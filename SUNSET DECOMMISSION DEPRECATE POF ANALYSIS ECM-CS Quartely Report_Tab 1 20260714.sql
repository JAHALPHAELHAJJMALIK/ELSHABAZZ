-- =====================================================================
	-- COMMENT(S) / CHANGE.LOG: --
-- =====================================================================
/* Tab 1. ECM Members and Services	
		•	For columns I - T, mark all applicable Populations of Focus 	that are known to the MCP to apply to the member, based ON the Populations of Focus 	that are eligible for ECM IN the county during the reporting period. */

-- C001: START WITH() ECMELIG PER WEEKLY ECM TEAMS MEETING + MS CLAUDIA GUIDANCE ON 20240418

-- C002: [TargetPopulation] ⏎ IN the 20240418 script, the POF assessment is updated to use the [ProviderPortal].ecm.[StratificationTargetPopulation] table instead, AS per the guidance FROM the ECM weekly teams meeting ON 20240418.
 
 -- C003: IN ('1063122323','1083764724','1447281936','1134144165','1205254950','1245246917','1295822658','1356889539','1366807760','1376229872','1427696616','1528271186','1073177739','1609920305','1619393584','1639614688','1649809526','1669711297','1689798985','1710439559','1760477467','1790718351','1891408043','1922642909','1598703647','1679158125','1952364747','1962483040','1982756086','1275972333','1255496105','1912688656','1134838352','1710336094','1710065933','1679357685','1922790906','1699043000','1255738423') -- C00#: UPDATE ECM National Provider Identifier (NPI) Number per "MOC Excel File ECM Provider Capacity Template 2023 Mapping 4.25.2024 20240503.xlsx"
 
 -- C004: PER MEETING VIA TEAMS ON 20240509 WITH() MS KATHRYN + SIR JUAN BOTH TABLES ([MemberTargetPopulation] AND + & [StratificationTargetPopulation]) SHOULD BE USED TO DETERMINE ECM MEMBER [TargetPopulation] 
		
		/* LEFT JOIN ProviderPortal.ecm.MemberTargetPopulation ECM_MT ON ECM_MT.MemberId = ECM.memid
		LEFT JOIN ProviderPortal.ecm.StratificationTargetPopulation AS ECM_MT ON ECM.memid = ECM_MT.MemberId */

-- C005: DEFAULT VALUES FOR MISSING VALUES WITHIN ECM / CS QUARTERLY REPORT WHEN [DiscontuationReason] ISNULL per ECM Weekly TEAM MEETING ON 20240808 ... ISNULL(ECM.DHCSReason,'DESIRED DEFAULT REASON?')

		/* USE 7 FOR DSNP / CSNP TO MCAL MEMBERSHIP OR VICE VERSA
		USE 8 FOR TERMED MEMBER(S)
		USE 15 AS FINAL CATCH - ALL */
		
		/* CASE 
		WHEN ECMD.DisenrollmentDate > @ClockStop
		THEN Null
			WHEN ECMD.Code IN ('WM') THEN '1'
			WHEN ECMD.code IN ('DP') THEN '3'
			WHEN ECMD.code IN ('ERR','EXP','UE') THEN '4'
			WHEN ECMD.code IN ('NE','OH','UBE','CAP') THEN '5'
			WHEN ECMD.code like 'N/A' THEN '2'
			ELSE '15' -- C005: DEFAULT VALUES FOR MISSING VALUES WITHIN ECM / CS QUARTERLY REPORT WHEN [DiscontuationReason] ISNULL per ECM Weekly TEAM MEETING ON 20240808 ... ISNULL(ECM.DHCSReason,'DESIRED DEFAULT REASON?')
		END AS 'DHCSReason' */

		/* CASE 
		WHEN ECM.Enrolltermdate = '12/31/2078' 
		THEN NULL
		-- WHEN ECM.EnrollTermDate > @ClockStop
		-- THEN NULL
		WHEN TRY_CONVERT(date,ECM.EnrollTermDate) BETWEEN @ClockStart AND @ClockStop
		THEN ECM.DHCSReason
		ELSE 15 -- C005: DEFAULT VALUES FOR MISSING VALUES WITHIN ECM / CS QUARTERLY REPORT WHEN [DiscontuationReason] ISNULL per ECM Weekly TEAM MEETING ON 20240808 ... ISNULL(ECM.DHCSReason,'DESIRED DEFAULT REASON?')
		END AS 'ECM Discontinuation Reason'  */

-- =====================================================================
	-- DECLARE @PARAMETER(S) / @FILTER(S) --
-- =====================================================================
DECLARE @leadlag AS decimal(9,0)
DECLARE @leadlagmonths AS int
DECLARE @ClockStart AS datetime
DECLARE @ClockStop AS datetime
DECLARE @IPPdt AS datetime
DECLARE @gapallowance AS int

SET @leadlag = -4 -- +- LEAD() LAG() IN ...
SET @leadlagmonths = 3 -- +- LEAD() LAG() IN MONTH(S)
SET @ClockStart = DATEADD(MONTH,@leadlag,DATEADD(DAY,1,EOMONTH(GETDATE(),-1))) -- AS [1st of ... MONTH]
SET @ClockStop = DATEADD(day,-1,DATEADD(MONTH,@leadlagmonths,@ClockStart))
SET @IPPdt = TRY_CONVERT(date,GETDATE())
SET @gapallowance = 14

		SELECT 'BETWEEN '+CAST(CAST(@ClockStart AS date) AS varchar (25))+' AND '+CAST(CAST(@ClockStop AS date) AS varchar (25)) AS [RANGE NOTE(s)]
		,TRY_CONVERT(varchar(4),DATEPART(yyyy,@ClockStart))+' Q'+TRY_CONVERT(varchar(2),DATEPART(q,@ClockStart)) AS [Reporting Period]
		






--------------------------------------------------------------------------------------------------------------------
	-- Error Trapping: Check If Permanent Table(s) Already Exist(s) And Drop If Applicable --
--------------------------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS #MemberStratificationTargetPopulation  -- C004: PER MEETING VIA TEAMS ON 20240509 WITH([MemberTargetPopulation] AND + & [StratificationTargetPopulation]) MS KATHRYN + SIR JUAN BOTH TABLES () SHOULD BE USED TO DETERMINE ECM MEMBER [TargetPopulation] 

		/* SELECT memid,* 
		FROM HMOPROD_PlanData.dbo.member
		WHERE secondaryid IN ('99898657G','99998889E') */

SELECT mstp.*
INTO #MemberStratificationTargetPopulation
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM 
( -- INITIATE ...
SELECT DISTINCT MemberId,TargetPopulation
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM ProviderPortal.ecm.MemberTargetPopulation 

UNION 
SELECT DISTINCT MemberId,TargetPopulation
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM ProviderPortal.ecm.StratificationTargetPopulation
)
AS mstp
WHERE 1=1
	-- AND MemberId IN ('2461612','957943') -- SAMPLE 

--------------------------------------------------------------------------------------------------------------------
	-- Error Trapping: Check If Permanent Table(s) Already Exist(s) And Drop If Applicable --
--------------------------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS INFORMATICS.dbo.ECMQTRLY_TAB1; -- SQL Server 2016 and later -- DYNAMIC tmp OR STATIC [TABLE] #INFORMATICS.dbo.ECMQTRLY_TAB1 is a local temporary table visible only IN the current session; ##INFORMATICS.dbo.ECMQTRLY_TAB1 is a GLOBAL temporary table visible to all sessions IN ('TempDB')

IF OBJECT_ID ('tempdb.dbo.#AttributeEnrolledRow#') IS NOT NULL DROP TABLE #AttributeEnrolledRow#
IF OBJECT_ID ('tempdb.dbo.#AttributeEnrolledRow1#') IS NOT NULL DROP TABLE #AttributeEnrolledRow1#
IF OBJECT_ID ('tempdb.dbo.#AttributeEnrolledRow2#') IS NOT NULL DROP TABLE #AttributeEnrolledRow2#
IF OBJECT_ID ('tempdb.dbo.#ECMEnrolled# ') IS NOT NULL DROP TABLE #ECMEnrolled# 
if object_id ('tempdb.dbo.#ECMPopulation#') is not null drop table #ECMPopulation#
if object_id ('tempdb.dbo.#ECMPre#') is not null drop table #ECMPre#
if object_id ('tempdb.dbo.#ECMAdultTargetPopulation#') is not null drop table #ECMAdultTargetPopulation#
if object_id ('tempdb.dbo.#ECMChildTargetPopulation#') is not null drop table #ECMChildTargetPopulation#
if object_id ('tempdb.dbo.#ECMAdultServices#') is not null drop table #ECMAdultServices#
if object_id ('tempdb.dbo.#ECMChildServices#') is not null drop table #ECMChildServices#
if object_id ('tempdb.dbo.#ECMAdultandPeds# ') is not null drop table #ECMAdultandPeds#
if object_id ('tempdb.dbo.#ECMFinal# ') is not null drop table #ECMFinal#
if object_id ('tempdb.dbo.#ECMAdultandPeds# ') is not null drop table #ECMAdultandPeds#
if object_id ('tempdb.dbo.#ECMMemberOutreach# ') is not null drop table #ECMMemberOutreach#

		/* ECM Enrolled Attribute */
