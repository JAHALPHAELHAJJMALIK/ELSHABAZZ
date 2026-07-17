---
name: contracting-rate-increase
description: "Use this skill whenever the user needs to modify an existing CHG contracting analysis SQL script for a new provider rate increase request. Triggers include: any combination of a .sql file and a rate increase request document (email, screenshot, or table), phrases like 'modify the existing script', 'update for [provider]', 'new contracting request', 'rate increase', 'contracting proposal', 'align with current request', 'replace the CASE blocks', or any reference to Contracting_Proposal_Category / Proposed_Rate_Payment. Also triggers when the user provides a 'governing skeleton' or screenshot of a contracting request table alongside a SQL template, or says things like 'contracting dept. request', 'DUBC2.0', 'target server SQLPROD02', 'rate increase request', or references CHG/QNXT contracting workflows. Use even if the user only pastes in part of the request — the full modification workflow handles everything from parameter extraction through output file creation."
---

# CHG Contracting Rate Increase — SQL Script Modifier

## Purpose

Modify an existing CHG/QNXT contracting analysis SQL script to align with a new provider rate increase request. The script follows a fixed template structure (pre-stage → CTE → staging table → UPDATE passes → summary queries). Only specific sections change per engagement; everything else carries forward unchanged.

**Target server:** SQLPROD02. All output SQL must conform to **DUB C 2.0** (see `references/dubc2_standards.md`).

---

## Inputs

1. **Existing SQL script** — the prior provider's version of the script (the template to modify)
2. **Rate increase request document** — email body, screenshot of the request table, or pasted text. This is the authoritative source for all parameter values.

If either is missing, ask before proceeding.

---

## Step 1 — Extract Parameters from the Request Document

Read the governing document and extract the following. All values must come directly from the document; never guess.

| Parameter | Source field in doc | Maps to |
|---|---|---|
| Provider name | Provider name / subject line | Staging table suffix, change log |
| TIN | Provider TIN | `#PROVISOLATION` filter comment |
| NPI | Provider NPI | `#PROVISOLATION` filter comment |
| DOS start | Date Range (start) | `@RangeStartDate` |
| DOS end | Date Range (end) | `@RangeEndDate` |
| Claims lag date | Claims Lag | `@CutoffDate` |
| Line of business | Line of Business field | Change log scope note, LOB-branch pattern (see below) |
| Service codes | Current/Proposed Rates rows | `Contracting_Proposal_Category` CASE (only when the request is code-specific) |
| Current rate(s) | Current Rates row | Change log only (history) |
| Proposed rate(s) | Proposed Rates row | `Proposed_Rate_Payment` CASE |
| Rate basis | Inferred from code type + unit + scope | CASE expression pattern (see below) |
| Change number | Next C### after last entry in log | Change log prefix |

**Rate basis inference — first decide CODE-SPECIFIC vs. BLANKET:**

- **Code-specific** (request doc names actual CPT/HCPCS/Rev codes, e.g. "T2033-U6", "S1040"): build the CASE blocks per code, using the patterns in Step 2d/2e below.
  - HCPCS/CPT + flat dollar amount → per-unit: `NULLIF(servunits, 0) * [amount].00`
  - Revenue code + per-diem dollar → per-diem: `NULLIF(servunits, 0) * [amount].00`
  - Modifier-qualified service (e.g. U6) → add OR chain across modcode1–modcode5
  - Percentage of fee schedule tied to specific codes (e.g. "CPT 43644: 120% Medicare Rate") → `NULLIF(ISNULL(EQUIV_allow_compare,0),0) * [decimal]` where decimal = pct / 100
- **Blanket % of fee schedule** (request doc gives only a percentage of Medicare/Medi-Cal fee schedule for the whole provider/specialty, with **no** CPT/HCPCS code list — e.g. "100% → 107% of Medicare Fee Schedule" for a Physical Therapy group): **do not wait on a code list.** `#PROVISOLATION` already scopes every line to this TIN/NPI, so the rate applies to everything that comes through — use the **LOB-branch pattern** in Step 2d/2e instead of a CPT-branch pattern. This is the correct default for any "X% of fee schedule" request that doesn't name specific codes.

