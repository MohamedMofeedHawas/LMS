import numpy as np
import pandas as pd
from sklearn.cluster import KMeans
from sklearn.preprocessing import StandardScaler
from ml.ml_utils import save


CLUSTER_FEATURES = [
    "QuizAttempts", "AvgScore", "PassRate", "FailureRatio",
    "CompletionRate", "ActivitiesCompleted", "LearningVelocity",
    "LateRate", "AbandonRate", "StudyConsistency",
]


def run(df: pd.DataFrame, results: dict) -> None:
    feat_cols = [c for c in CLUSTER_FEATURES if c in df.columns]
    cluster_df = df[["StudentId"] + feat_cols].dropna()

    if len(cluster_df) < 50 or len(feat_cols) < 4:
        print("  Skipped — insufficient data")
        return

    scaler = StandardScaler()
    X      = scaler.fit_transform(cluster_df[feat_cols])

    inertias = {}
    for k in range(2, min(9, len(cluster_df) // 10 + 2)):
        inertias[k] = KMeans(n_clusters=k, random_state=42, n_init=10).fit(X).inertia_
    results["1_1_elbow"] = pd.DataFrame(list(inertias.items()), columns=["K","Inertia"])

    km = KMeans(n_clusters=4, random_state=42, n_init=10)
    cluster_df = cluster_df.copy()
    cluster_df["Cluster"] = km.fit_predict(X)

    profile = cluster_df.groupby("Cluster")[feat_cols].mean().round(3).reset_index()

    rank_inputs = [c for c in ["AvgScore","CompletionRate","PassRate","QuizAttempts","ActivitiesCompleted"] if c in profile.columns]
    if rank_inputs:
        from sklearn.preprocessing import MinMaxScaler
        _s = MinMaxScaler()
        _normed = _s.fit_transform(profile[rank_inputs])
        profile["_rank"] = _normed.mean(axis=1)
        order = profile.sort_values("_rank", ascending=False)["Cluster"].tolist()
        profile.drop(columns=["_rank"], inplace=True)
        # assign labels by analyzing each cluster's characteristics
        label_map = {}
        for rank, cluster_id in enumerate(order):
            row  = profile[profile["Cluster"] == cluster_id].iloc[0]
            comp = row.get("CompletionRate", 0)
            quiz = row.get("QuizAttempts",   0)
            scr  = row.get("AvgScore",        0)

            if quiz > 3 and comp > 0.3:
                label_map[cluster_id] = "High Achievers"
            elif quiz > 3 and comp < 0.1:
                label_map[cluster_id] = "Inconsistent Learners"
            elif quiz < 1 and comp > 0.3:
                label_map[cluster_id] = "Passive Learners"
            else:
                label_map[cluster_id] = "At-Risk Students" 
    else:
        label_map = {i: f"Cluster {i}" for i in range(4)}

    cluster_df["ClusterLabel"] = cluster_df["Cluster"].map(label_map)
    profile["ClusterLabel"]    = profile["Cluster"].map(label_map)

    sizes = (
        cluster_df.groupby(["Cluster","ClusterLabel"]).size()
        .reset_index(name="StudentCount")
    )
    sizes["Pct"] = (sizes["StudentCount"] / len(cluster_df) * 100).round(1)

    results["1_2_cluster_profiles"] = profile
    results["1_3_student_clusters"] = cluster_df[["StudentId","Cluster","ClusterLabel"]]
    results["1_4_cluster_sizes"]    = sizes

    print(f"  {len(cluster_df):,} students → 4 clusters")
    for _, r in sizes.iterrows():
        print(f"    {r['ClusterLabel']}: {int(r['StudentCount'])} ({r['Pct']}%)")
