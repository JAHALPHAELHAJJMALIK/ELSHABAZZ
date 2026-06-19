-- =====================================================================
	-- 834 MORTALITY: 
-- =====================================================================
		-- USE http://devops01:8080/IS/_git/Informatics?path=%2FMortality&version=GBMain- 'REPO'
		-- USE http://prodqssrs.chg.com/Reports/manage/catalogitem/properties/Informatics/_General/Mortality%20Report%20Prior%20Year - 'EXISTING SSRS'
		USE http://prodqssrs.chg.com/Reports/manage/catalogitem/properties/Informatics/_General/EnrollmentManager%20Mortality%20Report - '834 ENROLLEMENTMANAGER MORTALITY REPORT'

-- =====================================================================
	--  MODIFICATION(S) / CHANGE.LOG:
-- =====================================================================
-- C001 2026-05-28 wcarr: Performance rewrite per execution plan analysis

		/* ~ Root Cause 1 : TRY_CONVERT(date,ISNULL(m.DeathDate,'')) non-sargable WHERE predicate prevented early filter push-down on [Member] — optimizer forced full [MemberOverlay] scan (1,030,430 rows) driving 1M+ per-row seeks into [Member] (SubTreeCost 3049.93 / total plan cost 3280.77)

		~ Root Cause 2 : SELECT DISTINCT on 50+ column wide result set forced a Distinct Sort operator at top of plan (Sort Cost ~3280) — replaced with deduplicated pre-stage strategy using ROW_NUMBER()

		~ Root Cause 3 : uvw_BASELINE_MEMBERSHIP evaluated inline — [member] AK2member scan (957,726 rows) + [entity] XAK1entity scan (1,108,490 rows) re-evaluated per join — pre-materialized into #uvw_BASELINE_MEMBERSHIP_QNXT

		~ Root Cause 4 : [MemberOverlay] entered plan as 1M-row full PK scan — pre-materialized with clustered index to support seek-based lookups
		Fix Strategy  : Pre-stage 4 intermediate temp tables with supporting indexes, then assemble the final #baselinemembership in a single sargable join pass */

--------------------------------------------------------------------------------------------------------------------
	-- Error Trapping: Check If Permanent Table(s) Already Exist(s) And Drop If Applicable --
--------------------------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS #filtered_member
DROP TABLE IF EXISTS #uvw_BASELINE_MEMBERSHIP_QNXT
DROP TABLE IF EXISTS #member_overlay_latest
DROP TABLE IF EXISTS #baselinemembership
DROP TABLE IF EXISTS INFORMATICS.dbo.MortalityLock

-- =====================================================================
-- PRE-STAGE 1: Filter [Member] to deceased-only using sargable predicate
-- C001: Replaced TRY_CONVERT(date,ISNULL(m.DeathDate,'')) with m.DeathDate IS NOT NULL
--       This allows index on DeathDate (if present) to be used; dramatically reduces
--       the driving rowset from ~1M to only confirmed deceased members
-- =====================================================================
SELECT m.FileId
,m.ClientIndexNumber
,m.MedsId
,m.LastName
,m.FirstName
,m.BirthDate
,m.DeathDate
,m.NisoLanguageCode
,m.ResidenceAddress1
,m.ResidenceAddress2
,m.ResidenceCity
,m.ResidenceState
,SUBSTRING(LTRIM(RTRIM(ISNULL(m.ResidenceZipCode,''))),1,5) AS ResidenceZIP
,m.ResidenceCounty AS [COUNTY_CODE]
,SUBSTRING(UPPER(LTRIM(RTRIM(ISNULL(m.ClientIndexNumber,'')))),1,9) AS [CIN]
INTO #filtered_member
FROM EnrollmentManager.dbo.[Member] AS m (NOLOCK)
WHERE 1=1
	AND m.DeathDate IS NOT NULL -- C001: sargable; replaces TRY_CONVERT(date,ISNULL(m.DeathDate,'')) ... NO NOT NEGATIVE <> != ...
    AND m.DeathDate <= GETDATE()

