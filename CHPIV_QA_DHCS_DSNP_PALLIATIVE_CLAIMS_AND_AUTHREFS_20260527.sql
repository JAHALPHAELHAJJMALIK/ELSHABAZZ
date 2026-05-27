-- =============================================================
	-- DHCS Palliative Quarterly D-SNP
-- =============================================================
/* SELECT ' ' AS 'PHIL TESTING: '
,r.*
FROM HMOPROD_PLANDATA.dbo.referral AS r
WHERE 1=1
	AND r.authorizationid IN ('4944423')

SELECT ' ' AS 'PHIL TESTING: '
,r.memid
,dc.*
FROM HMOPROD_PLANDATA.dbo.referral AS r (NOLOCK) 
		INNER JOIN HMOPROD_PLANDATA.dbo.authdiag AS ad (NOLOCK) ON r.referralid = ad.referralid
		INNER JOIN HMOPROD_PLANDATA.dbo.diagcode AS dc (NOLOCK) ON ad.diagcode = dc.codeid
	WHERE 1=1 
		AND UPPER(LTRIM(RTRIM(ISNULL(ad.diagcode,'')))) LIKE ISNULL('%'+@PalliativeDx+'%','%')

SELECT ' ' AS 'PHIL TESTING: '
,r.seendate
,r.memid
,dc.*
FROM HMOPROD_PLANDATA.dbo.referral AS r (NOLOCK) 
		INNER JOIN HMOPROD_PLANDATA.dbo.authdiag AS ad (NOLOCK) ON r.referralid = ad.referralid
		INNER JOIN HMOPROD_PLANDATA.dbo.diagcode AS dc (NOLOCK) ON ad.diagcode = dc.codeid
	WHERE 1=1 
		AND UPPER(LTRIM(RTRIM(ISNULL(ad.diagcode,'')))) LIKE ISNULL('%'+@PalliativeDx+'%','%')
		AND r.memid IN ('2684611')
ORDER BY TRY_CONVERT(date,ISNULL(r.seendate,'')) ASC */
	
-- =====================================================================
	-- Add the parameters for the stored procedure here:
-- =====================================================================
		DECLARE @BRAND AS nvarchar(100) = 'CHPIV' --'CHGSD' OR 'CHPIV' -- DEFAULT VAL()
		
-- ======================================
	-- MODIFICATION(S) / CHANGE.LOG: --
-- ======================================
-- C001: ADD claimdrg 'MS-DRG (Medicare Severity Diagnosis Related Groups) CODES' TO DETAIL AS OF 20240523

-- =====================================================================
	-- DECLARE @PARAMETER(S) / @FILTER(S) --
-- =====================================================================
-- DECLARE @SearchString AS varchar(255)
-- DECLARE @SPLITlob AS nvarchar(255)
DECLARE @leadlag AS decimal(9,0)
DECLARE @leadlagmonths AS int
DECLARE @when AS datetime
DECLARE @RangeStartDate AS datetime
DECLARE @RangeEndDate AS datetime
DECLARE @LOB AS varchar(255)
DECLARE @PalliativeDx AS nvarchar(255)

-- SET @SearchString = NULL  -- see CREATE TABLE #employee
-- SET @SPLITlob = 'MEDI-CAL,DSNP,CSNP,CMC,MSO - CHPIV' -- SQL: STRING_SPLIT() ... LINE_OF_BUSINESS OPTION(S)
SET @leadlag = -4 -- +- LEAD() LAG() IN ...
SET @leadlagmonths = 3 -- +- LEAD() LAG() IN MONTH(S)
SET @when = NULL
SET @RangeStartDate = DATEADD(MONTH,@leadlag,DATEADD(DAY,1,EOMONTH(GETDATE(),-1))) -- AS [1st of ... MONTH]
SET @RangeEndDate = DATEADD(day,-1,DATEADD(MONTH,@leadlagmonths,@RangeStartDate))
SET @LOB = 'CHPIV' -- bp.[OPTION(S)]: IN ('COMMUNITY Y MAS (HMO C-SNP)','DSNP MEDI-CAL PLAN','MEDI-CAL BENEFIT PLAN') ... p.[OPTION(S)]: IN ('DSNP MEDI-CAL','DSNP MEDICARE','COMMUNITY Y MAS (HMO C-SNP)','MEDI-CAL') -- ACTIVE LOB LOCK ... 
SET @PalliativeDx ='Z51.5'

		-- SELECT value FROM STRING_SPLIT(@SPLITlob, ',')

		SELECT ' ' AS '"DECLARE*" @PARAM(S)'
		,'BETWEEN '+CAST(CAST(@RangeStartDate AS date) AS varchar(255))+' AND '+CAST(CAST(@RangeEndDate AS date) AS varchar(255)) AS 'RANGE NOTE(s)'
		,bp.*
		FROM INFORMATICS.dbo.[uvw_LINE_OF_BUSINESS] AS bp -- HMOPROD_PLANDATA.dbo.benefitplan + HMOPROD_PLANDATA.dbo.program
		WHERE 1=1
			AND bp.[LINE_OF_BUSINESS] LIKE ISNULL('%'+@LOB+'%','%') -- CARDINALITY HIERARCHY CASUALTY ... LEAVE AS FINAL FILTER
			AND bp.[BRAND] IN (ISNULL(@BRAND,'CHPIV')) -- ('MEDI-CAL BENEFIT PLAN','DSNP MEDI-CAL PLAN','COMMUNITY Y MAS (HMO C-SNP)','IV_DSNP2 MEDI-CAL PLAN','CHG MARKETPLACE HMO PLAN') -- VALID ACTIVE OPTION(S) -- C###: ADD BRANDING FOR CHPIV 'MSO' = management services organization IMPLEMENTATION AS OF 01/01/2026 GO LIVE 
			
		SELECT 'Dx - DIAGNOSIS' AS [CodeType]
		,ISNULL(dc.description,'') AS [CodeDescr]
		,dc.*
		FROM HMOPROD_PLANDATA.dbo.DiagCode AS dc 
		WHERE 1=1 
			AND dc.codeid LIKE ISNULL('%'+@PalliativeDx+'%','%')		







