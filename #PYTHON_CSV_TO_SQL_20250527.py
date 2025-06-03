import csv
import os
import glob
import pyodbc
from datetime import datetime

# BEFORE EXECUTING THIS SCRIPT, CREATE TEMPORARY TABLE eg. "create-rawcsvresult-table-20240826.sql"
# Created temporary tables with EXPLICIT COLUMN DEFINITIONS for better DATA TYPE CONTROL AND PERFORMANCE optimization.
# ADD constraints and indexes where applicable for improved query performance.
# PERFORMANCE: ... If you find that it is taking too long, you might consider increasing the batch size (currently set to 1000)
# CHARINDEX() FIND SEARCH() 'UPDATE HERE:' MARKERS TO MAKE NECESSARY CODE UPDATE(S)

def detect_encoding(file_path, chunk_size=4096):
    encodings = ['utf-8', 'iso-8859-1', 'windows-1252', 'utf-16']
    for encoding in encodings:
        try:
            with open(file_path, 'rb') as file:
                while True:
                    chunk = file.read(chunk_size)
                    if not chunk:
                        return encoding
                    chunk.decode(encoding)
        except UnicodeDecodeError:
            continue
    return None

def count_rows(file_path, encoding):
    with open(file_path, 'r', encoding=encoding, errors='replace') as f:
        return sum(1 for _ in f) - 1  # Subtract 1 to exclude header

def truncate_data(data, max_lengths):
    return [str(item)[:length] if length else str(item) for item, length in zip(data, max_lengths)]

def get_column_max_lengths(cursor, table_name):
    cursor.execute(f"""
    SELECT COLUMN_NAME, CHARACTER_MAXIMUM_LENGTH
    FROM INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_NAME = '{table_name}'
    ORDER BY ORDINAL_POSITION
    """)
    return {row.COLUMN_NAME: row.CHARACTER_MAXIMUM_LENGTH for row in cursor.fetchall()}

def create_table(cursor, table_name):
    # UPDATE HERE: Modified table structure to match XWALK PROFDEG PVDRLICCERT.csv columns
    sql_script = f"""
    USE INFORMATICS;
    
    IF OBJECT_ID('dbo.{table_name}', 'U') IS NOT NULL
        DROP TABLE dbo.{table_name};
    
    CREATE TABLE dbo.{table_name}
    (
        -- UPDATE HERE: Columns updated to match XWALK PROFDEG PVDRLICCERT.csv structure
        [evips_TypeofLicensure] nvarchar(50),
        [symphonyXWALK] nvarchar(50),
        [Description] nvarchar(255),
        [Active_eVIPs_Degree_Code] nvarchar(50),
        [PVDRLICCERT] nvarchar(50),
        [NOTE] nvarchar(500),
        ImportedAt DATETIME2 DEFAULT GETDATE(),
        ImportedBy nvarchar(50) DEFAULT SYSTEM_USER
    );
    """
    
    commands = sql_script.split(';')
    
    for command in commands:
        if command.strip():
            try:
                cursor.execute(command)
            except pyodbc.Error as e:
                print(f"Error executing SQL command: {e}")
                print(f"Command: {command}")
    
    cursor.commit()
    print(f"Table {table_name} has been created or recreated.")