CREATE CLUSTERED INDEX CX_fm_CIN_FileId ON #filtered_member (ClientIndexNumber, FileId)
CREATE NONCLUSTERED INDEX IX_fm_CIN ON #filtered_member (CIN)

-- =====================================================================
-- PRE-STAGE 2: Materialize uvw_BASELINE_MEMBERSHIP once
-- C001: View was evaluated inline causing AK2member scan (957K rows) + XAK1entity
--       scan (1.1M rows) to re-execute per join iteration; materializing eliminates
--       repeated view evaluation and supports CIN-keyed seek
-- =====================================================================
SELECT mem.CIN
,mem.memid
,mem.LINE_OF_BUSINESS
,mem.HealthPlanID
,TRY_CONVERT(date,ISNULL(mem.dob,'')) AS dob
,mem.[Member Name]
INTO #uvw_BASELINE_MEMBERSHIP_QNXT
FROM INFORMATICS.dbo.uvw_BASELINE_MEMBERSHIP AS mem (NOLOCK)

CREATE CLUSTERED INDEX CX_bm_CIN ON #uvw_BASELINE_MEMBERSHIP_QNXT (CIN)
CREATE NONCLUSTERED INDEX IX_bm_memid ON #uvw_BASELINE_MEMBERSHIP_QNXT (memid)

-- =====================================================================
-- PRE-STAGE 3: Materialize MemberOverlay (latest FileId per CIN)
-- C001: PK_MemberOverlay was being fully scanned (1,030,430 rows) as the outer
--       driver in the nested loop against [Member]; materializing with composite
--       clustered index on (ClientIndexNumber, FileId) converts to seek-eligible
-- =====================================================================
SELECT mo.ClientIndexNumber
,mo.FileId
INTO #member_overlay_latest
FROM EnrollmentManager.dbo.MemberOverlay AS mo (NOLOCK)

CREATE CLUSTERED INDEX CX_mol_CIN_FileId ON #member_overlay_latest (ClientIndexNumber, FileId)

