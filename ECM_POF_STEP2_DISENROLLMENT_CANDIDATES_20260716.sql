-- =====================================================================
	--  MODIFICATION(S) | CHANGE.LOG:
-- =====================================================================

-- C001: STEP 2, per DUB C 2.0 20260715 request. Flags BASELINE ECM Enrolled members, INFORMATICS.dbo.BASELINE_QNXT_ProviderPortal_ECM_ENROLLED, who qualify under 1 or more EXISTING POF tables, most current run, but qualify under ZERO ALGORITHM (CHATGPT) POF tables, most current run. This is the DISENROLLMENT candidate population JAG is expecting near 4000, DUB C 2.0 estimates near 1000

-- C002: Added a companion RETAINED group, members who lose 1 or more EXISTING POF but still qualify under at least 1 ALGORITHM POF, this is NOT a disenrollment, addition beyond the literal ask, included to help reconcile the 4000 vs 1000 gap between JAG and DUB C 2.0

-- C003: Added an INFORMATION_SCHEMA.COLUMNS pre-check for [RunDate] across all 33 tables before the main build, the 20260714 POF Provider effort discovered 5 of 17 tables were missing an assumed-common column, [RANGE NOTE(s)], this guards against the same risk recurring for [RunDate]

-- =====================================================================
	-- #STEP 2# -- ECM ENROLLED POPULATION FLAGGED FOR DISENROLLMENT UNDER ALGORITHM POF LOGIC --
-- =====================================================================
/* ASSUMPTION, please confirm before executing against production:

'ABSENT from the CHATGPT_ECMPOF_ tables' is interpreted here as ABSENT FROM ALL 16 algorithm tables, zero POF qualification under the new algorithm. A member retaining even 1 algorithm POF is NOT a disenrollment, they are still ECM Enrolled under the new logic, just under fewer POFs, see the RETAINED companion query below.

If instead 'absent from any' was meant literally, absent from at least 1 of the 16, nearly every member qualifies under only 1 or 2 POFs to begin with, so that reading would flag almost the entire BASELINE POPULATION AND DOES NOT MATCH a 4000-ish or 1000-ish expectation. Flagging this explicitly rather than silently assuming. */

-- =====================================================================
	-- PRE-CHECK, CONFIRM [RunDate] EXISTS ON ALL 33 POF TABLES BEFORE RUNNING THE MAIN BUILD --
