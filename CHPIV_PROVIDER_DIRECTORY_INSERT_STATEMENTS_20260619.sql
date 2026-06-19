-- ================================================================================
	-- INSERT INTO CHPIV_PROVIDER_DIRECTORY_DATA FROM UPDATE TABLE
-- ================================================================================
USE INFORMATICS;

GO

-- ======================================
	-- MODIFICATION(S) / CHANGE.LOG: 
-- ======================================
-- C001: DESCRIPTION: INSERT records from CCIPA and ICPMG staging tables into main 

			/* - CHPIV_PROVIDER_DIRECTORY_DATA table
             
		SOURCE TABLES:
			- CHPIV_PROVIDER_DIRECTORY_DATA_UPDATE_CCIPA_20251210 (184 rows,23 columns)
			- CHPIV_PROVIDER_DIRECTORY_DATA_UPDATE_ICPMG_20251210 (163 rows,102 columns)
    
		DESTINATION TABLE:
			- CHPIV_PROVIDER_DIRECTORY_DATA (796 rows 107 columns total)

		NOTES:
			- CCIPA has 'MNAME' which maps to 'Mname' in destination (case difference)
			- CCIPA has 'ZIP' which maps to 'ZIPCODE' in destination
			- CCIPA will have NULL values for 81 columns not in source
			- ICPMG has 'MNAME' which maps to 'Mname' in destination
			- ICPMG will have NULL values for 3 columns (COUNTY,Telehealth_Indicator)
			- Added 'COUNTY' as 'Imperial' for both sources (business rule)
			- Added 'Telehealth_Indicator' as NULL (to be updated later per APL 25-014) */

		-- ⏎ Thank you,Excellent. My next task is to INSERT the resulting records FROM "CHPIV_PROVIDER_DIRECTORY_DATA_UPDATE_CCIPA_20251210" AND "CHPIV_PROVIDER_DIRECTORY_DATA_UPDATE_ICPMG_20251210" INTO "CHPIV_PROVIDER_DIRECTORY_DATA". If I provided you wit the TABLE DESIGN of each would you be able to assist in generating the INSERT INTO() SQL STATEMENTS? ... DRAG AND DROP FOR CONTEXT: 
				-- ~ LEVERAGE: "CHECKLIST_CHPIV_COMMUNITY_HEALTH_PLAN_OF_IMPERIAL_VALLEY_...sql"

-- C002: Insert records from the December 2025 full roster update into the main provider directory table

		/* SOURCE TABLE:
		  - CHPIV_PROVIDER_DIRECTORY_DATA_UPDATE_20251212 (901 rows,103 data columns + ID/audit)

		DESTINATION TABLE:
		  - CHPIV_PROVIDER_DIRECTORY_DATA (main consolidated table)

		NOTES:
		  - This update represents the combined full roster (CHPIV Direct + Primary Care Medical Group + others)
		  - Missing columns in source: COUNTY (set to 'Imperial' per business rule),Telehealth_Indicator (set to NULL - to be updated later per DHCS APL 25-014)
		  - Extra column in source: COL_103 (likely the trailing HOSPITAL_GRADE_QUALITY_DATA_LINK; ignored as it maps to existing column)
		  - NPI_NO cleaned with LTRIM/RTRIM for consistency
		  - Audit columns populated automatically */

		-- ⏎ Thank you,Excellent. My NEXT task IS TO INSERT the resulting records FROM "CHPIV_PROVIDER_DIRECTORY_DATA_UPDATE_20251212" INTO "CHPIV_PROVIDER_DIRECTORY_DATA". If I provided you with the TABLE DESIGN of each would you be able to assist in generating the INSERT INTO() SQL STATEMENTS? ... DRAG AND DROP FOR CONTEXT: 
				-- ~ LEVERAGE: "CHPIV_PROVIDER_DIRECTORY_INSERT_STATEMENTS_20251211.sql"
				-- ~ LEVERAGE: "CHPIV UPLOAD TABLE DESIGN 20251212.xlsx"
				-- ~ PLEASE PROVIDE the COMPLETE CODE.

