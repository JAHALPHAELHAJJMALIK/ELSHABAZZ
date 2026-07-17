-- =====================================================================
	-- POF ECM PROVIDER 20260714 -- REBUILT per JAG spec, generalized 20260714 --
	-- Sir Allan Sombillo / Sir Yousaf Farook, on behalf of JAG, do NOT want memberattribute used --
	-- Qualifying gate IS ProviderPortal.ECM.Member directly (m.ISECM = 1 AND
	-- m.EnrollmentStatus = 'Assigned'), joined ON pof.memid = m.MemberId, matching the CODE Malik
	-- supplied 20260714 --
	-- Malik confirmed the common field list 20260714: memid, carriermemid, lastname, firstname,
	-- TargetPopulation, [RANGE NOTE(s)], plus ProviderID/NPI/fullname from the Provider join. This
	-- replaces pof.* AND IS now applied uniformly across all 17 existing / 16 algorithm POF tables --
	-- SELECT DISTINCT retained per Malik's supplied CODE, guards against the mpa fan-out (2 to 3
	-- duplicate rows per member) observed IN Malik's earlier ad-hoc exploration without a dedup/window
	-- on MemberProviderAssigment. NO EffDate/TermDate window applied here, matching the supplied CODE
	-- exactly. Result-set titles include the source table name AS a navigability aid across 34 SSMS
	-- result tabs, a value-ADD beyond the literal supplied CODE, flagged here rather than silent --
	-- COUNT BY ECM PROVIDER coverage for all 17/16 tables already lives IN EXISTING POF v ALGORITHM
	-- POF ECM COUNTS 20260714.sql, NOT duplicated here to avoid redundant maintenance of the same logic
	-- IN two places --
-- =====================================================================

	-- EXISTING LOGIC DETAIL: 
-- =====================================================================
	-- ECMPOF_CHILD_BIRTH_EQUITY -- EXISTING LOGIC --
-- =====================================================================
SELECT DISTINCT ' ' AS 'EXISTING LOGIC DETAIL MEMBER LISTING - ECMPOF_CHILD_BIRTH_EQUITY'
,mpa.ProviderID
,prov.NPI
,prov.fullname AS [ECM Provider]
,pof.memid
,pof.carriermemid
,pof.lastname
,pof.firstname
,pof.TargetPopulation
,pof.[RANGE NOTE(s)]
FROM INFORMATICS.dbo.ECMPOF_CHILD_BIRTH_EQUITY (NOLOCK) AS pof -- EXISTING LOGIC
	INNER JOIN ProviderPortal.ECM.Member (NOLOCK) AS m ON pof.memid = m.MemberId
	LEFT JOIN [ProviderPortal].[ECM].[MemberProviderAssigment] (NOLOCK) AS mpa ON pof.memid = mpa.MemberId
		LEFT JOIN HMOPROD_PLANDATA.dbo.[provider] (NOLOCK) AS prov ON mpa.ProviderID = prov.provid
WHERE 1=1
	AND pof.[RunDate] = ( SELECT MAX(i.[RunDate]) FROM INFORMATICS.dbo.ECMPOF_CHILD_BIRTH_EQUITY AS i WITH (NOLOCK) )
	AND m.ISECM = 1
	AND m.EnrollmentStatus = 'Assigned'

UNION ALL 
-- =====================================================================
	-- ECMPOF_CHILD_HOMELESS -- EXISTING LOGIC --
-- =====================================================================
SELECT DISTINCT ' ' AS 'EXISTING LOGIC DETAIL MEMBER LISTING - ECMPOF_CHILD_HOMELESS'
,mpa.ProviderID
,prov.NPI
,prov.fullname AS [ECM Provider]
,pof.memid
,pof.carriermemid
,pof.lastname
,pof.firstname
,pof.TargetPopulation
,pof.[RANGE NOTE(s)]
FROM INFORMATICS.dbo.ECMPOF_CHILD_HOMELESS (NOLOCK) AS pof -- EXISTING LOGIC
	INNER JOIN ProviderPortal.ECM.Member (NOLOCK) AS m ON pof.memid = m.MemberId
	LEFT JOIN [ProviderPortal].[ECM].[MemberProviderAssigment] (NOLOCK) AS mpa ON pof.memid = mpa.MemberId
		LEFT JOIN HMOPROD_PLANDATA.dbo.[provider] (NOLOCK) AS prov ON mpa.ProviderID = prov.provid
WHERE 1=1
	AND pof.[RunDate] = ( SELECT MAX(i.[RunDate]) FROM INFORMATICS.dbo.ECMPOF_CHILD_HOMELESS AS i WITH (NOLOCK) )
	AND m.ISECM = 1
	AND m.EnrollmentStatus = 'Assigned'

UNION ALL 
-- =====================================================================
	-- ECMPOF_CHILDWITHFAMILY_HOMELESS -- EXISTING LOGIC --
-- =====================================================================
SELECT DISTINCT ' ' AS 'EXISTING LOGIC DETAIL MEMBER LISTING - ECMPOF_CHILDWITHFAMILY_HOMELESS'
,mpa.ProviderID
,prov.NPI
,prov.fullname AS [ECM Provider]
,pof.memid
,pof.carriermemid
,pof.lastname
,pof.firstname
,pof.TargetPopulation
,pof.[RANGE NOTE(s)]
FROM INFORMATICS.dbo.ECMPOF_CHILDWITHFAMILY_HOMELESS (NOLOCK) AS pof -- EXISTING LOGIC
	INNER JOIN ProviderPortal.ECM.Member (NOLOCK) AS m ON pof.memid = m.MemberId
	LEFT JOIN [ProviderPortal].[ECM].[MemberProviderAssigment] (NOLOCK) AS mpa ON pof.memid = mpa.MemberId
		LEFT JOIN HMOPROD_PLANDATA.dbo.[provider] (NOLOCK) AS prov ON mpa.ProviderID = prov.provid
WHERE 1=1
	AND pof.[RunDate] = ( SELECT MAX(i.[RunDate]) FROM INFORMATICS.dbo.ECMPOF_CHILDWITHFAMILY_HOMELESS AS i WITH (NOLOCK) )
	AND m.ISECM = 1
	AND m.EnrollmentStatus = 'Assigned'

UNION ALL 
-- =====================================================================
	-- ECMPOF_CHILDWITHOUTFAMILY_HOMELESS -- EXISTING LOGIC --
