-- =====================================================================
	-- MODIFICATION(S) / CHANGE.LOG: --
-- =====================================================================
/* Tab 4. Community Supports Members AND Services: 
		•	For columns J - X, indicate which Community Supports services the member 			was approved for, during the reporting period, by entering 1 for Yes AND 0 for No.	
		•	For columns Y - AM, indicate which Community Supports services the member received, 			during the reporting period, by entering 1 for Yes AND 0 for No. */

-- C000: START WITH() ECMELIG PER WEEKLY ECM TEAMS MEETING + MS CLAUDIA GUIDANCE ON 20240418

-- C001: Additional AUTH TEMPLATE for CS (COMMUNITY SUPPORT) AuthRef NEW AND r.servicecode = 'RCU01'  FOR JUST THAT CPT, modcode COMBINATION T2033, U6

-- C002: [TargetPopulation] ? In the 20240418 script, the POF assessment is updated to use the [ProviderPortal].ecm.[StratificationTargetPopulation] table instead, AS per the guidance FROM the ECM weekly teams meeting ON 20240418.

 -- C003: IN ('1063122323','1083764724','1447281936','1134144165','1205254950','1245246917','1295822658','1356889539','1366807760','1376229872','1427696616','1528271186','1073177739','1609920305','1619393584','1639614688','1649809526','1669711297','1689798985','1710439559','1760477467','1790718351','1891408043','1922642909','1598703647','1679158125','1952364747','1962483040','1982756086','1275972333','1255496105','1912688656','1134838352','1710336094','1710065933','1679357685','1922790906','1699043000','1255738423') -- C00#: UPDATE ECM National Provider Identifier (NPI) Number per "MOC Excel File ECM Provider Capacity Template 2023 Mapping 4.25.2024 20240503.xlsx"

-- C004: PLACEHOLDER PENDING SPECIFIC LOGIC FOR: Approved for Transitional Rent'  AS OF 2025123 - LEVERAGE: "UPDATED ECM-CS Quarterly Reports Narrative 9.9.25.docx" ... ,'0' AS 'Approved for Transitional Rent' 

-- C005: ... Now we will only be reporting "received service" if there was a claim during that specific quarter, that validates that the member received the service. "Approved for" remains the same. I will submit to informatics after it gets approved in the reports meeting. - LEVERAGE: "UPDATED ECM-CS Quarterly Reports Narrative 11-10-2025.docx"

-- C006: Update to Community Support Offered logic: 'Transitional Rent' per Ms Kathryn eMail on 20251216 - SUBJECT:Question: Transitional Rent codes in CommunitySupportsAuthStatus Report ~ LEVERAGE: http://devops01:8080/IS/Informatics/_workitems/edit/23626/

		/* [Community Support Service Name]	[Code]	[Modifier]	[Units for Auth]	[Auth End]
		Transitional Rent											H0040	U2					6								6 months 
		Transitional Rent											H0040	U1					1								6 months 
		Transitional Rent											H0043	U2					168							6 months 
		Transitional Rent											H0044	U6					6								6 months  */

-- M001: 20260605 - BUG FIX: 'Approved for Other Services' in BOTH UNION branches of #CSPopAuths# used asr.codeid <> NULL which always evaluates to UNKNOWN in T-SQL and therefore always returned '0'. Corrected to asr.codeid IS NOT NULL. Mirrors M002 fix already applied to STEP88_CS_COMMUNITYSUPPORT_POPULATION_20260605. Lines formerly: 377 (branch 1 css) and 544 (branch 2 RCU01).

-- M002: 20260605 - BUG FIX: 'Approved for Transitional Rent' in #CSPopAuths# UNION branch 2 (RCU01) was hardcoded '0' (stale C004 placeholder). Replaced with full C006 CASE logic to align with branch 1 (css). Mirrors M001 fix already applied to STEP88_CS_COMMUNITYSUPPORT_POPULATION_20260605. Line formerly: 542.

-- M003: 20260605 - DHCS HCPCS Coding Guidance v1.3 January 2026 ALIGNMENT: Added six new MTM/MSF subservice legs (S9452+U5 Nutrition Education Individual, S9452+U6 Nutrition Education Group, S9977+U4 Produce Rx Box, S9977+U5 Produce Rx Retail, S9977+U7 Medically Supportive Groceries, S9977+U8 Food Pharmacy, S9977+U9 Healthy Food Vouchers); H0044+U5 (Community or Home Transition Non-Recurring Set-Up Expenses); and mandatory housing outreach encounter codes T1016+U8 (in-person) and T1016+U8+GQ (telephonic/electronic). Applied to: #CSPopClaims# CASE blocks and WHERE filter; #CSPopAuths# UNION branch 1 and branch 2 CASE blocks and WHERE filter (branch 1 only); final SELECT #CSServices# pivot.

-- M004: 20260605 - ALIAS NORMALIZATION: Output column aliases for Housing Transition/Navigation Services normalized to slash+space ('Housing Transition/ Navigation Services') throughout - consistent with temp table column definition and STEP88 standard. Final SELECT output aliases and OLE DB block updated to match. Formerly slash-only (no space) at lines 645, 710, 803, 819.

-- M005: 20260605 - NEW OUTPUT COLUMNS: Added 'Approved for Housing Outreach - Initiation' and 'Received Housing Outreach - Initiation' pivot columns to final #CSServices# SELECT and OLE DB commented block, sourcing from the new T1016+U8 CASE columns added via M003.

-- =====================================================================
	-- DECLARE @PARAMETER(S) / @FILTER(S) --
-- =====================================================================
DECLARE @leadlag AS decimal(9,0)
DECLARE @leadlagmonths AS int
DECLARE @CSClockStart AS datetime2
DECLARE @CSClockStop AS datetime2
DECLARE @IPPdt AS datetime2
DECLARE @gapallowance AS int

SET @leadlag = -4 -- +- LEAD() LAG() IN ...
SET @leadlagmonths = 3 -- +- LEAD() LAG() IN MONTH(S)
SET @CSClockStart = DATEADD(MONTH,@leadlag,DATEADD(DAY,1,EOMONTH(GETDATE(),-1))) -- AS [1st of ... MONTH]
SET @CSClockStop = DATEADD(day,-1,DATEADD(MONTH,@leadlagmonths,@CSClockStart))
SET @IPPdt = TRY_CONVERT(date,GETDATE())
SET @gapallowance = 14

		SELECT 'BETWEEN '+CAST(CAST(@CSClockStart AS date) AS varchar (25))+' AND '+CAST(CAST(@CSClockStop AS date) AS varchar (25)) AS [RANGE NOTE(s)]
		,TRY_CONVERT(varchar(4),DATEPART(yyyy,@CSClockStart))+' Q'+TRY_CONVERT(varchar(2),DATEPART(q,@CSClockStart)) AS [Reporting Period]
		
		-- SELECT TOP 1 * FROM dbo.[uvw_AUTHREFCLAIM]







---------------------------------------------------------------------------------------------------------------------------------
	-- Error Trapping: Check If Permanent Table(s) Already Exist(s) AND Drop If Applicable --
----------------------------------------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS INFORMATICS.dbo.ECMCSQTRLY_TAB4
DROP TABLE IF EXISTS #CSPopClaims#;
DROP TABLE IF EXISTS #CSPopAuths#;
DROP TABLE IF EXISTS #baseline;
DROP TABLE IF EXISTS #CSServices#;

-- =====================================================================
	-- CS (Community Supports) CLAIMS service received: 
-- =====================================================================
SELECT DISTINCT clm.memid,
'1' AS 'Member received Community Supports Services',
SUBSTRING(UPPER(LTRIM(RTRIM(ISNULL(cd.servcode,'')))),1,5) AS 'codeid',
cd.modcode,
cd.modcode2,
cd.modcode3,
cd.modcode4,
cd.modcode5,
CASE 
WHEN SUBSTRING(UPPER(LTRIM(RTRIM(ISNULL(cd.servcode,'')))),1,5) IN ('H0043','H2016') 
	AND (cd.modcode IN ('U6') OR cd.modcode2 IN ('U6') OR cd.modcode3 IN ('U6') OR cd.modcode4 IN ('U6') OR cd.modcode5 IN ('U6')) 
THEN '1'
	ELSE '0'
END AS 'Received Housing Transition/ Navigation Services',
CASE 
WHEN SUBSTRING(UPPER(LTRIM(RTRIM(ISNULL(cd.servcode,'')))),1,5) = 'H0044'
	AND (cd.modcode IN ('U2') OR cd.modcode2 IN ('U2') OR cd.modcode3 IN ('U2') OR cd.modcode4 IN ('U2') OR cd.modcode5 IN ('U2')) 
THEN '1'
	ELSE '0'
END AS 'Received Housing Deposits',
CASE 
WHEN SUBSTRING(UPPER(LTRIM(RTRIM(ISNULL(cd.servcode,'')))),1,5) IN ('T2040','T2050','T2041','T2051')
	AND (cd.modcode IN ('U6') OR cd.modcode2 IN ('U6') OR cd.modcode3 IN ('U6') OR cd.modcode4 IN ('U6') OR cd.modcode5 IN ('U6')) 
THEN '1'
	ELSE '0'
END AS 'Received Housing Tenancy and Sustaining Services',
CASE 
WHEN SUBSTRING(UPPER(LTRIM(RTRIM(ISNULL(cd.servcode,'')))),1,5) IN ('H0043','H0044')
	AND (cd.modcode IN ('U3') OR cd.modcode2 IN ('U3') OR cd.modcode3 IN ('U3') OR cd.modcode4 IN ('U3') OR cd.modcode5 IN ('U3')) 
THEN '1'
	ELSE '0'
END AS 'Received Short-Term Post-Hospitalization Housing',
CASE 
WHEN SUBSTRING(UPPER(LTRIM(RTRIM(ISNULL(cd.servcode,'')))),1,5) = 'T2033'
	AND (cd.modcode IN ('U6') OR cd.modcode2 IN ('U6') OR cd.modcode3 IN ('U6') OR cd.modcode4 IN ('U6') OR cd.modcode5 IN ('U6')) 
THEN '1'
	ELSE '0'
END AS 'Received Recuperative Care',
CASE 
WHEN SUBSTRING(UPPER(LTRIM(RTRIM(ISNULL(cd.servcode,'')))),1,5) IN ('H0045','S5151','S9125')
	AND (cd.modcode IN ('U6') OR cd.modcode2 IN ('U6') OR cd.modcode3 IN ('U6') OR cd.modcode4 IN ('U6') OR cd.modcode5 IN ('U6')) 
THEN '1'	
	ELSE '0'
END AS 'Received Respite Services',
CASE 
WHEN SUBSTRING(UPPER(LTRIM(RTRIM(ISNULL(cd.servcode,'')))),1,5) IN ('T2012','T2014','T2018','T2020','H2014','H2038','H2024','H2026')
	AND (cd.modcode IN ('U6') OR cd.modcode2 IN ('U6') OR cd.modcode3 IN ('U6') OR cd.modcode4 IN ('U6') OR cd.modcode5 IN ('U6')) 
THEN '1'
	ELSE '0'
END AS 'Received Day Habilitation Programs',
CASE 
WHEN SUBSTRING(UPPER(LTRIM(RTRIM(ISNULL(cd.servcode,'')))),1,5) = 'T2038'
	AND (cd.modcode IN ('U4') OR cd.modcode2 IN ('U4') OR cd.modcode3 IN ('U4') OR cd.modcode4 IN ('U4') OR cd.modcode5 IN ('U4')) 
THEN '1'		
WHEN SUBSTRING(UPPER(LTRIM(RTRIM(ISNULL(cd.servcode,'')))),1,5) = 'H2022'
	AND (cd.modcode IN ('U5') OR cd.modcode2 IN ('U5') OR cd.modcode3 IN ('U5') OR cd.modcode4 IN ('U5') OR cd.modcode5 IN ('U5')) 
THEN '1'	
	ELSE '0'
END AS 'Received NF Transition to ALF',
CASE 
WHEN SUBSTRING(UPPER(LTRIM(RTRIM(ISNULL(cd.servcode,'')))),1,5) = 'T2038'
	AND (cd.modcode IN ('U5') OR cd.modcode2 IN ('U5') OR cd.modcode3 IN ('U5') OR cd.modcode4 IN ('U5') OR cd.modcode5 IN ('U5')) 
THEN '1'
WHEN SUBSTRING(UPPER(LTRIM(RTRIM(ISNULL(cd.servcode,'')))),1,5) = 'H0044' -- M003: DHCS v1.3 Jan 2026 ~ Community or Home Transition Non-Recurring Set-Up Expenses (Updated January 2026)
	AND (cd.modcode IN ('U5') OR cd.modcode2 IN ('U5') OR cd.modcode3 IN ('U5') OR cd.modcode4 IN ('U5') OR cd.modcode5 IN ('U5'))
THEN '1'
	ELSE '0'
END AS 'Received NF Transition to a Home',
CASE 
WHEN SUBSTRING(UPPER(LTRIM(RTRIM(ISNULL(cd.servcode,'')))),1,5) IN ('S5130','T1019')
	AND (cd.modcode IN ('U6') OR cd.modcode2 IN ('U6') OR cd.modcode3 IN ('U6') OR cd.modcode4 IN ('U6') OR cd.modcode5 IN ('U6')) 
