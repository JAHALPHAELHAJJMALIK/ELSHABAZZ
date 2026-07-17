-- =====================================================================
	-- EXISTING POF v ALGORITHM POF ECM COUNTS 20260714 -- REBUILT per JAG spec --
	-- Sir Allan Sombillo / Sir Yousaf Farook, on behalf of JAG, do NOT want memberattribute used --
	-- Qualifying gate IS now ProviderPortal.ECM.Member directly (m.ISECM = 1 AND
	-- m.EnrollmentStatus = 'Assigned'), matching the CODE Malik supplied 20260714. The prior
	-- #ECMEligible# / #ECMEnrolled# memberattribute derivation (Section 1/2 of the first 20260714
	-- draft) has been removed entirely, per this direction. This collapses the Eligible-vs-Enrolled
	-- split down to ONE qualifying population, 'ECM Enrolled (Assigned to Provider)' --
	-- ALSO answers Sir Allan / Joseph's Teams question 20260714: "net change IN enrollment for each
	-- Provider with the changes" --
-- =====================================================================

-- =====================================================================
	-- DECLARE @PARAMETER(S) / @FILTER(S) -- retained ONLY to drive the #ProviderAssignment#
	-- 'currently assigned' window below, NOT used against memberattribute anymore --
-- =====================================================================
DECLARE @ClockStart AS datetime
DECLARE @ClockStop AS datetime

SET @ClockStart = TRY_CONVERT(date,GETDATE())
SET @ClockStop = TRY_CONVERT(date,GETDATE())

-- =====================================================================
	-- SECTION 1: #PROVIDER ASSIGNMENT# (CURRENT ECM PROVIDER PER MEMBER) --
	-- Provider NAME resolution confirmed by Malik 20260714: HMOPROD_PLANDATA.dbo.[provider]
	-- (prov.provid = mpa.ProviderId), exposing prov.NPI AND prov.fullname --
	-- DEDUP retained AS a value-ADD beyond the supplied CODE: Malik's OWN ad-hoc exploration query,
	-- with NO window AND NO dedup, surfaced 2 to 3 duplicate rows per member (memid 2432180 x3 under
	-- ProviderID 355110). ROW_NUMBER below guards against that fan-out. Flagging this explicitly AS
	-- an addition, NOT a silent deviation from the supplied CODE pattern --
-- =====================================================================
IF OBJECT_ID('tempdb.dbo.#ProviderAssignmentRow#') IS NOT NULL DROP TABLE #ProviderAssignmentRow#
IF OBJECT_ID('tempdb.dbo.#ProviderAssignment#') IS NOT NULL DROP TABLE #ProviderAssignment#

SELECT m.MemberId AS memid
,mpa.ProviderId
,prov.NPI AS ProviderNPI
,prov.fullname AS ProviderName
,mpa.AssignmentID
,mpa.EffDate
,mpa.TermDate
,mpa.RuleId
,ROW_NUMBER() OVER(PARTITION BY m.MemberId ORDER BY mpa.EffDate DESC,mpa.CreateDate DESC) AS ROWNUMBER_Assignment
INTO #ProviderAssignmentRow#
FROM ProviderPortal.ECM.Member (NOLOCK) AS m
	INNER JOIN [SQLPROD02].[ProviderPortal].[ECM].[MemberProviderAssigment] (NOLOCK) AS mpa ON mpa.MemberId = m.MemberId
	LEFT JOIN HMOPROD_PLANDATA.dbo.[provider] (NOLOCK) AS prov ON prov.provid = mpa.ProviderId
WHERE 1=1
	AND m.ISECM = 1
	AND m.EnrollmentStatus = 'Assigned'
	AND TRY_CONVERT(date,mpa.EffDate) <= TRY_CONVERT(date,@ClockStop)
	AND TRY_CONVERT(date,ISNULL(mpa.TermDate,@ClockStop)) >= TRY_CONVERT(date,@ClockStart)

