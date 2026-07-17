-- ========================================================
	-- CHPIV PLACEHOLDER AND EXTERNAL SOURCE DATA INSERTION: 
-- ========================================================
-- ======================================
	-- MODIFICATION(S) / CHANGE.LOG: 
-- ======================================
-- C001: APPLICABLE TO PROVIDERS ONLY!!! ADD - ON PER EMAIL FROM MS JOHANNA BASED UPON DHCS FINDING (LEVERAGE: APL 25-014 AND OR "PROVDIR Telehealth Indicator evips location .msg")
		-- ~ LEVERAGE: SSA (SQL SERVER AGENT) JOB - "Provider Directory refresh sequence -The regular script has executed we may now proceed with the DirectoryExpert step" IN SQLPRODAPP01

		/* USE [PATH]: file://fileserver01/CHPIV/Provider%20Directory%20Updates/ - 'CHPIV ROSTER UPDATE FILE(S)' */
		
-- C002: TERMS / DELETIONS BASED UPON CHPIV FILE(S) -  'SUBJECT: New & Deleted Providers for CommunityCare & ICPMG FROM:SUSAN "*If they are removed, I have a Deleted? column in the Rosterfrom9-18 sheet, there will be an #N/A in the column ... •	Both have a handful *"'

-- C003: PULL CHPIV DIRECT PROVIDER(S) AND OR ENTITY(-IES) EXCLUSIVELY FROM eVIPS

-- C004: CHPIV PROVIDER DIRECTORY AGE RESTRICTION FIXES

/* From: Johanna Tellechea, BS <jduran@chgsd.com> 
Sent: Friday, January 9, 2026 4:25 PM
To: Walter Carr <WCarr@chgsd.com>
Subject: CHPIV - PEDS 

Hi Walter, 

As mentioned earlier, in our meeting with JAG today it was approved to have PEDs providers (Direct & IPA) be listed in the directory with age restrictions of 0-18 years. I know this is out of the norm for our DSNP directories but until further notice this will be the process. 

So that we don’t mess with the logic that is set up to pull DSNP data can you please translate on the back end all the PEDs providers to reflect age restriction from 21-99 to 0-18. We will keep the ages as 21-99 in evips considering you’ll do the translation on the back end so it doesn’t mess with your data. 

Can you please run the directory now, thank you 😊  */

-- C005: AD HOC MANUAL ADD-ON — FORCE 2 HOSPITAL RECORDS into CHPIV_PROVIDER_DIRECTORY_DATA see  "FORCE CHPIV HOSPITALS Provider Directory Data to CHG 12_08_25.xlsx" -> worksheet "2 HOSPITALS" (2 rows)

-- =====================================================
	-- TABLE DESIGN: 
-- =====================================================
USE INFORMATICS

SELECT c.TABLE_CATALOG+'.'+c.TABLE_SCHEMA+'.'+c.TABLE_NAME AS 'TABLE DESIGN: '
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
-- ORDER BY c.COLUMN_NAME,c.ORDINAL_POSITION;
ORDER BY c.ORDINAL_POSITION;

		SELECT TOP 10 ' ' AS 'INSERT INTO INFORMATICS.dbo.CHPIV_PROVIDER_DIRECTORY_DATA -- (FIELD(S) IN PLAY,...)',LEN(NPI_NO),* FROM INFORMATICS.dbo.CHPIV_PROVIDER_DIRECTORY_DATA

UPDATE INFORMATICS.dbo.CHPIV_PROVIDER_DIRECTORY_DATA
SET [Telehealth_Indicator] = TRY_CONVERT(nvarchar(1),'N')

UPDATE INFORMATICS.dbo.CHPIV_PROVIDER_DIRECTORY_DATA
SET NPI_NO = REPLACE(NPI_NO,'.0','')
,PHONE = REPLACE(PHONE,'.0','')
 
UPDATE INFORMATICS.dbo.CHPIV_PROVIDER_DIRECTORY_DATA
SET COUNTY = ISNULL(addcounty.County,'Unknown')
FROM INFORMATICS.dbo.CHPIV_PROVIDER_DIRECTORY_DATA AS roster
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
		WHEN SUBSTRING(LTRIM(RTRIM(roster.ZipCode)),1,1) = '0'
		THEN '0'+ SUBSTRING(LTRIM(RTRIM(roster.ZipCode)),2,4)
		WHEN SUBSTRING(LTRIM(RTRIM(roster.ZipCode)),1,1) = '00'
		THEN '00'+ SUBSTRING(LTRIM(RTRIM(roster.ZipCode)),3,3)
		ELSE  SUBSTRING(LTRIM(RTRIM(roster.ZipCode)),1,5) 
		END = addcounty.ZIP	

/* DELETE 
-- SELECT TOP 100000 ' ' AS 'CHECK 1st',TRY_CONVERT(nvarchar(10),LTRIM(RTRIM(ISNULL(NPI_NO,'')))) AS [RefreshNPI_NO],NPI_NO,*
-- SELECT DISTINCT ' ' AS 'CHECK 1st',TRY_CONVERT(nvarchar(10),LTRIM(RTRIM(ISNULL(NPI_NO,'')))) AS [RefreshNPI_NO],NPI_NO
FROM INFORMATICS.dbo.CHPIV_PROVIDER_DIRECTORY_DATA
WHERE 1=1
	AND TRY_CONVERT(nvarchar(10),LTRIM(RTRIM(ISNULL(NPI_NO,'')))) IN -- C002: TERMS / DELETIONS BASED UPON CHPIV FILE(S) -  'SUBJECT: New & Deleted Providers for CommunityCare & ICPMG FROM:SUSAN "*If they are removed, I have a Deleted? column in the Rosterfrom9-18 sheet, there will be an #N/A in the column ... •	Both have a handful *"
	( -- INITIATE ...
	'1689686933' -- FROM: "CHPIV ICPMG Provider Roster_251104_IdentifyNewAndDeletes.xlsx"
	,'1922291244' -- FROM: "CHPIV ICPMG Provider Roster_251104_IdentifyNewAndDeletes.xlsx"
	,'1033411061' -- FROM: "CHPIV ICPMG Provider Roster_251104_IdentifyNewAndDeletes.xlsx"
	,'1275530917' -- FROM: "CHPIV CCIPA Imperial Provider Roster_251105_IdentifyNewAndDeletes.xlsx"
	,'1508240862' -- FROM: "CHPIV CCIPA Imperial Provider Roster_251105_IdentifyNewAndDeletes.xlsx"
	,'1598021982' -- FROM: "CHPIV CCIPA Imperial Provider Roster_251105_IdentifyNewAndDeletes.xlsx"
	,'1295936201' -- FROM: "CHPIV CCIPA Imperial Provider Roster_251105_IdentifyNewAndDeletes.xlsx"
	,'1780670836' -- FROM: "CHPIV CCIPA Imperial Provider Roster_251105_IdentifyNewAndDeletes.xlsx"
	,'1558395558' -- FROM: "CHPIV CCIPA Imperial Provider Roster_251105_IdentifyNewAndDeletes.xlsx"
	,'1144539644' -- FROM: "CHPIV CCIPA Imperial Provider Roster_251105_IdentifyNewAndDeletes.xlsx"
	,'1750364493' -- FROM: "CHPIV CCIPA Imperial Provider Roster_251105_IdentifyNewAndDeletes.xlsx"
	,'1033411061' -- FROM: "CHPIV CCIPA Imperial Provider Roster_251105_IdentifyNewAndDeletes.xlsx"
	,'1992980270' -- FROM: "CHPIV CCIPA Imperial Provider Roster_251105_IdentifyNewAndDeletes.xlsx"
	) -- CONCLUDE ... */

		SELECT DISTINCT COUNTY,[Telehealth_Indicator] FROM INFORMATICS.dbo.CHPIV_PROVIDER_DIRECTORY_DATA -- LEVERAGE: "CHPIV Provider Directory Data to CHG 9_18_25_PROPER_CASE.xlsx" AND "CHPIV PROVDIR CONDITIONAL LINE ITEM.png"

		SELECT ' ' AS 'ISO ON MAX GROUP, NPI COMBINATION RECORD COUNT: ',chpiv.*
		-- SELECT TOP 100000 ' ' AS 'CHECK 1st',TRY_CONVERT(nvarchar(10),LTRIM(RTRIM(ISNULL(NPI_NO,'')))) AS [RefreshNPI_NO],NPI_NO,*
		-- SELECT DISTINCT ' ' AS 'CHECK 1st',TRY_CONVERT(nvarchar(10),LTRIM(RTRIM(ISNULL(NPI_NO,'')))) AS [RefreshNPI_NO],NPI_NO
		FROM INFORMATICS.dbo.CHPIV_PROVIDER_DIRECTORY_DATA AS chpiv -- LEVERAGE: "CHPIV Provider Directory Data to CHG 9_18_25_PROPER_CASE.xlsx" AND "CHPIV PROVDIR CONDITIONAL LINE ITEM.png" AND "CHPIV Provider Directory Data to CHG 12_08_25.xlsx"  AND ...
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
				
		SELECT ' ' AS 'ISO ON MAX GROUP RECORD COUNT: ',chpiv.*
		-- SELECT TOP 100000 ' ' AS 'CHECK 1st',TRY_CONVERT(nvarchar(10),LTRIM(RTRIM(ISNULL(NPI_NO,'')))) AS [RefreshNPI_NO],NPI_NO,*
		-- SELECT DISTINCT ' ' AS 'CHECK 1st',TRY_CONVERT(nvarchar(10),LTRIM(RTRIM(ISNULL(NPI_NO,'')))) AS [RefreshNPI_NO],NPI_NO
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
		
-- =======================================================
	-- UPLOAD ENTRY FOR PROVDIR_PCP
-- =======================================================
INSERT INTO INFORMATICS.dbo.PROVDIR_PCP (ZIP,NPIis,[Participating Network],SPEC,CityIs,[Zip Code],INDEXNM,PROVNM,[Clinic Name],DBA,[Address],CSZ,[Telephone Number],CA_License,[BOARD CERTIFIED],[ACCEPTING NEW PATIENTS],[Office Hour(s)],Accessibility,[Accessibility Category(ies)],FINALlang,FINALhosp_FULL_NAME,UPDATEDT_FOOTNOTE,CHAPTER_COUNT,CHAPTER_NAME,URL_WEBSITE,AFTERHOURS_PHONE,[ACCESS BY PUBLIC TRANSPORTATION],PROVIDER_TYPE,ACCREDITATION,Telehealth_Indicator,COUNTY)
SELECT DISTINCT TRY_CONVERT(nvarchar(5),'91914') AS 'ZIP' -- FORCE LOCK IN ... REQ TO ESTABLISH LICENSE ... DUMMY ZIP
,iso.[RefreshNPI_NO] AS 'NPI'
-- ,ISNULL(NPI_NO,'') AS 'NPI'
,CASE
WHEN [GROUP] LIKE '%CHPIV%Direct%'
THEN 'CHPIV-DSNP'
WHEN [GROUP] LIKE '%Community Care IPA%'
THEN 'CHPIV-IPA-CC'
WHEN [GROUP] LIKE '%Imperial County Physicians Medical Group%'
THEN 'CHPIV-IPA-ICPMG'
WHEN [GROUP] LIKE '%Premier Patient Care IPA%'
THEN 'CHPIV-IPA-PPC'
WHEN [GROUP] LIKE '%Primary%Care%Med%Group%'
THEN 'CHPIV-IPA-PCMG'
ELSE ''
END AS [Participating Network]
-- ,[Participating_Network]
-- ,'CHPIV-IPA-CC' AS 'Participating Network'
,SPECIALTY AS 'SPEC'
,CITY AS 'CityIs'
,TRY_CONVERT(nvarchar(5),ZIPCODE) AS 'Zip Code'
,TRY_CONVERT(nvarchar(25),LNAME)+',  '+TRY_CONVERT(nvarchar(25),FNAME)+', '+TRY_CONVERT(nvarchar(5),TITLE) AS 'INDEXNM'
,TRY_CONVERT(nvarchar(25),LNAME)+',  '+TRY_CONVERT(nvarchar(25),FNAME)+', '+TRY_CONVERT(nvarchar(5),TITLE)+' - ID# '+TRY_CONVERT(nvarchar(25),ISNULL(DIR_ID,'')) AS 'PROVNM'
-- ,TRY_CONVERT(nvarchar(25),LNAME)+',  '+TRY_CONVERT(nvarchar(25),FNAME)+', '+TRY_CONVERT(nvarchar(5),TITLE)+' - ID# '+TRY_CONVERT(nvarchar(25),ISNULL(CAQH,'')) AS 'PROVNM'
,TRY_CONVERT(nvarchar(100),NULL) AS 'Clinic Name' -- ABSENT FROM SOURCE DATA 
-- ,TRY_CONVERT(nvarchar(100),Clinic_Name)AS 'Clinic Name' -- ABSENT FROM SOURCE DATA 
,ISNULL([GROUP],'') AS 'DBA'
-- ,TRY_CONVERT(nvarchar(100),'CHPIV CommunityCare IPA') AS 'DBA'
-- ,TRY_CONVERT(nvarchar(100),ISNULL(PPG_NAME,'')) -- DBA AND OR ASSOCIATION_GROUP
,TRY_CONVERT(nvarchar(100),[Address]) AS 'Address'
,TRY_CONVERT(nvarchar(100),CITY)+', CA '+TRY_CONVERT(nvarchar(5),ZIPCODE) AS 'CSZ'
,TRY_CONVERT(nvarchar(13),PHONE) AS  'Telephone Number'
,LIC_ID AS 'CA_License'
-- ,TRY_CONVERT(nvarchar(100),NULL) AS 'BOARD CERTIFIED' -- Y OR N + (SPECIFIC BOARD IS ABSENT FROM SOURCE DATA)
,CASE
WHEN ISNULL(BOARD_CERT_ID,'N') IN('N')
THEN 'N'
ELSE 'Y ('+ISNULL(BOARD_CERT_ID,'')+')' 
END AS 'BOARD CERTIFIED' -- Y OR N + (SPECIFIC BOARD IS ABSENT FROM SOURCE DATA)
,CASE
WHEN ISNULL(ACCEPT_NEW_PAT,'') LIKE '%Y%'
THEN 'Yes'
ELSE 'No'
END AS 'ACCEPTING NEW PATIENTS'
-- ,ISNULL(ACCEPT_NEW_PAT,'') AS 'ACCEPTING NEW PATIENTS'
-- ,ACCEPT_NEW_PAT AS 'ACCEPTING NEW PATIENTS'
,ISNULL([HOURS],'') AS 'Office Hour(s)'
-- ,TRY_CONVERT(nvarchar(100),NULL) AS 'Accessibility'
,TRY_CONVERT(nvarchar(12),ISNULL(ACCESS_REQ,'')) AS 'Accessibility'
-- ,TRY_CONVERT(nvarchar(255),NULL) AS 'Accessibility (Categories)'
,STUFF(
CASE 
WHEN ISNULL(PARKING_IND,'') != '' 
THEN ', ' + PARKING_IND
ELSE '' 
END
+ CASE 
WHEN ISNULL(EXT_BUILD_IND,'') !='' 
THEN ', ' + EXT_BUILD_IND 
ELSE '' 
END
+ 
CASE 
WHEN ISNULL(INT_BUILD_IND,'') !='' 
THEN ', ' + INT_BUILD_IND 
ELSE '' 
END
+ 
CASE 
WHEN ISNULL(RESTROOM_IND,'') != '' 
THEN ', ' + RESTROOM_IND  
ELSE '' 
END
+ CASE 
WHEN ISNULL(EXAMROOM_IND,'') != '' 
THEN ', ' + EXAMROOM_IND 
ELSE '' 
END
+ 
CASE 
WHEN ISNULL(EXAMTBL_IND,'') != '' 
THEN ', ' + EXAMTBL_IND 
ELSE '' 
END
+ 
CASE 
WHEN ISNULL(PATIENT_AREA_IND,'') !='' 
THEN ', ' + PATIENT_AREA_IND 
ELSE '' 
END
+ 
CASE 
WHEN ISNULL(PATIENT_DIA_IND,'') != '' 
THEN ', ' + PATIENT_DIA_IND 
ELSE '' 
END,1,2,'') AS 'Accessibility (Categories)'
/* ,STUFF(
CASE 
WHEN ISNULL(Parking_Availabilty,'') != '' 
THEN ', ' + Parking_Availabilty
ELSE '' 
END
+ CASE 
WHEN ISNULL(Ext_Building,'') !='' 
THEN ', ' + Ext_Building 
ELSE '' 
END
+ 
CASE 
WHEN ISNULL(Int_Building,'') !='' 
THEN ', ' + Int_Building 
ELSE '' 
END
+ 
CASE 
WHEN ISNULL(Restroom,'') != '' 
THEN ', ' + Restroom  
ELSE '' 
END
+ CASE 
WHEN ISNULL(Exam_room,'') != '' 
THEN ', ' + Exam_room 
ELSE '' 
END
+ 
CASE 
WHEN ISNULL(Exam_Taable,'') != '' 
THEN ', ' + Exam_Taable 
ELSE '' 
END
+ 
CASE 
WHEN ISNULL(Patient_Area,'') !='' 
THEN ', ' + Patient_Area 
ELSE '' 
END
+ 
CASE 
WHEN ISNULL(Exam_Room_Disabilities,'') != '' 
THEN ', ' + Exam_Room_Disabilities 
ELSE '' 
END,1,2,'') AS 'Accessibility (Categories)' */
,STUFF(
CASE 
WHEN ISNULL(PHY_LANG01_PRV_LANG01,'') != '' 
THEN ', ' + PHY_LANG01_PRV_LANG01
ELSE '' 
END
+ CASE 
WHEN ISNULL(PHY_LANG02_PRV_LANG02,'') !='' 
THEN ', ' + PHY_LANG02_PRV_LANG02 
ELSE '' 
END
+ 
CASE 
WHEN ISNULL(PHY_LANG03_PRV_LANG03,'') !='' 
THEN ', ' + PHY_LANG03_PRV_LANG03 
ELSE '' 
END
+ 
CASE 
WHEN ISNULL(PHY_LANG04_PRV_LANG04,'') != '' 
THEN ', ' + PHY_LANG04_PRV_LANG04  
ELSE '' 
END
+ 
CASE 
WHEN ISNULL(PHY_LANG05_PRV_LANG05,'') != '' 
THEN ', ' + PHY_LANG05_PRV_LANG05 
ELSE '' 
END,1,2,'') AS 'FINALlang'
-- ,TRY_CONVERT(nvarchar(255),NULL) AS 'FINALlang'
-- ,Provider_Language AS 'FINALlang' 
,HOSP_NAME AS 'FINALhosp_FULL_NAME'
-- ,HospitalAmittingPriv AS 'FINALhosp_FULL_NAME'
,TRY_CONVERT(nvarchar(100),NULL) AS 'UPDATEDT_FOOTNOTE,' -- UPDATE() IN THE POST
,TRY_CONVERT(nvarchar(100),NULL) AS 'CHAPTER_COUNT' -- UPDATE() IN THE POST
,ca.CHAPTER_NAME
-- ,'Primary Care Physician' AS 'CHAPTER_NAME'
,ISNULL(WEBSITE,'') AS 'URL_WEBSITE'
-- ,TRY_CONVERT(nvarchar(100),NULL) AS 'URL_WEBSITE'
,TRY_CONVERT(nvarchar(10),' ') AS 'AFTERHOURS_PHONE' 
-- ,ISNULL(After_Hours_Phone,'') AS 'AFTERHOURS_PHONE' 
,'Yes' AS [ACCESS BY PUBLIC TRANSPORTATION] -- DEFAULT VAL() AS NULL(S) NOT ACCEPTED
,ca.PROVIDER_TYPE
-- ,'Primary Care' AS 'PROVIDER_TYPE'-- DEFAULT VAL() AS NULL(S) NOT ACCEPTED
,'Yes' AS ACCREDITATION -- DEFAULT VAL() AS NULL(S) NOT ACCEPTED
,[Telehealth_Indicator] -- C001: APPLICABLE TO PROVIDERS ONLY!!! ADD - ON PER EMAIL FROM MS JOHANNA BASED UPON DHCS FINDING (LEVERAGE: APL 25-014 AND OR "PROVDIR Telehealth Indicator evips location .msg")
,[COUNTY] 
-- SELECT TOP 10 ' ' AS 'CHECK 1st',* 
-- SELECT DISTINCT ' ' AS 'CHECK 1st',PCP_SPC,TITLE
FROM INFORMATICS.dbo.CHPIV_PROVIDER_DIRECTORY_DATA AS chpiv -- LEVERAGE: "CHPIV Provider Directory Data to CHG 9_18_25_PROPER_CASE.xlsx" AND "CHPIV PROVDIR CONDITIONAL LINE ITEM.png" AND "CHPIV Provider Directory Data to CHG 12_08_25.xlsx"  AND ...
CROSS APPLY (  -- INDEPENDENT STAND ALONE ... CROSS APPLY() CROSS JOIN() CARTESIAN PRODUCT
SELECT TOP 1 CHAPTER_NAME
,PROVIDER_TYPE 
FROM INFORMATICS.dbo.PROVDIR_PCP
) -- CONCLUDE ...
AS ca
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
	AND NOT [GROUP] LIKE '%CHPIV%Direct%' -- NO NOT NEGATIVE <> != ... -- C003: PULL CHPIV DIRECT PROVIDER(S) AND OR ENTITY(-IES) EXCLUSIVELY FROM eVIPS
	AND SPECIALTY IN ('Family Practice','Internal Medicine','Pediatrics','Obstetrics & Gynecology')

		SELECT ' ' AS 'CONFIRM PRESENCE OF AT LEAST ONE 1 "CHPIV" RECORD',*
		FROM INFORMATICS.dbo.PROVDIR_PCP 
		WHERE 1=1 
			AND [Participating Network] LIKE '%CHPIV%'

SELECT ' ' AS '#PYTHON UPLOAD OF ... : ',*
FROM INFORMATICS.dbo.CHPIV_PROVIDER_DIRECTORY_DATA -- LEVERAGE: "CHPIV Provider Directory Data to CHG 9_18_25_PROPER_CASE.xlsx" AND "CHPIV PROVDIR CONDITIONAL LINE ITEM.png"
WHERE 1=1 
	AND SPECIALTY IN ('Family Practice','Internal Medicine','Pediatrics','Obstetrics & Gynecology')
		
		SELECT DISTINCT SECTION_NO
		,[GROUP]
		SPECIALTY
		,CASE
		WHEN [GROUP] LIKE '%CHPIV%Direct%'
		THEN 'CHPIV-DSNP'
		WHEN [GROUP] LIKE '%Community Care IPA%'
		THEN 'CHPIV-IPA-CC'
		WHEN [GROUP] LIKE '%Imperial County Physicians Medical Group%'
		THEN 'CHPIV-IPA-ICPMG'
		WHEN [GROUP] LIKE '%Premier Patient Care IPA%'
		THEN 'CHPIV-IPA-PPC'
		WHEN [GROUP] LIKE '%Primary%Care%Med%Group%'
		THEN 'CHPIV-IPA-PCMG'
		ELSE ''
		END AS [Participating Network]
		FROM INFORMATICS.dbo.CHPIV_PROVIDER_DIRECTORY_DATA -- LEVERAGE: "CHPIV Provider Directory Data to CHG 9_18_25_PROPER_CASE.xlsx" AND "CHPIV PROVDIR CONDITIONAL LINE ITEM.png"
		WHERE 1=1 
			AND SPECIALTY IN ('Family Practice','Internal Medicine','Pediatrics','Obstetrics & Gynecology')

-- =======================================================
	-- UPLOAD ENTRY FOR PROVDIR_NPMP
