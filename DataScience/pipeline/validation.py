from pipeline_config import VALIDATION_RULES
from pipeline.logger import log


def validate_all(transformed):
    log.info("--- Stage 4: Validation ---")

    table_map = {
        "students":        "students",
        "activity_log_ml": "activity_log",
        "courses":         "courses",
        "enrollments":     "enrollments",
        "users":           "users",
        "activities":      "activities",
        "attempts":        "attempts",
        "submissions":     "submissions",
        "progress":        "progress",
        "notifications":   "notifications",
    }

    all_ok = True
    for data_key, rule_key in table_map.items():
        if data_key not in transformed or rule_key not in VALIDATION_RULES:
            continue
        df     = transformed[data_key]
        issues = []
        for rule in VALIDATION_RULES[rule_key]:
            col = rule["col"]
            if col not in df.columns:
                continue
            if rule["type"] == "no_null":
                n = int(df[col].isnull().sum())
                if n:
                    issues.append(f"{col}: {n} nulls")
            elif rule["type"] == "range":
                n = int((~df[col].between(rule["min"], rule["max"])).sum())
                if n:
                    issues.append(f"{col}: {n} out of range [{rule['min']}, {rule['max']}]")
        if issues:
            all_ok = False
            for i in issues:
                log.warning("[FAIL] %s — %s", data_key, i)
        else:
            log.info("[PASS] %s", data_key)

    for tbl in ["students", "courses", "activities", "comments"]:
        df = transformed.get(tbl)
        if df is None or "CreatedAt" not in df.columns or "UpdatedAt" not in df.columns:
            continue
        bad = df["UpdatedAt"] < df["CreatedAt"]
        if bad.sum():
            log.warning("[FAIL] %s: %d rows where UpdatedAt < CreatedAt", tbl, int(bad.sum()))
            all_ok = False
        else:
            log.info("[PASS] %s: timestamps OK", tbl)

    return all_ok