SELECT *
INTO #ProviderAssignment#
FROM #ProviderAssignmentRow#
WHERE 1=1
	AND ROWNUMBER_Assignment = 1

SELECT COUNT(*) AS provider_assignment_record_count FROM #ProviderAssignment#

-- =====================================================================
	-- SECTION 2: MEMBER x POF XREF (de-duplicated), ONE qualifying population, BY LOGIC VERSION --
	-- Qualifying gate: INNER JOIN pof TO ProviderPortal.ECM.Member directly, m.ISECM = 1 AND
	-- m.EnrollmentStatus = 'Assigned', exactly per the supplied CODE. Provider assignment details
	-- (ProviderId/NPI/Name) are pulled separately via LEFT JOIN #ProviderAssignment# downstream, so a
	-- qualifying member with NO current assignment row still surfaces under an 'UNASSIGNED' bucket
	-- rather than being silently dropped --
-- =====================================================================
IF OBJECT_ID('tempdb.dbo.#ExistingPOF_XREF#') IS NOT NULL DROP TABLE #ExistingPOF_XREF#
IF OBJECT_ID('tempdb.dbo.#AlgorithmPOF_XREF#') IS NOT NULL DROP TABLE #AlgorithmPOF_XREF#

	-- EXISTING POF --
SELECT memid
,[TargetPopulation]
INTO #ExistingPOF_XREF#
FROM (
SELECT pof.memid,pof.[TargetPopulation] FROM INFORMATICS.dbo.ECMPOF_CHILD_BIRTH_EQUITY AS pof INNER JOIN ProviderPortal.ECM.Member AS m ON pof.memid = m.MemberId WHERE pof.[RunDate] = ( SELECT MAX(i.[RunDate]) FROM INFORMATICS.dbo.ECMPOF_CHILD_BIRTH_EQUITY AS i WITH (NOLOCK) ) AND m.ISECM = 1 AND m.EnrollmentStatus = 'Assigned'
UNION ALL
SELECT pof.memid,pof.[TargetPopulation] FROM INFORMATICS.dbo.ECMPOF_CHILD_HOMELESS AS pof INNER JOIN ProviderPortal.ECM.Member AS m ON pof.memid = m.MemberId WHERE pof.[RunDate] = ( SELECT MAX(i.[RunDate]) FROM INFORMATICS.dbo.ECMPOF_CHILD_HOMELESS AS i WITH (NOLOCK) ) AND m.ISECM = 1 AND m.EnrollmentStatus = 'Assigned'
UNION ALL
SELECT pof.memid,pof.[TargetPopulation] FROM INFORMATICS.dbo.ECMPOF_CHILDWITHFAMILY_HOMELESS AS pof INNER JOIN ProviderPortal.ECM.Member AS m ON pof.memid = m.MemberId WHERE pof.[RunDate] = ( SELECT MAX(i.[RunDate]) FROM INFORMATICS.dbo.ECMPOF_CHILDWITHFAMILY_HOMELESS AS i WITH (NOLOCK) ) AND m.ISECM = 1 AND m.EnrollmentStatus = 'Assigned'
UNION ALL
SELECT pof.memid,pof.[TargetPopulation] FROM INFORMATICS.dbo.ECMPOF_CHILDWITHOUTFAMILY_HOMELESS AS pof INNER JOIN ProviderPortal.ECM.Member AS m ON pof.memid = m.MemberId WHERE pof.[RunDate] = ( SELECT MAX(i.[RunDate]) FROM INFORMATICS.dbo.ECMPOF_CHILDWITHOUTFAMILY_HOMELESS AS i WITH (NOLOCK) ) AND m.ISECM = 1 AND m.EnrollmentStatus = 'Assigned'
UNION ALL
SELECT pof.memid,pof.[TargetPopulation] FROM INFORMATICS.dbo.ECMPOF_CHILD_IPSNFED_HIGHUTIL AS pof INNER JOIN ProviderPortal.ECM.Member AS m ON pof.memid = m.MemberId WHERE pof.[RunDate] = ( SELECT MAX(i.[RunDate]) FROM INFORMATICS.dbo.ECMPOF_CHILD_IPSNFED_HIGHUTIL AS i WITH (NOLOCK) ) AND m.ISECM = 1 AND m.EnrollmentStatus = 'Assigned'
UNION ALL
SELECT pof.memid,pof.[TargetPopulation] FROM INFORMATICS.dbo.ECMPOF_CHILD_MHSMISUD AS pof INNER JOIN ProviderPortal.ECM.Member AS m ON pof.memid = m.MemberId WHERE pof.[RunDate] = ( SELECT MAX(i.[RunDate]) FROM INFORMATICS.dbo.ECMPOF_CHILD_MHSMISUD AS i WITH (NOLOCK) ) AND m.ISECM = 1 AND m.EnrollmentStatus = 'Assigned'
UNION ALL
SELECT pof.memid,pof.[TargetPopulation] FROM INFORMATICS.dbo.ECMPOF_CHILD_INCARCERATION AS pof INNER JOIN ProviderPortal.ECM.Member AS m ON pof.memid = m.MemberId WHERE pof.[RunDate] = ( SELECT MAX(i.[RunDate]) FROM INFORMATICS.dbo.ECMPOF_CHILD_INCARCERATION AS i WITH (NOLOCK) ) AND m.ISECM = 1 AND m.EnrollmentStatus = 'Assigned'
UNION ALL
SELECT pof.memid,pof.[TargetPopulation] FROM INFORMATICS.dbo.ECMPOF_CHILD_CCS AS pof INNER JOIN ProviderPortal.ECM.Member AS m ON pof.memid = m.MemberId WHERE pof.[RunDate] = ( SELECT MAX(i.[RunDate]) FROM INFORMATICS.dbo.ECMPOF_CHILD_CCS AS i WITH (NOLOCK) ) AND m.ISECM = 1 AND m.EnrollmentStatus = 'Assigned'
UNION ALL
SELECT pof.memid,pof.[TargetPopulation] FROM INFORMATICS.dbo.ECMPOF_CHILD_WELFARE AS pof INNER JOIN ProviderPortal.ECM.Member AS m ON pof.memid = m.MemberId WHERE pof.[RunDate] = ( SELECT MAX(i.[RunDate]) FROM INFORMATICS.dbo.ECMPOF_CHILD_WELFARE AS i WITH (NOLOCK) ) AND m.ISECM = 1 AND m.EnrollmentStatus = 'Assigned'
UNION ALL
SELECT pof.memid,pof.[TargetPopulation] FROM INFORMATICS.dbo.ECMPOF_ADULT_BIRTH_EQUITY AS pof INNER JOIN ProviderPortal.ECM.Member AS m ON pof.memid = m.MemberId WHERE pof.[RunDate] = ( SELECT MAX(i.[RunDate]) FROM INFORMATICS.dbo.ECMPOF_ADULT_BIRTH_EQUITY AS i WITH (NOLOCK) ) AND m.ISECM = 1 AND m.EnrollmentStatus = 'Assigned'
UNION ALL
SELECT pof.memid,pof.[TargetPopulation] FROM INFORMATICS.dbo.ECMPOF_ADULT_IPSNFED_HIGHUTIL AS pof INNER JOIN ProviderPortal.ECM.Member AS m ON pof.memid = m.MemberId WHERE pof.[RunDate] = ( SELECT MAX(i.[RunDate]) FROM INFORMATICS.dbo.ECMPOF_ADULT_IPSNFED_HIGHUTIL AS i WITH (NOLOCK) ) AND m.ISECM = 1 AND m.EnrollmentStatus = 'Assigned'
UNION ALL
SELECT pof.memid,pof.[TargetPopulation] FROM INFORMATICS.dbo.ECMPOF_ADULT_MHSMISUD AS pof INNER JOIN ProviderPortal.ECM.Member AS m ON pof.memid = m.MemberId WHERE pof.[RunDate] = ( SELECT MAX(i.[RunDate]) FROM INFORMATICS.dbo.ECMPOF_ADULT_MHSMISUD AS i WITH (NOLOCK) ) AND m.ISECM = 1 AND m.EnrollmentStatus = 'Assigned'
UNION ALL
SELECT pof.memid,pof.[TargetPopulation] FROM INFORMATICS.dbo.ECMPOF_ADULT_INCARCERATION AS pof INNER JOIN ProviderPortal.ECM.Member AS m ON pof.memid = m.MemberId WHERE pof.[RunDate] = ( SELECT MAX(i.[RunDate]) FROM INFORMATICS.dbo.ECMPOF_ADULT_INCARCERATION AS i WITH (NOLOCK) ) AND m.ISECM = 1 AND m.EnrollmentStatus = 'Assigned'
UNION ALL
SELECT pof.memid,pof.[TargetPopulation] FROM INFORMATICS.dbo.ECMPOF_ADULT_INSTITUTIONALIZATION AS pof INNER JOIN ProviderPortal.ECM.Member AS m ON pof.memid = m.MemberId WHERE pof.[RunDate] = ( SELECT MAX(i.[RunDate]) FROM INFORMATICS.dbo.ECMPOF_ADULT_INSTITUTIONALIZATION AS i WITH (NOLOCK) ) AND m.ISECM = 1 AND m.EnrollmentStatus = 'Assigned'
UNION ALL
SELECT pof.memid,pof.[TargetPopulation] FROM INFORMATICS.dbo.ECMPOF_ADULT_NURSING_TRANSITION AS pof INNER JOIN ProviderPortal.ECM.Member AS m ON pof.memid = m.MemberId WHERE pof.[RunDate] = ( SELECT MAX(i.[RunDate]) FROM INFORMATICS.dbo.ECMPOF_ADULT_NURSING_TRANSITION AS i WITH (NOLOCK) ) AND m.ISECM = 1 AND m.EnrollmentStatus = 'Assigned'
UNION ALL
SELECT pof.memid,pof.[TargetPopulation] FROM INFORMATICS.dbo.ECMPOF_ADULTWITHFAMILY_HOMELESS AS pof INNER JOIN ProviderPortal.ECM.Member AS m ON pof.memid = m.MemberId WHERE pof.[RunDate] = ( SELECT MAX(i.[RunDate]) FROM INFORMATICS.dbo.ECMPOF_ADULTWITHFAMILY_HOMELESS AS i WITH (NOLOCK) ) AND m.ISECM = 1 AND m.EnrollmentStatus = 'Assigned'
UNION ALL
SELECT pof.memid,pof.[TargetPopulation] FROM INFORMATICS.dbo.ECMPOF_ADULTWITHOUTFAMILY_HOMELESS AS pof INNER JOIN ProviderPortal.ECM.Member AS m ON pof.memid = m.MemberId WHERE pof.[RunDate] = ( SELECT MAX(i.[RunDate]) FROM INFORMATICS.dbo.ECMPOF_ADULTWITHOUTFAMILY_HOMELESS AS i WITH (NOLOCK) ) AND m.ISECM = 1 AND m.EnrollmentStatus = 'Assigned'
) AS pof
GROUP BY memid,[TargetPopulation]

	-- ALGORITHM (CHATGPT) POF -- NOTE: NO CHATGPT_ECMPOF_CHILD_HOMELESS counterpart exists, that POF
	-- was split into WITHFAMILY / WITHOUTFAMILY under the algorithm update --
