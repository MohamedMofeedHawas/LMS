VALIDATION_RULES = {
    "students": [
        {"col": "Id",                  "type": "no_null"},
        {"col": "DepartmentId",        "type": "range", "min": 1,    "max": 3},
        {"col": "YearId",              "type": "range", "min": 1,    "max": 4},
        {"col": "SquadronId",          "type": "range", "min": 1,    "max": 5},
        {"col": "AdmissionYear",       "type": "range", "min": 2018, "max": 2027},
        {"col": "EnrolledCourseCount", "type": "range", "min": 0,    "max": 9999},
    ],
    "activity_log": [
        {"col": "Id",               "type": "no_null"},
        {"col": "ActionName",       "type": "no_null"},
        {"col": "ProcessingTimeMs", "type": "range", "min": 0,   "max": 15000},
        {"col": "EngagementIndex",  "type": "range", "min": 0.0, "max": 1.0},
    ],
    "courses": [
        {"col": "Id",                  "type": "no_null"},
        {"col": "CreditHours",         "type": "range", "min": 1, "max": 6},
        {"col": "DepartmentId",        "type": "range", "min": 1, "max": 3},
        {"col": "ActualEnrolledCount", "type": "range", "min": 0, "max": 99999},
    ],
    "enrollments": [
        {"col": "StudentProfileId",    "type": "no_null"},
        {"col": "CourseId",            "type": "no_null"},
        {"col": "DaysSinceEnrollment", "type": "range", "min": 0, "max": 99999},
    ],
    "users": [
        {"col": "Id",               "type": "no_null"},
        {"col": "Email",            "type": "no_null"},
        {"col": "IsActive",         "type": "range", "min": 0, "max": 1},
        {"col": "AccessFailedCount","type": "range", "min": 0, "max": 10},
    ],
    "activities": [
        {"col": "Id",       "type": "no_null"},
        {"col": "CourseId", "type": "no_null"},
        {"col": "Title",    "type": "no_null"},
        {"col": "MaxGrade", "type": "range", "min": 1, "max": 500},
    ],
    "attempts": [
        {"col": "Id",        "type": "no_null"},
        {"col": "StudentId", "type": "no_null"},
        {"col": "QuizId",    "type": "no_null"},
    ],
    "submissions": [
        {"col": "Id",           "type": "no_null"},
        {"col": "AssignmentId", "type": "no_null"},
        {"col": "StudentId",    "type": "no_null"},
    ],
    "progress": [
        {"col": "Id",              "type": "no_null"},
        {"col": "ActivityId",      "type": "no_null"},
        {"col": "StudentId",       "type": "no_null"},
        {"col": "ProgressPercent", "type": "range", "min": 0, "max": 100},
    ],
    "notifications": [
        {"col": "Id",     "type": "no_null"},
        {"col": "Type",   "type": "no_null"},
        {"col": "IsRead", "type": "range", "min": 0, "max": 1},
    ],
}