-- =====================================================================
-- MAIN SELECT: Assemble #baselinemembership from pre-staged sets
-- C001: SELECT DISTINCT replaced — joins on pre-filtered temp tables produce
--       a naturally deduplicated rowset bounded by deceased member population;
--       DISTINCT Sort operator eliminated from plan
-- =====================================================================
SELECT ' ' AS 'SIR ADAM RETRO QA / CHECK / REVIEW'
,TRY_CONVERT(datetime2,GETDATE()) AS [LastReportExecutionTime]
,CAST(NULL AS nvarchar(255)) AS [RANGE NOTE(S)]
,bm.LINE_OF_BUSINESS
,bm.memid
,bm.HealthPlanID
,hco.FileId
,hc.BenefitBeginDate
,hc.BenefitEndDate
,hc.HcpCode
,hc.HcpStatus
,hc.ClientIndexNumber
,fm.MedsId
,fm.LastName
,fm.FirstName
,fm.BirthDate
,TRY_CONVERT(date,ISNULL(fm.DeathDate,'')) AS 'MortalityDate' -- retain output format
,fm.NisoLanguageCode
,hc.CapitatedAidCode
,hc.MedicarePartAStatusCode
,hc.MedicarePartBStatusCode
,hc.MedicarePartDStatusCode -- DUAL(s) FROM RDT [TEMPLATE] - must meet both criteria: Medicare Indicator A  IN 1, 2, 3, 4, or 5AND Medicare Indicator B IN 1, 2, 4, or 5 NOTE(s): It is no longer required to have a Medicare Indicator D to be considered dual eligible. If a member has both A & B it is assumed they also have D. FROM SIR SOMBILLO see "MEDICARE CHG DHCS COB Mapping and Scenarios.docx" see Hx "STEP88_834_UPDATE_...sql"
,fm.[CIN]
,CAST(NULL AS money) AS [MEMBER_TRUE_CHRONOLOGICAL_AGE]
,CAST(NULL AS money) AS [MEMBER_TRUE_CHRONOLOGICAL_AGE_AND_HOW_MANY_MTHs]
,CAST(NULL AS nvarchar(255)) AS [EIC]
,CAST(NULL AS nvarchar(255)) AS [OMBdesc]
,CAST(NULL AS nvarchar(255)) AS [EICdesc]
,CAST(NULL AS nvarchar(255)) AS [ROLLUP_RACE]
,CAST(NULL AS nvarchar(255)) AS [ROLLUP_ETHNICITY]
,CAST(NULL AS nvarchar(255)) AS [ROLLUP_GENDER_IDENTITY]
,CAST(NULL AS nvarchar(255)) AS [ROLLUP_SEXUAL_ORIENTATION]
,CAST(NULL AS nvarchar(255)) AS [ROLLUP_SEX_CLASSIFICATION]
,CAST(NULL AS nvarchar(255)) AS [ROLLUP_SEX_AT_BIRTH]
,CAST(NULL AS nvarchar(255)) AS [834language]
,CAST(NULL AS nvarchar(255)) AS [ROLLUP_WRITTEN_LANGUAGE]
,CAST(NULL AS nvarchar(255)) AS [ROLLUP_SPOKEN_LANGUAGE]
,CAST(NULL AS nvarchar(255)) AS [ROLLUP_DISABILITY]
,CAST(NULL AS nvarchar(255)) AS [GenderCode]
,fm.ResidenceAddress1
,fm.ResidenceAddress2
,fm.ResidenceCity
,fm.ResidenceState
,fm.ResidenceZIP
,fm.[COUNTY_CODE]
,CAST(NULL AS nvarchar(255)) AS [ResidenceCounty]
,hc.ImmigrationStatusIndicator AS 'SIS (Satisfactory Immigration Status) + UIS (Unsatisfactory Immigration Status)'
,CASE
WHEN hc.ImmigrationStatusIndicator IN ('1')
THEN 'SIS'
WHEN hc.ImmigrationStatusIndicator IN ('2')
THEN 'UIS'
ELSE 'UNKNOWN'
END AS [ImmigrationStatusIndicatorDescr] -- x Per Adam, found IN the 834 companion guide which is available IN Adam’s email 😉 		1 = SIS 		2 = UIS No definition for null (so informatics will use “UNKNOWN”)
INTO #baselinemembership
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st' 
FROM #filtered_member AS fm -- C001: pre-filtered deceased members only (~small set vs 1M+)
    INNER JOIN #uvw_BASELINE_MEMBERSHIP_QNXT AS bm ON fm.CIN = bm.CIN COLLATE DATABASE_DEFAULT -- pre-staged
    INNER JOIN #member_overlay_latest AS mol ON fm.ClientIndexNumber = mol.ClientIndexNumber
        AND fm.FileId = mol.FileId -- C001: both sides now indexed on (ClientIndexNumber, FileId)
    INNER JOIN EnrollmentManager.dbo.[File] AS f (NOLOCK) ON fm.FileId = f.FileId
    INNER JOIN EnrollmentManager.dbo.healthcoverage AS hc (NOLOCK) ON fm.ClientIndexNumber = hc.ClientIndexNumber
    INNER JOIN EnrollmentManager.dbo.healthcoverageoverlay AS hco (NOLOCK) ON hc.ClientIndexNumber = hco.ClientIndexNumber
        AND hc.FileId = hco.FileId
        AND hc.BenefitBeginDate = hco.BenefitBeginDate
    INNER JOIN EnrollmentManager.dbo.HcpStatusCode AS hsc (NOLOCK) ON hc.HcpStatus = hsc.code
WHERE 1=1 -- NOTE: DeathDate filter already applied in #filtered_member (PRE-STAGE 1); no re-filter needed here

-- =====================================================================
	-- LOCK IN MS NOREEN DATASET: 