-- =======================================================
INSERT INTO INFORMATICS.dbo.PROVDIR_NPMP (ZIP,NPIis,[Participating Network],SPEC,CityIs,[Zip Code],INDEXNM,PROVNM,[Clinic Name],DBA,[Address],CSZ,[Telephone Number],CA_License,[BOARD CERTIFIED],[ACCEPTING NEW PATIENTS],[Office Hour(s)],Accessibility,[Accessibility Category(ies)],FINALlang,FINALhosp_FULL_NAME,UPDATEDT_FOOTNOTE,CHAPTER_COUNT,CHAPTER_NAME,URL_WEBSITE,AFTERHOURS_PHONE,[ACCESS BY PUBLIC TRANSPORTATION],PROVIDER_TYPE,ACCREDITATION,Telehealth_Indicator,COUNTY)
SELECT DISTINCT TRY_CONVERT(nvarchar(5),'91914') AS 'ZIP' -- FORCE LOCK IN ... REQ TO ESTABLISH LICENSE ... DUMMY ZIP
,iso.[RefreshNPI_NO] AS 'NPI'
-- ,ISNULL(NPI_NO,'') AS 'NPI'
,CASE
WHEN [GROUP] LIKE '%CHPIV%Direct%'
THEN 'CHPIV-DSNP'
WHEN [GROUP] LIKE '%Community Care IPA%'
THEN 'CHPIV-IPA-CC'
WHEN [GROUP] LIKE '%Imperial County Physicians Medical Group%'
THEN 'CHPIV-IPA-ICPMG'
WHEN [GROUP] LIKE '%Premier Patient Care IPA%'
THEN 'CHPIV-IPA-PPC'
WHEN [GROUP] LIKE '%Primary%Care%Med%Group%'
THEN 'CHPIV-IPA-PCMG'
ELSE ''
END AS [Participating Network]
-- ,[Participating_Network]
-- ,'CHPIV-IPA-CC' AS 'Participating Network'
,SPECIALTY AS 'SPEC'
,CITY AS 'CityIs'
,TRY_CONVERT(nvarchar(5),ZIPCODE) AS 'Zip Code'
,TRY_CONVERT(nvarchar(25),LNAME)+',  '+TRY_CONVERT(nvarchar(25),FNAME)+', '+TRY_CONVERT(nvarchar(5),TITLE) AS 'INDEXNM'
,TRY_CONVERT(nvarchar(25),LNAME)+',  '+TRY_CONVERT(nvarchar(25),FNAME)+', '+TRY_CONVERT(nvarchar(5),TITLE)+' - ID# '+TRY_CONVERT(nvarchar(25),ISNULL(DIR_ID,'')) AS 'PROVNM'
-- ,TRY_CONVERT(nvarchar(25),LNAME)+',  '+TRY_CONVERT(nvarchar(25),FNAME)+', '+TRY_CONVERT(nvarchar(5),TITLE)+' - ID# '+TRY_CONVERT(nvarchar(25),ISNULL(CAQH,'')) AS 'PROVNM'
,TRY_CONVERT(nvarchar(100),NULL) AS 'Clinic Name' -- ABSENT FROM SOURCE DATA 
-- ,TRY_CONVERT(nvarchar(100),Clinic_Name)AS 'Clinic Name' -- ABSENT FROM SOURCE DATA 
,ISNULL([GROUP],'') AS 'DBA'
-- ,TRY_CONVERT(nvarchar(100),'CHPIV CommunityCare IPA') AS 'DBA'
-- ,TRY_CONVERT(nvarchar(100),ISNULL(PPG_NAME,'')) -- DBA AND OR ASSOCIATION_GROUP
,TRY_CONVERT(nvarchar(100),[Address]) AS 'Address'
,TRY_CONVERT(nvarchar(100),CITY)+', CA '+TRY_CONVERT(nvarchar(5),ZIPCODE) AS 'CSZ'
,TRY_CONVERT(nvarchar(13),PHONE) AS  'Telephone Number'
,LIC_ID AS 'CA_License'
-- ,TRY_CONVERT(nvarchar(100),NULL) AS 'BOARD CERTIFIED' -- Y OR N + (SPECIFIC BOARD IS ABSENT FROM SOURCE DATA)
,CASE
WHEN ISNULL(BOARD_CERT_ID,'N') IN('N')
THEN 'N'
ELSE 'Y ('+ISNULL(BOARD_CERT_ID,'')+')' 
END AS 'BOARD CERTIFIED' -- Y OR N + (SPECIFIC BOARD IS ABSENT FROM SOURCE DATA)
,CASE
WHEN ISNULL(ACCEPT_NEW_PAT,'') LIKE '%Y%'
THEN 'Yes'
ELSE 'No'
END AS 'ACCEPTING NEW PATIENTS'
-- ,ISNULL(ACCEPT_NEW_PAT,'') AS 'ACCEPTING NEW PATIENTS'
-- ,ACCEPT_NEW_PAT AS 'ACCEPTING NEW PATIENTS'
,ISNULL([HOURS],'') AS 'Office Hour(s)'
-- ,TRY_CONVERT(nvarchar(100),NULL) AS 'Accessibility'
,TRY_CONVERT(nvarchar(12),ISNULL(ACCESS_REQ,'')) AS 'Accessibility'
-- ,TRY_CONVERT(nvarchar(255),NULL) AS 'Accessibility (Categories)'
,STUFF(
CASE 
WHEN ISNULL(PARKING_IND,'') != '' 
THEN ', ' + PARKING_IND
ELSE '' 
END
+ CASE 
WHEN ISNULL(EXT_BUILD_IND,'') !='' 
THEN ', ' + EXT_BUILD_IND 
ELSE '' 
END
+ 
CASE 
WHEN ISNULL(INT_BUILD_IND,'') !='' 
THEN ', ' + INT_BUILD_IND 
ELSE '' 
END
+ 
CASE 
WHEN ISNULL(RESTROOM_IND,'') != '' 
THEN ', ' + RESTROOM_IND  
ELSE '' 
END
+ CASE 
WHEN ISNULL(EXAMROOM_IND,'') != '' 
THEN ', ' + EXAMROOM_IND 
ELSE '' 
END
+ 
CASE 
WHEN ISNULL(EXAMTBL_IND,'') != '' 
THEN ', ' + EXAMTBL_IND 
ELSE '' 
END
+ 
CASE 
WHEN ISNULL(PATIENT_AREA_IND,'') !='' 
THEN ', ' + PATIENT_AREA_IND 
ELSE '' 
END
+ 
CASE 
WHEN ISNULL(PATIENT_DIA_IND,'') != '' 
THEN ', ' + PATIENT_DIA_IND 
ELSE '' 
END,1,2,'') AS 'Accessibility (Categories)'
/* ,STUFF(
CASE 
WHEN ISNULL(Parking_Availabilty,'') != '' 
THEN ', ' + Parking_Availabilty
ELSE '' 
END
+ CASE 
WHEN ISNULL(Ext_Building,'') !='' 
THEN ', ' + Ext_Building 
ELSE '' 
END
+ 
CASE 
WHEN ISNULL(Int_Building,'') !='' 
THEN ', ' + Int_Building 
ELSE '' 
END
+ 
CASE 
WHEN ISNULL(Restroom,'') != '' 
THEN ', ' + Restroom  
ELSE '' 
END
+ CASE 
WHEN ISNULL(Exam_room,'') != '' 
THEN ', ' + Exam_room 
ELSE '' 
END
+ 
CASE 
WHEN ISNULL(Exam_Taable,'') != '' 
THEN ', ' + Exam_Taable 
ELSE '' 
END
+ 
CASE 
WHEN ISNULL(Patient_Area,'') !='' 
THEN ', ' + Patient_Area 
ELSE '' 
END
+ 
CASE 
WHEN ISNULL(Exam_Room_Disabilities,'') != '' 
THEN ', ' + Exam_Room_Disabilities 
ELSE '' 
END,1,2,'') AS 'Accessibility (Categories)' */
,STUFF(
CASE 
WHEN ISNULL(PHY_LANG01_PRV_LANG01,'') != '' 
THEN ', ' + PHY_LANG01_PRV_LANG01
ELSE '' 
END
+ CASE 
WHEN ISNULL(PHY_LANG02_PRV_LANG02,'') !='' 
THEN ', ' + PHY_LANG02_PRV_LANG02 
ELSE '' 
END
+ 
CASE 
WHEN ISNULL(PHY_LANG03_PRV_LANG03,'') !='' 
THEN ', ' + PHY_LANG03_PRV_LANG03 
ELSE '' 
END
+ 
CASE 
WHEN ISNULL(PHY_LANG04_PRV_LANG04,'') != '' 
THEN ', ' + PHY_LANG04_PRV_LANG04  
ELSE '' 
END
+ 
CASE 
WHEN ISNULL(PHY_LANG05_PRV_LANG05,'') != '' 
THEN ', ' + PHY_LANG05_PRV_LANG05 
ELSE '' 
END,1,2,'') AS 'FINALlang'
-- ,TRY_CONVERT(nvarchar(255),NULL) AS 'FINALlang'
-- ,Provider_Language AS 'FINALlang' 
,HOSP_NAME AS 'FINALhosp_FULL_NAME'
-- ,HospitalAmittingPriv AS 'FINALhosp_FULL_NAME'
,TRY_CONVERT(nvarchar(100),NULL) AS 'UPDATEDT_FOOTNOTE,' -- UPDATE() IN THE POST
,TRY_CONVERT(nvarchar(100),NULL) AS 'CHAPTER_COUNT' -- UPDATE() IN THE POST
,ca.CHAPTER_NAME
-- ,'Primary Care Physician' AS 'CHAPTER_NAME'
,ISNULL(WEBSITE,'') AS 'URL_WEBSITE'
-- ,TRY_CONVERT(nvarchar(100),NULL) AS 'URL_WEBSITE'
,TRY_CONVERT(nvarchar(10),' ') AS 'AFTERHOURS_PHONE' 
-- ,ISNULL(After_Hours_Phone,'') AS 'AFTERHOURS_PHONE' 
,'Yes' AS [ACCESS BY PUBLIC TRANSPORTATION] -- DEFAULT VAL() AS NULL(S) NOT ACCEPTED
,ca.PROVIDER_TYPE
-- ,'Primary Care' AS 'PROVIDER_TYPE'-- DEFAULT VAL() AS NULL(S) NOT ACCEPTED
,'Yes' AS ACCREDITATION -- DEFAULT VAL() AS NULL(S) NOT ACCEPTED
,[Telehealth_Indicator] -- C001: APPLICABLE TO PROVIDERS ONLY!!! ADD - ON PER EMAIL FROM MS JOHANNA BASED UPON DHCS FINDING (LEVERAGE: APL 25-014 AND OR "PROVDIR Telehealth Indicator evips location .msg")
,[COUNTY] 
-- SELECT TOP 10 ' ' AS 'CHECK 1st',* 
-- SELECT DISTINCT ' ' AS 'CHECK 1st',PCP_SPC,TITLE
FROM INFORMATICS.dbo.CHPIV_PROVIDER_DIRECTORY_DATA AS chpiv -- LEVERAGE: "CHPIV Provider Directory Data to CHG 9_18_25_PROPER_CASE.xlsx" AND "CHPIV PROVDIR CONDITIONAL LINE ITEM.png" AND "CHPIV Provider Directory Data to CHG 12_08_25.xlsx"  AND ...
CROSS APPLY (  -- INDEPENDENT STAND ALONE ... CROSS APPLY() CROSS JOIN() CARTESIAN PRODUCT
SELECT TOP 1 CHAPTER_NAME
,PROVIDER_TYPE 
FROM INFORMATICS.dbo.PROVDIR_NPMP
) -- CONCLUDE ...
AS ca
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
	AND NOT [GROUP] LIKE '%CHPIV%Direct%' -- NO NOT NEGATIVE <> != ... -- C003: PULL CHPIV DIRECT PROVIDER(S) AND OR ENTITY(-IES) EXCLUSIVELY FROM eVIPS
	AND SPECIALTY IN ('Nurse Practitioner','Physician Assistant')

		SELECT ' ' AS 'CONFIRM PRESENCE OF AT LEAST ONE 1 "CHPIV" RECORD',*
		FROM INFORMATICS.dbo.PROVDIR_NPMP 
		WHERE 1=1 
			AND [Participating Network] LIKE '%CHPIV%'

SELECT ' ' AS '#PYTHON UPLOAD OF ... : ',*
FROM INFORMATICS.dbo.CHPIV_PROVIDER_DIRECTORY_DATA -- LEVERAGE: "CHPIV Provider Directory Data to CHG 9_18_25_PROPER_CASE.xlsx" AND "CHPIV PROVDIR CONDITIONAL LINE ITEM.png"
WHERE 1=1 
	AND SPECIALTY IN ('Nurse Practitioner','Physician Assistant')
		
		SELECT DISTINCT SECTION_NO
		,[GROUP]
		SPECIALTY
		,CASE
		WHEN [GROUP] LIKE '%CHPIV%Direct%'
		THEN 'CHPIV-DSNP'
		WHEN [GROUP] LIKE '%Community Care IPA%'
		THEN 'CHPIV-IPA-CC'
		WHEN [GROUP] LIKE '%Imperial County Physicians Medical Group%'
		THEN 'CHPIV-IPA-ICPMG'
		WHEN [GROUP] LIKE '%Premier Patient Care IPA%'
		THEN 'CHPIV-IPA-PPC'
		WHEN [GROUP] LIKE '%Primary%Care%Med%Group%'
		THEN 'CHPIV-IPA-PCMG'
		ELSE ''
		END AS [Participating Network]
		FROM INFORMATICS.dbo.CHPIV_PROVIDER_DIRECTORY_DATA -- LEVERAGE: "CHPIV Provider Directory Data to CHG 9_18_25_PROPER_CASE.xlsx" AND "CHPIV PROVDIR CONDITIONAL LINE ITEM.png"
		WHERE 1=1 
			AND SPECIALTY IN ('Nurse Practitioner','Physician Assistant')

-- =======================================================
	-- UPLOAD ENTRY FOR PROVDIR_SPE
-- =======================================================
INSERT INTO INFORMATICS.dbo.PROVDIR_SPE (ZIP,NPIis,[Participating Network],SPEC,CityIs,[Zip Code],INDEXNM,PROVNM,[Clinic Name],DBA,[Address],CSZ,[Telephone Number],CA_License,[BOARD CERTIFIED],[ACCEPTING NEW PATIENTS],[Office Hour(s)],Accessibility,[Accessibility Category(ies)],FINALlang,FINALhosp_FULL_NAME,UPDATEDT_FOOTNOTE,CHAPTER_COUNT,CHAPTER_NAME,URL_WEBSITE,AFTERHOURS_PHONE,[ACCESS BY PUBLIC TRANSPORTATION],PROVIDER_TYPE,ACCREDITATION,Telehealth_Indicator,COUNTY)
SELECT DISTINCT TRY_CONVERT(nvarchar(5),'91914') AS 'ZIP' -- FORCE LOCK IN ... REQ TO ESTABLISH LICENSE ... DUMMY ZIP
,iso.[RefreshNPI_NO] AS 'NPI'
-- ,ISNULL(NPI_NO,'') AS 'NPI'
,CASE
WHEN [GROUP] LIKE '%CHPIV%Direct%'
THEN 'CHPIV-DSNP'
WHEN [GROUP] LIKE '%Community Care IPA%'
THEN 'CHPIV-IPA-CC'
WHEN [GROUP] LIKE '%Imperial County Physicians Medical Group%'
THEN 'CHPIV-IPA-ICPMG'
WHEN [GROUP] LIKE '%Premier Patient Care IPA%'
THEN 'CHPIV-IPA-PPC'
WHEN [GROUP] LIKE '%Primary%Care%Med%Group%'
THEN 'CHPIV-IPA-PCMG'
ELSE ''
END AS [Participating Network]
-- ,[Participating_Network]
-- ,'CHPIV-IPA-CC' AS 'Participating Network'
,SPECIALTY AS 'SPEC'
,CITY AS 'CityIs'
,TRY_CONVERT(nvarchar(5),ZIPCODE) AS 'Zip Code'
,TRY_CONVERT(nvarchar(25),LNAME)+',  '+TRY_CONVERT(nvarchar(25),FNAME)+', '+TRY_CONVERT(nvarchar(5),TITLE) AS 'INDEXNM'
,TRY_CONVERT(nvarchar(25),LNAME)+',  '+TRY_CONVERT(nvarchar(25),FNAME)+', '+TRY_CONVERT(nvarchar(5),TITLE)+' - ID# '+TRY_CONVERT(nvarchar(25),ISNULL(DIR_ID,'')) AS 'PROVNM'
-- ,TRY_CONVERT(nvarchar(25),LNAME)+',  '+TRY_CONVERT(nvarchar(25),FNAME)+', '+TRY_CONVERT(nvarchar(5),TITLE)+' - ID# '+TRY_CONVERT(nvarchar(25),ISNULL(CAQH,'')) AS 'PROVNM'
,TRY_CONVERT(nvarchar(100),NULL) AS 'Clinic Name' -- ABSENT FROM SOURCE DATA 
-- ,TRY_CONVERT(nvarchar(100),Clinic_Name)AS 'Clinic Name' -- ABSENT FROM SOURCE DATA 
,ISNULL([GROUP],'') AS 'DBA'
-- ,TRY_CONVERT(nvarchar(100),'CHPIV CommunityCare IPA') AS 'DBA'
-- ,TRY_CONVERT(nvarchar(100),ISNULL(PPG_NAME,'')) -- DBA AND OR ASSOCIATION_GROUP
,TRY_CONVERT(nvarchar(100),[Address]) AS 'Address'
,TRY_CONVERT(nvarchar(100),CITY)+', CA '+TRY_CONVERT(nvarchar(5),ZIPCODE) AS 'CSZ'
,TRY_CONVERT(nvarchar(13),PHONE) AS  'Telephone Number'
,LIC_ID AS 'CA_License'
-- ,TRY_CONVERT(nvarchar(100),NULL) AS 'BOARD CERTIFIED' -- Y OR N + (SPECIFIC BOARD IS ABSENT FROM SOURCE DATA)
,CASE
WHEN ISNULL(BOARD_CERT_ID,'N') IN('N')
THEN 'N'
ELSE 'Y ('+ISNULL(BOARD_CERT_ID,'')+')' 
END AS 'BOARD CERTIFIED' -- Y OR N + (SPECIFIC BOARD IS ABSENT FROM SOURCE DATA)
,CASE
WHEN ISNULL(ACCEPT_NEW_PAT,'') LIKE '%Y%'
THEN 'Yes'
ELSE 'No'
END AS 'ACCEPTING NEW PATIENTS'
-- ,ISNULL(ACCEPT_NEW_PAT,'') AS 'ACCEPTING NEW PATIENTS'
-- ,ACCEPT_NEW_PAT AS 'ACCEPTING NEW PATIENTS'
,ISNULL([HOURS],'') AS 'Office Hour(s)'
-- ,TRY_CONVERT(nvarchar(100),NULL) AS 'Accessibility'
,TRY_CONVERT(nvarchar(12),ISNULL(ACCESS_REQ,'')) AS 'Accessibility'
-- ,TRY_CONVERT(nvarchar(255),NULL) AS 'Accessibility (Categories)'
,STUFF(
CASE 
WHEN ISNULL(PARKING_IND,'') != '' 
THEN ', ' + PARKING_IND
ELSE '' 
END
+ CASE 
WHEN ISNULL(EXT_BUILD_IND,'') !='' 
THEN ', ' + EXT_BUILD_IND 
ELSE '' 
END
+ 
CASE 
WHEN ISNULL(INT_BUILD_IND,'') !='' 
THEN ', ' + INT_BUILD_IND 
ELSE '' 
END
+ 
CASE 
WHEN ISNULL(RESTROOM_IND,'') != '' 
THEN ', ' + RESTROOM_IND  
ELSE '' 
END
+ CASE 
WHEN ISNULL(EXAMROOM_IND,'') != '' 
THEN ', ' + EXAMROOM_IND 
ELSE '' 
END
+ 
CASE 
WHEN ISNULL(EXAMTBL_IND,'') != '' 
THEN ', ' + EXAMTBL_IND 
ELSE '' 
END
+ 
CASE 
WHEN ISNULL(PATIENT_AREA_IND,'') !='' 
THEN ', ' + PATIENT_AREA_IND 
ELSE '' 
END
+ 
CASE 
WHEN ISNULL(PATIENT_DIA_IND,'') != '' 
THEN ', ' + PATIENT_DIA_IND 
ELSE '' 
END,1,2,'') AS 'Accessibility (Categories)'
/* ,STUFF(
CASE 
WHEN ISNULL(Parking_Availabilty,'') != '' 
THEN ', ' + Parking_Availabilty
ELSE '' 
END
+ CASE 
WHEN ISNULL(Ext_Building,'') !='' 
THEN ', ' + Ext_Building 
ELSE '' 
END
+ 
CASE 
WHEN ISNULL(Int_Building,'') !='' 
THEN ', ' + Int_Building 
ELSE '' 
END
+ 
CASE 
WHEN ISNULL(Restroom,'') != '' 
THEN ', ' + Restroom  
ELSE '' 
END
+ CASE 
WHEN ISNULL(Exam_room,'') != '' 
THEN ', ' + Exam_room 
ELSE '' 
END
+ 
CASE 
WHEN ISNULL(Exam_Taable,'') != '' 
THEN ', ' + Exam_Taable 
ELSE '' 
END
+ 
CASE 
WHEN ISNULL(Patient_Area,'') !='' 
THEN ', ' + Patient_Area 
ELSE '' 
END
+ 
CASE 
WHEN ISNULL(Exam_Room_Disabilities,'') != '' 
THEN ', ' + Exam_Room_Disabilities 
ELSE '' 
END,1,2,'') AS 'Accessibility (Categories)' */
,STUFF(
CASE 
WHEN ISNULL(PHY_LANG01_PRV_LANG01,'') != '' 
THEN ', ' + PHY_LANG01_PRV_LANG01
ELSE '' 
END
+ CASE 
WHEN ISNULL(PHY_LANG02_PRV_LANG02,'') !='' 
THEN ', ' + PHY_LANG02_PRV_LANG02 
ELSE '' 
END
+ 
CASE 
WHEN ISNULL(PHY_LANG03_PRV_LANG03,'') !='' 
THEN ', ' + PHY_LANG03_PRV_LANG03 
ELSE '' 
END
+ 
CASE 
WHEN ISNULL(PHY_LANG04_PRV_LANG04,'') != '' 
THEN ', ' + PHY_LANG04_PRV_LANG04  
ELSE '' 
END
+ 
CASE 
WHEN ISNULL(PHY_LANG05_PRV_LANG05,'') != '' 
THEN ', ' + PHY_LANG05_PRV_LANG05 
ELSE '' 
END,1,2,'') AS 'FINALlang'
-- ,TRY_CONVERT(nvarchar(255),NULL) AS 'FINALlang'
-- ,Provider_Language AS 'FINALlang' 
,HOSP_NAME AS 'FINALhosp_FULL_NAME'
-- ,HospitalAmittingPriv AS 'FINALhosp_FULL_NAME'
,TRY_CONVERT(nvarchar(100),NULL) AS 'UPDATEDT_FOOTNOTE,' -- UPDATE() IN THE POST
,TRY_CONVERT(nvarchar(100),NULL) AS 'CHAPTER_COUNT' -- UPDATE() IN THE POST
,ca.CHAPTER_NAME
-- ,'Primary Care Physician' AS 'CHAPTER_NAME'
,ISNULL(WEBSITE,'') AS 'URL_WEBSITE'
-- ,TRY_CONVERT(nvarchar(100),NULL) AS 'URL_WEBSITE'
,TRY_CONVERT(nvarchar(10),' ') AS 'AFTERHOURS_PHONE' 
-- ,ISNULL(After_Hours_Phone,'') AS 'AFTERHOURS_PHONE' 
,'Yes' AS [ACCESS BY PUBLIC TRANSPORTATION] -- DEFAULT VAL() AS NULL(S) NOT ACCEPTED
,ca.PROVIDER_TYPE
-- ,'Primary Care' AS 'PROVIDER_TYPE'-- DEFAULT VAL() AS NULL(S) NOT ACCEPTED
,'Yes' AS ACCREDITATION -- DEFAULT VAL() AS NULL(S) NOT ACCEPTED
,[Telehealth_Indicator] -- C001: APPLICABLE TO PROVIDERS ONLY!!! ADD - ON PER EMAIL FROM MS JOHANNA BASED UPON DHCS FINDING (LEVERAGE: APL 25-014 AND OR "PROVDIR Telehealth Indicator evips location .msg")
,[COUNTY] 
-- SELECT TOP 10 ' ' AS 'CHECK 1st',* 
-- SELECT DISTINCT ' ' AS 'CHECK 1st',PCP_SPC,TITLE
FROM INFORMATICS.dbo.CHPIV_PROVIDER_DIRECTORY_DATA AS chpiv -- LEVERAGE: "CHPIV Provider Directory Data to CHG 9_18_25_PROPER_CASE.xlsx" AND "CHPIV PROVDIR CONDITIONAL LINE ITEM.png" AND "CHPIV Provider Directory Data to CHG 12_08_25.xlsx"  AND ...
CROSS APPLY (  -- INDEPENDENT STAND ALONE ... CROSS APPLY() CROSS JOIN() CARTESIAN PRODUCT
SELECT TOP 1 CHAPTER_NAME
,PROVIDER_TYPE 
FROM INFORMATICS.dbo.PROVDIR_SPE
) -- CONCLUDE ...
AS ca
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
	AND NOT [GROUP] LIKE '%CHPIV%Direct%' -- NO NOT NEGATIVE <> != ... -- C003: PULL CHPIV DIRECT PROVIDER(S) AND OR ENTITY(-IES) EXCLUSIVELY FROM eVIPS
	AND NOT SPECIALTY IN ('Family Practice','Internal Medicine','Pediatrics') -- NO NOT NEGATIVE <> != ... PCP
	AND NOT SPECIALTY IN ('Nurse Practitioner','Physician Assistant') -- NO NOT NEGATIVE <> != ... NPMP PA
	AND NOT SPECIALTY LIKE '%Psych%' -- NO NOT NEGATIVE <> != ... MH
	AND NOT SPECIALTY IN ('Acupuncture','Chiropractor','Physical Therapy','Occupational Therapist') -- NO NOT NEGATIVE <> != ... AHP
	AND NOT SPECIALTY LIKE '%Doula%' -- NO NOT NEGATIVE <> != ... DOULA
	AND NOT SPECIALTY LIKE '%Optometry%' -- NO NOT NEGATIVE <> != ... VSP
	AND NOT ISNULL(FNAME,'') = '' -- NO NOT NEGATIVE <> != ... FACILITIES

		SELECT ' ' AS 'CONFIRM PRESENCE OF AT LEAST ONE 1 "CHPIV" RECORD',*
		FROM INFORMATICS.dbo.PROVDIR_SPE 
		WHERE 1=1 
			AND [Participating Network] LIKE '%CHPIV%'

SELECT ' ' AS '#PYTHON UPLOAD OF ... : ',*
FROM INFORMATICS.dbo.CHPIV_PROVIDER_DIRECTORY_DATA -- LEVERAGE: "CHPIV Provider Directory Data to CHG 9_18_25_PROPER_CASE.xlsx" AND "CHPIV PROVDIR CONDITIONAL LINE ITEM.png"
WHERE 1=1 
	AND NOT SPECIALTY IN ('Family Practice','Internal Medicine','Pediatrics') -- NO NOT NEGATIVE <> != ... PCP
	AND NOT SPECIALTY IN ('Nurse Practitioner','Physician Assistant') -- NO NOT NEGATIVE <> != ... NPMP PA
	AND NOT SPECIALTY LIKE '%Psych%' -- NO NOT NEGATIVE <> != ... MH
	AND NOT SPECIALTY IN ('Acupuncture','Chiropractor','Physical Therapy','Occupational Therapist') -- NO NOT NEGATIVE <> != ... AHP
	AND NOT SPECIALTY LIKE '%Doula%' -- NO NOT NEGATIVE <> != ... DOULA
	AND NOT SPECIALTY LIKE '%Optometry%' -- NO NOT NEGATIVE <> != ... VSP
	AND NOT ISNULL(FNAME,'') = '' -- NO NOT NEGATIVE <> != ... FACILITIES
		
		SELECT DISTINCT SECTION_NO
		,[GROUP]
		SPECIALTY
		,CASE
		WHEN [GROUP] LIKE '%CHPIV%Direct%'
		THEN 'CHPIV-DSNP'
		WHEN [GROUP] LIKE '%Community Care IPA%'
		THEN 'CHPIV-IPA-CC'
		WHEN [GROUP] LIKE '%Imperial County Physicians Medical Group%'
		THEN 'CHPIV-IPA-ICPMG'
		WHEN [GROUP] LIKE '%Premier Patient Care IPA%'
		THEN 'CHPIV-IPA-PPC'
		WHEN [GROUP] LIKE '%Primary%Care%Med%Group%'
		THEN 'CHPIV-IPA-PCMG'
		ELSE ''
		END AS [Participating Network]
		FROM INFORMATICS.dbo.CHPIV_PROVIDER_DIRECTORY_DATA -- LEVERAGE: "CHPIV Provider Directory Data to CHG 9_18_25_PROPER_CASE.xlsx" AND "CHPIV PROVDIR CONDITIONAL LINE ITEM.png"
		WHERE 1=1 
			AND NOT SPECIALTY IN ('Family Practice','Internal Medicine','Pediatrics') -- NO NOT NEGATIVE <> != ... PCP
			AND NOT SPECIALTY IN ('Nurse Practitioner','Physician Assistant') -- NO NOT NEGATIVE <> != ... NPMP PA
			AND NOT SPECIALTY LIKE '%Psych%' -- NO NOT NEGATIVE <> != ... MH
			AND NOT SPECIALTY IN ('Acupuncture','Chiropractor','Physical Therapy','Occupational Therapist') -- NO NOT NEGATIVE <> != ... AHP
			AND NOT SPECIALTY LIKE '%Doula%' -- NO NOT NEGATIVE <> != ... DOULA
			AND NOT SPECIALTY LIKE '%Optometry%' -- NO NOT NEGATIVE <> != ... VSP
			AND NOT ISNULL(FNAME,'') = '' -- NO NOT NEGATIVE <> != ... FACILITIES