SELECT DISTINCT TRY_CONVERT(date,ma.createdate) AS [DOE (Date of Entry)],ma.memid
,ma.attributeid AS AttributeID
,qa.description AS AttributeName
,ma.thevalue AS AttributeValue
,CONVERT(VARCHAR(10),ma.effdate,101) AS EnrollEffDate
,CONVERT(VARCHAR(10),ma.termdate,101) AS EnrollTermDate
,ROW_NUMBER() OVER(PARTITION BY ma.memid ORDER BY CONVERT(DATE,ma.termdate) DESC, CONVERT(date,ma.effdate) ASC) AS ROWNUMBER_Enrolled
INTO #AttributeEnrolledRow#
FROM HMOPROD_PlanData.dbo.memberattribute AS ma (NOLOCK)
	INNER JOIN HMOPROD_PlanData.dbo.qattribute AS qa (NOLOCK) ON qa.attributeid = ma.attributeid
WHERE 1=1 
	AND qa.description = 'ECM Enrolled'
	AND TRY_CONVERT(date,ISNULL(ma.termdate,GETDATE())) >= TRY_CONVERT(date,@ClockStart) -- WITHIN reporting period [RANGE] OPPOSITION
	AND TRY_CONVERT(date,ma.effdate) <= TRY_CONVERT(date,@ClockStop) -- WITHIN reporting period [RANGE] OPPOSITION 
	AND TRY_CONVERT(date,ISNULL(ma.termdate,GETDATE())) >= TRY_CONVERT(date,ma.effdate) -- MUST BE TRUE ... NON-CROSSFOOTED RECORDS ARE ACTIVE ...	
	AND LTRIM(RTRIM(ISNULL(ma.TheValue,''))) LIKE '%Y%'

		-- Verification count:
SELECT COUNT(*) AS baseline_record_count FROM #AttributeEnrolledRow#
SELECT DISTINCT * INTO #AttributeEnrolledRow1# FROM #AttributeEnrolledRow# where ROWNUMBER_Enrolled= 1
SELECT DISTINCT * INTO #AttributeEnrolledRow2# FROM #AttributeEnrolledRow# where ROWNUMBER_Enrolled = 2

SELECT DISTINCT a1.memid,a1.AttributeID,a1.AttributeName,a1.AttributeValue
,CASE 
WHEN (CONVERT(DATE,a1.EnrollEffDate) = CONVERT(DATE,a2.EnrollTermDate) AND a1.EnrollTermDate > a2.EnrollTermDate) THEN a1.EnrollEffDate 
WHEN CONVERT(DATE,a1.EnrollEffDate) between CONVERT(DATE,a2.EnrollEffDate) AND CONVERT(DATE,a2.EnrollTermDate) THEN a2.EnrollEffDate 
ELSE a1.EnrollEffDate 
END AS EnrollEffDate
,CASE 
WHEN (CONVERT(DATE,a1.EnrollEffDate) = CONVERT(DATE,a2.EnrollTermDate) AND a1.EnrollTermDate > a2.EnrollTermDate) THEN a1.EnrollTermDate
WHEN CONVERT(DATE,a1.EnrollEffDate) between CONVERT(DATE,a2.EnrollEffDate) AND CONVERT(DATE,a2.EnrollTermDate) THEN a2.EnrollTermDate 
ELSE a1.EnrollTermDate 
END AS EnrollTermDate
-- ,m.MemberId
INTO #ECMEnrolled# 
FROM #AttributeEnrolledRow1# AS a1
	LEFT JOIN #AttributeEnrolledRow2# AS a2 ON a2.memid = a1.memid
	LEFT JOIN ProviderPortal.ECM.Member AS m ON m.MemberId = a1.memid
		AND m.ISECM = 1

		SELECT COUNT(DISTINCT(ecm.memid)) AS 'BASELINE ECM Enrolled MEMBERSHIP' FROM #ECMEnrolled# AS ecm
		SELECT TOP 10 ' ' AS '#BASELINE ECM Enrolled',* FROM #ECMEnrolled#







		/* ECM Enrolled Attribute with Provider Portal ECM member AS module JOIN */
SELECT DISTINCT 'Community Health Group Partnership Plan' AS 'Plan Name',
'29' AS 'Plan Code',
'San Diego' AS 'County',
TRY_CONVERT(varchar(4),DATEPART(yyyy,@ClockStart))+' Q'+TRY_CONVERT(varchar(2),DATEPART(q,@ClockStart)) AS [Reporting Period], --'2023 Q3'as 'Reporting Period
ECM.memid,
ECM_M.SecondaryId AS 'Member CIN',
e.lastname AS 'Member Last Name',
e.firstname AS 'Member First Name',
CONVERT(varchar(10), CAST(m.dob AS date), 101) AS 'Member Date of Birth',
DATEDIFF( yy, m.dob, getdate() ) -
	CASE
	WHEN DATEADD( yy, DATEDIFF( yy, m.dob, getdate() ), m.dob ) > getdate() 
	THEN 1
	ELSE 0
END AS MemberAge,
CASE WHEN (DATEDIFF( yy, m.dob, getdate() ) -
	CASE
	WHEN DATEADD( yy, DATEDIFF( yy, m.dob, getdate() ), m.dob ) > getdate() 
	THEN 1
	ELSE 0
	END 
) >= 21
THEN 'Adult' ELSE 'Child' 
End AS AdultorChild,
ECM.EnrollEffDate AS 'ECM Benefit Start Date',
ECM.enrolltermdate,
ECM_M.IsExternal,
ECM_M.WasHHP,
ECM_M.WasWPW
INTO #ECMPopulation#
FROM  #ECMEnrolled# AS ECM
	INNER JOIN ProviderPortal.ECM.Member ECM_M ON ECM.memid = ECM_M.memberid
	INNER JOIN HMOPROD_PlanData.dbo.member AS m (NOLOCK) ON m.memid = ECM_M.MemberId
	INNER JOIN ProviderPortal.ecm.MemberProviderAssigment AS ECM_P ON ECM_P.MemberId = ECM.memid
		LEFT JOIN HMOPROD_PlanData.dbo.entity e ON e.entid = m.entityid
WHERE 1=1 
	AND ECM_M.ProgramId IN ('QMXBP0782')
	AND ECM_M.IsECM = 1
ORDER BY ECM.memid

/*ECM Enrolled Members IN ECM module with who are receiving ECM Pediatric (CHILD) Services */
SELECT DISTINCT ECM.*,
ECM_MT.TargetPopulation
INTO #ECMChildTargetPopulation#
FROM #ECMPopulation# ECM
		-- LEFT JOIN ProviderPortal.ecm.MemberTargetPopulation ECM_MT ON ECM_MT.MemberId = ECM.memid
		-- LEFT JOIN ProviderPortal.ecm.StratificationTargetPopulation AS ECM_MT ON ECM.memid = ECM_MT.MemberId  -- C002: [TargetPopulation] ? IN the 20240418 script, the POF assessment is updated to use the [ProviderPortal].ecm.[StratificationTargetPopulation] table instead, AS per the guidance FROM the ECM weekly teams meeting ON 20240418.
		LEFT JOIN #MemberStratificationTargetPopulation AS ECM_MT ON ECM.memid = ECM_MT.MemberId  -- C004: PER MEETING VIA TEAMS ON 20240509 WITH([MemberTargetPopulation] AND + & [StratificationTargetPopulation]) MS KATHRYN + SIR JUAN BOTH TABLES () SHOULD BE USED TO DETERMINE ECM MEMBER [TargetPopulation] 
WHERE 1=1  
	AND ECM.MemberAge <= '20'
ORDER BY ECM.memid







