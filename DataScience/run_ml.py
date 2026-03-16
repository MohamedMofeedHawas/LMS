import sys
import warnings
from pathlib import Path

sys.path.insert(0, str(Path(__file__).parent))
warnings.filterwarnings("ignore")

import pandas as pd
from ml.ml_utils    import load_features, save, OUT_DIR, section
from ml             import segmentation, prediction, explainability
from ml             import early_warning, anomaly, dropout_profile
from ml             import evaluation, dashboard


def _export(results: dict) -> int:
    count = 0
    for name, df in results.items():
        if df is not None and not df.empty:
            save(df, name)
            count += 1

    try:
        import importlib
        for engine in ("openpyxl", "xlsxwriter"):
            try:
                importlib.import_module(engine)
                xlsx_path = OUT_DIR / "ml_insights.xlsx"
                seen: set = set()
                with pd.ExcelWriter(xlsx_path, engine=engine) as writer:
                    for name, df in results.items():
                        if df is not None and not df.empty:
                            sheet = name[:31]
                            i = 2
                            while sheet in seen:
                                sheet = name[:28] + f"_{i}"
                                i += 1
                            seen.add(sheet)
                            df.to_excel(writer, sheet_name=sheet, index=False)
                print(f"  Excel → {xlsx_path}")
                break
            except Exception:
                continue
    except Exception:
        pass

    return count


def main():
    section("ML Pipeline")

    df = load_features()
    print(f"  Loaded: {len(df):,} students × {len(df.columns)} features")

    results: dict = {}

    section("1 · Student Segmentation")
    segmentation.run(df, results)

    section("2-4 · Dropout / AtRisk / HighPerformer Prediction")
    trained_models = prediction.run(df, results)

    section("5 · Evaluation")
    evaluation.run(df, trained_models, results)

    section("6 · Early Warning System")
    early_warning.run(df, results)

    section("7 · Anomaly Detection")
    anomaly.run(df, results)

    section("8 · Dropout Profile")
    dropout_profile.run(df, results)

    section("9 · SHAP Explainability")
    explainability.run(df, trained_models, results)

    section("10 · Early Warning Dashboard")
    dashboard.run(df, results)

    section("Export")
    total = _export(results)

    section("DONE")
    print(f"""
  Tables  : {total}
  Output  : {OUT_DIR}
  Excel   : ml_insights.xlsx

  Sections:
    1.  Student Segmentation      KMeans K=4
    2.  Dropout Prediction        LR · RF · GBM · SVM{" · XGBoost" if _pkg("xgboost") else ""}
    3.  AtRisk Prediction         LR · RF · GBM · SVM{" · XGBoost" if _pkg("xgboost") else ""}
    4.  HighPerformer Prediction  LR · RF · GBM · SVM{" · XGBoost" if _pkg("xgboost") else ""}
    5.  Evaluation                Confusion · Calibration · Threshold · PR-AUC
    6.  Early Warning             Week 1 / 2 / 3 risk signals
    7.  Anomaly Detection         Isolation Forest
    8.  Dropout Profile           flagged vs safe comparison
    9.  SHAP Explainability       {"global + per-student" if _pkg("shap") else "skipped — pip install shap"}
    10. Dashboard                 top risky · course difficulty · engagement patterns
""")


def _pkg(name: str) -> bool:
    try:
        __import__(name)
        return True
    except ImportError:
        return False


if __name__ == "__main__":
    main()
