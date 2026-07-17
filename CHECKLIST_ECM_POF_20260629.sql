-- =====================================================================
	-- CHATGPT_ECMPOF_ADULTWITHFAMILY_HOMELESS -- ALGORITHM LOGIC --
-- =====================================================================
		USE http://devops01:8080/IS/_git/Informatics?path=%2FECM%20POF%20Counts&version=GBdev-chatgpt-snowflake - 'REPO'

SELECT ' ' AS 'PROVIDER PORTAL | ASSIGNED ALGORITHM LOGIC Unique Member Count by ECM Provider - CHATGPT_ECMPOF_ADULTWITHFAMILY_HOMELESS'
,pof.TargetPopulation
,mpa.ProviderID
,prov.NPI
,prov.fullname AS [ECM Provider]
,COUNT(DISTINCT(pof.memid)) AS [Unique Member Count]
FROM INFORMATICS.dbo.CHATGPT_ECMPOF_ADULTWITHFAMILY_HOMELESS (NOLOCK) AS pof -- ALGORITHM POF LOGIC ADJUSTMENT
	INNER JOIN ProviderPortal.ECM.Member (NOLOCK) AS m ON pof.memid = m.MemberId
		LEFT JOIN [ProviderPortal].[ECM].[MemberProviderAssigment] (NOLOCK) AS mpa ON pof.memid = mpa.MemberId
			AND ISNULL(mpa.TermDate,'12/31/2078') >= GETDATE()
		LEFT JOIN HMOPROD_PLANDATA.dbo.[provider] (NOLOCK) AS prov ON mpa.ProviderID = prov.provid
WHERE 1=1
	AND pof.[RunDate] = ( SELECT MAX(i.[RunDate]) FROM INFORMATICS.dbo.CHATGPT_ECMPOF_ADULTWITHFAMILY_HOMELESS AS i WITH (NOLOCK) )
	AND m.ISECM = 1
	AND m.EnrollmentStatus = 'Assigned'
GROUP BY pof.TargetPopulation
,mpa.ProviderID
,prov.NPI
,prov.fullname

JAH '#BASELINE 23K ECM ENROLLED'

x SEQUENCE(ECM DISENROLLMENT): 
		STEP01:   'ECM_POF_STEP1_BASELINE_INELIG_...sql' - ;EXEC IN [SQLPROD02]; JAG CHATGPT_ ALGORITHM ADJUSTMENT TO ECM POF ("CHATGPT 2026 ECM Eligibility Algorithm.docx")
		STEP02:   'ECM_POF_STEP2_DISENROLLMENT_CANDIDATES_...sql' - ;EXEC IN [SQLPROD02]; JAG CHATGPT_ ALGORITHM ADJUSTMENT TO ECM POF ("CHATGPT 2026 ECM Eligibility Algorithm.docx")
		STEP03   'ECM_POF_STEP3_MS_EXCEL_OLE_DB_ODBC_4_WORKSHEET_REFRESH_...sql' - ;EXEC IN [SQLPROD02]; JAG CHATGPT_ ALGORITHM ADJUSTMENT TO ECM POF ("CHATGPT 2026 ECM Eligibility Algorithm.docx")

x THE BET 
		~ 1000 TRUE DROPS
		~ 4000 DUBIOUS DROPS

		USE [PATH]: O:\wcarr\JAHStaging\STEP88 ECM Enrolled Population 20251023.sql -- QNXT ECM ENROLLED
		
		SELECT DISTINCT 'MS KATHRYN [ProviderPortal] ECM ENROLLED'
		,mi..* 
		FROM providerportal.ecm.MembersInformation  AS mi
		WHERE 1=1
			AND Isecm = 1 
			AND enrollmentstatus = 'enrolled'

		⏎ Good evening, we may have an all - nighter on our hands STEP 1:

x JAG is none to pleased with the actual results as he desires to tell a story ultimately with the outcome being that 'we' as an enterprise disenroll 4000 unique members from the ECM Enrolled ranks.

We have gathered a DREAM TEAM & here is where we are Step 1: define the ECM Enrolled Population (Expectation is ~23k unique memids)

The baseline script: C:\Users\wcarr\Desktop\ECM_POF_BASELINE_INELIG_20260715.sql

TABLE: SQLPROD02.INFORMATICS.dbo.BASELINE_QNXT_ProviderPortal_ECM_ENROLLED
I think we are good, may i have you review check our work before I explain the next steps?

		SELECT COUNT(DISTINCT(ecm.memid)) AS 'BASELINE ECM Enrolled MEMBERSHIP' 
		FROM INFORMATICS.dbo.BASELINE_QNXT_ProviderPortal_ECM_ENROLLED AS ecm

		SELECT ' ' AS 'BASELINE ECM Enrolled MEMBERSHIP'
		,bm.HealthPlanId
		,bm.[Member Name]
		,ee.*
		FROM INFORMATICS.dbo.BASELINE_QNXT_ProviderPortal_ECM_ENROLLED AS ee
				LEFT JOIN INFORMATICS.dbo.uvw_BASELINE_MEMBERSHIP AS bm ON ee.memid = bm.memid
		WHERE 1=1
			AND ROWNUMBER_Enrolled = 1

		⏎ STEP 2: EXTRACT the ECM Enrolled population which is going to be DISENROLLED
				~ JAG is 'expecting' this number to be aroung 4000 while my guess is more like 1000
				
We have two sets of ECM POF tables. The 'INFORMATICS.dbo.ECMPOF_...' representing the Existing POF logic tables. THEN we have the 'INFORMATICS.dbo.CHATGPT_ECMPOF_...' tables which represnts the revised logic which JAG believes is the decision maker.

I wish to flag members within the INFORMATICS.dbo.BASELINE_QNXT_ProviderPortal_ECM_ENROLLED table that are present in any of the most current run of the 'INFORMATICS.dbo.ECMPOF_...'  tables WHICH are ABSENT from any of the most current run of the 'INFORMATICS.dbo.CHATGPT_ECMPOF_...' tables.

May I have you assist?

x LOVELY 'MS KATHRYN' WITH THE ASSIST:
 
Here are my notes.
STEPS for tonight
Find unique members
		Walter to run members through new POF algorithm
		Members no longer eligible
		Members no longer eligible for 1 or more of their POFs, but still have at least 1 active
		Kathryn review report to check
		Member Enrollment status
		Current Provider Assignment
		Once reviewed, Paco to run Utilization lists
		Tatsani is reviewing utilization list
		Once reviewed, Allan to send to Joseph by 8AM tomorrow
 
Unique members
		ECM Enrolled attribute is active
		C01213745 = ECM ENROLLED
		ProviderPortal.ECM.Member where ISECM = 1
		Members are only assigned to 1 provider at a time
		[ProviderPortal].[ECM].[MemberProviderAssigment] where provider assignment term date is in the future
		Or use AssignedProviderID SELECT distinct * FROM providerportal.ecm.MembersInformation
 
		SELECT ' ' AS 'FULL DISENROLLMENT CANDIDATES: '
		,bm.HealthPlanId
		,bm.[Member Name]
		,mpa.*
		,dc.*
		FROM INFORMATICS.dbo.STEP2_DISENROLLMENT_CANDIDATES AS dc
				LEFT JOIN INFORMATICS.dbo.uvw_BASELINE_MEMBERSHIP AS bm ON dc.memid = bm.memid
				LEFT JOIN [ProviderPortal].[ECM].[MemberProviderAssigment] (NOLOCK) AS mpa ON dc.memid = mpa.MemberId
					AND ISNULL(mpa.TermDate,'12/31/2078') >= GETDATE()

		SELECT ' ' AS 'PARTIAL DISENROLLMENT CANDIDATES: '
		,bm.HealthPlanId
		,bm.[Member Name]
		,mpa.*
		,partiald.*
		FROM INFORMATICS.dbo.STEP2_RETAINED_FEWER_POFS AS partiald
				LEFT JOIN INFORMATICS.dbo.uvw_BASELINE_MEMBERSHIP AS bm ON partiald.memid = bm.memid
				LEFT JOIN [ProviderPortal].[ECM].[MemberProviderAssigment] (NOLOCK) AS mpa ON partiald.memid = mpa.MemberId
					AND ISNULL(mpa.TermDate,'12/31/2078') >= GETDATE()

-- =====================================================================
	-- QA | MEETING EXPECTATION(S)?: 
-- =====================================================================
DECLARE @ineligmemeber AS nvarchar(255) = '2172282' -- '743166' -- [HealthPlanID]: 1978343927

SELECT * FROM ProviderPortal.ECM.MembersInformation (NOLOCK) AS mi WHERE 1=1 AND MemberID = @ineligmemeber -- 1079481
SELECT * FROM ProviderPortal.ECM.Member (NOLOCK) AS m WHERE 1=1 AND MemberID = @ineligmemeber -- 1079481
SELECT * FROM ProviderPortal.ecm.MemberTargetPopulation (NOLOCK) AS mtp WHERE 1=1 AND MemberID = @ineligmemeber -- 1079481
SELECT * FROM [ProviderPortal].ecm.[StratificationTargetPopulation] AS sta WHERE 1=1 AND MemberID = @ineligmemeber -- '1079481'
SELECT * FROM [ProviderPortal].[ECM].[MemberProviderAssigment] (NOLOCK) AS mpa WHERE 1=1 AND MemberID = @ineligmemeber -- 1079481

-- SELECT ' ' AS 'EXISTING LOGIC:',* FROM INFORMATICS.dbo.ECMPOF_ADULT_MHSMISUD WHERE 1=1 AND memid = @ineligmemeber 
-- SELECT ' ' AS 'ALGORITHM LOGIC:',* FROM INFORMATICS.dbo.CHATGPT_ECMPOF_ADULT_MHSMISUD WHERE 1=1 AND memid = @ineligmemeber

-- WHERE 1=1
	--	AND m.ISECM = 1
	--	AND m.EnrollmentStatus = 'Assigned'
	--	AND prov.fullname LIKE '%CHG%'
	-- AND MemberID = 1079481

SELECT ' ' AS 'WHO IS THIS ECM PROVIDER?: '
,mpa.*
,prov.*
FROM ProviderPortal.ECM.Member (NOLOCK) AS m 
		LEFT JOIN [ProviderPortal].[ECM].[MemberProviderAssigment] (NOLOCK) AS mpa ON m.MemberId = mpa.MemberId
			AND ISNULL(mpa.TermDate,'12/31/2078') >= GETDATE()
		LEFT JOIN HMOPROD_PLANDATA.dbo.[provider] (NOLOCK) AS prov ON mpa.ProviderID = prov.provid
WHERE 1=1
	AND m.ISECM = 1
	AND m.EnrollmentStatus = 'Assigned'
	-- AND prov.fullname LIKE '%CHG%'
	AND m.MemberID = @ineligmemeber -- 1079481
	
-- =====================================================================
	-- ECMPOF_ADULTWITHFAMILY_HOMELESS -- EXISTING LOGIC --
-- =====================================================================
SELECT ' ' AS 'PROVIDER PORTAL | ASSIGNED EXISTING LOGIC Unique Member Count by ECM Provider - ECMPOF_ADULTWITHFAMILY_HOMELESS'
,pof.TargetPopulation
,mpa.ProviderID
,prov.NPI
,prov.fullname AS [ECM Provider]
,COUNT(DISTINCT(pof.memid)) AS [Unique Member Count]
FROM INFORMATICS.dbo.ECMPOF_ADULTWITHFAMILY_HOMELESS (NOLOCK) AS pof -- EXISTING LOGIC
	INNER JOIN ProviderPortal.ECM.Member (NOLOCK) AS m ON pof.memid = m.MemberId
		LEFT JOIN [ProviderPortal].[ECM].[MemberProviderAssigment] (NOLOCK) AS mpa ON pof.memid = mpa.MemberId
			AND ISNULL(mpa.TermDate,'12/31/2078') >= GETDATE()
		LEFT JOIN HMOPROD_PLANDATA.dbo.[provider] (NOLOCK) AS prov ON mpa.ProviderID = prov.provid
WHERE 1=1
	AND pof.[RunDate] = ( SELECT MAX(i.[RunDate]) FROM INFORMATICS.dbo.ECMPOF_ADULTWITHFAMILY_HOMELESS AS i WITH (NOLOCK) )
	AND m.ISECM = 1
	AND m.EnrollmentStatus = 'Assigned'
GROUP BY pof.TargetPopulation
,mpa.ProviderID
,prov.NPI
,prov.fullname

-- =====================================================================
	-- CHATGPT_ECMPOF_ADULTWITHFAMILY_HOMELESS -- ALGORITHM LOGIC --
-- =====================================================================
SELECT ' ' AS 'PROVIDER PORTAL | ASSIGNED ALGORITHM LOGIC Unique Member Count by ECM Provider - CHATGPT_ECMPOF_ADULTWITHFAMILY_HOMELESS'
,pof.TargetPopulation
,mpa.ProviderID
,prov.NPI
,prov.fullname AS [ECM Provider]
,COUNT(DISTINCT(pof.memid)) AS [Unique Member Count]
FROM INFORMATICS.dbo.CHATGPT_ECMPOF_ADULTWITHFAMILY_HOMELESS (NOLOCK) AS pof -- ALGORITHM POF LOGIC ADJUSTMENT
	INNER JOIN ProviderPortal.ECM.Member (NOLOCK) AS m ON pof.memid = m.MemberId
		LEFT JOIN [ProviderPortal].[ECM].[MemberProviderAssigment] (NOLOCK) AS mpa ON pof.memid = mpa.MemberId
			AND ISNULL(mpa.TermDate,'12/31/2078') >= GETDATE()
		LEFT JOIN HMOPROD_PLANDATA.dbo.[provider] (NOLOCK) AS prov ON mpa.ProviderID = prov.provid
WHERE 1=1
	AND pof.[RunDate] = ( SELECT MAX(i.[RunDate]) FROM INFORMATICS.dbo.CHATGPT_ECMPOF_ADULTWITHFAMILY_HOMELESS AS i WITH (NOLOCK) )
	AND m.ISECM = 1
	AND m.EnrollmentStatus = 'Assigned'
GROUP BY pof.TargetPopulation
,mpa.ProviderID
,prov.NPI
,prov.fullname

-- =====================================================================
	-- ECMPOF_ADULTWITHFAMILY_HOMELESS -- EXISTING LOGIC --
-- =====================================================================
SELECT ' ' AS 'QNXT NO ECM FILTER| EXISTING LOGIC Unique Member Count by ECM Provider - ECMPOF_ADULTWITHFAMILY_HOMELESS'
,pof.TargetPopulation
,COUNT(DISTINCT(pof.memid)) AS [Unique Member Count]
FROM INFORMATICS.dbo.ECMPOF_ADULTWITHFAMILY_HOMELESS (NOLOCK) AS pof -- EXISTING LOGIC
WHERE 1=1
	AND pof.[RunDate] = ( SELECT MAX(i.[RunDate]) FROM INFORMATICS.dbo.ECMPOF_ADULTWITHFAMILY_HOMELESS AS i WITH (NOLOCK) )
GROUP BY pof.TargetPopulation

-- =====================================================================
	-- CHATGPT_ECMPOF_ADULTWITHFAMILY_HOMELESS -- ALGORITHM LOGIC --
-- =====================================================================
SELECT ' ' AS 'QNXT NO ECM FILTER | ALGORITHM LOGIC Unique Member Count by ECM Provider - CHATGPT_ECMPOF_ADULTWITHFAMILY_HOMELESS'
,pof.TargetPopulation
,COUNT(DISTINCT(pof.memid)) AS [Unique Member Count]
FROM INFORMATICS.dbo.CHATGPT_ECMPOF_ADULTWITHFAMILY_HOMELESS (NOLOCK) AS pof -- ALGORITHM POF LOGIC ADJUSTMENT
WHERE 1=1
	AND pof.[RunDate] = ( SELECT MAX(i.[RunDate]) FROM INFORMATICS.dbo.CHATGPT_ECMPOF_ADULTWITHFAMILY_HOMELESS AS i WITH (NOLOCK) )
GROUP BY pof.TargetPopulation







JAH '[ProviderPortal] TABLES:'
Search "ProviderPortal" (19 hits in 1 file of 1 searched) [Extended]
  C:\Users\wcarr\Desktop\ECM-CS Quartely Report_Tab 1 20260715.sql (19 hits)
	Line    9: -- C002: [TargetPopulation] ⏎ IN the 20240418 script, the POF assessment is updated to use the [ProviderPortal].ecm.[StratificationTargetPopulation] table instead, AS per the guidance FROM the ECM weekly teams meeting ON 20240418.
	Line   15: 		/* LEFT JOIN ProviderPortal.ecm.MemberTargetPopulation AS ECM_MT ON ECM_MT.MemberId = ECM.memid
	Line   16: 		LEFT JOIN ProviderPortal.ecm.StratificationTargetPopulation AS ECM_MT ON ECM.memid = ECM_MT.MemberId */
	Line   89: FROM ProviderPortal.ecm.MemberTargetPopulation 
	Line   95: FROM ProviderPortal.ecm.StratificationTargetPopulation
	Line  159: 	LEFT JOIN ProviderPortal.ECM.Member AS m ON m.MemberId = a1.memid
	Line  203: 	INNER JOIN ProviderPortal.ECM.Member AS ECM_M ON ECM.memid = ECM_M.memberid
	Line  205: 	INNER JOIN ProviderPortal.ecm.MemberProviderAssigment AS ECM_P ON ECM_P.MemberId = ECM.memid
	Line  217: 		-- LEFT JOIN ProviderPortal.ecm.MemberTargetPopulation AS ECM_MT ON ECM_MT.MemberId = ECM.memid
	Line  218: 		-- LEFT JOIN ProviderPortal.ecm.StratificationTargetPopulation AS ECM_MT ON ECM.memid = ECM_MT.MemberId  -- C002: [TargetPopulation] ? IN the 20240418 script, the POF assessment is updated to use the [ProviderPortal].ecm.[StratificationTargetPopulation] table instead, AS per the guidance FROM the ECM weekly teams meeting ON 20240418.
	Line  300: 		-- LEFT JOIN ProviderPortal.ecm.MemberTargetPopulation AS ECM_MT ON ECM_MT.MemberId = ECM.memid
	Line  301: 		-- LEFT JOIN ProviderPortal.ecm.StratificationTargetPopulation AS ECM_MT ON ECM.memid = ECM_MT.MemberId  -- C002: [TargetPopulation] ? IN the 20240418 script, the POF assessment is updated to use the [ProviderPortal].ecm.[StratificationTargetPopulation] table instead, AS per the guidance FROM the ECM weekly teams meeting ON 20240418.
	Line  421: 		LEFT JOIN ProviderPortal.ecm.MemberDisenrollment AS ECMD ON ECMD.MemberId = ECM.memid
	Line  422: 		LEFT JOIN ProviderPortal.ecm.DisenrollmentReasons AS ECMDR ON ECMDR.DHCSCode = ECMD.Code
	Line  534: FROM [SQLPROD02].[ProviderPortal].[ECM].[MemberProviderAssigment]    
	Line  558: LEFT JOIN ProviderPortal.ECM.MemberOutreach AS ECMMem ON ECMMem.MemberId = ECM.memid
	Line  980: FROM ProviderPortal.ECM.MemberOutreach AS mo

-- ===============================================================================
	-- JAH CHECKLIST - ECM (ENHANCED CARE MANAGEMENT) POF (POPULATION OF FOCUS): 
-- ===============================================================================
JAH CHARINDEX() FIND() SEARCH() SOURCE(S) 'SUBJECT ECM HOMELESS MS KATHRYN',*HOMELESS*.sql,*HEDIS*.sql,*IPP*.sql,*HHIP*.sql,*HOMELESS*.rar,*HEDIS*.rar,*IPP*.rar,*HHIP*.rar,'DHCS has identified sixteen 16 mandatory ECM “target populations.” MCPs must proactively identify their high-need, high-cost Members who meet the target population criteria and offer them ECM. These target populations are':, SUBJECT:"*POF*" FROM:NOREPLY

		-- USE http://devops01:8080/IS/_git/Informatics?path=%2FECM%20POF%20Counts%2FECM%20POF%20JI%20JUSTICE%20INVOLVED%20INCARCERATION.sql&version=GBMain - 'REPO'
		USE http://devops01:8080/IS/_git/Informatics?path=%2FECM%20POF%20Counts&version=GBdev-chatgpt-snowflake - 'REPO'
		
SELECT ' ' AS 'loads the 215-row NDC list:',* FROM INFORMATICS.dbo.DMC_QUALIFYING_NDC_LIST -- see "BUILD-DMC-NDC-List-20260708.xlsx"
SELECT ' ' AS 'JAG CRITERION III: UTILIZATION/RISK (PARTIAL BUILD)',* FROM INFORMATICS.dbo.HEDIS_UTILIZATIONRISK_CODESET -- see "POF NCQA HEDIS Technical Specifications 20260710.xlsx"

SELECT *  
FROM INFORMATICS.dbo.ECMPOF_ADULTWITHOUTFAMILY_HOMELESS AS pof
WHERE 1=1 
            AND pof.[RunDate] = '2026-06-28' -- ( SELECT MAX( i.[RunDate] )FROM INFORMATICS.dbo.ECMPOF_ADULTWITHOUTFAMILY_HOMELESS AS i WITH (NOLOCK) )

SELECT *  
FROM INFORMATICS.dbo.CHATGPT_ECMPOF_ADULTWITHOUTFAMILY_HOMELESS AS pof
WHERE 1=1 
            AND pof.[RunDate] = ( SELECT MAX( i.[RunDate] )FROM INFORMATICS.dbo. CHATGPT_ECMPOF_ADULTWITHOUTFAMILY_HOMELESS AS i WITH (NOLOCK) )

SELECT DISTINCT RunDate FROM INFORMATICS.dbo.ECMPOF_ADULTWITHOUTFAMILY_HOMELESS AS pof ORDER BY RunDate DESC
SELECT DISTINCT RunDate FROM INFORMATICS.dbo.CHATGPT_ECMPOF_ADULTWITHOUTFAMILY_HOMELESS AS pof ORDER BY RunDate DESC

		⏎ ACT AS a Senior Data Analyst. May I have you PROVIDE '#MERMAID' FLOW CHART ... Please SUMMARIZE, EXAMINE, EXPLAIN AND INTERPRET the concept deployed IN the ATTACHED. PLEASE PROVIDE a detailed report suitable for PEER CODE REVIEW
		
		⏎ ACT AS a Senior Data Analyst. May I have you OPTIMIZE code to IMPROVE performance, readability, AND maintainability PLEASE retain any COMMENT LINES AND USE 'AS' PRIOR TO ASSIGNING TABLE / FIELD ALIAS. PLEASE ensure that SELECT statements are not left alone on their own lines.

		⏎ ACT AS a Senior Data Analyst. May I have you PLEASE PROVIDE a detailed CHANGE.LOG report based on the attached SQL scripts.
		
		⏎ ACT AS a Senior Data Analyst WITH 20+ years OF EXPERIENCE. PLEASE OPTIMIZE the attached CODE taking SQL QUERY EXECUTION ORDER OF OPERATION(S) INTO consideration FOR performance, readability, AND maintainability 

		⏎ ACT AS a Senior Data Analyst WITH 20+ years of EXPERIENCE. In the voice of Robert F Smith CEO of Vista Equity, May I have you PLEASE ENSURE ALIGNMENT BETWEEN the existing CODE AND the REQUIREMENTS attached FOR CONTEXT (starting with the ... Child CODE scripts): 
		
		⏎ ACT AS a Senior Data Analyst WITH 20+ years of EXPERIENCE. In the voice of Robert F Smith CEO of Vista Equity, May I have you PLEASE ENSURE ALIGNMENT BETWEEN the existing CODE AND the REQUIREMENTS attached FOR CONTEXT (now with the ... Adult CODE scripts): 
		
		⏎ ACT AS a Senior Data Analyst WITH 20+ years of EXPERIENCE. I have 18 existing tables, see them listed below:		

		-- SELECT TOP 1 *FROM INFORMATICS.dbo.ECMPOFPCP -- SUNSET DEPRECATE DECOMMISSION PCP TABLE
		SELECT targetpopulation,COUNT(DISTINCT(memid)) AS 'Unique Member Count' FROM INFORMATICS.dbo.ECMPOF_CHILD_HOMELESS GROUP BY TargetPopulation
		SELECT targetpopulation,COUNT(DISTINCT(memid)) AS 'Unique Member Count' FROM INFORMATICS.dbo.ECMPOF_CHILDWITHFAMILY_HOMELESS GROUP BY TargetPopulation
		SELECT targetpopulation,COUNT(DISTINCT(memid)) AS 'Unique Member Count' FROM INFORMATICS.dbo.ECMPOF_CHILDWITHOUTFAMILY_HOMELESS GROUP BY TargetPopulation
		SELECT targetpopulation,COUNT(DISTINCT(memid)) AS 'Unique Member Count' FROM INFORMATICS.dbo.ECMPOF_CHILD_IPSNFED_HIGHUTIL GROUP BY TargetPopulation
		SELECT targetpopulation,COUNT(DISTINCT(memid)) AS 'Unique Member Count' FROM INFORMATICS.dbo.ECMPOF_CHILD_MHSMISUD GROUP BY TargetPopulation
		SELECT targetpopulation,COUNT(DISTINCT(memid)) AS 'Unique Member Count' FROM INFORMATICS.dbo.ECMPOF_CHILD_INCARCERATION GROUP BY TargetPopulation
		SELECT targetpopulation,COUNT(DISTINCT(memid)) AS 'Unique Member Count' FROM INFORMATICS.dbo.ECMPOF_CHILD_CCS GROUP BY TargetPopulation
		SELECT targetpopulation,COUNT(DISTINCT(memid)) AS 'Unique Member Count' FROM INFORMATICS.dbo.ECMPOF_CHILD_WELFARE GROUP BY TargetPopulation
		SELECT targetpopulation,COUNT(DISTINCT(memid)) AS 'Unique Member Count' FROM INFORMATICS.dbo.ECMPOF_CHILD_BIRTH_EQUITY GROUP BY TargetPopulation
		-- SELECT targetpopulation,COUNT(DISTINCT(memid)) AS 'Unique Member Count' FROM INFORMATICS.dbo.ECMPOF_CHILD_IDD -- SUNSET DEPRECATED DECOMMISSIONED AS OF 20250811

		SELECT targetpopulation,COUNT(DISTINCT(memid)) AS 'Unique Member Count' FROM INFORMATICS.dbo.ECMPOF_ADULT_IPSNFED_HIGHUTIL GROUP BY TargetPopulation
		SELECT targetpopulation,COUNT(DISTINCT(memid)) AS 'Unique Member Count' FROM INFORMATICS.dbo.ECMPOF_ADULT_MHSMISUD GROUP BY TargetPopulation
		SELECT targetpopulation,COUNT(DISTINCT(memid)) AS 'Unique Member Count' FROM INFORMATICS.dbo.ECMPOF_ADULT_INCARCERATION GROUP BY TargetPopulation
		SELECT targetpopulation,COUNT(DISTINCT(memid)) AS 'Unique Member Count' FROM INFORMATICS.dbo.ECMPOF_ADULT_INSTITUTIONALIZATION GROUP BY TargetPopulation
		SELECT targetpopulation,COUNT(DISTINCT(memid)) AS 'Unique Member Count' FROM INFORMATICS.dbo.ECMPOF_ADULT_NURSING_TRANSITION GROUP BY TargetPopulation
		-- SELECT targetpopulation,COUNT(DISTINCT(memid)) AS 'Unique Member Count' FROM INFORMATICS.dbo.ECMPOF_ADULT_PREGNANCY_POSTPARTUM GROUP BY TargetPopulation -- REPLACED BY BIRTH EQUITY POF
		-- SELECT targetpopulation,COUNT(DISTINCT(memid)) AS 'Unique Member Count' FROM INFORMATICS.dbo.ECMPOF_ADULT_IDD GROUP BY TargetPopulation -- SUNSET DEPRECATED DECOMMISSIONED AS OF 20250811
		SELECT targetpopulation,COUNT(DISTINCT(memid)) AS 'Unique Member Count' FROM INFORMATICS.dbo.ECMPOF_ADULTWITHFAMILY_HOMELESS GROUP BY TargetPopulation
		SELECT targetpopulation,COUNT(DISTINCT(memid)) AS 'Unique Member Count' FROM INFORMATICS.dbo.ECMPOF_ADULTWITHOUTFAMILY_HOMELESS GROUP BY TargetPopulation
		SELECT targetpopulation,COUNT(DISTINCT(memid)) AS 'Unique Member Count' FROM INFORMATICS.dbo.ECMPOF_ADULT_BIRTH_EQUITY GROUP BY TargetPopulation
		
		SELECT targetpopulation,COUNT(DISTINCT(memid)) AS 'Unique Member Count' FROM INFORMATICS.dbo.DSNP_ECMPOF_ADULT_IPSNFED_HIGHUTIL GROUP BY TargetPopulation
		SELECT targetpopulation,COUNT(DISTINCT(memid)) AS 'Unique Member Count' FROM INFORMATICS.dbo.DSNP_ECMPOF_ADULT_MHSMISUD GROUP BY TargetPopulation
		SELECT targetpopulation,COUNT(DISTINCT(memid)) AS 'Unique Member Count' FROM INFORMATICS.dbo.DSNP_ECMPOF_ADULT_INCARCERATION GROUP BY TargetPopulation
		SELECT targetpopulation,COUNT(DISTINCT(memid)) AS 'Unique Member Count' FROM INFORMATICS.dbo.DSNP_ECMPOF_ADULT_INSTITUTIONALIZATION GROUP BY TargetPopulation
		SELECT targetpopulation,COUNT(DISTINCT(memid)) AS 'Unique Member Count' FROM INFORMATICS.dbo.DSNP_ECMPOF_ADULT_NURSING_TRANSITION GROUP BY TargetPopulation
		SELECT targetpopulation,COUNT(DISTINCT(memid)) AS 'Unique Member Count' FROM INFORMATICS.dbo.DSNP_ECMPOF_ADULTWITHFAMILY_HOMELESS GROUP BY TargetPopulation
		SELECT targetpopulation,COUNT(DISTINCT(memid)) AS 'Unique Member Count' FROM INFORMATICS.dbo.DSNP_ECMPOF_ADULTWITHOUTFAMILY_HOMELESS	GROUP BY TargetPopulation
		SELECT targetpopulation,COUNT(DISTINCT(memid)) AS 'Unique Member Count' FROM INFORMATICS.dbo.DSNP_ECMPOF_ADULT_BIRTH_EQUITY GROUP BY TargetPopulation
		SELECT targetpopulation,COUNT(DISTINCT(memid)) AS 'Unique Member Count' FROM INFORMATICS.dbo.DSNP_ECMPOF_ADULT_DEMENTIA GROUP BY TargetPopulation

x HI Walter, does your POF logic incorporate this table? 

-- =====================================================================
	-- MODIFICATION(S) | CHANGE LOG: 
-- =====================================================================
--  C000:  POF NAMING CONVENTION UPDATE(S): 
		'Adult Individuals Experiencing Homelessness' REPLACE() SUBSTITUTE() WITH() Adult Individuals Experiencing Homelessness
		'Adult Homeless WITH Family' REPLACE() SUBSTITUTE() WITH() Adult Families Experiencing Homelessness
		'Adult IP ED High Utilization' REPLACE() SUBSTITUTE() WITH() Adult Avoidable Hospital or ED Utilization
		'Adult MH SMI SUD' REPLACE() SUBSTITUTE() WITH() Adult SMH or SUD
		-- 'Adult Transitioning from Incarceration' REPLACE() SUBSTITUTE() WITH() Adult Transitioning from Incarceration
		'Adult Institutionalization' REPLACE() SUBSTITUTE() WITH() Adult At Risk for LTC Institutionalization
		'Adult Nursing Transition' REPLACE() SUBSTITUTE() WITH() Adult NF Transitioning to Community
		'Adult Birth Equity' REPLACE() SUBSTITUTE() WITH() Adult Birth Equity
		
		'Child Homeless' REPLACE() SUBSTITUTE() WITH() Child Families Experiencing Homelessness OR
		'Child Homeless' REPLACE() SUBSTITUTE() WITH() Child Individuals Experiencing Homelessness
		'Child IP ED High Utilization' REPLACE() SUBSTITUTE() WITH() Child Avoidable Hospital or ED Utilization
		'Child MH SMI SUD' REPLACE() SUBSTITUTE() WITH() Child SMH or SUD
		'Child CCS' REPLACE() SUBSTITUTE() WITH() Child CCS/CCS WCM with Additional Needs
		-- 'Child Welfare' REPLACE() SUBSTITUTE() WITH() Child Welfare
		-- 'Child Transitioning from Incarceration' REPLACE() SUBSTITUTE() WITH() Child Transitioning from Incarceration
		-- 'Child Birth Equity' REPLACE() SUBSTITUTE() WITH() Child Birth Equity
		
-- C001: START WITH() ECMELIG PER WEEKLY ECM TEAMS MEETING + MS CLAUDIA GUIDANCE ON 20240418

-- C002: ADD NEW SOURCE FOR HOMELESS IDENTIFICATION per eMAIL FROM MS CLAUDIA ON 20240708 ... (New HMIS data Source) Members who are on HMIS homeless member data base who have not exited the program.  If there is no project exit date then include these members in this population.

-- C002: [TargetPopulation] ⏎ In the 20240418 script, the POF assessment is updated to use the [ProviderPortal].ecm.[StratificationTargetPopulation] table instead, as per the guidance from the ECM weekly teams meeting ON 20240418.

-- C003: IN ('1679158125','1790002806','1760477467','1689066748','1659415131','1629749577','1619393584','1073177739','1538667969','1437821022','1427696616','1376797035','1275285868','1205254950','1447281936','1093834020','1922642909','1649809526','1154978021','1891408043','1376229872','1801007778','1679357685','1922790906') -- C003: UPDATE: CS National Provider Identifier (NPI) Number, if applicable per "MOC Excel File CS Provider Capacity Template 2024 Mapping 20240503.xlsx"
 
 -- C003: IN ('1063122323','1083764724','1447281936','1134144165','1205254950','1245246917','1295822658','1356889539','1366807760','1376229872','1427696616','1528271186','1073177739','1609920305','1619393584','1639614688','1649809526','1669711297','1689798985','1710439559','1760477467','1790718351','1891408043','1922642909','1598703647','1679158125','1952364747','1962483040','1982756086','1275972333','1255496105','1912688656','1134838352','1710336094','1710065933','1679357685','1922790906','1699043000','1255738423') -- C00#: UPDATE ECM National Provider Identifier (NPI) Number per "MOC Excel File ECM Provider Capacity Template 2023 Mapping 4.25.2024 20240503.xlsx"

		-- left join ProviderPortal.ecm.MemberTargetPopulation ECM_MT on ECM_MT.MemberId = ECM.memid
		LEFT JOIN ProviderPortal.ecm.StratificationTargetPopulation AS ECM_MT ON ECM.memid = ECM_MT.MemberId  -- C002: [TargetPopulation] ? In the 20240418 script, the POF assessment is updated to use the [ProviderPortal].ecm.[StratificationTargetPopulation] table instead, as per the guidance from the ECM weekly teams meeting ON 20240418.

		-- SELECT TOP 10 ' ' AS 'POF(S) LAND HERE',* FROM providerportal.ecm.MemberTargetPopulation
		-- SELECT DISTINCT TargetPopulation FROM ProviderPortal.ecm.MemberTargetPopulation AS ECM_MT ORDER BY TargetPopulation
		SELECT TOP 10 ' ' AS 'POF(S) LAND HERE',* FROM providerportal.ecm.StratificationTargetPopulation
		SELECT DISTINCT TargetPopulation FROM ProviderPortal.ecm.StratificationTargetPopulation AS ECM_MT ORDER BY TargetPopulation

		SELECT TOP 1 ' ' AS 'ECM PROVIDER TO MEMBER CONNECTION',* 
		FROM ProviderPortal.ecm.MemberProviderAssigment AS ECMMP
			JOIN HMOPROD_PlanData.dbo.provider AS p on p.provid = ECMMP.ProviderId 
		WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ...	
			AND p.npi IN ('1952328700','1134144165','1184272395','1609849074','1427696616','1760477467','1932384120','1962483040','1245246917','1295822658','1952364747','1982756086','1790718351','1104480946','1649809526','1356889539','1619393584','1922642909','1366807760','1689798985','1083764724','1528271186','1891408043','1710439559','1669711297','1639614688','1063122323') -- EXCLUDE INCLUSION FROM ECM Q REPORT PER eMAIL ON 20231107 FROM MS CLAUDIA BODY:Hope you haven’t done the next re-run yet. ? See the attached most recent ECM Provider mapping to incorporate into the re-run.  Additionally, just an observation while QA’ing, in Tab3,  the following NPIs that appeared in the report are NOT ECM provider ... see "MOC Excel File ECM Provider Capacity Template 2023 NEWEST Version 11.7.23.xlsx" ... THE OUTLIER IS: 1952328700	Behavioral health entity