THEN '1'
	ELSE '0'
END AS 'Received Personal Care and Homemaker Services',
CASE 
WHEN SUBSTRING(UPPER(LTRIM(RTRIM(ISNULL(cd.servcode,'')))),1,5) = 'S5165'
	AND (cd.modcode IN ('U6') OR cd.modcode2 IN ('U6') OR cd.modcode3 IN ('U6') OR cd.modcode4 IN ('U6') OR cd.modcode5 IN ('U6')) 
THEN '1'
	ELSE '0'
END AS 'Received Environmental Accessibility Adaptations',
CASE 
WHEN SUBSTRING(UPPER(LTRIM(RTRIM(ISNULL(cd.servcode,'')))),1,5) IN ('S5170','S9470','S9977')
	AND (cd.modcode IN ('U6') OR cd.modcode2 IN ('U6') OR cd.modcode3 IN ('U6') OR cd.modcode4 IN ('U6') OR cd.modcode5 IN ('U6'))
THEN '1'
WHEN SUBSTRING(UPPER(LTRIM(RTRIM(ISNULL(cd.servcode,'')))),1,5) = 'S9452' -- M003: DHCS v1.3 Jan 2026 ~ Nutrition Education Individual (U5) and Group (U6) sessions
	AND (cd.modcode IN ('U5','U6') OR cd.modcode2 IN ('U5','U6') OR cd.modcode3 IN ('U5','U6') OR cd.modcode4 IN ('U5','U6') OR cd.modcode5 IN ('U5','U6'))
THEN '1'
WHEN SUBSTRING(UPPER(LTRIM(RTRIM(ISNULL(cd.servcode,'')))),1,5) = 'S9977' -- M003: DHCS v1.3 Jan 2026 ~ Produce Rx Box (U4), Produce Rx Retail (U5), Medically Supportive Groceries (U7), Food Pharmacy (U8), Healthy Food Vouchers (U9)
	AND (cd.modcode IN ('U4','U5','U7','U8','U9') OR cd.modcode2 IN ('U4','U5','U7','U8','U9') OR cd.modcode3 IN ('U4','U5','U7','U8','U9') OR cd.modcode4 IN ('U4','U5','U7','U8','U9') OR cd.modcode5 IN ('U4','U5','U7','U8','U9'))
THEN '1'
	ELSE '0'
END AS 'Received Medically-Supportive Food',
CASE 
WHEN SUBSTRING(UPPER(LTRIM(RTRIM(ISNULL(cd.servcode,'')))),1,5) = 'H0014'
	AND (cd.modcode IN ('U6') OR cd.modcode2 IN ('U6') OR cd.modcode3 IN ('U6') OR cd.modcode4 IN ('U6') OR cd.modcode5 IN ('U6')) 
THEN '1'
	ELSE '0'
END AS 'Received Sobering Centers',
CASE 
WHEN SUBSTRING(UPPER(LTRIM(RTRIM(ISNULL(cd.servcode,'')))),1,5) = 'S5165'
	AND (cd.modcode IN ('U5') OR cd.modcode2 IN ('U5') OR cd.modcode3 IN ('U5') OR cd.modcode4 IN ('U5') OR cd.modcode5 IN ('U5')) 
THEN '1'	
	ELSE '0'
END AS 'Received Asthma Remediation',
-- '0' AS 'Received Transitional Rent', -- C004: PLACEHOLDER PENDING SPECIFIC LOGIC FOR: Approved for Transitional Rent'  AS OF 2025123 - LEVERAGE: "UPDATED ECM-CS Quarterly Reports Narrative 9.9.25.docx"
CASE 
WHEN SUBSTRING(UPPER(LTRIM(RTRIM(ISNULL(cd.servcode,'')))),1,5) IN ('H0040') 
	AND (cd.modcode IN ('U1') OR cd.modcode2 IN ('U1') OR cd.modcode3 IN ('U1') OR cd.modcode4 IN ('U1') OR cd.modcode5 IN ('U1')) 
THEN '1'
WHEN SUBSTRING(UPPER(LTRIM(RTRIM(ISNULL(cd.servcode,'')))),1,5) IN ('H0040','H0043') 
	AND (cd.modcode IN ('U2') OR cd.modcode2 IN ('U2') OR cd.modcode3 IN ('U2') OR cd.modcode4 IN ('U2') OR cd.modcode5 IN ('U2')) 
THEN '1'
WHEN SUBSTRING(UPPER(LTRIM(RTRIM(ISNULL(cd.servcode,'')))),1,5) IN ('H0044') 
	AND (cd.modcode IN ('U6') OR cd.modcode2 IN ('U6') OR cd.modcode3 IN ('U6') OR cd.modcode4 IN ('U6') OR cd.modcode5 IN ('U6')) 
THEN '1'
ELSE '0'
END AS 'Received Transitional Rent',  -- C006: Update to Community Support Offered logic: 'Transitional Rent' per Ms Kathryn eMail on 20251216 - SUBJECT:Question: Transitional Rent codes in CommunitySupportsAuthStatus Report ~ LEVERAGE: http://devops01:8080/IS/Informatics/_workitems/edit/23626/
CASE 
WHEN SUBSTRING(UPPER(LTRIM(RTRIM(ISNULL(cd.servcode,'')))),1,5) = 'T1016' -- M003: DHCS v1.3 Jan 2026 mandatory outreach encounter codes ~ PACES submission required; MCP reimbursement optional per DHCS pg 18-20
	AND (cd.modcode IN ('U8') OR cd.modcode2 IN ('U8') OR cd.modcode3 IN ('U8') OR cd.modcode4 IN ('U8') OR cd.modcode5 IN ('U8'))
THEN '1'
	ELSE '0'
END AS 'Received Housing Outreach - Initiation', -- M003: T1016+U8 (in-person) and T1016+U8+GQ (telephonic/electronic) ~ both successful and unsuccessful outreach ~ Housing Transition/Navigation, Housing Deposits, Housing Tenancy and Sustaining Services
CASE 
WHEN NOT SUBSTRING(UPPER(LTRIM(RTRIM(ISNULL(cd.servcode,'')))),1,5)  = '' -- NO NOT NEGATIVE <> != ...
THEN '1'
	ELSE '0'
END AS 'Received Other Services',
CASE 
WHEN bp.LINE_OF_BUSINESS IN ('MEDI-CAL') 
THEN 'Medi-Cal'
WHEN bp.LINE_OF_BUSINESS LIKE '%IV%'
THEN 'CHPIV DSNP'
WHEN bp.LINE_OF_BUSINESS LIKE '%CMC%'
THEN 'CMC'
WHEN bp.LINE_OF_BUSINESS LIKE '%DSNP%'
THEN 'DSNP'
ELSE 'Unknown'
END AS [LineofBusiness],
clm.claimid,
Glembocki.authorizationid
INTO #CSPopClaims#
FROM HMOPROD_PLANDATA.dbo.claim (NOLOCK) AS clm
	INNER JOIN HMOPROD_PLANDATA.dbo.claimdetail (NOLOCK) AS cd ON clm.claimid = cd.claimid
	-- JOIN INFORMATICS.dbo.[uvw_CLAIMS_PAID] AS pc ON clm.claimid = pc.claimid -- PAID CLAIM ISO !!!	
	INNER JOIN INFORMATICS.dbo.[uvw_LINE_OF_BUSINESS] AS bp ON clm.planid = bp.planid
		LEFT JOIN INFORMATICS.dbo.[uvw_AUTHREFCLAIM] AS  Glembocki ON clm.claimid = Glembocki.claimid -- 'Claude.ai v Perplexity.ai ...  'c.referralid OR cd.referralid = ref.authorizationid DISCOVERED ON 20150728 w Stefan Glembocki' ... C005: ... Now we will only be reporting "received service" if there was a claim during that specific quarter, that validates that the member received the service. "Approved for" remains the same. I will submit to informatics after it gets approved in the reports meeting. - LEVERAGE: "UPDATED ECM-CS Quarterly Reports Narrative 11-10-2025.docx"
WHERE 1=1 
	AND TRY_CONVERT(date,ISNULL(clm.enddate,GETDATE())) >= @CSClockStart -- WITHIN reporting period [RANGE] OPPOSITION .. Did the Member receive Community Supports services during the reporting period? Enter 1 for Yes. Enter 0 for No.
	AND TRY_CONVERT(date,clm.startdate) <= @CSClockStop -- WITHIN reporting period [RANGE] OPPOSITION .. Did the Member receive Community Supports services during the reporting period? Enter 1 for Yes. Enter 0 for No.
	-- AND TRY_CONVERT(date,clm.startdate) BETWEEN @CSClockStart AND @CSClockStop -- ... Did the Member receive Community Supports services during the reporting period? Enter 1 for Yes. Enter 0 for No.
	-- AND bp.programid IN ('QMXHPQ0842','QMXHPQ0847','QMXHPQ0848','QMXHPQ0850','QMXHPQ0851')
	AND 
	( -- INITIATE ...
	(SUBSTRING(UPPER(LTRIM(RTRIM(ISNULL(cd.servcode,'')))),1,5) IN ('H0043','H2016','T2040','T2050','T2051','T2041','T2033','H0045','S5151','S9125','T2012','T2014','T2018','T2020','H2014','H2038','H2024','H2026','S5130','T1019','S5170','S5165','S9470','S9977','H0014','S9452') -- M003: S9452 added (DHCS v1.3 Jan 2026 Nutrition Education codes)
		AND (cd.modcode IN ('U6') OR cd.modcode2 IN ('U6') OR cd.modcode3 IN ('U6') OR cd.modcode4 IN ('U6') OR cd.modcode5 IN ('U6')))

	OR (SUBSTRING(UPPER(LTRIM(RTRIM(ISNULL(cd.servcode,'')))),1,5) IN ('H0044') 
		AND (cd.modcode IN ('U2') OR cd.modcode2 IN ('U2') OR cd.modcode3 IN ('U2') OR cd.modcode4 IN ('U2') OR cd.modcode5 IN ('U2')))

	OR (SUBSTRING(UPPER(LTRIM(RTRIM(ISNULL(cd.servcode,'')))),1,5) IN ('H0044','H0043') 
		AND (cd.modcode IN ('U3') OR cd.modcode2 IN ('U3') OR cd.modcode3 IN ('U3') OR cd.modcode4 IN ('U3') OR cd.modcode5 IN ('U3')))

	OR (SUBSTRING(UPPER(LTRIM(RTRIM(ISNULL(cd.servcode,'')))),1,5) IN ('T2038') 
		AND (cd.modcode IN ('U4') OR cd.modcode2 IN ('U4') OR cd.modcode3 IN ('U4') OR cd.modcode4 IN ('U4') OR cd.modcode5 IN ('U4')))

	OR (SUBSTRING(UPPER(LTRIM(RTRIM(ISNULL(cd.servcode,'')))),1,5) IN ('H2022') 
		AND (cd.modcode IN ('U5') OR cd.modcode2 IN ('U5') OR cd.modcode3 IN ('U5') OR cd.modcode4 IN ('U5') OR cd.modcode5 IN ('U5')))

	OR (SUBSTRING(UPPER(LTRIM(RTRIM(ISNULL(cd.servcode,'')))),1,5) IN ('T2038','H0044') -- M003: H0044+U5 added (DHCS v1.3 Jan 2026 Community or Home Transition Non-Recurring Set-Up Expenses)
		AND (cd.modcode IN ('U5') OR cd.modcode2 IN ('U5') OR cd.modcode3 IN ('U5') OR cd.modcode4 IN ('U5') OR cd.modcode5 IN ('U5')))

	OR (SUBSTRING(UPPER(LTRIM(RTRIM(ISNULL(cd.servcode,'')))),1,5) IN ('S5165') 
		AND (cd.modcode IN ('U5') OR cd.modcode2 IN ('U5') OR cd.modcode3 IN ('U5') OR cd.modcode4 IN ('U5') OR cd.modcode5 IN ('U5')))

	OR (SUBSTRING(UPPER(LTRIM(RTRIM(ISNULL(cd.servcode,'')))),1,5) IN ('S9452') -- M003: Nutrition Education Individual (U5) modifier leg
		AND (cd.modcode IN ('U5') OR cd.modcode2 IN ('U5') OR cd.modcode3 IN ('U5') OR cd.modcode4 IN ('U5') OR cd.modcode5 IN ('U5')))

	OR (SUBSTRING(UPPER(LTRIM(RTRIM(ISNULL(cd.servcode,'')))),1,5) IN ('S9977') -- M003: Produce Rx Box (U4), Produce Rx Retail (U5), Medically Supportive Groceries (U7), Food Pharmacy (U8), Healthy Food Vouchers (U9)
		AND (cd.modcode IN ('U4','U5','U7','U8','U9') OR cd.modcode2 IN ('U4','U5','U7','U8','U9') OR cd.modcode3 IN ('U4','U5','U7','U8','U9') OR cd.modcode4 IN ('U4','U5','U7','U8','U9') OR cd.modcode5 IN ('U4','U5','U7','U8','U9')))

	OR (SUBSTRING(UPPER(LTRIM(RTRIM(ISNULL(cd.servcode,'')))),1,5) IN ('T1016') -- M003: Housing outreach initiation mandatory PACES encounter codes (DHCS v1.3 Jan 2026)
		AND (cd.modcode IN ('U8') OR cd.modcode2 IN ('U8') OR cd.modcode3 IN ('U8') OR cd.modcode4 IN ('U8') OR cd.modcode5 IN ('U8')))

	OR (SUBSTRING(UPPER(LTRIM(RTRIM(ISNULL(cd.servcode,'')))),1,5) IN ('H0040') 
		AND (cd.modcode IN ('U1') OR cd.modcode2 IN ('U1') OR cd.modcode3 IN ('U1')OR cd.modcode4 IN ('U1') OR cd.modcode5 IN ('U1')))
		
	OR (SUBSTRING(UPPER(LTRIM(RTRIM(ISNULL(cd.servcode,'')))),1,5) IN ('H0040','H0043') 
		AND (cd.modcode IN ('U2') OR cd.modcode2 IN ('U2') OR cd.modcode3 IN ('U2')OR cd.modcode4 IN ('U2') OR cd.modcode5 IN ('U2')))
		
	OR (SUBSTRING(UPPER(LTRIM(RTRIM(ISNULL(cd.servcode,'')))),1,5) IN ('H0044') 
		AND (cd.modcode IN ('U6') OR cd.modcode2 IN ('U6') OR cd.modcode3 IN ('U6') OR cd.modcode4 IN ('U6') OR cd.modcode5 IN ('U6')))
		) -- CONCLUDE ...
	AND ISNULL(clm.enddate,GETDATE()) >= clm.startdate -- MUST BE TRUE ... NON-CROSSFOOTED RECORDS ARE ACTIVE ...
	
		SELECT ' ' AS 'QA - TEST CS (Community Supports) UM service received:',* 
		FROM #CSPopClaims# 
		WHERE 1=1 
			AND memid IN ('2522812' -- NO CLAIM IN REPORTING PERIOD
			,'2669594' -- NO CLAIM IN REPORTING PERIOD
			,'2569142' -- YES CLAIM IN REPORTING PERIOD
			,'2466721' -- YES CLAIM IN REPORTING PERIOD
			,'1062706') -- YES CLAIM IN REPORTING PERIOD
				OR authorizationid IN ('4746737')

		/* SELECT ' ' AS 'QA - TEST RESULT(S):',* 
		FROM INFORMATICS.dbo.uvw_BASELINE_MEMBERSHIP
		WHERE 1=1
			AND CIN IN ('92332490D' -- NO CLAIM IN REPORTING PERIOD
			,'95801651E' -- NO CLAIM IN REPORTING PERIOD
			,'90533621H' -- YES CLAIM IN REPORTING PERIOD
			,'97454745C' -- YES CLAIM IN REPORTING PERIOD
			,'93436183A') -- YES CLAIM IN REPORTING PERIOD */







