-- =====================================================================
	-- POF ECM PROVIDER SUMMARY 20260714 -- companion summary version to POF ECM PROVIDER 20260714.sql --
	-- Sir Allan Sombillo / Sir Yousaf Farook, on behalf of JAG, do NOT want memberattribute used --
	-- Qualifying gate IS ProviderPortal.ECM.Member directly (m.ISECM = 1 AND
	-- m.EnrollmentStatus = 'Assigned'), joined ON pof.memid = m.MemberId, matching the CODE Malik
	-- supplied 20260714 --
	-- One 'Unique Member Count by ECM Provider' block per POF table, matching the exact GROUP BY
	-- TargetPopulation, ProviderID, NPI, fullname structure Malik supplied 20260714, generalized
	-- across all 17 existing / 16 algorithm POF tables --
	-- Result-set titles include the source table name AS a navigability aid across the 33 SSMS result
	-- tabs, matching the same convention used IN POF ECM PROVIDER 20260714.sql, flagged AS a value-ADD
	-- beyond the literal supplied CODE --
	-- This IS the per-table companion to EXISTING POF v ALGORITHM POF ECM COUNTS 20260714.sql, which
	-- covers the SAME counts already, unioned across all tables into 2 combined result sets rather than
	-- 33 separate ones. Kept AS a separate file per Malik's request for this specific block style,
	-- NOT a replacement for that script --
-- =====================================================================

-- =====================================================================
	-- ECMPOF_CHILD_BIRTH_EQUITY -- EXISTING LOGIC --
-- =====================================================================
SELECT ' ' AS 'EXISTING LOGIC Unique Member Count by ECM Provider - ECMPOF_CHILD_BIRTH_EQUITY'
,pof.TargetPopulation
,mpa.ProviderID
,prov.NPI
,prov.fullname AS [ECM Provider]
,COUNT(DISTINCT(pof.memid)) AS [Unique Member Count]
FROM INFORMATICS.dbo.ECMPOF_CHILD_BIRTH_EQUITY (NOLOCK) AS pof -- EXISTING LOGIC
	INNER JOIN ProviderPortal.ECM.Member (NOLOCK) AS m ON pof.memid = m.MemberId
	LEFT JOIN [ProviderPortal].[ECM].[MemberProviderAssigment] (NOLOCK) AS mpa ON pof.memid = mpa.MemberId
		LEFT JOIN HMOPROD_PLANDATA.dbo.[provider] (NOLOCK) AS prov ON mpa.ProviderID = prov.provid
WHERE 1=1
	AND pof.[RunDate] = ( SELECT MAX(i.[RunDate]) FROM INFORMATICS.dbo.ECMPOF_CHILD_BIRTH_EQUITY AS i WITH (NOLOCK) )
	AND m.ISECM = 1
	AND m.EnrollmentStatus = 'Assigned'
GROUP BY pof.TargetPopulation
,mpa.ProviderID
,prov.NPI
,prov.fullname

-- =====================================================================
	-- ECMPOF_CHILD_HOMELESS -- EXISTING LOGIC --
-- =====================================================================
SELECT ' ' AS 'EXISTING LOGIC Unique Member Count by ECM Provider - ECMPOF_CHILD_HOMELESS'
,pof.TargetPopulation
,mpa.ProviderID
,prov.NPI
,prov.fullname AS [ECM Provider]
,COUNT(DISTINCT(pof.memid)) AS [Unique Member Count]
FROM INFORMATICS.dbo.ECMPOF_CHILD_HOMELESS (NOLOCK) AS pof -- EXISTING LOGIC
	INNER JOIN ProviderPortal.ECM.Member (NOLOCK) AS m ON pof.memid = m.MemberId
	LEFT JOIN [ProviderPortal].[ECM].[MemberProviderAssigment] (NOLOCK) AS mpa ON pof.memid = mpa.MemberId
		LEFT JOIN HMOPROD_PLANDATA.dbo.[provider] (NOLOCK) AS prov ON mpa.ProviderID = prov.provid
WHERE 1=1
	AND pof.[RunDate] = ( SELECT MAX(i.[RunDate]) FROM INFORMATICS.dbo.ECMPOF_CHILD_HOMELESS AS i WITH (NOLOCK) )
	AND m.ISECM = 1
	AND m.EnrollmentStatus = 'Assigned'
GROUP BY pof.TargetPopulation
,mpa.ProviderID
,prov.NPI
,prov.fullname

-- =====================================================================
	-- ECMPOF_CHILDWITHFAMILY_HOMELESS -- EXISTING LOGIC --
-- =====================================================================
SELECT ' ' AS 'EXISTING LOGIC Unique Member Count by ECM Provider - ECMPOF_CHILDWITHFAMILY_HOMELESS'
,pof.TargetPopulation
,mpa.ProviderID
,prov.NPI
,prov.fullname AS [ECM Provider]
,COUNT(DISTINCT(pof.memid)) AS [Unique Member Count]
FROM INFORMATICS.dbo.ECMPOF_CHILDWITHFAMILY_HOMELESS (NOLOCK) AS pof -- EXISTING LOGIC
	INNER JOIN ProviderPortal.ECM.Member (NOLOCK) AS m ON pof.memid = m.MemberId
	LEFT JOIN [ProviderPortal].[ECM].[MemberProviderAssigment] (NOLOCK) AS mpa ON pof.memid = mpa.MemberId
		LEFT JOIN HMOPROD_PLANDATA.dbo.[provider] (NOLOCK) AS prov ON mpa.ProviderID = prov.provid
WHERE 1=1
	AND pof.[RunDate] = ( SELECT MAX(i.[RunDate]) FROM INFORMATICS.dbo.ECMPOF_CHILDWITHFAMILY_HOMELESS AS i WITH (NOLOCK) )
	AND m.ISECM = 1
	AND m.EnrollmentStatus = 'Assigned'
GROUP BY pof.TargetPopulation
,mpa.ProviderID
,prov.NPI
,prov.fullname

-- =====================================================================
	-- ECMPOF_CHILDWITHOUTFAMILY_HOMELESS -- EXISTING LOGIC --
-- =====================================================================
SELECT ' ' AS 'EXISTING LOGIC Unique Member Count by ECM Provider - ECMPOF_CHILDWITHOUTFAMILY_HOMELESS'
,pof.TargetPopulation
,mpa.ProviderID
,prov.NPI
,prov.fullname AS [ECM Provider]
,COUNT(DISTINCT(pof.memid)) AS [Unique Member Count]
FROM INFORMATICS.dbo.ECMPOF_CHILDWITHOUTFAMILY_HOMELESS (NOLOCK) AS pof -- EXISTING LOGIC
	INNER JOIN ProviderPortal.ECM.Member (NOLOCK) AS m ON pof.memid = m.MemberId
	LEFT JOIN [ProviderPortal].[ECM].[MemberProviderAssigment] (NOLOCK) AS mpa ON pof.memid = mpa.MemberId
		LEFT JOIN HMOPROD_PLANDATA.dbo.[provider] (NOLOCK) AS prov ON mpa.ProviderID = prov.provid
