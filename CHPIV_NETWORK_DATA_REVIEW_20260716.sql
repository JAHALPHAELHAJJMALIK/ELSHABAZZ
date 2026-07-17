-- ================================================================================
	-- INSERT INTO CHPIV_NETWORK_DATA FROM UPDATE TABLE: 
-- ================================================================================
USE INFORMATICS;

GO

-- ======================================
	-- MODIFICATION(S) / CHANGE.LOG: 
-- ======================================

-- C001: REMOVE 'CHPIV Direct' providers coming via the EXTERNAL file per CONVERSATIONS WITH MS JOHANNA 20260116 - SUBJECT:"*RE: CHPIV Network Data Alignment - RE: Confirming Alignment on Expectations*"

		/* STEP07: 'CHPIV_NETWORK_DATA_REVIEW_...sql' - ;EXEC IN [SQLPRODAPP01]; -- INCORPORATED INTO SSA (SQL SERVER AGENT) JOB "Provider Directory refresh sequence -The regular script has executed we may now proceed with the DirectoryExpert step" IN SQLPRODAPP01
				USE [PATH]: file://fileserver01/CHPIV/Provider%20Directory%20Updates/Outgoing/ - DATA REFRESH HERE THEN MANUAL DELIVERY VIA eMAIL 'SUBJECT:RE: CHPIV Network Data Alignment - RE: Confirming Alignment on Expectations' */

-- C002: PHARMACY ADDITION AS OF 20260226