SELECT DISTINCT ECM.[Plan Name], ECM.[Plan Code], ECM.County, ECM.[Reporting Period], ECM.memid,
ECM.[Member CIN], ECM.[Member Last Name], ECM.[Member First Name], ECM.[Member Date of Birth],
ECM.MemberAge, ECM.AdultorChild,
CASE 
WHEN ecm.memid IN (SELECT DISTINCT memid 
FROM #ECMChildTargetPopulation# WHERE TargetPopulation LIKE '%Child%Fam%Home%')
THEN '1' 
ELSE '0'
END AS 'Child – Families Experiencing Homelessness', -- FAMILY 1ST FIRST 
CASE 
WHEN ecm.memid IN (SELECT DISTINCT memid 
FROM #ECMChildTargetPopulation# WHERE TargetPopulation LIKE '%Child%Indiv%Home%' OR TargetPopulation LIKE '%Homeless%') -- HOMELESSNESS CATCH - ALL
THEN '1' 
ELSE '0'
END AS 'Child – Individuals Experiencing Homelessness', 
CASE WHEN ecm.memid IN (SELECT DISTINCT memid 
FROM #ECMChildTargetPopulation# WHERE TargetPopulation IN ('High Utilizers - Child',
'Child IP ED High Utilization','Adult IP ED High Utilization','Adult Avoidable Hospital or ED Utilization','Child Avoidable Hospital or ED Utilization'))
THEN '1' ELSE '0'
END AS 'Child – Avoidable Hospital or ED Utilization',
CASE WHEN ecm.memid IN (SELECT DISTINCT memid 
	FROM #ECMChildTargetPopulation# WHERE TargetPopulation IN ('Child MH SMI SUD','Child I/DD','Serious Mental Illness / Substance Use DisORDER - Adult','Adult I/DD','Adult MH SMI SUD','Adult SMH or SUD','Child SMH or SUD')) -- PER eMAIL FROM MS claudia ON 20231105 '2.	Request to rollup the ID/DD previous PoF INTO the SMI/SUD PoFs'
	THEN '1' ELSE '0'
END AS 'Child – SMI or SUD', 
CASE WHEN ecm.memid IN (SELECT DISTINCT memid 
	FROM #ECMChildTargetPopulation# WHERE TargetPopulation IN ('Children with Complex Needs',
	'Child CCS','Child CCS/CCS WCM with Additional Needs'))
	THEN '1' ELSE '0'
END AS 'Child – CCS/CCS WCM with Additional Needs',
CASE WHEN ecm.memid IN (SELECT DISTINCT memid 
	FROM #ECMChildTargetPopulation# WHERE TargetPopulation IN ('Child Welfare'))
	THEN '1' ELSE '0'
END AS 'Child – Child Welfare',
CASE WHEN ecm.memid IN (SELECT DISTINCT memid 
	FROM #ECMChildTargetPopulation# WHERE TargetPopulation IN ('Incarcerated and Transitioning to Community',
	'Individuals Transitioning FROM Incarceration', 'Child Incarceration','Child Transitioning FROM Incarceration','Adult Transitioning FROM Incarceration'))
	THEN '1' ELSE '0'
END AS 'Child – Transitioning FROM Incarceration',
CASE 
WHEN ecm.memid IN (SELECT DISTINCT memid
FROM #ECMChildTargetPopulation# 
WHERE 1=1 
	AND TargetPopulation IN ('Child Pregnancy Postpartum')
		OR TargetPopulation LIKE '%Birth%Equity%')
THEN '1' 
ELSE '0'
END AS 'Child - Birth Equity',
CONVERT(varchar(10), CAST(ECM.[ECM Benefit Start Date] AS date), 101) AS 'ECM Benefit Start Date',
CASE 
WHEN ECM.EnrollTermDate >= @ClockStop 
THEN Null else
CONVERT(varchar(10), CAST(ECM.EnrollTermDate AS date), 101) 
END AS 'ECM Benefit End Date',
ECM.IsExternal,
ECM.WasHHP,
ECM.WasWPW
INTO #ECMChildServices#
FROM #ECMChildTargetPopulation# AS ECM







		/*ECM Enrolled Members IN ECM module with who are receiving ECM ADULT services */
SELECT DISTINCT ECM.*,
ECM_MT.TargetPopulation
INTO #ECMAdultTargetPopulation#
FROM #ECMPopulation# ECM
		-- LEFT JOIN ProviderPortal.ecm.MemberTargetPopulation ECM_MT ON ECM_MT.MemberId = ECM.memid
		-- LEFT JOIN ProviderPortal.ecm.StratificationTargetPopulation AS ECM_MT ON ECM.memid = ECM_MT.MemberId  -- C002: [TargetPopulation] ? IN the 20240418 script, the POF assessment is updated to use the [ProviderPortal].ecm.[StratificationTargetPopulation] table instead, AS per the guidance FROM the ECM weekly teams meeting ON 20240418.
		LEFT JOIN #MemberStratificationTargetPopulation AS ECM_MT ON ECM.memid = ECM_MT.MemberId  -- C004: PER MEETING VIA TEAMS ON 20240509 WITH([MemberTargetPopulation] AND + & [StratificationTargetPopulation]) MS KATHRYN + SIR JUAN BOTH TABLES () SHOULD BE USED TO DETERMINE ECM MEMBER [TargetPopulation] 
WHERE 1=1 
	AND ECM.MemberAge >= '21'







SELECT DISTINCT ECM.[Plan Name], ECM.[Plan Code], ECM.County, ECM.[Reporting Period], ECM.memid,
ECM.[Member CIN], ECM.[Member Last Name], ECM.[Member First Name], ECM.[Member Date of Birth],
ECM.MemberAge, ECM.AdultorChild,
CASE 
WHEN ecm.memid IN (SELECT DISTINCT memid 
FROM #ECMAdultTargetPopulation# WHERE TargetPopulation LIKE '%Adult%Fam%Home%')
THEN '1' 
ELSE '0'
END AS 'Adult – Families Experiencing Homelessness', -- FAMILY 1ST FIRST 
CASE 
WHEN ecm.memid IN (SELECT DISTINCT memid 
FROM #ECMAdultTargetPopulation# WHERE TargetPopulation LIKE '%Adult%Indiv%Home%'  OR TargetPopulation LIKE '%Homeless%') -- HOMELESSNESS CATCH - ALL
THEN '1' 
ELSE '0'
END AS 'Adult – Individuals Experiencing Homelessness',
CASE WHEN ecm.memid IN (SELECT DISTINCT memid 
	FROM #ECMAdultTargetPopulation# WHERE TargetPopulation IN ('Adult IP ED High Utilization',
	'High Utilizers - Adult','Child IP ED High Utilization','Adult Avoidable Hospital or ED Utilization','Child Avoidable Hospital or ED Utilization'))
	THEN '1' ELSE '0'
END AS 'Adult – Avoidable Hospital or ED Utilization',
CASE WHEN ecm.memid IN (SELECT DISTINCT memid 
	FROM #ECMAdultTargetPopulation# WHERE TargetPopulation IN ('Adult MH SMI SUD','Child MH SMI SUD',
	'Serious Mental Illness / Substance Use DisORDER - Adult','Adult I/DD','Child I/DD','Adult SMH or SUD','Child SMH or SUD')) -- PER eMAIL FROM MS claudia ON 20231105 '2.	Request to rollup the ID/DD previous PoF INTO the SMI/SUD PoFs'
	THEN '1' ELSE '0'
END AS 'Adult – SMI or SUD',
CASE WHEN ecm.memid IN (SELECT DISTINCT memid 
	FROM #ECMAdultTargetPopulation# WHERE TargetPopulation IN ('Adult Incarceration',
	'Incarcerated and Transitioning to Community', 'Individuals Transitioning FROM Incarceration','Adult Transitioning FROM Incarceration','Child Transitioning FROM Incarceration'))
	THEN '1' ELSE '0'
END AS 'Adult – Transitioning FROM Incarceration',
CASE WHEN ecm.memid IN (SELECT DISTINCT memid 
	FROM #ECMAdultTargetPopulation# WHERE TargetPopulation IN ('At Risk for Institutionalization - Adult',
	'Adult Institutionalization','Child Institutionalization','Adult At Risk for LTC Institutionalization'))
	THEN '1' ELSE '0'
END AS 'Adult – LTC At-Risk for Institutionalization',
CASE WHEN ecm.memid IN (SELECT DISTINCT memid 
	FROM #ECMAdultTargetPopulation# WHERE TargetPopulation IN ('Adult Nursing Transition',
	'Nursing Facility Residents - Adult','Adult NF Transitioning to Community'))
	THEN '1' ELSE '0'
END AS 'Adult – NF Transitioning to Community',
CASE 
WHEN ecm.memid IN (SELECT DISTINCT memid
FROM #ECMAdultTargetPopulation# 
WHERE 1=1 
	AND TargetPopulation IN ('Adult Pregnancy Postpartum')
		OR TargetPopulation LIKE '%Birth%Equity%')