-- =====================================================================
SELECT DISTINCT ' ' AS 'EXISTING LOGIC DETAIL MEMBER LISTING - ECMPOF_CHILDWITHOUTFAMILY_HOMELESS'
,mpa.ProviderID
,prov.NPI
,prov.fullname AS [ECM Provider]
,pof.memid
,pof.carriermemid
,pof.lastname
,pof.firstname
,pof.TargetPopulation
,pof.[RANGE NOTE(s)]
FROM INFORMATICS.dbo.ECMPOF_CHILDWITHOUTFAMILY_HOMELESS (NOLOCK) AS pof -- EXISTING LOGIC
	INNER JOIN ProviderPortal.ECM.Member (NOLOCK) AS m ON pof.memid = m.MemberId
	LEFT JOIN [ProviderPortal].[ECM].[MemberProviderAssigment] (NOLOCK) AS mpa ON pof.memid = mpa.MemberId
		LEFT JOIN HMOPROD_PLANDATA.dbo.[provider] (NOLOCK) AS prov ON mpa.ProviderID = prov.provid
WHERE 1=1
	AND pof.[RunDate] = ( SELECT MAX(i.[RunDate]) FROM INFORMATICS.dbo.ECMPOF_CHILDWITHOUTFAMILY_HOMELESS AS i WITH (NOLOCK) )
	AND m.ISECM = 1
	AND m.EnrollmentStatus = 'Assigned'

UNION ALL 
-- =====================================================================
	-- ECMPOF_CHILD_IPSNFED_HIGHUTIL -- EXISTING LOGIC --
-- =====================================================================
SELECT DISTINCT ' ' AS 'EXISTING LOGIC DETAIL MEMBER LISTING - ECMPOF_CHILD_IPSNFED_HIGHUTIL'
,mpa.ProviderID
,prov.NPI
,prov.fullname AS [ECM Provider]
,pof.memid
,pof.carriermemid
,pof.lastname
,pof.firstname
,pof.TargetPopulation
,pof.[RANGE NOTE(s)]
FROM INFORMATICS.dbo.ECMPOF_CHILD_IPSNFED_HIGHUTIL (NOLOCK) AS pof -- EXISTING LOGIC
	INNER JOIN ProviderPortal.ECM.Member (NOLOCK) AS m ON pof.memid = m.MemberId
	LEFT JOIN [ProviderPortal].[ECM].[MemberProviderAssigment] (NOLOCK) AS mpa ON pof.memid = mpa.MemberId
		LEFT JOIN HMOPROD_PLANDATA.dbo.[provider] (NOLOCK) AS prov ON mpa.ProviderID = prov.provid
WHERE 1=1
	AND pof.[RunDate] = ( SELECT MAX(i.[RunDate]) FROM INFORMATICS.dbo.ECMPOF_CHILD_IPSNFED_HIGHUTIL AS i WITH (NOLOCK) )
	AND m.ISECM = 1
	AND m.EnrollmentStatus = 'Assigned'

UNION ALL 
-- =====================================================================
	-- ECMPOF_CHILD_MHSMISUD -- EXISTING LOGIC --
-- =====================================================================
SELECT DISTINCT ' ' AS 'EXISTING LOGIC DETAIL MEMBER LISTING - ECMPOF_CHILD_MHSMISUD'
,mpa.ProviderID
,prov.NPI
,prov.fullname AS [ECM Provider]
,pof.memid
,pof.carriermemid
,pof.lastname
,pof.firstname
,pof.TargetPopulation
,pof.[RANGE NOTE(s)]
FROM INFORMATICS.dbo.ECMPOF_CHILD_MHSMISUD (NOLOCK) AS pof -- EXISTING LOGIC
	INNER JOIN ProviderPortal.ECM.Member (NOLOCK) AS m ON pof.memid = m.MemberId
	LEFT JOIN [ProviderPortal].[ECM].[MemberProviderAssigment] (NOLOCK) AS mpa ON pof.memid = mpa.MemberId
		LEFT JOIN HMOPROD_PLANDATA.dbo.[provider] (NOLOCK) AS prov ON mpa.ProviderID = prov.provid
WHERE 1=1
	AND pof.[RunDate] = ( SELECT MAX(i.[RunDate]) FROM INFORMATICS.dbo.ECMPOF_CHILD_MHSMISUD AS i WITH (NOLOCK) )
	AND m.ISECM = 1
	AND m.EnrollmentStatus = 'Assigned'

UNION ALL 
-- =====================================================================
	-- ECMPOF_CHILD_INCARCERATION -- EXISTING LOGIC --
-- =====================================================================
SELECT DISTINCT ' ' AS 'EXISTING LOGIC DETAIL MEMBER LISTING - ECMPOF_CHILD_INCARCERATION'
,mpa.ProviderID
,prov.NPI
,prov.fullname AS [ECM Provider]
,pof.memid
,pof.carriermemid
,pof.lastname
,pof.firstname
,pof.TargetPopulation
,NULL AS [RANGE NOTE(s)]
FROM INFORMATICS.dbo.ECMPOF_CHILD_INCARCERATION (NOLOCK) AS pof -- EXISTING LOGIC
	INNER JOIN ProviderPortal.ECM.Member (NOLOCK) AS m ON pof.memid = m.MemberId
	LEFT JOIN [ProviderPortal].[ECM].[MemberProviderAssigment] (NOLOCK) AS mpa ON pof.memid = mpa.MemberId
		LEFT JOIN HMOPROD_PLANDATA.dbo.[provider] (NOLOCK) AS prov ON mpa.ProviderID = prov.provid
WHERE 1=1
	AND pof.[RunDate] = ( SELECT MAX(i.[RunDate]) FROM INFORMATICS.dbo.ECMPOF_CHILD_INCARCERATION AS i WITH (NOLOCK) )
	AND m.ISECM = 1
	AND m.EnrollmentStatus = 'Assigned'

UNION ALL 
-- =====================================================================
	-- ECMPOF_CHILD_CCS -- EXISTING LOGIC --
-- =====================================================================
SELECT DISTINCT ' ' AS 'EXISTING LOGIC DETAIL MEMBER LISTING - ECMPOF_CHILD_CCS'
,mpa.ProviderID
,prov.NPI
,prov.fullname AS [ECM Provider]
,pof.memid
,pof.carriermemid
,pof.lastname
,pof.firstname
,pof.TargetPopulation
,NULL AS [RANGE NOTE(s)]
FROM INFORMATICS.dbo.ECMPOF_CHILD_CCS (NOLOCK) AS pof -- EXISTING LOGIC
	INNER JOIN ProviderPortal.ECM.Member (NOLOCK) AS m ON pof.memid = m.MemberId
	LEFT JOIN [ProviderPortal].[ECM].[MemberProviderAssigment] (NOLOCK) AS mpa ON pof.memid = mpa.MemberId
		LEFT JOIN HMOPROD_PLANDATA.dbo.[provider] (NOLOCK) AS prov ON mpa.ProviderID = prov.provid