-- =====================================================================
	-- CS (Community Supports) UM service approved: 
-- =====================================================================
SELECT DISTINCT m.memid,
'LEVERAGE: #CSPopClaims#' AS 'Member received Community Supports Services',
asr.codeid,
asr.modcode,
asr.modcode2,
asr.modcode3,
asr.modcode4,
asr.modcode5,
CASE 
WHEN asr.codeid IN ('H0043','H2016') 
	AND (modcode IN ('U6') OR modcode2 IN ('U6') OR modcode3 IN ('U6') OR modcode4 IN ('U6') OR modcode5 IN ('U6')) 
THEN '1'
	ELSE '0'
END AS 'Approved for Housing Transition/ Navigation Services',
CASE 
WHEN asr.codeid = 'H0044' 
	AND (modcode IN ('U2') OR modcode2 IN ('U2') OR modcode3 IN ('U2') OR modcode4 IN ('U2') OR modcode5 IN ('U2')) 
THEN '1'
	ELSE '0'
END AS 'Approved for Housing Deposits',
CASE 
WHEN asr.codeid IN ('T2040','T2050','T2041','T2051') 
	AND (modcode IN ('U6') OR modcode2 IN ('U6') OR modcode3 IN ('U6') OR modcode4 IN ('U6') OR modcode5 IN ('U6')) 
THEN '1'
	ELSE '0'
END AS 'Approved for Housing Tenancy and Sustaining Services',
CASE 
WHEN asr.codeid IN ('H0043','H0044') 
	AND (modcode IN ('U3') OR modcode2 IN ('U3') OR modcode3 IN ('U3') OR modcode4 IN ('U3') OR modcode5 IN ('U3')) 
THEN '1'
	ELSE '0'
END AS 'Approved for Short-Term Post-Hospitalization Housing',
CASE 
WHEN asr.codeid = 'T2033' 
	AND (modcode IN ('U6') OR modcode2 IN ('U6') OR modcode3 IN ('U6') OR modcode4 IN ('U6') OR modcode5 IN ('U6')) 
THEN '1'
	ELSE '0'
END AS 'Approved for Recuperative Care',
CASE 
WHEN asr.codeid IN ('H0045','S5151','S9125') 
	AND (modcode IN ('U6') OR modcode2 IN ('U6') OR modcode3 IN ('U6') OR modcode4 IN ('U6') OR modcode5 IN ('U6'))
THEN '1'	
	ELSE '0'
END AS 'Approved for Respite Services',
CASE 
WHEN asr.codeid IN ('T2012','T2014','T2018','T2020','H2014','H2038','H2024','H2026') 
	AND (modcode IN ('U6') OR modcode2 IN ('U6') OR modcode3 IN ('U6') OR modcode4 IN ('U6') OR modcode5 IN ('U6')) 
THEN '1'
	ELSE '0'
END AS 'Approved for Day Habilitation Programs',
CASE 
WHEN asr.codeid = 'T2038' 
	AND (modcode IN ('U4') OR modcode2 IN ('U4') OR modcode3 IN ('U4') OR modcode4 IN ('U4') OR modcode5 IN ('U4')) 
THEN '1'	
WHEN asr.codeid = 'H2022' 
	AND (modcode IN ('U5') OR modcode2 IN ('U5') OR modcode3 IN ('U5') OR modcode4 IN ('U5') OR modcode5 IN ('U5')) 
THEN '1'	
	ELSE '0'
END AS 'Approved for NF Transition to ALF',
CASE 
WHEN asr.codeid = 'T2038' 
	AND (modcode IN ('U5') OR modcode2 IN ('U5') OR modcode3 IN ('U5') OR modcode4 IN ('U5') OR modcode5 IN ('U5')) 
THEN '1'
WHEN asr.codeid = 'H0044' -- M003: DHCS v1.3 Jan 2026 ~ Community or Home Transition Non-Recurring Set-Up Expenses (Updated January 2026)
	AND (modcode IN ('U5') OR modcode2 IN ('U5') OR modcode3 IN ('U5') OR modcode4 IN ('U5') OR modcode5 IN ('U5'))
THEN '1'
	ELSE '0'
END AS 'Approved for NF Transition to a Home',
CASE 
WHEN asr.codeid IN ('S5130','T1019') 
	AND (modcode IN ('U6') OR modcode2 IN ('U6') OR modcode3 IN ('U6') OR modcode4 IN ('U6') OR modcode5 IN ('U6'))
THEN '1'
	ELSE '0'
END AS 'Approved for Personal Care and Homemaker Services',
CASE 
WHEN asr.codeid = 'S5165' 
	AND (modcode IN ('U6') OR modcode2 IN ('U6') OR modcode3 IN ('U6') OR modcode4 IN ('U6') OR modcode5 IN ('U6')) 
THEN '1'
	ELSE '0'
END AS 'Approved for Environmental Accessibility Adaptations',
CASE 
WHEN asr.codeid IN ('S5170','S9470','S9977') 
	AND (modcode IN ('U6') OR modcode2 IN ('U6') OR modcode3 IN ('U6') OR modcode4 IN ('U6') OR modcode5 IN ('U6'))
THEN '1'
WHEN asr.codeid = 'S9452' -- M003: DHCS v1.3 Jan 2026 ~ Nutrition Education Individual (U5) and Group (U6) sessions
	AND (modcode IN ('U5','U6') OR modcode2 IN ('U5','U6') OR modcode3 IN ('U5','U6') OR modcode4 IN ('U5','U6') OR modcode5 IN ('U5','U6'))
THEN '1'
WHEN asr.codeid = 'S9977' -- M003: DHCS v1.3 Jan 2026 ~ Produce Rx Box (U4), Produce Rx Retail (U5), Medically Supportive Groceries (U7), Food Pharmacy (U8), Healthy Food Vouchers (U9)
	AND (modcode IN ('U4','U5','U7','U8','U9') OR modcode2 IN ('U4','U5','U7','U8','U9') OR modcode3 IN ('U4','U5','U7','U8','U9') OR modcode4 IN ('U4','U5','U7','U8','U9') OR modcode5 IN ('U4','U5','U7','U8','U9'))
THEN '1'
	ELSE '0'
END AS 'Approved for Medically-Supportive Food',
CASE 
WHEN asr.codeid = 'H0014' 
	AND (modcode IN ('U6') OR modcode2 IN ('U6') OR modcode3 IN ('U6') OR modcode4 IN ('U6') OR modcode5 IN ('U6')) 
THEN '1'
	ELSE '0'
END AS 'Approved for Sobering Centers',
CASE 
WHEN asr.codeid = 'S5165' 
	AND (modcode IN ('U5') OR modcode2 IN ('U5') OR modcode3 IN ('U5') OR modcode4 IN ('U5') OR modcode5 IN ('U5')) 
THEN '1'	
	ELSE '0'
END AS 'Approved for Asthma Remediation',
-- '0' AS 'Approved for Transitional Rent', -- C004: PLACEHOLDER PENDING SPECIFIC LOGIC FOR: Approved for Transitional Rent'  AS OF 2025123 - LEVERAGE: "UPDATED ECM-CS Quarterly Reports Narrative 9.9.25.docx"
CASE 
WHEN SUBSTRING(UPPER(LTRIM(RTRIM(ISNULL(asr.codeid,'')))),1,5) IN ('H0040') 
	AND (modcode IN ('U1') OR modcode2 IN ('U1') OR modcode3 IN ('U1') OR modcode4 IN ('U1') OR modcode5 IN ('U1')) 
THEN '1'
WHEN SUBSTRING(UPPER(LTRIM(RTRIM(ISNULL(asr.codeid,'')))),1,5) IN ('H0040','H0043') 
	AND (modcode IN ('U2') OR modcode2 IN ('U2') OR modcode3 IN ('U2') OR modcode4 IN ('U2') OR modcode5 IN ('U2')) 
THEN '1'
WHEN SUBSTRING(UPPER(LTRIM(RTRIM(ISNULL(asr.codeid,'')))),1,5) IN ('H0044') 
	AND (modcode IN ('U6') OR modcode2 IN ('U6') OR modcode3 IN ('U6') OR modcode4 IN ('U6') OR modcode5 IN ('U6')) 
THEN '1'
ELSE '0'
END AS 'Approved for Transitional Rent', -- C006: Update to Community Support Offered logic: 'Transitional Rent' per Ms Kathryn eMail on 20251216 - SUBJECT:Question: Transitional Rent codes in CommunitySupportsAuthStatus Report ~ LEVERAGE: http://devops01:8080/IS/Informatics/_workitems/edit/23626/
CASE 
WHEN asr.codeid = 'T1016' -- M003: DHCS v1.3 Jan 2026 mandatory outreach encounter codes ~ PACES submission required; MCP reimbursement optional per DHCS pg 18-20
	AND (modcode IN ('U8') OR modcode2 IN ('U8') OR modcode3 IN ('U8') OR modcode4 IN ('U8') OR modcode5 IN ('U8'))
THEN '1'
	ELSE '0'
