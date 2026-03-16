import numpy as np
import pandas as pd
from sklearn.calibration import calibration_curve
from sklearn.metrics import (
    confusion_matrix, roc_auc_score,
    average_precision_score, f1_score,
    precision_score, recall_score,
)
from ml.ml_utils import get_X_y


def _threshold_optimize(y_true: np.ndarray, proba: np.ndarray) -> dict:
    thresholds = np.arange(0.10, 0.91, 0.05)
    rows = []
    for t in thresholds:
        pred = (proba >= t).astype(int)
        if pred.sum() == 0:
            continue
        rows.append({
            "Threshold":  round(t, 2),
            "Precision":  round(precision_score(y_true, pred, zero_division=0), 4),
            "Recall":     round(recall_score(y_true, pred, zero_division=0), 4),
            "F1":         round(f1_score(y_true, pred, zero_division=0), 4),
            "Flagged":    int(pred.sum()),
            "FlaggedPct": round(pred.mean() * 100, 1),
        })
    df = pd.DataFrame(rows)
    best_idx = df["F1"].idxmax() if not df.empty else 0
    return df, float(df.loc[best_idx, "Threshold"]) if not df.empty else 0.5


def _confusion(y_true: np.ndarray, pred: np.ndarray, label: str) -> pd.DataFrame:
    cm = confusion_matrix(y_true, pred)
    tn, fp, fn, tp = cm.ravel() if cm.size == 4 else (0, 0, 0, 0)
    total = len(y_true)
    return pd.DataFrame([{
        "Target":              label,
        "TruePositive":        int(tp),
        "FalsePositive":       int(fp),
        "TrueNegative":        int(tn),
        "FalseNegative":       int(fn),
        "Precision":           round(tp / (tp + fp) if (tp + fp) else 0, 4),
        "Recall":              round(tp / (tp + fn) if (tp + fn) else 0, 4),
        "Specificity":         round(tn / (tn + fp) if (tn + fp) else 0, 4),
        "FalseAlarmRate":      round(fp / (fp + tn) if (fp + tn) else 0, 4),
        "MissedCasesRate":     round(fn / (fn + tp) if (fn + tp) else 0, 4),
    }])


def _calibration(y_true: np.ndarray, proba: np.ndarray,
                 model_name: str, n_bins: int = 10) -> pd.DataFrame:
    fraction_pos, mean_pred = calibration_curve(y_true, proba,
                                                n_bins=n_bins, strategy="uniform")
    return pd.DataFrame({
        "MeanPredictedProb": mean_pred.round(4),
        "FractionPositives": fraction_pos.round(4),
        "Model":             model_name,
    })


def run(df: pd.DataFrame, trained_models: dict, results: dict) -> None:
    target_map = {
        "Dropout":       "2_dropout",
        "AtRisk":        "3_atrisk",
        "HighPerformer": "4_highperf",
    }

    all_confusion   = []
    all_calibration = []
    all_thresholds  = []
    summary_rows    = []

    for target, prefix in target_map.items():
        models = trained_models.get(target, {})
        if not models:
            continue

        _, y, _ = get_X_y(df, target)
        prob_col = f"{target}_Probability"
        prob_key = f"{prefix}_probabilities"

        if prob_key not in results or prob_col not in results[prob_key].columns:
            continue

        # align probabilities with labels using StudentId to avoid index mismatch
        _prob_df   = results[prob_key][["StudentId", prob_col]].copy()
        _lbl_df    = df[["StudentId"]].copy()
        _lbl_df["_y"] = y
        _merged    = _lbl_df.merge(_prob_df, on="StudentId", how="inner")
        y          = _merged["_y"].values
        proba_full = _merged[prob_col].values

        # ── Threshold optimization ─────────────────────────────────────────
        thresh_df, best_thresh = _threshold_optimize(y, proba_full)
        thresh_df["Target"] = target
        all_thresholds.append(thresh_df)

        # apply optimal threshold to probabilities table
        results[prob_key][f"{target}_OptimalPredicted"] = (
            proba_full >= best_thresh
        ).astype(int)

        opt_pred = results[prob_key][f"{target}_OptimalPredicted"].values

        # ── Confusion matrix ───────────────────────────────────────────────
        cm_df = _confusion(y, opt_pred, target)
        cm_df["OptimalThreshold"] = best_thresh
        all_confusion.append(cm_df)

        # ── Calibration curve ──────────────────────────────────────────────
        best_name = next(iter(models))  # first = best (dict ordered by AUC)
        calib_df  = _calibration(y, proba_full, best_name)
        calib_df["Target"] = target
        all_calibration.append(calib_df)

        # ── PR-AUC (Average Precision) ─────────────────────────────────────
        pr_auc = round(average_precision_score(y, proba_full), 4) \
            if len(np.unique(y)) > 1 else None
        roc_auc = round(roc_auc_score(y, proba_full), 4) \
            if len(np.unique(y)) > 1 else None

        best_thresh_row = thresh_df.loc[thresh_df["F1"].idxmax()] if not thresh_df.empty else {}
        summary_rows.append({
            "Target":           target,
            "ROC_AUC_FullData":  roc_auc,
            "PR_AUC_FullData":   pr_auc,
            "BestThreshold":    best_thresh,
            "BestF1":           best_thresh_row.get("F1") if isinstance(best_thresh_row, pd.Series) else None,
            "BestPrecision":    best_thresh_row.get("Precision") if isinstance(best_thresh_row, pd.Series) else None,
            "BestRecall":       best_thresh_row.get("Recall") if isinstance(best_thresh_row, pd.Series) else None,
            "FlaggedAtOptimal": int(opt_pred.sum()),
            "FlaggedPct":       round(opt_pred.mean() * 100, 1),
        })

        print(f"  {target:<15}  ROC-AUC={roc_auc}  PR-AUC={pr_auc}  "
              f"BestThreshold={best_thresh}  F1={best_thresh_row.get('F1') if isinstance(best_thresh_row, pd.Series) else '-'}")

    if all_confusion:
        results["eval_confusion_matrix"]  = pd.concat(all_confusion,   ignore_index=True)
    if all_calibration:
        results["eval_calibration_curve"] = pd.concat(all_calibration, ignore_index=True).round(4)
    if all_thresholds:
        results["eval_threshold_search"]  = pd.concat(all_thresholds,  ignore_index=True).round(4)
    if summary_rows:
        results["eval_summary"]           = pd.DataFrame(summary_rows).round(4)