WHERE 1=1
	AND pof.[RunDate] = ( SELECT MAX(i.[RunDate]) FROM INFORMATICS.dbo.ECMPOF_CHILD_CCS AS i WITH (NOLOCK) )
	AND m.ISECM = 1
	AND m.EnrollmentStatus = 'Assigned'

UNION ALL 
-- =====================================================================
	-- ECMPOF_CHILD_WELFARE -- EXISTING LOGIC --
-- =====================================================================
SELECT DISTINCT ' ' AS 'EXISTING LOGIC DETAIL MEMBER LISTING - ECMPOF_CHILD_WELFARE'
,mpa.ProviderID
,prov.NPI
,prov.fullname AS [ECM Provider]
,pof.memid
,pof.carriermemid
,pof.lastname
,pof.firstname
,pof.TargetPopulation
,NULL AS [RANGE NOTE(s)]
FROM INFORMATICS.dbo.ECMPOF_CHILD_WELFARE (NOLOCK) AS pof -- EXISTING LOGIC
	INNER JOIN ProviderPortal.ECM.Member (NOLOCK) AS m ON pof.memid = m.MemberId
	LEFT JOIN [ProviderPortal].[ECM].[MemberProviderAssigment] (NOLOCK) AS mpa ON pof.memid = mpa.MemberId
		LEFT JOIN HMOPROD_PLANDATA.dbo.[provider] (NOLOCK) AS prov ON mpa.ProviderID = prov.provid
WHERE 1=1
	AND pof.[RunDate] = ( SELECT MAX(i.[RunDate]) FROM INFORMATICS.dbo.ECMPOF_CHILD_WELFARE AS i WITH (NOLOCK) )
	AND m.ISECM = 1
	AND m.EnrollmentStatus = 'Assigned'

UNION ALL 
-- =====================================================================
	-- ECMPOF_ADULT_BIRTH_EQUITY -- EXISTING LOGIC --
-- =====================================================================
SELECT DISTINCT ' ' AS 'EXISTING LOGIC DETAIL MEMBER LISTING - ECMPOF_ADULT_BIRTH_EQUITY'
,mpa.ProviderID
,prov.NPI
,prov.fullname AS [ECM Provider]
,pof.memid
,pof.carriermemid
,pof.lastname
,pof.firstname
,pof.TargetPopulation
,pof.[RANGE NOTE(s)]
FROM INFORMATICS.dbo.ECMPOF_ADULT_BIRTH_EQUITY (NOLOCK) AS pof -- EXISTING LOGIC
	INNER JOIN ProviderPortal.ECM.Member (NOLOCK) AS m ON pof.memid = m.MemberId
	LEFT JOIN [ProviderPortal].[ECM].[MemberProviderAssigment] (NOLOCK) AS mpa ON pof.memid = mpa.MemberId
		LEFT JOIN HMOPROD_PLANDATA.dbo.[provider] (NOLOCK) AS prov ON mpa.ProviderID = prov.provid
WHERE 1=1
	AND pof.[RunDate] = ( SELECT MAX(i.[RunDate]) FROM INFORMATICS.dbo.ECMPOF_ADULT_BIRTH_EQUITY AS i WITH (NOLOCK) )
	AND m.ISECM = 1
	AND m.EnrollmentStatus = 'Assigned'

UNION ALL 
-- =====================================================================
	-- ECMPOF_ADULT_IPSNFED_HIGHUTIL -- EXISTING LOGIC --
-- =====================================================================
SELECT DISTINCT ' ' AS 'EXISTING LOGIC DETAIL MEMBER LISTING - ECMPOF_ADULT_IPSNFED_HIGHUTIL'
,mpa.ProviderID
,prov.NPI
,prov.fullname AS [ECM Provider]
,pof.memid
,pof.carriermemid
,pof.lastname
,pof.firstname
,pof.TargetPopulation
,pof.[RANGE NOTE(s)]
FROM INFORMATICS.dbo.ECMPOF_ADULT_IPSNFED_HIGHUTIL (NOLOCK) AS pof -- EXISTING LOGIC
	INNER JOIN ProviderPortal.ECM.Member (NOLOCK) AS m ON pof.memid = m.MemberId
	LEFT JOIN [ProviderPortal].[ECM].[MemberProviderAssigment] (NOLOCK) AS mpa ON pof.memid = mpa.MemberId
		LEFT JOIN HMOPROD_PLANDATA.dbo.[provider] (NOLOCK) AS prov ON mpa.ProviderID = prov.provid
WHERE 1=1
	AND pof.[RunDate] = ( SELECT MAX(i.[RunDate]) FROM INFORMATICS.dbo.ECMPOF_ADULT_IPSNFED_HIGHUTIL AS i WITH (NOLOCK) )
	AND m.ISECM = 1
	AND m.EnrollmentStatus = 'Assigned'

UNION ALL 
-- =====================================================================
	-- ECMPOF_ADULT_MHSMISUD -- EXISTING LOGIC --
-- =====================================================================
SELECT DISTINCT ' ' AS 'EXISTING LOGIC DETAIL MEMBER LISTING - ECMPOF_ADULT_MHSMISUD'
,mpa.ProviderID
,prov.NPI
,prov.fullname AS [ECM Provider]
,pof.memid
,pof.carriermemid
,pof.lastname
,pof.firstname
,pof.TargetPopulation
,pof.[RANGE NOTE(s)]
FROM INFORMATICS.dbo.ECMPOF_ADULT_MHSMISUD (NOLOCK) AS pof -- EXISTING LOGIC
	INNER JOIN ProviderPortal.ECM.Member (NOLOCK) AS m ON pof.memid = m.MemberId
	LEFT JOIN [ProviderPortal].[ECM].[MemberProviderAssigment] (NOLOCK) AS mpa ON pof.memid = mpa.MemberId
		LEFT JOIN HMOPROD_PLANDATA.dbo.[provider] (NOLOCK) AS prov ON mpa.ProviderID = prov.provid
WHERE 1=1
	AND pof.[RunDate] = ( SELECT MAX(i.[RunDate]) FROM INFORMATICS.dbo.ECMPOF_ADULT_MHSMISUD AS i WITH (NOLOCK) )
	AND m.ISECM = 1
	AND m.EnrollmentStatus = 'Assigned'

UNION ALL 
-- =====================================================================
	-- ECMPOF_ADULT_INCARCERATION -- EXISTING LOGIC --
