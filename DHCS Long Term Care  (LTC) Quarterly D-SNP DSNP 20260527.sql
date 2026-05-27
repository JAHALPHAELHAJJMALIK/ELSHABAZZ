-- =====================================================================
	--  MODIFICATION(S) / CHANGE.LOG:
-- =====================================================================
-- C001: ADD claimdrg 'MS-DRG (Medicare Severity Diagnosis Related Groups) CODES' TO DETAIL AS OF 20240523

		/* SELECT ' ' AS 'SUMMARY: Days + Admits / Visits BY [Cx / COS] BY memid',los.* -- ... large claims costs for hospital inpatient stays => than 30 days
		INTO INFORMATICS.dbo.DELIVERABLE_DHCS_LTC_DSNP -- ... Enter the number of members currently residing in LTC for >90 days during the reporting period
		FROM 
		( -- INITIATE ...
		SELECT aa.memid
		,aa.Cx AS [Category of Service]
		,COUNT(DISTINCT(aa.memid)) AS [UNIQUE UTILZERS]
		,SUM(aa.[HCT LOGIC DAY(S)]) AS [DAY(S)]
		,SUM(p.PAID) AS [PAID]
		-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
		-- SELECT DISTINCT ' ' AS 'CHECK 1st'
		FROM #AdmitAssessment AS aa
			JOIN 
			( -- INITIATE ...
			SELECT memid
			,AdmitID
			,SUM(PAID_NET_AMT) AS 'Paid'
			FROM INFORMATICS.dbo.DHCS_LTC_DSNP AS developsource
			GROUP BY memid,AdmitID
			) -- CONCLUDE ...
			AS p ON aa.memid = p.memid
				AND aa.AdmitID = p.AdmitID
		WHERE 1=1
			AND CASE 
			WHEN TRY_CONVERT(date,ISNULL(aa.[Index Discharge Date],GETDATE())) > TRY_CONVERT(date,@RangeEndDate)
			THEN TRY_CONVERT(date,@RangeEndDate)
			ELSE ISNULL(aa.[Index Discharge Date],GETDATE()) 
			END BETWEEN TRY_CONVERT(date,@RangeStartDate) AND TRY_CONVERT(date,@RangeEndDate) -- ... Enter the number of members currently residing in LTC for >90 days during the reporting period
		GROUP BY aa.memid,aa.Cx
		) -- CONCLUDE ...
		AS los
		WHERE 1=1
			AND los.[DAY(S)] >= @ltcdays -- ... Enter the number of members currently residing in LTC for >90 days during the reporting period */

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
	
-- =====================================================================
	-- DECLARE @PARAMETER(S) / @FILTER(S): 
-- =====================================================================
DECLARE @BRAND AS nvarchar(100) = 'CHGSD' -- 'CHGSD' OR 'CHPIV' -- DEFAULT VAL()
		
-- DECLARE @SearchString AS varchar(255)
-- DECLARE @SPLITlob AS nvarchar(255)
DECLARE @leadlag AS decimal(9,0)
DECLARE @leadlagmonths AS int
DECLARE @when AS datetime2
DECLARE @RangeStartDate AS datetime2
DECLARE @RangeEndDate AS datetime2
DECLARE @CutoffDate AS datetime2
DECLARE @TruevFalse AS binary
-- DECLARE @DYNAMICLIKE AS nvarchar(255)
DECLARE @lobplanprog AS varchar(255)
DECLARE @memid AS varchar(25)
DECLARE @pos AS varchar(2)
DECLARE @solveforunknown AS decimal(9,3)
DECLARE @BirthdayAgeParam AS date

-- SET @SearchString = NULL  -- see CREATE TABLE #employee
-- SET @SPLITlob = 'MEDI-CAL,DSNP,CSNP,CMC,MSO - CHPIV' -- SQL: STRING_SPLIT() ... LINE_OF_BUSINESS OPTION(S)
SET @leadlag = -4 -- +- LEAD() LAG() IN ...
SET @leadlagmonths = 3 -- +- LEAD() LAG() IN MONTH(S)
SET @when = NULL
SET @RangeStartDate = DATEADD(MONTH,@leadlag,DATEADD(DAY,1,EOMONTH(GETDATE(),-1))) -- AS [1st OF ... MONTH]
SET @RangeEndDate = DATEADD(day,-1,DATEADD(MONTH,@leadlagmonths,@RangeStartDate))
SET @CutoffDate =  TRY_CONVERT(date,GETDATE()) -- PAID DATE CUTOFF
SET @TruevFalse = NULL
-- SET @DYNAMICLIKE = '%'+ISNULL(@SearchString,'')+'%' -- LIKE '%[@PARAMETER]%'
SET @lobplanprog = 'DSNP' -- SET @lobplanprog = 'DSNP MEDICARE PLAN' -- SELECT * FROM INFORMATICS.dbo.[uvw_LINE_OF_BUSINESS] -- ASSESS VALID ACTIVE OPTION(S)
SET @memid = CAST(NULL AS varchar(25)) -- ISO ON SPECIFIC MEMBER
SET @pos = NULL -- SELECT 'TELEHEALTH ("02") ANALYSIS DUE TO COVID - 19' AS [NOTE(S)],* FROM INFORMATICS2.dbo.SHELLpos
SET @solveforunknown = 1.0 -- DO THE MATH Fx - FORMULA (REVERSE ENGINEER) …100% value = (Given value ÷ Given percentage) × 100 ('STEP88_FEESCHED...sql') eg. 100% OF ?
SET @BirthdayAgeParam = DATEADD( yy, -18, GETDATE()) -- WHERE 1=1 AND TRY_CONVERT(date,mem.dob) <= @BirthdayAgeParam -- 65+ MEMBERSHIP

		-- SELECT value FROM STRING_SPLIT(@SPLITlob, ',')

		SELECT ' ' AS '"DECLARE*" @PARAM(S): '
		,'BETWEEN '+CAST(CAST(@RangeStartDate AS date) AS varchar(255))+' AND '+CAST(CAST(@RangeEndDate AS date) AS varchar(255)) AS 'RANGE NOTE(s)'
		,DATEPART(YEAR,GETDATE()) AS 'NormalizeYear'		
		,DATEFROMPARTS(YEAR(GETDATE()),MONTH(GETDATE()),1) AS 'NormalizeMonth' -- DATEFROMPARTS(year, month, day)
		,DATEFROMPARTS(YEAR(DATEADD(MONTH,-1,GETDATE())),MONTH(DATEADD(MONTH,-1,GETDATE())),1) AS 'NormalizePreviousMonth'
		,DATEFROMPARTS(YEAR(DATEADD(MONTH,1,GETDATE())),MONTH(DATEADD(MONTH,1,GETDATE())),1) AS 'NormalizeNextMonth'
		,CAST(DATEPART(yyyy, CAST(@RangeEndDate AS datetime)) AS nvarchar (4))+' Q'+CAST(DATENAME(qq, CAST(@RangeEndDate AS datetime)) AS varchar(1)) AS [Reporting Period] -- ie. 2026 Q1
		,bp.*
		FROM INFORMATICS.dbo.[uvw_LINE_OF_BUSINESS] AS bp -- HMOPROD_PLANDATA.dbo.benefitplan + HMOPROD_PLANDATA.dbo.program
		WHERE 1=1
			-- AND bp.[PLAN] LIKE ISNULL('%'+@lobplanprog+'%','%') 
			-- AND bp.[PROGRAM] LIKE ISNULL('%'+@lobplanprog+'%','%') 
			-- AND bp.LINE_OF_BUSINESS IN (SELECT value FROM STRING_SPLIT(@SPLITlob, ','))			
			AND bp.[LINE_OF_BUSINESS] LIKE ISNULL('%'+@lobplanprog+'%','%') 
			AND bp.[BRAND] IN (ISNULL(@BRAND,'CHGSD')) -- ('MEDI-CAL BENEFIT PLAN','DSNP MEDI-CAL PLAN','COMMUNITY Y MAS (HMO C-SNP)','IV_DSNP2 MEDI-CAL PLAN','CHG MARKETPLACE HMO PLAN') -- VALID ACTIVE OPTION(S) -- C###: ADD BRANDING FOR CHPIV 'MSO' = management services organization IMPLEMENTATION AS OF 01/01/2026 GO LIVE 

