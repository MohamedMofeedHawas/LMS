import numpy as np
import pandas as pd
from sklearn.ensemble import IsolationForest
from sklearn.preprocessing import StandardScaler


ANOMALY_FEATURES = [
    "QuizAttempts", "AvgScore", "PassRate", "FailureRatio",
    "CompletionRate", "LearningVelocity", "AbandonRate",
    "LateRate", "StudyConsistency", "SocialIsolationScore",
]


def run(df: pd.DataFrame, results: dict) -> None:
    feat_cols = [c for c in ANOMALY_FEATURES if c in df.columns]
    anom_df   = df[["StudentId"] + feat_cols].dropna()

    if len(anom_df) < 20 or len(feat_cols) < 4:
        print("  Skipped — insufficient data")
        return

    scaler = StandardScaler()
    X      = scaler.fit_transform(anom_df[feat_cols])

    iso = IsolationForest(contamination=0.05, random_state=42, n_jobs=-1)
    anom_df = anom_df.copy()
    anom_df["IsAnomaly"]    = (iso.fit_predict(X) == -1).astype(int)
    anom_df["AnomalyScore"] = iso.score_samples(X).round(4)

    q = {c: anom_df[c].quantile([0.25, 0.75]) for c in feat_cols if c in anom_df.columns}

    def _type(row) -> str:
        high_score  = row.get("AvgScore", 0)      > q.get("AvgScore",  {}).get(0.75, 9e9)
        low_score   = row.get("AvgScore", 100)     < q.get("AvgScore",  {}).get(0.25, 0)
        low_comp    = row.get("CompletionRate", 1) < 0.20
        high_fail   = row.get("FailureRatio", 0)  > q.get("FailureRatio",{}).get(0.75, 9e9)
        high_late   = row.get("LateRate", 0)       > q.get("LateRate",  {}).get(0.75, 9e9)
        high_social = row.get("SocialIsolationScore",0) > q.get("SocialIsolationScore",{}).get(0.75,9e9)

        if high_score and low_comp:    return "High Score / Low Completion"
        if high_fail  and low_comp:    return "High Failure / Low Completion"
        if high_late  and low_comp:    return "High Late Rate / Low Completion"
        if high_social and low_score:  return "Socially Isolated / Low Score"
        if low_score  and low_comp:    return "Low Score + Low Completion"
        return "Behavioral Outlier"

    anomalies = anom_df[anom_df["IsAnomaly"] == 1].copy()
    anomalies["AnomalyType"] = anomalies.apply(_type, axis=1)

    type_freq = (
        anomalies.groupby("AnomalyType")
        .agg(Count=("StudentId","count"))
        .sort_values("Count", ascending=False).reset_index()
    )

    results["6_1_anomaly_students"]  = anomalies[["StudentId","AnomalyType","AnomalyScore"] + feat_cols].sort_values("AnomalyScore")
    results["6_2_anomaly_type_freq"] = type_freq

    n = int(anom_df["IsAnomaly"].sum())
    print(f"  {n} anomalous students ({round(n/len(anom_df)*100,1)}%)")