THEN '1' 
ELSE '0'
END AS 'Adult - Birth Equity', -- REFINEMENT per eMAIL ON 20231105 FROM MS CLAUDIA BODY:3.	Update to the Birth Equity PoF logic (previously known AS Pregnant and postpartum) (Does not go live until 1/1/24) a.	Added focus ON African American women to logic 

ECM.[ECM Benefit Start Date],
ECM.EnrollTermDate,
ECM.IsExternal,
ECM.WasHHP,
ECM.WasWPW
INTO #ECMAdultServices#
FROM #ECMAdultTargetPopulation# ECM
ORDER BY ECM.memid

SELECT DISTINCT ECM.*,
ECMA.[Adult – Individuals Experiencing Homelessness],
ECMA.[Adult – Families Experiencing Homelessness],
ECMA.[Adult – Avoidable Hospital or ED Utilization],
ECMA.[Adult – SMI or SUD],
ECMA.[Adult – Transitioning FROM Incarceration],
ECMA.[Adult – LTC At-Risk for Institutionalization],
ECMA.[Adult – NF Transitioning to Community],
ECMA.[Adult - Birth Equity],
ECMP.[Child – Individuals Experiencing Homelessness],
ECMP.[Child – Families Experiencing Homelessness],
ECMP.[Child – Avoidable Hospital or ED Utilization],
ECMP.[Child – SMI or SUD],
ECMP.[Child – CCS/CCS WCM with Additional Needs],
ECMP.[Child – Child Welfare],
ECMP.[Child – Transitioning FROM Incarceration],
ECMP.[Child - Birth Equity]
INTO #ECMAdultandPeds#
FROM #ECMPopulation# AS ECM
		LEFT JOIN #ECMAdultServices# ECMA ON ECMA.memid = ECM.memid
		LEFT JOIN #ECMChildServices# ECMP ON ECMP.memid = ECM.memid







		/*ECM Enrolled Members receiving adult and peds services with disenrollment date and reason */
SELECT DISTINCT ECM.*,
CASE WHEN ECMD.DisenrollmentDate > @ClockStop --END of the current reporting period
THEN Null else
	CONVERT(varchar(10), CAST(ECMD.Disenrollmentdate AS date), 101) 
END AS 'ECM Benefit End Date_1',
CASE WHEN ECMD.DisenrollmentDate > @ClockStop --END of the current reporting period
THEN Null else
	ECMD.Code
END AS 'Code',
CASE 
WHEN ECMD.DisenrollmentDate > @ClockStop
THEN Null
	WHEN ECMD.Code IN ('WM') THEN '1'
	WHEN ECMD.code IN ('DP') THEN '3'
	WHEN ECMD.code IN ('ERR','EXP','UE') THEN '4'
	WHEN ECMD.code IN ('NE','OH','UBE','CAP') THEN '5'
	WHEN ECMD.code like 'N/A' THEN '2'
	ELSE '15' -- C005: DEFAULT VALUES FOR MISSING VALUES WITHIN ECM / CS QUARTERLY REPORT WHEN [DiscontuationReason] ISNULL per ECM Weekly TEAM MEETING ON 20240808 ... ISNULL(ECM.DHCSReason,'DESIRED DEFAULT REASON?')
END AS 'DHCSReason'
INTO #ECMFinal#
FROM #ECMAdultandPeds# AS ECM
		LEFT JOIN ProviderPortal.ecm.MemberDisenrollment ECMD ON ECMD.MemberId = ECM.memid
		LEFT JOIN ProviderPortal.ecm.DisenrollmentReasons ECMDR ON ECMDR.DHCSCode = ECMD.Code






		/*ECM Enrolled Members receiving adult and peds services with disenrollment date + reason and ECM provider NPI*/
SELECT DISTINCT ECM.[Plan Name], ECM.[Plan Code], ECM.County, ECM.[Reporting Period], 
ECM.[Member CIN],ECM.memid,
ECM.[Member Last Name], ECM.[Member First Name],
ECM.[Member Date of Birth], 
CASE WHEN ECM.[Adult – Individuals Experiencing Homelessness] is null THEN '0'
ELSE ECM.[Adult – Individuals Experiencing Homelessness]
END AS [Adult – Individuals Experiencing Homelessness],
CASE WHEN ECM.[Adult – Families Experiencing Homelessness] is null THEN '0'
ELSE ECM.[Adult – Families Experiencing Homelessness]
END AS [Adult – Families Experiencing Homelessness],
CASE WHEN ECM.[Adult – Avoidable Hospital or ED Utilization] is null THEN '0'
ELSE ECM.[Adult – Avoidable Hospital or ED Utilization]
END AS [Adult – Avoidable Hospital or ED Utilization], 
CASE WHEN ECM.[Adult – SMI or SUD] is null THEN '0'
ELSE ECM.[Adult – SMI or SUD]
END AS [Adult – SMI or SUD], 
CASE WHEN ECM.[Adult – Transitioning FROM Incarceration] is null THEN '0'
ELSE ECM.[Adult – Transitioning FROM Incarceration]
END AS [Adult – Transitioning FROM Incarceration],
CASE WHEN ECM.[Adult – LTC At-Risk for Institutionalization] is null THEN '0'
ELSE ECM.[Adult – LTC At-Risk for Institutionalization]
END AS [Adult – LTC At-Risk for Institutionalization], 
CASE WHEN ECM.[Adult – NF Transitioning to Community] is null THEN '0'
ELSE ECM.[Adult – NF Transitioning to Community]
END AS [Adult – NF Transitioning to Community],
CASE WHEN ECM.[Adult - Birth Equity] is null THEN '0'
ELSE ECM.[Adult - Birth Equity] 
END AS [Adult - Birth Equity],
CASE WHEN ECM.[Child – Individuals Experiencing Homelessness] is null THEN '0'
ELSE ECM.[Child – Individuals Experiencing Homelessness]
END AS [Child – Individuals Experiencing Homelessness], 
CASE WHEN ECM.[Child – Families Experiencing Homelessness] is null THEN '0'
ELSE ECM.[Child – Families Experiencing Homelessness]
END AS [Child – Families Experiencing Homelessness], 
CASE WHEN ECM.[Child – Avoidable Hospital or ED Utilization] is null THEN '0'
ELSE ECM.[Child – Avoidable Hospital or ED Utilization]
END AS [Child – Avoidable Hospital or ED Utilization], 
CASE WHEN ECM.[Child – SMI or SUD] is null THEN '0'
ELSE ECM.[Child – SMI or SUD]
END AS [Child – SMI or SUD],
CASE WHEN ECM.[Child – CCS/CCS WCM with Additional Needs] is null THEN '0'
ELSE ECM.[Child – CCS/CCS WCM with Additional Needs]
END AS [Child – CCS/CCS WCM with Additional Needs], 
CASE WHEN ECM.[Child – Child Welfare] is null THEN '0'
ELSE ECM.[Child – Child Welfare]
END AS [Child – Child Welfare],  
CASE WHEN ECM.[Child – Transitioning FROM Incarceration] is null THEN '0'
ELSE ECM.[Child – Transitioning FROM Incarceration]
END AS [Child – Transitioning FROM Incarceration],
CASE WHEN ECM.[Child - Birth Equity] is null THEN '0'
ELSE ECM.[Child - Birth Equity]
END AS [Child - Birth Equity],
ECM.[ECM Benefit Start Date],  

CASE WHEN ECM.Enrolltermdate = '12/31/2078' THEN NULL
	WHEN ECM.EnrollTermDate > @ClockStop 
	THEN NULL
	WHEN ECM.[ECM Benefit End Date_1] <= ECM.Enrolltermdate THEN ECM.[ECM Benefit End Date_1]
	ELSE ECM.enrolltermdate
END AS 'ECM Benefit End Date',
-- ECM.[ECM Benefit End Date_1],
-- CASE WHEN ECM.[ECM Benefit Start Date] <= ECM.[ECM Benefit End Date] 
	-- THEN ECM.[ECM Benefit End Date]
-- ELSE null END AS [ECM Benefit End Date], 
CASE 
WHEN ECM.Enrolltermdate = '12/31/2078' 
THEN NULL
WHEN ECM.EnrollTermDate IS NULL
THEN NULL
WHEN TRY_CONVERT(date,ECM.EnrollTermDate) BETWEEN @ClockStart AND @ClockStop
THEN ECM.DHCSReason
ELSE 15 -- C005: DEFAULT VALUES FOR MISSING VALUES WITHIN ECM / CS QUARTERLY REPORT WHEN [DiscontuationReason] ISNULL per ECM Weekly TEAM MEETING ON 20240808 ... ISNULL(ECM.DHCSReason,'DESIRED DEFAULT REASON?')
END AS 'ECM Discontinuation Reason' 
--ECM.[Member’s ECM Provider NPI],
--ECM_Ip.[Number of In-Person ECM Encounters],
--ECM_IP2.[Number of Telephonic or Telehealth ECM Encounters]
INTO #ECMPre#
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM #ECMFinal# AS ECM