x SEQUENCE(): 
		-- SUSNSET DEPRECATED DECOMMISSION AS OF 20250811 STEP01:COMBINED [sp] '[InsertECMPOFData]' - ;EXEC IN [SQLPROD02]; - 'SIR JUAN + MS KATHRYN PULL FROM THIS sp FOR THE PROVIDER PORTAL UI/UX'

		STEP01: 'Refresh ECM POF SOURCE sp' | SSMS SSA (SQL SERVER AGENT) JOB AUTOMATION - ;EXEC IN [SQLPROD02]; JOB RUNS ON "Occurs every week on Sunday at 5:19:00 PM. Schedule will be used starting on 5/31/2024." @1719
				~ LEVERAGE: "ECM POF Tables SQL ...sql"
		
				JOB STEP(S):
						EXEC [dbo].[sp_ECMPOF_ADULTINCARCERATION]; -- RUN TIME 00:06:36
						EXEC [dbo].[sp_ECMPOF_ADULTINSTITUTIONALIZATION]; -- RUN TIME 00:00:57
						EXEC [dbo].[sp_ECMPOF_ADULTHIGHUTIL]; -- RUN TIME 00:12:06
						EXEC [dbo].[sp_ECMPOF_ADULTMHSMISUD]; -- RUN TIME 00:21:26
						EXEC [dbo].[sp_ECMPOF_ADULTNURSING]; -- RUN TIME 00:00:09
						EXEC [dbo].[sp_ECMPOF_ADULT_HOMELESS_W_FAMILY]; -- RUN TIME 00:25:48
						EXEC [dbo].[sp_ECMPOF_ADULTWITHOUTFAMILY_HOMELESS_WO_FAMILY]; -- RUN TIME 00:24:54

						EXEC [dbo].[sp_ECMPOF_BIRTHEQUITY]; -- RUN TIME 00:17:05 ... COMBINED | CHILD AND ADULT 

						EXEC [dbo].[sp_ECMPOF_CHILDCCS]; -- RUN TIME 00:02:59
						EXEC [dbo].[sp_ECMPOF_CHILDHOMELESS_INDIVIDUAL]; -- RUN TIME 00:24:13
						EXEC [dbo].[sp_ECMPOF_CHILDHOMELESS_W_FAMILY]; -- RUN TIME 00:24:55
						EXEC [dbo].[sp_ECMPOF_CHILDINCARCERATION]; -- RUN TIME 00:00:43
						EXEC [dbo].[sp_ECMPOF_CHILDHIGHUTIL]; -- RUN TIME 00:12:29
						EXEC [dbo].[sp_ECMPOF_CHILDMHSMISUD]; -- RUN TIME 00:21:32
						EXEC [dbo].[sp_ECMPOF_CHILDWELFARE]; -- RUN TIME 00:00:47

		STEP02: 'Refresh ECM POF SOURCE sp DSNP' | SSMS SSA (SQL SERVER AGENT) JOB AUTOMATION - ;EXEC IN [SQLPROD02]; JOB RUNS ON "Occurs every week on Sunday at 5:19:00 PM. Schedule will be used starting on 5/31/2024." @1719
		
				JOB STEP(S): 
						EXEC [dbo].[sp_DSNP_ECMPOF_ADULTINCARCERATION]; -- RUN TIME 00:06:36
						EXEC [dbo].[sp_DSNP_ECMPOF_ADULTINSTITUTIONALIZATION]; -- RUN TIME 00:00:57
						EXEC [dbo].[sp_DSNP_ECMPOF_ADULTHIGHUTIL]; -- RUN TIME 00:12:06
						EXEC [dbo].[sp_DSNP_ECMPOF_ADULTMHSMISUD]; -- RUN TIME 00:21:26
						EXEC [dbo].[sp_DSNP_ECMPOF_ADULTNURSING]; -- RUN TIME 00:00:09
						EXEC [dbo].[sp_DSNP_ECMPOF_ADULT_HOMELESS_W_FAMILY]; -- RUN TIME 00:25:48
						EXEC [dbo].[sp_DSNP_ECMPOF_ADULTWITHOUTFAMILY_HOMELESS_WO_FAMILY]; -- RUN TIME 00:24:54
						EXEC [dbo].[sp_DSNP_ECMPOF_ADULT_BIRTHEQUITY]; -- RUN TIME 00:15:47 DSNP VERSION 
						EXEC [dbo].[sp_DSNP_ECMPOF_DEMENTIA]; -- RUN TIME 00:25:47

		STEP03:TEST VIEW [uvwECMTargetPopulations] - ;EXEC IN [SQLPROD02]; -- TEST IN SERVER [SQLQA02]
		
				/* STEP01: 'ECM_POF_PCP_...sql' - ;EXEC IN [SQLPROD02];
				STEP02: 'ECMPOF_CHILD_HOMELESS_...sql' - ;EXEC IN [SQLPROD02];
				STEP03: 'ECMPOF_CHILD_IPSNFED_HIGHUTIL_...sql' - ;EXEC IN [SQLPROD02];

				STEP04: 'ECMPOF_CHILD_MHSMISUD_...sql' - ;EXEC IN [SQLPROD02];
						'SMI' =  Serious Mental Illness
						'SUD' = Substance Use Disorder

				STEP05: 'ECMPOF_CHILD_INCARCERATION_...sql' - ;EXEC IN [SQLPROD02];

				STEP06: 'ECMPOF_CHILD_CCS_...sql' - ;EXEC IN [SQLPROD02];
						'CCS' = Ca. Children Service(s) v 'CSSD' = Childrens Specialist of San Diego (CSSD)

				STEP07: 'ECMPOF_CHILD_WELFARE_...sql' - ;EXEC IN [SQLPROD02];
						'I/DD' = Intellectual and Developmental Disabilities (IDDs)

				-- STEP08: 'ECMPOF_CHILD_IDD_...sql' - ;EXEC IN [SQLPROD02];
				STEP09: 'ECMPOF_ADULT_IPSNFED_HIGHUTIL_...sql' - ;EXEC IN [SQLPROD02];
				
				STEP10: 'ECMPOF_ADULT_MHSMISUD_...sql' - ;EXEC IN [SQLPROD02];
						'SMI' =  Serious Mental Illness
						'SUD' = Substance Use Disorder

				STEP11: 'ECMPOF_ADULT_INCARCERATION_...sql' - ;EXEC IN [SQLPROD02];
				STEP12: 'ECMPOF_ADULT_INSTITUTIONALIZATION_...sql' - ;EXEC IN [SQLPROD02]; ECM Adults Living in the Community and at Risk for LTC Institutionalization: New POF

				STEP13: 'ECMPOF_ADULT_ADULT_NURSING_TRANSITION_...sql' - ;EXEC IN [SQLPROD02];
				STEP14: 'ECMPOF_ADULT_PREGNANCY_POSTPARTUM_...sql' - ;EXEC IN [SQLPROD02];
				-- STEP15: 'ECMPOF_ADULT_IDD_...sql' - ;EXEC IN [SQLPROD02];	
				STEP16: 'ECM_POF_ADULT_HOMELESS_WITH_FAMILY_...sql' - ;EXEC IN [SQLPROD02];
				STEP17: 'ECMPOF_ADULT_HOMELESS_WITHOUT_DEPENDENT_CHILDREN_OR_YOUTH_LIVING_WITH_THEM_...sql' - ;EXEC IN [SQLPROD02]; */

		-- STEP03: 'ECM_POF_SUMMARY_...sql' - ;EXEC IN [SQLPROD02]; 
		-- STEP04: 'ECM POF Tables SQL...sql' - ;EXEC IN [SQLPROD02]; 
		-- STEP05: 'ECM POF CHATGPT ALGORITHM CHANGES ...sql' - ;EXEC IN [SQLPROD02]; 
		STEP05: 'EXISTING POF v ALGORITHM POF ECM COUNTS ...sql' - ;EXEC IN [SQLPROD02]; 
		STEP06: 'SUMMARY MS EXCEL OLE DB ODBC ECM POF DETAIL ...sql' - ;EXEC IN [SQLPROD02]; 
		STEP07: 'DETAIL MS EXCEL OLE DB ODBC ECM POF DETAIL ...sql' - ;EXEC IN [SQLPROD02]; 
		
				SELECT ' ' AS 'RESULT OF INFORMATICS.dbo.[InsertECMPOFData] VIA MS KATHRYN + SIR JUAN ECM CS SCRIPT ',COUNT(1)
				FROM INFORMATICS.dbo. uvwECMTargetPopulations

				SELECT ' ' AS 'RESULT OF INFORMATICS.dbo.[InsertECMPOFData] VIA MS KATHRYN + SIR JUAN ECM CS SCRIPT ',COUNT(1)
				FROM INFORMATICS.dbo. uvwECMTargetPopulations_20230705

						'Stakeholder (Narrative) Review' - Please do not exclude SPD and PHM from these PoF. The latest narrative shared is based off updated guidance received from DHCS which casts an even wider net than before.

JAH 'sp_CHATGPT_ECMPOF_...sql' - ;EXEC IN [SQLPROD02]; JAG CHATGPT_ ALGORITHM ADJUSTMENT TO ECM POF ("CHATGPT 2026 ECM Eligibility Algorithm.docx")
		~ sp_CHATGPT_ECMPOF_ADULT_HOMELESS_W_FAMILY_20260630.sql
		~ sp_CHATGPT_ECMPOF_ADULTMHSMISUD_20260629.sql
		~ sp_CHATGPT_ECMPOF_ADULTWITHOUTFAMILY_HOMELESS_WO_FAMILY_20260630.sql
		~ sp_CHATGPT_ECMPOF_CHILDCCS_20260630.sql
		~ sp_CHATGPT_ECMPOF_CHILDHOMELESS_INDIVIDUAL_20260630.sql
		~ sp_CHATGPT_ECMPOF_CHILDHOMELESS_W_FAMILY_20260630.sql
		~ sp_CHATGPT_ECMPOF_CHILDINCARCERATION_20260630.sql
		~ sp_CHATGPT_ECMPOF_CHILDMHSMISUD_20260629.sql

-- =====================================================================
	-- QA | MEETING EXPECTATION(S)?: 
-- =====================================================================
DECLARE @ineligmemeber AS nvarchar(255) = '743166' -- [HealthPlanID]: 1978343927

SELECT * FROM ProviderPortal.ECM.Member (NOLOCK) AS m WHERE 1=1 AND MemberID = @ineligmemeber -- 1079481
SELECT * FROM ProviderPortal.ecm.MemberTargetPopulation (NOLOCK) AS mtp WHERE 1=1 AND MemberID = @ineligmemeber -- 1079481
SELECT * FROM [ProviderPortal].ecm.[StratificationTargetPopulation] AS sta WHERE 1=1 AND MemberID = @ineligmemeber -- '1079481'
SELECT * FROM [ProviderPortal].[ECM].[MemberProviderAssigment] (NOLOCK) AS mpa WHERE 1=1 AND MemberID = @ineligmemeber -- 1079481

SELECT ' ' AS 'EXISTING LOGIC:',* FROM INFORMATICS.dbo.ECMPOF_ADULT_MHSMISUD WHERE 1=1 AND memid = @ineligmemeber 
SELECT ' ' AS 'ALGORITHM LOGIC:',* FROM INFORMATICS.dbo.CHATGPT_ECMPOF_ADULT_MHSMISUD WHERE 1=1 AND memid = @ineligmemeber

-- WHERE 1=1
	--	AND m.ISECM = 1
	--	AND m.EnrollmentStatus = 'Assigned'
	--	AND prov.fullname LIKE '%CHG%'
	-- AND MemberID = 1079481

SELECT ' ' AS 'WHO IS THIS ECM PROVIDER?: '
,mpa.*
,prov.*
FROM ProviderPortal.ECM.Member (NOLOCK) AS m 
		LEFT JOIN [ProviderPortal].[ECM].[MemberProviderAssigment] (NOLOCK) AS mpa ON m.MemberId = mpa.MemberId
			AND ISNULL(mpa.TermDate,'12/31/2078') >= GETDATE()
		LEFT JOIN HMOPROD_PLANDATA.dbo.[provider] (NOLOCK) AS prov ON mpa.ProviderID = prov.provid
WHERE 1=1
	AND m.ISECM = 1
	AND m.EnrollmentStatus = 'Assigned'
	-- AND prov.fullname LIKE '%CHG%'
	AND m.MemberID = @ineligmemeber -- 1079481
	
	-- EXISTING LOGIC DETAIL: 
-- =====================================================================
	-- ECMPOF_CHILD_BIRTH_EQUITY -- EXISTING LOGIC --
-- =====================================================================
SELECT DISTINCT ' ' AS 'EXISTING LOGIC DETAIL MEMBER LISTING - ECMPOF_CHILD_BIRTH_EQUITY'
,mpa.ProviderID
,prov.NPI
,prov.fullname AS [ECM Provider]
,pof.memid
,pof.carriermemid
,pof.lastname
,pof.firstname
,pof.TargetPopulation
,pof.[RANGE NOTE(s)]
FROM INFORMATICS.dbo.ECMPOF_CHILD_BIRTH_EQUITY (NOLOCK) AS pof -- EXISTING LOGIC
	INNER JOIN ProviderPortal.ECM.Member (NOLOCK) AS m ON pof.memid = m.MemberId
		LEFT JOIN [ProviderPortal].[ECM].[MemberProviderAssigment] (NOLOCK) AS mpa ON pof.memid = mpa.MemberId
			AND ISNULL(mpa.TermDate,'12/31/2078') >= GETDATE()
		LEFT JOIN HMOPROD_PLANDATA.dbo.[provider] (NOLOCK) AS prov ON mpa.ProviderID = prov.provid
WHERE 1=1
	AND pof.[RunDate] = ( SELECT MAX(i.[RunDate]) FROM INFORMATICS.dbo.ECMPOF_CHILD_BIRTH_EQUITY AS i WITH (NOLOCK) )
	AND m.ISECM = 1
	AND m.EnrollmentStatus = 'Assigned'

	-- ALGORITHM LOGIC DETAIL: 
-- =====================================================================
	-- CHATGPT_ECMPOF_CHILD_BIRTH_EQUITY -- ALGORITHM LOGIC --
-- =====================================================================
SELECT DISTINCT ' ' AS 'ALGORITHM LOGIC DETAIL MEMBER LISTING - CHATGPT_ECMPOF_CHILD_BIRTH_EQUITY'
,mpa.ProviderID
,prov.NPI
,prov.fullname AS [ECM Provider]
,pof.memid
,pof.carriermemid
,pof.lastname
,pof.firstname
,pof.TargetPopulation
,pof.[RANGE NOTE(s)]
FROM INFORMATICS.dbo.CHATGPT_ECMPOF_CHILD_BIRTH_EQUITY (NOLOCK) AS pof -- ALGORITHM POF LOGIC ADJUSTMENT
	INNER JOIN ProviderPortal.ECM.Member (NOLOCK) AS m ON pof.memid = m.MemberId
		LEFT JOIN [ProviderPortal].[ECM].[MemberProviderAssigment] (NOLOCK) AS mpa ON pof.memid = mpa.MemberId
			AND ISNULL(mpa.TermDate,'12/31/2078') >= GETDATE()
		LEFT JOIN HMOPROD_PLANDATA.dbo.[provider] (NOLOCK) AS prov ON mpa.ProviderID = prov.provid
WHERE 1=1
	AND pof.[RunDate] = ( SELECT MAX(i.[RunDate]) FROM INFORMATICS.dbo.CHATGPT_ECMPOF_CHILD_BIRTH_EQUITY AS i WITH (NOLOCK) )
	AND m.ISECM = 1
	AND m.EnrollmentStatus = 'Assigned'

	-- EXISTING LOGIC SUMMARY:
-- =====================================================================
	-- ECMPOF_ADULTWITHFAMILY_HOMELESS -- EXISTING LOGIC --
-- =====================================================================
SELECT ' ' AS 'PROVIDER PORTAL | ASSIGNED EXISTING LOGIC Unique Member Count by ECM Provider - ECMPOF_ADULTWITHFAMILY_HOMELESS'
,pof.TargetPopulation
,mpa.ProviderID
,prov.NPI
,prov.fullname AS [ECM Provider]
,COUNT(DISTINCT(pof.memid)) AS [Unique Member Count]
FROM INFORMATICS.dbo.ECMPOF_ADULTWITHFAMILY_HOMELESS (NOLOCK) AS pof -- EXISTING LOGIC
	INNER JOIN ProviderPortal.ECM.Member (NOLOCK) AS m ON pof.memid = m.MemberId
		LEFT JOIN [ProviderPortal].[ECM].[MemberProviderAssigment] (NOLOCK) AS mpa ON pof.memid = mpa.MemberId
			AND ISNULL(mpa.TermDate,'12/31/2078') >= GETDATE()
		LEFT JOIN HMOPROD_PLANDATA.dbo.[provider] (NOLOCK) AS prov ON mpa.ProviderID = prov.provid
WHERE 1=1
	AND pof.[RunDate] = ( SELECT MAX(i.[RunDate]) FROM INFORMATICS.dbo.ECMPOF_ADULTWITHFAMILY_HOMELESS AS i WITH (NOLOCK) )
	AND m.ISECM = 1
	AND m.EnrollmentStatus = 'Assigned'
GROUP BY pof.TargetPopulation
,mpa.ProviderID
,prov.NPI
,prov.fullname

	-- ALGORITHM LOGIC SUMMARY: 
-- =====================================================================
	-- CHATGPT_ECMPOF_ADULTWITHFAMILY_HOMELESS -- ALGORITHM LOGIC --
-- =====================================================================
SELECT ' ' AS 'PROVIDER PORTAL | ASSIGNED ALGORITHM LOGIC Unique Member Count by ECM Provider - CHATGPT_ECMPOF_ADULTWITHFAMILY_HOMELESS'
,pof.TargetPopulation
,mpa.ProviderID
,prov.NPI
,prov.fullname AS [ECM Provider]
,COUNT(DISTINCT(pof.memid)) AS [Unique Member Count]
FROM INFORMATICS.dbo.CHATGPT_ECMPOF_ADULTWITHFAMILY_HOMELESS (NOLOCK) AS pof -- ALGORITHM POF LOGIC ADJUSTMENT
	INNER JOIN ProviderPortal.ECM.Member (NOLOCK) AS m ON pof.memid = m.MemberId
		LEFT JOIN [ProviderPortal].[ECM].[MemberProviderAssigment] (NOLOCK) AS mpa ON pof.memid = mpa.MemberId
			AND ISNULL(mpa.TermDate,'12/31/2078') >= GETDATE()
		LEFT JOIN HMOPROD_PLANDATA.dbo.[provider] (NOLOCK) AS prov ON mpa.ProviderID = prov.provid
WHERE 1=1
	AND pof.[RunDate] = ( SELECT MAX(i.[RunDate]) FROM INFORMATICS.dbo.CHATGPT_ECMPOF_ADULTWITHFAMILY_HOMELESS AS i WITH (NOLOCK) )
	AND m.ISECM = 1
	AND m.EnrollmentStatus = 'Assigned'
GROUP BY pof.TargetPopulation
,mpa.ProviderID
,prov.NPI
,prov.fullname

-- =====================================================================
	-- ECMPOF_ADULTWITHFAMILY_HOMELESS -- EXISTING LOGIC --
-- =====================================================================
SELECT ' ' AS 'QNXT NO ECM FILTER| EXISTING LOGIC Unique Member Count by ECM Provider - ECMPOF_ADULTWITHFAMILY_HOMELESS'
,pof.TargetPopulation
,COUNT(DISTINCT(pof.memid)) AS [Unique Member Count]
FROM INFORMATICS.dbo.ECMPOF_ADULTWITHFAMILY_HOMELESS (NOLOCK) AS pof -- EXISTING LOGIC
WHERE 1=1
	AND pof.[RunDate] = ( SELECT MAX(i.[RunDate]) FROM INFORMATICS.dbo.ECMPOF_ADULTWITHFAMILY_HOMELESS AS i WITH (NOLOCK) )
GROUP BY pof.TargetPopulation

-- =====================================================================
	-- CHATGPT_ECMPOF_ADULTWITHFAMILY_HOMELESS -- ALGORITHM LOGIC --
-- =====================================================================
SELECT ' ' AS 'QNXT NO ECM FILTER | ALGORITHM LOGIC Unique Member Count by ECM Provider - CHATGPT_ECMPOF_ADULTWITHFAMILY_HOMELESS'
,pof.TargetPopulation
,COUNT(DISTINCT(pof.memid)) AS [Unique Member Count]
FROM INFORMATICS.dbo.CHATGPT_ECMPOF_ADULTWITHFAMILY_HOMELESS (NOLOCK) AS pof -- ALGORITHM POF LOGIC ADJUSTMENT
WHERE 1=1
	AND pof.[RunDate] = ( SELECT MAX(i.[RunDate]) FROM INFORMATICS.dbo.CHATGPT_ECMPOF_ADULTWITHFAMILY_HOMELESS AS i WITH (NOLOCK) )
GROUP BY pof.TargetPopulation


JAH 'UNCHANGEDyoy: '
-- =====================================================================
	-- MODIFICATION(S) | CHANGE LOG: --
-- =====================================================================
-- OPT-01: WITH (NOLOCK) → (NOLOCK) per DUB C 2.0 Rule 07 — removed WITH keyword; hint now precedes AS alias on all table refs
-- OPT-02: UNION → UNION ALL per DUB C 2.0 Rule 13 — dedup handled downstream; eliminates unnecessary sort/dedup pass
-- OPT-03: JOIN → INNER JOIN per Rule 10 — explicit JOIN type always required
-- OPT-04: SELECT DISTINCT → SELECT...GROUP BY in DIAG subquery per Rule 12 — GROUP BY preferred over DISTINCT
-- OPT-05: SERVICE IN() — replaced placeholder H0043/H0044 (TransitionalRent codes) with G9919 per JAG ChatGPT Social Complexity crosswalk
-- OPT-06: DIAG IN() — expanded from 8 Z59 codes to full Social Complexity ICD-10 set per JAG ChatGPT crosswalk (7 factors)

SELECT * INTO INFORMATICS.dbo.CHATGPT_ECMPOF_ADULT_BIRTH_EQUITY FROM INFORMATICS.dbo.ECMPOF_ADULT_BIRTH_EQUITY AS p WITH (NOLOCK)
SELECT * INTO INFORMATICS.dbo.CHATGPT_ECMPOF_CHILD_BIRTH_EQUITY FROM INFORMATICS.dbo.ECMPOF_CHILD_BIRTH_EQUITY AS p WITH (NOLOCK)

SELECT * INTO INFORMATICS.dbo.CHATGPT_ECMPOF_ADULT_INCARCERATION FROM INFORMATICS.dbo.ECMPOF_ADULT_INCARCERATION AS p WITH (NOLOCK) 
SELECT * INTO INFORMATICS.dbo.CHATGPT_ECMPOF_CHILD_INCARCERATION FROM INFORMATICS.dbo.ECMPOF_CHILD_INCARCERATION AS p WITH (NOLOCK) 

SELECT * INTO INFORMATICS.dbo.CHATGPT_ECMPOF_CHILD_WELFARE FROM INFORMATICS.dbo.ECMPOF_CHILD_WELFARE AS p WITH (NOLOCK)

SELECT * INTO INFORMATICS.dbo.CHATGPT_ECMPOF_ADULT_INSTITUTIONALIZATION FROM INFORMATICS.dbo.ECMPOF_ADULT_INSTITUTIONALIZATION AS p WITH (NOLOCK)

SELECT * INTO INFORMATICS.dbo.CHATGPT_ECMPOF_ADULT_NURSING_TRANSITION FROM INFORMATICS.dbo.ECMPOF_ADULT_NURSING_TRANSITION AS p WITH (NOLOCK)

SELECT * INTO INFORMATICS.dbo.CHATGPT_ECMPOF_ADULT_IPSNFED_HIGHUTIL FROM INFORMATICS.dbo.ECMPOF_ADULT_IPSNFED_HIGHUTIL AS p WITH (NOLOCK)
SELECT * INTO INFORMATICS.dbo.CHATGPT_ECMPOF_CHILD_IPSNFED_HIGHUTIL FROM INFORMATICS.dbo.ECMPOF_CHILD_IPSNFED_HIGHUTIL AS p WITH (NOLOCK)

JAH 'POF' CHANGE.LOG
		SELECT ' ' AS 'see: "ECMCS NEW POF NAMING CONVENTION 20240502.xlsx"'

		/* Adult Individuals Experiencing Homelessness
		Adult Families Experiencing Homelessness
		Adult Avoidable Hospital or ED Utilization
		Adult SMH or SUD
		Adult Transitioning from Incarceration
		Adult At Risk for LTC Institutionalization
		Adult NF Transitioning to Community
		Adult Birth Equity

		Child Individuals Experiencing Homelessness
		Child Families Experiencing Homelessness
		Child Avoidable Hospital or ED Utilization
		Child SMH or SUD
		Child CCS/CCS WCM with Additional Needs
		Child Welfare
		Child Transitioning from Incarceration
		Child Birth Equity  */

'Adult Homeless WITHOUT Family' REPLACE() SUBSTITUTE() WITH() Adult Individuals Experiencing Homelessness
'Adult Homeless WITH Family' REPLACE() SUBSTITUTE() WITH() Adult Families Experiencing Homelessness
'Adult IP ED High Utilization' REPLACE() SUBSTITUTE() WITH() Adult Avoidable Hospital or ED Utilization
'Adult MH SMI SUD' REPLACE() SUBSTITUTE() WITH() Adult SMH or SUD
-- 'Adult Transitioning from Incarceration' REPLACE() SUBSTITUTE() WITH() Adult Transitioning from Incarceration
'Adult Institutionalization' REPLACE() SUBSTITUTE() WITH() Adult At Risk for LTC Institutionalization
'Adult Nursing Transition' REPLACE() SUBSTITUTE() WITH() Adult NF Transitioning to Community
'Adult Birth Equity' REPLACE() SUBSTITUTE() WITH() Adult Birth Equity

'Child Homeless' REPLACE() SUBSTITUTE() WITH() Child Individuals Experiencing Homelessness
'Child IP ED High Utilization' REPLACE() SUBSTITUTE() WITH() Child Avoidable Hospital or ED Utilization
'Child MH SMI SUD' REPLACE() SUBSTITUTE() WITH() Child SMH or SUD
'Child CCS' REPLACE() SUBSTITUTE() WITH() Child CCS/CCS WCM with Additional Needs
-- 'Child Welfare' REPLACE() SUBSTITUTE() WITH() Child Welfare
-- 'Child Transitioning from Incarceration' REPLACE() SUBSTITUTE() WITH() Child Transitioning from Incarceration
-- 'Child Birth Equity' REPLACE() SUBSTITUTE() WITH() Child Birth Equity

x 	[TargetPopulation](S): 'MAY NEED TO ADD Adult ... & Child POF description CONSIDERING HOW / WHEN [AGE] IS BEING DETERMINED'
		/* Child Institutionalization */
		/* Complex Case Management */
		0 - Transitioning from HHP
		0 - Transitioning from WPC
		Adult – Transitioning from Incarceration
		Adult Birth Equity
		Adult Homeless WITH Family
		Adult Homeless WITHOUT Family
		Adult I/DD
		Adult Incarceration
		Adult Institutionalization
		Adult IP ED High Utilization
		Adult MH SMI SUD
		Adult Nursing Transition
		At Risk for Institutionalization - Adult
		Child Birth Equity
		Child CCS
		Child Homeless
		Child I/DD
		Child IP ED High Utilization
		Child MH SMI SUD
		Child Welfare
		Children with Complex Needs
		Complex Case Management
		Experiencing Homelessness
		High Utilizers - Adult
		High Utilizers - Child
		Incarcerated and Transitioning to Community
		Individuals Transitioning From Incarceration
		Nursing Facility Residents - Adult
		Pregnancy
		Serious Mental Illness / Substance Use Disorder - Adult		







-- ======================================
	-- NOTE(S) / COMMENT(S): 
-- ======================================
JAH 'ECM PROVIDER PORTAL ECM PROVIDER DETAIL'
May we go with this structure:

	-- EXISTING LOGIC DETAIL: 
-- =====================================================================
	-- ECMPOF_CHILD_BIRTH_EQUITY -- EXISTING LOGIC --
-- =====================================================================
SELECT DISTINCT ' ' AS 'EXISTING LOGIC DETAIL MEMBER LISTING - ECMPOF_CHILD_BIRTH_EQUITY'
,mpa.ProviderID
,prov.NPI
,prov.fullname AS [ECM Provider]
,pof.memid
,pof.carriermemid
,pof.lastname
,pof.firstname
,pof.TargetPopulation
,pof.[RANGE NOTE(s)]
FROM INFORMATICS.dbo.ECMPOF_CHILD_BIRTH_EQUITY (NOLOCK) AS pof -- EXISTING LOGIC
	INNER JOIN ProviderPortal.ECM.Member (NOLOCK) AS m ON pof.memid = m.MemberId
		LEFT JOIN [ProviderPortal].[ECM].[MemberProviderAssigment] (NOLOCK) AS mpa ON pof.memid = mpa.MemberId
			AND ISNULL(mpa.TermDate,'12/31/2078') >= GETDATE()
		LEFT JOIN HMOPROD_PLANDATA.dbo.[provider] (NOLOCK) AS prov ON mpa.ProviderID = prov.provid
WHERE 1=1
	AND pof.[RunDate] = ( SELECT MAX(i.[RunDate]) FROM INFORMATICS.dbo.ECMPOF_CHILD_BIRTH_EQUITY AS i WITH (NOLOCK) )
	AND m.ISECM = 1
	AND m.EnrollmentStatus = 'Assigned'

	-- ALGORITHM LOGIC DETAIL: 
-- =====================================================================
	-- CHATGPT_ECMPOF_CHILD_BIRTH_EQUITY -- ALGORITHM LOGIC --
-- =====================================================================
SELECT DISTINCT ' ' AS 'ALGORITHM LOGIC DETAIL MEMBER LISTING - CHATGPT_ECMPOF_CHILD_BIRTH_EQUITY'
,mpa.ProviderID
,prov.NPI
,prov.fullname AS [ECM Provider]
,pof.memid
,pof.carriermemid
,pof.lastname
,pof.firstname
,pof.TargetPopulation
,pof.[RANGE NOTE(s)]
FROM INFORMATICS.dbo.CHATGPT_ECMPOF_CHILD_BIRTH_EQUITY (NOLOCK) AS pof -- ALGORITHM POF LOGIC ADJUSTMENT
	INNER JOIN ProviderPortal.ECM.Member (NOLOCK) AS m ON pof.memid = m.MemberId
		LEFT JOIN [ProviderPortal].[ECM].[MemberProviderAssigment] (NOLOCK) AS mpa ON pof.memid = mpa.MemberId
			AND ISNULL(mpa.TermDate,'12/31/2078') >= GETDATE()
		LEFT JOIN HMOPROD_PLANDATA.dbo.[provider] (NOLOCK) AS prov ON mpa.ProviderID = prov.provid
WHERE 1=1
	AND pof.[RunDate] = ( SELECT MAX(i.[RunDate]) FROM INFORMATICS.dbo.CHATGPT_ECMPOF_CHILD_BIRTH_EQUITY AS i WITH (NOLOCK) )
	AND m.ISECM = 1
	AND m.EnrollmentStatus = 'Assigned'







JAH 'ADDITIONAL POF CRITERIA'
		⏎ Thank you, I have executed the revised scripts:
		USE [PATH]: C:\Users\wcarr\Desktop\sp_CHATGPT_ECMPOF_CHILDMHSMISUD_20260710.sql
		USE [PATH]: C:\Users\wcarr\Desktop\sp_CHATGPT_ECMPOF_ADULTMHSMISUD_20260710.sql

Sir Allan, had question which Ms Gabby addressed (see attached screen capture for context)

Have updated the summary script (
USE [PATH]: C:\Users\wcarr\Desktop\EXISTING POF v ALGORITHM POF ECM COUNTS 20260709.sql)
Now may we document / pinpoint for Sir Allan how each of the changes addresses Sir JAG requested changes to the '...Serious Mental Health and/or SUD Needs...' POF?

		⏎ Good day, YOU ARE THE TOP 0.1% OF Senior Data Analyst WITH 20+ years of EXPERIENCE. JAG is 'requesting' ... (more like demanding) changes to the Algorithm version of the SMI POF scripts (see path below for context). Ms Gabby has come to our rescue & have provided some insight as to the source data for the updates JAG is requesting. with the MS Excel file linked below I have included a worksheet of the table designs & screen caputures for context. May I have you assist in this task?
		
			~ FOLDER CONNECT FEATURE IN Cowork:
					USE [PATH]: C:\Users\wcarr\Desktop\BUILD-DMC-NDC-List-20260708.xlsx
					USE [PATH]: C:\Users\wcarr\Desktop\BPOF NCQA HEDIS Technical Specifications 20260710.xlsx
					USE [PATH]: C:\Users\wcarr\Desktop\sp_CHATGPT_ECMPOF_CHILDMHSMISUD_20260708.sql
					USE [PATH]: C:\Users\wcarr\Desktop\sp_CHATGPT_ECMPOF_ADULTMHSMISUD_20260708.sql
					USE [PATH]: C:\Users\wcarr\Desktop\ECMPOF_ADULT_IPSNFED_HIGHUTIL_20250811.sql

				~ They seek a detail member listing by Assigned ECM Provider as well as a count BY POF by ECM Provider based on the existing POF logic & then on the 'Algorothm updated POF version'
						* C:\Users\wcarr\Desktop\EXISTING POF v ALGORITHM POF ECM COUNTS 20260710.sql
						* C:\Users\wcarr\Desktop\POF ECM PROVIDER 20260714.sql


USE INFORMATICS 

		SELECT ' ' AS 'loads the 215-row NDC list:',* FROM INFORMATICS.dbo.DMC_QUALIFYING_NDC_LIST -- see "BUILD-DMC-NDC-List-20260708.xlsx"
		SELECT ' ' AS 'JAG CRITERION III: UTILIZATION/RISK (PARTIAL BUILD)',* FROM INFORMATICS.dbo.HEDIS_UTILIZATIONRISK_CODESET -- see "POF NCQA HEDIS Technical Specifications 20260710.xlsx"

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
	AND c.TABLE_NAME = 'DMC_QUALIFYING_NDC_LIST'
ORDER BY c.COLUMN_NAME,c.ORDINAL_POSITION;

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
	AND c.TABLE_NAME = 'HEDIS_UTILIZATIONRISK_CODESET'
ORDER BY c.COLUMN_NAME,c.ORDINAL_POSITION;