DECLARE @IndexPlus AS int
DECLARE @gapallowance AS int
DECLARE @los AS decimal(9,0)
DECLARE @ltcdays AS decimal(9,0)

SET @IndexPlus = 3
SET @gapallowance = 1
SET @los = 30
SET @ltcdays = 90

		SELECT @gapallowance AS [GAPS IN ... ALLOWED]
		,@IndexPlus AS [CONSECUTIVE ... + PLUS THE IndexAdmit]
		,@los AS [LOS LIMIT]
		,CAST(YEAR(TRY_CONVERT(date,GETDATE())) AS nvarchar(25))+'-' +CAST(MONTH(TRY_CONVERT(date,GETDATE())) AS nvarchar(25)) AS [CURRENT MOS]






-- =====================================================================
	--  COPT: PRE-STAGE STEP 1 - MATERIALIZE LOOKUP TABLES * PURPOSE: Eliminates Nested Loop rebinds on hcfaposlocation
-- =====================================================================
--------------------------------------------------------------------------------------------------------------------
	-- Error Trapping: Check If Permanent Table(s) Already Exist(s) And Drop If Applicable --
--------------------------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS #POSLOC;
DROP TABLE IF EXISTS #CONTRACTDESCR;
DROP TABLE IF EXISTS #QUALIFYING_CLAIMS; -- PRE - FILTER THE DETAIL
DROP TABLE IF EXISTS INFORMATICS.dbo.DHCS_LTC_DSNP;
DROP TABLE IF EXISTS INFORMATICS.dbo.DELIVERABLE_DHCS_LTC_DSNP;
DROP TABLE IF EXISTS INFORMATICS.dbo.DELIVERABLE_DHCS_LTC_DSNP_TEMPLATE;

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
,CASE
WHEN 
( -- INITIATE ...
CASE 
WHEN SUBSTRING(UPPER(LTRIM(RTRIM(ISNULL(cd.revcode,'')))),1,1) = 'Z'
THEN  UPPER(LTRIM(RTRIM(ISNULL(cd.revcode,''))))
WHEN SUBSTRING(UPPER(LTRIM(RTRIM(ISNULL(cd.revcode,'')))),1,1) = '0'
THEN  SUBSTRING(UPPER(LTRIM(RTRIM(ISNULL(cd.revcode,'')))),2,3)
ELSE UPPER(LTRIM(RTRIM(ISNULL(cd.revcode,''))))
END IN ('101', '190', '160', '169', '112', '199', '185', '180') -- LTC REVENUE CODES per requirements
) -- CONCLUDE...
THEN 'LTC'
ELSE 'NOT_QUALIFYING'
END AS [InclusionExclusionType]
INTO #QUALIFYING_CLAIMS
-- SELECT TOP 10 ' ' AS 'CHECK 1st',* 
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM HMOPROD_PLANDATA.dbo.claim (NOLOCK) AS clm
    INNER JOIN HMOPROD_PLANDATA.dbo.claimdetail (NOLOCK) AS cd ON clm.claimid = cd.claimid
    INNER JOIN INFORMATICS.dbo.[uvw_LINE_OF_BUSINESS] AS bp ON clm.planid = bp.planid
	-- INNER JOIN HMOPROD_PLANDATA.dbo.affiliation (NOLOCK) AS a ON clm.affiliationid = a.affiliationid -- REMINDER: within claim(s) tables AFFILIATIONID is the relationship BETWEEN the a.provid = [RENDERING] PROVIDER AND the a.affiliateid = [PAYTO] PROVIDER	
		-- LEFT JOIN INFORMATICS.dbo.[uvw_CLAIMS_BILLTYPE] AS sbt ON (LTRIM(RTRIM(clm.facilitycode))+LTRIM(RTRIM(clm.billclasscode))+LTRIM(RTRIM(clm.frequencycode))) = sbt.QNXTbilltype	
WHERE 1=1
	AND bp.[LINE_OF_BUSINESS] LIKE ISNULL('%'+@lobplanprog+'%','%') -- CARDINALITY HIERARCHY CASUALTY ... LEAVE AS FINAL FILTER
	AND TRY_CONVERT(date,clm.startdate) <= @RangeEndDate -- WITHIN reporting period [RANGE] OPPOSITION ... APPLICATION ALONE NEEDED TO ASSESS CONTINUOUS STAYS WITH STEP88_ADMIT CODE BELOW cd
	-- AND TRY_CONVERT(date,ISNULL(clm.enddate,GETDATE())) >= @RangeStartDate -- WITHIN reporting period [RANGE] OPPOSITION
	AND ISNULL(clm.enddate,GETDATE()) >= clm.startdate -- MUST BE TRUE ... NON-CROSSFOOTED RECORDS ARE ACTIVE ...	

CREATE CLUSTERED INDEX idx_QC_claimid ON #QUALIFYING_CLAIMS (claimid);
CREATE NONCLUSTERED INDEX idx_QC_memid ON #QUALIFYING_CLAIMS (memid);

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

SELECT 'N' AS [THE FINAL CLAIM]
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
,SUBSTRING(UPPER(LTRIM(RTRIM(ISNULL(CLAIMDATA.claimid,'')))),1,11) AS [FINALclaimid]
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
INTO INFORMATICS.dbo.DHCS_LTC_DSNP
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

CREATE NONCLUSTERED INDEX idx_REFACTOR_DupID ON INFORMATICS.dbo.DHCS_LTC_DSNP ([DupID]);
CREATE NONCLUSTERED INDEX idx_DSNP_claimid ON INFORMATICS.dbo.DHCS_LTC_DSNP (claimid);
CREATE NONCLUSTERED INDEX idx_DSNP_memid ON INFORMATICS.dbo.DHCS_LTC_DSNP (memid);

	-- CHECK FOR DUP(S) --