-- =====================================================================
SELECT tbl.[Table Name]
,CASE
WHEN col.COLUMN_NAME IS NULL
THEN 'MISSING RunDate - DO NOT RUN MAIN BUILD UNTIL RESOLVED'
ELSE 'OK'
END AS [RunDate Column Check]
FROM ( SELECT 'ECMPOF_CHILD_BIRTH_EQUITY' AS [Table Name]
UNION ALL
SELECT 'ECMPOF_CHILD_HOMELESS' AS [Table Name]
UNION ALL
SELECT 'ECMPOF_CHILDWITHFAMILY_HOMELESS' AS [Table Name]
UNION ALL
SELECT 'ECMPOF_CHILDWITHOUTFAMILY_HOMELESS' AS [Table Name]
UNION ALL
SELECT 'ECMPOF_CHILD_IPSNFED_HIGHUTIL' AS [Table Name]
UNION ALL
SELECT 'ECMPOF_CHILD_MHSMISUD' AS [Table Name]
UNION ALL
SELECT 'ECMPOF_CHILD_INCARCERATION' AS [Table Name]
UNION ALL
SELECT 'ECMPOF_CHILD_CCS' AS [Table Name]
UNION ALL
SELECT 'ECMPOF_CHILD_WELFARE' AS [Table Name]
UNION ALL
SELECT 'ECMPOF_ADULT_BIRTH_EQUITY' AS [Table Name]
UNION ALL
SELECT 'ECMPOF_ADULT_IPSNFED_HIGHUTIL' AS [Table Name]
UNION ALL
SELECT 'ECMPOF_ADULT_MHSMISUD' AS [Table Name]
UNION ALL
SELECT 'ECMPOF_ADULT_INCARCERATION' AS [Table Name]
UNION ALL
SELECT 'ECMPOF_ADULT_INSTITUTIONALIZATION' AS [Table Name]
UNION ALL
SELECT 'ECMPOF_ADULT_NURSING_TRANSITION' AS [Table Name]
UNION ALL
SELECT 'ECMPOF_ADULTWITHFAMILY_HOMELESS' AS [Table Name]
UNION ALL
SELECT 'ECMPOF_ADULTWITHOUTFAMILY_HOMELESS' AS [Table Name]
UNION ALL
SELECT 'CHATGPT_ECMPOF_CHILD_BIRTH_EQUITY' AS [Table Name]
UNION ALL
SELECT 'CHATGPT_ECMPOF_CHILDWITHFAMILY_HOMELESS' AS [Table Name]
UNION ALL
SELECT 'CHATGPT_ECMPOF_CHILDWITHOUTFAMILY_HOMELESS' AS [Table Name]
UNION ALL
SELECT 'CHATGPT_ECMPOF_CHILD_IPSNFED_HIGHUTIL' AS [Table Name]
UNION ALL
SELECT 'CHATGPT_ECMPOF_CHILD_MHSMISUD' AS [Table Name]
UNION ALL
SELECT 'CHATGPT_ECMPOF_CHILD_INCARCERATION' AS [Table Name]
UNION ALL
SELECT 'CHATGPT_ECMPOF_CHILD_CCS' AS [Table Name]
UNION ALL
SELECT 'CHATGPT_ECMPOF_CHILD_WELFARE' AS [Table Name]
UNION ALL
SELECT 'CHATGPT_ECMPOF_ADULT_BIRTH_EQUITY' AS [Table Name]
UNION ALL
SELECT 'CHATGPT_ECMPOF_ADULT_IPSNFED_HIGHUTIL' AS [Table Name]
UNION ALL
SELECT 'CHATGPT_ECMPOF_ADULT_MHSMISUD' AS [Table Name]
UNION ALL
SELECT 'CHATGPT_ECMPOF_ADULT_INCARCERATION' AS [Table Name]
UNION ALL
SELECT 'CHATGPT_ECMPOF_ADULT_INSTITUTIONALIZATION' AS [Table Name]
UNION ALL
SELECT 'CHATGPT_ECMPOF_ADULT_NURSING_TRANSITION' AS [Table Name]
UNION ALL
SELECT 'CHATGPT_ECMPOF_ADULTWITHFAMILY_HOMELESS' AS [Table Name]
UNION ALL
SELECT 'CHATGPT_ECMPOF_ADULTWITHOUTFAMILY_HOMELESS' AS [Table Name] ) AS tbl
	LEFT JOIN INFORMATION_SCHEMA.COLUMNS AS col ON col.TABLE_SCHEMA = 'dbo' AND col.TABLE_NAME = tbl.[Table Name] AND col.COLUMN_NAME = 'RunDate'
ORDER BY [RunDate Column Check] DESC
	,tbl.[Table Name]

-- =====================================================================
	-- Error Trapping: Check If Permanent Table(s) Already Exist(s) And Drop If Applicable --
-- =====================================================================
DROP TABLE IF EXISTS INFORMATICS.dbo.STEP2_DISENROLLMENT_CANDIDATES;
DROP TABLE IF EXISTS INFORMATICS.dbo.STEP2_RETAINED_FEWER_POFS;
DROP TABLE IF EXISTS #ExistingPOF_Current#;
DROP TABLE IF EXISTS #AlgorithmPOF_Current#;
DROP TABLE IF EXISTS #ExistingPOF_MemberList#;
DROP TABLE IF EXISTS #AlgorithmPOF_MemberList#;

-- =====================================================================
	-- #ExistingPOF_Current# -- MOST CURRENT RUN, ALL 17 EXISTING POF TABLES --
-- =====================================================================
-- =====================================================================
	-- ECMPOF_CHILD_BIRTH_EQUITY --
-- =====================================================================
SELECT DISTINCT pof.memid
,'ECMPOF_CHILD_BIRTH_EQUITY' AS [POF Table]
INTO #ExistingPOF_Current#
FROM INFORMATICS.dbo.ECMPOF_CHILD_BIRTH_EQUITY (NOLOCK) AS pof
WHERE 1=1
	AND pof.[RunDate] = ( SELECT MAX(i.[RunDate]) FROM INFORMATICS.dbo.ECMPOF_CHILD_BIRTH_EQUITY AS i (NOLOCK) )
UNION ALL
-- =====================================================================
	-- ECMPOF_CHILD_HOMELESS --