WHERE 1=1
	AND pof.[RunDate] = ( SELECT MAX(i.[RunDate]) FROM INFORMATICS.dbo.ECMPOF_CHILDWITHOUTFAMILY_HOMELESS AS i WITH (NOLOCK) )
	AND m.ISECM = 1
	AND m.EnrollmentStatus = 'Assigned'
GROUP BY pof.TargetPopulation
,mpa.ProviderID
,prov.NPI
,prov.fullname

-- =====================================================================
	-- ECMPOF_CHILD_IPSNFED_HIGHUTIL -- EXISTING LOGIC --
-- =====================================================================
SELECT ' ' AS 'EXISTING LOGIC Unique Member Count by ECM Provider - ECMPOF_CHILD_IPSNFED_HIGHUTIL'
,pof.TargetPopulation
,mpa.ProviderID
,prov.NPI
,prov.fullname AS [ECM Provider]
,COUNT(DISTINCT(pof.memid)) AS [Unique Member Count]
FROM INFORMATICS.dbo.ECMPOF_CHILD_IPSNFED_HIGHUTIL (NOLOCK) AS pof -- EXISTING LOGIC
	INNER JOIN ProviderPortal.ECM.Member (NOLOCK) AS m ON pof.memid = m.MemberId
	LEFT JOIN [ProviderPortal].[ECM].[MemberProviderAssigment] (NOLOCK) AS mpa ON pof.memid = mpa.MemberId
		LEFT JOIN HMOPROD_PLANDATA.dbo.[provider] (NOLOCK) AS prov ON mpa.ProviderID = prov.provid
WHERE 1=1
	AND pof.[RunDate] = ( SELECT MAX(i.[RunDate]) FROM INFORMATICS.dbo.ECMPOF_CHILD_IPSNFED_HIGHUTIL AS i WITH (NOLOCK) )
	AND m.ISECM = 1
	AND m.EnrollmentStatus = 'Assigned'
GROUP BY pof.TargetPopulation
,mpa.ProviderID
,prov.NPI
,prov.fullname

-- =====================================================================
	-- ECMPOF_CHILD_MHSMISUD -- EXISTING LOGIC --
-- =====================================================================
SELECT ' ' AS 'EXISTING LOGIC Unique Member Count by ECM Provider - ECMPOF_CHILD_MHSMISUD'
,pof.TargetPopulation
,mpa.ProviderID
,prov.NPI
,prov.fullname AS [ECM Provider]
,COUNT(DISTINCT(pof.memid)) AS [Unique Member Count]
FROM INFORMATICS.dbo.ECMPOF_CHILD_MHSMISUD (NOLOCK) AS pof -- EXISTING LOGIC
	INNER JOIN ProviderPortal.ECM.Member (NOLOCK) AS m ON pof.memid = m.MemberId
	LEFT JOIN [ProviderPortal].[ECM].[MemberProviderAssigment] (NOLOCK) AS mpa ON pof.memid = mpa.MemberId
		LEFT JOIN HMOPROD_PLANDATA.dbo.[provider] (NOLOCK) AS prov ON mpa.ProviderID = prov.provid
WHERE 1=1
	AND pof.[RunDate] = ( SELECT MAX(i.[RunDate]) FROM INFORMATICS.dbo.ECMPOF_CHILD_MHSMISUD AS i WITH (NOLOCK) )
	AND m.ISECM = 1
	AND m.EnrollmentStatus = 'Assigned'
GROUP BY pof.TargetPopulation
,mpa.ProviderID
,prov.NPI
,prov.fullname

-- =====================================================================
	-- ECMPOF_CHILD_INCARCERATION -- EXISTING LOGIC --
-- =====================================================================
SELECT ' ' AS 'EXISTING LOGIC Unique Member Count by ECM Provider - ECMPOF_CHILD_INCARCERATION'
,pof.TargetPopulation
,mpa.ProviderID
,prov.NPI
,prov.fullname AS [ECM Provider]
,COUNT(DISTINCT(pof.memid)) AS [Unique Member Count]
FROM INFORMATICS.dbo.ECMPOF_CHILD_INCARCERATION (NOLOCK) AS pof -- EXISTING LOGIC
	INNER JOIN ProviderPortal.ECM.Member (NOLOCK) AS m ON pof.memid = m.MemberId
	LEFT JOIN [ProviderPortal].[ECM].[MemberProviderAssigment] (NOLOCK) AS mpa ON pof.memid = mpa.MemberId
		LEFT JOIN HMOPROD_PLANDATA.dbo.[provider] (NOLOCK) AS prov ON mpa.ProviderID = prov.provid
WHERE 1=1
	AND pof.[RunDate] = ( SELECT MAX(i.[RunDate]) FROM INFORMATICS.dbo.ECMPOF_CHILD_INCARCERATION AS i WITH (NOLOCK) )
	AND m.ISECM = 1
	AND m.EnrollmentStatus = 'Assigned'
GROUP BY pof.TargetPopulation
,mpa.ProviderID
,prov.NPI
,prov.fullname

-- =====================================================================
	-- ECMPOF_CHILD_CCS -- EXISTING LOGIC --
-- =====================================================================
SELECT ' ' AS 'EXISTING LOGIC Unique Member Count by ECM Provider - ECMPOF_CHILD_CCS'
,pof.TargetPopulation
,mpa.ProviderID
,prov.NPI
,prov.fullname AS [ECM Provider]
,COUNT(DISTINCT(pof.memid)) AS [Unique Member Count]
FROM INFORMATICS.dbo.ECMPOF_CHILD_CCS (NOLOCK) AS pof -- EXISTING LOGIC
	INNER JOIN ProviderPortal.ECM.Member (NOLOCK) AS m ON pof.memid = m.MemberId
	LEFT JOIN [ProviderPortal].[ECM].[MemberProviderAssigment] (NOLOCK) AS mpa ON pof.memid = mpa.MemberId
		LEFT JOIN HMOPROD_PLANDATA.dbo.[provider] (NOLOCK) AS prov ON mpa.ProviderID = prov.provid
WHERE 1=1
	AND pof.[RunDate] = ( SELECT MAX(i.[RunDate]) FROM INFORMATICS.dbo.ECMPOF_CHILD_CCS AS i WITH (NOLOCK) )
	AND m.ISECM = 1
	AND m.EnrollmentStatus = 'Assigned'