-- C003: Network Analysis ADD - ON COLUMN(S) (# columns) ... CHPIV DIRECT NETWORK FILE DEVELOPMENT FOR MS JULIA AS PART OF PROVDIR PROCESS WITH ADDITIONAL FIELDS'

-- =====================================================
-- SECTION 1: PRE-INSERT VALIDATION
-- =====================================================
DECLARE @Update_Count INT;
DECLARE @Main_Count_Before INT;

SELECT @Update_Count = COUNT(*) 
FROM INFORMATICS.dbo.CHPIV_PROVIDER_DIRECTORY_DATA_UPDATE_20260619; -- 🔹 REMEMBER TO REPLACE() SUBSTITUTE() EXTERNAL FILE NAME: "CHPIV_PROVIDER_DIRECTORY_DATA_UPDATE_20260619"

SELECT @Main_Count_Before = COUNT(*) 
FROM INFORMATICS.dbo.CHPIV_PROVIDER_DIRECTORY_DATA; -- 🔹 REMEMBER TO REPLACE() SUBSTITUTE() EXTERNAL FILE NAME: "CHPIV_PROVIDER_DIRECTORY_DATA_UPDATE_20260619"

PRINT 'Source Table Count:';
PRINT '  Update Records ('+CONVERT(nvarchar(10),GETDATE(),112)+'): ' + CAST(@Update_Count AS VARCHAR(10));
PRINT '  Main Table Records (Before): ' + CAST(@Main_Count_Before AS VARCHAR(10));
PRINT '';
PRINT 'Expected Records After Insert: ' + CAST((@Main_Count_Before + @Update_Count) AS VARCHAR(10));PRINT '';
PRINT '';
PRINT '~ LEVERAGE "chpiv_provider_upload_...py": ' ;
PRINT '🔹 REMEMBER TO REPLACE() SUBSTITUTE() EXTERNAL FILE NAME: "CHPIV_PROVIDER_DIRECTORY_DATA_UPDATE_20260619"' ; 
PRINT '';

/* SELECT CAST(ImportedAt AS date) FROM INFORMATICS.dbo.CHPIV_PROVIDER_DIRECTORY_DATA GROUP BY CAST(ImportedAt AS date)  */

/* DELETE
-- SELECT ' ' AS 'DELETE TO RESET AND TEST INSERT INTO UPLOAD OF "CHPIV_PROVIDER_DIRECTORY_DATA_UPDATE_20260619"',*
-- SELECT TOP 100000 ' ' AS 'CHECK 1st',* -- ... FROM INFORMATICS.dbo.CHPIV_PROVIDER_DIRECTORY_DATA_UPDATE_20260619; -- LEVERAGE: "chpiv_fullroster_provider_upload_...py" AND "CHPIV Provider Directory Data to CHG 12_08_25.xlsx"
-- SELECT DISTINCT ' ' AS 'CHECK 1st',CAST(ImportedAt AS date) AS [ImportaAt] -- ... FROM INFORMATICS.dbo.CHPIV_PROVIDER_DIRECTORY_DATA_UPDATE_20260619; -- LEVERAGE: "chpiv_fullroster_provider_upload_...py" AND "CHPIV Provider Directory Data to CHG 12_08_25.xlsx"
FROM INFORMATICS.dbo.CHPIV_PROVIDER_DIRECTORY_DATA
WHERE 1=1
	AND CAST(ImportedAt AS date) = CAST('2026-01-20' AS date) */
	
-- =====================================================
-- SECTION 2: INSERT FROM UPDATE TABLE
-- =====================================================
BEGIN TRY
    BEGIN TRANSACTION;
    
    INSERT INTO dbo.CHPIV_PROVIDER_DIRECTORY_DATA
    ( -- INITIATE ...

	-- Core Provider Information (8 columns)	
	CITY
	,[GROUP]
	,SPECIALTY
	,LNAME
	,FNAME
	,Mname
	,TITLE
	,PHY_ID

	-- Address/Contact Information (5 columns)
	,ADDRESS
	,[STATE]
	,ZIPCODE
	,PHONE
	,HOURS

	-- Language Information (25 columns - CCIPA only has first language)
	,PHY_LANG01_PRV_LANG01
	,PHY_LANG02_PRV_LANG02
	,PHY_LANG03_PRV_LANG03
	,PHY_LANG04_PRV_LANG04
	,PHY_LANG05_PRV_LANG05
	,PHY_LANG06_PRV_LANG06
	,PHY_LANG07_PRV_LANG07
	,PHY_LANG08_PRV_LANG08
	,PHY_LANG09_PRV_LANG09
	,PHY_LANG10_PRV_LANG10
	,PHY_LANG11_PRV_LANG11
	,PHY_LANG12_PRV_LANG12
	,PHY_LANG13_PRV_LANG13
	,PHY_LANG14_PRV_LANG14
	,PHY_LANG15_PRV_LANG15
	,PHY_LANG16_PRV_LANG16
	,PHY_LANG17_PRV_LANG17
	,PHY_LANG18_PRV_LANG18
	,PHY_LANG19_PRV_LANG19
	,PHY_LANG20_PRV_LANG20
	,PHY_LANG21_PRV_LANG21
	,PHY_LANG22_PRV_LANG22
	,PHY_LANG23_PRV_LANG23
	,PHY_LANG24_PRV_LANG24
	,PHY_LANG25_PRV_LANG25

	-- Hospital/Certification (2 columns)
	,HOSP_NAME
	,CERTIFICATION

	-- Extender Information (16 columns - NULL for CCIPA)
	,EXT1A_LNAME
	,EXT1B_FNAME
	,EXT1C_MINITIAL
	,EXT1D_LICTYPE
	,EXT2A_LNAME
	,EXT2B_FNAME
	,EXT2C_MINITIAL
	,EXT2D_LICTYPE
	,EXT3A_LNAME
	,EXT3B_FNAME
	,EXT3C_MINITIAL
	,EXT3D_LICTYPE
	,EXT4A_LNAME
	,EXT4B_FNAME
	,EXT4C_MINITIAL
	,EXT4D_LICTYPE

	-- Administrative Information (7 columns)
	,SECTION_NO
	,DIR_ID
	,ACCEPT_NEW_PAT
	,PPG_NAME
	,CLNC_SER_TYP
	,PPG_ID
	,NPI_NO

	-- Accessibility Indicators (9 columns - NULL for CCIPA)
	-- ,ACCESS_REQ
	,PARKING_IND
	,EXT_BUILD_IND
	,INT_BUILD_IND
	,RESTROOM_IND
	,EXAMROOM_IND
	,EXAMTBL_IND
	,PATIENT_AREA_IND
	,PATIENT_DIA_IND

	-- Additional Provider Information (6 columns)
	,LIC_ID
	,EMAIL
	,BOARD_CERT_ID

	-- Office Language Information (15 columns - CCIPA only has first)
	,OFFICE_LANG01
	,OFFICE_LANG02
	,OFFICE_LANG03
	,OFFICE_LANG04
	,OFFICE_LANG05
	,OFFICE_LANG06
	,OFFICE_LANG07
	,OFFICE_LANG08
	,OFFICE_LANG09
	,OFFICE_LANG10
	,OFFICE_LANG11
	,OFFICE_LANG12
	,OFFICE_LANG13
	,OFFICE_LANG14
	,OFFICE_LANG15

	-- Provider Status/Preferences (6 columns)
	,SELF_ACCESS_FLAG
	,PHY_ALT_LNAME
	,PHY_ALT_FNAME
	,PHY_ALT_MNAME
	,WEBSITE
	,PHY_PANEL_STATUS

	-- Additional Contact (1 column)
	,AFTERHOUR_PHONE

	-- Provider Characteristics (4 columns)
	,PRV_CCT_IND_PHY_CCT_IND
	,GENDER
	,ACCR_TYPE
	,ACCR_DESC

	-- External Links (1 column)
	,HOSPITAL_GRADE_QUALITY_DATA_LINK

	-- Audit Columns (2 columns)
	,ImportedAt
	,ImportedBy

	-- Business Rule Columns (2 columns)
	,COUNTY
	,Telehealth_Indicator
	
	-- C003: Network Analysis ADD - ON COLUMN(S) (# columns) ... CHPIV DIRECT NETWORK FILE DEVELOPMENT FOR MS JULIA AS PART OF PROVDIR PROCESS WITH ADDITIONAL FIELDS'
	,[TAXONOMY CODE] -- decimal(10,0) NULL ; -- ORDINAL  1 | ⚠ KEY ANCHOR — CONFIRM INTENT
	,[TRAINING] -- nvarchar(255) NULL ; -- ORDINAL  2
	,[LOCATION NPI] -- decimal(10,0) NULL ; -- ORDINAL  3
	,[LOCATION NAME] -- nvarchar(25) NULL ; -- ORDINAL  4
	,[STAFFED BEDS] -- int NULL ; -- ORDINAL  5
	,[CULTURAL COMPETENCY] -- nvarchar(255) NULL ; -- ORDINAL  6	
	,[HCAI ID] -- nvarchar(25) NULL ; -- ORDINAL  7
    ) -- CONCLUDE ... 

	SELECT
	-- Core Provider Information (8 columns)	
	CITY
	,[GROUP]
	,SPECIALTY
	,LNAME
	,FNAME
	,Mname
	,TITLE
	,PHY_ID

	-- Address/Contact Information (5 columns)
	,ADDRESS -- FIELD REPLACED AS OF 20260608 CHPIV EXTERNAL IPA FILE
	-- ,ADDRESS_PHYSICAL
	,[STATE]
	,ZIPCODE
	,PHONE
	,HOURS

	-- Language Information (25 columns - CCIPA only has first language)
	,PHY_LANG01_PRV_LANG01
	,PHY_LANG02_PRV_LANG02
	,PHY_LANG03_PRV_LANG03
	,PHY_LANG04_PRV_LANG04
	,PHY_LANG05_PRV_LANG05
	,PHY_LANG06_PRV_LANG06
	,PHY_LANG07_PRV_LANG07
	,PHY_LANG08_PRV_LANG08
	,PHY_LANG09_PRV_LANG09
	,PHY_LANG10_PRV_LANG10
	,PHY_LANG11_PRV_LANG11
	,PHY_LANG12_PRV_LANG12
	,PHY_LANG13_PRV_LANG13
	,PHY_LANG14_PRV_LANG14
	,PHY_LANG15_PRV_LANG15
	,PHY_LANG16_PRV_LANG16
	,PHY_LANG17_PRV_LANG17
	,PHY_LANG18_PRV_LANG18
	,PHY_LANG19_PRV_LANG19
	,PHY_LANG20_PRV_LANG20
	,PHY_LANG21_PRV_LANG21
	,PHY_LANG22_PRV_LANG22
	,PHY_LANG23_PRV_LANG23
	,PHY_LANG24_PRV_LANG24
	,PHY_LANG25_PRV_LANG25

	-- Hospital/Certification (2 columns)
	-- ,SUBSTRING(STUFF(ISNULL(', ' +(LTRIM(RTRIM(HOSP_NAME1))),'') + ISNULL(', ' +(LTRIM(RTRIM(HOSP_NAME2))),''),1,2,''),1,255) AS [HOSP_NAME]
	,HOSP_NAME
	,CERTIFICATION

	-- Extender Information (16 columns - NULL for CCIPA)
	,EXT1A_LNAME
	,EXT1B_FNAME
	,EXT1C_MINITIAL
	,EXT1D_LICTYPE
	,EXT2A_LNAME
	,EXT2B_FNAME
	,EXT2C_MINITIAL
	,EXT2D_LICTYPE
	,EXT3A_LNAME
	,EXT3B_FNAME
	,EXT3C_MINITIAL
	,EXT3D_LICTYPE
	,EXT4A_LNAME
	,EXT4B_FNAME
	,EXT4C_MINITIAL
	,EXT4D_LICTYPE

	-- Administrative Information (7 columns)
	,SECTION_NO
	,DIR_ID
	,ACCEPT_NEW_PAT
	,PPG_NAME
	,CLNC_SER_TYP
	,PPG_ID
	,TRY_CONVERT(nvarchar(10),LTRIM(RTRIM(ISNULL(NPI_NO,'')))) AS NPI_NO

	-- Accessibility Indicators (9 columns - NULL for CCIPA)
	-- ,ACCESS_REQ
	,PARKING_IND
	,EXT_BUILD_IND
	,INT_BUILD_IND
	,RESTROOM_IND
	,EXAMROOM_IND
	,EXAMTBL_IND
	,PATIENT_AREA_IND
	,PATIENT_DIA_IND

	-- Additional Provider Information (6 columns)
	,LIC_ID
	,EMAIL
	,BOARD_CERT_ID

	-- Office Language Information (15 columns - CCIPA only has first)
	,OFFICE_LANG01
	,OFFICE_LANG02
	,OFFICE_LANG03
	,OFFICE_LANG04
	,OFFICE_LANG05
	,OFFICE_LANG06
	,OFFICE_LANG07
	,OFFICE_LANG08
	,OFFICE_LANG09
	,OFFICE_LANG10
	,OFFICE_LANG11
	,OFFICE_LANG12
	,OFFICE_LANG13
	,OFFICE_LANG14
	,OFFICE_LANG15

	-- Provider Status/Preferences (6 columns)
	,SELF_ACCESS_FLAG
	,PHY_ALT_LNAME
	,PHY_ALT_FNAME
	,PHY_ALT_MNAME
	,WEBSITE
	,NULL AS PHY_PANEL_STATUS

	-- Additional Contact (1 column)
	,AFTERHOUR_PHONE

	-- Provider Characteristics (4 columns)
	,NULL PRV_CCT_IND_PHY_CCT_IND
	,GENDER
	,ACCR_TYPE
	,ACCR_DESC

	-- External Links (1 column)
	,NULL AS [HOSPITAL_GRADE_QUALITY_DATA_LINK]

	-- Audit Columns (2 columns)
	,CAST(GETDATE() AS datetime2) AS ImportedAt
	,SYSTEM_USER AS ImportedBy

	-- Business Rule Columns (2 columns)
	,'Imperial' AS COUNTY -- Business rule: All CCIPA/ICPMG are Imperial County
	,NULL AS Telehealth_Indicator -- To be updated per DHCS APL 25-014

	-- C003: Network Analysis ADD - ON COLUMN(S) (# columns) ... CHPIV DIRECT NETWORK FILE DEVELOPMENT FOR MS JULIA AS PART OF PROVDIR PROCESS WITH ADDITIONAL FIELDS'
	,TRY_CONVERT(decimal(10, 0), LTRIM(RTRIM([TAXONOMY_CODE]))) AS [TAXONOMY CODE] -- decimal(10,0) NULL ; -- ORDINAL  1 | ⚠ KEY ANCHOR — CONFIRM INTENT
	,[TRAINING] AS [TRAINING] -- nvarchar(255) NULL ; -- ORDINAL  2
	,TRY_CONVERT(decimal(10, 0), NULL) AS [LOCATION NPI] -- decimal(10,0) NULL ; -- ORDINAL  3
	,NULL AS [LOCATION NAME] -- nvarchar(25) NULL ; -- ORDINAL  4
	,0 AS [STAFFED BEDS] -- int NULL ; -- ORDINAL  5
	,[CULTURAL_COMP] AS [CULTURAL COMPETENCY] -- nvarchar(255) NULL ; -- ORDINAL  6
	,TRY_CONVERT(nvarchar(25),NULL) AS [HCAI ID] -- ORDINAL  7 ... C###: UPDATE FOR MY204 AS OF 20250203 The DMHC’s standardized terminology is set forth in appendices A-F of the Annual Network Submission Instruction Manual for RY 2025. The health plan should also refer to the “Standardized Terminology and Other Reporting Resources” section of the Resources tab ON the Timely Access and Annual Network Reporting Web Portal for information ON standardized terminology resources. Please note, the DMHC relies ON the California Licensed Healthcare Facility Listing released by the California Department of Healthcare Access Information ('HCAI') to populate the Hospital and Other Inpatient Facility Name section of the Crosswalks tab. In addition, for RY 2025 the DMHC added a field for “'HCAI' ID” within the Hospital Report tab of the Hospital and Clinic Report Form. The “'HCAI' ID” field captures the unique identifier established by 'HCAI' to identify facilities used in the Licensed Facility Information System (LFIS). (See All Plan Letter (APL) 24-019.) The Plan may use the facility information provided ON www.'HCAI'.ca.gov to review its terminology and to identify the 'HCAI' ID for completing the Hospital and Clinic Report Form ... USE https://www.HCAI.ca.gov	

	FROM INFORMATICS.dbo.CHPIV_PROVIDER_DIRECTORY_DATA_UPDATE_20260619; -- LEVERAGE: "chpiv_fullroster_provider_upload_...py" AND "CHPIV Provider Directory Data to CHG 12_08_25.xlsx"

    DECLARE @Inserted INT = @@ROWCOUNT;
    
    COMMIT TRANSACTION;
    
    PRINT 'INSERT COMPLETED SUCCESSFULLY';
    PRINT '  Records Inserted: ' + CAST(@Inserted AS VARCHAR(10));
    PRINT '';
    
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION;
    
    PRINT 'ERROR INSERTING RECORDS:';
    PRINT '  Error Number: ' + CAST(ERROR_NUMBER() AS VARCHAR(10));
    PRINT '  Error Message: ' + ERROR_MESSAGE();
    PRINT '  Error Line: ' + CAST(ERROR_LINE() AS VARCHAR(10));
    PRINT '';
    
    THROW;
END CATCH;

-- =====================================================
-- SECTION 3: POST-INSERT VALIDATION
-- =====================================================
DECLARE @Main_Count_After INT;

SELECT @Main_Count_After = COUNT(*) 
FROM INFORMATICS.dbo.CHPIV_PROVIDER_DIRECTORY_DATA;

PRINT 'Final Record Counts:';
PRINT '  Main Table Records (After): ' + CAST(@Main_Count_After AS VARCHAR(10));
PRINT '  Total Records Added: ' + CAST((@Main_Count_After - @Main_Count_Before) AS VARCHAR(10));
PRINT '';

-- Verify by GROUP (recent imports)
PRINT 'Records by GROUP (recently inserted):';

SELECT [GROUP],COUNT(*) AS RecordCount
FROM INFORMATICS.dbo.CHPIV_PROVIDER_DIRECTORY_DATA
WHERE 1=1
	AND ImportedAt >= DATEADD(MINUTE,-30,GETDATE())  -- Adjust window as needed
GROUP BY [GROUP]
ORDER BY [GROUP];

-- Verify COUNTY assignment
PRINT '';
PRINT 'Records by COUNTY (recently inserted):';
SELECT COUNTY,COUNT(*) AS RecordCount
FROM INFORMATICS.dbo.CHPIV_PROVIDER_DIRECTORY_DATA
WHERE 1=1
	AND ImportedAt >= DATEADD(MINUTE,-30,GETDATE())
GROUP BY COUNTY
ORDER BY COUNTY;
-- =================================================================
-- INSERT PROCESS COMPLETED
-- =================================================================
GO