SELECT ' ' AS 'SHOULD RETURN 0 ROWS - DUP Validation',*
FROM INFORMATICS.dbo.DHCS_LTC_DSNP
WHERE 1=1
    AND [DupID] IN
    ( -- INITIATE ...
    SELECT [DupID]
    FROM INFORMATICS.dbo.DHCS_LTC_DSNP AS dup
    GROUP BY [DupID]
    HAVING COUNT(1)>1
    ) -- CONCLUDE ...







-- =====================================================================
	--  THE FINAL CLAIM:
-- =====================================================================
UPDATE INFORMATICS.dbo.DHCS_LTC_DSNP
SET [THE FINAL CLAIM] = 'N' -- POWER CYCLE RESET REFRESH RESTART ...

UPDATE INFORMATICS.dbo.DHCS_LTC_DSNP
SET [THE FINAL CLAIM] = 'Y'
FROM INFORMATICS.dbo.DHCS_LTC_DSNP AS clm
	INNER JOIN INFORMATICS.dbo.uvw_FINALCLAIM AS fc ON clm.claimid = fc.claimid

/* SELECT ' ' AS 'ARRIVE AT FINAL CLAIM: ',fc.* 
FROM INFORMATICS.dbo.uvw_FINALCLAIM  AS fc
WHERE 1=1 
	-- AND [ROWis] =1
	-- AND FINALclaimid IN ('23088E00427') -- SAMPLE */







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
	
UPDATE INFORMATICS.dbo.DHCS_LTC_DSNP
SET [Accommodation Code] = TRY_CONVERT(decimal(11,2),cv.amount)
FROM INFORMATICS.dbo.DHCS_LTC_DSNP AS c
	INNER JOIN acccode AS cv ON c.claimid = cv.claimid







-- =====================================================================
	-- TRI (Targeted Rate Increase): 
-- =====================================================================
UPDATE INFORMATICS.dbo.DHCS_LTC_DSNP
SET [TRI Payment] = tri.[ExtraAmountPaid]
FROM INFORMATICS.dbo.DHCS_LTC_DSNP AS c
	INNER JOIN [QNXT_Custom].[TRI].[FfsPaymentDetails] AS tri ON c.claimid = tri.ClaimId
		AND c.claimline = tri.LineNum







-- =====================================================================
	-- QUPD [PROCEDURE_1_CODE]: 
-- =====================================================================
UPDATE INFORMATICS.dbo.DHCS_LTC_DSNP
SET PROCEDURE_1_CODE = pcode
FROM INFORMATICS.dbo.DHCS_LTC_DSNP AS su
	INNER JOIN HMOPROD_PLANDATA.dbo.claimproc (NOLOCK) AS cp ON su.claimid = cp.claimid
WHERE 1=1
	AND ISNULL(cp.proctype,'') = 'Primary'
	AND su.claimline = '1'







-- =====================================================================
	-- PRINCIPAL DIAG  [prindiag] + [poa]: 
-- =====================================================================
UPDATE INFORMATICS.dbo.DHCS_LTC_DSNP
SET [prindiag] = LTRIM(RTRIM(ISNULL(diag.codeid,'')))
,[prindiag descr] = LTRIM(RTRIM(ISNULL(diag.[diag descr],'')))
,[PRESENT ON ADMISSION] = diag.[PRESENT ON ADMISSION]
FROM INFORMATICS.dbo.DHCS_LTC_DSNP AS su	
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
UPDATE INFORMATICS.dbo.DHCS_LTC_DSNP
SET [Primary / Secondary Status] = estatus.[Plan Position Status] -- [Primary or secondary claim] OR [Member Status (Primary, Secondary] see "DMP" FOR alt. SEQUENCE
 FROM INFORMATICS.dbo.DHCS_LTC_DSNP AS su 
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
	WHERE 1=1
		AND CAST(c.startdate AS date) BETWEEN CAST(ek.effdate AS date) AND CAST(ek.termdate AS date) -- RINA: APPLIED TO FIELD WITHIN TABLE TO BE UPDATE
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
UPDATE INFORMATICS.dbo.DHCS_LTC_DSNP -- FIVE (5) COMPONENT(s) FIVE (5) table(s) - claim, claimdetail,provider, contractinfo, affiliation ... 
SET contractedVerification = LTRIM(RTRIM(ci.contracted)) -- per SIR ADRIAN THE AFFILIATION SEQUENCE IS THE PREFERRED METHOD PAR STATUS / CONTRACTED ??? POST DISCUSSION WITH SIR EVAN AND LEVERAGING STEP88_QUICKCLAIM_...sql LOGIC ... AS OON, -- TODO:Confirm?
,capitationVerification = LTRIM(RTRIM(ci.iscapitated))
-- SELECT TOP 10 ' ' AS 'CHECK 1st',aff.provid,prov.fullname,ci.contracted,ci.termdate,ci.effdate,ci.lastupdate,c.[description] AS [CONTRACT_DESCR],bp.[description] AS [BENEFIT PLAN DESCR],prog.[description] AS [PROG DESCR],*,ci.contracted,sip.ProviderParStatus,ci.*,sip.*
-- SELECT DISTINCT ' ' AS 'CHECK 1st',contracted,iscapitated FROM HMOPROD_PLANDATA.dbo.contractinfo
FROM INFORMATICS.dbo.DHCS_LTC_DSNP AS source
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

/* UPDATE INFORMATICS.dbo.DHCS_LTC_DSNP
SET contractedVerification = 'Y' -- ACTIVE 274 274 PAR OVERRIDE ~ LEVERAGE "QNXT CXO EXECUTIVE SUMMARY CONTRACT PAR STATUS.jpg" AND 'uvw_FALSE_PROVIDER_PAR' AND 'uvw_ProviderRepository274_PAR' ... contractedVerification = NULL / 'N' NON-PAR (no contractinfo matchand not active on 274 roster) ... ISNULL(contractedVerification,'N')
FROM INFORMATICS.dbo.DHCS_LTC_DSNP AS source
	INNER JOIN SQLPRODAPP01.INFORMATICS.dbo.uvw_ProviderRepository274_PAR AS pr ON ISNULL(source.NPIpayto,'') = ISNULL(pr.[Group NPI],'') */

UPDATE INFORMATICS.dbo.DHCS_LTC_DSNP
SET contractedVerification = 'Y' -- ACTIVE 274 274 PAR OVERRIDE ~ LEVERAGE "QNXT CXO EXECUTIVE SUMMARY CONTRACT PAR STATUS.jpg" AND 'uvw_FALSE_PROVIDER_PAR' AND 'uvw_ProviderRepository274_PAR' ... contractedVerification = NULL / 'N' NON-PAR (no contractinfo matchand not active on 274 roster) ... ISNULL(contractedVerification,'N')
FROM INFORMATICS.dbo.DHCS_LTC_DSNP AS source
	INNER JOIN SQLPRODAPP01.INFORMATICS.dbo.uvw_ProviderRepository274_PAR AS pr ON ISNULL(source.NPIprovnm,'') = ISNULL(pr.[Provider NPI],'') 







-- ============================================================= 
	-- MS ALLYSON + MS HINA ADJ [UNIT(S)]: 
-- =============================================================
UPDATE INFORMATICS.dbo.DHCS_LTC_DSNP
SET [QUANTITY] = q.[QUANTITY] -- ,cd.servunits AS [QUANTITY] ... AS [units_adj] ... AS 'Units adj'
FROM INFORMATICS.dbo.DHCS_LTC_DSNP AS su
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
	FROM INFORMATICS.dbo.DHCS_LTC_DSNP
	) -- CONCLUDE ...
	AS q ON su.claimid = q.claimid
		AND su.claimline = q.claimline

		/* case
		when c.planid IN ('QMXBP0823','QMXBP0822','QMXBP0850','QMXBP0851') and cdet.amountpaid > 0 and es.primarystatus = 'P' THEN cdet.servunits
		when c.planid IN ('QMXBP0823','QMXBP0822','QMXBP0850','QMXBP0851') and sum(cdet.amountpaid) over (partition by c.memid, c.provid, cdet.dosfrom, cdet.dosto, cdet.servcode, cdet.claimline) > cdet.amountpaid and es.primarystatus = 'S' THEN 0
		when  c.planid IN ('QMXBP0823','QMXBP0822','QMXBP0850','QMXBP0851') and sum(cdet.amountpaid) over (partition by c.memid, c.provid, cdet.dosfrom, cdet.dosto, cdet.servcode, cdet.claimline) = cdet.amountpaid and es.primarystatus = 'S' THEN cdet.servunits
		when c.planid not IN ('QMXBP0823','QMXBP0822','QMXBP0850','QMXBP0851') THEN cdet.servunits
		ELSE 0 end Units_adj */
		