SELECT memid
,[TargetPopulation]
INTO #AlgorithmPOF_XREF#
FROM (
SELECT pof.memid,pof.[TargetPopulation] FROM INFORMATICS.dbo.CHATGPT_ECMPOF_CHILD_BIRTH_EQUITY AS pof INNER JOIN ProviderPortal.ECM.Member AS m ON pof.memid = m.MemberId WHERE pof.[RunDate] = ( SELECT MAX(i.[RunDate]) FROM INFORMATICS.dbo.CHATGPT_ECMPOF_CHILD_BIRTH_EQUITY AS i WITH (NOLOCK) ) AND m.ISECM = 1 AND m.EnrollmentStatus = 'Assigned'
UNION ALL
SELECT pof.memid,pof.[TargetPopulation] FROM INFORMATICS.dbo.CHATGPT_ECMPOF_CHILDWITHFAMILY_HOMELESS AS pof INNER JOIN ProviderPortal.ECM.Member AS m ON pof.memid = m.MemberId WHERE pof.[RunDate] = ( SELECT MAX(i.[RunDate]) FROM INFORMATICS.dbo.CHATGPT_ECMPOF_CHILDWITHFAMILY_HOMELESS AS i WITH (NOLOCK) ) AND m.ISECM = 1 AND m.EnrollmentStatus = 'Assigned'
UNION ALL
SELECT pof.memid,pof.[TargetPopulation] FROM INFORMATICS.dbo.CHATGPT_ECMPOF_CHILDWITHOUTFAMILY_HOMELESS AS pof INNER JOIN ProviderPortal.ECM.Member AS m ON pof.memid = m.MemberId WHERE pof.[RunDate] = ( SELECT MAX(i.[RunDate]) FROM INFORMATICS.dbo.CHATGPT_ECMPOF_CHILDWITHOUTFAMILY_HOMELESS AS i WITH (NOLOCK) ) AND m.ISECM = 1 AND m.EnrollmentStatus = 'Assigned'
UNION ALL
SELECT pof.memid,pof.[TargetPopulation] FROM INFORMATICS.dbo.CHATGPT_ECMPOF_CHILD_IPSNFED_HIGHUTIL AS pof INNER JOIN ProviderPortal.ECM.Member AS m ON pof.memid = m.MemberId WHERE pof.[RunDate] = ( SELECT MAX(i.[RunDate]) FROM INFORMATICS.dbo.CHATGPT_ECMPOF_CHILD_IPSNFED_HIGHUTIL AS i WITH (NOLOCK) ) AND m.ISECM = 1 AND m.EnrollmentStatus = 'Assigned'
UNION ALL
SELECT pof.memid,pof.[TargetPopulation] FROM INFORMATICS.dbo.CHATGPT_ECMPOF_CHILD_MHSMISUD AS pof INNER JOIN ProviderPortal.ECM.Member AS m ON pof.memid = m.MemberId WHERE pof.[RunDate] = ( SELECT MAX(i.[RunDate]) FROM INFORMATICS.dbo.CHATGPT_ECMPOF_CHILD_MHSMISUD AS i WITH (NOLOCK) ) AND m.ISECM = 1 AND m.EnrollmentStatus = 'Assigned'
UNION ALL
SELECT pof.memid,pof.[TargetPopulation] FROM INFORMATICS.dbo.CHATGPT_ECMPOF_CHILD_INCARCERATION AS pof INNER JOIN ProviderPortal.ECM.Member AS m ON pof.memid = m.MemberId WHERE pof.[RunDate] = ( SELECT MAX(i.[RunDate]) FROM INFORMATICS.dbo.CHATGPT_ECMPOF_CHILD_INCARCERATION AS i WITH (NOLOCK) ) AND m.ISECM = 1 AND m.EnrollmentStatus = 'Assigned'
UNION ALL
SELECT pof.memid,pof.[TargetPopulation] FROM INFORMATICS.dbo.CHATGPT_ECMPOF_CHILD_CCS AS pof INNER JOIN ProviderPortal.ECM.Member AS m ON pof.memid = m.MemberId WHERE pof.[RunDate] = ( SELECT MAX(i.[RunDate]) FROM INFORMATICS.dbo.CHATGPT_ECMPOF_CHILD_CCS AS i WITH (NOLOCK) ) AND m.ISECM = 1 AND m.EnrollmentStatus = 'Assigned'
UNION ALL
SELECT pof.memid,pof.[TargetPopulation] FROM INFORMATICS.dbo.CHATGPT_ECMPOF_CHILD_WELFARE AS pof INNER JOIN ProviderPortal.ECM.Member AS m ON pof.memid = m.MemberId WHERE pof.[RunDate] = ( SELECT MAX(i.[RunDate]) FROM INFORMATICS.dbo.CHATGPT_ECMPOF_CHILD_WELFARE AS i WITH (NOLOCK) ) AND m.ISECM = 1 AND m.EnrollmentStatus = 'Assigned'
UNION ALL
SELECT pof.memid,pof.[TargetPopulation] FROM INFORMATICS.dbo.CHATGPT_ECMPOF_ADULT_BIRTH_EQUITY AS pof INNER JOIN ProviderPortal.ECM.Member AS m ON pof.memid = m.MemberId WHERE pof.[RunDate] = ( SELECT MAX(i.[RunDate]) FROM INFORMATICS.dbo.CHATGPT_ECMPOF_ADULT_BIRTH_EQUITY AS i WITH (NOLOCK) ) AND m.ISECM = 1 AND m.EnrollmentStatus = 'Assigned'
UNION ALL
SELECT pof.memid,pof.[TargetPopulation] FROM INFORMATICS.dbo.CHATGPT_ECMPOF_ADULT_IPSNFED_HIGHUTIL AS pof INNER JOIN ProviderPortal.ECM.Member AS m ON pof.memid = m.MemberId WHERE pof.[RunDate] = ( SELECT MAX(i.[RunDate]) FROM INFORMATICS.dbo.CHATGPT_ECMPOF_ADULT_IPSNFED_HIGHUTIL AS i WITH (NOLOCK) ) AND m.ISECM = 1 AND m.EnrollmentStatus = 'Assigned'
UNION ALL
SELECT pof.memid,pof.[TargetPopulation] FROM INFORMATICS.dbo.CHATGPT_ECMPOF_ADULT_MHSMISUD AS pof INNER JOIN ProviderPortal.ECM.Member AS m ON pof.memid = m.MemberId WHERE pof.[RunDate] = ( SELECT MAX(i.[RunDate]) FROM INFORMATICS.dbo.CHATGPT_ECMPOF_ADULT_MHSMISUD AS i WITH (NOLOCK) ) AND m.ISECM = 1 AND m.EnrollmentStatus = 'Assigned'
UNION ALL
SELECT pof.memid,pof.[TargetPopulation] FROM INFORMATICS.dbo.CHATGPT_ECMPOF_ADULT_INCARCERATION AS pof INNER JOIN ProviderPortal.ECM.Member AS m ON pof.memid = m.MemberId WHERE pof.[RunDate] = ( SELECT MAX(i.[RunDate]) FROM INFORMATICS.dbo.CHATGPT_ECMPOF_ADULT_INCARCERATION AS i WITH (NOLOCK) ) AND m.ISECM = 1 AND m.EnrollmentStatus = 'Assigned'
UNION ALL
SELECT pof.memid,pof.[TargetPopulation] FROM INFORMATICS.dbo.CHATGPT_ECMPOF_ADULT_INSTITUTIONALIZATION AS pof INNER JOIN ProviderPortal.ECM.Member AS m ON pof.memid = m.MemberId WHERE pof.[RunDate] = ( SELECT MAX(i.[RunDate]) FROM INFORMATICS.dbo.CHATGPT_ECMPOF_ADULT_INSTITUTIONALIZATION AS i WITH (NOLOCK) ) AND m.ISECM = 1 AND m.EnrollmentStatus = 'Assigned'
UNION ALL
SELECT pof.memid,pof.[TargetPopulation] FROM INFORMATICS.dbo.CHATGPT_ECMPOF_ADULT_NURSING_TRANSITION AS pof INNER JOIN ProviderPortal.ECM.Member AS m ON pof.memid = m.MemberId WHERE pof.[RunDate] = ( SELECT MAX(i.[RunDate]) FROM INFORMATICS.dbo.CHATGPT_ECMPOF_ADULT_NURSING_TRANSITION AS i WITH (NOLOCK) ) AND m.ISECM = 1 AND m.EnrollmentStatus = 'Assigned'
UNION ALL
SELECT pof.memid,pof.[TargetPopulation] FROM INFORMATICS.dbo.CHATGPT_ECMPOF_ADULTWITHFAMILY_HOMELESS AS pof INNER JOIN ProviderPortal.ECM.Member AS m ON pof.memid = m.MemberId WHERE pof.[RunDate] = ( SELECT MAX(i.[RunDate]) FROM INFORMATICS.dbo.CHATGPT_ECMPOF_ADULTWITHFAMILY_HOMELESS AS i WITH (NOLOCK) ) AND m.ISECM = 1 AND m.EnrollmentStatus = 'Assigned'
UNION ALL
SELECT pof.memid,pof.[TargetPopulation] FROM INFORMATICS.dbo.CHATGPT_ECMPOF_ADULTWITHOUTFAMILY_HOMELESS AS pof INNER JOIN ProviderPortal.ECM.Member AS m ON pof.memid = m.MemberId WHERE pof.[RunDate] = ( SELECT MAX(i.[RunDate]) FROM INFORMATICS.dbo.CHATGPT_ECMPOF_ADULTWITHOUTFAMILY_HOMELESS AS i WITH (NOLOCK) ) AND m.ISECM = 1 AND m.EnrollmentStatus = 'Assigned'
) AS pof
GROUP BY memid,[TargetPopulation]

	-- CHECK FOR DUP(S) - SHOULD RETURN 0 ROWS EACH:
SELECT 'ExistingPOF_XREF DUP CHECK' AS [Check],memid,[TargetPopulation],COUNT(1) AS [Cnt] FROM #ExistingPOF_XREF# GROUP BY memid,[TargetPopulation] HAVING COUNT(1) > 1
SELECT 'AlgorithmPOF_XREF DUP CHECK' AS [Check],memid,[TargetPopulation],COUNT(1) AS [Cnt] FROM #AlgorithmPOF_XREF# GROUP BY memid,[TargetPopulation] HAVING COUNT(1) > 1

-- =====================================================================
	-- SECTION 3: UNIQUE MEMBER COUNT BY POF BY ECM PROVIDER --
-- =====================================================================
SELECT ' ' AS 'EXISTING POF - ECM Enrolled Unique Member Count BY POF BY ECM Provider'
,ISNULL(CAST(pa.ProviderId AS varchar(20)),'UNASSIGNED') AS [ProviderId]
,pa.ProviderNPI AS [NPI]
,ISNULL(pa.ProviderName,'UNASSIGNED') AS [ECM Provider]
,x.[TargetPopulation]
,COUNT(DISTINCT(x.memid)) AS [Unique Member Count]
FROM #ExistingPOF_XREF# AS x
	LEFT JOIN #ProviderAssignment# AS pa ON pa.memid = x.memid
