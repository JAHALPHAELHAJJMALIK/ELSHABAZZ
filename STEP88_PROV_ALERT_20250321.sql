-- ====================================================================
	-- PROVIDER ALERT LISTING FOR PROV(s) --
-- ====================================================================
JAH CHARINDEX() FIND() SEARCH() 'NEW MS OUTLOOK CONTACT', FROM:WALTER "*ALERT*"

		USE 'Fax Blast Provider Alert' <FaxBlastProviderAlert@chgsd.com>

		USE https://chgsd.service-now.com/
		-- USE http://efax01 
		USE http://faxcore/login/?ReturnUrl=%2Fuser%2F

				UID: em
				em: CHGSD
				PW: CHGSD CREDENTIAL(S)
		
				/* ... the Provider Alert (Fax Blast) was executed / is in progress AS OF: 20250513 - TRANSACTION LOG: http://efax01 

				Sir may I trouble you to assist me with getting a new MS Outlook Group Contact (email address) created?

				TO: 'Fax Blast Provider Alert' <FaxBlastProviderAlert@chgsd.com>
				CC: 'Informatics' <Informatics@chgsd.com>; 'Manuel Pena' <mpena@chgsd.com>; 'Kelly Bly' kbly@chgsd.com */
				
		USE a Known Test Fax Number (Optional): 
		Some services offer test fax numbers that automatically respond with a confirmation. For example:
			•	HP Test Fax Number (U.S.): +1-888-HPFaxme (+1-888-473-2963) 
					~ 8884732963@faxcore.chg.com - 'TEST'

-- ==========================================================
	-- BUILD / GENERATE PROVIDER FAX(es) --
-- ==========================================================
		SELECT 'see / REFERENCE "STEP88_GEOACCESS_PROVGROUP_...sql" AND OR "STEP88_REVIEW_PROVDIR_sql" AND OR "5_FIVE_ALERTS_...sql" EXEC IN SQLPRODAPP01;' AS [MESSAGE(S)]

---------------------------------------------------------------------------------------------------------------------------------
	-- Error Trapping: Check If Permanent Table(s) Already Exist(s) AND Drop If Applicable --
----------------------------------------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS #TEMPTABLEPROVALERT -- SQL Server 2016 AND later -- DYNAMIC tmp OR STATIC [TABLE] #TableName is a local temporary table visible only in the current session; #TableName is a GLOBAL temporary table visible to all sessions IN ('TempDB')

SELECT ' ' AS 'UNIVERSE OF PROVIDERS',*
INTO #TEMPTABLEPROVALERT
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st',[Email],[ASSOCIATION GROUP],[DBA]
FROM
( -- INITIATE ...
SELECT CHAPTER_NAME,LastName,NPIis,[SPEC],[Specialty],[INDEXNM],[Clinic Name],[ASSOCIATION GROUP],[DBA],FAXnumber,CAST(REPLACE(LTRIM(RTRIM(FAXnumber)),'-','')+'@faxcore.chg.com' AS nvarchar(100)) AS [Email]
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM INFORMATICS.dbo.PROVDIR_PCP --PROV(s)
UNION --VERTICAL() w UNION()  - ROW(s) --STACK DISTINCT
SELECT CHAPTER_NAME,LastName,NPIis,[SPEC],[Specialty],[INDEXNM],[Clinic Name],[ASSOCIATION GROUP],[DBA],FAXnumber,CAST(REPLACE(LTRIM(RTRIM(FAXnumber)),'-','')+'@faxcore.chg.com' AS nvarchar(100)) AS [Email]
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM INFORMATICS.dbo.PROVDIR_NPMP --PROV(s)
UNION --VERTICAL() w UNION()  - ROW(s) --STACK DISTINCT
SELECT CHAPTER_NAME,LastName,NPIis,[SPEC],[Specialty],[INDEXNM],[Clinic Name],[ASSOCIATION GROUP],[DBA],FAXnumber,CAST(REPLACE(LTRIM(RTRIM(FAXnumber)),'-','')+'@faxcore.chg.com' AS nvarchar(100)) AS [Email]
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM INFORMATICS.dbo.PROVDIR_SPE --PROV(s)
UNION --VERTICAL() w UNION()  - ROW(s) --STACK DISTINCT
SELECT CHAPTER_NAME,LastName,NPIis,[SPEC],[Specialty],[INDEXNM],[Clinic Name],[ASSOCIATION GROUP],[DBA],FAXnumber,CAST(REPLACE(LTRIM(RTRIM(FAXnumber)),'-','')+'@faxcore.chg.com' AS nvarchar(100)) AS [Email]
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM INFORMATICS.dbo.PROVDIR_MH --PROV(s)
UNION --VERTICAL() w UNION()  - ROW(s) --STACK DISTINCT
SELECT CHAPTER_NAME,LastName,NPIis,[SPEC],[Specialty],[INDEXNM],[Clinic Name],[ASSOCIATION GROUP],[DBA],FAXnumber,CAST(REPLACE(LTRIM(RTRIM(FAXnumber)),'-','')+'@faxcore.chg.com' AS nvarchar(100)) AS [Email]
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM INFORMATICS.dbo.PROVDIR_AHP --PROV(s)
UNION --VERTICAL() w UNION()  - ROW(s) --STACK DISTINCT
SELECT CHAPTER_NAME,LastName,NPIis,[SPEC],[Specialty],[INDEXNM],[Clinic Name],[ASSOCIATION GROUP],[DBA],FAXnumber,CAST(REPLACE(LTRIM(RTRIM(FAXnumber)),'-','')+'@faxcore.chg.com' AS nvarchar(100)) AS [Email]
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM INFORMATICS.dbo.PROVDIR_VSP --PROV(s)
) -- CONCLUDE ...
AS t
WHERE 1=1 
	AND t.FAXnumber NOT LIKE '000%' 
	-- AND t.DBA IN ('FAMILY HEALTH CENTERS OF SAN DIEGO') -- LIKE '%%%'

		SELECT * FROM #TEMPTABLEPROVALERT

		SELECT COUNT(DISTINCT(NPIis)) AS [Unique Recipient by NPI] FROM #TEMPTABLEPROVALERT
		SELECT DISTINCT DBA FROM #TEMPTABLEPROVALERT
		SELECT DISTINCT [Email] FROM #TEMPTABLEPROVALERT

/* --put all the fax numbers in a temp table
DROP TABLE IF EXISTS #fax_numbers

SELECT fn.faxphone
INTO #
FROM 
( -- INITIATE ...
SELECT DISTINCT [Email] AS [faxphone]
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st',[Email],[ASSOCIATION GROUP],[DBA]
FROM #TEMPTABLEPROVALERT
WHERE FAXnumber NOT LIKE '000%' --LIKE '%619%281%0194%'
) -- CONCLUDE ...
AS fn
WHERE LEN(fn.faxphone)>0
	AND fn.faxphone<>'0000000000'

	--count how many rows are in the temp table AND put the answer in a variable
DECLARE @number_of_rows decimal(28,12)

SELECT @number_of_rows = count(1) 
FROM #fax_numbers

	--figure out how many batches of 500 are needed based ON the number of rows
DECLARE @number_of_batches_needed int

SELECT @number_of_batches_needed=ceiling(@number_of_rows/500);

	-- use NTILE function to divide the data INTO batches of 500
DROP TABLE IF EXISTS #fax_with_batchnumber

SELECT NTILE(@number_of_batches_needed) over(ORDER BY faxphone) AS batch_num
       , faxphone
INTO #fax_with_batchnumber
FROM #fax_numbers

--use string_agg to create delimitted list of fax numbers in groups of 500
SELECT
string_agg(CAST(LTRIM(RTRIM(ISNULL(faxphone,''))) AS varchar(MAX)), '; ')
FROM #fax_with_batchnumber
GROUP BY batch_num */







-- ========================================================================
	-- EXCLUSION v. INCLUSION ... FQHC (Federally Qualified Health Center) SAMPLE -- 
-- ========================================================================
SELECT 'REFERENCE / see "CHGSD 15 FQHC.jpg"' AS [MESSAGE(S)],*
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT [DBA],[ASSOCIATION GROUP] -- CHECK 1st
FROM INFORMATICS.dbo.PROVDIR_CLINIC
WHERE 
( -- INITIATE ...
[DBA] LIKE '%BORREG%FOUND%'
	OR [DBA] LIKE '%CHS%'
	OR [DBA] LIKE '%SAN%YSID%'
	OR [DBA] LIKE '%COMM%HEA%SYS%'
	OR [DBA] LIKE '%FAM%HEA%CE%DIEG%'
	OR [DBA] LIKE '%IMPERIA%BEA%CLI%'
	OR [DBA] LIKE '%LA%MAESTR%'
	OR [DBA] LIKE '%NEIGHBORHOOD%HEAL%'
	OR [DBA] LIKE '%INTEGRATED%HEAL%'
	OR [DBA] LIKE '%DIEG%FAM%CAR%'
	OR [DBA] LIKE '%TRUECARE%'
	OR [DBA] LIKE '%VIST%COMM%CLIN%'
	OR [DBA] LIKE '%INDIAN%HEA%'
	OR [DBA] LIKE '%VILLAGE%HEAL%CEN%'
	OR [DBA] LIKE '%SAMAHAN%'
	OR [DBA] LIKE '%SYCUAN%'
	OR [DBA] LIKE '%SDAIHC%'
) -- CONCLUDE...

