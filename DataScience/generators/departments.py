import pandas as pd
from pathlib import Path


def generate(output_dir: Path) -> pd.DataFrame:
    print("\n[1/18] Departments...")

    data = [
        {"Id": 1, "Name": "Computer Science",          "Description": "CS Department 2023",  "ImageUrl": "/uploads/departments/cs.png",       "HeadId": 101},
        {"Id": 2, "Name": "Artificial Intelligence",   "Description": "AI Department",        "ImageUrl": "/uploads/departments/ai.png",       "HeadId": 102},
        {"Id": 3, "Name": "Cyber Security",            "Description": "Security Department",  "ImageUrl": "/uploads/departments/security.png", "HeadId": 103},
        {"Id": 4, "Name": "Computer Science",          "Description": "Duplicate Name Test",  "ImageUrl": "/uploads/departments/cs2.png",      "HeadId": 104},
        {"Id": 5, "Name": "Data Science",              "Description": "",                     "ImageUrl": "/uploads/departments/ds.png",       "HeadId": 105},
        {"Id": 6, "Name": "Software Engineering 2025", "Description": "SE Batch 2025",        "ImageUrl": "/uploads/departments/se.png",       "HeadId": 106},
    ]

    df = pd.DataFrame(data)
    df.to_csv(output_dir / "departments_dataset.csv", index=False)
    print(f"   done — {len(df)} rows")
    return df
