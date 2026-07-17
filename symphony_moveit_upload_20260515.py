"""
================================================================================
SYMPHONY_MOVEIT_UPLOAD.PY
================================================================================
PURPOSE  : Resolves the most-current SYMPHONY dat folder, selects the latest
           vintage per file-type prefix, creates a dated CHG ZIP archive in the
           STAGING folder, self-heals the MOVEit Automation Task source path
           and file filter on first run, then triggers the Task.  Fails loudly
           via SSA non-zero exit so the existing Database Mail notification chain
           fires on any error.

PIPELINE :
  SQLPROD02  |  SSA Job: "Symphony dat File Upload"
             |  Step 0 (NEW)  : symphony_moveit_upload.py   <-- THIS SCRIPT
             |  Step 1-13     : existing SSIS CHGSD_*.dtsx packages (unchanged)

SCHEDULE : Schedule 7988  (1st  Friday, 12:01 AM)
           Schedule 7989  (3rd  Friday, 12:11 AM)

DEPLOY   : \\netapp02\IS\Informatics\_Informatics Deliverables\Operations\Projects\SYMPHONY\

AUTHOR   : Informatics / El Hajj Malik Jahwaca
STANDARD : DUB C 2.0
--------------------------------------------------------------------------------
CHANGE LOG
  C001  2026-05-15  Initial build.  Dynamic folder resolution, latest-vintage
                    selection, MOVEit REST API path-patch with graceful fallback.
  C002  2026-05-15  ZIP workflow: creates YYYYMMDD_CHG.zip in STAGING folder.
                    STAGING auto-created on first run.  Old ZIPs purged before
                    new one is written.  MOVEit Task self-heals source path and
                    file filter to STAGING / *_CHG.zip on first run via REST API.
================================================================================
"""

import sys
import logging
import zipfile
import requests
import configparser
from datetime import datetime
from pathlib import Path


# ============================================================
# CONFIG
# ============================================================

CONFIG_PATH = Path(__file__).parent / "symphony_moveit_upload.ini"

MONTH_NAMES = {
    1: "January",  2: "February", 3: "March",    4: "April",
    5: "May",      6: "June",     7: "July",      8: "August",
    9: "September",10: "October", 11: "November", 12: "December",
}

EXPECTED_PREFIXES = [
    "CHGSD_ADDRESS",
    "CHGSD_BED_DETAIL",
    "CHGSD_CONTACT",
    "CHGSD_ENTITY",
    "CHGSD_HOSPITAL",
    "CHGSD_HOURS",
    "CHGSD_IDENTIFIER",
    "CHGSD_LANGUAGE",
    "CHGSD_LOCATION",
    "CHGSD_NETWORK",
    "CHGSD_ROSTER",
    "CHGSD_TAXONOMY",
]

STAGING_FILTER = "*_CHG.zip"


# ============================================================
# LOGGING  (stdout captured by SSA job history)
# ============================================================

logging.basicConfig(
    level    = logging.INFO,
    format   = "%(asctime)s  [%(levelname)s]  %(message)s",
    datefmt  = "%Y-%m-%d %H:%M:%S",
    handlers = [logging.StreamHandler(sys.stdout)],
)
LOG = logging.getLogger("symphony_moveit")


# ============================================================
# HELPERS — FILE SYSTEM
# ============================================================

def load_config() -> configparser.ConfigParser:
    if not CONFIG_PATH.exists():
        LOG.error("Config file not found: %s", CONFIG_PATH)
        sys.exit(1)
    cfg = configparser.ConfigParser()
    cfg.read(CONFIG_PATH)
    return cfg


def resolve_current_folder(root_unc: str) -> Path:
    """
    Derive the most-current SYMPHONY sub-folder from today's date.
    Convention: {ROOT}\\{YYYY}\\{YYYY}_{MonthName}\\
    Falls back to scanning for the newest month dir if expected folder
    does not yet exist (e.g. new month folder created mid-month).
    """
    today      = datetime.now()
    year_str   = str(today.year)
    month_name = MONTH_NAMES[today.month]
    expected   = Path(root_unc) / year_str / f"{year_str}_{month_name}"

    if expected.exists():
        LOG.info("Resolved current folder (date-based): %s", expected)
        return expected

    LOG.warning(
        "Expected folder not found: %s  --  scanning for most-recent month folder",
        expected,
    )
    root       = Path(root_unc)
    candidates = []
    for year_dir in sorted(root.iterdir(), reverse=True):
        if not year_dir.is_dir() or not year_dir.name.isdigit():
            continue
        for month_dir in sorted(year_dir.iterdir(), reverse=True):
            if month_dir.is_dir():
                candidates.append(month_dir)
        if candidates:
            break

    if not candidates:
        LOG.error("No valid year/month sub-folders found under ROOT: %s", root_unc)
        sys.exit(1)

    fallback = candidates[0]
    LOG.warning("Fallback folder selected: %s", fallback)
    return fallback


