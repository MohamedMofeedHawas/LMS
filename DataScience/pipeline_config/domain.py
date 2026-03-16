DOMAIN = {
    "valid_department_ids":  {1.0, 2.0, 3.0},
    "valid_year_ids":        {1.0, 2.0, 3.0, 4.0},
    "valid_squadron_ids":    {1.0, 2.0, 3.0, 4.0, 5.0},
    "max_valid_squadron_id": 100,

    "admission_year_min":   2018,
    "admission_year_max":   2027,
    "credit_hours_min":     1,
    "credit_hours_max":     6,
    "processing_ms_min":    0,
    "days_since_enroll_min":0,
    "max_grade_min":        1,
    "max_grade_max":        500,
    "progress_pct_min":     0,
    "progress_pct_max":     100,
    "access_failed_max":    10,

    "guest_user_id":    -1,
    "system_enroll_id": -1,

    "invalid_course_fk_values": [9999, 8888, 7777],

    "valid_activity_types":       {"Lecture", "Quiz", "Assignment"},
    "valid_question_types":       {"MCQ", "TrueFalse", "ShortAnswer"},
    "valid_attempt_statuses":     {"Completed", "InProgress", "Abandoned"},
    "valid_submission_statuses":  {"Submitted", "Graded", "Late", "Draft", "Missing"},
    "valid_progress_statuses":    {"NotStarted", "InProgress", "Completed"},
    "valid_notification_types":   {
        "NewLecture", "QuizAvailable", "AssignmentDue",
        "GradeReleased", "CourseEnrollment", "SystemAlert", "Reminder",
    },
    "valid_genders":              {"Male", "Female"},
    "valid_difficulty_levels":    {"Easy", "Medium", "Hard"},
    "valid_summary_statuses":     {"Done", "Pending", "Failed"},
    "valid_grading_modes":        {"Auto", "Manual"},
    "valid_quiz_scopes":          {"FullCourse", "SingleLecture", "MultiLecture"},
    "valid_content_types":        {"Pdf", "Video"},

    "null_strategies": {
        "students": {
            "DepartmentId":  "mode",
            "YearId":        "mode",
            "SquadronId":    "mode",
            "AdmissionYear": "mode",
        },
        "activity_log": {
            "UserId":           -1,
            "EntityId":         -1,
            "Description":      "No description",
            "IpAddress":        "Unknown",
            "UserAgent":        "Unknown",
            "ProcessingTimeMs": "median",
            "Metadata":         "{}",
            "EntityName":       "Unknown",
        },
        "courses": {
            "DepartmentId":  "mode",
            "YearId":        "mode",
            "InstructorId":  "mode",
            "Description":   "No description",
        },
        "enrollments": {
            "EnrolledById": -1,
        },
        "squadrons": {
            "Description": "No description",
        },
        "departments": {
            "Description": "No description",
        },
        "years": {},
        "users": {
            "FullName":   "Unknown",
            "Gender":     "Unknown",
            "City":       "Unknown",
            "NationalId": "Unknown",
        },
        "activities": {
            "Title":        "Untitled",
            "Description":  "No description",
            "MaxGrade":     "median",
            "PassingScore": "median",
        },
        "attempts": {
            "TimeSpentSeconds": "median",
            "GradedById":       -1,
        },
        "answers": {
            "IsCorrect":   -1,
            "MarksAwarded": 0,
        },
        "submissions": {
            "Grade":      "median",
            "Feedback":   "No feedback",
            "GradedById": -1,
        },
        "progress": {
            "TotalTimeSpentSeconds": "median",
        },
        "notifications": {
            "UserId": -1,
            "Title":  "System Notification",
            "Body":   "No details",
        },
        "comments": {
            "UserId":  -1,
            "Content": "[no content]",
        },
    },

    "dedup_keys": {
        "students":     ["Id"],
        "activity_log": ["Id"],
        "courses":      ["Id"],
        "enrollments":  ["StudentProfileId", "CourseId"],
        "years":        ["DepartmentId", "AcademicYear", "Name"],
        "squadrons":    ["Id"],
        "departments":  ["Name"],
        "users":        ["Id"],
        "activities":   ["Id"],
        "questions":    ["Id"],
        "options":      ["QuestionId", "OptionText"],
        "attempts":     ["StudentId", "QuizId", "AttemptNumber"],
        "answers":      ["QuizAttemptId", "QuestionId"],
        "submissions":  ["StudentId", "AssignmentId"],
        "progress":     ["StudentId", "ActivityId"],
        "notifications":["Id"],
        "comments":     ["Id"],
        "likes":        ["CommentId", "UserId"],
    },

    "risk_weight_no_enrollment":  0.6,
    "risk_weight_low_credits":    0.4,
    "risk_low_credit_threshold":  2,

    "engagement_activity_weight": 0.6,
    "engagement_speed_weight":    0.4,

    "department_names": {
        1: "Computer Science",
        2: "Artificial Intelligence",
        3: "Cyber Security",
    },
    "year_level_names": {
        1: "First Year",
        2: "Second Year",
        3: "Third Year",
        4: "Fourth Year",
    },
    "activity_type_labels": {
        "Lecture":    "Lecture",
        "Quiz":       "Quiz",
        "Assignment": "Assignment",
    },
}
