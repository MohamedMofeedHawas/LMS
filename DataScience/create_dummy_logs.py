import pandas as pd 
import numpy as np 
import uuid # To make a different ID
import datetime # This is to work with dates and time

SIZE = 1000  

# 1.Definition of possible values ​​(the choices I will choose from)


possible_user_ids = list(range(1, 51))
possible_user_ids.append(np.nan)

possible_actions = [
    'User Login', 'User Logout', 'GET /api/courses', 
    'GET /api/courses/{id}/modules', 'POST /api/assignments/{id}/submit',
    'POST /api/assignments/{id}/grade', 'GET /api/grades', 
    'POST /api/forum/submit', 
    np.nan 
]

possible_descriptions = [
    'Student logged in successfully', 'Teacher accessed dashboard',
    'User viewed course list', 'Assignment submitted by user', 
    'Grade updated by teacher', 'User viewed grades page',
    'New post in discussion forum', 'Failed login attempt',
    np.nan
]

possible_entity_names = [
    'Authentication', 'Course', 'Assignment', 
    'Submission', 'Grade', 'ForumPost', 'User', 
    np.nan
]


possible_years = [
    'Basic',
    'Preparatory',
    'Intermediate',
    'Final',
    np.nan
] 

possible_groups = [
    'Math_Group_A',
    'Physics_Lab_B',
   'History_Seniors',
  'General_Forum',
  np.nan
] 
possible_clients = ['web_client', 'mobile_app', 'api', np.nan] 

# 2.Building the Data Dictionary

#building (Created_at)
start_date = pd.to_datetime('2025-10-01')
total_duration_string = '22D' 
max_seconds = int(pd.to_timedelta(total_duration_string).total_seconds())
random_seconds = np.random.randint(0, max_seconds, SIZE)
created_at_list = start_date + pd.to_timedelta(random_seconds, unit='s')

#building (Expire_at)
expires_at_list = []
for date in created_at_list:
    if np.random.rand() > 0.7:
        expires_at_list.append(date + pd.to_timedelta(7, unit='d'))
    else:
        expires_at_list.append(pd.NaT) 


# Each "key" is the name of the column, and the "value" is the data inside it.
data = {
    'Id': np.arange(1, SIZE + 1),
    
    'UserId': np.random.choice(possible_user_ids, SIZE),
    
    'Action': np.random.choice(possible_actions, SIZE),
    
    'Description': np.random.choice(possible_descriptions, SIZE),
   
    'EntityName': np.random.choice(possible_entity_names, SIZE),
    
    'Iti': [str(uuid.uuid4()) if np.random.rand() > 0.3 else np.nan for _ in range(SIZE)],
    
    'ExpiresAt': expires_at_list,
    
    'CreatedAt': created_at_list,
    
    'ExtraDataIs': np.random.choice(possible_clients, SIZE, p=[0.5, 0.3, 0.1, 0.1]),
    
    'AcademicY': np.random.choice(possible_years, SIZE, p=[0.25, 0.25, 0.20, 0.20, 0.1]),
    
    'GroupName': np.random.choice(possible_groups, SIZE, p=[0.2, 0.2, 0.1, 0.4, 0.1]),
    
    'IsActive': np.random.choice([True, False, np.nan], SIZE, p=[0.8, 0.1, 0.1]),
}

# 4.Convert data to DataFrame 
df_dummy = pd.DataFrame(data)
df_dummy['IsActive'] = df_dummy['IsActive'].astype('boolean')
duplicate_rows = df_dummy.sample(n=20)
df_dummy = pd.concat([df_dummy, duplicate_rows])
df_dummy = df_dummy.sample(frac=1).reset_index(drop=True)

# 5.Saving into file 
OUTPUT_FILE = 'dummy_audit_logs.csv'
print(f"\nSaving to '{OUTPUT_FILE}'")
df_dummy.to_csv(OUTPUT_FILE, 
                index=False, 
                encoding='utf-8', 
                date_format='%Y-%m-%d %H:%M:%S', 
                na_rep='NULL')

print(f"Done! Created '{OUTPUT_FILE}' with {len(df_dummy)} rows.")
