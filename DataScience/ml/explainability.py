import numpy as np
import pandas as pd

try:
    import shap
    _SHAP = True
except ImportError:
    _SHAP = False


def run(df: pd.DataFrame, trained_models: dict, results: dict) -> None:
    if not _SHAP:
        print("  shap not installed — pip install shap")
        return

    prefix_map = {
        "Dropout":       "2_dropout",
        "AtRisk":        "3_atrisk",
        "HighPerformer": "4_highperf",
    }

    for target, models in trained_models.items():
        if not models:
            continue

        best_name = next(
            (n for n in ["RandomForest","GradientBoosting","XGBoost",
                          "LogisticRegression","SVM"] if n in models),
            None,
        )
        if not best_name:
            continue

        pipeline  = models[best_name][0]
        feat_cols = models[best_name][3]
        prefix    = prefix_map.get(target, target)
        steps     = list(pipeline.named_steps.keys())

        # transform data through all pipeline steps except the final model
        X_raw = df[feat_cols].fillna(0).values
        X_t   = X_raw
        for step_name in steps[:-1]:
            X_t = pipeline.named_steps[step_name].transform(X_t)

        # get feature names after selector
        if "selector" in pipeline.named_steps:
            mask       = pipeline.named_steps["selector"].get_support()
            feat_used  = [feat_cols[i] for i, s in enumerate(mask) if s]
        else:
            feat_used  = feat_cols

        model = pipeline.named_steps[steps[-1]]
        X_df  = pd.DataFrame(X_t, columns=feat_used)

        try:
            if best_name in ("RandomForest", "GradientBoosting", "XGBoost"):
                explainer = shap.TreeExplainer(model)
                raw       = explainer.shap_values(X_df.values)
                if isinstance(raw, list) and len(raw) == 2:
                    sv = np.array(raw[1])
                else:
                    sv = np.array(raw)
                if sv.ndim == 3:
                    sv = sv[:, :, 1]

            elif best_name == "LogisticRegression":
                bg        = shap.sample(X_df, min(100, len(X_df)))
                explainer = shap.LinearExplainer(model, bg.values)
                raw       = explainer.shap_values(X_df.values)
                sv        = np.array(raw)
                if sv.ndim == 3:
                    sv = sv[:, :, 1]

            else:
                bg        = shap.sample(X_df, min(50, len(X_df)))
                explainer = shap.KernelExplainer(model.predict_proba, bg.values)
                n_sample  = min(200, len(X_df))
                raw       = explainer.shap_values(X_df.values[:n_sample])
                if isinstance(raw, list) and len(raw) == 2:
                    sv = np.array(raw[1])
                else:
                    sv = np.array(raw)
                if sv.ndim == 3:
                    sv = sv[:, :, 1]

            # ensure 2D and correct number of columns
            sv = sv.reshape(sv.shape[0], -1)
            if sv.shape[1] != len(feat_used):
                print(f"  {target}: shape mismatch {sv.shape[1]} vs {len(feat_used)} — skipped")
                continue

            global_imp = (
                pd.DataFrame({
                    "Feature":     feat_used,
                    "MeanAbsSHAP": np.abs(sv).mean(axis=0),
                    "MeanSHAP":    sv.mean(axis=0),
                })
                .sort_values("MeanAbsSHAP", ascending=False)
                .reset_index(drop=True)
            )
            global_imp["Rank"] = range(1, len(global_imp) + 1)
            results[f"{prefix}_shap_global"] = global_imp.round(5)

            n_save  = min(1000, len(df))
            shap_df = pd.DataFrame(
                sv[:n_save],
                columns=[f"SHAP_{c}" for c in feat_used],
            )
            shap_df.insert(0, "StudentId", df["StudentId"].iloc[:n_save].values)
            shap_df[target] = df[target].iloc[:n_save].values
            results[f"{prefix}_shap_per_student"] = shap_df.round(5)

            print(f"  {target}: top drivers = {global_imp['Feature'].head(3).tolist()}")

        except Exception as e:
            print(f"  {target}: SHAP failed — {e}")
