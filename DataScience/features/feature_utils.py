from pathlib import Path
import pandas as pd
import numpy as np

BASE_DIR    = Path(__file__).parent.parent
CLEANED_DIR = BASE_DIR / "pipeline_output" / "cleaned"
OUT_DIR     = BASE_DIR / "pipeline_output" / "features"
OUT_DIR.mkdir(parents=True, exist_ok=True)


def load(name: str) -> pd.DataFrame:
    for suffix in (f"{name}_clean.csv", f"{name}.csv"):
        p = CLEANED_DIR / suffix
        if p.exists():
            return pd.read_csv(p, low_memory=False)
    return pd.DataFrame()


def parse_dates(df: pd.DataFrame, cols: list) -> pd.DataFrame:
    for c in cols:
        if c in df.columns:
            df[c] = pd.to_datetime(df[c], errors="coerce")
    return df


def safe_divide(a, b, fill=0.0):
    return np.where(b > 0, a / b, fill)


def normalize_minmax(series: pd.Series) -> pd.Series:
    mn, mx = series.min(), series.max()
    if mx == mn:
        return pd.Series(0.0, index=series.index)
    return (series - mn) / (mx - mn)


def save(df: pd.DataFrame, name: str) -> None:
    path = OUT_DIR / f"{name}.csv"
    df.to_csv(path, index=False)
    print(f"  Saved {name}.csv  ({len(df):,} rows × {len(df.columns)} cols)")
