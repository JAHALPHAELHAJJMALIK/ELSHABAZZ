-- =====================================================================
	-- #BASELINE ECM  (ENHANCED CARE MNGMNT) ENROLLED --
-- =====================================================================
-- =====================================================================
	--  MODIFICATION(S) | CHANGE.LOG:
-- =====================================================================
-- C001: 'MS KATHRYN [ProviderPortal] ECM ENROLLED' AS OF 20260715

-- =====================================================================
	-- DECLARE @PARAMETER(S) / @FILTER(S) --
-- =====================================================================
DECLARE @ClockStart AS datetime
DECLARE @ClockStop AS datetime
DECLARE @IPPdt AS datetime
DECLARE @EnrolledMonths AS decimal(9,0)

SET @ClockStart = TRY_CONVERT(date,'01/01/2022') -- ECM / CS ... CALAIM GO LIVE @2022
SET @ClockStop = TRY_CONVERT(date,GETDATE())
SET @IPPdt = TRY_CONVERT(date,GETDATE())
SET @EnrolledMonths = 36

		SELECT 'BETWEEN '+CAST(CAST(@ClockStart AS date) AS varchar (25))+' AND '+CAST(CAST(@ClockStop AS date) AS varchar (25)) AS [RANGE NOTE(s)] -- LEVERAGE: SELECT * FROM INFORMATICS.dbo.[uvw_ECM_ENROLLED] AND "uvw_ECM_ELIGIBLE_ECM_ENROLLED_TheValue_COUNTs.jpg"

/* Young Lady, may I confirm a truism?: 
 
A given member AS mUST be ECM Eligible before they can be ECM Enrolled ...
... AND A member should NOT be ECM Enrolled without being ECM Eligible. 
 
This is the case for a good 85% or so of our members. The caveat to this is for those Member not yet identified as ECM eligible by CHG, but are identified by our community as eligible. */

		SELECT ' ' AS 'ECM ELIG / ENROLLED MEMBER SAMPLE: '
		,ma.*
		,qa.*
		,bm.*
		FROM HMOPROD_PlanData.dbo.memberattribute AS ma (NOLOCK)
			INNER JOIN HMOPROD_PlanData.dbo.qattribute AS qa (NOLOCK) ON qa.attributeid = ma.attributeid
			INNER JOIN INFORMATICS.dbo.uvw_BASELINE_MEMBERSHIP AS bm ON ma.memid = bm.memid
		WHERE 1=1 
			AND qa.description LIKE '%ECM%'
			AND TRY_CONVERT(date,ISNULL(ma.termdate,GETDATE())) >= TRY_CONVERT(date,ma.effdate) -- MUST BE TRUE ... NON-CROSSFOOTED RECORDS ARE ACTIVE ...	
			AND LTRIM(RTRIM(ISNULL(ma.TheValue,''))) LIKE '%Y%'
			AND (bm.memid IN ('1006077')
				OR bm.CIN IN ('99999168G'))







---------------------------------------------------------------------------------------------------------------------------------
	-- Error Trapping: Check If Permanent Table(s) Already Exist(s) AND Drop If Applicable --
----------------------------------------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS #NewlyECMEnrolled

SELECT ' ' AS 'NEWLY ECM ENROLLED: '
,ma.memid 
,MIN(CONVERT(VARCHAR(10),ma.effdate,101)) AS [1stEnrolled]
INTO #NewlyECMEnrolled
FROM HMOPROD_PlanData.dbo.memberattribute AS ma (NOLOCK)
	INNER JOIN HMOPROD_PlanData.dbo.qattribute AS qa (NOLOCK) ON qa.attributeid = ma.attributeid
WHERE 1=1 
	AND qa.description = 'ECM Enrolled'
	AND TRY_CONVERT(date,ISNULL(ma.termdate,GETDATE())) >= TRY_CONVERT(date,ma.effdate) -- MUST BE TRUE ... NON-CROSSFOOTED RECORDS ARE ACTIVE ...	
	AND LTRIM(RTRIM(ISNULL(ma.TheValue,''))) LIKE '%Y%'