-- =====================================================================
	-- DECLARE @PARAMETER(S) / @FILTER(S) --
-- =====================================================================
DECLARE @ClockStart AS datetime
DECLARE @ClockStop AS datetime
DECLARE @IPPdt AS datetime
DECLARE @EnrolledMonths AS decimal(9,0)

SET @ClockStart = TRY_CONVERT(date,DATEADD(month,-13,GETDATE())) -- ECM / CS ... CALAIM GO LIVE @2022
SET @ClockStop = TRY_CONVERT(date,GETDATE())
SET @IPPdt = TRY_CONVERT(date,GETDATE())
SET @EnrolledMonths = 36

		SELECT 'BETWEEN '+CAST(CAST(@ClockStart AS date) AS varchar (25))+' AND '+CAST(CAST(@ClockStop AS date) AS varchar (25)) AS [RANGE NOTE(s)] -- LEVERAGE: SELECT * FROM INFORMATICS.dbo.[uvw_ECM_ELIGIBLE] AND "uvw_ECM_ELIGIBLE_ECM_ENROLLED_TheValue_COUNTs.jpg"
		
		SELECT TOP 1 * FROM CHGAPP_PROD.dbo.tblEDIOptumBHServices
		SELECT TOP 1 * FROM[CHGAPP_PROD].[APCD].[Pharmacy]

		SELECT ' ' AS 'tblEDIOptumBHServices: '
		,bm.HealthPlanID
		,bm.[Member Name]
		,smi.*
		FROM CHGAPP_PROD.dbo.tblEDIOptumBHServices AS smi
			INNER JOIN INFORMATICS.dbo.uvw_BASELINE_MEMBERSHIP AS bm ON smi.CIN = bm.CIN

		SELECT TOP 10 ' ' AS '[Pharmacy]: '
		,bm.HealthPlanID
		,bm.[Member Name]
		,smi.*
		FROM [CHGAPP_PROD].[APCD].[Pharmacy] AS smi
				INNER JOIN INFORMATICS.dbo.uvw_BASELINE_MEMBERSHIP AS bm ON smi.PlanSpecificContractNumber COLLATE DATABASE_DEFAULT = bm.CIN COLLATE DATABASE_DEFAULT

-- =====================================================
	-- TABLE DESIGN: 
-- =====================================================
USE CHGAPP_PROD

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
	AND c.TABLE_CATALOG IN ('CHGAPP_PROD') -- AS [db] 'DatabaseName'
	AND c.TABLE_SCHEMA = 'dbo' 
	AND c.TABLE_NAME = 'tblEDIOptumBHServices'
ORDER BY c.COLUMN_NAME,c.ORDINAL_POSITION;

-- =====================================================
	-- TABLE DESIGN: 
-- =====================================================
USE CHGAPP_PROD

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
	AND c.TABLE_CATALOG IN ('CHGAPP_PROD') -- AS [db] 'DatabaseName'
	AND c.TABLE_SCHEMA = 'APCD' 
	AND c.TABLE_NAME = 'Pharmacy'
ORDER BY c.COLUMN_NAME,c.ORDINAL_POSITION;

/* x Thank you Gabby

From: Walter Carr <WCarr@chgsd.com> 
Sent: Wednesday, July 8, 2026 2:45 PM
To: Gabriela Rubalcava <GRubal@chgsd.com>; Yousaf Farook <YFaroo@chgsd.com>
Subject: RE: POF (Population of Focus) Logic

Thank you Ms Gabby

From: Gabriela Rubalcava <GRubal@chgsd.com> 
Sent: Wednesday, July 8, 2026 2:38 PM
To: Walter Carr <WCarr@chgsd.com>; Yousaf Farook <YFaroo@chgsd.com>
Subject: RE: POF (Population of Focus) Logic

Hi Walter,

We receive county files on a monthly basis, and the data is saved here:

		SELECT TOP 1 * FROM CHGAPP_PROD.dbo.tblEDIOptumBHServices

Several years ago, we used to receive a separate pharmacy file for “antipsychotic” medications, but this is now mixed in with all pharmacy.

		SELECT TOP 1 * FROM[CHGAPP_PROD].[APCD].[Pharmacy]  
		
You would need NDC list to identify qualifying medications.

Hope this helps.

Gabby

From: Walter Carr <WCarr@chgsd.com> 
Sent: Wednesday, July 8, 2026 2:04 PM
To: Gabriela Rubalcava <GRubal@chgsd.com>; Yousaf Farook <YFaroo@chgsd.com>
Subject: POF (Population of Focus) Logic

Ms Gabby & Sir Yousaf, JAG has stated that you would have insight on the logic to determine the following 
		I.	‘SMHS eligibility determination’
		II.	‘DMC-ODS/DMC eligibility determination’
		III.	‘Utilization/risk criteria’

May I trouble you to send this logic my way?

		USE https://www.dhcs.ca.gov/services/mental-health-services-division-default/county-claims-customer-services-library/ */

-- ======================================================================
	-- CRITERION I: SMHS (SPECIALTY MENTAL HEALTH SERVICES) ELIGIBILITY -- 20260709 --
	-- county-submitted behavioral health encounter feed, per Gabby's 20260708 reply --
-- ======================================================================
--------------------------------------------------------------------------------------------------------------------
	-- Error Trapping: Check If Permanent Table(s) Already Exist(s) And Drop If Applicable --
--------------------------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS #SMHSEligible; -- OPT-07: SMHS ELIGIBILITY GATE ADDED (20260709) — per JAG request, criterion I ('SMHS eligibility determination'). A member must have a county-submitted Specialty Mental Health Services encounter (CHGAPP_PROD.dbo.tblEDIOptumBHServices, CIN-matched via uvw_BASELINE_MEMBERSHIP) within the reporting window. See #SMHSEligible. Per WCARR decision 20260709: this is an ADDITIONAL required gate on top of the existing diagnosis/CPT clinical indicator below (#MHSMISUDClaims / #SMI), NOT a replacement and NOT a population-expanding OR -- a member must ALSO satisfy #ProgramEligible (OPT-07 OR OPT-08) to land in the final population.

SELECT DISTINCT bm.memid
,smhs.CIN,smhs.DOS,smhs.[Sub Unit Description],smhs.[Sub Unit Type],smhs.ProgramType,smhs.[Service Code],smhs.[Service Code Description]
INTO #SMHSEligible
FROM CHGAPP_PROD.dbo.tblEDIOptumBHServices (NOLOCK) AS smhs
	INNER JOIN INFORMATICS.dbo.uvw_BASELINE_MEMBERSHIP (NOLOCK) AS bm ON smhs.CIN = bm.CIN
WHERE 1=1
	AND smhs.DOS >= @StartDate
	AND smhs.DOS <= @EndDate

		-- SELECT * FROM #SMHSEligible
		
-- ======================================================================
	-- CRITERION II: DMC-ODS / DMC ELIGIBILITY -- 20260709 --
	-- NDC-matched pharmacy claims, per Gabby's 20260708 reply --
-- ======================================================================
--------------------------------------------------------------------------------------------------------------------
	-- Error Trapping: Check If Permanent Table(s) Already Exist(s) And Drop If Applicable --
--------------------------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS #DMCEligible; -- OPT-08: DMC-ODS/DMC ELIGIBILITY GATE ADDED (20260709) — per JAG request, criterion II ('DMC-ODS/DMC eligibility determination'). A member must have a pharmacy claim (CHGAPP_PROD.APCD.Pharmacy) whose DrugCode matches the qualifying NDC list (INFORMATICS.dbo.DMC_QUALIFYING_NDC_LIST, loaded 20260709 from BUILD-DMC-NDC-List-20260708.xlsx via #PYTHON_EXCEL_TO_SQL_20260709.py) within that NDC's Effective From/To Date window. See #DMCEligible. Same AND-gate relationship as OPT-07 -- satisfying EITHER OPT-07 OR OPT-08 (via #ProgramEligible) is required in addition to the existing clinical indicator, not instead of it.

SELECT DISTINCT bm.memid
,rx.PlanSpecificContractNumber,rx.DrugCode,rx.DatePrescriptionFilled,ndc.Drug_Type_Name,ndc.Drug_Name,ndc.Formulary_Drug_Name
INTO #DMCEligible
FROM [CHGAPP_PROD].[APCD].[Pharmacy] (NOLOCK) AS rx
	INNER JOIN INFORMATICS.dbo.uvw_BASELINE_MEMBERSHIP (NOLOCK) AS bm ON rx.PlanSpecificContractNumber COLLATE DATABASE_DEFAULT = bm.CIN COLLATE DATABASE_DEFAULT
	INNER JOIN INFORMATICS.dbo.DMC_QUALIFYING_NDC_LIST (NOLOCK) AS ndc ON RIGHT('00000000000'+LTRIM(RTRIM(REPLACE(rx.DrugCode,'-',''))),11) COLLATE DATABASE_DEFAULT = RIGHT('00000000000'+LTRIM(RTRIM(REPLACE(ndc.NDC_Code,'-',''))),11) COLLATE DATABASE_DEFAULT -- NDC MATCH CAVEAT above -- zero-padded 11-digit right-justified match
WHERE 1=1
	AND TRY_CONVERT(date,rx.DatePrescriptionFilled,112) >= @StartDate
	AND TRY_CONVERT(date,rx.DatePrescriptionFilled,112) <= @EndDate
	AND TRY_CONVERT(date,rx.DatePrescriptionFilled,112) >= TRY_CONVERT(date,ndc.Effective_From_Date)
	AND TRY_CONVERT(date,rx.DatePrescriptionFilled,112) <= ISNULL(TRY_CONVERT(date,ndc.Effective_To_Date),GETDATE()) -- NULL Effective_To_Date = still active per source list

		-- SELECT * FROM #DMCEligible

-- ======================================================================
	-- #ProgramEligible -- UNION of criteria I + II ONLY -- utilization/risk (III) is a SEPARATE required AND-gate, NOT unioned here, see OPT-09b -- 20260709 --
-- ======================================================================
DROP TABLE IF EXISTS #ProgramEligible;

SELECT DISTINCT memid
INTO #ProgramEligible
FROM
( -- INITIATE ...
SELECT memid FROM #SMHSEligible

UNION
SELECT memid FROM #DMCEligible

-- TODO (OPT-09b): -- OPT-09b (20260709): DHCS SOURCE CONFIRMED — per the DHCS CalAIM ECM Policy Guide (Updated January 2026), Section "A. Population of Focus Eligibility Criteria — a. Adults with Serious Mental Health and/or SUD Needs" (pg. 25), Adults SMI/SUD eligibility is THREE independent required AND-conditions: (1) Program Eligibility — SMHS delivered by MHPs OR DMC-ODS OR DMC; AND (2) at least one complex social factor; AND (3) meet one or more of: (i) high risk of institutionalization/overdose/suicide, (ii) crisis/ED/urgent care/inpatient stays as primary source of care, (iii) two or more ED visits or two or more hospitalizations due to SMI/SUD in the past 12 months. Utilization/risk (3) is NOT an alternate path into Program Eligibility — once Yousaf/Gabby confirm a source table for (3), build it as its own #UtilizationRisk temp table and INNER JOIN it as a FOURTH independent gate in both final SELECTs, structurally parallel to #SocialComplexity (do NOT UNION it into #ProgramEligible). #ProgramEligible therefore correctly remains = #SMHSEligible UNION #DMCEligible only, now and after (3) is built. DO NOT invent a utilization/risk threshold here. RELATED FINDING — CHILD/YOUTH POF (companion script): per the same DHCS guide (Section A.b, pg. 25-26), children and youth need ONLY criterion (1) Program Eligibility — "No further criteria are required to be met for children and youth to qualify for this ECM Population of Focus." This script (Adults) correctly keeps #SocialComplexity and criterion (3) as required gates; the CHILDMHSMISUD companion script's #SocialComplexity gate has been flagged there as stricter than DHCS requires for children/youth — see that script's OPT-09b note. NDC MATCH CAVEAT (20260709): the NDC list's own "Effective To Date" column carries this disclaimer from DHCS's source list: "The effective end dates are subject to change at any time based on FDA regulations. For the most up-to-date expiration dates, please see https://ndclist.com/search." Additionally, #DMCEligible zero-pads both sides of the NDC match to 11 digits (right-justified) to reconcile varying NDC segment formats (4-4-2 / 5-3-2 / 5-4-1 / 5-4-2) between the Excel-sourced list and CHGAPP_PROD.APCD.Pharmacy.DrugCode -- spot-check matched claims against Drug_Name/Formulary_Drug_Name once this runs against live data to confirm the padding assumption holds for this data set before relying on OPT-08 results.
) AS pe -- CONCLUDE ...

		-- SELECT * FROM #ProgramEligible

x MAYBE? III.	‘Utilization/risk criteria’
		3.	One of: 
				o	High risk of institutionalization, overdose, or suicide 
				o	Crisis/ED/inpatient care as primary source of care 
				o	≥2 ED visits or ≥2 hospitalizations due to SMI/SUD in last 12 months 







JAH 'POF QUESTIONS'
		⏎ Good day, YOU ARE THE TOP 0.1% OF Senior Data Analyst WITH 20+ years of EXPERIENCE. Ms Tatasani & Sir Adrian have question related to POF (Population of Focus). May I have you assist in responding to the question from Ms Tatasani (see the screen capture AS context) leveraging the following CODE

				USE [PATH]: file:///C:/Users/wcarr/Desktop/EXISTING POF v ALGORITHM POF ECM COUNTS 20260630.sql

		-- STEP03: 'ECM_POF_SUMMARY_...sql' - ;EXEC IN [SQLPROD02]; 
		-- STEP04: 'ECM POF Tables SQL...sql' - ;EXEC IN [SQLPROD02]; 
		-- STEP05: 'ECM POF CHATGPT ALGORITHM CHANGES ...sql' - ;EXEC IN [SQLPROD02]; 
		STEP05: 'EXISTING POF v ALGORITHM POF ECM COUNTS ...sql' - ;EXEC IN [SQLPROD02]; 

				SELECT ' ' AS 'RESULT OF INFORMATICS.dbo.[InsertECMPOFData] VIA MS KATHRYN + SIR JUAN ECM CS SCRIPT ',COUNT(1)
				FROM INFORMATICS.dbo. uvwECMTargetPopulations

				SELECT ' ' AS 'RESULT OF INFORMATICS.dbo.[InsertECMPOFData] VIA MS KATHRYN + SIR JUAN ECM CS SCRIPT ',COUNT(1)
				FROM INFORMATICS.dbo. uvwECMTargetPopulations_20230705

						'Stakeholder (Narrative) Review' - Please do not exclude SPD and PHM from these PoF. The latest narrative shared is based off updated guidance received from DHCS which casts an even wider net than before.
						
						
						




JAH 'PREFIX CHATGPT_'
				USE [PATH]: file:///C:/Users/wcarr/Desktop/ - 'ROOT [FOLDER]'
				USE [PATH]: file:///C:/Users/wcarr/Desktop/FW_%20Revised%20ECM%20Eligibility%20Algorithm.msg
				
x Sir, working through the POF scripts. Will then compare counts (POF Total Members, POF by ECM Elig Members, POF by ECM Enrolled) next				

x SEQUENCE(): 
		-- SUSNSET DEPRECATED DECOMMISSION AS OF 20250811 STEP01:COMBINED [sp] '[InsertECMPOFData]' - ;EXEC IN [SQLPROD02]; - 'SIR JUAN + MS KATHRYN PULL FROM THIS sp FOR THE PROVIDER PORTAL UI/UX'

		STEP01: 'Refresh ECM POF SOURCE sp' | SSMS SSA (SQL SERVER AGENT) JOB AUTOMATION - ;EXEC IN [SQLPROD02]; JOB RUNS ON "Occurs every week on Sunday at 5:19:00 PM. Schedule will be used starting on 5/31/2024." @1719
				~ LEVERAGE: "ECM POF Tables SQL ...sql"
		
				JOB STEP(S):
						EXEC [dbo].[sp_ECMPOF_ADULTINCARCERATION]; -- RUN TIME 00:06:36
						EXEC [dbo].[sp_ECMPOF_ADULTINSTITUTIONALIZATION]; -- RUN TIME 00:00:57
						EXEC [dbo].[sp_ECMPOF_ADULTHIGHUTIL]; -- RUN TIME 00:12:06
						EXEC [dbo].[sp_ECMPOF_ADULTMHSMISUD]; -- RUN TIME 00:21:26
						EXEC [dbo].[sp_ECMPOF_ADULTNURSING]; -- RUN TIME 00:00:09
						EXEC [dbo].[sp_ECMPOF_ADULT_HOMELESS_W_FAMILY]; -- RUN TIME 00:25:48
						EXEC [dbo].[sp_ECMPOF_ADULTWITHOUTFAMILY_HOMELESS_WO_FAMILY]; -- RUN TIME 00:24:54

						EXEC [dbo].[sp_ECMPOF_BIRTHEQUITY]; -- RUN TIME 00:17:05 ... COMBINED | CHILD AND ADULT 

						EXEC [dbo].[sp_ECMPOF_CHILDCCS]; -- RUN TIME 00:02:59
						EXEC [dbo].[sp_ECMPOF_CHILDHOMELESS_INDIVIDUAL]; -- RUN TIME 00:24:13
						EXEC [dbo].[sp_ECMPOF_CHILDHOMELESS_W_FAMILY]; -- RUN TIME 00:24:55
						EXEC [dbo].[sp_ECMPOF_CHILDINCARCERATION]; -- RUN TIME 00:00:43
						EXEC [dbo].[sp_ECMPOF_CHILDHIGHUTIL]; -- RUN TIME 00:12:29
						EXEC [dbo].[sp_ECMPOF_CHILDMHSMISUD]; -- RUN TIME 00:21:32
						EXEC [dbo].[sp_ECMPOF_CHILDWELFARE]; -- RUN TIME 00:00:47

STEP99:   'sp_CHATGPT_ECMPOF_...sql' - ;EXEC IN [SQLPROD02]; JAG CHATGPT_ ALGORITHM ADJUSTMENT TO ECM POF ("CHATGPT 2026 ECM Eligibility Algorithm.docx")
		~ sp_CHATGPT_ECMPOF_ADULT_HOMELESS_W_FAMILY_20260630.sql
		~ sp_CHATGPT_ECMPOF_ADULTMHSMISUD_20260629.sql
		~ sp_CHATGPT_ECMPOF_ADULTWITHOUTFAMILY_HOMELESS_WO_FAMILY_20260630.sql
		~ sp_CHATGPT_ECMPOF_CHILDCCS_20260630.sql
		~ sp_CHATGPT_ECMPOF_CHILDHOMELESS_INDIVIDUAL_20260630.sql
		~ sp_CHATGPT_ECMPOF_CHILDHOMELESS_W_FAMILY_20260630.sql
		~ sp_CHATGPT_ECMPOF_CHILDINCARCERATION_20260630.sql
		~ sp_CHATGPT_ECMPOF_CHILDMHSMISUD_20260629.sql
		
JAH 'UNCHANGEDyoy: '
-- =====================================================================
	-- MODIFICATION(S) | CHANGE LOG: --
-- =====================================================================
-- OPT-01: WITH (NOLOCK) → (NOLOCK) per DUB C 2.0 Rule 07 — removed WITH keyword; hint now precedes AS alias on all table refs
-- OPT-02: UNION → UNION ALL per DUB C 2.0 Rule 13 — dedup handled downstream; eliminates unnecessary sort/dedup pass
-- OPT-03: JOIN → INNER JOIN per Rule 10 — explicit JOIN type always required
-- OPT-04: SELECT DISTINCT → SELECT...GROUP BY in DIAG subquery per Rule 12 — GROUP BY preferred over DISTINCT
-- OPT-05: SERVICE IN() — replaced placeholder H0043/H0044 (TransitionalRent codes) with G9919 per JAG ChatGPT Social Complexity crosswalk
-- OPT-06: DIAG IN() — expanded from 8 Z59 codes to full Social Complexity ICD-10 set per JAG ChatGPT crosswalk (7 factors)

SELECT * INTO INFORMATICS.dbo.CHATGPT_ECMPOF_ADULT_BIRTH_EQUITY FROM INFORMATICS.dbo.ECMPOF_ADULT_BIRTH_EQUITY AS p WITH (NOLOCK)
SELECT * INTO INFORMATICS.dbo.CHATGPT_ECMPOF_CHILD_BIRTH_EQUITY FROM INFORMATICS.dbo.ECMPOF_CHILD_BIRTH_EQUITY AS p WITH (NOLOCK)

SELECT * INTO INFORMATICS.dbo.CHATGPT_ECMPOF_ADULT_INCARCERATION FROM INFORMATICS.dbo.ECMPOF_ADULT_INCARCERATION AS p WITH (NOLOCK) 
SELECT * INTO INFORMATICS.dbo.CHATGPT_ECMPOF_CHILD_INCARCERATION FROM INFORMATICS.dbo.ECMPOF_CHILD_INCARCERATION AS p WITH (NOLOCK) 

SELECT * INTO INFORMATICS.dbo.CHATGPT_ECMPOF_CHILD_WELFARE FROM INFORMATICS.dbo.ECMPOF_CHILD_WELFARE AS p WITH (NOLOCK)

SELECT * INTO INFORMATICS.dbo.CHATGPT_ECMPOF_ADULT_INSTITUTIONALIZATION FROM INFORMATICS.dbo.ECMPOF_ADULT_INSTITUTIONALIZATION AS p WITH (NOLOCK)

SELECT * INTO INFORMATICS.dbo.CHATGPT_ECMPOF_ADULT_NURSING_TRANSITION FROM INFORMATICS.dbo.ECMPOF_ADULT_NURSING_TRANSITION AS p WITH (NOLOCK)

SELECT * INTO INFORMATICS.dbo.CHATGPT_ECMPOF_ADULT_IPSNFED_HIGHUTIL FROM INFORMATICS.dbo.ECMPOF_ADULT_IPSNFED_HIGHUTIL AS p WITH (NOLOCK)
SELECT * INTO INFORMATICS.dbo.CHATGPT_ECMPOF_CHILD_IPSNFED_HIGHUTIL FROM INFORMATICS.dbo.ECMPOF_CHILD_IPSNFED_HIGHUTIL AS p WITH (NOLOCK)

		~ LEVERAGE: "ECM POF CHATGPT ALGORITHM CHANGES 20260629.sql"

		SELECT 'ECM POF Adult Avoidable Hospital or ED Utilization' AS ' '
		,bp.LINE_OF_BUSINESS AS 'LOB AT REPORT EXEC'
		,COUNT(DISTINCT(pof.memid)) AS [Unique Member Count] 
		FROM INFORMATICS.dbo.CHATGPT_ECMPOF_ADULT_IPSNFED_HIGHUTIL AS pof
			INNER JOIN INFORMATICS.dbo.uvw_BASELINE_MEMBERSHIP AS bp ON pof.memid = bp.memid  -- HMOPROD_PLANDATA.dbo.benefitplan + HMOPROD_PLANDATA.dbo.program
		WHERE 1=1
			AND pof.RunDate = (SELECT MAX(RunDate) FROM INFORMATICS.dbo.ECMPOF_ADULT_IPSNFED_HIGHUTIL)
		GROUP BY bp.LINE_OF_BUSINESS;
		
		SELECT 'ECM POF Adult Avoidable Hospital or ED Utilization' AS ' '
		,bp.LINE_OF_BUSINESS AS 'LOB AT REPORT EXEC'
		,COUNT(DISTINCT(pof.memid)) AS [Unique Member Count] 
		FROM INFORMATICS.dbo.CHATGPT_ECMPOF_CHILD_IPSNFED_HIGHUTIL AS pof
			INNER JOIN INFORMATICS.dbo.uvw_BASELINE_MEMBERSHIP AS bp ON pof.memid = bp.memid  -- HMOPROD_PLANDATA.dbo.benefitplan + HMOPROD_PLANDATA.dbo.program
		WHERE 1=1
			AND pof.RunDate = (SELECT MAX(RunDate) FROM INFORMATICS.dbo.ECMPOF_CHILD_IPSNFED_HIGHUTIL)
		GROUP BY bp.LINE_OF_BUSINESS;

						EXEC [dbo].[sp_ECMPOF_ADULTINCARCERATION]; -- RUN TIME 00:06:36
						EXEC [dbo].[sp_ECMPOF_ADULTINSTITUTIONALIZATION]; -- RUN TIME 00:00:57
						EXEC [dbo].[sp_ECMPOF_ADULTHIGHUTIL]; -- RUN TIME 00:12:06
						EXEC [dbo].[sp_ECMPOF_ADULTMHSMISUD]; -- RUN TIME 00:21:26
						EXEC [dbo].[sp_ECMPOF_ADULTNURSING]; -- RUN TIME 00:00:09
						EXEC [dbo].[sp_ECMPOF_ADULT_HOMELESS_W_FAMILY]; -- RUN TIME 00:25:48
						EXEC [dbo].[sp_ECMPOF_ADULTWITHOUTFAMILY_HOMELESS_WO_FAMILY]; -- RUN TIME 00:24:54

						EXEC [dbo].[sp_ECMPOF_BIRTHEQUITY]; -- RUN TIME 00:17:05 ... COMBINED | CHILD AND ADULT 

						EXEC [dbo].[sp_ECMPOF_CHILDCCS]; -- RUN TIME 00:02:59
						EXEC [dbo].[sp_ECMPOF_CHILDHOMELESS_INDIVIDUAL]; -- RUN TIME 00:24:13
						EXEC [dbo].[sp_ECMPOF_CHILDHOMELESS_W_FAMILY]; -- RUN TIME 00:24:55
						EXEC [dbo].[sp_ECMPOF_CHILDINCARCERATION]; -- RUN TIME 00:00:43
						EXEC [dbo].[sp_ECMPOF_CHILDHIGHUTIL]; -- RUN TIME 00:12:29
						EXEC [dbo].[sp_ECMPOF_CHILDMHSMISUD]; -- RUN TIME 00:21:32
						EXEC [dbo].[sp_ECMPOF_CHILDWELFARE]; -- RUN TIME 00:00:47
		
-- ======================================================================================
	-- JAG CHATGPT_ ALGORITHM ADJUSTMENT TO ECM POF ("CHATGPT 2026 ECM Eligibility Algorithm.docx") -- 
-- ======================================================================================
--------------------------------------------------------------------------------------------------------------------
	-- Error Trapping: Check If Permanent Table(s) Already Exist(s) And Drop If Applicable --
--------------------------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS #Homeless_TransitionalRent;

SELECT DISTINCT c.memid
,c.claimid
,c.startdate
,cd.servcode
,ISNULL(sc.description,'') AS [CodeDescr]
,'SERVICE' AS [code type]
INTO #Homeless_TransitionalRent
FROM HMOPROD_PlanData.dbo.claim AS c WITH (NOLOCK)
	INNER JOIN HMOPROD_PlanData.dbo.claimdetail AS cd WITH (NOLOCK) ON c.claimid = cd.claimid
		LEFT JOIN HMOPROD_PLANDATA.dbo.svccode AS sc WITH (NOLOCK) ON SUBSTRING(UPPER(LTRIM(RTRIM(ISNULL(cd.servcode,'')))),1,5) = SUBSTRING(UPPER(LTRIM(RTRIM(ISNULL(sc.codeid,'')))),1,5)
WHERE 1=1 
	AND SUBSTRING(UPPER(LTRIM(RTRIM(ISNULL(cd.servcode,'')))),1,5) IN ('H0043','H0044') -- AS [CPT Service Code]
	AND c.startdate BETWEEN @StartDate AND @EndDate
	AND (c.resubclaimid IS NULL OR c.resubclaimid = '')
	AND c.claimid NOT LIKE '%R%'
	AND c.[status] IN ('ADJUCATED', 'PAID', 'PAY', 'REV', 'REVERSED', 'REVSYNCH');

		SELECT * FROM #Homeless_TransitionalRent;
		
,h.claimid AS ClaimIdH
,h.servcode AS CodeIdH
,h.[CodeDescr] AS [CodeIdDescr]
,h.[code type]
,h.startdate AS StartDateH	

h.claimid AS ClaimIdH,
h.servcode AS CodeIdH,
h.[CodeDescr] AS [CodeIdDescr],
h.[code type],
h.startdate AS StartDateH,

	INNER JOIN #Homeless_TransitionalRent AS h ON mm.memid = h.memid		
	
/* WHEN SUBSTRING(UPPER(LTRIM(RTRIM(ISNULL(asr.codeid,'')))),1,5) IN ('H0040') 
	AND (modcode IN ('U1') OR modcode2 IN ('U1') OR modcode3 IN ('U1') OR modcode4 IN ('U1') OR modcode5 IN ('U1')) 
THEN 'Transitional Rent'
WHEN SUBSTRING(UPPER(LTRIM(RTRIM(ISNULL(asr.codeid,'')))),1,5) IN ('H0040','H0043') 
	AND (modcode IN ('U2') OR modcode2 IN ('U2') OR modcode3 IN ('U2') OR modcode4 IN ('U2') OR modcode5 IN ('U2')) 
THEN 'Transitional Rent'
WHEN SUBSTRING(UPPER(LTRIM(RTRIM(ISNULL(asr.codeid,'')))),1,5) IN ('H0044') 
	AND (modcode IN ('U6') OR modcode2 IN ('U6') OR modcode3 IN ('U6') OR modcode4 IN ('U6') OR modcode5 IN ('U6')) 
THEN 'Transitional Rent' */

/* ISNULL(sc.description,'') AS [CodeDescr]
 ,UPPER(LTRIM(RTRIM(ISNULL(scg.description,'')))) + ' - ' + UPPER(LTRIM(RTRIM(ISNULL(scat.description,'')))) + ': ' + UPPER(LTRIM(RTRIM(ISNULL(ssc.description,'')))) AS 'ServiceCatDescr'
,scg.catid
,scg.subcatid
,scg.svcgroupid
,sc.*
FROM HMOPROD_PLANDATA.dbo.svccode AS sc 
	LEFT JOIN HMOPROD_PLANDATA.dbo.svccatgroup AS scg ON sc.codeid = scg.codeid
	LEFT JOIN HMOPROD_PLANDATA.dbo.svccategory AS scat ON scg.catid = scat.catid
	LEFT JOIN HMOPROD_PLANDATA.dbo.svcsubcategory AS ssc ON scg.catid = ssc.catid
		AND scg.subcatid = ssc.subcatid
		AND scg.svcgroupid = 'C01154158'
WHERE 1=1 	
	AND SUBSTRING(UPPER(LTRIM(RTRIM(ISNULL(sc.codeid,'')))),1,5) IN ('99408','99409','G0396','G0397','G0443','H0001','H0005','H0007','H0015','H0016','H0022','H0047','H0050','H2035','H2036','T1006','T1012','H0006','H0028') -- 'SMI' =  Serious Mental Illness 'SUD' = Substance Use Disorder ... AS [CPT Service Code] */
	
x LEVERAGE:
		'ECM_POF_G_MemberDetails_20260623.sql'
		'ECM_POF_H_MemberDetails_20260623.sql'
		'ECM_POF_I_MemberDetails_20260623.sql'

-- =====================================================================
	-- DECLARE @PARAMETER(S) / @FILTER(S) --
-- =====================================================================
DECLARE @ClockStart AS date = TRY_CONVERT(date,GETDATE()) -- CURRENT v TRY_CONVERT(date,'01/01/2022')  -- ECM CALAIM GO LIVE
DECLARE @ClockStop AS date = TRY_CONVERT(date,GETDATE())
DECLARE @StartDate AS date = TRY_CONVERT(date,'01/01/2022') -- ECM CALAIM GO LIVE ... CLAIM LOOKBACK WINDOW
DECLARE @EndDate AS date = GETDATE()
DECLARE @ReportRunDate AS date = GETDATE()
DECLARE @AgeCutoff AS int = 21 -- ADULT: >= 21
DECLARE @PCPrecordRANK AS int = 1 -- MOST CURRENT PCP
DECLARE @EnrolledMonths AS decimal(9,0) = 36
-- C003: USE MAX(RunDate) FROM POF TABLE SO THIS SCRIPT ALWAYS TARGETS THE MOST RECENT SP RUN
-- AVOIDS EMPTY RESULTS WHEN @ReportRunDate (GETDATE()) DOES NOT MATCH THE STORED RunDate
DECLARE @POF_G_RunDate AS date = (SELECT MAX(RunDate) FROM INFORMATICS.dbo.ECMPOF_ADULTWITHOUTFAMILY_HOMELESS)

		SELECT 'ECM POF G | Adults without Dependent Experiencing Homelessness' AS [REPORT]
		,CONVERT(varchar(10),@ReportRunDate,101) AS [RUN DATE]
		,'BETWEEN '+CONVERT(varchar(10),@StartDate,101)+' AND '+CONVERT(varchar(10),@EndDate,101) AS [CLAIM DATE RANGE]
		,'EXEC dbo.sp_ECMPOF_ADULTWITHOUTFAMILY_HOMELESS_WO_FAMILY MUST RUN BEFORE THIS SCRIPT' AS [PRE-REQ NOTE]
		,@POF_G_RunDate AS [POF TABLE RunDate IN USE]

-- =====================================================================
	-- DECLARE @PARAMETER(S) / @FILTER(S) --
-- =====================================================================
DECLARE @ClockStart AS date = TRY_CONVERT(date,GETDATE()) -- CURRENT v TRY_CONVERT(date,'01/01/2022')  -- ECM CALAIM GO LIVE
DECLARE @ClockStop AS date = TRY_CONVERT(date,GETDATE())
DECLARE @StartDate AS date = TRY_CONVERT(date,'01/01/2022') -- ECM CALAIM GO LIVE ... CLAIM LOOKBACK WINDOW
DECLARE @EndDate AS date = GETDATE()
DECLARE @ReportRunDate AS date = GETDATE()
DECLARE @AgeCutoff AS int = 21 -- ADULT: >= 21
DECLARE @PCPrecordRANK AS int = 1 -- MOST CURRENT PCP
DECLARE @EnrolledMonths AS decimal(9,0) = 36
-- C003: USE MAX(RunDate) FROM POF TABLE SO THIS SCRIPT ALWAYS TARGETS THE MOST RECENT SP RUN ... AVOIDS EMPTY RESULTS WHEN @ReportRunDate (GETDATE()) DOES NOT MATCH THE STORED RunDate
DECLARE @POF_H_RunDate AS date = (SELECT MAX(RunDate) FROM INFORMATICS.dbo.ECMPOF_ADULTWITHFAMILY_HOMELESS)
DECLARE @POF_HCHILD_RunDate AS date = (SELECT MAX(RunDate) FROM INFORMATICS.dbo.ECMPOF_CHILDWITHFAMILY_HOMELESS)

		SELECT 'ECM POF H | Homeless Families (Adult Families Experiencing Homelessness)' AS [REPORT]
		,CONVERT(varchar(10),@ReportRunDate,101) AS [RUN DATE]
		,'BETWEEN '+CONVERT(varchar(10),@StartDate,101)+' AND '+CONVERT(varchar(10),@EndDate,101) AS [CLAIM DATE RANGE]
		,'EXEC dbo.sp_ECMPOF_ADULT_HOMELESS_W_FAMILY MUST RUN BEFORE THIS SCRIPT' AS [PRE-REQ NOTE]
		,@POF_H_RunDate AS [POF ADULT RunDate IN USE]
		,@POF_HCHILD_RunDate AS [POF CHILD RunDate IN USE]

-- =====================================================================
	-- DECLARE @PARAMETER(S) / @FILTER(S) --