GROUP BY pof.TargetPopulation
,mpa.ProviderID
,prov.NPI
,prov.fullname

-- =====================================================================
	-- ECMPOF_CHILD_WELFARE -- EXISTING LOGIC --
-- =====================================================================
SELECT ' ' AS 'EXISTING LOGIC Unique Member Count by ECM Provider - ECMPOF_CHILD_WELFARE'
,pof.TargetPopulation
,mpa.ProviderID
,prov.NPI
,prov.fullname AS [ECM Provider]
,COUNT(DISTINCT(pof.memid)) AS [Unique Member Count]
FROM INFORMATICS.dbo.ECMPOF_CHILD_WELFARE (NOLOCK) AS pof -- EXISTING LOGIC
	INNER JOIN ProviderPortal.ECM.Member (NOLOCK) AS m ON pof.memid = m.MemberId
	LEFT JOIN [ProviderPortal].[ECM].[MemberProviderAssigment] (NOLOCK) AS mpa ON pof.memid = mpa.MemberId
		LEFT JOIN HMOPROD_PLANDATA.dbo.[provider] (NOLOCK) AS prov ON mpa.ProviderID = prov.provid
WHERE 1=1
	AND pof.[RunDate] = ( SELECT MAX(i.[RunDate]) FROM INFORMATICS.dbo.ECMPOF_CHILD_WELFARE AS i WITH (NOLOCK) )
	AND m.ISECM = 1
	AND m.EnrollmentStatus = 'Assigned'
GROUP BY pof.TargetPopulation
,mpa.ProviderID
,prov.NPI
,prov.fullname

-- =====================================================================
	-- ECMPOF_ADULT_BIRTH_EQUITY -- EXISTING LOGIC --
-- =====================================================================
SELECT ' ' AS 'EXISTING LOGIC Unique Member Count by ECM Provider - ECMPOF_ADULT_BIRTH_EQUITY'
,pof.TargetPopulation
,mpa.ProviderID
,prov.NPI
,prov.fullname AS [ECM Provider]
,COUNT(DISTINCT(pof.memid)) AS [Unique Member Count]
FROM INFORMATICS.dbo.ECMPOF_ADULT_BIRTH_EQUITY (NOLOCK) AS pof -- EXISTING LOGIC
	INNER JOIN ProviderPortal.ECM.Member (NOLOCK) AS m ON pof.memid = m.MemberId
	LEFT JOIN [ProviderPortal].[ECM].[MemberProviderAssigment] (NOLOCK) AS mpa ON pof.memid = mpa.MemberId
		LEFT JOIN HMOPROD_PLANDATA.dbo.[provider] (NOLOCK) AS prov ON mpa.ProviderID = prov.provid
WHERE 1=1
	AND pof.[RunDate] = ( SELECT MAX(i.[RunDate]) FROM INFORMATICS.dbo.ECMPOF_ADULT_BIRTH_EQUITY AS i WITH (NOLOCK) )
	AND m.ISECM = 1
	AND m.EnrollmentStatus = 'Assigned'
GROUP BY pof.TargetPopulation
,mpa.ProviderID
,prov.NPI
,prov.fullname

-- =====================================================================
	-- ECMPOF_ADULT_IPSNFED_HIGHUTIL -- EXISTING LOGIC --
-- =====================================================================
SELECT ' ' AS 'EXISTING LOGIC Unique Member Count by ECM Provider - ECMPOF_ADULT_IPSNFED_HIGHUTIL'
,pof.TargetPopulation
,mpa.ProviderID
,prov.NPI
,prov.fullname AS [ECM Provider]
,COUNT(DISTINCT(pof.memid)) AS [Unique Member Count]
FROM INFORMATICS.dbo.ECMPOF_ADULT_IPSNFED_HIGHUTIL (NOLOCK) AS pof -- EXISTING LOGIC
	INNER JOIN ProviderPortal.ECM.Member (NOLOCK) AS m ON pof.memid = m.MemberId
	LEFT JOIN [ProviderPortal].[ECM].[MemberProviderAssigment] (NOLOCK) AS mpa ON pof.memid = mpa.MemberId
		LEFT JOIN HMOPROD_PLANDATA.dbo.[provider] (NOLOCK) AS prov ON mpa.ProviderID = prov.provid
WHERE 1=1
	AND pof.[RunDate] = ( SELECT MAX(i.[RunDate]) FROM INFORMATICS.dbo.ECMPOF_ADULT_IPSNFED_HIGHUTIL AS i WITH (NOLOCK) )
	AND m.ISECM = 1
	AND m.EnrollmentStatus = 'Assigned'
GROUP BY pof.TargetPopulation
,mpa.ProviderID
,prov.NPI
,prov.fullname

-- =====================================================================
	-- ECMPOF_ADULT_MHSMISUD -- EXISTING LOGIC --
-- =====================================================================
SELECT ' ' AS 'EXISTING LOGIC Unique Member Count by ECM Provider - ECMPOF_ADULT_MHSMISUD'
,pof.TargetPopulation
,mpa.ProviderID
,prov.NPI
,prov.fullname AS [ECM Provider]
,COUNT(DISTINCT(pof.memid)) AS [Unique Member Count]
FROM INFORMATICS.dbo.ECMPOF_ADULT_MHSMISUD (NOLOCK) AS pof -- EXISTING LOGIC
	INNER JOIN ProviderPortal.ECM.Member (NOLOCK) AS m ON pof.memid = m.MemberId
	LEFT JOIN [ProviderPortal].[ECM].[MemberProviderAssigment] (NOLOCK) AS mpa ON pof.memid = mpa.MemberId
		LEFT JOIN HMOPROD_PLANDATA.dbo.[provider] (NOLOCK) AS prov ON mpa.ProviderID = prov.provid
WHERE 1=1
	AND pof.[RunDate] = ( SELECT MAX(i.[RunDate]) FROM INFORMATICS.dbo.ECMPOF_ADULT_MHSMISUD AS i WITH (NOLOCK) )
	AND m.ISECM = 1
	AND m.EnrollmentStatus = 'Assigned'
GROUP BY pof.TargetPopulation
,mpa.ProviderID
,prov.NPI
,prov.fullname

-- =====================================================================
	-- ECMPOF_ADULT_INCARCERATION -- EXISTING LOGIC --
