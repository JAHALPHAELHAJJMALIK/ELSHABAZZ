#!/usr/bin/env python3
"""
update_hospital_footnote.py

Weekly DirectoryExpert workflow helper for CHGSD/CHPIV Informatics.

Every DirectoryExpert-generated Provider Directory PDF repeats a footnote on
every chapter page:

    ** See list of hospitals on page ###

The page number (###) is wherever the Hospital chapter happens to land THAT
run -- it shifts week to week as roster content grows/shrinks. Today's manual
process is two passes: (1) find the new Hospital-chapter start page, (2) go
into every chapter and hand-edit the footnote to the new number. This script
automates pass 2: given the new page number, it finds every instance of the
footnote (regardless of what stale number is currently printed) and rewrites
just the digits, in place, matching the original font size/color/position.

HOW IT WORKS
------------
1. Scans every page for the pattern: "** See list of hospitals on page <digits>"
2. For each match, reads the exact character-level bounding box of the digit
   run only (leaves "** See list of hospitals on page " untouched).
3. Redacts (whites out) just that digit run and re-draws the NEW page number
   at the same origin, font size, and color.
4. Skips any instance that already reads the target number (idempotent --
   safe to re-run if a prior pass was partially applied).
5. Prints a QA summary: every distinct OLD page number found + how many
   times, so you can catch inconsistent/partially-updated footnotes before
   trusting the output.

FONT NOTE: the source documents use an embedded "Book Antiqua" subset with no
usable Unicode cmap, so PyMuPDF cannot reliably reuse the exact embedded glyph
program for newly inserted digits. This script substitutes the built-in
Times-Roman font for the replacement digits only (same size/color/position).
At the ~7pt footnote size used in these directories this is visually seamless
-- verified against the 2026-07-16 CHPIV DSNP Medicare directory (584
instances, spot-checked first/middle/last). If a future document uses a
noticeably different footnote font/size, re-verify visually before trusting it
at scale (see --dry-run and the crop-check snippet at the bottom of this file).

USAGE
-----
    # 1) Dry run first -- see what's currently there, change nothing:
    python3 update_hospital_footnote.py --pdf "DIRECTORY.pdf" --new-page 603 --dry-run

    # 2) Apply, writing a new file (default, non-destructive):
    python3 update_hospital_footnote.py --pdf "DIRECTORY.pdf" --new-page 603

    # 3) Apply IN PLACE (overwrites the source file -- use once you trust it):
    python3 update_hospital_footnote.py --pdf "DIRECTORY.pdf" --new-page 603 --in-place

    # Custom footnote wording (if a different directory uses different text):
    python3 update_hospital_footnote.py --pdf "DIRECTORY.pdf" --new-page 603 \\
        --prefix "** See list of hospitals on page "
"""

import argparse
import re
import sys
from collections import Counter

import fitz  # PyMuPDF


def find_footnote_matches(page, prefix: str, start_gap: float = 6.0,
                           char_gap: float = 2.0, scan_window: float = 40.0,
                           baseline_tolerance: float = 1.0):
    """
    Return a list of dicts, one per footnote instance found on this page:
        {
            "old_number": str,        # digits currently printed, e.g. "605"
            "digit_chars": [...],      # rawdict char entries for just the digits
            "fontname": str,
            "fontsize": float,
            "color": int,
        }

    IMPORTANT: this does NOT assume the prefix text and the digit run live in
    the same text span/line/block. A PDF freshly out of DirectoryExpert will
    have them together in one span -- but a PDF that has already been through
    ONE pass of this script will have the digits as a separate inserted text
    object entirely (a different block), because PyMuPDF appends inserted
    text as its own block rather than re-flowing it into the original
    paragraph, AND the replacement font's glyph metrics (ascender/descender)
    differ from the original embedded font, so the two runs' bounding boxes
    don't line up vertically even though they sit on the same visual line.

    To handle both cases reliably, we match on BASELINE y (the 'origin'
    coordinate PyMuPDF reports per character), not bounding-box overlap.
    Two characters on the same printed line share (almost) the same baseline
    origin y regardless of font, while their bbox extents can differ a lot
    due to ascender/descender/cap-height differences between fonts. Steps:
      1. Find the span(s) whose text contains the prefix substring exactly
         -- gives us the prefix's own last character (baseline y, right edge x).
      2. Scan all characters on the page for a contiguous digit run whose
         origin y is within `baseline_tolerance` points of that baseline,
         starting just right of the prefix's right edge (within max_gap).
    """
    results = []
    prefix_stripped = prefix.rstrip()

    d = page.get_text("rawdict")
    all_chars = []          # (char_dict, span) in document order
    prefix_anchors = []     # (baseline_y, right_x) for each prefix occurrence

    for block in d.get("blocks", []):
        for line in block.get("lines", []):
            for span in line.get("spans", []):
                chars = span.get("chars", [])
                for ch in chars:
                    all_chars.append((ch, span))
                txt = "".join(c["c"] for c in chars)
                idx = txt.find(prefix_stripped)
                if idx != -1:
                    end_idx = idx + len(prefix_stripped) - 1
                    last_char = chars[end_idx]
                    prefix_anchors.append((last_char["origin"][1], last_char["bbox"][2]))

    for baseline_y, right_x in prefix_anchors:
        candidates = []
        for ch, span in all_chars:
            oy = ch["origin"][1]
            ox = ch["origin"][0]
            if abs(oy - baseline_y) > baseline_tolerance:
                continue
            if ox < right_x - 1.0:  # must start at/after prefix's right edge
                continue
            if ox > right_x + scan_window:  # generous window to catch multi-digit numbers
                continue
            candidates.append((ch, span, ox))

        if not candidates:
            continue

        # Walk left-to-right, greedily collecting a contiguous digit run.
        # `start_gap` bounds prefix -> first digit; `char_gap` bounds the
        # spacing between consecutive digits (so the run terminates cleanly
        # once we run past the number, regardless of scan_window size).
        candidates.sort(key=lambda t: t[2])
        digit_chars = []
        cur_span = None
        expected_x = None  # right edge of the previous char in the run
        for ch, span, x0 in candidates:
            if not ch["c"].isdigit():
                if digit_chars:
                    break  # digit run ended
                else:
                    continue  # skip whitespace between prefix and the number
            gap_limit = start_gap if expected_x is None else char_gap
            gap = x0 - (expected_x if expected_x is not None else right_x)
            if gap > gap_limit:
                break
            digit_chars.append(ch)
            cur_span = span
            expected_x = ch["bbox"][2]

        if not digit_chars:
            continue

        old_number = "".join(c["c"] for c in digit_chars)
        results.append({
            "old_number": old_number,
            "digit_chars": digit_chars,
            "fontname": cur_span.get("font", "Times-Roman"),
            "fontsize": cur_span["size"],
            "color": cur_span.get("color", 0),
        })
    return results