-- =====================================================================
SELECT DISTINCT ' ' AS 'EXISTING LOGIC DETAIL MEMBER LISTING - ECMPOF_ADULT_INCARCERATION'
,mpa.ProviderID
,prov.NPI
,prov.fullname AS [ECM Provider]
,pof.memid
,pof.carriermemid
,pof.lastname
,pof.firstname
,pof.TargetPopulation
,NULL AS [RANGE NOTE(s)]
FROM INFORMATICS.dbo.ECMPOF_ADULT_INCARCERATION (NOLOCK) AS pof -- EXISTING LOGIC
	INNER JOIN ProviderPortal.ECM.Member (NOLOCK) AS m ON pof.memid = m.MemberId
	LEFT JOIN [ProviderPortal].[ECM].[MemberProviderAssigment] (NOLOCK) AS mpa ON pof.memid = mpa.MemberId
		LEFT JOIN HMOPROD_PLANDATA.dbo.[provider] (NOLOCK) AS prov ON mpa.ProviderID = prov.provid
WHERE 1=1
	AND pof.[RunDate] = ( SELECT MAX(i.[RunDate]) FROM INFORMATICS.dbo.ECMPOF_ADULT_INCARCERATION AS i WITH (NOLOCK) )
	AND m.ISECM = 1
	AND m.EnrollmentStatus = 'Assigned'

UNION ALL 
-- =====================================================================
	-- ECMPOF_ADULT_INSTITUTIONALIZATION -- EXISTING LOGIC --
-- =====================================================================
SELECT DISTINCT ' ' AS 'EXISTING LOGIC DETAIL MEMBER LISTING - ECMPOF_ADULT_INSTITUTIONALIZATION'
,mpa.ProviderID
,prov.NPI
,prov.fullname AS [ECM Provider]
,pof.memid
,pof.carriermemid
,pof.lastname
,pof.firstname
,pof.TargetPopulation
,NULL AS [RANGE NOTE(s)]
FROM INFORMATICS.dbo.ECMPOF_ADULT_INSTITUTIONALIZATION (NOLOCK) AS pof -- EXISTING LOGIC
	INNER JOIN ProviderPortal.ECM.Member (NOLOCK) AS m ON pof.memid = m.MemberId
	LEFT JOIN [ProviderPortal].[ECM].[MemberProviderAssigment] (NOLOCK) AS mpa ON pof.memid = mpa.MemberId
		LEFT JOIN HMOPROD_PLANDATA.dbo.[provider] (NOLOCK) AS prov ON mpa.ProviderID = prov.provid
WHERE 1=1
	AND pof.[RunDate] = ( SELECT MAX(i.[RunDate]) FROM INFORMATICS.dbo.ECMPOF_ADULT_INSTITUTIONALIZATION AS i WITH (NOLOCK) )
	AND m.ISECM = 1
	AND m.EnrollmentStatus = 'Assigned'

UNION ALL 
-- =====================================================================
	-- ECMPOF_ADULT_NURSING_TRANSITION -- EXISTING LOGIC --
-- =====================================================================
SELECT DISTINCT ' ' AS 'EXISTING LOGIC DETAIL MEMBER LISTING - ECMPOF_ADULT_NURSING_TRANSITION'
,mpa.ProviderID
,prov.NPI
,prov.fullname AS [ECM Provider]
,pof.memid
,pof.carriermemid
,pof.lastname
,pof.firstname
,pof.TargetPopulation
,pof.[RANGE NOTE(s)]
FROM INFORMATICS.dbo.ECMPOF_ADULT_NURSING_TRANSITION (NOLOCK) AS pof -- EXISTING LOGIC
	INNER JOIN ProviderPortal.ECM.Member (NOLOCK) AS m ON pof.memid = m.MemberId
	LEFT JOIN [ProviderPortal].[ECM].[MemberProviderAssigment] (NOLOCK) AS mpa ON pof.memid = mpa.MemberId
		LEFT JOIN HMOPROD_PLANDATA.dbo.[provider] (NOLOCK) AS prov ON mpa.ProviderID = prov.provid
WHERE 1=1
	AND pof.[RunDate] = ( SELECT MAX(i.[RunDate]) FROM INFORMATICS.dbo.ECMPOF_ADULT_NURSING_TRANSITION AS i WITH (NOLOCK) )
	AND m.ISECM = 1
	AND m.EnrollmentStatus = 'Assigned'

UNION ALL 
-- =====================================================================
	-- ECMPOF_ADULTWITHFAMILY_HOMELESS -- EXISTING LOGIC --
-- =====================================================================
SELECT DISTINCT ' ' AS 'EXISTING LOGIC DETAIL MEMBER LISTING - ECMPOF_ADULTWITHFAMILY_HOMELESS'
,mpa.ProviderID
,prov.NPI
,prov.fullname AS [ECM Provider]
,pof.memid
,pof.carriermemid
,pof.lastname
,pof.firstname
,pof.TargetPopulation
,pof.[RANGE NOTE(s)]
FROM INFORMATICS.dbo.ECMPOF_ADULTWITHFAMILY_HOMELESS (NOLOCK) AS pof -- EXISTING LOGIC
	INNER JOIN ProviderPortal.ECM.Member (NOLOCK) AS m ON pof.memid = m.MemberId
	LEFT JOIN [ProviderPortal].[ECM].[MemberProviderAssigment] (NOLOCK) AS mpa ON pof.memid = mpa.MemberId
		LEFT JOIN HMOPROD_PLANDATA.dbo.[provider] (NOLOCK) AS prov ON mpa.ProviderID = prov.provid
WHERE 1=1
	AND pof.[RunDate] = ( SELECT MAX(i.[RunDate]) FROM INFORMATICS.dbo.ECMPOF_ADULTWITHFAMILY_HOMELESS AS i WITH (NOLOCK) )
	AND m.ISECM = 1
	AND m.EnrollmentStatus = 'Assigned'

UNION ALL 
-- =====================================================================
	-- ECMPOF_ADULTWITHOUTFAMILY_HOMELESS -- EXISTING LOGIC --
-- =====================================================================
SELECT DISTINCT ' ' AS 'EXISTING LOGIC DETAIL MEMBER LISTING - ECMPOF_ADULTWITHOUTFAMILY_HOMELESS'
,mpa.ProviderID
,prov.NPI
,prov.fullname AS [ECM Provider]
,pof.memid
,pof.carriermemid
,pof.lastname
,pof.firstname
,pof.TargetPopulation
,pof.[RANGE NOTE(s)]
FROM INFORMATICS.dbo.ECMPOF_ADULTWITHOUTFAMILY_HOMELESS (NOLOCK) AS pof -- EXISTING LOGIC
	INNER JOIN ProviderPortal.ECM.Member (NOLOCK) AS m ON pof.memid = m.MemberId
	LEFT JOIN [ProviderPortal].[ECM].[MemberProviderAssigment] (NOLOCK) AS mpa ON pof.memid = mpa.MemberId
		LEFT JOIN HMOPROD_PLANDATA.dbo.[provider] (NOLOCK) AS prov ON mpa.ProviderID = prov.provid
