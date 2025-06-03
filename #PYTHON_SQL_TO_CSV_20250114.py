import pandas as pd
import sqlalchemy as sa
from datetime import datetime
import os
from pathlib import Path
import sys
from tqdm import tqdm
import urllib.parse

# Configuration
SERVER = 'SQLPROD02'
DATABASE = 'INFORMATICS'
TABLE_NAME = 'DETAILDIRTYDENIALS'
ROWS_PER_FILE = 1000000  # 1 million rows per file - Excel can handle this
CHUNK_SIZE = 50000  # Processing chunk size

def create_engine():
    """Create SQLAlchemy engine using Windows Authentication"""
    params = urllib.parse.quote_plus(
        f'DRIVER={{SQL Server}};'
        f'SERVER={SERVER};'
        f'DATABASE={DATABASE};'
        f'Trusted_Connection=yes;'
    )
    return sa.create_engine(f'mssql+pyodbc:///?odbc_connect={params}')

def get_row_count(engine):
    """Get total number of rows in the table"""
    with engine.connect() as connection:
        result = connection.execute(sa.text(f"SELECT COUNT(*) FROM {DATABASE}.dbo.{TABLE_NAME}"))
        return result.scalar()

def export_to_excel_files():
    try:
        # Create engine
        engine = create_engine()
        
        # Get total rows for progress bar
        total_rows = get_row_count(engine)
        print(f"Total rows to export: {total_rows:,}")
        
        # Create output directory
        timestamp = datetime.now().strftime('%Y%m%d_%H%M%S')
        output_dir = Path(r"C:\Users\wcarr\Desktop") / f"DirtyDenials_{timestamp}"
        output_dir.mkdir(exist_ok=True)
        print(f"Creating output directory: {output_dir}")
        
        # Initialize progress bar
        pbar = tqdm(total=total_rows, unit='rows')
        
        # Export in chunks
        offset = 0
        current_file_rows = 0
        file_number = 1
        current_df = pd.DataFrame()
        
        while True:
            query = sa.text(f"""
                SELECT 
                    [CLINICAL MESSAGE(s) / MEMO(s) / NOTE(s)] as clinical_message,
                    [claimid],
                    [ClaimCleanliness]
                FROM {DATABASE}.dbo.{TABLE_NAME}
                ORDER BY [claimid]
                OFFSET :offset ROWS
                FETCH NEXT :chunk_size ROWS ONLY
            """)
            
            # Read chunk using SQLAlchemy
            df_chunk = pd.read_sql(
                query, 
                engine, 
                params={'offset': offset, 'chunk_size': CHUNK_SIZE}
            )
            
            if df_chunk.empty:
                # Save any remaining data
                if not current_df.empty:
                    output_file = output_dir / f"DirtyDenials_part{file_number}.xlsx"
                    current_df.to_excel(output_file, index=False, engine='openpyxl')
                break
            
            # Append chunk to current dataframe
            current_df = pd.concat([current_df, df_chunk])
            current_file_rows += len(df_chunk)
            
            # If we've reached the rows per file limit, save to Excel
            if current_file_rows >= ROWS_PER_FILE:
                output_file = output_dir / f"DirtyDenials_part{file_number}.xlsx"
                print(f"\nSaving part {file_number} to: {output_file}")
                current_df.to_excel(output_file, index=False, engine='openpyxl')
                
                # Reset for next file
                current_df = pd.DataFrame()
                current_file_rows = 0
                file_number += 1
            
            # Update progress
            pbar.update(len(df_chunk))
            offset += CHUNK_SIZE
            
            # Clear chunk memory
            del df_chunk
        
        pbar.close()
        print(f"\nExport completed successfully!")
        print(f"Files saved to: {output_dir}")
        
        # Create summary file
        summary_file = output_dir / "00_README.txt"
        with open(summary_file, 'w') as f:
            f.write(f"Export Summary\n")
            f.write(f"Date: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}\n")
            f.write(f"Total Records: {total_rows:,}\n")
            f.write(f"Files Created: {file_number}\n")
            f.write(f"Records per File: {ROWS_PER_FILE:,}\n")
        
    except Exception as e:
        print(f"Error: {str(e)}")
        sys.exit(1)

if __name__ == "__main__":
    print("Starting export process...")
    export_to_excel_files()