def select_latest_per_prefix(folder: Path) -> dict:
    """
    For each CHGSD_* prefix select the single most-recently modified .dat file.
    Returns dict keyed by prefix, value = winning Path.
    Exits non-zero if any expected prefix has zero candidates.
    """
    dat_files = list(folder.glob("*.dat"))
    LOG.info("Total .dat files found in folder: %d", len(dat_files))

    selection = {}
    missing   = []

    for prefix in EXPECTED_PREFIXES:
        candidates = [
            f for f in dat_files
            if f.name.upper().startswith(prefix.upper())
        ]
        if not candidates:
            missing.append(prefix)
            continue
        winner = max(candidates, key=lambda f: (f.stat().st_mtime, f.name))
        selection[prefix] = winner
        LOG.info("  %-25s  -->  %s", prefix, winner.name)

    if missing:
        LOG.error(
            "Missing .dat files for %d prefix(es): %s",
            len(missing), ", ".join(missing),
        )
        sys.exit(1)

    LOG.info("Latest-vintage selection complete: %d files identified", len(selection))
    return selection


def ensure_staging(staging_unc: str) -> Path:
    """Create STAGING folder if it does not yet exist.  Exits on permission failure."""
    staging = Path(staging_unc)
    if not staging.exists():
        LOG.info("STAGING folder not found — creating: %s", staging)
        try:
            staging.mkdir(parents=True, exist_ok=True)
            LOG.info("STAGING folder created successfully")
        except OSError as exc:
            LOG.error("Failed to create STAGING folder: %s", exc)
            sys.exit(1)
    else:
        LOG.info("STAGING folder verified: %s", staging)
    return staging


def purge_old_zips(staging: Path) -> None:
    """Remove any prior-run *_CHG.zip from STAGING so MOVEit always sees exactly one file."""
    old_zips = list(staging.glob("*_CHG.zip"))
    for z in old_zips:
        try:
            z.unlink()
            LOG.info("Purged old ZIP: %s", z.name)
        except OSError as exc:
            LOG.error("Failed to delete old ZIP %s: %s", z.name, exc)
            sys.exit(1)


def create_zip(staging: Path, selected_files: dict) -> Path:
    """Create YYYYMMDD_CHG.zip in STAGING containing all 12 selected .dat files."""
    zip_name = datetime.now().strftime("%Y%m%d") + "_CHG.zip"
    zip_path = staging / zip_name
    LOG.info("Creating ZIP: %s", zip_path)
    try:
        with zipfile.ZipFile(zip_path, "w", compression=zipfile.ZIP_DEFLATED) as zf:
            for prefix, file_path in selected_files.items():
                zf.write(file_path, arcname=file_path.name)
                LOG.info(
                    "  + %-45s  (%s KB)",
                    file_path.name,
                    round(file_path.stat().st_size / 1024, 1),
                )
        size_kb = round(zip_path.stat().st_size / 1024, 1)
        LOG.info("ZIP created: %s  (%s KB total)", zip_name, size_kb)
        return zip_path
    except (OSError, zipfile.BadZipFile) as exc:
        LOG.error("Failed to create ZIP: %s", exc)
        sys.exit(1)


# ============================================================
# MOVEIT REST API
# ============================================================