-- ===================================================================================================
	--  COPT: PRE-STAGE STEP 2 - QUALIFY / KEY ON ... [claimid] IN A SINGLE PASS * PURPOSE: 1ST FIRST PRINCIPLE FILTER THE DETAIL:
-- ===================================================================================================
--------------------------------------------------------------------------------------------------------------------
	-- Error Trapping: Check If Permanent Table(s) Already Exist(s) And Drop If Applicable --
--------------------------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS #PREDISQUALIFYING_CLAIMS; -- PRE - FILTER EXCLUSION
DROP TABLE IF EXISTS #QUALIFYING_CLAIMS; -- FILTER THE DETAIL
DROP TABLE IF EXISTS INFORMATICS.dbo.CHPIV_QA_PALLIATIVE_CLAIM;
DROP TABLE IF EXISTS INFORMATICS.dbo.CHPIV_QA_PALLIATIVE_AUTH;
DROP TABLE IF EXISTS INFORMATICS.dbo.CHPIV_TEMPLATE_PALLIATIVE;

SELECT DISTINCT clm.claimid -- KEY ON ... FINAL ANSWER: the CASE statement cannot produce duplicate claimid, memid rows by itself. It returns one and only one classification per input row, with the first true WHEN taking PRECEDENCE.
,clm.memid
,CASE -- SCENARIO A: BILLTYPE MATCH -- C002: PER BRD / NARRATIVE "D-SNP Transmission of Admission Notification Narrative 04-01-2026 (002).docx"
WHEN diag.codeid LIKE ISNULL('%'+@PalliativeDx+'%','%')
THEN 'PALLIATIVE'
ELSE 'NOT_QUALIFYING'
END AS [InclusionExclusionType]
INTO #PREDISQUALIFYING_CLAIMS
-- SELECT TOP 10 ' ' AS 'CHECK 1st',* 
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM HMOPROD_PLANDATA.dbo.claim (NOLOCK) AS clm
    INNER JOIN INFORMATICS.dbo.[uvw_LINE_OF_BUSINESS] AS bp ON clm.planid = bp.planid
	-- INNER JOIN HMOPROD_PLANDATA.dbo.affiliation (NOLOCK) AS a ON clm.affiliationid = a.affiliationid -- REMINDER: within claim(s) tables AFFILIATIONID is the relationship BETWEEN the a.provid = [RENDERING] PROVIDER AND the a.affiliateid = [PAYTO] PROVIDER	
		-- LEFT JOIN INFORMATICS.dbo.[uvw_CLAIMS_BILLTYPE] AS sbt ON (LTRIM(RTRIM(clm.facilitycode))+LTRIM(RTRIM(clm.billclasscode))+LTRIM(RTRIM(clm.frequencycode))) = sbt.QNXTbilltype
	INNER JOIN 
	( -- INITIATE ...
	SELECT aliasrank.*
	FROM 
	( -- INITIATE ...
	SELECT aliassetup.*
	-- ,DENSE_RANK() OVER (PARTITION BY aliassetup.claimid ORDER BY aliassetup.sequence ASC,aliassetup.codeid DESC) AS [RANKis]
	,ROW_NUMBER() OVER (PARTITION BY aliassetup.claimid ORDER BY aliassetup.sequence ASC,aliassetup.codeid DESC) AS [ROWis]
	FROM 
	( -- INITIATE ...
	SELECT dx.claimid
	,dx.codeid
	,UPPER(LTRIM(RTRIM(ISNULL(dx.codeid,'')))) AS [diag]
	,ISNULL(dc.DESCRIPTION,'') AS [diag descr]
	,dx.sequence
	,dx.poa AS 'PRESENT ON ADMISSION'
	,dx.diagtype --Primary, Secondary, Admit, PRV, Trauma, 1, 2, 3, ...
	-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
	-- SELECT DISTINCT ' ' AS 'CHECK 1st'	
	FROM HMOPROD_PLANDATA.dbo.claimdiag (NOLOCK) AS dx
		LEFT JOIN HMOPROD_PLANDATA.dbo.DiagCode (NOLOCK) AS dc ON dx.codeid = dc.codeid
	GROUP BY dx.claimid,dx.codeid,UPPER(LTRIM(RTRIM(ISNULL(dx.codeid,'')))),ISNULL(dc.DESCRIPTION,''),dx.sequence,dx.poa,dx.diagtype
	) -- CONCLUDE
	AS aliassetup
	) -- CONCLUDE
	AS aliasrank
	WHERE 1=1
		-- AND aliasrank.sequence = 1 -- ONLY PRIMARY DIAGNOSES
		-- AND aliasrank.[RANKis] = 1
		-- AND aliasrank.[ROWis] = 1 -- ONLY PRIMARY DIAGNOSES
		AND aliasrank.codeid LIKE ISNULL('%'+@PalliativeDx+'%','%')
	) -- CONCLUDE ...
	AS diag ON clm.claimid = diag.claimid
