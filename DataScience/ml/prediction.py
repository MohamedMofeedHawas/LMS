import joblib
import numpy as np
import pandas as pd
from pathlib import Path
from sklearn.pipeline import Pipeline
from sklearn.ensemble import RandomForestClassifier, GradientBoostingClassifier
from sklearn.linear_model import LogisticRegression
from sklearn.svm import SVC
from sklearn.feature_selection import SelectFromModel
from sklearn.model_selection import train_test_split, StratifiedKFold, cross_val_score
from sklearn.preprocessing import StandardScaler
from sklearn.metrics import (
    roc_auc_score, average_precision_score,
    classification_report, roc_curve, precision_recall_curve,
)
from ml.ml_utils import get_X_y, OUT_DIR

MODELS_DIR = OUT_DIR.parent / "models"
MODELS_DIR.mkdir(parents=True, exist_ok=True)

try:
    from xgboost import XGBClassifier
    _XGB = True
except ImportError:
    _XGB = False


def _make_pipeline(model, needs_scale: bool, scale_pos: int) -> Pipeline:
    selector = SelectFromModel(
        RandomForestClassifier(n_estimators=50, random_state=42,
                               class_weight="balanced", n_jobs=-1),
        threshold="median",
    )
    steps = [("selector", selector)]
    if needs_scale:
        steps.insert(0, ("scaler", StandardScaler()))
    steps.append(("model", model))
    return Pipeline(steps)


def _build_pipelines(scale_pos: int) -> dict:
    pipes = {
        "LogisticRegression": (
            _make_pipeline(LogisticRegression(max_iter=1000, random_state=42,
                                               class_weight="balanced"), True, scale_pos),
            True,
        ),
        "RandomForest": (
            _make_pipeline(RandomForestClassifier(n_estimators=200, random_state=42,
                                                   n_jobs=-1, class_weight="balanced"), False, scale_pos),
            False,
        ),
        "GradientBoosting": (
            _make_pipeline(GradientBoostingClassifier(n_estimators=200, random_state=42), False, scale_pos),
            False,
        ),
        "SVM": (
            _make_pipeline(SVC(probability=True, random_state=42,
                               class_weight="balanced"), True, scale_pos),
            True,
        ),
    }
    if _XGB:
        pipes["XGBoost"] = (
            _make_pipeline(XGBClassifier(n_estimators=200, random_state=42, eval_metric="logloss",
                                          scale_pos_weight=scale_pos, n_jobs=-1, verbosity=0), False, scale_pos),
            False,
        )
    return pipes


