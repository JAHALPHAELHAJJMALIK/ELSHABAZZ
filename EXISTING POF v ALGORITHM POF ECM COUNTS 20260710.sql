-- =====================================================================
	-- #BASELINE ECM  (ENHANCED CARE MNGMNT) ELIGIBLE --
-- =====================================================================

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

		SELECT 'BETWEEN '+CAST(CAST(@ClockStart AS date) AS varchar (25))+' AND '+CAST(CAST(@ClockStop AS date) AS varchar (25)) AS [RANGE NOTE(s)] -- LEVERAGE: SELECT * FROM INFORMATICS.dbo.[uvw_ECM_ELIGIBLE] AND "uvw_ECM_ELIGIBLE_ECM_ENROLLED_TheValue_COUNTs.jpg"

/* Young Lady, may I confirm a truism?: 
 
A given member AS mUST be ECM Eligible before they can be ECM Enrolled ...
... AND A member should NOT be ECM Enrolled without being ECM Eligible. 
 
This is the case for a good 85% or so of our members. The caveat to this is for those Member not yet identified as ECM eligible by CHG, but are identified by our community as eligible. */

		/* SELECT ' ' AS 'ECM ELIG / ENROLLED MEMBER SAMPLE: '
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
				OR bm.CIN IN ('99999168G')) */







---------------------------------------------------------------------------------------------------------------------------------
	-- Error Trapping: Check If Permanent Table(s) Already Exist(s) AND Drop If Applicable --
----------------------------------------------------------------------------------------------------------------------------------
IF OBJECT_ID ('tempdb.dbo.#AttributeEligibleRow#') IS NOT NULL DROP TABLE #AttributeEligibleRow#
IF OBJECT_ID ('tempdb.dbo.#AttributeEligibleRow1#') IS NOT NULL DROP TABLE #AttributeEligibleRow1#
IF OBJECT_ID ('tempdb.dbo.#AttributeeligibleRow2#') IS NOT NULL DROP TABLE #AttributeEligibleRow2#
IF OBJECT_ID ('tempdb.dbo.#ECMEligible# ') IS NOT NULL DROP TABLE #ECMEligible#

	/* ECM Eligible Attribute */
SELECT DISTINCT TRY_CONVERT(date,ma.createdate) AS [DOE (Date of Entry)]
,ma.memid
,TRY_CONVERT(decimal(4,1),(DATEDIFF("dd",TRY_CONVERT(date,sme.dob),TRY_CONVERT(date,@ClockStop))/365.25)) AS 'MEMBER_AGE'
,TRY_CONVERT(int,(DATEDIFF("dd",TRY_CONVERT(date,sme.dob),TRY_CONVERT(date,@ClockStop))/365.25)) AS 'MEMBER_TRUE_CHRONOLOGICAL_AGE'
,DATEDIFF("mm",TRY_CONVERT(date,sme.dob),TRY_CONVERT(date,@ClockStop))-(TRY_CONVERT(int,(DATEDIFF("dd",TRY_CONVERT(date,sme.dob),TRY_CONVERT(date,@ClockStop))/365.25))*12) AS 'MEMBER_TRUE_CHRONOLOGICAL_AGE_AND_HOW_MANY_MTHs'
,ma.attributeid AS AttributeID
,qa.description AS AttributeName
,LTRIM(RTRIM(ISNULL(ma.TheValue,''))) AS 'AttributeValue'
,CONVERT(VARCHAR(10),ma.effdate,101) AS EligibleEffDate
,CONVERT(VARCHAR(10),ma.termdate,101) AS EligibleTermDate
,ROW_NUMBER() OVER(PARTITION BY ma.memid ORDER BY CONVERT(DATE,ma.termdate) DESC,CONVERT(date,ma.effdate) ASC) AS ROWNUMBER_Eligible
INTO #AttributeEligibleRow#
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st',
FROM HMOPROD_PlanData.dbo.memberattribute AS ma (NOLOCK)
	INNER JOIN HMOPROD_PlanData.dbo.qattribute AS qa (NOLOCK) ON qa.attributeid = ma.attributeid
	INNER JOIN HMOPROD_PLANDATA.dbo.member AS sme (NOLOCK) ON ma.memid = sme.memid
WHERE 1=1 
	AND qa.description = 'ECM Eligible'
	AND LTRIM(RTRIM(ISNULL(ma.TheValue,''))) LIKE '%Y%'
	-- AND TRY_CONVERT(date,ma.effdate) BETWEEN @ClockStart AND @ClockStop -- SPECIFIC TO MEMBERS INITIALLY / NEWLY EFFECTIVE ... eligible IN ECM during the reporting period
	-- AND TRY_CONVERT(date,ma.effdate) <= @IPPdt -- [Point IN time] AS of 6/30/2023  (this should be adjusted if the reporting period is different) SPECIFIC DATE 
	-- AND TRY_CONVERT(date,ISNULL(ma.termdate,GETDATE())) >= @IPPdt -- [Point IN time] AS of 6/30/2023  (this should be adjusted if the reporting period is different) SPECIFIC DATE 
	AND TRY_CONVERT(date,ISNULL(ma.termdate,GETDATE())) >= TRY_CONVERT(date,@ClockStart) -- WITHIN reporting period [RANGE] OPPOSITION
	AND TRY_CONVERT(date,ma.effdate) <= TRY_CONVERT(date,@ClockStop) -- WITHIN reporting period [RANGE] OPPOSITION 
	AND TRY_CONVERT(date,ISNULL(ma.termdate,GETDATE())) >= TRY_CONVERT(date,ma.effdate) -- MUST BE TRUE ... NON-CROSSFOOTED RECORDS ARE ACTIVE ...	

	-- Verification count:
SELECT COUNT(*) AS baseline_record_count FROM #AttributeEligibleRow#
SELECT DISTINCT * INTO #AttributeEligibleRow1# FROM #AttributeEligibleRow# where ROWNUMBER_Eligible= 1
SELECT DISTINCT * INTO #AttributeEligibleRow2# FROM #AttributeEligibleRow# where ROWNUMBER_Eligible = 2

SELECT DISTINCT a1.memid,a1.AttributeID,a1.AttributeName,a1.AttributeValue
,CASE 
WHEN (CONVERT(DATE,a1.EligibleEffDate) = CONVERT(DATE,a2.EligibleTermDate) 
	AND a1.EligibleTermDate > a2.EligibleTermDate) 
THEN a1.EligibleEffDate 
WHEN CONVERT(DATE,a1.EligibleEffDate) BETWEEN CONVERT(DATE,a2.EligibleEffDate) 
	AND CONVERT(DATE,a2.EligibleTermDate) 
THEN a2.EligibleEffDate 
ELSE a1.EligibleEffDate 
END AS EligibleEffDate
,CASE 
WHEN (CONVERT(DATE,a1.EligibleEffDate) = CONVERT(DATE,a2.EligibleTermDate) 
	AND a1.EligibleTermDate > a2.EligibleTermDate) 
THEN a1.EligibleTermDate
WHEN CONVERT(DATE,a1.EligibleEffDate) BETWEEN CONVERT(DATE,a2.EligibleEffDate) 
	AND CONVERT(DATE,a2.EligibleTermDate) 
THEN a2.EligibleTermDate 
ELSE a1.EligibleTermDate 
END AS EligibleTermDate
,a1.[MEMBER_TRUE_CHRONOLOGICAL_AGE]
INTO #ECMEligible# 
FROM #AttributeEligibleRow1# AS a1
		LEFT JOIN #AttributeEligibleRow2# AS a2 ON a2.memid = a1.memid
		LEFT JOIN ProviderPortal.ECM.Member AS m ON m.MemberId = a1.memid
			AND m.ISECM = 1

	-- CHECK FOR DUP(S):
SELECT ' ' AS 'SHOULD RETURN 0 ROWS - DUP Validation',*
FROM #ECMEligible#
WHERE 1=1 
	AND TRY_CONVERT(nvarchar(255),[memid])+TRY_CONVERT(nvarchar(255),[EligibleEffDate]) IN
	( -- INITIATE ...
	SELECT TRY_CONVERT(nvarchar(255),[memid])+TRY_CONVERT(nvarchar(255),[EligibleEffDate])
	FROM #ECMEligible# AS dup
	GROUP BY TRY_CONVERT(nvarchar(255),[memid])+TRY_CONVERT(nvarchar(255),[EligibleEffDate]) -- Duplication Driver 
	HAVING COUNT(1)>1 -- HAVING clause RESERVED for AGGREGATE(s) ... HAVING SUM(PAID_NET_AMT) != 0
	) -- CONCLUDE ...

		SELECT COUNT(DISTINCT(ecm.memid)) AS 'BASELINE ECM Eligible MEMBERSHIP' FROM #ECMEligible# AS ecm

		-- SELECT ' ' AS 'ECM Eligible 3 TO 20',COUNT(DISTINCT(ecm.memid)) AS [BASELINE ECM Eligible MEMBERSHIP] FROM #ECMEligible# AS ecm WHERE 1=1 AND ecm.MEMBER_TRUE_CHRONOLOGICAL_AGE BETWEEN 3 AND 20
		-- SELECT ' ' AS 'ECM Eligible CHILD',COUNT(DISTINCT(ecm.memid)) AS [BASELINE ECM Eligible MEMBERSHIP] FROM #ECMEligible# AS ecm WHERE 1=1 AND ecm.MEMBER_TRUE_CHRONOLOGICAL_AGE < 21
		-- SELECT ' ' AS 'ECM Eligible OVER 21',COUNT(DISTINCT(ecm.memid)) AS [BASELINE ECM Eligible MEMBERSHIP] FROM #ECMEligible# AS ecm WHERE 1=1 AND ecm.MEMBER_TRUE_CHRONOLOGICAL_AGE >= 21
		
