-- =====================================================================
	--  MODIFICATION(S) / CHANGE.LOG:
-- =====================================================================
-- C001: ADD claimdrg 'MS-DRG (Medicare Severity Diagnosis Related Groups) CODES' TO DETAIL AS OF 20240523

-- C002: PER BRD / NARRATIVE "D-SNP Transmission of Admission Notification Narrative 04-01-2026 (002).docx"
 
		/* COPT: PERFORMANCE OPTIMIZATION - FOUR ROOT CAUSES IDENTIFIED FROM EXECUTION PLAN
		ANALYSIS AS OF 20260421 (wcarr):

		ROOT CAUSE 1 - CATASTROPHIC HASH MATCH (2.07e15 ESTIMATED ROWS):
				The three-branch UNION in setclaim joined claimdetail inside the
				CTE scope, then CLAIMDATA re-joined claim again, then the final SELECT
				re-joined claimdetail a third time. SQL Server's optimizer could not
				push predicates through the UNION boundary, forcing a full scan of
				all ~157M claimdetail rows and producing a ~2 quadrillion row
				intermediate estimate before filtering. EstimatedTotalSubtreeCost
				reached 13,481,400,000,000 (13.5 TRILLION).
				FIX: Pre-stage qualifying claimids into #QUALIFYING_CLAIMS with
				targeted EXISTS / JOIN predicates on revcode and billtype BEFORE
				touching the detail table at full scale. The UNION is eliminated.
				setclaim now joins only #QUALIFYING_CLAIMS.

		ROOT CAUSE 2 - CORRELATED IN SUBQUERIES ON claimdetail (~10 BILLION REBINDS):
				The three UNION branches each contained:
				AND clm.claimid IN (SELECT claimid FROM claimdetail WHERE CASE...revcode...)
				This is a correlated subquery pattern. The execution plan showed
				~1.29e10 rebinds on Clustered Index Seeks, meaning SQL Server
				re-executed the inner SELECT for every outer row.
				FIX: Replaced with EXISTS(...) anti-join pattern and, at the
				pre-stage step, a single pass over claimdetail with a pre-computed
				REVCODE_NORMALIZED computed column to avoid repeated CASE evaluation.

		ROOT CAUSE 3 - FULL CLUSTERED INDEX SCANS ON claim (57M rows) AND
				claimdetail (157M rows) WITH TRY_CONVERT() ON INDEXED DATE COLUMNS:
				PlanAffectingConvert warnings confirmed:
				CONVERT_IMPLICIT(varchar(40), isnull(TRY_CAST([clm].[startdate] AS date),'1900-01-01'), 121)
				CONVERT(varchar(255), TRY_CAST([clm].[startdate] AS date), 112)
				CONVERT(varchar(255), TRY_CAST([clm].[enddate] AS date), 112)
				CONVERT(varchar(255), TRY_CAST([clm].[paiddate] AS date), 112)
				TRY_CONVERT() wrapping indexed columns defeats sargability -- the
				optimizer cannot use the index for range seeks and falls back to
				full clustered index scans.
				FIX: Date filters are applied as direct datetime2 comparisons
				against @RangeStartDate / @RangeEndDate (already datetime2), which
				allows the optimizer to seek on existing date indexes
				(idxPaidDate, IDX_CLAIM_MEMID_PLUS1 visible in the plan).

		ROOT CAUSE 4 - NESTED LOOPS ON hcfaposlocation + contract (~1.29e10 REBINDS):
				hcfaposlocation and contract were LEFT JOINed inline in the massive
				final SELECT, driven by the 2e15-row intermediate result. The
				optimizer chose Nested Loops with ~12.9 billion rebinds on each.
				FIX: Both small lookup tables are pre-materialized as temp tables
				(#POSLOC, #CONTRACTDESCR) so the optimizer has accurate row counts
				and selects Hash Join or Merge Join against a small build side. */

-- C003: ADJUSTMENT FOR CONTRACTING PROPOSAL OF [HCT LOGIC DAY(S)] PER TEAMS DISCUSSION ON 20260508

-- C004: ELLNER BARIATRIC 20260513 -- REPLACED Contracting_Proposal_Category AND Proposed_Rate_Payment CASE BLOCKS - 
       /* Per Sir Salim French contracting request 20260501 -- Medi-Cal LOB only -- CPT case rate basis
       CPT 43644 Bariatric Surgery/Gastrectomy: current $3,400 -> proposed $3,800 case rate
       CPT 43775 Bariatric Surgery/Gastric Restrictive Procedure: current $3,400 -> proposed $3,800 case rate
       General Surgery (all other CPTs): current 100% -> proposed 120% Prevailing Medicare Rate (EQUIV hybrid)
       ELSE = 0 (professional provider -- hard stop per corpus standard) */

-- C005: INTERFAITH COMMUNITY SERVICES 20260519 -- REPLACED Contracting_Proposal_Category AND Proposed_Rate_Payment CASE BLOCKS
       /* Per Daphyne Watson (Contract Development Manager) contracting request 20260511 -- Medi-Cal LOB only -- Per Diem T2033-U6 basis
       T2033-U6 Recuperative Care: current $204/day -> proposed $225/day (DO THE MATH Fx reverse-engineer)
       ELSE = 0 (specialty provider -- hard stop per corpus standard)
       Provider TIN: 953837714 | NPI: 1538667969 | DOS: 2/01/2025 - 1/31/2026 | Claims lag: no earlier than 2/01/2025 */

-- C006: HANGER 20260608 -- REPLACED Contracting_Proposal_Category AND Proposed_Rate_Payment CASE BLOCKS
       /* Per contracting request 20260512 (date brought to COO 20260512) -- Medi-Cal LOB only -- DME case rate basis
       S1040 Cranial Remolding Orthosis: current $2,200 -> proposed $2,400 (variance: +$200 per unit)
       ELSE = 0 (DME provider -- hard stop per corpus standard)
       Provider TIN: 953837714 | NPI: 1538667969 | DOS: 3/01/2025 - 2/28/2026 | Claims lag: no earlier than 3/01/2025 */

-- C007: VALLEY MEDICAL TRANSPORT 20260615 -- REPLACED Contracting_Proposal_Category AND Proposed_Rate_Payment CASE BLOCKS
       /* Per Daphyne Watson (Contract Development Manager) contracting request 20260315 (date brought to COO 20260313) -- Medi-Cal AND Medicare LOB (rates identical for both) -- per-unit HCPCS basis
       HIERARCHY DESIGN: modcode-qualified branches MUST evaluate BEFORE base CPT branches to prevent modifier-bearing lines from falling through to base rate.
       PRIORITY TIER 1 - MODIFIER-QUALIFIED (modcode takes precedence):
         A0130 + modcode UJ  : Night Call        current $26.43 -> proposed $45.00
         A0130 + modcode HN  : Dry-Run           current $20.30 -> proposed $35.00 (A0130 HN QN per request; HN evaluated here, QN on modcode2)
         A0380 + modcode HN  : Cancel at Door (Dry Run) current $20.30 -> proposed $35.00
         T2005 + modcode UJ  : Stretcher Night Call current $32.42 -> proposed $220.00
         T2005 + modcode DS  : Dry Run           current $20.35 -> proposed $200.00
       PRIORITY TIER 2 - BASE CPT (no qualifying modifier):
         A0130               : Non-Emergency Wheelchair or Ambulatory Pick-up current $20.30 -> proposed $35.00
         A0380               : Per Mile Charge   current $1.50 -> proposed $3.75 per unit (mileage)
         T2005               : Non-Emergency Stretcher Van current $26.29 -> proposed $200.00
         T2049               : Stretcher Mileage per mile current $1.50 -> proposed $5.00 per unit (mileage)
       ELSE = 0 (transportation provider -- hard stop per corpus standard)
       Provider TIN: 043678536 | NPI: 1881812089 | DOS: 3/01/2025 - 2/28/2026 | Claims lag: no earlier than 3/01/2025 */

-- C008: LO-HAR SENIOR LIVING 20260615 -- REPLACED Contracting_Proposal_Category AND Proposed_Rate_Payment CASE BLOCKS
       /* Per Daphyne Watson (Contract Development Manager) contracting request 20260612 (date brought to COO 20260313) -- Medi-Cal LOB AND Medicare LOB -- Rev Code 0101 per diem basis
       NOTE: TIN DISCREPANCY -- eVIPs TIN 471814132 vs. request doc TIN 471614132; BOTH retained in #PROVISOLATION per Sir Salim confirmation email 20260612
       Rev Code 0101 Custodial Care: current $170.00/day -- three-year step-up proposal:
         Yr 1 (DOS YEAR 2025): $225.00 per day ([HCT LOGIC DAY(S)])
         Yr 2 (DOS YEAR 2026): $231.75 per day ([HCT LOGIC DAY(S)])
         Yr 3 (DOS YEAR 2027): $238.70 per day ([HCT LOGIC DAY(S)])
       ELSE = 0 (facility provider -- hard stop per corpus standard)
       Provider TIN: 471814132 / 471614132 | NPI: 1104229012 | DOS: 3/01/2025 - 2/28/2026 | Claims lag: no earlier than 3/01/2025 */

-- =====================================================================
	-- DECLARE @PARAMETER(S) / @FILTER(S):
-- =====================================================================
DECLARE @BRAND AS nvarchar(100) = NULL -- 'CHGSD' OR 'CHPIV' -- DEFAULT VAL()
		
DECLARE @SearchString AS varchar(255)
-- DECLARE @SPLITlob AS nvarchar(255)
DECLARE @leadlag AS decimal(9,0)
DECLARE @leadlagmonths AS int
DECLARE @when AS datetime2
DECLARE @RangeStartDate AS datetime2
DECLARE @RangeEndDate AS datetime2
DECLARE @CutoffDate AS datetime2
DECLARE @TruevFalse AS binary
DECLARE @DYNAMICLIKE AS nvarchar(255)
DECLARE @lobplanprog AS varchar(255)
DECLARE @memid AS varchar(25)
DECLARE @pos AS varchar(2)
DECLARE @solveforunknown AS decimal(9,3)
DECLARE @BirthdayAgeParam AS date
DECLARE @CurrentAnesthesiaRate AS decimal(9,2)
DECLARE @currentmultiplier AS decimal(9,2)

SET @SearchString = NULL  -- see CREATE TABLE #employee
-- SET @SPLITlob = 'MEDI-CAL,DSNP,CSNP,CMC,MSO - CHPIV' -- SQL: STRING_SPLIT() ... LINE_OF_BUSINESS OPTION(S)
SET @leadlag = -15 -- +- LEAD() LAG() IN ... -- C008: LO-HAR SENIOR LIVING DOS 3/01/2025 - 2/28/2026
SET @leadlagmonths = 12 -- +- LEAD() LAG() IN MONTH(S) 
SET @when = NULL
SET @RangeStartDate = DATEADD(MONTH,@leadlag,DATEADD(DAY,1,EOMONTH(GETDATE(),-1))) -- AS [1st OF ... MONTH]
SET @RangeEndDate = DATEADD(day,-1,DATEADD(MONTH,@leadlagmonths,@RangeStartDate))
SET @CutoffDate =  TRY_CONVERT(date,GETDATE()) -- PAID DATE CUTOFF
SET @TruevFalse = NULL
SET @DYNAMICLIKE = '%'+ISNULL(@SearchString,'')+'%' -- LIKE '%[@PARAMETER]%'
SET @lobplanprog = NULL -- SET @lobplanprog = 'DSNP MEDICARE PLAN' -- SELECT * FROM INFORMATICS.dbo.[uvw_LINE_OF_BUSINESS] -- ASSESS VALID ACTIVE OPTION(S)
SET @memid = CAST(NULL AS varchar(25)) -- ISO ON SPECIFIC MEMBER
SET @pos = NULL -- SELECT 'TELEHEALTH ("02") ANALYSIS DUE TO COVID - 19' AS [NOTE(S)],* FROM INFORMATICS2.dbo.SHELLpos
SET @solveforunknown = 1.0 -- DO THE MATH Fx - FORMULA (REVERSE ENGINEER) … 100% value = (Given value ÷ Given percentage) × 100 ('STEP88_FEESCHED...sql') eg. 100% OF ?
SET @BirthdayAgeParam = DATEADD( yy, -18, GETDATE()) -- WHERE 1=1 AND TRY_CONVERT(date,mem.dob) <= @BirthdayAgeParam -- 65+ MEMBERSHIP
SET @CurrentAnesthesiaRate = 44.00
SET @currentmultiplier = 1

		-- SELECT value FROM STRING_SPLIT(@SPLITlob, ',')

		SELECT ' ' AS '"DECLARE*" @PARAM(S): '
		,'BETWEEN '+CAST(CAST(@RangeStartDate AS date) AS varchar(255))+' AND '+CAST(CAST(@RangeEndDate AS date) AS varchar(255)) AS 'RANGE NOTE(s)'
		,bp.*
		FROM INFORMATICS.dbo.[uvw_LINE_OF_BUSINESS] AS bp (NOLOCK) -- HMOPROD_PLANDATA.dbo.benefitplan + HMOPROD_PLANDATA.dbo.program
		WHERE 1=1
			AND bp.[BRAND] IN (ISNULL(@BRAND,'CHGSD')) -- ('MEDI-CAL BENEFIT PLAN','DSNP MEDI-CAL PLAN','COMMUNITY Y MAS (HMO C-SNP)','IV_DSNP2 MEDI-CAL PLAN','CHG MARKETPLACE HMO PLAN') -- VALID ACTIVE OPTION(S) -- C###: ADD BRANDING FOR CHPIV 'MSO' = management services organization IMPLEMENTATION AS OF 01/01/2026 GO LIVE 

-- DECLARE @SETfeesched AS varchar(255)
-- DECLARE @SETfeesched2 AS varchar(255)
-- DECLARE @SETfeesched3 AS varchar(255)

-- SET @SETfeesched = 'C01350903'
-- SET @SETfeesched2 = 'C01011396'
-- SET @SETfeesched3 = 'C01011395'

	-- Change from C00740459 to C00727442 for hospital claims
/* SET @SETfeesched = CASE 
    WHEN EXISTS (
        SELECT 1 
        FROM HMOPROD_PLANDATA.dbo.claim c
        WHERE c.formtype = 'UB04' -- Hospital Claims
        AND c.claimid IN (SELECT DISTINCT claimid FROM INFORMATICS.dbo.CONTRACTING_PACS)
    )
    THEN 'C00727442' -- Hospital Medi-Cal fee schedule
    ELSE 'C00740459' -- Professional Medi-Cal fee schedule
END; 

		⏎ ASC = Ambulatory Surgical Center
				•	??? - USE 'C00329963'

		⏎ Professional Claim (formtype = 1500)
				•	TRI Medi-cal - USE 'C01350903'
				•	Medi-cal - USE 'C00740459'
				•	Medicare POS = 02, 11, 12, 20, 50 - USE 'C01011396' 
				•	Medicare POS <> 02, 11, 12, 20, 50 - USE 'C01011395'
				
-- ======================================================================
	-- POS, BILL TYPE(S), Dx, PROC + REV: 
-- ======================================================================
SELECT ' ' AS 'PLACE OF SERVICE (POS)',*
FROM HMOPROD_PLANDATA.dbo.hcfaposlocation AS pos (NOLOCK)
WHERE 1=1 
	AND pos.locationcode IN ('02','11','12','20','50') -- Telehealth, Office Visit, Home, Urgent Care Facility & Federally Qualified Health Center				

		⏎ Hospital Claim (formtype = UB04) 
				•	TRI Medi-cal - USE 'C01350904'
				•	Medi-cal - USE 'C00727442'
				•	Medicare - NO NOT NEGATIVE != <> fee schedule. Claims are priced with Hospital OP PPS pricer
				
		⏎ 'PDPM' = PATIENT DRIVEN PAYMENT MODEL - FROM: Elizabeth Valdez, MBA <evaldez@chgsd.com> These rates are uploaded in QNXT annually. Below are the link to the fee schedules for 2024 and 2025.
				USE https://www.dhcs.ca.gov/services/medi-cal/Documents/AB1629/AB1629_WebUpdates/CY2025-FSNF-B-FSSA-Rates-On-File-09152025-Update.xlsx - '2025 rates'
				USE https://www.dhcs.ca.gov/services/medi-cal/Documents/AB1629/AB1629_WebUpdates/CY2024-FSNF-B-FSSA-Rates-On-File-09152025-Update.xlsx - '2024 rates'

		⏎ FOR CONTRACTING ANALYSIS CONSIDER MIN('TRI Medi-cal') OR MAS / BETTER!!! */






-- =====================================================================
--  COPT: PRE-STAGE STEP 1 - MATERIALIZE LOOKUP TABLES * PURPOSE: Eliminates Nested Loop rebinds on hcfaposlocation
-- =====================================================================
--------------------------------------------------------------------------------------------------------------------
	-- Error Trapping: Check If Permanent Table(s) Already Exist(s) And Drop If Applicable --
--------------------------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS #PROVISOLATION;
DROP TABLE IF EXISTS #POSLOC;
DROP TABLE IF EXISTS #CONTRACTDESCR;
DROP TABLE IF EXISTS #QUALIFYING_CLAIMS; -- PRE - FILTER THE DETAIL
DROP TABLE IF EXISTS INFORMATICS.dbo.CONTRACTING_PALOMAR_SPEC;
DROP TABLE IF EXISTS #ContractAnalysis;
DROP TABLE IF EXISTS INFORMATICS.dbo.CONTRACTING_PALOMAR_SPEC_TEMPLATE_DETAIL;

-- =====================================================================
	-- THE RFERRING PROVIDER: 
-- =====================================================================
/* SELECT ' ' AS 'REFERRING PROVIDER DIRECTLY FROM CLAIM TABLE: '
,cp.* -- LEVERAGE: "REFERRING PROV ON CLAIM 20260324.sql"
FROM HMOPROD_PLANDATA.dbo.ClaimProv AS cp
WHERE 1=1
	AND claimid IN ('25205E07574')
	
SELECT *
FROM INFORMATICS.dbo.uvw_AUTHREFCLAIM 
WHERE 1=1
	AND claimid IN ('25205E07574') */

SELECT * 
INTO #PROVISOLATION
-- SELECT TOP 100 ' ' AS 'CHECK 1st',fedid,npi,provid,*
-- SELECT DISTINCT ' ' AS 'CHECK 1st',fedid,npi,provid,
FROM INFORMATICS.dbo.[uvw_PROVISO] AS prov
WHERE 1=1 
	AND
	( -- INITIATE ...
	UPPER(LTRIM(RTRIM(ISNULL(prov.fedid,'')))) IN ('271332228') -- TIN (TAXPAYER IDENTIFICATION NUMBER) aka TaxID
		OR UPPER(LTRIM(RTRIM(ISNULL(prov.NPI,'')))) IN ('1649500141')  -- NPI (National Provider ID)
		-- OR PROVNM LIKE '%HANGER%'
		) -- CONCLUDE ...

		SELECT ' ' AS 'CONFIRM PROVIDER SELECTION: '
		,provid
		,fedid
		,NPI
		,PROVNM
		,SPECcode
		,SPECdescr
		,PROVcode
		,PROVtype 
		FROM #PROVISOLATION 
		GROUP BY provid,fedid,NPI,PROVNM,SPECcode,SPECdescr,PROVcode,PROVtype 
		ORDER BY PROVNM;

SELECT locationcode
,DESCRIPTION
INTO #POSLOC
FROM HMOPROD_PLANDATA.dbo.hcfaposlocation (NOLOCK);

CREATE CLUSTERED INDEX idx_POSLOC ON #POSLOC (locationcode);

SELECT [CONTRACT DESCRIPTION] = UPPER(LTRIM(RTRIM(ISNULL(CAST(description AS nvarchar(255)),''))))
,contractid
INTO #CONTRACTDESCR
FROM HMOPROD_PLANDATA.dbo.contract (NOLOCK)
WHERE 1=1
        AND NOT UPPER(LTRIM(RTRIM(ISNULL(CAST(description AS nvarchar(255)),'')))) = ''; -- NO NOT NEGATIVE <> != ...

CREATE CLUSTERED INDEX idx_CONTRACTDESCR ON #CONTRACTDESCR (contractid);







-- ===================================================================================================
	--  COPT: PRE-STAGE STEP 2 - QUALIFY / KEY ON ... [claimid] IN A SINGLE PASS * PURPOSE: 1ST FIRST PRINCIPLE FILTER THE DETAIL:
-- ===================================================================================================
SELECT DISTINCT clm.claimid -- KEY ON ... FINAL ANSWER: the CASE statement cannot produce duplicate claimid, memid rows by itself. It returns one and only one classification per input row, with the first true WHEN taking PRECEDENCE.
,clm.memid
,CASE -- SCENARIO A: BILLTYPE MATCH -- C002: PER BRD / NARRATIVE "D-SNP Transmission of Admission Notification Narrative 04-01-2026 (002).docx"
WHEN 1=0
THEN 'THE VILLAGE PEOPLE REPORT' -- GENERIC CATCH - ALL BEFORE THE WHERE CLAUSE ...
WHEN EXISTS ( -- DEFINITIVE ANSWER: Returns TRUE the moment SQL Server finds EVEN ONE MATCHING ROW IN THE SUBQUERY. It immediately stops scanning -- it does not count rows, does not return data, just confirms presence. This is why SELECT 1 is used -- the actual column value is irrelevant. -- IN PLAIN LANGUAGE: "DOES AT LEAST ONE ROW EXIST IN #PROVISOLATION where the provider ID matches?" ... NOT EXISTS(): EXACT LOGICAL INVERSE. Returns TRUE only WHEN THE SUBQUERY FINDS ZERO MATCHING ROWS. It is the correct, sargable, SQL-idiomatic way to express "exclude any claim whose provider appears in this list." It is semantically equivalent to a LEFT JOIN ... WHERE joined_table.key IS NULL anti-join pattern, but often cleaner and more readable.
SELECT 1
FROM #PROVISOLATION AS piso
WHERE 1=1
	AND a.provid = piso.provid -- KEY ON ... [Rendering Provider]
	)
THEN 'HIT ON RENDERING PROVIDER'
WHEN EXISTS ( -- DEFINITIVE ANSWER: Returns TRUE the moment SQL Server finds EVEN ONE MATCHING ROW IN THE SUBQUERY. It immediately stops scanning -- it does not count rows, does not return data, just confirms presence. This is why SELECT 1 is used -- the actual column value is irrelevant. -- IN PLAIN LANGUAGE: "DOES AT LEAST ONE ROW EXIST IN #PROVISOLATION where the provider ID matches?" ... NOT EXISTS(): EXACT LOGICAL INVERSE. Returns TRUE only WHEN THE SUBQUERY FINDS ZERO MATCHING ROWS. It is the correct, sargable, SQL-idiomatic way to express "exclude any claim whose provider appears in this list." It is semantically equivalent to a LEFT JOIN ... WHERE joined_table.key IS NULL anti-join pattern, but often cleaner and more readable.
SELECT 1
FROM #PROVISOLATION AS piso
WHERE 1=1
	AND a.affiliateid = piso.provid -- KEY ON ... [PayTo Provider]
	)
THEN 'HIT ON PAYTO PROVIDER'
ELSE 'NOT_QUALIFYING'
END AS [InclusionExclusionType]
INTO #QUALIFYING_CLAIMS
-- SELECT TOP 10 ' ' AS 'CHECK 1st',* 
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM HMOPROD_PLANDATA.dbo.claim (NOLOCK) AS clm
    -- INNER JOIN INFORMATICS.dbo.[uvw_LINE_OF_BUSINESS] AS bp ON clm.planid = bp.planid
	INNER JOIN HMOPROD_PLANDATA.dbo.affiliation (NOLOCK) AS a ON clm.affiliationid = a.affiliationid -- REMINDER: within claim(s) tables AFFILIATIONID is the relationship BETWEEN the a.provid = [RENDERING] PROVIDER AND the a.affiliateid = [PAYTO] PROVIDER	
WHERE 1=1
    AND ISNULL(clm.enddate,GETDATE()) >= @RangeStartDate -- WITHIN reporting period [RANGE] OPPOSITION
    AND clm.startdate <= @RangeEndDate -- WITHIN reporting period [RANGE] OPPOSITION
     AND clm.paiddate <= @CutoffDate -- PAID DATE CUTOFF
	 AND ISNULL(clm.enddate,GETDATE()) >= clm.startdate  -- MUST BE TRUE ... NON-CROSSFOOTED RECORDS ARE ACTIVE ...

CREATE CLUSTERED INDEX idx_QC_claimid ON #QUALIFYING_CLAIMS (claimid);
CREATE NONCLUSTERED INDEX idx_QC_memid ON #QUALIFYING_CLAIMS (memid);

/* DELETE -- ENSURE INCLUSIONEXCLUSION FENCE ... 
FROM #QUALIFYING_CLAIMS
WHERE 1=1
	AND InclusionExclusionType = 'NOT_QUALIFYING' */

	-- CHECK FOR DUP(S) --
SELECT ' ' AS 'SHOULD RETURN 0 ROWS - DUP Validation',*
FROM #QUALIFYING_CLAIMS
WHERE 1=1
    AND [claimid] IN
    ( -- INITIATE ...
    SELECT [claimid]
    FROM #QUALIFYING_CLAIMS AS dup
    GROUP BY [claimid]
    HAVING COUNT(1)>1
    ) -- CONCLUDE ... 

         SELECT ' ' AS 'QA PRE-STAGE OF QUALIFYING CLAIM COUNT: '
        ,InclusionExclusionType
        ,COUNT(DISTINCT claimid) AS [Unique Claims]
        ,COUNT(DISTINCT memid) AS [Unique Members]
        FROM #QUALIFYING_CLAIMS
        WHERE 1=1
            AND NOT InclusionExclusionType = 'NOT_QUALIFYING' -- NO NOT NEGATIVE <> = ...
        GROUP BY InclusionExclusionType







-- =====================================================================
	--  SETCLAIM CTE: NOW JOINS #QUALIFYING_CLAIMS ONLY - NOT FULL TABLES
-- =====================================================================
;WITH setclaim AS
( -- INITIATE ...
SELECT qc.claimid
,qc.memid
,qc.[InclusionExclusionType]
,TRY_CONVERT(nvarchar(255),'Assign Claim Adjudication Category') AS [ClaimCategory]
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM #QUALIFYING_CLAIMS AS qc
WHERE 1=1
    AND NOT qc.InclusionExclusionType = 'NOT_QUALIFYING' -- NO NOT NEGATIVE <> != ...
GROUP BY qc.claimid,qc.memid,qc.[InclusionExclusionType] -- CONSIDER Removing DISTINCT IN FAVOR OF GROUP BY: REPLACE the DISTINCT in the final SELECT with a proper GROUP BY clause. This is more explicit about the aggregation intent and allows the query optimizer to work more efficiently.
) -- CONCLUDE ...

        -- SELECT * FROM setclaim; -- Or any other query that uses the CTE

,CLAIMDATA AS
( -- INITIATE ...
SELECT clm.claimid
,clm.memid
,clm.affiliationid
,clm.startdate
,clm.enddate
,clm.cleandate
,clm.paiddate
,clm.adjuddate
,clm.okpaydate
,clm.Dischargedate
,clm.admitdate
,clm.patientstatus
,clm.okpayby
,clm.planid
,clm.totalamt
,clm.totalpaid
,clm.formtype
,clm.facilitycode
,clm.billclasscode
,clm.frequencycode
,clm.drg
,clm.AdmitType
,clm.AdmitSource
,clm.AdmitHour
,clm.contractnetworkid
,clm.[status]
,clm.controlnmb
,clm.referralid
,clm.manualencounter
,clm.isencounter
,clm.resubclaimid
,clm.totextdeductamt
,clm.logdate
,clm.ProviderParStatus
,clm.serviceaffilid -- WHEN POPULATED THE [Rendering Provid] ... INNER JOIN HMOPROD_PlanData.dbo.provider AS p ON clm.serviceaffilid = p.provid
,scr.[ClaimCategory]
,scr.[InclusionExclusionType]
FROM setclaim AS scr
    INNER JOIN HMOPROD_PLANDATA.dbo.claim (NOLOCK) AS clm ON scr.claimid = clm.claimid
) -- CONCLUDE ...

        -- SELECT * FROM CLAIMDATA; -- Or any other query that uses the CTE

