-- =====================================================================
	-- COMMENT(S) / CHANGE.LOG: --
-- =====================================================================
/* Tab 6: Community Supports Requests AND Denials */

-- C001: START WITH() ECMELIG PER WEEKLY ECM TEAMS MEETING + MS CLAUDIA GUIDANCE ON 20240418

-- C002: [TargetPopulation] ⏎ In the 20240418 script, the POF assessment is updated to use the [ProviderPortal].ecm.[StratificationTargetPopulation] table instead, AS per the guidance FROM the ECM weekly teams meeting ON 20240418.

-- C003: IN ('1679158125','1790002806','1760477467','1689066748','1659415131','1629749577','1619393584','1073177739','1538667969','1437821022','1427696616','1376797035','1275285868','1205254950','1447281936','1093834020','1922642909','1649809526','1154978021','1891408043','1376229872','1801007778','1679357685','1922790906') -- C003: UPDATE: CS National Provider Identifier (NPI) Number, if applicable per "MOC Excel File CS Provider Capacity Template 2024 Mapping 20240503.xlsx"

-- C004: UPDATE OF DATE [RANGE] DRIVER using CAST(CONVERT(datetime,(r.UtcReceiptDate at time zone 'UTC') at time zone 'Pacific Standard Time') AS date) per WEEKLY ECM / CS Meeting discussion AND "UPDATED ECM-CS Quarterly Reports Narrative 4.24.24.docx" ...Coordinated Universal Time or UTC is the primary time standard globally used to regulate clocks AND time. It establishes a reference for the current time, forming the basis for civil time AND time zones. UTC facilitates international communication, navigation, scientific research, AND commerce. ... 

-- C005: Update to Community Support Offered logic: 'Transitional Rent' per Ms Kathryn eMail on 20251216 - SUBJECT:Question: Transitional Rent codes in CommunitySupportsAuthStatus Report ~ LEVERAGE: http://devops01:8080/IS/Informatics/_workitems/edit/23626/

		/* [Community Support Service Name]	[Code]	[Modifier]	[Units for Auth]	[Auth End]
		Transitional Rent											H0040	U2					6								6 months 
		Transitional Rent											H0040	U1					1								6 months 
		Transitional Rent											H0043	U2					168							6 months 
		Transitional Rent											H0044	U6					6								6 months  */

-- M001: 20260605 - BUG FIX: Retired stale 'TBD' placeholder from the U6 IN list in both #CSAuths# css WHERE filter (line 78) and #CSDeniedRequests# WHERE filter (line 173). 'TBD' is not a valid HCPCS code and will never match a real authservice record. Removed from both locations.

-- M002: 20260605 - DHCS HCPCS Coding Guidance v1.3 January 2026 ALIGNMENT: Added S9452 to the U6 IN list (S9452+U6 Nutrition Education Group) and a new S9452+U5 OR block (Nutrition Education Individual) in both #CSAuths# css WHERE filter and #CSDeniedRequests# WHERE filter.

-- M003: 20260605 - DHCS HCPCS Coding Guidance v1.3 January 2026 ALIGNMENT: Added five new S9977 modifier OR blocks (U4 Produce Rx Box, U5 Produce Rx Retail, U7 Medically Supportive Groceries, U8 Food Pharmacy, U9 Healthy Food Vouchers) in both #CSAuths# css WHERE filter and #CSDeniedRequests# WHERE filter. Prior coverage was S9977+U6 only via the U6 IN list.

-- M004: 20260605 - DHCS HCPCS Coding Guidance v1.3 January 2026 ALIGNMENT: Added H0044+U5 (Community or Home Transition Services - Non-Recurring Set-Up Expenses) to the T2038/H2022 U5 OR block in both #CSAuths# css WHERE filter and #CSDeniedRequests# WHERE filter. Flagged in DHCS guidance as 'Updated January 2026'.

-- M005: 20260605 - DHCS HCPCS Coding Guidance v1.3 January 2026 ALIGNMENT: Added T1016+U8 housing outreach initiation OR block to both #CSAuths# css WHERE filter and #CSDeniedRequests# WHERE filter. DHCS mandates reporting of housing outreach encounter codes (both successful and unsuccessful) for Housing Transition/Navigation, Housing Deposits, and Housing Tenancy and Sustaining Services. PACES submission mandatory; MCP reimbursement optional per DHCS pg 18-20.