UPDATE #ECMPre#
SET [ECM Discontinuation Reason] = TRY_CONVERT(nvarchar(2),NULL)
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM #ECMPre#
WHERE 1=1
	AND [ECM Benefit End Date] IS NULL







;WITH ECM_Prov1 AS
(
SELECT DISTINCT
Memberid
,Providerid
,EffDate
,TermDate
,DENSE_RANK() over (partition BY Memberid ORDER BY TermDate desc) AS RowNbr
-- ,row_number() over (partition BY Memberid ORDER BY TermDate desc) AS RowNbr
FROM [SQLPROD02].[ProviderPortal].[ECM].[MemberProviderAssigment]    
)

SELECT DISTINCT 
ECM.*,
p.npi AS 'Member’s ECM Provider NPI',
ECMMem.Outreachdate,
CASE WHEN ECMMem.OutreachMethodID = '3' THEN 'In-Person'
	WHEN ECMMem.OutreachMethodID = '7' THEN 'In-Person'
	WHEN ECMMem.OutreachMethodID = '1' THEN 'Telehealth'
	WHEN ECMMem.OutreachMethodID = '2' THEN 'Telehealth'
	WHEN ECMMem.OutreachMethodID = '4' THEN 'Telehealth'
	WHEN ECMMem.OutreachMethodID = '5' THEN 'Telehealth'
	WHEN ECMMem.OutreachMethodID = '6' THEN 'Telehealth'
	WHEN ECMMem.OutreachMethodID = '8' THEN 'Telehealth'
	WHEN ECMMem.OutreachMethodID = '9' THEN 'Telehealth'
	WHEN ECMMem.OutreachMethodID = '10' THEN 'Telehealth'
END AS 'Encounters'

INTO #ECMMemberOutreach#

FROM #ECMpre# ECM
LEFT JOIN ECM_Prov1 AS ECMP ON ECMP.MemberId = ECM.memid
JOIN HMOPROD_PlanData.dbo.provider p ON ECMP.Providerid = p.provid
LEFT JOIN ProviderPortal.ECM.MemberOutreach ECMMem ON ECMMem.MemberId = ECM.memid
	AND ECMMem.OutreachDate between @ClockStart AND @ClockStop --Reporting period

WHERE 1=1 
	AND ECMP.RowNbr = 1
ORDER BY memid

SELECT DISTINCT ECM.[Plan Name], ECM.[Plan Code], ECM.County, ECM.[Reporting Period], 
ECM.[Member CIN],
ECM.[Member Last Name], ECM.[Member First Name],
ECM.[Member Date of Birth], 
CASE WHEN ECM.[Adult – Individuals Experiencing Homelessness] is null THEN '0'
ELSE ECM.[Adult – Individuals Experiencing Homelessness]
END AS [Adult – Individuals Experiencing Homelessness],
CASE WHEN ECM.[Adult – Families Experiencing Homelessness] is null THEN '0'
ELSE ECM.[Adult – Families Experiencing Homelessness]
END AS [Adult – Families Experiencing Homelessness],
CASE WHEN ECM.[Adult – Avoidable Hospital or ED Utilization] is null THEN '0'
ELSE ECM.[Adult – Avoidable Hospital or ED Utilization]
END AS [Adult – Avoidable Hospital or ED Utilization], 
CASE WHEN ECM.[Adult – SMI or SUD] is null THEN '0'
ELSE ECM.[Adult – SMI or SUD]
END AS [Adult – SMI or SUD], 
CASE WHEN ECM.[Adult – Transitioning FROM Incarceration] is null THEN '0'
ELSE ECM.[Adult – Transitioning FROM Incarceration]
END AS [Adult – Transitioning FROM Incarceration],
CASE WHEN ECM.[Adult – LTC At-Risk for Institutionalization] is null THEN '0'
ELSE ECM.[Adult – LTC At-Risk for Institutionalization]
END AS [Adult – LTC At-Risk for Institutionalization], 
CASE WHEN ECM.[Adult – NF Transitioning to Community] is null THEN '0'
ELSE ECM.[Adult – NF Transitioning to Community]
END AS [Adult – NF Transitioning to Community],
CASE WHEN ECM.[Adult - Birth Equity] is null THEN '0'
ELSE ECM.[Adult - Birth Equity]
END AS [Adult - Birth Equity],
CASE WHEN ECM.[Child – Individuals Experiencing Homelessness] is null THEN '0'
ELSE ECM.[Child – Individuals Experiencing Homelessness]
END AS [Child – Individuals Experiencing Homelessness], 
CASE WHEN ECM.[Child – Families Experiencing Homelessness] is null THEN '0'
ELSE ECM.[Child – Families Experiencing Homelessness]
END AS [Child – Families Experiencing Homelessness],
CASE WHEN ECM.[Child – Avoidable Hospital or ED Utilization] is null THEN '0'
ELSE ECM.[Child – Avoidable Hospital or ED Utilization]
END AS [Child – Avoidable Hospital or ED Utilization], 
CASE WHEN ECM.[Child – SMI or SUD] is null THEN '0'
ELSE ECM.[Child – SMI or SUD]
END AS [Child – SMI or SUD],
CASE WHEN ECM.[Child – CCS/CCS WCM with Additional Needs] is null THEN '0'
ELSE ECM.[Child – CCS/CCS WCM with Additional Needs]
END AS [Child – CCS/CCS WCM with Additional Needs], 
CASE WHEN ECM.[Child – Child Welfare] is null THEN '0'
ELSE ECM.[Child – Child Welfare]
END AS [Child – Child Welfare], 
CASE WHEN ECM.[Child – Transitioning FROM Incarceration] is null THEN '0'
ELSE ECM.[Child – Transitioning FROM Incarceration]
END AS [Child – Transitioning FROM Incarceration],
CASE WHEN ECM.[Child - Birth Equity] is null THEN '0'
ELSE ECM.[Child - Birth Equity]
END AS [Child - Birth Equity],
ECM.[ECM Benefit Start Date], 
ECM.[ECM Benefit End Date],
ECM.[ECM Discontinuation Reason],
ECM.[Member’s ECM Provider NPI],
ECM_Ip.[Number of In-Person ECM Encounters],
ECM_IP2.[Number of Telephonic or Telehealth ECM Encounters]
INTO INFORMATICS.dbo.ECMQTRLY_TAB1 
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st',
FROM #ECMMemberOutreach# ECM
outer apply (SELECT DISTINCT ECM1.memid, 
			count(DISTINCT(ECM1.outreachdate)) 
			as 'Number of In-Person ECM Encounters'
			FROM #ECMMemberOutreach# ECM1 
			WHERE 1=1 
	AND ECM.memid = ECM1.memid
			and ECM1.Encounters = 'In-Person'

			AND (ECM1.OutreachDate between
			CASE WHEN ECM.[ECM Benefit Start Date] < @ClockStart THEN @ClockStart
			ELSE ECM.[ECM Benefit Start Date] end
			AND 
			CASE WHEN ECM.[ECM Benefit End Date] > @ClockStop THEN @ClockStop
			WHEN ECM.[ECM Benefit End Date] is null THEN @ClockStop
		 	ELSE ECM.[ECM Benefit End Date] end)

			group BY ECM1.memid)ECM_IP
outer apply (SELECT DISTINCT ECM2.memid,  

			count(DISTINCT(ECM2.OutreachDate)) AS 'Number of Telephonic or Telehealth ECM Encounters'

			FROM #ECMMemberOutreach# ECM2

			WHERE 1=1 
				AND ECM2.Encounters = 'Telehealth'

			and ECM.memid = ECM2.memid 
				AND (ECM2.OutreachDate between
			CASE WHEN ECM.[ECM Benefit Start Date] < @ClockStart THEN @ClockStart
			ELSE ECM.[ECM Benefit Start Date] end
			AND 
			CASE WHEN ECM.[ECM Benefit End Date] > @ClockStop THEN @ClockStop
			WHEN ECM.[ECM Benefit End Date] is null THEN @ClockStop
			ELSE ECM.[ECM Benefit End Date] end)
			group BY ECM2.memid) AS ECM_IP2
ORDER BY [Member CIN]

		SELECT ' ' AS 'SAMPLE CODE COALESCE TASK',* 
		FROM INFORMATICS.dbo.ECMQTRLY_TAB1 
		WHERE 1=1
			AND [Member Last Name] LIKE '%BUSLE%' OR [Member Last Name] LIKE '%STEINER%'







