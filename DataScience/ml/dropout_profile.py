import numpy as np
import pandas as pd
from ml.ml_utils import LABEL_COLS


def run(df: pd.DataFrame, results: dict) -> None:
    feat_cols = [c for c in df.columns if c not in LABEL_COLS]

    for target, prefix in [("Dropout","7_dropout"), ("AtRisk","7_atrisk")]:
        if target not in df.columns:
            continue

        flagged = df[df[target] == 1]
        safe    = df[df[target] == 0]

        if flagged.empty or safe.empty:
            continue

        profile = pd.DataFrame({
            "Feature":     feat_cols,
            "Flagged_Avg": [flagged[c].mean() for c in feat_cols],
            "Safe_Avg":    [safe[c].mean()    for c in feat_cols],
        })
        profile["Gap"]    = (profile["Flagged_Avg"] - profile["Safe_Avg"]).round(4)
        profile["GapPct"] = (
            profile["Gap"] / profile["Safe_Avg"].replace(0, np.nan) * 100
        ).round(1)
        profile = profile.sort_values("GapPct").round(3)

        red_flags = profile[profile["Gap"] < 0].head(5)

        results[f"{prefix}_profile"]   = profile
        results[f"{prefix}_red_flags"] = red_flags

        print(f"  {target}: {len(flagged):,} flagged vs {len(safe):,} safe")
        if not red_flags.empty:
            print(f"    Top deficit: {red_flags.iloc[0]['Feature']}")