-- =====================================================================
	-- DECLARE @PARAMETER(S) / @FILTER(S) --
-- =====================================================================
DECLARE @leadlag AS decimal(9,0)
DECLARE @leadlagmonths AS int
DECLARE @ClockStart AS datetime
DECLARE @ClockStop AS datetime
DECLARE @IPPdt AS datetime
-- DECLARE @gapallowance AS int

SET @leadlag = -4 -- +- LEAD() LAG() IN ...
SET @leadlagmonths = 3 -- +- LEAD() LAG() IN MONTH(S)
SET @ClockStart = DATEADD(MONTH,@leadlag,DATEADD(DAY,1,EOMONTH(GETDATE(),-1))) -- AS [1st of ... MONTH]
SET @ClockStop = DATEADD(day,-1,DATEADD(MONTH,@leadlagmonths,@ClockStart))
SET @IPPdt = TRY_CONVERT(date,GETDATE())
-- SET @gapallowance = 14

		SELECT 'BETWEEN '+CAST(CAST(@ClockStart AS date) AS varchar (25))+' AND '+CAST(CAST(@ClockStop AS date) AS varchar (25)) AS [RANGE NOTE(s)]
		,TRY_CONVERT(varchar(4),DATEPART(yyyy,@ClockStart))+' Q'+TRY_CONVERT(varchar(2),DATEPART(q,@ClockStart)) AS [Reporting Period]







--------------------------------------------------------------------------------------------------------------------
	-- Error Trapping: Check If Permanent Table(s) Already Exist(s) AND Drop If Applicable --
--------------------------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS INFORMATICS.dbo.ECMCSQTRLY_TAB6;
DROP TABLE IF EXISTS INFORMATICS .dbo.ECM_Q_TAB6_CSDeniedRequests_DETAIL;

if object_id ('tempdb.dbo.#CSDeniedRequests#') is not null drop table #CSDeniedRequests#
if object_id ('tempdb.dbo.#CSAuths#') is not null drop table #CSAuths#

SELECT DISTINCT 'Community Health Group Partnership Plan' AS 'Plan Name',
'29' AS 'Plan Code',
'San Diego' AS 'COUNTY',
TRY_CONVERT(varchar(4),DATEPART(yyyy,@ClockStart))+' Q'+TRY_CONVERT(varchar(2),DATEPART(q,@ClockStart)) AS [Reporting Period], --'2022 Q2' AS 'Reporting Period', '2023 Q3' AS 'Reporting Period',
r.memid
,r.referto
,r.authorizationid
--COUNT (DISTINCT (r.memid)) AS 'Number of Members with External Community Supports Request'
INTO #CSAuths#
FROM HMOPROD_PlanData.dbo.member AS m
	INNER JOIN HMOPROD_PlanData.dbo.referral AS r ON r.memid = m.memid
	INNER JOIN HMOPROD_PLANDATA.dbo.authservice AS asr ON asr.referralid = r.referralid
	INNER JOIN HMOPROD_PLANDATA.dbo.entity AS e ON m.entityid = e.entid
		LEFT JOIN HMOPROD_PlanData.dbo.svccode svc ON svc.codeid = asr.codeid