-- C003: Network Analysis ADD - ON COLUMN(S) (# columns) ... CHPIV DIRECT NETWORK FILE DEVELOPMENT FOR MS JULIA AS PART OF PROVDIR PROCESS WITH ADDITIONAL FIELDS'

-- =====================================================
	-- SECTION 1: PRE-INSERT VALIDATION: 
-- =====================================================
--------------------------------------------------------------------------------------------------------------------
	-- Error Trapping: Check If Permanent Table(s) Already Exist(s) And Drop If Applicable --
--------------------------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS INFORMATICS.dbo.CHPIV_NETWORK_DATA;

SELECT chpiv.* 
,CAST(NULL AS nvarchar(255)) AS [Accessibility Codes]
,TRY_CONVERT(nvarchar(255),'EXTERNAL CHPIV ROSTER xlsx FILE') AS [Data Sourced From] -- '"CHPIV Direct Provider Directory" OR "EXTERNAL CHPIV ROSTER xlsx FILE"' AS '[Data Sourced From] OPTIONS: '
INTO INFORMATICS.dbo.CHPIV_NETWORK_DATA
-- SELECT TOP 100000 ' ' AS 'CHECK 1st',* 
-- SELECT DISTINCT ' ' AS 'CHECK 1st',ISNULL([GROUP],'') AS [GROUP]
FROM INFORMATICS.dbo.CHPIV_PROVIDER_DIRECTORY_DATA AS chpiv -- LEVERAGE: "CHPIV Provider Directory Data to CHG 9_18_25_PROPER_CASE.xlsx" AND "CHPIV PROVDIR CONDITIONAL LINE ITEM.png" AND "CHPIV Provider Directory Data to CHG 12_08_25.xlsx"  AND ...
	INNER JOIN 
	( -- INITIATE ...
	SELECT ' ' AS 'ISO ON MAX GROUP RECORD: '
	,ISNULL([GROUP],'') AS [RefreshGROUP]
	,MAX(CAST(ImportedAt AS date)) AS [RefreshRecordDate]
	FROM INFORMATICS.dbo.CHPIV_PROVIDER_DIRECTORY_DATA
	GROUP BY ISNULL([GROUP],'')
	) -- CONCLUDE ...
	AS isorefreshset ON ISNULL(chpiv.[GROUP],'') = isorefreshset.[RefreshGROUP]
		AND CAST(chpiv.ImportedAt AS date) = isorefreshset.[RefreshRecordDate]
	INNER JOIN 
	( -- INITIATE ...
	SELECT ' ' AS 'ISO ON MAX GROUP, NPI RECORD: '
	,ISNULL([GROUP],'') AS [RefreshGROUP]
	,TRY_CONVERT(nvarchar(10),LTRIM(RTRIM(ISNULL(NPI_NO,'')))) AS [RefreshNPI_NO]
	,MAX(CAST(ImportedAt AS date)) AS [RefreshRecordDate]
	FROM INFORMATICS.dbo.CHPIV_PROVIDER_DIRECTORY_DATA
	GROUP BY ISNULL([GROUP],''),TRY_CONVERT(nvarchar(10),LTRIM(RTRIM(ISNULL(NPI_NO,''))))
	) -- CONCLUDE ...
	AS iso ON ISNULL(chpiv.[GROUP],'') = iso.[RefreshGROUP]
		AND TRY_CONVERT(nvarchar(10),LTRIM(RTRIM(ISNULL(chpiv.NPI_NO,'')))) = iso.[RefreshNPI_NO]
		AND CAST(chpiv.ImportedAt AS date) = iso.[RefreshRecordDate]
WHERE 1=1
	AND ISNULL([GROUP],'') NOT IN ('CHPIV Direct') -- NO NOT NEGATIVE <> != ... C001: REMOVE 'CHPIV Direct' providers coming via the EXTERNAL file per CONVERSATIONS WITH MS JOHANNA 20260116 - SUBJECT:"*RE: CHPIV Network Data Alignment - RE: Confirming Alignment on Expectations*"

ALTER TABLE INFORMATICS.dbo.CHPIV_NETWORK_DATA
DROP COLUMN ID;  -- ONLY IF SAFE; BACKUP DATA FIRST IF TABLE HAS EXISTING ROWS

ALTER TABLE INFORMATICS.dbo.CHPIV_NETWORK_DATA
ADD ID int IDENTITY(1,1) NOT NULL PRIMARY KEY;  -- GENERATE SEQUENTIAL ID ... IDENTITY(INT,[SEED],[INCREMENT])

DECLARE @Update_Count INT;
DECLARE @Main_Count_Before INT;

SELECT @Update_Count = COUNT(*) 
FROM INFORMATICS.dbo.PROVDIR_PCP
WHERE 1=1
	AND [Participating Network] IN ('CHPIV-DSNP');

SELECT @Main_Count_Before = COUNT(*) 
FROM INFORMATICS.dbo.CHPIV_NETWORK_DATA;

PRINT 'Source Table Count:';
PRINT '  Update Records ('+CONVERT(nvarchar(10),GETDATE(),112)+'): ' + CAST(@Update_Count AS VARCHAR(10))+' PLUS +';
PRINT '  Main Table Records (Before): ' + CAST(@Main_Count_Before AS VARCHAR(10));
PRINT '';
PRINT 'Expected Records After Insert: ' + CAST((@Main_Count_Before + @Update_Count) AS VARCHAR(10))+' PLUS +';
PRINT '';
PRINT '~ LEVERAGE: "CHPIV Provider Directory Data Roster With Schedule 20251211.xlsx": ' ;
PRINT '';

-- =====================================================
	-- TABLE DESIGN: 
-- =====================================================
/* USE INFORMATICS

SELECT c.TABLE_CATALOG+'.'+c.TABLE_SCHEMA+'.'+c.TABLE_NAME AS 'TABLE DESIGN: CHPIV_PROVIDER_DIRECTORY_DATA'
,c.COLUMN_NAME
,c.DATA_TYPE
,c.IS_NULLABLE
,c.CHARACTER_MAXIMUM_LENGTH
,c.NUMERIC_PRECISION
,c.NUMERIC_SCALE
,c.COLUMN_DEFAULT
,c.ORDINAL_POSITION
,tc.CONSTRAINT_TYPE
,tc.CONSTRAINT_NAME
FROM INFORMATION_SCHEMA.COLUMNS AS c (NOLOCK) 
		LEFT JOIN INFORMATION_SCHEMA.KEY_COLUMN_USAGE AS kcu (NOLOCK) ON c.COLUMN_NAME = kcu.COLUMN_NAME 
			AND c.TABLE_NAME = kcu.TABLE_NAME
		LEFT JOIN INFORMATION_SCHEMA.TABLE_CONSTRAINTS AS tc (NOLOCK) ON kcu.CONSTRAINT_NAME = tc.CONSTRAINT_NAME
WHERE 1=1
	AND c.TABLE_CATALOG IN ('INFORMATICS') -- AS [db] 'DatabaseName'
	AND c.TABLE_SCHEMA = 'dbo' 
	AND c.TABLE_NAME = 'CHPIV_PROVIDER_DIRECTORY_DATA'
ORDER BY c.COLUMN_NAME,c.ORDINAL_POSITION;

		SELECT TOP 1  ' ' AS 'SAMPLE - CHPIV IPA ROSTER DATA: ',* 
		FROM INFORMATICS.dbo.CHPIV_PROVIDER_DIRECTORY_DATA;

		SELECT DISTINCT [GROUP]
		FROM INFORMATICS.dbo.CHPIV_PROVIDER_DIRECTORY_DATA
		
		SELECT DISTINCT 'Directory Section Number:  A (mental health), 1 (Primary Care Providers), 2 (Ob/Gyn), 3 (Hospitals), 4 (Specialists), 5 (Ancillaries), 7 (Skilled Nursing Facilities), 8 (Urgent Care Centers)' AS [MESSAGE(S)]
		,SECTION_NO
		,SPECIALTY 
		FROM INFORMATICS.dbo.CHPIV_PROVIDER_DIRECTORY_DATA		

		SELECT CAST(ImportedAt AS date) 
		,COUNT(1) AS [Record(s)]
		FROM INFORMATICS.dbo.CHPIV_PROVIDER_DIRECTORY_DATA 
		GROUP BY CAST(ImportedAt AS date)
		SELECT * FROM INFORMATICS.dbo.CHPIV_NETWORK_DATA

-- =====================================================
	-- TABLE DESIGN: 
-- =====================================================
USE INFORMATICS

SELECT c.TABLE_CATALOG+'.'+c.TABLE_SCHEMA+'.'+c.TABLE_NAME AS 'TABLE DESIGN: CHPIV_NETWORK_DATA'
,c.COLUMN_NAME
,c.DATA_TYPE
,c.IS_NULLABLE
,c.CHARACTER_MAXIMUM_LENGTH
,c.NUMERIC_PRECISION
,c.NUMERIC_SCALE
,c.COLUMN_DEFAULT
,c.ORDINAL_POSITION
,tc.CONSTRAINT_TYPE
,tc.CONSTRAINT_NAME
FROM INFORMATION_SCHEMA.COLUMNS AS c (NOLOCK) 
		LEFT JOIN INFORMATION_SCHEMA.KEY_COLUMN_USAGE AS kcu (NOLOCK) ON c.COLUMN_NAME = kcu.COLUMN_NAME 
			AND c.TABLE_NAME = kcu.TABLE_NAME
		LEFT JOIN INFORMATION_SCHEMA.TABLE_CONSTRAINTS AS tc (NOLOCK) ON kcu.CONSTRAINT_NAME = tc.CONSTRAINT_NAME
WHERE 1=1
	AND c.TABLE_CATALOG IN ('INFORMATICS') -- AS [db] 'DatabaseName'
	AND c.TABLE_SCHEMA = 'dbo' 
	AND c.TABLE_NAME = 'CHPIV_NETWORK_DATA'
ORDER BY c.COLUMN_NAME,c.ORDINAL_POSITION;

		SELECT TOP 1 ' ' AS 'SAMPLE - CHPIV DIRECT + IPA ROSTER NETWORK DATA: ',* FROM INFORMATICS.dbo.CHPIV_NETWORK_DATA;

-- =====================================================
	-- TABLE DESIGN: 
-- =====================================================
USE INFORMATICS

SELECT c.TABLE_CATALOG+'.'+c.TABLE_SCHEMA+'.'+c.TABLE_NAME AS 'TABLE DESIGN: PROVDIR_...'
,c.COLUMN_NAME
,c.DATA_TYPE
,c.IS_NULLABLE
,c.CHARACTER_MAXIMUM_LENGTH
,c.NUMERIC_PRECISION
,c.NUMERIC_SCALE
,c.COLUMN_DEFAULT
,c.ORDINAL_POSITION
,tc.CONSTRAINT_TYPE
,tc.CONSTRAINT_NAME
FROM INFORMATION_SCHEMA.COLUMNS AS c (NOLOCK) 
		LEFT JOIN INFORMATION_SCHEMA.KEY_COLUMN_USAGE AS kcu (NOLOCK) ON c.COLUMN_NAME = kcu.COLUMN_NAME 
			AND c.TABLE_NAME = kcu.TABLE_NAME
		LEFT JOIN INFORMATION_SCHEMA.TABLE_CONSTRAINTS AS tc (NOLOCK) ON kcu.CONSTRAINT_NAME = tc.CONSTRAINT_NAME
WHERE 1=1
	AND c.TABLE_CATALOG IN ('INFORMATICS') -- AS [db] 'DatabaseName'
	AND c.TABLE_SCHEMA = 'dbo' 
	AND c.TABLE_NAME = 'PROVDIR_PCP'
ORDER BY c.COLUMN_NAME,c.ORDINAL_POSITION;

		SELECT TOP 1 ' ' AS 'SAMPLE - PROVDIR_... PEOPLE TABLE DATA: ',SUBSTRING(CSZ,CHARINDEX(',',CSZ,1)+1,3) AS [STATE],* FROM INFORMATICS.dbo.PROVDIR_PCP WHERE 1=1 AND [Participating Network] IN ('CHPIV-DSNP');

		SELECT TOP 1 ' ' AS 'SAMPLE - PROVDIR_... PLACES TABLE DATA: ',SUBSTRING(CSZ,CHARINDEX(',',CSZ,1)+1,3) AS [STATE],* FROM INFORMATICS.dbo.PROVDIR_HOSGENERALACUTE WHERE 1=1 AND [Participating Network] IN ('CHPIV-DSNP'); */

-- =====================================================
-- SECTION 2: INSERT FROM UPDATE TABLE
-- =====================================================
BEGIN TRY
    BEGIN TRANSACTION;
    
    INSERT INTO INFORMATICS.dbo.CHPIV_NETWORK_DATA
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
	,ACCESS_REQ
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
	,[Accessibility Codes]
	,[Data Sourced From]

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
	,[HCAI ID] -- nvarchar(25) NULL ; -- ORDINAL  7 ... C###: UPDATE FOR MY204 AS OF 20250203 The DMHC’s standardized terminology is set forth in appendices A-F of the Annual Network Submission Instruction Manual for RY 2025. The health plan should also refer to the “Standardized Terminology and Other Reporting Resources” section of the Resources tab ON the Timely Access and Annual Network Reporting Web Portal for information ON standardized terminology resources. Please note, the DMHC relies ON the California Licensed Healthcare Facility Listing released by the California Department of Healthcare Access Information ('HCAI') to populate the Hospital and Other Inpatient Facility Name section of the Crosswalks tab. In addition, for RY 2025 the DMHC added a field for “'HCAI' ID” within the Hospital Report tab of the Hospital and Clinic Report Form. The “'HCAI' ID” field captures the unique identifier established by 'HCAI' to identify facilities used in the Licensed Facility Information System (LFIS). (See All Plan Letter (APL) 24-019.) The Plan may use the facility information provided ON www.'HCAI'.ca.gov to review its terminology and to identify the 'HCAI' ID for completing the Hospital and Clinic Report Form ... USE https://www.HCAI.ca.gov
	
    ) -- CONCLUDE 

	SELECT peopleandplaces.*
	FROM 
	( -- INITIATE ...
	SELECT DISTINCT  -- PEOPLE / INDIVIDUAL(S)
		-- Core Provider Information (8 columns)	
	CITYIs AS CITY
	-- ,TRY_CONVERT(nvarchar(255),NULL) AS [GROUP]
	,TRY_CONVERT(nvarchar(255),people.[Participating Network]) AS [GROUP]
	,SPEC AS SPECIALTY
	,SUBSTRING(INDEXNM,1,CHARINDEX(',',INDEXNM,1) - 1) AS LNAME
	,LTRIM( SUBSTRING(INDEXNM,CHARINDEX(',', INDEXNM) + 1,CHARINDEX(',', INDEXNM, CHARINDEX(',', INDEXNM) + 1)- CHARINDEX(',', INDEXNM) - 1 )) AS FNAME
	,MiddleName AS Mname
	-- ,TypeOfLicensure AS TITLE
	-- ,RIGHT(LTRIM(RTRIM(ISNULL(INDEXNM,''))),2) AS TITLE
	,INDEXNM AS TITLE
	,lookup_key AS PHY_ID -- practitionerid

	-- Address/Contact Information (5 columns)
	,[Address]
	,SUBSTRING(CSZ,CHARINDEX(',',CSZ,1)+1,3) AS [STATE]
	,[ZIP] AS ZIPCODE
	,[Telephone Number] AS PHONE
	,[Office Hour(s)] AS HOURS

	-- Language Information (25 columns - CCIPA only has first language)
	,Language1 AS PHY_LANG01_PRV_LANG01
	,Language2 AS PHY_LANG02_PRV_LANG02
	,Language3 AS PHY_LANG03_PRV_LANG03
	,Language4 AS PHY_LANG04_PRV_LANG04
	,Language5 AS PHY_LANG05_PRV_LANG05
	,TRY_CONVERT(nvarchar(255),NULL) AS PHY_LANG06_PRV_LANG06
	,TRY_CONVERT(nvarchar(255),NULL) AS PHY_LANG07_PRV_LANG07
	,TRY_CONVERT(nvarchar(255),NULL) AS PHY_LANG08_PRV_LANG08
	,TRY_CONVERT(nvarchar(255),NULL) AS PHY_LANG09_PRV_LANG09
	,TRY_CONVERT(nvarchar(255),NULL) AS PHY_LANG10_PRV_LANG10
	,TRY_CONVERT(nvarchar(255),NULL) AS PHY_LANG11_PRV_LANG11
	,TRY_CONVERT(nvarchar(255),NULL) AS PHY_LANG12_PRV_LANG12
	,TRY_CONVERT(nvarchar(255),NULL) AS PHY_LANG13_PRV_LANG13
	,TRY_CONVERT(nvarchar(255),NULL) AS PHY_LANG14_PRV_LANG14
	,TRY_CONVERT(nvarchar(255),NULL) AS PHY_LANG15_PRV_LANG15
	,TRY_CONVERT(nvarchar(255),NULL) AS PHY_LANG16_PRV_LANG16
	,TRY_CONVERT(nvarchar(255),NULL) AS PHY_LANG17_PRV_LANG17
	,TRY_CONVERT(nvarchar(255),NULL) AS PHY_LANG18_PRV_LANG18
	,TRY_CONVERT(nvarchar(255),NULL) AS PHY_LANG19_PRV_LANG19
	,TRY_CONVERT(nvarchar(255),NULL) AS PHY_LANG20_PRV_LANG20
	,TRY_CONVERT(nvarchar(255),NULL) AS PHY_LANG21_PRV_LANG21
	,TRY_CONVERT(nvarchar(255),NULL) AS PHY_LANG22_PRV_LANG22
	,TRY_CONVERT(nvarchar(255),NULL) AS PHY_LANG23_PRV_LANG23
	,TRY_CONVERT(nvarchar(255),NULL) AS PHY_LANG24_PRV_LANG24
	,TRY_CONVERT(nvarchar(255),NULL) AS PHY_LANG25_PRV_LANG25

	-- Hospital/Certification (2 columns)
	,[FINALhosp_FULL_NAME] AS HOSP_NAME
	,'N/A' AS CERTIFICATION

	-- Extender Information (16 columns - NULL for CCIPA)
	,TRY_CONVERT(nvarchar(255),NULL) AS EXT1A_LNAME
	,TRY_CONVERT(nvarchar(255),NULL) AS EXT1B_FNAME
	,TRY_CONVERT(nvarchar(255),NULL) AS EXT1C_MINITIAL
	,TRY_CONVERT(nvarchar(100),NULL) AS EXT1D_LICTYPE
	,TRY_CONVERT(nvarchar(255),NULL) AS EXT2A_LNAME
	,TRY_CONVERT(nvarchar(255),NULL) AS EXT2B_FNAME
	,TRY_CONVERT(nvarchar(255),NULL) AS EXT2C_MINITIAL
	,TRY_CONVERT(nvarchar(100),NULL) AS EXT2D_LICTYPE
	,TRY_CONVERT(nvarchar(255),NULL) AS EXT3A_LNAME
	,TRY_CONVERT(nvarchar(255),NULL) AS EXT3B_FNAME
	,TRY_CONVERT(nvarchar(255),NULL) AS EXT3C_MINITIAL
	,TRY_CONVERT(nvarchar(100),NULL) AS EXT3D_LICTYPE
	,TRY_CONVERT(nvarchar(255),NULL) AS EXT4A_LNAME
	,TRY_CONVERT(nvarchar(255),NULL) AS EXT4B_FNAME
	,TRY_CONVERT(nvarchar(255),NULL) AS EXT4C_MINITIAL
	,TRY_CONVERT(nvarchar(100),NULL) AS EXT4D_LICTYPE

	-- Administrative Information (7 columns)
	,CHAPTER_NAME AS SECTION_NO
	,COUNTY AS DIR_ID
	,[ACCEPTING NEW PATIENTS] AS ACCEPT_NEW_PAT
	,DBA AS PPG_NAME
	,PROVIDER_TYPE AS CLNC_SER_TYP
	,DBAPracticeID AS PPG_ID
	,TRY_CONVERT(nvarchar(10),LTRIM(RTRIM(ISNULL(NPIis,'')))) AS NPI_NO

	-- Accessibility Indicators (9 columns - NULL for CCIPA)
	,Accessibility AS ACCESS_REQ
	,TRY_CONVERT(nvarchar(255),NULL) AS PARKING_IND
	,TRY_CONVERT(nvarchar(255),NULL) AS EXT_BUILD_IND
	,TRY_CONVERT(nvarchar(255),NULL) AS INT_BUILD_IND
	,TRY_CONVERT(nvarchar(255),NULL) AS RESTROOM_IND
	,TRY_CONVERT(nvarchar(255),NULL) AS EXAMROOM_IND
	,TRY_CONVERT(nvarchar(255),NULL) AS EXAMTBL_IND
	,TRY_CONVERT(nvarchar(255),NULL) AS PATIENT_AREA_IND
	,TRY_CONVERT(nvarchar(255),NULL) AS PATIENT_DIA_IND

	-- Additional Provider Information (6 columns)
	,CA_License AS LIC_ID
	,EMAILis AS EMAIL
	,CASE
	WHEN [BOARD CERTIFIED] LIKE '%YES%'
	THEN 'Y'
	ELSE 'N'
	END AS BOARD_CERT_ID

	-- Office Language Information (15 columns - CCIPA only has first)
	,TRY_CONVERT(nvarchar(255),NULL) AS OFFICE_LANG01
	,TRY_CONVERT(nvarchar(255),NULL) AS OFFICE_LANG02
	,TRY_CONVERT(nvarchar(255),NULL) AS OFFICE_LANG03
	,TRY_CONVERT(nvarchar(255),NULL) AS OFFICE_LANG04
	,TRY_CONVERT(nvarchar(255),NULL) AS OFFICE_LANG05
	,TRY_CONVERT(nvarchar(255),NULL) AS OFFICE_LANG06
	,TRY_CONVERT(nvarchar(255),NULL) AS OFFICE_LANG07
	,TRY_CONVERT(nvarchar(255),NULL) AS OFFICE_LANG08
	,TRY_CONVERT(nvarchar(255),NULL) AS OFFICE_LANG09
	,TRY_CONVERT(nvarchar(255),NULL) AS OFFICE_LANG10
	,TRY_CONVERT(nvarchar(255),NULL) AS OFFICE_LANG11
	,TRY_CONVERT(nvarchar(255),NULL) AS OFFICE_LANG12
	,TRY_CONVERT(nvarchar(255),NULL) AS OFFICE_LANG13
	,TRY_CONVERT(nvarchar(255),NULL) AS OFFICE_LANG14
	,TRY_CONVERT(nvarchar(255),NULL) AS OFFICE_LANG15

	-- Provider Status/Preferences (6 columns)
	,TRY_CONVERT(nvarchar(1),NULL) AS SELF_ACCESS_FLAG
	,TRY_CONVERT(nvarchar(255),NULL) AS PHY_ALT_LNAME
	,TRY_CONVERT(nvarchar(255),NULL) AS PHY_ALT_FNAME
	,TRY_CONVERT(nvarchar(50),NULL) AS PHY_ALT_MNAME
	,URL_WEBSITE AS WEBSITE
	,CASE
	WHEN [ACCEPTING NEW PATIENTS] LIKE 'Y%'
	THEN 'E'
	ELSE 'J'
	END AS PHY_PANEL_STATUS

	-- Additional Contact (1 column)
	,AFTERHOURS_PHONE AS AFTERHOUR_PHONE

	-- Provider Characteristics (4 columns)
	,'N/A' AS PRV_CCT_IND_PHY_CCT_IND
	,[Provider Gender] AS [Gender]
	,TRY_CONVERT(nvarchar(255),NULL) AS ACCR_TYPE
	,ACCREDITATION_BY AS ACCR_DESC

	-- External Links (1 column)
	,TRY_CONVERT(nvarchar(255),NULL) AS HOSPITAL_GRADE_QUALITY_DATA_LINK

	-- Audit Columns (2 columns)
	,CAST(GETDATE() AS datetime2) AS ImportedAt
	,SYSTEM_USER AS ImportedBy
	,[Accessibility Category(ies)] AS [Accessibility Codes]
	,'CHPIV Direct Provider Directory' AS [Data Sourced From]

	-- Business Rule Columns (2 columns)
	,COUNTY -- Business rule: All CCIPA/ICPMG are Imperial County
	,Telehealth_Indicator -- To be updated per DHCS APL 25-014
	
	-- C003: Network Analysis ADD - ON COLUMN(S) (# columns) ... CHPIV DIRECT NETWORK FILE DEVELOPMENT FOR MS JULIA AS PART OF PROVDIR PROCESS WITH ADDITIONAL FIELDS'
	,TRY_CONVERT(decimal(10, 0), NULL) AS [TAXONOMY CODE] -- decimal(10,0) NULL ; -- ORDINAL  1 | ⚠ KEY ANCHOR — CONFIRM INTENT
	,NULL AS [TRAINING] -- nvarchar(255) NULL ; -- ORDINAL  2
	,TRY_CONVERT(decimal(10, 0), NULL) AS [LOCATION NPI] -- decimal(10,0) NULL ; -- ORDINAL  3
	,NULL AS [LOCATION NAME] -- nvarchar(25) NULL ; -- ORDINAL  4
	,0 AS [STAFFED BEDS] -- int NULL ; -- ORDINAL  5
	,NULL AS [CULTURAL COMPETENCY] -- nvarchar(255) NULL ; -- ORDINAL  6
	,NULL AS [HCAI ID] -- nvarchar(25) NULL ; -- ORDINAL  7 ... C###: UPDATE FOR MY204 AS OF 20250203 The DMHC’s standardized terminology is set forth in appendices A-F of the Annual Network Submission Instruction Manual for RY 2025. The health plan should also refer to the “Standardized Terminology and Other Reporting Resources” section of the Resources tab ON the Timely Access and Annual Network Reporting Web Portal for information ON standardized terminology resources. Please note, the DMHC relies ON the California Licensed Healthcare Facility Listing released by the California Department of Healthcare Access Information ('HCAI') to populate the Hospital and Other Inpatient Facility Name section of the Crosswalks tab. In addition, for RY 2025 the DMHC added a field for “'HCAI' ID” within the Hospital Report tab of the Hospital and Clinic Report Form. The “'HCAI' ID” field captures the unique identifier established by 'HCAI' to identify facilities used in the Licensed Facility Information System (LFIS). (See All Plan Letter (APL) 24-019.) The Plan may use the facility information provided ON www.'HCAI'.ca.gov to review its terminology and to identify the 'HCAI' ID for completing the Hospital and Clinic Report Form ... USE https://www.HCAI.ca.gov

	FROM
	( -- INITIATE ...
	SELECT *
	-- SELECT TOP 10 ' ' AS 'CHECK 1st',CSZ,*
	-- SELECT DISTINCT ' ' AS 'CHECK 1st',CSZ,SUBSTRING(CSZ,1,CHARINDEX(',',CSZ,1)-1) AS 'CSZCity',SUBSTRING(CSZ,CHARINDEX(',',CSZ,1)+1,3) AS 'CSZState',RIGHT(CSZ,5) AS 'CSZZip'
	FROM INFORMATICS.dbo.PROVDIR_PCP --PROV(s)

	UNION /* DISTINCT() */ 
	SELECT *
	-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
	-- SELECT DISTINCT ' ' AS 'CHECK 1st',CSZ,SUBSTRING(CSZ,1,CHARINDEX(',',CSZ,1)-1) AS 'CSZCity',SUBSTRING(CSZ,CHARINDEX(',',CSZ,1)+1,3) AS 'CSZState',RIGHT(CSZ,5) AS 'CSZZip'
	FROM INFORMATICS.dbo.PROVDIR_NPMP --PROV(s)

	UNION /* DISTINCT() */ 
	SELECT *
	-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
	-- SELECT DISTINCT ' ' AS 'CHECK 1st',CSZ,SUBSTRING(CSZ,1,CHARINDEX(',',CSZ,1)-1) AS 'CSZCity',SUBSTRING(CSZ,CHARINDEX(',',CSZ,1)+1,3) AS 'CSZState',RIGHT(CSZ,5) AS 'CSZZip'
	FROM INFORMATICS.dbo.PROVDIR_SPE --PROV(s)

	UNION /* DISTINCT() */ 
	SELECT *
	-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
	-- SELECT DISTINCT ' ' AS 'CHECK 1st',CSZ,SUBSTRING(CSZ,1,CHARINDEX(',',CSZ,1)-1) AS 'CSZCity',SUBSTRING(CSZ,CHARINDEX(',',CSZ,1)+1,3) AS 'CSZState',RIGHT(CSZ,5) AS 'CSZZip'
	FROM INFORMATICS.dbo.PROVDIR_MH --PROV(s)

	UNION /* DISTINCT() */ 
	SELECT *
	-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
	-- SELECT DISTINCT ' ' AS 'CHECK 1st',CSZ,SUBSTRING(CSZ,1,CHARINDEX(',',CSZ,1)-1) AS 'CSZCity',SUBSTRING(CSZ,CHARINDEX(',',CSZ,1)+1,3) AS 'CSZState',RIGHT(CSZ,5) AS 'CSZZip'
	FROM INFORMATICS.dbo.PROVDIR_AHP --PROV(s)

	UNION /* DISTINCT() */ 
	SELECT *
	-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
	-- SELECT DISTINCT ' ' AS 'CHECK 1st',CSZ,SUBSTRING(CSZ,1,CHARINDEX(',',CSZ,1)-1) AS 'CSZCity',SUBSTRING(CSZ,CHARINDEX(',',CSZ,1)+1,3) AS 'CSZState',RIGHT(CSZ,5) AS 'CSZZip'
	FROM INFORMATICS.dbo.PROVDIR_VSP --PROV(s)
	) -- CONCLUDE ...
	AS people
	WHERE 1=1
		AND people.[Participating Network] IN ('CHPIV-DSNP')
		-- AND NOT people.COUNTY LIKE '%SAN%DIEG%'; -- NO NOT NEGATIVE <> != ...
		
	UNION ALL
	SELECT DISTINCT  -- FACILITIY(-IES) / PLACES
		-- Core Provider Information (8 columns)	
	CITYIs AS CITY
	-- ,TRY_CONVERT(nvarchar(255),NULL) AS [GROUP]
	,TRY_CONVERT(nvarchar(255),places.[Participating Network]) AS [GROUP]
	,SPEC AS SPECIALTY
	,ISNULL(HospitalName,INDEXNM) AS LNAME
	,TRY_CONVERT(nvarchar(255),NULL) AS FNAME -- FOR PEOPLE ONLY!!!
	,TRY_CONVERT(nvarchar(255),NULL) AS Mname
	-- ,TypeOfLicensure AS TITLE
	-- ,RIGHT(LTRIM(RTRIM(ISNULL(INDEXNM,''))),2) AS TITLE
	,INDEXNM AS TITLE
	,lookup_key AS PHY_ID -- practitionerid

	-- Address/Contact Information (5 columns)
	,[Address]
	,SUBSTRING(CSZ,CHARINDEX(',',CSZ,1)+1,3) AS [STATE]
	,[ZIP] AS ZIPCODE
	,[Telephone Number] AS PHONE
	,[Office Hour(s)] AS HOURS

	-- Language Information (25 columns - CCIPA only has first language)
	,Language1 AS PHY_LANG01_PRV_LANG01
	,Language2 AS PHY_LANG02_PRV_LANG02
	,Language3 AS PHY_LANG03_PRV_LANG03
	,Language4 AS PHY_LANG04_PRV_LANG04
	,Language5 AS PHY_LANG05_PRV_LANG05
	,TRY_CONVERT(nvarchar(255),NULL) AS PHY_LANG06_PRV_LANG06
	,TRY_CONVERT(nvarchar(255),NULL) AS PHY_LANG07_PRV_LANG07
	,TRY_CONVERT(nvarchar(255),NULL) AS PHY_LANG08_PRV_LANG08
	,TRY_CONVERT(nvarchar(255),NULL) AS PHY_LANG09_PRV_LANG09
	,TRY_CONVERT(nvarchar(255),NULL) AS PHY_LANG10_PRV_LANG10
	,TRY_CONVERT(nvarchar(255),NULL) AS PHY_LANG11_PRV_LANG11
	,TRY_CONVERT(nvarchar(255),NULL) AS PHY_LANG12_PRV_LANG12
	,TRY_CONVERT(nvarchar(255),NULL) AS PHY_LANG13_PRV_LANG13
	,TRY_CONVERT(nvarchar(255),NULL) AS PHY_LANG14_PRV_LANG14
	,TRY_CONVERT(nvarchar(255),NULL) AS PHY_LANG15_PRV_LANG15
	,TRY_CONVERT(nvarchar(255),NULL) AS PHY_LANG16_PRV_LANG16
	,TRY_CONVERT(nvarchar(255),NULL) AS PHY_LANG17_PRV_LANG17
	,TRY_CONVERT(nvarchar(255),NULL) AS PHY_LANG18_PRV_LANG18
	,TRY_CONVERT(nvarchar(255),NULL) AS PHY_LANG19_PRV_LANG19
	,TRY_CONVERT(nvarchar(255),NULL) AS PHY_LANG20_PRV_LANG20
	,TRY_CONVERT(nvarchar(255),NULL) AS PHY_LANG21_PRV_LANG21
	,TRY_CONVERT(nvarchar(255),NULL) AS PHY_LANG22_PRV_LANG22
	,TRY_CONVERT(nvarchar(255),NULL) AS PHY_LANG23_PRV_LANG23
	,TRY_CONVERT(nvarchar(255),NULL) AS PHY_LANG24_PRV_LANG24
	,TRY_CONVERT(nvarchar(255),NULL) AS PHY_LANG25_PRV_LANG25

	-- Hospital/Certification (2 columns)
	,[FINALhosp_FULL_NAME] AS HOSP_NAME
	,'N/A' AS CERTIFICATION

	-- Extender Information (16 columns - NULL for CCIPA)
	,TRY_CONVERT(nvarchar(255),NULL) AS EXT1A_LNAME
	,TRY_CONVERT(nvarchar(255),NULL) AS EXT1B_FNAME
	,TRY_CONVERT(nvarchar(255),NULL) AS EXT1C_MINITIAL
	,TRY_CONVERT(nvarchar(100),NULL) AS EXT1D_LICTYPE
	,TRY_CONVERT(nvarchar(255),NULL) AS EXT2A_LNAME
	,TRY_CONVERT(nvarchar(255),NULL) AS EXT2B_FNAME
	,TRY_CONVERT(nvarchar(255),NULL) AS EXT2C_MINITIAL
	,TRY_CONVERT(nvarchar(100),NULL) AS EXT2D_LICTYPE
	,TRY_CONVERT(nvarchar(255),NULL) AS EXT3A_LNAME
	,TRY_CONVERT(nvarchar(255),NULL) AS EXT3B_FNAME
	,TRY_CONVERT(nvarchar(255),NULL) AS EXT3C_MINITIAL
	,TRY_CONVERT(nvarchar(100),NULL) AS EXT3D_LICTYPE
	,TRY_CONVERT(nvarchar(255),NULL) AS EXT4A_LNAME
	,TRY_CONVERT(nvarchar(255),NULL) AS EXT4B_FNAME
	,TRY_CONVERT(nvarchar(255),NULL) AS EXT4C_MINITIAL
	,TRY_CONVERT(nvarchar(100),NULL) AS EXT4D_LICTYPE

	-- Administrative Information (7 columns)
	,CHAPTER_NAME AS SECTION_NO
	,COUNTY AS DIR_ID
	,[ACCEPTING NEW PATIENTS] AS ACCEPT_NEW_PAT
	,DBA AS PPG_NAME
	,PROVIDER_TYPE AS CLNC_SER_TYP
	,[Clinic QNXT provid] AS PPG_ID
	,TRY_CONVERT(nvarchar(10),LTRIM(RTRIM(ISNULL(NPIis,'')))) AS NPI_NO

	-- Accessibility Indicators (9 columns - NULL for CCIPA)
	,Accessibility AS ACCESS_REQ
	,TRY_CONVERT(nvarchar(255),NULL) AS PARKING_IND
	,TRY_CONVERT(nvarchar(255),NULL) AS EXT_BUILD_IND
	,TRY_CONVERT(nvarchar(255),NULL) AS INT_BUILD_IND
	,TRY_CONVERT(nvarchar(255),NULL) AS RESTROOM_IND
	,TRY_CONVERT(nvarchar(255),NULL) AS EXAMROOM_IND
	,TRY_CONVERT(nvarchar(255),NULL) AS EXAMTBL_IND
	,TRY_CONVERT(nvarchar(255),NULL) AS PATIENT_AREA_IND
	,TRY_CONVERT(nvarchar(255),NULL) AS PATIENT_DIA_IND

	-- Additional Provider Information (6 columns)
	,CA_License AS LIC_ID
	,EMAILis AS EMAIL
	,CASE
	WHEN [BOARD CERTIFIED] LIKE '%YES%'
	THEN 'Y'
	ELSE 'N'
	END AS BOARD_CERT_ID

	-- Office Language Information (15 columns - CCIPA only has first)
	,TRY_CONVERT(nvarchar(255),NULL) AS OFFICE_LANG01
	,TRY_CONVERT(nvarchar(255),NULL) AS OFFICE_LANG02
	,TRY_CONVERT(nvarchar(255),NULL) AS OFFICE_LANG03
	,TRY_CONVERT(nvarchar(255),NULL) AS OFFICE_LANG04
	,TRY_CONVERT(nvarchar(255),NULL) AS OFFICE_LANG05
	,TRY_CONVERT(nvarchar(255),NULL) AS OFFICE_LANG06
	,TRY_CONVERT(nvarchar(255),NULL) AS OFFICE_LANG07
	,TRY_CONVERT(nvarchar(255),NULL) AS OFFICE_LANG08
	,TRY_CONVERT(nvarchar(255),NULL) AS OFFICE_LANG09
	,TRY_CONVERT(nvarchar(255),NULL) AS OFFICE_LANG10
	,TRY_CONVERT(nvarchar(255),NULL) AS OFFICE_LANG11
	,TRY_CONVERT(nvarchar(255),NULL) AS OFFICE_LANG12
	,TRY_CONVERT(nvarchar(255),NULL) AS OFFICE_LANG13
	,TRY_CONVERT(nvarchar(255),NULL) AS OFFICE_LANG14
	,TRY_CONVERT(nvarchar(255),NULL) AS OFFICE_LANG15

	-- Provider Status/Preferences (6 columns)
	,TRY_CONVERT(nvarchar(1),NULL) AS SELF_ACCESS_FLAG
	,TRY_CONVERT(nvarchar(255),NULL) AS PHY_ALT_LNAME
	,TRY_CONVERT(nvarchar(255),NULL) AS PHY_ALT_FNAME
	,TRY_CONVERT(nvarchar(50),NULL) AS PHY_ALT_MNAME
	,URL_WEBSITE AS WEBSITE
	,CASE
	WHEN [ACCEPTING NEW PATIENTS] LIKE 'Y%'
	THEN 'E'
	ELSE 'J'
	END AS PHY_PANEL_STATUS

	-- Additional Contact (1 column)
	,AFTERHOURS_PHONE AS AFTERHOUR_PHONE

	-- Provider Characteristics (4 columns)
	,'N/A' AS PRV_CCT_IND_PHY_CCT_IND
	,TRY_CONVERT(nvarchar(1),NULL) AS [Gender] -- FOR PEOPLE ONLY !!!
	,TRY_CONVERT(nvarchar(255),NULL) AS ACCR_TYPE
	,ACCREDITATION_BY AS ACCR_DESC

	-- External Links (1 column)
	,TRY_CONVERT(nvarchar(255),NULL) AS HOSPITAL_GRADE_QUALITY_DATA_LINK

	-- Audit Columns (2 columns)
	,CAST(GETDATE() AS datetime2) AS ImportedAt
	,SYSTEM_USER AS ImportedBy
	,[Accessibility Category(ies)] AS [Accessibility Codes]
	,'CHPIV Direct Provider Directory' AS [Data Sourced From]

	-- Business Rule Columns (2 columns)
	,COUNTY -- Business rule: All CCIPA/ICPMG are Imperial County
	,Telehealth_Indicator -- To be updated per DHCS APL 25-014
	
	-- C003: Network Analysis ADD - ON COLUMN(S) (# columns) ... CHPIV DIRECT NETWORK FILE DEVELOPMENT FOR MS JULIA AS PART OF PROVDIR PROCESS WITH ADDITIONAL FIELDS'
	,TRY_CONVERT(decimal(10, 0), NULL) AS [TAXONOMY CODE] -- decimal(10,0) NULL ; -- ORDINAL  1 | ⚠ KEY ANCHOR — CONFIRM INTENT
	,NULL AS [TRAINING] -- nvarchar(255) NULL ; -- ORDINAL  2
	,TRY_CONVERT(decimal(10, 0), NULL) AS [LOCATION NPI] -- decimal(10,0) NULL ; -- ORDINAL  3
	,NULL AS [LOCATION NAME] -- nvarchar(25) NULL ; -- ORDINAL  4
	,0 AS [STAFFED BEDS] -- int NULL ; -- ORDINAL  5
	,NULL AS [CULTURAL COMPETENCY] -- nvarchar(255) NULL ; -- ORDINAL  6
	,NULL AS [HCAI ID] -- nvarchar(25) NULL ; -- ORDINAL  7 ... C###: UPDATE FOR MY204 AS OF 20250203 The DMHC’s standardized terminology is set forth in appendices A-F of the Annual Network Submission Instruction Manual for RY 2025. The health plan should also refer to the “Standardized Terminology and Other Reporting Resources” section of the Resources tab ON the Timely Access and Annual Network Reporting Web Portal for information ON standardized terminology resources. Please note, the DMHC relies ON the California Licensed Healthcare Facility Listing released by the California Department of Healthcare Access Information ('HCAI') to populate the Hospital and Other Inpatient Facility Name section of the Crosswalks tab. In addition, for RY 2025 the DMHC added a field for “'HCAI' ID” within the Hospital Report tab of the Hospital and Clinic Report Form. The “'HCAI' ID” field captures the unique identifier established by 'HCAI' to identify facilities used in the Licensed Facility Information System (LFIS). (See All Plan Letter (APL) 24-019.) The Plan may use the facility information provided ON www.'HCAI'.ca.gov to review its terminology and to identify the 'HCAI' ID for completing the Hospital and Clinic Report Form ... USE https://www.HCAI.ca.gov
	
	FROM
	( -- INITIATE ...
	SELECT *
	-- SELECT TOP 10 ' ' AS 'CHECK 1st',CSZ,*
	-- SELECT DISTINCT ' ' AS 'CHECK 1st',CSZ,SUBSTRING(CSZ,1,CHARINDEX(',',CSZ,1)-1) AS 'CSZCity',SUBSTRING(CSZ,CHARINDEX(',',CSZ,1)+1,3) AS 'CSZState',RIGHT(CSZ,5) AS 'CSZZip'
	FROM INFORMATICS.dbo.PROVDIR_HOSGENERALACUTE

	UNION /* DISTINCT() */ 
	SELECT *
	-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
	-- SELECT DISTINCT ' ' AS 'CHECK 1st',CSZ,SUBSTRING(CSZ,1,CHARINDEX(',',CSZ,1)-1) AS 'CSZCity',SUBSTRING(CSZ,CHARINDEX(',',CSZ,1)+1,3) AS 'CSZState',RIGHT(CSZ,5) AS 'CSZZip'
	FROM INFORMATICS.dbo.PROVDIR_HOSMH
	) -- CONCLUDE ...
	AS places
	WHERE 1=1
		AND places.[Participating Network] IN ('CHPIV-DSNP')
		-- AND NOT people.COUNTY LIKE '%SAN%DIEG%'; -- NO NOT NEGATIVE <> != ...
		
	UNION ALL
	SELECT DISTINCT  -- FACILITIY(-IES) / PLACES
		-- Core Provider Information (8 columns)	
	CITYIs AS CITY
	-- ,TRY_CONVERT(nvarchar(255),NULL) AS [GROUP]
	,TRY_CONVERT(nvarchar(255),places.[Participating Network]) AS [GROUP]
	,SPEC AS SPECIALTY
	,ISNULL(HospitalName,INDEXNM) AS LNAME
	,TRY_CONVERT(nvarchar(255),NULL) AS FNAME -- FOR PEOPLE ONLY!!!
	,TRY_CONVERT(nvarchar(255),NULL) AS Mname
	-- ,TypeOfLicensure AS TITLE
	-- ,RIGHT(LTRIM(RTRIM(ISNULL(INDEXNM,''))),2) AS TITLE
	,INDEXNM AS TITLE
	,lookup_key AS PHY_ID -- practitionerid

	-- Address/Contact Information (5 columns)
	,[Address]
	,SUBSTRING(CSZ,CHARINDEX(',',CSZ,1)+1,3) AS [STATE]
	,[ZIP] AS ZIPCODE
	,[Telephone Number] AS PHONE
	,[Office Hour(s)] AS HOURS

	-- Language Information (25 columns - CCIPA only has first language)
	,Language1 AS PHY_LANG01_PRV_LANG01
	,Language2 AS PHY_LANG02_PRV_LANG02
	,Language3 AS PHY_LANG03_PRV_LANG03
	,Language4 AS PHY_LANG04_PRV_LANG04
	,Language5 AS PHY_LANG05_PRV_LANG05
	,TRY_CONVERT(nvarchar(255),NULL) AS PHY_LANG06_PRV_LANG06
	,TRY_CONVERT(nvarchar(255),NULL) AS PHY_LANG07_PRV_LANG07
	,TRY_CONVERT(nvarchar(255),NULL) AS PHY_LANG08_PRV_LANG08
	,TRY_CONVERT(nvarchar(255),NULL) AS PHY_LANG09_PRV_LANG09
	,TRY_CONVERT(nvarchar(255),NULL) AS PHY_LANG10_PRV_LANG10
	,TRY_CONVERT(nvarchar(255),NULL) AS PHY_LANG11_PRV_LANG11
	,TRY_CONVERT(nvarchar(255),NULL) AS PHY_LANG12_PRV_LANG12
	,TRY_CONVERT(nvarchar(255),NULL) AS PHY_LANG13_PRV_LANG13
	,TRY_CONVERT(nvarchar(255),NULL) AS PHY_LANG14_PRV_LANG14
	,TRY_CONVERT(nvarchar(255),NULL) AS PHY_LANG15_PRV_LANG15
	,TRY_CONVERT(nvarchar(255),NULL) AS PHY_LANG16_PRV_LANG16
	,TRY_CONVERT(nvarchar(255),NULL) AS PHY_LANG17_PRV_LANG17
	,TRY_CONVERT(nvarchar(255),NULL) AS PHY_LANG18_PRV_LANG18
	,TRY_CONVERT(nvarchar(255),NULL) AS PHY_LANG19_PRV_LANG19
	,TRY_CONVERT(nvarchar(255),NULL) AS PHY_LANG20_PRV_LANG20
	,TRY_CONVERT(nvarchar(255),NULL) AS PHY_LANG21_PRV_LANG21
	,TRY_CONVERT(nvarchar(255),NULL) AS PHY_LANG22_PRV_LANG22
	,TRY_CONVERT(nvarchar(255),NULL) AS PHY_LANG23_PRV_LANG23
	,TRY_CONVERT(nvarchar(255),NULL) AS PHY_LANG24_PRV_LANG24
	,TRY_CONVERT(nvarchar(255),NULL) AS PHY_LANG25_PRV_LANG25

	-- Hospital/Certification (2 columns)
	,[FINALhosp_FULL_NAME] AS HOSP_NAME
	,'N/A' AS CERTIFICATION

	-- Extender Information (16 columns - NULL for CCIPA)
	,TRY_CONVERT(nvarchar(255),NULL) AS EXT1A_LNAME
	,TRY_CONVERT(nvarchar(255),NULL) AS EXT1B_FNAME
	,TRY_CONVERT(nvarchar(255),NULL) AS EXT1C_MINITIAL
	,TRY_CONVERT(nvarchar(100),NULL) AS EXT1D_LICTYPE
	,TRY_CONVERT(nvarchar(255),NULL) AS EXT2A_LNAME
	,TRY_CONVERT(nvarchar(255),NULL) AS EXT2B_FNAME
	,TRY_CONVERT(nvarchar(255),NULL) AS EXT2C_MINITIAL
	,TRY_CONVERT(nvarchar(100),NULL) AS EXT2D_LICTYPE
	,TRY_CONVERT(nvarchar(255),NULL) AS EXT3A_LNAME
	,TRY_CONVERT(nvarchar(255),NULL) AS EXT3B_FNAME
	,TRY_CONVERT(nvarchar(255),NULL) AS EXT3C_MINITIAL
	,TRY_CONVERT(nvarchar(100),NULL) AS EXT3D_LICTYPE
	,TRY_CONVERT(nvarchar(255),NULL) AS EXT4A_LNAME
	,TRY_CONVERT(nvarchar(255),NULL) AS EXT4B_FNAME
	,TRY_CONVERT(nvarchar(255),NULL) AS EXT4C_MINITIAL
	,TRY_CONVERT(nvarchar(100),NULL) AS EXT4D_LICTYPE

	-- Administrative Information (7 columns)
	,CHAPTER_NAME AS SECTION_NO
	,COUNTY AS DIR_ID
	,[ACCEPTING NEW PATIENTS] AS ACCEPT_NEW_PAT
	,DBA AS PPG_NAME
	,PROVIDER_TYPE AS CLNC_SER_TYP
	,[Clinic QNXT provid] AS PPG_ID
	,TRY_CONVERT(nvarchar(10),LTRIM(RTRIM(ISNULL(NPIis,'')))) AS NPI_NO

	-- Accessibility Indicators (9 columns - NULL for CCIPA)
	,Accessibility AS ACCESS_REQ
	,TRY_CONVERT(nvarchar(255),NULL) AS PARKING_IND
	,TRY_CONVERT(nvarchar(255),NULL) AS EXT_BUILD_IND
	,TRY_CONVERT(nvarchar(255),NULL) AS INT_BUILD_IND
	,TRY_CONVERT(nvarchar(255),NULL) AS RESTROOM_IND
	,TRY_CONVERT(nvarchar(255),NULL) AS EXAMROOM_IND
	,TRY_CONVERT(nvarchar(255),NULL) AS EXAMTBL_IND
	,TRY_CONVERT(nvarchar(255),NULL) AS PATIENT_AREA_IND
	,TRY_CONVERT(nvarchar(255),NULL) AS PATIENT_DIA_IND

	-- Additional Provider Information (6 columns)
	,CA_License AS LIC_ID
	,EMAILis AS EMAIL
	,CASE
	WHEN [BOARD CERTIFIED] LIKE '%YES%'
	THEN 'Y'
	ELSE 'N'
	END AS BOARD_CERT_ID

	-- Office Language Information (15 columns - CCIPA only has first)
	,TRY_CONVERT(nvarchar(255),NULL) AS OFFICE_LANG01
	,TRY_CONVERT(nvarchar(255),NULL) AS OFFICE_LANG02
	,TRY_CONVERT(nvarchar(255),NULL) AS OFFICE_LANG03
	,TRY_CONVERT(nvarchar(255),NULL) AS OFFICE_LANG04
	,TRY_CONVERT(nvarchar(255),NULL) AS OFFICE_LANG05
	,TRY_CONVERT(nvarchar(255),NULL) AS OFFICE_LANG06
	,TRY_CONVERT(nvarchar(255),NULL) AS OFFICE_LANG07
	,TRY_CONVERT(nvarchar(255),NULL) AS OFFICE_LANG08
	,TRY_CONVERT(nvarchar(255),NULL) AS OFFICE_LANG09
	,TRY_CONVERT(nvarchar(255),NULL) AS OFFICE_LANG10
	,TRY_CONVERT(nvarchar(255),NULL) AS OFFICE_LANG11
	,TRY_CONVERT(nvarchar(255),NULL) AS OFFICE_LANG12
	,TRY_CONVERT(nvarchar(255),NULL) AS OFFICE_LANG13
	,TRY_CONVERT(nvarchar(255),NULL) AS OFFICE_LANG14
	,TRY_CONVERT(nvarchar(255),NULL) AS OFFICE_LANG15

	-- Provider Status/Preferences (6 columns)
	,TRY_CONVERT(nvarchar(1),NULL) AS SELF_ACCESS_FLAG
	,TRY_CONVERT(nvarchar(255),NULL) AS PHY_ALT_LNAME
	,TRY_CONVERT(nvarchar(255),NULL) AS PHY_ALT_FNAME
	,TRY_CONVERT(nvarchar(50),NULL) AS PHY_ALT_MNAME
	,URL_WEBSITE AS WEBSITE
	,CASE
	WHEN [ACCEPTING NEW PATIENTS] LIKE 'Y%'
	THEN 'E'
	ELSE 'J'
	END AS PHY_PANEL_STATUS

	-- Additional Contact (1 column)
	,AFTERHOURS_PHONE AS AFTERHOUR_PHONE

	-- Provider Characteristics (4 columns)
	,'N/A' AS PRV_CCT_IND_PHY_CCT_IND
	,TRY_CONVERT(nvarchar(1),NULL) AS [Gender] -- FOR PEOPLE ONLY !!!
	,TRY_CONVERT(nvarchar(255),NULL) AS ACCR_TYPE
	,ACCREDITATION_BY AS ACCR_DESC

	-- External Links (1 column)
	,TRY_CONVERT(nvarchar(255),NULL) AS HOSPITAL_GRADE_QUALITY_DATA_LINK

	-- Audit Columns (2 columns)
	,CAST(GETDATE() AS datetime2) AS ImportedAt
	,SYSTEM_USER AS ImportedBy
	,[Accessibility Category(ies)] AS [Accessibility Codes]
	,'CHPIV Direct Provider Directory' AS [Data Sourced From]

	-- Business Rule Columns (2 columns)
	,COUNTY -- Business rule: All CCIPA/ICPMG are Imperial County
	,Telehealth_Indicator -- To be updated per DHCS APL 25-014
	
	-- C003: Network Analysis ADD - ON COLUMN(S) (# columns) ... CHPIV DIRECT NETWORK FILE DEVELOPMENT FOR MS JULIA AS PART OF PROVDIR PROCESS WITH ADDITIONAL FIELDS'
	,TRY_CONVERT(decimal(10, 0), NULL) AS [TAXONOMY CODE] -- decimal(10,0) NULL ; -- ORDINAL  1 | ⚠ KEY ANCHOR — CONFIRM INTENT
	,NULL AS [TRAINING] -- nvarchar(255) NULL ; -- ORDINAL  2
	,TRY_CONVERT(decimal(10, 0), NULL) AS [LOCATION NPI] -- decimal(10,0) NULL ; -- ORDINAL  3
	,NULL AS [LOCATION NAME] -- nvarchar(25) NULL ; -- ORDINAL  4
	,0 AS [STAFFED BEDS] -- int NULL ; -- ORDINAL  5
	,NULL AS [CULTURAL COMPETENCY] -- nvarchar(255) NULL ; -- ORDINAL  6
	,NULL AS [HCAI ID] -- nvarchar(25) NULL ; -- ORDINAL  7 ... C###: UPDATE FOR MY204 AS OF 20250203 The DMHC’s standardized terminology is set forth in appendices A-F of the Annual Network Submission Instruction Manual for RY 2025. The health plan should also refer to the “Standardized Terminology and Other Reporting Resources” section of the Resources tab ON the Timely Access and Annual Network Reporting Web Portal for information ON standardized terminology resources. Please note, the DMHC relies ON the California Licensed Healthcare Facility Listing released by the California Department of Healthcare Access Information ('HCAI') to populate the Hospital and Other Inpatient Facility Name section of the Crosswalks tab. In addition, for RY 2025 the DMHC added a field for “'HCAI' ID” within the Hospital Report tab of the Hospital and Clinic Report Form. The “'HCAI' ID” field captures the unique identifier established by 'HCAI' to identify facilities used in the Licensed Facility Information System (LFIS). (See All Plan Letter (APL) 24-019.) The Plan may use the facility information provided ON www.'HCAI'.ca.gov to review its terminology and to identify the 'HCAI' ID for completing the Hospital and Clinic Report Form ... USE https://www.HCAI.ca.gov	
	
	FROM
	( -- INITIATE ...
	SELECT *
	-- SELECT TOP 10 ' ' AS 'CHECK 1st',CSZ,*
	-- SELECT DISTINCT ' ' AS 'CHECK 1st',CSZ,SUBSTRING(CSZ,1,CHARINDEX(',',CSZ,1)-1) AS 'CSZCity',SUBSTRING(CSZ,CHARINDEX(',',CSZ,1)+1,3) AS 'CSZState',RIGHT(CSZ,5) AS 'CSZZip'
	FROM INFORMATICS.dbo.PROVDIR_SNF

	UNION /* DISTINCT() */ 
	SELECT *
	-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
	-- SELECT DISTINCT ' ' AS 'CHECK 1st',CSZ,SUBSTRING(CSZ,1,CHARINDEX(',',CSZ,1)-1) AS 'CSZCity',SUBSTRING(CSZ,CHARINDEX(',',CSZ,1)+1,3) AS 'CSZState',RIGHT(CSZ,5) AS 'CSZZip'
	FROM INFORMATICS.dbo.PROVDIR_HOSPICE

	UNION /* DISTINCT() */ 
	SELECT *
	-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
	-- SELECT DISTINCT ' ' AS 'CHECK 1st',CSZ,SUBSTRING(CSZ,1,CHARINDEX(',',CSZ,1)-1) AS 'CSZCity',SUBSTRING(CSZ,CHARINDEX(',',CSZ,1)+1,3) AS 'CSZState',RIGHT(CSZ,5) AS 'CSZZip'
	FROM INFORMATICS.dbo.PROVDIR_HHC

	UNION /* DISTINCT() */ 
	SELECT *
	-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
	-- SELECT DISTINCT ' ' AS 'CHECK 1st',CSZ,SUBSTRING(CSZ,1,CHARINDEX(',',CSZ,1)-1) AS 'CSZCity',SUBSTRING(CSZ,CHARINDEX(',',CSZ,1)+1,3) AS 'CSZState',RIGHT(CSZ,5) AS 'CSZZip'
	FROM INFORMATICS.dbo.PROVDIR_LAB
	) -- CONCLUDE ...
	AS places
	WHERE 1=1
		AND places.[Participating Network] IN ('CHPIV-DSNP')
		-- AND NOT people.COUNTY LIKE '%SAN%DIEG%'; -- NO NOT NEGATIVE <> != ...	

	UNION ALL
	SELECT DISTINCT  -- FACILITIY(-IES) / PLACES
		-- Core Provider Information (8 columns)	
	CITYIs AS CITY
	-- ,TRY_CONVERT(nvarchar(255),NULL) AS [GROUP]
	,TRY_CONVERT(nvarchar(255),places.[Participating Network]) AS [GROUP]
	,SPEC AS SPECIALTY
	,ISNULL([Clinic Name],INDEXNM) AS LNAME
	,TRY_CONVERT(nvarchar(255),NULL) AS FNAME -- FOR PEOPLE ONLY!!!
	,TRY_CONVERT(nvarchar(255),NULL) AS Mname
	-- ,TypeOfLicensure AS TITLE
	-- ,RIGHT(LTRIM(RTRIM(ISNULL(INDEXNM,''))),2) AS TITLE
	,INDEXNM AS TITLE
	,lookup_key AS PHY_ID -- practitionerid

	-- Address/Contact Information (5 columns)
	,[Address]
	,SUBSTRING(CSZ,CHARINDEX(',',CSZ,1)+1,3) AS [STATE]
	,[ZIP] AS ZIPCODE
	,[Telephone Number] AS PHONE
	,[Office Hour(s)] AS HOURS

	-- Language Information (25 columns - CCIPA only has first language)
	,Language1 AS PHY_LANG01_PRV_LANG01
	,Language2 AS PHY_LANG02_PRV_LANG02
	,Language3 AS PHY_LANG03_PRV_LANG03
	,Language4 AS PHY_LANG04_PRV_LANG04
	,Language5 AS PHY_LANG05_PRV_LANG05
	,TRY_CONVERT(nvarchar(255),NULL) AS PHY_LANG06_PRV_LANG06
	,TRY_CONVERT(nvarchar(255),NULL) AS PHY_LANG07_PRV_LANG07
	,TRY_CONVERT(nvarchar(255),NULL) AS PHY_LANG08_PRV_LANG08
	,TRY_CONVERT(nvarchar(255),NULL) AS PHY_LANG09_PRV_LANG09
	,TRY_CONVERT(nvarchar(255),NULL) AS PHY_LANG10_PRV_LANG10
	,TRY_CONVERT(nvarchar(255),NULL) AS PHY_LANG11_PRV_LANG11
	,TRY_CONVERT(nvarchar(255),NULL) AS PHY_LANG12_PRV_LANG12
	,TRY_CONVERT(nvarchar(255),NULL) AS PHY_LANG13_PRV_LANG13
	,TRY_CONVERT(nvarchar(255),NULL) AS PHY_LANG14_PRV_LANG14
	,TRY_CONVERT(nvarchar(255),NULL) AS PHY_LANG15_PRV_LANG15
	,TRY_CONVERT(nvarchar(255),NULL) AS PHY_LANG16_PRV_LANG16
	,TRY_CONVERT(nvarchar(255),NULL) AS PHY_LANG17_PRV_LANG17
	,TRY_CONVERT(nvarchar(255),NULL) AS PHY_LANG18_PRV_LANG18
	,TRY_CONVERT(nvarchar(255),NULL) AS PHY_LANG19_PRV_LANG19
	,TRY_CONVERT(nvarchar(255),NULL) AS PHY_LANG20_PRV_LANG20
	,TRY_CONVERT(nvarchar(255),NULL) AS PHY_LANG21_PRV_LANG21
	,TRY_CONVERT(nvarchar(255),NULL) AS PHY_LANG22_PRV_LANG22
	,TRY_CONVERT(nvarchar(255),NULL) AS PHY_LANG23_PRV_LANG23
	,TRY_CONVERT(nvarchar(255),NULL) AS PHY_LANG24_PRV_LANG24
	,TRY_CONVERT(nvarchar(255),NULL) AS PHY_LANG25_PRV_LANG25

	-- Hospital/Certification (2 columns)
	,TRY_CONVERT(nvarchar(255),NULL) AS HOSP_NAME
	,'N/A' AS CERTIFICATION

	-- Extender Information (16 columns - NULL for CCIPA)
	,TRY_CONVERT(nvarchar(255),NULL) AS EXT1A_LNAME
	,TRY_CONVERT(nvarchar(255),NULL) AS EXT1B_FNAME
	,TRY_CONVERT(nvarchar(255),NULL) AS EXT1C_MINITIAL
	,TRY_CONVERT(nvarchar(100),NULL) AS EXT1D_LICTYPE
	,TRY_CONVERT(nvarchar(255),NULL) AS EXT2A_LNAME
	,TRY_CONVERT(nvarchar(255),NULL) AS EXT2B_FNAME
	,TRY_CONVERT(nvarchar(255),NULL) AS EXT2C_MINITIAL
	,TRY_CONVERT(nvarchar(100),NULL) AS EXT2D_LICTYPE
	,TRY_CONVERT(nvarchar(255),NULL) AS EXT3A_LNAME
	,TRY_CONVERT(nvarchar(255),NULL) AS EXT3B_FNAME
	,TRY_CONVERT(nvarchar(255),NULL) AS EXT3C_MINITIAL
	,TRY_CONVERT(nvarchar(100),NULL) AS EXT3D_LICTYPE
	,TRY_CONVERT(nvarchar(255),NULL) AS EXT4A_LNAME
	,TRY_CONVERT(nvarchar(255),NULL) AS EXT4B_FNAME
	,TRY_CONVERT(nvarchar(255),NULL) AS EXT4C_MINITIAL
	,TRY_CONVERT(nvarchar(100),NULL) AS EXT4D_LICTYPE

	-- Administrative Information (7 columns)
	,CHAPTER_NAME AS SECTION_NO
	,COUNTY AS DIR_ID
	,[ACCEPTING NEW PATIENTS] AS ACCEPT_NEW_PAT
	,DBA AS PPG_NAME
	,PROVIDER_TYPE AS CLNC_SER_TYP
	,[Clinic QNXT provid] AS PPG_ID
	,TRY_CONVERT(nvarchar(10),LTRIM(RTRIM(ISNULL(NPIis,'')))) AS NPI_NO

	-- Accessibility Indicators (9 columns - NULL for CCIPA)
	,Accessibility AS ACCESS_REQ
	,TRY_CONVERT(nvarchar(255),NULL) AS PARKING_IND
	,TRY_CONVERT(nvarchar(255),NULL) AS EXT_BUILD_IND
	,TRY_CONVERT(nvarchar(255),NULL) AS INT_BUILD_IND
	,TRY_CONVERT(nvarchar(255),NULL) AS RESTROOM_IND
	,TRY_CONVERT(nvarchar(255),NULL) AS EXAMROOM_IND
	,TRY_CONVERT(nvarchar(255),NULL) AS EXAMTBL_IND
	,TRY_CONVERT(nvarchar(255),NULL) AS PATIENT_AREA_IND
	,TRY_CONVERT(nvarchar(255),NULL) AS PATIENT_DIA_IND

	-- Additional Provider Information (6 columns)
	,CA_License AS LIC_ID
	,EMAILis AS EMAIL
	,TRY_CONVERT(nvarchar(1),NULL) AS BOARD_CERT_ID

	-- Office Language Information (15 columns - CCIPA only has first)
	,TRY_CONVERT(nvarchar(255),NULL) AS OFFICE_LANG01
	,TRY_CONVERT(nvarchar(255),NULL) AS OFFICE_LANG02
	,TRY_CONVERT(nvarchar(255),NULL) AS OFFICE_LANG03
	,TRY_CONVERT(nvarchar(255),NULL) AS OFFICE_LANG04
	,TRY_CONVERT(nvarchar(255),NULL) AS OFFICE_LANG05
	,TRY_CONVERT(nvarchar(255),NULL) AS OFFICE_LANG06
	,TRY_CONVERT(nvarchar(255),NULL) AS OFFICE_LANG07
	,TRY_CONVERT(nvarchar(255),NULL) AS OFFICE_LANG08
	,TRY_CONVERT(nvarchar(255),NULL) AS OFFICE_LANG09
	,TRY_CONVERT(nvarchar(255),NULL) AS OFFICE_LANG10
	,TRY_CONVERT(nvarchar(255),NULL) AS OFFICE_LANG11
	,TRY_CONVERT(nvarchar(255),NULL) AS OFFICE_LANG12
	,TRY_CONVERT(nvarchar(255),NULL) AS OFFICE_LANG13
	,TRY_CONVERT(nvarchar(255),NULL) AS OFFICE_LANG14
	,TRY_CONVERT(nvarchar(255),NULL) AS OFFICE_LANG15

	-- Provider Status/Preferences (6 columns)
	,TRY_CONVERT(nvarchar(1),NULL) AS SELF_ACCESS_FLAG
	,TRY_CONVERT(nvarchar(255),NULL) AS PHY_ALT_LNAME
	,TRY_CONVERT(nvarchar(255),NULL) AS PHY_ALT_FNAME
	,TRY_CONVERT(nvarchar(50),NULL) AS PHY_ALT_MNAME
	,URL_WEBSITE AS WEBSITE
	,CASE
	WHEN [ACCEPTING NEW PATIENTS] LIKE 'Y%'
	THEN 'E'
	ELSE 'J'
	END AS PHY_PANEL_STATUS

	-- Additional Contact (1 column)
	,AFTERHOURS_PHONE AS AFTERHOUR_PHONE

	-- Provider Characteristics (4 columns)
	,'N/A' AS PRV_CCT_IND_PHY_CCT_IND
	,TRY_CONVERT(nvarchar(1),NULL) AS [Gender] -- FOR PEOPLE ONLY !!!
	,TRY_CONVERT(nvarchar(255),NULL) AS ACCR_TYPE
	,ACCREDITATION_BY AS ACCR_DESC

	-- External Links (1 column)
	,TRY_CONVERT(nvarchar(255),NULL) AS HOSPITAL_GRADE_QUALITY_DATA_LINK

	-- Audit Columns (2 columns)
	,CAST(GETDATE() AS datetime2) AS ImportedAt
	,SYSTEM_USER AS ImportedBy
	,[Accessibility Category(ies)] AS [Accessibility Codes]
	,'CHPIV Direct Provider Directory' AS [Data Sourced From]

	-- Business Rule Columns (2 columns)
	,COUNTY -- Business rule: All CCIPA/ICPMG are Imperial County
	,Telehealth_Indicator -- To be updated per DHCS APL 25-014
	
	-- C003: Network Analysis ADD - ON COLUMN(S) (# columns) ... CHPIV DIRECT NETWORK FILE DEVELOPMENT FOR MS JULIA AS PART OF PROVDIR PROCESS WITH ADDITIONAL FIELDS'
	,TRY_CONVERT(decimal(10, 0), NULL) AS [TAXONOMY CODE] -- decimal(10,0) NULL ; -- ORDINAL  1 | ⚠ KEY ANCHOR — CONFIRM INTENT
	,NULL AS [TRAINING] -- nvarchar(255) NULL ; -- ORDINAL  2
	,TRY_CONVERT(decimal(10, 0), NULL) AS [LOCATION NPI] -- decimal(10,0) NULL ; -- ORDINAL  3
	,NULL AS [LOCATION NAME] -- nvarchar(25) NULL ; -- ORDINAL  4
	,0 AS [STAFFED BEDS] -- int NULL ; -- ORDINAL  5
	,NULL AS [CULTURAL COMPETENCY] -- nvarchar(255) NULL ; -- ORDINAL  6
	,NULL AS [HCAI ID] -- nvarchar(25) NULL ; -- ORDINAL  7 ... C###: UPDATE FOR MY204 AS OF 20250203 The DMHC’s standardized terminology is set forth in appendices A-F of the Annual Network Submission Instruction Manual for RY 2025. The health plan should also refer to the “Standardized Terminology and Other Reporting Resources” section of the Resources tab ON the Timely Access and Annual Network Reporting Web Portal for information ON standardized terminology resources. Please note, the DMHC relies ON the California Licensed Healthcare Facility Listing released by the California Department of Healthcare Access Information ('HCAI') to populate the Hospital and Other Inpatient Facility Name section of the Crosswalks tab. In addition, for RY 2025 the DMHC added a field for “'HCAI' ID” within the Hospital Report tab of the Hospital and Clinic Report Form. The “'HCAI' ID” field captures the unique identifier established by 'HCAI' to identify facilities used in the Licensed Facility Information System (LFIS). (See All Plan Letter (APL) 24-019.) The Plan may use the facility information provided ON www.'HCAI'.ca.gov to review its terminology and to identify the 'HCAI' ID for completing the Hospital and Clinic Report Form ... USE https://www.HCAI.ca.gov

	FROM
	( -- INITIATE ...
	SELECT *
	-- SELECT TOP 10 ' ' AS 'CHECK 1st',CSZ,*
	-- SELECT DISTINCT ' ' AS 'CHECK 1st',CSZ,SUBSTRING(CSZ,1,CHARINDEX(',',CSZ,1)-1) AS 'CSZCity',SUBSTRING(CSZ,CHARINDEX(',',CSZ,1)+1,3) AS 'CSZState',RIGHT(CSZ,5) AS 'CSZZip'
	FROM INFORMATICS.dbo.PROVDIR_CLINIC
	) -- CONCLUDE ...
	AS places
	WHERE 1=1
		AND places.[Participating Network] IN ('CHPIV-DSNP') -- LIKE '%CHPIV%'
		-- AND NOT people.COUNTY LIKE '%SAN%DIEG%'; -- NO NOT NEGATIVE <> != ...
		
	UNION ALL
	SELECT DISTINCT  -- PHARMACY(-IES) / PLACES
		-- Core Provider Information (8 columns)	
	CITYIs AS CITY
	-- ,TRY_CONVERT(nvarchar(255),NULL) AS [GROUP]
	,TRY_CONVERT(nvarchar(255),places.[Participating Network]) AS [GROUP]
	,CHAPTER_NAME AS SPECIALTY
	,ISNULL([Pharmacy Name],INDEXNM) AS LNAME
	,TRY_CONVERT(nvarchar(255),NULL) AS FNAME -- FOR PEOPLE ONLY!!!
	,TRY_CONVERT(nvarchar(255),NULL) AS Mname
	-- ,TypeOfLicensure AS TITLE
	-- ,RIGHT(LTRIM(RTRIM(ISNULL(INDEXNM,''))),2) AS TITLE
	,INDEXNM AS TITLE
	,lookup_key AS PHY_ID -- practitionerid

	-- Address/Contact Information (5 columns)
	,[Address]
	,SUBSTRING(CSZ,CHARINDEX(',',CSZ,1)+1,3) AS [STATE]
	,[ZIP] AS ZIPCODE
	,[Telephone Number] AS PHONE
	,[Office Hour(s)] AS HOURS

	-- Language Information (25 columns - CCIPA only has first language)
	,Language1 AS PHY_LANG01_PRV_LANG01
	,Language2 AS PHY_LANG02_PRV_LANG02
	,Language3 AS PHY_LANG03_PRV_LANG03
	,Language4 AS PHY_LANG04_PRV_LANG04
	,Language5 AS PHY_LANG05_PRV_LANG05
	,TRY_CONVERT(nvarchar(255),NULL) AS PHY_LANG06_PRV_LANG06
	,TRY_CONVERT(nvarchar(255),NULL) AS PHY_LANG07_PRV_LANG07
	,TRY_CONVERT(nvarchar(255),NULL) AS PHY_LANG08_PRV_LANG08
	,TRY_CONVERT(nvarchar(255),NULL) AS PHY_LANG09_PRV_LANG09
	,TRY_CONVERT(nvarchar(255),NULL) AS PHY_LANG10_PRV_LANG10
	,TRY_CONVERT(nvarchar(255),NULL) AS PHY_LANG11_PRV_LANG11
	,TRY_CONVERT(nvarchar(255),NULL) AS PHY_LANG12_PRV_LANG12
	,TRY_CONVERT(nvarchar(255),NULL) AS PHY_LANG13_PRV_LANG13
	,TRY_CONVERT(nvarchar(255),NULL) AS PHY_LANG14_PRV_LANG14
	,TRY_CONVERT(nvarchar(255),NULL) AS PHY_LANG15_PRV_LANG15
	,TRY_CONVERT(nvarchar(255),NULL) AS PHY_LANG16_PRV_LANG16
	,TRY_CONVERT(nvarchar(255),NULL) AS PHY_LANG17_PRV_LANG17
	,TRY_CONVERT(nvarchar(255),NULL) AS PHY_LANG18_PRV_LANG18
	,TRY_CONVERT(nvarchar(255),NULL) AS PHY_LANG19_PRV_LANG19
	,TRY_CONVERT(nvarchar(255),NULL) AS PHY_LANG20_PRV_LANG20
	,TRY_CONVERT(nvarchar(255),NULL) AS PHY_LANG21_PRV_LANG21
	,TRY_CONVERT(nvarchar(255),NULL) AS PHY_LANG22_PRV_LANG22
	,TRY_CONVERT(nvarchar(255),NULL) AS PHY_LANG23_PRV_LANG23
	,TRY_CONVERT(nvarchar(255),NULL) AS PHY_LANG24_PRV_LANG24
	,TRY_CONVERT(nvarchar(255),NULL) AS PHY_LANG25_PRV_LANG25

	-- Hospital/Certification (2 columns)
	,NULL AS HOSP_NAME
	,NULL AS CERTIFICATION

	-- Extender Information (16 columns - NULL for CCIPA)
	,TRY_CONVERT(nvarchar(255),NULL) AS EXT1A_LNAME
	,TRY_CONVERT(nvarchar(255),NULL) AS EXT1B_FNAME
	,TRY_CONVERT(nvarchar(255),NULL) AS EXT1C_MINITIAL
	,TRY_CONVERT(nvarchar(100),NULL) AS EXT1D_LICTYPE
	,TRY_CONVERT(nvarchar(255),NULL) AS EXT2A_LNAME
	,TRY_CONVERT(nvarchar(255),NULL) AS EXT2B_FNAME
	,TRY_CONVERT(nvarchar(255),NULL) AS EXT2C_MINITIAL
	,TRY_CONVERT(nvarchar(100),NULL) AS EXT2D_LICTYPE
	,TRY_CONVERT(nvarchar(255),NULL) AS EXT3A_LNAME
	,TRY_CONVERT(nvarchar(255),NULL) AS EXT3B_FNAME
	,TRY_CONVERT(nvarchar(255),NULL) AS EXT3C_MINITIAL
	,TRY_CONVERT(nvarchar(100),NULL) AS EXT3D_LICTYPE
	,TRY_CONVERT(nvarchar(255),NULL) AS EXT4A_LNAME
	,TRY_CONVERT(nvarchar(255),NULL) AS EXT4B_FNAME
	,TRY_CONVERT(nvarchar(255),NULL) AS EXT4C_MINITIAL
	,TRY_CONVERT(nvarchar(100),NULL) AS EXT4D_LICTYPE

	-- Administrative Information (7 columns)
	,CHAPTER_NAME AS SECTION_NO
	,COUNTY AS DIR_ID
	,'Y' AS ACCEPT_NEW_PAT
	,DBA AS PPG_NAME
	,PROVIDER_TYPE AS CLNC_SER_TYP
	,[Clinic QNXT provid] AS PPG_ID
	,TRY_CONVERT(nvarchar(10),LTRIM(RTRIM(ISNULL(NPIis,'')))) AS NPI_NO

	-- Accessibility Indicators (9 columns - NULL for CCIPA)
	,NULL AS ACCESS_REQ
	,TRY_CONVERT(nvarchar(255),NULL) AS PARKING_IND
	,TRY_CONVERT(nvarchar(255),NULL) AS EXT_BUILD_IND
	,TRY_CONVERT(nvarchar(255),NULL) AS INT_BUILD_IND
	,TRY_CONVERT(nvarchar(255),NULL) AS RESTROOM_IND
	,TRY_CONVERT(nvarchar(255),NULL) AS EXAMROOM_IND
	,TRY_CONVERT(nvarchar(255),NULL) AS EXAMTBL_IND
	,TRY_CONVERT(nvarchar(255),NULL) AS PATIENT_AREA_IND
	,TRY_CONVERT(nvarchar(255),NULL) AS PATIENT_DIA_IND

	-- Additional Provider Information (6 columns)
	,NULL AS LIC_ID
	,EMAILis AS EMAIL
	,NULL AS BOARD_CERT_ID

	-- Office Language Information (15 columns - CCIPA only has first)
	,TRY_CONVERT(nvarchar(255),NULL) AS OFFICE_LANG01
	,TRY_CONVERT(nvarchar(255),NULL) AS OFFICE_LANG02
	,TRY_CONVERT(nvarchar(255),NULL) AS OFFICE_LANG03
	,TRY_CONVERT(nvarchar(255),NULL) AS OFFICE_LANG04
	,TRY_CONVERT(nvarchar(255),NULL) AS OFFICE_LANG05
	,TRY_CONVERT(nvarchar(255),NULL) AS OFFICE_LANG06
	,TRY_CONVERT(nvarchar(255),NULL) AS OFFICE_LANG07
	,TRY_CONVERT(nvarchar(255),NULL) AS OFFICE_LANG08
	,TRY_CONVERT(nvarchar(255),NULL) AS OFFICE_LANG09
	,TRY_CONVERT(nvarchar(255),NULL) AS OFFICE_LANG10
	,TRY_CONVERT(nvarchar(255),NULL) AS OFFICE_LANG11
	,TRY_CONVERT(nvarchar(255),NULL) AS OFFICE_LANG12
	,TRY_CONVERT(nvarchar(255),NULL) AS OFFICE_LANG13
	,TRY_CONVERT(nvarchar(255),NULL) AS OFFICE_LANG14
	,TRY_CONVERT(nvarchar(255),NULL) AS OFFICE_LANG15

	-- Provider Status/Preferences (6 columns)
	,TRY_CONVERT(nvarchar(1),NULL) AS SELF_ACCESS_FLAG
	,TRY_CONVERT(nvarchar(255),NULL) AS PHY_ALT_LNAME
	,TRY_CONVERT(nvarchar(255),NULL) AS PHY_ALT_FNAME
	,TRY_CONVERT(nvarchar(50),NULL) AS PHY_ALT_MNAME
	,URL_WEBSITE AS WEBSITE
	,NULL AS PHY_PANEL_STATUS

	-- Additional Contact (1 column)
	,AFTERHOURS_PHONE AS AFTERHOUR_PHONE

	-- Provider Characteristics (4 columns)
	,NULL AS PRV_CCT_IND_PHY_CCT_IND
	,TRY_CONVERT(nvarchar(1),NULL) AS [Gender] -- FOR PEOPLE ONLY !!!
	,TRY_CONVERT(nvarchar(255),NULL) AS ACCR_TYPE
	,ACCREDITATION_BY AS ACCR_DESC

	-- External Links (1 column)
	,TRY_CONVERT(nvarchar(255),NULL) AS HOSPITAL_GRADE_QUALITY_DATA_LINK

	-- Audit Columns (2 columns)
	,CAST(GETDATE() AS datetime2) AS ImportedAt
	,SYSTEM_USER AS ImportedBy
	,NULL AS [Accessibility Codes]
	,'CHPIV Direct Provider Directory' AS [Data Sourced From]

	-- Business Rule Columns (2 columns)
	,COUNTY -- Business rule: All CCIPA/ICPMG are Imperial County
	,Telehealth_Indicator -- To be updated per DHCS APL 25-014	
	
	-- C003: Network Analysis ADD - ON COLUMN(S) (# columns) ... CHPIV DIRECT NETWORK FILE DEVELOPMENT FOR MS JULIA AS PART OF PROVDIR PROCESS WITH ADDITIONAL FIELDS'
	,TRY_CONVERT(decimal(10, 0), NULL) AS [TAXONOMY CODE] -- decimal(10,0) NULL ; -- ORDINAL  1 | ⚠ KEY ANCHOR — CONFIRM INTENT
	,NULL AS [TRAINING] -- nvarchar(255) NULL ; -- ORDINAL  2
	,TRY_CONVERT(decimal(10, 0), NULL) AS [LOCATION NPI] -- decimal(10,0) NULL ; -- ORDINAL  3
	,NULL AS [LOCATION NAME] -- nvarchar(25) NULL ; -- ORDINAL  4
	,0 AS [STAFFED BEDS] -- int NULL ; -- ORDINAL  5
	,NULL AS [CULTURAL COMPETENCY] -- nvarchar(255) NULL ; -- ORDINAL  6
	,NULL AS [HCAI ID] -- nvarchar(25) NULL ; -- ORDINAL  7 ... C###: UPDATE FOR MY204 AS OF 20250203 The DMHC’s standardized terminology is set forth in appendices A-F of the Annual Network Submission Instruction Manual for RY 2025. The health plan should also refer to the “Standardized Terminology and Other Reporting Resources” section of the Resources tab ON the Timely Access and Annual Network Reporting Web Portal for information ON standardized terminology resources. Please note, the DMHC relies ON the California Licensed Healthcare Facility Listing released by the California Department of Healthcare Access Information ('HCAI') to populate the Hospital and Other Inpatient Facility Name section of the Crosswalks tab. In addition, for RY 2025 the DMHC added a field for “'HCAI' ID” within the Hospital Report tab of the Hospital and Clinic Report Form. The “'HCAI' ID” field captures the unique identifier established by 'HCAI' to identify facilities used in the Licensed Facility Information System (LFIS). (See All Plan Letter (APL) 24-019.) The Plan may use the facility information provided ON www.'HCAI'.ca.gov to review its terminology and to identify the 'HCAI' ID for completing the Hospital and Clinic Report Form ... USE https://www.HCAI.ca.gov
	
	FROM
	( -- INITIATE ...
	/* SELECT *
	-- SELECT TOP 10 ' ' AS 'CHECK 1st',CSZ,*
	-- SELECT DISTINCT ' ' AS 'CHECK 1st',CSZ,SUBSTRING(CSZ,1,CHARINDEX(',',CSZ,1)-1) AS 'CSZCity',SUBSTRING(CSZ,CHARINDEX(',',CSZ,1)+1,3) AS 'CSZState',RIGHT(CSZ,5) AS 'CSZZip'
	FROM INFORMATICS.dbo.PROVDIR_PHARM */

	SELECT *
	-- SELECT TOP 10 ' ' AS 'CHECK 1st',CSZ,*
	-- SELECT DISTINCT ' ' AS 'CHECK 1st',CSZ,SUBSTRING(CSZ,1,CHARINDEX(',',CSZ,1)-1) AS 'CSZCity',SUBSTRING(CSZ,CHARINDEX(',',CSZ,1)+1,3) AS 'CSZState',RIGHT(CSZ,5) AS 'CSZZip'
	FROM INFORMATICS.dbo.PROVDIR_PHARM_RCP

	UNION /* DISTINCT() */ 
	SELECT *
	-- SELECT TOP 10 ' ' AS 'CHECK 1st',CSZ,*
	-- SELECT DISTINCT ' ' AS 'CHECK 1st',CSZ,SUBSTRING(CSZ,1,CHARINDEX(',',CSZ,1)-1) AS 'CSZCity',SUBSTRING(CSZ,CHARINDEX(',',CSZ,1)+1,3) AS 'CSZState',RIGHT(CSZ,5) AS 'CSZZip'
	FROM INFORMATICS.dbo.PROVDIR_PHARM_MO

	UNION /* DISTINCT() */ 
	SELECT *
	-- SELECT TOP 10 ' ' AS 'CHECK 1st',CSZ,*
	-- SELECT DISTINCT ' ' AS 'CHECK 1st',CSZ,SUBSTRING(CSZ,1,CHARINDEX(',',CSZ,1)-1) AS 'CSZCity',SUBSTRING(CSZ,CHARINDEX(',',CSZ,1)+1,3) AS 'CSZState',RIGHT(CSZ,5) AS 'CSZZip'
	FROM INFORMATICS.dbo.PROVDIR_PHARM_HI

	UNION /* DISTINCT() */ 
	SELECT *
	-- SELECT TOP 10 ' ' AS 'CHECK 1st',CSZ,*
	-- SELECT DISTINCT ' ' AS 'CHECK 1st',CSZ,SUBSTRING(CSZ,1,CHARINDEX(',',CSZ,1)-1) AS 'CSZCity',SUBSTRING(CSZ,CHARINDEX(',',CSZ,1)+1,3) AS 'CSZState',RIGHT(CSZ,5) AS 'CSZZip'
	FROM INFORMATICS.dbo.PROVDIR_PHARM_LTC

	UNION /* DISTINCT() */ 
	SELECT *
	-- SELECT TOP 10 ' ' AS 'CHECK 1st',CSZ,*
	-- SELECT DISTINCT ' ' AS 'CHECK 1st',CSZ,SUBSTRING(CSZ,1,CHARINDEX(',',CSZ,1)-1) AS 'CSZCity',SUBSTRING(CSZ,CHARINDEX(',',CSZ,1)+1,3) AS 'CSZState',RIGHT(CSZ,5) AS 'CSZZip'
	FROM INFORMATICS.dbo.PROVDIR_PHARM_ITU
	) -- CONCLUDE ...
	AS places
	WHERE 1=1
		AND places.[Participating Network] IN ('CHPIV-DSNP') -- C002: PHARMACY ADDITION AS OF 20260226
		-- AND NOT people.COUNTY LIKE '%SAN%DIEG%'; -- NO NOT NEGATIVE <> != ...		
		) -- CONCLUDE ...
		AS peopleandplaces;

-- ========================================================
	-- SECTION 3: NON PROVIDER DIRECTORY DIRECT CHPIV INSERT: 
-- ========================================================
		/* ~ LEVERAGE: "DEVELOPMENT_CHPIV_DIRECT_NETWORK_20260430.sql" */

-- =========================================================================
	-- ISO FOR CHPIV (COMMUNITY HEALTH PLAN OF IMPERIAL VALLEY) DIRECT IN eVIPS:
-- =========================================================================
---------------------------------------------------------------------------------------------------------------------------------
	-- Error Trapping: Check If Permanent Table(s) Already Exist(s) And Drop If Applicable --
----------------------------------------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS #chpiv
DROP TABLE IF EXISTS #hcai
DROP TABLE IF EXISTS #baselineprovider
DROP TABLE IF EXISTS #baselinefacility

SELECT DISTINCT ' ' AS 'ISO FOR CHPIV' --  FACILITIES [ProductName] AS LOB IN eVIPS'
,vlp.ProductName
,vlp.PracticeID
,vlp.PracticeName
,vlp.LocationID
,vlp.LocationName
,TRY_CONVERT(nvarchar(255),NULL) AS 'PractitionerID'
,TRY_CONVERT(nvarchar(255),NULL) AS 'NationalProviderID'
,TRY_CONVERT(nvarchar(255),NULL) AS 'ProviderName'
-- ,vlp.* -- CHPIV PROVIDER DIRECTORY DEVELOPMENT: LEVERAGE "CHPIV_placeholder_insertions_20250909.sql"
INTO #chpiv
FROM eVips_chgcv.dbo.vwPractices AS vp
	INNER JOIN eVips_chgcv.dbo.vwPracticeLocations AS vpl ON vp.PracticeID = vpl.PracticeID
	INNER JOIN eVips_chgcv.dbo.vwLocationProducts AS vlp ON vpl.PracticeID = vlp.PracticeID --'YOUNG LADY LAURA GAH ID WHERE p.archived = 'N' AND s.ServiceTypeName = 'HOSPITAL' AND p.focus like '%GAH%'' ON 20171120 see ,(LTRIM(RTRIM(vlp.ServiceTypeName))) AS [vlpSERVICETYPENAME]
			AND vpl.LocationID = vlp.LocationID -- per YOUNG LADY LAURA email ON 20171221 ... Products (CMC & MEDICAL)  are stored at Location Level. The code below is joining based only ON Practice ID. This should be based ON PracticeID + Location
WHERE 1=1
	AND vlp.ProductName LIKE '%MEDICARE%C%' -- SUNSET DEPRECATED DECOMMISSION SOLUTION
		OR vlp.ProductName LIKE '%CHPIV%' -- SUNSET DEPRECATED DECOMMISSION SOLUTION
		-- OR vlp.PracticeName LIKE '%CHPIV%' -- MARKER AS OF 20250728
		
UNION 
SELECT DISTINCT ' ' AS 'ISO FOR CHPIV' --  PROVIDER(S) [ProductName] AS LOB IN eVIPS'
,vpp.ProductName
,vpp.PracticeID
,vpp.PracticeName
,vpp.LocationID
,vpp.LocationName
,vpd.PractitionerID
,vpd.NationalProviderID
,ISNULL(vpd.LastName,'')+', '+ISNULL(vpd.FirstName,'') AS 'ProviderName'
-- ,vploc.*  -- C005: IDENTIFY CHPIV PER MEETING WITH() MS JOHANNA AND MS SANDRA ON 20250219 ... see "Copy of CHPIV_Rosters_Consolidated.xlsx"
FROM eVips_chgcv.dbo.vwPractitionerDemographics AS vpd
	INNER JOIN eVips_chgcv.dbo.vwPractitionerProducts AS vpp ON vpd.PractitionerID = vpp.PractitionerID -- aka cert_provider
		LEFT JOIN 
		( -- INITIATE ...
		SELECT DISTINCT vpprovloc.PractitionerID,vpprovloc.PracticeID,vpprovloc.LocationID,vpprovloc.AddressID,vpprovloc.LastName,vpprovloc.FirstName,vpprovloc.Archived,vpprovloc.LocationName,vpprovloc.NationalProviderID,vpprovloc.LocationNotes,vpprovloc.PracticeTypeName,vpprovloc.ProviderNumber,vpprovloc.website,vpfacloc.LineNumber1,vpfacloc.LineNumber2,vpfacloc.LineNumber3,vpfacloc.City,vpfacloc.[State],vpfacloc.ZipCode,vpfacloc.LocationTypeName 
		FROM eVips_chgcv.dbo.vwPractitionerLocations AS vpprovloc
			INNER JOIN eVips_chgcv.dbo.vwPracticeLocations AS vpfacloc ON vpprovloc.PracticeID = vpfacloc.PracticeID
				AND vpprovloc.LocationID = vpfacloc.LocationID 
		WHERE 1=1
			AND (LTRIM(RTRIM(ISNULL(vpfacloc.LocationTypeName,'')))) LIKE '%PRACTI%'
			) -- CONCLUDE ...
			AS vploc ON vpd.PractitionerID = vploc.PractitionerID
				AND vpp.PracticeID = vploc.PracticeID
				AND vpp.LocationID = vploc.LocationID
WHERE 1=1
	AND vpp.ProductName LIKE '%MEDICARE%C%' -- REIMAGINED IN SEP 2025 ... SUNSET DEPRECATED DECOMMISSION SOLUTION
		OR vpp.ProductName LIKE '%CHPIV%'  -- REIMAGINED IN SEP 2025 ... SUNSET DEPRECATED DECOMMISSION SOLUTION
	-- AND vpp.PracticeName LIKE '%CHPIV%' -- MARKER AS OF 20250728
	-- AND vpd.NationalProviderID IN 
	-- ( -- INITIATE ...
	-- '1043356850' -- ORIGINAL TEST CHPIV PROVIDER "Ahmad Bushra"
	-- ,'1710974084' -- PPCIPA PCP FROM "Copy of CHPIV_Rosters_Consolidated.xlsx" 
	-- ,'1295936201' -- PCPIPA Specialist FROM "Copy of CHPIV_Rosters_Consolidated.xlsx" 
	-- ,'1235368788' -- PPCIPA Mid-Level FROM "Copy of CHPIV_Rosters_Consolidated.xlsx" 
	-- ,'1144255258' -- ICPMG Roster FROM "Copy of CHPIV_Rosters_Consolidated.xlsx" 
	-- ,'1871912717' -- CCIPA Roster FROM "Copy of CHPIV_Rosters_Consolidated.xlsx" 
	-- ,'1487849345' -- MS JOHANNA TESTING PER CONVERSATION ON 20250718: AnayaEufemio Jr.
	-- ) -- CONCLUDE ... 
	
			-- SELECT * FROM #chpiv

	-- /* INNER JOIN #chpiv AS mso ON ISNULL(inn.practiceid,'') = ISNULL(mso.practiceid,'') -- CHPIV FACILITY 
		-- AND ISNULL(inn.locationid,'') = ISNULL(mso.locationid,'')
		
	-- INNER JOIN #chpiv AS mso ON ISNULL(inn.practiceid,'') = ISNULL(mso.practiceid,'') -- CHPIV PROVIDER 
		-- AND ISNULL(inn.locationid,'') = ISNULL(mso.locationid,'')
		-- AND ISNULL(inn.practitionerid,'') = ISNULL(mso.practitionerid,'') */

	-- INNER JOIN #chpiv AS mso ON ISNULL(vpl.practiceid,'') = ISNULL(mso.practiceid,'') -- CHPIV FACILITY 
		-- AND ISNULL(vpl.locationid,'') = ISNULL(mso.locationid,'')
		
	-- INNER JOIN #chpiv AS mso ON ISNULL(vploc.practiceid,'') = ISNULL(mso.practiceid,'') -- CHPIV PROVIDER 
		-- AND ISNULL(vploc.locationid,'') = ISNULL(mso.locationid,'')
		-- AND ISNULL(vploc.practitionerid,'') = ISNULL(mso.practitionerid,'')






-- =====================================================================
		-- 'HCAI' (Healthcare Access Information): --
-- =====================================================================
SELECT DISTINCT ' ' AS 'HCAI (Healthcare Access Information)'
,hcai.*
INTO #hcai
FROM 
( -- INITIATE ...
SELECT PracticeID
,ClassOrCategory
, ServiceTypeName
,ServiceCategoryTypeName
,Code1
,Code2
,LocationID
,LocationName
,TRY_CONVERT(nvarchar(25),Notes) AS [HCAI ID] -- C002: UPDATE FOR MY204 AS OF 20250203 The DMHC’s standardized terminology is set forth in appendices A-F of the Annual Network Submission Instruction Manual for RY 2025. The health plan should also refer to the “Standardized Terminology and Other Reporting Resources” section of the Resources tab ON the Timely Access and Annual Network Reporting Web Portal for information ON standardized terminology resources. Please note, the DMHC relies ON the California Licensed Healthcare Facility Listing released by the California Department of Healthcare Access Information ('HCAI') to populate the Hospital and Other Inpatient Facility Name section of the Crosswalks tab. In addition, for RY 2025 the DMHC added a field for “'HCAI' ID” within the Hospital Report tab of the Hospital and Clinic Report Form. The “'HCAI' ID” field captures the unique identifier established by 'HCAI' to identify facilities used in the Licensed Facility Information System (LFIS). (See All Plan Letter (APL) 24-019.) The Plan may use the facility information provided ON www.'HCAI'.ca.gov to review its terminology and to identify the 'HCAI' ID for completing the Hospital and Clinic Report Form ... USE https://www.HCAI.ca.gov	 	
,Notes
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st',	
FROM eVips_chgcv.dbo.vwLocationServices 
WHERE 1=1
	--AND LocationName LIKE '%THORTON%'
	--	OR LocationName LIKE '%SCRIP%REHAB%'
	AND ServiceTypeName LIKE '%HCAI%'
	) -- CONCLUDE ...
	AS hcai

		-- SELECT * FROM #hcai
		






--------------------------------------------------------------------------------------------------------------------
	-- Error Trapping: Check If Permanent Table(s) Already Exist(s) And Drop If Applicable --
--------------------------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS #LIC_FAC -- SQL Server 2016 and later -- DYNAMIC tmp OR STATIC [TABLE] #TableName is a local temporary table visible only in the current session; #TableName is a GLOBAL temporary table visible to all sessions IN ('TempDB')

SELECT DISTINCT vploc.LocationID
,vploc.PracticeID
,vploc.AddressID
,REPLACE((LTRIM(RTRIM(vplic.LicenseNumber))),'-','') AS [CA_LIC]
INTO #LIC_FAC
-- SELECT vploc.Archived,vplic.Archived,vplic.LicenseNumber,vplic.PrimaryLicense,* -- CHECK 1st
-- SELECT * FROM eVips_chgcv.dbo.vwPracticeLicenses WHERE (LTRIM(RTRIM(LicenseNumber))) = '090000013' -- CHECK 1st 
-- SELECT DISTINCT LocationTypeName FROM eVips_chgcv.dbo.vwPracticeLocations -- CHECK 1st
FROM eVips_chgcv.dbo.vwPracticeLocations AS vploc
	INNER JOIN eVips_chgcv.dbo.vwPracticeLicenses AS vplic ON vploc.PracticeID = vplic.PracticeID
		AND vploc.LocationID = vplic.LocationID
		AND vploc.AddressID = vplic.AddressID
WHERE (LTRIM(RTRIM(vploc.LocationTypeName))) LIKE '%PRACTIC%'
	AND ((LTRIM(RTRIM(vplic.LicenseTypeName))) LIKE '%LICENSE%'
			OR vplic.LicenseTypeName IS NULL)
	AND vplic.LicenseNumber IS NOT NULL
	AND (LTRIM(RTRIM(vplic.LicenseNumber))) != ''
	AND (LTRIM(RTRIM(vplic.PrimaryLicense))) = 'Y'
	AND (LTRIM(RTRIM(vploc.Archived))) = 'N'
	AND (LTRIM(RTRIM(vplic.Archived))) = 'N'

		-- SELECT * FROM #LIC_FAC

--------------------------------------------------------------------------------------------------------------------
	-- Error Trapping: Check If Permanent Table(s) Already Exist(s) And Drop If Applicable --
--------------------------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS #LIC_PROV -- SQL Server 2016 and later -- DYNAMIC tmp OR STATIC [TABLE] #TableName is a local temporary table visible only in the current session; #TableName is a GLOBAL temporary table visible to all sessions IN ('TempDB')

SELECT DISTINCT vploc.PractitionerID AS [lookup_key]
,vploc.PractitionerID
,REPLACE((LTRIM(RTRIM(vplic.LicenseNumber))),'-','') AS [CA_LIC]
INTO #LIC_PROV
-- SELECT vploc.Archived,vplic.Archived,vplic.LicenseNumber,vplic.PrimaryLicense,* -- CHECK 1st
-- SELECT * FROM eVips_chgcv.dbo.vwPractitionerLicenses -- CHECK 1st 
-- SELECT DISTINCT LocationTypeName FROM eVips_chgcv.dbo.vwPractitionerLocations -- CHECK 1st
FROM eVips_chgcv.dbo.vwPractitionerLocations AS vploc
	INNER JOIN eVips_chgcv.dbo.vwPractitionerLicenses AS vplic ON vploc.PractitionerID = vplic. PractitionerID
WHERE ((LTRIM(RTRIM(vplic.LicenseTypeName))) LIKE '%LICENSE%'
			OR vplic.LicenseTypeName IS NULL)
	AND vplic.LicenseNumber IS NOT NULL
	AND (LTRIM(RTRIM(vplic.LicenseNumber))) != ''
	AND (LTRIM(RTRIM(vplic.PrimaryLicense))) = 'Y'
	AND (LTRIM(RTRIM(vploc.Archived))) = 'N'
	AND (LTRIM(RTRIM(vplic.Archived))) = 'N'

		-- SELECT * FROM #LIC_PROV
		






--------------------------------------------------------------------------------------------------------------------
	-- Error Trapping: Check If Permanent Table(s) Already Exist(s) And Drop If Applicable --
--------------------------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS #PHONEprimary -- SQL Server 2016 and later -- DYNAMIC tmp OR STATIC [TABLE] #TableName is a local temporary table visible only in the current session; #TableName is a GLOBAL temporary table visible to all sessions IN ('TempDB')

SELECT DISTINCT LocationID,PracticeID,LTRIM(RTRIM(PhoneNumber)) AS [PhoneNumber]
INTO #PHONEprimary
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT PracticeTypeName FROM eVips_chgcv.dbo.vwLocationPhones -- CHECK 1st
FROM eVips_chgcv.dbo.vwLocationPhones
WHERE (LTRIM(RTRIM(PhoneTypeName))) LIKE '%PRIMAR%'

		-- SELECT * FROM #PHONEprimary
		
/* ,[DepartmentPhone] = SUBSTRING(LTRIM(RTRIM(qupd.PhoneNumber)),1,3)+'-'+SUBSTRING(LTRIM(RTRIM(qupd.PhoneNumber)),4,3)+'-'+SUBSTRING(LTRIM(RTRIM(qupd.PhoneNumber)),7,4)
,[Telephone Number] = SUBSTRING(LTRIM(RTRIM(qupd.PhoneNumber)),1,3)+'-'+SUBSTRING(LTRIM(RTRIM(qupd.PhoneNumber)),4,3)+'-'+SUBSTRING(LTRIM(RTRIM(qupd.PhoneNumber)),7,4)

	INNER JOIN #PHONEprimary AS qupd ON inet.PracticeID = qupd.PracticeID
		AND inet.LocationID = qupd.LocationID

		LEFT JOIN #PHONEprimary AS qupd ON vploc.PracticeID = qupd.PracticeID
			AND vploc.LocationID = qupd.LocationID */
			






-- ==================================================================
	-- BASELINE eVIPS PROVIDER CHECK(s) --
-- ==================================================================
SELECT DISTINCT ' ' AS  'BASELINE eVIPS PROVIDER CHECK(s): '
,ISNULL(ipaopb.[In-Person Appointments],'Y') AS [In-Person Appointments] -- C003: PER SIR ALEC FINDINGS ... mark all provider entries individually based on their product code. Y for “In-Person Appointments” if the product code is anything other than HBP. N if product code is HBP see "In-Person Apointments Report.docx"
,UPPER(LTRIM(RTRIM(vpp.ProductTypeName))) AS [In-Person Appointments Assessment (HBP=N Otherwise Y)]
,vpp.ProductName
,UPPER(LTRIM(RTRIM(vpp.PracticeID))) AS [DBAPracticeID]
,UPPER(LTRIM(RTRIM(vpp.PracticeName))) AS [DBA]
,calic.[CA_LIC]
,TRY_CONVERT(date,vpp.DateFrom) AS [DateFrom]
,TRY_CONVERT(date,vpp.DateTo) AS [DateTo]
,CAST(vpp.DateFrom AS date) AS [ContractEffectiveDate]
,CAST(vpp.DateTo AS date) AS [ContractExpirationDate]
,DERIVEDPROV.QNXTprovid
,DERIVEDPROV.ProviderAlternateID
,vpd.NationalProviderID
,vpps.SpecialtyCode
,vpps.SpecialtyName
,vpd.LastName
,vpd.FirstName
,vpps.InDirectory
,vpd.Archived AS [vpdARCHIVE]
,vpps.Archived AS [vppsARCHIVE]
,vploc.Archived AS [vplocARCHIVE]
,vpracloc.Archived AS [vpraclocARCHIVE]
,vpd.PractitionerStatus
,vpp.Archived
,vpp.StatusTypeName
,vploc.LineNumber1
,vploc.LineNumber2
,vploc.LineNumber3
,vploc.City
,vploc.[State]
,vploc.ZipCode
,ISNULL(addcounty.County,'') AS [COUNTY]
,vploc.PractitionerID
,vploc.PracticeID
,vploc.LocationID
,proveth.[Ethnicity]
,PHONEfax.FaxNumber
,[DepartmentPhone] = SUBSTRING(LTRIM(RTRIM(qupd.PhoneNumber)),1,3)+'-'+SUBSTRING(LTRIM(RTRIM(qupd.PhoneNumber)),4,3)+'-'+SUBSTRING(LTRIM(RTRIM(qupd.PhoneNumber)),7,4)
,[Telephone Number] = SUBSTRING(LTRIM(RTRIM(qupd.PhoneNumber)),1,3)+'-'+SUBSTRING(LTRIM(RTRIM(qupd.PhoneNumber)),4,3)+'-'+SUBSTRING(LTRIM(RTRIM(qupd.PhoneNumber)),7,4)
,ISNULL(tgi.[TGI_INDICATOR],'N') AS 'TGI_INDICATOR'
,ISNULL(thi.[Telehealth_Indicator],'N') AS [Telehealth_Indicator] -- C###: APPLICABLE TO PROVIDERS ONLY!!! ADD - ON PER EMAIL FROM MS JOHANNA BASED UPON DHCS FINDING (LEVERAGE: APL 25-014 AND OR "PROVDIR Telehealth Indicator evips location .msg")
INTO #baselineprovider
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM eVips_chgcv.dbo.vwPractitionerDemographics AS vpd
	INNER JOIN eVips_chgcv.dbo.vwPractitionerProducts AS vpp ON vpd.PractitionerID = vpp.PractitionerID -- aka cert_provider
		-- AND vpp.ProductID = vpps.ProductID -- aka cert_provider
	INNER JOIN eVips_chgcv.dbo.vwPractitionerProductSpecialties AS vpps ON vpp.PractitionerProductRecID = vpps.PractitionerProductRecID
	INNER JOIN 
	( -- INITIATE ...
	SELECT DISTINCT vpprovloc.PractitionerID,vpprovloc.PracticeID,vpprovloc.LocationID,vpprovloc.AddressID,vpprovloc.LastName,vpprovloc.FirstName,vpprovloc.Archived,vpprovloc.LocationName,vpprovloc.NationalProviderID AS [LocationNPI],vpprovloc.LocationNotes,vpprovloc.PracticeTypeName,vpprovloc.ProviderNumber,vpprovloc.website,vpfacloc.LineNumber1,vpfacloc.LineNumber2,vpfacloc.LineNumber3,vpfacloc.City,vpfacloc.[State],vpfacloc.ZipCode,vpfacloc.LocationTypeName 
	FROM eVips_chgcv.dbo.vwPractitionerLocations AS vpprovloc
		INNER JOIN eVips_chgcv.dbo.vwPracticeLocations AS vpfacloc ON vpprovloc.PracticeID = vpfacloc.PracticeID
			AND vpprovloc.LocationID = vpfacloc.LocationID 
		WHERE 1=1
			AND LTRIM(RTRIM(ISNULL(vpfacloc.LocationTypeName,''))) LIKE '%PRACTI%'
			) -- CONCLUDE ...
			AS vploc ON vploc.PractitionerID = vpd.PractitionerID
				AND vploc.PracticeID = vpp.PracticeID
				AND vploc.LocationID = vpp.LocationID
				-- AND vploc.AddressID = vpp.AddressID
	INNER JOIN eVips_chgcv.dbo.vwPracticeLocations AS vpracloc ON vpp.practiceid = vpracloc.practiceid  --SPECIAL ADD - ON JOIN (s)
		AND vpp.Locationid = vpracloc.Locationid --SPECIAL ADD - ON JOIN (s)

	/* INNER JOIN #chpiv AS mso ON ISNULL(vpl.practiceid,'') = ISNULL(mso.practiceid,'') -- CHPIV FACILITY 
		AND ISNULL(vpl.locationid,'') = ISNULL(mso.locationid,'') */
		
	INNER JOIN #chpiv AS mso ON ISNULL(vploc.practiceid,'') = ISNULL(mso.practiceid,'') -- CHPIV PROVIDER 
		AND ISNULL(vploc.locationid,'') = ISNULL(mso.locationid,'')
		AND ISNULL(vploc.practitionerid,'') = ISNULL(mso.practitionerid,'')

		-- LEFT JOIN #LIC_PROV AS lp ON vpd.PractitionerID = lp.PractitionerID

		LEFT JOIN eVips_chgcv.dbo.vwPractitionerSpecialties AS vps ON vpd.PractitionerID = vps.PractitionerID	
			AND vpps.specialtycode = vps.specialtycode
		LEFT JOIN 
		( -- INITIATE ...
		SELECT DISTINCT ProviderID,TableName,EntityCode,EntityName,EntityTypeCode,EntityTypeName 
		FROM eVips_chgcv.dbo.vwEntityAssignments 
		WHERE 1=1
			AND LTRIM(RTRIM(ISNULL(TableName,''))) LIKE '%PRACTI%'
			) -- CONCLUDE ... 
			AS vea ON vpd.PractitionerID = vea.ProviderID --ProviderID = PractitionerID WHERE (LTRIM(RTRIM(vea.TableName))) LIKE '%Practit%' OR  ProviderID = PracticeID WHERE (LTRIM(RTRIM(vea.TableName))) LIKE '%Practice%'
		LEFT JOIN INFORMATICS.dbo.ZIP_CODES AS zip ON CASE
		WHEN SUBSTRING(LTRIM(RTRIM(vploc.ZipCode)),1,1) = '0'
		THEN '0'+ SUBSTRING(LTRIM(RTRIM(vploc.ZipCode)),2,4)
		WHEN SUBSTRING(LTRIM(RTRIM(vploc.ZipCode)),1,1) = '00'
		THEN '00'+ SUBSTRING(LTRIM(RTRIM(vploc.ZipCode)),3,3)
		ELSE  SUBSTRING(LTRIM(RTRIM(vploc.ZipCode)),1,5) 
		END COLLATE DATABASE_DEFAULT  = SUBSTRING(LTRIM(RTRIM(zip.ZipCode)),1,5) COLLATE DATABASE_DEFAULT -- FORMERLY SQL01.DEV_DB.dbo.ZIP_CODES
		LEFT JOIN 
		( -- INITIATE ...
		SELECT DISTINCT zipcode,city,county,RegionTypeName 
		FROM eVips_chgcv.dbo.vwzipcodes 
		WHERE 1=1
				AND LTRIM(RTRIM(ISNULL(county,''))) LIKE '%SAN%DIEGO%'
			) -- CONCLUDE ...
			AS regionis ON CASE 
			WHEN SUBSTRING(LTRIM(RTRIM(vploc.ZipCode)),1,1) = '0' 
			THEN '0'+ SUBSTRING(LTRIM(RTRIM(vploc.ZipCode)),2,4) 
			WHEN SUBSTRING(LTRIM(RTRIM(vploc.ZipCode)),1,1) = '00' 
			THEN '00'+ SUBSTRING(LTRIM(RTRIM(vploc.ZipCode)),3,3) 
			ELSE  SUBSTRING(LTRIM(RTRIM(vploc.ZipCode)),1,5) 
			END = CASE 
			WHEN SUBSTRING(LTRIM(RTRIM(regionis.ZipCode)),1,1) = '0' 
			THEN '0'+ SUBSTRING(LTRIM(RTRIM(regionis.ZipCode)),2,4) 
			WHEN SUBSTRING(LTRIM(RTRIM(regionis.ZipCode)),1,1) = '00' 
			THEN '00'+ SUBSTRING(LTRIM(RTRIM(regionis.ZipCode)),3,3) 
			ELSE  SUBSTRING(LTRIM(RTRIM(regionis.ZipCode)),1,5) 
			END
		LEFT JOIN 
		( -- INITIATE ...
		SELECT DISTINCT r.FieldName,r.DisplayName,s.specialtycode,s.specialtyName AS [eVIPS_Specialty],r.Value AS [TIMELYACCESS_Profile] 
		FROM evips_chgcv.dbo.vwReferenceUserFields AS r 
			LEFT JOIN evips_chgcv.dbo.vwSpecialties AS s ON r.ParentRecID  = s.specialtyid
		WHERE 1=1
			AND r.tablename IN ('Specialties')
			AND r.fieldName IN ('Specialty Grouping - Timely Access')
			) -- CONCLUDE ...
			AS profile ON CASE
			WHEN vpps.SpecialtyCode IS NULL
			THEN (LTRIM(RTRIM(vpps.SpecialtyName)))
			ELSE (LTRIM(RTRIM(vpps.SpecialtyCode)))
			END = (LTRIM(RTRIM(ISNULL(profile.specialtycode,'')))) -- AS [DefineOTH_SPE]
		LEFT JOIN 
		( -- INITIATE 
		SELECT ' ' AS 'TGI (TRANS-GENDER) INDICATOR' -- C003: ADD Hi Walter, Please let me know if you have any questions. TGI indicator was added under the Personal tab/Personal ID/TGI/Notes 
		,ISNULL(Notes,'N') AS [TGI_INDICATOR],*
		FROM eVips_chgcv.dbo.vwPractitionerAlternateIDs  
		WHERE 1=1 
			AND (LTRIM(RTRIM(ISNULL(AlternateIDTypeName,'')))) LIKE '%TGI%' 
			AND archived = 'N'
		) -- CONCLUDE ...
		AS tgi ON vpd.PractitionerID = tgi.ProviderID

		LEFT JOIN 
		( -- INITIATE ...
		SELECT ' ' AS 'TELEHEALTH INDICATOR: ' -- C003: ADD Hi Walter, Please let me know if you have any questions. TGI indicator was added under the Personal tab/Personal ID/TGI/Notes 
		,ISNULL(Notes,'N') AS [Telehealth_Indicator]
		,ProviderID AS 'practitionerid'
		FROM eVips_chgcv.dbo.vwPractitionerAlternateIDs  
		WHERE 1=1 
				AND (LTRIM(RTRIM(ISNULL(AlternateIDTypeName,'')))) LIKE '%TELEH%' 
				AND archived = 'N' 
		GROUP BY ISNULL(Notes,'N'),ProviderID
		) -- CONCLUDE ...
		AS thi ON vpd.practitionerid = thi.practitionerid

		LEFT JOIN 
		( -- INITIATE ...
		SELECT ' ' AS 'ADD COUNTY FROM "DMHC CA County and ZIP Code Combinations - Revised 3.24.2020.xlsx" : ' 
		,City
		,[State]
		,SUBSTRING(LTRIM(RTRIM(ISNULL(ZipCode,''))),1,5) AS ZIP
		,ZipCode
		,County
		FROM INFORMATICS.dbo.ZIP_CODES -- LEVERAGE: "ZIP_DMHC CA County and ZIP Code Combinations - Revised 3.24.2020.xlsx" AND / OR "TIMELYACCESS_...rar" SERVICE AREA
		WHERE 1=1
			-- AND County LIKE '%SAN%DIEG%'
		GROUP BY City,[State],SUBSTRING(LTRIM(RTRIM(ISNULL(ZipCode,''))),1,5),ZipCode,County
		) -- CONCLUDE ...
		AS addcounty ON CASE
		WHEN SUBSTRING(LTRIM(RTRIM(vploc.ZipCode)),1,1) = '0'
		THEN '0'+ SUBSTRING(LTRIM(RTRIM(vploc.ZipCode)),2,4)
		WHEN SUBSTRING(LTRIM(RTRIM(vploc.ZipCode)),1,1) = '00'
		THEN '00'+ SUBSTRING(LTRIM(RTRIM(vploc.ZipCode)),3,3)
		ELSE  SUBSTRING(LTRIM(RTRIM(vploc.ZipCode)),1,5) 
		END = addcounty.ZIP

		LEFT JOIN #LIC_PROV AS calic ON vpd.PractitionerID = calic.PractitionerID

		LEFT JOIN ( -- INITIATE ...
		SELECT DISTINCT IDNumber AS [QNXTprovid],IDNumber,ProviderAlternateID,ProviderID,AlternateIDTypeID FROM eVips_chgcv.dbo.vwPractitionerAlternateIDs WHERE UPPER(LTRIM(RTRIM(ISNULL(AlternateIDTypeName,'')))) LIKE '%QNXT%' AND archived = 'N'
		) -- CONCLUDE ...
		AS DERIVEDPROV ON vpd.PractitionerID = DERIVEDPROV.[ProviderID]-- ,UPPER(LTRIM(RTRIM(vpd.PractitionerID))) AS 'lookup_key' DERIVED() ALIASNAME CONCLUDE ...

		LEFT JOIN 
		( -- INITIATE ...
		SELECT DISTINCT ' 'AS 'FROM PROVDIR CODE: "%HBP%" PROVIDER(S)'
		,LTRIM(RTRIM(vpd.NationalProviderID)) AS NPIis
		,UPPER(LTRIM(RTRIM(vpp.ProductTypeName))) AS [PROVIDER_TYPEdescr]
		,TRY_CONVERT(nvarchar(1),'N') AS 'In-Person Appointments'  -- C003: PER SIR ALEC FINDINGS ... mark all provider entries individually based on their product code. Y for “In-Person Appointments” if the product code is anything other than HBP. N if product code is HBP see "In-Person Apointments Report.docx"
		FROM eVips_chgcv.dbo.vwPractitionerDemographics AS vpd
			INNER JOIN eVips_chgcv.dbo.vwPractitionerProducts AS vpp ON vpd.PractitionerID = vpp.PractitionerID -- aka cert_provider
				-- AND vpp.ProductID = vpps.ProductID -- aka cert_provider
		WHERE 1=1
			AND UPPER(LTRIM(RTRIM(vpp.ProductTypeName))) LIKE '%HBP%'
		) -- CONCLUDE ...
		AS ipaopb ON LTRIM(RTRIM(vpd.NationalProviderID)) COLLATE SQL_Latin1_General_CP1_CI_AS  = ipaopb.NPIis COLLATE SQL_Latin1_General_CP1_CI_AS 

		LEFT JOIN 
		(-- INITIATE ...
		SELECT DISTINCT CASE 
		WHEN UPPER(LTRIM(RTRIM(ISNULL(vpd.EthnicityName,'OTHER')))) IN ('','APP=NOT DISCLOSED','NOT ON APP')
		THEN 'UNKNOWN'
		ELSE UPPER(LTRIM(RTRIM(ISNULL(vpd.EthnicityName,'OTHER'))))
		END AS [Ethnicity],*
		FROM eVips_chgcv.dbo.vwPractitionerDemographics AS vpd 
		) -- CONCLUDE ...
		AS proveth ON vpd.PractitionerID = proveth.PractitionerID
		
		LEFT JOIN (SELECT DISTINCT LocationID,PracticeID,LTRIM(RTRIM(PhoneNumber)) AS [FaxNumber] FROM eVips_chgcv.dbo.vwLocationPhones WHERE 1=1 AND UPPER(LTRIM(RTRIM(PhoneTypeName))) LIKE '%FAX%') AS PHONEfax ON vploc.practiceid = PHONEfax.practiceid  --PHONE ADD - ON JOIN (s)
			AND vploc.Locationid= PHONEfax.Locationid --FAX ADD - ON JOIN (s)	

		LEFT JOIN #PHONEprimary AS qupd ON vploc.PracticeID = qupd.PracticeID
			AND vploc.LocationID = qupd.LocationID
WHERE 1=1
	AND 
	( -- INITIATE ...
	(LTRIM(RTRIM(ISNULL(vpps.InDirectory,'')))) LIKE '%%%' --  @INDIR --SET @INDIR ='Y'--REMOVE FILTER FOR JOSEPH / TIMELYACCESS HBP(s)... '%' OR 'Y'  OR 'N'--SUBSTRING((LTRIM(RTRIM(cert_provider.in_directory))),1,1) LIKE @INDIR --see 'LTRIM(RTRIM(mcred.retrieve_list)) LIKE '%CN%V%'
		AND (LTRIM(RTRIM(vpd.Archived))) IN ('N') --WITH eVIPS LOGICAL BINARY OPTION(s) IN USE •	Must not be archived 
		AND (LTRIM(RTRIM(vpps.Archived))) IN ('N') -- ADD ON per MEETING ;WITH YOUNG LADY LAURA, SC & HL ON 20171226
		AND (LTRIM(RTRIM(vploc.Archived))) IN ('N') --WITH eVIPS LOGICAL BINARY OPTION(s) IN USE •	Must not be archived
		AND (LTRIM(RTRIM(vpracloc.Archived))) IN ('N')
		AND (LTRIM(RTRIM(ISNULL(vpd.PractitionerStatus,'')))) IN ('ACTIVE','') --•	Overall Status must be Active
		AND (LTRIM(RTRIM(vpp.Archived))) IN ('N') --WITH eVIPS LOGICAL BINARY OPTION(s) IN USE •	Must not be archived 
		) -- CONCLUDE ...
	AND ISNULL(vpp.StatusTypeName,'') IN ('Y','','Active','Active - Per Diem') --•	Plan Status must be: ‘Active’ or ‘Active Per Diem’ or Active VIP for a Product Name (CMC or MEDICAL):

	AND ISNULL(vpp.ProductName,'') IN ('CHPIV-DSNP')
	AND NOT EXISTS ( -- DEFINITIVE ANSWER: Returns TRUE the moment SQL Server finds EVEN ONE MATCHING ROW IN THE SUBQUERY. It immediately stops scanning -- it does not count rows, does not return data, just confirms presence. This is why SELECT 1 is used -- the actual column value is irrelevant. -- IN PLAIN LANGUAGE: "Does at least one row exist in #PROVISOLATION where the provider ID matches?" ... NOT EXISTS(): EXACT LOGICAL INVERSE. Returns TRUE only WHEN THE SUBQUERY FINDS ZERO MATCHING ROWS. It is the correct, sargable, SQL-idiomatic way to express "exclude any claim whose provider appears in this list." It is semantically equivalent to a LEFT JOIN ... WHERE joined_table.key IS NULL anti-join pattern, but often cleaner and more readable.
	SELECT 1
	FROM INFORMATICS.dbo.CHPIV_NETWORK_DATA AS piso -- NON PROVDIR AND NON EXTERNAL IPA ROSTER [NPI]
	WHERE 1=1
		AND ISNULL(vpd.NationalProviderID,'') = ISNULL(piso.NPI_NO,'') -- KEY ON ... [Rendering Provider]
		)

		-- SELECT * FROM #baselineprovider
	






-- ==================================================================
	-- BASELINE eVIPS FACILITY CHECK(s) --
-- ==================================================================
SELECT DISTINCT ' ' AS 'BASELINE eVIPS FAC CHECK(s): '
,calic.[CA_LIC]
,vlp.ProductName
,UPPER(LTRIM(RTRIM(vp.PracticeID))) AS [DBAPracticeID]
,UPPER(LTRIM(RTRIM(vp.PracticeName))) AS [DBA]
,DERIVEDFAC.QNXTprovid
,DERIVEDFAC.ProviderAlternateID
,vpl.PracticeID
,vp.PracticeName
,vpl.LocationID
,vpl.LocationName
,UPPER(LTRIM(RTRIM(vlp.InDirectory))) AS [INDIRECTORY]
,UPPER(LTRIM(RTRIM(vp.Archived))) AS [vpARCHIVED]
,UPPER(LTRIM(RTRIM(vp.PracticeStatus))) AS [vpPRACTICESTATUS]
,UPPER(LTRIM(RTRIM(vp.ApplicationStatus))) AS [vpAPPLICATIONSTATUS]
,UPPER(LTRIM(RTRIM(vpl.Archived))) AS [vplARCHIVED]
,UPPER(LTRIM(RTRIM(vpl.LocationTypeName))) AS [vplLOCATIONTYPENAME]
,UPPER(LTRIM(RTRIM(vlp.LocationTypeName))) AS [vlpLOCATIONTYPENAME]
,UPPER(LTRIM(RTRIM(vlp.Archived))) AS [vlpARCHIVED]
,UPPER(LTRIM(RTRIM(vlp.StatusTypeName))) AS [vlpSTATUSTYPENAME]
,UPPER(LTRIM(RTRIM(ISNULL(vlp.ServiceTypeName,'')))) AS [vlpSERVICETYPENAME]
,CAST(NULL AS nvarchar(5)) AS [providence]
,CAST(NULL AS nvarchar(100)) AS ID
,UPPER(LTRIM(RTRIM(vp.PracticeTypeName))) AS [VP_plan_type]
,UPPER(LTRIM(RTRIM(vlp.PracticeTypeName))) AS [VLP_plan_type]
,UPPER(LTRIM(RTRIM(vlp.ProductTypeCode))) AS [VLP_Alt_plan_type]
,UPPER(LTRIM(RTRIM(vlp.ProductTypeName))) AS [VLP_full_plan_name]
,UPPER(LTRIM(RTRIM(vp.PracticeTypeName))) AS [plan_type]
,UPPER(LTRIM(RTRIM(vlp.ProductName))) AS [plan_name]
,vp.LegalName AS [VPLegalName]
,vpl.LegalName AS [VPLLegalName]
,UPPER(LTRIM(RTRIM(vpl.LocationName))) AS [HospitalName]
,UPPER(LTRIM(RTRIM(vpl.LocationName))) AS [FacilityName]
,UPPER(LTRIM(RTRIM(vpl.LocationName))) AS [Clinic Name]
,UPPER(LTRIM(RTRIM(vpl.LocationName))) AS [Pharmacy Name] -- We have most of the NPIs for the clinics.  They are located in the NPI field in the address master
-- ,LTRIM(RTRIM(vpl.NationalProviderID)) AS NPIis
,LTRIM(RTRIM(vp.NationalProviderID)) AS altNPIis
,REPLACE(UPPER(LTRIM(RTRIM(vf.TaxIDNumber))),'-','') AS vfPROVTAXID
,REPLACE(UPPER(LTRIM(RTRIM(vf.TaxIDNumber))),'-','') AS [FEID vfPROVTAXID]
,CASE
WHEN vpl.NationalProviderID IS NULL
	AND UPPER(LTRIM(RTRIM(vf.FacilityStatus))) LIKE 'ACTIVE%'
	AND UPPER(LTRIM(RTRIM(vf.ApplicationStatus))) LIKE 'ACTIVE%'
THEN LTRIM(RTRIM(vf.NationalProviderID))
ELSE LTRIM(RTRIM(vpl.NationalProviderID)) 
END AS [NPIis]
,vpl.TwentyFourHourCoverage
,vpl.LineNumber1
,vpl.LineNumber2
,vpl.City
,vpl.[State]
,vpl.ZipCode
,ISNULL(addcounty.County,'') AS [COUNTY]
,vls.Code1
,vls.Code2
,vls.Code1 AS [FacilityType]
,vls.Code2 AS [InstitutionalFacilityType]
,vea.EntityCode
,vea.EntityName
,vea.EntityTypeCode
,vea.EntityTypeName
,PHONEfax.FaxNumber
,[DepartmentPhone] = SUBSTRING(LTRIM(RTRIM(qupd.PhoneNumber)),1,3)+'-'+SUBSTRING(LTRIM(RTRIM(qupd.PhoneNumber)),4,3)+'-'+SUBSTRING(LTRIM(RTRIM(qupd.PhoneNumber)),7,4)
,[Telephone Number] = SUBSTRING(LTRIM(RTRIM(qupd.PhoneNumber)),1,3)+'-'+SUBSTRING(LTRIM(RTRIM(qupd.PhoneNumber)),4,3)+'-'+SUBSTRING(LTRIM(RTRIM(qupd.PhoneNumber)),7,4)
,TRY_CONVERT(nvarchar(1),'N') AS [Telehealth_Indicator] -- C###: APPLICABLE TO PROVIDERS ONLY!!! ADD - ON PER EMAIL FROM MS JOHANNA BASED UPON DHCS FINDING (LEVERAGE: APL 25-014 AND OR "PROVDIR Telehealth Indicator evips location .msg")
INTO #baselinefacility
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st',
-- SELECT  vlp.Focus,vlsfocus.Code1,vlsfocus.Code2,vp.Archived,vp.PracticeStatus,vp.ApplicationStatus,vpl.Archived,vpl.LocationTypeName,vp.PracticeTypeName,* -- CHECK 1st
-- SELECT * FROM eVips_chgcv.dbo.vwPracticeLocations -- CHECK 1st
-- SELECT DISTINCT PracticeTypeName FROM eVips_chgcv.dbo.vwPracticeLocations -- CHECK 1st UPPER(LTRIM(RTRIM(vpl.PracticeTypeName))) AS [Type of Service]
-- SELECT * FROM eVips_chgcv.dbo.vwEntityAssignments WHERE UPPER(LTRIM(RTRIM(TableName))) LIKE '%Practice%' AND UPPER(LTRIM(RTRIM(EntityName))) LIKE '%MED%IMPA%' -- CHECK 1st
FROM eVips_chgcv.dbo.vwPractices AS vp
	INNER JOIN eVips_chgcv.dbo.vwPracticeLocations AS vpl ON vp.PracticeID = vpl.PracticeID
	
	INNER JOIN #chpiv AS mso ON ISNULL(vpl.practiceid,'') = ISNULL(mso.practiceid,'') -- CHPIV FACILITY 
		AND ISNULL(vpl.locationid,'') = ISNULL(mso.locationid,'')
		
	/* INNER JOIN #chpiv AS mso ON ISNULL(vploc.practiceid,'') = ISNULL(mso.practiceid,'') -- CHPIV PROVIDER 
		AND ISNULL(vploc.locationid,'') = ISNULL(mso.locationid,'')
		AND ISNULL(vploc.practitionerid,'') = ISNULL(mso.practitionerid,'') */

		LEFT JOIN #LIC_FAC AS calic ON vp.PracticeID = calic.PracticeID
			AND vp.LocationID = calic.LocationID

		LEFT JOIN eVips_chgcv.dbo.vwFacilities AS vf ON vpl.LocationName = vf.FacilityName
			OR vp.PracticeName = vf.FacilityName

		LEFT JOIN 
		( -- INITIATE ...
		SELECT DISTINCT PracticeID,ClassOrCategory,ServiceTypeName,ServiceCategoryTypeName,Code1,Code2,LocationID
		FROM eVips_chgcv.dbo.vwLocationServices 
		WHERE ServiceTypeName 
		LIKE '%GROUP%SPEC%'
		) -- CONCLUDE ...
		AS vls ON vp.PracticeID = vls.PracticeID -- DEFINE FAC CHAPTER(s) 				
		LEFT JOIN 
		( -- INITIATE ...
		SELECT DISTINCT LocationID,PracticeID,ClassOrCategory, ServiceTypeName,ServiceCategoryTypeName,code1,code2 
		FROM eVips_chgcv.dbo.vwLocationServices 
		WHERE (LTRIM(RTRIM(ServiceTypeName))) LIKE '%PHARM%TYPE%' 
			AND ServiceCategoryTypeName IS NOT NULL 
			AND (LTRIM(RTRIM(ServiceCategoryTypeName))) != ''
			) -- CONCLUDE ...
			AS vlspharmtype ON vp.PracticeID = vlspharmtype.PracticeID --DEFINE PHARM TYPE(s)
				AND vpl.LocationID = vlspharmtype.LocationID -- per YOUNG LADY LAURA email ON 20171221 ... Products (CMC & MEDICAL)  are stored at Location Level. The code below is joining based only ON Practice ID. This should be based ON PracticeID + Location
		LEFT JOIN 
		( -- INITIATE ...
		SELECT DISTINCT LocationID,PracticeID,ClassOrCategory, ServiceTypeName,ServiceCategoryTypeName,code1,code2 
		FROM eVips_chgcv.dbo.vwLocationServices 
		WHERE (LTRIM(RTRIM(ServiceTypeName))) LIKE '%PHARM%SERV%' 
			AND ServiceCategoryTypeName IS NOT NULL 
			AND (LTRIM(RTRIM(ServiceCategoryTypeName))) != ''
			) -- CONCLUDE ...
			AS vlspharmservice ON vp.PracticeID = vlspharmservice.PracticeID --DEFINE PHARM TYPE(s)
				AND vpl.LocationID = vlspharmservice.LocationID -- per YOUNG LADY LAURA email ON 20171221 ... Products (CMC & MEDICAL)  are stored at Location Level. The code below is joining based only ON Practice ID. This should be based ON PracticeID + Location
		LEFT JOIN 
		( -- INITIATE ...
		SELECT DISTINCT PracticeID,Code1,Code2,ServiceTypeName,ServiceCategoryTypeName 
		FROM eVips_chgcv.dbo.vwLocationServices 
		WHERE ServiceTypeName LIKE '274%TYPE%SERV%'
		) -- CONCLUDE ...
		AS vlsfocus ON vp.PracticeID = vlsfocus.PracticeID --Alt EFFORT TO DEFINE FAC CHAPTER(s)
		LEFT JOIN 
		( -- INITIATE ...
		SELECT DISTINCT ProviderID,TableName,EntityCode,EntityName,EntityTypeCode,EntityTypeName 
		FROM eVips_chgcv.dbo.vwEntityAssignments 
		WHERE (LTRIM(RTRIM(ISNULL(TableName,'')))) LIKE '%PRACTI%'
		) -- CONCLUDE ...
		AS vea ON vp.PracticeID = vea.ProviderID
		LEFT JOIN
		( -- INITIATE ...
		SELECT DISTINCT ljvlp.ProductTypeCode,ljvlp.ProductTypeName,ljvlp.PracticeTypeName,ljvlp.PracticeID,ljvlp.LocationID,ljvlp.Archived,ljvlp.StatusTypeName,vlpstype.indirectory,vlpstype.ServiceTypeCode,vlpstype.ServiceTypeName,ljvlp.productname,ljvlp.ProductPanelStatusTypeName,ljvlp.ProductPanelStatusTypeCode,ljvlp.ProviderNumber,ljvlp.Focus,ljvlp.ProductID,ljvlp.LocationTypeName 
		FROM eVips_chgcv.dbo.vwLocationProducts AS ljvlp 
			INNER JOIN evips_chgcv.dbo.vwLocationProductServices AS vlpstype ON ljvlp.LocationProductRecID = vlpstype.LocationProductRecID 
		WHERE 1=1
			AND ISNULL(ljvlp.Archived,'') IN ('N','') 
			AND (ISNULL(ljvlp.StatusTypeName,'') IN ('ACTIVE','') 
				OR ljvlp.StatusTypeName LIKE '%PARTICIP%')
			AND ISNULL(vlpstype.Archived,'') IN ('N','') 
			) -- CONCLUDE ...
			AS vlp ON vpl.PracticeID = vlp.PracticeID --'YOUNG LADY LAURA GAH ID WHERE p.archived = 'N' AND s.ServiceTypeName = 'HOSPITAL' AND p.focus like '%GAH%'' ON 20171120 see ,(LTRIM(RTRIM(vlp.ServiceTypeName))) AS [vlpSERVICETYPENAME]
				AND vpl.LocationID = vlp.LocationID -- per YOUNG LADY LAURA email ON 20171221 ... Products (CMC & MEDICAL)  are stored at Location Level. The code below is joining based only ON Practice ID. This should be based ON PracticeID + Location
		LEFT JOIN 
		( -- INITIATE ...
		SELECT DISTINCT LocationID,PracticeID,AccreditationTypeCode,AccreditationTypeName,Notes 
		FROM eVips_chgcv.dbo.vwLocationAccreditations AS vla 
		WHERE 1=1
			AND ISNULL(vla.Archived,'') IN ('N','') 
			) -- CONCLUDE ...
			AS accredboard ON vpl.LocationID = accredboard.LocationID
				AND vpl.PracticeID = accredboard.PracticeID
		LEFT JOIN INFORMATICS.dbo.ZIP_CODES AS zip ON CASE
		WHEN SUBSTRING(LTRIM(RTRIM(vpl.ZipCode)),1,1) = '0'
		THEN '0'+ SUBSTRING(LTRIM(RTRIM(vpl.ZipCode)),2,4)
		WHEN SUBSTRING(LTRIM(RTRIM(vpl.ZipCode)),1,1) = '00'
		THEN '00'+ SUBSTRING(LTRIM(RTRIM(vpl.ZipCode)),3,3)
		ELSE  SUBSTRING(LTRIM(RTRIM(vpl.ZipCode)),1,5) 
		END = SUBSTRING(LTRIM(RTRIM(zip.ZipCode)),1,5) COLLATE DATABASE_DEFAULT
		LEFT JOIN 
		( -- INITIATE ...
		SELECT DISTINCT zipcode,city,county,RegionTypeName 
		FROM eVips_chgcv.dbo.vwzipcodes 
		WHERE (LTRIM(RTRIM(ISNULL(county,'')))) LIKE '%SAN%DIEGO%'
		) -- CONCLUDE ...
		AS regionis ON CASE 
		WHEN SUBSTRING(LTRIM(RTRIM(vpl.ZipCode)),1,1) = '0' 
		THEN '0'+ SUBSTRING(LTRIM(RTRIM(vpl.ZipCode)),2,4) 
		WHEN SUBSTRING(LTRIM(RTRIM(vpl.ZipCode)),1,1) = '00' 
		THEN '00'+ SUBSTRING(LTRIM(RTRIM(vpl.ZipCode)),3,3) 
		ELSE  SUBSTRING(LTRIM(RTRIM(vpl.ZipCode)),1,5) 
		END = CASE 
		WHEN SUBSTRING(LTRIM(RTRIM(regionis.ZipCode)),1,1) = '0' 
		THEN '0'+ SUBSTRING(LTRIM(RTRIM(regionis.ZipCode)),2,4) 
		WHEN SUBSTRING(LTRIM(RTRIM(regionis.ZipCode)),1,1) = '00' 
		THEN '00'+ SUBSTRING(LTRIM(RTRIM(regionis.ZipCode)),3,3) 
		ELSE  SUBSTRING(LTRIM(RTRIM(regionis.ZipCode)),1,5) 
		END

		LEFT JOIN 
		( -- INITIATE ...
		SELECT ' ' AS 'ADD COUNTY FROM "DMHC CA County and ZIP Code Combinations - Revised 3.24.2020.xlsx" : ' 
		,City
		,[State]
		,SUBSTRING(LTRIM(RTRIM(ISNULL(ZipCode,''))),1,5) AS ZIP
		,ZipCode
		,County
		FROM INFORMATICS.dbo.ZIP_CODES -- LEVERAGE: "ZIP_DMHC CA County and ZIP Code Combinations - Revised 3.24.2020.xlsx" AND / OR "TIMELYACCESS_...rar" SERVICE AREA
		WHERE 1=1
			-- AND County LIKE '%SAN%DIEG%'
		GROUP BY City,[State],SUBSTRING(LTRIM(RTRIM(ISNULL(ZipCode,''))),1,5),ZipCode,County
		) -- CONCLUDE ...
		AS addcounty ON  CASE
		WHEN SUBSTRING(LTRIM(RTRIM(vpl.ZipCode)),1,1) = '0'
		THEN '0'+ SUBSTRING(LTRIM(RTRIM(vpl.ZipCode)),2,4)
		WHEN SUBSTRING(LTRIM(RTRIM(vpl.ZipCode)),1,1) = '00'
		THEN '00'+ SUBSTRING(LTRIM(RTRIM(vpl.ZipCode)),3,3)
		ELSE  SUBSTRING(LTRIM(RTRIM(vpl.ZipCode)),1,5) 
		END = addcounty.ZIP

		LEFT JOIN 
		( -- INITIATE ...
		SELECT DISTINCT r.FieldName,r.DisplayName,s.specialtycode,s.specialtyName AS [eVIPS_Specialty],r.Value AS [TIMELYACCESS_Profile] 
		FROM evips_chgcv.dbo.vwReferenceUserFields AS r 
		LEFT JOIN evips_chgcv.dbo.vwSpecialties AS s ON r.ParentRecID  = s.specialtyid
		WHERE r.tablename = 'Specialties' 
		AND r.fieldName = 'Specialty Grouping - Timely Access'
		) -- CONCLUDE ... 
		AS profile ON UPPER(LTRIM(RTRIM(ISNULL(vlsfocus.Code1,'')))) = UPPER(LTRIM(RTRIM(ISNULL(profile.specialtycode,''))))
		
		LEFT JOIN 
		( -- INITIATE ...
		SELECT DISTINCT IDNumber AS [QNXTprovid],IDNumber,ProviderAlternateID/* ,ProviderID */,LocationID,AlternateIDTypeID FROM eVips_chgcv.dbo.vwPracticeAlternateIDs  WHERE UPPER(LTRIM(RTRIM(ISNULL(AlternateIDTypeName,'')))) LIKE '%QNXT%' AND archived = 'N'
		) -- CONCLUDE ...
		AS DERIVEDFAC ON vpl.[LocationID] =DERIVEDFAC.[LocationID] -- ,vpl.LocationID DERIVED() ALIASNAME CONCLUDE ...	

		LEFT JOIN (SELECT DISTINCT LocationID,PracticeID,LTRIM(RTRIM(PhoneNumber)) AS [FaxNumber] FROM eVips_chgcv.dbo.vwLocationPhones WHERE 1=1 AND UPPER(LTRIM(RTRIM(PhoneTypeName))) LIKE '%FAX%') AS PHONEfax ON vpl.practiceid = PHONEfax.practiceid  --PHONE ADD - ON JOIN (s)
			AND vpl.Locationid= PHONEfax.Locationid --FAX ADD - ON JOIN (s)
	
		LEFT JOIN #PHONEprimary AS qupd ON vpl.PracticeID = qupd.PracticeID
			AND vpl.LocationID = qupd.LocationID
			
WHERE 1=1 
	AND vp.Archived IN ('N') --WITH eVIPS LOGICAL BINARY OPTION(s) IN USE •	Must not be archived 
	AND ISNULL(vp.PracticeStatus,'') IN ('ACTIVE','CONTRACTED','NA','') --•	Contract Status must be Active
	AND vpl.Archived IN ('N') --WITH eVIPS LOGICAL BINARY OPTION(s) IN USE •	Must not be archived
	 
	AND ISNULL(vlp.ProductName,'') IN ('CHPIV-DSNP')
	AND NOT EXISTS ( -- DEFINITIVE ANSWER: Returns TRUE the moment SQL Server finds EVEN ONE MATCHING ROW IN THE SUBQUERY. It immediately stops scanning -- it does not count rows, does not return data, just confirms presence. This is why SELECT 1 is used -- the actual column value is irrelevant. -- IN PLAIN LANGUAGE: "Does at least one row exist in #PROVISOLATION where the provider ID matches?" ... NOT EXISTS(): EXACT LOGICAL INVERSE. Returns TRUE only WHEN THE SUBQUERY FINDS ZERO MATCHING ROWS. It is the correct, sargable, SQL-idiomatic way to express "exclude any claim whose provider appears in this list." It is semantically equivalent to a LEFT JOIN ... WHERE joined_table.key IS NULL anti-join pattern, but often cleaner and more readable.
	SELECT 1
	FROM INFORMATICS.dbo.CHPIV_NETWORK_DATA AS piso -- NON PROVDIR AND NON EXTERNAL IPA ROSTER [NPI]
	WHERE 1=1
		AND ISNULL(CASE
		WHEN vpl.NationalProviderID IS NULL
			AND UPPER(LTRIM(RTRIM(vf.FacilityStatus))) LIKE 'ACTIVE%'
			AND UPPER(LTRIM(RTRIM(vf.ApplicationStatus))) LIKE 'ACTIVE%'
		THEN LTRIM(RTRIM(vf.NationalProviderID))
		ELSE LTRIM(RTRIM(vpl.NationalProviderID)) 
		END,'') = ISNULL(piso.NPI_NO,'') -- KEY ON ... [Rendering Provider]
		)

		-- SELECT * FROM #baselinefacility

INSERT INTO INFORMATICS.dbo.CHPIV_NETWORK_DATA
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
	,ACCESS_REQ
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
	,[Accessibility Codes]
	,[Data Sourced From]

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
	,[HCAI ID] -- nvarchar(25) NULL ; -- ORDINAL  7 ... C###: UPDATE FOR MY204 AS OF 20250203 The DMHC’s standardized terminology is set forth in appendices A-F of the Annual Network Submission Instruction Manual for RY 2025. The health plan should also refer to the “Standardized Terminology and Other Reporting Resources” section of the Resources tab ON the Timely Access and Annual Network Reporting Web Portal for information ON standardized terminology resources. Please note, the DMHC relies ON the California Licensed Healthcare Facility Listing released by the California Department of Healthcare Access Information ('HCAI') to populate the Hospital and Other Inpatient Facility Name section of the Crosswalks tab. In addition, for RY 2025 the DMHC added a field for “'HCAI' ID” within the Hospital Report tab of the Hospital and Clinic Report Form. The “'HCAI' ID” field captures the unique identifier established by 'HCAI' to identify facilities used in the Licensed Facility Information System (LFIS). (See All Plan Letter (APL) 24-019.) The Plan may use the facility information provided ON www.'HCAI'.ca.gov to review its terminology and to identify the 'HCAI' ID for completing the Hospital and Clinic Report Form ... USE https://www.HCAI.ca.gov	
    ) -- CONCLUDE 

SELECT chpivdirectnonprovdir.*
	FROM 
	( -- INITIATE ...
	SELECT DISTINCT  -- PEOPLE / INDIVIDUAL(S)
		-- Core Provider Information (8 columns)	
	CITY
	-- ,TRY_CONVERT(nvarchar(255),NULL) AS [GROUP]
	,TRY_CONVERT(nvarchar(255),people.[ProductName]) AS [GROUP]
	,[SpecialtyName] AS SPECIALTY
	,LastName AS LNAME
	,FirstName AS FNAME
	,NULL AS Mname
	-- ,TypeOfLicensure AS TITLE
	-- ,RIGHT(LTRIM(RTRIM(ISNULL(INDEXNM,''))),2) AS TITLE
	,NULL AS TITLE
	,practitionerid AS PHY_ID -- practitionerid

	-- Address/Contact Information (5 columns)
	,ISNULL([LineNumber1]+' '+[LineNumber2],[LineNumber1]) AS [Address] 
	,[STATE]
	,ZIPCODE
	,[Telephone Number] AS PHONE
	,NULL AS [HOURS]

	-- Language Information (25 columns - CCIPA only has first language)
	,NULL AS PHY_LANG01_PRV_LANG01
	,NULL AS PHY_LANG02_PRV_LANG02
	,NULL AS PHY_LANG03_PRV_LANG03
	,NULL AS PHY_LANG04_PRV_LANG04
	,NULL AS PHY_LANG05_PRV_LANG05
	,TRY_CONVERT(nvarchar(255),NULL) AS PHY_LANG06_PRV_LANG06
	,TRY_CONVERT(nvarchar(255),NULL) AS PHY_LANG07_PRV_LANG07
	,TRY_CONVERT(nvarchar(255),NULL) AS PHY_LANG08_PRV_LANG08
	,TRY_CONVERT(nvarchar(255),NULL) AS PHY_LANG09_PRV_LANG09
	,TRY_CONVERT(nvarchar(255),NULL) AS PHY_LANG10_PRV_LANG10
	,TRY_CONVERT(nvarchar(255),NULL) AS PHY_LANG11_PRV_LANG11
	,TRY_CONVERT(nvarchar(255),NULL) AS PHY_LANG12_PRV_LANG12
	,TRY_CONVERT(nvarchar(255),NULL) AS PHY_LANG13_PRV_LANG13
	,TRY_CONVERT(nvarchar(255),NULL) AS PHY_LANG14_PRV_LANG14
	,TRY_CONVERT(nvarchar(255),NULL) AS PHY_LANG15_PRV_LANG15
	,TRY_CONVERT(nvarchar(255),NULL) AS PHY_LANG16_PRV_LANG16
	,TRY_CONVERT(nvarchar(255),NULL) AS PHY_LANG17_PRV_LANG17
	,TRY_CONVERT(nvarchar(255),NULL) AS PHY_LANG18_PRV_LANG18
	,TRY_CONVERT(nvarchar(255),NULL) AS PHY_LANG19_PRV_LANG19
	,TRY_CONVERT(nvarchar(255),NULL) AS PHY_LANG20_PRV_LANG20
	,TRY_CONVERT(nvarchar(255),NULL) AS PHY_LANG21_PRV_LANG21
	,TRY_CONVERT(nvarchar(255),NULL) AS PHY_LANG22_PRV_LANG22
	,TRY_CONVERT(nvarchar(255),NULL) AS PHY_LANG23_PRV_LANG23
	,TRY_CONVERT(nvarchar(255),NULL) AS PHY_LANG24_PRV_LANG24
	,TRY_CONVERT(nvarchar(255),NULL) AS PHY_LANG25_PRV_LANG25

	-- Hospital/Certification (2 columns)
	,NULL AS HOSP_NAME
	,'N/A' AS CERTIFICATION

	-- Extender Information (16 columns - NULL for CCIPA)
	,TRY_CONVERT(nvarchar(255),NULL) AS EXT1A_LNAME
	,TRY_CONVERT(nvarchar(255),NULL) AS EXT1B_FNAME
	,TRY_CONVERT(nvarchar(255),NULL) AS EXT1C_MINITIAL
	,TRY_CONVERT(nvarchar(100),NULL) AS EXT1D_LICTYPE
	,TRY_CONVERT(nvarchar(255),NULL) AS EXT2A_LNAME
	,TRY_CONVERT(nvarchar(255),NULL) AS EXT2B_FNAME
	,TRY_CONVERT(nvarchar(255),NULL) AS EXT2C_MINITIAL
	,TRY_CONVERT(nvarchar(100),NULL) AS EXT2D_LICTYPE
	,TRY_CONVERT(nvarchar(255),NULL) AS EXT3A_LNAME
	,TRY_CONVERT(nvarchar(255),NULL) AS EXT3B_FNAME
	,TRY_CONVERT(nvarchar(255),NULL) AS EXT3C_MINITIAL
	,TRY_CONVERT(nvarchar(100),NULL) AS EXT3D_LICTYPE
	,TRY_CONVERT(nvarchar(255),NULL) AS EXT4A_LNAME
	,TRY_CONVERT(nvarchar(255),NULL) AS EXT4B_FNAME
	,TRY_CONVERT(nvarchar(255),NULL) AS EXT4C_MINITIAL
	,TRY_CONVERT(nvarchar(100),NULL) AS EXT4D_LICTYPE

	-- Administrative Information (7 columns)
	,'NON PROVIDER DIRECTORY PROVIDER' AS SECTION_NO
	,COUNTY AS DIR_ID
	,NULL AS ACCEPT_NEW_PAT
	,DBA AS PPG_NAME
	,NULL AS CLNC_SER_TYP
	,PracticeID AS PPG_ID
	,TRY_CONVERT(nvarchar(10),LTRIM(RTRIM(ISNULL(NationalProviderID,'')))) AS NPI_NO

	-- Accessibility Indicators (9 columns - NULL for CCIPA)
	,NULL AS ACCESS_REQ
	,TRY_CONVERT(nvarchar(255),NULL) AS PARKING_IND
	,TRY_CONVERT(nvarchar(255),NULL) AS EXT_BUILD_IND
	,TRY_CONVERT(nvarchar(255),NULL) AS INT_BUILD_IND
	,TRY_CONVERT(nvarchar(255),NULL) AS RESTROOM_IND
	,TRY_CONVERT(nvarchar(255),NULL) AS EXAMROOM_IND
	,TRY_CONVERT(nvarchar(255),NULL) AS EXAMTBL_IND
	,TRY_CONVERT(nvarchar(255),NULL) AS PATIENT_AREA_IND
	,TRY_CONVERT(nvarchar(255),NULL) AS PATIENT_DIA_IND

	-- Additional Provider Information (6 columns)
	,[CA_LIC] AS LIC_ID
	,NULL AS EMAIL
	,NULL AS BOARD_CERT_ID

	-- Office Language Information (15 columns - CCIPA only has first)
	,TRY_CONVERT(nvarchar(255),NULL) AS OFFICE_LANG01
	,TRY_CONVERT(nvarchar(255),NULL) AS OFFICE_LANG02
	,TRY_CONVERT(nvarchar(255),NULL) AS OFFICE_LANG03
	,TRY_CONVERT(nvarchar(255),NULL) AS OFFICE_LANG04
	,TRY_CONVERT(nvarchar(255),NULL) AS OFFICE_LANG05
	,TRY_CONVERT(nvarchar(255),NULL) AS OFFICE_LANG06
	,TRY_CONVERT(nvarchar(255),NULL) AS OFFICE_LANG07
	,TRY_CONVERT(nvarchar(255),NULL) AS OFFICE_LANG08
	,TRY_CONVERT(nvarchar(255),NULL) AS OFFICE_LANG09
	,TRY_CONVERT(nvarchar(255),NULL) AS OFFICE_LANG10
	,TRY_CONVERT(nvarchar(255),NULL) AS OFFICE_LANG11
	,TRY_CONVERT(nvarchar(255),NULL) AS OFFICE_LANG12
	,TRY_CONVERT(nvarchar(255),NULL) AS OFFICE_LANG13
	,TRY_CONVERT(nvarchar(255),NULL) AS OFFICE_LANG14
	,TRY_CONVERT(nvarchar(255),NULL) AS OFFICE_LANG15

	-- Provider Status/Preferences (6 columns)
	,TRY_CONVERT(nvarchar(1),NULL) AS SELF_ACCESS_FLAG
	,TRY_CONVERT(nvarchar(255),NULL) AS PHY_ALT_LNAME
	,TRY_CONVERT(nvarchar(255),NULL) AS PHY_ALT_FNAME
	,TRY_CONVERT(nvarchar(50),NULL) AS PHY_ALT_MNAME
	,NULL AS WEBSITE
	,NULL AS PHY_PANEL_STATUS

	-- Additional Contact (1 column)
	,[DepartmentPhone] AS AFTERHOUR_PHONE

	-- Provider Characteristics (4 columns)
	,'N/A' AS PRV_CCT_IND_PHY_CCT_IND
	,NULL AS [Gender]
	,TRY_CONVERT(nvarchar(255),NULL) AS ACCR_TYPE
	,NULL AS ACCR_DESC

	-- External Links (1 column)
	,TRY_CONVERT(nvarchar(255),NULL) AS HOSPITAL_GRADE_QUALITY_DATA_LINK

	-- Audit Columns (2 columns)
	,CAST(GETDATE() AS datetime2) AS ImportedAt
	,SYSTEM_USER AS ImportedBy
	,NULL AS [Accessibility Codes]
	,'CHPIV Direct Non - Provider Directory' AS [Data Sourced From]

	-- Business Rule Columns (2 columns)
	,COUNTY -- Business rule: All CCIPA/ICPMG are Imperial County
	,Telehealth_Indicator -- To be updated per DHCS APL 25-014	
	
	-- C003: Network Analysis ADD - ON COLUMN(S) (# columns) ... CHPIV DIRECT NETWORK FILE DEVELOPMENT FOR MS JULIA AS PART OF PROVDIR PROCESS WITH ADDITIONAL FIELDS'
	,TRY_CONVERT(decimal(10, 0), NULL) AS [TAXONOMY CODE] -- decimal(10,0) NULL ; -- ORDINAL  1 | ? KEY ANCHOR — CONFIRM INTENT
	,NULL AS [TRAINING] -- nvarchar(255) NULL ; -- ORDINAL  2
	,TRY_CONVERT(decimal(10, 0), NULL) AS [LOCATION NPI] -- decimal(10,0) NULL ; -- ORDINAL  3
	,NULL AS [LOCATION NAME] -- nvarchar(25) NULL ; -- ORDINAL  4
	,0 AS [STAFFED BEDS] -- int NULL ; -- ORDINAL  5
	,NULL AS [CULTURAL COMPETENCY] -- nvarchar(255) NULL ; -- ORDINAL  6
	,NULL AS [HCAI ID] -- nvarchar(25) NULL ; -- ORDINAL  7 ... C###: UPDATE FOR MY204 AS OF 20250203 The DMHC’s standardized terminology is set forth in appendices A-F of the Annual Network Submission Instruction Manual for RY 2025. The health plan should also refer to the “Standardized Terminology and Other Reporting Resources” section of the Resources tab ON the Timely Access and Annual Network Reporting Web Portal for information ON standardized terminology resources. Please note, the DMHC relies ON the California Licensed Healthcare Facility Listing released by the California Department of Healthcare Access Information ('HCAI') to populate the Hospital and Other Inpatient Facility Name section of the Crosswalks tab. In addition, for RY 2025 the DMHC added a field for “'HCAI' ID” within the Hospital Report tab of the Hospital and Clinic Report Form. The “'HCAI' ID” field captures the unique identifier established by 'HCAI' to identify facilities used in the Licensed Facility Information System (LFIS). (See All Plan Letter (APL) 24-019.) The Plan may use the facility information provided ON www.'HCAI'.ca.gov to review its terminology and to identify the 'HCAI' ID for completing the Hospital and Clinic Report Form ... USE https://www.HCAI.ca.gov
	FROM #baselineprovider	AS people
	
	UNION ALL
	SELECT DISTINCT  -- PHARMACY(-IES) / PLACES
		-- Core Provider Information (8 columns)	
	CITY
	-- ,TRY_CONVERT(nvarchar(255),NULL) AS [GROUP]
	,TRY_CONVERT(nvarchar(255),places.[ProductName]) AS [GROUP]
	,[vlpSERVICETYPENAME] AS SPECIALTY
	,ISNULL(places.LocationName,'') AS LNAME
	,NULL AS FNAME
	,NULL AS Mname
	-- ,TypeOfLicensure AS TITLE
	-- ,RIGHT(LTRIM(RTRIM(ISNULL(INDEXNM,''))),2) AS TITLE
	,NULL AS TITLE
	,locationid AS PHY_ID -- locationid

	-- Address/Contact Information (5 columns)
	,ISNULL([LineNumber1]+' '+[LineNumber2],[LineNumber1]) AS [Address] 
	-- ,[LineNumber1]+' '+[LineNumber2] AS [Address]
	,[STATE]
	,ZIPCODE
	,[Telephone Number] AS PHONE
	,NULL AS HOURS

	-- Language Information (25 columns - CCIPA only has first language)
	,NULL AS PHY_LANG01_PRV_LANG01
	,NULL AS PHY_LANG02_PRV_LANG02
	,NULL AS PHY_LANG03_PRV_LANG03
	,NULL AS PHY_LANG04_PRV_LANG04
	,NULL AS PHY_LANG05_PRV_LANG05
	,TRY_CONVERT(nvarchar(255),NULL) AS PHY_LANG06_PRV_LANG06
	,TRY_CONVERT(nvarchar(255),NULL) AS PHY_LANG07_PRV_LANG07
	,TRY_CONVERT(nvarchar(255),NULL) AS PHY_LANG08_PRV_LANG08
	,TRY_CONVERT(nvarchar(255),NULL) AS PHY_LANG09_PRV_LANG09
	,TRY_CONVERT(nvarchar(255),NULL) AS PHY_LANG10_PRV_LANG10
	,TRY_CONVERT(nvarchar(255),NULL) AS PHY_LANG11_PRV_LANG11
	,TRY_CONVERT(nvarchar(255),NULL) AS PHY_LANG12_PRV_LANG12
	,TRY_CONVERT(nvarchar(255),NULL) AS PHY_LANG13_PRV_LANG13
	,TRY_CONVERT(nvarchar(255),NULL) AS PHY_LANG14_PRV_LANG14
	,TRY_CONVERT(nvarchar(255),NULL) AS PHY_LANG15_PRV_LANG15
	,TRY_CONVERT(nvarchar(255),NULL) AS PHY_LANG16_PRV_LANG16
	,TRY_CONVERT(nvarchar(255),NULL) AS PHY_LANG17_PRV_LANG17
	,TRY_CONVERT(nvarchar(255),NULL) AS PHY_LANG18_PRV_LANG18
	,TRY_CONVERT(nvarchar(255),NULL) AS PHY_LANG19_PRV_LANG19
	,TRY_CONVERT(nvarchar(255),NULL) AS PHY_LANG20_PRV_LANG20
	,TRY_CONVERT(nvarchar(255),NULL) AS PHY_LANG21_PRV_LANG21
	,TRY_CONVERT(nvarchar(255),NULL) AS PHY_LANG22_PRV_LANG22
	,TRY_CONVERT(nvarchar(255),NULL) AS PHY_LANG23_PRV_LANG23
	,TRY_CONVERT(nvarchar(255),NULL) AS PHY_LANG24_PRV_LANG24
	,TRY_CONVERT(nvarchar(255),NULL) AS PHY_LANG25_PRV_LANG25

	-- Hospital/Certification (2 columns)
	,NULL AS HOSP_NAME
	,'N/A' AS CERTIFICATION

	-- Extender Information (16 columns - NULL for CCIPA)
	,TRY_CONVERT(nvarchar(255),NULL) AS EXT1A_LNAME
	,TRY_CONVERT(nvarchar(255),NULL) AS EXT1B_FNAME
	,TRY_CONVERT(nvarchar(255),NULL) AS EXT1C_MINITIAL
	,TRY_CONVERT(nvarchar(100),NULL) AS EXT1D_LICTYPE
	,TRY_CONVERT(nvarchar(255),NULL) AS EXT2A_LNAME
	,TRY_CONVERT(nvarchar(255),NULL) AS EXT2B_FNAME
	,TRY_CONVERT(nvarchar(255),NULL) AS EXT2C_MINITIAL
	,TRY_CONVERT(nvarchar(100),NULL) AS EXT2D_LICTYPE
	,TRY_CONVERT(nvarchar(255),NULL) AS EXT3A_LNAME
	,TRY_CONVERT(nvarchar(255),NULL) AS EXT3B_FNAME
	,TRY_CONVERT(nvarchar(255),NULL) AS EXT3C_MINITIAL
	,TRY_CONVERT(nvarchar(100),NULL) AS EXT3D_LICTYPE
	,TRY_CONVERT(nvarchar(255),NULL) AS EXT4A_LNAME
	,TRY_CONVERT(nvarchar(255),NULL) AS EXT4B_FNAME
	,TRY_CONVERT(nvarchar(255),NULL) AS EXT4C_MINITIAL
	,TRY_CONVERT(nvarchar(100),NULL) AS EXT4D_LICTYPE

	-- Administrative Information (7 columns)
	,'NON PROVIDER DIRECTORY FACILITY' AS SECTION_NO
	,COUNTY AS DIR_ID
	,NULL AS ACCEPT_NEW_PAT
	,DBA AS PPG_NAME
	,NULL AS CLNC_SER_TYP
	,PracticeID AS PPG_ID
	,TRY_CONVERT(nvarchar(10),LTRIM(RTRIM(ISNULL(NPIis,'')))) AS NPI_NO

	-- Accessibility Indicators (9 columns - NULL for CCIPA)
	,NULL AS ACCESS_REQ
	,TRY_CONVERT(nvarchar(255),NULL) AS PARKING_IND
	,TRY_CONVERT(nvarchar(255),NULL) AS EXT_BUILD_IND
	,TRY_CONVERT(nvarchar(255),NULL) AS INT_BUILD_IND
	,TRY_CONVERT(nvarchar(255),NULL) AS RESTROOM_IND
	,TRY_CONVERT(nvarchar(255),NULL) AS EXAMROOM_IND
	,TRY_CONVERT(nvarchar(255),NULL) AS EXAMTBL_IND
	,TRY_CONVERT(nvarchar(255),NULL) AS PATIENT_AREA_IND
	,TRY_CONVERT(nvarchar(255),NULL) AS PATIENT_DIA_IND

	-- Additional Provider Information (6 columns)
	,[CA_LIC] AS LIC_ID
	,NULL AS EMAIL
	,NULL AS BOARD_CERT_ID

	-- Office Language Information (15 columns - CCIPA only has first)
	,TRY_CONVERT(nvarchar(255),NULL) AS OFFICE_LANG01
	,TRY_CONVERT(nvarchar(255),NULL) AS OFFICE_LANG02
	,TRY_CONVERT(nvarchar(255),NULL) AS OFFICE_LANG03
	,TRY_CONVERT(nvarchar(255),NULL) AS OFFICE_LANG04
	,TRY_CONVERT(nvarchar(255),NULL) AS OFFICE_LANG05
	,TRY_CONVERT(nvarchar(255),NULL) AS OFFICE_LANG06
	,TRY_CONVERT(nvarchar(255),NULL) AS OFFICE_LANG07
	,TRY_CONVERT(nvarchar(255),NULL) AS OFFICE_LANG08
	,TRY_CONVERT(nvarchar(255),NULL) AS OFFICE_LANG09
	,TRY_CONVERT(nvarchar(255),NULL) AS OFFICE_LANG10
	,TRY_CONVERT(nvarchar(255),NULL) AS OFFICE_LANG11
	,TRY_CONVERT(nvarchar(255),NULL) AS OFFICE_LANG12
	,TRY_CONVERT(nvarchar(255),NULL) AS OFFICE_LANG13
	,TRY_CONVERT(nvarchar(255),NULL) AS OFFICE_LANG14
	,TRY_CONVERT(nvarchar(255),NULL) AS OFFICE_LANG15

	-- Provider Status/Preferences (6 columns)
	,TRY_CONVERT(nvarchar(1),NULL) AS SELF_ACCESS_FLAG
	,TRY_CONVERT(nvarchar(255),NULL) AS PHY_ALT_LNAME
	,TRY_CONVERT(nvarchar(255),NULL) AS PHY_ALT_FNAME
	,TRY_CONVERT(nvarchar(50),NULL) AS PHY_ALT_MNAME
	,NULL AS WEBSITE
	,NULL AS PHY_PANEL_STATUS

	-- Additional Contact (1 column)
	,[DepartmentPhone] AS AFTERHOUR_PHONE

	-- Provider Characteristics (4 columns)
	,'N/A' AS PRV_CCT_IND_PHY_CCT_IND
	,NULL AS [Gender]
	,TRY_CONVERT(nvarchar(255),NULL) AS ACCR_TYPE
	,NULL AS ACCR_DESC

	-- External Links (1 column)
	,TRY_CONVERT(nvarchar(255),NULL) AS HOSPITAL_GRADE_QUALITY_DATA_LINK

	-- Audit Columns (2 columns)
	,CAST(GETDATE() AS datetime2) AS ImportedAt
	,SYSTEM_USER AS ImportedBy
	,NULL AS [Accessibility Codes]
	,'CHPIV Direct Non - Provider Directory' AS [Data Sourced From]

	-- Business Rule Columns (2 columns)
	,COUNTY -- Business rule: All CCIPA/ICPMG are Imperial County
	,Telehealth_Indicator -- To be updated per DHCS APL 25-014
	
	-- C003: Network Analysis ADD - ON COLUMN(S) (# columns) ... CHPIV DIRECT NETWORK FILE DEVELOPMENT FOR MS JULIA AS PART OF PROVDIR PROCESS WITH ADDITIONAL FIELDS'
	,TRY_CONVERT(decimal(10, 0), NULL) AS [TAXONOMY CODE] -- decimal(10,0) NULL ; -- ORDINAL  1 | ? KEY ANCHOR — CONFIRM INTENT
	,NULL AS [TRAINING] -- nvarchar(255) NULL ; -- ORDINAL  2
	,TRY_CONVERT(decimal(10, 0), NULL) AS [LOCATION NPI] -- decimal(10,0) NULL ; -- ORDINAL  3
	,NULL AS [LOCATION NAME] -- nvarchar(25) NULL ; -- ORDINAL  4
	,0 AS [STAFFED BEDS] -- int NULL ; -- ORDINAL  5
	,NULL AS [CULTURAL COMPETENCY] -- nvarchar(255) NULL ; -- ORDINAL  6
	,NULL AS [HCAI ID] -- nvarchar(25) NULL ; -- ORDINAL  7 ... C###: UPDATE FOR MY204 AS OF 20250203 The DMHC’s standardized terminology is set forth in appendices A-F of the Annual Network Submission Instruction Manual for RY 2025. The health plan should also refer to the “Standardized Terminology and Other Reporting Resources” section of the Resources tab ON the Timely Access and Annual Network Reporting Web Portal for information ON standardized terminology resources. Please note, the DMHC relies ON the California Licensed Healthcare Facility Listing released by the California Department of Healthcare Access Information ('HCAI') to populate the Hospital and Other Inpatient Facility Name section of the Crosswalks tab. In addition, for RY 2025 the DMHC added a field for “'HCAI' ID” within the Hospital Report tab of the Hospital and Clinic Report Form. The “'HCAI' ID” field captures the unique identifier established by 'HCAI' to identify facilities used in the Licensed Facility Information System (LFIS). (See All Plan Letter (APL) 24-019.) The Plan may use the facility information provided ON www.'HCAI'.ca.gov to review its terminology and to identify the 'HCAI' ID for completing the Hospital and Clinic Report Form ... USE https://www.HCAI.ca.gov
	FROM #baselinefacility AS places
	) AS chpivdirectnonprovdir

-- =====================================================
	-- MS EXCEL OLE DB ODBC: 
-- =====================================================	
/* ;WITH chpivnpitax AS 
( -- INITIATE ...
SELECT  ' ' AS 'ADD ON NETWORK ANALYSIS TAXONOMY DATA: ',ISNULL(npitax.npi,'') AS [NPI]
-- ,TaxCross.*
-- ,LEN(TaxCross.TaxCode) AS [TAX LEN]
,taxdescr.*
,npitax.provider_organization_name
,npitax.parent_organization_lbn
FROM INFOAG.CHGAPP_PROD.dbo.tblNPIData AS npitax
CROSS APPLY -- CROSS ... THE alias TABLE
( -- INITIATE ...
VALUES
(npitax.healthcare_provider_taxonomycode_1,  npitax.healthcare_provider_primary_taxonomy_switch_1),
(npitax.healthcare_provider_taxonomy_code_2, npitax.healthcare_provider_primary_taxonomy_switch_2),
(npitax.healthcare_provider_taxonomy_code_3, npitax.healthcare_provider_primary_taxonomy_switch_3),
(npitax.healthcare_provider_taxonomy_code_4, npitax.healthcare_provider_primary_taxonomy_switch_4),
(npitax.healthcare_provider_taxonomy_code_5, npitax.healthcare_provider_primary_taxonomy_switch_5),
(npitax.healthcare_provider_taxonomy_code_6, npitax.healthcare_provider_primary_taxonomy_switch_6),
(npitax.healthcare_provider_taxonomy_code_7, npitax.healthcare_provider_primary_taxonomy_switch_7),
(npitax.healthcare_provider_taxonomy_code_8, npitax.healthcare_provider_primary_taxonomy_switch_8),
(npitax.healthcare_provider_taxonomy_code_9, npitax.healthcare_provider_primary_taxonomy_switch_9),
(npitax.healthcare_provider_taxonomy_code_10, npitax.healthcare_provider_primary_taxonomy_switch_10),
(npitax.healthcare_provider_taxonomy_code_11, npitax.healthcare_provider_primary_taxonomy_switch_11),
(npitax.healthcare_provider_taxonomy_code_12, npitax.healthcare_provider_primary_taxonomy_switch_12),
(npitax.healthcare_provider_taxonomy_code_13, npitax.healthcare_provider_primary_taxonomy_switch_13),
(npitax.healthcare_provider_taxonomy_code_14, npitax.healthcare_provider_primary_taxonomy_switch_14),
(npitax.healthcare_provider_taxonomy_code_15, npitax.healthcare_provider_primary_taxonomy_switch_15)
) -- CONCLUDE ...
AS TaxCross(TaxCode, TaxSwitch) -- alias([FIELD1],[FIELD2])
		LEFT JOIN 
		( -- INITIATE ...
		SELECT atc.*
		,ROW_NUMBER() OVER(PARTITION BY ISNULL(atc.TaxonomyCode,'') ORDER BY TRY_CONVERT(date,atc.CrosswalkDate) DESC) AS [ROWis] -- STRAIGHT FORWARD SEQUENCE
		FROM ProviderRepository.dbo.ANCTaxonomyCrosswalk AS atc
		WHERE 1=1
			AND NOT atc.NUCCClassification LIKE '%Student%' -- NO NOT NEGATIVE <> != ...
			) -- CONCLUDE ...
			AS taxdescr ON ISNULL(TaxCross.TaxCode,'') COLLATE DATABASE_DEFAULT = ISNULL(taxdescr.TaxonomyCode,'') COLLATE DATABASE_DEFAULT -- TAXONOMY / SPECIALTY XWALK CROSSWALK
				AND taxdescr.[ROWis] = 1
WHERE 1=1 
	-- AND D.SnapshotID = @SnapshotID
	AND TaxCross.TaxCode IS NOT NULL
	-- AND ISNULL(npitax.npi,'') IN ('1861405664','1588988646') -- SAMPLE: CHPIV DIRECT NON - PROVIDER DIRECTORY 
	) -- CONCLUDE ...

SELECT DISTINCT chpivnpitax.*
,cnd.*
FROM INFORMATICS.dbo.CHPIV_NETWORK_DATA AS cnd
		LEFT JOIN chpivnpitax ON ISNULL(cnd.NPI_NO,'') = ISNULL(chpivnpitax.npi,'') */

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
	-- SECTION 4: POST-INSERT VALIDATION: 
-- =====================================================
DECLARE @Main_Count_After INT;

SELECT @Main_Count_After = COUNT(*) 
FROM INFORMATICS.dbo.CHPIV_NETWORK_DATA;

PRINT 'Final Record Counts:';
PRINT '  Main Table Records (After): ' + CAST(@Main_Count_After AS VARCHAR(10));
PRINT '  Total Records Added: ' + CAST((@Main_Count_After - @Main_Count_Before) AS VARCHAR(10));
PRINT '';

-- Verify by GROUP (recent imports)
PRINT 'Records by GROUP (recently inserted):';
SELECT [GROUP],COUNT(*) AS [Records by GROUP (recently inserted)]
FROM INFORMATICS.dbo.CHPIV_NETWORK_DATA
WHERE 1=1
	AND ImportedAt >= DATEADD(MINUTE,-30,GETDATE())  -- Adjust window as needed
GROUP BY [GROUP]
ORDER BY [GROUP];

-- Verify COUNTY assignment
PRINT '';
PRINT 'Records by COUNTY (recently inserted):';
SELECT COUNTY,COUNT(*) AS [Records by COUNTY (recently inserted)]
FROM INFORMATICS.dbo.CHPIV_NETWORK_DATA
WHERE 1=1
	AND ImportedAt >= DATEADD(MINUTE,-30,GETDATE())
GROUP BY COUNTY
ORDER BY COUNTY;
-- =================================================================
	-- INSERT PROCESS COMPLETED
-- =================================================================
GO