-- =====================================================================
/* SELECT DISTINCT pof.memid
,'ECMPOF_CHILD_HOMELESS' AS [POF Table]
FROM INFORMATICS.dbo.ECMPOF_CHILD_HOMELESS (NOLOCK) AS pof
WHERE 1=1
	AND pof.[RunDate] = ( SELECT MAX(i.[RunDate]) FROM INFORMATICS.dbo.ECMPOF_CHILD_HOMELESS AS i (NOLOCK) )
UNION ALL */
-- =====================================================================
	-- ECMPOF_CHILDWITHFAMILY_HOMELESS --
-- =====================================================================
SELECT DISTINCT pof.memid
,'ECMPOF_CHILDWITHFAMILY_HOMELESS' AS [POF Table]
FROM INFORMATICS.dbo.ECMPOF_CHILDWITHFAMILY_HOMELESS (NOLOCK) AS pof
WHERE 1=1
	AND pof.[RunDate] = ( SELECT MAX(i.[RunDate]) FROM INFORMATICS.dbo.ECMPOF_CHILDWITHFAMILY_HOMELESS AS i (NOLOCK) )
UNION ALL
-- =====================================================================
	-- ECMPOF_CHILDWITHOUTFAMILY_HOMELESS --
-- =====================================================================
SELECT DISTINCT pof.memid
,'ECMPOF_CHILDWITHOUTFAMILY_HOMELESS' AS [POF Table]
FROM INFORMATICS.dbo.ECMPOF_CHILDWITHOUTFAMILY_HOMELESS (NOLOCK) AS pof
WHERE 1=1
	AND pof.[RunDate] = ( SELECT MAX(i.[RunDate]) FROM INFORMATICS.dbo.ECMPOF_CHILDWITHOUTFAMILY_HOMELESS AS i (NOLOCK) )
UNION ALL
-- =====================================================================
	-- ECMPOF_CHILD_IPSNFED_HIGHUTIL --
-- =====================================================================
SELECT DISTINCT pof.memid
,'ECMPOF_CHILD_IPSNFED_HIGHUTIL' AS [POF Table]
FROM INFORMATICS.dbo.ECMPOF_CHILD_IPSNFED_HIGHUTIL (NOLOCK) AS pof
WHERE 1=1
	AND pof.[RunDate] = ( SELECT MAX(i.[RunDate]) FROM INFORMATICS.dbo.ECMPOF_CHILD_IPSNFED_HIGHUTIL AS i (NOLOCK) )
UNION ALL
-- =====================================================================
	-- ECMPOF_CHILD_MHSMISUD --
-- =====================================================================
SELECT DISTINCT pof.memid
,'ECMPOF_CHILD_MHSMISUD' AS [POF Table]
FROM INFORMATICS.dbo.ECMPOF_CHILD_MHSMISUD (NOLOCK) AS pof
WHERE 1=1
	AND pof.[RunDate] = ( SELECT MAX(i.[RunDate]) FROM INFORMATICS.dbo.ECMPOF_CHILD_MHSMISUD AS i (NOLOCK) )
UNION ALL
-- =====================================================================
	-- ECMPOF_CHILD_INCARCERATION --
-- =====================================================================
SELECT DISTINCT pof.memid
,'ECMPOF_CHILD_INCARCERATION' AS [POF Table]
FROM INFORMATICS.dbo.ECMPOF_CHILD_INCARCERATION (NOLOCK) AS pof
WHERE 1=1
	AND pof.[RunDate] = ( SELECT MAX(i.[RunDate]) FROM INFORMATICS.dbo.ECMPOF_CHILD_INCARCERATION AS i (NOLOCK) )
UNION ALL
-- =====================================================================
	-- ECMPOF_CHILD_CCS --
-- =====================================================================
SELECT DISTINCT pof.memid
,'ECMPOF_CHILD_CCS' AS [POF Table]
FROM INFORMATICS.dbo.ECMPOF_CHILD_CCS (NOLOCK) AS pof
WHERE 1=1
	AND pof.[RunDate] = ( SELECT MAX(i.[RunDate]) FROM INFORMATICS.dbo.ECMPOF_CHILD_CCS AS i (NOLOCK) )
UNION ALL
-- =====================================================================
	-- ECMPOF_CHILD_WELFARE --
-- =====================================================================
SELECT DISTINCT pof.memid
,'ECMPOF_CHILD_WELFARE' AS [POF Table]
FROM INFORMATICS.dbo.ECMPOF_CHILD_WELFARE (NOLOCK) AS pof
WHERE 1=1
	AND pof.[RunDate] = ( SELECT MAX(i.[RunDate]) FROM INFORMATICS.dbo.ECMPOF_CHILD_WELFARE AS i (NOLOCK) )