class MOVEitClient:
    """
    Thin wrapper around the MOVEit Automation REST API v1.

    Auth flow    : POST /api/v1/token          --> bearer token
    Self-heal    : GET  /api/v1/tasks/{id}     --> read source config
                   PUT  /api/v1/tasks/{id}     --> patch source path + filter
    Task trigger : POST /api/v1/tasks/{id}/run
    """

    def __init__(self, base_url: str, username: str, password: str):
        self.base_url = base_url.rstrip("/")
        self.username = username
        self.password = password
        self.token    = None
        self.session  = requests.Session()
        self.session.verify = False  # devops01 uses a self-signed cert
        import urllib3
        urllib3.disable_warnings(urllib3.exceptions.InsecureRequestWarning)

    def authenticate(self) -> bool:
        url     = f"{self.base_url}/api/v1/token"
        payload = {
            "grant_type" : "password",
            "username"   : self.username,
            "password"   : self.password,
        }
        try:
            resp = self.session.post(url, data=payload, timeout=30)
            resp.raise_for_status()
            self.token = resp.json().get("access_token")
            if not self.token:
                LOG.warning("MOVEit auth response missing access_token: %s", resp.text)
                return False
            self.session.headers.update({"Authorization": f"Bearer {self.token}"})
            LOG.info("MOVEit REST API authenticated successfully")
            return True
        except requests.RequestException as exc:
            LOG.warning("MOVEit REST API auth failed: %s", exc)
            return False

    def get_task_id(self, task_name: str) -> "str | None":
        url = f"{self.base_url}/api/v1/tasks"
        try:
            resp  = self.session.get(url, timeout=30)
            resp.raise_for_status()
            tasks = resp.json().get("items", [])
            for task in tasks:
                if task.get("name", "").strip().lower() == task_name.strip().lower():
                    LOG.info("MOVEit Task found: '%s'  ID=%s", task_name, task["id"])
                    return str(task["id"])
            LOG.warning("MOVEit Task not found by name: '%s'", task_name)
            return None
        except requests.RequestException as exc:
            LOG.warning("MOVEit Task lookup failed: %s", exc)
            return None

    def _get_task_source(self, task_id: str) -> "dict | None":
        url = f"{self.base_url}/api/v1/tasks/{task_id}"
        try:
            resp = self.session.get(url, timeout=30)
            resp.raise_for_status()
            return resp.json().get("source", {})
        except requests.RequestException as exc:
            LOG.warning("MOVEit Task GET (source read) failed: %s", exc)
            return None

    def self_heal_source(self, task_id: str, staging_unc: str) -> bool:
        """
        Compare the Task's current source path and file filter against the STAGING
        target.  Issues a PUT only when a change is needed — idempotent on every
        subsequent run once the task is already pointing at STAGING.
        """
        current_source = self._get_task_source(task_id)
        if current_source is None:
            LOG.warning("Could not read current Task source — skipping self-heal")
            return False

        # Normalise for comparison (strip trailing backslash, case-insensitive)
        current_path   = current_source.get("path", "").rstrip("\\").lower()
        target_path    = staging_unc.rstrip("\\").lower()

        file_specs     = current_source.get("fileSpecs") or []
        current_filter = file_specs[0].get("pattern", "") if file_specs else ""

        needs_patch = (current_path != target_path) or (current_filter != STAGING_FILTER)

        if not needs_patch:
            LOG.info(
                "MOVEit Task source already points to STAGING with filter '%s' — no patch needed",
                STAGING_FILTER,
            )
            return True

        LOG.info("MOVEit Task source mismatch detected — self-healing:")
        LOG.info("  Path   : '%s'  -->  '%s'", current_path, staging_unc)
        LOG.info("  Filter : '%s'  -->  '%s'", current_filter, STAGING_FILTER)

        url     = f"{self.base_url}/api/v1/tasks/{task_id}"
        payload = {
            "source": {
                "path"      : staging_unc,
                "fileSpecs" : [{"pattern": STAGING_FILTER}],
            }
        }
        try:
            resp = self.session.put(url, json=payload, timeout=30)
            if resp.status_code in (200, 204):
                LOG.info("MOVEit Task source self-healed successfully")
                return True
            LOG.warning(
                "MOVEit API self-heal returned HTTP %d: %s",
                resp.status_code, resp.text[:300],
            )
            return False
        except requests.RequestException as exc:
            LOG.warning("MOVEit API self-heal request failed: %s", exc)
            return False

    def trigger_task(self, task_id: str) -> bool:
        url = f"{self.base_url}/api/v1/tasks/{task_id}/run"
        try:
            resp = self.session.post(url, timeout=30)
            if resp.status_code in (200, 202, 204):
                LOG.info("MOVEit Task triggered successfully (Task ID=%s)", task_id)
                return True
            LOG.warning(
                "MOVEit Task trigger returned HTTP %d: %s",
                resp.status_code, resp.text[:300],
            )
            return False
        except requests.RequestException as exc:
            LOG.warning("MOVEit Task trigger request failed: %s", exc)
            return False

    def logout(self):
        if not self.token:
            return
        try:
            self.session.delete(f"{self.base_url}/api/v1/token", timeout=10)
        except requests.RequestException:
            pass


# ============================================================
# MANUAL FALLBACK ALERT
# ============================================================