-- =====================================================================
SELECT ' ' AS 'EXISTING LOGIC Unique Member Count by ECM Provider - ECMPOF_ADULT_INCARCERATION'
,pof.TargetPopulation
,mpa.ProviderID
,prov.NPI
,prov.fullname AS [ECM Provider]
,COUNT(DISTINCT(pof.memid)) AS [Unique Member Count]
FROM INFORMATICS.dbo.ECMPOF_ADULT_INCARCERATION (NOLOCK) AS pof -- EXISTING LOGIC
	INNER JOIN ProviderPortal.ECM.Member (NOLOCK) AS m ON pof.memid = m.MemberId
	LEFT JOIN [ProviderPortal].[ECM].[MemberProviderAssigment] (NOLOCK) AS mpa ON pof.memid = mpa.MemberId
		LEFT JOIN HMOPROD_PLANDATA.dbo.[provider] (NOLOCK) AS prov ON mpa.ProviderID = prov.provid
WHERE 1=1
	AND pof.[RunDate] = ( SELECT MAX(i.[RunDate]) FROM INFORMATICS.dbo.ECMPOF_ADULT_INCARCERATION AS i WITH (NOLOCK) )
	AND m.ISECM = 1
	AND m.EnrollmentStatus = 'Assigned'
GROUP BY pof.TargetPopulation
,mpa.ProviderID
,prov.NPI
,prov.fullname

-- =====================================================================
	-- ECMPOF_ADULT_INSTITUTIONALIZATION -- EXISTING LOGIC --
-- =====================================================================
SELECT ' ' AS 'EXISTING LOGIC Unique Member Count by ECM Provider - ECMPOF_ADULT_INSTITUTIONALIZATION'
,pof.TargetPopulation
,mpa.ProviderID
,prov.NPI
,prov.fullname AS [ECM Provider]
,COUNT(DISTINCT(pof.memid)) AS [Unique Member Count]
FROM INFORMATICS.dbo.ECMPOF_ADULT_INSTITUTIONALIZATION (NOLOCK) AS pof -- EXISTING LOGIC
	INNER JOIN ProviderPortal.ECM.Member (NOLOCK) AS m ON pof.memid = m.MemberId
	LEFT JOIN [ProviderPortal].[ECM].[MemberProviderAssigment] (NOLOCK) AS mpa ON pof.memid = mpa.MemberId
		LEFT JOIN HMOPROD_PLANDATA.dbo.[provider] (NOLOCK) AS prov ON mpa.ProviderID = prov.provid
WHERE 1=1
	AND pof.[RunDate] = ( SELECT MAX(i.[RunDate]) FROM INFORMATICS.dbo.ECMPOF_ADULT_INSTITUTIONALIZATION AS i WITH (NOLOCK) )
	AND m.ISECM = 1
	AND m.EnrollmentStatus = 'Assigned'
GROUP BY pof.TargetPopulation
,mpa.ProviderID
,prov.NPI
,prov.fullname

-- =====================================================================
	-- ECMPOF_ADULT_NURSING_TRANSITION -- EXISTING LOGIC --
-- =====================================================================
SELECT ' ' AS 'EXISTING LOGIC Unique Member Count by ECM Provider - ECMPOF_ADULT_NURSING_TRANSITION'
,pof.TargetPopulation
,mpa.ProviderID
,prov.NPI
,prov.fullname AS [ECM Provider]
,COUNT(DISTINCT(pof.memid)) AS [Unique Member Count]
FROM INFORMATICS.dbo.ECMPOF_ADULT_NURSING_TRANSITION (NOLOCK) AS pof -- EXISTING LOGIC
	INNER JOIN ProviderPortal.ECM.Member (NOLOCK) AS m ON pof.memid = m.MemberId
	LEFT JOIN [ProviderPortal].[ECM].[MemberProviderAssigment] (NOLOCK) AS mpa ON pof.memid = mpa.MemberId
		LEFT JOIN HMOPROD_PLANDATA.dbo.[provider] (NOLOCK) AS prov ON mpa.ProviderID = prov.provid
WHERE 1=1
	AND pof.[RunDate] = ( SELECT MAX(i.[RunDate]) FROM INFORMATICS.dbo.ECMPOF_ADULT_NURSING_TRANSITION AS i WITH (NOLOCK) )
	AND m.ISECM = 1
	AND m.EnrollmentStatus = 'Assigned'
GROUP BY pof.TargetPopulation
,mpa.ProviderID
,prov.NPI
,prov.fullname

-- =====================================================================
	-- ECMPOF_ADULTWITHFAMILY_HOMELESS -- EXISTING LOGIC --
-- =====================================================================
SELECT ' ' AS 'EXISTING LOGIC Unique Member Count by ECM Provider - ECMPOF_ADULTWITHFAMILY_HOMELESS'
,pof.TargetPopulation
,mpa.ProviderID
,prov.NPI
,prov.fullname AS [ECM Provider]
,COUNT(DISTINCT(pof.memid)) AS [Unique Member Count]
FROM INFORMATICS.dbo.ECMPOF_ADULTWITHFAMILY_HOMELESS (NOLOCK) AS pof -- EXISTING LOGIC
	INNER JOIN ProviderPortal.ECM.Member (NOLOCK) AS m ON pof.memid = m.MemberId
	LEFT JOIN [ProviderPortal].[ECM].[MemberProviderAssigment] (NOLOCK) AS mpa ON pof.memid = mpa.MemberId
		LEFT JOIN HMOPROD_PLANDATA.dbo.[provider] (NOLOCK) AS prov ON mpa.ProviderID = prov.provid
WHERE 1=1
	AND pof.[RunDate] = ( SELECT MAX(i.[RunDate]) FROM INFORMATICS.dbo.ECMPOF_ADULTWITHFAMILY_HOMELESS AS i WITH (NOLOCK) )
	AND m.ISECM = 1
	AND m.EnrollmentStatus = 'Assigned'
GROUP BY pof.TargetPopulation
,mpa.ProviderID
,prov.NPI
,prov.fullname

-- =====================================================================
	-- ECMPOF_ADULTWITHOUTFAMILY_HOMELESS -- EXISTING LOGIC --
-- =====================================================================
SELECT ' ' AS 'EXISTING LOGIC Unique Member Count by ECM Provider - ECMPOF_ADULTWITHOUTFAMILY_HOMELESS'
,pof.TargetPopulation
,mpa.ProviderID
,prov.NPI
,prov.fullname AS [ECM Provider]
,COUNT(DISTINCT(pof.memid)) AS [Unique Member Count]
FROM INFORMATICS.dbo.ECMPOF_ADULTWITHOUTFAMILY_HOMELESS (NOLOCK) AS pof -- EXISTING LOGIC
	INNER JOIN ProviderPortal.ECM.Member (NOLOCK) AS m ON pof.memid = m.MemberId
	LEFT JOIN [ProviderPortal].[ECM].[MemberProviderAssigment] (NOLOCK) AS mpa ON pof.memid = mpa.MemberId
		LEFT JOIN HMOPROD_PLANDATA.dbo.[provider] (NOLOCK) AS prov ON mpa.ProviderID = prov.provid