SELECT ' ' AS 'ECM Elig Unique member Count BY POF',combined.*
FROM 
( -- INITIATE ...
SELECT [TargetPopulation]
,COUNT(DISTINCT(pof.memid)) AS [Unique Member Count] 
FROM INFORMATICS.dbo.ECMPOF_CHILD_BIRTH_EQUITY AS pof 
	INNER JOIN #ECMEligible# AS ee ON pof.memid = ee.memid 
WHERE 1=1
	AND pof.[RunDate] = ( SELECT MAX( i.[RunDate] ) FROM INFORMATICS.dbo.ECMPOF_CHILD_BIRTH_EQUITY AS i WITH (NOLOCK) )
GROUP BY [TargetPopulation]

UNION ALL 
SELECT [TargetPopulation]
,COUNT(DISTINCT(pof.memid)) AS [Unique Member Count] 
FROM INFORMATICS.dbo.ECMPOF_CHILD_HOMELESS AS pof
	INNER JOIN #ECMEligible# AS ee ON pof.memid = ee.memid
WHERE 1=1
	AND pof.[RunDate] = ( SELECT MAX( i.[RunDate] ) FROM INFORMATICS.dbo.ECMPOF_CHILD_HOMELESS AS i WITH (NOLOCK) )
GROUP BY [TargetPopulation]

UNION ALL 
SELECT [TargetPopulation]
,COUNT(DISTINCT(pof.memid)) AS [Unique Member Count] 
FROM INFORMATICS.dbo.ECMPOF_CHILDWITHFAMILY_HOMELESS AS pof
	INNER JOIN #ECMEligible# AS ee ON pof.memid = ee.memid 
WHERE 1=1
	AND pof.[RunDate] = ( SELECT MAX( i.[RunDate] ) FROM INFORMATICS.dbo.ECMPOF_CHILDWITHFAMILY_HOMELESS AS i WITH (NOLOCK) )
GROUP BY [TargetPopulation]

UNION ALL 
SELECT [TargetPopulation]
,COUNT(DISTINCT(pof.memid)) AS [Unique Member Count] 
FROM INFORMATICS.dbo.ECMPOF_CHILDWITHOUTFAMILY_HOMELESS AS pof
	INNER JOIN #ECMEligible# AS ee ON pof.memid = ee.memid 
WHERE 1=1
	AND pof.[RunDate] = ( SELECT MAX( i.[RunDate] ) FROM INFORMATICS.dbo.ECMPOF_CHILDWITHOUTFAMILY_HOMELESS AS i WITH (NOLOCK) )
GROUP BY [TargetPopulation]

UNION ALL
SELECT [TargetPopulation]
,COUNT(DISTINCT(pof.memid)) AS [Unique Member Count] 
FROM INFORMATICS.dbo.ECMPOF_CHILD_IPSNFED_HIGHUTIL AS pof
	INNER JOIN #ECMEligible# AS ee ON pof.memid = ee.memid 
WHERE 1=1
	AND pof.[RunDate] = ( SELECT MAX( i.[RunDate] ) FROM INFORMATICS.dbo.ECMPOF_CHILD_IPSNFED_HIGHUTIL AS i WITH (NOLOCK) )
GROUP BY [TargetPopulation]

UNION ALL
SELECT [TargetPopulation]
,COUNT(DISTINCT(pof.memid)) AS [Unique Member Count] 
FROM INFORMATICS.dbo.ECMPOF_CHILD_MHSMISUD AS pof
	INNER JOIN #ECMEligible# AS ee ON pof.memid = ee.memid 
WHERE 1=1
	AND pof.[RunDate] = ( SELECT MAX( i.[RunDate] ) FROM INFORMATICS.dbo.ECMPOF_CHILD_MHSMISUD AS i WITH (NOLOCK) )
GROUP BY [TargetPopulation]

UNION ALL 
SELECT [TargetPopulation]
,COUNT(DISTINCT(pof.memid)) AS [Unique Member Count] 
FROM INFORMATICS.dbo.ECMPOF_CHILD_INCARCERATION AS pof
	INNER JOIN #ECMEligible# AS ee ON pof.memid = ee.memid 
WHERE 1=1
	AND pof.[RunDate] = ( SELECT MAX( i.[RunDate] ) FROM INFORMATICS.dbo.ECMPOF_CHILD_INCARCERATION AS i WITH (NOLOCK) )
GROUP BY [TargetPopulation]

UNION ALL 
SELECT [TargetPopulation]
,COUNT(DISTINCT(pof.memid)) AS [Uniqude Member Count] 
FROM INFORMATICS.dbo.ECMPOF_CHILD_CCS AS pof
	INNER JOIN #ECMEligible# AS ee ON pof.memid = ee.memid 
WHERE 1=1
	AND pof.[RunDate] = ( SELECT MAX( i.[RunDate] ) FROM INFORMATICS.dbo.ECMPOF_CHILD_CCS AS i WITH (NOLOCK) )
GROUP BY [TargetPopulation]

UNION ALL 
SELECT [TargetPopulation]
,COUNT(DISTINCT(pof.memid)) AS [Unique Member Count] 
FROM INFORMATICS.dbo.ECMPOF_CHILD_WELFARE AS pof
	INNER JOIN #ECMEligible# AS ee ON pof.memid = ee.memid 
WHERE 1=1
	AND pof.[RunDate] = ( SELECT MAX( i.[RunDate] ) FROM INFORMATICS.dbo.ECMPOF_CHILD_WELFARE AS i WITH (NOLOCK) )
GROUP BY [TargetPopulation]

UNION ALL 
SELECT [TargetPopulation]
,COUNT(DISTINCT(pof.memid)) AS [Unique Member Count] 
FROM INFORMATICS.dbo.ECMPOF_ADULT_BIRTH_EQUITY AS pof
	INNER JOIN #ECMEligible# AS ee ON pof.memid = ee.memid 
WHERE 1=1
	AND pof.[RunDate] = ( SELECT MAX( i.[RunDate] ) FROM INFORMATICS.dbo.ECMPOF_ADULT_BIRTH_EQUITY AS i WITH (NOLOCK) )
GROUP BY [TargetPopulation]

UNION ALL 
SELECT [TargetPopulation]
,COUNT(DISTINCT(pof.memid)) AS [Unique Member Count] 
FROM INFORMATICS.dbo.ECMPOF_ADULT_IPSNFED_HIGHUTIL AS pof
	INNER JOIN #ECMEligible# AS ee ON pof.memid = ee.memid 
WHERE 1=1
	AND pof.[RunDate] = ( SELECT MAX( i.[RunDate] ) FROM INFORMATICS.dbo.ECMPOF_ADULT_IPSNFED_HIGHUTIL AS i WITH (NOLOCK) )
GROUP BY [TargetPopulation]

UNION ALL
SELECT [TargetPopulation]
,COUNT(DISTINCT(pof.memid)) AS [Unique Member Count] 
FROM INFORMATICS.dbo.ECMPOF_ADULT_MHSMISUD AS pof
	INNER JOIN #ECMEligible# AS ee ON pof.memid = ee.memid 
WHERE 1=1
	AND pof.[RunDate] = ( SELECT MAX( i.[RunDate] ) FROM INFORMATICS.dbo.ECMPOF_ADULT_MHSMISUD AS i WITH (NOLOCK) )
GROUP BY [TargetPopulation]

UNION ALL
SELECT [TargetPopulation]
,COUNT(DISTINCT(pof.memid)) AS [Unique Member Count] 
FROM INFORMATICS.dbo.ECMPOF_ADULT_INCARCERATION AS pof
	INNER JOIN #ECMEligible# AS ee ON pof.memid = ee.memid 
WHERE 1=1
	AND pof.[RunDate] = ( SELECT MAX( i.[RunDate] ) FROM INFORMATICS.dbo.ECMPOF_ADULT_INCARCERATION AS i WITH (NOLOCK) )
GROUP BY [TargetPopulation]

UNION ALL 
SELECT [TargetPopulation]
,COUNT(DISTINCT(pof.memid)) AS [Unique Member Count] 
FROM INFORMATICS.dbo.ECMPOF_ADULT_INSTITUTIONALIZATION AS pof
	INNER JOIN #ECMEligible# AS ee ON pof.memid = ee.memid 
WHERE 1=1
	AND pof.[RunDate] = ( SELECT MAX( i.[RunDate] ) FROM INFORMATICS.dbo.ECMPOF_ADULT_INSTITUTIONALIZATION AS i WITH (NOLOCK) )
GROUP BY [TargetPopulation]

UNION ALL 
SELECT [TargetPopulation]
,COUNT(DISTINCT(pof.memid)) AS [Unique Member Count] 
FROM INFORMATICS.dbo.ECMPOF_ADULT_NURSING_TRANSITION AS pof
	INNER JOIN #ECMEligible# AS ee ON pof.memid = ee.memid 
WHERE 1=1
	AND pof.[RunDate] = ( SELECT MAX( i.[RunDate] ) FROM INFORMATICS.dbo.ECMPOF_ADULT_NURSING_TRANSITION AS i WITH (NOLOCK) )
GROUP BY [TargetPopulation]

UNION ALL 
SELECT [TargetPopulation]
,COUNT(DISTINCT(pof.memid)) AS [Unique Member Count] 
FROM INFORMATICS.dbo.ECMPOF_ADULTWITHFAMILY_HOMELESS AS pof
	INNER JOIN #ECMEligible# AS ee ON pof.memid = ee.memid 
WHERE 1=1
	AND pof.[RunDate] = ( SELECT MAX( i.[RunDate] ) FROM INFORMATICS.dbo.ECMPOF_ADULTWITHFAMILY_HOMELESS AS i WITH (NOLOCK) )
GROUP BY [TargetPopulation]

UNION ALL 
SELECT [TargetPopulation]
,COUNT(DISTINCT(pof.memid)) AS [Unique Member Count] 
FROM INFORMATICS.dbo.ECMPOF_ADULTWITHOUTFAMILY_HOMELESS AS pof
	INNER JOIN #ECMEligible# AS ee ON pof.memid = ee.memid 
WHERE 1=1
	AND pof.[RunDate] = ( SELECT MAX( i.[RunDate] ) FROM INFORMATICS.dbo.ECMPOF_ADULTWITHOUTFAMILY_HOMELESS AS i WITH (NOLOCK) )
GROUP BY [TargetPopulation]
) -- CONCLUDE ...
AS combined 







-- =====================================================================
	-- POST CHATGPT ALGORITHM UPDATE: 		