SELECT TRY_CONVERT(datetime2,GETDATE()) AS [LastReportExecutionTime]
,'N' AS [THE FINAL CLAIM]
,CAST(NULL AS nvarchar(255)) AS 'NOTE(s)'
,CONVERT(nvarchar(25), GETDATE(),120) AS 'ExecutionDate'  --Like FORMAT or TEXT IN 'yyyy-mm-dd hh:mi:ss' (24h)
,TRY_CONVERT(nvarchar(255),NULL) AS [Cx]
,TRY_CONVERT(nvarchar(255),NULL) AS [SubCx]
,TRY_CONVERT(nvarchar(255),NULL) AS [DxCx]
,TRY_CONVERT(nvarchar(255),NULL) AS [Age Band]
,TRY_CONVERT(nvarchar(255),NULL) AS [Ethnicity]
,'UTILIZATION BETWEEN '+CAST(CAST(@RangeStartDate AS date) AS varchar(255))+' AND '+CAST(CAST(@RangeEndDate AS date) AS varchar(255)) AS 'RANGE NOTE(s)'
,bp.planid
,bp.programid
,bp.[LINE_OF_BUSINESS]
,bp.[PLAN]
,bp.PROGRAM
,a.affiliationid -- REMINDER: within claim(s) tables AFFILIATIONID is the relationship BETWEEN the a.provid = [RENDERING] PROVIDER AND the a.affiliateid = [PAYTO] PROVIDER
,cd.contractid
,contrdescr.[CONTRACT DESCRIPTION]
,cd.termid
,CLAIMDATA.contractnetworkid AS [NETWORK FLAG]
,cd.ffspoolamt AS [Provider Withhold] -- TRY_CONVERT(nvarchar(255),NULL) AS [Provider Withhold], -- ??? POTENTIAL SOLUTION AS DISCUSSED WITH SIR ADRIAN ON 20241125
,cd.ProvMedicareMandatedAdjust AS [Provider Withhold Alt] -- 		•	If you don’t want to use the claimdetail.ffspoolamt field for the “Provider Withhold” column—and you want to use the provider SEQUESTRATION instead—then I believe you want to use the claimdetail.ProvMedicareMandatedAdjust field. The SEQUESTRATION info in the contract is not always reliable since contracts can change, plus we have a couple of scripts that can alter the SEQUESTRATION rate based ON other factors ... PER eMAIL FROM SIR EVAN ON 20241202 ... eg.:  c.claimid IN ('24323E00966') $3.32
,CLAIMDATA.ProviderParStatus AS [PROVIDER_PAR_STAT]
,TRY_CONVERT(nvarchar(1),NULL) AS 'contractedVerification' -- LEVERAGE: 'uvw_FALSE_PROVIDER_PAR' AND 'uvw_ProviderRepository274_PAR'
,TRY_CONVERT(nvarchar(1),NULL) AS 'capitationVerification'
,CASE 
WHEN cd.Capitated = -1 
THEN 'Y' 
ELSE 'N' 
END AS [EncounterFlag] -- BOOLEAN() aka BINARY() aka TRUE v. FALSE aka 0 1
,CLAIMDATA.manualencounter
,CLAIMDATA.isencounter
,UPPER(LTRIM(RTRIM(ISNULL(CLAIMDATA.[status],'')))) AS [HEADERstatus]
,UPPER(LTRIM(RTRIM(ISNULL(cd.[status],'')))) AS [DETAILstatus]
,cd.modcode
,cd.modcode2
,cd.modcode3
,cd.modcode4
,cd.modcode5
,UPPER(LTRIM(RTRIM(ISNULL(CLAIMDATA.claimid,''))))+''+UPPER(LTRIM(RTRIM(ISNULL(cd.claimline,'')))) AS [DupID]
,CLAIMDATA.controlnmb AS [Pat. Control No.]
,CAST(UPPER(LTRIM(RTRIM(ISNULL(CLAIMDATA.memid,'')))) AS varchar(255))+'|'+CAST(UPPER(LTRIM(RTRIM(ISNULL(TRY_CONVERT(date,ISNULL(CLAIMDATA.dischargedate,CLAIMDATA.enddate)),'')))) AS varchar(10)) AS [DischargeEventID]
,CAST(UPPER(LTRIM(RTRIM(ISNULL(CLAIMDATA.memid,'')))) AS varchar(255))+CAST(UPPER(LTRIM(RTRIM(ISNULL(TRY_CONVERT(date,CLAIMDATA.startdate),'')))) AS varchar(10))+CAST(UPPER(LTRIM(RTRIM(ISNULL(a.provid,'')))) AS varchar(255)) AS [AdmitID] -- 'Unique person, date of service, and provider (RENDERING) = one visit' OR 'Unique person, date of service, and NDC = one script'
,CAST(UPPER(LTRIM(RTRIM(ISNULL(CLAIMDATA.memid,'')))) AS varchar(255))+CAST(UPPER(LTRIM(RTRIM(ISNULL(TRY_CONVERT(date,CLAIMDATA.Dischargedate),'')))) AS varchar(10))+CAST(UPPER(LTRIM(RTRIM(ISNULL(a.provid,'')))) AS varchar(255)) AS [DischargeID] -- 'Unique person, Discharge date, and provider (RENDERING) = one visit' OR 'Unique person, date of service, and NDC = one script'
,CAST(UPPER(LTRIM(RTRIM(ISNULL(CLAIMDATA.memid,'')))) AS varchar(255))+CAST(UPPER(LTRIM(RTRIM(ISNULL(TRY_CONVERT(date,CLAIMDATA.startdate),'')))) AS varchar(10)) AS [Alt. AdmitID] -- 'Alt. definition Unique person +  date of service'
,CAST(UPPER(LTRIM(RTRIM(ISNULL(CLAIMDATA.memid,'')))) AS varchar(255))+CAST(UPPER(LTRIM(RTRIM(ISNULL(TRY_CONVERT(date,CLAIMDATA.Dischargedate),'')))) AS varchar(10)) AS [Alt. DischargeID] -- 'Alt. definition Unique person +  Discharge date'
,bm.HealthPlanID AS 'SUBSCRID'
,bm.CIN
,CLAIMDATA.memid
,UPPER(LTRIM(RTRIM(ISNULL(sme.fullname,'')))) AS [MEMNM]
,sme.dob
,TRY_CONVERT(decimal(4,1),(DATEDIFF("dd",TRY_CONVERT(date,sme.dob),TRY_CONVERT(date,GETDATE()))/365.25)) AS 'MEMBER_AGE'
,TRY_CONVERT(int,(DATEDIFF("dd",TRY_CONVERT(date,sme.dob),TRY_CONVERT(date,GETDATE()))/365.25)) AS 'MEMBER_TRUE_CHRONOLOGICAL_AGE'
,DATEDIFF("mm",TRY_CONVERT(date,sme.dob),TRY_CONVERT(date,GETDATE()))-(TRY_CONVERT(int,(DATEDIFF("dd",TRY_CONVERT(date,sme.dob),TRY_CONVERT(date,GETDATE()))/365.25))*12) AS 'MEMBER_TRUE_CHRONOLOGICAL_AGE_AND_HOW_MANY_MTHs'
,a.provid -- REMINDER: within claim(s) tables AFFILIATIONID is the relationship BETWEEN the a.provid = [RENDERING] PROVIDER AND the a.affiliateid = [PAYTO] PROVIDER
,UPPER(LTRIM(RTRIM(ISNULL(p1.npi,'')))) AS [NPIprovnm]
,UPPER(LTRIM(RTRIM(ISNULL(p1.fullname,'')))) AS [PROVNM]
,a.affiliateid AS [PAYTO] -- REMINDER: within claim(s) tables AFFILIATIONID is the relationship BETWEEN the a.provid = [RENDERING] PROVIDER AND the a.affiliateid = [PAYTO] PROVIDER
,UPPER(LTRIM(RTRIM(ISNULL(p2.npi,'')))) AS [NPIpayto]
,UPPER(LTRIM(RTRIM(ISNULL(p2.fullname,'')))) AS [PAYTONM]
-- ,cd.renderingprovid -- OFF CLAIM RENDERING -- REMOVE AS CAN CAUSE DUP(s) AS OF 20181107
-- ,UPPER(LTRIM(RTRIM(ISNULL(p3.npi,'')))) AS [NPIrendering],UPPER(LTRIM(RTRIM(ISNULL(p3.fullname,'')))) AS [RENDERINGNM] -- REMOVE AS CAN CAUSE DUP(s) AS OF 20181107
,LTRIM(RTRIM(CLAIMDATA.planid)) AS clmLOB
,LTRIM(RTRIM(cd.planid)) AS cdLOB
,SUBSTRING(UPPER(LTRIM(RTRIM(ISNULL(CLAIMDATA.claimid,'')))),1,11) AS [ClaimIdRootPrefix]
,UPPER(LTRIM(RTRIM(ISNULL(CLAIMDATA.claimid,'')))) AS SEQ_CLAIM_ID
,CLAIMDATA.claimid
,CLAIMDATA.resubclaimid -- see "TRI_FFS_PAID_CLAIM_TEST_20241108.sql" ... '24156E24207' 
,cd.claimline
,cd.dosfrom
,cd.dosto
,CASE
WHEN LTRIM(RTRIM(CLAIMDATA.claimid))  LIKE '%A%'
THEN SUBSTRING(LTRIM(RTRIM(CLAIMDATA.claimid)),1,CHARINDEX('A',LTRIM(RTRIM(CLAIMDATA.claimid)),1)-1)
WHEN LTRIM(RTRIM(CLAIMDATA.claimid))  LIKE '%R%'
THEN SUBSTRING(LTRIM(RTRIM(CLAIMDATA.claimid)),1,CHARINDEX('R',LTRIM(RTRIM(CLAIMDATA.claimid)),1)-1)
ELSE LTRIM(RTRIM(CLAIMDATA.claimid))
END AS [ORIG_REVERSE_APPEND_CLAIMID]
,ct.ClmType
,ct.formtype
,sbt.QNXTbilltype
,sbt.BillTypeDescr
,cd.servunits -- AS [QUANTITY] ... AS [units_adj] ... AS 'Units adj'
,[QUANTITY] = TRY_CONVERT(decimal(9,0),0)
,[HCT LOGIC DAY(S)] = TRY_CONVERT(decimal(9,0),0)
,CLAIMDATA.totalamt AS TOTAL_BILLED_AMT -- BILLED (BAP) aka CHARGES
,CLAIMDATA.totalpaid AS TOTAL_PAID_AMOUNT
,cd.claimamt AS BILLED_AMT -- BILLED (BAP) aka CHARGES
-- ,cd.allowedamt AS ALLOWED_AMT  -- ALLOWED (BAP)
,cd.contractpaid AS ALLOWED_AMT  -- Alt. 'Allowed Amount' per MCR BID ... "spPartCClaims_...sql"
,cd.amountpaid AS NET_AMT
,cd.amountpaid AS PAID_NET_AMT-- [INVOICE AMT] ... cd.amountpaid AS 'PAID_NET_AMT' PROVEN to represent true COST (see pv.amountpaid AS CHECKAMT)  + PAID (BAP) ... c.	There is a field in the service tab for invoice cost, but it is not utilized by the Claims Department when pricing DME. The cost of invoice, including mark-ups and augmented contract rates, are calculated by the analyst and manually input to pay the claim. 
,-cd.paydiscount AS 'INT' -- INTEREST -- ,ABS(cd.paydiscount) AS 'INT'
,cd.ineligibleamt AS 'DISALLOWED'
,cd.cobeligibleamt AS 'COB Allowed'
,cd.extpaidamt AS 'COB Paid'
,CLAIMDATA.totextdeductamt AS 'COBDeduct'
,cd.extcoinsuranceamt AS 'COB Coinsurance'
,CAST(NULL AS money) AS [Modifier Discount] -- QUPD()
-- ,CAST((cd.amountpaid/@solveforunknown) AS money) AS [WHEN_GIVEN_CONTRACT_EQUIV_paid]
,CAST(NULL AS money) AS [EQUIV_allow_rate]
,CAST(NULL AS money) AS [EQUIV_allow_compare]
,CAST(NULL AS money) AS [EQUIV_allow_rate2]
,CAST(NULL AS money) AS [EQUIV_allow_compare2]
,CAST(NULL AS money) AS [EQUIV_allow_rate3]
,CAST(NULL AS money) AS [EQUIV_allow_compare3]
-- ,wc.userid,UPPER(LTRIM(RTRIM(ISNULL(CAST(wc.lastname AS varchar(255)),''))))+', '+UPPER(LTRIM(RTRIM(ISNULL(CAST(wc.firstname AS varchar(255)),'')))) AS [USERname]
-- ,UPPER(LTRIM(RTRIM(ISNULL(CAST(wc.lastname AS varchar(255)),'')))) AS [USERlastname]
-- ,UPPER(LTRIM(RTRIM(ISNULL(CAST(wc.firstname AS varchar(255)),'')))) AS [USERfirstname]
,TRY_CONVERT(date,CLAIMDATA.startdate) AS [DOS]
,SUBSTRING(CONVERT(varchar(255),TRY_CONVERT(date,CLAIMDATA.startdate),112),1,4) AS [YEAR_DOS] -- yyyy FROM yyyymmdd
,SUBSTRING(CONVERT(varchar(255),TRY_CONVERT(date,CLAIMDATA.startdate),112),1,6) AS [YEARMO_DOS] -- yyyymm FROM yyyymmdd
,SUBSTRING(CONVERT(varchar(255),TRY_CONVERT(date,CLAIMDATA.startdate),112),5,2) AS [MTH_DOS] -- mm FROM yyyymmdd
,UPPER(LTRIM(RTRIM(ISNULL(CAST(DATENAME(MONTH,TRY_CONVERT(date,CLAIMDATA.startdate)) AS varchar(3)),'')))) AS [ABBREV_MONTHis_DOS]
,TRY_CONVERT(date,CLAIMDATA.enddate) AS [DOSTHRU]
,SUBSTRING(CONVERT(varchar(255),TRY_CONVERT(date,CLAIMDATA.enddate),112),1,4) AS [YEAR_DOSTHRU] -- yyyy FROM yyyymmdd
,SUBSTRING(CONVERT(varchar(255),TRY_CONVERT(date,CLAIMDATA.enddate),112),1,6) AS [YEARMO_DOSTHRU] -- yyyymm FROM yyyymmdd
,SUBSTRING(CONVERT(varchar(255),TRY_CONVERT(date,CLAIMDATA.enddate),112),5,2) AS [MTH_DOSTHRU] -- mm FROM yyyymmdd
,UPPER(LTRIM(RTRIM(ISNULL(CAST(DATENAME(MONTH,TRY_CONVERT(date,CLAIMDATA.enddate)) AS varchar(3)),'')))) AS [ABBREV_MONTHis_DOSTHRU]
,TRY_CONVERT(date,CLAIMDATA.cleandate) AS [RECEIVED DATE]
,SUBSTRING(CONVERT(varchar(255),TRY_CONVERT(date,CLAIMDATA.cleandate),112),1,4) AS [YEAR_RECEIVED] -- yyyy FROM yyyymmdd
,SUBSTRING(CONVERT(varchar(255),TRY_CONVERT(date,CLAIMDATA.cleandate),112),1,6) AS [YEARMO_RECEIVED] -- yyyymm FROM yyyymmdd
,SUBSTRING(CONVERT(varchar(255),TRY_CONVERT(date,CLAIMDATA.cleandate),112),5,2) AS [MTH_RECEIVED] -- mm FROM yyyymmdd
,UPPER(LTRIM(RTRIM(ISNULL(CAST(DATENAME(MONTH,TRY_CONVERT(date,CLAIMDATA.cleandate)) AS varchar(3)),'')))) AS [ABBREV_MONTHis_RECEIVED]
,TRY_CONVERT(date,CLAIMDATA.paiddate)  AS [CHECK DATE]
,SUBSTRING(CONVERT(varchar(255),TRY_CONVERT(date,CLAIMDATA.paiddate),112),1,4) AS [YEAR_CHECKDATE] -- yyyy FROM yyyymmdd
,SUBSTRING(CONVERT(varchar(255),TRY_CONVERT(date,CLAIMDATA.paiddate),112),1,6) AS [YEARMO_CHECKDATE] -- yyyymm FROM yyyymmdd
,SUBSTRING(CONVERT(varchar(255),TRY_CONVERT(date,CLAIMDATA.paiddate),112),5,2) AS [MTH_CHECKDATE] -- mm FROM yyyymmdd
,UPPER(LTRIM(RTRIM(ISNULL(CAST(DATENAME(MONTH,TRY_CONVERT(date,CLAIMDATA.paiddate)) AS varchar(3)),'')))) AS [ABBREV_MONTHis_CHECKDATE]
,TRY_CONVERT(date,CLAIMDATA.adjuddate) AS [ADJUDICATE DATE]	
,SUBSTRING(CONVERT(varchar(255),TRY_CONVERT(date,CLAIMDATA.adjuddate),112),1,4) AS [YEAR_ADJUDICATE] -- yyyy FROM yyyymmdd
,SUBSTRING(CONVERT(varchar(255),TRY_CONVERT(date,CLAIMDATA.adjuddate),112),1,6) AS [YEARMO_ADJUDICATE] -- yyyymm FROM yyyymmdd
,SUBSTRING(CONVERT(varchar(255),TRY_CONVERT(date,CLAIMDATA.adjuddate),112),5,2) AS [MTH_ADJUDICATE] -- mm FROM yyyymmdd
,UPPER(LTRIM(RTRIM(ISNULL(CAST(DATENAME(MONTH,TRY_CONVERT(date,CLAIMDATA.adjuddate)) AS varchar(3)),'')))) AS [ABBREV_MONTHis_ADJUDICATE]
,TRY_CONVERT(date,CLAIMDATA.okpaydate) AS [POST DATE]
,SUBSTRING(CONVERT(varchar(255),TRY_CONVERT(date,CLAIMDATA.okpaydate),112),1,4) AS [YEAR_POST] -- yyyy FROM yyyymmdd
,SUBSTRING(CONVERT(varchar(255),TRY_CONVERT(date,CLAIMDATA.okpaydate),112),1,6) AS [YEARMO_POST] -- yyyymm FROM yyyymmdd
,SUBSTRING(CONVERT(varchar(255),TRY_CONVERT(date,CLAIMDATA.okpaydate),112),5,2) AS [MTH_POST] -- mm FROM yyyymmdd
,UPPER(LTRIM(RTRIM(ISNULL(CAST(DATENAME(MONTH,TRY_CONVERT(date,CLAIMDATA.okpaydate)) AS varchar(3)),'')))) AS [ABBREV_MONTHis_POST DATE]
,TRY_CONVERT(date,ISNULL(CLAIMDATA.Dischargedate,CLAIMDATA.enddate)) AS [DISCHARGE DATE]
,SUBSTRING(CONVERT(varchar(255),TRY_CONVERT(date,ISNULL(CLAIMDATA.Dischargedate,CLAIMDATA.enddate)),112),1,4) AS [YEAR_DISCHARGE] -- yyyy FROM yyyymmdd
,SUBSTRING(CONVERT(varchar(255),TRY_CONVERT(date,ISNULL(CLAIMDATA.Dischargedate,CLAIMDATA.enddate)),112),1,6) AS [YEARMO_DISCHARGE] -- yyyymm FROM yyyymmdd
,SUBSTRING(CONVERT(varchar(255),TRY_CONVERT(date,ISNULL(CLAIMDATA.Dischargedate,CLAIMDATA.enddate)),112),5,2) AS [MTH_DISCHARGE] -- mm FROM yyyymmdd
,UPPER(LTRIM(RTRIM(ISNULL(CAST(DATENAME(MONTH,TRY_CONVERT(date,ISNULL(CLAIMDATA.Dischargedate,CLAIMDATA.enddate))) AS varchar(3)),'')))) AS [ABBREV_MONTHis_DISCHARGE DATE]
,TRY_CONVERT(date,ISNULL(CLAIMDATA.admitdate,'')) AS [AdmitDate]
,SUBSTRING(CONVERT(varchar(255),TRY_CONVERT(date,ISNULL(CLAIMDATA.admitdate,'')),112),1,4) AS [YEAR_Admit] -- yyyy FROM yyyymmdd
,SUBSTRING(CONVERT(varchar(255),TRY_CONVERT(date,ISNULL(CLAIMDATA.admitdate,'')),112),1,6) AS [YEARMO_Admit] -- yyyymm FROM yyyymmdd
,SUBSTRING(CONVERT(varchar(255),TRY_CONVERT(date,ISNULL(CLAIMDATA.admitdate,'')),112),5,2) AS [MTH_Admit] -- mm FROM yyyymmdd
,UPPER(LTRIM(RTRIM(ISNULL(CAST(DATENAME(MONTH,TRY_CONVERT(date,ISNULL(CLAIMDATA.admitdate,''))) AS varchar(3)),'')))) AS [ABBREV_MONTHis_Admit]
,TRY_CONVERT(date,CLAIMDATA.cleandate) AS [TAT_CLEANDATE]
,TRY_CONVERT(date,cd.createdate) AS [TAT_CREATEDATE],
CAST(CLAIMDATA.logdate AS datetime) AS [TAT_LOGDATE]
,CAST(NULL AS varchar(255)) AS [Primary / Secondary Status] -- EMPTY SHELL QUPD FIELD
,SUBSTRING(UPPER(LTRIM(RTRIM(ISNULL(cd.servcode,'')))),1,5) AS 'CPT Service Code'
,sp.[CodeDescr] AS 'CPT Service Description'
,cd.revcode
,revcde.description AS 'REVCDE Descr'
,cd.medicareactioncode --  USE https://x12.org/codes/claim-adjustment-reason-codes ...  Claims where the primary insurance had denied the claim and CHG had "PAID" the claim but the amount paid was zero.Chartered by the American National Standards Institute for more than 40 years, X12 develops and maintains EDI standards and XML schemas which drive business processes globally.
,cd.location
,posloc.DESCRIPTION AS [POS Descr]
,CASE
WHEN cd.referralid IS NULL
THEN UPPER(LTRIM(RTRIM(ISNULL(CLAIMDATA.referralid,''))))
ELSE UPPER(LTRIM(RTRIM(ISNULL(cd.referralid,''))))
END AS AUTH_NUMBER -- c.referralid OR cd.referralid = ref.authorizationid DISCOVERED ON 20150728 w Stefan Glembocki
,CAST(NULL AS varchar(255)) AS [prindiag] -- EMPTY SHELL QUPD FIELD,principaldiag.prindiag
,CAST(NULL AS varchar(255)) AS [prindiag descr] -- EMPTY SHELL QUPD FIELD ,principaldiag.[prindiag descr]
,CAST(NULL AS nvarchar(255)) AS 'PRESENT ON ADMISSION'
,CLAIMDATA.drg --ADD ON TO MAKE DISTINCTION BETWEEN [DELIV_TYPE] aka [BIRTH_TYPE], etc... 20171025 'DRG' = Diagnosis Related Group (DRG)
,CAST(NULL AS nvarchar(255)) AS [DRGdescr]
,CAST(NULL AS nvarchar(255)) AS [PROCEDURE_1_CODE]
,CLAIMDATA.admitsource
,CLAIMDATA.admithour
,CLAIMDATA.dischargedate -- ,r.dischargedate -- FROM HMOPROD_PLANDATA.dbo.referral
,pstat.DischargeDescription  -- x see 'JAHDischargeStatus_PatientStatus_20160223.pdf'
,pstat.patientstatus
,0 AS [How many months with plan]
,CLAIMDATA.okpayby
,ISNULL(CLAIMDATA.okpayby,'N/A') AS [Decision Maker FOR modification / denial / deferrals]
,'Q'+DATENAME(qq,TRY_CONVERT(date,CLAIMDATA.okpaydate))+' '+DATENAME(yyyy,TRY_CONVERT(date,CLAIMDATA.okpaydate)) AS [DetermQuarter BY POST DATE]
,CASE
WHEN NOT ISNULL(cdrg.SeverityOfIllness,'') = '' -- NO NOT NEGATIVE <> != ...
THEN RTRIM(cdrg.finaldrg)+'-'+RTRIM(cdrg.SeverityOfIllness)
ELSE RTRIM(cdrg.finaldrg)
END AS [finalDRG+SOI]
,cdrg.subdrg
,cdrg.moddrg
,cdrg.finaldrg -- 1.	For select specialty’s proposed rate of “$460 per session per day for Dialysis (MS-DRG codes 800-809)”, is one claim the equivalent of “one session per day”? ... 
,ClaimData.[ClaimCategory]
,CLAIMDATA.[InclusionExclusionType] -- COPT: CARRIED FROM PRE-STAGE - ADMISSION TYPE CLASSIFICATION
,TRY_CONVERT(nvarchar(2000),NULL) AS [DETAILelement]
,TRY_CONVERT(decimal(11,2),0) AS 'TRI Payment'
,TRY_CONVERT(decimal(11,2),0) AS 'Accommodation Code'
,TRY_CONVERT(nvarchar(255),NULL) AS [Denial Reason] -- FIELD(p): QUPD FROM claimedit + rules; SHELL HERE
,CASE -- FIELD(s): PAPER vs ELECTRONIC INDICATOR PER NARRATIVE: 'E' IN claimid = ELECTRONIC
WHEN CHARINDEX('E',UPPER(LTRIM(RTRIM(ISNULL(CLAIMDATA.claimid,''))))) > 0
THEN 'ELECTRONIC'
ELSE 'PAPER'
END AS [Paper or Electronic]
,CASE -- FIELD(t): ER vs NON-ER INDICATOR PER NARRATIVE: 1500 POS 23/41 OR UB04 REVCODE 405
WHEN CLAIMDATA.formtype IN ('1500','1','P') -- 1500 CLAIM FORM
AND UPPER(LTRIM(RTRIM(ISNULL(cd.location,'')))) IN ('23','41')
THEN 'ER'
WHEN CLAIMDATA.formtype NOT IN ('1500','1','P') -- UB04 CLAIM FORM
AND (
CASE
WHEN SUBSTRING(LTRIM(RTRIM(ISNULL(cd.revcode,''))),1,1) = '0'
THEN SUBSTRING(LTRIM(RTRIM(ISNULL(cd.revcode,''))),2,3)
ELSE LTRIM(RTRIM(ISNULL(cd.revcode,'')))
END
) = '405'
THEN 'ER'
ELSE 'NON-ER'
END AS [ER or Non-ER]
,CASE -- FIELD(y): SERVICE TYPE INPATIENT vs OUTPATIENT/OTHER PER NARRATIVE: UB04 ONLY; facilitycode '01' = INPATIENT
WHEN CLAIMDATA.formtype NOT IN ('1500','1','P') -- UB04 ONLY
AND LTRIM(RTRIM(ISNULL(CLAIMDATA.facilitycode,''))) = '01'
THEN 'INPATIENT'
WHEN CLAIMDATA.formtype NOT IN ('1500','1','P') -- UB04 ONLY; NOT INPATIENT
AND NOT LTRIM(RTRIM(ISNULL(CLAIMDATA.facilitycode,''))) = '01'
THEN 'OUTPATIENT/OTHER'
ELSE 'N/A (PROFESSIONAL/1500)'
END AS [Service Type IP OP]
,CAST(NULL AS nvarchar(255)) AS [Withhold Amount] -- FIELD(j): FINANCE GAP - SHELL; FINANCE TO CONFIRM SOURCE (SAGE / GL EXPORT) -- SEE ALSO: [Provider Withhold] cd.ffspoolamt AND [Provider Withhold Alt] cd.ProvMedicareMandatedAdjust ALREADY PRESENT ABOVE
,CAST(NULL AS nvarchar(255)) AS [Check Number] -- FIELD(k): FINANCE GAP - SHELL; FINANCE TO CONFIRM SOURCE (SAGE / GL EXPORT) ... LEVERAGE: SELECT * FROM INFORMATICS.dbo.[uvw_CHECK_NUMBER] WHERE 1=1 AND claimid IN ('17172E00609','13108000437','19066E06289') -- PAYTOID aka VENDORID 313691 VERDOLIN MEDICO LEGAL CONSULTING, INC
,CAST(NULL AS nvarchar(255)) AS [RA EOB Explanation Code] -- FIELD(x): FINANCE GAP - SHELL; FINANCE TO CONFIRM SOURCE (SAGE REMIT)
INTO INFORMATICS.dbo.CONTRACTING_PALOMAR_SPEC
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM CLAIMDATA
    INNER JOIN HMOPROD_PLANDATA.dbo.claimdetail (NOLOCK) AS cd ON CLAIMDATA.claimid = cd.claimid

        LEFT JOIN INFORMATICS.dbo.uvw_PATIENTSTATUS (NOLOCK) AS pstat ON CLAIMDATA.claimid = pstat.claimid

        LEFT JOIN HMOPROD_PLANDATA.dbo.claimdrg (NOLOCK) AS cdrg ON CLAIMDATA.claimid = cdrg.claimid -- C001
                AND cdrg.finaldrg+cdrg.SeverityOfIllness IS NOT NULL

        LEFT JOIN INFORMATICS.dbo.[uvw_LINE_OF_BUSINESS] AS bp ON CLAIMDATA.planid = bp.planid

        LEFT JOIN
        ( -- INITIATE ...
        SELECT 'REVENUE_CODE' AS [CodeType]
		,ISNULL(rc.description,'') AS [CodeDescr]
		,rc.*
        ,CASE
        WHEN SUBSTRING(LTRIM(RTRIM(ISNULL(rc.codeid,''))),1,1) = 'Z'
        THEN  LTRIM(RTRIM(rc.codeid))
        WHEN SUBSTRING(LTRIM(RTRIM(ISNULL(rc.codeid,''))),1,1) = '0'
        THEN  SUBSTRING(LTRIM(RTRIM(ISNULL(rc.codeid,''))),2,3)
        ELSE LTRIM(RTRIM(ISNULL(rc.codeid,'')))
        END AS [REVENUE_CODE]
        FROM HMOPROD_PLANDATA.dbo.revcode (NOLOCK) AS rc
        ) -- CONCLUDE ...
        AS revcde ON CASE
        WHEN SUBSTRING(LTRIM(RTRIM(ISNULL(cd.revcode,''))),1,1) = 'Z'
        THEN  LTRIM(RTRIM(cd.revcode))
        WHEN SUBSTRING(LTRIM(RTRIM(ISNULL(cd.revcode,''))),1,1) = '0'
        THEN  SUBSTRING(LTRIM(RTRIM(ISNULL(cd.revcode,''))),2,3)
        ELSE LTRIM(RTRIM(ISNULL(cd.revcode,'')))
        END = revcde.REVENUE_CODE

        LEFT JOIN #POSLOC AS posloc ON UPPER(LTRIM(RTRIM(ISNULL(cd.location,'')))) = posloc.locationcode

        LEFT JOIN #CONTRACTDESCR AS contrdescr ON cd.contractid = contrdescr.contractid

        LEFT JOIN
        ( -- INITIATE ...
        SELECT 'CPT - PROCEDURE_CODE' AS [CodeType],ISNULL(sc.description,'') AS [CodeDescr],sc.*
        FROM HMOPROD_PLANDATA.dbo.svccode (NOLOCK) AS sc
        ) -- CONCLUDE ...
        AS sp ON SUBSTRING(UPPER(LTRIM(RTRIM(ISNULL(cd.servcode,'')))),1,5) = SUBSTRING(UPPER(LTRIM(RTRIM(ISNULL(sp.codeid,'')))),1,5)

        LEFT JOIN HMOPROD_PLANDATA.dbo.member (NOLOCK) AS sme ON CLAIMDATA.memid = sme.memid
        LEFT JOIN INFORMATICS.dbo.[uvw_CLAIMS_CLMTYPE] AS ct ON CLAIMDATA.formtype = ct.formtype
        LEFT JOIN INFORMATICS.dbo.[uvw_CLAIMS_BILLTYPE] AS sbt ON (LTRIM(RTRIM(CLAIMDATA.facilitycode))+LTRIM(RTRIM(CLAIMDATA.billclasscode))+LTRIM(RTRIM(CLAIMDATA.frequencycode))) = sbt.QNXTbilltype
        LEFT JOIN HMOPROD_PLANDATA.dbo.affiliation (NOLOCK) AS a ON CLAIMDATA.affiliationid = a.affiliationid
        LEFT JOIN HMOPROD_PLANDATA.dbo.provider (NOLOCK) AS p1 ON a.provid = p1.provid -- [RENDERING]
        LEFT JOIN HMOPROD_PLANDATA.dbo.provider (NOLOCK) AS p2 ON a.affiliateid = p2.provid -- [PAYTO]

        LEFT JOIN INFORMATICS.dbo.uvw_BASELINE_MEMBERSHIP AS bm ON CLAIMDATA.memid = bm.memid;

CREATE NONCLUSTERED INDEX idx_REFACTOR_DupID ON INFORMATICS.dbo.CONTRACTING_PALOMAR_SPEC ([DupID]);
CREATE NONCLUSTERED INDEX idx_DSNP_claimid ON INFORMATICS.dbo.CONTRACTING_PALOMAR_SPEC (claimid);
CREATE NONCLUSTERED INDEX idx_DSNP_memid ON INFORMATICS.dbo.CONTRACTING_PALOMAR_SPEC (memid);

	-- CHECK FOR DUP(S) --