WHERE 1=1
	AND pof.[RunDate] = ( SELECT MAX(i.[RunDate]) FROM INFORMATICS.dbo.ECMPOF_ADULTWITHOUTFAMILY_HOMELESS AS i WITH (NOLOCK) )
	AND m.ISECM = 1
	AND m.EnrollmentStatus = 'Assigned'
GROUP BY pof.TargetPopulation
,mpa.ProviderID
,prov.NPI
,prov.fullname

-- =====================================================================
	-- CHATGPT_ECMPOF_CHILD_BIRTH_EQUITY -- ALGORITHM LOGIC --
-- =====================================================================
SELECT ' ' AS 'ALGORITHM LOGIC Unique Member Count by ECM Provider - CHATGPT_ECMPOF_CHILD_BIRTH_EQUITY'
,pof.TargetPopulation
,mpa.ProviderID
,prov.NPI
,prov.fullname AS [ECM Provider]
,COUNT(DISTINCT(pof.memid)) AS [Unique Member Count]
FROM INFORMATICS.dbo.CHATGPT_ECMPOF_CHILD_BIRTH_EQUITY (NOLOCK) AS pof -- ALGORITHM POF LOGIC ADJUSTMENT
	INNER JOIN ProviderPortal.ECM.Member (NOLOCK) AS m ON pof.memid = m.MemberId
	LEFT JOIN [ProviderPortal].[ECM].[MemberProviderAssigment] (NOLOCK) AS mpa ON pof.memid = mpa.MemberId
		LEFT JOIN HMOPROD_PLANDATA.dbo.[provider] (NOLOCK) AS prov ON mpa.ProviderID = prov.provid
WHERE 1=1
	AND pof.[RunDate] = ( SELECT MAX(i.[RunDate]) FROM INFORMATICS.dbo.CHATGPT_ECMPOF_CHILD_BIRTH_EQUITY AS i WITH (NOLOCK) )
	AND m.ISECM = 1
	AND m.EnrollmentStatus = 'Assigned'
GROUP BY pof.TargetPopulation
,mpa.ProviderID
,prov.NPI
,prov.fullname

-- =====================================================================
	-- CHATGPT_ECMPOF_CHILDWITHFAMILY_HOMELESS -- ALGORITHM LOGIC --
-- =====================================================================
SELECT ' ' AS 'ALGORITHM LOGIC Unique Member Count by ECM Provider - CHATGPT_ECMPOF_CHILDWITHFAMILY_HOMELESS'
,pof.TargetPopulation
,mpa.ProviderID
,prov.NPI
,prov.fullname AS [ECM Provider]
,COUNT(DISTINCT(pof.memid)) AS [Unique Member Count]
FROM INFORMATICS.dbo.CHATGPT_ECMPOF_CHILDWITHFAMILY_HOMELESS (NOLOCK) AS pof -- ALGORITHM POF LOGIC ADJUSTMENT
	INNER JOIN ProviderPortal.ECM.Member (NOLOCK) AS m ON pof.memid = m.MemberId
	LEFT JOIN [ProviderPortal].[ECM].[MemberProviderAssigment] (NOLOCK) AS mpa ON pof.memid = mpa.MemberId
		LEFT JOIN HMOPROD_PLANDATA.dbo.[provider] (NOLOCK) AS prov ON mpa.ProviderID = prov.provid
WHERE 1=1
	AND pof.[RunDate] = ( SELECT MAX(i.[RunDate]) FROM INFORMATICS.dbo.CHATGPT_ECMPOF_CHILDWITHFAMILY_HOMELESS AS i WITH (NOLOCK) )
	AND m.ISECM = 1
	AND m.EnrollmentStatus = 'Assigned'
GROUP BY pof.TargetPopulation
,mpa.ProviderID
,prov.NPI
,prov.fullname

-- =====================================================================
	-- CHATGPT_ECMPOF_CHILDWITHOUTFAMILY_HOMELESS -- ALGORITHM LOGIC --
-- =====================================================================
SELECT ' ' AS 'ALGORITHM LOGIC Unique Member Count by ECM Provider - CHATGPT_ECMPOF_CHILDWITHOUTFAMILY_HOMELESS'
,pof.TargetPopulation
,mpa.ProviderID
,prov.NPI
,prov.fullname AS [ECM Provider]
,COUNT(DISTINCT(pof.memid)) AS [Unique Member Count]
FROM INFORMATICS.dbo.CHATGPT_ECMPOF_CHILDWITHOUTFAMILY_HOMELESS (NOLOCK) AS pof -- ALGORITHM POF LOGIC ADJUSTMENT
	INNER JOIN ProviderPortal.ECM.Member (NOLOCK) AS m ON pof.memid = m.MemberId
	LEFT JOIN [ProviderPortal].[ECM].[MemberProviderAssigment] (NOLOCK) AS mpa ON pof.memid = mpa.MemberId
		LEFT JOIN HMOPROD_PLANDATA.dbo.[provider] (NOLOCK) AS prov ON mpa.ProviderID = prov.provid
WHERE 1=1
	AND pof.[RunDate] = ( SELECT MAX(i.[RunDate]) FROM INFORMATICS.dbo.CHATGPT_ECMPOF_CHILDWITHOUTFAMILY_HOMELESS AS i WITH (NOLOCK) )
	AND m.ISECM = 1
	AND m.EnrollmentStatus = 'Assigned'
GROUP BY pof.TargetPopulation
,mpa.ProviderID
,prov.NPI
,prov.fullname

-- =====================================================================
	-- CHATGPT_ECMPOF_CHILD_IPSNFED_HIGHUTIL -- ALGORITHM LOGIC --
-- =====================================================================
SELECT ' ' AS 'ALGORITHM LOGIC Unique Member Count by ECM Provider - CHATGPT_ECMPOF_CHILD_IPSNFED_HIGHUTIL'
,pof.TargetPopulation
,mpa.ProviderID
,prov.NPI
,prov.fullname AS [ECM Provider]
,COUNT(DISTINCT(pof.memid)) AS [Unique Member Count]
FROM INFORMATICS.dbo.CHATGPT_ECMPOF_CHILD_IPSNFED_HIGHUTIL (NOLOCK) AS pof -- ALGORITHM POF LOGIC ADJUSTMENT
	INNER JOIN ProviderPortal.ECM.Member (NOLOCK) AS m ON pof.memid = m.MemberId
	LEFT JOIN [ProviderPortal].[ECM].[MemberProviderAssigment] (NOLOCK) AS mpa ON pof.memid = mpa.MemberId
		LEFT JOIN HMOPROD_PLANDATA.dbo.[provider] (NOLOCK) AS prov ON mpa.ProviderID = prov.provid