UNION ALL
-- =====================================================================
	-- ECMPOF_ADULT_BIRTH_EQUITY --
-- =====================================================================
SELECT DISTINCT pof.memid
,'ECMPOF_ADULT_BIRTH_EQUITY' AS [POF Table]
FROM INFORMATICS.dbo.ECMPOF_ADULT_BIRTH_EQUITY (NOLOCK) AS pof
WHERE 1=1
	AND pof.[RunDate] = ( SELECT MAX(i.[RunDate]) FROM INFORMATICS.dbo.ECMPOF_ADULT_BIRTH_EQUITY AS i (NOLOCK) )
UNION ALL
-- =====================================================================
	-- ECMPOF_ADULT_IPSNFED_HIGHUTIL --
-- =====================================================================
SELECT DISTINCT pof.memid
,'ECMPOF_ADULT_IPSNFED_HIGHUTIL' AS [POF Table]
FROM INFORMATICS.dbo.ECMPOF_ADULT_IPSNFED_HIGHUTIL (NOLOCK) AS pof
WHERE 1=1
	AND pof.[RunDate] = ( SELECT MAX(i.[RunDate]) FROM INFORMATICS.dbo.ECMPOF_ADULT_IPSNFED_HIGHUTIL AS i (NOLOCK) )
UNION ALL
-- =====================================================================
	-- ECMPOF_ADULT_MHSMISUD --
-- =====================================================================
SELECT DISTINCT pof.memid
,'ECMPOF_ADULT_MHSMISUD' AS [POF Table]
FROM INFORMATICS.dbo.ECMPOF_ADULT_MHSMISUD (NOLOCK) AS pof
WHERE 1=1
	AND pof.[RunDate] = ( SELECT MAX(i.[RunDate]) FROM INFORMATICS.dbo.ECMPOF_ADULT_MHSMISUD AS i (NOLOCK) )
UNION ALL
-- =====================================================================
	-- ECMPOF_ADULT_INCARCERATION --
-- =====================================================================
SELECT DISTINCT pof.memid
,'ECMPOF_ADULT_INCARCERATION' AS [POF Table]
FROM INFORMATICS.dbo.ECMPOF_ADULT_INCARCERATION (NOLOCK) AS pof
WHERE 1=1
	AND pof.[RunDate] = ( SELECT MAX(i.[RunDate]) FROM INFORMATICS.dbo.ECMPOF_ADULT_INCARCERATION AS i (NOLOCK) )
UNION ALL
-- =====================================================================
	-- ECMPOF_ADULT_INSTITUTIONALIZATION --
-- =====================================================================
SELECT DISTINCT pof.memid
,'ECMPOF_ADULT_INSTITUTIONALIZATION' AS [POF Table]
FROM INFORMATICS.dbo.ECMPOF_ADULT_INSTITUTIONALIZATION (NOLOCK) AS pof
WHERE 1=1
	AND pof.[RunDate] = ( SELECT MAX(i.[RunDate]) FROM INFORMATICS.dbo.ECMPOF_ADULT_INSTITUTIONALIZATION AS i (NOLOCK) )
UNION ALL
-- =====================================================================
	-- ECMPOF_ADULT_NURSING_TRANSITION --
-- =====================================================================
SELECT DISTINCT pof.memid
,'ECMPOF_ADULT_NURSING_TRANSITION' AS [POF Table]
FROM INFORMATICS.dbo.ECMPOF_ADULT_NURSING_TRANSITION (NOLOCK) AS pof
WHERE 1=1
	AND pof.[RunDate] = ( SELECT MAX(i.[RunDate]) FROM INFORMATICS.dbo.ECMPOF_ADULT_NURSING_TRANSITION AS i (NOLOCK) )
UNION ALL
-- =====================================================================
	-- ECMPOF_ADULTWITHFAMILY_HOMELESS --
-- =====================================================================
SELECT DISTINCT pof.memid
,'ECMPOF_ADULTWITHFAMILY_HOMELESS' AS [POF Table]
FROM INFORMATICS.dbo.ECMPOF_ADULTWITHFAMILY_HOMELESS (NOLOCK) AS pof
WHERE 1=1
	AND pof.[RunDate] = ( SELECT MAX(i.[RunDate]) FROM INFORMATICS.dbo.ECMPOF_ADULTWITHFAMILY_HOMELESS AS i (NOLOCK) )