-- =======================================================
	-- UPLOAD ENTRY FOR PROVDIR_MH
-- =======================================================
INSERT INTO INFORMATICS.dbo.PROVDIR_MH (ZIP,NPIis,[Participating Network],SPEC,CityIs,[Zip Code],INDEXNM,PROVNM,[Clinic Name],DBA,[Address],CSZ,[Telephone Number],CA_License,[BOARD CERTIFIED],[ACCEPTING NEW PATIENTS],[Office Hour(s)],Accessibility,[Accessibility Category(ies)],FINALlang,FINALhosp_FULL_NAME,UPDATEDT_FOOTNOTE,CHAPTER_COUNT,CHAPTER_NAME,URL_WEBSITE,AFTERHOURS_PHONE,[ACCESS BY PUBLIC TRANSPORTATION],PROVIDER_TYPE,ACCREDITATION,Telehealth_Indicator,COUNTY)
SELECT DISTINCT TRY_CONVERT(nvarchar(5),'91914') AS 'ZIP' -- FORCE LOCK IN ... REQ TO ESTABLISH LICENSE ... DUMMY ZIP
,iso.[RefreshNPI_NO] AS 'NPI'
-- ,ISNULL(NPI_NO,'') AS 'NPI'
,CASE
WHEN [GROUP] LIKE '%CHPIV%Direct%'
THEN 'CHPIV-DSNP'
WHEN [GROUP] LIKE '%Community Care IPA%'
THEN 'CHPIV-IPA-CC'
WHEN [GROUP] LIKE '%Imperial County Physicians Medical Group%'
THEN 'CHPIV-IPA-ICPMG'
WHEN [GROUP] LIKE '%Premier Patient Care IPA%'
THEN 'CHPIV-IPA-PPC'
WHEN [GROUP] LIKE '%Primary%Care%Med%Group%'
THEN 'CHPIV-IPA-PCMG'
ELSE ''
END AS [Participating Network]
-- ,[Participating_Network]
-- ,'CHPIV-IPA-CC' AS 'Participating Network'
,SPECIALTY AS 'SPEC'
,CITY AS 'CityIs'
,TRY_CONVERT(nvarchar(5),ZIPCODE) AS 'Zip Code'
,TRY_CONVERT(nvarchar(25),LNAME)+',  '+TRY_CONVERT(nvarchar(25),FNAME)+', '+TRY_CONVERT(nvarchar(5),TITLE) AS 'INDEXNM'
,TRY_CONVERT(nvarchar(25),LNAME)+',  '+TRY_CONVERT(nvarchar(25),FNAME)+', '+TRY_CONVERT(nvarchar(5),TITLE)+' - ID# '+TRY_CONVERT(nvarchar(25),ISNULL(DIR_ID,'')) AS 'PROVNM'
-- ,TRY_CONVERT(nvarchar(25),LNAME)+',  '+TRY_CONVERT(nvarchar(25),FNAME)+', '+TRY_CONVERT(nvarchar(5),TITLE)+' - ID# '+TRY_CONVERT(nvarchar(25),ISNULL(CAQH,'')) AS 'PROVNM'
,TRY_CONVERT(nvarchar(100),NULL) AS 'Clinic Name' -- ABSENT FROM SOURCE DATA 
-- ,TRY_CONVERT(nvarchar(100),Clinic_Name)AS 'Clinic Name' -- ABSENT FROM SOURCE DATA 
,ISNULL([GROUP],'') AS 'DBA'
-- ,TRY_CONVERT(nvarchar(100),'CHPIV CommunityCare IPA') AS 'DBA'
-- ,TRY_CONVERT(nvarchar(100),ISNULL(PPG_NAME,'')) -- DBA AND OR ASSOCIATION_GROUP
,TRY_CONVERT(nvarchar(100),[Address]) AS 'Address'
,TRY_CONVERT(nvarchar(100),CITY)+', CA '+TRY_CONVERT(nvarchar(5),ZIPCODE) AS 'CSZ'
,TRY_CONVERT(nvarchar(13),PHONE) AS  'Telephone Number'
,LIC_ID AS 'CA_License'
-- ,TRY_CONVERT(nvarchar(100),NULL) AS 'BOARD CERTIFIED' -- Y OR N + (SPECIFIC BOARD IS ABSENT FROM SOURCE DATA)
,CASE
WHEN ISNULL(BOARD_CERT_ID,'N') IN('N')
THEN 'N'
ELSE 'Y ('+ISNULL(BOARD_CERT_ID,'')+')' 
END AS 'BOARD CERTIFIED' -- Y OR N + (SPECIFIC BOARD IS ABSENT FROM SOURCE DATA)
,CASE
WHEN ISNULL(ACCEPT_NEW_PAT,'') LIKE '%Y%'
THEN 'Yes'
ELSE 'No'
END AS 'ACCEPTING NEW PATIENTS'
-- ,ISNULL(ACCEPT_NEW_PAT,'') AS 'ACCEPTING NEW PATIENTS'
-- ,ACCEPT_NEW_PAT AS 'ACCEPTING NEW PATIENTS'
,ISNULL([HOURS],'') AS 'Office Hour(s)'
-- ,TRY_CONVERT(nvarchar(100),NULL) AS 'Accessibility'
,TRY_CONVERT(nvarchar(12),ISNULL(ACCESS_REQ,'')) AS 'Accessibility'
-- ,TRY_CONVERT(nvarchar(255),NULL) AS 'Accessibility (Categories)'
,STUFF(
CASE 
WHEN ISNULL(PARKING_IND,'') != '' 
THEN ', ' + PARKING_IND
ELSE '' 
END
+ CASE 
WHEN ISNULL(EXT_BUILD_IND,'') !='' 
THEN ', ' + EXT_BUILD_IND 
ELSE '' 
END
+ 
CASE 
WHEN ISNULL(INT_BUILD_IND,'') !='' 
THEN ', ' + INT_BUILD_IND 
ELSE '' 
END
+ 
CASE 
WHEN ISNULL(RESTROOM_IND,'') != '' 
THEN ', ' + RESTROOM_IND  
ELSE '' 
END
+ CASE 
WHEN ISNULL(EXAMROOM_IND,'') != '' 
THEN ', ' + EXAMROOM_IND 
ELSE '' 
END
+ 
CASE 
WHEN ISNULL(EXAMTBL_IND,'') != '' 
THEN ', ' + EXAMTBL_IND 
ELSE '' 
END
+ 
CASE 
WHEN ISNULL(PATIENT_AREA_IND,'') !='' 
THEN ', ' + PATIENT_AREA_IND 
ELSE '' 
END
+ 
CASE 
WHEN ISNULL(PATIENT_DIA_IND,'') != '' 
THEN ', ' + PATIENT_DIA_IND 
ELSE '' 
END,1,2,'') AS 'Accessibility (Categories)'
/* ,STUFF(
CASE 
WHEN ISNULL(Parking_Availabilty,'') != '' 
THEN ', ' + Parking_Availabilty
ELSE '' 
END
+ CASE 
WHEN ISNULL(Ext_Building,'') !='' 
THEN ', ' + Ext_Building 
ELSE '' 
END
+ 
CASE 
WHEN ISNULL(Int_Building,'') !='' 
THEN ', ' + Int_Building 
ELSE '' 
END
+ 
CASE 
WHEN ISNULL(Restroom,'') != '' 
THEN ', ' + Restroom  
ELSE '' 
END
+ CASE 
WHEN ISNULL(Exam_room,'') != '' 
THEN ', ' + Exam_room 
ELSE '' 
END
+ 
CASE 
WHEN ISNULL(Exam_Taable,'') != '' 
THEN ', ' + Exam_Taable 
ELSE '' 
END
+ 
CASE 
WHEN ISNULL(Patient_Area,'') !='' 
THEN ', ' + Patient_Area 
ELSE '' 
END
+ 
CASE 
WHEN ISNULL(Exam_Room_Disabilities,'') != '' 
THEN ', ' + Exam_Room_Disabilities 
ELSE '' 
END,1,2,'') AS 'Accessibility (Categories)' */
,STUFF(
CASE 
WHEN ISNULL(PHY_LANG01_PRV_LANG01,'') != '' 
THEN ', ' + PHY_LANG01_PRV_LANG01
ELSE '' 
END
+ CASE 
WHEN ISNULL(PHY_LANG02_PRV_LANG02,'') !='' 
THEN ', ' + PHY_LANG02_PRV_LANG02 
ELSE '' 
END
+ 
CASE 
WHEN ISNULL(PHY_LANG03_PRV_LANG03,'') !='' 
THEN ', ' + PHY_LANG03_PRV_LANG03 
ELSE '' 
END
+ 
CASE 
WHEN ISNULL(PHY_LANG04_PRV_LANG04,'') != '' 
THEN ', ' + PHY_LANG04_PRV_LANG04  
ELSE '' 
END
+ 
CASE 
WHEN ISNULL(PHY_LANG05_PRV_LANG05,'') != '' 
THEN ', ' + PHY_LANG05_PRV_LANG05 
ELSE '' 
END,1,2,'') AS 'FINALlang'
-- ,TRY_CONVERT(nvarchar(255),NULL) AS 'FINALlang'
-- ,Provider_Language AS 'FINALlang' 
,HOSP_NAME AS 'FINALhosp_FULL_NAME'
-- ,HospitalAmittingPriv AS 'FINALhosp_FULL_NAME'
,TRY_CONVERT(nvarchar(100),NULL) AS 'UPDATEDT_FOOTNOTE,' -- UPDATE() IN THE POST
,TRY_CONVERT(nvarchar(100),NULL) AS 'CHAPTER_COUNT' -- UPDATE() IN THE POST
,ca.CHAPTER_NAME
-- ,'Primary Care Physician' AS 'CHAPTER_NAME'
,ISNULL(WEBSITE,'') AS 'URL_WEBSITE'
-- ,TRY_CONVERT(nvarchar(100),NULL) AS 'URL_WEBSITE'
,TRY_CONVERT(nvarchar(10),' ') AS 'AFTERHOURS_PHONE' 
-- ,ISNULL(After_Hours_Phone,'') AS 'AFTERHOURS_PHONE' 
,'Yes' AS [ACCESS BY PUBLIC TRANSPORTATION] -- DEFAULT VAL() AS NULL(S) NOT ACCEPTED
,ca.PROVIDER_TYPE
-- ,'Primary Care' AS 'PROVIDER_TYPE'-- DEFAULT VAL() AS NULL(S) NOT ACCEPTED
,'Yes' AS ACCREDITATION -- DEFAULT VAL() AS NULL(S) NOT ACCEPTED
,[Telehealth_Indicator] -- C001: APPLICABLE TO PROVIDERS ONLY!!! ADD - ON PER EMAIL FROM MS JOHANNA BASED UPON DHCS FINDING (LEVERAGE: APL 25-014 AND OR "PROVDIR Telehealth Indicator evips location .msg")
,[COUNTY] 
-- SELECT TOP 10 ' ' AS 'CHECK 1st',* 
-- SELECT DISTINCT ' ' AS 'CHECK 1st',PCP_SPC,TITLE
FROM INFORMATICS.dbo.CHPIV_PROVIDER_DIRECTORY_DATA AS chpiv -- LEVERAGE: "CHPIV Provider Directory Data to CHG 9_18_25_PROPER_CASE.xlsx" AND "CHPIV PROVDIR CONDITIONAL LINE ITEM.png" AND "CHPIV Provider Directory Data to CHG 12_08_25.xlsx"  AND ...
CROSS APPLY (  -- INDEPENDENT STAND ALONE ... CROSS APPLY() CROSS JOIN() CARTESIAN PRODUCT
SELECT TOP 1 CHAPTER_NAME
,PROVIDER_TYPE 
FROM INFORMATICS.dbo.PROVDIR_MH
) -- CONCLUDE ...
AS ca
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
	AND NOT [GROUP] LIKE '%CHPIV%Direct%' -- NO NOT NEGATIVE <> != ... -- C003: PULL CHPIV DIRECT PROVIDER(S) AND OR ENTITY(-IES) EXCLUSIVELY FROM eVIPS
	AND SPECIALTY LIKE '%Psych%'

		SELECT ' ' AS 'CONFIRM PRESENCE OF AT LEAST ONE 1 "CHPIV" RECORD',*
		FROM INFORMATICS.dbo.PROVDIR_MH 
		WHERE 1=1 
			AND [Participating Network] LIKE '%CHPIV%'

SELECT ' ' AS '#PYTHON UPLOAD OF ... : ',*
FROM INFORMATICS.dbo.CHPIV_PROVIDER_DIRECTORY_DATA -- LEVERAGE: "CHPIV Provider Directory Data to CHG 9_18_25_PROPER_CASE.xlsx" AND "CHPIV PROVDIR CONDITIONAL LINE ITEM.png"
WHERE 1=1 
	AND SPECIALTY LIKE '%Psych%'
		
		SELECT DISTINCT SECTION_NO
		,[GROUP]
		SPECIALTY
		,CASE
		WHEN [GROUP] LIKE '%CHPIV%Direct%'
		THEN 'CHPIV-DSNP'
		WHEN [GROUP] LIKE '%Community Care IPA%'
		THEN 'CHPIV-IPA-CC'
		WHEN [GROUP] LIKE '%Imperial County Physicians Medical Group%'
		THEN 'CHPIV-IPA-ICPMG'
		WHEN [GROUP] LIKE '%Premier Patient Care IPA%'
		THEN 'CHPIV-IPA-PPC'
		WHEN [GROUP] LIKE '%Primary%Care%Med%Group%'
		THEN 'CHPIV-IPA-PCMG'
		ELSE ''
		END AS [Participating Network]
		FROM INFORMATICS.dbo.CHPIV_PROVIDER_DIRECTORY_DATA -- LEVERAGE: "CHPIV Provider Directory Data to CHG 9_18_25_PROPER_CASE.xlsx" AND "CHPIV PROVDIR CONDITIONAL LINE ITEM.png"
		WHERE 1=1 
			AND SPECIALTY LIKE '%Psych%'

-- =======================================================
	-- UPLOAD ENTRY FOR PROVDIR_AHP
-- =======================================================
INSERT INTO INFORMATICS.dbo.PROVDIR_AHP (ZIP,NPIis,[Participating Network],SPEC,CityIs,[Zip Code],INDEXNM,PROVNM,[Clinic Name],DBA,[Address],CSZ,[Telephone Number],CA_License,[BOARD CERTIFIED],[ACCEPTING NEW PATIENTS],[Office Hour(s)],Accessibility,[Accessibility Category(ies)],FINALlang,FINALhosp_FULL_NAME,UPDATEDT_FOOTNOTE,CHAPTER_COUNT,CHAPTER_NAME,URL_WEBSITE,AFTERHOURS_PHONE,[ACCESS BY PUBLIC TRANSPORTATION],PROVIDER_TYPE,ACCREDITATION,Telehealth_Indicator,COUNTY)
SELECT DISTINCT TRY_CONVERT(nvarchar(5),'91914') AS 'ZIP' -- FORCE LOCK IN ... REQ TO ESTABLISH LICENSE ... DUMMY ZIP
,iso.[RefreshNPI_NO] AS 'NPI'
-- ,ISNULL(NPI_NO,'') AS 'NPI'
,CASE
WHEN [GROUP] LIKE '%CHPIV%Direct%'
THEN 'CHPIV-DSNP'
WHEN [GROUP] LIKE '%Community Care IPA%'
THEN 'CHPIV-IPA-CC'
WHEN [GROUP] LIKE '%Imperial County Physicians Medical Group%'
THEN 'CHPIV-IPA-ICPMG'
WHEN [GROUP] LIKE '%Premier Patient Care IPA%'
THEN 'CHPIV-IPA-PPC'
WHEN [GROUP] LIKE '%Primary%Care%Med%Group%'
THEN 'CHPIV-IPA-PCMG'
ELSE ''
END AS [Participating Network]
-- ,[Participating_Network]
-- ,'CHPIV-IPA-CC' AS 'Participating Network'
,SPECIALTY AS 'SPEC'
,CITY AS 'CityIs'
,TRY_CONVERT(nvarchar(5),ZIPCODE) AS 'Zip Code'
,TRY_CONVERT(nvarchar(25),LNAME)+',  '+TRY_CONVERT(nvarchar(25),FNAME)+', '+TRY_CONVERT(nvarchar(5),TITLE) AS 'INDEXNM'
,TRY_CONVERT(nvarchar(25),LNAME)+',  '+TRY_CONVERT(nvarchar(25),FNAME)+', '+TRY_CONVERT(nvarchar(5),TITLE)+' - ID# '+TRY_CONVERT(nvarchar(25),ISNULL(DIR_ID,'')) AS 'PROVNM'
-- ,TRY_CONVERT(nvarchar(25),LNAME)+',  '+TRY_CONVERT(nvarchar(25),FNAME)+', '+TRY_CONVERT(nvarchar(5),TITLE)+' - ID# '+TRY_CONVERT(nvarchar(25),ISNULL(CAQH,'')) AS 'PROVNM'
,TRY_CONVERT(nvarchar(100),NULL) AS 'Clinic Name' -- ABSENT FROM SOURCE DATA 
-- ,TRY_CONVERT(nvarchar(100),Clinic_Name)AS 'Clinic Name' -- ABSENT FROM SOURCE DATA 
,ISNULL([GROUP],'') AS 'DBA'
-- ,TRY_CONVERT(nvarchar(100),'CHPIV CommunityCare IPA') AS 'DBA'
-- ,TRY_CONVERT(nvarchar(100),ISNULL(PPG_NAME,'')) -- DBA AND OR ASSOCIATION_GROUP
,TRY_CONVERT(nvarchar(100),[Address]) AS 'Address'
,TRY_CONVERT(nvarchar(100),CITY)+', CA '+TRY_CONVERT(nvarchar(5),ZIPCODE) AS 'CSZ'
,TRY_CONVERT(nvarchar(13),PHONE) AS  'Telephone Number'
,LIC_ID AS 'CA_License'
-- ,TRY_CONVERT(nvarchar(100),NULL) AS 'BOARD CERTIFIED' -- Y OR N + (SPECIFIC BOARD IS ABSENT FROM SOURCE DATA)
,CASE
WHEN ISNULL(BOARD_CERT_ID,'N') IN('N')
THEN 'N'
ELSE 'Y ('+ISNULL(BOARD_CERT_ID,'')+')' 
END AS 'BOARD CERTIFIED' -- Y OR N + (SPECIFIC BOARD IS ABSENT FROM SOURCE DATA)
,CASE
WHEN ISNULL(ACCEPT_NEW_PAT,'') LIKE '%Y%'
THEN 'Yes'
ELSE 'No'
END AS 'ACCEPTING NEW PATIENTS'
-- ,ISNULL(ACCEPT_NEW_PAT,'') AS 'ACCEPTING NEW PATIENTS'
-- ,ACCEPT_NEW_PAT AS 'ACCEPTING NEW PATIENTS'
,ISNULL([HOURS],'') AS 'Office Hour(s)'
-- ,TRY_CONVERT(nvarchar(100),NULL) AS 'Accessibility'
,TRY_CONVERT(nvarchar(12),ISNULL(ACCESS_REQ,'')) AS 'Accessibility'
-- ,TRY_CONVERT(nvarchar(255),NULL) AS 'Accessibility (Categories)'
,STUFF(
CASE 
WHEN ISNULL(PARKING_IND,'') != '' 
THEN ', ' + PARKING_IND
ELSE '' 
END
+ CASE 
WHEN ISNULL(EXT_BUILD_IND,'') !='' 
THEN ', ' + EXT_BUILD_IND 
ELSE '' 
END
+ 
CASE 
WHEN ISNULL(INT_BUILD_IND,'') !='' 
THEN ', ' + INT_BUILD_IND 
ELSE '' 
END
+ 
CASE 
WHEN ISNULL(RESTROOM_IND,'') != '' 
THEN ', ' + RESTROOM_IND  
ELSE '' 
END
+ CASE 
WHEN ISNULL(EXAMROOM_IND,'') != '' 
THEN ', ' + EXAMROOM_IND 
ELSE '' 
END
+ 
CASE 
WHEN ISNULL(EXAMTBL_IND,'') != '' 
THEN ', ' + EXAMTBL_IND 
ELSE '' 
END
+ 
CASE 
WHEN ISNULL(PATIENT_AREA_IND,'') !='' 
THEN ', ' + PATIENT_AREA_IND 
ELSE '' 
END
+ 
CASE 
WHEN ISNULL(PATIENT_DIA_IND,'') != '' 
THEN ', ' + PATIENT_DIA_IND 
ELSE '' 
END,1,2,'') AS 'Accessibility (Categories)'
/* ,STUFF(
CASE 
WHEN ISNULL(Parking_Availabilty,'') != '' 
THEN ', ' + Parking_Availabilty
ELSE '' 
END
+ CASE 
WHEN ISNULL(Ext_Building,'') !='' 
THEN ', ' + Ext_Building 
ELSE '' 
END
+ 
CASE 
WHEN ISNULL(Int_Building,'') !='' 
THEN ', ' + Int_Building 
ELSE '' 
END
+ 
CASE 
WHEN ISNULL(Restroom,'') != '' 
THEN ', ' + Restroom  
ELSE '' 
END
+ CASE 
WHEN ISNULL(Exam_room,'') != '' 
THEN ', ' + Exam_room 
ELSE '' 
END
+ 
CASE 
WHEN ISNULL(Exam_Taable,'') != '' 
THEN ', ' + Exam_Taable 
ELSE '' 
END
+ 
CASE 
WHEN ISNULL(Patient_Area,'') !='' 
THEN ', ' + Patient_Area 
ELSE '' 
END
+ 
CASE 
WHEN ISNULL(Exam_Room_Disabilities,'') != '' 
THEN ', ' + Exam_Room_Disabilities 
ELSE '' 
END,1,2,'') AS 'Accessibility (Categories)' */
,STUFF(
CASE 
WHEN ISNULL(PHY_LANG01_PRV_LANG01,'') != '' 
THEN ', ' + PHY_LANG01_PRV_LANG01
ELSE '' 
END
+ CASE 
WHEN ISNULL(PHY_LANG02_PRV_LANG02,'') !='' 
THEN ', ' + PHY_LANG02_PRV_LANG02 
ELSE '' 
END
+ 
CASE 
WHEN ISNULL(PHY_LANG03_PRV_LANG03,'') !='' 
THEN ', ' + PHY_LANG03_PRV_LANG03 
ELSE '' 
END
+ 
CASE 
WHEN ISNULL(PHY_LANG04_PRV_LANG04,'') != '' 
THEN ', ' + PHY_LANG04_PRV_LANG04  
ELSE '' 
END
+ 
CASE 
WHEN ISNULL(PHY_LANG05_PRV_LANG05,'') != '' 
THEN ', ' + PHY_LANG05_PRV_LANG05 
ELSE '' 
END,1,2,'') AS 'FINALlang'
-- ,TRY_CONVERT(nvarchar(255),NULL) AS 'FINALlang'
-- ,Provider_Language AS 'FINALlang' 
,HOSP_NAME AS 'FINALhosp_FULL_NAME'
-- ,HospitalAmittingPriv AS 'FINALhosp_FULL_NAME'
,TRY_CONVERT(nvarchar(100),NULL) AS 'UPDATEDT_FOOTNOTE,' -- UPDATE() IN THE POST
,TRY_CONVERT(nvarchar(100),NULL) AS 'CHAPTER_COUNT' -- UPDATE() IN THE POST
,ca.CHAPTER_NAME
-- ,'Primary Care Physician' AS 'CHAPTER_NAME'
,ISNULL(WEBSITE,'') AS 'URL_WEBSITE'
-- ,TRY_CONVERT(nvarchar(100),NULL) AS 'URL_WEBSITE'
,TRY_CONVERT(nvarchar(10),' ') AS 'AFTERHOURS_PHONE' 
-- ,ISNULL(After_Hours_Phone,'') AS 'AFTERHOURS_PHONE' 
,'Yes' AS [ACCESS BY PUBLIC TRANSPORTATION] -- DEFAULT VAL() AS NULL(S) NOT ACCEPTED
,ca.PROVIDER_TYPE
-- ,'Primary Care' AS 'PROVIDER_TYPE'-- DEFAULT VAL() AS NULL(S) NOT ACCEPTED
,'Yes' AS ACCREDITATION -- DEFAULT VAL() AS NULL(S) NOT ACCEPTED
,[Telehealth_Indicator] -- C001: APPLICABLE TO PROVIDERS ONLY!!! ADD - ON PER EMAIL FROM MS JOHANNA BASED UPON DHCS FINDING (LEVERAGE: APL 25-014 AND OR "PROVDIR Telehealth Indicator evips location .msg")
,[COUNTY] 
-- SELECT TOP 10 ' ' AS 'CHECK 1st',* 
-- SELECT DISTINCT ' ' AS 'CHECK 1st',PCP_SPC,TITLE
FROM INFORMATICS.dbo.CHPIV_PROVIDER_DIRECTORY_DATA AS chpiv -- LEVERAGE: "CHPIV Provider Directory Data to CHG 9_18_25_PROPER_CASE.xlsx" AND "CHPIV PROVDIR CONDITIONAL LINE ITEM.png" AND "CHPIV Provider Directory Data to CHG 12_08_25.xlsx"  AND ...
CROSS APPLY (  -- INDEPENDENT STAND ALONE ... CROSS APPLY() CROSS JOIN() CARTESIAN PRODUCT
SELECT TOP 1 CHAPTER_NAME
,PROVIDER_TYPE 
FROM INFORMATICS.dbo.PROVDIR_AHP
) -- CONCLUDE ...
AS ca
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
	AND NOT [GROUP] LIKE '%CHPIV%Direct%' -- NO NOT NEGATIVE <> != ... -- C003: PULL CHPIV DIRECT PROVIDER(S) AND OR ENTITY(-IES) EXCLUSIVELY FROM eVIPS
	AND SPECIALTY IN ('Acupuncture','Chiropractor','Physical Therapy','Occupational Therapist') 

		SELECT ' ' AS 'CONFIRM PRESENCE OF AT LEAST ONE 1 "CHPIV" RECORD',*
		FROM INFORMATICS.dbo.PROVDIR_AHP 
		WHERE 1=1 
			AND [Participating Network] LIKE '%CHPIV%'

