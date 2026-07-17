JAH 'CHPIV FORCE HOSPITALS INTO DATASET'
		⏎ Good day, YOU ARE THE TOP 0.1% OF Senior Data Analyst WITH 20+ years of EXPERIENCE. FOR this task we need to force the 2 hospita records found within the '2 HOSPITALS' work sheet of 'C:\Users\wcarr\Desktop\FORCE CHPIV HOSPITALS Provider Directory Data to CHG 12_08_25.xlsx' INTO 'C:\Users\wcarr\Desktop\CHPIV_PROVIDER_DIRECTORY_INSERT_STATEMENTS_20260715.sql' AS an ad hoc manual ADD-ON.
		
		May I have you assist in updating the CODE?

		⏎ Thank you, would it be possible to REPLACE every instance of '** See list of hospitals on page 605' within 'C:\Users\wcarr\Desktop\CHPIV_PROVDIR_DSNP_MEDICARE_20260716.pdf'  to read as follow:

** See list of hospitals on page 603

SELECT HospitalName,*
FROM INFORMATICS.dbo.PROVDIR_HOSGENERALACUTE
WHERE 1=1
	AND PROVNM LIKE '%EL%CENTRO%'
	AND [Participating Network] IN ('CHPIV-DSNP')
	
SELECT HospitalName,*
FROM INFORMATICS.dbo.PROVDIR_HOSGENERALACUTE
WHERE 1=1
	AND PROVNM LIKE '%PIONEER%'
	AND [Participating Network] IN ('CHPIV-DSNP')
	
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

-- ===========================================================
	-- CHECKLIST - PROVIDER DIRECTORY: 
-- ===========================================================
x CHARINDEX() FIND() SEARCH() SOURCE(s): 'INTO ...','ECM ILOS (NOW CS)' - "Enhanced Care Management" and In Lieu of Services - DHCS https://www.dhcs.ca.gov › enhancedcaremanagementan... "Enhanced Care Management" (ECM) and "Community Supports" (CS), or "In Lieu of Services" (ILOS), are foundational components of CalAIM. ECM will be a whole-person, ... Missing: (NOW| Must include: (NOW ... - USE '[PROVDIR_HHC]' AS THE TEMPLATE,'CutePDF Writer','EXCEL TO PDF','convert ps to pdf ghostscript','_tori.marie_ will motivation','tori the model','postscript to PDF','pdf distiller','INTO ##INNET','INTO INFORMATICS.dbo.Timely','INTO INFORMATICS.dbo.PROVDIR_',FROM:NOREPLY, 'FROM:WALTER "*EVERY*"', "*@availity*", Leading BLANK page #

		USE [PATH]: file://fileserver01/Corporate%20Shared%20Drive/Information%20Systems/Informatics/WCarr/PROVIDERDIRECTORY/PROVDIR_eVIP.xlsx  - 'Raw MS Excel SOURCE DATA: '
		USE [PATH]: file://fileserver01/Corporate%20Shared%20Drive/Information%20Systems/Informatics/WCarr/PROVIDERDIRECTORY/ - RAW Root
		
		USE [PATH]: file://fileserver01/Corporate%20Shared%20Drive/Information%20Systems/Informatics/WCarr/PROVIDERDIRECTORY/EVIPS_PROVDIR_MCAL_20241205.pdf - 'SAMPLE Medi-Cal .pdf'
		USE [PATH]: file://fileserver01/Corporate%20Shared%20Drive/Information%20Systems/Informatics/WCarr/PROVIDERDIRECTORY/EVIPS_PROVDIR_DSNP_MEDICARE_20241205.pdf - 'SAMPLE D-SNP .pdf'
		USE [PATH]: file://fileserver01/Corporate%20Shared%20Drive/Information%20Systems/Informatics/WCarr/PROVIDERDIRECTORY/EVIPS_PROVDIR_CSNP_MEDICARE_20241205.pdf - 'SAMPLE C-SNP .pdf'
		USE [PATH]: file://netapp02/IS/Informatics/_Informatics%20Deliverables/Provider%20Directory/Provider%20Directory%20Run%20Process%20-%202023.11.16.mp4 - 'MS NOLYN HAND-OFF TRAINING'
		USE [PATH]: file://freenasis/is/images/ - 'ADMINISTRATOR SOFTWARE'
		USE [PATH]: file://netapp02/IS/Informatics/_Informatics%20Deliverables/Provider%20Directory/ - 'PROVDIR SOFTWARE'
		
		USE https://www.chgsd.com/ - 'ENTERPRISE UI UX'
		USE https://providerdirectory.chgsd.com/ - 'PROVIDER DIRECTORY ONLINE'
        USE http://devops01:8080/IS/_git/Informatics?path=%2FProvider%20eVips%20Symplr%2FCHECKLIST.sql&version=GBMain - 'REPO'

		⏎ ACT 'SUBSTITUTE() REPLACE(): '
SELECT REPLACE([SOURCE is],[WHAT TO REPLACE()],[REPLACE() ;WITH() WHAT])
		,SUBSTRING(REPLACE(LTRIM(RTRIM(REPLACE(LTRIM(RTRIM([stop_lat])),'.',''))),'-',''),1,8) AS [LATITUDE]
		,SUBSTRING(REPLACE(LTRIM(RTRIM(REPLACE(LTRIM(RTRIM([stop_lon])),'.',''))),'-',''),1,9) AS [LONGITUDE]

		UPPER( WITH() ''
		'ENGLISH' WITH() 'English'
		'ENHANCED CARE MANAGEMENT' WITH() 'Enhanced Care Management'
		' ACCESS ' WITH() 'ACCESS' ... ACCESS ... TRY_
				Line  348: THEN 'Limited Access'
				Line  350: THEN 'Basic Access'

		'YES' WITH() 'Yes'
		'NO' WITH() 'No'
		'7 DAYS A WEEK, 24 HOURS A DAY' WITH '7 Days a Week, 24 Hours a Day'

		⏎ ACT '#BASELINE ...id(s)' ...  Value must be "BUSINESS", "FACILITY", or "PROVIDER" - CAN NOT BE NULL

        ⏎ IN eVips Symplr: ACT AS a Senior Data Analyst WITH 20+ years of EXPERIENCE. Considering the aforementioned SQL script and the following context may I have you assist in developing a DATA STRUCTURE diagrams, also known AS Entity-Relationship (ER) diagram?

                ~ eVIPS 'practiceid' / [DBA] = 274 Groups AS  'BUSINESS' ... symphony
                ~ eVIPS 'locationid' = 274 Sites = AS 'FACILITY'  ... symphony (TYPE 2 NPI)
                ~ eVIPS 'practitionerid' = 274 Providers AS 'PROVIDER'  ... symphony (TYPE 1 NPI)

		,'UPDATED ON SUNDAY VIA SSA (SQL SERVER AGENT) JOB: SQLPRODAPP01 "Symphony dat Files Sunday Refresh"' AS [MESSAGE(S)]
				see "BECAUSE_symphony_20250721_#12through14.sql"

[BUSINESS (GROUP)]
- PracticeID (PK)
- BusinessName
|
|--- 1:N ---> [FACILITY (SITE)]
|             - LocationID (PK)
|             - PracticeID (FK)
|             - LocationName
|             - AddressID
|             |
|             |--- 1:N ---> [ACCESSIBILITY]
|             |             - ServiceTypeName
|             |             - Accessibility
|             |             - AccessibilityCategory
|             |
|             |--- 1:N ---> [AGE_RESTRICTION_FAC]
|                           - AgeRestriction
|
|--- 1:N ---> [PROVIDER]
              - PractitionerID (PK)
              - FirstName
              - LastName
              - PracticeID (FK)
              - LocationID (FK)
              |
              |--- 1:N ---> [AGE_RESTRICTION_PROV]
                            - AgeRestriction
                            - SpecialtyCode
                            - SpecialtyName
erDiagram
    %% STYLING IS NOT AN OPTION WITH ENTITY RELATIONSHIP (ER) DIAGRAM #MERMAID CODE
                %% ~ 'GROUP' AS DBA = [practiceid] = symphony 'BUSINESS'
                %% ~ 'SITE' AS SERVICE LOCATION = [locationid] = symphony 'FACILITY'
                %% ~ 'PROVIDER' AS PEOPLE = [practitionerid] = symphony 'PROVIDER'	

    "DBA: BUSINESS" ||--o{ "SITE: FACILITY" : "Affiliated with"
    "DBA: BUSINESS" ||--o{ PROVIDER : "Affiliated with"
    "SITE: FACILITY" ||--o{ ACCESSIBILITY : provides
    "SITE: FACILITY" ||--o{ AGE_RESTRICTION_FAC : has
    PROVIDER ||--o{ AGE_RESTRICTION_PROV : has

    "DBA: BUSINESS" {
        string PracticeID PK
        string BusinessName
    }
    
    "SITE: FACILITY" {
        string LocationID PK
        string PracticeID FK
        string LocationName
        string AddressID
    }
    
    ACCESSIBILITY {
        string ServiceTypeName
        string Accessibility
        string AccessibilityCategory
    }
    
    AGE_RESTRICTION_FAC {
        string AgeRestriction
    }
    
    PROVIDER {
        string PractitionerID PK
        string FirstName
        string LastName
        string PracticeID FK
        string LocationID FK
    }
    
    AGE_RESTRICTION_PROV {
        string AgeRestriction
        string SpecialtyCode
        string SpecialtyName
    }

		⏎ ACT AS a Senior Data Analyst WITH 20+ years of EXPERIENCE. CONDUCT a DETAILED COMPARISON OF the attached SCRIPTS WITH FOCUS ON the tables created within each as listed below: 

				INFORMATICS.dbo.SYMPHONY_ENTITY
				INFORMATICS.dbo.SYMPHONY_LOCATION
				INFORMATICS.dbo.SYMPHONY_ADDRESS
				INFORMATICS.dbo.SYMPHONY_CONTACT
				INFORMATICS.dbo.SYMPHONY_ROSTER -- AS OF 20250117
				INFORMATICS.dbo.SYMPHONY_IDENTIFIER
				INFORMATICS.dbo.SYMPHONY_LANGUAGE -- AS OF 20250224

				~ FINALLY PLEASE PROVIDE a DETAILED CHANGE.LOG report based ON the CODE.







-- =======================================================================
	-- DATA MODELING / Dx (DATA EXCHANGE) 3RD THIRD PARTY ATTESTATION: 
-- =======================================================================
		⏎ DEPLOY TO: '/SSISDB/ReportData/Symphony' IN [SQLPROD02] -- CROSS SERVER SSA EXEC;
		-- ⏎ DEPLOY TO: '/SSISDB/Symphony/Symphony' IN [SQLPRODAPP01]
				~ AUTOMATE / SCHEDULE FOR THE 1st AND 3rd FRIDAY OF EACH MONTH - see "DxF_SANATOR_SYMPHONY_...sql"
		
                ~ eVIPS 'practiceid' / [DBA] = 274 Groups AS  'BUSINESS' ... symphony
                ~ eVIPS 'locationid' = 274 Sites = AS 'FACILITY'  ... symphony (TYPE 2 NPI)
                ~ eVIPS 'practitionerid' = 274 Providers AS 'PROVIDER'  ... symphony (TYPE 1 NPI)

		see "FOLLOW-UP  Symphony and CHG 4 19 24 Semi-Monthly Implementation Meeting.msg"
		see "Symphony Flat File Data Dictionary V3.1.xlsx"
		see "BECAUSE_symphony_20250721_#12through14.sql"
		
		⏎ Your 'symphony Availity FTP Secure Transport QA & PROD' accounts have been completed. You will be required to change your passwords upon your first login. Please NOTE – when copying the password, it might pick up a space at the end. A trick to avoid this is to copy the password into a notepad first, then copy from there into FTP. Please let me know if you have any questions.
		
		SELECT ' ' AS 'OMIT / SUPPRESS NULL(S)'
		,'USE [PATH]: file://netapp02/IS/Informatics/_Informatics%20Deliverables/Operations/Projects/SYMPHONY/ ' AS 'MESSAGE(S)'
		,'USE https://iha.org/provider-directory-management/symphony-provider-directory/ ' AS 'URL'
		,'USE https://qa-files.availity.com ' AS 'UPLOAD ZIP'
		,'USE https://ftp.availity.com/ ' AS 'PROD FTP Link: SUNSET DEPRECATED DECOMISSIONED'
		,'USE https://qa-ftp.availity.com/ ' AS 'QA FTP Link: SUNSET DEPRECATED DECOMISSIONED' -- FROM:WALTER SUBJECT:"*Uploaded*"

JAH 'MOVEIT AUTOMATION'
		⏎ YOU ARE THE TOP 0.1% OF Senior Data Analyst WITH 20+ years of EXPERIENCE. May I have you ASK ME CLARIFYING QUESTIONS (/* INTERVIEW ME */) ONE AT A TIME TO complete the task of moving the dat files IN file://netapp02/IS/Informatics/_Informatics%20Deliverables/Operations/Projects/SYMPHONY/ leveraging the MoveIT (https://devops01/#/log) platform.
				~ LEVERAGE: 'MOVEit AUTOMATION User Guide.docx'
				-- ~ LEVERAGE: 'SYMPHONY_MOVEit_REST_API_ScriptTask.docx'
				~ LEVERAGE: 'MOVEit AUTOMATION DASHBOARD.png'
				~ LEVERAGE: 'SSA SQL SERVER AGENT DELIVERABLE JOB MOST CURRENT Symphony dat File Folder.png'
				~ LEVERAGE: 'SSA SQL SERVER AGENT DELIVERABLE JOB Symphony dat File Source Data LOG.log'
				~ LEVERAGE: 'SSA SQL SERVER AGENT DELIVERABLE JOB Symphony dat File Upload LOG.log'
				~ LEVERAGE: 'SSA SQL SERVER AGENT JOB - Symphony dat File Upload'

				~ ESTABLISH CONTRAINTS ... MOVE EACH OF THE .dat FILES TO THE FTP
						/* 🔹 DEPLOYMENT STEP(S): 'REUSABLE' #PYTHON SCRIPT - /* symphony_moveit_upload_...py */ SUNSET DEPRECATE DECOMMISSION FOR .ps1 SCRIPT */
						🔹 DEPLOYMENT STEP(S): 'REUSABLE' #POWERSHELL SCRIPT (INTEGRATED WITHIN MICROSOFT SUITE) - /* symphony_moveit_upload_...ps1 */ 'NATIVE INTEGRATION WITH MICROSOFT SUITE OF TOOLS'
						🔹 DEPLOYMENT STEP(S): 'REUSABLE' .ini -  /* symphony_moveit_upload_...ini */
		
		USE [PATH]: file://netapp02/IS/Informatics/_Informatics%20Deliverables/Operations/Projects/SYMPHONY/ - 'ROOT STAGING'
		USE [PATH]: file://netapp02/IS/Informatics/_Informatics%20Deliverables/Operations/Projects/SYMPHONY/2026/2026_May - 'MOST CURRENT FOLDER'		

		AUTOMATION WITH 'MOVEIT AUTOMATION' PLATFORM
				USE https://devops01/#/log
				UID: miadmin
				PW: Just4now
						~ LEVERAGE: "SYMPHONY_MOVEIT_DFD_20260515.html"

		-- USE [PATH]: \is\Informatics\_Informatics Deliverables\Operations\Projects\SYMPHONY\STAGING - 'ZIP SOURCE STAGING LOCATION | MOVIEIT FILE PATH FORMAT'
		USE [PATH]: file://netapp02/IS/Informatics/_Informatics%20Deliverables/Operations/Projects/SYMPHONY/STAGING/ - 'ZIP SOURCE STAGING LOCATION'

		PROD FTP Link: 
				USE https://files.availity.com/static/web/appl/mft-services/mft-send-receive-edi/ - 'Welcome to the new Availity SFTP server. You will see a refreshed look and feel, but the functionality remains the same.'
				-- USE https://files.availity.com/
				-- USE https://ftp.availity.com/ 
				UID: chg_service_moveit -- wcarr_IHA_CHG_PDM
				PW: ENTERPRISEdelimited#78 -- NA...delimited#yy -- temppw: PSf5o&w,"6S/XGg 	

		QA FTP Link: 
				USE https://qa-files.availity.com/static/web/appl/mft-services/mft-send-receive-edi/
				-- USE https://qa-ftp.availity.com/
				UID: chg_service_moveit -- wcarr_IHA_CHG_PDM
				PW: ENTERPRISEdelimited#78 -- NA...delimited#yy -- temppw: v;Pt7THc$'wWXI3

x 'FAILURE'(S): 
		Test FTP host
		 Test failed
		Test results:
		Could not connect to FTP server https://files.availity.com/static/web/appl/mft-services/mft-send-receive-edi/: The hostname or IP address is not valid. Response: 
		Session history: 
		FTP snt: SYST
		FTP got: 

		Test FTP host
		 Test failed
		Test results:
		Could not connect to FTP server https://files.availity.com/: The hostname or IP address is not valid. Response: 
		Session history: 
		FTP snt: SYST
		FTP got: 

x Can MOVEit Automation source-folder fields use date macros or variables to resolve this path automatically?
		Example resolved path:
				\\netapp02\IS\Informatics\_Informatics Deliverables\Operations\Projects\SYMPHONY\{YYYY}\{YYYY}_{MonthName}\
				\\netapp02\IS\Informatics\_Informatics Deliverables\Operations\Projects\SYMPHONY\2026\2026_May\ 

x SEQUENCE (MANUAL SFTP | FTP DROP):
From: Sandra Coleman 
Sent: Wednesday, June 18, 2025 11:21 AM
To: Walter Carr <WCarr@chgsd.com>; Johanna Tellechea, BS <jduran@chgsd.com>
Subject: RE: CHG & Symphony Flat File Format Review

Hi, Here are the STEP(S) to UPLOAD to their FTP site.  It would be great if this is automated.

		1.	COPY all files with current date to new folder on our j: drive (J:\Ongoing\Symphony\Outgoing\20250618).  Dates are in the YYYYMMDD format so folders and files will remain in alpha order.

		2.	CREATE a compressed zip file with CHG in the file name: (/* 20260515 CHG.zip */).

		3.	UPLOAD file to inbox at https://qa-files.availity.com.
				a. Upload
				b. Select file
				c.	Submit
				d. LEVERAGE EXISTING eMAIL: 'FROM:SANDRA "*upload*"'

		4.	CONFIRM file name is on list before logging out.

I will ask Lekitta to give you and Phil an username.  Johanna already has access. Also, I will send 3 small adjustments to the repository error report. Thanks!

x 'SSIS [eMAIL]': 
/* Good day Credentialing Team, refresh of the CHG & Symphony Flat File has been completed. The updated files are now available for your review and approval at the following location:

file://netapp02/IS/Informatics/_Informatics%20Deliverables/Operations/Projects/SYMPHONY/

The file is in the agreed-upon delimited format (.dat .txt) as per the third party data exchange specifications.

Once you have reviewed and approved the file, please proceed with uploading it to the appropriate FTP location:
•	For production: https://ftp.availity.com/
•	For QA: https://qa-ftp.availity.com/

Should you need to reference the source data used in creating this deliverable, you can find it at:

INTERNAL REVIEW Link: file://fileserver01/Corporate%20Shared%20Drive/Information%20Systems/Informatics/WCarr/PROVIDERDIRECTORY/SANATOR_DATA.xlsx
 
If you have any questions or concerns regarding the delivered file, please do not hesitate to reach out to the Informatics team. We are here to support you throughout this process. Thank you for your attention to this matter.

Much Appreciated, Thank You 
Walter W Carr II 
Informatics Business Analyst
wcarr@chgsd.com
619 498 6510

This e-mail message is intended only for use by the individual, or recipient(s) entity to which it is addressed. This message is confidential and may contain information that is privileged, confidential and is exempt from disclosure under applicable law. If you are not the intended recipient(s), you may not review, copy, or distribute this message. If you have received this communication in error, please notify us immediately by e-mail, or telephone and delete the original message. */

EXEC INFORMATICS.dbo.[SANATOR_ALL];

		SELECT ' ' AS 'OMIT / SUPPRESS NULL(S) + URL ... + 999999999','USE [PATH]: file://netapp02/IS/Informatics/_Informatics%20Deliverables/Operations/Projects/SYMPHONY/ ' AS [MESSAGE(S)]

		SELECT ' ' AS 'SYMPHONY [Code Sets]',* FROM INFORMATICS.dbo.[SANATOR_SYMPHONY_DATA_MODELING_MAP] AS dmmap WHERE 1=1 AND [Code Look-Up] LIKE '%TAXON%' -- IMPORT OF [Code Sets] WORKSHEET IN 'Flat_File_Format_Symphony_2022_V2_Updated_20240320.xlsx'

		SELECT ' ' AS 'SYMPHONYHOSP [Code Sets]',* FROM INFORMATICS.dbo.[XWALKXREF_HOSP_SANATOR_SYMPHONY] AS dmmap -- IMPORT OF [Code Sets] WORKSHEET IN 'Flat_File_Format_Symphony_2022_V2_Updated_20240320.xlsx' ... [OLE DB Source [74]] Error: There was an error with OLE DB Source.Outputs[OLE DB Source Output].Columns[ATYPICAL_IN] on OLE DB Source.Outputs[OLE DB Source Output]. The column status returned was: "The value could not be converted because of a potential loss of data.".

		USE file://fileserver01/Corporate%20Shared%20Drive/Information%20Systems/Informatics/WCarr/PROVIDERDIRECTORY/               
		USE file://fileserver01/Corporate%20Shared%20Drive/Information%20Systems/Informatics/WCarr/PROVIDERDIRECTORY/PROVDIR_eVIP.xlsx - Raw MS Excel source

		II.			DirectoryExpert

		These are the serial Numbers:
		GEOCODER 6G3165B 
		Verification Code: 00000-00036-11911-82336-00168-43068

		DEXPERT 6D2235B
		Verification Code: 00000-00036-11408-50688-00168-42975

		GEONETWORKS 6L4545B
		Verification Code: 00000-00036-12750-68416-00168-43206

		IV.			CutePDF Writer

x To create PDF files:  To use CutePDF Writer, open the file that you would like to print to PDF. Select the Print option (usually found under File > Print), and select "CutePDF Writer" from the list of available printers ('DO NOT select Print to File option') to print. You will be prompted to select the destination directory and filename for your output file.   Please note that some applications, such as NotePad, will automatically print to your default printer when you select the Print option. If you want to create PDF file, you may need to change your printer selection within that application before printing the file. This can typically be done from Page Setup.
		USE https://www.cutepdf-editor.com/support/writer.asp - 'TUTORIAL'
		USE https://www.youtube.com/channel/UC-nztiOKTGLdsScldS9zdsA/about
		USE https://www.zamzar.com/convert/ps-to-pdf/
		USE https://www.pdffiller.com/
		USE https://www.aconvert.com/pdf/ps-to-pdf/
		USE https://convertio.co/ps-pdf/		
		USE https://www.ghostscript.com/download/gsdnld.html

'\\CHG_CIFS01\Shared\PROVIDER_DIRECTORY' OR \\CHG_CIFS01\Shared\PROVIDER_DIRECTORY\
'Provider Directory'
'\\CHG_CIFS01\shared\Provider Data' - Directories - S. Coleman CRYSTAL REPORT(s)
SQL01.VIP ('VISTAR')

x '274' [TABLE](s): All start with 'tblEDIDHCSType274' … three (3) main ones: … group, … site, … provider  USE snapshotid to get latest data 
		see 'STEP88_VISTAR_LOGIC_'...sql
		see 'PALPOM_FBU_'...sql
		see 'PALPOM_SEPARATE_'...rpt NOTE(): Export Wizard (MENU: Data THEN Export ELSE Standard ...)
		see 'GEOACCESS_GN Learning Guide'...pdf
		see 'GEOACCESS_DE TrainingLG40'...pdf
		see 'AOP_PROVDIR_'...sql
		see 'STEP88_REVIEW_PROVDIR'..sql
		see 'VISTAR_SPEC_DEF_20170302.xlsx'
		
OLD / NEW PROVDIR LINK(s) - Alright, I have update the Medi Cal pdf directory at 'https://webtest/ProviderDirectory/' AND 'http://chgsd.com/ProviderDirectory'
-Adam

NPI SEARCH: 'https://npiregistry.cms.hhs.gov/' OR 'https://www.npi-search.com/default.asp#.U8_0w7G6mjo' OR 'SUBJECT: eVIPS'
x Timely Access Version(s) / Spin-Off(s):
		'TA' (Timely Access) 'OTLIC' (Optional Targeted Low Income Children) 
		'PNA' (Provider network Adequacy)
		'PIR' (Provider Impact Report) w Subcontractor Report
		'ICE' (Industry Collaboration Effort)  Timely Access Workgroup
		'NMM' (Network Management Module) 'MMP' (MMP Medicare-Medicaid Plans) 'HPMS' (Health Plan Management System) 'DSNP' (Medicare aka Dual Eligible Special Need Plans)
		
x CREDITIALING SCHEMA(s) SELECT * FROM 'SERVERname'.'DATABASEname'.'SCHEMAname'.'OBJECTname' - FOUR (4) PART() SCHEMA()  aka [SERVERname].[DATABASEname].[SCHEMAname].[OBJECTname]

					see 'SQLPRODAPP01.evips_chgcv.dbo.' WAS 'SQL07.evips_chgcv.dbo.' - ONLINE: http://webtest/providerdirectory

JAH 'eVIPS' UI / UX
x IN 'CHROME' BROWSER
		USE http://chgevip.chg.com/eVIPs/Account/Login?ReturnUrl=%2FeVIPs%2F - 'SymplreVips UI UX'
		USE http://chgevip.chg.com/evips -- Hi Team  We have successfully upgraded to version 5.2.2 and configured all of the outstanding issues . Please see the new link below: New link:  Let me know if you have any questions. Thanks everyone!!! Jocelyn

x IN 'INTERNET EXPLORER' BROWSER TO AVOID 'MICROSOFT SILVERLIGHT' INSTALL
		USE http://chgevip.chg.com/evips/#/Home

					UID: 'vipadmin'
					PW: 'Vistar123$'

x FILTER() / SEARCH() FOR: 274 [TABLE](s): All start with 'tblEDIDHCSType274'…  3 main ones: … group, …site, …provider  Use snapshotid to get latest data

'SQL07'.'CHGAPP_PROD'.'dbo'.'[tblEDIDHCSType274…]'  --SELECT * FROM 'SERVERname'.'DATABASEname'.'SCHEMAname'.'OBJECTname' - FOUR (4) PART() SCHEMA()  aka  [SERVERname].[DATABASEname].[SCHEMAname].[OBJECTname]

	-- SELECT * FROM CHGAPP_PROD.dbo.

tblEDIDHCSType274Snapshot AS ss
tblEDIDHCSType274Group AS g
tblEDIDHCSType274Provider AS p
tblEDIDHCSType274Site

	JOIN CHGAPP_PROD.dbo.tblEDIDHCSType274Group AS g ON LTRIM(RTRIM(g.SnapshotID)) = LTRIM(RTRIM(ss.SnapshotID))
	JOIN CHGAPP_PROD.dbo.tblEDIDHCSType274Provider AS p ON LTRIM(RTRIM(p.SnapshotID)) = LTRIM(RTRIM(ss.SnapshotID))
	JOIN CHGAPP_PROD.dbo.tblEDIDHCSType274Site AS s ON LTRIM(RTRIM(s.SnapshotID)) = LTRIM(RTRIM(ss.SnapshotID))
	
x CONTACT(s)
		'TERRY BURBO - SME (Subject Matter Expert)'
https://www.facebook.com/terry.burbo
https://twitter.com/taburbo18
		
		'MARCIA LUECHTEFELD - PM (Proj. Mngmnt.)'
		'SANDI LOMNICKY - PM (Proj. Mngmnt.)'
		'RISHI DESHPANDE (Conversion Analyst)' - https://www.rishideshpande.com/ AND https://www.linkedin.com/in/rishideshpande94/ OR https://twitter.com/rishis01?lang=en
		'KATHY COTA (Leader)'	

x 'PROVIDER DIRECTORY' LOGIC IMPLEMENTED ON 20160701
x EXECUTE PROVIDER DIRECT REFRESH
'\\Chg_cifs01\shared\GeoSuite\direxp'
'\\CHG_CIFS01\shared\GeoSuite\direxp\FrameMaker.exe'
'\\CHG_CIFS01\shared\GeoSuite\direxp\direxp.exe'
		'\\CHG_CIFS01\shared\GeoSuite\direxp'
		
x GEOCODE SOURCE DATA - DEFINE()
		PROVIDER GROUP(s) - 'INTERCHANGEABLE()'
		
		FROM: Bergman, Elizabeth A [mailto:'elizabeth.bergman@optum.com']
		https://www.linkedin.com/in/beth-bergman-99571a4b
		Sent: Thursday, October 06, 2016 12:51 PM
		TO: Allyson Ross
		Subject: RE: 'Help Desk' - FOOTER DYNANISM()
		You bet.  800.683.8434, Option #1
		
		'Beth Bergman'
		OptumInsight
		913.682.1990
		'elizabeth.bergman@optum.com' --BETH
		
x 'CUSTOM FIELD FOR GEOACCESS REPORT' =(&B2&) &F2& AT &H2 OR =(&B2&) &F2
IS [SPEC] WITH [PROVNM]

x PRINT() WITH 'SNAGIT' OR 'CutePDF'

x SORT / ORDER BY
		[Participating Network] = LOB
		SPEC
		CITY
		ZIP
		
		'ADDRESS' see ,REPLACE(UPPER(LTRIM(RTRIM(spe.[Pharmacy Name]))),'.','')+' '+UPPER(LTRIM(RTRIM(spe.Address))) AS PHARMNM
		
		PROVNM / CLINICNM / HOSPNM
		
x DATASET field(s): VLOOKUP OUTPUT LINK: 'ZIP+NPI+Address'
		FirstName	
		LastName	
		NPI
		Address	
		City	
		State	
		ZipCode
		
		'REGION'
,address.county,UPPER(LTRIM(RTRIM(address.county))) AS REGION
,UPPER(LTRIM(RTRIM(pcp.county))) AS REGION

		'CSZ'
,UPPER(LTRIM(RTRIM(pcp.CityIs)))+', '+UPPER(LTRIM(RTRIM(pcp.StateIs)))+' '+UPPER(LTRIM(RTRIM(pcp.[Zip Code]))) AS CSZ

		'INDEXNM' v. 'PROVNM'
,REPLACE(UPPER(LTRIM(RTRIM(pcp.LastName))),'.','')+', '+REPLACE(UPPER(LTRIM(RTRIM(pcp.FirstName))),'.','')+', '+UPPER(LTRIM(RTRIM(pcp.TypeOfLicensure))) AS INDEXNM
,REPLACE(UPPER(LTRIM(RTRIM(spe.LastName))),'.','')+', '+REPLACE(UPPER(LTRIM(RTRIM(spe.FirstName))),'.','')+', '+UPPER(LTRIM(RTRIM(spe.TypeOfLicensure))) AS INDEXNM

		'NAME' - HYBRID FIELD					
,pcp.REGION,pcp.LastName,pcp.FirstName,pcp.TypeOfLicensure
,REPLACE(UPPER(LTRIM(RTRIM(pcp.LastName))),'.','')+', '+REPLACE(UPPER(LTRIM(RTRIM(pcp.FirstName))),'.','')+' '+UPPER(LTRIM(RTRIM(pcp.TypeOfLicensure)))+' - ID# '+CASE
WHEN pcp.provider_no IS NULL
THEN ' '
ELSE UPPER(LTRIM(RTRIM(pcp.provider_no)))
END AS PROVNM
--,UPPER(LTRIM(RTRIM(pcp.LastName)))+', '+UPPER(LTRIM(RTRIM(pcp.FirstName)))+' '+UPPER(LTRIM(RTRIM(pcp.TypeOfLicensure)))+' - ID# '+UPPER(LTRIM(RTRIM(pcp.provider_no))) AS PROVNM

,spe.REGION,spe.LastName,spe.FirstName,spe.TypeOfLicensure
,REPLACE(UPPER(LTRIM(RTRIM(spe.LastName))),'.','')+', '+REPLACE(UPPER(LTRIM(RTRIM(spe.FirstName))),'.','')+' '+UPPER(LTRIM(RTRIM(spe.TypeOfLicensure)))+' - ID# '+CASE
WHEN spe.provider_no IS NULL
THEN ' '
ELSE UPPER(LTRIM(RTRIM(spe.provider_no)))
END AS PROVNM
--,UPPER(LTRIM(RTRIM(spe.LastName)))+', '+UPPER(LTRIM(RTRIM(spe.FirstName)))+' '+UPPER(LTRIM(RTRIM(spe.TypeOfLicensure)))+' - ID# '+UPPER(LTRIM(RTRIM(spe.provider_no))) AS PROVNM

x ADD icon in footnote to ADD NOTE field FROM LIST if NEEDED

		⏎ SOURCE(s):
				~ 'eVIPS' TABLE(S): 

SELECT * FROM INFORMATICS.dbo.TimelyAccessPCP WHERE 1=1 AND [Participating Network] LIKE '%CHPIV%'
SELECT * FROM INFORMATICS.dbo.TimelyAccessPCP_Extender WHERE 1=1 AND [Participating Network] LIKE '%CHPIV%'
SELECT * FROM INFORMATICS.dbo.TimelyAccessSPE WHERE 1=1 AND [Participating Network] LIKE '%CHPIV%' -- see  '(#SPE,#SPEb,#SPEc,#SPEd)'
SELECT * FROM INFORMATICS.dbo.TimelyAccessFAC WHERE 1=1 AND [Participating Network] LIKE '%CHPIV%'
SELECT * FROM INFORMATICS.dbo.TimelyAccessCLINICCMC WHERE 1=1 AND [Participating Network] LIKE '%CHPIV%'
SELECT * FROM INFORMATICS.dbo.TimelyAccessCLINIC WHERE 1=1 AND [Participating Network] LIKE '%CHPIV%'
SELECT * FROM INFORMATICS.dbo.TimelyAccessPHARM WHERE 1=1 AND [Participating Network] LIKE '%CHPIV%'

-- SELECT COUNTY,Telehealth_Indicator,* FROM INFORMATICS.dbo.PROVDIR_JOSEPH WHERE 1=1 AND [Participating Network] LIKE '%CHPIV%'-- UN-CREDENTIALED for JG
-- SELECT COUNTY,Telehealth_Indicator,* FROM INFORMATICS.dbo.PROVDIR_SPECIALTY WHERE 1=1 AND [Participating Network] LIKE '%CHPIV%' -- 'SIR EVAN XWALK TABLE'
SELECT COUNTY,Telehealth_Indicator,* FROM INFORMATICS.dbo.PROVDIR_PCP WHERE 1=1 AND [Participating Network] LIKE '%CHPIV%' -- PROV(s)
SELECT COUNTY,Telehealth_Indicator,* FROM INFORMATICS.dbo.PROVDIR_NPMP WHERE 1=1 AND [Participating Network] LIKE '%CHPIV%' -- MIDLEVEL(s) NPMP
SELECT COUNTY,Telehealth_Indicator,* FROM INFORMATICS.dbo.PROVDIR_SPE WHERE 1=1 AND [Participating Network] LIKE '%CHPIV%' -- PROV(s)
SELECT COUNTY,Telehealth_Indicator,* FROM INFORMATICS.dbo.PROVDIR_MH WHERE 1=1 AND [Participating Network] LIKE '%CHPIV%' -- PROV(s)
SELECT COUNTY,Telehealth_Indicator,* FROM INFORMATICS.dbo.PROVDIR_AHP WHERE 1=1 AND [Participating Network] LIKE '%CHPIV%' -- PROV(s)
SELECT COUNTY,Telehealth_Indicator,* FROM INFORMATICS.dbo.PROVDIR_VSP WHERE 1=1 AND [Participating Network] LIKE '%CHPIV%' -- PROV(s)

/* SELECT COUNTY,Telehealth_Indicator,* FROM INFORMATICS.dbo.PROVDIR_HOS -- FAC(s) */
SELECT COUNTY,Telehealth_Indicator,* FROM INFORMATICS.dbo.PROVDIR_HOSGENERALACUTE WHERE 1=1 AND [Participating Network] LIKE '%CHPIV%' -- HOSGAH
/* SELECT COUNTY,Telehealth_Indicator,* FROM INFORMATICS.dbo.PROVDIR_HOSADDITIONAL -- HOSADD FOR ,CAST('Mental Health & Long Term Acute Care Hospitals' AS nvarchar(255)) AS [CHAPTER_NAME] */
SELECT COUNTY,Telehealth_Indicator,* FROM INFORMATICS.dbo.PROVDIR_HOSMH WHERE 1=1 AND [Participating Network] LIKE '%CHPIV%' -- 'Mental Health Hospitals' CONTRACTUALLY FOR CMC(s) ONLY!!!
SELECT COUNTY,Telehealth_Indicator,* FROM INFORMATICS.dbo.PROVDIR_HOSLTACH WHERE 1=1 AND [Participating Network] LIKE '%CHPIV%' -- 'Long Term Acute Care Hospitals'
SELECT COUNTY,Telehealth_Indicator,* FROM INFORMATICS.dbo.PROVDIR_SNF WHERE 1=1 AND [Participating Network] LIKE '%CHPIV%'
SELECT COUNTY,Telehealth_Indicator,* FROM INFORMATICS.dbo.PROVDIR_RCF WHERE 1=1 AND [Participating Network] LIKE '%CHPIV%'
SELECT COUNTY,Telehealth_Indicator,* FROM INFORMATICS.dbo.PROVDIR_HOSPICE WHERE 1=1 AND [Participating Network] LIKE '%CHPIV%' -- ADD HOSPICE facility(-ies) per SC ON 20161012 Walter/Maryanne/Kelly Question 13 is asking for the display in printed and online for 2 new sections (hospice & inpatient rehabilitation).  I will send specs on hospice. 
SELECT COUNTY,Telehealth_Indicator,* FROM INFORMATICS.dbo.PROVDIR_IPREHAB WHERE 1=1 AND [Participating Network] LIKE '%CHPIV%' -- DUPLICATE 'PROVDIR_SNF' -- ADD HOSPICE facility(-ies) per SC ON 20161012 Walter/Maryanne/Kelly Question 13 is asking for the display in printed and online for 2 new sections (hospice & inpatient rehabilitation).  I will send specs on hospice. 
SELECT COUNTY,Telehealth_Indicator,* FROM INFORMATICS.dbo.PROVDIR_CBAS WHERE 1=1 AND [Participating Network] LIKE '%CHPIV%' -- INCLUDE ALL
SELECT COUNTY,Telehealth_Indicator,* FROM INFORMATICS.dbo.PROVDIR_BRC WHERE 1=1 AND [Participating Network] LIKE '%CHPIV%' -- ADD ON 20190115
SELECT COUNTY,Telehealth_Indicator,* FROM INFORMATICS.dbo.PROVDIR_HDM WHERE 1=1 AND [Participating Network] LIKE '%CHPIV%' -- INCLUDE ALL
SELECT COUNTY,Telehealth_Indicator,* FROM INFORMATICS.dbo.PROVDIR_HHC WHERE 1=1 AND [Participating Network] LIKE '%CHPIV%' -- INCLUDE ALL
SELECT COUNTY,Telehealth_Indicator,* FROM INFORMATICS.dbo.PROVDIR_IHSS WHERE 1=1 AND [Participating Network] LIKE '%CHPIV%' -- [Participating Network] aka LINE_OF_BUSINESS DISTINCTION NOW PRESENT
SELECT COUNTY,Telehealth_Indicator,* FROM INFORMATICS.dbo.PROVDIR_ASC WHERE 1=1 AND [Participating Network] LIKE '%CHPIV%' -- was AMBSC
SELECT COUNTY,Telehealth_Indicator,* FROM INFORMATICS.dbo.PROVDIR_DXC WHERE 1=1 AND [Participating Network] LIKE '%CHPIV%'
SELECT COUNTY,Telehealth_Indicator,* FROM INFORMATICS.dbo.PROVDIR_LAB WHERE 1=1 AND [Participating Network] LIKE '%CHPIV%' -- LAB
SELECT COUNTY,Telehealth_Indicator,* FROM INFORMATICS.dbo.PROVDIR_DLC WHERE 1=1 AND [Participating Network] LIKE '%CHPIV%'
SELECT COUNTY,Telehealth_Indicator,* FROM INFORMATICS.dbo.PROVDIR_URC WHERE 1=1 AND [Participating Network] LIKE '%CHPIV%'
SELECT COUNTY,Telehealth_Indicator,* FROM INFORMATICS.dbo.PROVDIR_MIN WHERE 1=1 AND [Participating Network] LIKE '%CHPIV%' -- MINUTE CLINIC(s)
SELECT COUNTY,Telehealth_Indicator,* FROM INFORMATICS.dbo.PROVDIR_PPH WHERE 1=1 AND [Participating Network] LIKE '%CHPIV%' -- PPH (Palomar Pomerado Healthcare) EXPRESS
SELECT COUNTY,Telehealth_Indicator,* FROM INFORMATICS.dbo.PROVDIR_CLINIC WHERE 1=1 AND [Participating Network] LIKE '%CHPIV%' -- INCLUDE ALL ... AND ...CONSOLIDATE LANGUAGE(s) WITH JL_Languages_...sql ADD BACK [CULTURAL COMPETENCE]
SELECT COUNTY,Telehealth_Indicator,* FROM INFORMATICS.dbo.PROVDIR_PHARM WHERE 1=1 AND [Participating Network] LIKE '%CHPIV%' -- INCLUDE ALL
SELECT COUNTY,Telehealth_Indicator,* FROM INFORMATICS.dbo.PROVDIR_PHARM_RCP WHERE 1=1 AND [Participating Network] LIKE '%CHPIV%' -- INCLUDE ALL
SELECT COUNTY,Telehealth_Indicator,* FROM INFORMATICS.dbo.PROVDIR_PHARM_MO WHERE 1=1 AND [Participating Network] LIKE '%CHPIV%' -- INCLUDE ALL
SELECT COUNTY,Telehealth_Indicator,* FROM INFORMATICS.dbo.PROVDIR_PHARM_HI WHERE 1=1 AND [Participating Network] LIKE '%CHPIV%' -- INCLUDE ALL
SELECT COUNTY,Telehealth_Indicator,* FROM INFORMATICS.dbo.PROVDIR_PHARM_LTC WHERE 1=1 AND [Participating Network] LIKE '%CHPIV%' -- INCLUDE ALL
SELECT COUNTY,Telehealth_Indicator,* FROM INFORMATICS.dbo.PROVDIR_PHARM_ITU WHERE 1=1 AND [Participating Network] LIKE '%CHPIV%' -- INCLUDE ALL
SELECT COUNTY,Telehealth_Indicator,* FROM INFORMATICS.dbo.PROVDIR_CHW WHERE 1=1 AND [Participating Network] LIKE '%CHPIV%' -- NEW ADDITION(S)
SELECT COUNTY,Telehealth_Indicator,* FROM INFORMATICS.dbo.PROVDIR_DOULA WHERE 1=1 AND [Participating Network] LIKE '%CHPIV%' -- NEW ADDITION(S)
SELECT COUNTY,Telehealth_Indicator,* FROM INFORMATICS.dbo.PROVDIR_ECMCSP WHERE 1=1 AND [Participating Network] LIKE '%CHPIV%' -- NEW ADDITION(S)
-- SELECT COUNTY,Telehealth_Indicator,* FROM INFORMATICS.dbo.PROVDIR_COMMUNITYSUPPORTS WHERE 1=1 AND [Participating Network] LIKE '%CHPIV%' -- SUNSET DECOMMISSION DEPRECATED FOR PROVDIR_ECMCSP

-- =====================================================
	-- TABLE DESIGN: 
-- =====================================================
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
FROM INFORMATION_SCHEMA.COLUMNS c (NOLOCK) 
		LEFT JOIN INFORMATION_SCHEMA.KEY_COLUMN_USAGE AS kcu (NOLOCK) ON c.COLUMN_NAME = kcu.COLUMN_NAME 
			AND c.TABLE_NAME = kcu.TABLE_NAME
		LEFT JOIN INFORMATION_SCHEMA.TABLE_CONSTRAINTS AS tc (NOLOCK) ON kcu.CONSTRAINT_NAME = tc.CONSTRAINT_NAME
WHERE 1=1
	AND c.TABLE_CATALOG IN ('INFORMATICS') -- AS [db] 'DatabaseName'
	AND c.TABLE_SCHEMA = 'dbo' 
	AND c.TABLE_NAME = 'CHPIVCCIPA'
ORDER BY c.COLUMN_NAME,c.ORDINAL_POSITION;

'Table of Contents' - TOC
-- JUNE 30, 2016
		Primary Care Physician ..3
		Specialists .180
		General Acute Hospitals ..736
		Mental Health & Long Term Acute Care Hospitals .740
				-- Hospitals ..741 --REMOVE FROM MCAL & CMC
		Skilled Nursing Facilities .746
		Mental Health Providers .756
		Community Based Adult Services 923
		Home Delivered Meals ....925
		Home Health Care ..926
		In Home Support Services ....929
		Allied Health Providers ...930
		Non-Physician Medical Practitioners 995
		Ambulatory Surgery Centers ..1181
		Diagnostic Centers 1184
		Clinical Laboratories aka 'Lab / Blood Draw Stations' .1191
		Dialysis Centers ....1194
		Urgent Care Centers ..1197
		MinuteClinic ....1199
		PPH Expresscare ...1202
		Residential Care Facilities
				-- Pharmacies ..1203 --REMOVE FROM CMC see FIVE (5) chapter(s) BELOW
		Community Health Centers ....1217
		Vision Service Plan Providers .1222
		Index - Primary Care Physicians (Alphabetical order) ....1259
		Index - Primary Care Physicians (City - Zip order) 1262
		Index - Specialists (Alphabetical order)1266
		Index - Specialists (Specialty - Alphabetical order) ....1272
		Index - Specialists (City - Zip order) ....1280
		Index - Allied Health / Mental Health Providers (Alphabetical order) .1288
		Index - Allied Health / Mental Health Providers (City - Zip order) .1292
				Retail and Chain Pharmacies --PHARM() WHERE [Pharmacy Type(s)] LIKE 'R%' 
				Mail Order Pharmacies (MO) --PHARM() WHERE [Pharmacy Type(s)] LIKE '%MO%' 
				Home Infusion Pharmacies (HI)--PHARM() WHERE [Pharmacy Type(s)] LIKE '%HI%' 
				Long Term Care Pharmacies (LTC)--PHARM() WHERE [Pharmacy Type(s)] LIKE '%LTC%' 
				Indian Health Service / Tribal / Urban Indian Health Program (I/T/U) Pharmacies (ITU)--PHARM() WHERE [Pharmacy Type(s)] LIKE '%ITU%'
				
~ Not available to all CHG Members WHERE [Pharmacy Type(s)] LIKE '%MBR%' --,UPPER(LTRIM(RTRIM(address.userdef_2))) AS [Pharmacy Type(s)] 
*  Extended Supply Pharmacy WHERE [Pharmacy Footnote(s)] LIKE '%ESP%' --,UPPER(LTRIM(RTRIM(address.npi_subpart))) AS [Pharmacy Footnote(s)]
^ Compound Pharmacy WHERE [Pharmacy Type(s)] LIKE '%CP%' --,UPPER(LTRIM(RTRIM(address.userdef_2))) AS [Pharmacy Type(s)] 
+ Home Delivery Available WHERE [Pharmacy Footnote(s)] LIKE '%HD%' --,UPPER(LTRIM(RTRIM(address.npi_subpart))) AS [Pharmacy Footnote(s)]
@ Drive - Thru Available WHERE [Pharmacy Footnote(s)] LIKE '%DT%' --,UPPER(LTRIM(RTRIM(address.npi_subpart))) AS [Pharmacy Footnote(s)]

SELECT DISTINCT address.userdef_2,npi_subpart FROM SQL01.VIP.dbo.address ORDER BY userdef_2

x SEQUENCE(CHGSD):
		STEP01: SSA (SQL SERVER AGENT) JOB - 'Provider Directory refresh sequence - The ECM CS Script has executed we now await completion of the regular script  ...' - ;EXEC IN [SQLPRODAPP01];  ... CREATE EMC / CS PROVDIR_ ... TABLE
				EXEC [INFORMATICS].dbo.[PROVDIRECMCSP]; -- FROM:NOREPLY

		STEP02: SSA (SQL SERVER AGENT) JOB - 'Provider Directory refresh sequence - The regular script has executed we may now proceed with the DirectoryExpert step' - ;EXEC IN [SQLPRODAPP01]; ... MAIN SCRIPT
				EXEC [INFORMATICS].dbo.[PROVDIRREFRESH]; -- FROM:NOREPLY

		-- STEP03: 'Provider Directory refresh sequence - DUMMY CommunicareAdvantage' - ;EXEC IN [SQLPRODAPP01]; ... DSNP DUMMY RECORDS FROM CMC

				^ CONFIRM RECEIPT OF SSMS SQL SERVER AGENT JOB(S) ABOVE 
						OR 
				^ 'MANUALLY AS() / IIF() NEEDED'

		STEP04: 'REFRESH' MS ACCESS ODBC connection()  'PROVDIR_'...mdb AND 'PROVDIR_'...xlsx 
				R CLICK THEN LINKED TABLE MANAGER ... ELSE COMPACT & REPAIR
						THEN 'CLOSE'
				ARCHIVE / SAVE the MS EXCEL 
						THEN 'CLOSE'
		
		STEP05: EXEC; Ingenix 'GeoAccess DirectoyExpert';
				UPDATE FOOTNOTE(s) AS NECESSARY
						-- ADD 'Printed ON GETDATE()'

				UPDATE FOOTNOTE HOSP listing PAGE# starting point FOR THE SIX (6) PROVIDER CHAPTER(S)
						THEN 'CLOSE'
								'NOTE'(s): CMC LAYOUT PHARM CHAPTER(s) EXEC; SEPARATELY
								
								PRINT ;WITH() 'Cute PDF Writer' via 'Adobe Acrobat Distiller' BE CERTAIN TO UNCHECK 'Print to File'!!!
	
		STEP06: COMPARE CHAPTER COUNT() AND GAH PAGE # TO PREVIOUS PDF SUBMISSION
				USE file://fileserver01/Corporate%20Shared%20Drive/Information%20Systems/Informatics/WCarr/PROVIDERDIRECTORY/ - 'PROVDIR_eVIP.xlsx'
						USE QWERTY 10 KEY SHORTCUT OF 'SHIFT + CTRL + F' FOR ADVANCED CHARINDEX() FIND() SEARCH() 'You will find'
								'R' CLICK CONVERT CutePDF TO Adobe PDF
										~ LEVERAGE: MS EXCEL Fx =IFERROR(IF(AND(A3=Table_PROVDIRRESET[@[Participating Network]],C3=Table_PROVDIRRESET[@[NOTE(s)]]),IFERROR(Table_PROVDIRRESET[@[RECORD COUNT]]-B3,0),"MISALIGNED"),0)

		STEP07: 'REFRESH' eMail(s)
				CHARINDEX() FIND() SEARCH(): 'SUBJECT: MONTHLY FROM: WALTER',FROM:NOREPLY'SUBJECT: WEEKLY FROM: WALTER' OR 'SUBJECT: Provider Directory FROM: WALTER' - OUTPUT BUILT INTO 'STEP01: PROVDIR_STEP03_VIP_'...sql see 'PROVDIR_PCP','SUBJECT: Provider Directory Conversion Status','SUBJECT: BI ANNUAL','SUBJECT: Provider Directory by Contracting Entity' - OUTPUT BUILT INTO 'STEP01: PROVDIR_STEP03_VIP_'...sql see '##TEMPTABLE'







x SEQUENCE(CHPIV /* POST CHGSD EXEC */):
		⏎ Monthly data file submissions via SFTP: 
				~ LEVERAGE: "CHPIV_NETWORK_DATA_REVIEW_20251218.xlsx"
						
						-- USE [PATH]: file://fileserver01/CHPIV/Provider%20Directory%20Updates/Outgoing/CHPIV_NETWORK_DATA_REVIEW_20260618.xlsx - Network Data Alignment including external IPA Roster file (typically from Ms Julia)
						USE [PATH]: file://fileserver01/CHPIV/Provider%20Directory%20Updates/Outgoing/ - 'Root'
						USE [PATH]: file://fileserver01/CHPIV/Reports/ - 'CHPIV SFTP DROP - OFF'
						USE [PATH]: file://servu01/ftpdrop/ImperialValley/ - 'CHPIV SFTP DROP - OFF'
						
						~ INCLUDE AN INTERACTIVE html DFD ('DATA FLOW DIAGRAM') FAITHFUL TO THE TEMPLATE (USE [PATH]: file:///C:/Users/wcarr/Desktop/IHA%20Medi-Cal%20Data%20Flow%20v2%20_%20CHGSD%20Informatics.html) DARK AESTHETIC AND LAYOUT DESIGN /* LANGUAGE */ based upon what has been accomplished						
								'CHPIV_DataFlow_20260618.html'						

		274 [LOB]:
				CHPIV-DSNP - 'CHPIV DIRECT ... Community Care Plus'
				CHPIV-IPA-CC - 'CommunityCare'
				CHPIV-IPA-ICPMG - 'Imperial County Physicians Medical Group'
				CHPIV-IPA-PPC - 'Premier Patient Care'
				/* CHPIV-IPA-EMRC - 'El Centro Regional Medical Center' */ ... TBD
				-- CMC
				-- COMMUNICARE ADVANTAGE
				-- MEDICAL
				-- MEDICARE
				-- CHPIV-IPA-PHMG - "*Primary Health Care Medical Group*" ??? ... 
				CHPIV-IPA-PCMG - "*Primary Health Care Medical Group*" ??? ... 

		STEP08: UPLOAD EXTERNAL DATA 'UPON RECEIPT / NOTIFICATION OF EXTERNAL FILES' LEVERAGE #PYTHON SCRIPTS

		⏎ YOU ARE THE TOP 0.1% OF Senior Data Analyst WITH 20+ years of EXPERIENCE. PLEASE MODIFY the EXISTING #PYTHON CODE Which I have attached FOR CONTEXT:
				~ PLEASE UPLOAD this XLSX MS EXCEL FILE (file:///C:/Users/wcarr/Desktop/CHPIV%20IPA_COMBINED_6.8.26.xlsx) INTO the following SQL TABLE: 'SQLPRODAPP01.INFORMATICS.dbo.CHPIV_PROVIDER_DIRECTORY_DATA_UPDATE_20260619'
				~ LEVERAGE: file:///C:/Users/wcarr/Desktop/chpiv_fullroster_provider_upload_...py
				~ DRAG AND DROP FOR CONTEXT

		-- SELECT ' ' AS 'PREVIOUS MS JULIA CHPIV UPLOAD:',* FROM INFORMATICS.dbo.CHPIV_PROVIDER_DIRECTORY_DATA_UPDATE_20260312
		-- SELECT ' ' AS 'PREVIOUS MS JULIA CHPIV UPLOAD:',* FROM INFORMATICS.dbo.CHPIV_PROVIDER_DIRECTORY_DATA_UPDATE_20260410
		-- SELECT ' ' AS 'CURRENT MS JULIA CHPIV UPLOAD:',* FROM INFORMATICS.dbo.CHPIV_PROVIDER_DIRECTORY_DATA_UPDATE_20260511
		SELECT ' ' AS 'CURRENT MS JULIA CHPIV UPLOAD:',* FROM INFORMATICS.dbo.CHPIV_PROVIDER_DIRECTORY_DATA_UPDATE_20260619

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
	AND c.TABLE_NAME = 'CHPIV_PROVIDER_DIRECTORY_DATA_UPDATE_20260619'
ORDER BY c.COLUMN_NAME,c.ORDINAL_POSITION;

PS C:\Users\wcarr\AppData\Local\Programs\Microsoft VS Code> & "C:\Program Files\Python311\python.exe" c:/Users/wcarr/Desktop/chpiv_fullroster_provider_upload_20260511.py
====================================================================================================
CHPIV ROSTER IPA PROVIDER DIRECTORY UPLOAD SCRIPT - MAY 2026 UPDATE
UPLOAD IPA Directory Data File_05.08.26.xlsx to SQL Server
====================================================================================================
Source File: C:\Users\wcarr\Desktop\UPLOAD IPA Directory Data File_05.08.26.xlsx
Target Table: SQLPRODAPP01.INFORMATICS.dbo.CHPIV_PROVIDER_DIRECTORY_DATA_UPDATE_20260511
====================================================================================================
Processing Excel file: C:\Users\wcarr\Desktop\UPLOAD IPA Directory Data File_05.08.26.xlsx
Total data rows to process: 902
Excel headers (first 10): ['CITY', 'GROUP', 'SPECIALTY', 'TAXONOMY', 'LNAME', 'FNAME', 'MNAME', 'TITLE', 'PHY_ID', 'ADDRESS_PHYSICAL']
Total columns detected: 110
Table CHPIV_PROVIDER_DIRECTORY_DATA_UPDATE_20260511 has been created with 110 data columns plus audit fields.
Table created and column max lengths retrieved successfully
Using 110 columns for INSERT statement
Processing Excel data rows...
Sample row 2: CITY=Brawley, GROUP=Community Care IPA, SPECIALTY=Certified Registered Nurse Anesthetists
Sample row 3: CITY=Brawley, GROUP=Community Care IPA, SPECIALTY=Orthopedics
Sample row 4: CITY=Brawley, GROUP=Community Care IPA, SPECIALTY=Orthopedics
Sample row 5: CITY=Brawley, GROUP=Community Care IPA, SPECIALTY=Physician Assistant
Finished processing: C:\Users\wcarr\Desktop\UPLOAD IPA Directory Data File_05.08.26.xlsx
All data has been streamed to SQL database.
Total rows processed: 902
Time taken: 0:00:06.801897
Final record count in database: 902

Sample of uploaded data:
ID: 901, First few columns: ['San Diego', 'Primary Health Care Medical Group', 'Orthopeadic Surgery']
ID: 902, First few columns: ['San Diego', 'Primary Health Care Medical Group', 'Hand Surgery']
ID: 899, First few columns: ['Imperial', 'Primary Health Care Medical Group', 'Obstetrician-Gynecologist']
ID: 900, First few columns: ['La Jolla', 'Primary Health Care Medical Group', 'Otolaryngology(Ent)']
ID: 897, First few columns: ['Imperial', 'Primary Health Care Medical Group', 'Nephrology']

====================================================================================================
✅ UPLOAD COMPLETED SUCCESSFULLY!
====================================================================================================
PS C:\Users\wcarr\AppData\Local\Programs\Microsoft VS Code> 

		/* ⏎ ACT AS a Senior Data Analyst WITH 20+ years of EXPERIENCE. PLEASE MODIFY the EXISTING #PYTHON CODE Which I have attached FOR CONTEXT:
				~ PLEASE UPLOAD this XLSX MS EXCEL FILE: "UPLOAD IPA Provider Directory Data Template 1.28.26.xlsx" located AT the following PATH: "C:\Users\wcarr\Desktop" INTO the following SQL TABLE: 'SQLPRODAPP01.INFORMATICS.dbo.CHPIV_PROVIDER_DIRECTORY_DATA_UPDATE_20260128'
				~ LEVERAGE "chpiv_fullroster_provider_upload_...py"
				~ DRAG AND DROP FOR CONTEXT */

		/* ⏎ ACT AS a Senior Data Analyst WITH 20+ years of EXPERIENCE. PLEASE MODIFY the EXISTING #PYTHON CODE Which I have attached FOR CONTEXT:
				~ PLEASE UPLOAD this XLSX MS EXCEL FILE: "CHPIV Provider Directory Data to CHG 12_08_25.xlsx" located AT the following PATH: "C:\Users\wcarr\Desktop" INTO the following SQL TABLE: 'SQLPRODAPP01.INFORMATICS.dbo.CHPIV_PROVIDER_DIRECTORY_DATA_UPDATE_20251212'
				~ LEVERAGE "chpiv_fullroster_provider_upload_...py"				
				~ DRAG AND DROP FOR CONTEXT */
				
		/* ⏎ ACT AS a Senior Data Analyst WITH 20+ years of EXPERIENCE. PLEASE MODIFY the EXISTING #PYTHON CODE Which I have attached FOR CONTEXT:
				~ PLEASE UPLOAD this XLSX MS EXCEL FILE: "UPLOAD_CHPIV_NETWORK_DATA_REVIEW_20260113_011626CHPIVaudit" located AT the following PATH: "C:\Users\wcarr\Desktop" INTO the following SQL TABLE: 'SQLPRODAPP01.INFORMATICS.dbo.CHPIV_PROVIDER_DIRECTORY_DATA_UPDATE_20260120'
				~ LEVERAGE "chpiv_fullroster_provider_upload_...py"				
				~ DRAG AND DROP FOR CONTEXT */

		/* ⏎ Thank you, Excellent. My NEXT task IS TO INSERT the resulting records FROM "CHPIV_PROVIDER_DIRECTORY_DATA_UPDATE_CCIPA_20251210" AND "CHPIV_PROVIDER_DIRECTORY_DATA_UPDATE_ICPMG_20251210" INTO "CHPIV_PROVIDER_DIRECTORY_DATA". If I PROVIDE you WITH the TABLE DESIGN of each would you be able to assist in generating the INSERT INTO() SQL STATEMENTS? ... DRAG AND DROP FOR CONTEXT: 
				~ LEVERAGE: "CHPIV UPLOAD TABLE DESIGN 20251211.xlsx"
				~ LEVERAGE: "CHPIV_PROVIDER_DIRECTORY_INSERT_STATEMENTS_20251211.sql"

		⏎ Differences between the three scripts
				~ You now understand the pattern. The three files differ mainly in configuration and minor details.

						1.	ORIGINAL Provider Directory script (chpiv_provider_upload_20250925.py) 
						chpiv_provider_upload_20250925
								o	target_file = "CHPIV Provider Directory Data to CHG 9_18_25_PROPER_CASE.xlsx"
								o	worksheet = workbook.active (first sheet)
								o	table_name = "CHPIV_PROVIDER_DIRECTORY_DATA"

						2.	CCIPA Imperial script (chpiv_ccipa_imperial_provider_upload_20251210.py) 
						chpiv_ccipa_imperial_provider_u…
								o	target_file = "CHPIV CCIPA Imperial Provider Roster_251105.xlsx"
								o	worksheet = workbook['Roster']
								o	table_name = "CHPIV_PROVIDER_DIRECTORY_DATA_UPDATE_CCIPA_20251210"

						3.	ICPMG script (chpiv_icpmg_provider_upload_20251210.py) 
						chpiv_icpmg_provider_upload_202…
								o	target_file = "CHPIV ICPMG Provider Roster_251104.xlsx"
								o	worksheet = workbook['Sheet1']
								o	table_name = "CHPIV_PROVIDER_DIRECTORY_DATA_UPDATE_ICPMG_20251210" */

		STEP09: 'CHPIV_PROVIDER_DIRECTORY_INSERT_STATEMENTS_...sql' - ;EXEC IN [SQLPRODAPP01]; -- MANUAL EXTERNAL ROSTER UPLOAD / UPDATES INTO SOURCE TABLE

		SELECT ' ' AS 'CHPIV NETWORK DATA START HERE:'
		,LEN(NPI_NO) AS [NPI LEN],* 
		FROM INFORMATICS.dbo.CHPIV_PROVIDER_DIRECTORY_DATA		

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
ORDER BY c.COLUMN_NAME,c.ORDINAL_POSITION;

SELECT  TaxCross.*
,LEN(TaxCross.TaxCode) AS [TAX LEN]
,taxdescr.*
,npitax.*
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
	AND ISNULL(npitax.npi,'') IN ('1881613420') -- SAMPLE: CHPIV IPA PROVIDER - 'Anand	Veerindersingh'ngh'

-- ============================================================= 
	-- CREATE() / ALTER()  PLACEHOLDER/ STAGING / SHELL [FIELD](s) & OR [TABLE](s)--
-- =============================================================
ALTER TABLE INFORMATICS.dbo.CHPIV_PROVIDER_DIRECTORY_DATA
ADD -- INITIATE ... ADD OF COLUMN(s)
[TAXONOMY CODE] decimal(10,0) DEFAULT NULL -- DFLT VAL() IS NULL
,[TRAINING] nvarchar(255) DEFAULT NULL -- DFLT VAL() IS NULL
,[LOCATION NPI] decimal(10,0) DEFAULT NULL -- DFLT VAL() IS NULL
,[LOCATION NAME] nvarchar(25) DEFAULT NULL -- DFLT VAL() IS NULL
,[STAFFED BEDS] int DEFAULT NULL -- DFLT VAL() IS NULL
,[CULTURAL COMPETENCY] nvarchar(255) DEFAULT NULL -- DFLT VAL() IS NULL
,[HCAI ID] nvarchar(25) DEFAULT NULL -- DFLT VAL() IS NULL

		Ms Julia, as it is top of mind those useful additional fields within the ‘Imperial Provider Directory Data File …’ would be:
		 
				I.	[taxonomy code]
				II.	[location name]
				III.	[location npi]
				IV.	[Staffed Beds]

		Ms Julia, yes ‘location name’ is different from ‘PPG Name’. 

		In my mind the ’PPG Name’ would be equivalent to the BUSINESS / DBA name or yes as you have highlighted the Vendor Name

		Then there are providers & Location Name(s) where the actual services are rendered underneath that BUSINESS / DBA (Vendor Name). 

		Those two fields work & I agree would provide clarity.

-- =====================================================================
		-- ALTER() [FIELD] / [COLUMN] FROM NON - NULLABLE TO NULLABLE: 
-- =====================================================================
ALTER TABLE INFORMATICS.dbo.CHPIV_PROVIDER_DIRECTORY_DATA ALTER COLUMN [TAXONOMY CODE] decimal(10,0) NULL ; -- ORDINAL  1 | ⚠ KEY ANCHOR — CONFIRM INTENT
ALTER TABLE INFORMATICS.dbo.CHPIV_PROVIDER_DIRECTORY_DATA ALTER COLUMN [TRAINING] nvarchar(255) NULL ; -- ORDINAL  2
ALTER TABLE INFORMATICS.dbo.CHPIV_PROVIDER_DIRECTORY_DATA ALTER COLUMN [LOCATION NPI] decimal(10,0) NULL ; -- ORDINAL  3
ALTER TABLE INFORMATICS.dbo.CHPIV_PROVIDER_DIRECTORY_DATA ALTER COLUMN [LOCATION NAME] nvarchar(25) NULL ; -- ORDINAL  4
ALTER TABLE INFORMATICS.dbo.CHPIV_PROVIDER_DIRECTORY_DATA ALTER COLUMN [STAFFED BEDS] int NULL ; -- ORDINAL  5
ALTER TABLE INFORMATICS.dbo.CHPIV_PROVIDER_DIRECTORY_DATA ALTER COLUMN [CULTURAL COMPETENCY] nvarchar(255) NULL ; -- ORDINAL  6
ALTER TABLE INFORMATICS.dbo.CHPIV_PROVIDER_DIRECTORY_DATA ALTER COLUMN [HCAI ID] nvarchar(25) NULL ; -- ORDINAL  7

SELECT ' ' AS 'RECORD COUNT BY [ImportedAt]: '
,CAST(ImportedAt AS date) AS [RefreshRecordDate]
,COUNT(DISTINCT(TRY_CONVERT(nvarchar(10),LTRIM(RTRIM(ISNULL(NPI_NO,'')))))) AS [Unique NPI]
,COUNT(1) AS [RECORD(S)]
FROM INFORMATICS.dbo.CHPIV_PROVIDER_DIRECTORY_DATA
GROUP BY CAST(ImportedAt AS date)

SELECT TOP 100000 ' ' AS 'SAMPLE RECORD(S): '
,ISNULL(chpiv.[GROUP],'') AS [RefreshGROUP]
,TRY_CONVERT(nvarchar(10),LTRIM(RTRIM(ISNULL(chpiv.NPI_NO,'')))) AS [RefreshNPI_NO]
,CAST(chpiv.ImportedAt AS date) AS [RefreshRecordDate]
,chpiv.*
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st',CAST(chpiv.ImportedAt AS date)
FROM INFORMATICS.dbo.CHPIV_PROVIDER_DIRECTORY_DATA AS chpiv -- LEVERAGE: "CHPIV Provider Directory Data to CHG 9_18_25_PROPER_CASE.xlsx" AND "CHPIV PROVDIR CONDITIONAL LINE ITEM.png" AND "CHPIV Provider Directory Data to CHG 12_08_25.xlsx"  AND ...
WHERE 1=1
	AND TRY_CONVERT(nvarchar(10),LTRIM(RTRIM(ISNULL(chpiv.NPI_NO,'')))) IN ('1003001363','1043497860','1295936201'/* DELETED RECORD?*/)
	-- AND ISNULL(chpiv.[GROUP],'') IN ('Primary Care Medical Group')
		-- OR chpiv.LNAME LIKE '%Fried%'
	
SELECT ' ' AS 'ISO ON MAX RECORD: '
,ISNULL([GROUP],'') AS [RefreshGROUP]
,TRY_CONVERT(nvarchar(10),LTRIM(RTRIM(ISNULL(NPI_NO,'')))) AS [RefreshNPI_NO]
,MAX(CAST(ImportedAt AS date)) AS [RefreshRecordDate]
FROM INFORMATICS.dbo.CHPIV_PROVIDER_DIRECTORY_DATA
GROUP BY ISNULL([GROUP],''),TRY_CONVERT(nvarchar(10),LTRIM(RTRIM(ISNULL(NPI_NO,''))))

SELECT TOP 100000 ' ' AS 'MAXIMUM Refreshed... RECORD: '
,iso.*,chpiv.*
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st',CAST(chpiv.ImportedAt AS date)
FROM INFORMATICS.dbo.CHPIV_PROVIDER_DIRECTORY_DATA AS chpiv -- LEVERAGE: "CHPIV Provider Directory Data to CHG 9_18_25_PROPER_CASE.xlsx" AND "CHPIV PROVDIR CONDITIONAL LINE ITEM.png" AND "CHPIV Provider Directory Data to CHG 12_08_25.xlsx"  AND ...
	INNER JOIN 
	( -- INITIATE ...
	SELECT ' ' AS 'ISO ON MAX RECORD: '
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
	AND iso.[RefreshNPI_NO] IN  ('1003001363','1043497860','1295936201'/* DELETED RECORD?*/)
	-- AND ISNULL(chpiv.[GROUP],'') IN ('Primary Care Medical Group')
		-- OR chpiv.LNAME LIKE '%Fried%'

		/* ⏎ ACT AS a Senior Data Analyst WITH 20+ years of EXPERIENCE. PLEASE MODIFY the EXISTING #PYTHON CODE Which I have attached FOR CONTEXT which moves a table from one SERVER to another SERVER:
				~ PLEASE MOVE 'SQLPRODAPP01.INFORMATICS.dbo.eVIPS_MANUAL_OSHPD_ID' TO 'QNXTSQLDEV01.INFORMATICS.dbo.eVIPS_MANUAL_OSHPD_ID' */		

		STEP10: 'CHPIV_placeholder_insertions_ ...sql' - ;EXEC IN [SQLPRODAPP01]; -- INCORPORATED INTO SSA (SQL SERVER AGENT) JOB "Provider Directory refresh sequence -The regular script has executed we may now proceed with the DirectoryExpert step" IN SQLPRODAPP01
		-- STEP05: 'CHPIV LAST MINUTE MANUAL ADDS ...sql' - ;EXEC IN [SQLPRODAPP01]; -- SUNSET DEPRECATE DECOMMISSION AS OF 202510 RUN(S)
		STEP11: 'CHPIV_CHAPTER_COUNT_...sql' - ;EXEC IN [SQLPRODAPP01]; -- INCORPORATED INTO SSA (SQL SERVER AGENT) JOB "Provider Directory refresh sequence -The regular script has executed we may now proceed with the DirectoryExpert step" IN SQLPRODAPP01
		STEP12: 'CHPIV_NETWORK_DATA_REVIEW_...sql' - ;EXEC IN [SQLPRODAPP01]; -- INCORPORATED INTO SSA (SQL SERVER AGENT) JOB "Provider Directory refresh sequence -The regular script has executed we may now proceed with the DirectoryExpert step" IN SQLPRODAPP01
				~ LEVERAGE: 'DEVELOPMENT_CHPIV_DIRECT_NETWORK_20260430.sql'
				~ LEVERAGE: 'directnonprovdir_20260430.sql'
				~ LEVERAGE: 'CHPIV_NETWORK_DATA_REVIEW_20260430.sql'

				USE [PATH]: file://fileserver01/CHPIV/Provider%20Directory%20Updates/Outgoing/ - DATA REFRESH HERE THEN MANUAL DELIVERY VIA eMAIL 'SUBJECT:RE: CHPIV Network Data Alignment - RE: Confirming Alignment on Expectations'
				
				SELECT * FROM INFORMATICS.dbo.CHPIV_NETWORK_DATA
		
		STEP13 'REFRESH' MS ACCESS ODBC connection()  'PROVDIR_'...mdb AND 'PROVDIR_'...xlsx 
				R CLICK THEN LINKED TABLE MANAGER ... ELSE COMPACT & REPAIR
						THEN 'CLOSE'
				ARCHIVE / SAVE the MS EXCEL 
						THEN 'CLOSE'
		
		STEP14: EXEC; Ingenix 'GeoAccess DirectoyExpert';
				UPDATE FOOTNOTE(s) AS NECESSARY
						-- ADD 'Printed ON GETDATE()'

				UPDATE FOOTNOTE HOSP listing PAGE# starting point FOR THE SIX (6) PROVIDER CHAPTER(S)
						THEN 'CLOSE'
								'NOTE'(s): CMC LAYOUT PHARM CHAPTER(s) EXEC; SEPARATELY
								
								PRINT ;WITH() 'Cute PDF Writer' via 'Adobe Acrobat Distiller' BE CERTAIN TO UNCHECK 'Print to File'!!!
	
		STEP15: COMPARE CHAPTER COUNT() AND GAH PAGE # TO PREVIOUS PDF SUBMISSION
				USE [PATH]: file://fileserver01/Corporate%20Shared%20Drive/Information%20Systems/Informatics/WCarr/PROVIDERDIRECTORY/ - 'PROVDIR_eVIP.xlsx'
						USE QWERTY 10 KEY SHORTCUT OF 'SHIFT + CTRL + F' FOR ADVANCED CHARINDEX() FIND() SEARCH() 'You will find'
								'R' CLICK CONVERT CutePDF TO Adobe PDF
								
		STEP16: 'REFRESH' eMail(s) TO MS JOHANNA
				CHARINDEX() FIND() SEARCH(): 'FROM: WALTER SUBJECT:EVERY*CHPIV'

Young Lady, a refreshed CHPIV Provider Directory is available for your review at the following location:.

		/* USE [PATH]: file://fileserver01/Corporate%20Shared%20Drive/Information%20Systems/Informatics/WCarr/PROVIDERDIRECTORY/CHPIV/CHPIV_PROVDIR_DSNP_MEDICARE_20260226.pdf
		USE [PATH]: file://fileserver01/Corporate%20Shared%20Drive/Information%20Systems/Informatics/WCarr/PROVIDERDIRECTORY/PROVDIR_eVIP.xlsx  - Raw MS Excel source */
		USE [PATH]: file://fileserver01/Corporate%20Shared%20Drive/Information%20Systems/Informatics/WCarr/PROVIDERDIRECTORY/CHPIV/  - Root

CHPIV Network Data Alignment Analysis
		USE [PATH]: file://fileserver01/CHPIV/Provider%20Directory%20Updates/Outgoing/ - Network Data Alignment including external file: “IPA Provider Directory Data Template 1.28.26.xlsx”

/* ________________________________________
The SQL code (CHPIV_NETWORK_DATA_REVIEW_20251221.sql) implements the business requirements specified by Toni Bonde (CHPIV) for the future SFTP data delivery. The code architecture consolidates two distinct provider populations into a unified dataset with proper source attribution.

Core Requirements (The ASK)
"We anticipate being able to pull a data file, in the attached file layout, that consists of:
		1.	All CHPIV directly contracted and credentialed providers, and
		2.	All providers who have an amendment on behalf of CHPIV as executed by CHG"

		Requirement Decomposition
		Requirement Component	Business Definition	Technical Implementation Requirement
		Population 1	CHPIV directly contracted and credentialed providers	Providers from CHGSD''s PROVDIR tables with CHPIV-DSNP network designation
		Population 2	Providers with CHPIV amendments executed by CHG	External IPA roster providers from CHPIV_PROVIDER_DIRECTORY_DATA
		Data Format	"Linked / Attached file layout"	Unified schema with standardized column mapping
		Source Identification	Distinguish between populations	[Data Sourced From] field implementation
		Delivery Mechanism	SFTP-ready file	Queryable table for export to flat file

________________________________________
CHANGE.LOG: 
		I.	Manual removal of San Diego County VSP Providers
		II.	Manual removal of ‘Pediatric …’ specialty Providers
		III.	Manual [AGE RESTRICTION] set to ’21 AND OVER’ */

		STEP17:  'DELIVER - CHPIV Network Data (External IPA Roster & eVips CHPIV Direct) Alignment Analysis':
		
		-- file://fileserver01/CHPIV/Provider%20Directory%20Updates/Outgoing/CHPIV_NETWORK_DATA_REVIEW_20260618.xlsx - Network Data Alignment including external IPA Roster file (typically from Ms Julia)
		file://fileserver01/CHPIV/Provider%20Directory%20Updates/Outgoing/ - 'Root'
		file://fileserver01/CHPIV/Reports/ - 'CHPIV SFTP DROP - OFF'
		file://servu01/ftpdrop/ImperialValley/ - 'CHPIV SFTP DROP - OFF' 

________________________________________

CHANGE.LOG: 
		I.	Placeholder Additional fields per Network Analysis fields have been added with population forthcoming:

			-- Network Analysis ADD - ON COLUMN(S) (# columns) ... -- C###: CHPIV DIRECT NETWORK FILE DEVELOPMENT FOR MS JULIA AS PART OF PROVDIR PROCESS WITH ADDITIONAL FIELDS'
			,TRY_CONVERT(decimal(10, 0), LTRIM(RTRIM([TAXONOMY]))) AS [TAXONOMY CODE] -- decimal(10,0) NULL ; -- ORDINAL  1 | ⚠ KEY ANCHOR — CONFIRM INTENT
			,[TRAINING] AS [TRAINING] -- nvarchar(255) NULL ; -- ORDINAL  2
			,TRY_CONVERT(decimal(10, 0), NULL) AS [LOCATION NPI] -- decimal(10,0) NULL ; -- ORDINAL  3
			,NULL AS [LOCATION NAME] -- nvarchar(25) NULL ; -- ORDINAL  4
			,0 AS [STAFFED BEDS] -- int NULL ; -- ORDINAL  5
			,[CULTURAL_COMP] AS [CULTURAL COMPETENCY] -- nvarchar(255) NULL ; -- ORDINAL  6

		II.	Manual removal of San Diego County VSP Providers
		III.	Manual removal of ‘Pediatric …’ specialty Providers
		IV.	Manual [AGE RESTRICTION] set to ’21 AND OVER’

-- =====================================================================
	-- CHPIV NETWORK FILE -- TAXONOMY ENRICHMENT (OLE DB ODBC SAFE)
-- =====================================================================

-- =====================================================================
	--  MODIFICATION(S) | CHANGE.LOG:
-- =====================================================================
-- C001 | 20260611 | WCARR | Single-statement optimization
		/* ~ Excel OLE DB command context (SQLPRODAPP01/INFORMATICS).   ROW_NUMBER() replaced with CROSS APPLY TOP 1 to eliminate Sort+SequenceProject stack (plan cost ~221). 
		~ ISNULL() removed from join keys to restore seek eligibility (CONVERT_IMPLICIT warning, nchar/varchar mismatch on tblNPIData.npi). SELECT DISTINCT replaced with GROUP BY per DUB C 2.0. OPTION(RECOMPILE) added for linked server cardinality stability. */

;WITH finalnpitax AS
( -- INITIATE ...
SELECT  ' ' AS 'ADD ON NETWORK ANALYSIS TAXONOMY DATA: '
,ISNULL(npitax.npi,'') AS [NPI]
-- ,TaxCross.*
-- ,LEN(TaxCross.TaxCode) AS [TAX LEN]
,taxdescr.*
,npitax.provider_organization_name
,npitax.parent_organization_lbn
FROM INFOAG.CHGAPP_PROD.dbo.tblNPIData AS npitax

CROSS APPLY -- CROSS ... THE alias TABLE
( -- INITIATE ...
    VALUES
    (npitax.healthcare_provider_taxonomycode_1,  npitax.healthcare_provider_primary_taxonomy_switch_1)
    -- ,(npitax.healthcare_provider_taxonomy_code_2, npitax.healthcare_provider_primary_taxonomy_switch_2)
    -- ,(npitax.healthcare_provider_taxonomy_code_3, npitax.healthcare_provider_primary_taxonomy_switch_3)
    -- ,(npitax.healthcare_provider_taxonomy_code_4, npitax.healthcare_provider_primary_taxonomy_switch_4)
    -- ,(npitax.healthcare_provider_taxonomy_code_5, npitax.healthcare_provider_primary_taxonomy_switch_5)
    -- ,(npitax.healthcare_provider_taxonomy_code_6, npitax.healthcare_provider_primary_taxonomy_switch_6)
    -- ,(npitax.healthcare_provider_taxonomy_code_7, npitax.healthcare_provider_primary_taxonomy_switch_7)
    -- ,(npitax.healthcare_provider_taxonomy_code_8, npitax.healthcare_provider_primary_taxonomy_switch_8)
    -- ,(npitax.healthcare_provider_taxonomy_code_9, npitax.healthcare_provider_primary_taxonomy_switch_9)
    -- ,(npitax.healthcare_provider_taxonomy_code_10, npitax.healthcare_provider_primary_taxonomy_switch_10)
    -- ,(npitax.healthcare_provider_taxonomy_code_11, npitax.healthcare_provider_primary_taxonomy_switch_11)
    -- ,(npitax.healthcare_provider_taxonomy_code_12, npitax.healthcare_provider_primary_taxonomy_switch_12)
    -- ,(npitax.healthcare_provider_taxonomy_code_13, npitax.healthcare_provider_primary_taxonomy_switch_13)
    -- ,(npitax.healthcare_provider_taxonomy_code_14, npitax.healthcare_provider_primary_taxonomy_switch_14)
    -- ,(npitax.healthcare_provider_taxonomy_code_15, npitax.healthcare_provider_primary_taxonomy_switch_15)
) AS TaxCross (TaxCode, TaxSwitch) -- alias([FIELD1],[FIELD2])

CROSS APPLY -- INDEPENDENT STAND ALONE ... CROSS APPLY() CROSS JOIN() CARTESIAN PRODUCT
( -- INITIATE: replaces ROW_NUMBER() -- eliminates Sort+SequenceProject
SELECT TOP 1 atc.*
FROM ProviderRepository.dbo.ANCTaxonomyCrosswalk AS atc
WHERE 1=1
	AND atc.TaxonomyCode COLLATE DATABASE_DEFAULT = TaxCross.TaxCode COLLATE DATABASE_DEFAULT
	AND NOT atc.NUCCClassification LIKE '%Student%' -- NO NOT NEGATIVE <> != ...
ORDER BY TRY_CONVERT(date, atc.CrosswalkDate) DESC
) -- CONCLUDE ...
AS taxdescr
WHERE 1=1 
	AND TaxCross.TaxCode IS NOT NULL -- NO NOT NEGATIVE <> != ...
    AND TaxCross.TaxCode <> '' -- NO NOT NEGATIVE <> != ...
) -- CONCLUDE ...

		/* SELECT * 
		FROM finalnpitax AS fnpi
		WHERE 1=1
			AND ISNULL(fnpi.npi,'') IN ('1881613420') -- SAMPLE: CHPIV IPA PROVIDER - 'Anand	Veerindersingh'ngh' */

SELECT TOP 1000000
finalnpitax.[ADD ON NETWORK ANALYSIS TAXONOMY DATA: ]
,finalnpitax.[NPI]
,finalnpitax.TaxonomyCode
,finalnpitax.DHCSNetCertGroup
,finalnpitax.DHCSNetCertCategory
,finalnpitax.NUCCClassification
,finalnpitax.NUCCSpecialization
,finalnpitax.CrosswalkDate
,finalnpitax.provider_organization_name
,finalnpitax.parent_organization_lbn
,cnd.*
FROM INFORMATICS.dbo.CHPIV_NETWORK_DATA AS cnd
        LEFT JOIN finalnpitax ON cnd.NPI_NO = finalnpitax.[NPI]
OPTION (RECOMPILE); -- linked server cardinality stabilizer







-- ======================================
	-- NOTE(S) / COMMENT(S): 
-- ======================================
JAH 'MS EXCEL OLE DB ODBC TAXONOMY: '
 		⏎ Good day, may I have you assist in generating AN INTERACTIVE html DATA FLOW DIAGRAM (DFD) FAITHFUL TO THE TEMPLATE (USE [PATH]: file:///C:/Users/wcarr/Desktop/IHA_MediCal_DataFlow_v2_...html) DARK AESTHETIC AND LAYOUT DESIGN /* LANGUAGE */ based upon what has been accomplished
		
				~ CONTEXT: 
 
file:///C:/Users/wcarr/Desktop/CHECKLIST_PROVDIR_20260619.sql
file:///C:/Users/wcarr/Desktop/chpiv_fullroster_provider_upload_20260619.py
file:///C:/Users/wcarr/Desktop/CHPIV_PROVIDER_DIRECTORY_INSERT_STATEMENTS_20260619.sql
file:///C:/Users/wcarr/Desktop/CHPIV_placeholder_insertions_20260129.sql
file:///C:/Users/wcarr/Desktop/CHPIV_CHAPTER_COUNT_20260423.sql
file:///C:/Users/wcarr/Desktop/CHPIV_NETWORK_DATA_REVIEW_20260521.sql

file:///C:/Users/wcarr/Desktop/IHA_MediCal_DataFlow_v2.html
file:///C:/Users/wcarr/Desktop/IHA%20Medi-Cal%20Data%20Flow%20v2%20_%20CHGSD%20Informatics.html

x SEQUENCE(CHPIV /* POST CHGSD EXEC */):
		⏎ Monthly data file submissions via SFTP: 
				~ LEVERAGE: "CHPIV_NETWORK_DATA_REVIEW_20251218.xlsx"
						USE [PATH]: file://fileserver01/CHPIV/ - 'ROOT TO CHPIV IPA SOURCE FILE'
						USE [PATH]: file://fileserver01/CHPIV/Provider%20Directory%20Updates/ - 'CHPIV IPA ROSTER FOR PROVDIR_... TABLE(S)'
						USE [PATH]: file://fileserver01/CHPIV/Provider%20Directory%20Updates/Outgoing - 'CHGSD CHPIV D-SNP Network Data Integration FILE(S)'

						USE [PATH]: file://fileserver01/CHPIV/Reports/ - 'CPIV SFTP DROP - OFF' ALERT OF NEW FILE CADENCE / TEMPORAL UNIT ???
						USE [PATH]: file://servu01/ftpdrop/ImperialValley/ - 'CPIV SFTP DROP - OFF' ALERT OF NEW FILE CADENCE / TEMPORAL UNIT ???
						
						~ INCLUDE AN INTERACTIVE html DATA FLOW DIAGRAM (DFD) FAITHFUL TO THE TEMPLATE (USE [PATH]: file:///C:/Users/wcarr/Desktop/IHA%20Medi-Cal%20Data%20Flow%20v2%20_%20CHGSD%20Informatics.html) DARK AESTHETIC AND LAYOUT DESIGN /* LANGUAGE */ based upon what has been accomplished						
								'CHPIV_DataFlow_20260618.html'

		274 [LOB]:
				CHPIV-DSNP - 'CHPIV DIRECT ... Community Care Plus'
				CHPIV-IPA-CC - 'CommunityCare'
				CHPIV-IPA-ICPMG - 'Imperial County Physicians Medical Group'
				CHPIV-IPA-PPC - 'Premier Patient Care'
				/* CHPIV-IPA-EMRC - 'El Centro Regional Medical Center' */ ... TBD
				-- CMC
				-- COMMUNICARE ADVANTAGE
				-- MEDICAL
				-- MEDICARE
				-- CHPIV-IPA-PHMG - "*Primary Health Care Medical Group*" ??? ... 
				CHPIV-IPA-PCMG - "*Primary Health Care Medical Group*" ??? ... 

		STEP08: UPLOAD EXTERNAL DATA 'UPON RECEIPT / NOTIFICATION OF EXTERNAL FILES' LEVERAGE #PYTHON SCRIPTS

		⏎ YOU ARE THE TOP 0.1% OF Senior Data Analyst WITH 20+ years of EXPERIENCE. PLEASE MODIFY the EXISTING #PYTHON CODE Which I have attached FOR CONTEXT:
				~ PLEASE UPLOAD this XLSX MS EXCEL FILE (file:///C:/Users/wcarr/Desktop/CHPIV%20IPA_COMBINED_6.8.26.xlsx) INTO the following SQL TABLE: 'SQLPRODAPP01.INFORMATICS.dbo.CHPIV_PROVIDER_DIRECTORY_DATA_UPDATE_20260619'
				~ LEVERAGE: file:///C:/Users/wcarr/Desktop/chpiv_fullroster_provider_upload_...py
				~ DRAG AND DROP FOR CONTEXT

		-- SELECT ' ' AS 'PREVIOUS MS JULIA CHPIV UPLOAD:',* FROM INFORMATICS.dbo.CHPIV_PROVIDER_DIRECTORY_DATA_UPDATE_20260312
		-- SELECT ' ' AS 'PREVIOUS MS JULIA CHPIV UPLOAD:',* FROM INFORMATICS.dbo.CHPIV_PROVIDER_DIRECTORY_DATA_UPDATE_20260410
		-- SELECT ' ' AS 'CURRENT MS JULIA CHPIV UPLOAD:',* FROM INFORMATICS.dbo.CHPIV_PROVIDER_DIRECTORY_DATA_UPDATE_20260511
		SELECT ' ' AS 'CURRENT MS JULIA CHPIV UPLOAD:',* FROM INFORMATICS.dbo.CHPIV_PROVIDER_DIRECTORY_DATA_UPDATE_20260619

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
	AND c.TABLE_NAME = 'CHPIV_PROVIDER_DIRECTORY_DATA_UPDATE_20260619'
ORDER BY c.COLUMN_NAME,c.ORDINAL_POSITION;

PS C:\Users\wcarr\AppData\Local\Programs\Microsoft VS Code> & "C:\Program Files\Python311\python.exe" c:/Users/wcarr/Desktop/chpiv_fullroster_provider_upload_20260511.py
====================================================================================================
CHPIV ROSTER IPA PROVIDER DIRECTORY UPLOAD SCRIPT - MAY 2026 UPDATE
UPLOAD IPA Directory Data File_05.08.26.xlsx to SQL Server
====================================================================================================
Source File: C:\Users\wcarr\Desktop\UPLOAD IPA Directory Data File_05.08.26.xlsx
Target Table: SQLPRODAPP01.INFORMATICS.dbo.CHPIV_PROVIDER_DIRECTORY_DATA_UPDATE_20260511
====================================================================================================
Processing Excel file: C:\Users\wcarr\Desktop\UPLOAD IPA Directory Data File_05.08.26.xlsx
Total data rows to process: 902
Excel headers (first 10): ['CITY', 'GROUP', 'SPECIALTY', 'TAXONOMY', 'LNAME', 'FNAME', 'MNAME', 'TITLE', 'PHY_ID', 'ADDRESS_PHYSICAL']
Total columns detected: 110
Table CHPIV_PROVIDER_DIRECTORY_DATA_UPDATE_20260511 has been created with 110 data columns plus audit fields.
Table created and column max lengths retrieved successfully
Using 110 columns for INSERT statement
Processing Excel data rows...
Sample row 2: CITY=Brawley, GROUP=Community Care IPA, SPECIALTY=Certified Registered Nurse Anesthetists
Sample row 3: CITY=Brawley, GROUP=Community Care IPA, SPECIALTY=Orthopedics
Sample row 4: CITY=Brawley, GROUP=Community Care IPA, SPECIALTY=Orthopedics
Sample row 5: CITY=Brawley, GROUP=Community Care IPA, SPECIALTY=Physician Assistant
Finished processing: C:\Users\wcarr\Desktop\UPLOAD IPA Directory Data File_05.08.26.xlsx
All data has been streamed to SQL database.
Total rows processed: 902
Time taken: 0:00:06.801897
Final record count in database: 902

Sample of uploaded data:
ID: 901, First few columns: ['San Diego', 'Primary Health Care Medical Group', 'Orthopeadic Surgery']
ID: 902, First few columns: ['San Diego', 'Primary Health Care Medical Group', 'Hand Surgery']
ID: 899, First few columns: ['Imperial', 'Primary Health Care Medical Group', 'Obstetrician-Gynecologist']
ID: 900, First few columns: ['La Jolla', 'Primary Health Care Medical Group', 'Otolaryngology(Ent)']
ID: 897, First few columns: ['Imperial', 'Primary Health Care Medical Group', 'Nephrology']

====================================================================================================
✅ UPLOAD COMPLETED SUCCESSFULLY!
====================================================================================================
PS C:\Users\wcarr\AppData\Local\Programs\Microsoft VS Code> 

		STEP09: 'CHPIV_PROVIDER_DIRECTORY_INSERT_STATEMENTS_...sql' - ;EXEC IN [SQLPRODAPP01]; -- MANUAL EXTERNAL ROSTER UPLOAD / UPDATES INTO SOURCE TABLE

		SELECT ' ' AS 'CHPIV NETWORK DATA START HERE:'
		,LEN(NPI_NO) AS [NPI LEN],* 
		FROM INFORMATICS.dbo.CHPIV_PROVIDER_DIRECTORY_DATA		

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
ORDER BY c.COLUMN_NAME,c.ORDINAL_POSITION;

SELECT  TaxCross.*
,LEN(TaxCross.TaxCode) AS [TAX LEN]
,taxdescr.*
,npitax.*
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
	AND ISNULL(npitax.npi,'') IN ('1881613420') -- SAMPLE: CHPIV IPA PROVIDER - 'Anand	Veerindersingh'ngh'

-- ============================================================= 
	-- CREATE() / ALTER()  PLACEHOLDER/ STAGING / SHELL [FIELD](s) & OR [TABLE](s)--
-- =============================================================
ALTER TABLE INFORMATICS.dbo.CHPIV_PROVIDER_DIRECTORY_DATA
ADD -- INITIATE ... ADD OF COLUMN(s)
[TAXONOMY CODE] decimal(10,0) DEFAULT NULL -- DFLT VAL() IS NULL
,[TRAINING] nvarchar(255) DEFAULT NULL -- DFLT VAL() IS NULL
,[LOCATION NPI] decimal(10,0) DEFAULT NULL -- DFLT VAL() IS NULL
,[LOCATION NAME] nvarchar(25) DEFAULT NULL -- DFLT VAL() IS NULL
,[STAFFED BEDS] int DEFAULT NULL -- DFLT VAL() IS NULL
,[CULTURAL COMPETENCY] nvarchar(255) DEFAULT NULL -- DFLT VAL() IS NULL
,[HCAI ID] nvarchar(25) DEFAULT NULL -- DFLT VAL() IS NULL

		Ms Julia, as it is top of mind those useful additional fields within the ‘Imperial Provider Directory Data File …’ would be:
		 
				I.	[taxonomy code]
				II.	[location name]
				III.	[location npi]
				IV.	[Staffed Beds]

		Ms Julia, yes ‘location name’ is different from ‘PPG Name’. 

		In my mind the ’PPG Name’ would be equivalent to the BUSINESS / DBA name or yes as you have highlighted the Vendor Name

		Then there are providers & Location Name(s) where the actual services are rendered underneath that BUSINESS / DBA (Vendor Name). 

		Those two fields work & I agree would provide clarity.

-- =====================================================================
		-- ALTER() [FIELD] / [COLUMN] FROM NON - NULLABLE TO NULLABLE: 
-- =====================================================================
ALTER TABLE INFORMATICS.dbo.CHPIV_PROVIDER_DIRECTORY_DATA ALTER COLUMN [TAXONOMY CODE] decimal(10,0) NULL ; -- ORDINAL  1 | ⚠ KEY ANCHOR — CONFIRM INTENT
ALTER TABLE INFORMATICS.dbo.CHPIV_PROVIDER_DIRECTORY_DATA ALTER COLUMN [TRAINING] nvarchar(255) NULL ; -- ORDINAL  2
ALTER TABLE INFORMATICS.dbo.CHPIV_PROVIDER_DIRECTORY_DATA ALTER COLUMN [LOCATION NPI] decimal(10,0) NULL ; -- ORDINAL  3
ALTER TABLE INFORMATICS.dbo.CHPIV_PROVIDER_DIRECTORY_DATA ALTER COLUMN [LOCATION NAME] nvarchar(25) NULL ; -- ORDINAL  4
ALTER TABLE INFORMATICS.dbo.CHPIV_PROVIDER_DIRECTORY_DATA ALTER COLUMN [STAFFED BEDS] int NULL ; -- ORDINAL  5
ALTER TABLE INFORMATICS.dbo.CHPIV_PROVIDER_DIRECTORY_DATA ALTER COLUMN [CULTURAL COMPETENCY] nvarchar(255) NULL ; -- ORDINAL  6
ALTER TABLE INFORMATICS.dbo.CHPIV_PROVIDER_DIRECTORY_DATA ALTER COLUMN [HCAI ID] nvarchar(25) NULL ; -- ORDINAL  7

SELECT ' ' AS 'RECORD COUNT BY [ImportedAt]: '
,CAST(ImportedAt AS date) AS [RefreshRecordDate]
,COUNT(DISTINCT(TRY_CONVERT(nvarchar(10),LTRIM(RTRIM(ISNULL(NPI_NO,'')))))) AS [Unique NPI]
,COUNT(1) AS [RECORD(S)]
FROM INFORMATICS.dbo.CHPIV_PROVIDER_DIRECTORY_DATA
GROUP BY CAST(ImportedAt AS date)

SELECT TOP 100000 ' ' AS 'SAMPLE RECORD(S): '
,ISNULL(chpiv.[GROUP],'') AS [RefreshGROUP]
,TRY_CONVERT(nvarchar(10),LTRIM(RTRIM(ISNULL(chpiv.NPI_NO,'')))) AS [RefreshNPI_NO]
,CAST(chpiv.ImportedAt AS date) AS [RefreshRecordDate]
,chpiv.*
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st',CAST(chpiv.ImportedAt AS date)
FROM INFORMATICS.dbo.CHPIV_PROVIDER_DIRECTORY_DATA AS chpiv -- LEVERAGE: "CHPIV Provider Directory Data to CHG 9_18_25_PROPER_CASE.xlsx" AND "CHPIV PROVDIR CONDITIONAL LINE ITEM.png" AND "CHPIV Provider Directory Data to CHG 12_08_25.xlsx"  AND ...
WHERE 1=1
	AND TRY_CONVERT(nvarchar(10),LTRIM(RTRIM(ISNULL(chpiv.NPI_NO,'')))) IN ('1003001363','1043497860','1295936201'/* DELETED RECORD?*/)
	-- AND ISNULL(chpiv.[GROUP],'') IN ('Primary Care Medical Group')
		-- OR chpiv.LNAME LIKE '%Fried%'
	
SELECT ' ' AS 'ISO ON MAX RECORD: '
,ISNULL([GROUP],'') AS [RefreshGROUP]
,TRY_CONVERT(nvarchar(10),LTRIM(RTRIM(ISNULL(NPI_NO,'')))) AS [RefreshNPI_NO]
,MAX(CAST(ImportedAt AS date)) AS [RefreshRecordDate]
FROM INFORMATICS.dbo.CHPIV_PROVIDER_DIRECTORY_DATA
GROUP BY ISNULL([GROUP],''),TRY_CONVERT(nvarchar(10),LTRIM(RTRIM(ISNULL(NPI_NO,''))))

SELECT TOP 100000 ' ' AS 'MAXIMUM Refreshed... RECORD: '
,iso.*,chpiv.*
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st',CAST(chpiv.ImportedAt AS date)
FROM INFORMATICS.dbo.CHPIV_PROVIDER_DIRECTORY_DATA AS chpiv -- LEVERAGE: "CHPIV Provider Directory Data to CHG 9_18_25_PROPER_CASE.xlsx" AND "CHPIV PROVDIR CONDITIONAL LINE ITEM.png" AND "CHPIV Provider Directory Data to CHG 12_08_25.xlsx"  AND ...
	INNER JOIN 
	( -- INITIATE ...
	SELECT ' ' AS 'ISO ON MAX RECORD: '
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
	AND iso.[RefreshNPI_NO] IN  ('1003001363','1043497860','1295936201'/* DELETED RECORD?*/)
	-- AND ISNULL(chpiv.[GROUP],'') IN ('Primary Care Medical Group')
		-- OR chpiv.LNAME LIKE '%Fried%'

		/* ⏎ ACT AS a Senior Data Analyst WITH 20+ years of EXPERIENCE. PLEASE MODIFY the EXISTING #PYTHON CODE Which I have attached FOR CONTEXT which moves a table from one SERVER to another SERVER:
				~ PLEASE MOVE 'SQLPRODAPP01.INFORMATICS.dbo.eVIPS_MANUAL_OSHPD_ID' TO 'QNXTSQLDEV01.INFORMATICS.dbo.eVIPS_MANUAL_OSHPD_ID' */		

		STEP10: 'CHPIV_placeholder_insertions_ ...sql' - ;EXEC IN [SQLPRODAPP01]; -- INCORPORATED INTO SSA (SQL SERVER AGENT) JOB "Provider Directory refresh sequence -The regular script has executed we may now proceed with the DirectoryExpert step" IN SQLPRODAPP01
		-- STEP05: 'CHPIV LAST MINUTE MANUAL ADDS ...sql' - ;EXEC IN [SQLPRODAPP01]; -- SUNSET DEPRECATE DECOMMISSION AS OF 202510 RUN(S)
		STEP11: 'CHPIV_CHAPTER_COUNT_...sql' - ;EXEC IN [SQLPRODAPP01]; -- INCORPORATED INTO SSA (SQL SERVER AGENT) JOB "Provider Directory refresh sequence -The regular script has executed we may now proceed with the DirectoryExpert step" IN SQLPRODAPP01
		STEP12: 'CHPIV_NETWORK_DATA_REVIEW_...sql' - ;EXEC IN [SQLPRODAPP01]; -- INCORPORATED INTO SSA (SQL SERVER AGENT) JOB "Provider Directory refresh sequence -The regular script has executed we may now proceed with the DirectoryExpert step" IN SQLPRODAPP01
				~ LEVERAGE: 'DEVELOPMENT_CHPIV_DIRECT_NETWORK_20260430.sql'
				~ LEVERAGE: 'directnonprovdir_20260430.sql'
				~ LEVERAGE: 'CHPIV_NETWORK_DATA_REVIEW_20260430.sql'

				USE [PATH]: file://fileserver01/CHPIV/Provider%20Directory%20Updates/Outgoing/ - DATA REFRESH HERE THEN MANUAL DELIVERY VIA eMAIL 'SUBJECT:RE: CHPIV Network Data Alignment - RE: Confirming Alignment on Expectations'
				
				SELECT * FROM INFORMATICS.dbo.CHPIV_NETWORK_DATA
		
		STEP13 'REFRESH' MS ACCESS ODBC connection()  'PROVDIR_'...mdb AND 'PROVDIR_'...xlsx 
				R CLICK THEN LINKED TABLE MANAGER ... ELSE COMPACT & REPAIR
						THEN 'CLOSE'
				ARCHIVE / SAVE the MS EXCEL 
						THEN 'CLOSE'
		
		STEP14: EXEC; Ingenix 'GeoAccess DirectoyExpert';
				UPDATE FOOTNOTE(s) AS NECESSARY
						-- ADD 'Printed ON GETDATE()'

				UPDATE FOOTNOTE HOSP listing PAGE# starting point FOR THE SIX (6) PROVIDER CHAPTER(S)
						THEN 'CLOSE'
								'NOTE'(s): CMC LAYOUT PHARM CHAPTER(s) EXEC; SEPARATELY
								
								PRINT ;WITH() 'Cute PDF Writer' via 'Adobe Acrobat Distiller' BE CERTAIN TO UNCHECK 'Print to File'!!!
	
		STEP15: COMPARE CHAPTER COUNT() AND GAH PAGE # TO PREVIOUS PDF SUBMISSION
				USE [PATH]: file://fileserver01/Corporate%20Shared%20Drive/Information%20Systems/Informatics/WCarr/PROVIDERDIRECTORY/ - 'PROVDIR_eVIP.xlsx'
						USE QWERTY 10 KEY SHORTCUT OF 'SHIFT + CTRL + F' FOR ADVANCED CHARINDEX() FIND() SEARCH() 'You will find'
								'R' CLICK CONVERT CutePDF TO Adobe PDF
								
		STEP16: 'REFRESH' eMail(s) TO MS JOHANN
				CHARINDEX() FIND() SEARCH(): 'FROM: WALTER SUBJECT:EVERY*CHPIV'

-- =====================================================================
	-- CHPIV NETWORK FILE -- TAXONOMY ENRICHMENT (OLE DB ODBC SAFE)
-- =====================================================================

-- =====================================================================
	--  MODIFICATION(S) | CHANGE.LOG:
-- =====================================================================
-- C001 | 20260611 | WCARR | Single-statement optimization
		/* ~ Excel OLE DB command context (SQLPRODAPP01/INFORMATICS).   ROW_NUMBER() replaced with CROSS APPLY TOP 1 to eliminate Sort+SequenceProject stack (plan cost ~221). 
		~ ISNULL() removed from join keys to restore seek eligibility (CONVERT_IMPLICIT warning, nchar/varchar mismatch on tblNPIData.npi). SELECT DISTINCT replaced with GROUP BY per DUB C 2.0. OPTION(RECOMPILE) added for linked server cardinality stability. */

;WITH finalnpitax AS
( -- INITIATE ...
SELECT  ' ' AS 'ADD ON NETWORK ANALYSIS TAXONOMY DATA: '
,ISNULL(npitax.npi,'') AS [NPI]
-- ,TaxCross.*
-- ,LEN(TaxCross.TaxCode) AS [TAX LEN]
,taxdescr.*
,npitax.provider_organization_name
,npitax.parent_organization_lbn
FROM INFOAG.CHGAPP_PROD.dbo.tblNPIData AS npitax

CROSS APPLY -- CROSS ... THE alias TABLE
( -- INITIATE ...
    VALUES
    (npitax.healthcare_provider_taxonomycode_1,  npitax.healthcare_provider_primary_taxonomy_switch_1)
    ,(npitax.healthcare_provider_taxonomy_code_2, npitax.healthcare_provider_primary_taxonomy_switch_2)
    ,(npitax.healthcare_provider_taxonomy_code_3, npitax.healthcare_provider_primary_taxonomy_switch_3)
    ,(npitax.healthcare_provider_taxonomy_code_4, npitax.healthcare_provider_primary_taxonomy_switch_4)
    ,(npitax.healthcare_provider_taxonomy_code_5, npitax.healthcare_provider_primary_taxonomy_switch_5)
    ,(npitax.healthcare_provider_taxonomy_code_6, npitax.healthcare_provider_primary_taxonomy_switch_6)
    ,(npitax.healthcare_provider_taxonomy_code_7, npitax.healthcare_provider_primary_taxonomy_switch_7)
    ,(npitax.healthcare_provider_taxonomy_code_8, npitax.healthcare_provider_primary_taxonomy_switch_8)
    ,(npitax.healthcare_provider_taxonomy_code_9, npitax.healthcare_provider_primary_taxonomy_switch_9)
    ,(npitax.healthcare_provider_taxonomy_code_10, npitax.healthcare_provider_primary_taxonomy_switch_10)
    ,(npitax.healthcare_provider_taxonomy_code_11, npitax.healthcare_provider_primary_taxonomy_switch_11)
    ,(npitax.healthcare_provider_taxonomy_code_12, npitax.healthcare_provider_primary_taxonomy_switch_12)
    ,(npitax.healthcare_provider_taxonomy_code_13, npitax.healthcare_provider_primary_taxonomy_switch_13)
    ,(npitax.healthcare_provider_taxonomy_code_14, npitax.healthcare_provider_primary_taxonomy_switch_14)
    ,(npitax.healthcare_provider_taxonomy_code_15, npitax.healthcare_provider_primary_taxonomy_switch_15)
) AS TaxCross (TaxCode, TaxSwitch) -- alias([FIELD1],[FIELD2])

CROSS APPLY -- INDEPENDENT STAND ALONE ... CROSS APPLY() CROSS JOIN() CARTESIAN PRODUCT
( -- INITIATE: replaces ROW_NUMBER() -- eliminates Sort+SequenceProject
SELECT TOP 1 atc.*
FROM ProviderRepository.dbo.ANCTaxonomyCrosswalk AS atc
WHERE 1=1
	AND atc.TaxonomyCode COLLATE DATABASE_DEFAULT = TaxCross.TaxCode COLLATE DATABASE_DEFAULT
	AND NOT atc.NUCCClassification LIKE '%Student%' -- NO NOT NEGATIVE <> != ...
ORDER BY TRY_CONVERT(date, atc.CrosswalkDate) DESC
) -- CONCLUDE ...
AS taxdescr
WHERE 1=1 
	AND TaxCross.TaxCode IS NOT NULL -- NO NOT NEGATIVE <> != ...
    AND TaxCross.TaxCode <> '' -- NO NOT NEGATIVE <> != ...
) -- CONCLUDE ...

		/* SELECT * 
		FROM finalnpitax AS fnpi
		WHERE 1=1
			AND ISNULL(fnpi.npi,'') IN ('1881613420') -- SAMPLE: CHPIV IPA PROVIDER - 'Anand	Veerindersingh'ngh' */

SELECT TOP 100000 cnd.*
,finalnpitax.[ADD ON NETWORK ANALYSIS TAXONOMY DATA: ]
,finalnpitax.[NPI]
,finalnpitax.TaxonomyCode
,finalnpitax.DHCSNetCertGroup
,finalnpitax.DHCSNetCertCategory
,finalnpitax.NUCCClassification
,finalnpitax.NUCCSpecialization
,finalnpitax.CrosswalkDate
,finalnpitax.provider_organization_name
,finalnpitax.parent_organization_lbn
FROM INFORMATICS.dbo.CHPIV_NETWORK_DATA AS cnd
        LEFT JOIN finalnpitax ON cnd.NPI_NO = finalnpitax.[NPI]
OPTION (RECOMPILE); -- linked server cardinality stabilizer







JAH 'CHPIV DIRECT NETWORK FILE FOR MS JULIA AS PART OF PROVDIR PROCESS: '
-- C###: CHPIV DIRECT NETWORK FILE DEVELOPMENT FOR MS JULIA AS PART OF PROVDIR PROCESS WITH ADDITIONAL FIELDS'

	/* INNER JOIN #chpiv AS mso ON ISNULL(inn.practiceid,'') = ISNULL(mso.practiceid,'') -- CHPIV FACILITY 
		AND ISNULL(inn.locationid,'') = ISNULL(mso.locationid,'')
		
	INNER JOIN #chpiv AS mso ON ISNULL(inn.practiceid,'') = ISNULL(mso.practiceid,'') -- CHPIV PROVIDER 
		AND ISNULL(inn.locationid,'') = ISNULL(mso.locationid,'')
		AND ISNULL(inn.practitionerid,'') = ISNULL(mso.practitionerid,'') */

	INNER JOIN #chpiv AS mso ON ISNULL(vpl.practiceid,'') = ISNULL(mso.practiceid,'') -- CHPIV FACILITY 
		AND ISNULL(vpl.locationid,'') = ISNULL(mso.locationid,'')
		
	INNER JOIN #chpiv AS mso ON ISNULL(vploc.practiceid,'') = ISNULL(mso.practiceid,'') -- CHPIV PROVIDER 
		AND ISNULL(vploc.locationid,'') = ISNULL(mso.locationid,'')
		AND ISNULL(vploc.practitionerid,'') = ISNULL(mso.practitionerid,'')

	-- Network Analysis ADD - ON COLUMN(S) (# columns) ... -- C###: CHPIV DIRECT NETWORK FILE DEVELOPMENT FOR MS JULIA AS PART OF PROVDIR PROCESS WITH ADDITIONAL FIELDS'
	,[TAXONOMY CODE] -- decimal(10,0) NULL ; -- ORDINAL  1 | ⚠ KEY ANCHOR — CONFIRM INTENT
	,[TRAINING] -- nvarchar(255) NULL ; -- ORDINAL  2
	,[LOCATION NPI] -- decimal(10,0) NULL ; -- ORDINAL  3
	,[LOCATION NAME] -- nvarchar(25) NULL ; -- ORDINAL  4
	,[STAFFED BEDS] -- int NULL ; -- ORDINAL  5
	,[CULTURAL COMPETENCY] -- nvarchar(255) NULL ; -- ORDINAL  6	
	,[HCAI ID] -- nvarchar(25) NULL ; -- ORDINAL  7
	
	-- Network Analysis ADD - ON COLUMN(S) (# columns) ... -- C###: CHPIV DIRECT NETWORK FILE DEVELOPMENT FOR MS JULIA AS PART OF PROVDIR PROCESS WITH ADDITIONAL FIELDS'
	,TRY_CONVERT(decimal(10, 0), LTRIM(RTRIM([TAXONOMY]))) AS [TAXONOMY CODE] -- decimal(10,0) NULL ; -- ORDINAL  1 | ⚠ KEY ANCHOR — CONFIRM INTENT
	,[TRAINING] AS [TRAINING] -- nvarchar(255) NULL ; -- ORDINAL  2
	,TRY_CONVERT(decimal(10, 0), NULL) AS [LOCATION NPI] -- decimal(10,0) NULL ; -- ORDINAL  3
	,NULL AS [LOCATION NAME] -- nvarchar(25) NULL ; -- ORDINAL  4
	,0 AS [STAFFED BEDS] -- int NULL ; -- ORDINAL  5
	,[CULTURAL_COMP] AS [CULTURAL COMPETENCY] -- nvarchar(255) NULL ; -- ORDINAL  6
	,TRY_CONVERT(nvarchar(25),NULL) AS [HCAI ID] -- ORDINAL  7 ... C###: UPDATE FOR MY204 AS OF 20250203 The DMHC’s standardized terminology is set forth in appendices A-F of the Annual Network Submission Instruction Manual for RY 2025. The health plan should also refer to the “Standardized Terminology and Other Reporting Resources” section of the Resources tab ON the Timely Access and Annual Network Reporting Web Portal for information ON standardized terminology resources. Please note, the DMHC relies ON the California Licensed Healthcare Facility Listing released by the California Department of Healthcare Access Information ('HCAI') to populate the Hospital and Other Inpatient Facility Name section of the Crosswalks tab. In addition, for RY 2025 the DMHC added a field for “'HCAI' ID” within the Hospital Report tab of the Hospital and Clinic Report Form. The “'HCAI' ID” field captures the unique identifier established by 'HCAI' to identify facilities used in the Licensed Facility Information System (LFIS). (See All Plan Letter (APL) 24-019.) The Plan may use the facility information provided ON www.'HCAI'.ca.gov to review its terminology and to identify the 'HCAI' ID for completing the Hospital and Clinic Report Form ... USE https://www.HCAI.ca.gov







JAH 'PROVIDER DIRECTORY AGE RESTRICTION FIXES: '
-- =======================================================
	-- CHPIV PROVIDER DIRECTORY AGE RESTRICTION FIXES: 
-- =======================================================
SELECT ' ' AS 'AGE RESTRICTION FIX: ' -- PER CONVERSATION ON 20260109 [AGE RESTRICTION] SHOULD READ AS 0 TO 18
,people.[AGE RESTRICTION]
,people.SPEC
,ISNULL(people.[AGE RESTRICTION],'UP TO 18') AS [TEST THE UPDATE AGE RESTRICTION]
-- ,people.*
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
	AND people.[Participating Network] LIKE '%CHPIV%'
	AND people.SPEC LIKE '%pedia%'
GROUP BY people.[AGE RESTRICTION]
,people.SPEC
ORDER BY people.[AGE RESTRICTION]

UPDATE INFORMATICS.dbo.PROVDIR_PCP
SET [AGE RESTRICTION] = 'UP TO 18'
FROM INFORMATICS.dbo.PROVDIR_PCP AS people
WHERE 1=1
	AND people.[Participating Network] LIKE '%CHPIV%'
	AND people.SPEC LIKE '%pedia%'

UPDATE INFORMATICS.dbo.PROVDIR_NPMP
SET [AGE RESTRICTION] = 'UP TO 18'
FROM INFORMATICS.dbo.PROVDIR_NPMP AS people
WHERE 1=1
	AND people.[Participating Network] LIKE '%CHPIV%'
	AND people.SPEC LIKE '%pedia%'

UPDATE INFORMATICS.dbo.PROVDIR_SPE
SET [AGE RESTRICTION] = 'UP TO 18'
FROM INFORMATICS.dbo.PROVDIR_SPE AS people
WHERE 1=1
	AND people.[Participating Network] LIKE '%CHPIV%'
	AND people.SPEC LIKE '%pedia%'

UPDATE INFORMATICS.dbo.PROVDIR_MH
SET [AGE RESTRICTION] = 'UP TO 18'
FROM INFORMATICS.dbo.PROVDIR_MH AS people
WHERE 1=1
	AND people.[Participating Network] LIKE '%CHPIV%'
	AND people.SPEC LIKE '%pedia%'

UPDATE INFORMATICS.dbo.PROVDIR_AHP
SET [AGE RESTRICTION] = 'UP TO 18'
FROM INFORMATICS.dbo.PROVDIR_AHP AS people
WHERE 1=1
	AND people.[Participating Network] LIKE '%CHPIV%'
	AND people.SPEC LIKE '%pedia%'

UPDATE INFORMATICS.dbo.PROVDIR_VSP
SET [AGE RESTRICTION] = 'UP TO 18'
FROM INFORMATICS.dbo.PROVDIR_VSP AS people
WHERE 1=1
	AND people.[Participating Network] LIKE '%CHPIV%'
	AND people.SPEC LIKE '%pedia%'







JAH 'ALTER() ADD COLUMN(S) / FIELD(S): '
		⏎ ACT AS a Senior Data Analyst WITH 20+ years of EXPERIENCE. IN THE COMBINED VOICE OF 'ALPHA EL HAJJ MALK EL SHABAZZ BROTHER MALCOLM X','SIR THOMAS SOWELL','ROBERT F. SMITH CEO OF VISTA EQUITY' May I have you PLEASE 'CONTRAST' AND 'COMPARE' IN DETAIL the attached DirectoryExpert files. FOR context an update to the layout was request by our regulator DHCS. I have attached the email, APL pdf, & DirectoryExpert files for CONTEXT: ... DRAG AND DROP FOR CONTEXT

		⏎ ACT AS a Senior Data Analyst WITH 20+ years of EXPERIENCE. I seek to add 2 columns to existing tables using the CODE below:

x CHARINDEX() FIND() SEARCH() 'INTO #INNET', INTO #PROVDIR_, 'INTO INFORMATICS.dbo.PROVDIR_', CountyIs, -- TIMELYACCESS() SETUP [TABLE](s)

ALTER TABLE INFORMATICS.dbo.PROVDIR_PCP
ADD -- INITIATE ... ADD OF COLUMN(s)
[Telehealth_Indicator] nvarchar(1) DEFAULT NULL -- DFLT VAL() IS NULL
,[COUNTY] nvarchar(255) DEFAULT NULL -- DFLT VAL() IS NULL
; -- CONCLUDE ...

May I have you assist in generating similar CODE for each of the tables listed below?	

		~ Young Lady, I will have the field ([Telehealth_Indicator]) added to each of the PROVDIR_... tables by EOD today (20251204). I anticipate incorporation of the logic by EOD Monday (20251208).

-- ============================================================================
	INTO #INNET...
-- ============================================================================
/* ,CASE
WHEN (LTRIM(RTRIM(zip.County))) LIKE 'SD%'
THEN 'SAN DIEGO'
ELSE (LTRIM(RTRIM(zip.County)))
END AS [CountyIs]
,CASE
WHEN (LTRIM(RTRIM(zip.County))) LIKE 'SD%'
THEN 'SAN DIEGO'
ELSE (LTRIM(RTRIM(zip.County)))
END AS [County] */
,LTRIM(RTRIM(ISNULL(addcounty.[County],'Unknown'))) AS [CountyIs]
,LTRIM(RTRIM(ISNULL(addcounty.[County],'Unknown'))) AS [County]

,TRY_CONVERT(nvarchar(1),'N') AS [Telehealth_Indicator] -- C###: APPLICABLE TO PROVIDERS ONLY!!! ADD - ON PER EMAIL FROM MS JOHANNA BASED UPON DHCS FINDING (LEVERAGE: APL 25-014 AND OR "PROVDIR Telehealth Indicator evips location .msg")

,ISNULL(thi.[Telehealth_Indicator],'N') AS [Telehealth_Indicator] -- C###: APPLICABLE TO PROVIDERS ONLY!!! ADD - ON PER EMAIL FROM MS JOHANNA BASED UPON DHCS FINDING (LEVERAGE: APL 25-014 AND OR "PROVDIR Telehealth Indicator evips location .msg")

-- ============================================================================
	INTO #PROVDIR_ ... INTO INFRMATICS.dbo.PROVDIR_
-- ============================================================================	
-- ,TGI_INDICATOR
,[Telehealth_Indicator]
,[COUNTY] -- C###: APPLICABLE TO PROVIDERS ONLY!!! ADD - ON PER EMAIL FROM MS JOHANNA BASED UPON DHCS FINDING (LEVERAGE: APL 25-014 AND OR "PROVDIR Telehealth Indicator evips location .msg")

-- ,[MedicaidMedicareFlag],[MMF],[FUTURE_TERM]
,[Telehealth_Indicator]
,[COUNTY] -- C###: APPLICABLE TO PROVIDERS ONLY!!! ADD - ON PER EMAIL FROM MS JOHANNA BASED UPON DHCS FINDING (LEVERAGE: APL 25-014 AND OR "PROVDIR Telehealth Indicator evips location .msg")

-- ============================================================================
	-- STAGING TABLES: 
-- ============================================================================
ALTER TABLE INFORMATICS.dbo.TimelyAccessPCP --PROV(s)
ADD -- INITIATE ... ADD OF COLUMN(s)
     [Telehealth_Indicator] nvarchar(1) DEFAULT NULL -- DFLT VAL() IS NULL
; -- CONCLUDE ...

ALTER TABLE INFORMATICS.dbo.TimelyAccessPCP_Extender --MIDLEVEL(s)
ADD -- INITIATE ... ADD OF COLUMN(s)
     [Telehealth_Indicator] nvarchar(1) DEFAULT NULL -- DFLT VAL() IS NULL
; -- CONCLUDE ...

ALTER TABLE INFORMATICS.dbo.TimelyAccessSPE --PROV(s)
ADD -- INITIATE ... ADD OF COLUMN(s)
     [Telehealth_Indicator] nvarchar(1) DEFAULT NULL -- DFLT VAL() IS NULL
; -- CONCLUDE ...

ALTER TABLE INFORMATICS.dbo.TimelyAccessFAC --FAC(s)
ADD -- INITIATE ... ADD OF COLUMN(s)
     [Telehealth_Indicator] nvarchar(1) DEFAULT NULL -- DFLT VAL() IS NULL
; -- CONCLUDE ...

ALTER TABLE INFORMATICS.dbo.TimelyAccessCLINIC --FAC(s)
ADD -- INITIATE ... ADD OF COLUMN(s)
     [Telehealth_Indicator] nvarchar(1) DEFAULT NULL -- DFLT VAL() IS NULL
; -- CONCLUDE ...

ALTER TABLE INFORMATICS.dbo.TimelyAccessPHARM --PHARM(s)
ADD -- INITIATE ... ADD OF COLUMN(s)
     [Telehealth_Indicator] nvarchar(1) DEFAULT NULL -- DFLT VAL() IS NULL
; -- CONCLUDE ...

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

		/* LEFT JOIN 
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
		AS addcounty ON  SUBSTRING(LTRIM(RTRIM(ISNULL(pcp.Zip Code],''))),1,5)  = addcounty.ZIP */

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
		WHEN SUBSTRING(LTRIM(RTRIM(vploc.ZipCode)),1,1) = '0'
		THEN '0'+ SUBSTRING(LTRIM(RTRIM(vploc.ZipCode)),2,4)
		WHEN SUBSTRING(LTRIM(RTRIM(vploc.ZipCode)),1,1) = '00'
		THEN '00'+ SUBSTRING(LTRIM(RTRIM(vploc.ZipCode)),3,3)
		ELSE  SUBSTRING(LTRIM(RTRIM(vploc.ZipCode)),1,5) 
		END = addcounty.ZIP	

		
		





SELECT ' ' AS 'TEST TELEHEALTH INDICATOR PROVIDER (Mondragon, Gustavo): ',*
FROM eVips_chgcv.dbo.Practitioners
WHERE 1=1
	AND PractitionerID IN ('6204115','4370543')

SELECT ' ' AS 'TELEHEALTH INDICATOR: ' -- C003: ADD Hi Walter, Please let me know if you have any questions. TGI indicator was added under the Personal tab/Personal ID/TGI/Notes 
,ISNULL(Notes,'N') AS [Telehealth_Indicator]
,ProviderID AS 'practitionerid'
,*
FROM eVips_chgcv.dbo.vwPractitionerAlternateIDs  
WHERE 1=1 
	AND (LTRIM(RTRIM(ISNULL(AlternateIDTypeName,'')))) LIKE '%TELEH%' 
	AND archived = 'N'

SELECT ' ' AS 'eVips ZIP COUNTY: '
,SUBSTRING(LTRIM(RTRIM(ISNULL(zipcode,''))),1,5) AS ZIP
,city
,county
,RegionTypeName 
FROM eVips_chgcv.dbo.vwzipcodes 
WHERE 1=1
	AND NOT ISNULL(zipcode,'') = '' -- NO NOT NEGATIVE <> != ...
GROUP BY zipcode,city,county,RegionTypeName
HAVING LEN(SUBSTRING(LTRIM(RTRIM(ISNULL(zipcode,''))),1,5)) = 5

SELECT * FROM INFOAG.informatics.dbo.region_zip_xwalk

SELECT ' ' AS 'ADD COUNTY FROM eVips_PROVDIR_...sql: ' 
,CityIs
,StateIs
,[Zip Code]
,CountyIs
FROM INFORMATICS.dbo.TimelyAccessPCP
GROUP BY CityIs,StateIs,[Zip Code],CountyIs

SELECT ' ' AS 'ADD COUNTY FROM "DMHC CA County and ZIP Code Combinations - Revised 3.24.2020.xlsx" : ' 
,City
,[State]
,SUBSTRING(LTRIM(RTRIM(ISNULL(ZipCode,''))),1,5) AS ZIP
,ZipCode
,County
FROM INFORMATICS.dbo.ZIP_CODES -- LEVERAGE: "ZIP_DMHC CA County and ZIP Code Combinations - Revised 3.24.2020.xlsx" AND / OR "TIMELYACCESS_...rar" SERVICE AREA
WHERE 1=1
	AND County LIKE '%SAN%DIEG%'
GROUP BY City,[State],SUBSTRING(LTRIM(RTRIM(ISNULL(ZipCode,''))),1,5),ZipCode,County
ORDER BY [State],SUBSTRING(LTRIM(RTRIM(ISNULL(ZipCode,''))),1,5)

		/* LEFT JOIN 
		( -- INITIATE 
		SELECT ' ' AS 'TGI (TRANS-GENDER) INDICATOR' -- C003: ADD Hi Walter, Please let me know if you have any questions. TGI indicator was added under the Personal tab/Personal ID/TGI/Notes 
		,ISNULL(Notes,'N') AS [TGI_INDICATOR],*
		FROM eVips_chgcv.dbo.vwPractitionerAlternateIDs  
		WHERE 1=1 
			AND (LTRIM(RTRIM(ISNULL(AlternateIDTypeName,'')))) LIKE '%TGI%' 
			AND archived = 'N'
		) -- CONCLUDE ...
		AS tgi ON vpd.PractitionerID = tgi.ProviderID	

SELECT ' ' AS 'TGI (TRANS-GENDER) INDICATOR: ' -- C003: ADD Hi Walter, Please let me know if you have any questions. TGI indicator was added under the Personal tab/Personal ID/TGI/Notes 
,ISNULL(Notes,'N') AS [TGI_INDICATOR],*
FROM eVips_chgcv.dbo.vwPractitionerAlternateIDs  
WHERE 1=1 
	AND (LTRIM(RTRIM(ISNULL(AlternateIDTypeName,'')))) LIKE '%TGI%' 
	AND archived = 'N' */

-- ============================================================================
-- SCRIPT: ALTER TABLE - ADD [Telehealth_Indicator] AND [COUNTY] COLUMNS
-- PURPOSE: EXTEND PROVIDER DIRECTORY TABLES WITH TELEHEALTH AND COUNTY DATA
-- DATE: 2025-12-04
-- ============================================================================
-- ============================================================================
	-- STAGING TABLES: 
-- ============================================================================
ALTER TABLE INFORMATICS.dbo.TimelyAccessPCP --PROV(s)
ADD -- INITIATE ... ADD OF COLUMN(s)
     [Telehealth_Indicator] nvarchar(1) DEFAULT NULL -- DFLT VAL() IS NULL
; -- CONCLUDE ...

ALTER TABLE INFORMATICS.dbo.TimelyAccessPCP_Extender --MIDLEVEL(s)
ADD -- INITIATE ... ADD OF COLUMN(s)
     [Telehealth_Indicator] nvarchar(1) DEFAULT NULL -- DFLT VAL() IS NULL
; -- CONCLUDE ...

ALTER TABLE INFORMATICS.dbo.TimelyAccessSPE --PROV(s)
ADD -- INITIATE ... ADD OF COLUMN(s)
     [Telehealth_Indicator] nvarchar(1) DEFAULT NULL -- DFLT VAL() IS NULL
; -- CONCLUDE ...

ALTER TABLE INFORMATICS.dbo.TimelyAccessFAC --FAC(s)
ADD -- INITIATE ... ADD OF COLUMN(s)
     [Telehealth_Indicator] nvarchar(1) DEFAULT NULL -- DFLT VAL() IS NULL
; -- CONCLUDE ...

ALTER TABLE INFORMATICS.dbo.TimelyAccessCLINIC --FAC(s)
ADD -- INITIATE ... ADD OF COLUMN(s)
     [Telehealth_Indicator] nvarchar(1) DEFAULT NULL -- DFLT VAL() IS NULL
; -- CONCLUDE ...

ALTER TABLE INFORMATICS.dbo.TimelyAccessPHARM --PHARM(s)
ADD -- INITIATE ... ADD OF COLUMN(s)
     [Telehealth_Indicator] nvarchar(1) DEFAULT NULL -- DFLT VAL() IS NULL
; -- CONCLUDE ...

ALTER TABLE INFORMATICS.dbo.TimelyAccessPCP_ECM --PROV(s)
ADD -- INITIATE ... ADD OF COLUMN(s)
     [Telehealth_Indicator] nvarchar(1) DEFAULT NULL -- DFLT VAL() IS NULL
; -- CONCLUDE ...

ALTER TABLE INFORMATICS.dbo.TimelyAccessPCP_ECM_Extender --MIDLEVEL(s)
ADD -- INITIATE ... ADD OF COLUMN(s)
     [Telehealth_Indicator] nvarchar(1) DEFAULT NULL -- DFLT VAL() IS NULL
; -- CONCLUDE ...

ALTER TABLE INFORMATICS.dbo.TimelyAccessSPE_ECM --PROV(s)
ADD -- INITIATE ... ADD OF COLUMN(s)
     [Telehealth_Indicator] nvarchar(1) DEFAULT NULL -- DFLT VAL() IS NULL
; -- CONCLUDE ...

ALTER TABLE INFORMATICS.dbo.TimelyAccessFAC_ECM --FAC(s)
ADD -- INITIATE ... ADD OF COLUMN(s)
     [Telehealth_Indicator] nvarchar(1) DEFAULT NULL -- DFLT VAL() IS NULL
; -- CONCLUDE ...

ALTER TABLE INFORMATICS.dbo.TimelyAccessCLINIC_ECM --FAC(s)
ADD -- INITIATE ... ADD OF COLUMN(s)
     [Telehealth_Indicator] nvarchar(1) DEFAULT NULL -- DFLT VAL() IS NULL
; -- CONCLUDE ...

ALTER TABLE INFORMATICS.dbo.TimelyAccessPHARM_ECM --PHARM(s)
ADD -- INITIATE ... ADD OF COLUMN(s)
     [Telehealth_Indicator] nvarchar(1) DEFAULT NULL -- DFLT VAL() IS NULL
; -- CONCLUDE ...

-- ============================================================================
	-- PROVIDER TABLES: 
-- ============================================================================
ALTER TABLE INFORMATICS.dbo.PROVDIR_PCP
ADD -- INITIATE ... ADD OF COLUMN(s)
     [Telehealth_Indicator] nvarchar(1) DEFAULT NULL -- DFLT VAL() IS NULL
    ,[COUNTY] nvarchar(255) DEFAULT NULL -- DFLT VAL() IS NULL
; -- CONCLUDE ...

ALTER TABLE INFORMATICS.dbo.PROVDIR_NPMP
ADD -- INITIATE ... ADD OF COLUMN(s)
     [Telehealth_Indicator] nvarchar(1) DEFAULT NULL -- DFLT VAL() IS NULL
    ,[COUNTY] nvarchar(255) DEFAULT NULL -- DFLT VAL() IS NULL
; -- CONCLUDE ...

ALTER TABLE INFORMATICS.dbo.PROVDIR_SPE
ADD -- INITIATE ... ADD OF COLUMN(s)
     [Telehealth_Indicator] nvarchar(1) DEFAULT NULL -- DFLT VAL() IS NULL
    ,[COUNTY] nvarchar(255) DEFAULT NULL -- DFLT VAL() IS NULL
; -- CONCLUDE ...

ALTER TABLE INFORMATICS.dbo.PROVDIR_MH
ADD -- INITIATE ... ADD OF COLUMN(s)
     [Telehealth_Indicator] nvarchar(1) DEFAULT NULL -- DFLT VAL() IS NULL
    ,[COUNTY] nvarchar(255) DEFAULT NULL -- DFLT VAL() IS NULL
; -- CONCLUDE ...

ALTER TABLE INFORMATICS.dbo.PROVDIR_AHP
ADD -- INITIATE ... ADD OF COLUMN(s)
     [Telehealth_Indicator] nvarchar(1) DEFAULT NULL -- DFLT VAL() IS NULL
    ,[COUNTY] nvarchar(255) DEFAULT NULL -- DFLT VAL() IS NULL
; -- CONCLUDE ...

ALTER TABLE INFORMATICS.dbo.PROVDIR_VSP
ADD -- INITIATE ... ADD OF COLUMN(s)
     [Telehealth_Indicator] nvarchar(1) DEFAULT NULL -- DFLT VAL() IS NULL
    ,[COUNTY] nvarchar(255) DEFAULT NULL -- DFLT VAL() IS NULL
; -- CONCLUDE ...

-- ============================================================================
	-- HOSPITAL TABLES: 
-- ============================================================================
ALTER TABLE INFORMATICS.dbo.PROVDIR_HOSGENERALACUTE
ADD -- INITIATE ... ADD OF COLUMN(s)
     [Telehealth_Indicator] nvarchar(1) DEFAULT NULL -- DFLT VAL() IS NULL
    ,[COUNTY] nvarchar(255) DEFAULT NULL -- DFLT VAL() IS NULL
; -- CONCLUDE ...

ALTER TABLE INFORMATICS.dbo.PROVDIR_HOSMH
ADD -- INITIATE ... ADD OF COLUMN(s)
     [Telehealth_Indicator] nvarchar(1) DEFAULT NULL -- DFLT VAL() IS NULL
    ,[COUNTY] nvarchar(255) DEFAULT NULL -- DFLT VAL() IS NULL
; -- CONCLUDE ...

ALTER TABLE INFORMATICS.dbo.PROVDIR_HOSLTACH
ADD -- INITIATE ... ADD OF COLUMN(s)
     [Telehealth_Indicator] nvarchar(1) DEFAULT NULL -- DFLT VAL() IS NULL
    ,[COUNTY] nvarchar(255) DEFAULT NULL -- DFLT VAL() IS NULL
; -- CONCLUDE ...

-- ============================================================================
	-- FACILITY TABLES:
-- ============================================================================
ALTER TABLE INFORMATICS.dbo.PROVDIR_SNF
ADD -- INITIATE ... ADD OF COLUMN(s)
     [Telehealth_Indicator] nvarchar(1) DEFAULT NULL -- DFLT VAL() IS NULL
    ,[COUNTY] nvarchar(255) DEFAULT NULL -- DFLT VAL() IS NULL
; -- CONCLUDE ...

ALTER TABLE INFORMATICS.dbo.PROVDIR_RCF
ADD -- INITIATE ... ADD OF COLUMN(s)
     [Telehealth_Indicator] nvarchar(1) DEFAULT NULL -- DFLT VAL() IS NULL
    ,[COUNTY] nvarchar(255) DEFAULT NULL -- DFLT VAL() IS NULL
; -- CONCLUDE ...

ALTER TABLE INFORMATICS.dbo.PROVDIR_HOSPICE
ADD -- INITIATE ... ADD OF COLUMN(s)
     [Telehealth_Indicator] nvarchar(1) DEFAULT NULL -- DFLT VAL() IS NULL
    ,[COUNTY] nvarchar(255) DEFAULT NULL -- DFLT VAL() IS NULL
; -- CONCLUDE ...

ALTER TABLE INFORMATICS.dbo.PROVDIR_IPREHAB
ADD -- INITIATE ... ADD OF COLUMN(s)
     [Telehealth_Indicator] nvarchar(1) DEFAULT NULL -- DFLT VAL() IS NULL
    ,[COUNTY] nvarchar(255) DEFAULT NULL -- DFLT VAL() IS NULL
; -- CONCLUDE ...

ALTER TABLE INFORMATICS.dbo.PROVDIR_CBAS
ADD -- INITIATE ... ADD OF COLUMN(s)
     [Telehealth_Indicator] nvarchar(1) DEFAULT NULL -- DFLT VAL() IS NULL
    ,[COUNTY] nvarchar(255) DEFAULT NULL -- DFLT VAL() IS NULL
; -- CONCLUDE ...

ALTER TABLE INFORMATICS.dbo.PROVDIR_BRC
ADD -- INITIATE ... ADD OF COLUMN(s)
     [Telehealth_Indicator] nvarchar(1) DEFAULT NULL -- DFLT VAL() IS NULL
    ,[COUNTY] nvarchar(255) DEFAULT NULL -- DFLT VAL() IS NULL
; -- CONCLUDE ...

-- ============================================================================
	-- HOME-BASED SERVICES:
-- ============================================================================
ALTER TABLE INFORMATICS.dbo.PROVDIR_HDM
ADD -- INITIATE ... ADD OF COLUMN(s)
     [Telehealth_Indicator] nvarchar(1) DEFAULT NULL -- DFLT VAL() IS NULL
    ,[COUNTY] nvarchar(255) DEFAULT NULL -- DFLT VAL() IS NULL
; -- CONCLUDE ...

ALTER TABLE INFORMATICS.dbo.PROVDIR_HHC
ADD -- INITIATE ... ADD OF COLUMN(s)
     [Telehealth_Indicator] nvarchar(1) DEFAULT NULL -- DFLT VAL() IS NULL
    ,[COUNTY] nvarchar(255) DEFAULT NULL -- DFLT VAL() IS NULL
; -- CONCLUDE ...

ALTER TABLE INFORMATICS.dbo.PROVDIR_IHSS
ADD -- INITIATE ... ADD OF COLUMN(s)
     [Telehealth_Indicator] nvarchar(1) DEFAULT NULL -- DFLT VAL() IS NULL
    ,[COUNTY] nvarchar(255) DEFAULT NULL -- DFLT VAL() IS NULL
; -- CONCLUDE ...

-- ============================================================================
	-- ANCILLARY SERVICES: 
-- ============================================================================
ALTER TABLE INFORMATICS.dbo.PROVDIR_ASC
ADD -- INITIATE ... ADD OF COLUMN(s)
     [Telehealth_Indicator] nvarchar(1) DEFAULT NULL -- DFLT VAL() IS NULL
    ,[COUNTY] nvarchar(255) DEFAULT NULL -- DFLT VAL() IS NULL
; -- CONCLUDE ...

ALTER TABLE INFORMATICS.dbo.PROVDIR_DXC
ADD -- INITIATE ... ADD OF COLUMN(s)
     [Telehealth_Indicator] nvarchar(1) DEFAULT NULL -- DFLT VAL() IS NULL
    ,[COUNTY] nvarchar(255) DEFAULT NULL -- DFLT VAL() IS NULL
; -- CONCLUDE ...

ALTER TABLE INFORMATICS.dbo.PROVDIR_LAB
ADD -- INITIATE ... ADD OF COLUMN(s)
     [Telehealth_Indicator] nvarchar(1) DEFAULT NULL -- DFLT VAL() IS NULL
    ,[COUNTY] nvarchar(255) DEFAULT NULL -- DFLT VAL() IS NULL
; -- CONCLUDE ...

ALTER TABLE INFORMATICS.dbo.PROVDIR_DLC
ADD -- INITIATE ... ADD OF COLUMN(s)
     [Telehealth_Indicator] nvarchar(1) DEFAULT NULL -- DFLT VAL() IS NULL
    ,[COUNTY] nvarchar(255) DEFAULT NULL -- DFLT VAL() IS NULL
; -- CONCLUDE ...

ALTER TABLE INFORMATICS.dbo.PROVDIR_URC
ADD -- INITIATE ... ADD OF COLUMN(s)
     [Telehealth_Indicator] nvarchar(1) DEFAULT NULL -- DFLT VAL() IS NULL
    ,[COUNTY] nvarchar(255) DEFAULT NULL -- DFLT VAL() IS NULL
; -- CONCLUDE ...

ALTER TABLE INFORMATICS.dbo.PROVDIR_MIN
ADD -- INITIATE ... ADD OF COLUMN(s)
     [Telehealth_Indicator] nvarchar(1) DEFAULT NULL -- DFLT VAL() IS NULL
    ,[COUNTY] nvarchar(255) DEFAULT NULL -- DFLT VAL() IS NULL
; -- CONCLUDE ...

ALTER TABLE INFORMATICS.dbo.PROVDIR_PPH
ADD -- INITIATE ... ADD OF COLUMN(s)
     [Telehealth_Indicator] nvarchar(1) DEFAULT NULL -- DFLT VAL() IS NULL
    ,[COUNTY] nvarchar(255) DEFAULT NULL -- DFLT VAL() IS NULL
; -- CONCLUDE ...

ALTER TABLE INFORMATICS.dbo.PROVDIR_CLINIC
ADD -- INITIATE ... ADD OF COLUMN(s)
     [Telehealth_Indicator] nvarchar(1) DEFAULT NULL -- DFLT VAL() IS NULL
    ,[COUNTY] nvarchar(255) DEFAULT NULL -- DFLT VAL() IS NULL
; -- CONCLUDE ...

-- ============================================================================
	-- PHARMACY TABLES: 
-- ============================================================================
ALTER TABLE INFORMATICS.dbo.PROVDIR_PHARM
ADD -- INITIATE ... ADD OF COLUMN(s)
     [Telehealth_Indicator] nvarchar(1) DEFAULT NULL -- DFLT VAL() IS NULL
    ,[COUNTY] nvarchar(255) DEFAULT NULL -- DFLT VAL() IS NULL
; -- CONCLUDE ...

ALTER TABLE INFORMATICS.dbo.PROVDIR_PHARM_RCP
ADD -- INITIATE ... ADD OF COLUMN(s)
     [Telehealth_Indicator] nvarchar(1) DEFAULT NULL -- DFLT VAL() IS NULL
    ,[COUNTY] nvarchar(255) DEFAULT NULL -- DFLT VAL() IS NULL
; -- CONCLUDE ...

ALTER TABLE INFORMATICS.dbo.PROVDIR_PHARM_MO
ADD -- INITIATE ... ADD OF COLUMN(s)
     [Telehealth_Indicator] nvarchar(1) DEFAULT NULL -- DFLT VAL() IS NULL
    ,[COUNTY] nvarchar(255) DEFAULT NULL -- DFLT VAL() IS NULL
; -- CONCLUDE ...

ALTER TABLE INFORMATICS.dbo.PROVDIR_PHARM_HI
ADD -- INITIATE ... ADD OF COLUMN(s)
     [Telehealth_Indicator] nvarchar(1) DEFAULT NULL -- DFLT VAL() IS NULL
    ,[COUNTY] nvarchar(255) DEFAULT NULL -- DFLT VAL() IS NULL
; -- CONCLUDE ...

ALTER TABLE INFORMATICS.dbo.PROVDIR_PHARM_LTC
ADD -- INITIATE ... ADD OF COLUMN(s)
     [Telehealth_Indicator] nvarchar(1) DEFAULT NULL -- DFLT VAL() IS NULL
    ,[COUNTY] nvarchar(255) DEFAULT NULL -- DFLT VAL() IS NULL
; -- CONCLUDE ...

ALTER TABLE INFORMATICS.dbo.PROVDIR_PHARM_ITU
ADD -- INITIATE ... ADD OF COLUMN(s)
     [Telehealth_Indicator] nvarchar(1) DEFAULT NULL -- DFLT VAL() IS NULL
    ,[COUNTY] nvarchar(255) DEFAULT NULL -- DFLT VAL() IS NULL
; -- CONCLUDE ...

-- ============================================================================
	-- ECM/COMMUNITY SUPPORT PROVIDERS: 
-- ============================================================================
ALTER TABLE INFORMATICS.dbo.PROVDIR_CHW
ADD -- INITIATE ... ADD OF COLUMN(s)
     [Telehealth_Indicator] nvarchar(1) DEFAULT NULL -- DFLT VAL() IS NULL
    ,[COUNTY] nvarchar(255) DEFAULT NULL -- DFLT VAL() IS NULL
; -- CONCLUDE ...

ALTER TABLE INFORMATICS.dbo.PROVDIR_DOULA
ADD -- INITIATE ... ADD OF COLUMN(s)
     [Telehealth_Indicator] nvarchar(1) DEFAULT NULL -- DFLT VAL() IS NULL
    ,[COUNTY] nvarchar(255) DEFAULT NULL -- DFLT VAL() IS NULL
; -- CONCLUDE ...

ALTER TABLE INFORMATICS.dbo.PROVDIR_ECMCSP
ADD -- INITIATE ... ADD OF COLUMN(s)
     [Telehealth_Indicator] nvarchar(1) DEFAULT NULL -- DFLT VAL() IS NULL
    ,[COUNTY] nvarchar(255) DEFAULT NULL -- DFLT VAL() IS NULL
; -- CONCLUDE ...
-- ============================================================================
-- END OF SCRIPT
-- TOTAL TABLES MODIFIED: 35
-- ============================================================================

SELECT TOP 1 [Telehealth_Indicator],[COUNTY], * FROM INFORMATICS.dbo.TimelyAccessPCP --PROV(s)
SELECT TOP 1 [Telehealth_Indicator],[COUNTY], * FROM INFORMATICS.dbo.TimelyAccessPCP_Extender --MIDLEVEL(s)
SELECT TOP 1 [Telehealth_Indicator],[COUNTY], * FROM INFORMATICS.dbo.TimelyAccessSPE --PROV(s)
SELECT TOP 1 [Telehealth_Indicator],[COUNTY], * FROM INFORMATICS.dbo.TimelyAccessFAC --FAC(s)
SELECT TOP 1 [Telehealth_Indicator],[COUNTY], * FROM INFORMATICS.dbo.TimelyAccessCLINIC --FAC(s)
SELECT TOP 1 [Telehealth_Indicator],[COUNTY], * FROM INFORMATICS.dbo.TimelyAccessPHARM --PHARM(s)

SELECT TOP 1 [Telehealth_Indicator],[COUNTY], * FROM INFORMATICS.dbo.TimelyAccessPCP_ECM --PROV(s)
SELECT TOP 1 [Telehealth_Indicator],[COUNTY], * FROM INFORMATICS.dbo.TimelyAccessPCP_ECM_Extender --MIDLEVEL(s)
SELECT TOP 1 [Telehealth_Indicator],[COUNTY], * FROM INFORMATICS.dbo.TimelyAccessSPE_ECM --PROV(s)
SELECT TOP 1 [Telehealth_Indicator],[COUNTY], * FROM INFORMATICS.dbo.TimelyAccessFAC_ECM --FAC(s)
SELECT TOP 1 [Telehealth_Indicator],[COUNTY], * FROM INFORMATICS.dbo.TimelyAccessCLINIC_ECM --FAC(s)
SELECT TOP 1 [Telehealth_Indicator],[COUNTY], * FROM INFORMATICS.dbo.TimelyAccessPHARM_ECM --PHARM(s)

SELECT TOP 1 [Telehealth_Indicator],[COUNTY], * FROM INFORMATICS.dbo.PROVDIR_PCP WHERE 1=1 AND [Participating Network] LIKE '%CHPIV%' -- PROV(s)
SELECT TOP 1 [Telehealth_Indicator],[COUNTY], * FROM INFORMATICS.dbo.PROVDIR_NPMP WHERE 1=1 AND [Participating Network] LIKE '%CHPIV%' -- MIDLEVEL(s) NPMP
SELECT TOP 1 [Telehealth_Indicator],[COUNTY], * FROM INFORMATICS.dbo.PROVDIR_SPE WHERE 1=1 AND [Participating Network] LIKE '%CHPIV%' -- PROV(s)
SELECT TOP 1 [Telehealth_Indicator],[COUNTY], * FROM INFORMATICS.dbo.PROVDIR_MH WHERE 1=1 AND [Participating Network] LIKE '%CHPIV%' -- PROV(s)
SELECT TOP 1 [Telehealth_Indicator],[COUNTY], * FROM INFORMATICS.dbo.PROVDIR_AHP WHERE 1=1 AND [Participating Network] LIKE '%CHPIV%' -- PROV(s)
SELECT TOP 1 [Telehealth_Indicator],[COUNTY], * FROM INFORMATICS.dbo.PROVDIR_VSP WHERE 1=1 AND [Participating Network] LIKE '%CHPIV%' -- PROV(s)
SELECT TOP 1 [Telehealth_Indicator],[COUNTY], * FROM INFORMATICS.dbo.PROVDIR_HOSGENERALACUTE WHERE 1=1 AND [Participating Network] LIKE '%CHPIV%' -- HOSGAH
SELECT TOP 1 [Telehealth_Indicator],[COUNTY], * FROM INFORMATICS.dbo.PROVDIR_HOSMH WHERE 1=1 AND [Participating Network] LIKE '%CHPIV%' -- 'Mental Health Hospitals' CONTRACTUALLY FOR CMC(s) ONLY!!!
SELECT TOP 1 [Telehealth_Indicator],[COUNTY], * FROM INFORMATICS.dbo.PROVDIR_HOSLTACH WHERE 1=1 AND [Participating Network] LIKE '%CHPIV%' -- 'Long Term Acute Care Hospitals'
SELECT TOP 1 [Telehealth_Indicator],[COUNTY], * FROM INFORMATICS.dbo.PROVDIR_SNF WHERE 1=1 AND [Participating Network] LIKE '%CHPIV%'
SELECT TOP 1 [Telehealth_Indicator],[COUNTY], * FROM INFORMATICS.dbo.PROVDIR_RCF WHERE 1=1 AND [Participating Network] LIKE '%CHPIV%'
SELECT TOP 1 [Telehealth_Indicator],[COUNTY], * FROM INFORMATICS.dbo.PROVDIR_HOSPICE WHERE 1=1 AND [Participating Network] LIKE '%CHPIV%' -- ADD HOSPICE facility(-ies) per SC ON 20161012 Walter/Maryanne/Kelly Question 13 is asking for the display in printed and online for 2 new sections (hospice & inpatient rehabilitation).  I will send specs on hospice. 
SELECT TOP 1 [Telehealth_Indicator],[COUNTY], * FROM INFORMATICS.dbo.PROVDIR_IPREHAB WHERE 1=1 AND [Participating Network] LIKE '%CHPIV%' -- DUPLICATE 'PROVDIR_SNF' -- ADD HOSPICE facility(-ies) per SC ON 20161012 Walter/Maryanne/Kelly Question 13 is asking for the display in printed and online for 2 new sections (hospice & inpatient rehabilitation).  I will send specs on hospice. 
SELECT TOP 1 [Telehealth_Indicator],[COUNTY], * FROM INFORMATICS.dbo.PROVDIR_CBAS WHERE 1=1 AND [Participating Network] LIKE '%CHPIV%' -- INCLUDE ALL
SELECT TOP 1 [Telehealth_Indicator],[COUNTY], * FROM INFORMATICS.dbo.PROVDIR_BRC WHERE 1=1 AND [Participating Network] LIKE '%CHPIV%' -- ADD ON 20190115
SELECT TOP 1 [Telehealth_Indicator],[COUNTY], * FROM INFORMATICS.dbo.PROVDIR_HDM WHERE 1=1 AND [Participating Network] LIKE '%CHPIV%' -- INCLUDE ALL
SELECT TOP 1 [Telehealth_Indicator],[COUNTY], * FROM INFORMATICS.dbo.PROVDIR_HHC WHERE 1=1 AND [Participating Network] LIKE '%CHPIV%' -- INCLUDE ALL
SELECT TOP 1 [Telehealth_Indicator],[COUNTY], * FROM INFORMATICS.dbo.PROVDIR_IHSS WHERE 1=1 AND [Participating Network] LIKE '%CHPIV%' -- [Participating Network] aka LINE_OF_BUSINESS DISTINCTION NOW PRESENT
SELECT TOP 1 [Telehealth_Indicator],[COUNTY], * FROM INFORMATICS.dbo.PROVDIR_ASC WHERE 1=1 AND [Participating Network] LIKE '%CHPIV%' -- was AMBSC
SELECT TOP 1 [Telehealth_Indicator],[COUNTY], * FROM INFORMATICS.dbo.PROVDIR_DXC WHERE 1=1 AND [Participating Network] LIKE '%CHPIV%'
SELECT TOP 1 [Telehealth_Indicator],[COUNTY], * FROM INFORMATICS.dbo.PROVDIR_LAB WHERE 1=1 AND [Participating Network] LIKE '%CHPIV%' -- LAB
SELECT TOP 1 [Telehealth_Indicator],[COUNTY], * FROM INFORMATICS.dbo.PROVDIR_DLC WHERE 1=1 AND [Participating Network] LIKE '%CHPIV%'
SELECT TOP 1 [Telehealth_Indicator],[COUNTY], * FROM INFORMATICS.dbo.PROVDIR_URC WHERE 1=1 AND [Participating Network] LIKE '%CHPIV%'
SELECT TOP 1 [Telehealth_Indicator],[COUNTY], * FROM INFORMATICS.dbo.PROVDIR_MIN WHERE 1=1 AND [Participating Network] LIKE '%CHPIV%' -- MINUTE CLINIC(s)
SELECT TOP 1 [Telehealth_Indicator],[COUNTY], * FROM INFORMATICS.dbo.PROVDIR_PPH WHERE 1=1 AND [Participating Network] LIKE '%CHPIV%' -- PPH (Palomar Pomerado Healthcare) EXPRESS
SELECT TOP 1 [Telehealth_Indicator],[COUNTY], * FROM INFORMATICS.dbo.PROVDIR_CLINIC WHERE 1=1 AND [Participating Network] LIKE '%CHPIV%' -- INCLUDE ALL ... AND ...CONSOLIDATE LANGUAGE(s) WITH JL_Languages_...sql ADD BACK [CULTURAL COMPETENCE]
SELECT TOP 1 [Telehealth_Indicator],[COUNTY], * FROM INFORMATICS.dbo.PROVDIR_PHARM WHERE 1=1 AND [Participating Network] LIKE '%CHPIV%' -- INCLUDE ALL
SELECT TOP 1 [Telehealth_Indicator],[COUNTY], * FROM INFORMATICS.dbo.PROVDIR_PHARM_RCP WHERE 1=1 AND [Participating Network] LIKE '%CHPIV%' -- INCLUDE ALL
SELECT TOP 1 [Telehealth_Indicator],[COUNTY], * FROM INFORMATICS.dbo.PROVDIR_PHARM_MO WHERE 1=1 AND [Participating Network] LIKE '%CHPIV%' -- INCLUDE ALL
SELECT TOP 1 [Telehealth_Indicator],[COUNTY], * FROM INFORMATICS.dbo.PROVDIR_PHARM_HI WHERE 1=1 AND [Participating Network] LIKE '%CHPIV%' -- INCLUDE ALL
SELECT TOP 1 [Telehealth_Indicator],[COUNTY], * FROM INFORMATICS.dbo.PROVDIR_PHARM_LTC WHERE 1=1 AND [Participating Network] LIKE '%CHPIV%' -- INCLUDE ALL
SELECT TOP 1 [Telehealth_Indicator],[COUNTY], * FROM INFORMATICS.dbo.PROVDIR_PHARM_ITU WHERE 1=1 AND [Participating Network] LIKE '%CHPIV%' -- INCLUDE ALL
SELECT TOP 1 [Telehealth_Indicator],[COUNTY], * FROM INFORMATICS.dbo.PROVDIR_CHW WHERE 1=1 AND [Participating Network] LIKE '%CHPIV%' -- NEW ADDITION(S)
SELECT TOP 1 [Telehealth_Indicator],[COUNTY], * FROM INFORMATICS.dbo.PROVDIR_DOULA WHERE 1=1 AND [Participating Network] LIKE '%CHPIV%' -- NEW ADDITION(S)
SELECT TOP 1 [Telehealth_Indicator],[COUNTY], * FROM INFORMATICS.dbo.PROVDIR_ECMCSP WHERE 1=1 AND [Participating Network] LIKE '%CHPIV%' -- NEW ADDITION(S)
-- SELECT TOP 1 [Telehealth_Indicator],[COUNTY], * FROM INFORMATICS.dbo.PROVDIR_COMMUNITYSUPPORTS WHERE 1=1 AND [Participating Network] LIKE '%CHPIV%' -- SUNSET DECOMMISSION DEPRECATED FOR PROVDIR_ECMCSP







FROM eVips_chgcv.dbo.vwPractitionerDemographics AS vpd
	INNER JOIN eVips_chgcv.dbo.vwPractitionerProducts AS vpp ON vpd.PractitionerID = vpp.PractitionerID -- aka cert_provider
		-- AND vpp.ProductID = vpps.ProductID -- aka cert_provider
	INNER JOIN eVips_chgcv.dbo.vwPractitionerProductSpecialties AS vpps ON vpp.PractitionerProductRecID = vpps.PractitionerProductRecID
	INNER JOIN 
	( -- INITIATE ...
	SELECT DISTINCT vpprovloc.PractitionerID,vpprovloc.PracticeID,vpprovloc.LocationID,vpprovloc.AddressID,vpprovloc.LastName,vpprovloc.FirstName,vpprovloc.Archived,vpprovloc.LocationName,vpprovloc.NationalProviderID,vpprovloc.LocationNotes,vpprovloc.PracticeTypeName,vpprovloc.ProviderNumber,vpprovloc.website,vpfacloc.LineNumber1,vpfacloc.LineNumber2,vpfacloc.LineNumber3,vpfacloc.City,vpfacloc.[State],vpfacloc.ZipCode,vpfacloc.LocationTypeName 
	FROM eVips_chgcv.dbo.vwPractitionerLocations AS vpprovloc
		INNER JOIN eVips_chgcv.dbo.vwPracticeLocations AS vpfacloc ON vpprovloc.PracticeID = vpfacloc.PracticeID
			AND vpprovloc.LocationID = vpfacloc.LocationID 
	WHERE 1=1
		AND (LTRIM(RTRIM(ISNULL(vpfacloc.LocationTypeName,'')))) LIKE '%PRACTI%'
		) -- CONCLUDE ...
		AS vploc ON vploc.PractitionerID = vpd.PractitionerID
			AND vploc.PracticeID = vpp.PracticeID
			AND vploc.LocationID = vpp.LocationID
			-- AND vploc.AddressID = vpp.AddressID
	INNER JOIN eVips_chgcv.dbo.vwPracticeLocations AS vpracloc ON vpp.practiceid = vpracloc.practiceid  --SPECIAL ADD - ON JOIN (s)
		AND vpp.Locationid = vpracloc.Locationid --SPECIAL ADD - ON JOIN (s)

		LEFT JOIN eVips_chgcv.dbo.vwPractitionerSpecialties AS vps ON vpd.PractitionerID = vps.PractitionerID	
			AND vps.specialtycode = vpps.specialtycode
		LEFT JOIN 
		( -- INITIATE ...
		SELECT DISTINCT ProviderID,TableName,EntityCode,EntityName,EntityTypeCode,EntityTypeName 
		FROM eVips_chgcv.dbo.vwEntityAssignments 
		WHERE (LTRIM(RTRIM(ISNULL(TableName,'')))) LIKE '%PRACTI%'
		) -- CONCLUDE ... 
		AS vea ON vpd.PractitionerID = vea.ProviderID --ProviderID = PractitionerID WHERE (LTRIM(RTRIM(vea.TableName))) LIKE '%Practit%' OR  ProviderID = PracticeID WHERE (LTRIM(RTRIM(vea.TableName))) LIKE '%Practice%'
		LEFT JOIN 
		( -- INITIATE ...
		SELECT DISTINCT * FROM #HOSPpriv 
		) -- CONCLUDE ...
		AS hp ON (LTRIM(RTRIM(ISNULL(vpd.PractitionerID,'')))) = (LTRIM(RTRIM(ISNULL(hp.lookup_key,''))))
		LEFT JOIN #ACCESSIBILITY AS acc ON vpp.PracticeID = acc.PracticeID
			AND vpp.LocationID = acc.LocationID
		LEFT JOIN #AGERESTRICTION_PROV AS ager ON vpp.PractitionerID = ager.PractitionerID
			AND vpp.ProductID = ager.ProductID
			AND vpp.PracticeID = ager.PracticeID
			AND vpp.LocationID = ager.LocationID
			AND vpp.PractitionerProductRecID = ager.PractitionerProductRecID
			-- AND (LTRIM(RTRIM(ager.AddressID))) = (LTRIM(RTRIM(vpp.AddressID)))	
		LEFT JOIN #HOURS_PROV AS h ON vpd.PractitionerID = h.PractitionerID
				AND vpp.Locationid= h.LocationID
				-- AND (LTRIM(RTRIM(h.AddressID))) = (LTRIM(RTRIM(vpp.AddressID)))	
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
		WHERE (LTRIM(RTRIM(ISNULL(county,'')))) LIKE '%SAN%DIEGO%'
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
		WHERE r.tablename IN ('Specialties')
			AND r.fieldName IN ('Specialty Grouping - Timely Access')
			) -- CONCLUDE ...
		AS profile ON CASE
		WHEN vpps.SpecialtyCode IS NULL
		THEN (LTRIM(RTRIM(vpps.SpecialtyName)))
		ELSE (LTRIM(RTRIM(vpps.SpecialtyCode)))
		END = (LTRIM(RTRIM(ISNULL(profile.specialtycode,'')))) -- AS [DefineOTH_SPE]

		LEFT JOIN #FUTURETERM AS ftm ON LTRIM(RTRIM(ISNULL(ftm.NationalProviderID,''))) = LTRIM(RTRIM(ISNULL(vpd.NationalProviderID,'')))

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
		WHEN SUBSTRING(LTRIM(RTRIM(vploc.ZipCode)),1,1) = '0'
		THEN '0'+ SUBSTRING(LTRIM(RTRIM(vploc.ZipCode)),2,4)
		WHEN SUBSTRING(LTRIM(RTRIM(vploc.ZipCode)),1,1) = '00'
		THEN '00'+ SUBSTRING(LTRIM(RTRIM(vploc.ZipCode)),3,3)
		ELSE  SUBSTRING(LTRIM(RTRIM(vploc.ZipCode)),1,5) 
		END = addcounty.ZIP

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
WHERE 1=1
	AND ( -- INITIATE ... REGULAR PROVIDER 'IN NETWORK / IN DIRECTORY LOGIC'
	(LTRIM(RTRIM(ISNULL(vpps.InDirectory,'')))) LIKE @INDIR --SET @INDIR ='Y'--REMOVE FILTER FOR JOSEPH / TIMELYACCESS HBP(s)... '%' OR 'Y'  OR 'N'--SUBSTRING((LTRIM(RTRIM(cert_provider.in_directory))),1,1) LIKE @INDIR --see 'LTRIM(RTRIM(mcred.retrieve_list)) LIKE '%CN%V%'
	AND (LTRIM(RTRIM(vpd.Archived))) IN ('N') --WITH eVIPS LOGICAL BINARY OPTION(s) IN USE •	Must not be archived 
	AND (LTRIM(RTRIM(vpps.Archived))) IN ('N') -- ADD ON per MEETING ;WITH YOUNG LADY LAURA, SC & HL ON 20171226
	AND (LTRIM(RTRIM(vploc.Archived))) IN ('N') --WITH eVIPS LOGICAL BINARY OPTION(s) IN USE •	Must not be archived
	AND (LTRIM(RTRIM(vpracloc.Archived))) IN ('N')
	AND (LTRIM(RTRIM(ISNULL(vpd.PractitionerStatus,'')))) IN ('ACTIVE','') --•	Overall Status must be Active
	AND (LTRIM(RTRIM(vpp.Archived))) IN ('N') --WITH eVIPS LOGICAL BINARY OPTION(s) IN USE •	Must not be archived 
	) -- CONCLUDE ... REGULAR PROVIDER 'IN NETWORK / IN DIRECTORY LOGIC'
	AND ISNULL(vpp.StatusTypeName,'') IN ('Y','','Active','Active - Per Diem') --•	Plan Status must be: ‘Active’ or ‘Active Per Diem’ or Active VIP for a Product Name (CMC or MEDICAL):

	-- AND (LTRIM(RTRIM(vpp.StatusTypeName))) IN ('V') --JOSEPH 'SPECIAL' PROVIDER(s) LOGIC
	-- AND (LTRIM(RTRIM(vpp.StatusTypeName))) LIKE '%ACT%VIP%' --JOSEPH 'SPECIAL' PROVIDER(s) LOGIC

		-- SELECT DISTINCT ISNULL(StatusTypeName,'') FROM eVips_chgcv.dbo.vwPractitionerProducts
		-- SELECT DISTINCT (LTRIM(RTRIM(StatusTypeName))) FROM eVips_chgcv.dbo.vwPractitionerProducts
		
		
		
		
		
		
		
JAH 'POF FOOTER'
'CHPIV DSNP' WAS(): 
*   Not Accepting new patients at this time ^ Medicare providers that accept Medicaid
** See list of hospitals on page 382
+ Per Diem / Part Time Provider - May Have Limited Appt. Availability
++ Clinic Specialists - for Assigned Members Only
@ After Hours Telephone Number is the same as Daytime Number - For help picking a doctor and verifying the availability of selected providers, please call Member Services
at 1-800-224-7766.

If you have questions, please call CommuniCare Advantage at 1-888-244-4430 and TTY 1-855-266-4584, 24 hours a day, 7 days a week. The call is free. For more information, visit www.chgsd.com.For more information, visit www.chgsd.com. Accessibility Codes: P-Parking, EB-Exterior Building, IB-Interior Building, W-Wheelchair, R-Restroom, PD-Patient Diagnostic & Treatment Use, E-Exam Room & T-Exam Table/Scale

'CHPIV DSNP' NOW():
*   Not Accepting new patients at this time ^ Medicare providers that accept Medicaid
** See list of hospitals on page 382
+ Per Diem / Part Time Provider - May Have Limited Appt. Availability
++ Clinic Specialists - for Assigned Members Only
@ After Hours Telephone Number is the same as Daytime Number - For help picking a doctor and verifying the availability of selected providers, please call Member Services at 1-888-484-1412. If you have questions, please call Community Advantage Plus at 1-888-484-1412 and TTY 1-888-671-3263, 24 hours a day, 7 days a week. The call is free. For more information, visit www.chpiv.org. For more information, visit www.chpiv.org. Accessibility Codes: P-Parking, EB-Exterior Building, IB-Interior Building, W-Wheelchair, R-Restroom, PD-Patient Diagnostic & Treatment Use, E-Exam Room & T-Exam Table/Scale

'MCAL' WAS(): 
*** AH - Adult Individuals Experiencing Homelessness, AF - Adult Families Experiencing Homelessness, AA - Adult Avoidable Hospital or ED Utilization, AS - Adult SMI or SUD, AI - Adult Transitioning from Incarceration Statewide, AR - Adult at Risk for LTC Institutionalization, AN - Adult NF Transitioning to Community, CH - Child Individuals Experiencing Homelessness, CF - Child Families Experiencing Homelessness, CA - Child Avoidable Hospital or ED Utilization, CS - Child SMI or SUD, CC - Child CCS/CCS WCM with Additional Needs, CW- Child Welfare, CI - Child Transitioning from Incarceration Statewide ,CB - Child Birth Equity

'MCAL' NOW(): 
*** AH - Adult Individuals Experiencing Homelessness, AF - Adult Families Experiencing Homelessness, AA - Adult Avoidable Hospital or ED Utilization, AS - Adult SMI or SUD, AI - Adult Transitioning from Incarceration, AR - Adult at Risk for LTC Institutionalization, AN - Adult NF Transitioning to Community, AB - Adult Birth Equity, CH - Child Individuals Experiencing Homelessness, CF - Child Families Experiencing Homelessness, CA - Child Avoidable Hospital or ED Utilization, CS - Child SMI or SUD, CC - Child CCS/CCS WCM with Additional Needs, CW - Child Welfare, CI - Child Transitioning from Incarceration, CB- Child  Birth Equity







JAH 'Symphony - Per meeting with symphony on 20251224 change 24 Hours office hours TO 0000 - -- C024: Symphony - Per meeting with symphony on 20251224 change 24 Hours office hours TO 0000 - 2359'
		USE http://devops01:8080/IS/Informatics/_workitems/edit/22543/
		
Sir, FYI I wanted to convey that as it relates to the ECM/CS chapter the only table you would need is 'PROVDIR_ECMCSP'. Upon further review of my checklist notes the 'PROVDIR_COMMUNITYSUPPORTS ' table was sunset in favor of 'PROVDIR_ECMCSP'.

The means by which to distinguish between ECM & CS is in the Specialty field (see below for context)

SELECT * FROM INFORMATICS.dbo.PROVDIR_ECMCSP WHERE 1=1 AND [Participating Network] LIKE '%CHPIV%' -- NEW ADDITION(S)

SELECT DISTINCT Specialty
,CASE
WHEN Specialty LIKE '%Enhanced%'
THEN 'ECM'
ELSE 'CS'
END AS ECMCS_Type
FROM INFORMATICS.dbo.PROVDIR_ECMCSP 
WHERE 1=1
   -- AND [Participating Network] LIKE '%CHPIV%' -- NEW ADDITION(S)

SELECT * FROM INFORMATICS.dbo.PROVDIR_COMMUNITYSUPPORTS -- WHERE 1=1 AND [Participating Network] LIKE '%CHPIV%' -- SUNSET DECOMMISSION DEPRECATED FOR PROVDIR_ECMCSP
	
-- C006: ADD NPI TO OUTPUT PER MS JOHANNA ON  20251106 '... I hate to request something due asap so I am terribly sorry but DHCS is asking for the NPI to be included in the date on the excel. Is there anyway you can regenerate with the NPI today? This requires upload today ☹ ...'		

-- ====================================================================
	-- FILECONTROL: 
-- ====================================================================
		-- SELECT ' ' AS 'STAND ALONE #BASELINE', * FROM INFORMATICS.dbo.ENTITY_ID_MAPPING
		
		-- SELECT * FROM INFORMATICS.dbo.SYMPHONY_ENTITY
		-- SELECT * FROM INFORMATICS.dbo.SYMPHONY_LOCATION
		-- SELECT * FROM INFORMATICS.dbo.SYMPHONY_ADDRESS
		-- SELECT * FROM INFORMATICS.dbo.SYMPHONY_CONTACT
		-- SELECT * FROM INFORMATICS.dbo.SYMPHONY_ROSTER -- AS OF 20250117
		-- SELECT * FROM INFORMATICS.dbo.SYMPHONY_IDENTIFIER
		-- SELECT * FROM INFORMATICS.dbo.SYMPHONY_LANGUAGE -- AS OF 20250224
		-- SELECT * FROM INFORMATICS.dbo.SYMPHONY_TAXONOMY
		-- SELECT * FROM INFORMATICS.dbo.SYMPHONY_HOSPITAL
		-- SELECT * FROM INFORMATICS.dbo.SYMPHONY_NETWORK
		-- SELECT * FROM INFORMATICS.dbo.SYMPHONY_HOURS
		-- SELECT * FROM INFORMATICS.dbo.SYMPHONY_BED_DETAIL

		-- SELECT DISTINCT FileTableName FROM INFORMATICS.dbo.SYMPHONY_ENTITY WHERE 1=1 AND ENTITY_TYPE = 'BUSINESS'
		-- SELECT DISTINCT FileTableName FROM INFORMATICS.dbo.SYMPHONY_LOCATION
		-- SELECT DISTINCT FileTableName FROM INFORMATICS.dbo.SYMPHONY_ADDRESS
		-- SELECT DISTINCT FileTableName FROM INFORMATICS.dbo.SYMPHONY_CONTACT
		-- SELECT DISTINCT FileTableName FROM INFORMATICS.dbo.SYMPHONY_ROSTER
		-- SELECT DISTINCT FileTableName FROM INFORMATICS.dbo.SYMPHONY_IDENTIFIER
		-- SELECT DISTINCT FileTableName FROM INFORMATICS.dbo.SYMPHONY_LANGUAGE
		-- SELECT DISTINCT FileTableName FROM INFORMATICS.dbo.SYMPHONY_TAXONOMY
		-- SELECT DISTINCT FileTableName FROM INFORMATICS.dbo.SYMPHONY_HOSPITAL
		-- SELECT DISTINCT FileTableName FROM INFORMATICS.dbo.SYMPHONY_NETWORK
		-- SELECT DISTINCT FileTableName FROM INFORMATICS.dbo.SYMPHONY_HOURS
		-- SELECT DISTINCT FileTableName FROM INFORMATICS.dbo.SYMPHONY_BED_DETAIL

		SELECT ' ' AS 'Symphony - Per meeting with symphony on 20251224 change 24 Hours office hours TO 0000 - -- C024: Symphony - Per meeting with symphony on 20251224 change 24 Hours office hours TO 0000 - 2359',*
		FROM INFORMATICS.dbo.SYMPHONY_HOURS
		WHERE 1=1
			AND START_HOUR = END_HOUR
			AND START_MINUTE = END_MINUTE

/* UPDATE INFORMATICS.dbo.SYMPHONY_HOURS -- C024: Symphony - Per meeting with symphony on 20251224 change 24 Hours office hours TO 0000 - 2359
SET START_HOUR = 0
,START_MINUTE = 0
,END_HOUR = 23
,END_MINUTE = 59
FROM INFORMATICS.dbo.SYMPHONY_HOURS
WHERE 1=1
	AND START_HOUR = END_HOUR
	AND START_MINUTE = END_MINUTE */	

		SELECT DISTINCT 'CHGSD_FILECONTROL_'+REPLACE(REPLACE(REPLACE(LTRIM(RTRIM(CAST( CONVERT(NVARCHAR(25),TRY_CONVERT(DATETIME,GETDATE()),120) AS NVARCHAR(25)))),' ',''),'-',''),':','') AS FileTableName,* 
		FROM INFORMATICS.dbo.SYMPHONY_FILECONTROL
		ORDER BY FILE_SEQ_NBR;







JAH 'symphony'

WHERE 1=1 -- C###: ALLOW MISSING TAXONOMY TO PASS PER INTERNAL DISCUSSION AS OF AUG 2025 ... 
	AND NOT ISNULL(PLACEHOLDER_TAXONOMY,'') = '' -- NO NOT NEGATIVE ,. != ... C###: DEPLOY INCLUSION SCRIPT OF ENTITY WITH A TAXONOMY CODE FROM THE START PER DISCUSSION WITH  SIR PHIL RELATED TO: "symphony_20250613_CHGSD_SYM_FlatFile_DRD.xlsx"
	

/* -- C022: START OF EIN SHARING  WORKAROUND IMPLEMENTATION TBD ...
-- C023: ALLOW MISSING TAXONOMY TO PASS PER INTERNAL DISCUSSION AS OF AUG 2025 ... AND

		LEFT JOIN INFORMATICS.dbo.[SANATOR_SYMPHONY_DATA_MODELING_MAP] AS dmmap ON UPPER(LTRIM(RTRIM(ISNULL(tax.TaxonomyCode,'')))) COLLATE DATABASE_DEFAULT = UPPER(LTRIM(RTRIM(ISNULL(dmmap.code,'')))) COLLATE DATABASE_DEFAULT  -- C023: ALLOW MISSING TAXONOMY TO PASS PER INTERNAL DISCUSSION AS OF AUG 2025 ... AND 

SELECT ' ' AS 'STAND ALONE #BASELINE', * 
FROM INFORMATICS.dbo.ENTITY_ID_MAPPING
WHERE 1=1
	AND provid IN ('4119102','4126140')

SELECT * FROM INFORMATICS.dbo.PROVDIR_HOSGENERALACUTE

SELECT *
FROM INFORMATICS.dbo.FAC_SANATOR_PROVDIR_CONTRACTING_ENT 
WHERE 1=1
	AND LocationID IN ('4119104','4119103','4126149','4126141')

SELECT * FROM INFORMATICS.dbo.SYMPHONY_HOSPITAL */







JAH ' The DBA info for all 900 providers will be under:'
		Group practice name is Integrated Health Partners (eVIPs practice ID# =   5321500) 
		Group tax ID is 474334653
		Group NPI is 1982756086

Then all practitioners with matching DBA FEID will be listed as IHP. - see "BECAUSE_symphony_20250721_#12through14.sql"

-- ==================================================================
	-- BASELINE eVIPS PROVIDER CHECK(s) --
-- ==================================================================
SELECT DISTINCT ' ' AS  'BASELINE eVIPS PROVIDER CHECK(s): '
,vploc.LineNumber1 AS 'Address'
,tgi.[TGI_INDICATOR]
,ISNULL(ipaopb.[In-Person Appointments],'Y') AS [In-Person Appointments] -- C003: PER SIR ALEC FINDINGS ... mark all provider entries individually based on their product code. Y for “In-Person Appointments” if the product code is anything other than HBP. N if product code is HBP see "In-Person Apointments Report.docx"
,UPPER(LTRIM(RTRIM(vpp.ProductTypeName))) AS [In-Person Appointments Assessment (HBP=N Otherwise Y)]
,vpp.ProductName
,UPPER(LTRIM(RTRIM(vpp.PracticeID))) AS [DBAPracticeID]
,UPPER(LTRIM(RTRIM(vpp.PracticeName))) AS [DBA]
,calic.*
,TRY_CONVERT(date,vpp.DateFrom) AS [DateFrom]
,TRY_CONVERT(date,vpp.DateTo) AS [DateTo]
,CAST(vpp.DateFrom AS date) AS [ContractEffectiveDate]
,CAST(vpp.DateTo AS date) AS [ContractExpirationDate]
,DERIVEDPROV.QNXTprovid
,DERIVEDPROV.ProviderAlternateID
,vpp.ProductName
,vpd.NationalProviderID
,vpps.SpecialtyCode
,vpps.SpecialtyName
,vpd.LastName
,vpd.FirstName
,vpps.InDirectory
,vpd.Archived
,vpps.Archived
,vploc.Archived
,vpracloc.Archived
,vpd.PractitionerStatus
,vpp.Archived
,vpp.StatusTypeName
,vploc.*
,proveth.*
,PHONEfax.FaxNumber
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM eVips_chgcv.dbo.vwPractitionerDemographics AS vpd
	JOIN eVips_chgcv.dbo.vwPractitionerProducts AS vpp ON vpd.PractitionerID = vpp.PractitionerID -- aka cert_provider
		-- AND vpp.ProductID = vpps.ProductID -- aka cert_provider
	JOIN eVips_chgcv.dbo.vwPractitionerProductSpecialties AS vpps ON vpp.PractitionerProductRecID = vpps.PractitionerProductRecID
		LEFT JOIN eVips_chgcv.dbo.vwPractitionerSpecialties AS vps ON vpd.PractitionerID = vps.PractitionerID	
			AND vpps.specialtycode = vps.specialtycode
		LEFT JOIN 
		( -- INITIATE ...
		SELECT DISTINCT ProviderID,TableName,EntityCode,EntityName,EntityTypeCode,EntityTypeName 
		FROM eVips_chgcv.dbo.vwEntityAssignments 
		WHERE UPPER(LTRIM(RTRIM(ISNULL(TableName,'')))) LIKE '%PRACTI%'
		) -- CONCLUDE ... 
		AS vea ON vpd.PractitionerID = vea.ProviderID --ProviderID = PractitionerID WHERE UPPER(LTRIM(RTRIM(vea.TableName))) LIKE '%Practit%' OR  ProviderID = PracticeID WHERE UPPER(LTRIM(RTRIM(vea.TableName))) LIKE '%Practice%'
	JOIN ( -- INITIATE ...
	SELECT DISTINCT vpprovloc.PractitionerID,vpprovloc.PracticeID,vpprovloc.LocationID,vpprovloc.AddressID,vpprovloc.LastName,vpprovloc.FirstName,vpprovloc.Archived,vpprovloc.LocationName,vpprovloc.NationalProviderID,vpprovloc.LocationNotes,vpprovloc.PracticeTypeName,vpprovloc.ProviderNumber,vpprovloc.website,vpfacloc.LineNumber1,vpfacloc.LineNumber2,vpfacloc.LineNumber3,vpfacloc.City,vpfacloc.[State],vpfacloc.ZipCode,vpfacloc.LocationTypeName 
	FROM eVips_chgcv.dbo.vwPractitionerLocations AS vpprovloc
		JOIN eVips_chgcv.dbo.vwPracticeLocations AS vpfacloc ON vpprovloc.PracticeID = vpfacloc.PracticeID
			AND vpprovloc.LocationID = vpfacloc.LocationID 
		WHERE UPPER(LTRIM(RTRIM(ISNULL(vpfacloc.LocationTypeName,'')))) LIKE '%PRACTI%'
		) -- CONCLUDE ...
		AS vploc ON vpd.PractitionerID = vploc.PractitionerID
		AND vpp.PracticeID = vploc.PracticeID
		AND vpp.LocationID = vploc.LocationID
		-- AND vpp.AddressID = vploc.AddressID
	JOIN eVips_chgcv.dbo.vwPracticeLocations AS vpracloc ON vpp.practiceid = vpracloc.practiceid  --SPECIAL ADD - ON JOIN(s)
		AND vpp.Locationid = vpracloc.Locationid --SPECIAL ADD - ON JOIN(s)
		LEFT JOIN INFORMATICS.dbo.ZIP_CODES AS zip ON CASE
		WHEN SUBSTRING(LTRIM(RTRIM(vploc.ZipCode)),1,1) = '0'
		THEN '0'+ SUBSTRING(LTRIM(RTRIM(vploc.ZipCode)),2,4)
		WHEN SUBSTRING(LTRIM(RTRIM(vploc.ZipCode)),1,1) = '00'
		THEN '00'+ SUBSTRING(LTRIM(RTRIM(vploc.ZipCode)),3,3)
		ELSE  SUBSTRING(LTRIM(RTRIM(vploc.ZipCode)),1,5) 
		END COLLATE DATABASE_DEFAULT = SUBSTRING(LTRIM(RTRIM(zip.ZipCode)),1,5) COLLATE DATABASE_DEFAULT -- FORMERLY SQL01.DEV_DB.dbo.ZIP_CODES

		LEFT JOIN 
		( -- INITIATE ...
		SELECT DISTINCT zipcode,city,county,RegionTypeName 
		FROM eVips_chgcv.dbo.vwzipcodes 
		WHERE UPPER(LTRIM(RTRIM(ISNULL(county,'')))) LIKE '%SAN%DIEGO%'
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
		WHERE r.tablename IN ('Specialties' )
		AND r.fieldName IN ('Specialty Grouping - Timely Access')
		) -- CONCLUDE ...
		AS profile ON CASE
		WHEN vpps.SpecialtyCode IS NULL
		THEN UPPER(LTRIM(RTRIM(vpps.SpecialtyName)))
		ELSE UPPER(LTRIM(RTRIM(vpps.SpecialtyCode)))
		END = UPPER(LTRIM(RTRIM(ISNULL(profile.specialtycode,'')))) -- AS [DefineOTH_SPE]

		LEFT JOIN 
		( -- INITIATE ...
		SELECT DISTINCT ' ' AS 'STATE LIC DATA',* 
		FROM eVips_chgcv.dbo.vwPractitionerLicenses
		WHERE 1=1 
			AND PrimaryLicense = 'Y'
		) -- CONCLUDE ...
		AS calic ON vpd.PractitionerID = calic.PractitionerID

		LEFT JOIN ( -- INITIATE ...
		SELECT DISTINCT IDNumber AS [QNXTprovid],IDNumber,ProviderAlternateID,ProviderID,AlternateIDTypeID FROM eVips_chgcv.dbo.vwPractitionerAlternateIDs WHERE UPPER(LTRIM(RTRIM(ISNULL(AlternateIDTypeName,'')))) LIKE '%QNXT%' AND archived = 'N'
		) -- CONCLUDE ...
		AS DERIVEDPROV ON vpd.PractitionerID = DERIVEDPROV.[ProviderID]-- ,UPPER(LTRIM(RTRIM(vpd.PractitionerID))) AS 'lookup_key' DERIVED() ALIASNAME CONCLUDE ...

		LEFT JOIN 
		( -- INITIATE 
		SELECT ' ' AS 'TGI (TRANS-GENDER) INDICATOR' -- C003: ADD Hi Walter, Please let me know if you have any questions. TGI indicator was added under the Personal tab/Personal ID/TGI/Notes 
		,ISNULL(Notes,'N') AS [TGI_INDICATOR],*
		FROM eVips_chgcv.dbo.vwPractitionerAlternateIDs  
		WHERE 1=1 
			AND UPPER(LTRIM(RTRIM(ISNULL(AlternateIDTypeName,'')))) LIKE '%TGI%' 
			AND archived = 'N'
		) -- CONCLUDE ...
		AS tgi ON vpd.PractitionerID = tgi.ProviderID

		LEFT JOIN 
		( -- INITIATE ...
		SELECT DISTINCT ' 'AS 'FROM PROVDIR CODE: "%HBP%" PROVIDER(S)'
		,LTRIM(RTRIM(vpd.NationalProviderID)) AS NPIis
		,UPPER(LTRIM(RTRIM(vpp.ProductTypeName))) AS [PROVIDER_TYPEdescr]
		,TRY_CONVERT(nvarchar(1),'N') AS 'In-Person Appointments'  -- C003: PER SIR ALEC FINDINGS ... mark all provider entries individually based on their product code. Y for “In-Person Appointments” if the product code is anything other than HBP. N if product code is HBP see "In-Person Apointments Report.docx"
		FROM eVips_chgcv.dbo.vwPractitionerDemographics AS vpd
			JOIN eVips_chgcv.dbo.vwPractitionerProducts AS vpp ON vpd.PractitionerID = vpp.PractitionerID -- aka cert_provider
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
		
WHERE 1=1 

	 AND 
	 ( -- INITIATE ... REGULAR PROVIDER 'IN NETWORK / IN DIRECTORY LOGIC'
	 UPPER(LTRIM(RTRIM(ISNULL(vpps.InDirectory,'')))) LIKE 'Y' --SET @INDIR ='Y' --REMOVE FILTER FOR JOSEPH / TIMELYACCESS HBP(s)... '%' OR 'Y'  OR 'N' --SUBSTRING(UPPER(LTRIM(RTRIM(cert_provider.in_directory))),1,1) LIKE @INDIR --see 'LTRIM(RTRIM(mcred.retrieve_list)) LIKE '%CN%V%'
		 AND UPPER(LTRIM(RTRIM(vpd.Archived))) IN ('N') --WITH eVIPS LOGICAL BINARY OPTION(s) IN USE •	Must not be archived 
		 AND UPPER(LTRIM(RTRIM(vpps.Archived))) IN ('N') -- ADD ON per MEETING ;WITH YOUNG LADY LAURA, SC & HL ON 20171226
		 AND UPPER(LTRIM(RTRIM(vploc.Archived))) IN ('N') --WITH eVIPS LOGICAL BINARY OPTION(s) IN USE •	Must not be archived
		 AND UPPER(LTRIM(RTRIM(vpracloc.Archived))) IN ('N')
		 AND UPPER(LTRIM(RTRIM(ISNULL(vpd.PractitionerStatus,'')))) IN ('ACTIVE','') --•	Overall Status must be Active
		 AND UPPER(LTRIM(RTRIM(vpp.Archived))) IN ('N') --WITH eVIPS LOGICAL BINARY OPTION(s) IN USE •	Must not be archived 
		 ) -- CONCLUDE ... REGULAR PROVIDER 'IN NETWORK / IN DIRECTORY LOGIC'
		 AND ISNULL(vpp.StatusTypeName,'') IN ('Y','','Active','Active - Per Diem') --•	Plan Status must be: ‘Active’ or ‘Active Per Diem’ or Active VIP for a Product Name (CMC or MEDICAL):

	AND vpd.NationalProviderID IN ('1982756086')
	-- AND vpp.PracticeID IN ('5321500')
	






-- ==================================================================
	-- BASELINE eVIPS FACILITY CHECK(s) --
-- ==================================================================
SELECT DISTINCT ' ' AS 'BASELINE eVIPS FAC CHECK(s): '
,vpl.LineNumber1 AS 'Address'
,vlp.ProductName
,UPPER(LTRIM(RTRIM(vp.PracticeID))) AS [DBAPracticeID]
,UPPER(LTRIM(RTRIM(vp.PracticeName))) AS [DBA]
,DERIVEDFAC.QNXTprovid
,DERIVEDFAC.ProviderAlternateID
,vpl.PracticeID
,vpl.LocationID
,vpl.LocationName
,vlp.ProductName
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
,vp.PracticeName
,vpl.LocationName
,vp.LegalName AS [VPLegalName]
,vpl.LegalName AS [VPLLegalName]
,UPPER(LTRIM(RTRIM(vpl.LocationName))) AS [HospitalName]
,UPPER(LTRIM(RTRIM(vpl.LocationName))) AS [FacilityName]
,UPPER(LTRIM(RTRIM(vpl.LocationName))) AS [Clinic Name]
,UPPER(LTRIM(RTRIM(vpl.LocationName))) AS [Pharmacy Name] -- We have most of the NPIs for the clinics.  They are located in the NPI field in the address master
,UPPER(LTRIM(RTRIM(vp.PracticeID))) AS [DBAPracticeID]
,UPPER(LTRIM(RTRIM(vp.PracticeName))) AS [DBA]
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
,vls.Code1
,vls.Code2
,vls.Code1 AS [FacilityType]
,vls.Code2 AS [InstitutionalFacilityType]
,vea.*
,PHONEfax.FaxNumber
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st',
-- SELECT  vlp.Focus,vlsfocus.Code1,vlsfocus.Code2,vp.Archived,vp.PracticeStatus,vp.ApplicationStatus,vpl.Archived,vpl.LocationTypeName,vp.PracticeTypeName,* -- CHECK 1st
-- SELECT * FROM eVips_chgcv.dbo.vwPracticeLocations -- CHECK 1st
-- SELECT DISTINCT PracticeTypeName FROM eVips_chgcv.dbo.vwPracticeLocations -- CHECK 1st UPPER(LTRIM(RTRIM(vpl.PracticeTypeName))) AS [Type of Service]
-- SELECT * FROM eVips_chgcv.dbo.vwEntityAssignments WHERE UPPER(LTRIM(RTRIM(TableName))) LIKE '%Practice%' AND UPPER(LTRIM(RTRIM(EntityName))) LIKE '%MED%IMPA%' -- CHECK 1st
FROM eVips_chgcv.dbo.vwPractices AS vp
	JOIN eVips_chgcv.dbo.vwPracticeLocations AS vpl ON vp.PracticeID = vpl.PracticeID

		LEFT JOIN eVips_chgcv.dbo.vwFacilities AS vf ON vpl.LocationName = vf.FacilityName
			OR vp.PracticeName = vf.FacilityName

		LEFT JOIN 
		( -- INITIATE ...
		SELECT DISTINCT PracticeID,ClassOrCategory, ServiceTypeName,ServiceCategoryTypeName,Code1,Code2,LocationID
		FROM eVips_chgcv.dbo.vwLocationServices 
		WHERE ServiceTypeName 
		LIKE '%GROUP%SPEC%'
		) -- CONCLUDE ...
		AS vls ON vp.PracticeID = vls.PracticeID -- DEFINE FAC CHAPTER(s) 		
		LEFT JOIN 
		( -- INITIATE ...
		SELECT DISTINCT LocationID,PracticeID,ClassOrCategory, ServiceTypeName,ServiceCategoryTypeName,code1,code2 
		FROM eVips_chgcv.dbo.vwLocationServices 
		WHERE UPPER(LTRIM(RTRIM(ServiceTypeName))) LIKE '%PHARM%TYPE%' 
			AND ServiceCategoryTypeName IS NOT NULL 
			AND UPPER(LTRIM(RTRIM(ServiceCategoryTypeName))) != ''
			) -- CONCLUDE ...
			AS vlspharmtype ON vp.PracticeID = vlspharmtype.PracticeID --DEFINE PHARM TYPE(s)
				AND vpl.LocationID = vlspharmtype.LocationID -- per YOUNG LADY LAURA email ON 20171221 ... Products (CMC & MEDICAL)  are stored at Location Level. The code below is joining based only ON Practice ID. This should be based ON PracticeID + Location

		LEFT JOIN 
		( -- INITIATE ...
		SELECT DISTINCT LocationID,PracticeID,ClassOrCategory, ServiceTypeName,ServiceCategoryTypeName,code1,code2 
		FROM eVips_chgcv.dbo.vwLocationServices 
		WHERE UPPER(LTRIM(RTRIM(ServiceTypeName))) LIKE '%PHARM%SERV%' 
			AND ServiceCategoryTypeName IS NOT NULL 
			AND UPPER(LTRIM(RTRIM(ServiceCategoryTypeName))) != ''
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
		WHERE UPPER(LTRIM(RTRIM(ISNULL(TableName,'')))) LIKE '%PRACTI%'
		) -- CONCLUDE ...
		AS vea ON vp.PracticeID = vea.ProviderID

		LEFT JOIN
		 ( -- INITIATE ...
		SELECT DISTINCT ljvlp.ProductTypeCode,ljvlp.ProductTypeName,ljvlp.PracticeTypeName,ljvlp.PracticeID,ljvlp.LocationID,ljvlp.Archived,ljvlp.StatusTypeName,vlpstype.indirectory,vlpstype.ServiceTypeCode,vlpstype.ServiceTypeName,ljvlp.productname,ljvlp.ProductPanelStatusTypeName,ljvlp.ProductPanelStatusTypeCode,ljvlp.ProviderNumber,ljvlp.Focus,ljvlp.ProductID,ljvlp.LocationTypeName 
		FROM eVips_chgcv.dbo.vwLocationProducts AS ljvlp 
			JOIN evips_chgcv.dbo.vwLocationProductServices AS vlpstype ON ljvlp.LocationProductRecID = vlpstype.LocationProductRecID 
		WHERE ISNULL(ljvlp.Archived,'') IN ('N','') 
			AND (ISNULL(ljvlp.StatusTypeName,'') IN ('ACTIVE','') 
				OR ljvlp.StatusTypeName LIKE '%PARTICIP%')
			AND ISNULL(vlpstype.Archived,'') IN ('N','') 
			) -- CONCLUDE ...
			AS vlp ON vpl.PracticeID = vlp.PracticeID --'YOUNG LADY LAURA GAH ID WHERE p.archived = 'N' AND s.ServiceTypeName = 'HOSPITAL' AND p.focus like '%GAH%'' ON 20171120 see ,UPPER(LTRIM(RTRIM(vlp.ServiceTypeName))) AS [vlpSERVICETYPENAME]
				AND vpl.LocationID = vlp.LocationID -- per YOUNG LADY LAURA email ON 20171221 ... Products (CMC & MEDICAL)  are stored at Location Level. The code below is joining based only ON Practice ID. This should be based ON PracticeID + Location

		LEFT JOIN 
		( -- INITIATE ...
		SELECT DISTINCT LocationID,PracticeID,AccreditationTypeCode,AccreditationTypeName,Notes 
		FROM eVips_chgcv.dbo.vwLocationAccreditations AS vla 
		WHERE ISNULL(vla.Archived,'') IN ('N','') 
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
		WHERE UPPER(LTRIM(RTRIM(ISNULL(county,'')))) LIKE '%SAN%DIEGO%'
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
			
WHERE 1=1 
	AND vp.Archived IN ('N') --WITH eVIPS LOGICAL BINARY OPTION(s) IN USE •	Must not be archived 
	AND ISNULL(vp.PracticeStatus,'') IN ('ACTIVE','CONTRACTED','NA','') --•	Contract Status must be Active
	AND vpl.Archived IN ('N') --WITH eVIPS LOGICAL BINARY OPTION(s) IN USE •	Must not be archived
	 
	AND CASE
	WHEN vpl.NationalProviderID IS NULL
		AND UPPER(LTRIM(RTRIM(vf.FacilityStatus))) LIKE 'ACTIVE%'
		AND UPPER(LTRIM(RTRIM(vf.ApplicationStatus))) LIKE 'ACTIVE%'
	THEN LTRIM(RTRIM(vf.NationalProviderID))
	ELSE LTRIM(RTRIM(vpl.NationalProviderID)) 
	END IN ('1982756086') -- AS [NPIis]	
	-- AND LTRIM(RTRIM(vp.NationalProviderID)) IN ('1982756086') -- AS altNPIis 
	-- AND vp.PracticeID IN ('5321500')







JAH 'symphony Dxf LOCK' ON 20250718
x see "BECAUSE_symphony_20250721_#12through14.sql"

		SELECT ' ' AS 'LOCK IN AS OF 20250718',sourcetable.*
		INTO INFORMATICS.dbo.PROV_SANATOR_PROVDIR_CONTRACTING_ENT_20250718
		FROM INFORMATICS.dbo.PROV_SANATOR_PROVDIR_CONTRACTING_ENT AS sourcetable

		SELECT ' ' AS 'LOCK IN AS OF 20250718',sourcetable.*
		INTO INFORMATICS.dbo.FAC_SANATOR_PROVDIR_CONTRACTING_ENT_20250718
		FROM INFORMATICS.dbo.FAC_SANATOR_PROVDIR_CONTRACTING_ENT AS sourcetable

SELECT DISTINCT eim.provid AS 'ENTITY_ID'
,subsetsymphony.* -- ESTABLISH SUBSET DATASET
FROM INFORMATICS.dbo.ENTITY_ID_MAPPING AS eim
	JOIN 
	( -- INITIATE ...
	SELECT DISTINCT 'BUSINESS + LOCATIONS' AS ENTITY_TYPE
	,TRY_CONVERT(nvarchar(50),PracticeID) AS 'PracticeID'
	,DBA AS 'Business Name'
	,TRY_CONVERT(nvarchar(50),locationid) AS 'locationid'
	,[Prov Directory by Contracting Entity] AS 'Location Name'
	,TRY_CONVERT(nvarchar(50),NULL) AS 'practitionerid'
	,TRY_CONVERT(nvarchar(50),NULL) AS 'Provider Name'
	,TRY_CONVERT(nvarchar(50),AddressID) AS 'AddressID'
	,TRY_CONVERT(nvarchar(50),PROVTAXID) AS 'BUSINESS_EIN_TAXID'
	-- SELECT TOP 10 ' ' AS 'CHECK 1st',practiceid,locationid,AddressID,[Prov Directory by Contracting Entity],[Clinic Name],*
	-- SELECT DISTINCT ' ' AS 'CHECK 1st',
	FROM INFORMATICS.dbo.FAC_SANATOR_PROVDIR_CONTRACTING_ENT_20250718 
	WHERE 1=1
		AND DBA IS NOT NULL -- REVISION PER BI MONTHLY MEETING WITH SYMPHONY ON 20240726

	UNION 
	SELECT DISTINCT 'BUSINESS + PROVIDERS' AS ENTITY_TYPE
	,TRY_CONVERT(nvarchar(50),PracticeID) AS 'PracticeID'
	,DBA AS 'Business Name'
	,TRY_CONVERT(nvarchar(50),locationid) AS 'locationid'
	,[Clinic Name] AS 'Location Name'
	,TRY_CONVERT(nvarchar(50),PractitionerId) AS 'PractitionerId'
	,[Prov Directory by Contracting Entity] AS 'Provider Name'
	,TRY_CONVERT(nvarchar(50),AddressID) AS 'AddressID'
	,TRY_CONVERT(nvarchar(50),PROVTAXID) AS 'BUSINESS_EIN_TAXID'
	-- SELECT TOP 10 ' ' AS 'CHECK 1st',practiceid,locationid,practitionerid,AddressID,[Prov Directory by Contracting Entity],[Clinic Name],*
	-- SELECT DISTINCT ' ' AS 'CHECK 1st',
	FROM INFORMATICS.dbo.PROV_SANATOR_PROVDIR_CONTRACTING_ENT_20250718
	WHERE 1=1
		AND LastName IS NOT NULL 
		AND FirstName IS NOT NULL
	) -- CONCLUDE ...
	AS subsetsymphony ON ISNULL(eim.PracticeID,'') = ISNULL(subsetsymphony.PracticeID,'')
		AND ISNULL(eim.Locationid,'') = ISNULL(subsetsymphony.Locationid,'')
		AND ISNULL(eim.PractitionerId,'') = ISNULL(subsetsymphony.PractitionerId,'')
		AND ISNULL(eim.AddressID,'') = ISNULL(subsetsymphony.AddressID,'')

-- ====================================================================
	-- FILECONTROL --
-- ====================================================================
		-- SELECT ' ' AS 'STAND ALONE #BASELINE', * FROM INFORMATICS.dbo.ENTITY_ID_MAPPING
		
		-- SELECT * FROM INFORMATICS.dbo.SYMPHONY_ENTITY
		-- SELECT * FROM INFORMATICS.dbo.SYMPHONY_LOCATION
		-- SELECT * FROM INFORMATICS.dbo.SYMPHONY_ADDRESS
		-- SELECT * FROM INFORMATICS.dbo.SYMPHONY_CONTACT
		-- SELECT * FROM INFORMATICS.dbo.SYMPHONY_ROSTER -- AS OF 20250117
		-- SELECT * FROM INFORMATICS.dbo.SYMPHONY_IDENTIFIER
		-- SELECT * FROM INFORMATICS.dbo.SYMPHONY_LANGUAGE -- AS OF 20250224
		-- SELECT * FROM INFORMATICS.dbo.SYMPHONY_TAXONOMY
		-- SELECT * FROM INFORMATICS.dbo.SYMPHONY_HOSPITAL
		-- SELECT * FROM INFORMATICS.dbo.SYMPHONY_NETWORK
		-- SELECT * FROM INFORMATICS.dbo.SYMPHONY_HOURS
		-- SELECT * FROM INFORMATICS.dbo.SYMPHONY_BED_DETAIL

		-- SELECT DISTINCT FileTableName FROM INFORMATICS.dbo.SYMPHONY_ENTITY WHERE 1=1 AND ENTITY_TYPE = 'BUSINESS'
		-- SELECT DISTINCT FileTableName FROM INFORMATICS.dbo.SYMPHONY_LOCATION
		-- SELECT DISTINCT FileTableName FROM INFORMATICS.dbo.SYMPHONY_ADDRESS
		-- SELECT DISTINCT FileTableName FROM INFORMATICS.dbo.SYMPHONY_CONTACT
		-- SELECT DISTINCT FileTableName FROM INFORMATICS.dbo.SYMPHONY_ROSTER
		-- SELECT DISTINCT FileTableName FROM INFORMATICS.dbo.SYMPHONY_IDENTIFIER
		-- SELECT DISTINCT FileTableName FROM INFORMATICS.dbo.SYMPHONY_LANGUAGE
		-- SELECT DISTINCT FileTableName FROM INFORMATICS.dbo.SYMPHONY_TAXONOMY
		-- SELECT DISTINCT FileTableName FROM INFORMATICS.dbo.SYMPHONY_HOSPITAL
		-- SELECT DISTINCT FileTableName FROM INFORMATICS.dbo.SYMPHONY_NETWORK
		-- SELECT DISTINCT FileTableName FROM INFORMATICS.dbo.SYMPHONY_HOURS
		-- SELECT DISTINCT FileTableName FROM INFORMATICS.dbo.SYMPHONY_BED_DETAIL

--"|provider_entity_id|loc_type|provider_address_id|business_entity_id|failed_count|
--|4377895           |SERVICE |90879              |4126763           |1701        |" ... Entity type PROVIDER location should have at least one matching BUSINESS location for location type SERVICE

SELECT ' ' AS 'STAND ALONE #BASELINE', * 
FROM INFORMATICS.dbo.ENTITY_ID_MAPPING
WHERE 1=1
	AND provid IN ('4377895','4126763')
	AND AddressID IN ('90879')
		
SELECT * 
FROM INFORMATICS.dbo.SYMPHONY_ENTITY
WHERE 1=1
	AND ENTITY_ID IN ('4377895','4126763')

SELECT * 
FROM INFORMATICS.dbo.SYMPHONY_ROSTER
WHERE 1=1
	AND PRIMARY_ID IN ('4377895','4126763')
		OR SECONDARY_ID IN ('4377895','4126763')

SELECT * 
FROM INFORMATICS.dbo.SYMPHONY_LOCATION
WHERE 1=1
	-- AND ENTITY_ID IN ('4377895','4126763')
	AND ADDRESS_ID IN ('90879')

SELECT * 
FROM INFORMATICS.dbo.SYMPHONY_ADDRESS
WHERE 1=1
	AND ADDRESS_ID IN ('90879')






	
-- "|provider_entity_id|loc_type|provider_address_id|business_entity_id|failed_count|
-- |4107493           |SERVICE |3881623            |4107491           |69          |" ...  Entity type FACILITY should have at least one matching BUSINESS location for location type SERVICE

SELECT ' ' AS 'STAND ALONE #BASELINE', * 
FROM INFORMATICS.dbo.ENTITY_ID_MAPPING
WHERE 1=1
	AND provid IN ('4107493','4107491')
	AND AddressID IN ('3881623')
		
SELECT * 
FROM INFORMATICS.dbo.SYMPHONY_ENTITY
WHERE 1=1
	AND ENTITY_ID IN ('4107493','4107491')

SELECT * 
FROM INFORMATICS.dbo.SYMPHONY_ROSTER
WHERE 1=1
	AND PRIMARY_ID IN ('4107493','4107491')
		OR SECONDARY_ID IN ('4107493','4107491')

SELECT * 
FROM INFORMATICS.dbo.SYMPHONY_LOCATION
WHERE 1=1
	AND ENTITY_ID IN ('4107491')
	AND ADDRESS_ID IN ('3881623')

SELECT * 
FROM INFORMATICS.dbo.SYMPHONY_LOCATION
WHERE 1=1
	AND ENTITY_ID IN ('4107493')
	AND ADDRESS_ID IN ('3881623')

SELECT * 
FROM INFORMATICS.dbo.SYMPHONY_LOCATION
WHERE 1=1
	AND ADDRESS_ID IN ('3881623')
	AND ENTITY_ID IN ('4107493','4107491')

SELECT * 
FROM INFORMATICS.dbo.SYMPHONY_LOCATION
WHERE 1=1
	AND ENTITY_ID IN ('4107491')

SELECT * 
FROM INFORMATICS.dbo.SYMPHONY_ADDRESS
WHERE 1=1
	AND ADDRESS_ID IN ('3881623')





--"|ADDRESS_ID|failed_count|
--|3881045   |86          |" ... ADDRESS_ID matches ADDRESS_ID in address file

/* DELETE 
FROM INFORMATICS.dbo.SYMPHONY_LOCATION 
WHERE 1=1
	--AND LOCATION_ID IN('4107267LSERVICE4107266')
	AND LOC_TYPE IN ('SERVICE')  -- 'BUSINESS' P O BOX REMAIN ...
	AND ADDRESS_ID IN (	SELECT DISTINCT ADDRESS_ID
	FROM INFORMATICS.dbo.SYMPHONY_ADDRESS
	WHERE 1=1
		AND LINE_1 LIKE '%P%O%BOX%') -- C021: symphony REMEDIATION: Remove rows in Location file with LOC_TYPE = SERVICE for corresponding ADDRESS_IDs

DELETE 
FROM INFORMATICS.dbo.SYMPHONY_ADDRESS 
WHERE 1=1
	-- AND ADDRESS_ID IN('3881045')
	AND LINE_1 LIKE '%P%O%BOX%' -- C021: symphony REMEDIATION: Remove rows in Location file with LOC_TYPE = SERVICE for corresponding ADDRESS_IDs  */ -- C###: PO BOX LET BACK IN, BECAUSE symphony ... AS OF 20250723

SELECT ' ' AS 'STAND ALONE #BASELINE', * 
FROM INFORMATICS.dbo.ENTITY_ID_MAPPING
WHERE 1=1
	AND AddressID IN ('3881045')
		
SELECT * 
FROM INFORMATICS.dbo.SYMPHONY_ENTITY
WHERE 1=1
	AND ENTITY_ID IN ('4107266','4107266')

SELECT * 
FROM INFORMATICS.dbo.SYMPHONY_LOCATION
WHERE 1=1
	AND ADDRESS_ID IN ('3881045')
		OR ENTITY_ID IN ('4107266','4107266')

SELECT * 
FROM INFORMATICS.dbo.SYMPHONY_ADDRESS
WHERE 1=1
	AND ADDRESS_ID IN ('3881045')

	SELECT DISTINCT addressid AS 'ADDRESS_ID',  -- ENSURE UPDATE of ALL dependent tables that reference ADDRESS_ID
	address1 AS LINE_1,
	TRY_CONVERT(NVARCHAR(75),NULL) AS LINE_2, -- OPTIONAL: DO NOT INCLUDE AS SYMPHONY HAS DIFFERENT DEFINITION OF OPTIONAL AND ITS CRITICALITY
	CityIs AS CITY,
	StateIs AS STATE_CD,
	[Zip Code] AS ZIPCODE
	FROM INFORMATICS.dbo.FAC_SANATOR_PROVDIR_CONTRACTING_ENT_20250718
	WHERE 1=1
		AND AddressID IN ('3881045')

	UNION
	SELECT DISTINCT addressid AS 'ADDRESS_ID',  -- ENSURE UPDATE of ALL dependent tables that reference ADDRESS_ID
	address1 AS LINE_1,
	TRY_CONVERT(NVARCHAR(75),NULL) AS LINE_2, -- OPTIONAL: DO NOT INCLUDE AS SYMPHONY HAS DIFFERENT DEFINITION OF OPTIONAL AND ITS CRITICALITY
	CityIs AS CITY,
	StateIs AS STATE_CD,
	[Zip Code] AS ZIPCODE
	FROM INFORMATICS.dbo.PROV_SANATOR_PROVDIR_CONTRACTING_ENT_20250718
	WHERE 1=1
		AND AddressID IN ('3881045')







-- =====================================================================
	-- TAXID EIN: 
-- =====================================================================
		SELECT ' ' AS 'EIN TaxID - PracticeID: '
		,TaxIDNumber -- FROM dbo.Practices.TaxIDNumber
		,PracticeID
		,LocationID
		,TRY_CONVERT(nvarchar(25),'') AS 'PractitionerID',*
		FROM evips_chgcv.dbo.vwPractices 
		WHERE 1=1 
			AND TaxIDNumber IN ('474334653') -- SAMPLE: IHP

		/* SELECT ' ' AS 'EIN TaxID - PracticeID,',TaxIDNumber,* 
		FROM evips_chgcv.dbo.Practices
		WHERE 1=1 
			AND TaxIDNumber IN ('474334653') -- SAMPLE: IHP */

		SELECT ' ' AS 'EIN TaxID - LocationID: '
		,TaxIDNumber  -- FROM dbo.Facilities
		,TRY_CONVERT(nvarchar(25),'') AS 'PracticeID'
		,TRY_CONVERT(nvarchar(25),'') AS 'LocationID'
		,TRY_CONVERT(nvarchar(25),'') AS 'PractitionerID',*
		FROM evips_chgcv.dbo.vwFacilities
		WHERE 1=1 
			AND TaxIDNumber IN ('474334653') -- SAMPLE: IHP

		/* SELECT ' ' AS 'EIN TaxID - LocationID,',TaxIDNumber,* 
		FROM evips_chgcv.dbo.Facilities
		WHERE 1=1 
			AND TaxIDNumber IN ('474334653') -- SAMPLE: IHP */

		SELECT ' ' AS 'EIN TaxID - PractitionerID: '
		,TaxIDNumber,* -- FROM dbo.Practices.TaxIDNumber
		,PracticeID
		,LocationID
		,PractitionerID
		FROM eVips_chgcv.dbo.vwPractitionerProducts
		WHERE 1=1 
			AND TaxIDNumber IN ('474334653') -- SAMPLE: IHP
				OR LocationID In ('6280070','5838634','5708743') -- IHP LOCATION(S)
				OR LocationID In ('6253045','5509968','4916004') -- IHP LOCATION(S)			

		SELECT DISTINCT ' ' AS 'symphony XWALK CROSSWALK'
		,[Prov Directory by Contracting Entity]
		,PROVTAXID
		,PracticeID
		,LocationID
		,TRY_CONVERT(nvarchar(25),NULL) AS 'PractitionerID',*
		FROM INFORMATICS.dbo.FAC_SANATOR_PROVDIR_CONTRACTING_ENT_20250718 AS sourcetable
		WHERE 1=1
			AND [Prov Directory by Contracting Entity] LIKE 'RADY%'
				OR PROVTAXID IN ('474334653')

		SELECT DISTINCT ' ' AS 'symphony XWALK CROSSWALK'
		,[Prov Directory by Contracting Entity]
		,PROVTAXID
		,PracticeID
		,LocationID
		,PractitionerID,*
		FROM INFORMATICS.dbo.PROV_SANATOR_PROVDIR_CONTRACTING_ENT_20250718 AS sourcetable
		WHERE 1=1
			AND [Prov Directory by Contracting Entity] LIKE 'RADY%'
				OR PROVTAXID IN ('474334653')

--|business_id_1|ein_1    |business_id_2|ein_2    |common_secondary_id|npi_1     |npi_2     |address_line_1_1       |address_line_1_2       |network_code_1                |network_code_2                |failed_count|
--|4117676      |474334653|4123259      |474334653|6155784            |1356927313|1356927313|855 E MADISON AVE      |855 E MADISON AVE      |CHGSD_HMO_Community y M?s (HMO|CHGSD_HMO_Community y M?s (HMO|336         | ... Duplicate EINs have common Roster with same address and same network codes

SELECT ' ' AS 'STAND ALONE #BASELINE - LOCATION'
,EIN_TAXID,* 
FROM INFORMATICS.dbo.ENTITY_ID_MAPPING
WHERE 1=1
	AND provid IN ('4117676','4123259','6155784') -- BECAUSE symphony START WITH DROPIING EIN FROM ENTITY
	-- AND provid = practiceid
	--AND provid = locationid
	-- AND EIN_TAXID IN ('474334653')

SELECT * 
FROM INFORMATICS.dbo.SYMPHONY_ROSTER -- AS OF 20250117
WHERE 1=1
	AND SECONDARY_ID IN ('6155784')

SELECT * 
FROM INFORMATICS.dbo.SYMPHONY_NETWORK
WHERE 1=1
	AND LOCATION_ID LIKE '4885831%'
		OR LOCATION_ID LIKE '4123324%'
		OR LOCATION_ID LIKE '4123272%'







--|EIN      |count(1)|total_records|failed_count|
--|952833205|2       |1002         |26          |

		--SELECT * FROM evips_chgcv.dbo.MemberTypes
		--SELECT * FROM evips_chgcv.dbo.AddressTypes
	  
--Line  1371: ,REPLACE(UPPER(LTRIM(RTRIM(vf.TaxIDNumber))),'-','') AS vfPROVTAXID
--Line  1520: ,REPLACE(UPPER(LTRIM(RTRIM(vp.TaxIDNumber))),'-','') AS PROVTAXID
--Line  2166: ,REPLACE(UPPER(LTRIM(RTRIM(vpp.TaxIDNumber))),'-','') AS [PROVTAXID]
	
SELECT ' ' AS 'STAND ALONE #BASELINE - LOCATION'
,EIN_TAXID,* 
FROM INFORMATICS.dbo.ENTITY_ID_MAPPING
WHERE 1=1
	--AND provid IN ('4117676','4123259')
	-- AND provid = practiceid
	--AND provid = locationid
	AND EIN_TAXID IN ('952833205') -- '474334653')
	-- AND practiceid IN ('4134229') -- TEST ALL RECORDS WHICH WILL DROP
	AND practiceid IN -- DROP THESE RECORDS  & ALL RESULTING practiceid COMBO(S) ... BECAUSE syphony ...
	( -- INITIATE ...
	SELECT DISTINCT provid
	FROM 
	( -- INITIATE ...
	SELECT DISTINCT provid
	,EIN_TAXID
	FROM INFORMATICS.dbo.ENTITY_ID_MAPPING
	WHERE 1=1
		AND ISNULL(EIN_TAXID,'') != '' --  ~ eVIPS 'practiceid' / [DBA] = 274 Groups AS  'BUSINESS' ... symphony ONLY
		) -- CONCLUDE ...
		AS eim
	WHERE 1=1 
		AND TRY_CONVERT(nvarchar(25),EIN_TAXID) IN
		( -- INITIATE ...
		SELECT TRY_CONVERT(nvarchar(25),EIN_TAXID)
		FROM 
		( -- INITIATE ...
		SELECT DISTINCT provid
		,EIN_TAXID
		FROM INFORMATICS.dbo.ENTITY_ID_MAPPING
		WHERE 1=1
			AND ISNULL(EIN_TAXID,'') != '' --  ~ eVIPS 'practiceid' / [DBA] = 274 Groups AS  'BUSINESS' ... symphony ONLY
			) -- CONCLUDE ...
			AS dup
		GROUP BY TRY_CONVERT(nvarchar(25),EIN_TAXID) -- Duplication Driver 
		HAVING COUNT(1)>1 -- HAVING clause RESERVED for AGGREGATE(s) ... HAVING SUM(PAID_NET_AMT) != 0
		) -- CONCLUDE ...
		) -- CONCLUDE ...

	-- CHECK FOR DUP(S) --
SELECT ' ' AS 'DROP THESE RECORDS  & ALL RESULTING practiceid COMBO(S)',*
FROM 
( -- INITIATE ...
SELECT DISTINCT provid
,EIN_TAXID
FROM INFORMATICS.dbo.ENTITY_ID_MAPPING
WHERE 1=1
	AND ISNULL(EIN_TAXID,'') != '' --  ~ eVIPS 'practiceid' / [DBA] = 274 Groups AS  'BUSINESS' ... symphony ONLY
	) -- CONCLUDE ...
	AS eim
WHERE 1=1 
	AND TRY_CONVERT(nvarchar(25),EIN_TAXID) IN
	( -- INITIATE ...
	SELECT TRY_CONVERT(nvarchar(25),EIN_TAXID)
	FROM 
	( -- INITIATE ...
	SELECT DISTINCT provid
	,EIN_TAXID
	FROM INFORMATICS.dbo.ENTITY_ID_MAPPING
	WHERE 1=1
		AND ISNULL(EIN_TAXID,'') != '' --  ~ eVIPS 'practiceid' / [DBA] = 274 Groups AS  'BUSINESS' ... symphony ONLY
		) -- CONCLUDE ...
		AS dup
	GROUP BY TRY_CONVERT(nvarchar(25),EIN_TAXID) -- Duplication Driver 
	HAVING COUNT(1)>1 -- HAVING clause RESERVED for AGGREGATE(s) ... HAVING SUM(PAID_NET_AMT) != 0
	); -- CONCLUDE ...

UPDATE INFORMATICS.dbo.ENTITY_ID_MAPPING
SET EIN_TAXID = 'DELETE' -- C###: AT THE START DROP EIN SHARING EIN TAXID BECAUSE symphony...
FROM INFORMATICS.dbo.ENTITY_ID_MAPPING AS eim
WHERE 1=1
	AND practiceid IN -- DROP THESE RECORDS  & ALL RESULTING practiceid COMBO(S) ... BECAUSE syphony ...
	( -- INITIATE ...
	SELECT DISTINCT provid
	FROM 
	( -- INITIATE ...
	SELECT DISTINCT provid
	,EIN_TAXID
	FROM INFORMATICS.dbo.ENTITY_ID_MAPPING
	WHERE 1=1
		AND ISNULL(EIN_TAXID,'') != '' --  ~ eVIPS 'practiceid' / [DBA] = 274 Groups AS  'BUSINESS' ... symphony ONLY
		) -- CONCLUDE ...
		AS eim
	WHERE 1=1 
		AND TRY_CONVERT(nvarchar(25),EIN_TAXID) IN
		( -- INITIATE ...
		SELECT TRY_CONVERT(nvarchar(25),EIN_TAXID)
		FROM 
		( -- INITIATE ...
		SELECT DISTINCT provid
		,EIN_TAXID
		FROM INFORMATICS.dbo.ENTITY_ID_MAPPING
		WHERE 1=1
			AND ISNULL(EIN_TAXID,'') != '' --  ~ eVIPS 'practiceid' / [DBA] = 274 Groups AS  'BUSINESS' ... symphony ONLY
			) -- CONCLUDE ...
			AS dup
		GROUP BY TRY_CONVERT(nvarchar(25),EIN_TAXID) -- Duplication Driver 
		HAVING COUNT(1)>1 -- HAVING clause RESERVED for AGGREGATE(s) ... HAVING SUM(PAID_NET_AMT) != 0
		) -- CONCLUDE ...
		) -- CONCLUDE ...
		
DELETE INFORMATICS.dbo.ENTITY_ID_MAPPING
FROM INFORMATICS.dbo.ENTITY_ID_MAPPING
WHERE 1=1
	AND EIN_TAXID IN ('DELETE') -- DROP THESE RECORDS  & ALL RESULTING practiceid COMBO(S) ... BECAUSE syphony ... -- C###: AT THE START DROP EIN SHARING EIN TAXID BECAUSE symphony...
	
SELECT *
FROM INFORMATICS.dbo.SYMPHONY_ENTITY
WHERE 1=1
	-- AND provid IN ('4117676','4123259') 
	AND EIN IN ('952833205') -- '474334653') -- SAMPLE: IHP

	-- CHECK FOR DUP(S) --
SELECT ' ' AS 'SHOULD BE NULL DUP Validation',*
-- DELETE
FROM INFORMATICS.dbo.SYMPHONY_ENTITY
WHERE 1=1 
	-- AND ISNULL(EIN,'') != ''
	AND EIN IN
	( -- INITIATE ...
	SELECT EIN
	FROM INFORMATICS.dbo.SYMPHONY_ENTITY AS dup
	GROUP BY EIN -- Duplication Driver 
	HAVING COUNT(1)>1 -- HAVING clause RESERVED for AGGREGATE(s) ... HAVING SUM(PAID_NET_AMT) != 0
	) -- CONCLUDE ...
ORDER BY EIN









--"|location_id           |network_code                  |entity_id|duplicate_count|failed_count|
--|4109536LSERVICE5595409|CHGSD_HMO_Communicare_Advantag|5595409  |2              |2798        |"

--"|NETWORK_NAME    |PLAN_TYPE|lob  |location_id           |count_duplicates|failed_count|
--|Dual Beneficiary|HMO      |MCARE|6248864LSERVICE4386134|2               |2798        |"

SELECT ' ' AS 'ALONE OR IN COMBINATION WITH SUBSTRING(): '
,PATINDEX('%en_ure%','please ensure the door is locked') AS 'PATINDEX START POSITION' -- PATINDEX('%[FIND () WHAT]%',[SOURCE],[START POSITION])  -- [START POSITION] default(s) TO 1 If either pattern or expression is NULL, PATINDEX returns NULL ... LIKE ALT.
,CHARINDEX('en','please ensure the door is locked') AS  'CHARINDEX START POSITION' -- CHARINDEX([FIND() WHAT],[SOURCE],[START POSITION]) ... [START POSITION] default(s) TO 1		

SELECT * 
FROM INFORMATICS.dbo.SYMPHONY_NETWORK
WHERE 1=1
	AND LOCATION_ID IN ('4109536LSERVICE5595409','6248864LSERVICE4386134')

SELECT DISTINCT ISNULL(SUBSTRING(sn.LOCATION_ID,1,PATINDEX('%L%', sn.LOCATION_ID)-1),'') AS 'deliver_locationid'
,PATINDEX('%L%', sn.LOCATION_ID)-1
,NETWORK_CODE,*
FROM INFORMATICS.dbo.SYMPHONY_NETWORK AS sn
WHERE 1=1
	AND sn.LOCATION_ID IN ('4109536LSERVICE5595409') -- ,'6248864LSERVICE4386134')

/* UPDATE INFORMATICS.dbo.SYMPHONY_NETWORK -- C###: ADDRESS smphony INABILITY TO ALLOW FOR COMPLEXITY / REALITY OF HOW MCP DO BUSINESS
SET CONTRACTED_PARTY = TRY_CONVERT(VARCHAR(75),pnnon.DBA) --  TRY_CONVERT(varchar(75),NULL) AS 'CONTRACTED_PARTY', -- UPDATE IN THE POST BECAUSE symphony ... */
SELECT pnnon.*
FROM INFORMATICS.dbo.SYMPHONY_NETWORK AS sn
	JOIN 
	( -- INITIATE ...
	SELECT DISTINCT PracticeID
	,LocationID
	,PractitionerID
	,[Participating Network]
	,[Name of Network]
	,DBA
	FROM INFORMATICS.dbo.PROV_SANATOR_PROVDIR_CONTRACTING_ENT_20250718
	WHERE 1=1
		AND [Name of Network] IN ('MEDI_CAL','Communicare_Advantage','Community y Más (HMO C-SNP)','Covered CA')

	UNION
	SELECT DISTINCT PracticeID
	,LocationID
	,TRY_CONVERT(nvarchar(25),NULL) AS 'PractitionerID'
	,[Participating Network]
	,[Name of Network]
	,DBA
	FROM INFORMATICS.dbo.FAC_SANATOR_PROVDIR_CONTRACTING_ENT_20250718
	WHERE 1=1
		AND [Name of Network] IN ('MEDI_CAL','Communicare_Advantage','Community y Más (HMO C-SNP)','Covered CA')
		) -- CONCLUDE ...
		AS pnnon ON ISNULL(SUBSTRING(sn.LOCATION_ID,1,PATINDEX('%L%', sn.LOCATION_ID)-1),'') = ISNULL(pnnon.LocationID,'') -- eVIPS locationid = 274 SITES AS 'FACILITY' 
WHERE 1=1
	AND sn.LOCATION_ID IN ('4109536LSERVICE5595409') -- ,'6248864LSERVICE4386134')






	
-- =====================================================
	-- MULTI - [db] DATABASE OBJECT SEARCH TEMPLATE: 
-- =====================================================
DECLARE @SearchText NVARCHAR(MAX) = 'TaxID'; -- Text to search for DEANumber, CONTRACTING_, primarystatus, uvw_JusticeInvolvedIndicator, Marketer, Grievance, paid, LTCFacilityType, % Vari, ReportingCounts
DECLARE @ExactMatchST BIT = 0; -- SET AS 1 WHEN NULL OR FOR an exact match ON @PARAM
DECLARE @ObjectName NVARCHAR(MAX) = NULL; -- Keep broad for object names
DECLARE @ExactMatchON BIT = 1; -- SET AS 1 WHEN NULL OR FOR an exact match ON @PARAM
DECLARE @SchemaName NVARCHAR(128) = NULL; -- Target schema (optional) magellan, dbo, ECM, EcmJson ... IGNORE CASE SENSITIVITY
DECLARE @ObjectType NVARCHAR(128) = NULL; -- All object types (optional) 
DECLARE @IncludeSystemObjects BIT = 0;   -- INCLUSION OR EXCLUSION OF system objects

		SELECT ISNULL(@SearchText,'N/A') AS 'Search Text'
		,ISNULL(@ObjectName,'N/A') AS 'Object Name'
		,ISNULL(@SchemaName,'N/A') AS 'Schema Name';

-- Define [db] to search
DECLARE @DatabaseList TABLE (DatabaseName NVARCHAR(128))
INSERT INTO @DatabaseList (DatabaseName)
VALUES 
	--('INFORMATICS'), -- WORKING [db]
	--('HMOPROD_PQCSIDB'), -- QNXT 'User'
	--('HMOPROD_PLANDATA'), -- QNXT [db]
	--('EnrollmentManager'), -- 834 MEMBERSHIP
	--('FINCHG'), -- FINANCE DEPT.	
	--('CareHub'), -- MIGRATION FROM [MemberPortal]
	--('MemberPortal'),
	--('ProviderPortal'),
	--('CHGAPP_PROD'),	
	('evips_chgcv'), -- SERVER: SQLPRODAPP01 PROVIDER NETWORK SOURCE DATA
	('ProviderRepository'), -- SERVER: SQLPRODAPP01 REPO
	--('INFOAG'), -- SERVER: SQLPRODAPP01 LINKED SERVER TO SQLPROD02.INFORMATICS [db]
	--('QPROD'),
	--('DATAWAREHOUSE'), -- LEGACY DW
	--('INFORMATICS2'), -- SQLPROD01.QPROD
	--('DIAMOND_Data'),  -- LEGACY SYSTEM (D950) ... 
	('master'); -- SQLPROD01.QPROD

		SELECT ' ' AS '[db](s) to Query:', * 
		FROM @DatabaseList;

-- Create results table
DROP TABLE IF EXISTS #SearchResults;
CREATE TABLE #SearchResults (
    DatabaseName NVARCHAR(128),
    ResultType NVARCHAR(50),
    SchemaName NVARCHAR(128),
    ObjectName NVARCHAR(256),
    ObjectType NVARCHAR(128),
    ColumnName NVARCHAR(128) NULL,
    DataTypeInfo NVARCHAR(256) NULL,
    AdditionalInfo NVARCHAR(MAX) NULL,
    ModifiedDate DATETIME NULL
);

-- Prepare search patterns
DECLARE @SearchPattern NVARCHAR(MAX) = CASE 
    WHEN @SearchText IS NULL THEN '%'
    WHEN @ExactMatchST = 1 THEN @SearchText
    ELSE '%' + @SearchText + '%'
END;

DECLARE @ObjectPattern NVARCHAR(MAX) = CASE 
    WHEN @ObjectName IS NULL THEN '%'
    WHEN @ExactMatchON = 1 THEN @ObjectName
    ELSE '%' + @ObjectName + '%'
END;

PRINT 'Search Pattern: ' + @SearchPattern;
PRINT 'Object Pattern: ' + @ObjectPattern;

-- Process each [db]
DECLARE @CurrentDB NVARCHAR(128);
DECLARE @SQL NVARCHAR(MAX);

DECLARE db_cursor CURSOR FOR 
SELECT DatabaseName FROM @DatabaseList;

OPEN db_cursor;
FETCH NEXT FROM db_cursor INTO @CurrentDB;

WHILE @@FETCH_STATUS = 0  
BEGIN
    PRINT 'Processing database: ' + @CurrentDB;
    
    BEGIN TRY
        -- **KEY FIX: Properly qualify all object references**
        SET @SQL = N'
        -- 1. Search Object Definitions
        INSERT INTO #SearchResults (DatabaseName, ResultType, SchemaName, ObjectName, ObjectType, AdditionalInfo, ModifiedDate)
        SELECT DISTINCT ''' + @CurrentDB + N''',
            ''Object Definition'', 
            SCHEMA_NAME(o.schema_id), 
            o.name, 
            o.type_desc,
            LEFT(ISNULL(m.definition, ''No definition''), 100) + ''...'',
            o.modify_date
        FROM ' + QUOTENAME(@CurrentDB) + N'.sys.objects AS o
            LEFT JOIN ' + QUOTENAME(@CurrentDB) + N'.sys.sql_modules AS m ON o.object_id = m.object_id
        WHERE 1=1
            AND (' + CASE WHEN @SchemaName IS NULL THEN N'1=1' ELSE N'SCHEMA_NAME(o.schema_id) = ''' + @SchemaName + N'''' END + N')
            AND (' + CASE WHEN @ObjectType IS NULL THEN N'1=1' ELSE N'o.type_desc LIKE ''' + @ObjectType + N'''' END + N')
            AND (' + CASE WHEN @IncludeSystemObjects = 1 THEN N'1=1' ELSE N'o.is_ms_shipped = 0' END + N')
            AND (
                o.name LIKE ''' + @SearchPattern + N''' OR 
                o.name LIKE ''' + @ObjectPattern + N''' OR
                m.definition LIKE ''' + @SearchPattern + N'''
            )
            AND o.name NOT LIKE ''sp_MS%'';
            
        -- 2. Search Tables via INFORMATION_SCHEMA
        INSERT INTO #SearchResults (DatabaseName, ResultType, SchemaName, ObjectName, ObjectType)
        SELECT DISTINCT ''' + @CurrentDB + N''',
            ''Table'',
            t.TABLE_SCHEMA,
            t.TABLE_NAME,
            t.TABLE_TYPE
        FROM ' + QUOTENAME(@CurrentDB) + N'.INFORMATION_SCHEMA.TABLES AS t
        WHERE 1=1
            AND (' + CASE WHEN @SchemaName IS NULL THEN N'1=1' ELSE N't.TABLE_SCHEMA = ''' + @SchemaName + N'''' END + N')
            AND (
                t.TABLE_NAME LIKE ''' + @SearchPattern + N''' OR
                t.TABLE_NAME LIKE ''' + @ObjectPattern + N'''
            );
            
        -- 3. Search Columns via INFORMATION_SCHEMA  
        INSERT INTO #SearchResults (DatabaseName, ResultType, SchemaName, ObjectName, ObjectType, ColumnName, DataTypeInfo, AdditionalInfo)
        SELECT DISTINCT ''' + @CurrentDB + N''',
            ''Column'',
            c.TABLE_SCHEMA,
            c.TABLE_NAME,
            t.TABLE_TYPE,
            c.COLUMN_NAME,
            c.DATA_TYPE + 
                CASE 
                    WHEN c.CHARACTER_MAXIMUM_LENGTH IS NOT NULL 
                    THEN ''('' + CAST(c.CHARACTER_MAXIMUM_LENGTH AS VARCHAR(10)) + '')''
                    ELSE ''''
                END,
            ''Nullable: '' + c.IS_NULLABLE
        FROM ' + QUOTENAME(@CurrentDB) + N'.INFORMATION_SCHEMA.COLUMNS AS c
            JOIN ' + QUOTENAME(@CurrentDB) + N'.INFORMATION_SCHEMA.TABLES AS t 
                ON c.TABLE_NAME = t.TABLE_NAME AND c.TABLE_SCHEMA = t.TABLE_SCHEMA
        WHERE 1=1
            AND (' + CASE WHEN @SchemaName IS NULL THEN N'1=1' ELSE N'c.TABLE_SCHEMA = ''' + @SchemaName + N'''' END + N')
            AND (
                c.COLUMN_NAME LIKE ''' + @SearchPattern + N''' OR 
                c.TABLE_NAME LIKE ''' + @SearchPattern + N''' OR
                c.TABLE_NAME LIKE ''' + @ObjectPattern + N'''
            );
            
        -- 4. Search Indexes
        INSERT INTO #SearchResults (DatabaseName, ResultType, SchemaName, ObjectName, ColumnName, DataTypeInfo, AdditionalInfo)
        SELECT DISTINCT ''' + @CurrentDB + N''',
            ''Index'',
            SCHEMA_NAME(t.schema_id),
            t.name,
            i.name,
            i.type_desc,
            ''Is Unique: '' + CASE WHEN i.is_unique = 1 THEN ''Yes'' ELSE ''No'' END
        FROM ' + QUOTENAME(@CurrentDB) + N'.sys.indexes AS i
            INNER JOIN ' + QUOTENAME(@CurrentDB) + N'.sys.tables AS t ON i.object_id = t.object_id
        WHERE 1=1
            AND (' + CASE WHEN @SchemaName IS NULL THEN N'1=1' ELSE N'SCHEMA_NAME(t.schema_id) = ''' + @SchemaName + N'''' END + N')
            AND (
                i.name LIKE ''' + @SearchPattern + N''' OR 
                t.name LIKE ''' + @SearchPattern + N''' OR
                t.name LIKE ''' + @ObjectPattern + N'''
            )
            AND i.name IS NOT NULL;';
            
        PRINT 'Executing search for: ' + @CurrentDB;
        EXEC sp_executesql @SQL;
        PRINT 'Successfully processed: ' + @CurrentDB;
            
    END TRY
    BEGIN CATCH
        PRINT 'Error processing database ' + @CurrentDB + ': ' + ERROR_MESSAGE();
        
        INSERT INTO #SearchResults (DatabaseName, ResultType, AdditionalInfo)
        VALUES (@CurrentDB, 'ERROR', 'Failed to process: ' + ERROR_MESSAGE());
    END CATCH
    
    FETCH NEXT FROM db_cursor INTO @CurrentDB;
END

CLOSE db_cursor;
DEALLOCATE db_cursor;

-- =====================================================
	-- DISPLAY RESULTS
-- =====================================================
SELECT ' ' AS 'Summary counts by database and result type',
DatabaseName,
ResultType, 
COUNT(*) AS TotalFound
FROM #SearchResults
GROUP BY DatabaseName, ResultType
ORDER BY DatabaseName, ResultType;

SELECT ' ' AS 'Summary counts by database and object type',
DatabaseName,
ObjectType, 
COUNT(*) AS TotalFound
FROM #SearchResults
GROUP BY DatabaseName, ObjectType
ORDER BY DatabaseName, ObjectType;

SELECT ' ' AS 'All detailed results (excluding errors)',*
FROM #SearchResults
WHERE 1=1
	AND ResultType != 'ERROR'  -- NO NOT NEGATIVE <> != ...
	-- AND ObjectType IN ('SQL_STORED_PROCEDURE')
	-- AND ObjectName LIKE ISNULL('%'+@ObjectName+'%','%') 
	AND ColumnName LIKE ISNULL('%'+@SearchText+'%','%')  
ORDER BY DatabaseName, ResultType, SchemaName, ObjectName;

/* IF EXISTS (SELECT 1 FROM #SearchResults WHERE ResultType = 'ERROR')
BEGIN
SELECT ' ' AS 'Errors encountered',
DatabaseName,
AdditionalInfo
FROM #SearchResults
WHERE 1=1
	AND ResultType = 'ERROR'
ORDER BY DatabaseName;
END

SELECT ' ' AS 'EcmJson Schema Specific Results',*
FROM #SearchResults
WHERE 1=1
	AND SchemaName = 'EcmJson' AND ResultType != 'ERROR'  -- NO NOT NEGATIVE <> != ...
ORDER BY ResultType, ObjectName, ColumnName; */

-- DROP TABLE IF EXISTS #SearchResults; -- POWER CYCLE RESET REFRESH RESTART ...

		SELECT ' ' AS 'EIN TaxID - PracticeID,',TaxIDNumber,* 
		FROM evips_chgcv.dbo.vwPractices 
		WHERE 1=1 
			AND TaxIDNumber IN ('474334653') -- SAMPLE: IHP

		SELECT ' ' AS 'EIN TaxID - PracticeID,',TaxIDNumber,* 
		FROM evips_chgcv.dbo.Practices
		WHERE 1=1 
			AND TaxIDNumber IN ('474334653') -- SAMPLE: IHP

		SELECT ' ' AS 'EIN TaxID - LocationID,',TaxIDNumber,* 
		FROM evips_chgcv.dbo.vwFacilities
		WHERE 1=1 
			AND TaxIDNumber IN ('474334653') -- SAMPLE: IHP

		SELECT ' ' AS 'EIN TaxID - LocationID,',TaxIDNumber,* 
		FROM evips_chgcv.dbo.Facilities
		WHERE 1=1 
			AND TaxIDNumber IN ('474334653') -- SAMPLE: IHP

		SELECT ' ' AS 'EIN TaxID - PractitionerID,',TaxIDNumber,* 
		FROM eVips_chgcv.dbo.vwPractitionerProducts
		WHERE 1=1 
			AND TaxIDNumber IN ('474334653') -- SAMPLE: IHP
		


		
		
		

JAH CHARINDEX() FIND() SEARCH() "*File Analysis*", "*File Feedback*", symphony
		USE http://devops01:8080/IS/_git/Informatics?path=%2FSir%20Sergio%20SSRS%20Development&version=GBMain - 'Sir Sergio SSRS Jobs'
		USE http://devops01:8080/IS/_git/Informatics?path=%2FEmergency%20Response%20%28snowflake%29&version=GBMain - 'Emergency Response (Snowflake)'

				SYMPHONY FW  INFORM  CHG File Analysis
				SYMPHONY INFORM  CHG File Feedback

		USE https://app.smartsheet.com/b/publish?EQBCT=e758c97ddc364d0c86aca42235f86052 - 'FEEDBACK LINK'

		USE [PATH:] file://netapp02/IS/Informatics/symphony/ - "*File Analysis*", "*File Feedback*"


CREATE OR ALTER PROCEDURE dbo.[SANATOR_ALL] --<Procedure_Name, sysname, ProcedureName> ... DROP ... EXEC dbo.[SANATOR_ALL]PUT ON HOLD

		⏎ SQLPRODAPP01.INFORMATICS.dbo.[SANATOR_ALL] PUT ON HOLD AS OF 20250718 
		
Thank you Carris and Symphony team,

We appreciate you meeting with us today and hearing our concerns as well as explaining the background on the current state of the project. I believe we’re all agreed on the need to demonstrate the value of Symphony to our stakeholders as quickly as possible. From an outsider’s perspective, there’s no denying the project appears to be floundering and learning that we’re at roughly triple the typical implementation time only supports that label.

I’ll reiterate my recommendation to shift from the current “all or nothing approach” to an incremental approach. By starting with a small percentage of CHG’s overall network, we could rapidly produce an output file the CHG credentialing department could begin using right away, helping improve our provider directory and ultimately, the member experience.

As requested, the attached file includes our feedback on the “issue summary” tab.
Our notes include:
		•	Root cause classified as either “source data” or “code”
		•	Notes identifying:
				o	five items where the issue listed appears to be in conflict with the 3.1 specifications we are working against
				o	two items which are listed as failures but show zero failed rows

We’re awaiting your feedback on:
		•	Which issues must be resolved to “zero failed records”
		•	Which issues have a threshold that is acceptable (and what that threshold is)

Below is CHG’s planned approach ahead of Tuesday’s technical team meeting:
		1.	CHG will freeze our source data as of 7/18 to ensure code is working as expected and that shifting source data is not causing variations in the issue counts.
		2.	CHG will address severity “3-High” errors where the root cause is “code” on a one by one basis, asking Symphony to process the file after each error has been addressed by CHG.
		3.	CHG will maintain focus on a single issue until the issue has been resolved to zero or can be transitioned to “source data” being the root cause.

Looking forward to your feedback and continuing the conversation on Tuesday.

Best,
Phil Steffek







JAH 'DELETE THESE'
-- C021: symphony REMEDIATION: Remove rows in Location file with LOC_TYPE = SERVICE for corresponding ADDRESS_IDs

		UPDATE INFORMATICS.dbo.SYMPHONY_IDENTIFIER
		SET TYPE_CD = 'PT'
		-- SELECT DISTINCT TYPE_CD 
		FROM INFORMATICS.dbo.SYMPHONY_IDENTIFIER
		WHERE 1=1
			AND TYPE_CD LIKE '%PT%'


		SELECT * FROM INFORMATICS.dbo.symphonyXWALKprofdegpvdrliccert

		SELECT DISTINCT TYPE_CD 
		FROM INFORMATICS.dbo.SYMPHONY_IDENTIFIER
		WHERE 1=1
			AND TYPE_CD LIKE '%PT%'

		SELECT DISTINCT TYPE_CD 
		FROM INFORMATICS.dbo.SYMPHONY_IDENTIFIER

-- ====================================================================
	-- FILECONTROL --
-- ====================================================================
		-- SELECT ' ' AS 'STAND ALONE #BASELINE', * FROM INFORMATICS.dbo.ENTITY_ID_MAPPING

		-- SELECT * FROM INFORMATICS.dbo.SYMPHONY_ENTITY
		-- SELECT * FROM INFORMATICS.dbo.SYMPHONY_LOCATION
		-- SELECT * FROM INFORMATICS.dbo.SYMPHONY_ADDRESS
		-- SELECT * FROM INFORMATICS.dbo.SYMPHONY_CONTACT
		-- SELECT * FROM INFORMATICS.dbo.SYMPHONY_ROSTER -- AS OF 20250117
		-- SELECT * FROM INFORMATICS.dbo.SYMPHONY_IDENTIFIER
		-- SELECT * FROM INFORMATICS.dbo.SYMPHONY_LANGUAGE -- AS OF 20250224
		-- SELECT * FROM INFORMATICS.dbo.SYMPHONY_TAXONOMY
		-- SELECT * FROM INFORMATICS.dbo.SYMPHONY_HOSPITAL
		-- SELECT * FROM INFORMATICS.dbo.SYMPHONY_NETWORK
		-- SELECT * FROM INFORMATICS.dbo.SYMPHONY_HOURS
		-- SELECT * FROM INFORMATICS.dbo.SYMPHONY_BED_DETAIL

		SELECT ' ' AS 'SOURCE COUNT(S)'
		,COUNT(DISTINCT(sourcetables.practiceid)) AS 'eVIPS practiceid'
		,COUNT(DISTINCT(sourcetables.locationid)) AS 'eVIPS locationid'
		,COUNT(DISTINCT(sourcetables.practitionerid)) AS 'eVIPS practitionerid'
		FROM
		( -- INITIATE ...
		SELECT DISTINCT practiceid
		,locationid
		,practitionerid
		FROM INFORMATICS.dbo.PROV_SANATOR_PROVDIR_CONTRACTING_ENT
		
		UNION 
		SELECT DISTINCT practiceid
		,locationid
		,TRY_CONVERT(nvarchar(255),NULL) AS practitionerid
		FROM INFORMATICS.dbo.FAC_SANATOR_PROVDIR_CONTRACTING_ENT
		) AS sourcetables

		SELECT ' ' AS 'ENTITY MAPPING RESULT COUNT(S)'
		,ENTITY_TYPE
		,COUNT(DISTINCT(provid)) AS 'Entity Type #BASELINE'
		FROM INFORMATICS.dbo.ENTITY_ID_MAPPING
		GROUP BY ENTITY_TYPE
		ORDER BY ENTITY_TYPE

--"|location_id           |network_code                  |entity_id|duplicate_count|failed_count|
--|4109536LSERVICE5595409|CHGSD_HMO_Communicare_Advantag|5595409  |2              |2797        |" ... ENTITY_ID, LOCATION_ID, NETWORK_NAME, PLANTYPE, LOB combination is not duplicated

--"|NETWORK_NAME    |PLAN_TYPE|lob  |location_id           |count_duplicates|failed_count|
--|Dual Beneficiary|HMO      |MCARE|6248864LSERVICE6115208|2               |2797        |" ... ENTITY_ID, LOCATION_ID, NETWORK_NAME, PLANTYPE, LOB combination is not duplicated
SELECT ' ' AS 'STAND ALONE #BASELINE', * 
FROM INFORMATICS.dbo.ENTITY_ID_MAPPING
WHERE 1=1
	AND provid IN ('5595409')

SELECT * 
FROM INFORMATICS.dbo.SYMPHONY_ENTITY
WHERE 1=1
	AND ENTITY_ID IN ('5595409')

SELECT * 
FROM INFORMATICS.dbo.SYMPHONY_LOCATION
WHERE 1=1
	-- AND ENTITY_ID IN ('5595409')
	AND LOCATION_ID IN ('4109536LSERVICE5595409','6248864LSERVICE6115208')

SELECT * 
FROM INFORMATICS.dbo.SYMPHONY_NETWORK
WHERE 1=1
	AND LOCATION_ID IN ('4109536LSERVICE5595409','6248864LSERVICE6115208')

SELECT ' ' AS 'SAMPLE - CHECK TO DELETE THESE: ',*
FROM 
( -- INITIATE  ...
SELECT DENSE_RANK() OVER(PARTITION BY leadlagnet.LOCATION_ID ORDER BY leadlagnet.CONTRACTED_PARTY ASC) AS [RANKis] -- RANK() ACCOUNT(s) FOR TIES + RETAINS SEQUENCE ... NO NEGATIVE NOT != <> GAPS IN THE SEQUENCE
,leadlagnet.*
FROM 
( -- INITIATE ...
SELECT ' ' AS 'symphony WOT CWT',*
FROM INFORMATICS.dbo.SYMPHONY_NETWORK
WHERE 1=1 
	AND LOCATION_ID+''+NETWORK_CODE IN
	( -- INITIATE ...
	SELECT LOCATION_ID+''+NETWORK_CODE
	FROM INFORMATICS.dbo.SYMPHONY_NETWORK AS dup
	GROUP BY LOCATION_ID+''+NETWORK_CODE -- Duplication Driver 
	HAVING COUNT(1)>1 -- HAVING clause RESERVED for AGGREGATE(s) ... HAVING SUM(PAID_NET_AMT) != 0
	) -- CONCLUDE ...
	) -- CONCLUDE ...
	AS leadlagnet
	) -- CONCLUDE ...
	AS wotcwt
WHERE 1=1
	AND wotcwt.LOCATION_ID IN ('4109536LSERVICE5595409','6248864LSERVICE6115208')
ORDER BY wotcwt.LOCATION_ID

SELECT ' ' AS 'SAMPLE - RETAIN THESE: ',*
FROM 
( -- INITIATE  ...
SELECT DENSE_RANK() OVER(PARTITION BY leadlagnet.LOCATION_ID ORDER BY leadlagnet.CONTRACTED_PARTY ASC) AS [RANKis] -- RANK() ACCOUNT(s) FOR TIES + RETAINS SEQUENCE ... NO NEGATIVE NOT != <> GAPS IN THE SEQUENCE
,leadlagnet.*
FROM 
( -- INITIATE ...
SELECT ' ' AS 'symphony WOT CWT',*
FROM INFORMATICS.dbo.SYMPHONY_NETWORK
WHERE 1=1 
	AND LOCATION_ID+''+NETWORK_CODE IN
	( -- INITIATE ...
	SELECT LOCATION_ID+''+NETWORK_CODE
	FROM INFORMATICS.dbo.SYMPHONY_NETWORK AS dup
	GROUP BY LOCATION_ID+''+NETWORK_CODE -- Duplication Driver 
	HAVING COUNT(1)>1 -- HAVING clause RESERVED for AGGREGATE(s) ... HAVING SUM(PAID_NET_AMT) != 0
	) -- CONCLUDE ...
	) -- CONCLUDE ...
	AS leadlagnet
	) -- CONCLUDE ...
	AS wotcwt
WHERE 1=1
	AND wotcwt.LOCATION_ID IN ('4109536LSERVICE5595409','6248864LSERVICE6115208')
	AND wotcwt.RANKis = 1
ORDER BY wotcwt.LOCATION_ID

--"|Provider_ID|NPI       |Fail_Reason                               |failed_count|
--|4115251    |1467557454|Failure - No Speciality for this Facility |294         |"
SELECT * 
FROM INFORMATICS.dbo.[SANATOR_SYMPHONY_DATA_MODELING_MAP] AS dmmap
WHERE 1=1
	AND UPPER(LTRIM(RTRIM(ISNULL(dmmap.code,'')))) IN ('207RC0000X')

SELECT ' ' AS 'STAND ALONE #BASELINE', * 
FROM INFORMATICS.dbo.ENTITY_ID_MAPPING
WHERE 1=1
	AND provid IN ('4115251')

SELECT provid,* 
FROM INFORMATICS.dbo.SYMPHONY_ENTITY
WHERE 1=1
	AND ENTITY_ID IN ('4115251')
	AND NPI IN ('1467557454')

SELECT * 
FROM INFORMATICS.dbo.SYMPHONY_TAXONOMY
WHERE 1=1
	AND ENTITY_ID IN ('4115251','4115250') 
	
SELECT * 
FROM INFORMATICS.dbo.SYMPHONY_ROSTER
WHERE 1=1
	AND PRIMARY_ID IN ('4115251')
		OR SECONDARY_ID IN ('4115251')

-- JOIN INFORMATICS.dbo.[SANATOR_SYMPHONY_DATA_MODELING_MAP] AS dmmap ON UPPER(LTRIM(RTRIM(ISNULL(tax.TaxonomyCode,'')))) COLLATE DATABASE_DEFAULT = UPPER(LTRIM(RTRIM(ISNULL(dmmap.code,'')))) COLLATE DATABASE_DEFAULT

UNION 
SELECT DISTINCT -- s.PROVTAXID AS ENTITY_ID,
eid.ENTITY_ID,
eim.provid,
eim.PLACEHOLDER_TAXONOMY AS TAXONOMY_CODE,
TRY_CONVERT(INT,NULL) AS PATIENT_MAX_AGE,
TRY_CONVERT(INT,NULL) AS PATIENT_MIN_AGE,
TRY_CONVERT(INT,NULL) AS ACCEPTED_GENDER_CD,
TRY_CONVERT(VARCHAR(20),NULL) AS PANEL_SIZE,
TRY_CONVERT(BINARY(1),NULL) AS IS_BOARD_CERT,
TRY_CONVERT(DATE,NULL) AS BOARD_CERT_EFF_DT,
TRY_CONVERT(DATE,NULL) AS BOARD_CERT_EXP_DT,
TRY_CONVERT(DATE,NULL) AS PANEL_START_DT,
TRY_CONVERT(DATE,NULL) AS PANEL_END_DT,
TRY_CONVERT(DATE,NULL) AS EFFECTIVE_DT
FROM INFORMATICS.dbo.ENTITY_ID_MAPPING AS eim 	-- SELECT ' ' AS 'STAND ALONE #BASELINE', * FROM INFORMATICS.dbo.ENTITY_ID_MAPPING
	JOIN INFORMATICS.dbo.SYMPHONY_ENTITY AS eid ON eim.provid = eid.provid -- LOCK IN FROM THE START ...
	JOIN INFORMATICS.dbo.[SANATOR_SYMPHONY_DATA_MODELING_MAP] AS dmmap ON UPPER(LTRIM(RTRIM(ISNULL(eim.PLACEHOLDER_TAXONOMY,'')))) COLLATE DATABASE_DEFAULT = UPPER(LTRIM(RTRIM(ISNULL(dmmap.code,'')))) COLLATE DATABASE_DEFAULT
WHERE 1=1
	AND eim.provid IN ('4115251') -- CHECK SAMPLE: 
	
SELECT DISTINCT tax.*
,TRY_CONVERT(nvarchar(12),ENTITY_TYPE)
,TRY_CONVERT(nvarchar(50),utid.provid)
,TRY_CONVERT(nvarchar(50),utid.PracticeID) AS 'PracticeID'
,TRY_CONVERT(nvarchar(50),utid.locationid) AS 'locationid'
,TRY_CONVERT(nvarchar(50),utid.PractitionerId) AS 'PractitionerId'
,TRY_CONVERT(nvarchar(50),utid.AddressID)
,TRY_CONVERT(nvarchar(50),utid.eVipsPracticeID)
,TRY_CONVERT(nvarchar(50),utid.eVipslocationid)
,TRY_CONVERT(nvarchar(50),utid.eVipsPractitionerId)
,TRY_CONVERT(nvarchar(50),utid.eVipsAddressID)
,DENSE_RANK() OVER(PARTITION BY utid.provid ORDER BY utid.locationid DESC) AS [RANKis] -- RANK() ACCOUNT(s) FOR TIES + RETAINS SEQUENCE ... NO NEGATIVE NOT != <> GAPS IN THE SEQUENCE
,ROW_NUMBER() OVER(PARTITION BY utid.provid ORDER BY utid.locationid DESC) AS [ROWis] -- STRAIGHT FORWARD SEQUENCE
,'ENT' + CAST(ABS(CAST(CAST(NEWID() AS VARBINARY) AS INT)) AS NVARCHAR(20)) AS 'NEW_ENTITY_ID' -- ENSURE UPDATE of ALL dependent tables that reference ENTITY_ID
,'LOC' + CAST(ABS(CAST(CAST(NEWID() AS VARBINARY) AS INT)) AS NVARCHAR(20)) AS 'NEW_LOCATION_ID' -- ENSURE UPDATE of ALL dependent tables that reference ENTITY_ID
FROM #UniqueTaxIDs AS utid
	JOIN 
	( -- INITIATE ...
	SELECT DISTINCT ' ' AS 'TAXONOMY, TAXID + DEA',s.SnapshotID
	,s.SiteID
	,s.eVIPSSiteID -- 'locationid'
	,s.eVIPSSiteID AS 'locationid'
	,s.TaxIDNumber
	,s.DEANumber
	,st.TaxonomyCode
	FROM [ProviderRepository].dbo.[Sites] AS s 
		JOIN [ProviderRepository].dbo.[SiteTaxonomy] AS st ON s.SiteID = st.SiteID
			AND ISNULL(st.TaxonomyCode,'') != ''
	WHERE 1=1	
		-- AND ISNULL(s.TaxIDNumber,'') != '' -- REQ. FOR CCA SUBMISSION
	) -- CONCLUDE ...
	AS tax ON utid.locationid = tax.locationid
WHERE 1=1
	AND utid.locationid IN ('4115251','4115250')

SELECT DISTINCT tax.*
,TRY_CONVERT(nvarchar(12),ENTITY_TYPE)
,TRY_CONVERT(nvarchar(50),utid.provid)
,TRY_CONVERT(nvarchar(50),utid.PracticeID) AS 'PracticeID'
,TRY_CONVERT(nvarchar(50),utid.locationid) AS 'locationid'
,TRY_CONVERT(nvarchar(50),utid.PractitionerId) AS 'PractitionerId'
,TRY_CONVERT(nvarchar(50),utid.AddressID)
,TRY_CONVERT(nvarchar(50),utid.eVipsPracticeID)
,TRY_CONVERT(nvarchar(50),utid.eVipslocationid)
,TRY_CONVERT(nvarchar(50),utid.eVipsPractitionerId)
,TRY_CONVERT(nvarchar(50),utid.eVipsAddressID)
,DENSE_RANK() OVER(PARTITION BY utid.provid ORDER BY utid.locationid DESC) AS [RANKis] -- RANK() ACCOUNT(s) FOR TIES + RETAINS SEQUENCE ... NO NEGATIVE NOT != <> GAPS IN THE SEQUENCE
,ROW_NUMBER() OVER(PARTITION BY utid.provid ORDER BY utid.locationid DESC) AS [ROWis] -- STRAIGHT FORWARD SEQUENCE
,'ENT' + CAST(ABS(CAST(CAST(NEWID() AS VARBINARY) AS INT)) AS NVARCHAR(20)) AS 'NEW_ENTITY_ID' -- ENSURE UPDATE of ALL dependent tables that reference ENTITY_ID
,'LOC' + CAST(ABS(CAST(CAST(NEWID() AS VARBINARY) AS INT)) AS NVARCHAR(20)) AS 'NEW_LOCATION_ID' -- ENSURE UPDATE of ALL dependent tables that reference ENTITY_ID
FROM #UniqueTaxIDs AS utid
	JOIN 
	( -- INITIATE ...
	SELECT DISTINCT ' ' AS 'TAXONOMY, TAXID + DEA',g.SnapshotID
	,g.GroupID
	,g.eVIPSGroupID -- 'practiceid'
	,g.eVIPSGroupID AS 'practiceid'
	,g.TaxIDNumber
	,gt.TaxonomyCode
	FROM [ProviderRepository].dbo.[Groups] AS g
		JOIN [ProviderRepository].dbo.[GroupTaxonomy] AS gt ON gt.GroupID = g.GroupID
			AND ISNULL(gt.TaxonomyCode,'') != ''
	WHERE 1=1
		AND ISNULL(g.TaxIDNumber,'') != '' -- REQ. FOR CCA SUBMISSION
		) -- CONCLUDE ...
		AS tax ON utid.PracticeID = tax.practiceid
WHERE 1=1
	AND utid.locationid IN ('4115251','4115250')

--		|Provider_ID|NPI       |Fail_Reason                               |failed_count|
--|6249479    |1770093437|Failure - No Speciality for this Provider |12          |
SELECT * 
FROM INFORMATICS.dbo.SYMPHONY_ENTITY
WHERE 1=1
	AND ENTITY_ID IN ('6249479')
	AND NPI IN ('1770093437')

SELECT * 
FROM INFORMATICS.dbo.SYMPHONY_TAXONOMY
WHERE 1=1
	AND ENTITY_ID IN ('6249479') 

--		"|provider_entity_id|loc_type|provider_address_id|business_entity_id|failed_count|
--|4107493           |SERVICE |3881623            |4107491           |70          |" -- Entity type FACILITY should have at least one matching BUSINESS location for location type SERVICE  ... Add row in Location file for PRIMARY_ID from roster file row corresponding to the Facility
SELECT * 
FROM INFORMATICS.dbo.SYMPHONY_ENTITY
WHERE 1=1
	AND ENTITY_ID IN ('4107493','4107491')

SELECT * 
FROM INFORMATICS.dbo.SYMPHONY_LOCATION
WHERE 1=1
	AND ENTITY_ID IN ('4107493') -- ,'4107491')
	AND ADDRESS_ID IN ('3881623')

SELECT * 
FROM INFORMATICS.dbo.SYMPHONY_ROSTER
WHERE 1=1
	AND PRIMARY_ID IN ('4107493','4107491')
	AND SECONDARY_ID IN ('4107493','4107491')

--"|provider_entity_id|loc_type|provider_address_id|business_entity_id|failed_count|
--|4377895           |SERVICE |90879              |4126763           |1685        |" -- Entity type PROVIDER location should have at least one matching BUSINESS location for location type SERVICE ... Add row in Location file for PRIMARY_ID from roster file row corresponding to the Provider
SELECT * 
FROM INFORMATICS.dbo.SYMPHONY_ENTITY
WHERE 1=1
	AND ENTITY_ID IN ('4377895') -- ,'4126763')

SELECT * 
FROM INFORMATICS.dbo.SYMPHONY_LOCATION
WHERE 1=1
	AND ENTITY_ID IN ('4377895','4126763')
	AND ADDRESS_ID IN ('90879')

SELECT * 
FROM INFORMATICS.dbo.SYMPHONY_ROSTER
WHERE 1=1
	AND PRIMARY_ID IN ('4126763','4377895')
	AND SECONDARY_ID IN ('4126763','4377895')

--"|line_1        |loc_type|location_id           |address_id|failed_count|
--|PO BOX 846621 |SERVICE |4107267LSERVICE4107266|3881045   |92          |"
SELECT * 
FROM INFORMATICS.dbo.SYMPHONY_LOCATION
WHERE 1=1
	--AND LOCATION_ID IN('4107267LSERVICE4107266')
	AND LOC_TYPE IN ('SERVICE')
	AND ADDRESS_ID IN (	SELECT DISTINCT ADDRESS_ID
	FROM INFORMATICS.dbo.SYMPHONY_ADDRESS
	WHERE 1=1
		AND LINE_1 LIKE 'P%O%BOX%')

SELECT * 
FROM INFORMATICS.dbo.SYMPHONY_ADDRESS
WHERE 1=1
	-- AND ADDRESS_ID IN('3881045')
	AND LINE_1 LIKE 'P%O%BOX%'

--|network_id    |location_id           |entity_id|entity_type|loc_type|failed_count|
--|NETW1454249425|4107217LSERVICE4107214|4107214  |BUSINESS   |SERVICE |5993        |
SELECT * 
FROM INFORMATICS.dbo.SYMPHONY_ENTITY
WHERE 1=1
	AND ENTITY_ID IN ('4107214')

SELECT * 
FROM INFORMATICS.dbo.SYMPHONY_LOCATION
WHERE 1=1
	AND LOCATION_ID IN ('4107217LSERVICE4107214')
		OR ENTITY_ID IN ('4107214')

SELECT * 
FROM INFORMATICS.dbo.SYMPHONY_NETWORK
WHERE 1=1
	AND LOCATION_ID IN ('4107217LSERVICE4107214')

--UPDATE INFORMATICS.dbo.SYMPHONY_NETWORK
--SET LOCATION_ID = 'DELETE'
--FROM INFORMATICS.dbo.SYMPHONY_NETWORK AS n
--	JOIN INFORMATICS.dbo.SYMPHONY_LOCATION AS l ON n.LOCATION_ID = l.LOCATION_ID
--	JOIN INFORMATICS.dbo.SYMPHONY_ENTITY AS e ON l.ENTITY_ID = e.ENTITY_ID
--		AND e.ENTITY_TYPE IN ('BUSINESS')

SELECT ' ' AS 'DELETE THESE',*
FROM INFORMATICS.dbo.SYMPHONY_NETWORK AS n
	JOIN INFORMATICS.dbo.SYMPHONY_LOCATION AS l ON n.LOCATION_ID = l.LOCATION_ID
	JOIN INFORMATICS.dbo.SYMPHONY_ENTITY AS e ON l.ENTITY_ID = e.ENTITY_ID
		AND e.ENTITY_TYPE IN ('BUSINESS')
WHERE 1=1
	-- AND n.LOCATION_ID IN ('4107217LSERVICE4107214')

SELECT ' ' AS 'DELETE THESE',*
-- DELETE
FROM INFORMATICS.dbo.SYMPHONY_NETWORK
WHERE 1=1
	AND LOCATION_ID IN ('DELETE')







JAH '_NETWORK'
-- C020: PER TECHNICAL MEETING WITH symphony ON 20250620 Remove rows in Network file where LOC_TYPE != SERVICE

--"|network_id    |location_id            |entity_id|entity_type|loc_type|failed_count|
--|NETW1669626021|4126947LBUSINESS4126763|4126763  |BUSINESS   |BUSINESS|44886       |"

TRY_CONVERT(nvarchar(25),leadlagforprimind.locationid)+'L'+LOC_TYPE+TRY_CONVERT(nvarchar(25),leadlagforprimind.ENTITY_ID) AS [LOCATION_ID],   -- C012: eid.provid: REPRESENTS AN EFFORT BY CREDENTIALING DEPT. DESIRE TO RETAIN eVIPS ID DESPITE symphony's INABILITY TO PROCESS UPLOAD ...  -- C019: DUMMY DBA (BUSINESS) BEING CLASSIFIED AS 'SERVICE' LOCATIONS PER ACTION ITEMS: SYMPHONY - Follow-Up: Symphony and CHG 6.6.2025 Semi-Monthly Implementation Meetings

SELECT ' ' AS 'SHOULD BE NULL',*
FROM INFORMATICS.dbo.SYMPHONY_NETWORK
WHERE 1=1
	AND ISNULL(LOCATION_ID,'') LIKE '%BUSINESS%' -- C###: PER TECHNICAL MEETING WITH symphony ON 20250620 Remove rows in Network file where LOC_TYPE != SERVICE

--"|entity_id|location_id|language_cd|count(1)|failed_count|
--|4380927  |null       |ENG        |3       |2084        |"

SELECT *
FROM INFORMATICS.dbo.SYMPHONY_LANGUAGE
WHERE 1=1
	AND ISNULL(ENTITY_ID,'') LIKE '%4380927%' -- SAMPLE PER TECHNICAL MEETING WITH symphony ON 2025062

	-- WHERE 1=1
		--	AND ISNULL(practitionerid,'') IN ('4380927')

--"|provider_entity_id|loc_type|provider_address_id|business_entity_id|failed_count|
--|4377895           |SERVICE |90879              |4126763           |1691        |"

SELECT * 
FROM INFORMATICS.dbo.SYMPHONY_ENTITY
WHERE 1=1
	AND ENTITY_ID IN ('4377895','4126763')

SELECT * 
FROM INFORMATICS.dbo.SYMPHONY_LOCATION
WHERE 1=1
	AND address_id IN ('90879')
		-- OR ENTITY_ID IN ('4126763')

SELECT * 
FROM INFORMATICS.dbo.SYMPHONY_LOCATION
WHERE 1=1
	AND address_id IN ('90879')
	AND ENTITY_ID IN ('4126763')

SELECT * 
FROM INFORMATICS.dbo.SYMPHONY_ADDRESS
WHERE 1=1
	AND address_id IN ('90879')







JAH 'AWOT'

		SELECT DISTINCT 'CHGSD_FILECONTROL_'+REPLACE(REPLACE(REPLACE(LTRIM(RTRIM(CAST( CONVERT(NVARCHAR(25),TRY_CONVERT(DATETIME,GETDATE()),120) AS NVARCHAR(25)))),' ',''),'-',''),':','') AS FileTableName,* 
		FROM INFORMATICS.dbo.SYMPHONY_FILECONTROL
		ORDER BY FILE_SEQ_NBR;		

"|provider_entity_id|provider_address_id|business_entity_id|failed_count|
|4376724           |3898536            |4117676           |2051        |"
FROM INFORMATICS.dbo.SYMPHONY_LOCATION

"|Provider_ID|NPI       |Location_ID           |Location_Type|Network_Count|Fail_Reason                    |failed_count|
|4386185    |1518414366|5139771LSERVICE4386185|SERVICE      |0            |Failure - No associated Network|10232       |"
FROM INFORMATICS.dbo.SYMPHONY_NETWORK

"|ROSTER_ID    |PRIMARY_ID|SECONDARY_ID|RELATIONSHIP_TYPE|EFFECTIVE_DT|EXPIRED_DT|EXPIRED_REASON_CD|ENTITY_ID|ENTITY_TYPE|failed_count|
|ROS1383470158|4108468   |4108469     |Bus2Prov         |null        |null      |null             |null     |null       |24          |"
FROM INFORMATICS.dbo.SYMPHONY_ROSTER







		SELECT ' ' AS 'CHECK 1st',COUNT(DISTINCT(TaxonomyCode)) AS 'Taxonomy OPTION(S)'
		-- SELECT DISTINCT ' ' AS 'CHECK 1st'
		FROM ProviderRepository.dbo.ANCTaxonomyCrosswalk AS tc

;WITH inclusionexclusion AS -- C###: DEPLOY INCLUSION SCRIPT OF ENTITY WITH A TAXONOMY CODE FROM THE START PER DISCUSSION WITH  SIR PHIL RELATED TO: "symphony_20250613_CHGSD_SYM_FlatFile_DRD.xlsx"
( -- INITIATE ...
SELECT DISTINCT ' ' AS 'INCLUSION v EXCLUSION FROM THE START: '
,p.PracticeID
,TRY_CONVERT(nvarchar(50),p.PractitionerID) AS 'PractitionerID'
,p.Locationid
FROM INFORMATICS.dbo.PROV_SANATOR_PROVDIR_CONTRACTING_ENT AS p	
	JOIN INFORMATICS.dbo.SYMPHONY_ENTITY AS eid ON p.PractitionerID = eid.provid
	JOIN 
	( -- INITIATE ...
	SELECT DISTINCT ' ' AS 'TAXONOMY, TAXID + DEA',p.SnapshotID
	,p.ProviderID
	,p.eVIPSProviderID -- 'practitionerid'
	,p.eVIPSProviderID AS 'practitionerid'
	,p.DEANumber 
	,vpp.TaxIDNumber
	,pt.TaxonomyCode
	FROM [ProviderRepository].dbo.[Providers] AS p
			LEFT JOIN evips_chgcv.dbo.vwPractitionerProducts AS vpp On p.ProviderID = vpp.PractitionerID
			LEFT JOIN [ProviderRepository].dbo.[ProviderTaxonomy] AS pt ON p.ProviderID = pt.ProviderID
				AND ISNULL(pt.TaxonomyCode,'') != ''
	WHERE 1=1
		-- AND ISNULL(vpp.TaxIDNumber,'') != '' -- REQ. FOR CCA SUBMISSION
			) -- CONCLUDE ...
			AS tax ON p.practitionerid = tax.practitionerid
	JOIN INFORMATICS.dbo.[SANATOR_SYMPHONY_DATA_MODELING_MAP] AS dmmap ON UPPER(LTRIM(RTRIM(ISNULL(tax.TaxonomyCode,'')))) COLLATE DATABASE_DEFAULT = UPPER(LTRIM(RTRIM(ISNULL(dmmap.code,'')))) COLLATE DATABASE_DEFAULT
WHERE 1=1
	AND ISNULL(CAST(tax.TaxonomyCode AS NVARCHAR(255)),'IGNORE') != 'IGNORE'
	
UNION 
SELECT DISTINCT ' ' AS 'INCLUSION v EXCLUSION FROM THE START: '
,s.PracticeID
,TRY_CONVERT(nvarchar(50),NULL) AS 'PractitionerID'
,s.Locationid
FROM INFORMATICS.dbo.FAC_SANATOR_PROVDIR_CONTRACTING_ENT AS s
	JOIN INFORMATICS.dbo.SYMPHONY_ENTITY AS eid ON s.locationid = eid.provid
	JOIN 
	( -- INITIATE ...
	SELECT DISTINCT ' ' AS 'TAXONOMY, TAXID + DEA',s.SnapshotID
	,s.SiteID
	,s.eVIPSSiteID -- 'locationid'
	,s.eVIPSSiteID AS 'locationid'
	,s.TaxIDNumber
	,s.DEANumber
	,st.TaxonomyCode
	FROM [ProviderRepository].dbo.[Sites] AS s 
		JOIN [ProviderRepository].dbo.[SiteTaxonomy] AS st ON s.SiteID = st.SiteID
			AND ISNULL(st.TaxonomyCode,'') != ''
	WHERE 1=1	
		-- AND ISNULL(s.TaxIDNumber,'') != '' -- REQ. FOR CCA SUBMISSION
	) -- CONCLUDE ...
	AS tax ON s.locationid = tax.locationid
	JOIN INFORMATICS.dbo.[SANATOR_SYMPHONY_DATA_MODELING_MAP] AS dmmap ON UPPER(LTRIM(RTRIM(ISNULL(tax.TaxonomyCode,'')))) COLLATE DATABASE_DEFAULT = UPPER(LTRIM(RTRIM(ISNULL(dmmap.code,'')))) COLLATE DATABASE_DEFAULT
WHERE 1=1
	AND ISNULL(CAST(tax.TaxonomyCode AS NVARCHAR(255)),'IGNORE') != 'IGNORE'
	
UNION 
SELECT DISTINCT ' ' AS 'INCLUSION v EXCLUSION FROM THE START: '
,p.PracticeID
,TRY_CONVERT(nvarchar(50),p.PractitionerID) AS 'PractitionerID'
,p.Locationid
FROM INFORMATICS.dbo.PROV_SANATOR_PROVDIR_CONTRACTING_ENT AS p
	JOIN INFORMATICS.dbo.SYMPHONY_ENTITY AS eid ON p.PracticeID = eid.provid
	JOIN 
	( -- INITIATE ...
	SELECT DISTINCT ' ' AS 'TAXONOMY, TAXID + DEA',g.SnapshotID
	,g.GroupID
	,g.eVIPSGroupID -- 'practiceid'
	,g.eVIPSGroupID AS 'practiceid'
	,g.TaxIDNumber
	,gt.TaxonomyCode
	FROM [ProviderRepository].dbo.[Groups] AS g
		JOIN [ProviderRepository].dbo.[GroupTaxonomy] AS gt ON gt.GroupID = g.GroupID
			AND ISNULL(gt.TaxonomyCode,'') != ''
	WHERE 1=1
		AND ISNULL(g.TaxIDNumber,'') != '' -- REQ. FOR CCA SUBMISSION
	) -- CONCLUDE ...
	AS tax ON p.PracticeID = tax.practiceid
	JOIN INFORMATICS.dbo.[SANATOR_SYMPHONY_DATA_MODELING_MAP] AS dmmap ON UPPER(LTRIM(RTRIM(ISNULL(tax.TaxonomyCode,'')))) COLLATE DATABASE_DEFAULT = UPPER(LTRIM(RTRIM(ISNULL(dmmap.code,'')))) COLLATE DATABASE_DEFAULT	
WHERE 1=1
	AND ISNULL(CAST(tax.TaxonomyCode AS NVARCHAR(255)),'IGNORE') != 'IGNORE'
	
UNION 
SELECT DISTINCT ' ' AS 'INCLUSION v EXCLUSION FROM THE START: '
,s.PracticeID
,TRY_CONVERT(nvarchar(50),NULL) AS 'PractitionerID'
,s.Locationid
FROM INFORMATICS.dbo.FAC_SANATOR_PROVDIR_CONTRACTING_ENT AS s
	JOIN INFORMATICS.dbo.SYMPHONY_ENTITY AS eid ON s.PracticeID = eid.provid
	JOIN 
	( -- INITIATE ...
	SELECT DISTINCT ' ' AS 'TAXONOMY, TAXID + DEA',g.SnapshotID
	,g.GroupID
	,g.eVIPSGroupID -- 'practiceid'
	,g.eVIPSGroupID AS 'practiceid'
	,g.TaxIDNumber
	,gt.TaxonomyCode
	FROM [ProviderRepository].dbo.[Groups] AS g
		JOIN [ProviderRepository].dbo.[GroupTaxonomy] AS gt ON gt.GroupID = g.GroupID
			AND ISNULL(gt.TaxonomyCode,'') != ''
	WHERE 1=1
		AND ISNULL(g.TaxIDNumber,'') != '' -- REQ. FOR CCA SUBMISSION
		) -- CONCLUDE ...
		AS tax ON s.PracticeID = tax.practiceid
		JOIN INFORMATICS.dbo.[SANATOR_SYMPHONY_DATA_MODELING_MAP] AS dmmap ON UPPER(LTRIM(RTRIM(ISNULL(tax.TaxonomyCode,'')))) COLLATE DATABASE_DEFAULT = UPPER(LTRIM(RTRIM(ISNULL(dmmap.code,'')))) COLLATE DATABASE_DEFAULT
WHERE 1=1
	AND ISNULL(CAST(tax.TaxonomyCode AS NVARCHAR(255)),'IGNORE') != 'IGNORE'
	) -- CONCLUDE ...

		SELECT * 
		FROM inclusionexclusion
		WHERE 1=1
		
		
		




-- =====================================================
	-- MULTI - DATABASE OBJECT SEARCH TEMPLATE: 
-- =====================================================
DECLARE @SearchText NVARCHAR(MAX) = 'eVIPSProviderID';  -- Text to search for DEANumber, CONTRACTING_, primarystatus, uvw_JusticeInvolvedIndicator, Marketer, Grievance, paid, LTCFacilityType, eVIPSGroupID, eVIPSSiteID, eVIPSProviderID
DECLARE @ExactMatchST BIT = 0;               -- SET AS 1 WHEN NULL OR FOR an exact match ON @PARAM
DECLARE @ObjectName NVARCHAR(MAX) = NULL;    -- Specific object name to search for (optional) uvw_BASELINE_MEMBERSHIP, CONTRACTING_
DECLARE @ExactMatchON BIT = 1;               -- SET AS 1 WHEN NULL OR FOR an exact match ON @PARAM
DECLARE @SchemaName NVARCHAR(128) = NULL;     -- Limit search to specific schema (optional) magellan, dbo, ECM
DECLARE @ObjectType NVARCHAR(128) = NULL;    -- Limit to specific object type (optional)
DECLARE @IncludeSystemObjects BIT = 0;       -- SET AS 1 FOR TO include system objects

		SELECT ISNULL(@SearchText,'N/A') AS 'txt CHARINDEX() FIND() SEARCH()'
		,ISNULL(@ObjectName,'N/A') AS 'obj CHARINDEX() FIND() SEARCH()'
		,ISNULL(@SchemaName,'N/A') AS 'SCHEMA() CHARINDEX() FIND() SEARCH()'

-- Define databases to search (add or remove as needed)
DECLARE @DatabaseList TABLE (DatabaseName NVARCHAR(128))
INSERT INTO @DatabaseList (DatabaseName)
VALUES 
 --   ('INFORMATICS'), -- WORKING [db]
 --   ('HMOPROD_PLANDATA'), -- QNXT [db]
 --   ('EnrollmentManager'), -- 834 MEMBERSHIP
	--('FINCHG'), -- FINANCE DEPT.	
 --   ('MemberPortal'),
 --   ('ProviderPortal'),
 --   ('CHGAPP_PROD'),	
	--('evips_chgcv'), -- SERVER: SQLPRODAPP01 PROVIDER NETWORK SOURCE DATA
    ('ProviderRepository'); -- SERVER: SQLPRODAPP01 REPO
	--('INFOAG'), -- SERVER: SQLPRODAPP01 LINKED SERVER TO SQLPROD02.INFORMATICS [db]
	--('QPROD'),
 --   ('DATAWAREHOUSE'), -- LEGACY DW
 --   ('INFORMATICS2'), -- SQLPROD01.QPROD
 --   ('DIAMOND_Data');  -- LEGACY SYSTEM (D950) ... 
	
		SELECT ' ' AS '[db](s) TO QRY: ',* FROM @DatabaseList

-- Create a temporary table to store results
DROP TABLE IF EXISTS #SearchResults;

CREATE TABLE #SearchResults (
    DatabaseName NVARCHAR(128),
    ResultType NVARCHAR(50),
    SchemaName VARCHAR(128),
    ObjectName NVARCHAR(256),
    ObjectType NVARCHAR(128),
    ColumnName NVARCHAR(128) NULL,
    DataTypeInfo NVARCHAR(256) NULL,
    AdditionalInfo NVARCHAR(MAX) NULL,
    ModifiedDate DATETIME NULL
);

-- Prepare search patterns
DECLARE @SearchPattern NVARCHAR(255) = CASE 
    WHEN @ExactMatchST = 1 THEN @SearchText
    ELSE '%' + ISNULL(@SearchText, '') + '%'
END;

DECLARE @ObjectPattern NVARCHAR(MAX) = CASE 
    WHEN @ExactMatchON = 1 THEN @ObjectName
    ELSE '%' + ISNULL(@ObjectName, '') + '%'
END;

-- Cursor to loop through databases
DECLARE @CurrentDB NVARCHAR(128)
DECLARE @SQL NVARCHAR(MAX)
DECLARE db_cursor CURSOR FOR 
SELECT DatabaseName FROM @DatabaseList
OPEN db_cursor  
FETCH NEXT FROM db_cursor INTO @CurrentDB

WHILE @@FETCH_STATUS = 0  
BEGIN
    PRINT 'Processing database: ' + @CurrentDB;
    
    BEGIN TRY

        -- Check if database exists and is accessible
        /* SET @SQL = N'IF DB_ID(''' + @CurrentDB + ''') IS NOT NULL 
                   BEGIN
                       USE ' + QUOTENAME(@CurrentDB) + ';
                       SELECT 1 AS [db CHECK];
                   END
                   ELSE
                   BEGIN
                       RAISERROR(''Database does not exist or is not accessible'', 16, 1);
                   END'; 
                   
        EXEC sp_executesql @SQL;*/
        
        -- 1. Search Object Definitions
        SET @SQL = N'
        USE ' + QUOTENAME(@CurrentDB) + N';
        
        INSERT INTO #SearchResults (DatabaseName, ResultType, SchemaName, ObjectName, ObjectType, AdditionalInfo, ModifiedDate)
        SELECT DISTINCT ''' + @CurrentDB + N''',
            ''Object Definition'', 
            SCHEMA_NAME(o.schema_id), 
            o.name, 
            ISNULL(o.type_desc,NULL),
            LEFT(m.definition, 100) + ''...'',
            o.modify_date
        FROM sys.sql_modules AS m
            INNER JOIN sys.objects AS o ON m.object_id = o.object_id
        WHERE 1=1
            AND (' + CASE WHEN @SchemaName IS NULL THEN N'1=1' ELSE N'SCHEMA_NAME(o.schema_id) = @SchemaName COLLATE DATABASE_DEFAULT' END + N')
            AND (' + CASE WHEN @ObjectType IS NULL THEN N'1=1' ELSE N'o.type_desc LIKE @ObjectType COLLATE DATABASE_DEFAULT' END + N')
            AND (' + CASE WHEN @IncludeSystemObjects = 1 THEN N'1=1' ELSE N'o.is_ms_shipped = 0' END + N')
            AND (m.definition LIKE @SearchPattern COLLATE DATABASE_DEFAULT OR o.name LIKE @ObjectPattern COLLATE DATABASE_DEFAULT)
            AND o.name NOT LIKE ''sp_MS%'';
            
        -- 2. Search Columns
        INSERT INTO #SearchResults (DatabaseName, ResultType, SchemaName, ObjectName, ObjectType, ColumnName, DataTypeInfo, AdditionalInfo)
        SELECT DISTINCT ''' + @CurrentDB + N''',
            ''Column'',
            c.TABLE_SCHEMA,
            c.TABLE_NAME,
            CAST(NULL AS nvarchar(128)),
            c.COLUMN_NAME,
            c.DATA_TYPE + 
                CASE 
                    WHEN c.CHARACTER_MAXIMUM_LENGTH IS NOT NULL 
                    THEN ''('' + CAST(c.CHARACTER_MAXIMUM_LENGTH AS VARCHAR(10)) + '')''
                    ELSE ''''
                END,
            ''Nullable: '' + c.IS_NULLABLE
        FROM INFORMATION_SCHEMA.COLUMNS AS c
            JOIN INFORMATION_SCHEMA.TABLES AS t ON c.TABLE_NAME = t.TABLE_NAME 
                AND c.TABLE_SCHEMA = t.TABLE_SCHEMA
        WHERE 1=1
            AND (' + CASE WHEN @SchemaName IS NULL THEN N'1=1' ELSE N'c.TABLE_SCHEMA = @SchemaName COLLATE DATABASE_DEFAULT' END + N')
            AND (c.COLUMN_NAME LIKE @SearchPattern COLLATE DATABASE_DEFAULT OR c.TABLE_NAME LIKE @ObjectPattern COLLATE DATABASE_DEFAULT);
            
        -- 3. Search Tables
        INSERT INTO #SearchResults (DatabaseName, ResultType, SchemaName, ObjectName, ObjectType)
        SELECT DISTINCT ''' + @CurrentDB + N''',
            ''TABLE'',
            t.TABLE_SCHEMA,
            t.TABLE_NAME,
            t.TABLE_TYPE
        FROM INFORMATION_SCHEMA.TABLES AS t
        WHERE 1=1
            AND (' + CASE WHEN @SchemaName IS NULL THEN N'1=1' ELSE N't.TABLE_SCHEMA = @SchemaName COLLATE DATABASE_DEFAULT' END + N')
            AND t.TABLE_NAME LIKE @ObjectPattern COLLATE DATABASE_DEFAULT;
            
        -- 4. Search Indexes
        INSERT INTO #SearchResults (DatabaseName, ResultType, SchemaName, ObjectName, ColumnName, DataTypeInfo, AdditionalInfo)
        SELECT DISTINCT ''' + @CurrentDB + N''',
            ''Index'',
            SCHEMA_NAME(t.schema_id),
            t.name,
            i.name,
            i.type_desc,
            ''Is Unique: '' + CASE WHEN i.is_unique = 1 THEN ''Yes'' ELSE ''No'' END
        FROM sys.indexes AS i
            INNER JOIN sys.tables AS t ON i.object_id = t.object_id
        WHERE 1=1
            AND (' + CASE WHEN @SchemaName IS NULL THEN N'1=1' ELSE N'SCHEMA_NAME(t.schema_id) = @SchemaName COLLATE DATABASE_DEFAULT' END + N')
            AND (i.name LIKE @SearchPattern COLLATE DATABASE_DEFAULT OR t.name LIKE @ObjectPattern COLLATE DATABASE_DEFAULT)
            AND i.name IS NOT NULL;';
            
        EXEC sp_executesql @SQL, 
            N'@SearchPattern NVARCHAR(MAX), @ObjectPattern NVARCHAR(MAX), @SchemaName NVARCHAR(128), @ObjectType NVARCHAR(128)',
            @SearchPattern, @ObjectPattern, @SchemaName, @ObjectType;
            
    END TRY
    BEGIN CATCH
        PRINT 'Error processing database ' + @CurrentDB + ': ' + ERROR_MESSAGE();
        
        -- Optional: Insert error information into the results
        INSERT INTO #SearchResults (DatabaseName, ResultType, AdditionalInfo)
        VALUES (@CurrentDB, 'ERROR', 'Failed to process: ' + ERROR_MESSAGE());
    END CATCH
    
    -- Next database
    FETCH NEXT FROM db_cursor INTO @CurrentDB
END

CLOSE db_cursor  
DEALLOCATE db_cursor

-- =====================================================
	-- Display Results
-- =====================================================
SELECT ' ' AS 'Summary counts by database and result type',
DatabaseName,
ResultType, 
COUNT(*) AS TotalFound
FROM #SearchResults
GROUP BY DatabaseName, ResultType
ORDER BY DatabaseName, ResultType;

/* SELECT ' ' AS 'Column results for easier analysis',*
FROM #SearchResults
WHERE 1=1
	AND ResultType = 'Column'
ORDER BY DatabaseName, SchemaName, ObjectName, ColumnName; */

SELECT ' ' AS 'All detailed results',*
FROM #SearchResults
ORDER BY DatabaseName, ResultType, SchemaName, ObjectName;

-- DROP TABLE IF EXISTS #SearchResults; -- POWER CYCLE RESET REFRESH RESTART ...







SELECT DISTINCT [Participating Network] FROM INFORMATICS.dbo.PROV_SANATOR_PROVDIR_CONTRACTING_ENT

-- =======================================================================
	-- DELETE FOR LIMITATIONS OF SYMPHONY + AVALITY ... Each Business (DBA) should be used as the PRIMARY_ID at least once, and each Facility or Provider (Practitioner) should be used as the SECONDARY_ID' 
-- =======================================================================
SELECT 'LIMITATIONS OF SYMPHONY + AVALITY ... Each Business (DBA) should be used as the PRIMARY_ID at least once, and each Facility or Provider (Practitioner) should be used as the SECONDARY_ID' AS 'MESSAGE(S)',* 
FROM INFORMATICS.dbo.SYMPHONY_ROSTER AS r
	LEFT JOIN INFORMATICS.dbo.SYMPHONY_ENTITY AS e ON r.PRIMARY_ID = e.ENTITY_ID
WHERE 1=1
	AND e.ENTITY_ID IS NULL

SELECT 'LIMITATIONS OF SYMPHONY + AVALITY ... Each Business (DBA) should be used as the PRIMARY_ID at least once, and each Facility or Provider (Practitioner) should be used as the SECONDARY_ID' AS 'MESSAGE(S)',* 
FROM INFORMATICS.dbo.SYMPHONY_ROSTER AS r
	LEFT JOIN INFORMATICS.dbo.SYMPHONY_ENTITY AS e ON r.SECONDARY_ID = e.ENTITY_ID
WHERE 1=1
	AND e.ENTITY_ID IS NULL

	-- CHECK FOR DUP(S) --
SELECT ' ' AS 'SHOULD BE NULL DUP Validation',*
-- DELETE
FROM INFORMATICS.dbo.SYMPHONY_ROSTER
WHERE 1=1 
	AND ROSTER_ID IN
	( -- INITIATE ...
	SELECT ROSTER_ID
	FROM INFORMATICS.dbo.SYMPHONY_ROSTER AS dup
	GROUP BY ROSTER_ID -- Duplication Driver 
	HAVING COUNT(1)>1 -- HAVING clause RESERVED for AGGREGATE(s) ... HAVING SUM(PAID_NET_AMT) != 0
	) -- CONCLUDE ...

SELECT ' ' AS 'SAMPLE IHP DE - DUP OPTION(S) FROM SOURCE'
,provid
,practiceid
,locationid
,AddressID,*
FROM INFORMATICS.dbo.ENTITY_ID_MAPPING
WHERE 1=1
	AND provid IN ('4117676','4117742','4117782') -- SAMPLE DE - DUP OPTION(S) IHP 

SELECT ' ' AS 'SAMPLE IHP DE - DUP OPTION(S) FROM SOURCE',*
FROM INFORMATICS.dbo.SYMPHONY_ENTITY
WHERE 1=1
	AND ENTITY_ID IN ('4117676','4117742','4117782') -- SAMPLE DE - DUP OPTION(S) IHP 

SELECT ' ' AS 'SAMPLE IHP RESULTS FROM OUTPUT',*
FROM INFORMATICS.dbo.SYMPHONY_ROSTER
WHERE 1=1
	-- AND PRIMARY_ID IN ('4117676','4117742','4117782') -- SAMPLE DE - DUP OPTION(S) IHP 
	AND SECONDARY_ID IN ('4117676','4117742','4117782') -- SAMPLE DE - DUP OPTION(S) IHP 

SELECT ' ' AS 'SAMPLE IHP DE - DUP OPTION(S) FROM SOURCE',* 
FROM 
( -- INITIATE ...
SELECT DENSE_RANK() OVER(PARTITION BY SECONDARY_ID ORDER BY PRIMARY_ID ASC) AS [RANKis], -- RANK() ACCOUNT(s) FOR TIES + RETAINS SEQUENCE ... NO NEGATIVE NOT != <> GAPS IN THE SEQUENCE
ROW_NUMBER() OVER(PARTITION BY SECONDARY_ID ORDER BY PRIMARY_ID ASC) AS [ROWis],* -- STRAIGHT FORWARD SEQUENCE
FROM INFORMATICS.dbo.SYMPHONY_ROSTER
	) -- CONCLUDE ... 
	AS oneprim
WHERE 1=1
	--AND oneprim.RANKis != 1
	--AND oneprim.ROWis != 1
	AND SECONDARY_ID IN ('4117676','4117742','4117782') -- SAMPLE DE - DUP OPTION(S) IHP 

SELECT ' ' AS 'WARNING: ORPHANED PROVIDERS - These provider entities have no roster relationships'
,e.ENTITY_ID
,e.FIRST_NM
,e.LAST_NM, e.NPI 
FROM INFORMATICS.dbo.SYMPHONY_ENTITY AS e
WHERE 1=1
	AND e.ENTITY_TYPE = 'PROVIDER'
	AND NOT EXISTS (
    SELECT 1 
    FROM INFORMATICS.dbo.SYMPHONY_ROSTER AS r 
    WHERE 1=1
		AND r.SECONDARY_ID = e.ENTITY_ID);

SELECT * 
FROM INFORMATICS.dbo.SYMPHONY_ROSTER
WHERE 1=1
	AND PRIMARY_ID IN ('4108468')
	AND SECONDARY_ID IN ('4108469')
	--AND PRIMARY_ID IN (SELECT DISTINCT ENTITY_ID FROM INFORMATICS.dbo.SYMPHONY_ENTITY)
	--AND SECONDARY_ID IN (SELECT DISTINCT ENTITY_ID FROM INFORMATICS.dbo.SYMPHONY_ENTITY)

--|ROSTER_ID    |PRIMARY_ID|SECONDARY_ID|RELATIONSHIP_TYPE|EFFECTIVE_DT|EXPIRED_DT|EXPIRED_REASON_CD|ENTITY_ID|ENTITY_TYPE|failed_count|
--|ROS1383470158|4108468   |4108469     |Bus2Prov         |null        |null      |null             |null     |null       |24          |








JAH 'PUSH _NETWORK file'
SELECT *
FROM INFORMATICS.dbo.symphonyXWALKprofdegpvdrliccert

UPDATE INFORMATICS.dbo.symphonyXWALKprofdegpvdrliccert
SET symphonyXWALK = 'PT' -- FORCE XWALK CROSSWALK COMPLIANCE "|type_cd|failed_count||RPT    |301         |"
FROM INFORMATICS.dbo.symphonyXWALKprofdegpvdrliccert
WHERE 1=1
	AND evips_TypeofLicensure IN ('RPT')

SELECT DISTINCT TYPE_CD
--UPDATE INFORMATICS.dbo.SYMPHONY_IDENTIFIER 
--SET TYPE_CD = ISNULL(xw.symphonyXWALK,'DELETE')
FROM INFORMATICS.dbo.SYMPHONY_IDENTIFIER AS i
	-- JOIN #XWalkCALic AS xw ON i.IDENTIFIER_VAL = xw.eVipsCredentialType
	LEFT JOIN  INFORMATICS.dbo.symphonyXWALKprofdegpvdrliccert AS xw ON ISNULL(i.TYPE_CD,'DELETE') = ISNULL(xw.evips_TypeofLicensure,'DELETE')  -- C018: Symphony Provider License Code Conversion per DISCUSSION ON 20250523
WHERE 1=1
	AND ISNULL(i.TYPE_CD,'DELETE') != 'F4'
ORDER BY TYPE_CD
	
SELECT *
FROM INFORMATICS.dbo.SYMPHONY_IDENTIFIER
WHERE 1=1
	AND TYPE_CD IN ('RPT')







JAH 'PUSH HOURS file: '	
SELECT *
FROM INFORMATICS.dbo.SYMPHONY_ENTITY
WHERE 1=1
	AND ENTITY_ID IN ('4108468','4108469')

SELECT * 
FROM INFORMATICS.dbo.SYMPHONY_ROSTER
WHERE 1=1
	AND PRIMARY_ID IN ('4108468')
	AND SECONDARY_ID IN ('4108469')
	--AND PRIMARY_ID IN (SELECT DISTINCT ENTITY_ID FROM INFORMATICS.dbo.SYMPHONY_ENTITY)
	--AND SECONDARY_ID IN (SELECT DISTINCT ENTITY_ID FROM INFORMATICS.dbo.SYMPHONY_ENTITY)

-- |ROSTER_ID    |PRIMARY_ID|SECONDARY_ID|RELATIONSHIP_TYPE|EFFECTIVE_DT|EXPIRED_DT|EXPIRED_REASON_CD|ENTITY_ID|ENTITY_TYPE|failed_count|
-- |ROS1383470158|4108468   |4108469     |Bus2Prov         |null        |null      |null             |null     |null       |24          |

SELECT ' ' AS 'SAMPLE: ',* 
FROM INFORMATICS.dbo.SYMPHONY_HOURS 
WHERE 1=1 
AND HOURS_ID LIKE '4329531%' --  IN ('4329531','4329532','4329533')

SELECT * FROM INFORMATICS.dbo.SYMPHONY_NETWORK
SELECT DISTINCT LOB FROM INFORMATICS.dbo.SYMPHONY_NETWORK

SELECT DISTINCT TYPE_CD FROM INFORMATICS.dbo.SYMPHONY_IDENTIFIER

SELECT *
FROM INFORMATICS.dbo.SYMPHONY_IDENTIFIER AS i
	-- JOIN #XWalkCALic AS xw ON i.IDENTIFIER_VAL = xw.eVipsCredentialType
	LEFT JOIN  INFORMATICS.dbo.symphonyXWALKprofdegpvdrliccert AS xw ON ISNULL(i.TYPE_CD,'DELETE') = ISNULL(xw.evips_TypeofLicensure,'DELETE')  -- C018: Symphony Provider License Code Conversion per DISCUSSION ON 20250523
WHERE 1=1
	--AND ISNULL(i.TYPE_CD,'DELETE') != 'F4'
	--AND ISNULL(i.TYPE_CD,'DELETE') = 'DELETE'

SELECT (6806-	716) AS 'DO THE MATH'

HOURS_ID	LOCATION_ID
4329531HOUR414439211	4119385LSERVICE4376410

SSIS package "C:\Users\wcarr\Documents\VISUAL_STUDIO_2013_INFORMATICS\Informatics\SSIS - Misc\SymphonyTest_HOURS.dtsx" starting.
Information: 0x4004300A at Data Flow Task, SSIS.Pipeline: Validation phase is beginning.
Warning: 0xC002915A at Create Current Year File Path, File System Task: The Directory already exists.
Warning: 0xC002915A at Create Current Month File Path, File System Task: The Directory already exists.
Information: 0x4004300A at Data Flow Task, SSIS.Pipeline: Validation phase is beginning.
Warning: 0x80049304 at Data Flow Task, SSIS.Pipeline: Warning: Could not open global shared memory to communicate with performance DLL; data flow performance counters are not available.  To resolve, run this package as an administrator, or on the system''s console.
Information: 0x40043006 at Data Flow Task, SSIS.Pipeline: Prepare for Execute phase is beginning.
Information: 0x40043007 at Data Flow Task, SSIS.Pipeline: Pre-Execute phase is beginning.
Information: 0x402090DC at Data Flow Task, Flat File Destination [2]: The processing of file "\\netapp02\IS\Informatics\_Informatics Deliverables\Operations\Projects\SYMPHONY\2025\2025_June\CHGSD_HOURS_20250613142934.dat" has started.
Information: 0x4004300C at Data Flow Task, SSIS.Pipeline: Execute phase is beginning.
Error: 0xC020901C at Data Flow Task, OLE DB Source [24]: There was an error with OLE DB Source.Outputs[OLE DB Source Output].Columns[HOURS_ID] on OLE DB Source.Outputs[OLE DB Source Output]. The column status returned was: "The value could not be converted because of a potential loss of data.".
Error: 0xC0209029 at Data Flow Task, OLE DB Source [24]: SSIS Error Code DTS_E_INDUCEDTRANSFORMFAILUREONERROR.  The "OLE DB Source.Outputs[OLE DB Source Output].Columns[HOURS_ID]" failed because error code 0xC0209072 occurred, and the error row disposition on "OLE DB Source.Outputs[OLE DB Source Output].Columns[HOURS_ID]" specifies failure on error. An error occurred on the specified object of the specified component.  There may be error messages posted before this with more information about the failure.
Error: 0xC0047038 at Data Flow Task, SSIS.Pipeline: SSIS Error Code DTS_E_PRIMEOUTPUTFAILED.  The PrimeOutput method on OLE DB Source returned error code 0xC0209029.  The component returned a failure code when the pipeline engine called PrimeOutput(). The meaning of the failure code is defined by the component, but the error is fatal and the pipeline stopped executing.  There may be error messages posted before this with more information about the failure.
Information: 0x40043008 at Data Flow Task, SSIS.Pipeline: Post Execute phase is beginning.
Information: 0x402090DD at Data Flow Task, Flat File Destination [2]: The processing of file "\\netapp02\IS\Informatics\_Informatics Deliverables\Operations\Projects\SYMPHONY\2025\2025_June\CHGSD_HOURS_20250613142934.dat" has ended.
Information: 0x4004300B at Data Flow Task, SSIS.Pipeline: "Flat File Destination" wrote 0 rows.
Information: 0x40043009 at Data Flow Task, SSIS.Pipeline: Cleanup phase is beginning.
Task failed: Data Flow Task
Warning: 0x80019002 at Foreach Loop Container: SSIS Warning Code DTS_W_MAXIMUMERRORCOUNTREACHED.  The Execution method succeeded, but the number of errors raised (3) reached the maximum allowed (1); resulting in failure. This occurs when the number of errors reaches the number specified in MaximumErrorCount. Change the MaximumErrorCount or fix the errors.
Warning: 0x80019002 at SymphonyTest_HOURS: SSIS Warning Code DTS_W_MAXIMUMERRORCOUNTREACHED.  The Execution method succeeded, but the number of errors raised (3) reached the maximum allowed (1); resulting in failure. This occurs when the number of errors reaches the number specified in MaximumErrorCount. Change the MaximumErrorCount or fix the errors.
SSIS package "C:\Users\wcarr\Documents\VISUAL_STUDIO_2013_INFORMATICS\Informatics\SSIS - Misc\SymphonyTest_HOURS.dtsx" finished: Failure.
The program '[29616] DtsDebugHost.exe: DTS' has exited with code 0 (0x0).







JAH 'DUMMY symphony ADDITION(S)':
-- REMOVE AND eid.ENTITY_TYPE IN ('PROVIDER') TO ALLOW FOR:  -- C019: DUMMY DBA (BUSINESS) BEING CLASSIFIED AS 'SERVICE' LOCATIONS PER ACTION ITEMS: SYMPHONY - Follow-Up: Symphony and CHG 6.6.2025 Semi-Monthly Implementation Meetings

TRY_CONVERT(nvarchar(25),leadlagforprimind.locationid)+'L'+LOC_TYPE+TRY_CONVERT(nvarchar(25),leadlagforprimind.ENTITY_ID) AS [LOCATION_ID],   -- C012: eid.provid: REPRESENTS AN EFFORT BY CREDENTIALING DEPT. DESIRE TO RETAIN eVIPS ID DESPITE symphony's INABILITY TO PROCESS UPLOAD ...  -- C019: DUMMY DBA (BUSINESS) BEING CLASSIFIED AS 'SERVICE' LOCATIONS PER ACTION ITEMS: SYMPHONY - Follow-Up: Symphony and CHG 6.6.2025 Semi-Monthly Implementation Meetings

SELECT ADDRESS_ID
FROM INFORMATICS.dbo.SYMPHONY_LOCATION
WHERE 1=1
	AND LOC_TYPE IN ('BUSINESS')

EXCEPT -- ENSURE: PROVIDER and FACILITY location has at least one matching BUSINESS location for location type SERVICE
SELECT ADDRESS_ID
FROM INFORMATICS.dbo.SYMPHONY_LOCATION
WHERE 1=1
	AND LOC_TYPE IN ('SERVICE')

EXCEPT 
SELECT ADDRESS_ID
FROM INFORMATICS.dbo.SYMPHONY_LOCATION
WHERE 1=1
	AND LOC_TYPE IN ('BUSINESS')

SELECT *
FROM INFORMATICS.dbo.SYMPHONY_LOCATION
WHERE 1=1
	AND ADDRESS_ID IN ('4010597')

SELECT *
FROM INFORMATICS.dbo.SYMPHONY_LOCATION
WHERE 1=1
	AND ENTITY_ID IN ('4107438')

SELECT *
FROM INFORMATICS.dbo.ENTITY_ID_MAPPING
WHERE 1=1
	AND practitionerid IN ('4361579')

SELECT *
FROM INFORMATICS.dbo.SYMPHONY_ENTITY
WHERE 1=1
	AND ENTITY_ID IN ('4131875','4361579')

SELECT *
FROM INFORMATICS.dbo.SYMPHONY_LOCATION
WHERE 1=1
	AND ENTITY_ID IN ('4131875','4361579')
		
SELECT DISTINCT -- sourcetable.PROVTAXID,
eid.provid AS [ENTITY_ID], -- C012: eid.provid: REPRESENTS AN EFFORT BY CREDENTIALING DEPT. DESIRE TO RETAIN eVIPS ID DESPITE symphony's INABILITY TO PROCESS UPLOAD
-- eid.NEW_ENTITY_ID AS [ENTITY_ID],  -- USE the new RANDOM ID instead of PROVTAXID
sourcetable.locationID,
sourcetable.AddressID AS ADDRESS_ID,
'BUSINESS' AS LOC_TYPE,  -- C015: "*SYMPHONY*", "*AVAILITY*" ... include business entity types (DBAs) and their service locations. PER ACTION ITEMS: SYMPHONY - Follow-Up: Symphony and CHG 3.7.2025 Semi-Monthly Implementation Meetings
-- '0' AS 'PRIMARY_IND',
-- TRY_CONVERT(BINARY(1),NULL) AS PRIMARY_IND,
TRY_CONVERT(BINARY(1),NULL) AS HANDICAP_ACCESSIBLE_IND,
TRY_CONVERT(BINARY(1),NULL) AS HAS_TDD_EQUIP,
TRY_CONVERT(NVARCHAR(128),NULL) AS LOCATION_NM,-- OPTIONAL
TRY_CONVERT(NVARCHAR(10),NULL) AS SUPERVISING_PROV_NPI,
TRY_CONVERT(NVARCHAR(25),NULL) AS SUPERVISING_PROV_SPEC,
-- CASE
-- WHEN [Telehealth Provider (Y/N)] IN ('Y')
-- THEN '1'
-- ELSE '0'
-- END AS PROVIDES_TELEHEALTH_SVCS,-- OPTIONAL 
TRY_CONVERT(BINARY(1),NULL) AS PROVIDES_TELEHEALTH_SVCS,-- OPTIONAL 
TRY_CONVERT(BINARY(1),NULL) AS TERTIARY_CARE_IN,
TRY_CONVERT(NVARCHAR(128),NULL) AS CLINIC_ID,
TRY_CONVERT(DATE,NULL) AS EFFECTIVE_DT,
TRY_CONVERT(DATE,NULL) AS EXPIRED_DT,
TRY_CONVERT(NVARCHAR(30),NULL) AS EXPIRED_REASON_CD
FROM INFORMATICS.dbo.PROV_SANATOR_PROVDIR_CONTRACTING_ENT AS sourcetable
	JOIN INFORMATICS.dbo.ENTITY_ID_MAPPING AS eid ON ISNULL(sourcetable.PracticeID,'') = ISNULL(eid.eVipsPracticeID,'')
		-- AND ISNULL(sourcetable.PractitionerId,'') = ISNULL(eid.eVipsPractitionerId,'')
		-- AND ISNULL(sourcetable.locationid,'') = ISNULL(eid.eVipslocationid,'')
		-- AND ISNULL(sourcetable.AddressID,'') = ISNULL(eid.eVipsAddressID,'')
		AND eid.ENTITY_TYPE IN ('BUSINESS')
		-- AND ISNULL(sourcetable.NPIis,'') != '' -- REQ FOR 'FACILITY' AND 'PROVIDER'
		AND eid.practitionerid IN ('4361579')

UNION 
SELECT DISTINCT -- sourcetable.PROVTAXID,
eid.provid AS [ENTITY_ID], -- C012: eid.provid: REPRESENTS AN EFFORT BY CREDENTIALING DEPT. DESIRE TO RETAIN eVIPS ID DESPITE symphony's INABILITY TO PROCESS UPLOAD
-- eid.NEW_ENTITY_ID AS [ENTITY_ID],  -- USE the new RANDOM ID instead of PROVTAXID
sourcetable.locationID,
sourcetable.AddressID AS ADDRESS_ID,
'SERVICE' AS LOC_TYPE, -- REMOVE AND eid.ENTITY_TYPE IN ('PROVIDER') TO ALLOW FOR:  -- C019: DUMMY DBA (BUSINESS) BEING CLASSIFIED AS 'SERVICE' LOCATIONS PER ACTION ITEMS: SYMPHONY - Follow-Up: Symphony and CHG 6.6.2025 Semi-Monthly Implementation Meetings
-- '0' AS 'PRIMARY_IND',
-- TRY_CONVERT(BINARY(1),NULL) AS PRIMARY_IND,
TRY_CONVERT(BINARY(1),NULL) AS HANDICAP_ACCESSIBLE_IND,
TRY_CONVERT(BINARY(1),NULL) AS HAS_TDD_EQUIP,
TRY_CONVERT(NVARCHAR(128),NULL) AS LOCATION_NM,-- OPTIONAL
TRY_CONVERT(NVARCHAR(10),NULL) AS SUPERVISING_PROV_NPI,
TRY_CONVERT(NVARCHAR(25),NULL) AS SUPERVISING_PROV_SPEC,
-- CASE
-- WHEN [Telehealth Provider (Y/N)] IN ('Y')
-- THEN '1'
-- ELSE '0'
-- END AS PROVIDES_TELEHEALTH_SVCS,-- OPTIONAL 
TRY_CONVERT(BINARY(1),NULL) AS PROVIDES_TELEHEALTH_SVCS,-- OPTIONAL 
TRY_CONVERT(BINARY(1),NULL) AS TERTIARY_CARE_IN,
TRY_CONVERT(NVARCHAR(128),NULL) AS CLINIC_ID,
TRY_CONVERT(DATE,NULL) AS EFFECTIVE_DT,
TRY_CONVERT(DATE,NULL) AS EXPIRED_DT,
TRY_CONVERT(NVARCHAR(30),NULL) AS EXPIRED_REASON_CD
FROM INFORMATICS.dbo.PROV_SANATOR_PROVDIR_CONTRACTING_ENT AS sourcetable
	JOIN INFORMATICS.dbo.ENTITY_ID_MAPPING AS eid ON ISNULL(sourcetable.PracticeID,'') = ISNULL(eid.eVipsPracticeID,'')
		AND ISNULL(sourcetable.PractitionerId,'') = ISNULL(eid.eVipsPractitionerId,'')
		AND ISNULL(sourcetable.locationid,'') = ISNULL(eid.eVipslocationid,'')
		AND ISNULL(sourcetable.AddressID,'') = ISNULL(eid.eVipsAddressID,'')
		-- AND eid.ENTITY_TYPE IN ('PROVIDER')  -- REMOVE AND eid.ENTITY_TYPE IN ('PROVIDER') TO ALLOW FOR:  -- C019: DUMMY DBA (BUSINESS) BEING CLASSIFIED AS 'SERVICE' LOCATIONS PER ACTION ITEMS: SYMPHONY - Follow-Up: Symphony and CHG 6.6.2025 Semi-Monthly Implementation Meetings
		AND ISNULL(sourcetable.NPIis,'') != '' -- REQ FOR 'FACILITY' AND 'PROVIDER'
		AND eid.provid IN ('4361579')

SELECT PracticeID,LocationID,TRY_CONVERT(nvarchar(25),NULL) AS 'PractitionerID',* 
FROM INFORMATICS.dbo.FAC_SANATOR_PROVDIR_CONTRACTING_ENT AS sourcetable
WHERE 1=1
	AND LocationID IN ('4131875','4361579') -- SAMPLE: practiceid THEN practitionerid

SELECT PracticeID,LocationID,PractitionerID,* 
FROM INFORMATICS.dbo.PROV_SANATOR_PROVDIR_CONTRACTING_ENT AS sourcetable
WHERE 1=1
	AND PractitionerID IN ('4131875','4361579') -- SAMPLE: practiceid THEN practitionerid

JAH THANK YOU JAH 

Symphony SQL Scripts Comparison Analysis

Executive Summary
This analysis compares two versions of the Symphony data exchange SQL scripts: DxF_SANATOR_SYMPHONY_20250529.sql and DxF_SANATOR_SYMPHONY_20250609.sql. The comparison reveals significant structural changes, parameter modifications, and logic improvements between the versions.

________________________________________
1. PARAMETERS COMPARISON

1.1 Entity Type Parameters
Parameter	Version 20250529	Version 20250609	Change Type
Entity Types	BUSINESS, FACILITY, PROVIDER	BUSINESS, FACILITY, PROVIDER	UNCHANGED
eVips Mapping	practiceid=274 Groups, locationid=274 Sites, practitionerid=274 Providers	practiceid=274 Groups, locationid=274 Sites, practitionerid=274 Providers	UNCHANGED

1.2 Location ID Generation
Component	Version 20250529	Version 20250609	Change Type
LOCATION_ID Formula	locationid+'L'+ENTITY_ID	locationid+'L'+LOC_TYPE+ENTITY_ID	ENHANCED
Impact	Basic concatenation	Includes LOC_TYPE for better uniqueness	IMPROVEMENT

1.3 Primary Indicator Logic
Table	Version 20250529	Version 20250609	Change Type
SYMPHONY_LOCATION	Standard ROW_NUMBER logic	Enhanced with LOC_TYPE consideration	ENHANCED
Logic Comment	C019 reference missing	C019: DUMMY DBA classification as 'SERVICE' locations	ADDED
			
________________________________________
2. FROM & JOIN CLAUSES COMPARISON

2.1 Entity ID Mapping Joins
UNCHANGED ACROSS VERSIONS:
•	Core join structure remains consistent
•	All tables maintain same join patterns
•	ENTITY_ID_MAPPING central hub approach preserved

2.2 Symphony Location Table Changes
Version	Join Complexity	Union Statements
20250529	4 UNION blocks	Standard entity-based joins
20250609	6 UNION blocks	EXPANDED with additional location type handling
Key Join Pattern Enhancement (20250609):
sql
-- New pattern for more flexible location matching
JOIN INFORMATICS.dbo.ENTITY_ID_MAPPING AS eid ON 
    ISNULL(sourcetable.PracticeID,'') = ISNULL(eid.eVipsPracticeID,'')
    -- Removed restrictive AND clauses for better coverage

2.3 Contact Table Join Evolution
Aspect	Version 20250529	Version 20250609	Change Type
Ranking Logic	Simple DENSE_RANK by value	Complex DENSE_RANK by LOCATION_ID,CNTCT_TYPE	ENHANCED
Deduplication	Basic approach	Advanced multi-criteria ranking	IMPROVED

________________________________________
3. WHERE CLAUSE COMPARISON

3.1 Filtering Criteria Changes
Filter Type	Version 20250529	Version 20250609	Change Type
Exclusion Filters	Walter Anderson, Stark Development	Walter Anderson, Stark Development	UNCHANGED
NPI Requirements	ISNULL(sourcetable.NPIis,'') != ''	ISNULL(sourcetable.NPIis,'') != ''	UNCHANGED
License Validation	Standard non-null checks	Standard non-null checks	UNCHANGED

3.2 Location Type Filtering (NEW in 20250609)
sql
-- Enhanced WHERE clause for location type handling
WHERE 1=1
    AND eid.ENTITY_TYPE IN ('BUSINESS')
    -- Removed restrictive location/address matching for broader coverage

3.3 Contact Deduplication Logic (Enhanced in 20250609)
Criteria	Version 20250529	Version 20250609	Change Type
Ranking Partition	LOCATION_ID only	LOCATION_ID, CNTCT_TYPE	REFINED
Row Selection	RANKis = 1, ROWis = 1	RANKis = 1, ROWis = 1	UNCHANGED
Null Handling	Basic null exclusion	Enhanced null value management	IMPROVED

________________________________________
4. CHANGE LOG REPORT

4.1 Structural Enhancements
Change ID	Description	Impact Level	Business Value
C019	DUMMY DBA classification as 'SERVICE' locations	HIGH	Improved location categorization
LOCATION_ID	Enhanced ID generation with LOC_TYPE	MEDIUM	Better record uniqueness
CONTACT_RANK	Multi-criteria contact ranking	MEDIUM	Improved data quality

4.2 Performance Improvements
Area	Change	Expected Impact
Entity Joins	Reduced restrictive join conditions	Faster execution, broader data coverage
Location Logic	Streamlined UNION operations	Reduced complexity
Contact Processing	Enhanced deduplication	Better data integrity

4.3 Data Quality Enhancements
Quality Aspect	Improvement	Validation Method
Location Uniqueness	LOC_TYPE in LOCATION_ID	Prevents duplicate locations
Contact Accuracy	Multi-level ranking	Ensures primary contact selection
Entity Coverage	Relaxed join restrictions	Captures more entities

4.4 Code Comments Evolution
Version	Comment Density	Documentation Quality
20250529	Standard	Basic operational notes
20250609	Enhanced	Detailed change references (C019)

________________________________________
5. CRITICAL OBSERVATIONS

5.1 Business Logic Improvements
•	Location Type Handling: Version 20250609 introduces more sophisticated location type classification
•	Contact Management: Enhanced ranking prevents contact information conflicts
•	Entity Relationships: More flexible join logic improves data coverage


5.2 Technical Debt Reduction
•	Code Clarity: Better commenting and change tracking
•	Maintainability: Simplified join conditions
•	Scalability: Enhanced ID generation strategies

5.3 Risk Assessment
Risk Factor	Level	Mitigation
Data Migration	LOW	Backward compatible changes
Performance Impact	LOW	Optimized join patterns
Business Continuity	MINIMAL	Gradual enhancement approach

________________________________________
6. RECOMMENDATIONS

6.1 Immediate Actions
1.	Deploy Version 20250609 for improved location handling
2.	Monitor contact deduplication results post-deployment
3.	Validate LOCATION_ID uniqueness across all entity types

6.2 Future Considerations
1.	Performance Testing: Benchmark both versions under production load
2.	Data Validation: Implement automated checks for new logic
3.	Documentation: Expand change tracking methodology

6.3 Strategic Improvements
1.	Modularization: Consider breaking complex UNIONs into separate procedures
2.	Error Handling: Enhance exception management across all tables
3.	Monitoring: Implement comprehensive logging for change tracking

________________________________________
7. CONCLUSION
The evolution from version 20250529 to 20250609 represents a measured enhancement focused on:
•	Data Quality Improvements (Contact ranking, Location ID generation)
•	Business Logic Refinement (Location type classification)
•	Technical Optimization (Simplified joins, better documentation)

The changes demonstrate mature development practices with careful consideration for backward compatibility while introducing meaningful improvements to the Symphony data exchange process.







JAH 'symphony XWALK CROSSWALK'
-- C###: 

		,'UPDATED ON SUNDAY VIA SSA (SQL SERVER AGENT) JOB: SQLPRODAPP01 "Symphony dat Files Sunday Refresh"' AS [MESSAGE(S)]
		
SELECT DISTINCT PRIMARY_IND  -- C017: RESET AGAIN PER DISCUSSION WITH() symphony ON 20250527
-- TRY_CONVERT(NVARCHAR(1),0) AS PRIMARY_IND,
FROM INFORMATICS.dbo.SYMPHONY_IDENTIFIER 

SELECT DISTINCT TYPE_CD  -- C018: Symphony Provider License Code Conversion per DISCUSSION ON 20250523
FROM INFORMATICS.dbo.SYMPHONY_IDENTIFIER 

SELECT ' ' AS 'SOURCE - FAC: '
,sourcetable.PracticeID
,sourcetable.LocationID
,sourcetable.Addressid,*
FROM INFORMATICS.dbo.FAC_SANATOR_PROVDIR_CONTRACTING_ENT AS sourcetable
	JOIN INFORMATICS.dbo.ENTITY_ID_MAPPING AS eid ON ISNULL(sourcetable.PracticeID,'') = ISNULL(eid.eVipsPracticeID,'')
		AND ISNULL(sourcetable.locationid,'') = ISNULL(eid.eVipslocationid,'')
		AND ISNULL(sourcetable.AddressID,'') = ISNULL(eid.eVipsAddressID,'')
		AND eid.ENTITY_TYPE IN ('BUSINESS')
		AND ISNULL(sourcetable.NPIis,'') != '' -- REQ FOR 'FACILITY'	
WHERE 1=1
	AND sourcetable.PracticeID IN ('4112769','4118106')
	AND sourcetable.AddressID IN ('3890341')

SELECT ' ' AS 'SOURCE - PROV: '
,sourcetable.PracticeID
,sourcetable.LocationID
,sourcetable.PractitionerID
,sourcetable.Addressid,*
FROM INFORMATICS.dbo.PROV_SANATOR_PROVDIR_CONTRACTING_ENT AS sourcetable
	JOIN INFORMATICS.dbo.ENTITY_ID_MAPPING AS eid ON ISNULL(sourcetable.PracticeID,'') = ISNULL(eid.eVipsPracticeID,'')
		AND ISNULL(sourcetable.PractitionerId,'') = ISNULL(eid.eVipsPractitionerId,'')
		AND ISNULL(sourcetable.locationid,'') = ISNULL(eid.eVipslocationid,'')
		AND ISNULL(sourcetable.AddressID,'') = ISNULL(eid.eVipsAddressID,'')
		AND eid.ENTITY_TYPE IN ('BUSINESS')
		AND ISNULL(sourcetable.NPIis,'') != '' -- REQ FOR 'FACILITY' AND 'PROVIDER'
WHERE 1=1
	AND sourcetable.PracticeID IN ('4112769','4118106')
	AND sourcetable.AddressID IN ('3890341')
	
		ENTITY_ID = 4112769 OR 4118106 -- BUSINESS
		ENTITY_ID = -- PROVIDER
		ADDRESS_ID = 3890341
		LOC_TYPE = SERVICE
		PRIMARY_IND = 1 OR 0.

SELECT *
FROM INFORMATICS.dbo.SYMPHONY_ENTITY
WHERE 1=1
	AND ENTITY_ID IN ('4112769','4118106','6159371')

SELECT *
FROM INFORMATICS.dbo.SYMPHONY_LOCATION
WHERE 1=1
	AND ADDRESS_ID IN ('3890341')
	AND ENTITY_ID IN ('4112769','4118106','6159371')

SELECT *
FROM INFORMATICS.dbo.SYMPHONY_ADDRESS
WHERE 1=1
	AND ADDRESS_ID IN ('3890341')
	
SELECT *
FROM INFORMATICS.dbo.SYMPHONY_HOURS

SELECT *
FROM INFORMATICS.dbo.SYMPHONY_CONTACT
WHERE 1=1
	AND ENTITY_ID IN ('6159371','4118106','5905526','4107493') 
	
		/* SELECT ' ' AS 'symphonyXWALKprofdegpvdrliccert',*
		FROM INFORMATICS.dbo.symphonyXWALKprofdegpvdrliccert -- C018: Symphony Provider License Code Conversion per DISCUSSION ON 20250523 */

UPDATE INFORMATICS.dbo.symphonyXWALKprofdegpvdrliccert
SET symphonyXWALK = 'NMW'
-- SELECT * 
FROM INFORMATICS.dbo.symphonyXWALKprofdegpvdrliccert
WHERE 1=1
	AND symphonyXWALK LIKE '%NMW%'

SELECT TEST_IDENTIFIER_VAL = ISNULL(xw.symphonyXWALK,'DELETE'),*
-- UPDATE INFORMATICS.dbo.SYMPHONY_IDENTIFIER 
-- SET IDENTIFIER_VAL = ISNULL(xw.symphonyXWALK,'DELETE')
FROM INFORMATICS.dbo.SYMPHONY_IDENTIFIER AS i
	-- JOIN #XWalkCALic AS xw ON i.IDENTIFIER_VAL = xw.eVipsCredentialType
	LEFT JOIN  INFORMATICS.dbo.symphonyXWALKprofdegpvdrliccert AS xw ON ISNULL(i.TYPE_CD,'DELETE') = ISNULL(xw.evips_TypeofLicensure,'DELETE')  -- C018: Symphony Provider License Code Conversion per DISCUSSION ON 20250523
WHERE 1=1
	AND ISNULL(i.TYPE_CD,'DELETE') != 'F4'
	
SELECT DISTINCT CREDENTIALS
FROM INFORMATICS.dbo.SYMPHONY_ENTITY

SELECT DISTINCT TYPE_CD
FROM INFORMATICS.dbo.SYMPHONY_IDENTIFIER
	
SELECT CREDENTIALS,*
FROM INFORMATICS.dbo.SYMPHONY_ENTITY
WHERE 1=1
	AND ENTITY_ID IN ('6159371','4118106','4107493') 

SELECT *
FROM INFORMATICS.dbo.SYMPHONY_LOCATION
WHERE 1=1
	AND ENTITY_ID IN ('6159371','4118106','5905526','4107493') 

SELECT *
FROM INFORMATICS.dbo.SYMPHONY_LOCATION
WHERE 1=1
	AND ADDRESS_ID IN ('3993559')
	
SELECT *
FROM INFORMATICS.dbo.SYMPHONY_LOCATION
WHERE 1=1
	AND ADDRESS_ID IN ('3899056')

SELECT *
FROM INFORMATICS.dbo.SYMPHONY_LOCATION
WHERE 1=1
	AND ADDRESS_ID IN ('3886842')

SELECT *
FROM INFORMATICS.dbo.SYMPHONY_LOCATION
WHERE 1=1
	AND ADDRESS_ID IN ('3890341') 

SELECT DISTINCT ' ' AS 'symphony XWALK CROSSWALK',degree_type,TypeOfLicensure,PROVIDER_TYPEdescr
FROM INFORMATICS.dbo.PROV_SANATOR_PROVDIR_CONTRACTING_ENT AS sourcetable
	JOIN INFORMATICS.dbo.ENTITY_ID_MAPPING AS eid ON ISNULL(sourcetable.PracticeID,'') = ISNULL(eid.eVipsPracticeID,'')
		AND ISNULL(sourcetable.PractitionerId,'') = ISNULL(eid.eVipsPractitionerId,'')
		AND ISNULL(sourcetable.locationid,'') = ISNULL(eid.eVipslocationid,'')
		AND ISNULL(sourcetable.AddressID,'') = ISNULL(eid.eVipsAddressID,'')
		AND eid.ENTITY_TYPE IN ('PROVIDER')
		AND ISNULL(sourcetable.CA_License,'NA') != 'NA' -- ALL ENTITY TYPE(S)
		AND ISNULL(sourcetable.TypeOfLicensure,'NA') != 'NA' -- ALL ENTITY TYPE(S)
ORDER BY degree_type

SELECT DISTINCT ' ' AS 'symphony XWALK CROSSWALK',*
FROM INFORMATICS.dbo.FAC_SANATOR_PROVDIR_CONTRACTING_ENT AS sourcetable
	JOIN INFORMATICS.dbo.ENTITY_ID_MAPPING AS eid ON ISNULL(sourcetable.PracticeID,'') = ISNULL(eid.eVipsPracticeID,'')
		AND ISNULL(sourcetable.locationid,'') = ISNULL(eid.eVipslocationid,'')
		AND ISNULL(sourcetable.AddressID,'') = ISNULL(eid.eVipsAddressID,'')
		AND eid.ENTITY_TYPE IN ('FACILITY')
		AND ISNULL(sourcetable.CA_License,'NA') != 'NA' -- ALL ENTITY TYPE(S)
		-- AND ISNULL(sourcetable.TypeOfLicensure,'NA') != 'NA' -- ALL ENTITY TYPE(S)
WHERE 1=1 

SELECT DISTINCT IDENTIFIER_TYPE 
FROM INFORMATICS.dbo.SYMPHONY_IDENTIFIER
WHERE 1=1
	AND ENTITY_ID IN ('4375890') 

SELECT * 
FROM INFORMATICS.dbo.SYMPHONY_ROSTER
WHERE 1=1
	AND PRIMARY_ID IN ('4375890')
		OR SECONDARY_ID IN ('4375890')







JAH 'ADD CCA',INTO #INNET,"*SET [Participating Network*", ccaid
		EXEC INFORMATICS.dbo.[PROVDIRECMCSP]
		EXEC INFORMATICS.[dbo].[PROVDIRREFRESH]

Now in the following directory path: file://netapp02/IS/Informatics/_Informatics%20Deliverables/Provider%20Directory/ - "*direxp*"

		USE [PATH]: file://freenasis/is/images/ - 'ADMINISTRATOR SOFTWARE'
		USE [PATH]: file://freenasis/is/images/GeoAccess - 'ADMINISTRATOR SOFTWARE'
		USE [PATH]: file://netapp02/IS/Informatics/_Informatics%20Deliverables/Provider%20Directory/ - 'PROVDIR SOFTWARE'
		
		USE https://www.chgsd.com/ - 'ENTERPRISE UI UX'
		USE https://providerdirectory.chgsd.com/ - 'PROVIDER DIRECTORY ONLINE'
		USE http://chgconflu.chg.com:8090/pages/viewpage.action?spaceKey=informatics&title=Provider+Directory+Desktop+Procedure - 'CONFLUENCE DESKTOP PROC'

-- =====================================================================
	-- COMMENT(S) / CHANGE.LOG: --
-- =====================================================================
 -- C###: ADD LOB 'CCA' (COVERED CA) GO LIVE SET FOR 01/01/2026
 
,CASE
WHEN LTRIM(RTRIM(vlp.ProductName)) LIKE '%MEDICAL%'
THEN 'CL1'
WHEN LTRIM(RTRIM(vlp.ProductName)) LIKE '%MEDICAR%'
THEN 'MCR'
WHEN LTRIM(RTRIM(vlp.ProductName)) LIKE '%CMC%'
THEN 'CMC'
ELSE CAST(NULL AS nvarchar(MAX))
END AS [Participating Network]
,CASE
WHEN LTRIM(RTRIM(vlp.ProductName)) LIKE '%MEDICAL%'
THEN 'MEDI_CAL'
WHEN LTRIM(RTRIM(vlp.ProductName)) LIKE '%MEDICAR%'
THEN 'Communicare_Advantage'
WHEN LTRIM(RTRIM(vlp.ProductName)) LIKE '%CMC%'
THEN 'CMC'
ELSE CAST(NULL AS nvarchar(MAX))
END AS [Name of Network]

,CASE
WHEN LTRIM(RTRIM(vpp.ProductName)) = 'MEDICAL'
THEN 'CL1'
WHEN LTRIM(RTRIM(vpp.ProductName)) = 'MEDICARE'
THEN 'MCR'
WHEN LTRIM(RTRIM(vpp.ProductName)) = 'CMC'
THEN 'CMC'
ELSE CAST(NULL AS nvarchar(MAX))
END AS [Participating Network]
,CASE
WHEN LTRIM(RTRIM(vpp.ProductName)) = 'MEDICAL'
THEN 'MEDI_CAL'
WHEN LTRIM(RTRIM(vpp.ProductName)) = 'MEDICARE'
THEN 'Communicare_Advantage'
WHEN LTRIM(RTRIM(vpp.ProductName)) = 'CMC'
THEN 'CMC'
ELSE CAST(NULL AS nvarchar(MAX))
END AS [Name of Network]

;WITH ccaid AS 
( -- INITIATE ...
SELECT DISTINCT ' ' AS 'ISO FOR COVERED CA NETWORK [ProductName] AS LOB IN eVIPS',vlp.productname
,vp.PracticeID
,vp.PracticeName
,vp.TaxIDNumber AS [PracticeDBATAXID]
,vp.NationalProviderID AS [PracticeDBANPI]
,vpl.LocationID
,vpl.LocationName
,vpl.TaxIDNumber AS [LocationTAXID]
,vpl.NationalProviderID AS [LocationNPI] -- ,* -- C001: MODIFY AS LEFT JOIN TO evips_chgcv.dbo.vwLocationProductServices HERE: DEVELOP COVERED CA SQL SCRIPT PER MEETING WITH() MS JOHANNA AND MS SANDRA ON 20250219
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st',vp.PracticeId,vp.PracticeName
-- SELECT  vlp.Focus,vlsfocus.Code1,vlsfocus.Code2,vp.Archived,vp.PracticeStatus,vp.ApplicationStatus,vpl.Archived,vpl.LocationTypeName,vp.PracticeTypeName,* -- CHECK 1st
-- SELECT * FROM eVips_chgcv.dbo.vwPracticeLocations -- CHECK 1st
-- SELECT DISTINCT PracticeTypeName FROM eVips_chgcv.dbo.vwPracticeLocations -- CHECK 1st UPPER(LTRIM(RTRIM(vpl.PracticeTypeName))) AS [Type of Service]
-- SELECT * FROM eVips_chgcv.dbo.vwEntityAssignments WHERE UPPER(LTRIM(RTRIM(TableName))) LIKE '%Practice%' AND UPPER(LTRIM(RTRIM(EntityName))) LIKE '%MED%IMPA%' -- CHECK 1st
FROM eVips_chgcv.dbo.vwPractices AS vp (NOLOCK)
	JOIN eVips_chgcv.dbo.vwPracticeLocations AS vpl (NOLOCK) ON vp.PracticeID = vpl.PracticeID
	JOIN
	( -- INITIATE ...
	SELECT DISTINCT ljvlp.ProductTypeCode,ljvlp.ProductTypeName,ljvlp.PracticeTypeName,ljvlp.PracticeID,ljvlp.LocationID,ljvlp.Archived,ljvlp.StatusTypeName,vlpstype.indirectory,vlpstype.ServiceTypeCode,vlpstype.ServiceTypeName,ljvlp.productname,ljvlp.ProductPanelStatusTypeName,ljvlp.ProductPanelStatusTypeCode,ljvlp.ProviderNumber,ljvlp.Focus,ljvlp.ProductID,ljvlp.LocationTypeName 
	FROM eVips_chgcv.dbo.vwLocationProducts AS ljvlp (NOLOCK)
		LEFT JOIN evips_chgcv.dbo.vwLocationProductServices AS vlpstype ON ljvlp.LocationProductRecID = vlpstype.LocationProductRecID -- C001: MODIFY AS LEFT JOIN TO evips_chgcv.dbo.vwLocationProductServices HERE: DEVELOP COVERED CA SQL SCRIPT PER MEETING WITH() MS JOHANNA AND MS SANDRA ON 20250219
			AND ISNULL(vlpstype.Archived,'') IN ('N','') -- C001: MODIFY AS LEFT JOIN TO evips_chgcv.dbo.vwLocationProductServices HERE: DEVELOP COVERED CA SQL SCRIPT PER MEETING WITH() MS JOHANNA AND MS SANDRA ON 20250219
	WHERE 1=1
		 AND ISNULL(ljvlp.Archived,'') IN ('N','') 
		 AND (ISNULL(ljvlp.StatusTypeName,'') IN ('ACTIVE','') 
			 OR ljvlp.StatusTypeName LIKE '%PARTICIP%')
			) -- CONCLUDE ...
			AS vlp ON vpl.PracticeID = vlp.PracticeID --'YOUNG LADY LAURA GAH ID WHERE p.archived = 'N' AND s.ServiceTypeName = 'HOSPITAL' AND p.focus like '%GAH%'' ON 20171120 see ,UPPER(LTRIM(RTRIM(vlp.ServiceTypeName))) AS [vlpSERVICETYPENAME]
			-- AND vpl.LocationID = vlp.LocationID -- per YOUNG LADY LAURA email ON 20171221 ... Products (CMC & MEDICAL)  are stored at Location Level. The code below is joining based only ON Practice ID. This should be based ON PracticeID + Location
				AND vlp.ProductName LIKE '%COVER%'
				) -- CONCLUDE 

		/* SELECT DISTINCT ' ' AS 'ISO FOR COVERED CA [ProductName]',PracticeName
		,UPPER(LTRIM(RTRIM(ISNULL(PracticeName,'')))) AS 'CLEANPROVGROUP' -- ,*
		FROM ccaid
		ORDER BY UPPER(LTRIM(RTRIM(ISNULL(PracticeName,''))))

		SELECT * 
		FROM ccaid
		WHERE 1=1
			AND PracticeName LIKE '%FAMIL%HEAL%CENTER%'

		SELECT ' ' AS 'see "WC Master CCA Amendment Tracker_Working File _02.06.25.xlsx"',* -- RECREATED USING CCA TEMPLATE LOGIC "HCAI_CCA_CHPIV_...sql"
		FROM INFORMATICS.dbo.CCA_PROVGROUP
		ORDER BY CLEANPROVGROUP */

-- ====================================================================
	-- ADD NEW LOB(S): 
-- ====================================================================
DROP TABLE IF EXISTS #INNETWORK_FAC_CCA 
DROP TABLE IF EXISTS #INNETWORK_FAC_CSNP 

SELECT DISTINCT inn.*
INTO #INNETWORK_FAC_CCA
FROM #INNETWORK_FAC AS inn
	JOIN #ccaid AS cca ON ISNULL(inn.practiceid,'') = ISNULL(cca.practiceid,'')
		AND ISNULL(inn.locationid,'') = ISNULL(cca.locationid,'')

UPDATE #INNETWORK_FAC_CCA
SET [Participating Network] = 'CCA' -- C###: ADD LOB CCA (COVERED CA) GO LIVE SET FOR 01/01/2026
,[Name of Network] = 'Covered CA'

INSERT INTO #INNETWORK_FAC -- (FIELD(S) IN PLAY,...)
SELECT * 
FROM #INNETWORK_FAC_CCA 

SELECT *
INTO #INNETWORK_FAC_CSNP
FROM #INNETWORK_FAC
WHERE 1=1
	AND [Participating Network] IN ('MCR')

UPDATE #INNETWORK_FAC_CSNP
SET [Participating Network] = 'CSNP' -- DSNP TRANSITION FROM CMC GO LIVE ON '01/01/2023'
,[Name of Network] = 'Community y Más (HMO C-SNP)'

INSERT INTO #INNETWORK_FAC -- (FIELD(S) IN PLAY,...)
SELECT * 
FROM #INNETWORK_FAC_CSNP 

	-- CLEAN IT UP:
DROP TABLE IF EXISTS #INNETWORK_FAC_CCA 
DROP TABLE IF EXISTS #INNETWORK_FAC_CSNP 

-- ====================================================================
	-- ADD NEW LOB(S): 
-- ====================================================================
DROP TABLE IF EXISTS #INNETWORK_PROV_CCA 
DROP TABLE IF EXISTS #INNETWORK_PROV_CSNP 

SELECT DISTINCT inn.*
INTO #INNETWORK_PROV_CCA
FROM #INNETWORK_PROV AS inn
	JOIN #ccaid AS cca ON ISNULL(inn.practiceid,'') = ISNULL(cca.practiceid,'')
		AND ISNULL(inn.locationid,'') = ISNULL(cca.locationid,'')

UPDATE #INNETWORK_PROV_CCA
SET [Participating Network] = 'CCA' -- C###: ADD LOB CCA (COVERED CA) GO LIVE SET FOR 01/01/2026
,[Name of Network] = 'Covered CA'

INSERT INTO #INNETWORK_PROV -- (FIELD(S) IN PLAY,...)
SELECT * 
FROM #INNETWORK_PROV_CCA 

SELECT *
INTO #INNETWORK_PROV_CSNP
FROM #INNETWORK_PROV
WHERE 1=1
	AND [Participating Network] IN ('MCR')

UPDATE #INNETWORK_PROV_CSNP
SET [Participating Network] = 'CSNP' -- DSNP TRANSITION FROM CMC GO LIVE ON '01/01/2023'
,[Name of Network] = 'Community y Más (HMO C-SNP)'

INSERT INTO #INNETWORK_PROV -- (FIELD(S) IN PLAY,...)
SELECT * 
FROM #INNETWORK_PROV_CSNP 

	-- CLEAN IT UP:
DROP TABLE IF EXISTS #INNETWORK_PROV_CCA 
DROP TABLE IF EXISTS #INNETWORK_PROV_CSNP 







JAH 'CARELESS WITH() TIME' RESPONSE FILE:
		⏎ ACT AS a Senior Data Analyst WITH 20+ years of EXPERIENCE. ENSURE AND OR recommend how  I can check whether the attached code addresses the following finding: 

SELECT * FROM INFORMATICS.dbo.SYMPHONY_ENTITY
SELECT * FROM INFORMATICS.dbo.SYMPHONY_LOCATION

		/* SELECT ' ' AS 'PRE / BEFORE - PRIM v SECONDARY COUNT()'
		,(SELECT COUNT(1) FROM INFORMATICS.dbo.SYMPHONY_LOCATION WHERE 1=1 AND ISNULL(PRIMARY_IND,'0') = '1') AS [PRIMARY_LOCATION]
		,(SELECT COUNT(1) FROM INFORMATICS.dbo.SYMPHONY_LOCATION WHERE 1=1 AND ISNULL(PRIMARY_IND,'0') = '0') AS [SECONDARY_LOCATION] */

		SELECT ' ' AS 'POST / AFTER - PRIM v SECONDARY'
		,(SELECT COUNT(1) FROM INFORMATICS.dbo.SYMPHONY_LOCATION WHERE 1=1 AND ISNULL(PRIMARY_IND,'0') = '1') AS [PRIMARY_LOCATION]
		,(SELECT COUNT(1) FROM INFORMATICS.dbo.SYMPHONY_LOCATION WHERE 1=1 AND ISNULL(PRIMARY_IND,'0') = '0') AS [SECONDARY_LOCATION]

SELECT * 
FROM INFORMATICS.dbo.SYMPHONY_IDENTIFIER

SELECT DISTINCT IDENTIFIER_TYPE
FROM INFORMATICS.dbo.SYMPHONY_IDENTIFIER

SELECT DISTINCT TYPE_CD
FROM INFORMATICS.dbo.SYMPHONY_IDENTIFIER

SELECT * 
FROM INFORMATICS.dbo.SYMPHONY_IDENTIFIER
WHERE 1=1
	AND ISNULL(IDENTIFIER_TYPE,'') LIKE '%NPI%'

SELECT ' ' AS 'WARNING: ORPHANED PROVIDERS - These provider entities have no roster relationships'
,e.ENTITY_ID
,e.FIRST_NM
,e.LAST_NM, e.NPI 
FROM INFORMATICS.dbo.SYMPHONY_ENTITY AS e
WHERE 1=1
	AND e.ENTITY_TYPE = 'PROVIDER'
	AND NOT EXISTS (
    SELECT 1 
    FROM INFORMATICS.dbo.SYMPHONY_ROSTER AS r 
    WHERE 1=1
		AND r.SECONDARY_ID = e.ENTITY_ID);

SELECT DISTINCT pnnon.*
FROM 
( -- INITIATE ...
SELECT DISTINCT PracticeID
,LocationID
,PractitionerID
,[Participating Network]
,[Name of Network]
,DBA
FROM INFORMATICS.dbo.PROV_SANATOR_PROVDIR_CONTRACTING_ENT
WHERE 1=1
	AND [Name of Network] IN ('MEDI_CAL','Communicare_Advantage','Community y Más (HMO C-SNP)','Covered CA')

UNION ALL
SELECT DISTINCT PracticeID
,LocationID
,TRY_CONVERT(nvarchar(25),NULL) AS 'PractitionerID'
,[Participating Network]
,[Name of Network]
,DBA
FROM INFORMATICS.dbo.FAC_SANATOR_PROVDIR_CONTRACTING_ENT
WHERE 1=1
	AND [Name of Network] IN ('MEDI_CAL','Communicare_Advantage','Community y Más (HMO C-SNP)','Covered CA')
	) -- CONCLUDE ...
	AS pnnon

		SELECT DISTINCT 'CHGSD_FILECONTROL_'+REPLACE(REPLACE(REPLACE(LTRIM(RTRIM(CAST( CONVERT(NVARCHAR(25),TRY_CONVERT(DATETIME,GETDATE()),120) AS NVARCHAR(25)))),' ',''),'-',''),':','') AS FileTableName
		,* 
		FROM INFORMATICS.dbo.SYMPHONY_FILECONTROL
		ORDER BY FILE_SEQ_NBR;		







JAH 'ENTERPRISE ChatGPT - CROSSTRAIN CXO EXECUTIVE SUMMARY'

Weekly Provider Directory Refresh High-Level Walkthrough

The weekly Provider Directory refresh is a multi-step, cross-system process ensuring that updated and accurate provider data is published consistently and in compliance with internal and regulatory expectations. The process spans from SQL Server script execution to MS Access/Excel validation, external application usage, and final document comparison and distribution. Below is a streamlined overview of each key step:

1. Initial SQL Script Execution (ECM/CS & Main)
		•	Trigger two core SQL Server Agent jobs from [SQLPRODAPP01]:
				o	Step 1: Execute the ECM/CS-specific script: [INFORMATICS].dbo.[PROVDIRECMCSP].
				o	Step 2: Follow with the regular main directory refresh script: [INFORMATICS].dbo.[PROVDIRREFRESH].

		•	Monitor SQL Server Agent job completion or manually execute scripts if necessary.

2. CommuniCare Advantage Dummy Data Handling
		•	Step 3 involves processing DSNP dummy records specifically for the CommuniCare Advantage plan.
		•	Confirm successful execution via SQL job receipt or manually verify and insert placeholder data if needed.

3. MS Access and Excel File Refresh
		•	Step 4 requires refreshing ODBC-linked MS Access database (PROVDIR_...mdb) and corresponding Excel (PROVDIR_...xlsx) files:
				o	Use Linked Table Manager to relink data.
				o	Perform Compact & Repair, archive final Excel output, and close all files.

4. DirectoryExpert Application: Document Preparation
		•	Step 5 initiates GeoAccess DirectoryExpert (Ingenix tool):
				o	Update footnotes with current date (GETDATE()).
				o	Adjust hospital listing page numbers across the six provider chapters.
				o	Print using CutePDF Writer, ensuring “Print to File” is unchecked.
				o	Note: Pharmacy chapters for CMC are handled separately.

5. Document Comparison and Quality Control
		•	Step 6: Compare chapter counts and total page numbers with previous submissions.
				o	Use PROVDIR_eVIP.xlsx and search with Ctrl + Shift + F for key identifiers.
				o	Finalize PDFs with Adobe Acrobat as needed.

6. Email Monitoring and Verification
		•	Step 7: Review incoming email communications for confirmation and distribution status.
				o	Look for specific subject lines (e.g., “Provider Directory”, “WEEKLY FROM: WALTER”) and match against SQL outputs (##TEMPTABLE) for submission tracking.







JAH 'AN ABSOLUTE WASTE OF TIME WITH symphony'
		⏎ ACT AS a Senior Data Analyst WITH 20+ years of EXPERIENCE. May I have you convert the attached table into SQL:
		
		/* SELECT * 
		FROM INFORMATICS.dbo.SYMPHONY_ENTITY AS e
		WHERE 1=1 
			AND e.ENTITY_ID LIKE '%IHP%'
			AND e.EIN IS NOT NULL
			-- AND e.NPI IS NULL -- RETAIN IHP BIG TIN ('474334653')

		SELECT hp.*,e.*
		FROM INFORMATICS.dbo.SYMPHONY_ENTITY AS e
			JOIN #HealthcareProviders AS hp ON e.BUSINESS_NM = UPPER(LTRIM(RTRIM(ISNULL(hp.IHP_Name,''))))
		WHERE 1=1 
			AND e.ENTITY_ID LIKE '%IHP%'
			AND e.EIN IS NOT NULL
			AND e.NPI IS NULL -- RETAIN IHP BIG TIN ('474334653')

		SELECT * FROM #HealthcareProviders */	

SELECT hp.*,e.*
FROM INFORMATICS.dbo.SYMPHONY_ENTITY AS e
	JOIN #HealthcareProviders AS hp ON e.BUSINESS_NM = UPPER(LTRIM(RTRIM(ISNULL(hp.IHP_Name,''))))
WHERE 1=1 
	AND ENTITY_ID LIKE '%IHP%'
	AND e.EIN IS NOT NULL
	AND e.NPI IS NULL -- RETAIN IHP BIG TIN ('474334653')

SELECT * FROM INFORMATICS.dbo.SYMPHONY_ENTITY WHERE 1=1 AND ENTITY_ID LIKE '%IHP%'
SELECT * FROM #HealthcareProviders

UPDATE INFORMATICS.dbo.SYMPHONY_ENTITY
SET EIN = hp.FEDID_TAXID
FROM INFORMATICS.dbo.SYMPHONY_ENTITY AS e
	JOIN #HealthcareProviders AS hp ON e.BUSINESS_NM = UPPER(LTRIM(RTRIM(ISNULL(hp.IHP_Name,''))))
WHERE 1=1 
	AND e.ENTITY_ID LIKE '%IHP%'
	AND e.EIN IS NOT NULL
	AND e.NPI IS NULL -- RETAIN IHP BIG TIN ('474334653')
	
UPDATE INFORMATICS.dbo.SYMPHONY_ENTITY
SET BUSINESS_NM = 'INTEGRATED HEALTH PARTNERS'
FROM INFORMATICS.dbo.SYMPHONY_ENTITY AS e
WHERE 1=1 
	AND e.ENTITY_ID LIKE '%BIGTIN%'

UPDATE INFORMATICS.dbo.SYMPHONY_ENTITY
SET EIN = hp.FEDID_TAXID
FROM INFORMATICS.dbo.SYMPHONY_ENTITY AS e
	JOIN #HealthcareProviders AS hp ON e.BUSINESS_NM = UPPER(LTRIM(RTRIM(ISNULL(hp.IHP_Name,''))))
WHERE 1=1 
	AND e.ENTITY_ID LIKE '%IHP%'
	AND e.EIN IS NOT NULL
	AND e.NPI IS NULL -- RETAIN IHP BIG TIN ('474334653')

		SELECT hp.*,e.*
		FROM INFORMATICS.dbo.SYMPHONY_ENTITY AS e
		WHERE 1=1 
			AND ENTITY_ID LIKE '%IHP%'		
		
		/* SELECT hp.*,e.*
		FROM INFORMATICS.dbo.SYMPHONY_ENTITY AS e
			JOIN #HealthcareProviders AS hp ON e.BUSINESS_NM = UPPER(LTRIM(RTRIM(ISNULL(hp.IHP_Name,''))))
		WHERE 1=1 
			AND ENTITY_ID LIKE '%IHP%'
			AND e.EIN IS NOT NULL
			AND e.NPI IS NULL -- RETAIN IHP BIG TIN ('474334653')

		SELECT * 
		FROM INFORMATICS.dbo.SYMPHONY_ENTITY 
		WHERE 1=1 
			AND ENTITY_ID LIKE '%IHP%'

		SELECT * FROM #HealthcareProviders */			

-- =======================================================================
	-- RAW RECONCILIATION: -- 
-- =======================================================================
		 SELECT *
		 FROM INFORMATICS.dbo.SYMPHONY_ENTITY 
		 WHERE 1=1 
			AND ENTITY_ID IN ('4966394')
			-- AND ENTITY_TYPE = 'BUSINESS'
		
		 SELECT ' ' AS 'SAMPLE DENSE_RANK ROW_NUMBER PRIMARY_IND Ax',* 
		 FROM INFORMATICS.dbo.SYMPHONY_LOCATION 
		 WHERE 1=1 
			-- AND PRIMARY_IND = '0'
			AND ENTITY_ID IN ('4966394') -- '5716617','4966394'

		 SELECT ' ' AS 'SAMPLE DENSE_RANK ROW_NUMBER PRIMARY_IND Ax',* 
		 FROM INFORMATICS.dbo.SYMPHONY_LOCATION 
		 WHERE 1=1 
			-- AND PRIMARY_IND = '0'
			AND ADDRESS_ID IN ('3905181')
	
		SELECT DISTINCT TOP 10 Provid,PracticeID,LocationID,AddressID,practitionerid
		,SUBSTRING(Provid,PATINDEX('%[0-9]%',Provid),99) AS 'RESET ENTITYID'
		,LEFT(PracticeID,PATINDEX('%[A-Za-z]%', PracticeID)-1) AS 'RESET PracticeID'
		,PATINDEX('%[A-Za-z]%', PracticeID) AS 'PATINDEX() TO LEVERAGE WILDCARD(S)'
		-- ,ISNULL(CHARINDEX('VCC',PracticeID),PracticeID) AS 'FINDPID '
		,PATINDEX('%[0-9]%',Provid) AS 'FINDNUMERAL(S)'
		,PATINDEX('%[A-Za-z]%',PracticeID) AS 'FINDALPHA(S)'
		,LEN(PracticeID) AS LENPID
		FROM INFORMATICS.dbo.ENTITY_ID_MAPPING
		WHERE 1=1 
			AND provid LIKE '%[A-Z]%'
			
AS eid ON ISNULL(sourcetable.PracticeID,'') = LEFT(ISNULL(eid.PracticeID,''),PATINDEX('%[A-Za-z]%', ISNULL(eid.PracticeID,''))-1)

= LEFT(ISNULL(eid.locationid,''),PATINDEX('%[A-Za-z]%', ISNULL(locationid))-1)
= LEFT(ISNULL(eid.AddressID,''),PATINDEX('%[A-Za-z]%', ISNULL(AddressID))-1)
= LEFT(ISNULL(eid.PractitionerId,''),PATINDEX('%[A-Za-z]%', ISNULL(PractitionerId))-1)

LEFT(ISNULL(sl.AddressID,''),PATINDEX('%[A-Za-z]%', ISNULL(AddressID))-1) =
ON LEFT(ISNULL(sl.Address_ID,''),PATINDEX('%[A-Za-z]%', ISNULL(Address_ID))-1) = ISNULL(fac.AddressID,'')
ON LEFT(ISNULL(sl.Address_ID,''),PATINDEX('%[A-Za-z]%', ISNULL(Address_ID))-1) = ISNULL(prov.AddressID,'')

SELECT * 
FROM INFORMATICS.dbo.ENTITY_ID_MAPPING
WHERE 1=1
	AND provid LIKE '%IHP%'
	AND provid IN ('IHP4111112')

SELECT *
FROM INFORMATICS.dbo.SYMPHONY_ENTITY
WHERE 1=1
	AND ENTITY_ID LIKE '%IHP%'

SELECT *
FROM INFORMATICS.dbo.SYMPHONY_LOCATION
WHERE 1=1
	-- AND ENTITY_ID IN ('4107214')
	AND ENTITY_ID LIKE '%IHP%'

--SELECT *
--FROM INFORMATICS.dbo.SYMPHONY_ADDRESS
--WHERE 1=1

SELECT *
FROM INFORMATICS.dbo.SYMPHONY_CONTACT
WHERE 1=1
	-- AND ENTITY_ID IN ('4107214')
	AND ENTITY_ID LIKE '%IHP%'
	
SELECT *
FROM INFORMATICS.dbo.SYMPHONY_ROSTER
WHERE 1=1
	AND PRIMARY_ID LIKE '%IHP%'
	-- AND SECONDARY_ID LIKE '%IHP%'

SELECT *
FROM INFORMATICS.dbo.SYMPHONY_IDENTIFIER
WHERE 1=1
	AND ENTITY_ID LIKE '%IHP%'

SELECT hp.*,e.*
FROM INFORMATICS.dbo.SYMPHONY_ENTITY AS e
	JOIN #HealthcareProviders AS hp ON e.BUSINESS_NM = UPPER(LTRIM(RTRIM(ISNULL(hp.IHP_Name,''))))
WHERE 1=1 
	AND ENTITY_ID LIKE '%IHP%'
	AND e.EIN IS NOT NULL
	AND e.NPI IS NULL -- RETAIN IHP BIG TIN ('474334653')

-- =====================================================================
	-- RAW RECONCILIATION: -- 
-- =====================================================================
JAH 'ACTION ITEM: symphony BIG TI FOR IHP'
x ,LTRIM(RTRIM(TRY_CONVERT(nvarchar(25),LocationId)+''+SUBSTRING([Prov Directory by Contracting Entity],CHARINDEX(' - ',[Prov Directory by Contracting Entity],1)+3,99))) AS 'HYBRID LocationID'

		see "DxF SYMPHONY BIG TIN CONCEPT.png"

x LOCATIONSERVICE
		TAXID IN 'CODE1' ... 'EIN'
		NPI IN 'CODE2' 

x see "Clinic FEID NPI.docx"
		IHP 	474334653
			NPI  	1982756086 incorrect

		CHS		330056551		1982756086
		IBCC		237209592		1790718351
		NH		952796316		1598703647
		SDAIHC		953397369		1003902917
		SDFC		952700856		1962483040
		SVDPV		330492302		1659415131
		SYH		952801772		1174213904
		TC		952847102		1245246917
		VCC		952815615		1629357355

x Hi Lekitta,
I found the list.  Please add the code for Doulas.  Everything else we can work around.

Howard,
It looks like RCP was added to the list in error.  This degree is in your code set.

Walter,
On your next pass, please change the following degrees in the final data to the Availity code.

Johanna,
Please make sure eVIPs degree data is not changed when we get the data back from Symphony.

CREDENTIALS not in codeset (AMFT, ASW, ATC, BCBA-D, DOL, HAD, LPCC, NMW, OP, OT, PC, RCP)
 
 x 'XWALK CROSSWALK'
		eVIPs	Availity Code	 
		AMFT	MFT	 
		ASW	LCSW	 
		ATC	AT	 
		BCBA-D	BCBA	 
		HAD	AUD	 
		LPCC	LPC	 
		NMW	CNM	 
		OP	COP	 
		OT	OTR	 
		PC	LPC	 


		DOL	 	Availity to add New Code
		RCP	RCP	No change

x 'BIG TIN' AS 'BUSINESS' 

--------------------------------------------------------------------------------------------------------------------
	-- Error Trapping: Check If Permanent Table(s) Already Exist(s) And Drop If Applicable --
--------------------------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS #HealthcareProviders

-- Create the IHP (Integrated Healthcare Provider) table
CREATE TABLE #HealthcareProviders (
    IHP_Name VARCHAR(50) NOT NULL,
    FEDID_TAXID VARCHAR(20),
    NPI VARCHAR(20),
    PRIMARY KEY (IHP_Name)
);

-- Insert the data from the table
INSERT INTO #HealthcareProviders (IHP_Name, FEDID_TAXID, NPI)
VALUES
    ('IHP - BIG TIN', '474334653', NULL),
    ('Integrated Health Partners - CHS', '330056551', '1982756086'),
    ('Integrated Health Partners - IBCC', '237209592', '1790718351'),
    ('Integrated Health Partners - NH', '952796316', '1598703647'),
    ('Integrated Health Partners - SDAIHC', '953397369', '1003902917'),
    ('Integrated Health Partners - SDFC', '952700856', '1962483040'),
    ('Integrated Health Partners - SVDPV', '330492302', '1659415131'),
    ('Integrated Health Partners - SYH', '952801772', '1174213904'),
    ('Integrated Health Partners - TrueCare', '952847102', '1245246917'),
    ('Integrated Health Partners - VCC', '952815615', '1629357355');

		SELECT * FROM 	#HealthcareProviders

SELECT DISTINCT ServiceTypeName 
FROM eVips_chgcv.dbo.vwLocationServices 
ORDER BY ServiceTypeName

SELECT DISTINCT PracticeID,Code1,Code2,ServiceTypeName,ServiceCategoryTypeName 
FROM eVips_chgcv.dbo.vwLocationServices 
WHERE ServiceTypeName LIKE '274%TYPE%SERV%'
		
		SELECT * FROM 	#HealthcareProviders

SELECT ' ' AS 'eVips: INTEGRATED HEALTH PARTNERS - FAC',TaxIDNumber,NationalProviderID,* 
FROM eVips_chgcv.dbo.vwFacilities -- Facilities
WHERE 1=1
	AND TaxIDNumber IN ('474334653') -- NPI IN ('1598122871')

SELECT ' ' AS 'eVips: INTEGRATED HEALTH PARTNERS - PRACTICES',TaxIDNumber,NationalProviderID,* 
FROM eVips_chgcv.dbo. vwPractices -- Practices
WHERE 1=1
	AND TaxIDNumber IN ('474334653') -- NPI IN ('1598122871') 
	-- AND practiceid IN ('5321500') -- Integrated Health Partners ... ?BIG TIN?

SELECT ' ' AS 'IHP BIG TIN?: FAC'
,CHARINDEX(' - ',[Prov Directory by Contracting Entity],1)+3 -- ie.: INTEGRATED HEALTH PARTNERS - IBCC
,LTRIM(RTRIM(TRY_CONVERT(nvarchar(25),LocationId)+''+SUBSTRING([Prov Directory by Contracting Entity],CHARINDEX(' - ',[Prov Directory by Contracting Entity],1)+3,99))) AS 'HYBRID LocationID',*
FROM INFORMATICS.dbo.FAC_SANATOR_PROVDIR_CONTRACTING_ENT
WHERE 1=1
	AND [Prov Directory by Contracting Entity] LIKE '%INTEGRAT%HEALTH%PART%'
	-- AND PracticeID IN ('5321500') -- Integrated Health Partners ... ?BIG TIN?
	-- AND DBAPracticeID IN ('5321500') -- Integrated Health Partners ... ?BIG TIN?
	
SELECT ' ' AS 'IHP BIG TIN?: PROV'
,CHARINDEX(' - ',[Prov Directory by Contracting Entity],1)+3 -- ie.: INTEGRATED HEALTH PARTNERS - IBCC
,LTRIM(RTRIM(TRY_CONVERT(nvarchar(25),LocationId)+''+SUBSTRING([Prov Directory by Contracting Entity],CHARINDEX(' - ',[Prov Directory by Contracting Entity],1)+3,99))) AS 'HYBRID LocationID',*
FROM INFORMATICS.dbo.PROV_SANATOR_PROVDIR_CONTRACTING_ENT
WHERE 1=1
	AND [Prov Directory by Contracting Entity] LIKE '%INTEGRAT%HEALTH%PART%'
	-- AND PracticeID IN ('5321500') -- Integrated Health Partners ... ?BIG TIN?
	-- AND DBAPracticeID IN ('5321500') -- Integrated Health Partners ... ?BIG TIN?







SELECT ' ' AS 'MULTI NAME per fedid / TaxID IN eVIPS FACILITIES',TaxIDNumber,* 
FROM eVips_chgcv.dbo.Facilities 
WHERE 1=1
	AND ISNULL(TaxIDNumber,'') != ''
	-- AND TaxIDNumber IN ('474334653','010667477','953782169') -- NPI IN ('1598122871')
	AND TaxIDNumber IN 
	( -- INITIATE ...
	SELECT DISTINCT TaxIDNumber
	FROM eVips_chgcv.dbo.Facilities 
	WHERE 1=1
	AND ISNULL(TaxIDNumber,'') != ''
	GROUP BY TaxIDNumber
	HAVING COUNT(DISTINCT(TRY_CONVERT(nvarchar(255),LTRIM(RTRIM(FacilityName))))) > 1

	UNION 
	SELECT DISTINCT TaxIDNumber
	FROM eVips_chgcv.dbo.Practices 
	WHERE 1=1
	AND ISNULL(TaxIDNumber,'') != ''
	GROUP BY TaxIDNumber
	HAVING COUNT(DISTINCT(TRY_CONVERT(nvarchar(255),LTRIM(RTRIM(PracticeName))))) > 1
	) -- CONCLUDE ... 

SELECT ' ' AS 'MULTI NAME per fedid / TaxID IN eVIPS PRACTICE',TaxIDNumber,*
FROM eVips_chgcv.dbo.Practices AS p
WHERE 1=1
	AND ISNULL(TaxIDNumber,'') != ''
	-- AND TaxIDNumber IN ('474334653','010667477','953782169') -- NPI IN ('1598122871')
	AND TaxIDNumber IN 
	( -- INITIATE ...
	SELECT DISTINCT TaxIDNumber
	FROM eVips_chgcv.dbo.Facilities 
	WHERE 1=1
	AND ISNULL(TaxIDNumber,'') != ''
	GROUP BY TaxIDNumber
	HAVING COUNT(DISTINCT(TRY_CONVERT(nvarchar(255),LTRIM(RTRIM(FacilityName))))) > 1

	UNION 
	SELECT DISTINCT TaxIDNumber
	FROM eVips_chgcv.dbo.Practices 
	WHERE 1=1
	AND ISNULL(TaxIDNumber,'') != ''
	GROUP BY TaxIDNumber
	HAVING COUNT(DISTINCT(TRY_CONVERT(nvarchar(255),LTRIM(RTRIM(PracticeName))))) > 1
	) -- CONCLUDE ... 
ORDER BY p.TaxIDNumber

SELECT ' ' AS 'MULTI DBA PER TaxID IN QNXT: ',fedid,PROVNM,* 
FROM INFOAG.INFORMATICS.dbo.[uvw_PROVISO] AS piso -- INFOAG = SQLPROD02 IN SQLPRODAPP01
WHERE 1=1
	-- AND fedid IN ('474334653') -- NPI IN ('1598122871') eg. SAMPLE: INTEGRATED HEALTH PARTNERS
	AND ISNULL(piso.fedid,'') !=''
	AND ISNULL(piso.fedid,'') IN 
	( -- INITIATE ...
	SELECT DISTINCT ISNULL(fedid,'') AS 'fedid'
	FROM INFOAG.INFORMATICS.dbo.[uvw_PROVISO] -- INFOAG = SQLPROD02 IN SQLPRODAPP01
	WHERE 1=1
		AND ISNULL(fedid,'') !=''
	GROUP BY fedid
	HAVING COUNT(DISTINCT(TRY_CONVERT(nvarchar(255),LTRIM(RTRIM(provid)))+' ' +TRY_CONVERT(nvarchar(255),LTRIM(RTRIM(PROVNM)))))> 1
	) -- CONCLUDE ...
ORDER BY ISNULL(piso.fedid,'')







-- =====================================================
	-- MULTI - DATABASE OBJECT SEARCH TEMPLATE: -- 
-- =====================================================
DECLARE @SearchText NVARCHAR(MAX) = 'TaxIDNumber';  -- Text to search for DEANumber, CONTRACTING_, primarystatus
DECLARE @ExactMatchST BIT = 0;                        -- SET AS 1 WHEN NULL OR FOR an exact match ON @PARAM
DECLARE @ObjectName NVARCHAR(MAX) = NULL;             -- Specific object name to search for (optional)
DECLARE @ExactMatchON BIT = 1;                        -- SET AS 1 WHEN NULL OR FOR an exact match ON @PARAM
DECLARE @SchemaName NVARCHAR(128) = NULL;             -- Limit search to specific schema (optional)
DECLARE @ObjectType NVARCHAR(128) = NULL;             -- Limit to specific object type (optional)
DECLARE @IncludeSystemObjects BIT = 0;                -- SET AS 1 FOR to include system objects

	-- Define databases to search (add or remove as needed)
DECLARE @DatabaseList TABLE (DatabaseName NVARCHAR(128))
INSERT INTO @DatabaseList (DatabaseName)
VALUES 
    ('INFORMATICS'), -- WORKING [db]
    ('HMOPROD_PLANDATA'), -- QNXT [db]
    ('EnrollmentManager'), -- 834 MEMBERSHIP
    ('ProviderPortal'),
	('evips_chgcv'), -- SERVER: SQLPRODAPP01 PROVIDER NETWORK SOURCE DATA
    ('ProviderReporsitory'), -- SERVER: SQLPRODAPP01 REPO
	('INFOAG'), -- SERVER: SQLPRODAPP01 LINKED SERVER TO SQLPROD02.INFORMATICS [db]
	('QPROD'),
    ('DATAWAREHOUSE'), -- LEGACY DW
    ('INFORMATICS2'), -- SQLPROD01.QPROD
    ('DIAMOND_Data');  -- LEGACY SYSTEM (D950) ... 

	-- Create a temporary table to store results
DROP TABLE IF EXISTS #SearchResults;

CREATE TABLE #SearchResults (
    DatabaseName NVARCHAR(128),
    ResultType NVARCHAR(50),
    SchemaName NVARCHAR(128),
    ObjectName NVARCHAR(256),
    ObjectType NVARCHAR(128),
    ColumnName NVARCHAR(128) NULL,
    DataTypeInfo NVARCHAR(256) NULL,
    AdditionalInfo NVARCHAR(MAX) NULL,
    ModifiedDate DATETIME NULL
);

	-- Prepare search patterns
DECLARE @SearchPattern NVARCHAR(MAX) = CASE 
    WHEN @ExactMatchST = 1 THEN @SearchText
    ELSE '%' + ISNULL(@SearchText, '') + '%'
END;

DECLARE @ObjectPattern NVARCHAR(MAX) = CASE 
    WHEN @ExactMatchON = 1 THEN @ObjectName
    ELSE '%' + ISNULL(@ObjectName, '') + '%'
END;

	-- Cursor to loop through databases
DECLARE @CurrentDB NVARCHAR(128)
DECLARE @SQL NVARCHAR(MAX)
DECLARE db_cursor CURSOR FOR 
SELECT DatabaseName FROM @DatabaseList
OPEN db_cursor  
FETCH NEXT FROM db_cursor INTO @CurrentDB

WHILE @@FETCH_STATUS = 0  
BEGIN
    PRINT 'Processing database: ' + @CurrentDB;
    
    BEGIN TRY
        -- Check if database exists and is accessible
        SET @SQL = N'USE ' + QUOTENAME(@CurrentDB);
        EXEC sp_executesql @SQL;
        
        -- 1. Search Object Definitions
        SET @SQL = N'
        USE ' + QUOTENAME(@CurrentDB) + N';
        
        INSERT INTO #SearchResults (DatabaseName, ResultType, SchemaName, ObjectName, ObjectType, AdditionalInfo, ModifiedDate)
        SELECT DISTINCT 
            ''' + @CurrentDB + N''',
            ''Object Definition'', 
            SCHEMA_NAME(o.schema_id), 
            o.name, 
            ISNULL(o.type_desc,''TABLE''),
            LEFT(m.definition, 100) + ''...'',
            o.modify_date
        FROM sys.sql_modules AS m
            INNER JOIN sys.objects AS o ON m.object_id = o.object_id
        WHERE 1=1
            AND (' + CASE WHEN @SchemaName IS NULL THEN N'1=1' ELSE N'SCHEMA_NAME(o.schema_id) = @SchemaName' END + N')
            AND (' + CASE WHEN @ObjectType IS NULL THEN N'1=1' ELSE N'o.type_desc LIKE @ObjectType' END + N')
            AND (' + CASE WHEN @IncludeSystemObjects = 1 THEN N'1=1' ELSE N'o.is_ms_shipped = 0' END + N')
            AND (m.definition LIKE @SearchPattern OR o.name LIKE @ObjectPattern)
            AND o.name NOT LIKE ''sp_MS%'';
            
        -- 2. Search Columns
        INSERT INTO #SearchResults (DatabaseName, ResultType, SchemaName, ObjectName, ObjectType, ColumnName, DataTypeInfo, AdditionalInfo)
        SELECT DISTINCT 
            ''' + @CurrentDB + N''',
            ''Column'',
            c.TABLE_SCHEMA,
            c.TABLE_NAME,
            TRY_CONVERT(nvarchar(128),''TABLE''),
            c.COLUMN_NAME,
            c.DATA_TYPE + 
                CASE 
                    WHEN c.CHARACTER_MAXIMUM_LENGTH IS NOT NULL 
                    THEN ''('' + CAST(c.CHARACTER_MAXIMUM_LENGTH AS VARCHAR(10)) + '')''
                    ELSE ''''
                END,
            ''Nullable: '' + c.IS_NULLABLE
        FROM INFORMATION_SCHEMA.COLUMNS AS c
            JOIN INFORMATION_SCHEMA.TABLES AS t ON c.TABLE_NAME = t.TABLE_NAME 
                AND c.TABLE_SCHEMA = t.TABLE_SCHEMA
        WHERE 1=1
            AND (' + CASE WHEN @SchemaName IS NULL THEN N'1=1' ELSE N'c.TABLE_SCHEMA = @SchemaName' END + N')
            AND (c.COLUMN_NAME LIKE @SearchPattern OR c.TABLE_NAME LIKE @ObjectPattern);
            
        -- 3. Search Tables
        INSERT INTO #SearchResults (DatabaseName, ResultType, SchemaName, ObjectName, ObjectType)
        SELECT DISTINCT 
            ''' + @CurrentDB + N''',
            ''Table'',
            t.TABLE_SCHEMA,
            t.TABLE_NAME,
            t.TABLE_TYPE
        FROM INFORMATION_SCHEMA.TABLES AS t
        WHERE 1=1
            AND (' + CASE WHEN @SchemaName IS NULL THEN N'1=1' ELSE N't.TABLE_SCHEMA = @SchemaName' END + N')
            AND t.TABLE_NAME LIKE @ObjectPattern;
            
        -- 4. Search Indexes
        INSERT INTO #SearchResults (DatabaseName, ResultType, SchemaName, ObjectName, ColumnName, DataTypeInfo, AdditionalInfo)
        SELECT DISTINCT 
            ''' + @CurrentDB + N''',
            ''Index'',
            SCHEMA_NAME(t.schema_id),
            t.name,
            i.name,
            i.type_desc,
            ''Is Unique: '' + CASE WHEN i.is_unique = 1 THEN ''Yes'' ELSE ''No'' END
        FROM sys.indexes AS i
            INNER JOIN sys.tables AS t ON i.object_id = t.object_id
        WHERE 1=1
            AND (' + CASE WHEN @SchemaName IS NULL THEN N'1=1' ELSE N'SCHEMA_NAME(t.schema_id) = @SchemaName' END + N')
            AND (i.name LIKE @SearchPattern OR t.name LIKE @ObjectPattern)
            AND i.name IS NOT NULL;';
            
        EXEC sp_executesql @SQL, 
            N'@SearchPattern NVARCHAR(MAX), @ObjectPattern NVARCHAR(MAX), @SchemaName NVARCHAR(128), @ObjectType NVARCHAR(128)',
            @SearchPattern, @ObjectPattern, @SchemaName, @ObjectType;
            
    END TRY
    BEGIN CATCH
        PRINT 'Error processing database ' + @CurrentDB + ': ' + ERROR_MESSAGE();
        
        -- Optional: Insert error information into the results
        INSERT INTO #SearchResults (DatabaseName, ResultType, AdditionalInfo)
        VALUES (@CurrentDB, 'ERROR', 'Failed to process: ' + ERROR_MESSAGE());
    END CATCH
    
    -- Next database
    FETCH NEXT FROM db_cursor INTO @CurrentDB
END

CLOSE db_cursor  
DEALLOCATE db_cursor

-- =====================================================
	-- Display Results
-- =====================================================
SELECT 	' ' AS 'Summary counts by database and result type',
DatabaseName,
ResultType, 
COUNT(*) AS TotalFound
FROM #SearchResults
GROUP BY DatabaseName, ResultType
ORDER BY DatabaseName, ResultType;

SELECT 	' ' AS 'All detailed results',*
FROM #SearchResults
ORDER BY DatabaseName, ResultType, SchemaName, ObjectName;

SELECT 	' ' AS 'Column results for easier analysis',*
FROM #SearchResults
WHERE ResultType = 'Column'
ORDER BY DatabaseName, SchemaName, ObjectName, ColumnName;

DROP TABLE IF EXISTS #SearchResults; -- POWER CYCLE RESET REFRESH RESTART ... 







JAH CHARINDEX() FIND() SEARCH() SUBJECT:"*Availity*"
-- =====================================================================
	-- COMMENT(S) / CHANGE.LOG: --
-- =====================================================================
-- C013: "*SYMPHONY*", "*AVAILITY*" ... exclude Stark Development and Walter Anderson Plumbing from all data tables in future submissions. PER MS SANDRA DURING CONVERSATION WITH() ACTION ITEMS: SYMPHONY - Follow-Up: Symphony and CHG 3.7.2025 Semi-Monthly Implementation Meetings
	( -- INITIATE ...
 
 -- C014: "*SYMPHONY*", "*AVAILITY*" ... remove NPI information from the identifier file for non-business entities. PER ACTION ITEMS: SYMPHONY - Follow-Up: Symphony and CHG 3.7.2025 Semi-Monthly Implementation Meetings
 
 -- C015: "*SYMPHONY*", "*AVAILITY*" ... include business entity types (DBAs) and their service locations. PER ACTION ITEMS: SYMPHONY - Follow-Up: Symphony and CHG 3.7.2025 Semi-Monthly Implementation Meetings

		Next Steps:
				•	Walter to update the location file to include business entity types (DBAs) and their service locations.
				•	Walter to exclude Stark Development and Walter Anderson Plumbing from all data tables in future submissions.
				•	Walter to remove NPI information from the identifier file for non-business entities.
				-- •	Sandra to review the list of degree code exceptions and determine which ones can be combined or need to be added as new codes.
				-- •	Sandra to provide a data structure diagram of CHG's understanding of their data by next March 14, 2025.
				-- •	Howard to consult with Amy about the possibility of adding "Doula" to the professional degree code set.
				-- •	Lekitta to cancel next Friday's meeting and reschedule it for the week of the 21st.
				-- •	Howard will review the updated files once they are received from CHG on March 14, 2025.

SELECT TOP 10 ' ' AS 'CHECK 1st',practiceid,locationid,AddressID,*
-- SELECT DISTINCT ' ' AS 'CHECK 1st',
FROM INFORMATICS.dbo.FAC_SANATOR_PROVDIR_CONTRACTING_ENT 
WHERE 1=1
	AND DBA IS NOT NULL -- REVISION PER BI MONTHLY MEETING WITH SYMPHONY ON 20240726
	AND  -- C013: "*SYMPHONY*", "*AVAILITY*" ... exclude Stark Development and Walter Anderson Plumbing from all data tables in future submissions. PER MS SANDRA DURING CONVERSATION WITH() ACTION ITEMS: SYMPHONY - Follow-Up: Symphony and CHG 3.7.2025 Semi-Monthly Implementation Meetings
	( -- INITIATE ...
	[Prov Directory by Contracting Entity] LIKE '%WALTER%ANDE%'
		OR [Prov Directory by Contracting Entity] LIKE '%STARK%DEVELOP%'
	) -- CONCLUDE ...
	
SELECT TOP 10 ' ' AS 'CHECK 1st',practiceid,locationid,AddressID,*
-- SELECT DISTINCT ' ' AS 'CHECK 1st',
FROM INFORMATICS.dbo.FAC_SANATOR_PROVDIR_CONTRACTING_ENT 
WHERE 1=1 
	AND DBA IS NOT NULL -- REVISION PER BI MONTHLY MEETING WITH SYMPHONY ON 20240726
	AND DBA NOT LIKE '%TELEM%'
	AND DBA NOT LIKE '%ABLE%TO%'
	AND DBA NOT LIKE '%RADY%'
	AND GETMEDGRP NOT LIKE '%TELEM%'
	AND GETMEDGRP NOT LIKE '%ABLE%TO%'
	AND GETMEDGRP NOT LIKE '%RADY%'
	AND  -- C013: "*SYMPHONY*", "*AVAILITY*" ... exclude Stark Development and Walter Anderson Plumbing from all data tables in future submissions. PER MS SANDRA DURING CONVERSATION WITH() ACTION ITEMS: SYMPHONY - Follow-Up: Symphony and CHG 3.7.2025 Semi-Monthly Implementation Meetings
	( -- INITIATE ...
	[Prov Directory by Contracting Entity] LIKE '%WALTER%ANDE%'
		OR [Prov Directory by Contracting Entity] LIKE '%STARK%DEVELOP%'
	) -- CONCLUDE ...

SELECT TOP 10 ' ' AS 'CHECK 1st',practiceid,locationid,practitionerid,AddressID,*
-- SELECT DISTINCT ' ' AS 'CHECK 1st',
FROM INFORMATICS.dbo.PROV_SANATOR_PROVDIR_CONTRACTING_ENT
WHERE 1=1
	AND LastName IS NOT NULL 
	AND FirstName IS NOT NULL
	
	
	
	
	
	
	
JAH 'SYMPHONY NONSENSE'
ROW_NUMBER() OVER(PARTITION BY eid.[provid] ORDER BY eid.NPI DESC) AS [ROWis], -- STRAIGHT FWD SEQUENCE THE SEQUENCE

eid.NEW_ENTITY_ID AS [ENTITY_ID],  -- USE the new RANDOM ID instead of PROVTAXID
eid.ENTITY_TYPE,

AS sourcetable
	JOIN INFORMATICS.dbo.ENTITY_ID_MAPPING AS eid ON sourcetable.PROVTAXID = eid.PROVTAXID
		AND sourcetable.NPIis = eid.NPI
		AND sourcetable.PractitionerId = eid.[provid]
		AND sourcetable.PracticeId = eid.[provid]
		AND eid.ENTITY_TYPE IN ('PROVIDER')

	-- CHECK FOR DUP(S) --
SELECT ' ' AS 'SHOULD BE NULL DUP Validation',*
-- DELETE
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st',
FROM INFORMATICS.dbo.SYMPHONY_ADDRESS
WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ... AND ...
	AND ADDRESS_ID IN
	( -- INITIATE ...
	SELECT ADDRESS_ID
	FROM INFORMATICS.dbo.SYMPHONY_ADDRESS AS dup
	GROUP BY ADDRESS_ID -- Duplication Driver 
	HAVING COUNT(1)>1 -- HAVING clause RESERVED for AGGREGATE(s) ... HAVING SUM(PAID_NET_AMT) != 0
	); -- CONCLUDE ...

SELECT SUBSTRING(LOCATION_ID,1,7) AS LOCATIONID,*
FROM 
( -- INITIATE ...
SELECT DENSE_RANK() OVER(PARTITION BY sl.ENTITY_ID ORDER BY sl.LOCATION_ID) AS [RANKis] -- RANK() ACCOUNT(s) FOR TIES + RETAINS SEQUENCE ... NO NEGATIVE NOT != <> GAPS IN THE SEQUENCE
,ROW_NUMBER() OVER(PARTITION BY sl.ENTITY_ID ORDER BY sl.LOCATION_ID) AS [ROWis] -- STRAIGHT FORWARD SEQUENCE
,sl.*
FROM INFORMATICS.dbo.SYMPHONY_LOCATION AS sl
WHERE 1=1
	-- AND sl.ENTITY_ID IN ('4368574') -- SAMPLE
) -- CONCLUDE ...
AS setprim 
WHERE 1=1
	AND ENTITY_ID IN ('4368574','4356006') -- SAMPLE TO SET PRIM_IN
	AND LOCATION_ID IN ('5256564L5716664') -- SAMPLE TO SET PRIM_IN
	AND RANKis = 10

SELECT MIN(RANKis),MAX(RANKis),MIN(PRIMARY_IND),MAX(PRIMARY_IND)
FROM 
( -- INITIATE ...
SELECT sl.*
,DENSE_RANK() OVER(PARTITION BY sl.ENTITY_ID ORDER BY sl.LOCATION_ID) AS [RANKis] -- RANK() ACCOUNT(s) FOR TIES + RETAINS SEQUENCE ... NO NEGATIVE NOT != <> GAPS IN THE SEQUENCE
,ROW_NUMBER() OVER(PARTITION BY sl.ENTITY_ID ORDER BY sl.LOCATION_ID) AS [ROWis] -- STRAIGHT FORWARD SEQUENCE
FROM INFORMATICS.dbo.SYMPHONY_LOCATION AS sl
WHERE 1=1
	-- AND sl.ENTITY_ID IN ('4368574') -- SAMPLE
) -- CONCLUDE ...
AS setprim 

--------------------------------------------------------------------------------------------------------------------
	-- Error Trapping: Check If Permanent Table(s) Already Exist(s) And Drop If Applicable --
--------------------------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS INFORMATICS.dbo.DxHOURS

SELECT * 
INTO INFORMATICS.dbo.DxHOURS
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st',
FROM INFORMATICS.dbo.SYMPHONY_HOURS;

SELECT LOC_TYPE,*
FROM INFORMATICS.dbo.SYMPHONY_LOCATION
WHERE 1=1
	AND LOC_TYPE IN ('SERVICE')

SELECT [Participating Network],*
FROM INFORMATICS.dbo.PROV_SANATOR_PROVDIR_CONTRACTING_ENT AS p





JAH 'ADDR'
SELECT TOP 10 ' ' AS 'PRACTICE ADDR',*
FROM eVips_chgcv.dbo.vwPractices AS vp
	JOIN eVips_chgcv.dbo.vwPracticeLocations AS vpl ON vp.PracticeID = vpl.PracticeID

SELECT TOP 10 ' 'AS 'PRACTITIONER ADDR',vpprovloc.PractitionerID,vpprovloc.PracticeID,vpprovloc.LocationID,vpprovloc.AddressID,vpprovloc.LastName,vpprovloc.FirstName,vpprovloc.Archived,vpprovloc.LocationName,vpprovloc.NationalProviderID,vpprovloc.LocationNotes,vpprovloc.PracticeTypeName,vpprovloc.ProviderNumber,vpprovloc.website,vpfacloc.LineNumber1,vpfacloc.LineNumber2,vpfacloc.LineNumber3,vpfacloc.City,vpfacloc.[State],vpfacloc.ZipCode,vpfacloc.LocationTypeName 
FROM eVips_chgcv.dbo.vwPractitionerLocations AS vpprovloc
	JOIN eVips_chgcv.dbo.vwPracticeLocations AS vpfacloc ON vpprovloc.PracticeID = vpfacloc.PracticeID
		AND vpprovloc.LocationID = vpfacloc.LocationID 
		WHERE UPPER(LTRIM(RTRIM(ISNULL(vpfacloc.LocationTypeName,'')))) LIKE '%PRACTI%'

-- SELECT DISTINCT LocationTypeName FROM eVips_chgcv.dbo.vwPractitionerLocations
-- SELECT TOP 10 * FROM eVips_chgcv.dbo.vwPractitionerLocations

		LEFT JOIN
		( -- INITIATE ...
		SELECT DISTINCT vpprovloc.PractitionerID,vpprovloc.PracticeID,vpprovloc.LocationID,vpprovloc.AddressID,vpprovloc.LastName,vpprovloc.FirstName,vpprovloc.Archived,vpprovloc.LocationName,vpprovloc.NationalProviderID,vpprovloc.LocationNotes,vpprovloc.PracticeTypeName,vpprovloc.ProviderNumber,vpprovloc.website,vpfacloc.LineNumber1,vpfacloc.LineNumber2,vpfacloc.LineNumber3,vpfacloc.City,vpfacloc.[State],vpfacloc.ZipCode,vpfacloc.LocationTypeName 
		FROM eVips_chgcv.dbo.vwPractitionerLocations AS vpprovloc
		JOIN eVips_chgcv.dbo.vwPracticeLocations AS vpfacloc ON vpprovloc.PracticeID = vpfacloc.PracticeID
			AND vpprovloc.LocationID = vpfacloc.LocationID 
		WHERE UPPER(LTRIM(RTRIM(ISNULL(vpfacloc.LocationTypeName,'')))) LIKE '%PRACTI%'
		) -- CONCLUDE ...
		AS vploc ON vpd.PractitionerID = vploc.PractitionerID
		AND vpp.PracticeID = vploc.PracticeID
		AND vpp.LocationID = vploc.LocationID

	JOIN ( -- INITIATE ...
	SELECT DISTINCT ' 'AS 'PRACTITIONER ADDR',vpprovloc.PractitionerID,vpprovloc.PracticeID,vpprovloc.LocationID,vpprovloc.AddressID,vpprovloc.LastName,vpprovloc.FirstName,vpprovloc.Archived,vpprovloc.LocationName,vpprovloc.NationalProviderID,vpprovloc.LocationNotes,vpprovloc.PracticeTypeName,vpprovloc.ProviderNumber,vpprovloc.website,vpfacloc.LineNumber1,vpfacloc.LineNumber2,vpfacloc.LineNumber3,vpfacloc.City,vpfacloc.[State],vpfacloc.ZipCode,vpfacloc.LocationTypeName 
	FROM eVips_chgcv.dbo.vwPractitionerLocations AS vpprovloc
		JOIN eVips_chgcv.dbo.vwPracticeLocations AS vpfacloc ON vpprovloc.PracticeID = vpfacloc.PracticeID
			AND vpprovloc.LocationID = vpfacloc.LocationID 
		WHERE UPPER(LTRIM(RTRIM(ISNULL(vpfacloc.LocationTypeName,'')))) LIKE '%PRACTI%'
		) -- CONCLUDE ...
		AS vploc ON vploc.PractitionerID = vpd.PractitionerID
		AND vploc.PracticeID = vpp.PracticeID
		AND vploc.LocationID = vpp.LocationID
		-- AND vploc.AddressID = vpp.AddressID
	JOIN eVips_chgcv.dbo.vwPracticeLocations AS vpracloc ON vpp.practiceid = vpracloc.practiceid  --SPECIAL ADD - ON JOIN (s)
		AND vpp.Locationid = vpracloc.Locationid --SPECIAL ADD - ON JOIN (s)

		 SELECT * FROM INFORMATICS.dbo.SYMPHONY_FILECONTROL -- SQL Server 2016 and later -- DYNAMIC tmp OR STATIC [TABLE] #TableName is a local temporary table visible only in the current session; #TableName is a GLOBAL temporary table visible to all sessions IN ('TempDB')
		 SELECT * FROM INFORMATICS.dbo.SYMPHONY_ENTITY WHERE 1=1 AND ENTITY_TYPE = 'BUSINESS'
		 SELECT * FROM INFORMATICS.dbo.SYMPHONY_LOCATION
		 SELECT * FROM INFORMATICS.dbo.SYMPHONY_ADDRESS
		 SELECT * FROM INFORMATICS.dbo.SYMPHONY_CONTACT
		 SELECT * FROM INFORMATICS.dbo.SYMPHONY_ROSTER
		 SELECT * FROM INFORMATICS.dbo.SYMPHONY_IDENTIFIER
		 SELECT * FROM INFORMATICS.dbo.SYMPHONY_LANGUAGE
		 SELECT * FROM INFORMATICS.dbo.SYMPHONY_TAXONOMY
		 SELECT * FROM INFORMATICS.dbo.SYMPHONY_HOSPITAL
		 SELECT * FROM INFORMATICS.dbo.SYMPHONY_NETWORK
		 SELECT * FROM INFORMATICS.dbo.SYMPHONY_HOURS
		 SELECT * FROM INFORMATICS.dbo.SYMPHONY_BED_DETAIL

SELECT DISTINCT FileTableName FROM INFORMATICS.dbo.SYMPHONY_ENTITY
SELECT DISTINCT FileTableName FROM INFORMATICS.dbo.SYMPHONY_LOCATION
SELECT DISTINCT FileTableName FROM INFORMATICS.dbo.SYMPHONY_ADDRESS
SELECT DISTINCT FileTableName FROM INFORMATICS.dbo.SYMPHONY_CONTACT
SELECT DISTINCT FileTableName FROM INFORMATICS.dbo.SYMPHONY_ROSTER
SELECT DISTINCT FileTableName FROM INFORMATICS.dbo.SYMPHONY_IDENTIFIER
SELECT DISTINCT FileTableName FROM INFORMATICS.dbo.SYMPHONY_LANGUAGE
SELECT DISTINCT FileTableName FROM INFORMATICS.dbo.SYMPHONY_TAXONOMY
SELECT DISTINCT FileTableName FROM INFORMATICS.dbo.SYMPHONY_HOSPITAL
SELECT DISTINCT FileTableName FROM INFORMATICS.dbo.SYMPHONY_NETWORK
SELECT DISTINCT FileTableName FROM INFORMATICS.dbo.SYMPHONY_HOURS
SELECT DISTINCT FileTableName FROM INFORMATICS.dbo.SYMPHONY_BED_DETAIL		







JAH 'Claude.ai' ON 20241105 RANDOM ID NEWID():

ROW_NUMBER() OVER(PARTITION BY eid.[provid] ORDER BY eid.NPI DESC) AS [ROWis], -- STRAIGHT FWD SEQUENCE THE SEQUENCE

'LOC' + CAST(ABS(CAST(CAST(NEWID() AS VARBINARY) AS INT)) AS VARCHAR(20)) AS LOCATION_ID,  -- ENSURE UPDATE of ALL dependent tables that reference LOCATION_ID
'IDENT' + CAST(ABS(CAST(CAST(NEWID() AS VARBINARY) AS INT)) AS VARCHAR(20)) AS IDENTIFIER_ID,  -- ENSURE UPDATE of ALL dependent tables that reference IDENTIFIER_ID
'NETW' + CAST(ABS(CAST(CAST(NEWID() AS VARBINARY) AS INT)) AS VARCHAR(20)) AS NETWORK_ID,  -- ENSURE UPDATE of ALL dependent tables that reference NETWORK_ID

I will help you modify the SYMPHONY_ENTITY table creation to use randomly generated IDs while maintaining referential relationships across tables.
SQL Code for Random Entity IDsClick to open code.

m.NEW_ENTITY_ID AS ENTITY_ID,  -- USE the new RANDOM ID instead of PROVTAXID

JOIN INFORMATICS.dbo.ENTITY_ID_MAPPING AS m ON e.OLD_ENTITY_ID = m.PROVTAXID 
	AND e.ENTITY_TYPE = m.ENTITY_TYPE

This solution provides several benefits:

		~ Consistent ID Generation: Uses 'ENT_' prefix followed by a RANDOM NUMBER for entity IDs
		~ Referential Integrity: Maintains relationships between entities via the mapping table
		~ Traceability: Keeps original PROVTAXID mapping for reference
		~ Scalability: Can handle additional entity types
		~ Uniqueness: Ensures unique IDs across all entity types

Key considerations:

		~ You will need to UPDATE ALL dependent tables that reference ENTITY_ID
		~ The mapping table helps maintain relationships and troubleshoot issues
		~ The random IDs are generated once and stored, ensuring consistency
		~ The prefix (ENT_, LOC_, ROS_) helps identify the type of ID
		~ Using NEWID() with proper casting ensures random but valid IDs

		LEFT JOIN 
		( -- INITIATE ...
		SELECT DISTINCT ProviderID,TableName,EntityCode,EntityName,EntityTypeCode,EntityTypeName 
		FROM eVips_chgcv.dbo.vwEntityAssignments 
		-- WHERE UPPER(LTRIM(RTRIM(ISNULL(TableName,'')))) LIKE '%PRACTI%' -- C009: ALLOW FOR REMIT LOCATION PER MS SANDRA BECAUSE SYMPHONY LACKS ABILITY TO UNDERSTAND UPLOAD CHGSD DATA
		) -- CONCLUDE ...
		AS vea ON vp.PracticeID = vea.ProviderID

CREATE TABLE INFORMATICS.dbo.SYMPHONY_LOCATION

-- p.PROVTAXID AS ENTITY_ID,
eid.ENTITY_ID,

AS p
	JOIN INFORMATICS.dbo.SYMPHONY_ENTITY AS eid ON p.PROVTAXID = eid.PROVTAXID





CREATE TABLE INFORMATICS.dbo.SYMPHONY_CONTACT
CREATE TABLE INFORMATICS.dbo.SYMPHONY_LANGUAGE
CREATE TABLE INFORMATICS.dbo.SYMPHONY_TAXONOMY

    -- LocationID AS LOCATION_ID,
	lid.LOCATION_ID,
	-- p.PROVTAXID AS ENTITY_ID,
	lid.ENTITY_ID,

	JOIN INFORMATICS.dbo.SYMPHONY_LOCATION AS lid ON p.LocationID = lid.LocationID
		AND p.PROVTAXID = lid.PROVTAXID

    -- LocationID AS LOCATION_ID,
	lid.LOCATION_ID,
	-- p.PROVTAXID AS ENTITY_ID,
	eid.ENTITY_ID,

-- p.PROVTAXID AS ENTITY_ID,
eid.ENTITY_ID,
-- TRY_CONVERT(NVARCHAR(50),NULL)  AS LOCATION_ID,
lid.LOCATION_ID,

	-- s.PROVTAXID AS ENTITY_ID,
	eid.ENTITY_ID,
    -- s.LocationID AS LOCATION_ID,
	lid.LOCATION_ID,

AS p
	JOIN INFORMATICS.dbo.SYMPHONY_LOCATION AS lid ON p.LocationID = lid.LocationID
	JOIN INFORMATICS.dbo.SYMPHONY_ENTITY AS eid ON p.PROVTAXID = eid.PROVTAXID
	
AS dmmaplang
	JOIN INFORMATICS.dbo.SYMPHONY_LOCATION AS lid ON p.LocationID = lid.LocationID
	JOIN INFORMATICS.dbo.SYMPHONY_ENTITY AS eid ON p.PROVTAXID = eid.PROVTAXID	







CREATE TABLE INFORMATICS.dbo.SYMPHONY_IDENTIFIER 
CREATE TABLE INFORMATICS.dbo.SYMPHONY_HOSPITAL

	-- p.PROVTAXID AS ENTITY_ID,
	eid.ENTITY_ID,
	
	-- s.PROVTAXID AS ENTITY_ID,
	eid.ENTITY_ID,	
	
AS p
	JOIN INFORMATICS.dbo.SYMPHONY_ENTITY AS eid ON p.PROVTAXID = eid.PROVTAXID

AS s
	JOIN INFORMATICS.dbo.SYMPHONY_ENTITY AS eid ON s.PROVTAXID = eid.PROVTAXID







CREATE TABLE INFORMATICS.dbo.SYMPHONY_NETWORK 
CREATE TABLE INFORMATICS.dbo.SYMPHONY_HOURS
CREATE TABLE INFORMATICS.dbo.SYMPHONY_BED_DETAIL

    -- p.LocationID AS LOCATION_ID,
	lid.LOCATION_ID,
	
	-- DailyHours.LocationID,
	lid.LOCATION_ID,

AS p
	JOIN INFORMATICS.dbo.SYMPHONY_LOCATION AS lid ON p.LocationID = lid.LocationID

AS DailyHours
	JOIN INFORMATICS.dbo.SYMPHONY_LOCATION AS lid ON DailyHours.LocationID = lid.LocationID
	
	
	
	
	
	
	
-- First CREATE a MAPPING TABLE to maintain relationship between PROVTAXID and new RANDOM IDs
DROP TABLE IF EXISTS INFORMATICS.dbo.ENTITY_ID_MAPPING;

CREATE TABLE INFORMATICS.dbo.ENTITY_ID_MAPPING (
    PROVTAXID VARCHAR(50),
    NEW_ENTITY_ID VARCHAR(50),
    ENTITY_TYPE VARCHAR(12)
);

	-- POPULATE MAPPING TABLE with UNIQUE RANDOM IDs for each PROVTAXID and TYPE COMBINATION
WITH UniqueTaxIDs AS (
    -- GET DISTINCT PROVTAXID and TYPE COMBINATIONS from your source data
    SELECT DISTINCT PROVTAXID, 'BUSINESS' AS ENTITY_TYPE
    FROM INFORMATICS.dbo.FAC_SANATOR_PROVDIR_CONTRACTING_ENT 
    WHERE DBA IS NOT NULL

    UNION

    SELECT DISTINCT PROVTAXID, 'FACILITY' AS ENTITY_TYPE
    FROM INFORMATICS.dbo.FAC_SANATOR_PROVDIR_CONTRACTING_ENT 
    WHERE 1=1 
        AND DBA NOT LIKE '%TELEM%'
        AND DBA NOT LIKE '%ABLE%TO%'
        AND DBA NOT LIKE '%RADY%'
        AND GETMEDGRP NOT LIKE '%TELEM%'
        AND GETMEDGRP NOT LIKE '%ABLE%TO%'
        AND GETMEDGRP NOT LIKE '%RADY%'

    UNION

    SELECT DISTINCT PROVTAXID, 'PROVIDER' AS ENTITY_TYPE
    FROM INFORMATICS.dbo.PROV_SANATOR_PROVDIR_CONTRACTING_ENT
    WHERE LastName IS NOT NULL AND FirstName IS NOT NULL
)
INSERT INTO INFORMATICS.dbo.ENTITY_ID_MAPPING
SELECT 
    PROVTAXID,
    'ENT' + CAST(ABS(CAST(CAST(NEWID() AS VARBINARY) AS INT)) AS VARCHAR(20)) AS NEW_ENTITY_ID,
    ENTITY_TYPE
FROM UniqueTaxIDs;

		SELECT * FROM INFORMATICS.dbo.ENTITY_ID_MAPPING;








	-- Modify the SYMPHONY_ENTITY table creation to use the new random IDs
DROP TABLE IF EXISTS INFORMATICS.dbo.SYMPHONY_ENTITY;

CREATE TABLE INFORMATICS.dbo.SYMPHONY_ENTITY (
    -- ... [previous columns remain the same]
);

	-- Modified INSERT statement using the mapping table
INSERT INTO INFORMATICS.dbo.SYMPHONY_ENTITY
SELECT FileTableName,
    m.NEW_ENTITY_ID AS ENTITY_ID,  -- Use the new random ID instead of PROVTAXID
    ENTITY_TYPE,
    EIN,
    BUSINESS_NM,
    DBA_NM,
    [URL],
    EXPIRED_DT,
    END_REASON_CD,
    NPI,
    NPI_TYPE_CD,
    ATYPICAL_IN,
    SSN,
    LAST_NM,
    FIRST_NM,
    MIDDLE_NM,
    PREFIX,
    SUFFIX,
    [CREDENTIALS],
    GENDER_CD,
    DOB,
    RACE_CD,
    ETHNICITY_CD,
    LAST_UPDATE_DT
FROM 
(
    -- Your existing source query here
    SELECT DISTINCT 'CHGSD_ENTITY_'+REPLACE(REPLACE(REPLACE(LTRIM(RTRIM(CAST( CONVERT(nvarchar(25),TRY_CONVERT(datetime,GETDATE()),120) AS nvarchar(25)))),' ',''),'-',''),':','') AS FileTableName,
    ROW_NUMBER() OVER(PARTITION BY PROVTAXID ORDER BY NPIis DESC) AS [RANKis],
    PROVTAXID AS OLD_ENTITY_ID,
    TRY_CONVERT(varchar(12),'BUSINESS') AS ENTITY_TYPE,
    -- ... [rest of your existing columns]
    FROM INFORMATICS.dbo.FAC_SANATOR_PROVDIR_CONTRACTING_ENT 
    WHERE 1=1 AND DBA IS NOT NULL -- REVISION PER BI MONTHLY MEETING WITH SYMPHONY ON 20240726

    UNION ALL
    -- ... [your other UNION statements]
) AS e
JOIN INFORMATICS.dbo.ENTITY_ID_MAPPING m 
    ON e.OLD_ENTITY_ID = m.PROVTAXID 
    AND e.ENTITY_TYPE = m.ENTITY_TYPE
WHERE RANKis = 1;







	-- Update dependent tables to use new ENTITY_IDs
	-- Example for SYMPHONY_LOCATION:
INSERT INTO INFORMATICS.dbo.SYMPHONY_LOCATION
SELECT 
    l.FileTableName,
    'LOC' + CAST(ABS(CAST(CAST(NEWID() AS VARBINARY) AS INT)) AS VARCHAR(20)) AS LOCATION_ID,
    m.NEW_ENTITY_ID AS ENTITY_ID,  -- Use mapped ID instead of PROVTAXID
    l.ADDRESS_ID,
    l.LOC_TYPE,
    l.PRIMARY_IND,
    l.HANDICAP_ACCESSIBLE_IND,
    l.HAS_TDD_EQUIP,
    l.LOCATION_NM,
    l.SUPERVISING_PROV_NPI,
    l.SUPERVISING_PROV_SPEC,
    l.PROVIDES_TELEHEALTH_SVCS,
    l.TERTIARY_CARE_IN,
    l.CLINIC_ID,
    l.EFFECTIVE_DT,
    l.EXPIRED_DT,
    l.EXPIRED_REASON_CD
FROM INFORMATICS.dbo.FAC_SANATOR_PROVDIR_CONTRACTING_ENT src
JOIN INFORMATICS.dbo.ENTITY_ID_MAPPING m ON src.PROVTAXID = m.PROVTAXID
CROSS APPLY (
    -- Your existing location logic here
    SELECT 
        'CHGSD_LOCATION_'+REPLACE(REPLACE(REPLACE(LTRIM(RTRIM(CAST( CONVERT(NVARCHAR(25),TRY_CONVERT(DATETIME,GETDATE()),120) AS NVARCHAR(25)))),' ',''),'-',''),':','') AS FileTableName,
        -- ... [rest of your location columns]
) l;







	-- Similarly update other dependent tables (SYMPHONY_ROSTER, SYMPHONY_IDENTIFIER, etc.)
	-- Example for SYMPHONY_ROSTER:
INSERT INTO INFORMATICS.dbo.SYMPHONY_ROSTER
SELECT 
    r.FileTableName,
    'ROS' + CAST(ABS(CAST(CAST(NEWID() AS VARBINARY) AS INT)) AS VARCHAR(20)) AS ROSTER_ID,
    m_primary.NEW_ENTITY_ID AS PRIMARY_ID,
    m_secondary.NEW_ENTITY_ID AS SECONDARY_ID,
    r.RELATIONSHIP_TYPE,
    r.EFFECTIVE_DT,
    r.EXPIRED_DT,
    r.EXPIRED_REASON_CD
FROM YourSourceRosterData r
JOIN INFORMATICS.dbo.ENTITY_ID_MAPPING m_primary 
    ON r.PRIMARY_ID = m_primary.PROVTAXID
JOIN INFORMATICS.dbo.ENTITY_ID_MAPPING m_secondary 
    ON r.SECONDARY_ID = m_secondary.PROVTAXID;







		SELECT DISTINCT 'CHGSD_FILECONTROL_'+REPLACE(REPLACE(REPLACE(LTRIM(RTRIM(CAST( CONVERT(NVARCHAR(25),TRY_CONVERT(DATETIME,GETDATE()),120) AS NVARCHAR(25)))),' ',''),'-',''),':','') AS FileTableName,* 
		FROM INFORMATICS.dbo.SYMPHONY_FILECONTROL
		ORDER BY FILE_SEQ_NBR

SELECT ' ' AS 'SAMPLE REMIT: BALBOA NEPHROLOGY MEDICAL GROUP',[vplLOCATIONTYPENAME],*
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st', ServiceTypeName,vlpSERVICETYPENAME,vlpLOCATIONTYPENAME,vplLOCATIONTYPENAME
FROM INFORMATICS.dbo.FAC_SANATOR_PROVDIR_CONTRACTING_ENT
WHERE 1=1 
	AND LocationID IN ('4108469')
		OR DBA LIKE '%BALBOA%'

SELECT ' ' AS 'SAMPLE REMIT: BALBOA NEPHROLOGY MEDICAL GROUP',*
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st',DBA
FROM INFORMATICS.dbo.PROV_SANATOR_PROVDIR_CONTRACTING_ENT
WHERE 1=1 
	AND LocationID IN ('4108469')
		OR DBA LIKE '%BALBOA%'

		SELECT ' ' AS 'RANDOM ID DEVELOPMENT', 'DUBC2.0' + CAST(ABS(CAST(CAST(NEWID() AS VARBINARY) AS INT)) AS VARCHAR(20)) AS [RANDOM_ID]
		,RAND(9) AS [RANDOM]

-- ==================================================================
	-- BASELINE eVIPS FAC CHECK(s) --
-- ==================================================================
SELECT DISTINCT ' ' AS 'BASELINE eVIPS FAC CHECK(s)',vlp.ProductName,UPPER(LTRIM(RTRIM(vpl.LocationTypeName))) AS [vplLOCATIONTYPENAME]
,UPPER(LTRIM(RTRIM(vp.PracticeID))) AS [DBAPracticeID]
,UPPER(LTRIM(RTRIM(vp.PracticeName))) AS [DBA]
,DERIVEDFAC.QNXTprovid,DERIVEDFAC.ProviderAlternateID,vpl.PracticeID,vpl.LocationID,vpl.LocationName,vlp.ProductName,UPPER(LTRIM(RTRIM(vlp.InDirectory))) AS [INDIRECTORY],UPPER(LTRIM(RTRIM(vp.Archived))) AS [vpARCHIVED],UPPER(LTRIM(RTRIM(vp.PracticeStatus))) AS [vpPRACTICESTATUS],UPPER(LTRIM(RTRIM(vp.ApplicationStatus))) AS [vpAPPLICATIONSTATUS],UPPER(LTRIM(RTRIM(vpl.Archived))) AS [vplARCHIVED],UPPER(LTRIM(RTRIM(vpl.LocationTypeName))) AS [vplLOCATIONTYPENAME],UPPER(LTRIM(RTRIM(vlp.LocationTypeName))) AS [vlpLOCATIONTYPENAME],UPPER(LTRIM(RTRIM(vlp.Archived))) AS [vlpARCHIVED],UPPER(LTRIM(RTRIM(vlp.StatusTypeName))) AS [vlpSTATUSTYPENAME],UPPER(LTRIM(RTRIM(ISNULL(vlp.ServiceTypeName,'')))) AS [vlpSERVICETYPENAME],CAST(NULL AS nvarchar(5)) AS [providence],CAST(NULL AS nvarchar(100)) AS ID,UPPER(LTRIM(RTRIM(vp.PracticeTypeName))) AS [VP_plan_type],UPPER(LTRIM(RTRIM(vlp.PracticeTypeName))) AS [VLP_plan_type],UPPER(LTRIM(RTRIM(vlp.ProductTypeCode))) AS [VLP_Alt_plan_type],UPPER(LTRIM(RTRIM(vlp.ProductTypeName))) AS [VLP_full_plan_name],UPPER(LTRIM(RTRIM(vp.PracticeTypeName))) AS [plan_type],UPPER(LTRIM(RTRIM(vlp.ProductName))) AS [plan_name],vp.PracticeName,vpl.LocationName,vp.LegalName AS [VPLegalName],vpl.LegalName AS [VPLLegalName]
,UPPER(LTRIM(RTRIM(vpl.LocationName))) AS [HospitalName]
,UPPER(LTRIM(RTRIM(vpl.LocationName))) AS [FacilityName]
,UPPER(LTRIM(RTRIM(vpl.LocationName))) AS [Clinic Name]
,UPPER(LTRIM(RTRIM(vpl.LocationName))) AS [Pharmacy Name] -- We have most of the NPIs for the clinics.  They are located in the NPI field in the address master
,UPPER(LTRIM(RTRIM(vp.PracticeID))) AS [DBAPracticeID]
,UPPER(LTRIM(RTRIM(vp.PracticeName))) AS [DBA]
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
,vpl.LineNumber1,vpl.LineNumber2,vpl.City
,vls.Code1,vls.Code2,vls.Code1 AS [FacilityType],vls.Code2 AS [InstitutionalFacilityType]
,vea.*
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st',
-- SELECT  vlp.Focus,vlsfocus.Code1,vlsfocus.Code2,vp.Archived,vp.PracticeStatus,vp.ApplicationStatus,vpl.Archived,vpl.LocationTypeName,vp.PracticeTypeName,* -- CHECK 1st
-- SELECT * FROM eVips_chgcv.dbo.vwPracticeLocations -- CHECK 1st
-- SELECT DISTINCT PracticeTypeName FROM eVips_chgcv.dbo.vwPracticeLocations -- CHECK 1st UPPER(LTRIM(RTRIM(vpl.PracticeTypeName))) AS [Type of Service]
-- SELECT * FROM eVips_chgcv.dbo.vwEntityAssignments WHERE UPPER(LTRIM(RTRIM(TableName))) LIKE '%Practice%' AND UPPER(LTRIM(RTRIM(EntityName))) LIKE '%MED%IMPA%' -- CHECK 1st
FROM eVips_chgcv.dbo.vwPractices AS vp
	JOIN eVips_chgcv.dbo.vwPracticeLocations AS vpl ON vp.PracticeID = vpl.PracticeID

		LEFT JOIN eVips_chgcv.dbo.vwFacilities AS vf ON vpl.LocationName = vf.FacilityName
			OR vp.PracticeName = vf.FacilityName

		LEFT JOIN 
		( -- INITIATE ...
		SELECT DISTINCT PracticeID,ClassOrCategory, ServiceTypeName,ServiceCategoryTypeName,Code1,Code2,LocationID
		FROM eVips_chgcv.dbo.vwLocationServices 
		WHERE ServiceTypeName 
		LIKE '%GROUP%SPEC%'
		) -- CONCLUDE ...
		AS vls ON vp.PracticeID = vls.PracticeID -- DEFINE FAC CHAPTER(s) 		
		LEFT JOIN 
		( -- INITIATE ...
		SELECT DISTINCT LocationID,PracticeID,ClassOrCategory, ServiceTypeName,ServiceCategoryTypeName,code1,code2 
		FROM eVips_chgcv.dbo.vwLocationServices 
		WHERE UPPER(LTRIM(RTRIM(ServiceTypeName))) LIKE '%PHARM%TYPE%' 
			AND ServiceCategoryTypeName IS NOT NULL 
			AND UPPER(LTRIM(RTRIM(ServiceCategoryTypeName))) != ''
			) -- CONCLUDE ...
			AS vlspharmtype ON vp.PracticeID = vlspharmtype.PracticeID --DEFINE PHARM TYPE(s)
				AND vpl.LocationID = vlspharmtype.LocationID -- per YOUNG LADY LAURA email ON 20171221 ... Products (CMC & MEDICAL)  are stored at Location Level. The code below is joining based only on Practice ID. This should be based on PracticeID + Location

		LEFT JOIN 
		( -- INITIATE ...
		SELECT DISTINCT LocationID,PracticeID,ClassOrCategory, ServiceTypeName,ServiceCategoryTypeName,code1,code2 
		FROM eVips_chgcv.dbo.vwLocationServices 
		WHERE UPPER(LTRIM(RTRIM(ServiceTypeName))) LIKE '%PHARM%SERV%' 
			AND ServiceCategoryTypeName IS NOT NULL 
			AND UPPER(LTRIM(RTRIM(ServiceCategoryTypeName))) != ''
			) -- CONCLUDE ...
			AS vlspharmservice ON vp.PracticeID = vlspharmservice.PracticeID --DEFINE PHARM TYPE(s)
				AND vpl.LocationID = vlspharmservice.LocationID -- per YOUNG LADY LAURA email ON 20171221 ... Products (CMC & MEDICAL)  are stored at Location Level. The code below is joining based only on Practice ID. This should be based on PracticeID + Location
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
		WHERE UPPER(LTRIM(RTRIM(ISNULL(TableName,'')))) LIKE '%PRACTI%'
		) -- CONCLUDE ...
		AS vea ON vp.PracticeID = vea.ProviderID
		LEFT JOIN
		 ( -- INITIATE ...
		SELECT DISTINCT ljvlp.ProductTypeCode,ljvlp.ProductTypeName,ljvlp.PracticeTypeName,ljvlp.PracticeID,ljvlp.LocationID,ljvlp.Archived,ljvlp.StatusTypeName,vlpstype.indirectory,vlpstype.ServiceTypeCode,vlpstype.ServiceTypeName,ljvlp.productname,ljvlp.ProductPanelStatusTypeName,ljvlp.ProductPanelStatusTypeCode,ljvlp.ProviderNumber,ljvlp.Focus,ljvlp.ProductID,ljvlp.LocationTypeName 
		FROM eVips_chgcv.dbo.vwLocationProducts AS ljvlp 
			JOIN evips_chgcv.dbo.vwLocationProductServices AS vlpstype ON ljvlp.LocationProductRecID = vlpstype.LocationProductRecID 
		WHERE ISNULL(ljvlp.Archived,'') IN ('N','') 
			AND (ISNULL(ljvlp.StatusTypeName,'') IN ('ACTIVE','') 
				OR ljvlp.StatusTypeName LIKE '%PARTICIP%')
			AND ISNULL(vlpstype.Archived,'') IN ('N','') 
			) -- CONCLUDE ...
			AS vlp ON vpl.PracticeID = vlp.PracticeID --'YOUNG LADY LAURA GAH ID WHERE p.archived = 'N' AND s.ServiceTypeName = 'HOSPITAL' AND p.focus like '%GAH%'' ON 20171120 see ,UPPER(LTRIM(RTRIM(vlp.ServiceTypeName))) AS [vlpSERVICETYPENAME]
				AND vpl.LocationID = vlp.LocationID -- per YOUNG LADY LAURA email ON 20171221 ... Products (CMC & MEDICAL)  are stored at Location Level. The code below is joining based only on Practice ID. This should be based on PracticeID + Location

		LEFT JOIN 
		( -- INITIATE ...
		SELECT DISTINCT LocationID,PracticeID,AccreditationTypeCode,AccreditationTypeName,Notes 
		FROM eVips_chgcv.dbo.vwLocationAccreditations AS vla 
		WHERE ISNULL(vla.Archived,'') IN ('N','') 
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
		WHERE UPPER(LTRIM(RTRIM(ISNULL(county,'')))) LIKE '%SAN%DIEGO%'
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
WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ...
	AND vp.Archived IN ('N') --WITH eVIPS LOGICAL BINARY OPTION(s) IN USE •	Must not be archived 
	 AND ISNULL(vp.PracticeStatus,'') IN ('ACTIVE','CONTRACTED','NA','') --•	Contract Status must be Active
	AND vpl.Archived IN ('N') --WITH eVIPS LOGICAL BINARY OPTION(s) IN USE •	Must not be archived

	-- AND  vp.Archived IN ('N') --WITH eVIPS LOGICAL BINARY OPTION(s) IN USE •	Must not be archived 
	 -- AND ISNULL(vp.PracticeStatus,'') IN ('ACTIVE','CONTRACTED','NA','') --•	Contract Status must be Active
	 -- AND vpl.Archived IN ('N') --WITH eVIPS LOGICAL BINARY OPTION(s) IN USE •	Must not be archived
	 
	AND vpl.LocationID IN ('4108469')

	--AND LTRIM(RTRIM(vp.NationalProviderID)) IN ('1396873451') -- AS altNPIis 

	--AND REPLACE(UPPER(LTRIM(RTRIM(vf.TaxIDNumber))),'-','') IN ('1396873451') -- AS vfPROVTAXID

	--AND REPLACE(UPPER(LTRIM(RTRIM(vf.TaxIDNumber))),'-','') IN ('1396873451') -- AS [FEID vfPROVTAXID]

	--AND CASE
	--WHEN vpl.NationalProviderID IS NULL
	--	AND UPPER(LTRIM(RTRIM(vf.FacilityStatus))) LIKE 'ACTIVE%'
	--	AND UPPER(LTRIM(RTRIM(vf.ApplicationStatus))) LIKE 'ACTIVE%'
	--THEN LTRIM(RTRIM(vf.NationalProviderID))
	--ELSE LTRIM(RTRIM(vpl.NationalProviderID)) 
	--END IN ('1396873451') -- AS [NPIis]

	--AND vp.LegalName LIKE '%CareClix%'
	--AND vpl.LineNumber1 LIKE '%2888%LOKER%' -- ,vpl.LineNumber2,vpl.City
	
	--AND UPPER(LTRIM(RTRIM(vp.PracticeName))) LIKE '%TELEMED%' -- AS [DBA]

SELECT ' ' AS 'SAMPLE REMIT: BALBOA NEPHROLOGY MEDICAL GROUP',[vplLOCATIONTYPENAME],*
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st', ServiceTypeName,vlpSERVICETYPENAME,vlpLOCATIONTYPENAME,vplLOCATIONTYPENAME
FROM INFORMATICS.dbo.FAC_SANATOR_PROVDIR_CONTRACTING_ENT
WHERE 1=1 
	AND LocationID IN ('4108469')

SELECT ' ' AS 'SAMPLE REMIT: BALBOA NEPHROLOGY MEDICAL GROUP',*
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st',
FROM INFORMATICS.dbo.PROV_SANATOR_PROVDIR_CONTRACTING_ENT
WHERE 1=1 
	AND LocationID IN ('4108469')







JAH 'SYMPHONY Dx v3.1'
		see "FOLLOW-UP  Symphony and CHG 4 19 24 Semi-Monthly Implementation Meeting.msg"
		see "Symphony Flat File Data Dictionary V3.1.xlsx"

-- C002: ADD MEDICAL GROUPS: (ABLE2...,TELEMED2U... + RADY) AND FACILITES (SITES) TO THE PROVIDER SYMPHONY .dat DELIVERABLE DUE: 20240503

x IN SSIS .pkg:

x NOT IN ('AAS','ACSW','ADN','ANP','APRN','ARNP','ASM','AT','AUD','BA','BA-PA','BCABA','BCBA','BCBAD','BCHS','BDS','BPH','BPT','BS','BSN','BSW','CAC','CADC','CBT','CCCA','CCCS','CCDC','CD','CDC','CGC','CHT','CMFT','CMHC','CMT','CN','CNC','CNFA','CNM','CNMNP','CNOR','CNP','CNS','CO','COP','CP','CRNA','CRNFA','CRNP','CSA','CSP','CSRW','CST','CSW','CSWP','DC','DD','DDA-A','DDS','DDS-A','DIPL','DMD','DMIN','DNAP','DNP','DNSP','DO','DOT','DPH','DPM','DPT','DSN','DSW','EAMP','EDD','FNP','GNP','IBCLC','LAC','LCPC','LCSW','LD','LDEM','LDO','LICSW','LM','LMFT','LMHC','LMP','LMSW','LMT','LPC','LPCT','LPN','LPTA','LRT','LSAC','MA','MAC','MAE','MAO','MAS','MB','MBAHM','MBBS','MBS','MC','MCD','MCHMC','MD','MDIV','MED','MFCS','MFT','MHD','MHDL','MHR','MHS','MMFT','MMSC','MN','MOT','MPA','MPH','MPS','MPT','MRC','MS','MSCHR','MSCP','MSD','MSM','MSN','MSO','MSOT','MSP','MSPT','MSS','MSSA','MSSW','MSTCM','MSW','ND','NP','OD','OPA','OPAC','OTC','OTR','PA','PA-C','PhD','PMHNP','PN','PNP','PSYD','PT','PTA','RC','RCSW','RD','RDH','RN','RNFA','RNMN','RNSA','RPH','RPT','RRT','SA','SCD','SLDP','SLP','SSW','SW','TCSW') -- PROFDEG CODE SET FROM SYMPHONY ... 4 	Create a list of codes that are not in the list 	Walter 	5/10/2024 	NEW 

x NOT IN ('AA','ACN','ACSW','ACU','ANT','ARNP','ATHT','AUD','BA','CCO','CHIR','CLD','CLNS','CMH','COE','CPHT','CS','CSW','DEN','DENT','DGA','DH','DIET','DO','DPM','DSA','EFCS','EGR','ELG','EMTB','EMTP','FC','GC','HAD','HADTP','HADTR','IMF','IPH','KEGR','LEP','LM','LMT','LP','LPCC','LPN','LPT','MD','ME','MFT','MGA','MHC','NAT','NC','ND','NMF','NMW','NP','NPF','NRCLS','OCC','OCS','OMS','OP','OPS','ORA','ORT','OS','OT','OTA','OTALP','OTHER','OTLP','PA','PCCI','PCFM','PCSA','PH','PHAO','PHE','PHN','PLT','PLTR','PLTS','PMHN','PMR','POD','PODA','POR','PR','PRO','PSCH','PSY','PSYC','PT','PTA','RCP','RD','RDA','RDH','RDHAP','RDHEF','RN','RPH','RPS','RPSA','RPSY','SA','SLD','SLP','SLPAA','SPA','TC','TLP','VN','VNR') -- PVDRLICCERT CODE SET FROM SYMPHONY ... 4 	Create a list of codes that are not in the list 	Walter 	5/10/2024 	NEW 

SELECT DISTINCT ' ' AS '4 	Create a list of codes that are not in the list 	Walter 	5/10/2024 	NEW ',PractitionerTypeName,TypeOfLicensure
-- SELECT ' ' AS 'CHECK 1st',PractitionerTypeName,TypeOfLicensure,*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM INFORMATICS.dbo.PROV_SANATOR_PROVDIR_CONTRACTING_ENT
WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ... AND ...
	AND TypeOfLicensure NOT IN ('AA','ACN','ACSW','ACU','ANT','ARNP','ATHT','AUD','BA','CCO','CHIR','CLD','CLNS','CMH','COE','CPHT','CS','CSW','DEN','DENT','DGA','DH','DIET','DO','DPM','DSA','EFCS','EGR','ELG','EMTB','EMTP','FC','GC','HAD','HADTP','HADTR','IMF','IPH','KEGR','LEP','LM','LMT','LP','LPCC','LPN','LPT','MD','ME','MFT','MGA','MHC','NAT','NC','ND','NMF','NMW','NP','NPF','NRCLS','OCC','OCS','OMS','OP','OPS','ORA','ORT','OS','OT','OTA','OTALP','OTHER','OTLP','PA','PCCI','PCFM','PCSA','PH','PHAO','PHE','PHN','PLT','PLTR','PLTS','PMHN','PMR','POD','PODA','POR','PR','PRO','PSCH','PSY','PSYC','PT','PTA','RCP','RD','RDA','RDH','RDHAP','RDHEF','RN','RPH','RPS','RPSA','RPSY','SA','SLD','SLP','SLPAA','SPA','TC','TLP','VN','VNR') -- PVDRLICCERT CODE SET FROM SYMPHONY ... 4 	Create a list of codes that are not in the list 	Walter 	5/10/2024 	NEW 

SELECT *
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM 
( -- INITIATE ...
SELECT DISTINCT 'CHGSD_IDENTIFIER_'+REPLACE(REPLACE(REPLACE(LTRIM(RTRIM(CAST( CONVERT(nvarchar(25),TRY_CONVERT(datetime,GETDATE()),120) AS nvarchar(25)))),' ',''),'-',''),':','') AS [FileTableName],'IDENTIFIER' AS [NOTE(S)]
,PractitionerID AS [IDENTIFIER_ID]
,PROVTAXID AS [ENTITY_ID]
,'LICENSE' AS [IDENTIFIER_TYPE] -- PLACEHOLDER FOR OPTIONAL [FIELD]
,CA_License AS [IDENTIFIER_VAL] -- PLACEHOLDER FOR OPTIONAL [FIELD]
,'TRUE' AS [PRIMARY_IND] -- PLACEHOLDER FOR OPTIONAL [FIELD] ... BOOLEAN() aka BINARY() aka TRUE v. FALSE aka 0 1
,TypeOfLicensure AS [TYPE_CD] -- PLACEHOLDER FOR OPTIONAL [FIELD]
,TRY_CONVERT(nvarchar(30),NULL) AS [TYPE] -- PLACEHOLDER FOR OPTIONAL [FIELD]
,TRY_CONVERT(nvarchar(128),NULL) AS [ISSUER] -- PLACEHOLDER FOR OPTIONAL [FIELD]
,TRY_CONVERT(nvarchar(60),NULL) AS [ISSUER_CD] -- PLACEHOLDER FOR OPTIONAL [FIELD]
,'CA' AS [ISSUER_STATE_CD] -- PLACEHOLDER FOR OPTIONAL [FIELD]
,TRY_CONVERT(nvarchar(2),1) AS [STATUS_CD] -- PLACEHOLDER FOR OPTIONAL [FIELD]
,TRY_CONVERT(date,NULL) AS [EFFECTIVE_DT] -- PLACEHOLDER FOR OPTIONAL [FIELD]
,TRY_CONVERT(date,NULL) AS [EXPIRED_DT] -- PLACEHOLDER FOR OPTIONAL [FIELD]
,TRY_CONVERT(varchar(128),NULL) AS [EXPIRED_REASON_CD] -- PLACEHOLDER FOR OPTIONAL [FIELD]
,TRY_CONVERT(date,NULL) AS [ORIGINAL_ISSUE_DT] -- PLACEHOLDER FOR OPTIONAL [FIELD]
,TRY_CONVERT(nvarchar(128),NULL) AS [SECONDARY_IDENTIFIER] -- PLACEHOLDER FOR OPTIONAL [FIELD]
,TRY_CONVERT(binary,NULL) AS [HAS_DEBARRED_MEDICARE_IND] -- PLACEHOLDER FOR OPTIONAL [FIELD] ... BOOLEAN() aka BINARY() aka TRUE v. FALSE aka 0 1
,TRY_CONVERT(binary,NULL) AS [OPT_OUT_IND] -- PLACEHOLDER FOR OPTIONAL [FIELD] ... BOOLEAN() aka BINARY() aka TRUE v. FALSE aka 0 1
,TRY_CONVERT(date,NULL) AS [OPT_OUT_DT] -- PLACEHOLDER FOR OPTIONAL [FIELD]
,TRY_CONVERT(nvarchar(20),NULL) AS [AGGREGATE_AMT] -- PLACEHOLDER FOR OPTIONAL [FIELD]
,TRY_CONVERT(nvarchar(128),NULL) AS [NOTES] -- PLACEHOLDER FOR OPTIONAL [FIELD]
,TRY_CONVERT(nvarchar(128),NULL) AS [COVERAGE_TYPE] -- PLACEHOLDER FOR OPTIONAL [FIELD]
,TRY_CONVERT(nvarchar(128),NULL) AS [MALPRACTICE_DESC] -- PLACEHOLDER FOR OPTIONAL [FIELD]
,TRY_CONVERT(nvarchar(20),NULL) AS [OCCURANCE_AMT] -- PLACEHOLDER FOR OPTIONAL [FIELD]
,TRY_CONVERT(nvarchar(30),NULL) AS [POLICY_NUM] -- PLACEHOLDER FOR OPTIONAL [FIELD]
,TRY_CONVERT(nvarchar(128),NULL) AS [CARRIER_NM] -- PLACEHOLDER FOR OPTIONAL [FIELD]
-- SELECT ' ' AS 'CHECK 1st',CA_License,*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM INFORMATICS.dbo.PROV_SANATOR_PROVDIR_CONTRACTING_ENT
WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ... AND ...
	AND CA_License IS NOT NULL
) -- CONCLUDE ...
AS stxt
WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ... AND ...
	AND TYPE_CD IN ('AA','ACN','ACSW','ACU','ANT','ARNP','ATHT','AUD','BA','CCO','CHIR','CLD','CLNS','CMH','COE','CPHT','CS','CSW','DEN','DENT','DGA','DH','DIET','DO','DPM','DSA','EFCS','EGR','ELG','EMTB','EMTP','FC','GC','HAD','HADTP','HADTR','IMF','IPH','KEGR','LEP','LM','LMT','LP','LPCC','LPN','LPT','MD','ME','MFT','MGA','MHC','NAT','NC','ND','NMF','NMW','NP','NPF','NRCLS','OCC','OCS','OMS','OP','OPS','ORA','ORT','OS','OT','OTA','OTALP','OTHER','OTLP','PA','PCCI','PCFM','PCSA','PH','PHAO','PHE','PHN','PLT','PLTR','PLTS','PMHN','PMR','POD','PODA','POR','PR','PRO','PSCH','PSY','PSYC','PT','PTA','RCP','RD','RDA','RDH','RDHAP','RDHEF','RN','RPH','RPS','RPSA','RPSY','SA','SLD','SLP','SLPAA','SPA','TC','TLP','VN','VNR') -- PVDRLICCERT CODE SET FROM SYMPHONY ... 4 	Create a list of codes that are not in the list 	Walter 	5/10/2024 	NEW 







SELECT FileTableName, [NOTE(S)], ENTITY_ID, ENTITY_TYPE, ORGANIZATION_NM, DBA_NM, FirstName, LastName, MIDDLENAME, PREFIX, SUFFIX, PREFERRED_NM, CREDENTIALS, GENDER_CD, DOB, ETHNICITY_CD, 
                         IS_DECEASED, NOTIFICATION_EMAIL,ATYPICAL_IN, EFFECTIVE_DT, EXPIRED_DT, NO_MEDICAL_DIRECTOR_REASON, PROVIDER_OWNED_ORGANIZATION, EIN, NPI, NPI_TYPE_CD, SSN, PROVIDES_TELEHEALTH_SVCS, 
                         PROVIDES_INHOME_SUPPORT_SVCS, MHP_AREA_OF_EXPERTISE, MHP_PRACTICE_FOCUS, ACADEMIC_DEGREE_CD, URL
FROM 
( -- INITIATE ...
...
) -- CONCLUDE ...
AS stxt

		SELECT TOP 10 ' ' AS 'PROVIDIR TELEHEALTH ONLY SAMPLE: ', DBA,* 
		FROM INFORMATICS.dbo.PROVDIR_PCP
		WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ... AND ...
			AND NPIis IN (SELECT DISTINCT NPI FROM INFORMATICS.dbo.TIMELYACCESS_TELEHEALTH WHERE 1=1 AND [In-Person Appointments] = 'N' )

		SELECT TOP 10 ' ' AS 'TIMELYACCESS TELEHEALTH ONLY SAMPLE: ',[Provider Group / IPA],* 
		-- SELECT DISTINCT [Provider Group / IPA]
		FROM INFORMATICS.dbo.TIMELYACCESS_TELEHEALTH
		WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ... AND ...
			AND [In-Person Appointments] = 'N' 

		SELECT TOP 10 'DEVELOP MEDICAL GROUP(S) aka "ORGANIZATION" AS PROVIDER ... -Value must be "ORGANIZATION", "FACILITY", or "PROVIDER"-Can not be null' AS [MESSAGE(S)],PROVTAXID,DBA -- C002: ADD MEDICAL GROUPS: (ABLE2...,TELEMED2U... + RADY) AND FACILITES (SITES) TO THE PROVIDER SYMPHONY .dat DELIVERABLE DUE: 20240503
		-- ,'Individual' AS [NPI_TYPE_CD]
		,TRY_CONVERT(varchar(10),'2') AS [NPI_TYPE_CD] -- "-Value must be ""1"" or ""2"" -Required unless atypical -Field only populated for Facility or Provider entity type "	Not used	NPI Type Code 2 (A Non-Person) – Organizations other than an individual that render health care services or furnish health care supplies to patients; e.g., hospitals, home health agencies, ambulance companies, health maintenance organizations, durable medical equipment suppliers, pharmacies, group practices.	NPI Type Code 1 (A Person) – Individuals who render health care or furnish health care supplies to patients; e.g., physicians, dentists, nurses, chiropractors, pharmacists, physical therapists. Note: Individuals who have incorporated may also have the corporation obtain an NPI as a Type 2 organization.
		,* 
		FROM INFORMATICS.dbo.FAC_SANATOR_PROVDIR_CONTRACTING_ENT 
		WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ... AND ...
			AND DBA LIKE '%TELEM%'-- MED GROUPS IN ('%ABLE2%','%TELEMED%','RADY') ... IN ('ABLE TO BEHAVIORAL HEALTH SERVICES',''TELEMED2U')
				OR DBA LIKE '%ABLE%TO%' -- MED GROUPS IN ('%ABLE2%','%TELEMED%','RADY') ... IN ('ABLE TO BEHAVIORAL HEALTH SERVICES',''TELEMED2U') 
				OR DBA LIKE '%RADY%'
				OR GETMEDGRP LIKE '%TELEM%'-- MED GROUPS IN ('%ABLE2%','%TELEMED%','RADY') ... IN ('ABLE TO BEHAVIORAL HEALTH SERVICES',''TELEMED2U')
				OR GETMEDGRP LIKE '%ABLE%TO%' -- MED GROUPS IN ('%ABLE2%','%TELEMED%','RADY') ... IN ('ABLE TO BEHAVIORAL HEALTH SERVICES',''TELEMED2U') 
				OR GETMEDGRP LIKE '%RADY%'
		
		SELECT TOP 10 'DEVELOP SITES aka "FACILITY" AS PROVIDER ... -Value must be "ORGANIZATION", "FACILITY", or "PROVIDER"-Can not be null' AS [MESSAGE(S)],PROVTAXID,DBA -- C002: ADD MEDICAL GROUPS: (ABLE2...,TELEMED2U... + RADY) AND FACILITES (SITES) TO THE PROVIDER SYMPHONY .dat DELIVERABLE DUE: 20240503
		-- ,'Individual' AS [NPI_TYPE_CD]
		,TRY_CONVERT(varchar(10),'2') AS [NPI_TYPE_CD] -- "-Value must be ""1"" or ""2"" -Required unless atypical -Field only populated for Facility or Provider entity type "	Not used	NPI Type Code 2 (A Non-Person) – Organizations other than an individual that render health care services or furnish health care supplies to patients; e.g., hospitals, home health agencies, ambulance companies, health maintenance organizations, durable medical equipment suppliers, pharmacies, group practices.	NPI Type Code 1 (A Person) – Individuals who render health care or furnish health care supplies to patients; e.g., physicians, dentists, nurses, chiropractors, pharmacists, physical therapists. Note: Individuals who have incorporated may also have the corporation obtain an NPI as a Type 2 organization.
		,* 
		FROM INFORMATICS.dbo.FAC_SANATOR_PROVDIR_CONTRACTING_ENT 
		WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ... AND ...
			AND DBA NOT LIKE '%TELEM%'-- MED GROUPS IN ('%ABLE2%','%TELEMED%','RADY') ... IN ('ABLE TO BEHAVIORAL HEALTH SERVICES',''TELEMED2U')
			AND DBA NOT LIKE '%ABLE%TO%' -- MED GROUPS IN ('%ABLE2%','%TELEMED%','RADY') ... IN ('ABLE TO BEHAVIORAL HEALTH SERVICES',''TELEMED2U') 
			AND DBA NOT LIKE '%RADY%'
			AND GETMEDGRP NOT LIKE '%TELEM%'-- MED GROUPS IN ('%ABLE2%','%TELEMED%','RADY') ... IN ('ABLE TO BEHAVIORAL HEALTH SERVICES',''TELEMED2U')
			AND GETMEDGRP NOT LIKE '%ABLE%TO%' -- MED GROUPS IN ('%ABLE2%','%TELEMED%','RADY') ... IN ('ABLE TO BEHAVIORAL HEALTH SERVICES',''TELEMED2U') 
			AND GETMEDGRP NOT LIKE '%RADY%'

-- ==================================================================
	-- BASELINE eVIPS PROVIDER CHECK(s) --
-- ==================================================================
SELECT DISTINCT 'BASELINE eVIPS PROVIDER CHECK(s) IF / WHEN YTHE TELEHEALTH ONLY ARE IN THE DIRECTORY' AS [MESSAGE(S)]
,UPPER(LTRIM(RTRIM(vpp.PracticeID))) AS [DBAPracticeID]
,UPPER(LTRIM(RTRIM(vpp.PracticeName))) AS [DBA]
,DERIVEDPROV.QNXTprovid,DERIVEDPROV.ProviderAlternateID,vpp.ProductName,vpd.NationalProviderID,vpps.SpecialtyCode,vpps.SpecialtyName,vpd.LastName,vpd.FirstName,vpps.InDirectory,vpd.Archived,vpps.Archived,vploc.Archived,vpracloc.Archived,vpd.PractitionerStatus,vpp.Archived,vpp.StatusTypeName,vploc.*

-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT * FROM INFORMATICS.dbo.ZIP_CODES -- CHECK 1st
-- SELECT DISTINCT SpecialtyCode,SpecialtyName FROM eVips_chgcv.dbo.vwPractitionerSpecialties ORDER BY SpecialtyCode,SpecialtyName -- CHECK 1st
FROM eVips_chgcv.dbo.vwPractitionerDemographics AS vpd
	JOIN eVips_chgcv.dbo.vwPractitionerProducts AS vpp ON vpd.PractitionerID = vpp.PractitionerID -- aka cert_provider
		-- AND vpp.ProductID = vpps.ProductID -- aka cert_provider
	JOIN eVips_chgcv.dbo.vwPractitionerProductSpecialties AS vpps ON vpp.PractitionerProductRecID = vpps.PractitionerProductRecID
		LEFT JOIN eVips_chgcv.dbo.vwPractitionerSpecialties AS vps ON vpd.PractitionerID = vps.PractitionerID	
			AND vpps.specialtycode = vps.specialtycode
		LEFT JOIN 
		( -- INITIATE ...
		SELECT DISTINCT ProviderID,TableName,EntityCode,EntityName,EntityTypeCode,EntityTypeName 
		FROM eVips_chgcv.dbo.vwEntityAssignments 
		WHERE UPPER(LTRIM(RTRIM(ISNULL(TableName,'')))) LIKE '%PRACTI%'
		) -- CONCLUDE ... 
		AS vea ON vpd.PractitionerID = vea.ProviderID --ProviderID = PractitionerID WHERE UPPER(LTRIM(RTRIM(vea.TableName))) LIKE '%Practit%' OR  ProviderID = PracticeID WHERE UPPER(LTRIM(RTRIM(vea.TableName))) LIKE '%Practice%'
	JOIN ( -- INITIATE ...
	SELECT DISTINCT vpprovloc.PractitionerID,vpprovloc.PracticeID,vpprovloc.LocationID,vpprovloc.AddressID,vpprovloc.LastName,vpprovloc.FirstName,vpprovloc.Archived,vpprovloc.LocationName,vpprovloc.NationalProviderID,vpprovloc.LocationNotes,vpprovloc.PracticeTypeName,vpprovloc.ProviderNumber,vpprovloc.website,vpfacloc.LineNumber1,vpfacloc.LineNumber2,vpfacloc.LineNumber3,vpfacloc.City,vpfacloc.[State],vpfacloc.ZipCode,vpfacloc.LocationTypeName 
	FROM eVips_chgcv.dbo.vwPractitionerLocations AS vpprovloc
		JOIN eVips_chgcv.dbo.vwPracticeLocations AS vpfacloc ON vpprovloc.PracticeID = vpfacloc.PracticeID
			AND vpprovloc.LocationID = vpfacloc.LocationID 
		WHERE UPPER(LTRIM(RTRIM(ISNULL(vpfacloc.LocationTypeName,'')))) LIKE '%PRACTI%'
		) -- CONCLUDE ...
		AS vploc ON vpd.PractitionerID = vploc.PractitionerID
		AND vpp.PracticeID = vploc.PracticeID
		AND vpp.LocationID = vploc.LocationID
		-- AND vpp.AddressID = vploc.AddressID
	JOIN eVips_chgcv.dbo.vwPracticeLocations AS vpracloc ON vpp.practiceid = vpracloc.practiceid  --SPECIAL ADD - ON JOIN(s)
		AND vpp.Locationid = vpracloc.Locationid --SPECIAL ADD - ON JOIN(s)
		LEFT JOIN INFORMATICS.dbo.ZIP_CODES AS zip ON CASE
		WHEN SUBSTRING(LTRIM(RTRIM(vploc.ZipCode)),1,1) = '0'
		THEN '0'+ SUBSTRING(LTRIM(RTRIM(vploc.ZipCode)),2,4)
		WHEN SUBSTRING(LTRIM(RTRIM(vploc.ZipCode)),1,1) = '00'
		THEN '00'+ SUBSTRING(LTRIM(RTRIM(vploc.ZipCode)),3,3)
		ELSE  SUBSTRING(LTRIM(RTRIM(vploc.ZipCode)),1,5) 
		END COLLATE DATABASE_DEFAULT = SUBSTRING(LTRIM(RTRIM(zip.ZipCode)),1,5) COLLATE DATABASE_DEFAULT -- FORMERLY SQL01.DEV_DB.dbo.ZIP_CODES
		LEFT JOIN 
		( -- INITIATE ...
		SELECT DISTINCT zipcode,city,county,RegionTypeName 
		FROM eVips_chgcv.dbo.vwzipcodes 
		WHERE UPPER(LTRIM(RTRIM(ISNULL(county,'')))) LIKE '%SAN%DIEGO%'
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
		WHERE r.tablename IN ('Specialties' )
		AND r.fieldName IN ('Specialty Grouping - Timely Access')
		) -- CONCLUDE ...
		AS profile ON CASE
		WHEN vpps.SpecialtyCode IS NULL
		THEN UPPER(LTRIM(RTRIM(vpps.SpecialtyName)))
		ELSE UPPER(LTRIM(RTRIM(vpps.SpecialtyCode)))
		END = UPPER(LTRIM(RTRIM(ISNULL(profile.specialtycode,'')))) -- AS [DefineOTH_SPE]

		LEFT JOIN 
		( -- INITIATE ...
		SELECT DISTINCT * 
		FROM eVips_chgcv.dbo.vwPractitionerLicenses
		WHERE PrimaryLicense = 'Y'
		-- WHERE qnxt.NPI IN ('1043258429')
		) -- CONCLUDE ...
		AS calic ON vpd.PractitionerID = calic.PractitionerID

		LEFT JOIN ( -- INITIATE ...
		SELECT DISTINCT IDNumber AS [QNXTprovid],IDNumber,ProviderAlternateID,ProviderID,AlternateIDTypeID FROM eVips_chgcv.dbo.vwPractitionerAlternateIDs WHERE UPPER(LTRIM(RTRIM(ISNULL(AlternateIDTypeName,'')))) LIKE '%QNXT%' AND archived = 'N'
		) -- CONCLUDE ...
		AS DERIVEDPROV ON vpd.PractitionerID = DERIVEDPROV.[ProviderID]-- ,UPPER(LTRIM(RTRIM(vpd.PractitionerID))) AS 'lookup_key' DERIVED() ALIASNAME CONCLUDE ...
				
WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ...
	 AND 
	 ( -- INITIATE ... REGULAR PROVIDER 'IN NETWORK / IN DIRECTORY LOGIC'
	 UPPER(LTRIM(RTRIM(vpd.Archived))) IN ('N') --WITH eVIPS LOGICAL BINARY OPTION(s) IN USE •	Must not be archived 
		 AND UPPER(LTRIM(RTRIM(vpps.Archived))) IN ('N') -- ADD ON per MEETING ;WITH YOUNG LADY LAURA, SC & HL ON 20171226
		 AND UPPER(LTRIM(RTRIM(vploc.Archived))) IN ('N') --WITH eVIPS LOGICAL BINARY OPTION(s) IN USE •	Must not be archived
		 AND UPPER(LTRIM(RTRIM(vpracloc.Archived))) IN ('N')
		 AND UPPER(LTRIM(RTRIM(ISNULL(vpd.PractitionerStatus,'')))) IN ('ACTIVE','') --•	Overall Status must be Active
		 AND UPPER(LTRIM(RTRIM(vpp.Archived))) IN ('N') --WITH eVIPS LOGICAL BINARY OPTION(s) IN USE •	Must not be archived 
		 ) -- CONCLUDE ... REGULAR PROVIDER 'IN NETWORK / IN DIRECTORY LOGIC'
		 AND ISNULL(vpp.StatusTypeName,'') IN ('Y','','Active','Active - Per Diem') --•	Plan Status must be: ‘Active’ or ‘Active Per Diem’ or Active VIP for a Product Name (CMC or MEDICAL):

	-- AND UPPER(LTRIM(RTRIM(vpp.PracticeName))) LIKE '%TELEMED2%' -- AS [DBA
	AND UPPER(LTRIM(RTRIM(vpp.PracticeName))) LIKE '%ABLE%TO%' -- AS [DBA]







-- ==================================================================
	-- BASELINE eVIPS FAC CHECK(s) --
-- ==================================================================
SELECT DISTINCT 'BASELINE eVIPS FAC CHECK(s) IF / WHEN YTHE TELEHEALTH ONLY ARE IN THE DIRECTORY' AS [MESSAGE(S)]
,UPPER(LTRIM(RTRIM(vp.PracticeID))) AS [DBAPracticeID]
,UPPER(LTRIM(RTRIM(vp.PracticeName))) AS [DBA]
,DERIVEDFAC.QNXTprovid,DERIVEDFAC.ProviderAlternateID,vpl.PracticeID,vpl.LocationID,vpl.LocationName,vlp.ProductName,UPPER(LTRIM(RTRIM(vlp.InDirectory))) AS [INDIRECTORY],UPPER(LTRIM(RTRIM(vp.Archived))) AS [vpARCHIVED],UPPER(LTRIM(RTRIM(vp.PracticeStatus))) AS [vpPRACTICESTATUS],UPPER(LTRIM(RTRIM(vp.ApplicationStatus))) AS [vpAPPLICATIONSTATUS],UPPER(LTRIM(RTRIM(vpl.Archived))) AS [vplARCHIVED],UPPER(LTRIM(RTRIM(vpl.LocationTypeName))) AS [vplLOCATIONTYPENAME],UPPER(LTRIM(RTRIM(vlp.LocationTypeName))) AS [vlpLOCATIONTYPENAME],UPPER(LTRIM(RTRIM(vlp.Archived))) AS [vlpARCHIVED],UPPER(LTRIM(RTRIM(vlp.StatusTypeName))) AS [vlpSTATUSTYPENAME],UPPER(LTRIM(RTRIM(ISNULL(vlp.ServiceTypeName,'')))) AS [vlpSERVICETYPENAME],CAST(NULL AS nvarchar(5)) AS [providence],CAST(NULL AS nvarchar(100)) AS ID,UPPER(LTRIM(RTRIM(vp.PracticeTypeName))) AS [VP_plan_type],UPPER(LTRIM(RTRIM(vlp.PracticeTypeName))) AS [VLP_plan_type],UPPER(LTRIM(RTRIM(vlp.ProductTypeCode))) AS [VLP_Alt_plan_type],UPPER(LTRIM(RTRIM(vlp.ProductTypeName))) AS [VLP_full_plan_name],UPPER(LTRIM(RTRIM(vp.PracticeTypeName))) AS [plan_type],UPPER(LTRIM(RTRIM(vlp.ProductName))) AS [plan_name],vp.PracticeName,vpl.LocationName,vp.LegalName AS [VPLegalName],vpl.LegalName AS [VPLLegalName]
,UPPER(LTRIM(RTRIM(vpl.LocationName))) AS [HospitalName]
,UPPER(LTRIM(RTRIM(vpl.LocationName))) AS [FacilityName]
,UPPER(LTRIM(RTRIM(vpl.LocationName))) AS [Clinic Name]
,UPPER(LTRIM(RTRIM(vpl.LocationName))) AS [Pharmacy Name] -- We have most of the NPIs for the clinics.  They are located in the NPI field in the address master
,UPPER(LTRIM(RTRIM(vp.PracticeID))) AS [DBAPracticeID]
,UPPER(LTRIM(RTRIM(vp.PracticeName))) AS [DBA]
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
,vpl.LineNumber1,vpl.LineNumber2,vpl.City
,vls.Code1,vls.Code2,vls.Code1 AS [FacilityType],vls.Code2 AS [InstitutionalFacilityType]
,vea.*
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st',
-- SELECT  vlp.Focus,vlsfocus.Code1,vlsfocus.Code2,vp.Archived,vp.PracticeStatus,vp.ApplicationStatus,vpl.Archived,vpl.LocationTypeName,vp.PracticeTypeName,* -- CHECK 1st
-- SELECT * FROM eVips_chgcv.dbo.vwPracticeLocations -- CHECK 1st
-- SELECT DISTINCT PracticeTypeName FROM eVips_chgcv.dbo.vwPracticeLocations -- CHECK 1st UPPER(LTRIM(RTRIM(vpl.PracticeTypeName))) AS [Type of Service]
-- SELECT * FROM eVips_chgcv.dbo.vwEntityAssignments WHERE UPPER(LTRIM(RTRIM(TableName))) LIKE '%Practice%' AND UPPER(LTRIM(RTRIM(EntityName))) LIKE '%MED%IMPA%' -- CHECK 1st
FROM eVips_chgcv.dbo.vwPractices AS vp
	JOIN eVips_chgcv.dbo.vwPracticeLocations AS vpl ON vp.PracticeID = vpl.PracticeID

		LEFT JOIN eVips_chgcv.dbo.vwFacilities AS vf ON vpl.LocationName = vf.FacilityName
			OR vp.PracticeName = vf.FacilityName

		LEFT JOIN 
		( -- INITIATE ...
		SELECT DISTINCT PracticeID,ClassOrCategory, ServiceTypeName,ServiceCategoryTypeName,Code1,Code2,LocationID
		FROM eVips_chgcv.dbo.vwLocationServices 
		WHERE ServiceTypeName 
		LIKE '%GROUP%SPEC%'
		) -- CONCLUDE ...
		AS vls ON vp.PracticeID = vls.PracticeID -- DEFINE FAC CHAPTER(s) 		
		LEFT JOIN 
		( -- INITIATE ...
		SELECT DISTINCT LocationID,PracticeID,ClassOrCategory, ServiceTypeName,ServiceCategoryTypeName,code1,code2 
		FROM eVips_chgcv.dbo.vwLocationServices 
		WHERE UPPER(LTRIM(RTRIM(ServiceTypeName))) LIKE '%PHARM%TYPE%' 
			AND ServiceCategoryTypeName IS NOT NULL 
			AND UPPER(LTRIM(RTRIM(ServiceCategoryTypeName))) != ''
			) -- CONCLUDE ...
			AS vlspharmtype ON vp.PracticeID = vlspharmtype.PracticeID --DEFINE PHARM TYPE(s)
				AND vpl.LocationID = vlspharmtype.LocationID -- per YOUNG LADY LAURA email ON 20171221 ... Products (CMC & MEDICAL)  are stored at Location Level. The code below is joining based only on Practice ID. This should be based on PracticeID + Location

		LEFT JOIN 
		( -- INITIATE ...
		SELECT DISTINCT LocationID,PracticeID,ClassOrCategory, ServiceTypeName,ServiceCategoryTypeName,code1,code2 
		FROM eVips_chgcv.dbo.vwLocationServices 
		WHERE UPPER(LTRIM(RTRIM(ServiceTypeName))) LIKE '%PHARM%SERV%' 
			AND ServiceCategoryTypeName IS NOT NULL 
			AND UPPER(LTRIM(RTRIM(ServiceCategoryTypeName))) != ''
			) -- CONCLUDE ...
			AS vlspharmservice ON vp.PracticeID = vlspharmservice.PracticeID --DEFINE PHARM TYPE(s)
				AND vpl.LocationID = vlspharmservice.LocationID -- per YOUNG LADY LAURA email ON 20171221 ... Products (CMC & MEDICAL)  are stored at Location Level. The code below is joining based only on Practice ID. This should be based on PracticeID + Location
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
		WHERE UPPER(LTRIM(RTRIM(ISNULL(TableName,'')))) LIKE '%PRACTI%'
		) -- CONCLUDE ...
		AS vea ON vp.PracticeID = vea.ProviderID
		LEFT JOIN
		 ( -- INITIATE ...
		SELECT DISTINCT ljvlp.ProductTypeCode,ljvlp.ProductTypeName,ljvlp.PracticeTypeName,ljvlp.PracticeID,ljvlp.LocationID,ljvlp.Archived,ljvlp.StatusTypeName,vlpstype.indirectory,vlpstype.ServiceTypeCode,vlpstype.ServiceTypeName,ljvlp.productname,ljvlp.ProductPanelStatusTypeName,ljvlp.ProductPanelStatusTypeCode,ljvlp.ProviderNumber,ljvlp.Focus,ljvlp.ProductID,ljvlp.LocationTypeName 
		FROM eVips_chgcv.dbo.vwLocationProducts AS ljvlp 
			JOIN evips_chgcv.dbo.vwLocationProductServices AS vlpstype ON ljvlp.LocationProductRecID = vlpstype.LocationProductRecID 
		WHERE ISNULL(ljvlp.Archived,'') IN ('N','') 
			AND (ISNULL(ljvlp.StatusTypeName,'') IN ('ACTIVE','') 
				OR ljvlp.StatusTypeName LIKE '%PARTICIP%')
			AND ISNULL(vlpstype.Archived,'') IN ('N','') 
			) -- CONCLUDE ...
			AS vlp ON vpl.PracticeID = vlp.PracticeID --'YOUNG LADY LAURA GAH ID WHERE p.archived = 'N' AND s.ServiceTypeName = 'HOSPITAL' AND p.focus like '%GAH%'' ON 20171120 see ,UPPER(LTRIM(RTRIM(vlp.ServiceTypeName))) AS [vlpSERVICETYPENAME]
				AND vpl.LocationID = vlp.LocationID -- per YOUNG LADY LAURA email ON 20171221 ... Products (CMC & MEDICAL)  are stored at Location Level. The code below is joining based only on Practice ID. This should be based on PracticeID + Location

		LEFT JOIN 
		( -- INITIATE ...
		SELECT DISTINCT LocationID,PracticeID,AccreditationTypeCode,AccreditationTypeName,Notes 
		FROM eVips_chgcv.dbo.vwLocationAccreditations AS vla 
		WHERE ISNULL(vla.Archived,'') IN ('N','') 
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
		WHERE UPPER(LTRIM(RTRIM(ISNULL(county,'')))) LIKE '%SAN%DIEGO%'
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
	
WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ...
	 AND vp.Archived IN ('N') --WITH eVIPS LOGICAL BINARY OPTION(s) IN USE •	Must not be archived 
	  AND ISNULL(vp.PracticeStatus,'') IN ('ACTIVE','CONTRACTED','NA','') --•	Contract Status must be Active
	  AND vpl.Archived IN ('N') --WITH eVIPS LOGICAL BINARY OPTION(s) IN USE •	Must not be archived

	 AND  vp.Archived IN ('N') --WITH eVIPS LOGICAL BINARY OPTION(s) IN USE •	Must not be archived 
	  AND ISNULL(vp.PracticeStatus,'') IN ('ACTIVE','CONTRACTED','NA','') --•	Contract Status must be Active
	  AND vpl.Archived IN ('N') --WITH eVIPS LOGICAL BINARY OPTION(s) IN USE •	Must not be archived
	 
	-- AND UPPER(LTRIM(RTRIM(vp.PracticeName))) LIKE '%TELEMED2%' -- AS [DBA]
	AND UPPER(LTRIM(RTRIM(vp.PracticeName))) LIKE '%ABLE%TO%' -- AS [DBA]
	
	
	
	
	
	
	
JAH 'SYMPHONY DxF UPDATE'
x 'HOURS':

SELECT StartTime,EndTime
,[24_HOUR_START] = REPLACE(REPLACE(LTRIM(LEFT(CONVERT(VARCHAR(20),CAST(StartTime AS datetime),114),5)),'AM',' AM'),'PM',' PM') --AS [Time in the 12-hour format hh:miAM (or PM) SPACING]
,[24_HOUR_END] = REPLACE(REPLACE(LTRIM(LEFT(CONVERT(VARCHAR(20),CAST(EndTime AS datetime),114),5)),'AM',' AM'),'PM',' PM') --AS [Time in the 12-hour format hh:miAM (or PM) SPACING]
 ,[12_HOUR_START] = REPLACE(REPLACE(LTRIM(RIGHT(CONVERT(VARCHAR(20),CAST(StartTime AS datetime),100),7)),'AM',' AM'),'PM',' PM') --AS [Time in the 12-hour format hh:miAM (or PM) SPACING]
,[12_HOUR_END] = REPLACE(REPLACE(LTRIM(RIGHT(CONVERT(VARCHAR(20),CAST(EndTime AS datetime),100),7)),'AM',' AM'),'PM',' PM') --AS [Time in the 12-hour format hh:miAM (or PM) SPACING]
,* 
FROM evips_chgcv.dbo.vwLocationHours AS vlh
WHERE LTRIM(RTRIM(vlh.DayOfWeekID)) = '1' --SUNDAY
	AND UPPER(LTRIM(RTRIM(ISNULL(vlh.Archived,'')))) NOT IN ('Y')

SELECT 'hh:mm:ss:mmm (24-hour FORMAT) MILITARY TIME(): ' AS ' ', CONVERT(nvarchar(255),TRY_CONVERT(datetime,GETDATE()),114) AS [FIELD_NAME]
SELECT 'yyyy-mm-dd hh:mm:ss (24-hour FORMAT) MILITARY TIME(): ' AS ' ', CONVERT(nvarchar(255),TRY_CONVERT(datetime,GETDATE()),120) AS [FIELD_NAME]
SELECT 'dd mmm yyyy hh:mi:ss:nnn AM/PM: ' AS ' ', CONVERT(nvarchar(255),TRY_CONVERT(datetime,GETDATE()),130) AS [ISLAMIC CALENDAR DATES]

SELECT *
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM 
( -- INITIATE ...
SELECT DISTINCT 'CHGSD_HOURS_'+REPLACE(REPLACE(REPLACE(LTRIM(RTRIM(CAST( CONVERT(nvarchar(25),TRY_CONVERT(datetime,GETDATE()),120) AS nvarchar(25)))),' ',''),'-',''),':','') AS [FileTableName],'HOURS' AS [NOTE(S)]
,PracticeID AS [HOURS_ID]
,LocationID
,TRY_CONVERT(binary,NULL) AS [APPOINTMENT_ONLY_IND] -- PLACEHOLDER FOR OPTIONAL [FIELD] ... BOOLEAN() aka BINARY() aka TRUE v. FALSE aka 0 1
,'SUNDAY' AS [DAY]
,TRY_CONVERT(int,[HOUR_1_START]) AS [START_HOUR]
,TRY_CONVERT(int,[MIN_1_START]) AS [START_MINUTE]
,TRY_CONVERT(int,[HOUR_1_END]) AS [END_HOUR]
,TRY_CONVERT(int,[MIN_1_END]) AS [END_MINUTE]
,TRY_CONVERT(int,NULL) AS [SEQUENCE] -- PLACEHOLDER FOR OPTIONAL [FIELD]
,TRY_CONVERT(date,NULL) AS [EFFECTIVE_DT] -- PLACEHOLDER FOR OPTIONAL [FIELD]
,TRY_CONVERT(date,NULL) AS [EXPIRED_DT] -- PLACEHOLDER FOR OPTIONAL [FIELD]
,TRY_CONVERT(varchar(128),NULL) AS [EXPIRED_REASON_CD] -- PLACEHOLDER FOR OPTIONAL [FIELD]
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM INFORMATICS.dbo.PROV_SANATOR_PROVDIR_CONTRACTING_ENT
WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ... AND ...
	AND ISNULL(CAST(HOUR_1_START AS nvarchar(255)),'IGNORE') != 'IGNORE' -- OMIT / SUPPRESS NULL(S)

UNION 
SELECT DISTINCT 'CHGSD_HOURS_'+REPLACE(REPLACE(REPLACE(LTRIM(RTRIM(CAST( CONVERT(nvarchar(25),TRY_CONVERT(datetime,GETDATE()),120) AS nvarchar(25)))),' ',''),'-',''),':','') AS [FileTableName],'HOURS' AS [NOTE(S)]
,PracticeID AS [HOURS_ID]
,LocationID
,TRY_CONVERT(binary,NULL) AS [APPOINTMENT_ONLY_IND] -- PLACEHOLDER FOR OPTIONAL [FIELD] ... BOOLEAN() aka BINARY() aka TRUE v. FALSE aka 0 1
,'MONDAY' AS [DAY]
,TRY_CONVERT(int,[HOUR_2_START]) AS [START_HOUR]
,TRY_CONVERT(int,[MIN_2_START]) AS [START_MINUTE]
,TRY_CONVERT(int,[HOUR_2_END]) AS [END_HOUR]
,TRY_CONVERT(int,[MIN_2_END]) AS [END_MINUTE]
,TRY_CONVERT(int,NULL) AS [SEQUENCE] -- PLACEHOLDER FOR OPTIONAL [FIELD]
,TRY_CONVERT(date,NULL) AS [EFFECTIVE_DT] -- PLACEHOLDER FOR OPTIONAL [FIELD]
,TRY_CONVERT(date,NULL) AS [EXPIRED_DT] -- PLACEHOLDER FOR OPTIONAL [FIELD]
,TRY_CONVERT(varchar(128),NULL) AS [EXPIRED_REASON_CD] -- PLACEHOLDER FOR OPTIONAL [FIELD]
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM INFORMATICS.dbo.PROV_SANATOR_PROVDIR_CONTRACTING_ENT
WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ... AND ...
	AND ISNULL(CAST(HOUR_2_START AS nvarchar(255)),'IGNORE') != 'IGNORE' -- OMIT / SUPPRESS NULL(S) 

UNION 
SELECT DISTINCT 'CHGSD_HOURS_'+REPLACE(REPLACE(REPLACE(LTRIM(RTRIM(CAST( CONVERT(nvarchar(25),TRY_CONVERT(datetime,GETDATE()),120) AS nvarchar(25)))),' ',''),'-',''),':','') AS [FileTableName],'HOURS' AS [NOTE(S)]
,PracticeID AS [HOURS_ID]
,LocationID
,TRY_CONVERT(binary,NULL) AS [APPOINTMENT_ONLY_IND] -- PLACEHOLDER FOR OPTIONAL [FIELD] ... BOOLEAN() aka BINARY() aka TRUE v. FALSE aka 0 1
,'TUESDAY' AS [DAY]
,TRY_CONVERT(int,[HOUR_3_START]) AS [START_HOUR]
,TRY_CONVERT(int,[MIN_3_START]) AS [START_MINUTE]
,TRY_CONVERT(int,[HOUR_3_END]) AS [END_HOUR]
,TRY_CONVERT(int,[MIN_3_END]) AS [END_MINUTE]
,TRY_CONVERT(int,NULL) AS [SEQUENCE] -- PLACEHOLDER FOR OPTIONAL [FIELD]
,TRY_CONVERT(date,NULL) AS [EFFECTIVE_DT] -- PLACEHOLDER FOR OPTIONAL [FIELD]
,TRY_CONVERT(date,NULL) AS [EXPIRED_DT] -- PLACEHOLDER FOR OPTIONAL [FIELD]
,TRY_CONVERT(varchar(128),NULL) AS [EXPIRED_REASON_CD] -- PLACEHOLDER FOR OPTIONAL [FIELD]
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM INFORMATICS.dbo.PROV_SANATOR_PROVDIR_CONTRACTING_ENT
WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ... AND ...
	AND ISNULL(CAST(HOUR_3_START AS nvarchar(255)),'IGNORE') != 'IGNORE' -- OMIT / SUPPRESS NULL(S)

UNION 
SELECT DISTINCT 'CHGSD_HOURS_'+REPLACE(REPLACE(REPLACE(LTRIM(RTRIM(CAST( CONVERT(nvarchar(25),TRY_CONVERT(datetime,GETDATE()),120) AS nvarchar(25)))),' ',''),'-',''),':','') AS [FileTableName],'HOURS' AS [NOTE(S)]
,PracticeID AS [HOURS_ID]
,LocationID
,TRY_CONVERT(binary,NULL) AS [APPOINTMENT_ONLY_IND] -- PLACEHOLDER FOR OPTIONAL [FIELD] ... BOOLEAN() aka BINARY() aka TRUE v. FALSE aka 0 1
,'WEDNESDAY' AS [DAY]
,TRY_CONVERT(int,[HOUR_4_START]) AS [START_HOUR]
,TRY_CONVERT(int,[MIN_4_START]) AS [START_MINUTE]
,TRY_CONVERT(int,[HOUR_4_END]) AS [END_HOUR]
,TRY_CONVERT(int,[MIN_4_END]) AS [END_MINUTE]
,TRY_CONVERT(int,NULL) AS [SEQUENCE] -- PLACEHOLDER FOR OPTIONAL [FIELD]
,TRY_CONVERT(date,NULL) AS [EFFECTIVE_DT] -- PLACEHOLDER FOR OPTIONAL [FIELD]
,TRY_CONVERT(date,NULL) AS [EXPIRED_DT] -- PLACEHOLDER FOR OPTIONAL [FIELD]
,TRY_CONVERT(varchar(128),NULL) AS [EXPIRED_REASON_CD] -- PLACEHOLDER FOR OPTIONAL [FIELD]
-- SELECT TOP 20 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM INFORMATICS.dbo.PROV_SANATOR_PROVDIR_CONTRACTING_ENT
WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ... AND ...
	AND ISNULL(CAST(HOUR_4_START AS nvarchar(255)),'IGNORE') != 'IGNORE' -- OMIT / SUPPRESS NULL(S)

UNION 
SELECT DISTINCT 'CHGSD_HOURS_'+REPLACE(REPLACE(REPLACE(LTRIM(RTRIM(CAST( CONVERT(nvarchar(25),TRY_CONVERT(datetime,GETDATE()),120) AS nvarchar(25)))),' ',''),'-',''),':','') AS [FileTableName],'HOURS' AS [NOTE(S)]
,PracticeID AS [HOURS_ID]
,LocationID
,TRY_CONVERT(binary,NULL) AS [APPOINTMENT_ONLY_IND] -- PLACEHOLDER FOR OPTIONAL [FIELD] ... BOOLEAN() aka BINARY() aka TRUE v. FALSE aka 0 1
,'THURSDAY' AS [DAY]
,TRY_CONVERT(int,[HOUR_5_START]) AS [START_HOUR]
,TRY_CONVERT(int,[MIN_5_START]) AS [START_MINUTE]
,TRY_CONVERT(int,[HOUR_5_END]) AS [END_HOUR]
,TRY_CONVERT(int,[MIN_5_END]) AS [END_MINUTE]
,TRY_CONVERT(int,NULL) AS [SEQUENCE] -- PLACEHOLDER FOR OPTIONAL [FIELD]
,TRY_CONVERT(date,NULL) AS [EFFECTIVE_DT] -- PLACEHOLDER FOR OPTIONAL [FIELD]
,TRY_CONVERT(date,NULL) AS [EXPIRED_DT] -- PLACEHOLDER FOR OPTIONAL [FIELD]
,TRY_CONVERT(varchar(128),NULL) AS [EXPIRED_REASON_CD] -- PLACEHOLDER FOR OPTIONAL [FIELD]
-- SELECT TOP 20 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM INFORMATICS.dbo.PROV_SANATOR_PROVDIR_CONTRACTING_ENT
WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ... AND ...
	AND ISNULL(CAST(HOUR_5_START AS nvarchar(255)),'IGNORE') != 'IGNORE' -- OMIT / SUPPRESS NULL(S)

UNION 
SELECT DISTINCT 'CHGSD_HOURS_'+REPLACE(REPLACE(REPLACE(LTRIM(RTRIM(CAST( CONVERT(nvarchar(25),TRY_CONVERT(datetime,GETDATE()),120) AS nvarchar(25)))),' ',''),'-',''),':','') AS [FileTableName],'HOURS' AS [NOTE(S)]
,PracticeID AS [HOURS_ID]
,LocationID
,TRY_CONVERT(binary,NULL) AS [APPOINTMENT_ONLY_IND] -- PLACEHOLDER FOR OPTIONAL [FIELD] ... BOOLEAN() aka BINARY() aka TRUE v. FALSE aka 0 1
,'FRIDAY' AS [DAY]
,TRY_CONVERT(int,[HOUR_6_START]) AS [START_HOUR]
,TRY_CONVERT(int,[MIN_6_START]) AS [START_MINUTE]
,TRY_CONVERT(int,[HOUR_6_END]) AS [END_HOUR]
,TRY_CONVERT(int,[MIN_6_END]) AS [END_MINUTE]
,TRY_CONVERT(int,NULL) AS [SEQUENCE] -- PLACEHOLDER FOR OPTIONAL [FIELD]
,TRY_CONVERT(date,NULL) AS [EFFECTIVE_DT] -- PLACEHOLDER FOR OPTIONAL [FIELD]
,TRY_CONVERT(date,NULL) AS [EXPIRED_DT] -- PLACEHOLDER FOR OPTIONAL [FIELD]
,TRY_CONVERT(varchar(128),NULL) AS [EXPIRED_REASON_CD] -- PLACEHOLDER FOR OPTIONAL [FIELD]
-- SELECT TOP 20 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM INFORMATICS.dbo.PROV_SANATOR_PROVDIR_CONTRACTING_ENT
WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ... AND ...
	AND ISNULL(CAST(HOUR_6_START AS nvarchar(255)),'IGNORE') != 'IGNORE' -- OMIT / SUPPRESS NULL(S)

UNION 
SELECT DISTINCT 'CHGSD_HOURS_'+REPLACE(REPLACE(REPLACE(LTRIM(RTRIM(CAST( CONVERT(nvarchar(25),TRY_CONVERT(datetime,GETDATE()),120) AS nvarchar(25)))),' ',''),'-',''),':','') AS [FileTableName],'HOURS' AS [NOTE(S)]
,PracticeID AS [HOURS_ID]
,LocationID
,TRY_CONVERT(binary,NULL) AS [APPOINTMENT_ONLY_IND] -- PLACEHOLDER FOR OPTIONAL [FIELD] ... BOOLEAN() aka BINARY() aka TRUE v. FALSE aka 0 1
,'SATURDAY' AS [DAY]
,TRY_CONVERT(int,[HOUR_7_START]) AS [START_HOUR]
,TRY_CONVERT(int,[MIN_7_START]) AS [START_MINUTE]
,TRY_CONVERT(int,[HOUR_7_END]) AS [END_HOUR]
,TRY_CONVERT(int,[MIN_7_END]) AS [END_MINUTE]
,TRY_CONVERT(int,NULL) AS [SEQUENCE] -- PLACEHOLDER FOR OPTIONAL [FIELD]
,TRY_CONVERT(date,NULL) AS [EFFECTIVE_DT] -- PLACEHOLDER FOR OPTIONAL [FIELD]
,TRY_CONVERT(date,NULL) AS [EXPIRED_DT] -- PLACEHOLDER FOR OPTIONAL [FIELD]
,TRY_CONVERT(varchar(128),NULL) AS [EXPIRED_REASON_CD] -- PLACEHOLDER FOR OPTIONAL [FIELD]
-- SELECT TOP 20 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM INFORMATICS.dbo.PROV_SANATOR_PROVDIR_CONTRACTING_ENT
WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ... AND ...
	AND ISNULL(CAST(HOUR_7_START AS nvarchar(255)),'IGNORE') != 'IGNORE' -- OMIT / SUPPRESS NULL(S)
) -- CONCLUDE ...
AS stxt
-- WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ... AND ...
	-- AND [FileTableName]=? -- USE [PATH]: \\netapp02\IS\Informatics\_Informatics Deliverables\Operations\Projects\SYMPHONY\ OR file://netapp02/IS/Informatics/_Informatics%20Deliverables/Operations/Projects/SYMPHONY/







JAH 'HOSP PRIV OMIT / SUPPRESS'

-- =====================================================================
	-- COMMENT(S) / CHANGELOG: --
-- =====================================================================
-- C001 OMIT / SUPPRESS NON - DELIVERY HOSPITAL AFFILIATION WITHIN THE PROVIDERDIRECTORY ONLY (SAMPLE: VU, LAC, MD	SHARP GROSSMONT HOSPITAL, SHARP MEMORIAL HOSPITAL	1497828255 ) ... FOR THE PURPOSES OF #HOSPRIV [InDirectory] BOOLEAN MEANS THE OPPOSITE 'Y' = EXCLUDE / OMIT /SUPPRESS FORM THE PROVDIR WHILE 'N' = INCLUDE IN THE PROVDIR

SELECT ' ' AS 'DR VU LAC #HOSPPRIV AT SHARP MARY BIRCH'
,'C001 OMIT / SUPPRESS NON - DELIVERY HOSPITAL AFFILIATION WITHIN THE PROVIDERDIRECTORY ONLY (SAMPLE: VU, LAC, MD	SHARP GROSSMONT HOSPITAL, SHARP MEMORIAL HOSPITAL	1497828255 ) ... FOR THE PURPOSES OF #HOSPRIV [InDirectory] BOOLEAN MEANS THE OPPOSITE "Y" = EXCLUDE / OMIT /SUPPRESS FORM THE PROVDIR WHILE "N" = INCLUDE IN THE PROVDIR' AS [MESSAGE(S)]
,INDEXNM,FINALhosp_FULL_NAME,*
FROM INFORMATICS.dbo.PROVDIR_SPE
WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ...
	AND INDEXNM LIKE '%VU%LAC%'
	AND SPEC LIKE '%OB%GYN%'
	-- AND lookup_key IN ('4391768') -- PractitionerID

SELECT TOP 10 InDirectory,InstitutionName,Archived,* FROM eVips_chgcv.dbo.vwPractitionerAppointments WHERE 1=1 AND PractitionerID IN ('4391768') 

-- ===================================================================
	-- 'eVIPS' CHECK ;WITH() ME HOSP Privileges Source Application--
-- ===================================================================
------------------------------------------------------------------------------------------------------------------------
	-- Error Trapping: Check If Permanent Table(s) Already Exist(s) And Drop If Applicable --
------------------------------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS #COVER_FOR_NO_COVG -- SQL Server 2016 and later -- DYNAMIC tmp OR STATIC [TABLE] #TableName is a local temporary table visible only in the current session; #TableName is a GLOBAL temporary table visible to all sessions IN ('TempDB')

SELECT DISTINCT 'Y' AS [USE_HOSPITALIST]
,vpa.InDirectory
,UPPER(LTRIM(RTRIM(vpd.NationalProviderID))) AS ORIGINALnpi
,UPPER(LTRIM(RTRIM(CAST(vpd.LastName AS varchar(255))))) AS ORIGINALlnm
,UPPER(LTRIM(RTRIM(CAST(vpd.FirstName AS varchar(255))))) AS ORIGINALfnm
,UPPER(LTRIM(RTRIM(vpd.PractitionerID))) AS ORIGINALlkup
,UPPER(LTRIM(RTRIM(vpd.PractitionerID))) AS [lookup_key]
,UPPER(LTRIM(RTRIM(vpd.PractitionerID))) AS lky
,UPPER(LTRIM(RTRIM(CAST(vpcp.CoveringPractitionerID AS varchar(25))))) AS [COVERlkup ]
,UPPER(LTRIM(RTRIM(CAST(vpcp.CoveringPhysicianName AS varchar(255))))) AS [COVERNM]
,UPPER(LTRIM(RTRIM(CAST(vpcp.CoveringPractitionerID AS varchar(25))))) AS ALTlky --aka 'COVERlkup'
,UPPER(LTRIM(RTRIM(vpa.InstitutionID))) AS [HOSP_lookup_key]
,CAST(NULL AS varchar(25)) AS HOSPNPI --QUPD
,UPPER(LTRIM(RTRIM(vpa.InstitutionName))) AS [HOSPNM]
,UPPER(LTRIM(RTRIM(vpa.InstitutionName))) AS 'HOSP_name'
,CAST(NULL AS varchar(25)) AS HOSPITAL_ID --QUPD the QNXT provid
,CAST(NULL AS varchar(5)) AS [HOSPABBREV] -- QUPD ;WITH() USE EITHER #WCE [ABBREV] LOGIC
,CAST(NULL AS varchar(25)) AS [NPIhospital] -- QUPD
,CAST(NULL AS varchar(25)) AS [CA_License] -- QUPD
,UPPER(LTRIM(RTRIM(vpa.InstitutionName))) AS [company]
,CAST(NULL AS varchar(5)) AS [providence] -- QUPD ;WITH() USE EITHER #WCE [ABBREV] LOGIC
INTO #COVER_FOR_NO_COVG
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM eVips_chgcv.dbo.vwPractitionerDemographics AS vpd
	JOIN eVips_chgcv.dbo.vwPractitionerCoveringPhysicians AS vpcp ON vpd.PractitionerID = vpcp.PractitionerID -- DIRECT PRIVILEGE(s) DEMO(s)
	JOIN eVips_chgcv.dbo.vwPractitionerAppointments AS vpa ON vpcp.CoveringPractitionerID = vpa.PractitionerID -- FIND / CHARINDEX THE COVERING PRIVILEGE(s)
WHERE UPPER(LTRIM(RTRIM(ISNULL(vpcp.PracticeTypeName,'')))) LIKE '%%' -- ADD ON per DESIRE TO CAPTURE VAL() FOR TIMELYACCESS per JL email ON 20180307 '...It looks like in the PCP file we’re still missing some privileges.  For example, Ali Abdallah is one we looked at this morning and he should have privileges through a covering provider....'
		AND UPPER(LTRIM(RTRIM(vpcp.PracticeCoveringTypeName))) LIKE '%COVER%' --'%SUPER%' -- '%COVER%' --IN ('COVER','COVERING')
		AND UPPER(LTRIM(RTRIM(ISNULL(vpcp.Archived,'')))) IN ('N')  --Per S. Coleman email ON 20171229 '...Some archived Hospital privileges are showing: ...'	
		AND UPPER(LTRIM(RTRIM(ISNULL(vpa.Archived,'')))) IN ('N')  --Per S. Coleman email ON 20171229 '...Some archived Hospital privileges are showing: ...'			
		AND UPPER(LTRIM(RTRIM(vpa.InstitutionName))) NOT LIKE '%INACT%'
		AND UPPER(LTRIM(RTRIM(vpa.InstitutionName))) NOT LIKE '%PEND%'
		AND UPPER(LTRIM(RTRIM(vpa.InstitutionName))) NOT LIKE '%KAISER%'
		AND UPPER(LTRIM(RTRIM(vpa.InstitutionName))) NOT LIKE '%MENIFEE%'
		AND UPPER(LTRIM(RTRIM(vpa.InstitutionName))) NOT LIKE '%NAVAL%'
		AND UPPER(LTRIM(RTRIM(vpa.InstitutionName))) NOT LIKE '%V%A%SAN%DIEGO'
		AND UPPER(LTRIM(RTRIM(vpa.InstitutionName))) NOT LIKE '%NO%PRIV%COV%AGREE%'

UNION -- VERTICAL() STACK DISTINCT()
SELECT DISTINCT 'Y' AS [USE_HOSPITALIST]
,vpa.InDirectory
,UPPER(LTRIM(RTRIM(vpd.NationalProviderID))) AS ORIGINALnpi
,UPPER(LTRIM(RTRIM(CAST(vpd.LastName AS varchar(255))))) AS ORIGINALlnm
,UPPER(LTRIM(RTRIM(CAST(vpd.FirstName AS varchar(255))))) AS ORIGINALfnm
,UPPER(LTRIM(RTRIM(vpd.PractitionerID))) AS ORIGINALlkup
,UPPER(LTRIM(RTRIM(vpd.PractitionerID))) AS [lookup_key]
,UPPER(LTRIM(RTRIM(vpd.PractitionerID))) AS lky
,UPPER(LTRIM(RTRIM(CAST(vpcp.CoveringPractitionerID AS varchar(25))))) AS [COVERlkup ]
,UPPER(LTRIM(RTRIM(CAST(vpcp.CoveringPhysicianName AS varchar(255))))) AS [COVERNM]
,UPPER(LTRIM(RTRIM(CAST(vpcp.CoveringPractitionerID AS varchar(25))))) AS ALTlky --aka 'COVERlkup'
,UPPER(LTRIM(RTRIM(vpa.InstitutionID))) AS [HOSP_lookup_key]
,CAST(NULL AS varchar(25)) AS HOSPNPI --QUPD
,UPPER(LTRIM(RTRIM(vpa.InstitutionName))) AS [HOSPNM]
,UPPER(LTRIM(RTRIM(vpa.InstitutionName))) AS 'HOSP_name'
,CAST(NULL AS varchar(25)) AS HOSPITAL_ID --QUPD the QNXT provid
,CAST(NULL AS varchar(5)) AS [HOSPABBREV] -- QUPD ;WITH() USE EITHER #WCE [ABBREV] LOGIC
,CAST(NULL AS varchar(25)) AS [NPIhospital] -- QUPD
,CAST(NULL AS varchar(25)) AS [CA_License] -- QUPD
,UPPER(LTRIM(RTRIM(vpa.InstitutionName))) AS [company]
,CAST(NULL AS varchar(5)) AS [providence] -- QUPD ;WITH() USE EITHER #WCE [ABBREV] LOGIC
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM eVips_chgcv.dbo.vwPractitionerDemographics AS vpd
	JOIN eVips_chgcv.dbo.vwPractitionerCoveringPhysicians AS vpcp ON vpd.PractitionerID = vpcp.PractitionerID -- DIRECT PRIVILEGE(s) DEMO(s)
	JOIN eVips_chgcv.dbo.vwPractitionerAppointments AS vpa ON vpcp.CoveringPractitionerID = vpa.PractitionerID -- FIND / CHARINDEX THE COVERING PRIVILEGE(s)
WHERE UPPER(LTRIM(RTRIM(ISNULL(vpcp.PracticeTypeName,'')))) LIKE 'AHP%' -- SQL Server 'CARDINALITY','SQL OPTIMIZATION' - NUMBER of elements in a set or other grouping, as a property of that grouping.
		AND UPPER(LTRIM(RTRIM(vpcp.PracticeCoveringTypeName))) LIKE '%COVER%' --'%SUPER%' -- '%COVER%' --IN ('COVER','COVERING')
		AND UPPER(LTRIM(RTRIM(ISNULL(vpcp.Archived,'')))) IN ('N')  --Per S. Coleman email ON 20171229 '...Some archived Hospital privileges are showing: ...'	
		AND UPPER(LTRIM(RTRIM(ISNULL(vpa.Archived,'')))) IN ('N')  --Per S. Coleman email ON 20171229 '...Some archived Hospital privileges are showing: ...'			
		AND UPPER(LTRIM(RTRIM(vpa.InstitutionName))) NOT LIKE '%INACT%'
		AND UPPER(LTRIM(RTRIM(vpa.InstitutionName))) NOT LIKE '%PEND%'
		AND UPPER(LTRIM(RTRIM(vpa.InstitutionName))) NOT LIKE '%KAISER%'
		AND UPPER(LTRIM(RTRIM(vpa.InstitutionName))) NOT LIKE '%MENIFEE%'
		AND UPPER(LTRIM(RTRIM(vpa.InstitutionName))) NOT LIKE '%NAVAL%'
		AND UPPER(LTRIM(RTRIM(vpa.InstitutionName))) NOT LIKE '%V%A%SAN%DIEGO'
		AND UPPER(LTRIM(RTRIM(vpa.InstitutionName))) NOT LIKE '%NO%PRIV%COV%AGREE%'

UNION -- VERTICAL() STACK DISTINCT()
SELECT DISTINCT 'Y' AS [USE_HOSPITALIST]
,vpa.InDirectory
,UPPER(LTRIM(RTRIM(vpd.NationalProviderID))) AS ORIGINALnpi
,UPPER(LTRIM(RTRIM(CAST(vpd.LastName AS varchar(255))))) AS ORIGINALlnm
,UPPER(LTRIM(RTRIM(CAST(vpd.FirstName AS varchar(255))))) AS ORIGINALfnm
,UPPER(LTRIM(RTRIM(vpd.PractitionerID))) AS ORIGINALlkup
,UPPER(LTRIM(RTRIM(vpd.PractitionerID))) AS [lookup_key]
,UPPER(LTRIM(RTRIM(vpd.PractitionerID))) AS lky
,UPPER(LTRIM(RTRIM(CAST(vpcp.CoveringPractitionerID AS varchar(25))))) AS [COVERlkup ]
,UPPER(LTRIM(RTRIM(CAST(vpcp.CoveringPhysicianName AS varchar(255))))) AS [COVERNM]
,UPPER(LTRIM(RTRIM(CAST(vpcp.CoveringPractitionerID AS varchar(25))))) AS ALTlky --aka 'COVERlkup'
,UPPER(LTRIM(RTRIM(vpa.InstitutionID))) AS [HOSP_lookup_key]
,CAST(NULL AS varchar(25)) AS HOSPNPI --QUPD
,UPPER(LTRIM(RTRIM(vpa.InstitutionName))) AS [HOSPNM]
,UPPER(LTRIM(RTRIM(vpa.InstitutionName))) AS 'HOSP_name'
,CAST(NULL AS varchar(25)) AS HOSPITAL_ID --QUPD the QNXT provid
,CAST(NULL AS varchar(5)) AS [HOSPABBREV] -- QUPD ;WITH() USE EITHER #WCE [ABBREV] LOGIC
,CAST(NULL AS varchar(25)) AS [NPIhospital] -- QUPD
,CAST(NULL AS varchar(25)) AS [CA_License] -- QUPD
,UPPER(LTRIM(RTRIM(vpa.InstitutionName))) AS [company]
,CAST(NULL AS varchar(5)) AS [providence] -- QUPD ;WITH() USE EITHER #WCE [ABBREV] LOGIC
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM eVips_chgcv.dbo.vwPractitionerDemographics AS vpd
	JOIN eVips_chgcv.dbo.vwPractitionerCoveringPhysicians AS vpcp ON vpd.PractitionerID = vpcp.PractitionerID -- DIRECT PRIVILEGE(s) DEMO(s)
	JOIN eVips_chgcv.dbo.vwPractitionerAppointments AS vpa ON vpcp.CoveringPractitionerID = vpa.PractitionerID -- FIND / CHARINDEX THE COVERING PRIVILEGE(s)
WHERE UPPER(LTRIM(RTRIM(ISNULL(vpcp.PracticeTypeName,'')))) LIKE 'ANC%' -- SQL Server 'CARDINALITY','SQL OPTIMIZATION' - NUMBER of elements in a set or other grouping, as a property of that grouping.
		AND UPPER(LTRIM(RTRIM(vpcp.PracticeCoveringTypeName))) LIKE '%COVER%' --'%SUPER%' -- '%COVER%' --IN ('COVER','COVERING')
		AND UPPER(LTRIM(RTRIM(ISNULL(vpcp.Archived,'')))) IN ('N')  --Per S. Coleman email ON 20171229 '...Some archived Hospital privileges are showing: ...'	
		AND UPPER(LTRIM(RTRIM(ISNULL(vpa.Archived,'')))) IN ('N')  --Per S. Coleman email ON 20171229 '...Some archived Hospital privileges are showing: ...'			
		AND UPPER(LTRIM(RTRIM(vpa.InstitutionName))) NOT LIKE '%INACT%'
		AND UPPER(LTRIM(RTRIM(vpa.InstitutionName))) NOT LIKE '%PEND%'
		AND UPPER(LTRIM(RTRIM(vpa.InstitutionName))) NOT LIKE '%KAISER%'
		AND UPPER(LTRIM(RTRIM(vpa.InstitutionName))) NOT LIKE '%MENIFEE%'
		AND UPPER(LTRIM(RTRIM(vpa.InstitutionName))) NOT LIKE '%NAVAL%'
		AND UPPER(LTRIM(RTRIM(vpa.InstitutionName))) NOT LIKE '%V%A%SAN%DIEGO'
		AND UPPER(LTRIM(RTRIM(vpa.InstitutionName))) NOT LIKE '%NO%PRIV%COV%AGREE%'

UNION -- VERTICAL() STACK DISTINCT()
SELECT DISTINCT 'Y' AS [USE_HOSPITALIST]
,vpa.InDirectory
,UPPER(LTRIM(RTRIM(vpd.NationalProviderID))) AS ORIGINALnpi
,UPPER(LTRIM(RTRIM(CAST(vpd.LastName AS varchar(255))))) AS ORIGINALlnm
,UPPER(LTRIM(RTRIM(CAST(vpd.FirstName AS varchar(255))))) AS ORIGINALfnm
,UPPER(LTRIM(RTRIM(vpd.PractitionerID))) AS ORIGINALlkup
,UPPER(LTRIM(RTRIM(vpd.PractitionerID))) AS [lookup_key]
,UPPER(LTRIM(RTRIM(vpd.PractitionerID))) AS lky
,UPPER(LTRIM(RTRIM(CAST(vpcp.CoveringPractitionerID AS varchar(25))))) AS [COVERlkup ]
,UPPER(LTRIM(RTRIM(CAST(vpcp.CoveringPhysicianName AS varchar(255))))) AS [COVERNM]
,UPPER(LTRIM(RTRIM(CAST(vpcp.CoveringPractitionerID AS varchar(25))))) AS ALTlky --aka 'COVERlkup'
,UPPER(LTRIM(RTRIM(vpa.InstitutionID))) AS [HOSP_lookup_key]
,CAST(NULL AS varchar(25)) AS HOSPNPI --QUPD
,UPPER(LTRIM(RTRIM(vpa.InstitutionName))) AS [HOSPNM]
,UPPER(LTRIM(RTRIM(vpa.InstitutionName))) AS 'HOSP_name'
,CAST(NULL AS varchar(25)) AS HOSPITAL_ID --QUPD the QNXT provid
,CAST(NULL AS varchar(5)) AS [HOSPABBREV] -- QUPD ;WITH() USE EITHER #WCE [ABBREV] LOGIC
,CAST(NULL AS varchar(25)) AS [NPIhospital] -- QUPD
,CAST(NULL AS varchar(25)) AS [CA_License] -- QUPD
,UPPER(LTRIM(RTRIM(vpa.InstitutionName))) AS [company]
,CAST(NULL AS varchar(5)) AS [providence] -- QUPD ;WITH() USE EITHER #WCE [ABBREV] LOGIC
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM eVips_chgcv.dbo.vwPractitionerDemographics AS vpd
	JOIN eVips_chgcv.dbo.vwPractitionerCoveringPhysicians AS vpcp ON vpd.PractitionerID = vpcp.PractitionerID -- DIRECT PRIVILEGE(s) DEMO(s)
	JOIN eVips_chgcv.dbo.vwPractitionerAppointments AS vpa ON vpcp.CoveringPractitionerID = vpa.PractitionerID -- FIND / CHARINDEX THE COVERING PRIVILEGE(s)
WHERE UPPER(LTRIM(RTRIM(ISNULL(vpcp.PracticeTypeName,'')))) LIKE 'HBP%' -- SQL Server 'CARDINALITY','SQL OPTIMIZATION' - NUMBER of elements in a set or other grouping, as a property of that grouping.
		AND UPPER(LTRIM(RTRIM(vpcp.PracticeCoveringTypeName))) LIKE '%COVER%' --'%SUPER%' -- '%COVER%' --IN ('COVER','COVERING')
		AND UPPER(LTRIM(RTRIM(ISNULL(vpcp.Archived,'')))) IN ('N')  --Per S. Coleman email ON 20171229 '...Some archived Hospital privileges are showing: ...'	
		AND UPPER(LTRIM(RTRIM(ISNULL(vpa.Archived,'')))) IN ('N')  --Per S. Coleman email ON 20171229 '...Some archived Hospital privileges are showing: ...'			
		AND UPPER(LTRIM(RTRIM(vpa.InstitutionName))) NOT LIKE '%INACT%'
		AND UPPER(LTRIM(RTRIM(vpa.InstitutionName))) NOT LIKE '%PEND%'
		AND UPPER(LTRIM(RTRIM(vpa.InstitutionName))) NOT LIKE '%KAISER%'
		AND UPPER(LTRIM(RTRIM(vpa.InstitutionName))) NOT LIKE '%MENIFEE%'
		AND UPPER(LTRIM(RTRIM(vpa.InstitutionName))) NOT LIKE '%NAVAL%'
		AND UPPER(LTRIM(RTRIM(vpa.InstitutionName))) NOT LIKE '%V%A%SAN%DIEGO'
		AND UPPER(LTRIM(RTRIM(vpa.InstitutionName))) NOT LIKE '%NO%PRIV%COV%AGREE%'

UNION -- VERTICAL() STACK DISTINCT()
SELECT DISTINCT 'Y' AS [USE_HOSPITALIST]
,vpa.InDirectory
,UPPER(LTRIM(RTRIM(vpd.NationalProviderID))) AS ORIGINALnpi
,UPPER(LTRIM(RTRIM(CAST(vpd.LastName AS varchar(255))))) AS ORIGINALlnm
,UPPER(LTRIM(RTRIM(CAST(vpd.FirstName AS varchar(255))))) AS ORIGINALfnm
,UPPER(LTRIM(RTRIM(vpd.PractitionerID))) AS ORIGINALlkup
,UPPER(LTRIM(RTRIM(vpd.PractitionerID))) AS [lookup_key]
,UPPER(LTRIM(RTRIM(vpd.PractitionerID))) AS lky
,UPPER(LTRIM(RTRIM(CAST(vpcp.CoveringPractitionerID AS varchar(25))))) AS [COVERlkup ]
,UPPER(LTRIM(RTRIM(CAST(vpcp.CoveringPhysicianName AS varchar(255))))) AS [COVERNM]
,UPPER(LTRIM(RTRIM(CAST(vpcp.CoveringPractitionerID AS varchar(25))))) AS ALTlky --aka 'COVERlkup'
,UPPER(LTRIM(RTRIM(vpa.InstitutionID))) AS [HOSP_lookup_key]
,CAST(NULL AS varchar(25)) AS HOSPNPI --QUPD
,UPPER(LTRIM(RTRIM(vpa.InstitutionName))) AS [HOSPNM]
,UPPER(LTRIM(RTRIM(vpa.InstitutionName))) AS 'HOSP_name'
,CAST(NULL AS varchar(25)) AS HOSPITAL_ID --QUPD the QNXT provid
,CAST(NULL AS varchar(5)) AS [HOSPABBREV] -- QUPD ;WITH() USE EITHER #WCE [ABBREV] LOGIC
,CAST(NULL AS varchar(25)) AS [NPIhospital] -- QUPD
,CAST(NULL AS varchar(25)) AS [CA_License] -- QUPD
,UPPER(LTRIM(RTRIM(vpa.InstitutionName))) AS [company]
,CAST(NULL AS varchar(5)) AS [providence] -- QUPD ;WITH() USE EITHER #WCE [ABBREV] LOGIC
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM eVips_chgcv.dbo.vwPractitionerDemographics AS vpd
	JOIN eVips_chgcv.dbo.vwPractitionerCoveringPhysicians AS vpcp ON vpd.PractitionerID = vpcp.PractitionerID -- DIRECT PRIVILEGE(s) DEMO(s)
	JOIN eVips_chgcv.dbo.vwPractitionerAppointments AS vpa ON vpcp.CoveringPractitionerID = vpa.PractitionerID -- FIND / CHARINDEX THE COVERING PRIVILEGE(s)
WHERE UPPER(LTRIM(RTRIM(ISNULL(vpcp.PracticeTypeName,'')))) LIKE 'PCP%' -- SQL Server 'CARDINALITY','SQL OPTIMIZATION' - NUMBER of elements in a set or other grouping, as a property of that grouping.
		AND UPPER(LTRIM(RTRIM(vpcp.PracticeCoveringTypeName))) LIKE '%COVER%' --'%SUPER%' -- '%COVER%' --IN ('COVER','COVERING')
		AND UPPER(LTRIM(RTRIM(ISNULL(vpcp.Archived,'')))) IN ('N')  --Per S. Coleman email ON 20171229 '...Some archived Hospital privileges are showing: ...'	
		AND UPPER(LTRIM(RTRIM(ISNULL(vpa.Archived,'')))) IN ('N')  --Per S. Coleman email ON 20171229 '...Some archived Hospital privileges are showing: ...'			
		AND UPPER(LTRIM(RTRIM(vpa.InstitutionName))) NOT LIKE '%INACT%'
		AND UPPER(LTRIM(RTRIM(vpa.InstitutionName))) NOT LIKE '%PEND%'
		AND UPPER(LTRIM(RTRIM(vpa.InstitutionName))) NOT LIKE '%KAISER%'
		AND UPPER(LTRIM(RTRIM(vpa.InstitutionName))) NOT LIKE '%MENIFEE%'
		AND UPPER(LTRIM(RTRIM(vpa.InstitutionName))) NOT LIKE '%NAVAL%'
		AND UPPER(LTRIM(RTRIM(vpa.InstitutionName))) NOT LIKE '%V%A%SAN%DIEGO'
		AND UPPER(LTRIM(RTRIM(vpa.InstitutionName))) NOT LIKE '%NO%PRIV%COV%AGREE%'

UNION -- VERTICAL() STACK DISTINCT()
SELECT DISTINCT 'Y' AS [USE_HOSPITALIST]
,vpa.InDirectory
,UPPER(LTRIM(RTRIM(vpd.NationalProviderID))) AS ORIGINALnpi
,UPPER(LTRIM(RTRIM(CAST(vpd.LastName AS varchar(255))))) AS ORIGINALlnm
,UPPER(LTRIM(RTRIM(CAST(vpd.FirstName AS varchar(255))))) AS ORIGINALfnm
,UPPER(LTRIM(RTRIM(vpd.PractitionerID))) AS ORIGINALlkup
,UPPER(LTRIM(RTRIM(vpd.PractitionerID))) AS [lookup_key]
,UPPER(LTRIM(RTRIM(vpd.PractitionerID))) AS lky
,UPPER(LTRIM(RTRIM(CAST(vpcp.CoveringPractitionerID AS varchar(25))))) AS [COVERlkup ]
,UPPER(LTRIM(RTRIM(CAST(vpcp.CoveringPhysicianName AS varchar(255))))) AS [COVERNM]
,UPPER(LTRIM(RTRIM(CAST(vpcp.CoveringPractitionerID AS varchar(25))))) AS ALTlky --aka 'COVERlkup'
,UPPER(LTRIM(RTRIM(vpa.InstitutionID))) AS [HOSP_lookup_key]
,CAST(NULL AS varchar(25)) AS HOSPNPI --QUPD
,UPPER(LTRIM(RTRIM(vpa.InstitutionName))) AS [HOSPNM]
,UPPER(LTRIM(RTRIM(vpa.InstitutionName))) AS 'HOSP_name'
,CAST(NULL AS varchar(25)) AS HOSPITAL_ID --QUPD the QNXT provid
,CAST(NULL AS varchar(5)) AS [HOSPABBREV] -- QUPD ;WITH() USE EITHER #WCE [ABBREV] LOGIC
,CAST(NULL AS varchar(25)) AS [NPIhospital] -- QUPD
,CAST(NULL AS varchar(25)) AS [CA_License] -- QUPD
,UPPER(LTRIM(RTRIM(vpa.InstitutionName))) AS [company]
,CAST(NULL AS varchar(5)) AS [providence] -- QUPD ;WITH() USE EITHER #WCE [ABBREV] LOGIC
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM eVips_chgcv.dbo.vwPractitionerDemographics AS vpd
	JOIN eVips_chgcv.dbo.vwPractitionerCoveringPhysicians AS vpcp ON vpd.PractitionerID = vpcp.PractitionerID -- DIRECT PRIVILEGE(s) DEMO(s)
	JOIN eVips_chgcv.dbo.vwPractitionerAppointments AS vpa ON vpcp.CoveringPractitionerID = vpa.PractitionerID -- FIND / CHARINDEX THE COVERING PRIVILEGE(s)
WHERE UPPER(LTRIM(RTRIM(ISNULL(vpcp.PracticeTypeName,'')))) LIKE 'PS%' -- SQL Server 'CARDINALITY','SQL OPTIMIZATION' - NUMBER of elements in a set or other grouping, as a property of that grouping.
		AND UPPER(LTRIM(RTRIM(vpcp.PracticeCoveringTypeName))) LIKE '%COVER%' --'%SUPER%' -- '%COVER%' --IN ('COVER','COVERING')
		AND UPPER(LTRIM(RTRIM(ISNULL(vpcp.Archived,'')))) IN ('N')  --Per S. Coleman email ON 20171229 '...Some archived Hospital privileges are showing: ...'	
		AND UPPER(LTRIM(RTRIM(ISNULL(vpa.Archived,'')))) IN ('N')  --Per S. Coleman email ON 20171229 '...Some archived Hospital privileges are showing: ...'			
		AND UPPER(LTRIM(RTRIM(vpa.InstitutionName))) NOT LIKE '%INACT%'
		AND UPPER(LTRIM(RTRIM(vpa.InstitutionName))) NOT LIKE '%PEND%'
		AND UPPER(LTRIM(RTRIM(vpa.InstitutionName))) NOT LIKE '%KAISER%'
		AND UPPER(LTRIM(RTRIM(vpa.InstitutionName))) NOT LIKE '%MENIFEE%'
		AND UPPER(LTRIM(RTRIM(vpa.InstitutionName))) NOT LIKE '%NAVAL%'
		AND UPPER(LTRIM(RTRIM(vpa.InstitutionName))) NOT LIKE '%V%A%SAN%DIEGO'
		AND UPPER(LTRIM(RTRIM(vpa.InstitutionName))) NOT LIKE '%NO%PRIV%COV%AGREE%'

UNION -- VERTICAL() STACK DISTINCT()
SELECT DISTINCT 'Y' AS [USE_HOSPITALIST]
,vpa.InDirectory
,UPPER(LTRIM(RTRIM(vpd.NationalProviderID))) AS ORIGINALnpi
,UPPER(LTRIM(RTRIM(CAST(vpd.LastName AS varchar(255))))) AS ORIGINALlnm
,UPPER(LTRIM(RTRIM(CAST(vpd.FirstName AS varchar(255))))) AS ORIGINALfnm
,UPPER(LTRIM(RTRIM(vpd.PractitionerID))) AS ORIGINALlkup
,UPPER(LTRIM(RTRIM(vpd.PractitionerID))) AS [lookup_key]
,UPPER(LTRIM(RTRIM(vpd.PractitionerID))) AS lky
,UPPER(LTRIM(RTRIM(CAST(vpcp.CoveringPractitionerID AS varchar(25))))) AS [COVERlkup ]
,UPPER(LTRIM(RTRIM(CAST(vpcp.CoveringPhysicianName AS varchar(255))))) AS [COVERNM]
,UPPER(LTRIM(RTRIM(CAST(vpcp.CoveringPractitionerID AS varchar(25))))) AS ALTlky --aka 'COVERlkup'
,UPPER(LTRIM(RTRIM(vpa.InstitutionID))) AS [HOSP_lookup_key]
,CAST(NULL AS varchar(25)) AS HOSPNPI --QUPD
,UPPER(LTRIM(RTRIM(vpa.InstitutionName))) AS [HOSPNM]
,UPPER(LTRIM(RTRIM(vpa.InstitutionName))) AS 'HOSP_name'
,CAST(NULL AS varchar(25)) AS HOSPITAL_ID --QUPD the QNXT provid
,CAST(NULL AS varchar(5)) AS [HOSPABBREV] -- QUPD ;WITH() USE EITHER #WCE [ABBREV] LOGIC
,CAST(NULL AS varchar(25)) AS [NPIhospital] -- QUPD
,CAST(NULL AS varchar(25)) AS [CA_License] -- QUPD
,UPPER(LTRIM(RTRIM(vpa.InstitutionName))) AS [company]
,CAST(NULL AS varchar(5)) AS [providence] -- QUPD ;WITH() USE EITHER #WCE [ABBREV] LOGIC
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM eVips_chgcv.dbo.vwPractitionerDemographics AS vpd
	JOIN eVips_chgcv.dbo.vwPractitionerCoveringPhysicians AS vpcp ON vpd.PractitionerID = vpcp.PractitionerID -- DIRECT PRIVILEGE(s) DEMO(s)
	JOIN eVips_chgcv.dbo.vwPractitionerAppointments AS vpa ON vpcp.CoveringPractitionerID = vpa.PractitionerID -- FIND / CHARINDEX THE COVERING PRIVILEGE(s)
WHERE UPPER(LTRIM(RTRIM(ISNULL(vpcp.PracticeTypeName,'')))) LIKE 'SP%' -- SQL Server 'CARDINALITY','SQL OPTIMIZATION' - NUMBER of elements in a set or other grouping, as a property of that grouping.
		AND UPPER(LTRIM(RTRIM(vpcp.PracticeCoveringTypeName))) LIKE '%COVER%' --'%SUPER%' -- '%COVER%' --IN ('COVER','COVERING')
		AND UPPER(LTRIM(RTRIM(ISNULL(vpcp.Archived,'')))) IN ('N')  --Per S. Coleman email ON 20171229 '...Some archived Hospital privileges are showing: ...'	
		AND UPPER(LTRIM(RTRIM(ISNULL(vpa.Archived,'')))) IN ('N')  --Per S. Coleman email ON 20171229 '...Some archived Hospital privileges are showing: ...'			
		AND UPPER(LTRIM(RTRIM(vpa.InstitutionName))) NOT LIKE '%INACT%'
		AND UPPER(LTRIM(RTRIM(vpa.InstitutionName))) NOT LIKE '%PEND%'
		AND UPPER(LTRIM(RTRIM(vpa.InstitutionName))) NOT LIKE '%KAISER%'
		AND UPPER(LTRIM(RTRIM(vpa.InstitutionName))) NOT LIKE '%MENIFEE%'
		AND UPPER(LTRIM(RTRIM(vpa.InstitutionName))) NOT LIKE '%NAVAL%'
		AND UPPER(LTRIM(RTRIM(vpa.InstitutionName))) NOT LIKE '%V%A%SAN%DIEGO'
		AND UPPER(LTRIM(RTRIM(vpa.InstitutionName))) NOT LIKE '%NO%PRIV%COV%AGREE%'

		-- SELECT * FROM #COVER_FOR_NO_COVG	ORDER BY ORIGINALlnm,ORIGINALfnm







-----------------------------------------------------------------------------------------------------------------------
	-- Error Trapping: Check If Permanent Table(s) Already Exist(s) And Drop If Applicable --
------------------------------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS #HOSPpriv -- SQL Server 2016 and later -- DYNAMIC tmp OR STATIC [TABLE] #TableName is a local temporary table visible only in the current session; #TableName is a GLOBAL temporary table visible to all sessions IN ('TempDB')

SELECT DISTINCT 'N' AS [USE_HOSPITALIST]
,vpa.InDirectory
,UPPER(LTRIM(RTRIM(vpd.NationalProviderID))) AS ORIGINALnpi
,UPPER(LTRIM(RTRIM(CAST(vpd.LastName AS varchar(255))))) AS ORIGINALlnm
,UPPER(LTRIM(RTRIM(CAST(vpd.FirstName AS varchar(255))))) AS ORIGINALfnm
,UPPER(LTRIM(RTRIM(vpd.PractitionerID))) AS ORIGINALlkup
,UPPER(LTRIM(RTRIM(vpd.PractitionerID))) AS [lookup_key]
,UPPER(LTRIM(RTRIM(vpd.PractitionerID))) AS lky
,CAST('NA' AS varchar(255)) AS [COVERlkup ] -- DIRECT PRIVILEGE(s)
,CAST('NA' AS varchar(255)) AS [COVERNM] -- DIRECT PRIVILEGE(s)
,CAST('NA' AS varchar(255)) AS ALTlky -- DIRECT PRIVILEGE(s)
,UPPER(LTRIM(RTRIM(vpa.InstitutionID))) AS [HOSP_lookup_key]
,CAST(NULL AS varchar(25)) AS HOSPNPI --QUPD
,UPPER(LTRIM(RTRIM(vpa.InstitutionName))) AS [HOSPNM]
,UPPER(LTRIM(RTRIM(vpa.InstitutionName))) AS 'HOSP_name'
,CAST(NULL AS varchar(25)) AS [HOSPITAL_ID] -- QUPD the QNXT provid
,CAST(NULL AS varchar(5)) AS [HOSPABBREV] -- QUPD ;WITH() USE EITHER #WCE [ABBREV] LOGIC
,CAST(NULL AS varchar(25)) AS [NPIhospital] -- QUPD
,CAST(NULL AS varchar(25)) AS [CA_License] -- QUPD
,UPPER(LTRIM(RTRIM(vpa.InstitutionName))) AS [company]
,CAST(NULL AS varchar(5)) AS [providence] -- QUPD ;WITH() USE EITHER #WCE [ABBREV] LOGIC
INTO #HOSPpriv
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM eVips_chgcv.dbo.vwPractitionerDemographics AS vpd
	JOIN eVips_chgcv.dbo.vwPractitionerAppointments AS vpa ON vpd.PractitionerID = vpa.PractitionerID -- DIRECT PRIVILEGE(s)
WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ...
	AND UPPER(LTRIM(RTRIM(vpa.PositionTypeCode))) IN ('ACIVE','ACTIVE','ADMIT','ATTEND','SENIOR',' ASSOC','COURTESY','PROV','TEMP','HONORARY')  --per S. Coleman via email ON 20160712 (2)	Only show active hospital affiliations with the attached (in red) statuses for practitioners.  Dr. William Pitt CRV San Diego 92120 shows 4 hospitals.  GH & SMHH are archived and should not show.)
	AND UPPER(LTRIM(RTRIM(ISNULL(vpa.Archived,'')))) IN ('N')  --Per S. Coleman email ON 20171229 '...Some archived Hospital privileges are showing: ...'
	AND UPPER(LTRIM(RTRIM(vpa.InstitutionName))) NOT LIKE '%INACT%'
	AND UPPER(LTRIM(RTRIM(vpa.InstitutionName))) NOT LIKE '%PEND%'
	AND UPPER(LTRIM(RTRIM(vpa.InstitutionName))) NOT LIKE '%KAISER%'
	AND UPPER(LTRIM(RTRIM(vpa.InstitutionName))) NOT LIKE '%MENIFEE%'
	AND UPPER(LTRIM(RTRIM(vpa.InstitutionName))) NOT LIKE '%NAVAL%'
	AND UPPER(LTRIM(RTRIM(vpa.InstitutionName))) NOT LIKE '%V%A%SAN%DIEGO'
	AND UPPER(LTRIM(RTRIM(vpa.InstitutionName))) NOT LIKE '%NO%PRIV%COV%AGREE%'
	-- AND vpa.PractitionerID IN ('4391768') -- C001 OMIT / SUPPRESS NON - DELIVERY HOSPITAL AFFILIATION WITHIN THE PROVIDERDIRECTORY ONLY (SAMPLE: VU, LAC, MD	SHARP GROSSMONT HOSPITAL, SHARP MEMORIAL HOSPITAL	1497828255 ) ... FOR THE PURPOSES OF #HOSPRIV [InDirectory] BOOLEAN MEANS THE OPPOSITE 'Y' = OMIT /SUPPRESS FORM THE PROVDIR WHILE 'N' = INCLUDE IN THE PROVDIR
	AND vpa.InDirectory IN ('N') -- C001 OMIT / SUPPRESS NON - DELIVERY HOSPITAL AFFILIATION WITHIN THE PROVIDERDIRECTORY ONLY (SAMPLE: VU, LAC, MD	SHARP GROSSMONT HOSPITAL, SHARP MEMORIAL HOSPITAL	1497828255 ) ... FOR THE PURPOSES OF #HOSPRIV [InDirectory] BOOLEAN MEANS THE OPPOSITE 'Y' = OMIT /SUPPRESS FORM THE PROVDIR WHILE 'N' = INCLUDE IN THE PROVDIR

UNION -- VERTICAL() STACK DISTINCT()
SELECT DISTINCT 'N' AS [USE_HOSPITALIST]
,vpa.InDirectory
,UPPER(LTRIM(RTRIM(vpd.NationalProviderID))) AS ORIGINALnpi
,UPPER(LTRIM(RTRIM(CAST(vpd.LastName AS varchar(255))))) AS ORIGINALlnm
,UPPER(LTRIM(RTRIM(CAST(vpd.FirstName AS varchar(255))))) AS ORIGINALfnm
,UPPER(LTRIM(RTRIM(vpd.PractitionerID))) AS ORIGINALlkup
,UPPER(LTRIM(RTRIM(vpd.PractitionerID))) AS [lookup_key]
,UPPER(LTRIM(RTRIM(vpd.PractitionerID))) AS lky
,CAST('NA' AS varchar(255)) AS [COVERlkup ] -- DIRECT PRIVILEGE(s)
,CAST('NA' AS varchar(255)) AS [COVERNM] -- DIRECT PRIVILEGE(s)
,CAST('NA' AS varchar(255)) AS ALTlky -- DIRECT PRIVILEGE(s)
,UPPER(LTRIM(RTRIM(vpa.InstitutionID))) AS [HOSP_lookup_key]
,CAST(NULL AS varchar(25)) AS HOSPNPI --QUPD
,UPPER(LTRIM(RTRIM(vpa.InstitutionName))) AS [HOSPNM]
,UPPER(LTRIM(RTRIM(vpa.InstitutionName))) AS 'HOSP_name'
,CAST(NULL AS varchar(25)) AS [HOSPITAL_ID] -- QUPD the QNXT provid
,CAST(NULL AS varchar(5)) AS [HOSPABBREV] -- QUPD ;WITH() USE EITHER #WCE [ABBREV] LOGIC
,CAST(NULL AS varchar(25)) AS [NPIhospital] -- QUPD
,CAST(NULL AS varchar(25)) AS [CA_License] -- QUPD
,UPPER(LTRIM(RTRIM(vpa.InstitutionName))) AS [company]
,CAST(NULL AS varchar(5)) AS [providence] -- QUPD ;WITH() USE EITHER #WCE [ABBREV] LOGIC
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM eVips_chgcv.dbo.vwPractitionerDemographics AS vpd
	JOIN eVips_chgcv.dbo.vwPractitionerAppointments AS vpa ON vpd.PractitionerID = vpa.PractitionerID -- DIRECT PRIVILEGE(s)
WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ...
	AND UPPER(LTRIM(RTRIM(vpa.PositionTypeName))) IN ('ACIVE','ACTIVE','ADMIT','ATTEND','SENIOR',' ASSOC','COURTESY','PROV','TEMP','HONORARY')  --per S. Coleman via email ON 20160712 (2)	Only show active hospital affiliations with the attached (in red) statuses for practitioners.  Dr. William Pitt CRV San Diego 92120 shows 4 hospitals.  GH & SMHH are archived and should not show.)
	AND UPPER(LTRIM(RTRIM(ISNULL(vpa.Archived,'')))) IN ('N')  --Per S. Coleman email ON 20171229 '...Some archived Hospital privileges are showing: ...'
	AND UPPER(LTRIM(RTRIM(vpa.InstitutionName))) NOT LIKE '%INACT%'
	AND UPPER(LTRIM(RTRIM(vpa.InstitutionName))) NOT LIKE '%PEND%'
	AND UPPER(LTRIM(RTRIM(vpa.InstitutionName))) NOT LIKE '%KAISER%'
	AND UPPER(LTRIM(RTRIM(vpa.InstitutionName))) NOT LIKE '%MENIFEE%'
	AND UPPER(LTRIM(RTRIM(vpa.InstitutionName))) NOT LIKE '%NAVAL%'
	AND UPPER(LTRIM(RTRIM(vpa.InstitutionName))) NOT LIKE '%V%A%SAN%DIEGO'
	AND UPPER(LTRIM(RTRIM(vpa.InstitutionName))) NOT LIKE '%NO%PRIV%COV%AGREE%'
	-- AND vpa.PractitionerID IN ('4391768') -- C001 OMIT / SUPPRESS NON - DELIVERY HOSPITAL AFFILIATION WITHIN THE PROVIDERDIRECTORY ONLY (SAMPLE: VU, LAC, MD	SHARP GROSSMONT HOSPITAL, SHARP MEMORIAL HOSPITAL	1497828255 ) ... FOR THE PURPOSES OF #HOSPRIV [InDirectory] BOOLEAN MEANS THE OPPOSITE 'Y' = EXCLUDE / OMIT /SUPPRESS FORM THE PROVDIR WHILE 'N' = INCLUDE IN THE PROVDIR
	AND vpa.InDirectory IN ('N') -- C001 OMIT / SUPPRESS NON - DELIVERY HOSPITAL AFFILIATION WITHIN THE PROVIDERDIRECTORY ONLY (SAMPLE: VU, LAC, MD	SHARP GROSSMONT HOSPITAL, SHARP MEMORIAL HOSPITAL	1497828255 ) ... FOR THE PURPOSES OF #HOSPRIV [InDirectory] BOOLEAN MEANS THE OPPOSITE 'Y' = EXCLUDE / OMIT /SUPPRESS FORM THE PROVDIR WHILE 'N' = INCLUDE IN THE PROVDIR
ORDER BY UPPER(LTRIM(RTRIM(vpa.InstitutionName))) -- ADD ON / SORT REQUEST FROM PROVDIR MEETING ON 20180731 see ,UPPER(LTRIM(RTRIM(vpa.InstitutionName))) AS [HOSPNM]

		SELECT ' ' AS 'DR VU LAC OBGYN SAMPLE: ',* FROM #HOSPpriv WHERE 1=1 AND lookup_key IN ('4391768') -- PractitionerID

INSERT INTO #HOSPpriv ([USE_HOSPITALIST],InDirectory,ORIGINALnpi,ORIGINALlnm,ORIGINALfnm,ORIGINALlkup,lookup_key,lky,COVERlkup,COVERNM,ALTlky,HOSP_lookup_key,HOSPNPI,HOSPNM,HOSP_name,HOSPITAL_ID,HOSPABBREV,NPIhospital,CA_License,company,providence)
SELECT DISTINCT [USE_HOSPITALIST],InDirectory,ORIGINALnpi,ORIGINALlnm,ORIGINALfnm,ORIGINALlkup,lookup_key,lky,COVERlkup,COVERNM,ALTlky,HOSP_lookup_key,HOSPNPI,HOSPNM,HOSP_name,HOSPITAL_ID,HOSPABBREV,NPIhospital,CA_License,company,providence
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM #COVER_FOR_NO_COVG AS cc
WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ...
	AND cc.InDirectory IN ('N') -- C001 OMIT / SUPPRESS NON - DELIVERY HOSPITAL AFFILIATION WITHIN THE PROVIDERDIRECTORY ONLY (SAMPLE: VU, LAC, MD	SHARP GROSSMONT HOSPITAL, SHARP MEMORIAL HOSPITAL	1497828255 ) ... FOR THE PURPOSES OF #HOSPRIV [InDirectory] BOOLEAN MEANS THE OPPOSITE 'Y' = EXCLUDE / OMIT /SUPPRESS FORM THE PROVDIR WHILE 'N' = INCLUDE IN THE PROVDIR
	AND cc.COVERlkup IS NOT NULL
	AND LTRIM(RTRIM(cc.COVERlkup)) != ''
	AND UPPER(LTRIM(RTRIM(cc.ORIGINALlkup))) NOT IN -- NO NOT NEGATIVE <> != 
	( -- INITIATE ...
	SELECT DISTINCT UPPER(LTRIM(RTRIM(hp.lookup_key)))
	FROM #HOSPpriv AS hp
	) -- CONCLUDE ...
ORDER BY [HOSPNM] -- ADD ON / SORT REQUEST FROM PROVDIR MEETING ON 20180731 see ,UPPER(LTRIM(RTRIM(vpa.InstitutionName))) AS [HOSPNM]	

		SELECT ' ' AS 'ALL PRIVILEGES SOURCE',* FROM #HOSPpriv WHERE 1=1
		SELECT ' ' AS 'EXCEPTION TO ALL PRIVILEGES SOURCE',* FROM #HOSPpriv WHERE 1=1 AND InDirectory = 'Y'







JAH 'USER DEFINED'
		USE [PATH]: file://netapp02/IS/Informatics/_Informatics%20Deliverables/Audits/DHCS/2023 - 'INFORMATICS  DELIVERABLES + VERSION CTRL' REPLACE() SUBSTITUTE() SPACE(s) ;WITH() '%20' IN 'HYPERLINK()'  / PATH() AS NECESSARY, '/Peer Review' CROSS TRAINING MEDIA

	-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
	-- SELECT DISTINCT TableName,LocationName,PracticeName,Value,PracticeLegalName,LegalName -- CHECK 1st
	FROM eVips_chgcv.dbo.vwUserFields AS ccsu
		JOIN evips_chgcv.dbo.vwPracticeLocations AS ccspl ON ccsu.ParentRecID = ccspl.LocationID
		-- JOIN evips_chgcv.dbo.vwPracticeLocations AS ccspl ON ccsu.ProviderID = ccspl.LocationID
		-- JOIN evips_chgcv.dbo.vwPracticeLocations AS ccspl ON ccsu.ProviderID = ccspl.PracticeID
	
		SELECT TOP 10 * FROM eVips_chgcv.dbo.vwTaxonomies

21. 'May I have you rewrite the script utilizing the Potential Improvements and Code Review suggestions' ... 

x HERE ARE THE KEY SQL 'IMPROVEMENTS' AND 'CHANGES':
        ⏎ Descriptive Comments
				~ Added a header comment section with a description, author, and revision history.
				~ Added comments throughout the script to explain the purpose and logic of various sections.

        ⏎ Variable Declarations
				~ Consolidated variable declarations at the beginning of the script for better readability and maintainability.
				~ Provided descriptive names for variables to enhance code clarity.

        ⏎ #TEMPORARY TABLE CREATION
				~ Created temporary tables with EXPLICIT COLUMN DEFINITIONS for better DATA TYPE CONTROL AND PERFORMANCE optimization.
				~ Added constraints and indexes where applicable for improved query performance.
			
/* CREATE TABLE #temp 
(
    ClaimID INT,
    MemID NVARCHAR(25),
    POS nvarchar(255),
    ProvID INT,
    NPIRendering NVARCHAR(10),
    ProvNm nvarchar(255),
    PayToID INT,
    NPIPayto NVARCHAR(10),
    PayToNm nvarchar(255)
); */

        ⏎ Parameterized Values
				~ Replaced hardcoded values with variables, such as @ProviderLocationCode, to allow for easier modification and reusability.

        ⏎ Error Handling
				~ Implemented error handling techniques, such as checking for null values and handling date conversions, to improve robustness and prevent potential errors.

        ⏎ Performance Optimizations
				~ Used appropriate indexes and join conditions to optimize query performance.
				~ Utilized COLLATE clauses for case-insensitive searches where applicable.

        ⏎ 'Stakeholder (Narrative) PEER CODE REVIEW' ... WITHIN +-3% OF HCT ... '@param CUBE' see MS NOLYN CONTRACTING DELIVERABLE







JAH CHARINDEX() FIND() SEARCH() 'GPT' (GENERATIVE PRE-TRAINED TRANSFORMER) 'LLM' LARGE LANGUAGE MODEL,,'SUBJECT:CHG & Symphony Flat File Format Review FROM:Informatics'
		SELECT 'SANATOR_eVIPS_PROVDIR_STEP03_VIP_...sql @LINE#: 16151' AS [MESSAGE(S)]
		SELECT ' ' AS 'IMPORT FROM "SANATOR_SYMPHONY_Flat_File_Format_Symphony_2022_V2.xlsx"',* FROM INFORMATICS.dbo.[SANATOR_SYMPHONY_DATA_MODELING_MAP]
		SELECT ' ' AS 'DATA MODELING MAP SYMPHONY SITES',lookup_key,LocationID,* FROM INFORMATICS.dbo.FAC_SANATOR_PROVDIR_CONTRACTING_ENT
		SELECT ' ' AS 'DATA MODELING MAP SYMPHONY PROVIDERS',lookup_key,LocationID,* FROM INFORMATICS.dbo.PROV_SANATOR_PROVDIR_CONTRACTING_ENT
		SELECT ' ' AS 'DEPRECATED ORIG. DATA MODELING MAP SYMPHONY PROVIDERS',* FROM INFORMATICS.dbo.SANATOR_PROVDIR_CONTRACTING_ENT -- SQL Server 2016 and later -- DYNAMIC tmp OR 
		-- DROP TABLE IF EXISTS INFORMATICS.dbo.SANATOR_PROVDIR_CONTRACTING_ENT -- SQL Server 2016 and later -- DYNAMIC tmp OR 

		SELECT ' ' AS 'IMPORT FROM "SANATOR_SYMPHONY_Flat_File_Format_Symphony_2022_V2.xlsx"',* FROM INFORMATICS.dbo.[SANATOR_SYMPHONY_DATA_MODELING_MAP] WHERE [Code Look-Up] LIKE '%Lang%'
		-- SELECT DISTINCT [Assigned],[Assigned Fullname],[Assigned email],[Assigned phone],COUNT(DISTINCT(INDEXNM)) AS [PROV(s) COUNT] FROM INFORMATICS.dbo.PROV_SANATOR_PROVDIR_CONTRACTING_ENT GROUP BY [Assigned],[Assigned Fullname],[Assigned email],[Assigned phone]

		SELECT REPLACE(REPLACE(REPLACE(LTRIM(RTRIM(CAST( CONVERT(nvarchar(25),TRY_CONVERT(datetime,GETDATE()),120) AS nvarchar(25)))),' ',''),'-',''),':','') AS [FileTableName]
		SELECT 'CHGSD_PROVIDER_'+REPLACE(REPLACE(REPLACE(LTRIM(RTRIM(CAST( CONVERT(nvarchar(25),TRY_CONVERT(datetime,GETDATE()),120) AS nvarchar(25)))),' ',''),'-',''),':','') AS [FileTableName]
		SELECT 'CHGSD_LOCATION_'+REPLACE(REPLACE(REPLACE(LTRIM(RTRIM(CAST( CONVERT(nvarchar(25),TRY_CONVERT(datetime,GETDATE()),120) AS nvarchar(25)))),' ',''),'-',''),':','') AS [FileTableName]
		-- SELECT 'CHGSD_EDUCATION_'+REPLACE(REPLACE(REPLACE(LTRIM(RTRIM(CAST( CONVERT(nvarchar(25),TRY_CONVERT(datetime,GETDATE()),120) AS nvarchar(25)))),' ',''),'-',''),':','') AS [FileTableName]
		SELECT 'CHGSD_ADDRESS_'+REPLACE(REPLACE(REPLACE(LTRIM(RTRIM(CAST( CONVERT(nvarchar(25),TRY_CONVERT(datetime,GETDATE()),120) AS nvarchar(25)))),' ',''),'-',''),':','') AS [FileTableName]
		SELECT 'CHGSD_ROSTER_'+REPLACE(REPLACE(REPLACE(LTRIM(RTRIM(CAST( CONVERT(nvarchar(25),TRY_CONVERT(datetime,GETDATE()),120) AS nvarchar(25)))),' ',''),'-',''),':','') AS [FileTableName]
		SELECT 'CHGSD_CONTACT_'+REPLACE(REPLACE(REPLACE(LTRIM(RTRIM(CAST( CONVERT(nvarchar(25),TRY_CONVERT(datetime,GETDATE()),120) AS nvarchar(25)))),' ',''),'-',''),':','') AS [FileTableName]
		SELECT 'CHGSD_LANGUAGE_'+REPLACE(REPLACE(REPLACE(LTRIM(RTRIM(CAST( CONVERT(nvarchar(25),TRY_CONVERT(datetime,GETDATE()),120) AS nvarchar(25)))),' ',''),'-',''),':','') AS [FileTableName]
		-- SELECT 'CHGSD_BED_DETAIL_'+REPLACE(REPLACE(REPLACE(LTRIM(RTRIM(CAST( CONVERT(nvarchar(25),TRY_CONVERT(datetime,GETDATE()),120) AS nvarchar(25)))),' ',''),'-',''),':','') AS [FileTableName]
		SELECT 'CHGSD_IDENTIFIER_'+REPLACE(REPLACE(REPLACE(LTRIM(RTRIM(CAST( CONVERT(nvarchar(25),TRY_CONVERT(datetime,GETDATE()),120) AS nvarchar(25)))),' ',''),'-',''),':','') AS [FileTableName]
		SELECT 'CHGSD_HOSPITALAFFILIATION_'+REPLACE(REPLACE(REPLACE(LTRIM(RTRIM(CAST( CONVERT(nvarchar(25),TRY_CONVERT(datetime,GETDATE()),120) AS nvarchar(25)))),' ',''),'-',''),':','') AS [FileTableName]
		SELECT 'CHGSD_NETWORK_'+REPLACE(REPLACE(REPLACE(LTRIM(RTRIM(CAST( CONVERT(nvarchar(25),TRY_CONVERT(datetime,GETDATE()),120) AS nvarchar(25)))),' ',''),'-',''),':','') AS [FileTableName]
		SELECT 'CHGSD_TAXONOMY_'+REPLACE(REPLACE(REPLACE(LTRIM(RTRIM(CAST( CONVERT(nvarchar(25),TRY_CONVERT(datetime,GETDATE()),120) AS nvarchar(25)))),' ',''),'-',''),':','') AS [FileTableName]
		SELECT 'CHGSD_HOURS_'+REPLACE(REPLACE(REPLACE(LTRIM(RTRIM(CAST( CONVERT(nvarchar(25),TRY_CONVERT(datetime,GETDATE()),120) AS nvarchar(25)))),' ',''),'-',''),':','') AS [FileTableName]

		USE [PATH]: file:///C:/Users/wcarr/Documents/VISUAL_STUDIO_2013_INFORMATICS/Informatics/ - 'INDEX: VISUAL STUDIO' [Informatics.sln]
		USE [PATH]: file://netapp02/IS/Informatics/_Informatics%20Deliverables/Operations/Projects/SYMPHONY/ - 'OUTPUT DELIMITED BY ~ .dat .txt FILE(S) ... see "DATA_MODELING_MAP_SANATR_SYMPHONY_...sql"'
		
		SELECT 
		TRY_CONVERT(nvarchar(25),NULL) AS [OPTIONAL_COL] -- PLACEHOLDER FOR OPTIONAL [FIELD]
		,TRY_CONVERT(binary,NULL) AS [OPTIONAL_COL] -- PLACEHOLDER FOR OPTIONAL [FIELD] ... BOOLEAN() aka BINARY() aka TRUE v. FALSE aka 0 1
		,TRY_CONVERT(decimal(9,1),69.69) AS [OPTIONAL_COL] -- PLACEHOLDER FOR OPTIONAL [FIELD] ... int()
		,TRY_CONVERT(money,NULL) AS [OPTIONAL_COL] -- PLACEHOLDER FOR OPTIONAL [FIELD]
		,TRY_CONVERT(int,NULL) AS [OPTIONAL_COL] -- PLACEHOLDER FOR OPTIONAL [FIELD]
		,TRY_CONVERT(date,NULL) AS [EFFECTIVE_DT] -- PLACEHOLDER FOR OPTIONAL [FIELD]
		,TRY_CONVERT(date,NULL) AS [EXPIRED_DT] -- PLACEHOLDER FOR OPTIONAL [FIELD]
		,TRY_CONVERT(varchar(128),NULL) AS [EXPIRED_REASON_CD] -- PLACEHOLDER FOR OPTIONAL [FIELD]
		
x DEPLOY TO: '/SSISDB/ReportData/Symphony' IN [SQLPROD02] -- CROSS SERVER SSA EXEC;
-- x DEPLOY TO: '/SSISDB/Symphony/Symphony' IN [SQLPRODAPP01]
		AUTOMATE / SCHEDULE FOR THE 1st AND 3rd FRIDAY OF EACH MONTH
		
x SSIS [eMAIL]: 
The CHG & Symphony Flat File have been refreshed & are ready for review / upload: file://netapp02/IS/Informatics/_Informatics%20Deliverables/Operations/Projects/SYMPHONY/ - 'OUTPUT DELIMITED BY ~ .dat .txt FILE(S) '
		
		PROD FTP Link: USE https://ftp.availity.com/
		
		QA FTP Link: USE https://qa-ftp.availity.com/
		
		INTERNAL REVIEW Link: USE file://fileserver01/Corporate%20Shared%20Drive/Information%20Systems/Informatics/WCarr/PROVIDERDIRECTORY/SANATOR_DATA.xlsx

JAH 'SYMPHONY ACCESS' ON 20230908
x Hi Walter,

Your 'symphony Availity FTP Secure Transport QA & PROD' accounts have been completed. You will be required to change your passwords upon your first login. Please NOTE – when copying the password, it might pick up a space at the end. A trick to avoid this is to copy the password into a notepad first, then copy from there into FTP. Please let me know if you have any questions.

Sincerely,

Kelsey Pietrykowski
Program Manager, Health Plan Delivery Services
Availity | 5555 Gate Parkway, Ste 110 | Jacksonville, FL 32256 
C 812.571.0263
Kelsey.Pietrykowski@availity.com
signature_481913982

Text
Description automatically generated We’re Great Place to Work-Certified™!
Click here to learn what makes our company culture great!

The information contained in this e-mail may be privileged and confidential under applicable law. It is intended solely for the use of the person or firm named above. If the reader of this e-mail is not the intended recipient, please notify us immediately by returning the e-mail to the originating e-mail address. Availity, LLC is not responsible for errors or omissions in this e-mail message. Any personal comments made in this e-mail do not reflect the views of Availity, LLC.







JAH 'Claude.ai ChatGPT BARD' ON 20231002 - Automating .dat File Uploads to FTP with Python ^ Python script to upload .dat files to Availity FTP

May I have you write a python script to automate the upload of .dat files to the following FTP site https://ftp.availity.com/

Sure, here is a Python script to automate the upload of .dat files to the Availity FTP site:

		⏎ #BARD Python
	
import ftplib
import os

# Define the FTP connection parameters
FTP_HOST = "ftp.availity.com"
FTP_USER = "YOUR_FTP_USERNAME"
FTP_PASS = "YOUR_FTP_PASSWORD"
FTP_REMOTE_DIR = "/incoming/"

# Get a list of all .dat files in the local directory
local_dir = os.getcwd()
dat_files = [f for f in os.listdir(local_dir) if f.endswith(".dat")]

# Connect to the FTP server
ftp = ftplib.FTP(FTP_HOST)
ftp.login(FTP_USER, FTP_PASS)

# Change to the remote directory
ftp.cwd(FTP_REMOTE_DIR)

# Upload each .dat file
for dat_file in dat_files:
    with open(dat_file, "rb") as f:
        ftp.storbinary(f"STOR {dat_file}", f)

# Close the FTP connection
ftp.quit()

# Print a success message
print("All .dat files uploaded successfully!")

Use code with caution. Learn more
To use this script, simply save it as a .py file and run it from the command line. The script will connect to the Availity FTP site, upload all of the .dat files in the current directory, and then close the connection.

Here is an example of how to use the script:

python upload_dat_files.py
This will upload all of the .dat files in the current directory to the Availity FTP site.

You can also schedule the script to run regularly using a cron job. This will ensure that your .dat files are always up-to-date on the Availity FTP site.

Bard may display inaccurate or offensive information that doesn’t represent Google’s views. Bard Privacy Notice

		⏎ #BARD PYTHON

import ftplib
import os

# Define the FTP connection parameters
FTP_HOST = "ftp.availity.com"
FTP_USER = "YOUR_FTP_USERNAME"
FTP_PASS = "YOUR_FTP_PASSWORD"

# Define the local directory containing the .dat files to upload
LOCAL_DIR = "/path/to/local/directory"

# Connect to the FTP server
ftp = ftplib.FTP(FTP_HOST, FTP_USER, FTP_PASS)

# Change to the desired directory on the FTP server
ftp.cwd("/path/to/remote/directory")

# Get a list of the .dat files in the local directory
file_list = os.listdir(LOCAL_DIR)

# Upload each .dat file to the FTP server
for filename in file_list:
    if filename.endswith(".dat"):
        with open(os.path.join(LOCAL_DIR, filename), "rb") as f:
            ftp.storbinary(f"STOR {filename}", f)

# Close the FTP connection
ftp.quit()

Use code with caution. Learn more
To use this script, you will need to replace the YOUR_FTP_USERNAME and YOUR_FTP_PASSWORD placeholders with your own Availity FTP credentials. You will also need to replace the /path/to/local/directory and /path/to/remote/directory placeholders with the local directory containing the .dat files to upload and the remote directory on the Availity FTP server where you want to upload them.

Once you have updated the script with your own information, you can run it by typing the following command in a terminal:

python ftp_upload.py
This will connect to the Availity FTP server, change to the specified directory, and upload all of the .dat files in the specified local directory.

Bard may display inaccurate or offensive information that doesn’t represent Google’s views. Bard Privacy Notice







Automating .dat File Uploads to FTP with Python

EH
May I have you write a python script to automate the upload of .dat files to the following FTP site https://ftp.availity.com/

Claude can NOT visit links. Responses may contain hallucination.
EH

Here is a Python script that can automate uploading .dat files to an FTP server:

#python

Copy code

		⏎ #Claude.ai PYTHON
import ftplib
import os

FTP_HOST = 'ftp.availity.com'
FTP_USER = 'your_username'
FTP_PASS = 'your_password' 

dat_files = []

# Get list of .dat files in current directory
for file in os.listdir('.'):
    if file.endswith('.dat'):
        dat_files.append(file)

print(f'Found {len(dat_files)} .dat files')

with ftplib.FTP(FTP_HOST, FTP_USER, FTP_PASS) as ftp:
    for file in dat_files:
        with open(file, 'rb') as f:
            ftp.storbinary(f'STOR {file}', f) 
            print(f'Uploaded {file}')

print('Done uploading .dat files to FTP.')

To use this, you would need to update the FTP_USER and FTP_PASS with your actual credentials. It searches the current directory for any .dat files, opens each one to upload in binary mode, and prints out status messages so you can see the progress.

The key steps are:

		⏎ Import ftplib and os libraries
		⏎ Set FTP connection details
		⏎ Get list of .dat files
		⏎ Connect to FTP server
		⏎ Loop through each file, open and upload it
		⏎ Let me know if you have any other questions!

Let me know if you need any clarification or have additional requirements for the script! I can modify it as needed.

Copy
Retry

No file chosen

		⏎ to send, shift + ⏎ to add a new line, Ctrl + K to create a new chat

-- ============================================================
	-- HUNT FOR DEPENDENCIES ---
-- ============================================================
USE [INFORMATICS] -- EXEC IN [SERVERname]; SCHEMA() SELECT * FROM 'SERVERname'.'DATABASEname'.'SCHEMAname'.'OBJECTname' - FOUR (4) PART() SCHEMA() aka [SERVERname].[DATABASEname].[SCHEMAname].[OBJECTname] - see '[SQL13].[CHGAPP_PROD].dbo.[tblEDIDHCSType834]' PERHAPS AID IN RESOLVING RUNTIME ISSUE??? AS OF 20180808 Thanks for sending this. Something occurred to me last night.  Allyson was having a similar issue because she as connected to the master database when she was executing her query.  She was doing the same as you…pulling data from HMOPROD_PlanData and writing it to Informatics.  But she was executing from the master database.  And I think I saw last night that you might have been doing the same thing.  And I think your default database on SQLPROD02 might be master.  Do you recall which database you were connected to?  Jeremy

DECLARE @sp AS nvarchar(255)

SET @sp = N'dbo.SANATOR_PROVDIR_CONTRACTING_ENT'

SELECT DISTINCT ' ' AS 'Objects that DEPEND upon [@sp]',
    referencing_schema_name, 
    referencing_entity_name
FROM sys.dm_sql_referencing_entities(@sp, 'OBJECT')

SELECT DISTINCT ' ' AS 'Objects on which [@sp] DEPENDS',
    referenced_schema_name, 
    referenced_entity_name
FROM sys.dm_sql_referenced_entities(@sp, 'OBJECT')

SELECT DISTINCT ' ' AS 'Objects on which [@sp] DEPENDS',
    referenced_schema_name, 
    referenced_entity_name
FROM sys.sql_expression_dependencies
WHERE referencing_id = OBJECT_ID(@sp)

SELECT ' ' AS 'DEPENDENCIES',
    referencing_schema_name, 
    referencing_entity_name,
    referencing_id, 
    referencing_class_desc, 
    is_caller_dependent
FROM sys.dm_sql_referencing_entities ('DiabeticPopulation', 'TABLE');







JAH THANK YOU JAH 'Claude.ai ChatGPT GEMINI was BARD GROK' ON 20240304 - Updating an HMO Provider Directory with a Sequence of Image Attachments

EH
6
PROVDIR_ICF 001.png
PROVDIR_ICF 002.png
PROVDIR_ICF 003.png
PROVDIR_ICF 004.png
PROVDIR_ICF 005.png

EH
May I have you create a meeting agenda to update the Enterprise HMO public facing Provider Directory using the attached images sequence by the file name suffix # 001 as an example.

Based on the sequence of images provided, I can create a meeting agenda to discuss updating the Enterprise HMO public facing Provider Directory. However, I must be careful not to reproduce any copyrighted material directly from the images. I will provide an overview and summary of the key points instead.

Meeting Agenda: Updating Enterprise Medi-Cal Provider Directory

		⏎ Review current Provider Directory data sources
				~ Examine existing data sources such as SQL databases, Excel files, and Provider Directory files 

		⏎ Identify tables and data to include in the updated Provider Directory
				~ Analyze tables and data elements from the main database
				~ ADD ICF

		⏎ Data linking and integration approach
				~ Discuss options for linking and combining data from multiple sources (Images 2 and 3)

		⏎ Testing and validation
				~ Plan testing strategies to validate the updated Provider Directory
				~ Discuss peer review, sample data checks, and user acceptance testing

		⏎ Deployment and rollout
				~ Outline the deployment process to make the updated directory publicly accessible
				~ Coordinate with relevant teams for technical implementation and marketing/communications








Evaluate pasting data as linked tables or appending to existing tables
Export and publishing options
Review methods to export the integrated Provider Directory data (Image 3)
Discuss formats like Access Database, Excel, PDF, or HTML for publishing

Please note that I have summarized the key points without directly reproducing any copyrighted content from the images. Let me know if you need any clarification or have additional requirements for the agenda.

Copy


------------------------------------------------------------------------------------------------------------------------ -- Error Trapping: Check If Permanent Table(s) Already Exist(s) And Drop If A
PASTED
EH
May I have you DECIPHER, SIMPLIFY, SUMMARIZE, EXAMINE, EXPLAIN AND INTERPRET the concept deployed IN the attached. PLEASE PROVIDE a detailed report suitable for PEER CODE REVIEW

The attached code appears to be a SQL script that creates and populates a table named PROVDIR_ICF in the INFORMATICS.dbo database schema. This table is intended to store information about Intermediate Care Facilities (ICF) for a Provider Directory. Here is a detailed explanation of the code:

Table Creation
The script first checks if the PROVDIR_ICF table already exists and drops it if present.
It then creates a new table PROVDIR_ICF with various columns such as NPIis, Specialty, Accessibility, Address, Telephone Number, Clinic QNXT provid, and several other columns related to provider and facility information.
The table is populated by selecting data from the TimelyAccessFAC table, applying filters to include only records related to "INTERMEDIATE CARE FACILITIES".
Data Cleanup and Normalization
The script performs several UPDATE operations on the PROVDIR_ICF table to handle null values and apply default values for certain columns like Accessibility and Accessibility Category(ies).
It also removes any records where the TESTING column is null.
Chapter Count Calculation
The script creates a temporary table #COUNT_ICF to calculate the number of unique facilities/centers for each Participating Network.
It then updates the CHAPTER_COUNT column in the PROVDIR_ICF table with a formatted string indicating the number of facilities/centers available for each Participating Network.
Hospital Abbreviation and Full Name Processing
The script updates the HOSP1, HOSP2, ..., HOSP5 columns with the hospital abbreviations (HOSPabbrev) from the TimelyAccessFAC table, ensuring that duplicates are not inserted.
It also populates the HOSP_FULL_NAME1, HOSP_FULL_NAME2, ..., HOSP_FULL_NAME5 columns with the full hospital names from the TimelyAccessFAC table, again avoiding duplicates.
Finally, it concatenates the unique hospital abbreviations and full names into the FINALhosp and FINALhosp_FULL_NAME columns, respectively.
Data Formatting and Transformation
Throughout the script, there are various string manipulations and formatting operations performed on columns like CSZ, Telephone Number, PROVNM, and others to ensure consistent formatting.
Default Values and Placeholders
The script assigns default values or placeholders to certain columns like BOARD CERTIFIED, ACCEPTING NEW PATIENTS, Office Hour(s), ACCESS BY PUBLIC TRANSPORTATION, DEGREE DESCRIPTION, and others.
The overall purpose of this script seems to be to extract and transform data from the TimelyAccessFAC table, clean and normalize the data, and populate the PROVDIR_ICF table with the necessary information for Intermediate Care Facilities to be included in a Provider Directory. The script incorporates various data manipulation and formatting techniques to ensure consistency and readability of the output.

It's important to note that this is a complex script, and a thorough code review should be performed to ensure its correctness and efficiency, especially when dealing with large datasets. Additionally, proper error handling, input validation, and performance optimization techniques should be implemented as needed.

Copy


EH
Thank you

You're welcome!

Copy



Claude can make mistakes. Please double-check responses.

2 messages remaining until 8 PM
Subscribe to Pro


No file chosen

3 Sonnet
Use shift + return for new line







-- ===============================================================================
	-- ICF/DD = Intermediate Care Facility for Developmentally Disabled Transition RENDERING / PAYTO --
-- ===============================================================================
SELECT DISTINCT ' ' AS 'ICF/DD = Intermediate Care Facility for Developmentally Disabled Transition'
,UPPER(LTRIM(RTRIM(ISNULL(pspe.spectype,'')))) AS [Specialty Status]
,DENSE_RANK() OVER(PARTITION BY prov.provid ORDER BY spe.description) AS [RANKis]
,ROW_NUMBER() OVER(PARTITION BY prov.provid ORDER BY spe.description) AS [ROWis]
,UPPER(LTRIM(RTRIM(ISNULL(spe.specialtycode,'')))) AS SPECcode
,UPPER(LTRIM(RTRIM(ISNULL(spe.description,'')))) AS SPECdescr,pspe.spectype
,prov.provid
,prov.fedid
,prov.NPI
,prov.ExternalID -- AS [SEQ_PROV_ID]
,PROVNM = UPPER(LTRIM(RTRIM(ISNULL(prov.fullname,'')))) -- PROVIDER NAME
,ent.enttype
,ent.lastname
,ent.firstname
,ent.middlename
,ent.entname
,PROVcode = UPPER(LTRIM(RTRIM(ISNULL(pt.provtype,'')))) -- PROVTYPE CODE
,PROVtype = UPPER(LTRIM(RTRIM(ISNULL(pt.[description],'')))) -- PROVTYPE Descr.
,PROVclass = UPPER(LTRIM(RTRIM(ISNULL(pt.provclass,'')))) -- PROVTYPE Classification
,PROVaddr1 = UPPER(LTRIM(RTRIM(ISNULL(ent.phyaddr1,''))))
,PROVaddr2 = UPPER(LTRIM(RTRIM(ISNULL(ent.phyaddr2,''))))
,PROVcity = UPPER(LTRIM(RTRIM(ISNULL(ent.phycity,''))))
,PROVstate = SUBSTRING(UPPER(LTRIM(RTRIM(ISNULL(ent.phystate,'')))),1,2)
,PROVcounty = UPPER(LTRIM(RTRIM(ISNULL(ent.phycounty,'')))) -- •	County, if Plan is multi-county
,PROVzip = CASE
WHEN SUBSTRING(LTRIM(RTRIM(ent.phyzip)),1,1) = '0'
THEN '0'+ SUBSTRING(LTRIM(RTRIM(ent.phyzip)),2,4)
WHEN SUBSTRING(LTRIM(RTRIM(ent.phyzip)),1,1) = '00'
THEN '00'+ SUBSTRING(LTRIM(RTRIM(ent.phyzip)),3,3)
ELSE  SUBSTRING(LTRIM(RTRIM(ent.phyzip)),1,5) 
END
,PROVphone = CASE
WHEN LTRIM(RTRIM(ent.phone)) = ''
THEN SUBSTRING(REPLACE(LTRIM(RTRIM(ent.emerphone)),'-',''),1,10)
ELSE SUBSTRING(REPLACE(LTRIM(RTRIM(ent.phone)),'-',''),1,10)
END
,PROVmobile = CASE
WHEN LTRIM(RTRIM(ent.mobilephone)) = ''
THEN SUBSTRING(REPLACE(LTRIM(RTRIM(ent.secphone)),'-',''),1,10)
ELSE SUBSTRING(REPLACE(LTRIM(RTRIM(ent.mobilephone)),'-',''),1,10)
END
,PROVemail = LTRIM(RTRIM(ent.email))
-- ,evips.REGION AS [PCP REGION]
-- INTO #PROVISOLATION
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM HMOPROD_PLANDATA.dbo.provider AS prov
	JOIN HMOPROD_PLANDATA.dbo.entity AS ent ON prov.entityid = ent.entid
		LEFT JOIN HMOPROD_PLANDATA.dbo.providertype AS pt ON prov.provtype = pt.provtype
		LEFT JOIN HMOPROD_PLANDATA.dbo.provspecialty AS pspe ON prov.provid = pspe.provid
		LEFT JOIN HMOPROD_PLANDATA.dbo.specialty AS spe ON pspe.specialtycode = spe.specialtycode
WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ...
	AND UPPER(LTRIM(RTRIM(ISNULL(prov.npi,'')))) IN ('1073736427','1831124890','1639392079','1336368984','1114124849','1053518779','1134342520','1417183831','1982839320','1922233469','1679708028','1699901017','1477789832','1972739399','1881820207','1164658589','1205061645','1659506012','1154557577','1922277698','1427284843','1063648483') -- ICF NPI(S) FROM SIR SALIM FILE see "COC_SURVEY_..."

		SELECT * FROM #PROVISOLATION







DROP TABLE IF EXISTS #snapshot -- SQL Server 2016 and later -- DYNAMIC tmp OR STATIC [TABLE] #INFORMATICS.dbo.SHELLclaimlist_TOPDIAG is a local temporary table visible only in the current session; ##INFORMATICS.dbo.SHELLclaimlist_TOPDIAG is a GLOBAL temporary table visible to all sessions IN ('TempDB')

SELECT ' ' AS '[ProviderRepository] - DSNP TRANSITION ;WITH() [LOBCode] v [HCPCode] AS OF 20230101 [SnapshotID] IN USE',*
INTO #snapshot
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st',
FROM 
( -- INITIATE ...
SELECT DENSE_RANK() OVER (PARTITION BY LOB ORDER BY snapshotid DESC,TRY_CONVERT(datetime,Createdate) DESC) AS [RANKis],* 
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st',
FROM [ProviderRepository].dbo.[Snapshot] -- IN SQLPRODAPP01
) -- CONCLUDE ...
AS ss
WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ...
	AND ss.RANKis BETWEEN 1 AND 3
	AND ss.SnapshotID IN 
	 ( -- INITIATE ...
	 SELECT MAX([SnapshotID]) AS [SID] FROM [ProviderRepository].dbo.[Snapshot] /* WHERE LOB IN ('MEDICAL') */ GROUP BY LOB
	 ) -- CONCLUDE ...

		SELECT * FROM #snapshot







-- ==================================================================
	-- BASELINE eVIPS FAC CHECK(s) --
-- ==================================================================
SELECT DISTINCT 'BASELINE eVIPS FAC CHECK(s)' AS [MESSAGE(S)]
,DERIVEDFAC.QNXTprovid,DERIVEDFAC.ProviderAlternateID,vpl.LineNumber1,vpl.LineNumber2,vpl.City,vpl.PracticeID,vpl.LocationID,vpl.LocationName,vlp.ProductName,UPPER(LTRIM(RTRIM(vlp.InDirectory))) AS [INDIRECTORY],UPPER(LTRIM(RTRIM(vp.Archived))) AS [vpARCHIVED],UPPER(LTRIM(RTRIM(vp.PracticeStatus))) AS [vpPRACTICESTATUS],UPPER(LTRIM(RTRIM(vp.ApplicationStatus))) AS [vpAPPLICATIONSTATUS],UPPER(LTRIM(RTRIM(vpl.Archived))) AS [vplARCHIVED],UPPER(LTRIM(RTRIM(vpl.LocationTypeName))) AS [vplLOCATIONTYPENAME],UPPER(LTRIM(RTRIM(vlp.LocationTypeName))) AS [vlpLOCATIONTYPENAME],UPPER(LTRIM(RTRIM(vlp.Archived))) AS [vlpARCHIVED],UPPER(LTRIM(RTRIM(vlp.StatusTypeName))) AS [vlpSTATUSTYPENAME],UPPER(LTRIM(RTRIM(ISNULL(vlp.ServiceTypeName,'')))) AS [vlpSERVICETYPENAME],CAST(NULL AS nvarchar(5)) AS [providence],CAST(NULL AS nvarchar(100)) AS ID,UPPER(LTRIM(RTRIM(vp.PracticeTypeName))) AS [VP_plan_type],UPPER(LTRIM(RTRIM(vlp.PracticeTypeName))) AS [VLP_plan_type],UPPER(LTRIM(RTRIM(vlp.ProductTypeCode))) AS [VLP_Alt_plan_type],UPPER(LTRIM(RTRIM(vlp.ProductTypeName))) AS [VLP_full_plan_name],UPPER(LTRIM(RTRIM(vp.PracticeTypeName))) AS [plan_type],UPPER(LTRIM(RTRIM(vlp.ProductName))) AS [plan_name],vp.PracticeName,vpl.LocationName,vp.LegalName AS [VPLegalName],vpl.LegalName AS [VPLLegalName]
,UPPER(LTRIM(RTRIM(vpl.LocationName))) AS [HospitalName]
,UPPER(LTRIM(RTRIM(vpl.LocationName))) AS [FacilityName]
,UPPER(LTRIM(RTRIM(vpl.LocationName))) AS [Clinic Name]
,UPPER(LTRIM(RTRIM(vpl.LocationName))) AS [Pharmacy Name] -- We have most of the NPIs for the clinics.  They are located in the NPI field in the address master
,UPPER(LTRIM(RTRIM(vp.PracticeID))) AS [DBAPracticeID]
,UPPER(LTRIM(RTRIM(vp.PracticeName))) AS [DBA]
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
,vpl.LineNumber1,vpl.LineNumber2,vpl.City
,vls.Code1,vls.Code2,vls.Code1 AS [FacilityType],vls.Code2 AS [InstitutionalFacilityType]
,vea.*
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st',
-- SELECT  vlp.Focus,vlsfocus.Code1,vlsfocus.Code2,vp.Archived,vp.PracticeStatus,vp.ApplicationStatus,vpl.Archived,vpl.LocationTypeName,vp.PracticeTypeName,* -- CHECK 1st
-- SELECT * FROM eVips_chgcv.dbo.vwPracticeLocations -- CHECK 1st
-- SELECT DISTINCT PracticeTypeName FROM eVips_chgcv.dbo.vwPracticeLocations -- CHECK 1st UPPER(LTRIM(RTRIM(vpl.PracticeTypeName))) AS [Type of Service]
-- SELECT * FROM eVips_chgcv.dbo.vwEntityAssignments WHERE UPPER(LTRIM(RTRIM(TableName))) LIKE '%Practice%' AND UPPER(LTRIM(RTRIM(EntityName))) LIKE '%MED%IMPA%' -- CHECK 1st
FROM eVips_chgcv.dbo.vwPractices AS vp
	JOIN eVips_chgcv.dbo.vwPracticeLocations AS vpl ON vp.PracticeID = vpl.PracticeID
		LEFT JOIN eVips_chgcv.dbo.vwFacilities AS vf ON vpl.LocationName = vf.FacilityName
			OR vp.PracticeName = vf.FacilityName
		LEFT JOIN 
		( -- INITIATE ...
		SELECT DISTINCT PracticeID,ClassOrCategory, ServiceTypeName,ServiceCategoryTypeName,Code1,Code2,LocationID
		FROM eVips_chgcv.dbo.vwLocationServices 
		WHERE ServiceTypeName 
		LIKE '%GROUP%SPEC%'
		) -- CONCLUDE ...
		AS vls ON vp.PracticeID = vls.PracticeID -- DEFINE FAC CHAPTER(s) 		
		LEFT JOIN 
		( -- INITIATE ...
		SELECT DISTINCT LocationID,PracticeID,ClassOrCategory, ServiceTypeName,ServiceCategoryTypeName,code1,code2 
		FROM eVips_chgcv.dbo.vwLocationServices 
		WHERE UPPER(LTRIM(RTRIM(ServiceTypeName))) LIKE '%PHARM%TYPE%' 
			AND ServiceCategoryTypeName IS NOT NULL 
			AND UPPER(LTRIM(RTRIM(ServiceCategoryTypeName))) != ''
			) -- CONCLUDE ...
			AS vlspharmtype ON vp.PracticeID = vlspharmtype.PracticeID --DEFINE PHARM TYPE(s)
				AND vpl.LocationID = vlspharmtype.LocationID -- per YOUNG LADY LAURA email ON 20171221 ... Products (CMC & MEDICAL)  are stored at Location Level. The code below is joining based only on Practice ID. This should be based on PracticeID + Location
		LEFT JOIN 
		( -- INITIATE ...
		SELECT DISTINCT LocationID,PracticeID,ClassOrCategory, ServiceTypeName,ServiceCategoryTypeName,code1,code2 
		FROM eVips_chgcv.dbo.vwLocationServices 
		WHERE UPPER(LTRIM(RTRIM(ServiceTypeName))) LIKE '%PHARM%SERV%' 
			AND ServiceCategoryTypeName IS NOT NULL 
			AND UPPER(LTRIM(RTRIM(ServiceCategoryTypeName))) != ''
			) -- CONCLUDE ...
			AS vlspharmservice ON vp.PracticeID = vlspharmservice.PracticeID --DEFINE PHARM TYPE(s)
				AND vpl.LocationID = vlspharmservice.LocationID -- per YOUNG LADY LAURA email ON 20171221 ... Products (CMC & MEDICAL)  are stored at Location Level. The code below is joining based only on Practice ID. This should be based on PracticeID + Location
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
		WHERE UPPER(LTRIM(RTRIM(ISNULL(TableName,'')))) LIKE '%PRACTI%'
		) -- CONCLUDE ...
		AS vea ON vp.PracticeID = vea.ProviderID
		LEFT JOIN
		 ( -- INITIATE ...
		SELECT DISTINCT ljvlp.ProductTypeCode,ljvlp.ProductTypeName,ljvlp.PracticeTypeName,ljvlp.PracticeID,ljvlp.LocationID,ljvlp.Archived,ljvlp.StatusTypeName,vlpstype.indirectory,vlpstype.ServiceTypeCode,vlpstype.ServiceTypeName,ljvlp.productname,ljvlp.ProductPanelStatusTypeName,ljvlp.ProductPanelStatusTypeCode,ljvlp.ProviderNumber,ljvlp.Focus,ljvlp.ProductID,ljvlp.LocationTypeName 
		FROM eVips_chgcv.dbo.vwLocationProducts AS ljvlp 
			JOIN evips_chgcv.dbo.vwLocationProductServices AS vlpstype ON ljvlp.LocationProductRecID = vlpstype.LocationProductRecID 
		WHERE ISNULL(ljvlp.Archived,'') IN ('N','') 
			AND (ISNULL(ljvlp.StatusTypeName,'') IN ('ACTIVE','') 
				OR ljvlp.StatusTypeName LIKE '%PARTICIP%')
			AND ISNULL(vlpstype.Archived,'') IN ('N','') 
			) -- CONCLUDE ...
			AS vlp ON vpl.PracticeID = vlp.PracticeID --'YOUNG LADY LAURA GAH ID WHERE p.archived = 'N' AND s.ServiceTypeName = 'HOSPITAL' AND p.focus like '%GAH%'' ON 20171120 see ,UPPER(LTRIM(RTRIM(vlp.ServiceTypeName))) AS [vlpSERVICETYPENAME]
				AND vpl.LocationID = vlp.LocationID -- per YOUNG LADY LAURA email ON 20171221 ... Products (CMC & MEDICAL)  are stored at Location Level. The code below is joining based only on Practice ID. This should be based on PracticeID + Location
		LEFT JOIN 
		( -- INITIATE ...
		SELECT DISTINCT LocationID,PracticeID,AccreditationTypeCode,AccreditationTypeName,Notes 
		FROM eVips_chgcv.dbo.vwLocationAccreditations AS vla 
		WHERE ISNULL(vla.Archived,'') IN ('N','') 
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
		WHERE UPPER(LTRIM(RTRIM(ISNULL(county,'')))) LIKE '%SAN%DIEGO%'
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

WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ...
	 AND vp.Archived IN ('N') --WITH eVIPS LOGICAL BINARY OPTION(s) IN USE •	Must not be archived 
	  AND ISNULL(vp.PracticeStatus,'') IN ('ACTIVE','CONTRACTED','NA','') --•	Contract Status must be Active
	  AND vpl.Archived IN ('N') --WITH eVIPS LOGICAL BINARY OPTION(s) IN USE •	Must not be archived

	 AND  vp.Archived IN ('N') --WITH eVIPS LOGICAL BINARY OPTION(s) IN USE •	Must not be archived 
	  AND ISNULL(vp.PracticeStatus,'') IN ('ACTIVE','CONTRACTED','NA','') --•	Contract Status must be Active
	  AND vpl.Archived IN ('N') --WITH eVIPS LOGICAL BINARY OPTION(s) IN USE •	Must not be archived
	 
	 -- AND vpl.LocationName LIKE '%SHARP%HOSPICE%'
	
	AND UPPER(LTRIM(RTRIM(ISNULL(vlp.ServiceTypeName,'')))) LIKE '%INTERMEDIATE%CARE%FACILITIES%%' 
	-- AND vpl.NationalProviderID IN ('1073736427','1831124890','1639392079','1336368984','1114124849','1053518779','1134342520','1417183831','1982839320','1922233469','1679708028','1699901017','1477789832','1972739399','1881820207','1164658589','1205061645','1659506012','1154557577','1922277698','1427284843','1063648483') -- ICF NPI(S)







JAH ADD 'ECM / CS POF'
x FOOTNOTE: *** AH - Adult Individuals Experiencing Homelessness, AF - Adult Families Experiencing Homelessness, AA - Adult Avoidable Hospital or ED Utilization, AS - Adult SMI or SUD, AI - Adult Transitioning from Incarceration Statewide, AR - Adult at Risk for LTC Institutionalization , AN - Adult NF Transitioning to Community, CH - Child Individuals Experiencing Homelessness, CF - Child Families Experiencing Homelessness, CA - Child Avoidable Hospital or ED Utilization, CS - Child SMI or SUD, CC - Child CCS/CCS WCM with Additional Needs, CW- Child Welfare, CI - Child Transitioning from Incarceration Statewide ,CB - Child Birth Equity

AIEH - Adult Individuals Experiencing Homelessness, AFEH - Adult Families Experiencing Homelessness, AAHEDU - Adult Avoidable Hospital or ED Utilization, ASMISUD - Adult SMI or SUD, ATIS - Adult Transitioning from Incarceration Statewide, ARLTCI - Adult at Risk for LTC Institutionalization , ANFTC- Adult NF Transitioning to Community, CIEH- Child Individuals Experiencing Homelessness, CFEH- Child Families Experiencing Homelessness, CAHEDU- Child Avoidable Hospital or ED Utilization, CSMISUD- Child SMI or SUD, CCSWCMAN- Child CCS/CCS WCM with Additional Needs, CW- Child Welfare, CTIS- Child Transitioning from Incarceration Statewide ,CBE- Child Birth Equity

SELECT ' ' AS 'ADD COL()',INDEXNM,[ECMCS_POF],* FROM INFORMATICS.dbo.PROVDIR_ECMCSP WHERE 1=1 AND ECMCS_POF IS NOT NULL

AIEH - Adult Individuals Experiencing Homelessness, AFEH - Adult Families Experiencing Homelessness, AAHEDU - Adult Avoidable Hospital or ED Utilization, ASMISUD - Adult SMI or SUD, ATIS - Adult Transitioning from Incarceration Statewide, ARLTCI - Adult at Risk for LTC Institutionalization , ANFTC- Adult NF Transitioning to Community, CIEH- Child Individuals Experiencing Homelessness, CFEH- Child Families Experiencing Homelessness, CAHEDU- Child Avoidable Hospital or ED Utilization, CSMISUD- Child SMI or SUD, CCSWCMAN- Child CCS/CCS WCM with Additional Needs, CW- Child Welfare, CTIS- Child Transitioning from Incarceration Statewide ,CBE- Child Birth Equity

'1649809526',''

SELECT ' ' AS 'ADD COL()',[ECMCS_POF],* FROM INFORMATICS.dbo.PROVDIR_ECMCSP
HOSPITAL_IDENTIFICATION

ALTER TABLE TABLENAME
ADD -- INITIATE ... ADD OF COLUMN(s)
[ECMCS_POF] nvarchar(255) DEFAULT NULL -- DFLT VAL() IS NULL
; -- CONCLUDE ...

		SELECT ' ' AS 'ADD COL()',* FROM TABLENAME







JAH '[CSZ]' UPDATE
,[CSZ] = TRY_CONVERT(varchar(255),NULL)

SELECT Address,CSZ,* FROM INFORMATICS.dbo.PROVDIR_DOULA
SELECT Address,CSZ,* FROM INFORMATICS.dbo.SANATOR_PROVDIR_DOULA
SELECT Address,CSZ,* FROM INFORMATICS.dbo.PROVDIR_CHW
SELECT Address,CSZ,* FROM INFORMATICS.dbo.SANATOR_PROVDIR_CHW
SELECT Address,CSZ,* FROM INFORMATICS.dbo.PROVDIR_ECMCSP

-- =====================================================================
	-- SUPPRESS [DOULA] / [CHW] HOME ADDRESS -- 
-- =====================================================================
UPDATE INFORMATICS.dbo.PROVDIR_DOULA
SET [CSZ] = TRY_CONVERT(varchar(255),NULL) -- IN LIEU OF ACTUAL ADDR per "D-SNP & C-SNP Provider Directory" MEETING ON 20230927
-- ,address1 = TRY_CONVERT(varchar(5),NULL)
-- ,address2 = TRY_CONVERT(varchar(25),NULL)
-- ,CityIs = TRY_CONVERT(varchar(25),NULL)
-- ,StateIs = TRY_CONVERT(varchar(2),NULL)
-- ,[Zip Code] = TRY_CONVERT(varchar(5),NULL)
-- SELECT ' ' AS 'CHECK 1st',[Name of Network],LocationName,Address,NPIis,address1,CityIs,StateIs,[Zip Code],*
-- SELECT DISTINCT ' ' AS 'CHECK 1st',[Name of Network],LocationName,Address,NPIis,address1,CityIs,StateIs,[Zip Code]
FROM INFORMATICS.dbo.PROVDIR_DOULA
WHERE [Address] LIKE '%Contact%appointments%'

UPDATE INFORMATICS.dbo.PROVDIR_CHW
SET [CSZ] = TRY_CONVERT(varchar(255),NULL) -- IN LIEU OF ACTUAL ADDR per "D-SNP & C-SNP Provider Directory" MEETING ON 20230927
-- ,address1 = TRY_CONVERT(varchar(5),NULL)
-- ,address2 = TRY_CONVERT(varchar(25),NULL)
-- ,CityIs = TRY_CONVERT(varchar(25),NULL)
-- ,StateIs = TRY_CONVERT(varchar(2),NULL)
-- ,[Zip Code] = TRY_CONVERT(varchar(5),NULL)
-- SELECT ' ' AS 'CHECK 1st',[Name of Network],LocationName,Address,NPIis,address1,CityIs,StateIs,[Zip Code],*
-- SELECT DISTINCT ' ' AS 'CHECK 1st',[Name of Network],LocationName,Address,NPIis,address1,CityIs,StateIs,[Zip Code]
FROM INFORMATICS.dbo.PROVDIR_CHW
WHERE [Address] LIKE '%Contact%appointments%'

UPDATE INFORMATICS.dbo.SANATOR_PROVDIR_DOULA
SET [CSZ] = TRY_CONVERT(varchar(255),NULL) -- IN LIEU OF ACTUAL ADDR per "D-SNP & C-SNP Provider Directory" MEETING ON 20230927
-- ,address1 = TRY_CONVERT(varchar(5),NULL)
-- ,address2 = TRY_CONVERT(varchar(25),NULL)
-- ,CityIs = TRY_CONVERT(varchar(25),NULL)
-- ,StateIs = TRY_CONVERT(varchar(2),NULL)
-- ,[Zip Code] = TRY_CONVERT(varchar(5),NULL)
-- SELECT ' ' AS 'CHECK 1st',[Name of Network],LocationName,Address,NPIis,address1,CityIs,StateIs,[Zip Code],*
-- SELECT DISTINCT ' ' AS 'CHECK 1st',[Name of Network],LocationName,Address,NPIis,address1,CityIs,StateIs,[Zip Code]
FROM INFORMATICS.dbo.SANATOR_PROVDIR_DOULA
WHERE [Address] LIKE '%Contact%appointments%'

UPDATE INFORMATICS.dbo.SANATOR_PROVDIR_CHW
SET [CSZ] = TRY_CONVERT(varchar(255),NULL) -- IN LIEU OF ACTUAL ADDR per "D-SNP & C-SNP Provider Directory" MEETING ON 20230927
-- ,address1 = TRY_CONVERT(varchar(5),NULL)
-- ,address2 = TRY_CONVERT(varchar(25),NULL)
-- ,CityIs = TRY_CONVERT(varchar(25),NULL)
-- ,StateIs = TRY_CONVERT(varchar(2),NULL)
-- ,[Zip Code] = TRY_CONVERT(varchar(5),NULL)
-- SELECT ' ' AS 'CHECK 1st',[Name of Network],LocationName,Address,NPIis,address1,CityIs,StateIs,[Zip Code],*
-- SELECT DISTINCT ' ' AS 'CHECK 1st',[Name of Network],LocationName,Address,NPIis,address1,CityIs,StateIs,[Zip Code]
FROM INFORMATICS.dbo.SANATOR_PROVDIR_CHW
WHERE [Address] LIKE '%Contact%appointments%'

UPDATE INFORMATICS.dbo.PROVDIR_ECMCSP
SET [CSZ] = TRY_CONVERT(varchar(255),NULL) -- IN LIEU OF ACTUAL ADDR per "D-SNP & C-SNP Provider Directory" MEETING ON 20230927
-- ,address1 = TRY_CONVERT(varchar(5),NULL)
-- ,address2 = TRY_CONVERT(varchar(25),NULL)
-- ,CityIs = TRY_CONVERT(varchar(25),NULL)
-- ,StateIs = TRY_CONVERT(varchar(2),NULL)
-- ,[Zip Code] = TRY_CONVERT(varchar(5),NULL)
-- SELECT ' ' AS 'CHECK 1st',[Name of Network],LocationName,Address,NPIis,address1,CityIs,StateIs,[Zip Code],*
-- SELECT DISTINCT ' ' AS 'CHECK 1st',[Name of Network],LocationName,Address,NPIis,address1,CityIs,StateIs,[Zip Code]
FROM INFORMATICS.dbo.PROVDIR_ECMCSP
WHERE [Address] LIKE '%Contact%appointments%'







JAH 'PROVDIR UPDATES'
x FOR CHW CHAPTER WHEN THE PROVIDER ADDR IN ('2420 FENTON')
		THEN USE 'Contact for appointments' -- IN LIEU OF ACTUAL ADDR per "D-SNP & C-SNP Provider Directory" MEETING ON 20230927
		
		MAKE CHANGE AT [TimelyAccess...] TABLE DEVELOPMENT SECTION
				CHARINDEX() FIND() SEARCH():
				
-- ==========================================================
	-- TIMELYACCESS() SETUP [TABLE](s)--
-- ==========================================================
UPDATE INFORMATICS.dbo.TimelyAccessPCP
SET [Address] = 'Contact for appointments' -- IN LIEU OF ACTUAL ADDR per "D-SNP & C-SNP Provider Directory" MEETING ON 20230927
-- ,address1 = TRY_CONVERT(varchar(5),NULL)
-- ,address2 = TRY_CONVERT(varchar(25),NULL)
-- ,CityIs = TRY_CONVERT(varchar(25),NULL)
-- ,StateIs = TRY_CONVERT(varchar(2),NULL)
-- ,[Zip Code] = TRY_CONVERT(varchar(5),NULL)
-- SELECT ' ' AS 'CHECK 1st',[Name of Network],LocationName,Address,NPIis,address1,CityIs,StateIs,[Zip Code],*
-- SELECT DISTINCT ' ' AS 'CHECK 1st',[Name of Network],LocationName,Address,NPIis,address1,CityIs,StateIs,[Zip Code]
FROM INFORMATICS.dbo.TimelyAccessFAC
WHERE [Address] LIKE '%2420%FENTON%'
	OR [Address] = 'Contact for appointments'

					SELECT * FROM INFORMATICS.dbo.TimelyAccessPCP
					SELECT * FROM INFORMATICS.dbo.TimelyAccessPCP_Extender
					SELECT * FROM INFORMATICS.dbo.TimelyAccessSPE - see  '(#SPE,#SPEb,#SPEc,#SPEd)'
					SELECT * FROM INFORMATICS.dbo.TimelyAccessFAC
					SELECT * FROM INFORMATICS.dbo.TimelyAccessCLINICCMC
					SELECT * FROM INFORMATICS.dbo.TimelyAccessCLINIC
					SELECT * FROM INFORMATICS.dbo.TimelyAccessPHARM

x MOVED TO '2420 FENTON ST 91914' FROM '740 BAY BLVD 91910' AS OF 20130510		
		
x FOR EMC CHAPTER ADD ECM POF(S)
		see "BASIC ACCESS SECTION(S)"
		
		SELECT * FROM INFORMATICS.dbo.PROVDIR_CHW --NEW ADDITION(S)
		SELECT * FROM INFORMATICS.dbo.PROVDIR_DOULA --NEW ADDITION(S)
		SELECT * FROM INFORMATICS.dbo.PROVDIR_ECMCSP --NEW ADDITION(S)

-- ===================================================================
	-- HDR [ACCESSIBILITY] OPTION(s) --
-- ===================================================================
--------------------------------------------------------------------------------------------------------------------
	-- Error Trapping: Check If Permanent Table(s) Already Exist(s) And Drop If Applicable --
--------------------------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS #ACCESSIBILITY -- SQL Server 2016 and later -- DYNAMIC tmp OR STATIC [TABLE] #TableName is a local temporary table visible only in the current session; #TableName is a GLOBAL temporary table visible to all sessions IN ('TempDB')
 
SELECT DISTINCT ServiceTypeName
,CASE
WHEN SUBSTRING(UPPER(LTRIM(RTRIM(vls.ClassOrCategory))),1,1) = 'L'
THEN 'Limited Access'
WHEN SUBSTRING(UPPER(LTRIM(RTRIM(vls.ClassOrCategory))),1,1) = 'B'
THEN 'Basic Access'
ELSE ''
END AS [Accessibility]
,UPPER(LTRIM(RTRIM(vls.ServiceCategoryTypeName))) AS [Accessibility Category(ies)]
,vls.PracticeID,vls.LocationID
INTO #ACCESSIBILITY
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ClassOrCategory -- CHECK 1st
-- SELECT DISTINCT ServiceTypeName -- CHECK 1st
-- SELECT DISTINCT PracticeTypeName -- CHECK 1st
-- SELECT DISTINCT ServiceCategoryTypeName -- CHECK 1st
FROM eVips_chgcv.dbo.vwLocationServices AS vls
WHERE UPPER(LTRIM(RTRIM(vls.ServiceTypeName))) LIKE '%SITE%REV%'

		-- SELECT * FROM #ACCESSIBILITY
,CASE
WHEN UPPER(LTRIM(RTRIM(vpp.focus))) LIKE '%HIV%'
THEN 'HIV/AIDS'
WHEN UPPER(LTRIM(RTRIM(vpp.focus))) LIKE '%HL%'
THEN 'Homelessness'
WHEN UPPER(LTRIM(RTRIM(vpp.focus))) LIKE '%BL%'
THEN 'Blindness'
WHEN UPPER(LTRIM(RTRIM(vpp.focus))) LIKE '%VI%'
THEN 'Visual Impairment'
WHEN UPPER(LTRIM(RTRIM(vpp.focus))) LIKE '%DF%'
THEN 'Deafness'
WHEN UPPER(LTRIM(RTRIM(vpp.focus))) LIKE '%HH%'
THEN 'Hard of Hearing'
WHEN UPPER(LTRIM(RTRIM(vpp.focus))) LIKE '%CI%'
THEN 'Chronic Illness'
WHEN UPPER(LTRIM(RTRIM(vpp.focus))) LIKE '%PD%'
THEN 'Physical Disabilities'
WHEN UPPER(LTRIM(RTRIM(vpp.focus))) LIKE '%SMI%'
THEN 'Serious Mental Illness'
WHEN UPPER(LTRIM(RTRIM(vpp.focus))) LIKE '%TR%'
THEN 'Trauma'
WHEN UPPER(LTRIM(RTRIM(vpp.focus))) LIKE '%DA%'
THEN 'Anxiety Disorder'
WHEN UPPER(LTRIM(RTRIM(vpp.focus))) LIKE '%DAU%'
THEN 'Autism'
WHEN UPPER(LTRIM(RTRIM(vpp.focus))) LIKE '%CW%'
THEN 'Child Welfare'
WHEN UPPER(LTRIM(RTRIM(vpp.focus))) LIKE '%CO%'
THEN 'Co-occurring Disorders'
WHEN UPPER(LTRIM(RTRIM(vpp.focus))) LIKE '%DE%'
THEN 'Eating Disorder '
WHEN UPPER(LTRIM(RTRIM(vpp.focus))) LIKE '%OCD%'
THEN 'Obsessive-Compulsive Disorder'
WHEN UPPER(LTRIM(RTRIM(vpp.focus))) LIKE '%DM%'
THEN 'Mood Disorder'
WHEN UPPER(LTRIM(RTRIM(vpp.focus))) LIKE '%NPSC%'
THEN 'Neuropsychology'
WHEN UPPER(LTRIM(RTRIM(vpp.focus))) LIKE '%PP%'
THEN 'Psychopharmacology'
WHEN UPPER(LTRIM(RTRIM(vpp.focus))) LIKE '%SCH%'
THEN 'Schizophrenia'
WHEN UPPER(LTRIM(RTRIM(vpp.focus))) LIKE '%SA%'
THEN 'Substance Abuse'
ELSE CAST('NONE' AS nvarchar(100))
END AS [AREA_of_PRACTICE] -- per S. Coleman email ON 20160713 (8)	Add Areas of Practice includes:   to practitioners (cert_provider: focus) and specific for that site/group code.  If null do not show field.  I added a few for HL & VI for testing.)







JAH 'NEW LOB' - 'eMAIL' ON 20230808
x Hi Kelly, 

The CMS approved plan name for the C-SNP is as follows:

		SELECT 'CSNP' AS [Participating Network],'Community y Más (HMO C-SNP)' AS [LINE_OF_BUSINESS],'COPY MCR / D-SNP' AS [MESSAGE(S)]
		,EOMONTH(GETDATE(),-1) AS [RESET HCT LAG],EOMONTH(GETDATE(),-4) AS [HCT LAG],DATEADD(dd,1,EOMONTH(GETDATE(),-1))  AS [RESET dos_month],CASE WHEN GETDATE() IS NULL THEN DATEADD(dd,1,EOMONTH(GETDATE(),-1)) ELSE DATEADD(dd,1,EOMONTH(GETDATE(),-1)) END dos_month
		,DATEADD(dd,1,DATEADD(mm,-12,EOMONTH(GETDATE(),-4))) AS [Current 12 Month Start],EOMONTH(GETDATE(),-4) AS [Current 12 Month End]
		,DATEADD(dd,1,DATEADD(mm,-24,EOMONTH(GETDATE(),-4))) AS [Previous 12 Month Start],EOMONTH(GETDATE(),-16) AS [Previous 12 Month End]

		SELECT TOP 1 * FROM SQLPRODAPP01.INFORMATICS.dbo.PROVDIR_SPE

Thanks, Francisca

x C-SNP [Name of Network] AS 'Community y Más (HMO C-SNP)'
x 

--------------------------------------------------------------------------------------------------------------------
	-- Error Trapping: Check If Permanent Table(s) Already Exist(s) And Drop If Applicable --
--------------------------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS #CSNPSETUPPCP -- DUPLICATE OF D-SNP (MCR)
 
SELECT DISTINCT *
INTO #CSNPSETUPPCP
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM INFORMATICS.dbo.TimelyAccessPCP
WHERE [Participating Network] IN ('MCR')

UPDATE #CSNPSETUPPCP
SET [Participating Network] = 'CSNP' -- DSNP TRANSITION FROM CMC GO LIVE ON '01/01/2023'
,[Name of Network] = 'Community y Más (HMO C-SNP)'
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'

INSERT INTO INFORMATICS.dbo.TimelyAccessPCP -- (...) ADD CMC RECORD(s) MANUAL SINCE SWITCH FROM 'B' [Participating Network]
SELECT * -- SELECT DISTINCT ...
--SELECT TOP 100 * --CHECK 1st
--SELECT DISTINCT ratecode,[COAgroup] --CHECK 1st
FROM #CSNPSETUPPCP

		,CASE
		WHEN LTRIM(RTRIM(vlp.ProductName)) LIKE '%MEDICAL%'
		THEN 'CL1'
		WHEN LTRIM(RTRIM(vlp.ProductName)) LIKE '%MEDICAR%'
		THEN 'MCR'
		WHEN LTRIM(RTRIM(vlp.ProductName)) LIKE '%CMC%'
		THEN 'CMC'
		WHEN ...
		THEN 'Community y Más (HMO C-SNP)'
		ELSE CAST(NULL AS nvarchar(255))
		END AS [Participating Network]
		,CASE
		WHEN LTRIM(RTRIM(vlp.ProductName)) LIKE '%MEDICAL%'
		THEN 'MEDI_CAL'
		WHEN LTRIM(RTRIM(vlp.ProductName)) LIKE '%MEDICAR%'
		THEN 'Communicare_Advantage'
		WHEN LTRIM(RTRIM(vlp.ProductName)) LIKE '%CMC%'
		THEN 'CMC'
		WHEN ...
		THEN 'Community y Más (HMO C-SNP)'
		ELSE CAST(NULL AS nvarchar(255))
		END AS [Name of Network]

x UPDATES OF [MedicaidMedicareFlag] FOR PROVDIR_ ... SITE TABLE(S)

x CHARINDEX() FIND() SEARCH()

INTO #FUTURETERM
,'This provider will remain in the network until '+DATENAME(MONTH,[DateTo])+' '+CAST(DATEPART(DAY,[DateTo]) AS nvarchar(2))+', '+CAST(DATEPART(YEAR,[DateTo]) AS nvarchar(4)) AS [FUTURE_TERM] -- 'This provider will remain in the network until Month, day, 20XX.'

,CAST('Both' AS nvarchar(25)) AS [MedicaidMedicareFlag],CAST('Both' AS nvarchar(25)) AS [MMF]
-- ,CAST('PLACEHOLDER' AS nvarchar(255)) AS [FUTURE_TERM] -- 'This provider will remain in the network until Month, day, 20XX'
,ftm.[FUTURE_TERM] -- 'This provider will remain in the network until Month, day, 20XX'
INTO #INNET...

-- ==========================================================
	-- TIMELYACCESS() SETUP [TABLE](s)--
-- ==========================================================
INTO INFORMATICS.dbo.TimelyAccess

		LEFT JOIN #FUTURETERM AS ftm ON LTRIM(RTRIM(ISNULL(ftm.NationalProviderID,''))) = CASE
		WHEN vpl.NationalProviderID IS NULL
			AND UPPER(LTRIM(RTRIM(vf.FacilityStatus))) LIKE 'ACTIVE%'
			AND UPPER(LTRIM(RTRIM(vf.ApplicationStatus))) LIKE 'ACTIVE%'
		THEN LTRIM(RTRIM(ISNULL(vf.NationalProviderID,'')))
		ELSE LTRIM(RTRIM(ISNULL(vpl.NationalProviderID,''))) 
		END

		LEFT JOIN #FUTURETERM AS ftm ON LTRIM(RTRIM(ISNULL(ftm.NationalProviderID,''))) = LTRIM(RTRIM(ISNULL(vpd.NationalProviderID,'')))

,[MedicaidMedicareFlag],[MMF],[FUTURE_TERM]
INTO INFORMATICS.dbo.PROVDIR_...
 
UPDATE INFORMATICS.dbo.PROVDIR_PCP
SET [INDEXNM] = [INDEXNM]+' ^ '
WHERE [MedicaidMedicareFlag] LIKE '%Both%'
	AND ISNULL([Participating Network],'OTH') NOT LIKE '%CL1%'

x From: Sandra Coleman <scolem@chgsd.com> 
Sent: Tuesday, August 8, 2023 12:23 PM
To: Walter Carr <WCarr@chgsd.com>; Kelly Bly <kbly@chgsd.com>; Nolyn Payawal <npayawal@chgsd.com>; Lupita Alvarado <malvarado@chgsd.com>; Janice Lopez <JLopez@chgsd.com>; Johanna Duran <jduran@chgsd.com>
Subject: D-SNP change - Providers with future term dates

Hi, This will be discussed tomorrow.  All other changes have been made in the intro pages and provider detail.  We will discuss this last provider detail adjustment and get the time line for the online changes. CMS wants to show if the provider has a future term date.  We have added a To date (vwPractitionerProducts.DateTo) for these providers to test.  This is for the pdf and online.

Brener, Madeline E          1285864918
West, Alixandra S             1619375649
Isaias, Agnela T                  1790772572

NPIis
1790745776
1790745776
1790745776
1790772572
1790772572

This is on page 17 of the specs.
•	Providers who will be available in-network only for a certain period (e.g., as of a future date) or who will leave the network as of a specified date, and provide a clear indication of the time limitation (such as “beginning [month, day, 20XX]” or “until [month, day, 20XX]”).]
Wording to discuss:
This provider will remain in the network until Month, day, 20XX.

Sandra Coleman, MBA, Credentialing Manager
Community Health Group
2420 Fenton Street, Ste 100, Chula Vista, Ca 91914
Phone:  619-498-6438
Fax:  619-382-1211
scolem@chgsd.com 

		SELECT ' ' AS 'SAMPLE OF FUTURE TERMS',DateTo,FUTURE_TERM,* FROM #FUTURETERM WHERE NationalProviderID IN ('1285864918','1619375649','1790772572') -- SAMPLE / TEST Brener, Madeline E          1285864918 West, Alixandra S             1619375649 Isaias, Agnela T                  1790772572 Isaias, Agnela T                  1790772572

		SELECT DISTINCT  ' ' AS 'Medicare providers that accept Medicaid UPDATE(S)',[MedicaidMedicareFlag],[FUTURE_TERM] FROM INFORMATICS.dbo.PROVDIR_PCP

		UNION
		SELECT DISTINCT  ' ' AS 'Medicare providers that accept Medicaid UPDATE(S)',[MedicaidMedicareFlag],[FUTURE_TERM] FROM INFORMATICS.dbo.PROVDIR_NPMP

		UNION
		SELECT DISTINCT  ' ' AS 'Medicare providers that accept Medicaid UPDATE(S)',[MedicaidMedicareFlag],[FUTURE_TERM] FROM INFORMATICS.dbo.PROVDIR_SPE

		UNION
		SELECT DISTINCT  ' ' AS 'Medicare providers that accept Medicaid UPDATE(S)',[MedicaidMedicareFlag],[FUTURE_TERM] FROM INFORMATICS.dbo.PROVDIR_MH

		UNION
		SELECT DISTINCT  ' ' AS 'Medicare providers that accept Medicaid UPDATE(S)',[MedicaidMedicareFlag],[FUTURE_TERM] FROM INFORMATICS.dbo.PROVDIR_AHP

		UNION
		SELECT DISTINCT  ' ' AS 'Medicare providers that accept Medicaid UPDATE(S)',[MedicaidMedicareFlag],[FUTURE_TERM] FROM INFORMATICS.dbo.PROVDIR_VSP

		UNION
		SELECT DISTINCT  ' ' AS 'Medicare providers that accept Medicaid UPDATE(S)',[MedicaidMedicareFlag],[FUTURE_TERM] FROM INFORMATICS.dbo.PROVDIR_CHW

		UNION
		SELECT DISTINCT  ' ' AS 'Medicare providers that accept Medicaid UPDATE(S)',[MedicaidMedicareFlag],[FUTURE_TERM] FROM INFORMATICS.dbo.PROVDIR_DOULA

		UNION
		SELECT DISTINCT  ' ' AS 'Medicare providers that accept Medicaid UPDATE(S)',[MedicaidMedicareFlag],[FUTURE_TERM] FROM INFORMATICS.dbo.PROVDIR_HOS

		UNION
		SELECT DISTINCT  ' ' AS 'Medicare providers that accept Medicaid UPDATE(S)',[MedicaidMedicareFlag],[FUTURE_TERM] FROM INFORMATICS.dbo.PROVDIR_HOSGENERALACUTE

		UNION
		SELECT DISTINCT  ' ' AS 'Medicare providers that accept Medicaid UPDATE(S)',[MedicaidMedicareFlag],[FUTURE_TERM] FROM INFORMATICS.dbo.PROVDIR_HOSMH

		UNION
		SELECT DISTINCT  ' ' AS 'Medicare providers that accept Medicaid UPDATE(S)',[MedicaidMedicareFlag],[FUTURE_TERM] FROM INFORMATICS.dbo.PROVDIR_HOSLTACH

		UNION
		SELECT DISTINCT  ' ' AS 'Medicare providers that accept Medicaid UPDATE(S)',[MedicaidMedicareFlag],[FUTURE_TERM] FROM INFORMATICS.dbo.PROVDIR_SNF

		UNION
		SELECT DISTINCT  ' ' AS 'Medicare providers that accept Medicaid UPDATE(S)',[MedicaidMedicareFlag],[FUTURE_TERM] FROM INFORMATICS.dbo.PROVDIR_RCF

		UNION
		SELECT DISTINCT  ' ' AS 'Medicare providers that accept Medicaid UPDATE(S)',[MedicaidMedicareFlag],[FUTURE_TERM] FROM INFORMATICS.dbo.PROVDIR_HOSPICE

		UNION
		SELECT DISTINCT  ' ' AS 'Medicare providers that accept Medicaid UPDATE(S)',[MedicaidMedicareFlag],[FUTURE_TERM] FROM INFORMATICS.dbo.PROVDIR_IPREHAB

		UNION
		SELECT DISTINCT  ' ' AS 'Medicare providers that accept Medicaid UPDATE(S)',[MedicaidMedicareFlag],[FUTURE_TERM] FROM INFORMATICS.dbo.PROVDIR_CBAS

		UNION
		SELECT DISTINCT  ' ' AS 'Medicare providers that accept Medicaid UPDATE(S)',[MedicaidMedicareFlag],[FUTURE_TERM] FROM INFORMATICS.dbo.PROVDIR_BRC

		UNION
		SELECT DISTINCT  ' ' AS 'Medicare providers that accept Medicaid UPDATE(S)',[MedicaidMedicareFlag],[FUTURE_TERM] FROM INFORMATICS.dbo.PROVDIR_HDM

		UNION
		SELECT DISTINCT  ' ' AS 'Medicare providers that accept Medicaid UPDATE(S)',[MedicaidMedicareFlag],[FUTURE_TERM] FROM INFORMATICS.dbo.PROVDIR_HHC

		UNION
		SELECT DISTINCT  ' ' AS 'Medicare providers that accept Medicaid UPDATE(S)',[MedicaidMedicareFlag],[FUTURE_TERM] FROM INFORMATICS.dbo.PROVDIR_IHSS

		UNION
		SELECT DISTINCT  ' ' AS 'Medicare providers that accept Medicaid UPDATE(S)',[MedicaidMedicareFlag],[FUTURE_TERM] FROM INFORMATICS.dbo.PROVDIR_ASC

		UNION
		SELECT DISTINCT  ' ' AS 'Medicare providers that accept Medicaid UPDATE(S)',[MedicaidMedicareFlag],[FUTURE_TERM] FROM INFORMATICS.dbo.PROVDIR_DXC

		UNION
		SELECT DISTINCT  ' ' AS 'Medicare providers that accept Medicaid UPDATE(S)',[MedicaidMedicareFlag],[FUTURE_TERM] FROM INFORMATICS.dbo.PROVDIR_LAB

		UNION
		SELECT DISTINCT  ' ' AS 'Medicare providers that accept Medicaid UPDATE(S)',[MedicaidMedicareFlag],[FUTURE_TERM] FROM INFORMATICS.dbo.PROVDIR_DLC

		UNION
		SELECT DISTINCT  ' ' AS 'Medicare providers that accept Medicaid UPDATE(S)',[MedicaidMedicareFlag],[FUTURE_TERM] FROM INFORMATICS.dbo.PROVDIR_URC

		UNION
		SELECT DISTINCT  ' ' AS 'Medicare providers that accept Medicaid UPDATE(S)',[MedicaidMedicareFlag],[FUTURE_TERM] FROM INFORMATICS.dbo.PROVDIR_MIN

		UNION
		SELECT DISTINCT  ' ' AS 'Medicare providers that accept Medicaid UPDATE(S)',[MedicaidMedicareFlag],[FUTURE_TERM] FROM INFORMATICS.dbo.PROVDIR_PPH

		UNION
		SELECT DISTINCT  ' ' AS 'Medicare providers that accept Medicaid UPDATE(S)',[MedicaidMedicareFlag],[FUTURE_TERM] FROM INFORMATICS.dbo.PROVDIR_CLINIC

		UNION
		SELECT DISTINCT  ' ' AS 'Medicare providers that accept Medicaid UPDATE(S)',[MedicaidMedicareFlag],[FUTURE_TERM] FROM INFORMATICS.dbo.PROVDIR_PHARM

		UNION
		SELECT DISTINCT  ' ' AS 'Medicare providers that accept Medicaid UPDATE(S)',[MedicaidMedicareFlag],[FUTURE_TERM] FROM INFORMATICS.dbo.PROVDIR_ECMCSP







JAH 'PROVDIR D-SNP UPDATE' - 'FROM:LUPITA SUBJECT:'
^ Medicare providers that accept Medicaid

ALTER TABLE INFORMATICS.dbo.TimelyAccessPCP_ECM_Extender
ADD -- INITIATE ... ADD OF COLUMN(s)
[MedicaidMedicareFlag] varchar(max) DEFAULT NULL -- DFLT VAL() IS NULL
; -- CONCLUDE ...

		SELECT * FROM INFORMATICS.dbo.TimelyAccessPCP
		SELECT * FROM INFORMATICS.dbo.TimelyAccessPCP_Extender
		SELECT * FROM INFORMATICS.dbo.TimelyAccessSPE - see  '(#SPE,#SPEb,#SPEc,#SPEd)'
		SELECT * FROM INFORMATICS.dbo.TimelyAccessFAC
		SELECT * FROM INFORMATICS.dbo.TimelyAccessCLINICCMC
		SELECT * FROM INFORMATICS.dbo.TimelyAccessCLINIC
		SELECT * FROM INFORMATICS.dbo.TimelyAccessPHARM

		SELECT * FROM INFORMATICS.dbo.SANATOR_TimelyAccessPCP
		SELECT * FROM INFORMATICS.dbo.SANATOR_TimelyAccessPCP_Extender
		SELECT * FROM INFORMATICS.dbo.SANATOR_TimelyAccessSPE - see  '(#SPE,#SPEb,#SPEc,#SPEd)'
		SELECT * FROM INFORMATICS.dbo.SANATOR_TimelyAccessFAC
		SELECT * FROM INFORMATICS.dbo.SANATOR_TimelyAccessCLINICCMC
		SELECT * FROM INFORMATICS.dbo.SANATOR_TimelyAccessCLINIC
		SELECT * FROM INFORMATICS.dbo.SANATOR_TimelyAccessPHARM

		SELECT * FROM INFORMATICS.dbo.TimelyAccessPCP_ECM
		SELECT * FROM INFORMATICS.dbo.TimelyAccessPCP_ECM_Extender
		SELECT * FROM INFORMATICS.dbo.TimelyAccessSPE_ECM - see  '(#SPE,#SPEb,#SPEc,#SPEd)'
		SELECT * FROM INFORMATICS.dbo.TimelyAccessFAC_ECM
		SELECT * FROM INFORMATICS.dbo.TimelyAccessCLINIC_ECMCMC
		SELECT * FROM INFORMATICS.dbo.TimelyAccessCLINIC_ECM
		SELECT * FROM INFORMATICS.dbo.TimelyAccessPHARM_ECM

		SELECT [MedicaidMedicareFlag],* FROM INFORMATICS.dbo.PROVDIR_PCP --PROV(s)
		SELECT [MedicaidMedicareFlag],* FROM INFORMATICS.dbo.PROVDIR_NPMP --MIDLEVEL(s) NPMP
		SELECT [MedicaidMedicareFlag],* FROM INFORMATICS.dbo.PROVDIR_SPE --PROV(s)
		SELECT [MedicaidMedicareFlag],* FROM INFORMATICS.dbo.PROVDIR_MH --PROV(s)
		SELECT [MedicaidMedicareFlag],* FROM INFORMATICS.dbo.PROVDIR_AHP --PROV(s)
		SELECT [MedicaidMedicareFlag],* FROM INFORMATICS.dbo.PROVDIR_VSP --PROV(s)

		SELECT [MedicaidMedicareFlag],* FROM INFORMATICS.dbo.PROVDIR_ECMCSP --PROV(s)

		SELECT [MedicaidMedicareFlag],* FROM INFORMATICS.dbo.SANATOR_PROVDIR_PCP --PROV(s)
		SELECT [MedicaidMedicareFlag],* FROM INFORMATICS.dbo.SANATOR_PROVDIR_NPMP --MIDLEVEL(s) NPMP
		SELECT [MedicaidMedicareFlag],* FROM INFORMATICS.dbo.SANATOR_PROVDIR_SPE --PROV(s)
		SELECT [MedicaidMedicareFlag],* FROM INFORMATICS.dbo.SANATOR_PROVDIR_MH --PROV(s)
		SELECT [MedicaidMedicareFlag],* FROM INFORMATICS.dbo.SANATOR_PROVDIR_AHP --PROV(s)
		SELECT [MedicaidMedicareFlag],* FROM INFORMATICS.dbo.SANATOR_PROVDIR_VSP --PROV(s)

UPDATE INFORMATICS.dbo.PROVDIR_PCP
SET [MMF] = CAST([MedicaidMedicareFlag] AS nvarchar(25))

UPDATE INFORMATICS.dbo.PROVDIR_NPMP
SET [MMF] = CAST([MedicaidMedicareFlag] AS nvarchar(25))

UPDATE INFORMATICS.dbo.PROVDIR_SPE
SET [MMF] = CAST([MedicaidMedicareFlag] AS nvarchar(25))

UPDATE INFORMATICS.dbo.PROVDIR_MH
SET [MMF] = CAST([MedicaidMedicareFlag] AS nvarchar(25))

UPDATE INFORMATICS.dbo.PROVDIR_AHP
SET [MMF] = CAST([MedicaidMedicareFlag] AS nvarchar(25))

UPDATE INFORMATICS.dbo.PROVDIR_VSP
SET [MMF] = CAST([MedicaidMedicareFlag] AS nvarchar(25))

,CAST('Both' AS nvarchar(25)) AS [MedicaidMedicareFlag],CAST(NULL as nvarchar(25)) AS [MMF]

UPDATE #INNETWORK_FAC
SET [MedicaidMedicareFlag] = 'Medicaid Only'
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st',
FROM #INNETWORK_FAC
WHERE [Participating Network] IN ('CL1')
	AND PracticeID NOT IN 
	( -- INITIATE ...
	SELECT DISTINCT PracticeID
	FROM #INNETWORK_FAC
	WHERE [Participating Network] IN ('MCR')
	) -- CONCLUDE ...
	AND LocationID NOT IN 
	( -- INITIATE ...
	SELECT DISTINCT LocationID
	FROM #INNETWORK_FAC
	WHERE [Participating Network] IN ('MCR')
	) -- CONCLUDE ...

UPDATE #INNETWORK_FAC
SET [MedicaidMedicareFlag] = 'Medicare Only'
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st',
FROM #INNETWORK_FAC
WHERE [Participating Network] IN ('MCR')
	AND PracticeID NOT IN 
	( -- INITIATE ...
	SELECT DISTINCT PracticeID
	FROM #INNETWORK_FAC
	WHERE [Participating Network] IN ('CL1')
	) -- CONCLUDE ...
	AND LocationID NOT IN 
	( -- INITIATE ...
	SELECT DISTINCT LocationID
	FROM #INNETWORK_FAC
	WHERE [Participating Network] IN ('CL1')
	) -- CONCLUDE ...

UPDATE #INNETWORK_PROV
SET [MedicaidMedicareFlag] = 'Medicaid Only'
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st',
FROM #INNETWORK_PROV
WHERE [Participating Network] IN ('CL1')
	AND PractitionerID NOT IN 
	( -- INITIATE ...
	SELECT DISTINCT PractitionerID
	FROM #INNETWORK_PROV
	WHERE [Participating Network] IN ('MCR')
	) -- CONCLUDE ...
	AND PracticeID NOT IN 
	( -- INITIATE ...
	SELECT DISTINCT PracticeID
	FROM #INNETWORK_PROV
	WHERE [Participating Network] IN ('MCR')
	) -- CONCLUDE ...
	AND LocationID NOT IN 
	( -- INITIATE ...
	SELECT DISTINCT LocationID
	FROM #INNETWORK_PROV
	WHERE [Participating Network] IN ('MCR')
	) -- CONCLUDE ...

UPDATE #INNETWORK_PROV
SET [MedicaidMedicareFlag] = 'Medicare Only'
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st',
FROM #INNETWORK_PROV
WHERE [Participating Network] IN ('MCR')
	AND PractitionerID NOT IN 
	( -- INITIATE ...
	SELECT DISTINCT PractitionerID
	FROM #INNETWORK_PROV
	WHERE [Participating Network] IN ('CL1')
	) -- CONCLUDE ...
	AND PracticeID NOT IN 
	( -- INITIATE ...
	SELECT DISTINCT PracticeID
	FROM #INNETWORK_PROV
	WHERE [Participating Network] IN ('CL1')
	) -- CONCLUDE ...
	AND LocationID NOT IN 
	( -- INITIATE ...
	SELECT DISTINCT LocationID
	FROM #INNETWORK_PROV
	WHERE [Participating Network] IN ('CL1')
	) -- CONCLUDE ...

x 'SUBJECT:D-SNP Directory for 2024  FROM:LIUPITA'
Hello Walter, 
Can you please help me with the following specs for our D-SNP directory? I was able to find some changes that we need to do to how the providers are displayed. Please see what is highlighted in page 15 and 17. Please let me know if there are any additional changes we would need to do to our Provider and Pharmacy listings.

Thank you for all your help,  
Lupita Alvarado 
Provider Quality Assurance Analyst
Phone: (619) 498-6431 
malvarado@chgsd.com
 
		SELECT [Participating Network],LastName,FirstName,NPIis,* FROM INFORMATICS.dbo.TimelyAccessSPE WHERE NPIis IN ('1710466008','1497138002')
		SELECT COUNT(DISTINCT(NPIis)) AS 'DENOMINATOR' FROM INFORMATICS.dbo.TimelyAccessSPE

-- SELECT ' ' AS 'Medicaid Only CHECK',[Participating Network],LastName,FirstName,NPIis,*
SELECT COUNT(DISTINCT(NPIis)) AS 'Medicaid Only NUMERATOR'
FROM INFORMATICS.dbo.TimelyAccessSPE
WHERE [Participating Network] IN ('CL1')
	AND PractitionerID NOT IN 
	( -- INITIATE ...
	SELECT DISTINCT PractitionerID
	FROM INFORMATICS.dbo.TimelyAccessSPE
	WHERE [Participating Network] IN ('MCR')
	) -- CONCLUDE ...
	AND PracticeID NOT IN 
	( -- INITIATE ...
	SELECT DISTINCT PracticeID
	FROM INFORMATICS.dbo.TimelyAccessSPE
	WHERE [Participating Network] IN ('MCR')
	) -- CONCLUDE ...
	AND LocationID NOT IN 
	( -- INITIATE ...
	SELECT DISTINCT LocationID
	FROM INFORMATICS.dbo.TimelyAccessSPE
	WHERE [Participating Network] IN ('MCR')
	) -- CONCLUDE ...

-- SELECT ' ' AS 'Medicare Only CHECK',[Participating Network],LastName,FirstName,NPIis,*
SELECT COUNT(DISTINCT(NPIis)) AS 'Medicare Only NUMERATOR'
FROM INFORMATICS.dbo.TimelyAccessSPE
WHERE [Participating Network] IN ('MCR')
	AND PractitionerID NOT IN 
	( -- INITIATE ...
	SELECT DISTINCT PractitionerID
	FROM INFORMATICS.dbo.TimelyAccessSPE
	WHERE [Participating Network] IN ('CL1')
	) -- CONCLUDE ...
	AND PracticeID NOT IN 
	( -- INITIATE ...
	SELECT DISTINCT PracticeID
	FROM INFORMATICS.dbo.TimelyAccessSPE
	WHERE [Participating Network] IN ('CL1')
	) -- CONCLUDE ...
	AND LocationID NOT IN 
	( -- INITIATE ...
	SELECT DISTINCT LocationID
	FROM INFORMATICS.dbo.TimelyAccessSPE
	WHERE [Participating Network] IN ('CL1')
	) -- CONCLUDE ...







		SELECT [MedicaidMedicareFlag],* FROM INFORMATICS.dbo.PROVDIR_PCP WHERE [Participating Network] = 'MCR' AND NPIis IN ('1295746618')

		USE: http://chgtableau - '[Server]'
		USE https://www.tableau.com/ - '[Account management]' 		
		USE: https://chgtableau.chgsd.com - 'TABLEAU APP'

ALTER TABLE INFORMATICS.dbo.PROVDIR_PCP
ADD -- INITIATE ... ADD OF COLUMN(s)
[MMF] nvarchar(25) DEFAULT NULL -- DFLT VAL() IS NULL
; -- CONCLUDE ...

UPDATE INFORMATICS.dbo.PROVDIR_PCP
SET [MMF] = CAST([MedicaidMedicareFlag] AS nvarchar(25))

ALTER TABLE INFORMATICS.dbo.PROVDIR_PCP
ALTER COLUMN --INITIATE ... ALTER() COLUMN(s) DATA TYPE
[MedicaidMedicareFlag] nvarchar (25) -- see [1] int  --[2] int  --[3] int  --[4] int  --[5] int  --[6] int  --[7] int  --[8] int  --[9] int  --[10] int  --[11] int  --[12] int  --[TotalCOL] int
; -- CONCLUDE ...

GROUP BY ALL - IN 'SNOWFLAKE'
		USE https://www.linkedin.com/posts/soumakdas_snowflake-snowflakesummit-snowflakesummit2023-activity-7087392269967765504-OaYF?utm_source=share&utm_medium=member_desktop







JAH 'PROVDIR DSNP TRANSITION'
... INTO INFORMATICS.dbo.PROVDIR_HOSMH
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT HOSPITAL_IDENTIFICATION,[Participating Network],ISNULL(CAST(spe.HospitalName AS nvarchar(100)),'')+' '+ISNULL(CAST(spe.HOSPabbrev AS nvarchar(100)),'')+' ID# '+ISNULL(CAST(spe.provider_no AS nvarchar(25)),'') COLLATE DATABASE_DEFAULT AS [TESTING],HOSPITAL_IDENTIFICATION -- CHECK 1st
FROM INFORMATICS.dbo.TimelyAccessFAC AS spe
WHERE ( -- INITIATE ... 
[Participating Network] IN ('CMC','MCR') -- DSNP TRANSITION FROM CMC GO LIVE ON '01/01/2023'
	-- AND UPPER(LTRIM(RTRIM(ISNULL(spe.[Type of Service FOCUS],'')))) NOT LIKE '%GAH%'
	AND (UPPER(LTRIM(RTRIM(ISNULL(spe.[Type of Service FOCUS],'')))) LIKE '%MH%') --  ,UPPER(LTRIM(RTRIM(vlp.focus))) AS [Type of Service FOCUS] per NETWORK REPORT DISCUSSION NO MH BENEFIT FOR MEDI-CAL
	AND spe.plan_type = 'FACILITY'
	AND spe.[vlpSTATUSTYPENAME] LIKE 'ACTIVE%' --•	ADD ON TO FAC per PROVDIR meeting ON 20171226
) -- CONCLUDE ... B
/* OR UPPER(LTRIM(RTRIM(spe.NPIis))) IN ('1063589620','1205816931','1457321317','1598722027','1639172133','1659354173','1962438200') --ATTEMPT TO MIMIC VIP LOGIC ...  */

... INTO INFORMATICS.dbo.SANATOR_PROVDIR_HOSMH
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT HOSPITAL_IDENTIFICATION,[Participating Network],ISNULL(CAST(spe.HospitalName AS nvarchar(100)),'')+' '+ISNULL(CAST(spe.HOSPabbrev AS nvarchar(100)),'')+' ID# '+ISNULL(CAST(spe.provider_no AS nvarchar(25)),'') COLLATE DATABASE_DEFAULT AS [TESTING],HOSPITAL_IDENTIFICATION -- CHECK 1st
FROM INFORMATICS.dbo.SANATOR_TimelyAccessFAC AS spe
WHERE ( -- INITIATE ... 
[Participating Network] IN ('CMC','MCR') -- DSNP TRANSITION FROM CMC GO LIVE ON '01/01/2023'
	-- AND UPPER(LTRIM(RTRIM(ISNULL(spe.[Type of Service FOCUS],'')))) NOT LIKE '%GAH%'
	AND (UPPER(LTRIM(RTRIM(ISNULL(spe.[Type of Service FOCUS],'')))) LIKE '%MH%') --  ,UPPER(LTRIM(RTRIM(vlp.focus))) AS [Type of Service FOCUS] per NETWORK REPORT DISCUSSION NO MH BENEFIT FOR MEDI-CAL
	AND spe.plan_type = 'FACILITY'
	AND spe.[vlpSTATUSTYPENAME] LIKE 'ACTIVE%' --•	ADD ON TO FAC per PROVDIR meeting ON 20171226
) -- CONCLUDE ... B
/* OR UPPER(LTRIM(RTRIM(spe.NPIis))) IN ('1063589620','1205816931','1457321317','1598722027','1639172133','1659354173','1962438200') --ATTEMPT TO MIMIC VIP LOGIC ...  */







ON LINE #4001
------------------------------------------------------------------------------------------------------------------------
	-- Error Trapping: Check If Permanent Table(s) Already Exist(s) And Drop If Applicable --
------------------------------------------------------------------------------------------------------------------------
TRUNCATE TABLE
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
INFORMATICS.dbo.TimelyAccessCLINICCMC

INSERT INTO INFORMATICS.dbo.TimelyAccessCLINICCMC -- ([FIELD])
SELECT DISTINCT *
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM INFORMATICS.dbo.TimelyAccessCLINIC
WHERE [Participating Network] IN ('CL1')

					UPDATE INFORMATICS.dbo.TimelyAccessCLINICCMC
					SET [Participating Network] = 'CMC'
					,[Name of Network] = 'CalMediConnect'
					-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
					-- SELECT DISTINCT ' ' AS 'CHECK 1st'
					FROM INFORMATICS.dbo.TimelyAccessCLINICCMC
					WHERE [Participating Network] IN ('CL1')

INSERT INTO INFORMATICS.dbo.TimelyAccessCLINICCMC -- ([FIELD])
SELECT DISTINCT *
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM INFORMATICS.dbo.TimelyAccessCLINIC
WHERE [Participating Network] IN ('CL1')

					UPDATE INFORMATICS.dbo.TimelyAccessCLINICCMC
					SET [Participating Network] = 'MCR' -- DSNP TRANSITION FROM CMC GO LIVE ON '01/01/2023'
					,[Name of Network] = 'Communicare_Advantage'
					-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
					-- SELECT DISTINCT ' ' AS 'CHECK 1st'
					FROM INFORMATICS.dbo.TimelyAccessCLINICCMC
					WHERE [Participating Network] IN ('CL1')

INSERT INTO INFORMATICS.dbo.TimelyAccessCLINIC -- (...) ADD CMC RECORD(s) MANUAL SINCE SWITCH FROM 'B' [Participating Network]
SELECT * -- SELECT DISTINCT ...
--SELECT TOP 100 * --CHECK 1st
--SELECT DISTINCT ratecode,[COAgroup] --CHECK 1st
FROM INFORMATICS.dbo.TimelyAccessCLINICCMC

					UPDATE INFORMATICS.dbo.TimelyAccessCLINIC
					SET [AGE RESTRICTION] = 'NONE' -- per eMAIL FROM MS. MARYANNE ON 20181218 'The community clinics can be defaulted to the below.'
					-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
					-- SELECT DISTINCT ' ' AS 'CHECK 1st'
					FROM INFORMATICS.dbo.TimelyAccessCLINIC
					
					UPDATE INFORMATICS.dbo.TimelyAccessCLINIC
					SET [AGE RESTRICTION] = '21 AND OVER' -- per eMAIL FROM MS. MARYANNE ON 20181218 'The community clinics can be defaulted to the below.'
					-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
					-- SELECT DISTINCT ' ' AS 'CHECK 1st'
					FROM INFORMATICS.dbo.TimelyAccessCLINIC
					WHERE [Participating Network] IN ('CMC','MCR') -- DSNP TRANSITION FROM CMC GO LIVE ON '01/01/2023'







------------------------------------------------------------------------------------------------------------------------
	-- Error Trapping: Check If Permanent Table(s) Already Exist(s) And Drop If Applicable --
------------------------------------------------------------------------------------------------------------------------
TRUNCATE TABLE
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
INFORMATICS.dbo.TimelyAccessCLINIC_ECMCMC

INSERT INTO INFORMATICS.dbo.TimelyAccessCLINIC_ECMCMC -- ([FIELD])
SELECT DISTINCT *
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM INFORMATICS.dbo.TimelyAccessCLINIC_ECM
WHERE [Participating Network] IN ('CL1')

					UPDATE INFORMATICS.dbo.TimelyAccessCLINIC_ECMCMC
					SET [Participating Network] = 'CMC' -- PENDING DSNP TRANSITION FROM CMC GO LIVE ON '01/01/2023'
					,[Name of Network] = 'CalMediConnect'
					-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
					-- SELECT DISTINCT ' ' AS 'CHECK 1st'
					FROM INFORMATICS.dbo.TimelyAccessCLINIC_ECMCMC
					WHERE [Participating Network] IN ('CL1')
					
INSERT INTO INFORMATICS.dbo.TimelyAccessCLINIC_ECMCMC -- ([FIELD])
SELECT DISTINCT *
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM INFORMATICS.dbo.TimelyAccessCLINIC_ECM
WHERE [Participating Network] IN ('CL1')

					UPDATE INFORMATICS.dbo.TimelyAccessCLINIC_ECMCMC
					SET [Participating Network] = 'MCR' -- DSNP TRANSITION FROM CMC GO LIVE ON '01/01/2023'
					,[Name of Network] = 'Communicare_Advantage'
					-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
					-- SELECT DISTINCT ' ' AS 'CHECK 1st'
					FROM INFORMATICS.dbo.TimelyAccessCLINIC_ECMCMC
					WHERE [Participating Network] IN ('CL1')

INSERT INTO INFORMATICS.dbo.TimelyAccessCLINIC_ECM -- (...) ADD CMC RECORD(s) MANUAL SINCE SWITCH FROM 'B' [Participating Network]
SELECT * -- SELECT DISTINCT ...
--SELECT TOP 100 * --CHECK 1st
--SELECT DISTINCT ratecode,[COAgroup] --CHECK 1st
FROM INFORMATICS.dbo.TimelyAccessCLINIC_ECMCMC

					UPDATE INFORMATICS.dbo.TimelyAccessCLINIC_ECM
					SET [AGE RESTRICTION] = 'NONE' -- per eMAIL FROM MS. MARYANNE ON 20181218 'The community clinics can be defaulted to the below.'
					-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
					-- SELECT DISTINCT ' ' AS 'CHECK 1st'
					FROM INFORMATICS.dbo.TimelyAccessCLINIC_ECM
					
					UPDATE INFORMATICS.dbo.TimelyAccessCLINIC_ECM
					SET [AGE RESTRICTION] = '21 AND OVER' -- per eMAIL FROM MS. MARYANNE ON 20181218 'The community clinics can be defaulted to the below.'
					-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
					-- SELECT DISTINCT ' ' AS 'CHECK 1st'
					FROM INFORMATICS.dbo.TimelyAccessCLINIC_ECM
					WHERE [Participating Network] IN ('CMC','MCR') -- DSNP TRANSITION FROM CMC GO LIVE ON '01/01/2023'







------------------------------------------------------------------------------------------------------------------------
	-- Error Trapping: Check If Permanent Table(s) Already Exist(s) And Drop If Applicable --
------------------------------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS INFORMATICS.dbo.SANATOR_TimelyAccessCLINICCMC -- SQL Server 2016 and later -- DYNAMIC tmp OR STATIC [TABLE] #TableName is a local temporary table visible only in the current session; #TableName is a GLOBAL temporary table visible to all sessions IN ('TempDB')

SELECT DISTINCT *
INTO INFORMATICS.dbo.SANATOR_TimelyAccessCLINICCMC
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM INFORMATICS.dbo.SANATOR_TimelyAccessCLINIC
WHERE [Participating Network] IN ('CL1')

					UPDATE INFORMATICS.dbo.SANATOR_TimelyAccessCLINICCMC
					SET [Participating Network] = 'CMC'
					,[Name of Network] = 'CalMediConnect'
					-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
					-- SELECT DISTINCT ' ' AS 'CHECK 1st'
					FROM INFORMATICS.dbo.SANATOR_TimelyAccessCLINICCMC
					WHERE [Participating Network] IN ('CL1')

INSERT INTO INFORMATICS.dbo.SANATOR_TimelyAccessCLINICCMC -- ([FIELD])
SELECT DISTINCT *
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM INFORMATICS.dbo.TimelyAccessCLINIC
WHERE [Participating Network] IN ('CL1')

					UPDATE INFORMATICS.dbo.SANATOR_TimelyAccessCLINICCMC
					SET [Participating Network] = 'MCR' -- DSNP TRANSITION FROM CMC GO LIVE ON '01/01/2023'
					,[Name of Network] = 'Communicare_Advantage'
					-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
					-- SELECT DISTINCT ' ' AS 'CHECK 1st'
					FROM INFORMATICS.dbo.SANATOR_TimelyAccessCLINICCMC
					WHERE [Participating Network] IN ('CL1')

INSERT INTO INFORMATICS.dbo.SANATOR_TimelyAccessCLINIC -- (...) ADD CMC RECORD(s) MANUAL SINCE SWITCH FROM 'B' [Participating Network]
SELECT * -- SELECT DISTINCT ...
--SELECT TOP 100 * --CHECK 1st
--SELECT DISTINCT ratecode,[COAgroup] --CHECK 1st
FROM INFORMATICS.dbo.SANATOR_TimelyAccessCLINICCMC

UPDATE INFORMATICS.dbo.SANATOR_TimelyAccessCLINIC
SET [AGE RESTRICTION] = 'NONE' -- per eMAIL FROM MS. MARYANNE ON 20181218 'The community clinics can be defaulted to the below.'
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM INFORMATICS.dbo.SANATOR_TimelyAccessCLINIC

UPDATE INFORMATICS.dbo.SANATOR_TimelyAccessCLINIC
SET [AGE RESTRICTION] = '21 AND OVER' -- per eMAIL FROM MS. MARYANNE ON 20181218 'The community clinics can be defaulted to the below.'
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM INFORMATICS.dbo.SANATOR_TimelyAccessCLINIC
WHERE [Participating Network] IN ('CMC','MCR') -- DSNP TRANSITION FROM CMC GO LIVE ON '01/01/2023'







JAH 'ECM CSP CHAPTER IMPLEMENTATION'
EXEC [INFORMATICS].dbo.[PROVDIRECMCSP]; -- IN [SERVERname] see 'CHECKLIST_SSRS_...sql' AND 'STEP88_sp_STOREDPROCEDURE_...sql'

-- ===================================================================
	-- DEVELOP [Office Hour(s)] PROVDIR ENTRY--
-- ===================================================================
		-- SELECT * FROM #HOURS_FAC

-- =====================================================================
	-- INSERT STATEMENTS FOR PROCEDURE HERE:
-- =====================================================================
		SELECT DISTINCT  'ECM / CSPs CHAPTER DEVELOPMENT LIST' AS [MESSAGE(S)],[Participating Network],Specialty,DBA,INDEXNM
		,COUNT(DISTINCT(INDEXNM+Address)) AS [ECM CSPs Provider(s)]
		-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
		-- SELECT DISTINCT ' ' AS 'CHECK 1st'
		FROM INFORMATICS.dbo.PROVDIR_ECMCSP
		WHERE DBA LIKE '%MAESTRA%'
		--WHERE [Participating Network] = 'CMC'
		--	AND Specialty NOT IN (' Enhanced Care Management')
		GROUP BY [Participating Network],Specialty,CHAPTER_COUNT
		ORDER BY [Participating Network],Specialty,DBA,INDEXNM

		SELECT 'SAMPLE NEW CHAPTER FOR ECM / CSPs' AS [MESSAGE(S)],[Office Hour(s)],* 
		FROM INFORMATICS.dbo.PROVDIR_ECMCSP
		-- WHERE [Office Hour(s)] LIKE '%7%DAYS%'
		WHERE INDEXNM LIKE '%JEWISH%'

		SELECT 'SAMPLE NEW CHAPTER FOR ECM / CSPs' AS [MESSAGE(S)],h.*,e.TwentyFourHourCoverage,e.[Office Hour(s)],e.* 
		FROM INFORMATICS.dbo.TimelyAccessFAC_ECM AS e
			LEFT JOIN #HOURS_FAC AS h ON e.PracticeID = h.PracticeID
				AND e.LocationID = h.LocationID
		WHERE [Clinic Name] LIKE '%JEWISH%'

		SELECT 'SAMPLE NEW CHAPTER FOR ECM / CSPs' AS [MESSAGE(S)],[Participating Network],LocationID,PracticeID,ProductID,VLP_Alt_plan_type AS [ProductTypeCode],vlpSERVICETYPENAME,vlpSERVICETYPENAME AS [Specialty],PracticeName,LocationName,HospitalName,[Clinic Name],*
		FROM INFORMATICS.dbo.TimelyAccessFAC_ECM AS e
		WHERE DBA LIKE '%MAESTRA%'
		-- WHERE VLP_Alt_plan_type = 'CSP'
		-- WHERE vlpSERVICETYPENAME LIKE '%MRI%'
-- =====================================================================
	-- CONCLUDE STATEMENTS FOR PROCEDURE HERE:
-- =====================================================================

SELECT TOP 100 * -- CHECK 1st
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM INFORMATICS.dbo.HSDfacility AS hf 
WHERE Name IN ('OTAY LAKES SURGERY CENTER')

SELECT TOP 100 * -- CHECK 1st
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM INFORMATICS.dbo.HSDprovider AS hp
WHERE [Name of Physician or Mid-Level Practitioner] IN ('PRANAB BARMAN')

SELECT vpl.LocationID,vp.*
FROM eVips_chgcv.dbo.vwPractices AS vp
	JOIN eVips_chgcv.dbo.vwPracticeLocations AS vpl ON vp.PracticeID = vpl.PracticeID
-- WHERE vpl.Notes IN ('5641373','5653333','5653334','5653335')
WHERE vpl.LocationName LIKE '%AMERICAN%TRUE%'

SELECT vpl.LocationID,vpl.*
FROM eVips_chgcv.dbo.vwPractices AS vp
	JOIN eVips_chgcv.dbo.vwPracticeLocations AS vpl ON vp.PracticeID = vpl.PracticeID
-- WHERE vpl.Notes IN ('5641373','5653333','5653334','5653335')
WHERE vpl.LocationName LIKE '%AMERICAN%TRUE%'

SELECT [Clinic QNXT provid],[Participating Network],Specialty,DBA,INDEXNM,PROVNM,* FROM INFORMATICS.dbo.PROVDIR_ECMCSP AS e WHERE INDEXNM LIKE '%AMERICAN%TRUE%'

SELECT vpl.Notes,*
FROM eVips_chgcv.dbo.vwPracticeLocations AS vpl
WHERE vpl.Notes IN ('5641373','5653333','5653334','5653335')







JAH 'REMOVE MEDI - CAL PHARM CHAPTER(S)'
EXEC [INFORMATICS].dbo.[PROVDIRECMCSP]; -- LEVERAGE: Provider Directory refresh sequence - The ECM CS Script has executed we now await completion of the regular script  ...  IN SQLPRODAPP01
EXEC [INFORMATICS].dbo.[PROVDIRREFRESH]; -- LEVERAGE: SSA (SQL SERVER AGENT) JOB - "Provider Directory refresh sequence -The regular script has executed we may now proceed with the DirectoryExpert step" IN SQLPRODAPP01

x Search "_PHARM" (87 hits in 1 file of 1 searched)
  C:\Users\wcarr\Desktop\eVIPS_PROVDIR_STEP03_VIP_20220427.sql (87 hits)
		SELECT * FROM INFORMATICS.dbo.PROVDIR_PHARM WHERE [Participating Network] IN ('CL1')
		SELECT * FROM INFORMATICS.dbo.PROVDIR_PHARM_RCP WHERE [Participating Network] IN ('CL1')
		SELECT * FROM INFORMATICS.dbo.PROVDIR_PHARM_MO WHERE [Participating Network] IN ('CL1')
		SELECT * FROM INFORMATICS.dbo.PROVDIR_PHARM_HI WHERE [Participating Network] IN ('CL1')
		SELECT * FROM INFORMATICS.dbo.PROVDIR_PHARM_LTC WHERE [Participating Network] IN ('CL1')
		SELECT * FROM INFORMATICS.dbo.PROVDIR_PHARM_ITU WHERE [Participating Network] IN ('CL1')

JAH ADD 'ECMCS' CHAPTER
-- EXEC [INFORMATICS].dbo.[PROVDIRREFRESH];
-- EXEC [INFORMATICS].dbo.[PROVDIRECMCSP];

-- CREATE PROCEDURE dbo.[ECMCSP] --<Procedure_Name, sysname, ProcedureName>
ALTER PROCEDURE dbo.[ECMCSP] --<Procedure_Name, sysname, ProcedureName>
-- DROP PROCEDURE dbo.[ECMCSP] --<Procedure_Name, sysname, ProcedureName>

SELECT DISTINCT DBA,INDEXNM,Specialty
FROM INFORMATICS.dbo.PROVDIR_ECMCSP

SELECT [Participating Network] COLLATE DATABASE_DEFAULT AS [Participating Network] -- ,plan_type
,COUNT(DISTINCT(PROVNM)) AS [RECORD COUNT]
,'Enhanced Care Management & Community Supports Providers' AS [NOTE(s)]
,CAST(NULL AS nvarchar(255)) AS [ONLINE_TITLE],CAST(NULL AS int) AS [TOTAL],UPDATEDT_FOOTNOTE
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
FROM INFORMATICS.dbo.PROVDIR_ECMCSP
GROUP BY [Participating Network],UPDATEDT_FOOTNOTE
-- ORDER BY [Participating Network] COLLATE DATABASE_DEFAULT AS [Participating Network] -- ,plan_type

SELECT * FROM INFORMATICS.dbo.PROVDIR_ECMCSP







JAH 'eMAIL' ON 20220410
x CAHRINDEX() FIND() SEARCH() 'SUBJECT: Q2 DBA & Emails report FROM:SANDRA'
Hi,  We have the need to update our Sanator file for providers.  We should add the Cred Contact emails for the groups that we want Symphony to send emails to.  Monse has been sending a separate file each quarter.  Since Symphony is transitioning to Availity, we need the “Email Is” column to be our Cred contact email.  Symphony responded state the emails sent will use this field.   You are currently using the location email in this column.  Please switch it.

The Cred Contact email field is InternalContact.EmailAddress where LocationTypeName is Cred Contact.  Please do not add the Cred location email.

To make sure Availity does not send an email to certain groups, please omit emails for the following groups:

		1)	Remove groups with 50+ practitioners.  Our large groups attest quarterly via rosters.  If a group have 50 or more distinct NPI, the cred contact email should not be added.
		2)	Remove FEID with multiple DBA names
		3)	Remove the following Goups/DBAs:

				a.	Pharmacies (ProviderProductService.ServicTypeName = Pharmacy)
				b.	VSP (Practice.PracticeName is like “- VSP”)
				c.	PTPN (Practice.PracticeName is like “- PTPN”)

Let me know if we need to meet to review this.

	Line 987: ,REPLACE(UPPER(LTRIM(RTRIM(vf.TaxIDNumber))),'-','') AS vfPROVTAXID -- #INNETWORK_FAC

	Line 1136: ,REPLACE(UPPER(LTRIM(RTRIM(vp.TaxIDNumber))),'-','') AS PROVTAXID -- #INNETWORK_PROV







SELECT DISTINCT ic.EmailAddress,ic.ParentRecID,ic.ContactName,ic.ContactTitle,ic.Notes,pl.LocationTypeName,pl.LocationID,pl.PracticeID,pl.AddressID,pl.LocationName,pl.PracticeCode,pl.PracticeNationalProviderID,pl.TaxIDNumber,pl.NationalProviderID,pl.PracticeName,pl.PracticeLegalName,pl.LegalName -- ic.*,pl.* 
	FROM evips_chgcv.dbo.vwPracticeLocations AS pl
		JOIN evips_chgcv.dbo.vwInternalContacts AS ic ON pl.LocationID = ic.ParentRecID
	-- WHERE PracticeID IN ('4107300')
	WHERE ISNULL(ic.EmailAddress,'') != ''
		AND pl.LocationName IN ('Advanced Counseling Center of San Diego')

		-- AND ParentRecID IN ('4107302','4107301','4107303','4107305','5178615')
		AND UPPER(LTRIM(RTRIM(ISNULL(pl.LocationTypeName,'')))) LIKE  '%CRED%CONTACT%'

SELECT EMAILis,DBA,* FROM #INNETWORK_FAC WHERE [ASSOCIATION GROUP] LIKE '%ADVANCED COUNSELING CENTER OF SAN%'
SELECT EMAILis,* FROM #INNETWORK_PROV WHERE [ASSOCIATION GROUP] LIKE '%ADVANCED COUNSELING CENTER OF SAN%'

-- dbp...@... ROSTAMITHERAPYCENTER@GMAIL.COM	Y	ADVANCED COUNSELING CENTER OF SAN DIEGO
-- info4...@...  ENSOMEDICALBILLING@YAHOO.COM	Y	ADVANCED THERAPY SERVICES
-- ...@... AISHA

USE evips_chgcv -- EXEC IN [SERVERname]; SCHEMA() SELECT * FROM 'SERVERname'.'DATABASEname'.'SCHEMAname'.'OBJECTname' - FOUR (4) PART() SCHEMA() aka [SERVERname].[DATABASEname].[SCHEMAname].[OBJECTname] - see '[SQL13].[CHGAPP_PROD].dbo.[tblEDIDHCSType834]' PERHAPS AID IN RESOLVING RUNTIME ISSUE??? AS OF 20180808 Thanks for sending this. Something occurred to me last night.  Allyson was having a similar issue because she as connected to the master database when she was executing her query.  She was doing the same as you…pulling data from HMOPROD_PlanData and writing it to Informatics.  But she was executing from the master database.  And I think I saw last night that you might have been doing the same thing.  And I think your default database on SQLPROD02 might be master.  Do you recall which database you were connected to?  Jeremy

DECLARE @tblis AS nvarchar (100)
DECLARE @tbltype AS nvarchar (100)
DECLARE @tblwas AS nvarchar (100)
DECLARE @tblwillbe AS nvarchar (100)
DECLARE @fieldis AS nvarchar (100)
DECLARE @fieldwas AS nvarchar (100)
DECLARE @fieldwillbe AS nvarchar (100)
DECLARE @textis AS nvarchar (100)

SET @tblis  = '%%'--UPDATE AS NEEDED HERE WITHIN THE ‘’
SET @tbltype  = '%%'--UPDATE AS NEEDED HERE WITHIN THE ‘’
SET @tblwas  = '%%'--UPDATE AS NEEDED HERE WITHIN THE ‘’
SET @tblwillbe  = '%%'--UPDATE AS NEEDED HERE WITHIN THE ‘’
SET @fieldis  = '%locationtypename%'--UPDATE AS NEEDED HERE WITHIN THE ‘’ ISO w createid OR dreatedate
SET @fieldwas  = '%%'--UPDATE AS NEEDED HERE WITHIN THE ‘’
SET @fieldwillbe  = '%%'--UPDATE AS NEEDED HERE WITHIN THE ‘’
SET @textis  = '%InternalContact%'--UPDATE AS NEEDED HERE WITHIN THE ‘’

SELECT *
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM INFORMATION_SCHEMA.COLUMNS AS isc
	JOIN INFORMATION_SCHEMA.TABLES AS ist ON ist.TABLE_NAME = isc.TABLE_NAME
WHERE isc.TABLE_NAME LIKE @tblis
	AND isc.COLUMN_NAME LIKE @fieldis
	AND ist.TABLE_TYPE LIKE @tbltype
	AND isc.TABLE_NAME IN (SELECT iscwas.TABLE_NAME
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM INFORMATION_SCHEMA.COLUMNS AS iscwas
WHERE iscwas.TABLE_NAME LIKE @tblwas
	AND iscwas.COLUMN_NAME LIKE @fieldwas)
	AND isc.TABLE_NAME IN (SELECT iscwillbe.TABLE_NAME
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM INFORMATION_SCHEMA.COLUMNS AS iscwillbe
WHERE iscwillbe.TABLE_NAME LIKE @tblwillbe
	AND iscwillbe.COLUMN_NAME LIKE @fieldwillbe)
ORDER BY isc.TABLE_NAME,isc.COLUMN_NAME

		SELECT EmailAddress,* 
		SELECT DISTINCT TableName
		FROM evips_chgcv.dbo.vwInternalContacts 
		WHERE ISNULL(EmailAddress,'') != ''
			-- AND UPPER(LTRIM(RTRIM(ISNULL(innet.LocationTypeName,'')))) LIKE  '%CRED%CONTACT%'

		SELECT DISTINCT ic.EmailAddress,ic.ParentRecID,ic.ContactName,ic.ContactTitle,ic.Notes,pl.LocationTypeName,pl.LocationID,pl.PracticeID,pl.AddressID,pl.LocationName,pl.PracticeCode,pl.PracticeNationalProviderID,pl.TaxIDNumber,pl.NationalProviderID,pl.PracticeName,pl.PracticeLegalName,pl.LegalName -- ic.*,pl.* 
		FROM evips_chgcv.dbo.vwPracticeLocations AS pl
			JOIN evips_chgcv.dbo.vwInternalContacts AS ic ON pl.LocationID = ic.ParentRecID
		-- WHERE PracticeID IN ('4107300')
		WHERE ISNULL(ic.EmailAddress,'') != ''
			-- AND ParentRecID IN ('4107302','4107301','4107303','4107305','5178615')
			AND UPPER(LTRIM(RTRIM(ISNULL(pl.LocationTypeName,'')))) LIKE  '%CRED%CONTACT%'

		SELECT EmailAddress,* 
		FROM evips_chgcv.dbo.vwInternalContacts 
		WHERE ISNULL(ic.EmailAddress,'') != ''
			AND ParentRecID IN ('4107302','4107301','4107303','4107305','5178615')







From: Monserrat Partida <mpartida@chgsd.com> 
Sent: Friday, April 1, 2022 4:25 PM
To: Sandra Coleman <scolem@chgsd.com>; Johanna Duran <jduran@chgsd.com>
Subject: RE: Q2 DBA & Emails report

Nope. You got it Boss. 

From: Sandra Coleman <scolem@chgsd.com> 
Sent: Friday, April 1, 2022 4:22 PM
To: Monserrat Partida <mpartida@chgsd.com>; Johanna Duran <jduran@chgsd.com>
Subject: FW: Q2 DBA & Emails report

I need to send something to Walter with details of each area.  Review below to see if I missed anything.

Remove means remove the Cred Contact’s email for:

		1)	Remove groups with 50+ practitioners
		2)	Remove FEID with multiple DBA names
		3)	Remove 

				a.	Pharmacies
				b.	VSP
				c.	PTPN

Monse did I forget anything? 

From: Sandra Coleman 
Sent: Friday, April 1, 2022 4:13 PM
To: Monserrat Partida <mpartida@chgsd.com>; Johanna Duran <jduran@chgsd.com>; Chelsey Mones <cmones@iha.org>
Subject: RE: Q2 DBA & Emails report

Hi Chelsey,  You cannot send the attestation emails to the “Email Is” emails.  This is the site location email, not the Cred Contact email.  These emails are often different.  Please send the Q2 attestation email dates and delay the 1st email by 2 weeks.  We were unaware that this data had to go thru the Sanator file.  No one communicated this to us.  It is unfair to ask our Informatics team to turn this around in one week.  We also have to test the data.  We are also doing a conversion on 4/14-15/22.  We could have the file ready by 4/22/22.  If we can finish the file before 4/14/22, we will send it to you.  Also, what is the new field name that you want for attestation email addresses.  As mentioned, the “Email Is” is the site location email, not who should go to the website to attest.

Thanks!

Sandra Coleman, MBA, Credentialing Manager
Community Health Group
2420 Fenton Street, Ste 100, Chula Vista, Ca 91914
Phone:  619-498-6438
Fax:  619-382-1211
scolem@chgsd.com 

From: Monserrat Partida <mpartida@chgsd.com> 
Sent: Friday, April 1, 2022 1:44 PM
To: Sandra Coleman <scolem@chgsd.com>; Johanna Duran <jduran@chgsd.com>
Subject: FW: Q2 DBA & Emails report

Hi,  Symphony will not be able to use the Q2 report unless we use the Sanator file.  She mention below that the file must have the changes by Friday the 8th. I know you will be out on PTO and I don’t believe Walter will be able to update the Sanator file with the updates. Thanks,

From: Chelsey Capalad <ccapalad@iha.org> 
Sent: Wednesday, March 30, 2022 2:17 PM
To: Monserrat Partida <mpartida@chgsd.com>
Subject: RE: Q2 DBA & Emails report

Hi Monse, I apologize I spoke too soon. The Gaine team provided clarification for me in that they do not process a supplemental contact file. What is being utilized is the “Email Is” Column from your Provider file, which is directly incorporated into your weekly data files to Symphony. Please ensure all contact info is updated within your Provider file, preferably by this Friday’s file, but at the latest next Friday, 4/8. 

Please let me know if you have questions. 
Thank you, 

Chelsey Capalad
Senior Client Success Manager 
510.506.5307
 
Integrated Healthcare Association
180 Grand Ave, Ste 1365
Oakland, CA 94612

www.iha.org

From: Chelsey Capalad 
Sent: Wednesday, March 30, 2022 1:20 PM
To: Monserrat Partida <mpartida@chgsd.com>
Subject: RE: Q2 DBA & Emails report

Please proceed with dropping your file to the SFTP ASAP and advise when complete. 

Thank you! 

Chelsey Capalad
Senior Client Success Manager 
510.506.5307
 
Integrated Healthcare Association
180 Grand Ave, Ste 1365
Oakland, CA 94612

www.iha.org
 

From: Monserrat Partida <mpartida@chgsd.com> 
Sent: Wednesday, March 30, 2022 9:33 AM
To: Chelsey Capalad <ccapalad@iha.org>
Subject: RE: Q2 DBA & Emails report

Good morning Chelsey!
My apologies for my late response. It will be a supplemental file.
 
Thanks!
 
From: Chelsey Capalad <ccapalad@iha.org> 
Sent: Wednesday, March 23, 2022 3:17 PM
To: Monserrat Partida <mpartida@chgsd.com>
Subject: RE: Q2 DBA & Emails report
 
Hi Monse! 
 
Just to clarify – this file you’re referencing below is part of your regular files that you send to Symphony weekly or is it a supplemental file? 
 
Chelsey Capalad
Senior Client Success Manager 
510.506.5307
 
Integrated Healthcare Association
180 Grand Ave, Ste 1365
Oakland, CA 94612
 
www.iha.org
 
 
From: Monserrat Partida <mpartida@chgsd.com> 
Sent: Wednesday, March 23, 2022 3:12 PM
To: Chelsey Capalad <ccapalad@iha.org>
Subject: Q2 DBA & Emails report
 
Hello Chelsey,
 
Can you please let me know when I can send over the file with the DBAs and emails of the groups that we would like for Availity to reach out to for Q2. 
 
Thank you! 
 
Monserrat Partida 
Provider Data Analyst

Community Health Group
2420 Fenton St
Chula Vista, CA 91914


mpartida@chgsd.com 


The Community is What Counts

This e-mail communication that you have received may contain Protected Health Information (PHI) as defined by The Health Insurance Portability and Accountability Act of 1996 (HIPAA). Federal law mandates that you not use or disclose the information contained herein in any way that will compromise the privacy, security or confidentiality of the individual to whom the information pertains. If this e-mail communication has been misdirected to you, please notify the sender of this e-mail immediately, delete the e-mail and destroy any copies of the e-mail.
 
Disclaimer
The information contained in this communication from the sender is confidential. It is intended solely for use by the recipient and others authorized to receive it. If you are not the recipient, you are hereby notified that any disclosure, copying, distribution or taking action in relation of the contents of this information is strictly prohibited and may be unlawful.

This email has been scanned for viruses and malware, and may have been automatically archived by Mimecast Ltd, an innovator in Software as a Service (SaaS) for business. Providing a safer and more useful place for your human generated data. Specializing in; Security, archiving and compliance. To find out more Click Here.

Disclaimer
The information contained in this communication from the sender is confidential. It is intended solely for use by the recipient and others authorized to receive it. If you are not the recipient, you are hereby notified that any disclosure, copying, distribution or taking action in relation of the contents of this information is strictly prohibited and may be unlawful.

This email has been scanned for viruses and malware, and may have been automatically archived by Mimecast Ltd, an innovator in Software as a Service (SaaS) for business. Providing a safer and more useful place for your human generated data. Specializing in; Security, archiving and compliance. To find out more Click Here.







JAH 'CCS PANELED SITE'
x CHARINDEX() FIND() SEARCH() 'SUBJECT:CCS FROM:WALTER'
	Line 1510: ,CAST('NO' AS varchar(3)) AS [CCSPaneledProvider] -- RFP TEAM REQUESTED ADD ON AS OF 20220121 PER DISCUSSION ;WITH() YOUNG LADY FRANCISCA, MS MONSE Y SIR RAUL
	Line 1642: SET [CCSPaneledProvider] = CAST('YES' AS varchar(3))
	Line 2142: ,CAST('NO' AS varchar(3)) AS [CCSPaneledProvider] -- RFP TEAM REQUESTED ADD ON AS OF 20220121 PER DISCUSSION ;WITH() YOUNG LADY FRANCISCA, MS MONSE Y SIR RAUL
	Line 2264: SET [CCSPaneledProvider] = CAST('YES' AS varchar(3))

	Line 4778: ,[CCSPaneledProvider] -- ADD TO THE SIX (6) PROVIDER PROVDIR_... [TABLE(S)]
	Line 5188: ,[CCSPaneledProvider] -- ADD TO THE SIX (6) PROVIDER PROVDIR_... [TABLE(S)]
	Line 5603: ,[CCSPaneledProvider] -- ADD TO THE SIX (6) PROVIDER PROVDIR_... [TABLE(S)]
	Line 6019: ,[CCSPaneledProvider] -- ADD TO THE SIX (6) PROVIDER PROVDIR_... [TABLE(S)]
	Line 6438: ,[CCSPaneledProvider] -- ADD TO THE SIX (6) PROVIDER PROVDIR_... [TABLE(S)]
	Line 6854: ,[CCSPaneledProvider] -- ADD TO THE SIX (6) PROVIDER PROVDIR_... [TABLE(S)]

SELECT '[CCSPaneledProvider] field Added' AS [MESSAGE(S)],[CCSPaneledProvider],* FROM INFORMATICS.dbo.PROVDIR_PCP
SELECT '[CCSPaneledProvider] field Added' AS [MESSAGE(S)],[CCSPaneledProvider],* FROM INFORMATICS.dbo.PROVDIR_SPE
SELECT '[CCSPaneledProvider] field Added' AS [MESSAGE(S)],[CCSPaneledProvider],* FROM INFORMATICS.dbo.PROVDIR_MH
SELECT '[CCSPaneledProvider] field Added' AS [MESSAGE(S)],[CCSPaneledProvider],* FROM INFORMATICS.dbo.PROVDIR_AHP
SELECT '[CCSPaneledProvider] field Added' AS [MESSAGE(S)],[CCSPaneledProvider],* FROM INFORMATICS.dbo.PROVDIR_VSP
SELECT '[CCSPaneledProvider] field Added' AS [MESSAGE(S)],[CCSPaneledProvider],* FROM INFORMATICS.dbo.PROVDIR_NPMP

SELECT '[CCSPaneledProvider] field Added' AS [MESSAGE(S)],[CCSPaneledProvider],* FROM INFORMATICS.dbo.PROVDIR_HOS
SELECT '[CCSPaneledProvider] field Added' AS [MESSAGE(S)],[CCSPaneledProvider],* FROM INFORMATICS.dbo.PROVDIR_HOSGENERALACUTE
SELECT '[CCSPaneledProvider] field Added' AS [MESSAGE(S)],[CCSPaneledProvider],* FROM INFORMATICS.dbo.PROVDIR_HOSLTACH
SELECT '[CCSPaneledProvider] field Added' AS [MESSAGE(S)],[CCSPaneledProvider],* FROM INFORMATICS.dbo.PROVDIR_HOSMH
SELECT '[CCSPaneledProvider] field Added' AS [MESSAGE(S)],[CCSPaneledProvider],* FROM INFORMATICS.dbo.PROVDIR_SNF
SELECT '[CCSPaneledProvider] field Added' AS [MESSAGE(S)],[CCSPaneledProvider],* FROM INFORMATICS.dbo.PROVDIR_IPREHAB
SELECT '[CCSPaneledProvider] field Added' AS [MESSAGE(S)],[CCSPaneledProvider],* FROM INFORMATICS.dbo.PROVDIR_RCF
SELECT '[CCSPaneledProvider] field Added' AS [MESSAGE(S)],[CCSPaneledProvider],* FROM INFORMATICS.dbo.PROVDIR_HOSPICE
SELECT '[CCSPaneledProvider] field Added' AS [MESSAGE(S)],[CCSPaneledProvider],* FROM INFORMATICS.dbo.PROVDIR_CBAS
SELECT '[CCSPaneledProvider] field Added' AS [MESSAGE(S)],[CCSPaneledProvider],* FROM INFORMATICS.dbo.PROVDIR_BRC
SELECT '[CCSPaneledProvider] field Added' AS [MESSAGE(S)],[CCSPaneledProvider],* FROM INFORMATICS.dbo.PROVDIR_HDM
SELECT '[CCSPaneledProvider] field Added' AS [MESSAGE(S)],[CCSPaneledProvider],* FROM INFORMATICS.dbo.PROVDIR_HHC
SELECT '[CCSPaneledProvider] field Added' AS [MESSAGE(S)],[CCSPaneledProvider],* FROM INFORMATICS.dbo.PROVDIR_IHSS
SELECT '[CCSPaneledProvider] field Added' AS [MESSAGE(S)],[CCSPaneledProvider],* FROM INFORMATICS.dbo.PROVDIR_ASC
SELECT '[CCSPaneledProvider] field Added' AS [MESSAGE(S)],[CCSPaneledProvider],* FROM INFORMATICS.dbo.PROVDIR_DXC
SELECT '[CCSPaneledProvider] field Added' AS [MESSAGE(S)],[CCSPaneledProvider],* FROM INFORMATICS.dbo.PROVDIR_LAB
SELECT '[CCSPaneledProvider] field Added' AS [MESSAGE(S)],[CCSPaneledProvider],* FROM INFORMATICS.dbo.PROVDIR_DLC
SELECT '[CCSPaneledProvider] field Added' AS [MESSAGE(S)],[CCSPaneledProvider],* FROM INFORMATICS.dbo.PROVDIR_URC
SELECT '[CCSPaneledProvider] field Added' AS [MESSAGE(S)],[CCSPaneledProvider],* FROM INFORMATICS.dbo.PROVDIR_MIN
SELECT '[CCSPaneledProvider] field Added' AS [MESSAGE(S)],[CCSPaneledProvider],* FROM INFORMATICS.dbo.PROVDIR_PPH
SELECT '[CCSPaneledProvider] field Added' AS [MESSAGE(S)],[CCSPaneledProvider],* FROM INFORMATICS.dbo.PROVDIR_CLINIC
SELECT '[CCSPaneledProvider] field Added' AS [MESSAGE(S)],[CCSPaneledProvider],* FROM INFORMATICS.dbo.PROVDIR_PHARM
SELECT '[CCSPaneledProvider] field Added' AS [MESSAGE(S)],[CCSPaneledProvider],* FROM INFORMATICS.dbo.PROVDIR_PHARM_RCP
SELECT '[CCSPaneledProvider] field Added' AS [MESSAGE(S)],[CCSPaneledProvider],* FROM INFORMATICS.dbo.PROVDIR_PHARM_MO
SELECT '[CCSPaneledProvider] field Added' AS [MESSAGE(S)],[CCSPaneledProvider],* FROM INFORMATICS.dbo.PROVDIR_PHARM_HI
SELECT '[CCSPaneledProvider] field Added' AS [MESSAGE(S)],[CCSPaneledProvider],* FROM INFORMATICS.dbo.PROVDIR_PHARM_LTC
SELECT '[CCSPaneledProvider] field Added' AS [MESSAGE(S)],[CCSPaneledProvider],* FROM INFORMATICS.dbo.PROVDIR_PHARM_ITU	

SELECT DISTINCT '(CCS Paneled Provider) ' AS [CCS PANEL PROVIDER NOTE(s)],ccsd.NationalProviderID,ccsu.ProviderID,ccsd.PractitionerID,ccsu.DataSource,ccsu.Value,ccsu.tablename,ccsu.fieldname
-- SELECT ccsu.*,ccsd.* -- CHECK 1st
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM eVips_chgcv.dbo.vwUserFields AS ccsu
	JOIN eVips_chgcv.dbo.vwPractitionerDemographics AS ccsd on ccsu.ProviderID = ccsd.practitionerid
	-- JOIN eVips_chgcv.dbo.vwPractitionerDemographics AS ccsd on ccsu.ParentRecID = ccsd.practitionerid
WHERE ccsu.FieldName LIKE '%CCS%'
	AND ccsu.Value LIKE '%CCS%'
	AND ISNULL(ccsd.NationalProviderID,'') != ''
	-- AND ccsd.NationalProviderID IN ('1912218199','1760776728','1740485531','1275580037','1821387572','1649699968') -- ccsu.ProviderID IN ('4371852','4380505','4386131','4387896','4962677')

SELECT DISTINCT '(CCS Paneled Site) ' AS [CCS PANEL SITE NOTE(s)],ccspl.LocationName,ccspl.LegalName,ccspl.NationalProviderID,ccsu.ProviderID,ccspl.PracticeID,ccspl.LocationID,ccsu.DataSource,ccsu.Value,ccsu.tablename,ccsu.fieldname
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT TableName,LocationName,PracticeName,Value,PracticeLegalName,LegalName -- CHECK 1st
FROM eVips_chgcv.dbo.vwUserFields AS ccsu
	JOIN evips_chgcv.dbo.vwPracticeLocations AS ccspl on ccsu.ParentRecID = ccspl.LocationID
	-- JOIN evips_chgcv.dbo.vwPracticeLocations AS ccspl on ccsu.ProviderID = ccspl.LocationID
	-- JOIN evips_chgcv.dbo.vwPracticeLocations AS ccspl on ccsu.ProviderID = ccspl.PracticeID
WHERE ccspl.Archived IN ('N') --WITH eVIPS LOGICAL BINARY OPTION(s) IN USE •	Must not be archived 
	AND ccsu.FieldName LIKE '%CCS%'
	AND ccsu.Value LIKE '%CCS%'
	-- AND LegalName LIKE '%PALOM%'
	-- AND LineNumber1 LIKE '%555%PARK%'
	AND ISNULL(ccspl.NationalProviderID,'') != ''
	-- AND ccspl.NationalProviderID IN ('1801861190','1457321317') -- SAMPLE 'TRI CITY MED CTR''
ORDER BY ccspl.LocationName

SELECT * -- CHECK 1st
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM INFORMATICS.dbo.TimelyAccessFAC AS f
	JOIN 
	( -- INITIATE ...
	SELECT DISTINCT '(CCS Paneled Site) ' AS [CCS PANEL SITE NOTE(s)],ccspl.LocationName,ccspl.LegalName,ccspl.NationalProviderID,ccsu.ProviderID,ccspl.PracticeID,ccspl.LocationID,ccsu.DataSource,ccsu.Value,ccsu.tablename,ccsu.fieldname
	-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
	-- SELECT DISTINCT TableName,LocationName,PracticeName,Value,PracticeLegalName,LegalName -- CHECK 1st
	FROM eVips_chgcv.dbo.vwUserFields AS ccsu
		JOIN evips_chgcv.dbo.vwPracticeLocations AS ccspl on ccsu.ParentRecID = ccspl.LocationID
		-- JOIN evips_chgcv.dbo.vwPracticeLocations AS ccspl on ccsu.ProviderID = ccspl.LocationID
		-- JOIN evips_chgcv.dbo.vwPracticeLocations AS ccspl on ccsu.ProviderID = ccspl.PracticeID
	WHERE ccspl.Archived IN ('N') --WITH eVIPS LOGICAL BINARY OPTION(s) IN USE •	Must not be archived 
		AND ccsu.FieldName LIKE '%CCS%'
		AND ccsu.Value LIKE '%CCS%'
		-- AND LegalName LIKE '%PALOM%'
		-- AND LineNumber1 LIKE '%555%PARK%'
		AND ISNULL(ccspl.NationalProviderID,'') != ''
		-- AND ccspl.NationalProviderID IN ('1801861190','1457321317') -- SAMPLE 'TRI CITY MED CTR''
	-- ORDER BY ccspl.LocationName
		) -- CONCLUDE ...
		AS ccs ON f.NPIis = UPPER(LTRIM(RTRIM(ISNULL(ccs.NationalProviderID,''))))
			AND f.PracticeID = ccs.PracticeID
			AND f.LocationID = ccs.LocationID

--SELECT * FROM evips_chgcv.dbo.vwLocationServices WHERE PracticeID IN ('4126140') 
--SELECT * FROM evips_chgcv.dbo.vwUserDefinedFields WHERE FieldName LIKE '%CCS%'
SELECT * FROM evips_chgcv.dbo.PracticeLocations WHERE NationalProviderID IN ('1801861190')
SELECT DISTINCT TableName FROM evips_chgcv.[dbo].[vwUserFields] WHERE FieldName LIKE '%CCS%' AND Value LIKE '%CCS%'
SELECT * FROM evips_chgcv.[dbo].[vwUserFields] WHERE FieldName LIKE '%CCS%' AND Value LIKE '%CCS%' AND TableName IN ('PracticeLocations') -- UserFieldRecID IN ('1199129')

SELECT * -- CHECK 1st
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM INFORMATICS.dbo.TimelyAccessFAC AS f
WHERE NPIis IN ('1093091662')

SELECT * -- CHECK 1st
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM INFORMATICS.dbo.PROVDIR_AHP
WHERE NPIis IN ('1093091662')







-- ====================================================================
	-- CCS Paneled Sites INDICATOR UPDATE() -- 
-- ====================================================================
SELECT '"Paneled Providers" have been determined by the CCS ("California Childrens Services" ) program to meet the advanced education, training, and/or experience requirements for his/her provider type in order to render services to a CCS applicant or client. USE [PATH]: https://www.dhcs.ca.gov/services/ccs/Pages/CCSProviders.aspx' AS [NOTES]

UPDATE #INNETWORK_FAC
SET [CCSPaneledProvider] = CAST('YES' AS varchar(3))
-- SELECT [CCS PANEL] = ccs.[CCS PANEL PROVIDER NOTE(s)]+ISNULL([CULTURAL COMPETENCE],''),ccs.*,p.* -- CHECK 1st
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM #INNETWORK_FAC AS f
	JOIN 
	( -- INITIATE ...
	SELECT DISTINCT '(CCS Paneled Site) ' AS [CCS PANEL SITE NOTE(s)],ccspl.LocationName,ccspl.LegalName,ccspl.NationalProviderID,ccsu.ProviderID,ccspl.PracticeID,ccspl.LocationID,ccsu.DataSource,ccsu.Value,ccsu.tablename,ccsu.fieldname
	-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
	-- SELECT DISTINCT TableName,LocationName,PracticeName,Value,PracticeLegalName,LegalName -- CHECK 1st
	FROM eVips_chgcv.dbo.vwUserFields AS ccsu
		JOIN evips_chgcv.dbo.vwPracticeLocations AS ccspl on ccsu.ParentRecID = ccspl.LocationID
		-- JOIN evips_chgcv.dbo.vwPracticeLocations AS ccspl on ccsu.ProviderID = ccspl.LocationID
		-- JOIN evips_chgcv.dbo.vwPracticeLocations AS ccspl on ccsu.ProviderID = ccspl.PracticeID
	WHERE ccspl.Archived IN ('N') --WITH eVIPS LOGICAL BINARY OPTION(s) IN USE •	Must not be archived 
		AND ccsu.FieldName LIKE '%CCS%'
		AND ccsu.Value LIKE '%CCS%'
		-- AND LegalName LIKE '%PALOM%'
		-- AND LineNumber1 LIKE '%555%PARK%'
		AND ISNULL(ccspl.NationalProviderID,'') != ''
		-- AND ccspl.NationalProviderID IN ('1801861190','1457321317') -- SAMPLE 'TRI CITY MED CTR''
	-- ORDER BY ccspl.LocationName
		) -- CONCLUDE ...
		AS ccs ON f.NPIis = UPPER(LTRIM(RTRIM(ISNULL(ccs.NationalProviderID,''))))
			AND f.PracticeID = ccs.PracticeID
			AND f.LocationID = ccs.LocationID








-- ==================================================================
	-- BASELINE eVIPS FAC CHECK(s) --
-- ==================================================================
SELECT DISTINCT 'BASELINE eVIPS FAC CHECK(s)' AS [MESSAGE(S)],*
,vpl.LocationName,vlp.ProductName,UPPER(LTRIM(RTRIM(vlp.InDirectory))) AS [INDIRECTORY],UPPER(LTRIM(RTRIM(vp.Archived))) AS [vpARCHIVED],UPPER(LTRIM(RTRIM(vp.PracticeStatus))) AS [vpPRACTICESTATUS],UPPER(LTRIM(RTRIM(vp.ApplicationStatus))) AS [vpAPPLICATIONSTATUS],UPPER(LTRIM(RTRIM(vpl.Archived))) AS [vplARCHIVED],UPPER(LTRIM(RTRIM(vpl.LocationTypeName))) AS [vplLOCATIONTYPENAME],UPPER(LTRIM(RTRIM(vlp.LocationTypeName))) AS [vlpLOCATIONTYPENAME],UPPER(LTRIM(RTRIM(vlp.Archived))) AS [vlpARCHIVED],UPPER(LTRIM(RTRIM(vlp.StatusTypeName))) AS [vlpSTATUSTYPENAME],UPPER(LTRIM(RTRIM(vlp.ServiceTypeName))) AS [vlpSERVICETYPENAME],CAST(NULL AS nvarchar(5)) AS [providence],CAST(NULL AS nvarchar(100)) AS ID,UPPER(LTRIM(RTRIM(vp.PracticeTypeName))) AS [VP_plan_type],UPPER(LTRIM(RTRIM(vlp.PracticeTypeName))) AS [VLP_plan_type],UPPER(LTRIM(RTRIM(vlp.ProductTypeCode))) AS [VLP_Alt_plan_type],UPPER(LTRIM(RTRIM(vlp.ProductTypeName))) AS [VLP_full_plan_name],UPPER(LTRIM(RTRIM(vp.PracticeTypeName))) AS [plan_type],UPPER(LTRIM(RTRIM(vlp.ProductName))) AS [plan_name],vp.PracticeName,vpl.LocationName,vp.LegalName AS [VPLegalName],vpl.LegalName AS [VPLLegalName]
,UPPER(LTRIM(RTRIM(vpl.LocationName))) AS [HospitalName]
,UPPER(LTRIM(RTRIM(vpl.LocationName))) AS [FacilityName]
,UPPER(LTRIM(RTRIM(vpl.LocationName))) AS [Clinic Name]
,UPPER(LTRIM(RTRIM(vpl.LocationName))) AS [Pharmacy Name] -- We have most of the NPIs for the clinics.  They are located in the NPI field in the address master
,UPPER(LTRIM(RTRIM(vp.PracticeID))) AS [DBAPracticeID]
,UPPER(LTRIM(RTRIM(vp.PracticeName))) AS [DBA]
-- ,LTRIM(RTRIM(vpl.NationalProviderID)) AS NPIis
,LTRIM(RTRIM(vp.NationalProviderID)) AS altNPIis
,REPLACE(UPPER(LTRIM(RTRIM(vf.TaxIDNumber))),'-','') AS vfPROVTAXID
,CASE
WHEN vpl.NationalProviderID IS NULL
	AND UPPER(LTRIM(RTRIM(vf.FacilityStatus))) LIKE 'ACTIVE%'
	AND UPPER(LTRIM(RTRIM(vf.ApplicationStatus))) LIKE 'ACTIVE%'
THEN LTRIM(RTRIM(vf.NationalProviderID))
ELSE LTRIM(RTRIM(vpl.NationalProviderID)) 
END AS [NPIis]
,vpl.TwentyFourHourCoverage
,vpl.LineNumber1,vpl.LineNumber2,vpl.City
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT  vlp.Focus,vlsfocus.Code1,vlsfocus.Code2,vp.Archived,vp.PracticeStatus,vp.ApplicationStatus,vpl.Archived,vpl.LocationTypeName,vp.PracticeTypeName,* -- CHECK 1st
-- SELECT * FROM eVips_chgcv.dbo.vwPracticeLocations -- CHECK 1st
-- SELECT DISTINCT PracticeTypeName FROM eVips_chgcv.dbo.vwPracticeLocations -- CHECK 1st UPPER(LTRIM(RTRIM(vpl.PracticeTypeName))) AS [Type of Service]
-- SELECT * FROM eVips_chgcv.dbo.vwEntityAssignments WHERE UPPER(LTRIM(RTRIM(TableName))) LIKE '%Practice%' AND UPPER(LTRIM(RTRIM(EntityName))) LIKE '%MED%IMPA%' -- CHECK 1st
FROM eVips_chgcv.dbo.vwPractices AS vp
	JOIN eVips_chgcv.dbo.vwPracticeLocations AS vpl ON vp.PracticeID = vpl.PracticeID
		LEFT JOIN eVips_chgcv.dbo.vwFacilities AS vf ON vpl.LocationName = vf.FacilityName
			OR vp.PracticeName = vf.FacilityName
		LEFT JOIN ( -- INITIATE ...
		SELECT DISTINCT PracticeID,ClassOrCategory, ServiceTypeName,ServiceCategoryTypeName 
		FROM eVips_chgcv.dbo.vwLocationServices 
		WHERE ServiceTypeName 
		LIKE '%GROUP%SPEC%'
		) -- CONCLUDE ...
		AS vls ON vp.PracticeID = vls.PracticeID -- DEFINE FAC CHAPTER(s) 		
		LEFT JOIN ( -- INITIATE ...
		SELECT DISTINCT LocationID,PracticeID,ClassOrCategory, ServiceTypeName,ServiceCategoryTypeName,code1,code2 
		FROM eVips_chgcv.dbo.vwLocationServices 
		WHERE UPPER(LTRIM(RTRIM(ServiceTypeName))) LIKE '%PHARM%TYPE%' 
			AND ServiceCategoryTypeName IS NOT NULL 
			AND UPPER(LTRIM(RTRIM(ServiceCategoryTypeName))) != ''
			) -- CONCLUDE ...
			AS vlspharmtype ON vp.PracticeID = vlspharmtype.PracticeID --DEFINE PHARM TYPE(s)
				AND vpl.LocationID = vlspharmtype.LocationID -- per YOUNG LADY LAURA email ON 20171221 ... Products (CMC & MEDICAL)  are stored at Location Level. The code below is joining based only on Practice ID. This should be based on PracticeID + Location
		LEFT JOIN ( -- INITIATE ...
		SELECT DISTINCT LocationID,PracticeID,ClassOrCategory, ServiceTypeName,ServiceCategoryTypeName,code1,code2 
		FROM eVips_chgcv.dbo.vwLocationServices 
		WHERE UPPER(LTRIM(RTRIM(ServiceTypeName))) LIKE '%PHARM%SERV%' 
			AND ServiceCategoryTypeName IS NOT NULL 
			AND UPPER(LTRIM(RTRIM(ServiceCategoryTypeName))) != ''
			) -- CONCLUDE ...
			AS vlspharmservice ON vp.PracticeID = vlspharmservice.PracticeID --DEFINE PHARM TYPE(s)
				AND vpl.LocationID = vlspharmservice.LocationID -- per YOUNG LADY LAURA email ON 20171221 ... Products (CMC & MEDICAL)  are stored at Location Level. The code below is joining based only on Practice ID. This should be based on PracticeID + Location
		LEFT JOIN ( -- INITIATE ...
		SELECT DISTINCT PracticeID,Code1,Code2,ServiceTypeName,ServiceCategoryTypeName 
		FROM eVips_chgcv.dbo.vwLocationServices 
		WHERE ServiceTypeName LIKE '274%TYPE%SERV%'
		) -- CONCLUDE ...
		AS vlsfocus ON vp.PracticeID = vlsfocus.PracticeID --Alt EFFORT TO DEFINE FAC CHAPTER(s)
		LEFT JOIN ( -- INITIATE ...
		SELECT DISTINCT ProviderID,TableName,EntityCode,EntityName,EntityTypeCode,EntityTypeName 
		FROM eVips_chgcv.dbo.vwEntityAssignments 
		WHERE UPPER(LTRIM(RTRIM(ISNULL(TableName,'')))) LIKE '%PRACTI%'
		) -- CONCLUDE ...
		AS vea ON vp.PracticeID = vea.ProviderID
LEFT JOIN
		 ( -- INITIATE ...
		SELECT DISTINCT ljvlp.ProductTypeCode,ljvlp.ProductTypeName,ljvlp.PracticeTypeName,ljvlp.PracticeID,ljvlp.LocationID,ljvlp.Archived,ljvlp.StatusTypeName,vlpstype.indirectory,vlpstype.ServiceTypeCode,vlpstype.ServiceTypeName,ljvlp.productname,ljvlp.ProductPanelStatusTypeName,ljvlp.ProductPanelStatusTypeCode,ljvlp.ProviderNumber,ljvlp.Focus,ljvlp.ProductID,ljvlp.LocationTypeName 
		FROM eVips_chgcv.dbo.vwLocationProducts AS ljvlp 
			JOIN evips_chgcv.dbo.vwLocationProductServices AS vlpstype ON ljvlp.LocationProductRecID = vlpstype.LocationProductRecID 
		WHERE ISNULL(ljvlp.Archived,'') IN ('N','') 
			AND (ISNULL(ljvlp.StatusTypeName,'') IN ('ACTIVE','') 
				OR ljvlp.StatusTypeName LIKE '%PARTICIP%')
			AND ISNULL(vlpstype.Archived,'') IN ('N','') 
			) -- CONCLUDE ...
			AS vlp ON vpl.PracticeID = vlp.PracticeID --'YOUNG LADY LAURA GAH ID WHERE p.archived = 'N' AND s.ServiceTypeName = 'HOSPITAL' AND p.focus like '%GAH%'' ON 20171120 see ,UPPER(LTRIM(RTRIM(vlp.ServiceTypeName))) AS [vlpSERVICETYPENAME]
				AND vpl.LocationID = vlp.LocationID -- per YOUNG LADY LAURA email ON 20171221 ... Products (CMC & MEDICAL)  are stored at Location Level. The code below is joining based only on Practice ID. This should be based on PracticeID + Location
		LEFT JOIN ( -- INITIATE ...
		SELECT DISTINCT LocationID,PracticeID,AccreditationTypeCode,AccreditationTypeName,Notes 
		FROM eVips_chgcv.dbo.vwLocationAccreditations AS vla 
		WHERE ISNULL(vla.Archived,'') IN ('N','') 
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
		LEFT JOIN ( -- INITIATE ...
		SELECT DISTINCT zipcode,city,county,RegionTypeName 
		FROM eVips_chgcv.dbo.vwzipcodes 
		WHERE UPPER(LTRIM(RTRIM(ISNULL(county,'')))) LIKE '%SAN%DIEGO%'
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
		LEFT JOIN ( -- INITIATE ...
		SELECT DISTINCT r.FieldName,r.DisplayName,s.specialtycode,s.specialtyName AS [eVIPS_Specialty],r.Value AS [TIMELYACCESS_Profile] 
		FROM evips_chgcv.dbo.vwReferenceUserFields AS r 
			LEFT JOIN evips_chgcv.dbo.vwSpecialties AS s ON r.ParentRecID  = s.specialtyid
		WHERE r.tablename = 'Specialties' 
			AND r.fieldName = 'Specialty Grouping - Timely Access'
			) -- CONCLUDE ... 
		AS profile ON UPPER(LTRIM(RTRIM(ISNULL(vlsfocus.Code1,'')))) = UPPER(LTRIM(RTRIM(ISNULL(profile.specialtycode,''))))

--WHERE vp.Archived IN ('N') --WITH eVIPS LOGICAL BINARY OPTION(s) IN USE •	Must not be archived 
--	AND ISNULL(vp.PracticeStatus,'') IN ('ACTIVE','CONTRACTED','NA','') --•	Contract Status must be Active
--	AND vpl.Archived IN ('N') --WITH eVIPS LOGICAL BINARY OPTION(s) IN USE •	Must not be archived

--AND CASE
--WHEN vpl.NationalProviderID IS NULL
--	AND UPPER(LTRIM(RTRIM(vf.FacilityStatus))) LIKE 'ACTIVE%'
--	AND UPPER(LTRIM(RTRIM(vf.ApplicationStatus))) LIKE 'ACTIVE%'
--THEN LTRIM(RTRIM(vf.NationalProviderID))
--ELSE LTRIM(RTRIM(vpl.NationalProviderID)) 
--END IN ('1801861190') -- AS [NPIis]

WHERE  PracticeLegalName LIKE '%PALOMAR%'

-- WHERE  LineNumber1 LIKE '%555%PARK%'







JAH 'RFP' ON 20210121"Paneled Providers" have been determined by the CCS ('California Childrens Services') program to meet the advanced education, training, and/or experience requirements for his/her provider type in order to render services to a CCS applicant or client.
		USE [PATH]: https://www.dhcs.ca.gov/services/ccs/Pages/CCSProviders.aspx

,CAST('NO' AS varchar(3)) AS [CCSPaneledProvider] -- RFP TEAM REQUESTED ADD ON AS OF 20220121 PER DISCUSSION ;WITH() YOUNG LADY FRANCISCA, MS MONSE Y SIR RAUL
INTO #INNETWORK_PROV

-- ====================================================================
	-- CCS Paneled Providers INDICATOR UPDATE() -- 
-- ====================================================================
SELECT '"Paneled Providers" have been determined by the CCS ("California Childrens Services" ) program to meet the advanced education, training, and/or experience requirements for his/her provider type in order to render services to a CCS applicant or client. USE [PATH]: https://www.dhcs.ca.gov/services/ccs/Pages/CCSProviders.aspx' AS [NOTES]

UPDATE #INNETWORK_PROV
SET [CCSPaneledProvider] = CAST('YES' AS varchar(3))
-- SELECT [CCS PANEL] = ccs.[CCS PANEL PROVIDER NOTE(s)]+ISNULL([CULTURAL COMPETENCE],''),ccs.*,p.* -- CHECK 1st
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM #INNETWORK_PROV AS p
	JOIN 
	( -- INITIATE ...
	SELECT DISTINCT '(CCS Paneled Provider) ' AS [CCS PANEL PROVIDER NOTE(s)],ccsd.NationalProviderID,ccsu.ProviderID,ccsd.PractitionerID,ccsu.DataSource,ccsu.Value,ccsu.tablename,ccsu.fieldname
	-- SELECT ccsd.*,ccsu.* -- CHECK 1st
	-- SELECT DISTINCT ' ' AS 'CHECK 1st'
	FROM eVips_chgcv.dbo.vwUserFields AS ccsu
		JOIN eVips_chgcv.dbo.vwPractitionerDemographics AS ccsd on ccsu.ProviderID = ccsd.practitionerid
	WHERE ccsu.FieldName LIKE '%CCS%'
		AND ccsu.Value LIKE '%CCS%'
		-- AND ccsd.NationalProviderID IN ('1912218199','1760776728','1740485531','1275580037','1821387572','1649699968') -- ccsu.ProviderID IN ('4371852','4380505','4386131','4387896','4962677')
		) -- CONCLUDE ...
		AS ccs ON p.NPIis = UPPER(LTRIM(RTRIM(ISNULL(ccs.NationalProviderID,''))))

,[CCSPaneledProvider] -- ADD TO THE SIX (6) PROVIDER PROVDIR_... [TABLE(S)]
INTO INFORMATICS.dbo.PROVDIR_PCP

,[CCSPaneledProvider] -- ADD TO THE SIX (6) PROVIDER PROVDIR_... [TABLE(S)]
INTO INFORMATICS.dbo.PROVDIR_SPE

,[CCSPaneledProvider] -- ADD TO THE SIX (6) PROVIDER PROVDIR_... [TABLE(S)]
INTO INFORMATICS.dbo.PROVDIR_MH

,[CCSPaneledProvider] -- ADD TO THE SIX (6) PROVIDER PROVDIR_... [TABLE(S)]
INTO INFORMATICS.dbo.PROVDIR_AHP

,[CCSPaneledProvider] -- ADD TO THE SIX (6) PROVIDER PROVDIR_... [TABLE(S)]
 INTO INFORMATICS.dbo.PROVDIR_VSP

,[CCSPaneledProvider] -- ADD TO THE SIX (6) PROVIDER PROVDIR_... [TABLE(S)]
INTO INFORMATICS.dbo.PROVDIR_NPMP







ALTER TABLE INFORMATICS.dbo.PROVDIR_PCP
ADD -- INITIATE ... ADD OF COLUMN(s)
[CCSPaneledProvider] varchar(3) -- DFLT VAL() IS NULL

ALTER TABLE INFORMATICS.dbo.PROVDIR_SPE
ADD -- INITIATE ... ADD OF COLUMN(s)
[CCSPaneledProvider] varchar(3) -- DFLT VAL() IS NULL

ALTER TABLE INFORMATICS.dbo.PROVDIR_MH
ADD -- INITIATE ... ADD OF COLUMN(s)
[CCSPaneledProvider] varchar(3) -- DFLT VAL() IS NULL

ALTER TABLE INFORMATICS.dbo.PROVDIR_AHP
ADD -- INITIATE ... ADD OF COLUMN(s)
[CCSPaneledProvider] varchar(3) -- DFLT VAL() IS NULL

ALTER TABLE INFORMATICS.dbo.PROVDIR_VSP
ADD -- INITIATE ... ADD OF COLUMN(s)
[CCSPaneledProvider] varchar(3) -- DFLT VAL() IS NULL

ALTER TABLE INFORMATICS.dbo.PROVDIR_NPMP
ADD -- INITIATE ... ADD OF COLUMN(s)
[CCSPaneledProvider] varchar(3) -- DFLT VAL() IS NULL

ALTER TABLE INFORMATICS.dbo.PROVDIR_ECMCSP
ADD -- INITIATE ... ADD OF COLUMN(s)
[CCSPaneledProvider] varchar(3) -- DFLT VAL() IS NULL

ALTER TABLE INFORMATICS.dbo.SANATOR_PROVDIR_PCP
ADD -- INITIATE ... ADD OF COLUMN(s)
[CCSPaneledProvider] varchar(3) -- DFLT VAL() IS NULL

ALTER TABLE INFORMATICS.dbo.SANATOR_PROVDIR_SPE
ADD -- INITIATE ... ADD OF COLUMN(s)
[CCSPaneledProvider] varchar(3) -- DFLT VAL() IS NULL

ALTER TABLE INFORMATICS.dbo.SANATOR_PROVDIR_MH
ADD -- INITIATE ... ADD OF COLUMN(s)
[CCSPaneledProvider] varchar(3) -- DFLT VAL() IS NULL

ALTER TABLE INFORMATICS.dbo.SANATOR_PROVDIR_AHP
ADD -- INITIATE ... ADD OF COLUMN(s)
[CCSPaneledProvider] varchar(3) -- DFLT VAL() IS NULL

ALTER TABLE INFORMATICS.dbo.SANATOR_PROVDIR_VSP
ADD -- INITIATE ... ADD OF COLUMN(s)
[CCSPaneledProvider] varchar(3) -- DFLT VAL() IS NULL

ALTER TABLE INFORMATICS.dbo.SANATOR_PROVDIR_NPMP
ADD -- INITIATE ... ADD OF COLUMN(s)
[CCSPaneledProvider] varchar(3) -- DFLT VAL() IS NULL









SELECT DISTINCT [CCSPaneledProvider]
FROM 
( -- INITIATE ...
SELECT LastName,NPIis,[SPEC],[Specialty],[INDEXNM],[Clinic Name],[ASSOCIATION GROUP],[DBA],FAXnumber,[CCSPaneledProvider]
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM INFORMATICS.dbo.PROVDIR_PCP --PROV(s)
UNION --VERTICAL() w UNION()  - ROW(s) --STACK DISTINCT
SELECT LastName,NPIis,[SPEC],[Specialty],[INDEXNM],[Clinic Name],[ASSOCIATION GROUP],[DBA],FAXnumber,[CCSPaneledProvider]
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM INFORMATICS.dbo.PROVDIR_NPMP --PROV(s)
UNION --VERTICAL() w UNION()  - ROW(s) --STACK DISTINCT
SELECT LastName,NPIis,[SPEC],[Specialty],[INDEXNM],[Clinic Name],[ASSOCIATION GROUP],[DBA],FAXnumber,[CCSPaneledProvider]
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM INFORMATICS.dbo.PROVDIR_SPE --PROV(s)
UNION --VERTICAL() w UNION()  - ROW(s) --STACK DISTINCT
SELECT LastName,NPIis,[SPEC],[Specialty],[INDEXNM],[Clinic Name],[ASSOCIATION GROUP],[DBA],FAXnumber,[CCSPaneledProvider]
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM INFORMATICS.dbo.PROVDIR_MH --PROV(s)
UNION --VERTICAL() w UNION()  - ROW(s) --STACK DISTINCT
SELECT LastName,NPIis,[SPEC],[Specialty],[INDEXNM],[Clinic Name],[ASSOCIATION GROUP],[DBA],FAXnumber,[CCSPaneledProvider]
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM INFORMATICS.dbo.PROVDIR_AHP --PROV(s)
UNION --VERTICAL() w UNION()  - ROW(s) --STACK DISTINCT
SELECT LastName,NPIis,[SPEC],[Specialty],[INDEXNM],[Clinic Name],[ASSOCIATION GROUP],[DBA],FAXnumber,[CCSPaneledProvider]
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM INFORMATICS.dbo.PROVDIR_VSP --PROV(s)
) -- CONCLUDE ...
AS alias







JAH 'ADD ECM AND ILOS CHAPTRER(S)'
x CHARINDEX() FIND() SEARCH() 'INTO ...','ECM ILOS (NOW CS)' - "Enhanced Care Management" and In Lieu of Services - DHCShttps://www.dhcs.ca.gov › enhancedcaremanagementan... "Enhanced Care Management" (ECM) and "Community Supports", or "In Lieu of Services" (ILOS), are foundational components of CalAIM. ECM will be a whole-person, ... Missing: (NOW| Must include: (NOW ... - USE '[PROVDIR_HHC]' AS THE TEMPLATE
		USE https://www.google.com/search?q=ECM+ILOS+%28NOW+CS
		USE https://www.dhcs.ca.gov/enhancedcaremanagementandinlieuofservices

		see 'ECMCSPs_eVIPS_PROVDIR_STEP_...sql'
		
		/* SELECT * FROM INFORMATICS.dbo.PROVDIR_ECM -- LIKE '%PROVDIR_HHC%'
		SELECT * FROM INFORMATICS.dbo.PROVDIR_COMMUNITYSUPPORTS -- LIKE '%PROVDIR_HHC%' */

x STEP01 UPDATE SQL SCRIPT
x STEP02 UPDATE MS ACCESS db
x STEP03 UPDATE DirectoryExpert

-- ==================================================================
	-- BASELINE eVIPS FAC CHECK(s) --
-- ==================================================================
SELECT DISTINCT 'BASELINE eVIPS FAC CHECK(s)' AS [NOTE(S)],vpl.LocationName,vlp.ProductName,UPPER(LTRIM(RTRIM(vlp.InDirectory))) AS [INDIRECTORY],UPPER(LTRIM(RTRIM(vp.Archived))) AS [vpARCHIVED],UPPER(LTRIM(RTRIM(vp.PracticeStatus))) AS [vpPRACTICESTATUS],UPPER(LTRIM(RTRIM(vp.ApplicationStatus))) AS [vpAPPLICATIONSTATUS],UPPER(LTRIM(RTRIM(vpl.Archived))) AS [vplARCHIVED],UPPER(LTRIM(RTRIM(vpl.LocationTypeName))) AS [vplLOCATIONTYPENAME],UPPER(LTRIM(RTRIM(vlp.LocationTypeName))) AS [vlpLOCATIONTYPENAME],UPPER(LTRIM(RTRIM(vlp.Archived))) AS [vlpARCHIVED],UPPER(LTRIM(RTRIM(vlp.StatusTypeName))) AS [vlpSTATUSTYPENAME],UPPER(LTRIM(RTRIM(vlp.ServiceTypeName))) AS [vlpSERVICETYPENAME],CAST(NULL AS nvarchar(5)) AS [providence],CAST(NULL AS nvarchar(100)) AS ID,UPPER(LTRIM(RTRIM(vp.PracticeTypeName))) AS [VP_plan_type],UPPER(LTRIM(RTRIM(vlp.PracticeTypeName))) AS [VLP_plan_type],UPPER(LTRIM(RTRIM(vlp.ProductTypeCode))) AS [VLP_Alt_plan_type],UPPER(LTRIM(RTRIM(vlp.ProductTypeName))) AS [VLP_full_plan_name],UPPER(LTRIM(RTRIM(vp.PracticeTypeName))) AS [plan_type],UPPER(LTRIM(RTRIM(vlp.ProductName))) AS [plan_name],vp.PracticeName,vpl.LocationName,vp.LegalName AS [VPLegalName],vpl.LegalName AS [VPLLegalName]
,UPPER(LTRIM(RTRIM(vpl.LocationName))) AS [HospitalName]
,UPPER(LTRIM(RTRIM(vpl.LocationName))) AS [FacilityName]
,UPPER(LTRIM(RTRIM(vpl.LocationName))) AS [Clinic Name]
,UPPER(LTRIM(RTRIM(vpl.LocationName))) AS [Pharmacy Name] -- We have most of the NPIs for the clinics.  They are located in the NPI field in the address master
,UPPER(LTRIM(RTRIM(vp.PracticeID))) AS [DBAPracticeID]
,UPPER(LTRIM(RTRIM(vp.PracticeName))) AS [DBA]
-- ,LTRIM(RTRIM(vpl.NationalProviderID)) AS NPIis
,LTRIM(RTRIM(vp.NationalProviderID)) AS altNPIis
,REPLACE(UPPER(LTRIM(RTRIM(vf.TaxIDNumber))),'-','') AS vfPROVTAXID
,CASE
WHEN vpl.NationalProviderID IS NULL
	AND UPPER(LTRIM(RTRIM(vf.FacilityStatus))) LIKE 'ACTIVE%'
	AND UPPER(LTRIM(RTRIM(vf.ApplicationStatus))) LIKE 'ACTIVE%'
THEN LTRIM(RTRIM(vf.NationalProviderID))
ELSE LTRIM(RTRIM(vpl.NationalProviderID)) 
END AS [NPIis]
,vpl.TwentyFourHourCoverage
,vpl.LineNumber1,vpl.LineNumber2,vpl.City
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT  vlp.Focus,vlsfocus.Code1,vlsfocus.Code2,vp.Archived,vp.PracticeStatus,vp.ApplicationStatus,vpl.Archived,vpl.LocationTypeName,vp.PracticeTypeName,* -- CHECK 1st
-- SELECT * FROM eVips_chgcv.dbo.vwPracticeLocations -- CHECK 1st
-- SELECT DISTINCT PracticeTypeName FROM eVips_chgcv.dbo.vwPracticeLocations -- CHECK 1st UPPER(LTRIM(RTRIM(vpl.PracticeTypeName))) AS [Type of Service]
-- SELECT * FROM eVips_chgcv.dbo.vwEntityAssignments WHERE UPPER(LTRIM(RTRIM(TableName))) LIKE '%Practice%' AND UPPER(LTRIM(RTRIM(EntityName))) LIKE '%MED%IMPA%' -- CHECK 1st
FROM eVips_chgcv.dbo.vwPractices AS vp
	JOIN eVips_chgcv.dbo.vwPracticeLocations AS vpl ON vp.PracticeID = vpl.PracticeID
		LEFT JOIN eVips_chgcv.dbo.vwFacilities AS vf ON vpl.LocationName = vf.FacilityName
			OR vp.PracticeName = vf.FacilityName
		LEFT JOIN ( -- INITIATE ...
		SELECT DISTINCT PracticeID,ClassOrCategory, ServiceTypeName,ServiceCategoryTypeName 
		FROM eVips_chgcv.dbo.vwLocationServices 
		WHERE ServiceTypeName 
		LIKE '%GROUP%SPEC%'
		) -- CONCLUDE ...
		AS vls ON vp.PracticeID = vls.PracticeID -- DEFINE FAC CHAPTER(s) 		
		LEFT JOIN ( -- INITIATE ...
		SELECT DISTINCT LocationID,PracticeID,ClassOrCategory, ServiceTypeName,ServiceCategoryTypeName,code1,code2 
		FROM eVips_chgcv.dbo.vwLocationServices 
		WHERE UPPER(LTRIM(RTRIM(ServiceTypeName))) LIKE '%PHARM%TYPE%' 
			AND ServiceCategoryTypeName IS NOT NULL 
			AND UPPER(LTRIM(RTRIM(ServiceCategoryTypeName))) != ''
			) -- CONCLUDE ...
			AS vlspharmtype ON vp.PracticeID = vlspharmtype.PracticeID --DEFINE PHARM TYPE(s)
				AND vpl.LocationID = vlspharmtype.LocationID -- per YOUNG LADY LAURA email ON 20171221 ... Products (CMC & MEDICAL)  are stored at Location Level. The code below is joining based only on Practice ID. This should be based on PracticeID + Location
		LEFT JOIN ( -- INITIATE ...
		SELECT DISTINCT LocationID,PracticeID,ClassOrCategory, ServiceTypeName,ServiceCategoryTypeName,code1,code2 
		FROM eVips_chgcv.dbo.vwLocationServices 
		WHERE UPPER(LTRIM(RTRIM(ServiceTypeName))) LIKE '%PHARM%SERV%' 
			AND ServiceCategoryTypeName IS NOT NULL 
			AND UPPER(LTRIM(RTRIM(ServiceCategoryTypeName))) != ''
			) -- CONCLUDE ...
			AS vlspharmservice ON vp.PracticeID = vlspharmservice.PracticeID --DEFINE PHARM TYPE(s)
				AND vpl.LocationID = vlspharmservice.LocationID -- per YOUNG LADY LAURA email ON 20171221 ... Products (CMC & MEDICAL)  are stored at Location Level. The code below is joining based only on Practice ID. This should be based on PracticeID + Location
		LEFT JOIN ( -- INITIATE ...
		SELECT DISTINCT PracticeID,Code1,Code2,ServiceTypeName,ServiceCategoryTypeName 
		FROM eVips_chgcv.dbo.vwLocationServices 
		WHERE ServiceTypeName LIKE '274%TYPE%SERV%'
		) -- CONCLUDE ...
		AS vlsfocus ON vp.PracticeID = vlsfocus.PracticeID --Alt EFFORT TO DEFINE FAC CHAPTER(s)
		LEFT JOIN ( -- INITIATE ...
		SELECT DISTINCT ProviderID,TableName,EntityCode,EntityName,EntityTypeCode,EntityTypeName 
		FROM eVips_chgcv.dbo.vwEntityAssignments 
		WHERE UPPER(LTRIM(RTRIM(ISNULL(TableName,'')))) LIKE '%PRACTI%'
		) -- CONCLUDE ...
		AS vea ON vp.PracticeID = vea.ProviderID
LEFT JOIN
		 ( -- INITIATE ...
		SELECT DISTINCT ljvlp.ProductTypeCode,ljvlp.ProductTypeName,ljvlp.PracticeTypeName,ljvlp.PracticeID,ljvlp.LocationID,ljvlp.Archived,ljvlp.StatusTypeName,vlpstype.indirectory,vlpstype.ServiceTypeCode,vlpstype.ServiceTypeName,ljvlp.productname,ljvlp.ProductPanelStatusTypeName,ljvlp.ProductPanelStatusTypeCode,ljvlp.ProviderNumber,ljvlp.Focus,ljvlp.ProductID,ljvlp.LocationTypeName 
		FROM eVips_chgcv.dbo.vwLocationProducts AS ljvlp 
			JOIN evips_chgcv.dbo.vwLocationProductServices AS vlpstype ON ljvlp.LocationProductRecID = vlpstype.LocationProductRecID 
		--WHERE ISNULL(ljvlp.Archived,'') IN ('N','') 
		--	AND (ISNULL(ljvlp.StatusTypeName,'') IN ('ACTIVE','') 
		--		OR ljvlp.StatusTypeName LIKE '%PARTICIP%')
		--	AND ISNULL(vlpstype.Archived,'') IN ('N','') 
			) -- CONCLUDE ...
			AS vlp ON vpl.PracticeID = vlp.PracticeID --'YOUNG LADY LAURA GAH ID WHERE p.archived = 'N' AND s.ServiceTypeName = 'HOSPITAL' AND p.focus like '%GAH%'' ON 20171120 see ,UPPER(LTRIM(RTRIM(vlp.ServiceTypeName))) AS [vlpSERVICETYPENAME]
				AND vpl.LocationID = vlp.LocationID -- per YOUNG LADY LAURA email ON 20171221 ... Products (CMC & MEDICAL)  are stored at Location Level. The code below is joining based only on Practice ID. This should be based on PracticeID + Location
		LEFT JOIN ( -- INITIATE ...
		SELECT DISTINCT LocationID,PracticeID,AccreditationTypeCode,AccreditationTypeName,Notes 
		FROM eVips_chgcv.dbo.vwLocationAccreditations AS vla 
		WHERE ISNULL(vla.Archived,'') IN ('N','') 
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
		LEFT JOIN ( -- INITIATE ...
		SELECT DISTINCT zipcode,city,county,RegionTypeName 
		FROM eVips_chgcv.dbo.vwzipcodes 
		WHERE UPPER(LTRIM(RTRIM(ISNULL(county,'')))) LIKE '%SAN%DIEGO%'
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
		LEFT JOIN ( -- INITIATE ...
		SELECT DISTINCT r.FieldName,r.DisplayName,s.specialtycode,s.specialtyName AS [eVIPS_Specialty],r.Value AS [TIMELYACCESS_Profile] 
		FROM evips_chgcv.dbo.vwReferenceUserFields AS r 
			LEFT JOIN evips_chgcv.dbo.vwSpecialties AS s ON r.ParentRecID  = s.specialtyid
		WHERE r.tablename = 'Specialties' 
			AND r.fieldName = 'Specialty Grouping - Timely Access'
			) -- CONCLUDE ... 
		AS profile ON UPPER(LTRIM(RTRIM(ISNULL(vlsfocus.Code1,'')))) = UPPER(LTRIM(RTRIM(ISNULL(profile.specialtycode,''))))

--WHERE UPPER(LTRIM(RTRIM(vlp.ServiceTypeName))) LIKE '%ECM%' -- email FROM MS SANDRA ON 20211215 Specialty = ECM or Specialty listed below (vwLocationProductServices.ServiceTypeName)
--	OR UPPER(LTRIM(RTRIM(vlp.ServiceTypeName))) LIKE '%CSP%' -- email FROM MS SANDRA ON 20211215 Specialty = ECM or Specialty listed below (vwLocationProductServices.ServiceTypeName)
--	OR UPPER(LTRIM(RTRIM(vlp.ServiceTypeName))) LIKE '%HOUSING%' -- email FROM MS SANDRA ON 20211215 Specialty = ECM or Specialty listed below (vwLocationProductServices.ServiceTypeName)
--	OR UPPER(LTRIM(RTRIM(vlp.ServiceTypeName))) LIKE '%RECUPERATIVE%' -- email FROM MS SANDRA ON 20211215 Specialty = ECM or Specialty listed below (vwLocationProductServices.ServiceTypeName)
--	OR UPPER(LTRIM(RTRIM(vlp.ServiceTypeName))) LIKE '%RESPITE%' -- email FROM MS SANDRA ON 20211215 Specialty = ECM or Specialty listed below (vwLocationProductServices.ServiceTypeName)
--	OR UPPER(LTRIM(RTRIM(vlp.ServiceTypeName))) LIKE '%TRANSITION%' -- email FROM MS SANDRA ON 20211215 Specialty = ECM or Specialty listed below (vwLocationProductServices.ServiceTypeName)
--	OR UPPER(LTRIM(RTRIM(vlp.ServiceTypeName))) LIKE '%MEAL%TAILOR%' -- email FROM MS SANDRA ON 20211215 Specialty = ECM or Specialty listed below (vwLocationProductServices.ServiceTypeName)
--	OR UPPER(LTRIM(RTRIM(vlp.ServiceTypeName))) LIKE '%SOBERI%' -- email FROM MS SANDRA ON 20211215 Specialty = ECM or Specialty listed below (vwLocationProductServices.ServiceTypeName)
--	OR UPPER(LTRIM(RTRIM(vlp.ServiceTypeName))) LIKE '%ASTHMA%' -- email FROM MS SANDRA ON 20211215 Specialty = ECM or Specialty listed below (vwLocationProductServices.ServiceTypeName)
--	OR UPPER(LTRIM(RTRIM(vlp.ServiceTypeName))) LIKE '%FED%QUAL%' -- email FROM MS SANDRA ON 20211215 Specialty = ECM or Specialty listed below (vwLocationProductServices.ServiceTypeName)
--	OR UPPER(LTRIM(RTRIM(vlp.ServiceTypeName))) IN ('HTNS','HD','HTSS','STPHH','RCMR','RS','DHP','NFTDALF','CTSNFTH','PCHS','EAAHM','MMTM','SC','AR','ECM') -- email FROM MS SANDRA ON 20211215 Specialty = ECM or Specialty listed below (vwLocationProductServices.ServiceTypeName)
--	OR UPPER(LTRIM(RTRIM(vlp.ServiceTypeCode))) IN ('HTNS','HD','HTSS','STPHH','RCMR','RS','DHP','NFTDALF','CTSNFTH','PCHS','EAAHM','MMTM','SC','AR','ECM') -- email FROM MS SANDRA ON 20211215 Specialty = ECM or Specialty listed below (vwLocationProductServices.ServiceTypeName)

--WHERE vlp.ProductTypeName LIKE '%ECM%' -- email FROM MS SANDRA ON 20211215 Provider type = ECM or CSP (vwLocationProducts.ProductTypeCode)
--	OR vlp.ProductTypeName LIKE '%CSP%' -- email FROM MS SANDRA ON 20211215 Provider type = ECM or CSP (vwLocationProducts.ProductTypeCode)
--	OR vlp.ProductTypeCode LIKE '%ECM%' -- email FROM MS SANDRA ON 20211215 Provider type = ECM or CSP (vwLocationProducts.ProductTypeCode)
--	OR vlp.ProductTypeCode LIKE '%CSP%' -- email FROM MS SANDRA ON 20211215 Provider type = ECM or CSP (vwLocationProducts.ProductTypeCode)

--WHERE vp.Archived IN ('N') --WITH eVIPS LOGICAL BINARY OPTION(s) IN USE •	Must not be archived 
--	 AND ISNULL(vp.PracticeStatus,'') IN ('ACTIVE','CONTRACTED','NA','') --•	Contract Status must be Active
--	 AND vpl.Archived IN ('N') --WITH eVIPS LOGICAL BINARY OPTION(s) IN USE •	Must not be archived

--WHERE UPPER(LTRIM(RTRIM(ISNULL(vp.PracticeName,'')))) LIKE '%FAMILY HEALTH CENTERS OF SAN DIEGO%'

WHERE   LTRIM(RTRIM(vp.NationalProviderID)) IN ('1790002806')
	OR UPPER(LTRIM(RTRIM(vpl.LocationName))) LIKE '%PEOPLE%ASSI%'

SELECT DISTINCT ProductTypeName,ProductTypeCode,NationalProviderID,StatusTypeName,LocationName,LineNumber1,City,State,ZipCode,*
FROM evips_chgcv.dbo.vwLocationProducts AS vlp
WHERE vlp.ProductTypeName LIKE '%ECM%' -- email FROM MS SANDRA ON 20211215 Provider type = ECM or CSP (vwLocationProducts.ProductTypeCode)
	OR vlp.ProductTypeName LIKE '%CSP%' -- email FROM MS SANDRA ON 20211215 Provider type = ECM or CSP (vwLocationProducts.ProductTypeCode)
	OR vlp.ProductTypeCode LIKE '%ECM%' -- email FROM MS SANDRA ON 20211215 Provider type = ECM or CSP (vwLocationProducts.ProductTypeCode)
	OR vlp.ProductTypeCode LIKE '%CSP%' -- email FROM MS SANDRA ON 20211215 Provider type = ECM or CSP (vwLocationProducts.ProductTypeCode)

SELECT DISTINCT LocationName,ServiceTypeCode,ServiceTypeName
FROM evips_chgcv.dbo.vwLocationProductServices AS vlp
WHERE UPPER(LTRIM(RTRIM(vlp.ServiceTypeName))) LIKE '%ECM%' -- email FROM MS SANDRA ON 20211215 Specialty = ECM or Specialty listed below (vwLocationProductServices.ServiceTypeName)
	OR UPPER(LTRIM(RTRIM(vlp.ServiceTypeName))) LIKE '%CSP%' -- email FROM MS SANDRA ON 20211215 Specialty = ECM or Specialty listed below (vwLocationProductServices.ServiceTypeName)
	OR UPPER(LTRIM(RTRIM(vlp.ServiceTypeName))) LIKE '%HOUSING%' -- email FROM MS SANDRA ON 20211215 Specialty = ECM or Specialty listed below (vwLocationProductServices.ServiceTypeName)
	OR UPPER(LTRIM(RTRIM(vlp.ServiceTypeName))) LIKE '%RECUPERATIVE%' -- email FROM MS SANDRA ON 20211215 Specialty = ECM or Specialty listed below (vwLocationProductServices.ServiceTypeName)
	OR UPPER(LTRIM(RTRIM(vlp.ServiceTypeName))) LIKE '%RESPITE%' -- email FROM MS SANDRA ON 20211215 Specialty = ECM or Specialty listed below (vwLocationProductServices.ServiceTypeName)
	OR UPPER(LTRIM(RTRIM(vlp.ServiceTypeName))) LIKE '%TRANSITION%' -- email FROM MS SANDRA ON 20211215 Specialty = ECM or Specialty listed below (vwLocationProductServices.ServiceTypeName)
	OR UPPER(LTRIM(RTRIM(vlp.ServiceTypeName))) LIKE '%MEAL%TAILOR%' -- email FROM MS SANDRA ON 20211215 Specialty = ECM or Specialty listed below (vwLocationProductServices.ServiceTypeName)
	OR UPPER(LTRIM(RTRIM(vlp.ServiceTypeName))) LIKE '%SOBERI%' -- email FROM MS SANDRA ON 20211215 Specialty = ECM or Specialty listed below (vwLocationProductServices.ServiceTypeName)
	OR UPPER(LTRIM(RTRIM(vlp.ServiceTypeName))) LIKE '%ASTHMA%' -- email FROM MS SANDRA ON 20211215 Specialty = ECM or Specialty listed below (vwLocationProductServices.ServiceTypeName)
	OR UPPER(LTRIM(RTRIM(vlp.ServiceTypeName))) LIKE '%FED%QUAL%' -- email FROM MS SANDRA ON 20211215 Specialty = ECM or Specialty listed below (vwLocationProductServices.ServiceTypeName)
	OR UPPER(LTRIM(RTRIM(vlp.ServiceTypeName))) IN ('HTNS','HD','HTSS','STPHH','RCMR','RS','DHP','NFTDALF','CTSNFTH','PCHS','EAAHM','MMTM','SC','AR','ECM') -- email FROM MS SANDRA ON 20211215 Specialty = ECM or Specialty listed below (vwLocationProductServices.ServiceTypeName)
	OR UPPER(LTRIM(RTRIM(vlp.ServiceTypeCode))) IN ('HTNS','HD','HTSS','STPHH','RCMR','RS','DHP','NFTDALF','CTSNFTH','PCHS','EAAHM','MMTM','SC','AR','ECM') -- email FROM MS SANDRA ON 20211215 Specialty = ECM or Specialty listed below (vwLocationProductServices.ServiceTypeName)
ORDER BY vlp.ServiceTypeName,Locationname

SELECT DISTINCT *
FROM eVips_chgcv.dbo.vwPractitionerDemographics AS vpd
	JOIN eVips_chgcv.dbo.vwPractitionerProducts AS vpp ON vpd.PractitionerID = vpp.PractitionerID -- aka cert_provider
		-- AND vpp.ProductID = vpps.ProductID -- aka cert_provider
	JOIN eVips_chgcv.dbo.vwPractitionerProductSpecialties AS vpps ON vpp.PractitionerProductRecID = vpps.PractitionerProductRecID
WHERE UPPER(LTRIM(RTRIM(vpps.SpecialtyCode))) IN ('HTNS','HD','HTSS','STPHH','RCMR','RS','DHP','NFTDALF','CTSNFTH','PCHS','EAAHM','MMTM','SC','AR','ECM')
	OR UPPER(LTRIM(RTRIM(vpps.SpecialtyName))) IN ('HTNS','HD','HTSS','STPHH','RCMR','RS','DHP','NFTDALF','CTSNFTH','PCHS','EAAHM','MMTM','SC','AR','ECM')

SELECT DISTINCT DBA,LocationName,[Clinic Name],vlpSERVICETYPENAME
FROM INFORMATICS.dbo.TimelyAccessFAC AS e
WHERE DBA LIKE '%FAMILY HEALTH CENTERS OF SAN DIEGO%'
ORDER BY e.vlpSERVICETYPENAME

SELECT DISTINCT DBA,INDEXNM,Specialty,*
FROM INFORMATICS.dbo.PROVDIR_ECMCSP AS e
WHERE DBA LIKE '%FAMILY HEALTH CENTERS OF SAN DIEGO%'
ORDER BY e.Specialty

		LEFT JOIN
		 ( -- INITIATE ...
		SELECT DISTINCT ljvlp.ProductTypeCode,ljvlp.ProductTypeName,ljvlp.PracticeTypeName,ljvlp.PracticeID,ljvlp.LocationID,ljvlp.Archived,ljvlp.StatusTypeName,vlpstype.indirectory,vlpstype.ServiceTypeCode,vlpstype.ServiceTypeName,ljvlp.productname,ljvlp.ProductPanelStatusTypeName,ljvlp.ProductPanelStatusTypeCode,ljvlp.ProviderNumber,ljvlp.Focus,ljvlp.ProductID,ljvlp.LocationTypeName 
		FROM eVips_chgcv.dbo.vwLocationProducts AS ljvlp 
			JOIN evips_chgcv.dbo.vwLocationProductServices AS vlpstype ON ljvlp.LocationProductRecID = vlpstype.LocationProductRecID 
		--WHERE ISNULL(ljvlp.Archived,'') IN ('N','') 
		--	AND (ISNULL(ljvlp.StatusTypeName,'') IN ('ACTIVE','') 
		--		OR ljvlp.StatusTypeName LIKE '%PARTICIP%')
		--	AND ISNULL(vlpstype.Archived,'') IN ('N','') 
			) -- CONCLUDE ...
			AS vlp ON vpl.PracticeID = vlp.PracticeID --'YOUNG LADY LAURA GAH ID WHERE p.archived = 'N' AND s.ServiceTypeName = 'HOSPITAL' AND p.focus like '%GAH%'' ON 20171120 see ,UPPER(LTRIM(RTRIM(vlp.ServiceTypeName))) AS [vlpSERVICETYPENAME]
				AND vpl.LocationID = vlp.LocationID -- per YOUNG LADY LAURA email ON 20171221 ... Products (CMC & MEDICAL)  are stored at Location Level. The code below is joining based only on Practice ID. This should be based on PracticeID + Location

------------------------------------------------------------------------------------------------------------------------
	-- Error Trapping: Check If Permanent Table(s) Already Exist(s) And Drop If Applicable --
------------------------------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS INFORMATICS.dbo.PROVDIR_ECMCSP  -- SQL Server 2016 and later -- DYNAMIC tmp OR STATIC [TABLE] #TableName is a local temporary table visible only in the current session; #TableName is a GLOBAL temporary table visible to all sessions IN ('TempDB')

SELECT *
INTO INFORMATICS.dbo.PROVDIR_ECMCSP
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ISNULL(CAST(spe.HospitalName AS nvarchar(100)),'')+' '+ISNULL(CAST(spe.HOSPabbrev AS nvarchar(100)),'')+' ID# '+ISNULL(CAST(spe.provider_no AS nvarchar(25)),'') COLLATE DATABASE_DEFAULT AS [TESTING],HospitalName --,vlpSERVICETYPENAME,plan_type,[Type of Service FOCUS],ServiceCategoryTypeName,Code1,Code2 -- CHECK 1st
FROM INFORMATICS.dbo.PROVDIR_HHC -- USE [PROVDIR_HHC] AS THE TEMPLATE

/* ------------------------------------------------------------------------------------------------------------------------
	-- Error Trapping: Check If Permanent Table(s) Already Exist(s) And Drop If Applicable --
------------------------------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS INFORMATICS.dbo.PROVDIR_ECM  -- SQL Server 2016 and later -- DYNAMIC tmp OR STATIC [TABLE] #TableName is a local temporary table visible only in the current session; #TableName is a GLOBAL temporary table visible to all sessions IN ('TempDB')

SELECT *
INTO INFORMATICS.dbo.PROVDIR_ECM
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ISNULL(CAST(spe.HospitalName AS nvarchar(100)),'')+' '+ISNULL(CAST(spe.HOSPabbrev AS nvarchar(100)),'')+' ID# '+ISNULL(CAST(spe.provider_no AS nvarchar(25)),'') COLLATE DATABASE_DEFAULT AS [TESTING],HospitalName --,vlpSERVICETYPENAME,plan_type,[Type of Service FOCUS],ServiceCategoryTypeName,Code1,Code2 -- CHECK 1st
FROM INFORMATICS.dbo.PROVDIR_HHC

------------------------------------------------------------------------------------------------------------------------
	-- Error Trapping: Check If Permanent Table(s) Already Exist(s) And Drop If Applicable --
------------------------------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS INFORMATICS.dbo.PROVDIR_COMMUNITYSUPPORTS  -- SQL Server 2016 and later -- DYNAMIC tmp OR STATIC [TABLE] #TableName is a local temporary table visible only in the current session; #TableName is a GLOBAL temporary table visible to all sessions IN ('TempDB')

SELECT *
INTO INFORMATICS.dbo.PROVDIR_COMMUNITYSUPPORTS
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ISNULL(CAST(spe.HospitalName AS nvarchar(100)),'')+' '+ISNULL(CAST(spe.HOSPabbrev AS nvarchar(100)),'')+' ID# '+ISNULL(CAST(spe.provider_no AS nvarchar(25)),'') COLLATE DATABASE_DEFAULT AS [TESTING],HospitalName --,vlpSERVICETYPENAME,plan_type,[Type of Service FOCUS],ServiceCategoryTypeName,Code1,Code2 -- CHECK 1st
FROM INFORMATICS.dbo.PROVDIR_HHC */

		SELECT HospitalName,ServiceTypeName,vlpSERVICETYPENAME,plan_type,vlpSTATUSTYPENAME,[Type of Service],[Type of Service (Other)],[Type of Service FOCUS],*
		FROM INFORMATICS.dbo.TimelyAccessFAC
		-- WHERE HospitalName LIKE '%KINDRED%'
		WHERE [Type of Service FOCUS] LIKE '%GAH%'

		SELECT CHAPTER_NAME,*
		FROM INFORMATICS.dbo.PROVDIR_HHC
		WHERE INDEXNM LIKE '%KINDRED%'

		SELECT CHAPTER_NAME,*
		FROM INFORMATICS.dbo.PROVDIR_HDM
		WHERE INDEXNM LIKE '%KINDRED%'

		SELECT CHAPTER_NAME,*
		FROM INFORMATICS.dbo.PROVDIR_HOSGENERALACUTE
		WHERE INDEXNM LIKE '%KINDRED%'







JAH 'ADJUST OFFICE HOURS'
x Office Hours logic has been adjusted per Ms. Sandra request on 20210726 ("...Subject: RE: Provider Directory Office Hours Not Updating - Good morning,  Yes, this should affect all reports.  The repository shouldn’t have any archived office hours.  After you make the adjustments, please run a test directory excel file so that we can see the changes for this week’s directory before Thursday.  Thanks so much! )"

		SELECT vpps.InDirectory,vpps.PractitionerProductRecID,vpp.Archived,vpp.StatusTypeName,vpp.LocationID,vpp.InDirectory,*
		FROM evips_chgcv.dbo.vwPractitionerProducts AS vpp
				JOIN evips_chgcv.dbo.vwPractitionerProductSpecialties AS vpps ON vpp.PractitionerProductRecID = vpps.PractitionerProductRecID
		WHERE vpp.LocationID IN ('4129676')
		-- WHERE vpp.LastName LIKE '%ESKANDER%'
		-- WHERE  vpp.PractitionerID IN ('4387709') -- ESKANDER NPI: 1144486929
		--	AND LineNumber1 LIKE '%910%SYCAMORE%'
		-- AND LineNumber2 LIKE '%102%'
			-- AND LocationID IN ('5178507') 
			AND vpps.InDirectory IN ('Y')

--------------------------------------------------------------------------------------------------------------------
	-- Error Trapping: Check If Permanent Table(s) Already Exist(s) And Drop If Applicable --
--------------------------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS #HOURS_PROV -- SQL Server 2016 and later -- DYNAMIC tmp OR STATIC [TABLE] #TableName is a local temporary table visible only in the current session; #TableName is a GLOBAL temporary table visible to all sessions IN ('TempDB')
 
SELECT DISTINCT LocationID,PracticeID,PractitionerID
,CAST(NULL AS varchar(255)) AS [Office Hour(s)] -- vwLocationHours OR vwPractitionerLocationHours ,UPPER(LTRIM(RTRIM(address.legal_name))) AS [Office Hour(s)] SAMPLE(): 'MON-FRI 8:30AM - 6PM, SAT 8:30AM-2PM, SUN CLOSED'
,CAST(NULL AS varchar(15)) AS [1_START] -- SUNDAY
,CAST(NULL AS varchar(15)) AS [2_START] -- MONDAY
,CAST(NULL AS varchar(15)) AS [3_START] -- TUESDAY
,CAST(NULL AS varchar(15)) AS [4_START] -- WEDNESDAY
,CAST(NULL AS varchar(15)) AS [5_START] -- THURSDAY
,CAST(NULL AS varchar(15)) AS [6_START] -- FRIDAY
,CAST(NULL AS varchar(15)) AS [7_START] -- SATURDAY
,CAST(NULL AS varchar(15)) AS [1_END] -- SUNDAY
,CAST(NULL AS varchar(15)) AS [2_END] -- MONDAY
,CAST(NULL AS varchar(15)) AS [3_END] -- TUESDAY
,CAST(NULL AS varchar(15)) AS [4_END] -- WEDNESDAY
,CAST(NULL AS varchar(15)) AS [5_END] -- THURSDAY
,CAST(NULL AS varchar(15)) AS [6_END] -- FRIDAY
,CAST(NULL AS varchar(15)) AS [7_END] -- SATURDAY
INTO #HOURS_PROV
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
FROM evips_chgcv.dbo.vwPractitionerLocationHours

	--DUP(s)--
-- SELECT  'DUP Validation' AS [NOTE(s)],*
-- FROM #HOURS_PROV
-- WHERE LTRIM(RTRIM(locationID))+LTRIM(RTRIM(PractitionerID)) IN (SELECT LTRIM(RTRIM(dup.locationID))+LTRIM(RTRIM(dup.PractitionerID))
-- FROM #HOURS_PROV AS dup
-- GROUP BY LTRIM(RTRIM(dup.locationID))+LTRIM(RTRIM(dup.PractitionerID)) --Duplication Driver
-- HAVING COUNT(1)>1) --HAVING clause RESERVED for AGGREGATE(s)
-- ORDER BY LTRIM(RTRIM(locationID))+LTRIM(RTRIM(PractitionerID))

		-- SELECT * FROM #HOURS_PROV

UPDATE #HOURS_PROV
SET [1_START] = REPLACE(REPLACE(LTRIM(RIGHT(CONVERT(VARCHAR(20),CAST(StartTime AS datetime),100), 7)),'AM',' AM'),'PM',' PM') --AS [Time in the 12-hour format hh:miAM (or PM) SPACING]
,[1_END] = REPLACE(REPLACE(LTRIM(RIGHT(CONVERT(VARCHAR(20),CAST(EndTime AS datetime),100), 7)),'AM',' AM'),'PM',' PM') --AS [Time in the 12-hour format hh:miAM (or PM) SPACING]
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
FROM #HOURS_PROV AS h
	JOIN evips_chgcv.dbo.vwPractitionerLocationHours AS vlh ON h.LocationID = vlh.LocationID
		AND h.PracticeID = vlh.PracticeID
		AND h.PractitionerID = vlh.PractitionerID
WHERE LTRIM(RTRIM(vlh.DayOfWeekID)) = '1' --SUNDAY
	AND UPPER(LTRIM(RTRIM(ISNULL(Archived,'')))) NOT IN ('Y')

UPDATE #HOURS_PROV
SET [2_START] = REPLACE(REPLACE(LTRIM(RIGHT(CONVERT(VARCHAR(20),CAST(StartTime AS datetime),100), 7)),'AM',' AM'),'PM',' PM') --AS [Time in the 12-hour format hh:miAM (or PM) SPACING]
,[2_END] = REPLACE(REPLACE(LTRIM(RIGHT(CONVERT(VARCHAR(20),CAST(EndTime AS datetime),100), 7)),'AM',' AM'),'PM',' PM') --AS [Time in the 12-hour format hh:miAM (or PM) SPACING]
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
FROM #HOURS_PROV AS h
	JOIN evips_chgcv.dbo.vwPractitionerLocationHours AS vlh ON h.LocationID = vlh.LocationID
		AND h.PracticeID = vlh.PracticeID
		AND h.PractitionerID = vlh.PractitionerID
WHERE LTRIM(RTRIM(vlh.DayOfWeekID)) = '2' --MONDAY
	AND UPPER(LTRIM(RTRIM(ISNULL(Archived,'')))) NOT IN ('Y')

UPDATE #HOURS_PROV
SET [3_START] = REPLACE(REPLACE(LTRIM(RIGHT(CONVERT(VARCHAR(20),CAST(StartTime AS datetime),100), 7)),'AM',' AM'),'PM',' PM') --AS [Time in the 12-hour format hh:miAM (or PM) SPACING]
,[3_END] = REPLACE(REPLACE(LTRIM(RIGHT(CONVERT(VARCHAR(20),CAST(EndTime AS datetime),100), 7)),'AM',' AM'),'PM',' PM') --AS [Time in the 12-hour format hh:miAM (or PM) SPACING]
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
FROM #HOURS_PROV AS h
	JOIN evips_chgcv.dbo.vwPractitionerLocationHours AS vlh ON h.LocationID = vlh.LocationID
		AND h.PracticeID = vlh.PracticeID
		AND h.PractitionerID = vlh.PractitionerID
WHERE LTRIM(RTRIM(vlh.DayOfWeekID)) = '3' --TUESDAY
	AND UPPER(LTRIM(RTRIM(ISNULL(Archived,'')))) NOT IN ('Y')

UPDATE #HOURS_PROV
SET [4_START] = REPLACE(REPLACE(LTRIM(RIGHT(CONVERT(VARCHAR(20),CAST(StartTime AS datetime),100), 7)),'AM',' AM'),'PM',' PM') --AS [Time in the 12-hour format hh:miAM (or PM) SPACING]
,[4_END] = REPLACE(REPLACE(LTRIM(RIGHT(CONVERT(VARCHAR(20),CAST(EndTime AS datetime),100), 7)),'AM',' AM'),'PM',' PM') --AS [Time in the 12-hour format hh:miAM (or PM) SPACING]
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
FROM #HOURS_PROV AS h
	JOIN evips_chgcv.dbo.vwPractitionerLocationHours AS vlh ON h.LocationID = vlh.LocationID
		AND h.PracticeID = vlh.PracticeID
		AND h.PractitionerID = vlh.PractitionerID
WHERE LTRIM(RTRIM(vlh.DayOfWeekID)) = '4' --WEDNESDAY
	AND UPPER(LTRIM(RTRIM(ISNULL(Archived,'')))) NOT IN ('Y')

UPDATE #HOURS_PROV
SET [5_START] = REPLACE(REPLACE(LTRIM(RIGHT(CONVERT(VARCHAR(20),CAST(StartTime AS datetime),100), 7)),'AM',' AM'),'PM',' PM') --AS [Time in the 12-hour format hh:miAM (or PM) SPACING]
,[5_END] = REPLACE(REPLACE(LTRIM(RIGHT(CONVERT(VARCHAR(20),CAST(EndTime AS datetime),100), 7)),'AM',' AM'),'PM',' PM') --AS [Time in the 12-hour format hh:miAM (or PM) SPACING]
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
FROM #HOURS_PROV AS h
	JOIN evips_chgcv.dbo.vwPractitionerLocationHours AS vlh ON h.LocationID = vlh.LocationID
		AND h.PracticeID = vlh.PracticeID
		AND h.PractitionerID = vlh.PractitionerID
WHERE LTRIM(RTRIM(vlh.DayOfWeekID)) = '5' --THURSDAY
	AND UPPER(LTRIM(RTRIM(ISNULL(Archived,'')))) NOT IN ('Y')

UPDATE #HOURS_PROV
SET [6_START] = REPLACE(REPLACE(LTRIM(RIGHT(CONVERT(VARCHAR(20),CAST(StartTime AS datetime),100), 7)),'AM',' AM'),'PM',' PM') --AS [Time in the 12-hour format hh:miAM (or PM) SPACING]
,[6_END] = REPLACE(REPLACE(LTRIM(RIGHT(CONVERT(VARCHAR(20),CAST(EndTime AS datetime),100), 7)),'AM',' AM'),'PM',' PM') --AS [Time in the 12-hour format hh:miAM (or PM) SPACING]
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
FROM #HOURS_PROV AS h
	JOIN evips_chgcv.dbo.vwPractitionerLocationHours AS vlh ON h.LocationID = vlh.LocationID
		AND h.PracticeID = vlh.PracticeID
		AND h.PractitionerID = vlh.PractitionerID
WHERE LTRIM(RTRIM(vlh.DayOfWeekID)) = '6' --FRIDAY
	AND UPPER(LTRIM(RTRIM(ISNULL(Archived,'')))) NOT IN ('Y')

UPDATE #HOURS_PROV
SET [7_START] = REPLACE(REPLACE(LTRIM(RIGHT(CONVERT(VARCHAR(20),CAST(StartTime AS datetime),100), 7)),'AM',' AM'),'PM',' PM') --AS [Time in the 12-hour format hh:miAM (or PM) SPACING]
,[7_END] = REPLACE(REPLACE(LTRIM(RIGHT(CONVERT(VARCHAR(20),CAST(EndTime AS datetime),100), 7)),'AM',' AM'),'PM',' PM') --AS [Time in the 12-hour format hh:miAM (or PM) SPACING]
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM #HOURS_PROV AS h
	JOIN evips_chgcv.dbo.vwPractitionerLocationHours AS vlh ON h.LocationID = vlh.LocationID
		AND h.PracticeID = vlh.PracticeID
		AND h.PractitionerID = vlh.PractitionerID
WHERE LTRIM(RTRIM(vlh.DayOfWeekID)) = '7' --SATURDAY
	AND UPPER(LTRIM(RTRIM(ISNULL(Archived,'')))) NOT IN ('Y')

		-- SELECT * FROM #HOURS_PROV

UPDATE #HOURS_PROV
SET [Office Hour(s)] = CASE
WHEN [2_START] = [3_START]
	AND [2_START] = [4_START]
	AND [2_START] = [5_START]
	AND [2_START] = [6_START]
	AND [2_END] = [3_END]
	AND [2_END] = [4_END]
	AND [2_END] = [5_END]
	AND [2_END] = [6_END]
THEN 'MON - FRI '+[2_START]+' - '+[2_END]
+
CASE
WHEN [7_START] IS NOT NULL
THEN ', SAT  '+[7_START]+' - '+[7_END]
ELSE ''
END
+
CASE
WHEN [1_START] IS NOT NULL
THEN ', SUN  '+[1_START]+' - '+[1_END]
ELSE ''
END
ELSE CASE
WHEN [2_START] IS NOT NULL
THEN 'MON '+[2_START]+' - '+[2_END]
ELSE ''
END
+
CASE
WHEN [3_START] IS NOT NULL
THEN ', TUE '+[3_START]+' - '+[3_END]
ELSE ''
END
+
CASE
WHEN [4_START] IS NOT NULL
THEN ', WED '+[4_START]+' - '+[4_END]
ELSE ''
END
+
CASE
WHEN [5_START] IS NOT NULL
THEN ', THU '+[5_START]+' - '+[5_END]
ELSE ''
END
+
CASE
WHEN [6_START] IS NOT NULL
THEN ', FRI '+[6_START]+' - '+[6_END]
ELSE ''
END
+
CASE
WHEN [7_START] IS NOT NULL
THEN ', SAT  '+[7_START]+' - '+[7_END]
ELSE ''
END
+
CASE
WHEN [1_START] IS NOT NULL
THEN ', SUN  '+[1_START]+' - '+[1_END]
ELSE ''
END
END --NESTED()
-- SELECT TOP 100 *  -- CHECK 1st
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM #HOURS_PROV AS h

		-- SELECT * FROM #HOURS_PROV

UPDATE #HOURS_PROV
SET [Office Hour(s)] = CASE
WHEN [Office Hour(s)] LIKE ', %'
THEN SUBSTRING([Office Hour(s)],3,255)
ELSE [Office Hour(s)]
END 
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
FROM #HOURS_PROV

		SELECT * 
		FROM #HOURS_PROV 
		WHERE LocationID IN ('5178507','4129676')
		-- WHERE PractitionerID IN ('4387709')
			-- AND LocationID IN ('5178507') -- ('4126929') -- ('4129676')

		SELECT LineNumber1,LineNumber2,LineNumber3,LocationID,PractitionerID,PracticeID,Archived,LocationArchived,InDirectory,DayOfWeekID,DayOfWeekName,StartTime,EndTime,*
		FROM evips_chgcv.dbo.vwPractitionerLocationHours AS plh
		-- WHERE LocationID IN ('5178507')
		-- WHERE  PractitionerID IN ('4387709')
		--	AND LineNumber1 LIKE '%910%SYCAMORE%'
		-- AND LineNumber2 LIKE '%102%'
			-- AND LocationID IN ('5178507') -- ('4126929') -- ('4129676')
			 -- AND DayOfWeekID IN ('1','7')
		--WHERE PractitionerID IN ('4382306')
			-- AND UPPER(LTRIM(RTRIM(ISNULL(Archived,'')))) NOT IN ('Y')
			WHERE LineNumber1 LIKE '%910%SYCAMORE%'
			AND LineNumber2 LIKE '%102%'
		ORDER BY plh.PractitionerID,plh.LocationID

		SELECT DISTINCT  [Office Hour(s)],Address,lookup_key AS [PractitionerID],[Clinic QNXT provid] AS [LocationID],* FROM INFORMATICS.dbo.PROVDIR_SPE WHERE INDEXNM LIKE '%ESKANDER%' AND [Participating Network] LIKE '%CL1%'  AND Address LIKE '%910%SYCAMORE%'
		
SELECT COUNT(DISTINCT(howmany.[PractitionerID])) AS [Impacted PractitionerID Provider(s)],COUNT(DISTINCT(howmany.NPIis)) AS [Impacted NPI Provider(s)]
FROM 
( -- INITIATE ...
SELECT prov.*
FROM 
( -- INITIATE ...
SELECT DISTINCT INDEXNM AS [PDFnm],[Office Hour(s)] AS [OfficeHour(s)],Address AS Addr,lookup_key AS [PractitionerID],[Clinic QNXT provid] AS [LocationID],NPIis 
FROM INFORMATICS.dbo.PROVDIR_PCP
UNION
SELECT DISTINCT INDEXNM AS [PDFnm],[Office Hour(s)] AS [OfficeHour(s)],Address AS Addr,lookup_key AS [PractitionerID],[Clinic QNXT provid] AS [LocationID],NPIis 
FROM INFORMATICS.dbo.PROVDIR_NPMP
UNION 
SELECT DISTINCT INDEXNM AS [PDFnm],[Office Hour(s)] AS [OfficeHour(s)],Address AS Addr,lookup_key AS [PractitionerID],[Clinic QNXT provid] AS [LocationID],NPIis 
FROM INFORMATICS.dbo.PROVDIR_SPE
UNION 
SELECT DISTINCT INDEXNM AS [PDFnm],[Office Hour(s)] AS [OfficeHour(s)],Address AS Addr,lookup_key AS [PractitionerID],[Clinic QNXT provid] AS [LocationID],NPIis 
FROM INFORMATICS.dbo.PROVDIR_MH
UNION 
SELECT DISTINCT INDEXNM AS [PDFnm],[Office Hour(s)] AS [OfficeHour(s)],Address AS Addr,lookup_key AS [PractitionerID],[Clinic QNXT provid] AS [LocationID],NPIis 
FROM INFORMATICS.dbo.PROVDIR_AHP
UNION
SELECT DISTINCT INDEXNM AS [PDFnm],[Office Hour(s)] AS [OfficeHour(s)],Address AS Addr,lookup_key AS [PractitionerID],[Clinic QNXT provid] AS [LocationID],NPIis 
FROM INFORMATICS.dbo.PROVDIR_VSP		
) -- CONCLUDE ...
AS prov 
	JOIN 
	( -- INITIATE 
	SELECT *
	FROM INFORMATICS.dbo.PROVDIR_PCP
	UNION 
	SELECT *
	FROM INFORMATICS.dbo.PROVDIR_NPMP
	UNION
	SELECT *
	FROM INFORMATICS.dbo.PROVDIR_SPE
	UNION
	SELECT *
	FROM INFORMATICS.dbo.PROVDIR_MH
	UNION
	SELECT *
	FROM INFORMATICS.dbo.PROVDIR_AHP
	UNION
	SELECT *
	FROM INFORMATICS.dbo.PROVDIR_VSP
	) -- CONCLUDE ...
	AS multi ON prov.Addr = multi.Address
		AND prov.PractitionerID = multi.lookup_key
WHERE prov.[OfficeHour(s)] != multi.[Office Hour(s)]
) -- CONCLUDE ...
AS howmany







SELECT DISTINCT 'PROVIDER WITH MULTIPLE OFFICE HOURS AT SINGLE LOCATION' AS [NOTE(S)],prov.INDEXNM,prov.[OfficeHour(s)],prov.Addr,prov.[Clinic Name],prov.PractitionerID,prov.LocationID,prov.[Telephone Number]
FROM 
( -- INITIATE ...
SELECT DISTINCT INDEXNM AS [PDFnm],[Office Hour(s)] AS [OfficeHour(s)],Address AS Addr,lookup_key AS [PractitionerID],[Clinic QNXT provid] AS [LocationID],*
FROM INFORMATICS.dbo.PROVDIR_PCP
UNION
SELECT DISTINCT INDEXNM AS [PDFnm],[Office Hour(s)] AS [OfficeHour(s)],Address AS Addr,lookup_key AS [PractitionerID],[Clinic QNXT provid] AS [LocationID],*
FROM INFORMATICS.dbo.PROVDIR_NPMP
UNION 
SELECT DISTINCT INDEXNM AS [PDFnm],[Office Hour(s)] AS [OfficeHour(s)],Address AS Addr,lookup_key AS [PractitionerID],[Clinic QNXT provid] AS [LocationID],*
FROM INFORMATICS.dbo.PROVDIR_SPE
UNION 
SELECT DISTINCT INDEXNM AS [PDFnm],[Office Hour(s)] AS [OfficeHour(s)],Address AS Addr,lookup_key AS [PractitionerID],[Clinic QNXT provid] AS [LocationID],*
FROM INFORMATICS.dbo.PROVDIR_MH
UNION 
SELECT DISTINCT INDEXNM AS [PDFnm],[Office Hour(s)] AS [OfficeHour(s)],Address AS Addr,lookup_key AS [PractitionerID],[Clinic QNXT provid] AS [LocationID],*
FROM INFORMATICS.dbo.PROVDIR_AHP
UNION
SELECT DISTINCT INDEXNM AS [PDFnm],[Office Hour(s)] AS [OfficeHour(s)],Address AS Addr,lookup_key AS [PractitionerID],[Clinic QNXT provid] AS [LocationID],*
FROM INFORMATICS.dbo.PROVDIR_VSP		
) -- CONCLUDE ...
AS prov 
	JOIN 
	( -- INITIATE 
	SELECT *
	FROM INFORMATICS.dbo.PROVDIR_PCP
	UNION 
	SELECT *
	FROM INFORMATICS.dbo.PROVDIR_NPMP
	UNION
	SELECT *
	FROM INFORMATICS.dbo.PROVDIR_SPE
	UNION
	SELECT *
	FROM INFORMATICS.dbo.PROVDIR_MH
	UNION
	SELECT *
	FROM INFORMATICS.dbo.PROVDIR_AHP
	UNION
	SELECT *
	FROM INFORMATICS.dbo.PROVDIR_VSP
	) -- CONCLUDE ...
	AS multi ON prov.Addr = multi.Address
		AND prov.PractitionerID = multi.lookup_key
WHERE prov.[OfficeHour(s)] != multi.[Office Hour(s)]
ORDER BY prov.Addr,prov.INDEXNM,prov.LocationID

		SELECT * FROM evips_chgcv.dbo.Addresses WHERE LineNumber1 LIKE '%910%SYCAMORE%'
 
 





-- ==================================================================
	-- BASELINE eVIPS PROVIDER CHECK(s) --
-- ==================================================================
SELECT DISTINCT 'BASELINE eVIPS PROVIDER CHECK(s)' AS [NOTE(S)],vpp.ProductName,vpd.NationalProviderID,vpps.SpecialtyCode,vpps.SpecialtyName,vpd.LastName,vpd.FirstName,vpps.InDirectory,vpd.Archived,vpps.Archived,vploc.Archived,vpracloc.Archived,vpd.PractitionerStatus,vpp.Archived,vpp.StatusTypeName,vploc.*
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT * FROM INFORMATICS.dbo.ZIP_CODES -- CHECK 1st
-- SELECT DISTINCT SpecialtyCode,SpecialtyName FROM eVips_chgcv.dbo.vwPractitionerSpecialties ORDER BY SpecialtyCode,SpecialtyName -- CHECK 1st
FROM eVips_chgcv.dbo.vwPractitionerDemographics AS vpd
	JOIN eVips_chgcv.dbo.vwPractitionerProducts AS vpp ON vpd.PractitionerID = vpp.PractitionerID -- aka cert_provider
		-- AND vpp.ProductID = vpps.ProductID -- aka cert_provider
	JOIN eVips_chgcv.dbo.vwPractitionerProductSpecialties AS vpps ON vpp.PractitionerProductRecID = vpps.PractitionerProductRecID
		LEFT JOIN eVips_chgcv.dbo.vwPractitionerSpecialties AS vps ON vpd.PractitionerID = vps.PractitionerID	
			AND vpps.specialtycode = vps.specialtycode
		LEFT JOIN ( -- INITIATE ...
		SELECT DISTINCT ProviderID,TableName,EntityCode,EntityName,EntityTypeCode,EntityTypeName 
		FROM eVips_chgcv.dbo.vwEntityAssignments 
		WHERE UPPER(LTRIM(RTRIM(ISNULL(TableName,'')))) LIKE '%PRACTI%'
		) -- CONCLUDE ... 
		AS vea ON vpd.PractitionerID = vea.ProviderID --ProviderID = PractitionerID WHERE UPPER(LTRIM(RTRIM(vea.TableName))) LIKE '%Practit%' OR  ProviderID = PracticeID WHERE UPPER(LTRIM(RTRIM(vea.TableName))) LIKE '%Practice%'
	JOIN ( -- INITIATE ...
	SELECT DISTINCT vpprovloc.PractitionerID,vpprovloc.PracticeID,vpprovloc.LocationID,vpprovloc.AddressID,vpprovloc.LastName,vpprovloc.FirstName,vpprovloc.Archived,vpprovloc.LocationName,vpprovloc.NationalProviderID,vpprovloc.LocationNotes,vpprovloc.PracticeTypeName,vpprovloc.ProviderNumber,vpprovloc.website,vpfacloc.LineNumber1,vpfacloc.LineNumber2,vpfacloc.LineNumber3,vpfacloc.City,vpfacloc.[State],vpfacloc.ZipCode,vpfacloc.LocationTypeName 
	FROM eVips_chgcv.dbo.vwPractitionerLocations AS vpprovloc
		JOIN eVips_chgcv.dbo.vwPracticeLocations AS vpfacloc ON vpprovloc.PracticeID = vpfacloc.PracticeID
			AND vpprovloc.LocationID = vpfacloc.LocationID 
		WHERE UPPER(LTRIM(RTRIM(ISNULL(vpfacloc.LocationTypeName,'')))) LIKE '%PRACTI%'
		) -- CONCLUDE ...
		AS vploc ON vpd.PractitionerID = vploc.PractitionerID
		AND vpp.PracticeID = vploc.PracticeID
		AND vpp.LocationID = vploc.LocationID
		-- AND vpp.AddressID = vploc.AddressID
	JOIN eVips_chgcv.dbo.vwPracticeLocations AS vpracloc ON vpp.practiceid = vpracloc.practiceid  --SPECIAL ADD - ON JOIN (s)
		AND vpp.Locationid = vpracloc.Locationid --SPECIAL ADD - ON JOIN (s)
		LEFT JOIN INFORMATICS.dbo.ZIP_CODES AS zip ON CASE
WHEN SUBSTRING(LTRIM(RTRIM(vploc.ZipCode)),1,1) = '0'
THEN '0'+ SUBSTRING(LTRIM(RTRIM(vploc.ZipCode)),2,4)
WHEN SUBSTRING(LTRIM(RTRIM(vploc.ZipCode)),1,1) = '00'
THEN '00'+ SUBSTRING(LTRIM(RTRIM(vploc.ZipCode)),3,3)
ELSE  SUBSTRING(LTRIM(RTRIM(vploc.ZipCode)),1,5) 
END COLLATE DATABASE_DEFAULT = SUBSTRING(LTRIM(RTRIM(zip.ZipCode)),1,5) COLLATE DATABASE_DEFAULT -- FORMERLY SQL01.DEV_DB.dbo.ZIP_CODES
		LEFT JOIN ( -- INITIATE ...
		SELECT DISTINCT zipcode,city,county,RegionTypeName 
		FROM eVips_chgcv.dbo.vwzipcodes 
		WHERE UPPER(LTRIM(RTRIM(ISNULL(county,'')))) LIKE '%SAN%DIEGO%'
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
		LEFT JOIN ( -- INITIATE ...
		SELECT DISTINCT r.FieldName,r.DisplayName,s.specialtycode,s.specialtyName AS [eVIPS_Specialty],r.Value AS [TIMELYACCESS_Profile] 
		FROM evips_chgcv.dbo.vwReferenceUserFields AS r 
			LEFT JOIN evips_chgcv.dbo.vwSpecialties AS s ON r.ParentRecID  = s.specialtyid
		WHERE r.tablename IN ('Specialties')
			AND r.fieldName IN ('Specialty Grouping - Timely Access')
			) -- CONCLUDE ...
		AS profile ON CASE
WHEN vpps.SpecialtyCode IS NULL
THEN UPPER(LTRIM(RTRIM(vpps.SpecialtyName)))
ELSE UPPER(LTRIM(RTRIM(vpps.SpecialtyCode)))
END = UPPER(LTRIM(RTRIM(ISNULL(profile.specialtycode,''))))-- AS [DefineOTH_SPE]

WHERE vpd.NationalProviderID IN ('1780188979','1194130484')

-- WHERE ( -- INITIATE ... REGULAR PROVIDER 'IN NETWORK / IN DIRECTORY LOGIC'
-- UPPER(LTRIM(RTRIM(ISNULL(vpps.InDirectory,'')))) LIKE @INDIR --SET @INDIR ='Y'--REMOVE FILTER FOR JOSEPH / TIMELYACCESS HBP(s)... '%' OR 'Y'  OR 'N'--SUBSTRING(UPPER(LTRIM(RTRIM(cert_provider.in_directory))),1,1) LIKE @INDIR --see 'LTRIM(RTRIM(mcred.retrieve_list)) LIKE '%CN%V%'
	-- AND UPPER(LTRIM(RTRIM(vpd.Archived))) IN ('N') --WITH eVIPS LOGICAL BINARY OPTION(s) IN USE •	Must not be archived 
	-- AND UPPER(LTRIM(RTRIM(vpps.Archived))) IN ('N') -- ADD ON per MEETING ;WITH YOUNG LADY LAURA, SC & HL ON 20171226
	-- AND UPPER(LTRIM(RTRIM(vploc.Archived))) IN ('N') --WITH eVIPS LOGICAL BINARY OPTION(s) IN USE •	Must not be archived
	-- AND UPPER(LTRIM(RTRIM(vpracloc.Archived))) IN ('N')
	-- AND UPPER(LTRIM(RTRIM(ISNULL(vpd.PractitionerStatus,'')))) IN ('ACTIVE','') --•	Overall Status must be Active
	-- AND UPPER(LTRIM(RTRIM(vpp.Archived))) IN ('N') --WITH eVIPS LOGICAL BINARY OPTION(s) IN USE •	Must not be archived 
	-- ) -- CONCLUDE ... REGULAR PROVIDER 'IN NETWORK / IN DIRECTORY LOGIC'
	-- AND ISNULL(vpp.StatusTypeName,'') IN ('Y','','Active','Active - Per Diem') --•	Plan Status must be: ‘Active’ or ‘Active Per Diem’ or Active VIP for a Product Name (CMC or MEDICAL):







JAH DEVELOP 'PROVDIR_PCP' - see 'PCP_CHAPTER_FIXes_yyyymmdd.sql'
-- ==========================================================
	-- TIMELYACCESS() SETUP [TABLE](s)--
-- ==========================================================
------------------------------------------------------------------------------------------------------------------------
	-- Error Trapping: Check If Permanent Table(s) Already Exist(s) And Drop If Applicable --
------------------------------------------------------------------------------------------------------------------------
TRUNCATE TABLE
-- SELECT TOP 100 * --CHECK 1st
-- SELECT DISTINCT --CHECK 1st
INFORMATICS.dbo.TimelyAccessPCP

INSERT INTO INFORMATICS.dbo.TimelyAccessPCP -- ([FIELD])
SELECT DISTINCT *
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT plan_type,DefineOTH_SPE,* -- CHECK 1st
-- SELECT DISTINCT [DEGREE DESCRIPTION] -- CHECK 1st
-- SELECT DISTINCT plan_type -- CHECK 1st
-- SELECT DISTINCT DefineOTH_SPE -- CHECK 1st
FROM ##INNETWORK_PROV
WHERE (plan_type IS NULL --PROV(s) ;WITH() ,UPPER(LTRIM(RTRIM(vpp.ProductTypeCode))) AS [plan_type]
	OR UPPER(LTRIM(RTRIM(plan_type))) LIKE '%PCP%') --'%PRIM%CARE%PROV%' -- = 'PCP' --Cert_provider.plan_type has one of the following values: 'PCP','SPE','AHP',and 'HBP' or starts with '%NPMP' - LIKE '%%'
		AND UPPER(LTRIM(RTRIM(DefineOTH_SPE))) IN ('FAM','GNP','INM','OB','OBG','GYN','PED')
--ORDER BY DefineOTH_SPE

x WHERE (plan_type IS NULL --PROV(s) ;WITH() ,UPPER(LTRIM(RTRIM(vpp.ProductTypeCode))) AS [plan_type]
	OR UPPER(LTRIM(RTRIM(plan_type))) LIKE '%PCP%') --'%PRIM%CARE%PROV%' -- = 'PCP' --Cert_provider.plan_type has one of the following values: 'PCP','SPE','AHP',and 'HBP' or starts with '%NPMP' - LIKE '%%'
		AND UPPER(LTRIM(RTRIM(DefineOTH_SPE))) IN ('FAM','GNP','INM','OB','OBG','GYN','PED','FAMP','GNPP','INMP','OBP','OBGP','GYNP') -- SUFFIX OF '...P' ADDED TO SPECIALTY TO FCAILITATE DHCS Specialties to split FOR NETWORK REPORTING
-- ORDER BY DefineOTH_SPE

/* JAH DEVELOP 'PROVDIR_PCP' - see 'PCP_CHAPTER_FIXes_yyyymmdd.sql'
x WHERE (plan_type IS NULL --PROV(s) ;WITH() ,UPPER(LTRIM(RTRIM(vpp.ProductTypeCode))) AS [plan_type]
	OR UPPER(LTRIM(RTRIM(plan_type))) LIKE '%PCP%') --'%PRIM%CARE%PROV%' -- = 'PCP' --Cert_provider.plan_type has one of the following values: 'PCP','SPE','AHP',and 'HBP' or starts with '%NPMP' - LIKE '%%'
		AND UPPER(LTRIM(RTRIM(DefineOTH_SPE))) IN ('FAM','GNP','INM','OB','OBG','GYN','PED','FAMP','GNPP','INMP','OBP','OBGP','GYNP') -- SUFFIX OF '...P' ADDED TO SPECIALTY TO FCAILITATE DHCS Specialties to split FOR NETWORK REPORTING
-- ORDER BY DefineOTH_SPE */







JAH UPDATE 'FOOTNOTE' - MEDI-CAL ONLY!!! SIX (6) PROVIDER CHAPTER(s)
/* x For help picking a doctor and verifying the availability of selected providers, please call Member Services at 1-800-224-7766. */
@ After Hours Telephone Number is the same as Daytime Number For help picking a doctor and verifying the availability of selected providers, please call Member Services at 1-800-224-7766.
@ After Hours Telephone Number is the same as Daytime Number - For help picking a doctor and verifying the availability of selected providers, please call Member Services at 1-800-224-7766.

,UPPER(LTRIM(RTRIM(vploc.PracticeTypeName))) AS [entity_type]
,[entity_type] AS PracticeTypeName







JAH 'TRUNCATE v. DELETE' - per CONVERSATION ;WITH SIR EVAN ON 20190808

TRUNCATE TABLE
-- SELECT TOP 100 * --CHECK 1st
-- SELECT DISTINCT --CHECK 1st
INFORMATICS.dbo.TimelyAccessPCP

INSERT INTO INFORMATICS.dbo.TimelyAccessPCP -- ([FIELD])
SELECT DISTINCT *
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM ##INNETWORK_PROV

TRUNCATE TABLE
-- SELECT TOP 100 * --CHECK 1st
-- SELECT DISTINCT --CHECK 1st
INFORMATICS.dbo.TimelyAccessPCP_Extender

INSERT INTO INFORMATICS.dbo.TimelyAccessPCP_Extender -- ([FIELD])
SELECT DISTINCT *
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM ##INNETWORK_PROV

TRUNCATE TABLE
-- SELECT TOP 100 * --CHECK 1st
-- SELECT DISTINCT --CHECK 1st
INFORMATICS.dbo.TimelyAccessSPE

INSERT INTO INFORMATICS.dbo.TimelyAccessSPE -- ([FIELD])
SELECT DISTINCT *
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM ##INNETWORK_PROV

TRUNCATE TABLE
-- SELECT TOP 100 * --CHECK 1st
-- SELECT DISTINCT --CHECK 1st
INFORMATICS.dbo.TimelyAccessFAC

INSERT INTO INFORMATICS.dbo.TimelyAccessFAC -- ([FIELD])
SELECT DISTINCT *
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM ##INNETWORK_FAC

TRUNCATE TABLE
-- SELECT TOP 100 * --CHECK 1st
-- SELECT DISTINCT --CHECK 1st
INFORMATICS.dbo.TimelyAccessCLINIC

INSERT INTO INFORMATICS.dbo.TimelyAccessCLINIC -- ([FIELD])
SELECT DISTINCT *
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM ##INNETWORK_FAC

TRUNCATE TABLE
-- SELECT TOP 100 * --CHECK 1st
-- SELECT DISTINCT --CHECK 1st
INFORMATICS.dbo.TimelyAccessCLINICCMC

INSERT INTO INFORMATICS.dbo.TimelyAccessCLINICCMC -- ([FIELD])
SELECT DISTINCT *
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM INFORMATICS.dbo.TimelyAccessCLINIC

TRUNCATE TABLE
-- SELECT TOP 100 * --CHECK 1st
-- SELECT DISTINCT --CHECK 1st
INFORMATICS.dbo.TimelyAccessPHARM

INSERT INTO INFORMATICS.dbo.TimelyAccessPHARM -- ([FIELD])
SELECT DISTINCT *
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM ##INNETWORK_FAC







JAH 'SIX (6) PROVIDER CHAPTER(s)' - NEW SANATOR

--,UPPER(LTRIM(RTRIM(vp.LegalName))) AS [DBA]
,UPPER(LTRIM(RTRIM(vp.PracticeID))) AS [DBAPracticeID]
,UPPER(LTRIM(RTRIM(vp.PracticeName))) AS [DBA]

INTO ##INNETWORK_FAC
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT  vlp.Focus,vlsfocus.Code1,vlsfocus.Code2,vp.Archived,vp.PracticeStatus,vp.ApplicationStatus,vpl.Archived,vpl.LocationTypeName,vp.PracticeTypeName,* -- CHECK 1st
-- SELECT * FROM eVips_chgcv.dbo.vwPracticeLocations -- CHECK 1st
-- SELECT DISTINCT PracticeTypeName FROM eVips_chgcv.dbo.vwPracticeLocations -- CHECK 1st UPPER(LTRIM(RTRIM(vpl.PracticeTypeName))) AS [Type of Service]
-- SELECT * FROM eVips_chgcv.dbo.vwEntityAssignments WHERE UPPER(LTRIM(RTRIM(TableName))) LIKE '%Practice%' AND UPPER(LTRIM(RTRIM(EntityName))) LIKE '%MED%IMPA%' -- CHECK 1st
FROM eVips_chgcv.dbo.vwPractices AS vp

,UPPER(LTRIM(RTRIM(vpp.PracticeID))) AS [DBAPracticeID]
,UPPER(LTRIM(RTRIM(vpp.PracticeName))) AS [DBA

INTO ##INNETWORK_PROV
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT * FROM INFORMATICS.dbo.ZIP_CODES -- CHECK 1st
-- SELECT DISTINCT SpecialtyCode,SpecialtyName FROM eVips_chgcv.dbo.vwPractitionerSpecialties ORDER BY SpecialtyCode,SpecialtyName -- CHECK 1st
FROM eVips_chgcv.dbo.vwPractitionerDemographics AS vpd
	JOIN eVips_chgcv.dbo.vwPractitionerProducts AS vpp ON vpp.PractitionerID = vpd.PractitionerID --aka cert_provider

x CHARINDEX() FIND() SEARCH() 'INTO INFORMATICS.dbo.PROVDIR_','INTO INFORMATICS.dbo.SANATOR_PROVDIR_'

					SELECT DISTINCT UPPER(LTRIM(RTRIM(vpp.PracticeID))) AS [DBAPracticeID]
					,UPPER(LTRIM(RTRIM(vpp.PracticeName))) AS [DBA]
					FROM eVips_chgcv.dbo.vwPractitionerProducts AS vpp

x GO TO ;WITH() 'CTRL + G' #4514

,pcp.[DBAPracticeID],pcp.[DBA]
,spe.[DBAPracticeID],spe.[DBA]







JAH 'MANUAL PAGE ENTRY' - SELECT 'BI-ANNUAL MS EXCEL PROVIDER DIRECTORY OUTPUT REVIEW' AS [MESSAGE(s)],* FROM ##MSEXCEL_PROVDIR ORDER BY CHAPTER_SEQUENCE,CityIs,[Zip Code],SPEC,INDEXNM,AddressIs
x CHARINDEX() FIND() SEARCH() 'You will find' TO LOCATE EACH CHAPTER PAGE # THEN APPLY Fx
x CREATE THREE (3) COLUMN ONE (1) FOR FINAL PAGE# ONE (1) FOR TWO (2) ENTRY PER PAGE AND ONE (1) FOR THREE (3) ENTRY PER PAGE

					[COL 2] = /* eg. IN CELL 'C1' HARDCODE CHAPTER STARTING PAGE# '##'
					eg. IN CELL 'C2' ENTER '=C1'
					eg. IN CELL 'C3' ENTER '=C2+1' */
					
					eg. IN CELL 'C3' ENTER '=C2+1'
					eg. IN CELL 'C4' ENTER '=C3'
					
					[COL 3] = /* eg. IN CELL 'C1' HARDCODE CHAPTER STARTING PAGE# '##'
					eg. IN CELL 'C2' ENTER '=C1'
					eg. IN CELL 'C3' ENTER '=C2'
					eg. IN CELL 'C4' ENTER '=C3+1' */
					
					eg. IN CELL 'C4' ENTER '=C3+1'
					eg. IN CELL 'C5' ENTER '=C4'
					eg. IN CELL 'C6' ENTER '=C5'					
					
			
x see [CHAPTER_SEQUENCE]
1	Primary Care Physician
2	Specialists
3	General Acute Hospitals
4	LONG TERM ACUTE CARE HOSPITALS
5	Skilled Nursing Facilities
6	Nursing Facilities - Residential Care
7	Hospice
8	Nursing Facilities - Inpatient Rehabilitation
9	Mental Health Providers
10	Community Based Adult Services
12	Home Health Care
14	Allied Health Providers 
15	Non-Physician Medical Practitioners
16	Ambulatory Surgery Centers
17	Diagnostic Centers
18	Clinical Laboratories
19	Dialysis Centers
20	Birthing Centers
21	Urgent Care Centers
22	Retail Clinics - MinuteClinic
24	Pharmacy
25	Community Health Centers
26	Vision Service Plan Providers

-- =================================================================
	-- MS EXCEL PROVIDER DIRECTORY REVIEW--
-- =================================================================
-- x IN SQL07.eVips_chgcv.dbo...
-- x see 'DERIVED_MSEXCEL_PROVDIR_'...sql
-- x [NOTE(s)] - Msg 1033, Level 15, State 1, Line 19 The ORDER BY clause is invalid in views, inline functions, DERIVED() tables, subqueries, and common table expressions, unless TOP or FOR XML is also specified.

-----------------------------------------------------------------------------------------------------------------------------
	-- Error Trapping: Check If Permanent Table(s) Already Exist(s) And Drop If Applicable --
-----------------------------------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS ##MSEXCEL_PROVDIR -- SQL Server 2016 and later -- DYNAMIC tmp OR STATIC [TABLE] #TableName is a local temporary table visible only in the current session; ##TableName is a GLOBAL temporary table visible to all sessions IN ('TempDB')







JAH 'ADD CHAPTER'(s) - HOSPITAL(s)
x ON 20190528

DROP TABLE IF EXISTS INFORMATICS.dbo.PROVDIR_HOSADDITIONAL -- SQL Server 2016 and later -- DYNAMIC tmp OR STATIC [TABLE] #TableName is a local temporary table visible only in the current session; ##TableName is a GLOBAL temporary table visible to all sessions IN ('TempDB')

SELECT * INTO INFORMATICS.dbo.PROVDIR_HOSADDITIONAL FROM INFORMATICS.dbo.PROVDIR_HOSMH -- 'Mental Health Hospitals' CONTRACTUALLY FOR CMC(s) ONLY!!!

SELECT * FROM INFORMATICS.dbo.PROVDIR_HOSLTACH -- 'Long Term Acute Care Hospitals'
SELECT * FROM INFORMATICS.dbo.PROVDIR_HOSMH -- 'Long Term Acute Care Hospitals'

,'Mental Health Hospitals' AS [CHAPTER_NAME] -- ADDED ON 20190528 FORMERLY PART OF PROVDIR_HOSADDITIONAL
,'Mental Health Hospitals' AS [PROVIDER_TYPE] -- ADDED ON 20190528 FORMERLY PART OF PROVDIR_HOSADDITIONAL
,'Long Term Acute Care Hospitals'AS [CHAPTER_NAME] -- ADDED ON 20190528 FORMERLY PART OF PROVDIR_HOSADDITIONAL
,'Long Term Acute Care Hospitals' AS [PROVIDER_TYPE] -- ADDED ON 20190528 FORMERLY PART OF PROVDIR_HOSADDITIONAL

		/* SELECT * FROM INFORMATICS.dbo.PROVDIR_HOS --FAC(s) */
		SELECT * FROM INFORMATICS.dbo.PROVDIR_HOSGENERALACUTE --HOSGAH
		/* SELECT * FROM INFORMATICS.dbo.PROVDIR_HOSADDITIONAL -- HOSADD FOR ,CAST('Mental Health & Long Term Acute Care Hospitals' AS nvarchar(255)) AS [CHAPTER_NAME] */
		SELECT * FROM INFORMATICS.dbo.PROVDIR_HOSMH -- 'Mental Health & Long Term Acute Care Hospitals' CONTRACTUALLY FOR CMC(s) ONLY!!!
		SELECT * FROM INFORMATICS.dbo.PROVDIR_HOSLTACH -- 'Long Term Acute Care Hospitals'

INTO [TABLENAME]
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT HOSPITAL_IDENTIFICATION,[Participating Network],ISNULL(CAST(spe.HospitalName AS nvarchar(100)),'')+' '+ISNULL(CAST(spe.HOSPabbrev AS nvarchar(100)),'')+' ID# '+ISNULL(CAST(spe.provider_no AS nvarchar(25)),'') COLLATE DATABASE_DEFAULT AS [TESTING],HOSPITAL_IDENTIFICATION -- CHECK 1st
FROM INFORMATICS.dbo.TimelyAccessFAC AS spe
WHERE ( -- INITIATE ... A
[Participating Network] IN ('CL1')
	-- AND UPPER(LTRIM(RTRIM(ISNULL(spe.[Type of Service FOCUS],'')))) NOT LIKE '%GAH%'
	AND UPPER(LTRIM(RTRIM(ISNULL(spe.[Type of Service FOCUS],'')))) LIKE  '%LTACH%' --  ,UPPER(LTRIM(RTRIM(vlp.focus))) AS [Type of Service FOCUS] per NETWORK REPORT DISCUSSION NO MH BENEFIT FOR MEDI-CAL
	AND spe.plan_type = 'FACILITY'
	AND spe.[vlpSTATUSTYPENAME] LIKE 'ACTIVE%' --•	ADD ON TO FAC per PROVDIR meeting ON 20171226
) -- CONCLUDE ... A
OR ( -- INITIATE ... B
[Participating Network] IN ('CMC')
	-- AND UPPER(LTRIM(RTRIM(ISNULL(spe.[Type of Service FOCUS],'')))) NOT LIKE '%GAH%'
	AND (UPPER(LTRIM(RTRIM(ISNULL(spe.[Type of Service FOCUS],'')))) LIKE '%MH%' --  ,UPPER(LTRIM(RTRIM(vlp.focus))) AS [Type of Service FOCUS]
		OR UPPER(LTRIM(RTRIM(ISNULL(spe.[Type of Service FOCUS],'')))) LIKE  '%LTACH%') --  ,UPPER(LTRIM(RTRIM(vlp.focus))) AS [Type of Service FOCUS] per NETWORK REPORT DISCUSSION NO MH BENEFIT FOR MEDI-CAL
	AND spe.plan_type = 'FACILITY'
	AND spe.[vlpSTATUSTYPENAME] LIKE 'ACTIVE%' --•	ADD ON TO FAC per PROVDIR meeting ON 20171226
) -- CONCLUDE ... B
/* OR UPPER(LTRIM(RTRIM(spe.NPIis))) IN ('1063589620','1205816931','1457321317','1598722027','1639172133','1659354173','1962438200') --ATTEMPT TO MIMIC VIP LOGIC ...  */		







JAH 'SANATOR' - ADDITIONAL HOSPPRIV LOGIC
x USE 1316913833 (PETER H BELOTT MD) AS eg.
					see 'SANATOR_eVIPS_PROVDIR_STEP03_VIP_20190515.sql'

x [FIELD]: 'SHARP GROSSMONT HOSPITAL, ALVARADO HOSPITAL MEDICAL CENTER, SHARP CHULA VISTA MEDICAL CENTER, SHARP MEMORIAL HOSPITAL' AND 'Scripps Mercy Hospital - Hillcrest'
x Please add these to Sanator’s weekly file only.

Affiliate - 'AFFIL'
Applicant - 'APP','APPLICANT'
Consult - 'CONSULT'

					SELECT DISTINCT PositionTypeCode,PositionTypeName FROM eVips_chgcv.dbo.vwPractitionerAppointments ORDER BY PositionTypeCode,PositionTypeName

WHERE (UPPER(LTRIM(RTRIM(vpa.PositionTypeCode))) IN ('AFFIL','APP','APPLICANT','CONSULT','ACIVE','ACTIVE','ADMIT','ATTEND','SENIOR',' ASSOC','COURTESY','PROV','TEMP','HONORARY') 
	OR UPPER(LTRIM(RTRIM(vpa.PositionTypeName))) IN ('AFFIL','APP','APPLICANT','CONSULT','ACIVE','ACTIVE','ADMIT','ATTEND','SENIOR',' ASSOC','COURTESY','PROV','TEMP','HONORARY') )  -- UPDATE  FOR SANATOR FILE ONLY!!! ON 20190515 per MS. SANDRA '...Please add these to Sanator’s weekly file only....' -- per S. Coleman via email ON 20160712 (2)	Only show active hospital affiliations with the attached (in red) statuses for practitioners.  Dr. William Pitt CRV San Diego 92120 shows 4 hospitals.  GH & SMHH are archived and should not show.)

SELECT TOP 100 InstitutionName,* -- CHECK 1st
-- SELECT DISTINCT PositionTypeCode,PositionTypeCode -- CHECK 1st
FROM eVips_chgcv.dbo.vwPractitionerDemographics AS vpd
	JOIN eVips_chgcv.dbo.vwPractitionerAppointments AS vpa ON  vpa.PractitionerID = vpd.PractitionerID --DIRECT PRIVILEGE(s)
WHERE UPPER(LTRIM(RTRIM(vpd.NationalProviderID))) IN ('1316913833')
	AND (UPPER(LTRIM(RTRIM(vpa.PositionTypeCode))) IN ('AFFIL','APP','APPLICANT','CONSULT','ACIVE','ACTIVE','ADMIT','ATTEND','SENIOR',' ASSOC','COURTESY','PROV','TEMP','HONORARY') 
		OR UPPER(LTRIM(RTRIM(vpa.PositionTypeName))) IN ('AFFIL','APP','APPLICANT','CONSULT','ACIVE','ACTIVE','ADMIT','ATTEND','SENIOR',' ASSOC','COURTESY','PROV','TEMP','HONORARY') )  -- UPDATE  FOR SANATOR FILE ONLY!!! ON 20190515 per MS. SANDRA '...Please add these to Sanator’s weekly file only....' -- per S. Coleman via email ON 20160712 (2)	Only show active hospital affiliations with the attached (in red) statuses for practitioners.  Dr. William Pitt CRV San Diego 92120 shows 4 hospitals.  GH & SMHH are archived and should not show.)
	AND UPPER(LTRIM(RTRIM(ISNULL(vpa.Archived,'')))) IN ('N')  --Per S. Coleman email ON 20171229 '...Some archived Hospital privileges are showing: ...'
	AND UPPER(LTRIM(RTRIM(vpa.InstitutionName))) NOT LIKE '%INACT%'
	AND UPPER(LTRIM(RTRIM(vpa.InstitutionName))) NOT LIKE '%PEND%'
	AND UPPER(LTRIM(RTRIM(vpa.InstitutionName))) NOT LIKE '%KAISER%'
	AND UPPER(LTRIM(RTRIM(vpa.InstitutionName))) NOT LIKE '%MENIFEE%'
	AND UPPER(LTRIM(RTRIM(vpa.InstitutionName))) NOT LIKE '%NAVAL%'
	AND UPPER(LTRIM(RTRIM(vpa.InstitutionName))) NOT LIKE '%V%A%SAN%DIEGO'
	AND UPPER(LTRIM(RTRIM(vpa.InstitutionName))) NOT LIKE '%NO%PRIV%COV%AGREE%'
ORDER BY UPPER(LTRIM(RTRIM(vpa.InstitutionName))) -- ADD ON / SORT REQUEST FROM PROVDIR MEETING ON 20180731 see ,UPPER(LTRIM(RTRIM(vpa.InstitutionName))) AS [HOSPNM]	

-----------------------------------------------------------------------------------------------------------------------
	-- Error Trapping: Check If Permanent Table(s) Already Exist(s) And Drop If Applicable --
------------------------------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS ##HOSPpriv -- SQL Server 2016 and later -- DYNAMIC tmp OR STATIC [TABLE] #TableName is a local temporary table visible only in the current session; ##TableName is a GLOBAL temporary table visible to all sessions IN ('TempDB')

SELECT DISTINCT 'N' AS [USE_HOSPITALIST]
,UPPER(LTRIM(RTRIM(vpd.NationalProviderID))) AS ORIGINALnpi
,UPPER(LTRIM(RTRIM(CAST(vpd.LastName AS nvarchar(255))))) AS ORIGINALlnm
,UPPER(LTRIM(RTRIM(CAST(vpd.FirstName AS nvarchar(255))))) AS ORIGINALfnm
,UPPER(LTRIM(RTRIM(vpd.PractitionerID))) AS ORIGINALlkup
,UPPER(LTRIM(RTRIM(vpd.PractitionerID))) AS [lookup_key]
,UPPER(LTRIM(RTRIM(vpd.PractitionerID))) AS lky
,CAST('NA' AS nvarchar(255)) AS [COVERlkup ] -- DIRECT PRIVILEGE(s)
,CAST('NA' AS nvarchar(255)) AS [COVERNM] -- DIRECT PRIVILEGE(s)
,CAST('NA' AS nvarchar(255)) AS ALTlky --DIRECT PRIVILEGE(s)
,UPPER(LTRIM(RTRIM(vpa.InstitutionID))) AS [HOSP_lookup_key]
,CAST(NULL AS nvarchar(25)) AS HOSPNPI --QUPD
,UPPER(LTRIM(RTRIM(vpa.InstitutionName))) AS [HOSPNM]
,UPPER(LTRIM(RTRIM(vpa.InstitutionName))) AS 'HOSP_name'
,CAST(NULL AS nvarchar(25)) AS [HOSPITAL_ID] -- QUPD the QNXT provid
,CAST(NULL AS nvarchar(5)) AS [HOSPABBREV] -- QUPD ;WITH() USE EITHER #WCE [ABBREV] LOGIC
,CAST(NULL AS nvarchar(25)) AS [NPIhospital] -- QUPD
,CAST(NULL AS nvarchar(25)) AS [CA_License] -- QUPD
,UPPER(LTRIM(RTRIM(vpa.InstitutionName))) AS [company]
,CAST(NULL AS nvarchar(5)) AS [providence] -- QUPD ;WITH() USE EITHER #WCE [ABBREV] LOGIC
INTO ##HOSPpriv
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM eVips_chgcv.dbo.vwPractitionerDemographics AS vpd
	JOIN eVips_chgcv.dbo.vwPractitionerAppointments AS vpa ON  vpa.PractitionerID = vpd.PractitionerID --DIRECT PRIVILEGE(s)
WHERE (UPPER(LTRIM(RTRIM(vpa.PositionTypeCode))) IN ('ACIVE','ACTIVE','ADMIT','ATTEND','SENIOR',' ASSOC','COURTESY','PROV','TEMP','HONORARY') 
	OR UPPER(LTRIM(RTRIM(vpa.PositionTypeName))) IN ('ACIVE','ACTIVE','ADMIT','ATTEND','SENIOR',' ASSOC','COURTESY','PROV','TEMP','HONORARY'))  -- per S. Coleman via email ON 20160712 (2)	Only show active hospital affiliations with the attached (in red) statuses for practitioners.  Dr. William Pitt CRV San Diego 92120 shows 4 hospitals.  GH & SMHH are archived and should not show.)
	AND UPPER(LTRIM(RTRIM(ISNULL(vpa.Archived,'')))) IN ('N')  --Per S. Coleman email ON 20171229 '...Some archived Hospital privileges are showing: ...'
		AND UPPER(LTRIM(RTRIM(vpa.InstitutionName))) NOT LIKE '%INACT%'
		AND UPPER(LTRIM(RTRIM(vpa.InstitutionName))) NOT LIKE '%PEND%'
		AND UPPER(LTRIM(RTRIM(vpa.InstitutionName))) NOT LIKE '%KAISER%'
		AND UPPER(LTRIM(RTRIM(vpa.InstitutionName))) NOT LIKE '%MENIFEE%'
		AND UPPER(LTRIM(RTRIM(vpa.InstitutionName))) NOT LIKE '%NAVAL%'
		AND UPPER(LTRIM(RTRIM(vpa.InstitutionName))) NOT LIKE '%V%A%SAN%DIEGO'
		AND UPPER(LTRIM(RTRIM(vpa.InstitutionName))) NOT LIKE '%NO%PRIV%COV%AGREE%'
ORDER BY UPPER(LTRIM(RTRIM(vpa.InstitutionName))) -- ADD ON / SORT REQUEST FROM PROVDIR MEETING ON 20180731 see ,UPPER(LTRIM(RTRIM(vpa.InstitutionName))) AS [HOSPNM]







JAH 'PROVDIR_HOSADDITIONAL' - ALTER() STUFF()
x CHECK

SELECT * FROM ##INNETWORK_FAC WHERE [FacilityName] LIKE '%PROMISE%'

SELECT TOP 100 vp.Archived,vp.PracticeStatus,vpl.Archived,UPPER(LTRIM(RTRIM(vpl.LocationName))) AS [FacilityName]
FROM eVips_chgcv.dbo.vwPractices AS vp
	JOIN eVips_chgcv.dbo.vwPracticeLocations AS vpl ON vpl.PracticeID = vp.PracticeID
WHERE UPPER(LTRIM(RTRIM(vpl.LocationName))) LIKE '%PROMISE%'

					SELECT * FROM INFORMATICS.dbo.PROVDIR_HOSADDITIONAL

SELECT DISTINCT HOSPITAL_IDENTIFICATION,[Participating Network],ISNULL(CAST(spe.HospitalName AS nvarchar(100)),'')+' '+ISNULL(CAST(spe.HOSPabbrev AS nvarchar(100)),'')+' ID# '+ISNULL(CAST(spe.provider_no AS nvarchar(25)),'') COLLATE DATABASE_DEFAULT AS [TESTING],HOSPITAL_IDENTIFICATION -- CHECK 1st
FROM INFORMATICS.dbo.TimelyAccessFAC AS spe
WHERE ((UPPER(LTRIM(RTRIM(spe.[Type of Service FOCUS]))) NOT LIKE '%GAH%'
	-- OR spe.[Type of Service FOCUS] IS NULL
) -- CONCLUDE ...
		AND spe.plan_type = 'FACILITY'
		AND spe.[vlpSTATUSTYPENAME] LIKE 'ACTIVE%' --•	ADD ON TO FAC per PROVDIR meeting ON 20171226
) --ATTEMPT TO MIMIC VIP LOGIC ... 		OR UPPER(LTRIM(RTRIM([HOSPITAL_IDENTIFICATION]))) NOT LIKE '%GAH%') --,UPPER(LTRIM(RTRIM(cert_provider.focus))) AS [HOSPITAL_IDENTIFICATION] -- NEED TO SPLIT HOSP TABLE INTO TWO (2) per S. COLEMAN ON 20160628 see 'GAH' General Acute Hospital THEN CHANGE APPLIED BECAUSE VISTAR WAS ALTERED per SCOLEMAN ON 20161013
OR UPPER(LTRIM(RTRIM(spe.NPIis))) IN ('1063589620','1205816931','1457321317','1598722027','1639172133','1659354173','1962438200') --ATTEMPT TO MIMIC VIP LOGIC ... 
ORDER BY [Participating Network],TESTING

SELECT DISTINCT HOSPITAL_IDENTIFICATION,[Participating Network],ISNULL(CAST(spe.HospitalName AS nvarchar(100)),'')+' '+ISNULL(CAST(spe.HOSPabbrev AS nvarchar(100)),'')+' ID# '+ISNULL(CAST(spe.provider_no AS nvarchar(25)),'') COLLATE DATABASE_DEFAULT AS [TESTING],HOSPITAL_IDENTIFICATION -- CHECK 1st
FROM INFORMATICS.dbo.TimelyAccessFAC AS spe
WHERE ( -- INITIATE ... A
[Participating Network] IN ('CL1')
	AND UPPER(LTRIM(RTRIM(ISNULL(spe.[Type of Service FOCUS],'')))) NOT LIKE '%GAH%'
	AND UPPER(LTRIM(RTRIM(ISNULL(spe.[Type of Service FOCUS],'')))) LIKE  '%LTACH%' --  ,UPPER(LTRIM(RTRIM(vlp.focus))) AS [Type of Service FOCUS] per NETWORK REPORT DISCUSSION NO MH BENEFIT FOR MEDI-CAL
	AND spe.plan_type = 'FACILITY'
	AND spe.[vlpSTATUSTYPENAME] LIKE 'ACTIVE%' --•	ADD ON TO FAC per PROVDIR meeting ON 20171226
) -- CONCLUDE ... A
OR ( -- INITIATE ... B
[Participating Network] IN ('CMC')
	AND UPPER(LTRIM(RTRIM(ISNULL(spe.[Type of Service FOCUS],'')))) NOT LIKE '%GAH%'
	AND (UPPER(LTRIM(RTRIM(ISNULL(spe.[Type of Service FOCUS],'')))) LIKE '%MH%' --  ,UPPER(LTRIM(RTRIM(vlp.focus))) AS [Type of Service FOCUS]
		OR UPPER(LTRIM(RTRIM(ISNULL(spe.[Type of Service FOCUS],'')))) LIKE  '%LTACH%') --  ,UPPER(LTRIM(RTRIM(vlp.focus))) AS [Type of Service FOCUS] per NETWORK REPORT DISCUSSION NO MH BENEFIT FOR MEDI-CAL
	AND spe.plan_type = 'FACILITY'
	AND spe.[vlpSTATUSTYPENAME] LIKE 'ACTIVE%' --•	ADD ON TO FAC per PROVDIR meeting ON 20171226
) -- CONCLUDE ... B
/* OR UPPER(LTRIM(RTRIM(spe.NPIis))) IN ('1063589620','1205816931','1457321317','1598722027','1639172133','1659354173','1962438200') --ATTEMPT TO MIMIC VIP LOGIC ...  */
ORDER BY [Participating Network],TESTING

SELECT DISTINCT HOSPITAL_IDENTIFICATION,[Participating Network],ISNULL(CAST(spe.HospitalName AS nvarchar(100)),'')+' '+ISNULL(CAST(spe.HOSPabbrev AS nvarchar(100)),'')+' ID# '+ISNULL(CAST(spe.provider_no AS nvarchar(25)),'') COLLATE DATABASE_DEFAULT AS [TESTING],HOSPITAL_IDENTIFICATION -- CHECK 1st
FROM INFORMATICS.dbo.TimelyAccessFAC AS spe
WHERE ( -- INITIATE ... A
[Participating Network] IN ('CL1')
	--AND UPPER(LTRIM(RTRIM(ISNULL(spe.[Type of Service FOCUS],'')))) NOT LIKE '%GAH%'
	AND UPPER(LTRIM(RTRIM(ISNULL(spe.[Type of Service FOCUS],'')))) LIKE  '%LTACH%' --  ,UPPER(LTRIM(RTRIM(vlp.focus))) AS [Type of Service FOCUS] per NETWORK REPORT DISCUSSION NO MH BENEFIT FOR MEDI-CAL
	AND spe.plan_type = 'FACILITY'
	AND spe.[vlpSTATUSTYPENAME] LIKE 'ACTIVE%' --•	ADD ON TO FAC per PROVDIR meeting ON 20171226
) -- CONCLUDE ... A
OR ( -- INITIATE ... B
[Participating Network] IN ('CMC')
	--AND UPPER(LTRIM(RTRIM(ISNULL(spe.[Type of Service FOCUS],'')))) NOT LIKE '%GAH%'
	AND (UPPER(LTRIM(RTRIM(ISNULL(spe.[Type of Service FOCUS],'')))) LIKE '%MH%' --  ,UPPER(LTRIM(RTRIM(vlp.focus))) AS [Type of Service FOCUS]
		OR UPPER(LTRIM(RTRIM(ISNULL(spe.[Type of Service FOCUS],'')))) LIKE  '%LTACH%') --  ,UPPER(LTRIM(RTRIM(vlp.focus))) AS [Type of Service FOCUS] per NETWORK REPORT DISCUSSION NO MH BENEFIT FOR MEDI-CAL
	AND spe.plan_type = 'FACILITY'
	AND spe.[vlpSTATUSTYPENAME] LIKE 'ACTIVE%' --•	ADD ON TO FAC per PROVDIR meeting ON 20171226
) -- CONCLUDE ... B
/* OR UPPER(LTRIM(RTRIM(spe.NPIis))) IN ('1063589620','1205816931','1457321317','1598722027','1639172133','1659354173','1962438200') --ATTEMPT TO MIMIC VIP LOGIC ...  */
ORDER BY [Participating Network],TESTING

					SELECT FacilityName,HOSPITAL_IDENTIFICATION,*
					FROM INFORMATICS.dbo.TimelyAccessFAC
					WHERE FacilityName LIKE '%PROMISE%'

SELECT PROVNM,HOSPITAL_IDENTIFICATION,*
FROM INFORMATICS.dbo.PROVDIR_HOSADDITIONAL
ORDER BY [Participating Network] -- Mental Health & Long Term Acute Care Hospitals - MH Hospital(s) ARE CMC ONLY!!!







JAH 'LICENSE IN CA ONLY' - EBI E - ID# 2162 IN 399 JEFFERSON RD	PARSIPPANY, NJ 07054
SELECT PROVNM,* FROM INFORMATICS.dbo.PROVDIR_HOSADDITIONAL ORDER BY [Participating Network] -- Mental Health & Long Term Acute Care Hospitals - MH Hospital(s) ARE CMC ONLY!!!
SELECT 'TABLEAU SOURCE [TABLE]' AS [MESSAGE(s)],* FROM INFORMATICS.dbo.FINAL_PROVDIR_CHAPTER_COUNT -- FOR TABLEAU
SELECT * FROM INFORMATICS.dbo.PROVDIR_CHAPTER_COUNT

SELECT PROVNM,HOSPITAL_IDENTIFICATION,* 
FROM INFORMATICS.dbo.PROVDIR_HOSGENERALACUTE
WHERE PROVNM IN ('EBI E - ID# 2162')
ORDER BY [Participating Network] -- Mental Health & Long Term Acute Care Hospitals - MH Hospital(s) ARE CMC ONLY!!!

SELECT PROVNM,HOSPITAL_IDENTIFICATION,* 
DELETE 
FROM INFORMATICS.dbo.PROVDIR_HOSADDITIONAL 
WHERE PROVNM IN ('EBI E - ID# 2162')
ORDER BY [Participating Network] -- Mental Health & Long Term Acute Care Hospitals - MH Hospital(s) ARE CMC ONLY!!!

SELECT PROVNM,HOSPITAL_IDENTIFICATION,* 
FROM INFORMATICS.dbo.PROVDIR_HOSGENERALACUTE
ORDER BY [Participating Network] -- Mental Health & Long Term Acute Care Hospitals - MH Hospital(s) ARE CMC ONLY!!!

SELECT PROVNM,HOSPITAL_IDENTIFICATION,* 
FROM INFORMATICS.dbo.PROVDIR_HOSADDITIONAL 
ORDER BY [Participating Network] -- Mental Health & Long Term Acute Care Hospitals - MH Hospital(s) ARE CMC ONLY!!!

SELECT PROVNM,HOSPITAL_IDENTIFICATION,*
FROM INFORMATICS.dbo.PROVDIR_HOSADDITIONAL
ORDER BY [Participating Network] -- Mental Health & Long Term Acute Care Hospitals - MH Hospital(s) ARE CMC ONLY!!!

SELECT DISTINCT HOSPITAL_IDENTIFICATION,[Participating Network],ISNULL(CAST(spe.HospitalName AS nvarchar(100)),'')+' '+ISNULL(CAST(spe.HOSPabbrev AS nvarchar(100)),'')+' ID# '+ISNULL(CAST(spe.provider_no AS nvarchar(25)),'') COLLATE DATABASE_DEFAULT AS [TESTING],HOSPITAL_IDENTIFICATION -- CHECK 1st
FROM INFORMATICS.dbo.TimelyAccessFAC AS spe
WHERE ( -- INITIATE ... A
[Participating Network] IN ('CL1')
AND UPPER(LTRIM(RTRIM(spe.[Type of Service FOCUS]))) LIKE '%LTACH%' --  ,UPPER(LTRIM(RTRIM(vlp.focus))) AS [Type of Service FOCUS] per NETWORK REPORT DISCUSSION NO MH BENEFIT FOR MEDI-CAL
		AND spe.plan_type = 'FACILITY'
		AND spe.[vlpSTATUSTYPENAME] LIKE 'ACTIVE%' --•	ADD ON TO FAC per PROVDIR meeting ON 20171226
) -- CONCLUDE ... A
OR ( -- INITIATE ... B
[Participating Network] IN ('CMC')
	AND UPPER(LTRIM(RTRIM(spe.[Type of Service FOCUS]))) LIKE '%MH%' --  ,UPPER(LTRIM(RTRIM(vlp.focus))) AS [Type of Service FOCUS]
		OR UPPER(LTRIM(RTRIM(spe.[Type of Service FOCUS]))) LIKE  '%LTACH%' --  ,UPPER(LTRIM(RTRIM(vlp.focus))) AS [Type of Service FOCUS] per NETWORK REPORT DISCUSSION NO MH BENEFIT FOR MEDI-CAL
		AND spe.plan_type = 'FACILITY'
		AND spe.[vlpSTATUSTYPENAME] LIKE 'ACTIVE%' --•	ADD ON TO FAC per PROVDIR meeting ON 20171226
) -- CONCLUDE ... B
/* OR UPPER(LTRIM(RTRIM(spe.NPIis))) IN ('1063589620','1205816931','1457321317','1598722027','1639172133','1659354173','1962438200') --ATTEMPT TO MIMIC VIP LOGIC ...  */
ORDER BY [Participating Network] -- Mental Health & Long Term Acute Care Hospitals - MH Hospital(s) ARE CMC ONLY!!!







JAH 'PROVIDER DIRECTORY MEETING' - ON 20190430
x ADD [CHAPTER_NAME] FIELD TO PROVDIR TABLE(s) - REPLACE SUBSTITUTE
					',CAST(NULL AS nvarchar(255)) AS [CHAPTER_COUNT]' ;WITH() ',CAST(NULL AS nvarchar(255)) AS [CHAPTER_COUNT],CAST('Primary Care Physician' AS nvarchar(255)) AS [CHAPTER_NAME]'







JAH 'PROVDIR MEETING' - CHECK(s)
1841696614 SEAPORT HOSPICE IN 'HOSPICE' EXCLUSIVELY
1265837405 SEAPORT HOME HEALTH IN 'HOME HEALTH CARE' EXCLUSIVELY

,UPPER(LTRIM(RTRIM('Nursing Facilities - Residential Care'))) AS [PROVIDER_TYPE]
INTO INFORMATICS.dbo.PROVDIR_RCF

,'Nursing Facilities - Inpatient Rehabilitation' AS [NOTE(s)]

					SELECT * FROM INFORMATICS.dbo.PROVDIR_HHC WHERE NPIis IN ('1841696614','1265837405')
					SELECT * FROM INFORMATICS.dbo.PROVDIR_HOSPICE WHERE NPIis IN ('1841696614','1265837405')

					SELECT DISTINCT PROVIDER_TYPE FROM INFORMATICS.dbo.PROVDIR_IPREHAB
					SELECT DISTINCT PROVIDER_TYPE FROM INFORMATICS.dbo.PROVDIR_RCF
					
SELECT DISTINCT [AFTERHOURS_PHONE] FROM INFORMATICS.dbo.PROVDIR_PCP
UNION -- VERTICAL() STACK DISTINCT()
SELECT DISTINCT [AFTERHOURS_PHONE] FROM INFORMATICS.dbo.PROVDIR_SPE
UNION -- VERTICAL() STACK DISTINCT()
SELECT DISTINCT [AFTERHOURS_PHONE] FROM INFORMATICS.dbo.PROVDIR_MH
UNION -- VERTICAL() STACK DISTINCT()
SELECT DISTINCT [AFTERHOURS_PHONE] FROM INFORMATICS.dbo.PROVDIR_AHP
UNION -- VERTICAL() STACK DISTINCT()
SELECT DISTINCT [AFTERHOURS_PHONE] FROM INFORMATICS.dbo.PROVDIR_VSP
UNION -- VERTICAL() STACK DISTINCT()
SELECT DISTINCT [AFTERHOURS_PHONE] FROM INFORMATICS.dbo.PROVDIR_NPMP
UNION -- VERTICAL() STACK DISTINCT()
SELECT DISTINCT [AFTERHOURS_PHONE] FROM INFORMATICS.dbo.PROVDIR_HOS
UNION -- VERTICAL() STACK DISTINCT()
SELECT DISTINCT [AFTERHOURS_PHONE] FROM INFORMATICS.dbo.PROVDIR_HOSGENERALACUTE
UNION -- VERTICAL() STACK DISTINCT()
SELECT DISTINCT [AFTERHOURS_PHONE] FROM INFORMATICS.dbo.PROVDIR_HOSADDITIONAL
UNION -- VERTICAL() STACK DISTINCT()
SELECT DISTINCT [AFTERHOURS_PHONE] FROM INFORMATICS.dbo.PROVDIR_SNF
UNION -- VERTICAL() STACK DISTINCT()
SELECT DISTINCT [AFTERHOURS_PHONE] FROM INFORMATICS.dbo.PROVDIR_IPREHAB
UNION -- VERTICAL() STACK DISTINCT()
SELECT DISTINCT [AFTERHOURS_PHONE] FROM INFORMATICS.dbo.PROVDIR_RCF
UNION -- VERTICAL() STACK DISTINCT()
SELECT DISTINCT [AFTERHOURS_PHONE] FROM INFORMATICS.dbo.PROVDIR_HOSPICE
UNION -- VERTICAL() STACK DISTINCT()
SELECT DISTINCT [AFTERHOURS_PHONE] FROM INFORMATICS.dbo.PROVDIR_CBAS
UNION -- VERTICAL() STACK DISTINCT()
SELECT DISTINCT [AFTERHOURS_PHONE] FROM INFORMATICS.dbo.PROVDIR_BRC
UNION -- VERTICAL() STACK DISTINCT()
SELECT DISTINCT [AFTERHOURS_PHONE] FROM INFORMATICS.dbo.PROVDIR_HDM
UNION -- VERTICAL() STACK DISTINCT()
SELECT DISTINCT [AFTERHOURS_PHONE] FROM INFORMATICS.dbo.PROVDIR_HHC
UNION -- VERTICAL() STACK DISTINCT()
SELECT DISTINCT [AFTERHOURS_PHONE] FROM INFORMATICS.dbo.PROVDIR_IHSS
UNION -- VERTICAL() STACK DISTINCT()
SELECT DISTINCT [AFTERHOURS_PHONE] FROM INFORMATICS.dbo.PROVDIR_ASC
UNION -- VERTICAL() STACK DISTINCT()
SELECT DISTINCT [AFTERHOURS_PHONE] FROM INFORMATICS.dbo.PROVDIR_DXC
UNION -- VERTICAL() STACK DISTINCT()
SELECT DISTINCT [AFTERHOURS_PHONE] FROM INFORMATICS.dbo.PROVDIR_LAB
UNION -- VERTICAL() STACK DISTINCT()
SELECT DISTINCT [AFTERHOURS_PHONE] FROM INFORMATICS.dbo.PROVDIR_DLC
UNION -- VERTICAL() STACK DISTINCT()
SELECT DISTINCT [AFTERHOURS_PHONE] FROM INFORMATICS.dbo.PROVDIR_URC
UNION -- VERTICAL() STACK DISTINCT()
SELECT DISTINCT [AFTERHOURS_PHONE] FROM INFORMATICS.dbo.PROVDIR_MIN
UNION -- VERTICAL() STACK DISTINCT()
SELECT DISTINCT [AFTERHOURS_PHONE] FROM INFORMATICS.dbo.PROVDIR_PPH
UNION -- VERTICAL() STACK DISTINCT()
SELECT DISTINCT [AFTERHOURS_PHONE] FROM INFORMATICS.dbo.PROVDIR_CLINIC
UNION -- VERTICAL() STACK DISTINCT()
SELECT DISTINCT [AFTERHOURS_PHONE] FROM INFORMATICS.dbo.PROVDIR_PHARM
UNION -- VERTICAL() STACK DISTINCT()
SELECT DISTINCT [AFTERHOURS_PHONE] FROM INFORMATICS.dbo.PROVDIR_PHARM_RCP
UNION -- VERTICAL() STACK DISTINCT()
SELECT DISTINCT [AFTERHOURS_PHONE] FROM INFORMATICS.dbo.PROVDIR_PHARM_MO
UNION -- VERTICAL() STACK DISTINCT()
SELECT DISTINCT [AFTERHOURS_PHONE] FROM INFORMATICS.dbo.PROVDIR_PHARM_HI
UNION -- VERTICAL() STACK DISTINCT()
SELECT DISTINCT [AFTERHOURS_PHONE] FROM INFORMATICS.dbo.PROVDIR_PHARM_LTC
UNION -- VERTICAL() STACK DISTINCT()
SELECT DISTINCT [AFTERHOURS_PHONE] FROM INFORMATICS.dbo.PROVDIR_PHARM_ITU
UNION -- VERTICAL() STACK DISTINCT()
SELECT DISTINCT [AFTERHOURS_PHONE] FROM INFORMATICS.dbo.PROVDIR_CHAPTER_COUNT
UNION -- VERTICAL() STACK DISTINCT()
SELECT DISTINCT [AFTERHOURS_PHONE] FROM INFORMATICS.dbo.PROVDIR_CONTRACTING_ENT					







JAH 'PROVIDER DIRECTORY ' - ON 20190122
x BRC
					LAYOUT - see 'DIALYSIS CENTER' aka [_DLC]
					ORDER / SEQUENCE / HIERARCHY
x SELECT * FROM INFORMATCIS.dbo.PROVDIR_BRC
x Freestanding Birth Centers & Midwife Services







JAH 'ADD PROVDIR CHAPTER' - BRC(s)
x Hi Maryanne,  We will be adding a new chapter to the directory for Birthing Centers.  Please add this to next Tuesday’s agenda.   Walter:  What date will you be able to add the chapter? We have 2 MC and 2 CMC center with BRC specialty code. Liliana:  Heading translations in other 4 languages & confirm directory misc data fields. Maryanne:  What date will this be added to the online search.

AND (UPPER(LTRIM(RTRIM(vpl.PracticeTypeName))) LIKE '%BIRTH%' 
	OR UPPER(LTRIM(RTRIM(vpl.PracticeTypeName))) LIKE '%BRC%'
	OR UPPER(LTRIM(RTRIM(vpl.LocationName))) LIKE '%BIRTH%' 
	OR UPPER(LTRIM(RTRIM(vpl.LocationName)))  LIKE '%BRC%')

vlpSERVICETYPENAME IN ('BIRTHING CENTER')

UNION ALL --VERTICAL() w UNION ALL()  - ROW(s) --STACK
SELECT [Participating Network] COLLATE DATABASE_DEFAULT AS [Participating Network] -- ,plan_type
,COUNT(DISTINCT(LTRIM(RTRIM([Address]))+LTRIM(RTRIM([HospitalName])))) AS [RECORD COUNT]
,'Birthing Centers' AS [NOTE(s)]
,CAST(NULL AS nvarchar(255)) AS [ONLINE_TITLE],CAST(NULL AS int) AS [TOTAL],UPDATEDT_FOOTNOTE
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
FROM INFORMATICS.dbo.PROVDIR_BRC
GROUP BY [Participating Network],UPDATEDT_FOOTNOTE
--ORDER BY [Participating Network] COLLATE DATABASE_DEFAULT AS [Participating Network] -- ,plan_type

UNION ALL --VERTICAL() w UNION ALL()  - ROW(s) --STACK
SELECT COUNT(DISTINCT(LTRIM(RTRIM([Address]))+LTRIM(RTRIM([HospitalName])))) AS [RECORD COUNT]
,'Birthing Centers' AS [NOTE(s)]
,CAST(NULL AS nvarchar(255)) AS [ONLINE_TITLE]
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
FROM INFORMATICS.dbo.PROVDIR_BRC
--ORDER BY [Participating Network] COLLATE DATABASE_DEFAULT AS [Participating Network] -- ,plan_type

SELECT * FROM INFORMATICS.dbo.PROVDIR_CLINIC ORDER BY INDEXNM --INCLUDE ALL ... AND ...CONSOLIDATE LANGUAGE(s) WITH JL_Languages_...sql ADD BACK [CULTURAL COMPETENCE]
SELECT DISTINCT INDEXNM FROM INFORMATICS.dbo.PROVDIR_CLINIC ORDER BY INDEXNM --INCLUDE ALL ... AND ...CONSOLIDATE LANGUAGE(s) WITH JL_Languages_...sql ADD BACK [CULTURAL COMPETENCE]
SELECT * FROM INFORMATICS.dbo.PROVDIR_CLINIC WHERE Address LIKE '%LEWIS%' ORDER BY INDEXNM







JAH 'QNXT PROVID' - For the provider directory, can you make sure that if you are pulling the QNXT provid from eVIPs that you are getting it from vwPractitionerAlternateIDs.IDNumber  It might be coming from there already.  Jeremy

x see AS [provider_no]
x SELECT * FROM INFORMATICS.dbo.PROVDIR_CHAPTER_COUNT

'1912218199'
,UPPER(LTRIM(RTRIM(vpaid.IDnumber))) AS [provider_no] -- per email FROM JL ON 20180924 ''
,UPPER(LTRIM(RTRIM(vlp.ProviderNumber))) AS [VLP_provider_no] -- LEGACY (D950) SEQ_PROV_ID
,UPPER(LTRIM(RTRIM(vfaid.IDnumber))) AS [VFA_provider_no] -- per email FROM JL ON 20180924 ''
,UPPER(LTRIM(RTRIM(vpaid.IDnumber))) AS [VPA_provider_no] -- per email FROM JL ON 20180924 ''

					SELECT IDNumber,* FROM eVips_chgcv.dbo.vwFacilityAlternateIDs
					SELECT IDNumber,* FROM eVips_chgcv.dbo.vwPracticeAlternateIDs
					SELECT IDNumber,* FROM eVips_chgcv.dbo.vwPractitionerAlternateIDs

USE [eVips_chgcv]

DECLARE @tblis AS nvarchar (100)
DECLARE @tbltype AS nvarchar (100)
DECLARE @tblwas AS nvarchar (100)
DECLARE @tblwillbe AS nvarchar (100)
DECLARE @fieldis AS nvarchar (100)
DECLARE @fieldwas AS nvarchar (100)
DECLARE @fieldwillbe AS nvarchar (100)

SET @tblis  = '%vw%'--UPDATE AS NEEDED HERE WITHIN THE ‘’
SET @tbltype  = '%%'--UPDATE AS NEEDED HERE WITHIN THE ‘’
SET @tblwas  = '%%'--UPDATE AS NEEDED HERE WITHIN THE ‘’
SET @tblwillbe  = '%%'--UPDATE AS NEEDED HERE WITHIN THE ‘’
SET @fieldis  = '%alternate%'--UPDATE AS NEEDED HERE WITHIN THE ‘’ ISO w createid OR dreatedate
SET @fieldwas  = '%%'--UPDATE AS NEEDED HERE WITHIN THE ‘’
SET @fieldwillbe  = '%%'--UPDATE AS NEEDED HERE WITHIN THE ‘’

SELECT *
-- SELECT * FROM INFORMATION_SCHEMA.TABLES -- CHECK 1st
FROM INFORMATION_SCHEMA.COLUMNS AS isc
	JOIN INFORMATION_SCHEMA.TABLES AS ist ON ist.TABLE_NAME = isc.TABLE_NAME
WHERE isc.TABLE_NAME LIKE @tblis
	AND isc.COLUMN_NAME LIKE @fieldis
	AND ist.TABLE_TYPE LIKE @tbltype
	AND isc.TABLE_NAME IN (SELECT iscwas.TABLE_NAME
FROM INFORMATION_SCHEMA.COLUMNS AS iscwas
WHERE iscwas.TABLE_NAME LIKE @tblwas
	AND iscwas.COLUMN_NAME LIKE @fieldwas)
	AND isc.TABLE_NAME IN (SELECT iscwillbe.TABLE_NAME
FROM INFORMATION_SCHEMA.COLUMNS AS iscwillbe
WHERE iscwillbe.TABLE_NAME LIKE @tblwillbe
	AND iscwillbe.COLUMN_NAME LIKE @fieldwillbe)
ORDER BY isc.TABLE_NAME,isc.COLUMN_NAME

					-- SELECT * FROM 
					-- SELECT DISTINCT  FROM 
					-- SELECT * FROM [DATABASEname].dbo.
					-- SELECT DISTINCT FROM [DATABASEname].dbo.

--[TABLE]







JAH 'QNXT provid(s)' - FROM YOUNG LADY LAURA

SELECT lookup_key,FacilityName,provider_no,LocationID,* FROM INFORMATICS.dbo.TimelyAccessFAC WHERE provider_no = '16' OR lookup_key IN ('4126140','4124793','4124810')
SELECT DISTINCT IDNumber,ProviderAlternateID,ProviderID,LocationID,AlternateIDTypeID FROM eVips_chgcv.dbo.vwPracticeAlternateIDs  WHERE UPPER(LTRIM(RTRIM(ISNULL(AlternateIDTypeName,'')))) LIKE '%QNXT%' AND archived = 'N' AND IDNumber IN ('16') -- ',18','20')

SELECT lookup_key,LastName,FirstName,provider_no,* FROM INFORMATICS.dbo.TimelyAccessPCP WHERE provider_no = '2778' OR lookup_key IN ('4126140','4124793','4124810')
SELECT DISTINCT IDNumber,ProviderAlternateID,ProviderID,AlternateIDTypeID FROM eVips_chgcv.dbo.vwPractitionerAlternateIDs  WHERE UPPER(LTRIM(RTRIM(ISNULL(AlternateIDTypeName,'')))) LIKE '%QNXT%' AND archived = 'N' AND IDNumber IN ('2778')

-- ====================================================================
	-- QUPD() QNXT [provid] FAC(s)--
-- ====================================================================
/* JAH 'QNXT PROVID' - For the provider directory, can you make sure that if you are pulling the QNXT provid from eVIPs that you are getting it from vwPractitionerAlternateIDs.IDNumber  It might be coming from there already.  Jeremy */

UPDATE ##INNETWORK_FAC
SET [provider_no] = DERIVEDFAC.IDnumber -- ,UPPER(LTRIM(RTRIM(vlp.ProviderNumber))) AS [provider_no] -- LEGACY (D950) SEQ_PROV_ID
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM ##INNETWORK_FAC AS inp
	JOIN ( -- INITIATE ...
SELECT DISTINCT IDNumber,ProviderAlternateID/* ,ProviderID */,LocationID,AlternateIDTypeID FROM eVips_chgcv.dbo.vwPracticeAlternateIDs  WHERE UPPER(LTRIM(RTRIM(ISNULL(AlternateIDTypeName,'')))) LIKE '%QNXT%' AND archived = 'N'
) AS DERIVEDFAC ON UPPER(LTRIM(RTRIM(ISNULL(DERIVEDFAC.[LocationID],'')))) = UPPER(LTRIM(RTRIM(ISNULL(inp.[LocationID],'')))) -- ,vpl.LocationID DERIVED() ALIASNAME CONCLUDE ...

	--DUP(s)--
-- SELECT 'DUP Validation' AS [NOTE(s)],IDNumber,*
-- FROM eVips_chgcv.dbo.vwPracticeAlternateIDs
-- WHERE LTRIM(RTRIM(LocationID)) IN (SELECT LTRIM(RTRIM(dup.LocationID))
-- FROM eVips_chgcv.dbo.vwPracticeAlternateIDs AS dup
-- WHERE UPPER(LTRIM(RTRIM(ISNULL(dup.AlternateIDTypeName,'')))) LIKE '%QNX%'
	-- AND dup.archived = 'N'
-- GROUP BY LTRIM(RTRIM(dup.LocationID)) --Duplication Driver
-- HAVING COUNT(1)>1) --HAVING clause RESERVED for AGGREGATE(s)
	-- AND UPPER(LTRIM(RTRIM(ISNULL(AlternateIDTypeName,'')))) LIKE '%QNX%'
	-- AND archived = 'N' 
-- ORDER BY LTRIM(RTRIM(LocationID))

-- ====================================================================
	-- QUPD() QNXT [provid] PROV(s)--
-- ====================================================================
/* JAH 'QNXT PROVID' - For the provider directory, can you make sure that if you are pulling the QNXT provid from eVIPs that you are getting it from vwPractitionerAlternateIDs.IDNumber  It might be coming from there already.  Jeremy */

UPDATE ##INNETWORK_PROV
SET [provider_no] = DERIVEDPROV.IDnumber
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM ##INNETWORK_PROV AS inp
	JOIN ( -- INITIATE ...
SELECT DISTINCT IDNumber,ProviderAlternateID,ProviderID,AlternateIDTypeID FROM eVips_chgcv.dbo.vwPractitionerAlternateIDs WHERE UPPER(LTRIM(RTRIM(ISNULL(AlternateIDTypeName,'')))) LIKE '%QNXT%' AND archived = 'N'
) AS DERIVEDPROV ON UPPER(LTRIM(RTRIM(ISNULL(DERIVEDPROV.[ProviderID],'')))) = UPPER(LTRIM(RTRIM(ISNULL(inp.[lookup_key],'')))) -- ,UPPER(LTRIM(RTRIM(vpd.PractitionerID))) AS 'lookup_key' DERIVED() ALIASNAME CONCLUDE ...

	--DUP(s)--
-- SELECT 'DUP Validation' AS [NOTE(s)],IDNumber,*
-- FROM eVips_chgcv.dbo.vwPractitionerAlternateIDs
-- WHERE LTRIM(RTRIM(ProviderID)) IN (SELECT LTRIM(RTRIM(dup.ProviderID))
-- FROM eVips_chgcv.dbo.vwPractitionerAlternateIDs AS dup
-- WHERE UPPER(LTRIM(RTRIM(ISNULL(dup.AlternateIDTypeName,'')))) LIKE '%QNX%'
	-- AND dup.archived = 'N'
-- GROUP BY LTRIM(RTRIM(dup.ProviderID)) --Duplication Driver
-- HAVING COUNT(1)>1) --HAVING clause RESERVED for AGGREGATE(s)
	-- AND UPPER(LTRIM(RTRIM(ISNULL(AlternateIDTypeName,'')))) LIKE '%QNX%'
	-- AND archived = 'N' 
-- ORDER BY LTRIM(RTRIM(ProviderID))






SELECT [AGE RESTRICTION] ,*
FROM
( -- INITIATE ...
SELECT * FROM INFORMATICS.dbo.PROVDIR_PCP --PROV(s)
UNION --VERTICAL() w UNION ALL()  - ROW(s) --STACK 
SELECT * FROM INFORMATICS.dbo.PROVDIR_NPMP --MIDLEVEL(s) NPMP
UNION --VERTICAL() w UNION ALL()  - ROW(s) --STACK 
SELECT * FROM INFORMATICS.dbo.PROVDIR_SPE --PROV(s)
UNION --VERTICAL() w UNION ALL()  - ROW(s) --STACK 
SELECT * FROM INFORMATICS.dbo.PROVDIR_MH --PROV(s)
UNION --VERTICAL() w UNION ALL()  - ROW(s) --STACK 
SELECT * FROM INFORMATICS.dbo.PROVDIR_AHP --PROV(s)
UNION --VERTICAL() w UNION ALL()  - ROW(s) --STACK 
SELECT * FROM INFORMATICS.dbo.PROVDIR_VSP --PROV(s)
) AS DERIVED -- DERIVED() ALIASNAME CONCLUDE ...
WHERE [AGE RESTRICTION] IS NULL

SELECT [AGE RESTRICTION] ,*
FROM
( -- INITIATE ...
SELECT * FROM INFORMATICS.dbo.PROVDIR_HOSGENERALACUTE --HOSGAH
UNION --VERTICAL() w UNION ALL()  - ROW(s) --STACK 
SELECT * FROM INFORMATICS.dbo.PROVDIR_HOSADDITIONAL --HOSADD
) AS DERIVED -- DERIVED() ALIASNAME CONCLUDE ...
WHERE [AGE RESTRICTION] IS NULL

SELECT [AGE RESTRICTION] ,*
FROM
( -- INITIATE ...
SELECT * FROM INFORMATICS.dbo.PROVDIR_SNF
UNION --VERTICAL() w UNION ALL()  - ROW(s) --STACK 
SELECT * FROM INFORMATICS.dbo.PROVDIR_RCF
UNION --VERTICAL() w UNION ALL()  - ROW(s) --STACK 
SELECT * FROM INFORMATICS.dbo.PROVDIR_HOSPICE --ADD HOSPICE facility(-ies) per SC ON 20161012 Walter/Maryanne/Kelly Question 13 is asking for the display in printed and online for 2 new sections (hospice & inpatient rehabilitation).  I will send specs on hospice. 
UNION --VERTICAL() w UNION ALL()  - ROW(s) --STACK 
SELECT * FROM INFORMATICS.dbo.PROVDIR_IPREHAB --DUPLICATE 'PROVDIR_SNF' --ADD HOSPICE facility(-ies) per SC ON 20161012 Walter/Maryanne/Kelly Question 13 is asking for the display in printed and online for 2 new sections (hospice & inpatient rehabilitation).  I will send specs on hospice. 
UNION --VERTICAL() w UNION ALL()  - ROW(s) --STACK 
SELECT * FROM INFORMATICS.dbo.PROVDIR_CBAS --INCLUDE ALL
UNION --VERTICAL() w UNION ALL()  - ROW(s) --STACK 
SELECT * FROM INFORMATICS.dbo.PROVDIR_HDM --INCLUDE ALL
UNION --VERTICAL() w UNION ALL()  - ROW(s) --STACK 
SELECT * FROM INFORMATICS.dbo.PROVDIR_HHC --INCLUDE ALL
UNION --VERTICAL() w UNION ALL()  - ROW(s) --STACK 
SELECT * FROM INFORMATICS.dbo.PROVDIR_IHSS --[Participating Network] aka LINE_OF_BUSINESS DISTINCTION NOW PRESENT
UNION --VERTICAL() w UNION ALL()  - ROW(s) --STACK 
SELECT * FROM INFORMATICS.dbo.PROVDIR_ASC --was AMBSC
UNION --VERTICAL() w UNION ALL()  - ROW(s) --STACK 
SELECT * FROM INFORMATICS.dbo.PROVDIR_DXC
UNION --VERTICAL() w UNION ALL()  - ROW(s) --STACK 
SELECT * FROM INFORMATICS.dbo.PROVDIR_LAB --LAB
UNION --VERTICAL() w UNION ALL()  - ROW(s) --STACK 
SELECT * FROM INFORMATICS.dbo.PROVDIR_DLC
UNION --VERTICAL() w UNION ALL()  - ROW(s) --STACK 
SELECT * FROM INFORMATICS.dbo.PROVDIR_URC
UNION --VERTICAL() w UNION ALL()  - ROW(s) --STACK 
SELECT * FROM INFORMATICS.dbo.PROVDIR_MIN --MINUTE CLINIC(s)
UNION --VERTICAL() w UNION ALL()  - ROW(s) --STACK 
SELECT * FROM INFORMATICS.dbo.PROVDIR_PPH --PPH (Palomar Pomerado Healthcare) EXPRESS
) AS DERIVED -- DERIVED() ALIASNAME CONCLUDE ...
WHERE [AGE RESTRICTION] IS NULL

-- SELECT * FROM INFORMATICS.dbo.PROVDIR_CLINIC --INCLUDE ALL ... AND ...CONSOLIDATE LANGUAGE(s) WITH JL_Languages_...sql ADD BACK [CULTURAL COMPETENCE]
-- SELECT * FROM INFORMATICS.dbo.PROVDIR_PHARM --INCLUDE ALL
-- SELECT * FROM INFORMATICS.dbo.PROVDIR_PHARM_RCP --INCLUDE ALL
-- SELECT * FROM INFORMATICS.dbo.PROVDIR_PHARM_MO --INCLUDE ALL
-- SELECT * FROM INFORMATICS.dbo.PROVDIR_PHARM_HI --INCLUDE ALL
-- SELECT * FROM INFORMATICS.dbo.PROVDIR_PHARM_LTC --INCLUDE ALL
-- SELECT * FROM INFORMATICS.dbo.PROVDIR_PHARM_ITU --INCLUDE ALL







JAH 'QNXT PROVID' - For the provider directory, can you make sure that if you are pulling the QNXT provid from eVIPs that you are getting it from vwPractitionerAlternateIDs.IDNumber  It might be coming from there already.  Jeremy

x see AS [provider_no]

-- ====================================================================
	-- QUPD() QNXT [provid] --
-- ====================================================================
/* JAH 'QNXT PROVID' - For the provider directory, can you make sure that if you are pulling the QNXT provid from eVIPs that you are getting it from vwPractitionerAlternateIDs.IDNumber  It might be coming from there already.  Jeremy */

UPDATE ##INNETWORK_PROV
SET [provider_no] = DERIVED.IDnumber
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM ##INNETWORK_PROV AS inp
	JOIN ( -- INITIATE ...
SELECT DISTINCT IDNumber,ProviderAlternateID,ProviderID,AlternateIDTypeID FROM eVips_chgcv.dbo.vwPractitionerAlternateIDs WHERE UPPER(LTRIM(RTRIM(ISNULL(AlternateIDTypeName,'')))) LIKE '%QNX%'
) AS DERIVED ON UPPER(LTRIM(RTRIM(ISNULL(DERIVED.[ProviderID],'')))) = UPPER(LTRIM(RTRIM(ISNULL(inp.[lookup_key],'')))) -- ,UPPER(LTRIM(RTRIM(vpd.PractitionerID))) AS 'lookup_key' DERIVED() ALIASNAME CONCLUDE ...







'1912218199'
,UPPER(LTRIM(RTRIM(vpaid.IDnumber))) AS [provider_no] -- per email FROM JL ON 20180924 'For the provider directory, can you make sure that if you are pulling the QNXT provid from eVIPs that you are getting it from vwPractitionerAlternateIDs.IDNumber  It might be coming from there already.  Jeremy'
,UPPER(LTRIM(RTRIM(vlp.ProviderNumber))) AS [VLP_provider_no] -- LEGACY (D950) SEQ_PROV_ID
,UPPER(LTRIM(RTRIM(vpaid.IDnumber))) AS [VPA_provider_no] -- per email FROM JL ON 20180924 'For the provider directory, can you make sure that if you are pulling the QNXT provid from eVIPs that you are getting it from vwPractitionerAlternateIDs.IDNumber  It might be coming from there already.  Jeremy'

,UPPER(LTRIM(RTRIM(vpaid.IDnumber))) AS [provider_no] -- per email FROM JL ON 20180924 'For the provider directory, can you make sure that if you are pulling the QNXT provid from eVIPs that you are getting it from vwPractitionerAlternateIDs.IDNumber  It might be coming from there already.  Jeremy'
,UPPER(LTRIM(RTRIM(vpp.ProviderNumber))) AS [VPP_provider_no] -- LEGACY (D950) SEQ_PROV_ID
,UPPER(LTRIM(RTRIM(vploc.ProviderNumber))) AS [alt_provider_no] -- LEGACY (D950) SEQ_PROV_ID
,UPPER(LTRIM(RTRIM(vpaid.IDnumber))) AS [VPA_provider_no] -- per email FROM JL ON 20180924 'For the provider directory, can you make sure that if you are pulling the QNXT provid from eVIPs that you are getting it from vwPractitionerAlternateIDs.IDNumber  It might be coming from there already.  Jeremy'

SELECT * FROM INFORMATICS.dbo.TimelyAccessPCP WHERE provider_no  = '2827'
SELECT * FROM INFORMATICS.dbo.TimelyAccessSPE WHERE provider_no  = '2827'

					--SELECT IDNumber,* FROM eVips_chgcv.dbo.vwFacilityAlternateIDs 
					--SELECT IDNumber,* FROM eVips_chgcv.dbo.vwPracticeAlternateIDs WHERE UPPER(LTRIM(RTRIM(ISNULL(AlternateIDTypeName,'')))) LIKE '%QNX%'

					SELECT DISTINCT IDNumber,ProviderAlternateID,ProviderID,AlternateIDTypeID,* FROM eVips_chgcv.dbo.vwPractitionerAlternateIDs WHERE UPPER(LTRIM(RTRIM(ISNULL(AlternateIDTypeName,'')))) LIKE '%QNX%' AND IDNumber IN ('2827')
	--SELECT DISTINCT AlternateIDTypeName FROM eVips_chgcv.dbo.vwPractitionerAlternateIDs WHERE UPPER(LTRIM(RTRIM(ISNULL(AlternateIDTypeName,'')))) LIKE '%QNX%'			
	
	--DUP(s)--
SELECT 'DUP Validation' AS [NOTE(s)],*
FROM eVips_chgcv.dbo.vwPractitionerAlternateIDs
WHERE LTRIM(RTRIM(ProviderID)) IN (SELECT LTRIM(RTRIM(dup.ProviderID))
FROM eVips_chgcv.dbo.vwPractitionerAlternateIDs AS dup
WHERE UPPER(LTRIM(RTRIM(ISNULL(dup.AlternateIDTypeName,'')))) LIKE '%QNX%'
GROUP BY LTRIM(RTRIM(dup.ProviderID)) --Duplication Driver
HAVING COUNT(1)>1) --HAVING clause RESERVED for AGGREGATE(s)
	AND UPPER(LTRIM(RTRIM(ISNULL(AlternateIDTypeName,'')))) LIKE '%QNX%'
ORDER BY LTRIM(RTRIM(ProviderID))
					
USE [eVips_chgcv]

DECLARE @tblis AS nvarchar (100)
DECLARE @tbltype AS nvarchar (100)
DECLARE @tblwas AS nvarchar (100)
DECLARE @tblwillbe AS nvarchar (100)
DECLARE @fieldis AS nvarchar (100)
DECLARE @fieldwas AS nvarchar (100)
DECLARE @fieldwillbe AS nvarchar (100)

SET @tblis  = '%vw%'--UPDATE AS NEEDED HERE WITHIN THE ‘’
SET @tbltype  = '%%'--UPDATE AS NEEDED HERE WITHIN THE ‘’
SET @tblwas  = '%%'--UPDATE AS NEEDED HERE WITHIN THE ‘’
SET @tblwillbe  = '%%'--UPDATE AS NEEDED HERE WITHIN THE ‘’
SET @fieldis  = '%alternate%'--UPDATE AS NEEDED HERE WITHIN THE ‘’ ISO w createid OR dreatedate
SET @fieldwas  = '%%'--UPDATE AS NEEDED HERE WITHIN THE ‘’
SET @fieldwillbe  = '%%'--UPDATE AS NEEDED HERE WITHIN THE ‘’

SELECT *
-- SELECT * FROM INFORMATION_SCHEMA.TABLES -- CHECK 1st
FROM INFORMATION_SCHEMA.COLUMNS AS isc
	JOIN INFORMATION_SCHEMA.TABLES AS ist ON ist.TABLE_NAME = isc.TABLE_NAME
WHERE isc.TABLE_NAME LIKE @tblis
	AND isc.COLUMN_NAME LIKE @fieldis
	AND ist.TABLE_TYPE LIKE @tbltype
	AND isc.TABLE_NAME IN (SELECT iscwas.TABLE_NAME
FROM INFORMATION_SCHEMA.COLUMNS AS iscwas
WHERE iscwas.TABLE_NAME LIKE @tblwas
	AND iscwas.COLUMN_NAME LIKE @fieldwas)
	AND isc.TABLE_NAME IN (SELECT iscwillbe.TABLE_NAME
FROM INFORMATION_SCHEMA.COLUMNS AS iscwillbe
WHERE iscwillbe.TABLE_NAME LIKE @tblwillbe
	AND iscwillbe.COLUMN_NAME LIKE @fieldwillbe)
ORDER BY isc.TABLE_NAME,isc.COLUMN_NAME

					-- SELECT * FROM 
					-- SELECT DISTINCT  FROM 
					-- SELECT * FROM [DATABASEname].dbo.
					-- SELECT DISTINCT FROM [DATABASEname].dbo.

--[TABLE]







JAH 'QASP' - Qualified Autism Services P...

,CASE
WHEN UPPER(LTRIM(RTRIM(ISNULL(spe.[plan_type],'')))) LIKE '%AHP%-%PAR%'
THEN 'Qualified Autism Services Paraprofessional'
WHEN UPPER(LTRIM(RTRIM(ISNULL(spe.[plan_type],'')))) LIKE '%AHP%-%PROF%'
THEN 'Qualified Autism Services Professional'
WHEN UPPER(LTRIM(RTRIM(ISNULL(spe.[plan_type],'')))) LIKE '%AHP%-%PROV%'
THEN 'Qualified Autism Services Provider'
ELSE 'UNKNOWN'
END AS [QASPSpecialty]







SELECT DISTINCT [FINALlang],LEN([FINALlang]) AS [HOW MANY LANGUAGE(s) SPOKEN] 
FROM --see BELOW
( -- INITIATE ...
SELECT DISTINCT [FINALlang] -- VERIFY 'AMERICAN SIGN LANGUAGE' CHANGE
-- SELECT DISTINCT [ACCREDITATION_BY],* -- CHECK 1st
FROM INFORMATICS.dbo.PROVDIR_PCP --PROV(s)
UNION -- VERTICAL() STACK ALL()
SELECT DISTINCT [FINALlang] -- VERIFY 'AMERICAN SIGN LANGUAGE' CHANGE
-- SELECT DISTINCT [ACCREDITATION_BY] -- CHECK 1st
FROM INFORMATICS.dbo.PROVDIR_NPMP --PROV(s)
UNION -- VERTICAL() STACK ALL()
SELECT DISTINCT [FINALlang] -- VERIFY 'AMERICAN SIGN LANGUAGE' CHANGE
-- SELECT DISTINCT [ACCREDITATION_BY] -- CHECK 1st
FROM INFORMATICS.dbo.PROVDIR_SPE --PROV(s)
UNION -- VERTICAL() STACK ALL()
SELECT DISTINCT [FINALlang] -- VERIFY 'AMERICAN SIGN LANGUAGE' CHANGE
-- SELECT DISTINCT [ACCREDITATION_BY] -- CHECK 1st
FROM INFORMATICS.dbo.PROVDIR_MH --PROV(s)
UNION -- VERTICAL() STACK ALL()
SELECT DISTINCT [FINALlang] -- VERIFY 'AMERICAN SIGN LANGUAGE' CHANGE
-- SELECT DISTINCT [ACCREDITATION_BY] -- CHECK 1st
FROM INFORMATICS.dbo.PROVDIR_AHP --PROV(s)
UNION -- VERTICAL() STACK ALL()
SELECT DISTINCT [FINALlang] -- VERIFY 'AMERICAN SIGN LANGUAGE' CHANGE
-- SELECT DISTINCT [ACCREDITATION_BY] -- CHECK 1st
FROM INFORMATICS.dbo.PROVDIR_VSP --PROV(s)
UNION -- VERTICAL() STACK ALL()
SELECT DISTINCT [FINALlang] -- VERIFY 'AMERICAN SIGN LANGUAGE' CHANGE
-- SELECT DISTINCT [ACCREDITATION_BY] -- CHECK 1st
FROM INFORMATICS.dbo.PROVDIR_CLINIC --FQHC(s)
) AS DERIVED -- DERIVED() ALIASNAME CONCLUDE ...
ORDER BY LEN([FINALlang]) DESC

JAH 'CHECK AGE RESTRICTION' - FOR BARBADILLO FERDINAND 1982662193
LEFT JOIN (SELECT TOP 100000 * FROM ##HOSPpriv ORDER BY lookup_key,HOSPNM) AS hp ON UPPER(LTRIM(RTRIM(hp.lookup_key))) = UPPER(LTRIM(RTRIM(vpd.PractitionerID)))

x REORDER HIOSP AFFILIATION

		LEFT JOIN #AGERESTRICTION_PROV AS ager ON UPPER(LTRIM(RTRIM(ager.PractitionerID))) = UPPER(LTRIM(RTRIM(vpd.PractitionerID)))
			AND UPPER(LTRIM(RTRIM(ager.ProductID))) = UPPER(LTRIM(RTRIM(vpp.ProductID)))
			AND UPPER(LTRIM(RTRIM(ager.LocationID))) = UPPER(LTRIM(RTRIM(vpp.LocationID)))
			-- AND UPPER(LTRIM(RTRIM(ager.AddressID))) = UPPER(LTRIM(RTRIM(vpp.AddressID)))	
			
SELECT INDEXNM,FINALhosp,FINALhosp_FULL_NAME,[Clinic Name],[AGE RESTRICTION],* FROM INFORMATICS.dbo.PROVDIR_PCP WHERE INDEXNM LIKE '%BARBADIL%FERD%'
SELECT * FROM INFORMATICS.dbo.PROVDIR_HHC

					SELECT * FROM ##HOSPpriv WHERE lookup_key IN ('4395048')

SELECT DISTINCT pp.LastName,pp.FirstName,vppl.PractitionerID,vppl.ProductID,vppl.MinimumAge,vppl.MaximumAge,pp.PracticeID,pp.LocationID,pp.AddressID,pp.*
 ,[AGE RESTRICTION] = CASE --QUPD / CASE WHEN THEN ELSE END... USE pcp.MinimumAge AND pcp.age-restriction2
WHEN LTRIM(RTRIM(ISNULL(vppl.MinimumAge,'0'))) = '21'
	AND LTRIM(RTRIM(ISNULL(vppl.MaximumAge,'0'))) = '999'
THEN '21 AND OVER'
WHEN LTRIM(RTRIM(ISNULL(vppl.MinimumAge,'0'))) = '18'
	AND LTRIM(RTRIM(ISNULL(vppl.MaximumAge,'0'))) = '999'
THEN '18 AND OVER'
WHEN LTRIM(RTRIM(ISNULL(vppl.MinimumAge,'0'))) = '0'
	AND LTRIM(RTRIM(ISNULL(vppl.MaximumAge,'0'))) = '18'
THEN 'UP TO 18' --Per S. Coleman ON 20160809 Please review the following for this provider. Cohenmeyer  132285     SPE  92123  Age Restrictions should show 0 – 18
WHEN LTRIM(RTRIM(ISNULL(vppl.MinimumAge,'0'))) = '0'
	AND LTRIM(RTRIM(ISNULL(vppl.MaximumAge,'0'))) != '999'
THEN 'UP TO '+LTRIM(RTRIM(ISNULL(vppl.MaximumAge,'0')))
WHEN LTRIM(RTRIM(ISNULL(vppl.MinimumAge,'0'))) != '0' -- NO NOT NEGATIVE <> != ...
	AND LTRIM(RTRIM(ISNULL(vppl.MaximumAge,'0'))) = '999'
THEN LTRIM(RTRIM(ISNULL(vppl.MinimumAge,'0')))+' AND OVER'
WHEN LTRIM(RTRIM(ISNULL(vppl.MinimumAge,'0'))) != '0' -- NO NOT NEGATIVE <> != ...
	AND LTRIM(RTRIM(ISNULL(vppl.MaximumAge,'0'))) != '999'
THEN LTRIM(RTRIM(ISNULL(vppl.MinimumAge,'0')))+' TO '+LTRIM(RTRIM(ISNULL(vppl.MaximumAge,'0')))
ELSE 'NONE'
END --CHANGE OF OPTION(s) per S. Coleman ON 20170103
--INTO #AGERESTRICTION_PROV
-- SELECT * --CHECK 1st
-- SELECT DISTINCT ISNULL(MinimumAge,'0') AS [MINAGE],ISNULL(MaximumAge,'0') AS [MAXAGE] --CHECK 1st
FROM eVips_chgcv.dbo.vwPractitionerProductLimitations AS vppl --OR vwLocationProductLimitations
	JOIN  eVips_chgcv.dbo.vwPractitionerProducts AS pp on pp.PractitionerProductRecID = vppl.PractitionerProductRecID
WHERE UPPER(LTRIM(RTRIM(vppl.LimitationtypeName))) LIKE '%AGE%' --WHERE LimitationtypeName LIKE '%Age%' 
	-- AND vppl.PractitionerID IN ('4394031','4396103') --TEST PROVIDER(s)
	AND pp.archived = 'N'
	AND vppl.archived = 'N'
	AND vppl.PractitionerID IN ('4395048')







JAH CHECK ,spe.[Participating Network] COLLATE DATABASE_DEFAULT AS [Participating Network] -- per SCOLEMAN email ON 20180723 '...Yes, all of the facilities should be by LOB and have the focus, specialties, age restrictions be based on each separate LOB record.  These support services were just for CMC when we started CMC, then somewhere down the line David contracted with them for MC also except for IHSS...'
-- ,'B' AS [Participating Network] -- INCLUDE ALL RECORDS REGARDLESS OF [Participating Network]

JAH 'FIX MEDGRPIPA'(s) - see ##MEDGRPOPTIONS

-- ,REPLACE(UPPER(LTRIM(RTRIM(vp.TaxIDNumber))),'-','') AS MEDGRPIPA
,REPLACE(UPPER(LTRIM(RTRIM(vp.PracticeCode))),'-','') AS MEDGRPIPA --UPDATED AS MATCH FOUND ;WITH() TimelyAccessCLINIC DATA SAMPLE(s)
,UPPER(LTRIM(RTRIM(vp.PracticeName))) AS MEDGRP

,UPPER(LTRIM(RTRIM(vpp.PracticeCode))) AS [MEDGRPIPA]
,UPPER(LTRIM(RTRIM(vpp.PracticeName))) AS [MEDGRP] 

INTO ##MEDGRPOPTIONS
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
 FROM MEDGRPOPTIONS
--WHERE MEDGRPIPA LIKE '%RADY%'
--	OR MEDGRP LIKE '%RADY%'
WHERE MEDGRPIPA IN ('951691313','144-GMG','120-IBH','125-LMFC','115-NH','140-NCHS','145-OSHC','130-SDFC','150-SYHC','274440873','506-UMG','330571597','320230033 ','330702174','956006144','330541971','260622624  ','800519972 ','160-VCC','325-PPCAMG','315-CPCMG','193-S','385-MHCS','107-CHS','209-BCHF','517-FHCOSD','157-SDIAHC','136-SIHC','610-SMC') --RADY IS 951691313 aka RADY CHILDRENS SPECIALISTS OF SAN DIEGO
	OR MEDGRP LIKE '%IMPERIAL%BEACH%' -- ADD ON per SColeman email ON 20180730 '...Please change 120-IBH to 120-IBHC....'
	OR MEDGRP LIKE '%NESTOR%' -- ADD ON per SColeman email ON 20180730 '...Please change 120-IBH to 120-IBHC....'
	OR MEDGRPIPA IN ('120-IBHC')  -- ADD ON per SColeman email ON 20180730 '...Please change 120-IBH to 120-IBHC....'
ORDER BY MEDGRP







JAH 'MEETING'(s) - ON 20180717

USE [eVips_chgcv]

DECLARE @tblis AS nvarchar(100)
DECLARE @tbltype AS nvarchar(100)
DECLARE @tblwas AS nvarchar(100)
DECLARE @tblwillbe AS nvarchar(100)
DECLARE @fieldis AS nvarchar(100)
DECLARE @fieldwas AS nvarchar(100)
DECLARE @fieldwillbe AS nvarchar(100)

SET @tblis  = '%location%'--UPDATE AS NEEDED HERE WITHIN THE ‘’
SET @tbltype  = '%%'--UPDATE AS NEEDED HERE WITHIN THE ‘’
SET @tblwas  = '%%'--UPDATE AS NEEDED HERE WITHIN THE ‘’
SET @tblwillbe  = '%%'--UPDATE AS NEEDED HERE WITHIN THE ‘’
SET @fieldis  = '%note%'--UPDATE AS NEEDED HERE WITHIN THE ‘’ ISO w createid OR dreatedate
SET @fieldwas  = '%%'--UPDATE AS NEEDED HERE WITHIN THE ‘’
SET @fieldwillbe  = '%%'--UPDATE AS NEEDED HERE WITHIN THE ‘’

SELECT *
-- SELECT * FROM INFORMATION_SCHEMA.TABLES --CHECK 1st
FROM INFORMATION_SCHEMA.COLUMNS AS isc
	JOIN INFORMATION_SCHEMA.TABLES AS ist ON ist.TABLE_NAME = isc.TABLE_NAME
WHERE isc.TABLE_NAME LIKE @tblis
	AND isc.COLUMN_NAME LIKE @fieldis
	AND ist.TABLE_TYPE LIKE @tbltype
	AND isc.TABLE_NAME IN (SELECT iscwas.TABLE_NAME
FROM INFORMATION_SCHEMA.COLUMNS AS iscwas
WHERE iscwas.TABLE_NAME LIKE @tblwas
	AND iscwas.COLUMN_NAME LIKE @fieldwas)
	AND isc.TABLE_NAME IN (SELECT iscwillbe.TABLE_NAME
FROM INFORMATION_SCHEMA.COLUMNS AS iscwillbe
WHERE iscwillbe.TABLE_NAME LIKE @tblwillbe
	AND iscwillbe.COLUMN_NAME LIKE @fieldwillbe)
ORDER BY isc.TABLE_NAME,isc.COLUMN_NAME

					-- SELECT * FROM 
					-- SELECT DISTINCT notes FROM 
					-- SELECT * FROM [DATABASEname].dbo.
					-- SELECT DISTINCT FROM [DATABASEname].dbo.
					
-- vwFacilityLocationAccreditations
vwLocationAccreditations
LocationAccreditations

SELECT accredboard.Notes,* FROM eVips_chgcv.dbo.vwPracticeLocations AS vpl 
	JOIN (SELECT DISTINCT LocationID,PracticeID,AccreditationTypeCode,AccreditationTypeName,Notes FROM eVips_chgcv.dbo.vwLocationAccreditations AS vla WHERE vla.Archived IN ('N') OR vla.Archived IS NULL) AS accredboard ON accredboard.LocationID =vpl.LocationID
		AND accredboard.PracticeID = vpl.PracticeID
WHERE UPPER(LTRIM(RTRIM(ISNULL(accredboard.Notes,'')))) LIKE '%HTTP%'
ORDER BY vpl.LocationName

FIND JAH '##ACCRED' [NOTE] field(s) IN eVIPS 'vw...' ALVARADO  20568 [LocationAccreditation].notes 1265468946 locationID 4107806
SELECT DISTINCT notes FROM vwLocationAccreditations
SELECT DISTINCT notes FROM LocationAccreditations

,CASE
WHEN UPPER(LTRIM(RTRIM(ISNULL(accredboard.Notes,'')))) LIKE '%HTTP%'
THEN UPPER(LTRIM(RTRIM(ISNULL(accredboard.Notes,''))))
ELSE CAST(NULL AS nvarchar(100))
END AS [ACCREDITATION_QUALITY_REPORT] --ANOTHER REVERSAL per S. COLEMAN email ON 20170522 ANOTHER ADD per SCOLEMAN In the Provider Directory Team meeting today, we agreed to make a slight change.  We realized that we must show the individual link to the accredited source for each hospital MC & CMC directories.We will keep Accredited & Accredited by fields.  Please remove the quality fields from all facilities for printed and online directories.  We will keep the star rating data in Vistar just in case it is asked for in the future.This field will be replaced by “Accreditation & Quality Report:” for hospitals only.  I’ve placed the hyperlink name in 3.	Accreditation and Quality Summary will hyperlink to the address provided by the data.  ON 20170419

	LEFT JOIN (SELECT DISTINCT LocationID,PracticeID,AccreditationTypeCode,AccreditationTypeName,Notes FROM eVips_chgcv.dbo.vwLocationAccreditations AS vla WHERE vla.Archived IN ('N') OR vla.Archived IS NULL) AS accredboard ON accredboard.LocationID =vpl.LocationID
			AND accredboard.PracticeID = vpl.PracticeID

					WHERE ta.[ACCREDITATION_QUALITY_REPORT] IS NULL
						AND fix.[NOTE(s)] LIKE '%HTTP%' --ANOTHER ADD per SCOLEMAN In the Provider Directory Team meeting today, we agreed to make a slight change.  We realized that we must show the individual link to the accredited source for each hospital MC & CMC directories.We will keep Accredited & Accredited by fields.  Please remove the quality fields from all facilities for printed and online directories.  We will keep the star rating data in Vistar just in case it is asked for in the future.This field will be replaced by “Accreditation & Quality Report:” for hospitals only.  I’ve placed the hyperlink name in 'board_cert. notes' AS [ACCREDITATION_QUALITY_REPORT] --3.	Accreditation and Quality Summary will hyperlink to the address provided by the data. field for a place holder.  This field format should allow in pdf and online to link to actual address.  Data is in  Paradise Valley Hospital (v9514) and Radys Children’s Hospital (v9509) records.  We will add the link in the other hospitals tomorrow. Please call me if you have any questions.  ON 20170419







JAH 'eVIPS PROVDIR GO LIVE' - ON 20180712
x ADD 'Irene Gonzales <igonzales@chgsd.com>' AS RECIPIENT(s)

SELECT DISTINCT r.FieldName,r.DisplayName,s.specialtycode,s.specialtyName AS [eVIPS_Specialty],r.Value AS [TIMELYACCESS_Profile] 
FROM evips_chgcv.dbo.vwReferenceUserFields AS r 
	LEFT JOIN evips_chgcv.dbo.vwSpecialties AS s on s.specialtyid = r.ParentRecID 
WHERE r.tablename = 'Specialties' 
	AND UPPER(LTRIM(RTRIM(ISNULL(r.fieldName,'')))) LIKE '%SPECIALTY%'
	AND UPPER(LTRIM(RTRIM(ISNULL(s.specialtyName,'')))) LIKE '%NATAL%'

WHERE LTRIM(RTRIM(vpd.NationalProviderID)) IN ('1033102959','1134389026')

	JOIN (SELECT DISTINCT vpprovloc.PractitionerID,vpprovloc.PracticeID,vpprovloc.LocationID,vpprovloc.AddressID,vpprovloc.LastName,vpprovloc.FirstName,vpprovloc.Archived,vpprovloc.LocationName,vpprovloc.NationalProviderID,vpprovloc.LocationNotes,vpprovloc.PracticeTypeName,vpprovloc.ProviderNumber,vpprovloc.website,vpfacloc.LineNumber1,vpfacloc.LineNumber2,vpfacloc.LineNumber3,vpfacloc.City,vpfacloc.[State],vpfacloc.ZipCode,vpfacloc.LocationTypeName FROM eVips_chgcv.dbo.vwPractitionerLocations AS vpprovloc 	JOIN eVips_chgcv.dbo.vwPracticeLocations AS vpfacloc ON UPPER(LTRIM(RTRIM(vpfacloc.PracticeID))) = UPPER(LTRIM(RTRIM(vpprovloc.PracticeID))) 		AND UPPER(LTRIM(RTRIM(vpfacloc.LocationID))) = UPPER(LTRIM(RTRIM(vpprovloc.LocationID))) WHERE UPPER(LTRIM(RTRIM(ISNULL(vpfacloc.LocationTypeName,'')))) LIKE '%PRACTI%')

SELECT DISTINCT vpprovloc.PractitionerID,vpprovloc.PracticeID,vpprovloc.LocationID,vpprovloc.AddressID,vpprovloc.LastName,vpprovloc.FirstName,vpprovloc.Archived,vpprovloc.LocationName,vpprovloc.NationalProviderID,vpprovloc.LocationNotes,vpprovloc.PracticeTypeName,vpprovloc.ProviderNumber,vpprovloc.website,vpfacloc.LineNumber1,vpfacloc.LineNumber2,vpfacloc.LineNumber3,vpfacloc.City,vpfacloc.[State],vpfacloc.ZipCode,vpfacloc.LocationTypeName FROM eVips_chgcv.dbo.vwPractitionerLocations AS vpprovloc 	JOIN eVips_chgcv.dbo.vwPracticeLocations AS vpfacloc ON UPPER(LTRIM(RTRIM(vpfacloc.PracticeID))) = UPPER(LTRIM(RTRIM(vpprovloc.PracticeID))) 		AND UPPER(LTRIM(RTRIM(vpfacloc.LocationID))) = UPPER(LTRIM(RTRIM(vpprovloc.LocationID))) WHERE UPPER(LTRIM(RTRIM(ISNULL(vpfacloc.LocationTypeName,'')))) LIKE '%PRACTI%'

SELECT DISTINCT LocationTypeName FROM eVips_chgcv.dbo.vwPracticeLocations

IN ('1346384468','1952322935')

SELECT * FROM INFORMATICS.dbo.AQR_VISTAR WHERE NPIis IN ('1346384468','1952322935') OR LastName LIKE '%THORNTON%' OR LastName LIKE '%SHARP%MESA%'

					INSERT INTO INFORMATICS.dbo.AQR_VISTAR  (ID,IDLINK,ACCREDITATION_QUALITY_REPORT,LastName,NPIis)
					VALUES
					('1952322935','HTTPS://WWW.QUALITYCHECK.ORG/QUALITY-REPORT/?KEYWORD=10071&BSNID=10071','HTTPS://WWW.QUALITYCHECK.ORG/QUALITY-REPORT/?KEYWORD=10071&BSNID=10071','THORNTON HOSPITAL','1952322935') -- [INITIAL] REC() / ROW
					--,(15,'Wayne','Male', 5000,'Finance'); -- [NEXT ] REC() / ROW  
					-- FROM ...
					
					INSERT INTO INFORMATICS.dbo.AQR_VISTAR  (ID,IDLINK,ACCREDITATION_QUALITY_REPORT,LastName,NPIis)
					VALUES
					('1346384468','HTTPS://WWW.QUALITYCHECK.ORG/QUALITY-REPORT/?KEYWORD=462661&BSNID=462661','HTTPS://WWW.QUALITYCHECK.ORG/QUALITY-REPORT/?KEYWORD=462661&BSNID=462661','SHARP MESA VISTA','1346384468') -- [INITIAL] REC() / ROW
					--,(15,'Wayne','Male', 5000,'Finance'); -- [NEXT ] REC() / ROW  
					-- FROM ...				
					
UPDATE INFORMATICS.dbo.AQR_VISTAR
SET NPIis = '1952322935'
FROM INFORMATICS.dbo.AQR_VISTAR
WHERE ID = '1952322935'

UPDATE INFORMATICS.dbo.AQR_VISTAR
SET IDLINK = 'HTTPS://WWW.QUALITYCHECK.ORG/QUALITY-REPORT/?KEYWORD=10071&BSNID=10071'
,ACCREDITATION_QUALITY_REPORT = 'HTTPS://WWW.QUALITYCHECK.ORG/QUALITY-REPORT/?KEYWORD=10071&BSNID=10071'
FROM INFORMATICS.dbo.AQR_VISTAR
WHERE ID = '1952322935'

--DELETE 
--SELECT * 
FROM INFORMATICS.dbo.AQR_VISTAR
WHERE ID = '1952322935'
	AND LastName = 'THORNTON HOSPITAL'
	
JAH '[FIELD]'(s) - 
SELECT DISTINCT ACCREDITATION_QUALITY_REPORT,NPIis,TESTING-- ,* 
FROM SQL01.INFORMATICS.dbo.PROVDIR_HOSGENERALACUTE --PROVDIR_HOSGENERALACUTE 
ORDER BY TESTING

SELECT DISTINCT ACCREDITATION_QUALITY_REPORT,NPIis,TESTING -- ,* 
FROM INFORMATICS.dbo.PROVDIR_HOS
ORDER BY TESTING

SELECT DISTINCT ACCREDITATION_QUALITY_REPORT,NPIis,INDEXNM-- ,* 
FROM SQL01.INFORMATICS.dbo.PROVDIR_HOSGENERALACUTE --PROVDIR_HOSGENERALACUTE 
ORDER BY INDEXNM

SELECT DISTINCT ACCREDITATION_QUALITY_REPORT,NPIis,INDEXNM -- ,* 
FROM INFORMATICS.dbo.PROVDIR_HOS
ORDER BY INDEXNM

USE [eVips_chgcv]

DECLARE @tblis AS nvarchar(100)
DECLARE @tbltype AS nvarchar(100)
DECLARE @tblwas AS nvarchar(100)
DECLARE @tblwillbe AS nvarchar(100)
DECLARE @fieldis AS nvarchar(100)
DECLARE @fieldwas AS nvarchar(100)
DECLARE @fieldwillbe AS nvarchar(100)

SET @tblis  = '%vw%'--UPDATE AS NEEDED HERE WITHIN THE ‘’
SET @tbltype  = '%%'--UPDATE AS NEEDED HERE WITHIN THE ‘’
SET @tblwas  = '%%'--UPDATE AS NEEDED HERE WITHIN THE ‘’
SET @tblwillbe  = '%%'--UPDATE AS NEEDED HERE WITHIN THE ‘’
SET @fieldis  = '%note%'--UPDATE AS NEEDED HERE WITHIN THE ‘’ ISO w createid OR dreatedate
SET @fieldwas  = '%%'--UPDATE AS NEEDED HERE WITHIN THE ‘’
SET @fieldwillbe  = '%%'--UPDATE AS NEEDED HERE WITHIN THE ‘’

SELECT *
-- SELECT * FROM INFORMATION_SCHEMA.TABLES --CHECK 1st
FROM INFORMATION_SCHEMA.COLUMNS AS isc
	JOIN INFORMATION_SCHEMA.TABLES AS ist ON ist.TABLE_NAME = isc.TABLE_NAME
WHERE isc.TABLE_NAME LIKE @tblis
	AND isc.COLUMN_NAME LIKE @fieldis
	AND ist.TABLE_TYPE LIKE @tbltype
	AND isc.TABLE_NAME IN (SELECT iscwas.TABLE_NAME
FROM INFORMATION_SCHEMA.COLUMNS AS iscwas
WHERE iscwas.TABLE_NAME LIKE @tblwas
	AND iscwas.COLUMN_NAME LIKE @fieldwas)
	AND isc.TABLE_NAME IN (SELECT iscwillbe.TABLE_NAME
FROM INFORMATION_SCHEMA.COLUMNS AS iscwillbe
WHERE iscwillbe.TABLE_NAME LIKE @tblwillbe
	AND iscwillbe.COLUMN_NAME LIKE @fieldwillbe)
ORDER BY isc.TABLE_NAME,isc.COLUMN_NAME

					-- SELECT * FROM 
					-- SELECT DISTINCT  FROM 
					-- SELECT * FROM [DATABASEname].dbo.
					-- SELECT DISTINCT FROM [DATABASEname].dbo.					







SELECT * --CHECK 1st
-- SELECT DISTINCT UPPER(LTRIM(RTRIM(vlp.InDirectory))) AS [INDIRECTORY],UPPER(LTRIM(RTRIM(vpl.LocationName))) AS [FAC Name],UPPER(LTRIM(RTRIM(vpl.LineNumber1))) AS [address1] --CHECK 1st
FROM eVips_chgcv.dbo.vwPractices AS vp
	JOIN eVips_chgcv.dbo.vwPracticeLocations AS vpl ON vpl.PracticeID = vp.PracticeID
		LEFT JOIN eVips_chgcv.dbo.vwFacilities AS vf ON UPPER(LTRIM(RTRIM(vf.FacilityName))) = UPPER(LTRIM(RTRIM(vpl.LocationName)))
			OR UPPER(LTRIM(RTRIM(vf.FacilityName))) = UPPER(LTRIM(RTRIM(vp.PracticeName)))
		LEFT JOIN (SELECT DISTINCT PracticeID,ClassOrCategory, ServiceTypeName,ServiceCategoryTypeName FROM eVips_chgcv.dbo.vwLocationServices WHERE ServiceTypeName LIKE '%GROUP%SPEC%') AS vls ON vls.PracticeID = vp.PracticeID --DEFINE FAC CHAPTER(s) 		
		LEFT JOIN (SELECT DISTINCT LocationID,PracticeID,ClassOrCategory, ServiceTypeName,ServiceCategoryTypeName,code1,code2 FROM eVips_chgcv.dbo.vwLocationServices WHERE UPPER(LTRIM(RTRIM(ServiceTypeName))) LIKE '%PHARM%TYPE%' AND ServiceCategoryTypeName IS NOT NULL AND UPPER(LTRIM(RTRIM(ServiceCategoryTypeName))) != '') AS vlspharmtype ON vlspharmtype.PracticeID = vp.PracticeID --DEFINE PHARM TYPE(s)
			AND vlspharmtype.LocationID = vpl.LocationID --per YOUNG LADY LAURA email ON 20171221 ... Products (CMC & MEDICAL)  are stored at Location Level. The code below is joining based only on Practice ID. This should be based on PracticeID + Location
		LEFT JOIN (SELECT DISTINCT LocationID,PracticeID,ClassOrCategory, ServiceTypeName,ServiceCategoryTypeName,code1,code2 FROM eVips_chgcv.dbo.vwLocationServices WHERE UPPER(LTRIM(RTRIM(ServiceTypeName))) LIKE '%PHARM%SERV%' AND ServiceCategoryTypeName IS NOT NULL AND UPPER(LTRIM(RTRIM(ServiceCategoryTypeName))) != '') AS vlspharmservice ON vlspharmservice.PracticeID = vp.PracticeID --DEFINE PHARM TYPE(s)
			AND vlspharmservice.LocationID = vpl.LocationID --per YOUNG LADY LAURA email ON 20171221 ... Products (CMC & MEDICAL)  are stored at Location Level. The code below is joining based only on Practice ID. This should be based on PracticeID + Location
		LEFT JOIN (SELECT DISTINCT PracticeID,Code1,Code2,ServiceTypeName,ServiceCategoryTypeName FROM eVips_chgcv.dbo.vwLocationServices WHERE ServiceTypeName LIKE '274%TYPE%SERV%') AS vlsfocus ON vlsfocus.PracticeID = vp.PracticeID --Alt EFFORT TO DEFINE FAC CHAPTER(s)
		LEFT JOIN (SELECT DISTINCT ProviderID,TableName,EntityCode,EntityName,EntityTypeCode,EntityTypeName FROM eVips_chgcv.dbo.vwEntityAssignments WHERE TableName LIKE '%PRACTI%') AS vea ON vea.ProviderID = vp.PracticeID
		LEFT JOIN (SELECT DISTINCT ljvlp.ProductTypeCode,ljvlp.ProductTypeName,ljvlp.PracticeTypeName,ljvlp.PracticeID,ljvlp.LocationID,ljvlp.Archived,ljvlp.StatusTypeName,vlpstype.indirectory,vlpstype.ServiceTypeName,ljvlp.productname,ljvlp.ProductPanelStatusTypeName,ljvlp.ProductPanelStatusTypeCode,ljvlp.ProviderNumber,ljvlp.Focus,ljvlp.ProductID,ljvlp.LocationTypeName FROM eVips_chgcv.dbo.vwLocationProducts AS ljvlp JOIN evips_chgcv.dbo.vwLocationProductServices AS vlpstype ON vlpstype.LocationProductRecID = ljvlp.LocationProductRecID WHERE (ljvlp.Archived IN ('N') OR ljvlp.Archived IS NULL) AND (ljvlp.StatusTypeName IN ('ACTIVE') OR ljvlp.StatusTypeName LIKE '%PARTICIP%' OR ljvlp.StatusTypeName IS NULL) AND (vlpstype.Archived IN ('N') OR vlpstype.Archived IS NULL)) AS vlp ON vlp.PracticeID = vpl.PracticeID --'YOUNG LADY LAURA GAH ID WHERE p.archived = 'N' AND s.ServiceTypeName = 'HOSPITAL' AND p.focus like '%GAH%'' ON 20171120 see ,UPPER(LTRIM(RTRIM(vlp.ServiceTypeName))) AS [vlpSERVICETYPENAME]
			AND vlp.LocationID = vpl.LocationID --per YOUNG LADY LAURA email ON 20171221 ... Products (CMC & MEDICAL)  are stored at Location Level. The code below is joining based only on Practice ID. This should be based on PracticeID + Location
		LEFT JOIN (SELECT DISTINCT LocationID,PracticeID,AccreditationTypeCode,AccreditationTypeName FROM eVips_chgcv.dbo.vwLocationAccreditations AS vla WHERE vla.Archived IN ('N') OR vla.Archived IS NULL) AS accredboard ON accredboard.LocationID =vpl.LocationID
			AND accredboard.PracticeID = vpl.PracticeID

		LEFT JOIN INFORMATICS.dbo.ZIP_CODES AS zip ON SUBSTRING(LTRIM(RTRIM(zip.ZipCode)),1,5) COLLATE DATABASE_DEFAULT = CASE
WHEN SUBSTRING(LTRIM(RTRIM(vpl.ZipCode)),1,1) = '0'
THEN '0'+ SUBSTRING(LTRIM(RTRIM(vpl.ZipCode)),2,4)
WHEN SUBSTRING(LTRIM(RTRIM(vpl.ZipCode)),1,1) = '00'
THEN '00'+ SUBSTRING(LTRIM(RTRIM(vpl.ZipCode)),3,3)
ELSE  SUBSTRING(LTRIM(RTRIM(vpl.ZipCode)),1,5) 
END
		LEFT JOIN (SELECT DISTINCT zipcode,city,county,RegionTypeName FROM eVips_chgcv.dbo.vwzipcodes WHERE UPPER(LTRIM(RTRIM(ISNULL(county,'')))) LIKE '%SAN%DIEGO%') AS regionis ON CASE WHEN SUBSTRING(LTRIM(RTRIM(regionis.ZipCode)),1,1) = '0' THEN '0'+ SUBSTRING(LTRIM(RTRIM(regionis.ZipCode)),2,4) WHEN SUBSTRING(LTRIM(RTRIM(regionis.ZipCode)),1,1) = '00' THEN '00'+ SUBSTRING(LTRIM(RTRIM(regionis.ZipCode)),3,3) ELSE  SUBSTRING(LTRIM(RTRIM(regionis.ZipCode)),1,5) END = CASE WHEN SUBSTRING(LTRIM(RTRIM(vpl.ZipCode)),1,1) = '0' THEN '0'+ SUBSTRING(LTRIM(RTRIM(vpl.ZipCode)),2,4) WHEN SUBSTRING(LTRIM(RTRIM(vpl.ZipCode)),1,1) = '00' THEN '00'+ SUBSTRING(LTRIM(RTRIM(vpl.ZipCode)),3,3) ELSE  SUBSTRING(LTRIM(RTRIM(vpl.ZipCode)),1,5) END
		LEFT JOIN (SELECT DISTINCT r.FieldName,r.DisplayName,s.specialtycode,s.specialtyName AS [eVIPS_Specialty],r.Value AS [TIMELYACCESS_Profile] FROM evips_chgcv.dbo.vwReferenceUserFields AS r LEFT JOIN evips_chgcv.dbo.vwSpecialties AS s on s.specialtyid = r.ParentRecID WHERE r.tablename = 'Specialties' AND r.fieldName = 'Specialty Grouping - Timely Access') AS profile ON UPPER(LTRIM(RTRIM(ISNULL(profile.specialtycode,'')))) = UPPER(LTRIM(RTRIM(ISNULL(vlsfocus.Code1,''))))

		LEFT JOIN (SELECT DISTINCT LocationID,PracticeID,LTRIM(RTRIM(PhoneNumber))AS [PhoneNumber] FROM eVips_chgcv.dbo.vwLocationPhones WHERE UPPER(LTRIM(RTRIM(PhoneTypeName))) LIKE '%PRIMAR%') AS PHONEprimary ON PHONEprimary.practiceid = vpl.practiceid  --PHONE ADD - ON JOIN (s)
			AND PHONEprimary.Locationid= vpl.Locationid --PHONE ADD - ON JOIN (s)

		LEFT JOIN (SELECT DISTINCT LocationID,PracticeID,LTRIM(RTRIM(PhoneNumber)) AS [PhoneNumber] FROM eVips_chgcv.dbo.vwLocationPhones WHERE UPPER(LTRIM(RTRIM(PhoneTypeName))) LIKE '%FAX%') AS PHONEfax ON PHONEfax.practiceid = vpl.practiceid  --PHONE ADD - ON JOIN (s)
			AND PHONEfax.Locationid= vpl.Locationid --FAX ADD - ON JOIN (s)
			
WHERE 		CASE
WHEN vpl.NationalProviderID IS NULL
	AND UPPER(LTRIM(RTRIM(vf.FacilityStatus))) LIKE 'ACTIVE%'
	AND UPPER(LTRIM(RTRIM(vf.ApplicationStatus))) LIKE 'ACTIVE%'
THEN LTRIM(RTRIM(vf.NationalProviderID))
ELSE LTRIM(RTRIM(vpl.NationalProviderID)) 
END IN ('1265468946') -- ALVARADO HOSPITAL HTTPS://WWW.QUALITYCHECK.ORG/QUALITY-REPORT/?KEYWORD=10066&BSNID=10066	1265468946	ALVARADO HOSPITAL HTTPS://WWW.QUALITYCHECK.ORG/QUALITY-REPORT/?KEYWORD=10071&BSNID=10071







SELECT DISTINCT ACCREDITATION_QUALITY_REPORT,LastName,NPIis FROM INFORMATICS.dbo.TimelyAccessFAC

SELECT AS [ACCREDITATION_QUALITY_REPORT] - see SELECT * FROM INFORMATICS.dbo.AQR_VISTAR -- IMPORT FROM SQL01.VIP aka 'VISTAR' TO FIX AS [ACCREDITATION_QUALITY_REPORT] see 'AQR_VISTAR_20180711.xlsx'

SELECT DISTINCT ACCREDITATION_QUALITY_REPORT FROM INFORMATICS.dbo.TimelyAccessFAC
SELECT DISTINCT ACCREDITATION_QUALITY_REPORT FROM INFORMATICS.dbo.TimelyAccessCLINIC		
SELECT DISTINCT ACCREDITATION_QUALITY_REPORT FROM INFORMATICS.dbo.TimelyAccessPHARM

SELECT DISTINCT ACCREDITATION_QUALITY_REPORT,LastName,NPIis FROM INFORMATICS.dbo.TimelyAccessFAC

SELECT DISTINCT r.FieldName,r.DisplayName,s.specialtycode,s.specialtyName AS [eVIPS_Specialty],r.Value AS [TIMELYACCESS_Profile] 
FROM evips_chgcv.dbo.vwReferenceUserFields AS r 
	LEFT JOIN evips_chgcv.dbo.vwSpecialties AS s on s.specialtyid = r.ParentRecID 
WHERE r.tablename = 'Specialties' 
	AND UPPER(LTRIM(RTRIM(ISNULL(r.fieldName,'')))) LIKE '%SPECIALTY%'
	AND UPPER(LTRIM(RTRIM(ISNULL(s.specialtyName,'')))) LIKE '%NATAL%'

-- ==============================================================
	-- AQR FROM VISTAR FIX --
-- ==============================================================
UPDATE ##INNETWORK_FAC
SET [ACCREDITATION_QUALITY_REPORT] = aqr.[IDLINK]
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM ##INNETWORK_FAC AS inf
	JOIN INFORMATICS.dbo.AQR_VISTAR AS aqr ON UPPER(LTRIM(RTRIM(ISNULL(aqr.ID,'')))) =  UPPER(LTRIM(RTRIM(ISNULL(inf.NPIis,'')))) -- IMPORT FROM SQL01.VIP aka 'VISTAR' TO FIX AS [ACCREDITATION_QUALITY_REPORT] see 'AQR_VISTAR_20180711.xlsx' ,CAST(NULL AS nvarchar(100)) AS [ACCREDITATION_QUALITY_REPORT] --ANOTHER REVERSAL per S. COLEMAN email ON 20170522 ANOTHER ADD per SCOLEMAN In the Provider Directory Team meeting today, we agreed to make a slight change.  We realized that we must show the individual link to the accredited source for each hospital MC & CMC directories.We will keep Accredited & Accredited by fields.  Please remove the quality fields from all facilities for printed and online directories.  We will keep the star rating data in Vistar just in case it is asked for in the future.This field will be replaced by “Accreditation & Quality Report:” for hospitals only.  I’ve placed the hyperlink name in 3.	Accreditation and Quality Summary will hyperlink to the address provided by the data.  ON 20170419
WHERE inf.[ACCREDITATION_QUALITY_REPORT] IS NULL

					UPDATE ##INNETWORK_FAC
					SET [ACCREDITATION_QUALITY_REPORT] = 'NA'
					-- SELECT DISTINCT [ACCREDITATION_QUALITY_REPORT] -- CHECK 1st
					FROM ##INNETWORK_FAC AS inf
					WHERE inf.[ACCREDITATION_QUALITY_REPORT] IS NULL

					SELECT * FROM INFORMATICS.dbo.PROVDIR_PCP
					SELECT * FROM INFORMATICS.dbo.PROVDIR_SPE
					
					SELECT * FROM INFORMATICS.dbo.PROVDIR_HOS
,UPPER(LTRIM(RTRIM('Hospitals'))) AS PROVIDER_TYPE
					
					SELECT * FROM INFORMATICS.dbo.PROVDIR_HOSGENERALACUTE
,UPPER(LTRIM(RTRIM('General Acute Hospital'))) AS PROVIDER_TYPE
					
					SELECT * FROM INFORMATICS.dbo.PROVDIR_HOSADDITIONAL
,CASE
WHEN UPPER(LTRIM(RTRIM([Participating Network]))) = 'CL1'
THEN UPPER(LTRIM(RTRIM('Long Term Acute Care Hospitals')))
ELSE UPPER(LTRIM(RTRIM('Mental Health & Long Term Acute Care Hospitals')))
END AS PROVIDER_TYPE

					SELECT * FROM INFORMATICS.dbo.PROVDIR_SNF
					SELECT * FROM INFORMATICS.dbo.PROVDIR_RCF
					SELECT * FROM INFORMATICS.dbo.PROVDIR_HOSPICE
					SELECT * FROM INFORMATICS.dbo.PROVDIR_IPREHAB
					SELECT * FROM INFORMATICS.dbo.PROVDIR_MH
					SELECT * FROM INFORMATICS.dbo.PROVDIR_CBAS
					SELECT * FROM INFORMATICS.dbo.PROVDIR_HDM
					SELECT * FROM INFORMATICS.dbo.PROVDIR_HHC
					SELECT * FROM INFORMATICS.dbo.PROVDIR_IHSS
					SELECT * FROM INFORMATICS.dbo.PROVDIR_AHP
					SELECT * FROM INFORMATICS.dbo.PROVDIR_NPMP
					SELECT * FROM INFORMATICS.dbo.PROVDIR_ASC
					SELECT * FROM INFORMATICS.dbo.PROVDIR_DXC
					SELECT * FROM INFORMATICS.dbo.PROVDIR_LAB
					SELECT * FROM INFORMATICS.dbo.PROVDIR_DLC
					SELECT * FROM INFORMATICS.dbo.PROVDIR_URC
					SELECT * FROM INFORMATICS.dbo.PROVDIR_MIN
					SELECT * FROM INFORMATICS.dbo.PROVDIR_PPH
					SELECT * FROM INFORMATICS.dbo.PROVDIR_PHARM
					SELECT * FROM INFORMATICS.dbo.PROVDIR_CLINIC
					SELECT * FROM INFORMATICS.dbo.PROVDIR_VSP
					SELECT * FROM INFORMATICS.dbo.PROVDIR_PHARM_RCP
					SELECT * FROM INFORMATICS.dbo.PROVDIR_PHARM_MO
					SELECT * FROM INFORMATICS.dbo.PROVDIR_PHARM_HI
					SELECT * FROM INFORMATICS.dbo.PROVDIR_PHARM_LTC
					SELECT * FROM INFORMATICS.dbo.PROVDIR_PHARM_ITU

					SELECT * FROM INFORMATICS.dbo.PROVDIR_PCP
					SELECT * FROM INFORMATICS.dbo.PROVDIR_SPE
					SELECT * FROM INFORMATICS.dbo.PROVDIR_HOS
					SELECT * FROM INFORMATICS.dbo.PROVDIR_HOSGENERALACUTE
					SELECT * FROM INFORMATICS.dbo.PROVDIR_HOSADDITIONAL
					SELECT * FROM INFORMATICS.dbo.PROVDIR_SNF
					SELECT * FROM INFORMATICS.dbo.PROVDIR_RCF
					SELECT * FROM INFORMATICS.dbo.PROVDIR_HOSPICE
					SELECT * FROM INFORMATICS.dbo.PROVDIR_IPREHAB
					SELECT * FROM INFORMATICS.dbo.PROVDIR_MH
					SELECT * FROM INFORMATICS.dbo.PROVDIR_CBAS
					SELECT * FROM INFORMATICS.dbo.PROVDIR_HDM
					SELECT * FROM INFORMATICS.dbo.PROVDIR_HHC
					SELECT * FROM INFORMATICS.dbo.PROVDIR_IHSS
					SELECT * FROM INFORMATICS.dbo.PROVDIR_AHP
					SELECT * FROM INFORMATICS.dbo.PROVDIR_NPMP
					SELECT * FROM INFORMATICS.dbo.PROVDIR_ASC
					SELECT * FROM INFORMATICS.dbo.PROVDIR_DXC
					SELECT * FROM INFORMATICS.dbo.PROVDIR_LAB
					SELECT * FROM INFORMATICS.dbo.PROVDIR_DLC
					SELECT * FROM INFORMATICS.dbo.PROVDIR_URC
					SELECT * FROM INFORMATICS.dbo.PROVDIR_MIN
					SELECT * FROM INFORMATICS.dbo.PROVDIR_PPH
					SELECT * FROM INFORMATICS.dbo.PROVDIR_PHARM
					SELECT * FROM INFORMATICS.dbo.PROVDIR_CLINIC
					SELECT * FROM INFORMATICS.dbo.PROVDIR_VSP
					SELECT * FROM INFORMATICS.dbo.PROVDIR_PHARM_RCP
					SELECT * FROM INFORMATICS.dbo.PROVDIR_PHARM_MO
					SELECT * FROM INFORMATICS.dbo.PROVDIR_PHARM_HI
					SELECT * FROM INFORMATICS.dbo.PROVDIR_PHARM_LTC
					SELECT * FROM INFORMATICS.dbo.PROVDIR_PHARM_ITU







	JOIN (SELECT DISTINCT vpprovloc.PractitionerID,vpprovloc.PracticeID,vpprovloc.LocationID,vpprovloc.AddressID,vpprovloc.LastName,vpprovloc.FirstName,vpprovloc.Archived,vpprovloc.LocationName,vpprovloc.NationalProviderID,vpprovloc.LocationNotes,vpprovloc.PracticeTypeName,vpprovloc.ProviderNumber,vpprovloc.website,vpfacloc.LineNumber1,vpfacloc.LineNumber2,vpfacloc.LineNumber3,vpfacloc.City,vpfacloc.[State],vpfacloc.ZipCode,vpfacloc.LocationTypeName FROM eVips_chgcv.dbo.vwPractitionerLocations AS vpprovloc 	JOIN eVips_chgcv.dbo.vwPracticeLocations AS vpfacloc ON UPPER(LTRIM(RTRIM(vpfacloc.PracticeID))) = UPPER(LTRIM(RTRIM(vpprovloc.PracticeID))) 		AND UPPER(LTRIM(RTRIM(vpfacloc.LocationID))) = UPPER(LTRIM(RTRIM(vpprovloc.LocationID))) WHERE UPPER(LTRIM(RTRIM(ISNULL(vpfacloc.LocationTypeName,'')))) LIKE '%PRACTI%') AS vploc ON UPPER(LTRIM(RTRIM(vploc.PractitionerID))) = UPPER(LTRIM(RTRIM(vpd.PractitionerID)))
		AND UPPER(LTRIM(RTRIM(vploc.PracticeID))) = UPPER(LTRIM(RTRIM(vpp.PracticeID)))
		AND UPPER(LTRIM(RTRIM(vploc.LocationID))) = UPPER(LTRIM(RTRIM(vpp.LocationID)))
		-- AND UPPER(LTRIM(RTRIM(vploc.AddressID))) = UPPER(LTRIM(RTRIM(vpp.AddressID)))







Hi Walter,
Can you please see the email string below and let us know when this is resolved. 

Thank you,
Kelly Callies
Sr Business Analyst
Community Health Group
(619) 498-6598

From: Evan Ducheny 
Sent: Tuesday, July 10, 2018 4:42 PM
To: Kelly Callies <KellyCallies@chgsd.com>; Ron Ruyeras <rruyeras@chgsd.com>
Subject: RE: Provider Directory Testing 

There is a field in Walter’s hospital tables called ACCREDITATION_QUALITY_REPORT. This field is always NULL in SQLPRODAPP01.INFORMATICS (which is used by the test environment). However, this field contains a URL to www.qualitycheck.org in SQL01.HMOPROD_REPORT (which is used in production). The Provider Directory app constructs an HTML link based on the contents of this field. If the field is NULL, then it puts “N/A” in the link, which causes a 404 error.

-Evan

From: Kelly Callies 
Sent: Tuesday, July 10, 2018 4:11 PM
To: Ron Ruyeras <rruyeras@chgsd.com>
Cc: Evan Ducheny <eduche@chgsd.com>
Subject: RE: Provider Directory Testing 

Hi Evan 
Can you take a look. This does work in prod, we double checked. 

Thank you

Thank you,
Kelly Callies
Sr Business Analyst
Community Health Group
(619) 498-6598

From: Ron Ruyeras 
Sent: Tuesday, July 10, 2018 4:07 PM
To: Kelly Callies <KellyCallies@chgsd.com>
Cc: Evan Ducheny <eduche@chgsd.com>
Subject: RE: Provider Directory Testing 

Accreditation/Quality Report links show 404 error in Hospital search:

Ron Ruyeras
Software Test Engineer
Information Systems
rruyeras@chgsd.com
(619) 498-6495

From: Kelly Callies 
Sent: Tuesday, July 10, 2018 3:31 PM
To: Ron Ruyeras <rruyeras@chgsd.com>
Cc: Maryanne Peralta <MPeral@chgsd.com>; Eric Almirol <EricAlmirol@chgsd.com>
Subject: Provider Directory Testing 

Hi Ron,
Here is a link to the test environment:  http://webtest/providerdirectory/

Here is a link to the production environment: https://www.chgsd.com/ProviderDirectory/SearchDirectory.aspx

Let me know if you have any questions.  

Thank you,
Kelly Callies
Sr Business Analyst
Community Health Group
(619) 498-6598







SELECT DISTINCT FINALlang,[CULTURAL COMPETENCE],AREA_of_PRACTICE FROM INFORMATICS.dbo.PROVDIR_CLINIC
SELECT DISTINCT FINALlang,[CULTURAL COMPETENCE],AREA_of_PRACTICE FROM INFORMATICS.dbo.PROVDIR_PHARM

SELECT DISTINCT FINALlang,[CULTURAL COMPETENCE],AREA_of_PRACTICE FROM INFORMATICS.dbo.PROVDIR_PCP --PROV(s)
SELECT DISTINCT FINALlang,[CULTURAL COMPETENCE],AREA_of_PRACTICE FROM INFORMATICS.dbo.PROVDIR_NPMP --MIDLEVEL(s) NPMP
SELECT DISTINCT FINALlang,[CULTURAL COMPETENCE],AREA_of_PRACTICE FROM INFORMATICS.dbo.PROVDIR_SPE --PROV(s)
SELECT DISTINCT FINALlang,[CULTURAL COMPETENCE],AREA_of_PRACTICE FROM INFORMATICS.dbo.PROVDIR_MH --PROV(s)
SELECT DISTINCT FINALlang,[CULTURAL COMPETENCE],AREA_of_PRACTICE FROM INFORMATICS.dbo.PROVDIR_AHP --PROV(s)
SELECT DISTINCT FINALlang,[CULTURAL COMPETENCE],AREA_of_PRACTICE FROM INFORMATICS.dbo.PROVDIR_VSP --PROV(s)

SELECT DISTINCT FINALlangIS FROM INFORMATICS.dbo.[PROVDIR_FINALlang] --WHERE FINALlangIS NOT LIKE '%ENGL%'







-- ====================================================================
	-- NETWORK REVIEW / RESEARCH ;WITH SQL07.eVips_chgcv. OR 'SQLPRODAPP01.evips_chgcv.dbo.' --
-- ====================================================================
/* x see / REFERENCE 'STEP88_GEOACCESS_PROVGROUP_'...sql AND OR 'PROV_ALERT_'...sql */

-- =====================================================================
	-- INSERT STATEMENTS FOR PROCEDURE HERE:
-- =====================================================================
-- ====================================================================
	--SET PARAMETER(s) / FILTER(s) / ESTABLISH HDR tempdb(s)--
-- ====================================================================
DECLARE @LOB AS nvarchar(5) --DELETE() WHERE UPPER(LTRIM(RTRIM(ISNULL([Participating Network],'')))) = ''
DECLARE @INDIR AS nvarchar(1) --REMOVE FILTER FOR JOSEPH / TIMELYACCESS HBP(s)... '%' OR 'Y'  OR 'N'--SUBSTRING(UPPER(LTRIM(RTRIM(cert_provider.in_directory))),1,1) LIKE @INDIR --see 'LTRIM(RTRIM(mcred.retrieve_list)) LIKE '%CN%V%'
DECLARE @footnotedt AS nvarchar(25)
-- DECLARE @what AS nvarchar(255)
DECLARE @when AS datetime
DECLARE @hospriv AS nvarchar(1)

SET @LOB = 'C%' --'CL%' THEN 'CM%' ELSE 'C%' OR '%' TO CAPTURE ALL (FINAL RUN FOR ONLINE SEARCH()) --'CL1' OR 'CMC' --DELETE() WHERE UPPER(LTRIM(RTRIM(ISNULL([Participating Network],'')))) = ''
SET @INDIR = '%'--REMOVE FILTER FOR JOSEPH / TIMELYACCESS HBP(s)... '%' OR 'Y'  OR 'N'--SUBSTRING(UPPER(LTRIM(RTRIM(cert_provider.in_directory))),1,1) LIKE @INDIR --see 'LTRIM(RTRIM(mcred.retrieve_list)) LIKE '%CN%V%'
SET @footnotedt = 'Last Updated: ' --'Last Updated: 01/27/2017' --PRESET TO NEXT FRIDAY
-- SET @what  = '%SPECIAL%'
SET @when = GETDATE()
SET @hospriv = 'Y' --USE 'Y' TO RETAIN DIRECT HOSPPRIV ONLY WITHIN PROVIDER DIRECTORY / USE 'B' TO RETAIN EITHER OPTION FOR NETWORK ADEQUACY REPORT(s) seeSELECT DISTINCT 'N' AS [USE_HOSPITALIST]...

-- ===================================================================
	-- tmp [TABLE](s)--
-- ===================================================================
------------------------------------------------------------------------------------------------------------------------
	-- Error Trapping: Check If Permanent Table(s) Already Exist(s) And Drop If Applicable --
------------------------------------------------------------------------------------------------------------------------
IF OBJECT_ID('TempDB..#ACCESSIBILITY') IS NOT NULL
BEGIN

		DROP TABLE #ACCESSIBILITY

 END
 
SELECT DISTINCT ServiceTypeName
,CASE
WHEN SUBSTRING(UPPER(LTRIM(RTRIM(vls.ClassOrCategory))),1,1) = 'L'
THEN 'Limited Access'
WHEN SUBSTRING(UPPER(LTRIM(RTRIM(vls.ClassOrCategory))),1,1) = 'B'
THEN 'Basic Access'
ELSE ''
END AS [Accessibility]
,UPPER(LTRIM(RTRIM(vls.ServiceCategoryTypeName))) AS [Accessibility Category(ies)]
,vls.PracticeID,vls.LocationID
INTO #ACCESSIBILITY
-- SELECT * --CHECK 1st
-- SELECT DISTINCT ClassOrCategory --CHECK 1st
-- SELECT DISTINCT ServiceTypeName --CHECK 1st
-- SELECT DISTINCT PracticeTypeName --CHECK 1st
-- SELECT DISTINCT ServiceCategoryTypeName --CHECK 1st
FROM eVips_chgcv.dbo.vwLocationServices AS vls
WHERE UPPER(LTRIM(RTRIM(vls.ServiceTypeName))) LIKE '%SITE%REV%'

					--SELECT * FROM #ACCESSIBILITY







--------------------------------------------------------------------------------------------------------------------
	-- Error Trapping: Check If Permanent Table(s) Already Exist(s) And Drop If Applicable --
--------------------------------------------------------------------------------------------------------------------
IF OBJECT_ID('TempDB..##LIC_FAC') IS NOT NULL
BEGIN

		DROP TABLE ##LIC_FAC --#TableName is a local temporary table visible only in the current session; ##TableName is a global temporary table visible to all sessions IN ('tempdb')

END

SELECT DISTINCT vploc.LocationID,vploc.PracticeID,vploc.AddressID,REPLACE(UPPER(LTRIM(RTRIM(vplic.LicenseNumber))),'-','') AS [CA_LIC]
INTO ##LIC_FAC
--SELECT vploc.Archived,vplic.Archived,vplic.LicenseNumber,vplic.PrimaryLicense,* --CHECK 1st
--SELECT * FROM eVips_chgcv.dbo.vwPracticeLicenses WHERE UPPER(LTRIM(RTRIM(LicenseNumber))) = '090000013' --CHECK 1st 
--SELECT DISTINCT LocationTypeName FROM eVips_chgcv.dbo.vwPracticeLocations --CHECK 1st
FROM eVips_chgcv.dbo.vwPracticeLocations AS vploc
	JOIN eVips_chgcv.dbo.vwPracticeLicenses AS vplic ON  vplic.PracticeID = vploc. PracticeID
		AND vplic.LocationID = vploc. LocationID
		AND vplic.AddressID = vploc. AddressID
WHERE UPPER(LTRIM(RTRIM(vploc.LocationTypeName))) LIKE '%PRACTIC%'
	AND (UPPER(LTRIM(RTRIM(vplic.LicenseTypeName))) LIKE '%LICENSE%'
			OR vplic.LicenseTypeName IS NULL)
	AND vplic.LicenseNumber IS NOT NULL
	AND UPPER(LTRIM(RTRIM(vplic.LicenseNumber))) != ''
	AND UPPER(LTRIM(RTRIM(vplic.PrimaryLicense))) = 'Y'
	AND UPPER(LTRIM(RTRIM(vploc.Archived))) = 'N'
	AND UPPER(LTRIM(RTRIM(vplic.Archived))) = 'N'

					-- SELECT * FROM ##LIC_FAC			






SELECT DISTINCT BoardCertified FROM eVips_chgcv.dbo.vwPractitionerSpecialties

-- ====================================================================
	-- PROV(s) --
-- ====================================================================
-- INTO ##INNETWORK_PROV
SELECT DISTINCT UPPER(LTRIM(RTRIM(vpps.InDirectory))) AS [INDIRECTORY]
,vps.BoardCertified,vps.Archived,vps.BoardName
,CASE
WHEN SUBSTRING(UPPER(LTRIM(RTRIM(ISNULL(vps.BoardCertified,'')))),1,1) IN ('N','E','')  --Per S. Coleman email ON 20180711 '...If it is not applicable, it should be not applicable.  If it is N or null or eligible, it should be NO....'
THEN 'N'
WHEN SUBSTRING(UPPER(LTRIM(RTRIM(ISNULL(vps.BoardCertified,'')))),1,1) != 'N'
AND UPPER(LTRIM(RTRIM(ISNULL(vps.Archived,'')))) IN ('N')  --Per S. Coleman email ON 20171229 '...Board cert status is incorrect ...'
AND vps.BoardName IS NOT NULL               
THEN 'Y'
ELSE 'N'
END AS [BoardCertified(Y/N)]
,CASE
WHEN SUBSTRING(UPPER(LTRIM(RTRIM(ISNULL(vps.BoardCertified,'')))),1,1) IN ('N','E','')  --Per S. Coleman email ON 20180711 '...If it is not applicable, it should be not applicable.  If it is N or null or eligible, it should be NO....'
THEN 'NA'
WHEN SUBSTRING(UPPER(LTRIM(RTRIM(ISNULL(vps.BoardCertified,'')))),1,1) != 'N'
	AND UPPER(LTRIM(RTRIM(ISNULL(vps.Archived,'')))) IN ('N')  --Per S. Coleman email ON 20171229 '...Board cert status is incorrect ...'
THEN UPPER(LTRIM(RTRIM(vps.BoardName))) 
ELSE 'NA'
END AS [BoardName] --[SAMPLE / EXAMPLE] For example see v18422 Dr. Blum: His cert_provider specialties are 'CRV' and 'CET'.  When you link to the master_cred table, it show he is board certified in 'CRV' and not certified in 'CET'.  Since the 'CRV' is YES, you would then link to the board_cert table to see which board.  Please make sure this is a tight join because Dr. Blum is also board certified in INM but this info is not needed.  His board_cert.specialty 'CRV' shows the cert_code AIM which matches to the sys_lookups set name cert_code.  That description is American Board of Internal Medicine. So 'CET' board status would show NO, but his 'CRV' would show YES (American Board of Internal Medicine).  Please call me if you have any questions. Thanks! AND --ADD per MS. K Callies ON 20170323
,vpp.ProductName
,profile.* --APL18-005
,UPPER(LTRIM(RTRIM(vpd.PractitionerID))) AS [lookup_key]
,UPPER(LTRIM(RTRIM(vpp.ProductTypeCode))) AS [plan_type]
,vea.EntityCode
,UPPER(LTRIM(RTRIM(vpd.Archived))) AS [vpdARCHIVED]
,UPPER(LTRIM(RTRIM(vpd.PractitionerStatus))) AS [vpdPRACTITIONERSTATUS]
,UPPER(LTRIM(RTRIM(vpp.Archived))) AS [vppARCHIVED]
,UPPER(LTRIM(RTRIM(vpp.StatusTypeName))) AS [vppSTATUSTYPENAME]
,vpracloc.locationtypename,UPPER(LTRIM(RTRIM(vpracloc.Archived))) AS [vpraclocARCHIVED]
,UPPER(LTRIM(RTRIM(vpd.LastName))) AS LastName,UPPER(LTRIM(RTRIM(vpd.FirstName))) AS FirstName
,SUBSTRING(REPLACE(UPPER(LTRIM(RTRIM(vpd.LastName))),'.','')+', '+REPLACE(UPPER(LTRIM(RTRIM(vpd.FirstName))),'.','')+', '+UPPER(LTRIM(RTRIM(vpd.PractitionerTypeCode))),1,255) AS [INDEXNM]
,acc.[Accessibility] --HARDCODED LIKE VIPs vwLocationServices
,acc.[Accessibility Category(ies)] --HARDCODED LIKE VIPs
,calic.[CA_LIC]
,UPPER(LTRIM(RTRIM(vpd.PractitionerTypeCode))) AS [TypeOfLicensure]
,LTRIM(RTRIM(vpd.NationalProviderID)) AS [NPI]
,UPPER(LTRIM(RTRIM(vpp.PracticeName))) AS [DBA]
,UPPER(LTRIM(RTRIM(vpp.PracticeName))) AS [ASSOCIATION GROUP]
,UPPER(LTRIM(RTRIM(vploc.LocationName))) AS [Clinic Name]
,CASE
WHEN vpps.SpecialtyCode IS NULL
THEN UPPER(LTRIM(RTRIM(vpps.SpecialtyName)))
ELSE UPPER(LTRIM(RTRIM(vpps.SpecialtyCode)))
END AS [DefineOTH_SPE]
,vpps.SpecialtyCode,vpps.SpecialtyName
,UPPER(LTRIM(RTRIM(vpp.ProductTypeName))) AS [PROVIDER_TYPEdescr]
,CASE
WHEN vpp.ProductTypeName LIKE '%AHP%'
THEN 'Allied Health Practitioner' 
WHEN vpp.ProductTypeName LIKE '%HBP%'
THEN 'Hospital Based Provider' 
WHEN vpp.ProductTypeName LIKE '%NP%'
THEN 'Non Physician Medical Practitioner' 
WHEN vpp.ProductTypeName LIKE '%SPE%'
THEN 'Specialist' 
ELSE 'Specialist' 
END AS [PROVIDER_TYPE]
,CASE
WHEN LTRIM(RTRIM(vpp.ProductName)) = 'MEDICAL'
THEN 'CL1'
WHEN LTRIM(RTRIM(vpp.ProductName)) = 'MEDICARE'
THEN 'MCR'
WHEN LTRIM(RTRIM(vpp.ProductName)) = 'CMC'
THEN 'CMC'
ELSE CAST(NULL AS nvarchar(MAX))
END AS [Participating Network]
,UPPER(LTRIM(RTRIM(vploc.LineNumber1))) AS [address1]
,UPPER(LTRIM(RTRIM(vploc.LineNumber2))) AS [address2]
,UPPER(LTRIM(RTRIM(vploc.LineNumber3))) AS [address3]
,CASE
WHEN (UPPER(LTRIM(RTRIM(vploc.LineNumber2))) IN ('')
	OR vploc.LineNumber2 IS NULL)
THEN UPPER(LTRIM(RTRIM(vploc.LineNumber1)))
ELSE UPPER(RTRIM(LTRIM(vploc.LineNumber1)))+' '+UPPER(RTRIM(LTRIM(vploc.LineNumber2)))
END AS [Address]
,UPPER(LTRIM(RTRIM(vploc.City))) AS [CityIs]
,CASE
WHEN UPPER(LTRIM(RTRIM(zip.County))) LIKE 'SD%'
THEN 'SAN DIEGO'
ELSE UPPER(LTRIM(RTRIM(zip.County)))
END AS [CountyIs]
,CASE
WHEN UPPER(LTRIM(RTRIM(zip.County))) LIKE 'SD%'
THEN 'SAN DIEGO'
ELSE UPPER(LTRIM(RTRIM(zip.County)))
END AS [County]
,UPPER(LTRIM(RTRIM(vploc.[State]))) AS StateIs
,CASE
WHEN SUBSTRING(LTRIM(RTRIM(vploc.ZipCode)),1,1) = '0'
THEN '0'+ SUBSTRING(LTRIM(RTRIM(vploc.ZipCode)),2,4)
WHEN SUBSTRING(LTRIM(RTRIM(vploc.ZipCode)),1,1) = '00'
THEN '00'+ SUBSTRING(LTRIM(RTRIM(vploc.ZipCode)),3,3)
ELSE  SUBSTRING(LTRIM(RTRIM(vploc.ZipCode)),1,5) 
END AS [ZIP]
,UPPER(LTRIM(RTRIM(ISNULL(regionis.RegionTypeName,'')))) AS [REGION]
,[Telephone Number] = SUBSTRING(LTRIM(RTRIM(PHONEprimary.PhoneNumber)),1,3)+'-'+SUBSTRING(LTRIM(RTRIM(PHONEprimary.PhoneNumber)),4,3)+'-'+SUBSTRING(LTRIM(RTRIM(PHONEprimary.PhoneNumber)),7,4)
,[FAXnumber] = SUBSTRING(LTRIM(RTRIM(PHONEfax.PhoneNumber)),1,3)+'-'+SUBSTRING(LTRIM(RTRIM(PHONEfax.PhoneNumber)),4,3)+'-'+SUBSTRING(LTRIM(RTRIM(PHONEfax.PhoneNumber)),7,4) -- ,*
-- INTO ##INNETWORK_PROV
-- SELECT *  --CHECK 1st
-- SELECT DISTINCT UPPER(LTRIM(RTRIM(vpps.InDirectory))) AS [INDIRECTORY],,UPPER(LTRIM(RTRIM(vpd.LastName))) AS LastName ,UPPER(LTRIM(RTRIM(vpd.FirstName))) AS FirstName,UPPER(LTRIM(RTRIM(vploc.LineNumber1))) AS [address1] --CHECK 1st
FROM eVips_chgcv.dbo.vwPractitionerDemographics AS vpd
	JOIN eVips_chgcv.dbo.vwPractitionerProducts AS vpp ON UPPER(LTRIM(RTRIM(vpp.PractitionerID))) = UPPER(LTRIM(RTRIM(vpd.PractitionerID))) --aka cert_provider
		-- AND UPPER(LTRIM(RTRIM(vpp.ProductID))) = UPPER(LTRIM(RTRIM(vpps.ProductID))) --aka cert_provider
	JOIN eVips_chgcv.dbo.vwPractitionerProductSpecialties AS vpps ON UPPER(LTRIM(RTRIM(vpps.PractitionerProductRecID))) = UPPER(LTRIM(RTRIM(vpp.PractitionerProductRecID)))
		LEFT JOIN eVips_chgcv.dbo.vwPractitionerSpecialties AS vps ON UPPER(LTRIM(RTRIM(vps.PractitionerID))) = UPPER(LTRIM(RTRIM(vpd.PractitionerID)))	
			AND UPPER(LTRIM(RTRIM(vps.specialtycode))) = UPPER(LTRIM(RTRIM(vpps.specialtycode)))
		LEFT JOIN (SELECT DISTINCT ProviderID,TableName,EntityCode,EntityName,EntityTypeCode,EntityTypeName FROM eVips_chgcv.dbo.vwEntityAssignments WHERE UPPER(LTRIM(RTRIM(TableName))) LIKE '%Practit%') AS vea ON UPPER(LTRIM(RTRIM(vea.ProviderID))) = UPPER(LTRIM(RTRIM(vpd.PractitionerID))) --ProviderID = PractitionerID WHERE UPPER(LTRIM(RTRIM(vea.TableName))) LIKE '%Practit%' OR  ProviderID = PracticeID WHERE UPPER(LTRIM(RTRIM(vea.TableName))) LIKE '%Practice%'
	JOIN (SELECT DISTINCT vpprovloc.PractitionerID,vpprovloc.PracticeID,vpprovloc.LocationID,vpprovloc.AddressID,vpprovloc.LastName,vpprovloc.FirstName,vpprovloc.Archived,vpprovloc.LocationName,vpprovloc.NationalProviderID,vpprovloc.LocationNotes,vpprovloc.PracticeTypeName,vpprovloc.ProviderNumber,vpprovloc.website,vpfacloc.LineNumber1,vpfacloc.LineNumber2,vpfacloc.LineNumber3,vpfacloc.City,vpfacloc.[State],vpfacloc.ZipCode,vpfacloc.LocationTypeName FROM eVips_chgcv.dbo.vwPractitionerLocations AS vpprovloc 	JOIN eVips_chgcv.dbo.vwPracticeLocations AS vpfacloc ON UPPER(LTRIM(RTRIM(vpfacloc.PracticeID))) = UPPER(LTRIM(RTRIM(vpprovloc.PracticeID))) 		AND UPPER(LTRIM(RTRIM(vpfacloc.LocationID))) = UPPER(LTRIM(RTRIM(vpprovloc.LocationID))) WHERE UPPER(LTRIM(RTRIM(ISNULL(vpfacloc.LocationTypeName,'')))) LIKE '%PRACTI%') AS vploc ON UPPER(LTRIM(RTRIM(vploc.PractitionerID))) = UPPER(LTRIM(RTRIM(vpd.PractitionerID)))
		AND UPPER(LTRIM(RTRIM(vploc.PracticeID))) = UPPER(LTRIM(RTRIM(vpp.PracticeID)))
		AND UPPER(LTRIM(RTRIM(vploc.LocationID))) = UPPER(LTRIM(RTRIM(vpp.LocationID)))
		-- AND UPPER(LTRIM(RTRIM(vploc.AddressID))) = UPPER(LTRIM(RTRIM(vpp.AddressID)))
	JOIN eVips_chgcv.dbo.vwPracticeLocations AS vpracloc ON vpracloc.practiceid = vpp.practiceid  --SPECIAL ADD - ON JOIN (s)
		AND vpracloc.Locationid = vpp.Locationid --SPECIAL ADD - ON JOIN (s)

			LEFT JOIN INFORMATICS.dbo.ZIP_CODES AS zip ON SUBSTRING(LTRIM(RTRIM(zip.ZipCode)),1,5) COLLATE DATABASE_DEFAULT = CASE
WHEN SUBSTRING(LTRIM(RTRIM(vploc.ZipCode)),1,1) = '0'
THEN '0'+ SUBSTRING(LTRIM(RTRIM(vploc.ZipCode)),2,4)
WHEN SUBSTRING(LTRIM(RTRIM(vploc.ZipCode)),1,1) = '00'
THEN '00'+ SUBSTRING(LTRIM(RTRIM(vploc.ZipCode)),3,3)
ELSE  SUBSTRING(LTRIM(RTRIM(vploc.ZipCode)),1,5) 
END COLLATE DATABASE_DEFAULT --FORMERLY SQL01.DEV_DB.dbo.ZIP_CODES
		LEFT JOIN (SELECT DISTINCT zipcode,city,county,RegionTypeName FROM eVips_chgcv.dbo.vwzipcodes WHERE UPPER(LTRIM(RTRIM(ISNULL(county,'')))) LIKE '%SAN%DIEGO%') AS regionis ON CASE WHEN SUBSTRING(LTRIM(RTRIM(regionis.ZipCode)),1,1) = '0' THEN '0'+ SUBSTRING(LTRIM(RTRIM(regionis.ZipCode)),2,4) WHEN SUBSTRING(LTRIM(RTRIM(regionis.ZipCode)),1,1) = '00' THEN '00'+ SUBSTRING(LTRIM(RTRIM(regionis.ZipCode)),3,3) ELSE  SUBSTRING(LTRIM(RTRIM(regionis.ZipCode)),1,5) END = CASE WHEN SUBSTRING(LTRIM(RTRIM(vploc.ZipCode)),1,1) = '0' THEN '0'+ SUBSTRING(LTRIM(RTRIM(vploc.ZipCode)),2,4) WHEN SUBSTRING(LTRIM(RTRIM(vploc.ZipCode)),1,1) = '00' THEN '00'+ SUBSTRING(LTRIM(RTRIM(vploc.ZipCode)),3,3) ELSE  SUBSTRING(LTRIM(RTRIM(vploc.ZipCode)),1,5) END
		LEFT JOIN (SELECT DISTINCT r.FieldName,r.DisplayName,s.specialtycode,s.specialtyName AS [eVIPS_Specialty],r.Value AS [TIMELYACCESS_Profile] FROM evips_chgcv.dbo.vwReferenceUserFields AS r LEFT JOIN evips_chgcv.dbo.vwSpecialties AS s on s.specialtyid = r.ParentRecID WHERE r.tablename = 'Specialties' AND r.fieldName = 'Specialty Grouping - Timely Access') AS profile ON UPPER(LTRIM(RTRIM(ISNULL(profile.specialtycode,'')))) = CASE
WHEN vpps.SpecialtyCode IS NULL
THEN UPPER(LTRIM(RTRIM(vpps.SpecialtyName)))
ELSE UPPER(LTRIM(RTRIM(vpps.SpecialtyCode)))
END -- AS [DefineOTH_SPE]

		LEFT JOIN (SELECT DISTINCT LocationID,PracticeID,LTRIM(RTRIM(PhoneNumber)) AS [PhoneNumber] FROM eVips_chgcv.dbo.vwLocationPhones WHERE UPPER(LTRIM(RTRIM(PhoneTypeName))) LIKE '%PRIMAR%') AS PHONEprimary ON PHONEprimary.practiceid = vpp.practiceid  --PHONE ADD - ON JOIN (s)
			AND PHONEprimary.Locationid= vpp.Locationid --PHONE ADD - ON JOIN (s)

		LEFT JOIN (SELECT DISTINCT LocationID,PracticeID,LTRIM(RTRIM(PhoneNumber)) AS [PhoneNumber] FROM eVips_chgcv.dbo.vwLocationPhones WHERE UPPER(LTRIM(RTRIM(PhoneTypeName))) LIKE '%FAX%') AS PHONEfax ON PHONEfax.practiceid = vpp.practiceid  --PHONE ADD - ON JOIN (s)
			AND PHONEfax.Locationid= vpp.Locationid --FAX ADD - ON JOIN (s)

		LEFT JOIN (SELECT DISTINCT vploc.PractitionerID AS [lookup_key],REPLACE(UPPER(LTRIM(RTRIM(vplic.LicenseNumber))),'-','') AS [CA_LIC] FROM eVips_chgcv.dbo.vwPractitionerLocations AS vploc 	JOIN eVips_chgcv.dbo.vwPractitionerLicenses AS vplic ON  vplic.PractitionerID = vploc. PractitionerID WHERE (UPPER(LTRIM(RTRIM(vplic.LicenseTypeName))) LIKE '%LICENSE%' 			OR vplic.LicenseTypeName IS NULL) 	AND vplic.LicenseNumber IS NOT NULL 	AND UPPER(LTRIM(RTRIM(vplic.LicenseNumber))) != '' 	AND UPPER(LTRIM(RTRIM(vplic.PrimaryLicense))) = 'Y' 	AND UPPER(LTRIM(RTRIM(vploc.Archived))) = 'N' 	AND UPPER(LTRIM(RTRIM(vplic.Archived))) = 'N') AS calic ON UPPER(LTRIM(RTRIM(ISNULL(calic.lookup_key,'')))) = UPPER(LTRIM(RTRIM(ISNULL(vpd.PractitionerID,'')))) --see INTO ##LIC_PROV

				LEFT JOIN #ACCESSIBILITY AS acc ON UPPER(LTRIM(RTRIM(acc.PracticeID))) = UPPER(LTRIM(RTRIM(vpp.PracticeID)))
				AND UPPER(LTRIM(RTRIM(acc.LocationID))) = UPPER(LTRIM(RTRIM(vpp.LocationID)))
				
WHERE ((LTRIM(RTRIM(ISNULL(vpps.InDirectory,''))) LIKE @INDIR --SET @INDIR ='Y'--REMOVE FILTER FOR JOSEPH / TIMELYACCESS HBP(s)... '%' OR 'Y'  OR 'N'--SUBSTRING(UPPER(LTRIM(RTRIM(cert_provider.in_directory))),1,1) LIKE @INDIR --see 'LTRIM(RTRIM(mcred.retrieve_list)) LIKE '%CN%V%'
	AND UPPER(LTRIM(RTRIM(vpd.Archived))) IN ('N') --WITH eVIPS LOGICAL BINARY OPTION(s) IN USE •	Must not be archived 
	AND UPPER(LTRIM(RTRIM(vpps.Archived))) IN ('N') -- ADD ON per MEETING ;WITH YOUNG LADY LAURA, SC & HL ON 20171226
	AND UPPER(LTRIM(RTRIM(vploc.Archived))) IN ('N') --WITH eVIPS LOGICAL BINARY OPTION(s) IN USE •	Must not be archived
	AND UPPER(LTRIM(RTRIM(vpracloc.Archived))) IN ('N')
	AND (UPPER(LTRIM(RTRIM(vpd.PractitionerStatus))) IN ('ACTIVE') --•	Overall Status must be Active
		OR vpd.PractitionerStatus IS NULL)
	AND UPPER(LTRIM(RTRIM(vpp.Archived))) IN ('N') --WITH eVIPS LOGICAL BINARY OPTION(s) IN USE •	Must not be archived 
	AND (UPPER(LTRIM(RTRIM(vpp.StatusTypeName))) IN ('Y') --•	Plan Status must be: ‘Active’ or ‘Active Per Diem’ or Active VIP for a Product Name (CMC or MEDICAL):
		OR UPPER(LTRIM(RTRIM(vpp.StatusTypeName))) LIKE 'ACTIV%' --•	Plan Status must be: ‘Active’ or ‘Active Per Diem’ or Active VIP for a Product Name (CMC or MEDICAL):
		OR vpp.StatusTypeName IS NULL)) --CONCLUDE REGULAR PROVIDER 'IN NETWORK / IN DIRECTORY LOGIC'
	----------------AND UPPER(LTRIM(RTRIM(vea.TableName))) LIKE '%PRACTIT%') --ARRIVE AT ENTITY TYPE(s) FROM PROVDIR MEETING ON 20170920 SPECIFICALLY TO ID VSP PROV(s) ... --ProviderID = PractitionerID WHERE UPPER(LTRIM(RTRIM(vea.TableName))) LIKE '%Practit%' OR  ProviderID = PracticeID WHERE UPPER(LTRIM(RTRIM(vea.TableName))) LIKE '%Practice%'
OR (UPPER(LTRIM(RTRIM(vpp.StatusTypeName))) IN ('V') --JOSEPH 'SPECIAL' PROVIDER(s) LOGIC
	OR UPPER(LTRIM(RTRIM(vpp.StatusTypeName))) LIKE '%ACT%VIP%')) --JOSEPH 'SPECIAL' PROVIDER(s) LOGIC

AND LTRIM(RTRIM(vpd.NationalProviderID)) IN ('1649699968')







'DIRECTORY FIX'(es) -  Hi Walter,  We only have a couple of weeks left for VIPs.  Please make sure the address is a factor for the eVIPs directory.  We have many docs that have different age restrictions, panel status for different addresses and affiliations.  Another way to say it, a provider can be at more than one address for an affiliation and each address has different panel status, specialty, age restriction and provider type.  Thanks! - 'DONE'

x Hi,  We changed the specialty for Minute clinics and PPHexpresscre in eVIPs only to Retail Clinics.  eVIP’s directory for urgent care & retail clinics should look like this.

Urgent Care Centers
Retail Clinics
					Minute Clinics - see 'Retail Clinics - Minute Clinics'
					PPHExpresscare - see 'Retail Clinics - PPHExpresscare'
					
SELECT * FROM INFORMATICS.dbo.PROVDIR_MIN --MINUTE CLINIC(s)
SELECT * FROM INFORMATICS.dbo.PROVDIR_PPH --PPH (Palomar Pomerado Healthcare) EXPRESS					

x Hi,  This record looks okay on the front end.  Please let us know what field we missed to have it show in the eVIPs directory.  Thanks!
					practiceid IN ('4299898') --GROSSMONT PLAZA SURGERY NPIis = '1528041811'

WHERE (vp.Archived IN ('N') --WITH eVIPS LOGICAL BINARY OPTION(s) IN USE •	Must not be archived 
	AND (vp.PracticeStatus IN ('ACTIVE','CONTRACTED','NA') --•	Contract Status must be Active
		OR vp.PracticeStatus IS NULL)
	AND (vp.ApplicationStatus IN ('ACTIVE','CONTRACTED','NA') --•	Application Status must be contractedarchived
		OR vp.ApplicationStatus IS NULL)		
	AND vpl.Archived IN ('N')) --WITH eVIPS LOGICAL BINARY OPTION(s) IN USE •	Must not be archived
 
	AND UPPER(LTRIM(RTRIM(vp.PracticeID))) IN ('4299898') --GROSSMONT PLAZA SURGERY NPIis = '1528041811'
	
x Please adjust the logic to exclude the application status for facilities.  The overall status must be ACTIVE but if we credential the facility, the app status will change every 3 years.	
	 /* AND (vp.ApplicationStatus IN ('ACTIVE','CONTRACTED','NA') --•	Application Status must be contractedarchived
		 OR vp.ApplicationStatus IS NULL) -- AS OF 20180613 per email FROM MS. SANDRA Please adjust the logic to exclude the application status for facilities.  The overall status must be ACTIVE but if we credential the facility, the app status will change every 3 years.*/







'CLINIC QNXT #(s) IN eVIPS' - Hi,  The QNXT number for community clinic pcp sites are located in the practice alt id tab.  

Table:  vwPracticeAlternateIDs
AlternateIDTypeName = QNXT
Field = IDNumber







SELECT mcred.lookup_key,age_restriction,age_restriction2,address.[address1],UPPER(LTRIM(RTRIM(address.city))) AS CityIs,CASE
WHEN SUBSTRING(LTRIM(RTRIM(address.zip)),1,1) = '0'
THEN '0'+ SUBSTRING(LTRIM(RTRIM(address.zip)),2,4)
WHEN SUBSTRING(LTRIM(RTRIM(address.zip)),1,1) = '00'
THEN '00'+ SUBSTRING(LTRIM(RTRIM(address.zip)),3,3)
ELSE  SUBSTRING(LTRIM(RTRIM(address.zip)),1,5) 
END AS [Zip Code]
,CASE
WHEN LTRIM(RTRIM(cert_provider.plan_name)) = 'MEDICAL'
THEN 'CL1'
WHEN LTRIM(RTRIM(cert_provider.plan_name)) = 'MEDICARE'
THEN 'MCR'
WHEN LTRIM(RTRIM(cert_provider.plan_name)) = 'CMC'
THEN 'CMC'
ELSE CAST(NULL AS nvarchar(MAX))
END AS [Participating Network],*
FROM VIP.dbo.master_cred AS mcred
	JOIN VIP.dbo.cert_provider ON cert_provider.lookup_key  = mcred.lookup_key --LOOK to lookup_key for LINK(s)
	JOIN VIP.dbo.address ON address.lookup_name = cert_provider.group_name
	JOIN VIP.dbo.entity_master AS em ON LTRIM(RTRIM(em.Entity_name)) = LTRIM(RTRIM(cert_provider.Deligated_Entity))
WHERE UPPER(LTRIM(RTRIM(ISNULL(mcred.lookup_key,'')))) IN ('271') --NPI: '1356319446'
ORDER BY cert_provider.age_restriction

SELECT [AGE RESTRICTION],[Clinic Name],NPIis,[Participating Network],Specialty,CityIs,[Zip Code],* FROM INFORMATICS.dbo.PROVDIR_SPE WHERE lookup_key IN ('271')

------------------------------------------------------------------------------------------------------------------------
	-- Error Trapping: Check If Permanent Table(s) Already Exist(s) And Drop If Applicable --
------------------------------------------------------------------------------------------------------------------------
IF OBJECT_ID('TempDB..#AGERESTRICTION_PROV') IS NOT NULL
BEGIN

		DROP TABLE #AGERESTRICTION_PROV

 END
 
SELECT DISTINCT pp.LastName,pp.FirstName,vppl.PractitionerID,vppl.ProductID,vppl.MinimumAge,vppl.MaximumAge --,vppl.LocationID,vppl.AddressID
 ,[AGE RESTRICTION] = CASE --QUPD / CASE WHEN THEN ELSE EN... USE pcp.MinimumAge AND pcp.age-restriction2
WHEN LTRIM(RTRIM(ISNULL(vppl.MinimumAge,'0'))) = '21'
	AND LTRIM(RTRIM(ISNULL(vppl.MaximumAge,'0'))) = '999'
THEN '21 AND OVER'
WHEN LTRIM(RTRIM(ISNULL(vppl.MinimumAge,'0'))) = '18'
	AND LTRIM(RTRIM(ISNULL(vppl.MaximumAge,'0'))) = '999'
THEN '18 AND OVER'
WHEN LTRIM(RTRIM(ISNULL(vppl.MinimumAge,'0'))) = '0'
	AND LTRIM(RTRIM(ISNULL(vppl.MaximumAge,'0'))) = '18'
THEN 'UP TO 18' --Per S. Coleman ON 20160809 Please review the following for this provider. Cohenmeyer  132285     SPE  92123  Age Restrictions should show 0 – 18
WHEN LTRIM(RTRIM(ISNULL(vppl.MinimumAge,'0'))) = '0'
	AND LTRIM(RTRIM(ISNULL(vppl.MaximumAge,'0'))) != '999'
THEN 'UP TO '+LTRIM(RTRIM(ISNULL(vppl.MaximumAge,'0')))
WHEN LTRIM(RTRIM(ISNULL(vppl.MinimumAge,'0'))) != '0' -- NO NOT NEGATIVE <> != ...
	AND LTRIM(RTRIM(ISNULL(vppl.MaximumAge,'0'))) = '999'
THEN LTRIM(RTRIM(ISNULL(vppl.MinimumAge,'0')))+' AND OVER'
WHEN LTRIM(RTRIM(ISNULL(vppl.MinimumAge,'0'))) != '0' -- NO NOT NEGATIVE <> != ...
	AND LTRIM(RTRIM(ISNULL(vppl.MaximumAge,'0'))) != '999'
THEN LTRIM(RTRIM(ISNULL(vppl.MinimumAge,'0')))+' TO '+LTRIM(RTRIM(ISNULL(vppl.MaximumAge,'0')))
ELSE 'NONE'
END --CHANGE OF OPTION(s) per S. Coleman ON 20170103
--INTO #AGERESTRICTION_PROV
-- SELECT * --CHECK 1st
-- SELECT DISTINCT ISNULL(MinimumAge,'0') AS [MINAGE],ISNULL(MaximumAge,'0') AS [MAXAGE] --CHECK 1st
FROM eVips_chgcv.dbo.vwPractitionerProductLimitations AS vppl --OR vwLocationProductLimitations
	JOIN  eVips_chgcv.dbo.vwPractitionerProducts AS pp on pp.PractitionerProductRecID = vppl.PractitionerProductRecID
WHERE UPPER(LTRIM(RTRIM(vppl.LimitationtypeName))) LIKE '%AGE%' --WHERE LimitationtypeName LIKE '%Age%' 
	-- AND vppl.PractitionerID IN ('4394031','4396103') --TEST PROVIDER(s)
	AND pp.archived = 'N'
	AND vppl.archived = 'N'
	AND vppl.PractitionerID IN ('4390502')

	
	
	
	
	
	
'eVIPS' - Hi Walter,  We are in the process of doing our final reviews for facilities and pharmacies.  I think a tighter join is need for the facility licenses.

2 facilities fall under the same DBA California Reliable Medical Systems.  One is Elm ADHC & the other is Golden Life ADHC.  They have different license numbers.  The eVIPs directory is pulling the Elm license # for both.

Please adjust for the next eVIPs print.  Thanks!

--------------------------------------------------------------------------------------------------------------------
	-- Error Trapping: Check If Permanent Table(s) Already Exist(s) And Drop If Applicable --
--------------------------------------------------------------------------------------------------------------------
IF OBJECT_ID('TempDB..##LIC_FAC') IS NOT NULL
BEGIN

		DROP TABLE ##LIC_FAC --#TableName is a local temporary table visible only in the current session; ##TableName is a global temporary table visible to all sessions IN ('tempdb')

END

SELECT DISTINCT vploc.LocationID,vploc.PracticeID,vploc.AddressID,REPLACE(UPPER(LTRIM(RTRIM(vplic.LicenseNumber))),'-','') AS [CA_LIC]
INTO ##LIC_FAC
--SELECT vploc.Archived,vplic.Archived,vplic.LicenseNumber,vplic.PrimaryLicense,* --CHECK 1st
--SELECT * FROM eVips_chgcv.dbo.vwPracticeLicenses WHERE UPPER(LTRIM(RTRIM(LicenseNumber))) = '090000013' --CHECK 1st 
--SELECT DISTINCT LocationTypeName FROM eVips_chgcv.dbo.vwPracticeLocations --CHECK 1st
FROM eVips_chgcv.dbo.vwPracticeLocations AS vploc
	JOIN eVips_chgcv.dbo.vwPracticeLicenses AS vplic ON  vplic.PracticeID = vploc. PracticeID
		AND vplic.LocationID = vploc. LocationID
		AND vplic.AddressID = vploc. AddressID
WHERE UPPER(LTRIM(RTRIM(vploc.LocationTypeName))) LIKE '%PRACTIC%'
	AND (UPPER(LTRIM(RTRIM(vplic.LicenseTypeName))) LIKE '%LICENSE%'
			OR vplic.LicenseTypeName IS NULL)
	AND vplic.LicenseNumber IS NOT NULL
	AND UPPER(LTRIM(RTRIM(vplic.LicenseNumber))) != ''
	AND UPPER(LTRIM(RTRIM(vplic.PrimaryLicense))) = 'Y'
	AND UPPER(LTRIM(RTRIM(vploc.Archived))) = 'N'
	AND UPPER(LTRIM(RTRIM(vplic.Archived))) = 'N'

					--SELECT * FROM ##LIC_FAC
					
--------------------------------------------------------------------------------------------------------------------
	-- Error Trapping: Check If Permanent Table(s) Already Exist(s) And Drop If Applicable --
--------------------------------------------------------------------------------------------------------------------
IF OBJECT_ID('TempDB..##LIC_PROV') IS NOT NULL
BEGIN

		DROP TABLE ##LIC_PROV --#TableName is a local temporary table visible only in the current session; ##TableName is a global temporary table visible to all sessions IN ('tempdb')

END

SELECT DISTINCT vploc.PractitionerID AS [lookup_key],REPLACE(UPPER(LTRIM(RTRIM(vplic.LicenseNumber))),'-','') AS [CA_LIC]
INTO ##LIC_PROV
--SELECT vploc.Archived,vplic.Archived,vplic.LicenseNumber,vplic.PrimaryLicense,* --CHECK 1st
--SELECT * FROM eVips_chgcv.dbo.vwPractitionerLicenses --CHECK 1st 
--SELECT DISTINCT LocationTypeName FROM eVips_chgcv.dbo.vwPractitionerLocations --CHECK 1st
FROM eVips_chgcv.dbo.vwPractitionerLocations AS vploc
	JOIN eVips_chgcv.dbo.vwPractitionerLicenses AS vplic ON  vplic.PractitionerID = vploc. PractitionerID
WHERE (UPPER(LTRIM(RTRIM(vplic.LicenseTypeName))) LIKE '%LICENSE%'
			OR vplic.LicenseTypeName IS NULL)
	AND vplic.LicenseNumber IS NOT NULL
	AND UPPER(LTRIM(RTRIM(vplic.LicenseNumber))) != ''
	AND UPPER(LTRIM(RTRIM(vplic.PrimaryLicense))) = 'Y'
	AND UPPER(LTRIM(RTRIM(vploc.Archived))) = 'N'
	AND UPPER(LTRIM(RTRIM(vplic.Archived))) = 'N'

					--SELECT * FROM ##LIC_PROV
					
UPDATE ##INNETWORK_FAC
SET [CA_License] = UPPER(LTRIM(RTRIM(qupd.[CA_LIC])))
-- SELECT TOP 100 * --CHECK 1st
-- SELECT DISTINCT --CHECK 1st
FROM ##INNETWORK_FAC AS inet
	JOIN ##LIC_FAC AS qupd ON UPPER(LTRIM(RTRIM(ISNULL(qupd.PracticeID,'')))) = UPPER(LTRIM(RTRIM(ISNULL(inet.PracticeID,''))))
		AND UPPER(LTRIM(RTRIM(ISNULL(qupd.LocationID,'')))) = UPPER(LTRIM(RTRIM(ISNULL(inet.LocationID,''))))
		AND UPPER(LTRIM(RTRIM(ISNULL(qupd.AddressID,'')))) = UPPER(LTRIM(RTRIM(ISNULL(inet.AddressID,''))))
--WHERE inet.[CA_License] IS NULL

UPDATE ##INNETWORK_FAC
SET [CA_License] = UPPER(LTRIM(RTRIM(qupd.[CA_LIC])))
-- SELECT TOP 100 * --CHECK 1st
-- SELECT DISTINCT --CHECK 1st
FROM ##INNETWORK_FAC AS inet
	JOIN ##LIC_FAC AS qupd ON UPPER(LTRIM(RTRIM(ISNULL(qupd.PracticeID,'')))) = UPPER(LTRIM(RTRIM(ISNULL(inet.PracticeID,''))))
		AND UPPER(LTRIM(RTRIM(ISNULL(qupd.LocationID,'')))) = UPPER(LTRIM(RTRIM(ISNULL(inet.LocationID,''))))
		-- AND UPPER(LTRIM(RTRIM(ISNULL(qupd.AddressID,'')))) = UPPER(LTRIM(RTRIM(ISNULL(inet.AddressID,''))))
WHERE inet.[CA_License] IS NULL

UPDATE ##INNETWORK_FAC
SET [CA_License] = UPPER(LTRIM(RTRIM(qupd.[CA_LIC])))
-- SELECT TOP 100 * --CHECK 1st
-- SELECT DISTINCT --CHECK 1st
FROM ##INNETWORK_FAC AS inet
	JOIN ##LIC_FAC AS qupd ON UPPER(LTRIM(RTRIM(ISNULL(qupd.PracticeID,'')))) = UPPER(LTRIM(RTRIM(ISNULL(inet.PracticeID,''))))
		-- AND UPPER(LTRIM(RTRIM(ISNULL(qupd.LocationID,'')))) = UPPER(LTRIM(RTRIM(ISNULL(inet.LocationID,''))))
		-- AND UPPER(LTRIM(RTRIM(ISNULL(qupd.AddressID,'')))) = UPPER(LTRIM(RTRIM(ISNULL(inet.AddressID,''))))
WHERE inet.[CA_License] IS NULL

					UPDATE ##INNETWORK_FAC
					SET [CA_License] = 'NA' --CA License MISSING LINK(s) FOR SYCUAN MEDICAL DENTAL CENTER - NO ALPHA(s) DESIRED...per DISCUSSION ON 20170320
					-- SELECT DISTINCT NPIis,[Clinic Name],CA_License 
					FROM ##INNETWORK_FAC
					WHERE LTRIM(RTRIM(NPIis)) IN ('1427197078','1235280223','1417026758') --per MS. E. Martinez & DMHC (KRAL) confirmation ON 20170321 FOR [SOUTHERN INDIAN HEALTH COUNCIL] AND [SYCUAN MEDICAL DENTAL CENTER] (the Indian exclusion) ...Hello Elizabeth, The validation tool for the Timely Access portal has been updated to accept NA for CA License in the Clinics template.  Please report these two clinics. Please let me know if you have any other questions. Jeff KRAL

UPDATE ##INNETWORK_PROV
SET [CA_License] = UPPER(LTRIM(RTRIM(qupd.[CA_LIC])))
-- SELECT TOP 100 * --CHECK 1st
-- SELECT DISTINCT --CHECK 1st
FROM ##INNETWORK_PROV AS inet
	JOIN ##LIC_PROV AS qupd ON UPPER(LTRIM(RTRIM(ISNULL(qupd.lookup_key,'')))) = UPPER(LTRIM(RTRIM(ISNULL(inet.lookup_key,''))))
--WHERE inet.[CA_License] IS NULL			







'PROVDIR' - ON 20180508
x CMS FINDING(s) WALK THROUGH - CHIME IN ON
x 'CHANGE'(s) TO  [FIELD] AS [CULTURAL COMP] 'NONE' FOR DFLT(s) SHOW REGARDLESS
x 'CHANGE'(s) TO  [FIELD] AS [ADDITIONAL TRAININIG] aka [AREA_OF_PRACTICE] 'NONE' FOR DFLT(s) SHOW REGARDLESS???
x LANGUAGE FROM CHARLES TO ADDR SOME OF THE HEADER(s) / FOOTER(s) 
x CHANGE(s) TO 88 120 Languages ADD ', including ASL' POTENTIALLY ADD [LANGUAGE] [FIELD](s) FOR FAC(s)
x BUILD CHAPTER COUNT [TABLE]
x LIKE '%PRAC%' ON PHARM(s) LOGIC

						Element 2.4
						•	Cultural Competence Training
						•	PDF displays if there is a value
						•	Recommend
						•	"Cultural Competency:" + type of training
						•	"Cultural Competency: None"
						•	Walter to update PDF
						
x SEARCH(): SCRIPT
				'INTO ##INNET'
				'INTO INFORMATICS.dbo.Timely'
				'INTO INFORMATICS.dbo.PROVDIR_'







'PROVDIR FOOTNOTE UPDATE'(s) - Hi,  Re: Handicap accessibility code  There is a new handicap accessibility code “PD” that will be listed in the printed and online directories.  We will start capturing this information.  The footnotes will need to be updated in the pdf and online.

PD = PATIENT DIAGNOSTIC & TREATMENT  USE

Please place this in the footer after restroom (. . . R-Restroom', PD-Patient Diagnostic & Treatment Use,' E-Exam Room . . .)

						', PD-Patient Diagnostic & Treatment Use,'

JAH 'PROVDIR' - ONLINE AND CODE
x Hi,  This is an agenda item for the Provider Directory Team next week.  There is a new handicap accessibility code “PD” that will be listed in the printed and online directories.  I know Credentialing will need to add the code to start capturing this information.  The footnote will also need to be updated.  Let’s discuss this next week.  Thanks!

*   Not Accepting new patients at this time
+ Per Diem / Part Time Provider - May Have Limited Appt. Availability
++ Clinic Specialists - for Assigned Members Only
^ Services are provided in the home
** Over 120 languages are spoken by medical staff or interpreters.

If you have questions, please call CommuniCare Advantage Cal MediConnect Plan at 1-888-244-4430, TTY/TDD: 1-855-266-4584, 24 hours a day, seven days a week. The call is free.  For more information, visit www.chgsd.com. Accessibility Codes: P-Parking, EB-Exterior Building, IB-Interior Building, W-Wheelchair, R-Restroom, PD-Patient Diagnostic & Treatment Use, E-Exam Room & T-Exam Table/Scale

WAS /* 'Accessibility Codes: P-Parking, EB-Exterior Building, IB-Interior Building, W-Wheelchair, R-Restroom, E-Exam Room & T-Exam Table/Scale' */ NOW() 'Accessibility Codes: P-Parking, EB-Exterior Building, IB-Interior Building, W-Wheelchair, R-Restroom, PD-Patient Diagnostic & Treatment Use, E-Exam Room & T-Exam Table/Scale'

~ Not available to all CHG Members
*  Extended Supply Pharmacy
^ Compound Pharmacy
+ Home Delivery Available
@ Drive - Thru Available

If you have questions, please call CommuniCare Advantage Cal MediConnect Plan at 1-888-244-4430, TTY/TDD: 1-855-266-4584, 24 hours a day, seven days a week. The call is free.  For more information, visit www.chgsd.com. Accessibility Codes: P-Parking, EB-Exterior Building, IB-Interior Building, W-Wheelchair, R-Restroom, PD-Patient Diagnostic & Treatment Use, E-Exam Room & T-Exam Table/Scale

WAS /* 'Accessibility Codes: P-Parking, EB-Exterior Building, IB-Interior Building, W-Wheelchair, R-Restroom, E-Exam Room & T-Exam Table/Scale' */ NOW() 'Accessibility Codes: P-Parking, EB-Exterior Building, IB-Interior Building, W-Wheelchair, R-Restroom, PD-Patient Diagnostic & Treatment Use, E-Exam Room & T-Exam Table/Scale'

*   Not Accepting new patients at this time
** See list of hospitals on page 1368
+ Per Diem / Part Time Provider - May Have Limited Appt. Availability
++ Clinic Specialists - for Assigned Members Only
@ After Hours Telephone Number is the same as Daytime Number

Accessibility Codes: P-Parking, EB-Exterior Building, IB-Interior Building, W-Wheelchair, R-Restroom, PD-Patient Diagnostic & Treatment Use, E-Exam Room & T-Exam Table/Scale

WAS /* 'Accessibility Codes: P-Parking, EB-Exterior Building, IB-Interior Building, W-Wheelchair, R-Restroom, E-Exam Room & T-Exam Table/Scale' */ NOW() 'Accessibility Codes: P-Parking, EB-Exterior Building, IB-Interior Building, W-Wheelchair, R-Restroom, PD-Patient Diagnostic & Treatment Use, E-Exam Room & T-Exam Table/Scale'







REPLACE() / SUBSTITUTE() 'SIGN LANGUAGE' FOR 'AMERICAN SIGN LANGUAGE'
-- ===================================================================
	-- LANGUAGE(s) FOR PROV(s)--
-- ===================================================================
------------------------------------------------------------------------------------------------------------------------
	-- Error Trapping: Check If Permanent Table(s) Already Exist(s) And Drop If Applicable --
------------------------------------------------------------------------------------------------------------------------
IF OBJECT_ID('TempDB..#LANGUAGEsORDER') IS NOT NULL
BEGIN

		DROP TABLE #LANGUAGEsORDER

 END

;WITH LANGUAGEsORDER AS --;WITH() LIKE '%CREATION OF [tempdb] TABLE%'  ## FROM JL
( --INITIATE ...
SELECT DISTINCT UPPER(LTRIM(RTRIM(vps.PractitionerID))) AS 'lookup_key'
,'ENGLISH' AS LANG --BUREAUCRATIC NONSENSE ... DFLT VAL()
--INTO #LANGUAGEsORDER
--SELECT  TOP 100 * --CHECK 1st
FROM eVips_chgcv.dbo.vwPractitionerSpecialties AS vps
UNION ALL --VERTICAL() w UNION ALL()  - ROW(s) --STACK
SELECT DISTINCT UPPER(LTRIM(RTRIM(vpl.PractitionerID))) AS 'lookup_key'
,UPPER(LTRIM(RTRIM(vpl.LanguageName))) AS LANG
--INTO #LANGUAGEsORDER
--SELECT  TOP 100 * --CHECK 1st
FROM eVips_chgcv.dbo.vwPractitionerLanguages AS vpl
) --CONCLUDE ...
SELECT *
INTO #LANGUAGEsORDER
-- SELECT TOP 100 *  --CHECK 1st
-- SELECT DISTINCT --CHECK 1st
FROM LANGUAGEsORDER
ORDER BY LANG	

					UPDATE #LANGUAGEsORDER
					SET [LANG] = 'AMERICAN SIGN LANGUAGE'
					-- SELECT DISTINCT [LANG] FROM #LANGUAGEsORDER ORDER BY [LANG]
					FROM #LANGUAGEsORDER
					WHERE UPPER(LTRIM(RTRIM(ISNULL([LANG],'')))) LIKE '%SIGN%LANG%'

	--DUP(s)--
 -- SELECT 'DUP Validation' AS [NOTE(s)],*
 -- FROM #LANGUAGEsORDER
-- WHERE LTRIM(RTRIM(lookup_key)) IN (SELECT LTRIM(RTRIM(dup.lookup_key))
-- FROM #LANGUAGEsORDER AS dup
-- GROUP BY LTRIM(RTRIM(dup.lookup_key)) --Duplication Driver
-- HAVING COUNT(1)>1) --HAVING clause RESERVED for AGGREGATE(s)
-- ORDER BY LTRIM(RTRIM(lookup_key))

					SELECT DISTINCT [LANG] FROM #LANGUAGEsORDER ORDER BY [LANG]

-- ==========================================================
	-- CLEAN UP LANGUAGE(s) IN eVIPS USE [SQLPRODAPP01]
-- ==========================================================
UPDATE INFORMATICS.dbo.PROVDIR_PCP --PROV(s)
SET [FINALlang] = REPLACE(REPLACE([FINALlang],', , , ',''),', , ','')
FROM INFORMATICS.dbo.PROVDIR_PCP --PROV(s)

UPDATE INFORMATICS.dbo.PROVDIR_NPMP --PROV(s)
SET [FINALlang] = REPLACE(REPLACE([FINALlang],', , , ',''),', , ','')
FROM INFORMATICS.dbo.PROVDIR_NPMP --PROV(s)

UPDATE INFORMATICS.dbo.PROVDIR_SPE --PROV(s)
SET [FINALlang] = REPLACE(REPLACE([FINALlang],', , , ',''),', , ','')
FROM INFORMATICS.dbo.PROVDIR_SPE --PROV(s)

UPDATE INFORMATICS.dbo.PROVDIR_MH --PROV(s)
SET [FINALlang] = REPLACE(REPLACE([FINALlang],', , , ',''),', , ','')
FROM INFORMATICS.dbo.PROVDIR_MH --PROV(s)

UPDATE INFORMATICS.dbo.PROVDIR_AHP --PROV(s)
SET [FINALlang] = REPLACE(REPLACE([FINALlang],', , , ',''),', , ','')
FROM INFORMATICS.dbo.PROVDIR_AHP --PROV(s)

UPDATE INFORMATICS.dbo.PROVDIR_VSP --PROV(s)
SET [FINALlang] = REPLACE(REPLACE([FINALlang],', , , ',''),', , ','')
FROM INFORMATICS.dbo.PROVDIR_VSP --PROV(s)

					UPDATE INFORMATICS.dbo.PROVDIR_CLINIC --FQHC(s)
					SET [FINALlang] = REPLACE(REPLACE([FINALlang],', , , ',''),', , ','')
					FROM INFORMATICS.dbo.PROVDIR_CLINIC --FQHC(s)

---------------------------------------------------------------------------------------------------------------------
	-- Error Trapping: Check If Permanent Table(s) Already Exist(s) And Drop If Applicable --
---------------------------------------------------------------------------------------------------------------------
IF OBJECT_ID('TempDB..##DERIVED') IS NOT NULL
BEGIN

		DROP TABLE ##DERIVED --#TableName is a local temporary table visible only in the current session; ##TableName is a global temporary table visible to all sessions IN 'tempdb'

END

SELECT * 
INTO ##DERIVED
-- SELECT * --CHECK 1st
-- SELECT DISTINCT --CHECK 1st
FROM --see BELOW
( -- INITIATE ...
SELECT DISTINCT [FINALlang] -- VERIFY 'AMERICAN SIGN LANGUAGE' CHANG
-- SELECT DISTINCT [ACCREDITATION_BY],* --CHECK 1st
FROM INFORMATICS.dbo.PROVDIR_PCP --PROV(s)
UNION -- VERTICAL() STACK ALL()
SELECT DISTINCT [FINALlang] -- VERIFY 'AMERICAN SIGN LANGUAGE' CHANG
-- SELECT DISTINCT [ACCREDITATION_BY] --CHECK 1st
FROM INFORMATICS.dbo.PROVDIR_NPMP --PROV(s)
UNION -- VERTICAL() STACK ALL()
SELECT DISTINCT [FINALlang] -- VERIFY 'AMERICAN SIGN LANGUAGE' CHANG
-- SELECT DISTINCT [ACCREDITATION_BY] --CHECK 1st
FROM INFORMATICS.dbo.PROVDIR_SPE --PROV(s)
UNION -- VERTICAL() STACK ALL()
SELECT DISTINCT [FINALlang] -- VERIFY 'AMERICAN SIGN LANGUAGE' CHANG
-- SELECT DISTINCT [ACCREDITATION_BY] --CHECK 1st
FROM INFORMATICS.dbo.PROVDIR_MH --PROV(s)
UNION -- VERTICAL() STACK ALL()
SELECT DISTINCT [FINALlang] -- VERIFY 'AMERICAN SIGN LANGUAGE' CHANG
-- SELECT DISTINCT [ACCREDITATION_BY] --CHECK 1st
FROM INFORMATICS.dbo.PROVDIR_AHP --PROV(s)
UNION -- VERTICAL() STACK ALL()
SELECT DISTINCT [FINALlang] -- VERIFY 'AMERICAN SIGN LANGUAGE' CHANG
-- SELECT DISTINCT [ACCREDITATION_BY] --CHECK 1st
FROM INFORMATICS.dbo.PROVDIR_VSP --PROV(s)
UNION -- VERTICAL() STACK ALL()
SELECT DISTINCT [FINALlang] -- VERIFY 'AMERICAN SIGN LANGUAGE' CHANG
-- SELECT DISTINCT [ACCREDITATION_BY] --CHECK 1st
FROM INFORMATICS.dbo.PROVDIR_CLINIC --FQHC(s)
) AS DERIVED -- DERIVED() ALIASNAME CONCLUDE ...
-- WHERE LastName LIKE '%%%'
-- WHERE NPIis IN ('','','','','','')
 WHERE UPPER(LTRIM(RTRIM(ISNULL([FINALlang],'')))) LIKE'%SIGN%LANG%' --THE DESCR... 
--WHERE UPPER(LTRIM(RTRIM(ISNULL([LANG],'')))) IN ('','','','','','') -- THE CODE...
-- WHERE [INDEXNM] LIKE '%%%%%'
-- ORDER BY [INDEXNM]

					SELECT 'FINALlang CLEANUP' AS [NOTE(s)],* FROM ##DERIVED

-- ==========================================================
	-- CLEAN UP LANGUAGE(s) IN VISTAR USE [SQL01] --
-- ==========================================================
UPDATE INFORMATICS.dbo.PROVDIR_PCP --PROV(s)
SET [FINALlang] = REPLACE(REPLACE([FINALlang],', , , ',''),', , ','')
FROM INFORMATICS.dbo.PROVDIR_PCP --PROV(s)

UPDATE INFORMATICS.dbo.PROVDIR_NPMP --PROV(s)
SET [FINALlang] = REPLACE(REPLACE([FINALlang],', , , ',''),', , ','')
FROM INFORMATICS.dbo.PROVDIR_NPMP --PROV(s)

UPDATE INFORMATICS.dbo.PROVDIR_SPE --PROV(s)
SET [FINALlang] = REPLACE(REPLACE([FINALlang],', , , ',''),', , ','')
FROM INFORMATICS.dbo.PROVDIR_SPE --PROV(s)

UPDATE INFORMATICS.dbo.PROVDIR_MH --PROV(s)
SET [FINALlang] = REPLACE(REPLACE([FINALlang],', , , ',''),', , ','')
FROM INFORMATICS.dbo.PROVDIR_MH --PROV(s)

UPDATE INFORMATICS.dbo.PROVDIR_AHP --PROV(s)
SET [FINALlang] = REPLACE(REPLACE([FINALlang],', , , ',''),', , ','')
FROM INFORMATICS.dbo.PROVDIR_AHP --PROV(s)

UPDATE INFORMATICS.dbo.PROVDIR_VSP --PROV(s)
SET [FINALlang] = REPLACE(REPLACE([FINALlang],', , , ',''),', , ','')
FROM INFORMATICS.dbo.PROVDIR_VSP --PROV(s)

					UPDATE INFORMATICS.dbo.PROVDIR_CLINIC --FQHC(s)
					SET [FINALlang] = REPLACE(REPLACE([FINALlang],', , , ',''),', , ','')
					FROM INFORMATICS.dbo.PROVDIR_CLINIC --FQHC(s)
					
---------------------------------------------------------------------------------------------------------------------
	-- Error Trapping: Check If Permanent Table(s) Already Exist(s) And Drop If Applicable --
---------------------------------------------------------------------------------------------------------------------
IF OBJECT_ID('TempDB..##DERIVED') IS NOT NULL
BEGIN

		DROP TABLE ##DERIVED --#TableName is a local temporary table visible only in the current session; ##TableName is a global temporary table visible to all sessions IN 'tempdb'

END

SELECT * 
INTO ##DERIVED
-- SELECT * --CHECK 1st
-- SELECT DISTINCT --CHECK 1st
FROM --see BELOW
( -- INITIATE ...
SELECT DISTINCT [FINALlang] -- VERIFY 'AMERICAN SIGN LANGUAGE' CHANG
-- SELECT DISTINCT [ACCREDITATION_BY],* --CHECK 1st
FROM INFORMATICS.dbo.PROVDIR_PCP --PROV(s)
UNION -- VERTICAL() STACK ALL()
SELECT DISTINCT [FINALlang] -- VERIFY 'AMERICAN SIGN LANGUAGE' CHANG
-- SELECT DISTINCT [ACCREDITATION_BY] --CHECK 1st
FROM INFORMATICS.dbo.PROVDIR_NPMP --PROV(s)
UNION -- VERTICAL() STACK ALL()
SELECT DISTINCT [FINALlang] -- VERIFY 'AMERICAN SIGN LANGUAGE' CHANG
-- SELECT DISTINCT [ACCREDITATION_BY] --CHECK 1st
FROM INFORMATICS.dbo.PROVDIR_SPE --PROV(s)
UNION -- VERTICAL() STACK ALL()
SELECT DISTINCT [FINALlang] -- VERIFY 'AMERICAN SIGN LANGUAGE' CHANG
-- SELECT DISTINCT [ACCREDITATION_BY] --CHECK 1st
FROM INFORMATICS.dbo.PROVDIR_MH --PROV(s)
UNION -- VERTICAL() STACK ALL()
SELECT DISTINCT [FINALlang] -- VERIFY 'AMERICAN SIGN LANGUAGE' CHANG
-- SELECT DISTINCT [ACCREDITATION_BY] --CHECK 1st
FROM INFORMATICS.dbo.PROVDIR_AHP --PROV(s)
UNION -- VERTICAL() STACK ALL()
SELECT DISTINCT [FINALlang] -- VERIFY 'AMERICAN SIGN LANGUAGE' CHANG
-- SELECT DISTINCT [ACCREDITATION_BY] --CHECK 1st
FROM INFORMATICS.dbo.PROVDIR_VSP --PROV(s)
UNION -- VERTICAL() STACK ALL()
SELECT DISTINCT [FINALlang] -- VERIFY 'AMERICAN SIGN LANGUAGE' CHANG
-- SELECT DISTINCT [ACCREDITATION_BY] --CHECK 1st
FROM INFORMATICS.dbo.PROVDIR_CLINIC --FQHC(s)
) AS DERIVED -- DERIVED() ALIASNAME CONCLUDE ...
-- WHERE LastName LIKE '%%%'
-- WHERE NPIis IN ('','','','','','')
 WHERE UPPER(LTRIM(RTRIM(ISNULL([FINALlang],'')))) LIKE'%SIGN%LANG%' --THE DESCR... 
--WHERE UPPER(LTRIM(RTRIM(ISNULL([LANG],'')))) IN ('','','','','','') -- THE CODE...
-- WHERE [INDEXNM] LIKE '%%%%%'
-- ORDER BY [INDEXNM]

					SELECT 'FINALlang CLEANUP' AS [NOTE(s)],* FROM ##DERIVED

/* FINALlang
AMERICAN SIGN LANGUAGE, , , 
AMERICAN SIGN LANGUAGE, SPANISH
ARABIC, FARSI, GREEK, HUNGARIAN, AMERICAN SIGN LANGUAGE, SINHALESE, SPANISH, VIETNAMESE
ENGLISH, SPANISH, AMERICAN SIGN LANGUAGE, ,  */







'YOUNG LADY NORA' - ADHOC
-- ===================================================================
	-- HDR [ACCESSIBILITY] OPTION(s)--
-- ===================================================================
------------------------------------------------------------------------------------------------------------------------
	-- Error Trapping: Check If Permanent Table(s) Already Exist(s) And Drop If Applicable --
------------------------------------------------------------------------------------------------------------------------
IF OBJECT_ID('TempDB..#ACCESSIBILITY') IS NOT NULL
BEGIN

		DROP TABLE #ACCESSIBILITY

 END
 
SELECT DISTINCT ServiceTypeName
,CASE
WHEN SUBSTRING(UPPER(LTRIM(RTRIM(vls.ClassOrCategory))),1,1) = 'L'
THEN 'Limited Access'
WHEN SUBSTRING(UPPER(LTRIM(RTRIM(vls.ClassOrCategory))),1,1) = 'B'
THEN 'Basic Access'
ELSE ''
END AS [Accessibility]
,UPPER(LTRIM(RTRIM(vls.ServiceCategoryTypeName))) AS [Accessibility Category(ies)]
,vls.PracticeID,vls.LocationID
INTO #ACCESSIBILITY
-- SELECT * --CHECK 1st
-- SELECT DISTINCT ClassOrCategory --CHECK 1st
-- SELECT DISTINCT ServiceTypeName --CHECK 1st
-- SELECT DISTINCT PracticeTypeName --CHECK 1st
-- SELECT DISTINCT ServiceCategoryTypeName --CHECK 1st
FROM eVips_chgcv.dbo.vwLocationServices AS vls
WHERE UPPER(LTRIM(RTRIM(vls.ServiceTypeName))) LIKE '%SITE%REV%'

					--SELECT * FROM #ACCESSIBILITY
					
Good morning,  Yes.  This is in the PARS accessibility field.  If a site has a special exam table and scale the field has a T in it.

					'GroupService.LocationService.ServiceCategoryTypeName is like T'

SELECT 'PCPs who have scales for obese patients and height adjustable exam tables' AS [NOTE(s)],[Accessibility],[Accessibility Category(ies)],* --CHECK 1st
FROM INFORMATICS.dbo.PROVDIR_PCP --PROV(s)
WHERE UPPER(LTRIM(RTRIM(ISNULL([Accessibility Category(ies)],'')))) LIKE'%T%'

SELECT DISTINCT 'PCPs who have scales for obese patients and height adjustable exam tables' AS [NOTE(s)]/* ,[Accessibility],[Accessibility Category(ies)] */,INDEXNM--CHECK 1st
FROM INFORMATICS.dbo.PROVDIR_PCP --PROV(s)
WHERE UPPER(LTRIM(RTRIM(ISNULL([Accessibility Category(ies)],'')))) LIKE'%T%'
ORDER BY INDEXNM







UPDATE 'BEHAVIORAL HEALTH THERAPIERS' - IN SQL01. (VISTAR) 

Sir, I see 'BEHAVIORAL HEALTH SERVICES' ON SQLAPPPROD01 (eVIPS) 

I see 'BEHAVIORAL HEALTH' ON SQL01 (VISTAR)

JAH CHARINDEX() FIND() SEARCH(): 'INTO INFORMATICS.dbo.TimelyAccess' OR 'INTO HMOPROD_REPORT.dbo.PROVDIR' - see SELECT * FROM INFORMATICS.dbo.TimelyAccessSPE - see  '(#SPE,#SPEb,#SPEc,#SPEd)'

-- ==========================================================
               -- GENERATE PROVIDER GROUP [TEMPLATE] --
-- ==========================================================
---------------------------------------------------------------------------------------------------------------------
               -- Error Trapping: Check If Permanent Table(s) Already Exist(s) And Drop If Applicable --
---------------------------------------------------------------------------------------------------------------------
IF OBJECT_ID('TempDB..##DERIVED') IS NOT NULL
BEGIN

	DROP TABLE ##DERIVED --#TableName is a local temporary table visible only in the current session; ##TableName is a global temporary table visible to all sessions IN 'tempdb'

END

SELECT * 
INTO ##DERIVED
-- SELECT * --CHECK 1st
-- SELECT DISTINCT --CHECK 1st
FROM --see BELOW
( -- INITIATE ...
SELECT DISTINCT SPEC
-- SELECT DISTINCT [ACCREDITATION_BY] --CHECK 1st
FROM INFORMATICS.dbo.PROVDIR_PCP --PROV(s)
UNION -- VERTICAL() STACK ALL()
SELECT DISTINCT SPEC
-- SELECT DISTINCT [ACCREDITATION_BY] --CHECK 1st
FROM INFORMATICS.dbo.PROVDIR_NPMP --PROV(s)
UNION -- VERTICAL() STACK ALL()
SELECT DISTINCT SPEC
-- SELECT DISTINCT [ACCREDITATION_BY] --CHECK 1st
FROM INFORMATICS.dbo.PROVDIR_SPE --PROV(s)
UNION -- VERTICAL() STACK ALL()
SELECT DISTINCT SPEC
-- SELECT DISTINCT [ACCREDITATION_BY] --CHECK 1st
FROM INFORMATICS.dbo.PROVDIR_MH --PROV(s)
UNION -- VERTICAL() STACK ALL()
SELECT DISTINCT SPEC
-- SELECT DISTINCT [ACCREDITATION_BY] --CHECK 1st
FROM INFORMATICS.dbo.PROVDIR_AHP --PROV(s)
UNION -- VERTICAL() STACK ALL()
SELECT DISTINCT SPEC
-- SELECT DISTINCT [ACCREDITATION_BY] --CHECK 1st
FROM INFORMATICS.dbo.PROVDIR_VSP --PROV(s)
) AS DERIVED -- DERIVED() ALIASNAME CONCLUDE ...
-- WHERE LastName LIKE '%%%'
-- WHERE NPIis IN ('','','','','','')
-- WHERE UPPER(LTRIM(RTRIM([SPEC]))) LIKE'%%%' --THE DESCR... 
--WHERE UPPER(LTRIM(RTRIM([Specialty]))) IN ('','','','','','') --THE CODE...
-- WHERE [INDEXNM] LIKE '%%%%%'

					SELECT * FROM ##DERIVED ORDER BY SPEC

-- ==========================================================
               -- GENERATE PROVIDER GROUP [TEMPLATE] --
-- ==========================================================
---------------------------------------------------------------------------------------------------------------------
               -- Error Trapping: Check If Permanent Table(s) Already Exist(s) And Drop If Applicable --
---------------------------------------------------------------------------------------------------------------------
IF OBJECT_ID('TempDB..##DERIVED') IS NOT NULL
BEGIN

	DROP TABLE ##DERIVED --#TableName is a local temporary table visible only in the current session; ##TableName is a global temporary table visible to all sessions IN 'tempdb'

END

SELECT * 
INTO ##DERIVED
-- SELECT * --CHECK 1st
-- SELECT DISTINCT --CHECK 1st
FROM --see BELOW
( -- INITIATE ...
SELECT DISTINCT SPEC
-- SELECT DISTINCT [ACCREDITATION_BY] --CHECK 1st
FROM INFORMATICS.dbo.PROVDIR_PCP --PROV(s)
UNION -- VERTICAL() STACK ALL()
SELECT DISTINCT SPEC
-- SELECT DISTINCT [ACCREDITATION_BY] --CHECK 1st
FROM INFORMATICS.dbo.PROVDIR_NPMP --PROV(s)
UNION -- VERTICAL() STACK ALL()
SELECT DISTINCT SPEC
-- SELECT DISTINCT [ACCREDITATION_BY] --CHECK 1st
FROM INFORMATICS.dbo.PROVDIR_SPE --PROV(s)
UNION -- VERTICAL() STACK ALL()
SELECT DISTINCT SPEC
-- SELECT DISTINCT [ACCREDITATION_BY] --CHECK 1st
FROM INFORMATICS.dbo.PROVDIR_MH --PROV(s)
UNION -- VERTICAL() STACK ALL()
SELECT DISTINCT SPEC
-- SELECT DISTINCT [ACCREDITATION_BY] --CHECK 1st
FROM INFORMATICS.dbo.PROVDIR_AHP --PROV(s)
UNION -- VERTICAL() STACK ALL()
SELECT DISTINCT SPEC
-- SELECT DISTINCT [ACCREDITATION_BY] --CHECK 1st
FROM INFORMATICS.dbo.PROVDIR_VSP --PROV(s)
) AS DERIVED -- DERIVED() ALIASNAME CONCLUDE ...
-- WHERE LastName LIKE '%%%'
-- WHERE NPIis IN ('','','','','','')
-- WHERE UPPER(LTRIM(RTRIM([SPEC]))) LIKE'%%%' --THE DESCR... 
-- WHERE UPPER(LTRIM(RTRIM([Specialty]))) IN ('','','','','','') --THE CODE...
-- WHERE [INDEXNM] LIKE '%%%%%'

					SELECT * FROM ##DERIVED ORDER BY SPEC

Much Appreciated, Thank You
Walter W Carr II
Informatics Research Business Analyst
wcarr@chgsd.com
619 498 6510

This e-mail message is intended only for use by the individual, or recipient(s) entity to which it is addressed. This message is confidential and may contain information that is privileged, confidential and is exempt from disclosure under applicable law. If you are not the intended recipient(s), you may not review, copy, or distribute this message. If you have received this communication in error, please notify us immediately by e-mail, or telephone and delete the original message.







'TO': AAmezcua@chgsd.com;EAdams@chgsd.com;SColem@chgsd.com;MPeral@chgsd.com;KellyCallies@chgsd.com
		'CC': ASanta@chgsd.com;AHanco@chgsd.com;CGiangregorio@chgsd.com;HArndt@chgsd.com;jlutz@chgsd.com;NKoizu@chgsd.com;rfierr@chgsd.com;eduche@chgsd.com;EricAlmirol@chgsd.com;LHaish@chgsd.com;DinahDacurro@chgsd.com;aross@chgsd.com;EMarti@chgsd.com;pbeauchamp@chgsd.com;LJimenezAvila@chgsd.com;DAvest@chgsd.com;pdangelo@chgsd.com;CopyCenter@chgsd.com;LauraInfante@chgsd.com;HLora@chgsd.com
		
		x SEARCH(): 'Online PS to PDF Converter' USE CutePDF
					'https://ps2pdf.com/convert.htm'
					'http://www.go2pdf.com/ps-to-pdf.html'
					'https://online2pdf.com/convert-ps-to-pdf'

'SANATOR' - Provider:
ADD [Field]						Note
Middle Name						The full middle name - ,UPPER(LTRIM(RTRIM(vpd.MiddleName))) AS [MiddleName]
DOB	 								IN 'yyyy-mm-dd' DOB Format: YYYY-MM-DD eg. 1980-06-28 - ,SUBSTRING(UPPER(LTRIM(RTRIM(ISNULL(CONVERT(nvarchar(25),CAST(vpd.BirthDate AS datetime),120),'')))),1,10) AS [DOB] -- yyyy-mm-dd
Suffix									Exclude period (.) YOU MEAN PREFIX - REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(UPPER(LTRIM(RTRIM(vpd.PrefixName)),'[',''),']',''),'&',''),'.',''),' AND ','') AS [PrefixName] --NESTED TAG(s) 'PARADISE VALLEY HOSPITAL SYSTEM' --'WALTER WESLEY CARR II' 'North County & Escondido Physical Therapy'
In Directory						,UPPER(LTRIM(RTRIM(vpps.InDirectory))) AS [INDIRECTORY]

,spe.[INDIRECTORY],spe.LastName,spe.FirstName,spe.[MiddleName],spe.[PrefixName],spe.[DOB]
,pcp.[INDIRECTORY],pcp.LastName,pcp.FirstName,pcp.[MiddleName],pcp.[PrefixName],pcp.[DOB]

SELECT * FROM INFORMATICS.dbo.TimelyAccessPCP 
SELECT * FROM INFORMATICS.dbo.TimelyAccessPCP_Extender 		
SELECT * FROM INFORMATICS.dbo.TimelyAccessSPE - see  '(#SPE,#SPEb,#SPEc,#SPEd)'

ALTER TABLE INFORMATICS.dbo.TimelyAccessPCP
ADD --INITIATE ... ADDITION OF COLUMN(s)
[MiddleName] nvarchar (25) DEFAULT NULL --DFLT VAL() IS NULL
,[PrefixName] nvarchar (25) DEFAULT NULL --DFLT VAL() IS NULL
,[SuffixName] nvarchar (25) DEFAULT NULL --DFLT VAL() IS NULL
,[DOB] nvarchar (10) DEFAULT NULL --DFLT VAL() IS NULL
; --CONCLUDE ...

ALTER TABLE INFORMATICS.dbo.TimelyAccessPCP_Extender
ADD --INITIATE ... ADDITION OF COLUMN(s)
[MiddleName] nvarchar (25) DEFAULT NULL --DFLT VAL() IS NULL
,[PrefixName] nvarchar (25) DEFAULT NULL --DFLT VAL() IS NULL
,[SuffixName] nvarchar (25) DEFAULT NULL --DFLT VAL() IS NULL
,[DOB] nvarchar (10) DEFAULT NULL --DFLT VAL() IS NULL
; --CONCLUDE ...

ALTER TABLE INFORMATICS.dbo.TimelyAccessSPE
ADD --INITIATE ... ADDITION OF COLUMN(s)
[MiddleName] nvarchar (25) DEFAULT NULL --DFLT VAL() IS NULL
,[PrefixName] nvarchar (25) DEFAULT NULL --DFLT VAL() IS NULL
,[SuffixName] nvarchar (25) DEFAULT NULL --DFLT VAL() IS NULL
,[DOB] nvarchar (10) DEFAULT NULL --DFLT VAL() IS NULL
; --CONCLUDE ...

ALTER TABLE INFORMATICS.dbo.PROVDIR_PCP
ADD --INITIATE ... ADDITION OF COLUMN(s)
[MiddleName] nvarchar (25) DEFAULT NULL --DFLT VAL() IS NULL
,[PrefixName] nvarchar (25) DEFAULT NULL --DFLT VAL() IS NULL
,[SuffixName] nvarchar (25) DEFAULT NULL --DFLT VAL() IS NULL
,[DOB] nvarchar (10) DEFAULT NULL --DFLT VAL() IS NULL
; --CONCLUDE ...

ALTER TABLE INFORMATICS.dbo.PROVDIR_NPMP
ADD --INITIATE ... ADDITION OF COLUMN(s)
[MiddleName] nvarchar (25) DEFAULT NULL --DFLT VAL() IS NULL
,[PrefixName] nvarchar (25) DEFAULT NULL --DFLT VAL() IS NULL
,[SuffixName] nvarchar (25) DEFAULT NULL --DFLT VAL() IS NULL
,[DOB] nvarchar (10) DEFAULT NULL --DFLT VAL() IS NULL
; --CONCLUDE ...

ALTER TABLE INFORMATICS.dbo.PROVDIR_SPE
ADD --INITIATE ... ADDITION OF COLUMN(s)
[MiddleName] nvarchar (25) DEFAULT NULL --DFLT VAL() IS NULL
,[PrefixName] nvarchar (25) DEFAULT NULL --DFLT VAL() IS NULL
,[SuffixName] nvarchar (25) DEFAULT NULL --DFLT VAL() IS NULL
,[DOB] nvarchar (10) DEFAULT NULL --DFLT VAL() IS NULL
; --CONCLUDE ...

ALTER TABLE INFORMATICS.dbo.PROVDIR_MH
ADD --INITIATE ... ADDITION OF COLUMN(s)
[MiddleName] nvarchar (25) DEFAULT NULL --DFLT VAL() IS NULL
,[PrefixName] nvarchar (25) DEFAULT NULL --DFLT VAL() IS NULL
,[SuffixName] nvarchar (25) DEFAULT NULL --DFLT VAL() IS NULL
,[DOB] nvarchar (10) DEFAULT NULL --DFLT VAL() IS NULL
; --CONCLUDE ...

ALTER TABLE INFORMATICS.dbo.PROVDIR_AHP
ADD --INITIATE ... ADDITION OF COLUMN(s)
[MiddleName] nvarchar (25) DEFAULT NULL --DFLT VAL() IS NULL
,[PrefixName] nvarchar (25) DEFAULT NULL --DFLT VAL() IS NULL
,[SuffixName] nvarchar (25) DEFAULT NULL --DFLT VAL() IS NULL
,[DOB] nvarchar (10) DEFAULT NULL --DFLT VAL() IS NULL
; --CONCLUDE ...

ALTER TABLE INFORMATICS.dbo.PROVDIR_VSP
ADD --INITIATE ... ADDITION OF COLUMN(s)
[MiddleName] nvarchar (25) DEFAULT NULL --DFLT VAL() IS NULL
,[PrefixName] nvarchar (25) DEFAULT NULL --DFLT VAL() IS NULL
,[SuffixName] nvarchar (25) DEFAULT NULL --DFLT VAL() IS NULL
,[DOB] nvarchar (10) DEFAULT NULL --DFLT VAL() IS NULL
; --CONCLUDE ...

x DEVELOP NON 'INDIR' version

-- =====================================================================
	-- INSERT STATEMENTS FOR PROCEDURE HERE:
-- =====================================================================
-- ====================================================================
	--SET PARAMETER(s) / FILTER(s) / ESTABLISH HDR tempdb(s)--
-- ====================================================================
DECLARE @LOB AS nvarchar(5) --DELETE() WHERE UPPER(LTRIM(RTRIM(ISNULL([Participating Network],'')))) = ''
DECLARE @INDIR AS nvarchar(1) --REMOVE FILTER FOR JOSEPH / TIMELYACCESS HBP(s)... '%' OR 'Y'  OR 'N'--SUBSTRING(UPPER(LTRIM(RTRIM(cert_provider.in_directory))),1,1) LIKE @INDIR --see 'LTRIM(RTRIM(mcred.retrieve_list)) LIKE '%CN%V%'
DECLARE @footnotedt AS nvarchar(25)
-- DECLARE @what AS nvarchar(255)
DECLARE @when AS datetime
DECLARE @hospriv AS nvarchar(1)

SET @LOB = 'C%' --'CL%' THEN 'CM%' ELSE 'C%' OR '%' TO CAPTURE ALL (FINAL RUN FOR ONLINE SEARCH()) --'CL1' OR 'CMC' --DELETE() WHERE UPPER(LTRIM(RTRIM(ISNULL([Participating Network],'')))) = ''
SET @INDIR ='%'--REMOVE FILTER FOR JOSEPH / TIMELYACCESS HBP(s)... '%' OR 'Y'  OR 'N'--SUBSTRING(UPPER(LTRIM(RTRIM(cert_provider.in_directory))),1,1) LIKE @INDIR --see 'LTRIM(RTRIM(mcred.retrieve_list)) LIKE '%CN%V%'
SET @footnotedt = 'Last Updated: ' --'Last Updated: 01/27/2017' --PRESET TO NEXT FRIDAY
-- SET @what  = '%SPECIAL%'
SET @when = GETDATE()
SET @hospriv = 'B' --USE 'Y' TO RETAIN DIRECT HOSPPRIV ONLY WITHIN PROVIDER DIRECTORY / USE 'B' TO RETAIN EITHER OPTION FOR NETWORK ADEQUACY REPORT(s) seeSELECT DISTINCT 'N' AS [USE_HOSPITALIST]...







'REGION OPTION'(s)
					SD-NORTH INLAND
					RIVERSIDE
					SD-NORTH COASTAL
					SD-SOUTH
					SD-CENTRAL
					SD-EAST
					SD-NORTH
					
,spe.TRUE_CLINICname AS [Clinic Name]

select zipcode, city, county, RegionTypeName,CASE
WHEN SUBSTRING(LTRIM(RTRIM(regionis.ZipCode)),1,1) = '0'
THEN '0'+ SUBSTRING(LTRIM(RTRIM(regionis.ZipCode)),2,4)
WHEN SUBSTRING(LTRIM(RTRIM(regionis.ZipCode)),1,1) = '00'
THEN '00'+ SUBSTRING(LTRIM(RTRIM(regionis.ZipCode)),3,3)
ELSE  SUBSTRING(LTRIM(RTRIM(regionis.ZipCode)),1,5) 
END AS [ZIP]
FROM eVips_chgcv.dbo.vwzipcodes AS regionis
where county = 'SAN DIEGO'
order by zipcode

,UPPER(LTRIM(RTRIM(ISNULL(regionis.RegionTypeName,'')))) AS [REGION]

		LEFT JOIN (SELECT DISTINCT zipcode,city,county,RegionTypeName FROM eVips_chgcv.dbo.vwzipcodes WHERE UPPER(LTRIM(RTRIM(ISNULL(county,'')))) LIKE '%SAN%DIEGO%') AS regionis ON CASE WHEN SUBSTRING(LTRIM(RTRIM(regionis.ZipCode)),1,1) = '0' THEN '0'+ SUBSTRING(LTRIM(RTRIM(regionis.ZipCode)),2,4) WHEN SUBSTRING(LTRIM(RTRIM(regionis.ZipCode)),1,1) = '00' THEN '00'+ SUBSTRING(LTRIM(RTRIM(regionis.ZipCode)),3,3) ELSE  SUBSTRING(LTRIM(RTRIM(regionis.ZipCode)),1,5) END = CASE WHEN SUBSTRING(LTRIM(RTRIM(vpl.ZipCode)),1,1) = '0' THEN '0'+ SUBSTRING(LTRIM(RTRIM(vpl.ZipCode)),2,4) WHEN SUBSTRING(LTRIM(RTRIM(vpl.ZipCode)),1,1) = '00' THEN '00'+ SUBSTRING(LTRIM(RTRIM(vpl.ZipCode)),3,3) ELSE  SUBSTRING(LTRIM(RTRIM(vpl.ZipCode)),1,5) END --##INNETFAC
	
		LEFT JOIN (SELECT DISTINCT zipcode,city,county,RegionTypeName FROM eVips_chgcv.dbo.vwzipcodes WHERE UPPER(LTRIM(RTRIM(ISNULL(county,'')))) LIKE '%SAN%DIEGO%') AS regionis ON CASE WHEN SUBSTRING(LTRIM(RTRIM(regionis.ZipCode)),1,1) = '0' THEN '0'+ SUBSTRING(LTRIM(RTRIM(regionis.ZipCode)),2,4) WHEN SUBSTRING(LTRIM(RTRIM(regionis.ZipCode)),1,1) = '00' THEN '00'+ SUBSTRING(LTRIM(RTRIM(regionis.ZipCode)),3,3) ELSE  SUBSTRING(LTRIM(RTRIM(regionis.ZipCode)),1,5) END = CASE WHEN SUBSTRING(LTRIM(RTRIM(vploc.ZipCode)),1,1) = '0' THEN '0'+ SUBSTRING(LTRIM(RTRIM(vploc.ZipCode)),2,4) WHEN SUBSTRING(LTRIM(RTRIM(vploc.ZipCode)),1,1) = '00' THEN '00'+ SUBSTRING(LTRIM(RTRIM(vploc.ZipCode)),3,3) ELSE  SUBSTRING(LTRIM(RTRIM(vploc.ZipCode)),1,5) END --##INNETPROV					

select zipcode, city, county, RegionTypeName,CASE
WHEN SUBSTRING(LTRIM(RTRIM(regionis.ZipCode)),1,1) = '0'
THEN '0'+ SUBSTRING(LTRIM(RTRIM(regionis.ZipCode)),2,4)
WHEN SUBSTRING(LTRIM(RTRIM(regionis.ZipCode)),1,1) = '00'
THEN '00'+ SUBSTRING(LTRIM(RTRIM(regionis.ZipCode)),3,3)
ELSE  SUBSTRING(LTRIM(RTRIM(regionis.ZipCode)),1,5) 
END AS [ZIP]
FROM eVips_chgcv.dbo.vwzipcodes AS regionis
where county = 'SAN DIEGO'
order by zipcode





--SELECT * FROM INFORMATICS.dbo.TimelyAccessPHARM WHERE [Pharmacy Name] LIKE '%SHARP%'
SELECT * FROM INFORMATICS.dbo.PROVDIR_HOSGENERALACUTE WHERE INDEXNM LIKE '%SHARP%'
SELECT * FROM INFORMATICS.dbo.PROVDIR_PHARM WHERE INDEXNM LIKE '%SHAR%'







'PROVDIR ONLINE REFRESH' - Sandra,

The Test environment at 'http://webtest/providerdirectory/Home.aspx' has been refreshed. 
You may proceed with your testing. 

Let me know if you have any concerns or issues. Thank You!



Niharika Thotapalli (Jeni)
Software Developer








'EXCLUSION'(s) - Good morning,  Before you run the eVIPs directory, please adjust the pharmacy type filter.  Similar to VIPs, please exclude the type NPDS.  This type should not be in the directory.  Thanks! 

					,UPPER(LTRIM(RTRIM(address.userdef_2))) AS [Pharmacy Type(s)] 
					,UPPER(LTRIM(RTRIM(vlspharmtype.ServiceCategoryTypeName))) AS [Pharmacy Type(s)]

	AND (address.userdef_2 NOT LIKE '%NPDS%' 
		OR UPPER(LTRIM(RTRIM(address.userdef_2))) = ''
		OR address.userdef_2 IS NULL) --Per S. Coleman ON 20160719 email: Hi,This is not a change. Please make sure pharmacies with (userdef2 of “NPDS”)are not showing in the pharmacy list. Thanks!
		
SELECT DISTINCT [Pharmacy Name],Address --CHECK 1st
--SELECT * FROM eVips_chgcv.dbo.vwEntityAssignments WHERE UPPER(LTRIM(RTRIM(TableName))) LIKE '%Practice%' AND UPPER(LTRIM(RTRIM(EntityName))) LIKE '%MED%IMPA%'
--SELECT DISTINCT [DEGREE DESCRIPTION] --CHECK 1st
--SELECT DISTINCT [Pharmacy Name],NPIis,Address --CHECK 1st
--SELECT DISTINCT plan_type --CHECK 1st
--SELECT DISTINCT [Type of Service] --CHECK 1st ,UPPER(LTRIM(RTRIM(vpl.PracticeTypeName)))AS [Type of Service] --,'Free Standing - Primary and/or Specialty Care' AS [Type of Service]
FROM ##INNETWORK_FAC
WHERE
( --INITIATE ...
UPPER(LTRIM(RTRIM(EntityName))) LIKE '%MED%IMPA%' --AFFIRMATIVE --,vea.TableName,vea.EntityCode,vea.EntityName,vea.EntityTypeCode,vea.EntityTypeName
	AND (plan_type IS NULL --FAC(s) ;WITH() ,UPPER(LTRIM(RTRIM(vp.PracticeTypeName))) AS [plan_type]
		OR UPPER(LTRIM(RTRIM(plan_type))) NOT IN ('COMMUNITY CLINIC')) --see 'TimelyAccessCLINIC' --,UPPER(LTRIM(RTRIM(vp.PracticeTypeName))) AS [plan_type] 1003162868
	--OR vlspharmPHARMACYTYPENAME IS NOT NULL
	AND vplLOCATIONTYPENAME LIKE '%PRACTI%'
	AND LTRIM(RTRIM(ISNULL([INDIRECTORY],''))) LIKE '%Y%' --SET @INDIR ='Y'--REMOVE FILTER FOR JOSEPH / TIMELYACCESS HBP(s)... '%' OR 'Y'  OR 'N'--SUBSTRING(UPPER(LTRIM(RTRIM(cert_provider.in_directory))),1,1) LIKE @INDIR --see 'LTRIM(RTRIM(mcred.retrieve_list)) LIKE '%CN%V%'
) --CONCLUDE ...
	AND (UPPER(LTRIM(RTRIM([Pharmacy Type(s)]))) NOT LIKE '%NPDS%' 
		OR UPPER(LTRIM(RTRIM(ISNULL([Pharmacy Type(s)],'')))) = '') --Per S. Coleman ON 20160719 AND 20180212 email: Good morning,  Before you run the eVIPs directory, please adjust the pharmacy type filter.  Similar to VIPs, please exclude the type NPDS.  This type should not be in the directory.  Thanks!  OR Hi,This is not a change. Please make sure pharmacies with (userdef2 of “NPDS”)are not showing in the pharmacy list. Thanks!
	
SELECT DISTINCT [Pharmacy Type(s)],[Pharmacy Footnote(s)] FROM INFORMATICS.dbo.TimelyAccessPHARM
SELECT DISTINCT [Pharmacy Type(s)],[Pharmacy Footnote(s)],* FROM INFORMATICS.dbo.TimelyAccessPHARM







'[BOARD ...]' - Hi,  There is a slight change to the code used during our discussion for ABA providers.  Instead of the eVIPs degree being QASP, I found that the code should be RBT.  See their certifying website.

					'https://www.bacb.com/'

eVIPs Degree
Paraprofessional
High School Level             RBT

Professional
Bachelor's Level                                BCaBA
Master's Level                   BCBA
Doctoral Level                   BCBA-D

All will have the specialty code BHT (Behavioral Health Therapies) as discussed.  I trained the Cred Team on the change this morning.  See the updated 2nd  page for Mental Health Specialty training.  The changes are highlighted in yellow.  

--------------------------------------------------------------------------------------------------------------------
	-- Error Trapping: Check If Permanent Table(s) Already Exist(s) And Drop If Applicable --
--------------------------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS #XWalkCALic

	-- Create the CredentialsMappingTable to store credential types and their corresponding availability codes
CREATE TABLE #XWalkCALic (
    eVipsCredentialType VARCHAR(10) NOT NULL,
    AvailabilityCode VARCHAR(10) NOT NULL,
);

-- Insert the credential mappings from the table
INSERT INTO #XWalkCALic (eVipsCredentialType, AvailabilityCode)
VALUES
    ('AMFT', 'MFT'),
    ('ASW', 'LCSW'),
    ('ATC', 'AT'),
    ('BCBA-D', 'BCBA'),
    ('HAD', 'AUD'),
    ('LPCC', 'LPC'),
    ('NMW', 'CNM'),
    ('OP', 'COP'),
    ('OT', 'OTR'),
    ('PC', 'LPC');

		SELECT * FROM #XWalkCALic








Good Morning Walter, I took a look at your eVIPs raw data for CMC and the Board Certified field is blank, and on the front end on eVIPs it shows and “Non Applicable”. I believe “Non Applicable” should be showing on your raw excel data as well instead of “blank” or “null”.  

•	Board Certification field shows blank on the online directory and its showing “NO” on Walter’s raw Excel for MCCONNELL, AMANDA, PA. 

--,'N' AS [BoardCertified(Y/N)] --QUPD ;WITH()  ???
,CASE
WHEN accredboard.AccreditationTypeName IS NOT NULL
THEN 'Y'
ELSE 'N'
END AS [BoardCertified(Y/N)]
,CASE
WHEN accredboard.AccreditationTypeName IS NULL
THEN 'NA'
ELSE UPPER(LTRIM(RTRIM(accredboard.AccreditationTypeName)))
END AS [BoardName] --THANKS TO YOUNG LADY LAURA ON 20180130 see LEFT JOIN (SELECT DISTINCT LocationID,PracticeID,AccreditationTypeCode,AccreditationTypeName FROM eVips_chgcv.dbo.vwLocationAccreditations AS vla WHERE vla.Archived IN ('N') OR vla.Archived IS NULL) AS accredboard ...
--,REPLACE(UPPER(LTRIM(RTRIM(vp.TaxIDNumber))),'-','') AS MEDGRPIPA

--,CAST(NULL AS nvarchar(1)) AS [ACCREDITATION] --QUPD ;WITH() ??? ANOTHER REVERSAL per S. COLEMAN email ON 20170522 ADD per MS. K Callies ON 20170323
--,CAST(NULL AS nvarchar(100)) AS [ACCREDITATION_BY] --QUPD ;WITH() ???ADD per MS. K Callies ON 20170323
,CASE
WHEN accredboard.AccreditationTypeName IS NOT NULL
THEN 'YES'
ELSE 'NO'
END AS [ACCREDITATION] --ANOTHER REVERSAL per S. COLEMAN email ON 20170522 ADD per MS. K Callies ON 20170323
,CASE
WHEN accredboard.AccreditationTypeName IS NULL
THEN 'NA'
ELSE UPPER(LTRIM(RTRIM(accredboard.AccreditationTypeName)))
END AS [ACCREDITATION_BY] --THANKS TO YOUNG LADY LAURA ON 20180130 see LEFT JOIN (SELECT DISTINCT LocationID,PracticeID,AccreditationTypeCode,AccreditationTypeName FROM eVips_chgcv.dbo.vwLocationAccreditations AS vla WHERE vla.Archived IN ('N') OR vla.Archived IS NULL) AS accredboard .

...INTO ##INNETWORK_FAC







--,'N' AS [BoardCertified(Y/N)] --QUPD ;WITH()  ???
,CASE
WHEN SUBSTRING(UPPER(LTRIM(RTRIM(ISNULL(vps.BoardCertified,'')))),1,1) != 'N'
	AND UPPER(LTRIM(RTRIM(ISNULL(vps.Archived,'')))) IN ('N')  --Per S. Coleman email ON 20171229 '...Board cert status is incorrect ...'
	AND vps.BoardName IS NOT NULL
THEN 'Y'
ELSE 'N'
END AS [BoardCertified(Y/N)]
,CASE
WHEN SUBSTRING(UPPER(LTRIM(RTRIM(ISNULL(vps.BoardCertified,'')))),1,1) != 'N'
	AND UPPER(LTRIM(RTRIM(ISNULL(vps.Archived,'')))) IN ('N')  --Per S. Coleman email ON 20171229 '...Board cert status is incorrect ...'
THEN UPPER(LTRIM(RTRIM(vps.BoardName))) 
ELSE 'NA'
END AS [BoardName] --[SAMPLE / EXAMPLE] For example see v18422 Dr. Blum: His cert_provider specialties are 'CRV' and 'CET'.  When you link to the master_cred table, it show he is board certified in 'CRV' and not certified in 'CET'.  Since the 'CRV' is YES, you would then link to the board_cert table to see which board.  Please make sure this is a tight join because Dr. Blum is also board certified in INM but this info is not needed.  His board_cert.specialty 'CRV' shows the cert_code AIM which matches to the sys_lookups set name cert_code.  That description is American Board of Internal Medicine. So 'CET' board status would show NO, but his 'CRV' would show YES (American Board of Internal Medicine).  Please call me if you have any questions. Thanks! AND --ADD per MS. K Callies ON 20170323

,CASE
WHEN SUBSTRING(UPPER(LTRIM(RTRIM(ISNULL(vps.BoardCertified,'')))),1,1) != 'N'
	AND UPPER(LTRIM(RTRIM(ISNULL(vps.Archived,'')))) IN ('N')  --Per S. Coleman email ON 20171229 '...Board cert status is incorrect ...'
	AND vps.BoardName IS NOT NULL
THEN 'YES'
ELSE 'NO'
END AS [ACCREDITATION] --ANOTHER REVERSAL per S. COLEMAN email ON 20170522 ADD per MS. K Callies ON 20170323
,CASE
WHEN SUBSTRING(UPPER(LTRIM(RTRIM(ISNULL(vps.BoardCertified,'')))),1,1) != 'N'
	AND UPPER(LTRIM(RTRIM(ISNULL(vps.Archived,'')))) IN ('N')  --Per S. Coleman email ON 20171229 '...Board cert status is incorrect ...'
	AND vps.BoardName IS NOT NULL
THEN UPPER(LTRIM(RTRIM(vps.BoardName))) 
ELSE 'NA'
END AS [ACCREDITATION_BY] --[SAMPLE / EXAMPLE] For example see v18422 Dr. Blum: His cert_provider specialties are 'CRV' and 'CET'.  When you link to the master_cred table, it show he is board certified in 'CRV' and not certified in 'CET'.  Since the 'CRV' is YES, you would then link to the board_cert table to see which board.  Please make sure this is a tight join because Dr. Blum is also board certified in INM but this info is not needed.  His board_cert.specialty 'CRV' shows the cert_code AIM which matches to the sys_lookups set name cert_code.  That description is American Board of Internal Medicine. So 'CET' board status would show NO, but his 'CRV' would show YES (American Board of Internal Medicine).  Please call me if you have any questions. Thanks! AND --ADD per MS. K Callies ON 20170323

...INTO ##INNETWORK_PROV







,CASE
WHEN UPPER(LTRIM(RTRIM(pcp.[BoardCertified(Y/N)]))) = 'Y'
THEN 'YES'
ELSE 'Non Applicable'
END AS [BOARD CERTIFIED]

,CASE
WHEN UPPER(LTRIM(RTRIM(spe.[BoardCertified(Y/N)]))) = 'Y'
THEN 'YES'
ELSE 'Non Applicable'
END AS [BOARD CERTIFIED]







SET [BOARD CERTIFIED] = 'Non Applicable' -- 'NO'







'SIR HORACIO FINDING'(s) - Good afternoon, After testing the most up to date online directory we had a total of five findings.

Walter, we did find an archived inactive facility on the online directory for PCP JEFFERIS, LAUREN MD. Could you please take a look at this one to find the reason why this archived practice location is pulling into the directory. 

These next findings are for IS. I did go over the information from Walter’s  raw Excel directory sheet and confirmed that the information is correct, so for some reason the online directory is not pulling the correct info.  

					•	Board Certification field shows blank on the online directory and its showing “NO” on Walter’s raw Excel for MCCONNELL, AMANDA, PA. 
					•	Hospital Affiliation field on the online directory is not pulling the complete information. For URISOTE, ALEXANDER, MD is only pulling “THORTON HOSPITAL” and it should pull “UNIVERSITY OF CALIFORNIA SAN DIEGO MEDICAL CENTER” as well. 
					•	The Hours of Operation field is not pulling the complete information, ADAMS, TALIA, PA is missing hours for SAT and SUN. 

Please let me know if you have any questions. Thank you for your patience. 
Best Regards, 
Horacio Lora 

x PVH MISSING 'GAH' FROM ,UPPER(LTRIM(RTRIM(vlp.focus))) AS [Type of Service FOCUS] --,'Free Standing - Primary and/or Specialty Care' AS [Type of Service]

SELECT DISTINCT TESTING FROM INFORMATICS.dbo.PROVDIR_HOSGENERALACUTE ORDER BY TESTING

SELECT [Type of Service FOCUS],ServiceTypeName,ServiceCategoryTypeName,plan_type,[vlpSTATUSTYPENAME],ISNULL(CAST(spe.HospitalName AS nvarchar(100)),'')+' '+ISNULL(CAST(spe.HOSPabbrev AS nvarchar(100)),'')+' ID# '+ISNULL(CAST(spe.provider_no AS nvarchar(25)),'') COLLATE DATABASE_DEFAULT AS [TESTING],* --CHECK 1st
--SELECT DISTINCT [Participating Network],ISNULL(CAST(spe.HospitalName AS nvarchar(100)),'')+' '+ISNULL(CAST(spe.HOSPabbrev AS nvarchar(100)),'')+' ID# '+ISNULL(CAST(spe.provider_no AS nvarchar(25)),'') COLLATE DATABASE_DEFAULT AS [TESTING],HospitalName,vlpSERVICETYPENAME,ServiceTypeName,ServiceCategoryTypeName,plan_type,[Type of Service FOCUS],Code1,Code2 --CHECK 1st
FROM INFORMATICS.dbo.TimelyAccessFAC AS spe

WHERE FacilityName LIKE '%PARA%VALL%'

WHERE
( -- INITIATE ...
(-- INITIATE ...
spe.vlpSERVICETYPENAME LIKE '%HOSPITAL%'
		OR UPPER(LTRIM(RTRIM(spe.ServiceTypeName))) LIKE '%HOSPITAL%' --per YOUNG LADY LAURA email ON 20171221 To determine the type of Facility we should only rely on the vwLocationProductServices.servicetypename.  This applies to other Facility Chapters. Community clinics are the exception as they are identified by locationTypeName  = ‘Practice - CC’
		OR UPPER(LTRIM(RTRIM(spe.ServiceCategoryTypeName))) LIKE '%HOSPITAL%' --LEFT JOIN (SELECT DISTINCT PracticeID,ClassOrCategory, ServiceTypeName,ServiceCategoryTypeName FROM eVips_chgcv.dbo.vwLocationServices WHERE ServiceTypeName LIKE '%GROUP%SPEC%') AS vls ON vls.PracticeID = vp.PracticeID --DEFINE FAC CHAPTER(s) 
) --CONCLUDE ...		
	AND spe.plan_type = 'FACILITY'
	AND spe.[vlpSTATUSTYPENAME] LIKE 'ACTIVE%' --•	ADD ON TO FAC per PROVDIR meeting ON 20171226
) --CONCLUDE ...
AND spe.[Type of Service FOCUS] LIKE '%GAH%'

WHERE UPPER(LTRIM(RTRIM(vpd.LastName))) LIKE '%HOSEI%'
	AND UPPER(LTRIM(RTRIM(vpd.FirstName))) LIKE '%NADE%'

SELECT lookup_key,INDEXNM,[BOARD CERTIFIED],ACCREDITATION,FINALhosp,[Office Hour(s)],DSFlag,* 
--INTO ##DERIVED
-- SELECT * --CHECK 1st
-- SELECT DISTINCT --CHECK 1st
FROM --see BELOW
( -- INITIATE ...
SELECT 'CATEGORY - '+UPPER(LTRIM(RTRIM(ZIP))) AS [GEOACCESS_PROVID],*
-- SELECT DISTINCT [ACCREDITATION_BY] --CHECK 1st
FROM INFORMATICS.dbo.PROVDIR_PCP --PROV(s)
UNION -- VERTICAL() STACK ALL()
SELECT 'CATEGORY - '+UPPER(LTRIM(RTRIM(ZIP))) AS [GEOACCESS_PROVID],*
-- SELECT DISTINCT [ACCREDITATION_BY] --CHECK 1st
FROM INFORMATICS.dbo.PROVDIR_NPMP --PROV(s)
UNION -- VERTICAL() STACK ALL()
SELECT 'CATEGORY - '+UPPER(LTRIM(RTRIM(ZIP))) AS [GEOACCESS_PROVID],*
-- SELECT DISTINCT [ACCREDITATION_BY] --CHECK 1st
FROM INFORMATICS.dbo.PROVDIR_SPE --PROV(s)
UNION -- VERTICAL() STACK ALL()
SELECT 'CATEGORY - '+UPPER(LTRIM(RTRIM(ZIP))) AS [GEOACCESS_PROVID],*
-- SELECT DISTINCT [ACCREDITATION_BY] --CHECK 1st
FROM INFORMATICS.dbo.PROVDIR_MH --PROV(s)
UNION -- VERTICAL() STACK ALL()
SELECT 'CATEGORY - '+UPPER(LTRIM(RTRIM(ZIP))) AS [GEOACCESS_PROVID],*
-- SELECT DISTINCT [ACCREDITATION_BY] --CHECK 1st
FROM INFORMATICS.dbo.PROVDIR_AHP --PROV(s)
UNION -- VERTICAL() STACK ALL()
SELECT 'CATEGORY - '+UPPER(LTRIM(RTRIM(ZIP))) AS [GEOACCESS_PROVID],*
-- SELECT DISTINCT [ACCREDITATION_BY] --CHECK 1st
FROM INFORMATICS.dbo.PROVDIR_VSP --PROV(s)
) AS DERIVED -- DERIVED() ALIASNAME CONCLUDE ...
-- WHERE INDEXNM LIKE '%JEFF%LAUR%' --SHOULD HAVE NO HOSP AFFIL
WHERE INDEXNM LIKE '%MCC%AMA%' --BOARD CERT
-- WHERE INDEXNM LIKE '%URI%ALEX%' --HOSP [THORN...] & [UCSD ...]
-- WHERE INDEXNM LIKE '%ADA%TALIA%' --[Office Hour(s)]
-- WHERE INDEXNM LIKE '%HOSE%NADE%' --[DSflag] footnote(s)
-- WHERE LastName LIKE '%%%'
-- WHERE NPIis IN ('','','','','','')
-- WHERE UPPER(LTRIM(RTRIM([SPEC]))) LIKE'%%%' --THE DESCR... 
--WHERE UPPER(LTRIM(RTRIM([Specialty]))) IN ('','','','','','') --THE CODE...
-- WHERE [INDEXNM] LIKE '%%%%%'

					--SELECT * FROM #COVER_FOR_NO_COVG	ORDER BY ORIGINALlnm,ORIGINALfnmSELECT * FROM #COVER_FOR_NO_COVG	 WHERE ORIGINALlkup IN ('4356614') OR lookup_key IN ('4356614') ORDER BY ORIGINALlnm,ORIGINALfnm
					
					SELECT * FROM ##HOSPpriv WHERE lookup_key IN ('4356614')
					
--WHERE vpp.archived = 'N'  
--	AND vploc.archived = 'N' 
--	AND (vploc.locationtypename = 'Practice-CC'
--		OR UPPER(LTRIM(RTRIM(vploc.PracticeTypeName))) LIKE '%COMM%CLIN%')	
--	AND  vpp.producttypecode LIKE 'SPE%'
WHERE vpp.PractitionerID IN ('4372505')					







'COMMUNITY CLINIC'(s) - Good morning,  Here is a little adjustment for the Community Clinic chapter.  It looks like you are also pulling the remit or dba practice location.  It should only be the location type that start with “Practice”.  See Imperial Beach.  Their regular practice location shows okay but there is a 2nd record with a PO Box that is showing.







'PROVIDER CLINIC'(s) - Hi,  Thanks for the eVIPs directory.  As you know Vistar ran the community clinic providers twice.  We are in the middle of inactivating about 600 providers.  What we did right away is to archive all of the group locations that were duplicate.  Please make sure for any reports including the directory that practicelocations.archived = N.  I still see a few clinic names that are archived in the excel file.  we are starting the pdf review now.

	AND (UPPER(LTRIM(RTRIM(vpl.LocationName))) LIKE '%DEL%MISI%' 
		OR UPPER(LTRIM(RTRIM(vp.PracticeName))) LIKE '%DEL%MISI%')

SELECT DISTINCT LocationName FROM INFORMATICS.dbo.TimelyAccessCLINIC ORDER BY LocationName

	AND UPPER(LTRIM(RTRIM(vploc.LocationName))) IN (SELECT DISTINCT LocationName FROM INFORMATICS.dbo.TimelyAccessCLINIC) --,UPPER(LTRIM(RTRIM(vploc.LocationName))) AS [Clinic Name]

	AND UPPER(LTRIM(RTRIM(vpd.LastName))) LIKE '%POTH%'
	AND UPPER(LTRIM(RTRIM(vpd.FirstName))) LIKE '%PHILLIP%'
	--AND UPPER(LTRIM(RTRIM(vploc.LocationName))) IN (SELECT DISTINCT LocationName FROM INFORMATICS.dbo.TimelyAccessCLINIC) --,UPPER(LTRIM(RTRIM(vploc.LocationName))) AS [Clinic Name]

	AND UPPER(LTRIM(RTRIM(vpd.LastName))) LIKE '%SAF%'
	AND UPPER(LTRIM(RTRIM(vpd.FirstName))) LIKE '%ROOZ%'
	--AND UPPER(LTRIM(RTRIM(vploc.LocationName))) IN (SELECT DISTINCT LocationName FROM INFORMATICS.dbo.TimelyAccessCLINIC) --,UPPER(LTRIM(RTRIM(vploc.LocationName))) AS [Clinic Name]

	AND UPPER(LTRIM(RTRIM(vpd.LastName))) LIKE '%KAUF%'
	AND UPPER(LTRIM(RTRIM(vpd.FirstName))) LIKE '%DAV%'
	--AND UPPER(LTRIM(RTRIM(vploc.LocationName))) IN (SELECT DISTINCT LocationName FROM INFORMATICS.dbo.TimelyAccessCLINIC) --,UPPER(LTRIM(RTRIM(vploc.LocationName))) AS [Clinic Name]

	AND UPPER(LTRIM(RTRIM(vpd.LastName))) LIKE '%CORO%'
	AND UPPER(LTRIM(RTRIM(vpd.FirstName))) LIKE '%MYR%'
	--AND UPPER(LTRIM(RTRIM(vploc.LocationName))) IN (SELECT DISTINCT LocationName FROM INFORMATICS.dbo.TimelyAccessCLINIC) --,UPPER(LTRIM(RTRIM(vploc.LocationName))) AS [Clinic Name]

	AND UPPER(LTRIM(RTRIM(vpd.LastName))) LIKE '%SEBI%'
	AND UPPER(LTRIM(RTRIM(vpd.FirstName))) LIKE '%MARI%'
	--AND UPPER(LTRIM(RTRIM(vploc.LocationName))) IN (SELECT DISTINCT LocationName FROM INFORMATICS.dbo.TimelyAccessCLINIC) --,UPPER(LTRIM(RTRIM(vploc.LocationName))) AS [Clinic Name]







'REVERT BACK' - eVIPs

Hi,  Thanks for the eVIPs directory.  As you know Vistar ran the community clinic providers twice.  We are in the middle of inactivating about 600 providers.  What we did right away is to archive all of the group locations that were duplicate.  Please make sure for any reports including the directory that practicelocations.archived = N.  I still see a few clinic names that are archived in the excel file.  we are starting the pdf review now.

x group practice type = Community clinic see 1295747038 FROM 20180201 PAGE #290 'SCHWARTZ, JOSEPH MD - ID'  provider_no 301116 AND lookup_key 4369851

					CHECK GEOACCESS SOFTWARE



------------------------------------------------------------------------------------------------------------------------------------
----------------	-- Error Trapping: Check If Permanent Table(s) Already Exist(s) And Drop If Applicable --
------------------------------------------------------------------------------------------------------------------------------------
----------------IF OBJECT_ID('TempDB..##DSflag') IS NOT NULL
----------------BEGIN

----------------		DROP TABLE ##DSflag --#TableName is a local temporary table visible only in the current session; ##TableName is a global temporary table visible to all sessions IN ('tempdb')

----------------END

SELECT DISTINCT vpp.PractitionerID AS [lookupkey],vpp.archived,vploc.archived,vploc.locationtypename,vploc.PracticeTypeName,vpp.producttypecode,'Clinic Specialists - for Assigned Members Only' AS [DSflag] --,*
--INTO ##DSflag
--SELECT vploc.locationtypename, vpp.practitionerid, vpp.lastname, vpp.firstname, vpp.practiceid, vpp.practicename, vpp.LocationID, vpp.locationname, vpp.PractitionerTypeCode, vpp.producttypecode, vpp.ProductTypeName --CHECK 1st
--SELECT DISTINCT --CHECK 1st
FROM eVips_chgcv.dbo.vwPractitionerProducts AS vpp
	LEFT JOIN eVips_chgcv.dbo.vwPracticeLocations AS vploc on vploc.practiceid = vpp.practiceid 
		AND vploc.Locationid= vpp.Locationid
--WHERE vpp.archived = 'N'  
--	AND vploc.archived = 'N' 
--	AND (vploc.locationtypename = 'Practice-CC'
--		OR UPPER(LTRIM(RTRIM(vploc.PracticeTypeName))) LIKE '%COMM%CLIN%')	
--	AND  vpp.producttypecode LIKE 'SPE%'
WHERE vpp.PractitionerID IN ('4372505')
--UNION ALL --VERTICAL() w UNION ALL()  - ROW(s) --STACK
SELECT DISTINCT vpp.PractitionerID AS [lookupkey],vpp.archived,vploc.archived,vploc.locationtypename,vploc.PracticeTypeName,vpp.producttypecode,'Per Diem / Part Time Provider - May Have Limited Appt. Availability' AS [DSflag] --,*
--SELECT DISTINCT vpp.PractitionerID AS [lookupkey],vpp.PractitionerID,'Per Diem / Part Time Provider - May Have Limited Appt. Availability' AS [DSflag],*
----SELECT vpp.StatusTypeName,vploc.locationtypename, vpp.practitionerid, vpp.lastname, vpp.firstname, vpp.practiceid, vpp.practicename, vpp.LocationID, vpp.locationname, vpp.PractitionerTypeCode, vpp.producttypecode, vpp.ProductTypeName --CHECK 1st
----SELECT DISTINCT --CHECK 1st
FROM eVips_chgcv.dbo.vwPractitionerProducts AS vpp
	LEFT JOIN eVips_chgcv.dbo.vwPracticeLocations AS vploc on vploc.practiceid = vpp.practiceid 
		AND vploc.Locationid= vpp.Locationid
--WHERE vpp.archived = 'N'  
--	AND vploc.archived = 'N' 
--	AND UPPER(LTRIM(RTRIM(vpp.StatusTypeName))) LIKE 'ACT%PER%DIE%'
--	AND vpp.PractitionerID IN ('4372505')
WHERE vpp.PractitionerID IN ('4372505')

					--SELECT * FROM ##DSflag --RELATED TO PROV(s) ONLY







UPDATE ##INNETWORK_PROV
SET [DSflag] = UPPER(LTRIM(RTRIM(qupd.[DSflag]))) --RELATED TO PROV(s) ONLY
--SELECT * --CHECK 1st
FROM ##INNETWORK_PROV AS inet
	JOIN ##DSflag AS qupd ON UPPER(LTRIM(RTRIM(qupd.PractitionerID))) = UPPER(LTRIM(RTRIM(inet.lookup_key))) --,UPPER(LTRIM(RTRIM(vpd.PractitionerID))) AS 'lookup_key'
		--AND UPPER(LTRIM(RTRIM(qupd.PracticeID))) = UPPER(LTRIM(RTRIM(inet.PracticeID)))
		--AND UPPER(LTRIM(RTRIM(qupd.LocationID))) = UPPER(LTRIM(RTRIM(inet.LocationID)))
		--AND UPPER(LTRIM(RTRIM(qupd.AddressID))) = UPPER(LTRIM(RTRIM(inet.AddressID)))	

SELECT DSflag,* FROM INFORMATICS.dbo.PROVDIR_SPE WHERE NPIis IN ('1295747038')
SELECT DSflag,* FROM INFORMATICS.dbo.PROVDIR_SPE WHERE NPIis IN ('1295747038')
SELECT * FROM ##DSflag WHERE PractitionerID IN ('4369851')

SELECT vpp.StatusTypeName,vploc.PracticeTypeName,* --CHECK 1st
--SELECT DISTINCT vpp.PractitionerID,'Clinic Specialists - for Assigned Members Only' AS [DSflag]
--,vploc.LocationID,vploc.PracticeID,vploc.AddressID
FROM eVips_chgcv.dbo.vwPractitionerProducts AS vpp
	LEFT JOIN eVips_chgcv.dbo.vwPracticeLocations AS vploc on vploc.practiceid = vpp.practiceid 
		AND vploc.Locationid= vpp.Locationid
WHERE PractitionerID IN ('4369851')
	AND vpp.archived = 'N'  
	AND vploc.archived = 'N' 

SELECT DISTINCT ProductTypeCode,ProductTypeName FROM evips_chgcv.dbo.vwLocationProducts 
SELECT DISTINCT ProductTypeCode,ProductTypeName FROM eVips_chgcv.dbo.vwPractitionerProducts

	AND vwLocationProducts.ProductTypeName IN ('FAC', 'ANC','MEDICAL') --MEDICAL Should Go Away

Thank you,
Laura Infante

Hi,  Please do not run the eVIPs directory until we meet.  I will check everyone’s calendar right now.  I know your directory has a lot more query elements.  This is my simple crystal query for eVIPs facilities (in and not in directory).

{vwPracticeLocations.LocationTypeName} startswith "Practice" and
{vwLocationProducts.StatusTypeName} startswith "Active" and
{vwLocationProducts.Archived} = "N" and
not ({vwLocationProducts.LocationName} like "*inactive*") 
and {vwLocationProductServices.Archived} = "N"

AND (UPPER(LTRIM(RTRIM(vpl.LocationName))) LIKE '%BORREGO%COMM%FOUND%' 
	OR UPPER(LTRIM(RTRIM(vp.PracticeName))) LIKE '%BORREGO%COMM%FOUND%'
	OR UPPER(LTRIM(RTRIM(vp.PracticeID))) = '4108812'
	--OR UPPER(LTRIM(RTRIM(vpl.LocationName))) LIKE '%AFC%URG%'
	--OR UPPER(LTRIM(RTRIM(vp.PracticeName))) LIKE '%AFC%URG%'
	)

	AND (UPPER(LTRIM(RTRIM(vlp.ServiceTypeName))) LIKE '%URG%CAR%CENT%'
		OR UPPER(LTRIM(RTRIM(vls.ServiceCategoryTypeName))) LIKE '%URG%CAR%CENT%')
	
SELECT DISTINCT plan_type FROM ##INNETWORK_FAC --WHERE FacilityName LIKE '%BORREGO%COMM%FOUND%'

SELECT DISTINCT ljvlp.PracticeTypeName,vlpstype.ServiceTypeName FROM eVips_chgcv.dbo.vwLocationProducts AS ljvlp JOIN evips_chgcv.dbo.vwLocationProductServices AS vlpstype ON vlpstype.LocationProductRecID = ljvlp.LocationProductRecID WHERE (ljvlp.Archived IN ('N') OR ljvlp.Archived IS NULL) AND (ljvlp.StatusTypeName IN ('ACTIVE') OR ljvlp.StatusTypeName LIKE '%PARTICIP%' OR ljvlp.StatusTypeName IS NULL) AND (vlpstype.Archived IN ('N') OR vlpstype.Archived IS NULL)

SELECT * FROM evips_chgcv.dbo.vwLocationProducts WHERE PracticeID = '4108812'

SELECT DISTINCT ProductTypeCode FROM evips_chgcv.dbo.vwProductTemplateItems
SELECT DISTINCT ProductTypeCode FROM evips_chgcv.dbo.vwPractitionerProducts
SELECT DISTINCT ProductTypeCode FROM evips_chgcv.dbo.vwPractitionerDemographics

SELECT DISTINCT ljvlp.ProductTypeCode,ljvlp.PracticeTypeName,ljvlp.PracticeID,ljvlp.LocationID,ljvlp.Archived,ljvlp.StatusTypeName,vlpstype.indirectory,vlpstype.ServiceTypeName,ljvlp.productname,ljvlp.ProductPanelStatusTypeName,ljvlp.ProductPanelStatusTypeCode,ljvlp.ProviderNumber,ljvlp.Focus,ljvlp.ProductID,ljvlp.LocationTypeName FROM eVips_chgcv.dbo.vwLocationProducts AS ljvlp JOIN evips_chgcv.dbo.vwLocationProductServices AS vlpstype ON vlpstype.LocationProductRecID = ljvlp.LocationProductRecID WHERE (ljvlp.Archived IN ('N') OR ljvlp.Archived IS NULL) AND (ljvlp.StatusTypeName IN ('ACTIVE') OR ljvlp.StatusTypeName LIKE '%PARTICIP%' OR ljvlp.StatusTypeName IS NULL) AND (vlpstype.Archived IN ('N') OR vlpstype.Archived IS NULL

USE evips_chgcv

DECLARE @tblis AS nvarchar(88)
DECLARE @tbltype AS nvarchar(88)
DECLARE @tblwas AS nvarchar(88)
DECLARE @tblwillbe AS nvarchar(88)
DECLARE @fieldis AS nvarchar(88)
DECLARE @fieldwas AS nvarchar(88)
DECLARE @fieldwillbe AS nvarchar(88)

SET @tblis  = '%%'--UPDATE AS NEEDED HERE WITHIN THE ‘’
SET @tbltype  = '%%'--UPDATE AS NEEDED HERE WITHIN THE ‘’
SET @tblwas  = '%%'--UPDATE AS NEEDED HERE WITHIN THE ‘’
SET @tblwillbe  = '%%'--UPDATE AS NEEDED HERE WITHIN THE ‘’
SET @fieldis  = '%produc%type%code%'--UPDATE AS NEEDED HERE WITHIN THE ‘’ ISO w createid OR dreatedate
SET @fieldwas  = '%%'--UPDATE AS NEEDED HERE WITHIN THE ‘’
SET @fieldwillbe  = '%%'--UPDATE AS NEEDED HERE WITHIN THE ‘’

SELECT *
-- SELECT * FROM INFORMATION_SCHEMA.TABLES --CHECK 1st
FROM INFORMATION_SCHEMA.COLUMNS AS isc
	JOIN INFORMATION_SCHEMA.TABLES AS ist ON ist.TABLE_NAME = isc.TABLE_NAME
WHERE isc.TABLE_NAME LIKE @tblis
	AND isc.COLUMN_NAME LIKE @fieldis
	AND ist.TABLE_TYPE LIKE @tbltype
	AND isc.TABLE_NAME IN (SELECT iscwas.TABLE_NAME
FROM INFORMATION_SCHEMA.COLUMNS AS iscwas
WHERE iscwas.TABLE_NAME LIKE @tblwas
	AND iscwas.COLUMN_NAME LIKE @fieldwas)
	AND isc.TABLE_NAME IN (SELECT iscwillbe.TABLE_NAME
FROM INFORMATION_SCHEMA.COLUMNS AS iscwillbe
WHERE iscwillbe.TABLE_NAME LIKE @tblwillbe
	AND iscwillbe.COLUMN_NAME LIKE @fieldwillbe)
ORDER BY isc.TABLE_NAME,isc.COLUMN_NAME







--SELECT * --CHECK 1st
--SELECT * FROM eVips_chgcv.dbo.vwEntityAssignments WHERE UPPER(LTRIM(RTRIM(TableName))) LIKE '%Practice%' AND UPPER(LTRIM(RTRIM(EntityName))) LIKE '%MED%IMPA%'
--SELECT DISTINCT [DEGREE DESCRIPTION] --CHECK 1st
SELECT DISTINCT [Pharmacy Name],NPIis,Address,VP_plan_type,VLP_plan_type,VLP_Alt_plan_type,[INDIRECTORY] --CHECK 1st
--SELECT DISTINCT plan_type --CHECK 1st
--SELECT DISTINCT [Type of Service] --CHECK 1st ,UPPER(LTRIM(RTRIM(vpl.PracticeTypeName)))AS [Type of Service] --,'Free Standing - Primary and/or Specialty Care' AS [Type of Service]
FROM ##INNETWORK_FAC
WHERE
--( --INITIATE ...
UPPER(LTRIM(RTRIM(EntityName))) LIKE '%MED%IMPA%' --AFFIRMATIVE --,vea.TableName,vea.EntityCode,vea.EntityName,vea.EntityTypeCode,vea.EntityTypeName
	--AND (plan_type IS NULL --FAC(s) ;WITH() ,UPPER(LTRIM(RTRIM(vp.PracticeTypeName))) AS [plan_type]
	--	OR UPPER(LTRIM(RTRIM(plan_type))) NOT LIKE '%COMM%CLIN%' --see 'TimelyAccessCLINIC' --,UPPER(LTRIM(RTRIM(vp.PracticeTypeName))) AS [plan_type] 1003162868
--) --CONCLUDE ...		
	--OR vlspharmPHARMACYTYPENAME IS NOT NULL
	--AND vplLOCATIONTYPENAME LIKE '%PRACTI%'
	AND LTRIM(RTRIM(ISNULL([INDIRECTORY],''))) LIKE '%Y%' --SET @INDIR ='Y'--REMOVE FILTER FOR JOSEPH / TIMELYACCESS HBP(s)... '%' OR 'Y'  OR 'N'--SUBSTRING(UPPER(LTRIM(RTRIM(cert_provider.in_directory))),1,1) LIKE @INDIR --see 'LTRIM(RTRIM(mcred.retrieve_list)) LIKE '%CN%V%'
	--AND UPPER(LTRIM(RTRIM(plan_type))) NOT LIKE '%COMM%CLIN%' --see 'TimelyAccessCLINIC' --,UPPER(LTRIM(RTRIM(vp.PracticeTypeName))) AS [plan_type] 1003162868	
--) --CONCLUDE ...







'YOUNG LADY LAURA' - UI / UX: ('http://chgevip.chg.com/evips/#/Home')  
Hi Walter, Sandra,  eVIPs has been successfully moved to production environment. Your team may begin with the data entry.  The production database is on SQLPRODAPP01.evips_chgcv     Thank you, Laura Infante

		UID: vipadmin
		PW: Vistar123$

SELECT * FROM 'SERVERname'.'DATABASEname'.'SCHEMAname'.'OBJECTname' - FOUR (4) PART() SCHEMA()  aka [SERVERname].[DATABASEname].[SCHEMAname].[OBJECTname] - see 'SQLPRODAPP01.evips_chgcv.dbo.' WAS 'SQL07.evips_chgcv.dbo.'

x We now have an eVIPs test environment.  Link: 'http://chgevip-test.chg.com/eVIPs/#/Home'   The test DB is on 'SQLTest01.evips_chgcv'

x ARCHIVE STATUS() UPPER(LTRIM(RTRIM(ISNULL(vpa.Archived,'')))) IN ('N')  --Per S. Coleman email ON 20171229 '...Some archived Hospital privileges are showing: ...'

x 'SUBJECT: Provider Directory Conversion Status'
x 'SUBJECT: Provider Directory Conversion Status (Iteration FROM 12/06/2017)'

x 'SUBJECT: TEST eVIP Provider Directory (Online & PDF)'







'BOARD CERTIFICATION(s) / ACCREDITATION(s)' - FAC(s)
x IN eVIPS

--,'N' AS [BoardCertified(Y/N)] --QUPD ;WITH()  ???
,CASE
WHEN UPPER(LTRIM(RTRIM(vps.BoardCertified))) != 'N'
THEN 'Y'
ELSE 'N'
END AS [BoardCertified(Y/N)]
,CASE
WHEN SUBSTRING(UPPER(LTRIM(RTRIM(vps.BoardCertified))),1,1) = 'N'
THEN 'NA'
ELSE UPPER(LTRIM(RTRIM(vps.BoardName))) 
END AS [BoardName] --[SAMPLE / EXAMPLE] For example see v18422 Dr. Blum: His cert_provider specialties are 'CRV' and 'CET'.  When you link to the master_cred table, it show he is board certified in 'CRV' and not certified in 'CET'.  Since the 'CRV' is YES, you would then link to the board_cert table to see which board.  Please make sure this is a tight join because Dr. Blum is also board certified in INM but this info is not needed.  His board_cert.specialty 'CRV' shows the cert_code AIM which matches to the sys_lookups set name cert_code.  That description is American Board of Internal Medicine. So 'CET' board status would show NO, but his 'CRV' would show YES (American Board of Internal Medicine).  Please call me if you have any questions. Thanks! AND --ADD per MS. K Callies ON 20170323

,CASE
WHEN SUBSTRING(UPPER(LTRIM(RTRIM(ISNULL(vps.BoardCertified,'')))),1,1) != 'N'
	AND UPPER(LTRIM(RTRIM(ISNULL(vps.Archived,'')))) IN ('N')  --Per S. Coleman email ON 20171229 '...Board cert status is incorrect ...'
	AND vps.BoardName IS NOT NULL
THEN 'YES'
ELSE 'NO'
END AS [ACCREDITATION] --ANOTHER REVERSAL per S. COLEMAN email ON 20170522 ADD per MS. K Callies ON 20170323
,CASE
WHEN SUBSTRING(UPPER(LTRIM(RTRIM(ISNULL(vps.BoardCertified,'')))),1,1) != 'N'
	AND UPPER(LTRIM(RTRIM(ISNULL(vps.Archived,'')))) IN ('N')  --Per S. Coleman email ON 20171229 '...Board cert status is incorrect ...'
THEN UPPER(LTRIM(RTRIM(vps.BoardName))) 
ELSE 'NA'
END AS [ACCREDITATION_BY] --[SAMPLE / EXAMPLE] For example see v18422 Dr. Blum: His cert_provider specialties are 'CRV' and 'CET'.  When you link to the master_cred table, it show he is board certified in 'CRV' and not certified in 'CET'.  Since the 'CRV' is YES, you would then link to the board_cert table to see which board.  Please make sure this is a tight join because Dr. Blum is also board certified in INM but this info is not needed.  His board_cert.specialty 'CRV' shows the cert_code AIM which matches to the sys_lookups set name cert_code.  That description is American Board of Internal Medicine. So 'CET' board status would show NO, but his 'CRV' would show YES (American Board of Internal Medicine).  Please call me if you have any questions. Thanks! AND --ADD per MS. K Callies ON 20170323

		LEFT JOIN eVips_chgcv.dbo.vwPractitionerSpecialties AS vps ON UPPER(LTRIM(RTRIM(vps.PractitionerID))) = UPPER(LTRIM(RTRIM(vpd.PractitionerID)))	
			AND UPPER(LTRIM(RTRIM(vps.specialtycode))) = UPPER(LTRIM(RTRIM(vpps.specialtycode)))

	JOIN eVips_chgcv.dbo.vwPractitionerLocations AS vploc ON UPPER(LTRIM(RTRIM(vploc.PractitionerID))) = UPPER(LTRIM(RTRIM(vpd.PractitionerID)))
		AND UPPER(LTRIM(RTRIM(vploc.PracticeID))) = UPPER(LTRIM(RTRIM(vpp.PracticeID)))
		AND UPPER(LTRIM(RTRIM(vploc.LocationID))) = UPPER(LTRIM(RTRIM(vpp.LocationID)))

SELECT * FROM eVips_chgcv.dbo.vwLocationAccreditations
SELECT DISTINCT LocationID,PracticeID,AccreditationTypeCode,AccreditationTypeName FROM eVips_chgcv.dbo.vwLocationAccreditations AS vla WHERE vla.Archived IN ('N') OR vla.Archived IS NULL

WHERE LTRIM(RTRIM(vpl.NationalProviderID)) IN ('1659359446')

		LEFT JOIN (SELECT DISTINCT LocationID,PracticeID,AccreditationTypeCode,AccreditationTypeName FROM eVips_chgcv.dbo.vwLocationAccreditations AS vla WHERE vla.Archived IN ('N') OR vla.Archived IS NULL) AS accredboard ON accredboard.LocationID =vpl.LocationID
			AND accredboard.PracticeID = vpl.PracticeID

--,'N' AS [BoardCertified(Y/N)] --QUPD ;WITH()  ???
,CASE
WHEN accredboard.AccreditationTypeName IS NOT NULL
THEN 'Y'
ELSE 'N'
END AS [BoardCertified(Y/N)]
,CASE
WHEN accredboard.AccreditationTypeName IS NULL
THEN 'NA'
ELSE UPPER(LTRIM(RTRIM(accredboard.AccreditationTypeName)))
END AS [BoardName] --THANKS TO YOUNG LADY LAURA ON 20180130 see LEFT JOIN (SELECT DISTINCT LocationID,PracticeID,AccreditationTypeCode,AccreditationTypeName FROM eVips_chgcv.dbo.vwLocationAccreditations AS vla WHERE vla.Archived IN ('N') OR vla.Archived IS NULL) AS accredboard ...

--,CAST(NULL AS nvarchar(1)) AS [ACCREDITATION] --QUPD ;WITH() ??? ANOTHER REVERSAL per S. COLEMAN email ON 20170522 ADD per MS. K Callies ON 20170323
--,CAST(NULL AS nvarchar(100)) AS [ACCREDITATION_BY] --QUPD ;WITH() ???ADD per MS. K Callies ON 20170323
,CASE
WHEN accredboard.AccreditationTypeName IS NOT NULL
THEN 'YES'
ELSE 'NO'
END AS [ACCREDITATION] --ANOTHER REVERSAL per S. COLEMAN email ON 20170522 ADD per MS. K Callies ON 20170323
,CASE
WHEN accredboard.AccreditationTypeName IS NULL
THEN 'NA'
ELSE UPPER(LTRIM(RTRIM(accredboard.AccreditationTypeName)))
END AS [ACCREDITATION_BY] --THANKS TO YOUNG LADY LAURA ON 20180130 see LEFT JOIN (SELECT DISTINCT LocationID,PracticeID,AccreditationTypeCode,AccreditationTypeName FROM eVips_chgcv.dbo.vwLocationAccreditations AS vla WHERE vla.Archived IN ('N') OR vla.Archived IS NULL) AS accredboard .







-- ====================================================================
	-- REVIEW / RESEARCH ;WITH SQL07.eVips_chgcv. OR 'QLPRODAPP01.evips_chgcv.dbo.' --
-- ====================================================================
-- INTO ##INNETWORK_FAC
SELECT DISTINCT UPPER(LTRIM(RTRIM(vlp.InDirectory))) AS [INDIRECTORY]
,vlp.ProductName
,UPPER(LTRIM(RTRIM(vp.PracticeID))) AS [lookup_key]
,UPPER(LTRIM(RTRIM(vp.PracticeTypeName))) AS [plan_type],vea.TableName,vea.EntityCode,vea.EntityName,vea.EntityTypeCode,vea.EntityTypeName 
,vp.PracticeName,vpl.LocationName,vp.LegalName AS [VPLegalName],vpl.LegalName AS [VPLLegalName]
,UPPER(LTRIM(RTRIM(vpl.LocationName))) AS [HospitalName]
,UPPER(LTRIM(RTRIM(vpl.LocationName))) AS [FacilityName]
,UPPER(LTRIM(RTRIM(vpl.LocationName))) AS [Clinic Name]
,UPPER(LTRIM(RTRIM(vpl.LocationName))) AS [Pharmacy Name] --We have most of the NPIs for the clinics.  They are located in the NPI field in the address master
,UPPER(LTRIM(RTRIM(vp.PracticeName))) AS [Alt. Clinic Name]
,UPPER(LTRIM(RTRIM(vp.PracticeName))) AS [ClinicNameAgain]
-- ,LTRIM(RTRIM(vpl.NationalProviderID)) AS NPIis
,LTRIM(RTRIM(vp.NationalProviderID)) AS altNPIis
,REPLACE(UPPER(LTRIM(RTRIM(vf.TaxIDNumber))),'-','') AS vfPROVTAXID
,CASE
WHEN vpl.NationalProviderID IS NULL
	AND UPPER(LTRIM(RTRIM(vf.FacilityStatus))) LIKE 'ACTIVE%'
	AND UPPER(LTRIM(RTRIM(vf.ApplicationStatus))) LIKE 'ACTIVE%'
THEN LTRIM(RTRIM(vf.NationalProviderID))
ELSE LTRIM(RTRIM(vpl.NationalProviderID)) 
END AS [NPIis]
,UPPER(LTRIM(RTRIM(vp.Archived))) AS [vpARCHIVED]
,UPPER(LTRIM(RTRIM(vp.PracticeStatus))) AS [vpPRACTICESTATUS]
,UPPER(LTRIM(RTRIM(vp.ApplicationStatus))) AS [vpAPPLICATIONSTATUS]
,UPPER(LTRIM(RTRIM(vpl.Archived))) AS [vplARCHIVED]
,UPPER(LTRIM(RTRIM(vpl.LocationTypeName))) AS [vplLOCATIONTYPENAME]
,UPPER(LTRIM(RTRIM(vlp.LocationTypeName))) AS [vlpLOCATIONTYPENAME]
,UPPER(LTRIM(RTRIM(vlp.StatusTypeName))) AS [vlpSTATUSTYPENAME]
,UPPER(LTRIM(RTRIM(vlp.ServiceTypeName))) AS [vlpSERVICETYPENAME]
,UPPER(LTRIM(RTRIM(vlp.focus))) AS [Type of Service FOCUS] --,'Free Standing - Primary and/or Specialty Care' AS [Type of Service]
,vlp.Focus,vlsfocus.Code1,vlsfocus.Code2,vp.Archived,vp.PracticeStatus,vp.ApplicationStatus,vpl.Archived,vpl.LocationTypeName,vp.PracticeTypeName
,UPPER(LTRIM(RTRIM(vls.ServiceTypeName))) AS [vlsSERVICETYPENAME]
,UPPER(LTRIM(RTRIM(vls.ServiceCategoryTypeName))) AS [vlsSERVICECATEGORYTYPENAME] --DEFINE FAC CHAPTER(s)
,UPPER(LTRIM(RTRIM(vlsfocus.ServiceTypeName))) AS [vlsfocusSERVICETYPENAME]
,UPPER(LTRIM(RTRIM(vlsfocus.ServiceCategoryTypeName))) AS [vlsfocusSERVICECATEGORYTYPENAME] --MIMIC cp.focus
,UPPER(LTRIM(RTRIM(vp.PracticeTypeName))) AS [PROVIDER_TYPEdescr]
,CASE
WHEN LTRIM(RTRIM(vlp.ProductName)) LIKE '%MEDICAL%'
THEN 'CL1'
WHEN LTRIM(RTRIM(vlp.ProductName)) LIKE '%MEDICAR%'
THEN 'MCR'
WHEN LTRIM(RTRIM(vlp.ProductName)) LIKE '%CMC%'
THEN 'CMC'
ELSE CAST(NULL AS nvarchar(MAX))
END AS [Participating Network],vlp.ProductName
-- ,CAST(NULL AS nvarchar(255)) AS [Pharmacy Type(s)]  --QUPD ;WITH() ??? ,UPPER(LTRIM(RTRIM(address.userdef_2))) AS [Pharmacy Type(s)] --,UPPER(LTRIM(RTRIM(address.userdef_2))) AS [Accessibility Category(ies)]
,UPPER(LTRIM(RTRIM(vlspharmtype.ServiceCategoryTypeName))) AS [Pharmacy Type(s)]
,UPPER(LTRIM(RTRIM(vlspharmtype.PracticeID))) AS [vlspharmtypePHARMACYPRACTICEID]
,UPPER(LTRIM(RTRIM(vlspharmtype.ClassOrCategory))) AS [vlspharmtypePHARMACYCLASS]
,UPPER(LTRIM(RTRIM(vlspharmtype.ServiceTypeName))) AS [vlspharmtypePHARMACYSERVICETYPE]
,UPPER(LTRIM(RTRIM(vlspharmtype.ServiceCategoryTypeName))) AS [vlspharmtypePHARMACYTYPENAME]
-- ,CAST(NULL AS nvarchar(255)) AS [Pharmacy Footnote(s)]  --QUPD ;WITH() ???,UPPER(LTRIM(RTRIM(address.npi_subpart))) AS [Pharmacy Footnote(s)]
,UPPER(LTRIM(RTRIM(vlspharmservice.ServiceCategoryTypeName))) AS [Pharmacy Footnote(s)]
,CAST(NULL AS nvarchar(255)) AS [npi_subpart]  --QUPD ;WITH() ??? ,address.npi_subpart
,UPPER(LTRIM(RTRIM(vlspharmservice.PracticeID))) AS [vlspharmservicePHARMACYPRACTICEID]
,UPPER(LTRIM(RTRIM(vlspharmservice.ClassOrCategory))) AS [vlspharmservicePHARMACYCLASS]
,UPPER(LTRIM(RTRIM(vlspharmservice.ServiceTypeName))) AS [vlspharmservicePHARMACYSERVICETYPE]
,UPPER(LTRIM(RTRIM(vlspharmservice.ServiceCategoryTypeName))) AS [vlspharmservicePHARMACYTYPENAME]	
,UPPER(LTRIM(RTRIM(vpl.LineNumber1))) AS [address1]
,UPPER(LTRIM(RTRIM(vpl.LineNumber2))) AS [address2]
,UPPER(LTRIM(RTRIM(vpl.LineNumber3))) AS [address3]
,CASE
WHEN (UPPER(LTRIM(RTRIM(vpl.LineNumber2))) IN ('')
	OR vpl.LineNumber2 IS NULL)
THEN UPPER(LTRIM(RTRIM(vpl.LineNumber1)))
ELSE UPPER(RTRIM(LTRIM(vpl.LineNumber1)))+' '+UPPER(RTRIM(LTRIM(vpl.LineNumber2)))
END AS [Address]
,UPPER(LTRIM(RTRIM(vpl.City))) AS [CityIs]
,CASE
WHEN UPPER(LTRIM(RTRIM(zip.County))) LIKE 'SD%'
THEN 'SAN DIEGO'
ELSE UPPER(LTRIM(RTRIM(zip.County)))
END AS [CountyIs]
,CASE
WHEN UPPER(LTRIM(RTRIM(zip.County))) LIKE 'SD%'
THEN 'SAN DIEGO'
ELSE UPPER(LTRIM(RTRIM(zip.County)))
END AS [County]
,UPPER(LTRIM(RTRIM(vpl.[State]))) AS StateIs
,CASE
WHEN SUBSTRING(LTRIM(RTRIM(vpl.ZipCode)),1,1) = '0'
THEN '0'+ SUBSTRING(LTRIM(RTRIM(vpl.ZipCode)),2,4)
WHEN SUBSTRING(LTRIM(RTRIM(vpl.ZipCode)),1,1) = '00'
THEN '00'+ SUBSTRING(LTRIM(RTRIM(vpl.ZipCode)),3,3)
ELSE  SUBSTRING(LTRIM(RTRIM(vpl.ZipCode)),1,5) 
END AS [Zip Code] 
,[Telephone Number] = SUBSTRING(LTRIM(RTRIM(PHONEprimary.PhoneNumber)),1,3)+'-'+SUBSTRING(LTRIM(RTRIM(PHONEprimary.PhoneNumber)),4,3)+'-'+SUBSTRING(LTRIM(RTRIM(PHONEprimary.PhoneNumber)),7,4)
,[FAXnumber] = SUBSTRING(LTRIM(RTRIM(PHONEfax.PhoneNumber)),1,3)+'-'+SUBSTRING(LTRIM(RTRIM(PHONEfax.PhoneNumber)),4,3)+'-'+SUBSTRING(LTRIM(RTRIM(PHONEfax.PhoneNumber)),7,4)  -- ,* 
,CASE
WHEN accredboard.AccreditationTypeName IS NOT NULL
THEN 'Y'
ELSE 'N'
END AS [BoardCertified(Y/N)]
,CASE
WHEN accredboard.AccreditationTypeName IS NULL
THEN 'NA'
ELSE UPPER(LTRIM(RTRIM(accredboard.AccreditationTypeName)))
END AS [BoardName] --THANKS TO YOUNG LADY LAURA ON 20180130 see LEFT JOIN (SELECT DISTINCT LocationID,PracticeID,AccreditationTypeCode,AccreditationTypeName FROM eVips_chgcv.dbo.vwLocationAccreditations AS vla WHERE vla.Archived IN ('N') OR vla.Archived IS NULL) AS accredboard ...
--,CAST(NULL AS nvarchar(1)) AS [ACCREDITATION] --QUPD ;WITH() ??? ANOTHER REVERSAL per S. COLEMAN email ON 20170522 ADD per MS. K Callies ON 20170323
--,CAST(NULL AS nvarchar(100)) AS [ACCREDITATION_BY] --QUPD ;WITH() ???ADD per MS. K Callies ON 20170323
,CASE
WHEN accredboard.AccreditationTypeName IS NOT NULL
THEN 'YES'
ELSE 'NO'
END AS [ACCREDITATION] --ANOTHER REVERSAL per S. COLEMAN email ON 20170522 ADD per MS. K Callies ON 20170323
,CASE
WHEN accredboard.AccreditationTypeName IS NULL
THEN 'NA'
ELSE UPPER(LTRIM(RTRIM(accredboard.AccreditationTypeName)))
END AS [ACCREDITATION_BY] --THANKS TO YOUNG LADY LAURA ON 20180130 see LEFT JOIN (SELECT DISTINCT LocationID,PracticeID,AccreditationTypeCode,AccreditationTypeName FROM eVips_chgcv.dbo.vwLocationAccreditations AS vla WHERE vla.Archived IN ('N') OR vla.Archived IS NULL) AS accredboard .
--SELECT * --CHECK 1st
--SELECT DISTINCT UPPER(LTRIM(RTRIM(vlp.InDirectory))) AS [INDIRECTORY],UPPER(LTRIM(RTRIM(vpl.LocationName))) AS [FAC Name],UPPER(LTRIM(RTRIM(vpl.LineNumber1))) AS [address1] --CHECK 1st
FROM eVips_chgcv.dbo.vwPractices AS vp
	JOIN eVips_chgcv.dbo.vwPracticeLocations AS vpl ON vpl.PracticeID = vp.PracticeID
		LEFT JOIN eVips_chgcv.dbo.vwFacilities AS vf ON UPPER(LTRIM(RTRIM(vf.FacilityName))) = UPPER(LTRIM(RTRIM(vpl.LocationName)))
			OR UPPER(LTRIM(RTRIM(vf.FacilityName))) = UPPER(LTRIM(RTRIM(vp.PracticeName)))
		LEFT JOIN (SELECT DISTINCT PracticeID,ClassOrCategory, ServiceTypeName,ServiceCategoryTypeName FROM eVips_chgcv.dbo.vwLocationServices WHERE ServiceTypeName LIKE '%GROUP%SPEC%') AS vls ON vls.PracticeID = vp.PracticeID --DEFINE FAC CHAPTER(s) 		
		LEFT JOIN (SELECT DISTINCT LocationID,PracticeID,ClassOrCategory, ServiceTypeName,ServiceCategoryTypeName,code1,code2 FROM eVips_chgcv.dbo.vwLocationServices WHERE UPPER(LTRIM(RTRIM(ServiceTypeName))) LIKE '%PHARM%TYPE%' AND ServiceCategoryTypeName IS NOT NULL AND UPPER(LTRIM(RTRIM(ServiceCategoryTypeName))) != '') AS vlspharmtype ON vlspharmtype.PracticeID = vp.PracticeID --DEFINE PHARM TYPE(s)
			AND vlspharmtype.LocationID = vpl.LocationID --per YOUNG LADY LAURA email ON 20171221 ... Products (CMC & MEDICAL)  are stored at Location Level. The code below is joining based only on Practice ID. This should be based on PracticeID + Location
		LEFT JOIN (SELECT DISTINCT LocationID,PracticeID,ClassOrCategory, ServiceTypeName,ServiceCategoryTypeName,code1,code2 FROM eVips_chgcv.dbo.vwLocationServices WHERE UPPER(LTRIM(RTRIM(ServiceTypeName))) LIKE '%PHARM%SERV%' AND ServiceCategoryTypeName IS NOT NULL AND UPPER(LTRIM(RTRIM(ServiceCategoryTypeName))) != '') AS vlspharmservice ON vlspharmservice.PracticeID = vp.PracticeID --DEFINE PHARM TYPE(s)
			AND vlspharmservice.LocationID = vpl.LocationID --per YOUNG LADY LAURA email ON 20171221 ... Products (CMC & MEDICAL)  are stored at Location Level. The code below is joining based only on Practice ID. This should be based on PracticeID + Location
		LEFT JOIN (SELECT DISTINCT PracticeID,Code1,Code2,ServiceTypeName,ServiceCategoryTypeName FROM eVips_chgcv.dbo.vwLocationServices WHERE ServiceTypeName LIKE '274%TYPE%SERV%') AS vlsfocus ON vlsfocus.PracticeID = vp.PracticeID --Alt EFFORT TO DEFINE FAC CHAPTER(s)
		LEFT JOIN (SELECT DISTINCT ProviderID,TableName,EntityCode,EntityName,EntityTypeCode,EntityTypeName FROM eVips_chgcv.dbo.vwEntityAssignments WHERE TableName LIKE '%PRACTI%') AS vea ON vea.ProviderID = vp.PracticeID
		LEFT JOIN (SELECT DISTINCT ljvlp.PracticeID,ljvlp.LocationID,ljvlp.Archived,ljvlp.StatusTypeName,vlpstype.indirectory,vlpstype.ServiceTypeName,ljvlp.productname,ljvlp.ProductPanelStatusTypeName,ljvlp.ProductPanelStatusTypeCode,ljvlp.ProviderNumber,ljvlp.Focus,ljvlp.ProductID,ljvlp.LocationTypeName FROM eVips_chgcv.dbo.vwLocationProducts AS ljvlp JOIN evips_chgcv.dbo.vwLocationProductServices AS vlpstype ON vlpstype.LocationProductRecID = ljvlp.LocationProductRecID WHERE (ljvlp.Archived IN ('N') OR ljvlp.Archived IS NULL) AND (ljvlp.StatusTypeName IN ('ACTIVE') OR ljvlp.StatusTypeName LIKE '%PARTICIP%' OR ljvlp.StatusTypeName IS NULL) AND (vlpstype.Archived IN ('N') OR vlpstype.Archived IS NULL)) AS vlp ON vlp.PracticeID = vpl.PracticeID --'YOUNG LADY LAURA GAH ID WHERE p.archived = 'N' AND s.ServiceTypeName = 'HOSPITAL' AND p.focus like '%GAH%'' ON 20171120 see ,UPPER(LTRIM(RTRIM(vlp.ServiceTypeName))) AS [vlpSERVICETYPENAME]
			AND vlp.LocationID = vpl.LocationID --per YOUNG LADY LAURA email ON 20171221 ... Products (CMC & MEDICAL)  are stored at Location Level. The code below is joining based only on Practice ID. This should be based on PracticeID + Location
		LEFT JOIN (SELECT DISTINCT LocationID,PracticeID,AccreditationTypeCode,AccreditationTypeName FROM eVips_chgcv.dbo.vwLocationAccreditations AS vla WHERE vla.Archived IN ('N') OR vla.Archived IS NULL) AS accredboard ON accredboard.LocationID =vpl.LocationID
			AND accredboard.PracticeID = vpl.PracticeID

		LEFT JOIN INFORMATICS.dbo.ZIP_CODES AS zip ON SUBSTRING(LTRIM(RTRIM(zip.ZipCode)),1,5) COLLATE DATABASE_DEFAULT = CASE
WHEN SUBSTRING(LTRIM(RTRIM(vpl.ZipCode)),1,1) = '0'
THEN '0'+ SUBSTRING(LTRIM(RTRIM(vpl.ZipCode)),2,4)
WHEN SUBSTRING(LTRIM(RTRIM(vpl.ZipCode)),1,1) = '00'
THEN '00'+ SUBSTRING(LTRIM(RTRIM(vpl.ZipCode)),3,3)
ELSE  SUBSTRING(LTRIM(RTRIM(vpl.ZipCode)),1,5) 
END

		LEFT JOIN (SELECT DISTINCT LocationID,PracticeID,LTRIM(RTRIM(PhoneNumber))AS [PhoneNumber] FROM eVips_chgcv.dbo.vwLocationPhones WHERE UPPER(LTRIM(RTRIM(PhoneTypeName))) LIKE '%PRIMAR%') AS PHONEprimary ON PHONEprimary.practiceid = vpl.practiceid  --PHONE ADD - ON JOIN (s)
			AND PHONEprimary.Locationid= vpl.Locationid --PHONE ADD - ON JOIN (s)
		LEFT JOIN (SELECT DISTINCT LocationID,PracticeID,LTRIM(RTRIM(PhoneNumber)) AS [PhoneNumber] FROM eVips_chgcv.dbo.vwLocationPhones WHERE UPPER(LTRIM(RTRIM(PhoneTypeName))) LIKE '%FAX%') AS PHONEfax ON PHONEfax.practiceid = vpl.practiceid  --PHONE ADD - ON JOIN (s)
			AND PHONEfax.Locationid= vpl.Locationid --FAX ADD - ON JOIN (s)

	WHERE vp.Archived IN ('N') --WITH eVIPS LOGICAL BINARY OPTION(s) IN USE •	Must not be archived 
	AND (vp.PracticeStatus IN ('ACTIVE','CONTRACTED','NA') --•	Contract Status must be Active
		OR vp.PracticeStatus IS NULL)
	AND (vp.ApplicationStatus IN ('ACTIVE','CONTRACTED','NA') --•	Application Status must be contractedarchived
		OR vp.ApplicationStatus IS NULL)		
	AND vpl.Archived IN ('N') --WITH eVIPS LOGICAL BINARY OPTION(s) IN USE •	Must not be archived

	AND UPPER(LTRIM(RTRIM(vpl.LocationName))) LIKE '%SCRIPPS%MERC%CHULA%' --LTRIM(RTRIM(vpl.NationalProviderID)) IN ('9999999999') --SCHCV
	
	AND CASE
WHEN vpl.NationalProviderID IS NULL
	AND UPPER(LTRIM(RTRIM(vf.FacilityStatus))) LIKE 'ACTIVE%'
	AND UPPER(LTRIM(RTRIM(vf.ApplicationStatus))) LIKE 'ACTIVE%'
THEN LTRIM(RTRIM(vf.NationalProviderID))
ELSE LTRIM(RTRIM(vpl.NationalProviderID)) 
END IN ('1659359446')

SELECT * FROM INFORMATICS.dbo.PROVDIR_HOSGENERALACUTE WHERE [Participating Network] IN ('CL1') ORDER BY INDEXNM
SELECT * FROM eVips_chgcv.dbo.vwFacilities AS vf WHERE LTRIM(RTRIM(vf.NationalProviderID)) IN ('1659359446')
SELECT * FROM ##INNETWORK_FAC WHERE lookup_key IN ('4300026')







'YOUNG LADY LAURA SANATOR FILE' - see 'IF OBJECT_ID (N'INFORMATICS.dbo.PROVDIR_CONTRACTING_ENT', N'U') IS NOT NULL --STATIC [TABLE_NAME] CLEANSE()'

From: Laura Infante 
Sent: Thursday, January 25, 2018 11:27 AM
To: Walter Carr <WCarr@chgsd.com>
Subject: RE: Provider Directory (Online & PDF) - Medi Cal (WEEKLY)

In the Sanator File the Assigned column should include the Assigned analyst full name, instead of the username. And phone number, however I know we are still working on that. This is how Sanator will know who to reach out to in case of questions.

select   u.username, n.UserNameFull, r.rolename, m.email, a.PropertyNames , a.PropertyValuesString as [PHONE somewhere in here]
FROM [dbo].[vw_aspnet_UsersInRoles] ur
LEFT JOIN [vw_aspnet_Roles] r on r.roleid = ur.roleid
LEFT JOIN [vw_aspnet_Users] u on u.userid = ur.userid
LEFT JOIN [vw_aspnet_UserNames] n on n.UserName = u.UserName
LEFT JOIN [vw_aspnet_MembershipUsers] m on m.userid = ur.userid
LEFT JOIN aspnet_Profile AS a on a.userid = ur.userid
where m.isapproved = '1' -- Active users

	JOIN (select DISTINCT m.userid,u.username,n.UserNameFull,r.rolename,m.email,a.PropertyNames, a.PropertyValuesString as [PHONE somewhere in here] FROM eVips_chgcv.dbo.[vw_aspnet_UsersInRoles] AS ur LEFT JOIN eVips_chgcv.dbo.[vw_aspnet_Roles] AS r on r.roleid = ur.roleid LEFT JOIN eVips_chgcv.dbo.[vw_aspnet_Users] AS u on u.userid = ur.userid LEFT JOIN eVips_chgcv.dbo.[vw_aspnet_UserNames] AS n on n.UserName = u.UserName LEFT JOIN eVips_chgcv.dbo.[vw_aspnet_MembershipUsers] AS m on m.userid = ur.userid LEFT JOIN eVips_chgcv.dbo.aspnet_Profile AS a on a.userid = ur.userid) AS upv ON UPPER(LTRIM(RTRIM(upv.username))) = UPPER(LTRIM(RTRIM(pce.[Assigned]))) --per YOUNG LADY LAURA email ON 20180124 see 'SUBJECT: evips email'

WHERE LTRIM(RTRIM(vpd.NationalProviderID)) IN ('1487765343') --KRUMHOLZ

SELECT * FROM INFORMATICS.dbo.PROVDIR_SPE WHERE NPIis IN ('1487765343') --KRUMHOLZ

8589875827

,[Telephone Number] = SUBSTRING(LTRIM(RTRIM(PHONEprimary.PhoneNumber)),1,3)+'-'+SUBSTRING(LTRIM(RTRIM(PHONEprimary.PhoneNumber)),4,3)+'-'+SUBSTRING(LTRIM(RTRIM(PHONEprimary.PhoneNumber)),7,4)
,[FAXnumber] = SUBSTRING(LTRIM(RTRIM(PHONEfax.PhoneNumber)),1,3)+'-'+SUBSTRING(LTRIM(RTRIM(PHONEfax.PhoneNumber)),4,3)+'-'+SUBSTRING(LTRIM(RTRIM(PHONEfax.PhoneNumber)),7,4)

		LEFT JOIN (SELECT DISTINCT LocationID,PracticeID,LTRIM(RTRIM(PhoneNumber)) AS [PhoneNumber] FROM eVips_chgcv.dbo.vwLocationPhones WHERE UPPER(LTRIM(RTRIM(PhoneTypeName))) LIKE '%PRIMAR%') AS PHONEprimary ON PHONEprimary.practiceid = vpp.practiceid  --PHONE ADD - ON JOIN (s)
			AND PHONEprimary.Locationid= vpp.Locationid --PHONE ADD - ON JOIN (s)
		LEFT JOIN (SELECT DISTINCT LocationID,PracticeID,LTRIM(RTRIM(PhoneNumber)) AS [987] FROM eVips_chgcv.dbo.vwLocationPhones WHERE UPPER(LTRIM(RTRIM(PhoneTypeName))) LIKE '%FAX%') AS PHONEfax ON PHONEfax.practiceid = vpp.practiceid  --PHONE ADD - ON JOIN (s)
			AND PHONEfax.Locationid= vpp.Locationid --PHONE ADD - ON JOIN (s)
			
'CHARINDEX() / FIND() / SEARCH() FOR' - SQL09.HMOPROD_QCSIDB.dbo.quser --ASSIGNED USER

SELECT DISTINCT [Assigned],[Assigned email],[Assigned phone] FROM INFORMATICS.dbo.PROVDIR_CONTRACTING_ENT
SELECT * FROM eVips_chgcv.dbo.user_profile_vip WHERE UPPER(LTRIM(RTRIM(user_name))) IN ('MPARTI','EMICKL','ACERVA','HLORA','EADAMS','JBELTRAN')
-- SELECT * FROM eVips_chgcv.dbo.SmtpProfiles WHERE UPPER(LTRIM(RTRIM(user_name))) IN ('MPARTI','EMICKL','ACERVA','HLORA','EADAMS','JBELTRAN') --VISTAR DEFAULT email

					--TABLE_NAME

select m.userid,u.username, n.UserNameFull, r.rolename, m.email,*
FROM eVips_chgcv.dbo.[vw_aspnet_UsersInRoles] AS ur
	LEFT JOIN eVips_chgcv.dbo.[vw_aspnet_Roles] AS r on r.roleid = ur.roleid
	LEFT JOIN eVips_chgcv.dbo.[vw_aspnet_Users] AS u on u.userid = ur.userid
	LEFT JOIN eVips_chgcv.dbo.[vw_aspnet_UserNames] AS n on n.UserName = u.UserName
	LEFT JOIN eVips_chgcv.dbo.[vw_aspnet_MembershipUsers] AS m on m.userid = ur.userid
--where m.isapproved = '1' -- Active users
--	and rolename = 'Credentialing'
--	AND UPPER(LTRIM(RTRIM(u.username ))) IN ('MPARTI','EMICKL','ACERVA','HLORA','EADAMS','JBELTRAN')
WHERE UPPER(LTRIM(RTRIM(u.username ))) IN ('MPARTI','EMICKL','ACERVA','HLORA','EADAMS','JBELTRAN')

	-- JOIN eVips_chgcv.dbo.user_profile_vip AS upv ON UPPER(LTRIM(RTRIM(upv.user_name))) = UPPER(LTRIM(RTRIM(pce.[Assigned])))
	JOIN (select DISTINCT m.userid,u.username, n.UserNameFull, r.rolename, m.email FROM eVips_chgcv.dbo.[vw_aspnet_UsersInRoles] AS ur LEFT JOIN eVips_chgcv.dbo.[vw_aspnet_Roles] AS r on r.roleid = ur.roleid LEFT JOIN eVips_chgcv.dbo.[vw_aspnet_Users] AS u on u.userid = ur.userid LEFT JOIN eVips_chgcv.dbo.[vw_aspnet_UserNames] AS n on n.UserName = u.UserName LEFT JOIN eVips_chgcv.dbo.[vw_aspnet_MembershipUsers] AS m on m.userid = ur.userid) AS upv ON UPPER(LTRIM(RTRIM(upv.username))) = UPPER(LTRIM(RTRIM(pce.[Assigned]))) --per YOUNG LADY LAURA email ON 20180124 see 'SUBJECT: evips email'

select   u.username, n.UserNameFull, r.rolename, m.email, a.PropertyNames
 , a.PropertyValuesString as [PHONE somewhere in here] --SELECT name FROM #employee WHERE name LIKE '%[0-9]'; --CONCLUDE(s) ;WITH A NUMERIC VAL()
FROM eVips_chgcv.dbo.[vw_aspnet_UsersInRoles] AS ur
	LEFT JOIN eVips_chgcv.dbo.[vw_aspnet_Roles] AS r on r.roleid = ur.roleid
	LEFT JOIN eVips_chgcv.dbo.[vw_aspnet_Users] AS u on u.userid = ur.userid
	LEFT JOIN eVips_chgcv.dbo.[vw_aspnet_UserNames] AS n on n.UserName = u.UserName
	LEFT JOIN eVips_chgcv.dbo.[vw_aspnet_MembershipUsers] AS m on m.userid = ur.userid
	LEFT JOIN eVips_chgcv.dbo.aspnet_Profile AS a on a.userid = ur.userid
-- where m.isapproved = '1' -- Active users
-- -- and u.UserName = 'ACERVA'
-- and rolename = 'Credentialing'
WHERE UPPER(LTRIM(RTRIM(u.username ))) IN ('MPARTI','EMICKL','ACERVA','HLORA','EADAMS','JBELTRAN')

	-- JOIN eVips_chgcv.dbo.user_profile_vip AS upv ON UPPER(LTRIM(RTRIM(upv.user_name))) = UPPER(LTRIM(RTRIM(pce.[Assigned])))
	JOIN (select m.userid,u.username,n.UserNameFull,r.rolename,m.email,a.PropertyNames,a.PropertyValuesString as [PHONE somewhere in here],[Telephone Number] = RIGHT(UPPER(LTRIM(RTRIM(CAST(ISNULL(a.PropertyValuesString,'') AS nvarchar(2000))))),10) FROM eVips_chgcv.dbo.[vw_aspnet_UsersInRoles] AS ur LEFT JOIN eVips_chgcv.dbo.[vw_aspnet_Roles] AS r on r.roleid = ur.roleid LEFT JOIN eVips_chgcv.dbo.[vw_aspnet_Users] AS u on u.userid = ur.userid LEFT JOIN eVips_chgcv.dbo.[vw_aspnet_UserNames] AS n on n.UserName = u.UserName LEFT JOIN eVips_chgcv.dbo.[vw_aspnet_MembershipUsers] AS m on m.userid = ur.userid LEFT JOIN eVips_chgcv.dbo.aspnet_Profile AS a on a.userid = ur.userid) AS upv ON UPPER(LTRIM(RTRIM(upv.username))) = UPPER(LTRIM(RTRIM(pce.[Assigned]))) --per YOUNG LADY LAURA email ON 20180124 see 'SUBJECT: evips email' AND ON 20180125 '...In the Sanator File the Assigned column should include the Assigned analyst full name, instead of the username. And phone number, however I know we are still working on that. This is how Sanator will know who to reach out to in case of questions...'
	
select m.userid,u.username,n.UserNameFull,r.rolename,m.email,a.PropertyNames,a.PropertyValuesString as [PHONE somewhere in here],[Telephone Number] = RIGHT(UPPER(LTRIM(RTRIM(CAST(ISNULL(a.PropertyValuesString,'') AS nvarchar(2000))))),10) FROM eVips_chgcv.dbo.[vw_aspnet_UsersInRoles] AS ur LEFT JOIN eVips_chgcv.dbo.[vw_aspnet_Roles] AS r on r.roleid = ur.roleid LEFT JOIN eVips_chgcv.dbo.[vw_aspnet_Users] AS u on u.userid = ur.userid LEFT JOIN eVips_chgcv.dbo.[vw_aspnet_UserNames] AS n on n.UserName = u.UserName LEFT JOIN eVips_chgcv.dbo.[vw_aspnet_MembershipUsers] AS m on m.userid = ur.userid LEFT JOIN eVips_chgcv.dbo.aspnet_Profile AS a on a.userid = ur.userid WHERE UPPER(LTRIM(RTRIM(u.username ))) IN ('MPARTI','EMICKL','ACERVA','HLORA','EADAMS','JBELTRAN') ORDER BY u.username
	
Workgroup:S:0:13:Signature:S:13:0:Extension:S:13:0:Entity:S:13:0:PrintProfile:S:13:0:Title:S:13:30:ServiceAccount:S:43:0:ReplyToEmail:S:43:0:FriendlyName:S:43:16:FaxNumber:S:59:0:PhoneNumber:S:59:10:Region:S:69:0:Manager:S:69:0:
Workgroup:S:0:13:Signature:S:13:0:Extension:S:13:0:Entity:S:13:0:PrintProfile:S:13:0:Title:S:13:24:ServiceAccount:S:37:0:ReplyToEmail:S:37:0:FriendlyName:S:37:16:FaxNumber:S:53:10:PhoneNumber:S:63:10:Region:S:73:0:Manager:S:73:0:
Workgroup:S:0:13:Signature:S:13:0:Extension:S:13:0:Entity:S:13:0:PrintProfile:S:13:0:Title:S:13:24:ServiceAccount:S:37:0:ReplyToEmail:S:37:0:FriendlyName:S:37:12:FaxNumber:S:49:10:PhoneNumber:S:59:10:Region:S:69:0:Manager:S:69:0:
Workgroup:S:0:13:Signature:S:13:0:Extension:S:13:0:Entity:S:13:0:PrintProfile:S:13:0:Title:S:13:24:ServiceAccount:S:37:0:ReplyToEmail:S:37:0:FriendlyName:S:37:16:FaxNumber:S:53:10:PhoneNumber:S:63:10:Region:S:73:0:Manager:S:73:0:
Workgroup:S:0:13:Signature:S:13:0:Extension:S:13:0:Entity:S:13:0:PrintProfile:S:13:0:Title:S:13:0:ServiceAccount:S:13:0:ReplyToEmail:S:13:0:FriendlyName:S:13:12:FaxNumber:S:25:0:PhoneNumber:S:25:0:Region:S:25:0:Manager:S:25:1:
Workgroup:S:0:13:Signature:S:13:0:Extension:S:13:0:Entity:S:13:0:PrintProfile:S:13:0:Title:S:13:24:ServiceAccount:S:37:0:ReplyToEmail:S:37:0:FriendlyName:S:37:17:FaxNumber:S:54:10:PhoneNumber:S:64:10:Region:S:74:0:Manager:S:74:0:

CredentialingCredentialing Data SpecilalistJonathan Beltran6194986590
CredentialingCredentialing SpecialistArlene Cervantes61938212156194986567
CredentialingProvider Data SpecialistEvelyn Adams61938212136194986504
CredentialingProvider Data SpecialistElizabeth Rojano61938212126194986521
CredentialingHoracio LoraY
CredentialingCredentialing SpecialistMonserrat Partida61938212086192408957

Hi,  Each group practice has an assigned to for that FEID.  You would them match the user name in the user table.

					Columns to add:
					
					FEID – Practice.TaxIDNumber
					Assigned – Practice.AssignedTo match to UserAccount.UserName
					Assigned email – UserAccount.Email
					Assigned phone – UserAccount.UserPhoneNumber

I think you already have these:
DBA – Practice.PracticeName
Location Code – Location.LocationCode

Thanks!

From: Walter Carr 
Sent: Wednesday, January 17, 2018 3:14 PM
To: Laura Infante <LauraInfante@chgsd.com>; Laura Infante <LauraInfante@chgsd.com>; Sandra Coleman <SColem@chgsd.com>; Horacio Lora <HLora@chgsd.com>
Cc: Jeremy Lutz <jlutz@chgsd.com>
Subject: Sanator Agenda / Homework

Young Ladies & Gentlemen, such that I may complete my homework assignment may I request the table(s) / field(s) in VIP & or eVIPS to add the columns discussed during the conference call ([REP UserID],[REP email],[REP contact phone],[GENERAL contact email],[GENERAL contact phone]) to the output table? Thank you.

\\CHG_CIFS01\Shared\PROVIDER_DIRECTORY\SANATOR_DATA.xlsx - Sanator Refresh

Much Appreciated, Thank You
Walter W Carr II
Informatics Research Business Analyst
wcarr@chgsd.com
619 498 6510

This e-mail message is intended only for use by the individual, or recipient(s) entity to which it is addressed. This message is confidential and may contain information that is privileged, confidential and is exempt from disclosure under applicable law. If you are not the intended recipient(s), you may not review, copy, or distribute this message. If you have received this communication in error, please notify us immediately by e-mail, or telephone and delete the original message.

-- ============================================================
	--FILTER() / SEARCH() FOR: SQL Sample(s) FIND / CHARINDEX table(s) or field(s) Specification(s)--

					'SCHEMA()' = SELECT * FROM 'SERVERname'.'DATABASEname'.'SCHEMAname'.'OBJECTname' - FOUR (4) PART() SCHEMA()  aka [SERVERname].[DATABASEname].[SCHEMAname].[OBJECTname] - see 'SQL13.CHGAPP_PROD.dbo.tblEDIDHCSType834'
-- ============================================================
USE eVips_chgcv

DECLARE @tblis AS nvarchar(88)
DECLARE @tbltype AS nvarchar(88)
DECLARE @tblwas AS nvarchar(88)
DECLARE @tblwillbe AS nvarchar(88)
DECLARE @fieldis AS nvarchar(88)
DECLARE @fieldwas AS nvarchar(88)
DECLARE @fieldwillbe AS nvarchar(88)

SET @tblis  = '%%'--UPDATE AS NEEDED HERE WITHIN THE ‘’
SET @tbltype  = '%base%'--UPDATE AS NEEDED HERE WITHIN THE ‘’
SET @tblwas  = '%%'--UPDATE AS NEEDED HERE WITHIN THE ‘’
SET @tblwillbe  = '%%'--UPDATE AS NEEDED HERE WITHIN THE ‘’
SET @fieldis  = '%email%'--UPDATE AS NEEDED HERE WITHIN THE ‘’ ISO w createid OR dreatedate
SET @fieldwas  = '%%'--UPDATE AS NEEDED HERE WITHIN THE ‘’
SET @fieldwillbe  = '%%'--UPDATE AS NEEDED HERE WITHIN THE ‘’

SELECT *
-- SELECT * FROM INFORMATION_SCHEMA.TABLES --CHECK 1st
-- SELECT DISTINCT --CHECK 1st
FROM INFORMATION_SCHEMA.COLUMNS AS isc
	JOIN INFORMATION_SCHEMA.TABLES AS ist ON ist.TABLE_NAME = isc.TABLE_NAME
WHERE isc.TABLE_NAME LIKE @tblis
	AND isc.COLUMN_NAME LIKE @fieldis
	AND ist.TABLE_TYPE LIKE @tbltype
	AND isc.TABLE_NAME IN (SELECT iscwas.TABLE_NAME
FROM INFORMATION_SCHEMA.COLUMNS AS iscwas
WHERE iscwas.TABLE_NAME LIKE @tblwas
	AND iscwas.COLUMN_NAME LIKE @fieldwas)
	AND isc.TABLE_NAME IN (SELECT iscwillbe.TABLE_NAME
FROM INFORMATION_SCHEMA.COLUMNS AS iscwillbe
WHERE iscwillbe.TABLE_NAME LIKE @tblwillbe
	AND iscwillbe.COLUMN_NAME LIKE @fieldwillbe)
ORDER BY isc.TABLE_NAME,isc.COLUMN_NAME

					-- SELECT * FROM 
					-- SELECT TOP 100 * FROM 
					-- SELECT DISTINCT CertificationBoardID,BoardName FROM 
					-- SELECT * FROM [DATABASEname].dbo.
					-- SELECT DISTINCT FROM [DATABASEname].dbo.		

--user_profile_vip
--aspnet_Users
--EntityAssignments
--Practices WHERE PracticeName = 'Aces' --PracticeID = '4107192'
vwPractices WHERE PracticeName = 'Aces' --PracticeID = '4107192'
--ABMSBoards --BLANK()
--CertificationBoards --???
--vwABMSBoards --BLANK()
--vwCertificationBoards
vwPractitionerSpecialties
--vwSpecialties







'CHECK PROVDIR FAC()' - Hi,  In balancing one to one, we noticed a facility that should not be in the VIPs directory.  

					EPC Surgery Center 
					
has plans record statuses of applicant.  It is not credential yet.  Please remove applicant from all facilities.  Thanks!

Sandra Coleman, MBA, Credentialing Manager
Community Health Group
2420 Fenton Street, Suite 100, Chula Vista CA 91914
619 498 6438 phone
619 382 1211 fax
scolem@chgsd.com

WHERE vp.Archived IN ('N') --WITH eVIPS LOGICAL BINARY OPTION(s) IN USE •	Must not be archived 
	 AND (vp.PracticeStatus IN ('ACTIVE','CONTRACTED','NA') --•	Contract Status must be Active
		 OR vp.PracticeStatus IS NULL)
	 AND (vp.ApplicationStatus IN ('ACTIVE','CONTRACTED','NA') --•	Application Status must be contractedarchived
		 OR vp.ApplicationStatus IS NULL)		
	 AND vpl.Archived IN ('N') --WITH eVIPS LOGICAL BINARY OPTION(s) IN USE •	Must not be archived
	 
SELECT Status
,UPPER(LTRIM(RTRIM(vp.PracticeID))) AS [lookup_key],* 
FROM eVips_chgcv.dbo.vwLocationProducts

		LEFT JOIN (SELECT DISTINCT ljvlp.PracticeID,ljvlp.LocationID,ljvlp.Archived,ljvlp.StatusTypeName,vlpstype.indirectory,vlpstype.ServiceTypeName,ljvlp.productname,ljvlp.ProductPanelStatusTypeName,ljvlp.ProductPanelStatusTypeCode,ljvlp.ProviderNumber,ljvlp.Focus,ljvlp.ProductID,ljvlp.LocationTypeName FROM eVips_chgcv.dbo.vwLocationProducts AS ljvlp LEFT JOIN evips_chgcv.dbo.vwLocationProductServices AS vlpstype ON vlpstype.LocationProductRecID = ljvlp.LocationProductRecID WHERE (ljvlp.Archived IN ('N') OR ljvlp.Archived IS NULL) AND (ljvlp.StatusTypeName IN ('ACTIVE') OR ljvlp.StatusTypeName LIKE '%PARTICIP%' OR ljvlp.StatusTypeName IS NULL) AND (vlpstype.Archived IN ('N') OR vlpstype.Archived IS NULL)) AS vlp ON vlp.PracticeID = vpl.PracticeID --'YOUNG LADY LAURA GAH ID WHERE p.archived = 'N' AND s.ServiceTypeName = 'HOSPITAL' AND p.focus like '%GAH%'' ON 20171120 see ,UPPER(LTRIM(RTRIM(vlp.ServiceTypeName))) AS [vlpSERVICETYPENAME]
		
SELECT StatusTypeName,LocationName,PracticeName,UPPER(LTRIM(RTRIM(PracticeID))) AS [lookup_key],* 
FROM eVips_chgcv.dbo.vwLocationProducts
WHERE UPPER(LTRIM(RTRIM(PracticeID))) IN ('4112509')

SELECT UPPER(LTRIM(RTRIM(PracticeID))) AS [lookup_key],* 
FROM eVips_chgcv.dbo.vwLocationProductServices
WHERE UPPER(LTRIM(RTRIM(PracticeID))) IN ('4112509')

SELECT [lookup_key],* 
FROM ##INNETWORK_FAC
WHERE UPPER(LTRIM(RTRIM(HospitalName))) LIKE '%EPC%SURG%' 
	OR UPPER(LTRIM(RTRIM(DBA))) LIKE '%EPC%SURG%'
	
SELECT * --CHECK 1st
FROM INFORMATICS.dbo.TimelyAccessFAC AS spe
WHERE UPPER(LTRIM(RTRIM(HospitalName))) LIKE '%EPC%SURG%' 
	OR UPPER(LTRIM(RTRIM(DBA))) LIKE '%EPC%SURG%'
	OR MCREDstatus LIKE 'APPL%'

					--DELETE
					 SELECT * --CHECK 1st
					-- SELECT DISTINCT --CHECK 1st
					FROM INFORMATICS.dbo.TimelyAccessFAC
					WHERE MCREDstatus LIKE 'APPL%' --per MS. SANDRA email ON 20180122 '...Hi,  In balancing one to one, we noticed a facility that should not be in the VIPs directory.  EPC Surgery Center  has plans record statuses of applicant.  It is not credential yet.  Please remove applicant from all facilities.  Thanks!...'
					
WHERE LTRIM(RTRIM(vpd.NationalProviderID)) IN ('1487765343') --KRUMHOLZ

SELECT * FROM INFORMATICS.dbo.PROVDIR_SPE WHERE NPIis IN ('1487765343') --KRUMHOLZ







'AGE RESTRICTION'(s) - Good morning Walter,
Before you run the directory today, could you please double check the age restriction? We found that the age restrictions are matching on eVIPs and Vistar but not showing correct info on directory. 
Example:
Vistar shows: Age restriction: 0-18
eVIPs shows: Age restriction: 0-18
Directory shows: None 

Practitioner examples: 
Wenger, Dennis - NPI# 1932270790
Scher, Colin - NPI# 1396816153

Best Regards,

Horacio Lora 

Horacio Lora, Credentialing Services Supervisor 
Community Health Group
2420 Fenton Street, Suite 100, Chula Vista CA 91914
619 498 6487 phone
619 382 1225 fax
hlora@chgsd.com

SELECT * FROM eVips_chgcv.dbo.vwPractitionerProducts
SELECT * FROM eVips_chgcv.dbo.vwLocationProducts

-- ===================================================================
	--HDR [AGE RESTRICTION] OPTION(s)--
-- ===================================================================
------------------------------------------------------------------------------------------------------------------------
	-- Error Trapping: Check If Permanent Table(s) Already Exist(s) And Drop If Applicable --
------------------------------------------------------------------------------------------------------------------------
IF OBJECT_ID('TempDB..#AGERESTRICTION_FAC') IS NOT NULL
BEGIN

		DROP TABLE #AGERESTRICTION_FAC

 END
 
SELECT DISTINCT lp.LocationName,vlpl.LocationID,vlpl.PracticeID,vlpl.ProductID --,vlpl.AddressID
 ,[AGE RESTRICTION] = CASE --QUPD / CASE WHEN THEN ELSE END... USE pcp.MinimumAge AND pcp.age-restriction2
WHEN LTRIM(RTRIM(ISNULL(vlpl.MinimumAge,'0'))) = '21'
	AND LTRIM(RTRIM(ISNULL(vlpl.MaximumAge,'0'))) = '999'
THEN '21 AND OVER'
WHEN LTRIM(RTRIM(ISNULL(vlpl.MinimumAge,'0'))) = '18'
	AND LTRIM(RTRIM(ISNULL(vlpl.MaximumAge,'0'))) = '999'
THEN '18 AND OVER'
WHEN LTRIM(RTRIM(ISNULL(vlpl.MinimumAge,'0'))) = '0'
	AND LTRIM(RTRIM(ISNULL(vlpl.MaximumAge,'0'))) = '18'
THEN 'UP TO 18' --Per S. Coleman ON 20160809 Please review the following for this provider. Cohenmeyer  132285     SPE  92123  Age Restrictions should show 0 – 18
WHEN LTRIM(RTRIM(ISNULL(vlpl.MinimumAge,'0'))) = '0'
	AND LTRIM(RTRIM(ISNULL(vlpl.MaximumAge,'0'))) != '999'
THEN 'UP TO '+LTRIM(RTRIM(ISNULL(vlpl.MaximumAge,'0')))
WHEN LTRIM(RTRIM(ISNULL(vlpl.MinimumAge,'0'))) != '0' -- NO NOT NEGATIVE <> != ...
	AND LTRIM(RTRIM(ISNULL(vlpl.MaximumAge,'0'))) = '999'
THEN LTRIM(RTRIM(ISNULL(vlpl.MinimumAge,'0')))+' AND OVER'
WHEN LTRIM(RTRIM(ISNULL(vlpl.MinimumAge,'0'))) != '0' -- NO NOT NEGATIVE <> != ...
	AND LTRIM(RTRIM(ISNULL(vlpl.MaximumAge,'0'))) != '999'
THEN LTRIM(RTRIM(ISNULL(vlpl.MinimumAge,'0')))+' TO '+LTRIM(RTRIM(ISNULL(vlpl.MaximumAge,'0')))
ELSE 'NONE'
END --CHANGE OF OPTION(s) per S. Coleman ON 20170103
--INTO #AGERESTRICTION_FAC
--SELECT * --CHECK 1st
--SELECT DISTINCT ISNULL(MinimumAge,'0') AS [MINAGE],ISNULL(MaximumAge,'0') AS [MAXAGE] --CHECK 1st
FROM eVips_chgcv.dbo.vwLocationProductLimitations AS vlpl --OR vwPractitionerProductLimitations
	JOIN  eVips_chgcv.dbo.vwLocationProducts AS lp on lp.LocationProductRecID = vlpl.LocationProductRecID
WHERE UPPER(LTRIM(RTRIM(vlpl.LimitationtypeName))) LIKE '%AGE%' --WHERE LimitationtypeName LIKE '%Age%' 
	AND lp.archived = 'N'
	AND vlpl.archived = 'N'

					--SELECT * FROM #AGERESTRICTION_FAC






------------------------------------------------------------------------------------------------------------------------
	-- Error Trapping: Check If Permanent Table(s) Already Exist(s) And Drop If Applicable --
------------------------------------------------------------------------------------------------------------------------
IF OBJECT_ID('TempDB..#AGERESTRICTION_PROV') IS NOT NULL
BEGIN

		DROP TABLE #AGERESTRICTION_PROV

 END
 
SELECT DISTINCT pp.LastName,pp.FirstName,vppl.PractitionerID,vppl.ProductID,vppl.MinimumAge,vppl.MaximumAge --,vppl.LocationID,vppl.AddressID
 ,[AGE RESTRICTION] = CASE --QUPD / CASE WHEN THEN ELSE END... USE pcp.MinimumAge AND pcp.age-restriction2
WHEN LTRIM(RTRIM(ISNULL(vppl.MinimumAge,'0'))) = '21'
	AND LTRIM(RTRIM(ISNULL(vppl.MaximumAge,'0'))) = '999'
THEN '21 AND OVER'
WHEN LTRIM(RTRIM(ISNULL(vppl.MinimumAge,'0'))) = '18'
	AND LTRIM(RTRIM(ISNULL(vppl.MaximumAge,'0'))) = '999'
THEN '18 AND OVER'
WHEN LTRIM(RTRIM(ISNULL(vppl.MinimumAge,'0'))) = '0'
	AND LTRIM(RTRIM(ISNULL(vppl.MaximumAge,'0'))) = '18'
THEN 'UP TO 18' --Per S. Coleman ON 20160809 Please review the following for this provider. Cohenmeyer  132285     SPE  92123  Age Restrictions should show 0 – 18
WHEN LTRIM(RTRIM(ISNULL(vppl.MinimumAge,'0'))) = '0'
	AND LTRIM(RTRIM(ISNULL(vppl.MaximumAge,'0'))) != '999'
THEN 'UP TO '+LTRIM(RTRIM(ISNULL(vppl.MaximumAge,'0')))
WHEN LTRIM(RTRIM(ISNULL(vppl.MinimumAge,'0'))) != '0' -- NO NOT NEGATIVE <> != ...
	AND LTRIM(RTRIM(ISNULL(vppl.MaximumAge,'0'))) = '999'
THEN LTRIM(RTRIM(ISNULL(vppl.MinimumAge,'0')))+' AND OVER'
WHEN LTRIM(RTRIM(ISNULL(vppl.MinimumAge,'0'))) != '0' -- NO NOT NEGATIVE <> != ...
	AND LTRIM(RTRIM(ISNULL(vppl.MaximumAge,'0'))) != '999'
THEN LTRIM(RTRIM(ISNULL(vppl.MinimumAge,'0')))+' TO '+LTRIM(RTRIM(ISNULL(vppl.MaximumAge,'0')))
ELSE 'NONE'
END --CHANGE OF OPTION(s) per S. Coleman ON 20170103
--INTO #AGERESTRICTION_PROV
-- SELECT * --CHECK 1st
-- SELECT DISTINCT ISNULL(MinimumAge,'0') AS [MINAGE],ISNULL(MaximumAge,'0') AS [MAXAGE] --CHECK 1st
FROM eVips_chgcv.dbo.vwPractitionerProductLimitations AS vppl --OR vwLocationProductLimitations
	JOIN  eVips_chgcv.dbo.vwPractitionerProducts AS pp on pp.PractitionerProductRecID = vppl.PractitionerProductRecID
WHERE UPPER(LTRIM(RTRIM(vppl.LimitationtypeName))) LIKE '%AGE%' --WHERE LimitationtypeName LIKE '%Age%' 
	-- AND vppl.PractitionerID IN ('4394031','4396103') --TEST PROVIDER(s)
	AND pp.archived = 'N'
	AND vppl.archived = 'N'
	
SELECT * --CHECK 1st
--SELECT DISTINCT ISNULL(MinimumAge,'0') AS [MINAGE],ISNULL(MaximumAge,'0') AS [MAXAGE] --CHECK 1st
FROM eVips_chgcv.dbo.vwLocationProductLimitations AS vlpl --OR vwPractitionerProductLimitations
	LEFT JOIN  eVips_chgcv.dbo.vwLocationProducts AS lp on lp.LocationProductRecID = vlpl.LocationProductRecID
WHERE UPPER(LTRIM(RTRIM(vlpl.LimitationtypeName))) LIKE '%AGE%' --WHERE LimitationtypeName LIKE '%Age%' 
	AND lp.archived = 'N'
	AND vlpl.archived = 'N'

 SELECT * --CHECK 1st
-- SELECT DISTINCT ISNULL(MinimumAge,'0') AS [MINAGE],ISNULL(MaximumAge,'0') AS [MAXAGE] --CHECK 1st
FROM eVips_chgcv.dbo.vwPractitionerProductLimitations AS vppl --OR vwLocationProductLimitations
	LEFT JOIN  eVips_chgcv.dbo.vwPractitionerProducts AS pp on pp.PractitionerProductRecID = vppl.PractitionerProductRecID
WHERE UPPER(LTRIM(RTRIM(vppl.LimitationtypeName))) LIKE '%AGE%' --WHERE LimitationtypeName LIKE '%Age%' 
	-- AND vppl.PractitionerID IN ('4394031','4396103') --TEST PROVIDER(s)
	AND pp.archived = 'N'
	AND vppl.archived = 'N'
	
PractitionerProductLimitationRecID	PractitionerProductRecID
4710759													4710757
4710762													4710760	







-- ==========================================================
	--GENERATE PROVIDER GROUP [TEMPLATE] --
-- ==========================================================
-------------------------------------------------------------------------------------------------------------------------
	-- Error Trapping: Check If Permanent Table(s) Already Exist(s) And Drop If Applicable --
-------------------------------------------------------------------------------------------------------------------------
IF OBJECT_ID('TempDB..##DERIVED') IS NOT NULL
BEGIN

		DROP TABLE ##DERIVED --#TableName is a local temporary table visible only in the current session; ##TableName is a global temporary table visible to all sessions IN 'tempdb'

END

SELECT * 
INTO ##DERIVED
-- SELECT * --CHECK 1st
-- SELECT DISTINCT --CHECK 1st
FROM --see BELOW
( -- INITIATE ...
SELECT 'CATEGORY - '+UPPER(LTRIM(RTRIM(ZIP))) AS [GEOACCESS_PROVID],*
-- SELECT DISTINCT [ACCREDITATION_BY] --CHECK 1st
FROM INFORMATICS.dbo.PROVDIR_PCP --PROV(s)
UNION -- VERTICAL() STACK ALL()
SELECT 'CATEGORY - '+UPPER(LTRIM(RTRIM(ZIP))) AS [GEOACCESS_PROVID],*
-- SELECT DISTINCT [ACCREDITATION_BY] --CHECK 1st
FROM INFORMATICS.dbo.PROVDIR_NPMP --PROV(s)
UNION -- VERTICAL() STACK ALL()
SELECT 'CATEGORY - '+UPPER(LTRIM(RTRIM(ZIP))) AS [GEOACCESS_PROVID],*
-- SELECT DISTINCT [ACCREDITATION_BY] --CHECK 1st
FROM INFORMATICS.dbo.PROVDIR_SPE --PROV(s)
UNION -- VERTICAL() STACK ALL()
SELECT 'CATEGORY - '+UPPER(LTRIM(RTRIM(ZIP))) AS [GEOACCESS_PROVID],*
-- SELECT DISTINCT [ACCREDITATION_BY] --CHECK 1st
FROM INFORMATICS.dbo.PROVDIR_MH --PROV(s)
UNION -- VERTICAL() STACK ALL()
SELECT 'CATEGORY - '+UPPER(LTRIM(RTRIM(ZIP))) AS [GEOACCESS_PROVID],*
-- SELECT DISTINCT [ACCREDITATION_BY] --CHECK 1st
FROM INFORMATICS.dbo.PROVDIR_AHP --PROV(s)
UNION -- VERTICAL() STACK ALL()
SELECT 'CATEGORY - '+UPPER(LTRIM(RTRIM(ZIP))) AS [GEOACCESS_PROVID],*
-- SELECT DISTINCT [ACCREDITATION_BY] --CHECK 1st
FROM INFORMATICS.dbo.PROVDIR_VSP --PROV(s)
) AS DERIVED -- DERIVED() ALIASNAME CONCLUDE ...
WHERE NPIis IN ('1932270790','1396816153')

					SELECT * FROM ##DERIVED

SELECT [Participating Network] --,plan_type
,COUNT(DISTINCT(NPIis)) AS [RECORD COUNT]
,'The COUNT() is' AS [NOTE]
-- SELECT TOP 100 * --CHECK 1st
-- SELECT DISTINCT --CHECK 1st
FROM ##DERIVED
GROUP BY [Participating Network] --,plan_type

-------------------------------------------------------------------------------------------------------------------------
	-- Error Trapping: Check If Permanent Table(s) Already Exist(s) And Drop If Applicable --
-------------------------------------------------------------------------------------------------------------------------
IF OBJECT_ID('TempDB..##TEMPTABLE') IS NOT NULL
BEGIN

		DROP TABLE ##TEMPTABLE --#TableName is a local temporary table visible only in the current session; ##TableName is a global temporary table visible to all sessions IN 'tempdb'

END

;WITH TEMPTABLE AS --;WITH() LIKE '%CREATION OF [tempdb] TABLE%'  ## FROM JL
( --INITIATE ...
SELECT 'CATEGORY - '+UPPER(LTRIM(RTRIM(ZIP))) AS [GEOACCESS_PROVID],*
-- SELECT DISTINCT [ACCREDITATION_BY] --CHECK 1st
FROM INFORMATICS.dbo.PROVDIR_PCP --PROV(s)
UNION -- VERTICAL() STACK ALL()
SELECT 'CATEGORY - '+UPPER(LTRIM(RTRIM(ZIP))) AS [GEOACCESS_PROVID],*
-- SELECT DISTINCT [ACCREDITATION_BY] --CHECK 1st
FROM INFORMATICS.dbo.PROVDIR_NPMP --PROV(s)
UNION -- VERTICAL() STACK ALL()
SELECT 'CATEGORY - '+UPPER(LTRIM(RTRIM(ZIP))) AS [GEOACCESS_PROVID],*
-- SELECT DISTINCT [ACCREDITATION_BY] --CHECK 1st
FROM INFORMATICS.dbo.PROVDIR_SPE --PROV(s)
UNION -- VERTICAL() STACK ALL()
SELECT 'CATEGORY - '+UPPER(LTRIM(RTRIM(ZIP))) AS [GEOACCESS_PROVID],*
-- SELECT DISTINCT [ACCREDITATION_BY] --CHECK 1st
FROM INFORMATICS.dbo.PROVDIR_MH --PROV(s)
UNION -- VERTICAL() STACK ALL()
SELECT 'CATEGORY - '+UPPER(LTRIM(RTRIM(ZIP))) AS [GEOACCESS_PROVID],*
-- SELECT DISTINCT [ACCREDITATION_BY] --CHECK 1st
FROM INFORMATICS.dbo.PROVDIR_AHP --PROV(s)
UNION -- VERTICAL() STACK ALL()
SELECT 'CATEGORY - '+UPPER(LTRIM(RTRIM(ZIP))) AS [GEOACCESS_PROVID],*
-- SELECT DISTINCT [ACCREDITATION_BY] --CHECK 1st
FROM INFORMATICS.dbo.PROVDIR_VSP --PROV(s)
) --CONCLUDE ...
SELECT DISTINCT * 
INTO ##TEMPTABLE
-- SELECT TOP 100 * --CHECK 1st
-- SELECT DISTINCT --CHECK 1st
FROM TEMPTABLE
WHERE NPIis IN ('1932270790','1396816153')
ORDER BY [INDEXNM]

					SELECT * FROM ##TEMPTABLE

SELECT [Participating Network] --,plan_type
,COUNT(DISTINCT(NPIis)) AS [RECORD COUNT]
,'The COUNT() is' AS [NOTE]
-- SELECT TOP 100 * --CHECK 1st
-- SELECT DISTINCT --CHECK 1st
FROM ##TEMPTABLE
GROUP BY [Participating Network] --,plan_type







'ACCREDITATION' - aka {BOARD CERTIFICATION}
x see 'ZZZ_CONVERSION_'...sql

SELECT CASE
WHEN SUBSTRING(UPPER(LTRIM(RTRIM(ISNULL(vps.BoardCertified,'')))),1,1) != 'N'
	AND UPPER(LTRIM(RTRIM(ISNULL(vps.Archived,'')))) IN ('N')  --Per S. Coleman email ON 20171229 '...Board cert status is incorrect ...'
	AND vps.BoardName IS NOT NULL
THEN 'YES'
ELSE 'NO'
END AS [ACCREDITATION] --ANOTHER REVERSAL per S. COLEMAN email ON 20170522 ADD per MS. K Callies ON 20170323
,CASE
WHEN SUBSTRING(UPPER(LTRIM(RTRIM(ISNULL(vps.BoardCertified,'')))),1,1) != 'N'
	AND UPPER(LTRIM(RTRIM(ISNULL(vps.Archived,'')))) IN ('N')  --Per S. Coleman email ON 20171229 '...Board cert status is incorrect ...'
THEN UPPER(LTRIM(RTRIM(vps.BoardName))) 
ELSE 'NA'
END AS [ACCREDITATION_BY] --[SAMPLE / EXAMPLE] For example see v18422 Dr. Blum: His cert_provider specialties are 'CRV' and 'CET'.  When you link to the master_cred table, it show he is board certified in 'CRV' and not certified in 'CET'.  Since the 'CRV' is YES, you would then link to the board_cert table to see which board.  Please make sure this is a tight join because Dr. Blum is also board certified in INM but this info is not needed.  His board_cert.specialty 'CRV' shows the cert_code AIM which matches to the sys_lookups set name cert_code.  That description is American Board of Internal Medicine. So 'CET' board status would show NO, but his 'CRV' would show YES (American Board of Internal Medicine).  Please call me if you have any questions. Thanks! AND --ADD per MS. K Callies ON 20170323
,CASE
WHEN UPPER(LTRIM(RTRIM(vps.BoardCertified))) != 'N'
THEN 'Y'
ELSE 'N'
END AS [BoardCertified(Y/N)]
,CASE
WHEN SUBSTRING(UPPER(LTRIM(RTRIM(vps.BoardCertified))),1,1) = 'N'
THEN 'NA'
ELSE UPPER(LTRIM(RTRIM(vps.BoardName))) 
END AS [BoardName] --[SAMPLE / EXAMPLE] For example see v18422 Dr. Blum: His cert_provider specialties are 'CRV' and 'CET'.  When you link to the master_cred table, it show he is board certified in 'CRV' and not certified in 'CET'.  Since the 'CRV' is YES, you would then link to the board_cert table to see which board.  Please make sure this is a tight join because Dr. Blum is also board certified in INM but this info is not needed.  His board_cert.specialty 'CRV' shows the cert_code AIM which matches to the sys_lookups set name cert_code.  That description is American Board of Internal Medicine. So 'CET' board status would show NO, but his 'CRV' would show YES (American Board of Internal Medicine).  Please call me if you have any questions. Thanks! AND --ADD per MS. K Callies ON 20170323
,vps.[BoardName]
,SUBSTRING(REPLACE(REPLACE(REPLACE(LTRIM(RTRIM(vps.[BoardName])),' OF ',' '),' AND ',' '),' & ',' '),1,1) --AS [FIRST_INITIAL_SOURCE]
+''+
SUBSTRING(REPLACE(REPLACE(REPLACE(LTRIM(RTRIM(vps.[BoardName])),' OF ',' '),' AND ',' '),' & ',' '),CHARINDEX(' ',REPLACE(REPLACE(REPLACE(LTRIM(RTRIM(vps.[BoardName])),' OF ',' '),' AND ',' '),' & ',' '),1)+1,1) --AS [SECOND_INITIAL_SOURCE]
+''+
SUBSTRING(LTRIM(RTRIM(SUBSTRING(REPLACE(REPLACE(REPLACE(LTRIM(RTRIM(vps.[BoardName])),' OF ',' '),' AND ',' '),' & ',' '),CHARINDEX(' ',REPLACE(REPLACE(REPLACE(LTRIM(RTRIM(vps.[BoardName])),' OF ',' '),' AND ',' '),' & ',' '),1)+1,255))),CHARINDEX(' ',LTRIM(RTRIM(SUBSTRING(REPLACE(REPLACE(REPLACE(LTRIM(RTRIM(vps.[BoardName])),' OF ',' '),' AND ',' '),' & ',' '),CHARINDEX(' ',REPLACE(REPLACE(REPLACE(LTRIM(RTRIM(vps.[BoardName])),' OF ',' '),' AND ',' '),' & ',' '),1)+1,255))),1)+1,1) --AS [THIRD_INITIAL_SOURCE]
+''+
SUBSTRING(LTRIM(RTRIM(SUBSTRING(LTRIM(RTRIM(SUBSTRING(REPLACE(REPLACE(REPLACE(LTRIM(RTRIM(vps.[BoardName])),' OF ',' '),' AND ',' '),' & ',' '),CHARINDEX(' ',REPLACE(REPLACE(REPLACE(LTRIM(RTRIM(vps.[BoardName])),' OF ',' '),' AND ',' '),' & ',' '),1)+1,255))),CHARINDEX(' ',LTRIM(RTRIM(SUBSTRING(REPLACE(REPLACE(REPLACE(LTRIM(RTRIM(vps.[BoardName])),' OF ',' '),' AND ',' '),' & ',' '),CHARINDEX(' ',REPLACE(REPLACE(REPLACE(LTRIM(RTRIM(vps.[BoardName])),' OF ',' '),' AND ',' '),' & ',' '),1)+1,255))),1)+1,255))),CHARINDEX(' ',LTRIM(RTRIM(SUBSTRING(LTRIM(RTRIM(SUBSTRING(REPLACE(REPLACE(REPLACE(LTRIM(RTRIM(vps.[BoardName])),' OF ',' '),' AND ',' '),' & ',' '),CHARINDEX(' ',REPLACE(REPLACE(REPLACE(LTRIM(RTRIM(vps.[BoardName])),' OF ',' '),' AND ',' '),' & ',' '),1)+1,255))),CHARINDEX(' ',LTRIM(RTRIM(SUBSTRING(REPLACE(REPLACE(REPLACE(LTRIM(RTRIM(vps.[BoardName])),' OF ',' '),' AND ',' '),' & ',' '),CHARINDEX(' ',REPLACE(REPLACE(REPLACE(LTRIM(RTRIM(vps.[BoardName])),' OF ',' '),' AND ',' '),' & ',' '),1)+1,255))),1)+1,255))),1)+1,1) --AS [FOURTH_INITIAL_SOURCE]
+''+
SUBSTRING(LTRIM(RTRIM(SUBSTRING(LTRIM(RTRIM(SUBSTRING(LTRIM(RTRIM(SUBSTRING(REPLACE(REPLACE(REPLACE(LTRIM(RTRIM(vps.[BoardName])),' OF ',' '),' AND ',' '),' & ',' '),CHARINDEX(' ',REPLACE(REPLACE(REPLACE(LTRIM(RTRIM(vps.[BoardName])),' OF ',' '),' AND ',' '),' & ',' '),1)+1,255))),CHARINDEX(' ',LTRIM(RTRIM(SUBSTRING(REPLACE(REPLACE(REPLACE(LTRIM(RTRIM(vps.[BoardName])),' OF ',' '),' AND ',' '),' & ',' '),CHARINDEX(' ',REPLACE(REPLACE(REPLACE(LTRIM(RTRIM(vps.[BoardName])),' OF ',' '),' AND ',' '),' & ',' '),1)+1,255))),1)+1,255))),CHARINDEX(' ',LTRIM(RTRIM(SUBSTRING(LTRIM(RTRIM(SUBSTRING(REPLACE(REPLACE(REPLACE(LTRIM(RTRIM(vps.[BoardName])),' OF ',' '),' AND ',' '),' & ',' '),CHARINDEX(' ',REPLACE(REPLACE(REPLACE(LTRIM(RTRIM(vps.[BoardName])),' OF ',' '),' AND ',' '),' & ',' '),1)+1,255))),CHARINDEX(' ',LTRIM(RTRIM(SUBSTRING(REPLACE(REPLACE(REPLACE(LTRIM(RTRIM(vps.[BoardName])),' OF ',' '),' AND ',' '),' & ',' '),CHARINDEX(' ',REPLACE(REPLACE(REPLACE(LTRIM(RTRIM(vps.[BoardName])),' OF ',' '),' AND ',' '),' & ',' '),1)+1,255))),1)+1,255))),1)+1,255))),CHARINDEX(' ',LTRIM(RTRIM(SUBSTRING(LTRIM(RTRIM(SUBSTRING(LTRIM(RTRIM(SUBSTRING(REPLACE(REPLACE(REPLACE(LTRIM(RTRIM(vps.[BoardName])),' OF ',' '),' AND ',' '),' & ',' '),CHARINDEX(' ',REPLACE(REPLACE(REPLACE(LTRIM(RTRIM(vps.[BoardName])),' OF ',' '),' AND ',' '),' & ',' '),1)+1,255))),CHARINDEX(' ',LTRIM(RTRIM(SUBSTRING(REPLACE(REPLACE(REPLACE(LTRIM(RTRIM(vps.[BoardName])),' OF ',' '),' AND ',' '),' & ',' '),CHARINDEX(' ',REPLACE(REPLACE(REPLACE(LTRIM(RTRIM(vps.[BoardName])),' OF ',' '),' AND ',' '),' & ',' '),1)+1,255))),1)+1,255))),CHARINDEX(' ',LTRIM(RTRIM(SUBSTRING(LTRIM(RTRIM(SUBSTRING(REPLACE(REPLACE(REPLACE(LTRIM(RTRIM(vps.[BoardName])),' OF ',' '),' AND ',' '),' & ',' '),CHARINDEX(' ',REPLACE(REPLACE(REPLACE(LTRIM(RTRIM(vps.[BoardName])),' OF ',' '),' AND ',' '),' & ',' '),1)+1,255))),CHARINDEX(' ',LTRIM(RTRIM(SUBSTRING(REPLACE(REPLACE(REPLACE(LTRIM(RTRIM(vps.[BoardName])),' OF ',' '),' AND ',' '),' & ',' '),CHARINDEX(' ',REPLACE(REPLACE(REPLACE(LTRIM(RTRIM(vps.[BoardName])),' OF ',' '),' AND ',' '),' & ',' '),1)+1,255))),1)+1,255))),1)+1,255))),1)+1,1) AS [ABBREVIATIONis]  --AS [FIFTH_INITIAL_SOURCE] REPLACE() / SUBSTITUTE() the [SOURCE] FROM PREVIOUS ... NESTED()
,*
FROM eVips_chgcv.dbo.vwPractitionerSpecialties AS vps

		--LEFT JOIN eVips_chgcv.dbo.vwPractitionerSpecialties AS vps ON UPPER(LTRIM(RTRIM(vps.PractitionerID))) = UPPER(LTRIM(RTRIM(vpd.PractitionerID)))	
		--	AND UPPER(LTRIM(RTRIM(vps.specialtycode))) = UPPER(LTRIM(RTRIM(vpps.specialtycode)))

USE eVips_chgcv

DECLARE @tblis AS nvarchar(88)
DECLARE @tbltype AS nvarchar(88)
DECLARE @tblwas AS nvarchar(88)
DECLARE @tblwillbe AS nvarchar(88)
DECLARE @fieldis AS nvarchar(88)
DECLARE @fieldwas AS nvarchar(88)
DECLARE @fieldwillbe AS nvarchar(88)

SET @tblis  = '%%'--UPDATE AS NEEDED HERE WITHIN THE ‘’
SET @tbltype  = '%%'--UPDATE AS NEEDED HERE WITHIN THE ‘’
SET @tblwas  = '%%'--UPDATE AS NEEDED HERE WITHIN THE ‘’
SET @tblwillbe  = '%%'--UPDATE AS NEEDED HERE WITHIN THE ‘’
SET @fieldis  = '%boardn%'--UPDATE AS NEEDED HERE WITHIN THE ‘’ ISO w createid OR dreatedate
SET @fieldwas  = '%%'--UPDATE AS NEEDED HERE WITHIN THE ‘’
SET @fieldwillbe  = '%%'--UPDATE AS NEEDED HERE WITHIN THE ‘’

SELECT *
-- SELECT * FROM INFORMATION_SCHEMA.TABLES --CHECK 1st
-- SELECT DISTINCT --CHECK 1st
FROM INFORMATION_SCHEMA.COLUMNS AS isc
	JOIN INFORMATION_SCHEMA.TABLES AS ist ON ist.TABLE_NAME = isc.TABLE_NAME
WHERE isc.TABLE_NAME LIKE @tblis
	AND isc.COLUMN_NAME LIKE @fieldis
	AND ist.TABLE_TYPE LIKE @tbltype
	AND isc.TABLE_NAME IN (SELECT iscwas.TABLE_NAME
FROM INFORMATION_SCHEMA.COLUMNS AS iscwas
WHERE iscwas.TABLE_NAME LIKE @tblwas
	AND iscwas.COLUMN_NAME LIKE @fieldwas)
	AND isc.TABLE_NAME IN (SELECT iscwillbe.TABLE_NAME
FROM INFORMATION_SCHEMA.COLUMNS AS iscwillbe
WHERE iscwillbe.TABLE_NAME LIKE @tblwillbe
	AND iscwillbe.COLUMN_NAME LIKE @fieldwillbe)
ORDER BY isc.TABLE_NAME,isc.COLUMN_NAME

					-- SELECT * FROM 
					-- SELECT TOP 100 * FROM 
					-- SELECT DISTINCT CertificationBoardID,BoardName FROM 
					-- SELECT * FROM [DATABASEname].dbo.
					-- SELECT DISTINCT FROM [DATABASEname].dbo.		

--ABMSBoards --BLANK()
--CertificationBoards --???
--vwABMSBoards --BLANK()
--vwCertificationBoards
vwPractitionerSpecialties
--vwSpecialties







'VISTAR HEDIS' - Hi,  Here are the crystal query specs that we discussed.  These are for VIPs providers in or out of the directory.  If it is easier to run it from eVIPs, that is ok.

x see 'HEDIS_CMC.xlsx'

{sys_lookups.set_name} = "speciality" and
{cert_provider.location_no} = "main" and
{master_cred.status} startswith ["act", "comm"] and
{cert_provider.archive_status} = "y" and
{cert_provider.plan_name} = "CMC" and
{cert_provider.plan_type} in ["pcp", "spe"] and
not ({sys_lookups.description} like ["*anest*", "*emergen*", "*neonat*", "*pathol*", "*radiolo*"])

Column Headings
					QNXT # 
					PCP or SPE
					Specialty code 
					Specialty board status 
					License #
					If certified:
					board cert code (eg ABIM) - QUPD ;WITH SQL01.VIP.dbo.board_cert AS bc ON UPPER(LTRIM(RTRIM(bc.certified_desc))) = UPPER(LTRIM(RTRIM(h.[certifying board description  (eg American Board of Internal Medicine)]))) see ,CAST(NULL AS nvarchar(25)) AS [board cert code (eg ABIM)]
					certifying board description  (eg American Board of Internal Medicine)
					??? expiration date (blank if null) ?- ,CAST(NULL AS date) AS [expiration date (blank if null)]	

thanks! 

Sandra Coleman, MBA, Credentialing Manager
Community Health Group
2420 Fenton Street, Suite 100, Chula Vista CA 91914
619 498 6438 phone
619 382 1211 fax
scolem@chgsd.com

#4059

					The expiration date is:

					In VIPs - board_cert.renew
					In eVIPs – PractitionerSpecialty.expirationDate

-- ==========================================================
	--GENERATE ADHOC HEDIS CMC [TEMPLATE] --
-- ==========================================================
-----------------------------------------------------------------------------------------------------------------------------
	-- Error Trapping: Check If Permanent Table(s) Already Exist(s) And Drop If Applicable --
-----------------------------------------------------------------------------------------------------------------------------
IF OBJECT_ID (N'HMOPROD_REPORT.dbo.HEDIS_CMC', N'U') IS NOT NULL --STATIC [TABLE_NAME] CLEANSE()
BEGIN

		DROP TABLE HMOPROD_REPORT.dbo.HEDIS_CMC --#TableName is a local temporary table visible only in the current session; ##TableName is a global temporary table visible to all sessions IN 'tempdb'

END

;WITH TEMPTABLE AS --;WITH() LIKE '%CREATION OF [tempdb] TABLE%'  ## FROM JL
( --INITIATE ...
SELECT [ASSOCIATION GROUP] AS [Prov Directory by Contracting Entity],* 
--SELECT * --CHECK 1st
FROM INFORMATICS.dbo.PROVDIR_PCP --PROV(s)
UNION -- VERTICAL() STACK ALL()
SELECT [ASSOCIATION GROUP] AS [Prov Directory by Contracting Entity],* 
--SELECT * --CHECK 1st
FROM INFORMATICS.dbo.PROVDIR_NPMP --PROV(s)
UNION -- VERTICAL() STACK ALL()
SELECT [ASSOCIATION GROUP] AS [Prov Directory by Contracting Entity],* 
--SELECT * --CHECK 1st
FROM INFORMATICS.dbo.PROVDIR_SPE --PROV(s)
UNION -- VERTICAL() STACK ALL()
SELECT [ASSOCIATION GROUP] AS [Prov Directory by Contracting Entity],* 
--SELECT * --CHECK 1st
FROM INFORMATICS.dbo.PROVDIR_MH --PROV(s)
UNION -- VERTICAL() STACK ALL()
SELECT [ASSOCIATION GROUP] AS [Prov Directory by Contracting Entity],* 
--SELECT * --CHECK 1st
FROM INFORMATICS.dbo.PROVDIR_AHP --PROV(s)
UNION -- VERTICAL() STACK ALL()
SELECT [ASSOCIATION GROUP] AS [Prov Directory by Contracting Entity],* 
--SELECT * --CHECK 1st
FROM INFORMATICS.dbo.PROVDIR_VSP --PROV(s)
) --CONCLUDE ...
SELECT DISTINCT provider_no AS [QNXT #],PROVIDER_TYPE,plan_type,Specialty AS [Specialty code],SUBSTRING([BOARD CERTIFIED],1,4) AS [Specialty board status],CA_License AS [License #],'?????' AS [board cert code (eg ABIM)],ACCREDITATION_BY AS [certifying board description  (eg American Board of Internal Medicine)],CAST(NULL AS date) AS [expiration date (blank if null)]
-- SELECT DISTINCT * 
INTO HMOPROD_REPORT.dbo.HEDIS_CMC
-- SELECT TOP 100 * --CHECK 1st
-- SELECT DISTINCT --CHECK 1st
FROM TEMPTABLE
WHERE [Participating Network] LIKE '%CMC%'
	AND UPPER(LTRIM(RTRIM([SPEC]))) NOT LIKE'%ANESTH%' --THE DESCR... 
	AND UPPER(LTRIM(RTRIM([SPEC]))) NOT LIKE'%EMERGEN%' --THE DESCR... 
	AND UPPER(LTRIM(RTRIM([SPEC]))) NOT LIKE'%NEONAT%' --THE DESCR... 
	AND UPPER(LTRIM(RTRIM([SPEC]))) NOT LIKE'%PATHOLOG%' --THE DESCR... 
	AND UPPER(LTRIM(RTRIM([SPEC]))) NOT LIKE'%RADIOLOG%' --THE DESCR... 
-- WHERE [INDEXNM] LIKE '%%%%%'
ORDER BY [INDEXNM]

					SELECT * FROM HMOPROD_REPORT.dbo.HEDIS_CMC
					
FROM INFORMATICS.dbo.HEDIS_CMC AS h
	JOIN eVips_chgcv.dbo.vwPractitionerSpecialties AS bc ON UPPER(LTRIM(RTRIM(bc.BoardName))) = UPPER(LTRIM(RTRIM(h.[certifying board description  (eg American Board of Internal Medicine)])))

					SELECT * FROM INFORMATICS.dbo.HEDIS_CMC
-- =====================================================================
	-- CONCLUDE STATEMENTS FOR PROCEDURE HERE:
-- =====================================================================

,CASE
WHEN SUBSTRING(UPPER(LTRIM(RTRIM(ISNULL(vps.BoardCertified,'')))),1,1) != 'N'
	AND UPPER(LTRIM(RTRIM(ISNULL(vps.Archived,'')))) IN ('N')  --Per S. Coleman email ON 20171229 '...Board cert status is incorrect ...'
	AND vps.BoardName IS NOT NULL
THEN 'YES'
ELSE 'NO'
END AS [ACCREDITATION] --ANOTHER REVERSAL per S. COLEMAN email ON 20170522 ADD per MS. K Callies ON 20170323
,CASE
WHEN SUBSTRING(UPPER(LTRIM(RTRIM(ISNULL(vps.BoardCertified,'')))),1,1) != 'N'
	AND UPPER(LTRIM(RTRIM(ISNULL(vps.Archived,'')))) IN ('N')  --Per S. Coleman email ON 20171229 '...Board cert status is incorrect ...'
THEN UPPER(LTRIM(RTRIM(vps.BoardName))) 
ELSE 'NA'
END AS [ACCREDITATION_BY] --[SAMPLE / EXAMPLE] For example see v18422 Dr. Blum: His cert_provider specialties are 'CRV' and 'CET'.  When you link to the master_cred table, it show he is board certified in 'CRV' and not certified in 'CET'.  Since the 'CRV' is YES, you would then link to the board_cert table to see which board.  Please make sure this is a tight join because Dr. Blum is also board certified in INM but this info is not needed.  His board_cert.specialty 'CRV' shows the cert_code AIM which matches to the sys_lookups set name cert_code.  That description is American Board of Internal Medicine. So 'CET' board status would show NO, but his 'CRV' would show YES (American Board of Internal Medicine).  Please call me if you have any questions. Thanks! AND --ADD per MS. K Callies ON 20170323

					SELECT CertificationBoardID,* FROM eVips_chgcv.dbo.vwCertificationBoards
					SELECT ExpirationDate,* FROM eVips_chgcv.dbo.vwPractitionerSpecialties

	--DUP(s)--
SELECT *
FROM eVips_chgcv.dbo.vwPractitionerSpecialties --MORE WORK REQUIRED BELOW!!! 2774 DUP(s) MANUALLY DEFAULTED to 'Y'
WHERE LTRIM(RTRIM(PractitionerID)) IN (SELECT LTRIM(RTRIM(dup.PractitionerID))
FROM eVips_chgcv.dbo.vwPractitionerSpecialties AS dup
GROUP BY LTRIM(RTRIM(dup.PractitionerID)) --Duplication Driver
HAVING COUNT(1)>1) --HAVING clause RESERVED for AGGREGATE(s)
ORDER BY LTRIM(RTRIM(PractitionerID))







'CHECK eVIPS CONVERSION' - Good morning,  We are working on getting the pharmacies in this week. 'PARALLEL RUN' Please run a directory from eVIPs Thursday afternoon after you run the live directory from VIPs.  Also, here are a couple of items to check out.  These providers are not showing on the eVIPs directory but their plans look okay.

					Hausman, Cheryl             Q#159587
					Alvira, Providence           Q#154312

Also, the double plus footnote by the name is missing for Hosein, Nadeen MD Q#161012 San Diego 92103 Endo.  Thanks! 

WHERE UPPER(LTRIM(RTRIM(vpd.LastName))) LIKE '%HAUS%'
	AND UPPER(LTRIM(RTRIM(vpd.FirstName))) LIKE '%CHER%'

WHERE UPPER(LTRIM(RTRIM(vpd.LastName))) LIKE '%ALVI%'
	AND UPPER(LTRIM(RTRIM(vpd.FirstName))) LIKE '%PROVI%'

WHERE UPPER(LTRIM(RTRIM(vpd.LastName))) LIKE '%HOSEI%'
	AND UPPER(LTRIM(RTRIM(vpd.FirstName))) LIKE '%NADE%'

SELECT * FROM INFORMATICS.dbo.PROVDIR_AHP WHERE lookup_key IN ('4371885','4368977')
SELECT [DSflag],* FROM INFORMATICS.dbo.PROVDIR_SPE WHERE lookup_key IN ('4372505')

------------------------------------------------------------------------------------------------------------------------------------
----------------	-- Error Trapping: Check If Permanent Table(s) Already Exist(s) And Drop If Applicable --
------------------------------------------------------------------------------------------------------------------------------------
----------------IF OBJECT_ID('TempDB..##DSflag') IS NOT NULL
----------------BEGIN

----------------		DROP TABLE ##DSflag --#TableName is a local temporary table visible only in the current session; ##TableName is a global temporary table visible to all sessions IN ('tempdb')

----------------END

SELECT DISTINCT vpp.PractitionerID AS [lookupkey],vpp.archived,vploc.archived,vploc.locationtypename,vploc.PracticeTypeName,vpp.producttypecode,'Clinic Specialists - for Assigned Members Only' AS [DSflag] --,*
--INTO ##DSflag
--SELECT vploc.locationtypename, vpp.practitionerid, vpp.lastname, vpp.firstname, vpp.practiceid, vpp.practicename, vpp.LocationID, vpp.locationname, vpp.PractitionerTypeCode, vpp.producttypecode, vpp.ProductTypeName --CHECK 1st
--SELECT DISTINCT --CHECK 1st
FROM eVips_chgcv.dbo.vwPractitionerProducts AS vpp
	LEFT JOIN eVips_chgcv.dbo.vwPracticeLocations AS vploc on vploc.practiceid = vpp.practiceid 
		AND vploc.Locationid= vpp.Locationid
--WHERE vpp.archived = 'N'  
--	AND vploc.archived = 'N' 
--	AND (vploc.locationtypename = 'Practice-CC'
--		OR UPPER(LTRIM(RTRIM(vploc.PracticeTypeName))) LIKE '%COMM%CLIN%')	
--	AND  vpp.producttypecode LIKE 'SPE%'
WHERE vpp.PractitionerID IN ('4372505')
--UNION ALL --VERTICAL() w UNION ALL()  - ROW(s) --STACK
SELECT DISTINCT vpp.PractitionerID AS [lookupkey],vpp.archived,vploc.archived,vploc.locationtypename,vploc.PracticeTypeName,vpp.producttypecode,'Per Diem / Part Time Provider - May Have Limited Appt. Availability' AS [DSflag] --,*
--SELECT DISTINCT vpp.PractitionerID AS [lookupkey],vpp.PractitionerID,'Per Diem / Part Time Provider - May Have Limited Appt. Availability' AS [DSflag],*
----SELECT vpp.StatusTypeName,vploc.locationtypename, vpp.practitionerid, vpp.lastname, vpp.firstname, vpp.practiceid, vpp.practicename, vpp.LocationID, vpp.locationname, vpp.PractitionerTypeCode, vpp.producttypecode, vpp.ProductTypeName --CHECK 1st
----SELECT DISTINCT --CHECK 1st
FROM eVips_chgcv.dbo.vwPractitionerProducts AS vpp
	LEFT JOIN eVips_chgcv.dbo.vwPracticeLocations AS vploc on vploc.practiceid = vpp.practiceid 
		AND vploc.Locationid= vpp.Locationid
--WHERE vpp.archived = 'N'  
--	AND vploc.archived = 'N' 
--	AND UPPER(LTRIM(RTRIM(vpp.StatusTypeName))) LIKE 'ACT%PER%DIE%'
--	AND vpp.PractitionerID IN ('4372505')
WHERE vpp.PractitionerID IN ('4372505')

					--SELECT * FROM ##DSflag --RELATED TO PROV(s) ONLY







'MORE COMPLAINT'(s) - Hi Walter,  Here are a few adjustments for the eVIPs directory.  Please adjust them before you re-run the directory on Tuesday.

-- SELECT LocationID,* FROM INFORMATICS.dbo.TimelyAccessPCP WHERE LTRIM(RTRIM(lookup_key)) IN ('4389470','4367470','4380458','4382830')

SELECT FINALhosp,* FROM INFORMATICS.dbo.PROVDIR_PCP WHERE LTRIM(RTRIM(lookup_key)) IN ('4389470')
SELECT FINALhosp,* FROM INFORMATICS.dbo.PROVDIR_PCP WHERE LTRIM(RTRIM(lookup_key)) IN ('4367470')
SELECT [Clinic QNXT provid],* FROM INFORMATICS.dbo.PROVDIR_PCP WHERE LTRIM(RTRIM(lookup_key)) IN ('4380458')

SELECT TOP 100 Archived,BoardCertified,BoardName
,CASE
WHEN SUBSTRING(UPPER(LTRIM(RTRIM(ISNULL(vps.BoardCertified,'')))),1,1) != 'N'
	AND UPPER(LTRIM(RTRIM(ISNULL(vps.Archived,'')))) IN ('N')  --Per S. Coleman email ON 20171229 '...Board cert status is incorrect ...'
	AND vps.BoardName IS NOT NULL
THEN 'YES'
ELSE 'NO'
END AS [ACCREDITATION] --ANOTHER REVERSAL per S. COLEMAN email ON 20170522 ADD per MS. K Callies ON 20170323
,CASE
WHEN SUBSTRING(UPPER(LTRIM(RTRIM(ISNULL(vps.BoardCertified,'')))),1,1) != 'N'
	AND UPPER(LTRIM(RTRIM(ISNULL(vps.Archived,'')))) IN ('N')  --Per S. Coleman email ON 20171229 '...Board cert status is incorrect ...'
THEN UPPER(LTRIM(RTRIM(vps.BoardName))) 
ELSE 'NA'
END AS [ACCREDITATION_BY] --[SAMPLE / EXAMPLE] For example see v18422 Dr. Blum: His cert_provider specialties are 'CRV' and 'CET'.  When you link to the master_cred table, it show he is board certified in 'CRV' and not certified in 'CET'.  Since the 'CRV' is YES, you would then link to the board_cert table to see which board.  Please make sure this is a tight join because Dr. Blum is also board certified in INM but this info is not needed.  His board_cert.specialty 'CRV' shows the cert_code AIM which matches to the sys_lookups set name cert_code.  That description is American Board of Internal Medicine. So 'CET' board status would show NO, but his 'CRV' would show YES (American Board of Internal Medicine).  Please call me if you have any questions. Thanks! AND --ADD per MS. K Callies ON 20170323
,* FROM eVips_chgcv.dbo.vwPractitionerSpecialties AS vps WHERE PractitionerID IN ('4382830') --AND UPPER(LTRIM(RTRIM(ISNULL(vpa.Archived,'')))) IN ('N')

SELECT DISTINCT BoardCertified,BoardName FROM eVips_chgcv.dbo.vwPractitionerSpecialties
SELECT ACCREDITATION,ACCREDITATION_BY,* FROM INFORMATICS.dbo.PROVDIR_PCP WHERE LTRIM(RTRIM(lookup_key)) IN ('4382830')

					1)	Some archived Hospital privileges are showing: 
					V2615    Sanzone, Ronald does not have active privileges.  PVH & Scripps Hillcrest are inactive privileges but they are archived.
					V16635 Flores, Jill does not have active privileges.  No privileges should be showing.
					
	AND UPPER(LTRIM(RTRIM(ISNULL(vpa.Archived,'')))) IN ('N')  --Per S. Coleman email ON 20171229 '...Some archived Hospital privileges are showing: ...'
	
WHERE UPPER(LTRIM(RTRIM(vpd.LastName))) LIKE '%SANZONE%'
	AND UPPER(LTRIM(RTRIM(vpd.FirstName))) LIKE '%RON%'

SELECT * FROM INFORMATICS.dbo.PROVDIR_PCP WHERE LTRIM(RTRIM(lookup_key)) IN ('4389470')

WHERE UPPER(LTRIM(RTRIM(vpd.LastName))) LIKE '%FLOR%'
	AND UPPER(LTRIM(RTRIM(vpd.FirstName))) LIKE '%JILL%'

SELECT * FROM INFORMATICS.dbo.PROVDIR_PCP WHERE LTRIM(RTRIM(lookup_key)) IN ('4367470')

					2)	Site code should be eVIPs unique Location ID:  in VIPs, this is the address code.  I believe this would be the LocationID. It is a unique ID for every location (Site).  
					Cardenas, Yolanda is a PCP at S136001.  The new site location id is 4125235. see '[Clinic QNXT provid]'

,UPPER(LTRIM(RTRIM(spe.LocationID))) AS [Clinic QNXT provid] ---Per S. Coleman email ON 20171229 '...Site code should be eVIPs unique Location ID ...'
-- ,[Clinic QNXT provid]
	
WHERE UPPER(LTRIM(RTRIM(vpd.LastName))) LIKE '%CARDEN%'
	AND UPPER(LTRIM(RTRIM(vpd.FirstName))) LIKE '%YOL%'

SELECT * FROM INFORMATICS.dbo.PROVDIR_PCP WHERE LTRIM(RTRIM(lookup_key)) IN ('4380458')	

					3)	Board cert status is incorrect 
					V23257         Battikhi, Huda is eligible in Pediatrics.  eVIPs is correct.  The directory shows Y as if board certified. see '[ACCREDITATION]'

SELECT TOP 100 Archived,BoardCertified,BoardName
,CASE
WHEN SUBSTRING(UPPER(LTRIM(RTRIM(ISNULL(vps.BoardCertified,'')))),1,1) != 'N'
	AND UPPER(LTRIM(RTRIM(ISNULL(vps.Archived,'')))) IN ('N')  --Per S. Coleman email ON 20171229 '...Board cert status is incorrect ...'
	AND vps.BoardName IS NOT NULL
THEN 'YES'
ELSE 'NO'
END AS [ACCREDITATION] --ANOTHER REVERSAL per S. COLEMAN email ON 20170522 ADD per MS. K Callies ON 20170323
,CASE
WHEN SUBSTRING(UPPER(LTRIM(RTRIM(ISNULL(vps.BoardCertified,'')))),1,1) != 'N'
	AND UPPER(LTRIM(RTRIM(ISNULL(vps.Archived,'')))) IN ('N')  --Per S. Coleman email ON 20171229 '...Board cert status is incorrect ...'
THEN UPPER(LTRIM(RTRIM(vps.BoardName))) 
ELSE 'NA'
END AS [ACCREDITATION_BY] --[SAMPLE / EXAMPLE] For example see v18422 Dr. Blum: His cert_provider specialties are 'CRV' and 'CET'.  When you link to the master_cred table, it show he is board certified in 'CRV' and not certified in 'CET'.  Since the 'CRV' is YES, you would then link to the board_cert table to see which board.  Please make sure this is a tight join because Dr. Blum is also board certified in INM but this info is not needed.  His board_cert.specialty 'CRV' shows the cert_code AIM which matches to the sys_lookups set name cert_code.  That description is American Board of Internal Medicine. So 'CET' board status would show NO, but his 'CRV' would show YES (American Board of Internal Medicine).  Please call me if you have any questions. Thanks! AND --ADD per MS. K Callies ON 20170323
,* FROM eVips_chgcv.dbo.vwPractitionerSpecialties AS vps WHERE PractitionerID IN ('4382830') --AND UPPER(LTRIM(RTRIM(ISNULL(vpa.Archived,'')))) IN ('N')

SELECT DISTINCT BoardCertified,BoardName FROM eVips_chgcv.dbo.vwPractitionerSpecialties
SELECT ACCREDITATION,ACCREDITATION_BY,* FROM INFORMATICS.dbo.PROVDIR_PCP WHERE LTRIM(RTRIM(lookup_key)) IN ('4382830')

WHERE UPPER(LTRIM(RTRIM(vpd.LastName))) LIKE '%BATT%'
	AND UPPER(LTRIM(RTRIM(vpd.FirstName))) LIKE '%HUD%'
	
SELECT * FROM INFORMATICS.dbo.PROVDIR_PCP WHERE LTRIM(RTRIM(lookup_key)) IN ('4382830')

USE eVips_chgcv
DECLARE @tblis AS nvarchar(88)
DECLARE @tblwas AS nvarchar(88)
DECLARE @tblwillbe AS nvarchar(88)
DECLARE @fieldis AS nvarchar(88)
DECLARE @fieldwas AS nvarchar(88)
DECLARE @fieldwillbe AS nvarchar(88)

SET @tblis  = '%vw%'--UPDATE AS NEEDED HERE WITHIN THE ‘’
SET @tblwas  = '%%'--UPDATE AS NEEDED HERE WITHIN THE ‘’
SET @tblwillbe  = '%%'--UPDATE AS NEEDED HERE WITHIN THE ‘’
SET @fieldis  = '%board%'--UPDATE AS NEEDED HERE WITHIN THE ‘’ ISO w createid OR dreatedate
SET @fieldwas  = '%%'--UPDATE AS NEEDED HERE WITHIN THE ‘’
SET @fieldwillbe  = '%%'--UPDATE AS NEEDED HERE WITHIN THE ‘’

SELECT DISTINCT TABLE_NAME,COLUMN_NAME,DATA_TYPE,IS_NULLABLE,CHARACTER_MAXIMUM_LENGTH,COLLATION_NAME --,*
FROM INFORMATION_SCHEMA.COLUMNS WITH (NOLOCK) --MINIMIZE impact on PRODUCTION staff during BUSINESS HOUR(s)
--FROM INFORMATION_SCHEMA.TABLES WITH (NOLOCK) --MINIMIZE impact on PRODUCTION staff during BUSINESS HOUR(s)
--FROM INFORMATION_SCHEMA.COLUMNS (NOLOCK) --MINIMIZE impact on PRODUCTION staff during BUSINESS HOUR(s)
--FROM INFORMATION_SCHEMA.TABLES (NOLOCK) --MINIMIZE impact on PRODUCTION staff during BUSINESS HOUR(s)
WHERE TABLE_NAME LIKE @tblis
	AND COLUMN_NAME LIKE @fieldis
	AND TABLE_NAME IN (SELECT TABLE_NAME
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME LIKE @tblwas
	AND COLUMN_NAME LIKE @fieldwas)
	AND TABLE_NAME IN (SELECT TABLE_NAME
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME LIKE @tblwillbe
	AND COLUMN_NAME LIKE @fieldwillbe)
ORDER BY TABLE_NAME,COLUMN_NAME

					-- SELECT * FROM 
					-- SELECT DISTINCT  FROM 
					 SELECT * FROM eVips_chgcv.dbo.
					-- SELECT DISTINCT FROM [DATABASEname].dbo.
					
--vwABMSBoards --ISNULL()
--vwCertificationBoards --HEADER DESCRIPTION(s)
--vwPractitionerCME --ISNULL()
vwPractitionerSpecialties --AS [ACCREDITATION_BY] FROM ##INNETWORK_PROV
--vwSpecialties --???

Thanks so much! 







x AGE RESTRICTION(s) MAKE NULL(s) '0' ... 







'MORE COMPLAINT'(s) - Hi Walter,  Here are a few adjustments for the eVIPs directory.  Please adjust them before you re-run the directory on Tuesday.

-- SELECT LocationID,* FROM INFORMATICS.dbo.TimelyAccessPCP WHERE LTRIM(RTRIM(lookup_key)) IN ('4389470','4367470','4380458','4382830')

SELECT FINALhosp,* FROM INFORMATICS.dbo.PROVDIR_PCP WHERE LTRIM(RTRIM(lookup_key)) IN ('4389470')
SELECT FINALhosp,* FROM INFORMATICS.dbo.PROVDIR_PCP WHERE LTRIM(RTRIM(lookup_key)) IN ('4367470')
SELECT [Clinic QNXT provid],* FROM INFORMATICS.dbo.PROVDIR_PCP WHERE LTRIM(RTRIM(lookup_key)) IN ('4380458')

SELECT TOP 100 Archived,BoardCertified,BoardName
,CASE
WHEN SUBSTRING(UPPER(LTRIM(RTRIM(ISNULL(vps.BoardCertified,'')))),1,1) != 'N'
	AND UPPER(LTRIM(RTRIM(ISNULL(vps.Archived,'')))) IN ('N')  --Per S. Coleman email ON 20171229 '...Board cert status is incorrect ...'
	AND vps.BoardName IS NOT NULL
THEN 'YES'
ELSE 'NO'
END AS [ACCREDITATION] --ANOTHER REVERSAL per S. COLEMAN email ON 20170522 ADD per MS. K Callies ON 20170323
,CASE
WHEN SUBSTRING(UPPER(LTRIM(RTRIM(ISNULL(vps.BoardCertified,'')))),1,1) != 'N'
	AND UPPER(LTRIM(RTRIM(ISNULL(vps.Archived,'')))) IN ('N')  --Per S. Coleman email ON 20171229 '...Board cert status is incorrect ...'
THEN UPPER(LTRIM(RTRIM(vps.BoardName))) 
ELSE 'NA'
END AS [ACCREDITATION_BY] --[SAMPLE / EXAMPLE] For example see v18422 Dr. Blum: His cert_provider specialties are 'CRV' and 'CET'.  When you link to the master_cred table, it show he is board certified in 'CRV' and not certified in 'CET'.  Since the 'CRV' is YES, you would then link to the board_cert table to see which board.  Please make sure this is a tight join because Dr. Blum is also board certified in INM but this info is not needed.  His board_cert.specialty 'CRV' shows the cert_code AIM which matches to the sys_lookups set name cert_code.  That description is American Board of Internal Medicine. So 'CET' board status would show NO, but his 'CRV' would show YES (American Board of Internal Medicine).  Please call me if you have any questions. Thanks! AND --ADD per MS. K Callies ON 20170323
,* FROM eVips_chgcv.dbo.vwPractitionerSpecialties AS vps WHERE PractitionerID IN ('4382830') --AND UPPER(LTRIM(RTRIM(ISNULL(vpa.Archived,'')))) IN ('N')

SELECT DISTINCT BoardCertified,BoardName FROM eVips_chgcv.dbo.vwPractitionerSpecialties
SELECT ACCREDITATION,ACCREDITATION_BY,* FROM INFORMATICS.dbo.PROVDIR_PCP WHERE LTRIM(RTRIM(lookup_key)) IN ('4382830')

					1)	Some archived Hospital privileges are showing: 
					V2615    Sanzone, Ronald does not have active privileges.  PVH & Scripps Hillcrest are inactive privileges but they are archived.
					V16635 Flores, Jill does not have active privileges.  No privileges should be showing.
					
	AND UPPER(LTRIM(RTRIM(ISNULL(vpa.Archived,'')))) IN ('N')  --Per S. Coleman email ON 20171229 '...Some archived Hospital privileges are showing: ...'
	
WHERE UPPER(LTRIM(RTRIM(vpd.LastName))) LIKE '%SANZONE%'
	AND UPPER(LTRIM(RTRIM(vpd.FirstName))) LIKE '%RON%'

SELECT * FROM INFORMATICS.dbo.PROVDIR_PCP WHERE LTRIM(RTRIM(lookup_key)) IN ('4389470')

WHERE UPPER(LTRIM(RTRIM(vpd.LastName))) LIKE '%FLOR%'
	AND UPPER(LTRIM(RTRIM(vpd.FirstName))) LIKE '%JILL%'

SELECT * FROM INFORMATICS.dbo.PROVDIR_PCP WHERE LTRIM(RTRIM(lookup_key)) IN ('4367470')

					2)	Site code should be eVIPs unique Location ID:  in VIPs, this is the address code.  I believe this would be the LocationID. It is a unique ID for every location (Site).  
					Cardenas, Yolanda is a PCP at S136001.  The new site location id is 4125235. see '[Clinic QNXT provid]'

,UPPER(LTRIM(RTRIM(spe.LocationID))) AS [Clinic QNXT provid] ---Per S. Coleman email ON 20171229 '...Site code should be eVIPs unique Location ID ...'
-- ,[Clinic QNXT provid]
	
WHERE UPPER(LTRIM(RTRIM(vpd.LastName))) LIKE '%CARDEN%'
	AND UPPER(LTRIM(RTRIM(vpd.FirstName))) LIKE '%YOL%'

SELECT * FROM INFORMATICS.dbo.PROVDIR_PCP WHERE LTRIM(RTRIM(lookup_key)) IN ('4380458')	

					3)	Board cert status is incorrect 
					V23257         Battikhi, Huda is eligible in Pediatrics.  eVIPs is correct.  The directory shows Y as if board certified. see '[ACCREDITATION]'

SELECT TOP 100 Archived,BoardCertified,BoardName
,CASE
WHEN SUBSTRING(UPPER(LTRIM(RTRIM(ISNULL(vps.BoardCertified,'')))),1,1) != 'N'
	AND UPPER(LTRIM(RTRIM(ISNULL(vps.Archived,'')))) IN ('N')  --Per S. Coleman email ON 20171229 '...Board cert status is incorrect ...'
	AND vps.BoardName IS NOT NULL
THEN 'YES'
ELSE 'NO'
END AS [ACCREDITATION] --ANOTHER REVERSAL per S. COLEMAN email ON 20170522 ADD per MS. K Callies ON 20170323
,CASE
WHEN SUBSTRING(UPPER(LTRIM(RTRIM(ISNULL(vps.BoardCertified,'')))),1,1) != 'N'
	AND UPPER(LTRIM(RTRIM(ISNULL(vps.Archived,'')))) IN ('N')  --Per S. Coleman email ON 20171229 '...Board cert status is incorrect ...'
THEN UPPER(LTRIM(RTRIM(vps.BoardName))) 
ELSE 'NA'
END AS [ACCREDITATION_BY] --[SAMPLE / EXAMPLE] For example see v18422 Dr. Blum: His cert_provider specialties are 'CRV' and 'CET'.  When you link to the master_cred table, it show he is board certified in 'CRV' and not certified in 'CET'.  Since the 'CRV' is YES, you would then link to the board_cert table to see which board.  Please make sure this is a tight join because Dr. Blum is also board certified in INM but this info is not needed.  His board_cert.specialty 'CRV' shows the cert_code AIM which matches to the sys_lookups set name cert_code.  That description is American Board of Internal Medicine. So 'CET' board status would show NO, but his 'CRV' would show YES (American Board of Internal Medicine).  Please call me if you have any questions. Thanks! AND --ADD per MS. K Callies ON 20170323
,* FROM eVips_chgcv.dbo.vwPractitionerSpecialties AS vps WHERE PractitionerID IN ('4382830') --AND UPPER(LTRIM(RTRIM(ISNULL(vpa.Archived,'')))) IN ('N')

SELECT DISTINCT BoardCertified,BoardName FROM eVips_chgcv.dbo.vwPractitionerSpecialties
SELECT ACCREDITATION,ACCREDITATION_BY,* FROM INFORMATICS.dbo.PROVDIR_PCP WHERE LTRIM(RTRIM(lookup_key)) IN ('4382830')

WHERE UPPER(LTRIM(RTRIM(vpd.LastName))) LIKE '%BATT%'
	AND UPPER(LTRIM(RTRIM(vpd.FirstName))) LIKE '%HUD%'
	
SELECT * FROM INFORMATICS.dbo.PROVDIR_PCP WHERE LTRIM(RTRIM(lookup_key)) IN ('4382830')

USE eVips_chgcv
DECLARE @tblis AS nvarchar(88)
DECLARE @tblwas AS nvarchar(88)
DECLARE @tblwillbe AS nvarchar(88)
DECLARE @fieldis AS nvarchar(88)
DECLARE @fieldwas AS nvarchar(88)
DECLARE @fieldwillbe AS nvarchar(88)

SET @tblis  = '%vw%'--UPDATE AS NEEDED HERE WITHIN THE ‘’
SET @tblwas  = '%%'--UPDATE AS NEEDED HERE WITHIN THE ‘’
SET @tblwillbe  = '%%'--UPDATE AS NEEDED HERE WITHIN THE ‘’
SET @fieldis  = '%board%'--UPDATE AS NEEDED HERE WITHIN THE ‘’ ISO w createid OR dreatedate
SET @fieldwas  = '%%'--UPDATE AS NEEDED HERE WITHIN THE ‘’
SET @fieldwillbe  = '%%'--UPDATE AS NEEDED HERE WITHIN THE ‘’

SELECT DISTINCT TABLE_NAME,COLUMN_NAME,DATA_TYPE,IS_NULLABLE,CHARACTER_MAXIMUM_LENGTH,COLLATION_NAME --,*
FROM INFORMATION_SCHEMA.COLUMNS WITH (NOLOCK) --MINIMIZE impact on PRODUCTION staff during BUSINESS HOUR(s)
--FROM INFORMATION_SCHEMA.TABLES WITH (NOLOCK) --MINIMIZE impact on PRODUCTION staff during BUSINESS HOUR(s)
--FROM INFORMATION_SCHEMA.COLUMNS (NOLOCK) --MINIMIZE impact on PRODUCTION staff during BUSINESS HOUR(s)
--FROM INFORMATION_SCHEMA.TABLES (NOLOCK) --MINIMIZE impact on PRODUCTION staff during BUSINESS HOUR(s)
WHERE TABLE_NAME LIKE @tblis
	AND COLUMN_NAME LIKE @fieldis
	AND TABLE_NAME IN (SELECT TABLE_NAME
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME LIKE @tblwas
	AND COLUMN_NAME LIKE @fieldwas)
	AND TABLE_NAME IN (SELECT TABLE_NAME
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME LIKE @tblwillbe
	AND COLUMN_NAME LIKE @fieldwillbe)
ORDER BY TABLE_NAME,COLUMN_NAME

					-- SELECT * FROM 
					-- SELECT DISTINCT  FROM 
					 SELECT * FROM eVips_chgcv.dbo.
					-- SELECT DISTINCT FROM [DATABASEname].dbo.
					
--vwABMSBoards --ISNULL()
--vwCertificationBoards --HEADER DESCRIPTION(s)
--vwPractitionerCME --ISNULL()
vwPractitionerSpecialties --AS [ACCREDITATION_BY] FROM ##INNETWORK_PROV
--vwSpecialties --???

Thanks so much! 







x AGE RESTRICTION(s) MAKE NULL(s) '0' ... 

-- ===================================================================
	--HDR [AGE RESTRICTION] OPTION(s)--
-- ===================================================================
------------------------------------------------------------------------------------------------------------------------
	-- Error Trapping: Check If Permanent Table(s) Already Exist(s) And Drop If Applicable --
------------------------------------------------------------------------------------------------------------------------
IF OBJECT_ID('TempDB..#AGERESTRICTION_FAC') IS NOT NULL
BEGIN

		DROP TABLE #AGERESTRICTION_FAC

 END
 
SELECT DISTINCT vlpl.LocationID,vlpl.PracticeID,vlpl.ProductID --,vlpl.AddressID
 ,[AGE RESTRICTION] = CASE --QUPD / CASE WHEN THEN ELSE END... USE pcp.MinimumAge AND pcp.age-restriction2
WHEN LTRIM(RTRIM(ISNULL(vlpl.MinimumAge,'0'))) = '21'
	AND LTRIM(RTRIM(ISNULL(vlpl.MaximumAge,'0'))) = '999'
THEN '21 AND OVER'
WHEN LTRIM(RTRIM(ISNULL(vlpl.MinimumAge,'0'))) = '18'
	AND LTRIM(RTRIM(ISNULL(vlpl.MaximumAge,'0'))) = '999'
THEN '18 AND OVER'
WHEN LTRIM(RTRIM(ISNULL(vlpl.MinimumAge,'0'))) = '0'
	AND LTRIM(RTRIM(ISNULL(vlpl.MaximumAge,'0'))) = '18'
THEN 'UP TO 18' --Per S. Coleman ON 20160809 Please review the following for this provider. Cohenmeyer  132285     SPE  92123  Age Restrictions should show 0 – 18
WHEN LTRIM(RTRIM(ISNULL(vlpl.MinimumAge,'0'))) = '0'
	AND LTRIM(RTRIM(ISNULL(vlpl.MaximumAge,'0'))) != '999'
THEN 'UP TO '+LTRIM(RTRIM(ISNULL(vlpl.MaximumAge,'0')))
WHEN LTRIM(RTRIM(ISNULL(vlpl.MinimumAge,'0'))) != '0' -- NO NOT NEGATIVE <> != ...
	AND LTRIM(RTRIM(ISNULL(vlpl.MaximumAge,'0'))) = '999'
THEN LTRIM(RTRIM(ISNULL(vlpl.MinimumAge,'0')))+' AND OVER'
WHEN LTRIM(RTRIM(ISNULL(vlpl.MinimumAge,'0'))) != '0' -- NO NOT NEGATIVE <> != ...
	AND LTRIM(RTRIM(ISNULL(vlpl.MaximumAge,'0'))) != '999'
THEN LTRIM(RTRIM(ISNULL(vlpl.MinimumAge,'0')))+' TO '+LTRIM(RTRIM(ISNULL(vlpl.MaximumAge,'0')))
ELSE 'NONE'
END --CHANGE OF OPTION(s) per S. Coleman ON 20170103
INTO #AGERESTRICTION_FAC
--SELECT * --CHECK 1st
--SELECT DISTINCT ISNULL(MinimumAge,'0') AS [MINAGE],ISNULL(MaximumAge,'0') AS [MAXAGE] --CHECK 1st
FROM eVips_chgcv.dbo.vwLocationProductLimitations AS vlpl --OR vwPractitionerProductLimitations
WHERE UPPER(LTRIM(RTRIM(vlpl.LimitationtypeName))) LIKE '%AGE%' --WHERE LimitationtypeName LIKE '%Age%' 

					SELECT * FROM #AGERESTRICTION_FAC







------------------------------------------------------------------------------------------------------------------------
	-- Error Trapping: Check If Permanent Table(s) Already Exist(s) And Drop If Applicable --
------------------------------------------------------------------------------------------------------------------------
IF OBJECT_ID('TempDB..#AGERESTRICTION_PROV') IS NOT NULL
BEGIN

		DROP TABLE #AGERESTRICTION_PROV

 END
 
SELECT DISTINCT vppl.PractitionerID,vppl.ProductID --,vppl.LocationID,vppl.AddressID
 ,[AGE RESTRICTION] = CASE --QUPD / CASE WHEN THEN ELSE END... USE pcp.MinimumAge AND pcp.age-restriction2
WHEN LTRIM(RTRIM(ISNULL(vppl.MinimumAge,'0'))) = '21'
	AND LTRIM(RTRIM(ISNULL(vppl.MaximumAge,'0'))) = '999'
THEN '21 AND OVER'
WHEN LTRIM(RTRIM(ISNULL(vppl.MinimumAge,'0'))) = '18'
	AND LTRIM(RTRIM(ISNULL(vppl.MaximumAge,'0'))) = '999'
THEN '18 AND OVER'
WHEN LTRIM(RTRIM(ISNULL(vppl.MinimumAge,'0'))) = '0'
	AND LTRIM(RTRIM(ISNULL(vppl.MaximumAge,'0'))) = '18'
THEN 'UP TO 18' --Per S. Coleman ON 20160809 Please review the following for this provider. Cohenmeyer  132285     SPE  92123  Age Restrictions should show 0 – 18
WHEN LTRIM(RTRIM(ISNULL(vppl.MinimumAge,'0'))) = '0'
	AND LTRIM(RTRIM(ISNULL(vppl.MaximumAge,'0'))) != '999'
THEN 'UP TO '+LTRIM(RTRIM(ISNULL(vppl.MaximumAge,'0')))
WHEN LTRIM(RTRIM(ISNULL(vppl.MinimumAge,'0'))) != '0' -- NO NOT NEGATIVE <> != ...
	AND LTRIM(RTRIM(ISNULL(vppl.MaximumAge,'0'))) = '999'
THEN LTRIM(RTRIM(ISNULL(vppl.MinimumAge,'0')))+' AND OVER'
WHEN LTRIM(RTRIM(ISNULL(vppl.MinimumAge,'0'))) != '0' -- NO NOT NEGATIVE <> != ...
	AND LTRIM(RTRIM(ISNULL(vppl.MaximumAge,'0'))) != '999'
THEN LTRIM(RTRIM(ISNULL(vppl.MinimumAge,'0')))+' TO '+LTRIM(RTRIM(ISNULL(vppl.MaximumAge,'0')))
ELSE 'NONE'
END --CHANGE OF OPTION(s) per S. Coleman ON 20170103
INTO #AGERESTRICTION_PROV
--SELECT * --CHECK 1st
--SELECT DISTINCT ISNULL(MinimumAge,'0') AS [MINAGE],ISNULL(MaximumAge,'0') AS [MAXAGE] --CHECK 1st
FROM eVips_chgcv.dbo.vwPractitionerProductLimitations AS vppl --OR vwLocationProductLimitations
WHERE UPPER(LTRIM(RTRIM(vppl.LimitationtypeName))) LIKE '%AGE%' --WHERE LimitationtypeName LIKE '%Age%' 

					SELECT * FROM #AGERESTRICTION_PROV

x ##LIC_FAC AND ##LIC_PROV EXCLUDE ARCHIVED LIC(s) ...

--------------------------------------------------------------------------------------------------------------------
	-- Error Trapping: Check If Permanent Table(s) Already Exist(s) And Drop If Applicable --
--------------------------------------------------------------------------------------------------------------------
IF OBJECT_ID('TempDB..##LIC_FAC') IS NOT NULL
BEGIN

		DROP TABLE ##LIC_FAC --#TableName is a local temporary table visible only in the current session; ##TableName is a global temporary table visible to all sessions IN ('tempdb')

END

SELECT DISTINCT vploc.LocationID,vploc.PracticeID,vploc.AddressID,REPLACE(UPPER(LTRIM(RTRIM(vplic.LicenseNumber))),'-','') AS [CA_LIC]
INTO ##LIC_FAC
--SELECT vploc.Archived,vplic.Archived,vplic.LicenseNumber,vplic.PrimaryLicense,* --CHECK 1st
--SELECT * FROM eVips_chgcv.dbo.vwPracticeLicenses WHERE UPPER(LTRIM(RTRIM(LicenseNumber))) = '090000013' --CHECK 1st 
--SELECT DISTINCT LocationTypeName FROM eVips_chgcv.dbo.vwPracticeLocations --CHECK 1st
FROM eVips_chgcv.dbo.vwPracticeLocations AS vploc
	JOIN eVips_chgcv.dbo.vwPracticeLicenses AS vplic ON  vplic.PracticeID = vploc. PracticeID
		AND vplic.LocationID = vploc. LocationID
		AND vplic.AddressID = vploc. AddressID
WHERE UPPER(LTRIM(RTRIM(vploc.LocationTypeName))) LIKE '%PRACTIC%'
	AND (UPPER(LTRIM(RTRIM(vplic.LicenseTypeName))) LIKE '%LICENSE%'
			OR vplic.LicenseTypeName IS NULL)
	AND vplic.LicenseNumber IS NOT NULL
	AND UPPER(LTRIM(RTRIM(vplic.LicenseNumber))) != ''
	AND UPPER(LTRIM(RTRIM(vplic.PrimaryLicense))) = 'Y'
	AND UPPER(LTRIM(RTRIM(vploc.Archived))) = 'N'
	AND UPPER(LTRIM(RTRIM(vplic.Archived))) = 'N'

					SELECT * FROM ##LIC_FAC







--------------------------------------------------------------------------------------------------------------------
	-- Error Trapping: Check If Permanent Table(s) Already Exist(s) And Drop If Applicable --
--------------------------------------------------------------------------------------------------------------------
IF OBJECT_ID('TempDB..##LIC_PROV') IS NOT NULL
BEGIN

		DROP TABLE ##LIC_PROV --#TableName is a local temporary table visible only in the current session; ##TableName is a global temporary table visible to all sessions IN ('tempdb')

END

SELECT DISTINCT vploc.PractitionerID AS [lookup_key],REPLACE(UPPER(LTRIM(RTRIM(vplic.LicenseNumber))),'-','') AS [CA_LIC]
INTO ##LIC_PROV
--SELECT vploc.Archived,vplic.Archived,vplic.LicenseNumber,vplic.PrimaryLicense,* --CHECK 1st
--SELECT * FROM eVips_chgcv.dbo.vwPractitionerLicenses --CHECK 1st 
--SELECT DISTINCT LocationTypeName FROM eVips_chgcv.dbo.vwPractitionerLocations --CHECK 1st
FROM eVips_chgcv.dbo.vwPractitionerLocations AS vploc
	JOIN eVips_chgcv.dbo.vwPractitionerLicenses AS vplic ON  vplic.PractitionerID = vploc. PractitionerID
WHERE (UPPER(LTRIM(RTRIM(vplic.LicenseTypeName))) LIKE '%LICENSE%'
			OR vplic.LicenseTypeName IS NULL)
	AND vplic.LicenseNumber IS NOT NULL
	AND UPPER(LTRIM(RTRIM(vplic.LicenseNumber))) != ''
	AND UPPER(LTRIM(RTRIM(vplic.PrimaryLicense))) = 'Y'
	AND UPPER(LTRIM(RTRIM(vploc.Archived))) = 'N'
	AND UPPER(LTRIM(RTRIM(vplic.Archived))) = 'N'

					SELECT * FROM ##LIC_PROV







x ALLOW FOR IS NULL EntityCode In PROVDIR_AHP

	AND (UPPER(LTRIM(RTRIM(spe.EntityCode)))  NOT LIKE '%VSP%'
		OR spe.EntityCode IS NULL) --ARRIVE AT ENTITY TYPE(s) FROM PROVDIR MEETING ON 20170920 SPECIFICALLY TO ID VSP PROV(s) ... --ProviderID = PractitionerID WHERE UPPER(LTRIM(RTRIM(vea.TableName))) LIKE '%Practit%' OR  ProviderID = PracticeID WHERE UPPER(LTRIM(RTRIM(vea.TableName))) LIKE '%Practice%'

x IGNORE LOB aka [Particpating Network] LIKE '%PHARM%'(s)
					SELECT * FROM INFORMATICS.dbo.PROVDIR_CLINIC --INCLUDE ALL ... AND ...CONSOLIDATE LANGUAGE(s) WITH JL_Languages_...sql ADD BACK [CULTURAL COMPETENCE]

x ADD [ProductName] to REVIEW ...
x AND vp.StatusTypeName LIKE 'ACTIVE%' --•	ADD ON TO FAC per PROVDIR meeting ON 20171226

		see ,UPPER(LTRIM(RTRIM(vlp.StatusTypeName))) AS [vlpSTATUSTYPENAME]
		
				AND spe.[vlpSTATUSTYPENAME] LIKE 'ACTIVE%' --•	ADD ON TO FAC per PROVDIR meeting ON 20171226
		
x [Office Hour(s)]
x AND UPPER(LTRIM(RTRIM(vpps.Archived))) IN ('N') -- ADD ON per MEETING ;WITH YOUNG LADY LAURA, SC & HL ON 20171226

SELECT DISTINCT [Office Hour(s)] FROM ##INNETWORK_FAC
SELECT DISTINCT [Office Hour(s)] FROM ##INNETWORK_PROV

					SELECT [Office Hour(s)],* FROM ##INNETWORK_FAC WHERE [Office Hour(s)] IS NULL
					SELECT [Office Hour(s)],* FROM ##INNETWORK_PROV WHERE [Office Hour(s)] IS NULL

SELECT DISTINCT [vlpSTATUSTYPENAME] FROM ##INNETWORK_FAC
SELECT DISTINCT [vppSTATUSTYPENAME] FROM ##INNETWORK_PROV

SELECT DISTINCT [panel_status] FROM ##INNETWORK_FAC
SELECT DISTINCT [panel_status] FROM ##INNETWORK_PROV

SELECT DISTINCT [status_code] FROM ##INNETWORK_PROV

,UPPER(LTRIM(RTRIM(vlp.StatusTypeName))) AS [vlpSTATUSTYPENAME]
,UPPER(LTRIM(RTRIM(vlp.ProductPanelStatusTypeName))) AS [panel_status]

,UPPER(LTRIM(RTRIM(vpp.StatusTypeName))) AS [vppSTATUSTYPENAME]
,UPPER(LTRIM(RTRIM(vpp.ProductPanelStatusTypeName))) AS [panel_status]
,UPPER(LTRIM(RTRIM(vpp.StatusTypeName))) AS [status_code] --QUPD ;WITH() ??? ,cert_provider.status_code --CAPTURE 'D' & OR 'S' (PER DIEM's & OR CLINIC SPECIALIST)

x see 'STEP88_REVIEW_PROVDIR_'...sql

--WHERE UPPER(LTRIM(RTRIM(vlspharmtype.ServiceCategoryTypeName))) LIKE '%MO%' 
WHERE UPPER(LTRIM(RTRIM(EntityName))) LIKE '%MED%IMPA%' --PROVDIR_PHARM
	AND UPPER(LTRIM(RTRIM(vpl.LocationTypeName))) LIKE '%PRACTI%'
	AND vp.Archived IN ('N') --WITH eVIPS LOGICAL BINARY OPTION(s) IN USE •	Must not be archived 
	 AND (vp.PracticeStatus IN ('ACTIVE','CONTRACTED','NA') --•	Contract Status must be Active
		 OR vp.PracticeStatus IS NULL)
	 AND (vp.ApplicationStatus IN ('ACTIVE','CONTRACTED','NA') --•	Application Status must be contractedarchived
		 OR vp.ApplicationStatus IS NULL)		
	 AND vpl.Archived IN ('N') --WITH eVIPS LOGICAL BINARY OPTION(s) IN USE •	Must not be archived
	AND UPPER(LTRIM(RTRIM(vlp.InDirectory))) = 'Y' 

WHERE SUBSTRING(UPPER(LTRIM(RTRIM(vpl.TwentyFourHourCoverage))),1,1) IN ('Y') --PROVDIR_CLINIC
	AND vp.PracticeTypeName LIKE '%COMM%CLIN%' -- ,UPPER(LTRIM(RTRIM(vp.PracticeTypeName))) AS [plan_type]
	--AND UPPER(LTRIM(RTRIM(vp.PracticeTypeName))) LIKE '%PRACT%'
	--AND UPPER(LTRIM(RTRIM(vpl.LocationTypeName))) LIKE '%PRACT%'
	AND vp.Archived IN ('N') --WITH eVIPS LOGICAL BINARY OPTION(s) IN USE •	Must not be archived 
	AND (vp.PracticeStatus IN ('ACTIVE','CONTRACTED','NA') --•	Contract Status must be Active
		OR vp.PracticeStatus IS NULL)
	AND (vp.ApplicationStatus IN ('ACTIVE','CONTRACTED','NA') --•	Application Status must be contractedarchived
		OR vp.ApplicationStatus IS NULL)		
	AND vpl.Archived IN ('N') --WITH eVIPS LOGICAL BINARY OPTION(s) IN USE •	Must not be archived
	--AND LTRIM(RTRIM(ISNULL(UPPER(LTRIM(RTRIM(vlp.InDirectory))),''))) LIKE '%Y%'  








'PHARM ISSUE(s)' - Good morning,  I’m working from home today.  Sinuses are reeking havoc.  I would like to spend as much time as needed today to finish eVIPs directory. 

1)	The numbers for VSP are increasing and will be done by today.

2)	I looked at the Hospital numbers and see a lot of items in there that do not have the plan product specialties and hospital.  Here are a few in question.  I know we need to split about 10 more multiple DBAs, but my numbers are a closer match.  I only show one Palomar health – downtown and one palomar medical center with the plans specialty of hospital.

3)	The last area is the 'pharmacy'.  We are conducting our 100% review and using the plans, the numbers for pharmacies are too high.  Let’s discuss.

SELECT DISTINCT LocationID,PracticeID,ClassOrCategory, ServiceTypeName,ServiceCategoryTypeName,code1,code2 FROM eVips_chgcv.dbo.vwLocationServices WHERE UPPER(LTRIM(RTRIM(ServiceTypeName))) LIKE '%PHARM%TYPE%' AND ServiceCategoryTypeName IS NOT NULL AND UPPER(LTRIM(RTRIM(ServiceCategoryTypeName))) != '' AND ServiceCategoryTypeName LIKE '%MO%' 

WHERE UPPER(LTRIM(RTRIM(vlspharmtype.ServiceCategoryTypeName))) LIKE '%MO%'  --MAIL ORDER PHARMACY(-ies)
	-- AND vp.Archived IN ('N') --WITH eVIPS LOGICAL BINARY OPTION(s) IN USE •	Must not be archived 
	 -- AND (vp.PracticeStatus IN ('ACTIVE','CONTRACTED','NA') --•	Contract Status must be Active
		 -- OR vp.PracticeStatus IS NULL)
	 -- AND (vp.ApplicationStatus IN ('ACTIVE','CONTRACTED','NA') --•	Application Status must be contractedarchived
		 -- OR vp.ApplicationStatus IS NULL)		
	 -- AND vpl.Archived IN ('N') --WITH eVIPS LOGICAL BINARY OPTION(s) IN USE •	Must not be archived
	 
		-- LEFT JOIN (SELECT DISTINCT PracticeID,ClassOrCategory, ServiceTypeName,ServiceCategoryTypeName FROM eVips_chgcv.dbo.vwLocationServices WHERE ServiceTypeName LIKE '%PHARMACY%' AND ServiceCategoryTypeName IS NOT NULL AND UPPER(LTRIM(RTRIM(ServiceCategoryTypeName))) != '') AS vlspharm ON vlspharm.PracticeID = vp.PracticeID --DEFINE PHARM SUBSET CHAPTER(s) 

		LEFT JOIN (SELECT DISTINCT LocationID,PracticeID,ClassOrCategory, ServiceTypeName,ServiceCategoryTypeName,code1,code2 FROM eVips_chgcv.dbo.vwLocationServices WHERE UPPER(LTRIM(RTRIM(ServiceTypeName))) LIKE '%PHARM%TYPE%' AND ServiceCategoryTypeName IS NOT NULL AND UPPER(LTRIM(RTRIM(ServiceCategoryTypeName))) != '') AS vlspharmtype ON vlspharm.PracticeID = vp.PracticeID --DEFINE PHARM TYPE(s)

		LEFT JOIN (SELECT DISTINCT LocationID,PracticeID,ClassOrCategory, ServiceTypeName,ServiceCategoryTypeName,code1,code2 FROM eVips_chgcv.dbo.vwLocationServices WHERE UPPER(LTRIM(RTRIM(ServiceTypeName))) LIKE '%PHARM%SERV%' AND ServiceCategoryTypeName IS NOT NULL AND UPPER(LTRIM(RTRIM(ServiceCategoryTypeName))) != '') AS vlspharmservice ON vlspharm.PracticeID = vp.PracticeID --DEFINE PHARM TYPE(s)
		
-- ,CAST(NULL AS nvarchar(255)) AS [Pharmacy Type(s)]  --QUPD ;WITH() ??? ,UPPER(LTRIM(RTRIM(address.userdef_2))) AS [Pharmacy Type(s)] --,UPPER(LTRIM(RTRIM(address.userdef_2))) AS [Accessibility Category(ies)]
,UPPER(LTRIM(RTRIM(vlspharmtype.ServiceCategoryTypeName))) AS [Pharmacy Type(s)]
,UPPER(LTRIM(RTRIM(vlspharmtype.PracticeID))) AS [vlspharmtypePHARMACYPRACTICEID]
,UPPER(LTRIM(RTRIM(vlspharmtype.ClassOrCategory))) AS [vlspharmtypePHARMACYCLASS]
,UPPER(LTRIM(RTRIM(vlspharmtype.ServiceTypeName))) AS [vlspharmtypePHARMACYSERVICETYPE]
,UPPER(LTRIM(RTRIM(vlspharmtype.ServiceCategoryTypeName))) AS [vlspharmtypePHARMACYTYPENAME]
-- ,CAST(NULL AS nvarchar(255)) AS [Pharmacy Footnote(s)]  --QUPD ;WITH() ???,UPPER(LTRIM(RTRIM(address.npi_subpart))) AS [Pharmacy Footnote(s)]
,UPPER(LTRIM(RTRIM(vlspharmservice.ServiceCategoryTypeName))) AS [Pharmacy Footnote(s)]
,CAST(NULL AS nvarchar(255)) AS [npi_subpart]  --QUPD ;WITH() ??? ,address.npi_subpart
,UPPER(LTRIM(RTRIM(vlspharmservice.PracticeID))) AS [vlspharmservicePHARMACYPRACTICEID]
,UPPER(LTRIM(RTRIM(vlspharmservice.ClassOrCategory))) AS [vlspharmservicePHARMACYCLASS]
,UPPER(LTRIM(RTRIM(vlspharmservice.ServiceTypeName))) AS [vlspharmservicePHARMACYSERVICETYPE]
,UPPER(LTRIM(RTRIM(vlspharmservice.ServiceCategoryTypeName))) AS [vlspharmservicePHARMACYTYPENAME]	

					SELECT * FROM INFORMATICS.dbo.TimelyAccessPHARM

WHERE vp.Archived IN ('N') --WITH eVIPS LOGICAL BINARY OPTION(s) IN USE •	Must not be archived 
	 AND (vp.PracticeStatus IN ('ACTIVE','CONTRACTED','NA') --•	Contract Status must be Active
		 OR vp.PracticeStatus IS NULL)
	 AND (vp.ApplicationStatus IN ('ACTIVE','CONTRACTED','NA') --•	Application Status must be contractedarchived
		 OR vp.ApplicationStatus IS NULL)		
	--AND UPPER(LTRIM(RTRIM(vp.PracticeTypeName))) LIKE '%FACILIT%'
	 AND vpl.Archived IN ('N') --WITH eVIPS LOGICAL BINARY OPTION(s) IN USE •	Must not be archived
	 
AND 
( --INITIATE ...
UPPER(LTRIM(RTRIM(vea.EntityName))) LIKE '%MED%IMPA%' --AFFIRMATIVE --,vea.TableName,vea.EntityCode,vea.EntityName,vea.EntityTypeCode,vea.EntityTypeName
	AND (vp.PracticeTypeName IS NULL --FAC(s) ;WITH() ,UPPER(LTRIM(RTRIM(vp.PracticeTypeName))) AS [plan_type]
		OR UPPER(LTRIM(RTRIM(vp.PracticeTypeName))) NOT IN ('COMMUNITY CLINIC')) --see 'TimelyAccessCLINIC' --,UPPER(LTRIM(RTRIM(vp.PracticeTypeName))) AS [plan_type] 1003162868
	--OR vlspharmPHARMACYTYPENAME IS NOT NULL
	AND vpl.LocationTypeName LIKE '%PRACTI%'
) --CONCLUDE ...
	--AND LTRIM(RTRIM(vpl.NationalProviderID)) IN ('1164437406','1356325583') --PROVDIR_VSP
	AND UPPER(LTRIM(RTRIM(vlspharm.ServiceCategoryTypeName))) LIKE '%MO%'


Here is my simple query to look at all of the non-pharmacy facilities.  The query is the same for pharmacies except the service name is pharmacy.

not ({vwLocationProducts.LocationName} like "*inactive*") and
not ({vwLocationProductServices.ServiceTypeName} in ["Pharmacy"]) and
{vwPracticeLocations.LocationTypeName} startswith "Practice" and
{vwLocationProducts.StatusTypeName} startswith "Active" and
{vwLocationProducts.Archived} = "N"

,UPPER(LTRIM(RTRIM(vlspharm.PracticeID))) AS [vlspharmPHARMACYPRACTICEID]
,UPPER(LTRIM(RTRIM(vlspharm.ClassOrCategory))) AS [vlspharmPHARMACYCLASS]
,UPPER(LTRIM(RTRIM(vlspharm.ServiceTypeName))) AS [vlspharmPHARMACYSERVICETYPE]
,UPPER(LTRIM(RTRIM(vlspharm.ServiceCategoryTypeName))) AS [vlspharmPHARMACYTYPENAME]

		LEFT JOIN (SELECT DISTINCT PracticeID,ClassOrCategory, ServiceTypeName,ServiceCategoryTypeName FROM eVips_chgcv.dbo.vwLocationServices WHERE ServiceTypeName LIKE '%PHARMACY%' AND PracticeTypeName LIKE '%PRACTI%') AS vlspharm ON vlspharm.PracticeID = vp.PracticeID --DEFINE PHARM SUBSET CHAPTER(s) 

					SELECT * FROM ##PHARMtype
					SELECT * FROM ##PHARMfootnote	

		LEFT JOIN (SELECT DISTINCT PracticeID,ClassOrCategory, ServiceTypeName,ServiceCategoryTypeName FROM eVips_chgcv.dbo.vwLocationServices WHERE ServiceTypeName LIKE '%PHARMACY%' AND PracticeTypeName LIKE '%PRACTI%') AS vlspharm ON vlspharm.PracticeID = vp.PracticeID --DEFINE PHARM SUBSET CHAPTER(s) 
	
	SELECT * FROM eVips_chgcv.dbo.vwLocationServices WHERE ServiceTypeName LIKE '%PHARMACY%'
	
-- INTO INFORMATICS.dbo.TimelyAccessPHARM
SELECT vlspharmPHARMACYTYPENAME,[Pharmacy Type(s)],* --CHECK 1st
--SELECT * FROM eVips_chgcv.dbo.vwEntityAssignments WHERE UPPER(LTRIM(RTRIM(TableName))) LIKE '%Practice%' AND UPPER(LTRIM(RTRIM(EntityName))) LIKE '%MED%IMPA%'
--SELECT DISTINCT [DEGREE DESCRIPTION] --CHECK 1st
--SELECT DISTINCT [Pharmacy Type(s)],[Pharmacy Name],Address --CHECK 1st
--SELECT DISTINCT plan_type --CHECK 1st
--SELECT DISTINCT [Type of Service] --CHECK 1st ,UPPER(LTRIM(RTRIM(vpl.PracticeTypeName)))AS [Type of Service] --,'Free Standing - Primary and/or Specialty Care' AS [Type of Service]
FROM ##INNETWORK_FAC
WHERE
( --INITIATE ...
UPPER(LTRIM(RTRIM(EntityName))) LIKE '%MED%IMPA%' --AFFIRMATIVE --,vea.TableName,vea.EntityCode,vea.EntityName,vea.EntityTypeCode,vea.EntityTypeName
	AND (plan_type IS NULL --FAC(s) ;WITH() ,UPPER(LTRIM(RTRIM(vp.PracticeTypeName))) AS [plan_type]
		OR UPPER(LTRIM(RTRIM(plan_type))) NOT IN ('COMMUNITY CLINIC')) --see 'TimelyAccessCLINIC' --,UPPER(LTRIM(RTRIM(vp.PracticeTypeName))) AS [plan_type] 1003162868
	--OR vlspharmPHARMACYTYPENAME IS NOT NULL
	AND vplLOCATIONTYPENAME LIKE '%PRACTI%'
) --CONCLUDE ...
----------------OR UPPER(LTRIM(RTRIM([Pharmacy Name])))  LIKE '%PHARM%'
----------------OR UPPER(LTRIM(RTRIM(NPIis))) IN ('1003162868','1003822305','1003925520','1013252626','1013265081','1013359462','1013951375','1013953801','1023033628','1023255361','1033136361','1033228556','1043253214','1043254402','1043346190','1043380959','1043603780','1043665425','1053354803','1053378760','1053490797','1053646265','1063454882','1063468437','1063527216','1063671535','1073530200','1073544888','1073707683','1073807434','1073879490','1073946489','1083645899','1083659981','1083786867','1083941637','1093795577','1104216571','1104217165','1104855139','1104860469','1104861095','1104869437','1104935550','1104936715','1114968021','1124053111','1124062476','1124220926','1124262316','1134141047','1134336928','1134528425','1144235151','1144247552','1144261058','1144333469','1144455957','1144574260','1154306231','1154336485','1154350106','1154350197','1154362028','1154366953','1154494987','1154764769','1164437406','1164451118','1164465332','1174569784','1174702484','1174802961','1174853113','1174988901','1184063471','1184646879','1184653198','1184997835','1194731489','1194760090','1194760199','1205008299','1205853629','1205925989','1205945680','1215187521','1215269022','1215962204','1215983861','1225067275','1225074818','1225075971','1225084759','1225147671','1225148828','1235145525','1235156647','1235170234','1235241225','1235280223','1235296583','1245251297','1245257708','1245259282','1245264175','1245273010','1245286954','1245376862','1245676667','1255644357','1265459499','1265474084','1265488266','1265864078','1275549578','1275562282','1275576001','1275577009','1275578171','1275643041','1275835332','1275884736','1285600072','1285670893','1285675199','1285676015','1285676858','1285679183','1295054716','1295085017','1295750891','1295752541','1295804144','1295844629','1295890473','1306005079','1306075890','1306880653','1306882931','1306956958','1316194525','1316227572','1316264559','1316964737','1316968399','1316976368','1316983927','1326077363','1326081191','1326152661','1326297839','1336180207','1336258821','1346267572','1346593118','1356325583','1356363048','1356450704','1356570170','1366458663','1366471377','1366487266','1376558650','1376559666','1376585190','1376933820','1386650679','1386688653','1396788147','1396944161','1396975975','1407216732','1407885452','1407938285','1417026758','1417932807','1417995655','1427004894','1427093327','1427206424','1427306489','1437538691','1447267380','1447292271','1447293030','1447371208','1447576699','1447591110','1457330300','1457395287','1457396350','1457397515','1457521239','1457527145','1467467746','1467496737','1467497354','1467498527','1467536326','1477570729','1477597748','1477738359','1487763843','1487849246','1487900429','1487949319','1497778773','1497797690','1497798755','1497865091','1497938336','1508094558','1508802109','1508807504','1508812520','1508877002','1508970849','1518072545','1518300532','1518900307','1518982115','1528480613','1538103361','1538278965','1538279138','1548204373','1548205446','1548269533','1548282247','1548423601','1558307611','1558781005','1568571990','1568608214','1568721355','1568896280','1578764023','1588607337','1588697155','1588734123','1588751945','1588752687','1588774194','1588776579','1588816474','1598133829','1598143133','1598703647','1598706400','1598773566','1598786576','1598874950','1598874968','1598874984','1598875197','1609116649','1609201706','1609817576','1609985043','1609986207','1619080942','1619343357','1619912417','1619982626','1619994845','1629010442','1629086830','1629171038','1629285382','1629296041','1629357355','1629473988','1639115793','1639184914','1639567605','1649216706','1649307802','1649356650','1649639089','1649655267','1649695800','1659312577','1659315901','1659436079','1659673739','1669509824','1669581948','1669617734','1669779435','1679510176','1689043002','1689610214','1689674889','1689705873','1689741175','1699716696','1700214046','1700803939','1700822343','1700891710','1700967155','1710097316','1710902317','1710904958','1710998190','1730195025','1730234493','1730273582','1730432469','1740214790','1740227289','1740227727','1750322665','1750399739','1750599684','1760407365','1760472716','1760850010','1770527020','1770529778','1770692162','1780613737','1780627042','1780690073','1780849588','1780966507','1790100642','1790189223','1790726669','1790734036','1790783025','1790790707','1790894244','1790928810','1801256789','1801802103','1801813035','1801906409','1811048069','1821017096','1821118910','1821249327','1821395609','1831130756','1831133271','1831398676','1831546464','1841205127','1841309218','1841309366','1851302368','1851318182','1851400287','1851430805','1851593560','1861435125','1861438921','1861484214','1871571307','1871693796','1881631703','1881704435','1881727634','1881977833','1891724811','1891741898','1891804332','1891826145','1891876249','1891942108','1891982096','1902104367','1902235047','1902811284','1902828502','1912016437','1912922519','1912942814','1912942913','1922041706','1922043819','1932124534','1932126265','1932218211','1932218393','1932332343','1932485307','1932547874','1952322935','1952328270','1952345316','1952429821','1962429381','1962511436','1962511451','1962512566','1962517995','1962730044','1962753061','1962809780','1962957514','1982626677','1982633921','1992720593','1992727697','1992816094','1992956700') --ATTEMPT TO MIMIC VIP LOGIC ...

					--SELECT * FROM INFORMATICS.dbo.TimelyAccessPHARM
					
SELECT DISTINCT [Pharmacy Type(s)],[Pharmacy Footnote(s)] FROM INFORMATICS.dbo.TimelyAccessPHARM

--------------------------------------------------------------------------------------------------------------------
	-- Error Trapping: Check If Permanent Table(s) Already Exist(s) And Drop If Applicable --
--------------------------------------------------------------------------------------------------------------------
IF OBJECT_ID('TempDB..##PHARMtype') IS NOT NULL
BEGIN

		DROP TABLE ##PHARMtype --#TableName is a local temporary table visible only in the current session; ##TableName is a global temporary table visible to all sessions IN ('tempdb')

END

SELECT DISTINCT LocationID,PracticeID,ClassOrCategory, ServiceTypeName,ServiceCategoryTypeName,code1,code2
INTO ##PHARMtype
--SELECT * --CHECK 1st
--SELECT DISTINCT code1,code2,ServiceCategoryTypeName
FROM eVips_chgcv.dbo.vwLocationServices --LEFT JOIN (SELECT DISTINCT PracticeID,ClassOrCategory, ServiceTypeName,ServiceCategoryTypeName FROM eVips_chgcv.dbo.vwLocationServices WHERE ServiceTypeName LIKE '%PHARMACY%' AND PracticeTypeName LIKE '%PRACTI%') AS vlspharm ON vlspharm.PracticeID = vp.PracticeID --DEFINE PHARM SUBSET CHAPTER(s) 
WHERE UPPER(LTRIM(RTRIM(ServiceTypeName))) LIKE '%PHARM%TYPE%'
	-- AND UPPER(LTRIM(RTRIM(PracticeTypeName))) LIKE '%PRACTI%'
	AND ServiceCategoryTypeName IS NOT NULL
	AND UPPER(LTRIM(RTRIM(ServiceCategoryTypeName))) != ''

					--SELECT * FROM ##PHARMtype

--------------------------------------------------------------------------------------------------------------------
	-- Error Trapping: Check If Permanent Table(s) Already Exist(s) And Drop If Applicable --
--------------------------------------------------------------------------------------------------------------------
IF OBJECT_ID('TempDB..##PHARMfootnote') IS NOT NULL
BEGIN

		DROP TABLE ##PHARMfootnote --#TableName is a local temporary table visible only in the current session; ##TableName is a global temporary table visible to all sessions IN ('tempdb')

END

SELECT DISTINCT LocationID,PracticeID,ClassOrCategory, ServiceTypeName,ServiceCategoryTypeName,code1,code2
INTO ##PHARMfootnote
--SELECT * --CHECK 1st
--SELECT DISTINCT code1,code2,ServiceCategoryTypeName
FROM eVips_chgcv.dbo.vwLocationServices --LEFT JOIN (SELECT DISTINCT PracticeID,ClassOrCategory, ServiceTypeName,ServiceCategoryTypeName FROM eVips_chgcv.dbo.vwLocationServices WHERE ServiceTypeName LIKE '%PHARMACY%' AND PracticeTypeName LIKE '%PRACTI%') AS vlspharm ON vlspharm.PracticeID = vp.PracticeID --DEFINE PHARM SUBSET CHAPTER(s) 
WHERE UPPER(LTRIM(RTRIM(ServiceTypeName))) LIKE '%PHARM%SERV%'
	-- AND UPPER(LTRIM(RTRIM(PracticeTypeName))) LIKE '%PRACTI%'
	AND ServiceCategoryTypeName IS NOT NULL
	AND UPPER(LTRIM(RTRIM(ServiceCategoryTypeName))) != ''

					--SELECT * FROM ##PHARMfootnote
					
-- ===================================================================
	--CMC PHARM chapter(s) AND footnote(s)--
-- ===================================================================
UPDATE ##INNETWORK_FAC
SET [Pharmacy Type(s)] = UPPER(LTRIM(RTRIM(qupd.ServiceCategoryTypeName)))
--SELECT * --CHECK 1st
FROM ##INNETWORK_FAC AS inet
	JOIN ##PHARMtype AS qupd ON UPPER(LTRIM(RTRIM(qupd.PracticeID))) = UPPER(LTRIM(RTRIM(inet.PracticeID)))
		--AND UPPER(LTRIM(RTRIM(qupd.LocationID))) = UPPER(LTRIM(RTRIM(inet.LocationID)))
WHERE [Pharmacy Type(s)] IS NULL --,UPPER(LTRIM(RTRIM(vlspharm.ServiceCategoryTypeName))) AS [Pharmacy Type(s)]  --QUPD ;WITH() ??? ,UPPER(LTRIM(RTRIM(address.userdef_2))) AS [Pharmacy Type(s)]

					UPDATE ##INNETWORK_FAC
					SET [Pharmacy Type(s)] = 'R,CLNC,MBR'
					-- SELECT * --CHECK 1st
					FROM ##INNETWORK_FAC
					WHERE [Pharmacy Type(s)] = 'CLNC,MBR'

					UPDATE ##INNETWORK_FAC
					SET [Pharmacy Type(s)] = 'R,CP'
					-- SELECT * --CHECK 1st
					FROM ##INNETWORK_FAC
					WHERE [Pharmacy Type(s)] = 'CP'

					UPDATE ##INNETWORK_FAC
					SET [Pharmacy Type(s)] = 'R,CP,MBR'
					-- SELECT * --CHECK 1st
					FROM ##INNETWORK_FAC
					WHERE [Pharmacy Type(s)] = 'CP,MBR'

					UPDATE ##INNETWORK_FAC
					SET [Pharmacy Type(s)] = 'HI'
					-- SELECT * --CHECK 1st
					FROM ##INNETWORK_FAC
					WHERE [Pharmacy Type(s)] = 'HT'

UPDATE ##INNETWORK_FAC
SET [Pharmacy Footnote(s)] = UPPER(LTRIM(RTRIM(qupd.ServiceCategoryTypeName)))
--SELECT * --CHECK 1st
FROM ##INNETWORK_FAC AS inet
	JOIN ##PHARMfootnote AS qupd ON UPPER(LTRIM(RTRIM(qupd.PracticeID))) = UPPER(LTRIM(RTRIM(inet.PracticeID)))
		--AND UPPER(LTRIM(RTRIM(qupd.LocationID))) = UPPER(LTRIM(RTRIM(inet.LocationID)))
WHERE [Pharmacy Footnote(s)] IS NULL

4)	We will also be done with the community clinics today.







'LAB CHAPTER MISSING' - see PROVDIR_LAB 

x NO APPLICABLE [Participating Network](s) aka LOB(s)

--SELECT * FROM eVips_chgcv.dbo. --CHECK 1st
SELECT DISTINCT UPPER(LTRIM(RTRIM(vpl.LocationName))),UPPER(LTRIM(RTRIM(vpl.LineNumber1)))  --CHECK 1st
FROM eVips_chgcv.dbo.vwPractices AS vp
	JOIN eVips_chgcv.dbo.vwPracticeLocations AS vpl ON vpl.PracticeID = vp.PracticeID
		LEFT JOIN (SELECT DISTINCT PracticeID,ClassOrCategory, ServiceTypeName,ServiceCategoryTypeName FROM eVips_chgcv.dbo.vwLocationServices WHERE ServiceTypeName LIKE '%GROUP%SPEC%') AS vls ON vls.PracticeID = vp.PracticeID --DEFINE FAC CHAPTER(s) 
		LEFT JOIN (SELECT DISTINCT PracticeID,ServiceCategoryTypeName FROM eVips_chgcv.dbo.vwLocationServices WHERE ServiceTypeName LIKE '%PHARMACY%') AS vlspharm ON vlspharm.PracticeID = vp.PracticeID --DEFINE PHARM SUBSET CHAPTER(s) 
		LEFT JOIN (SELECT DISTINCT PracticeID,Code1,Code2,ServiceTypeName,ServiceCategoryTypeName FROM eVips_chgcv.dbo.vwLocationServices WHERE ServiceTypeName LIKE '274%TYPE%SERV%') AS vlsfocus ON vlsfocus.PracticeID = vp.PracticeID --Alt EFFORT TO DEFINE FAC CHAPTER(s)
		LEFT JOIN (SELECT DISTINCT ProviderID,TableName,EntityCode,EntityName,EntityTypeCode,EntityTypeName FROM eVips_chgcv.dbo.vwEntityAssignments WHERE TableName LIKE '%PRACTI%') AS vea ON vea.ProviderID = vp.PracticeID
		LEFT JOIN (SELECT DISTINCT ljvlp.PracticeID,ljvlp.Locationid,ljvlp.Archived,ljvlp.StatusTypeName,vlpstype.ServiceTypeName,ljvlp.productname,ljvlp.ProductPanelStatusTypeName,ljvlp.ProductPanelStatusTypeCode,ljvlp.ProviderNumber,ljvlp.Focus,ljvlp.ProductID FROM eVips_chgcv.dbo.vwLocationProducts AS ljvlp LEFT JOIN evips_chgcv.dbo.vwLocationProductServices AS vlpstype ON vlpstype.LocationProductRecID = ljvlp.LocationProductRecID WHERE (ljvlp.Archived IN ('N') OR ljvlp.Archived IS NULL) AND (ljvlp.StatusTypeName IN ('ACTIVE') OR ljvlp.StatusTypeName LIKE '%PARTICIP%' OR ljvlp.StatusTypeName IS NULL) AND (vlpstype.Archived IN ('N') OR vlpstype.Archived IS NULL)) AS vlp ON vlp.PracticeID = vpl.PracticeID --'YOUNG LADY LAURA GAH ID WHERE p.archived = 'N' AND s.ServiceTypeName = 'HOSPITAL' AND p.focus like '%GAH%'' ON 20171120 see ,UPPER(LTRIM(RTRIM(vlp.ServiceTypeName))) AS [vlpSERVICETYPENAME]
			--AND vlp.LocationID = vpl.LocationID
		LEFT JOIN INFORMATICS.dbo.ZIP_CODES AS zip ON SUBSTRING(LTRIM(RTRIM(zip.ZipCode)),1,5) COLLATE DATABASE_DEFAULT = CASE
WHEN SUBSTRING(LTRIM(RTRIM(vpl.ZipCode)),1,1) = '0'
THEN '0'+ SUBSTRING(LTRIM(RTRIM(vpl.ZipCode)),2,4)
WHEN SUBSTRING(LTRIM(RTRIM(vpl.ZipCode)),1,1) = '00'
THEN '00'+ SUBSTRING(LTRIM(RTRIM(vpl.ZipCode)),3,3)
ELSE  SUBSTRING(LTRIM(RTRIM(vpl.ZipCode)),1,5) 
END			

WHERE LTRIM(RTRIM(vpl.NationalProviderID)) IN ('1366479099') -- OR LTRIM(RTRIM(spe.NPIis)) IN ('1366479099') --WHERE LTRIM(RTRIM([Type of Service])) = 'CL'
	--OR UPPER(LTRIM(RTRIM(vpl.LocationName))) LIKE '%QUEST%'
	
--WHERE UPPER(LTRIM(RTRIM(vp.PracticeID))) IN ('4107796') --UPPER(LTRIM(RTRIM(vp.PracticeID))) AS 'lookup_key' ALVARADO HOSPITAL aka 'GAH'

SELECT * FROM INFORMATICS.dbo.ZIP_CODES

WHERE LTRIM(RTRIM(vpl.NationalProviderID)) IN ('1366479099') -- OR LTRIM(RTRIM(spe.NPIis)) IN ('1366479099') --WHERE LTRIM(RTRIM([Type of Service])) = 'CL'
	OR  UPPER(LTRIM(RTRIM(vp.PracticeID))) IN ('4107796') --UPPER(LTRIM(RTRIM(vp.PracticeID))) AS 'lookup_key' ALVARADO HOSPITAL aka 'GAH'







'HOSP PRIV ARCHIVE'(d) - Hi,  Here are a couple of items to be adjusted for the directory.

					see AND UPPER(LTRIM(RTRIM(vpa.PractitionerID))) IN ('4362625','4368221')
					SELECT * FROM INFORMATICS.dbo.PROVDIR_PCP WHERE lookup_key IN ('4362625','4368221')
					SELECT * FROM ##HOSPpriv WHERE lookup_key IN ('4362625','4368221')

DELETE
-- SELECT 'REINSERT DELETE - POST GO LIVE ON "20171215"' AS [NOTE(s)],* --CHECK 1st SELECT 'REINSERT DELETE - POST GO LIVE ON ''20171215''' [SINGLE QUOTE](s)
-- SELECT * --CHECK 1st
-- SELECT DISTINCT HOSPNM,HOSPABBREV FROM ##HOSPpriv ORDER BY HOSPNM --CHECK 1st
FROM ##HOSPpriv
WHERE (HOSPNPI IS NULL --,UPPER(LTRIM(RTRIM(addr.npi))) AS HOSPNPI
	OR HOSPNM IS NULL
	-- OR [USE_HOSPITALIST]  IS NOT NULL
	OR [USE_HOSPITALIST] IN ('Y')) --USE  IN ('Y') TO RETAIN DIRECT HOSPPRIV ONLY WITHIN PROVIDER DIRECTORY / USE 'B' TO RETAIN EITHER OPTION FOR NETWORK ADEQUACY REPORT(s) seeSELECT  DISTINCT 'N' AS [USE_HOSPITALIST] ...	
	AND lookup_key IN ('4362625','4368221')	

Practitioner Hospital Privileges
					1)	Q148188               Alb privileges are archived in VIPs & eVIPs, but shows on the eVIPs directory.  Please add the code to show if archived = N.

x 'ALB	SIMONA lookup_key = 4362625'	

					2)	Q152633               Aljawadi does not have privileges.  None should show.  Please make sure  like in some network reports that you are not pulling the privileges for the covering provider.

x 'ALJAWADI	GEORGIA lookup_key = 4368221'

Thanks!

Sandra Coleman, MBA, Credentialing Manager
Community Health Group
2420 Fenton Street, Suite 100, Chula Vista CA 91914
619 498 6438 phone
619 382 1211 fax
scolem@chgsd.com

-- ===================================================================
	--'eVIPS' CHECK ;WITH() ME HOSP Privileges Source Application--
-- ===================================================================
------------------------------------------------------------------------------------------------------------------------
	-- Error Trapping: Check If Permanent Table(s) Already Exist(s) And Drop If Applicable --
------------------------------------------------------------------------------------------------------------------------
IF OBJECT_ID('TempDB..#COVER_FOR_NO_COVG') IS NOT NULL
BEGIN

		DROP TABLE #COVER_FOR_NO_COVG

END

SELECT DISTINCT UPPER(LTRIM(RTRIM(CAST(vpcp.LastName AS nvarchar(255))))) AS ORIGINALlnm
,UPPER(LTRIM(RTRIM(CAST(vpcp.FirstName AS nvarchar(255))))) AS ORIGINALfnm
,UPPER(LTRIM(RTRIM(vpcp.PractitionerID))) AS ORIGINALlkup
,UPPER(LTRIM(RTRIM(vpcp.PractitionerID))) AS 'lookup_key'
,UPPER(LTRIM(RTRIM(vpd.NationalProviderID))) AS ORIGINALnpi
----------------,vpcp.CoveringPhysicianName
----------------,SUBSTRING(UPPER(LTRIM(RTRIM(CAST(vpcp.CoveringPhysicianName AS nvarchar(255))))),1,CHARINDEX(':',UPPER(LTRIM(RTRIM(CAST(vpcp.CoveringPhysicianName AS nvarchar(255))))),1)-1) AS COVERlkup --'LOOKUP KEY!!!'
----------------,SUBSTRING(UPPER(LTRIM(RTRIM(CAST(vpcp.CoveringPhysicianName AS nvarchar(255))))),CHARINDEX(':',UPPER(LTRIM(RTRIM(CAST(vpcp.CoveringPhysicianName AS nvarchar(255))))),1)+1,255) AS COVERNM
,UPPER(LTRIM(RTRIM(CAST(vpcp.CoveringPractitionerID AS nvarchar(25))))) AS COVERlkup --'LOOKUP KEY!!!'
,UPPER(LTRIM(RTRIM(CAST(vpcp.CoveringPhysicianName AS nvarchar(255))))) AS COVERNM
INTO #COVER_FOR_NO_COVG
--SELECT * --CHECK 1st
--SELECT * FROM eVips_chgcv.dbo.vwPractitionerDemographics --CHECK 1st
--SELECT DISTINCT PracticeTypeName --CHECK 1st
--SELECT DISTINCT PracticeCoveringTypeName --CHECK 1st
FROM eVips_chgcv.dbo.vwPractitionerCoveringPhysicians AS vpcp--SUPER???
	LEFT JOIN eVips_chgcv.dbo.vwPractitionerDemographics AS vpd ON UPPER(LTRIM(RTRIM(vpd.PractitionerID))) = UPPER(LTRIM(RTRIM(vpcp.PractitionerID))) 
WHERE (UPPER(LTRIM(RTRIM(vpcp.PracticeTypeName))) LIKE 'AHP%'
	OR UPPER(LTRIM(RTRIM(vpcp.PracticeTypeName))) LIKE 'ANC%'
	OR UPPER(LTRIM(RTRIM(vpcp.PracticeTypeName))) LIKE 'HBP%'
	OR UPPER(LTRIM(RTRIM(vpcp.PracticeTypeName))) LIKE 'PCP%'
	OR UPPER(LTRIM(RTRIM(vpcp.PracticeTypeName))) LIKE 'PS%'
	OR UPPER(LTRIM(RTRIM(vpcp.PracticeTypeName))) LIKE 'SP%')
		AND UPPER(LTRIM(RTRIM(vpcp.PracticeCoveringTypeName))) LIKE '%COVER%' --'%SUPER%' -- '%COVER%' --IN ('COVER','COVERING')
		----------------AND UPPER(LTRIM(RTRIM(vpd.NationalProviderID))) IN ('1699759936')
		
					--SELECT * FROM #COVER_FOR_NO_COVG	ORDER BY ORIGINALlnm,ORIGINALfnm







-----------------------------------------------------------------------------------------------------------------------
	-- Error Trapping: Check If Permanent Table(s) Already Exist(s) And Drop If Applicable --
------------------------------------------------------------------------------------------------------------------------
IF OBJECT_ID('TempDB..##HOSPpriv') IS NOT NULL
BEGIN

		DROP TABLE ##HOSPpriv

END
 
SELECT DISTINCT 'N' AS [USE_HOSPITALIST]
,UPPER(LTRIM(RTRIM(vpa.PractitionerID))) AS 'lookup_key'
,UPPER(LTRIM(RTRIM(vpa.PractitionerID))) AS lky
,CAST(NULL AS nvarchar(25)) AS ALTlky
,UPPER(LTRIM(RTRIM(vpa.InstitutionID))) AS 'HOSP_lookup_key'
,CAST(NULL AS nvarchar(25)) AS HOSPNPI --QUPD
,UPPER(LTRIM(RTRIM(vpa.InstitutionName))) AS HOSPNM
,CAST(NULL AS nvarchar(25)) AS HOSPITAL_ID --QUPD the QNXT provid
,CAST(NULL AS nvarchar(5)) AS [HOSPABBREV] --QUPD ;WITH() USE EITHER #WCE [ABBREV] LOGIC
,CAST(NULL AS nvarchar(25)) AS [NPIhospital] --QUPD
,CAST(NULL AS nvarchar(25)) AS [CA_License] --QUPD
,UPPER(LTRIM(RTRIM(vpa.InstitutionName))) AS [company]
,CAST(NULL AS nvarchar(5)) AS [providence] --QUPD ;WITH() USE EITHER #WCE [ABBREV] LOGIC
----------------,UPPER(LTRIM(RTRIM(vpa.Archived))) AS [archive_status]
----------------,UPPER(LTRIM(RTRIM(vpa.PositionTypeName))) AS [status]
INTO ##HOSPpriv
--SELECT TOP 100 * --CHECK 1st
--SELECT DISTINCT PositionTypeName,PositionTypeCode
FROM eVips_chgcv.dbo.vwPractitionerAppointments AS vpa
	--LEFT JOIN eVips_chgcv.dbo.vwPractitionerDemographics AS vpd ON UPPER(LTRIM(RTRIM(vpd.PractitionerID))) = UPPER(LTRIM(RTRIM(vpa.PractitionerID)))
WHERE (UPPER(LTRIM(RTRIM(vpa.PositionTypeCode))) IN ('ACIVE','ACTIVE','ADMIT','ATTEND','SENIOR',' ASSOC','COURTESY','PROV','TEMP','HONORARY') 
	OR UPPER(LTRIM(RTRIM(vpa.PositionTypeName))) IN ('ACIVE','ACTIVE','ADMIT','ATTEND','SENIOR',' ASSOC','COURTESY','PROV','TEMP','HONORARY'))  --per S. Coleman via email ON 20160712 (2)	Only show active hospital affiliations with the attached (in red) statuses for practitioners.  Dr. William Pitt CRV San Diego 92120 shows 4 hospitals.  GH & SMHH are archived and should not show.)
	----------------AND (UPPER(LTRIM(RTRIM(ad.archive_status))) NOT IN ('A')
	----------------	OR UPPER(LTRIM(RTRIM(ad.archive_status))) = ''
	----------------	OR ad.archive_status IS NULL) --Per S. Coleman ON 20160809 Please review the following for this provider. Cohenmeyer  132285     SPE  92123  NPM Hosp Priv should show only SMHLJ,RCHSD,SMHE.  TH & UCSD are archived.
	AND UPPER(LTRIM(RTRIM(vpa.InstitutionName))) NOT LIKE '%INACT%'
	AND UPPER(LTRIM(RTRIM(vpa.InstitutionName))) NOT LIKE '%PEND%'
	AND UPPER(LTRIM(RTRIM(vpa.PractitionerID))) IN ('4362625','4368221')

					--SELECT * FROM ##HOSPpriv

INSERT INTO ##HOSPpriv ([USE_HOSPITALIST],lookup_key,lky)
SELECT 'N' AS [USE_HOSPITALIST]
,UPPER(LTRIM(RTRIM(cc.ORIGINALlkup))) AS lookup_key
,UPPER(LTRIM(RTRIM(cc.ORIGINALlkup))) AS lky
--SELECT * --CHECK 1st
--SELECT DISTINCT HOSPNM,HOSPABBREV FROM ##HOSPpriv ORDER BY HOSPNM --CHECK 1st
--SELECT * FROM ##HOSPpriv --CHECK 1st
FROM #COVER_FOR_NO_COVG AS cc
WHERE UPPER(LTRIM(RTRIM(cc.ORIGINALlkup))) NOT IN (SELECT DISTINCT UPPER(LTRIM(RTRIM(hp.lookup_key)))
FROM ##HOSPpriv AS hp)
	AND cc.COVERlkup IS NOT NULL
	AND LTRIM(RTRIM(cc.COVERlkup)) != ''







-- ==============================================================
	--USE W;WITH() TO DEVELOP CTE ( Common TBL Expression )--
-- ==============================================================
------------------------------------------------------------------------------------------------------------------------
	-- Error Trapping: Check If Permanent Table(s) Already Exist(s) And Drop If Applicable --
------------------------------------------------------------------------------------------------------------------------
IF OBJECT_ID('TempDB..#INITIALS') IS NOT NULL
BEGIN

		DROP TABLE #INITIALS

 END
 
;WITH INITIALS AS --;WITH() LIKE '%CREATION OF [tempdb] TABLE%'  ## FROM JL
( --INITIATE ...
SELECT lookup_key,company
,LTRIM(RTRIM(REPLACE(REPLACE(UPPER(LTRIM(RTRIM([company]))),'-',''),'(',''))) AS [FIRST_INITIAL_SOURCE]
,SUBSTRING(LTRIM(RTRIM(REPLACE(REPLACE(UPPER(LTRIM(RTRIM([company]))),'-',''),'(',''))),CHARINDEX(' ',LTRIM(RTRIM(REPLACE(REPLACE(UPPER(LTRIM(RTRIM([company]))),'-',''),'(',''))),1)+1,255) AS [SECOND_INITIAL_SOURCE] --REPLACE() / SUBSTITUTE() the [SOURCE] FROM PREVIOUS ... 
,SUBSTRING(LTRIM(RTRIM(SUBSTRING(LTRIM(RTRIM(REPLACE(REPLACE(UPPER(LTRIM(RTRIM([company]))),'-',''),'(',''))),CHARINDEX(' ',LTRIM(RTRIM(REPLACE(REPLACE(UPPER(LTRIM(RTRIM([company]))),'-',''),'(',''))),1)+1,255))),CHARINDEX(' ',LTRIM(RTRIM(SUBSTRING(LTRIM(RTRIM(REPLACE(REPLACE(UPPER(LTRIM(RTRIM([company]))),'-',''),'(',''))),CHARINDEX(' ',LTRIM(RTRIM(REPLACE(REPLACE(UPPER(LTRIM(RTRIM([company]))),'-',''),'(',''))),1)+1,255))),1)+1,255) AS [THIRD_INITIAL_SOURCE]  --REPLACE() / SUBSTITUTE() the [SOURCE] FROM PREVIOUS ... 
,SUBSTRING(LTRIM(RTRIM(SUBSTRING(LTRIM(RTRIM(SUBSTRING(LTRIM(RTRIM(REPLACE(REPLACE(UPPER(LTRIM(RTRIM([company]))),'-',''),'(',''))),CHARINDEX(' ',LTRIM(RTRIM(REPLACE(REPLACE(UPPER(LTRIM(RTRIM([company]))),'-',''),'(',''))),1)+1,255))),CHARINDEX(' ',LTRIM(RTRIM(SUBSTRING(LTRIM(RTRIM(REPLACE(REPLACE(UPPER(LTRIM(RTRIM([company]))),'-',''),'(',''))),CHARINDEX(' ',LTRIM(RTRIM(REPLACE(REPLACE(UPPER(LTRIM(RTRIM([company]))),'-',''),'(',''))),1)+1,255))),1)+1,255))),CHARINDEX(' ',LTRIM(RTRIM(SUBSTRING(LTRIM(RTRIM(SUBSTRING(LTRIM(RTRIM(REPLACE(REPLACE(UPPER(LTRIM(RTRIM([company]))),'-',''),'(',''))),CHARINDEX(' ',LTRIM(RTRIM(REPLACE(REPLACE(UPPER(LTRIM(RTRIM([company]))),'-',''),'(',''))),1)+1,255))),CHARINDEX(' ',LTRIM(RTRIM(SUBSTRING(LTRIM(RTRIM(REPLACE(REPLACE(UPPER(LTRIM(RTRIM([company]))),'-',''),'(',''))),CHARINDEX(' ',LTRIM(RTRIM(REPLACE(REPLACE(UPPER(LTRIM(RTRIM([company]))),'-',''),'(',''))),1)+1,255))),1)+1,255))),1)+1,255) AS [FOURTH_INITIAL_SOURCE]  --REPLACE() / SUBSTITUTE() the [SOURCE] FROM PREVIOUS ... 
,SUBSTRING(LTRIM(RTRIM(SUBSTRING(LTRIM(RTRIM(SUBSTRING(LTRIM(RTRIM(SUBSTRING(LTRIM(RTRIM(REPLACE(REPLACE(UPPER(LTRIM(RTRIM([company]))),'-',''),'(',''))),CHARINDEX(' ',LTRIM(RTRIM(REPLACE(REPLACE(UPPER(LTRIM(RTRIM([company]))),'-',''),'(',''))),1)+1,255))),CHARINDEX(' ',LTRIM(RTRIM(SUBSTRING(LTRIM(RTRIM(REPLACE(REPLACE(UPPER(LTRIM(RTRIM([company]))),'-',''),'(',''))),CHARINDEX(' ',LTRIM(RTRIM(REPLACE(REPLACE(UPPER(LTRIM(RTRIM([company]))),'-',''),'(',''))),1)+1,255))),1)+1,255))),CHARINDEX(' ',LTRIM(RTRIM(SUBSTRING(LTRIM(RTRIM(SUBSTRING(LTRIM(RTRIM(REPLACE(REPLACE(UPPER(LTRIM(RTRIM([company]))),'-',''),'(',''))),CHARINDEX(' ',LTRIM(RTRIM(REPLACE(REPLACE(UPPER(LTRIM(RTRIM([company]))),'-',''),'(',''))),1)+1,255))),CHARINDEX(' ',LTRIM(RTRIM(SUBSTRING(LTRIM(RTRIM(REPLACE(REPLACE(UPPER(LTRIM(RTRIM([company]))),'-',''),'(',''))),CHARINDEX(' ',LTRIM(RTRIM(REPLACE(REPLACE(UPPER(LTRIM(RTRIM([company]))),'-',''),'(',''))),1)+1,255))),1)+1,255))),1)+1,255))),CHARINDEX(' ',LTRIM(RTRIM(SUBSTRING(LTRIM(RTRIM(SUBSTRING(LTRIM(RTRIM(SUBSTRING(LTRIM(RTRIM(REPLACE(REPLACE(UPPER(LTRIM(RTRIM([company]))),'-',''),'(',''))),CHARINDEX(' ',LTRIM(RTRIM(REPLACE(REPLACE(UPPER(LTRIM(RTRIM([company]))),'-',''),'(',''))),1)+1,255))),CHARINDEX(' ',LTRIM(RTRIM(SUBSTRING(LTRIM(RTRIM(REPLACE(REPLACE(UPPER(LTRIM(RTRIM([company]))),'-',''),'(',''))),CHARINDEX(' ',LTRIM(RTRIM(REPLACE(REPLACE(UPPER(LTRIM(RTRIM([company]))),'-',''),'(',''))),1)+1,255))),1)+1,255))),CHARINDEX(' ',LTRIM(RTRIM(SUBSTRING(LTRIM(RTRIM(SUBSTRING(LTRIM(RTRIM(REPLACE(REPLACE(UPPER(LTRIM(RTRIM([company]))),'-',''),'(',''))),CHARINDEX(' ',LTRIM(RTRIM(REPLACE(REPLACE(UPPER(LTRIM(RTRIM([company]))),'-',''),'(',''))),1)+1,255))),CHARINDEX(' ',LTRIM(RTRIM(SUBSTRING(LTRIM(RTRIM(REPLACE(REPLACE(UPPER(LTRIM(RTRIM([company]))),'-',''),'(',''))),CHARINDEX(' ',LTRIM(RTRIM(REPLACE(REPLACE(UPPER(LTRIM(RTRIM([company]))),'-',''),'(',''))),1)+1,255))),1)+1,255))),1)+1,255))),1)+1,255) AS [FIFTH_INITIAL_SOURCE] --REPLACE() / SUBSTITUTE() the [SOURCE] FROM PREVIOUS ... 
FROM ##HOSPpriv
) --CONCLUDE ...
SELECT UPPER(SUBSTRING(LTRIM(RTRIM([FIRST_INITIAL_SOURCE])),1,1) --1ST INITIAL ...
+''+ 
CASE
WHEN LTRIM(RTRIM([SECOND_INITIAL_SOURCE])) = LTRIM(RTRIM([FIRST_INITIAL_SOURCE]))
THEN ''
ELSE SUBSTRING(LTRIM(RTRIM([SECOND_INITIAL_SOURCE])),1,1)--2ND INITIAL 
END
+''+ 
CASE
WHEN LTRIM(RTRIM([THIRD_INITIAL_SOURCE])) = LTRIM(RTRIM([SECOND_INITIAL_SOURCE]))
THEN ''
ELSE SUBSTRING(LTRIM(RTRIM([THIRD_INITIAL_SOURCE])),1,1) --3RD INITIAL ...
END
+''+ 
CASE
WHEN LTRIM(RTRIM([FOURTH_INITIAL_SOURCE])) = LTRIM(RTRIM([THIRD_INITIAL_SOURCE]))
THEN ''
ELSE SUBSTRING(LTRIM(RTRIM([FOURTH_INITIAL_SOURCE])),1,1) --4TH INITIAL ...
END
+''+ 
CASE
WHEN LTRIM(RTRIM([FIFTH_INITIAL_SOURCE])) = LTRIM(RTRIM([FOURTH_INITIAL_SOURCE]))
THEN ''
ELSE SUBSTRING(LTRIM(RTRIM([FIFTH_INITIAL_SOURCE])),1,1) --5TH INITIAL ...
END) AS [ABBREVIATIONis],* --NESTED()
INTO #INITIALS
--SELECT * --CHECK 1st
FROM INITIALS					

					--SELECT * FROM ##HOSPpriv

UPDATE ##HOSPpriv --,CAST(NULL AS nvarchar(5)) AS [ABBREVIATIONis]
SET [HOSPABBREV] = i.[ABBREVIATIONis] --QUPD ;WITH() USE EITHER #WCE [ABBREV] LOGIC
,[providence] = i.[ABBREVIATIONis] --QUPD ;WITH() USE EITHER #WCE [ABBREV] LOGIC
FROM ##HOSPpriv AS hp
	JOIN #INITIALS AS i ON UPPER(LTRIM(RTRIM(i.lookup_key))) = UPPER(LTRIM(RTRIM(hp.lookup_key)))
		AND UPPER(LTRIM(RTRIM(i.company))) = UPPER(LTRIM(RTRIM(hp.company)))

					--SELECT  providence,* FROM ##HOSPpriv ORDER BY company

UPDATE ##HOSPpriv
SET NPIhospital = UPPER(LTRIM(RTRIM(vf.NationalProviderID)))
--,CA_License = --???
,HOSPNPI = UPPER(LTRIM(RTRIM(vf.NationalProviderID)))
--,HOSPITAL_ID = --??? QNXT provid
--SELECT * --CHECK 1st
FROM ##HOSPpriv AS hp
JOIN eVips_chgcv.dbo.vwFacilities AS vf ON UPPER(LTRIM(RTRIM(hp.HOSPNM))) = UPPER(LTRIM(RTRIM(vf.FacilityName)))
	OR SUBSTRING(UPPER(LTRIM(RTRIM(hp.HOSPNM))),1,15) = SUBSTRING(UPPER(LTRIM(RTRIM(vf.FacilityName))),1,15)
WHERE UPPER(LTRIM(RTRIM(vf.NationalProviderID))) != '' --VAL() IS PRESENT!!!
AND NPIhospital IS NULL

UPDATE ##HOSPpriv
SET [USE_HOSPITALIST] = 'Y' --IIF() / WHEN A COVERING PROVIDER IS NEEDED TO ESTABLISH HOSP PRIV
,ALTlky = LTRIM(RTRIM(cc.COVERlkup))
--SELECT * --CHECK 1st
--SELECT LTRIM(RTRIM(hp.lookup_key)) AS hpl,LTRIM(RTRIM(cc.COVERlkup)) AS cl
FROM ##HOSPpriv AS hp
JOIN #COVER_FOR_NO_COVG AS cc ON LTRIM(RTRIM(cc.ORIGINALlkup)) COLLATE DATABASE_DEFAULT = LTRIM(RTRIM(hp.lookup_key)) COLLATE DATABASE_DEFAULT
WHERE (hp.company IS NULL
	OR UPPER(LTRIM(RTRIM(hp.company))) COLLATE DATABASE_DEFAULT LIKE '%NO%PRIVIL%'
	OR UPPER(LTRIM(RTRIM(hp.company))) COLLATE DATABASE_DEFAULT LIKE '%A%MEDIC%SAN%DIEG%'
	OR UPPER(LTRIM(RTRIM(hp.company))) COLLATE DATABASE_DEFAULT LIKE '%KAISER%'
	OR UPPER(LTRIM(RTRIM(hp.company))) COLLATE DATABASE_DEFAULT = 'NA'
	OR UPPER(LTRIM(RTRIM(hp.company))) COLLATE DATABASE_DEFAULT LIKE '%SAN%DIEG%PSYC%HOS%')
	----------------AND LTRIM(RTRIM(hp.lookup_key)) IN ('3466','20376','4158') --TEST / SAMPLE...
		AND LTRIM(RTRIM(cc.COVERlkup)) COLLATE DATABASE_DEFAULT IN (SELECT DISTINCT LTRIM(RTRIM(yes.lookup_key))
--SELECT * --CHECK 1st
--SELECT DISTINCT HOSPNM,HOSPABBREV FROM ##HOSPpriv ORDER BY HOSPNM --CHECK 1st
FROM ##HOSPpriv AS yes
WHERE yes.company IS NOT NULL
	AND UPPER(LTRIM(RTRIM(yes.company))) COLLATE DATABASE_DEFAULT NOT LIKE '%NO%PRIVIL%'
	AND UPPER(LTRIM(RTRIM(yes.company))) COLLATE DATABASE_DEFAULT NOT LIKE '%A%MEDIC%SAN%DIEG%'
	AND UPPER(LTRIM(RTRIM(yes.company))) COLLATE DATABASE_DEFAULT NOT LIKE '%KAISER%'
	AND UPPER(LTRIM(RTRIM(yes.company))) COLLATE DATABASE_DEFAULT NOT IN ('NA')
	AND UPPER(LTRIM(RTRIM(yes.company))) COLLATE DATABASE_DEFAULT NOT LIKE '%SAN%DIEG%PSYC%HOS%') --OPPOSITE OF ABOVE...







------------------------------------------------------------------------------------------------------------------------
	-- Error Trapping: Check If Permanent Table(s) Already Exist(s) And Drop If Applicable --
------------------------------------------------------------------------------------------------------------------------
IF OBJECT_ID('TempDB..#ALT_HOSPpriv') IS NOT NULL
BEGIN

		DROP TABLE #ALT_HOSPpriv

END

SELECT qupd.* --CHECK 1st
INTO #ALT_HOSPpriv
--SELECT * --CHECK 1st
FROM ##HOSPpriv	AS hp
	JOIN ##HOSPpriv AS qupd ON LTRIM(RTRIM(qupd.lookup_key)) = LTRIM(RTRIM(hp.ALTlky))
WHERE qupd.company IS NOT NULL
	AND UPPER(LTRIM(RTRIM(qupd.company))) NOT LIKE '%NO%PRIVIL%'
	AND UPPER(LTRIM(RTRIM(qupd.company))) NOT LIKE '%A%MEDIC%SAN%DIEG%'
	AND UPPER(LTRIM(RTRIM(qupd.company))) NOT LIKE '%KAISER%'
	AND UPPER(LTRIM(RTRIM(qupd.company))) NOT IN ('NA')
	AND UPPER(LTRIM(RTRIM(qupd.company))) NOT LIKE '%SAN%DIEG%PSYC%HOS%'

					UPDATE ##HOSPpriv
					SET HOSPNPI = UPPER(LTRIM(RTRIM(qupd.HOSPNPI)))
					,HOSPNM = UPPER(LTRIM(RTRIM(qupd.HOSPNM)))
					,HOSPABBREV = UPPER(LTRIM(RTRIM(qupd.HOSPABBREV)))
					,HOSPITAL_ID = UPPER(LTRIM(RTRIM(qupd.HOSPITAL_ID)))
					--SELECT qupd.* --CHECK 1st
					FROM ##HOSPpriv	AS hp
						JOIN #ALT_HOSPpriv AS qupd ON LTRIM(RTRIM(qupd.lookup_key)) = LTRIM(RTRIM(hp.ALTlky))
					WHERE qupd.company IS NOT NULL
						AND UPPER(LTRIM(RTRIM(qupd.company))) NOT LIKE '%NO%PRIVIL%'
						AND UPPER(LTRIM(RTRIM(qupd.company))) NOT LIKE '%A%MEDIC%SAN%DIEG%'
						AND UPPER(LTRIM(RTRIM(qupd.company))) NOT LIKE '%KAISER%'
						AND UPPER(LTRIM(RTRIM(qupd.company))) NOT IN ('NA')
						AND UPPER(LTRIM(RTRIM(qupd.company))) NOT LIKE '%SAN%DIEG%PSYC%HOS%'







------------------------------------------------------------------------------------------------------------------------
	-- Error Trapping: Check If Permanent Table(s) Already Exist(s) And Drop If Applicable --
------------------------------------------------------------------------------------------------------------------------
IF OBJECT_ID('TempDB..#HOSPnpiNULL') IS NOT NULL
BEGIN

		DROP TABLE #HOSPnpiNULL

END

SELECT DISTINCT HOSPNPI,HOSPNM,HOSPABBREV,HOSPITAL_ID
INTO #HOSPnpiNULL
--SELECT * --CHECK 1st
FROM ##HOSPpriv
WHERE HOSPNPI IS NOT NULL
	AND LTRIM(RTRIM(HOSPNPI)) NOT IN (' ASC','NO PRIV','NON-PAR')

					UPDATE ##HOSPpriv
					SET HOSPNPI = UPPER(LTRIM(RTRIM(hpn.HOSPNPI)))
					,HOSPABBREV  = UPPER(LTRIM(RTRIM(hpn.HOSPABBREV)))
					,HOSPITAL_ID  = UPPER(LTRIM(RTRIM(hpn.HOSPITAL_ID)))
					--SELECT * --CHECK 1st
					FROM ##HOSPpriv AS hp
						JOIN #HOSPnpiNULL AS hpn ON UPPER(LTRIM(RTRIM(hpn.HOSPNM))) = UPPER(LTRIM(RTRIM(hp.HOSPNM)))
					WHERE hp.HOSPNPI IS NULL
						OR LTRIM(RTRIM(hp.HOSPNPI)) IN (' ASC','NO PRIV','NON-PAR')

-- DELETE
SELECT 'REINSERT DELETE - POST GO LIVE ON "20171215"' AS [NOTE(s)],* --CHECK 1st SELECT 'REINSERT DELETE - POST GO LIVE ON ''20171215''' [SINGLE QUOTE](s)
--SELECT * --CHECK 1st
--SELECT DISTINCT HOSPNM,HOSPABBREV FROM ##HOSPpriv ORDER BY HOSPNM --CHECK 1st
FROM ##HOSPpriv
WHERE HOSPNPI IS NULL --,UPPER(LTRIM(RTRIM(addr.npi))) AS HOSPNPI
----------------ORDER BY HOSPNM
	-- OR [USE_HOSPITALIST]  IS NOT NULL
	OR [USE_HOSPITALIST] IN (@hospriv) --USE  IN ('Y') TO RETAIN DIRECT HOSPPRIV ONLY WITHIN PROVIDER DIRECTORY / USE 'B' TO RETAIN EITHER OPTION FOR NETWORK ADEQUACY REPORT(s) seeSELECT  DISTINCT 'N' AS [USE_HOSPITALIST]...

					SELECT * FROM #HOSPpriv WHERE lookup_key IN ('4362625','4368221')








'CLEAN UP THE GAH'(s) aka PROVDIR_HOSGENERALACUTE - SQL ... 

SELECT DISTINCT ljvlp.StatusTypeName,vlpstype.ServiceTypeName,ljvlp.Focus FROM eVips_chgcv.dbo.vwLocationProducts AS ljvlp LEFT JOIN evips_chgcv.dbo.vwLocationProductServices AS vlpstype ON vlpstype.LocationProductRecID = ljvlp.LocationProductRecID WHERE (ljvlp.Archived IN ('N') OR ljvlp.Archived IS NULL) AND (ljvlp.StatusTypeName IN ('ACTIVE') OR ljvlp.StatusTypeName LIKE '%PARTICIP%' OR ljvlp.StatusTypeName IS NULL) AND (vlpstype.Archived IN ('N') OR vlpstype.Archived IS NULL)	

		LEFT JOIN (SELECT DISTINCT ljvlp.PracticeID,ljvlp.Archived,ljvlp.StatusTypeName,vlpstype.ServiceTypeName,ljvlp.productname,ljvlp.ProductPanelStatusTypeName,ljvlp.ProductPanelStatusTypeCode,ljvlp.ProviderNumber,ljvlp.Focus,ljvlp.ProductID FROM eVips_chgcv.dbo.vwLocationProducts AS ljvlp LEFT JOIN evips_chgcv.dbo.vwLocationProductServices AS vlpstype ON vlpstype.LocationProductRecID = ljvlp.LocationProductRecID WHERE (ljvlp.Archived IN ('N') OR ljvlp.Archived IS NULL) AND (ljvlp.StatusTypeName IN ('ACTIVE') OR ljvlp.StatusTypeName LIKE '%PARTICIP%' OR ljvlp.StatusTypeName IS NULL) AND (vlpstype.Archived IN ('N') OR vlpstype.Archived IS NULL)) AS vlp ON vlp.PracticeID = vp.PracticeID --'YOUNG LADY LAURA GAH ID WHERE p.archived = 'N' AND s.ServiceTypeName = 'HOSPITAL' AND p.focus like '%GAH%'' ON 20171120 see ,UPPER(LTRIM(RTRIM(vlp.ServiceTypeName))) AS [vlpSERVICETYPENAME]

		LEFT JOIN (SELECT DISTINCT vlps.LocationID,vlps.PracticeID,vlps.ServiceTypeName,vlpB.Focus FROM eVips_chgcv.dbo.[vwLocationProducts] AS vlpB JOIN eVips_chgcv.dbo.[vwLocationProductServices] AS vlps on vlps.LocationProductRecID = vlpB.LocationProductRecID WHERE vlpB.Focus IS NOT NULL) AS tosfocus ON tosfocus.PracticeID = vp.PracticeID --YET ANOTHER Alt EFFORT TO DEFINE FAC CHAPTER(s) by 'focus'
	
		LEFT JOIN (SELECT DISTINCT vlps.LocationID,vlps.PracticeID,vlps.ServiceTypeName FROM eVips_chgcv.dbo.[vwLocationProducts] AS vlpB JOIN eVips_chgcv.dbo.[vwLocationProductServices] AS vlps on vlps.LocationProductRecID = vlpB.LocationProductRecID WHERE vlps.ServiceTypeName IS NOT NULL) AS tosname ON tosname.PracticeID = vp.PracticeID --YET ANOTHER Alt EFFORT TO DEFINE FAC CHAPTER(s) by 'ServiceTypeName'

		-- LEFT JOIN (SELECT DISTINCT vlps.LocationID,vlps.PracticeID,vlps.ServiceTypeName,vlpB.Focus FROM eVips_chgcv.dbo.[vwLocationProducts] AS vlpB JOIN eVips_chgcv.dbo.[vwLocationProductServices] AS vlps on vlps.LocationProductRecID = vlpB.LocationProductRecID WHERE vlps.ServiceTypeName = 'GROUP SPECIALTY' AND vlpB.Focus like '%GAH%') AS tos ON tos.PracticeID = vp.PracticeID --YET ANOTHER Alt EFFORT TO DEFINE FAC CHAPTER(s)
	
		-- LEFT JOIN (SELECT DISTINCT vlps.LocationID,vlps.PracticeID,vlps.ServiceTypeName,vlpB.Focus FROM eVips_chgcv.dbo.[vwLocationProducts] AS vlpB JOIN eVips_chgcv.dbo.[vwLocationProductServices] AS vlps on vlps.LocationProductRecID = vlpB.LocationProductRecID WHERE vlps.ServiceTypeName LIKE '%HOSP%' AND vlpB.Focus like '%GAH%') AS toshosp ON toshosp.PracticeID = vp.PracticeID --YET ANOTHER Alt EFFORT TO DEFINE FAC CHAPTER(s)

--SELECT * --CHECK 1st
--SELECT DISTINCT ISNULL(CAST(spe.HospitalName AS nvarchar(100)),'')+' '+ISNULL(CAST(spe.HOSPabbrev AS nvarchar(100)),'')+' ID# '+ISNULL(CAST(spe.provider_no AS nvarchar(25)),'') COLLATE DATABASE_DEFAULT AS [TESTING],HospitalName,vlpSERVICETYPENAME,plan_type,[Type of Service FOCUS],ServiceCategoryTypeName,Code1,Code2 --CHECK 1st
FROM INFORMATICS.dbo.TimelyAccessFAC AS spe
WHERE ((spe.vlpSERVICETYPENAME LIKE '%HOSPITAL%'
		OR UPPER(LTRIM(RTRIM(spe.ServiceCategoryTypeName))) LIKE '%HOSPITAL%' --LEFT JOIN (SELECT DISTINCT PracticeID,ClassOrCategory, ServiceTypeName,ServiceCategoryTypeName FROM eVips_chgcv.dbo.vwLocationServices WHERE ServiceTypeName LIKE '%GROUP%SPEC%') AS vls ON vls.PracticeID = vp.PracticeID --DEFINE FAC CHAPTER(s) 
) --CONCLUDE ...
	AND spe.plan_type = 'FACILITY'
	AND [Type of Service FOCUS] LIKE '%GAH%'
) --CONCLUDE ...







--Logic for Allied Health Chapter from eVIPs
select distinct p.practitionerid, p.LastName, p.firstname, p.ProductName, p.ProductTypeCode, s.specialtyName, s.indirectory 
from eVips_chgcv.dbo.vwPractitionerProducts p 
	LEFT JOIN eVips_chgcv.dbo.vwPractitionerProductSpecialties s on p.PractitionerProductRecID = s.PractitionerProductRecID and s.archived = 'N'
where p.productTypecode = 'AHP'
and p.archived = 'N'
and p.LocationName not like '%VSP%'
and p.StatusTypeName like 'ACTIVE%'
and s.indirectory = 'Y'
and s.SpecialtyName not like '%Psychiatry%'
and s.SpecialtyName not like '%PSYCHOLOGY%'
and s.SpecialtyName not like '%BEHAVIORAL HEALTH%'
ORDER by  p.LastName, p.firstname

	AND UPPER(LTRIM(RTRIM(spe.DefineOTH_SPE))) NOT IN ('BH','BEHAVIORAL HEALTH','GERP','APSC','CPSC','GPSC','ADP','APSY','FPSY','PSYCH','PSY','PSC','CAP') --Remove psychology providers. LIKE 'PSC%' OR LIKE '%PSY%'  AND 'BH' ADDED per S. Coleman ON 20160711 (Behavioral Health should be added to the query to include in Mental Health and exclude from Allied Health.  Now 3 specialty descriptions.  If like psychology,psychiatry and behavioral health then Mental Health and exclude physicians from specialists.  We can discuss the later part with the team.)
	
	
	
	
	
	
--SELECT * --CHECK 1st
--SELECT DISTINCT ISNULL(CAST(spe.HospitalName AS nvarchar(100)),'')+' '+ISNULL(CAST(spe.HOSPabbrev AS nvarchar(100)),'')+' ID# '+ISNULL(CAST(spe.provider_no AS nvarchar(25)),'') COLLATE DATABASE_DEFAULT AS [TESTING],HospitalName,vlpSERVICETYPENAME,plan_type,[Type of Service FOCUS],ServiceCategoryTypeName,Code1,Code2 --CHECK 1st
FROM INFORMATICS.dbo.TimelyAccessFAC AS spe
WHERE 
( -- INITIATE ...
(-- INITIATE ...
spe.vlpSERVICETYPENAME LIKE '%HOSPITAL%'
		OR UPPER(LTRIM(RTRIM(spe.ServiceTypeName))) LIKE '%HOSPITAL%' --per YOUNG LADY LAURA email ON 20171221 To determine the type of Facility we should only rely on the vwLocationProductServices.servicetypename.  This applies to other Facility Chapters. Community clinics are the exception as they are identified by locationTypeName  = ‘Practice - CC’
		OR UPPER(LTRIM(RTRIM(spe.ServiceCategoryTypeName))) LIKE '%HOSPITAL%' --LEFT JOIN (SELECT DISTINCT PracticeID,ClassOrCategory, ServiceTypeName,ServiceCategoryTypeName FROM eVips_chgcv.dbo.vwLocationServices WHERE ServiceTypeName LIKE '%GROUP%SPEC%') AS vls ON vls.PracticeID = vp.PracticeID --DEFINE FAC CHAPTER(s) 
) --CONCLUDE ...		
	AND spe.plan_type = 'FACILITY'
) --CONCLUDE ...

Hi Walter,  I am reviewing  eVIPs counts, and have some feedback:

		1.	For Facilities we need to make sure that we are excluding DBA product location records. Please add a condition to only include Locations that begin with the word “Practice”: vwLocationProducts.LocationTypeName like 'PRACTICE%' 
		
SELECT DISTINCT LocationTypeName FROM eVips_chgcv.dbo.vwPracticeLocations --REFINE GAH MORE;WITH ,UPPER(LTRIM(RTRIM(vpl.LocationTypeName))) AS [vplLOCATIONTYPENAME]

,UPPER(LTRIM(RTRIM(vp.PracticeName))) AS [DBA]
,UPPER(LTRIM(RTRIM(vpl.LocationTypeName))) AS [vplLOCATIONTYPENAME]

WHERE [vplLOCATIONTYPENAME] LIKE '%PRACTICE%'		

		 2.	In the SNF chapter, I am seeing records for Facilities that are not SNFs. For example: RADY CHILDREN'S' SPECIALISTS OF SAN DIEGO. Can you review this example. I am not sure what is causing it to show.
	
SELECT DISTINCT ServiceTypeName FROM eVips_chgcv.dbo.vwLocationProductServices
SELECT DISTINCT ServiceTypeName FROM eVips_chgcv.dbo.vwLocationServices

SELECT DISTINCT ServiceCategoryTypeName FROM eVips_chgcv.dbo.vwLocationProductServices
SELECT DISTINCT ServiceCategoryTypeName FROM eVips_chgcv.dbo.vwLocationServices

,UPPER(LTRIM(RTRIM(vlp.ServiceTypeName))) AS [vlpSERVICETYPENAME]
,vls.ServiceTypeName,vls.ServiceCategoryTypeName --DEFINE FAC CHAPTER(s) ;WITHSELECT  

		LEFT JOIN (SELECT DISTINCT PracticeID,ClassOrCategory, ServiceTypeName,ServiceCategoryTypeName FROM eVips_chgcv.dbo.vwLocationServices WHERE ServiceTypeName LIKE '%GROUP%SPEC%') AS vls ON vls.PracticeID = vp.PracticeID --DEFINE FAC CHAPTER(s) 

		3.	 For Community Clinics, we added a new flag to indicate that it should be reported in the directory:  vwPracticeLocations.TwentyFourHourCoverage = 'Y'. Can you please confirm that this field is being used.

SELECT DISTINCT TwentyFourHourCoverage FROM eVips_chgcv.dbo.vwPracticeLocations

,CASE
WHEN SUBSTRING(UPPER(LTRIM(RTRIM(vpl.TwentyFourHourCoverage))),1,1) IN ('Y') --USE THIS CASE WHEN THEN ELSE END ONLY FOR HOS / SNF
THEN '7 Days a Week, 24 Hours a Day'
ELSE UPPER(LTRIM(RTRIM(h.[Office Hour(s)])))
END AS [Office Hour(s)],vpl.TwentyFourHourCoverage		

Call me if you have questions.   Thank you, Laura Infante







SELECT DISTINCT LocationTypeName FROM eVips_chgcv.dbo.vwPracticeLocations --REFINE GAH MORE;WITH ,UPPER(LTRIM(RTRIM(vpl.LocationTypeName))) AS [vplLOCATIONTYPENAME]

,UPPER(LTRIM(RTRIM(vp.PracticeName))) AS [DBA]
,UPPER(LTRIM(RTRIM(vpl.LocationTypeName))) AS [vplLOCATIONTYPENAME]

SELECT * FROM INFORMATICS.dbo.PROVDIR_HOSGENERALACUTE	







x 'Discuss Directory Specs for Community Clinic' - ON 20171211 @1000 see 'STEP88_REVIEW_PROVDIR_'...sql
WHERE --CLINIC
( --INITIATE ...
UPPER(LTRIM(RTRIM(vp.PracticeTypeName))) IN ('COMMUNITY CLINIC') --,UPPER(LTRIM(RTRIM(vp.PracticeTypeName))) AS [plan_type] OR ,UPPER(LTRIM(RTRIM(vp.PracticeTypeName))) AS [PROVIDER_TYPEdescr] AFFIRMATIVE --,UPPER(LTRIM(RTRIM(vp.PracticeTypeName))) AS [plan_type]
	AND UPPER(LTRIM(RTRIM(vls.ServiceCategoryTypeName))) LIKE '%CLINIC%'
	AND UPPER(LTRIM(RTRIM(vea.EntityName))) NOT LIKE '%MED%IMPA%' --see 'TimelyAccessPHARM' --,vea.TableName,vea.EntityCode
	AND UPPER(LTRIM(RTRIM(vpl.LocationName))) NOT LIKE '%PHARMA%' --,UPPER(LTRIM(RTRIM(vpl.LocationName))) AS [Clinic Name]
) --CONCLUDE ...







x 'ISOLATE FOR HIV PROVIDER'(s) - BASED ON focus [FIELD] 

SELECT * FROM ##INNETWORK_PROV WHERE focus LIKE '%HIV%' OR [AREA_of_PRACTICE] LIKE '%HIV%' 
SELECT DISTINCT LastName,FirstName FROM ##INNETWORK_PROV WHERE focus LIKE '%HIV%' OR [AREA_of_PRACTICE] LIKE '%HIV%' 
SELECT CA_License,* FROM INFORMATICS.dbo.PROVDIR_SPE WHERE SPEC LIKE '%HIV%' ORDER BY CityIs,ZIP,SPEC,INDEXNM

					,CASE
					WHEN UPPER(LTRIM(RTRIM(cert_provider.focus))) LIKE @HIV
					THEN 'HIV / AIDS'
					ELSE UPPER(LTRIM(RTRIM(cert_provider.focus)))  --ADD 'DAU' to the HIV, SA cp.focus OPTION(s) per DISCUSSION(s) ON 20170320 / SA (Substance Abuse Professional - All Levels LICENSE) aka (Substance Use Disorder - SPECIALTY) per NETWORK SESSION ON 20170315
					END AS [Specialty / Subspecialty]

SELECT * --CHECK 1st
--SELECT plan_type,DefineOTH_SPE,* --CHECK 1st
--SELECT DISTINCT [DEGREE DESCRIPTION] --CHECK 1st
--SELECT DISTINCT plan_type --CHECK 1st
--SELECT DISTINCT DefineOTH_SPE --CHECK 1st
FROM ##INNETWORK_PROV
-- WHERE UPPER(LTRIM(RTRIM(plan_type))) LIKE '%SPECIAL%' --IN ('SPE','HBP','AHP','NPMP') --ADD 'HBP' to capture ALL Anesthesiologist 20150512 AND Cert_provider.plan_type has one of the following values: PCP,SPE,AHP,and HBP or starts with NPMP
WHERE (plan_type IS NULL --PROV(s) ;WITH() ,UPPER(LTRIM(RTRIM(vpp.ProductTypeCode))) AS [plan_type]
	OR UPPER(LTRIM(RTRIM(plan_type))) IN ('SPE','HBP','AHP','NPMP')) --LIKE '%SPECIAL%' --IN ('SPE','HBP','AHP','NPMP') --ADD 'HBP' to capture ALL Anesthesiologist 20150512 AND Cert_provider.plan_type has one of the following values: PCP,SPE,AHP,and HBP or starts with NPMP
		AND focus LIKE '%HIV%' OR [AREA_of_PRACTICE] LIKE '%HIV%'







x 'REFRESH' MS EXCEL ODBC LINK(s) ;WITH(): 'R' CLICK ^ 'Table' ^ 'Edit Query'
		OR 'R' CLICK ^ 'Table' ^ 'External Data Properties...' THEN FOLLOW 'UI / UX' External Data WIZARD (From Other Sources DROP DOWN)
				OUTPUT YIELD(s) #,### REC()

REPLACE Provider=SQLOLEDB.1;Integrated Security=SSPI;Persist Security Info=True;Initial Catalog=INFORMATICS;Data Source=SQL07;Use Procedure for Prepare=1;Auto Translate=True;Packet Size=4096;Workstation ID=316CHGWIN7WS;Use Encryption for Data=False;Tag with column collation when possible=False

;WITH()

Provider=SQLOLEDB.1;Integrated Security=SSPI;Persist Security Info=True;Initial Catalog=INFORMATICS;Data Source=SQLPRODAPP01;Use Procedure for Prepare=1;Auto Translate=True;Packet Size=4096;Workstation ID=316CHGWIN7WS;Use Encryption for Data=False;Tag with column collation when possible=False				







x '[FINALlang]' - DEPENDENT UPON ##INNETWORKPROVx
SELECT FINALlang,* FROM INFORMATICS.dbo.PROVDIR_CLINIC WHERE INDEXNM LIKE '%VISTA%COMM%'
SELECT * FROM INFORMATICS.dbo.[PROVDIR_FINALlang] WHERE [Clinic QNXT provid] LIKE '%S160%' OR [Clinic NPI] = '1295822658'
SELECT Language1,Language2,Language3,Language4,[FINALlang],* FROM INFORMATICS.dbo.TimelyAccessCLINIC WHERE FINALlang IS NOT NULL --WHERE [Clinic Name] LIKE '%VISTA%COMM%'
SELECT * FROM INFORMATICS.dbo.TimelyAccessPCP WHERE [Clinic QNXT provid] LIKE '%S160%' OR [Clinic NPI] = '1295822658'







x 'DEGREE  DESCR' - CODE SELECT DISTINCT e.degreecode,e.DegreeName,r.value --CHECK 1st
FROM evips_chgcv.dbo.vwPractitionerEducation AS e 
	LEFT JOIN evips_chgcv.dbo.[vwReferenceUserFields] AS r on r.ParentRecID = e.DegreeId 
		AND r.Displayname = 'Directory Degree' 
		AND r.archived ='N' 
WHERE e.archived ='N' 
	-- AND e.DegreeCode = 'MD'
	AND r.Value IS NOT NULL --ADDITIONAL CRITERIA per YOUNG LADY LAURA EMAIL ...Credentialing has added 7 degree descriptions for the directory. In the query below I only see “PHYSICIAN AND SURGEON”...

--------------------------------------------------------------------------------------------------------------------
	-- Error Trapping: Check If Permanent Table(s) Already Exist(s) And Drop If Applicable --
--------------------------------------------------------------------------------------------------------------------
IF OBJECT_ID('TempDB..##DEGREE_PROV') IS NOT NULL
BEGIN

		DROP TABLE ##DEGREE_PROV --#TableName is a local temporary table visible only in the current session; ##TableName is a global temporary table visible to all sessions IN ('tempdb')

END

SELECT DISTINCT e.PractitionerID AS [lookup_key],e.degreecode,e.DegreeName,UPPER(LTRIM(RTRIM(r.Value))) as [Directory_Degree]
INTO ##DEGREE_PROV
--SELECT UPPER(LTRIM(RTRIM(r.Value))) as [Directory_Degree],*  --CHECK 1st
--SELECT DISTINCT e.degreecode,e.DegreeName,r.value --CHECK 1st
FROM evips_chgcv.dbo.vwPractitionerEducation AS e 
	LEFT JOIN evips_chgcv.dbo.[vwReferenceUserFields] AS r on r.ParentRecID = e.DegreeId 
		AND r.Displayname = 'Directory Degree' 
		AND r.archived ='N' 
WHERE e.archived ='N' 
	-- AND e.DegreeCode = 'MD'
	AND r.Value IS NOT NULL --ADDITIONAL CRITERIA per YOUNG LADY LAURA EMAIL ...Credentialing has added 7 degree descriptions for the directory. In the query below I only see “PHYSICIAN AND SURGEON”...

	AND (e.PractitionerID = '2714235' --TEST CASE KHORO 	AND UPPER(LTRIM(RTRIM(vploc.LastName))) LIKE '%KHOR%' --TEST CASE ... 	AND UPPER(LTRIM(RTRIM(vploc.FirstName))) LIKE '%SUZ%' --TEST CASE ...
OR (UPPER(LTRIM(RTRIM(e.LastName))) LIKE '%KHOR%' --TEST CASE ...
	AND UPPER(LTRIM(RTRIM(e.FirstName))) LIKE '%SUZ%')) --TEST CASE ...
	
					 SELECT * FROM evips_chgcv.dbo.vwPractitionerEducation AS e WHERE e.PractitionerID = '2714235' --TEST CASE KHORO 	AND UPPER(LTRIM(RTRIM(vploc.LastName))) LIKE '%KHOR%' --TEST CASE ... 	AND UPPER(LTRIM(RTRIM(vploc.FirstName))) LIKE '%SUZ%' --TEST CASE ...
					 SELECT * FROM evips_chgcv.dbo.[vwReferenceUserFields]
					 SELECT * FROM ##DEGREE_PROV		 
					
UPDATE ##INNETWORK_PROV
SET [DEGREE DESCRIPTION] = LTRIM(RTRIM(qupd.[Directory_Degree]))
--SELECT * --CHECK 1st ,'Please use the TRS Relay number 711.' AS [TTY] --AFTERHOURS IN Location Phones
FROM ##INNETWORK_PROV AS inet
	-- JOIN ##DEGREE_PROV AS qupd ON UPPER(LTRIM(RTRIM(qupd.lookup_key))) = UPPER(LTRIM(RTRIM(inet.PractitionerID)))
	JOIN ##DEGREE_PROV AS qupd ON UPPER(LTRIM(RTRIM(qupd.degreecode))) = UPPER(LTRIM(RTRIM(inet.TypeOfLicensure)))

SELECT DISTINCT [DEGREE DESCRIPTION],TypeOfLicensure FROM INFORMATICS.dbo.PROVDIR_PCP --PROV(s)
UNION ALL --VERTICAL() w UNION ALL()  - ROW(s) --STACK
SELECT DISTINCT [DEGREE DESCRIPTION],TypeOfLicensure FROM INFORMATICS.dbo.PROVDIR_NPMP --MIDLEVEL(s) NPMP
UNION ALL --VERTICAL() w UNION ALL()  - ROW(s) --STACK
SELECT DISTINCT [DEGREE DESCRIPTION],TypeOfLicensure FROM INFORMATICS.dbo.PROVDIR_SPE --PROV(s)
UNION ALL --VERTICAL() w UNION ALL()  - ROW(s) --STACK
SELECT DISTINCT [DEGREE DESCRIPTION],TypeOfLicensure FROM INFORMATICS.dbo.PROVDIR_MH --PROV(s)
UNION ALL --VERTICAL() w UNION ALL()  - ROW(s) --STACK
SELECT DISTINCT [DEGREE DESCRIPTION],TypeOfLicensure FROM INFORMATICS.dbo.PROVDIR_AHP --PROV(s)
UNION ALL --VERTICAL() w UNION ALL()  - ROW(s) --STACK
SELECT DISTINCT [DEGREE DESCRIPTION],TypeOfLicensure FROM INFORMATICS.dbo.PROVDIR_VSP --PROV(s)
UNION ALL --VERTICAL() w UNION ALL()  - ROW(s) --STACK
SELECT DISTINCT [DEGREE DESCRIPTION],TypeOfLicensure FROM INFORMATICS.dbo.PROVDIR_HOS --FAC(s)
UNION ALL --VERTICAL() w UNION ALL()  - ROW(s) --STACK
SELECT DISTINCT [DEGREE DESCRIPTION],TypeOfLicensure FROM INFORMATICS.dbo.PROVDIR_HOSGENERALACUTE --HOSGAH
UNION ALL --VERTICAL() w UNION ALL()  - ROW(s) --STACK
SELECT DISTINCT [DEGREE DESCRIPTION],TypeOfLicensure FROM INFORMATICS.dbo.PROVDIR_HOSADDITIONAL --HOSADD
UNION ALL --VERTICAL() w UNION ALL()  - ROW(s) --STACK
SELECT DISTINCT [DEGREE DESCRIPTION],TypeOfLicensure FROM INFORMATICS.dbo.PROVDIR_SNF
UNION ALL --VERTICAL() w UNION ALL()  - ROW(s) --STACK
SELECT DISTINCT [DEGREE DESCRIPTION],TypeOfLicensure FROM INFORMATICS.dbo.PROVDIR_RCF
UNION ALL --VERTICAL() w UNION ALL()  - ROW(s) --STACK
SELECT DISTINCT [DEGREE DESCRIPTION],TypeOfLicensure FROM INFORMATICS.dbo.PROVDIR_HOSPICE --ADD HOSPICE facility(-ies) per SC ON 20161012 Walter/Maryanne/Kelly Question 13 is asking for the display in printed and online for 2 new sections (hospice & inpatient rehabilitation).  I will send specs on hospice. 
UNION ALL --VERTICAL() w UNION ALL()  - ROW(s) --STACK
SELECT DISTINCT [DEGREE DESCRIPTION],TypeOfLicensure FROM INFORMATICS.dbo.PROVDIR_IPREHAB --DUPLICATE 'PROVDIR_SNF' --ADD HOSPICE facility(-ies) per SC ON 20161012 Walter/Maryanne/Kelly Question 13 is asking for the display in printed and online for 2 new sections (hospice & inpatient rehabilitation).  I will send specs on hospice. 
UNION ALL --VERTICAL() w UNION ALL()  - ROW(s) --STACK
SELECT DISTINCT [DEGREE DESCRIPTION],TypeOfLicensure FROM INFORMATICS.dbo.PROVDIR_CBAS --INCLUDE ALL
UNION ALL --VERTICAL() w UNION ALL()  - ROW(s) --STACK
SELECT DISTINCT [DEGREE DESCRIPTION],TypeOfLicensure FROM INFORMATICS.dbo.PROVDIR_HDM --INCLUDE ALL
UNION ALL --VERTICAL() w UNION ALL()  - ROW(s) --STACK
SELECT DISTINCT [DEGREE DESCRIPTION],TypeOfLicensure FROM INFORMATICS.dbo.PROVDIR_HHC --INCLUDE ALL
UNION ALL --VERTICAL() w UNION ALL()  - ROW(s) --STACK
SELECT DISTINCT [DEGREE DESCRIPTION],TypeOfLicensure FROM INFORMATICS.dbo.PROVDIR_IHSS --[Participating Network] aka LINE_OF_BUSINESS DISTINCTION NOW PRESENT
UNION ALL --VERTICAL() w UNION ALL()  - ROW(s) --STACK
SELECT DISTINCT [DEGREE DESCRIPTION],TypeOfLicensure FROM INFORMATICS.dbo.PROVDIR_ASC --was AMBSC
UNION ALL --VERTICAL() w UNION ALL()  - ROW(s) --STACK
SELECT DISTINCT [DEGREE DESCRIPTION],TypeOfLicensure FROM INFORMATICS.dbo.PROVDIR_DXC
UNION ALL --VERTICAL() w UNION ALL()  - ROW(s) --STACK
SELECT DISTINCT [DEGREE DESCRIPTION],TypeOfLicensure FROM INFORMATICS.dbo.PROVDIR_LAB --LAB
UNION ALL --VERTICAL() w UNION ALL()  - ROW(s) --STACK
SELECT DISTINCT [DEGREE DESCRIPTION],TypeOfLicensure FROM INFORMATICS.dbo.PROVDIR_DLC
UNION ALL --VERTICAL() w UNION ALL()  - ROW(s) --STACK
SELECT DISTINCT [DEGREE DESCRIPTION],TypeOfLicensure FROM INFORMATICS.dbo.PROVDIR_URC
UNION ALL --VERTICAL() w UNION ALL()  - ROW(s) --STACK
SELECT DISTINCT [DEGREE DESCRIPTION],TypeOfLicensure FROM INFORMATICS.dbo.PROVDIR_MIN --MINUTE CLINIC(s)
UNION ALL --VERTICAL() w UNION ALL()  - ROW(s) --STACK
SELECT DISTINCT [DEGREE DESCRIPTION],TypeOfLicensure FROM INFORMATICS.dbo.PROVDIR_PPH --PPH (Palomar Pomerado Healthcare) EXPRESS
UNION ALL --VERTICAL() w UNION ALL()  - ROW(s) --STACK
SELECT DISTINCT [DEGREE DESCRIPTION],TypeOfLicensure FROM INFORMATICS.dbo.PROVDIR_CLINIC --CONSOLIDATE LANGUAGE(s) WITH JL_Languages_...sql ADD BACK [CULTURAL COMPETENCE]
UNION ALL --VERTICAL() w UNION ALL()  - ROW(s) --STACK
SELECT DISTINCT [DEGREE DESCRIPTION],TypeOfLicensure FROM INFORMATICS.dbo.PROVDIR_PHARM --INCLUDE ALL







x 'LICENSE' - DATA ENTRY PERFORMED THEN REFRESH (30 min. RUNTIME)--------------------------------------------------------------------------------------------------------------------
	-- Error Trapping: Check If Permanent Table(s) Already Exist(s) And Drop If Applicable --
--------------------------------------------------------------------------------------------------------------------
IF OBJECT_ID('TempDB..##LIC_FAC') IS NOT NULL
BEGIN

		DROP TABLE ##LIC_FAC --#TableName is a local temporary table visible only in the current session; ##TableName is a global temporary table visible to all sessions IN ('tempdb')

END

SELECT DISTINCT vploc.LocationID,vploc.PracticeID,vploc.AddressID,REPLACE(UPPER(LTRIM(RTRIM(vplic.LicenseNumber))),'-','') AS [CA_LIC]
INTO ##LIC_FAC
--SELECT vplic.LicenseNumber,vplic.PrimaryLicense,* --CHECK 1st
--SELECT * FROM eVips_chgcv.dbo.vwPracticeLicenses WHERE UPPER(LTRIM(RTRIM(LicenseNumber))) = '090000013' --CHECK 1st 
--SELECT DISTINCT LocationTypeName FROM eVips_chgcv.dbo.vwPracticeLocations --CHECK 1st
FROM eVips_chgcv.dbo.vwPracticeLocations AS vploc
	JOIN eVips_chgcv.dbo.vwPracticeLicenses AS vplic ON  vplic.PracticeID = vploc. PracticeID
		AND vplic.LocationID = vploc. LocationID
		AND vplic.AddressID = vploc. AddressID
WHERE UPPER(LTRIM(RTRIM(vploc.LocationTypeName))) LIKE '%PRACTIC%'
	AND (UPPER(LTRIM(RTRIM(vplic.LicenseTypeName))) LIKE '%LICENSE%'
			OR vplic.LicenseTypeName IS NULL)
	AND vplic.LicenseNumber IS NOT NULL
	AND UPPER(LTRIM(RTRIM(vplic.LicenseNumber))) != ''
	AND UPPER(LTRIM(RTRIM(vplic.PrimaryLicense))) = 'Y'	

					--SELECT * FROM ##LIC_FAC







--------------------------------------------------------------------------------------------------------------------
	-- Error Trapping: Check If Permanent Table(s) Already Exist(s) And Drop If Applicable --
--------------------------------------------------------------------------------------------------------------------
IF OBJECT_ID('TempDB..##LIC_PROV') IS NOT NULL
BEGIN

		DROP TABLE ##LIC_PROV --#TableName is a local temporary table visible only in the current session; ##TableName is a global temporary table visible to all sessions IN ('tempdb')

END

SELECT DISTINCT vploc.PractitionerID AS [lookup_key],REPLACE(UPPER(LTRIM(RTRIM(vplic.LicenseNumber))),'-','') AS [CA_LIC]
INTO ##LIC_PROV
--SELECT vplic.LicenseNumber,vplic.PrimaryLicense,* --CHECK 1st
--SELECT * FROM eVips_chgcv.dbo.vwPractitionerLocations --CHECK 1st 
--SELECT DISTINCT LocationTypeName FROM eVips_chgcv.dbo.vwPractitionerLocations --CHECK 1st
FROM eVips_chgcv.dbo.vwPractitionerLocations AS vploc
	JOIN eVips_chgcv.dbo.vwPractitionerLicenses AS vplic ON  vplic.PractitionerID = vploc. PractitionerID
WHERE (UPPER(LTRIM(RTRIM(vplic.LicenseTypeName))) LIKE '%LICENSE%'
			OR vplic.LicenseTypeName IS NULL)
	AND vplic.LicenseNumber IS NOT NULL
	AND UPPER(LTRIM(RTRIM(vplic.LicenseNumber))) != ''
	AND UPPER(LTRIM(RTRIM(vplic.PrimaryLicense))) = 'Y'
	
	AND (UPPER(LTRIM(RTRIM(vploc.LastName))) LIKE '%KHOR%' --TEST CASE ...
	AND UPPER(LTRIM(RTRIM(vploc.FirstName))) LIKE '%SUZ%' --TEST CASE ...
OR (UPPER(LTRIM(RTRIM(vploc.LastName))) LIKE '%TOLE%' --TEST CASE ...
	AND UPPER(LTRIM(RTRIM(vploc.FirstName))) LIKE '%ABE%') --TEST CASE ...
OR (UPPER(LTRIM(RTRIM(vploc.LastName))) LIKE '%PEN%' --TEST CASE ...
	AND UPPER(LTRIM(RTRIM(vploc.FirstName))) LIKE '%JOS%')) --TEST CASE ...	
ORDER BY vplic.LicenseNumber

					 SELECT * FROM ##LIC_PROV







x 'PROVIDER_TYPE'(s) - MANUALLY HARCODED(d) 

,UPPER(LTRIM(RTRIM(vp.PracticeTypeName))) AS [PROVIDER_TYPEdescr]
,UPPER(LTRIM(RTRIM(vpp.ProductTypeName))) AS [PROVIDER_TYPEdescr]

,'PRIMARY CARE' AS [PROVIDER_TYPE]
-- ,[PROVIDER_TYPEdescr] AS [PROVIDER_TYPE]

,CASE
WHEN [PROVIDER_TYPEdescr] LIKE '%AHP%'
THEN 'Allied Health Practitioner' 
WHEN [PROVIDER_TYPEdescr] LIKE '%HBP%'
THEN 'Hospital Based Provider' 
WHEN [PROVIDER_TYPEdescr] LIKE '%NP%'
THEN 'Non Physician Medical Practitioner' 
WHEN [PROVIDER_TYPEdescr] LIKE '%SPE%'
THEN 'Specialist' 
ELSE 'Specialist' 
END AS [PROVIDER_TYPE]
-- ,[PROVIDER_TYPEdescr] AS [PROVIDER_TYPE]

,UPPER(LTRIM(RTRIM('Hospitals'))) AS PROVIDER_TYPE ...

see ,UPPER(LTRIM(RTRIM(vpp.ProductTypeName))) AS [PROVIDER_TYPEdescr] AND / OR ,[PROVIDER_TYPEdescr] AS [PROVIDER_TYPE]

SELECT DISTINCT PracticeAs,plan_type_fullname,PROVIDER_TYPEdescr FROM SQL07.INFORMATICS.dbo.TimelyAccessPCP
SELECT DISTINCT PracticeAs,plan_type_fullname,PROVIDER_TYPEdescr FROM SQL07.INFORMATICS.dbo.TimelyAccessPCP_Extender
SELECT DISTINCT PracticeAs,plan_type_fullname,PROVIDER_TYPEdescr FROM SQL07.INFORMATICS.dbo.TimelyAccessSPE
SELECT DISTINCT ProductTypeCode,ProductTypeName,PracticeAs FROM SQL07.eVips_chgcv.dbo.vwPractitionerProducts

					'[PROVIDER_TYPE]'
					PRIMARY CARE
					NON PHYSICIAN MEDICAL PRACTITIONER
					HOSPITAL BASED PROVIDER
					SPECIALIST
					HOSPITAL BASED PROVIDER
					ALLIED HEALTH PRACTITIONER
					NON PHYSICIAN MEDICAL PRACTITIONER
					SPECIALIST
					ALLIED HEALTH PRACTITIONER
					ALLIED HEALTH PRACTITIONER
					HOSPITALS
					GENERAL ACUTE HOSPITAL
					LONG TERM ACUTE CARE HOSPITALS
					MENTAL HEALTH & LONG TERM ACUTE CARE HOSPITALS
					SKILLED NURSING FACILITY
					RESIDENTIAL CARE FACILITIES
					HOSPICE
					INPATIENT REHABILITATION FACILITY
					COMMUNITY BASED ADULT SERVICES
					HOME DELIVERED MEALS
					HOME HEALTH CARE FACILITIES
					IN HOME SUPPORT SERVICES
					AMBULATORY SURGERY CENTERS
					DIAGNOSTIC CENTERS
					CLINICAL LABORATORIES
					DIALYSIS CENTERS
					URGENT CARE CENTERS
					URGENT CARE CENTERS
					URGENT CARE CENTERS
					COMMUNITY HEALTH CENTERS
					PHARMACIES
					
SELECT DISTINCT FINALhosp_FULL_NAME,FINALlang,PROVIDER_TYPE FROM INFORMATICS.dbo.PROVDIR_PCP --PROV(s)
UNION ALL --VERTICAL() w UNION ALL()  - ROW(s) --STACK
SELECT DISTINCT PROVIDER_TYPE FROM INFORMATICS.dbo.PROVDIR_NPMP --MIDLEVEL(s) NPMP
UNION ALL --VERTICAL() w UNION ALL()  - ROW(s) --STACK
SELECT DISTINCT PROVIDER_TYPE FROM INFORMATICS.dbo.PROVDIR_SPE --PROV(s)
UNION ALL --VERTICAL() w UNION ALL()  - ROW(s) --STACK
SELECT DISTINCT PROVIDER_TYPE FROM INFORMATICS.dbo.PROVDIR_MH --PROV(s)
UNION ALL --VERTICAL() w UNION ALL()  - ROW(s) --STACK
SELECT DISTINCT PROVIDER_TYPE FROM INFORMATICS.dbo.PROVDIR_AHP --PROV(s)
UNION ALL --VERTICAL() w UNION ALL()  - ROW(s) --STACK
SELECT DISTINCT PROVIDER_TYPE FROM INFORMATICS.dbo.PROVDIR_VSP --PROV(s)
UNION ALL --VERTICAL() w UNION ALL()  - ROW(s) --STACK
SELECT DISTINCT PROVIDER_TYPE FROM INFORMATICS.dbo.PROVDIR_HOS --FAC(s)
UNION ALL --VERTICAL() w UNION ALL()  - ROW(s) --STACK
SELECT DISTINCT PROVIDER_TYPE FROM INFORMATICS.dbo.PROVDIR_HOSGENERALACUTE --HOSGAH
UNION ALL --VERTICAL() w UNION ALL()  - ROW(s) --STACK
SELECT DISTINCT PROVIDER_TYPE FROM INFORMATICS.dbo.PROVDIR_HOSADDITIONAL --HOSADD
UNION ALL --VERTICAL() w UNION ALL()  - ROW(s) --STACK
SELECT DISTINCT PROVIDER_TYPE FROM INFORMATICS.dbo.PROVDIR_SNF
UNION ALL --VERTICAL() w UNION ALL()  - ROW(s) --STACK
SELECT DISTINCT PROVIDER_TYPE FROM INFORMATICS.dbo.PROVDIR_RCF
UNION ALL --VERTICAL() w UNION ALL()  - ROW(s) --STACK
SELECT DISTINCT PROVIDER_TYPE FROM INFORMATICS.dbo.PROVDIR_HOSPICE --ADD HOSPICE facility(-ies) per SC ON 20161012 Walter/Maryanne/Kelly Question 13 is asking for the display in printed and online for 2 new sections (hospice & inpatient rehabilitation).  I will send specs on hospice. 
UNION ALL --VERTICAL() w UNION ALL()  - ROW(s) --STACK
SELECT DISTINCT PROVIDER_TYPE FROM INFORMATICS.dbo.PROVDIR_IPREHAB --DUPLICATE 'PROVDIR_SNF' --ADD HOSPICE facility(-ies) per SC ON 20161012 Walter/Maryanne/Kelly Question 13 is asking for the display in printed and online for 2 new sections (hospice & inpatient rehabilitation).  I will send specs on hospice. 
UNION ALL --VERTICAL() w UNION ALL()  - ROW(s) --STACK
SELECT DISTINCT PROVIDER_TYPE FROM INFORMATICS.dbo.PROVDIR_CBAS --INCLUDE ALL
UNION ALL --VERTICAL() w UNION ALL()  - ROW(s) --STACK
SELECT DISTINCT PROVIDER_TYPE FROM INFORMATICS.dbo.PROVDIR_HDM --INCLUDE ALL
UNION ALL --VERTICAL() w UNION ALL()  - ROW(s) --STACK
SELECT DISTINCT PROVIDER_TYPE FROM INFORMATICS.dbo.PROVDIR_HHC --INCLUDE ALL
UNION ALL --VERTICAL() w UNION ALL()  - ROW(s) --STACK
SELECT DISTINCT PROVIDER_TYPE FROM INFORMATICS.dbo.PROVDIR_IHSS --[Participating Network] aka LINE_OF_BUSINESS DISTINCTION NOW PRESENT
UNION ALL --VERTICAL() w UNION ALL()  - ROW(s) --STACK
SELECT DISTINCT PROVIDER_TYPE FROM INFORMATICS.dbo.PROVDIR_ASC --was AMBSC
UNION ALL --VERTICAL() w UNION ALL()  - ROW(s) --STACK
SELECT DISTINCT PROVIDER_TYPE FROM INFORMATICS.dbo.PROVDIR_DXC
UNION ALL --VERTICAL() w UNION ALL()  - ROW(s) --STACK
SELECT DISTINCT PROVIDER_TYPE FROM INFORMATICS.dbo.PROVDIR_LAB --LAB
UNION ALL --VERTICAL() w UNION ALL()  - ROW(s) --STACK
SELECT DISTINCT PROVIDER_TYPE FROM INFORMATICS.dbo.PROVDIR_DLC
UNION ALL --VERTICAL() w UNION ALL()  - ROW(s) --STACK
SELECT DISTINCT PROVIDER_TYPE FROM INFORMATICS.dbo.PROVDIR_URC
UNION ALL --VERTICAL() w UNION ALL()  - ROW(s) --STACK
SELECT DISTINCT PROVIDER_TYPE FROM INFORMATICS.dbo.PROVDIR_MIN --MINUTE CLINIC(s)
UNION ALL --VERTICAL() w UNION ALL()  - ROW(s) --STACK
SELECT DISTINCT PROVIDER_TYPE FROM INFORMATICS.dbo.PROVDIR_PPH --PPH (Palomar Pomerado Healthcare) EXPRESS
UNION ALL --VERTICAL() w UNION ALL()  - ROW(s) --STACK
SELECT DISTINCT PROVIDER_TYPE FROM INFORMATICS.dbo.PROVDIR_CLINIC --CONSOLIDATE LANGUAGE(s) WITH JL_Languages_...sql ADD BACK [CULTURAL COMPETENCE]
UNION ALL --VERTICAL() w UNION ALL()  - ROW(s) --STACK
SELECT DISTINCT PROVIDER_TYPE FROM INFORMATICS.dbo.PROVDIR_PHARM --INCLUDE ALL







x 'OFFICE HOUR'(s) - ???
,CAST(NULL AS nvarchar(255)) AS [Office Hour(s)] --vwLocationHours OR vwPractitionerLocationHours ,UPPER(LTRIM(RTRIM(address.legal_name))) AS [Office Hour(s)] SAMPLE(): 'MON-FRI 8:30AM - 6PM, SAT 8:30AM-2PM, SUN CLOSED'

SELECT DISTINCT  [Office Hour(s)] FROM #HOURS_PROV ORDER BY [Office Hour(s)]
SELECT INDEXNM,* FROM INFORMATICS.dbo.PROVDIR_PCP WHERE lookup_key IN ('2060654','2054902','2048263','2058458')
SELECT * FROM ##INNETWORK_PROV WHERE lookup_key = '2060654'
SELECT * FROM ##HOSPpriv	WHERE lookup_key = '2060654'

					SELECT TOP 10 * --CHECK 1st
					FROM evips_chgcv.dbo.vwLocationHours
					WHERE LocationID IN ('2302710')
						OR PracticeID IN ('2302707')

					SELECT TOP 10 Notes,* --CHECK 1st
					FROM evips_chgcv.dbo.vwPracticeLocations
					WHERE CAST(UPPER(LTRIM(RTRIM(Notes))) AS nvarchar(25)) = 'S294001'

					SELECT TOP 10 LocationNotes,* --CHECK 1st
					FROM evips_chgcv.dbo.vwPractitionerLocations
					WHERE CAST(UPPER(LTRIM(RTRIM(LocationNotes))) AS nvarchar(25)) = 'S294001'

					SELECT * 
					FROM ##MSEXCEL_PROVDIR 
					WHERE INDEXNM LIKE '%ZAND%KAR%' --lookup_key = '2049489'

,CAST(UPPER(LTRIM(RTRIM(vpl.Notes))) AS nvarchar(25)) [Clinic QNXT provid] --aka SITE CODE eVips_chgcv.dbo.vwPracticeLocations
,CAST(UPPER(LTRIM(RTRIM(vploc.LocationNotes))) AS nvarchar(25)) [Clinic QNXT provid] --aka SITE CODE --eVips_chgcv.dbo.vwPractitionerLocations

-- ===================================================================
	--DEVELOP [Office Hour(s)] PROVDIR ENTRY--
-- ===================================================================
--------------------------------------------------------------------------------------------------------------------
	-- Error Trapping: Check If Permanent Table(s) Already Exist(s) And Drop If Applicable --
--------------------------------------------------------------------------------------------------------------------
IF OBJECT_ID('TempDB..#HOURS_FAC') IS NOT NULL --DYNAMIC #TableName is a local temporary table visible only in the current session; ##TableName is a global temporary table visible to all sessions IN ('TempDB')
BEGIN

		DROP TABLE #HOURS_FAC

END
 
SELECT DISTINCT LocationID,PracticeID
,CAST(NULL AS nvarchar(255)) AS [Office Hour(s)] --vwLocationHours OR vwPractitionerLocationHours ,UPPER(LTRIM(RTRIM(address.legal_name))) AS [Office Hour(s)] SAMPLE(): 'MON-FRI 8:30AM - 6PM, SAT 8:30AM-2PM, SUN CLOSED'
,CAST(NULL AS nvarchar(15)) AS [1_START] --SUNDAY
,CAST(NULL AS nvarchar(15)) AS [2_START] --MONDAY
,CAST(NULL AS nvarchar(15)) AS [3_START] --TUESDAY
,CAST(NULL AS nvarchar(15)) AS [4_START] --WEDNESDAY
,CAST(NULL AS nvarchar(15)) AS [5_START] --THURSDAY
,CAST(NULL AS nvarchar(15)) AS [6_START] --FRIDAY
,CAST(NULL AS nvarchar(15)) AS [7_START] --SATURDAY
,CAST(NULL AS nvarchar(15)) AS [1_END] --SUNDAY
,CAST(NULL AS nvarchar(15)) AS [2_END] --MONDAY
,CAST(NULL AS nvarchar(15)) AS [3_END] --TUESDAY
,CAST(NULL AS nvarchar(15)) AS [4_END] --WEDNESDAY
,CAST(NULL AS nvarchar(15)) AS [5_END] --THURSDAY
,CAST(NULL AS nvarchar(15)) AS [6_END] --FRIDAY
,CAST(NULL AS nvarchar(15)) AS [7_END] --SATURDAY
INTO #HOURS_FAC
--SELECT TOP 100 * --CHECK 1st
FROM evips_chgcv.dbo.vwLocationHours
 
	--DUP(s)--
 -- SELECT 'DUP Validation' AS [NOTE(s)],*
 -- FROM #HOURS_FAC
-- WHERE LTRIM(RTRIM(LocationID)) IN (SELECT LTRIM(RTRIM(dup.LocationID))
 -- FROM #HOURS_FAC AS dup
 -- GROUP BY LTRIM(RTRIM(dup.LocationID)) --Duplication Driver
 -- HAVING COUNT(1)>1) --HAVING clause RESERVED for AGGREGATE(s)
 -- ORDER BY LTRIM(RTRIM(LocationID))

					 --SELECT * FROM #HOURS_FAC

UPDATE #HOURS_FAC
SET [1_START] = REPLACE(REPLACE(LTRIM(RIGHT(CONVERT(VARCHAR(20),CAST(StartTime AS datetime),100), 7)),'AM',' AM'),'PM',' PM') --AS [Time in the 12-hour format hh:miAM (or PM) SPACING]
,[1_END] = REPLACE(REPLACE(LTRIM(RIGHT(CONVERT(VARCHAR(20),CAST(EndTime AS datetime),100), 7)),'AM',' AM'),'PM',' PM') --AS [Time in the 12-hour format hh:miAM (or PM) SPACING]
--SELECT TOP 100 * --CHECK 1st
FROM #HOURS_FAC AS h
	JOIN evips_chgcv.dbo.vwLocationHours AS vlh ON LTRIM(RTRIM(vlh.LocationID)) = LTRIM(RTRIM(h.LocationID))
		AND LTRIM(RTRIM(vlh.PracticeID)) = LTRIM(RTRIM(h.PracticeID))
WHERE LTRIM(RTRIM(vlh.DayOfWeekID)) = '1' --SUNDAY

UPDATE #HOURS_FAC
SET [2_START] = REPLACE(REPLACE(LTRIM(RIGHT(CONVERT(VARCHAR(20),CAST(StartTime AS datetime),100), 7)),'AM',' AM'),'PM',' PM') --AS [Time in the 12-hour format hh:miAM (or PM) SPACING]
,[2_END] = REPLACE(REPLACE(LTRIM(RIGHT(CONVERT(VARCHAR(20),CAST(EndTime AS datetime),100), 7)),'AM',' AM'),'PM',' PM') --AS [Time in the 12-hour format hh:miAM (or PM) SPACING]
--SELECT TOP 100 * --CHECK 1st
FROM #HOURS_FAC AS h
	JOIN evips_chgcv.dbo.vwLocationHours AS vlh ON LTRIM(RTRIM(vlh.LocationID)) = LTRIM(RTRIM(h.LocationID))
		AND LTRIM(RTRIM(vlh.PracticeID)) = LTRIM(RTRIM(h.PracticeID))
WHERE LTRIM(RTRIM(vlh.DayOfWeekID)) = '2' --MONDAY

UPDATE #HOURS_FAC
SET [3_START] = REPLACE(REPLACE(LTRIM(RIGHT(CONVERT(VARCHAR(20),CAST(StartTime AS datetime),100), 7)),'AM',' AM'),'PM',' PM') --AS [Time in the 12-hour format hh:miAM (or PM) SPACING]
,[3_END] = REPLACE(REPLACE(LTRIM(RIGHT(CONVERT(VARCHAR(20),CAST(EndTime AS datetime),100), 7)),'AM',' AM'),'PM',' PM') --AS [Time in the 12-hour format hh:miAM (or PM) SPACING]
--SELECT TOP 100 * --CHECK 1st
FROM #HOURS_FAC AS h
	JOIN evips_chgcv.dbo.vwLocationHours AS vlh ON LTRIM(RTRIM(vlh.LocationID)) = LTRIM(RTRIM(h.LocationID))
		AND LTRIM(RTRIM(vlh.PracticeID)) = LTRIM(RTRIM(h.PracticeID))
WHERE LTRIM(RTRIM(vlh.DayOfWeekID)) = '3' --TUESDAY

UPDATE #HOURS_FAC
SET [4_START] = REPLACE(REPLACE(LTRIM(RIGHT(CONVERT(VARCHAR(20),CAST(StartTime AS datetime),100), 7)),'AM',' AM'),'PM',' PM') --AS [Time in the 12-hour format hh:miAM (or PM) SPACING]
,[4_END] = REPLACE(REPLACE(LTRIM(RIGHT(CONVERT(VARCHAR(20),CAST(EndTime AS datetime),100), 7)),'AM',' AM'),'PM',' PM') --AS [Time in the 12-hour format hh:miAM (or PM) SPACING]
--SELECT TOP 100 * --CHECK 1st
FROM #HOURS_FAC AS h
	JOIN evips_chgcv.dbo.vwLocationHours AS vlh ON LTRIM(RTRIM(vlh.LocationID)) = LTRIM(RTRIM(h.LocationID))
		AND LTRIM(RTRIM(vlh.PracticeID)) = LTRIM(RTRIM(h.PracticeID))
WHERE LTRIM(RTRIM(vlh.DayOfWeekID)) = '4' --WEDNESDAY

UPDATE #HOURS_FAC
SET [5_START] = REPLACE(REPLACE(LTRIM(RIGHT(CONVERT(VARCHAR(20),CAST(StartTime AS datetime),100), 7)),'AM',' AM'),'PM',' PM') --AS [Time in the 12-hour format hh:miAM (or PM) SPACING]
,[5_END] = REPLACE(REPLACE(LTRIM(RIGHT(CONVERT(VARCHAR(20),CAST(EndTime AS datetime),100), 7)),'AM',' AM'),'PM',' PM') --AS [Time in the 12-hour format hh:miAM (or PM) SPACING]
--SELECT TOP 100 * --CHECK 1st
FROM #HOURS_FAC AS h
	JOIN evips_chgcv.dbo.vwLocationHours AS vlh ON LTRIM(RTRIM(vlh.LocationID)) = LTRIM(RTRIM(h.LocationID))
		AND LTRIM(RTRIM(vlh.PracticeID)) = LTRIM(RTRIM(h.PracticeID))
WHERE LTRIM(RTRIM(vlh.DayOfWeekID)) = '5' --THURSDAY

UPDATE #HOURS_FAC
SET [6_START] = REPLACE(REPLACE(LTRIM(RIGHT(CONVERT(VARCHAR(20),CAST(StartTime AS datetime),100), 7)),'AM',' AM'),'PM',' PM') --AS [Time in the 12-hour format hh:miAM (or PM) SPACING]
,[6_END] = REPLACE(REPLACE(LTRIM(RIGHT(CONVERT(VARCHAR(20),CAST(EndTime AS datetime),100), 7)),'AM',' AM'),'PM',' PM') --AS [Time in the 12-hour format hh:miAM (or PM) SPACING]
--SELECT TOP 100 * --CHECK 1st
FROM #HOURS_FAC AS h
	JOIN evips_chgcv.dbo.vwLocationHours AS vlh ON LTRIM(RTRIM(vlh.LocationID)) = LTRIM(RTRIM(h.LocationID))
		AND LTRIM(RTRIM(vlh.PracticeID)) = LTRIM(RTRIM(h.PracticeID))
WHERE LTRIM(RTRIM(vlh.DayOfWeekID)) = '6' --FRIDAY

UPDATE #HOURS_FAC
SET [7_START] = REPLACE(REPLACE(LTRIM(RIGHT(CONVERT(VARCHAR(20),CAST(StartTime AS datetime),100), 7)),'AM',' AM'),'PM',' PM') --AS [Time in the 12-hour format hh:miAM (or PM) SPACING]
,[7_END] = REPLACE(REPLACE(LTRIM(RIGHT(CONVERT(VARCHAR(20),CAST(EndTime AS datetime),100), 7)),'AM',' AM'),'PM',' PM') --AS [Time in the 12-hour format hh:miAM (or PM) SPACING]
--SELECT TOP 100 * --CHECK 1st
FROM #HOURS_FAC AS h
	JOIN evips_chgcv.dbo.vwLocationHours AS vlh ON LTRIM(RTRIM(vlh.LocationID)) = LTRIM(RTRIM(h.LocationID))
		AND LTRIM(RTRIM(vlh.PracticeID)) = LTRIM(RTRIM(h.PracticeID))
WHERE LTRIM(RTRIM(vlh.DayOfWeekID)) = '7' --SATURDAY

					--SELECT * FROM #HOURS_FAC

UPDATE #HOURS_FAC
SET [Office Hour(s)] = CASE
WHEN [2_START] = [3_START]
	AND [2_START] = [4_START]
	AND [2_START] = [5_START]
	AND [2_START] = [6_START]
	AND [2_END] = [3_END]
	AND [2_END] = [4_END]
	AND [2_END] = [5_END]
	AND [2_END] = [6_END]
THEN 'MON - FRI '+[2_START]+' - '+[2_END]
ELSE CASE
WHEN [2_START] IS NOT NULL
THEN 'MON '+[2_START]+' - '+[2_END]
ELSE ''
END
+
CASE
WHEN [3_START] IS NOT NULL
THEN ', TUE '+[3_START]+' - '+[3_END]
ELSE ''
END
+
CASE
WHEN [4_START] IS NOT NULL
THEN ', WED '+[4_START]+' - '+[4_END]
ELSE ''
END
+
CASE
WHEN [5_START] IS NOT NULL
THEN ', THU '+[5_START]+' - '+[5_END]
ELSE ''
END
+
CASE
WHEN [6_START] IS NOT NULL
THEN ', FRI '+[6_START]+' - '+[6_END]
ELSE ''
END
+
CASE
WHEN [7_START] IS NOT NULL
THEN ', SAT  '+[7_START]+' - '+[7_END]
ELSE ''
END
+
CASE
WHEN [1_START] IS NOT NULL
THEN ', SUN  '+[1_START]+' - '+[1_END]
ELSE ''
END
END --NESTED()
FROM #HOURS_FAC AS h

					UPDATE #HOURS_FAC
					SET [Office Hour(s)] = CASE
					WHEN [Office Hour(s)] LIKE ', %'
					THEN SUBSTRING([Office Hour(s)],3,255)
					ELSE [Office Hour(s)]
					END 
					--SELECT * --CHECK 1st
					FROM #HOURS_FAC

					SELECT * FROM #HOURS_FAC
					WHERE LocationID IN ('2302710')
						OR PracticeID IN ('2302707')







--------------------------------------------------------------------------------------------------------------------
	-- Error Trapping: Check If Permanent Table(s) Already Exist(s) And Drop If Applicable --
--------------------------------------------------------------------------------------------------------------------
IF OBJECT_ID('TempDB..#HOURS_PROV') IS NOT NULL --DYNAMIC #TableName is a local temporary table visible only in the current session; ##TableName is a global temporary table visible to all sessions IN ('TempDB')
BEGIN

		DROP TABLE #HOURS_PROV

END
 
SELECT DISTINCT LocationID,PracticeID,PractitionerID
,CAST(NULL AS nvarchar(255)) AS [Office Hour(s)] --vwLocationHours OR vwPractitionerLocationHours ,UPPER(LTRIM(RTRIM(address.legal_name))) AS [Office Hour(s)] SAMPLE(): 'MON-FRI 8:30AM - 6PM, SAT 8:30AM-2PM, SUN CLOSED'
,CAST(NULL AS nvarchar(15)) AS [1_START] --SUNDAY
,CAST(NULL AS nvarchar(15)) AS [2_START] --MONDAY
,CAST(NULL AS nvarchar(15)) AS [3_START] --TUESDAY
,CAST(NULL AS nvarchar(15)) AS [4_START] --WEDNESDAY
,CAST(NULL AS nvarchar(15)) AS [5_START] --THURSDAY
,CAST(NULL AS nvarchar(15)) AS [6_START] --FRIDAY
,CAST(NULL AS nvarchar(15)) AS [7_START] --SATURDAY
,CAST(NULL AS nvarchar(15)) AS [1_END] --SUNDAY
,CAST(NULL AS nvarchar(15)) AS [2_END] --MONDAY
,CAST(NULL AS nvarchar(15)) AS [3_END] --TUESDAY
,CAST(NULL AS nvarchar(15)) AS [4_END] --WEDNESDAY
,CAST(NULL AS nvarchar(15)) AS [5_END] --THURSDAY
,CAST(NULL AS nvarchar(15)) AS [6_END] --FRIDAY
,CAST(NULL AS nvarchar(15)) AS [7_END] --SATURDAY
INTO #HOURS_PROV
--SELECT TOP 100 * --CHECK 1st
FROM evips_chgcv.dbo.vwPractitionerLocationHours
 
	--DUP(s)--
-- SELECT 'DUP Validation' AS [NOTE(s)],*
-- FROM #HOURS_PROV
-- WHERE LTRIM(RTRIM(LocationID))+LTRIM(RTRIM(PractitionerID)) IN (SELECT LTRIM(RTRIM(dup.LocationID))+LTRIM(RTRIM(dup.PractitionerID))
-- FROM #HOURS_PROV AS dup
-- GROUP BY LTRIM(RTRIM(dup.LocationID))+LTRIM(RTRIM(dup.PractitionerID)) --Duplication Driver
-- HAVING COUNT(1)>1) --HAVING clause RESERVED for AGGREGATE(s)
-- ORDER BY LTRIM(RTRIM(LocationID))+LTRIM(RTRIM(PractitionerID))

					--SELECT * FROM #HOURS_PROV

UPDATE #HOURS_PROV
SET [1_START] = REPLACE(REPLACE(LTRIM(RIGHT(CONVERT(VARCHAR(20),CAST(StartTime AS datetime),100), 7)),'AM',' AM'),'PM',' PM') --AS [Time in the 12-hour format hh:miAM (or PM) SPACING]
,[1_END] = REPLACE(REPLACE(LTRIM(RIGHT(CONVERT(VARCHAR(20),CAST(EndTime AS datetime),100), 7)),'AM',' AM'),'PM',' PM') --AS [Time in the 12-hour format hh:miAM (or PM) SPACING]
--SELECT TOP 100 * --CHECK 1st
FROM #HOURS_PROV AS h
	JOIN evips_chgcv.dbo.vwPractitionerLocationHours AS vlh ON LTRIM(RTRIM(vlh.LocationID)) = LTRIM(RTRIM(h.LocationID))
		AND LTRIM(RTRIM(vlh.PracticeID)) = LTRIM(RTRIM(h.PracticeID))
		AND LTRIM(RTRIM(vlh.PractitionerID)) = LTRIM(RTRIM(h.PractitionerID))
WHERE LTRIM(RTRIM(vlh.DayOfWeekID)) = '1' --SUNDAY

UPDATE #HOURS_PROV
SET [2_START] = REPLACE(REPLACE(LTRIM(RIGHT(CONVERT(VARCHAR(20),CAST(StartTime AS datetime),100), 7)),'AM',' AM'),'PM',' PM') --AS [Time in the 12-hour format hh:miAM (or PM) SPACING]
,[2_END] = REPLACE(REPLACE(LTRIM(RIGHT(CONVERT(VARCHAR(20),CAST(EndTime AS datetime),100), 7)),'AM',' AM'),'PM',' PM') --AS [Time in the 12-hour format hh:miAM (or PM) SPACING]
--SELECT TOP 100 * --CHECK 1st
FROM #HOURS_PROV AS h
	JOIN evips_chgcv.dbo.vwPractitionerLocationHours AS vlh ON LTRIM(RTRIM(vlh.LocationID)) = LTRIM(RTRIM(h.LocationID))
		AND LTRIM(RTRIM(vlh.PracticeID)) = LTRIM(RTRIM(h.PracticeID))
		AND LTRIM(RTRIM(vlh.PractitionerID)) = LTRIM(RTRIM(h.PractitionerID))
WHERE LTRIM(RTRIM(vlh.DayOfWeekID)) = '2' --MONDAY

UPDATE #HOURS_PROV
SET [3_START] = REPLACE(REPLACE(LTRIM(RIGHT(CONVERT(VARCHAR(20),CAST(StartTime AS datetime),100), 7)),'AM',' AM'),'PM',' PM') --AS [Time in the 12-hour format hh:miAM (or PM) SPACING]
,[3_END] = REPLACE(REPLACE(LTRIM(RIGHT(CONVERT(VARCHAR(20),CAST(EndTime AS datetime),100), 7)),'AM',' AM'),'PM',' PM') --AS [Time in the 12-hour format hh:miAM (or PM) SPACING]
--SELECT TOP 100 * --CHECK 1st
FROM #HOURS_PROV AS h
	JOIN evips_chgcv.dbo.vwPractitionerLocationHours AS vlh ON LTRIM(RTRIM(vlh.LocationID)) = LTRIM(RTRIM(h.LocationID))
		AND LTRIM(RTRIM(vlh.PracticeID)) = LTRIM(RTRIM(h.PracticeID))
		AND LTRIM(RTRIM(vlh.PractitionerID)) = LTRIM(RTRIM(h.PractitionerID))
WHERE LTRIM(RTRIM(vlh.DayOfWeekID)) = '3' --TUESDAY

UPDATE #HOURS_PROV
SET [4_START] = REPLACE(REPLACE(LTRIM(RIGHT(CONVERT(VARCHAR(20),CAST(StartTime AS datetime),100), 7)),'AM',' AM'),'PM',' PM') --AS [Time in the 12-hour format hh:miAM (or PM) SPACING]
,[4_END] = REPLACE(REPLACE(LTRIM(RIGHT(CONVERT(VARCHAR(20),CAST(EndTime AS datetime),100), 7)),'AM',' AM'),'PM',' PM') --AS [Time in the 12-hour format hh:miAM (or PM) SPACING]
--SELECT TOP 100 * --CHECK 1st
FROM #HOURS_PROV AS h
	JOIN evips_chgcv.dbo.vwPractitionerLocationHours AS vlh ON LTRIM(RTRIM(vlh.LocationID)) = LTRIM(RTRIM(h.LocationID))
		AND LTRIM(RTRIM(vlh.PracticeID)) = LTRIM(RTRIM(h.PracticeID))
		AND LTRIM(RTRIM(vlh.PractitionerID)) = LTRIM(RTRIM(h.PractitionerID))
WHERE LTRIM(RTRIM(vlh.DayOfWeekID)) = '4' --WEDNESDAY

UPDATE #HOURS_PROV
SET [5_START] = REPLACE(REPLACE(LTRIM(RIGHT(CONVERT(VARCHAR(20),CAST(StartTime AS datetime),100), 7)),'AM',' AM'),'PM',' PM') --AS [Time in the 12-hour format hh:miAM (or PM) SPACING]
,[5_END] = REPLACE(REPLACE(LTRIM(RIGHT(CONVERT(VARCHAR(20),CAST(EndTime AS datetime),100), 7)),'AM',' AM'),'PM',' PM') --AS [Time in the 12-hour format hh:miAM (or PM) SPACING]
--SELECT TOP 100 * --CHECK 1st
FROM #HOURS_PROV AS h
	JOIN evips_chgcv.dbo.vwPractitionerLocationHours AS vlh ON LTRIM(RTRIM(vlh.LocationID)) = LTRIM(RTRIM(h.LocationID))
		AND LTRIM(RTRIM(vlh.PracticeID)) = LTRIM(RTRIM(h.PracticeID))
		AND LTRIM(RTRIM(vlh.PractitionerID)) = LTRIM(RTRIM(h.PractitionerID))
WHERE LTRIM(RTRIM(vlh.DayOfWeekID)) = '5' --THURSDAY

UPDATE #HOURS_PROV
SET [6_START] = REPLACE(REPLACE(LTRIM(RIGHT(CONVERT(VARCHAR(20),CAST(StartTime AS datetime),100), 7)),'AM',' AM'),'PM',' PM') --AS [Time in the 12-hour format hh:miAM (or PM) SPACING]
,[6_END] = REPLACE(REPLACE(LTRIM(RIGHT(CONVERT(VARCHAR(20),CAST(EndTime AS datetime),100), 7)),'AM',' AM'),'PM',' PM') --AS [Time in the 12-hour format hh:miAM (or PM) SPACING]
--SELECT TOP 100 * --CHECK 1st
FROM #HOURS_PROV AS h
	JOIN evips_chgcv.dbo.vwPractitionerLocationHours AS vlh ON LTRIM(RTRIM(vlh.LocationID)) = LTRIM(RTRIM(h.LocationID))
		AND LTRIM(RTRIM(vlh.PracticeID)) = LTRIM(RTRIM(h.PracticeID))
		AND LTRIM(RTRIM(vlh.PractitionerID)) = LTRIM(RTRIM(h.PractitionerID))
WHERE LTRIM(RTRIM(vlh.DayOfWeekID)) = '6' --FRIDAY

UPDATE #HOURS_PROV
SET [7_START] = REPLACE(REPLACE(LTRIM(RIGHT(CONVERT(VARCHAR(20),CAST(StartTime AS datetime),100), 7)),'AM',' AM'),'PM',' PM') --AS [Time in the 12-hour format hh:miAM (or PM) SPACING]
,[7_END] = REPLACE(REPLACE(LTRIM(RIGHT(CONVERT(VARCHAR(20),CAST(EndTime AS datetime),100), 7)),'AM',' AM'),'PM',' PM') --AS [Time in the 12-hour format hh:miAM (or PM) SPACING]
--SELECT TOP 100 * --CHECK 1st
FROM #HOURS_PROV AS h
	JOIN evips_chgcv.dbo.vwPractitionerLocationHours AS vlh ON LTRIM(RTRIM(vlh.LocationID)) = LTRIM(RTRIM(h.LocationID))
		AND LTRIM(RTRIM(vlh.PracticeID)) = LTRIM(RTRIM(h.PracticeID))
		AND LTRIM(RTRIM(vlh.PractitionerID)) = LTRIM(RTRIM(h.PractitionerID))
WHERE LTRIM(RTRIM(vlh.DayOfWeekID)) = '7' --SATURDAY

					--SELECT * FROM #HOURS_PROV

UPDATE #HOURS_PROV
SET [Office Hour(s)] = CASE
WHEN [2_START] = [3_START]
	AND [2_START] = [4_START]
	AND [2_START] = [5_START]
	AND [2_START] = [6_START]
	AND [2_END] = [3_END]
	AND [2_END] = [4_END]
	AND [2_END] = [5_END]
	AND [2_END] = [6_END]
THEN 'MON - FRI '+[2_START]+' - '+[2_END]
ELSE CASE
WHEN [2_START] IS NOT NULL
THEN 'MON '+[2_START]+' - '+[2_END]
ELSE ''
END
+
CASE
WHEN [3_START] IS NOT NULL
THEN ', TUE '+[3_START]+' - '+[3_END]
ELSE ''
END
+
CASE
WHEN [4_START] IS NOT NULL
THEN ', WED '+[4_START]+' - '+[4_END]
ELSE ''
END
+
CASE
WHEN [5_START] IS NOT NULL
THEN ', THU '+[5_START]+' - '+[5_END]
ELSE ''
END
+
CASE
WHEN [6_START] IS NOT NULL
THEN ', FRI '+[6_START]+' - '+[6_END]
ELSE ''
END
+
CASE
WHEN [7_START] IS NOT NULL
THEN ', SAT  '+[7_START]+' - '+[7_END]
ELSE ''
END
+
CASE
WHEN [1_START] IS NOT NULL
THEN ', SUN  '+[1_START]+' - '+[1_END]
ELSE ''
END
END --NESTED()
FROM #HOURS_PROV AS h

					UPDATE #HOURS_PROV
					SET [Office Hour(s)] = CASE
					WHEN [Office Hour(s)] LIKE ', %'
					THEN SUBSTRING([Office Hour(s)],3,255)
					ELSE [Office Hour(s)]
					END 
					--SELECT * --CHECK 1st
					FROM #HOURS_PROV
						
					SELECT * --CHECK 1st
					FROM #HOURS_PROV
					WHERE LocationID IN ('2302710')
						OR PracticeID IN ('2302707')







x REINSERT POST GO LIVE ON '20171215'

-- DELETE
SELECT 'REINSERT DELETE - POST GO LIE ON "20171215"' AS [NOTE(s)],* --CHECK 1st
--SELECT DISTINCT HOSPNM,HOSPABBREV --CHECK 1st
--SELECT DISTINCT HOSPNM,HOSPABBREV FROM ##HOSPpriv ORDER BY HOSPNM --CHECK 1st
FROM ##HOSPpriv
WHERE HOSPNPI IS NULL --,UPPER(LTRIM(RTRIM(addr.npi))) AS HOSPNPI
----------------ORDER BY HOSPNM
	-- OR [USE_HOSPITALIST]  IS NOT NULL
	OR [USE_HOSPITALIST] IN (@hospriv) --USE  IN ('Y') TO RETAIN DIRECT HOSPPRIV ONLY WITHIN PROVIDER DIRECTORY / USE 'B' TO RETAIN EITHER OPTION FOR NETWORK ADEQUACY REPORT(s) see SELECT DISTINCT 'N' AS [USE_HOSPITALIST]...

					--SELECT * FROM ##HOSPpriv

 x 'EXECUTION PLAN'

SELECT distinct ljvlp.PracticeID,
       ljvlp.Archived,
       StatusTypeName,
       ServiceTypeName,
       productname,
       ProductPanelStatusTypeName,
       ProductPanelStatusTypeCode,
       ProviderNumber,
       Focus,
       ljvlp.ProductID

		-- LEFT JOIN (SELECT vlpstype.ServiceTypeName,ljvlp.* FROM eVips_chgcv.dbo.vwLocationProducts AS ljvlp LEFT JOIN evips_chgcv.dbo.vwLocationProductServices AS vlpstype ON vlpstype.LocationProductRecID = ljvlp.LocationProductRecID WHERE (ljvlp.Archived IN ('N') OR ljvlp.Archived IS NULL) AND (ljvlp.StatusTypeName IN ('ACTIVE') OR ljvlp.StatusTypeName LIKE '%PARTICIP%' OR ljvlp.StatusTypeName IS NULL) AND (vlpstype.Archived IN ('N') OR vlpstype.Archived IS NULL)) AS vlp ON vlp.PracticeID = vp.PracticeID

		LEFT JOIN (SELECT DISTINCT ljvlp.PracticeID, ljvlp.Archived, StatusTypeName, ServiceTypeName, productname, ProductPanelStatusTypeName, ProductPanelStatusTypeCode, ProviderNumber, Focus, ljvlp.ProductID FROM eVips_chgcv.dbo.vwLocationProducts AS ljvlp LEFT JOIN evips_chgcv.dbo.vwLocationProductServices AS vlpstype ON vlpstype.LocationProductRecID = ljvlp.LocationProductRecID WHERE (ljvlp.Archived IN ('N') OR ljvlp.Archived IS NULL) AND (ljvlp.StatusTypeName IN ('ACTIVE') OR ljvlp.StatusTypeName LIKE '%PARTICIP%' OR ljvlp.StatusTypeName IS NULL) AND (vlpstype.Archived IN ('N') OR vlpstype.Archived IS NULL)) AS vlp ON vlp.PracticeID = vp.PracticeID

Jeremy Lutz
Informatics Manager
Community Health Group
619-240-8914
jlutz@chgsd.com







x 'SITECODE' MISSING aka [Clinic QNXT provid] --,UPPER(LTRIM(RTRIM(vpl.Notes))) AS [Clinic QNXT provid] --aka SITE CODE OR ,UPPER(LTRIM(RTRIM(vploc.LocationNotes))) AS [Clinic QNXT provid] --aka SITE CODE

CAST( ... PRESENT YET 'ProviderDirectoryExpert' FAILED TO SEE DATA ...

PCP_ONLY_EVIPS_PROVDIR_MCAL_TEMPLATE_20171120.pdf
PCP_ONLY_EVIPS_PROVDIR_CMC_TEMPLATE_20171120.ps

This information should come from these fields. They will  still be comma delimited as in VIP system (example: P, EB, IB, W, R, E,T). They did not transfer over this field in this iteration, I have reported this as an error. I just want to make sure you have the logic  in place. Sandra manually entered a few records on Friday that you  can get results.

---Formerly Address.userdef_2
select ClassOrCategory,practiceid, practiceName, LocationID, LocationName, ServiceTypeName, ServiceCategoryTypeName
from eVips_chgcv.dbo.vwlocationservices
where ServiceTypeName = 'Pharmacy Type'

,UPPER(LTRIM(RTRIM(vlspharm.ServiceCategoryTypeName))) AS [vlspharmPHARMACYTYPENAME],vls.ClassOrCategory --DEFINE PHARM TYPE(s)
	LEFT JOIN (SELECT * FROM eVips_chgcv.dbo.vwLocationServices WHERE ServiceTypeName LIKE '%PHARMACY%') AS vlspharm ON vls.PracticeID = vp.PracticeID --DEFINE PHARM SUBSET CHAPTER(s) 

					Values:
					CLNC = Clinic
					CP = Compound Pharmacy
					HI = Home Infusion
					IP = Inpatient Pharmacy
					ITU = Indian Tribal Urban
					LTC = Long Term Care
					MBR = Member
					MO = Mail Order
					NPDS = Non-Dispensing Pharmacy Site
					R = Retail
					SP = Specialty Pharmacy

SELECT DISTINCT [Pharmacy TYpe(s)] FROM INFORMATICS.dbo.TimelyAccessPHARM
SELECT DISTINCT [Pharmacy Footnote(s)] FROM INFORMATICS.dbo.TimelyAccessPHARM

					Pharmacy TYpe(s)
					NULL
					CP, MBR
					HI
					HI, CP
					IP
					IP, CP
					ITU, MBR
					LTC
					LTC, CP
					LTC, CP, R
					MO
					R
					R, CLNC, MBR
					R, CP
					R, CP, MBR
					R, HI
					R, HI, CP
					R, LTC
					R, LTC, CP
					R, MBR
					R,CP
					SP

					Pharmacy Footnote(s)
					NULL
					ESP
					ESP, DT
					ESP, HD
					ESP, MBR
					HD







x 'YOUNG LADY LAURA(s) GAH(s)' - Criteria:
Product record with a focus like ‘%GAH%’ (vwLocationproducts.Focus)
AND  ‘HOSPITAL’ service record  (vwLocationProductServices.ServiceTypeName)
AND  Not Archived (Archived = ‘N’)

					Select  p.practiceid,  g.PracticeName, g.TaxIDnumber as Practice_TaxID,  g.NationalProviderID as Practice_NPI, g.PracticeStatus, g.applicationstatus as Practice_ApplicationStatus, g.archived as Practice_archived,
					l.locationCode, l.LocationName, l.locationTypeName, l.NationalProviderID as Location_NPI, l.archived as Location_Archived, 
					p.ProductName,  p. statusTypeName, p.focus, p.archived as Plan_Archived, p.ProductPanelStatusTypeName, s.ServiceTypeName
					from evips_chgcv.dbo.vwLocationproducts p
					LEFT JOIN evips_chgcv.dbo.vwLocationProductServices s on s.LocationProductRecID = p.LocationProductRecID AND s.archived ='N'
					LEFT JOIN evips_chgcv.dbo.vwpractices g on g.practiceid = p.practiceid and g.archived = 'N'
					LEFT JOIN evips_chgcv.dbo.vwPracticeLocations l on l.LocationID = p.LocationID and l.archived = 'N'
					WHERE p.archived = 'N'
					AND s.ServiceTypeName = 'HOSPITAL'
					AND p.focus like '%GAH%'
					ORDER by  p.PracticeName, p.PracticeId, p.practiceTypeName

SELECT PracticeName,EntityName,plan_type,[Type of Service],ServiceCategoryTypeName,NPIis,Code2,Code1,[Type of Service FOCUS],* 
FROM ##INNETWORK_FAC
WHERE UPPER(LTRIM(RTRIM(PracticeID))) IN ('2308344','2302094') --(GAH) --('2302094') --(SNF) --('2308344') --(GAH)
ORDER BY PracticeID

					SELECT PracticeName,EntityName,plan_type,[Type of Service],ServiceCategoryTypeName,NPIis,Code2,Code1,[Type of Service FOCUS],* 
					FROM INFORMATICS.dbo.TimelyAccessFAC
					WHERE UPPER(LTRIM(RTRIM(PracticeID))) IN ('2308344','2302094') --(GAH) --('2302094') --(SNF) --('2308344') --(GAH)
					ORDER BY PracticeID

SELECT * FROM INFORMATICS.dbo.PROVDIR_HOS WHERE lookup_key IN ('2308344','2302094') --(GAH) --('2302094') --(SNF) --('2308344') --(GAH)
SELECT * FROM INFORMATICS.dbo.PROVDIR_SNF WHERE lookup_key IN ('2308344','2302094') --(GAH) --('2302094') --(SNF) --('2308344') --(GAH)
SELECT * FROM INFORMATICS.dbo.TimelyAccessPHARM		

select focus, practicename, locationname, archived, * 
from vwlocationproducts
where practiceid = '2308344'
and archived = 'N'

,UPPER(LTRIM(RTRIM(vlp.StatusTypeName))) AS [vlpSTATUSTYPENAME]
,UPPER(LTRIM(RTRIM(vlp.ServiceTypeName))) AS [vlpSERVICETYPENAME]







--INTO ##INNETWORK_FAC
--SELECT * --CHECK 1st
 SELECT UPPER(LTRIM(RTRIM(vlp.StatusTypeName))) AS [vlpSTATUSTYPENAME],UPPER(LTRIM(RTRIM(vlp.ServiceTypeName))) AS [vlpSERVICETYPENAME]tos.Focus,vlsfocus.Code1,vlsfocus.Code2,vp.Archived,vp.PracticeStatus,vp.ApplicationStatus,vpl.Archived,vpl.LocationTypeName,vp.PracticeTypeName,* --CHECK 1st
--SELECT * FROM eVips_chgcv.dbo.vwPracticeLocations --CHECK 1st
--SELECT DISTINCT PracticeTypeName FROM eVips_chgcv.dbo.vwPracticeLocations --CHECK 1st UPPER(LTRIM(RTRIM(vpl.PracticeTypeName))) AS [Type of Service]
--SELECT * FROM eVips_chgcv.dbo.vwEntityAssignments WHERE UPPER(LTRIM(RTRIM(TableName))) LIKE '%Practice%' AND UPPER(LTRIM(RTRIM(EntityName))) LIKE '%MED%IMPA%' --CHECK 1st
FROM eVips_chgcv.dbo.vwPractices AS vp
		LEFT JOIN (SELECT * FROM eVips_chgcv.dbo.vwLocationServices WHERE ServiceTypeName LIKE '%GROUP%SPEC%') AS vls ON vls.PracticeID = vp.PracticeID --DEFINE FAC CHAPTER(s) 
			--AND vls.LocationID = vp.LocationID
		LEFT JOIN (SELECT * FROM eVips_chgcv.dbo.vwLocationServices WHERE ServiceTypeName LIKE '274%TYPE%SERV%') AS vlsfocus ON vlsfocus.PracticeID = vp.PracticeID --Alt EFFORT TO DEFINE FAC CHAPTER(s)
			--AND vlsfocus.LocationID = vp.LocationID
		LEFT JOIN (SELECT DISTINCT vlps.LocationID,vlps.PracticeID,vlps.ServiceTypeName,vlpB.Focus FROM eVips_chgcv.dbo.[vwLocationProducts] AS vlpB JOIN eVips_chgcv.dbo.[vwLocationProductServices] AS vlps on vlps.LocationProductRecID = vlpB.LocationProductRecID WHERE vlps.ServiceTypeName = 'GROUP SPECIALTY' AND vlpB.Focus like '%GAH%') AS tos ON tos.PracticeID = vp.PracticeID --YET ANOTHER Alt EFFORT TO DEFINE FAC CHAPTER(s)
		LEFT JOIN (SELECT * FROM eVips_chgcv.dbo.vwEntityAssignments WHERE TableName LIKE '%PRACTI%') AS vea ON vea.ProviderID = vp.PracticeID
	JOIN eVips_chgcv.dbo.vwPracticeLocations AS vpl ON vpl.PracticeID = vp.PracticeID
		LEFT JOIN (SELECT vlpstype.ServiceTypeName,ljvlp.* FROM eVips_chgcv.dbo.vwLocationProducts AS ljvlp LEFT JOIN evips_chgcv.dbo.vwLocationProductServices AS vlpstype ON vlpstype.LocationProductRecID = ljvlp.LocationProductRecID WHERE (ljvlp.Archived IN ('N') OR ljvlp.Archived IS NULL) AND (ljvlp.StatusTypeName IN ('ACTIVE') OR ljvlp.StatusTypeName LIKE '%PARTICIP%' OR ljvlp.StatusTypeName IS NULL) AND (vlpstype.Archived IN ('N') OR vlpstype.Archived IS NULL)) AS vlp ON vlp.PracticeID = vp.PracticeID
		LEFT JOIN INFORMATICS.dbo.ZIP_CODES AS zip ON SUBSTRING(LTRIM(RTRIM(zip.ZipCode)),1,5) COLLATE DATABASE_DEFAULT = CASE
WHEN SUBSTRING(LTRIM(RTRIM(vpl.ZipCode)),1,1) = '0'
THEN '0'+ SUBSTRING(LTRIM(RTRIM(vpl.ZipCode)),2,4)
WHEN SUBSTRING(LTRIM(RTRIM(vpl.ZipCode)),1,1) = '00'
THEN '00'+ SUBSTRING(LTRIM(RTRIM(vpl.ZipCode)),3,3)
ELSE  SUBSTRING(LTRIM(RTRIM(vpl.ZipCode)),1,5) 
END
WHERE vp.Archived IN ('N') --WITH eVIPS LOGICAL BINARY OPTION(s) IN USE •	Must not be archived 
	 AND (vp.PracticeStatus IN ('ACTIVE','NA') --•	Contract Status must be Active
		 OR vp.PracticeStatus IS NULL)
	 AND (vp.ApplicationStatus IN ('CONTRACTED','NA') --•	Application Status must be contractedarchived
		 OR vp.ApplicationStatus IS NULL)		
	--AND UPPER(LTRIM(RTRIM(vp.PracticeTypeName))) LIKE '%FACILIT%'
	 AND vpl.Archived IN ('N') --WITH eVIPS LOGICAL BINARY OPTION(s) IN USE •	Must not be archived
	AND vlp.ServiceTypeName LIKE '%HOSPITAL%'







-- INTO INFORMATICS.dbo.TimelyAccessFAC
SELECT * --CHECK 1st
--SELECT DISTINCT [DEGREE DESCRIPTION] --CHECK 1st
--SELECT DISTINCT [Clinic Name] --CHECK 1st
--SELECT DISTINCT plan_type --CHECK 1st
--SELECT DISTINCT [Type of Service] --CHECK 1st ,UPPER(LTRIM(RTRIM(vpl.PracticeTypeName)))AS [Type of Service] --,'Free Standing - Primary and/or Specialty Care' AS [Type of Service]
FROM ##INNETWORK_FAC
WHERE
( --INITIATE ...
	(EntityName IS NULL
		OR UPPER(LTRIM(RTRIM(EntityName))) NOT LIKE '%MED%IMPA%') --see 'TimelyAccessPHARM' --,vea.TableName,vea.EntityCode
	AND (plan_type IS NULL --FAC(s) ;WITH() ,UPPER(LTRIM(RTRIM(vp.PracticeTypeName))) AS [plan_type]
		OR UPPER(LTRIM(RTRIM(plan_type))) NOT IN ('COMMUNITY CLINIC')) --see 'TimelyAccessCLINIC' --,UPPER(LTRIM(RTRIM(vp.PracticeTypeName))) AS [plan_type]
	--AND UPPER(LTRIM(RTRIM([Type of Service]))) IN ('AMB',' ASC','CBAS','DLC','DME','DXC','HDM','HHC','IHSS','NF','RCF','SNF','URC','CL','HPM','HSPC','HOSPICE')) ,'Free Standing - Primary and/or Specialty Care' AS [Type of Service] ??? per Network Adequacy REVIEW WITH TEAM ON 20170302...ADD HOSPICE facility(-ies) per SC ON 20161012 Walter/Maryanne/Kelly Question 13 is asking for the display in printed and online for 2 new sections (hospice & inpatient rehabilitation).  I will send specs on hospice. 	--,UPPER(LTRIM(RTRIM(vpl.PracticeTypeName)))AS [Type of Service]
) --CONCLUDE ...
OR (UPPER(LTRIM(RTRIM(NPIis))) IN ('1528271186','1396743225','1598106544','1598882169','1699094003','1568659233','1316225147')) --Long-Term Services and Supports (LTSS) & Nursing Facilities - Residential Care (RCF))
OR (UPPER(LTRIM(RTRIM(plan_type))) LIKE '%ANC%'
	AND UPPER(LTRIM(RTRIM([Type of Service]))) IN ('DME')) -- DME(s)???
OR (UPPER(LTRIM(RTRIM(NPIis))) IN ('1073626784','1669569802','1750441309','1164456190','1386643856','1073626784','1821108028','1821108028')) --FIND THE DME(s)???







-- INTO INFORMATICS.dbo.PROVDIR_HOS
SELECT * --CHECK 1st
--SELECT DISTINCT HospitalName --CHECK 1st
--SELECT DISTINCT [Type of Service] FROM INFORMATICS.dbo.TimelyAccessFAC ORDER BY TypeOfLicensure --CHECK 1st
--SELECT DISTINCT plan_type FROM INFORMATICS.dbo.TimelyAccessFAC ORDER BY plan_type --CHECK 1st
FROM INFORMATICS.dbo.TimelyAccessFAC AS spe
--WHERE UPPER(LTRIM(RTRIM(spe.HospitalName))) LIKE '%ALVAR%HOSP%'
WHERE (UPPER(LTRIM(RTRIM(ServiceCategoryTypeName))) LIKE 'HOSPITAL%'
	AND spe.plan_type = 'FACILITY')
			-- AND UPPER(LTRIM(RTRIM(spe.group_name))) LIKE '%FAC%'
			-- AND [Hospital OSHPD ID] IS NOT NULL
OR UPPER(LTRIM(RTRIM(spe.NPIis))) IN ('1063589620','1154304475','1184722779','1205816931','1265468946','1356410351','1376513754','1396728630','1407839921','1457321317','1528041811','1598722027','1639172133','1659354173','1659359446','1700829199','1710065933','1801861190','1841233780','1841277704','1962438200') --ATTEMPT TO MIMIC VIP LOGIC ... ,vls.ServiceTypeName,vls.ServiceCategoryTypeName --DEFINE FAC CHAPTER(s) ;WITH SELECT DISTINCT ServiceTypeName,[ServiceCategoryTypeName] FROM SQL07.evips_chgcv.dbo.vwLocationServices WHERE UPPER(LTRIM(RTRIM(ServiceTypeName))) LIKE '%GROUP%SPEC%'







-- INTO INFORMATICS.dbo.PROVDIR_SNF
SELECT * --CHECK 1st
--SELECT DISTINCT HospitalName --CHECK 1st
--SELECT DISTINCT [Type of Service] FROM INFORMATICS.dbo.TimelyAccessFAC ORDER BY TypeOfLicensure --CHECK 1st
--SELECT DISTINCT plan_type FROM INFORMATICS.dbo.TimelyAccessFAC ORDER BY plan_type --CHECK 1st
FROM INFORMATICS.dbo.TimelyAccessFAC AS spe
WHERE ((UPPER(LTRIM(RTRIM(spe.Code2))) LIKE '%SKILL%NURS%FAC%'
	OR UPPER(LTRIM(RTRIM(ServiceCategoryTypeName))) LIKE '%SKILL%NURS%FAC%'
	OR [Type of Service FOCUS] LIKE '%SNF%')
		AND spe.plan_type = 'FACILITY'
	-- AND UPPER(LTRIM(RTRIM(spe.group_name))) LIKE '%FAC%'
	-- AND [Hospital OSHPD ID] IS NOT NULL
) --ATTEMPT TO MIMIC VIP LOGIC ...
OR UPPER(LTRIM(RTRIM(spe.NPIis))) IN ('1003098906','1003852666','1013953199','1023048295','1083727093','1174926448','1184607418','1184628554','1225028327','1235133687','1255344800','1255499174','1265415749','1265462436','1265823264','1265879795','1275513293','1275533929','1285061085','1336134204','1356345706','1386657054','1386681286','1407035512','1447653340','1457486078','1477566024','1487640066','1497759856','1518146620','1538142369','1568484517','1578521274','1578576138','1598871808','1619947090','1629129267','1649375403','1659369262','1700973963','1710065933','1720335789','1730176538','1760709687','1790789170','1811942063','1811963028','1861491490','1871522672','1881684900','1942213681') --ATTEMPT TO MIMIC VIP LOGIC ... 
--ORDER BY spe.LastName+' '+spe.HOSPabbrev+' ID# '+spe.provider_no AND spe.[Type of Service] = 'SNF'







INTO INFORMATICS.dbo.TimelyAccessPHARM
--SELECT * --CHECK 1st
--SELECT * FROM eVips_chgcv.dbo.vwEntityAssignments WHERE UPPER(LTRIM(RTRIM(TableName))) LIKE '%Practice%' AND UPPER(LTRIM(RTRIM(EntityName))) LIKE '%MED%IMPA%'
--SELECT DISTINCT [DEGREE DESCRIPTION] --CHECK 1st
--SELECT DISTINCT [Pharmacy Name],NPIis,Address --CHECK 1st
--SELECT DISTINCT plan_type --CHECK 1st
--SELECT DISTINCT [Type of Service] --CHECK 1st ,UPPER(LTRIM(RTRIM(vpl.PracticeTypeName)))AS [Type of Service] --,'Free Standing - Primary and/or Specialty Care' AS [Type of Service]
FROM ##INNETWORK_FAC
WHERE
( --INITIATE ...
UPPER(LTRIM(RTRIM(EntityName))) LIKE '%MED%IMPA%' --AFFIRMATIVE --,vea.TableName,vea.EntityCode,vea.EntityName,vea.EntityTypeCode,vea.EntityTypeName
	AND (plan_type IS NULL --FAC(s) ;WITH() ,UPPER(LTRIM(RTRIM(vp.PracticeTypeName))) AS [plan_type]
	OR UPPER(LTRIM(RTRIM(plan_type))) NOT IN ('COMMUNITY CLINIC')) --see 'TimelyAccessCLINIC' --,UPPER(LTRIM(RTRIM(vp.PracticeTypeName))) AS [plan_type] 1003162868

) --CONCLUDE ...
OR UPPER(LTRIM(RTRIM([Pharmacy Name])))  LIKE '%PHARM%'
OR UPPER(LTRIM(RTRIM(NPIis))) IN ('1003162868','1003822305','1003925520','1013252626','1013265081','1013359462','1013951375','1013953801','1023033628','1023255361','1033136361','1033228556','1043253214','1043254402','1043346190','1043380959','1043603780','1043665425','1053354803','1053378760','1053490797','1053646265','1063454882','1063468437','1063527216','1063671535','1073530200','1073544888','1073707683','1073807434','1073879490','1073946489','1083645899','1083659981','1083786867','1083941637','1093795577','1104216571','1104217165','1104855139','1104860469','1104861095','1104869437','1104935550','1104936715','1114968021','1124053111','1124062476','1124220926','1124262316','1134141047','1134336928','1134528425','1144235151','1144247552','1144261058','1144333469','1144455957','1144574260','1154306231','1154336485','1154350106','1154350197','1154362028','1154366953','1154494987','1154764769','1164437406','1164451118','1164465332','1174569784','1174702484','1174802961','1174853113','1174988901','1184063471','1184646879','1184653198','1184997835','1194731489','1194760090','1194760199','1205008299','1205853629','1205925989','1205945680','1215187521','1215269022','1215962204','1215983861','1225067275','1225074818','1225075971','1225084759','1225147671','1225148828','1235145525','1235156647','1235170234','1235241225','1235280223','1235296583','1245251297','1245257708','1245259282','1245264175','1245273010','1245286954','1245376862','1245676667','1255644357','1265459499','1265474084','1265488266','1265864078','1275549578','1275562282','1275576001','1275577009','1275578171','1275643041','1275835332','1275884736','1285600072','1285670893','1285675199','1285676015','1285676858','1285679183','1295054716','1295085017','1295750891','1295752541','1295804144','1295844629','1295890473','1306005079','1306075890','1306880653','1306882931','1306956958','1316194525','1316227572','1316264559','1316964737','1316968399','1316976368','1316983927','1326077363','1326081191','1326152661','1326297839','1336180207','1336258821','1346267572','1346593118','1356325583','1356363048','1356450704','1356570170','1366458663','1366471377','1366487266','1376558650','1376559666','1376585190','1376933820','1386650679','1386688653','1396788147','1396944161','1396975975','1407216732','1407885452','1407938285','1417026758','1417932807','1417995655','1427004894','1427093327','1427206424','1427306489','1437538691','1447267380','1447292271','1447293030','1447371208','1447576699','1447591110','1457330300','1457395287','1457396350','1457397515','1457521239','1457527145','1467467746','1467496737','1467497354','1467498527','1467536326','1477570729','1477597748','1477738359','1487763843','1487849246','1487900429','1487949319','1497778773','1497797690','1497798755','1497865091','1497938336','1508094558','1508802109','1508807504','1508812520','1508877002','1508970849','1518072545','1518300532','1518900307','1518982115','1528480613','1538103361','1538278965','1538279138','1548204373','1548205446','1548269533','1548282247','1548423601','1558307611','1558781005','1568571990','1568608214','1568721355','1568896280','1578764023','1588607337','1588697155','1588734123','1588751945','1588752687','1588774194','1588776579','1588816474','1598133829','1598143133','1598703647','1598706400','1598773566','1598786576','1598874950','1598874968','1598874984','1598875197','1609116649','1609201706','1609817576','1609985043','1609986207','1619080942','1619343357','1619912417','1619982626','1619994845','1629010442','1629086830','1629171038','1629285382','1629296041','1629357355','1629473988','1639115793','1639184914','1639567605','1649216706','1649307802','1649356650','1649639089','1649655267','1649695800','1659312577','1659315901','1659436079','1659673739','1669509824','1669581948','1669617734','1669779435','1679510176','1689043002','1689610214','1689674889','1689705873','1689741175','1699716696','1700214046','1700803939','1700822343','1700891710','1700967155','1710097316','1710902317','1710904958','1710998190','1730195025','1730234493','1730273582','1730432469','1740214790','1740227289','1740227727','1750322665','1750399739','1750599684','1760407365','1760472716','1760850010','1770527020','1770529778','1770692162','1780613737','1780627042','1780690073','1780849588','1780966507','1790100642','1790189223','1790726669','1790734036','1790783025','1790790707','1790894244','1790928810','1801256789','1801802103','1801813035','1801906409','1811048069','1821017096','1821118910','1821249327','1821395609','1831130756','1831133271','1831398676','1831546464','1841205127','1841309218','1841309366','1851302368','1851318182','1851400287','1851430805','1851593560','1861435125','1861438921','1861484214','1871571307','1871693796','1881631703','1881704435','1881727634','1881977833','1891724811','1891741898','1891804332','1891826145','1891876249','1891942108','1891982096','1902104367','1902235047','1902811284','1902828502','1912016437','1912922519','1912942814','1912942913','1922041706','1922043819','1932124534','1932126265','1932218211','1932218393','1932332343','1932485307','1932547874','1952322935','1952328270','1952345316','1952429821','1962429381','1962511436','1962511451','1962512566','1962517995','1962730044','1962753061','1962809780','1962957514','1982626677','1982633921','1992720593','1992727697','1992816094','1992956700') --ATTEMPT TO MIMIC VIP LOGIC ...








-- INTO INFORMATICS.dbo.PROVDIR_PHARM
SELECT * --CHECK 1st
--SELECT DISTINCT group_name --CHECK 1st
FROM INFORMATICS.dbo.TimelyAccessPHARM AS spe
WHERE spe.[Pharmacy Type(s)] LIKE '%MO%' --MAIL ORDER PHARMACY(-ies) UPPER(LTRIM(RTRIM(address.userdef_2))) AS [Pharmacy Type(s)]
UNION ALL --VERTICAL() w UNION ALL()  - ROW(s) --STACK
----------------INTO INFORMATICS.dbo.PROVDIR_PHARM
--SELECT * --CHECK 1st
--SELECT DISTINCT group_name --CHECK 1st
FROM INFORMATICS.dbo.TimelyAccessPHARM AS spe
WHERE ((spe.[Pharmacy Type(s)] NOT LIKE '%MO%' --EXCLUDE MAIL ORDER PHARMACY(-ies) UPPER(LTRIM(RTRIM(address.userdef_2))) AS [Pharmacy Type(s)]
	OR spe.[Pharmacy Type(s)] IS NULL)
	 AND (spe.REGION LIKE 'SD%' --UPPER(LTRIM(RTRIM(address.county))) AS [REGION] NEED 'MAIL ORDER' however
		 OR spe.REGION  LIKE '%SAN%DIEG%'
		OR spe.REGION IS NULL)) --UPPER(LTRIM(RTRIM(address.county))) AS [REGION] NEED 'MAIL ORDER' however
 --OR UPPER(LTRIM(RTRIM(spe.NPIis))) IN ('') --see TimelyAccessPHARM WHERE CLAUSE FOR NPI(s) FROM VIP ... ATTEMPT TO MIMIC VIP LOGIC ...
 
 
 
 
 
 
 
 WHERE LTRIM(RTRIM(mcred.npi)) IN ('1336107580') --WHERE... OR... Rancho Bernardo Surgery Center

SELECT * FROM INFORMATICS.dbo.TimelyAccessFAC WHERE LTRIM(RTRIM(NPIis)) IN ('1336107580') --WHERE... OR... Rancho Bernardo Surgery Center
SELECT * FROM INFORMATICS.dbo.PROVDIR_ASC WHERE LTRIM(RTRIM(NPIis)) IN ('1336107580') --WHERE... OR...Rancho Bernardo Surgery Center







'VSP PROV ISSUE'(s) - SELECT * FROM INFORMATICS.dbo.PROVDIR_AHP WHERE INDEXNM LIKE '%COLEM%BROO%'
SELECT * FROM INFORMATICS.dbo.PROVDIR_VSP WHERE INDEXNM LIKE '%COLEM%BROO%'

ADDRESS LIKE '%VSP%'

--VSP Entity Assignments
select p.practitionerid, p.lastName, p.FirstName, p.StatusTypeName, ea.entityName, ea.EntityCode,  p.productName, p.practicename, p.LocationName, p.LineNumber1, p.LineNumber2, p.city, p.state, p.ZipCode
from vwPractitionerProducts p
LEFT JOIN  vwEntityAssignments ea on p.PractitionerProductRecID = ea.Parentrecid 
                                                                     AND ea.TableName = 'PractitionerProducts'
where ea.archived ='N'
and p.archived = 'N'
and p.StatusTypeName Like 'ACTIVE%' 
 and  practitionerid = '4364276'

ea.ParentRecID = vpp.PractitionerProductRecID

Locationname

SELECT DISTINCT ea.ProviderID,ea.TableName,ea.EntityCode,ea.EntityName,ea.EntityTypeCode,ea.EntityTypeName ,*
FROM eVips_chgcv.dbo.vwEntityAssignments AS ea 
	JOIN eVips_chgcv.dbo.vwPractitionerProducts AS vpp ON UPPER(LTRIM(RTRIM(vpp.PractitionerProductRecID))) = UPPER(LTRIM(RTRIM(ea.ParentRecID))) --VSP / PHARM
WHERE UPPER(LTRIM(RTRIM(ea.TableName))) LIKE '%Practit%Product%'

LEFT JOIN (SELECT DISTINCT ProviderID,TableName,EntityCode,EntityName,EntityTypeCode,EntityTypeName FROM eVips_chgcv.dbo.vwEntityAssignments WHERE UPPER(LTRIM(RTRIM(TableName))) LIKE '%Practit%Product%') AS vea ON UPPER(LTRIM(RTRIM(vea.ProviderID))) = UPPER(LTRIM(RTRIM(vpd.PractitionerID))) --ProviderID = PractitionerID WHERE UPPER(LTRIM(RTRIM(vea.TableName))) LIKE '%Practit%' OR  ProviderID = PracticeID WHERE UPPER(LTRIM(RTRIM(vea.TableName))) LIKE '%Practice%'

--SELECT * --CHECK 1st
--SELECT * FROM INFORMATICS.dbo.ZIP_CODES--CHECK 1st
--SELECT DISTINCT SpecialtyCode,SpecialtyName FROM eVips_chgcv.dbo.vwPractitionerSpecialties ORDER BY SpecialtyCode,SpecialtyName--CHECK 1st
FROM eVips_chgcv.dbo.vwPractitionerDemographics AS vpd
	JOIN eVips_chgcv.dbo.vwPractitionerProducts AS vpp ON UPPER(LTRIM(RTRIM(vpp.PractitionerID))) = UPPER(LTRIM(RTRIM(vpd.PractitionerID))) --aka cert_provider
		-- AND UPPER(LTRIM(RTRIM(vpp.ProductID))) = UPPER(LTRIM(RTRIM(vpps.ProductID))) --aka cert_provider
	JOIN eVips_chgcv.dbo.vwPractitionerProductSpecialties AS vpps ON UPPER(LTRIM(RTRIM(vpps.PractitionerProductRecID))) = UPPER(LTRIM(RTRIM(vpp.PractitionerProductRecID)))
		LEFT JOIN eVips_chgcv.dbo.vwPractitionerSpecialties AS vps ON UPPER(LTRIM(RTRIM(vps.PractitionerID))) = UPPER(LTRIM(RTRIM(vpd.PractitionerID)))	
			AND UPPER(LTRIM(RTRIM(vps.specialtycode))) = UPPER(LTRIM(RTRIM(vpps.specialtycode)))
		LEFT JOIN (SELECT DISTINCT ea.ProviderID,ea.TableName,ea.EntityCode,ea.EntityName,ea.EntityTypeCode,ea.EntityTypeName FROM eVips_chgcv.dbo.vwEntityAssignments AS ea WHERE UPPER(LTRIM(RTRIM(TableName))) LIKE '%Practit%') AS vea ON UPPER(LTRIM(RTRIM(vea.ProviderID))) = UPPER(LTRIM(RTRIM(vpd.PractitionerID))) --ProviderID = PractitionerID WHERE UPPER(LTRIM(RTRIM(vea.TableName))) LIKE '%Practit%' OR  ProviderID = PracticeID WHERE UPPER(LTRIM(RTRIM(vea.TableName))) LIKE '%Practice%'
	JOIN eVips_chgcv.dbo.vwPractitionerLocations AS vploc ON UPPER(LTRIM(RTRIM(vploc.PractitionerID))) = UPPER(LTRIM(RTRIM(vpd.PractitionerID)))
		AND UPPER(LTRIM(RTRIM(vploc.PracticeID))) = UPPER(LTRIM(RTRIM(vpp.PracticeID)))
		AND UPPER(LTRIM(RTRIM(vploc.LocationID))) = UPPER(LTRIM(RTRIM(vpp.LocationID)))
		-- AND UPPER(LTRIM(RTRIM(vploc.AddressID))) = UPPER(LTRIM(RTRIM(vpp.AddressID)))







'FOOTNOTE ADD'(ed) - Please add a footnote for the providers with these specialties for the pdf and for the online.  The footnote should state 

					'Services are provided in the home' ;WITH * Services are provided in the home OR IN CMC ^ Services are provided in the home

HDM      Home Delivered Meals
HHC       Home Health Care
IHSS       In Home Support Services

WHERE UPPER(LTRIM(RTRIM([Specialty]))) IN ('HDM','HHC','IHSS') --THE CODE...







'MINUTE(s) FROM CONVERSION STATUS MEETING' - ON 20171120 Hi,  I the meeting this afternoon we discussed where we are with this iteration, what is expected from the next iteration, the conversion schedule and a backup plan to be able to run the directories and 274/network files if the data isn’t 100% complete.  We agreed to perform a provider directory quality check, starting with the PCP chapter.  Walter will prepare the pdf so Credentialing can review the formatting with the existing providers.  Walter will also prepare the excel file so IS can test the online directory it in the test environment.

The team approved the timeline below, with running VIPs & eVIPs side by side if needed.

11/28-11/30        Next iteration
12/1                       Last VIPs data entry by full Cred Team (Sandra will make directory related updates in VIPs)
12/1                       IS to copy VIPs production to VIPs test and send to Vistar
12/7                       Directory from VIPs
12/8                       Vistar to send eVIPs production files
12/8                       IS to prepare a production file for data entry (Only Credentialing will have access to front end data entry)
12/8                       IS to prepare a test file for everyone to access
12/9-12/14          Cred Team to finish eVIPs production file for the directory
12/12-12/14        On-site Training
12/14                     Directory from VIPs
12/15                     “GO LIVE”
12/21                     Goal:  Directory from eVIPs after 100% accuracy review.  (Note:  The directory will be produced from VIPs until it is 100% correct from eVIPs.)







'CHECK MINUTE CLINIC'(s) - ;WITH lookup_key IN ('138699')
SELECT * FROM INFORMATICS.dbo.TimelyAccessFAC WHERE lookup_key IN ('138699')

SELECT * FROM INFORMATICS.dbo.TimelyAccessFAC WHERE LastName LIKE '%MINUTE%' AND CParchive_status = 'Y'
SELECT * FROM INFORMATICS.dbo.PROVDIR_MIN
SELECT * FROM INFORMATICS.dbo.TimelyAccessFAC WHERE lookup_key IN ('138699')







'PROVIDER DIRECTORY' - FILE
MODIFY PROVDIR.xlsx

x PROVDIR CROSS CHECK

Hi,  I was reviewing my notes from out eVIPs directory meeting for community clinics, I’ve updated the province field for all of the sites with “O or P” at the end of the group code.  I thought we were only putting CC in the main site so there would be duplicates.  Also, there are 3 new CC sites.  We will work on getting their license # and OSHPD numbers before this Wednesday.  Horacio, please follow up with the specialists.

Sandra Coleman, MBA, Credentialing Manager
Community Health Group
2420 Fenton Street, Suite 100, Chula Vista CA 91914
619 498 6438 phone
619 382 1211 fax
scolem@chgsd.com







'CREATE SPECIAL xlsx FOR YOUNG LADY ELIZABETH & YOUNG LADY KELLY' - DUE BY 20171122
x Hi Elizabeth,  Prior to you uploading the PD DHCS will have to complete a full review of CHG’s current PD, as they last Revision was for 06/15 Provider Directory.  Additionally, DHCS/Managed Care Operations Division (MCOD) has deployed a new internal process for Contract Managers to review/verify plan Provider Directories (PD). This process requires that plans provide the listing of Providers and a few other data elements contained in the respective PD submission; placed in Excel format.  Below I have provided a screenshot of the layout and data elements. Please disregard “Contact Name” as this is a field MCOD uses internally when calling the provider. For clarity, the providers should be listed on the spreadsheet in the same order that they are listed in the PD, from beginning to end, not by provider specialty. This ensures proper randomization when validating the PD. I will be assisting Manuel with reviewing the most recent CHG PD that was submitted on 10/30/17. I will need the plan to follow-up with the Excel spreadsheet. Please provide the spreadsheet by COB 11/10/17. I would like to complete my review and validation by 2/10/17.  If you have any questions, please do not hesitate to contact me. 

 'SUBJECT: SPECIAL EXCEL'

-- ==========================================================
	--GENERATE SPECIAL 'PDF IN EXCEL FORMAT '--
-- ==========================================================
-- USE: '=IFERROR(VLOOKUP(UPPER(TRIM(CLEAN(A3)))&UPPER(TRIM(CLEAN(D3))),indexnmid,6,FALSE),IFERROR(VLOOKUP(UPPER(TRIM(CLEAN(A3)))&UPPER(TRIM(CLEAN(D3))),provnmid,5,FALSE),""))'

-----------------------------------------------------------------------------------------------------------------------------
	-- Error Trapping: Check If Permanent Table(s) Already Exist(s) And Drop If Applicable --
-----------------------------------------------------------------------------------------------------------------------------
IF OBJECT_ID (N'INFORMATICS.dbo.PROVDIR_EXCEL', N'U') IS NOT NULL --STATIC [TABLE_NAME] CLEANSE()
BEGIN

		DROP TABLE INFORMATICS.dbo.PROVDIR_EXCEL --#TableName is a local temporary table visible only in the current session; ##TableName is a global temporary table visible to all sessions IN 'tempdb'

END

SELECT DISTINCT [INDEXNM],[Address],[CSZ] 
INTO INFORMATICS.dbo.PROVDIR_EXCEL --'Prov Directory by Contracting Entity'
--SELECT * --CHECK 1st
FROM INFORMATICS.dbo.PROVDIR_PCP --PROV(s)
UNION -- VERTICAL() STACK ALL()
SELECT DISTINCT [INDEXNM],[Address],[CSZ] FROM INFORMATICS.dbo.PROVDIR_NPMP --MIDLEVEL(s) NPMP
UNION -- VERTICAL() STACK ALL()
SELECT DISTINCT [INDEXNM],[Address],[CSZ] FROM INFORMATICS.dbo.PROVDIR_SPE --PROV(s)
UNION -- VERTICAL() STACK ALL()
SELECT DISTINCT [INDEXNM],[Address],[CSZ] FROM INFORMATICS.dbo.PROVDIR_MH --PROV(s)
UNION -- VERTICAL() STACK ALL()
SELECT DISTINCT [INDEXNM],[Address],[CSZ] FROM INFORMATICS.dbo.PROVDIR_AHP --PROV(s)
UNION -- VERTICAL() STACK ALL()
SELECT DISTINCT [INDEXNM],[Address],[CSZ] FROM INFORMATICS.dbo.PROVDIR_VSP --PROV(s)
UNION -- VERTICAL() STACK ALL()
SELECT DISTINCT [INDEXNM],[Address],[CSZ] FROM INFORMATICS.dbo.PROVDIR_HOS --FAC(s)
UNION -- VERTICAL() STACK ALL()
SELECT DISTINCT [INDEXNM],[Address],[CSZ] FROM INFORMATICS.dbo.PROVDIR_HOSGENERALACUTE --HOSGAH
UNION -- VERTICAL() STACK ALL()
SELECT DISTINCT [INDEXNM],[Address],[CSZ] FROM INFORMATICS.dbo.PROVDIR_HOSADDITIONAL --HOSADD
UNION -- VERTICAL() STACK ALL()
SELECT DISTINCT [INDEXNM],[Address],[CSZ] FROM INFORMATICS.dbo.PROVDIR_SNF
UNION -- VERTICAL() STACK ALL()
SELECT DISTINCT [INDEXNM],[Address],[CSZ] FROM INFORMATICS.dbo.PROVDIR_RCF
UNION -- VERTICAL() STACK ALL()
SELECT DISTINCT [INDEXNM],[Address],[CSZ] FROM INFORMATICS.dbo.PROVDIR_HOSPICE --ADD HOSPICE facility(-ies) per SC ON 20161012 Walter/Maryanne/Kelly Question 13 is asking for the display in printed and online for 2 new sections (hospice & inpatient rehabilitation).  I will send specs on hospice. 
UNION -- VERTICAL() STACK ALL()
SELECT DISTINCT [INDEXNM],[Address],[CSZ] FROM INFORMATICS.dbo.PROVDIR_IPREHAB --DUPLICATE 'PROVDIR_SNF' --ADD HOSPICE facility(-ies) per SC ON 20161012 Walter/Maryanne/Kelly Question 13 is asking for the display in printed and online for 2 new sections (hospice & inpatient rehabilitation).  I will send specs on hospice. 
UNION -- VERTICAL() STACK ALL()
SELECT DISTINCT [INDEXNM],[Address],[CSZ] FROM INFORMATICS.dbo.PROVDIR_CBAS --INCLUDE ALL
UNION -- VERTICAL() STACK ALL()
SELECT DISTINCT [INDEXNM],[Address],[CSZ] FROM INFORMATICS.dbo.PROVDIR_HDM --INCLUDE ALL
UNION -- VERTICAL() STACK ALL()
SELECT DISTINCT [INDEXNM],[Address],[CSZ] FROM INFORMATICS.dbo.PROVDIR_HHC --INCLUDE ALL
UNION -- VERTICAL() STACK ALL()
SELECT DISTINCT [INDEXNM],[Address],[CSZ] FROM INFORMATICS.dbo.PROVDIR_IHSS --[Participating Network] aka LINE_OF_BUSINESS DISTINCTION NOW PRESENT
UNION -- VERTICAL() STACK ALL()
SELECT DISTINCT [INDEXNM],[Address],[CSZ] FROM INFORMATICS.dbo.PROVDIR_ASC --was AMBSC
UNION -- VERTICAL() STACK ALL()
SELECT DISTINCT [INDEXNM],[Address],[CSZ] FROM INFORMATICS.dbo.PROVDIR_DXC
UNION -- VERTICAL() STACK ALL()
SELECT DISTINCT [INDEXNM],[Address],[CSZ] FROM INFORMATICS.dbo.PROVDIR_LAB --LAB
UNION -- VERTICAL() STACK ALL()
SELECT DISTINCT [INDEXNM],[Address],[CSZ] FROM INFORMATICS.dbo.PROVDIR_DLC
UNION -- VERTICAL() STACK ALL()
SELECT DISTINCT [INDEXNM],[Address],[CSZ] FROM INFORMATICS.dbo.PROVDIR_URC
UNION -- VERTICAL() STACK ALL()
SELECT DISTINCT [INDEXNM],[Address],[CSZ] FROM INFORMATICS.dbo.PROVDIR_MIN --MINUTE CLINIC(s)
UNION -- VERTICAL() STACK ALL()
SELECT DISTINCT [INDEXNM],[Address],[CSZ] FROM INFORMATICS.dbo.PROVDIR_PPH --PPH (Palomar Pomerado Healthcare) EXPRESS
UNION -- VERTICAL() STACK ALL()
SELECT DISTINCT [INDEXNM],[Address],[CSZ] FROM INFORMATICS.dbo.PROVDIR_CLINIC --CONSOLIDATE LANGUAGE(s) WITH JL_Languages_...sql ADD BACK [CULTURAL COMPETENCE]
UNION -- VERTICAL() STACK ALL()
SELECT DISTINCT [INDEXNM],[Address],[CSZ] FROM INFORMATICS.dbo.PROVDIR_PHARM --INCLUDE ALL

					SELECT * FROM INFORMATICS.dbo.PROVDIR_EXCEL --'Prov Directory by Contracting Entity'

x Hi All, As discussed, here are the requirements for approval.  I will be looking for approvals from: Sandra, Elizabeth and Roberto. Thank you all and please let me know if you have any questions. Kelly 

--This is NPI 1710187299 supposed to have empty license no?

--Looks like it's empty - SELECT CA_License,  * FROM sql01.INFORMATICS.dbo.PROVDIR_HHC WHERE npiis = 1710187299

SELECT * FROM INFORMATICS.dbo.PROVDIR_HHC WHERE NPIis IN ('1710187299')
SELECT LTRIM(RTRIM(mcred.npi)),mcred.state_license,* FROM VIP.dbo.master_cred AS mcred WHERE mcred.npi IN ('1710187299')