WHERE 1=1 
	AND r.servicecode = 'css'
	AND r.status IN ('approved','denied')
	AND r.authstatus IN ('approved','denied')
	AND asr.status IN ('approved','denied')
	AND CAST(CONVERT(datetime,(r.UtcReceiptDate at time zone 'UTC') at time zone 'Pacific Standard Time') AS date) BETWEEN @ClockStart AND @ClockStop -- C004: UPDATE OF DATE [RANGE] DRIVER using CAST(CONVERT(datetime,(r.UtcReceiptDate at time zone 'UTC') at time zone 'Pacific Standard Time') AS date) per WEEKLY ECM / CS Meeting discussion AND "UPDATED ECM-CS Quarterly Reports Narrative 4.24.24.docx" ...Coordinated Universal Time or UTC is the primary time standard globally used to regulate clocks AND time. It establishes a reference for the current time, forming the basis for civil time AND time zones. UTC facilitates international communication, navigation, scientific research, AND commerce. ... 
	AND 
	( -- INITIATE ...
	(asr.codeid IN ('H0043', 'H2016','T2040', 'T2050', 'T2051','T2041','T2033', -- M001: 'TBD' placeholder retired ~ not a valid HCPCS code
	'H0045','S5151','S9125','T2012','T2014','T2018','T2020','H2014','H2038',
	'H2024','H2026','S5130','T1019','S5170','S5165','S9470','S9977',
	'H0014','S9452') -- M002: S9452 added (DHCS v1.3 Jan 2026 Nutrition Education codes)
	AND (modcode IN ('U6') OR modcode2 IN ('U6') OR modcode3 IN ('U6')
		OR modcode4 IN ('U6') OR modcode5 IN ('U6')))

		OR (asr.codeid IN ('H0044') 
	AND (modcode IN ('U2') OR modcode2 IN ('U2') OR modcode3 IN ('U2')
		OR modcode4 IN ('U2') OR modcode5 IN ('U2')))

		OR (asr.codeid IN ('H0044','H0043') 
	AND (modcode IN ('U3') OR modcode2 IN ('U3') OR modcode3 IN ('U3')
		OR modcode4 IN ('U3') OR modcode5 IN ('U3')))

		OR (asr.codeid IN ('T2038') 
	AND (modcode IN ('U4') OR modcode2 IN ('U4') OR modcode3 IN ('U4')
		OR modcode4 IN ('U4') OR modcode5 IN ('U4')))

		OR (asr.codeid IN ('H2022') 
	AND (modcode IN ('U5') OR modcode2 IN ('U5') OR modcode3 IN ('U5')
		OR modcode4 IN ('U5') OR modcode5 IN ('U5')))

		OR (asr.codeid IN ('T2038','H0044') -- M004: H0044+U5 added (DHCS v1.3 Jan 2026 Community or Home Transition Non-Recurring Set-Up Expenses)
	AND (modcode IN ('U5') OR modcode2 IN ('U5') OR modcode3 IN ('U5')
		OR modcode4 IN ('U5') OR modcode5 IN ('U5')))

		OR (asr.codeid IN ('S5165') 
	AND (modcode IN ('U5') OR modcode2 IN ('U5') OR modcode3 IN ('U5')
		OR modcode4 IN ('U5') OR modcode5 IN ('U5')))

		OR (asr.codeid IN ('S9452') -- M002: Nutrition Education Individual (U5) modifier leg
	AND (modcode IN ('U5') OR modcode2 IN ('U5') OR modcode3 IN ('U5')
		OR modcode4 IN ('U5') OR modcode5 IN ('U5')))

		OR (asr.codeid IN ('S9977') -- M003: Produce Rx Box (U4), Produce Rx Retail (U5), Medically Supportive Groceries (U7), Food Pharmacy (U8), Healthy Food Vouchers (U9)
	AND (modcode IN ('U4','U5','U7','U8','U9') OR modcode2 IN ('U4','U5','U7','U8','U9') OR modcode3 IN ('U4','U5','U7','U8','U9')
		OR modcode4 IN ('U4','U5','U7','U8','U9') OR modcode5 IN ('U4','U5','U7','U8','U9')))

		OR (asr.codeid IN ('T1016') -- M005: Housing outreach initiation mandatory PACES encounter codes (DHCS v1.3 Jan 2026)
	AND (modcode IN ('U8') OR modcode2 IN ('U8') OR modcode3 IN ('U8')
		OR modcode4 IN ('U8') OR modcode5 IN ('U8')))

	OR (SUBSTRING(UPPER(LTRIM(RTRIM(ISNULL(asr.codeid,'')))),1,5) IN ('H0040') -- C005: Update to Community Support Offered logic: 'Transitional Rent' per Ms Kathryn eMail on 20251216 - SUBJECT:Question: Transitional Rent codes in CommunitySupportsAuthStatus Report ~ LEVERAGE: http://devops01:8080/IS/Informatics/_workitems/edit/23626/
		AND (modcode IN ('U1') OR modcode2 IN ('U1') OR modcode3 IN ('U1')OR modcode4 IN ('U1') OR modcode5 IN ('U1')))
		
	OR (SUBSTRING(UPPER(LTRIM(RTRIM(ISNULL(asr.codeid,'')))),1,5) IN ('H0040','H0043') -- C005: Update to Community Support Offered logic: 'Transitional Rent' per Ms Kathryn eMail on 20251216 - SUBJECT:Question: Transitional Rent codes in CommunitySupportsAuthStatus Report ~ LEVERAGE: http://devops01:8080/IS/Informatics/_workitems/edit/23626/
		AND (modcode IN ('U2') OR modcode2 IN ('U2') OR modcode3 IN ('U2')OR modcode4 IN ('U2') OR modcode5 IN ('U2')))
		
	OR (SUBSTRING(UPPER(LTRIM(RTRIM(ISNULL(asr.codeid,'')))),1,5) IN ('H0044') -- C005: Update to Community Support Offered logic: 'Transitional Rent' per Ms Kathryn eMail on 20251216 - SUBJECT:Question: Transitional Rent codes in CommunitySupportsAuthStatus Report ~ LEVERAGE: http://devops01:8080/IS/Informatics/_workitems/edit/23626/
		AND (modcode IN ('U6') OR modcode2 IN ('U6') OR modcode3 IN ('U6') OR modcode4 IN ('U6') OR modcode5 IN ('U6')))		
		) -- CONCLUDE ...
	AND r.termdate >= r.effdate -- MUST BE TRUE ... NON-CROSSFOOTED RECORDS ARE ACTIVE ...		