GROUP BY ISNULL(CAST(pa.ProviderId AS varchar(20)),'UNASSIGNED')
,pa.ProviderNPI
,ISNULL(pa.ProviderName,'UNASSIGNED')
,x.[TargetPopulation]
ORDER BY 3,4

SELECT ' ' AS 'ALGORITHM POF - ECM Enrolled Unique Member Count BY POF BY ECM Provider'
,ISNULL(CAST(pa.ProviderId AS varchar(20)),'UNASSIGNED') AS [ProviderId]
,pa.ProviderNPI AS [NPI]
,ISNULL(pa.ProviderName,'UNASSIGNED') AS [ECM Provider]
,x.[TargetPopulation]
,COUNT(DISTINCT(x.memid)) AS [Unique Member Count]
FROM #AlgorithmPOF_XREF# AS x
	LEFT JOIN #ProviderAssignment# AS pa ON pa.memid = x.memid
GROUP BY ISNULL(CAST(pa.ProviderId AS varchar(20)),'UNASSIGNED')
,pa.ProviderNPI
,ISNULL(pa.ProviderName,'UNASSIGNED')
,x.[TargetPopulation]
ORDER BY 3,4

-- =====================================================================
	-- SECTION 4: NET CHANGE BY ECM PROVIDER BY POF -- EXISTING vs ALGORITHM --
	-- Directly answers Sir Allan / Joseph's Teams question 20260714: "For Providers Joseph wants
	-- to know the net change IN enrollment for each Provider with the changes" --