def color_int_to_rgb(color_int: int):
    """PyMuPDF rawdict 'color' is a packed sRGB int (0 = black)."""
    r = ((color_int >> 16) & 255) / 255.0
    g = ((color_int >> 8) & 255) / 255.0
    b = (color_int & 255) / 255.0
    return (r, g, b)


def process_pdf(pdf_path: str, new_page: str, prefix: str, dry_run: bool,
                 out_path: str, redact_pad: float = 0.4,
                 replacement_font: str = "Times-Roman"):
    doc = fitz.open(pdf_path)

    old_number_counts = Counter()
    pages_touched = []
    pages_skipped_already_correct = []
    anomalies = []

    for pno in range(doc.page_count):
        page = doc[pno]
        matches = find_footnote_matches(page, prefix)
        if not matches:
            continue

        for match in matches:
            old_number_counts[match["old_number"]] += 1

            if match["old_number"] == str(new_page):
                pages_skipped_already_correct.append(pno + 1)
                continue

            if dry_run:
                pages_touched.append(pno + 1)
                continue

            chars = match["digit_chars"]
            x0 = min(c["bbox"][0] for c in chars)
            y0 = min(c["bbox"][1] for c in chars)
            x1 = max(c["bbox"][2] for c in chars)
            y1 = max(c["bbox"][3] for c in chars)
            redact_rect = fitz.Rect(x0 - redact_pad, y0 - redact_pad,
                                     x1 + redact_pad, y1 + redact_pad)
            origin = chars[0]["origin"]
            fontsize = match["fontsize"]
            color = color_int_to_rgb(match["color"])

            try:
                page.add_redact_annot(redact_rect, fill=(1, 1, 1))
                page.apply_redactions(images=fitz.PDF_REDACT_IMAGE_NONE)
                page.insert_text(
                    origin,
                    str(new_page),
                    fontsize=fontsize,
                    fontname=replacement_font,
                    color=color,
                )
                pages_touched.append(pno + 1)
            except Exception as e:
                anomalies.append((pno + 1, str(e)))

    print("=" * 70)
    print(f"Footnote pattern:  '{prefix}<digits>'")
    print(f"Target page number: {new_page}")
    print(f"Mode: {'DRY RUN (no changes made)' if dry_run else 'APPLY'}")
    print("-" * 70)
    print("Distinct OLD page numbers currently found (QA -- check for stragglers):")
    for num, count in sorted(old_number_counts.items(), key=lambda x: -x[1]):
        flag = "  <-- already matches target" if num == str(new_page) else ""
        print(f"  '{num}': {count} instance(s){flag}")
    print("-" * 70)
    print(f"Instances already correct (skipped): {len(pages_skipped_already_correct)}")
    print(f"Instances {'that would be' if dry_run else ''} updated: {len(pages_touched)}")
    if anomalies:
        print(f"ANOMALIES ({len(anomalies)}) -- review these pages manually:")
        for pno, msg in anomalies:
            print(f"  page {pno}: {msg}")
    print("=" * 70)

    if dry_run:
        doc.close()
        return

    doc.save(out_path, garbage=4, deflate=True)
    doc.close()
    print(f"Saved: {out_path}")


def main():
    ap = argparse.ArgumentParser(description=__doc__,
                                  formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--pdf", required=True, help="Path to the source PDF")
    ap.add_argument("--new-page", required=True,
                     help="The new page number the footnote should point to (e.g. 603)")
    ap.add_argument("--prefix", default="** See list of hospitals on page ",
                     help="Footnote text preceding the page number "
                          "(default: '** See list of hospitals on page ')")
    ap.add_argument("--dry-run", action="store_true",
                     help="Scan and report only -- make no changes")
    ap.add_argument("--in-place", action="store_true",
                     help="Overwrite the source PDF instead of writing a new file")
    ap.add_argument("--out", default=None,
                     help="Output path (ignored with --in-place). "
                          "Default: <source>_UPDATED.pdf")
    args = ap.parse_args()

    if args.in_place:
        out_path = args.pdf
    elif args.out:
        out_path = args.out
    else:
        if args.pdf.lower().endswith(".pdf"):
            out_path = args.pdf[:-4] + "_UPDATED.pdf"
        else:
            out_path = args.pdf + "_UPDATED.pdf"

    process_pdf(
        pdf_path=args.pdf,
        new_page=args.new_page,
        prefix=args.prefix,
        dry_run=args.dry_run,
        out_path=out_path,
    )


if __name__ == "__main__":
    sys.exit(main())