SELECT 'REFERENCE / see "CHGSD 15 FQHC.jpg"' AS [MESSAGE(S)],*
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT [DBA],[ASSOCIATION GROUP] -- CHECK 1st
FROM INFORMATICS.dbo.PROVDIR_PCP
WHERE 
( -- INITIATE ...
[DBA] LIKE '%BORREG%FOUND%'
	OR [DBA] LIKE '%CHS%'
	OR [DBA] LIKE '%SAN%YSID%'
	OR [DBA] LIKE '%COMM%HEA%SYS%'
	OR [DBA] LIKE '%FAM%HEA%CE%DIEG%'
	OR [DBA] LIKE '%IMPERIA%BEA%CLI%'
	OR [DBA] LIKE '%LA%MAESTR%'
	OR [DBA] LIKE '%NEIGHBORHOOD%HEAL%'
	OR [DBA] LIKE '%INTEGRATED%HEAL%'
	OR [DBA] LIKE '%DIEG%FAM%CAR%'
	OR [DBA] LIKE '%TRUECARE%'
	OR [DBA] LIKE '%VIST%COMM%CLIN%'
	OR [DBA] LIKE '%INDIAN%HEA%'
	OR [DBA] LIKE '%VILLAGE%HEAL%CEN%'
	OR [DBA] LIKE '%SAMAHAN%'
	OR [DBA] LIKE '%SYCUAN%'
	OR [DBA] LIKE '%SDAIHC%'
) -- CONCLUDE...

/* x A Federally Qualified Health Center (FQHC) is a reimbursement designation FROM the Bureau of Primary Health Care AND the Centers for Medicare AND Medicaid Services of the United States Department of Health AND Human Services. */

		-- SELECT DISTINCT INDEXNM,[Clinic Name],[DBA],[ASSOCIATION GROUP],[DBA] FROM INFORMATICS.dbo.PROVDIR_CLINIC -- FQHC(s)

		-- SELECT DISTINCT pa.[Clinic Name] --pa.[ASSOCIATION GROUP],pa.[Clinic Name]
		-- FROM #TEMPTABLEPROVALERT AS pa
		-- JOIN (SELECT DISTINCT INDEXNM,[Clinic Name],[DBA],[ASSOCIATION GROUP],[DBA] FROM INFORMATICS.dbo.PROVDIR_CLINIC) AS fqhc ON fqhc.INDEXNM = pa.[Clinic Name]

		-- SELECT DISTINCT pa.[Clinic Name] --pa.[ASSOCIATION GROUP],pa.[Clinic Name]
		-- FROM #TEMPTABLEPROVALERT AS pa
		-- JOIN (SELECT DISTINCT INDEXNM,[Clinic Name],[DBA],[ASSOCIATION GROUP],[DBA] FROM INFORMATICS.dbo.PROVDIR_CLINIC) AS fqhc ON fqhc.DBA = pa.[ASSOCIATION GROUP]

		-- SELECT DISTINCT pa.[Clinic Name] --pa.[ASSOCIATION GROUP],pa.[Clinic Name]
		-- FROM #TEMPTABLEPROVALERT AS pa	
		-- WHERE pa.[Clinic Name] LIKE '%INDIAN%'

UPDATE #TEMPTABLEPROVALERT
SET FAXnumber = '999-'
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT [DBA],[ASSOCIATION GROUP] -- CHECK 1st
FROM #TEMPTABLEPROVALERT AS pa
WHERE ( -- INITIATE ...
[ASSOCIATION GROUP] LIKE '%UCSD%'  -- IDENTIFY UCSD
	OR  [DBA] LIKE '%UCSD%'
) -- CONCLUDE ...

UPDATE #TEMPTABLEPROVALERT
SET FAXnumber = '999-'
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT [DBA],[ASSOCIATION GROUP] -- CHECK 1st
FROM #TEMPTABLEPROVALERT AS pa
WHERE ( -- INITIATE ...
[ASSOCIATION GROUP] LIKE '%RADY%'  -- IDENTIFY CSSD' aka "RADY CHILDREN'S SPECIALISTS OF SAN DIEGO"
	OR  [DBA] LIKE '%RADY%'
) -- CONCLUDE ...

UPDATE #TEMPTABLEPROVALERT
SET FAXnumber = '999-'
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT [DBA],[ASSOCIATION GROUP] -- CHECK 1st
FROM #TEMPTABLEPROVALERT AS pa
WHERE ( -- INITIATE ...
[ASSOCIATION GROUP] LIKE '%CHILDREN%PRIMARY CARE MEDICAL GROUP%'  -- IDENTIFY CPCMG
	OR  [DBA] LIKE '%CHILDREN%PRIMARY CARE MEDICAL GROUP%'
) -- CONCLUDE ...

UPDATE #TEMPTABLEPROVALERT
SET FAXnumber = '999-'
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT [DBA],[ASSOCIATION GROUP] -- CHECK 1st
FROM #TEMPTABLEPROVALERT AS pa
WHERE ( -- INITIATE ...
[ASSOCIATION GROUP] LIKE '%PEDIATRIC PRIMARY CARE ASSOC MEDICAL GROUP%'  -- IDENTIFY PPCAMG
	OR  [DBA] LIKE '%PEDIATRIC PRIMARY CARE ASSOC MEDICAL GROUP%'
) -- CONCLUDE ...

UPDATE #TEMPTABLEPROVALERT
SET FAXnumber = '999-'
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT [DBA],[ASSOCIATION GROUP] -- CHECK 1st
FROM #TEMPTABLEPROVALERT AS pa
	JOIN (SELECT DISTINCT INDEXNM,[Clinic Name],[ASSOCIATION GROUP],[DBA] FROM INFORMATICS.dbo.PROVDIR_CLINIC) AS fqhc ON fqhc.INDEXNM = pa.[Clinic Name] -- IDENTIFY FQHC (Federally Qualified Health Center)
	
UPDATE #TEMPTABLEPROVALERT
SET FAXnumber = '999-'
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT [DBA],[ASSOCIATION GROUP] -- CHECK 1st
FROM #TEMPTABLEPROVALERT AS pa
	JOIN (SELECT DISTINCT INDEXNM,[Clinic Name],[ASSOCIATION GROUP],[DBA] FROM INFORMATICS.dbo.PROVDIR_CLINIC) AS fqhc ON fqhc.DBA = pa.[ASSOCIATION GROUP] -- IDENTIFY FQHC (Federally Qualified Health Center)