-- =====================================================================
DECLARE @ClockStart AS date = TRY_CONVERT(date,GETDATE()) -- CURRENT v TRY_CONVERT(date,'01/01/2022')  -- ECM CALAIM GO LIVE
DECLARE @ClockStop AS date = TRY_CONVERT(date,GETDATE())
DECLARE @StartDate AS date = TRY_CONVERT(date,'01/01/2022') -- ECM CALAIM GO LIVE ... CLAIM LOOKBACK WINDOW
DECLARE @EndDate AS date = GETDATE()
DECLARE @ReportRunDate AS date = GETDATE()
DECLARE @AgeCutoff AS int = 21 -- CHILD/YOUTH: < 21
DECLARE @PCPrecordRANK AS int = 1 -- MOST CURRENT PCP
DECLARE @EnrolledMonths AS decimal(9,0) = 36
-- C003: USE MAX(RunDate) FROM POF TABLE SO THIS SCRIPT ALWAYS TARGETS THE MOST RECENT SP RUN 
-- AVOIDS EMPTY RESULTS WHEN @ReportRunDate (GETDATE()) DOES NOT MATCH THE STORED RunDate
-- DECLARE @POF_I_RunDate AS date = (SELECT MAX(RunDate) FROM INFORMATICS.dbo.ECMPOF_CHILD_HOMELESS)
DECLARE @POF_I_RunDate AS date = (SELECT MAX(RunDate) FROM INFORMATICS.dbo.ECMPOF_CHILDWITHOUTFAMILY_HOMELESS)

		SELECT 'ECM POF I | Unaccompanied Children and Youth Experiencing Homelessness' AS [REPORT]
		,CONVERT(varchar(10),@ReportRunDate,101) AS [RUN DATE]
		,'BETWEEN '+CONVERT(varchar(10),@StartDate,101)+' AND '+CONVERT(varchar(10),@EndDate,101) AS [CLAIM DATE RANGE]
		,'EXEC dbo.sp_ECMPOF_CHILDHOMELESS_INDIVIDUAL MUST RUN BEFORE THIS SCRIPT' AS [PRE-REQ NOTE]
		,@POF_I_RunDate AS [POF CHILD INDIVIDUAL RunDate IN USE]				







JAH 'ECM POF HOMELESS DETAIL LISTING':
		⏎ Good day, we have a task to compile a list of ECM Eligible and ECM Enrolled members falling under specific POF (Population of Focus). Specifically with the listing have a column which flag which code or logic made the member eligible for the given POF:

May I have you assist in this effort & which context will aid in making this efficient for you?

🚩 FOLDER CONNECT FEATURE IN Cowork
				USE [PATH]: file:///C:/Users/wcarr/Desktop/ - 'ROOT [FOLDER]'
				USE [PATH]: file:///C:/Users/wcarr/Desktop/ECMElig.sql - 'ECM ELIG LOGIC'
				USE [PATH]: file:///C:/Users/wcarr/Desktop/ECMEnroll.sql - 'ECM ENROLLED LOGIC'
				
		2)	John: Population of Focus #1. G. ('Adults without Dependent Experiencing Homelessness') Yousaf to provide a list of Z codes (risk of homelessness) so John can run a report o see how many member have that Z codes 
		
				USE [PATH]: file:///C:/Users/wcarr/Desktop/ECMPOF_ADULT_HOMELESS_WITHOUT_DEPENDENT_CHILDREN_OR_YOUTH_LIVING_WITH_THEM_20250811.sql
				
		3)	John: Population of Focus #2. H. ('Homeless Families') how many individual members qualify for homelessness using the diagnosis code specified in the narrative.  
		
				USE [PATH]: file:///C:/Users/wcarr/Desktop/ECMPOF_ADULT_HOMELESS_WITH_FAMILY_20250811.sql
				
		4)	John: Population of Focus #3. I. ('Unaccompanied Children and Youth Experiencing Homelessness') how many individual members qualify for homelessness using the diagnosis code specified in the narrative
		
				USE [PATH]: file:///C:/Users/wcarr/Desktop/ECMPOF_CHILD_HOMELESS_INDIVIDUAL_20250811.sql

x From: John Costello 
Sent: Friday, June 19, 2026 2:22 PM
To: Walter Carr <WCarr@chgsd.com>
Cc: Tatsani Flora <TInkha@chgsd.com>; Allan Sombillo <asombi@chgsd.com>
Subject: FW: ECM Population of Focus

Hi Walter,

Can you please take the current ECM CS code for sections G (Adults without Dependent Experiencing Homelessness), H (Homeless Families), and I (Unaccompanied Children and Youth Experiencing Homelessness) and produce the member details report for each population?    We need to include the Z code that triggered them to be in that population and in the case of section G what other physical, behavioral or developmental diagnosis that accompanied that Z code.  Also, for populations H and I, we will want to see the dependents that rolled up to the individual.  I think it is a good idea to also include age for all the members and their dependents.  Please let me know if you have any questions.

Regards,

John Costello

From: Tatsani Flora <TInkha@chgsd.com> 
Sent: Friday, June 19, 2026 10:17 AM
To: Yousaf Farook <YFaroo@chgsd.com>; Blanca Cecilia Villa <CecyVilla@chgsd.com>; John Costello <jcostello@chgsd.com>
Cc: Allan Sombillo <asombi@chgsd.com>; Kathryn Madrid <kmadrid@chgsd.com>; Kelly Bly <kbly@chgsd.com>
Subject: ECM Population of Focus

Good Morning Yousaf and Cecy:

Would you please review if the attached narrative is the document we went over during CARE meeting yesterday? This is the copy that Walter has.  John and team will start generating the requested reports based off the attached document unless you have a different version.

Requested From CARE:
		-- 1)	Yousaf: Based on the list Yousaf shared,  Yousaf to verify if the providers have the physician on site.  Please let us know if there is anything we assist you with.
		2)	John: Population of Focus #1. G. Yousaf to provide a list of Z codes (risk of homelessness) so John can run a report o see how many member have that Z codes 
		3)	John: Population of Focus #2. H. how many individual members qualify for homelessness using the diagnosis code specified in the narrative.  
		4)	John: Population of Focus #3. I. how many individual members qualify for homelessness using the diagnosis code specified in the narrative
		-- 5)	John: Using ChatGPT or QNXT Tables, review if the Z codes provided are relevant to homelessness
		-- 6)	John: Population of Focus #9.M. compare the population from this logic to the new logic that Kelly, Aldo, and Adam use to identify Incarcerated members.  How are they compare?

Thanks,
Tatsani

		 file:///C:/Users/wcarr/Desktop/ECM_POF_G_MemberDetails_20260622B.sql
		 file:///C:/Users/wcarr/Desktop/ECM_POF_H_MemberDetails_20260622B.sql
		 file:///C:/Users/wcarr/Desktop/ECM_POF_I_MemberDetails_20260622B.sql
		 file:///C:/Users/wcarr/Desktop/ECM%20POF%20MS%20EXCEL%20OLE%20DB%20ODBC%2020260622.sql - 'MS EXCEL OLE DB ODBC'

-- =====================================================================
-- DECLARE @PARAMETER(S) / @FILTER(S) --
-- =====================================================================
DECLARE @ClockStart AS date = TRY_CONVERT(date,GETDATE()) -- CURRENT v TRY_CONVERT(date,'01/01/2022')  -- ECM CALAIM GO LIVE
DECLARE @ClockStop AS date = TRY_CONVERT(date,GETDATE())
DECLARE @StartDate AS date = TRY_CONVERT(date,'01/01/2022') -- ECM CALAIM GO LIVE ... CLAIM LOOKBACK WINDOW
DECLARE @EndDate AS date = GETDATE()
DECLARE @ReportRunDate AS date = GETDATE()
DECLARE @AgeCutoff AS int = 21 -- ADULT: >= 21
DECLARE @PCPrecordRANK AS int = 1 -- MOST CURRENT PCP
DECLARE @EnrolledMonths AS decimal(9,0) = 36
-- C003: USE MAX(RunDate) FROM POF TABLE SO THIS SCRIPT ALWAYS TARGETS THE MOST RECENT SP RUN
-- AVOIDS EMPTY RESULTS WHEN @ReportRunDate (GETDATE()) DOES NOT MATCH THE STORED RunDate
DECLARE @POF_G_RunDate AS date = (SELECT MAX(RunDate) FROM INFORMATICS.dbo.ECMPOF_ADULTWITHOUTFAMILY_HOMELESS)

		SELECT 'ECM POF G | Adults without Dependent Experiencing Homelessness' AS [REPORT]
		,CONVERT(varchar(10),@ReportRunDate,101) AS [RUN DATE]
		,'BETWEEN '+CONVERT(varchar(10),@StartDate,101)+' AND '+CONVERT(varchar(10),@EndDate,101) AS [CLAIM DATE RANGE]
		,'EXEC dbo.sp_ECMPOF_ADULTWITHOUTFAMILY_HOMELESS_WO_FAMILY MUST RUN BEFORE THIS SCRIPT' AS [PRE-REQ NOTE]
		,@POF_G_RunDate AS [POF TABLE RunDate IN USE]

		-- SELECT TOP 1 * FROM INFORMATICS.dbo.ECMPOF_CHILDWITHFAMILY_HOMELESS AS pof ORDER BY RunDate DESC
		-- SELECT TOP 1 * FROM INFORMATICS.dbo.ECMPOF_CHILDWITHOUTFAMILY_HOMELESS AS pof ORDER BY RunDate DESC
		-- SELECT TOP 1 * FROM INFORMATICS.dbo.ECMPOF_CHILD_HOMELESS AS pof ORDER BY RunDate DESC
		-- SELECT TOP 1 * FROM INFORMATICS.dbo.ECMPOF_ADULTWITHFAMILY_HOMELESS AS pof ORDER BY RunDate DESC
		SELECT TOP 1 * FROM INFORMATICS.dbo.ECMPOF_ADULTWITHOUTFAMILY_HOMELESS AS pof ORDER BY RunDate DESC

-- =====================================================================
-- DECLARE @PARAMETER(S) / @FILTER(S) --
-- =====================================================================
DECLARE @ClockStart AS date = TRY_CONVERT(date,GETDATE()) -- CURRENT v TRY_CONVERT(date,'01/01/2022')  -- ECM CALAIM GO LIVE
DECLARE @ClockStop AS date = TRY_CONVERT(date,GETDATE())
DECLARE @StartDate AS date = TRY_CONVERT(date,'01/01/2022') -- ECM CALAIM GO LIVE ... CLAIM LOOKBACK WINDOW
DECLARE @EndDate AS date = GETDATE()
DECLARE @ReportRunDate AS date = GETDATE()
DECLARE @AgeCutoff AS int = 21 -- ADULT: >= 21
DECLARE @PCPrecordRANK AS int = 1 -- MOST CURRENT PCP
DECLARE @EnrolledMonths AS decimal(9,0) = 36
-- C003: USE MAX(RunDate) FROM POF TABLE SO THIS SCRIPT ALWAYS TARGETS THE MOST RECENT SP RUN ... AVOIDS EMPTY RESULTS WHEN @ReportRunDate (GETDATE()) DOES NOT MATCH THE STORED RunDate
DECLARE @POF_H_RunDate AS date = (SELECT MAX(RunDate) FROM INFORMATICS.dbo.ECMPOF_ADULTWITHFAMILY_HOMELESS)
DECLARE @POF_HCHILD_RunDate AS date = (SELECT MAX(RunDate) FROM INFORMATICS.dbo.ECMPOF_CHILDWITHFAMILY_HOMELESS)

		SELECT 'ECM POF H | Homeless Families (Adult Families Experiencing Homelessness)' AS [REPORT]
		,CONVERT(varchar(10),@ReportRunDate,101) AS [RUN DATE]
		,'BETWEEN '+CONVERT(varchar(10),@StartDate,101)+' AND '+CONVERT(varchar(10),@EndDate,101) AS [CLAIM DATE RANGE]
		,'EXEC dbo.sp_ECMPOF_ADULT_HOMELESS_W_FAMILY MUST RUN BEFORE THIS SCRIPT' AS [PRE-REQ NOTE]
		,@POF_H_RunDate AS [POF ADULT RunDate IN USE]
		,@POF_HCHILD_RunDate AS [POF CHILD RunDate IN USE]

		SELECT TOP 1 * FROM INFORMATICS.dbo.ECMPOF_CHILDWITHFAMILY_HOMELESS AS pof ORDER BY RunDate DESC
		-- SELECT TOP 1 * FROM INFORMATICS.dbo.ECMPOF_CHILDWITHOUTFAMILY_HOMELESS AS pof ORDER BY RunDate DESC
		-- SELECT TOP 1 * FROM INFORMATICS.dbo.ECMPOF_CHILD_HOMELESS AS pof ORDER BY RunDate DESC
		SELECT TOP 1 * FROM INFORMATICS.dbo.ECMPOF_ADULTWITHFAMILY_HOMELESS AS pof ORDER BY RunDate DESC
		-- SELECT TOP 1 * FROM INFORMATICS.dbo.ECMPOF_ADULTWITHOUTFAMILY_HOMELESS AS pof ORDER BY RunDate DESC

-- =====================================================================
-- DECLARE @PARAMETER(S) / @FILTER(S) --
-- =====================================================================
DECLARE @ClockStart AS date = TRY_CONVERT(date,GETDATE()) -- CURRENT v TRY_CONVERT(date,'01/01/2022')  -- ECM CALAIM GO LIVE
DECLARE @ClockStop AS date = TRY_CONVERT(date,GETDATE())
DECLARE @StartDate AS date = TRY_CONVERT(date,'01/01/2022') -- ECM CALAIM GO LIVE ... CLAIM LOOKBACK WINDOW
DECLARE @EndDate AS date = GETDATE()
DECLARE @ReportRunDate AS date = GETDATE()
DECLARE @AgeCutoff AS int = 21 -- CHILD/YOUTH: < 21
DECLARE @PCPrecordRANK AS int = 1 -- MOST CURRENT PCP
DECLARE @EnrolledMonths AS decimal(9,0) = 36
-- C003: USE MAX(RunDate) FROM POF TABLE SO THIS SCRIPT ALWAYS TARGETS THE MOST RECENT SP RUN 
-- AVOIDS EMPTY RESULTS WHEN @ReportRunDate (GETDATE()) DOES NOT MATCH THE STORED RunDate
-- DECLARE @POF_I_RunDate AS date = (SELECT MAX(RunDate) FROM INFORMATICS.dbo.ECMPOF_CHILD_HOMELESS)
DECLARE @POF_I_RunDate AS date = (SELECT MAX(RunDate) FROM INFORMATICS.dbo.ECMPOF_CHILDWITHOUTFAMILY_HOMELESS)

		SELECT 'ECM POF I | Unaccompanied Children and Youth Experiencing Homelessness' AS [REPORT]
		,CONVERT(varchar(10),@ReportRunDate,101) AS [RUN DATE]
		,'BETWEEN '+CONVERT(varchar(10),@StartDate,101)+' AND '+CONVERT(varchar(10),@EndDate,101) AS [CLAIM DATE RANGE]
		,'EXEC dbo.sp_ECMPOF_CHILDHOMELESS_INDIVIDUAL MUST RUN BEFORE THIS SCRIPT' AS [PRE-REQ NOTE]
		,@POF_I_RunDate AS [POF CHILD INDIVIDUAL RunDate IN USE]

		-- SELECT TOP 1 * FROM INFORMATICS.dbo.ECMPOF_CHILDWITHFAMILY_HOMELESS AS pof ORDER BY RunDate DESC
		SELECT TOP 1 * FROM INFORMATICS.dbo.ECMPOF_CHILDWITHOUTFAMILY_HOMELESS AS pof ORDER BY RunDate DESC
		-- SELECT TOP 1 * FROM INFORMATICS.dbo.ECMPOF_CHILD_HOMELESS AS pof ORDER BY RunDate DESC
		-- SELECT TOP 1 * FROM INFORMATICS.dbo.ECMPOF_ADULTWITHFAMILY_HOMELESS AS pof ORDER BY RunDate DESC
		-- SELECT TOP 1 * FROM INFORMATICS.dbo.ECMPOF_ADULTWITHOUTFAMILY_HOMELESS AS pof ORDER BY RunDate DESC







JAH 'ADD CHPIV MEMBERSHIP TO D-SNP DSNP ECM POF SCRIPT(S): '
FROM: [spUPDATEMemberMonths] 
,CAST(ulob.LINE_OF_BUSINESS AS NVARCHAR(25)) AS LOB -- C005: TO ALLEVIATE TRUNCATION ERROR FROM 20251015 SSA JOB SCHEDULED RUN: Message Executed as user: CHG\qnxtadmin. String or binary data would be truncated. [SQLSTATE 22001] (Error 8152)  The statement has been terminated. [SQLSTATE 01000] (Error 3621).  The step failed.
	
-- =====================================================================
	-- Add the parameters for the stored procedure here:
-- =====================================================================
		/* DECLARE */ @CurrentLOB AS varchar(25) = 'DSNP' -- DEFAULT VAL() 'LOB' OPTION(S): 				CSNP 				CMC 				DSNP 				Medi-Cal 				Unknown

AS
BEGIN

-- =====================================================================
	-- MODIFICATION(S) | CHANGE LOG: --
-- =====================================================================
-- C002: ADD CHPIV MEMBERSHIP TO D-SNP DSNP ECM POF SCRIPT(S): 

		/* From: Kathryn Madrid <kmadrid@chgsd.com> 
		Sent: Thursday, December 4, 2025 3:56 PM
		To: Blanca Cecilia Villa <CecyVilla@chgsd.com>; Yousaf Farook <YFaroo@chgsd.com>; Walter Carr <WCarr@chgsd.com>
		Subject: RE: DSNP POF FOR CHPIV?

		Thanks!  @Walter Carr, please confirm the DSNP CHPIV members will also be located here: INFORMATICS.dbo.uvwECMTargetPopulations’ ?

		Thanks!

		From: Blanca Cecilia Villa <CecyVilla@chgsd.com> 
		Sent: Thursday, December 4, 2025 3:54 PM
		To: Kathryn Madrid <kmadrid@chgsd.com>; Yousaf Farook <YFaroo@chgsd.com>
		Cc: Walter Carr <WCarr@chgsd.com>
		Subject: RE: DSNP POF FOR CHPIV?

		Good afternoon, 

		Yes, according to the new regulations, 

		Thank you, 

		Cecy

		From: Kathryn Madrid <kmadrid@chgsd.com> 
		Sent: Thursday, December 4, 2025 2:46 PM
		To: Blanca Cecilia Villa <CecyVilla@chgsd.com>; Yousaf Farook <YFaroo@chgsd.com>
		Cc: Walter Carr <WCarr@chgsd.com>
		Subject: DSNP POF FOR CHPIV?

		Hi Cecy / Yousaf,

		Will we be assessing DSNP CHPIV members for POF?  */

-- =====================================================================
	-- DYNAMIC() v. STATIC() DECLARE(s) FOR [CLAIM LISTING REFINEMENT] --
-- =====================================================================
DECLARE @RangeStartDate date = DATEADD(mm,-12,GETDATE())
DECLARE @RangeEndDate date = GETDATE()
DECLARE @ReportRunDate date = GETDATE()
DECLARE @AgeCutoff int = 21
DECLARE @PCPrecordRANK AS int = 1 -- ENTER 1 TO GET() JUST MOST CURRENT [RANKis] see DENSE_RANK() OVER(PARTITION BY ek.memid ORDER BY CAST(ek.effdate AS datetime) DESC) AS [RANKis] --'RANKis' --RANK by MOST CURRENT

		-- SELECT TOP 1 @AgeCutoff AS 'AGE LIMIT >= (GREATER THAN EQUAL TO)'
		-- ,@ReportRunDate AS [RunDate]
		-- ,'BETWEEN '+CAST(CAST(@RangeStartDate AS date) AS varchar(MAX))+' AND '+CAST(CAST(@RangeEndDate AS date) AS varchar(MAX)) AS 'RANGE NOTE(S)'
		-- ,mm.LOB,mm.* 
		FROM INFORMATICS.dbo.MemberMonths AS mm
		WHERE 1=1
			AND mm.CurrentMonth = 1 -- CURRENTLY ACTIVE OR ... LOB AT REPORT EXEC 
			AND (ISNULL(mm.LOB,'') IN (@CurrentLOB)
				OR ISNULL(mm.LOB,'') LIKE '%IV%') 

		SELECT ' ' AS 'MemberMonths LOB OPTION(S): '
		,ISNULL(LOB,'') AS [LOB]
		FROM INFORMATICS.dbo.MemberMonths AS mm
		GROUP BY ISNULL(LOB,'')
		
		-- SELECT * FROM INFORMATICS.dbo.uvw_LINE_OF_BUSINESS
		
WHERE 1=1
	AND mm.CurrentMonth = 1 -- CURRENTLY ACTIVE OR ... LOB AT REPORT EXEC 
	AND (ISNULL(mm.LOB,'') IN (@CurrentLOB)
		OR ISNULL(mm.LOB,'') LIKE '%IV%') -- C002: ADD CHPIV MEMBERSHIP TO D-SNP DSNP ECM POF SCRIPT(S): 
		
		⏎ ACT AS a Senior Data Analyst WITH 20+ years OF EXPERIENCE. PLEASE MODIFY the EXISTING CODE provided FOR CONTEXT:
				   ✅ ENSURE THAT THE QUERY FOLLOWS ALL 'DUB C 2.0 CODING' STYLE STANDARDS AND PREFERENCES /*  BLOCK BY BLOCK */:
						~ PLEASE ENSURE THAT ALL COMMENTS FROM ORIGINAL CODE ARE PRESERVED.
						~ PLEASE ENSURE that the JOIN FIELDS ARE ON THE SAME LINE
						~ PLEASE ENSURE EXPLICIT JOIN Type: Change JOIN TO INNER JOIN FOR clarity AND better optimization by the query engine ... BE MINDFUL OF CREATING ERRONEOUS /* LEFT JOIN */ ^ /* RIGHT INNER JOIN */ ^ /* CROSS INNER JOIN */
						~ PLEASE ENSURE that SELECT statements ARE NOT LEFT alone ON their own lines.
						~ PLEASE ENSURE that ALL TABLE AND FIELD aliases ARE PRECEDED BY 'AS' keyword.
						~ PLEASE ENSURE that the COMMA (,) FOR EACH FIELD IS ON THE LEFT HAND SIDE
						~ PLEASE ENSURE that ALL SQL SYNTAX IS IN UPPER CASE
						~ PLEASE RESTRUCTURE the CASE statements so that CASE, WHEN, THEN, ELSE, AND END each begin at the start of a new line.
						~ PLEASE DO NOT ADD LEADING spaces/indentation TO align fields vertically. Commas should be placed at the start of each line WITH NO preceding spaces. EACH field should START immediately after the comma.
						~ WHERE (NOLOCK) IS PRESENT APPLY IT DIRECTLY AFTER TABLE OR FIELD
						~ CONSIDER Removing DISTINCT IN FAVOR OF GROUP BY: REPLACE the DISTINCT IN the final SELECT WITH a proper GROUP BY clause. This IS more EXPLICIT about the aggregation intent AND allows the query optimizer to work more efficiently.
						~ CONSIDER CHANGING UNION to UNION ALL WHEN handling OF duplicates IS HANDLED WITHIN the final aggregation. This eliminates unnecessary duplicate removal operations at each union step, significantly improving performance.
						~ TO AVOID TRUNCATION ERROR(S) WITH AN INSERT STATEMENT PLEASE ENSURE THAT EVERY field being INSERTED has an EXPLICIT CAST TO MATCH the CREATE TABLE DATA TYPES EXACTLY  ... TRUNCATE ^ INSERT INTO ^ EXPLICIT COLUMN DEFINITIONS
						~ PLEASE PROVIDE the COMPLETE OPTIMIZED CODE.

-- ❌ INCORRECT (with alignment spacing / indentation):
       ,1 AS [QtrNum]
       ,DATEPART(YEAR,@ClockStart) AS [Year]
 
-- ✅ CORRECT (no alignment spacing / indentation):
,1 AS [QtrNum]
,DATEPART(YEAR,@ClockStart) AS [Year]

#03.
FROM HMOPROD_PLANDATA.dbo.enrollkeys (NOLOCK) AS ek
CROSS JOIN INFORMATICS.dbo.date_calendarISO (NOLOCK) AS dc -- CALENDAR(S) -- INDEPENDENT STAND ALONE ... CROSS APPLY() CROSS JOIN() CARTESIAN PRODUCT
	INNER JOIN INFORMATICS.dbo.[uvw_LINE_OF_BUSINESS] (NOLOCK) AS bp ON ek.programid = bp.programid
		LEFT JOIN HMOPROD_PLANDATA.dbo.language (NOLOCK) AS lang ON lang.languageid = mem.primarylanguage
WHERE 1=1 /* CARDINALITY HIERARCHY FOR ... Building dynamic WHERE conditions ... AND ... */
	AND CAST(ISNULL(c.enddate,'9999-12-31') AS date)>=p.RangeStartDate -- WITHIN reporting period [RANGE] OPPOSITION
	-- AND CAST(ISNULL(c.enddate,GETDATE()) AS date)>=p.RangeStartDate -- WITHIN reporting period [RANGE] OPPOSITION
GROUP BY -- v SELECT DISTINCT ... CONSIDER Removing DISTINCT IN FAVOR OF GROUP BY: REPLACE the DISTINCT IN the final SELECT WITH a proper GROUP BY clause. This IS more EXPLICIT about the aggregation intent AND allows the query optimizer to work more efficiently.

		🚀 THE BUSINESS CASE: /* PROS */
				1. Performance Velocity: 
						~ Speed to insight: (NOLOCK) bypasses locking mechanisms. When you ARE running reports against massive enrollment tables – we ARE talking millions of member records – this can mean the difference between a 2-minute query and a 45-second query

		Concurrency liberation: Your analysts ARE NOT blocked waiting for write operations to complete. In a fast-moving healthcare environment where enrollment data is constantly updating, this keeps your business intelligence flowing

				2. Operational Continuity: 
						~ No deadlock scenarios: You eliminate the risk of reader-writer deadlocks. I HAVE seen production systems grind to a halt because reporting queries locked with enrollment batch processes

		Resource efficiency: Fewer locks = less memory overhead = lower SQL Server resource contention
		 
		🚀 THE RISK PROFILE: /* CONS */
		Now here's where it gets serious – and why I'd challenge any of my portfolio companies using NOLOCK without a governance framework:
				1. Data Integrity Compromise (DIRTY READS)
						-- Your query might read:
						Member ID: 12345, Plan: Gold, Status: Active
						 
						-- But mid-query, a transaction rolls back:
						ACTUAL DATA: Member ID: 12345, Plan: Silver, Status: Pending
 
In healthcare analytics? That is catastrophic. You are reporting enrollment numbers to CMS that do NOT exist. you ARE calculating risk adjustments on phantom members. I HAVE seen companies face seven-figure audit penalties for exactly this scenario.







JAH 'ECM POF'
-- C004: PER TEAMS CHAT WITH MS KATHRYN ADD '... AND are you able to put the first RunDate in here? INFORMATICS.dbo.uvwECMTargetPopulations' ON 20251009

JAH THANK YOU JAH 
JAH THANK YOU JAH 
UNION → UNION ALL: CHANGE ALL UNION to UNION ALL WHEN handling OF duplicates IS HANDLED WITHIN the final aggregation. This eliminates unnecessary duplicate removal operations at each union step, significantly improving performance.

JAH THANK YOU JAH 
		⏎ ACT AS a Senior Data Analyst WITH 20+ years OF EXPERIENCE. PLEASE OPTIMIZE the existing CODE provided / attached AS CONTEXT taking SQL QUERY EXECUTION ORDER OF OPERATION(S) INTO consideration FOR performance, readability, AND maintainability

				✅ ENSURE THAT THE QUERY FOLLOWS ALL 'DUB C 2.0 CODING' STANDARDS AND PREFERENCES:
						~ PLEASE ENSURE THAT COMMENTS FROM ORIGINAL CODE ARE PRESERVED.
						~ PLEASE ENSURE that the JOIN FIELDS ARE ON THE SAME LINE
						~ PLEASE ENSURE EXPLICIT JOIN Type: Change JOIN to INNER JOIN for clarity and better optimization by the query engine
						~ PLEASE ENSURE that SELECT statements ARE NOT left alone ON their own lines.
						~ PLEASE ENSURE that ALL TABLE AND FIELD aliases ARE PRECEDED BY 'AS' keyword.
						~ PLEASE ENSURE that the COMMA (,) FOR EACH FIELD IS ON THE LEFT HAND SIDE
						~ PLEASE ENSURE that ALL SQL SYNTAX IS IN UPPER CASE
						~ WHERE (NOLOCK) IS PRESENT APPLY IT DIRECTLY AFTER TABLE OR FIELD
						~ PLEASE DO NOT ADD leading spaces/indentation to align fields vertically. Commas should be placed at the start of each line with NO preceding spaces. Each field should start immediately after the comma.
						~ CONSIDER Removing DISTINCT IN FAVOR OF GROUP BY: REPLACE the DISTINCT in the final SELECT with a proper GROUP BY clause. This is more explicit about the aggregation intent and allows the query optimizer to work more efficiently.
~ CONSIDER CHANGING UNION to UNION ALL WHEN handling OF duplicates IS HANDLED WITHIN the final aggregation. This eliminates unnecessary duplicate removal operations at each union step, significantly improving performance.
						~ PLEASE PROVIDE the COMPLETE OPTIMIZED CODE.						

-- ❌ INCORRECT (with alignment spacing / indentation):
	 ,1 AS [QtrNum]
	 ,DATEPART(YEAR,@ClockStart) AS [Year]

-- ✅ CORRECT (no alignment spacing / indentation):
,1 AS [QtrNum]
,DATEPART(YEAR,@ClockStart) AS [Year]

		⏎ Thank you, I very much appreciate your guidance & as a result revised my '... STANDARDS AND PREFERENCES:' (see below for context). I finalized the view & now may I have you PLEASE ASSIST IN GENERATING AN EXECUTIVE SUMMARY 'CXO EXECUTIVE SUMMARY' TO FACILITATE STORYTELLING WITH CONTEXT IN the voice of Robert F Smith CEO of Vista Equity and ensure alignment with the ask from Ms Kathryn to... (see screen capture for the ask context)

JAH THANK YOU JAH 
Key Optimizations Applied:

Performance Enhancements:
		1.	UNION → UNION ALL: Changed all UNION to UNION ALL since you arere already handling duplicates with the final aggregation. This eliminates unnecessary duplicate removal operations at each union step, significantly improving performance.
		2.	Removed DISTINCT + Added GROUP BY: Replaced the DISTINCT in the final SELECT with a proper GROUP BY clause. This is more explicit about the aggregation intent and allows the query optimizer to work more efficiently.
		3.	Simplified TRY_CONVERT: Removed the redundant TRY_CONVERT(DATE,ISNULL(...)) wrapper in the subquerys MIN function since the conversion already happened in the CTE.
		4.	Explicit JOIN Type: Changed JOIN to INNER JOIN for clarity and better optimization by the query engine.

DUB C 2.0 Standards Applied:
		✅ All SQL keywords converted to UPPERCASE
		✅ Commas placed on LEFT side with NO leading spaces
		✅ All aliases preceded by AS keyword
		✅ JOIN conditions on same line
		✅ SELECT statements not alone on their own lines
		✅ All original comments preserved
		✅ No vertical alignment spacing
		✅ Complete code provided

Execution Benefits:
The optimized version reduces processing overhead by approximately 20-30% through the elimination of duplicate checking at each UNION step and more efficient aggregation handling in the final query

JAH THANK YOU JAH 
Dissected SQL view, strategized optimization for performance

Let me analyze this SQL view and optimize it according to the DUB C 2.0 coding standards provided. The user wants me to:
		1.	Optimize for performance, readability, and maintainability
		2.	Consider SQL query execution order of operations
		3.	Follow specific coding standards: 
				o	Preserve original comments
				o	JOIN fields on the same line
				o	SELECT statements not alone on their own lines
				o	ALL table and field aliases preceded by 'AS' keyword
				o	Comma on the LEFT hand side
				o	ALL SQL syntax in UPPER CASE
				o	(NOLOCK) directly after table/field where present
				o	NO leading spaces/indentation to align fields vertically
				o	Commas at start of each line with NO preceding spaces
				o	Provide COMPLETE optimized code

Let me review the current code:
		1.	The view uses a CTE (pof) that unions multiple tables
		2.	Each union selects the same columns: TargetPopulation, memid, carriermemid, secondaryid, RunDate
		3.	The main query joins pof with a subquery (minpof) that finds the minimum RunDate per memid and TargetPopulation
		4.	All the WHERE clauses have commented out date filters

Performance considerations:
		•	The current approach creates a large union, then joins it with a subquery that groups the same data
		•	This means the data is scanned twice
		•	The DISTINCT in the final SELECT might be redundant if the join is correct
		•	Using TRY_CONVERT repeatedly could be optimized
		•	The commented-out WHERE clauses suggest they might want to filter by latest RunDate, but currently all data is included

Optimization opportunities:
		1.	Consider if DISTINCT is necessary in the final SELECT
		2.	The TRY_CONVERT is applied multiple times - this could be done once
		3.	The subquery minpof could be optimized
		4.	Consider if there are indexes on memid and TargetPopulation

I''ll focus on implementing the DUB C 2.0 coding standards with precision. The formatting will prioritize readability while maintaining the core logic of the original view. I''ll carefully restructure the SQL to meet the specified guidelines, ensuring each element aligns with the prescribed formatting rules.

The key approach will involve:
		•	Restructuring the SQL syntax
		•	Applying consistent uppercase for keywords
		•	Repositioning commas to the left side
		•	Adding AS keywords for all aliases
		•	Preserving the original query''s core logic and performance characteristics

Looking at this SQL view, I''ll optimize it for performance, readability, and maintainability while adhering to all DUB C 2.0 coding standards. Here is the complete optimized code:
Optimized uvwECMTargetPopulations View

USE [INFORMATICS] GO /****** Object: View [dbo].[uvwECMTargetPopulations] Script Date: 10/9/2025 1:05:30 PM ******/ SET ANSI_NULLS ON GO SET QUOTED_IDENTIFIER ON GO CREATE OR ALTER VIEW [dbo].[uvwECMTargetPopulations] -- <VIEW_Name, sysname, 

x ADD 1st MEMBER APPEARANCE BY POF 

x HI Walter, good morning.. questiooon.. do you know when the POF for CCS went into effect?
 
AND are you able to put the first RunDate in here? INFORMATICS.dbo.uvwECMTargetPopulations
 
20230616 is my first run Young Lady of the 'ECM POF CHILD CCS' script.
 
By 'AND are you able to put the first RunDate in here' you mean ADD a column to the view? If Yes, for you but of course. When would you need this done?
 
anytime is fine to add it
 
thank youuuuu
 
still not sure on the WHY of the spike
 
but seems could be related to the member's status in the program
 
Just to clarify for each POF you want the first run date ... or at least the first time I ran the given ECM POF script in this added column?
 
no, like the first run date that identified the member's POF
 
so then i can tell when you first identified
 
and then that should be within 1 day of their ECM eligiblity (dev process)
 
That might be a bit more of a challenge as some of these POF scripts were inherited and did not necessarily have an 'ExecutionDate' or 'RunDate'. I can certainly bring in the MIN(ExecutionDate) from when I took over  (and added an ExecutionDate field)  the scripts by Member by POF. I shall keep you posted Young Lady.
 
SELECT TOP 100 * FROM INFORMATICS.dbo.uvwECMTargetPopulations
SELECT TOP 100 * FROM INFORMATICS.dbo.ECMPOF_CHILD_CCS

SELECT MIN(RunDate) AS 'MIN',MAX(RunDate) AS 'MAX' FROM INFORMATICS.dbo.ECMPOF_CHILD_CCS 

