import sys
import warnings
from pathlib import Path

sys.path.insert(0, str(Path(__file__).parent))
warnings.filterwarnings("ignore")

from features.student_features import build_all as build_student
from features.course_features   import build_all as build_course
from features.feature_utils     import save, OUT_DIR


def section(title: str) -> None:
    print(f"\n{'='*60}\n  {title}\n{'='*60}")


def main():
    section("Feature Engineering Pipeline")

    student_feat, feature_report = build_student()
    save(student_feat,   "student_features")
    save(feature_report, "feature_report")

    course_feat = build_course()
    save(course_feat, "course_features")

    section("Summary")
    print(f"  student_features.csv  {len(student_feat):>6,} rows × {len(student_feat.columns):>3} features")
    print(f"  course_features.csv   {len(course_feat):>6,} rows  × {len(course_feat.columns):>3} features")
    print(f"  feature_report.csv    {len(feature_report):>6,} rows  (quality audit)")

    print("\n  Labels:")
    leakage_notes = {
        "Dropout":      "defined by CompletionRate  → exclude from X",
        "AtRisk":       "defined by CompletionRate  → exclude from X",
        "HighPerformer":"defined by AvgScore+PassRate → exclude from X",
    }
    for col, note in leakage_notes.items():
        if col in student_feat.columns:
            n   = int(student_feat[col].sum())
            pct = round(n / len(student_feat) * 100, 1)
            print(f"    {col:<15} {n:>5} ({pct:>5}%)   {note}")

    print("\n  Class distribution:")
    for col in ["Dropout","AtRisk","HighPerformer"]:
        if col in student_feat.columns:
            ratio = student_feat[col].mean()
            print(f"    {col:<15} {ratio*100:.1f}%")

    dropped = feature_report[feature_report["Dropped"] == True]
    if not dropped.empty:
        print(f"\n  Features removed by validation: {len(dropped)}")
        for _, row in dropped.iterrows():
            print(f"    {row['Feature']:<30} reason: {row['Drop_Reason']}")

    print(f"\n  Output: {OUT_DIR}")
    print("="*60)


if __name__ == "__main__":
    main()