UNION 
SELECT DISTINCT 'Community Health Group Partnership Plan' AS 'Plan Name',
'29' AS 'Plan Code',
'San Diego' AS 'COUNTY',
TRY_CONVERT(varchar(4),DATEPART(yyyy,@ClockStart))+' Q'+TRY_CONVERT(varchar(2),DATEPART(q,@ClockStart)) AS [Reporting Period], --'2022 Q2' AS 'Reporting Period', '2023 Q3' AS 'Reporting Period',
r.memid
,r.referto
,r.authorizationid
--COUNT (DISTINCT (r.memid)) AS 'Number of Members with External Community Supports Request'
FROM HMOPROD_PlanData.dbo.member AS m
	INNER JOIN HMOPROD_PlanData.dbo.referral AS r ON r.memid = m.memid
	INNER JOIN HMOPROD_PLANDATA.dbo.authservice AS asr ON asr.referralid = r.referralid
	INNER JOIN HMOPROD_PLANDATA.dbo.entity AS e ON m.entityid = e.entid
		LEFT JOIN HMOPROD_PlanData.dbo.svccode svc ON svc.codeid = asr.codeid
WHERE 1=1 
	AND r.servicecode = 'RCU01'
	AND r.status IN ('approved','denied')
	AND r.authstatus IN ('approved','denied')
	AND asr.status IN ('approved','denied')
	AND CAST(CONVERT(datetime,(r.UtcReceiptDate at time zone 'UTC') at time zone 'Pacific Standard Time') AS date) BETWEEN @ClockStart AND @ClockStop -- C004: UPDATE OF DATE [RANGE] DRIVER using CAST(CONVERT(datetime,(r.UtcReceiptDate at time zone 'UTC') at time zone 'Pacific Standard Time') AS date) per WEEKLY ECM / CS Meeting discussion AND "UPDATED ECM-CS Quarterly Reports Narrative 4.24.24.docx" ...Coordinated Universal Time or UTC is the primary time standard globally used to regulate clocks AND time. It establishes a reference for the current time, forming the basis for civil time AND time zones. UTC facilitates international communication, navigation, scientific research, AND commerce. ... 
	AND asr.codeid = 'T2033' 
	AND (modcode IN ('U6') 
		OR modcode2 IN ('U6') 
		OR modcode3 IN ('U6')
		OR modcode4 IN ('U6') 
		OR modcode5 IN ('U6')) 
	AND r.termdate >= r.effdate -- MUST BE TRUE ... NON-CROSSFOOTED RECORDS ARE ACTIVE ...		