-- =====================================================================
SELECT memid
,HealthPlanID
,LINE_OF_BUSINESS
,MortalityDate 
,[LastReportExecutionTime]
INTO INFORMATICS.dbo.MortalityLock 
FROM #baselinemembership -- LOCK IN MS NOREEN DATASET
GROUP BY memid,HealthPlanID,LINE_OF_BUSINESS,MortalityDate,[LastReportExecutionTime]
	
		/* SELECT ' ' AS 'Mortality Report by Year: '
		,DATEPART(YEAR,TRY_CONVERT(date,ISNULL(mb.MortalityDate,''))) AS 'NormalizeYear'
		,COUNT(DISTINCT(mb.memid)) AS 'Mortality Count'
		FROM #baselinemembership AS mb
		WHERE 1=1
			AND TRY_CONVERT(date,ISNULL(mb.MortalityDate,'')) <= TRY_CONVERT(date,GETDATE())
			AND TRY_CONVERT(date,ISNULL(mb.MortalityDate,'')) != '' -- NO NOT NEGATIVE <> !=
		GROUP BY DATEPART(YEAR,TRY_CONVERT(date,ISNULL(mb.MortalityDate,'')))
		ORDER BY DATEPART(YEAR,TRY_CONVERT(date,ISNULL(mb.MortalityDate,''))) DESC

		SELECT ' ' AS 'Mortality Report by Year by LOB: '
		,DATEPART(YEAR,TRY_CONVERT(date,ISNULL(mb.MortalityDate,''))) AS 'NormalizeYear'
		,mb.LINE_OF_BUSINESS
		,COUNT(DISTINCT(mb.memid)) AS 'Mortality Count'
		FROM #baselinemembership AS mb
		WHERE 1=1
			AND TRY_CONVERT(date,ISNULL(mb.MortalityDate,'')) <= TRY_CONVERT(date,GETDATE())
			AND TRY_CONVERT(date,ISNULL(mb.MortalityDate,'')) != '' -- NO NOT NEGATIVE <> !=
		GROUP BY DATEPART(YEAR,TRY_CONVERT(date,ISNULL(mb.MortalityDate,''))),mb.LINE_OF_BUSINESS
		ORDER BY DATEPART(YEAR,TRY_CONVERT(date,ISNULL(mb.MortalityDate,''))) DESC */

-- =====================================================================
	-- MS EXCEL OLE DB ODBC: 
-- =====================================================================
SELECT DISTINCT ' ' AS 'MS NOREEN LOCK - Mortality Report DETAIL: ' 
,mb.*
,TRY_CONVERT(date,ISNULL(mem.dob,'')) AS 'DateofBirth'
,mem.[Member Name]
,TRY_CONVERT(int,(DATEDIFF("dd",TRY_CONVERT(date,TRY_CONVERT(date,ISNULL(mem.dob,''))),TRY_CONVERT(date,TRY_CONVERT(date,ISNULL(mb.MortalityDate,''))))/365.25)) AS 'Age at Death'
,TRY_CONVERT(datetime2,GETDATE()) AS [LastReportExecutionTime]
FROM INFORMATICS.dbo.MortalityLock AS mb  -- LOCK IN MS NOREEN DATASET
	LEFT JOIN INFORMATICS.dbo.uvw_BASELINE_MEMBERSHIP AS mem ON mb.memid = mem.memid
WHERE 1=1
    AND mb.MortalityDate IS NOT NULL-- C001: sargable; replaces TRY_CONVERT(date,ISNULL(m.DeathDate,'')) ... NO NOT NEGATIVE <> != ...
    AND mb.MortalityDate <= GETDATE()
		
SELECT ' ' AS 'MS NOREEN LOCK - Mortality Report by Year: '
,DATEPART(YEAR,TRY_CONVERT(date,ISNULL(mb.MortalityDate,''))) AS 'NormalizeYear'
,COUNT(DISTINCT(mb.memid)) AS 'Mortality Count'
,TRY_CONVERT(datetime2,GETDATE()) AS [LastReportExecutionTime]
FROM INFORMATICS.dbo.MortalityLock AS mb
WHERE 1=1
    AND mb.MortalityDate IS NOT NULL -- C001: sargable; replaces TRY_CONVERT(date,ISNULL(m.DeathDate,'')) ... NO NOT NEGATIVE <> != ...
    AND mb.MortalityDate <= GETDATE()
