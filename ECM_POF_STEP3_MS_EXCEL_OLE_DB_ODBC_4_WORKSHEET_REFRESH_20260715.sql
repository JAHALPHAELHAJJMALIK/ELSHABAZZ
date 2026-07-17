-- =====================================================================
	--  MODIFICATION(S) | CHANGE.LOG:
-- =====================================================================
-- C001: DUB C 2.0 pass on DUB C 2.0's 4 worksheet Excel OLE DB ODBC refresh script, 20260715. Added (NOLOCK) to uvw_BASELINE_MEMBERSHIP, STEP2_DISENROLLMENT_CANDIDATES, and STEP2_RETAINED_FEWER_POFS references, no logic changes

-- =====================================================================
	-- QA | MEETING EXPECTATION(S)?: 
-- =====================================================================
DECLARE @ineligmemeber AS nvarchar(255) = '2172282' -- '743166' -- [HealthPlanID]: 1978343927

SELECT * FROM ProviderPortal.ECM.MembersInformation (NOLOCK) AS mi WHERE 1=1 AND MemberID = @ineligmemeber -- 1079481
SELECT * FROM ProviderPortal.ECM.Member (NOLOCK) AS m WHERE 1=1 AND MemberID = @ineligmemeber -- 1079481
SELECT * FROM ProviderPortal.ecm.MemberTargetPopulation (NOLOCK) AS mtp WHERE 1=1 AND MemberID = @ineligmemeber -- 1079481
SELECT * FROM [ProviderPortal].ecm.[StratificationTargetPopulation] AS sta WHERE 1=1 AND MemberID = @ineligmemeber -- '1079481'
SELECT * FROM [ProviderPortal].[ECM].[MemberProviderAssigment] (NOLOCK) AS mpa WHERE 1=1 AND MemberID = @ineligmemeber -- 1079481

SELECT mpa.MemberId
,COUNT(*) AS [Concurrent Active Assignments]
FROM [ProviderPortal].[ECM].[MemberProviderAssigment] (NOLOCK) AS mpa
WHERE 1=1
	AND ISNULL(mpa.TermDate,'12/31/2078') >= GETDATE()
GROUP BY mpa.MemberId
HAVING COUNT(*) > 1

SELECT COUNT(DISTINCT ee.memid) AS [BASELINE Members With No Match In uvw_BASELINE_MEMBERSHIP]
FROM INFORMATICS.dbo.BASELINE_QNXT_ProviderPortal_ECM_ENROLLED (NOLOCK) AS ee
	LEFT JOIN INFORMATICS.dbo.uvw_BASELINE_MEMBERSHIP (NOLOCK) AS bm ON ee.memid = bm.memid
WHERE 1=1
	AND ee.ROWNUMBER_Enrolled = 1
	AND bm.memid IS NULL
	
-- =====================================================================
	-- ALIGNMENT CHECK AGAINST MS KATHRYN'S 'ECM POF' TEAMS NOTES, TODAY 5:40 PM --
-- =====================================================================
/* Kathryn's STEPS for tonight:
1. Find unique members												-> WORKSHEET 2, BASELINE ECM Enrolled MEMBERSHIP
2. Walter to run members through new POF algorithm
	1. Members no longer eligible										-> WORKSHEET 3, FULL DISENROLLMENT CANDIDATES
	2. Members no longer eligible for 1+ POFs, still 1+ active		-> WORKSHEET 4, PARTIAL DISENROLLMENT CANDIDATES
3. Kathryn review report to check
	1. Member Enrollment status										-> NEEDS CONFIRMATION, see NOTE below
	2. Current Provider Assignment										-> mpa JOIN on all 3 detail worksheets, currently assigned window
4. Once reviewed, Paco to run Utilization lists						-> OUT OF SCOPE for this file, downstream of Paco
5. Tatsani is reviewing utilization list								-> OUT OF SCOPE for this file, downstream of Tatsani
6. Once reviewed, Allan to send to Joseph by 8AM						-> OUT OF SCOPE for this file, delivery step

WORKSHEET 1, SANITY SUMMARY, is not one of Kathryn's numbered steps directly, it is the QA control tying WORKSHEET 2, 3, and 4 counts back to JAG's ~4000 and DUB C 2.0's ~1000 expectation before Kathryn's step 3 review begins.

NOTE, please confirm: uvw_BASELINE_MEMBERSHIP has not been reviewed column by column against Kathryn's step 3.1, Member Enrollment status. Confirm this view actually surfaces a current enrollment status field, not just HealthPlanId and Member Name, before Kathryn's review, since that is her explicit first checkpoint. Cannot verify this independently, no direct database access from this session

NOTE, carried over unresolved from the 20260714 session close: the mpa JOIN currently assigned window, ISNULL(mpa.TermDate,'12/31/2078') >= GETDATE(), has no EffDate <= today check and no ROW_NUMBER dedup. If any member has 2 simultaneously non terminated MemberProviderAssigment rows, that member will fan out to 2 rows in ALL FOUR worksheets below, not just this one script. Same open item, now propagated into the Excel deliverable, worth a look before this goes to Kathryn */