SELECT DISTINCT r.memid
,r.referto
,r.authorizationid
INTO #CSDeniedRequests#
FROM HMOPROD_PlanData.dbo.member AS m
	INNER JOIN HMOPROD_PlanData.dbo.referral AS r ON r.memid = m.memid
	INNER JOIN HMOPROD_PLANDATA.dbo.authservice AS asr ON asr.referralid = r.referralid
	INNER JOIN HMOPROD_PLANDATA.dbo.entity AS e ON m.entityid = e.entid
		LEFT JOIN HMOPROD_PlanData.dbo.svccode svc ON svc.codeid = asr.codeid
WHERE 1=1 
	AND r.servicecode = 'css'
	AND r.status IN ('denied')
	AND r.authstatus IN ('denied')
	AND asr.status IN ('denied')
	-- AND cast(r.referraldate AS date) between '7/1/2023' AND '9/30/2023' --'4/1/2022' AND '6/30/2022'
	-- AND TRY_CONVERT(date,r.referraldate) BETWEEN @ClockStart AND @ClockStop
	AND CAST(CONVERT(datetime,(r.UtcReceiptDate at time zone 'UTC') at time zone 'Pacific Standard Time') AS date) BETWEEN @ClockStart AND @ClockStop -- C004: UPDATE OF DATE [RANGE] DRIVER using CAST(CONVERT(datetime,(r.UtcReceiptDate at time zone 'UTC') at time zone 'Pacific Standard Time') AS date) per WEEKLY ECM / CS Meeting discussion AND "UPDATED ECM-CS Quarterly Reports Narrative 4.24.24.docx" ...Coordinated Universal Time or UTC is the primary time standard globally used to regulate clocks AND time. It establishes a reference for the current time, forming the basis for civil time AND time zones. UTC facilitates international communication, navigation, scientific research, AND commerce. ... 
	AND 
	( -- INITIATE ...
	(asr.codeid IN ('H0043', 'H2016','T2040', 'T2050', 'T2051','T2041','T2033', -- M001: 'TBD' placeholder retired ~ not a valid HCPCS code
	'H0045','S5151','S9125','T2012','T2014','T2018','T2020','H2014','H2038',
	'H2024','H2026','S5130','T1019','S5170','S5165','S9470','S9977',
	'H0014','S9452') -- M002: S9452 added (DHCS v1.3 Jan 2026 Nutrition Education codes)
		AND (modcode IN ('U6') OR modcode2 IN ('U6') OR modcode3 IN ('U6')
		OR modcode4 IN ('U6') OR modcode5 IN ('U6')))
	OR (asr.codeid IN ('H0044') 
		AND (modcode IN ('U2') OR modcode2 IN ('U2') OR modcode3 IN ('U2')
		OR modcode4 IN ('U2') OR modcode5 IN ('U2')))
	OR (asr.codeid IN ('H0044','H0043') 
		AND (modcode IN ('U3') OR modcode2 IN ('U3') OR modcode3 IN ('U3')
		OR modcode4 IN ('U3') OR modcode5 IN ('U3')))
	OR (asr.codeid IN ('T2038') 
		AND (modcode IN ('U4') OR modcode2 IN ('U4') OR modcode3 IN ('U4')
		OR modcode4 IN ('U4') OR modcode5 IN ('U4')))
	OR (asr.codeid IN ('H2022') 
		AND (modcode IN ('U5') OR modcode2 IN ('U5') OR modcode3 IN ('U5')
		OR modcode4 IN ('U5') OR modcode5 IN ('U5')))
	OR (asr.codeid IN ('T2038','H0044') -- M004: H0044+U5 added (DHCS v1.3 Jan 2026 Community or Home Transition Non-Recurring Set-Up Expenses)
		AND (modcode IN ('U5') OR modcode2 IN ('U5') OR modcode3 IN ('U5')
		OR modcode4 IN ('U5') OR modcode5 IN ('U5')))
	OR (asr.codeid IN ('S5165') 
		AND (modcode IN ('U5') OR modcode2 IN ('U5') OR modcode3 IN ('U5')
		OR modcode4 IN ('U5') OR modcode5 IN ('U5')))
	OR (asr.codeid IN ('S9452') -- M002: Nutrition Education Individual (U5) modifier leg
		AND (modcode IN ('U5') OR modcode2 IN ('U5') OR modcode3 IN ('U5')
		OR modcode4 IN ('U5') OR modcode5 IN ('U5')))
	OR (asr.codeid IN ('S9977') -- M003: Produce Rx Box (U4), Produce Rx Retail (U5), Medically Supportive Groceries (U7), Food Pharmacy (U8), Healthy Food Vouchers (U9)
		AND (modcode IN ('U4','U5','U7','U8','U9') OR modcode2 IN ('U4','U5','U7','U8','U9') OR modcode3 IN ('U4','U5','U7','U8','U9')
		OR modcode4 IN ('U4','U5','U7','U8','U9') OR modcode5 IN ('U4','U5','U7','U8','U9')))
	OR (asr.codeid IN ('T1016') -- M005: Housing outreach initiation mandatory PACES encounter codes (DHCS v1.3 Jan 2026)
		AND (modcode IN ('U8') OR modcode2 IN ('U8') OR modcode3 IN ('U8')
		OR modcode4 IN ('U8') OR modcode5 IN ('U8')))
		
	OR (SUBSTRING(UPPER(LTRIM(RTRIM(ISNULL(asr.codeid,'')))),1,5) IN ('H0040') -- C005: Update to Community Support Offered logic: 'Transitional Rent' per Ms Kathryn eMail on 20251216 - SUBJECT:Question: Transitional Rent codes in CommunitySupportsAuthStatus Report ~ LEVERAGE: http://devops01:8080/IS/Informatics/_workitems/edit/23626/
		AND (modcode IN ('U1') OR modcode2 IN ('U1') OR modcode3 IN ('U1')OR modcode4 IN ('U1') OR modcode5 IN ('U1')))
		
	OR (SUBSTRING(UPPER(LTRIM(RTRIM(ISNULL(asr.codeid,'')))),1,5) IN ('H0040','H0043') -- C005: Update to Community Support Offered logic: 'Transitional Rent' per Ms Kathryn eMail on 20251216 - SUBJECT:Question: Transitional Rent codes in CommunitySupportsAuthStatus Report ~ LEVERAGE: http://devops01:8080/IS/Informatics/_workitems/edit/23626/
		AND (modcode IN ('U2') OR modcode2 IN ('U2') OR modcode3 IN ('U2')OR modcode4 IN ('U2') OR modcode5 IN ('U2')))
		
	OR (SUBSTRING(UPPER(LTRIM(RTRIM(ISNULL(asr.codeid,'')))),1,5) IN ('H0044') -- C005: Update to Community Support Offered logic: 'Transitional Rent' per Ms Kathryn eMail on 20251216 - SUBJECT:Question: Transitional Rent codes in CommunitySupportsAuthStatus Report ~ LEVERAGE: http://devops01:8080/IS/Informatics/_workitems/edit/23626/
		AND (modcode IN ('U6') OR modcode2 IN ('U6') OR modcode3 IN ('U6') OR modcode4 IN ('U6') OR modcode5 IN ('U6')))
	) -- CONCLUDE ...
	AND r.termdate >= r.effdate -- MUST BE TRUE ... NON-CROSSFOOTED RECORDS ARE ACTIVE ...		

