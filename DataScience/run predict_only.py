import sys
import warnings
from pathlib import Path

sys.path.insert(0, str(Path(__file__).parent))
warnings.filterwarnings("ignore")

import joblib
import pandas as pd

MODELS_DIR   = Path(__file__).parent / "pipeline_output" / "models"
FEATURES_DIR = Path(__file__).parent / "pipeline_output" / "features"
OUT_DIR      = Path(__file__).parent / "pipeline_output" / "ml"
OUT_DIR.mkdir(parents=True, exist_ok=True)


def section(title: str) -> None:
    print(f"\n{'='*65}\n  {title}\n{'='*65}")


def main():
    section("Predict Only")

    feat_path = FEATURES_DIR / "student_features.csv"
    if not feat_path.exists():
        print("  Run build_features.py first")
        return

    df = pd.read_csv(feat_path, low_memory=False)
    print(f"  Loaded: {len(df):,} students")

    targets = [
        ("Dropout",       "dropout"),
        ("AtRisk",        "atrisk"),
        ("HighPerformer", "highperformer"),
    ]

    all_probs = df[["StudentId"]].copy()

    for target, fname in targets:
        pkl = MODELS_DIR / f"{fname}_model.pkl"
        if not pkl.exists():
            print(f"  {target}: model not found — run run_ml.py first")
            continue

        artifact   = joblib.load(pkl)
        model      = artifact["model"]
        scaler     = artifact["scaler"]
        needs_scale= artifact["needs_scale"]
        feat_cols  = artifact["feature_cols"]
        model_name = artifact["model_name"]
        auc        = artifact["auc"]

        X = df[feat_cols].fillna(0).values
        if needs_scale:
            X = scaler.transform(X)

        proba = model.predict_proba(X)[:, 1]

        prob_df = df[["StudentId"]].copy()
        prob_df[f"{target}_Probability"] = proba.round(4)
        prob_df[f"{target}_Predicted"]   = (proba >= 0.5).astype(int)
        if target in df.columns:
            prob_df[f"{target}_Actual"]  = df[target].values

        prob_df.sort_values(f"{target}_Probability", ascending=False) \
               .to_csv(OUT_DIR / f"pred_{fname}.csv", index=False)

        all_probs[f"{target}_Probability"] = proba.round(4)
        all_probs[f"{target}_Predicted"]   = (proba >= 0.5).astype(int)

        n_flagged = int((proba >= 0.5).sum())
        print(f"  {target:<15}  {model_name:<22}  AUC={auc}  Flagged={n_flagged}")

    all_probs.to_csv(OUT_DIR / "pred_all_students.csv", index=False)

    section("DONE")
    print(f"""
  pred_dropout.csv        → Dropout probability per student
  pred_atrisk.csv         → AtRisk probability per student
  pred_highperformer.csv  → HighPerformer probability per student
  pred_all_students.csv   → All three combined
  Output: {OUT_DIR}
""")


if __name__ == "__main__":
    main()