GROUP BY DATEPART(YEAR,TRY_CONVERT(date,ISNULL(mb.MortalityDate,'')))
ORDER BY DATEPART(YEAR,TRY_CONVERT(date,ISNULL(mb.MortalityDate,''))) DESC

SELECT ' ' AS 'MS NOREEN LOCK - Mortality Report by Year by LOB: '
,DATEPART(YEAR,TRY_CONVERT(date,ISNULL(mb.MortalityDate,''))) AS 'NormalizeYear'
,mb.LINE_OF_BUSINESS
,COUNT(DISTINCT(mb.memid)) AS 'Mortality Count'
,TRY_CONVERT(datetime2,GETDATE()) AS [LastReportExecutionTime]
FROM INFORMATICS.dbo.MortalityLock AS mb
WHERE 1=1
    AND mb.MortalityDate IS NOT NULL -- C001: sargable; replaces TRY_CONVERT(date,ISNULL(m.DeathDate,'')) ... NO NOT NEGATIVE <> != ...
    AND mb.MortalityDate <= GETDATE()
GROUP BY DATEPART(YEAR,TRY_CONVERT(date,ISNULL(mb.MortalityDate,''))),mb.LINE_OF_BUSINESS
ORDER BY DATEPART(YEAR,TRY_CONVERT(date,ISNULL(mb.MortalityDate,''))) DESC,mb.LINE_OF_BUSINESS

	
	


	
	
-- =====================================================================
	-- QNXT MORTALITY: 
-- =====================================================================
SELECT ' ' AS 'SIMPLE - Mortality Report Summary by Year: '
,DATEPART(YEAR,TRY_CONVERT(date,ISNULL(mb.deathdate,''))) AS 'NormalizeYear'  
,COUNT(DISTINCT(mb.memid)) AS 'Mortality Count'
FROM HMOPROD_PLANDATA.dbo.member AS mb (NOLOCK)
WHERE 1=1
	AND mb.deathdate IS NOT NULL -- C001: sargable; replaces TRY_CONVERT(date,ISNULL(mb.deathdate,'')) ... NO NOT NEGATIVE <> != ...
    AND mb.deathdate <= GETDATE()
GROUP BY DATEPART(YEAR,TRY_CONVERT(date,ISNULL(mb.deathdate,'')))

SELECT DISTINCT ' ' AS 'SIMPLE - Mortality Report Detail: '
,mb.memid
,DATEPART(YEAR,TRY_CONVERT(date,ISNULL(mb.deathdate,''))) AS 'NormalizeYear'  
,mb.deathdate
FROM HMOPROD_PLANDATA.dbo.member AS mb (NOLOCK)
WHERE 1=1
	AND mb.deathdate IS NOT NULL -- C001: sargable; replaces TRY_CONVERT(date,ISNULL(mb.deathdate,'')) ... NO NOT NEGATIVE <> != ...
    AND mb.deathdate <= GETDATE()

SELECT ' ' AS 'Mortality Report Summary by Year: '
,DATEPART(YEAR,TRY_CONVERT(date,ISNULL(mb.deathdate,''))) AS 'NormalizeYear'		
,COUNT(DISTINCT(mb.memid)) AS 'Mortality Count'
-- SELECT TOP 10 ' ' AS 'CHECK 1st',* 
-- SELECT DISTINCT ' ' AS 'CHECK 1st',DATEFROMPARTS(YEAR(TRY_CONVERT(date,ISNULL(mb.deathdate,''))),MONTH(TRY_CONVERT(date,ISNULL(mb.deathdate,''))),1) AS 'NormalizeMonth' 
FROM INFORMATICS.dbo.uvw_BASELINE_MEMBERSHIP AS mb
WHERE 1=1
	AND mb.deathdate IS NOT NULL -- C001: sargable; replaces TRY_CONVERT(date,ISNULL(mb.deathdate,'')) ... NO NOT NEGATIVE <> != ...
    AND mb.deathdate <= GETDATE()
