import random
from datetime import datetime, timedelta
from pathlib import Path

import pandas as pd

from config.settings import INSTRUCTOR_IDS
from utils.helpers import rand_date, maybe_null


ATT_STATUSES = ["Completed", "Completed", "Completed", "InProgress", "Abandoned"]


def generate(output_dir: Path, valid_student_ids: list, valid_quiz_ids: list,
             quiz_meta: dict, questions_rows: list, opt_map: dict):
    print("\n[12/18] Quiz Attempts & Student Answers...")

    attempts_rows = []
    answers_rows  = []
    attempt_id    = 1
    answer_id     = 1

    sample_students = random.sample(valid_student_ids, min(1500, len(valid_student_ids)))
    sample_quizzes  = random.sample(valid_quiz_ids,    min(200,  len(valid_quiz_ids)))

    quiz_q_map: dict[int, list] = {}
    for q in questions_rows:
        qz = q.get("QuizId")
        if qz:
            quiz_q_map.setdefault(qz, []).append(q)

    for student_id in sample_students:
        chosen_quizzes = random.sample(sample_quizzes, min(random.randint(1, 8), len(sample_quizzes)))

        for quiz_id in chosen_quizzes:
            quiz      = quiz_meta.get(quiz_id, {})
            max_att   = quiz.get("MaxAttempts") or 3
            max_score = quiz.get("MaxGrade") or 20
            n_att     = random.randint(1, min(max_att, 3))

            for att_num in range(1, n_att + 1):
                started_at   = rand_date(datetime(2022, 6, 1), datetime(2026, 2, 1))
                time_limit   = quiz.get("TimeLimitMinutes") or 30
                time_spent   = random.randint(60, time_limit * 60 + 300)
                submitted_at = maybe_null(started_at + timedelta(seconds=time_spent), 0.08)
                status       = random.choices(ATT_STATUSES)[0]
                if submitted_at is None:
                    status = "InProgress"

                score     = None
                is_graded = 0
                if status == "Completed" and submitted_at:
                    score     = round(random.uniform(0, max_score), 1)
                    is_graded = random.choice([1, 1, 0])

                if random.random() < 0.03 and score:
                    score = max_score + random.randint(5, 50)
                if random.random() < 0.04:
                    time_spent = None

                attempts_rows.append({
                    "Id":               attempt_id,
                    "QuizId":           quiz_id,
                    "StudentId":        student_id,
                    "AttemptNumber":    att_num,
                    "StartedAt":        started_at,
                    "SubmittedAt":      submitted_at,
                    "Score":            score,
                    "MaxScore":         max_score,
                    "ScorePercent":     round(score / max_score * 100, 1) if score and max_score else None,
                    "Status":           status,
                    "IsGraded":         is_graded,
                    "GradedById":       maybe_null(random.choice(INSTRUCTOR_IDS), 0.40),
                    "GradedAt":         maybe_null(submitted_at + timedelta(hours=random.randint(1, 48)), 0.45) if submitted_at else None,
                    "TimeSpentSeconds": time_spent,
                })

                quiz_qs    = [q for q in quiz_q_map.get(quiz_id, []) if q.get("QuestionText")]
                n_answered = random.randint(max(1, len(quiz_qs) - 2), len(quiz_qs)) if quiz_qs else 0

                for q in quiz_qs[:n_answered]:
                    qid   = q["Id"]
                    qtype = q["QuestionType"]
                    opts  = opt_map.get(qid, [])

                    sel_opt = None; written = None; is_correct = None; marks_awd = 0

                    if qtype in ("MCQ", "TrueFalse") and opts:
                        chosen_opt = maybe_null(random.choice(opts), 0.05)
                        if chosen_opt:
                            sel_opt    = chosen_opt["opt_id"]
                            is_correct = chosen_opt["is_correct"]
                            marks_awd  = (q["Marks"] or 1) if is_correct else 0
                    elif qtype == "ShortAnswer":
                        written = maybe_null(random.choice([
                            "The answer relates to the concept discussed.",
                            "I believe it is the first option.",
                            "Binary search works on sorted arrays.",
                            "Stack overflow occurs when recursion is too deep.",
                        ]), 0.10)
                        is_correct = maybe_null(random.choice([1, 0]), 0.20)
                        marks_awd  = maybe_null(round(random.uniform(0, q["Marks"] or 2), 1), 0.30)

                    answers_rows.append({
                        "Id":                 answer_id,
                        "QuizAttemptId":      attempt_id,
                        "QuestionId":         qid,
                        "SelectedOptionId":   sel_opt,
                        "WrittenAnswer":       written,
                        "IsCorrect":          is_correct,
                        "MarksAwarded":       marks_awd,
                        "InstructorFeedback": maybe_null("Good effort.", 0.80),
                    })
                    answer_id += 1

                attempt_id += 1

    for _ in range(50):
        attempts_rows.append({
            "Id": attempt_id, "QuizId": random.choice(valid_quiz_ids),
            "StudentId": random.randint(9000, 9999), "AttemptNumber": 1,
            "StartedAt": datetime(2024, 5, 1), "SubmittedAt": None,
            "Score": None, "MaxScore": 20, "ScorePercent": None,
            "Status": "InProgress", "IsGraded": 0,
            "GradedById": None, "GradedAt": None, "TimeSpentSeconds": None,
        })
        attempt_id += 1

    for d in random.sample(attempts_rows[:300], 60):
        dup       = d.copy()
        dup["Id"] = attempt_id
        attempts_rows.append(dup)
        attempt_id += 1

    df_attempts = pd.DataFrame(attempts_rows).sample(frac=1).reset_index(drop=True)
    df_answers  = pd.DataFrame(answers_rows).sample(frac=1).reset_index(drop=True)
    df_attempts.to_csv(output_dir / "quiz_attempts_dataset.csv",   index=False, sep=";")
    df_answers.to_csv(output_dir  / "student_answers_dataset.csv", index=False, sep=";")

    print(f"   done — {len(df_attempts):,} attempts, {len(df_answers):,} answers")
    return df_attempts, df_answers