END AS 'Approved for Housing Outreach - Initiation', -- M003: T1016+U8 (in-person) and T1016+U8+GQ (telephonic/electronic) ~ both successful and unsuccessful outreach ~ Housing Transition/Navigation, Housing Deposits, Housing Tenancy and Sustaining Services
CASE 
WHEN asr.codeid IS NOT NULL -- M001: CORRECTED FROM asr.codeid <> NULL ~ <> NULL always evaluates to UNKNOWN in T-SQL, never TRUE
THEN '1'
ELSE '0'
END AS 'Approved for Other Services',
CASE 
WHEN bp.LINE_OF_BUSINESS IN ('MEDI-CAL') 
THEN 'Medi-Cal'
WHEN bp.LINE_OF_BUSINESS LIKE '%IV%'
THEN 'CHPIV DSNP'
WHEN bp.LINE_OF_BUSINESS LIKE '%CMC%'
THEN 'CMC'
WHEN bp.LINE_OF_BUSINESS LIKE '%DSNP%'
THEN 'DSNP'
ELSE 'Unknown'
END AS [LineofBusiness],
Glembocki.claimid, -- C005: ... Now we will only be reporting "received service" if there was a claim during that specific quarter, that validates that the member received the service. "Approved for" remains the same. I will submit to informatics after it gets approved in the reports meeting. - LEVERAGE: "UPDATED ECM-CS Quarterly Reports Narrative 11-10-2025.docx"
r.authorizationid
INTO #CSPopAuths#
FROM HMOPROD_PlanData.dbo.member AS m
	INNER JOIN HMOPROD_PlanData.dbo.referral AS r ON r.memid = m.memid
	INNER JOIN HMOPROD_PLANDATA.dbo.authservice AS asr ON asr.referralid = r.referralid
	INNER JOIN HMOPROD_PLANDATA.dbo.entity AS e ON m.entityid = e.entid
	INNER JOIN HMOPROD_PLANDATA.dbo.enrollkeys AS ek ON ek.enrollid = r.enrollid
	INNER JOIN INFORMATICS.dbo.[uvw_LINE_OF_BUSINESS] AS bp ON ek.planid = bp.planid	
		LEFT JOIN INFORMATICS.dbo.[uvw_AUTHREFCLAIM] AS  Glembocki ON r.referralid = Glembocki.referralid -- 'Claude.ai v Perplexity.ai ...  'c.referralid OR cd.referralid = ref.authorizationid DISCOVERED ON 20150728 w Stefan Glembocki' ... C005: ... Now we will only be reporting "received service" if there was a claim during that specific quarter, that validates that the member received the service. "Approved for" remains the same. I will submit to informatics after it gets approved in the reports meeting. - LEVERAGE: "UPDATED ECM-CS Quarterly Reports Narrative 11-10-2025.docx"
			AND r.authorizationid = Glembocki.authorizationid	
		LEFT JOIN HMOPROD_PlanData.dbo.svccode AS svc ON svc.codeid = asr.codeid
WHERE 1=1 
	AND r.servicecode = 'css'
	AND r.status = 'approved'
	AND r.authstatus = 'approved'
	AND asr.status = 'approved'
	AND CAST(CONVERT(datetime2,(r.UtcReceiptDate at time zone 'UTC') at time zone 'Pacific Standard Time') AS date) BETWEEN @CSClockStart AND @CSClockStop -- Coordinated Universal Time or UTC is the primary time standard globally used to regulate clocks AND time. It establishes a reference for the current time, forming the basis for civil time AND time zones. UTC facilitates international communication, navigation, scientific research, AND commerce. ... ADHOC REQUEST per eMAIL FROM MS NATALIA ON 20221115 '... We need to run a report through AuthScans for Auth Scan Report for EYECARE OF SAN DIEGO/Provider ID: 313124 ...'
	-- AND ek.programid IN ('QMXHPQ0842','QMXHPQ0847','QMXHPQ0848','QMXHPQ0850','QMXHPQ0851')
	AND 
	( -- INITIATE ...
	(asr.codeid IN ('H0043','H2016','T2040','T2050','T2051','T2041','T2033','H0045','S5151','S9125','T2012','T2014','T2018','T2020','H2014','H2038','H2024','H2026','S5130','T1019','S5170','S5165','S9470','S9977','H0014','S9452') -- M003: S9452 added (DHCS v1.3 Jan 2026 Nutrition Education codes)
		AND (modcode IN ('U6') OR modcode2 IN ('U6') OR modcode3 IN ('U6') OR modcode4 IN ('U6') OR modcode5 IN ('U6')))

	OR (asr.codeid IN ('H0044') 
		AND (modcode IN ('U2') OR modcode2 IN ('U2') OR modcode3 IN ('U2') OR modcode4 IN ('U2') OR modcode5 IN ('U2')))

	OR (asr.codeid IN ('H0044','H0043') 
		AND (modcode IN ('U3') OR modcode2 IN ('U3') OR modcode3 IN ('U3') OR modcode4 IN ('U3') OR modcode5 IN ('U3')))

	OR (asr.codeid IN ('T2038') 
		AND (modcode IN ('U4') OR modcode2 IN ('U4') OR modcode3 IN ('U4') OR modcode4 IN ('U4') OR modcode5 IN ('U4')))

	OR (asr.codeid IN ('H2022') 
		AND (modcode IN ('U5') OR modcode2 IN ('U5') OR modcode3 IN ('U5') OR modcode4 IN ('U5') OR modcode5 IN ('U5')))

	OR (asr.codeid IN ('T2038','H0044') -- M003: H0044+U5 added (DHCS v1.3 Jan 2026 Community or Home Transition Non-Recurring Set-Up Expenses)
		AND (modcode IN ('U5') OR modcode2 IN ('U5') OR modcode3 IN ('U5') OR modcode4 IN ('U5') OR modcode5 IN ('U5')))

	OR (asr.codeid IN ('S5165') 
		AND (modcode IN ('U5') OR modcode2 IN ('U5') OR modcode3 IN ('U5') OR modcode4 IN ('U5') OR modcode5 IN ('U5')))

	OR (asr.codeid IN ('S9452') -- M003: Nutrition Education Individual (U5) modifier leg
		AND (modcode IN ('U5') OR modcode2 IN ('U5') OR modcode3 IN ('U5') OR modcode4 IN ('U5') OR modcode5 IN ('U5')))

	OR (asr.codeid IN ('S9977') -- M003: Produce Rx Box (U4), Produce Rx Retail (U5), Medically Supportive Groceries (U7), Food Pharmacy (U8), Healthy Food Vouchers (U9)
		AND (modcode IN ('U4','U5','U7','U8','U9') OR modcode2 IN ('U4','U5','U7','U8','U9') OR modcode3 IN ('U4','U5','U7','U8','U9') OR modcode4 IN ('U4','U5','U7','U8','U9') OR modcode5 IN ('U4','U5','U7','U8','U9')))

	OR (asr.codeid IN ('T1016') -- M003: Housing outreach initiation mandatory PACES encounter codes (DHCS v1.3 Jan 2026)
		AND (modcode IN ('U8') OR modcode2 IN ('U8') OR modcode3 IN ('U8') OR modcode4 IN ('U8') OR modcode5 IN ('U8')))

	OR (SUBSTRING(UPPER(LTRIM(RTRIM(ISNULL(asr.codeid,'')))),1,5) IN ('H0040') 
		AND (modcode IN ('U1') OR modcode2 IN ('U1') OR modcode3 IN ('U1')OR modcode4 IN ('U1') OR modcode5 IN ('U1')))
		
	OR (SUBSTRING(UPPER(LTRIM(RTRIM(ISNULL(asr.codeid,'')))),1,5) IN ('H0040','H0043') 
		AND (modcode IN ('U2') OR modcode2 IN ('U2') OR modcode3 IN ('U2')OR modcode4 IN ('U2') OR modcode5 IN ('U2')))
		
	OR (SUBSTRING(UPPER(LTRIM(RTRIM(ISNULL(asr.codeid,'')))),1,5) IN ('H0044') 
		AND (modcode IN ('U6') OR modcode2 IN ('U6') OR modcode3 IN ('U6') OR modcode4 IN ('U6') OR modcode5 IN ('U6')))
		) -- CONCLUDE ...
	AND ISNULL(r.termdate,GETDATE()) >= ISNULL(r.effdate,GETDATE()) -- MUST BE TRUE ... NON-CROSSFOOTED RECORDS ARE ACTIVE ...

UNION 
SELECT DISTINCT m.memid,
'0' AS 'Member received Community Supports Services',
asr.codeid,
asr.modcode,
asr.modcode2,
asr.modcode3,
asr.modcode4,
asr.modcode5,
CASE 
WHEN asr.codeid IN ('H0043','H2016') 
	AND (modcode IN ('U6') OR modcode2 IN ('U6') OR modcode3 IN ('U6') OR modcode4 IN ('U6') OR modcode5 IN ('U6')) 
THEN '1'
	ELSE '0'
END AS 'Approved for Housing Transition/ Navigation Services',
CASE 
WHEN asr.codeid = 'H0044' 
	AND (modcode IN ('U2') OR modcode2 IN ('U2') OR modcode3 IN ('U2') OR modcode4 IN ('U2') OR modcode5 IN ('U2')) 
THEN '1'
	ELSE '0'
END AS 'Approved for Housing Deposits',
CASE 
WHEN asr.codeid IN ('T2040','T2050','T2041','T2051') 
	AND (modcode IN ('U6') OR modcode2 IN ('U6') OR modcode3 IN ('U6') OR modcode4 IN ('U6') OR modcode5 IN ('U6')) 
THEN '1'
	ELSE '0'
END AS 'Approved for Housing Tenancy and Sustaining Services',
CASE 
WHEN asr.codeid IN ('H0043','H0044') 
	AND (modcode IN ('U3') OR modcode2 IN ('U3') OR modcode3 IN ('U3') OR modcode4 IN ('U3') OR modcode5 IN ('U3')) 
THEN '1'
	ELSE '0'
END AS 'Approved for Short-Term Post-Hospitalization Housing',
CASE 
WHEN asr.codeid = 'T2033' 
	AND (modcode IN ('U6') OR modcode2 IN ('U6') OR modcode3 IN ('U6') OR modcode4 IN ('U6') OR modcode5 IN ('U6')) 
THEN '1'
	ELSE '0'
END AS 'Approved for Recuperative Care',
CASE 
WHEN asr.codeid IN ('H0045','S5151','S9125') 
	AND (modcode IN ('U6') OR modcode2 IN ('U6') OR modcode3 IN ('U6') OR modcode4 IN ('U6') OR modcode5 IN ('U6')) 
THEN '1'	
	ELSE '0'
END AS 'Approved for Respite Services',
CASE 
WHEN asr.codeid IN ('T2012','T2014','T2018','T2020','H2014','H2038','H2024','H2026') 
	AND (modcode IN ('U6') OR modcode2 IN ('U6') OR modcode3 IN ('U6') OR modcode4 IN ('U6') OR modcode5 IN ('U6')) 
THEN '1'
	ELSE '0'
END AS 'Approved for Day Habilitation Programs',
CASE 
WHEN asr.codeid = 'T2038' 
	AND (modcode IN ('U4') OR modcode2 IN ('U4') OR modcode3 IN ('U4') OR modcode4 IN ('U4') OR modcode5 IN ('U4')) 
THEN '1'	
	
WHEN asr.codeid = 'H2022' 
	AND (modcode IN ('U5') OR modcode2 IN ('U5') OR modcode3 IN ('U5') OR modcode4 IN ('U5') OR modcode5 IN ('U5')) 
THEN '1'	
	ELSE '0'
END AS 'Approved for NF Transition to ALF',
CASE 
WHEN asr.codeid = 'T2038' 
	AND (modcode IN ('U5') OR modcode2 IN ('U5') OR modcode3 IN ('U5') OR modcode4 IN ('U5') OR modcode5 IN ('U5')) 
THEN '1'
WHEN asr.codeid = 'H0044' -- M003: DHCS v1.3 Jan 2026 ~ Community or Home Transition Non-Recurring Set-Up Expenses (Updated January 2026)
	AND (modcode IN ('U5') OR modcode2 IN ('U5') OR modcode3 IN ('U5') OR modcode4 IN ('U5') OR modcode5 IN ('U5'))
THEN '1'
	ELSE '0'
END AS 'Approved for NF Transition to a Home',
CASE 
WHEN asr.codeid IN ('S5130','T1019') 
	AND (modcode IN ('U6') OR modcode2 IN ('U6') OR modcode3 IN ('U6') OR modcode4 IN ('U6') OR modcode5 IN ('U6')) 
THEN '1'
	ELSE '0'
END AS 'Approved for Personal Care and Homemaker Services',
CASE 
WHEN asr.codeid = 'S5165' 
	AND (modcode IN ('U6') OR modcode2 IN ('U6') OR modcode3 IN ('U6') OR modcode4 IN ('U6') OR modcode5 IN ('U6')) 
THEN '1'
	ELSE '0'
END AS 'Approved for Environmental Accessibility Adaptations',
CASE 
WHEN asr.codeid IN ('S5170','S9470','S9977') 
	AND (modcode IN ('U6') OR modcode2 IN ('U6') OR modcode3 IN ('U6') OR modcode4 IN ('U6') OR modcode5 IN ('U6'))
THEN '1'
WHEN asr.codeid = 'S9452' -- M003: DHCS v1.3 Jan 2026 ~ Nutrition Education Individual (U5) and Group (U6) sessions
	AND (modcode IN ('U5','U6') OR modcode2 IN ('U5','U6') OR modcode3 IN ('U5','U6') OR modcode4 IN ('U5','U6') OR modcode5 IN ('U5','U6'))
THEN '1'
WHEN asr.codeid = 'S9977' -- M003: DHCS v1.3 Jan 2026 ~ Produce Rx Box (U4), Produce Rx Retail (U5), Medically Supportive Groceries (U7), Food Pharmacy (U8), Healthy Food Vouchers (U9)
	AND (modcode IN ('U4','U5','U7','U8','U9') OR modcode2 IN ('U4','U5','U7','U8','U9') OR modcode3 IN ('U4','U5','U7','U8','U9') OR modcode4 IN ('U4','U5','U7','U8','U9') OR modcode5 IN ('U4','U5','U7','U8','U9'))
THEN '1'
	ELSE '0'
END AS 'Approved for Medically-Supportive Food',
CASE 
WHEN asr.codeid = 'H0014' 
	AND (modcode IN ('U6') OR modcode2 IN ('U6') OR modcode3 IN ('U6') OR modcode4 IN ('U6') OR modcode5 IN ('U6')) 
