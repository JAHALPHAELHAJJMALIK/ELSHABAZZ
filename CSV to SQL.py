import csv
import os
import glob
import pyodbc
from datetime import datetime

# BEFORE EXECUTING THIS SCRIPT, CREATE TEMPORARY TABLE eg. "create-rawcsvresult-table-20240826.sql"
# Created temporary tables with EXPLICIT COLUMN DEFINITIONS for better DATA TYPE CONTROL AND PERFORMANCE optimization.
# ADD constraints and indexes where applicable for improved query performance.
#PERFORMANCE: ... If you find that IT IS s taking too long, you might consider increasing the batch size (currently set to 1000) to reduce the number of database commits.

#UPDATE *.csv FOR DESIRED SOURCE FILE WILDCARD '%%%'
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

# CREATE SQL TABLE: 
def create_table(cursor, table_name):
    sql_script = f"""
    USE INFORMATICS;  -- Replace with your actual database name
    
    -- Check if the table exists and drop it if it does
    IF OBJECT_ID('dbo.{table_name}', 'U') IS NOT NULL
        DROP TABLE dbo.{table_name};
    
    -- Create the table
    CREATE TABLE dbo.{table_name}
    (
        ID nvarchar(255),
        [Value Set Name] nvarchar(255),
        [Value Set Version] date,
        [Code] nvarchar(255),
        [Definition] nvarchar(1000),
        [Code System] nvarchar(255),
        [measure] nvarchar(255),
		
        -- Add any additional columns that are in your CSV files
        -- For example:
        -- Latitude FLOAT,
        -- Longitude FLOAT,
        -- FacilityType NVARCHAR(100),
        -- etc.
        
        -- BEST PRACTICE: to include audit columns
        ImportedAt DATETIME2 DEFAULT GETDATE()
    );
    
    -- Optionally, add any necessary permissions
    -- GRANT SELECT, INSERT, UPDATE, DELETE ON dbo.{table_name} TO YourUserOrRole;
    
    PRINT '{table_name} table has been created successfully.';
    """
    
    # Split the script into individual commands
    commands = sql_script.split(';')
    
    for command in commands:
        if command.strip():  # Skip empty commands
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

    all_files = glob.glob(os.path.join(input_path, "*IPPFUMFUA_*.csv"))
    if not all_files:
        raise ValueError(f"No matching CSV files found in {input_path}")

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

        # Create the table
        create_table(cursor, table_name)

        # Get column max lengths
        column_max_lengths = get_column_max_lengths(cursor, table_name)
        print("Column max lengths:", column_max_lengths)

        start_time = datetime.now()

		# UPDATE THE INSERT STATEMENT TO MATCH YOUR TABLE STRUCTURE
		# UPDATE THE [FIELD(S)] / COLUMN(S)  
		# UPDATE THE "?" TO MATCH FIELD / COLUMN COUNT()
		# PARAMETERIZED QUERY WITH EXPLICIT COLUMN NAMES
        insert_sql = f"""
        INSERT INTO {table_name} 
        (
        [ID],[Value Set Name],[Value Set Version],[Code],[Definition],[Code System],[measure]
        )
        VALUES (?,?,?,?,?,?,?)
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
                headers = next(reader, None)  # Assume first row is headers
                
                if not headers:
                    print(f"Warning: Empty file or unable to read headers: {file}")
                    continue

                expected_headers = [
                "ID","Value Set Name","Value Set Version","Code","Definition","Code System","measure"
                ]
                if headers != expected_headers:
                    print(f"Warning: CSV headers do not match expected structure in file: {file}")
                    print(f"Expected: {expected_headers}")
                    print(f"Found: {headers}")
                    continue
                
                max_lengths = [column_max_lengths.get(header, None) for header in headers]
                
                batch = []
                for row_num, row in enumerate(reader, start=2):
                    if len(row) != 7:  # Update this to match the expected number of columns
                        print(f"Warning: Row {row_num} in {file} has {len(row)} columns instead of 7. Skipping.")
                        continue
                    
                    truncated_row = truncate_data(row, max_lengths)
                    batch.append(tuple(truncated_row))
                    
                    if len(batch) >= batch_size:
                        try:
                            cursor.executemany(insert_sql, batch)
                            conn.commit()
                            processed_rows += len(batch)
                            print(f"Progress: {processed_rows}/{total_rows} rows ({processed_rows/total_rows*100:.2f}%)")
                        except pyodbc.DataError as e:
                            print(f"Error inserting batch: {e}")
                            for i, row in enumerate(batch):
                                try:
                                    cursor.execute(insert_sql, row)
                                    conn.commit()
                                    processed_rows += 1
                                except pyodbc.DataError as e:
                                    print(f"Error inserting row {row_num + i}: {e}")
                                    print(f"Problematic row: {row}")
                        batch = []
                
                # Insert any remaining rows
                if batch:
                    try:
                        cursor.executemany(insert_sql, batch)
                        conn.commit()
                        processed_rows += len(batch)
                    except pyodbc.DataError as e:
                        print(f"Error inserting final batch: {e}")
                        for i, row in enumerate(batch):
                            try:
                                cursor.execute(insert_sql, row)
                                conn.commit()
                                processed_rows += 1
                            except pyodbc.DataError as e:
                                print(f"Error inserting row {row_num + i}: {e}")
                                print(f"Problematic row: {row}")

            print(f"Finished processing: {file}")

        end_time = datetime.now()
        duration = end_time - start_time
        print(f"All data has been streamed to SQL database.")
        print(f"Total rows processed: {processed_rows}")
        print(f"Time taken: {duration}")

    except Exception as e:
        print(f"An error occurred: {e}")
        raise
    finally:
        if 'conn' in locals():
            conn.close()

# CONFIGURATION: UPDATE THESE VARIABLES: 
# eg. [PATH]: file:///C:/Users/wcarr/Desktop/
input_path = r"C:\Users\wcarr\Desktop"
table_name = "IPPFUMFUA"
connection_string = "DRIVER={SQL Server};SERVER=SQLPROD02;DATABASE=INFORMATICS;Trusted_Connection=yes;"

# Execute the function
if __name__ == "__main__":
    stream_csv_to_sql(input_path, table_name, connection_string)