-- =====================================================================
SELECT ' ' AS 'NET CHANGE BY ECM Provider BY POF'
,ISNULL(e.[ProviderId],a.[ProviderId]) AS [ProviderId]
,ISNULL(e.[ECM Provider],a.[ECM Provider]) AS [ECM Provider]
,ISNULL(e.[TargetPopulation],a.[TargetPopulation]) AS [TargetPopulation]
,ISNULL(e.[Existing Count],0) AS [Existing Count]
,ISNULL(a.[Algorithm Count],0) AS [Algorithm Count]
,ISNULL(a.[Algorithm Count],0)-ISNULL(e.[Existing Count],0) AS [Net Change]
FROM
(
SELECT ISNULL(CAST(pa.ProviderId AS varchar(20)),'UNASSIGNED') AS [ProviderId]
,ISNULL(pa.ProviderName,'UNASSIGNED') AS [ECM Provider]
,x.[TargetPopulation]
,COUNT(DISTINCT(x.memid)) AS [Existing Count]
FROM #ExistingPOF_XREF# AS x
	LEFT JOIN #ProviderAssignment# AS pa ON pa.memid = x.memid
GROUP BY ISNULL(CAST(pa.ProviderId AS varchar(20)),'UNASSIGNED')
,ISNULL(pa.ProviderName,'UNASSIGNED')
,x.[TargetPopulation]
) AS e
	FULL JOIN