THEN '1'
	ELSE '0'
END AS 'Approved for Sobering Centers',
CASE 
WHEN asr.codeid = 'S5165' 
	AND (modcode IN ('U5') OR modcode2 IN ('U5') OR modcode3 IN ('U5') OR modcode4 IN ('U5') OR modcode5 IN ('U5')) 
THEN '1'	
	ELSE '0'
END AS 'Approved for Asthma Remediation',
-- '0' AS 'Approved for Transitional Rent', -- C004: PLACEHOLDER PENDING SPECIFIC LOGIC FOR: Approved for Transitional Rent'  AS OF 2025123 - LEVERAGE: "UPDATED ECM-CS Quarterly Reports Narrative 9.9.25.docx"
CASE 
WHEN SUBSTRING(UPPER(LTRIM(RTRIM(ISNULL(asr.codeid,'')))),1,5) IN ('H0040') 
	AND (modcode IN ('U1') OR modcode2 IN ('U1') OR modcode3 IN ('U1') OR modcode4 IN ('U1') OR modcode5 IN ('U1')) 
THEN '1'
WHEN SUBSTRING(UPPER(LTRIM(RTRIM(ISNULL(asr.codeid,'')))),1,5) IN ('H0040','H0043') 
	AND (modcode IN ('U2') OR modcode2 IN ('U2') OR modcode3 IN ('U2') OR modcode4 IN ('U2') OR modcode5 IN ('U2')) 
THEN '1'
WHEN SUBSTRING(UPPER(LTRIM(RTRIM(ISNULL(asr.codeid,'')))),1,5) IN ('H0044') 
	AND (modcode IN ('U6') OR modcode2 IN ('U6') OR modcode3 IN ('U6') OR modcode4 IN ('U6') OR modcode5 IN ('U6')) 
THEN '1'
ELSE '0'
END AS 'Approved for Transitional Rent', -- M002: CORRECTED ~ stale C004 hardcoded '0' replaced with full C006 logic ~ UNION branch 2 (RCU01) now aligned with UNION branch 1 (css)
CASE 
WHEN asr.codeid = 'T1016' -- M003: DHCS v1.3 Jan 2026 mandatory outreach encounter codes ~ PACES submission required; MCP reimbursement optional per DHCS pg 18-20
	AND (modcode IN ('U8') OR modcode2 IN ('U8') OR modcode3 IN ('U8') OR modcode4 IN ('U8') OR modcode5 IN ('U8'))
THEN '1'
	ELSE '0'
END AS 'Approved for Housing Outreach - Initiation', -- M003: T1016+U8 (in-person) and T1016+U8+GQ (telephonic/electronic) ~ both successful and unsuccessful outreach ~ Housing Transition/Navigation, Housing Deposits, Housing Tenancy and Sustaining Services
CASE 
WHEN asr.codeid IS NOT NULL -- M001: CORRECTED FROM asr.codeid <> NULL ~ <> NULL always evaluates to UNKNOWN in T-SQL, never TRUE
THEN '1'
	ELSE '0'
END AS 'Approved for Other Services',
CASE 
WHEN bp.LINE_OF_BUSINESS IN ('MEDI-CAL') 
THEN 'Medi-Cal'
WHEN bp.LINE_OF_BUSINESS LIKE '%IV%'
THEN 'CHPIV DSNP'
WHEN bp.LINE_OF_BUSINESS LIKE '%CMC%'
THEN 'CMC'
WHEN bp.LINE_OF_BUSINESS LIKE '%DSNP%'
THEN 'DSNP'
ELSE 'Unknown'
END AS [LineofBusiness],
Glembocki.claimid, -- C005: ... Now we will only be reporting "received service" if there was a claim during that specific quarter, that validates that the member received the service. "Approved for" remains the same. I will submit to informatics after it gets approved in the reports meeting. - LEVERAGE: "UPDATED ECM-CS Quarterly Reports Narrative 11-10-2025.docx"
r.authorizationid
FROM HMOPROD_PlanData.dbo.member AS m
	INNER JOIN HMOPROD_PlanData.dbo.referral AS r ON r.memid = m.memid
	INNER JOIN HMOPROD_PLANDATA.dbo.authservice AS asr ON asr.referralid = r.referralid
	INNER JOIN HMOPROD_PLANDATA.dbo.entity AS e ON m.entityid = e.entid
	INNER JOIN HMOPROD_PLANDATA.dbo.enrollkeys AS ek ON ek.enrollid = r.enrollid
	INNER JOIN INFORMATICS.dbo.[uvw_LINE_OF_BUSINESS] AS bp ON ek.planid = bp.planid		
		LEFT JOIN INFORMATICS.dbo.[uvw_AUTHREFCLAIM] AS  Glembocki ON r.referralid = Glembocki.referralid -- 'Claude.ai v Perplexity.ai ...  'c.referralid OR cd.referralid = ref.authorizationid DISCOVERED ON 20150728 w Stefan Glembocki' ... C005: ... Now we will only be reporting "received service" if there was a claim during that specific quarter, that validates that the member received the service. "Approved for" remains the same. I will submit to informatics after it gets approved in the reports meeting. - LEVERAGE: "UPDATED ECM-CS Quarterly Reports Narrative 11-10-2025.docx"
			AND r.authorizationid = Glembocki.authorizationid	
		LEFT JOIN HMOPROD_PlanData.dbo.svccode AS svc ON svc.codeid = asr.codeid
WHERE 1=1
	AND r.servicecode = 'RCU01'
	AND r.status = 'approved'
	AND r.authstatus = 'approved'
	AND asr.status = 'approved'
	AND CAST(CONVERT(datetime2,(r.UtcReceiptDate at time zone 'UTC') at time zone 'Pacific Standard Time') AS date) BETWEEN @CSClockStart AND @CSClockStop -- Coordinated Universal Time or UTC is the primary time standard globally used to regulate clocks AND time. It establishes a reference for the current time, forming the basis for civil time AND time zones. UTC facilitates international communication, navigation, scientific research, AND commerce. ... ADHOC REQUEST per eMAIL FROM MS NATALIA ON 20221115 '... We need to run a report through AuthScans for Auth Scan Report for EYECARE OF SAN DIEGO/Provider ID: 313124 ...'
	-- AND ek.programid IN ('QMXHPQ0842','QMXHPQ0847','QMXHPQ0848','QMXHPQ0850','QMXHPQ0851')
	AND asr.codeid = 'T2033' 
	AND (modcode IN ('U6') 
		OR modcode2 IN ('U6') 
		OR modcode3 IN ('U6')
		OR modcode4 IN ('U6') 
		OR modcode5 IN ('U6')) 
	AND r.termdate >= r.effdate -- MUST BE TRUE ... NON-CROSSFOOTED RECORDS ARE ACTIVE ...

		SELECT ' ' AS 'QA TEST - CS (Community Supports) UM service approved:',* 
		FROM #CSPopAuths#
		WHERE 1=1
			AND memid IN ('2522812' -- NO CLAIM IN REPORTING PERIOD
			,'2669594' -- NO CLAIM IN REPORTING PERIOD
			,'2569142' -- YES CLAIM IN REPORTING PERIOD
			,'2466721' -- YES CLAIM IN REPORTING PERIOD
			,'1062706') -- YES CLAIM IN REPORTING PERIOD
				OR authorizationid IN ('4746737')

		/* SELECT ' ' AS 'QA - TEST RESULT(S):',* 
		FROM INFORMATICS.dbo.uvw_BASELINE_MEMBERSHIP
		WHERE 1=1
			AND CIN IN ('92332490D' -- NO CLAIM IN REPORTING PERIOD
			,'95801651E' -- NO CLAIM IN REPORTING PERIOD
			,'90533621H' -- YES CLAIM IN REPORTING PERIOD
			,'97454745C' -- YES CLAIM IN REPORTING PERIOD
			,'93436183A') -- YES CLAIM IN REPORTING PERIOD */







-- =====================================================================
	-- CS (Community Supports) FINALIZE OUTPUT: 
-- =====================================================================
SELECT DISTINCT 'Community Health Group Partnership Plan' AS 'Plan Name'
,'029' AS 'Plan Code'
,'San Diego' AS 'County'
,TRY_CONVERT(varchar(4),DATEPART(yyyy,@CSClockStart))+' Q'+TRY_CONVERT(varchar(2),DATEPART(q,@CSClockStart)) AS [Reporting Period] --'2022 Q2' AS 'Reporting Period','2023 Q3' AS 'Reporting Period',
,pop.memid
,bm.CIN AS 'Member CIN'
,bm.[Member Last Name]
,bm.[Member First Name]
,CONVERT(varchar(10),CAST(bm.dob AS date),101) AS 'Member Date of Birth'
INTO #baseline
FROM INFORMATICS.dbo.uvw_BASELINE_MEMBERSHIP AS bm
	INNER JOIN 
	( -- INITIATE ...
	SELECT memid 
	FROM #CSPopClaims#
	GROUP BY memid
	
	UNION 
	SELECT memid 
	FROM #CSPopAuths#
	GROUP BY memid
	) -- CONCLUDE ...
	AS pop ON bm.memid = pop.memid

		SELECT ' ' AS 'SET #BASELINE POP: ',* FROM #baseline
 
SELECT DISTINCT b.*
,ISNULL(CSC.[Member received Community Supports Services],'0') AS 'Member received Community Supports Services'
/* APPROVED = AUTHS */
,CASE
WHEN EXISTS ( -- DEFINITIVE ANSWER: Returns TRUE the moment SQL Server finds EVEN ONE MATCHING ROW IN THE SUBQUERY. It immediately stops scanning -- it does not count rows, does not return data, just confirms presence. This is why SELECT 1 is used -- the actual column value is irrelevant. -- IN PLAIN LANGUAGE: "DOES AT LEAST ONE ROW EXIST IN #PROVISOLATION where the provider ID matches?" ... NOT EXISTS(): EXACT LOGICAL INVERSE. Returns TRUE only WHEN THE SUBQUERY FINDS ZERO MATCHING ROWS. It is the correct, sargable, SQL-idiomatic way to express "exclude any claim whose provider appears in this list." It is semantically equivalent to a LEFT JOIN ... WHERE joined_table.key IS NULL anti-join pattern, but often cleaner and more readable.
SELECT 1 
FROM #CSPopAuths# AS ecsa
WHERE 1=1 
	AND b.memid = ecsa.memid -- KEY ON ...
	AND [Approved for Housing Transition/ Navigation Services] = '1') -- M003: NORMALIZED SUBQUERY REFERENCE (slash+space) ~ consistent with temp table column alias
THEN '1' ELSE '0'
END AS 'Approved for Housing Transition/ Navigation Services' -- M003: NORMALIZED OUTPUT ALIAS (slash+space)
,CASE
WHEN EXISTS ( -- DEFINITIVE ANSWER: Returns TRUE the moment SQL Server finds EVEN ONE MATCHING ROW IN THE SUBQUERY. It immediately stops scanning -- it does not count rows, does not return data, just confirms presence. This is why SELECT 1 is used -- the actual column value is irrelevant. -- IN PLAIN LANGUAGE: "DOES AT LEAST ONE ROW EXIST IN #PROVISOLATION where the provider ID matches?" ... NOT EXISTS(): EXACT LOGICAL INVERSE. Returns TRUE only WHEN THE SUBQUERY FINDS ZERO MATCHING ROWS. It is the correct, sargable, SQL-idiomatic way to express "exclude any claim whose provider appears in this list." It is semantically equivalent to a LEFT JOIN ... WHERE joined_table.key IS NULL anti-join pattern, but often cleaner and more readable.
SELECT 1 
FROM #CSPopAuths# AS ecsa
WHERE 1=1 
	AND b.memid = ecsa.memid -- KEY ON ...
	AND [Approved for Housing Deposits] = '1')
THEN '1' ELSE '0'
END AS 'Approved for Housing Deposits'
,CASE
WHEN EXISTS ( -- DEFINITIVE ANSWER: Returns TRUE the moment SQL Server finds EVEN ONE MATCHING ROW IN THE SUBQUERY. It immediately stops scanning -- it does not count rows, does not return data, just confirms presence. This is why SELECT 1 is used -- the actual column value is irrelevant. -- IN PLAIN LANGUAGE: "DOES AT LEAST ONE ROW EXIST IN #PROVISOLATION where the provider ID matches?" ... NOT EXISTS(): EXACT LOGICAL INVERSE. Returns TRUE only WHEN THE SUBQUERY FINDS ZERO MATCHING ROWS. It is the correct, sargable, SQL-idiomatic way to express "exclude any claim whose provider appears in this list." It is semantically equivalent to a LEFT JOIN ... WHERE joined_table.key IS NULL anti-join pattern, but often cleaner and more readable.
SELECT 1 
FROM #CSPopAuths# AS ecsa
WHERE 1=1 
	AND b.memid = ecsa.memid -- KEY ON ...
	AND [Approved for Housing Tenancy and Sustaining Services] = '1')