SELECT ' ' AS 'SHOULD RETURN 0 ROWS - DUP Validation',*
FROM INFORMATICS.dbo.CONTRACTING_PALOMAR_SPEC
WHERE 1=1
    AND [DupID] IN
    ( -- INITIATE ...
    SELECT [DupID]
    FROM INFORMATICS.dbo.CONTRACTING_PALOMAR_SPEC AS dup
    GROUP BY [DupID]
    HAVING COUNT(1)>1
    ) -- CONCLUDE ...







-- =====================================================================
	--  THE FINAL CLAIM:
-- =====================================================================
UPDATE INFORMATICS.dbo.CONTRACTING_PALOMAR_SPEC
SET [THE FINAL CLAIM] = 'N' -- POWER CYCLE RESET REFRESH RESTART ...

UPDATE INFORMATICS.dbo.CONTRACTING_PALOMAR_SPEC
SET [THE FINAL CLAIM] = 'Y'
FROM INFORMATICS.dbo.CONTRACTING_PALOMAR_SPEC AS clm
	INNER JOIN INFORMATICS.dbo.uvw_FINALCLAIM AS fc ON clm.claimid = fc.claimid

/* SELECT ' ' AS 'ARRIVE AT FINAL CLAIM: ',fc.* 
FROM INFORMATICS.dbo.uvw_FINALCLAIM  AS fc
WHERE 1=1 
	-- AND [ROWis] =1
	-- AND [ClaimIdRootPrefix] IN ('23088E00427') -- SAMPLE */







-- =====================================================================
	-- ACCOMMODATION CODE(S) - LEVERAGE: PACS CONTRACTING': 
-- =====================================================================
;WITH acccode AS 
( -- INITIATE ...
SELECT ' ' AS 'ONE 1 OR THE OTHER VAL(): '
,cv.*
FROM HMOPROD_PLANDATA.dbo.ClaimValue AS cv
WHERE 1=1
	-- AND cv.claimid IN ('25135E02709') -- SAMPLE: 
	AND cv.valuecode IN ('24') -- ... Also, per Claims (Rodrigo), the .76 and .75 are separate from the rev code and can be found in QNXT in the Claims Module, go to UB codes and find subsection titled “Value Codes”. The “amount” listed for Value Code 24 will be the code that describes the type of service.
	AND (cv.amount = .75 -- Vent (.75)
		OR cv.amount = .76)  -- Non-Vent (.76)
		) -- CONCLUDE ...

		-- SELECT * FROM acccode
		-- SELECT ' ' AS 'valuecode Descr.',* FROM HMOPROD_PLANDATA.dbo.edi_ub_valuecodes
		-- SELECT ' ' AS 'valuecode Descr.',* FROM HMOPROD_PLANDATA.dbo.ubvalue
		-- SELECT ' ' AS 'valuecode Descr.',* FROM HMOPROD_PLANDATA.dbo.ITSValueCode

	-- CHECK FOR DUP(S) --
/* SELECT ' ' AS 'SHOULD RETURN 0 ROWS - DUP Validation: ',*
FROM acccode
WHERE 1=1 
	AND claimid IN
	( -- INITIATE ...
	SELECT claimid
	FROM acccode AS dup
	GROUP BY claimid -- Duplication Driver 
	HAVING COUNT(1)>1 -- HAVING clause RESERVED for AGGREGATE(s) ... HAVING SUM(PAID_NET_AMT) != 0
	); -- CONCLUDE ... */
	
UPDATE INFORMATICS.dbo.CONTRACTING_PALOMAR_SPEC
SET [Accommodation Code] = TRY_CONVERT(decimal(11,2),cv.amount)
FROM INFORMATICS.dbo.CONTRACTING_PALOMAR_SPEC AS c
	INNER JOIN acccode AS cv ON c.claimid = cv.claimid







-- =====================================================================
	-- TRI (Targeted Rate Increase): 
-- =====================================================================
UPDATE INFORMATICS.dbo.CONTRACTING_PALOMAR_SPEC
SET [TRI Payment] = tri.[ExtraAmountPaid]
FROM INFORMATICS.dbo.CONTRACTING_PALOMAR_SPEC AS c
	INNER JOIN [QNXT_Custom].[TRI].[FfsPaymentDetails] AS tri ON c.claimid = tri.ClaimId
		AND c.claimline = tri.LineNum







-- =====================================================================
	-- QUPD [PROCEDURE_1_CODE]: 
-- =====================================================================
UPDATE INFORMATICS.dbo.CONTRACTING_PALOMAR_SPEC
SET PROCEDURE_1_CODE = pcode
FROM INFORMATICS.dbo.CONTRACTING_PALOMAR_SPEC AS su
	INNER JOIN HMOPROD_PLANDATA.dbo.claimproc (NOLOCK) AS cp ON su.claimid = cp.claimid
WHERE 1=1
	AND ISNULL(cp.proctype,'') = 'Primary'
	AND su.claimline = '1'







-- =====================================================================
	-- PRINCIPAL DIAG  [prindiag] + [poa]: 
-- =====================================================================
UPDATE INFORMATICS.dbo.CONTRACTING_PALOMAR_SPEC
SET [prindiag] = LTRIM(RTRIM(ISNULL(diag.codeid,'')))
,[prindiag descr] = LTRIM(RTRIM(ISNULL(diag.[diag descr],'')))
,[PRESENT ON ADMISSION] = diag.[PRESENT ON ADMISSION]
FROM INFORMATICS.dbo.CONTRACTING_PALOMAR_SPEC AS su	
	INNER JOIN 
	( -- INITIATE ...
	SELECT aliassetup.*
	-- ,DENSE_RANK() OVER (PARTITION BY aliassetup.claimid ORDER BY aliassetup.[sequence] ASC,aliassetup.codeid DESC) AS [RANKis]
	,ROW_NUMBER() OVER (PARTITION BY aliassetup.claimid ORDER BY aliassetup.[sequence] ASC,aliassetup.codeid DESC) AS [ROWis]
	FROM 
	( -- INITIATE ...
	SELECT dx.claimid
	,dx.codeid
	,ISNULL(dc.DESCRIPTION,'') AS [diag descr]
	,dx.[sequence]
	,dx.poa AS 'PRESENT ON ADMISSION'
	,dx.diagtype --Primary, Secondary, Admit, PRV, Trauma, 1, 2, 3, ...
	-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
	-- SELECT DISTINCT ' ' AS 'CHECK 1st'	
	FROM HMOPROD_PLANDATA.dbo.claimdiag (NOLOCK) AS dx
		LEFT JOIN HMOPROD_PLANDATA.dbo.DiagCode (NOLOCK) AS dc ON dx.codeid = dc.codeid
	GROUP BY dx.claimid,dx.codeid,ISNULL(dc.DESCRIPTION,''),dx.sequence,dx.poa,dx.diagtype
	) -- CONCLUDE
	AS aliassetup
	) -- CONCLUDE ...
	AS diag ON su.claimid = diag.claimid
		-- AND diag.sequence = 1 -- ONLY PRIMARY DIAGNOSIS
		-- AND diag.[RANKis] = 1
		AND diag.[ROWis] = 1 -- ONLY PRIMARY DIAGNOSIS
	
	