WHERE 1=1
	AND pof.[RunDate] = ( SELECT MAX(i.[RunDate]) FROM INFORMATICS.dbo.ECMPOF_ADULTWITHOUTFAMILY_HOMELESS AS i WITH (NOLOCK) )
	AND m.ISECM = 1
	AND m.EnrollmentStatus = 'Assigned'







	-- ALGORITHM LOGIC DETAIL: 
-- =====================================================================
	-- CHATGPT_ECMPOF_CHILD_BIRTH_EQUITY -- ALGORITHM LOGIC --
-- =====================================================================
SELECT DISTINCT ' ' AS 'ALGORITHM LOGIC DETAIL MEMBER LISTING - CHATGPT_ECMPOF_CHILD_BIRTH_EQUITY'
,mpa.ProviderID
,prov.NPI
,prov.fullname AS [ECM Provider]
,pof.memid
,pof.carriermemid
,pof.lastname
,pof.firstname
,pof.TargetPopulation
,pof.[RANGE NOTE(s)]
FROM INFORMATICS.dbo.CHATGPT_ECMPOF_CHILD_BIRTH_EQUITY (NOLOCK) AS pof -- ALGORITHM POF LOGIC ADJUSTMENT
	INNER JOIN ProviderPortal.ECM.Member (NOLOCK) AS m ON pof.memid = m.MemberId
	LEFT JOIN [ProviderPortal].[ECM].[MemberProviderAssigment] (NOLOCK) AS mpa ON pof.memid = mpa.MemberId
		LEFT JOIN HMOPROD_PLANDATA.dbo.[provider] (NOLOCK) AS prov ON mpa.ProviderID = prov.provid
WHERE 1=1
	AND pof.[RunDate] = ( SELECT MAX(i.[RunDate]) FROM INFORMATICS.dbo.CHATGPT_ECMPOF_CHILD_BIRTH_EQUITY AS i WITH (NOLOCK) )
	AND m.ISECM = 1
	AND m.EnrollmentStatus = 'Assigned'

UNION ALL 
-- =====================================================================
	-- CHATGPT_ECMPOF_CHILDWITHFAMILY_HOMELESS -- ALGORITHM LOGIC --
-- =====================================================================
SELECT DISTINCT ' ' AS 'ALGORITHM LOGIC DETAIL MEMBER LISTING - CHATGPT_ECMPOF_CHILDWITHFAMILY_HOMELESS'
,mpa.ProviderID
,prov.NPI
,prov.fullname AS [ECM Provider]
,pof.memid
,pof.carriermemid
,pof.lastname
,pof.firstname
,pof.TargetPopulation
,pof.[RANGE NOTE(s)]
FROM INFORMATICS.dbo.CHATGPT_ECMPOF_CHILDWITHFAMILY_HOMELESS (NOLOCK) AS pof -- ALGORITHM POF LOGIC ADJUSTMENT
	INNER JOIN ProviderPortal.ECM.Member (NOLOCK) AS m ON pof.memid = m.MemberId
	LEFT JOIN [ProviderPortal].[ECM].[MemberProviderAssigment] (NOLOCK) AS mpa ON pof.memid = mpa.MemberId
		LEFT JOIN HMOPROD_PLANDATA.dbo.[provider] (NOLOCK) AS prov ON mpa.ProviderID = prov.provid
WHERE 1=1
	AND pof.[RunDate] = ( SELECT MAX(i.[RunDate]) FROM INFORMATICS.dbo.CHATGPT_ECMPOF_CHILDWITHFAMILY_HOMELESS AS i WITH (NOLOCK) )
	AND m.ISECM = 1
	AND m.EnrollmentStatus = 'Assigned'

UNION ALL 
-- =====================================================================
	-- CHATGPT_ECMPOF_CHILDWITHOUTFAMILY_HOMELESS -- ALGORITHM LOGIC --
-- =====================================================================
SELECT DISTINCT ' ' AS 'ALGORITHM LOGIC DETAIL MEMBER LISTING - CHATGPT_ECMPOF_CHILDWITHOUTFAMILY_HOMELESS'
,mpa.ProviderID
,prov.NPI
,prov.fullname AS [ECM Provider]
,pof.memid
,pof.carriermemid
,pof.lastname
,pof.firstname
,pof.TargetPopulation
,pof.[RANGE NOTE(s)]
FROM INFORMATICS.dbo.CHATGPT_ECMPOF_CHILDWITHOUTFAMILY_HOMELESS (NOLOCK) AS pof -- ALGORITHM POF LOGIC ADJUSTMENT
	INNER JOIN ProviderPortal.ECM.Member (NOLOCK) AS m ON pof.memid = m.MemberId
	LEFT JOIN [ProviderPortal].[ECM].[MemberProviderAssigment] (NOLOCK) AS mpa ON pof.memid = mpa.MemberId
		LEFT JOIN HMOPROD_PLANDATA.dbo.[provider] (NOLOCK) AS prov ON mpa.ProviderID = prov.provid
WHERE 1=1
	AND pof.[RunDate] = ( SELECT MAX(i.[RunDate]) FROM INFORMATICS.dbo.CHATGPT_ECMPOF_CHILDWITHOUTFAMILY_HOMELESS AS i WITH (NOLOCK) )
	AND m.ISECM = 1
	AND m.EnrollmentStatus = 'Assigned'

UNION ALL 
-- =====================================================================
	-- CHATGPT_ECMPOF_CHILD_IPSNFED_HIGHUTIL -- ALGORITHM LOGIC --
-- =====================================================================
SELECT DISTINCT ' ' AS 'ALGORITHM LOGIC DETAIL MEMBER LISTING - CHATGPT_ECMPOF_CHILD_IPSNFED_HIGHUTIL'
,mpa.ProviderID
,prov.NPI
,prov.fullname AS [ECM Provider]
,pof.memid
,pof.carriermemid
,pof.lastname
,pof.firstname
,pof.TargetPopulation
,pof.[RANGE NOTE(s)]
FROM INFORMATICS.dbo.CHATGPT_ECMPOF_CHILD_IPSNFED_HIGHUTIL (NOLOCK) AS pof -- ALGORITHM POF LOGIC ADJUSTMENT
	INNER JOIN ProviderPortal.ECM.Member (NOLOCK) AS m ON pof.memid = m.MemberId
	LEFT JOIN [ProviderPortal].[ECM].[MemberProviderAssigment] (NOLOCK) AS mpa ON pof.memid = mpa.MemberId
		LEFT JOIN HMOPROD_PLANDATA.dbo.[provider] (NOLOCK) AS prov ON mpa.ProviderID = prov.provid