UNION ALL
-- =====================================================================
	-- ECMPOF_ADULTWITHOUTFAMILY_HOMELESS --
-- =====================================================================
SELECT DISTINCT pof.memid
,'ECMPOF_ADULTWITHOUTFAMILY_HOMELESS' AS [POF Table]
FROM INFORMATICS.dbo.ECMPOF_ADULTWITHOUTFAMILY_HOMELESS (NOLOCK) AS pof
WHERE 1=1
	AND pof.[RunDate] = ( SELECT MAX(i.[RunDate]) FROM INFORMATICS.dbo.ECMPOF_ADULTWITHOUTFAMILY_HOMELESS AS i (NOLOCK) )







-- =====================================================================
	-- #AlgorithmPOF_Current# -- MOST CURRENT RUN, ALL 16 ALGORITHM (CHATGPT) POF TABLES --
-- =====================================================================
-- =====================================================================
	-- CHATGPT_ECMPOF_CHILD_BIRTH_EQUITY --
-- =====================================================================
SELECT DISTINCT pof.memid
,'CHATGPT_ECMPOF_CHILD_BIRTH_EQUITY' AS [POF Table]
INTO #AlgorithmPOF_Current#
FROM INFORMATICS.dbo.CHATGPT_ECMPOF_CHILD_BIRTH_EQUITY (NOLOCK) AS pof
WHERE 1=1
	AND pof.[RunDate] = ( SELECT MAX(i.[RunDate]) FROM INFORMATICS.dbo.CHATGPT_ECMPOF_CHILD_BIRTH_EQUITY AS i (NOLOCK) )
UNION ALL
-- =====================================================================
	-- CHATGPT_ECMPOF_CHILDWITHFAMILY_HOMELESS --
-- =====================================================================
SELECT DISTINCT pof.memid
,'CHATGPT_ECMPOF_CHILDWITHFAMILY_HOMELESS' AS [POF Table]
FROM INFORMATICS.dbo.CHATGPT_ECMPOF_CHILDWITHFAMILY_HOMELESS (NOLOCK) AS pof
WHERE 1=1
	AND pof.[RunDate] = ( SELECT MAX(i.[RunDate]) FROM INFORMATICS.dbo.CHATGPT_ECMPOF_CHILDWITHFAMILY_HOMELESS AS i (NOLOCK) )
UNION ALL
-- =====================================================================
	-- CHATGPT_ECMPOF_CHILDWITHOUTFAMILY_HOMELESS --
-- =====================================================================
SELECT DISTINCT pof.memid
,'CHATGPT_ECMPOF_CHILDWITHOUTFAMILY_HOMELESS' AS [POF Table]
FROM INFORMATICS.dbo.CHATGPT_ECMPOF_CHILDWITHOUTFAMILY_HOMELESS (NOLOCK) AS pof
WHERE 1=1
	AND pof.[RunDate] = ( SELECT MAX(i.[RunDate]) FROM INFORMATICS.dbo.CHATGPT_ECMPOF_CHILDWITHOUTFAMILY_HOMELESS AS i (NOLOCK) )
UNION ALL
-- =====================================================================
	-- CHATGPT_ECMPOF_CHILD_IPSNFED_HIGHUTIL --
-- =====================================================================
SELECT DISTINCT pof.memid
,'CHATGPT_ECMPOF_CHILD_IPSNFED_HIGHUTIL' AS [POF Table]
FROM INFORMATICS.dbo.CHATGPT_ECMPOF_CHILD_IPSNFED_HIGHUTIL (NOLOCK) AS pof
WHERE 1=1
	AND pof.[RunDate] = ( SELECT MAX(i.[RunDate]) FROM INFORMATICS.dbo.CHATGPT_ECMPOF_CHILD_IPSNFED_HIGHUTIL AS i (NOLOCK) )
UNION ALL
-- =====================================================================
	-- CHATGPT_ECMPOF_CHILD_MHSMISUD --
-- =====================================================================
SELECT DISTINCT pof.memid
,'CHATGPT_ECMPOF_CHILD_MHSMISUD' AS [POF Table]
FROM INFORMATICS.dbo.CHATGPT_ECMPOF_CHILD_MHSMISUD (NOLOCK) AS pof
WHERE 1=1
	AND pof.[RunDate] = ( SELECT MAX(i.[RunDate]) FROM INFORMATICS.dbo.CHATGPT_ECMPOF_CHILD_MHSMISUD AS i (NOLOCK) )
