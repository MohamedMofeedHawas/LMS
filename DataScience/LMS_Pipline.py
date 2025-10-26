import pandas as pd

INPUT_FILE = 'dummy_audit_logs.csv'
OUTPUT_FILE = 'cleaned_audit_logs.csv'

# --- 1. Extract ---
def extract_data(file_path):
    print(f"Reading data from '{file_path}'")
    try:
        df = pd.read_csv(file_path)
        return df
    except FileNotFoundError:
        print(f"Error: File not found. Did you run 'create_dummy_logs.py' first?")
        return None

# --- 2. Transform ---
def transform_data(df):
    if df is None:
        return None
        
    print("Transforming data")
    df['UserId'] = df['UserId'].fillna(0).astype(int)
    df['IsActive'] = df['IsActive'].fillna(False)

    text_columns = ['Action', 'Description', 'EntityName', 'AcademicY', 'GroupName', 'ExtraDataIs']
    for col in text_columns:
        if col in df.columns:
            df[col] = df[col].fillna('Unknown')
    
    # Process 'CreatedAt' (Main timestamp)
    df['CreatedAt'] = pd.to_datetime(df['CreatedAt'], errors='coerce')
    df = df.dropna(subset=['CreatedAt'])
    # Process 'ExpiresAt' (convert to date, but keep NaT for NULLs)
    df['ExpiresAt'] = pd.to_datetime(df['ExpiresAt'], errors='coerce')

    # Divide Date into Date, days and hours
    df['EventDate'] = df['CreatedAt'].dt.date
    df['EventHour'] = df['CreatedAt'].dt.hour
    df['EventDay'] = df['CreatedAt'].dt.day_name()

    # Remove Duplicates
    df = df.drop_duplicates()
    
    # Reorder Columns (for better readability) 
    new_order = [
        'Id', 'UserId', 'CreatedAt', 'EventDate', 'EventHour', 'EventDay',
        'Action', 'Description', 'EntityName', 'GroupName', 'AcademicY',
        'ExtraDataIs', 'IsActive', 'ExpiresAt'
    ]
    final_order = [col for col in new_order if col in df.columns]
    df = df[final_order]

    print("Data transformation complete.")
    return df

# --- 3. Load ---
def load_data(df, output_path):
    if df is None:
        print("No data to load.")
        return
        
    df.to_csv(output_path, index=False, encoding='utf-8')
    print(f"Successfully saved cleaned data to '{output_path}'")

# --- Main function to run the pipeline ---
def main():
    print("Starting Data Pipeline")
    
    # 1. Extract
    raw_data = extract_data(INPUT_FILE)
    
    # 2. Transform
    cleaned_data = transform_data(raw_data)
    
    # 3. Load
    load_data(cleaned_data, OUTPUT_FILE)
    
    # This is the line I fixed:
    if cleaned_data is not None:
        print("\n Cleaned Data Sample (First 5 Rows) ")
        print(cleaned_data.head())
    
    print("Data Pipeline Finished ")

if __name__ == "__main__":
    main()