UPDATE INFORMATICS.dbo.DHCS_LTC_DSNP
SET [HCT LOGIC DAY(S)] = t.[QUANTITY] -- AS [units_adj]
FROM INFORMATICS.dbo.DHCS_LTC_DSNP AS t 
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
UPDATE INFORMATICS.dbo.DHCS_LTC_DSNP
SET [ClaimCategory] = CAST(NULL AS nvarchar(255)) -- POWER CYCLE RESET REFRESH RESTART ...
,[Cx] = CAST(NULL AS nvarchar(255)) 

UPDATE INFORMATICS.dbo.DHCS_LTC_DSNP
SET [ClaimCategory] = 'Paid'
FROM INFORMATICS.dbo.DHCS_LTC_DSNP AS sourcetable
	INNER JOIN INFORMATICS.dbo.[uvw_CLAIMS_PAID] AS pc ON sourcetable.claimid = pc.claimid

/* UPDATE INFORMATICS.dbo.DHCS_LTC_DSNP
SET [ClaimCategory] = 'Denied'
FROM INFORMATICS.dbo.DHCS_LTC_DSNP AS sourcetable
WHERE 1=1
	AND UPPER(LTRIM(RTRIM(ISNULL(sourcetable.[HEADERstatus],'')))) IN ('DENIED') -- FINAL STATUS 

UPDATE INFORMATICS.dbo.DHCS_LTC_DSNP
SET [Cx] = 'Inpatient'
FROM INFORMATICS.dbo.DHCS_LTC_DSNP AS sourcetable
WHERE 1=1
	AND ISNULL(sourcetable.[InclusionExclusionType],'') = 'HOSPITAL_INPATIENT'

UPDATE INFORMATICS.dbo.DHCS_LTC_DSNP
SET [Cx] = 'SNF'
FROM INFORMATICS.dbo.DHCS_LTC_DSNP AS sourcetable
WHERE 1=1
	AND ISNULL(sourcetable.[InclusionExclusionType],'') = 'SNF_SKILLED' */







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
FROM INFORMATICS.dbo.DHCS_LTC_DSNP

/* SELECT ' ' AS 'QA REV CODE(S)'
,revcode
,[REVCDE Descr]
FROM INFORMATICS.dbo.DHCS_LTC_DSNP
GROUP BY revcode,[REVCDE Descr]

SELECT ' ' AS 'QA CPT CODE(S)'
,[CPT Service Code]
,[CPT Service Description]
FROM INFORMATICS.dbo.DHCS_LTC_DSNP
GROUP BY [CPT Service Code],[CPT Service Description]

SELECT ' ' AS 'QA PRINDIAG(S)'
,[prindiag]
,[prindiag descr]
FROM INFORMATICS.dbo.DHCS_LTC_DSNP
GROUP BY [prindiag],[prindiag descr]

SELECT ' ' AS 'QA HEADER STATUS & planid'
,status
,planid
FROM HMOPROD_PLANDATA.dbo.claim 
WHERE 1=1
	AND  claimid IN  
	( -- INITIATE ...
	SELECT claimid
	FROM INFORMATICS.dbo.DHCS_LTC_DSNP
	GROUP BY claimid
	) --CONCLUDE ...
GROUP BY status,planid */

SELECT ' ' AS 'QA LOB(S)'
,t.LINE_OF_BUSINESS
FROM INFORMATICS.dbo.DHCS_LTC_DSNP AS t
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
FROM INFORMATICS.dbo.DHCS_LTC_DSNP AS u
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
FROM INFORMATICS.dbo.DHCS_LTC_DSNP AS u
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
,[ClaimCategory]
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
,SUM(QUANTITY) AS 'Units Adj'
,MIN(TRY_CONVERT(date,DOS)) AS 'MIN() OF RANGE'
,MAX(TRY_CONVERT(date,DOS)) AS 'MAX() OF RANGE'
,MAX(su.[CHECK DATE]) AS RUNOUT_DT
,SUM(su.BILLED_AMT) AS Billed
,SUM(su.ALLOWED_AMT) AS Allowed
,SUM(su.NET_AMT) AS Net
,SUM(su.PAID_NET_AMT) AS Paid
,SUM(su.INT) AS Interest
,SUM(su.[TRI Payment]) AS 'TRI (Targeted Rate Increase) Payment'
FROM INFORMATICS.dbo.DHCS_LTC_DSNP AS su
WHERE 1=1
        AND [ClaimCategory] IN ('Paid')
GROUP BY [ClaimCategory],ISNULL(su.Cx,'NOT YET CLASSIFIED'),su.ExecutionDate,su.LINE_OF_BUSINESS,su.[RANGE NOTE(s)],su.[Primary / Secondary Status]







-- ======================================================================
	-- VISIT / ADMIT / ENCOUNTER: 'Unique person, date of service, and provider = one visit'
-- ======================================================================

		-- EXEC [INFORMATICS].dbo.[spWCdate_calendarISO];

-----------------------------------------------------------------------------------------------------------------------------
	--Error Trapping: Check If Permanent Table(s) Already Exist(s) And Drop If Applicable--
-----------------------------------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS #AdmitAssessment -- SQL Server 2016 and later -- DYNAMIC tmp OR STATIC [TABLE] #INFORMATICS.dbo.DHCS_LTC_DSNP is a local temporary table visible only IN the current session; ##INFORMATICS.dbo.DHCS_LTC_DSNP is a GLOBAL temporary table visible to all sessions IN ('TempDB')