SELECT MIN(TRY_CONVERT(date,ISNULL(RunDate,GETDATE()))) AS 'First RunDate'
,memid
,TargetPopulation
FROM INFORMATICS.dbo.ECMPOF_CHILD_CCS 
GROUP BY memid,TargetPopulation

		SELECT 'ECM POF Child CCS/CCS WCM with Additional Needs' AS ' '
		,bp.LINE_OF_BUSINESS AS 'LOB AT REPORT EXEC'
		,pof.RunDate
		,COUNT(DISTINCT(pof.memid)) AS [Unique Member Count] 
		FROM INFORMATICS.dbo.ECMPOF_CHILD_CCS AS pof
			JOIN INFORMATICS.dbo.uvw_BASELINE_MEMBERSHIP AS bp ON pof.memid = bp.memid  -- HMOPROD_PLANDATA.dbo.benefitplan + HMOPROD_PLANDATA.dbo.program
		WHERE 1=1
			-- AND bp.LINE_OF_BUSINESS IN ('DSNP'); -- ('CSNP','CMC','MEDICARE ADVANTAGE','DSNP','MEDI-CAL')
		GROUP BY bp.LINE_OF_BUSINESS,pof.RunDate
		ORDER BY pof.RunDate DESC;







JAH 'ECM JSON'
x SUMMARY AND DETAIL
		-- USE [PATH]: \\Chg_cifs01\depts\HCS\HHP Master\ECM Master\JSON Files - 'QA THE DETAIL: ' FROM MS KATHRYN & SIR EVAN
		USE [PATH]: file://chg_cifs01/depts/HCS/HHP%20Master/ECM%20Master/JSON%20Files/ - 'QA THE DETAIL: ' FROM MS KATHRYN & SIR EVAN







JAH 'uvwECM_CAPACITY'
Hello Walter
 
I will bug you pretty soon with the capacity numbers 
 
10/06/2025
 
ECM capacity changes to make for this Quarterly report: 
 
1134838352 adults 700
1356889539 kids 1950

	('PAIR TEAM MEDICAL GROUP OF CALIFORNIA', '1134838352', 'Community-Based Organization (CBO)', 500, 300), -- C006: Additional ECM PROVIDER PER SIR OMAR - LEVERAGE: "Update to ECM CS Quarterly Reporting  Narrative.msg" AND "SIR OMAR MOC Excel File ECM Provider Capacity Template 2025 Mapping 09.05.2025.xlsx" AS OF 20250905

-- C###: PER TEAMS DICSUSSION WITH MS TANIA ON 20251006 ... Hello Walter  I will bug you pretty soon with the capacity numbers  10/06/2025  ECM capacity changes to make for this Quarterly report:  1134838352 adults 700 1356889539 kids 1950
 
 
 Hello Y''all 
 
Yes, Walter. Please go ahead and override the report.
 
Just to confirm, these are New changes. 
 
1134838352	700	300
1356889539	3000	1950
 
 
Also, New changes from this month, but I believe you already made the changes. 
 
1306665146	1500	75
1457804635	250	50
1801907449	900	500
1306534797	100	0
  
Let me know if you have any questions and thank you!







JAH 'POF ADJUSTMENT(S): '
SELECT * 
FROM FINCHG.dbo.Current_AidCode_Crosswalk 
WHERE 1=1 
AND [AID CODE] IN ('G5'
,'G6'
,'G7'
,'G8'
,'4K'
,'N7'
,'N8'
,'N0'
,'F3'
,'F4'
,'G3'
,'G4'
,'I2'
,'I3'
,'I4'
,'I5'
,'I6') -- LEVERAGE"STEP88_AIDCODE_...sql" ... SELECT * FROM FINCHG.dbo.Current_AidCode_Crosswalk -- C0002: JUSTICE INVOLVED FORMERLY INCARCERATION AID CODE(S) UPDATED PER TEAMS CONVERSATION WITH SIR OMAR ON 20250909 see "ECM POF INCARCERATION JUSTICE INVOLVED.png" ... These are the aid codes that we are wondering if they need to be included in the narrative Aid Codes: I2, I3, I4, I5 and l6

		AND UPPER(LTRIM(RTRIM(ISNULL(ma.thevalue,'IGNORE')))) IN ('G5'
		,'G6'
		,'G7'
		,'G8'
		,'4K'
		,'N7'
		,'N8'
		,'N0'
		,'F3'
		,'F4'
		,'G3'
		,'G4'
		,'I2'
		,'I3'
		,'I4'
		,'I5'
		,'I6') -- LEVERAGE"STEP88_AIDCODE_...sql" ... SELECT * FROM FINCHG.dbo.Current_AidCode_Crosswalk -- C002: JUSTICE INVOLVED FORMERLY INCARCERATION AID CODE(S) UPDATED PER TEAMS CONVERSATION WITH SIR OMAR ON 20250909 see "ECM POF INCARCERATION JUSTICE INVOLVED.png" ... These are the aid codes that we are wondering if they need to be included in the narrative Aid Codes: I2, I3, I4, I5 and l6

Sir, certainly I can make the change & yes an updated narrative would be most appreciated as 'documentation' has been a hot item for JAG.
 
Good afternoon Walter. I have a question about the ECM POF Narrative, specifically  for Individuals transitioning from Incarceration for Adults and Youth. 
 
We have aid codes that are not on the Narrative, but I am not sure if they need to be included or not based on the current logic
 
 Individuals greater than 21 years of age transitioning from incarceration who have significant complex physical or oral health needs requiring immediate transition
 of services to the
community.
 
Use the following Aid codes:
G5
G6
G7
G8
4K
N7
N8
N0
F3
F4
G3
G4
 
AND
 
Any other diagnosis (physical, behavioral or developmental).
 
Or
 
Look for justice involved code (J) in the 834.  If the JI code (J) is present on the 834 file then mark the member eligible for this PoF.
 
 This is what is on the current narrative
 
These are the aid codes that we are wondering if they need to be included in the narrative
 
Aid Codes: I2, I3, I4, I5 and l6
 
These would come from the  834 file 
 
In your opinion does the Narrative have to be update to include these aid codes?
 
Sir, such that we have the changes documented yes please may I trouble you to update the narrative. In the interim I will implement the Aid Code updates based upon this conversation.
 
 
 
 
 
 
 
JAH 'ECM POF UPDATE(S) ...CTRL + H' ... THREE 3 DSNP_ECM... 
x SEQUENCE(): 
		STEP00: 'SSMS SSA (SQL SERVER AGENT) JOB'; AUTOMATION - ;EXEC IN [SQLPROD02]; JOB RUNS ON "Occurs every week on Sunday at 5:19:00 PM. Schedule will be used starting on 5/31/2024." @1719 see "Refresh ECM POF SOURCE sp" 

JOB STEP(S): 'ECM POF Refresh: '
Refresh ECM POF SOURCE sp
EXEC [dbo].[sp_ECMPOF_ADULTINCARCERATION]; -- RUN TIME 00:06:36
EXEC [dbo].[sp_ECMPOF_ADULTINSTITUTIONALIZATION]; -- RUN TIME 00:00:57
EXEC [dbo].[sp_ECMPOF_ADULTHIGHUTIL]; -- RUN TIME 00:12:06
EXEC [dbo].[sp_ECMPOF_ADULTMHSMISUD]; -- RUN TIME 00:21:26
EXEC [dbo].[sp_ECMPOF_ADULTNURSING]; -- RUN TIME 00:00:09
EXEC [dbo].[sp_ECMPOF_ADULT_HOMELESS_W_FAMILY]; -- RUN TIME 00:25:48
EXEC [dbo].[sp_ECMPOF_ADULTWITHOUTFAMILY_HOMELESS_WO_FAMILY]; -- RUN TIME 00:24:54
EXEC [dbo].[sp_ECMPOF_BIRTHEQUITY]; -- RUN TIME 00:17:05 ... CHILD AND ADULT COMBINED
EXEC [dbo].[sp_ECMPOF_CHILDCCS]; -- RUN TIME 00:02:59
EXEC [dbo].[sp_ECMPOF_CHILDHOMELESS_INDIVIDUAL]; -- RUN TIME 00:24:13
EXEC [dbo].[sp_ECMPOF_CHILDHOMELESS_W_FAMILY]; -- RUN TIME 00:24:55
EXEC [dbo].[sp_ECMPOF_CHILDINCARCERATION]; -- RUN TIME 00:00:43
EXEC [dbo].[sp_ECMPOF_CHILDHIGHUTIL]; -- RUN TIME 00:12:29
EXEC [dbo].[sp_ECMPOF_CHILDMHSMISUD]; -- RUN TIME 00:21:32
EXEC [dbo].[sp_ECMPOF_CHILDWELFARE]; -- RUN TIME 00:00:47
ECM POF Refresh

JOB STEP(S): 'ECM POF Refresh DSNP: '
Refresh ECM POF SOURCE sp DSNP 
EXEC [dbo].[sp_DSNP_ECMPOF_ADULTINCARCERATION]; -- RUN TIME 00:06:36
EXEC [dbo].[sp_DSNP_ECMPOF_ADULTINSTITUTIONALIZATION]; -- RUN TIME 00:00:57
EXEC [dbo].[sp_DSNP_ECMPOF_ADULTHIGHUTIL]; -- RUN TIME 00:12:06
EXEC [dbo].[sp_DSNP_ECMPOF_ADULTMHSMISUD]; -- RUN TIME 00:21:26
EXEC [dbo].[sp_DSNP_ECMPOF_ADULTNURSING]; -- RUN TIME 00:00:09
EXEC [dbo].[sp_DSNP_ECMPOF_ADULT_HOMELESS_W_FAMILY]; -- RUN TIME 00:25:48
EXEC [dbo].[sp_DSNP_ECMPOF_ADULTWITHOUTFAMILY_HOMELESS_WO_FAMILY]; -- RUN TIME 00:24:54
EXEC [dbo].[sp_DSNP_ECMPOF_ADULT_BIRTHEQUITY]; -- RUN TIME 00:25:47
EXEC [dbo].[sp_DSNP_ECMPOF_DEMENTIA]; -- RUN TIME 00:25:47
ECM POF Refresh DSNP 

-- C###: SUNSET DEPRECATED DECOMMISSIONED AS OF 20250811 see "ECM POF Narrative include DSNP Dementia 7.10.2025.docx"
		"SUNSET_DEPRECATE_DECOMMISSION_...sql"

		SELECT TOP 1 *FROM INFORMATICS.dbo.ECMPOFPCP -- LEGACY
		-- SELECT COUNT(1) FROM INFORMATICS.dbo.ECMPOFPCP -- LEGACY
		SELECT COUNT(1) FROM INFORMATICS.dbo.ECMPOF_CHILD_HOMELESS
		SELECT COUNT(1) FROM INFORMATICS.dbo.ECMPOF_CHILDWITHFAMILY_HOMELESS
		SELECT COUNT(1) FROM INFORMATICS.dbo.ECMPOF_CHILDWITHOUTFAMILY_HOMELESS
		SELECT COUNT(1) FROM INFORMATICS.dbo.ECMPOF_CHILD_IPSNFED_HIGHUTIL
		SELECT COUNT(1) FROM INFORMATICS.dbo.ECMPOF_CHILD_MHSMISUD
		SELECT COUNT(1) FROM INFORMATICS.dbo.ECMPOF_CHILD_INCARCERATION
		SELECT COUNT(1) FROM INFORMATICS.dbo.ECMPOF_CHILD_CCS
		SELECT COUNT(1) FROM INFORMATICS.dbo.ECMPOF_CHILD_WELFARE
		SELECT COUNT(1) FROM INFORMATICS.dbo.ECMPOF_CHILD_BIRTH_EQUITY
		-- SELECT COUNT(1) FROM INFORMATICS.dbo.ECMPOF_CHILD_IDD -- SUNSET DEPRECATED DECOMMISSIONED AS OF 20250811

		-- SELECT TOP 10 * FROM [ProviderPortal].[ECM].
		SELECT COUNT(1) FROM INFORMATICS.dbo.ECMPOF_ADULT_IPSNFED_HIGHUTIL
		SELECT COUNT(1) FROM INFORMATICS.dbo.ECMPOF_ADULT_MHSMISUD
		SELECT COUNT(1) FROM INFORMATICS.dbo.ECMPOF_ADULT_INCARCERATION
		SELECT COUNT(1) FROM INFORMATICS.dbo.ECMPOF_ADULT_INSTITUTIONALIZATION
		SELECT COUNT(1) FROM INFORMATICS.dbo.ECMPOF_ADULT_NURSING_TRANSITION
		-- SELECT COUNT(1) FROM INFORMATICS.dbo.ECMPOF_ADULT_PREGNANCY_POSTPARTUM -- REPLACED BY BIRTH EQUITY POF
		-- SELECT COUNT(1) FROM INFORMATICS.dbo.ECMPOF_ADULT_IDD -- SUNSET DEPRECATED DECOMMISSIONED AS OF 20250811
		SELECT COUNT(1) FROM INFORMATICS.dbo.ECMPOF_ADULTWITHFAMILY_HOMELESS
		SELECT COUNT(1) FROM INFORMATICS.dbo.ECMPOF_ADULTWITHOUTFAMILY_HOMELESS
		SELECT COUNT(1) FROM INFORMATICS.dbo.ECMPOF_ADULT_BIRTH_EQUITY
		
		SELECT COUNT(1) FROM INFORMATICS.dbo.DSNP_ECMPOF_ADULT_IPSNFED_HIGHUTIL
		SELECT COUNT(1) FROM INFORMATICS.dbo.DSNP_ECMPOF_ADULT_MHSMISUD
		SELECT COUNT(1) FROM INFORMATICS.dbo.DSNP_ECMPOF_ADULT_INCARCERATION
		SELECT COUNT(1) FROM INFORMATICS.dbo.DSNP_ECMPOF_ADULT_INSTITUTIONALIZATION
		SELECT COUNT(1) FROM INFORMATICS.dbo.DSNP_ECMPOF_ADULT_NURSING_TRANSITION
		SELECT COUNT(1) FROM INFORMATICS.dbo.DSNP_ECMPOF_ADULTWITHFAMILY_HOMELESS
		SELECT COUNT(1) FROM INFORMATICS.dbo.DSNP_ECMPOF_ADULTWITHOUTFAMILY_HOMELESS	
		SELECT COUNT(1) FROM INFORMATICS.dbo.DSNP_ECMPOF_ADULT_BIRTH_EQUITY	
		SELECT COUNT(1) FROM INFORMATICS.dbo.DSNP_ECMPOF_ADULT_DEMENTIA	
		
x START WITH() 'InsertECMPOFData'
-- =====================================================================
	-- Add the parameters for the stored procedure here:
-- =====================================================================
		/* DECLARE */ @CurrentLOB AS varchar(25) = 'Medi-Cal' -- DEFAULT VAL() 'LOB' OPTION(S): 				CSNP 				CMC 				DSNP 				Medi-Cal 				Unknown 'LOB' OPTION(S): 				C-SNP 				CMC 				D-SNP 				Medi-Cal 				Unknown	
		/* DECLARE */ @CurrentLOB AS varchar(25) = 'D-SNP' -- DEFAULT VAL()

		~ -- NO NOT NEGATIVE <> != ... MS KATHRYN ENROLLED CCM / CM IDENTIFICATION

		~ CurrentMonth = 1 -- CURRENTLY ACTIVE OR ... LOB AT REPORT EXEC 

WHERE 1=1
	AND mm.CurrentMonth = 1 -- CURRENTLY ACTIVE OR ... LOB AT REPORT EXEC 
	
		SELECT DISTINCT LOB FROM INFORMATICS.dbo.MemberMonths
				'LOB': 				C-SNP 				CMC 				D-SNP 				Medi-Cal 				Unknown	

x NEAR BOTTOM OF EACH sp see "... AND mm.LOB = 'Medi-Cal'"
		-- ... AND mm.LOB = 'Medi-Cal'
		... AND mm.LOB IN (@CurrentLOB)
			
x CHARINDEX() FIND() SEARCH() 'SUBJECT:"*POF*" FROM:NOREPLY'
-- C002: SUNSET 	"sp_ECMPOF_PCP" FOR uvw_PCP AS OF 20250811 AND TO BETTER ACCOMODATE THE IMPLEMENTATION OF "ECM POF Narrative include DSNP Dementia 7.10.2025.docx"
DECLARE @FileId AS int = (SELECT MAX(f.FileId) AS FileId FROM CHGAPP_PROD.dbo.tblEDIProcessedFile AS f JOIN CHGAPP_PROD.dbo.tblEDIHMISData AS d ON d.FileId = f.FileId)
DECLARE @StartDate DATE = DATEADD(MONTH, -12, GETDATE());
DECLARE @EndDate DATE = GETDATE();
DECLARE @ReportRunDate DATE = GETDATE();
DECLARE @AgeCutoff INT = 21;
DECLARE @PCPrecordRANK INT = 1; -- ENTER 1 TO GET() JUST MOST CURRENT [RANKis] see DENSE_RANK() 

-- =====================================================================
	-- MODIFICATION(S) | CHANGE LOG: --
-- =====================================================================
--  C001:  POF NAMING CONVENTION UPDATE(S): 
		/* 'Adult Individuals Experiencing Homelessness' REPLACE() SUBSTITUTE() WITH() Adult Individuals Experiencing Homelessness
		'Adult Homeless WITH Family' REPLACE() SUBSTITUTE() WITH() Adult Families Experiencing Homelessness
		'Adult IP ED High Utilization' REPLACE() SUBSTITUTE() WITH() Adult Avoidable Hospital or ED Utilization
		'Adult MH SMI SUD' REPLACE() SUBSTITUTE() WITH() Adult SMH or SUD
		-- 'Adult Transitioning from Incarceration' REPLACE() SUBSTITUTE() WITH() Adult Transitioning from Incarceration
		'Adult Institutionalization' REPLACE() SUBSTITUTE() WITH() Adult At Risk for LTC Institutionalization
		'Adult Nursing Transition' REPLACE() SUBSTITUTE() WITH() Adult NF Transitioning to Community
		'Adult Birth Equity' REPLACE() SUBSTITUTE() WITH() Adult Birth Equity

		'Child Homeless' REPLACE() SUBSTITUTE() WITH() Child Families Experiencing Homelessness
		'Child Homeless' REPLACE() SUBSTITUTE() WITH() Child Individuals Experiencing Homelessness
		'Child IP ED High Utilization' REPLACE() SUBSTITUTE() WITH() Child Avoidable Hospital or ED Utilization
		'Child MH SMI SUD' REPLACE() SUBSTITUTE() WITH() Child SMH or SUD
		'Child CCS' REPLACE() SUBSTITUTE() WITH() Child CCS/CCS WCM with Additional Needs
		-- 'Child Welfare' REPLACE() SUBSTITUTE() WITH() Child Welfare
		-- 'Child Transitioning from Incarceration' REPLACE() SUBSTITUTE() WITH() Child Transitioning from Incarceration
		-- 'Child Birth Equity' REPLACE() SUBSTITUTE() WITH() Child Birth Equity */

-- C002: ADD NEW SOURCE FOR HOMELESS IDENTIFICATION per eMAIL FROM MS CLAUDIA ON 20240708 ... (New HMIS data Source) Members who are on HMIS homeless member data base who have not exited the program.  If there is no project exit date then include these members in this population.

		SELECT DISTINCT ' ' AS 'MS CLAUDIA HOMELESS COMPARATIVE ANALYSIS REPORT',[Project Exit Date]
		,@FileId AS [HMIS (Homeless Management Information System) FILE IN USE]
		,@AgeCutoff AS [AGE LIMIT >= (GREATER THAN EQUAL TO)]
		,@ReportRunDate AS [AGE Ax + Report Run Date]
		,'BETWEEN ' + CONVERT(VARCHAR(10), @StartDate, 120) + ' AND ' + CONVERT(VARCHAR(10), @EndDate, 120) AS [RANGE NOTE(s)]
		-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
		-- SELECT DISTINCT ' ' AS 'CHECK 1st'
		FROM CHGAPP_PROD.dbo.tblEDIHMISData AS d 
		WHERE 1=1 
		-- AND [Project Exit Date] IS NULL 	-- C000: ADJUSTMENT per eMAIL ON 20240708 FROM MS CLAUDIA (SUBJECT: Updates to ECM Pof Narrative)- ... i.	(New HMIS data Source) Members who are on HMIS homeless member data base who have not exited the program.  If there is no project exit date then include these members in this population.
			AND TRY_CONVERT(date,ISNULL([Project Exit Date],GETDATE())) >= TRY_CONVERT(date,GETDATE()) -- C000: ADJUSTMENT per eMAIL ON 20240708 FROM MS CLAUDIA (SUBJECT: Updates to ECM Pof Narrative)- ... i.	(New HMIS data Source) Members who are on HMIS homeless member data base who have not exited the program.  If there is no project exit date then include these members in this population.

	-- CHECK FOR DUP(S) --
SELECT ' ' AS 'SHOULD RETURN 0 ROWS - DUP Validation',*
FROM INFORMATICS.dbo.uvw_BASELINE_MEMBERSHIP
WHERE 1=1
	AND memid IN
	( -- INITIATE ...
	SELECT memid
	FROM INFORMATICS.dbo.uvw_BASELINE_MEMBERSHIP AS dup
	GROUP BY memid -- Duplication Driver 
	HAVING COUNT(1)>1 -- HAVING clause RESERVED for AGGREGATE(s) ... HAVING SUM(PAID_NET_AMT) != 0
	) -- CONCLUDE ...

		SELECT DISTINCT LINE_OF_BUSINESS FROM INFORMATICS.dbo.uvw_BASELINE_MEMBERSHIP

-- Display results
		-- SELECT * FROM INFORMATICS.dbo.ECMPOF_ADULTWITHOUTFAMILY_HOMELESS

		SELECT 'ECM POF Adult Individuals Experiencing Homelessness' AS ' ',
		,bp.LINE_OF_BUSINESS AS 'LOB AT REPORT EXEC'
		,COUNT(DISTINCT(pof.memid)) AS [Unique Member Count] 
		FROM INFORMATICS.dbo.ECMPOF_ADULTWITHOUTFAMILY_HOMELESS AS pof
			JOIN INFORMATICS.dbo.uvw_BASELINE_MEMBERSHIP AS bp ON pof.memid = bp.memid  -- HMOPROD_PLANDATA.dbo.benefitplan + HMOPROD_PLANDATA.dbo.program
		WHERE 1=1
			-- AND bp.LINE_OF_BUSINESS IN ('DSNP'); -- ('CSNP','CMC','MEDICARE ADVANTAGE','DSNP','MEDI-CAL')
		GROUP BY bp.LINE_OF_BUSINESS;







		⏎ ACT AS a Senior Data Analyst WITH 20+ years OF EXPERIENCE. PLEASE OPTIMIZE the attached CODE taking SQL QUERY EXECUTION ORDER OF OPERATION(S) INTO consideration FOR performance, readability, AND maintainability 

		⏎ ACT AS a Senior Data Analyst WITH 20+ years of EXPERIENCE. In the voice of Robert F Smith CEO of Vista Equity, May I have you PLEASE ENSURE ALIGNMENT BETWEEN the existing CODE AND the REQUIREMENTS attached FOR CONTEXT (starting with the ... Child CODE scripts): 
		
		⏎ ACT AS a Senior Data Analyst WITH 20+ years of EXPERIENCE. In the voice of Robert F Smith CEO of Vista Equity, May I have you PLEASE ENSURE ALIGNMENT BETWEEN the existing CODE AND the REQUIREMENTS attached FOR CONTEXT (now with the ... Adult CODE scripts): 
		
		⏎ ACT AS a Senior Data Analyst WITH 20+ years of EXPERIENCE. I have 18 existing tables, see them listed below:

		SELECT COUNT(1) FROM INFORMATICS.dbo.ECMPOF_CHILD_HOMELESS
		SELECT COUNT(1) FROM INFORMATICS.dbo.ECMPOF_CHILDWITHFAMILY_HOMELESS
		SELECT COUNT(1) FROM INFORMATICS.dbo.ECMPOF_CHILDWITHOUTFAMILY_HOMELESS
		SELECT COUNT(1) FROM INFORMATICS.dbo.ECMPOF_CHILD_IPSNFED_HIGHUTIL
		SELECT COUNT(1) FROM INFORMATICS.dbo.ECMPOF_CHILD_MHSMISUD
		SELECT COUNT(1) FROM INFORMATICS.dbo.ECMPOF_CHILD_INCARCERATION
		SELECT COUNT(1) FROM INFORMATICS.dbo.ECMPOF_CHILD_CCS
		SELECT COUNT(1) FROM INFORMATICS.dbo.ECMPOF_CHILD_WELFARE
		SELECT COUNT(1) FROM INFORMATICS.dbo.ECMPOF_CHILD_IDD

		SELECT COUNT(1) FROM INFORMATICS.dbo.ECMPOF_ADULT_IPSNFED_HIGHUTIL
		SELECT COUNT(1) FROM INFORMATICS.dbo.ECMPOF_ADULT_MHSMISUD
		SELECT COUNT(1) FROM INFORMATICS.dbo.ECMPOF_ADULT_INCARCERATION
		SELECT COUNT(1) FROM INFORMATICS.dbo.ECMPOF_ADULT_INSTITUTIONALIZATION
		SELECT COUNT(1) FROM INFORMATICS.dbo.ECMPOF_ADULT_NURSING_TRANSITION
		SELECT COUNT(1) FROM INFORMATICS.dbo.ECMPOF_ADULT_PREGNANCY_POSTPARTUM
		SELECT COUNT(1) FROM INFORMATICS.dbo.ECMPOF_ADULT_IDD
		SELECT COUNT(1) FROM INFORMATICS.dbo.ECMPOF_ADULTWITHFAMILY_HOMELESS
		SELECT COUNT(1) FROM INFORMATICS.dbo.ECMPOF_ADULTWITHOUTFAMILY_HOMELESS

 I need to create a duplicate of these table with a prefix of 'DSNP_...'. My plan is to do what I have done below for the 'INFORMATICS.dbo.ECMPOF_CHILD_HOMELESS' table. May I have you assist in doing this for the remaining 17 tables?
 
 JAH THANK YOU JAH 
'RECIPIENT(S): ' Juan Castillo Belmontes <jbelmontes@chgsd.com>; Juan Francisco Sanchez juansanchez@chgsd.com

JAH THANK YOU JAH 
Certainly, Walter. Below is the SQL script that replicates your approach for the remaining 17 tables, creating a duplicate table with the prefix DSNP_ and truncating the newly created tables.

-- CHILD Tables: 
SELECT TOP 1 *
INTO INFORMATICS.dbo.DSNP_ECMPOF_CHILD_HOMELESS
FROM INFORMATICS.dbo.ECMPOF_CHILD_HOMELESS

TRUNCATE TABLE INFORMATICS.dbo.DSNP_ECMPOF_CHILD_HOMELESS

SELECT TOP 1 * INTO INFORMATICS.dbo.DSNP_ECMPOF_CHILDWITHFAMILY_HOMELESS FROM INFORMATICS.dbo.ECMPOF_CHILDWITHFAMILY_HOMELESS
TRUNCATE TABLE INFORMATICS.dbo.DSNP_ECMPOF_CHILDWITHFAMILY_HOMELESS

SELECT TOP 1 * INTO INFORMATICS.dbo.DSNP_ECMPOF_CHILDWITHOUTFAMILY_HOMELESS FROM INFORMATICS.dbo.ECMPOF_CHILDWITHOUTFAMILY_HOMELESS
TRUNCATE TABLE INFORMATICS.dbo.DSNP_ECMPOF_CHILDWITHOUTFAMILY_HOMELESS

SELECT TOP 1 * INTO INFORMATICS.dbo.DSNP_ECMPOF_CHILD_IPSNFED_HIGHUTIL FROM INFORMATICS.dbo.ECMPOF_CHILD_IPSNFED_HIGHUTIL
TRUNCATE TABLE INFORMATICS.dbo.DSNP_ECMPOF_CHILD_IPSNFED_HIGHUTIL

SELECT TOP 1 * INTO INFORMATICS.dbo.DSNP_ECMPOF_CHILD_MHSMISUD FROM INFORMATICS.dbo.ECMPOF_CHILD_MHSMISUD
TRUNCATE TABLE INFORMATICS.dbo.DSNP_ECMPOF_CHILD_MHSMISUD

SELECT TOP 1 * INTO INFORMATICS.dbo.DSNP_ECMPOF_CHILD_INCARCERATION FROM INFORMATICS.dbo.ECMPOF_CHILD_INCARCERATION
TRUNCATE TABLE INFORMATICS.dbo.DSNP_ECMPOF_CHILD_INCARCERATION

SELECT TOP 1 * INTO INFORMATICS.dbo.DSNP_ECMPOF_CHILD_CCS FROM INFORMATICS.dbo.ECMPOF_CHILD_CCS
TRUNCATE TABLE INFORMATICS.dbo.DSNP_ECMPOF_CHILD_CCS

SELECT TOP 1 * INTO INFORMATICS.dbo.DSNP_ECMPOF_CHILD_WELFARE FROM INFORMATICS.dbo.ECMPOF_CHILD_WELFARE
TRUNCATE TABLE INFORMATICS.dbo.DSNP_ECMPOF_CHILD_WELFARE

SELECT TOP 1 * INTO INFORMATICS.dbo.DSNP_ECMPOF_CHILD_IDD FROM INFORMATICS.dbo.ECMPOF_CHILD_IDD
TRUNCATE TABLE INFORMATICS.dbo.DSNP_ECMPOF_CHILD_IDD

-- ADULT Tables: 
SELECT TOP 1 * INTO INFORMATICS.dbo.DSNP_ECMPOF_ADULT_IPSNFED_HIGHUTIL FROM INFORMATICS.dbo.ECMPOF_ADULT_IPSNFED_HIGHUTIL
TRUNCATE TABLE INFORMATICS.dbo.DSNP_ECMPOF_ADULT_IPSNFED_HIGHUTIL

SELECT TOP 1 * INTO INFORMATICS.dbo.DSNP_ECMPOF_ADULT_MHSMISUD FROM INFORMATICS.dbo.ECMPOF_ADULT_MHSMISUD
TRUNCATE TABLE INFORMATICS.dbo.DSNP_ECMPOF_ADULT_MHSMISUD

SELECT TOP 1 * INTO INFORMATICS.dbo.DSNP_ECMPOF_ADULT_INCARCERATION FROM INFORMATICS.dbo.ECMPOF_ADULT_INCARCERATION
TRUNCATE TABLE INFORMATICS.dbo.DSNP_ECMPOF_ADULT_INCARCERATION

SELECT TOP 1 * INTO INFORMATICS.dbo.DSNP_ECMPOF_ADULT_INSTITUTIONALIZATION FROM INFORMATICS.dbo.ECMPOF_ADULT_INSTITUTIONALIZATION
TRUNCATE TABLE INFORMATICS.dbo.DSNP_ECMPOF_ADULT_INSTITUTIONALIZATION

SELECT TOP 1 * INTO INFORMATICS.dbo.DSNP_ECMPOF_ADULT_NURSING_TRANSITION FROM INFORMATICS.dbo.ECMPOF_ADULT_NURSING_TRANSITION
TRUNCATE TABLE INFORMATICS.dbo.DSNP_ECMPOF_ADULT_NURSING_TRANSITION

SELECT TOP 1 * INTO INFORMATICS.dbo.DSNP_ECMPOF_ADULT_PREGNANCY_POSTPARTUM FROM INFORMATICS.dbo.ECMPOF_ADULT_PREGNANCY_POSTPARTUM
TRUNCATE TABLE INFORMATICS.dbo.DSNP_ECMPOF_ADULT_PREGNANCY_POSTPARTUM

SELECT TOP 1 * INTO INFORMATICS.dbo.DSNP_ECMPOF_ADULT_IDD FROM INFORMATICS.dbo.ECMPOF_ADULT_IDD
TRUNCATE TABLE INFORMATICS.dbo.DSNP_ECMPOF_ADULT_IDD

SELECT TOP 1 * INTO INFORMATICS.dbo.DSNP_ECMPOF_ADULTWITHFAMILY_HOMELESS FROM INFORMATICS.dbo.ECMPOF_ADULTWITHFAMILY_HOMELESS
TRUNCATE TABLE INFORMATICS.dbo.DSNP_ECMPOF_ADULTWITHFAMILY_HOMELESS

SELECT TOP 1 * INTO INFORMATICS.dbo.DSNP_ECMPOF_ADULTWITHOUTFAMILY_HOMELESS FROM INFORMATICS.dbo.ECMPOF_ADULTWITHOUTFAMILY_HOMELESS
TRUNCATE TABLE INFORMATICS.dbo.DSNP_ECMPOF_ADULTWITHOUTFAMILY_HOMELESS

		Tips:
				•	Permissions: Ensure your SQL login has CREATE TABLE and TRUNCATE permissions.
				•	Indexes and Constraints: This method copies only structure and data, not indexes, constraints, or triggers. You can use SELECT INTO to scaffold the structure, then apply DDL scripts to match original table constraints if necessary.
				•	Future Automation: If you plan to do this regularly, consider a dynamic SQL script that loops through table names.

Would you like help generating a dynamic version of this script for easier reuse







		⏎ ACT AS a Senior Data Analyst WITH 20+ years of EXPERIENCE. PLEASE MODIFY the existing CODE TO ENSURE ALIGNMENT WITH the REQUIREMENTS attached FOR CONTEXT:	

CODE: 
AND alias.diag IN ('F10.920','F10.921','F10.929','F10.930','F10.931','F10.932','F10.939','F10.94','F10.950','F10.951','F10.959','F10.96','F10.97','F10.980','F10.981','F10.982','F10.988','F10.99','F11.90','F11.920','F11.921','F11.922','F11.929','F11.93','F11.94','F11.950','F11.951','F11.959','F11.981','F11.982','F11.988','F11.99','F12.90','F12.920','F12.921','F12.922','F12.929','F12.93','F12.950','F12.951','F12.959','F12.980','F12.988','F12.99','F13.90','F13.920','F13.921','F13.929','F13.930','F13.931','F13.932','F13.939','F13.94','F13.950','F13.951','F13.959','F13.96','F13.97','F13.980','F13.981','F13.982','F13.988','F13.99','F14.90','F14.920','F14.921','F14.922','F14.929','F14.93','F14.94','F14.950','F14.951','F14.959','F14.980','F14.981','F14.982','F14.988','F14.99','F15.90','F15.920','F15.921','F15.922','F15.929','F15.93','F15.94','F15.950','F15.951','F15.959','F15.980','F15.981','F15.982','F15.988','F15.99','F16.90','F16.920','F16.921','F16.929','F16.94','F16.950','F16.951','F16.959','F16.980','F16.983','F16.988','F16.99','F18.90','F18.920','F18.921','F18.929','F18.94','F18.950','F18.951','F18.959','F18.97','F18.980','F18.988','F18.99','F19.90','F19.920','F19.921','F19.922','F19.929','F19.930','F19.931','F19.932','F19.939','F19.94','F19.950','F19.951','F19.959','F19.96','F19.97','F19.980','F19.981','F19.982','F19.988','F19.99') -- SUD diagnosis codes: ICD-10 Code Series F00 to F99 
		) -- CONCLUDE ...

NARRATIVE: 
V. Population of Focus #16 DSNP ONLY

Documented Dementia Needs

Adults
	
All adults in DSNP LOB (21 yrs of age and older) who have claim diagnosis within last 12-month period

Prior diagnosis of Mild Cognitive Impairment: 
G31.84
F06.71
F06.70
F01.50
F01.51
F01.xy
F01.Ay
F01.By
F01.Cy
F02.80
F02.81
F02.xw
F02.Ay
F02.By
F02.Cy
F03.Ay
F03.By
F03.Cy
Prior diagnosis of dementia:
331
331.11
331.19
331.82
294.11







JAH 'SIR JUAN' SIR JUAN is saving the informatic POF and external POFs in that table.  According to Current status we have about 300 members without POF, mostly from external auths…which means they didn’t get a POF from Informatics. Let me know if we should meet with Juan and get the number down for that.		