UNION 
SELECT DISTINCT r.memid
,r.referto
,r.authorizationid
FROM HMOPROD_PlanData.dbo.member AS m
	INNER JOIN HMOPROD_PlanData.dbo.referral AS r ON r.memid = m.memid
	INNER JOIN HMOPROD_PLANDATA.dbo.authservice AS asr ON asr.referralid = r.referralid
	INNER JOIN HMOPROD_PLANDATA.dbo.entity AS e ON m.entityid = e.entid
		LEFT JOIN HMOPROD_PlanData.dbo.svccode svc ON svc.codeid = asr.codeid
WHERE 1=1 
	AND r.servicecode = 'RCU01'
	AND r.status IN ('denied')
	AND r.authstatus IN ('denied')
	AND asr.status IN ('denied')
	AND CAST(CONVERT(datetime,(r.UtcReceiptDate at time zone 'UTC') at time zone 'Pacific Standard Time') AS date) BETWEEN @ClockStart AND @ClockStop -- C004: UPDATE OF DATE [RANGE] DRIVER using CAST(CONVERT(datetime,(r.UtcReceiptDate at time zone 'UTC') at time zone 'Pacific Standard Time') AS date) per WEEKLY ECM / CS Meeting discussion AND "UPDATED ECM-CS Quarterly Reports Narrative 4.24.24.docx" ...Coordinated Universal Time or UTC is the primary time standard globally used to regulate clocks AND time. It establishes a reference for the current time, forming the basis for civil time AND time zones. UTC facilitates international communication, navigation, scientific research, AND commerce. ... 
	AND asr.codeid = 'T2033' 
	AND (modcode IN ('U6') 
		OR modcode2 IN ('U6') 
		OR modcode3 IN ('U6')
		OR modcode4 IN ('U6') 
		OR modcode5 IN ('U6')) 
	AND r.termdate >= r.effdate -- MUST BE TRUE ... NON-CROSSFOOTED RECORDS ARE ACTIVE ...			