SELECT ' ' AS 'Admit Analysis'
,CAST(NULL AS nvarchar(255)) AS [Index AdmitID] -- The ORIGINAL / INITIAL Visit + OR Admit
,CAST(NULL AS datetime) AS [Index Admission Date] -- The ORIGINAL / INITIAL Visit + OR Admit
,CAST(NULL AS datetime) AS [Index Discharge Date] -- The ORIGINAL / INITIAL Visit + OR Admit
,0 AS [Index Calendar Days]
,[DoTheMathInDays] = CASE
WHEN TRY_CONVERT(date,[PREVIOUS ADMIT DOS]) =TRY_CONVERT(date,DOS)
THEN 0
ELSE DATEDIFF("d",TRY_CONVERT(date,[PREVIOUS ADMIT DOSTHRU]),TRY_CONVERT(date,DOS)) 
END
,[DoTheMathInMonths] = CASE
WHEN TRY_CONVERT(date,[PREVIOUS ADMIT DOS]) =TRY_CONVERT(date,DOS)
THEN 0
ELSE DATEDIFF("m",TRY_CONVERT(date,[PREVIOUS ADMIT DOSTHRU]),TRY_CONVERT(date,DOS)) 
END
,[DATEDIFF DAY(S)] = CASE
WHEN DATEDIFF("d",TRY_CONVERT(date,DOS),TRY_CONVERT(date,ISNULL(DischargeDate,DOSTHRU))) = 0
THEN 1
ELSE DATEDIFF("d",TRY_CONVERT(date,DOS),TRY_CONVERT(date,ISNULL(DischargeDate,DOSTHRU))) -- ... +1 -- INCLUDE [startdate] / [DOS]
END --"(Day Count = Discharge Date - Admit Date; when Admit Date = Discharge Date then Day Count = 1)"
,[CALENDAR DAY(S)] = TRY_CONVERT(decimal(9,0),0)
,[CALENDAR DAY(S) minus END / DISCHARGE date] = TRY_CONVERT(decimal(9,0),0)
,[WORK DAY(S)] = TRY_CONVERT(decimal(9,0),0)
,[READMISSION] = TRY_CONVERT(decimal(9,0),0)
,[CONTINUOUS] = TRY_CONVERT(decimal(9,0),0)
,[CONSECUTIVE] = TRY_CONVERT(decimal(9,0),0)
,[HCT LOGIC DAY(S)] = TRY_CONVERT(decimal(9,0),0)
,dothemath.*
INTO #AdmitAssessment
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM 
( -- INITIATE...
SELECT ranklag.*
,ISNULL(LAG(DOS) OVER (PARTITION BY Cx,memid ORDER BY [RANKis] ASC),DOS) AS [PREVIOUS ADMIT DOS]
,ISNULL(LEAD(DOS) OVER (PARTITION BY Cx,memid ORDER BY [RANKis] ASC),DOS) AS [NEXT ADMIT DOS]
,ISNULL(LAG(ISNULL(DischargeDate,DOSTHRU)) OVER (PARTITION BY Cx,memid ORDER BY [RANKis] ASC),ISNULL(DischargeDate,DOSTHRU)) AS [PREVIOUS ADMIT DOSTHRU]
,ISNULL(LEAD(ISNULL(DischargeDate,DOSTHRU)) OVER (PARTITION BY Cx,memid ORDER BY [RANKis] ASC),ISNULL(DischargeDate,DOSTHRU)) AS [NEXT ADMIT DOSTHRU]
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM 
( -- INITIATE ...
SELECT rankrow.*
-- ,DENSE_RANK() OVER (PARTITION BY memid,Cx ORDER BY memid,Cx,DOS,provid) AS [RANKis]
,DENSE_RANK() OVER (PARTITION BY memid,Cx ORDER BY DOS,provid) AS [RANKis]
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM 
( -- INITIATE ...
SELECT DISTINCT ' ' AS 'NESTED DENSE_RANK() ROW() LAG() LEAD()'
,'LTC' AS 'Cx'
-- ,[Cx]
/* ,CASE -- FOR [CONSECUTIVE] MONTH ANALYSIS ... MCP members who were either 1. discharged from an inpatient setting or 2. IN the emergency department for services two (2) or more times over four (4) consecutive months
WHEN Cx IN ('IP (Inpatient Facility)', 'ER')
THEN 'IPER'
WHEN Cx LIKE '%SNF%'
THEN 'SNF'
ELSE Cx
END AS [Cx] */
,MEMNM
,memid
,DischargeDate
,DOS
,DOSTHRU
,PAYTONM
,PAYTO
,PROVNM
,provid
,[AdmitID] -- a.     VISIT / ADMIT / ENCOUNTER: 'Unique person, date of service, and provider = one visit'  OR 'Unique person, date of service, and NDC = one script'
FROM INFORMATICS.dbo.DHCS_LTC_DSNP AS developsource
WHERE 1=1 
		AND developsource.[ClaimCategory] IN ('Paid')
	-- AND ISNULL(developsource.Cx,'') != '' -- NO NOT NEGATIVE <> != AS DEFAULT
) -- CONCLUDE ...
AS rankrow
) -- CONCLUDE ...
AS ranklag
) -- CONCLUDE ...
AS dothemath

		SELECT DISTINCT ' ' AS 'CHECK  [Cx] / [COS] CATEGORY OF SERVICE ASSIGNMENT'
		,[Cx] 
		FROM INFORMATICS.dbo.DHCS_LTC_DSNP

		SELECT ' ' AS 'KINDRED SAMPLE DUP',* 
		FROM INFORMATICS.dbo.DHCS_LTC_DSNP 
		WHERE 1=1 
			AND AdmitID IN ('23000202022-09-282571')

		/* SELECT ' ' AS 'HCT COMP QA USE [URL]: https://chgtableau.chgsd.com - "TABLEAU APP"',GETDATE() AS [TimeStamp],MAX(su.[RANGE NOTE(s)]) AS [RANGE],su.YEARMO_DOS AS [Each Month],[Cx]AS [COS (Category of Service)]
		,COUNT(DISTINCT(AdmitID)) AS [Admits / Visit / Encounter]
		,COUNT(DISTINCT(memid)) AS [Denominator Membership]
		-- SELECT TOP 10 ' ' AS 'CHECK 1st',* 
		-- SELECT DISTINCT ' ' AS 'CHECK 1st',[Cx]
		FROM INFORMATICS.dbo.DHCS_LTC_DSNP AS su -- UTILIZATION BETWEEN 2022-05-01 AND 2022-12-31
		WHERE 1=1 
			AND [Cx] IN (SELECT DISTINCT [Cx] FROM INFORMATICS.dbo.DHCS_LTC_DSNP)
		GROUP BY [Cx],YEARMO_DOS */







-- ======================================================================
	-- INDEX READMISSION(S) --
-- ======================================================================
UPDATE #AdmitAssessment
SET [READMISSION] = 1
FROM #AdmitAssessment
WHERE 1=1 
	-- AND [DoTheMathInMonths] BETWEEN 1 AND @los
	AND [DoTheMathInDays] BETWEEN 1 AND @los