SELECT ' ' AS '#PYTHON UPLOAD OF ... : ',*
FROM INFORMATICS.dbo.CHPIV_PROVIDER_DIRECTORY_DATA -- LEVERAGE: "CHPIV Provider Directory Data to CHG 9_18_25_PROPER_CASE.xlsx" AND "CHPIV PROVDIR CONDITIONAL LINE ITEM.png"
WHERE 1=1 
	AND SPECIALTY IN ('Acupuncture','Chiropractor','Physical Therapy','Occupational Therapist') 
		
		SELECT DISTINCT SECTION_NO
		,[GROUP]
		SPECIALTY
		,CASE
		WHEN [GROUP] LIKE '%CHPIV%Direct%'
		THEN 'CHPIV-DSNP'
		WHEN [GROUP] LIKE '%Community Care IPA%'
		THEN 'CHPIV-IPA-CC'
		WHEN [GROUP] LIKE '%Imperial County Physicians Medical Group%'
		THEN 'CHPIV-IPA-ICPMG'
		WHEN [GROUP] LIKE '%Premier Patient Care IPA%'
		THEN 'CHPIV-IPA-PPC'
		WHEN [GROUP] LIKE '%Primary%Care%Med%Group%'
		THEN 'CHPIV-IPA-PCMG'
		ELSE ''
		END AS [Participating Network]
		FROM INFORMATICS.dbo.CHPIV_PROVIDER_DIRECTORY_DATA -- LEVERAGE: "CHPIV Provider Directory Data to CHG 9_18_25_PROPER_CASE.xlsx" AND "CHPIV PROVDIR CONDITIONAL LINE ITEM.png"
		WHERE 1=1 
			AND SPECIALTY IN ('Acupuncture','Chiropractor','Physical Therapy','Occupational Therapist') 

-- =======================================================
	-- UPLOAD ENTRY FOR PROVDIR_VSP
-- =======================================================
INSERT INTO INFORMATICS.dbo.PROVDIR_VSP (ZIP,NPIis,[Participating Network],SPEC,CityIs,[Zip Code],INDEXNM,PROVNM,[Clinic Name],DBA,[Address],CSZ,[Telephone Number],CA_License,[BOARD CERTIFIED],[ACCEPTING NEW PATIENTS],[Office Hour(s)],Accessibility,[Accessibility Category(ies)],FINALlang,FINALhosp_FULL_NAME,UPDATEDT_FOOTNOTE,CHAPTER_COUNT,CHAPTER_NAME,URL_WEBSITE,AFTERHOURS_PHONE,[ACCESS BY PUBLIC TRANSPORTATION],PROVIDER_TYPE,ACCREDITATION,Telehealth_Indicator,COUNTY)
SELECT DISTINCT TRY_CONVERT(nvarchar(5),'91914') AS 'ZIP' -- FORCE LOCK IN ... REQ TO ESTABLISH LICENSE ... DUMMY ZIP
,iso.[RefreshNPI_NO] AS 'NPI'
-- ,ISNULL(NPI_NO,'') AS 'NPI'
,CASE
WHEN [GROUP] LIKE '%CHPIV%Direct%'
THEN 'CHPIV-DSNP'
WHEN [GROUP] LIKE '%Community Care IPA%'
THEN 'CHPIV-IPA-CC'
WHEN [GROUP] LIKE '%Imperial County Physicians Medical Group%'
THEN 'CHPIV-IPA-ICPMG'
WHEN [GROUP] LIKE '%Premier Patient Care IPA%'
THEN 'CHPIV-IPA-PPC'
WHEN [GROUP] LIKE '%Primary%Care%Med%Group%'
THEN 'CHPIV-IPA-PCMG'
ELSE ''
END AS [Participating Network]
-- ,[Participating_Network]
-- ,'CHPIV-IPA-CC' AS 'Participating Network'
,SPECIALTY AS 'SPEC'
,CITY AS 'CityIs'
,TRY_CONVERT(nvarchar(5),ZIPCODE) AS 'Zip Code'
,TRY_CONVERT(nvarchar(25),LNAME)+',  '+TRY_CONVERT(nvarchar(25),FNAME)+', '+TRY_CONVERT(nvarchar(5),TITLE) AS 'INDEXNM'
,TRY_CONVERT(nvarchar(25),LNAME)+',  '+TRY_CONVERT(nvarchar(25),FNAME)+', '+TRY_CONVERT(nvarchar(5),TITLE)+' - ID# '+TRY_CONVERT(nvarchar(25),ISNULL(DIR_ID,'')) AS 'PROVNM'
-- ,TRY_CONVERT(nvarchar(25),LNAME)+',  '+TRY_CONVERT(nvarchar(25),FNAME)+', '+TRY_CONVERT(nvarchar(5),TITLE)+' - ID# '+TRY_CONVERT(nvarchar(25),ISNULL(CAQH,'')) AS 'PROVNM'
,TRY_CONVERT(nvarchar(100),NULL) AS 'Clinic Name' -- ABSENT FROM SOURCE DATA 
-- ,TRY_CONVERT(nvarchar(100),Clinic_Name)AS 'Clinic Name' -- ABSENT FROM SOURCE DATA 
,ISNULL([GROUP],'') AS 'DBA'
-- ,TRY_CONVERT(nvarchar(100),'CHPIV CommunityCare IPA') AS 'DBA'
-- ,TRY_CONVERT(nvarchar(100),ISNULL(PPG_NAME,'')) -- DBA AND OR ASSOCIATION_GROUP
,TRY_CONVERT(nvarchar(100),[Address]) AS 'Address'
,TRY_CONVERT(nvarchar(100),CITY)+', CA '+TRY_CONVERT(nvarchar(5),ZIPCODE) AS 'CSZ'
,TRY_CONVERT(nvarchar(13),PHONE) AS  'Telephone Number'
,LIC_ID AS 'CA_License'
-- ,TRY_CONVERT(nvarchar(100),NULL) AS 'BOARD CERTIFIED' -- Y OR N + (SPECIFIC BOARD IS ABSENT FROM SOURCE DATA)
,CASE
WHEN ISNULL(BOARD_CERT_ID,'N') IN('N')
THEN 'N'
ELSE 'Y ('+ISNULL(BOARD_CERT_ID,'')+')' 
END AS 'BOARD CERTIFIED' -- Y OR N + (SPECIFIC BOARD IS ABSENT FROM SOURCE DATA)
,CASE
WHEN ISNULL(ACCEPT_NEW_PAT,'') LIKE '%Y%'
THEN 'Yes'
ELSE 'No'
END AS 'ACCEPTING NEW PATIENTS'
-- ,ISNULL(ACCEPT_NEW_PAT,'') AS 'ACCEPTING NEW PATIENTS'
-- ,ACCEPT_NEW_PAT AS 'ACCEPTING NEW PATIENTS'
,ISNULL([HOURS],'') AS 'Office Hour(s)'
-- ,TRY_CONVERT(nvarchar(100),NULL) AS 'Accessibility'
,TRY_CONVERT(nvarchar(12),ISNULL(ACCESS_REQ,'')) AS 'Accessibility'
-- ,TRY_CONVERT(nvarchar(255),NULL) AS 'Accessibility (Categories)'
,STUFF(
CASE 
WHEN ISNULL(PARKING_IND,'') != '' 
THEN ', ' + PARKING_IND
ELSE '' 
END
+ CASE 
WHEN ISNULL(EXT_BUILD_IND,'') !='' 
THEN ', ' + EXT_BUILD_IND 
ELSE '' 
END
+ 
CASE 
WHEN ISNULL(INT_BUILD_IND,'') !='' 
THEN ', ' + INT_BUILD_IND 
ELSE '' 
END
+ 
CASE 
WHEN ISNULL(RESTROOM_IND,'') != '' 
THEN ', ' + RESTROOM_IND  
ELSE '' 
END
+ CASE 
WHEN ISNULL(EXAMROOM_IND,'') != '' 
THEN ', ' + EXAMROOM_IND 
ELSE '' 
END
+ 
CASE 
WHEN ISNULL(EXAMTBL_IND,'') != '' 
THEN ', ' + EXAMTBL_IND 
ELSE '' 
END
+ 
CASE 
WHEN ISNULL(PATIENT_AREA_IND,'') !='' 
THEN ', ' + PATIENT_AREA_IND 
ELSE '' 
END
+ 
CASE 
WHEN ISNULL(PATIENT_DIA_IND,'') != '' 
THEN ', ' + PATIENT_DIA_IND 
ELSE '' 
END,1,2,'') AS 'Accessibility (Categories)'
/* ,STUFF(
CASE 
WHEN ISNULL(Parking_Availabilty,'') != '' 
THEN ', ' + Parking_Availabilty
ELSE '' 
END
+ CASE 
WHEN ISNULL(Ext_Building,'') !='' 
THEN ', ' + Ext_Building 
ELSE '' 
END
+ 
CASE 
WHEN ISNULL(Int_Building,'') !='' 
THEN ', ' + Int_Building 
ELSE '' 
END
+ 
CASE 
WHEN ISNULL(Restroom,'') != '' 
THEN ', ' + Restroom  
ELSE '' 
END
+ CASE 
WHEN ISNULL(Exam_room,'') != '' 
THEN ', ' + Exam_room 
ELSE '' 
END
+ 
CASE 
WHEN ISNULL(Exam_Taable,'') != '' 
THEN ', ' + Exam_Taable 
ELSE '' 
END
+ 
CASE 
WHEN ISNULL(Patient_Area,'') !='' 
THEN ', ' + Patient_Area 
ELSE '' 
END
+ 
CASE 
WHEN ISNULL(Exam_Room_Disabilities,'') != '' 
THEN ', ' + Exam_Room_Disabilities 
ELSE '' 
END,1,2,'') AS 'Accessibility (Categories)' */
,STUFF(
CASE 
WHEN ISNULL(PHY_LANG01_PRV_LANG01,'') != '' 
THEN ', ' + PHY_LANG01_PRV_LANG01
ELSE '' 
END
+ CASE 
WHEN ISNULL(PHY_LANG02_PRV_LANG02,'') !='' 
THEN ', ' + PHY_LANG02_PRV_LANG02 
ELSE '' 
END
+ 
CASE 
WHEN ISNULL(PHY_LANG03_PRV_LANG03,'') !='' 
THEN ', ' + PHY_LANG03_PRV_LANG03 
ELSE '' 
END
+ 
CASE 
WHEN ISNULL(PHY_LANG04_PRV_LANG04,'') != '' 
THEN ', ' + PHY_LANG04_PRV_LANG04  
ELSE '' 
END
+ 
CASE 
WHEN ISNULL(PHY_LANG05_PRV_LANG05,'') != '' 
THEN ', ' + PHY_LANG05_PRV_LANG05 
ELSE '' 
END,1,2,'') AS 'FINALlang'
-- ,TRY_CONVERT(nvarchar(255),NULL) AS 'FINALlang'
-- ,Provider_Language AS 'FINALlang' 
,HOSP_NAME AS 'FINALhosp_FULL_NAME'
-- ,HospitalAmittingPriv AS 'FINALhosp_FULL_NAME'
,TRY_CONVERT(nvarchar(100),NULL) AS 'UPDATEDT_FOOTNOTE,' -- UPDATE() IN THE POST
,TRY_CONVERT(nvarchar(100),NULL) AS 'CHAPTER_COUNT' -- UPDATE() IN THE POST
,ca.CHAPTER_NAME
-- ,'Primary Care Physician' AS 'CHAPTER_NAME'
,ISNULL(WEBSITE,'') AS 'URL_WEBSITE'
-- ,TRY_CONVERT(nvarchar(100),NULL) AS 'URL_WEBSITE'
,TRY_CONVERT(nvarchar(10),' ') AS 'AFTERHOURS_PHONE' 
-- ,ISNULL(After_Hours_Phone,'') AS 'AFTERHOURS_PHONE' 
,'Yes' AS [ACCESS BY PUBLIC TRANSPORTATION] -- DEFAULT VAL() AS NULL(S) NOT ACCEPTED
,ca.PROVIDER_TYPE
-- ,'Primary Care' AS 'PROVIDER_TYPE'-- DEFAULT VAL() AS NULL(S) NOT ACCEPTED
,'Yes' AS ACCREDITATION -- DEFAULT VAL() AS NULL(S) NOT ACCEPTED
,[Telehealth_Indicator] -- C001: APPLICABLE TO PROVIDERS ONLY!!! ADD - ON PER EMAIL FROM MS JOHANNA BASED UPON DHCS FINDING (LEVERAGE: APL 25-014 AND OR "PROVDIR Telehealth Indicator evips location .msg")
,[COUNTY] 
-- SELECT TOP 10 ' ' AS 'CHECK 1st',* 
-- SELECT DISTINCT ' ' AS 'CHECK 1st',PCP_SPC,TITLE
FROM INFORMATICS.dbo.CHPIV_PROVIDER_DIRECTORY_DATA AS chpiv -- LEVERAGE: "CHPIV Provider Directory Data to CHG 9_18_25_PROPER_CASE.xlsx" AND "CHPIV PROVDIR CONDITIONAL LINE ITEM.png" AND "CHPIV Provider Directory Data to CHG 12_08_25.xlsx"  AND ...
CROSS APPLY (  -- INDEPENDENT STAND ALONE ... CROSS APPLY() CROSS JOIN() CARTESIAN PRODUCT
SELECT TOP 1 CHAPTER_NAME
,PROVIDER_TYPE 
FROM INFORMATICS.dbo.PROVDIR_VSP
) -- CONCLUDE ...
AS ca
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
	AND NOT [GROUP] LIKE '%CHPIV%Direct%' -- NO NOT NEGATIVE <> != ... -- C003: PULL CHPIV DIRECT PROVIDER(S) AND OR ENTITY(-IES) EXCLUSIVELY FROM eVIPS
	AND SPECIALTY LIKE '%Optometry%'

		SELECT ' ' AS 'CONFIRM PRESENCE OF AT LEAST ONE 1 "CHPIV" RECORD',*
		FROM INFORMATICS.dbo.PROVDIR_VSP 
		WHERE 1=1 
			AND [Participating Network] LIKE '%CHPIV%'

SELECT ' ' AS '#PYTHON UPLOAD OF ... : ',*
FROM INFORMATICS.dbo.CHPIV_PROVIDER_DIRECTORY_DATA -- LEVERAGE: "CHPIV Provider Directory Data to CHG 9_18_25_PROPER_CASE.xlsx" AND "CHPIV PROVDIR CONDITIONAL LINE ITEM.png"
WHERE 1=1 
	AND SPECIALTY LIKE '%Optometry%'
		
		SELECT DISTINCT SECTION_NO
		,[GROUP]
		SPECIALTY
		,CASE
		WHEN [GROUP] LIKE '%CHPIV%Direct%'
		THEN 'CHPIV-DSNP'
		WHEN [GROUP] LIKE '%Community Care IPA%'
		THEN 'CHPIV-IPA-CC'
		WHEN [GROUP] LIKE '%Imperial County Physicians Medical Group%'
		THEN 'CHPIV-IPA-ICPMG'
		WHEN [GROUP] LIKE '%Premier Patient Care IPA%'
		THEN 'CHPIV-IPA-PPC'
		WHEN [GROUP] LIKE '%Primary%Care%Med%Group%'
		THEN 'CHPIV-IPA-PCMG'
		ELSE ''
		END AS [Participating Network]
		FROM INFORMATICS.dbo.CHPIV_PROVIDER_DIRECTORY_DATA -- LEVERAGE: "CHPIV Provider Directory Data to CHG 9_18_25_PROPER_CASE.xlsx" AND "CHPIV PROVDIR CONDITIONAL LINE ITEM.png"
		WHERE 1=1 
			AND SPECIALTY LIKE '%Optometry%'

-- =======================================================
	-- FORCED ENTRY FOR PROVDIR_HOSGENERALACUTE
-- =======================================================
INSERT INTO INFORMATICS.dbo.PROVDIR_HOSGENERALACUTE (ZIP,NPIis,[Participating Network],SPEC,CityIs,[Zip Code],INDEXNM,PROVNM,[Clinic Name],DBA,[Address],CSZ,[Telephone Number],CA_License,[ACCEPTING NEW PATIENTS],[Office Hour(s)],Accessibility,[Accessibility Category(ies)],FINALlang,UPDATEDT_FOOTNOTE,CHAPTER_COUNT,CHAPTER_NAME,URL_WEBSITE,AFTERHOURS_PHONE,[ACCESS BY PUBLIC TRANSPORTATION],PROVIDER_TYPE,ACCREDITATION,TESTING,[BOARD CERTIFIED])
SELECT DISTINCT TRY_CONVERT(nvarchar(5),'91914') AS 'ZIP' -- FORCE LOCK IN ... REQ TO ESTABLISH LICENSE ... DUMMY ZIP
,iso.[RefreshNPI_NO] AS 'NPI'
-- ,ISNULL(NPI_NO,'') AS 'NPI'
,CASE
WHEN [GROUP] LIKE '%CHPIV%Direct%'
THEN 'CHPIV-DSNP'
WHEN [GROUP] LIKE '%Community Care IPA%'
THEN 'CHPIV-IPA-CC'
WHEN [GROUP] LIKE '%Imperial County Physicians Medical Group%'
THEN 'CHPIV-IPA-ICPMG'
WHEN [GROUP] LIKE '%Premier Patient Care IPA%'
THEN 'CHPIV-IPA-PPC'
WHEN [GROUP] LIKE '%Primary%Care%Med%Group%'
THEN 'CHPIV-IPA-PCMG'
ELSE ''
END AS [Participating Network]
-- ,LTRIM(RTRIM(ISNULL([Participating_Network],''))) AS 'Participating Network' -- C005: IDENTIFY CHPIV PER MEETING WITH() MS JOHANNA AND MS SANDRA ON 20250219 ... see "Copy of CHPIV_Rosters_Consolidated.xlsx"
-- ,'CHPIV-DSNP' AS 'Participating Network' -- C005: IDENTIFY CHPIV PER MEETING WITH() MS JOHANNA AND MS SANDRA ON 20250219 ... see "Copy of CHPIV_Rosters_Consolidated.xlsx"
,TRY_CONVERT(nvarchar(11),SPECIALTY) AS 'SPEC'
-- ,' Hospitals ' AS 'SPEC'
,CITY AS 'CityIs'
,TRY_CONVERT(nvarchar(5),ZIPCODE) AS 'Zip Code'
,TRY_CONVERT(nvarchar(100),LNAME) AS 'INDEXNM'
,TRY_CONVERT(nvarchar(100),LNAME)+' - ID# '+TRY_CONVERT(nvarchar(25),ISNULL(PHY_ID,'')) AS 'PROVNM'
,TRY_CONVERT(nvarchar(100),LNAME) AS 'Clinic Name' -- ABSENT FROM SOURCE DATA 
,TRY_CONVERT(nvarchar(100),ISNULL([GROUP],'')) AS 'DBA'
,TRY_CONVERT(nvarchar(100),[Address]) AS 'Address'
,TRY_CONVERT(nvarchar(100),CITY)+', CA '+TRY_CONVERT(nvarchar(5),ZIPCODE) AS 'CSZ'
,TRY_CONVERT(nvarchar(13),PHONE) AS  'Telephone Number'
,ISNULL(LIC_ID,'') AS 'CA_License'
,CASE
WHEN ISNULL(ACCEPT_NEW_PAT,'') LIKE '%Y%'
THEN 'Yes'
ELSE 'No'
END AS 'ACCEPTING NEW PATIENTS'
-- ,ISNULL(ACCEPT_NEW_PAT,'') AS 'ACCEPTING NEW PATIENTS'
-- ,'Yes' AS 'ACCEPTING NEW PATIENTS'
,ISNULL([HOURS],'') AS 'Office Hour(s)'
-- ,ISNULL([Hours],'') AS 'Office Hour(s)'
-- ,'7 Days a Week, 24 Hours a Day' AS 'Office Hour(s)'
,TRY_CONVERT(nvarchar(12),ISNULL(ACCESS_REQ,'')) AS 'Accessibility'
-- ,TRY_CONVERT(nvarchar(255),NULL) AS 'Accessibility (Categories)'
,TRY_CONVERT(nvarchar(15),STUFF(
CASE 
WHEN ISNULL(PARKING_IND,'') != '' 
THEN ', ' + PARKING_IND
ELSE '' 
END
+ CASE 
WHEN ISNULL(EXT_BUILD_IND,'') !='' 
THEN ', ' + EXT_BUILD_IND 
ELSE '' 
END
+ 
CASE 
WHEN ISNULL(INT_BUILD_IND,'') !='' 
THEN ', ' + INT_BUILD_IND 
ELSE '' 
END
+ 
CASE 
WHEN ISNULL(RESTROOM_IND,'') != '' 
THEN ', ' + RESTROOM_IND  
ELSE '' 
END
+ CASE 
WHEN ISNULL(EXAMROOM_IND,'') != '' 
THEN ', ' + EXAMROOM_IND 
ELSE '' 
END
+ 
CASE 
WHEN ISNULL(EXAMTBL_IND,'') != '' 
THEN ', ' + EXAMTBL_IND 
ELSE '' 
END
+ 
CASE 
WHEN ISNULL(PATIENT_AREA_IND,'') !='' 
THEN ', ' + PATIENT_AREA_IND 
ELSE '' 
END
+ 
CASE 
WHEN ISNULL(PATIENT_DIA_IND,'') != '' 
THEN ', ' + PATIENT_DIA_IND 
ELSE '' 
END,1,2,'')) AS 'Accessibility (Categories)'
,STUFF(
CASE 
WHEN ISNULL(PHY_LANG01_PRV_LANG01,'') != '' 
THEN ', ' + PHY_LANG01_PRV_LANG01
ELSE '' 
END
+ CASE 
WHEN ISNULL(PHY_LANG02_PRV_LANG02,'') !='' 
THEN ', ' + PHY_LANG02_PRV_LANG02 
ELSE '' 
END
+ 
CASE 
WHEN ISNULL(PHY_LANG03_PRV_LANG03,'') !='' 
THEN ', ' + PHY_LANG03_PRV_LANG03 
ELSE '' 
END
+ 
CASE 
WHEN ISNULL(PHY_LANG04_PRV_LANG04,'') != '' 
THEN ', ' + PHY_LANG04_PRV_LANG04  
ELSE '' 
END
+ 
CASE 
WHEN ISNULL(PHY_LANG05_PRV_LANG05,'') != '' 
THEN ', ' + PHY_LANG05_PRV_LANG05 
ELSE '' 
END,1,2,'') AS 'FINALlang'
,TRY_CONVERT(nvarchar(100),NULL) AS 'UPDATEDT_FOOTNOTE,' -- UPDATE() IN THE POST
,TRY_CONVERT(nvarchar(100),NULL) AS 'CHAPTER_COUNT' -- UPDATE() IN THE POST
,ca.CHAPTER_NAME
-- ,'General Acute Hospitals' AS 'CHAPTER_NAME'
,ISNULL(WEBSITE,'') AS 'URL_WEBSITE'
,TRY_CONVERT(nvarchar(13),ISNULL(AFTERHOUR_PHONE,'')) AS  'AFTERHOURS_PHONE'
,'Yes' AS [ACCESS BY PUBLIC TRANSPORTATION] -- DEFAULT VAL() AS NULL(S) NOT ACCEPTED
,TRY_CONVERT(nvarchar(22),ca.PROVIDER_TYPE) AS 'PROVIDER_TYPE'
-- ,'GENERAL ACUTE HOSPITAL' AS 'PROVIDER_TYPE'-- DEFAULT VAL() AS NULL(S) NOT ACCEPTED
,'Yes' AS ACCREDITATION -- DEFAULT VAL() AS NULL(S) NOT ACCEPTED
,TRY_CONVERT(nvarchar(100),LNAME)+' - ID# '+TRY_CONVERT(nvarchar(25),ISNULL(PHY_ID,'')) AS 'TESTING'
,CASE
WHEN ISNULL(BOARD_CERT_ID,'N') IN('N')
THEN 'N'
ELSE 'Y ('+ISNULL(BOARD_CERT_ID,'')+')' 
END AS 'BOARD CERTIFIED' -- Y OR N + (SPECIFIC BOARD IS ABSENT FROM SOURCE DATA)
-- ,ISNULL(BOARD_CERT_ID,'') AS 'BOARD CERTIFIED' -- SPECIFIC BOARD IS ABSENT FROM SOURCE DATA
-- SELECT TOP 10 ' ' AS 'CHECK 1st',* 
-- SELECT DISTINCT ' ' AS 'CHECK 1st',
FROM INFORMATICS.dbo.CHPIV_PROVIDER_DIRECTORY_DATA AS chpiv -- LEVERAGE: "CHPIV Provider Directory Data to CHG 9_18_25_PROPER_CASE.xlsx" AND "CHPIV PROVDIR CONDITIONAL LINE ITEM.png" AND "CHPIV Provider Directory Data to CHG 12_08_25.xlsx"  AND ...
CROSS APPLY (  -- INDEPENDENT STAND ALONE ... CROSS APPLY() CROSS JOIN() CARTESIAN PRODUCT
SELECT TOP 1 CHAPTER_NAME
,PROVIDER_TYPE 
FROM INFORMATICS.dbo.PROVDIR_HOSGENERALACUTE
) -- CONCLUDE ...
AS ca
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
	AND [GROUP] LIKE '%CHPIV%Direct%' -- C005: AD HOC MANUAL ADD-ON — FORCE 2 HOSPITAL RECORDS into CHPIV_PROVIDER_DIRECTORY_DATA see  "FORCE CHPIV HOSPITALS Provider Directory Data to CHG 12_08_25.xlsx" -> worksheet "2 HOSPITALS" (2 rows)
	AND ISNULL(SPECIALTY,'') LIKE '%Hospital%'
	AND ISNULL(FNAME,'') = '' -- FACILITIES

