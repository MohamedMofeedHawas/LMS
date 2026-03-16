import pandas as pd


def run(tables: dict, results: dict) -> None:
    print("\n" + "="*65 + "\n  6 · Monitoring & Early Warning\n" + "="*65)

    students     = tables["students"]
    activity_log = tables["activity_log"]
    progress     = tables["progress"]
    attempts     = tables["attempts"]
    submissions  = tables["submissions"]
    enrollments  = tables["enrollments"]
    engagement   = tables["engagement"]
    student_perf = tables["student_performance"]
    course_metrics = tables["course_metrics"]
    activities   = tables["activities"]

    alerts = []

    # ── Inactive Students ─────────────────────────────────────────────────────
    print("\n  [6.1] Inactive Students")
    if not activity_log.empty and "Timestamp" in activity_log.columns and not students.empty:
        _sids = set(students["Id"])
        last_seen = (
            activity_log[activity_log["UserId"].isin(_sids)]
            .groupby("UserId")["Timestamp"].max()
            .reset_index()
            .rename(columns={"UserId": "StudentId", "Timestamp": "LastSeen"})
        )
        inactive = last_seen.copy()
        inactive["DaysSinceActive"] = (pd.Timestamp.now() - inactive["LastSeen"]).dt.days
        inactive_7  = inactive[inactive["DaysSinceActive"] > 7]
        inactive_14 = inactive[inactive["DaysSinceActive"] > 14]
        inactive_30 = inactive[inactive["DaysSinceActive"] > 30]

        results["monitoring"]["inactive_students"] = (
            inactive.sort_values("DaysSinceActive", ascending=False)
        )
        print(f"  Inactive >7d: {len(inactive_7)}  >14d: {len(inactive_14)}  >30d: {len(inactive_30)}")

        if len(inactive_7) > 0:
            alerts.append({"Rule": "Inactive Students (>7 days)",   "Count": len(inactive_7),  "Severity": "Medium"})
        if len(inactive_14) > 0:
            alerts.append({"Rule": "Inactive Students (>14 days)",  "Count": len(inactive_14), "Severity": "High"})
        if len(inactive_30) > 0:
            alerts.append({"Rule": "Inactive Students (>30 days)",  "Count": len(inactive_30), "Severity": "Critical"})
    else:
        print("  Skipped")

    # ── High Course Dropout ───────────────────────────────────────────────────
    print("\n  [6.2] High Course Dropout")
    if not course_metrics.empty and "CompletionRate" in course_metrics.columns:
        high_dropout = course_metrics[course_metrics["CompletionRate"] < 0.4].copy()
        high_dropout["DropoutRate"] = (1 - high_dropout["CompletionRate"]).round(3)
        keep = [c for c in ["CourseId","Title","DepartmentName","CompletionRate","DropoutRate","TotalAttempts"] if c in high_dropout.columns]
        results["monitoring"]["high_dropout_courses"] = high_dropout[keep].sort_values("DropoutRate", ascending=False)
        print(f"  {len(high_dropout)} courses with dropout > 60%")
        if len(high_dropout) > 0:
            alerts.append({"Rule": "High Course Dropout (>60%)", "Count": len(high_dropout), "Severity": "High"})
    else:
        print("  Skipped")

    # ── Difficult Activities (too many retries) ────────────────────────────────
    print("\n  [6.3] Difficult Activities")
    if not attempts.empty and "AttemptNumber" in attempts.columns:
        retry_stats = (
            attempts.groupby("QuizId")
            .agg(AvgAttempts=("AttemptNumber","mean"), PassRate=("Passed","mean"), TotalStudents=("StudentId","nunique"))
            .round(3).reset_index()
        )
        difficult = retry_stats[(retry_stats["AvgAttempts"] > 2) | (retry_stats["PassRate"] < 0.4)]
        if not activities.empty and "Title" in activities.columns:
            difficult = difficult.merge(
                activities[["Id","Title","CourseId"]].rename(columns={"Id":"QuizId"}),
                on="QuizId", how="left"
            )
        results["monitoring"]["difficult_activities"] = difficult.sort_values("AvgAttempts", ascending=False)
        print(f"  {len(difficult)} activities flagged")
        if len(difficult) > 0:
            alerts.append({"Rule": "Difficult Activities (avg attempts > 2 or pass rate < 40%)", "Count": len(difficult), "Severity": "Medium"})
    else:
        print("  Skipped")

    # ── Multiple Failed Attempts ──────────────────────────────────────────────
    print("\n  [6.4] Multiple Failed Attempts")
    if not attempts.empty and "Passed" in attempts.columns:
        failed_students = (
            attempts[attempts["Passed"] == 0]
            .groupby("StudentId")
            .agg(FailedAttempts=("Id","count"), UniqueQuizzesFailed=("QuizId","nunique"))
            .reset_index()
        )
        chronic_failers = failed_students[failed_students["FailedAttempts"] >= 5]
        results["monitoring"]["chronic_fail_students"] = chronic_failers.sort_values("FailedAttempts", ascending=False)
        print(f"  {len(chronic_failers)} students with 5+ failed attempts")
        if len(chronic_failers) > 0:
            alerts.append({"Rule": "Students with 5+ Failed Attempts", "Count": len(chronic_failers), "Severity": "High"})
    else:
        print("  Skipped")

    # ── Assignment Delays ─────────────────────────────────────────────────────
    print("\n  [6.5] Assignment Delays")
    if not submissions.empty and "IsLate" in submissions.columns:
        late_students = (
            submissions.groupby("StudentId")
            .agg(TotalSubmissions=("Id","count"), LateSubmissions=("IsLate","sum"))
            .reset_index()
        )
        late_students["LateRate"] = (late_students["LateSubmissions"] / late_students["TotalSubmissions"]).round(3)
        chronic_late = late_students[late_students["LateRate"] >= 0.5]
        results["monitoring"]["assignment_delays"] = chronic_late.sort_values("LateRate", ascending=False)
        print(f"  {len(chronic_late)} students with 50%+ late submissions")
        if len(chronic_late) > 0:
            alerts.append({"Rule": "Students with 50%+ Late Submissions", "Count": len(chronic_late), "Severity": "Medium"})
    else:
        print("  Skipped")

    # ── Engagement Drop Indicator ─────────────────────────────────────────────
    print("\n  [6.6] Engagement Drop")
    if not activity_log.empty and "Timestamp" in activity_log.columns and not students.empty:
        _sids = set(students["Id"])
        _log  = activity_log[activity_log["UserId"].isin(_sids)].copy()
        _log["Month"] = _log["Timestamp"].dt.to_period("M").astype(str)

        monthly = (
            _log.groupby(["UserId","Month"]).size()
            .reset_index(name="Actions")
            .sort_values(["UserId","Month"])
        )

        all_months = sorted(monthly["Month"].unique())

        # find the two most populated consecutive months (avoids sparse end-of-dataset issue)
        month_counts = monthly.groupby("Month")["UserId"].nunique()
        best_month_idx = month_counts.nlargest(10).index
        # pick two consecutive months from the busiest period
        sorted_best = sorted(best_month_idx)
        pair = None
        for i in range(len(sorted_best)-1):
            if sorted_best[i+1] == sorted_best[i]:
                pair = (sorted_best[i], sorted_best[i+1])
                break
        if pair is None and len(sorted_best) >= 2:
            pair = (sorted_best[-2], sorted_best[-1])

        if pair:
            m1 = monthly[monthly["Month"] == pair[0]].set_index("UserId")["Actions"]
            m2 = monthly[monthly["Month"] == pair[1]].set_index("UserId")["Actions"]
            drop_df  = pd.concat([m1.rename("PrevMonth"), m2.rename("CurrMonth")], axis=1).dropna()
            drop_df["Drop"]    = drop_df["PrevMonth"] - drop_df["CurrMonth"]
            drop_df["DropPct"] = (drop_df["Drop"] / drop_df["PrevMonth"].replace(0, 1) * 100).round(1)
            eng_drop = drop_df[drop_df["DropPct"] >= 50].reset_index().rename(columns={"UserId":"StudentId"})
            results["monitoring"]["engagement_drop"] = eng_drop.sort_values("DropPct", ascending=False)
            print(f"  {len(eng_drop)} students with 50%+ engagement drop  (comparing {pair[0]} vs {pair[1]})")
            if len(eng_drop) > 0:
                alerts.append({"Rule": "Engagement Drop 50%+ vs Prior Month", "Count": len(eng_drop), "Severity": "High"})
        else:
            print("  Not enough monthly data")
    else:
        print("  Skipped")

    # ── Student Risk Score ────────────────────────────────────────────────────
    print("\n  [6.7] Student Risk Score")
    if not student_perf.empty and not engagement.empty:
        _eng = engagement[["StudentId","ActionCount"]].copy()
        risk = student_perf.merge(_eng, on="StudentId", how="left")

        # Only score students who have actual activity — zeros mean "not yet enrolled"
        # not "failing". A student with zero attempts hasn't started, not at risk.
        is_active = (
            (risk["AvgQuizScore"]   > 0) |
            (risk["QuizPassRate"]   > 0) |
            (risk["CompletionRate"] > 0) |
            (risk["ActionCount"].fillna(0) > 0)
        )
        risk_active = risk[is_active].copy()
        inactive_count = len(risk) - len(risk_active)

        if not risk_active.empty:
            # Use percentile-based normalization so risk is relative to the cohort,
            # not absolute thresholds — avoids inflating risk when the whole dataset
            # has naturally low scores (which is the case with generated data).
            def pct_rank(s):
                return s.rank(pct=True).fillna(0.5)

            f_score    = 1 - pct_rank(risk_active["AvgQuizScore"])
            f_pass     = 1 - pct_rank(risk_active["QuizPassRate"])
            f_complete = 1 - pct_rank(risk_active["CompletionRate"])
            f_engage   = 1 - pct_rank(risk_active["ActionCount"].fillna(0))

            risk_active["RiskScore"] = (
                (f_score * 0.30) + (f_pass * 0.25) + (f_complete * 0.25) + (f_engage * 0.20)
            ).round(4)
            risk_active["RiskLevel"] = pd.cut(
                risk_active["RiskScore"],
                bins=[-0.01, 0.35, 0.60, 1.01],
                labels=["Low", "Medium", "High"],
            )

        keep = [c for c in ["StudentId","RiskScore","RiskLevel","AvgQuizScore","QuizPassRate","CompletionRate","ActionCount"] if c in risk_active.columns]
        results["monitoring"]["student_risk_scores"] = risk_active[keep].sort_values("RiskScore", ascending=False)

        high_risk = int((risk_active["RiskLevel"] == "High").sum())
        med_risk  = int((risk_active["RiskLevel"] == "Medium").sum())
        low_risk  = int((risk_active["RiskLevel"] == "Low").sum())
        print(f"  Active students scored: {len(risk_active):,}  (skipped {inactive_count:,} with no activity)")
        print(f"  High: {high_risk}  Medium: {med_risk}  Low: {low_risk}")
        if high_risk > 0:
            alerts.append({"Rule": "High Risk Students (active only)", "Count": high_risk, "Severity": "Critical"})
    else:
        print("  Skipped")

    # ── Alert Summary ─────────────────────────────────────────────────────────
    print("\n  [6.8] Alert Summary")
    alert_df = pd.DataFrame(alerts) if alerts else pd.DataFrame(columns=["Rule","Count","Severity"])
    severity_order = {"Critical": 0, "High": 1, "Medium": 2, "Low": 3}
    if not alert_df.empty:
        alert_df["SeverityOrder"] = alert_df["Severity"].map(severity_order)
        alert_df = alert_df.sort_values("SeverityOrder").drop(columns="SeverityOrder")
    results["monitoring"]["alerts"] = alert_df
    print(f"  {len(alert_df)} active alerts")
    for _, row in alert_df.iterrows():
        print(f"  [{row['Severity']}] {row['Rule']}: {row['Count']}")

    print(f"\n  ✅ Monitoring: {len(results['monitoring'])} tables")