UPDATE #AdmitAssessment
SET [CONTINUOUS] = 1
,[CONSECUTIVE] = 1
FROM #AdmitAssessment
WHERE 1=1 
	-- AND [DoTheMathInMonths] <= @gapallowance
	AND [DoTheMathInDays] <= @gapallowance
	AND RANKis != 1 -- NO NOT NEGATIVE <> !=

UPDATE #AdmitAssessment
SET [Index AdmitID] = CAST(AdmitID AS nvarchar(MAX))
,[Index Admission Date] = TRY_CONVERT(date,DOS)
,[Index Discharge Date] = TRY_CONVERT(date,ISNULL(DischargeDate,DOSTHRU))
FROM #AdmitAssessment
WHERE 1=1 
	AND [Index AdmitID] IS NULL
	AND RANKis = 1

UPDATE #AdmitAssessment
SET [Index AdmitID] = CAST(AdmitID AS nvarchar(MAX))
,[Index Admission Date] = TRY_CONVERT(date,DOS)
,[Index Discharge Date] = TRY_CONVERT(date,ISNULL(DischargeDate,DOSTHRU))
FROM #AdmitAssessment
WHERE 1=1 
	AND [Index AdmitID] IS NULL
	AND CONSECUTIVE = 0







-- ======================================================================
	-- SQL #PYTHON FOR WHILE LOOP() BREAK / FEEDBACK LOOP() CONDITION(S) -- 
-- ======================================================================
DECLARE @rowCount int;
WHILE (1=1)
BEGIN

		UPDATE #AdmitAssessment
		SET [Index AdmitID] = c.[Index AdmitID]
		,[Index Admission Date] = c.[Index Admission Date]
		,[Index Discharge Date] = TRY_CONVERT(date,ISNULL(aa.DischargeDate,aa.DOSTHRU))
		FROM #AdmitAssessment AS aa
			JOIN 
			( -- INITIATE ...
			SELECT DISTINCT memid,Cx,DOS,DOSTHRU,ISNULL(DischargeDate,DOSTHRU) AS [DischargeDate],[PREVIOUS ADMIT DOS],[PREVIOUS ADMIT DOSTHRU],[Index AdmitID],[Index Admission Date] 
			FROM #AdmitAssessment 
			WHERE 1=1 
				AND [Index AdmitID] IS NOT NULL
			) -- CONCLUDE ...
			AS c ON aa.memid = c.memid 
				AND aa.Cx = c.Cx 
				AND aa.[PREVIOUS ADMIT DOS] = c.DOS 
				AND aa.[PREVIOUS ADMIT DOSTHRU] = ISNULL(c.DischargeDate,c.DOSTHRU)
			WHERE 1=1 
				AND aa.[Index AdmitID] IS NULL
				AND  aa.CONSECUTIVE = 1

SET @rowCount = @@ROWCOUNT;
IF (@rowCount = 0)
BREAK;
END

UPDATE #AdmitAssessment
SET [Index Discharge Date] = idd.[Index Discharge Date]
FROM #AdmitAssessment AS aa
	JOIN 
	( -- INITIATE ...
	SELECT [Index AdmitID],MAX([Index Discharge Date]) AS [Index Discharge Date]
	FROM #AdmitAssessment 
	WHERE 1=1 
		AND [Index AdmitID] IS NOT NULL
	GROUP BY [Index AdmitID]
	) -- CONCLUDE ...
	AS idd ON aa.[Index AdmitID] = idd.[Index AdmitID]







-- ======================================================================
	-- THE UNIT(S) ... [DAY(S)] -- 
-- ======================================================================
UPDATE #AdmitAssessment 
SET [CALENDAR DAY(S)] = cwd.[CALENDAR DAY(S)]
,[CALENDAR DAY(S) minus END / DISCHARGE date] = cwd.[CALENDAR DAY(S) minus END / DISCHARGE date]
FROM #AdmitAssessment AS aa
	JOIN 
	( -- INITIATE ...
	SELECT cdays.AdmitID
	,COUNT(DISTINCT(cdays.calendar_date)) AS [CALENDAR DAY(S)]
	,COUNT(DISTINCT(cdays.calendar_date))-1 AS [CALENDAR DAY(S) minus END / DISCHARGE date]
	FROM 
	( -- INITIATE ...
	SELECT DISTINCT 'ISOLATE FOR EVERY[DAY](S)' AS [NOTE(S)]
	,CAST(UPPER(LTRIM(RTRIM(ISNULL(t.memid,'')))) AS varchar(25))+CAST(UPPER(LTRIM(RTRIM(ISNULL(TRY_CONVERT(date,t.startdate),'')))) AS varchar(10))+CAST(UPPER(LTRIM(RTRIM(ISNULL(a.provid,'')))) AS varchar(25)) AS [AdmitID] -- 'Unique person, date of service, and provider = one visit'  OR 'Unique person, date of service, and NDC = one script'
	,dc.* -- ,t.claimid
	-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
	-- SELECT DISTINCT ' ' AS 'CHECK 1st'
	FROM INFORMATICS.dbo.date_calendarISO AS dc
	,(SELECT DISTINCT affiliationid,memid,startdate,enddate,dischargedate,provid 
	FROM HMOPROD_PLANDATA.dbo.claim (NOLOCK) 
	WHERE 1=1 
		AND claimid IN (SELECT DISTINCT claimid FROM INFORMATICS.dbo.DHCS_LTC_DSNP)) AS t -- DO NOT NO NEGATIVE <> != COVER UP THE TE() ... 50 YEAR CALENDAR [sp]
		JOIN HMOPROD_PLANDATA.dbo.affiliation (NOLOCK) AS a ON t.affiliationid = a.affiliationid -- REMINDER: within claim(s) tables AFFILIATIONID is the relationship between the a.provid = RENDERING PROVIDER AND the a.affiliateid = PAYTO aka VENDOR
	WHERE 1=1 
		AND TRY_CONVERT(date,dc.calendar_date) BETWEEN TRY_CONVERT(date,t.startdate) AND TRY_CONVERT(date,ISNULL(t.Dischargedate,t.enddate)) -- RINA()
		-- AND TRY_CONVERT(date,dc.calendar_date) BETWEEN TRY_CONVERT(date,@CalendarDate_Start) AND TRY_CONVERT(date,@CalendarDate_End) -- RINA()
		-- AND claimid NOT LIKE '%A%'  -- see "STEP88_ORIGINAL_CLAIM...sql" ... 'A "CLEAN CLAIM" is one that has no defect, impropriety, lack of any required substantiating documentation, or particular circumstance requiring special treatment that prevents timely payment.'
		-- AND claimid NOT LIKE '%R%'  -- see "STEP88_ORIGINAL_CLAIM...sql" ... 'A "CLEAN CLAIM" is one that has no defect, impropriety, lack of any required substantiating documentation, or particular circumstance requiring special treatment that prevents timely payment.'
	) -- CONCLUDE...
	AS cdays
	GROUP BY cdays.AdmitID
	) -- CONCLUDE ...
	AS cwd ON aa.AdmitID = cwd.AdmitID
	