SELECT DISTINCT CS.[Plan Name],
CS.[Plan Code],
CS.COUNTY,
CS.[Reporting Period],
COUNT(DISTINCT (CS.memid)) AS 'Number of Members with External Community Supports Request',
COUNT (DISTINCT (CSD.memid)) AS 'Number of Members with External Community Supports Request Denied'
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st',
INTO INFORMATICS.dbo.ECMCSQTRLY_TAB6
FROM #CSAuths# AS CS 
	LEFT JOIN #CSDeniedRequests# CSD ON CSD.memid = CS.memid
GROUP BY CS.[Plan Name], CS.[Plan Code], CS.COUNTY, CS.[Reporting Period]

SELECT ' ' AS 'PER REPORT MEETING REQUEST ON 20250811: ',*
INTO INFORMATICS .dbo.ECM_Q_TAB6_CSDeniedRequests_DETAIL
FROM #CSDeniedRequests#

		/* SELECT csdr.* -- MS EXCEL ODBC DELIVERABLE
		,CAST(CONVERT(datetime,(r.UtcReceiptDate at time zone 'UTC') at time zone 'Pacific Standard Time') AS date) AS 'Receiptdate'
		,r.servicecode
		,r.status
		,r.authstatus
		,svc.* 	-- ,asr.*
		FROM INFORMATICS .dbo.ECM_Q_TAB6_CSDeniedRequests_DETAIL AS csdr
			INNER JOIN HMOPROD_PLANDATA.dbo.referral AS r ON csdr.authorizationid = r.authorizationid
			INNER JOIN HMOPROD_PLANDATA.dbo.authservice AS asr ON r.referralid = asr.referralid
				LEFT JOIN HMOPROD_PlanData.dbo.svccode AS svc ON svc.codeid = asr.codeid
		WHERE 1=1 
			AND asr.sequence = 1 */

		SELECT * FROM INFORMATICS.dbo.ECMCSQTRLY_TAB6

		SELECT ' ' AS 'CS Tab 6 REVIEW: '
		,CS.referto
		,piso.PROVNM
		,piso.NPI
		,COUNT(DISTINCT(memid)) AS 'Number of Members with External Community Supports Request'
		,COUNT(DISTINCT(authorizationid)) AS 'Number of Auths with External Community Supports Request'
		FROM #CSAuths# AS CS 
			INNER JOIN INFORMATICS.dbo.[uvw_PROVISO] AS piso ON CS.referto = piso.provid
		WHERE 1=1
			-- AND CS.referto IN ('360594','338896')
		GROUP BY CS.referto,piso.PROVNM,piso.NPI

		SELECT ' ' AS 'QA - SERENE',* 
		FROM INFORMATICS.dbo.[uvw_PROVISO] 
		WHERE 1=1
			AND NPI IN ('1114765229','1649809526')
				OR PROVNM LIKE '%SEREN%HEALTH%' --   ('SERENE HEALTH', '1114765229', 'Behavioral health entity', 'Housing Deposits', 105), -- C001: CS PROVIDER NPI CHANGE.LOG - WRONG NPI: 1649809526	Please update to reflect the CORRECT NPI: 1114765229 PER eMAIL FROM MS CLAUDIA ON 20250429