-- =====================================================================	
SELECT ' ' AS 'POST CHATGPT UPDATE: ECM Elig Unique member Count BY POF'
,combined.*
FROM 
( -- INITIATE ...
SELECT [TargetPopulation]
,COUNT(DISTINCT(pof.memid)) AS [POST ChatGPT Updates Unique Member Count] 
FROM INFORMATICS.dbo.CHATGPT_ECMPOF_CHILD_BIRTH_EQUITY AS pof 
	INNER JOIN #ECMEligible# AS ee ON pof.memid = ee.memid 
WHERE 1=1
	AND pof.[RunDate] = ( SELECT MAX( i.[RunDate] ) FROM INFORMATICS.dbo.CHATGPT_ECMPOF_CHILD_BIRTH_EQUITY AS i WITH (NOLOCK) )
GROUP BY [TargetPopulation]

UNION ALL 
SELECT [TargetPopulation]
,COUNT(DISTINCT(pof.memid)) AS [POST ChatGPT Updates Unique Member Count] 
FROM INFORMATICS.dbo.CHATGPT_ECMPOF_CHILDWITHFAMILY_HOMELESS AS pof
	INNER JOIN #ECMEligible# AS ee ON pof.memid = ee.memid 
WHERE 1=1
	AND pof.[RunDate] = ( SELECT MAX( i.[RunDate] ) FROM INFORMATICS.dbo.CHATGPT_ECMPOF_CHILDWITHFAMILY_HOMELESS AS i WITH (NOLOCK) )
GROUP BY [TargetPopulation]

UNION ALL 
SELECT [TargetPopulation]
,COUNT(DISTINCT(pof.memid)) AS [POST ChatGPT Updates Unique Member Count] 
FROM INFORMATICS.dbo.CHATGPT_ECMPOF_CHILDWITHOUTFAMILY_HOMELESS AS pof
	INNER JOIN #ECMEligible# AS ee ON pof.memid = ee.memid 
WHERE 1=1
	AND pof.[RunDate] = ( SELECT MAX( i.[RunDate] ) FROM INFORMATICS.dbo.CHATGPT_ECMPOF_CHILDWITHOUTFAMILY_HOMELESS AS i WITH (NOLOCK) )
GROUP BY [TargetPopulation]

UNION ALL
SELECT [TargetPopulation]
,COUNT(DISTINCT(pof.memid)) AS [POST ChatGPT Updates Unique Member Count] 
FROM INFORMATICS.dbo.CHATGPT_ECMPOF_CHILD_IPSNFED_HIGHUTIL AS pof
	INNER JOIN #ECMEligible# AS ee ON pof.memid = ee.memid 
WHERE 1=1
	AND pof.[RunDate] = ( SELECT MAX( i.[RunDate] ) FROM INFORMATICS.dbo.CHATGPT_ECMPOF_CHILD_IPSNFED_HIGHUTIL AS i WITH (NOLOCK) )
GROUP BY [TargetPopulation]

UNION ALL
SELECT [TargetPopulation]
,COUNT(DISTINCT(pof.memid)) AS [POST ChatGPT Updates Unique Member Count] 
FROM INFORMATICS.dbo.CHATGPT_ECMPOF_CHILD_MHSMISUD AS pof
	INNER JOIN #ECMEligible# AS ee ON pof.memid = ee.memid 
WHERE 1=1
	AND pof.[RunDate] = ( SELECT MAX( i.[RunDate] ) FROM INFORMATICS.dbo.CHATGPT_ECMPOF_CHILD_MHSMISUD AS i WITH (NOLOCK) )
GROUP BY [TargetPopulation]

UNION ALL 
SELECT [TargetPopulation]
,COUNT(DISTINCT(pof.memid)) AS [POST ChatGPT Updates Unique Member Count] 
FROM INFORMATICS.dbo.CHATGPT_ECMPOF_CHILD_INCARCERATION AS pof
	INNER JOIN #ECMEligible# AS ee ON pof.memid = ee.memid 
WHERE 1=1
	AND pof.[RunDate] = ( SELECT MAX( i.[RunDate] ) FROM INFORMATICS.dbo.CHATGPT_ECMPOF_CHILD_INCARCERATION AS i WITH (NOLOCK) )
GROUP BY [TargetPopulation]

UNION ALL 
SELECT [TargetPopulation]
,COUNT(DISTINCT(pof.memid)) AS [Uniqude Member Count] 
FROM INFORMATICS.dbo.CHATGPT_ECMPOF_CHILD_CCS AS pof
	INNER JOIN #ECMEligible# AS ee ON pof.memid = ee.memid 
WHERE 1=1
	AND pof.[RunDate] = ( SELECT MAX( i.[RunDate] ) FROM INFORMATICS.dbo.CHATGPT_ECMPOF_CHILD_CCS AS i WITH (NOLOCK) )
GROUP BY [TargetPopulation]

UNION ALL 
SELECT [TargetPopulation]
,COUNT(DISTINCT(pof.memid)) AS [POST ChatGPT Updates Unique Member Count] 
FROM INFORMATICS.dbo.CHATGPT_ECMPOF_CHILD_WELFARE AS pof
	INNER JOIN #ECMEligible# AS ee ON pof.memid = ee.memid 
WHERE 1=1
	AND pof.[RunDate] = ( SELECT MAX( i.[RunDate] ) FROM INFORMATICS.dbo.CHATGPT_ECMPOF_CHILD_WELFARE AS i WITH (NOLOCK) )
GROUP BY [TargetPopulation]

UNION ALL 
SELECT [TargetPopulation]
,COUNT(DISTINCT(pof.memid)) AS [POST ChatGPT Updates Unique Member Count] 
FROM INFORMATICS.dbo.CHATGPT_ECMPOF_ADULT_BIRTH_EQUITY AS pof
	INNER JOIN #ECMEligible# AS ee ON pof.memid = ee.memid 
WHERE 1=1
	AND pof.[RunDate] = ( SELECT MAX( i.[RunDate] ) FROM INFORMATICS.dbo.CHATGPT_ECMPOF_ADULT_BIRTH_EQUITY AS i WITH (NOLOCK) )
GROUP BY [TargetPopulation]

UNION ALL 
SELECT [TargetPopulation]
,COUNT(DISTINCT(pof.memid)) AS [POST ChatGPT Updates Unique Member Count] 
FROM INFORMATICS.dbo.CHATGPT_ECMPOF_ADULT_IPSNFED_HIGHUTIL AS pof
	INNER JOIN #ECMEligible# AS ee ON pof.memid = ee.memid 
WHERE 1=1
	AND pof.[RunDate] = ( SELECT MAX( i.[RunDate] ) FROM INFORMATICS.dbo.CHATGPT_ECMPOF_ADULT_IPSNFED_HIGHUTIL AS i WITH (NOLOCK) )
GROUP BY [TargetPopulation]

UNION ALL
SELECT [TargetPopulation]
,COUNT(DISTINCT(pof.memid)) AS [POST ChatGPT Updates Unique Member Count] 
FROM INFORMATICS.dbo.CHATGPT_ECMPOF_ADULT_MHSMISUD AS pof
	INNER JOIN #ECMEligible# AS ee ON pof.memid = ee.memid 
WHERE 1=1
	AND pof.[RunDate] = ( SELECT MAX( i.[RunDate] ) FROM INFORMATICS.dbo.CHATGPT_ECMPOF_ADULT_MHSMISUD AS i WITH (NOLOCK) )
GROUP BY [TargetPopulation]

UNION ALL
SELECT [TargetPopulation]
,COUNT(DISTINCT(pof.memid)) AS [POST ChatGPT Updates Unique Member Count] 
FROM INFORMATICS.dbo.CHATGPT_ECMPOF_ADULT_INCARCERATION AS pof
	INNER JOIN #ECMEligible# AS ee ON pof.memid = ee.memid 
WHERE 1=1
	AND pof.[RunDate] = ( SELECT MAX( i.[RunDate] ) FROM INFORMATICS.dbo.CHATGPT_ECMPOF_ADULT_INCARCERATION AS i WITH (NOLOCK) )
GROUP BY [TargetPopulation]

UNION ALL 
SELECT [TargetPopulation]
,COUNT(DISTINCT(pof.memid)) AS [POST ChatGPT Updates Unique Member Count] 
FROM INFORMATICS.dbo.CHATGPT_ECMPOF_ADULT_INSTITUTIONALIZATION AS pof
	INNER JOIN #ECMEligible# AS ee ON pof.memid = ee.memid 
WHERE 1=1
	AND pof.[RunDate] = ( SELECT MAX( i.[RunDate] ) FROM INFORMATICS.dbo.CHATGPT_ECMPOF_ADULT_INSTITUTIONALIZATION AS i WITH (NOLOCK) )
GROUP BY [TargetPopulation]

UNION ALL 
SELECT [TargetPopulation]
,COUNT(DISTINCT(pof.memid)) AS [POST ChatGPT Updates Unique Member Count] 
FROM INFORMATICS.dbo.CHATGPT_ECMPOF_ADULT_NURSING_TRANSITION AS pof
	INNER JOIN #ECMEligible# AS ee ON pof.memid = ee.memid 
WHERE 1=1
	AND pof.[RunDate] = ( SELECT MAX( i.[RunDate] ) FROM INFORMATICS.dbo.CHATGPT_ECMPOF_ADULT_NURSING_TRANSITION AS i WITH (NOLOCK) )
GROUP BY [TargetPopulation]

UNION ALL 
SELECT [TargetPopulation]
,COUNT(DISTINCT(pof.memid)) AS [POST ChatGPT Updates Unique Member Count] 
FROM INFORMATICS.dbo.CHATGPT_ECMPOF_ADULTWITHFAMILY_HOMELESS AS pof
	INNER JOIN #ECMEligible# AS ee ON pof.memid = ee.memid 
WHERE 1=1
	AND pof.[RunDate] = ( SELECT MAX( i.[RunDate] ) FROM INFORMATICS.dbo.CHATGPT_ECMPOF_ADULTWITHFAMILY_HOMELESS AS i WITH (NOLOCK) )
GROUP BY [TargetPopulation]

UNION ALL 
SELECT [TargetPopulation]
,COUNT(DISTINCT(pof.memid)) AS [POST ChatGPT Updates Unique Member Count] 
FROM INFORMATICS.dbo.CHATGPT_ECMPOF_ADULTWITHOUTFAMILY_HOMELESS AS pof
	INNER JOIN #ECMEligible# AS ee ON pof.memid = ee.memid 
WHERE 1=1
	AND pof.[RunDate] = ( SELECT MAX( i.[RunDate] ) FROM INFORMATICS.dbo.CHATGPT_ECMPOF_ADULTWITHOUTFAMILY_HOMELESS AS i WITH (NOLOCK) )
GROUP BY [TargetPopulation]
) -- CONCLUDE ...
AS combined 







-- =====================================================================
	-- #BASELINE ECM  (ENHANCED CARE MNGMNT) ENROLLED --
-- =====================================================================
-- =====================================================================
	-- DECLARE @PARAMETER(S) / @FILTER(S) --
-- =====================================================================
--DECLARE @ClockStart AS datetime
--DECLARE @ClockStop AS datetime
--DECLARE @IPPdt AS datetime
--DECLARE @EnrolledMonths AS decimal(9,0)

--SET @ClockStart = TRY_CONVERT(date,GETDATE()) -- ECM / CS ... CALAIM GO LIVE @2022
--SET @ClockStop = TRY_CONVERT(date,GETDATE())
--SET @IPPdt = TRY_CONVERT(date,GETDATE())
--SET @EnrolledMonths = 36

		SELECT 'BETWEEN '+CAST(CAST(@ClockStart AS date) AS varchar (25))+' AND '+CAST(CAST(@ClockStop AS date) AS varchar (25)) AS [RANGE NOTE(s)] -- LEVERAGE: SELECT * FROM INFORMATICS.dbo.[uvw_ECM_ENROLLED] AND "uvw_ECM_ELIGIBLE_ECM_ENROLLED_TheValue_COUNTs.jpg"

/* Young Lady, may I confirm a truism?: 
 
A given member AS mUST be ECM Eligible before they can be ECM Enrolled ...
... AND A member should NOT be ECM Enrolled without being ECM Eligible. 
 
This is the case for a good 85% or so of our members. The caveat to this is for those Member not yet identified as ECM eligible by CHG, but are identified by our community as eligible. */

		/* SELECT ' ' AS 'ECM ELIG / ENROLLED MEMBER SAMPLE: '
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
				OR bm.CIN IN ('99999168G')) */







---------------------------------------------------------------------------------------------------------------------------------
	-- Error Trapping: Check If Permanent Table(s) Already Exist(s) AND Drop If Applicable --
----------------------------------------------------------------------------------------------------------------------------------
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
WHERE 1=1 
	AND qa.description = 'ECM Enrolled'
	AND LTRIM(RTRIM(ISNULL(ma.TheValue,''))) LIKE '%Y%'		
	-- AND TRY_CONVERT(date,ma.effdate) BETWEEN @ClockStart AND @ClockStop -- SPECIFIC TO MEMBERS INITIALLY / NEWLY EFFECTIVE ... during the reporting period
	-- AND TRY_CONVERT(date,ma.effdate) <= @IPPdt -- [Point IN time] AS of 6/30/2023  (this should be adjusted if the reporting period is different) SPECIFIC DATE 
	-- AND TRY_CONVERT(date,ISNULL(ma.termdate,GETDATE())) >= @IPPdt -- [Point IN time] AS of 6/30/2023  (this should be adjusted if the reporting period is different) SPECIFIC DATE 
	AND TRY_CONVERT(date,ISNULL(ma.termdate,GETDATE())) >= TRY_CONVERT(date,@ClockStart) -- WITHIN reporting period [RANGE] OPPOSITION
	AND TRY_CONVERT(date,ma.effdate) <= TRY_CONVERT(date,@ClockStop) -- WITHIN reporting period [RANGE] OPPOSITION 
	AND TRY_CONVERT(date,ISNULL(ma.termdate,GETDATE())) >= TRY_CONVERT(date,ma.effdate) -- MUST BE TRUE ... NON-CROSSFOOTED RECORDS ARE ACTIVE ...	
	
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