UPDATE #AdmitAssessment 
SET [WORK DAY(S)] = cwd.[WORK DAY(S)]
FROM #AdmitAssessment AS aa
	JOIN 
	( -- INITIATE ...
	SELECT cdays.AdmitID
	,COUNT(DISTINCT(cdays.calendar_date)) AS [WORK DAY(S)]
	FROM 
	( -- INITIATE ...
	SELECT DISTINCT 'ISOLATE FOR EVERY[DAY](S)' AS [NOTE(S)]
	,CAST(UPPER(LTRIM(RTRIM(ISNULL(t.memid,'')))) AS varchar(25))+CAST(UPPER(LTRIM(RTRIM(ISNULL(TRY_CONVERT(date,t.startdate),'')))) AS varchar(10))+CAST(UPPER(LTRIM(RTRIM(ISNULL(a.provid,'')))) AS varchar(25)) AS [AdmitID] -- 'Unique person, date of service, and provider = one visit'  OR 'Unique person, date of service, and NDC = one script'
	,dc.* -- ,t.claimid
	-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
	-- SELECT DISTINCT ' ' AS 'CHECK 1st'
	FROM INFORMATICS.dbo.date_calendarISO AS dc,(SELECT DISTINCT affiliationid,memid,startdate,enddate,dischargedate,provid FROM HMOPROD_PLANDATA.dbo.claim WHERE claimid IN (SELECT DISTINCT claimid FROM INFORMATICS.dbo.DHCS_LTC_DSNP)) AS t -- DO NOT NO NEGATIVE <> != COVER UP THE TE() ... 50 YEAR CALENDAR [sp]
		JOIN HMOPROD_PLANDATA.dbo.affiliation AS a ON t.affiliationid = a.affiliationid -- REMINDER: within claim(s) tables AFFILIATIONID is the relationship between the a.provid = PROVIDER AND the a.affiliateid = PAYTO aka VENDOR
	WHERE 1=1 
		AND TRY_CONVERT(date,dc.calendar_date) BETWEEN TRY_CONVERT(date,t.startdate) AND TRY_CONVERT(date,ISNULL(t.Dischargedate,t.enddate)) -- RINA()
		-- AND TRY_CONVERT(date,dc.calendar_date) BETWEEN TRY_CONVERT(date,@CalendarDate_Start) AND TRY_CONVERT(date,@CalendarDate_End) -- RINA()
		-- AND claimid NOT LIKE '%A%'  -- see "STEP88_ORIGINAL_CLAIM...sql" ... 'A "CLEAN CLAIM" is one that has no defect, impropriety, lack of any required substantiating documentation, or particular circumstance requiring special treatment that prevents timely payment.'
		-- AND claimid NOT LIKE '%R%'  -- see "STEP88_ORIGINAL_CLAIM...sql" ... 'A "CLEAN CLAIM" is one that has no defect, impropriety, lack of any required substantiating documentation, or particular circumstance requiring special treatment that prevents timely payment.'
			AND dc.WORKDAY = 1
			-- AND dc.HOLIDAYS = 1
	) -- CONCLUDE...
	AS cdays
	GROUP BY cdays.AdmitID
	) -- CONCLUDE ...
	AS cwd ON aa.AdmitID = cwd.AdmitID	

UPDATE #AdmitAssessment
SET [Index Calendar Days] = icd.[Index Calendar Days]
FROM #AdmitAssessment AS uaa
	JOIN 
	( -- INITIATE ...
	SELECT [Index AdmitID],COUNT(DISTINCT(dc.calendar_date))-1 AS [Index Calendar Days] -- EXCLUDE / minus THE END / DISCHARGE date
	-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
	-- SELECT DISTINCT ' ' AS 'CHECK 1st'
	FROM INFORMATICS.dbo.date_calendarISO AS dc,#AdmitAssessment AS aa -- DO NOT NO NEGATIVE <> != COVER UP THE TE() ... 50 YEAR CALENDAR [sp]
	WHERE 1=1 
		AND TRY_CONVERT(date,dc.calendar_date) BETWEEN TRY_CONVERT(date,aa.[Index Admission Date]) AND TRY_CONVERT(date,aa.[Index Discharge Date]) -- RINA()
	GROUP BY [Index AdmitID]
	) --CONCLUDE ...
	AS icd ON uaa.[Index AdmitID] = icd.[Index AdmitID]
	
UPDATE #AdmitAssessment
SET [HCT LOGIC DAY(S)] = hct.[HCT LOGIC DAY(S)]
FROM #AdmitAssessment AS uaa
	JOIN 
	( -- INITIATE ...
	SELECT [AdmitID]
	,SUM([HCT LOGIC DAY(S)]) AS [HCT LOGIC DAY(S)]
	-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
	-- SELECT DISTINCT ' ' AS 'CHECK 1st'
	FROM INFORMATICS.dbo.DHCS_LTC_DSNP
	GROUP BY [AdmitID]
	) --CONCLUDE ...
	AS hct ON uaa.[AdmitID] = hct.[AdmitID]

DELETE
FROM #AdmitAssessment
WHERE 1=1 
	AND [Cx]+[AdmitID] IN 
	( -- INITIATE ...
	SELECT [Cx]+[AdmitID] AS [DupID]
	FROM #AdmitAssessment AS dup
	GROUP BY [Cx]+[AdmitID] -- Duplication Driver 
	HAVING COUNT(1)>1 -- HAVING clause RESERVED for AGGREGATE(s) ... HAVING SUM(PAID_NET_AMT) != 0
	) -- CONCLUDE ... 
		AND [DATEDIFF DAY(S)] != [CALENDAR DAY(S) minus END / DISCHARGE date]

	-- CHECK FOR DUP(S) --
SELECT ' ' AS 'SHOULD RETURN 0 ROWS - DUP Validation'
,Cx
,[AdmitID],*
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st',
FROM #AdmitAssessment
WHERE 1=1 
	AND [Cx]+[AdmitID] IN 
	( -- INITIATE ...
	SELECT [Cx]+[AdmitID] AS [DupID]
	FROM #AdmitAssessment AS dup
	GROUP BY [Cx]+[AdmitID] -- Duplication Driver 
	HAVING COUNT(1)>1 -- HAVING clause RESERVED for AGGREGATE(s) ... HAVING SUM(PAID_NET_AMT) != 0
	) -- CONCLUDE ... 







-- ============================================================= 
	-- SUMMARY: Days + Admits / Visits --
-- =============================================================
SELECT ' ' AS 'DETAIL SAMPLE: ',aa.* -- developsource.* 
FROM #AdmitAssessment AS aa
	-- JOIN INFORMATICS.dbo.DHCS_LTC_DSNP AS developsource ON aa.AdmitID = developsource.AdmitID