-- =======================================================
	-- UPLOAD ENTRY FOR PROVDIR_HOSGENERALACUTE
-- =======================================================
INSERT INTO INFORMATICS.dbo.PROVDIR_HOSGENERALACUTE (ZIP,NPIis,[Participating Network],SPEC,CityIs,[Zip Code],INDEXNM,PROVNM,[Clinic Name],DBA,[Address],CSZ,[Telephone Number],CA_License,[ACCEPTING NEW PATIENTS],[Office Hour(s)],Accessibility,[Accessibility Category(ies)],FINALlang,UPDATEDT_FOOTNOTE,CHAPTER_COUNT,CHAPTER_NAME,URL_WEBSITE,AFTERHOURS_PHONE,[ACCESS BY PUBLIC TRANSPORTATION],PROVIDER_TYPE,ACCREDITATION,TESTING,[BOARD CERTIFIED])
SELECT DISTINCT TRY_CONVERT(nvarchar(5),'91914') AS 'ZIP' -- FORCE LOCK IN ... REQ TO ESTABLISH LICENSE ... DUMMY ZIP
,iso.[RefreshNPI_NO] AS 'NPI'
-- ,ISNULL(NPI_NO,'') AS 'NPI'
,CASE
WHEN [GROUP] LIKE '%CHPIV%Direct%'
THEN 'CHPIV-DSNP'
WHEN [GROUP] LIKE '%Community Care IPA%'
THEN 'CHPIV-IPA-CC'
WHEN [GROUP] LIKE '%Imperial County Physicians Medical Group%'
THEN 'CHPIV-IPA-ICPMG'
WHEN [GROUP] LIKE '%Premier Patient Care IPA%'
THEN 'CHPIV-IPA-PPC'
WHEN [GROUP] LIKE '%Primary%Care%Med%Group%'
THEN 'CHPIV-IPA-PCMG'
ELSE ''
END AS [Participating Network]
-- ,LTRIM(RTRIM(ISNULL([Participating_Network],''))) AS 'Participating Network' -- C005: IDENTIFY CHPIV PER MEETING WITH() MS JOHANNA AND MS SANDRA ON 20250219 ... see "Copy of CHPIV_Rosters_Consolidated.xlsx"
-- ,'CHPIV-DSNP' AS 'Participating Network' -- C005: IDENTIFY CHPIV PER MEETING WITH() MS JOHANNA AND MS SANDRA ON 20250219 ... see "Copy of CHPIV_Rosters_Consolidated.xlsx"
,TRY_CONVERT(nvarchar(11),SPECIALTY) AS 'SPEC'
-- ,' Hospitals ' AS 'SPEC'
,CITY AS 'CityIs'
,TRY_CONVERT(nvarchar(5),ZIPCODE) AS 'Zip Code'
,TRY_CONVERT(nvarchar(100),LNAME) AS 'INDEXNM'
,TRY_CONVERT(nvarchar(100),LNAME)+' - ID# '+TRY_CONVERT(nvarchar(25),ISNULL(PHY_ID,'')) AS 'PROVNM'
,TRY_CONVERT(nvarchar(100),LNAME) AS 'Clinic Name' -- ABSENT FROM SOURCE DATA 
,TRY_CONVERT(nvarchar(100),ISNULL([GROUP],'')) AS 'DBA'
,TRY_CONVERT(nvarchar(100),[Address]) AS 'Address'
,TRY_CONVERT(nvarchar(100),CITY)+', CA '+TRY_CONVERT(nvarchar(5),ZIPCODE) AS 'CSZ'
,TRY_CONVERT(nvarchar(13),PHONE) AS  'Telephone Number'
,ISNULL(LIC_ID,'') AS 'CA_License'
,CASE
WHEN ISNULL(ACCEPT_NEW_PAT,'') LIKE '%Y%'
THEN 'Yes'
ELSE 'No'
END AS 'ACCEPTING NEW PATIENTS'
-- ,ISNULL(ACCEPT_NEW_PAT,'') AS 'ACCEPTING NEW PATIENTS'
-- ,'Yes' AS 'ACCEPTING NEW PATIENTS'
,ISNULL([HOURS],'') AS 'Office Hour(s)'
-- ,ISNULL([Hours],'') AS 'Office Hour(s)'
-- ,'7 Days a Week, 24 Hours a Day' AS 'Office Hour(s)'
,TRY_CONVERT(nvarchar(12),ISNULL(ACCESS_REQ,'')) AS 'Accessibility'
-- ,TRY_CONVERT(nvarchar(255),NULL) AS 'Accessibility (Categories)'
,TRY_CONVERT(nvarchar(15),STUFF(
CASE 
WHEN ISNULL(PARKING_IND,'') != '' 
THEN ', ' + PARKING_IND
ELSE '' 
END
+ CASE 
WHEN ISNULL(EXT_BUILD_IND,'') !='' 
THEN ', ' + EXT_BUILD_IND 
ELSE '' 
END
+ 
CASE 
WHEN ISNULL(INT_BUILD_IND,'') !='' 
THEN ', ' + INT_BUILD_IND 
ELSE '' 
END
+ 
CASE 
WHEN ISNULL(RESTROOM_IND,'') != '' 
THEN ', ' + RESTROOM_IND  
ELSE '' 
END
+ CASE 
WHEN ISNULL(EXAMROOM_IND,'') != '' 
THEN ', ' + EXAMROOM_IND 
ELSE '' 
END
+ 
CASE 
WHEN ISNULL(EXAMTBL_IND,'') != '' 
THEN ', ' + EXAMTBL_IND 
ELSE '' 
END
+ 
CASE 
WHEN ISNULL(PATIENT_AREA_IND,'') !='' 
THEN ', ' + PATIENT_AREA_IND 
ELSE '' 
END
+ 
CASE 
WHEN ISNULL(PATIENT_DIA_IND,'') != '' 
THEN ', ' + PATIENT_DIA_IND 
ELSE '' 
END,1,2,'')) AS 'Accessibility (Categories)'
,STUFF(
CASE 
WHEN ISNULL(PHY_LANG01_PRV_LANG01,'') != '' 
THEN ', ' + PHY_LANG01_PRV_LANG01
ELSE '' 
END
+ CASE 
WHEN ISNULL(PHY_LANG02_PRV_LANG02,'') !='' 
THEN ', ' + PHY_LANG02_PRV_LANG02 
ELSE '' 
END
+ 
CASE 
WHEN ISNULL(PHY_LANG03_PRV_LANG03,'') !='' 
THEN ', ' + PHY_LANG03_PRV_LANG03 
ELSE '' 
END
+ 
CASE 
WHEN ISNULL(PHY_LANG04_PRV_LANG04,'') != '' 
THEN ', ' + PHY_LANG04_PRV_LANG04  
ELSE '' 
END
+ 
CASE 
WHEN ISNULL(PHY_LANG05_PRV_LANG05,'') != '' 
THEN ', ' + PHY_LANG05_PRV_LANG05 
ELSE '' 
END,1,2,'') AS 'FINALlang'
,TRY_CONVERT(nvarchar(100),NULL) AS 'UPDATEDT_FOOTNOTE,' -- UPDATE() IN THE POST
,TRY_CONVERT(nvarchar(100),NULL) AS 'CHAPTER_COUNT' -- UPDATE() IN THE POST
,ca.CHAPTER_NAME
-- ,'General Acute Hospitals' AS 'CHAPTER_NAME'
,ISNULL(WEBSITE,'') AS 'URL_WEBSITE'
,TRY_CONVERT(nvarchar(13),ISNULL(AFTERHOUR_PHONE,'')) AS  'AFTERHOURS_PHONE'
,'Yes' AS [ACCESS BY PUBLIC TRANSPORTATION] -- DEFAULT VAL() AS NULL(S) NOT ACCEPTED
,TRY_CONVERT(nvarchar(22),ca.PROVIDER_TYPE) AS 'PROVIDER_TYPE'
-- ,'GENERAL ACUTE HOSPITAL' AS 'PROVIDER_TYPE'-- DEFAULT VAL() AS NULL(S) NOT ACCEPTED
,'Yes' AS ACCREDITATION -- DEFAULT VAL() AS NULL(S) NOT ACCEPTED
,TRY_CONVERT(nvarchar(100),LNAME)+' - ID# '+TRY_CONVERT(nvarchar(25),ISNULL(PHY_ID,'')) AS 'TESTING'
,CASE
WHEN ISNULL(BOARD_CERT_ID,'N') IN('N')
THEN 'N'
ELSE 'Y ('+ISNULL(BOARD_CERT_ID,'')+')' 
END AS 'BOARD CERTIFIED' -- Y OR N + (SPECIFIC BOARD IS ABSENT FROM SOURCE DATA)
-- ,ISNULL(BOARD_CERT_ID,'') AS 'BOARD CERTIFIED' -- SPECIFIC BOARD IS ABSENT FROM SOURCE DATA
-- SELECT TOP 10 ' ' AS 'CHECK 1st',* 
-- SELECT DISTINCT ' ' AS 'CHECK 1st',
FROM INFORMATICS.dbo.CHPIV_PROVIDER_DIRECTORY_DATA AS chpiv -- LEVERAGE: "CHPIV Provider Directory Data to CHG 9_18_25_PROPER_CASE.xlsx" AND "CHPIV PROVDIR CONDITIONAL LINE ITEM.png" AND "CHPIV Provider Directory Data to CHG 12_08_25.xlsx"  AND ...
CROSS APPLY (  -- INDEPENDENT STAND ALONE ... CROSS APPLY() CROSS JOIN() CARTESIAN PRODUCT
SELECT TOP 1 CHAPTER_NAME
,PROVIDER_TYPE 
FROM INFORMATICS.dbo.PROVDIR_HOSGENERALACUTE
) -- CONCLUDE ...
AS ca
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
	AND NOT [GROUP] LIKE '%CHPIV%Direct%' -- NO NOT NEGATIVE <> != ... -- C003: PULL CHPIV DIRECT PROVIDER(S) AND OR ENTITY(-IES) EXCLUSIVELY FROM eVIPS
	AND ISNULL(SPECIALTY,'') LIKE '%Hospital%'
	AND ISNULL(FNAME,'') = '' -- FACILITIES

		SELECT ' ' AS 'CONFIRM PRESENCE OF AT LEAST ONE 1 "CHPIV" RECORD',*
		FROM INFORMATICS.dbo.PROVDIR_HOSGENERALACUTE 
		WHERE 1=1 
			AND [Participating Network] LIKE '%CHPIV%'

SELECT ' ' AS '#PYTHON UPLOAD OF ... : ',*
FROM INFORMATICS.dbo.CHPIV_PROVIDER_DIRECTORY_DATA -- LEVERAGE: "CHPIV Provider Directory Data to CHG 9_18_25_PROPER_CASE.xlsx" AND "CHPIV PROVDIR CONDITIONAL LINE ITEM.png"
WHERE 1=1 
	AND ISNULL(SPECIALTY,'') LIKE '%Hospital%'
	AND ISNULL(FNAME,'') = '' -- FACILITIES
		
		SELECT DISTINCT SECTION_NO
		,[GROUP]
		SPECIALTY
		,CASE
		WHEN [GROUP] LIKE '%CHPIV%Direct%'
		THEN 'CHPIV-DSNP'
		WHEN [GROUP] LIKE '%Community Care IPA%'
		THEN 'CHPIV-IPA-CC'
		WHEN [GROUP] LIKE '%Imperial County Physicians Medical Group%'
		THEN 'CHPIV-IPA-ICPMG'
		WHEN [GROUP] LIKE '%Premier Patient Care IPA%'
		THEN 'CHPIV-IPA-PPC'
		WHEN [GROUP] LIKE '%Primary%Care%Med%Group%'
		THEN 'CHPIV-IPA-PCMG'
		ELSE ''
		END AS [Participating Network]
		FROM INFORMATICS.dbo.CHPIV_PROVIDER_DIRECTORY_DATA -- LEVERAGE: "CHPIV Provider Directory Data to CHG 9_18_25_PROPER_CASE.xlsx" AND "CHPIV PROVDIR CONDITIONAL LINE ITEM.png"
		WHERE 1=1 
			AND SPECIALTY LIKE '%Hospital%'
			AND ISNULL(FNAME,'') = '' -- FACILITIESAND ISNULL(FNAME,'') = ''

-- =======================================================
	-- UPLOAD ENTRY FOR PROVDIR_HOSMH
-- =======================================================
INSERT INTO INFORMATICS.dbo.PROVDIR_HOSMH (ZIP,NPIis,[Participating Network],SPEC,CityIs,[Zip Code],INDEXNM,PROVNM,[Clinic Name],DBA,[Address],CSZ,[Telephone Number],CA_License,[ACCEPTING NEW PATIENTS],[Office Hour(s)],Accessibility,[Accessibility Category(ies)],FINALlang,UPDATEDT_FOOTNOTE,CHAPTER_COUNT,CHAPTER_NAME,URL_WEBSITE,AFTERHOURS_PHONE,[ACCESS BY PUBLIC TRANSPORTATION],PROVIDER_TYPE,ACCREDITATION,TESTING,[BOARD CERTIFIED])
SELECT DISTINCT TRY_CONVERT(nvarchar(5),'91914') AS 'ZIP' -- FORCE LOCK IN ... REQ TO ESTABLISH LICENSE ... DUMMY ZIP
,iso.[RefreshNPI_NO] AS 'NPI'
-- ,ISNULL(NPI_NO,'') AS 'NPI'
,CASE
WHEN [GROUP] LIKE '%CHPIV%Direct%'
THEN 'CHPIV-DSNP'
WHEN [GROUP] LIKE '%Community Care IPA%'
THEN 'CHPIV-IPA-CC'
WHEN [GROUP] LIKE '%Imperial County Physicians Medical Group%'
THEN 'CHPIV-IPA-ICPMG'
WHEN [GROUP] LIKE '%Premier Patient Care IPA%'
THEN 'CHPIV-IPA-PPC'
WHEN [GROUP] LIKE '%Primary%Care%Med%Group%'
THEN 'CHPIV-IPA-PCMG'
ELSE ''
END AS [Participating Network]
-- ,LTRIM(RTRIM(ISNULL([Participating_Network],''))) AS 'Participating Network' -- C005: IDENTIFY CHPIV PER MEETING WITH() MS JOHANNA AND MS SANDRA ON 20250219 ... see "Copy of CHPIV_Rosters_Consolidated.xlsx"
-- ,'CHPIV-DSNP' AS 'Participating Network' -- C005: IDENTIFY CHPIV PER MEETING WITH() MS JOHANNA AND MS SANDRA ON 20250219 ... see "Copy of CHPIV_Rosters_Consolidated.xlsx"
,TRY_CONVERT(nvarchar(11),SPECIALTY) AS 'SPEC'
-- ,' Hospitals ' AS 'SPEC'
,CITY AS 'CityIs'
,TRY_CONVERT(nvarchar(5),ZIPCODE) AS 'Zip Code'
,LNAME AS 'INDEXNM'
,TRY_CONVERT(nvarchar(100),LNAME)+' - ID# '+TRY_CONVERT(nvarchar(25),ISNULL(PHY_ID,'')) AS 'PROVNM'
,TRY_CONVERT(nvarchar(100),LNAME) AS 'Clinic Name' -- ABSENT FROM SOURCE DATA 
,TRY_CONVERT(nvarchar(100),ISNULL([GROUP],'')) AS 'DBA'
,TRY_CONVERT(nvarchar(100),[Address]) AS 'Address'
,TRY_CONVERT(nvarchar(100),CITY)+', CA '+TRY_CONVERT(nvarchar(5),ZIPCODE) AS 'CSZ'
,TRY_CONVERT(nvarchar(13),PHONE) AS  'Telephone Number'
,ISNULL(LIC_ID,'') AS 'CA_License'
,CASE
WHEN ISNULL(ACCEPT_NEW_PAT,'') LIKE '%Y%'
THEN 'Yes'
ELSE 'No'
END AS 'ACCEPTING NEW PATIENTS'
-- ,ISNULL(ACCEPT_NEW_PAT,'') AS 'ACCEPTING NEW PATIENTS'
-- ,'Yes' AS 'ACCEPTING NEW PATIENTS'
,ISNULL([HOURS],'') AS 'Office Hour(s)'
-- ,'7 Days a Week, 24 Hours a Day' AS 'Office Hour(s)'
,TRY_CONVERT(nvarchar(12),ISNULL(ACCESS_REQ,'')) AS 'Accessibility'
-- ,TRY_CONVERT(nvarchar(255),NULL) AS 'Accessibility (Categories)'
,TRY_CONVERT(nvarchar(15),STUFF(
CASE 
WHEN ISNULL(PARKING_IND,'') != '' 
THEN ', ' + PARKING_IND
ELSE '' 
END
+ CASE 
WHEN ISNULL(EXT_BUILD_IND,'') !='' 
THEN ', ' + EXT_BUILD_IND 
ELSE '' 
END
+ 
CASE 
WHEN ISNULL(INT_BUILD_IND,'') !='' 
THEN ', ' + INT_BUILD_IND 
ELSE '' 
END
+ 
CASE 
WHEN ISNULL(RESTROOM_IND,'') != '' 
THEN ', ' + RESTROOM_IND  
ELSE '' 
END
+ CASE 
WHEN ISNULL(EXAMROOM_IND,'') != '' 
THEN ', ' + EXAMROOM_IND 
ELSE '' 
END
+ 
CASE 
WHEN ISNULL(EXAMTBL_IND,'') != '' 
THEN ', ' + EXAMTBL_IND 
ELSE '' 
END
+ 
CASE 
WHEN ISNULL(PATIENT_AREA_IND,'') !='' 
THEN ', ' + PATIENT_AREA_IND 
ELSE '' 
END
+ 
CASE 
WHEN ISNULL(PATIENT_DIA_IND,'') != '' 
THEN ', ' + PATIENT_DIA_IND 
ELSE '' 
END,1,2,'')) AS 'Accessibility (Categories)'
,STUFF(
CASE 
WHEN ISNULL(PHY_LANG01_PRV_LANG01,'') != '' 
THEN ', ' + PHY_LANG01_PRV_LANG01
ELSE '' 
END
+ CASE 
WHEN ISNULL(PHY_LANG02_PRV_LANG02,'') !='' 
THEN ', ' + PHY_LANG02_PRV_LANG02 
ELSE '' 
END
+ 
CASE 
WHEN ISNULL(PHY_LANG03_PRV_LANG03,'') !='' 
THEN ', ' + PHY_LANG03_PRV_LANG03 
ELSE '' 
END
+ 
CASE 
WHEN ISNULL(PHY_LANG04_PRV_LANG04,'') != '' 
THEN ', ' + PHY_LANG04_PRV_LANG04  
ELSE '' 
END
+ 
CASE 
WHEN ISNULL(PHY_LANG05_PRV_LANG05,'') != '' 
THEN ', ' + PHY_LANG05_PRV_LANG05 
ELSE '' 
END,1,2,'') AS 'FINALlang'
,TRY_CONVERT(nvarchar(100),NULL) AS 'UPDATEDT_FOOTNOTE,' -- UPDATE() IN THE POST
,TRY_CONVERT(nvarchar(100),NULL) AS 'CHAPTER_COUNT' -- UPDATE() IN THE POST
,ca.CHAPTER_NAME
-- ,'Mental Health Hospitals' AS 'CHAPTER_NAME'
,ISNULL(WEBSITE,'') AS 'URL_WEBSITE'
,TRY_CONVERT(nvarchar(13),ISNULL(AFTERHOUR_PHONE,'')) AS  'AFTERHOURS_PHONE'
,'Yes' AS [ACCESS BY PUBLIC TRANSPORTATION] -- DEFAULT VAL() AS NULL(S) NOT ACCEPTED
,TRY_CONVERT(nvarchar(22),ca.PROVIDER_TYPE) AS 'PROVIDER_TYPE'
-- ,'Mental Health Hospital' AS 'PROVIDER_TYPE'-- DEFAULT VAL() AS NULL(S) NOT ACCEPTED
,'Yes' AS ACCREDITATION -- DEFAULT VAL() AS NULL(S) NOT ACCEPTED
,TRY_CONVERT(nvarchar(100),LNAME)+' - ID# '+TRY_CONVERT(nvarchar(25),ISNULL(PHY_ID,'')) AS 'TESTING'
,CASE
WHEN ISNULL(BOARD_CERT_ID,'N') IN('N')
THEN 'N'
ELSE 'Y ('+ISNULL(BOARD_CERT_ID,'')+')' 
END AS 'BOARD CERTIFIED' -- Y OR N + (SPECIFIC BOARD IS ABSENT FROM SOURCE DATA)
-- ,ISNULL(BOARD_CERT_ID,'') AS 'BOARD CERTIFIED' -- SPECIFIC BOARD IS ABSENT FROM SOURCE DATA
-- SELECT TOP 10 ' ' AS 'CHECK 1st',* 
-- SELECT DISTINCT ' ' AS 'CHECK 1st',
FROM INFORMATICS.dbo.CHPIV_PROVIDER_DIRECTORY_DATA AS chpiv -- LEVERAGE: "CHPIV Provider Directory Data to CHG 9_18_25_PROPER_CASE.xlsx" AND "CHPIV PROVDIR CONDITIONAL LINE ITEM.png" AND "CHPIV Provider Directory Data to CHG 12_08_25.xlsx"  AND ...
CROSS APPLY (  -- INDEPENDENT STAND ALONE ... CROSS APPLY() CROSS JOIN() CARTESIAN PRODUCT
SELECT TOP 1 CHAPTER_NAME
,PROVIDER_TYPE 
FROM INFORMATICS.dbo.PROVDIR_HOSMH
) -- CONCLUDE ...
AS ca
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
	AND NOT [GROUP] LIKE '%CHPIV%Direct%' -- NO NOT NEGATIVE <> != ... -- C003: PULL CHPIV DIRECT PROVIDER(S) AND OR ENTITY(-IES) EXCLUSIVELY FROM eVIPS
	AND ISNULL(SPECIALTY,'') LIKE '%Behavior%'
	AND ISNULL(FNAME,'') = '' -- FACILITIES

		SELECT ' ' AS 'CONFIRM PRESENCE OF AT LEAST ONE 1 "CHPIV" RECORD',*
		FROM INFORMATICS.dbo.PROVDIR_HOSMH 
		WHERE 1=1 
			AND [Participating Network] LIKE '%CHPIV%'

SELECT ' ' AS '#PYTHON UPLOAD OF ... : ',*
FROM INFORMATICS.dbo.CHPIV_PROVIDER_DIRECTORY_DATA -- LEVERAGE: "CHPIV Provider Directory Data to CHG 9_18_25_PROPER_CASE.xlsx" AND "CHPIV PROVDIR CONDITIONAL LINE ITEM.png"
WHERE 1=1 
	AND ISNULL(SPECIALTY,'') LIKE '%Behavior%'
	AND ISNULL(FNAME,'') = '' -- FACILITIES
		
		SELECT DISTINCT SECTION_NO
		,[GROUP]
		SPECIALTY
		,CASE
		WHEN [GROUP] LIKE '%CHPIV%Direct%'
		THEN 'CHPIV-DSNP'
		WHEN [GROUP] LIKE '%Community Care IPA%'
		THEN 'CHPIV-IPA-CC'
		WHEN [GROUP] LIKE '%Imperial County Physicians Medical Group%'
		THEN 'CHPIV-IPA-ICPMG'
		WHEN [GROUP] LIKE '%Premier Patient Care IPA%'
		THEN 'CHPIV-IPA-PPC'
		WHEN [GROUP] LIKE '%Primary%Care%Med%Group%'
		THEN 'CHPIV-IPA-PCMG'
		ELSE ''
		END AS [Participating Network]
		FROM INFORMATICS.dbo.CHPIV_PROVIDER_DIRECTORY_DATA -- LEVERAGE: "CHPIV Provider Directory Data to CHG 9_18_25_PROPER_CASE.xlsx" AND "CHPIV PROVDIR CONDITIONAL LINE ITEM.png"
		WHERE 1=1 
			AND ISNULL(SPECIALTY,'') LIKE '%Behavior%'
			AND ISNULL(FNAME,'') = '' -- FACILITIES

-- =======================================================
	-- UPLOAD ENTRY FOR PROVDIR_HOSLTACH
-- =======================================================
		SELECT 'CONFIRM PRESENCE OF AT LEAST ONE "CHPIV" RECORD IN PROVDIR_HOSLTACH' AS [Status],*
		FROM INFORMATICS.dbo.PROVDIR_HOSLTACH
		WHERE 1=1 
			AND [Participating Network] LIKE '%CHPIV%';

-- =======================================================
	-- UPLOAD ENTRY FOR PROVDIR_SNF