SELECT ' ' AS 'ECM Enrolled Unique member Count BY POF',combined.*
FROM 
( -- INITIATE ...
SELECT [TargetPopulation]
,COUNT(DISTINCT(pof.memid)) AS [Unique Member Count] 
FROM INFORMATICS.dbo.ECMPOF_CHILD_BIRTH_EQUITY AS pof 
	INNER JOIN #ECMEnrolled# AS ee ON pof.memid = ee.memid 
WHERE 1=1
	AND pof.[RunDate] = ( SELECT MAX( i.[RunDate] ) FROM INFORMATICS.dbo.ECMPOF_CHILD_BIRTH_EQUITY AS i WITH (NOLOCK) )
GROUP BY [TargetPopulation]

UNION ALL 
SELECT [TargetPopulation]
,COUNT(DISTINCT(pof.memid)) AS [Unique Member Count] 
FROM INFORMATICS.dbo.ECMPOF_CHILD_HOMELESS AS pof
	INNER JOIN #ECMEnrolled# AS ee ON pof.memid = ee.memid
WHERE 1=1
	AND pof.[RunDate] = ( SELECT MAX( i.[RunDate] ) FROM INFORMATICS.dbo.ECMPOF_CHILD_HOMELESS AS i WITH (NOLOCK) )
GROUP BY [TargetPopulation]

UNION ALL 
SELECT [TargetPopulation]
,COUNT(DISTINCT(pof.memid)) AS [Unique Member Count] 
FROM INFORMATICS.dbo.ECMPOF_CHILDWITHFAMILY_HOMELESS AS pof
	INNER JOIN #ECMEnrolled# AS ee ON pof.memid = ee.memid 
WHERE 1=1
	AND pof.[RunDate] = ( SELECT MAX( i.[RunDate] ) FROM INFORMATICS.dbo.ECMPOF_CHILDWITHFAMILY_HOMELESS AS i WITH (NOLOCK) )
GROUP BY [TargetPopulation]

UNION ALL 
SELECT [TargetPopulation]
,COUNT(DISTINCT(pof.memid)) AS [Unique Member Count] 
FROM INFORMATICS.dbo.ECMPOF_CHILDWITHOUTFAMILY_HOMELESS AS pof
	INNER JOIN #ECMEnrolled# AS ee ON pof.memid = ee.memid 
WHERE 1=1
	AND pof.[RunDate] = ( SELECT MAX( i.[RunDate] ) FROM INFORMATICS.dbo.ECMPOF_CHILDWITHOUTFAMILY_HOMELESS AS i WITH (NOLOCK) )
GROUP BY [TargetPopulation]

UNION ALL
SELECT [TargetPopulation]
,COUNT(DISTINCT(pof.memid)) AS [Unique Member Count] 
FROM INFORMATICS.dbo.ECMPOF_CHILD_IPSNFED_HIGHUTIL AS pof
	INNER JOIN #ECMEnrolled# AS ee ON pof.memid = ee.memid 
WHERE 1=1
	AND pof.[RunDate] = ( SELECT MAX( i.[RunDate] ) FROM INFORMATICS.dbo.ECMPOF_CHILD_IPSNFED_HIGHUTIL AS i WITH (NOLOCK) )
GROUP BY [TargetPopulation]

UNION ALL
SELECT [TargetPopulation]
,COUNT(DISTINCT(pof.memid)) AS [Unique Member Count] 
FROM INFORMATICS.dbo.ECMPOF_CHILD_MHSMISUD AS pof
	INNER JOIN #ECMEnrolled# AS ee ON pof.memid = ee.memid 
WHERE 1=1
	AND pof.[RunDate] = ( SELECT MAX( i.[RunDate] ) FROM INFORMATICS.dbo.ECMPOF_CHILD_MHSMISUD AS i WITH (NOLOCK) )
GROUP BY [TargetPopulation]

UNION ALL 
SELECT [TargetPopulation]
,COUNT(DISTINCT(pof.memid)) AS [Unique Member Count] 
FROM INFORMATICS.dbo.ECMPOF_CHILD_INCARCERATION AS pof
	INNER JOIN #ECMEnrolled# AS ee ON pof.memid = ee.memid 
WHERE 1=1
	AND pof.[RunDate] = ( SELECT MAX( i.[RunDate] ) FROM INFORMATICS.dbo.ECMPOF_CHILD_INCARCERATION AS i WITH (NOLOCK) )
GROUP BY [TargetPopulation]

UNION ALL 
SELECT [TargetPopulation]
,COUNT(DISTINCT(pof.memid)) AS [Uniqude Member Count] 
FROM INFORMATICS.dbo.ECMPOF_CHILD_CCS AS pof
	INNER JOIN #ECMEnrolled# AS ee ON pof.memid = ee.memid 
WHERE 1=1
	AND pof.[RunDate] = ( SELECT MAX( i.[RunDate] ) FROM INFORMATICS.dbo.ECMPOF_CHILD_CCS AS i WITH (NOLOCK) )
GROUP BY [TargetPopulation]

UNION ALL 
SELECT [TargetPopulation]
,COUNT(DISTINCT(pof.memid)) AS [Unique Member Count] 
FROM INFORMATICS.dbo.ECMPOF_CHILD_WELFARE AS pof
	INNER JOIN #ECMEnrolled# AS ee ON pof.memid = ee.memid 
WHERE 1=1
	AND pof.[RunDate] = ( SELECT MAX( i.[RunDate] ) FROM INFORMATICS.dbo.ECMPOF_CHILD_WELFARE AS i WITH (NOLOCK) )
GROUP BY [TargetPopulation]

UNION ALL 
SELECT [TargetPopulation]
,COUNT(DISTINCT(pof.memid)) AS [Unique Member Count] 
FROM INFORMATICS.dbo.ECMPOF_ADULT_BIRTH_EQUITY AS pof
	INNER JOIN #ECMEnrolled# AS ee ON pof.memid = ee.memid 
WHERE 1=1
	AND pof.[RunDate] = ( SELECT MAX( i.[RunDate] ) FROM INFORMATICS.dbo.ECMPOF_ADULT_BIRTH_EQUITY AS i WITH (NOLOCK) )
GROUP BY [TargetPopulation]

UNION ALL 
SELECT [TargetPopulation]
,COUNT(DISTINCT(pof.memid)) AS [Unique Member Count] 
FROM INFORMATICS.dbo.ECMPOF_ADULT_IPSNFED_HIGHUTIL AS pof
	INNER JOIN #ECMEnrolled# AS ee ON pof.memid = ee.memid 
WHERE 1=1
	AND pof.[RunDate] = ( SELECT MAX( i.[RunDate] ) FROM INFORMATICS.dbo.ECMPOF_ADULT_IPSNFED_HIGHUTIL AS i WITH (NOLOCK) )
GROUP BY [TargetPopulation]

UNION ALL
SELECT [TargetPopulation]
,COUNT(DISTINCT(pof.memid)) AS [Unique Member Count] 
FROM INFORMATICS.dbo.ECMPOF_ADULT_MHSMISUD AS pof
	INNER JOIN #ECMEnrolled# AS ee ON pof.memid = ee.memid 
WHERE 1=1
	AND pof.[RunDate] = ( SELECT MAX( i.[RunDate] ) FROM INFORMATICS.dbo.ECMPOF_ADULT_MHSMISUD AS i WITH (NOLOCK) )
GROUP BY [TargetPopulation]

UNION ALL
SELECT [TargetPopulation]
,COUNT(DISTINCT(pof.memid)) AS [Unique Member Count] 
FROM INFORMATICS.dbo.ECMPOF_ADULT_INCARCERATION AS pof
	INNER JOIN #ECMEnrolled# AS ee ON pof.memid = ee.memid 
WHERE 1=1
	AND pof.[RunDate] = ( SELECT MAX( i.[RunDate] ) FROM INFORMATICS.dbo.ECMPOF_ADULT_INCARCERATION AS i WITH (NOLOCK) )
GROUP BY [TargetPopulation]

UNION ALL 
SELECT [TargetPopulation]
,COUNT(DISTINCT(pof.memid)) AS [Unique Member Count] 
FROM INFORMATICS.dbo.ECMPOF_ADULT_INSTITUTIONALIZATION AS pof
	INNER JOIN #ECMEnrolled# AS ee ON pof.memid = ee.memid 
WHERE 1=1
	AND pof.[RunDate] = ( SELECT MAX( i.[RunDate] ) FROM INFORMATICS.dbo.ECMPOF_ADULT_INSTITUTIONALIZATION AS i WITH (NOLOCK) )
GROUP BY [TargetPopulation]

UNION ALL 
SELECT [TargetPopulation]
,COUNT(DISTINCT(pof.memid)) AS [Unique Member Count] 
FROM INFORMATICS.dbo.ECMPOF_ADULT_NURSING_TRANSITION AS pof
	INNER JOIN #ECMEnrolled# AS ee ON pof.memid = ee.memid 
WHERE 1=1
	AND pof.[RunDate] = ( SELECT MAX( i.[RunDate] ) FROM INFORMATICS.dbo.ECMPOF_ADULT_NURSING_TRANSITION AS i WITH (NOLOCK) )
GROUP BY [TargetPopulation]

UNION ALL 
SELECT [TargetPopulation]
,COUNT(DISTINCT(pof.memid)) AS [Unique Member Count] 
FROM INFORMATICS.dbo.ECMPOF_ADULTWITHFAMILY_HOMELESS AS pof
	INNER JOIN #ECMEnrolled# AS ee ON pof.memid = ee.memid 
WHERE 1=1
	AND pof.[RunDate] = ( SELECT MAX( i.[RunDate] ) FROM INFORMATICS.dbo.ECMPOF_ADULTWITHFAMILY_HOMELESS AS i WITH (NOLOCK) )
GROUP BY [TargetPopulation]

UNION ALL 
SELECT [TargetPopulation]
,COUNT(DISTINCT(pof.memid)) AS [Unique Member Count] 
FROM INFORMATICS.dbo.ECMPOF_ADULTWITHOUTFAMILY_HOMELESS AS pof
	INNER JOIN #ECMEnrolled# AS ee ON pof.memid = ee.memid 
WHERE 1=1
	AND pof.[RunDate] = ( SELECT MAX( i.[RunDate] ) FROM INFORMATICS.dbo.ECMPOF_ADULTWITHOUTFAMILY_HOMELESS AS i WITH (NOLOCK) )
GROUP BY [TargetPopulation]
) -- CONCLUDE ...
AS combined 







-- =====================================================================
	-- POST CHATGPT UPDATE: 