WHERE 1=1
	AND pof.[RunDate] = ( SELECT MAX(i.[RunDate]) FROM INFORMATICS.dbo.CHATGPT_ECMPOF_CHILD_IPSNFED_HIGHUTIL AS i WITH (NOLOCK) )
	AND m.ISECM = 1
	AND m.EnrollmentStatus = 'Assigned'

UNION ALL 
-- =====================================================================
	-- CHATGPT_ECMPOF_CHILD_MHSMISUD -- ALGORITHM LOGIC --
-- =====================================================================
SELECT DISTINCT ' ' AS 'ALGORITHM LOGIC DETAIL MEMBER LISTING - CHATGPT_ECMPOF_CHILD_MHSMISUD'
,mpa.ProviderID
,prov.NPI
,prov.fullname AS [ECM Provider]
,pof.memid
,pof.carriermemid
,pof.lastname
,pof.firstname
,pof.TargetPopulation
,pof.[RANGE NOTE(s)]
FROM INFORMATICS.dbo.CHATGPT_ECMPOF_CHILD_MHSMISUD (NOLOCK) AS pof -- ALGORITHM POF LOGIC ADJUSTMENT
	INNER JOIN ProviderPortal.ECM.Member (NOLOCK) AS m ON pof.memid = m.MemberId
	LEFT JOIN [ProviderPortal].[ECM].[MemberProviderAssigment] (NOLOCK) AS mpa ON pof.memid = mpa.MemberId
		LEFT JOIN HMOPROD_PLANDATA.dbo.[provider] (NOLOCK) AS prov ON mpa.ProviderID = prov.provid
WHERE 1=1
	AND pof.[RunDate] = ( SELECT MAX(i.[RunDate]) FROM INFORMATICS.dbo.CHATGPT_ECMPOF_CHILD_MHSMISUD AS i WITH (NOLOCK) )
	AND m.ISECM = 1
	AND m.EnrollmentStatus = 'Assigned'

UNION ALL 
-- =====================================================================
	-- CHATGPT_ECMPOF_CHILD_INCARCERATION -- ALGORITHM LOGIC --
-- =====================================================================
SELECT DISTINCT ' ' AS 'ALGORITHM LOGIC DETAIL MEMBER LISTING - CHATGPT_ECMPOF_CHILD_INCARCERATION'
,mpa.ProviderID
,prov.NPI
,prov.fullname AS [ECM Provider]
,pof.memid
,pof.carriermemid
,pof.lastname
,pof.firstname
,pof.TargetPopulation
,NULL AS [RANGE NOTE(s)]
FROM INFORMATICS.dbo.CHATGPT_ECMPOF_CHILD_INCARCERATION (NOLOCK) AS pof -- ALGORITHM POF LOGIC ADJUSTMENT
	INNER JOIN ProviderPortal.ECM.Member (NOLOCK) AS m ON pof.memid = m.MemberId
	LEFT JOIN [ProviderPortal].[ECM].[MemberProviderAssigment] (NOLOCK) AS mpa ON pof.memid = mpa.MemberId
		LEFT JOIN HMOPROD_PLANDATA.dbo.[provider] (NOLOCK) AS prov ON mpa.ProviderID = prov.provid
WHERE 1=1
	AND pof.[RunDate] = ( SELECT MAX(i.[RunDate]) FROM INFORMATICS.dbo.CHATGPT_ECMPOF_CHILD_INCARCERATION AS i WITH (NOLOCK) )
	AND m.ISECM = 1
	AND m.EnrollmentStatus = 'Assigned'

UNION ALL 
-- =====================================================================
	-- CHATGPT_ECMPOF_CHILD_CCS -- ALGORITHM LOGIC --
-- =====================================================================
SELECT DISTINCT ' ' AS 'ALGORITHM LOGIC DETAIL MEMBER LISTING - CHATGPT_ECMPOF_CHILD_CCS'
,mpa.ProviderID
,prov.NPI
,prov.fullname AS [ECM Provider]
,pof.memid
,pof.carriermemid
,pof.lastname
,pof.firstname
,pof.TargetPopulation
,NULL AS [RANGE NOTE(s)]
FROM INFORMATICS.dbo.CHATGPT_ECMPOF_CHILD_CCS (NOLOCK) AS pof -- ALGORITHM POF LOGIC ADJUSTMENT
	INNER JOIN ProviderPortal.ECM.Member (NOLOCK) AS m ON pof.memid = m.MemberId
	LEFT JOIN [ProviderPortal].[ECM].[MemberProviderAssigment] (NOLOCK) AS mpa ON pof.memid = mpa.MemberId
		LEFT JOIN HMOPROD_PLANDATA.dbo.[provider] (NOLOCK) AS prov ON mpa.ProviderID = prov.provid
WHERE 1=1
	AND pof.[RunDate] = ( SELECT MAX(i.[RunDate]) FROM INFORMATICS.dbo.CHATGPT_ECMPOF_CHILD_CCS AS i WITH (NOLOCK) )
	AND m.ISECM = 1
	AND m.EnrollmentStatus = 'Assigned'

UNION ALL 
-- =====================================================================
	-- CHATGPT_ECMPOF_CHILD_WELFARE -- ALGORITHM LOGIC --
-- =====================================================================
SELECT DISTINCT ' ' AS 'ALGORITHM LOGIC DETAIL MEMBER LISTING - CHATGPT_ECMPOF_CHILD_WELFARE'
,mpa.ProviderID
,prov.NPI
,prov.fullname AS [ECM Provider]
,pof.memid
,pof.carriermemid
,pof.lastname
,pof.firstname
,pof.TargetPopulation
,NULL AS [RANGE NOTE(s)]
FROM INFORMATICS.dbo.CHATGPT_ECMPOF_CHILD_WELFARE (NOLOCK) AS pof -- ALGORITHM POF LOGIC ADJUSTMENT
	INNER JOIN ProviderPortal.ECM.Member (NOLOCK) AS m ON pof.memid = m.MemberId
	LEFT JOIN [ProviderPortal].[ECM].[MemberProviderAssigment] (NOLOCK) AS mpa ON pof.memid = mpa.MemberId
		LEFT JOIN HMOPROD_PLANDATA.dbo.[provider] (NOLOCK) AS prov ON mpa.ProviderID = prov.provid
WHERE 1=1
	AND pof.[RunDate] = ( SELECT MAX(i.[RunDate]) FROM INFORMATICS.dbo.CHATGPT_ECMPOF_CHILD_WELFARE AS i WITH (NOLOCK) )
	AND m.ISECM = 1
	AND m.EnrollmentStatus = 'Assigned'

UNION ALL 
-- =====================================================================
	-- CHATGPT_ECMPOF_ADULT_BIRTH_EQUITY -- ALGORITHM LOGIC --