THEN '1' ELSE '0'
END AS 'Approved for Housing Tenancy and Sustaining Services'
,CASE
WHEN EXISTS ( -- DEFINITIVE ANSWER: Returns TRUE the moment SQL Server finds EVEN ONE MATCHING ROW IN THE SUBQUERY. It immediately stops scanning -- it does not count rows, does not return data, just confirms presence. This is why SELECT 1 is used -- the actual column value is irrelevant. -- IN PLAIN LANGUAGE: "DOES AT LEAST ONE ROW EXIST IN #PROVISOLATION where the provider ID matches?" ... NOT EXISTS(): EXACT LOGICAL INVERSE. Returns TRUE only WHEN THE SUBQUERY FINDS ZERO MATCHING ROWS. It is the correct, sargable, SQL-idiomatic way to express "exclude any claim whose provider appears in this list." It is semantically equivalent to a LEFT JOIN ... WHERE joined_table.key IS NULL anti-join pattern, but often cleaner and more readable.
SELECT 1 
FROM #CSPopAuths# AS ecsa
WHERE 1=1 
	AND b.memid = ecsa.memid -- KEY ON ...
	AND [Approved for Short-Term Post-Hospitalization Housing] = '1')
THEN '1' ELSE '0'
END AS 'Approved for Short-Term Post-Hospitalization Housing'
,CASE
WHEN EXISTS ( -- DEFINITIVE ANSWER: Returns TRUE the moment SQL Server finds EVEN ONE MATCHING ROW IN THE SUBQUERY. It immediately stops scanning -- it does not count rows, does not return data, just confirms presence. This is why SELECT 1 is used -- the actual column value is irrelevant. -- IN PLAIN LANGUAGE: "DOES AT LEAST ONE ROW EXIST IN #PROVISOLATION where the provider ID matches?" ... NOT EXISTS(): EXACT LOGICAL INVERSE. Returns TRUE only WHEN THE SUBQUERY FINDS ZERO MATCHING ROWS. It is the correct, sargable, SQL-idiomatic way to express "exclude any claim whose provider appears in this list." It is semantically equivalent to a LEFT JOIN ... WHERE joined_table.key IS NULL anti-join pattern, but often cleaner and more readable.
SELECT 1 
FROM #CSPopAuths# AS ecsa
WHERE 1=1 
	AND b.memid = ecsa.memid -- KEY ON ...
	AND [Approved for Recuperative Care] = '1')
THEN '1' ELSE '0'
END AS 'Approved for Recuperative Care'
,CASE
WHEN EXISTS ( -- DEFINITIVE ANSWER: Returns TRUE the moment SQL Server finds EVEN ONE MATCHING ROW IN THE SUBQUERY. It immediately stops scanning -- it does not count rows, does not return data, just confirms presence. This is why SELECT 1 is used -- the actual column value is irrelevant. -- IN PLAIN LANGUAGE: "DOES AT LEAST ONE ROW EXIST IN #PROVISOLATION where the provider ID matches?" ... NOT EXISTS(): EXACT LOGICAL INVERSE. Returns TRUE only WHEN THE SUBQUERY FINDS ZERO MATCHING ROWS. It is the correct, sargable, SQL-idiomatic way to express "exclude any claim whose provider appears in this list." It is semantically equivalent to a LEFT JOIN ... WHERE joined_table.key IS NULL anti-join pattern, but often cleaner and more readable.
SELECT 1 
FROM #CSPopAuths# AS ecsa
WHERE 1=1 
	AND b.memid = ecsa.memid -- KEY ON ...
	AND [Approved for Respite Services] = '1')
THEN '1' ELSE '0'
END AS 'Approved for Respite Services'
,CASE
WHEN EXISTS ( -- DEFINITIVE ANSWER: Returns TRUE the moment SQL Server finds EVEN ONE MATCHING ROW IN THE SUBQUERY. It immediately stops scanning -- it does not count rows, does not return data, just confirms presence. This is why SELECT 1 is used -- the actual column value is irrelevant. -- IN PLAIN LANGUAGE: "DOES AT LEAST ONE ROW EXIST IN #PROVISOLATION where the provider ID matches?" ... NOT EXISTS(): EXACT LOGICAL INVERSE. Returns TRUE only WHEN THE SUBQUERY FINDS ZERO MATCHING ROWS. It is the correct, sargable, SQL-idiomatic way to express "exclude any claim whose provider appears in this list." It is semantically equivalent to a LEFT JOIN ... WHERE joined_table.key IS NULL anti-join pattern, but often cleaner and more readable.
SELECT 1 
FROM #CSPopAuths# AS ecsa
WHERE 1=1 
	AND b.memid = ecsa.memid -- KEY ON ...
	AND [Approved for Day Habilitation Programs] = '1')
THEN '1' ELSE '0'
END AS 'Approved for Day Habilitation Programs'
,CASE
WHEN EXISTS ( -- DEFINITIVE ANSWER: Returns TRUE the moment SQL Server finds EVEN ONE MATCHING ROW IN THE SUBQUERY. It immediately stops scanning -- it does not count rows, does not return data, just confirms presence. This is why SELECT 1 is used -- the actual column value is irrelevant. -- IN PLAIN LANGUAGE: "DOES AT LEAST ONE ROW EXIST IN #PROVISOLATION where the provider ID matches?" ... NOT EXISTS(): EXACT LOGICAL INVERSE. Returns TRUE only WHEN THE SUBQUERY FINDS ZERO MATCHING ROWS. It is the correct, sargable, SQL-idiomatic way to express "exclude any claim whose provider appears in this list." It is semantically equivalent to a LEFT JOIN ... WHERE joined_table.key IS NULL anti-join pattern, but often cleaner and more readable.
SELECT 1 
FROM #CSPopAuths# AS ecsa
WHERE 1=1 
	AND b.memid = ecsa.memid -- KEY ON ...
	AND [Approved for NF Transition to ALF] = '1')
THEN '1' ELSE '0'
END AS 'Approved for NF Transition to ALF'
,CASE
WHEN EXISTS ( -- DEFINITIVE ANSWER: Returns TRUE the moment SQL Server finds EVEN ONE MATCHING ROW IN THE SUBQUERY. It immediately stops scanning -- it does not count rows, does not return data, just confirms presence. This is why SELECT 1 is used -- the actual column value is irrelevant. -- IN PLAIN LANGUAGE: "DOES AT LEAST ONE ROW EXIST IN #PROVISOLATION where the provider ID matches?" ... NOT EXISTS(): EXACT LOGICAL INVERSE. Returns TRUE only WHEN THE SUBQUERY FINDS ZERO MATCHING ROWS. It is the correct, sargable, SQL-idiomatic way to express "exclude any claim whose provider appears in this list." It is semantically equivalent to a LEFT JOIN ... WHERE joined_table.key IS NULL anti-join pattern, but often cleaner and more readable.
SELECT 1 
FROM #CSPopAuths# AS ecsa
WHERE 1=1 
	AND b.memid = ecsa.memid -- KEY ON ...
	AND [Approved for NF Transition to a Home] = '1')
THEN '1' ELSE '0'
END AS 'Approved for NF Transition to a Home'
,CASE
WHEN EXISTS ( -- DEFINITIVE ANSWER: Returns TRUE the moment SQL Server finds EVEN ONE MATCHING ROW IN THE SUBQUERY. It immediately stops scanning -- it does not count rows, does not return data, just confirms presence. This is why SELECT 1 is used -- the actual column value is irrelevant. -- IN PLAIN LANGUAGE: "DOES AT LEAST ONE ROW EXIST IN #PROVISOLATION where the provider ID matches?" ... NOT EXISTS(): EXACT LOGICAL INVERSE. Returns TRUE only WHEN THE SUBQUERY FINDS ZERO MATCHING ROWS. It is the correct, sargable, SQL-idiomatic way to express "exclude any claim whose provider appears in this list." It is semantically equivalent to a LEFT JOIN ... WHERE joined_table.key IS NULL anti-join pattern, but often cleaner and more readable.
SELECT 1 
FROM #CSPopAuths# AS ecsa
WHERE 1=1 
	AND b.memid = ecsa.memid -- KEY ON ...
	AND [Approved for Personal Care and Homemaker Services] = '1')
THEN '1' ELSE '0'
END AS 'Approved for Personal Care and Homemaker Services'
,CASE
WHEN EXISTS ( -- DEFINITIVE ANSWER: Returns TRUE the moment SQL Server finds EVEN ONE MATCHING ROW IN THE SUBQUERY. It immediately stops scanning -- it does not count rows, does not return data, just confirms presence. This is why SELECT 1 is used -- the actual column value is irrelevant. -- IN PLAIN LANGUAGE: "DOES AT LEAST ONE ROW EXIST IN #PROVISOLATION where the provider ID matches?" ... NOT EXISTS(): EXACT LOGICAL INVERSE. Returns TRUE only WHEN THE SUBQUERY FINDS ZERO MATCHING ROWS. It is the correct, sargable, SQL-idiomatic way to express "exclude any claim whose provider appears in this list." It is semantically equivalent to a LEFT JOIN ... WHERE joined_table.key IS NULL anti-join pattern, but often cleaner and more readable.
SELECT 1 
FROM #CSPopAuths# AS ecsa
WHERE 1=1 
	AND b.memid = ecsa.memid -- KEY ON ...
	AND [Approved for Environmental Accessibility Adaptations] = '1')
THEN '1' ELSE '0'
END AS 'Approved for Environmental Accessibility Adaptations'
,CASE
WHEN EXISTS ( -- DEFINITIVE ANSWER: Returns TRUE the moment SQL Server finds EVEN ONE MATCHING ROW IN THE SUBQUERY. It immediately stops scanning -- it does not count rows, does not return data, just confirms presence. This is why SELECT 1 is used -- the actual column value is irrelevant. -- IN PLAIN LANGUAGE: "DOES AT LEAST ONE ROW EXIST IN #PROVISOLATION where the provider ID matches?" ... NOT EXISTS(): EXACT LOGICAL INVERSE. Returns TRUE only WHEN THE SUBQUERY FINDS ZERO MATCHING ROWS. It is the correct, sargable, SQL-idiomatic way to express "exclude any claim whose provider appears in this list." It is semantically equivalent to a LEFT JOIN ... WHERE joined_table.key IS NULL anti-join pattern, but often cleaner and more readable.
SELECT 1 
FROM #CSPopAuths# AS ecsa
WHERE 1=1 
	AND b.memid = ecsa.memid -- KEY ON ...
	AND [Approved for Medically-Supportive Food] = '1')
THEN '1' ELSE '0'
END AS 'Approved for Medically-Supportive Food'
,CASE
WHEN EXISTS ( -- DEFINITIVE ANSWER: Returns TRUE the moment SQL Server finds EVEN ONE MATCHING ROW IN THE SUBQUERY. It immediately stops scanning -- it does not count rows, does not return data, just confirms presence. This is why SELECT 1 is used -- the actual column value is irrelevant. -- IN PLAIN LANGUAGE: "DOES AT LEAST ONE ROW EXIST IN #PROVISOLATION where the provider ID matches?" ... NOT EXISTS(): EXACT LOGICAL INVERSE. Returns TRUE only WHEN THE SUBQUERY FINDS ZERO MATCHING ROWS. It is the correct, sargable, SQL-idiomatic way to express "exclude any claim whose provider appears in this list." It is semantically equivalent to a LEFT JOIN ... WHERE joined_table.key IS NULL anti-join pattern, but often cleaner and more readable.
SELECT 1 
FROM #CSPopAuths# AS ecsa
WHERE 1=1 
	AND b.memid = ecsa.memid -- KEY ON ...
	AND [Approved for Sobering Centers] = '1')
THEN '1' ELSE '0'
END AS 'Approved for Sobering Centers'
,CASE
WHEN EXISTS ( -- DEFINITIVE ANSWER: Returns TRUE the moment SQL Server finds EVEN ONE MATCHING ROW IN THE SUBQUERY. It immediately stops scanning -- it does not count rows, does not return data, just confirms presence. This is why SELECT 1 is used -- the actual column value is irrelevant. -- IN PLAIN LANGUAGE: "DOES AT LEAST ONE ROW EXIST IN #PROVISOLATION where the provider ID matches?" ... NOT EXISTS(): EXACT LOGICAL INVERSE. Returns TRUE only WHEN THE SUBQUERY FINDS ZERO MATCHING ROWS. It is the correct, sargable, SQL-idiomatic way to express "exclude any claim whose provider appears in this list." It is semantically equivalent to a LEFT JOIN ... WHERE joined_table.key IS NULL anti-join pattern, but often cleaner and more readable.
SELECT 1 
FROM #CSPopAuths# AS ecsa
WHERE 1=1 
	AND b.memid = ecsa.memid -- KEY ON ...
	AND [Approved for Asthma Remediation] = '1')
THEN '1' ELSE '0'
END AS 'Approved for Asthma Remediation'
,CASE
WHEN EXISTS ( -- DEFINITIVE ANSWER: Returns TRUE the moment SQL Server finds EVEN ONE MATCHING ROW IN THE SUBQUERY. It immediately stops scanning -- it does not count rows, does not return data, just confirms presence. This is why SELECT 1 is used -- the actual column value is irrelevant. -- IN PLAIN LANGUAGE: "DOES AT LEAST ONE ROW EXIST IN #PROVISOLATION where the provider ID matches?" ... NOT EXISTS(): EXACT LOGICAL INVERSE. Returns TRUE only WHEN THE SUBQUERY FINDS ZERO MATCHING ROWS. It is the correct, sargable, SQL-idiomatic way to express "exclude any claim whose provider appears in this list." It is semantically equivalent to a LEFT JOIN ... WHERE joined_table.key IS NULL anti-join pattern, but often cleaner and more readable.
SELECT 1 
FROM #CSPopAuths# AS ecsa
WHERE 1=1 
	AND b.memid = ecsa.memid -- KEY ON ...
	AND [Approved for Transitional Rent] = '1')