If anything else is ambiguous (multiple codes with unclear scope, unclear modifier logic, a code-specific request missing its code list), confirm with the user before writing SQL — don't fabricate codes.

---

## Step 2 — Apply Changes to the SQL Script

Make **only** the changes below. Do not alter CTEs, UPDATE passes, fee schedule logic, or summary queries.

### 2a. Change Log Entry

Add a new `C###` entry immediately after the last entry in the change log. Use this format:

```sql
-- C###: [PROVIDER NAME CAPS] [YYYYMMDD] -- REPLACED Contracting_Proposal_Category AND Proposed_Rate_Payment CASE BLOCKS
       /* Per [requester name/title] contracting request [request date] -- [LOB] only -- [rate basis description]
       [CODE] [Service description]: current [current rate] -> proposed [proposed rate] ([variance, e.g. +$200 per unit])
       ELSE = 0 ([provider type] -- hard stop per corpus standard)
       Provider TIN: [TIN] | NPI: [NPI] | DOS: [start] - [end] | Claims lag: no earlier than [lag date] */
```

### 2b. Date Parameters

Hardcode the dates from the request. Retain the old dynamic lines commented out above them for rollback/audit:

```sql
-- C###: [PROVIDER] -- DOS RANGE HARDCODED PER CONTRACTING REQUEST [date] -- [start] THROUGH [end]
SET @RangeStartDate = '[YYYY-MM-DD]' -- [PROVIDER]: DATE RANGE FROM REQUEST DOC ([M/DD/YYYY])
SET @RangeEndDate   = '[YYYY-MM-DD]' -- [PROVIDER]: DATE RANGE FROM REQUEST DOC ([M/DD/YYYY])
SET @CutoffDate     = '[YYYY-MM-DD]' -- [PROVIDER]: CLAIMS LAG -- NO EARLIER THAN [lag date]
```

Comment out the old dynamic SET lines directly above with a note; do not delete them.

### 2c. Staging Table Rename

Replace **all** occurrences of the old provider's staging table name with the new one:

1. First: `CONTRACTING_[OLD]_TEMPLATE_DETAIL` → `CONTRACTING_[NEW]_TEMPLATE_DETAIL` (longer string first)
2. Then: `CONTRACTING_[OLD]` → `CONTRACTING_[NEW]`

Table suffix naming: uppercase, underscores for spaces, drop punctuation. Examples: `HANGER`, `INTERFAITH_COMMUNITY_SERVICES`, `ELLNER_BARIATRIC`.

Also update the provider comment in the `#PROVISOLATION` block:
```sql
AND -- C###: Rate Increase Request -- [PROVIDER] ([specialty/type]) -- TIN: [TIN] NPI: [NPI]
```

Use Python + bash to do bulk replacement (sed in-place fails on the mounted output folder due to permissions):
```python
# /tmp/working.sql → apply replacements → /tmp/modified.sql → write to outputs
```

### 2d. Contracting_Proposal_Category CASE Block

Which pattern to use depends on the rate basis decided in Step 1.

**Pattern A — Code-specific request.** Replace the block entirely. Only build WHEN branches directly supported by the current request documentation. Comment out (do not delete) the old branches.

```sql
,CASE -- C###: [PROVIDER] [YYYYMMDD] -- REPLACES [PRIOR PROVIDER] CASE BLOCK -- [LOB] only -- [rate basis]
WHEN UPPER(LTRIM(RTRIM(ISNULL([CPT Service Code], '')))) IN ('[CODE]') -- [desc] ([CODE] current [rate] -> proposed [rate])
[AND modifier block if applicable]
THEN CAST('[Category Label]' AS nvarchar(255))
-- WHEN ... -- NO ADDITIONAL BRANCHES SUPPORTED BY CURRENT CONTRACTING REQUEST DOCUMENTATION
ELSE CAST('Other Services' AS nvarchar(255)) -- services outside [scope] -- default catch-all per corpus standard
END AS 'Contracting_Proposal_Category'
```

