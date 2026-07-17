USE [INFORMATICS]
GO

/****** Object:  StoredProcedure [dbo].[sp_CHATGPT_ECMPOF_CHILDMHSMISUD]    Script Date: 6/29/2026 8:22:56 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =====================================================================
-- Author:		WCARR
-- Create date: IN 20230705
-- Description:	ECM POF
-- =====================================================================

-- CREATE OR ALTER PROCEDURE [dbo].[sp_CHATGPT_ECMPOF_CHILDMHSMISUD] -- <Procedure_Name, sysname, ProcedureName> ... DROP PROCEDURE ... EXEC dbo.sp_CHATGPT_ECMPOF_CHILDMHSMISUD;

-- =====================================================================
	-- Add the parameters for the stored procedure here:
-- =====================================================================
		DECLARE @CurrentLOB AS varchar(25) = 'Medi-Cal' -- DEFAULT VAL() 'LOB' OPTION(S): 				C-SNP 				CMC 				D-SNP 				Medi-Cal 				Unknown

-- AS
-- BEGIN

-- =====================================================================
	-- INITIATE STATEMENTS FOR PROCEDURE HERE:
-- =====================================================================
-- =====================================================================
	-- COMMENT(S) / CHANGE.LOG: --
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

		'Child Homeless' REPLACE() SUBSTITUTE() WITH() Child Individuals Experiencing Homelessness
		'Child IP ED High Utilization' REPLACE() SUBSTITUTE() WITH() Child Avoidable Hospital or ED Utilization
		'Child MH SMI SUD' REPLACE() SUBSTITUTE() WITH() Child SMH or SUD
		'Child CCS' REPLACE() SUBSTITUTE() WITH() Child CCS/CCS WCM with Additional Needs
		-- 'Child Welfare' REPLACE() SUBSTITUTE() WITH() Child Welfare
		-- 'Child Transitioning from Incarceration' REPLACE() SUBSTITUTE() WITH() Child Transitioning from Incarceration
		-- 'Child Birth Equity' REPLACE() SUBSTITUTE() WITH() Child Birth Equity */

-- OPT-01: WITH (NOLOCK) → (NOLOCK) per DUB C 2.0 Rule 07 — removed WITH keyword; hint now precedes AS alias on all table refs
-- OPT-02: UNION → UNION ALL per DUB C 2.0 Rule 13 — dedup handled downstream; eliminates unnecessary sort/dedup pass
-- OPT-03: INNER JOIN → INNER JOIN per Rule 10 — explicit INNER JOIN type always required
-- OPT-04: SELECT DISTINCT → SELECT...GROUP BY in DIAG subquery per Rule 12 — GROUP BY preferred over DISTINCT
-- OPT-05: SERVICE IN() — replaced placeholder H0043/H0044 (TransitionalRent codes) with G9919 per JAG ChatGPT Social Complexity crosswalk
-- OPT-06: DIAG IN() — expanded from 8 Z59 codes to full Social Complexity ICD-10 set per JAG ChatGPT crosswalk (7 factors)

-- OPT-07: SMHS ELIGIBILITY GATE ADDED (20260709) — per JAG request, criterion I ('SMHS eligibility determination'). A member must have a county-submitted Specialty Mental Health Services encounter (CHGAPP_PROD.dbo.tblEDIOptumBHServices, CIN-matched via uvw_BASELINE_MEMBERSHIP) within the reporting window. See #SMHSEligible. Per WCARR decision 20260709: this is an ADDITIONAL required gate on top of the existing diagnosis/CPT clinical indicator below (#MHSMISUDClaims / #SMI), NOT a replacement and NOT a population-expanding OR -- a member must ALSO satisfy #ProgramEligible (OPT-07 OR OPT-08) to land in the final population.