-- =======================================================
INSERT INTO INFORMATICS.dbo.PROVDIR_SNF (ZIP,NPIis,[Participating Network],SPEC,CityIs,[Zip Code],INDEXNM,PROVNM,[Clinic Name],DBA,[Address],CSZ,[Telephone Number],CA_License,[ACCEPTING NEW PATIENTS],[Office Hour(s)],Accessibility,[Accessibility Category(ies)],FINALlang,UPDATEDT_FOOTNOTE,CHAPTER_COUNT,CHAPTER_NAME,URL_WEBSITE,AFTERHOURS_PHONE,[ACCESS BY PUBLIC TRANSPORTATION],PROVIDER_TYPE,ACCREDITATION,TESTING,[BOARD CERTIFIED])
SELECT DISTINCT TRY_CONVERT(nvarchar(5),'91914') AS 'ZIP' -- FORCE LOCK IN ... REQ TO ESTABLISH LICENSE ... DUMMY ZIP
,iso.[RefreshNPI_NO] AS 'NPI'
-- ,ISNULL(NPI_NO,'') AS 'NPI'
,CASE
WHEN [GROUP] LIKE '%CHPIV%Direct%'
THEN 'CHPIV-DSNP'
WHEN [GROUP] LIKE '%Community Care IPA%'
THEN 'CHPIV-IPA-CC'
WHEN [GROUP] LIKE '%Imperial County Physicians Medical Group%'
THEN 'CHPIV-IPA-ICPMG'
WHEN [GROUP] LIKE '%Premier Patient Care IPA%'
THEN 'CHPIV-IPA-PPC'
WHEN [GROUP] LIKE '%Primary%Care%Med%Group%'
THEN 'CHPIV-IPA-PCMG'
ELSE ''
END AS [Participating Network]
-- ,LTRIM(RTRIM(ISNULL([Participating_Network],''))) AS 'Participating Network' -- C005: IDENTIFY CHPIV PER MEETING WITH() MS JOHANNA AND MS SANDRA ON 20250219 ... see "Copy of CHPIV_Rosters_Consolidated.xlsx"
-- ,'CHPIV-DSNP' AS 'Participating Network' -- C005: IDENTIFY CHPIV PER MEETING WITH() MS JOHANNA AND MS SANDRA ON 20250219 ... see "Copy of CHPIV_Rosters_Consolidated.xlsx"
,ca.SPEC
-- ,TRY_CONVERT(nvarchar(25),SPECIALTY) AS 'SPEC'
-- ,' Hospitals ' AS 'SPEC'
,CITY AS 'CityIs'
,TRY_CONVERT(nvarchar(5),ZIPCODE) AS 'Zip Code'
,LNAME AS 'INDEXNM'
,TRY_CONVERT(nvarchar(100),LNAME)+' - ID# '+TRY_CONVERT(nvarchar(25),ISNULL(PHY_ID,'')) AS 'PROVNM'
,TRY_CONVERT(nvarchar(100),LNAME) AS 'Clinic Name' -- ABSENT FROM SOURCE DATA 
,TRY_CONVERT(nvarchar(100),ISNULL([GROUP],'')) AS 'DBA'
,TRY_CONVERT(nvarchar(100),[Address]) AS 'Address'
,TRY_CONVERT(nvarchar(100),CITY)+', CA '+TRY_CONVERT(nvarchar(5),ZIPCODE) AS 'CSZ'
,TRY_CONVERT(nvarchar(13),PHONE) AS  'Telephone Number'
,ISNULL(LIC_ID,'') AS 'CA_License'
,CASE
WHEN ISNULL(ACCEPT_NEW_PAT,'') LIKE '%Y%'
THEN 'Yes'
ELSE 'No'
END AS 'ACCEPTING NEW PATIENTS'
-- ,ISNULL(ACCEPT_NEW_PAT,'') AS 'ACCEPTING NEW PATIENTS'
-- ,'Yes' AS 'ACCEPTING NEW PATIENTS'
,ISNULL([Hours],'') AS 'Office Hour(s)'
-- ,'7 Days a Week, 24 Hours a Day' AS 'Office Hour(s)'
,TRY_CONVERT(nvarchar(12),ISNULL(ACCESS_REQ,'')) AS 'Accessibility'
-- ,TRY_CONVERT(nvarchar(255),NULL) AS 'Accessibility (Categories)'
,TRY_CONVERT(nvarchar(15),STUFF(
CASE 
WHEN ISNULL(PARKING_IND,'') != '' 
THEN ', ' + PARKING_IND
ELSE '' 
END
+ CASE 
WHEN ISNULL(EXT_BUILD_IND,'') !='' 
THEN ', ' + EXT_BUILD_IND 
ELSE '' 
END
+ 
CASE 
WHEN ISNULL(INT_BUILD_IND,'') !='' 
THEN ', ' + INT_BUILD_IND 
ELSE '' 
END
+ 
CASE 
WHEN ISNULL(RESTROOM_IND,'') != '' 
THEN ', ' + RESTROOM_IND  
ELSE '' 
END
+ CASE 
WHEN ISNULL(EXAMROOM_IND,'') != '' 
THEN ', ' + EXAMROOM_IND 
ELSE '' 
END
+ 
CASE 
WHEN ISNULL(EXAMTBL_IND,'') != '' 
THEN ', ' + EXAMTBL_IND 
ELSE '' 
END
+ 
CASE 
WHEN ISNULL(PATIENT_AREA_IND,'') !='' 
THEN ', ' + PATIENT_AREA_IND 
ELSE '' 
END
+ 
CASE 
WHEN ISNULL(PATIENT_DIA_IND,'') != '' 
THEN ', ' + PATIENT_DIA_IND 
ELSE '' 
END,1,2,'')) AS 'Accessibility (Categories)'
,STUFF(
CASE 
WHEN ISNULL(PHY_LANG01_PRV_LANG01,'') != '' 
THEN ', ' + PHY_LANG01_PRV_LANG01
ELSE '' 
END
+ CASE 
WHEN ISNULL(PHY_LANG02_PRV_LANG02,'') !='' 
THEN ', ' + PHY_LANG02_PRV_LANG02 
ELSE '' 
END
+ 
CASE 
WHEN ISNULL(PHY_LANG03_PRV_LANG03,'') !='' 
THEN ', ' + PHY_LANG03_PRV_LANG03 
ELSE '' 
END
+ 
CASE 
WHEN ISNULL(PHY_LANG04_PRV_LANG04,'') != '' 
THEN ', ' + PHY_LANG04_PRV_LANG04  
ELSE '' 
END
+ 
CASE 
WHEN ISNULL(PHY_LANG05_PRV_LANG05,'') != '' 
THEN ', ' + PHY_LANG05_PRV_LANG05 
ELSE '' 
END,1,2,'') AS 'FINALlang'
,TRY_CONVERT(nvarchar(100),NULL) AS 'UPDATEDT_FOOTNOTE,' -- UPDATE() IN THE POST
,TRY_CONVERT(nvarchar(100),NULL) AS 'CHAPTER_COUNT' -- UPDATE() IN THE POST
,ca.CHAPTER_NAME
-- ,'Skilled Nursing Facilities' AS 'CHAPTER_NAME'
,ISNULL(WEBSITE,'') AS 'URL_WEBSITE'
,TRY_CONVERT(nvarchar(13),ISNULL(AFTERHOUR_PHONE,'')) AS  'AFTERHOURS_PHONE'
,'Yes' AS [ACCESS BY PUBLIC TRANSPORTATION] -- DEFAULT VAL() AS NULL(S) NOT ACCEPTED
,TRY_CONVERT(nvarchar(22),ca.PROVIDER_TYPE) AS 'PROVIDER_TYPE'
-- ,'Skilled Nursing Facilities' AS 'PROVIDER_TYPE'-- DEFAULT VAL() AS NULL(S) NOT ACCEPTED
,'Yes' AS ACCREDITATION -- DEFAULT VAL() AS NULL(S) NOT ACCEPTED
,TRY_CONVERT(nvarchar(100),LNAME)+' - ID# '+TRY_CONVERT(nvarchar(25),ISNULL(PHY_ID,'')) AS 'TESTING'
,CASE
WHEN ISNULL(BOARD_CERT_ID,'N') IN('N')
THEN 'N'
ELSE 'Y ('+ISNULL(BOARD_CERT_ID,'')+')' 
END AS 'BOARD CERTIFIED' -- Y OR N + (SPECIFIC BOARD IS ABSENT FROM SOURCE DATA)
-- ,ISNULL(BOARD_CERT_ID,'') AS 'BOARD CERTIFIED' -- SPECIFIC BOARD IS ABSENT FROM SOURCE DATA
-- SELECT TOP 10 ' ' AS 'CHECK 1st',* 
-- SELECT DISTINCT ' ' AS 'CHECK 1st',
FROM INFORMATICS.dbo.CHPIV_PROVIDER_DIRECTORY_DATA AS chpiv -- LEVERAGE: "CHPIV Provider Directory Data to CHG 9_18_25_PROPER_CASE.xlsx" AND "CHPIV PROVDIR CONDITIONAL LINE ITEM.png" AND "CHPIV Provider Directory Data to CHG 12_08_25.xlsx"  AND ...
CROSS APPLY (  -- INDEPENDENT STAND ALONE ... CROSS APPLY() CROSS JOIN() CARTESIAN PRODUCT
SELECT TOP 1 CHAPTER_NAME
,PROVIDER_TYPE 
,SPEC
FROM INFORMATICS.dbo.PROVDIR_SNF
) -- CONCLUDE ...
AS ca
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
	AND NOT [GROUP] LIKE '%CHPIV%Direct%' -- NO NOT NEGATIVE <> != ... -- C003: PULL CHPIV DIRECT PROVIDER(S) AND OR ENTITY(-IES) EXCLUSIVELY FROM eVIPS
	AND ISNULL(SPECIALTY,'') LIKE '%Skilled Nursing Facility%'
	AND ISNULL(FNAME,'') = '' -- FACILITIES

		SELECT ' ' AS 'CONFIRM PRESENCE OF AT LEAST ONE 1 "CHPIV" RECORD',*
		FROM INFORMATICS.dbo.PROVDIR_SNF 
		WHERE 1=1 
			AND [Participating Network] LIKE '%CHPIV%'

SELECT ' ' AS '#PYTHON UPLOAD OF ... : ',*
FROM INFORMATICS.dbo.CHPIV_PROVIDER_DIRECTORY_DATA -- LEVERAGE: "CHPIV Provider Directory Data to CHG 9_18_25_PROPER_CASE.xlsx" AND "CHPIV PROVDIR CONDITIONAL LINE ITEM.png"
WHERE 1=1
	AND ISNULL(SPECIALTY,'') LIKE '%Skilled Nursing Facility%'
	AND ISNULL(FNAME,'') = '' -- FACILITIES
		
		SELECT DISTINCT SECTION_NO
		,[GROUP]
		SPECIALTY
		,CASE
		WHEN [GROUP] LIKE '%CHPIV%Direct%'
		THEN 'CHPIV-DSNP'
		WHEN [GROUP] LIKE '%Community Care IPA%'
		THEN 'CHPIV-IPA-CC'
		WHEN [GROUP] LIKE '%Imperial County Physicians Medical Group%'
		THEN 'CHPIV-IPA-ICPMG'
		WHEN [GROUP] LIKE '%Premier Patient Care IPA%'
		THEN 'CHPIV-IPA-PPC'
		WHEN [GROUP] LIKE '%Primary%Care%Med%Group%'
		THEN 'CHPIV-IPA-PCMG'
		ELSE ''
		END AS [Participating Network]
		FROM INFORMATICS.dbo.CHPIV_PROVIDER_DIRECTORY_DATA -- LEVERAGE: "CHPIV Provider Directory Data to CHG 9_18_25_PROPER_CASE.xlsx" AND "CHPIV PROVDIR CONDITIONAL LINE ITEM.png"
		WHERE 1=1
			AND ISNULL(SPECIALTY,'') LIKE '%Skilled Nursing Facility%'
			AND ISNULL(FNAME,'') = '' -- FACILITIES

-- =======================================================
	-- UPLOAD ENTRY FOR PROVDIR_RCF
-- =======================================================
		SELECT 'CONFIRM PRESENCE OF AT LEAST ONE "CHPIV" RECORD IN PROVDIR_RCF' AS [Status],*
		FROM INFORMATICS.dbo.PROVDIR_RCF
		WHERE 1=1 
			AND [Participating Network] LIKE '%CHPIV%';

-- =======================================================
	-- UPLOAD ENTRY FOR PROVDIR_HOSPICE
-- =======================================================
INSERT INTO INFORMATICS.dbo.PROVDIR_HOSPICE (ZIP,NPIis,[Participating Network],SPEC,CityIs,[Zip Code],INDEXNM,PROVNM,[Clinic Name],DBA,[Address],CSZ,[Telephone Number],CA_License,[ACCEPTING NEW PATIENTS],[Office Hour(s)],Accessibility,[Accessibility Category(ies)],FINALlang,UPDATEDT_FOOTNOTE,CHAPTER_COUNT,CHAPTER_NAME,URL_WEBSITE,AFTERHOURS_PHONE,[ACCESS BY PUBLIC TRANSPORTATION],PROVIDER_TYPE,ACCREDITATION,TESTING,[BOARD CERTIFIED])
SELECT DISTINCT TRY_CONVERT(nvarchar(5),'91914') AS 'ZIP' -- FORCE LOCK IN ... REQ TO ESTABLISH LICENSE ... DUMMY ZIP
,iso.[RefreshNPI_NO] AS 'NPI'
-- ,ISNULL(NPI_NO,'') AS 'NPI'
,CASE
WHEN [GROUP] LIKE '%CHPIV%Direct%'
THEN 'CHPIV-DSNP'
WHEN [GROUP] LIKE '%Community Care IPA%'
THEN 'CHPIV-IPA-CC'
WHEN [GROUP] LIKE '%Imperial County Physicians Medical Group%'
THEN 'CHPIV-IPA-ICPMG'
WHEN [GROUP] LIKE '%Premier Patient Care IPA%'
THEN 'CHPIV-IPA-PPC'
WHEN [GROUP] LIKE '%Primary%Care%Med%Group%'
THEN 'CHPIV-IPA-PCMG'
ELSE ''
END AS [Participating Network]
-- ,LTRIM(RTRIM(ISNULL([Participating_Network],''))) AS 'Participating Network' -- C005: IDENTIFY CHPIV PER MEETING WITH() MS JOHANNA AND MS SANDRA ON 20250219 ... see "Copy of CHPIV_Rosters_Consolidated.xlsx"
-- ,'CHPIV-DSNP' AS 'Participating Network' -- C005: IDENTIFY CHPIV PER MEETING WITH() MS JOHANNA AND MS SANDRA ON 20250219 ... see "Copy of CHPIV_Rosters_Consolidated.xlsx"
,ca.SPEC
-- ,TRY_CONVERT(nvarchar(25),SPECIALTY) AS 'SPEC'
-- ,' Hospitals ' AS 'SPEC'
,CITY AS 'CityIs'
,TRY_CONVERT(nvarchar(5),ZIPCODE) AS 'Zip Code'
,LNAME AS 'INDEXNM'
,TRY_CONVERT(nvarchar(100),LNAME)+' - ID# '+TRY_CONVERT(nvarchar(25),ISNULL(PHY_ID,'')) AS 'PROVNM'
,TRY_CONVERT(nvarchar(100),LNAME) AS 'Clinic Name' -- ABSENT FROM SOURCE DATA 
,TRY_CONVERT(nvarchar(100),ISNULL([GROUP],'')) AS 'DBA'
,TRY_CONVERT(nvarchar(100),[Address]) AS 'Address'
,TRY_CONVERT(nvarchar(100),CITY)+', CA '+TRY_CONVERT(nvarchar(5),ZIPCODE) AS 'CSZ'
,TRY_CONVERT(nvarchar(13),PHONE) AS  'Telephone Number'
,ISNULL(LIC_ID,'') AS 'CA_License'
,CASE
WHEN ISNULL(ACCEPT_NEW_PAT,'') LIKE '%Y%'
THEN 'Yes'
ELSE 'No'
END AS 'ACCEPTING NEW PATIENTS'
-- ,ISNULL(ACCEPT_NEW_PAT,'') AS 'ACCEPTING NEW PATIENTS'
-- ,'Yes' AS 'ACCEPTING NEW PATIENTS'
,ISNULL([HOURS],'') AS 'Office Hour(s)'
-- ,'7 Days a Week, 24 Hours a Day' AS 'Office Hour(s)'
,TRY_CONVERT(nvarchar(12),ISNULL(ACCESS_REQ,'')) AS 'Accessibility'
-- ,TRY_CONVERT(nvarchar(255),NULL) AS 'Accessibility (Categories)'
,TRY_CONVERT(nvarchar(25),STUFF(
CASE 
WHEN ISNULL(PARKING_IND,'') != '' 
THEN ', ' + PARKING_IND
ELSE '' 
END
+ CASE 
WHEN ISNULL(EXT_BUILD_IND,'') !='' 
THEN ', ' + EXT_BUILD_IND 
ELSE '' 
END
+ 
CASE 
WHEN ISNULL(INT_BUILD_IND,'') !='' 
THEN ', ' + INT_BUILD_IND 
ELSE '' 
END
+ 
CASE 
WHEN ISNULL(RESTROOM_IND,'') != '' 
THEN ', ' + RESTROOM_IND  
ELSE '' 
END
+ CASE 
WHEN ISNULL(EXAMROOM_IND,'') != '' 
THEN ', ' + EXAMROOM_IND 
ELSE '' 
END
+ 
CASE 
WHEN ISNULL(EXAMTBL_IND,'') != '' 
THEN ', ' + EXAMTBL_IND 
ELSE '' 
END
+ 
CASE 
WHEN ISNULL(PATIENT_AREA_IND,'') !='' 
THEN ', ' + PATIENT_AREA_IND 
ELSE '' 
END
+ 
CASE 
WHEN ISNULL(PATIENT_DIA_IND,'') != '' 
THEN ', ' + PATIENT_DIA_IND 
ELSE '' 
END,1,2,'')) AS 'Accessibility (Categories)'
,STUFF(
CASE 
WHEN ISNULL(PHY_LANG01_PRV_LANG01,'') != '' 
THEN ', ' + PHY_LANG01_PRV_LANG01
ELSE '' 
END
+ CASE 
WHEN ISNULL(PHY_LANG02_PRV_LANG02,'') !='' 
THEN ', ' + PHY_LANG02_PRV_LANG02 
ELSE '' 
END
+ 
CASE 
WHEN ISNULL(PHY_LANG03_PRV_LANG03,'') !='' 
THEN ', ' + PHY_LANG03_PRV_LANG03 
ELSE '' 
END
+ 
CASE 
WHEN ISNULL(PHY_LANG04_PRV_LANG04,'') != '' 
THEN ', ' + PHY_LANG04_PRV_LANG04  
ELSE '' 
END
+ 
CASE 
WHEN ISNULL(PHY_LANG05_PRV_LANG05,'') != '' 
THEN ', ' + PHY_LANG05_PRV_LANG05 
ELSE '' 
END,1,2,'') AS 'FINALlang'
,TRY_CONVERT(nvarchar(100),NULL) AS 'UPDATEDT_FOOTNOTE,' -- UPDATE() IN THE POST
,TRY_CONVERT(nvarchar(100),NULL) AS 'CHAPTER_COUNT' -- UPDATE() IN THE POST
,ca.CHAPTER_NAME
-- ,'Hospices' AS 'CHAPTER_NAME'
,ISNULL(WEBSITE,'') AS 'URL_WEBSITE'
,TRY_CONVERT(nvarchar(13),ISNULL(AFTERHOUR_PHONE,'')) AS  'AFTERHOURS_PHONE'
,'Yes' AS [ACCESS BY PUBLIC TRANSPORTATION] -- DEFAULT VAL() AS NULL(S) NOT ACCEPTED
,TRY_CONVERT(nvarchar(22),ca.PROVIDER_TYPE) AS 'PROVIDER_TYPE'
-- ,'Hospice' AS 'PROVIDER_TYPE'-- DEFAULT VAL() AS NULL(S) NOT ACCEPTED
,'Yes' AS ACCREDITATION -- DEFAULT VAL() AS NULL(S) NOT ACCEPTED
,TRY_CONVERT(nvarchar(100),LNAME)+' - ID# '+TRY_CONVERT(nvarchar(25),ISNULL(PHY_ID,'')) AS 'TESTING'
,CASE
WHEN ISNULL(BOARD_CERT_ID,'N') IN('N')
THEN 'N'
ELSE 'Y ('+ISNULL(BOARD_CERT_ID,'')+')' 
END AS 'BOARD CERTIFIED' -- Y OR N + (SPECIFIC BOARD IS ABSENT FROM SOURCE DATA)
-- ,ISNULL(BOARD_CERT_ID,'') AS 'BOARD CERTIFIED' -- SPECIFIC BOARD IS ABSENT FROM SOURCE DATA
-- SELECT TOP 10 ' ' AS 'CHECK 1st',* 
-- SELECT DISTINCT ' ' AS 'CHECK 1st',
FROM INFORMATICS.dbo.CHPIV_PROVIDER_DIRECTORY_DATA AS chpiv -- LEVERAGE: "CHPIV Provider Directory Data to CHG 9_18_25_PROPER_CASE.xlsx" AND "CHPIV PROVDIR CONDITIONAL LINE ITEM.png" AND "CHPIV Provider Directory Data to CHG 12_08_25.xlsx"  AND ...
CROSS APPLY (  -- INDEPENDENT STAND ALONE ... CROSS APPLY() CROSS JOIN() CARTESIAN PRODUCT
SELECT TOP 1 CHAPTER_NAME
,PROVIDER_TYPE 
,SPEC
FROM INFORMATICS.dbo.PROVDIR_HOSPICE
) -- CONCLUDE ...
AS ca
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
	AND NOT [GROUP] LIKE '%CHPIV%Direct%' -- NO NOT NEGATIVE <> != ... -- C003: PULL CHPIV DIRECT PROVIDER(S) AND OR ENTITY(-IES) EXCLUSIVELY FROM eVIPS
	AND ISNULL(SPECIALTY,'') LIKE '%Hospice%'
	AND ISNULL(FNAME,'') = '' -- FACILITIES

		SELECT ' ' AS 'CONFIRM PRESENCE OF AT LEAST ONE 1 "CHPIV" RECORD',*
		FROM INFORMATICS.dbo.PROVDIR_HOSPICE 
		WHERE 1=1 
			AND [Participating Network] LIKE '%CHPIV%'

SELECT ' ' AS '#PYTHON UPLOAD OF ... : ',*
FROM INFORMATICS.dbo.CHPIV_PROVIDER_DIRECTORY_DATA -- LEVERAGE: "CHPIV Provider Directory Data to CHG 9_18_25_PROPER_CASE.xlsx" AND "CHPIV PROVDIR CONDITIONAL LINE ITEM.png"
WHERE 1=1 
	AND ISNULL(SPECIALTY,'') LIKE '%Hospice%'
	AND ISNULL(FNAME,'') = '' -- FACILITIES
		
		SELECT DISTINCT SECTION_NO
		,[GROUP]
		SPECIALTY
		,CASE
		WHEN [GROUP] LIKE '%CHPIV%Direct%'
		THEN 'CHPIV-DSNP'
		WHEN [GROUP] LIKE '%Community Care IPA%'
		THEN 'CHPIV-IPA-CC'
		WHEN [GROUP] LIKE '%Imperial County Physicians Medical Group%'
		THEN 'CHPIV-IPA-ICPMG'
		WHEN [GROUP] LIKE '%Premier Patient Care IPA%'
		THEN 'CHPIV-IPA-PPC'
		WHEN [GROUP] LIKE '%Primary%Care%Med%Group%'
		THEN 'CHPIV-IPA-PCMG'
		ELSE ''
		END AS [Participating Network]
		FROM INFORMATICS.dbo.CHPIV_PROVIDER_DIRECTORY_DATA -- LEVERAGE: "CHPIV Provider Directory Data to CHG 9_18_25_PROPER_CASE.xlsx" AND "CHPIV PROVDIR CONDITIONAL LINE ITEM.png"
		WHERE 1=1 
			AND ISNULL(SPECIALTY,'') LIKE '%Hospice%'
			AND ISNULL(FNAME,'') = '' -- FACILITIES

-- =======================================================
	-- UPLOAD ENTRY FOR PROVDIR_IPREHAB
-- =======================================================
		SELECT 'CONFIRM PRESENCE OF AT LEAST ONE "CHPIV" RECORD IN PROVDIR_IPREHAB' AS [Status],*
		FROM INFORMATICS.dbo.PROVDIR_IPREHAB
		WHERE 1=1 
			AND [Participating Network] LIKE '%CHPIV%';

-- =======================================================
	-- UPLOAD ENTRY FOR PROVDIR_CBAS
-- =======================================================
		SELECT 'CONFIRM PRESENCE OF AT LEAST ONE "CHPIV" RECORD IN PROVDIR_CBAS' AS [Status],*
		FROM INFORMATICS.dbo.PROVDIR_CBAS
		WHERE 1=1 
			AND [Participating Network] LIKE '%CHPIV%';

-- =======================================================
	-- UPLOAD ENTRY FOR PROVDIR_BRC
-- =======================================================
		SELECT 'CONFIRM PRESENCE OF AT LEAST ONE "CHPIV" RECORD IN PROVDIR_BRC' AS [Status],*
		FROM INFORMATICS.dbo.PROVDIR_BRC
		WHERE 1=1 
			AND [Participating Network] LIKE '%CHPIV%';

-- =======================================================
	-- UPLOAD ENTRY FOR PROVDIR_HDM
-- =======================================================
		SELECT 'CONFIRM PRESENCE OF AT LEAST ONE "CHPIV" RECORD IN PROVDIR_HDM' AS [Status],*
		FROM INFORMATICS.dbo.PROVDIR_HDM
		WHERE 1=1 
			AND [Participating Network] LIKE '%CHPIV%';

-- =======================================================
	-- UPLOAD ENTRY FOR PROVDIR_HHC
