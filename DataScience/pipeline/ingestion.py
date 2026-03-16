import numpy as np
import pandas as pd

from pipeline_config import DATA_DIR, CSV_MAP, SCHEMAS
from pipeline.logger import log, record_audit


def detect_separator(path):
    with open(path, encoding="utf-8-sig", errors="ignore") as f:
        first_line = f.readline()
    return ";" if first_line.count(";") > first_line.count(",") else ","


def load_table(name):
    path = DATA_DIR / CSV_MAP[name]
    if not path.exists():
        raise FileNotFoundError(f"File not found: {path}")

    sep = detect_separator(path)
    df  = pd.read_csv(path, encoding="utf-8-sig", sep=sep)

    df.columns = [c.strip().lstrip("\ufeff") for c in df.columns]
    df = df.loc[:, ~df.columns.str.startswith("Unnamed")]
    df = df.loc[:, df.columns.str.strip() != ""]

    schema = SCHEMAS.get(name, {})
    for col, dtype_kind in schema.items():
        if col not in df.columns:
            continue
        try:
            if dtype_kind == "M":
                df[col] = pd.to_datetime(df[col], errors="coerce")
            elif dtype_kind in ("i", "f"):
                df[col] = pd.to_numeric(df[col], errors="coerce")
            elif dtype_kind == "b" and df[col].dtype == object:
                df[col] = df[col].map({"True": True, "False": False, True: True, False: False})
        except Exception as exc:
            log.warning("[%s] Could not cast %s: %s", name, col, exc)

    missing = set(schema) - set(df.columns)
    if missing:
        log.warning("[%s] Missing columns: %s", name, missing)

    log.info("[%s] Loaded %d rows × %d cols (sep='%s')", name, len(df), len(df.columns), sep)
    record_audit(name, "load", len(df))
    return df


def ingest_all():
    log.info("--- Stage 1: Ingestion ---")
    tables = {}
    for name in CSV_MAP:
        try:
            tables[name] = load_table(name)
        except FileNotFoundError as e:
            log.error("[%s] File not found — skipping: %s", name, e)
    if len(tables) < len(CSV_MAP):
        log.warning("Missing tables: %s", set(CSV_MAP) - set(tables))
    log.info("Loaded %d / %d tables", len(tables), len(CSV_MAP))
    return tables