UPDATE #TEMPTABLEPROVALERT
SET FAXnumber = '999-'
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT [DBA],[ASSOCIATION GROUP] -- CHECK 1st
FROM #TEMPTABLEPROVALERT AS pa	
WHERE pa.[Clinic Name] LIKE '%INDIAN%' -- IDENTIFY FQHC (Federally Qualified Health Center)

		SELECT (SELECT COUNT(DISTINCT([Email])) FROM #TEMPTABLEPROVALERT) AS [RECORD COUNT],*
		-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
		-- SELECT DISTINCT ' ' AS 'CHECK 1st',[Email],[ASSOCIATION GROUP],[DBA]
		FROM #TEMPTABLEPROVALERT
		WHERE FAXnumber NOT LIKE '000%' 
			AND FAXnumber NOT LIKE '999-%' -- APPLICATION OF EXCLUSION(S) / INCLUSION(S)

		SELECT DISTINCT [Email] 
		-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
		-- SELECT DISTINCT [DBA],[ASSOCIATION GROUP] -- CHECK 1st
		FROM #TEMPTABLEPROVALERT 
		WHERE FAXnumber NOT LIKE '000%'
			AND FAXnumber NOT LIKE '999-%' -- APPLICATION OF EXCLUSION(S) / INCLUSION(S)







-- ====================================================================
	-- PROVIDER ALERT LISTING FOR [FAC](s) --
-- ====================================================================
-----------------------------------------------------------------------------------------------------------------------------
	--Error Trapping: Check If Permanent Table(s) Already Exist(s) AND Drop If Applicable--
-----------------------------------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS #TEMPTABLEFACALERT -- SQL Server 2016 AND later -- DYNAMIC tmp OR STATIC [TABLE] #TableName is a local temporary table visible only in the current session; #TableName is a GLOBAL temporary table visible to all sessions IN ('TempDB')

;WITH TEMPTABLE AS --;WITH() LIKE '%CREATION OF [tempdb] TABLE%'  # FROM JL
( --INITIATE ...
SELECT DISTINCT NPIis,INDEXNM,[ASSOCIATION GROUP],[DBA],[FAXnumber],CAST(REPLACE(LTRIM(RTRIM(FAXnumber)),'-','')+'@faxcore.chg.com' AS nvarchar(100)) AS [Email]
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM INFORMATICS.dbo.PROVDIR_SNF

UNION -- VERTICAL() STACK DISTINCT()
SELECT DISTINCT NPIis,HospitalName AS [INDEXNM],[ASSOCIATION GROUP],[DBA],[FAXnumber],CAST(REPLACE(LTRIM(RTRIM(FAXnumber)),'-','')+'@faxcore.chg.com' AS nvarchar(100)) AS [Email]
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM INFORMATICS.dbo.TimelyAccessFAC -- FROM #INNETWORK_FAC
-- WHERE vlpSERVICETYPENAME LIKE '%BOARD%'
	-- OR HospitalName LIKE '%BLACK%TIGE%'
	-- OR ServiceTypeName LIKE '%DURABLE%MED%'
	-- OR ServiceCategoryTypeName LIKE '%DURABLE%MED%'
	-- OR [Type of Service] IN ('DME')
) --CONCLUDE ...
SELECT DISTINCT * 
INTO #TEMPTABLEFACALERT
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM TEMPTABLE
WHERE 1=1 
	AND FAXnumber NOT LIKE '000%'

		SELECT ' ' AS 'UNIVERSE OF PROVIDERS',(SELECT COUNT(DISTINCT([Email])) FROM #TEMPTABLEFACALERT) AS [RECORD COUNT],*
		-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
		-- SELECT DISTINCT ' ' AS 'CHECK 1st',[Email],[ASSOCIATION GROUP],[DBA]
		FROM #TEMPTABLEFACALERT
		WHERE 1=1 
			AND FAXnumber NOT LIKE '000%' 
		
		SELECT COUNT(DISTINCT(NPIis)) AS [Unique Recipient by NPI]FROM #TEMPTABLEFACALERT

		SELECT DISTINCT [Email]
		-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
		-- SELECT DISTINCT ' ' AS 'CHECK 1st',[Email],[ASSOCIATION GROUP],[DBA]
		FROM #TEMPTABLEFACALERT
		WHERE 1=1 
			AND FAXnumber NOT LIKE '000%' --LIKE '%619%281%0194%'
			 -- AND ([ASSOCIATION GROUP] NOT LIKE '%RADY%'  -- EXCLUDE CSSD' aka RADY(s)
				-- OR  [DBA] NOT LIKE '%RADY%') -- EXCLUDE CSSD aka RADY(s)
			-- AND [ASSOCIATION GROUP] LIKE '%RADY%'  -- INCLUDE CSSD aka RADY(s)
			-- AND [DBA] LIKE '%RADY%' -- INCLUDE CSSD aka RADY(s)
		






-- ====================================================================
	-- Alt. PROVIDER ALERT LISTING FOR FAC(s) --
-- ====================================================================
/* x see 'SUBCONTARCTOR_'...rar */ USE [ProviderRepository]
-----------------------------------------------------------------------------------------------------------------------------
	--Error Trapping: Check If Permanent Table(s) Already Exist(s) AND Drop If Applicable--
-----------------------------------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS #TEMPTABLEFACALERT -- SQL Server 2016 AND later -- DYNAMIC tmp OR STATIC [TABLE] #TableName is a local temporary table visible only in the current session; #TableName is a GLOBAL temporary table visible to all sessions IN ('TempDB')

SELECT *
INTO #TEMPTABLEFACALERT
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM 
( -- INITIATE ...
SELECT DISTINCT 'MEDICAL GROUP' AS [SubcontractorType],UPPER(LTRIM(RTRIM(ISNULL(g.GroupName,'')))) AS [AffiliateName],UPPER(LTRIM(RTRIM(ISNULL(s.Address,''))))+' '+UPPER(LTRIM(RTRIM(ISNULL(s.Address2,'')))) AS [FullAddress],UPPER(LTRIM(RTRIM(ISNULL(s.City,'')))) AS [CITY],UPPER(LTRIM(RTRIM(ISNULL(s.County,'')))) AS [COUNTY],UPPER(LTRIM(RTRIM(ISNULL(s.State,'')))) AS [STATE],SUBSTRING(UPPER(LTRIM(RTRIM(ISNULL(s.ZipCode,'')))),1,5) AS [ZIP]
,s.PrimaryFax AS [FAXnumber]
,CAST(REPLACE(LTRIM(RTRIM(s.PrimaryFax)),'-','')+'@faxcore.chg.com' AS nvarchar(100)) AS [Email]
-- SELECT g.PracticeTypeName,* -- CHECK 1st
-- SELECT MAX([SnapshotID]) AS 'SID' FROM [ProviderRepository].dbo.[Snapshot] -- CHECK 1st
-- SELECT DISTINCT g.PracticeTypeName -- CHECK 1st
FROM [ProviderRepository].dbo.[Sites] AS s
	JOIN [ProviderRepository].dbo.GroupSites AS gs ON gs.SiteID = s.SiteID
		AND gs.[SnapshotID] = s.[SnapshotID]
	JOIN [ProviderRepository].dbo.Groups AS g ON g.GroupID = gs.GroupID
		AND g.GroupID = gs.GroupID
		AND g.[SnapshotID] = s.[SnapshotID]
WHERE CAST(s.CountofMedicalMembers AS int) != 0
	AND UPPER(LTRIM(RTRIM(ISNULL(g.PracticeTypeName,'')))) LIKE '%GROUP%'
	-- AND UPPER(LTRIM(RTRIM(ISNULL(g.PracticeTypeName,'')))) NOT LIKE '%FACIL%' -- Per S .COLEMAN EMAIL ON 20190401 '...Send one fax per practice.  Practice Status = Active Practice Type not = Facility  Fax # to use Practice Location = Cred Contact If no cred contact use fax# for one address that starts with practice.  Thanks! ...'
	AND s.PrimaryFax IS NOT NULL
	AND s.PrimaryFax NOT IN ('0000000000')
-- ORDER BY  UPPER(LTRIM(RTRIM(ISNULL(g.GroupName,'')))),s.PrimaryFax	
) AS DERIVED -- CONCLUDE ...

		SELECT (SELECT COUNT(DISTINCT([Email])) FROM #TEMPTABLEFACALERT) AS [RECORD COUNT],*
		-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
		-- SELECT DISTINCT ' ' AS 'CHECK 1st',[Email],[ASSOCIATION GROUP],[DBA]
		FROM #TEMPTABLEFACALERT
		WHERE FAXnumber NOT LIKE '000%' 
			 AND ([ASSOCIATION GROUP] NOT LIKE '%RADY%'  -- EXCLUDE CSSD' aka RADY(s)
				OR  [DBA] NOT LIKE '%RADY%') -- EXCLUDE CSSD aka RADY(s)
			-- AND [ASSOCIATION GROUP] LIKE '%RADY%'  -- INCLUDE CSSD aka RADY(s)
			-- AND [DBA] LIKE '%RADY%' -- INCLUDE CSSD aka RADY(s)
		-- ORDER BY ...

		SELECT DISTINCT [Email]
		-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
		-- SELECT DISTINCT ' ' AS 'CHECK 1st',[Email],[ASSOCIATION GROUP],[DBA]
		FROM #TEMPTABLEFACALERT
		WHERE FAXnumber NOT LIKE '000%' --LIKE '%619%281%0194%'
			 AND ([ASSOCIATION GROUP] NOT LIKE '%RADY%'  -- EXCLUDE CSSD' aka RADY(s)
				OR  [DBA] NOT LIKE '%RADY%') -- EXCLUDE CSSD aka RADY(s)
			-- AND [ASSOCIATION GROUP] LIKE '%RADY%'  -- INCLUDE CSSD aka RADY(s)
			-- AND [DBA] LIKE '%RADY%' -- INCLUDE CSSD aka RADY(s)
		-- ORDER BY ...







-- ====================================================================
	-- FIVE (5) COHORT(S) PROVIDER ALERT LISTING -- 
-- ====================================================================
x Hello Walter AND Jeremy,  We need to get these Provider alerts out to contracted providers by tomorrow 7/16/2021, attached are the following:

		1) V1 Hospital letter should be faxed to all contracted hospitals.
		2) V2 SNF letter should be faxed to all contracted SNFs AND assisted living facilities.
		3) V3 Home health letter should be faxed to all contracted home health facilities.
		4) V4 Transportation letter should be faxed to all contracted transportation vendors (Ambulance vendors AND black tiger).
		5) V5 DME letter should be faxed to all contracted DME vendors.

Flor, please upload the PDF files to the website (Provider Alert section).
 
Ataa Maty IMG, BSN, RN
Director of Utilization Management 
Community Health Group
2420 Fenton Street, Suite 100
Chula Vista, CA 91914
T: (619)498-6458
C: (619)371-6674
F: (866)897-6024/for Hospital
F: (619)382-1210/for SNF
Email: AMaty@chgsd.com
 
*For inpatient team assistance after hours, weekends, AND ON holidays, please call (800)224-7766 to reach the on-call nurse for help with authorizations AND discharge needs.
 
*Confidentiality Notice: This e-mail (including attachments), is covered by the Electronic Communications Privacy Act, 18 U.S.C. 2510-2521, is confidential, AND may be legally privileged. If you are not the intended recipient, you are hereby notified that any retention, dissemination, distribution, or copying of this communication is strictly prohibited. Please reply to the sender that you have received a message in error, THEN delete it. Thank you.

-- ====================================================================
	-- HOSPITAL(s) --
-- ====================================================================
-----------------------------------------------------------------------------------------------------------------------------
	--Error Trapping: Check If Permanent Table(s) Already Exist(s) AND Drop If Applicable--
-----------------------------------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS #TEMPTABLEFACALERT -- SQL Server 2016 AND later -- DYNAMIC tmp OR STATIC [TABLE] #TableName is a local temporary table visible only in the current session; #TableName is a GLOBAL temporary table visible to all sessions IN ('TempDB')