-- OPT-08: DMC-ODS/DMC ELIGIBILITY GATE ADDED (20260709) — per JAG request, criterion II ('DMC-ODS/DMC eligibility determination'). A member must have a pharmacy claim (CHGAPP_PROD.APCD.Pharmacy) whose DrugCode matches the qualifying NDC list (INFORMATICS.dbo.DMC_QUALIFYING_NDC_LIST, loaded 20260709 from BUILD-DMC-NDC-List-20260708.xlsx via #PYTHON_EXCEL_TO_SQL_20260709.py) within that NDC's Effective From/To Date window. See #DMCEligible. Same AND-gate relationship as OPT-07 -- satisfying EITHER OPT-07 OR OPT-08 (via #ProgramEligible) is required in addition to the existing clinical indicator, not instead of it.

-- OPT-09: UTILIZATION/RISK CRITERIA — PENDING (20260709). JAG's criterion III ('Utilization/risk criteria') has no confirmed data source yet -- Gabby/Yousaf's 20260708 reply addressed only criteria I and II. #ProgramEligible is therefore CURRENTLY = #SMHSEligible UNION #DMCEligible only. DO NOT invent a utilization/risk threshold here -- once Yousaf/Gabby confirm a source, add a third UNION branch to #ProgramEligible and update this comment. NDC MATCH CAVEAT (20260709): the NDC list's own "Effective To Date*" column carries this disclaimer from DHCS's source list: "The effective end dates are subject to change at any time based on FDA regulations. For the most up-to-date expiration dates, please see https://ndclist.com/search." Additionally, #DMCEligible zero-pads both sides of the NDC match to 11 digits (right-justified) to reconcile varying NDC segment formats (4-4-2 / 5-3-2 / 5-4-1 / 5-4-2) between the Excel- sourced list and CHGAPP_PROD.APCD.Pharmacy.DrugCode -- spot-check matched claims against Drug_Name/Formulary_Drug_Name once this runs against live data to confirm the padding assumption holds for this data set before relying on OPT-08 results.

-- OPT-09b (20260709): DHCS SOURCE CONFIRMED — per the DHCS CalAIM ECM Policy Guide (Updated January 2026), Section "A. Population of Focus Eligibility Criteria — a. Adults with Serious Mental Health and/or SUD Needs" (pg. 25), Adults SMI/SUD eligibility is THREE independent required AND-conditions: (1) Program Eligibility — SMHS delivered by MHPs OR DMC-ODS OR DMC; AND (2) at least one complex social factor; AND (3) meet one or more of: (i) high risk of institutionalization/overdose/suicide, (ii) crisis/ED/urgent care/inpatient stays as primary source of care, (iii) two or more ED visits or two or more hospitalizations due to SMI/SUD in the past 12 months. Utilization/risk (3) is NOT an alternate path into Program Eligibility — once Yousaf/Gabby confirm a source table for (3), build it as its own #UtilizationRisk temp table and INNER JOIN it as a FOURTH independent gate in both final SELECTs, structurally parallel to #SocialComplexity (do NOT UNION it into #ProgramEligible). #ProgramEligible therefore correctly remains = #SMHSEligible UNION #DMCEligible only, now and after (3) is built. DO NOT invent a utilization/risk threshold here. SEPARATE FINDING — CHILD/YOUTH POF: per the same DHCS guide (Section A.b, pg. 25-26), children and youth need ONLY criterion (1) Program Eligibility — "No further criteria are required to be met for children and youth to qualify for this ECM Population of Focus." DHCS does not require a complex social factor or utilization/risk for children/youth. THIS script's existing #SocialComplexity INNER JOIN gate below (pre-existing logic, not part of the current JAG request) is therefore stricter than DHCS requires for the child/youth population — flagged for Walter/JAG review, not altered here since removing it was not part of the current request. NDC MATCH CAVEAT (20260709): the NDC list's own "Effective To Date" column carries this disclaimer from DHCS's source list: "The effective end dates are subject to change at any time based on FDA ...

-- OPT-10 (20260710): UTILIZATION/RISK CRITERION (3) — PARTIALLY BUILT, per Gabby Rubalcava's 20260710 NCQA HEDIS code set reply (POF NCQA HEDIS Technical Specifications 20260710.xlsx -> INFORMATICS.dbo.HEDIS_UTILIZATIONRISK_CODESET) and WCARR's 20260709 proposal to reuse #ERClaims/#IPClaims/#SNFClaims from ECMPOF_ADULT_IPSNFED_HIGHUTIL_20250811.sql. See #UtilizationRisk (built directly below #SocialComplexity) for the full build comment. STATUS: sub-criterion (iii) [two or more ED visits or two or more hospitalizations due to SMI/SUD in 12mo] is fully built; sub-criterion (i) is PARTIALLY built (overdose/suicide diagnosis portions only -- the undiagnosed "institutionalization" portion is flagged, not built, since DHCS's broad footnote-22 definition would otherwise make it true for nearly anyone with any ED/IP/SNF claim); sub-criterion (ii) [primary source of care] is NOT built -- no threshold/definition has been confirmed. DO NOT invent a threshold for the unbuilt portions. Also note: the "Inpatient Hospital" Cx / BILL_TYPE UPDATE against INFORMATICS2.dbo.SHELLunion00_RDT that WCARR originally proposed 20260709 was NOT used for #IPClaims -- that logic runs against a downstream RDT/CCI reporting shell in a different database; #IPClaims instead reuses the native billclasscode IN ('1','2') inpatient definition already proven against this script's own HMOPROD_PlanData source (same pattern as #ERClaims).

-- =====================================================================
	-- DYNAMIC() v. STATIC() DECLARE(s) FOR [CLAIM LISTING REFINEMENT] --
-- =====================================================================
DECLARE @StartDate date = DATEADD(mm,-12,GETDATE())
DECLARE @EndDate date = GETDATE()
DECLARE @ReportRunDate date = GETDATE()
DECLARE @AgeCutoff int = 21
DECLARE @PCPrecordRANK AS int = 1 -- ENTER 1 TO GET() JUST MOST CURRENT [RANKis] see DENSE_RANK() OVER(PARTITION BY ek.memid ORDER BY CAST(ek.effdate AS datetime) DESC) AS [RANKis] --'RANKis' --RANK by MOST CURRENT

		SELECT TOP 1 @AgeCutoff AS [AGE LIMIT < (LESS THAN)],@ReportRunDate AS [RunDate],'BETWEEN '+CAST(CAST(@StartDate AS date) AS varchar(MAX))+' AND '+CAST(CAST(@EndDate AS date) AS varchar(MAX)) AS [RANGE NOTE(s)],*
		FROM INFORMATICS.dbo.MemberMonths







-- ======================================================================
	-- ECM COS (CATEGORY OF SERVICE) --
-- ======================================================================
--------------------------------------------------------------------------------------------------------------------
	-- Error Trapping: Check If Permanent Table(s) Already Exist(s) And Drop If Applicable --
--------------------------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS #SMI; -- SQL Server 2016 and later -- DYNAMIC tmp OR STATIC [TABLE] #TableName is a local temporary table visible only in the current session; ##TableName is a GLOBAL temporary table visible to all sessions IN ('TempDB')

SELECT DISTINCT ' ' AS 'SMI (Serious Mental Illness)'
,mmem.memid,mmem.effdate,mmem.termdate,mem.codeid,CAST(mem.description AS nvarchar(MAX)) AS [CodeDescr]
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st',
INTO #SMI
FROM HMOPROD_PlanData.dbo.memo AS mem (NOLOCK)
	INNER JOIN HMOPROD_PlanData.dbo.membermemo AS mmem (NOLOCK) ON mem.memoid = mmem.memoid
WHERE 1=1
	AND mem.memotype = 'salrt'
	-- AND TRY_CONVERT(date,mem.termdate) >= TRY_CONVERT(date,GETDATE())
	AND TRY_CONVERT(date,mem.effdate) >= @StartDate
	AND TRY_CONVERT(date,mem.effdate) <= @EndDate
	AND mem.codeid = 'MentalHealth'
	-- AND mm.memid = mmem.memid -- FROM INFORMATICS.dbo.MemberMonths AS mm (NOLOCK)

		-- SELECT * FROM #SMI







--------------------------------------------------------------------------------------------------------------------
	-- Error Trapping: Check If Permanent Table(s) Already Exist(s) And Drop If Applicable --
--------------------------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS #MHSMISUDClaims; -- SQL Server 2016 and later -- DYNAMIC tmp OR STATIC [TABLE] #TableName is a local temporary table visible only in the current session; ##TableName is a GLOBAL temporary table visible to all sessions IN ('TempDB')

SELECT DISTINCT c.memid,c.claimid,c.startdate,cdx.codeid,cdx.[diag descr],'DIAG' AS [code type]
,CAST(UPPER(LTRIM(RTRIM(ISNULL(c.memid,'')))) AS varchar(MAX))+CAST(UPPER(LTRIM(RTRIM(ISNULL(TRY_CONVERT(date,c.startdate),'')))) AS varchar(10))+CAST(UPPER(LTRIM(RTRIM(ISNULL(a.provid,'')))) AS varchar(MAX)) AS [AdmitID] -- 'Unique person, date of service, and provider = one visit'  OR 'Unique person, date of service, and NDC = one script'
INTO #MHSMISUDClaims
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st',
FROM HMOPROD_PlanData.dbo.claim AS c (NOLOCK)
	INNER JOIN HMOPROD_PlanData.dbo.claimdetail AS cd (NOLOCK) ON c.claimid = cd.claimid
	INNER JOIN HMOPROD_PlanData.dbo.affiliation AS a (NOLOCK) ON c.affiliationid = a.affiliationid
	INNER JOIN
	( -- INITIATE ...
	SELECT DISTINCT *
	FROM
	( -- INITIATE ...
	SELECT aliassetup.*
	,DENSE_RANK() OVER (PARTITION BY aliassetup.claimid ORDER BY aliassetup.sequence ASC,aliassetup.codeid DESC) AS [RANKis]
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
	WHERE 1=1
		AND alias.diag IN ('F10.920','F10.921','F10.929','F10.930','F10.931','F10.932','F10.939','F10.94','F10.950','F10.951','F10.959','F10.96','F10.97','F10.980','F10.981','F10.982','F10.988','F10.99','F11.90','F11.920','F11.921','F11.922','F11.929','F11.93','F11.94','F11.950','F11.951','F11.959','F11.981','F11.982','F11.988','F11.99','F12.90','F12.920','F12.921','F12.922','F12.929','F12.93','F12.950','F12.951','F12.959','F12.980','F12.988','F12.99','F13.90','F13.920','F13.921','F13.929','F13.930','F13.931','F13.932','F13.939','F13.94','F13.950','F13.951','F13.959','F13.96','F13.97','F13.980','F13.981','F13.982','F13.988','F13.99','F14.90','F14.920','F14.921','F14.922','F14.929','F14.93','F14.94','F14.950','F14.951','F14.959','F14.980','F14.981','F14.982','F14.988','F14.99','F15.90','F15.920','F15.921','F15.922','F15.929','F15.93','F15.94','F15.950','F15.951','F15.959','F15.980','F15.981','F15.982','F15.988','F15.99','F16.90','F16.920','F16.921','F16.929','F16.94','F16.950','F16.951','F16.959','F16.980','F16.983','F16.988','F16.99','F18.90','F18.920','F18.921','F18.929','F18.94','F18.950','F18.951','F18.959','F18.97','F18.980','F18.988','F18.99','F19.90','F19.920','F19.921','F19.922','F19.929','F19.930','F19.931','F19.932','F19.939','F19.94','F19.950','F19.951','F19.959','F19.96','F19.97','F19.980','F19.981','F19.982','F19.988','F19.99') -- SUD diagnosis codes: ICD-10 Code Series F00 to F99
		) -- CONCLUDE ...
		AS cdx ON c.claimid = cdx.claimid
WHERE 1=1
	AND c.startdate >= @StartDate
	AND c.startdate <= @EndDate
	AND
	( -- INITIATE ...
		c.resubclaimid IS NULL
		OR
		c.resubclaimid = ''
	) -- CONCLUDE ...
	AND c.claimid NOT LIKE '%R%' -- NO NOT NEGATIVE != <>
	AND c.[status] in ('ADJUCATED', 'PAID', 'PAY', 'REV', 'REVERSED', 'REVSYNCH')
	AND cd.[status] NOT IN ('DENY','VOID') -- NO NOT NEGATIVE !=

UNION
SELECT DISTINCT c.memid,c.claimid,c.startdate,sc.codeid,ISNULL(sc.description,'') AS [code descr],'CPT' AS [code type]
,CAST(UPPER(LTRIM(RTRIM(ISNULL(c.memid,'')))) AS varchar(MAX))+CAST(UPPER(LTRIM(RTRIM(ISNULL(TRY_CONVERT(date,c.startdate),'')))) AS varchar(10))+CAST(UPPER(LTRIM(RTRIM(ISNULL(a.provid,'')))) AS varchar(MAX)) AS [AdmitID] -- 'Unique person, date of service, and provider = one visit'  OR 'Unique person, date of service, and NDC = one script'
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st',
FROM HMOPROD_PlanData.dbo.claim AS c (NOLOCK)
	INNER JOIN HMOPROD_PlanData.dbo.claimdetail AS cd (NOLOCK) ON c.claimid = cd.claimid
	INNER JOIN HMOPROD_PlanData.dbo.affiliation AS a (NOLOCK) ON c.affiliationid = a.affiliationid
		LEFT JOIN HMOPROD_PLANDATA.dbo.svccode AS sc ON cd.servcode = sc.codeid
WHERE 1=1
	AND c.startdate >= @StartDate
	AND c.startdate <= @EndDate
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

-- TODO (OPT-09b): -- OPT-09b (20260709): DHCS SOURCE CONFIRMED — per the DHCS CalAIM ECM Policy Guide (Updated January 2026), Section "A. Population of Focus Eligibility Criteria — a. Adults with Serious Mental Health and/or SUD Needs" (pg. 25), Adults SMI/SUD eligibility is THREE independent required AND-conditions: (1) Program Eligibility — SMHS delivered by MHPs OR DMC-ODS OR DMC; AND (2) at least one complex social factor; AND (3) meet one or more of: (i) high risk of institutionalization/overdose/suicide, (ii) crisis/ED/urgent care/inpatient stays as primary source of care, (iii) two or more ED visits or two or more hospitalizations due to SMI/SUD in the past 12 months. Utilization/risk (3) is NOT an alternate path into Program Eligibility — once Yousaf/Gabby confirm a source table for (3), build it as its own #UtilizationRisk temp table and INNER JOIN it as a FOURTH independent gate in both final SELECTs, structurally parallel to #SocialComplexity (do NOT UNION it into #ProgramEligible). #ProgramEligible therefore correctly remains = #SMHSEligible UNION #DMCEligible only, now and after (3) is built. DO NOT invent a utilization/risk threshold here. SEPARATE FINDING — CHILD/YOUTH POF: per the same DHCS guide (Section A.b, pg. 25-26), children and youth need ONLY criterion (1) Program Eligibility — "No further criteria are required to be met for children and youth to qualify for this ECM Population of Focus." DHCS does not require a complex social factor or utilization/risk for children/youth. THIS script's existing #SocialComplexity INNER JOIN gate below (pre-existing logic, not part of the current JAG request) is therefore stricter than DHCS requires for the child/youth population — flagged for Walter/JAG review, not altered here since removing it was not part of the current request. NDC MATCH CAVEAT (20260709): the NDC list's own "Effective To Date" column carries this disclaimer from DHCS's source list: "The effective end dates are subject to change at any time based on FDA regulations. For the most up-to-date expiration dates, please see https://ndclist.com/search." Additionally, #DMCEligible zero-pads both sides of the NDC match to 11 digits (right-justified) to reconcile varying NDC segment formats (4-4-2 / 5-3-2 / 5-4-1 / 5-4-2) between the Excel-sourced list and CHGAPP_PROD.APCD.Pharmacy.DrugCode -- spot-check matched claims against Drug_Name/Formulary_Drug_Name once this runs against live data to confirm the padding assumption holds for this data set before relying on OPT-08 results.
) AS pe -- CONCLUDE ...

		-- SELECT * FROM #ProgramEligible







-- ======================================================================
	-- CHATGPT JAG ALGORITHM FOR SOCIAL COMPLEXITY INDICATION:
-- ======================================================================
--------------------------------------------------------------------------------------------------------------------
	-- Error Trapping: Check If Permanent Table(s) Already Exist(s) And Drop If Applicable --
--------------------------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS #SocialComplexity;

SELECT c.memid
,c.claimid
,c.startdate
,cd.servcode AS [codeid]
,ISNULL(sc.[description],'') AS [diag descr]
,'SERVICE' AS [code type]
INTO #SocialComplexity
FROM HMOPROD_PlanData.dbo.claim (NOLOCK) AS c
	INNER JOIN HMOPROD_PlanData.dbo.claimdetail (NOLOCK) AS cd ON c.claimid = cd.claimid
		LEFT JOIN HMOPROD_PlanData.dbo.svccode (NOLOCK) AS sc ON SUBSTRING(UPPER(LTRIM(RTRIM(ISNULL(cd.servcode,'')))),1,5) = SUBSTRING(UPPER(LTRIM(RTRIM(ISNULL(sc.codeid,'')))),1,5)
WHERE 1=1
	AND c.startdate BETWEEN @StartDate AND @EndDate
	AND (c.resubclaimid IS NULL OR c.resubclaimid = '')
	AND c.claimid NOT LIKE '%R%'
	AND c.[status] IN ('ADJUCATED','PAID','PAY','REV','REVERSED','REVSYNCH')
	AND SUBSTRING(UPPER(LTRIM(RTRIM(ISNULL(cd.servcode,'')))),1,5) IN (
	'H0043','H0044' -- Transitional Rent
	,'G9919' -- ACEs Screening Performed; Score >= 4 (High Risk) -- JAG ChatGPT Social Complexity Crosswalk
	)

UNION ALL
SELECT c.memid
,c.claimid
,c.startdate
,cdx.codeid
,cdx.[diag descr]
,'DIAG' AS [code type]
FROM HMOPROD_PlanData.dbo.claim (NOLOCK) AS c
INNER JOIN (
SELECT dx.claimid
,dx.codeid
,dc.DESCRIPTION AS [diag descr]
,dx.sequence
FROM HMOPROD_PLANDATA.dbo.claimdiag (NOLOCK) AS dx
		LEFT JOIN HMOPROD_PLANDATA.dbo.DiagCode (NOLOCK) AS dc ON dx.codeid = dc.codeid
WHERE 1=1
	AND dx.sequence = 1 -- PRIMARY DIAGNOSIS ONLY; expand if secondary positions required per JAG COO review
	AND dx.codeid IN (
	-- LACK OF STABLE HOUSING / HOMELESSNESS / HOUSING INSTABILITY -- JAG ChatGPT Social Complexity Crosswalk
	'Z59.00' -- Homelessness, unspecified
	,'Z59.01' -- Sheltered homelessness
	,'Z59.02' -- Unsheltered homelessness
	,'Z59.10' -- Inadequate housing, unspecified
	,'Z59.11' -- Inadequate housing environmental temperature
	,'Z59.12' -- Inadequate housing utilities
	,'Z59.19' -- Other inadequate housing
	,'Z59.811' -- Housing instability, housed, with risk of homelessness
	,'Z59.812' -- Housing instability, housed, homelessness in past 12 months
	,'Z59.819' -- Housing instability, housed, unspecified
	,'Z59.89' -- Other problems related to housing/economic circumstances
	,'Z59.9' -- Problem related to housing/economic circumstances, unspecified
	-- LACK OF ACCESS TO FOOD / FOOD INSECURITY -- JAG ChatGPT Social Complexity Crosswalk
	,'Z59.41' -- Food insecurity
	,'Z59.48' -- Other specified lack of adequate food
	-- DIFFICULTY ACCESSING TRANSPORTATION -- JAG ChatGPT Social Complexity Crosswalk
	,'Z59.82' -- Transportation insecurity
	-- FORMER FOSTER YOUTH / CHILD WELFARE HISTORY -- JAG ChatGPT Social Complexity Crosswalk
	,'Z62.21' -- Child in welfare custody
	,'Z62.22' -- Institutional upbringing
	,'Z62.29' -- Other upbringing away from parents
	,'Z62.819' -- Personal history of unspecified abuse in childhood
	-- RECENT LAW ENFORCEMENT CONTACT -- JAG ChatGPT Social Complexity Crosswalk
	,'Z65.3' -- Problems related to other legal circumstances
	,'Z65.8' -- Other specified problems related to psychosocial circumstances
	-- INABILITY TO WORK OR ENGAGE IN THE COMMUNITY -- JAG ChatGPT Social Complexity Crosswalk
	,'Z56.0' -- Unemployment
	,'Z56.89' -- Other problems related to employment
	,'Z60.2' -- Problems related to living alone
	,'Z60.4' -- Social exclusion and rejection
	,'Z60.8' -- Other problems related to social environment
	,'Z60.9' -- Problem related to social environment, unspecified
	)
	GROUP BY dx.claimid,dx.codeid,dc.DESCRIPTION,dx.sequence
	) AS cdx ON c.claimid = cdx.claimid
WHERE 1=1
	AND c.startdate BETWEEN @StartDate AND @EndDate
	AND (c.resubclaimid IS NULL OR c.resubclaimid = '')
	AND c.claimid NOT LIKE '%R%'
	AND c.[status] IN ('ADJUCATED','PAID','PAY','REV','REVERSED','REVSYNCH')

		-- SELECT * FROM #SocialComplexity;







-- ======================================================================
	-- #UtilizationRisk -- JAG CRITERION III: UTILIZATION/RISK (PARTIAL BUILD) -- 20260710 --
-- ======================================================================
-- OPT-10 (20260710): Built from Gabby Rubalcava's 20260710 NCQA HEDIS code set (INFORMATICS.dbo.HEDIS_UTILIZATIONRISK_CODESET, loaded via #ALGORITHM_POF_PYTHON_EXCEL_TO_SQL_20260710.py against POF NCQA HEDIS Technical Specifications 20260710.xlsx) plus the #ERClaims/#IPClaims/#SNFClaims claim definitions reused from ECMPOF_ADULT_IPSNFED_HIGHUTIL_20250811.sql (WCARR proposal, 20260709). Per DHCS (OPT-09b), item (3) requires meeting ONE OR MORE of three sub-criteria -- this build covers TWO of the three:
--   (i) PARTIAL -- overdose and suicide portions only, via an ED/IP/SNF claim carrying an Unintentional Drug Overdose or Intentional Self Harm diagnosis (HEDIS FUA/FUM value sets, matched against HMOPROD_PLANDATA.dbo.claimdiag). The undiagnosed "institutionalization" portion of (i) is deliberately NOT built: DHCS footnote 22 defines institutionalization broadly as "any type of inpatient, SNF, long-term, or ED setting," but treating a single historical claim (no diagnosis, no count threshold) as a stand-alone "high risk of institutionalization" flag would make this sub-criterion true for nearly anyone with ANY ED/IP/SNF history in the trailing 12 months -- that is an interpretive threshold call DHCS did not specify, so it is flagged for Walter/JAG direction rather than invented here.
--   (ii) NOT BUILT -- "crisis/ED/urgent care/inpatient stays as PRIMARY source of care" needs a numerator/denominator or proxy definition (e.g. ED/IP share of total encounters in the window) that has not been designed or confirmed with Walter. DO NOT invent this threshold.
--   (iii) BUILT -- two or more distinct ED visits (#ERClaims) OR two or more distinct hospitalizations (#IPClaims), each carrying a Mental Illness or AOD/Alcohol/Opioid/Other-Drug-Abuse-and-Dependence diagnosis (HEDIS FUM/FUA/DSU value sets), counted via the AdmitID dedup key (memid+startdate+provid = one visit) over the same trailing-12-month @StartDate/@EndDate window already declared at the top of this script.

-- Per DHCS's "one or more of" wording, the branches below are UNION'd (an OR), not ANDed. #UtilizationRisk is INNER JOIN'd once, below, as a FOURTH independent required gate -- parallel to #SocialComplexity and #ProgramEligible, per OPT-09b -- in BOTH final SELECTs.
--------------------------------------------------------------------------------------------------------------------
	-- Error Trapping: Check If Permanent Table(s) Already Exist(s) And Drop If Applicable --
--------------------------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS #ODSuicideDiagClaims; -- claims carrying an overdose or intentional self-harm diagnosis -- overdose/suicide portions of sub-criterion (i)

SELECT DISTINCT dx.claimid
INTO #ODSuicideDiagClaims
FROM HMOPROD_PLANDATA.dbo.claimdiag (NOLOCK) AS dx
	INNER JOIN INFORMATICS.dbo.HEDIS_UTILIZATIONRISK_CODESET (NOLOCK) AS hx ON UPPER(LTRIM(RTRIM(ISNULL(dx.codeid,'')))) = UPPER(LTRIM(RTRIM(ISNULL(hx.Code,''))))
WHERE 1=1
	AND hx.Value_Set_Name IN ('Intentional Self Harm','Unintentional Drug Overdose')

--------------------------------------------------------------------------------------------------------------------
	-- Error Trapping: Check If Permanent Table(s) Already Exist(s) And Drop If Applicable --
--------------------------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS #SMISUDDiagClaims; -- claims carrying a Mental Illness or SUD (AOD/Alcohol/Opioid/Other Drug) diagnosis -- 'due to SMI/SUD' qualifier for sub-criterion (iii)

SELECT DISTINCT dx.claimid
INTO #SMISUDDiagClaims
FROM HMOPROD_PLANDATA.dbo.claimdiag (NOLOCK) AS dx
	INNER JOIN INFORMATICS.dbo.HEDIS_UTILIZATIONRISK_CODESET (NOLOCK) AS hx ON UPPER(LTRIM(RTRIM(ISNULL(dx.codeid,'')))) = UPPER(LTRIM(RTRIM(ISNULL(hx.Code,''))))
WHERE 1=1
	AND hx.Value_Set_Name IN ('Mental Illness','AOD Abuse and Dependence','Alcohol Abuse and Dependence','Opioid Abuse and Dependence','Other Drug Abuse and Dependence')

--------------------------------------------------------------------------------------------------------------------
	-- Error Trapping: Check If Permanent Table(s) Already Exist(s) And Drop If Applicable --
--------------------------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS #ERClaims; -- ED claim definition reused verbatim from ECMPOF_ADULT_IPSNFED_HIGHUTIL_20250811.sql

SELECT c.memid
,c.claimid
,c.startdate
,a.affiliateid
,cd.dosfrom
,CAST(UPPER(LTRIM(RTRIM(ISNULL(c.memid,'')))) AS varchar(MAX))+CAST(UPPER(LTRIM(RTRIM(ISNULL(TRY_CONVERT(date,c.startdate),'')))) AS varchar(10))+CAST(UPPER(LTRIM(RTRIM(ISNULL(a.provid,'')))) AS varchar(MAX)) AS [AdmitID] -- 'Unique person, date of service, and provider = one visit'
INTO #ERClaims
FROM HMOPROD_PlanData.dbo.claim (NOLOCK) AS c
	INNER JOIN HMOPROD_PlanData.dbo.claimdetail (NOLOCK) AS cd ON c.claimid = cd.claimid
	INNER JOIN HMOPROD_PlanData.dbo.affiliation (NOLOCK) AS a ON c.affiliationid = a.affiliationid
WHERE 1=1
	AND c.startdate >= @StartDate
	AND c.startdate <= @EndDate
	AND (c.resubclaimid IS NULL OR c.resubclaimid = '')
	AND c.claimid NOT LIKE '%R%'
	AND c.[status] IN ('ADJUCATED','PAID','PAY','REV','REVERSED','REVSYNCH')
	AND c.facilitycode = '1'
	AND c.billclasscode IN ('3','4')
	AND cd.[status] NOT IN ('DENY','VOID')
	AND cd.revcode BETWEEN '0450' AND '0459'

--------------------------------------------------------------------------------------------------------------------
	-- Error Trapping: Check If Permanent Table(s) Already Exist(s) And Drop If Applicable --
--------------------------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS #IPClaims; -- inpatient claim definition reused verbatim from ECMPOF_ADULT_IPSNFED_HIGHUTIL_20250811.sql -- NOTE 20260710: this replaces WCARR's original 20260709 proposal to reuse the 'Inpatient Hospital' Cx / BILL_TYPE UPDATE against INFORMATICS2.dbo.SHELLunion00_RDT -- that logic runs against a DOWNSTREAM RDT/CCI reporting shell table in a different database, not the HMOPROD_PlanData source this script (and #ERClaims/#SocialComplexity/etc.) is built on. billclasscode IN ('1','2') is the native, already-proven inpatient definition against the SAME source system -- see #IPClaims in ECMPOF_ADULT_IPSNFED_HIGHUTIL_20250811.sql

SELECT c.memid
,c.claimid
,c.startdate
,a.affiliateid
,cd.dosfrom
,CAST(UPPER(LTRIM(RTRIM(ISNULL(c.memid,'')))) AS varchar(MAX))+CAST(UPPER(LTRIM(RTRIM(ISNULL(TRY_CONVERT(date,c.startdate),'')))) AS varchar(10))+CAST(UPPER(LTRIM(RTRIM(ISNULL(a.provid,'')))) AS varchar(MAX)) AS [AdmitID] -- 'Unique person, date of service, and provider = one visit'
INTO #IPClaims
FROM HMOPROD_PlanData.dbo.claim (NOLOCK) AS c
	INNER JOIN HMOPROD_PlanData.dbo.claimdetail (NOLOCK) AS cd ON c.claimid = cd.claimid
	INNER JOIN HMOPROD_PlanData.dbo.affiliation (NOLOCK) AS a ON c.affiliationid = a.affiliationid
WHERE 1=1
	AND c.startdate >= @StartDate
	AND c.startdate <= @EndDate
	AND (c.resubclaimid IS NULL OR c.resubclaimid = '')
	AND c.claimid NOT LIKE '%R%'
	AND c.[status] IN ('ADJUCATED','PAID','PAY','REV','REVERSED','REVSYNCH')
	AND c.facilitycode = '1'
	AND c.billclasscode IN ('1','2')

--------------------------------------------------------------------------------------------------------------------
	-- Error Trapping: Check If Permanent Table(s) Already Exist(s) And Drop If Applicable --
--------------------------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS #SNFClaims; -- SNF/institutional claim definition reused from ECMPOF_ADULT_IPSNFED_HIGHUTIL_20250811.sql -- 3-way UNION: NF revenue codes, SNF revenue code, and facility-type-based SNF claims -- source file's plain UNION changed to UNION ALL per DUB C 2.0 Rule 13, since #UtilizationRisk already DISTINCTs on memid and COUNT(DISTINCT AdmitID) downstream

SELECT c.memid
,c.claimid
,c.startdate
,a.affiliateid
,cd.dosfrom
,CAST(UPPER(LTRIM(RTRIM(ISNULL(c.memid,'')))) AS varchar(MAX))+CAST(UPPER(LTRIM(RTRIM(ISNULL(TRY_CONVERT(date,c.startdate),'')))) AS varchar(10))+CAST(UPPER(LTRIM(RTRIM(ISNULL(a.provid,'')))) AS varchar(MAX)) AS [AdmitID]
INTO #SNFClaims
FROM HMOPROD_PlanData.dbo.claim (NOLOCK) AS c
	INNER JOIN HMOPROD_PlanData.dbo.claimdetail (NOLOCK) AS cd ON c.claimid = cd.claimid
	INNER JOIN HMOPROD_PlanData.dbo.affiliation (NOLOCK) AS a ON c.affiliationid = a.affiliationid
WHERE 1=1
	AND c.startdate >= @StartDate
	AND c.startdate <= @EndDate
	AND (c.resubclaimid IS NULL OR c.resubclaimid = '')
	AND c.claimid NOT LIKE '%R%'
	AND c.[status] IN ('ADJUCATED','PAID','PAY','REV','REVERSED','REVSYNCH')
	AND cd.[status] NOT IN ('DENY','VOID')
	AND cd.revcode BETWEEN '0191' AND '0193'

UNION ALL
SELECT c.memid
,c.claimid
,c.startdate
,a.affiliateid
,cd.dosfrom
,CAST(UPPER(LTRIM(RTRIM(ISNULL(c.memid,'')))) AS varchar(MAX))+CAST(UPPER(LTRIM(RTRIM(ISNULL(TRY_CONVERT(date,c.startdate),'')))) AS varchar(10))+CAST(UPPER(LTRIM(RTRIM(ISNULL(a.provid,'')))) AS varchar(MAX)) AS [AdmitID]
FROM HMOPROD_PlanData.dbo.claim (NOLOCK) AS c
	INNER JOIN HMOPROD_PlanData.dbo.claimdetail (NOLOCK) AS cd ON c.claimid = cd.claimid
	INNER JOIN HMOPROD_PlanData.dbo.affiliation (NOLOCK) AS a ON c.affiliationid = a.affiliationid
WHERE 1=1
	AND c.startdate >= @StartDate
	AND c.startdate <= @EndDate
	AND (c.resubclaimid IS NULL OR c.resubclaimid = '')
	AND c.claimid NOT LIKE '%R%'
	AND c.[status] IN ('ADJUCATED','PAID','PAY','REV','REVERSED','REVSYNCH')
	AND cd.[status] NOT IN ('DENY','VOID')
	AND cd.revcode IN ('0022')

UNION ALL
SELECT c.memid
,c.claimid
,c.startdate
,a.affiliateid
,cd.dosfrom
,CAST(UPPER(LTRIM(RTRIM(ISNULL(c.memid,'')))) AS varchar(MAX))+CAST(UPPER(LTRIM(RTRIM(ISNULL(TRY_CONVERT(date,c.startdate),'')))) AS varchar(10))+CAST(UPPER(LTRIM(RTRIM(ISNULL(a.provid,'')))) AS varchar(MAX)) AS [AdmitID]
FROM HMOPROD_PlanData.dbo.claim (NOLOCK) AS c
	INNER JOIN HMOPROD_PlanData.dbo.claimdetail (NOLOCK) AS cd ON c.claimid = cd.claimid
	INNER JOIN HMOPROD_PlanData.dbo.affiliation (NOLOCK) AS a ON c.affiliationid = a.affiliationid
WHERE 1=1
	AND c.startdate >= @StartDate
	AND c.startdate <= @EndDate
	AND (c.resubclaimid IS NULL OR c.resubclaimid = '')
	AND c.claimid NOT LIKE '%R%'
	AND c.[status] IN ('ADJUCATED','PAID','PAY','REV','REVERSED','REVSYNCH')
	AND c.facilitycode = '2'
	AND c.billclasscode IN ('2','3')

--------------------------------------------------------------------------------------------------------------------
	-- Error Trapping: Check If Permanent Table(s) Already Exist(s) And Drop If Applicable --
--------------------------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS #UtilizationRisk; -- final OR of the two built sub-criteria -- see OPT-10 header comment above for what is and is NOT included

SELECT DISTINCT memid
INTO #UtilizationRisk
FROM
( -- INITIATE ...
SELECT er.memid -- sub-criterion (i), overdose/suicide portion: ED visit carrying an overdose or self-harm diagnosis
FROM #ERClaims AS er
	INNER JOIN #ODSuicideDiagClaims AS ods ON er.claimid = ods.claimid

UNION
SELECT ip.memid -- sub-criterion (i), overdose/suicide portion: inpatient stay carrying an overdose or self-harm diagnosis
FROM #IPClaims AS ip
	INNER JOIN #ODSuicideDiagClaims AS ods ON ip.claimid = ods.claimid

UNION
SELECT sn.memid -- sub-criterion (i), overdose/suicide portion: SNF/institutional stay carrying an overdose or self-harm diagnosis
FROM #SNFClaims AS sn
	INNER JOIN #ODSuicideDiagClaims AS ods ON sn.claimid = ods.claimid

UNION
SELECT er.memid -- sub-criterion (iii): two or more distinct ED visits due to SMI/SUD in the trailing 12 months
FROM #ERClaims AS er
	INNER JOIN #SMISUDDiagClaims AS sd ON er.claimid = sd.claimid
GROUP BY er.memid
HAVING COUNT(DISTINCT er.AdmitID) >= 2

UNION
SELECT ip.memid -- sub-criterion (iii): two or more distinct hospitalizations due to SMI/SUD in the trailing 12 months
FROM #IPClaims AS ip
	INNER JOIN #SMISUDDiagClaims AS sd ON ip.claimid = sd.claimid
GROUP BY ip.memid
HAVING COUNT(DISTINCT ip.AdmitID) >= 2
) AS ur -- CONCLUDE ...

		-- SELECT * FROM #UtilizationRisk







--------------------------------------------------------------------------------------------------------------------
	-- Error Trapping: Check If Permanent Table(s) Already Exist(s) And Drop If Applicable --
--------------------------------------------------------------------------------------------------------------------
-- TRUNCATE TABLE INFORMATICS.dbo.CHATGPT_ECMPOF_CHILD_MHSMISUD; -- SQL Server 2016 and later -- DYNAMIC tmp OR STATIC [TABLE] #TableName is a local temporary table visible only in the current session; ##TableName is a GLOBAL temporary table visible to all sessions IN ('TempDB')

-- DROP TABLE IF EXISTS INFORMATICS.dbo.CHATGPT_ECMPOF_CHILD_MHSMISUD; -- SQL Server 2016 and later -- DYNAMIC tmp OR STATIC [TABLE] #TableName is a local temporary table visible only in the current session; ##TableName is a GLOBAL temporary table visible to all sessions IN ('TempDB')

INSERT INTO INFORMATICS.dbo.CHATGPT_ECMPOF_CHILD_MHSMISUD -- (FIELD(S) IN PLAY,...)

SELECT finalinsert.*
FROM 
( -- INITIATE ...
SELECT DISTINCT 'Child SMH or SUD' AS [TargetPopulation],@AgeCutoff AS [AGE LIMIT < (LESS THAN)],@ReportRunDate AS [RunDate],'BETWEEN '+CAST(CAST(@StartDate AS date) AS varchar(MAX))+' AND '+CAST(CAST(@EndDate AS date) AS varchar(MAX)) AS [RANGE NOTE(s)]
,mm.memid,mm.carriermemid,mm.secondaryid,TRY_CONVERT(date,sme.dob) AS [Date of Birth],ent.lastname,ent.firstname,ent.middlename
,[MEMBER_AGE] = CAST(DATEDIFF("dd",CAST(sme.dob AS datetime),TRY_CONVERT(date,@ReportRunDate))/365.25 AS money)
,[MEMBER_TRUE_CHRONOLOGICAL_AGE] = CAST(SUBSTRING(CAST(CAST(DATEDIFF("dd",TRY_CONVERT(date,sme.dob),TRY_CONVERT(date,@ReportRunDate))/365.25 AS money) AS nvarchar(25)),1,CHARINDEX('.',CAST(DATEDIFF("dd",TRY_CONVERT(date,sme.dob),TRY_CONVERT(date,@ReportRunDate))/365.25 AS money),1)-1) AS int)
,h.codeid AS [code],h.[diag descr] AS [code descr],h.[code type]
,UPPER(LTRIM(RTRIM(ent.Phyaddr1))) AS [PhyAddress1]
,UPPER(LTRIM(RTRIM(ent.Phyaddr2))) AS [PhyAddress2]
,UPPER(LTRIM(RTRIM(ent.Phycity))) AS [PhyCity]
,UPPER(LTRIM(RTRIM(ent.Phystate))) AS [PhyState]
,UPPER(LTRIM(RTRIM(ISNULL(ent.Phycounty,'UNDEFINED COUNTY')))) AS [PhyCounty] --�	County, if Plan is multi-county
,CASE
WHEN SUBSTRING(LTRIM(RTRIM(ISNULL(CAST(ent.Phyzip AS nvarchar(25)),''))),1,1) = '0'
THEN '0'+ SUBSTRING(LTRIM(RTRIM(ISNULL(CAST(ent.Phyzip AS nvarchar(25)),''))),2,4)
WHEN SUBSTRING(LTRIM(RTRIM(ISNULL(CAST(ent.Phyzip AS nvarchar(25)),''))),1,1) = '00'
THEN '00'+ SUBSTRING(LTRIM(RTRIM(ISNULL(CAST(ent.Phyzip AS nvarchar(25)),''))),3,3)
ELSE  SUBSTRING(LTRIM(RTRIM(ISNULL(CAST(ent.Phyzip AS nvarchar(25)),''))),1,5)
END AS [PhyZip]
,UPPER(LTRIM(RTRIM(ent.addr1))) AS [MailingAddress1]
,UPPER(LTRIM(RTRIM(ent.addr2))) AS [MailingAddress2]
,UPPER(LTRIM(RTRIM(ent.city))) AS [MailingCity]
,UPPER(LTRIM(RTRIM(ent.state))) AS [MailingState]
,UPPER(LTRIM(RTRIM(ISNULL(ent.county,'UNDEFINED COUNTY')))) AS [MailingCounty] --�	County, if Plan is multi-county
,CASE
WHEN SUBSTRING(LTRIM(RTRIM(ISNULL(CAST(ent.zip AS nvarchar(25)),''))),1,1) = '0'
THEN '0'+ SUBSTRING(LTRIM(RTRIM(ISNULL(CAST(ent.zip AS nvarchar(25)),''))),2,4)
WHEN SUBSTRING(LTRIM(RTRIM(ISNULL(CAST(ent.zip AS nvarchar(25)),''))),1,1) = '00'
THEN '00'+ SUBSTRING(LTRIM(RTRIM(ISNULL(CAST(ent.zip AS nvarchar(25)),''))),3,3)
ELSE  SUBSTRING(LTRIM(RTRIM(ISNULL(CAST(ent.zip AS nvarchar(25)),''))),1,5)
END AS [MailingZip]
,[TELEPHONE] = CASE
WHEN LTRIM(RTRIM(ent.phone)) = ''
THEN SUBSTRING(REPLACE(LTRIM(RTRIM(ent.emerphone)),'-',''),1,10)
ELSE SUBSTRING(REPLACE(LTRIM(RTRIM(ent.phone)),'-',''),1,10)
END,ent.emerphone,ent.faxphone,ent.mobilephone,ent.pagerphone,ent.secfaxphone,ent.secphone,ent.SecureFaxPhone
,UPPER(LTRIM(RTRIM(ISNULL(ent.email,'')))) AS [eMAIL]
,ISNULL(pcp.PAYTONM,'NO PCP REQUIRED') AS [PCPs Pay To]
-- INTO INFORMATICS.dbo.CHATGPT_ECMPOF_CHILD_MHSMISUD
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st',
FROM INFORMATICS.dbo.MemberMonths AS mm (NOLOCK)
	INNER JOIN #MHSMISUDClaims AS h ON mm.memid = h.memid
	INNER JOIN #SocialComplexity AS tr ON h.memid = tr.memid
	INNER JOIN #ProgramEligible AS pe ON mm.memid = pe.memid -- OPT-07/OPT-08: must ALSO be SMHS- or DMC-ODS/DMC-eligible
	INNER JOIN #UtilizationRisk AS ur ON mm.memid = ur.memid -- OPT-10: must ALSO meet DHCS utilization/risk criterion (3) -- built sub-parts only, see #UtilizationRisk header comment	
		LEFT JOIN HMOPROD_PLANDATA.dbo.member AS sme ON mm.memid = sme.memid
		LEFT JOIN HMOPROD_PLANDATA.dbo.entity AS ent ON sme.entityid = ent.entid
		LEFT JOIN INFORMATICS.dbo.uvw_PCP AS pcp ON mm.memid = pcp.memid
			AND pcp.[RANKis] = @PCPrecordRANK -- CURRENT OR LAST PCP Ax
			AND pcp.[ROWis] = @PCPrecordRANK -- CURRENT OR LAST PCP Ax
WHERE 1=1
	AND mm.CurrentMonth = 1 -- CURRENTLY ACTIVE OR ... LOB AT REPORT EXEC
	AND mm.LOB IN (@CurrentLOB)
	AND CAST(SUBSTRING(CAST(CAST(DATEDIFF("dd",TRY_CONVERT(date,sme.dob),TRY_CONVERT(date,@ReportRunDate))/365.25 AS money) AS nvarchar(25)),1,CHARINDEX('.',CAST(DATEDIFF("dd",TRY_CONVERT(date,sme.dob),TRY_CONVERT(date,@ReportRunDate))/365.25 AS money),1)-1) AS int) < @AgeCutoff

	AND mm.memid NOT IN
	( -- INITIATE ...
	SELECT DISTINCT ccmcm.memberid
	FROM
	( -- INITIATE ...
	SELECT ' ' AS 'MS KATHRYN ENROLLED CCM / CM IDENTIFICATION'
	,'Y' AS [CCMflag],mi.memberid,lcm.Name AS CareMgrName
	FROM ProviderPortal.ecm.MembersInformation AS mi (NOLOCK)

		CROSS APPLY (
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
	) -- CONCLUDE ...
	AS ccmcm
	) -- CONCLUDE ...

UNION
SELECT DISTINCT 'Child SMH or SUD' AS [TargetPopulation],@AgeCutoff AS [AGE LIMIT < (LESS THAN)],@ReportRunDate AS [RunDate],'BETWEEN '+CAST(CAST(@StartDate AS date) AS varchar(MAX))+' AND '+CAST(CAST(@EndDate AS date) AS varchar(MAX)) AS [RANGE NOTE(s)]
,mm.memid,mm.carriermemid,mm.secondaryid,TRY_CONVERT(date,sme.dob) AS [Date of Birth],ent.lastname,ent.firstname,ent.middlename
,[MEMBER_AGE] = CAST(DATEDIFF("dd",CAST(sme.dob AS datetime),TRY_CONVERT(date,@ReportRunDate))/365.25 AS money)
,[MEMBER_TRUE_CHRONOLOGICAL_AGE] = CAST(SUBSTRING(CAST(CAST(DATEDIFF("dd",TRY_CONVERT(date,sme.dob),TRY_CONVERT(date,@ReportRunDate))/365.25 AS money) AS nvarchar(25)),1,CHARINDEX('.',CAST(DATEDIFF("dd",TRY_CONVERT(date,sme.dob),TRY_CONVERT(date,@ReportRunDate))/365.25 AS money),1)-1) AS int)
,h.codeid AS [code],h.[CodeDescr] AS [code descr],'SMI' AS [code type]
,UPPER(LTRIM(RTRIM(ent.Phyaddr1))) AS [PhyAddress1]
,UPPER(LTRIM(RTRIM(ent.Phyaddr2))) AS [PhyAddress2]
,UPPER(LTRIM(RTRIM(ent.Phycity))) AS [PhyCity]
,UPPER(LTRIM(RTRIM(ent.Phystate))) AS [PhyState]
,UPPER(LTRIM(RTRIM(ISNULL(ent.Phycounty,'UNDEFINED COUNTY')))) AS [PhyCounty] --�	County, if Plan is multi-county
,CASE
WHEN SUBSTRING(LTRIM(RTRIM(ISNULL(CAST(ent.Phyzip AS nvarchar(25)),''))),1,1) = '0'
THEN '0'+ SUBSTRING(LTRIM(RTRIM(ISNULL(CAST(ent.Phyzip AS nvarchar(25)),''))),2,4)
WHEN SUBSTRING(LTRIM(RTRIM(ISNULL(CAST(ent.Phyzip AS nvarchar(25)),''))),1,1) = '00'
THEN '00'+ SUBSTRING(LTRIM(RTRIM(ISNULL(CAST(ent.Phyzip AS nvarchar(25)),''))),3,3)
ELSE  SUBSTRING(LTRIM(RTRIM(ISNULL(CAST(ent.Phyzip AS nvarchar(25)),''))),1,5)
END AS [PhyZip]
,UPPER(LTRIM(RTRIM(ent.addr1))) AS [MailingAddress1]
,UPPER(LTRIM(RTRIM(ent.addr2))) AS [MailingAddress2]
,UPPER(LTRIM(RTRIM(ent.city))) AS [MailingCity]
,UPPER(LTRIM(RTRIM(ent.state))) AS [MailingState]
,UPPER(LTRIM(RTRIM(ISNULL(ent.county,'UNDEFINED COUNTY')))) AS [MailingCounty] --�	County, if Plan is multi-county
,CASE
WHEN SUBSTRING(LTRIM(RTRIM(ISNULL(CAST(ent.zip AS nvarchar(25)),''))),1,1) = '0'
THEN '0'+ SUBSTRING(LTRIM(RTRIM(ISNULL(CAST(ent.zip AS nvarchar(25)),''))),2,4)
WHEN SUBSTRING(LTRIM(RTRIM(ISNULL(CAST(ent.zip AS nvarchar(25)),''))),1,1) = '00'
THEN '00'+ SUBSTRING(LTRIM(RTRIM(ISNULL(CAST(ent.zip AS nvarchar(25)),''))),3,3)
ELSE  SUBSTRING(LTRIM(RTRIM(ISNULL(CAST(ent.zip AS nvarchar(25)),''))),1,5)
END AS [MailingZip]
,[TELEPHONE] = CASE
WHEN LTRIM(RTRIM(ent.phone)) = ''
THEN SUBSTRING(REPLACE(LTRIM(RTRIM(ent.emerphone)),'-',''),1,10)
ELSE SUBSTRING(REPLACE(LTRIM(RTRIM(ent.phone)),'-',''),1,10)
END,ent.emerphone,ent.faxphone,ent.mobilephone,ent.pagerphone,ent.secfaxphone,ent.secphone,ent.SecureFaxPhone
,UPPER(LTRIM(RTRIM(ISNULL(ent.email,'')))) AS [eMAIL]
,ISNULL(pcp.PAYTONM,'NO PCP REQUIRED') AS [PCPs Pay To]
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st',
FROM INFORMATICS.dbo.MemberMonths AS mm (NOLOCK)
	INNER JOIN #SMI AS h ON mm.memid = h.memid
	INNER JOIN #SocialComplexity AS tr ON h.memid = tr.memid
	INNER JOIN #ProgramEligible AS pe ON mm.memid = pe.memid -- OPT-07/OPT-08: must ALSO be SMHS- or DMC-ODS/DMC-eligible
	INNER JOIN #UtilizationRisk AS ur ON mm.memid = ur.memid -- OPT-10: must ALSO meet DHCS utilization/risk criterion (3) -- built sub-parts only, see #UtilizationRisk header comment
		LEFT JOIN HMOPROD_PLANDATA.dbo.member AS sme ON mm.memid = sme.memid
		LEFT JOIN HMOPROD_PLANDATA.dbo.entity AS ent ON sme.entityid = ent.entid
		LEFT JOIN INFORMATICS.dbo.uvw_PCP AS pcp ON mm.memid = pcp.memid
			AND pcp.[RANKis] = @PCPrecordRANK -- CURRENT OR LAST PCP Ax
			AND pcp.[ROWis] = @PCPrecordRANK -- CURRENT OR LAST PCP Ax
WHERE 1=1
	AND mm.CurrentMonth = 1 -- CURRENTLY ACTIVE OR ... LOB AT REPORT EXEC
	AND mm.LOB IN (@CurrentLOB)
	AND CAST(SUBSTRING(CAST(CAST(DATEDIFF("dd",TRY_CONVERT(date,sme.dob),TRY_CONVERT(date,@ReportRunDate))/365.25 AS money) AS nvarchar(25)),1,CHARINDEX('.',CAST(DATEDIFF("dd",TRY_CONVERT(date,sme.dob),TRY_CONVERT(date,@ReportRunDate))/365.25 AS money),1)-1) AS int) < @AgeCutoff

	AND mm.memid NOT IN
	( -- INITIATE ...
	SELECT DISTINCT ccmcm.memberid
	FROM
	( -- INITIATE ...
	SELECT ' ' AS 'MS KATHRYN ENROLLED CCM / CM IDENTIFICATION'
	,'Y' AS [CCMflag],mi.memberid,lcm.Name AS CareMgrName
	FROM ProviderPortal.ecm.MembersInformation AS mi (NOLOCK)

		CROSS APPLY (
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
	) -- CONCLUDE ...
	AS ccmcm
	) -- CONCLUDE ...
	) -- CONCLUDE ...
	AS finalinsert

-- Display results
		-- SELECT * FROM INFORMATICS.dbo.CHATGPT_ECMPOF_CHILD_MHSMISUD

		SELECT 'ECM POF Child SMH or SUD' AS ' '
		,bp.LINE_OF_BUSINESS AS 'LOB AT REPORT EXEC'
		,COUNT(DISTINCT(pof.memid)) AS [Unique Member Count]
		FROM INFORMATICS.dbo.CHATGPT_ECMPOF_CHILD_MHSMISUD AS pof
			INNER JOIN INFORMATICS.dbo.uvw_BASELINE_MEMBERSHIP AS bp ON pof.memid = bp.memid  -- HMOPROD_PLANDATA.dbo.benefitplan + HMOPROD_PLANDATA.dbo.program
		WHERE 1=1
			-- AND bp.LINE_OF_BUSINESS IN ('DSNP'); -- ('CSNP','CMC','MEDICARE ADVANTAGE','DSNP','MEDI-CAL')
		GROUP BY bp.LINE_OF_BUSINESS;
-- =====================================================================
	-- CONCLUDE STATEMENTS FOR PROCEDURE HERE:
-- =====================================================================
--END
--GO
