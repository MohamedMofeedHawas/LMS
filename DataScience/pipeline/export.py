import pandas as pd

from pipeline_config import EXPORT_CLEAN, EXPORT_ML, EXPORT_ANALYTICS, INSIGHTS_FILE
from pipeline.logger import log, save_audit


def export_all(transformed, insights, feat_tables=None):
    log.info("--- Stage 6: Export ---")

    clean_map = {
        "students":               "students",
        "activity_log_analytics": "activity_log",
        "courses":                "courses",
        "enrollments":            "enrollments",
        "years":                  "years",
        "squadrons":              "squadrons",
        "departments":            "departments",
        "users":                  "users",
        "activities":             "activities",
        "attempts":               "attempts",
        "submissions":            "submissions",
        "progress":               "progress",
        "notifications":          "notifications",
        "comments":               "comments",
        "likes":                  "likes",
        "questions":              "questions",
        "options":                "options",
        "answers":                "answers",
    }
    for key, name in clean_map.items():
        if key in transformed:
            out = EXPORT_CLEAN / f"{name}_clean.csv"
            transformed[key].to_csv(out, index=False)
            log.info("  Saved %s (%d rows)", out.name, len(transformed[key]))

    ml_map = {
        "students":        "students_ml",
        "activity_log_ml": "activity_log_ml",
        "courses":         "courses_ml",
        "enrollments":     "enrollments_ml",
        "users":           "users_ml",
        "activities":      "activities_ml",
        "attempts":        "attempts_ml",
        "submissions":     "submissions_ml",
        "progress":        "progress_ml",
    }
    for key, name in ml_map.items():
        if key in transformed:
            out = EXPORT_ML / f"{name}.csv"
            transformed[key].to_csv(out, index=False)
            log.info("  Saved %s (%d rows)", out.name, len(transformed[key]))

    for name, df in insights.items():
        if df is not None and not df.empty:
            (EXPORT_ANALYTICS / f"{name}.csv").write_text(df.to_csv(index=False), encoding="utf-8")

    try:
        with pd.ExcelWriter(INSIGHTS_FILE, engine="openpyxl") as writer:
            for sheet, df in insights.items():
                if df is not None and not df.empty:
                    df.to_excel(writer, sheet_name=sheet[:31], index=False)
        log.info("  Saved %s", INSIGHTS_FILE.name)
    except Exception as e:
        log.warning("  Excel export failed: %s", e)

    if feat_tables:
        for name, df in feat_tables.items():
            if df is not None and not df.empty:
                out = EXPORT_CLEAN / f"{name}_clean.csv"
                df.to_csv(out, index=False)
                log.info("  Saved %s (%d rows)", out.name, len(df))
        if "ml_features_dataset" in feat_tables:
            out = EXPORT_ML / "ml_features_dataset.csv"
            feat_tables["ml_features_dataset"].to_csv(out, index=False)
            log.info("  Saved %s", out.name)

    save_audit()
    log.info("Export complete.")