-----------------------------------------------------------------------------------------------------------------------------
	--Error Trapping: Check If Permanent Table(s) Already Exist(s) And Drop If Applicable--
-----------------------------------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS #EligibilityAssessment -- SQL Server 2016 and later -- DYNAMIC tmp OR STATIC [TABLE] #TABLENAME is a local temporary table visible only IN the current session; ##TABLENAME is a GLOBAL temporary table visible to all sessions IN ('TempDB')

SELECT CAST(NULL AS nvarchar(255)) AS [Index ECM BenefitID] -- The ORIGINAL / INITIAL Visit + OR Admit
,CAST(NULL AS datetime) AS [Index ECM Benefit Start Date] -- The ORIGINAL / INITIAL Visit + OR Admit
,CAST(NULL AS datetime) AS [Index ECM Benefit End Date] -- The ORIGINAL / INITIAL Visit + OR Admit
,[DoTheMathInDays] = CASE
WHEN TRY_CONVERT(date,[PREVIOUS ECM Benefit Start Date]) = TRY_CONVERT(date,[ECM Benefit Start Date])
THEN 0
ELSE DATEDIFF("d",TRY_CONVERT(date,[PREVIOUS ECM Benefit End Date]),TRY_CONVERT(date,[ECM Benefit Start Date])) 
END
,[DoTheMathInMonths] = CASE
WHEN TRY_CONVERT(date,[PREVIOUS ECM Benefit Start Date]) = TRY_CONVERT(date,[ECM Benefit Start Date])
THEN 0
ELSE DATEDIFF("m",TRY_CONVERT(date,[PREVIOUS ECM Benefit End Date]),TRY_CONVERT(date,[ECM Benefit Start Date])) 
END
,[ENROLLMENT DAY(S)] = TRY_CONVERT(decimal(9,0),0)
,[ENROLLMENT MONTH(S)] = TRY_CONVERT(decimal(9,0),0)
,[CONTINUOUS] = TRY_CONVERT(decimal(9,0),0)
,[CONSECUTIVE] = TRY_CONVERT(decimal(9,0),0)
,dothemath.*
INTO #EligibilityAssessment
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM 
( -- INITIATE...
SELECT ranklag.*
,ISNULL(LAG([ECM Benefit Start Date]) OVER (PARTITION BY [Plan Name],[Member CIN] ORDER BY [RANKis] ASC),[ECM Benefit Start Date]) AS [PREVIOUS ECM Benefit Start Date]
,ISNULL(LEAD([ECM Benefit Start Date]) OVER (PARTITION BY [Plan Name],[Member CIN] ORDER BY [RANKis] ASC),[ECM Benefit Start Date]) AS [NEXT ECM Benefit Start Date]
-- ,ISNULL(LAG([ECM Benefit Start Date]) OVER (PARTITION BY [Plan Name],[Member CIN] ORDER BY [RANKis] DESC),[ECM Benefit Start Date]) AS [NEXT ECM Benefit Start Date]

,ISNULL(LAG(ISNULL([ECM Benefit End Date],TRY_CONVERT(date,GETDATE()))) OVER (PARTITION BY [Plan Name],[Member CIN] ORDER BY [RANKis] ASC),ISNULL([ECM Benefit End Date],TRY_CONVERT(date,GETDATE()))) AS [PREVIOUS ECM Benefit End Date]
,ISNULL(LEAD(ISNULL([ECM Benefit End Date],TRY_CONVERT(date,GETDATE()))) OVER (PARTITION BY [Plan Name],[Member CIN] ORDER BY [RANKis] ASC),ISNULL([ECM Benefit End Date],TRY_CONVERT(date,GETDATE()))) AS [NEXT ECM Benefit End Date]
-- ,ISNULL(LAG(ISNULL([ECM Benefit End Date],TRY_CONVERT(date,GETDATE()))) OVER (PARTITION BY [Plan Name],[Member CIN] ORDER BY [RANKis] DESC),ISNULL([ECM Benefit End Date],TRY_CONVERT(date,GETDATE()))) AS [NEXT ECM Benefit End Date]

-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM 
( -- INITIATE ...
SELECT rankrow.*
,DENSE_RANK() OVER (PARTITION BY [Member CIN],[Plan Name] ORDER BY [Member CIN],[Plan Name],[ECM Benefit Start Date]) AS [RANKis]
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM 
( -- INITIATE ...
SELECT DISTINCT ' ' AS 'NESTED DENSE_RANK() ROW() LAG() LEAD()',[Plan Name],[Member Last Name]+', '+[Member First Name] AS [MEMNM],[Member CIN],[ECM Benefit Start Date],TRY_CONVERT(date,ISNULL([ECM Benefit End Date],'12/31/2078')) AS [ECM Benefit End Date],CAST([Member CIN] AS varchar(255))+CAST(TRY_CONVERT(date,[ECM Benefit Start Date]) AS varchar(10)) AS [ECM BenefitID] -- a.     VISIT / ADMIT / ENCOUNTER: 'Unique person, date of service, and provider = one visit'  OR 'Unique person, date of service, and NDC = one script'
FROM INFORMATICS.dbo.ECMQTRLY_TAB1 AS developsource
WHERE 1=1 
	AND TRY_CONVERT(date,ISNULL([ECM Benefit End Date],'12/31/2078')) >= TRY_CONVERT(date,[ECM Benefit Start Date]) 
) -- CONCLUDE ...
AS rankrow
) -- CONCLUDE ...
AS ranklag
) -- CONCLUDE ...
AS dothemath
WHERE 1=1 
	-- AND
	






-- ======================================================================
	-- INDEX ELIGIBILITY / GAP ALLOWANCE(S) IN [DAY(S)] --
-- ======================================================================
UPDATE #EligibilityAssessment
SET [CONTINUOUS] = 1
,[CONSECUTIVE] = 1
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM #EligibilityAssessment
WHERE 1=1 
	AND [DoTheMathInDays] <= @gapallowance -- GAP ALLOWANCE(S) IN [DAY(S)]
	AND RANKis != 1 -- NO NOT NEGATIVE <> != 

UPDATE #EligibilityAssessment
SET [Index ECM BenefitID] = CAST([ECM BenefitID] AS nvarchar(MAX))
,[Index ECM Benefit Start Date] = TRY_CONVERT(date,[ECM Benefit Start Date])
,[Index ECM Benefit End Date] = TRY_CONVERT(date,[ECM Benefit End Date])
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM #EligibilityAssessment
WHERE 1=1 
	AND [Index ECM BenefitID] IS NULL
	AND RANKis = 1

UPDATE #EligibilityAssessment
SET [Index ECM BenefitID] = CAST([ECM BenefitID] AS nvarchar(MAX))
,[Index ECM Benefit Start Date] = TRY_CONVERT(date,[ECM Benefit Start Date])
,[Index ECM Benefit End Date] = TRY_CONVERT(date,[ECM Benefit End Date])
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM #EligibilityAssessment
WHERE 1=1 
	AND [Index ECM BenefitID] IS NULL
	AND CONSECUTIVE = 0







-- ======================================================================
	-- SQL #PYTHON FOR WHILE LOOP() BREAK / FEEDBACK LOOP() CONDITION(S) -- 
-- ======================================================================
DECLARE @rowCount int;
WHILE (1=1)
BEGIN

		UPDATE #EligibilityAssessment
		SET [Index ECM BenefitID] = c.[Index ECM BenefitID]
		,[Index ECM Benefit Start Date] = c.[Index ECM Benefit Start Date]
		,[Index ECM Benefit End Date] = aa.[ECM Benefit End Date]
		-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
		-- SELECT DISTINCT ' ' AS 'CHECK 1st'
		FROM #EligibilityAssessment AS aa
			INNER JOIN 
			( -- INITIATE ...
			SELECT DISTINCT [Member CIN],[Plan Name],[ECM Benefit Start Date],[ECM Benefit End Date],[PREVIOUS ECM Benefit Start Date],[PREVIOUS ECM Benefit End Date],[Index ECM BenefitID],[Index ECM Benefit Start Date] 
			FROM #EligibilityAssessment 
			WHERE 1=1 
				AND [Index ECM BenefitID] IS NOT NULL
			) -- CONCLUDE ...
			AS c ON aa.[Member CIN] = c.[Member CIN] 
				AND aa.[Plan Name] = c.[Plan Name] 
				AND aa.[PREVIOUS ECM Benefit Start Date] = c.[ECM Benefit Start Date] 
				AND aa.[PREVIOUS ECM Benefit End Date] = c.[ECM Benefit End Date]
			WHERE 1=1 
				AND aa.[Index ECM BenefitID] IS NULL
				AND  aa.CONSECUTIVE = 1