WHERE 1=1
	AND pof.[RunDate] = ( SELECT MAX(i.[RunDate]) FROM INFORMATICS.dbo.CHATGPT_ECMPOF_CHILD_IPSNFED_HIGHUTIL AS i WITH (NOLOCK) )
	AND m.ISECM = 1
	AND m.EnrollmentStatus = 'Assigned'
GROUP BY pof.TargetPopulation
,mpa.ProviderID
,prov.NPI
,prov.fullname

-- =====================================================================
	-- CHATGPT_ECMPOF_CHILD_MHSMISUD -- ALGORITHM LOGIC --
-- =====================================================================
SELECT ' ' AS 'ALGORITHM LOGIC Unique Member Count by ECM Provider - CHATGPT_ECMPOF_CHILD_MHSMISUD'
,pof.TargetPopulation
,mpa.ProviderID
,prov.NPI
,prov.fullname AS [ECM Provider]
,COUNT(DISTINCT(pof.memid)) AS [Unique Member Count]
FROM INFORMATICS.dbo.CHATGPT_ECMPOF_CHILD_MHSMISUD (NOLOCK) AS pof -- ALGORITHM POF LOGIC ADJUSTMENT
	INNER JOIN ProviderPortal.ECM.Member (NOLOCK) AS m ON pof.memid = m.MemberId
	LEFT JOIN [ProviderPortal].[ECM].[MemberProviderAssigment] (NOLOCK) AS mpa ON pof.memid = mpa.MemberId
		LEFT JOIN HMOPROD_PLANDATA.dbo.[provider] (NOLOCK) AS prov ON mpa.ProviderID = prov.provid
WHERE 1=1
	AND pof.[RunDate] = ( SELECT MAX(i.[RunDate]) FROM INFORMATICS.dbo.CHATGPT_ECMPOF_CHILD_MHSMISUD AS i WITH (NOLOCK) )
	AND m.ISECM = 1
	AND m.EnrollmentStatus = 'Assigned'
GROUP BY pof.TargetPopulation
,mpa.ProviderID
,prov.NPI
,prov.fullname

-- =====================================================================
	-- CHATGPT_ECMPOF_CHILD_INCARCERATION -- ALGORITHM LOGIC --
-- =====================================================================
SELECT ' ' AS 'ALGORITHM LOGIC Unique Member Count by ECM Provider - CHATGPT_ECMPOF_CHILD_INCARCERATION'
,pof.TargetPopulation
,mpa.ProviderID
,prov.NPI
,prov.fullname AS [ECM Provider]
,COUNT(DISTINCT(pof.memid)) AS [Unique Member Count]
FROM INFORMATICS.dbo.CHATGPT_ECMPOF_CHILD_INCARCERATION (NOLOCK) AS pof -- ALGORITHM POF LOGIC ADJUSTMENT
	INNER JOIN ProviderPortal.ECM.Member (NOLOCK) AS m ON pof.memid = m.MemberId
	LEFT JOIN [ProviderPortal].[ECM].[MemberProviderAssigment] (NOLOCK) AS mpa ON pof.memid = mpa.MemberId
		LEFT JOIN HMOPROD_PLANDATA.dbo.[provider] (NOLOCK) AS prov ON mpa.ProviderID = prov.provid
WHERE 1=1
	AND pof.[RunDate] = ( SELECT MAX(i.[RunDate]) FROM INFORMATICS.dbo.CHATGPT_ECMPOF_CHILD_INCARCERATION AS i WITH (NOLOCK) )
	AND m.ISECM = 1
	AND m.EnrollmentStatus = 'Assigned'
GROUP BY pof.TargetPopulation
,mpa.ProviderID
,prov.NPI
,prov.fullname

-- =====================================================================
	-- CHATGPT_ECMPOF_CHILD_CCS -- ALGORITHM LOGIC --
-- =====================================================================
SELECT ' ' AS 'ALGORITHM LOGIC Unique Member Count by ECM Provider - CHATGPT_ECMPOF_CHILD_CCS'
,pof.TargetPopulation
,mpa.ProviderID
,prov.NPI
,prov.fullname AS [ECM Provider]
,COUNT(DISTINCT(pof.memid)) AS [Unique Member Count]
FROM INFORMATICS.dbo.CHATGPT_ECMPOF_CHILD_CCS (NOLOCK) AS pof -- ALGORITHM POF LOGIC ADJUSTMENT
	INNER JOIN ProviderPortal.ECM.Member (NOLOCK) AS m ON pof.memid = m.MemberId
	LEFT JOIN [ProviderPortal].[ECM].[MemberProviderAssigment] (NOLOCK) AS mpa ON pof.memid = mpa.MemberId
		LEFT JOIN HMOPROD_PLANDATA.dbo.[provider] (NOLOCK) AS prov ON mpa.ProviderID = prov.provid
WHERE 1=1
	AND pof.[RunDate] = ( SELECT MAX(i.[RunDate]) FROM INFORMATICS.dbo.CHATGPT_ECMPOF_CHILD_CCS AS i WITH (NOLOCK) )
	AND m.ISECM = 1
	AND m.EnrollmentStatus = 'Assigned'
GROUP BY pof.TargetPopulation
,mpa.ProviderID
,prov.NPI
,prov.fullname

-- =====================================================================
	-- CHATGPT_ECMPOF_CHILD_WELFARE -- ALGORITHM LOGIC --
-- =====================================================================
SELECT ' ' AS 'ALGORITHM LOGIC Unique Member Count by ECM Provider - CHATGPT_ECMPOF_CHILD_WELFARE'
,pof.TargetPopulation
,mpa.ProviderID
,prov.NPI
,prov.fullname AS [ECM Provider]
,COUNT(DISTINCT(pof.memid)) AS [Unique Member Count]
FROM INFORMATICS.dbo.CHATGPT_ECMPOF_CHILD_WELFARE (NOLOCK) AS pof -- ALGORITHM POF LOGIC ADJUSTMENT
	INNER JOIN ProviderPortal.ECM.Member (NOLOCK) AS m ON pof.memid = m.MemberId
	LEFT JOIN [ProviderPortal].[ECM].[MemberProviderAssigment] (NOLOCK) AS mpa ON pof.memid = mpa.MemberId
		LEFT JOIN HMOPROD_PLANDATA.dbo.[provider] (NOLOCK) AS prov ON mpa.ProviderID = prov.provid
WHERE 1=1
	AND pof.[RunDate] = ( SELECT MAX(i.[RunDate]) FROM INFORMATICS.dbo.CHATGPT_ECMPOF_CHILD_WELFARE AS i WITH (NOLOCK) )
	AND m.ISECM = 1
	AND m.EnrollmentStatus = 'Assigned'
