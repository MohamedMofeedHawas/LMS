import sys
import warnings
from pathlib import Path

sys.path.insert(0, str(Path(__file__).parent))
warnings.filterwarnings("ignore")

from analytics.loader      import load_all, section
from analytics.admin       import admin_analytics
from analytics.teacher     import teacher_analytics
from analytics.student     import student_analytics
from analytics.behavioral  import behavioral_analytics
from analytics.course      import course_analytics
from analytics.monitoring  import monitoring
from analytics.warehouse   import star_schema
from analytics.export      import export_results


def main():
    tables  = load_all()
    results = {
        "admin":      {},
        "teacher":    {},
        "student":    {},
        "course":     {},
        "monitoring": {},
    }

    admin_analytics.run(tables, results)
    teacher_analytics.run(tables, results)
    student_analytics.run(tables, results)
    behavioral_analytics.run(tables, results)
    course_analytics.run(tables, results)
    monitoring.run(tables, results)
    star_schema.run(tables)
    export_results.run(results)

    section("DONE")
    total = sum(len(v) for v in results.values())
    print(f"""
  Total tables : {total}

  Admin        {len(results['admin'])} tables  →  analysis/admin/
  Teacher      {len(results['teacher'])} tables  →  analysis/instructor/
  Student      {len(results['student'])} tables  →  analysis/student/
  Course       {len(results['course'])} tables  →  analysis/course/
  Monitoring   {len(results['monitoring'])} tables  →  analysis/monitoring/

  Star Schema  →  analysis/star_schema/
  Excel        →  analysis/analysis_insights.xlsx
""")


if __name__ == "__main__":
    main()