UNION ALL
-- =====================================================================
	-- CHATGPT_ECMPOF_CHILD_INCARCERATION --
-- =====================================================================
SELECT DISTINCT pof.memid
,'CHATGPT_ECMPOF_CHILD_INCARCERATION' AS [POF Table]
FROM INFORMATICS.dbo.CHATGPT_ECMPOF_CHILD_INCARCERATION (NOLOCK) AS pof
WHERE 1=1
	AND pof.[RunDate] = ( SELECT MAX(i.[RunDate]) FROM INFORMATICS.dbo.CHATGPT_ECMPOF_CHILD_INCARCERATION AS i (NOLOCK) )
UNION ALL
-- =====================================================================
	-- CHATGPT_ECMPOF_CHILD_CCS --
-- =====================================================================
SELECT DISTINCT pof.memid
,'CHATGPT_ECMPOF_CHILD_CCS' AS [POF Table]
FROM INFORMATICS.dbo.CHATGPT_ECMPOF_CHILD_CCS (NOLOCK) AS pof
WHERE 1=1
	AND pof.[RunDate] = ( SELECT MAX(i.[RunDate]) FROM INFORMATICS.dbo.CHATGPT_ECMPOF_CHILD_CCS AS i (NOLOCK) )
UNION ALL
-- =====================================================================
	-- CHATGPT_ECMPOF_CHILD_WELFARE --
-- =====================================================================
SELECT DISTINCT pof.memid
,'CHATGPT_ECMPOF_CHILD_WELFARE' AS [POF Table]
FROM INFORMATICS.dbo.CHATGPT_ECMPOF_CHILD_WELFARE (NOLOCK) AS pof
WHERE 1=1
	AND pof.[RunDate] = ( SELECT MAX(i.[RunDate]) FROM INFORMATICS.dbo.CHATGPT_ECMPOF_CHILD_WELFARE AS i (NOLOCK) )
UNION ALL
-- =====================================================================
	-- CHATGPT_ECMPOF_ADULT_BIRTH_EQUITY --
-- =====================================================================
SELECT DISTINCT pof.memid
,'CHATGPT_ECMPOF_ADULT_BIRTH_EQUITY' AS [POF Table]
FROM INFORMATICS.dbo.CHATGPT_ECMPOF_ADULT_BIRTH_EQUITY (NOLOCK) AS pof
WHERE 1=1
	AND pof.[RunDate] = ( SELECT MAX(i.[RunDate]) FROM INFORMATICS.dbo.CHATGPT_ECMPOF_ADULT_BIRTH_EQUITY AS i (NOLOCK) )
UNION ALL
-- =====================================================================
	-- CHATGPT_ECMPOF_ADULT_IPSNFED_HIGHUTIL --
-- =====================================================================
SELECT DISTINCT pof.memid
,'CHATGPT_ECMPOF_ADULT_IPSNFED_HIGHUTIL' AS [POF Table]
FROM INFORMATICS.dbo.CHATGPT_ECMPOF_ADULT_IPSNFED_HIGHUTIL (NOLOCK) AS pof
WHERE 1=1
	AND pof.[RunDate] = ( SELECT MAX(i.[RunDate]) FROM INFORMATICS.dbo.CHATGPT_ECMPOF_ADULT_IPSNFED_HIGHUTIL AS i (NOLOCK) )
UNION ALL
-- =====================================================================
	-- CHATGPT_ECMPOF_ADULT_MHSMISUD --
-- =====================================================================
SELECT DISTINCT pof.memid
,'CHATGPT_ECMPOF_ADULT_MHSMISUD' AS [POF Table]
FROM INFORMATICS.dbo.CHATGPT_ECMPOF_ADULT_MHSMISUD (NOLOCK) AS pof
WHERE 1=1
	AND pof.[RunDate] = ( SELECT MAX(i.[RunDate]) FROM INFORMATICS.dbo.CHATGPT_ECMPOF_ADULT_MHSMISUD AS i (NOLOCK) )
UNION ALL
-- =====================================================================
	-- CHATGPT_ECMPOF_ADULT_INCARCERATION --