-- =====================================================================
SELECT ' ' AS 'POST CHATGPT UPDATE: ECM Enrolled Unique member Count BY POF'
,combined.*
FROM 
( -- INITIATE ...
SELECT [TargetPopulation]
,COUNT(DISTINCT(pof.memid)) AS [POST ChatGPT Updates Unique Member Count] 
FROM INFORMATICS.dbo.CHATGPT_ECMPOF_CHILD_BIRTH_EQUITY AS pof 
	INNER JOIN #ECMEnrolled# AS ee ON pof.memid = ee.memid 
WHERE 1=1
	AND pof.[RunDate] = ( SELECT MAX( i.[RunDate] ) FROM INFORMATICS.dbo.CHATGPT_ECMPOF_CHILD_BIRTH_EQUITY AS i WITH (NOLOCK) )
GROUP BY [TargetPopulation]

UNION ALL 
SELECT [TargetPopulation]
,COUNT(DISTINCT(pof.memid)) AS [POST ChatGPT Updates Unique Member Count] 
FROM INFORMATICS.dbo.CHATGPT_ECMPOF_CHILDWITHFAMILY_HOMELESS AS pof
	INNER JOIN #ECMEnrolled# AS ee ON pof.memid = ee.memid 
WHERE 1=1
	AND pof.[RunDate] = ( SELECT MAX( i.[RunDate] ) FROM INFORMATICS.dbo.CHATGPT_ECMPOF_CHILDWITHFAMILY_HOMELESS AS i WITH (NOLOCK) )
GROUP BY [TargetPopulation]

UNION ALL 
SELECT [TargetPopulation]
,COUNT(DISTINCT(pof.memid)) AS [POST ChatGPT Updates Unique Member Count] 
FROM INFORMATICS.dbo.CHATGPT_ECMPOF_CHILDWITHOUTFAMILY_HOMELESS AS pof
	INNER JOIN #ECMEnrolled# AS ee ON pof.memid = ee.memid 
WHERE 1=1
	AND pof.[RunDate] = ( SELECT MAX( i.[RunDate] ) FROM INFORMATICS.dbo.CHATGPT_ECMPOF_CHILDWITHOUTFAMILY_HOMELESS AS i WITH (NOLOCK) )
GROUP BY [TargetPopulation]

UNION ALL
SELECT [TargetPopulation]
,COUNT(DISTINCT(pof.memid)) AS [POST ChatGPT Updates Unique Member Count] 
FROM INFORMATICS.dbo.CHATGPT_ECMPOF_CHILD_IPSNFED_HIGHUTIL AS pof
	INNER JOIN #ECMEnrolled# AS ee ON pof.memid = ee.memid 
WHERE 1=1
	AND pof.[RunDate] = ( SELECT MAX( i.[RunDate] ) FROM INFORMATICS.dbo.CHATGPT_ECMPOF_CHILD_IPSNFED_HIGHUTIL AS i WITH (NOLOCK) )
GROUP BY [TargetPopulation]

UNION ALL
SELECT [TargetPopulation]
,COUNT(DISTINCT(pof.memid)) AS [POST ChatGPT Updates Unique Member Count] 
FROM INFORMATICS.dbo.CHATGPT_ECMPOF_CHILD_MHSMISUD AS pof
	INNER JOIN #ECMEnrolled# AS ee ON pof.memid = ee.memid 
WHERE 1=1
	AND pof.[RunDate] = ( SELECT MAX( i.[RunDate] ) FROM INFORMATICS.dbo.CHATGPT_ECMPOF_CHILD_MHSMISUD AS i WITH (NOLOCK) )
GROUP BY [TargetPopulation]

UNION ALL 
SELECT [TargetPopulation]
,COUNT(DISTINCT(pof.memid)) AS [POST ChatGPT Updates Unique Member Count] 
FROM INFORMATICS.dbo.CHATGPT_ECMPOF_CHILD_INCARCERATION AS pof
	INNER JOIN #ECMEnrolled# AS ee ON pof.memid = ee.memid 
WHERE 1=1
	AND pof.[RunDate] = ( SELECT MAX( i.[RunDate] ) FROM INFORMATICS.dbo.CHATGPT_ECMPOF_CHILD_INCARCERATION AS i WITH (NOLOCK) )
GROUP BY [TargetPopulation]

UNION ALL 
SELECT [TargetPopulation]
,COUNT(DISTINCT(pof.memid)) AS [Uniqude Member Count] 
FROM INFORMATICS.dbo.CHATGPT_ECMPOF_CHILD_CCS AS pof
	INNER JOIN #ECMEnrolled# AS ee ON pof.memid = ee.memid 
WHERE 1=1
	AND pof.[RunDate] = ( SELECT MAX( i.[RunDate] ) FROM INFORMATICS.dbo.CHATGPT_ECMPOF_CHILD_CCS AS i WITH (NOLOCK) )
GROUP BY [TargetPopulation]

UNION ALL 
SELECT [TargetPopulation]
,COUNT(DISTINCT(pof.memid)) AS [POST ChatGPT Updates Unique Member Count] 
FROM INFORMATICS.dbo.CHATGPT_ECMPOF_CHILD_WELFARE AS pof
	INNER JOIN #ECMEnrolled# AS ee ON pof.memid = ee.memid 
WHERE 1=1
	AND pof.[RunDate] = ( SELECT MAX( i.[RunDate] ) FROM INFORMATICS.dbo.CHATGPT_ECMPOF_CHILD_WELFARE AS i WITH (NOLOCK) )
GROUP BY [TargetPopulation]

UNION ALL 
SELECT [TargetPopulation]
,COUNT(DISTINCT(pof.memid)) AS [POST ChatGPT Updates Unique Member Count] 
FROM INFORMATICS.dbo.CHATGPT_ECMPOF_ADULT_BIRTH_EQUITY AS pof
	INNER JOIN #ECMEnrolled# AS ee ON pof.memid = ee.memid 
WHERE 1=1
	AND pof.[RunDate] = ( SELECT MAX( i.[RunDate] ) FROM INFORMATICS.dbo.CHATGPT_ECMPOF_ADULT_BIRTH_EQUITY AS i WITH (NOLOCK) )
GROUP BY [TargetPopulation]

UNION ALL 
SELECT [TargetPopulation]
,COUNT(DISTINCT(pof.memid)) AS [POST ChatGPT Updates Unique Member Count] 
FROM INFORMATICS.dbo.CHATGPT_ECMPOF_ADULT_IPSNFED_HIGHUTIL AS pof
	INNER JOIN #ECMEnrolled# AS ee ON pof.memid = ee.memid 
WHERE 1=1
	AND pof.[RunDate] = ( SELECT MAX( i.[RunDate] ) FROM INFORMATICS.dbo.CHATGPT_ECMPOF_ADULT_IPSNFED_HIGHUTIL AS i WITH (NOLOCK) )
GROUP BY [TargetPopulation]

UNION ALL
SELECT [TargetPopulation]
,COUNT(DISTINCT(pof.memid)) AS [POST ChatGPT Updates Unique Member Count] 
FROM INFORMATICS.dbo.CHATGPT_ECMPOF_ADULT_MHSMISUD AS pof
	INNER JOIN #ECMEnrolled# AS ee ON pof.memid = ee.memid 
WHERE 1=1
	AND pof.[RunDate] = ( SELECT MAX( i.[RunDate] ) FROM INFORMATICS.dbo.CHATGPT_ECMPOF_ADULT_MHSMISUD AS i WITH (NOLOCK) )
GROUP BY [TargetPopulation]

UNION ALL
SELECT [TargetPopulation]
,COUNT(DISTINCT(pof.memid)) AS [POST ChatGPT Updates Unique Member Count] 
FROM INFORMATICS.dbo.CHATGPT_ECMPOF_ADULT_INCARCERATION AS pof
	INNER JOIN #ECMEnrolled# AS ee ON pof.memid = ee.memid 
WHERE 1=1
	AND pof.[RunDate] = ( SELECT MAX( i.[RunDate] ) FROM INFORMATICS.dbo.CHATGPT_ECMPOF_ADULT_INCARCERATION AS i WITH (NOLOCK) )
GROUP BY [TargetPopulation]

UNION ALL 
SELECT [TargetPopulation]
,COUNT(DISTINCT(pof.memid)) AS [POST ChatGPT Updates Unique Member Count] 
FROM INFORMATICS.dbo.CHATGPT_ECMPOF_ADULT_INSTITUTIONALIZATION AS pof
	INNER JOIN #ECMEnrolled# AS ee ON pof.memid = ee.memid 
WHERE 1=1
	AND pof.[RunDate] = ( SELECT MAX( i.[RunDate] ) FROM INFORMATICS.dbo.CHATGPT_ECMPOF_ADULT_INSTITUTIONALIZATION AS i WITH (NOLOCK) )
GROUP BY [TargetPopulation]

UNION ALL 
SELECT [TargetPopulation]
,COUNT(DISTINCT(pof.memid)) AS [POST ChatGPT Updates Unique Member Count] 
FROM INFORMATICS.dbo.CHATGPT_ECMPOF_ADULT_NURSING_TRANSITION AS pof
	INNER JOIN #ECMEnrolled# AS ee ON pof.memid = ee.memid 
WHERE 1=1
	AND pof.[RunDate] = ( SELECT MAX( i.[RunDate] ) FROM INFORMATICS.dbo.CHATGPT_ECMPOF_ADULT_NURSING_TRANSITION AS i WITH (NOLOCK) )
GROUP BY [TargetPopulation]

UNION ALL 
SELECT [TargetPopulation]
,COUNT(DISTINCT(pof.memid)) AS [POST ChatGPT Updates Unique Member Count] 
FROM INFORMATICS.dbo.CHATGPT_ECMPOF_ADULTWITHFAMILY_HOMELESS AS pof
	INNER JOIN #ECMEnrolled# AS ee ON pof.memid = ee.memid 
WHERE 1=1
	AND pof.[RunDate] = ( SELECT MAX( i.[RunDate] ) FROM INFORMATICS.dbo.CHATGPT_ECMPOF_ADULTWITHFAMILY_HOMELESS AS i WITH (NOLOCK) )
GROUP BY [TargetPopulation]

UNION ALL 
SELECT [TargetPopulation]
,COUNT(DISTINCT(pof.memid)) AS [POST ChatGPT Updates Unique Member Count] 
FROM INFORMATICS.dbo.CHATGPT_ECMPOF_ADULTWITHOUTFAMILY_HOMELESS AS pof
	INNER JOIN #ECMEnrolled# AS ee ON pof.memid = ee.memid 
WHERE 1=1
	AND pof.[RunDate] = ( SELECT MAX( i.[RunDate] ) FROM INFORMATICS.dbo.CHATGPT_ECMPOF_ADULTWITHOUTFAMILY_HOMELESS AS i WITH (NOLOCK) )
GROUP BY [TargetPopulation]
) -- CONCLUDE ...
AS combined 







-- =====================================================================
	-- ADDENDUM: ANSWERING SIR ADRIAN'S QUESTION -- "HOW MANY UNIQUE MEMBERS?"
	-- Requested via Ms. Tatasani Flora, 20260706 10:49 AM
-- =====================================================================
/* Ms. Tatasani confirmed the goal at 10:49 AM: "Adrian is asking how many unique members?"

This is a DIFFERENT question than "is a member only in ONE POF" (which is NOT an
accurate statement -- see prior reply). Each POF is driven independently by
Diagnosis, Service Code, HMIS presence, incarceration, welfare, etc., so a single
member can qualify for MULTIPLE POFs at once
(e.g., Homeless + High Utilizer + SMI/SUD diagnosis = 3 POFs, same person).

The EXISTING script's "Unique member Count BY POF" result set (UNION ALL + GROUP BY
TargetPopulation) counts each POF bucket separately. A member sitting in 3 POFs is
counted 3 times across that result set -- it answers "how big is each POF bucket,"
NOT "how many unique members."

This addendum UNIONs member+POF pairs ACROSS all buckets and de-duplicates on memid, producing:
	1) A single de-duplicated headcount (answers Adrian's question directly)
	2) An overlap distribution -- how many POFs each member sits in -- which is the
	   real evidence behind "that would not be an accurate statement"

PRE-REQUISITE: Run the EXISTING script's Section 1 (ECM Eligible, through creation of #ECMEligible#) and Section 2 (ECM Enrolled, through creation of #ECMEnrolled#) FIRST, in the SAME session/tab -- this addendum reuses those temp tables. Do not run this addendum in a fresh query window without them. */

---------------------------------------------------------------------------------------------------------------------------------
	-- Error Trapping: Check If Permanent Table(s) Already Exist(s) AND Drop If Applicable --
----------------------------------------------------------------------------------------------------------------------------------
IF OBJECT_ID('tempdb.dbo.#ExistingPOF_Eligible_XREF#') IS NOT NULL DROP TABLE #ExistingPOF_Eligible_XREF#
IF OBJECT_ID('tempdb.dbo.#ExistingPOF_Enrolled_XREF#') IS NOT NULL DROP TABLE #ExistingPOF_Enrolled_XREF#
IF OBJECT_ID('tempdb.dbo.#AlgorithmPOF_Eligible_XREF#') IS NOT NULL DROP TABLE #AlgorithmPOF_Eligible_XREF#
IF OBJECT_ID('tempdb.dbo.#AlgorithmPOF_Enrolled_XREF#') IS NOT NULL DROP TABLE #AlgorithmPOF_Enrolled_XREF#

-- =====================================================================
	-- EXISTING POF -- ECM ELIGIBLE -- MEMBER x POF XREF (de-duplicated) --