-- =====================================================================
SELECT DISTINCT ' ' AS 'ALGORITHM LOGIC DETAIL MEMBER LISTING - CHATGPT_ECMPOF_ADULT_BIRTH_EQUITY'
,mpa.ProviderID
,prov.NPI
,prov.fullname AS [ECM Provider]
,pof.memid
,pof.carriermemid
,pof.lastname
,pof.firstname
,pof.TargetPopulation
,pof.[RANGE NOTE(s)]
FROM INFORMATICS.dbo.CHATGPT_ECMPOF_ADULT_BIRTH_EQUITY (NOLOCK) AS pof -- ALGORITHM POF LOGIC ADJUSTMENT
	INNER JOIN ProviderPortal.ECM.Member (NOLOCK) AS m ON pof.memid = m.MemberId
	LEFT JOIN [ProviderPortal].[ECM].[MemberProviderAssigment] (NOLOCK) AS mpa ON pof.memid = mpa.MemberId
		LEFT JOIN HMOPROD_PLANDATA.dbo.[provider] (NOLOCK) AS prov ON mpa.ProviderID = prov.provid
WHERE 1=1
	AND pof.[RunDate] = ( SELECT MAX(i.[RunDate]) FROM INFORMATICS.dbo.CHATGPT_ECMPOF_ADULT_BIRTH_EQUITY AS i WITH (NOLOCK) )
	AND m.ISECM = 1
	AND m.EnrollmentStatus = 'Assigned'

UNION ALL 
-- =====================================================================
	-- CHATGPT_ECMPOF_ADULT_IPSNFED_HIGHUTIL -- ALGORITHM LOGIC --
-- =====================================================================
SELECT DISTINCT ' ' AS 'ALGORITHM LOGIC DETAIL MEMBER LISTING - CHATGPT_ECMPOF_ADULT_IPSNFED_HIGHUTIL'
,mpa.ProviderID
,prov.NPI
,prov.fullname AS [ECM Provider]
,pof.memid
,pof.carriermemid
,pof.lastname
,pof.firstname
,pof.TargetPopulation
,pof.[RANGE NOTE(s)]
FROM INFORMATICS.dbo.CHATGPT_ECMPOF_ADULT_IPSNFED_HIGHUTIL (NOLOCK) AS pof -- ALGORITHM POF LOGIC ADJUSTMENT
	INNER JOIN ProviderPortal.ECM.Member (NOLOCK) AS m ON pof.memid = m.MemberId
	LEFT JOIN [ProviderPortal].[ECM].[MemberProviderAssigment] (NOLOCK) AS mpa ON pof.memid = mpa.MemberId
		LEFT JOIN HMOPROD_PLANDATA.dbo.[provider] (NOLOCK) AS prov ON mpa.ProviderID = prov.provid
WHERE 1=1
	AND pof.[RunDate] = ( SELECT MAX(i.[RunDate]) FROM INFORMATICS.dbo.CHATGPT_ECMPOF_ADULT_IPSNFED_HIGHUTIL AS i WITH (NOLOCK) )
	AND m.ISECM = 1
	AND m.EnrollmentStatus = 'Assigned'

UNION ALL 
-- =====================================================================
	-- CHATGPT_ECMPOF_ADULT_MHSMISUD -- ALGORITHM LOGIC --
-- =====================================================================
SELECT DISTINCT ' ' AS 'ALGORITHM LOGIC DETAIL MEMBER LISTING - CHATGPT_ECMPOF_ADULT_MHSMISUD'
,mpa.ProviderID
,prov.NPI
,prov.fullname AS [ECM Provider]
,pof.memid
,pof.carriermemid
,pof.lastname
,pof.firstname
,pof.TargetPopulation
,pof.[RANGE NOTE(s)]
FROM INFORMATICS.dbo.CHATGPT_ECMPOF_ADULT_MHSMISUD (NOLOCK) AS pof -- ALGORITHM POF LOGIC ADJUSTMENT
	INNER JOIN ProviderPortal.ECM.Member (NOLOCK) AS m ON pof.memid = m.MemberId
	LEFT JOIN [ProviderPortal].[ECM].[MemberProviderAssigment] (NOLOCK) AS mpa ON pof.memid = mpa.MemberId
		LEFT JOIN HMOPROD_PLANDATA.dbo.[provider] (NOLOCK) AS prov ON mpa.ProviderID = prov.provid
WHERE 1=1
	AND pof.[RunDate] = ( SELECT MAX(i.[RunDate]) FROM INFORMATICS.dbo.CHATGPT_ECMPOF_ADULT_MHSMISUD AS i WITH (NOLOCK) )
	AND m.ISECM = 1
	AND m.EnrollmentStatus = 'Assigned'

UNION ALL 
-- =====================================================================
	-- CHATGPT_ECMPOF_ADULT_INCARCERATION -- ALGORITHM LOGIC --
-- =====================================================================
SELECT DISTINCT ' ' AS 'ALGORITHM LOGIC DETAIL MEMBER LISTING - CHATGPT_ECMPOF_ADULT_INCARCERATION'
,mpa.ProviderID
,prov.NPI
,prov.fullname AS [ECM Provider]
,pof.memid
,pof.carriermemid
,pof.lastname
,pof.firstname
,pof.TargetPopulation
,NULL AS [RANGE NOTE(s)]
FROM INFORMATICS.dbo.CHATGPT_ECMPOF_ADULT_INCARCERATION (NOLOCK) AS pof -- ALGORITHM POF LOGIC ADJUSTMENT
	INNER JOIN ProviderPortal.ECM.Member (NOLOCK) AS m ON pof.memid = m.MemberId
	LEFT JOIN [ProviderPortal].[ECM].[MemberProviderAssigment] (NOLOCK) AS mpa ON pof.memid = mpa.MemberId
		LEFT JOIN HMOPROD_PLANDATA.dbo.[provider] (NOLOCK) AS prov ON mpa.ProviderID = prov.provid
WHERE 1=1
	AND pof.[RunDate] = ( SELECT MAX(i.[RunDate]) FROM INFORMATICS.dbo.CHATGPT_ECMPOF_ADULT_INCARCERATION AS i WITH (NOLOCK) )
	AND m.ISECM = 1
	AND m.EnrollmentStatus = 'Assigned'

UNION ALL 
-- =====================================================================
	-- CHATGPT_ECMPOF_ADULT_INSTITUTIONALIZATION -- ALGORITHM LOGIC --