SELECT ' ' AS 'ECM Unique member Count BY POF',combined.*
FROM 
( -- INITIATE ...
SELECT [TargetPopulation],COUNT(DISTINCT(memid)) AS [Unique Member Count] FROM INFORMATICS.dbo.ECMPOF_CHILD_BIRTH_EQUITY GROUP BY [TargetPopulation]

UNION 
SELECT [TargetPopulation],COUNT(DISTINCT(memid)) AS [Unique Member Count] FROM INFORMATICS.dbo.ECMPOF_CHILD_HOMELESS GROUP BY [TargetPopulation]

UNION 
SELECT [TargetPopulation],COUNT(DISTINCT(memid)) AS [Unique Member Count] FROM INFORMATICS.dbo.ECMPOF_CHILDWITHFAMILY_HOMELESS GROUP BY [TargetPopulation]

UNION 
SELECT [TargetPopulation],COUNT(DISTINCT(memid)) AS [Unique Member Count] FROM INFORMATICS.dbo.ECMPOF_CHILDWITHOUTFAMILY_HOMELESS GROUP BY [TargetPopulation]

UNION
SELECT [TargetPopulation],COUNT(DISTINCT(memid)) AS [Unique Member Count] FROM INFORMATICS.dbo.ECMPOF_CHILD_IPSNFED_HIGHUTIL GROUP BY [TargetPopulation]

UNION
SELECT [TargetPopulation],COUNT(DISTINCT(memid)) AS [Unique Member Count] FROM INFORMATICS.dbo.ECMPOF_CHILD_MHSMISUD GROUP BY [TargetPopulation]

UNION 
SELECT [TargetPopulation],COUNT(DISTINCT(memid)) AS [Unique Member Count] FROM INFORMATICS.dbo.ECMPOF_CHILD_INCARCERATION GROUP BY [TargetPopulation]	

UNION 
SELECT [TargetPopulation],COUNT(DISTINCT(memid)) AS [Uniqude Member Count] FROM INFORMATICS.dbo.ECMPOF_CHILD_CCS GROUP BY [TargetPopulation]

UNION 
SELECT [TargetPopulation],COUNT(DISTINCT(memid)) AS [Unique Member Count] FROM INFORMATICS.dbo.ECMPOF_CHILD_WELFARE GROUP BY [TargetPopulation]

UNION 
SELECT [TargetPopulation],COUNT(DISTINCT(memid)) AS [Unique Member Count] FROM INFORMATICS.dbo.ECMPOF_CHILD_IDD GROUP BY [TargetPopulation]

UNION 
SELECT [TargetPopulation],COUNT(DISTINCT(memid)) AS [Unique Member Count] FROM INFORMATICS.dbo.ECMPOF_ADULT_BIRTH_EQUITY GROUP BY [TargetPopulation]

UNION 
SELECT [TargetPopulation],COUNT(DISTINCT(memid)) AS [Unique Member Count] FROM INFORMATICS.dbo.ECMPOF_ADULT_IPSNFED_HIGHUTIL GROUP BY [TargetPopulation]

UNION
SELECT [TargetPopulation],COUNT(DISTINCT(memid)) AS [Unique Member Count] FROM INFORMATICS.dbo.ECMPOF_ADULT_MHSMISUD GROUP BY [TargetPopulation]

UNION
SELECT [TargetPopulation],COUNT(DISTINCT(memid)) AS [Unique Member Count] FROM INFORMATICS.dbo.ECMPOF_ADULT_INCARCERATION GROUP BY [TargetPopulation]

UNION 
SELECT [TargetPopulation],COUNT(DISTINCT(memid)) AS [Unique Member Count] FROM INFORMATICS.dbo.ECMPOF_ADULT_INSTITUTIONALIZATION GROUP BY [TargetPopulation]

UNION 
SELECT [TargetPopulation],COUNT(DISTINCT(memid)) AS [Unique Member Count] FROM INFORMATICS.dbo.ECMPOF_ADULT_NURSING_TRANSITION GROUP BY [TargetPopulation]

UNION 
SELECT [TargetPopulation],COUNT(DISTINCT(memid)) AS [Unique Member Count] FROM INFORMATICS.dbo.ECMPOF_ADULT_PREGNANCY_POSTPARTUM GROUP BY [TargetPopulation]

UNION 
SELECT [TargetPopulation],COUNT(DISTINCT(memid)) AS [Unique Member Count] FROM INFORMATICS.dbo.ECMPOF_ADULTWITHFAMILY_HOMELESS GROUP BY [TargetPopulation]

UNION 
SELECT [TargetPopulation],COUNT(DISTINCT(memid)) AS [Unique Member Count] FROM INFORMATICS.dbo.ECMPOF_ADULTWITHOUTFAMILY_HOMELESS GROUP BY [TargetPopulation]

UNION 
SELECT [TargetPopulation],COUNT(DISTINCT(memid)) AS [Unique Member Count] FROM INFORMATICS.dbo.ECMPOF_ADULT_IDD GROUP BY [TargetPopulation]
) -- CONCLUDE ...
AS combined

-- ============================================================================
		⏎ See codes for the following ECM POF conditions below:
-- ============================================================================
(i) Mental illness; 
	AND SUBSTRING(UPPER(LTRIM(RTRIM(ISNULL(cd.servcode,'')))),1,5) IN ('99408','99409','G0396','G0397','G0443','H0001','H0005','H0007','H0015','H0016','H0022','H0047','H0050','H2035','H2036','T1006','T1012','H0006','H0028') -- 'SMI' =  Serious Mental Illness 'SUD' = Substance Use Disorder ... AS [CPT Service Code] 

FROM HMOPROD_PlanData.dbo.memo AS mem (NOLOCK)
	JOIN
	( -- INITIATE ...
	SELECT DISTINCT ' ' AS '#BASELINE ISO MEMBERSHIP',memid
	FROM INFORMATICS.dbo.ECM_LIKE_CONTINUOUS_ENROLLMENT 
	WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ... AND ...
		AND [CONSECUTIVE MONTH(S)] = 3 -- ... enrolled as DSNP in Reporting Period 
		AND TRY_CONVERT(date,EligibilityEnd) = TRY_CONVERT(date,@ClockStop) -- ... (Continuously enrolled until the last day of the reporting period
		AND [AGE] > 21 -- ... Look for individuals greater than 21 years of age:
		) -- CONCLUDE ...
		AS isomem ON mem.memid = isomem.memid
	JOIN HMOPROD_PlanData.dbo.membermemo AS mmem (NOLOCK) ON mem.memoid = mmem.memoid
WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ... AND ...
	AND mem.memotype = 'salrt' 
	AND TRY_CONVERT(date,mem.effdate) >= @LookbackStart 
	AND TRY_CONVERT(date,mem.effdate) <= @LookbackStop	
	AND mem.codeid = 'MentalHealth' -- 'SMI (Serious Mental Illness)'
	
(ii) SUD;
WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ... AND ...
	AND alias.diag >= 'F1'
	AND alias.diag < 'F9' -- #SUDClaims 'SUD' = Substance Use Disorder

WHERE alias.diag IN ('F10.920','F10.921','F10.929','F10.930','F10.931','F10.932','F10.939','F10.94','F10.950','F10.951','F10.959','F10.96','F10.97','F10.980','F10.981','F10.982','F10.988','F10.99','F11.90','F11.920','F11.921','F11.922','F11.929','F11.93','F11.94','F11.950','F11.951','F11.959','F11.981','F11.982','F11.988','F11.99','F12.90','F12.920','F12.921','F12.922','F12.929','F12.93','F12.950','F12.951','F12.959','F12.980','F12.988','F12.99','F13.90','F13.920','F13.921','F13.929','F13.930','F13.931','F13.932','F13.939','F13.94','F13.950','F13.951','F13.959','F13.96','F13.97','F13.980','F13.981','F13.982','F13.988','F13.99','F14.90','F14.920','F14.921','F14.922','F14.929','F14.93','F14.94','F14.950','F14.951','F14.959','F14.980','F14.981','F14.982','F14.988','F14.99','F15.90','F15.920','F15.921','F15.922','F15.929','F15.93','F15.94','F15.950','F15.951','F15.959','F15.980','F15.981','F15.982','F15.988','F15.99','F16.90','F16.920','F16.921','F16.929','F16.94','F16.950','F16.951','F16.959','F16.980','F16.983','F16.988','F16.99','F18.90','F18.920','F18.921','F18.929','F18.94','F18.950','F18.951','F18.959','F18.97','F18.980','F18.988','F18.99','F19.90','F19.920','F19.921','F19.922','F19.929','F19.930','F19.931','F19.932','F19.939','F19.94','F19.950','F19.951','F19.959','F19.96','F19.97','F19.980','F19.981','F19.982','F19.988','F19.99') -- SUD Substance Use Disorder diagnosis codes: ICD-10 Code Series F00 to F99 

(iii) Chronic Condition/Significant Non-Chronic Clinical Condition; 
WHERE alias.diag LIKE 'E08%'
	OR alias.diag LIKE 'E09%'
	OR alias.diag LIKE 'E10%'
	OR alias.diag LIKE 'E11%'
	OR alias.diag LIKE 'E12%'
	OR alias.diag LIKE 'E13%'
	OR alias.diag LIKE 'K73%' -- #ChronicCondClaims

(iv) Intellectual or Developmental Disability (I/DD); 
WHERE alias.diag >= 'F7'
	AND alias.diag < 'F8' -- #IntellectualDisClaims

WHERE alias.diag >= 'F8'
	AND alias.diag < 'F9' -- #DevelopmentalDisClaims
	
	AND alias.diag IN ('F22','F23','F24','F28','F29','F32.3','F33.3','F70','F71','F72','F73','F78','F78.A1','F78.A9','F79','F80.0','F80.1','F80.2','F80.4','F80.81','F80.82','F80.89','F80.9','F81.0','F81.2','F81.81','F81.89','F81.9','F82','F84','F84.0','F84.0','F84.0','F84.2','F84.2','F84.3','F84.3','F84.3','F84.5','F84.5','F84.8','F84.8','F84.8','F84.9','F84.9','F84.9','F88','F89','F90.0','F90.1','F90.2','F90.8','F90.9','F91.0','F91.1','F91.2','F91.3','F91.8','F91.9','F93.0','F93.8','F93.9','F94.0','F94.1','F94.2','F94.8','F94.9','F95.0','F95.0','F95.1','F95.1','F95.2','F95.2','F95.8','F95.8','F95.9','F95.9','F98.0','F98.1','F98.21','F98.29','F98.3','F98.4','F98.5','F98.8','F98.9','F99','Q90','Q90.0','Q90.1','Q90.2','Q90.9','Q91.0','Q91.1','Q91.2','Q91.3','Q91.4','Q91.5','Q91.6','Q91.7','Q92','Q93','Q93.0','Q93.1','Q93.2','Q93.3','Q93.4','Q93.5','Q93.51','Q93.59','Q93.7','Q93.8','Q93.81','Q93.82','Q93.88','Q93.89','Q93.9','Q99.2') -- ...who have a diagnosis of I/DD Use the following ICD-10 diagnosis codes: Lookback period 12 months	

(v) Traumatic Brain Injury (TBI); 
WHERE alias.diag >= 'S06'
	AND alias.diag < 'S07' -- #BrainInjClaims

(vi) HIV/AIDS; 
WHERE alias.diag >= 'B20'
	AND alias.diag < 'B25' -- #HIVClaims

(vii) Pregnant or Postpartum.
WHERE alias.diag >= 'Z32'
	AND alias.diag < 'Z40' -- #PregnancyClaims

	WHERE alias.diag BETWEEN 'O00.00' AND 'O99.891'
	OR alias.diag BETWEEN 'O9A.111' AND 'O9A.519'
	OR alias.diag BETWEEN 'Z03.71' AND 'Z03.79'
	OR alias.diag IN ('Z32.01')
	OR alias.diag BETWEEN 'Z33.1' AND 'Z33.3'
	OR alias.diag BETWEEN 'Z34.00' AND 'Z34.93'
	OR alias.diag BETWEEN 'Z36.0' AND 'Z36.9'
	OR alias.diag IN ('Z36.8A')
	OR alias.diag BETWEEN 'Z39.1' AND 'Z39.2'
	) -- CONCLUDE ...

		( -- INITIATE ...
	SUBSTRING(UPPER(LTRIM(RTRIM(ISNULL(cd.servcode,'')))),1,5) IN ('59400','59410','59425','59426','59510','59515','59610','59614','59618','59622','57170','58300','59430')
		OR SUBSTRING(UPPER(LTRIM(RTRIM(ISNULL(cd.servcode,'')))),1,5) BETWEEN '99201' AND '99205'
		OR SUBSTRING(UPPER(LTRIM(RTRIM(ISNULL(cd.servcode,'')))),1,5) BETWEEN '99211' AND '99215'
		OR SUBSTRING(UPPER(LTRIM(RTRIM(ISNULL(cd.servcode,'')))),1,5)BETWEEN '99241' AND '99245'
		OR SUBSTRING(UPPER(LTRIM(RTRIM(ISNULL(cd.servcode,'')))),1,5) IN ('99483','99501','G0101 G0463','H1005','T1015') -- ... AS [CPT Service Code] 
		) -- CONCLUDE ...

(viii) MISC:
WHERE alias.diag IN ('Z65.1','Z65.2','Z65.3','Z65.4','Z65.5','Z65.8','Z65.9') -- #IncarcerationClaims

	AND UPPER(LTRIM(RTRIM(ISNULL(ma.thevalue,'IGNORE')))) IN ('G5','G6','G7','G8','4K','N7','N8','N0','F3','F4','G3','G4') -- = 'YES' ... transitioning from incarceration [AIDCODE]

UPPER(LTRIM(RTRIM(ISNULL(ma.thevalue,'IGNORE')))) IN ('2P','2R','2S','2T','2U','4E','4M','4T','46','5K','5L','03','04 06 07','4A')  -- WELFARE Kids in foster care use the following aid codes  +'03' +California Adoption Assistance Program aid codes:

-- =====================================================================
    -- DECLARE @PARAMETER(S) / @FILTER(S) --
-- =====================================================================
DECLARE @ClockStart AS date
DECLARE @ClockStop AS date

SET @ClockStart = TRY_CONVERT(date,'01/01/2024')
SET @ClockStop = TRY_CONVERT(date,'03/31/2024')

DECLARE @LookbackStart date = DATEADD(mm,-12,@ClockStop)
DECLARE @LookbackStop date = @ClockStop
DECLARE @AgeSetDate date = @ClockStop
DECLARE @AgeCutoff int = 21
DECLARE @PCPrecordRANK AS int = 1 -- ENTER 1 TO GET() JUST MOST CURRENT [RANKis] see DENSE_RANK() OVER(PARTITION BY ek.memid ORDER BY CAST(ek.effdate AS datetime) DESC) AS [RANKis] --'RANKis' --RANK by MOST CURRENT

		SELECT TOP 1 ' ' AS 'CHECK ON REMOVAL OF -- C001: ...',@AgeCutoff AS [AGE LIMIT >= (GREATER THAN EQUAL TO)],@AgeSetDate AS [RunDate],'BETWEEN '+CAST(CAST(@LookbackStart AS date) AS varchar(MAX))+' AND '+CAST(CAST(@LookbackStop AS date) AS varchar(MAX)) AS [LOOKBACK RANGE NOTE(s)]

SELECT DISTINCT ' ' AS 'AND ... Any other diagnosis (physical, behavioral or developmental).',c.memid
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st',
FROM HMOPROD_PlanData.dbo.claim AS c (NOLOCK)
	JOIN INFORMATICS.dbo.WC_ECM_LIKE_CONTINUOUS_ENROLLMENT AS isomem ON c.memid = isomem.memid

	JOIN 
	( -- INITIATE ...
	SELECT DISTINCT ' ' AS 'LTC POPULATION',ek.memid
	FROM HMOPROD_PLANDATA.dbo.enrollkeys AS ek
		JOIN HMOPROD_PLANDATA.dbo.enrollcoverage AS ec on ek.enrollid = ec.enrollid
	WHERE 1=1 AND ec.ratecode LIKE '%LTC%'
	) -- CONCLUDE ...
	AS ltc ON c.memid = ltc.memid 

	JOIN HMOPROD_PlanData.dbo.claimdetail AS cd (NOLOCK) ON c.claimid = cd.claimid  
	JOIN 
	( -- INITIATE ...
	SELECT DISTINCT *
	-- INTO #prindiag
	-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
	-- SELECT DISTINCT ' ' AS 'CHECK 1st',
	FROM 
	( -- INITIATE ...
	SELECT aliassetup.*,DENSE_RANK() OVER (PARTITION BY aliassetup.claimid ORDER BY aliassetup.sequence ASC,aliassetup.codeid DESC) AS [RANKis]
	-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
	-- SELECT DISTINCT ' ' AS 'CHECK 1st',
	FROM 
	( -- INITIATE ...
	SELECT DISTINCT dx.claimid,dx.codeid,UPPER(LTRIM(RTRIM(ISNULL(dx.codeid,'')))) AS [diag],ISNULL(dc.DESCRIPTION,'') AS [diag descr],dx.sequence,dx.poa AS 'PRESENT ON ADMISSION'
	-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
	-- SELECT DISTINCT ' ' AS 'CHECK 1st',
	FROM HMOPROD_PLANDATA.dbo.claimdiag AS dx
		LEFT JOIN HMOPROD_PLANDATA.dbo.DiagCode AS dc ON dx.codeid = dc.codeid
	) -- CONCLUDE
	AS aliassetup
	) -- CONCLUDE
	AS alias
	-- WHERE alias.sequence = 1 -- BETWEEN 1 AND 9	
		-- AND alias.[RANKis] = 1
WHERE alias.diag >= 'B20'
	AND alias.diag < 'B25' -- #HIVClaims
		OR alias.diag IN ('F10.920','F10.921','F10.929','F10.930','F10.931','F10.932','F10.939','F10.94','F10.950','F10.951','F10.959','F10.96','F10.97','F10.980','F10.981','F10.982','F10.988','F10.99','F11.90','F11.920','F11.921','F11.922','F11.929','F11.93','F11.94','F11.950','F11.951','F11.959','F11.981','F11.982','F11.988','F11.99','F12.90','F12.920','F12.921','F12.922','F12.929','F12.93','F12.950','F12.951','F12.959','F12.980','F12.988','F12.99','F13.90','F13.920','F13.921','F13.929','F13.930','F13.931','F13.932','F13.939','F13.94','F13.950','F13.951','F13.959','F13.96','F13.97','F13.980','F13.981','F13.982','F13.988','F13.99','F14.90','F14.920','F14.921','F14.922','F14.929','F14.93','F14.94','F14.950','F14.951','F14.959','F14.980','F14.981','F14.982','F14.988','F14.99','F15.90','F15.920','F15.921','F15.922','F15.929','F15.93','F15.94','F15.950','F15.951','F15.959','F15.980','F15.981','F15.982','F15.988','F15.99','F16.90','F16.920','F16.921','F16.929','F16.94','F16.950','F16.951','F16.959','F16.980','F16.983','F16.988','F16.99','F18.90','F18.920','F18.921','F18.929','F18.94','F18.950','F18.951','F18.959','F18.97','F18.980','F18.988','F18.99','F19.90','F19.920','F19.921','F19.922','F19.929','F19.930','F19.931','F19.932','F19.939','F19.94','F19.950','F19.951','F19.959','F19.96','F19.97','F19.980','F19.981','F19.982','F19.988','F19.99') -- SUD diagnosis codes: ICD-10 Code Series F00 to F99 
	) -- CONCLUDE ...
	AS cdx ON c.claimid = cdx.claimid
WHERE c.startdate >= @LookbackStart 
	AND c.startdate <= @LookbackStop
	AND 
	( -- INITIATE ...
		c.resubclaimid IS NULL 
		OR 
		c.resubclaimid = ''
	) -- CONCLUDE ...
	AND c.claimid NOT LIKE '%R%' -- NO NOT NEGATIVE != <>
	AND c.[status] in ('ADJUCATED', 'PAID', 'PAY', 'REV', 'REVERSED', 'REVSYNCH')
	AND cd.[status] NOT IN ('DENY','VOID') -- NO NOT NEGATIVE != 

SELECT DISTINCT ' ' AS 'AND ... Any other diagnosis (physical, behavioral or developmental).',c.memid
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st',
FROM HMOPROD_PlanData.dbo.claim AS c (NOLOCK)
	JOIN INFORMATICS.dbo.WC_ECM_LIKE_CONTINUOUS_ENROLLMENT AS isomem ON c.memid = isomem.memid

	JOIN 
	( -- INITIATE ...
	SELECT DISTINCT ' ' AS 'LTC POPULATION',ek.memid
	FROM HMOPROD_PLANDATA.dbo.enrollkeys AS ek
		JOIN HMOPROD_PLANDATA.dbo.enrollcoverage AS ec on ek.enrollid = ec.enrollid
	WHERE 1=1 AND ec.ratecode LIKE '%LTC%'
	) -- CONCLUDE ...
	AS ltc ON c.memid = ltc.memid

	JOIN HMOPROD_PlanData.dbo.claimdetail AS cd (NOLOCK) ON c.claimid = cd.claimid  
	JOIN HMOPROD_PlanData.dbo.affiliation AS a (NOLOCK) ON c.affiliationid = a.affiliationid
		LEFT JOIN HMOPROD_PLANDATA.dbo.svccode AS sc ON cd.servcode = sc.codeid
WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ... AND ...
	AND c.startdate >= @LookbackStart 
	AND c.startdate <= @LookbackStop
	AND 
	(
		c.resubclaimid IS NULL 
		OR 
		c.resubclaimid = ''
	)
	AND c.claimid NOT LIKE '%R%' -- NO NOT NEGATIVE != <>
	AND c.[status] IN ('ADJUCATED','PAID','PAY','REV','REVERSED','REVSYNCH')
	AND cd.[status] NOT IN ('DENY','VOID') -- NO NOT NEGATIVE != 
	AND SUBSTRING(UPPER(LTRIM(RTRIM(ISNULL(cd.servcode,'')))),1,5) IN ('99408','99409','G0396','G0397','G0443','H0001','H0005','H0007','H0015','H0016','H0022','H0047','H0050','H2035','H2036','T1006','T1012','H0006','H0028') -- 'SMI' =  Serious Mental Illness 'SUD' = Substance Use Disorder ... AS [CPT Service Code] 

		-- SELECT * FROM #MHSMISUDClaims
		






-- =====================================================
	-- MULTI - [db] DATABASE OBJECT SEARCH TEMPLATE: 
-- =====================================================
DECLARE @SearchText NVARCHAR(MAX) = 'ECMPOFPCP'; -- Text to search for DEANumber, CONTRACTING_, primarystatus, uvw_JusticeInvolvedIndicator, Marketer, Grievance, paid, LTCFacilityType, % Vari, ReportingCounts
DECLARE @ExactMatchST BIT = 0; -- SET AS 1 WHEN NULL OR FOR an exact match ON @PARAM
DECLARE @ObjectName NVARCHAR(MAX) = 'ECMPOFPCP'; -- Keep broad for object names
DECLARE @ExactMatchON BIT = 0; -- SET AS 1 WHEN NULL OR FOR an exact match ON @PARAM
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
	('INFORMATICS'), -- WORKING [db]
	--('HMOPROD_PQCSIDB'), -- QNXT 'User'
	--('HMOPROD_PLANDATA'), -- QNXT [db]
	--('EnrollmentManager'), -- 834 MEMBERSHIP
	--('FINCHG'), -- FINANCE DEPT.	
	--('CareHub'), -- MIGRATION FROM [MemberPortal]
	('MemberPortal'),
	('ProviderPortal'),
	('CHGAPP_PROD'),	
	--('evips_chgcv'), -- SERVER: SQLPRODAPP01 PROVIDER NETWORK SOURCE DATA
	--('ProviderRepository'), -- SERVER: SQLPRODAPP01 REPO
	('INFOAG'), -- SERVER: SQLPRODAPP01 LINKED SERVER TO SQLPROD02.INFORMATICS [db]
	('QPROD'),
	('DATAWAREHOUSE'), -- LEGACY DW
	('INFORMATICS2'), -- SQLPROD01.QPROD
	('DIAMOND_Data'),  -- LEGACY SYSTEM (D950) ... 
	('dataprep'),  -- LEGACY STAGING ... 	
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
	AND ObjectType IN ('SQL_STORED_PROCEDURE') -- ,'VIEW','SQL_SCALAR_FUNCTION','SQL_TABLE_VALUED_FUNCTION','BASE TABLE') -- ASSESS ObjectType(s) ...
	-- AND ObjectName LIKE ISNULL('%'+@ObjectName+'%','%') 
	-- AND ColumnName LIKE ISNULL('%'+@SearchText+'%','%')  
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
	AND SchemaName = 'EcmJson' AND ResultType != 'ERROR'
ORDER BY ResultType, ObjectName, ColumnName; */

-- DROP TABLE IF EXISTS #SearchResults; -- POWER CYCLE RESET REFRESH RESTART ...







JAH 'ECM POF'
x AND AN 'ECM / CS'AUTHORIZATION AGING REPORT 
		30 / 60 / 90 DAY(S)
		
		⏎ ACT AS a Senior Data Analyst WITH 20+ years of EXPERIENCE. IN THE VOICE OF Robert F Smith,CEO OF VISTA EQUITY. PLEASE ASSIST IN GENERATING AN EXECUTIVE SUMMARY explaining how the ECM JI (Justice Involved) POF (Population of Focus) is presently being pulled for each age category. ,LEVERAGE the attached CODE provided FOR CONTEXT
				see "ECMPOF_ADULT_INCARCERATION_20250429.sql" AND "ECMPOF_CHILD_INCARCERATION_20250429.sql"

FYI Young Lady, related to the ECM POF (Justice Involved) context here is the logic I am currently deploying (have likewise attached the scripts should you be so inclined):

Extraction Methodology: ECM Justice-Involved Population of Focus (POF) – Age-Based Data Capture Strategy
________________________________________
Architecture: From Indicator to Action
1. Core Identification Source: uvw_JusticeInvolvedIndicator View
This view serves as the data linchpin that operationalizes the JI indicator from EnrollmentManager, joining across:
		•	Member & File (for the JusticeInvolvedIndicator = 'J')
		•	MemberOverlay (to ensure current FileId alignment)
		•	HealthCoverage & HealthCoverageOverlay (to tie eligibility periods to member-level data)
		•	HcpStatusCode (to bring in the status semantics)

		The result is a unique memid set extracted via ClientIndexNumber matching CIN in uvw_BASELINE_MEMBERSHIP. The output is curated to only include records where:
		•	JusticeInvolvedIndicator = 'J'
		•	Coverage period integrity is enforced: BenefitBeginDate ≤ BenefitEndDate

This serves as the foundation for identifying all JI-flagged members within the current reporting cycle.
________________________________________
2. Downstream Age-Based Segmentation
From this view, two age-based procedures bifurcate the workflow:

		A. Adults (≥21) – sp_ECMPOF_ADULTINCARCERATION
				•	Filters the #JI population where member age ≥ 21
				•	Applies an expanded eligibility logic, leveraging both:
						o	Diagnosis-based incarceration proxies (e.g., Z65.1–Z65.9, chronic conditions, SUDs, brain injuries)
						o	AID Code Mapping (memberattribute → values like 'G5', 'N7', etc.)

				•	Members must be:
						o	Enrolled in Medi-Cal
						o	Not already enrolled in ECM (via ProviderPortal.ecm.MembersInformation)

				•	Results populate ECMPOF_ADULT_INCARCERATION

		B. Children (<21) – sp_ECMPOF_CHILDINCARCERATION
				•	Filters the #JI population where member age < 21
				•	Relies strictly on uvw_JusticeInvolvedIndicator + valid AID codes for population qualification
				•	Results populate ECMPOF_CHILD_INCARCERATION
	
	
	
	
	
	
	
JAH 'JI (JUSTICE INVOLED) = INCARCERATION'
SELECT TOP 10  ' ' AS 'ECM POF: JUSTICED INVOLVED (JI) FORMERLY INCARCERATION...',JusticeInvolvedIndicator,* FROM EnrollmentManager.dbo.[Member] AS mb (NOLOCK) -- From: Avina Patel <apatel@chgsd.com> Sent: Wednesday, November 20, 2024 3:38 PM To: Kathryn Madrid <kmadrid@chgsd.com>; Adam Hancock <AHanco@chgsd.com>; Sushanthi Pediredla <scetty@chgsd.com> Cc: Walter Carr <WCarr@chgsd.com> Subject: RE: Question: Justice Involved in 834? Hi Kathryn, The justice involved indicator is in the member table in EnrollmentManager, but so far we have not received any members that have the indicator, so there are currently no values. Thank you, Avina

SELECT DISTINCT JusticeInvolvedIndicator FROM EnrollmentManager.dbo.[Member] AS mb (NOLOCK) -- From: Avina Patel <apatel@chgsd.com> Sent: Wednesday, November 20, 2024 3:38 PM To: Kathryn Madrid <kmadrid@chgsd.com>; Adam Hancock <AHanco@chgsd.com>; Sushanthi Pediredla <scetty@chgsd.com> Cc: Walter Carr <WCarr@chgsd.com> Subject: RE: Question: Justice Involved in 834? Hi Kathryn, The justice involved indicator is in the member table in EnrollmentManager, but so far we have not received any members that have the indicator, so there are currently no values. Thank you, Avina

SELECT * FROM INFORMATICS.dbo.ECMPOF_ADULT_INCARCERATION
SELECT * FROM INFORMATICS.dbo.ECMPOF_CHILD_INCARCERATION

-- SELECT TOP 10 * FROM INFORMATICS.dbo.uvw_BASELINE_MEMBERSHIP

SELECT ' ' AS 'ECM POF: JUSTICED INVOLVED (JI) FORMERLY INCARCERATION: ',bm.*
FROM INFORMATICS.dbo.uvw_BASELINE_MEMBERSHIP AS bm
	JOIN EnrollmentManager.dbo.[Member] AS mb ON bm.CIN = SUBSTRING(UPPER(LTRIM(RTRIM(ISNULL(mb.ClientIndexNumber,'')))),1,9)
WHERE 1=1
	AND mb.JusticeInvolvedIndicator IN ('J')

		USE http://devops01:8080/IS/_git/Informatics?path=%2FECM%20POF%20Counts%2FECM%20POF%20JI%20JUSTICE%20INVOLVED.sql&version=GBMain - 'REPO'

	JOIN 
	( -- INITIATE ...
	SELECT DISTINCT ' ' AS 'ECM POF: JUSTICED INVOLVED (JI) FORMERLY INCARCERATION: ',bm.memid
	FROM INFORMATICS.dbo.uvw_BASELINE_MEMBERSHIP AS bm
		JOIN EnrollmentManager.dbo.[Member] AS mb ON bm.CIN = SUBSTRING(UPPER(LTRIM(RTRIM(ISNULL(mb.ClientIndexNumber,'')))),1,9)
	WHERE 1=1
		AND mb.JusticeInvolvedIndicator IN ('J')
	) -- CONCLUDE ...
	AS iso ON mm.memid = iso.memid
	
-- =====================================================
	-- MULTI-DATABASE OBJECT SEARCH TEMPLATE: -- 
-- =====================================================
DECLARE @SearchText NVARCHAR(255) = 'JusticeInvolvedIndicator';  -- Text to search for DEANumber, CONTRACTING_, primarystatus
DECLARE @ExactMatchST BIT = 0;                        -- SET AS 1 for exact matches AND NULL @PARAM
DECLARE @ObjectName NVARCHAR(255) = NULL;             -- Specific object name to search for (optional)
DECLARE @ExactMatchON BIT = 1;                        -- SET AS 1 FOR exact object name matches AND NULL @PARAM
DECLARE @SchemaName NVARCHAR(128) = NULL;             -- Limit search to specific schema (optional)
DECLARE @ObjectType NVARCHAR(128) = NULL;             -- Limit to specific object type (optional)
DECLARE @IncludeSystemObjects BIT = 0;                -- Set to 1 to include system objects

	-- Define databases to search (add or remove as needed)
DECLARE @DatabaseList TABLE (DatabaseName NVARCHAR(128))
INSERT INTO @DatabaseList (DatabaseName)
VALUES 
    --('INFORMATICS'), -- WORKING [db]
    --('HMOPROD_PLANDATA'), -- QNXT [db]
    ('EnrollmentManager') -- 834 MEMBERSHIP
 --   ('ProviderPortal'),
	--('evips_chgcv'), -- SERVER: SQLPRODAPP01 PROVIDER NETWORK SOURCE DATA
 --   ('ProviderReporsitory'), -- SERVER: SQLPRODAPP01 REPO
	--('INFOAG'), -- SERVER: SQLPRODAPP01 LINKED SERVER TO SQLPROD02.INFORMATICS [db]
	--('QPROD'),
 --   ('DATAWAREHOUSE'), -- LEGACY DW
 --   ('INFORMATICS2'), -- SQLPROD01.QPROD
 --   ('DIAMOND_Data');  -- LEGACY SYSTEM (D950) ... 

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







JAH 'ECM WEEKLY'
x HI Walter,

My providerportal tables won’t be in production until tonight 😊 Adding @Adam Hancock and @Avina Patel – do you know where the JI field reference is in the 834 data?

Thanks,
Kathryn

x Provider types: Tables:  providerportal.[ECM].[ProviderTypes], [ECM].[ProviderTypesResponses]
 
JI data: providerportal.[ECM].[ServiceTypes], providerportal.[ECM].[ProviderServiceTypeResponses]

JAH UPDATE 'ECM POF' HOMELESS
x 'eMAIL' ON 20240708 - Hello Walter (and Kathryn),

x 'TEAMS'
[Wednesday 3:33 PM] Kathryn Madrid
		Provider types: Tables:  [ECM].[ProviderTypes], [ECM].[ProviderTypesResponses]
		 
		JI data: [ECM].[ServiceTypes], [ECM].[ProviderServiceTypeResponses]
 
[Wednesday 3:33 PM] Walter Carr
Thank you Young Lady
 like 1
 
[Wednesday 3:33 PM] Kathryn Madrid
currently only in qa02

We’ve made updates to the PoF Narrative. This impacted a total of 5 PoFs. The updates are highlighted in the attached document and summarized below:

		1.	Added to Individuals Transitioning from Incarceration
				a.	Population of Focus #8 ADULTS 21+ 
						i.	Look for JUSTICE INVOLVED code (J) in the 834.  If the JI code (J) is present on the 834 file then mark the member eligible for this PoF.
				b.	Population of Focus #9 CHILDREN/YOUTH (under 21) 
						i.	Look for JUSTICE INVOLVED code (J) in the 834.  If the JI code (J) is present on the 834 file then mark the member eligible for this PoF.

		2.	Added to Individuals Experiencing Homelessness. 
				a.	Population of Focus #1 ADULTS 21+ (Adults without Dependent Children/Youth Living with them experiencing homelessness and have at least one complex physical, behavioral, or developmental health need)
						i.	(New HMIS data Source) Members who are on HMIS homeless member data base who have not exited the program.  If there is no project exit date then include these members in this population.
				b.	Population of Focus #2 ADULTS 21+ ( Homeless Families or Unaccompanied Children and Youth Experiencing Homelessness)  
						i.	(New HMIS data Source) Members who are on HMIS homeless member data base who have not exited the program.  If there is no project exit date then include these members in this population.
				c.	Population of Focus #3 CHILDREN/YOUTH under 21 ( Homeless Families or Unaccompanied Children and Youth Experiencing Homelessness)  
						i.	(New HMIS data Source) Members who are on HMIS homeless member data base who have not exited the program.  If there is no project exit date then include these members in this population.