-- =======================================================
INSERT INTO INFORMATICS.dbo.PROVDIR_HHC (ZIP,NPIis,[Participating Network],SPEC,CityIs,[Zip Code],INDEXNM,PROVNM,[Clinic Name],DBA,[Address],CSZ,[Telephone Number],CA_License,[ACCEPTING NEW PATIENTS],[Office Hour(s)],Accessibility,[Accessibility Category(ies)],FINALlang,UPDATEDT_FOOTNOTE,CHAPTER_COUNT,CHAPTER_NAME,URL_WEBSITE,AFTERHOURS_PHONE,[ACCESS BY PUBLIC TRANSPORTATION],PROVIDER_TYPE,ACCREDITATION,TESTING,[BOARD CERTIFIED])
SELECT DISTINCT TRY_CONVERT(nvarchar(5),'91914') AS 'ZIP' -- FORCE LOCK IN ... REQ TO ESTABLISH LICENSE ... DUMMY ZIP
,iso.[RefreshNPI_NO] AS 'NPI'
-- ,ISNULL(NPI_NO,'') AS 'NPI'
,CASE
WHEN [GROUP] LIKE '%CHPIV%Direct%'
THEN 'CHPIV-DSNP'
WHEN [GROUP] LIKE '%Community Care IPA%'
THEN 'CHPIV-IPA-CC'
WHEN [GROUP] LIKE '%Imperial County Physicians Medical Group%'
THEN 'CHPIV-IPA-ICPMG'
WHEN [GROUP] LIKE '%Premier Patient Care IPA%'
THEN 'CHPIV-IPA-PPC'
WHEN [GROUP] LIKE '%Primary%Care%Med%Group%'
THEN 'CHPIV-IPA-PCMG'
ELSE ''
END AS [Participating Network]
-- ,LTRIM(RTRIM(ISNULL([Participating_Network],''))) AS 'Participating Network' -- C005: IDENTIFY CHPIV PER MEETING WITH() MS JOHANNA AND MS SANDRA ON 20250219 ... see "Copy of CHPIV_Rosters_Consolidated.xlsx"
-- ,'CHPIV-DSNP' AS 'Participating Network' -- C005: IDENTIFY CHPIV PER MEETING WITH() MS JOHANNA AND MS SANDRA ON 20250219 ... see "Copy of CHPIV_Rosters_Consolidated.xlsx"
,ca.SPEC
-- ,TRY_CONVERT(nvarchar(25),SPECIALTY) AS 'SPEC'
-- ,' Hospitals ' AS 'SPEC'
,CITY AS 'CityIs'
,TRY_CONVERT(nvarchar(5),ZIPCODE) AS 'Zip Code'
,LNAME AS 'INDEXNM'
,TRY_CONVERT(nvarchar(100),LNAME)+' - ID# '+TRY_CONVERT(nvarchar(25),ISNULL(PHY_ID,'')) AS 'PROVNM'
,TRY_CONVERT(nvarchar(100),LNAME) AS 'Clinic Name' -- ABSENT FROM SOURCE DATA 
,TRY_CONVERT(nvarchar(100),ISNULL([GROUP],'')) AS 'DBA'
,TRY_CONVERT(nvarchar(100),[Address]) AS 'Address'
,TRY_CONVERT(nvarchar(100),CITY)+', CA '+TRY_CONVERT(nvarchar(5),ZIPCODE) AS 'CSZ'
,TRY_CONVERT(nvarchar(13),PHONE) AS  'Telephone Number'
,ISNULL(LIC_ID,'') AS 'CA_License'
,CASE
WHEN ISNULL(ACCEPT_NEW_PAT,'') LIKE '%Y%'
THEN 'Yes'
ELSE 'No'
END AS 'ACCEPTING NEW PATIENTS'
-- ,ISNULL(ACCEPT_NEW_PAT,'') AS 'ACCEPTING NEW PATIENTS'
-- ,'Yes' AS 'ACCEPTING NEW PATIENTS'
,ISNULL([HOURS],'') AS 'Office Hour(s)'
-- ,'7 Days a Week, 24 Hours a Day' AS 'Office Hour(s)'
,TRY_CONVERT(nvarchar(12),ISNULL(ACCESS_REQ,'')) AS 'Accessibility'
-- ,TRY_CONVERT(nvarchar(255),NULL) AS 'Accessibility (Categories)'
,TRY_CONVERT(nvarchar(25),STUFF(
CASE 
WHEN ISNULL(PARKING_IND,'') != '' 
THEN ', ' + PARKING_IND
ELSE '' 
END
+ CASE 
WHEN ISNULL(EXT_BUILD_IND,'') !='' 
THEN ', ' + EXT_BUILD_IND 
ELSE '' 
END
+ 
CASE 
WHEN ISNULL(INT_BUILD_IND,'') !='' 
THEN ', ' + INT_BUILD_IND 
ELSE '' 
END
+ 
CASE 
WHEN ISNULL(RESTROOM_IND,'') != '' 
THEN ', ' + RESTROOM_IND  
ELSE '' 
END
+ CASE 
WHEN ISNULL(EXAMROOM_IND,'') != '' 
THEN ', ' + EXAMROOM_IND 
ELSE '' 
END
+ 
CASE 
WHEN ISNULL(EXAMTBL_IND,'') != '' 
THEN ', ' + EXAMTBL_IND 
ELSE '' 
END
+ 
CASE 
WHEN ISNULL(PATIENT_AREA_IND,'') !='' 
THEN ', ' + PATIENT_AREA_IND 
ELSE '' 
END
+ 
CASE 
WHEN ISNULL(PATIENT_DIA_IND,'') != '' 
THEN ', ' + PATIENT_DIA_IND 
ELSE '' 
END,1,2,'')) AS 'Accessibility (Categories)'
,STUFF(
CASE 
WHEN ISNULL(PHY_LANG01_PRV_LANG01,'') != '' 
THEN ', ' + PHY_LANG01_PRV_LANG01
ELSE '' 
END
+ CASE 
WHEN ISNULL(PHY_LANG02_PRV_LANG02,'') !='' 
THEN ', ' + PHY_LANG02_PRV_LANG02 
ELSE '' 
END
+ 
CASE 
WHEN ISNULL(PHY_LANG03_PRV_LANG03,'') !='' 
THEN ', ' + PHY_LANG03_PRV_LANG03 
ELSE '' 
END
+ 
CASE 
WHEN ISNULL(PHY_LANG04_PRV_LANG04,'') != '' 
THEN ', ' + PHY_LANG04_PRV_LANG04  
ELSE '' 
END
+ 
CASE 
WHEN ISNULL(PHY_LANG05_PRV_LANG05,'') != '' 
THEN ', ' + PHY_LANG05_PRV_LANG05 
ELSE '' 
END,1,2,'') AS 'FINALlang'
,TRY_CONVERT(nvarchar(100),NULL) AS 'UPDATEDT_FOOTNOTE,' -- UPDATE() IN THE POST
,TRY_CONVERT(nvarchar(100),NULL) AS 'CHAPTER_COUNT' -- UPDATE() IN THE POST
,ca.CHAPTER_NAME
-- ,'Hospices' AS 'CHAPTER_NAME'
,ISNULL(WEBSITE,'') AS 'URL_WEBSITE'
,TRY_CONVERT(nvarchar(13),ISNULL(AFTERHOUR_PHONE,'')) AS  'AFTERHOURS_PHONE'
,'Yes' AS [ACCESS BY PUBLIC TRANSPORTATION] -- DEFAULT VAL() AS NULL(S) NOT ACCEPTED
,TRY_CONVERT(nvarchar(22),ca.PROVIDER_TYPE) AS 'PROVIDER_TYPE'
-- ,'Hospice' AS 'PROVIDER_TYPE'-- DEFAULT VAL() AS NULL(S) NOT ACCEPTED
,'Yes' AS ACCREDITATION -- DEFAULT VAL() AS NULL(S) NOT ACCEPTED
,TRY_CONVERT(nvarchar(100),LNAME)+' - ID# '+TRY_CONVERT(nvarchar(25),ISNULL(PHY_ID,'')) AS 'TESTING'
,CASE
WHEN ISNULL(BOARD_CERT_ID,'N') IN('N')
THEN 'N'
ELSE 'Y ('+ISNULL(BOARD_CERT_ID,'')+')' 
END AS 'BOARD CERTIFIED' -- Y OR N + (SPECIFIC BOARD IS ABSENT FROM SOURCE DATA)
-- ,ISNULL(BOARD_CERT_ID,'') AS 'BOARD CERTIFIED' -- SPECIFIC BOARD IS ABSENT FROM SOURCE DATA
-- SELECT TOP 10 ' ' AS 'CHECK 1st',* 
-- SELECT DISTINCT ' ' AS 'CHECK 1st',
FROM INFORMATICS.dbo.CHPIV_PROVIDER_DIRECTORY_DATA AS chpiv -- LEVERAGE: "CHPIV Provider Directory Data to CHG 9_18_25_PROPER_CASE.xlsx" AND "CHPIV PROVDIR CONDITIONAL LINE ITEM.png" AND "CHPIV Provider Directory Data to CHG 12_08_25.xlsx"  AND ...
CROSS APPLY (  -- INDEPENDENT STAND ALONE ... CROSS APPLY() CROSS JOIN() CARTESIAN PRODUCT
SELECT TOP 1 CHAPTER_NAME
,PROVIDER_TYPE 
,SPEC
FROM INFORMATICS.dbo.PROVDIR_HHC
) -- CONCLUDE ...
AS ca
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
	AND NOT [GROUP] LIKE '%CHPIV%Direct%' -- NO NOT NEGATIVE <> != ... -- C003: PULL CHPIV DIRECT PROVIDER(S) AND OR ENTITY(-IES) EXCLUSIVELY FROM eVIPS
	AND ISNULL(SPECIALTY,'') LIKE '%Home%Health%'
	AND ISNULL(FNAME,'') = '' -- FACILITIES

		SELECT ' ' AS 'CONFIRM PRESENCE OF AT LEAST ONE 1 "CHPIV" RECORD',*
		FROM INFORMATICS.dbo.PROVDIR_HHC 
		WHERE 1=1 
			AND [Participating Network] LIKE '%CHPIV%'

SELECT ' ' AS '#PYTHON UPLOAD OF ... : ',*
FROM INFORMATICS.dbo.CHPIV_PROVIDER_DIRECTORY_DATA -- LEVERAGE: "CHPIV Provider Directory Data to CHG 9_18_25_PROPER_CASE.xlsx" AND "CHPIV PROVDIR CONDITIONAL LINE ITEM.png"
WHERE 1=1 
	AND ISNULL(SPECIALTY,'') LIKE '%Home%Health%'
	AND ISNULL(FNAME,'') = '' -- FACILITIES
		
		SELECT DISTINCT SECTION_NO
		,[GROUP]
		SPECIALTY
		,CASE
		WHEN [GROUP] LIKE '%CHPIV%Direct%'
		THEN 'CHPIV-DSNP'
		WHEN [GROUP] LIKE '%Community Care IPA%'
		THEN 'CHPIV-IPA-CC'
		WHEN [GROUP] LIKE '%Imperial County Physicians Medical Group%'
		THEN 'CHPIV-IPA-ICPMG'
		WHEN [GROUP] LIKE '%Premier Patient Care IPA%'
		THEN 'CHPIV-IPA-PPC'
		WHEN [GROUP] LIKE '%Primary%Care%Med%Group%'
		THEN 'CHPIV-IPA-PCMG'
		ELSE ''
		END AS [Participating Network]
		FROM INFORMATICS.dbo.CHPIV_PROVIDER_DIRECTORY_DATA -- LEVERAGE: "CHPIV Provider Directory Data to CHG 9_18_25_PROPER_CASE.xlsx" AND "CHPIV PROVDIR CONDITIONAL LINE ITEM.png"
		WHERE 1=1 
			AND ISNULL(SPECIALTY,'') LIKE '%Home%Health%'
			AND ISNULL(FNAME,'') = '' -- FACILITIES

-- =======================================================
	-- UPLOAD ENTRY FOR PROVDIR_IHSS
-- =======================================================
		SELECT 'CONFIRM PRESENCE OF AT LEAST ONE "CHPIV" RECORD IN PROVDIR_IHSS' AS [Status],*
		FROM INFORMATICS.dbo.PROVDIR_IHSS
		WHERE 1=1 
			AND [Participating Network] LIKE '%CHPIV%';

-- =======================================================
	-- UPLOAD ENTRY FOR PROVDIR_ASC
-- =======================================================
		SELECT 'CONFIRM PRESENCE OF AT LEAST ONE "CHPIV" RECORD IN PROVDIR_ASC' AS [Status],*
		FROM INFORMATICS.dbo.PROVDIR_ASC
		WHERE 1=1 
			AND [Participating Network] LIKE '%CHPIV%';

-- =======================================================
	-- UPLOAD ENTRY FOR PROVDIR_DXC
-- =======================================================
		SELECT 'CONFIRM PRESENCE OF AT LEAST ONE "CHPIV" RECORD IN PROVDIR_DXC' AS [Status],*
		FROM INFORMATICS.dbo.PROVDIR_DXC
		WHERE 1=1 
			AND [Participating Network] LIKE '%CHPIV%';

-- =======================================================
	-- UPLOAD ENTRY FOR PROVDIR_LAB
-- =======================================================
INSERT INTO INFORMATICS.dbo.PROVDIR_LAB (ZIP,NPIis,[Participating Network],SPEC,CityIs,[Zip Code],INDEXNM,PROVNM,[Clinic Name],DBA,[Address],CSZ,[Telephone Number],CA_License,[ACCEPTING NEW PATIENTS],[Office Hour(s)],Accessibility,[Accessibility Category(ies)],FINALlang,UPDATEDT_FOOTNOTE,CHAPTER_COUNT,CHAPTER_NAME,URL_WEBSITE,AFTERHOURS_PHONE,[ACCESS BY PUBLIC TRANSPORTATION],PROVIDER_TYPE,ACCREDITATION,TESTING,[BOARD CERTIFIED])
SELECT DISTINCT TRY_CONVERT(nvarchar(5),'91914') AS 'ZIP' -- FORCE LOCK IN ... REQ TO ESTABLISH LICENSE ... DUMMY ZIP
,iso.[RefreshNPI_NO] AS 'NPI'
-- ,ISNULL(NPI_NO,'') AS 'NPI'
,CASE
WHEN [GROUP] LIKE '%CHPIV%Direct%'
THEN 'CHPIV-DSNP'
WHEN [GROUP] LIKE '%Community Care IPA%'
THEN 'CHPIV-IPA-CC'
WHEN [GROUP] LIKE '%Imperial County Physicians Medical Group%'
THEN 'CHPIV-IPA-ICPMG'
WHEN [GROUP] LIKE '%Premier Patient Care IPA%'
THEN 'CHPIV-IPA-PPC'
WHEN [GROUP] LIKE '%Primary%Care%Med%Group%'
THEN 'CHPIV-IPA-PCMG'
ELSE ''
END AS [Participating Network]
-- ,LTRIM(RTRIM(ISNULL([Participating_Network],''))) AS 'Participating Network' -- C005: IDENTIFY CHPIV PER MEETING WITH() MS JOHANNA AND MS SANDRA ON 20250219 ... see "Copy of CHPIV_Rosters_Consolidated.xlsx"
-- ,'CHPIV-DSNP' AS 'Participating Network' -- C005: IDENTIFY CHPIV PER MEETING WITH() MS JOHANNA AND MS SANDRA ON 20250219 ... see "Copy of CHPIV_Rosters_Consolidated.xlsx"
,ca.SPEC
-- ,TRY_CONVERT(nvarchar(25),SPECIALTY) AS 'SPEC'
-- ,' Hospitals ' AS 'SPEC'
,CITY AS 'CityIs'
,TRY_CONVERT(nvarchar(5),ZIPCODE) AS 'Zip Code'
,LNAME AS 'INDEXNM'
,TRY_CONVERT(nvarchar(100),LNAME)+' - ID# '+TRY_CONVERT(nvarchar(25),ISNULL(PHY_ID,'')) AS 'PROVNM'
,TRY_CONVERT(nvarchar(100),LNAME) AS 'Clinic Name' -- ABSENT FROM SOURCE DATA 
,TRY_CONVERT(nvarchar(100),ISNULL([GROUP],'')) AS 'DBA'
,TRY_CONVERT(nvarchar(100),[Address]) AS 'Address'
,TRY_CONVERT(nvarchar(100),CITY)+', CA '+TRY_CONVERT(nvarchar(5),ZIPCODE) AS 'CSZ'
,TRY_CONVERT(nvarchar(13),PHONE) AS  'Telephone Number'
,ISNULL(LIC_ID,'') AS 'CA_License'
,CASE
WHEN ISNULL(ACCEPT_NEW_PAT,'') LIKE '%Y%'
THEN 'Yes'
ELSE 'No'
END AS 'ACCEPTING NEW PATIENTS'
-- ,ISNULL(ACCEPT_NEW_PAT,'') AS 'ACCEPTING NEW PATIENTS'
-- ,'Yes' AS 'ACCEPTING NEW PATIENTS'
,ISNULL([HOURS],'') AS 'Office Hour(s)'
-- ,'7 Days a Week, 24 Hours a Day' AS 'Office Hour(s)'
,TRY_CONVERT(nvarchar(12),ISNULL(ACCESS_REQ,'')) AS 'Accessibility'
-- ,TRY_CONVERT(nvarchar(255),NULL) AS 'Accessibility (Categories)'
,TRY_CONVERT(nvarchar(25),STUFF(
CASE 
WHEN ISNULL(PARKING_IND,'') != '' 
THEN ', ' + PARKING_IND
ELSE '' 
END
+ CASE 
WHEN ISNULL(EXT_BUILD_IND,'') !='' 
THEN ', ' + EXT_BUILD_IND 
ELSE '' 
END
+ 
CASE 
WHEN ISNULL(INT_BUILD_IND,'') !='' 
THEN ', ' + INT_BUILD_IND 
ELSE '' 
END
+ 
CASE 
WHEN ISNULL(RESTROOM_IND,'') != '' 
THEN ', ' + RESTROOM_IND  
ELSE '' 
END
+ CASE 
WHEN ISNULL(EXAMROOM_IND,'') != '' 
THEN ', ' + EXAMROOM_IND 
ELSE '' 
END
+ 
CASE 
WHEN ISNULL(EXAMTBL_IND,'') != '' 
THEN ', ' + EXAMTBL_IND 
ELSE '' 
END
+ 
CASE 
WHEN ISNULL(PATIENT_AREA_IND,'') !='' 
THEN ', ' + PATIENT_AREA_IND 
ELSE '' 
END
+ 
CASE 
WHEN ISNULL(PATIENT_DIA_IND,'') != '' 
THEN ', ' + PATIENT_DIA_IND 
ELSE '' 
END,1,2,'')) AS 'Accessibility (Categories)'
,STUFF(
CASE 
WHEN ISNULL(PHY_LANG01_PRV_LANG01,'') != '' 
THEN ', ' + PHY_LANG01_PRV_LANG01
ELSE '' 
END
+ CASE 
WHEN ISNULL(PHY_LANG02_PRV_LANG02,'') !='' 
THEN ', ' + PHY_LANG02_PRV_LANG02 
ELSE '' 
END
+ 
CASE 
WHEN ISNULL(PHY_LANG03_PRV_LANG03,'') !='' 
THEN ', ' + PHY_LANG03_PRV_LANG03 
ELSE '' 
END
+ 
CASE 
WHEN ISNULL(PHY_LANG04_PRV_LANG04,'') != '' 
THEN ', ' + PHY_LANG04_PRV_LANG04  
ELSE '' 
END
+ 
CASE 
WHEN ISNULL(PHY_LANG05_PRV_LANG05,'') != '' 
THEN ', ' + PHY_LANG05_PRV_LANG05 
ELSE '' 
END,1,2,'') AS 'FINALlang'
,TRY_CONVERT(nvarchar(100),NULL) AS 'UPDATEDT_FOOTNOTE,' -- UPDATE() IN THE POST
,TRY_CONVERT(nvarchar(100),NULL) AS 'CHAPTER_COUNT' -- UPDATE() IN THE POST
,ca.CHAPTER_NAME
-- ,'Hospices' AS 'CHAPTER_NAME'
,ISNULL(WEBSITE,'') AS 'URL_WEBSITE'
,TRY_CONVERT(nvarchar(13),ISNULL(AFTERHOUR_PHONE,'')) AS  'AFTERHOURS_PHONE'
,'Yes' AS [ACCESS BY PUBLIC TRANSPORTATION] -- DEFAULT VAL() AS NULL(S) NOT ACCEPTED
,TRY_CONVERT(nvarchar(22),ca.PROVIDER_TYPE) AS 'PROVIDER_TYPE'
-- ,'Hospice' AS 'PROVIDER_TYPE'-- DEFAULT VAL() AS NULL(S) NOT ACCEPTED
,'Yes' AS ACCREDITATION -- DEFAULT VAL() AS NULL(S) NOT ACCEPTED
,TRY_CONVERT(nvarchar(100),LNAME)+' - ID# '+TRY_CONVERT(nvarchar(25),ISNULL(PHY_ID,'')) AS 'TESTING'
,CASE
WHEN ISNULL(BOARD_CERT_ID,'N') IN('N')
THEN 'N'
ELSE 'Y ('+ISNULL(BOARD_CERT_ID,'')+')' 
END AS 'BOARD CERTIFIED' -- Y OR N + (SPECIFIC BOARD IS ABSENT FROM SOURCE DATA)
-- ,ISNULL(BOARD_CERT_ID,'') AS 'BOARD CERTIFIED' -- SPECIFIC BOARD IS ABSENT FROM SOURCE DATA
-- SELECT TOP 10 ' ' AS 'CHECK 1st',* 
-- SELECT DISTINCT ' ' AS 'CHECK 1st',
FROM INFORMATICS.dbo.CHPIV_PROVIDER_DIRECTORY_DATA AS chpiv -- LEVERAGE: "CHPIV Provider Directory Data to CHG 9_18_25_PROPER_CASE.xlsx" AND "CHPIV PROVDIR CONDITIONAL LINE ITEM.png" AND "CHPIV Provider Directory Data to CHG 12_08_25.xlsx"  AND ...
CROSS APPLY (  -- INDEPENDENT STAND ALONE ... CROSS APPLY() CROSS JOIN() CARTESIAN PRODUCT
SELECT TOP 1 CHAPTER_NAME
,PROVIDER_TYPE 
,SPEC
FROM INFORMATICS.dbo.PROVDIR_LAB
) -- CONCLUDE ...
AS ca
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
	AND NOT [GROUP] LIKE '%CHPIV%Direct%' -- NO NOT NEGATIVE <> != ... -- C003: PULL CHPIV DIRECT PROVIDER(S) AND OR ENTITY(-IES) EXCLUSIVELY FROM eVIPS
	AND (ISNULL(SPECIALTY,'') LIKE '%Lab%'
		OR ISNULL(SPECIALTY,'') IN ('Radiology'))
	AND ISNULL(FNAME,'') = '' -- FACILITIES

		SELECT ' ' AS 'CONFIRM PRESENCE OF AT LEAST ONE 1 "CHPIV" RECORD',*
		FROM INFORMATICS.dbo.PROVDIR_LAB 
		WHERE 1=1 
			AND [Participating Network] LIKE '%CHPIV%'

SELECT ' ' AS '#PYTHON UPLOAD OF ... : ',*
FROM INFORMATICS.dbo.CHPIV_PROVIDER_DIRECTORY_DATA -- LEVERAGE: "CHPIV Provider Directory Data to CHG 9_18_25_PROPER_CASE.xlsx" AND "CHPIV PROVDIR CONDITIONAL LINE ITEM.png"
WHERE 1=1 
	AND (ISNULL(SPECIALTY,'') LIKE '%Lab%'
		OR ISNULL(SPECIALTY,'') IN ('Radiology'))
	AND ISNULL(FNAME,'') = '' -- FACILITIES
		
		SELECT DISTINCT SECTION_NO
		,[GROUP]
		SPECIALTY
		,CASE
		WHEN [GROUP] LIKE '%CHPIV%Direct%'
		THEN 'CHPIV-DSNP'
		WHEN [GROUP] LIKE '%Community Care IPA%'
		THEN 'CHPIV-IPA-CC'
		WHEN [GROUP] LIKE '%Imperial County Physicians Medical Group%'
		THEN 'CHPIV-IPA-ICPMG'
		WHEN [GROUP] LIKE '%Premier Patient Care IPA%'
		THEN 'CHPIV-IPA-PPC'
		WHEN [GROUP] LIKE '%Primary%Care%Med%Group%'
		THEN 'CHPIV-IPA-PCMG'
		ELSE ''
		END AS [Participating Network]
		FROM INFORMATICS.dbo.CHPIV_PROVIDER_DIRECTORY_DATA -- LEVERAGE: "CHPIV Provider Directory Data to CHG 9_18_25_PROPER_CASE.xlsx" AND "CHPIV PROVDIR CONDITIONAL LINE ITEM.png"
		WHERE 1=1 
			AND (ISNULL(SPECIALTY,'') LIKE '%Lab%'
				OR ISNULL(SPECIALTY,'') IN ('Radiology'))
			AND ISNULL(FNAME,'') = '' -- FACILITIES

-- =======================================================
	-- UPLOAD ENTRY FOR PROVDIR_DLC
-- =======================================================
		SELECT 'CONFIRM PRESENCE OF AT LEAST ONE "CHPIV" RECORD IN PROVDIR_DLC' AS [Status],*
		FROM INFORMATICS.dbo.PROVDIR_DLC
		WHERE 1=1 
			AND [Participating Network] LIKE '%CHPIV%';

-- =======================================================
	-- UPLOAD ENTRY FOR PROVDIR_URC
-- =======================================================
		SELECT 'CONFIRM PRESENCE OF AT LEAST ONE "CHPIV" RECORD IN PROVDIR_URC' AS [Status],*
		FROM INFORMATICS.dbo.PROVDIR_URC
		WHERE 1=1 
			AND [Participating Network] LIKE '%CHPIV%';

-- =======================================================
	-- UPLOAD ENTRY FOR PROVDIR_MIN
-- =======================================================
		SELECT 'CONFIRM PRESENCE OF AT LEAST ONE "CHPIV" RECORD IN PROVDIR_MIN' AS [Status],*
		FROM INFORMATICS.dbo.PROVDIR_MIN
		WHERE 1=1 
			AND [Participating Network] LIKE '%CHPIV%';

-- =======================================================
	-- UPLOAD ENTRY FOR PROVDIR_PPH