WHERE 1=1
	AND bp.[LINE_OF_BUSINESS] LIKE ISNULL('%'+@LOB+'%','%') -- CARDINALITY HIERARCHY CASUALTY ... LEAVE AS FINAL FILTER
	AND bp.[BRAND] IN (ISNULL(@BRAND,'CHGSD')) -- ('MEDI-CAL BENEFIT PLAN','DSNP MEDI-CAL PLAN','COMMUNITY Y MAS (HMO C-SNP)','IV_DSNP2 
	AND TRY_CONVERT(date,clm.startdate) < @RangeStartDate

CREATE CLUSTERED INDEX idx_QC_claimid ON #PREDISQUALIFYING_CLAIMS (claimid);
CREATE NONCLUSTERED INDEX idx_QC_memid ON #PREDISQUALIFYING_CLAIMS (memid);

	-- CHECK FOR DUP(S) --
SELECT ' ' AS 'SHOULD RETURN 0 ROWS - DUP Validation',*
FROM #PREDISQUALIFYING_CLAIMS
WHERE 1=1
    AND [claimid] IN
    ( -- INITIATE ...
    SELECT [claimid]
    FROM #PREDISQUALIFYING_CLAIMS AS dup
    GROUP BY [claimid]
    HAVING COUNT(1)>1
    ) -- CONCLUDE ...

        SELECT ' ' AS 'QA PRE-STAGE OF DISQUALIFYING CLAIM COUNT: '
        ,InclusionExclusionType
        ,COUNT(DISTINCT claimid) AS [Unique Claims]
        ,COUNT(DISTINCT memid) AS [Unique Members]
        FROM #PREDISQUALIFYING_CLAIMS
        WHERE 1=1
            AND NOT InclusionExclusionType = 'NOT_QUALIFYING' -- NO NOT NEGATIVE <> = ...
        GROUP BY InclusionExclusionType








SELECT DISTINCT clm.claimid -- KEY ON ... FINAL ANSWER: the CASE statement cannot produce duplicate claimid, memid rows by itself. It returns one and only one classification per input row, with the first true WHEN taking PRECEDENCE.
,clm.memid
,diag.[diag descr]
,CASE -- SCENARIO A: BILLTYPE MATCH -- C002: PER BRD / NARRATIVE "D-SNP Transmission of Admission Notification Narrative 04-01-2026 (002).docx"
WHEN diag.codeid LIKE ISNULL('%'+@PalliativeDx+'%','%')
THEN 'PALLIATIVE'
ELSE 'NOT_QUALIFYING'
END AS [InclusionExclusionType]
INTO #QUALIFYING_CLAIMS
-- SELECT TOP 10 ' ' AS 'CHECK 1st',* 
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM HMOPROD_PLANDATA.dbo.claim (NOLOCK) AS clm
    INNER JOIN INFORMATICS.dbo.[uvw_LINE_OF_BUSINESS] AS bp ON clm.planid = bp.planid
	-- INNER JOIN HMOPROD_PLANDATA.dbo.affiliation (NOLOCK) AS a ON clm.affiliationid = a.affiliationid -- REMINDER: within claim(s) tables AFFILIATIONID is the relationship BETWEEN the a.provid = [RENDERING] PROVIDER AND the a.affiliateid = [PAYTO] PROVIDER	
		-- LEFT JOIN INFORMATICS.dbo.[uvw_CLAIMS_BILLTYPE] AS sbt ON (LTRIM(RTRIM(clm.facilitycode))+LTRIM(RTRIM(clm.billclasscode))+LTRIM(RTRIM(clm.frequencycode))) = sbt.QNXTbilltype
	INNER JOIN 
	( -- INITIATE ...
	SELECT aliasrank.*
	FROM 
	( -- INITIATE ...
	SELECT aliassetup.*
	-- ,DENSE_RANK() OVER (PARTITION BY aliassetup.claimid ORDER BY aliassetup.sequence ASC,aliassetup.codeid DESC) AS [RANKis]
	,ROW_NUMBER() OVER (PARTITION BY aliassetup.claimid ORDER BY aliassetup.sequence ASC,aliassetup.codeid DESC) AS [ROWis]
	FROM 
	( -- INITIATE ...
	SELECT dx.claimid
	,dx.codeid
	,UPPER(LTRIM(RTRIM(ISNULL(dx.codeid,'')))) AS [diag]
	,ISNULL(dc.DESCRIPTION,'') AS [diag descr]
	,dx.sequence
	,dx.poa AS 'PRESENT ON ADMISSION'
	,dx.diagtype --Primary, Secondary, Admit, PRV, Trauma, 1, 2, 3, ...
	-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
	-- SELECT DISTINCT ' ' AS 'CHECK 1st'	
	FROM HMOPROD_PLANDATA.dbo.claimdiag (NOLOCK) AS dx
		LEFT JOIN HMOPROD_PLANDATA.dbo.DiagCode (NOLOCK) AS dc ON dx.codeid = dc.codeid
	GROUP BY dx.claimid,dx.codeid,UPPER(LTRIM(RTRIM(ISNULL(dx.codeid,'')))),ISNULL(dc.DESCRIPTION,''),dx.sequence,dx.poa,dx.diagtype
	) -- CONCLUDE
	AS aliassetup
	) -- CONCLUDE
	AS aliasrank
	WHERE 1=1
		-- AND aliasrank.sequence = 1 -- ONLY PRIMARY DIAGNOSES
		-- AND aliasrank.[RANKis] = 1
		-- AND aliasrank.[ROWis] = 1 -- ONLY PRIMARY DIAGNOSES
		AND aliasrank.codeid LIKE ISNULL('%'+@PalliativeDx+'%','%')
	) -- CONCLUDE ...
	AS diag ON clm.claimid = diag.claimid
WHERE 1=1
	/* AND NOT TRY_CONVERT(date,cd.dosfrom) < @RangeStartDate -- NO NOT NEGATIVE <> != ... A snowflake sp CRITERIA "PROD_CHG_ODS.INFORMATICS.SP_DSNP_PALLIATIVE_QUARTERLY" */
	AND bp.[LINE_OF_BUSINESS] LIKE ISNULL('%'+@LOB+'%','%') -- CARDINALITY HIERARCHY CASUALTY ... LEAVE AS FINAL FILTER
	AND bp.[BRAND] IN (ISNULL(@BRAND,'CHGSD')) -- ('MEDI-CAL BENEFIT PLAN','DSNP MEDI-CAL PLAN','COMMUNITY Y MAS (HMO C-SNP)','IV_DSNP2 
	AND TRY_CONVERT(date,ISNULL(clm.enddate,GETDATE())) >= @RangeStartDate -- WITHIN reporting period [RANGE] OPPOSITION ...
	AND TRY_CONVERT(date,clm.startdate) <= @RangeEndDate -- WITHIN reporting period [RANGE] OPPOSITION ... 
	AND NOT clm.memid IN -- NO NOT NEGATIVE <> != ... ENSURE CAPTURE OF 'ONLY ... members NEWLY enrolled in palliative care services within the reporting period.'
	(-- INITIATE ...
	SELECT memid FROM #PREDISQUALIFYING_CLAIMS GROUP BY memid
	) -- CONCLUDE ... 	
	AND ISNULL(clm.enddate,GETDATE()) >= clm.startdate -- MUST BE TRUE ... NON-CROSSFOOTED RECORDS ARE ACTIVE ...	
	/* AND clm.memid IN ('2515648','2072036','2179179','2039563','2007640','2138850','2289620','2080680','2283915','2069305','859291','2656298','2424902','2088863','969712','2139826','2041205','2679388','2389066','2108288','2421699','1014002','2279227','2576397','1080707','2159422','1037378','2011234','2017576','2379409','1002900','2088864','1032334','188349','2137637','220796','2474081','2114567','2474792','2088816','2159490','2050967','2341572','862674') -- IN SQL NOT IN snowflake TABLE: PROD_CHG_ODS.INFORMATICS.PreviousPalliativeMembers	 */

CREATE CLUSTERED INDEX idx_QC_claimid ON #QUALIFYING_CLAIMS (claimid);
CREATE NONCLUSTERED INDEX idx_QC_memid ON #QUALIFYING_CLAIMS (memid);







-- =====================================================================
	--  SETCLAIM CTE: NOW JOINS #QUALIFYING_CLAIMS ONLY - NOT FULL TABLES
-- =====================================================================
;WITH setclaim AS
( -- INITIATE ...
SELECT qc.claimid
,qc.memid
,qc.[InclusionExclusionType]
,qc.[diag descr]
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM #QUALIFYING_CLAIMS AS qc
WHERE 1=1
    AND NOT qc.InclusionExclusionType = 'NOT_QUALIFYING' -- NO NOT NEGATIVE <> != ...
GROUP BY qc.claimid,qc.memid,qc.[InclusionExclusionType],qc.[diag descr] -- CONSIDER Removing DISTINCT IN FAVOR OF GROUP BY: REPLACE the DISTINCT in the final SELECT with a proper GROUP BY clause. This is more explicit about the aggregation intent and allows the query optimizer to work more efficiently.
) -- CONCLUDE ...

SELECT ' ' AS 'Palliative Claims',* 
INTO INFORMATICS.dbo.CHPIV_QA_PALLIATIVE_CLAIM
FROM setclaim;

		SELECT ' ' AS 'Claim - Palliative Members IN Qtr Without Previous Qtr HIT: '
		,COUNT(DISTINCT(memid)) AS 'Unique Member Count' 
		FROM INFORMATICS.dbo.CHPIV_QA_PALLIATIVE_CLAIM;
		
		/* SELECT ' ' AS "TEST snowflake AGAINST - 'QA_DHCS_DSNP_PALLIATIVE_CLAIMS_AND_AUTHREFS_20250825.sql' RESULT(S): ",* 
		FROM PROD_CHG_ODS.INFORMATICS.PreviousPalliativeMembers
		WHERE 1=1
			AND MEMBERAK IN ('210807','2201048','2083121','2515648','2072036','2184836','2566111','2192485','104559','2075864','2130307','131532','938865','99907','2179179','2137809','125151','2039563','2464855','2072075','120743','2072067','2179904','2323202','2070731','2138529','2050187','2120026','2332984','2154406','2088675','2007640','2326265','1025850','2285851','1046237','2153091','2137661','2091246','2173661','2138850','854739','802999','2121830','2154294','73213','2140791','2120665','2099799','2667277','84899','2230382','2048836','2492167','2289620','2089041','2174229','2307919','2420865','2088807','2072467','2080680','2708520','2137656','2501326','1025740','2139189','994153','2425448','1030024','91834','2283915','2525630','2069305','859291','2454895','2497218','2106919','2576397','2057332','2046850','2072985','2072609','2166344','2605687','2120663','2468851','2137542','2420836','2367310','2137702','2089547','2169088','2283961','2549269','2122262','2311008','1080707','2080324','118401','2159422','2138600','2107666','918484','2539379','2072767','2217081','2159517','115793','292250','2172837','921800','882056','2321873','2400521','2210767','2130173','2529242','1037378','1065862','2120058','2011234','2024296','2361363','2068201','2138752','2017576','2414394','2379409','1021517','2152786','2367417','1002900','2480337','1042093','2039479','2138464','2358983','2152984','2083210','2195320','993374','2204990','2153100','2138962','2433797','2066785','2015240','2382959','2433417','2278651','2349597','2084737','2470759','2369996','2494997','2292161','2452860','970059','2656298','2424902','2046729','845791','2109717','910327','2553854','2464779','1078343','2107911','2088863','2086698','812341','2152782','1053775','800416','2671401','1070778','2073615','2107005','1012500','2089114','969712','949927','2103591','2119921','1079159','2525825','2653128','2139826','2346581','2041205','2173773','964692','1037928','914323','2679388','2547746','2130225','2160016','2120177','1076688','2471195','2088684','2552494','2137901','1050679','838984','2027630','2101008','2159540','2389066','1065515','2168949','2039959','2224653','2554233','2170125','1078397','2195280','2048859','2272248','2022290','1030485','2130377','1049172','2108288','2355363','2421699','1014002','2107332','2279227','2450325','2517532','1001246','2276570','2081026','2070310','2502234','1070912','2088864','102112','2485528','2280050','1070371','2080281','2152945','2349548','2152851','2168716','2037817','2479827','2138658','2230862','2473413','2284833','2525256','2480022','2117528','854762','2515110','950105','2068335','2140041','1077202','1032334','2039512','2482845','1038912','2080376','188349','2137637','2159472','220796','2205369','106051','2444532','2045917','2119975','2138328','2206880','2080087','1009699','2184808','2166369','195841','2376212','2474081','34913','2131099','2260490','2087356','2359112','2101887','2314632','2114567','2130232','2474792','2402124','2152820','2162947','2650511','2088816','2159490','106704','1046175','2153016','827824','2482767','2096849','2050967','2152763','2000592','1033527','2131450','2499715','2008260','2341572','2236053','133074','2461705','2120652','1040187','2470883','1044973','2155799','2625828','2570506','2650208','2171849','1058423','2050621','2471874','2565844','2414422','2041958','2138347','2315427','2578486','2066120','2100384','2647748','2263628','2066139','2028846','2069758','862674','1054328','2088673') */







-- =====================================================================
	-- Add the parameters for the stored procedure here:
-- =====================================================================
		-- /* DECLARE */ @BRAND AS nvarchar(100) = NULL --'CHGSD' OR 'CHPIV' -- DEFAULT VAL()

-- =====================================================================
	-- AUTH Request for Information (RFI) --
-- =====================================================================

-- =====================================================================
	-- MODIFICATION(S) / CHANGE.LOG: --
-- =====================================================================
-- C000: Coordinated Universal Time or UTC is the primary time standard globally used to regulate clocks and time. It establishes a reference for the current time, forming the basis for civil time and time zones. UTC facilitates international communication, navigation, scientific research, and commerce.

		-- ,CONVERT(datetime,(r.UtcReceiptDate at time zone 'UTC') at time zone 'Pacific Standard Time') 

-- =====================================================================
	-- DECLARE @PARAMETER(S) / @FILTER(S) --
-- =====================================================================
DECLARE @ClockStart AS datetime
DECLARE @ClockStop AS datetime
DECLARE @Authrundt AS datetime
-- DECLARE @Authlob AS nvarchar(255)
-- DECLARE @PalliativeDx AS nvarchar(255)

SET @ClockStart = DATEADD(MONTH,@leadlag,DATEADD(DAY,1,EOMONTH(GETDATE(),-1))) -- AS [1st of ... MONTH]
SET @ClockStop = DATEADD(day,-1,DATEADD(MONTH,@leadlagmonths,@ClockStart))
SET @Authrundt = TRY_CONVERT(date,GETDATE())
-- SET @Authlob =  'CHPIV' -- bp.[OPTION(S)]: IN ('COMMUNITY Y MAS (HMO C-SNP)','DSNP MEDI-CAL PLAN','MEDI-CAL BENEFIT PLAN') ... p.[OPTION(S)]: IN ('DSNP MEDI-CAL','DSNP MEDICARE','COMMUNITY Y MAS (HMO C-SNP)','MEDI-CAL') -- ACTIVE LOB LOCK ... 
-- SET @PalliativeDx ='Z51.5'

		SELECT ' ' AS 'AUTH Request for Information (RFI)'
		,'BETWEEN '+CONVERT(nvarchar(10),@ClockStart,101)+' AND '+CONVERT(nvarchar(10),@ClockStop,101) AS 'RANGE NOTE(S)'
		,@Authrundt AS 'EXEC DATE'
		-- ,@Authlob AS 'LOB @parm FILTER'
		,bp.*
		-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
		-- SELECT DISTINCT ' ' AS 'CHECK 1st'
		FROM INFORMATICS.dbo.[uvw_LINE_OF_BUSINESS] AS bp (NOLOCK) -- HMOPROD_PLANDATA.dbo.benefitplan + HMOPROD_PLANDATA.dbo.program
		WHERE 1=1 
			-- AND bp.[LINE_OF_BUSINESS] LIKE ISNULL('%'+@Authlob+'%','%')
			AND bp.[BRAND] IN (ISNULL(@BRAND,'CHPIV')) -- ('MEDI-CAL BENEFIT PLAN','DSNP MEDI-CAL PLAN','COMMUNITY Y MAS (HMO C-SNP)','IV_DSNP2 MEDI-CAL PLAN','CHG MARKETPLACE HMO PLAN') -- VALID ACTIVE OPTION(S) -- C###: ADD BRANDING FOR CHPIV 'MSO' = management services organization IMPLEMENTATION AS OF 01/01/2026 GO LIVE 
			






;WITH PREVLTCAUTHREFS AS 
( -- INITIATE ...
SELECT prev_r.memid
FROM HMOPROD_PLANDATA.dbo.referral AS prev_r (NOLOCK)
	INNER JOIN HMOPROD_PLANDATA.dbo.enrollkeys AS prev_e (NOLOCK) ON prev_r.enrollid = prev_e.enrollid
	INNER JOIN INFORMATICS.dbo.[uvw_LINE_OF_BUSINESS] AS prev_bp (NOLOCK) ON prev_e.programid = prev_bp.programid
	INNER JOIN HMOPROD_PLANDATA.dbo.authdiag AS prev_ad (NOLOCK) ON prev_r.referralid = prev_ad.referralid
WHERE 1=1
	AND UPPER(LTRIM(RTRIM(ISNULL(prev_ad.diagcode,'')))) LIKE ISNULL('%'+@PalliativeDx+'%','%')
	-- AND prev_bp.[LINE_OF_BUSINESS] LIKE ISNULL('%'+@Authlob+'%','%')
	AND prev_bp.[BRAND] IN (ISNULL(@BRAND,'CHPIV'))
	AND TRY_CONVERT(date, prev_r.seendate) < @ClockStart 
GROUP BY prev_r.memid
) -- CONCLUDE ...

		-- SELECT TOP 1 * FROM PREVLTCAUTHREFS

,SETAUTHREF AS 
( -- INITIATE ...
SELECT DISTINCT r.memid
,r.authorizationid
,ad.referralid,UPPER(LTRIM(RTRIM(ISNULL(ad.diagcode,'')))) AS [Diagnosis code]
,LTRIM(RTRIM(ad.diagqualifier)) AS [Diagnosis Category]
,[Diagnosis codes Descr] = UPPER(LTRIM(RTRIM(ISNULL(dc.description,'')))),sequence
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM HMOPROD_PLANDATA.dbo.referral AS r (NOLOCK) 
	INNER JOIN HMOPROD_PLANDATA.dbo.enrollkeys AS e (NOLOCK) ON r.enrollid = e.enrollid
	INNER JOIN INFORMATICS.dbo.[uvw_LINE_OF_BUSINESS] AS bp (NOLOCK) ON e.programid = bp.programid  -- HMOPROD_PLANDATA.dbo.benefitplan + HMOPROD_PLANDATA.dbo.program	
	INNER JOIN HMOPROD_PLANDATA.dbo.authdiag AS ad (NOLOCK) ON r.referralid = ad.referralid
	INNER JOIN HMOPROD_PLANDATA.dbo.diagcode AS dc (NOLOCK) ON ad.diagcode = dc.codeid
WHERE 1=1 
	AND UPPER(LTRIM(RTRIM(ISNULL(ad.diagcode,'')))) LIKE ISNULL('%'+@PalliativeDx+'%','%')
	-- AND bp.[LINE_OF_BUSINESS] LIKE ISNULL('%'+@Authlob+'%','%')
	AND bp.[BRAND] IN (ISNULL(@BRAND,'CHPIV')) -- ('MEDI-CAL BENEFIT PLAN','DSNP MEDI-CAL PLAN','COMMUNITY Y MAS (HMO C-SNP)','IV_DSNP2 MEDI-CAL PLAN','CHG MARKETPLACE HMO PLAN') -- VALID ACTIVE OPTION(S) -- C###: ADD BRANDING FOR CHPIV 'MSO' = management services organization IMPLEMENTATION AS OF 01/01/2026 GO LIVE 
	AND CAST(r.effdate AS date) BETWEEN CAST(e.effdate AS date) AND CAST(e.termdate AS date) -- RINA: APPLIED TO FIELD WITHIN TABLE TO BE UPDATE	
	AND TRY_CONVERT(date,seendate) BETWEEN @ClockStart AND @ClockStop -- Coordinated Universal Time or UTC is the primary time standard globally used to regulate clocks and time. It establishes a reference for the current time, forming the basis for civil time and time zones. UTC facilitates international communication, navigation, scientific research, and commerce. ... ADHOC REQUEST per eMAIL FROM MS NATALIA ON 20221115 '... We need to run a report through AuthScans for Auth Scan Report for EYECARE OF SAN DIEGO/Provider ID: 313124 ...'
	AND NOT r.memid IN -- NO NOT NEGATIVE <> != ... 
	(-- INITIATE ...
	SELECT memid FROM PREVLTCAUTHREFS GROUP BY memid -- TO ENSURE CAPTURE OF '... members NEWLY enrolled in palliative care services within the reporting period.'
	) -- CONCLUDE ... 
	AND TRY_CONVERT(date,ISNULL(r.termdate,GETDATE())) >= TRY_CONVERT(date,r.effdate) -- MUST BE TRUE ... NON-CROSSFOOTED RECORDS ARE ACTIVE ...	
	) -- CONCLUDE ...

SELECT ' ' AS 'Palliative Authrefs',* 
INTO INFORMATICS.dbo.CHPIV_QA_PALLIATIVE_AUTH
FROM SETAUTHREF;

		SELECT ' ' AS 'Auth - Palliative Members IN Qtr Without Previous Qtr HIT: '
		,COUNT(DISTINCT(memid)) AS 'Unique Member Count' 
		FROM INFORMATICS.dbo.CHPIV_QA_PALLIATIVE_AUTH;







-- =====================================================================
	-- MS EXCEL OLE DB ODBC / TEMPLATE DELIVERABLE - RACE / ETHNICITY ASSIGNMENT: 
-- =====================================================================
-- =====================================================================
	-- STRATIFICATIONS: RACE / ETHNICITY:
-- =====================================================================
-----------------------------------------------------------------------------------------------------------------------------
	-- Error Trapping: Check If Permanent Table(s) Already Exist(s) And Drop If Applicable --
-----------------------------------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS #baselinememiso
DROP TABLE IF EXISTS #MemberEnrollmentEthnicityRace

SELECT ' ' AS '#BASELINE ISO MEMBERSHIP'
,baselinesource.memid
,baselinesource.CIN
,Race_White = TRY_CONVERT(decimal(9,0),0)
,Race_Black_Or_African_American = TRY_CONVERT(decimal(9,0),0)
,Race_American_Indian_And_Alaska_Native = TRY_CONVERT(decimal(9,0),0)
,Race_Asian = TRY_CONVERT(decimal(9,0),0)
,Race_Native_Hawaiian_And_Other_Pacific_Islander = TRY_CONVERT(decimal(9,0),0)
,Race_Some_Other_Race = TRY_CONVERT(decimal(9,0),0)
,Race_Two_Or_More_Races = TRY_CONVERT(decimal(9,0),0)
,Race_Asked_But_No_Answer = TRY_CONVERT(decimal(9,0),0)
,Race_Asked_But_No_Answer_with_Eth_Hispanic = TRY_CONVERT(decimal(9,0),0)
,Race_Asked_But_No_Answer_with_Eth_Not_Hispanic = TRY_CONVERT(decimal(9,0),0)
,Race_Unknown = TRY_CONVERT(decimal(9,0),0)
,Ethnicity_Hispanic_Latino = TRY_CONVERT(decimal(9,0),0)
,Ethnicity_Not_Hispanic_Latino = TRY_CONVERT(decimal(9,0),0)
,Ethnicity_Asked_But_No_Answer = TRY_CONVERT(decimal(9,0),0)
,Ethnicity_Unknown = TRY_CONVERT(decimal(9,0),0)
INTO #baselinememiso
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM 
( -- INITIATE ...
SELECT pall.memid,bm.CIN
FROM INFORMATICS.dbo.CHPIV_QA_PALLIATIVE_AUTH AS pall
	INNER JOIN INFORMATICS.dbo.uvw_BASELINE_MEMBERSHIP AS bm ON pall.memid = bm.memid

UNION ALL
SELECT pall.memid,bm.CIN
FROM INFORMATICS.dbo.CHPIV_QA_PALLIATIVE_CLAIM AS pall
	INNER JOIN INFORMATICS.dbo.uvw_BASELINE_MEMBERSHIP AS bm ON pall.memid = bm.memid
) -- CONCLUDE ...
AS baselinesource
-- WHERE 1=1
	-- AND [CONSECUTIVE MONTH(S)] = 3 -- ... enrolled as DSNP in Reporting Period 
	-- AND TRY_CONVERT(date,EligibilityEnd) = TRY_CONVERT(date,@ClockStop) -- ... (Continuously enrolled until the last day of the reporting period
	-- AND [AGE] >20 -- ... Look for individuals greater than 21 years of age:
GROUP BY baselinesource.memid,baselinesource.CIN

		SELECT ' ' AS 'REVIEW OUTPUT: ',* FROM #baselinememiso;

	-- DENOMINATOR DEVELOPMENT:
SELECT mem.CIN
,omb.OMBdesc
INTO #MemberEnrollmentEthnicityRace
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM #baselinememiso AS mem ----- use your base table with the race/ethnicity columns
	INNER JOIN EnrollmentManager.dbo.[Member] AS m ON m.ClientIndexNumber = mem.CIN
	INNER JOIN EnrollmentManager.dbo.healthcoverage AS hc ON m.ClientIndexNumber = hc.ClientIndexNumber
	INNER JOIN EnrollmentManager.dbo.healthcoverageoverlay AS hco ON hc.ClientIndexNumber = hco.ClientIndexNumber
	INNER JOIN EnrollmentManager..EthnicityIndustryCode AS eic (NOLOCK) on m.EthnicityIndustryCode = eic.Code
	INNER JOIN informatics.dbo.Ethnicity_EICandOMBDesc_XWalk AS omb ON omb.EIC = eic.Code
WHERE 1=1
	AND hc.FileId = hco.FileId 
	AND hc.BenefitBeginDate = hco.BenefitBeginDate
	AND TRY_CONVERT(DATE,hc.BenefitEndDate) >= @ClockStart -- WITHIN reporting period [RANGE] OPPOSITION ...
	AND TRY_CONVERT(DATE,hco.BenefitBeginDate) <= @ClockStop -- WITHIN reporting period [RANGE] OPPOSITION ... 
GROUP BY mem.CIN,omb.OMBdesc

	-- DENOMINATOR - IDENTIFY MEMBERS WITH MULTIPLE RACES THAT ARE NOT HISPANIC OR LATINO
DROP TABLE IF EXISTS #multiplerace;

SELECT CIN
,COUNT(DISTINCT(ombdesc)) AS Numberrace 
INTO #multiplerace
FROM #MemberEnrollmentEthnicityRace
WHERE 1=1
	AND NOT OMBdesc = 'Hispanic or Latino' -- NO NOT NEGATIVE <> != ...
GROUP BY CIN;

	-- UPDATE FOR MEMBERS WITH MULTIPLE RACES
UPDATE #baselinememiso
SET Race_Two_Or_More_Races = 1
FROM #baselinememiso AS m
	INNER JOIN #multiplerace AS me ON me.CIN = m.CIN
WHERE 1=1
	AND Numberrace >= 2;

	-- UPDATE ETHNICITY COLUMNS 
UPDATE #baselinememiso
SET Ethnicity_Hispanic_Latino = 1
FROM #baselinememiso AS m
	INNER JOIN #MemberEnrollmentEthnicityRace AS me ON me.CIN = m.CIN
WHERE 1=1
	AND me.OMBdesc = 'Hispanic or Latino';

UPDATE #baselinememiso
SET Ethnicity_Not_Hispanic_Latino = 1
FROM #baselinememiso AS m
WHERE 1=1
	AND m.Ethnicity_Hispanic_Latino = 0
    AND m.CIN IN 
	( -- INITIATE ...
        SELECT CIN
        FROM #MemberEnrollmentEthnicityRace
        WHERE 1=1
			AND NOT OMBdesc = 'Hispanic or Latino' -- NO NOT NEGATIVE <> != ...
			); -- CONCLUDE ...

	-- UPDATE RACE COLUMNS, ENSURING NO DOUBLE COUNTING
UPDATE #baselinememiso
SET Race_White = 1
FROM #baselinememiso AS m
	INNER JOIN #MemberEnrollmentEthnicityRace AS me ON me.CIN = m.CIN 
WHERE 1=1
	AND me.OMBdesc = 'White'
    AND m.CIN IN 
	( -- INITIATE ... 
        SELECT CIN
        FROM #multiplerace
        WHERE 1=1
			AND Numberrace = 1
			); -- CONCLUDE ...

UPDATE #baselinememiso
SET Race_Black_Or_African_American = 1
FROM #baselinememiso AS m
	INNER JOIN #MemberEnrollmentEthnicityRace AS me ON me.CIN = m.CIN
WHERE 1=1
	AND me.OMBdesc = 'Black or African American'
    AND m.CIN IN 
	(-- INITIATE ...
	SELECT CIN
	FROM #multiplerace
	WHERE 1=1
		AND Numberrace = 1
		); -- CONCLUDE ...

UPDATE #baselinememiso
SET Race_American_Indian_And_Alaska_Native = 1
FROM #baselinememiso AS m
	INNER JOIN #MemberEnrollmentEthnicityRace AS me ON me.CIN = m.CIN
WHERE 1=1
	AND me.OMBdesc = 'American Indian or Alaska Native'
    AND m.CIN IN 
	( -- INITIATE ...
	SELECT CIN
	FROM #multiplerace
	WHERE 1=1
		AND Numberrace = 1
		); -- CONCLUDE ...

UPDATE #baselinememiso
SET Race_Asian = 1
FROM #baselinememiso AS m
	INNER JOIN #MemberEnrollmentEthnicityRace AS me ON me.CIN = m.CIN
WHERE 1=1
	AND me.OMBdesc = 'Asian'
	AND m.CIN IN 
	( -- INITIATE ...
	SELECT CIN
	FROM #multiplerace
	WHERE 1=1
		AND Numberrace = 1
		); -- CONCLUDE ...

UPDATE #baselinememiso
SET Race_Native_Hawaiian_And_Other_Pacific_Islander = 1
FROM #baselinememiso AS m
	INNER JOIN #MemberEnrollmentEthnicityRace AS me ON me.CIN = m.CIN
WHERE 1=1
	AND me.OMBdesc = 'Native Hawaiian or Other Pacific Islander'
    AND m.CIN IN 
	( -- INITIATE ...
	SELECT CIN
	FROM #multiplerace
	WHERE 1=1
		AND Numberrace = 1
		); -- CONCLUDE ...

UPDATE #baselinememiso
SET Race_Some_Other_Race = 1
FROM #baselinememiso AS m
	INNER JOIN #MemberEnrollmentEthnicityRace AS me ON me.CIN = m.CIN
WHERE 1=1
	AND me.OMBdesc = 'Other'
	AND m.CIN IN 
	( -- INITIATE ...
	SELECT CIN
	FROM #multiplerace
	WHERE 1=1
		AND Numberrace = 1
		); -- CONCLUDE ...

UPDATE #baselinememiso
SET Race_Asked_But_No_Answer_with_Eth_Hispanic = 1
FROM #baselinememiso AS m
	INNER JOIN #MemberEnrollmentEthnicityRace AS me ON me.CIN = m.CIN
WHERE 1=1
	AND me.OMBdesc = 'Hispanic or Latino' -- HISPANIC ETHNICITY TOGGLE
	AND m.Race_White = 0
    AND m.Race_Black_Or_African_American = 0
    AND m.Race_American_Indian_And_Alaska_Native = 0
    AND m.Race_Asian = 0
    AND m.Race_Native_Hawaiian_And_Other_Pacific_Islander = 0
    AND m.Race_Some_Other_Race = 0
    AND m.Race_Two_Or_More_Races = 0
    AND m.Race_Asked_But_No_Answer = 0;
	
UPDATE #baselinememiso
SET Race_Asked_But_No_Answer_with_Eth_Not_Hispanic = 1 -- CATCH - ALL DEFAULT 'Race unknown'
FROM #baselinememiso AS m
WHERE 1=1
	AND m.Race_White = 0
    AND m.Race_Black_Or_African_American = 0
    AND m.Race_American_Indian_And_Alaska_Native = 0
    AND m.Race_Asian = 0
    AND m.Race_Native_Hawaiian_And_Other_Pacific_Islander = 0
    AND m.Race_Some_Other_Race = 0
    AND m.Race_Two_Or_More_Races = 0
    AND m.Race_Asked_But_No_Answer = 0
	AND Race_Asked_But_No_Answer_with_Eth_Hispanic = 0
	AND Race_Asked_But_No_Answer_with_Eth_Not_Hispanic = 0;

UPDATE #baselinememiso
SET Race_Unknown = 1 -- CATCH - ALL DEFAULT 'Race unknown'
FROM #baselinememiso AS m
WHERE 1=1
	AND m.Race_White = 0
	AND m.Race_Black_Or_African_American = 0
	AND m.Race_American_Indian_And_Alaska_Native = 0
	AND m.Race_Asian = 0
	AND m.Race_Native_Hawaiian_And_Other_Pacific_Islander = 0
	AND m.Race_Some_Other_Race = 0
	AND m.Race_Two_Or_More_Races = 0
	AND m.Race_Asked_But_No_Answer = 0
	AND m.Race_Asked_But_No_Answer_with_Eth_Hispanic = 0
	AND m.Race_Asked_But_No_Answer_with_Eth_Not_Hispanic = 0;
	
UPDATE #baselinememiso
SET Ethnicity_Unknown = 1 -- CATCH - ALL DEFAULT 'Ethnicity unknown'
FROM #baselinememiso AS m
WHERE 1=1
	AND m.Ethnicity_Hispanic_Latino = 0
    AND m.Ethnicity_Not_Hispanic_Latino = 0
    AND m.Ethnicity_Asked_But_No_Answer = 0;
	
		-- SELECT * FROM #baselinememiso

	-- CHECK FOR DUP(S) --
SELECT ' ' AS 'SHOULD RETURN 0 ROWS - DUP Validation',*
FROM #baselinememiso
WHERE 1=1
	AND LTRIM(RTRIM(memid)) IN 
	( -- INITIATE ...
	SELECT LTRIM(RTRIM(dup.memid))
	FROM #baselinememiso AS dup
	GROUP BY LTRIM(RTRIM(dup.memid)) --Duplication Driver
	HAVING COUNT(1)>1 --HAVING clause RESERVED for AGGREGATE(s)
	) -- CONCLUDE ...

SELECT 'Community Health Group' AS 'Parent Company Name' -- MS EXCEL ODBC: TEMPLATE
,'#####/D-SNP' AS 'H Contract # '
,'BETWEEN '+CAST(CAST(@ClockStart AS date) AS varchar (25))+' AND '+CAST(CAST(@ClockStop AS date) AS varchar (25)) AS 'Reporting Period' -- 2025Q#?
,'EAE' AS 'EAE or FIDE' 
,COUNT(DISTINCT(bm.memid)) AS 'Member Count '
,SUM(Race_White) AS 'Race_White'
,SUM(bm.Race_Black_Or_African_American) AS 'Race_Black_Or_African_American'
,SUM(bm.Race_American_Indian_And_Alaska_Native) AS 'Race_American_Indian_And_Alaska_Native'
,SUM(bm.Race_Asian) AS 'Race_Asian'
,SUM(bm.Race_Native_Hawaiian_And_Other_Pacific_Islander) AS 'Race_Native_Hawaiian_And_Other_Pacific_Islander'
,SUM(bm.Race_Some_Other_Race) AS 'Race_Some_Other_Race'
,SUM(bm.Race_Two_Or_More_Races) AS 'Race_Two_Or_More_Races'
,SUM(bm.Race_Asked_But_No_Answer) AS 'Race_Asked_But_No_Answer'
,SUM(bm.Race_Asked_But_No_Answer_with_Eth_Hispanic) AS 'Race_Asked_But_No_Answer_with_Eth_Hispanic'
,SUM(bm.Race_Asked_But_No_Answer_with_Eth_Not_Hispanic) AS 'Race_Asked_But_No_Answer_with_Eth_Not_Hispanic'
,SUM(bm.Race_Unknown) AS 'Race_Unknown'
,SUM(bm.Ethnicity_Hispanic_Latino) AS 'Ethnicity_Hispanic_Latino'
,SUM(bm.Ethnicity_Not_Hispanic_Latino) AS 'Ethnicity_Not_Hispanic_Latino'
,SUM(bm.Ethnicity_Asked_But_No_Answer) AS 'Ethnicity_Asked_But_No_Answer'
,SUM(bm.Ethnicity_Unknown) AS 'Ethnicity_Unknown'
INTO INFORMATICS.dbo.CHPIV_TEMPLATE_PALLIATIVE
FROM #baselinememiso AS bm

 		SELECT ' ' AS 'MS EXCEL OLE DB OBDC (TEMPLATE): ',pall.* 
		FROM INFORMATICS.dbo.CHPIV_TEMPLATE_PALLIATIVE (NOLOCK) AS pall
		
		/* SELECT ' ' AS 'MS EXCEL OLE DB OBDC (CLAIMS): ',bm.*
		,pall.* 
		,[diag descr]
		FROM INFORMATICS.dbo.CHPIV_QA_PALLIATIVE_CLAIM (NOLOCK) AS pall
				LEFT JOIN INFORMATICS.dbo.uvw_BASELINE_MEMBERSHIP (NOLOCK) AS bm ON pall.memid = bm.memid

		SELECT ' ' AS 'MS EXCEL OLE DB OBDC (AUTH): ',bm.*
		,pall.* 
		FROM INFORMATICS.dbo.CHPIV_QA_PALLIATIVE_AUTH (NOLOCK) AS pall
				LEFT JOIN INFORMATICS.dbo.uvw_BASELINE_MEMBERSHIP (NOLOCK) AS bm ON pall.memid = bm.memid */