GROUP BY ma.memid

		SELECT TOP 1 * FROM #NewlyECMEnrolled
		
		-- SAMPLE DEPLOYMENT OF NEWLY ECM ENROLLED:
/* SELECT ... 
FROM #NewlyECMEnrolled AS nee  -- C005: PER DISCUSSION WITH MS CLAUDI VIA TEAMS ON 20240514 ONLY INCLUDE NEWLY Enrolled DURING THE REPORTING PERIOD ... Enter the number of unique Members (not reported in any previous quarter) identified and determined as Enrolled for ECM during the reporting period
	INNER JOIN #ECMEnrolled# AS ECM ON nee.memid = ECM.memid
	INNER JOIN ProviderPortal.ECM.Member ECM_M ON ECM.memid = ECM_M.memberid
	INNER JOIN ProviderPortal.ECM.MemberProviderAssigment ECMMP ON ECMMP.MemberId = ECM_M.MemberId
	INNER JOIN #ECMOutreach# AS ECMO ON ECMO.memid = ECM.memid
WHERE 1=1 
	AND ECM_M.ProgramId IN ('QMXBP0782')
	AND ecm_m.IsECM = '1'
	AND nee.[1stEnrolled] BETWEEN TRY_CONVERT(date,@ClockStart) AND TRY_CONVERT(date,@ClockStop) */			
		
IF OBJECT_ID ('tempdb.dbo.#AttributeEnrolledRow#') IS NOT NULL DROP TABLE #AttributeEnrolledRow#
IF OBJECT_ID ('tempdb.dbo.#AttributeEnrolledRow1#') IS NOT NULL DROP TABLE #AttributeEnrolledRow1#
IF OBJECT_ID ('tempdb.dbo.#AttributeEnrolledRow2#') IS NOT NULL DROP TABLE #AttributeEnrolledRow2#
IF OBJECT_ID ('tempdb.dbo.#ECMEnrolled# ') IS NOT NULL DROP TABLE #ECMEnrolled#

	/* ECM Enrolled Attribute */
SELECT DISTINCT TRY_CONVERT(date,ma.createdate) AS [DOE (Date of Entry)]
,ma.memid
,TRY_CONVERT(decimal(4,1),(DATEDIFF("dd",TRY_CONVERT(date,sme.dob),TRY_CONVERT(date,@ClockStop))/365.25)) AS 'MEMBER_AGE'
,TRY_CONVERT(int,(DATEDIFF("dd",TRY_CONVERT(date,sme.dob),TRY_CONVERT(date,@ClockStop))/365.25)) AS 'MEMBER_TRUE_CHRONOLOGICAL_AGE'
,DATEDIFF("mm",TRY_CONVERT(date,sme.dob),TRY_CONVERT(date,@ClockStop))-(TRY_CONVERT(int,(DATEDIFF("dd",TRY_CONVERT(date,sme.dob),TRY_CONVERT(date,@ClockStop))/365.25))*12) AS 'MEMBER_TRUE_CHRONOLOGICAL_AGE_AND_HOW_MANY_MTHs'
,ma.attributeid AS AttributeID
,qa.description AS AttributeName
,LTRIM(RTRIM(ISNULL(ma.TheValue,''))) AS 'AttributeValue'
,CONVERT(VARCHAR(10),ma.effdate,101) AS EnrollEffDate
,CONVERT(VARCHAR(10),ma.termdate,101) AS EnrollTermDate
,ROW_NUMBER() OVER(PARTITION BY ma.memid ORDER BY CONVERT(DATE,ma.termdate) DESC,CONVERT(date,ma.effdate) ASC) AS ROWNUMBER_Enrolled
INTO #AttributeEnrolledRow#
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st',
FROM HMOPROD_PlanData.dbo.memberattribute AS ma (NOLOCK)
	INNER JOIN HMOPROD_PlanData.dbo.qattribute AS qa (NOLOCK) ON qa.attributeid = ma.attributeid
	INNER JOIN HMOPROD_PLANDATA.dbo.member AS sme (NOLOCK) ON ma.memid = sme.memid	
	INNER JOIN ProviderPortal.ECM.MembersInformation (NOLOCK) AS mi ON ma.memid = mi.MemberId -- C001: 'MS KATHRYN [ProviderPortal] ECM ENROLLED' AS OF 20260715 AS OF 20260715