GROUP BY pof.TargetPopulation
,mpa.ProviderID
,prov.NPI
,prov.fullname

-- =====================================================================
	-- CHATGPT_ECMPOF_ADULT_BIRTH_EQUITY -- ALGORITHM LOGIC --
-- =====================================================================
SELECT ' ' AS 'ALGORITHM LOGIC Unique Member Count by ECM Provider - CHATGPT_ECMPOF_ADULT_BIRTH_EQUITY'
,pof.TargetPopulation
,mpa.ProviderID
,prov.NPI
,prov.fullname AS [ECM Provider]
,COUNT(DISTINCT(pof.memid)) AS [Unique Member Count]
FROM INFORMATICS.dbo.CHATGPT_ECMPOF_ADULT_BIRTH_EQUITY (NOLOCK) AS pof -- ALGORITHM POF LOGIC ADJUSTMENT
	INNER JOIN ProviderPortal.ECM.Member (NOLOCK) AS m ON pof.memid = m.MemberId
	LEFT JOIN [ProviderPortal].[ECM].[MemberProviderAssigment] (NOLOCK) AS mpa ON pof.memid = mpa.MemberId
		LEFT JOIN HMOPROD_PLANDATA.dbo.[provider] (NOLOCK) AS prov ON mpa.ProviderID = prov.provid
WHERE 1=1
	AND pof.[RunDate] = ( SELECT MAX(i.[RunDate]) FROM INFORMATICS.dbo.CHATGPT_ECMPOF_ADULT_BIRTH_EQUITY AS i WITH (NOLOCK) )
	AND m.ISECM = 1
	AND m.EnrollmentStatus = 'Assigned'
GROUP BY pof.TargetPopulation
,mpa.ProviderID
,prov.NPI
,prov.fullname

-- =====================================================================
	-- CHATGPT_ECMPOF_ADULT_IPSNFED_HIGHUTIL -- ALGORITHM LOGIC --
-- =====================================================================
SELECT ' ' AS 'ALGORITHM LOGIC Unique Member Count by ECM Provider - CHATGPT_ECMPOF_ADULT_IPSNFED_HIGHUTIL'
,pof.TargetPopulation
,mpa.ProviderID
,prov.NPI
,prov.fullname AS [ECM Provider]
,COUNT(DISTINCT(pof.memid)) AS [Unique Member Count]
FROM INFORMATICS.dbo.CHATGPT_ECMPOF_ADULT_IPSNFED_HIGHUTIL (NOLOCK) AS pof -- ALGORITHM POF LOGIC ADJUSTMENT
	INNER JOIN ProviderPortal.ECM.Member (NOLOCK) AS m ON pof.memid = m.MemberId
	LEFT JOIN [ProviderPortal].[ECM].[MemberProviderAssigment] (NOLOCK) AS mpa ON pof.memid = mpa.MemberId
		LEFT JOIN HMOPROD_PLANDATA.dbo.[provider] (NOLOCK) AS prov ON mpa.ProviderID = prov.provid
WHERE 1=1
	AND pof.[RunDate] = ( SELECT MAX(i.[RunDate]) FROM INFORMATICS.dbo.CHATGPT_ECMPOF_ADULT_IPSNFED_HIGHUTIL AS i WITH (NOLOCK) )
	AND m.ISECM = 1
	AND m.EnrollmentStatus = 'Assigned'
GROUP BY pof.TargetPopulation
,mpa.ProviderID
,prov.NPI
,prov.fullname

-- =====================================================================
	-- CHATGPT_ECMPOF_ADULT_MHSMISUD -- ALGORITHM LOGIC --
-- =====================================================================
SELECT ' ' AS 'ALGORITHM LOGIC Unique Member Count by ECM Provider - CHATGPT_ECMPOF_ADULT_MHSMISUD'
,pof.TargetPopulation
,mpa.ProviderID
,prov.NPI
,prov.fullname AS [ECM Provider]
,COUNT(DISTINCT(pof.memid)) AS [Unique Member Count]
FROM INFORMATICS.dbo.CHATGPT_ECMPOF_ADULT_MHSMISUD (NOLOCK) AS pof -- ALGORITHM POF LOGIC ADJUSTMENT
	INNER JOIN ProviderPortal.ECM.Member (NOLOCK) AS m ON pof.memid = m.MemberId
	LEFT JOIN [ProviderPortal].[ECM].[MemberProviderAssigment] (NOLOCK) AS mpa ON pof.memid = mpa.MemberId
		LEFT JOIN HMOPROD_PLANDATA.dbo.[provider] (NOLOCK) AS prov ON mpa.ProviderID = prov.provid
WHERE 1=1
	AND pof.[RunDate] = ( SELECT MAX(i.[RunDate]) FROM INFORMATICS.dbo.CHATGPT_ECMPOF_ADULT_MHSMISUD AS i WITH (NOLOCK) )
	AND m.ISECM = 1
	AND m.EnrollmentStatus = 'Assigned'
GROUP BY pof.TargetPopulation
,mpa.ProviderID
,prov.NPI
,prov.fullname

-- =====================================================================
	-- CHATGPT_ECMPOF_ADULT_INCARCERATION -- ALGORITHM LOGIC --
-- =====================================================================
SELECT ' ' AS 'ALGORITHM LOGIC Unique Member Count by ECM Provider - CHATGPT_ECMPOF_ADULT_INCARCERATION'
,pof.TargetPopulation
,mpa.ProviderID
,prov.NPI
,prov.fullname AS [ECM Provider]
,COUNT(DISTINCT(pof.memid)) AS [Unique Member Count]
FROM INFORMATICS.dbo.CHATGPT_ECMPOF_ADULT_INCARCERATION (NOLOCK) AS pof -- ALGORITHM POF LOGIC ADJUSTMENT
	INNER JOIN ProviderPortal.ECM.Member (NOLOCK) AS m ON pof.memid = m.MemberId
	LEFT JOIN [ProviderPortal].[ECM].[MemberProviderAssigment] (NOLOCK) AS mpa ON pof.memid = mpa.MemberId
		LEFT JOIN HMOPROD_PLANDATA.dbo.[provider] (NOLOCK) AS prov ON mpa.ProviderID = prov.provid
WHERE 1=1
	AND pof.[RunDate] = ( SELECT MAX(i.[RunDate]) FROM INFORMATICS.dbo.CHATGPT_ECMPOF_ADULT_INCARCERATION AS i WITH (NOLOCK) )
	AND m.ISECM = 1
	AND m.EnrollmentStatus = 'Assigned'
GROUP BY pof.TargetPopulation
,mpa.ProviderID
,prov.NPI
,prov.fullname