(
SELECT ISNULL(CAST(pa.ProviderId AS varchar(20)),'UNASSIGNED') AS [ProviderId]
,ISNULL(pa.ProviderName,'UNASSIGNED') AS [ECM Provider]
,x.[TargetPopulation]
,COUNT(DISTINCT(x.memid)) AS [Algorithm Count]
FROM #AlgorithmPOF_XREF# AS x
	LEFT JOIN #ProviderAssignment# AS pa ON pa.memid = x.memid
GROUP BY ISNULL(CAST(pa.ProviderId AS varchar(20)),'UNASSIGNED')
,ISNULL(pa.ProviderName,'UNASSIGNED')
,x.[TargetPopulation]
) AS a
ON a.[ProviderId] = e.[ProviderId]
	AND a.[TargetPopulation] = e.[TargetPopulation]
ORDER BY 1,3

-- =====================================================================
	-- OPEN ITEMS -- 20260714 --
	-- 1) 'Currently assigned' window on #ProviderAssignment# (EffDate <= today, TermDate >= today)
	--    AND the ROW_NUMBER dedup are additions beyond the CODE Malik supplied, which used a raw
	--    LEFT JOIN with no window AND no dedup. Kept AS a value-ADD given the duplicate-row finding
	--    from Malik's own exploration, NOT a silent deviation. Remove IF undesired
	-- 2) The Eligible-vs-Enrolled split from the prior 20260714 draft has been collapsed to ONE
	--    qualifying population (m.ISECM = 1 AND m.EnrollmentStatus = 'Assigned'), matching the
	--    supplied CODE. IF JAG still wants a separate ECM-Eligible-but-not-yet-Assigned count, that
	--    would need a different source than ProviderPortal.ECM.Member (this table only carries
	--    Assigned-population attributes per the sample row reviewed 20260714)
-- =====================================================================
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         