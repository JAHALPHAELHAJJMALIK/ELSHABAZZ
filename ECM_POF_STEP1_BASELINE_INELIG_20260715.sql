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

SET @ClockStart = TRY_CONVERT(date,GETDATE()) -- ECM / CS ... CALAIM GO LIVE @2022
SET @ClockStop = TRY_CONVERT(date,GETDATE())
SET @IPPdt = TRY_CONVERT(date,GETDATE())
SET @EnrolledMonths = 36

		SELECT 'BETWEEN '+CAST(CAST(@ClockStart AS date) AS varchar (25))+' AND '+CAST(CAST(@ClockStop AS date) AS varchar (25)) AS [RANGE NOTE(s)] -- LEVERAGE: SELECT * FROM INFORMATICS.dbo.[uvw_ECM_ENROLLED] AND "uvw_ECM_ELIGIBLE_ECM_ENROLLED_TheValue_COUNTs.jpg"

/* Young Lady, may I confirm a truism?: 
 
A given member AS mUST be ECM Eligible before they can be ECM Enrolled ...
... AND A member should NOT be ECM Enrolled without being ECM Eligible. 
 
This is the case for a good 85% or so of our members. The caveat to this is for those Member not yet identified as ECM eligible by CHG, but are identified by our community as eligible. */

-- =====================================================================
	-- QA | MEETING EXPECTATION(S)?: 
-- =====================================================================
DECLARE @ineligmemeber AS nvarchar(255) = '743166' -- [HealthPlanID]: 1978343927

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

SELECT DISTINCT 'MS KATHRYN [ProviderPortal] ECM ENROLLED'
,mi.* 
FROM providerportal.ecm.MembersInformation  AS mi
WHERE 1=1
	AND mi.Isecm = 1 
	AND mi.enrollmentstatus = 'enrolled'

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







--------------------------------------------------------------------------------------------------------------------
	-- Error Trapping: Check If Permanent Table(s) Already Exist(s) And Drop If Applicable --
--------------------------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS INFORMATICS.dbo.BASELINE_QNXT_ProviderPortal_ECM_ENROLLED;

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
INTO INFORMATICS.dbo.BASELINE_QNXT_ProviderPortal_ECM_ENROLLED
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st',
FROM HMOPROD_PlanData.dbo.memberattribute AS ma (NOLOCK)
	INNER JOIN HMOPROD_PlanData.dbo.qattribute AS qa (NOLOCK) ON qa.attributeid = ma.attributeid
	INNER JOIN HMOPROD_PLANDATA.dbo.member AS sme (NOLOCK) ON ma.memid = sme.memid
	INNER JOIN ProviderPortal.ECM.MembersInformation (NOLOCK) AS mi ON ma.memid = mi.MemberId -- C001: 'MS KATHRYN [ProviderPortal] ECM ENROLLED' AS OF 20260715
WHERE 1=1 
	AND qa.description = 'ECM Enrolled'
	AND LTRIM(RTRIM(ISNULL(ma.TheValue,''))) LIKE '%Y%'		
	AND TRY_CONVERT(date,ISNULL(ma.termdate,GETDATE())) >= TRY_CONVERT(date,@ClockStart) -- WITHIN reporting period [RANGE] OPPOSITION
	AND TRY_CONVERT(date,ma.effdate) <= TRY_CONVERT(date,@ClockStop) -- WITHIN reporting period [RANGE] OPPOSITION 
	AND TRY_CONVERT(date,ISNULL(ma.termdate,GETDATE())) >= TRY_CONVERT(date,ma.effdate) -- MUST BE TRUE ... NON-CROSSFOOTED RECORDS ARE ACTIVE ...
	AND mi.Isecm = 1 -- C001: 'MS KATHRYN [ProviderPortal] ECM ENROLLED' AS OF 20260715
	AND mi.enrollmentstatus = 'enrolled' -- C001: 'MS KATHRYN [ProviderPortal] ECM ENROLLED' AS OF 20260715
	
	-- CHECK FOR DUP(S):
SELECT ' ' AS 'SHOULD RETURN 0 ROWS - DUP Validation',*
FROM INFORMATICS.dbo.BASELINE_QNXT_ProviderPortal_ECM_ENROLLED
WHERE 1=1
	AND TRY_CONVERT(nvarchar(255),[memid])+TRY_CONVERT(nvarchar(255),[EnrollEffDate]) IN
	( -- INITIATE ...
	SELECT TRY_CONVERT(nvarchar(255),[memid])+TRY_CONVERT(nvarchar(255),[EnrollEffDate])
	FROM INFORMATICS.dbo.BASELINE_QNXT_ProviderPortal_ECM_ENROLLED AS dup
	WHERE 1=1
		AND ROWNUMBER_Enrolled = 1
	GROUP BY TRY_CONVERT(nvarchar(255),[memid])+TRY_CONVERT(nvarchar(255),[EnrollEffDate]) -- Duplication Driver 
	HAVING COUNT(1)>1 -- HAVING clause RESERVED for AGGREGATE(s) ... HAVING SUM(PAID_NET_AMT) != 0
	) -- CONCLUDE ...

		SELECT COUNT(DISTINCT(ecm.memid)) AS 'BASELINE ECM Enrolled MEMBERSHIP' 
		FROM INFORMATICS.dbo.BASELINE_QNXT_ProviderPortal_ECM_ENROLLED AS ecm

		SELECT * 
		FROM INFORMATICS.dbo.BASELINE_QNXT_ProviderPortal_ECM_ENROLLED
		WHERE 1=1
			AND ROWNUMBER_Enrolled = 1