-- =====================================================================
SELECT memid
,[TargetPopulation]
INTO #ExistingPOF_Eligible_XREF#
FROM ( -- INITIATE ...
SELECT pof.memid
,pof.[TargetPopulation]
FROM INFORMATICS.dbo.ECMPOF_CHILD_BIRTH_EQUITY AS pof
	INNER JOIN #ECMEligible# AS ee ON pof.memid = ee.memid
WHERE 1=1
	AND pof.[RunDate] = ( SELECT MAX( i.[RunDate] ) FROM INFORMATICS.dbo.ECMPOF_CHILD_BIRTH_EQUITY AS i WITH (NOLOCK) )

UNION ALL
SELECT pof.memid
,pof.[TargetPopulation]
FROM INFORMATICS.dbo.ECMPOF_CHILD_HOMELESS AS pof
	INNER JOIN #ECMEligible# AS ee ON pof.memid = ee.memid
WHERE 1=1
	AND pof.[RunDate] = ( SELECT MAX( i.[RunDate] ) FROM INFORMATICS.dbo.ECMPOF_CHILD_HOMELESS AS i WITH (NOLOCK) )

UNION ALL
SELECT pof.memid
,pof.[TargetPopulation]
FROM INFORMATICS.dbo.ECMPOF_CHILDWITHFAMILY_HOMELESS AS pof
	INNER JOIN #ECMEligible# AS ee ON pof.memid = ee.memid
WHERE 1=1
	AND pof.[RunDate] = ( SELECT MAX( i.[RunDate] ) FROM INFORMATICS.dbo.ECMPOF_CHILDWITHFAMILY_HOMELESS AS i WITH (NOLOCK) )

UNION ALL
SELECT pof.memid
,pof.[TargetPopulation]
FROM INFORMATICS.dbo.ECMPOF_CHILDWITHOUTFAMILY_HOMELESS AS pof
	INNER JOIN #ECMEligible# AS ee ON pof.memid = ee.memid
WHERE 1=1
	AND pof.[RunDate] = ( SELECT MAX( i.[RunDate] ) FROM INFORMATICS.dbo.ECMPOF_CHILDWITHOUTFAMILY_HOMELESS AS i WITH (NOLOCK) )

UNION ALL
SELECT pof.memid
,pof.[TargetPopulation]
FROM INFORMATICS.dbo.ECMPOF_CHILD_IPSNFED_HIGHUTIL AS pof
	INNER JOIN #ECMEligible# AS ee ON pof.memid = ee.memid
WHERE 1=1
	AND pof.[RunDate] = ( SELECT MAX( i.[RunDate] ) FROM INFORMATICS.dbo.ECMPOF_CHILD_IPSNFED_HIGHUTIL AS i WITH (NOLOCK) )

UNION ALL
SELECT pof.memid
,pof.[TargetPopulation]
FROM INFORMATICS.dbo.ECMPOF_CHILD_MHSMISUD AS pof
	INNER JOIN #ECMEligible# AS ee ON pof.memid = ee.memid
WHERE 1=1
	AND pof.[RunDate] = ( SELECT MAX( i.[RunDate] ) FROM INFORMATICS.dbo.ECMPOF_CHILD_MHSMISUD AS i WITH (NOLOCK) )

UNION ALL
SELECT pof.memid
,pof.[TargetPopulation]
FROM INFORMATICS.dbo.ECMPOF_CHILD_INCARCERATION AS pof
	INNER JOIN #ECMEligible# AS ee ON pof.memid = ee.memid
WHERE 1=1
	AND pof.[RunDate] = ( SELECT MAX( i.[RunDate] ) FROM INFORMATICS.dbo.ECMPOF_CHILD_INCARCERATION AS i WITH (NOLOCK) )

UNION ALL
SELECT pof.memid
,pof.[TargetPopulation]
FROM INFORMATICS.dbo.ECMPOF_CHILD_CCS AS pof
	INNER JOIN #ECMEligible# AS ee ON pof.memid = ee.memid
WHERE 1=1
	AND pof.[RunDate] = ( SELECT MAX( i.[RunDate] ) FROM INFORMATICS.dbo.ECMPOF_CHILD_CCS AS i WITH (NOLOCK) )

UNION ALL
SELECT pof.memid
,pof.[TargetPopulation]
FROM INFORMATICS.dbo.ECMPOF_CHILD_WELFARE AS pof
	INNER JOIN #ECMEligible# AS ee ON pof.memid = ee.memid
WHERE 1=1
	AND pof.[RunDate] = ( SELECT MAX( i.[RunDate] ) FROM INFORMATICS.dbo.ECMPOF_CHILD_WELFARE AS i WITH (NOLOCK) )

UNION ALL
SELECT pof.memid
,pof.[TargetPopulation]
FROM INFORMATICS.dbo.ECMPOF_ADULT_BIRTH_EQUITY AS pof
	INNER JOIN #ECMEligible# AS ee ON pof.memid = ee.memid
WHERE 1=1
	AND pof.[RunDate] = ( SELECT MAX( i.[RunDate] ) FROM INFORMATICS.dbo.ECMPOF_ADULT_BIRTH_EQUITY AS i WITH (NOLOCK) )

UNION ALL
SELECT pof.memid
,pof.[TargetPopulation]
FROM INFORMATICS.dbo.ECMPOF_ADULT_IPSNFED_HIGHUTIL AS pof
	INNER JOIN #ECMEligible# AS ee ON pof.memid = ee.memid
WHERE 1=1
	AND pof.[RunDate] = ( SELECT MAX( i.[RunDate] ) FROM INFORMATICS.dbo.ECMPOF_ADULT_IPSNFED_HIGHUTIL AS i WITH (NOLOCK) )

UNION ALL
SELECT pof.memid
,pof.[TargetPopulation]
FROM INFORMATICS.dbo.ECMPOF_ADULT_MHSMISUD AS pof
	INNER JOIN #ECMEligible# AS ee ON pof.memid = ee.memid
WHERE 1=1
	AND pof.[RunDate] = ( SELECT MAX( i.[RunDate] ) FROM INFORMATICS.dbo.ECMPOF_ADULT_MHSMISUD AS i WITH (NOLOCK) )

UNION ALL
SELECT pof.memid
,pof.[TargetPopulation]
FROM INFORMATICS.dbo.ECMPOF_ADULT_INCARCERATION AS pof
	INNER JOIN #ECMEligible# AS ee ON pof.memid = ee.memid
WHERE 1=1
	AND pof.[RunDate] = ( SELECT MAX( i.[RunDate] ) FROM INFORMATICS.dbo.ECMPOF_ADULT_INCARCERATION AS i WITH (NOLOCK) )

UNION ALL
SELECT pof.memid
,pof.[TargetPopulation]
FROM INFORMATICS.dbo.ECMPOF_ADULT_INSTITUTIONALIZATION AS pof
	INNER JOIN #ECMEligible# AS ee ON pof.memid = ee.memid
WHERE 1=1
	AND pof.[RunDate] = ( SELECT MAX( i.[RunDate] ) FROM INFORMATICS.dbo.ECMPOF_ADULT_INSTITUTIONALIZATION AS i WITH (NOLOCK) )

UNION ALL
SELECT pof.memid
,pof.[TargetPopulation]
FROM INFORMATICS.dbo.ECMPOF_ADULT_NURSING_TRANSITION AS pof
	INNER JOIN #ECMEligible# AS ee ON pof.memid = ee.memid
WHERE 1=1
	AND pof.[RunDate] = ( SELECT MAX( i.[RunDate] ) FROM INFORMATICS.dbo.ECMPOF_ADULT_NURSING_TRANSITION AS i WITH (NOLOCK) )

UNION ALL
SELECT pof.memid
,pof.[TargetPopulation]
FROM INFORMATICS.dbo.ECMPOF_ADULTWITHFAMILY_HOMELESS AS pof
	INNER JOIN #ECMEligible# AS ee ON pof.memid = ee.memid
WHERE 1=1
	AND pof.[RunDate] = ( SELECT MAX( i.[RunDate] ) FROM INFORMATICS.dbo.ECMPOF_ADULTWITHFAMILY_HOMELESS AS i WITH (NOLOCK) )

UNION ALL
SELECT pof.memid
,pof.[TargetPopulation]
FROM INFORMATICS.dbo.ECMPOF_ADULTWITHOUTFAMILY_HOMELESS AS pof
	INNER JOIN #ECMEligible# AS ee ON pof.memid = ee.memid
WHERE 1=1
	AND pof.[RunDate] = ( SELECT MAX( i.[RunDate] ) FROM INFORMATICS.dbo.ECMPOF_ADULTWITHOUTFAMILY_HOMELESS AS i WITH (NOLOCK) )
) AS pof -- CONCLUDE ...
GROUP BY memid,[TargetPopulation]

-- =====================================================================
	-- EXISTING POF -- ECM ENROLLED -- MEMBER x POF XREF (de-duplicated) --
-- =====================================================================
SELECT memid
,[TargetPopulation]
INTO #ExistingPOF_Enrolled_XREF#
FROM ( -- INITIATE ...
SELECT pof.memid
,pof.[TargetPopulation]
FROM INFORMATICS.dbo.ECMPOF_CHILD_BIRTH_EQUITY AS pof
	INNER JOIN #ECMEnrolled# AS ee ON pof.memid = ee.memid
WHERE 1=1
	AND pof.[RunDate] = ( SELECT MAX( i.[RunDate] ) FROM INFORMATICS.dbo.ECMPOF_CHILD_BIRTH_EQUITY AS i WITH (NOLOCK) )

UNION ALL
SELECT pof.memid
,pof.[TargetPopulation]
FROM INFORMATICS.dbo.ECMPOF_CHILD_HOMELESS AS pof
	INNER JOIN #ECMEnrolled# AS ee ON pof.memid = ee.memid
WHERE 1=1
	AND pof.[RunDate] = ( SELECT MAX( i.[RunDate] ) FROM INFORMATICS.dbo.ECMPOF_CHILD_HOMELESS AS i WITH (NOLOCK) )

UNION ALL
SELECT pof.memid
,pof.[TargetPopulation]
FROM INFORMATICS.dbo.ECMPOF_CHILDWITHFAMILY_HOMELESS AS pof
	INNER JOIN #ECMEnrolled# AS ee ON pof.memid = ee.memid
WHERE 1=1
	AND pof.[RunDate] = ( SELECT MAX( i.[RunDate] ) FROM INFORMATICS.dbo.ECMPOF_CHILDWITHFAMILY_HOMELESS AS i WITH (NOLOCK) )

UNION ALL
SELECT pof.memid
,pof.[TargetPopulation]
FROM INFORMATICS.dbo.ECMPOF_CHILDWITHOUTFAMILY_HOMELESS AS pof
	INNER JOIN #ECMEnrolled# AS ee ON pof.memid = ee.memid
WHERE 1=1
	AND pof.[RunDate] = ( SELECT MAX( i.[RunDate] ) FROM INFORMATICS.dbo.ECMPOF_CHILDWITHOUTFAMILY_HOMELESS AS i WITH (NOLOCK) )

UNION ALL
SELECT pof.memid
,pof.[TargetPopulation]
FROM INFORMATICS.dbo.ECMPOF_CHILD_IPSNFED_HIGHUTIL AS pof
	INNER JOIN #ECMEnrolled# AS ee ON pof.memid = ee.memid
WHERE 1=1
	AND pof.[RunDate] = ( SELECT MAX( i.[RunDate] ) FROM INFORMATICS.dbo.ECMPOF_CHILD_IPSNFED_HIGHUTIL AS i WITH (NOLOCK) )

UNION ALL
SELECT pof.memid
,pof.[TargetPopulation]
FROM INFORMATICS.dbo.ECMPOF_CHILD_MHSMISUD AS pof
	INNER JOIN #ECMEnrolled# AS ee ON pof.memid = ee.memid
WHERE 1=1
	AND pof.[RunDate] = ( SELECT MAX( i.[RunDate] ) FROM INFORMATICS.dbo.ECMPOF_CHILD_MHSMISUD AS i WITH (NOLOCK) )

UNION ALL
SELECT pof.memid
,pof.[TargetPopulation]
FROM INFORMATICS.dbo.ECMPOF_CHILD_INCARCERATION AS pof
	INNER JOIN #ECMEnrolled# AS ee ON pof.memid = ee.memid
WHERE 1=1
	AND pof.[RunDate] = ( SELECT MAX( i.[RunDate] ) FROM INFORMATICS.dbo.ECMPOF_CHILD_INCARCERATION AS i WITH (NOLOCK) )

UNION ALL
SELECT pof.memid
,pof.[TargetPopulation]
FROM INFORMATICS.dbo.ECMPOF_CHILD_CCS AS pof
	INNER JOIN #ECMEnrolled# AS ee ON pof.memid = ee.memid
WHERE 1=1
	AND pof.[RunDate] = ( SELECT MAX( i.[RunDate] ) FROM INFORMATICS.dbo.ECMPOF_CHILD_CCS AS i WITH (NOLOCK) )

UNION ALL
SELECT pof.memid
,pof.[TargetPopulation]
FROM INFORMATICS.dbo.ECMPOF_CHILD_WELFARE AS pof
	INNER JOIN #ECMEnrolled# AS ee ON pof.memid = ee.memid
WHERE 1=1
	AND pof.[RunDate] = ( SELECT MAX( i.[RunDate] ) FROM INFORMATICS.dbo.ECMPOF_CHILD_WELFARE AS i WITH (NOLOCK) )

UNION ALL
SELECT pof.memid
,pof.[TargetPopulation]
FROM INFORMATICS.dbo.ECMPOF_ADULT_BIRTH_EQUITY AS pof
	INNER JOIN #ECMEnrolled# AS ee ON pof.memid = ee.memid
WHERE 1=1
	AND pof.[RunDate] = ( SELECT MAX( i.[RunDate] ) FROM INFORMATICS.dbo.ECMPOF_ADULT_BIRTH_EQUITY AS i WITH (NOLOCK) )

UNION ALL
SELECT pof.memid
,pof.[TargetPopulation]
FROM INFORMATICS.dbo.ECMPOF_ADULT_IPSNFED_HIGHUTIL AS pof
	INNER JOIN #ECMEnrolled# AS ee ON pof.memid = ee.memid
WHERE 1=1
	AND pof.[RunDate] = ( SELECT MAX( i.[RunDate] ) FROM INFORMATICS.dbo.ECMPOF_ADULT_IPSNFED_HIGHUTIL AS i WITH (NOLOCK) )

UNION ALL
SELECT pof.memid
,pof.[TargetPopulation]
FROM INFORMATICS.dbo.ECMPOF_ADULT_MHSMISUD AS pof
	INNER JOIN #ECMEnrolled# AS ee ON pof.memid = ee.memid
WHERE 1=1
	AND pof.[RunDate] = ( SELECT MAX( i.[RunDate] ) FROM INFORMATICS.dbo.ECMPOF_ADULT_MHSMISUD AS i WITH (NOLOCK) )

UNION ALL
SELECT pof.memid
,pof.[TargetPopulation]
FROM INFORMATICS.dbo.ECMPOF_ADULT_INCARCERATION AS pof
	INNER JOIN #ECMEnrolled# AS ee ON pof.memid = ee.memid
WHERE 1=1
	AND pof.[RunDate] = ( SELECT MAX( i.[RunDate] ) FROM INFORMATICS.dbo.ECMPOF_ADULT_INCARCERATION AS i WITH (NOLOCK) )

UNION ALL
SELECT pof.memid
,pof.[TargetPopulation]
FROM INFORMATICS.dbo.ECMPOF_ADULT_INSTITUTIONALIZATION AS pof
	INNER JOIN #ECMEnrolled# AS ee ON pof.memid = ee.memid
WHERE 1=1
	AND pof.[RunDate] = ( SELECT MAX( i.[RunDate] ) FROM INFORMATICS.dbo.ECMPOF_ADULT_INSTITUTIONALIZATION AS i WITH (NOLOCK) )

UNION ALL
SELECT pof.memid
,pof.[TargetPopulation]
FROM INFORMATICS.dbo.ECMPOF_ADULT_NURSING_TRANSITION AS pof
	INNER JOIN #ECMEnrolled# AS ee ON pof.memid = ee.memid
WHERE 1=1
	AND pof.[RunDate] = ( SELECT MAX( i.[RunDate] ) FROM INFORMATICS.dbo.ECMPOF_ADULT_NURSING_TRANSITION AS i WITH (NOLOCK) )

UNION ALL
SELECT pof.memid
,pof.[TargetPopulation]
FROM INFORMATICS.dbo.ECMPOF_ADULTWITHFAMILY_HOMELESS AS pof
	INNER JOIN #ECMEnrolled# AS ee ON pof.memid = ee.memid
WHERE 1=1
	AND pof.[RunDate] = ( SELECT MAX( i.[RunDate] ) FROM INFORMATICS.dbo.ECMPOF_ADULTWITHFAMILY_HOMELESS AS i WITH (NOLOCK) )

UNION ALL
SELECT pof.memid
,pof.[TargetPopulation]
FROM INFORMATICS.dbo.ECMPOF_ADULTWITHOUTFAMILY_HOMELESS AS pof
	INNER JOIN #ECMEnrolled# AS ee ON pof.memid = ee.memid
WHERE 1=1
	AND pof.[RunDate] = ( SELECT MAX( i.[RunDate] ) FROM INFORMATICS.dbo.ECMPOF_ADULTWITHOUTFAMILY_HOMELESS AS i WITH (NOLOCK) )
) AS pof -- CONCLUDE ...
GROUP BY memid,[TargetPopulation]