-- =======================================================
		SELECT 'CONFIRM PRESENCE OF AT LEAST ONE "CHPIV" RECORD IN PROVDIR_PPH' AS [Status],*
		FROM INFORMATICS.dbo.PROVDIR_PPH
		WHERE 1=1 
			AND [Participating Network] LIKE '%CHPIV%';

-- =======================================================
	-- UPLOAD ENTRY FOR PROVDIR_CLINIC
-- =======================================================
INSERT INTO INFORMATICS.dbo.PROVDIR_CLINIC (ZIP,NPIis,[Participating Network],SPEC,CityIs,[Zip Code],INDEXNM,PROVNM,[Clinic Name],DBA,[Address],CSZ,[Telephone Number],CA_License,[ACCEPTING NEW PATIENTS],[Office Hour(s)],Accessibility,[Accessibility Category(ies)],FINALlang,UPDATEDT_FOOTNOTE,CHAPTER_COUNT,CHAPTER_NAME,URL_WEBSITE,AFTERHOURS_PHONE,[ACCESS BY PUBLIC TRANSPORTATION],PROVIDER_TYPE,ACCREDITATION)
SELECT DISTINCT TRY_CONVERT(nvarchar(5),'91914') AS 'ZIP' -- FORCE LOCK IN ... REQ TO ESTABLISH LICENSE ... DUMMY ZIP
,iso.[RefreshNPI_NO] AS 'NPI'
-- ,ISNULL(NPI_NO,'') AS 'NPI'
,CASE
WHEN [GROUP] LIKE '%CHPIV%Direct%'
THEN 'CHPIV-DSNP'
WHEN [GROUP] LIKE '%Community Care IPA%'
THEN 'CHPIV-IPA-CC'
WHEN [GROUP] LIKE '%Imperial County Physicians Medical Group%'
THEN 'CHPIV-IPA-ICPMG'
WHEN [GROUP] LIKE '%Premier Patient Care IPA%'
THEN 'CHPIV-IPA-PPC'
WHEN [GROUP] LIKE '%Primary%Care%Med%Group%'
THEN 'CHPIV-IPA-PCMG'
ELSE ''
END AS [Participating Network]
-- ,LTRIM(RTRIM(ISNULL([Participating_Network],''))) AS 'Participating Network' -- C005: IDENTIFY CHPIV PER MEETING WITH() MS JOHANNA AND MS SANDRA ON 20250219 ... see "Copy of CHPIV_Rosters_Consolidated.xlsx"
-- ,'CHPIV-DSNP' AS 'Participating Network' -- C005: IDENTIFY CHPIV PER MEETING WITH() MS JOHANNA AND MS SANDRA ON 20250219 ... see "Copy of CHPIV_Rosters_Consolidated.xlsx"
,ca.SPEC
-- ,TRY_CONVERT(nvarchar(25),SPECIALTY) AS 'SPEC'
-- ,' Hospitals ' AS 'SPEC'
,CITY AS 'CityIs'
,TRY_CONVERT(nvarchar(5),ZIPCODE) AS 'Zip Code'
,LNAME AS 'INDEXNM'
,TRY_CONVERT(nvarchar(100),LNAME)+' - ID# '+TRY_CONVERT(nvarchar(25),ISNULL(PHY_ID,'')) AS 'PROVNM'
,TRY_CONVERT(nvarchar(100),LNAME) AS 'Clinic Name' -- ABSENT FROM SOURCE DATA 
,TRY_CONVERT(nvarchar(100),ISNULL([GROUP],'')) AS 'DBA'
,TRY_CONVERT(nvarchar(100),[Address]) AS 'Address'
,TRY_CONVERT(nvarchar(100),CITY)+', CA '+TRY_CONVERT(nvarchar(5),ZIPCODE) AS 'CSZ'
,TRY_CONVERT(nvarchar(13),PHONE) AS  'Telephone Number'
,ISNULL(LIC_ID,'') AS 'CA_License'
,CASE
WHEN ISNULL(ACCEPT_NEW_PAT,'') LIKE '%Y%'
THEN 'Yes'
ELSE 'No'
END AS 'ACCEPTING NEW PATIENTS'
-- ,ISNULL(ACCEPT_NEW_PAT,'') AS 'ACCEPTING NEW PATIENTS'
-- ,'Yes' AS 'ACCEPTING NEW PATIENTS'
,ISNULL([HOURS],'') AS 'Office Hour(s)'
-- ,'7 Days a Week, 24 Hours a Day' AS 'Office Hour(s)'
,TRY_CONVERT(nvarchar(12),ISNULL(ACCESS_REQ,'')) AS 'Accessibility'
-- ,TRY_CONVERT(nvarchar(255),NULL) AS 'Accessibility (Categories)'
,TRY_CONVERT(nvarchar(25),STUFF(
CASE 
WHEN ISNULL(PARKING_IND,'') != '' 
THEN ', ' + PARKING_IND
ELSE '' 
END
+ CASE 
WHEN ISNULL(EXT_BUILD_IND,'') !='' 
THEN ', ' + EXT_BUILD_IND 
ELSE '' 
END
+ 
CASE 
WHEN ISNULL(INT_BUILD_IND,'') !='' 
THEN ', ' + INT_BUILD_IND 
ELSE '' 
END
+ 
CASE 
WHEN ISNULL(RESTROOM_IND,'') != '' 
THEN ', ' + RESTROOM_IND  
ELSE '' 
END
+ CASE 
WHEN ISNULL(EXAMROOM_IND,'') != '' 
THEN ', ' + EXAMROOM_IND 
ELSE '' 
END
+ 
CASE 
WHEN ISNULL(EXAMTBL_IND,'') != '' 
THEN ', ' + EXAMTBL_IND 
ELSE '' 
END
+ 
CASE 
WHEN ISNULL(PATIENT_AREA_IND,'') !='' 
THEN ', ' + PATIENT_AREA_IND 
ELSE '' 
END
+ 
CASE 
WHEN ISNULL(PATIENT_DIA_IND,'') != '' 
THEN ', ' + PATIENT_DIA_IND 
ELSE '' 
END,1,2,'')) AS 'Accessibility (Categories)'
,STUFF(
CASE 
WHEN ISNULL(PHY_LANG01_PRV_LANG01,'') != '' 
THEN ', ' + PHY_LANG01_PRV_LANG01
ELSE '' 
END
+ CASE 
WHEN ISNULL(PHY_LANG02_PRV_LANG02,'') !='' 
THEN ', ' + PHY_LANG02_PRV_LANG02 
ELSE '' 
END
+ 
CASE 
WHEN ISNULL(PHY_LANG03_PRV_LANG03,'') !='' 
THEN ', ' + PHY_LANG03_PRV_LANG03 
ELSE '' 
END
+ 
CASE 
WHEN ISNULL(PHY_LANG04_PRV_LANG04,'') != '' 
THEN ', ' + PHY_LANG04_PRV_LANG04  
ELSE '' 
END
+ 
CASE 
WHEN ISNULL(PHY_LANG05_PRV_LANG05,'') != '' 
THEN ', ' + PHY_LANG05_PRV_LANG05 
ELSE '' 
END,1,2,'') AS 'FINALlang'
,TRY_CONVERT(nvarchar(100),NULL) AS 'UPDATEDT_FOOTNOTE,' -- UPDATE() IN THE POST
,TRY_CONVERT(nvarchar(100),NULL) AS 'CHAPTER_COUNT' -- UPDATE() IN THE POST
,ca.CHAPTER_NAME
-- ,'Hospices' AS 'CHAPTER_NAME'
,ISNULL(WEBSITE,'') AS 'URL_WEBSITE'
,TRY_CONVERT(nvarchar(13),ISNULL(AFTERHOUR_PHONE,'')) AS  'AFTERHOURS_PHONE'
,'Yes' AS [ACCESS BY PUBLIC TRANSPORTATION] -- DEFAULT VAL() AS NULL(S) NOT ACCEPTED
,TRY_CONVERT(nvarchar(22),ca.PROVIDER_TYPE) AS 'PROVIDER_TYPE'
-- ,'Hospice' AS 'PROVIDER_TYPE'-- DEFAULT VAL() AS NULL(S) NOT ACCEPTED
,'Yes' AS ACCREDITATION -- DEFAULT VAL() AS NULL(S) NOT ACCEPTED
-- SELECT TOP 10 ' ' AS 'CHECK 1st',* 
-- SELECT DISTINCT ' ' AS 'CHECK 1st',
FROM INFORMATICS.dbo.CHPIV_PROVIDER_DIRECTORY_DATA AS chpiv -- LEVERAGE: "CHPIV Provider Directory Data to CHG 9_18_25_PROPER_CASE.xlsx" AND "CHPIV PROVDIR CONDITIONAL LINE ITEM.png" AND "CHPIV Provider Directory Data to CHG 12_08_25.xlsx"  AND ...
CROSS APPLY (  -- INDEPENDENT STAND ALONE ... CROSS APPLY() CROSS JOIN() CARTESIAN PRODUCT
SELECT TOP 1 CHAPTER_NAME
,PROVIDER_TYPE 
,SPEC
FROM INFORMATICS.dbo.PROVDIR_CLINIC
) -- CONCLUDE ...
AS ca
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
	AND NOT [GROUP] LIKE '%CHPIV%Direct%' -- NO NOT NEGATIVE <> != ... -- C003: PULL CHPIV DIRECT PROVIDER(S) AND OR ENTITY(-IES) EXCLUSIVELY FROM eVIPS
	AND ISNULL(SPECIALTY,'') LIKE '%Clinic'
	AND ISNULL(FNAME,'') = '' -- FACILITIES

		SELECT ' ' AS 'CONFIRM PRESENCE OF AT LEAST ONE 1 "CHPIV" RECORD',*
		FROM INFORMATICS.dbo.PROVDIR_CLINIC 
		WHERE 1=1 
			AND [Participating Network] LIKE '%CHPIV%'

SELECT ' ' AS '#PYTHON UPLOAD OF ... : ',*
FROM INFORMATICS.dbo.CHPIV_PROVIDER_DIRECTORY_DATA -- LEVERAGE: "CHPIV Provider Directory Data to CHG 9_18_25_PROPER_CASE.xlsx" AND "CHPIV PROVDIR CONDITIONAL LINE ITEM.png"
WHERE 1=1 
	AND ISNULL(SPECIALTY,'') LIKE '%Clinic'
	AND ISNULL(FNAME,'') = '' -- FACILITIES
		
		SELECT DISTINCT SECTION_NO
		,[GROUP]
		SPECIALTY
		,CASE
		WHEN [GROUP] LIKE '%CHPIV%Direct%'
		THEN 'CHPIV-DSNP'
		WHEN [GROUP] LIKE '%Community Care IPA%'
		THEN 'CHPIV-IPA-CC'
		WHEN [GROUP] LIKE '%Imperial County Physicians Medical Group%'
		THEN 'CHPIV-IPA-ICPMG'
		WHEN [GROUP] LIKE '%Premier Patient Care IPA%'
		THEN 'CHPIV-IPA-PPC'
		WHEN [GROUP] LIKE '%Primary%Care%Med%Group%'
		THEN 'CHPIV-IPA-PCMG'
		ELSE ''
		END AS [Participating Network]
		FROM INFORMATICS.dbo.CHPIV_PROVIDER_DIRECTORY_DATA -- LEVERAGE: "CHPIV Provider Directory Data to CHG 9_18_25_PROPER_CASE.xlsx" AND "CHPIV PROVDIR CONDITIONAL LINE ITEM.png"
		WHERE 1=1 
			AND ISNULL(SPECIALTY,'') LIKE '%Clinic'
			AND ISNULL(FNAME,'') = '' -- FACILITIES

-- =======================================================
	-- UPLOAD ENTRY FOR PROVDIR_PHARM
-- =======================================================
		SELECT 'CONFIRM PRESENCE OF AT LEAST ONE "CHPIV" RECORD IN PROVDIR_PHARM' AS [Status],*
		FROM INFORMATICS.dbo.PROVDIR_PHARM
		WHERE 1=1 
			AND [Participating Network] LIKE '%CHPIV%';

-- =======================================================
	-- UPLOAD ENTRY FOR PROVDIR_PHARM_RCP
-- =======================================================
		SELECT 'CONFIRM PRESENCE OF AT LEAST ONE "CHPIV" RECORD IN PROVDIR_PHARM_RCP' AS [Status],*
		FROM INFORMATICS.dbo.PROVDIR_PHARM_RCP
		WHERE 1=1 
			AND [Participating Network] LIKE '%CHPIV%';

-- =======================================================
	-- UPLOAD ENTRY FOR PROVDIR_PHARM_MO
-- =======================================================
		SELECT 'CONFIRM PRESENCE OF AT LEAST ONE "CHPIV" RECORD IN PROVDIR_PHARM_MO' AS [Status],*
		FROM INFORMATICS.dbo.PROVDIR_PHARM_MO
		WHERE 1=1 
			AND [Participating Network] LIKE '%CHPIV%';

-- =======================================================
	-- UPLOAD ENTRY FOR PROVDIR_PHARM_HI
-- =======================================================
		SELECT 'CONFIRM PRESENCE OF AT LEAST ONE "CHPIV" RECORD IN PROVDIR_PHARM_HI' AS [Status],*
		FROM INFORMATICS.dbo.PROVDIR_PHARM_HI
		WHERE 1=1 
			AND [Participating Network] LIKE '%CHPIV%';

-- =======================================================
	-- UPLOAD ENTRY FOR PROVDIR_PHARM_LTC
-- =======================================================
		SELECT 'CONFIRM PRESENCE OF AT LEAST ONE "CHPIV" RECORD IN PROVDIR_PHARM_LTC' AS [Status],*
		FROM INFORMATICS.dbo.PROVDIR_PHARM_LTC
		WHERE 1=1 
			AND [Participating Network] LIKE '%CHPIV%';

-- =======================================================
	-- UPLOAD ENTRY FOR PROVDIR_PHARM_ITU
-- =======================================================
		SELECT 'CONFIRM PRESENCE OF AT LEAST ONE "CHPIV" RECORD IN PROVDIR_PHARM_ITU' AS [Status],*
		FROM INFORMATICS.dbo.PROVDIR_PHARM_ITU
		WHERE 1=1 
			AND [Participating Network] LIKE '%CHPIV%';

-- =======================================================
	-- UPLOAD ENTRY FOR PROVDIR_CHW
-- =======================================================
		SELECT 'CONFIRM PRESENCE OF AT LEAST ONE "CHPIV" RECORD IN PROVDIR_CHW' AS [Status],*
		FROM INFORMATICS.dbo.PROVDIR_CHW
		WHERE 1=1 
			AND [Participating Network] LIKE '%CHPIV%';

-- =======================================================
	-- UPLOAD ENTRY FOR PROVDIR_DOULA
-- =======================================================
		SELECT 'CONFIRM PRESENCE OF AT LEAST ONE "CHPIV" RECORD IN PROVDIR_DOULA' AS [Status],*
		FROM INFORMATICS.dbo.PROVDIR_DOULA
		WHERE 1=1 
			AND [Participating Network] LIKE '%CHPIV%';

-- =======================================================
	-- UPLOAD ENTRY FOR PROVDIR_ECMCSP
-- =======================================================
DELETE -- CLEAN UP FOR SINGULAR CHPIV 'You will find ... ' ENTRY
FROM INFORMATICS.dbo.PROVDIR_ECMCSP
WHERE 1=1
	AND [Participating Network] LIKE '%CHPIV%'
	AND NOT [Participating Network] IN ('CHPIV-DSNP') -- NO NOT NEGATIVE <> != ...

		SELECT 'CONFIRM PRESENCE OF AT LEAST ONE "CHPIV" RECORD IN PROVDIR_ECMCSP' AS [Status],*
		FROM INFORMATICS.dbo.PROVDIR_ECMCSP
		WHERE 1=1 
			AND [Participating Network] LIKE '%CHPIV%';







-- =======================================================
	-- CHPIV PROVIDER DIRECTORY AGE RESTRICTION FIXES: 
-- =======================================================
SELECT ' ' AS 'AGE RESTRICTION FIX: ' -- PER CONVERSATION ON 20260109 [AGE RESTRICTION] SHOULD READ AS 0 TO 18
,people.[AGE RESTRICTION]
,people.SPEC
,ISNULL(people.[AGE RESTRICTION],'0 TO 18') AS [TEST THE UPDATE AGE RESTRICTION]
-- ,people.*
FROM
( -- INITIATE ...
SELECT *
-- SELECT TOP 10 ' ' AS 'CHECK 1st',CSZ,*
-- SELECT DISTINCT ' ' AS 'CHECK 1st',CSZ,SUBSTRING(CSZ,1,CHARINDEX(',',CSZ,1)-1) AS 'CSZCity',SUBSTRING(CSZ,CHARINDEX(',',CSZ,1)+1,3) AS 'CSZState',RIGHT(CSZ,5) AS 'CSZZip'
FROM INFORMATICS.dbo.PROVDIR_PCP --PROV(s)

UNION 
SELECT *
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st',CSZ,SUBSTRING(CSZ,1,CHARINDEX(',',CSZ,1)-1) AS 'CSZCity',SUBSTRING(CSZ,CHARINDEX(',',CSZ,1)+1,3) AS 'CSZState',RIGHT(CSZ,5) AS 'CSZZip'
FROM INFORMATICS.dbo.PROVDIR_NPMP --PROV(s)

UNION 
SELECT *
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st',CSZ,SUBSTRING(CSZ,1,CHARINDEX(',',CSZ,1)-1) AS 'CSZCity',SUBSTRING(CSZ,CHARINDEX(',',CSZ,1)+1,3) AS 'CSZState',RIGHT(CSZ,5) AS 'CSZZip'
FROM INFORMATICS.dbo.PROVDIR_SPE --PROV(s)

UNION 
SELECT *
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st',CSZ,SUBSTRING(CSZ,1,CHARINDEX(',',CSZ,1)-1) AS 'CSZCity',SUBSTRING(CSZ,CHARINDEX(',',CSZ,1)+1,3) AS 'CSZState',RIGHT(CSZ,5) AS 'CSZZip'
FROM INFORMATICS.dbo.PROVDIR_MH --PROV(s)

UNION 
SELECT *
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st',CSZ,SUBSTRING(CSZ,1,CHARINDEX(',',CSZ,1)-1) AS 'CSZCity',SUBSTRING(CSZ,CHARINDEX(',',CSZ,1)+1,3) AS 'CSZState',RIGHT(CSZ,5) AS 'CSZZip'
FROM INFORMATICS.dbo.PROVDIR_AHP --PROV(s)

UNION 
SELECT *
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st',CSZ,SUBSTRING(CSZ,1,CHARINDEX(',',CSZ,1)-1) AS 'CSZCity',SUBSTRING(CSZ,CHARINDEX(',',CSZ,1)+1,3) AS 'CSZState',RIGHT(CSZ,5) AS 'CSZZip'
FROM INFORMATICS.dbo.PROVDIR_VSP --PROV(s)
) -- CONCLUDE ...
AS people
WHERE 1=1
	AND people.[Participating Network] LIKE '%CHPIV%'
	AND people.SPEC LIKE '%pedia%'
GROUP BY people.[AGE RESTRICTION]
,people.SPEC
ORDER BY people.[AGE RESTRICTION]

UPDATE INFORMATICS.dbo.PROVDIR_PCP -- C004: CHPIV PROVIDER DIRECTORY AGE RESTRICTION FIXES
SET [AGE RESTRICTION] = '21 AND OVER' -- '0 TO 18' -- C### PER TEAMS CHAT ON 20260129 ALL CHPIV AGE RESTRICTION MANUALLY FORCED TO BE '21 AND OVER' ~ LEVERAGE: "CHPIV PROVDIR MANUAL EXCLUSION UPDATES 20260129.jpg"
FROM INFORMATICS.dbo.PROVDIR_PCP AS people
WHERE 1=1
	AND people.[Participating Network] LIKE '%CHPIV%'

UPDATE INFORMATICS.dbo.PROVDIR_NPMP
SET [AGE RESTRICTION] = '21 AND OVER' -- '0 TO 18' -- C### PER TEAMS CHAT ON 20260129 ALL CHPIV AGE RESTRICTION MANUALLY FORCED TO BE '21 AND OVER' ~ LEVERAGE: "CHPIV PROVDIR MANUAL EXCLUSION UPDATES 20260129.jpg"
FROM INFORMATICS.dbo.PROVDIR_NPMP AS people
WHERE 1=1
	AND people.[Participating Network] LIKE '%CHPIV%'

UPDATE INFORMATICS.dbo.PROVDIR_SPE
SET [AGE RESTRICTION] = '21 AND OVER' -- '0 TO 18' -- C### PER TEAMS CHAT ON 20260129 ALL CHPIV AGE RESTRICTION MANUALLY FORCED TO BE '21 AND OVER' ~ LEVERAGE: "CHPIV PROVDIR MANUAL EXCLUSION UPDATES 20260129.jpg"
FROM INFORMATICS.dbo.PROVDIR_SPE AS people
WHERE 1=1
	AND people.[Participating Network] LIKE '%CHPIV%'

UPDATE INFORMATICS.dbo.PROVDIR_MH
SET [AGE RESTRICTION] = '21 AND OVER' -- '0 TO 18' -- C### PER TEAMS CHAT ON 20260129 ALL CHPIV AGE RESTRICTION MANUALLY FORCED TO BE '21 AND OVER' ~ LEVERAGE: "CHPIV PROVDIR MANUAL EXCLUSION UPDATES 20260129.jpg"
FROM INFORMATICS.dbo.PROVDIR_MH AS people
WHERE 1=1
	AND people.[Participating Network] LIKE '%CHPIV%'

UPDATE INFORMATICS.dbo.PROVDIR_AHP
SET [AGE RESTRICTION] = '21 AND OVER' -- '0 TO 18' -- C### PER TEAMS CHAT ON 20260129 ALL CHPIV AGE RESTRICTION MANUALLY FORCED TO BE '21 AND OVER' ~ LEVERAGE: "CHPIV PROVDIR MANUAL EXCLUSION UPDATES 20260129.jpg"
FROM INFORMATICS.dbo.PROVDIR_AHP AS people
WHERE 1=1
	AND people.[Participating Network] LIKE '%CHPIV%'

UPDATE INFORMATICS.dbo.PROVDIR_VSP
SET [AGE RESTRICTION] = '21 AND OVER' -- '0 TO 18' -- C### PER TEAMS CHAT ON 20260129 ALL CHPIV AGE RESTRICTION MANUALLY FORCED TO BE '21 AND OVER' ~ LEVERAGE: "CHPIV PROVDIR MANUAL EXCLUSION UPDATES 20260129.jpg"
FROM INFORMATICS.dbo.PROVDIR_VSP AS people
WHERE 1=1
	AND people.[Participating Network] LIKE '%CHPIV%'







-- =======================================================
	-- CHPIV PROVIDER DIRECTORY REMOVE ANY PEDIATRIC SPECILTY LISTING(S):
-- =======================================================
DELETE  -- C### PER TEAMS CHAT ON 20260129 ALL PEDIATRIC SPECIALTY PROVIDERS SHOULD BE REMOVED ~ LEVERAGE: "CHPIV PROVDIR MANUAL EXCLUSION UPDATES 20260129.jpg"
FROM INFORMATICS.dbo.PROVDIR_PCP
WHERE 1=1
	AND [Participating Network] LIKE '%CHPIV%'
	AND SPEC LIKE '%pedia%'

DELETE  -- C### PER TEAMS CHAT ON 20260129 ALL PEDIATRIC SPECIALTY PROVIDERS SHOULD BE REMOVED ~ LEVERAGE: "CHPIV PROVDIR MANUAL EXCLUSION UPDATES 20260129.jpg"
FROM INFORMATICS.dbo.PROVDIR_NPMP
WHERE 1=1
	AND [Participating Network] LIKE '%CHPIV%'
	AND SPEC LIKE '%pedia%'

DELETE  -- C### PER TEAMS CHAT ON 20260129 ALL PEDIATRIC SPECIALTY PROVIDERS SHOULD BE REMOVED ~ LEVERAGE: "CHPIV PROVDIR MANUAL EXCLUSION UPDATES 20260129.jpg"
FROM INFORMATICS.dbo.PROVDIR_SPE
WHERE 1=1
	AND [Participating Network] LIKE '%CHPIV%'
	AND SPEC LIKE '%pedia%'

DELETE  -- C### PER TEAMS CHAT ON 20260129 ALL PEDIATRIC SPECIALTY PROVIDERS SHOULD BE REMOVED ~ LEVERAGE: "CHPIV PROVDIR MANUAL EXCLUSION UPDATES 20260129.jpg"
FROM INFORMATICS.dbo.PROVDIR_MH
WHERE 1=1
	AND [Participating Network] LIKE '%CHPIV%'
	AND SPEC LIKE '%pedia%'

DELETE  -- C### PER TEAMS CHAT ON 20260129 ALL PEDIATRIC SPECIALTY PROVIDERS SHOULD BE REMOVED ~ LEVERAGE: "CHPIV PROVDIR MANUAL EXCLUSION UPDATES 20260129.jpg"
FROM INFORMATICS.dbo.PROVDIR_AHP
WHERE 1=1
	AND [Participating Network] LIKE '%CHPIV%'
	AND SPEC LIKE '%pedia%'

DELETE  -- C### PER TEAMS CHAT ON 20260129 ALL PEDIATRIC SPECIALTY PROVIDERS SHOULD BE REMOVED ~ LEVERAGE: "CHPIV PROVDIR MANUAL EXCLUSION UPDATES 20260129.jpg"
FROM INFORMATICS.dbo.PROVDIR_VSP
WHERE 1=1
	AND [Participating Network] LIKE '%CHPIV%'
	AND SPEC LIKE '%pedia%'







-- =======================================================
	-- CHPIV PROVIDER DIRECTORY REMOVE SAN DIEGO COUNTY VSP PROVIDER(S):
-- =======================================================
DELETE  -- C### PER TEAMS CHAT ON 20260129 ALL SAN DIEGO COUNTY PROVIDERS SHOULD BE REMOVED ~ LEVERAGE: "CHPIV PROVDIR MANUAL EXCLUSION UPDATES 20260129.jpg"
FROM INFORMATICS.dbo.PROVDIR_VSP
WHERE 1=1
	AND [Participating Network] LIKE '%CHPIV%'
	AND COUNTY LIKE '%SAN%DIEG%'