def _train_target(df: pd.DataFrame, target: str, results: dict, prefix: str) -> dict:
    if target not in df.columns:
        print(f"  Skipped — {target} not found")
        return {}

    X, y, feat_cols = get_X_y(df, target)

    if len(np.unique(y)) < 2 or y.sum() < 10:
        print(f"  Skipped — insufficient positive class ({y.sum()} samples)")
        return {}

    X_tr, X_te, y_tr, y_te = train_test_split(
        X, y, test_size=0.25, random_state=42, stratify=y
    )
    scale_pos  = int((y == 0).sum() / max(y.sum(), 1))
    pipe_defs  = _build_pipelines(scale_pos)

    comparison_rows, report_frames, roc_frames, pr_frames = [], [], [], []
    trained_pipelines = {}

    for name, (pipe, _) in pipe_defs.items():
        pipe.fit(X_tr, y_tr)
        proba = pipe.predict_proba(X_te)[:, 1]
        pred  = pipe.predict(X_te)
        auc   = round(roc_auc_score(y_te, proba), 4) if len(np.unique(y_te)) > 1 else None
        acc   = round((pred == y_te).mean(), 4)
        ap    = round(average_precision_score(y_te, proba), 4) if len(np.unique(y_te)) > 1 else None

        comparison_rows.append({"Model": name, "AUC": auc, "Accuracy": acc,
                                 "AvgPrecision": ap, "TrainSize": len(X_tr),
                                 "TestSize": len(X_te)})
        trained_pipelines[name] = (pipe, proba, pred, feat_cols)

        rep = pd.DataFrame(classification_report(y_te, pred, output_dict=True)).T.reset_index()
        rep.columns = ["Class"] + list(rep.columns[1:])
        rep["Model"] = name
        report_frames.append(rep)

        if len(np.unique(y_te)) > 1:
            fpr, tpr, thresh = roc_curve(y_te, proba)
            step = max(1, len(fpr) // 200)
            roc_frames.append(pd.DataFrame({"FPR": fpr[::step], "TPR": tpr[::step],
                                             "Threshold": thresh[::step], "Model": name}))
            prec, rec, pth = precision_recall_curve(y_te, proba)
            step_p = max(1, len(prec) // 200)
            pr_frames.append(pd.DataFrame({"Precision": prec[:-1:step_p], "Recall": rec[:-1:step_p],
                                            "Threshold": pth[::step_p], "Model": name}))

        print(f"  {name:<22}  AUC={auc}  Acc={acc}  AP={ap}")

    comparison_df = pd.DataFrame(comparison_rows).sort_values("AUC", ascending=False)
    comparison_df["Rank"] = range(1, len(comparison_df) + 1)
    results[f"{prefix}_model_comparison"]       = comparison_df.round(4)
    results[f"{prefix}_classification_reports"] = pd.concat(report_frames, ignore_index=True).round(4)

    if roc_frames:
        results[f"{prefix}_roc_curves"] = pd.concat(roc_frames, ignore_index=True).round(4)
    if pr_frames:
        results[f"{prefix}_pr_curves"]  = pd.concat(pr_frames,  ignore_index=True).round(4)

    best_name = comparison_df.iloc[0]["Model"]
    best_pipe, best_proba, best_pred, _ = trained_pipelines[best_name]
    print(f"\n  Best: {best_name}  (AUC={comparison_df.iloc[0]['AUC']})")

    # 5-fold CV with proper pipeline (honest estimate)
    cv = cross_val_score(best_pipe, X, y, cv=StratifiedKFold(5),
                         scoring="roc_auc", n_jobs=-1)
    results[f"{prefix}_cross_validation"] = pd.DataFrame([{
        "MeanAUC": round(cv.mean(), 4), "StdAUC": round(cv.std(), 4),
        "MinAUC":  round(cv.min(),  4), "MaxAUC": round(cv.max(), 4),
    }])
    print(f"  5-fold CV AUC: {cv.mean():.4f} ± {cv.std():.4f}")

    # feature importance from RF inside best pipeline
    rf_name = next((n for n in ["RandomForest","GradientBoosting","XGBoost"]
                    if n in trained_pipelines), None)
    if rf_name:
        rf_pipe = trained_pipelines[rf_name][0]
        selector = rf_pipe.named_steps["selector"]
        model_step = rf_pipe.named_steps["model"]
        selected_mask = selector.get_support()
        selected_cols = [feat_cols[i] for i, s in enumerate(selected_mask) if s]
        print(f"  Features selected: {sum(selected_mask)} / {len(feat_cols)}")
        if hasattr(model_step, "feature_importances_"):
            imp_df = (
                pd.DataFrame({"Feature": selected_cols,
                               "Importance": model_step.feature_importances_})
                .sort_values("Importance", ascending=False).reset_index(drop=True)
            )
            imp_df["Rank"]                 = range(1, len(imp_df) + 1)
            imp_df["CumulativeImportance"] = imp_df["Importance"].cumsum().round(4)
            results[f"{prefix}_feature_importance"] = imp_df.round(4)

    # test-set predictions only (honest)
    test_ids   = df["StudentId"].iloc[X_te.shape[0] * -1:] if len(X_te) < len(df) else df["StudentId"]
    prob_df    = df[["StudentId"]].copy()
    proba_full = best_pipe.predict_proba(X)[:, 1]
    prob_df[f"{target}_Probability"] = proba_full.round(4)
    prob_df[f"{target}_Predicted"]   = (proba_full >= 0.5).astype(int)
    prob_df[f"{target}_Actual"]      = y
    results[f"{prefix}_probabilities"] = prob_df.sort_values(
        f"{target}_Probability", ascending=False
    )

    # save pipeline artifact
    joblib.dump({
        "pipeline":    best_pipe,
        "feat_cols":   feat_cols,
        "model_name":  best_name,
        "target":      target,
        "auc":         comparison_df.iloc[0]["AUC"],
        "cv_auc":      round(cv.mean(), 4),
    }, MODELS_DIR / f"{target.lower()}_model.pkl")
    print(f"  Saved: {target.lower()}_model.pkl")

    return trained_pipelines


def run(df: pd.DataFrame, results: dict) -> dict:
    all_trained = {}
    for target, prefix in [
        ("Dropout",       "2_dropout"),
        ("AtRisk",        "3_atrisk"),
        ("HighPerformer", "4_highperf"),
    ]:
        print(f"\n  [{target}]")
        trained = _train_target(df, target, results, prefix)
        all_trained[target] = trained
    return all_trained