WHERE 1=1 
	AND aa.memid IN ('1017297') -- '73326','1098330','2435097'
	AND ISNULL(aa.[Index Discharge Date],GETDATE()) BETWEEN TRY_CONVERT(date,@RangeStartDate) AND TRY_CONVERT(date,@RangeEndDate)
	-- AND revcode BETWEEN '0110' AND '0219'
	-- AND TOTAL_PAID_AMOUNT > 0
	-- AND claimid NOT LIKE '%R%'
	-- AND HEADERstatus IN ('ADJUCATED','PAID','PAY','REV','REVERSED','REVSYNCH')
	-- AND developsource.DETAILstatus NOT IN ('DENY','VOID')

SELECT ' ' AS 'SUMMARY: Days + Admits / Visits BY [Cx / COS] BY memid',los.* -- ... large claims costs for hospital inpatient stays => than 30 days
INTO INFORMATICS.dbo.DELIVERABLE_DHCS_LTC_DSNP -- ... Enter the number of members currently residing in LTC for >90 days during the reporting period
FROM 
( -- INITIATE ...
SELECT aa.memid
,aa.Cx AS [Category of Service]
,COUNT(DISTINCT(aa.memid)) AS [UNIQUE UTILZERS]
,SUM(aa.[HCT LOGIC DAY(S)]) AS [DAY(S)]
,SUM(p.PAID) AS [PAID]
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM #AdmitAssessment AS aa
	JOIN 
	( -- INITIATE ...
	SELECT memid
	,AdmitID
	,SUM(PAID_NET_AMT) AS 'Paid'
	FROM INFORMATICS.dbo.DHCS_LTC_DSNP AS developsource
	GROUP BY memid,AdmitID
	) -- CONCLUDE ...
	AS p ON aa.memid = p.memid
		AND aa.AdmitID = p.AdmitID
WHERE 1=1
	AND CASE 
	WHEN TRY_CONVERT(date,ISNULL(aa.[Index Discharge Date],GETDATE())) > TRY_CONVERT(date,@RangeEndDate)
	THEN TRY_CONVERT(date,@RangeEndDate)
	ELSE ISNULL(aa.[Index Discharge Date],GETDATE()) 
	END BETWEEN TRY_CONVERT(date,@RangeStartDate) AND TRY_CONVERT(date,@RangeEndDate) -- ... Enter the number of members currently residing in LTC for >90 days during the reporting period
GROUP BY aa.memid,aa.Cx
) -- CONCLUDE ...
AS los
WHERE 1=1
	AND los.[DAY(S)] >= @ltcdays -- ... Enter the number of members currently residing in LTC for >90 days during the reporting period
	
		SELECT * FROM INFORMATICS.dbo.DELIVERABLE_DHCS_LTC_DSNP

SELECT ' ' AS 'SUMMARY: Days + Admits / Visits BY Cx COS BY [RENDERING]',los.* -- ... large claims costs for hospital inpatient stays => than 30 days
FROM 
( -- INITIATE ...
SELECT aa.Cx AS [Category of Service]
,aa.PROVNM,DATEPART(year,aa.DOS) AS YOS
,COUNT(DISTINCT(aa.memid)) AS [UNIQUE UTILZERS]
,COUNT(DISTINCT(aa.[Index AdmitID])) AS [INDEX ADMIT(S) / VISIT(S)] -- USING [Index AdmitID] ENABLES TRACKING OF [CONSECUTIVE] DAY(S)
,COUNT(DISTINCT(p.[AdmitID])) AS [ADMIT(S) / VISIT(S)] -- USING [Index AdmitID] ENABLES TRACKING OF [CONSECUTIVE] DAY(S)
,SUM([CALENDAR DAY(S)]) AS [CALENDAR DAY(S)]
,SUM([CALENDAR DAY(S) minus END / DISCHARGE date]) AS [CALENDAR DAY(S) minus END / DISCHARGE date]
,SUM([DATEDIFF DAY(S)]) AS [DATEDIFF DAY(S)]
,SUM([WORK DAY(S)]) AS [WORK DAY(S)]
,SUM([HCT LOGIC DAY(S)]) AS [HCT LOGIC DAY(S)]
,SUM(p.PAID) AS 'Paid'
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM #AdmitAssessment AS aa
	JOIN 
	( -- INITIATE ...
	SELECT AdmitID
	,SUM(PAID_NET_AMT) AS 'Paid'
	FROM INFORMATICS.dbo.DHCS_LTC_DSNP
	GROUP BY AdmitID
	) -- CONCLUDE ...
	AS p ON aa.AdmitID = p.AdmitID
GROUP BY aa.Cx,aa.PROVNM,DATEPART(year,aa.DOS)
) -- CONCLUDE ...
AS los
	
/* SELECT ' ' AS 'DHCS Long Term Care  (LTC) Quarterly D-SNP DSNP' -- MS EXCEL ODBC: DETAIL
,d.[RANGE NOTE(S)] AS 'Reporting Period'
,s.[Category of Service]
,s.[DAY(S)]
,s.memid
,d.SUBSCRID AS 'HealthPlanID'
,d.CIN
,d.MEMNM AS 'MemberName'
,TRY_CONVERT(date,d.dob) AS 'Date of Birth'
,d.NPIProvnm AS 'Rendering NPI'
,d.PROVNM AS 'Rendering Provider'
,d.DOS AS 'Date of Service'
,TRY_CONVERT(date,d.[DISCHARGE DATE]) AS 'Discharge Date'
,d.AUTH_NUMBER AS 'AuthorizationID'
-- ,s.*,d.*
FROM INFORMATICS.dbo.DELIVERABLE_DHCS_LTC_DSNP AS s
	JOIN INFORMATICS.dbo.DHCS_LTC_DSNP AS d ON s.memid = d.memid
WHERE 1=1
	AND d.[ClaimCategory] IN ('Paid')
ORDER BY d.memid,d.MEMNM,TRY_CONVERT(date,d.[DISCHARGE DATE]) DESC */

SELECT 'Community Health Group' AS 'Parent Company Name' -- MS EXCEL OLE DB ODBC: TEMPLATE
,'H4377/D-SNP' AS 'H Contract # '
,CAST(DATEPART(yyyy, CAST(@RangeEndDate AS datetime)) AS nvarchar (4))+' Q'+CAST(DATENAME(qq, CAST(@RangeEndDate AS datetime)) AS varchar(1)) AS [Reporting Period] -- ie. 2026 Q1
,'EAE' AS 'EAE or FIDE' 
,COUNT(DISTINCT(memid)) AS '#members residing in LTC for > 90 days'
INTO INFORMATICS.dbo.DELIVERABLE_DHCS_LTC_DSNP_TEMPLATE
FROM INFORMATICS.dbo.DELIVERABLE_DHCS_LTC_DSNP
CROSS APPLY (SELECT DISTINCT [RANGE NOTE(S)] FROM INFORMATICS.dbo.DHCS_LTC_DSNP) AS rp -- INDEPENDENT STAND ALONE ... CROSS APPLY() CROSS JOIN() CARTESIAN PRODUCT
GROUP BY rp.[RANGE NOTE(S)]

		SELECT * FROM INFORMATICS.dbo.DELIVERABLE_DHCS_LTC_DSNP_TEMPLATE