SET @rowCount = @@ROWCOUNT;
IF (@rowCount = 0)
BREAK;
END

UPDATE #EligibilityAssessment
SET [Index ECM Benefit End Date] = idd.[Index ECM Benefit End Date]
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM #EligibilityAssessment AS aa
	INNER JOIN 
	( -- INITIATE ...
	SELECT DISTINCT [Index ECM BenefitID],MAX([Index ECM Benefit End Date]) AS [Index ECM Benefit End Date]
	FROM #EligibilityAssessment 
	WHERE 1=1 
		AND [Index ECM BenefitID] IS NOT NULL
	GROUP BY [Index ECM BenefitID]
	) -- CONCLUDE ...
	AS idd ON aa.[Index ECM BenefitID] = idd.[Index ECM BenefitID]

		SELECT ' ' AS 'PRE - #ASSESSMENT SAMPLE CODE COALESCE TASK',* FROM #EligibilityAssessment WHERE MEMNM LIKE '%BUSLE%' OR MEMNM LIKE '%STEINER%' ORDER BY MEMNM
		SELECT ' ' AS 'PRE - SOURCE SAMPLE CODE COALESCE TASK',* FROM INFORMATICS.dbo.ECMQTRLY_TAB1 WHERE [Member Last Name] LIKE '%BUSLE%' OR [Member Last Name] LIKE '%STEINER%' ORDER BY [Member Last Name]	







-- ======================================================================
	-- THE UNIT(S) ... [DAY(S)] -- 
-- ======================================================================
UPDATE #EligibilityAssessment
SET [Index ECM Benefit End Date] = TRY_CONVERT(date,NULL)
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM #EligibilityAssessment
WHERE 1=1 
	AND TRY_CONVERT(date,[Index ECM Benefit End Date]) = TRY_CONVERT(date,'12/31/2078')

UPDATE #EligibilityAssessment
SET [ECM Benefit End Date] = TRY_CONVERT(date,NULL)
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM #EligibilityAssessment
WHERE 1=1 
	AND TRY_CONVERT(date,[ECM Benefit End Date]) = TRY_CONVERT(date,'12/31/2078')

UPDATE #EligibilityAssessment
SET [ENROLLMENT DAY(S)] = CASE
WHEN DATEDIFF("d",TRY_CONVERT(date,[ECM Benefit Start Date]),TRY_CONVERT(date,ISNULL([ECM Benefit End Date],@ClockStop))) = 0
THEN 1
ELSE DATEDIFF("d",TRY_CONVERT(date,[ECM Benefit Start Date]),TRY_CONVERT(date,ISNULL([ECM Benefit End Date],@ClockStop))) -- ... +1 -- INCLUDE [startdate] / [DOS]
END --"(Day Count = Discharge Date - Admit Date; WHEN Admit Date = Discharge Date THEN Day Count = 1)"
,[ENROLLMENT MONTH(S)] = CASE
WHEN DATEDIFF("m",TRY_CONVERT(date,[ECM Benefit Start Date]),TRY_CONVERT(date,ISNULL([ECM Benefit End Date],@ClockStop))) = 0
THEN 1
ELSE DATEDIFF("m",TRY_CONVERT(date,[ECM Benefit Start Date]),TRY_CONVERT(date,ISNULL([ECM Benefit End Date],@ClockStop))) -- ... +1 -- INCLUDE [startdate] / [DOS]
END --"(Day Count = Discharge Date - Admit Date; WHEN Admit Date = Discharge Date THEN Day Count = 1)"
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM #EligibilityAssessment

SELECT ' ' AS 'SHOULD BE NULL DUP Validation',[ECM BenefitID],*
-- DELETE
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st',
FROM #EligibilityAssessment
WHERE 1=1 
	AND [ECM BenefitID] IN 
	( -- INITIATE ...
	SELECT [ECM BenefitID] AS [DupID]
	FROM #EligibilityAssessment AS dup
	GROUP BY [ECM BenefitID] -- Duplication Driver 
	HAVING COUNT(1)>1 -- HAVING clause RESERVED for AGGREGATE(s) ... HAVING SUM(PAID_NET_AMT) != 0
	) -- CONCLUDE ...

			SELECT ' ' AS 'POST - #ASSESSMENT SAMPLE CODE COALESCE TASK',* FROM #EligibilityAssessment WHERE MEMNM LIKE '%BUSLE%' OR MEMNM LIKE '%STEINER%' OR [Member CIN] IN ('90026726C') ORDER BY MEMNM
			SELECT ' ' AS 'POST - SOURCE SAMPLE CODE COALESCE TASK',* FROM INFORMATICS.dbo.ECMQTRLY_TAB1 WHERE [Member Last Name] LIKE '%BUSLE%' OR [Member Last Name] LIKE '%STEINER%' ORDER BY [Member Last Name]
			SELECT COUNT(1) AS [RECORD COUNT],COUNT(DISTINCT([Member CIN])) AS [UNIQUE MEMBER COUNT] FROM #EligibilityAssessment







-----------------------------------------------------------------------------------------------------------------------------
	--Error Trapping: Check If Permanent Table(s) Already Exist(s) And Drop If Applicable--
-----------------------------------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS INFORMATICS.dbo.FINALECMQTemplate -- SQL Server 2016 and later -- DYNAMIC tmp OR STATIC [TABLE] #TABLENAME is a local temporary table visible only IN the current session; ##TABLENAME is a GLOBAL temporary table visible to all sessions IN ('TempDB')

SELECT DISTINCT ea.[Plan Name],developsource.[Plan Code],developsource.[County],developsource.[Reporting Period],ea.[Member CIN],developsource.[Member Last Name],developsource.[Member First Name],developsource.[Member Date of Birth],developsource.[Adult – Individuals Experiencing Homelessness],developsource.[Adult – Families Experiencing Homelessness],developsource.[Adult – Avoidable Hospital or ED Utilization],developsource.[Adult – SMI or SUD],developsource.[Adult – Transitioning FROM Incarceration],developsource.[Adult – LTC At-Risk for Institutionalization],developsource.[Adult – NF Transitioning to Community],developsource.[Adult - Birth Equity],developsource.[Child – Individuals Experiencing Homelessness],developsource.[Child – Families Experiencing Homelessness],developsource.[Child – Avoidable Hospital or ED Utilization],developsource.[Child – SMI or SUD],developsource.[Child – CCS/CCS WCM with Additional Needs],developsource.[Child – Child Welfare],developsource.[Child – Transitioning FROM Incarceration],developsource.[Child - Birth Equity]
,ea.[Index ECM Benefit Start Date] AS [ECM Benefit Start Date],ea.[Index ECM Benefit End Date] AS [ECM Benefit End Date],developsource.[ECM Discontinuation Reason],developsource.[Member’s ECM Provider NPI],ISNULL(agg.[Number of In-Person ECM Encounters],0) AS [Number of In-Person ECM Encounters],ISNULL(agg.[Number of Telephonic or Telehealth ECM Encounters],0) AS [Number of Telephonic or Telehealth ECM Encounters]
-- ,0 AS [Number of In-Person ECM Encounters],0 AS [Number of Telephonic or Telehealth ECM Encounters]
INTO INFORMATICS.dbo.FINALECMQTemplate
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st',
FROM #EligibilityAssessment AS ea 
	INNER JOIN INFORMATICS.dbo.ECMQTRLY_TAB1 AS developsource ON ea.[Member CIN] = developsource.[Member CIN]
		AND ea.[ECM Benefit Start Date] = developsource.[ECM Benefit Start Date]
		-- AND ISNULL(ea.[ECM Benefit End Date],GETDATE()) = ISNULL(developsource.[ECM Benefit End Date],GETDATE())
		LEFT JOIN 
		( -- INITIATE ...
		SELECT [Member CIN] -- ,[ECM Benefit Start Date]
		,SUM([Number of In-Person ECM Encounters]) AS [Number of In-Person ECM Encounters]
		,SUM([Number of Telephonic or Telehealth ECM Encounters]) AS [Number of Telephonic or Telehealth ECM Encounters]
		FROM INFORMATICS.dbo.ECMQTRLY_TAB1
		GROUP BY [Member CIN] -- ,[ECM Benefit Start Date]
		) -- CONCLUDE ...
		AS agg ON ea.[Member CIN] = agg.[Member CIN]
			-- AND ea.[ECM Benefit Start Date] = agg.[ECM Benefit Start Date]
WHERE 1=1 
	AND ea.RANKis = 1
	-- AND
	-- (ea.MEMNM LIKE '%BUSLE%'
		-- OR ea.MEMNM LIKE '%STEINER%'))