-- =====================================================================
SELECT DISTINCT ' ' AS 'ALGORITHM LOGIC DETAIL MEMBER LISTING - CHATGPT_ECMPOF_ADULT_INSTITUTIONALIZATION'
,mpa.ProviderID
,prov.NPI
,prov.fullname AS [ECM Provider]
,pof.memid
,pof.carriermemid
,pof.lastname
,pof.firstname
,pof.TargetPopulation
,NULL AS [RANGE NOTE(s)]
FROM INFORMATICS.dbo.CHATGPT_ECMPOF_ADULT_INSTITUTIONALIZATION (NOLOCK) AS pof -- ALGORITHM POF LOGIC ADJUSTMENT
	INNER JOIN ProviderPortal.ECM.Member (NOLOCK) AS m ON pof.memid = m.MemberId
	LEFT JOIN [ProviderPortal].[ECM].[MemberProviderAssigment] (NOLOCK) AS mpa ON pof.memid = mpa.MemberId
		LEFT JOIN HMOPROD_PLANDATA.dbo.[provider] (NOLOCK) AS prov ON mpa.ProviderID = prov.provid
WHERE 1=1
	AND pof.[RunDate] = ( SELECT MAX(i.[RunDate]) FROM INFORMATICS.dbo.CHATGPT_ECMPOF_ADULT_INSTITUTIONALIZATION AS i WITH (NOLOCK) )
	AND m.ISECM = 1
	AND m.EnrollmentStatus = 'Assigned'

UNION ALL 
-- =====================================================================
	-- CHATGPT_ECMPOF_ADULT_NURSING_TRANSITION -- ALGORITHM LOGIC --
-- =====================================================================
SELECT DISTINCT ' ' AS 'ALGORITHM LOGIC DETAIL MEMBER LISTING - CHATGPT_ECMPOF_ADULT_NURSING_TRANSITION'
,mpa.ProviderID
,prov.NPI
,prov.fullname AS [ECM Provider]
,pof.memid
,pof.carriermemid
,pof.lastname
,pof.firstname
,pof.TargetPopulation
,pof.[RANGE NOTE(s)]
FROM INFORMATICS.dbo.CHATGPT_ECMPOF_ADULT_NURSING_TRANSITION (NOLOCK) AS pof -- ALGORITHM POF LOGIC ADJUSTMENT
	INNER JOIN ProviderPortal.ECM.Member (NOLOCK) AS m ON pof.memid = m.MemberId
	LEFT JOIN [ProviderPortal].[ECM].[MemberProviderAssigment] (NOLOCK) AS mpa ON pof.memid = mpa.MemberId
		LEFT JOIN HMOPROD_PLANDATA.dbo.[provider] (NOLOCK) AS prov ON mpa.ProviderID = prov.provid
WHERE 1=1
	AND pof.[RunDate] = ( SELECT MAX(i.[RunDate]) FROM INFORMATICS.dbo.CHATGPT_ECMPOF_ADULT_NURSING_TRANSITION AS i WITH (NOLOCK) )
	AND m.ISECM = 1
	AND m.EnrollmentStatus = 'Assigned'

UNION ALL 
-- =====================================================================
	-- CHATGPT_ECMPOF_ADULTWITHFAMILY_HOMELESS -- ALGORITHM LOGIC --
-- =====================================================================
SELECT DISTINCT ' ' AS 'ALGORITHM LOGIC DETAIL MEMBER LISTING - CHATGPT_ECMPOF_ADULTWITHFAMILY_HOMELESS'
,mpa.ProviderID
,prov.NPI
,prov.fullname AS [ECM Provider]
,pof.memid
,pof.carriermemid
,pof.lastname
,pof.firstname
,pof.TargetPopulation
,pof.[RANGE NOTE(s)]
FROM INFORMATICS.dbo.CHATGPT_ECMPOF_ADULTWITHFAMILY_HOMELESS (NOLOCK) AS pof -- ALGORITHM POF LOGIC ADJUSTMENT
	INNER JOIN ProviderPortal.ECM.Member (NOLOCK) AS m ON pof.memid = m.MemberId
	LEFT JOIN [ProviderPortal].[ECM].[MemberProviderAssigment] (NOLOCK) AS mpa ON pof.memid = mpa.MemberId
		LEFT JOIN HMOPROD_PLANDATA.dbo.[provider] (NOLOCK) AS prov ON mpa.ProviderID = prov.provid
WHERE 1=1
	AND pof.[RunDate] = ( SELECT MAX(i.[RunDate]) FROM INFORMATICS.dbo.CHATGPT_ECMPOF_ADULTWITHFAMILY_HOMELESS AS i WITH (NOLOCK) )
	AND m.ISECM = 1
	AND m.EnrollmentStatus = 'Assigned'

UNION ALL 
-- =====================================================================
	-- CHATGPT_ECMPOF_ADULTWITHOUTFAMILY_HOMELESS -- ALGORITHM LOGIC --
-- =====================================================================
SELECT DISTINCT ' ' AS 'ALGORITHM LOGIC DETAIL MEMBER LISTING - CHATGPT_ECMPOF_ADULTWITHOUTFAMILY_HOMELESS'
,mpa.ProviderID
,prov.NPI
,prov.fullname AS [ECM Provider]
,pof.memid
,pof.carriermemid
,pof.lastname
,pof.firstname
,pof.TargetPopulation
,pof.[RANGE NOTE(s)]
FROM INFORMATICS.dbo.CHATGPT_ECMPOF_ADULTWITHOUTFAMILY_HOMELESS (NOLOCK) AS pof -- ALGORITHM POF LOGIC ADJUSTMENT
	INNER JOIN ProviderPortal.ECM.Member (NOLOCK) AS m ON pof.memid = m.MemberId
	LEFT JOIN [ProviderPortal].[ECM].[MemberProviderAssigment] (NOLOCK) AS mpa ON pof.memid = mpa.MemberId
		LEFT JOIN HMOPROD_PLANDATA.dbo.[provider] (NOLOCK) AS prov ON mpa.ProviderID = prov.provid
WHERE 1=1
	AND pof.[RunDate] = ( SELECT MAX(i.[RunDate]) FROM INFORMATICS.dbo.CHATGPT_ECMPOF_ADULTWITHOUTFAMILY_HOMELESS AS i WITH (NOLOCK) )
	AND m.ISECM = 1
	AND m.EnrollmentStatus = 'Assigned'

-- =====================================================================
	-- OPEN ITEMS -- 20260714 --
	-- 1) NO 'currently assigned' window OR dedup applied to mpa here, matching the supplied CODE
	--    exactly. Worth confirming whether the raw detail listing should also dedup duplicate
	--    provider-assignment rows before this goes to JAG, given Malik's own exploration surfaced
	--    2 to 3 duplicate mpa rows per member without such a window
	-- 2) carriermemid, lastname, firstname, [RANGE NOTE(s)] are assumed present AND identically
	--    spelled across all 17 existing / 16 algorithm POF tables, per Malik's confirmed field list.
	--    IF any one table's columns differ, that table's block above IS the one to correct
-- =====================================================================