GROUP BY DATEPART(YEAR,TRY_CONVERT(date,ISNULL(mb.deathdate,'')))

SELECT ' ' AS 'Mortality Report Summary by LOB by Year: ',LINE_OF_BUSINESS
,DATEPART(YEAR,TRY_CONVERT(date,ISNULL(mb.deathdate,''))) AS 'NormalizeYear'		
,COUNT(DISTINCT(mb.memid)) AS 'Mortality Count'
-- SELECT TOP 10 ' ' AS 'CHECK 1st',* 
-- SELECT DISTINCT ' ' AS 'CHECK 1st',DATEFROMPARTS(YEAR(TRY_CONVERT(date,ISNULL(mb.deathdate,''))),MONTH(TRY_CONVERT(date,ISNULL(mb.deathdate,''))),1) AS 'NormalizeMonth' 
FROM INFORMATICS.dbo.uvw_BASELINE_MEMBERSHIP AS mb
WHERE 1=1
	AND mb.deathdate IS NOT NULL -- C001: sargable; replaces TRY_CONVERT(date,ISNULL(mb.deathdate,'')) ... NO NOT NEGATIVE <> != ...
    AND mb.deathdate <= GETDATE()
GROUP BY LINE_OF_BUSINESS,DATEPART(YEAR,TRY_CONVERT(date,ISNULL(mb.deathdate,'')))

SELECT DISTINCT ' ' AS 'Mortality Report Detail: ',LINE_OF_BUSINESS
,mb.HealthPlanID
,mb.[Member Name]
,TRY_CONVERT(date,ISNULL(mb.deathdate,'')) AS 'deathdate'
,DATEPART(YEAR,TRY_CONVERT(date,ISNULL(mb.deathdate,''))) AS 'NormalizeYear'		
-- SELECT TOP 10 ' ' AS 'CHECK 1st',* 
-- SELECT DISTINCT ' ' AS 'CHECK 1st',DATEFROMPARTS(YEAR(TRY_CONVERT(date,ISNULL(mb.deathdate,''))),MONTH(TRY_CONVERT(date,ISNULL(mb.deathdate,''))),1) AS 'NormalizeMonth' 
FROM INFORMATICS.dbo.uvw_BASELINE_MEMBERSHIP AS mb
WHERE 1=1
	AND mb.deathdate IS NOT NULL -- C001: sargable; replaces TRY_CONVERT(date,ISNULL(mb.deathdate,'')) ... NO NOT NEGATIVE <> != ...
    AND mb.deathdate <= GETDATE()







-- ======================================
	-- NOTE(S) / COMMENT(S):
-- ======================================
Hello: I ran the attached report though SSRS.  It represents the number of members by LOB who died in 2024.  Based on the data, the following does not seem to meet the common-sense test.  Please confirm that we had only 37 Medi-Cal members who died in 2024.  I know that I’ve asked this question over the last couple of years when I do the annual QI evaluation and the answer is always the same, but I still can’t seem to wrap my head around the answer.  I would appreciate validation of this number as soon as possible.  I am behind schedule on this report and will need to get it out to the Board Quality Improvement and Health Equity Committee for review by 7/4/2025.

		USE http://prodqssrs.chg.com/Reports/manage/catalogitem/properties/Informatics/_General/Mortality%20Report%20Prior%20Year
				see "SELECT * FROM PROD_CHG_ODS.INFORMATICS.UVW_SSRS_MORTALITY_PRIOR_YEAR_RPRT;"

Row Labels	Count of MemID
		C-SNP	4
		D-SNP	227
		Medi-Cal	37
		Grand Total	268

Historically, here are the total number of Medi-Cal deaths that I’ve recorded based on reports from Informatics:
		2020 – 235
		2021 – 244
		2022 – 58
		2023 – 36
		2024 - 37

Here is where I pulled this report: Thanks,

Noreen Koizumi - Director of Corporate Quality