;WITH TEMPTABLE AS --;WITH() LIKE '%CREATION OF [tempdb] TABLE%'  # FROM JL
( --INITIATE ...
SELECT DISTINCT NPIis,INDEXNM,[ASSOCIATION GROUP],[DBA],[FAXnumber],CAST(REPLACE(LTRIM(RTRIM(FAXnumber)),'-','')+'@faxcore.chg.com' AS nvarchar(100)) AS [Email]
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM INFORMATICS.dbo.PROVDIR_HOS
) --CONCLUDE ...
SELECT DISTINCT * 
INTO #TEMPTABLEFACALERT
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM TEMPTABLE
WHERE FAXnumber NOT LIKE '000%'

		SELECT ' ' AS 'UNIVERSE OF THE FIVE (5) COHORTS',(SELECT COUNT(DISTINCT([Email])) FROM #TEMPTABLEFACALERT) AS [RECORD COUNT],*
		-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
		-- SELECT DISTINCT ' ' AS 'CHECK 1st',[Email],[ASSOCIATION GROUP],[DBA]
		FROM #TEMPTABLEFACALERT
		WHERE FAXnumber NOT LIKE '000%' 

		SELECT DISTINCT [Email]
		-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
		-- SELECT DISTINCT ' ' AS 'CHECK 1st',[Email],[ASSOCIATION GROUP],[DBA]
		FROM #TEMPTABLEFACALERT
		WHERE FAXnumber NOT LIKE '000%' --LIKE '%619%281%0194%'

		





-- ====================================================================
	-- SNF(s)  & ASSISTED LIVING FACILITY(-ies) --
-- ====================================================================
-----------------------------------------------------------------------------------------------------------------------------
	--Error Trapping: Check If Permanent Table(s) Already Exist(s) AND Drop If Applicable--
-----------------------------------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS #TEMPTABLEFACALERT -- SQL Server 2016 AND later -- DYNAMIC tmp OR STATIC [TABLE] #TableName is a local temporary table visible only in the current session; #TableName is a GLOBAL temporary table visible to all sessions IN ('TempDB')

;WITH TEMPTABLE AS --;WITH() LIKE '%CREATION OF [tempdb] TABLE%'  # FROM JL
( --INITIATE ...
SELECT DISTINCT NPIis,INDEXNM,[ASSOCIATION GROUP],[DBA],[FAXnumber],CAST(REPLACE(LTRIM(RTRIM(FAXnumber)),'-','')+'@faxcore.chg.com' AS nvarchar(100)) AS [Email]
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM INFORMATICS.dbo.PROVDIR_SNF

UNION -- VERTICAL() STACK DISTINCT()
SELECT DISTINCT NPIis,HospitalName AS [INDEXNM],[ASSOCIATION GROUP],[DBA],[FAXnumber],CAST(REPLACE(LTRIM(RTRIM(FAXnumber)),'-','')+'@faxcore.chg.com' AS nvarchar(100)) AS [Email]
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM INFORMATICS.dbo.TimelyAccessFAC -- FROM #INNETWORK_FAC
WHERE vlpSERVICETYPENAME LIKE '%BOARD%'
) --CONCLUDE ...
SELECT DISTINCT * 
INTO #TEMPTABLEFACALERT
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM TEMPTABLE
WHERE FAXnumber NOT LIKE '000%'

		SELECT ' ' AS 'UNIVERSE OF THE FIVE (5) COHORTS',(SELECT COUNT(DISTINCT([Email])) FROM #TEMPTABLEFACALERT) AS [RECORD COUNT],*
		-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
		-- SELECT DISTINCT ' ' AS 'CHECK 1st',[Email],[ASSOCIATION GROUP],[DBA]
		FROM #TEMPTABLEFACALERT
		WHERE FAXnumber NOT LIKE '000%' 

		SELECT DISTINCT [Email]
		-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
		-- SELECT DISTINCT ' ' AS 'CHECK 1st',[Email],[ASSOCIATION GROUP],[DBA]
		FROM #TEMPTABLEFACALERT
		WHERE FAXnumber NOT LIKE '000%' --LIKE '%619%281%0194%'







-- ====================================================================
	-- HOME HEALTH  --
-- ====================================================================
-----------------------------------------------------------------------------------------------------------------------------
	--Error Trapping: Check If Permanent Table(s) Already Exist(s) AND Drop If Applicable--
-----------------------------------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS #TEMPTABLEFACALERT -- SQL Server 2016 AND later -- DYNAMIC tmp OR STATIC [TABLE] #TableName is a local temporary table visible only in the current session; #TableName is a GLOBAL temporary table visible to all sessions IN ('TempDB')

;WITH TEMPTABLE AS --;WITH() LIKE '%CREATION OF [tempdb] TABLE%'  # FROM JL
( --INITIATE ...
SELECT DISTINCT NPIis,INDEXNM,[ASSOCIATION GROUP],[DBA],[FAXnumber],CAST(REPLACE(LTRIM(RTRIM(FAXnumber)),'-','')+'@faxcore.chg.com' AS nvarchar(100)) AS [Email]
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM INFORMATICS.dbo.PROVDIR_HHC
) --CONCLUDE ...
SELECT DISTINCT * 
INTO #TEMPTABLEFACALERT
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM TEMPTABLE
WHERE FAXnumber NOT LIKE '000%'

		SELECT ' ' AS 'UNIVERSE OF THE FIVE (5) COHORTS',(SELECT COUNT(DISTINCT([Email])) FROM #TEMPTABLEFACALERT) AS [RECORD COUNT],*
		-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
		-- SELECT DISTINCT ' ' AS 'CHECK 1st',[Email],[ASSOCIATION GROUP],[DBA]
		FROM #TEMPTABLEFACALERT
		WHERE FAXnumber NOT LIKE '000%' 

		SELECT DISTINCT [Email]
		-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
		-- SELECT DISTINCT ' ' AS 'CHECK 1st',[Email],[ASSOCIATION GROUP],[DBA]
		FROM #TEMPTABLEFACALERT
		WHERE FAXnumber NOT LIKE '000%' --LIKE '%619%281%0194%'







-- ====================================================================
	-- TRANSPORTATION & BLACK TIGER --
-- ====================================================================
-----------------------------------------------------------------------------------------------------------------------------
	--Error Trapping: Check If Permanent Table(s) Already Exist(s) AND Drop If Applicable--
-----------------------------------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS #TEMPTABLEFACALERT -- SQL Server 2016 AND later -- DYNAMIC tmp OR STATIC [TABLE] #TableName is a local temporary table visible only in the current session; #TableName is a GLOBAL temporary table visible to all sessions IN ('TempDB')

;WITH TEMPTABLE AS --;WITH() LIKE '%CREATION OF [tempdb] TABLE%'  # FROM JL
( --INITIATE ...
SELECT DISTINCT NPIis,HospitalName AS [INDEXNM],[ASSOCIATION GROUP],[DBA],[FAXnumber],CAST(REPLACE(LTRIM(RTRIM(FAXnumber)),'-','')+'@faxcore.chg.com' AS nvarchar(100)) AS [Email]
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM INFORMATICS.dbo.TimelyAccessFAC -- FROM #INNETWORK_FAC
WHERE vlpSERVICETYPENAME LIKE '%AMBULAN%'
	OR vlpSERVICETYPENAME LIKE '%TRANSPORT%'
	OR HospitalName LIKE '%BLACK%TIGE%'
) --CONCLUDE ...
SELECT DISTINCT * 
INTO #TEMPTABLEFACALERT
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM TEMPTABLE
WHERE FAXnumber NOT LIKE '000%'

		SELECT ' ' AS 'UNIVERSE OF THE FIVE (5) COHORTS',(SELECT COUNT(DISTINCT([Email])) FROM #TEMPTABLEFACALERT) AS [RECORD COUNT],*
		-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
		-- SELECT DISTINCT ' ' AS 'CHECK 1st',[Email],[ASSOCIATION GROUP],[DBA]
		FROM #TEMPTABLEFACALERT
		WHERE FAXnumber NOT LIKE '000%' 

		SELECT DISTINCT [Email]
		-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
		-- SELECT DISTINCT ' ' AS 'CHECK 1st',[Email],[ASSOCIATION GROUP],[DBA]
		FROM #TEMPTABLEFACALERT
		WHERE FAXnumber NOT LIKE '000%' --LIKE '%619%281%0194%'







-- ====================================================================
	-- DME --
-- ====================================================================
-----------------------------------------------------------------------------------------------------------------------------
	--Error Trapping: Check If Permanent Table(s) Already Exist(s) AND Drop If Applicable--
-----------------------------------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS #TEMPTABLEFACALERT -- SQL Server 2016 AND later -- DYNAMIC tmp OR STATIC [TABLE] #TableName is a local temporary table visible only in the current session; #TableName is a GLOBAL temporary table visible to all sessions IN ('TempDB')

;WITH TEMPTABLE AS --;WITH() LIKE '%CREATION OF [tempdb] TABLE%'  # FROM JL
( --INITIATE ...
SELECT DISTINCT NPIis,HospitalName AS [INDEXNM],[ASSOCIATION GROUP],[DBA],[FAXnumber],CAST(REPLACE(LTRIM(RTRIM(FAXnumber)),'-','')+'@faxcore.chg.com' AS nvarchar(100)) AS [Email]
-- SELECT TOP 1000 * -- CHECK 1st
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM INFORMATICS.dbo.TimelyAccessFAC -- FROM #INNETWORK_FAC
WHERE vlpSERVICETYPENAME LIKE '%DURABLE%MED%'
	OR ServiceTypeName LIKE '%DURABLE%MED%'
	OR ServiceCategoryTypeName LIKE '%DURABLE%MED%'
	OR [Type of Service] IN ('DME')
) --CONCLUDE ...
SELECT DISTINCT * 
INTO #TEMPTABLEFACALERT
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM TEMPTABLE
WHERE FAXnumber NOT LIKE '000%'

		SELECT ' ' AS 'UNIVERSE OF THE FIVE (5) COHORTS',(SELECT COUNT(DISTINCT([Email])) FROM #TEMPTABLEFACALERT) AS [RECORD COUNT],*
		-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
		-- SELECT DISTINCT ' ' AS 'CHECK 1st',[Email],[ASSOCIATION GROUP],[DBA]
		FROM #TEMPTABLEFACALERT
		WHERE FAXnumber NOT LIKE '000%' 

		SELECT DISTINCT [Email]
		-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
		-- SELECT DISTINCT ' ' AS 'CHECK 1st',[Email],[ASSOCIATION GROUP],[DBA]
		FROM #TEMPTABLEFACALERT
		WHERE FAXnumber NOT LIKE '000%' --LIKE '%619%281%0194%'







-- ====================================================================
	-- UNIVERSE OF THE FIVE (5) COHORT(S)  --
-- ====================================================================
/* [FACILITY / OTH TYPE(S)]
		Hospital
		SNF
		Home Health
		Transportation
		DME */

-----------------------------------------------------------------------------------------------------------------------------
	--Error Trapping: Check If Permanent Table(s) Already Exist(s) AND Drop If Applicable--
-----------------------------------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS #TEMPTABLEFACALERT -- SQL Server 2016 AND later -- DYNAMIC tmp OR STATIC [TABLE] #TableName is a local temporary table visible only in the current session; #TableName is a GLOBAL temporary table visible to all sessions IN ('TempDB')

;WITH TEMPTABLE AS --;WITH() LIKE '%CREATION OF [tempdb] TABLE%'  # FROM JL
( --INITIATE ...
SELECT DISTINCT NPIis,INDEXNM,[ASSOCIATION GROUP],[DBA],[FAXnumber],CAST(REPLACE(LTRIM(RTRIM(FAXnumber)),'-','')+'@faxcore.chg.com' AS nvarchar(100)) AS [Email]
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM INFORMATICS.dbo.PROVDIR_HOS

UNION 
SELECT DISTINCT NPIis,INDEXNM,[ASSOCIATION GROUP],[DBA],[FAXnumber],CAST(REPLACE(LTRIM(RTRIM(FAXnumber)),'-','')+'@faxcore.chg.com' AS nvarchar(100)) AS [Email]
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM INFORMATICS.dbo.PROVDIR_SNF

UNION -- VERTICAL() STACK DISTINCT()
SELECT DISTINCT NPIis,HospitalName AS [INDEXNM],[ASSOCIATION GROUP],[DBA],[FAXnumber],CAST(REPLACE(LTRIM(RTRIM(FAXnumber)),'-','')+'@faxcore.chg.com' AS nvarchar(100)) AS [Email]
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM INFORMATICS.dbo.TimelyAccessFAC -- FROM #INNETWORK_FAC
WHERE vlpSERVICETYPENAME LIKE '%BOARD%'

UNION
SELECT DISTINCT NPIis,INDEXNM,[ASSOCIATION GROUP],[DBA],[FAXnumber],CAST(REPLACE(LTRIM(RTRIM(FAXnumber)),'-','')+'@faxcore.chg.com' AS nvarchar(100)) AS [Email]
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM INFORMATICS.dbo.PROVDIR_HHC

UNION
SELECT DISTINCT NPIis,HospitalName AS [INDEXNM],[ASSOCIATION GROUP],[DBA],[FAXnumber],CAST(REPLACE(LTRIM(RTRIM(FAXnumber)),'-','')+'@faxcore.chg.com' AS nvarchar(100)) AS [Email]
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM INFORMATICS.dbo.TimelyAccessFAC -- FROM #INNETWORK_FAC
WHERE vlpSERVICETYPENAME LIKE '%AMBULAN%'
	OR vlpSERVICETYPENAME LIKE '%TRANSPORT%'
	OR HospitalName LIKE '%BLACK%TIGE%'

UNION 
SELECT DISTINCT NPIis,HospitalName AS [INDEXNM],[ASSOCIATION GROUP],[DBA],[FAXnumber],CAST(REPLACE(LTRIM(RTRIM(FAXnumber)),'-','')+'@faxcore.chg.com' AS nvarchar(100)) AS [Email]
-- SELECT TOP 1000 * -- CHECK 1st
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM INFORMATICS.dbo.TimelyAccessFAC -- FROM #INNETWORK_FAC
WHERE vlpSERVICETYPENAME LIKE '%DURABLE%MED%'
	OR ServiceTypeName LIKE '%DURABLE%MED%'
	OR ServiceCategoryTypeName LIKE '%DURABLE%MED%'
	OR [Type of Service] IN ('DME')
) --CONCLUDE ...
SELECT DISTINCT * 
INTO #TEMPTABLEFACALERT
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM TEMPTABLE
WHERE FAXnumber NOT LIKE '000%'

		SELECT ' ' AS 'UNIVERSE OF THE FIVE (5) COHORTS',(SELECT COUNT(DISTINCT([Email])) FROM #TEMPTABLEFACALERT) AS [RECORD COUNT],*
		-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
		-- SELECT DISTINCT ' ' AS 'CHECK 1st',[Email],[ASSOCIATION GROUP],[DBA]
		FROM #TEMPTABLEFACALERT
		WHERE FAXnumber NOT LIKE '000%' 

		SELECT DISTINCT [Email]
		-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
		-- SELECT DISTINCT ' ' AS 'CHECK 1st',[Email],[ASSOCIATION GROUP],[DBA]
		FROM #TEMPTABLEFACALERT
		WHERE FAXnumber NOT LIKE '000%' --LIKE '%619%281%0194%'







-- ====================================================================
	-- Alt. PROVIDER ALERT LISTING FOR FAC(s) --
-- ====================================================================
/* x see 'STEP88_REVIEW_PROVDIR_'...sql */ USE [eVips_chgcv]

		SELECT 'RUN OPENING DECLARE(S) AND #tmp CTE [TABLE(s)] FROM eVIPS_PROVDIR_STEP03_VIP_...sql ' AS [MESSAGE(S)]

-----------------------------------------------------------------------------------------------------------------------------
	--Error Trapping: Check If Permanent Table(s) Already Exist(s) AND Drop If Applicable--
-----------------------------------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS #TEMPTABLEFACALERT -- SQL Server 2016 AND later -- DYNAMIC tmp OR STATIC [TABLE] #TableName is a local temporary table visible only in the current session; #TableName is a GLOBAL temporary table visible to all sessions IN ('TempDB')

SELECT DISTINCT PHONEfax.PhoneNumber AS [FAXnumber],CAST(REPLACE(LTRIM(RTRIM(PHONEfax.PhoneNumber)),'-','')+'@faxcore.chg.com' AS nvarchar(100)) AS [Email]
,UPPER(LTRIM(RTRIM(vlp.InDirectory))) AS [INDIRECTORY]
,vlp.ProductName
,UPPER(LTRIM(RTRIM(vp.PracticeID))) AS [lookup_key]
,REPLACE(UPPER(LTRIM(RTRIM(vp.PracticeCode))),'-','') AS MEDGRPIPA --UPDATED AS MATCH FOUND ;WITH() TimelyAccessCLINIC DATA SAMPLE(s) FROM INTO #INNETWORK_FAC
,UPPER(LTRIM(RTRIM(vp.PracticeName))) AS MEDGRP
,UPPER(LTRIM(RTRIM(vlsptn.PracticeTypeName))) AS [VLSPTN_plan_type]
,UPPER(LTRIM(RTRIM(vp.PracticeTypeName))) AS [VP_plan_type] --per MS. SANDRA email ON 20180131 '...Yes.  All of the plan types for facilities should come FROM the products not the practices....'
,UPPER(LTRIM(RTRIM(vlp.PracticeTypeName))) AS [VLP_plan_type] --per MS. SANDRA email ON 20180131 '...Yes.  All of the plan types for facilities should come FROM the products not the practices....'
,UPPER(LTRIM(RTRIM(vlp.ProductTypeCode))) AS [VLP_Alt_plan_type] --per MS. SANDRA email ON 20180131 '...Yes.  All of the plan types for facilities should come FROM the products not the practices....'
,UPPER(LTRIM(RTRIM(vlp.ProductTypeName))) AS [VLP_full_plan_name] --per MS. SANDRA email ON 20180131 '...Yes.  All of the plan types for facilities should come FROM the products not the practices....'
,UPPER(LTRIM(RTRIM(vp.PracticeTypeName))) AS [plan_type] --per MS. SANDRA email ON 20180131 '...Yes.  All of the plan types for facilities should come FROM the products not the practices....'
,vea.TableName,vea.EntityCode,vea.EntityName,vea.EntityTypeCode,vea.EntityTypeName 
,vp.PracticeName,vpl.LocationName,vp.LegalName AS [VPLegalName],vpl.LegalName AS [VPLLegalName]
,UPPER(LTRIM(RTRIM(vpl.LocationName))) AS [HospitalName]
,UPPER(LTRIM(RTRIM(vpl.LocationName))) AS [FacilityName]
,UPPER(LTRIM(RTRIM(vpl.LocationName))) AS [Clinic Name]
,UPPER(LTRIM(RTRIM(vpl.LocationName))) AS [Pharmacy Name] --We have most of the NPIs for the clinics.  They are located in the NPI field in the address master
,UPPER(LTRIM(RTRIM(vp.PracticeName))) AS [Alt. Clinic Name]
,UPPER(LTRIM(RTRIM(vp.PracticeName))) AS [ClinicNameAgain]
,UPPER(LTRIM(RTRIM(vp.PracticeName))) AS [DBA]
,LTRIM(RTRIM(vp.NationalProviderID)) AS altNPIis
,REPLACE(UPPER(LTRIM(RTRIM(vf.TaxIDNumber))),'-','') AS vfPROVTAXID
,CASE
WHEN vpl.NationalProviderID IS NULL
	AND UPPER(LTRIM(RTRIM(vf.FacilityStatus))) LIKE 'ACTIVE%'
	AND UPPER(LTRIM(RTRIM(vf.ApplicationStatus))) LIKE 'ACTIVE%'
THEN LTRIM(RTRIM(vf.NationalProviderID))
ELSE LTRIM(RTRIM(vpl.NationalProviderID)) 
END AS [NPIis]
INTO #TEMPTABLEFACALERT
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT UPPER(LTRIM(RTRIM(vlp.InDirectory))) AS [INDIRECTORY],UPPER(LTRIM(RTRIM(vpl.LocationName))) AS [FAC Name],UPPER(LTRIM(RTRIM(vpl.LineNumber1))) AS [address1] -- CHECK 1st
FROM eVips_chgcv.dbo.vwPractices AS vp
	JOIN eVips_chgcv.dbo.vwPracticeLocations AS vpl ON vp.PracticeID = vpl.PracticeID
		LEFT JOIN eVips_chgcv.dbo.vwLocationServices AS vlsptn ON vpl.LocationID = vlsptn.PracticeID
		LEFT JOIN eVips_chgcv.dbo.vwFacilities AS vf ON vpl.LocationName = vf.FacilityName
			OR vp.PracticeName = vf.FacilityName
		LEFT JOIN (SELECT DISTINCT PracticeID,ClassOrCategory, ServiceTypeName,ServiceCategoryTypeName FROM eVips_chgcv.dbo.vwLocationServices WHERE ServiceTypeName LIKE '%GROUP%SPEC%') AS vls ON vp.PracticeID = vls.PracticeID -- DEFINE FAC CHAPTER(s) 		
		LEFT JOIN (SELECT DISTINCT LocationID,PracticeID,ClassOrCategory, ServiceTypeName,ServiceCategoryTypeName,code1,code2 FROM eVips_chgcv.dbo.vwLocationServices WHERE UPPER(LTRIM(RTRIM(ServiceTypeName))) LIKE '%PHARM%TYPE%' AND ServiceCategoryTypeName IS NOT NULL AND UPPER(LTRIM(RTRIM(ServiceCategoryTypeName))) != '') AS vlspharmtype ON vp.PracticeID = vlspharmtype.PracticeID --DEFINE PHARM TYPE(s)
			AND vpl.LocationID = vlspharmtype.LocationID -- per YOUNG LADY LAURA email ON 20171221 ... Products (CMC & MEDICAL)  are stored at Location Level. The code below is joining based only ON Practice ID. This should be based ON PracticeID + Location
		LEFT JOIN (SELECT DISTINCT LocationID,PracticeID,ClassOrCategory, ServiceTypeName,ServiceCategoryTypeName,code1,code2 FROM eVips_chgcv.dbo.vwLocationServices WHERE UPPER(LTRIM(RTRIM(ServiceTypeName))) LIKE '%PHARM%SERV%' AND ServiceCategoryTypeName IS NOT NULL AND UPPER(LTRIM(RTRIM(ServiceCategoryTypeName))) != '') AS vlspharmservice ON vp.PracticeID = vlspharmservice.PracticeID --DEFINE PHARM TYPE(s)
			vpl.LocationID = vlspharmservice.LocationID -- per YOUNG LADY LAURA email ON 20171221 ... Products (CMC & MEDICAL)  are stored at Location Level. The code below is joining based only ON Practice ID. This should be based ON PracticeID + Location
		LEFT JOIN (SELECT DISTINCT PracticeID,Code1,Code2,ServiceTypeName,ServiceCategoryTypeName FROM eVips_chgcv.dbo.vwLocationServices WHERE ServiceTypeName LIKE '274%TYPE%SERV%') AS vlsfocus ON vp.PracticeID = vlsfocus.PracticeID --Alt EFFORT TO DEFINE FAC CHAPTER(s)
		LEFT JOIN (SELECT DISTINCT ProviderID,TableName,EntityCode,EntityName,EntityTypeCode,EntityTypeName FROM eVips_chgcv.dbo.vwEntityAssignments WHERE TableName LIKE '%PRACTI%') AS vea ON vp.ProviderID = vea.PracticeID
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

		LEFT JOIN (SELECT DISTINCT LocationID,PracticeID,AccreditationTypeCode,AccreditationTypeName,Notes FROM eVips_chgcv.dbo.vwLocationAccreditations AS vla WHERE vla.Archived IN ('N') OR vla.Archived IS NULL) AS accredboard ON vpl.LocationID = accredboard.LocationID
			AND vpl.PracticeID = accredboard.PracticeID

		LEFT JOIN INFORMATICS.dbo.ZIP_CODES AS zip ON CASE
		WHEN SUBSTRING(LTRIM(RTRIM(vpl.ZipCode)),1,1) = '0'
		THEN '0'+ SUBSTRING(LTRIM(RTRIM(vpl.ZipCode)),2,4)
		WHEN SUBSTRING(LTRIM(RTRIM(vpl.ZipCode)),1,1) = '00'
		THEN '00'+ SUBSTRING(LTRIM(RTRIM(vpl.ZipCode)),3,3)
		ELSE  SUBSTRING(LTRIM(RTRIM(vpl.ZipCode)),1,5) 
		END = SUBSTRING(LTRIM(RTRIM(zip.ZipCode)),1,5) COLLATE DATABASE_DEFAULT

		LEFT JOIN (SELECT DISTINCT zipcode,city,county,RegionTypeName FROM eVips_chgcv.dbo.vwzipcodes WHERE UPPER(LTRIM(RTRIM(ISNULL(county,'')))) LIKE '%SAN%DIEGO%') AS regionis ON CASE WHEN SUBSTRING(LTRIM(RTRIM(vpl.ZipCode)),1,1) = '0' THEN '0'+ SUBSTRING(LTRIM(RTRIM(vpl.ZipCode)),2,4) WHEN SUBSTRING(LTRIM(RTRIM(vpl.ZipCode)),1,1) = '00' THEN '00'+ SUBSTRING(LTRIM(RTRIM(vpl.ZipCode)),3,3) ELSE  SUBSTRING(LTRIM(RTRIM(vpl.ZipCode)),1,5) END = CASE WHEN SUBSTRING(LTRIM(RTRIM(regionis.ZipCode)),1,1) = '0' THEN '0'+ SUBSTRING(LTRIM(RTRIM(regionis.ZipCode)),2,4) WHEN SUBSTRING(LTRIM(RTRIM(regionis.ZipCode)),1,1) = '00' THEN '00'+ SUBSTRING(LTRIM(RTRIM(regionis.ZipCode)),3,3) ELSE  SUBSTRING(LTRIM(RTRIM(regionis.ZipCode)),1,5) END

		LEFT JOIN (SELECT DISTINCT r.FieldName,r.DisplayName,s.specialtycode,s.specialtyName AS [eVIPS_Specialty],r.Value AS [TIMELYACCESS_Profile] FROM evips_chgcv.dbo.vwReferenceUserFields AS r LEFT JOIN evips_chgcv.dbo.vwSpecialties AS s ON r.ParentRecID  = s.specialtyidWHERE r.tablename = 'Specialties' AND r.fieldName = 'Specialty Grouping - Timely Access') AS timelyaccess ON UPPER(LTRIM(RTRIM(ISNULL(vlsfocus.Code1,'')))) = UPPER(LTRIM(RTRIM(ISNULL(timelyaccess.specialtycode,'')))) 

		LEFT JOIN (SELECT DISTINCT r.FieldName,r.DisplayName,s.specialtycode,s.specialtyName AS [eVIPS_Specialty],r.Value AS [HSD_Profile] FROM evips_chgcv.dbo.vwReferenceUserFields AS r LEFT JOIN evips_chgcv.dbo.vwSpecialties AS s ON r.ParentRecID  = s.specialtyidWHERE r.tablename = 'Specialties' AND r.fieldName = 'Specialty Grouping - HSD Network') AS hsd ON UPPER(LTRIM(RTRIM(ISNULL(vlsfocus.Code1,'')))) = UPPER(LTRIM(RTRIM(ISNULL(hsd.specialtycode,''))))

		LEFT JOIN (SELECT DISTINCT LocationID,PracticeID,LTRIM(RTRIM(PhoneNumber))AS [PhoneNumber] FROM eVips_chgcv.dbo.vwLocationPhones WHERE UPPER(LTRIM(RTRIM(PhoneTypeName))) LIKE '%PRIMAR%') AS PHONEprimary ON vpl.practiceid  PHONEprimary.practiceid =  -- PHONE ADD - ON JOIN(s)
			AND vpl.Locationid = PHONEprimary.Locationid-- PHONE ADD - ON JOIN(s)

		LEFT JOIN (SELECT DISTINCT LocationID,PracticeID,LTRIM(RTRIM(PhoneNumber)) AS [PhoneNumber] FROM eVips_chgcv.dbo.vwLocationPhones WHERE UPPER(LTRIM(RTRIM(PhoneTypeName))) LIKE '%FAX%') AS PHONEfax ON vpl.practiceid = PHONEfax.practiceid  -- PHONE ADD - ON JOIN(s)
			AND vpl.Locationid = PHONEfax.Locationid -- FAX ADD - ON JOIN(s)

		LEFT JOIN #ACCESSIBILITY AS acc ON vpl.LocationID = acc.LocationID
				OR vpl.PracticeID = acc.PracticeID

		LEFT JOIN #LIC_FAC AS qupd ON vpl.PracticeID = qupd.PracticeID
			AND vpl.LocationID = qupd.LocationID
			AND vpl.AddressID = qupd.AddressID

		LEFT JOIN #AGERESTRICTION_FAC AS ager ON vpl.LocationID =ager.LocationID
			AND vpl.PracticeID = ager.PracticeID
			AND vlp.ProductID = ager.ProductID

		LEFT JOIN #HOURS_FAC AS h ON vpl.PracticeID = h.PracticeID
			AND vpl.LocationID = h.LocationID

WHERE (vp.Archived IN ('N') --WITH eVIPS LOGICAL BINARY OPTION(s) IN USE •	Must not be archived 
	AND (vp.PracticeStatus IN ('ACTIVE')) --•	Contract Status must be Active
	AND vpl.Archived IN ('N')) --WITH eVIPS LOGICAL BINARY OPTION(s) IN USE •	Must not be archived
	
-- ==============================================================
	-- WHERE CLAUSE IN ADDITION TO #INNETWORK_FAC LOGIC ABOVE --
-- ==============================================================
/* WHERE UPPER(LTRIM(RTRIM(ISNULL(vlp.InDirectory,'')))) LIKE @INDIR --AND LTRIM(RTRIM(ISNULL([INDIRECTORY],''))) LIKE @INDIR --SET @INDIR ='Y' --REMOVE FILTER FOR JOSEPH / TIMELYACCESS HBP(s)... '%' OR 'Y'  OR 'N' --SUBSTRING(UPPER(LTRIM(RTRIM(cert_provider.in_directory))),1,1) LIKE @INDIR --see 'LTRIM(RTRIM(mcred.retrieve_list)) LIKE '%CN%V%' */

AND vp.PracticeTypeName 

WHERE CASE
WHEN vpl.NationalProviderID IS NULL
	AND UPPER(LTRIM(RTRIM(vf.FacilityStatus))) LIKE 'ACTIVE%'
	AND UPPER(LTRIM(RTRIM(vf.ApplicationStatus))) LIKE 'ACTIVE%'
THEN LTRIM(RTRIM(vf.NationalProviderID))
ELSE LTRIM(RTRIM(vpl.NationalProviderID)) 
END IN ('1659359446','','')

WHERE SUBSTRING(LTRIM(RTRIM(PHONEfax.PhoneNumber)),1,3)+'-'+SUBSTRING(LTRIM(RTRIM(PHONEfax.PhoneNumber)),4,3)+'-'+SUBSTRING(LTRIM(RTRIM(PHONEfax.PhoneNumber)),7,4) LIKE '%%%'
WHERE SUBSTRING(LTRIM(RTRIM(PHONEprimary.PhoneNumber)),1,3)+'-'+SUBSTRING(LTRIM(RTRIM(PHONEprimary.PhoneNumber)),4,3)+'-'+SUBSTRING(LTRIM(RTRIM(PHONEprimary.PhoneNumber)),7,4) LIKE '%%%'

WHERE (UPPER(LTRIM(RTRIM(vpl.LocationName))) LIKE 'A%1%' 
	OR UPPER(LTRIM(RTRIM(vp.PracticeName))) LIKE 'A%1%')

WHERE UPPER(LTRIM(RTRIM(vlspharmtype.ServiceCategoryTypeName))) LIKE '%MO%'  --MAIL ORDER PHARMACY(-ies)
 
WHERE UPPER(LTRIM(RTRIM(vp.PracticeID))) IN ('4107796') --UPPER(LTRIM(RTRIM(vp.PracticeID)))  AS [lookup_key]

WHERE UPPER(LTRIM(RTRIM(vpl.LocationID))) IN ('4123984') 

WHERE vlp.ServiceTypeName LIKE '%HOSPITAL%'

WHERE UPPER(LTRIM(RTRIM(vpp.PracticeName))) LIKE '%%%' -- ,UPPER(LTRIM(RTRIM(vpp.PracticeName))) AS [MEDGRP]

		SELECT (SELECT COUNT(DISTINCT([Email])) FROM #TEMPTABLEFACALERT) AS [RECORD COUNT],*
		-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
		-- SELECT DISTINCT ' ' AS 'CHECK 1st',[Email],[ASSOCIATION GROUP],[DBA]
		FROM #TEMPTABLEFACALERT
		WHERE FAXnumber NOT LIKE '000%' --LIKE '%619%281%0194%'
		-- AND [ASSOCIATION GROUP] LIKE '%LA%MAESTR%' 
		-- AND [ASSOCIATION GROUP] NOT LIKE '%NOR%COUN%HEAL%SE%'
		-- ORDER BY [ASSOCIATION GROUP]

					SELECT DISTINCT [Email] 
					-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
					-- SELECT DISTINCT [ASSOCIATION GROUP] -- CHECK 1st
					FROM #TEMPTABLEFACALERT 
					WHERE FAXnumber NOT LIKE '000%' --LIKE '%619%281%0194%'
						--AND [ASSOCIATION GROUP] LIKE '%LA%MAESTR%' 
						--AND [ASSOCIATION GROUP] NOT LIKE '%NOR%COUN%HEAL%SE%'

					SELECT DISTINCT VP_plan_type,VLP_plan_type,plan_type,[VLSPTN_plan_type] FROM #TEMPTABLEFACALERT WHERE FAXnumber IS NOT NULL
					SELECT DISTINCT DBA,FAXnumber FROM #TEMPTABLEFACALERT WHERE FAXnumber IS NOT NULL
					SELECT DISTINCT FacilityName,FAXnumber FROM #TEMPTABLEFACALERT WHERE FAXnumber IS NOT NULL
					SELECT DISTINCT FAXnumber FROM #TEMPTABLEFACALERT WHERE FAXnumber IS NOT NULL
					SELECT * FROM #TEMPTABLEFACALERT WHERE FAXnumber IS NOT NULL						







-- ======================================
	-- NOTE(S) / COMMENT(S) / CHANGE.LOG --
-- ======================================
SELECT ' ' AS 'INTEGRATED HEALTH PARTNERS',* 
FROM INFOAG.INFORMATICS.dbo.[uvw_PROVISO] -- INFOAG = SQLPROD02 IN SQLPRODAPP01
WHERE 1=1
	AND fedid IN ('474334653') -- NPI IN ('1598122871')

-- ==================================================================
	-- BASELINE eVIPS PROVIDER CHECK(s) --
-- ==================================================================
SELECT DISTINCT ' ' AS  'BASELINE eVIPS PROVIDER CHECK(s)',tgi.[TGI_INDICATOR]
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
,DERIVEDPROV.QNXTprovid,DERIVEDPROV.ProviderAlternateID,vpp.ProductName,vpd.NationalProviderID,vpps.SpecialtyCode,vpps.SpecialtyName,vpd.LastName,vpd.FirstName,vpps.InDirectory,vpd.Archived,vpps.Archived,vploc.Archived,vpracloc.Archived,vpd.PractitionerStatus,vpp.Archived,vpp.StatusTypeName
,vploc.*
,proveth.*
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
		
WHERE 1=1 

	-- AND 
	-- ( -- INITIATE ... REGULAR PROVIDER 'IN NETWORK / IN DIRECTORY LOGIC'
	-- UPPER(LTRIM(RTRIM(ISNULL(vpps.InDirectory,'')))) LIKE @INDIR --SET @INDIR ='Y' --REMOVE FILTER FOR JOSEPH / TIMELYACCESS HBP(s)... '%' OR 'Y'  OR 'N' --SUBSTRING(UPPER(LTRIM(RTRIM(cert_provider.in_directory))),1,1) LIKE @INDIR --see 'LTRIM(RTRIM(mcred.retrieve_list)) LIKE '%CN%V%'
		-- AND UPPER(LTRIM(RTRIM(vpd.Archived))) IN ('N') --WITH eVIPS LOGICAL BINARY OPTION(s) IN USE •	Must not be archived 
		-- AND UPPER(LTRIM(RTRIM(vpps.Archived))) IN ('N') -- ADD ON per MEETING ;WITH YOUNG LADY LAURA, SC & HL ON 20171226
		-- AND UPPER(LTRIM(RTRIM(vploc.Archived))) IN ('N') --WITH eVIPS LOGICAL BINARY OPTION(s) IN USE •	Must not be archived
		-- AND UPPER(LTRIM(RTRIM(vpracloc.Archived))) IN ('N')
		-- AND UPPER(LTRIM(RTRIM(ISNULL(vpd.PractitionerStatus,'')))) IN ('ACTIVE','') --•	Overall Status must be Active
		-- AND UPPER(LTRIM(RTRIM(vpp.Archived))) IN ('N') --WITH eVIPS LOGICAL BINARY OPTION(s) IN USE •	Must not be archived 
		-- ) -- CONCLUDE ... REGULAR PROVIDER 'IN NETWORK / IN DIRECTORY LOGIC'
		-- AND ISNULL(vpp.StatusTypeName,'') IN ('Y','','Active','Active - Per Diem') --•	Plan Status must be: ‘Active’ or ‘Active Per Diem’ or Active VIP for a Product Name (CMC or MEDICAL):

	AND vpd.PractitionerID IN 
	( -- INITIATE ...
	SELECT DISTINCT PractitionerID 
	FROM eVips_chgcv.dbo.vwPractitionerLicenses
	WHERE 1=1 
		AND LicenseNumber LIKE '%ACE%'
		) -- CONCLUDE ...

	AND vpd.NationalProviderID IN ('')

	AND vpd.PractitionerID IN ('')

	AND UPPER(LTRIM(RTRIM(vpp.PracticeName))) LIKE '%ABLE%TO%' -- AS [DBA]
	






-- ==================================================================
	-- BASELINE eVIPS FACILITY CHECK(s) --
-- ==================================================================
SELECT DISTINCT ' ' AS 'BASELINE eVIPS FAC CHECK(s)',vlp.ProductName
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
WHERE 1=1 
	--  AND vp.Archived IN ('N') --WITH eVIPS LOGICAL BINARY OPTION(s) IN USE •	Must not be archived 
	 -- AND ISNULL(vp.PracticeStatus,'') IN ('ACTIVE','CONTRACTED','NA','') --•	Contract Status must be Active
	 -- AND vpl.Archived IN ('N') --WITH eVIPS LOGICAL BINARY OPTION(s) IN USE •	Must not be archived
	 
	AND CASE
	WHEN vpl.NationalProviderID IS NULL
		AND UPPER(LTRIM(RTRIM(vf.FacilityStatus))) LIKE 'ACTIVE%'
		AND UPPER(LTRIM(RTRIM(vf.ApplicationStatus))) LIKE 'ACTIVE%'
	THEN LTRIM(RTRIM(vf.NationalProviderID))
	ELSE LTRIM(RTRIM(vpl.NationalProviderID)) 
	END IN ('1396873451') -- AS [NPIis]
	
	AND LTRIM(RTRIM(vp.NationalProviderID)) IN ('1396873451') -- AS altNPIis 

	AND REPLACE(UPPER(LTRIM(RTRIM(vf.TaxIDNumber))),'-','') IN ('1396873451') -- AS vfPROVTAXID

	AND REPLACE(UPPER(LTRIM(RTRIM(vf.TaxIDNumber))),'-','') IN ('1396873451') -- AS [FEID vfPROVTAXID]	

	AND vp.LegalName LIKE '%CareClix%'
	AND vpl.LineNumber1 LIKE '%2888%LOKER%' -- ,vpl.LineNumber2,vpl.City
	
	AND UPPER(LTRIM(RTRIM(vp.PracticeName))) LIKE '%TELEMED%' -- AS [DBA]
	
	AND vpl.LocationID IN ('4108469')








-- =====================================================================
	-- ISO FOR CHPIV (COMMUNITY HEALTH PLAN OF IMPERIAL VALLEY) IN eVIPS: --
-- =====================================================================
		SELECT DISTINCT ' ' AS 'eVIPS Practitioner LOB OPTION(S)',ProductName 
		FROM eVips_chgcv.dbo.vwPractitionerProducts
		
SELECT '' AS 'ISO FOR CHPIV [ProductName] AS LOB IN eVIPS',vpp.ProductName,* -- C00#: IDENTIFY CHPIV PER MEETING WITH() MS JOHANNA AND MS SANDRA ON 20250219
FROM eVips_chgcv.dbo.vwPractitionerDemographics AS vpd
	JOIN eVips_chgcv.dbo.vwPractitionerProducts AS vpp ON vpd.PractitionerID = vpp.PractitionerID -- aka cert_provider
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
WHERE 1=1
	AND vpp.ProductName LIKE '%CHPIV%'
	AND vpd.NationalProviderID IN ('1043356850') -- TEST CHPIV PROVIDER "Ahmad Bushra"		







-- =====================================================================
		-- CCA (COVERED CA) AND  'HCAI' = Healthcare Access Information: --
-- =====================================================================
-- =====================================================================
	-- COMMENT(S) / CHANGE.LOG: --
-- =====================================================================
-- C001: MODIFY AS LEFT JOIN TO evips_chgcv.dbo.vwLocationProductServices HERE: DEVELOP COVERED CA SQL SCRIPT PER MEETING WITH() MS JOHANNA AND MS SANDRA ON 20250219

-- C002: UPDATE FOR MY204 AS OF 20250203 The DMHC’s standardized terminology is set forth in appendices A-F of the Annual Network Submission Instruction Manual for RY 2025. The health plan should also refer to the “Standardized Terminology and Other Reporting Resources” section of the Resources tab ON the Timely Access and Annual Network Reporting Web Portal for information ON standardized terminology resources. Please note, the DMHC relies ON the California Licensed Healthcare Facility Listing released by the California Department of Healthcare Access Information ('HCAI') to populate the Hospital and Other Inpatient Facility Name section of the Crosswalks tab. In addition, for RY 2025 the DMHC added a field for “'HCAI' ID” within the Hospital Report tab of the Hospital and Clinic Report Form. The “'HCAI' ID” field captures the unique identifier established by 'HCAI' to identify facilities used in the Licensed Facility Information System (LFIS). (See All Plan Letter (APL) 24-019.) The Plan may use the facility information provided ON www.'HCAI'.ca.gov to review its terminology and to identify the 'HCAI' ID for completing the Hospital and Clinic Report Form ... USE https://www.HCAI.ca.gov	

		USE http://devops01:8080/IS/Informatics/_git/Informatics?path=%2FCovered%20Ca%20Network&version=GBMain - 'GITHUB'
		
		SELECT DISTINCT ' ' AS 'eVIPS Location LOB OPTION(S)',ProductName 
		FROM eVips_chgcv.dbo.vwLocationProducts
		
		SELECT ' ' AS 'see "WC Master CCA Amendment Tracker_Working File _02.06.25.xlsx"',* 
		FROM INFORMATICS.dbo.CCA_PROVGROUP

;WITH mcalid AS 
( -- INITIATE ...
SELECT DISTINCT ' ' AS 'ISO FOR MEDI-CAL [ProductName] AS LOB IN eVIPS',vlp.productname
,vp.PracticeID
,vp.PracticeName
,vp.TaxIDNumber AS [PracticeDBATAXID]
,vp.NationalProviderID AS [PracticeDBANPI]
,vpl.LocationID
,vpl.LocationName
,vpl.TaxIDNumber AS [LocationTAXID]
,vpl.NationalProviderID AS [LocationNPI] -- ,*
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
		JOIN evips_chgcv.dbo.vwLocationProductServices AS vlpstype ON ljvlp.LocationProductRecID = vlpstype.LocationProductRecID
			AND ISNULL(vlpstype.Archived,'') IN ('N','')
	WHERE 1=1
		 AND ISNULL(ljvlp.Archived,'') IN ('N','') 
		 AND (ISNULL(ljvlp.StatusTypeName,'') IN ('ACTIVE','') 
			 OR ljvlp.StatusTypeName LIKE '%PARTICIP%')
			) -- CONCLUDE ...
			AS vlp ON vpl.PracticeID = vlp.PracticeID --'YOUNG LADY LAURA GAH ID WHERE p.archived = 'N' AND s.ServiceTypeName = 'HOSPITAL' AND p.focus like '%GAH%'' ON 20171120 see ,UPPER(LTRIM(RTRIM(vlp.ServiceTypeName))) AS [vlpSERVICETYPENAME]
			-- AND vpl.LocationID = vlp.LocationID -- per YOUNG LADY LAURA email ON 20171221 ... Products (CMC & MEDICAL)  are stored at Location Level. The code below is joining based only ON Practice ID. This should be based ON PracticeID + Location
				AND vlp.ProductName LIKE '%MEDICAL%'
				) -- CONCLUDE 

		/* SELECT DISTINCT ' ' AS 'ISO FOR MEDI - CAL [ProductName]',PracticeName
		FROM mcalid
		
		SELECT * 
		FROM mcalid
		WHERE 1=1
			AND PracticeName LIKE '%FAMIL%HEAL%CENTER%' */
			
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
			
,hcai AS 
( -- INITIATE ...
SELECT DISTINCT ' ' AS 'HCAI (Healthcare Access Information)',PracticeID
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

		/* SELECT ' ' AS 'Test file: Kindred Hospital - San Diego ',* 
		FROM hcai 
		WHERE 1=1 
			AND [HCAI ID] IN ('106370759')
				OR LocationName LIKE '%KINDRED%'
				OR LocationName LIKE '%THORTON%'
				OR LocationName LIKE '%SCRIP%REHAB%' */
		
,TRY_CONVERT(nvarchar(25),NULL) AS [HCAI ID] -- C002: UPDATE FOR MY204 AS OF 20250203 The DMHC’s standardized terminology is set forth in appendices A-F of the Annual Network Submission Instruction Manual for RY 2025. The health plan should also refer to the “Standardized Terminology and Other Reporting Resources” section of the Resources tab ON the Timely Access and Annual Network Reporting Web Portal for information ON standardized terminology resources. Please note, the DMHC relies ON the California Licensed Healthcare Facility Listing released by the California Department of Healthcare Access Information ('HCAI') to populate the Hospital and Other Inpatient Facility Name section of the Crosswalks tab. In addition, for RY 2025 the DMHC added a field for “'HCAI' ID” within the Hospital Report tab of the Hospital and Clinic Report Form. The “'HCAI' ID” field captures the unique identifier established by 'HCAI' to identify facilities used in the Licensed Facility Information System (LFIS). (See All Plan Letter (APL) 24-019.) The Plan may use the facility information provided ON www.'HCAI'.ca.gov to review its terminology and to identify the 'HCAI' ID for completing the Hospital and Clinic Report Form ... USE https://www.HCAI.ca.gov	

		/* Test file: Kindred Hospital - San Diego 
		NPI: 1992880512
		Locationid: 5508038
		HCAI: 106370759 ??? DIFFERENT [HCAI ID]: '106370721'
		IN: Evips location: Providers/Groups tab/Locations/Practice/Location Services/HCAI/Notes=HCAI #
		
		LEFT JOIN 
		( -- INITIATE ...
		SELECT DISTINCT PracticeID,ClassOrCategory, ServiceTypeName,ServiceCategoryTypeName,Code1,Code2,LocationID,Notes
		FROM eVips_chgcv.dbo.vwLocationServices 
		WHERE 1=1
			AND ServiceTypeName LIKE '%HCAI%'
		) -- CONCLUDE ...
		AS hcai ON vp.PracticeID = vls.PracticeID -- DEFINE FAC CHAPTER(s) */







-- ===============================================================================
	-- ICF/DD = Intermediate Care Facility for Developmentally Disabled Transition RENDERING / PAYTO --
-- ===============================================================================
DROP TABLE IF EXISTS #ICF -- SQL Server 2016 and later -- DYNAMIC tmp OR STATIC [TABLE] #INFORMATICS.dbo.SHELLclaimlist_TOPDIAG is a local temporary table visible only in the current session; ##INFORMATICS.dbo.SHELLclaimlist_TOPDIAG is a GLOBAL temporary table visible to all sessions IN ('TempDB')

SELECT DISTINCT ' ' AS 'IDENTIFY ICF/DD = Intermediate Care Facility for Developmentally Disabled Transition','see "FW  CHG LTC ICF DD Network Readiness Requirements and Network Readiness Template.msg" FROM SIR SALIM' AS [MESSAGE(S)],vls.LocationID,vls.LocationName,vls.PracticeID,vls.PracticeName,vls.ServiceTypeName,vls.ServiceTypeCode,vp.NationalProviderID -- ,vls.*,vp.*
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st',
INTO #ICF
FROM evips_chgcv.dbo.vwLocationServices AS vls
	LEFT JOIN evips_chgcv.dbo.vwPractices AS vp ON vls.PracticeId = vp.PracticeId
	
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
			AS vlp ON vls.PracticeID = vlp.PracticeID --'YOUNG LADY LAURA GAH ID WHERE p.archived = 'N' AND s.ServiceTypeName = 'HOSPITAL' AND p.focus like '%GAH%'' ON 20171120 see ,UPPER(LTRIM(RTRIM(vlp.ServiceTypeName))) AS [vlpSERVICETYPENAME]
				AND vls.LocationID = vlp.LocationID -- per YOUNG LADY LAURA email ON 20171221 ... Products (CMC & MEDICAL)  are stored at Location Level. The code below is joining based only ON Practice ID. This should be based ON PracticeID + Location
WHERE 1=1 
	AND UPPER(LTRIM(RTRIM(ISNULL(vlp.ServiceTypeName,'')))) LIKE '%INTERMEDIATE%CARE%FACILITIES%' -- PER DISCUSSION WITH() MS JOHANNA + MS SANDRA REGARDING ADDING ICF AS A PROVDIR_ICF CHAPTER ON 202402029
	-- AND UPPER(LTRIM(RTRIM(ISNULL(vp.NationalProviderID,''))))  IN ('1073736427','1831124890','1639392079','1336368984','1114124849','1053518779','1134342520','1417183831','1982839320','1922233469','1679708028','1699901017','1477789832','1972739399','1881820207','1164658589','1205061645','1659506012','1154557577','1922277698','1427284843','1063648483') -- ICF NPI(S) FROM SIR SALIM FILE see "COC_SURVEY_..."

		SELECT * FROM #ICF







-- ==================================================================
	-- BASELINE SUBACUTE FACILITIES (SNFs) FOR EAE NETWORK --
-- ==================================================================
DROP TABLE IF EXISTS #SUBACUTEFAC -- SQL Server 2016 and later -- DYNAMIC tmp OR STATIC [TABLE] #INFORMATICS.dbo.SHELLclaimlist_TOPDIAG is a local temporary table visible only in the current session; ##INFORMATICS.dbo.SHELLclaimlist_TOPDIAG is a GLOBAL temporary table visible to all sessions IN ('TempDB')

SELECT DISTINCT ' ' AS 'IDENTIFY SUBACUTE FACILITIES (SNFs) via eVips (Symplr)',vls.LocationID,vls.LocationName,vls.PracticeID,vls.PracticeName,vls.ServiceTypeName,vls.ServiceTypeCode,vp.NationalProviderID -- ,vls.*,vp.*
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st',
INTO #SUBACUTEFAC
FROM SQLPRODAPP01.evips_chgcv.dbo.vwLocationServices AS vls
	LEFT JOIN SQLPRODAPP01.evips_chgcv.dbo.vwPractices AS vp ON vls.PracticeId = vp.PracticeId
WHERE 1=1 
	AND ServiceTypeName LIKE '%ACUTE%' -- LIKE '%SAFETY%PROV%'

		SELECT * FROM #SUBACUTEFAC
