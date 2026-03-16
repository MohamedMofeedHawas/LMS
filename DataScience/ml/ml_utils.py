from pathlib import Path
import numpy as np
import pandas as pd

BASE_DIR     = Path(__file__).parent.parent
FEATURES_DIR = BASE_DIR / "pipeline_output" / "features"
OUT_DIR      = BASE_DIR / "pipeline_output" / "ml"
OUT_DIR.mkdir(parents=True, exist_ok=True)

LABEL_COLS   = {"Dropout", "AtRisk", "HighPerformer", "CompositeScore", "StudentId"}

LEAKAGE_MAP = {
    "Dropout":       {"CompletionRate", "ActivitiesCompleted", "AbandonRate",
                      "RemainingActivities", "LearningVelocity", "AvgProgressPct"},
    "AtRisk":        {"CompletionRate", "ActivitiesCompleted", "AbandonRate",
                      "RemainingActivities", "LearningVelocity", "AvgProgressPct"},
    "HighPerformer": {"AvgScore", "PassRate", "MinScore", "ScoreStd",
                      "FailureRatio", "AvgAttemptsPerQuiz", "AvgAttemptsBeforeSuccess",
                      "DifficultyExposure"},
}


def load_features() -> pd.DataFrame:
    path = FEATURES_DIR / "student_features.csv"
    if not path.exists():
        raise FileNotFoundError(f"Run build_features.py first: {path}")
    return pd.read_csv(path, low_memory=False)


def get_X_y(df: pd.DataFrame, target: str) -> tuple:
    exclude = LABEL_COLS | LEAKAGE_MAP.get(target, set())
    feature_cols = [c for c in df.columns if c not in exclude]
    X = df[feature_cols].fillna(0).values
    y = df[target].values
    return X, y, feature_cols


def save(df: pd.DataFrame, name: str) -> None:
    if not df.empty:
        df.to_csv(OUT_DIR / f"{name}.csv", index=False)


def section(title: str) -> None:
    print(f"\n{'='*65}\n  {title}\n{'='*65}")