-- =====================================================================
	-- WORKSHEET 1 -- SANITY SUMMARY -- COMPARE AGAINST JAG'S ~4000 EXPECTATION AND DUB C 2.0'S ~1000 ESTIMATE --
-- =====================================================================
SELECT ( SELECT COUNT(DISTINCT memid) FROM INFORMATICS.dbo.BASELINE_QNXT_ProviderPortal_ECM_ENROLLED (NOLOCK) ) AS [BASELINE ECM Enrolled]
,( SELECT COUNT(DISTINCT memid) FROM INFORMATICS.dbo.STEP2_DISENROLLMENT_CANDIDATES (NOLOCK) ) AS [DISENROLLMENT Candidates - 0 Algorithm POF]
,( SELECT COUNT(DISTINCT memid) FROM INFORMATICS.dbo.STEP2_RETAINED_FEWER_POFS (NOLOCK) ) AS [RETAINED - Lost Some POFs Not All]

-- =====================================================================
	-- WORKSHEET 2 -- BASELINE ECM Enrolled MEMBERSHIP --
-- =====================================================================
SELECT ' ' AS 'BASELINE ECM Enrolled MEMBERSHIP'
,bm.HealthPlanId
,bm.[Member Name]
,prov.NPI
,prov.fullname AS [ECM Provider]
,mpa.*
,ee.*
FROM INFORMATICS.dbo.BASELINE_QNXT_ProviderPortal_ECM_ENROLLED AS ee
		LEFT JOIN INFORMATICS.dbo.uvw_BASELINE_MEMBERSHIP AS bm ON ee.memid = bm.memid
		LEFT JOIN [ProviderPortal].[ECM].[MemberProviderAssigment] (NOLOCK) AS mpa ON ee.memid = mpa.MemberId
			AND ISNULL(mpa.TermDate,'12/31/2078') >= GETDATE()
		LEFT JOIN HMOPROD_PLANDATA.dbo.[provider] (NOLOCK) AS prov ON mpa.ProviderID = prov.provid
WHERE 1=1
	AND ROWNUMBER_Enrolled = 1

-- =====================================================================
	-- WORKSHEET 3 -- FULL DISENROLLMENT CANDIDATES -- Kathryn item 2.1, Members no longer eligible --
-- =====================================================================
SELECT ' ' AS 'FULL DISENROLLMENT CANDIDATES: '
,bm.HealthPlanId
,bm.[Member Name]
,prov.NPI
,prov.fullname AS [ECM Provider]		
,mpa.*
,dc.*
FROM INFORMATICS.dbo.STEP2_DISENROLLMENT_CANDIDATES AS dc
		LEFT JOIN INFORMATICS.dbo.uvw_BASELINE_MEMBERSHIP AS bm ON dc.memid = bm.memid
		LEFT JOIN [ProviderPortal].[ECM].[MemberProviderAssigment] (NOLOCK) AS mpa ON dc.memid = mpa.MemberId
			AND ISNULL(mpa.TermDate,'12/31/2078') >= GETDATE()
		LEFT JOIN HMOPROD_PLANDATA.dbo.[provider] (NOLOCK) AS prov ON mpa.ProviderID = prov.provid

-- =====================================================================
	-- WORKSHEET 4 -- PARTIAL DISENROLLMENT CANDIDATES -- Kathryn item 2.2, no longer eligible for 1+ POFs, still 1+ active --
-- =====================================================================
SELECT ' ' AS 'PARTIAL DISENROLLMENT CANDIDATES: '
,bm.HealthPlanId
,bm.[Member Name]
,prov.NPI
,prov.fullname AS [ECM Provider]		
,mpa.*
,partiald.*
FROM INFORMATICS.dbo.STEP2_RETAINED_FEWER_POFS AS partiald
		LEFT JOIN INFORMATICS.dbo.uvw_BASELINE_MEMBERSHIP AS bm ON partiald.memid = bm.memid
		LEFT JOIN [ProviderPortal].[ECM].[MemberProviderAssigment] (NOLOCK) AS mpa ON partiald.memid = mpa.MemberId
			AND ISNULL(mpa.TermDate,'12/31/2078') >= GETDATE()
		LEFT JOIN HMOPROD_PLANDATA.dbo.[provider] (NOLOCK) AS prov ON mpa.ProviderID = prov.provid
