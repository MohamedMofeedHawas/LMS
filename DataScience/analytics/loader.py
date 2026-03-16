import warnings
from pathlib import Path

import pandas as pd

warnings.filterwarnings("ignore")

BASE_DIR    = Path(__file__).parent.parent
CLEANED_DIR = BASE_DIR / "pipeline_output" / "cleaned"
OUT_DIR     = BASE_DIR / "pipeline_output" / "analysis"
SCHEMA_DIR  = OUT_DIR / "star_schema"

OUT_DIR.mkdir(parents=True, exist_ok=True)
SCHEMA_DIR.mkdir(parents=True, exist_ok=True)

INSIGHTS_FILE = OUT_DIR / "analysis_insights.xlsx"


def load(name: str, folder: Path = CLEANED_DIR) -> pd.DataFrame:
    for suffix in (f"{name}_clean.csv", f"{name}.csv"):
        p = folder / suffix
        if p.exists():
            df = pd.read_csv(p, low_memory=False)
            print(f"  ✓ {name:30s}  {len(df):>7,} rows  {len(df.columns):>3} cols")
            return df
    print(f"  ✗ {name} — not found")
    return pd.DataFrame()


def save(df: pd.DataFrame, name: str) -> None:
    if not df.empty:
        df.to_csv(OUT_DIR / f"{name}.csv", index=False)


def save_schema(df: pd.DataFrame, name: str) -> None:
    if not df.empty:
        df.to_csv(SCHEMA_DIR / f"{name}.csv", index=False)


def pct(part: float, total: float) -> float:
    return round(part / total * 100, 1) if total else 0.0


def section(title: str) -> None:
    print(f"\n{'='*65}\n  {title}\n{'='*65}")


def unique_sheet(role: str, name: str, seen: set) -> str:
    base = f"{role[:2]}_{name}"[:31]
    candidate, i = base, 2
    while candidate in seen:
        suffix = f"_{i}"
        candidate = base[: 31 - len(suffix)] + suffix
        i += 1
    seen.add(candidate)
    return candidate


def load_all() -> dict:
    section("0 · Loading data")

    tables = {}
    names = [
        "students", "users", "courses", "enrollments", "activities",
        "attempts", "submissions", "progress", "answers", "questions",
        "activity_log", "comments", "likes", "squadrons", "notifications",
        "engagement", "student_performance", "course_metrics",
    ]
    for name in names:
        tables[name] = load(name)

    datetime_cols = {
        "students":     ["CreatedAt", "UpdatedAt"],
        "users":        ["CreatedAt", "LastLoginAt"],
        "enrollments":  ["EnrollmentDate"],
        "attempts":     ["StartedAt", "SubmittedAt"],
        "submissions":  ["SubmittedAt", "GradedAt"],
        "progress":     ["FirstAccessedAt", "LastAccessedAt", "CompletedAt"],
        "activity_log": ["Timestamp"],
        "comments":     ["CreatedAt"],
        "activities":   ["CreatedAt", "DueDate"],
    }
    for tbl, cols in datetime_cols.items():
        df = tables.get(tbl, pd.DataFrame())
        for c in cols:
            if c in df.columns:
                df[c] = pd.to_datetime(df[c], errors="coerce")

    return tables