def emit_fallback_alert(staging: Path, zip_path: Path, reason: str) -> None:
    """
    Emits a structured block to stdout (captured in SSA job history) so the
    operator has everything needed to manually trigger the MOVEit Task.
    SSA step still exits 0 — the ZIP is staged and ready; only the API call
    failed.  SSIS steps will still run normally.
    """
    LOG.warning("=" * 72)
    LOG.warning("MANUAL ACTION REQUIRED — MOVEit Task NOT auto-triggered")
    LOG.warning("=" * 72)
    LOG.warning("Reason      : %s", reason)
    LOG.warning("MOVEit URL  : https://devops01/#/log  -->  Tasks  -->  Symphony dat File Upload")
    LOG.warning("Action      : Verify source path = %s", staging)
    LOG.warning("              Verify file filter  = %s", STAGING_FILTER)
    LOG.warning("              Run task manually if not triggered by schedule")
    LOG.warning("ZIP staged  : %s", zip_path)
    LOG.warning("=" * 72)


# ============================================================
# MAIN
# ============================================================

def main():
    LOG.info("=" * 72)
    LOG.info(
        "SYMPHONY MOVEIT UPLOAD  --  Pre-flight  --  %s",
        datetime.now().strftime("%Y-%m-%d %H:%M:%S"),
    )
    LOG.info("=" * 72)

    # 1. Load config
    cfg = load_config()

    root_unc    = cfg.get("paths",  "root_unc")
    staging_unc = cfg.get("paths",  "staging_unc")
    moveit_url  = cfg.get("moveit", "base_url")
    moveit_user = cfg.get("moveit", "username")
    moveit_pass = cfg.get("moveit", "password")
    moveit_task = cfg.get("moveit", "task_name")

    LOG.info("ROOT UNC    : %s", root_unc)
    LOG.info("STAGING UNC : %s", staging_unc)
    LOG.info("MOVEit URL  : %s", moveit_url)
    LOG.info("MOVEit Task : %s", moveit_task)

    # 2. Resolve current month folder
    source_folder = resolve_current_folder(root_unc)

    # 3. Select latest vintage per prefix (12 files)
    selected_files = select_latest_per_prefix(source_folder)

    # 4. Ensure STAGING exists (creates on first run)
    staging = ensure_staging(staging_unc)

    # 5. Purge prior-run ZIP from STAGING
    purge_old_zips(staging)

    # 6. Create YYYYMMDD_CHG.zip in STAGING
    zip_path = create_zip(staging, selected_files)

    # 7. MOVEit REST API: authenticate
    client     = MOVEitClient(moveit_url, moveit_user, moveit_pass)
    api_ok     = client.authenticate()
    api_reason = None

    if not api_ok:
        api_reason = "MOVEit REST API authentication failed"

    # 8. Locate Task by name
    task_id = None
    if api_ok:
        task_id = client.get_task_id(moveit_task)
        if not task_id:
            api_ok     = False
            api_reason = f"MOVEit Task not found by name: '{moveit_task}'"

    # 9. Self-heal source path + filter (idempotent — no-op after first run)
    heal_ok = False
    if api_ok and task_id:
        heal_ok = client.self_heal_source(task_id, staging_unc)
        if not heal_ok:
            api_reason = (
                "MOVEit REST API source self-heal failed.  "
                "Manually set Task source to STAGING and filter to *_CHG.zip, "
                "then trigger the Task."
            )

    # 10. Trigger Task (only if self-heal succeeded or was already correct)
    if heal_ok and task_id:
        triggered = client.trigger_task(task_id)
        if not triggered:
            LOG.warning(
                "MOVEit Task could not be triggered via API — "
                "it will run on its configured schedule.  ZIP is staged and ready."
            )
    else:
        emit_fallback_alert(staging, zip_path, api_reason or "API unavailable")

    client.logout()

    # 11. Final manifest (always emitted for SSA job history audit)
    LOG.info("-" * 72)
    LOG.info("PRE-FLIGHT MANIFEST")
    LOG.info("Source Folder : %s", source_folder)
    LOG.info("ZIP staged    : %s  (%s KB)", zip_path.name, round(zip_path.stat().st_size / 1024, 1))
    LOG.info("Files zipped  : %d", len(selected_files))
    for prefix, path in selected_files.items():
        LOG.info(
            "  %-25s  %s  (%s KB)",
            prefix, path.name, round(path.stat().st_size / 1024, 1),
        )
    LOG.info("-" * 72)
    LOG.info("Pre-flight complete.  Handing off to SSIS upload steps.")
    LOG.info("=" * 72)

    sys.exit(0)


if __name__ == "__main__":
    main()