-- =====================================================================
	-- ALGORITHM (CHATGPT) POF -- ECM ELIGIBLE -- MEMBER x POF XREF (de-duplicated) --
-- =====================================================================
SELECT memid
,[TargetPopulation]
INTO #AlgorithmPOF_Eligible_XREF#
FROM ( -- INITIATE ...
SELECT pof.memid
,pof.[TargetPopulation]
FROM INFORMATICS.dbo.CHATGPT_ECMPOF_CHILD_BIRTH_EQUITY AS pof
	INNER JOIN #ECMEligible# AS ee ON pof.memid = ee.memid
WHERE 1=1
	AND pof.[RunDate] = ( SELECT MAX( i.[RunDate] ) FROM INFORMATICS.dbo.CHATGPT_ECMPOF_CHILD_BIRTH_EQUITY AS i WITH (NOLOCK) )

UNION ALL
SELECT pof.memid
,pof.[TargetPopulation]
FROM INFORMATICS.dbo.CHATGPT_ECMPOF_CHILDWITHFAMILY_HOMELESS AS pof
	INNER JOIN #ECMEligible# AS ee ON pof.memid = ee.memid
WHERE 1=1
	AND pof.[RunDate] = ( SELECT MAX( i.[RunDate] ) FROM INFORMATICS.dbo.CHATGPT_ECMPOF_CHILDWITHFAMILY_HOMELESS AS i WITH (NOLOCK) )

UNION ALL
SELECT pof.memid
,pof.[TargetPopulation]
FROM INFORMATICS.dbo.CHATGPT_ECMPOF_CHILDWITHOUTFAMILY_HOMELESS AS pof
	INNER JOIN #ECMEligible# AS ee ON pof.memid = ee.memid
WHERE 1=1
	AND pof.[RunDate] = ( SELECT MAX( i.[RunDate] ) FROM INFORMATICS.dbo.CHATGPT_ECMPOF_CHILDWITHOUTFAMILY_HOMELESS AS i WITH (NOLOCK) )

UNION ALL
SELECT pof.memid
,pof.[TargetPopulation]
FROM INFORMATICS.dbo.CHATGPT_ECMPOF_CHILD_IPSNFED_HIGHUTIL AS pof
	INNER JOIN #ECMEligible# AS ee ON pof.memid = ee.memid
WHERE 1=1
	AND pof.[RunDate] = ( SELECT MAX( i.[RunDate] ) FROM INFORMATICS.dbo.CHATGPT_ECMPOF_CHILD_IPSNFED_HIGHUTIL AS i WITH (NOLOCK) )

UNION ALL
SELECT pof.memid
,pof.[TargetPopulation]
FROM INFORMATICS.dbo.CHATGPT_ECMPOF_CHILD_MHSMISUD AS pof
	INNER JOIN #ECMEligible# AS ee ON pof.memid = ee.memid
WHERE 1=1
	AND pof.[RunDate] = ( SELECT MAX( i.[RunDate] ) FROM INFORMATICS.dbo.CHATGPT_ECMPOF_CHILD_MHSMISUD AS i WITH (NOLOCK) )

UNION ALL
SELECT pof.memid
,pof.[TargetPopulation]
FROM INFORMATICS.dbo.CHATGPT_ECMPOF_CHILD_INCARCERATION AS pof
	INNER JOIN #ECMEligible# AS ee ON pof.memid = ee.memid
WHERE 1=1
	AND pof.[RunDate] = ( SELECT MAX( i.[RunDate] ) FROM INFORMATICS.dbo.CHATGPT_ECMPOF_CHILD_INCARCERATION AS i WITH (NOLOCK) )

UNION ALL
SELECT pof.memid
,pof.[TargetPopulation]
FROM INFORMATICS.dbo.CHATGPT_ECMPOF_CHILD_CCS AS pof
	INNER JOIN #ECMEligible# AS ee ON pof.memid = ee.memid
WHERE 1=1
	AND pof.[RunDate] = ( SELECT MAX( i.[RunDate] ) FROM INFORMATICS.dbo.CHATGPT_ECMPOF_CHILD_CCS AS i WITH (NOLOCK) )

UNION ALL
SELECT pof.memid
,pof.[TargetPopulation]
FROM INFORMATICS.dbo.CHATGPT_ECMPOF_CHILD_WELFARE AS pof
	INNER JOIN #ECMEligible# AS ee ON pof.memid = ee.memid
WHERE 1=1
	AND pof.[RunDate] = ( SELECT MAX( i.[RunDate] ) FROM INFORMATICS.dbo.CHATGPT_ECMPOF_CHILD_WELFARE AS i WITH (NOLOCK) )

UNION ALL
SELECT pof.memid
,pof.[TargetPopulation]
FROM INFORMATICS.dbo.CHATGPT_ECMPOF_ADULT_BIRTH_EQUITY AS pof
	INNER JOIN #ECMEligible# AS ee ON pof.memid = ee.memid
WHERE 1=1
	AND pof.[RunDate] = ( SELECT MAX( i.[RunDate] ) FROM INFORMATICS.dbo.CHATGPT_ECMPOF_ADULT_BIRTH_EQUITY AS i WITH (NOLOCK) )

UNION ALL
SELECT pof.memid
,pof.[TargetPopulation]
FROM INFORMATICS.dbo.CHATGPT_ECMPOF_ADULT_IPSNFED_HIGHUTIL AS pof
	INNER JOIN #ECMEligible# AS ee ON pof.memid = ee.memid
WHERE 1=1
	AND pof.[RunDate] = ( SELECT MAX( i.[RunDate] ) FROM INFORMATICS.dbo.CHATGPT_ECMPOF_ADULT_IPSNFED_HIGHUTIL AS i WITH (NOLOCK) )

UNION ALL
SELECT pof.memid
,pof.[TargetPopulation]
FROM INFORMATICS.dbo.CHATGPT_ECMPOF_ADULT_MHSMISUD AS pof
	INNER JOIN #ECMEligible# AS ee ON pof.memid = ee.memid
WHERE 1=1
	AND pof.[RunDate] = ( SELECT MAX( i.[RunDate] ) FROM INFORMATICS.dbo.CHATGPT_ECMPOF_ADULT_MHSMISUD AS i WITH (NOLOCK) )

UNION ALL
SELECT pof.memid
,pof.[TargetPopulation]
FROM INFORMATICS.dbo.CHATGPT_ECMPOF_ADULT_INCARCERATION AS pof
	INNER JOIN #ECMEligible# AS ee ON pof.memid = ee.memid
WHERE 1=1
	AND pof.[RunDate] = ( SELECT MAX( i.[RunDate] ) FROM INFORMATICS.dbo.CHATGPT_ECMPOF_ADULT_INCARCERATION AS i WITH (NOLOCK) )

UNION ALL
SELECT pof.memid
,pof.[TargetPopulation]
FROM INFORMATICS.dbo.CHATGPT_ECMPOF_ADULT_INSTITUTIONALIZATION AS pof
	INNER JOIN #ECMEligible# AS ee ON pof.memid = ee.memid
WHERE 1=1
	AND pof.[RunDate] = ( SELECT MAX( i.[RunDate] ) FROM INFORMATICS.dbo.CHATGPT_ECMPOF_ADULT_INSTITUTIONALIZATION AS i WITH (NOLOCK) )

UNION ALL
SELECT pof.memid
,pof.[TargetPopulation]
FROM INFORMATICS.dbo.CHATGPT_ECMPOF_ADULT_NURSING_TRANSITION AS pof
	INNER JOIN #ECMEligible# AS ee ON pof.memid = ee.memid
WHERE 1=1
	AND pof.[RunDate] = ( SELECT MAX( i.[RunDate] ) FROM INFORMATICS.dbo.CHATGPT_ECMPOF_ADULT_NURSING_TRANSITION AS i WITH (NOLOCK) )

UNION ALL
SELECT pof.memid
,pof.[TargetPopulation]
FROM INFORMATICS.dbo.CHATGPT_ECMPOF_ADULTWITHFAMILY_HOMELESS AS pof
	INNER JOIN #ECMEligible# AS ee ON pof.memid = ee.memid
WHERE 1=1
	AND pof.[RunDate] = ( SELECT MAX( i.[RunDate] ) FROM INFORMATICS.dbo.CHATGPT_ECMPOF_ADULTWITHFAMILY_HOMELESS AS i WITH (NOLOCK) )

UNION ALL
SELECT pof.memid
,pof.[TargetPopulation]
FROM INFORMATICS.dbo.CHATGPT_ECMPOF_ADULTWITHOUTFAMILY_HOMELESS AS pof
	INNER JOIN #ECMEligible# AS ee ON pof.memid = ee.memid
WHERE 1=1
	AND pof.[RunDate] = ( SELECT MAX( i.[RunDate] ) FROM INFORMATICS.dbo.CHATGPT_ECMPOF_ADULTWITHOUTFAMILY_HOMELESS AS i WITH (NOLOCK) )
) AS pof -- CONCLUDE ...
GROUP BY memid,[TargetPopulation]

-- =====================================================================
	-- ALGORITHM (CHATGPT) POF -- ECM ENROLLED -- MEMBER x POF XREF (de-duplicated) --