WHERE 1=1 
	AND qa.description = 'ECM Enrolled'
	AND LTRIM(RTRIM(ISNULL(ma.TheValue,''))) LIKE '%Y%'		
	-- AND TRY_CONVERT(date,ma.effdate) BETWEEN @ClockStart AND @ClockStop -- SPECIFIC TO MEMBERS INITIALLY / NEWLY EFFECTIVE ... during the reporting period
	-- AND TRY_CONVERT(date,ma.effdate) <= @IPPdt -- [Point IN time] AS of 6/30/2023  (this should be adjusted if the reporting period is different) SPECIFIC DATE 
	-- AND TRY_CONVERT(date,ISNULL(ma.termdate,GETDATE())) >= @IPPdt -- [Point IN time] AS of 6/30/2023  (this should be adjusted if the reporting period is different) SPECIFIC DATE 
	AND TRY_CONVERT(date,ISNULL(ma.termdate,GETDATE())) >= TRY_CONVERT(date,@ClockStart) -- WITHIN reporting period [RANGE] OPPOSITION
	AND TRY_CONVERT(date,ma.effdate) <= TRY_CONVERT(date,@ClockStop) -- WITHIN reporting period [RANGE] OPPOSITION 
	AND TRY_CONVERT(date,ISNULL(ma.termdate,GETDATE())) >= TRY_CONVERT(date,ma.effdate) -- MUST BE TRUE ... NON-CROSSFOOTED RECORDS ARE ACTIVE ...	
	AND mi.Isecm = 1 -- C001: 'MS KATHRYN [ProviderPortal] ECM ENROLLED' AS OF 20260715
	AND mi.enrollmentstatus = 'enrolled' -- C001: 'MS KATHRYN [ProviderPortal] ECM ENROLLED' AS OF 20260715

	-- Verification count:
SELECT COUNT(*) AS baseline_record_count FROM #AttributeEnrolledRow#
SELECT DISTINCT * INTO #AttributeEnrolledRow1# FROM #AttributeEnrolledRow# where ROWNUMBER_Enrolled= 1
SELECT DISTINCT * INTO #AttributeEnrolledRow2# FROM #AttributeEnrolledRow# where ROWNUMBER_Enrolled = 2

SELECT DISTINCT a1.memid,a1.AttributeID,a1.AttributeName,a1.AttributeValue
,CASE 
WHEN (CONVERT(DATE,a1.EnrollEffDate) = CONVERT(DATE,a2.EnrollTermDate) 
	AND a1.EnrollTermDate > a2.EnrollTermDate) 
THEN a1.EnrollEffDate 
WHEN CONVERT(DATE,a1.EnrollEffDate) BETWEEN CONVERT(DATE,a2.EnrollEffDate) 
	AND CONVERT(DATE,a2.EnrollTermDate) 
THEN a2.EnrollEffDate 
ELSE a1.EnrollEffDate 
END AS EnrollEffDate
,CASE 
WHEN (CONVERT(DATE,a1.EnrollEffDate) = CONVERT(DATE,a2.EnrollTermDate) 
	AND a1.EnrollTermDate > a2.EnrollTermDate) 
THEN a1.EnrollTermDate
WHEN CONVERT(DATE,a1.EnrollEffDate) BETWEEN CONVERT(DATE,a2.EnrollEffDate) 
	AND CONVERT(DATE,a2.EnrollTermDate) 
THEN a2.EnrollTermDate 
ELSE a1.EnrollTermDate 
END AS EnrollTermDate
,a1.[MEMBER_TRUE_CHRONOLOGICAL_AGE]
INTO #ECMEnrolled# 
FROM #AttributeEnrolledRow1# AS a1
	LEFT JOIN #AttributeEnrolledRow2# AS a2 ON a2.memid = a1.memid
	LEFT JOIN ProviderPortal.ECM.Member AS m ON m.MemberId = a1.memid
		AND m.ISECM = 1

	-- CHECK FOR DUP(S):