THEN '1' ELSE '0'
END AS 'Approved for Transitional Rent' -- M001: C004 comment retired ~ Transitional Rent now fully implemented via C006 in both UNION branches
,CASE
WHEN EXISTS ( -- DEFINITIVE ANSWER: Returns TRUE the moment SQL Server finds EVEN ONE MATCHING ROW IN THE SUBQUERY. It immediately stops scanning -- it does not count rows, does not return data, just confirms presence. This is why SELECT 1 is used -- the actual column value is irrelevant. -- IN PLAIN LANGUAGE: "DOES AT LEAST ONE ROW EXIST IN #PROVISOLATION where the provider ID matches?" ... NOT EXISTS(): EXACT LOGICAL INVERSE. Returns TRUE only WHEN THE SUBQUERY FINDS ZERO MATCHING ROWS. It is the correct, sargable, SQL-idiomatic way to express "exclude any claim whose provider appears in this list." It is semantically equivalent to a LEFT JOIN ... WHERE joined_table.key IS NULL anti-join pattern, but often cleaner and more readable.
SELECT 1 
FROM #CSPopAuths# AS ecsa
WHERE 1=1 
	AND b.memid = ecsa.memid -- KEY ON ...
	AND [Approved for Housing Outreach - Initiation] = '1')
THEN '1' ELSE '0'
END AS 'Approved for Housing Outreach - Initiation' -- M005: T1016+U8 mandatory PACES encounter codes (DHCS v1.3 Jan 2026) 
,CASE
WHEN EXISTS ( -- DEFINITIVE ANSWER: Returns TRUE the moment SQL Server finds EVEN ONE MATCHING ROW IN THE SUBQUERY. It immediately stops scanning -- it does not count rows, does not return data, just confirms presence. This is why SELECT 1 is used -- the actual column value is irrelevant. -- IN PLAIN LANGUAGE: "DOES AT LEAST ONE ROW EXIST IN #PROVISOLATION where the provider ID matches?" ... NOT EXISTS(): EXACT LOGICAL INVERSE. Returns TRUE only WHEN THE SUBQUERY FINDS ZERO MATCHING ROWS. It is the correct, sargable, SQL-idiomatic way to express "exclude any claim whose provider appears in this list." It is semantically equivalent to a LEFT JOIN ... WHERE joined_table.key IS NULL anti-join pattern, but often cleaner and more readable.
SELECT 1 
FROM #CSPopAuths# AS ecsa
WHERE 1=1 
	AND b.memid = ecsa.memid -- KEY ON ...
	AND [Approved for Other Services] = '1')
THEN '1' ELSE '0'
END AS 'Approved for Other Services'
/* RECEIVED = CLAIMS */
,CASE
WHEN EXISTS ( -- DEFINITIVE ANSWER: Returns TRUE the moment SQL Server finds EVEN ONE MATCHING ROW IN THE SUBQUERY. It immediately stops scanning -- it does not count rows, does not return data, just confirms presence. This is why SELECT 1 is used -- the actual column value is irrelevant. -- IN PLAIN LANGUAGE: "DOES AT LEAST ONE ROW EXIST IN #PROVISOLATION where the provider ID matches?" ... NOT EXISTS(): EXACT LOGICAL INVERSE. Returns TRUE only WHEN THE SUBQUERY FINDS ZERO MATCHING ROWS. It is the correct, sargable, SQL-idiomatic way to express "exclude any claim whose provider appears in this list." It is semantically equivalent to a LEFT JOIN ... WHERE joined_table.key IS NULL anti-join pattern, but often cleaner and more readable.
SELECT 1 
FROM #CSPopClaims# AS ecsc
WHERE 1=1 
	AND b.memid = ecsc.memid -- KEY ON ...
	AND [Received Housing Transition/ Navigation Services] = '1') -- M003: NORMALIZED SUBQUERY REFERENCE (slash+space) ~ consistent with temp table column alias
THEN '1' ELSE '0'
END AS 'Received Housing Transition/ Navigation Services' -- M003: NORMALIZED OUTPUT ALIAS (slash+space)
,CASE
WHEN EXISTS ( -- DEFINITIVE ANSWER: Returns TRUE the moment SQL Server finds EVEN ONE MATCHING ROW IN THE SUBQUERY. It immediately stops scanning -- it does not count rows, does not return data, just confirms presence. This is why SELECT 1 is used -- the actual column value is irrelevant. -- IN PLAIN LANGUAGE: "DOES AT LEAST ONE ROW EXIST IN #PROVISOLATION where the provider ID matches?" ... NOT EXISTS(): EXACT LOGICAL INVERSE. Returns TRUE only WHEN THE SUBQUERY FINDS ZERO MATCHING ROWS. It is the correct, sargable, SQL-idiomatic way to express "exclude any claim whose provider appears in this list." It is semantically equivalent to a LEFT JOIN ... WHERE joined_table.key IS NULL anti-join pattern, but often cleaner and more readable.
SELECT 1 
FROM #CSPopClaims# AS ecsc
WHERE 1=1 
	AND b.memid = ecsc.memid -- KEY ON ...
	AND [Received Housing Deposits] = '1')
THEN '1' ELSE '0'
END AS 'Received Housing Deposits'
,CASE
WHEN EXISTS ( -- DEFINITIVE ANSWER: Returns TRUE the moment SQL Server finds EVEN ONE MATCHING ROW IN THE SUBQUERY. It immediately stops scanning -- it does not count rows, does not return data, just confirms presence. This is why SELECT 1 is used -- the actual column value is irrelevant. -- IN PLAIN LANGUAGE: "DOES AT LEAST ONE ROW EXIST IN #PROVISOLATION where the provider ID matches?" ... NOT EXISTS(): EXACT LOGICAL INVERSE. Returns TRUE only WHEN THE SUBQUERY FINDS ZERO MATCHING ROWS. It is the correct, sargable, SQL-idiomatic way to express "exclude any claim whose provider appears in this list." It is semantically equivalent to a LEFT JOIN ... WHERE joined_table.key IS NULL anti-join pattern, but often cleaner and more readable.
SELECT 1 
FROM #CSPopClaims# AS ecsc
WHERE 1=1 
	AND b.memid = ecsc.memid -- KEY ON ...
	AND [Received Housing Tenancy and Sustaining Services] = '1')
THEN '1' ELSE '0'
END AS 'Received Housing Tenancy and Sustaining Services'
,CASE
WHEN EXISTS ( -- DEFINITIVE ANSWER: Returns TRUE the moment SQL Server finds EVEN ONE MATCHING ROW IN THE SUBQUERY. It immediately stops scanning -- it does not count rows, does not return data, just confirms presence. This is why SELECT 1 is used -- the actual column value is irrelevant. -- IN PLAIN LANGUAGE: "DOES AT LEAST ONE ROW EXIST IN #PROVISOLATION where the provider ID matches?" ... NOT EXISTS(): EXACT LOGICAL INVERSE. Returns TRUE only WHEN THE SUBQUERY FINDS ZERO MATCHING ROWS. It is the correct, sargable, SQL-idiomatic way to express "exclude any claim whose provider appears in this list." It is semantically equivalent to a LEFT JOIN ... WHERE joined_table.key IS NULL anti-join pattern, but often cleaner and more readable.
SELECT 1 
FROM #CSPopClaims# AS ecsc
WHERE 1=1 
	AND b.memid = ecsc.memid -- KEY ON ...
	AND [Received Short-Term Post-Hospitalization Housing] = '1')
THEN '1' ELSE '0'
END AS 'Received Short-Term Post-Hospitalization Housing'
,CASE
WHEN EXISTS ( -- DEFINITIVE ANSWER: Returns TRUE the moment SQL Server finds EVEN ONE MATCHING ROW IN THE SUBQUERY. It immediately stops scanning -- it does not count rows, does not return data, just confirms presence. This is why SELECT 1 is used -- the actual column value is irrelevant. -- IN PLAIN LANGUAGE: "DOES AT LEAST ONE ROW EXIST IN #PROVISOLATION where the provider ID matches?" ... NOT EXISTS(): EXACT LOGICAL INVERSE. Returns TRUE only WHEN THE SUBQUERY FINDS ZERO MATCHING ROWS. It is the correct, sargable, SQL-idiomatic way to express "exclude any claim whose provider appears in this list." It is semantically equivalent to a LEFT JOIN ... WHERE joined_table.key IS NULL anti-join pattern, but often cleaner and more readable.
SELECT 1 
FROM #CSPopClaims# AS ecsc
WHERE 1=1 
	AND b.memid = ecsc.memid -- KEY ON ...
	AND [Received Recuperative Care] = '1')
THEN '1' ELSE '0'
END AS 'Received Recuperative Care'
,CASE
WHEN EXISTS ( -- DEFINITIVE ANSWER: Returns TRUE the moment SQL Server finds EVEN ONE MATCHING ROW IN THE SUBQUERY. It immediately stops scanning -- it does not count rows, does not return data, just confirms presence. This is why SELECT 1 is used -- the actual column value is irrelevant. -- IN PLAIN LANGUAGE: "DOES AT LEAST ONE ROW EXIST IN #PROVISOLATION where the provider ID matches?" ... NOT EXISTS(): EXACT LOGICAL INVERSE. Returns TRUE only WHEN THE SUBQUERY FINDS ZERO MATCHING ROWS. It is the correct, sargable, SQL-idiomatic way to express "exclude any claim whose provider appears in this list." It is semantically equivalent to a LEFT JOIN ... WHERE joined_table.key IS NULL anti-join pattern, but often cleaner and more readable.
SELECT 1 
FROM #CSPopClaims# AS ecsc
WHERE 1=1 
	AND b.memid = ecsc.memid -- KEY ON ...
	AND [Received Respite Services] = '1')
THEN '1' ELSE '0'
END AS 'Received Respite Services'
,CASE
WHEN EXISTS ( -- DEFINITIVE ANSWER: Returns TRUE the moment SQL Server finds EVEN ONE MATCHING ROW IN THE SUBQUERY. It immediately stops scanning -- it does not count rows, does not return data, just confirms presence. This is why SELECT 1 is used -- the actual column value is irrelevant. -- IN PLAIN LANGUAGE: "DOES AT LEAST ONE ROW EXIST IN #PROVISOLATION where the provider ID matches?" ... NOT EXISTS(): EXACT LOGICAL INVERSE. Returns TRUE only WHEN THE SUBQUERY FINDS ZERO MATCHING ROWS. It is the correct, sargable, SQL-idiomatic way to express "exclude any claim whose provider appears in this list." It is semantically equivalent to a LEFT JOIN ... WHERE joined_table.key IS NULL anti-join pattern, but often cleaner and more readable.
SELECT 1 
FROM #CSPopClaims# AS ecsc
WHERE 1=1 
	AND b.memid = ecsc.memid -- KEY ON ...
	AND [Received Day Habilitation Programs] = '1')
THEN '1' ELSE '0'
END AS 'Received Day Habilitation Programs'
,CASE
WHEN EXISTS ( -- DEFINITIVE ANSWER: Returns TRUE the moment SQL Server finds EVEN ONE MATCHING ROW IN THE SUBQUERY. It immediately stops scanning -- it does not count rows, does not return data, just confirms presence. This is why SELECT 1 is used -- the actual column value is irrelevant. -- IN PLAIN LANGUAGE: "DOES AT LEAST ONE ROW EXIST IN #PROVISOLATION where the provider ID matches?" ... NOT EXISTS(): EXACT LOGICAL INVERSE. Returns TRUE only WHEN THE SUBQUERY FINDS ZERO MATCHING ROWS. It is the correct, sargable, SQL-idiomatic way to express "exclude any claim whose provider appears in this list." It is semantically equivalent to a LEFT JOIN ... WHERE joined_table.key IS NULL anti-join pattern, but often cleaner and more readable.
SELECT 1 
FROM #CSPopClaims# AS ecsc
WHERE 1=1 
	AND b.memid = ecsc.memid -- KEY ON ...
	AND [Received NF Transition to ALF] = '1')
THEN '1' ELSE '0'
END AS 'Received NF Transition to ALF'
,CASE
WHEN EXISTS ( -- DEFINITIVE ANSWER: Returns TRUE the moment SQL Server finds EVEN ONE MATCHING ROW IN THE SUBQUERY. It immediately stops scanning -- it does not count rows, does not return data, just confirms presence. This is why SELECT 1 is used -- the actual column value is irrelevant. -- IN PLAIN LANGUAGE: "DOES AT LEAST ONE ROW EXIST IN #PROVISOLATION where the provider ID matches?" ... NOT EXISTS(): EXACT LOGICAL INVERSE. Returns TRUE only WHEN THE SUBQUERY FINDS ZERO MATCHING ROWS. It is the correct, sargable, SQL-idiomatic way to express "exclude any claim whose provider appears in this list." It is semantically equivalent to a LEFT JOIN ... WHERE joined_table.key IS NULL anti-join pattern, but often cleaner and more readable.
SELECT 1 
FROM #CSPopClaims# AS ecsc
WHERE 1=1 
	AND b.memid = ecsc.memid -- KEY ON ...
	AND [Received NF Transition to a Home] = '1')