**Modifier block** (only when request doc specifies modifier qualifications):
```sql
    AND
    ( -- INITIATE ...
    modcode  = '[MOD]'
        OR modcode2 = '[MOD]'
        OR modcode3 = '[MOD]'
        OR modcode4 = '[MOD]'
        OR modcode5 = '[MOD]'
        ) -- CONCLUDE ...
```

Multiple service codes → separate WHEN branches, one per code.

**Pattern B — Blanket % of fee schedule (no code list).** Every line already isolated by `#PROVISOLATION` belongs to the same proposal, so there's nothing to branch on — collapse the category to a single label instead of leaving it at the default catch-all:

```sql
,CASE -- C###: [PROVIDER] [YYYYMMDD] -- [rate basis], e.g. blanket % of Medicare Fee Schedule -- [LOB(s)]
WHEN 1=1
THEN CAST('[Specialty/Provider] Services' AS nvarchar(255)) -- e.g. 'Specialty Services' — every line for this TIN/NPI is in scope, no code-level split needed
ELSE CAST('Other Services' AS nvarchar(255)) -- default catch-all per corpus standard (unreachable given WHEN 1=1, retained for pattern consistency)
END AS 'Contracting_Proposal_Category'
```

### 2e. Proposed_Rate_Payment CASE Block

**Pattern A — Code-specific request.** Replace the block entirely, mirroring the same WHEN conditions as the category block:

```sql
,CASE -- C###: [PROVIDER] [YYYYMMDD] -- REPLACES [PRIOR PROVIDER] CASE BLOCK -- [rate description] -- [LOB] only
WHEN UPPER(LTRIM(RTRIM(ISNULL([CPT Service Code], '')))) IN ('[CODE]') -- [desc]
[AND modifier block if applicable]
THEN [rate expression] -- DO THE MATH Fx [description] -- [LOB] only
-- WHEN ... -- NO ADDITIONAL BRANCHES SUPPORTED BY CURRENT CONTRACTING REQUEST DOCUMENTATION
ELSE 0 -- DEFAULT: [provider type] -- uncategorized lines are data anomaly -- hard stop per corpus standard
END AS 'Proposed_Rate_Payment'
```

**Rate expressions (Pattern A):**

| Basis | Expression |
|---|---|
| Per unit / per diem (fixed $) | `NULLIF(servunits, 0) * [amount].00` |
| % of EQUIV fee schedule, code-specific | `NULLIF(ISNULL(EQUIV_allow_compare,0),0) * [decimal]` |
| Case rate (flat, not per unit) | `[amount].00` |

**Pattern B — Blanket % of fee schedule (no code list, LOB-branch).** Branch on `LINE_OF_BUSINESS` instead of CPT code. Prefer `EQUIV_allow_compare` (the priced fee-schedule equivalent) and fall back to actual paid + TRI when EQUIV is unavailable (e.g. no matching fee table row). Close with a modest default bump rather than a hard `0`, since every line here is in scope by definition — a hard `0` on an unresolved LOB would silently zero out otherwise-valid proposal lines:

```sql
,CASE -- C###: [PROVIDER] [YYYYMMDD] -- [pct]% of Medicare/Medi-Cal Fee Schedule -- Medi-Cal AND Medicare LOB
WHEN LINE_OF_BUSINESS IN ('MEDI-CAL')
THEN ISNULL((NULLIF(EQUIV_allow_compare,0) * [decimal]),((NULLIF(PAID_NET_AMT,0)+ISNULL([TRI Payment],0)) * [decimal])) -- [pct]% of DYNAMIC Medi-Cal Fee Schedule
WHEN LINE_OF_BUSINESS IN ('DSNP','CSNP')
THEN ISNULL((NULLIF(EQUIV_allow_compare,0) * [decimal]),((NULLIF(PAID_NET_AMT,0)+ISNULL([TRI Payment],0)) * [decimal])) -- [pct]% of DYNAMIC Medicare Fee Schedule
-- ELSE 0 -- OPTION: hard stop for LOBs outside the request scope, if Contracting confirms this proposal should NOT apply beyond MEDI-CAL/DSNP/CSNP
ELSE (NULLIF(ISNULL(PAID_NET_AMT,0),0)+ISNULL([TRI Payment],0)) * 1.05 -- DEFAULT CATCH-ALL for any other/unresolved LOB -- ~5% increase built in rather than zeroing the line; confirm with Contracting whether this is the desired fallback for the specific request
END AS 'Proposed_Rate_Payment'
```

`[decimal]` = proposed pct / 100 (e.g. 107% → `1.07`, 110% → `1.10`). For multi-year step-up proposals (Y1/Y2/...), scaffold the additional years as commented-out `THEN` alternates under each WHEN branch, same as the per-diem step-up pattern, and confirm the effective/tier-change date with Contracting before activating anything past Y1.

Decision rule for A vs. B: if the request doc lists specific CPT/HCPCS/revenue codes with rates, use Pattern A. If the request doc gives only a percentage of a named fee schedule with no code list, use Pattern B — do not treat the missing code list as a blocker in that case.

---

## Step 3 — Write and Verify the Output File

**Filename:** `CONTRACTING_[PROVIDER]_[YYYYMMDD].sql`

Write via Python to avoid the sed permission issue on the mounted output folder. Note: the mounted `outputs` folder can also reject an in-place rewrite of a file it already wrote (even via Python) — if that happens, do all edits against a scratch copy (e.g. under `/tmp`) and copy the finished file into `outputs` under its final name in one shot rather than editing a file already sitting in `outputs`:
```python
with open('/tmp/modified.sql', 'r', encoding='utf-8') as f:
    content = f.read()
with open('/sessions/.../mnt/outputs/CONTRACTING_[PROVIDER]_[YYYYMMDD].sql', 'w', encoding='utf-8') as f:
    f.write(content)
```

**Verify before presenting:**
1. `grep -c 'CONTRACTING_[OLD]' output.sql` → must be 0 (the change log history entry uses the provider name string, not the table prefix, so it won't match)
2. New C### appears in change log ✓
3. `@RangeStartDate`, `@RangeEndDate`, `@CutoffDate` match the request doc exactly ✓
4. For Pattern B (blanket %): confirm the LOB values used (`MEDI-CAL`, `DSNP`, `CSNP`, etc.) actually match what's populated in `LINE_OF_BUSINESS` for this provider's claims, and confirm the default-catch-all fallback behavior (5% bump vs. hard 0) with Contracting if the request doc doesn't say what should happen to LOBs outside the named list ✓
5. DUB C 2.0 spot-check on all new additions: one space between tokens, left-aligned commas, uppercase keywords, explicit AS ✓

---

## DUB C 2.0 Quick Reference

See `references/dubc2_standards.md` for the full standard. The four rules most relevant to new additions:

1. **One space between all tokens** — no compressed `col1,col2`, no double spaces
2. **Left-aligned commas** — `,column_name` at start of line, never trailing
3. **Uppercase SQL keywords** — `SELECT`, `FROM`, `WHERE`, `CASE`, `WHEN`, `THEN`, `ELSE`, `END`, `AS`, `AND`, `OR`, `NOT`, `IN`, `NULL`, `UPDATE`, `SET`, `INTO`, `INNER JOIN`, `LEFT JOIN`, `DROP TABLE IF EXISTS`, etc.
4. **Explicit AS on all aliases** — `col AS [Alias]`, never `col [Alias]`