-- =====================================================================
SELECT DISTINCT pof.memid
,'CHATGPT_ECMPOF_ADULT_INCARCERATION' AS [POF Table]
FROM INFORMATICS.dbo.CHATGPT_ECMPOF_ADULT_INCARCERATION (NOLOCK) AS pof
WHERE 1=1
	AND pof.[RunDate] = ( SELECT MAX(i.[RunDate]) FROM INFORMATICS.dbo.CHATGPT_ECMPOF_ADULT_INCARCERATION AS i (NOLOCK) )
UNION ALL
-- =====================================================================
	-- CHATGPT_ECMPOF_ADULT_INSTITUTIONALIZATION --
-- =====================================================================
SELECT DISTINCT pof.memid
,'CHATGPT_ECMPOF_ADULT_INSTITUTIONALIZATION' AS [POF Table]
FROM INFORMATICS.dbo.CHATGPT_ECMPOF_ADULT_INSTITUTIONALIZATION (NOLOCK) AS pof
WHERE 1=1
	AND pof.[RunDate] = ( SELECT MAX(i.[RunDate]) FROM INFORMATICS.dbo.CHATGPT_ECMPOF_ADULT_INSTITUTIONALIZATION AS i (NOLOCK) )
UNION ALL
-- =====================================================================
	-- CHATGPT_ECMPOF_ADULT_NURSING_TRANSITION --
-- =====================================================================
SELECT DISTINCT pof.memid
,'CHATGPT_ECMPOF_ADULT_NURSING_TRANSITION' AS [POF Table]
FROM INFORMATICS.dbo.CHATGPT_ECMPOF_ADULT_NURSING_TRANSITION (NOLOCK) AS pof
WHERE 1=1
	AND pof.[RunDate] = ( SELECT MAX(i.[RunDate]) FROM INFORMATICS.dbo.CHATGPT_ECMPOF_ADULT_NURSING_TRANSITION AS i (NOLOCK) )
UNION ALL
-- =====================================================================
	-- CHATGPT_ECMPOF_ADULTWITHFAMILY_HOMELESS --
-- =====================================================================
SELECT DISTINCT pof.memid
,'CHATGPT_ECMPOF_ADULTWITHFAMILY_HOMELESS' AS [POF Table]
FROM INFORMATICS.dbo.CHATGPT_ECMPOF_ADULTWITHFAMILY_HOMELESS (NOLOCK) AS pof
WHERE 1=1
	AND pof.[RunDate] = ( SELECT MAX(i.[RunDate]) FROM INFORMATICS.dbo.CHATGPT_ECMPOF_ADULTWITHFAMILY_HOMELESS AS i (NOLOCK) )
UNION ALL
-- =====================================================================
	-- CHATGPT_ECMPOF_ADULTWITHOUTFAMILY_HOMELESS --
-- =====================================================================
SELECT DISTINCT pof.memid
,'CHATGPT_ECMPOF_ADULTWITHOUTFAMILY_HOMELESS' AS [POF Table]
FROM INFORMATICS.dbo.CHATGPT_ECMPOF_ADULTWITHOUTFAMILY_HOMELESS (NOLOCK) AS pof
WHERE 1=1
	AND pof.[RunDate] = ( SELECT MAX(i.[RunDate]) FROM INFORMATICS.dbo.CHATGPT_ECMPOF_ADULTWITHOUTFAMILY_HOMELESS AS i (NOLOCK) )







-- =====================================================================
	-- #ExistingPOF_MemberList# -- ONE ROW PER MEMBER, WHICH EXISTING POF(s) MATCHED --
-- =====================================================================
SELECT existing.memid
,STRING_AGG(existing.[POF Table],'|') AS [Existing POF Matches]
,COUNT(DISTINCT existing.[POF Table]) AS [Existing POF Count]
INTO #ExistingPOF_MemberList#
FROM #ExistingPOF_Current# AS existing
GROUP BY existing.memid

-- =====================================================================
	-- #AlgorithmPOF_MemberList# -- ONE ROW PER MEMBER, WHICH ALGORITHM POF(s) MATCHED --
-- =====================================================================
SELECT algo.memid
,STRING_AGG(algo.[POF Table],'|') AS [Algorithm POF Matches]
,COUNT(DISTINCT algo.[POF Table]) AS [Algorithm POF Count]
INTO #AlgorithmPOF_MemberList#
FROM #AlgorithmPOF_Current# AS algo
GROUP BY algo.memid

-- =====================================================================
	-- STEP2_DISENROLLMENT_CANDIDATES -- IN BASELINE, IN >=1 EXISTING POF, IN 0 ALGORITHM POF --