-- =====================================================================
	-- CHATGPT_ECMPOF_ADULT_INSTITUTIONALIZATION -- ALGORITHM LOGIC --
-- =====================================================================
SELECT ' ' AS 'ALGORITHM LOGIC Unique Member Count by ECM Provider - CHATGPT_ECMPOF_ADULT_INSTITUTIONALIZATION'
,pof.TargetPopulation
,mpa.ProviderID
,prov.NPI
,prov.fullname AS [ECM Provider]
,COUNT(DISTINCT(pof.memid)) AS [Unique Member Count]
FROM INFORMATICS.dbo.CHATGPT_ECMPOF_ADULT_INSTITUTIONALIZATION (NOLOCK) AS pof -- ALGORITHM POF LOGIC ADJUSTMENT
	INNER JOIN ProviderPortal.ECM.Member (NOLOCK) AS m ON pof.memid = m.MemberId
	LEFT JOIN [ProviderPortal].[ECM].[MemberProviderAssigment] (NOLOCK) AS mpa ON pof.memid = mpa.MemberId
		LEFT JOIN HMOPROD_PLANDATA.dbo.[provider] (NOLOCK) AS prov ON mpa.ProviderID = prov.provid
WHERE 1=1
	AND pof.[RunDate] = ( SELECT MAX(i.[RunDate]) FROM INFORMATICS.dbo.CHATGPT_ECMPOF_ADULT_INSTITUTIONALIZATION AS i WITH (NOLOCK) )
	AND m.ISECM = 1
	AND m.EnrollmentStatus = 'Assigned'
GROUP BY pof.TargetPopulation
,mpa.ProviderID
,prov.NPI
,prov.fullname

-- =====================================================================
	-- CHATGPT_ECMPOF_ADULT_NURSING_TRANSITION -- ALGORITHM LOGIC --
-- =====================================================================
SELECT ' ' AS 'ALGORITHM LOGIC Unique Member Count by ECM Provider - CHATGPT_ECMPOF_ADULT_NURSING_TRANSITION'
,pof.TargetPopulation
,mpa.ProviderID
,prov.NPI
,prov.fullname AS [ECM Provider]
,COUNT(DISTINCT(pof.memid)) AS [Unique Member Count]
FROM INFORMATICS.dbo.CHATGPT_ECMPOF_ADULT_NURSING_TRANSITION (NOLOCK) AS pof -- ALGORITHM POF LOGIC ADJUSTMENT
	INNER JOIN ProviderPortal.ECM.Member (NOLOCK) AS m ON pof.memid = m.MemberId
	LEFT JOIN [ProviderPortal].[ECM].[MemberProviderAssigment] (NOLOCK) AS mpa ON pof.memid = mpa.MemberId
		LEFT JOIN HMOPROD_PLANDATA.dbo.[provider] (NOLOCK) AS prov ON mpa.ProviderID = prov.provid
WHERE 1=1
	AND pof.[RunDate] = ( SELECT MAX(i.[RunDate]) FROM INFORMATICS.dbo.CHATGPT_ECMPOF_ADULT_NURSING_TRANSITION AS i WITH (NOLOCK) )
	AND m.ISECM = 1
	AND m.EnrollmentStatus = 'Assigned'
GROUP BY pof.TargetPopulation
,mpa.ProviderID
,prov.NPI
,prov.fullname

-- =====================================================================
	-- CHATGPT_ECMPOF_ADULTWITHFAMILY_HOMELESS -- ALGORITHM LOGIC --
-- =====================================================================
SELECT ' ' AS 'ALGORITHM LOGIC Unique Member Count by ECM Provider - CHATGPT_ECMPOF_ADULTWITHFAMILY_HOMELESS'
,pof.TargetPopulation
,mpa.ProviderID
,prov.NPI
,prov.fullname AS [ECM Provider]
,COUNT(DISTINCT(pof.memid)) AS [Unique Member Count]
FROM INFORMATICS.dbo.CHATGPT_ECMPOF_ADULTWITHFAMILY_HOMELESS (NOLOCK) AS pof -- ALGORITHM POF LOGIC ADJUSTMENT
	INNER JOIN ProviderPortal.ECM.Member (NOLOCK) AS m ON pof.memid = m.MemberId
	LEFT JOIN [ProviderPortal].[ECM].[MemberProviderAssigment] (NOLOCK) AS mpa ON pof.memid = mpa.MemberId
		LEFT JOIN HMOPROD_PLANDATA.dbo.[provider] (NOLOCK) AS prov ON mpa.ProviderID = prov.provid
WHERE 1=1
	AND pof.[RunDate] = ( SELECT MAX(i.[RunDate]) FROM INFORMATICS.dbo.CHATGPT_ECMPOF_ADULTWITHFAMILY_HOMELESS AS i WITH (NOLOCK) )
	AND m.ISECM = 1
	AND m.EnrollmentStatus = 'Assigned'
GROUP BY pof.TargetPopulation
,mpa.ProviderID
,prov.NPI
,prov.fullname

-- =====================================================================
	-- CHATGPT_ECMPOF_ADULTWITHOUTFAMILY_HOMELESS -- ALGORITHM LOGIC --
-- =====================================================================
SELECT ' ' AS 'ALGORITHM LOGIC Unique Member Count by ECM Provider - CHATGPT_ECMPOF_ADULTWITHOUTFAMILY_HOMELESS'
,pof.TargetPopulation
,mpa.ProviderID
,prov.NPI
,prov.fullname AS [ECM Provider]
,COUNT(DISTINCT(pof.memid)) AS [Unique Member Count]
FROM INFORMATICS.dbo.CHATGPT_ECMPOF_ADULTWITHOUTFAMILY_HOMELESS (NOLOCK) AS pof -- ALGORITHM POF LOGIC ADJUSTMENT
	INNER JOIN ProviderPortal.ECM.Member (NOLOCK) AS m ON pof.memid = m.MemberId
	LEFT JOIN [ProviderPortal].[ECM].[MemberProviderAssigment] (NOLOCK) AS mpa ON pof.memid = mpa.MemberId
		LEFT JOIN HMOPROD_PLANDATA.dbo.[provider] (NOLOCK) AS prov ON mpa.ProviderID = prov.provid
WHERE 1=1
	AND pof.[RunDate] = ( SELECT MAX(i.[RunDate]) FROM INFORMATICS.dbo.CHATGPT_ECMPOF_ADULTWITHOUTFAMILY_HOMELESS AS i WITH (NOLOCK) )
	AND m.ISECM = 1
	AND m.EnrollmentStatus = 'Assigned'
GROUP BY pof.TargetPopulation
,mpa.ProviderID
,prov.NPI
,prov.fullname

