from pathlib import Path

BASE_DIR  = Path(__file__).parent.parent
DATA_DIR  = BASE_DIR / "data" / "raw"
OUTPUT_DIR = BASE_DIR / "pipeline_output"

EXPORT_CLEAN     = OUTPUT_DIR / "cleaned"
EXPORT_ML        = OUTPUT_DIR / "ml_ready"
EXPORT_ANALYTICS = OUTPUT_DIR / "analytics"
EXPORT_PARQUET   = OUTPUT_DIR / "parquet"
SCALER_DIR       = OUTPUT_DIR / "scalers"

LOG_FILE      = OUTPUT_DIR / "pipeline.log"
AUDIT_FILE    = OUTPUT_DIR / "audit_trail.json"
INSIGHTS_FILE = OUTPUT_DIR / "insights_summary.xlsx"

for _d in [OUTPUT_DIR, EXPORT_CLEAN, EXPORT_ML, EXPORT_ANALYTICS, EXPORT_PARQUET, SCALER_DIR]:
    _d.mkdir(parents=True, exist_ok=True)
