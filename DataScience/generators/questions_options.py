import random
from pathlib import Path

import pandas as pd

from config.settings import QUESTIONS_BANK
from utils.helpers import maybe_null, rand_uuid


Q_TYPES   = ["MCQ", "TrueFalse", "ShortAnswer"]
Q_WEIGHTS = [0.65, 0.20, 0.15]


def generate(output_dir: Path, valid_quiz_ids: list):
    print("\n[10/18] Questions...")
    print("\n[11/18] Question Options...")

    questions_rows = []
    options_rows   = []
    q_id   = 1
    opt_id = 1
    opt_map: dict[int, list] = {}

    for quiz_id in valid_quiz_ids:
        for q_num in range(random.randint(3, 15)):
            qtype = random.choices(Q_TYPES, weights=Q_WEIGHTS)[0]
            tmpl  = random.choice(QUESTIONS_BANK)
            marks = random.choice([1, 2, 2, 3, 5])
            if random.random() < 0.04:
                marks = random.choice([-1, 0, 100])

            questions_rows.append({
                "Id":             q_id,
                "QuizId":         quiz_id,
                "QuestionText":   tmpl[0] if random.random() > 0.03 else None,
                "QuestionTextAr": maybe_null(f"ترجمة: {tmpl[0][:30]}", 0.55),
                "QuestionType":   qtype,
                "Marks":          marks,
                "Explanation":    maybe_null(f"Because {tmpl[1]} is correct.", 0.50),
                "ExplanationAr":  maybe_null("الشرح بالعربية", 0.70),
                "SortOrder":      q_num + 1,
                "ImageUrl":       maybe_null(f"/uploads/questions/{rand_uuid()}.png", 0.85),
                "_correct_ans":   tmpl[1],
                "_wrong_opts":    tmpl[2],
            })

            if qtype == "MCQ":
                all_opts = [(tmpl[1], 1)] + [(w, 0) for w in tmpl[2][:3]]
                random.shuffle(all_opts)
                opt_map[q_id] = []
                for si, (txt, is_c) in enumerate(all_opts):
                    options_rows.append({
                        "Id": opt_id, "QuestionId": q_id,
                        "OptionText":   txt,
                        "OptionTextAr": maybe_null(f"خيار: {txt[:20]}", 0.55),
                        "IsCorrect": is_c, "SortOrder": si + 1,
                    })
                    opt_map[q_id].append({"opt_id": opt_id, "is_correct": is_c})
                    opt_id += 1

            elif qtype == "TrueFalse":
                correct_tf = random.choice(["True", "False"])
                opt_map[q_id] = []
                for si, txt in enumerate(["True", "False"]):
                    is_c = 1 if txt == correct_tf else 0
                    options_rows.append({
                        "Id": opt_id, "QuestionId": q_id,
                        "OptionText":   txt,
                        "OptionTextAr": "صح" if txt == "True" else "خطأ",
                        "IsCorrect": is_c, "SortOrder": si + 1,
                    })
                    opt_map[q_id].append({"opt_id": opt_id, "is_correct": is_c})
                    opt_id += 1

            q_id += 1

    for _ in range(30):
        questions_rows.append({
            "Id": q_id, "QuizId": random.randint(9000, 9999),
            "QuestionText": "Orphan question", "QuestionTextAr": None,
            "QuestionType": "MCQ", "Marks": 2,
            "Explanation": None, "ExplanationAr": None,
            "SortOrder": 99, "ImageUrl": None,
            "_correct_ans": "Unknown", "_wrong_opts": ["A", "B", "C"],
        })
        q_id += 1

    for d in random.sample(questions_rows[:200], 40):
        dup       = d.copy()
        dup["Id"] = q_id
        questions_rows.append(dup)
        q_id += 1

    df_questions = pd.DataFrame(questions_rows).drop(columns=["_correct_ans", "_wrong_opts"])
    df_questions = df_questions.sample(frac=1).reset_index(drop=True)
    df_questions.to_csv(output_dir / "questions_dataset.csv", index=False, sep=";")

    df_options = pd.DataFrame(options_rows).sample(frac=1).reset_index(drop=True)
    df_options.to_csv(output_dir / "question_options_dataset.csv", index=False, sep=";")

    valid_q_ids = [q["Id"] for q in questions_rows if q["QuizId"] in set(valid_quiz_ids)]

    print(f"   done — {len(df_questions):,} questions, {len(df_options):,} options")
    return df_questions, df_options, opt_map, valid_q_ids, questions_rows