-- =====================================================================
SELECT memid
,[TargetPopulation]
INTO #AlgorithmPOF_Enrolled_XREF#
FROM ( -- INITIATE ...
SELECT pof.memid
,pof.[TargetPopulation]
FROM INFORMATICS.dbo.CHATGPT_ECMPOF_CHILD_BIRTH_EQUITY AS pof
	INNER JOIN #ECMEnrolled# AS ee ON pof.memid = ee.memid
WHERE 1=1
	AND pof.[RunDate] = ( SELECT MAX( i.[RunDate] ) FROM INFORMATICS.dbo.CHATGPT_ECMPOF_CHILD_BIRTH_EQUITY AS i WITH (NOLOCK) )

UNION ALL
SELECT pof.memid
,pof.[TargetPopulation]
FROM INFORMATICS.dbo.CHATGPT_ECMPOF_CHILDWITHFAMILY_HOMELESS AS pof
	INNER JOIN #ECMEnrolled# AS ee ON pof.memid = ee.memid
WHERE 1=1
	AND pof.[RunDate] = ( SELECT MAX( i.[RunDate] ) FROM INFORMATICS.dbo.CHATGPT_ECMPOF_CHILDWITHFAMILY_HOMELESS AS i WITH (NOLOCK) )

UNION ALL
SELECT pof.memid
,pof.[TargetPopulation]
FROM INFORMATICS.dbo.CHATGPT_ECMPOF_CHILDWITHOUTFAMILY_HOMELESS AS pof
	INNER JOIN #ECMEnrolled# AS ee ON pof.memid = ee.memid
WHERE 1=1
	AND pof.[RunDate] = ( SELECT MAX( i.[RunDate] ) FROM INFORMATICS.dbo.CHATGPT_ECMPOF_CHILDWITHOUTFAMILY_HOMELESS AS i WITH (NOLOCK) )

UNION ALL
SELECT pof.memid
,pof.[TargetPopulation]
FROM INFORMATICS.dbo.CHATGPT_ECMPOF_CHILD_IPSNFED_HIGHUTIL AS pof
	INNER JOIN #ECMEnrolled# AS ee ON pof.memid = ee.memid
WHERE 1=1
	AND pof.[RunDate] = ( SELECT MAX( i.[RunDate] ) FROM INFORMATICS.dbo.CHATGPT_ECMPOF_CHILD_IPSNFED_HIGHUTIL AS i WITH (NOLOCK) )

UNION ALL
SELECT pof.memid
,pof.[TargetPopulation]
FROM INFORMATICS.dbo.CHATGPT_ECMPOF_CHILD_MHSMISUD AS pof
	INNER JOIN #ECMEnrolled# AS ee ON pof.memid = ee.memid
WHERE 1=1
	AND pof.[RunDate] = ( SELECT MAX( i.[RunDate] ) FROM INFORMATICS.dbo.CHATGPT_ECMPOF_CHILD_MHSMISUD AS i WITH (NOLOCK) )

UNION ALL
SELECT pof.memid
,pof.[TargetPopulation]
FROM INFORMATICS.dbo.CHATGPT_ECMPOF_CHILD_INCARCERATION AS pof
	INNER JOIN #ECMEnrolled# AS ee ON pof.memid = ee.memid
WHERE 1=1
	AND pof.[RunDate] = ( SELECT MAX( i.[RunDate] ) FROM INFORMATICS.dbo.CHATGPT_ECMPOF_CHILD_INCARCERATION AS i WITH (NOLOCK) )

UNION ALL
SELECT pof.memid
,pof.[TargetPopulation]
FROM INFORMATICS.dbo.CHATGPT_ECMPOF_CHILD_CCS AS pof
	INNER JOIN #ECMEnrolled# AS ee ON pof.memid = ee.memid
WHERE 1=1
	AND pof.[RunDate] = ( SELECT MAX( i.[RunDate] ) FROM INFORMATICS.dbo.CHATGPT_ECMPOF_CHILD_CCS AS i WITH (NOLOCK) )

UNION ALL
SELECT pof.memid
,pof.[TargetPopulation]
FROM INFORMATICS.dbo.CHATGPT_ECMPOF_CHILD_WELFARE AS pof
	INNER JOIN #ECMEnrolled# AS ee ON pof.memid = ee.memid
WHERE 1=1
	AND pof.[RunDate] = ( SELECT MAX( i.[RunDate] ) FROM INFORMATICS.dbo.CHATGPT_ECMPOF_CHILD_WELFARE AS i WITH (NOLOCK) )

UNION ALL
SELECT pof.memid
,pof.[TargetPopulation]
FROM INFORMATICS.dbo.CHATGPT_ECMPOF_ADULT_BIRTH_EQUITY AS pof
	INNER JOIN #ECMEnrolled# AS ee ON pof.memid = ee.memid
WHERE 1=1
	AND pof.[RunDate] = ( SELECT MAX( i.[RunDate] ) FROM INFORMATICS.dbo.CHATGPT_ECMPOF_ADULT_BIRTH_EQUITY AS i WITH (NOLOCK) )

UNION ALL
SELECT pof.memid
,pof.[TargetPopulation]
FROM INFORMATICS.dbo.CHATGPT_ECMPOF_ADULT_IPSNFED_HIGHUTIL AS pof
	INNER JOIN #ECMEnrolled# AS ee ON pof.memid = ee.memid
WHERE 1=1
	AND pof.[RunDate] = ( SELECT MAX( i.[RunDate] ) FROM INFORMATICS.dbo.CHATGPT_ECMPOF_ADULT_IPSNFED_HIGHUTIL AS i WITH (NOLOCK) )

UNION ALL
SELECT pof.memid
,pof.[TargetPopulation]
FROM INFORMATICS.dbo.CHATGPT_ECMPOF_ADULT_MHSMISUD AS pof
	INNER JOIN #ECMEnrolled# AS ee ON pof.memid = ee.memid
WHERE 1=1
	AND pof.[RunDate] = ( SELECT MAX( i.[RunDate] ) FROM INFORMATICS.dbo.CHATGPT_ECMPOF_ADULT_MHSMISUD AS i WITH (NOLOCK) )

UNION ALL
SELECT pof.memid
,pof.[TargetPopulation]
FROM INFORMATICS.dbo.CHATGPT_ECMPOF_ADULT_INCARCERATION AS pof
	INNER JOIN #ECMEnrolled# AS ee ON pof.memid = ee.memid
WHERE 1=1
	AND pof.[RunDate] = ( SELECT MAX( i.[RunDate] ) FROM INFORMATICS.dbo.CHATGPT_ECMPOF_ADULT_INCARCERATION AS i WITH (NOLOCK) )

UNION ALL
SELECT pof.memid
,pof.[TargetPopulation]
FROM INFORMATICS.dbo.CHATGPT_ECMPOF_ADULT_INSTITUTIONALIZATION AS pof
	INNER JOIN #ECMEnrolled# AS ee ON pof.memid = ee.memid
WHERE 1=1
	AND pof.[RunDate] = ( SELECT MAX( i.[RunDate] ) FROM INFORMATICS.dbo.CHATGPT_ECMPOF_ADULT_INSTITUTIONALIZATION AS i WITH (NOLOCK) )

UNION ALL
SELECT pof.memid
,pof.[TargetPopulation]
FROM INFORMATICS.dbo.CHATGPT_ECMPOF_ADULT_NURSING_TRANSITION AS pof
	INNER JOIN #ECMEnrolled# AS ee ON pof.memid = ee.memid
WHERE 1=1
	AND pof.[RunDate] = ( SELECT MAX( i.[RunDate] ) FROM INFORMATICS.dbo.CHATGPT_ECMPOF_ADULT_NURSING_TRANSITION AS i WITH (NOLOCK) )

UNION ALL
SELECT pof.memid
,pof.[TargetPopulation]
FROM INFORMATICS.dbo.CHATGPT_ECMPOF_ADULTWITHFAMILY_HOMELESS AS pof
	INNER JOIN #ECMEnrolled# AS ee ON pof.memid = ee.memid
WHERE 1=1
	AND pof.[RunDate] = ( SELECT MAX( i.[RunDate] ) FROM INFORMATICS.dbo.CHATGPT_ECMPOF_ADULTWITHFAMILY_HOMELESS AS i WITH (NOLOCK) )

UNION ALL
SELECT pof.memid
,pof.[TargetPopulation]
FROM INFORMATICS.dbo.CHATGPT_ECMPOF_ADULTWITHOUTFAMILY_HOMELESS AS pof
	INNER JOIN #ECMEnrolled# AS ee ON pof.memid = ee.memid
WHERE 1=1
	AND pof.[RunDate] = ( SELECT MAX( i.[RunDate] ) FROM INFORMATICS.dbo.CHATGPT_ECMPOF_ADULTWITHOUTFAMILY_HOMELESS AS i WITH (NOLOCK) )
) AS pof -- CONCLUDE ...
GROUP BY memid,[TargetPopulation]

-- =====================================================================
	-- ANSWER #1 -- TOTAL DE-DUPLICATED UNIQUE MEMBER COUNT --
	-- (this is the number that answers "how many unique members?") --
-- =====================================================================
SELECT ' ' AS 'ANSWER: TOTAL Unique Member Count (de-duplicated ACROSS all POFs)'
,[POF Algorithm Version]
,[Population]
,[Unique Member Count]
FROM (
	SELECT 'Existing POF' AS [POF Algorithm Version], 'ECM Eligible' AS [Population], COUNT(DISTINCT memid) AS [Unique Member Count] FROM #ExistingPOF_Eligible_XREF#
	UNION ALL
	SELECT 'Existing POF' AS [POF Algorithm Version], 'ECM Enrolled' AS [Population], COUNT(DISTINCT memid) FROM #ExistingPOF_Enrolled_XREF#
	UNION ALL
	SELECT 'Algorithm (ChatGPT) POF' AS [POF Algorithm Version], 'ECM Eligible' AS [Population], COUNT(DISTINCT memid) AS [Unique Member Count] FROM #AlgorithmPOF_Eligible_XREF#
	UNION ALL
	SELECT 'Algorithm (ChatGPT) POF' AS [POF Algorithm Version], 'ECM Enrolled' AS [Population], COUNT(DISTINCT memid) AS [Unique Member Count] FROM #AlgorithmPOF_Enrolled_XREF#
) AS summary

-- =====================================================================
	-- ANSWER #2 -- OVERLAP DISTRIBUTION --
	-- (this is the evidence: how many POFs does each member actually sit in) --
-- =====================================================================
SELECT ' ' AS 'Existing POF - ECM Eligible - # of POFs per member'
,[POF_Count]
,COUNT(*) AS [Number of Members]
FROM ( SELECT memid, COUNT(DISTINCT [TargetPopulation]) AS POF_Count FROM #ExistingPOF_Eligible_XREF# GROUP BY memid ) AS x
GROUP BY POF_Count
ORDER BY POF_Count

SELECT ' ' AS 'Existing POF - ECM Enrolled - # of POFs per member'
,[POF_Count]
,COUNT(*) AS [Number of Members]
FROM ( SELECT memid, COUNT(DISTINCT [TargetPopulation]) AS POF_Count FROM #ExistingPOF_Enrolled_XREF# GROUP BY memid ) AS x
GROUP BY POF_Count
ORDER BY POF_Count

SELECT ' ' AS 'Algorithm (ChatGPT) POF - ECM Eligible - # of POFs per member'
,[POF_Count]
,COUNT(*) AS [Number of Members]
FROM ( SELECT memid, COUNT(DISTINCT [TargetPopulation]) AS POF_Count FROM #AlgorithmPOF_Eligible_XREF# GROUP BY memid ) AS x
GROUP BY POF_Count
ORDER BY POF_Count

SELECT ' ' AS 'Algorithm (ChatGPT) POF - ECM Enrolled - # of POFs per member'
,[POF_Count]
,COUNT(*) AS [Number of Members]
FROM ( SELECT memid, COUNT(DISTINCT [TargetPopulation]) AS POF_Count FROM #AlgorithmPOF_Enrolled_XREF# GROUP BY memid ) AS x
GROUP BY POF_Count
ORDER BY POF_Count

-- =====================================================================
	-- OPTIONAL DETAIL -- which specific POFs overlap, for a sample member --
	-- swap in a real memid returned above with POF_Count >= 2 --
-- =====================================================================
SELECT bm.memid
,bm.HealthPlanid
,bm.[Member Name]
,COUNT(DISTINCT [TargetPopulation]) AS POF_Count 
FROM #ExistingPOF_Enrolled_XREF# AS e
	INNER JOIN INFORMATICS.dbo.uvw_BASELINE_MEMBERSHIP AS bm ON e.memid = bm.memid
GROUP BY bm.memid,bm.HealthPlanid,bm.[Member Name]
HAVING COUNT(DISTINCT e.[TargetPopulation]) > 1
ORDER BY COUNT(DISTINCT e.[TargetPopulation]) DESC

		SELECT ' ' AS 'Members with Multiple POFs: ',e.* 
		,bm.memid
		,bm.HealthPlanid
		,bm.[Member Name]
		FROM #ExistingPOF_Eligible_XREF# AS e
			INNER JOIN INFORMATICS.dbo.uvw_BASELINE_MEMBERSHIP AS bm ON e.memid = bm.memid
		WHERE 1=1
			AND e.memid = '1046568'
			ORDER BY e.[TargetPopulation]

SELECT bm.memid
,bm.HealthPlanid
,bm.[Member Name]
,COUNT(DISTINCT [TargetPopulation]) AS POF_Count 
FROM #AlgorithmPOF_Enrolled_XREF# AS e
	INNER JOIN INFORMATICS.dbo.uvw_BASELINE_MEMBERSHIP AS bm ON e.memid = bm.memid
GROUP BY bm.memid,bm.HealthPlanid,bm.[Member Name]
HAVING COUNT(DISTINCT e.[TargetPopulation]) > 1
ORDER BY COUNT(DISTINCT e.[TargetPopulation]) DESC

		SELECT ' ' AS 'Algorithm Members with Multiple POFs: ',e.* 
		,bm.memid
		,bm.HealthPlanid
		,bm.[Member Name]
		FROM #AlgorithmPOF_Eligible_XREF# AS e
			INNER JOIN INFORMATICS.dbo.uvw_BASELINE_MEMBERSHIP AS bm ON e.memid = bm.memid
		WHERE 1=1
			AND e.memid = '712320'
			ORDER BY e.[TargetPopulation]