UNION
SELECT DISTINCT ea.[Plan Name],developsource.[Plan Code],developsource.[County],developsource.[Reporting Period],ea.[Member CIN],developsource.[Member Last Name],developsource.[Member First Name],developsource.[Member Date of Birth],developsource.[Adult – Individuals Experiencing Homelessness],developsource.[Adult – Families Experiencing Homelessness],developsource.[Adult – Avoidable Hospital or ED Utilization],developsource.[Adult – SMI or SUD],developsource.[Adult – Transitioning FROM Incarceration],developsource.[Adult – LTC At-Risk for Institutionalization],developsource.[Adult – NF Transitioning to Community],developsource.[Adult - Birth Equity],developsource.[Child – Individuals Experiencing Homelessness],developsource.[Child – Families Experiencing Homelessness],developsource.[Child – Avoidable Hospital or ED Utilization],developsource.[Child – SMI or SUD],developsource.[Child – CCS/CCS WCM with Additional Needs],developsource.[Child – Child Welfare],developsource.[Child – Transitioning FROM Incarceration],developsource.[Child - Birth Equity]
,ea.[Index ECM Benefit Start Date] AS [ECM Benefit Start Date],ea.[Index ECM Benefit End Date] AS [ECM Benefit End Date],developsource.[ECM Discontinuation Reason],developsource.[Member’s ECM Provider NPI],ISNULL(agg.[Number of In-Person ECM Encounters],0) AS [Number of In-Person ECM Encounters],ISNULL(agg.[Number of Telephonic or Telehealth ECM Encounters],0) AS [Number of Telephonic or Telehealth ECM Encounters]
-- ,0 AS [Number of In-Person ECM Encounters],0 AS [Number of Telephonic or Telehealth ECM Encounters]
FROM #EligibilityAssessment AS ea 
	INNER JOIN INFORMATICS.dbo.ECMQTRLY_TAB1 AS developsource ON ea.[Member CIN] = developsource.[Member CIN]
		AND ea.[ECM Benefit Start Date] = developsource.[ECM Benefit Start Date]
		-- AND ISNULL(ea.[ECM Benefit End Date],GETDATE()) = ISNULL(developsource.[ECM Benefit End Date],GETDATE())
		LEFT JOIN 
		( -- INITIATE ...
		SELECT [Member CIN] -- ,[ECM Benefit Start Date]
		,SUM([Number of In-Person ECM Encounters]) AS [Number of In-Person ECM Encounters]
		,SUM([Number of Telephonic or Telehealth ECM Encounters]) AS [Number of Telephonic or Telehealth ECM Encounters]
		FROM INFORMATICS.dbo.ECMQTRLY_TAB1
		GROUP BY [Member CIN] -- ,[ECM Benefit Start Date]
		) -- CONCLUDE ...
		AS agg ON ea.[Member CIN] = agg.[Member CIN]
			-- AND ea.[ECM Benefit Start Date] = agg.[ECM Benefit Start Date]
WHERE 1=1 
	AND ea.RANKis != 1
	AND CONTINUOUS = 0
	--AND
	--( ea.MEMNM LIKE '%BUSLE%'
	--	OR ea.MEMNM LIKE '%STEINER%')

		SELECT ' ' AS 'FINAL TEMPLATE SAMPLE CODE COALESCE TASK',* FROM INFORMATICS.dbo.FINALECMQTemplate WHERE [Member Last Name] LIKE '%BUSLE%' OR [Member Last Name] LIKE '%STEINER%' OR [MEMBER CIN] IN ('90026726C') ORDER BY [Member Last Name]
			
SELECT mo.MemberID,mbr.fullname,COUNT(DISTINCT(OutreachDate)) AS [ECM Encounters],MIN(TRY_CONVERT(date,mo.OutreachDate)) AS [MIN OUTREACH RANGE],MAX(TRY_CONVERT(date,mo.OutreachDate)) AS [MAX OUTREACH RANGE]
,CASE WHEN mo.OutreachMethodID = '3' 
THEN 'In-Person'
WHEN mo.OutreachMethodID = '7' 
THEN 'In-Person'
WHEN mo.OutreachMethodID = '1' 
THEN 'Telehealth'
WHEN mo.OutreachMethodID = '2' 
THEN 'Telehealth'
WHEN mo.OutreachMethodID = '4' 
THEN 'Telehealth'
WHEN mo.OutreachMethodID = '5' 
THEN 'Telehealth'
WHEN mo.OutreachMethodID = '6' 
THEN 'Telehealth'
WHEN mo.OutreachMethodID = '8' 
THEN 'Telehealth'
WHEN mo.OutreachMethodID = '9' 
THEN 'Telehealth'
WHEN mo.OutreachMethodID = '10' 
THEN 'Telehealth'
END AS [EncounterType]
-- SELECT TOP 10 ' ' AS 'CHECK 1st',mbr.fullname,mo.*
-- SELECT DISTINCT ' ' AS 'CHECK 1st',
FROM ProviderPortal.ECM.MemberOutreach AS mo
		LEFT JOIN 
		( -- INITIATE ...
		SELECT DISTINCT mb.memid,mb.ssn,mb.secondaryid,mb.dob,mb.deathdate,SUBSTRING(UPPER(LTRIM(RTRIM(ISNULL(mb.secondaryid,'')))),1,9) AS [CIN],SUBSTRING(LTRIM(RTRIM(ISNULL(ek.carriermemid,''))),1,10) AS [HealthPlanID],mb.fullname
		-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
		-- SELECT DISTINCT ' ' AS 'CHECK 1st'
		FROM HMOPROD_PLANDATA.dbo.member AS mb
			INNER JOIN HMOPROD_PLANDATA.dbo.enrollkeys AS ek ON mb.memid = ek.memid
		WHERE 1=1 
			AND ISNULL(mb.IsSubscriber,'') = 'Y' -- ISO ON SUBSCRIBER ONLY!!!
			-- AND ISNULL(ek.carriermemid,'') != ''
			AND UPPER(LTRIM(RTRIM(ISNULL(ek.segtype,'')))) ='INT'
			AND CAST(ek.termdate AS date) > CAST(ek.effdate AS date)
				) -- CONCLUDE ...
				AS mbr ON mo.MemberId = mbr.memid
WHERE 1=1 
	-- AND TRY_CONVERT(date,mo.OutreachDate) BETWEEN @ClockStart AND @ClockStop
	AND mo.OutreachDate BETWEEN @ClockStart AND @ClockStop
	AND ( -- INITIATE ...
	mo.MemberId IN ('1000651') -- MOSHE, AMEEN
		OR mo.MemberId IN ('1037172')  -- 92484570C	BUSLEY, DANIEL
		OR mo.MemberId IN ('2415647 ')  -- 90230328F STEINER, CHARLES A
		) -- CONCLUDE ...
GROUP BY MemberID,mbr.fullname
,CASE WHEN mo.OutreachMethodID = '3' 
THEN 'In-Person'
WHEN mo.OutreachMethodID = '7' 
THEN 'In-Person'
WHEN mo.OutreachMethodID = '1' 
THEN 'Telehealth'
WHEN mo.OutreachMethodID = '2' 
THEN 'Telehealth'
WHEN mo.OutreachMethodID = '4' 
THEN 'Telehealth'
WHEN mo.OutreachMethodID = '5' 
THEN 'Telehealth'
WHEN mo.OutreachMethodID = '6' 
THEN 'Telehealth'
WHEN mo.OutreachMethodID = '8' 
THEN 'Telehealth'
WHEN mo.OutreachMethodID = '9' 
THEN 'Telehealth'
WHEN mo.OutreachMethodID = '10' 
THEN 'Telehealth'
END

SELECT ' 'AS 'TAB ONE 1 SAMPLE: ',*
FROM
( -- INITIATE ...
SELECT ' ' AS 'RANK FINAL TEMPLATE SAMPLE CODE COALESCE TASK',DENSE_RANK() OVER (PARTITION BY [Member CIN],[ECM Benefit Start Date] ORDER BY [ECM Discontinuation Reason] DESC) AS [RANKis],*
FROM INFORMATICS.dbo.FINALECMQTemplate 
WHERE 1=1 
	-- AND ...
) -- CONCLUDE ...
AS final
WHERE 1=1 
	AND [RANKis] = 1
	AND 
	( -- INITITIATE ...
	[Member Last Name] LIKE '%BUSLE%' 
		OR [Member Last Name] LIKE '%STEINER%' 
		OR [MEMBER CIN] IN ('97585593F') -- COLLINSWORTH	BURGANDY
		) -- CONCLUDE ...