THEN '1' ELSE '0'
END AS 'Received NF Transition to a Home'
,CASE
WHEN EXISTS ( -- DEFINITIVE ANSWER: Returns TRUE the moment SQL Server finds EVEN ONE MATCHING ROW IN THE SUBQUERY. It immediately stops scanning -- it does not count rows, does not return data, just confirms presence. This is why SELECT 1 is used -- the actual column value is irrelevant. -- IN PLAIN LANGUAGE: "DOES AT LEAST ONE ROW EXIST IN #PROVISOLATION where the provider ID matches?" ... NOT EXISTS(): EXACT LOGICAL INVERSE. Returns TRUE only WHEN THE SUBQUERY FINDS ZERO MATCHING ROWS. It is the correct, sargable, SQL-idiomatic way to express "exclude any claim whose provider appears in this list." It is semantically equivalent to a LEFT JOIN ... WHERE joined_table.key IS NULL anti-join pattern, but often cleaner and more readable.
SELECT 1 
FROM #CSPopClaims# AS ecsc
WHERE 1=1 
	AND b.memid = ecsc.memid -- KEY ON ...
	AND [Received Personal Care and Homemaker Services] = '1')
THEN '1' ELSE '0'
END AS 'Received Personal Care and Homemaker Services'
,CASE
WHEN EXISTS ( -- DEFINITIVE ANSWER: Returns TRUE the moment SQL Server finds EVEN ONE MATCHING ROW IN THE SUBQUERY. It immediately stops scanning -- it does not count rows, does not return data, just confirms presence. This is why SELECT 1 is used -- the actual column value is irrelevant. -- IN PLAIN LANGUAGE: "DOES AT LEAST ONE ROW EXIST IN #PROVISOLATION where the provider ID matches?" ... NOT EXISTS(): EXACT LOGICAL INVERSE. Returns TRUE only WHEN THE SUBQUERY FINDS ZERO MATCHING ROWS. It is the correct, sargable, SQL-idiomatic way to express "exclude any claim whose provider appears in this list." It is semantically equivalent to a LEFT JOIN ... WHERE joined_table.key IS NULL anti-join pattern, but often cleaner and more readable.
SELECT 1 
FROM #CSPopClaims# AS ecsc
WHERE 1=1 
	AND b.memid = ecsc.memid -- KEY ON ...
	AND [Received Environmental Accessibility Adaptations] = '1')
THEN '1' ELSE '0'
END AS 'Received Environmental Accessibility Adaptations'
,CASE
WHEN EXISTS ( -- DEFINITIVE ANSWER: Returns TRUE the moment SQL Server finds EVEN ONE MATCHING ROW IN THE SUBQUERY. It immediately stops scanning -- it does not count rows, does not return data, just confirms presence. This is why SELECT 1 is used -- the actual column value is irrelevant. -- IN PLAIN LANGUAGE: "DOES AT LEAST ONE ROW EXIST IN #PROVISOLATION where the provider ID matches?" ... NOT EXISTS(): EXACT LOGICAL INVERSE. Returns TRUE only WHEN THE SUBQUERY FINDS ZERO MATCHING ROWS. It is the correct, sargable, SQL-idiomatic way to express "exclude any claim whose provider appears in this list." It is semantically equivalent to a LEFT JOIN ... WHERE joined_table.key IS NULL anti-join pattern, but often cleaner and more readable.
SELECT 1 
FROM #CSPopClaims# AS ecsc
WHERE 1=1 
	AND b.memid = ecsc.memid -- KEY ON ...
	AND [Received Medically-Supportive Food] = '1')
THEN '1' ELSE '0'
END AS 'Received Medically-Supportive Food'
,CASE
WHEN EXISTS ( -- DEFINITIVE ANSWER: Returns TRUE the moment SQL Server finds EVEN ONE MATCHING ROW IN THE SUBQUERY. It immediately stops scanning -- it does not count rows, does not return data, just confirms presence. This is why SELECT 1 is used -- the actual column value is irrelevant. -- IN PLAIN LANGUAGE: "DOES AT LEAST ONE ROW EXIST IN #PROVISOLATION where the provider ID matches?" ... NOT EXISTS(): EXACT LOGICAL INVERSE. Returns TRUE only WHEN THE SUBQUERY FINDS ZERO MATCHING ROWS. It is the correct, sargable, SQL-idiomatic way to express "exclude any claim whose provider appears in this list." It is semantically equivalent to a LEFT JOIN ... WHERE joined_table.key IS NULL anti-join pattern, but often cleaner and more readable.
SELECT 1 
FROM #CSPopClaims# AS ecsc
WHERE 1=1 
	AND b.memid = ecsc.memid -- KEY ON ...
	AND [Received Sobering Centers] = '1')
THEN '1' ELSE '0'
END AS 'Received Sobering Centers'
,CASE
WHEN EXISTS ( -- DEFINITIVE ANSWER: Returns TRUE the moment SQL Server finds EVEN ONE MATCHING ROW IN THE SUBQUERY. It immediately stops scanning -- it does not count rows, does not return data, just confirms presence. This is why SELECT 1 is used -- the actual column value is irrelevant. -- IN PLAIN LANGUAGE: "DOES AT LEAST ONE ROW EXIST IN #PROVISOLATION where the provider ID matches?" ... NOT EXISTS(): EXACT LOGICAL INVERSE. Returns TRUE only WHEN THE SUBQUERY FINDS ZERO MATCHING ROWS. It is the correct, sargable, SQL-idiomatic way to express "exclude any claim whose provider appears in this list." It is semantically equivalent to a LEFT JOIN ... WHERE joined_table.key IS NULL anti-join pattern, but often cleaner and more readable.
SELECT 1 
FROM #CSPopClaims# AS ecsc
WHERE 1=1 
	AND b.memid = ecsc.memid -- KEY ON ...
	AND [Received Asthma Remediation] = '1')
THEN '1' ELSE '0'
END AS 'Received Asthma Remediation'
,CASE
WHEN EXISTS ( -- DEFINITIVE ANSWER: Returns TRUE the moment SQL Server finds EVEN ONE MATCHING ROW IN THE SUBQUERY. It immediately stops scanning -- it does not count rows, does not return data, just confirms presence. This is why SELECT 1 is used -- the actual column value is irrelevant. -- IN PLAIN LANGUAGE: "DOES AT LEAST ONE ROW EXIST IN #PROVISOLATION where the provider ID matches?" ... NOT EXISTS(): EXACT LOGICAL INVERSE. Returns TRUE only WHEN THE SUBQUERY FINDS ZERO MATCHING ROWS. It is the correct, sargable, SQL-idiomatic way to express "exclude any claim whose provider appears in this list." It is semantically equivalent to a LEFT JOIN ... WHERE joined_table.key IS NULL anti-join pattern, but often cleaner and more readable.
SELECT 1 
FROM #CSPopClaims# AS ecsc
WHERE 1=1 
	AND b.memid = ecsc.memid -- KEY ON ...
	AND [Received Transitional Rent] = '1')
THEN '1' ELSE '0'
END AS 'Received Transitional Rent' -- M001: C004 comment retired ~ Transitional Rent now fully implemented via C006
,CASE
WHEN EXISTS ( -- DEFINITIVE ANSWER: Returns TRUE the moment SQL Server finds EVEN ONE MATCHING ROW IN THE SUBQUERY. It immediately stops scanning -- it does not count rows, does not return data, just confirms presence. This is why SELECT 1 is used -- the actual column value is irrelevant. -- IN PLAIN LANGUAGE: "DOES AT LEAST ONE ROW EXIST IN #PROVISOLATION where the provider ID matches?" ... NOT EXISTS(): EXACT LOGICAL INVERSE. Returns TRUE only WHEN THE SUBQUERY FINDS ZERO MATCHING ROWS. It is the correct, sargable, SQL-idiomatic way to express "exclude any claim whose provider appears in this list." It is semantically equivalent to a LEFT JOIN ... WHERE joined_table.key IS NULL anti-join pattern, but often cleaner and more readable.
SELECT 1 
FROM #CSPopClaims# AS ecsc
WHERE 1=1 
	AND b.memid = ecsc.memid -- KEY ON ...
	AND [Received Housing Outreach - Initiation] = '1')
THEN '1' ELSE '0'
END AS 'Received Housing Outreach - Initiation' -- M005: T1016+U8 mandatory PACES encounter codes (DHCS v1.3 Jan 2026) 
,CASE
WHEN EXISTS ( -- DEFINITIVE ANSWER: Returns TRUE the moment SQL Server finds EVEN ONE MATCHING ROW IN THE SUBQUERY. It immediately stops scanning -- it does not count rows, does not return data, just confirms presence. This is why SELECT 1 is used -- the actual column value is irrelevant. -- IN PLAIN LANGUAGE: "DOES AT LEAST ONE ROW EXIST IN #PROVISOLATION where the provider ID matches?" ... NOT EXISTS(): EXACT LOGICAL INVERSE. Returns TRUE only WHEN THE SUBQUERY FINDS ZERO MATCHING ROWS. It is the correct, sargable, SQL-idiomatic way to express "exclude any claim whose provider appears in this list." It is semantically equivalent to a LEFT JOIN ... WHERE joined_table.key IS NULL anti-join pattern, but often cleaner and more readable.
SELECT 1 
FROM #CSPopClaims# AS ecsc
WHERE 1=1 
	AND b.memid = ecsc.memid -- KEY ON ...
	AND [Received Other Services] = '1')
THEN '1' ELSE '0'
END AS 'Received Other Services'
INTO #CSServices#
FROM #baseline AS b
	LEFT JOIN #CSPopClaims# AS CSC ON b.memid = CSC.memid
	-- LEFT JOIN #CSPopAuths# AS CSA ON b.memid = CSA.memid

SELECT DISTINCT CS.* -- FINALIZE OUTPUT FOR ECM / CS QUARTERLY REPORT AND ENSURE DEDUP()
INTO INFORMATICS.dbo.ECMCSQTRLY_TAB4
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st',
FROM #CSServices# AS CS

		SELECT ' ' AS 'TAB 4 FOUR REVIEW: ',* 
		FROM INFORMATICS.dbo.ECMCSQTRLY_TAB4 
		WHERE 1=1
			AND [Received Transitional Rent] = 1
				OR [Approved for Transitional Rent] = 1
		ORDER BY [Member Last Name];

-- ===========================================================================
	-- MS EXCEL OLE DB ODBC:
-- ===========================================================================
/* SELECT [Plan Name]
,[Plan Code]
,[County]
,[Reporting Period]
-- ,[memid]
,[Member CIN]
,[Member Last Name]
,[Member First Name]
,[Member Date of Birth]
,[Member received Community Supports Services]
,[Approved for Housing Transition/ Navigation Services] -- M004: normalized to slash+space
,[Approved for Housing Deposits]
,[Approved for Housing Tenancy and Sustaining Services]
,[Approved for Short-Term Post-Hospitalization Housing]
,[Approved for Recuperative Care]
,[Approved for Respite Services]
,[Approved for Day Habilitation Programs]
,[Approved for NF Transition to ALF]
,[Approved for NF Transition to a Home]
,[Approved for Personal Care and Homemaker Services]
,[Approved for Environmental Accessibility Adaptations]
,[Approved for Medically-Supportive Food]
,[Approved for Sobering Centers]
,[Approved for Asthma Remediation]
,[Approved for Transitional Rent]
-- ,[Approved for Housing Outreach - Initiation] -- M005: new column ~ T1016+U8 DHCS v1.3 Jan 2026
-- ,[Approved for Other Services]
,[Received Housing Transition/ Navigation Services] -- M004: normalized to slash+space
,[Received Housing Deposits]
,[Received Housing Tenancy and Sustaining Services]
,[Received Short-Term Post-Hospitalization Housing]
,[Received Recuperative Care]
,[Received Respite Services]
,[Received Day Habilitation Programs]
,[Received NF Transition to ALF]
,[Received NF Transition to a Home]
,[Received Personal Care and Homemaker Services]
,[Received Environmental Accessibility Adaptations]
,[Received Medically-Supportive Food]
,[Received Sobering Centers]
,[Received Asthma Remediation]
,[Received Transitional Rent]
-- ,[Received Housing Outreach - Initiation] -- M005: new column ~ T1016+U8 DHCS v1.3 Jan 2026
,[Received Other Services]
-- IN MS EXCEL Fx: =IF(COUNTIF(I5:AM5,1)=0,"NOT ASSIGNED","") AS [Assigned to POF Indicator]
FROM INFORMATICS.dbo.ECMCSQTRLY_TAB4 
ORDER BY [Member Last Name]

		-- SELECT * FROM INFORMATICS.dbo.ECMCSQTRLY_TAB4 ORDER BY [Member Last Name] */