-- =====================================================================
SELECT DISTINCT base.memid
,base.[DOE (Date of Entry)]
,base.MEMBER_AGE
,base.EnrollEffDate
,base.EnrollTermDate
,existing.[Existing POF Matches]
,existing.[Existing POF Count]
INTO INFORMATICS.dbo.STEP2_DISENROLLMENT_CANDIDATES
FROM INFORMATICS.dbo.BASELINE_QNXT_ProviderPortal_ECM_ENROLLED (NOLOCK) AS base
	INNER JOIN #ExistingPOF_MemberList# (NOLOCK) AS existing ON base.memid = existing.memid
WHERE 1=1
	AND base.ROWNUMBER_Enrolled = 1 -- dedup, per the 20260715 BASELINE review, memid plus EnrollEffDate produced duplicate rows in the raw memberattribute source
	AND NOT EXISTS ( SELECT 1 FROM #AlgorithmPOF_MemberList# AS algo WHERE 1=1 AND algo.memid = base.memid )

	-- CHECK FOR DUP(S):
SELECT ' ' AS 'SHOULD RETURN 0 ROWS - DUP Validation',*
FROM INFORMATICS.dbo.STEP2_DISENROLLMENT_CANDIDATES
WHERE 1=1
	AND memid IN
	( -- INITIATE ...
	SELECT memid
	FROM INFORMATICS.dbo.STEP2_DISENROLLMENT_CANDIDATES AS dup
	GROUP BY memid -- Duplication Driver
	HAVING COUNT(1)>1
	) -- CONCLUDE ...

-- =====================================================================
	-- STEP2_RETAINED_FEWER_POFS -- IN BASELINE, IN >=1 EXISTING POF, STILL IN >=1 ALGORITHM POF --
-- =====================================================================
-- C002: NOT a disenrollment. Included to help reconcile JAG's 4000 expectation against DUB C 2.0 1000 estimate, this group lost SOME POF qualifications under the algorithm but did not lose ECM Enrolled status entirely ... PARTIAL DISENROLLMENT CANDIDATES
SELECT DISTINCT base.memid
,base.[DOE (Date of Entry)]
,base.MEMBER_AGE
,base.EnrollEffDate
,base.EnrollTermDate
,existing.[Existing POF Matches]
,existing.[Existing POF Count]
,algo.[Algorithm POF Matches]
,algo.[Algorithm POF Count]
INTO INFORMATICS.dbo.STEP2_RETAINED_FEWER_POFS
FROM INFORMATICS.dbo.BASELINE_QNXT_ProviderPortal_ECM_ENROLLED (NOLOCK) AS base
	INNER JOIN #ExistingPOF_MemberList# (NOLOCK) AS existing ON base.memid = existing.memid
	INNER JOIN #AlgorithmPOF_MemberList# (NOLOCK) AS algo ON base.memid = algo.memid
WHERE 1=1
	AND base.ROWNUMBER_Enrolled = 1
	AND existing.[Existing POF Count] > algo.[Algorithm POF Count] -- lost at least 1 POF, but not all

	-- CHECK FOR DUP(S):
SELECT ' ' AS 'SHOULD RETURN 0 ROWS - DUP Validation',*
FROM INFORMATICS.dbo.STEP2_RETAINED_FEWER_POFS
WHERE 1=1
	AND memid IN
	( -- INITIATE ...
	SELECT memid
	FROM INFORMATICS.dbo.STEP2_RETAINED_FEWER_POFS AS dup
	GROUP BY memid -- Duplication Driver
	HAVING COUNT(1)>1
	) -- CONCLUDE ...

-- =====================================================================
	-- SANITY SUMMARY -- COMPARE AGAINST JAG'S ~4000 EXPECTATION AND DUB C 2.0 ~1000 ESTIMATE --
-- =====================================================================
SELECT ( SELECT COUNT(DISTINCT memid) FROM INFORMATICS.dbo.BASELINE_QNXT_ProviderPortal_ECM_ENROLLED ) AS [BASELINE ECM Enrolled]
,( SELECT COUNT(DISTINCT memid) FROM INFORMATICS.dbo.STEP2_DISENROLLMENT_CANDIDATES ) AS [DISENROLLMENT Candidates - 0 Algorithm POF]
,( SELECT COUNT(DISTINCT memid) FROM INFORMATICS.dbo.STEP2_RETAINED_FEWER_POFS ) AS [RETAINED - Lost Some POFs Not All]