def stream_csv_to_sql(input_path, table_name, connection_string, batch_size=1000):
    if not os.path.exists(input_path):
        raise ValueError(f"Input path does not exist: {input_path}")

    # UPDATE HERE: MODIFIED THE FILE PATTERN TO MATCH XWALK PROFDEG PVDRLICCERT.csv FILENAME PATTERN
    all_files = glob.glob(os.path.join(input_path, "XWALK PROFDEG PVDRLICCERT.csv"))
    if not all_files:
        raise ValueError(f"No matching CSV files found in {input_path}. Looking for: XWALK PROFDEG PVDRLICCERT.csv")

    total_rows = 0
    processed_rows = 0

    # Count total rows
    for file in all_files:
        encoding = detect_encoding(file)
        if encoding:
            total_rows += count_rows(file, encoding)
        else:
            print(f"Warning: Unable to determine encoding for {file}. Skipping.")

    print(f"Total rows to process: {total_rows}")

    try:
        conn = pyodbc.connect(connection_string, timeout=30)
        cursor = conn.cursor()

        create_table(cursor, table_name)
        column_max_lengths = get_column_max_lengths(cursor, table_name)
        print("Column max lengths:", column_max_lengths)

        start_time = datetime.now()

        # UPDATE HERE: MODIFIED THE INSERT STATEMENT TO MATCH XWALK PROFDEG PVDRLICCERT TABLE COLUMNS
        insert_sql = f"""
        INSERT INTO {table_name} 
        (
            -- UPDATE HERE: LIST ALL COLUMNS FOR XWALK PROFDEG PVDRLICCERT
            [evips_TypeofLicensure], [symphonyXWALK], [Description], [Active_eVIPs_Degree_Code], 
            [PVDRLICCERT], [NOTE]
        )
        -- UPDATE HERE: 6 QUESTION MARKS TO MATCH THE 6 DATA COLUMNS
        VALUES (?,?,?,?,?,?)
        """

        for file in all_files:
            print(f"Processing file: {file}")
            encoding = detect_encoding(file)
            if not encoding:
                print(f"Warning: Unable to determine encoding for {file}. Skipping.")
                continue

            print(f"Using encoding: {encoding}")
            with open(file, 'r', encoding=encoding, errors='replace') as infile:
                reader = csv.reader(infile)
                headers = next(reader, None)
                
                if not headers:
                    print(f"Warning: Empty file or unable to read headers: {file}")
                    continue

                # UPDATE HERE: MODIFIED EXPECTED HEADERS TO MATCH XWALK PROFDEG PVDRLICCERT.csv STRUCTURE
                expected_headers = [
                    "evips TypeofLicensure", "symphonyXWALK", "Descrption", "Active eVIPs Degree Code",
                    "PVDRLICCERT", "NOTE"
                ]
                
                print(f"CSV Headers found: {headers}")
                print(f"Expected headers: {expected_headers}")
                
                # Create mapping for max lengths based on actual headers
                max_lengths = []
                for header in headers:
                    # Clean header name to match database column names
                    clean_header = header.strip()
                    if clean_header == "evips TypeofLicensure":
                        max_lengths.append(column_max_lengths.get("evips_TypeofLicensure", None))
                    elif clean_header == "symphonyXWALK":
                        max_lengths.append(column_max_lengths.get("symphonyXWALK", None))
                    elif clean_header == "Descrption":  # Note: CSV has typo "Descrption"
                        max_lengths.append(column_max_lengths.get("Description", None))
                    elif clean_header == "Active eVIPs Degree Code":
                        max_lengths.append(column_max_lengths.get("Active_eVIPs_Degree_Code", None))
                    elif clean_header == "PVDRLICCERT":
                        max_lengths.append(column_max_lengths.get("PVDRLICCERT", None))
                    elif clean_header == "NOTE":
                        max_lengths.append(column_max_lengths.get("NOTE", None))
                    else:
                        max_lengths.append(None)
                
                batch = []
                for row_num, row in enumerate(reader, start=2):
                    if len(row) != 6:  # UPDATE HERE: MODIFIED THE COLUMN COUNT CHECK TO MATCH 6 COLUMNS
                        print(f"Warning: Row {row_num} in {file} has {len(row)} columns instead of 6. Skipping.")
                        continue
                    
                    try:
                        # UPDATE HERE: MODIFIED DATA TYPE CONVERSIONS TO MATCH XWALK PROFDEG PVDRLICCERT COLUMN TYPES
                        processed_row = [
                            row[0].strip() if row[0] else None,  # evips TypeofLicensure
                            row[1].strip() if row[1] else None,  # symphonyXWALK
                            row[2].strip() if row[2] else None,  # Description (from "Descrption")
                            row[3].strip() if row[3] else None,  # Active eVIPs Degree Code
                            row[4].strip() if row[4] else None,  # PVDRLICCERT
                            row[5].strip() if row[5] else None   # NOTE
                        ]
                        
                        # Print sample of processed rows for debugging
                        if row_num <= 5:
                            print(f"Sample processed row {row_num}:", processed_row)
                        
                        truncated_row = truncate_data(processed_row, max_lengths)
                        batch.append(tuple(truncated_row))
                        
                        if len(batch) >= batch_size:
                            try:
                                cursor.executemany(insert_sql, batch)
                                conn.commit()
                                processed_rows += len(batch)
                                print(f"Progress: {processed_rows}/{total_rows} rows ({processed_rows/total_rows*100:.2f}%)")
                                batch = []
                            except pyodbc.Error as e:
                                print(f"Error inserting batch: {e}")
                                # Try inserting rows one by one to identify problematic rows
                                for i, single_row in enumerate(batch):
                                    try:
                                        cursor.execute(insert_sql, single_row)
                                        conn.commit()
                                        processed_rows += 1
                                    except pyodbc.Error as row_error:
                                        print(f"Error inserting row {row_num - len(batch) + i}: {row_error}")
                                        print(f"Problematic row data: {single_row}")
                                batch = []
                    
                    except (ValueError, IndexError) as e:
                        print(f"Error processing row {row_num}: {e}")
                        print(f"Raw row data: {row}")
                        continue
                
                if batch:
                    try:
                        cursor.executemany(insert_sql, batch)
                        conn.commit()
                        processed_rows += len(batch)
                    except pyodbc.Error as e:
                        print(f"Error inserting final batch: {e}")
                        for i, single_row in enumerate(batch):
                            try:
                                cursor.execute(insert_sql, single_row)
                                conn.commit()
                                processed_rows += 1
                            except pyodbc.Error as row_error:
                                print(f"Error inserting row: {row_error}")
                                print(f"Problematic row data: {single_row}")

            print(f"Finished processing: {file}")

        end_time = datetime.now()
        duration = end_time - start_time
        print(f"All data has been streamed to SQL database.")
        print(f"Total rows processed: {processed_rows}")
        print(f"Time taken: {duration}")
        
        # Validation query to verify data upload
        cursor.execute(f"SELECT COUNT(*) as RecordCount FROM {table_name}")
        final_count = cursor.fetchone().RecordCount
        print(f"Final record count in database: {final_count}")
        
        # Display sample of uploaded data
        cursor.execute(f"SELECT TOP 5 * FROM {table_name} ORDER BY ImportedAt DESC")
        sample_rows = cursor.fetchall()
        print("\nSample of uploaded data:")
        for row in sample_rows:
            print(row)

    except Exception as e:
        print(f"An error occurred: {e}")
        raise
    finally:
        if 'conn' in locals():
            conn.close()

# UPDATE HERE: UPDATED THESE VARIABLES FOR XWALK PROFDEG PVDRLICCERT.csv ENVIRONMENT AND FILE NAMING
input_path = r"C:\Users\wcarr\Desktop"
table_name = "symphonyXWALKprofdegpvdrliccert"
connection_string = "DRIVER={SQL Server};SERVER=SQLPRODAPP01;DATABASE=INFORMATICS;Trusted_Connection=yes;"

# Execute the function
if __name__ == "__main__":
    print("=" * 80)
    print("XWALK PROFDEG PVDRLICCERT.csv to SQL Server Upload Script")
    print("=" * 80)
    print(f"Source File: {os.path.join(input_path, 'XWALK PROFDEG PVDRLICCERT.csv')}")
    print(f"Target Table: SQLPRODAPP01.INFORMATICS.dbo.{table_name}")
    print("=" * 80)
    
    try:
        stream_csv_to_sql(input_path, table_name, connection_string)
        print("\n" + "=" * 80)
        print("✓ UPLOAD COMPLETED SUCCESSFULLY!")
        print("=" * 80)
    except Exception as e:
        print("\n" + "=" * 80)
        print("✗ UPLOAD FAILED!")
        print(f"Error: {e}")
        print("=" * 80)