Context on HMIS Data- every month the EDI team helps us with a report we receive from Regional Task Force on Homelessness’ HMIS data. This report captures our Members currently experiencing homelessness AND those that were permanently housed. Those that have been permanently housed we are defining as containing a “project exit date” at least that’s the way the report appears for us in the attached and should NOT be identified as ECM Eligible. Your view might look different. Please work with the EDI team, if needed, to interpret the original data source. 

From the EDI Team:
The data is stored in two tables:
		1.	The data: CHGAPP_PROD.dbo.tblEDIHMISData
		2.	The contact data for the members: CHGAPP_PROD.dbo.tblEDIHMISContact
		
				SELECT TOP 10 * FROM CHGAPP_PROD.dbo.tblEDIHMISData
				SELECT TOP 10 * FROM CHGAPP_PROD.dbo.tblEDIHMISContact

If we think we need to pull in EDI team and have them join our Thursday meeting, Edwin is the best POC. 

Thanks, 
Claudia Velasquez, BSW
ECM/CS Manager 
2420 Fenton Street, Suite 100
Chula Vista, CA 91914
T: (619) 271-2257
F: (866) 897-6024
 
*For inpatient team assistance after hours, weekend, and on holidays, please call (800)224-7766 to reach the on-call nurse for help with authorizations and discharge needs.
 
*Confidentiality Notice: This e-mail (including attachments), is covered by the Electronic Communications Privacy Act, 18 U.S.C. 2510-2521, is confidential, and may be legally privileged. If you are not the intended recipient, you are hereby notified that any retention, dissemination, distribution, or copying of this communication is strictly prohibited. Please reply to the sender that you have received a message in error, then delete it. Thank you.

-- =============================================================
	-- HHIP (Housing and Homelessness Incentive Program)  HOMELESS --
-- =============================================================
-- =============================================================
	-- HMIS Homeless Management Information System --
-- =============================================================
-- =====================================================================
	-- DECLARE @PARAMETER(S) / @FILTER(S) --
-- =====================================================================
DECLARE @FileId AS int
-- DECLARE @ClockStart AS datetime
-- DECLARE @ClockStop AS datetime

SET @FileId = (SELECT MAX(f.FileId) AS FileId FROM CHGAPP_PROD.dbo.tblEDIProcessedFile AS f JOIN CHGAPP_PROD.dbo.tblEDIHMISData AS d ON d.FileId = f.FileId) -- 574292 -- 507847
-- SET @ClockStart = TRY_CONVERT(date,'07/01/2023')
-- SET @ClockStop = TRY_CONVERT(date,'12/31/2023')

		SELECT DISTINCT ' ' AS 'DETERMINE [FileID] OPTION: '
		-- , 'BETWEEN '+CAST(CAST(@ClockStart AS date) AS varchar (25))+' AND '+CAST(CAST(@ClockStop AS date) AS varchar (25)) AS [RANGE NOTE(s)]
		,@FileId AS [FILE IN USE]
		,fid.*
		FROM 
		( -- INITIATE ...
		SELECT CAST(STUFF(STUFF(RTRIM(RIGHT(LEFT(f.FileName, PATINDEX('%[_][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]%', f.FileName)-1),8)),5,0,'/'),3, 0, '/') AS DATE) AS [FileMonth]
		,f.* 
		FROM CHGAPP_PROD.dbo.tblEDIProcessedFile AS f
			JOIN CHGAPP_PROD.dbo.tblEDIHMISData AS d ON d.FileId = f.FileId
		) -- CONCLUDE ...
		AS fid
		WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ... AND ... 
			AND fid.Fileid IN (@FileId)
			-- AND TRY_CONVERT(date,fid.[FileMonth]) BETWEEN @ClockStart AND @ClockStop;

		SELECT TOP 10 ' ' AS 'SAMPLE: HMIS = A Homeless Management Information System DATASET',* FROM CHGAPP_PROD.dbo.tblEDIHMISData WHERE 1=1 AND Fileid IN (@FileId)
		SELECT TOP 10 ' ' AS 'SAMPLE: HMIS = A Homeless Management Information System CONTACT DATA',* FROM CHGAPP_PROD.dbo.tblEDIHMISContact WHERE 1=1 AND Fileid IN (@FileId)
		






--------------------------------------------------------------------------------------------------------------------
-- Error Trapping: Check If Permanent Table(s) Already Exist(s) And Drop If Applicable --
--------------------------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS #HMIS; -- SQL Server 2016 and later -- DYNAMIC tmp OR STATIC [TABLE] #TableName is a local temporary table visible only IN the current session; ##TableName is a GLOBAL temporary table visible to all sessions IN ('TempDB')

	-- CTE for HMIS data
WITH hmis AS (
SELECT ' ' AS 'HMIS Homeless Management Information System FROM SIR EDWIN',
	f.[FileName],
	d.*,
	CAST(STUFF(STUFF(RTRIM(RIGHT(LEFT(f.FileName, PATINDEX('%[_][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]%', f.FileName)-1),8)),5,0,'/'),3, 0, '/') AS DATE) AS [FileMonth]
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM CHGAPP_PROD.dbo.tblEDIProcessedFile AS f
	JOIN CHGAPP_PROD.dbo.tblEDIHMISData AS d ON d.FileId = f.FileId
WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ... AND ... 
	AND [Project Exit Date] IS NULL 	-- C000: ADJUSTMENT per eMAIL ON 20240708 FROM MS CLAUDIA (SUBJECT: Updates to ECM Pof Narrative)- ... i.	(New HMIS data Source) Members who are on HMIS homeless member data base who have not exited the program.  If there is no project exit date then include these members in this population.
),

	-- CTE for QNXT data
qnxt_data AS (
SELECT DISTINCT m.memid, 
m.fullname, 
m.dob, 
m.secondaryid, 
m.issubscriber, 
m.[status], 
m.ssn AS QnxtSSN, 
ent.firstname, 
ent.middlename, 
ent.lastname
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM HMOPROD_PlanData.dbo.member AS m
	JOIN HMOPROD_PlanData.dbo.entity AS ent ON ent.entid = m.entityid
	JOIN HMOPROD_PlanData.dbo.enrollkeys AS ek ON ek.memid = m.memid
WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ... AND ... 
	AND m.issubscriber = 'Y'
	AND m.[status] = 'Active'
	AND ek.segtype = 'INT'
	AND CAST(ek.termdate AS date) > CAST(ek.effdate AS date) -- MUST BE TRUE ... NON-CROSSFOOTED RECORDS ARE ACTIVE ...
),

	-- CTE for SSN matching
ssn_qnxt_match AS (
SELECT DISTINCT 'SSN' AS MatchType, 
	m.*, 
	hmis.*
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM qnxt_data AS m
	JOIN hmis ON REPLACE(REPLACE(hmis.SSN, '-',''), ' ', '') = m.QnxtSSN COLLATE DATABASE_DEFAULT
WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ... AND ... 
	AND m.QnxtSSN IS NOT NULL 
	AND m.QnxtSSN <> '' 
	AND m.QnxtSSN <> '000000000'
),

	-- CTE for Name and DOB matching
name_dob_qnxt_match AS (
SELECT DISTINCT 'NameDOB' AS MatchType, 
	m.*, 
	hmis.*
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM qnxt_data AS m
	JOIN hmis ON hmis.[Last Name] = m.lastname COLLATE DATABASE_DEFAULT
		AND hmis.[First Name] = m.firstname COLLATE DATABASE_DEFAULT
		AND CAST(hmis.[Date of Birth Date] AS DATE) = CAST(m.dob AS DATE)
WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ... AND ... 
	AND m.dob IS NOT NULL
	AND hmis.[Date of Birth Date] IS NOT NULL 
	AND hmis.[Date of Birth Date] <> ''
	AND NOT EXISTS (
		SELECT 1 
		FROM ssn_qnxt_match 
		WHERE ssn_qnxt_match.memid = m.memid
	)
),

	-- CTE for combined matched data
hmis_matched_data AS (
SELECT * FROM ssn_qnxt_match

UNION ALL
SELECT * FROM name_dob_qnxt_match
)

	-- Final SELECT into temp table
SELECT 'Homeless Management Information System (HMIS)' AS [HCx],
    *
INTO #HMIS
FROM hmis_matched_data AS hmd
WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ... AND ... 
    AND hmd.FileId = @FileId
    -- AND TRY_CONVERT(date, hmd.[FileMonth]) BETWEEN @ClockStart AND @ClockStop;

	-- Summary statistics
		SELECT MatchType,
		COUNT(DISTINCT(memid)) AS [Unique HMIS memid],
		COUNT(DISTINCT(QnxtSSN)) AS [Unique QNXTssn Match] 
		FROM #HMIS 
		GROUP BY MatchType;

		-- SELECT TOP 1 * FROM #HMIS;







SELECT TOP 10 'Look for JUSTICE INVOLVED code (J) in the 834.  If the JI code (J) is present on the 834 file then mark the member eligible for this PoF.' AS 'MESSAGE(S)',* FROM providerportal.[ECM].[ProviderTypes]
SELECT TOP 10 'Look for JUSTICE INVOLVED code (J) in the 834.  If the JI code (J) is present on the 834 file then mark the member eligible for this PoF.' AS 'MESSAGE(S)',* FROM providerportal.[ECM].[ProviderTypesResponses]
SELECT TOP 10 'Look for JUSTICE INVOLVED code (J) in the 834.  If the JI code (J) is present on the 834 file then mark the member eligible for this PoF.' AS 'MESSAGE(S)',* FROM providerportal.[ECM].[ServiceTypes]
SELECT TOP 10 'Look for JUSTICE INVOLVED code (J) in the 834.  If the JI code (J) is present on the 834 file then mark the member eligible for this PoF.' AS 'MESSAGE(S)',* FROM providerportal.[ECM].[ProviderServiceTypeResponses]

		-- 834 Files
SELECT 'TABLE: [FILE] - 834 METADATA UPLOAD Tx' AS [NOTE(S)],* FROM EnrollmentManager.dbo.[FILE] ORDER BY MedsExtractionDate DESC -- FileType: Monthly vs Daily
SELECT DISTINCT 'TABLE: [FILE] - 834 METADATA UPLOAD Tx' AS [NOTE(S)],FileType FROM EnrollmentManager.dbo.[FILE]

		-- Member info
SELECT 'TABLE: [member] - MEMBER HEADER DATA see MedsId AS [SSN],LastName,FirstName,DEMO DATA ... IGNORE [AidCode] FIELD FOR [CapitationAidCode] IN [healthcoverage] TABLE' AS [NOTE(S)],* FROM EnrollmentManager.dbo.[Member] WHERE ClientIndexNumber IN ('90660335E','91447624A') -- AND fileid='169'
SELECT 'TABLE: [MemberOverlay] - IDENTIFY [RowIsCurrent] = MAX([FileId]) FOR GIVEN [CIN]' AS [NOTE(S)],* FROM EnrollmentManager.dbo.MemberOverlay WHERE ClientIndexNumber IN ('90660335E','91447624A')
SELECT 'TABLE: [HealthCoverage] - DETAIL' AS [NOTE(S)],* FROM EnrollmentManager.dbo.[HealthCoverage]  WHERE ClientIndexNumber IN ('90660335E','91447624A') -- AND fileid='169' and benefitbegindate='2020-01-01'
SELECT 'TABLE: [HealthCoverageOverlay] - DETAIL METADATA PROVIDING MAX([FileId]) FOR GIVEN [CIN] + [BenefitBeginDate]' AS [NOTE(S)],* FROM EnrollmentManager.dbo.HealthCoverageOverlay WHERE ClientIndexNumber IN ('90660335E','91447624A')
SELECT 'TABLE: [HcpStatusCode] - STATUS XWALK' AS [NOTE(s)],* FROM EnrollmentManager.dbo.HcpStatusCode
SELECT 'TABLE: [HcpStatusCode] - STATUS XWALK' AS [NOTE(s)],* FROM EnrollmentManager.dbo.HcpStatusCode WHERE code IN ('01','51','S1') 
SELECT 'TABLE: [HcpStatusCode] - STATUS XWALK' AS [NOTE(s)],* FROM EnrollmentManager.dbo.HcpStatusCode WHERE UPPER(LTRIM(RTRIM(ISNULL(Description,'')))) LIKE '%SUPPLEME%'
SELECT 'TABLE: [HcpStatusCode] - STATUS XWALK' AS [NOTE(s)],* FROM EnrollmentManager.dbo.HcpStatusCode WHERE UPPER(LTRIM(RTRIM(ISNULL(Description,'')))) LIKE '%CAPITATIO%RECOVERY%' -- AND code In ('S9') -- NOT IN ('01','51','S1')

FROM EnrollmentManager.dbo.[File] AS f
	JOIN EnrollmentManager.dbo.[Member] AS m ON f.FileId = m.FileId
	JOIN EnrollmentManager.dbo.MemberOverlay AS mo ON m.ClientIndexNumber = mo.ClientIndexNumber -- 'TABLE: [MemberOverlay] - IDENTIFY [RowIsCurrent] = MAX([FileId]) FOR GIVEN [CIN]'
		AND m.FileId = mo.FileId
	JOIN EnrollmentManager.dbo.healthcoverage AS hc ON m.ClientIndexNumber = hc.ClientIndexNumber
		-- AND m.FileId = hc.FileId -- SANS THIS JOIN TO VIEW ALL DETAIL v. DETAIL LIMITED TO MAX([FileId]) FOR GIVEN [CIN]
	JOIN EnrollmentManager.dbo.healthcoverageoverlay AS hco ON hc.ClientIndexNumber = hco.ClientIndexNumber  -- 'TABLE: [HealthCoverageOverlay] - DETAIL METADATA PROVIDING MAX([FileId]) FOR GIVEN [CIN] + [BenefitBeginDate]'
		AND hc.FileId = hco.FileId 
		AND hc.BenefitBeginDate = hco.BenefitBeginDate
	JOIN EnrollmentManager.dbo.HcpStatusCode AS hsc ON hc.HcpStatus = hsc.code

-- ============================================================
		-- HUNT FOR DEPENDENCIES --
-- ============================================================
SELECT ' ' AS  'CHARINDEX() FIND() SEARCH()  FOUR (4) PART(S) SCHEMA(): "SERVERname"."DATABASEname"."SCHEMAname"."OBJECTname"'

USE EnrollmentManager; -- Change this to your target database

	-- Declare server and database variables
	-- Note: Server name usage here is illustrative; dynamic cross-server queries require linked servers or external scripts.
	
/* DECLARE @ServerName nvarchar(255) = N'INFORMATIONAL ONLY'; -- This is more for documentation as we can't switch servers within a script ... The dynamic SQL (@SQL) is constructed to incorporate the database and schema names into the script. This approach is necessary because T-SQL does not allow the direct use of variables in certain statements (e.g., USE, schema names in queries). */

DECLARE @DatabaseName nvarchar(255) = N'EnrollmentManager'; 
DECLARE @SchemaName nvarchar(255) = N'%%%'; -- Specify the schema name here
-- DECLARE @ObjectName nvarchar(255) = N'dbo.CMCSummary'; -- Specify your object name here
DECLARE @ObjectName nvarchar(255) = N'%%%'; -- Specify your object name here ... '%'+'...'+'%'

	-- Update the following variables as needed for your search criteria
DECLARE @SearchText nvarchar(255) = N'%JI%'; -- Text to search for in object definitions and column names ... '%'+'...'+'%'

DECLARE @SQL nvarchar(255);

	-- Dynamic SQL to switch database context (Note: USE statement cannot use variable directly)
SET @SQL = N'USE [' + @DatabaseName + '];'+ 

'-- Your SQL script here, for example:
SELECT DB_NAME() AS CurrentDatabase; -- This will show the database name as a demonstration of dynamic SQL execution

-- Insert the rest of your SQL script here

-- Dynamic SQL script including schema variable
DECLARE @ObjectName NVARCHAR(MAX) = N''YourObjectName''; -- Specify the object name

-- Example: Searching in object definitions (procedures, functions, views, etc.) within the specified schema
SELECT 
    o.name AS ObjectName,
    o.type_desc AS ObjectType,
    m.definition AS ObjectDefinition
FROM sys.sql_modules AS m
JOIN sys.objects o ON m.object_id = o.object_id
WHERE m.definition LIKE N''%' + @SchemaName + N'.YourObjectName%'' -- Adjust this LIKE pattern as needed
AND SCHEMA_NAME(o.schema_id) = ''' + @SchemaName + N'''
ORDER BY o.name;

-- You can add more queries here that utilize the @SchemaName variable';

-- Execute the dynamic SQL
EXEC sp_executesql @SQL;

-- Note: This script demonstrates how to incorporate a schema name dynamically into SQL operations.
-- Remember to replace placeholders like YourServerName, YourDatabaseName, YourSchemaName, and YourObjectName
-- with actual values relevant to your use case.

-- For operations that need to be conducted on a specific database directly
-- you can embed them within dynamic SQL statements as shown above.

-- Note: Directly changing server context within a T-SQL script executed on SQL Server is not possible.
-- For operations across servers, consider using linked servers and four-part names or openquery, 
-- or manage cross-server execution within application logic or SQL Server Management Studio (SSMS) scripts.

	-- Objects that depend upon @ObjectName, filtered by schema
SELECT DISTINCT 'Objects that depend upon ' + @ObjectName AS DependencyType,
    referencing_schema_name, 
    referencing_entity_name
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st',
FROM sys.dm_sql_referencing_entities(QUOTENAME(@SchemaName) + '.' + QUOTENAME(@ObjectName), 'OBJECT')
-- FROM sys.dm_sql_referencing_entities(QUOTENAME(@DatabaseName)+ '.' +QUOTENAME(@SchemaName) + '.' + QUOTENAME(@ObjectName), 'OBJECT')
WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ...
	AND referencing_schema_name = @SchemaName;

	-- Objects on which @ObjectName depends, filtered by schema
SELECT DISTINCT 'Objects on which ' + @ObjectName + ' depends' AS DependencyType,
    referenced_schema_name, 
    referenced_entity_name
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st',
FROM sys.dm_sql_referenced_entities(QUOTENAME(@SchemaName) + '.' + QUOTENAME(@ObjectName), 'OBJECT')
-- FROM sys.dm_sql_referenced_entities(QUOTENAME(@DatabaseName)+ '.' +QUOTENAME(@SchemaName) + '.' + QUOTENAME(@ObjectName), 'OBJECT')
WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ...
	AND referenced_schema_name = @SchemaName;

	-- Alternative method to find dependencies (using sys.sql_expression_dependencies), filtered by schema
SELECT DISTINCT 'Objects on which ' + @ObjectName + ' depends (alternative method)' AS DependencyType,
    OBJECT_SCHEMA_NAME(referencing_id) AS referencing_schema_name, 
    OBJECT_NAME(referencing_id) AS referencing_entity_name
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st',
FROM sys.sql_expression_dependencies
WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ...
	AND referencing_id = OBJECT_ID(QUOTENAME(@SchemaName) + '.' + QUOTENAME(@ObjectName))
	-- AND referencing_id = OBJECT_ID(QUOTENAME(@DatabaseName)+ '.' +QUOTENAME(@SchemaName) + '.' + QUOTENAME(@ObjectName))
AND OBJECT_SCHEMA_NAME(referencing_id) = @SchemaName;







-- ============================================================
	-- HUNT FOR OCCURRENCES --
-- ============================================================
-- Searching in object definitions (e.g., procedures, functions, views, triggers)
SELECT o.name AS ObjectName,
    o.type_desc AS ObjectType,
    m.definition AS ObjectDefinition
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st',	
FROM sys.sql_modules AS m
	JOIN sys.objects o ON m.object_id = o.object_id
WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ...
	-- AND o.name LIKE '%' + @ObjectName + '%'
	-- AND m.definition LIKE '%' + @SearchText + '%'	
	AND o.name LIKE @ObjectName
	AND m.definition LIKE @SearchText
ORDER BY o.name;

-- Searching for table and column names containing the search text
SELECT isc.TABLE_CATALOG AS DatabaseName,
    isc.TABLE_SCHEMA AS SchemaName,
    isc.TABLE_NAME AS TableName,
    isc.COLUMN_NAME AS ColumnName,*
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st',
FROM INFORMATION_SCHEMA.COLUMNS AS isc
	JOIN INFORMATION_SCHEMA.TABLES AS ist ON isc.TABLE_NAME = ist.TABLE_NAME
WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ...
	-- AND isc.TABLE_NAME LIKE '%' + @ObjectName + '%'	 
	-- AND isc.COLUMN_NAME LIKE '%' + @SearchText + '%'	
	AND isc.TABLE_NAME LIKE @ObjectName
	AND isc.COLUMN_NAME LIKE @SearchText
ORDER BY isc.TABLE_NAME, isc.COLUMN_NAME;

		-- SELECT TOP 10 ' ' AS 'CHECK 1st',* 
		-- SELECT DISTINCT ' ' AS 'CHECK 1st' 
		-- FROM [TABLE]








JAH 'RE - DEVELOP CHILD HOMELLES POF(S)'
		/* Adult Individuals Experiencing Homelessness
		Adult Families Experiencing Homelessness
		Adult Avoidable Hospital or ED Utilization
		Adult SMH or SUD
		Adult Transitioning from Incarceration
		Adult At Risk for LTC Institutionalization
		Adult NF Transitioning to Community
		Adult Birth Equity

		Child Individuals Experiencing Homelessness
		Child Families Experiencing Homelessness
		Child Avoidable Hospital or ED Utilization
		Child SMH or SUD
		Child CCS/CCS WCM with Additional Needs
		Child Welfare
		Child Transitioning from Incarceration
		Child Birth Equity  */
		
x ECM POF 'Child Families Experiencing Homelessness'
		sp_ECMPOF_CHILDHOMELESS_W_FAMILY

-- SELECT TOP 10 * FROM INFORMATICS.dbo.ECMPOF_CHILD_HOMELESS	
		SELECT 'ECM POF Child Families Experiencing Homelessness' AS ' ',COUNT(DISTINCT(memid)) AS [Unique Member Count] FROM INFORMATICS.dbo.ECMPOF_CHILDWITHFAMILY_HOMELESS
-- =====================================================================
	-- CONCLUDE STATEMENTS FOR PROCEDURE HERE:
-- =====================================================================
END
GO

x ECM POF 'Child Individuals Experiencing Homelessness'
		sp_ECMPOF_CHILDHOMELESS_INDIVIDUAL

		-- SELECT * FROM INFORMATICS.dbo.ECMPOF_CHILDWITHOUTFAMILY_HOMELESS
		SELECT 'ECM POF Child Individuals Experiencing Homelessness' AS ' ',
		COUNT(DISTINCT(memid)) AS [Unique Member Count] 
		FROM INFORMATICS.dbo.ECMPOF_CHILDWITHOUTFAMILY_HOMELESS
-- =====================================================================
	-- CONCLUDE STATEMENTS FOR PROCEDURE HERE:
-- =====================================================================
END
GO







JAH 'POF' CHANGE.LOG
		SELECT ' ' AS 'see: "ECMCS NEW POF NAMING CONVENTION 20240502.xlsx"'

		/* Adult Individuals Experiencing Homelessness
		Adult Families Experiencing Homelessness
		Adult Avoidable Hospital or ED Utilization
		Adult SMH or SUD
		Adult Transitioning from Incarceration
		Adult At Risk for LTC Institutionalization
		Adult NF Transitioning to Community
		Adult Birth Equity

		Child Individuals Experiencing Homelessness
		Child Avoidable Hospital or ED Utilization
		Child SMH or SUD
		Child CCS/CCS WCM with Additional Needs
		Child Welfare
		Child Transitioning from Incarceration
		Child Birth Equity  */

'Adult Homeless WITHOUT Family' REPLACE() SUBSTITUTE() WITH() Adult Individuals Experiencing Homelessness
'Adult Homeless WITH Family' REPLACE() SUBSTITUTE() WITH() Adult Families Experiencing Homelessness
'Adult IP ED High Utilization' REPLACE() SUBSTITUTE() WITH() Adult Avoidable Hospital or ED Utilization
'Adult MH SMI SUD' REPLACE() SUBSTITUTE() WITH() Adult SMH or SUD
-- 'Adult Transitioning from Incarceration' REPLACE() SUBSTITUTE() WITH() Adult Transitioning from Incarceration
'Adult Institutionalization' REPLACE() SUBSTITUTE() WITH() Adult At Risk for LTC Institutionalization
'Adult Nursing Transition' REPLACE() SUBSTITUTE() WITH() Adult NF Transitioning to Community
'Adult Birth Equity' REPLACE() SUBSTITUTE() WITH() Adult Birth Equity

'Child Homeless' REPLACE() SUBSTITUTE() WITH() Child Individuals Experiencing Homelessness
'Child IP ED High Utilization' REPLACE() SUBSTITUTE() WITH() Child Avoidable Hospital or ED Utilization
'Child MH SMI SUD' REPLACE() SUBSTITUTE() WITH() Child SMH or SUD
'Child CCS' REPLACE() SUBSTITUTE() WITH() Child CCS/CCS WCM with Additional Needs
-- 'Child Welfare' REPLACE() SUBSTITUTE() WITH() Child Welfare
-- 'Child Transitioning from Incarceration' REPLACE() SUBSTITUTE() WITH() Child Transitioning from Incarceration
-- 'Child Birth Equity' REPLACE() SUBSTITUTE() WITH() Child Birth Equity

-- =====================================================================
	-- Add the parameters for the stored procedure here:
-- =====================================================================
		-- /* DECLARE  */@StartDate AS datetime = NULL -- '08/19/2015' -- DEFAULT VAL()

		IN ('1679158125','1790002806','1760477467','1689066748','1659415131','1629749577','1619393584','1073177739','1538667969','1437821022','1427696616','1376797035','1275285868','1205254950','1447281936','1093834020','1922642909','1649809526','1154978021','1891408043','1376229872','1801007778','1679357685','1922790906') -- C003: UPDATE: CS National Provider Identifier (NPI) Number, if applicable per "MOC Excel File CS Provider Capacity Template 2024 Mapping 20240503.xlsx"
		 
		 IN ('1063122323','1083764724','1447281936','1134144165','1205254950','1245246917','1295822658','1356889539','1366807760','1376229872','1427696616','1528271186','1073177739','1609920305','1619393584','1639614688','1649809526','1669711297','1689798985','1710439559','1760477467','1790718351','1891408043','1922642909','1598703647','1679158125','1952364747','1962483040','1982756086','1275972333','1255496105','1912688656','1134838352','1710336094','1710065933','1679357685','1922790906','1699043000','1255738423') -- C00#: UPDATE ECM National Provider Identifier (NPI) Number per "MOC Excel File ECM Provider Capacity Template 2023 Mapping 4.25.2024 20240503.xlsx"

-- =====================================================================
	-- MODIFICATION(S) | CHANGE LOG: --
-- =====================================================================
-- C001: START WITH() ECMELIG PER WEEKLY ECM TEAMS MEETING + MS CLAUDIA GUIDANCE ON 20240418

-- C002: [TargetPopulation] ⏎ In the 20240418 script, the POF assessment is updated to use the [ProviderPortal].ecm.[StratificationTargetPopulation] table instead, as per the guidance from the ECM weekly teams meeting ON 20240418.

-- C003: IN ('1679158125','1790002806','1760477467','1689066748','1659415131','1629749577','1619393584','1073177739','1538667969','1437821022','1427696616','1376797035','1275285868','1205254950','1447281936','1093834020','1922642909','1649809526','1154978021','1891408043','1376229872','1801007778','1679357685','1922790906') -- C003: UPDATE: CS National Provider Identifier (NPI) Number, if applicable per "MOC Excel File CS Provider Capacity Template 2024 Mapping 20240503.xlsx"
 
 -- C003: IN ('1063122323','1083764724','1447281936','1134144165','1205254950','1245246917','1295822658','1356889539','1366807760','1376229872','1427696616','1528271186','1073177739','1609920305','1619393584','1639614688','1649809526','1669711297','1689798985','1710439559','1760477467','1790718351','1891408043','1922642909','1598703647','1679158125','1952364747','1962483040','1982756086','1275972333','1255496105','1912688656','1134838352','1710336094','1710065933','1679357685','1922790906','1699043000','1255738423') -- C00#: UPDATE ECM National Provider Identifier (NPI) Number per "MOC Excel File ECM Provider Capacity Template 2023 Mapping 4.25.2024 20240503.xlsx"

		-- left join ProviderPortal.ecm.MemberTargetPopulation ECM_MT on ECM_MT.MemberId = ECM.memid
		LEFT JOIN ProviderPortal.ecm.StratificationTargetPopulation AS ECM_MT ON ECM.memid = ECM_MT.MemberId  -- C002: [TargetPopulation] ? In the 20240418 script, the POF assessment is updated to use the [ProviderPortal].ecm.[StratificationTargetPopulation] table instead, as per the guidance from the ECM weekly teams meeting ON 20240418.







JAH 'HEADER' v 'DETAIL' AS COMPARED TO 'FACT' v 'DIM' TABLE...

SELECT DISTINCT ' ' AS 'MS CLAUDIA ADHOC: ECM/CS AUTH REPORT',r.servicecode
FROM HMOPROD_PLANDATA.dbo.referral AS r
WHERE 1=1
	-- AND UtcReceiptDate BETWEEN TRY_CONVERT(date,'') AND TRY_CONVERT(date,GETDATE())
	-- AND r.servicecode LIKE 'ECM'
	AND r.servicecode LIKE '%ECM%'
		OR r.servicecode LIKE '%CS%'







JAH THANK YOU JAH 'Claude.ai' ON 20240425 - Improving Birth Equity in San Diego County

DHCS provides guidance and criteria for identifying individuals who qualify for each ECM Population of Focus, including the Birth Equity POF.

In the ECM Policy Guide (May 2022), DHCS identifies two specific subgroups under the Pregnancy and Postpartum POF:
              1.     Individuals who are pregnant, and
              2.     Individuals who are postpartum (defined as the 12 months after the end of a pregnancy).

The guide states that MCPs (Managed Care Plans) must offer ECM to all pregnant and postpartum individuals who:
              1.     Are enrolled in Medi-Cal managed care;
              2.     Are pregnant or postpartum;
              3.     Are not otherwise excluded from ECM; and
              4.     Meet the eligibility criteria.

The eligibility criteria include having certain health conditions, co-morbidities, social factors, or other criteria determined by DHCS or the MCP that put the individual at high risk.

For the Birth Equity focus, DHCS has emphasized the importance of identifying and addressing disparities in maternal and infant health outcomes, particularly among Black/African American and Native American/Alaska Native populations. MCPs are expected to use data and work with community partners to identify and engage pregnant and postpartum individuals who may benefit from ECM due to health and social risk factors.

While the exact SQL logic for identifying the Birth Equity POF may vary by MCP based on their data and specific county demographics, the overall guidance from DHCS is to use a combination of claims data (pregnancy and postpartum diagnosis and procedure codes), member demographics (age, race/ethnicity), and other health and social risk factors to proactively identify and outreach to this population for ECM services.

The SQL script developed is following this general approach by identifying pregnant women and newborns, and then further stratifying by age and specific ethnicities that align with DHCS Birth Equity focus.
              USE https://www.dhcs.ca.gov/CalAIM/ECM/Documents/ECM-BirthEquity-POF-FAQ%27s-February2024.pdf 

The California Department of Health Care Services (DHCS) provides several documents and resources related to the Enhanced Care Management (ECM) program and Populations of Focus. Here are a few key resources:
              1.     ECM Policy Guide (May 2022) - This comprehensive guide outlines the policies and requirements for the ECM program, including detailed descriptions of each Population of Focus and eligibility criteria. URL: https://www.dhcs.ca.gov/Documents/MCQMD/ ... ECM-Policy-Guide-May-2022.pdf
              2.     ECM Key Definitions - This document provides key definitions related to ECM, including Populations of Focus. URL: https://www.dhcs.ca.gov/Documents/MCQMD/ECM-Key-Definitions.pdf
              3.     CalAIM ECM and Community Supports Populations of Focus Descriptions - This document provides a brief overview of each ECM Population of Focus. URL: https://www.dhcs.ca.gov/Documents/MCQMD/ ...Populations-of-Focus-Descriptions.pdf
              4.     Medi-Cal Managed Care Health Plan Contract, Exhibit A, Attachment III - This contract language specifies the requirements for MCPs related to ECM, including identifying and serving Populations of Focus. URL: https://www.dhcs.ca.gov/provgovpart/Documents/ ... Exhibit-A-Attachment-III-6-1-22.pdf
              5.     CalAIM Data Sharing Authorization Guidance - This document provides guidance on data sharing for ECM and includes discussion of identifying Populations of Focus. URL: https://www.dhcs.ca.gov/Documents/MCQMD/ ... CalAIM-Data-Sharing-Authorization-Guidance.pdf

These resources provide the policy context and guidance from DHCS related to ECM Populations of Focus, including Birth Equity. 

POF Birth Equity for San Diego County
I do not have enough context to fully understand your request. POF could stand for various things, and I'm not sure how it relates to birth equity in San Diego County. Could you please provide more information or rephrase your request? I'd be happy to assist you once I have a clearer understanding of what you are looking for.
Copy
CHECKLIST_ECM_POF_20240105
ECMPOF_BIRTH_EQUITY_20240105
EH

For context:
Based on the provided SQL scripts, it appears you are working on identifying ECM (Enhanced Care Management) Populations of Focus (POF) for San Diego County, with a specific focus on Birth Equity.

The first script (CHECKLIST_ECM_POF_20240105.sql) seems to be a checklist or guide that provides an overview of the various ECM POF tables in the INFORMATICS database, such as ECMPOF_CHILD_HOMELESS, ECMPOF_ADULT_MHSMISUD, etc. It also mentions a stored procedure [sp] '[InsertECMPOFData]' that is used to populate an ECM Target Populations view.

The second script (ECMPOF_BIRTH_EQUITY_20240105.sql) contains the stored procedure [sp_ECMPOF_BIRTHEQUITY] which appears to be the main logic for identifying the Birth Equity population. Here are the key steps:
		1.	It sets up date range variables and age cutoff (21 years).
		2.	It identifies newborns and their mothers in a specific date range using the #BaselineKick temporary table. It matches ethnicity information as well.
		3.	It finds pregnancy and postpartum related claims for the identified mothers using diagnosis codes, CPT codes, and revenue codes. This data is stored in the #PPPClaims temp table.
		4.	It then populates two permanent tables - ECMPOF_ADULT_BIRTH_EQUITY and ECMPOF_CHILD_BIRTH_EQUITY.
				•	The adult table includes mothers 21 years and older.
				•	The child table includes mothers younger than 21.
				•	Both exclude members enrolled in CCM/CM programs.
				•	Both filter for specific ethnicities: 'Black or African American','American Indian or Alaska Native','Native Hawaiian or Other Pacific Islander'.
		5.	Finally, it does some counts and distinct checks on the output tables.

In summary, this stored procedure is using claims data and member demographics to identify pregnant women and newborns, stratified by age and specific ethnicities, for the ECM Birth Equity population of focus in San Diego County. The output is stored in two permanent tables for adults and children.

These ECM Populations of Focus include:
		1.	Individuals and Families Experiencing Homelessness
		2.	High Utilizers with Frequent Hospital or Emergency Room Visits/Admissions
		3.	Individuals with Serious Mental Illness (SMI) or Substance Use Disorder (SUD)
		4.	Individuals Transitioning from Incarceration
		5.	Adults Living in the Community and at Risk for Long-Term Care Institutionalization
		6.	Nursing Facility Residents Transitioning to the Community
		7.	Children or Youth with Complex Physical, Behavioral, and Developmental Health Needs (e.g., California Childrens Services, Foster Care, Youth with Clinical High-Risk Syndrome or First Episode of Psychosis)

The SQL scripts you provided are focusing specifically on identifying the Birth Equity POF, which appears to be a subset of pregnant and postpartum women and newborns, with an emphasis on certain ethnicities that may face disparities or require additional care management.

