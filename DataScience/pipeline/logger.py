import sys
import json
import logging
from pathlib import Path
from datetime import datetime

sys.path.insert(0, str(Path(__file__).parent.parent))

from pipeline_config import LOG_FILE, AUDIT_FILE


def setup_logger():
    logger = logging.getLogger("pipeline")
    if logger.handlers:
        logger.handlers.clear()
    logger.setLevel(logging.DEBUG)
    fmt = logging.Formatter("%(asctime)s  %(levelname)-7s  %(message)s", datefmt="%H:%M:%S")
    console = logging.StreamHandler(sys.stdout)
    console.setLevel(logging.INFO)
    console.setFormatter(fmt)
    fh = logging.FileHandler(LOG_FILE, mode="w", encoding="utf-8")
    fh.setLevel(logging.DEBUG)
    fh.setFormatter(fmt)
    logger.addHandler(console)
    logger.addHandler(fh)
    return logger


log        = setup_logger()
_audit_log = {}


def record_audit(table, operation, rows_affected, detail=""):
    _audit_log.setdefault(table, []).append({
        "operation":     operation,
        "rows_affected": rows_affected,
        "detail":        detail,
        "timestamp":     datetime.now().isoformat(timespec="seconds"),
    })


def save_audit():
    with open(AUDIT_FILE, "w", encoding="utf-8") as f:
        json.dump(_audit_log, f, indent=2, default=str)
    log.info("Audit trail saved → %s", AUDIT_FILE.name)