-- =====================================================================
	-- [Primary or secondary claim] OR [Member Status (Primary, Secondary]: 
-- =====================================================================
UPDATE INFORMATICS.dbo.CONTRACTING_PALOMAR_SPEC
SET [Primary / Secondary Status] = estatus.[Plan Position Status] -- [Primary or secondary claim] OR [Member Status (Primary, Secondary] see "DMP" FOR alt. SEQUENCE
 FROM INFORMATICS.dbo.CONTRACTING_PALOMAR_SPEC AS su 
	INNER JOIN 
	( -- INITIATE ...
	SELECT c.claimid
	,es.primarystatus AS 'Plan Position Status'
	,ek.carriermemid
	,ek.memid
	,es.effdate
	,es.termdate
	,es.primarystatus AS 'STATUS INDICATOR'
	,ec.ratecode
	,bp.programid
	,bp.planid
	,bp.LINE_OF_BUSINESS
	,ek.enrollid
	-- SELECT TOP 10 ' ' AS 'CHECK 1st',estatus.[STATUS INDICATOR],su.* 
	-- SELECT DISTINCT ' ' AS 'CHECK 1st'
	FROM HMOPROD_PLANDATA.dbo.enrollkeys (NOLOCK) AS ek
		INNER JOIN HMOPROD_PLANDATA.dbo.member (NOLOCK) AS mem ON ek.memid = mem.memid
			LEFT JOIN INFORMATICS.dbo.[uvw_LINE_OF_BUSINESS] AS bp ON ek.programid = bp.programid
		INNER JOIN HMOPROD_PLANDATA.dbo.program (NOLOCK) AS pg  ON ek.programid = pg.programid
		INNER JOIN HMOPROD_PLANDATA.dbo.entity (NOLOCK) AS ent ON mem.entityid = ent.entid
		INNER JOIN HMOPROD_PlanData.dbo.enrollstatus (NOLOCK) AS es ON ek.enrollid = es.enrollid		
		INNER JOIN HMOPROD_PLANDATA.dbo.enrollcoverage (NOLOCK) AS ec ON ek.enrollid = ec.enrollid
		INNER JOIN HMOPROD_PLANDATA.dbo.claim (NOLOCK) AS c ON ek.memid = c.memid
			AND ek.enrollid = c.enrollid -- planid / programid JOIN
			AND CAST(c.startdate AS date) BETWEEN CAST(ek.effdate AS date) AND CAST(ek.termdate AS date) -- RINA: APPLIED TO FIELD WITHIN TABLE TO BE UPDATE
	WHERE 1=1
		AND UPPER(LTRIM(RTRIM(ISNULL(ek.segtype,'')))) ='INT'
		AND CAST(ek.termdate AS date) > CAST(ek.effdate AS date) -- MUST BE TRUE ... NON-CROSSFOOTED RECORDS ARE ACTIVE ...
	GROUP BY c.claimid,es.primarystatus,ek.carriermemid,ek.memid,es.effdate,es.termdate,es.primarystatus,ec.ratecode,bp.programid,bp.planid,bp.LINE_OF_BUSINESS,ek.enrollid
	) -- CONCLUDE ...
	AS estatus ON su.claimid = estatus.claimid
WHERE 1=1
	AND CAST(su.DOS AS date) BETWEEN CAST(estatus.effdate AS date) AND CAST(estatus.termdate AS date)	-- RINA: APPLIED TO FIELD WITHIN TABLE TO BE UPDATE







-- =====================================================================
	-- contracted PROVIDER(s) + QUPD TRUST but VERIFY contracted status ci.contracted: 
-- =====================================================================
UPDATE INFORMATICS.dbo.CONTRACTING_PALOMAR_SPEC -- FIVE (5) COMPONENT(s) FIVE (5) table(s) - claim, claimdetail,provider, contractinfo, affiliation ... 
SET contractedVerification = LTRIM(RTRIM(ci.contracted)) -- per SIR ADRIAN THE AFFILIATION SEQUENCE IS THE PREFERRED METHOD PAR STATUS / CONTRACTED ??? POST DISCUSSION WITH SIR EVAN AND LEVERAGING STEP88_QUICKCLAIM_...sql LOGIC ... AS OON, -- TODO:Confirm?
,capitationVerification = LTRIM(RTRIM(ci.iscapitated))
-- SELECT TOP 10 ' ' AS 'CHECK 1st',aff.provid,prov.fullname,ci.contracted,ci.termdate,ci.effdate,ci.lastupdate,c.[description] AS [CONTRACT_DESCR],bp.[description] AS [BENEFIT PLAN DESCR],prog.[description] AS [PROG DESCR],*,ci.contracted,sip.ProviderParStatus,ci.*,sip.*
-- SELECT DISTINCT ' ' AS 'CHECK 1st',contracted,iscapitated FROM HMOPROD_PLANDATA.dbo.contractinfo
FROM INFORMATICS.dbo.CONTRACTING_PALOMAR_SPEC AS source
	INNER JOIN 
	( -- INITIATE ...
	SELECT Cl.claimid
	,Cl.affiliationid
	,Cl.contractnetworkid
	,ClD.contractid
	,bp.LINE_OF_BUSINESS
	,bp.planid
	,bp.programid
	FROM HMOPROD_PlanData.dbo.claim (NOLOCK) AS Cl
		INNER JOIN HMOPROD_PlanData.dbo.claimdetail (NOLOCK) AS ClD ON Cl.claimid = ClD.claimid	
		INNER JOIN INFORMATICS.dbo.[uvw_LINE_OF_BUSINESS] AS bp ON Cl.planid = bp.planid
	GROUP BY Cl.claimid,Cl.affiliationid,Cl.contractnetworkid,ClD.contractid,bp.LINE_OF_BUSINESS,bp.planid,bp.programid
	) -- CONCLUDE ...
	AS hdr ON source.claimid = hdr.claimid
	-- INNER JOIN INFORMATICS.dbo.[uvw_RELAXED_NETWORK_OON] AS ci ON  hdr.programid = ci.programid -- C006: per DISCUSSION WITH MS TATSANI & SIR ADRIAN ON 20250401 REAGARDING "Review OON ON Milliman Claim File" - ACTION ITEM: RELAX TRIZETTO contracted QUERY		
	INNER JOIN HMOPROD_PLANDATA.dbo.contractinfo (NOLOCK) AS ci ON hdr.programid = ci.programid -- ci key#01 smh.programid,
		AND hdr.affiliationid = ci.affiliationid -- ci key#02 a.affiliationid, -- AFFILIATIONID (REMINDER: within memberpcp AFFILIATIONID is the relationship between PCP + SITE (SERVICELOCATION) whereas PAYTOAFFILID within memberpcp represents the relationship between PCP + IPA (PAYTO) FINALLY within CLAIM table a.provid = RENDERING PROVIDER a.affiliateid = PAYTO aka VENDOR	
		AND hdr.contractid = ci.contractid -- ci key#03 see ci.key#04 IN WHERE CLAUSE cd.contractid,
		AND ISNULL(hdr.contractnetworkid,'') = ISNULL(ci.networkid,'') -- ci key#05 ON clm.contractNetworkId LTRIM(RTRIM(clm.contractnetworkid)) AS [NETWORK FLAG], -- DEPRECATED for PROVIDER_PAR_STAT + contractedVerification already present AND to avoid confusion w NetworkID ... ??? (see  INFORMATICS2.dbo.[SHELLprov] was the PARTICIPARTION_FLAG FROM PROVC IN D950 OR see ci.contractnetworkid 20140410)
		AND TRY_CONVERT(date,source.[DOS]) BETWEEN TRY_CONVERT(date,ci.effdate) AND TRY_CONVERT(date,ci.termdate) -- ci key#04 ... NOT NEEDED WHEN JOIN ON uvw_RELAXED_NETWORK_OON

/* UPDATE INFORMATICS.dbo.CONTRACTING_PALOMAR_SPEC
SET contractedVerification = 'Y' -- ACTIVE 274 274 PAR OVERRIDE ~ LEVERAGE "QNXT CXO EXECUTIVE SUMMARY CONTRACT PAR STATUS.jpg" AND 'uvw_FALSE_PROVIDER_PAR' AND 'uvw_ProviderRepository274_PAR' ... contractedVerification = NULL / 'N' NON-PAR (no contractinfo matchand not active on 274 roster) ... ISNULL(contractedVerification,'N')
FROM INFORMATICS.dbo.CONTRACTING_PALOMAR_SPEC AS source
	INNER JOIN SQLPRODAPP01.INFORMATICS.dbo.uvw_ProviderRepository274_PAR AS pr ON ISNULL(source.NPIpayto,'') = ISNULL(pr.[Group NPI],'') */

UPDATE INFORMATICS.dbo.CONTRACTING_PALOMAR_SPEC
SET contractedVerification = 'Y' -- ACTIVE 274 274 PAR OVERRIDE ~ LEVERAGE "QNXT CXO EXECUTIVE SUMMARY CONTRACT PAR STATUS.jpg" AND 'uvw_FALSE_PROVIDER_PAR' AND 'uvw_ProviderRepository274_PAR' ... contractedVerification = NULL / 'N' NON-PAR (no contractinfo matchand not active on 274 roster) ... ISNULL(contractedVerification,'N')
FROM INFORMATICS.dbo.CONTRACTING_PALOMAR_SPEC AS source
	INNER JOIN SQLPRODAPP01.INFORMATICS.dbo.uvw_ProviderRepository274_PAR AS pr ON ISNULL(source.NPIprovnm,'') = ISNULL(pr.[Provider NPI],'') 







-- ============================================================= 
	-- MS ALLYSON + MS HINA ADJ [UNIT(S)]: 
-- =============================================================
UPDATE INFORMATICS.dbo.CONTRACTING_PALOMAR_SPEC
SET [QUANTITY] = q.[QUANTITY] -- ,cd.servunits AS [QUANTITY] ... AS [units_adj] ... AS 'Units adj'
FROM INFORMATICS.dbo.CONTRACTING_PALOMAR_SPEC AS su
	INNER JOIN 
	( -- INITIATE ...
	SELECT DISTINCT claimid
	,claimline
	,CASE
	WHEN planid IN ('QMXBP0823','QMXBP0822','QMXBP0850','QMXBP0851') -- ADD DSNP AS OF 20230101 DSNP MEDICARE PLAN	DSNP MCARE	DSNP MCARE	'QMXBP0850' + DSNP MEDI-CAL PLAN	DSNP MCAL	DSNP MCAL
		AND PAID_NET_AMT > 0 
		AND [Primary / Secondary Status] = 'P' 
	THEN servunits
	WHEN planid IN ('QMXBP0823','QMXBP0822','QMXBP0850','QMXBP0851') -- ADD DSNP AS OF 20230101 DSNP MEDICARE PLAN	DSNP MCARE	DSNP MCARE	'QMXBP0850' + DSNP MEDI-CAL PLAN	DSNP MCAL	DSNP MCAL
		AND sum(PAID_NET_AMT) over (partition by memid,provid,dosfrom,dosto,[CPT Service Code],claimline) > PAID_NET_AMT 
		AND [Primary / Secondary Status] = 'S' 
	THEN 0
	WHEN planid IN ('QMXBP0823','QMXBP0822','QMXBP0850','QMXBP0851') -- ADD DSNP AS OF 20230101 DSNP MEDICARE PLAN	DSNP MCARE	DSNP MCARE	'QMXBP0850' + DSNP MEDI-CAL PLAN	DSNP MCAL	DSNP MCAL
		AND sum(PAID_NET_AMT) over (partition by memid,provid,dosfrom,dosto,[CPT Service Code],claimline) = PAID_NET_AMT 
		AND [Primary / Secondary Status] = 'S' 
	THEN servunits
	WHEN NOT planid IN ('QMXBP0823','QMXBP0822','QMXBP0850','QMXBP0851') -- NO NEGATIVE NOT != <> ... 
	THEN servunits
	ELSE 0 
	END AS [QUANTITY]
	FROM INFORMATICS.dbo.CONTRACTING_PALOMAR_SPEC
	) -- CONCLUDE ...
	AS q ON su.claimid = q.claimid
		AND su.claimline = q.claimline

		/* case
		when c.planid IN ('QMXBP0823','QMXBP0822','QMXBP0850','QMXBP0851') and cdet.amountpaid > 0 and es.primarystatus = 'P' THEN cdet.servunits
		when c.planid IN ('QMXBP0823','QMXBP0822','QMXBP0850','QMXBP0851') and sum(cdet.amountpaid) over (partition by c.memid, c.provid, cdet.dosfrom, cdet.dosto, cdet.servcode, cdet.claimline) > cdet.amountpaid and es.primarystatus = 'S' THEN 0
		when  c.planid IN ('QMXBP0823','QMXBP0822','QMXBP0850','QMXBP0851') and sum(cdet.amountpaid) over (partition by c.memid, c.provid, cdet.dosfrom, cdet.dosto, cdet.servcode, cdet.claimline) = cdet.amountpaid and es.primarystatus = 'S' THEN cdet.servunits
		when c.planid not IN ('QMXBP0823','QMXBP0822','QMXBP0850','QMXBP0851') THEN cdet.servunits
		ELSE 0 end Units_adj */
		
UPDATE INFORMATICS.dbo.CONTRACTING_PALOMAR_SPEC
SET [HCT LOGIC DAY(S)] = t.[QUANTITY] -- AS [units_adj]
FROM INFORMATICS.dbo.CONTRACTING_PALOMAR_SPEC AS t 
	-- INNER JOIN INFORMATICS.dbo.[uvw_CLAIMS_PAID] AS p ON t.claimid = p.claimid -- SETTLE THE PAID CLAIMS ARGUMENT ...
WHERE 1=1 
	-- AND t.revcode BETWEEN '0110' AND '0219' -- HCT LOCK
	AND t.revcode BETWEEN '0101' AND '0219' -- HCT EXPANSION IN ('0101','0190','0160','0169','0112','0199','0185','0180') -- LTC REVENUE CODES per requirements  ... COMBINATION OF MS ALLYSON HCT [day_units] LOGIC (BETWEEN '0110' AND '0219') AND + KINDRED NEGOTIATION PROPOSAL see "CHG- Kindred Initial Proposal Renewal Eff 020124.pdf" (BETWEEN '0100' AND '0219')
	-- AND t.TOTAL_PAID_AMOUNT > 0
	AND NOT NULLIF(t.TOTAL_PAID_AMOUNT,0) = 0 -- NO NOT NEGATIVE <> != ... APPLES TO APPLES PAID LINES ONLY! ... C003: ADJUSTMENT FOR CONTRACTING PROPOSAL OF [HCT LOGIC DAY(S)] PER TEAMS DISCUSSION ON 20260508
	-- AND t.claimid NOT LIKE '%R%'
	-- AND t.HEADERstatus IN ('ADJUCATED','PAID','PAY','REV','REVERSED','REVSYNCH')
	-- AND t.DETAILstatus NOT IN ('DENY','VOID')
	-- AND ISNULL(t.resubclaimid,'') = '' -- ... AND resubclaimid IS NULL







-- =====================================================================
	-- [Cx] / [COS] / [ClaimCategory] CATEGORY OF SERVICE ASSIGNMENT: 
-- =====================================================================
UPDATE INFORMATICS.dbo.CONTRACTING_PALOMAR_SPEC
SET [ClaimCategory] = CAST(NULL AS nvarchar(255)) -- POWER CYCLE RESET REFRESH RESTART ...
,[Cx] = CAST(NULL AS nvarchar(255))

UPDATE INFORMATICS.dbo.CONTRACTING_PALOMAR_SPEC
SET [ClaimCategory] = 'Paid'
FROM INFORMATICS.dbo.CONTRACTING_PALOMAR_SPEC AS sourcetable
	INNER JOIN INFORMATICS.dbo.[uvw_CLAIMS_PAID] AS pc ON sourcetable.claimid = pc.claimid







-- =============================================================
	-- @PARAM(S) / @DECLARE(S) QA: 
-- =============================================================
SELECT ' ' AS 'QA [RANGE]'
,MIN([DOS]) AS [MIN DOS],MAX([DOS]) AS [MAX DOS]
,MIN([DOSTHRU]) AS [MIN DOSTHRU],MAX([DOSTHRU]) AS [MAX DOSTHRU]
,MIN([RECEIVED DATE]) AS [MIN RECEIVED DATE],MAX([RECEIVED DATE]) AS [MAX RECEIVED DATE]
,MIN([CHECK DATE]) AS [MIN CHECK DATE],MAX([CHECK DATE]) AS [MAX CHECK DATE]
,MIN([ADJUDICATE DATE]) AS [MIN ADJUDICATE DATE],MAX([ADJUDICATE DATE]) AS [MAX ADJUDICATE DATE]
,MIN([POST DATE]) AS [MIN POST DATE],MAX([POST DATE]) AS [MAX POST DATE]
,MIN([DISCHARGE DATE]) AS [MIN DISCHARGE DATE],MAX([DISCHARGE DATE]) AS [MAX DISCHARGE DATE]
FROM INFORMATICS.dbo.CONTRACTING_PALOMAR_SPEC

/* SELECT ' ' AS 'QA REV CODE(S)'
,revcode
,[REVCDE Descr]
FROM INFORMATICS.dbo.CONTRACTING_PALOMAR_SPEC
GROUP BY revcode,[REVCDE Descr]

SELECT ' ' AS 'QA CPT CODE(S)'
,[CPT Service Code]
,[CPT Service Description]
FROM INFORMATICS.dbo.CONTRACTING_PALOMAR_SPEC
GROUP BY [CPT Service Code],[CPT Service Description]

SELECT ' ' AS 'QA PRINDIAG(S)'
,[prindiag]
,[prindiag descr]
FROM INFORMATICS.dbo.CONTRACTING_PALOMAR_SPEC
GROUP BY [prindiag],[prindiag descr]

SELECT ' ' AS 'QA HEADER STATUS & planid'
,status
,planid
FROM HMOPROD_PLANDATA.dbo.claim 
WHERE 1=1
	AND  claimid IN  
	( -- INITIATE ...
	SELECT claimid
	FROM INFORMATICS.dbo.CONTRACTING_PALOMAR_SPEC
	GROUP BY claimid
	) --CONCLUDE ...
GROUP BY status,planid */

SELECT ' ' AS 'QA LOB(S)'
,t.LINE_OF_BUSINESS
FROM INFORMATICS.dbo.CONTRACTING_PALOMAR_SPEC AS t
GROUP BY t.LINE_OF_BUSINESS

SELECT ' ' AS 'QA CONTRACTED PROVIDER(S): '	
,u.provid AS [RenderingID]
,u.NPIprovnm AS [Rendering NPI]
,u.PROVNM AS [Rendering Provider]
,piso.SPECdescr AS [Rendering Specialty]
,u.PAYTO AS [PayToID]
,u.NPIpayto AS [PayTo NPI]
,u.PAYTONM AS [PayTo Provider]
,pto.SPECdescr AS [PayTo Specialty]
FROM INFORMATICS.dbo.CONTRACTING_PALOMAR_SPEC AS u
		LEFT JOIN INFORMATICS.dbo.[uvw_PROVISO] AS piso ON u.provid = piso.provid
		LEFT JOIN INFORMATICS.dbo.[uvw_PROVISO] AS pto ON u.payto = pto.provid
WHERE 1=1
	-- AND [ClaimCategory] IN ('Paid')
	AND ISNULL(contractedVerification,'N') = 'Y'
GROUP BY u.provid,u.NPIprovnm,u.PROVNM,piso.SPECdescr,u.PAYTO,u.NPIpayto,u.PAYTONM,pto.SPECdescr

/* SELECT ' ' AS 'QA NON - CONTRACTED PROVIDER(S): '	
,u.provid AS [RenderingID]
,u.NPIprovnm AS [Rendering NPI]
,u.PROVNM AS [Rendering Provider]
,piso.SPECdescr AS [Rendering Specialty]
,u.PAYTO AS [PayToID]
,u.NPIpayto AS [PayTo NPI]
,u.PAYTONM AS [PayTo Provider]
,pto.SPECdescr AS [PayTo Specialty]
FROM INFORMATICS.dbo.CONTRACTING_PALOMAR_SPEC AS u
		LEFT JOIN INFORMATICS.dbo.[uvw_PROVISO] AS piso ON u.provid = piso.provid
		LEFT JOIN INFORMATICS.dbo.[uvw_PROVISO] AS pto ON u.payto = pto.provid
WHERE 1=1
	-- AND [ClaimCategory] IN ('Paid')
	AND ISNULL(contractedVerification,'N') = 'N'h
GROUP BY u.provid,u.NPIprovnm,u.PROVNM,piso.SPECdescr,u.PAYTO,u.NPIpayto,u.PAYTONM,pto.SPECdescr */







-- =============================================================
	--  SUMMARY / SUBTOTAL() ROLLUP v. CUBE:
-- =============================================================
SELECT ' ' AS 'BASELINE SUMMARY BY LOB'
,ISNULL(su.Cx,'NOT YET CLASSIFIED') AS 'Cx'
,su.ExecutionDate
,su.LINE_OF_BUSINESS
,su.[RANGE NOTE(s)]
,su.[Primary / Secondary Status]
,COUNT(DISTINCT(su.memid)) AS 'Unique Members'
,COUNT(DISTINCT(su.claimid)) AS 'Unique Claims'
,COUNT(DISTINCT(su.AdmitID)) AS 'Admits / Visits'
,COUNT(DISTINCT(su.[Alt. AdmitID])) AS 'Alt. Admits / Visits'
,SUM([HCT LOGIC DAY(S)]) AS 'HCT LOGIC DAY(S)'
,SUM(ISNULL(servunits,0)) AS 'QTY'
,SUM(QUANTITY) AS 'Units Adj'
,MIN (TRY_CONVERT(date,DOS)) AS 'MIN() OF RANGE'
,MAX(TRY_CONVERT(date,DOS)) AS 'MAX() OF RANGE'
,MAX(su.[CHECK DATE]) AS RUNOUT_DT
,SUM(su.BILLED_AMT) AS Billed
,SUM(su.ALLOWED_AMT) AS Allowed
,SUM(su.NET_AMT) AS Net
,SUM(su.PAID_NET_AMT) AS Paid
,SUM(su.INT) AS Interest -- ABS(cd.paydiscount) AS [INT]
,SUM(su.[TRI Payment]) AS 'TRI (Targeted Rate Increase) Payment'
FROM INFORMATICS.dbo.CONTRACTING_PALOMAR_SPEC AS su
WHERE 1=1
	AND [ClaimCategory] IN ('Paid')
	-- AND [Primary / Secondary Status] = 'P'
	-- AND ISNULL(resubclaimid,'') = '' -- (c.resubclaimid is NULL or c.resubclaimid = '')
GROUP BY ISNULL(su.Cx,'NOT YET CLASSIFIED'),su.ExecutionDate,su.LINE_OF_BUSINESS,su.[RANGE NOTE(s)],su.[Primary / Secondary Status]







-- =====================================================================
	--  DYNAMIC FEE SCHEDULE -- REVISED: 20260324
-- =====================================================================
-- ======================================
	-- MODIFICATION(S) / CHANGE.LOG: 
-- ======================================
-- M001: Replace hardcoded @SETfeesched = 'C01350904' with a DYNAMIC
      -- CASE expression driven by LINE_OF_BUSINESS + ClmType / formtype
      -- sourced directly from INFORMATICS.dbo.CONTRACTING_PALOMAR_SPEC.

		/* AUTHOR(S): Ms. Allyson (original) | Revised by Informatics / wcarr */

      /* ROUTING MATRIX (from Image 1 / uvw_LINE_OF_BUSINESS cross-validation):
      ┌─────────────────────────────────┬─────────────────┬───────────────┐
      │ LINE_OF_BUSINESS     │ ClmType/formtype│ Fee Sched ID  │
      ├─────────────────────────────────┼─────────────────┼───────────────┤
      │ MEDI-CAL  (LIKE '%MEDI%')       │ FACILITY  (UB92 │ C01350904     │
      │           │  / UB04)        │    │
      │ MEDI-CAL  (LIKE '%MEDI%')       │ PROFESSIONAL    │ C01350903     │
      │           │  (1500)         │    │
      │ DSNP / CSNP  (LIKE '%SNP%')     │ ANY  │ C01011396     │
      │ ALL OTHER            │ ANY  │ C01011395     │
      └─────────────────────────────────┴─────────────────┴───────────────┘ */

		/* • The CASE below mirrors the LOB × ClmType CARTESIAN output validated in
		Image 1 (CHGSD / MEDI-CAL, DSNP, CSNP rows with Fee Schedule SELECTION).
		• @SETfeesched is now SET per-row inside the UPDATE via a correlated
		sub-expression using the claim's own LINE_OF_BUSINESS and ClmType /
		formtype columns already staged in CONTRACTING_PALOMAR_SPEC.
		• Original @SETfeesched single-value DECLARE / SET block is RETAINED
		below (commented out) for rollback / audit purposes per DUB C 2.0. */

-- =====================================================================
	-- STEP 1 -- DECISION SUPPORT QUERY: DYNAMIC FEE SCHEDULE ROUTING MATRIX
-- =====================================================================
		/* Run this first to visually confirm the correct fee schedule per LOB x ClmType ... before executing the UPDATE block below. Output matches Image 1 validation. */

/* SELECT ' ' AS 'DYNAMIC FEE SCHEDULE OPTIONS BY [LOB] AND [ClmType] / [formtype]'
,lob.*
,ct.*
,CASE
WHEN ISNULL(ct.ClmType,'') IN ('FACILITY')
AND ISNULL(lob.LINE_OF_BUSINESS,'') LIKE '%MEDI%'
THEN 'C01350904'  -- Facility / UB04 / UB92 + Medi-Cal
WHEN ISNULL(ct.ClmType,'') IN ('PROFESSIONAL')
AND ISNULL(lob.LINE_OF_BUSINESS,'') LIKE '%MEDI%'
THEN 'C01350903'  -- Professional / 1500 + Medi-Cal
WHEN ISNULL(lob.LINE_OF_BUSINESS,'') LIKE '%SNP%'
THEN 'C01011396'  -- DSNP / CSNP (any ClmType)
ELSE 'C01011395'  -- All other LOBs (fallback)
END AS [Fee Schedule SELECTION]
FROM INFORMATICS.dbo.uvw_LINE_OF_BUSINESS AS lob
CROSS JOIN INFORMATICS.dbo.uvw_CLAIMS_CLMTYPE AS ct (NOLOCK) -- CARTESIAN PRODUCT: LOB × ClmType
WHERE 1=1
    AND ISNULL(lob.BRAND,'') IN ('CHGSD')
    AND ISNULL(lob.LINE_OF_BUSINESS,'') IN ('MEDI-CAL','DSNP','CSNP')
    AND ISNULL(ct.ClmType,'') IN ('PROFESSIONAL','FACILITY') */

	-- Change from C00740459 to C00727442 for hospital claims
/* SET @SETfeesched = CASE 
    WHEN EXISTS (
        SELECT 1 
        FROM HMOPROD_PLANDATA.dbo.claim c
        WHERE c.formtype = 'UB04' -- Hospital Claims
        AND c.claimid IN (SELECT DISTINCT claimid FROM INFORMATICS.dbo.CONTRACTING_PACS)
    )
    THEN 'C00727442' -- Hospital Medi-Cal fee schedule
    ELSE 'C00740459' -- Professional Medi-Cal fee schedule
END; 

		⏎ ASC = Ambulatory Surgical Center
				•	??? - USE 'C00329963'

		⏎ Professional Claim (formtype = 1500)
				•	TRI Medi-cal - USE 'C01350903'
				•	Medi-cal - USE 'C00740459'
				•	Medicare POS = 02, 11, 12, 20, 50 - USE 'C01011396' 
				•	Medicare POS <> 02, 11, 12, 20, 50 - USE 'C01011395'
				
-- ======================================================================
	-- POS, BILL TYPE(S), Dx, PROC + REV: 
-- ======================================================================
SELECT ' ' AS 'PLACE OF SERVICE (POS)',*
FROM HMOPROD_PLANDATA.dbo.hcfaposlocation AS pos (NOLOCK)
WHERE 1=1 
	AND pos.locationcode IN ('02','11','12','20','50') -- Telehealth, Office Visit, Home, Urgent Care Facility & Federally Qualified Health Center				

		⏎ Hospital Claim (formtype = UB04) 
				•	TRI Medi-cal - USE 'C01350904'
				•	Medi-cal - USE 'C00727442'
				•	Medicare - NO NOT NEGATIVE != <> fee schedule. Claims are priced with Hospital OP PPS pricer
				
		⏎ 'PDPM' = PATIENT DRIVEN PAYMENT MODEL - FROM: Elizabeth Valdez, MBA <evaldez@chgsd.com> These rates are uploaded in QNXT annually. Below are the link to the fee schedules for 2024 and 2025.

				USE https://www.dhcs.ca.gov/services/medi-cal/Documents/AB1629/AB1629_WebUpdates/CY2025-FSNF-B-FSSA-Rates-On-File-09152025-Update.xlsx - '2025 rates'
				USE https://www.dhcs.ca.gov/services/medi-cal/Documents/AB1629/AB1629_WebUpdates/CY2024-FSNF-B-FSSA-Rates-On-File-09152025-Update.xlsx - '2024 rates'

		⏎ FOR CONTRACTING ANALYSIS CONSIDER MIN('TRI Medi-cal') OR MAS / BETTER!!! */

-- =====================================================================
--  @SETfeesched -- ORIGINAL HARDCODED BLOCK (RETAINED / COMMENTED OUT)
-- =====================================================================
-- DECLARE @SETfeesched AS VARCHAR(255)
-- SET @SETfeesched = 'C01350904'   -- <-- REPLACED BY DYNAMIC CASE BELOW (M001)
-- =====================================================================

-- =====================================================================
--  STEP 2 -- POWER CYCLE: NULL-RESET ALL EQUIV COLUMNS
-- =====================================================================
UPDATE INFORMATICS.dbo.CONTRACTING_PALOMAR_SPEC
SET  [EQUIV_allow_rate] = CAST(NULL AS MONEY)
    ,[EQUIV_allow_compare] = CAST(NULL AS MONEY)
    ,[EQUIV_allow_rate2] = CAST(NULL AS MONEY)
    ,[EQUIV_allow_compare2] = CAST(NULL AS MONEY)
    ,[EQUIV_allow_rate3] = CAST(NULL AS MONEY)
    ,[EQUIV_allow_compare3] = CAST(NULL AS MONEY)

-- =====================================================================
--  STEP 3 -- MODIFIER DISCOUNT UPDATE
-- =====================================================================
UPDATE INFORMATICS.dbo.CONTRACTING_PALOMAR_SPEC
SET [Modifier Discount] =
      (CASE WHEN md.paypercent  IS NULL THEN 1 ELSE md.paypercent /100 END)
    * (CASE WHEN md2.paypercent IS NULL THEN 1 ELSE md2.paypercent/100 END)
    * (CASE WHEN md3.paypercent IS NULL THEN 1 ELSE md3.paypercent/100 END)
    * (CASE WHEN md4.paypercent IS NULL THEN 1 ELSE md4.paypercent/100 END)
    * (CASE WHEN md5.paypercent IS NULL THEN 1 ELSE md5.paypercent/100 END)
FROM INFORMATICS.dbo.CONTRACTING_PALOMAR_SPEC AS su
    LEFT JOIN HMOPROD_PlanData.dbo.contract AS con  (NOLOCK) ON su.contractid = con.contractid
    LEFT JOIN HMOPROD_PlanData.dbo.moddiscount AS md   (NOLOCK) ON con.moddiscountgroupid = md.moddiscountgroupid   AND su.modcode = md.modcode
    LEFT JOIN HMOPROD_PlanData.dbo.moddiscount AS md2  (NOLOCK) ON con.moddiscountgroupid = md2.moddiscountgroupid  AND su.modcode2 = md2.modcode
    LEFT JOIN HMOPROD_PlanData.dbo.moddiscount AS md3  (NOLOCK) ON con.moddiscountgroupid = md3.moddiscountgroupid  AND su.modcode3 = md3.modcode
    LEFT JOIN HMOPROD_PlanData.dbo.moddiscount AS md4  (NOLOCK) ON con.moddiscountgroupid = md4.moddiscountgroupid  AND su.modcode4 = md4.modcode
    LEFT JOIN HMOPROD_PlanData.dbo.moddiscount AS md5  (NOLOCK) ON con.moddiscountgroupid = md5.moddiscountgroupid  AND su.modcode5 = md5.modcode

-- =====================================================================
--  STEP 4 -- EQUIV_ALLOW_RATE UPDATE  [M001: DYNAMIC @SETfeesched]
-- =====================================================================
--  KEY CHANGE (M001):
--    Each feetable JOIN now uses an inline CASE expression in place of the
--    static @SETfeesched variable, resolving the correct fee schedule code
--    per row based on the claim's own LINE_OF_BUSINESS and ClmType/formtype
--    columns already present in INFORMATICS.dbo.CONTRACTING_PALOMAR_SPEC.
--
--    DYNAMIC FEE SCHEDULE SELECTION INLINE EXPRESSION (reusable pattern):
--    -----------------------------------------------------------------------
--    CASE
--        WHEN ISNULL(su.ClmType,'') IN ('FACILITY')
--  AND ISNULL(su.LINE_OF_BUSINESS,'') LIKE '%MEDI%'
--        THEN 'C01350904'
--        WHEN ISNULL(su.ClmType,'') IN ('PROFESSIONAL')
--  AND ISNULL(su.LINE_OF_BUSINESS,'') LIKE '%MEDI%'
--        THEN 'C01350903'
--        WHEN ISNULL(su.LINE_OF_BUSINESS,'') LIKE '%SNP%'
--        THEN 'C01011396'
--        ELSE 'C01011395'
--    END
--    -----------------------------------------------------------------------
--    This expression is applied identically on every feetable alias
--    (f through f14) in the SET clause and all 14 LEFT JOIN ON predicates.
-- =====================================================================

UPDATE INFORMATICS.dbo.CONTRACTING_PALOMAR_SPEC
SET [EQUIV_allow_rate] =
CASE
WHEN f.feeamount   IS NULL AND f2.feeamount  IS NULL AND f3.feeamount  IS NULL
AND f4.feeamount  IS NULL AND f5.feeamount  IS NULL AND f6.feeamount  IS NULL
AND f7.feeamount  IS NULL AND f8.feeamount  IS NULL AND f9.feeamount  IS NULL
AND f10.feeamount IS NULL AND f11.feeamount IS NULL AND f12.feeamount IS NULL
AND f13.feeamount IS NULL
THEN f14.feeamount
WHEN f.feeamount   IS NULL AND f2.feeamount  IS NULL AND f3.feeamount  IS NULL
AND f4.feeamount  IS NULL AND f5.feeamount  IS NULL AND f6.feeamount  IS NULL
AND f7.feeamount  IS NULL AND f8.feeamount  IS NULL AND f9.feeamount  IS NULL
AND f10.feeamount IS NULL AND f11.feeamount IS NULL AND f12.feeamount IS NULL
THEN f13.feeamount
WHEN f.feeamount   IS NULL AND f2.feeamount  IS NULL AND f3.feeamount  IS NULL
AND f4.feeamount  IS NULL AND f5.feeamount  IS NULL AND f6.feeamount  IS NULL
AND f7.feeamount  IS NULL AND f8.feeamount  IS NULL AND f9.feeamount  IS NULL
AND f10.feeamount IS NULL AND f11.feeamount IS NULL
THEN f12.feeamount
WHEN f.feeamount   IS NULL AND f2.feeamount  IS NULL AND f3.feeamount  IS NULL
AND f4.feeamount  IS NULL AND f5.feeamount  IS NULL AND f6.feeamount  IS NULL
AND f7.feeamount  IS NULL AND f8.feeamount  IS NULL AND f9.feeamount  IS NULL
AND f10.feeamount IS NULL
THEN f11.feeamount
WHEN f.feeamount   IS NULL AND f2.feeamount  IS NULL AND f3.feeamount  IS NULL
AND f4.feeamount  IS NULL AND f5.feeamount  IS NULL AND f6.feeamount  IS NULL
AND f7.feeamount  IS NULL AND f8.feeamount  IS NULL AND f9.feeamount  IS NULL
THEN f10.feeamount
WHEN f.feeamount   IS NULL AND f2.feeamount  IS NULL AND f3.feeamount  IS NULL
AND f4.feeamount  IS NULL AND f5.feeamount  IS NULL AND f6.feeamount  IS NULL
AND f7.feeamount  IS NULL AND f8.feeamount  IS NULL
THEN f9.feeamount
WHEN f.feeamount   IS NULL AND f2.feeamount  IS NULL AND f3.feeamount  IS NULL
AND f4.feeamount  IS NULL AND f5.feeamount  IS NULL AND f6.feeamount  IS NULL
AND f7.feeamount  IS NULL
THEN f8.feeamount
WHEN f.feeamount   IS NULL AND f2.feeamount  IS NULL AND f3.feeamount  IS NULL
AND f4.feeamount  IS NULL AND f5.feeamount  IS NULL AND f6.feeamount  IS NULL
THEN f7.feeamount
WHEN f.feeamount   IS NULL AND f2.feeamount  IS NULL AND f3.feeamount  IS NULL
AND f4.feeamount  IS NULL AND f5.feeamount  IS NULL
THEN f6.feeamount
WHEN f.feeamount   IS NULL AND f2.feeamount  IS NULL AND f3.feeamount  IS NULL
AND f4.feeamount  IS NULL
THEN f5.feeamount
WHEN f.feeamount   IS NULL AND f2.feeamount  IS NULL AND f3.feeamount  IS NULL
THEN f4.feeamount
WHEN f.feeamount   IS NULL AND f2.feeamount  IS NULL
THEN f3.feeamount
WHEN f.feeamount   IS NULL
THEN f2.feeamount
ELSE f.feeamount
END

,[EQUIV_allow_compare] =
CASE
WHEN f.feeamount   IS NULL AND f2.feeamount  IS NULL AND f3.feeamount  IS NULL
AND f4.feeamount  IS NULL AND f5.feeamount  IS NULL AND f6.feeamount  IS NULL
AND f7.feeamount  IS NULL AND f8.feeamount  IS NULL AND f9.feeamount  IS NULL
AND f10.feeamount IS NULL AND f11.feeamount IS NULL AND f12.feeamount IS NULL
AND f13.feeamount IS NULL
THEN f14.feeamount
WHEN f.feeamount   IS NULL AND f2.feeamount  IS NULL AND f3.feeamount  IS NULL
AND f4.feeamount  IS NULL AND f5.feeamount  IS NULL AND f6.feeamount  IS NULL
AND f7.feeamount  IS NULL AND f8.feeamount  IS NULL AND f9.feeamount  IS NULL
AND f10.feeamount IS NULL AND f11.feeamount IS NULL AND f12.feeamount IS NULL
THEN f13.feeamount
WHEN f.feeamount   IS NULL AND f2.feeamount  IS NULL AND f3.feeamount  IS NULL
AND f4.feeamount  IS NULL AND f5.feeamount  IS NULL AND f6.feeamount  IS NULL
AND f7.feeamount  IS NULL AND f8.feeamount  IS NULL AND f9.feeamount  IS NULL
AND f10.feeamount IS NULL AND f11.feeamount IS NULL
THEN f12.feeamount
WHEN f.feeamount   IS NULL AND f2.feeamount  IS NULL AND f3.feeamount  IS NULL
AND f4.feeamount  IS NULL AND f5.feeamount  IS NULL AND f6.feeamount  IS NULL
AND f7.feeamount  IS NULL AND f8.feeamount  IS NULL AND f9.feeamount  IS NULL
AND f10.feeamount IS NULL
THEN f11.feeamount
WHEN f.feeamount   IS NULL AND f2.feeamount  IS NULL AND f3.feeamount  IS NULL
AND f4.feeamount  IS NULL AND f5.feeamount  IS NULL AND f6.feeamount  IS NULL
AND f7.feeamount  IS NULL AND f8.feeamount  IS NULL AND f9.feeamount  IS NULL
THEN f10.feeamount
WHEN f.feeamount   IS NULL AND f2.feeamount  IS NULL AND f3.feeamount  IS NULL
AND f4.feeamount  IS NULL AND f5.feeamount  IS NULL AND f6.feeamount  IS NULL
AND f7.feeamount  IS NULL AND f8.feeamount  IS NULL
THEN f9.feeamount
WHEN f.feeamount   IS NULL AND f2.feeamount  IS NULL AND f3.feeamount  IS NULL
AND f4.feeamount  IS NULL AND f5.feeamount  IS NULL AND f6.feeamount  IS NULL
AND f7.feeamount  IS NULL
THEN f8.feeamount
WHEN f.feeamount   IS NULL AND f2.feeamount  IS NULL AND f3.feeamount  IS NULL
AND f4.feeamount  IS NULL AND f5.feeamount  IS NULL AND f6.feeamount  IS NULL
THEN f7.feeamount
WHEN f.feeamount   IS NULL AND f2.feeamount  IS NULL AND f3.feeamount  IS NULL
AND f4.feeamount  IS NULL AND f5.feeamount  IS NULL
THEN f6.feeamount
WHEN f.feeamount   IS NULL AND f2.feeamount  IS NULL AND f3.feeamount  IS NULL
AND f4.feeamount  IS NULL
THEN f5.feeamount
WHEN f.feeamount   IS NULL AND f2.feeamount  IS NULL AND f3.feeamount  IS NULL
THEN f4.feeamount
WHEN f.feeamount   IS NULL AND f2.feeamount  IS NULL
THEN f3.feeamount
WHEN f.feeamount   IS NULL
THEN f2.feeamount
ELSE f.feeamount
END
* (CASE WHEN md.paypercent  IS NULL THEN 1 ELSE md.paypercent /100 END)
* (CASE WHEN md2.paypercent IS NULL THEN 1 ELSE md2.paypercent/100 END)
* (CASE WHEN md3.paypercent IS NULL THEN 1 ELSE md3.paypercent/100 END)
* (CASE WHEN md4.paypercent IS NULL THEN 1 ELSE md4.paypercent/100 END)
* (CASE WHEN md5.paypercent IS NULL THEN 1 ELSE md5.paypercent/100 END)
* su.QUANTITY
FROM INFORMATICS.dbo.CONTRACTING_PALOMAR_SPEC AS su   (NOLOCK)
		LEFT JOIN HMOPROD_PlanData.dbo.contract AS ct   (NOLOCK) ON su.contractid = ct.contractid
		LEFT JOIN HMOPROD_PlanData.dbo.moddiscount AS md   (NOLOCK) ON ct.moddiscountgroupid = md.moddiscountgroupid   AND su.modcode = md.modcode
		LEFT JOIN HMOPROD_PlanData.dbo.moddiscount AS md2  (NOLOCK) ON ct.moddiscountgroupid = md2.moddiscountgroupid  AND su.modcode2 = md2.modcode
		LEFT JOIN HMOPROD_PlanData.dbo.moddiscount AS md3  (NOLOCK) ON ct.moddiscountgroupid = md3.moddiscountgroupid  AND su.modcode3 = md3.modcode
		LEFT JOIN HMOPROD_PlanData.dbo.moddiscount AS md4  (NOLOCK) ON ct.moddiscountgroupid = md4.moddiscountgroupid  AND su.modcode4 = md4.modcode
		LEFT JOIN HMOPROD_PlanData.dbo.moddiscount AS md5  (NOLOCK) ON ct.moddiscountgroupid = md5.moddiscountgroupid  AND su.modcode5 = md5.modcode

-- =====================================================================
--  [Fee Schedule LEFT JOINs] -- M001: @SETfeesched REPLACED WITH DYNAMIC CASE
-- =====================================================================
		/* PATTERN: Every f/f2…f14 alias now uses the same inline CASE on feetableid ... instead of the former static scalar variable @SETfeesched. */

		LEFT JOIN HMOPROD_PlanData.dbo.feetable AS f (NOLOCK) ON su.[CPT Service Code] = f.mincodeid
			AND su.modcode = f.modcode
			AND su.modcode2 = f.modcode2
			AND su.location = f.locationcode
			AND f.termdate = '12/31/2078'
			AND f.feetableid = CASE
	 -- WHEN ISNULL(su.ClmType,'') IN ('FACILITY') AND ISNULL(su.LINE_OF_BUSINESS,'') LIKE '%MEDI%' THEN 'C01350904'
	 -- WHEN ISNULL(su.ClmType,'') IN ('PROFESSIONAL') AND ISNULL(su.LINE_OF_BUSINESS,'') LIKE '%MEDI%' THEN 'C01350903'
	 WHEN /* ISNULL(su.LINE_OF_BUSINESS,'') LIKE '%SNP%' AND */ ISNULL(su.location,'') IN ('02','11','12','20','50') THEN 'C01011396'
	 ELSE 'C01011395' END

		LEFT JOIN HMOPROD_PlanData.dbo.feetable AS f2   (NOLOCK) ON su.[CPT Service Code] = f2.mincodeid
			AND su.modcode = f2.modcode
			AND su.modcode2 = f.modcode2
			AND ISNULL(f2.locationcode,'') = ''
			AND f2.termdate = '12/31/2078'
			AND f2.feetableid = CASE
	 -- WHEN ISNULL(su.ClmType,'') IN ('FACILITY') AND ISNULL(su.LINE_OF_BUSINESS,'') LIKE '%MEDI%' THEN 'C01350904'
	 -- WHEN ISNULL(su.ClmType,'') IN ('PROFESSIONAL') AND ISNULL(su.LINE_OF_BUSINESS,'') LIKE '%MEDI%' THEN 'C01350903'
	 WHEN /* ISNULL(su.LINE_OF_BUSINESS,'') LIKE '%SNP%' AND */ ISNULL(su.location,'') IN ('02','11','12','20','50') THEN 'C01011396'
	 ELSE 'C01011395' END

		LEFT JOIN HMOPROD_PlanData.dbo.feetable AS f3   (NOLOCK) ON su.[CPT Service Code] = f3.mincodeid
			AND su.modcode = f3.modcode2
			AND su.modcode2 = f3.modcode
			AND su.location = f3.locationcode
			AND f3.termdate = '12/31/2078'
			AND f3.feetableid = CASE
	 -- WHEN ISNULL(su.ClmType,'') IN ('FACILITY') AND ISNULL(su.LINE_OF_BUSINESS,'') LIKE '%MEDI%' THEN 'C01350904'
	 -- WHEN ISNULL(su.ClmType,'') IN ('PROFESSIONAL') AND ISNULL(su.LINE_OF_BUSINESS,'') LIKE '%MEDI%' THEN 'C01350903'
	 WHEN /* ISNULL(su.LINE_OF_BUSINESS,'') LIKE '%SNP%' AND */ ISNULL(su.location,'') IN ('02','11','12','20','50') THEN 'C01011396'
	 ELSE 'C01011395' END

		LEFT JOIN HMOPROD_PlanData.dbo.feetable AS f4   (NOLOCK) ON su.[CPT Service Code] = f4.mincodeid
			AND su.modcode = f4.modcode2
			AND su.modcode2 = f4.modcode
			AND ISNULL(f4.locationcode,'') = ''
			AND f4.termdate = '12/31/2078'
			AND f4.feetableid = CASE
	 -- WHEN ISNULL(su.ClmType,'') IN ('FACILITY') AND ISNULL(su.LINE_OF_BUSINESS,'') LIKE '%MEDI%' THEN 'C01350904'
	 -- WHEN ISNULL(su.ClmType,'') IN ('PROFESSIONAL') AND ISNULL(su.LINE_OF_BUSINESS,'') LIKE '%MEDI%' THEN 'C01350903'
	 WHEN /* ISNULL(su.LINE_OF_BUSINESS,'') LIKE '%SNP%' AND */ ISNULL(su.location,'') IN ('02','11','12','20','50') THEN 'C01011396'
	 ELSE 'C01011395' END

		LEFT JOIN HMOPROD_PlanData.dbo.feetable AS f5   (NOLOCK) ON su.[CPT Service Code] = f5.mincodeid
			AND su.modcode = f5.modcode
			AND su.location = f5.locationcode
			AND f5.termdate = '12/31/2078'
			AND f5.feetableid = CASE
	 -- WHEN ISNULL(su.ClmType,'') IN ('FACILITY') AND ISNULL(su.LINE_OF_BUSINESS,'') LIKE '%MEDI%' THEN 'C01350904'
	 -- WHEN ISNULL(su.ClmType,'') IN ('PROFESSIONAL') AND ISNULL(su.LINE_OF_BUSINESS,'') LIKE '%MEDI%' THEN 'C01350903'
	 WHEN /* ISNULL(su.LINE_OF_BUSINESS,'') LIKE '%SNP%' AND */ ISNULL(su.location,'') IN ('02','11','12','20','50') THEN 'C01011396'
	 ELSE 'C01011395' END

		LEFT JOIN HMOPROD_PlanData.dbo.feetable AS f6   (NOLOCK) ON su.[CPT Service Code] = f6.mincodeid
			AND su.modcode = f6.modcode
			AND ISNULL(f6.locationcode,'') = ''
			AND f6.termdate = '12/31/2078'
			AND f6.feetableid = CASE
	 -- WHEN ISNULL(su.ClmType,'') IN ('FACILITY') AND ISNULL(su.LINE_OF_BUSINESS,'') LIKE '%MEDI%' THEN 'C01350904'
	 -- WHEN ISNULL(su.ClmType,'') IN ('PROFESSIONAL') AND ISNULL(su.LINE_OF_BUSINESS,'') LIKE '%MEDI%' THEN 'C01350903'
	 WHEN /* ISNULL(su.LINE_OF_BUSINESS,'') LIKE '%SNP%' AND */ ISNULL(su.location,'') IN ('02','11','12','20','50') THEN 'C01011396'
	 ELSE 'C01011395' END

		LEFT JOIN HMOPROD_PlanData.dbo.feetable AS f7   (NOLOCK) ON su.[CPT Service Code] = f7.mincodeid
			AND su.modcode2 = f7.modcode
			AND su.location = f7.locationcode
			AND f7.termdate = '12/31/2078'
			AND f7.feetableid = CASE
	 -- WHEN ISNULL(su.ClmType,'') IN ('FACILITY') AND ISNULL(su.LINE_OF_BUSINESS,'') LIKE '%MEDI%' THEN 'C01350904'
	 -- WHEN ISNULL(su.ClmType,'') IN ('PROFESSIONAL') AND ISNULL(su.LINE_OF_BUSINESS,'') LIKE '%MEDI%' THEN 'C01350903'
	 WHEN /* ISNULL(su.LINE_OF_BUSINESS,'') LIKE '%SNP%' AND */ ISNULL(su.location,'') IN ('02','11','12','20','50') THEN 'C01011396'
	 ELSE 'C01011395' END

		LEFT JOIN HMOPROD_PlanData.dbo.feetable AS f8   (NOLOCK) ON su.[CPT Service Code] = f8.mincodeid
			AND su.modcode2 = f8.modcode
			AND ISNULL(f8.locationcode,'') = ''
			AND f8.termdate = '12/31/2078'
			AND f8.feetableid = CASE
	 -- WHEN ISNULL(su.ClmType,'') IN ('FACILITY') AND ISNULL(su.LINE_OF_BUSINESS,'') LIKE '%MEDI%' THEN 'C01350904'
	 -- WHEN ISNULL(su.ClmType,'') IN ('PROFESSIONAL') AND ISNULL(su.LINE_OF_BUSINESS,'') LIKE '%MEDI%' THEN 'C01350903'
	 WHEN /* ISNULL(su.LINE_OF_BUSINESS,'') LIKE '%SNP%' AND */ ISNULL(su.location,'') IN ('02','11','12','20','50') THEN 'C01011396'
	 ELSE 'C01011395' END

		LEFT JOIN HMOPROD_PlanData.dbo.feetable AS f9   (NOLOCK) ON su.[CPT Service Code] = f9.mincodeid
			AND su.modcode3 = f9.modcode
			AND su.location = f9.locationcode
			AND f9.termdate = '12/31/2078'
			AND f9.feetableid = CASE
	 -- WHEN ISNULL(su.ClmType,'') IN ('FACILITY') AND ISNULL(su.LINE_OF_BUSINESS,'') LIKE '%MEDI%' THEN 'C01350904'
	 -- WHEN ISNULL(su.ClmType,'') IN ('PROFESSIONAL') AND ISNULL(su.LINE_OF_BUSINESS,'') LIKE '%MEDI%' THEN 'C01350903'
	 WHEN /* ISNULL(su.LINE_OF_BUSINESS,'') LIKE '%SNP%' AND */ ISNULL(su.location,'') IN ('02','11','12','20','50') THEN 'C01011396'
	 ELSE 'C01011395' END

		LEFT JOIN HMOPROD_PlanData.dbo.feetable AS f10  (NOLOCK) ON su.[CPT Service Code] = f10.mincodeid
			AND su.modcode3 = f10.modcode
			AND ISNULL(f10.locationcode,'') = ''
			AND f10.termdate = '12/31/2078'
			AND f10.feetableid = CASE
	 -- WHEN ISNULL(su.ClmType,'') IN ('FACILITY') AND ISNULL(su.LINE_OF_BUSINESS,'') LIKE '%MEDI%' THEN 'C01350904'
	 -- WHEN ISNULL(su.ClmType,'') IN ('PROFESSIONAL') AND ISNULL(su.LINE_OF_BUSINESS,'') LIKE '%MEDI%' THEN 'C01350903'
	 WHEN /* ISNULL(su.LINE_OF_BUSINESS,'') LIKE '%SNP%' AND */ ISNULL(su.location,'') IN ('02','11','12','20','50') THEN 'C01011396'
	 ELSE 'C01011395' END

		LEFT JOIN HMOPROD_PlanData.dbo.feetable AS f11  (NOLOCK) ON su.[CPT Service Code] = f11.mincodeid
			AND su.modcode4 = f11.modcode
			AND su.location = f11.locationcode
			AND f11.termdate = '12/31/2078'
			AND f11.feetableid = CASE
	 -- WHEN ISNULL(su.ClmType,'') IN ('FACILITY') AND ISNULL(su.LINE_OF_BUSINESS,'') LIKE '%MEDI%' THEN 'C01350904'
	 -- WHEN ISNULL(su.ClmType,'') IN ('PROFESSIONAL') AND ISNULL(su.LINE_OF_BUSINESS,'') LIKE '%MEDI%' THEN 'C01350903'
	 WHEN /* ISNULL(su.LINE_OF_BUSINESS,'') LIKE '%SNP%' AND */ ISNULL(su.location,'') IN ('02','11','12','20','50') THEN 'C01011396'
	 ELSE 'C01011395' END

		LEFT JOIN HMOPROD_PlanData.dbo.feetable AS f12  (NOLOCK) ON su.[CPT Service Code] = f12.mincodeid
			AND su.modcode4 = f12.modcode
			AND ISNULL(f12.locationcode,'') = ''
			AND f12.termdate = '12/31/2078'
			AND f12.feetableid = CASE
	 -- WHEN ISNULL(su.ClmType,'') IN ('FACILITY') AND ISNULL(su.LINE_OF_BUSINESS,'') LIKE '%MEDI%' THEN 'C01350904'
	 -- WHEN ISNULL(su.ClmType,'') IN ('PROFESSIONAL') AND ISNULL(su.LINE_OF_BUSINESS,'') LIKE '%MEDI%' THEN 'C01350903'
	 WHEN /* ISNULL(su.LINE_OF_BUSINESS,'') LIKE '%SNP%' AND */ ISNULL(su.location,'') IN ('02','11','12','20','50') THEN 'C01011396'
	 ELSE 'C01011395' END

		LEFT JOIN HMOPROD_PlanData.dbo.feetable AS f13  (NOLOCK) ON su.[CPT Service Code] = f13.mincodeid
			AND su.modcode5 = f13.modcode
			AND su.location = f13.locationcode
			AND f13.termdate = '12/31/2078'
			AND f13.feetableid = CASE
	 -- WHEN ISNULL(su.ClmType,'') IN ('FACILITY') AND ISNULL(su.LINE_OF_BUSINESS,'') LIKE '%MEDI%' THEN 'C01350904'
	 -- WHEN ISNULL(su.ClmType,'') IN ('PROFESSIONAL') AND ISNULL(su.LINE_OF_BUSINESS,'') LIKE '%MEDI%' THEN 'C01350903'
	 WHEN /* ISNULL(su.LINE_OF_BUSINESS,'') LIKE '%SNP%' AND */ ISNULL(su.location,'') IN ('02','11','12','20','50') THEN 'C01011396'
	 ELSE 'C01011395' END

		LEFT JOIN HMOPROD_PlanData.dbo.feetable AS f14  (NOLOCK) ON su.[CPT Service Code] = f14.mincodeid
			AND su.modcode5 = f14.modcode
			AND ISNULL(f14.locationcode,'') = ''
			AND f14.termdate = '12/31/2078'
			AND f14.feetableid = CASE
	 -- WHEN ISNULL(su.ClmType,'') IN ('FACILITY') AND ISNULL(su.LINE_OF_BUSINESS,'') LIKE '%MEDI%' THEN 'C01350904'
	 -- WHEN ISNULL(su.ClmType,'') IN ('PROFESSIONAL') AND ISNULL(su.LINE_OF_BUSINESS,'') LIKE '%MEDI%' THEN 'C01350903'
	 WHEN /* ISNULL(su.LINE_OF_BUSINESS,'') LIKE '%SNP%' AND */ ISNULL(su.location,'') IN ('02','11','12','20','50') THEN 'C01011396'
	 ELSE 'C01011395' END
	WHERE 1=1
		AND [EQUIV_allow_rate] IS NULL







-- =======================================================================
	-- CONTRACTING SUMMARY ANALYSIS (WITH ZERO HANDLING) - CLAIMLINE DETAIL: 
-- =======================================================================
SELECT DISTINCT 'CONTRACTING PROPOSAL DEVELOPMENT: ' AS [Scenario]
,claimid
,claimline
,AdmitID
,[Alt. AdmitID]
,LINE_OF_BUSINESS
,ISNULL(LINE_OF_BUSINESS,'')+' '+ISNULL([Primary / Secondary Status],'') AS 'LOB'
,PAYTONM
,memid
,revcode
,[REVCDE Descr]
,[CPT Service Code]
,[CPT Service Description]
,[HCT LOGIC DAY(S)]
,QUANTITY
,BILLED_AMT
,ALLOWED_AMT
,NET_AMT
,PAID_NET_AMT AS 'Actual_Payment'
,[TRI Payment]
,EQUIV_allow_rate AS 'Fee Schedule Rate'
,EQUIV_allow_compare AS 'Fee Schedule Paid'
/* ,EQUIV_allow_rate2 AS 'Medicare In Office NF Rate'
,EQUIV_allow_compare2 AS 'Medicare In Office NF Paid'
,EQUIV_allow_rate3 AS 'Medicare Out of Office NF Rate'
,EQUIV_allow_compare3 AS 'Medicare Out of Office NF Paid' */
,NULLIF(PAID_NET_AMT,0) * 1.00 AS 'Current_Rate_Payment' -- ASSUME THAT WHAT HAS BEEN PAID IS WHAT THE CONTRACTING DEPT. HAS DOCUMENTED
,CASE -- C008: LO-HAR SENIOR LIVING 20260615 -- Medi-Cal AND Medicare LOB -- Rev Code 0101 Custodial Care per diem basis
-- =====================================================================
-- REV CODE 0101 CUSTODIAL CARE: single qualifying branch
-- DESIGN: Rev code normalized via SUBSTRING to strip leading zero; all non-0101 lines are hard-stopped at ELSE = 0
-- =====================================================================
WHEN revcode IN ('0101','0160') -- Rev Code 0101 Custodial Care -- current $170.00/day -> proposed three-year step-up per contracting request 20260612
THEN CAST('Rev Code 0101 - Custodial Care' AS nvarchar(255))
-- WHEN ... -- NO ADDITIONAL BRANCHES SUPPORTED BY CURRENT CONTRACTING REQUEST DOCUMENTATION
ELSE CAST('Other Services' AS nvarchar(255)) -- services outside Lo-Har Senior Living Rev Code 0101 scope -- default catch-all per corpus standard
END AS 'Contracting_Proposal_Category'

,CASE -- C008: LO-HAR SENIOR LIVING 20260615 -- Medi-Cal AND Medicare LOB -- Rev Code 0101 Custodial Care per diem basis
-- =====================================================================
-- REV CODE 0101 CUSTODIAL CARE: three-year step-up per diem
-- UNIT DRIVER: [HCT LOGIC DAY(S)] -- revenue codes 0101-0219 already populated via UPDATE above
-- YEAR DISCRIMINATOR: [YEAR_DOS] (yyyymm substring already staged as 4-char year in CONTRACTING_PALOMAR_SPEC)
-- Yr 1 DOS YEAR 2025: $225.00/day | Yr 2 DOS YEAR 2026: $231.75/day | Yr 3 DOS YEAR 2027: $238.70/day
-- =====================================================================
WHEN revcode IN ('0101','0160') -- Rev Code 0101 Custodial Care -- current $170.00/day -> proposed three-year step-up per contracting request 20260612
THEN NULLIF(ISNULL([HCT LOGIC DAY(S)],0),0) * 225.00 -- Yr 1: $225.00/day
-- THEN NULLIF(ISNULL([HCT LOGIC DAY(S)],0),0) * 231.75 -- Yr 2: $231.75/day
-- THEN NULLIF(ISNULL([HCT LOGIC DAY(S)],0),0) * 238.70 -- Yr 3: $238.70/day
-- WHEN ... -- NO ADDITIONAL BRANCHES SUPPORTED BY CURRENT CONTRACTING REQUEST DOCUMENTATION
ELSE 0 -- DEFAULT: facility provider -- uncategorized lines or non-0101 rev codes are hard stop per corpus standard
END AS 'Proposed_Rate_Payment'
,ISNULL((NULLIF(ISNULL(EQUIV_allow_compare,0),0)* 1.05),((NULLIF(ISNULL(PAID_NET_AMT,0),0)+ISNULL([TRI Payment],0)) * 1.05)) AS 'Counter_Offer_Payment' -- ASSUME THAT WHAT HAS BEEN PAID IS WHAT THE CONTRACTING DEPT. HAS DOCUMENTED
-- ,ISNULL((NULLIF(ISNULL(EQUIV_allow_compare,0),0)* 1.05),(NULLIF(ISNULL(PAID_NET_AMT,0),0) * 1.05)) AS 'Counter_Offer_Payment' -- ASSUME THAT WHAT HAS BEEN PAID IS WHAT THE CONTRACTING DEPT. HAS DOCUMENTED
-- ,NULLIF(ISNULL(PAID_NET_AMT,0),0) * 1.05 AS 'Counter_Offer_Payment' -- ASSUME THAT WHAT HAS BEEN PAID IS WHAT THE CONTRACTING DEPT. HAS DOCUMENTED
INTO #ContractAnalysis
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st',[LOB],LINE_OF_BUSINESS
FROM INFORMATICS.dbo.CONTRACTING_PALOMAR_SPEC AS clm
WHERE 1=1
	AND [ClaimCategory] IN ('Paid') -- PAID CLAIMS ONLY!!!
    -- AND LINE_OF_BUSINESS LIKE '%MEDI%CAL%' -- C008: LO-HAR SENIOR LIVING -- Medi-Cal AND Medicare LOB (both captured per contracting request 20260612) -- no LOB filter applied
	AND [Primary / Secondary Status] = 'P'
	AND NOT NULLIF(PAID_NET_AMT,0) = 0 -- NO NOT NEGATIVE <> != ... APPLES TO APPLES PAID LINES ONLY!
	-- AND NOT NULLIF(ISNULL([EQUIV_allow_compare],0),0) = 0 -- NO NOT NEGATIVE <> != ... APPLES TO APPLES EQUIV FEE SCHEDULE VAL ONLY!

-- ======================================================================================
	-- INCLUSION / EXCLUSION ... ER (EMERGENCY ROOM) VISIT THAT RESULTS IN AN IP (INPATIENT) ADMIT: 
-- ======================================================================================
;WITH ipa AS
( -- INITIATE ...
SELECT su.memid
,su.claimid
,su.claimline
,su.DOS AS 'AdmissionDate'
,TRY_CONVERT(date,ISNULL(su.DOSTHRU,GETDATE())) AS 'DischargeDate'
FROM INFORMATICS.dbo.CONTRACTING_PALOMAR_SPEC AS su
	INNER JOIN #ContractAnalysis AS ca ON su.claimid = ca.claimid
		AND su.claimline = ca.claimline
WHERE 1=1
	AND ca.Contracting_Proposal_Category LIKE '%Inpatient%'
GROUP BY su.memid,su.claimid,su.claimline,su.DOS,TRY_CONVERT(date,ISNULL(su.DOSTHRU,GETDATE()))
) -- CONCLUDE ...

		-- SELECT *,DATEADD(day,1,TRY_CONVERT(date,AdmissionDate)) AS 'Day After AdmissionDate' FROM ipa

,erv AS
( -- INITIATE ...
SELECT er.memid
,er.claimid
,er.claimline
,er.DOS AS 'AdmissionDate'
,TRY_CONVERT(date,ISNULL(er.DOSTHRU,GETDATE())) AS 'DischargeDate'
FROM INFORMATICS.dbo.CONTRACTING_PALOMAR_SPEC AS er
WHERE 1=1
	AND CASE
	WHEN SUBSTRING(LTRIM(RTRIM(ISNULL(er.revcode,''))),1,1) = 'Z'
	THEN  LTRIM(RTRIM(er.revcode))
	WHEN SUBSTRING(LTRIM(RTRIM(ISNULL(er.revcode,''))),1,1) = '0'
	THEN  SUBSTRING(LTRIM(RTRIM(ISNULL(er.revcode,''))),2,3)
	ELSE LTRIM(RTRIM(ISNULL(er.revcode,'')))
	END LIKE '45%'
	AND (er.QNXTbilltype  LIKE '13%' -- HOSPITAL  OP
		OR er.QNXTbilltype  LIKE '14%') -- HOSPITAL Oth
	AND er.[ClmType] = 'FACILITY'
GROUP BY er.memid,er.claimid,er.claimline,er.DOS,TRY_CONVERT(date,ISNULL(er.DOSTHRU,GETDATE()))
) -- CONCLUDE ...

		-- SELECT * FROM erv

,ipaviatheer AS 
( -- INITIATE ...
SELECT ip.*
FROM ipa AS ip
	INNER JOIN erv AS er ON ip.memid = er.memid
WHERE 1=1
	AND TRY_CONVERT(date,er.DischargeDate) BETWEEN TRY_CONVERT(date,ip.AdmissionDate) AND DATEADD(day,1,TRY_CONVERT(date,ip.AdmissionDate)) -- RINA(): APPLIED TO FIELD WITHIN TABLE TO BE UPDATED 
	)
	
		-- SELECT * FROM ipaviatheer

		/* SELECT ' ' AS 'QA ER THAT RESULT INTO AN IP ADMIT: '
		,memid
		,SUBSCRID AS 'HealthPlanID'
		,MEMNM
		,QNXTbilltype
		,BillTypeDescr
		,revcode
		,[REVCDE Descr]
		,DOS
		,DOSTHRU,* 
		FROM INFORMATICS.dbo.CONTRACTING_PALOMAR_SPEC AS su
		WHERE 1=1 
			AND su.memid IN ('853483','2060516','1046703')
		ORDER BY su.memid,TRY_CONVERT(date,DOS) ASC */

UPDATE #ContractAnalysis
SET Contracting_Proposal_Category = 'Inpatient Services through the ER' -- OPPOSITE OF "All Other Inpatient Services" WHICH WOULD REPRESNT IP ABSENT OF AN EMERGENCY ROOM ENCOUNTER */
FROM #ContractAnalysis AS ca
		INNER JOIN ipaviatheer AS iper ON ca.memid = iper.memid
			AND ca.claimid = iper.claimid
			AND ca.claimline = iper.claimline
			
		-- SELECT QNXTbilltype,BillTypeDescr FROM INFORMATICS.dbo.CONTRACTING_PALOMAR_SPEC GROUP BY QNXTbilltype,BillTypeDescr

;WITH entireclaimer AS
( -- INITIATE ...
SELECT er.memid
,er.claimid
,er.claimline
,er.DOS AS 'AdmissionDate'
,TRY_CONVERT(date,ISNULL(er.DOSTHRU,GETDATE())) AS 'DischargeDate'
FROM INFORMATICS.dbo.CONTRACTING_PALOMAR_SPEC AS er
WHERE 1=1
	AND CASE
	WHEN SUBSTRING(LTRIM(RTRIM(ISNULL(er.revcode,''))),1,1) = 'Z'
	THEN  LTRIM(RTRIM(er.revcode))
	WHEN SUBSTRING(LTRIM(RTRIM(ISNULL(er.revcode,''))),1,1) = '0'
	THEN  SUBSTRING(LTRIM(RTRIM(ISNULL(er.revcode,''))),2,3)
	ELSE LTRIM(RTRIM(ISNULL(er.revcode,'')))
	END IN ('450')
	AND er.QNXTbilltype IN ('111','117') -- C006: REVISED ER DEFINITION PER DSCUSSION WITH MS GRISELDA ON 20250929 '... I spoke briefly with Griselda and Rodrigo regarding identifying "Inpatient Services through the ER". ..'
GROUP BY er.memid,er.claimid,er.claimline,er.DOS,TRY_CONVERT(date,ISNULL(er.DOSTHRU,GETDATE()))
) -- CONCLUDE ...

		-- SELECT * FROM entireclaimer

UPDATE #ContractAnalysis
SET Contracting_Proposal_Category = 'Inpatient Services through the ER' -- OPPOSITE OF "All Other Inpatient Services" WHICH WOULD REPRESNT IP ABSENT OF AN EMERGENCY ROOM ENCOUNTER */
FROM #ContractAnalysis AS ca
	INNER JOIN entireclaimer AS iper ON ca.claimid = iper.claimid

SELECT ' ' AS 'TEMPLATE: HYBRID JAG SUMMARY',LINE_OF_BUSINESS,
COUNT(DISTINCT(memid)) AS 'Unduplicated Members',
COUNT(DISTINCT(claimid)) AS 'Unique Claim Count',
COUNT(DISTINCT(AdmitID)) AS 'Admit Visit',
SUM(CASE WHEN ISNULL([HCT LOGIC DAY(S)],0) = 0 THEN ISNULL(QUANTITY,0) ELSE ISNULL([HCT LOGIC DAY(S)],0) END) AS [Days / Units],
SUM([HCT LOGIC DAY(S)]) AS 'Total_Days',
SUM(QUANTITY) AS 'Total_Units',
SUM(BILLED_AMT) AS 'Total_Billed',
SUM(Actual_Payment) AS 'Actual_Payment_Total',
SUM(Current_Rate_Payment) AS 'Current_Rate_Total',
SUM(Proposed_Rate_Payment) AS 'Proposed_Rate_Total',
SUM(Counter_Offer_Payment) AS 'Counter_Offer_Total',
CASE 
WHEN SUM(Current_Rate_Payment) = 0 
THEN 'N/A'
ELSE TRY_CONVERT(nvarchar(255),TRY_CONVERT(decimal(9,3),((SUM(Proposed_Rate_Payment) / NULLIF(SUM(Current_Rate_Payment),0)) - 1) * 100)) + '%'
END AS 'Overall_Proposed_Impact',
CASE 
WHEN SUM(Current_Rate_Payment) = 0 
THEN 'N/A'
ELSE TRY_CONVERT(nvarchar(255),TRY_CONVERT(decimal(9,3),((SUM(Counter_Offer_Payment) / NULLIF(SUM(Current_Rate_Payment),0)) - 1) * 100)) + '%'
END AS 'Overall_Counter_Impact',
SUM([TRI Payment]) AS 'TRI (Targeted Rate Increase Payment)' -- ,[TRI Payment] 
FROM #ContractAnalysis
WHERE 1=1
	-- AND NOT [Contracting_Proposal_Category] IN ('Other Services') -- NO NOT NEGATIVE <> != THE 'DEFAULT CATCH - ALL'
GROUP BY LINE_OF_BUSINESS;

SELECT ' ' AS 'TEMPLATE: BY [Contracting_Proposal_Category] WITH DYNAMIC COUNTER % Summary',
PAYTONM AS [Pay To Provider],
[LOB],
[Contracting_Proposal_Category] AS 'Category',
COUNT(DISTINCT(AdmitID)) AS 'Admit Visit Interaction',
COUNT(DISTINCT memid) AS [Total Unique Members],
SUM(Actual_Payment) AS [Actual Amount Paid],
SUM(CASE WHEN ISNULL([HCT LOGIC DAY(S)],0) = 0 THEN ISNULL(QUANTITY,0) ELSE ISNULL([HCT LOGIC DAY(S)],0) END) AS [Days / Units],
TRY_CONVERT(nvarchar(255),NULL) AS 'Unit Type ',
TRY_CONVERT(nvarchar(255),NULL) AS 'Currently Paid at: ',
SUM(Proposed_Rate_Payment) AS [Proposed Total Paid],
TRY_CONVERT(nvarchar(255),NULL) AS 'Proposed Rate: ',
SUM([TRI Payment]) AS 'TRI (Targeted Rate Increase Payment)' -- ,[TRI Payment] 
FROM #ContractAnalysis
WHERE 1=1
	-- AND NOT [Contracting_Proposal_Category] IN ('Other Services') -- NO NOT NEGATIVE <> != THE 'DEFAULT CATCH - ALL'
	AND [LOB] IS NOT NULL -- NO NOT NEGATIVE <> != ONLY PULL ASSIGNED LOB CLAIM LINE DETAIL
GROUP BY PAYTONM,LOB,[Contracting_Proposal_Category]
ORDER BY PAYTONM,[Contracting_Proposal_Category];

SELECT ' ' AS 'TEMPLATE: BY [Pay To Provider] WITH DYNAMIC COUNTER % Summary',
PAYTONM AS [Pay To Provider],
[LOB],
COUNT(DISTINCT memid) AS [Total Unique Members],
SUM(Actual_Payment) AS [Actual Amount Paid],
SUM(CASE WHEN ISNULL([HCT LOGIC DAY(S)],0) = 0 THEN ISNULL(QUANTITY,0) ELSE ISNULL([HCT LOGIC DAY(S)],0) END) AS [Days / Units],
SUM(Proposed_Rate_Payment) AS [Proposed Total Paid],
SUM([TRI Payment]) AS 'TRI (Targeted Rate Increase Payment)' -- ,[TRI Payment] 
FROM #ContractAnalysis
WHERE 1=1
	-- AND NOT [Contracting_Proposal_Category] IN ('Other Services') -- NO NOT NEGATIVE <> != THE 'DEFAULT CATCH - ALL'
GROUP BY PAYTONM,LOB
ORDER BY PAYTONM;

SELECT ' ' AS 'TEMPLATE: FULL Summary BY CPT / Revenue Code with ZERO Handling',
PAYTONM AS [Pay To Provider],
[LOB],
revcode,
[REVCDE Descr] AS 'Revcode Descr.',
[CPT Service Code],
[CPT Service Description] AS 'CPT Descr.',
COUNT(DISTINCT memid) AS [Number of Members],
COUNT(DISTINCT claimid) AS [Number of Claims],
SUM(CASE WHEN ISNULL([HCT LOGIC DAY(S)],0) = 0 THEN ISNULL(QUANTITY,0) ELSE ISNULL([HCT LOGIC DAY(S)],0) END) AS [Days / Units],
SUM(Actual_Payment) AS [CHG Total Paid],
SUM(Proposed_Rate_Payment) AS [Proposed Total Paid (###% of ... )],
-- SUM(Proposed_Rate_Payment2) AS [Proposed Total Paid (###% of In-Office Medicare)],
-- SUM(Proposed_Rate_Payment3) AS [Proposed Total Paid (###% of In-Office Medicare)],
-- SUM(Proposed_Rate_Payment4) AS [Proposed Total Paid (###% of Out of Office Medicare)],
-- SUM(Proposed_Rate_Payment5) AS [Proposed Total Paid (###% of Out of Office Medicare)],
(SUM(Proposed_Rate_Payment) - (SUM(ISNULL(Actual_Payment, 0)) + SUM(ISNULL([TRI Payment], 0)))) AS [Dollar Difference between CHG Total Paid and Proposed Total Paid],
CASE 
WHEN SUM(Current_Rate_Payment) = 0 
THEN 'N/A'
WHEN SUM([TRI Payment]) = 0
THEN TRY_CONVERT(nvarchar(255),TRY_CONVERT(decimal(9,3),((SUM(Proposed_Rate_Payment) / (NULLIF(SUM(ISNULL(Actual_Payment,0)),0))) - 1) * 100)) + '%' 
ELSE TRY_CONVERT(nvarchar(255),TRY_CONVERT(decimal(9,3),((SUM(Proposed_Rate_Payment) / (NULLIF(SUM(ISNULL(Actual_Payment,0)),0)+NULLIF(SUM(ISNULL([TRI Payment],0)),0))) - 1) * 100)) + '%' 
END AS [Percent Difference between CHG Total Paid and Proposed Total Paid],
[Contracting_Proposal_Category],
SUM([TRI Payment]) AS 'TRI (Targeted Rate Increase Payment)' -- [TRI Payment] 
FROM #ContractAnalysis
WHERE 1=1
	-- AND NOT [Contracting_Proposal_Category] IN ('Other Services') -- NO NOT NEGATIVE <> != THE 'DEFAULT CATCH - ALL'
GROUP BY PAYTONM,[LOB],revcode,[REVCDE Descr],[CPT Service Code],[CPT Service Description] ,[Contracting_Proposal_Category]
ORDER BY PAYTONM,revcode,[CPT Service Code];

SELECT ' ' AS 'TEMPLATE: HYBRID FULL Summary BY [Contracting_Proposal_Category] BY CPT / Revenue Code with ZERO Handling',
'All Pay To Providers Combined' AS [Pay To Provider],
[LOB],
revcode,
[REVCDE Descr] AS 'Revcode Descr.',
[CPT Service Code],
[CPT Service Description] AS 'CPT Descr.',
COUNT(DISTINCT memid) AS [Number of Members],
COUNT(DISTINCT claimid) AS [Number of Claims],
SUM(CASE WHEN ISNULL([HCT LOGIC DAY(S)],0) = 0 THEN ISNULL(QUANTITY,0) ELSE ISNULL([HCT LOGIC DAY(S)],0) END) AS [Days / Units],
SUM(Actual_Payment) AS [CHG Total Paid],
SUM(Proposed_Rate_Payment) AS [Proposed Total Paid (100% of Med-Cal)],
-- SUM(Proposed_Rate_Payment2) AS [Proposed Total Paid (100% of In-Office Medicare)],
-- SUM(Proposed_Rate_Payment3) AS [Proposed Total Paid (130% of In-Office Medicare)],
-- SUM(Proposed_Rate_Payment4) AS [Proposed Total Paid (100% of Out of Office Medicare)],
-- SUM(Proposed_Rate_Payment5) AS [Proposed Total Paid (130% of Out of Office Medicare)],
(SUM(Proposed_Rate_Payment) - (SUM(ISNULL(Actual_Payment, 0)) + SUM(ISNULL([TRI Payment], 0)))) AS [Dollar Difference between CHG Total Paid and Proposed Total Paid],
CASE 
WHEN SUM(Current_Rate_Payment) = 0 
THEN 'N/A'
WHEN SUM([TRI Payment]) = 0
THEN TRY_CONVERT(nvarchar(255),TRY_CONVERT(decimal(9,3),((SUM(Proposed_Rate_Payment) / (NULLIF(SUM(ISNULL(Actual_Payment,0)),0))) - 1) * 100)) + '%' 
ELSE TRY_CONVERT(nvarchar(255),TRY_CONVERT(decimal(9,3),((SUM(Proposed_Rate_Payment) / (NULLIF(SUM(ISNULL(Actual_Payment,0)),0)+NULLIF(SUM(ISNULL([TRI Payment],0)),0))) - 1) * 100)) + '%' 
END AS [Percent Difference between CHG Total Paid and Proposed Total Paid],
[Contracting_Proposal_Category],
SUM([TRI Payment]) AS 'TRI (Targeted Rate Increase Payment)' -- ,[TRI Payment] 
FROM #ContractAnalysis AS ca
WHERE 1=1
	-- AND NOT [Contracting_Proposal_Category] IN ('Other Services') -- NO NOT NEGATIVE <> != THE 'DEFAULT CATCH - ALL'
GROUP BY [LOB],revcode,[REVCDE Descr],[CPT Service Code],[CPT Service Description] ,ca.[Contracting_Proposal_Category]
ORDER BY ca.[Contracting_Proposal_Category],revcode,[CPT Service Code];

 -- =======================================================================
	-- CONTRACTING CXO EXECUTIVE SUMMARY: 
-- =======================================================================
		/* ?  'SAMPLE CXO EXCUTIVE SUMMARY': ie. eg.		
				~ see "MODIFY_EXISTING_CODE.sql", FROM:WALTER SUBJECT:"*CONTRACT*"
		
CXO Executive Summary: The Proposal Category CASE statement classifies healthcare claims by line detail specifically for providers with NPI 1457321317 or 1376513754, OR TIN/FEDID #95-6003843. The classification system includes specific bill type requirements and expanded revenue code coverage.

Source: QNXT
•	Summary includes “PAID” claims ONLY.

LOB: Medi-Cal 
Amount paid during time period: $ 3,039,311 
Proposed amount paid: $ 3,664,500 
This is a difference of: $625,189 (21%)

Key Categories and Business Rules:
		1.	Administrative Days (Ok.) 
				o	Applies to revenue codes 0169, 0190, and 0199
				o	Requires validation of HCT Logic Days (non-zero)
				o	Enforces a $500 per diem rate requirement
				o	Notable: Recent business decision to exclude cases not meeting the $500/day threshold

		2.	IP Skilled Nursing (Ok.) 
				o	Covers revenue codes 0191-0194
				o	Represents inpatient skilled nursing services

		3.	Boarder Baby Services (Ok.) 
				o	Includes revenue codes 0170, 0171, and 0179
				o	Specific category for newborn care services

		4.	Radiation Oncology 
				o	Encompasses revenue codes 0330-0339 and bill type 13X or 14X
				o	Reimbursement set at 120% of Medi-Cal rates
				o	Important: Excludes claims without established Medi-Cal reference rates

		5.	OP Implants 
				o	Covers revenue codes 0275, 0276, 0278, and 0279 and 0274 and bill type 13X or 14X
				o	Reimbursement structured at 50% of charges

		6.	Other OP Services where service does not land in previous categories and the bill type is 13X or 14X 
				o	Serves as the catch all / default category for all other outpatient services

Business Impact: The classification system now includes specific bill type requirements (13X or 14X) for outpatient services and encompasses additional revenue codes, ensuring more accurate categorization of claims for the specified providers.

Please NOTE: There are instance whereby for the OP Implant category the whole claim vs claim line paid amount scenario which caused concern persist, thus skewing the analysis: */

-- =======================================================================
	-- CONTRACTING DETAIL: 
-- =======================================================================
SELECT DISTINCT ' ' AS 'CONTRACTING - DETAIL: '
,su.[RANGE NOTE(s)]
,su.[ExecutionDate] AS [Report Run date time]
,TRY_CONVERT(date,SUBSTRING(su.[RANGE NOTE(S)],21,10)) AS [time period start date]
,TRY_CONVERT(date,SUBSTRING(su.[RANGE NOTE(S)],36,10)) AS [time period end date]
,su.[EQUIV_allow_rate]
,su.[EQUIV_allow_rate2]
,su.[EQUIV_allow_rate3]
,su.LINE_OF_BUSINESS AS [LOB]
,su.[Primary / Secondary Status] AS [plan position]
,ISNULL(su.LINE_OF_BUSINESS,'')+' '+ISNULL(su.[Primary / Secondary Status],'') AS [plan position status]
,su.DOS
,su.DOSTHRU
,su.dosfrom AS [dos from]
,su.dosto AS [dos to]
,su.claimid
,su.claimline AS [claim line]
,su.AdmitID
,su.[Alt. AdmitID]
,su.HEADERstatus AS [claim status]
,su.servunits
,su.QUANTITY AS [Units adj] -- ,su.cd.servunits AS [QUANTITY] ... AS [units_adj] ... AS 'Units adj'
,su.[HCT LOGIC DAY(S)] AS [hct day logic]
,su.PAID_NET_AMT AS [claim line amt paid]
,su.BILLED_AMT AS [claim line billed amt]
,su.TOTAL_BILLED_AMT AS [total billed amt]
,su.[TRI Payment] 
,su.ClmType AS [Claim Type]
,su.HEADERstatus AS [claim header status]
,su.[CHECK DATE] AS [claim paid date]
,su.SUBSCRID AS 'HealthPlanid'
,su.memid
,su.MEMNM AS [member name]
,su.QNXTbilltype AS [Bill Type]
,su.BillTypeDescr AS [Bill Type Descr]
,su.[CPT Service Code] AS [CPT]
,su.[CPT Service Description] AS [CPT description]
,su.revcode
,su.[REVCDE Descr] AS [revcode description]
,su.[Modifier Discount]
,su.EQUIV_allow_rate AS 'TRI Medi-cal Rate'
,su.EQUIV_allow_compare AS 'TRI Medi-cal Paid'
,su.EQUIV_allow_rate2 AS 'Medicare In Office NF Rate'
,su.EQUIV_allow_compare2 AS 'Medicare In Office NF Paid'
,su.EQUIV_allow_rate3 AS 'Medicare Out of Office NF Rate'
,su.EQUIV_allow_compare3 AS 'Medicare Out of Office NF Paid'
,su.formtype
,su.finaldrg
,su.modcode
,su.modcode2
,su.modcode3
,su.modcode4
,su.modcode5
,su.provid AS [rendering provider id]
,su.NPIprovnm AS [rendering provider npi]
-- ,TRY_CONVERT(nvarchar(25),pisorender.fedid) AS [Rendering provider fedid]
,su.PROVNM AS [rendering provider name]
,su.PAYTO AS [payto provider id]
,su.NPIpayto AS [payto provider npi]
,TRY_CONVERT(nvarchar(25),pisopayto.fedid) AS [payto provider fedid]
,su.PAYTONM AS [payto provider name]
,TRY_CONVERT(nvarchar(255),'') AS [claim inclusion reason]
,su.contractid
,su.[CONTRACT DESCRIPTION]
,TRY_CONVERT(nvarchar(255),NULL) AS [actual paid per unit]
,TRY_CONVERT(nvarchar(255),NULL) AS [medi cal allowed rate]
,TRY_CONVERT(nvarchar(255),NULL) AS [medicare allowed rate]
,TRY_CONVERT(nvarchar(255),NULL) AS [asc allowed rate]
,TRY_CONVERT(nvarchar(255),NULL) AS [custom rate proposed amt paid]
,TRY_CONVERT(nvarchar(255),NULL) AS [custom rate type]
,TRY_CONVERT(nvarchar(255),NULL) AS [custom rate]
,NULLIF(ISNULL(su.PAID_NET_AMT,0),0) * 1.00 AS 'Current_Rate_Payment' -- ASSUME THAT WHAT HAS BEEN PAID IS WHAT THE CONTRACTING DEPT. HAS DOCUMENTED
,ca.Contracting_Proposal_Category
,ca.Proposed_Rate_Payment
INTO INFORMATICS.dbo.CONTRACTING_PALOMAR_SPEC_TEMPLATE_DETAIL
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM INFORMATICS.dbo.CONTRACTING_PALOMAR_SPEC AS su
	INNER JOIN #ContractAnalysis AS ca ON su.memid = ca.memid
		AND su.claimid = ca.claimid
		AND su.claimline = ca.claimline
		-- LEFT JOIN #PROVISOLATION AS pisorender ON su.provid = pisorender.provid
		LEFT JOIN #PROVISOLATION AS pisopayto ON su.PAYTO = pisopayto.provid
	
		-- SELECT * FROM INFORMATICS.dbo.CONTRACTING_PALOMAR_SPEC_TEMPLATE_DETAIL







-- =====================================================================
	-- LEVERAGE HCT AS QA: 
-- =====================================================================	
SELECT  ' ' AS 'QA WITH() HCT: CONTRACTING PROPOSAL BY PROVIDER' -- LEVERAGE: "HCT_TEST_RADY_UCSD_ECM_...sql"
-- ,member_month
,line_of_business
,cost_category
,paytoid
,payto
,SUM(paid) AS 'Amount Paid'
,SUM(admits_visits) AS 'Admits / Visits'
,SUM(days_units) AS 'Days / Units'
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM informatics.dbo.dash_hct
WHERE 1=1
	AND TRY_CONVERT(date,ISNULL(member_month,GETDATE())) BETWEEN @RangeStartDate AND @RangeEndDate
	AND 
	( -- INITIATE ...
	provid IN 
	( -- INITIATE ...
	SELECT provid FROM #PROVISOLATION GROUP BY provid
	) -- CONCLUDE ... 
		OR paytoid IN 
		( -- INITIATE ...
		SELECT provid FROM #PROVISOLATION GROUP BY provid
		) -- CONCLUDE ...
		) -- CONCLUDE ...
GROUP BY /* member_month, */line_of_business,cost_category,paytoid,payto
ORDER BY line_of_business,cost_category /* ,member_month */ DESC

;WITH testrev AS -- MS GRISELDA QA CODE TEST:
( -- INITIATE ...
SELECT DISTINCT ' ' AS 'ADMIN DAY(S) TEST: '
,TRY_CONVERT(date,clm.startdate) AS 'DOS'
,clm.claimid
,clm.memid
,TRY_CONVERT(nvarchar(255),'Assign Claim Adjudication Category') AS [ClaimCategory]
,p2.fullname AS 'PAYTO'
-- SELECT TOP 10 ' ' AS 'CHECK 1st',* 
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM HMOPROD_PLANDATA.dbo.claim AS clm (NOLOCK)
	INNER JOIN HMOPROD_PLANDATA.dbo.claimdetail AS cd (NOLOCK) ON clm.claimid = cd.claimid
	-- INNER JOIN INFORMATICS.dbo.[uvw_CLAIMS_PAID] AS pc (NOLOCK) ON clm.claimid = pc.claimid -- PAID CLAIM ISO !!!	
	INNER JOIN INFORMATICS.dbo.[uvw_LINE_OF_BUSINESS] AS bp (NOLOCK) ON clm.planid = bp.planid
	
		LEFT JOIN HMOPROD_PLANDATA.dbo.affiliation AS a (NOLOCK) ON clm.affiliationid = a.affiliationid -- REMINDER: within claim(s) tables AFFILIATIONID is the relationship BETWEEN the a.provid = [RENDERING] PROVIDER AND the a.affiliateid = [PAYTO] PROVIDER
		-- LEFT JOIN HMOPROD_PLANDATA.dbo.provider AS p1 (NOLOCK) ON a.provid = p1.provid -- [RENDERING]
		LEFT JOIN HMOPROD_PLANDATA.dbo.provider AS p2 (NOLOCK) ON a.affiliateid = p2.provid -- [PAYTO] (IPAID)
		-- LEFT JOIN INFORMATICS.dbo.[uvw_CLAIMS_CLMTYPE] AS ct (NOLOCK) ON clm.formtype = ct.formtype
		-- LEFT JOIN INFORMATICS.dbo.[uvw_CLAIMS_BILLTYPE] AS sbt (NOLOCK) ON (LTRIM(RTRIM(clm.facilitycode))+LTRIM(RTRIM(clm.billclasscode))+LTRIM(RTRIM(clm.frequencycode))) = sbt.QNXTbilltype -- HEADER replacement for POS (NOLOCK) ON INCLM claims
WHERE 1=1
	AND TRY_CONVERT(date,ISNULL(clm.enddate,GETDATE())) >= @RangeStartDate -- WITHIN reporting period [RANGE] OPPOSITION
	AND TRY_CONVERT(date,clm.startdate) <= @RangeEndDate -- WITHIN reporting period [RANGE] OPPOSITION 
	AND clm.claimid IN -- THE ENTIRE CLAIM by [REVCODE]
	( -- INITIATE 
	SELECT DISTINCT claimid
	FROM HMOPROD_PLANDATA.dbo.claimdetail
	WHERE 1=1 
		AND CASE
	WHEN SUBSTRING(UPPER(LTRIM(RTRIM(ISNULL(cd.revcode,'')))),1,1) = 'Z'
	THEN  UPPER(LTRIM(RTRIM(ISNULL(cd.revcode,''))))
	WHEN SUBSTRING(UPPER(LTRIM(RTRIM(ISNULL(cd.revcode,'')))),1,1) = '0'
	THEN  SUBSTRING(UPPER(LTRIM(RTRIM(ISNULL(cd.revcode,'')))),2,3)
	ELSE UPPER(LTRIM(RTRIM(ISNULL(cd.revcode,''))))
	END IN ('101') -- C008: LO-HAR SENIOR LIVING -- LIMIT PLACED ON REVENUE_CODE -- Rev Code 0101 Custodial Care
	) --CONCLUDE ...
	AND UPPER(LTRIM(RTRIM(ISNULL(a.affiliateid,'')))) IN -- [PAYTO]
	( -- INITIATE ...
	SELECT DISTINCT provid FROM #PROVISOLATION 
	) -- CONCLUDE ... 
	AND ISNULL(clm.enddate,GETDATE()) >= clm.startdate -- MUST BE TRUE ... NON-CROSSFOOTED RECORDS ARE ACTIVE ...
	) -- CONCLUDE ...

		SELECT * FROM testrev; -- Or any other query that uses the CTE 







-- =========================================
	-- LEVERAGE TRI (TARGETED RATE INCREASE): 
-- =========================================
SELECT ' ' AS 'QA WITH() TRI (TARGETED RATE INCREASE) SUMMARY: '
,tri.PaytoProvId
,piso.PROVNM
,SUM(tri.[ExtraAmountPaid]) AS 'Extra payment'
FROM [QNXT_Custom].[TRI].[FfsPaymentDetails] AS tri
	INNER JOIN INFORMATICS.dbo.CONTRACTING_PALOMAR_SPEC AS c ON tri.ClaimId = c.claimid
		AND  tri.LineNum = c.claimline
	INNER JOIN 
	( -- INITIATE ...
	SELECT provid
	,PROVNM
	FROM #PROVISOLATION
	GROUP BY provid,PROVNM
	) -- CONCLUDE ... 
	AS piso ON tri.PaytoProvId = piso.provid
GROUP BY tri.PaytoProvId,piso.PROVNM

		SELECT ' ' AS 'TEST CASE RATE CLAIMLINE DETAIL RAW: '
		,claimid
		,claimline
		,[Cx]
		,PAID_NET_AMT
		,[TRI Payment]
		,[CPT Service Code]
		,[CPT Service Description]
		,revcode
		,[REVCDE Descr]
		,prindiag
		,[prindiag descr],*
		FROM INFORMATICS.dbo.CONTRACTING_PALOMAR_SPEC
		WHERE 1=1
			AND ISNULL(claimid,'') IN ('25213E75618','25071E12217') -- C008: REPLACE WITH LO-HAR SAMPLE CLAIMID(S) FOR QA

		SELECT ' ' AS 'TEST CASE RATE CLAIMLINE DETAIL PROPOSAL: '
		,claimid
		,[claim line]
		,Contracting_Proposal_Category
		,[claim line amt paid]
		,Proposed_Rate_Payment
		,[TRI Payment],*
		FROM INFORMATICS.dbo.CONTRACTING_PALOMAR_SPEC_TEMPLATE_DETAIL
		WHERE 1=1
			AND ISNULL(claimid,'') IN ('25213E75618','25071E12217') -- C008: REPLACE WITH LO-HAR SAMPLE CLAIMID(S) FOR QA