Identifying and flagging these POFs allows the health plan to provide targeted outreach, care coordination, and supportive services to improve outcomes and address the unique needs of each group.
Copy
EH

Does DHCS (dept. of health care services) provide any guidance on defining his POF?








JAH THANK YOU JAH 
JAH 'Claude.ai ChatGPR BARD GROK' ON 20240105 - Deciphering and Explaining a Child Birth Equity SQL Script for Peer Review

The SQL script, is doing the following main things:

		⏎ Declaring various date variables for specifying the report date range, such as @StartDate, @EndDate, @ReportRunDate.

		⏎ Creating some temporary tables like #BaselineKick to identify mother-baby pairs by joining various membership/relationship tables.

		⏎ Identifying pregnancy/postpartum related diagnosis and procedure codes from claims data and inserting into a temp table #PPPClaims. This uses things like claimdiag, svccode tables along with clever JOINs and analytic FUNCTIONs like ROW_NUMBER() and DENSE_RANK().

		⏎ Creating output tables ECMPOF_ADULT_BIRTH_EQUITY and ECMPOF_CHILD_BIRTH_EQUITY that have Member data like name, DOB, address details. It LEFT JOINs the #PPPClaims data to include any pregnancy/postpartum codes found for those members.

		⏎ Including some age filters, like >= 21 years for adult table and < 21 years for child table.

		⏎ Adding ethnicity information by clever JOINs to external ethnicity mapping tables.

		⏎ Finally summarizing the counts and doing some data quality checks on the output tables.

In summary, it is pregnancy / post partum identification logic that separates into adults vs children, includes detailed Member data like demographics and address, enriched with diagnosis/procedure data from claims, and designed specifically for some sort of Birth Equity report. Healthcare analysis to identify and stratify a pregnant population.

EXAMININATION:


		⏎ The script uses dynamic declarations to set variables for dates, age cutoff, and PCP record rank.

		⏎ It identifies newborns and mothers based on specific criteria, storing the information in a temporary table (#BaselineKick).

		⏎ Maternity claims data is extracted and stored in another temporary table (#PPPClaims).

		⏎ Two more temporary tables are created for adult and child childbirth equity (#ECMPOF_ADULT_BIRTH_EQUITY and #ECMPOF_CHILD_BIRTH_EQUITY).

		⏎ Ethnicity information is added to these tables by matching with another table, and records without specified ethnicity are removed.

EXPLAIN:
The script is designed to extract and analyze data related to childbirth and maternity claims in a healthcare database. It initializes variables, identifies newborns and mothers, extracts maternity claims data, and creates temporary tables for adult and child childbirth equity. Ethnicity information is added, and records without specified ethnicity are excluded.

INTERPRET:
This SQL script is part of a process aimed at understanding and categorizing childbirth-related data. It extracts information about newborns, mothers, and maternity claims, creating temporary tables for further analysis. Ethnicity details are incorporated, and records lacking ethnicity information are excluded.

Please note that a more detailed review and understanding of the entire database schema would be necessary for a comprehensive peer code review.

The techniques used demonstrate good SQL coding practices - temporary tables, modular SQL, single purpose staging tables, descriptive naming conventions, consistent formatting. Overall this seems like efficient, well written code that is doing healthcare analysis to identify and stratify a pregnant population.

Please let me know if you need any specific sections explained in more detail!

Copy

Thank you

EH
shift + ⏎ to add a new line, Ctrl + K to create a new chat
No file chosen

Claude.ai is in beta release and may display incorrect or harmful information

Upgrade plan
Get GPT-4, DALL·E, and more

User
WALTER NANCY

Close sidebar
ChatGPT 3.5






JAH 'ECM SSRS REPORT RE - DEVELOPMENT'
		USE http://prodqssrs/reports/browse/CHG%20Reports/ECM
		
		see "ECM Daily Member File.rdl"
		see "ECM Member File.rdl"

		SELECT DISTINCT * 
		FROM INFORMATICS.dbo.ECM_All
		WHERE 
		(AdultOrChildYouth = 'Adult' OR In_HHPorWPC = 1 OR MemberEnrollmentStatus = 'Termed')
		ORDER BY Member_Last_Name
		,Member_First_Name

		SELECT TOP 10 *
		-- SELECT COUNT(1)
		-- SELECT COUNT(DISTINCT(MemberId))
		FROM ProviderPortal.ECM.Member AS M (NOLOCK)
			JOIN 
			( -- INITIATE ...
			SELECT DISTINCT [memid] FROM INFORMATICS.dbo.ECMPOF_CHILD_HOMELESS

			UNION
			SELECT DISTINCT [memid] FROM INFORMATICS.dbo.ECMPOF_CHILD_IPSNFED_HIGHUTIL

			UNION
			SELECT DISTINCT [memid] FROM INFORMATICS.dbo.ECMPOF_CHILD_MHSMISUD

			UNION 
			SELECT DISTINCT [memid] FROM INFORMATICS.dbo.ECMPOF_CHILD_INCARCERATION		

			UNION 
			SELECT DISTINCT [memid] FROM INFORMATICS.dbo.ECMPOF_CHILD_CCS

			UNION 
			SELECT DISTINCT [memid] FROM INFORMATICS.dbo.ECMPOF_CHILD_WELFARE
					
			UNION 
			SELECT DISTINCT [memid] FROM INFORMATICS.dbo.ECMPOF_CHILD_IDD

			UNION 
			SELECT DISTINCT [memid] FROM INFORMATICS.dbo.ECMPOF_ADULT_MHSMISUD

			UNION
			SELECT DISTINCT [memid] FROM INFORMATICS.dbo.ECMPOF_ADULT_INCARCERATION

			UNION
			SELECT DISTINCT [memid] FROM INFORMATICS.dbo.ECMPOF_ADULT_INSTITUTIONALIZATION

			UNION 
			SELECT DISTINCT [memid] FROM INFORMATICS.dbo.ECMPOF_ADULT_NURSING_TRANSITION		

			-- UNION 
			-- SELECT DISTINCT [memid] FROM INFORMATICS.dbo.ECMPOF_ADULT_PREGNANCY_POSTPARTUM

			UNION 
			SELECT DISTINCT [memid] FROM INFORMATICS.dbo.ECMPOF_ADULT_IPSNFED_HIGHUTIL

			UNION 
			SELECT DISTINCT [memid] FROM INFORMATICS.dbo.ECMPOF_ADULTWITHFAMILY_HOMELESS

			UNION 
			SELECT DISTINCT [memid] FROM INFORMATICS.dbo.ECMPOF_ADULTWITHOUTFAMILY_HOMELESS

			UNION 
			SELECT DISTINCT [memid] FROM INFORMATICS.dbo.ECMPOF_ADULT_IDD
			) AS ecmm ON M.MemberId = ecmm.memid
		-- WHERE M.IsECM = 1

-- ============================================================
	-- HUNT FOR DEPENDENCIES ---
-- ============================================================
USE INFORMATICS -- EXEC IN [SERVERname]; SCHEMA() SELECT * FROM 'SERVERname'.'DATABASEname'.'SCHEMAname'.'OBJECTname' - FOUR (4) PART() SCHEMA() aka [SERVERname].[DATABASEname].[SCHEMAname].[OBJECTname] - see '[SQL13].[CHGAPP_PROD].dbo.[tblEDIDHCSType834]' PERHAPS AID IN RESOLVING RUNTIME ISSUE??? AS OF 20180808 Thanks for sending this. Something occurred to me last night.  Allyson was having a similar issue because she as connected to the master database when she was executing her query.  She was doing the same as you…pulling data from HMOPROD_PlanData and writing it to Informatics.  But she was executing from the master database.  And I think I saw last night that you might have been doing the same thing.  And I think your default database on SQLPROD02 might be master.  Do you recall which database you were connected to?  Jeremy

DECLARE @sp AS nvarchar(MAX)

SET @sp = N'dbo.rpt_ECM_Member_file'

SELECT DISTINCT ' ' AS 'Objects that DEPEND upon [@sp]',
    referencing_schema_name, 
    referencing_entity_name
FROM sys.dm_sql_referencing_entities(@sp,'OBJECT')

SELECT DISTINCT ' ' AS 'Objects on which [@sp] DEPENDS',
    referenced_schema_name, 
    referenced_entity_name
FROM sys.dm_sql_referenced_entities(@sp,'OBJECT')

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
FROM sys.dm_sql_referencing_entities (@sp,'OBJECT');







-- ============================================================
	-- HUNT FOR OCCURRENCES -- 
-- ============================================================
DECLARE @server AS nvarchar(MAX) = 'SQLPROD02'
-- DECLARE @db AS nvarchar(MAX) = 'INFORMATICS'

USE [master] -- EXEC IN [SERVERname]; SCHEMA() SELECT * FROM 'SERVERname'.'DATABASEname'.'SCHEMAname'.'OBJECTname' - FOUR (4) PART() SCHEMA() aka [SERVERname].[DATABASEname].[SCHEMAname].[OBJECTname] - see '[SQL13].[CHGAPP_PROD].dbo.[tblEDIDHCSType834]' PERHAPS AID IN RESOLVING RUNTIME ISSUE??? AS OF 20180808 Thanks for sending this. Something occurred to me last night.  Allyson was having a similar issue because she as connected to the master database when she was executing her query.  She was doing the same as you…pulling data from HMOPROD_PlanData and writing it to Informatics.  But she was executing from the master database.  And I think I saw last night that you might have been doing the same thing.  And I think your default database on SQLPROD02 might be master.  Do you recall which database you were connected to?  Jeremy

DECLARE @tblis AS nvarchar(MAX)
DECLARE @tbltype AS nvarchar(MAX)
DECLARE @tblwas AS nvarchar(MAX)
DECLARE @tblwillbe AS nvarchar(MAX)
DECLARE @fieldis AS nvarchar(MAX)
DECLARE @fieldwas AS nvarchar(MAX)
DECLARE @fieldwillbe AS nvarchar(MAX)
DECLARE @textis AS nvarchar(MAX)

SET @tblis  = '%%' --UPDATE AS NEEDED HERE WITHIN THE ‘’
SET @tbltype  = '%%' --UPDATE AS NEEDED HERE WITHIN THE ‘’
SET @tblwas  = '%%' --UPDATE AS NEEDED HERE WITHIN THE ‘’
SET @tblwillbe  = '%%' --UPDATE AS NEEDED HERE WITHIN THE ‘’
SET @fieldis  = '%ECM_All%' --UPDATE AS NEEDED HERE WITHIN THE ‘’ ISO w createid OR dreatedate
SET @fieldwas  = '%%' --UPDATE AS NEEDED HERE WITHIN THE ‘’
SET @fieldwillbe  = '%%' --UPDATE AS NEEDED HERE WITHIN THE ‘’
SET @textis  = '%ECM_All%' --UPDATE AS NEEDED HERE WITHIN THE ‘’

SELECT @server AS [SERVER],' ' AS 'db'
,o.name,o.type_desc,m.definition,OBJECT_NAME(o.OBJECT_ID) AS [OBJECT NAME],OBJECT_DEFINITION(o.OBJECT_ID) AS [SCRIPT],*
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM SYS.SQL_MODULES AS m -- CHARINDEX() FIND() SEARCH() IN ALL OBJECT(s)
	JOIN sys.objects o ON m.object_id = o.object_id
-- WHERE o.name LIKE @tblis
WHERE m.definition LIKE @textis -- '%CaseloadIsCurr%' FROM: MS. ALLYSON HUNT ON 20190827 Hola,  Do any of you guys know how this table is populated?  Informatics.dbo.CaseMgrCMC
		-- OR m.definition LIKE @tblis -- '%CaseloadIsCurr%' FROM: MS. ALLYSON HUNT ON 20190827 Hola,  Do any of you guys know how this table is populated?  Informatics.dbo.CaseMgrCMC
ORDER BY OBJECT_NAME(o.OBJECT_ID)

SELECT DISTINCT @server AS [SERVER],isc.TABLE_CATALOG AS [db],ist.TABLE_NAME,'TABLE' AS [type_desc],*
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

		-- SELECT TOP 10 ' ' AS 'CHECK 1st',* 
		-- SELECT DISTINCT ' ' AS 'CHECK 1st' 
		-- FROM [TABLE]







JAH 'FINALIZE ECM POF'
x TEST IN SERVER [sqlqa02]
x ONE 1 vw
x DETERMINE EXEC TIME

--------------------------------------------------------------------------------------------------------------------
	-- Error Trapping: Check If Permanent Table(s) Already Exist(s) And Drop If Applicable --
--------------------------------------------------------------------------------------------------------------------
TRUNCATE TABLE INFORMATICS.dbo.ECMPOF_ADULT_IPSNFED_HIGHUTIL; -- SQL Server 2016 and later -- DYNAMIC tmp OR STATIC [TABLE] #TableName is a local temporary table visible only in the current session; ##TableName is a GLOBAL temporary table visible to all sessions IN ('TempDB')
-- DROP TABLE IF EXISTS INFORMATICS.dbo.ECMPOF_ADULT_IPSNFED_HIGHUTIL; -- SQL Server 2016 and later -- DYNAMIC tmp OR STATIC [TABLE] #TableName is a local temporary table visible only in the current session; ##TableName is a GLOBAL temporary table visible to all sessions IN ('TempDB')

INSERT INTO INFORMATICS.dbo.ECMPOF_ADULT_IPSNFED_HIGHUTIL -- (FIELD(S) IN PLAY,...)
SELECT DISTINCT 'Adult Incarceration' AS [TargetPopulation],

-- x SQLPROD02.INFORMATICS.dbo.MemberMonths
-- x SQLPROD02.INFORMATICS.dbo.ECMPOFPCP

--------------------------------------------------------------------------------------------------------------------
	-- Error Trapping: Check If Permanent Table(s) Already Exist(s) And Drop If Applicable --
--------------------------------------------------------------------------------------------------------------------
TRUNCATE TABLE INFORMATICS.dbo.ECMPOF_CHILD_CCS; -- SQL Server 2016 and later -- DYNAMIC tmp OR STATIC [TABLE] #TableName is a local temporary table visible only in the current session; ##TableName is a GLOBAL temporary table visible to all sessions IN ('TempDB')
-- DROP TABLE IF EXISTS INFORMATICS.dbo.ECMPOF_CHILD_CCS; -- SQL Server 2016 and later -- DYNAMIC tmp OR STATIC [TABLE] #TableName is a local temporary table visible only in the current session; ##TableName is a GLOBAL temporary table visible to all sessions IN ('TempDB')

INSERT INTO INFORMATICS.dbo.ECMPOF_CHILD_CCS -- (FIELD(S) IN PLAY,...)
SELECT DISTINCT 'Child CCS' AS [TargetPopulation],







-- =====================================================================
-- Template generated from Template Explorer using:
-- Create Procedure (New Menu).SQL

-- Use the Specify Values for Template Parameters 
-- command (Ctrl-Shift-M) to fill in the parameter 
-- values below.

-- This block of comments will not be included in
-- the definition of the procedure.
-- =====================================================================
USE [INFORMATICS] -- WHERE [sp] IS LOCATED 'SERVERname'.'DATABASEname'.'SCHEMAname'.'OBJECTname' - FOUR (4) PART() SCHEMA()  aka [SERVERname].[DATABASEname].[SCHEMAname].[OBJECTname]

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET NOCOUNT ON -- added to prevent extra result sets from interfering with SELECT statements.
SET ANSI_NULLS ON
SET ANSI_WARNINGS ON
SET ARITHABORT OFF
SET ARITHIGNORE ON
SET TEXTSIZE 2147483647

GO
SET QUOTED_IDENTIFIER ON
GO

-- =====================================================================
-- Author:		WCARR
-- Create date: IN yyyymmdd
-- Description:	GENERATE STORED PROCEDURE (sp) 
-- =====================================================================
-- CREATE PROCEDURE dbo.[sp] --<Procedure_Name, sysname, ProcedureName>
ALTER PROCEDURE dbo.[sp] --<Procedure_Name, sysname, ProcedureName>
-- DROP PROCEDURE dbo.[sp] --<Procedure_Name, sysname, ProcedureName>

-- =====================================================================
	-- Add the parameters for the stored procedure here:
-- =====================================================================
		-- @StartDate AS datetime = NULL -- '08/19/2015' -- DEFAULT VAL()
		-- ,@EndDate AS datetime = NULL -- '08/19/2015' -- DEFAULT VAL()
		-- ,@textval AS nvarchar(100) = NULL --'My Name Is' -- DEFAULT VAL()
		-- ,@money AS money = NULL -- 375.25 -- DEFAULT VAL()
		-- ,@NumberIs AS int = NULL -- 9 -- DEFAULT VAL()
		-- ,@RXstart AS nvarchar(8) = NULL -- yyyymmdd' -- DEFAULT VAL()
		-- ,@RXend AS nvarchar(8) = NULL -- 'yyyymmdd' -- DEFAULT VAL()
		-- ,@spec AS nvarchar(100)  = NULL -- 'CARDIO' -- ENTER DESIRED [SPEC DESCRIPTION] -- DEFAULT VAL()
		-- ,@city AS nvarchar(100)  = NULL -- 'CHULA VIST' -- ENTER DESIRED [SPEC DESCRIPTION] -- DEFAULT VAL()
		-- ,@zip AS nvarchar(5) = NULL -- '91914' -- ENTER DESIRED [ZIP CODE]VAL() -- DEFAULT VAL()

AS
BEGIN

-- =====================================================================
	-- INITIATE STATEMENTS FOR PROCEDURE HERE:
-- =====================================================================
-- =====================================================================
	-- CONCLUDE STATEMENTS FOR PROCEDURE HERE:
-- =====================================================================
END
GO







JAH 'COMBINE ? GET() DISTINCT MEMBERSHIP'
DECLARE @PCPrecordRANK AS int = 1 -- ENTER 1 TO GET() JUST MOST CURRENT [RANKis] see DENSE_RANK() OVER(PARTITION BY ek.memid ORDER BY CAST(ek.effdate AS datetime) DESC) AS [RANKis] --'RANKis' --RANK by MOST CURRENT

,ISNULL(pcp.PAYTONM,'NO PCP REQUIRED') AS [PCPs Pay To]

		LEFT JOIN INFORMATICS.dbo.uvw_PCP AS pcp ON mm.memid = pcp.memid
			AND pcp.[RANKis] = @PCPrecordRANK -- CURRENT OR LAST PCP Ax
			-- AND pcp.[ROWRANKis] = @PCPrecordRANK -- CURRENT OR LAST PCP Ax
			AND pcp.[ROWis] = @PCPrecordRANK -- CURRENT OR LAST PCP Ax

USE ProviderPortal
GO
SELECT ' ' AS 'MS KATHRYN ENROLLED CCM / CM IDENTIFICATION'
,ecm.memberid
,lcm.Name AS CareMgrName
FROM ecm.MembersInformation ecm(NOLOCK)
CROSS APPLY(
    select 
    *
    FROM ecm.MemberProviderAssigment mpa(NOLOCK)
WHERE mpa.MemberId= ecm.MemberId
AND mpa.TermDate = '2078-12-31'
)mpa
OUTER APPLY (
    SELECT TOP 1 *
    FROM ecm.LeadCareManager lcm(NOLOCK)
    WHERE lcm.AssignmentID= mpa.AssignmentID
    ORDER BY lcm.LeadCareManagerID desc
)lcm
       LEFT JOIN providerportal.ecm.ValidProvider vp on vp.ProviderId=mpa.ProviderId
WHERE ecm.IsECM = 0 and ecm.EnrollmentStatus = 'enrolled'
	-- AND ecm.MemberId IN ('2404257')

SELECT ' ' AS 'MS KATHRYN ENROLLED CCM / CM IDENTIFICATION'
,'Y' AS [CCMflag],mi.memberid,lcm.Name AS CareMgrName
FROM ProviderPortal.ecm.MembersInformation AS mi (NOLOCK)
		
		CROSS APPLY(
		SELECT *
		FROM ProviderPortal.ecm.MemberProviderAssigment AS mpa (NOLOCK)
		WHERE mpa.MemberId= mi.MemberId
		AND mpa.TermDate = '2078-12-31'
		) AS mpa
		
		OUTER APPLY (
		SELECT TOP 1 *
		FROM ProviderPortal.ecm.LeadCareManager AS lcm (NOLOCK)
		WHERE lcm.AssignmentID= mpa.AssignmentID
		ORDER BY lcm.LeadCareManagerID DESC
		) AS lcm
		
		LEFT JOIN ProviderPortal.ecm.ValidProvider AS vp ON vp.ProviderId=mpa.ProviderId
WHERE mi.IsECM = 0 
	AND mi.EnrollmentStatus = 'enrolled'
	-- AND mi.MemberId IN ('2404257')







JAH 'DEVELOPMENT' ???
--------------------------------------------------------------------------------------------------------------------
	-- Error Trapping: Check If Permanent Table(s) Already Exist(s) And Drop If Applicable --
--------------------------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS #SMI; -- SQL Server 2016 and later -- DYNAMIC tmp OR STATIC [TABLE] #TableName is a local temporary table visible only in the current session; ##TableName is a GLOBAL temporary table visible to all sessions IN ('TempDB')

SELECT DISTINCT ' ' AS 'SMI (Serious Mental Illness)',mmem.memid,mmem.effdate,mmem.termdate,mem.codeid,CAST(mem.description AS nvarchar(MAX)) AS [CodeDescr]
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st',
INTO #SMI
FROM HMOPROD_PlanData.dbo.memo AS mem (NOLOCK)
	JOIN HMOPROD_PlanData.dbo.membermemo AS mmem (NOLOCK) ON mem.memoid = mmem.memoid
WHERE mem.memotype = 'salrt' 
	AND TRY_CONVERT(date,mem.termdate) >= TRY_CONVERT(date,GETDATE())
	-- AND TRY_CONVERT(date,mem.effdate) >= @StartDate 
	-- AND TRY_CONVERT(date,mem.effdate) <= @EndDate	
	AND mem.codeid = 'MentalHealth'
	-- AND mm.memid = mmem.memid -- FROM INFORMATICS.dbo.MemberMonths AS mm (NOLOCK)

		SELECT * FROM #SMI

outer apply (
select top 1
mm.memid,
 
mmem.effdate, 
mmem.termdate
from HMOPROD_PlanData.dbo.memo mem(NOLOCK)
join HMOPROD_PlanData.dbo.membermemo mmem(NOLOCK) on mem.memoid = mmem.memoid
where mem.memotype = 'salrt' 
and mem.termdate > GETDATE()
and mem.codeid = 'MentalHealth'
and mm.memid = mmem.memid -- FROM INFORMATICS.dbo.MemberMonths AS mm (NOLOCK)
order by mmem.effdate desc
) AS smi

-- =====================================================================
	-- DECLARE @PARAMETER(S) / @FILTER(S) --
-- =====================================================================
DECLARE @ReportRunDate date = GETDATE()
DECLARE @AgeCutoff int = 21
DECLARE @whichaidcode AS nvarchar(5) = 'MA002' -- AIDCODE aka CMCapCode aka SUBSC_DEPT

		SELECT TOP 1 @AgeCutoff AS [AGE LIMIT < (LESS THAN)],@ReportRunDate AS [RunDate],* FROM INFORMATICS.dbo.MemberMonths
		
-- SELECT DISTINCT ' ' AS 'POF #7 Children and Youth Enrolled in California Children’s Services ',q.attributeid,q.description,ma.*
SELECT DISTINCT ' ' AS 'POF #7 CCS = Ca. Children Service(s) v CSSD = Childrens Specialist of San Diego (CSSD)',q.attributeid,q.description -- ,ma.thevalue
-- SELECT DISTINCT 'POF #8 CCS = Ca. Children Service(s) v CSSD = Childrens Specialist of San Diego (CSSD)',q.*,ma.thevalue
FROM HMOPROD_PLANDATA.dbo.qattribute AS q
	JOIN HMOPROD_PlanData.dbo.memberattribute AS ma WITH(INDEX(XIE1memberattribute), NOLOCK) ON q.attributeid = ma.attributeid -- m.memid = ma.memid  
WHERE q.description LIKE '%CCS%' 
	AND @ReportRunDate BETWEEN ma.effdate AND ma.termdate -- RINA(): APPLIED TO FIELD WITHIN TABLE TO BE UPDATED
	AND CAST(ma.termdate AS date) != CAST(ma.effdate AS date)
	AND CAST(ma.termdate AS datetime) > CAST(ma.effdate AS datetime)

SELECT DISTINCT ' ' AS 'HHP Enrolled + AIDCODE',q.attributeid,q.description,ma.*
-- SELECT DISTINCT q.*,ma.thevalue
FROM HMOPROD_PLANDATA.dbo.qattribute AS q
	JOIN HMOPROD_PlanData.dbo.memberattribute AS ma WITH(INDEX(XIE1memberattribute), NOLOCK) ON q.attributeid = ma.attributeid -- m.memid = ma.memid  
WHERE q.attributeid IN ('C01112777',@whichaidcode)
	AND @ReportRunDate BETWEEN ma.effdate AND ma.termdate -- RINA(): APPLIED TO FIELD WITHIN TABLE TO BE UPDATED
	AND CAST(ma.termdate AS date) != CAST(ma.effdate AS date)
	AND CAST(ma.termdate AS datetime) > CAST(ma.effdate AS datetime)
	-- AND ma.thevalue = 'YES'

SELECT DISTINCT ' ' AS 'AIDCODE: Individuals less than 21 years of age transitioning from incarceration',q.attributeid,q.description,ma.*
-- SELECT DISTINCT q.*,ma.thevalue
FROM HMOPROD_PLANDATA.dbo.qattribute AS q
	JOIN HMOPROD_PlanData.dbo.memberattribute AS ma WITH(INDEX(XIE1memberattribute), NOLOCK) ON q.attributeid = ma.attributeid -- m.memid = ma.memid  
WHERE q.attributeid IN (@whichaidcode)
	AND @ReportRunDate BETWEEN ma.effdate AND ma.termdate -- RINA(): APPLIED TO FIELD WITHIN TABLE TO BE UPDATED
	AND CAST(ma.termdate AS date) != CAST(ma.effdate AS date)
	AND CAST(ma.termdate AS datetime) > CAST(ma.effdate AS datetime)
	AND UPPER(LTRIM(RTRIM(ISNULL(ma.thevalue,'IGNORE')))) IN ('G5','G6','G7','G8','4K','N7','N8','N0','F3','F4','G3','G4') -- = 'YES'

SELECT * 
FROM INFORMATICS2.dbo.SHELLrevcde
--WHERE REVENUE_CODE BETWEEN '0191' AND '0193'
--	OR REVENUE_CODE IN ('0022')
WHERE REVENUE_CODE BETWEEN '191' AND '193'
	OR REVENUE_CODE IN ('022')

/* CASE
WHEN SUBSTRING(LTRIM(RTRIM(ISNULL(cd.revcode,''))),1,1) = 'Z'
THEN  LTRIM(RTRIM(cd.revcode))
WHEN SUBSTRING(LTRIM(RTRIM(ISNULL(cd.revcode,''))),1,1) = '0'
THEN  SUBSTRING(LTRIM(RTRIM(ISNULL(cd.revcode,''))),2,3)
ELSE LTRIM(RTRIM(ISNULL(cd.revcode,'')))
END */

SELECT * 
FROM INFORMATICS2.dbo.SHELLrevcde
--WHERE REVENUE_CODE BETWEEN '0191' AND '0193'
--	OR REVENUE_CODE IN ('0022')
WHERE REVENUE_CODE BETWEEN '191' AND '193'
	OR REVENUE_CODE IN ('022')
	
SELECT DISTINCT alias.diag,alias.[diag descr],'DIAG' AS [code type]
	-- INTO #prindiag
	-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
	-- SELECT DISTINCT ' ' AS 'CHECK 1st'	
	FROM 
	( -- INITIATE ...
	SELECT aliassetup.*,DENSE_RANK() OVER (PARTITION BY aliassetup.claimid ORDER BY aliassetup.sequence ASC,aliassetup.codeid DESC) AS [RANKis]
	FROM 
	( -- INITIATE ...
	SELECT DISTINCT dx.claimid,dx.codeid,UPPER(LTRIM(RTRIM(ISNULL(dx.codeid,'')))) AS [diag],ISNULL(dc.DESCRIPTION,'') AS [diag descr],dx.sequence,dx.poa AS 'PRESENT ON ADMISSION'
	-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
	-- SELECT DISTINCT ' ' AS 'CHECK 1st',
	FROM HMOPROD_PLANDATA.dbo.claimdiag AS dx
		LEFT JOIN HMOPROD_PLANDATA.dbo.DiagCode AS dc ON dx.codeid = dc.codeid
	) -- CONCLUDE
	AS aliassetup
	) -- CONCLUDE
	AS alias
-- WHERE alias.sequence = 1 -- BETWEEN 1 AND 9	
		-- AND alias.[RANKis] = 1
WHERE alias.diag LIKE '%Z59%'

		-- homelessness claims
IF EXISTS( SELECT 1 FROM tempdb.sys.sysobjects WHERE name LIKE '#HomelessClaims%')
	DROP TABLE IF EXISTS #HomelessClaims

  	-- AND mm.InMSSP = 0
	-- AND mm.memid NOT IN 
	-- ( -- INITIATE ...
	-- SELECT MemberId
	-- FROM CM.dbo.uvwCASEMgrRepMembers (NOLOCK)
	-- WHERE CASEManagerTeam = 'SPD'
	-- ) -- CONCLUDE ...

		/* LEFT JOIN HMOPROD_PlANData..memberattribute AS ma WITH(INDEX(XIE1memberattribute), NOLOCK) ON m.memid = ma.memid  
			  AND ma.attributeid = 'C01112777'  
			  AND ma.thevalue = 'yes'  
			  AND GETDATE() BETWEEN ma.effdate AND ma.termdate */
  
		/* LEFT JOIN WPW_Roster wpw(NOLOCK) ON m.secondaryid = wpw.CIN  
		  AND FILE_DATE = (SELECT MAX( FILE_DATE) FROM WPW_Roster)  
		  AND current_statusfinal not like 'exited%'  
		WHERE ErVisitCount >= 5  
			OR (IPAdmitCount + SNFAdmitCount) >= 3 */
 
	/* AND NOT EXISTS (SELECT top 1 p.MemberId
	FROM ProviderPortal.ECM.MembersPendingAssignment p  (NOLOCK)
	WHERE p.MemberId = m.memid) */
	
	/* AND NOT EXISTS (
	SELECT TOP 1 1 
	FROM ProviderPortal.ECM.MembersInformation mi(NOLOCK) 
	WHERE mi.MemberId = m.memid --this should be the alias used in the SP
		AND mi.IsECM=0 --PHM members will have this set to 0 and ECM will have 1
		AND mi.EnrollmentStatus='Enrolled') */

? With SMI Flag from the County. All Payer Claims Database File. 

Children or youth (those younger than 21 yrs of age) with complex physical, and behavioral issues: With SMI Flag from the County. All Payer Claims Database File. 

12 months lookback period for both the SMI flag and diagnosis codes

And/or

/* -- SUD claims
if exists( select 1 from tempdb.sys.sysobjects where name like '#SUDClaims%' )
	drop TABLE IF EXISTS #SUDClaims */







-- ====================================================================
	-- Member CONDITION(s)--
-- ====================================================================
--------------------------------------------------------------------------------------------------------------------
	--Error Trapping: Check If Permanent Table(s) Already Exist(s) And Drop If Applicable--
--------------------------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS #MEMBER_CONDITION; -- SQL Server 2016 and later -- DYNAMIC tmp OR STATIC [TABLE] #TableName is a local temporary table visible only in the current session; #TableName is a GLOBAL temporary table visible to all sessions IN ('TempDB')

-- DECLARE @rundt AS date

-- SET @rundt = GETDATE()

SELECT DISTINCT  'CONDITION' AS Category
,CAST(mc.effdate AS datetime) AS effdate,CAST(mc.termdate AS datetime) AS termdate
,LTRIM(RTRIM(mc.MemId)) AS MemberID
,UPPER(LTRIM(RTRIM(cond.description))) AS [EXPLANATION]
-- INTO #MEMBER_CONDITION

-- SELECT TOP 10 ' ' AS 'CHECK 1st',rt.*,er.*
-- SELECT DISTINCT ' ' AS 'CHECK 1st',cond.*
FROM HMOPROD_PLANDATA.dbo.condition AS cond
	JOIN HMOPROD_PLANDATA.dbo.membercondition AS mc ON LTRIM(RTRIM(mc.conditionid)) = LTRIM(RTRIM(cond.conditionid))
	JOIN HMOPROD_PLANDATA.dbo.member AS m ON mc.memid = m.memid
WHERE cond.description LIKE '%SMI%'
WHERE mc.memid IN (SELECT DISTINCT memid FROM HMOPROD_PlanData.dbo.enrollkeys WHERE carriermemid = '3170045825') -- SAMPLE 
	AND CAST(mc.termdate AS date) != CAST(mc.effdate AS date)
	AND CAST(mc.termdate AS date) > CAST(mc.effdate AS date)

-- ======================================================================
	-- Dx, PROC + REV -- 
-- ======================================================================
SELECT 'Dx - DIAGNOSIS' AS [CodeType],ISNULL(dc.description,'') AS [CodeDescr],dc.*
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st',
FROM HMOPROD_PLANDATA.dbo.DiagCode AS dc 
WHERE dc.codeid BETWEEN 'O00.00' AND 'O99.891'
	OR dc.codeid BETWEEN 'O9A.111' AND 'O9A.519'
	OR dc.codeid BETWEEN 'Z03.71' AND 'Z03.79'
	OR dc.codeid IN ('Z32.01')
	OR dc.codeid BETWEEN 'Z33.1' AND 'Z33.3'
	OR dc.codeid BETWEEN 'Z34.00' AND 'Z34.93'
	OR dc.codeid BETWEEN 'Z36.0' AND 'Z36.9'
	OR dc.codeid IN ('Z36.8A')
	OR dc.codeid BETWEEN 'Z39.1' AND 'Z39.2'

-- WHERE dc.codeid >= 'F8'
	-- AND dc.codeid < 'F9'
	
-- WHERE dc.codeid LIKE 'E08%'
		-- OR dc.codeid LIKE 'E09%'

SELECT 'CPT - PROCEDURE_CODE' AS [CodeType],ISNULL(sc.description,'') AS [CodeDescr],sc.*
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st',
FROM HMOPROD_PLANDATA.dbo.svccode AS sc 
WHERE SUBSTRING(UPPER(LTRIM(RTRIM(ISNULL(sc.codeid,'')))),1,5) IN ('59400','59410','59425','59426','59510','59515','59610','59614','59618','59622','57170','58300','59430')
	OR SUBSTRING(UPPER(LTRIM(RTRIM(ISNULL(sc.codeid,'')))),1,5) BETWEEN '99201' AND '99205'
	OR SUBSTRING(UPPER(LTRIM(RTRIM(ISNULL(sc.codeid,'')))),1,5) BETWEEN '99211' AND '99215'
	OR SUBSTRING(UPPER(LTRIM(RTRIM(ISNULL(sc.codeid,'')))),1,5)BETWEEN '99241' AND '99245'
	OR SUBSTRING(UPPER(LTRIM(RTRIM(ISNULL(sc.codeid,'')))),1,5) IN ('99483','99501','G0101 G0463','H1005','T1015')

/* O00.00- O99.891,
O9A.111- O9A.519,
Z03.71- Z03.79, 
Z32.01, 
Z33.1- Z33.3, 
Z34.00- Z34.93, 
Z36.0- Z36.9,
Z36.8A
Z39.1- Z39.2
59400, 59410, 59425, 59426, 59510, 59515, 59610, 59614, 59618, 59622, 57170, 58300, 59430
99201-99205,
99211-99215,
99241-99245, 
99483, 
99501,
G0101
G0463,
H1005,
T1015 */

		SELECT DISTINCT mm.InMSSP from MemberMonths mm
