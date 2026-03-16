import pandas as pd
from pathlib import Path

from analytics.loader import OUT_DIR, INSIGHTS_FILE, unique_sheet


ROLE_FOLDERS = {
    "admin":      "admin",
    "teacher":    "instructor",
    "student":    "student",
    "course":     "course",
    "monitoring": "monitoring",
}


def run(results: dict) -> None:
    print("\n" + "="*65 + "\n  7 · Export\n" + "="*65)

    total = 0
    for role, folder_name in ROLE_FOLDERS.items():
        role_dir = OUT_DIR / folder_name
        role_dir.mkdir(parents=True, exist_ok=True)
        for name, df in results.get(role, {}).items():
            if df is not None and not df.empty:
                df.to_csv(role_dir / f"{name}.csv", index=False)
                total += 1

    print(f"  Saved {total} CSVs → {OUT_DIR}")

    try:
        with pd.ExcelWriter(INSIGHTS_FILE, engine="openpyxl") as writer:
            _seen: set = set()
            for role, folder_name in ROLE_FOLDERS.items():
                for name, df in results.get(role, {}).items():
                    if df is not None and not df.empty:
                        sheet = unique_sheet(role, name, _seen)
                        df.to_excel(writer, sheet_name=sheet, index=False)
        print(f"  Saved Excel → {INSIGHTS_FILE}")
    except Exception as e:
        print(f"  ⚠  Excel failed: {e}")

    print(f"\n  Output structure:")
    for role, folder_name in ROLE_FOLDERS.items():
        n = len(results.get(role, {}))
        if n:
            print(f"    analysis/{folder_name}/  ({n} files)")