SELECT ' ' AS 'SHOULD RETURN 0 ROWS - DUP Validation',*
FROM #ECMEnrolled#
WHERE 1=1
	AND TRY_CONVERT(nvarchar(255),[memid])+TRY_CONVERT(nvarchar(255),[EnrollEffDate]) IN
	( -- INITIATE ...
	SELECT TRY_CONVERT(nvarchar(255),[memid])+TRY_CONVERT(nvarchar(255),[EnrollEffDate])
	FROM #ECMEnrolled# AS dup
	GROUP BY TRY_CONVERT(nvarchar(255),[memid])+TRY_CONVERT(nvarchar(255),[EnrollEffDate]) -- Duplication Driver 
	HAVING COUNT(1)>1 -- HAVING clause RESERVED for AGGREGATE(s) ... HAVING SUM(PAID_NET_AMT) != 0
	) -- CONCLUDE ...

		SELECT COUNT(DISTINCT(ecm.memid)) AS 'BASELINE ECM Enrolled MEMBERSHIP' FROM #ECMEnrolled# AS ecm

		-- SELECT ' ' AS 'ECM Enrolled 3 TO 20',COUNT(DISTINCT(ecm.memid)) AS [BASELINE ECM Enrolled MEMBERSHIP] FROM #ECMEnrolled# AS ecm WHERE 1=1 AND ecm.MEMBER_TRUE_CHRONOLOGICAL_AGE BETWEEN 3 AND 20
		-- SELECT ' ' AS 'ECM Enrolled CHILD',COUNT(DISTINCT(ecm.memid)) AS [BASELINE ECM Enrolled MEMBERSHIP] FROM #ECMEnrolled# AS ecm WHERE 1=1 AND ecm.MEMBER_TRUE_CHRONOLOGICAL_AGE < 21
		-- SELECT ' ' AS 'ECM Enrolled OVER 21',COUNT(DISTINCT(ecm.memid)) AS [BASELINE ECM Enrolled MEMBERSHIP] FROM #ECMEnrolled# AS ecm WHERE 1=1 AND ecm.MEMBER_TRUE_CHRONOLOGICAL_AGE >= 21		

		SELECT 'ENR' AS 'INDICATOR',memid
		,MIN(EnrollEffDate) AS [EffDate]
		,MAX(TRY_CONVERT(date,ISNULL(EnrollTermDate,'12/31/2078'))) AS [TermDate]
		FROM #ECMEnrolled#
		GROUP BY memid		
		
		SELECT ' ' AS '#BASELINE ECM Enrolled SAMPLE',* 
		,DATEDIFF("m",TRY_CONVERT(date,EnrollEffDate),CASE
		WHEN TRY_CONVERT(date,ISNULL(EnrollTermDate,GETDATE())) >= TRY_CONVERT(date,GETDATE())
		THEN TRY_CONVERT(date,@ClockStop)
		ELSE TRY_CONVERT(date,ISNULL(EnrollTermDate,GETDATE()))
		END)+1 AS [Months Enrolled IN ECM]
		FROM #ECMEnrolled#
		WHERE 1=1
			AND memid IN ('2049786','2075502')

		SELECT ' ' AS 'CONTINUOUSLY ENROLLED ...',memid
		FROM 
		( -- INITIATE ...
		SELECT ' ' AS '#BASELINE ECM Enrolled SAMPLE',* 
		,DATEDIFF("m",TRY_CONVERT(date,EnrollEffDate),CASE
		WHEN TRY_CONVERT(date,ISNULL(EnrollTermDate,GETDATE())) >= TRY_CONVERT(date,GETDATE())
		THEN TRY_CONVERT(date,@ClockStop)
		ELSE TRY_CONVERT(date,ISNULL(EnrollTermDate,GETDATE()))
		END)+1 AS [Months Enrolled IN ECM]
		FROM #ECMEnrolled#
		WHERE 1=1
		) -- CONCLUDE ...
		AS ecme
		WHERE 1=1
		GROUP BY memid
		HAVING SUM([Months Enrolled IN ECM]) >= @EnrolledMonths
