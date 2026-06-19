-- =====================================================================
	-- COMMENT(S) / CHANGE.LOG: --
-- =====================================================================

	/* Tab 5 Community Supports Provider Capacity */
	
-- =============================================
-- Author: Hina Punjabi
-- Original Create date: 20220104
-- Description:	Community Supports (CS) Authorization report Monthly
-- Change Log
-- Date			Initials	Ticket#		Description
-- 09/06/2023	jcostello				C001 - Updated fo QNXT Ethnicity changes.
-- =============================================

-- C001: per TEAMS DISCUSSION WITH() MS CLAUDIA FOR TAB 5 WE SHOULD BE CAPTURING MEMBERS WITH() AN OPEN CS AUTH AT THE END OF THE QTR BEING REPORTED ... 	r.effdate as 'Auth Start Date', -- FROM ALTER proc [dbo].[rptCommunitySupportsAuth] ... 	r.termdate as 'Auth End Date', -- FROM ALTER proc [dbo].[rptCommunitySupportsAuth]

-- We have a new QNXT auth template called Community Supports under outpatient services.  Please use this authorization template to capture all daily authorizations.  I would like a daily count with detail AND an accumulative count for the month.  

/*I would like to see the following fields IN the report:
Member CIN
Member CHG ID
Member Name
Member DOB
Member Address
Member Phone
Member language
Member ethnicity
Member PCP
Authorization Number
Codes approved ON the authorization
Modifier approved with the codes.
Codes Descriptions

-- Please see the CS services AND the relevant code document at the link below: 
		-- USE https://www.dhcs.ca.gov/Documents/MCQMD/Coding-Options-for-ECM-and-Community-Supports.pdf*/

-- C002: [TargetPopulation] ? In the 20240418 script, the POF assessment is updated to use the [ProviderPortal].ecm.[StratificationTargetPopulation] table instead, as per the guidance from the ECM weekly teams meeting ON 20240418.

-- C003: IN ('1679158125','1790002806','1760477467','1689066748','1659415131','1629749577','1619393584','1073177739','1538667969','1437821022','1427696616','1376797035','1275285868','1205254950','1447281936','1093834020','1922642909','1649809526','1154978021','1891408043','1376229872','1801007778','1679357685','1922790906') -- C003: UPDATE: CS National Provider Identifier (NPI) Number, if applicable per "MOC Excel File CS Provider Capacity Template 2024 Mapping 20240503.xlsx"
 
 -- C003: IN ('1063122323','1083764724','1447281936','1134144165','1205254950','1245246917','1295822658','1356889539','1366807760','1376229872','1427696616','1528271186','1073177739','1609920305','1619393584','1639614688','1649809526','1669711297','1689798985','1710439559','1760477467','1790718351','1891408043','1922642909','1598703647','1679158125','1952364747','1962483040','1982756086','1275972333','1255496105','1912688656','1134838352','1710336094','1710065933','1679357685','1922790906','1699043000','1255738423') -- C00#: UPDATE ECM National Provider Identifier (NPI) Number per "MOC Excel File ECM Provider Capacity Template 2023 Mapping 4.25.2024 20240503.xlsx"

/* C004: 20240508 CHANGE.LOG Report
		1.	INNER JOIN Condition Added IN ECMCSQTRLY_TAB5 Table Population:
				•	In the "ECM-CS Quartely Report_Tab 5 20240508.sql" script, a JOIN condition has been added when populating the ECMCSQTRLY_TAB5 table.
				•	The JOIN condition links the INFORMATICS.dbo.[uvw_CS_CAPACITY] view with the INFORMATICS.dbo.ECMCSQTRLY_TAB5PROV table based on matching npi_number and community_support_offered columns.
				•	This change ensures that only records with matching NPI numbers and community support offerings are inserted into the ECMCSQTRLY_TAB5 table.

		2.	Output Query Modified to Include INFORMATICS.dbo.[uvw_CS_CAPACITY] Table:
				•	In the "ECM-CS Quartely Report_Tab 5 20240508.sql" script, the output query that populates the INFORMATICS.dbo.ECMCSQTRLY_TAB5PROV_FINAL table has been modified to include the INFORMATICS.dbo.[uvw_CS_CAPACITY] view.
				•	The INFORMATICS.dbo.[uvw_CS_CAPACITY] table is joined with the INFORMATICS.dbo.ECMCSQTRLY_TAB5PROV table based on matching npi_number and community_support_offered columns.
				•	This change allows the final output to include information from both the provider capacity template and the ECMCSQTRLY_TAB5PROV table.

		3.	[Community Supports Provider NPI] Column Source Changed:
				•	In the "ECM-CS Quartely Report_Tab 5 20240508.sql" script, the source of the [Community Supports Provider NPI] column IN the final output query has been changed from tabfiveprov.[Community Supports Provider NPI] to cs.npi_number.
				•	This change ensures that the NPI number is sourced from the INFORMATICS.dbo.[uvw_CS_CAPACITY] view instead of the ECMCSQTRLY_TAB5PROV table.

		4.	Commented Out SELECT Statements:
				•	In the "ECM-CS Quartely Report_Tab 5 20240508.sql" script, several SELECT statements have been commented out, likely used for debugging or testing purposes.
				•	These commented out statements include:
				•	SELECT TOP 10 ' ' AS 'CHECK 1st',' ' AS 'TAB 5 CS',et.[Community Supports Provider NPI],et.[Community Supports Offered by Provider],cs.,et.
				•	SELECT DISTINCT ' ' AS 'CHECK 1st',cs.community_support_offered,et.[Community Supports Offered by Provider]
				•	SELECT TOP 10 ' ' AS 'CHECK 1st',*
				•	Commenting out these statements does not affect the functionality of the script but helps IN code readability and organization.

		5.	Commented Out WHERE Condition:
				•	In the "ECM-CS Quartely Report_Tab 5 20240508.sql" script, a WHERE condition has been commented out IN the query that populates the ECMCSQTRLY_TAB5 table.
				•	The commented out condition is: AND cs.npi_number IN ('1093834020')
				•	This condition appears to be used for testing or sampling purposes, limiting the results to a specific NPI number.
				•	Commenting out this condition allows the query to process all records without any specific NPI number filter. */

/* Tab 5. PROVIDER Community Supports Members and Services	ADDED AS OF Q4 2023 ECM / CS REPORTING		

	•	For columns J - X, indicate which Community Supports services the member 
		was approved for, during the reporting period, by entering 1 for Yes and 0 for No.	

	•	For columns Y - AM, indicate which Community Supports services the member received, 
		during the reporting period, by entering 1 for Yes and 0 for No.	*/
		
-- C004: Update to Community Support Offered logic: 'Transitional Rent' per Ms Kathryn eMail on 20251216 - SUBJECT:Question: Transitional Rent codes in CommunitySupportsAuthStatus Report ~ LEVERAGE: http://devops01:8080/IS/Informatics/_workitems/edit/23626/

		/* [Community Support Service Name]	[Code]	[Modifier]	[Units for Auth]	[Auth End]
		Transitional Rent											H0040	U2					6								6 months 
		Transitional Rent											H0040	U1					1								6 months 
		Transitional Rent											H0043	U2					168							6 months 
		Transitional Rent											H0044	U6					6								6 months  */		

  -- C005: ENSURE LIMIT BY [BRAND] CHGSD v CHPIV ON 20260204
 
-- M001: 20260605 - BUG FIX: Typo 'T42041' in asr4 Housing Tenancy and Sustaining Services WHEN block (line 259). Corrected to 'T2041'. Any auth with Housing Tenancy code on authservice sequence 5 was silently failing to classify and falling through to 'Received Other Service'.

-- M002: 20260605 - BUG FIX: Asthma Remediation asr2 WHEN block (line 328) referenced asr.modcode (sequence 1 modifier) instead of asr2.modcode (sequence 3 modifier). Corrected to asr2.modcode. Any S5165+U5 auth on authservice sequence 3 was misclassifying.

-- M003: 20260605 - DHCS HCPCS Coding Guidance v1.3 January 2026 ALIGNMENT: Added S9452+U5 (Nutrition Education Individual) and S9452+U6 (Nutrition Education Group) across all five asr sequences (asr through asr4) in the [Community Supports Offered by Provider] CASE block. S9452 was entirely absent from Tab 5.

-- M004: 20260605 - DHCS HCPCS Coding Guidance v1.3 January 2026 ALIGNMENT: Expanded S9977 WHEN blocks across all five asr sequences to include new modifier legs U4 (Produce Rx Box), U5 (Produce Rx Retail), U7 (Medically Supportive Groceries), U8 (Food Pharmacy), U9 (Healthy Food Vouchers). Prior code captured S9977+U6 only. Each new modifier leg added as a distinct WHEN block per sequence for label specificity.

-- M005: 20260605 - DHCS HCPCS Coding Guidance v1.3 January 2026 ALIGNMENT: Added H0044+U5 (Community or Home Transition Services - Non-Recurring Set-Up Expenses) across all five asr sequences. Flagged in DHCS guidance as 'Updated January 2026'. H0044+U5 was entirely absent from Tab 5.

-- M006: 20260605 - DHCS HCPCS Coding Guidance v1.3 January 2026 ALIGNMENT: Added mandatory housing outreach encounter codes T1016+U8 (in-person outreach) and T1016+U8+GQ (telephonic/electronic outreach) across all five asr sequences routing to 'Housing Outreach - Initiation'. DHCS requires MCPs to report and require providers to submit for Housing Transition/Navigation, Housing Deposits, and Housing Tenancy and Sustaining Services initiation outreach - both successful and unsuccessful. PACES submission mandatory; MCP reimbursement optional per DHCS pg 18-20. NOTE: Tab 5 evaluates asr.modcode (primary modifier field) only, consistent with existing script architecture.

-- =====================================================================
	-- DECLARE @PARAMETER(S) / @FILTER(S) --
-- =====================================================================
DECLARE @leadlag AS decimal(9,0)
DECLARE @leadlagmonths AS int
DECLARE @ClockStart AS datetime
DECLARE @ClockStop AS datetime
DECLARE @IPPdt AS datetime
DECLARE @gapallowance AS int

SET @leadlag = -4 -- +- LEAD() LAG() IN ...
SET @leadlagmonths = 3 -- +- LEAD() LAG() IN MONTH(S)
SET @ClockStart = DATEADD(MONTH,@leadlag,DATEADD(DAY,1,EOMONTH(GETDATE(),-1))) -- AS [1st of ... MONTH]
SET @ClockStop = DATEADD(day,-1,DATEADD(MONTH,@leadlagmonths,@ClockStart))
SET @IPPdt = TRY_CONVERT(date,GETDATE())
SET @gapallowance = 14

		SELECT 'BETWEEN '+CAST(CAST(@ClockStart AS date) AS varchar (25))+' AND '+CAST(CAST(@ClockStop AS date) AS varchar (25)) AS [RANGE NOTE(s)]
		,TRY_CONVERT(varchar(4),DATEPART(yyyy,@ClockStart))+' Q'+TRY_CONVERT(varchar(2),DATEPART(q,@ClockStart)) AS [Reporting Period]







---------------------------------------------------------------------------------------------------------------------------------
	-- Error Trapping: Check If Permanent Table(s) Already Exist(s) AND Drop If Applicable --
----------------------------------------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS INFORMATICS.dbo.ECMCSQTRLY_TAB5PROV;
DROP TABLE IF EXISTS INFORMATICS.dbo.ECMCSQTRLY_TAB5PROV_FINAL;
DROP TABLE IF EXISTS INFORMATICS.dbo.ECMCSQTRLY_TAB5;
DROP Table if exists #temp;

		SELECT ' ' AS 'see "ALTER proc [dbo].[rptCommunitySupportsAuth_Monthly]"'

SELECT DISTINCT 'Community Health Group Partnership Plan' AS 'Plan Name',
'29' AS 'Plan Code',
'San Diego' AS 'County',
TRY_CONVERT(varchar(4),DATEPART(yyyy,@ClockStart))+' Q'+TRY_CONVERT(varchar(2),DATEPART(q,@ClockStart)) AS [Reporting Period], --'2022 Q2' AS 'Reporting Period', '2023 Q3' AS 'Reporting Period',
referto.npi AS 'Community Supports Provider NPI',
TRY_CONVERT(nvarchar(255),NULL) AS [Community Supports Provider Type],
TRY_CONVERT(nvarchar(255),NULL) AS [Number of Members the Provider is able to serve],
m.fullname AS Member_Name,
m.dob AS Member_DOB,
m.secondaryid AS CIN,
m.memid AS Member_ID,
CASE lang.description                                                     
WHEN 'NO VALID DATA REPORTED' THEN 'Unknown'
WHEN 'No Language' THEN 'Unknown'
WHEN 'Undetermined' THEN 'Unknown'
WHEN '' THEN 'Unknown'
WHEN 'English, Old (ca. 450-1100)' THEN 'English'
WHEN 'English, Middle (1100-1500)' THEN 'English'
WHEN 'English - Large Print' THEN 'English'
WHEN 'Spanish - Large Print' THEN 'Spanish'
WHEN 'Arabic - Large Print' THEN 'Arabic'
WHEN 'Vietnamese - Large Print' THEN 'Vietnamese'
WHEN 'Tagalog - Large Print' THEN 'Tagalog'
WHEN 'Lao - Large Print' THEN 'Laotian'
ELSE lang.description
END	as Member_Preferred_Language,

	eth.description AS Member_Ethnicity,
	e.addr1,
	e.addr2,
	e.city,
	e.[state],
	LEFT( e.zip, 5 ) AS zip,
	pn.*,
	pcp.pcp_name,
	r.servicecode AS 'Referral_ServiceCode',
	r.authorizationid AS Authorization_ID,
	r.referralid AS Referral_ID,
	CAST(r.referraldate AS date) AS Referral_Date,
	r.effdate AS 'Auth Start Date',
	r.termdate AS 'Auth End Date',
	r.status AS 'Referral_Status',
	r.authstatus AS 'Auth_Status',

	asr.status AS 'HCPCSCode1_Status',
	asr1.status AS 'HCPCSCode2_Status',
	asr2.status AS 'HCPCSCode3_Status',
	asr3.status AS 'HCPCSCode4_Status',
	asr4.status AS 'HCPCSCode5_Status',

	r.referFROM AS Refer_FromProvID,
	referfrom.fullname AS Refer_FromProviderName,
	r.referto AS Refer_ToProvID,
	referto.fullname AS Refer_ToProviderName,

	asr.codeid AS 'HCPCSCode1',
	svc.description AS 'HCPCSCode1_Description',
	asr.modcode AS 'HCPCSCode1_ModCode1',
	asr.modcode2 AS 'HCPCSCode1_ModCode2',
	asr.modcode3 AS 'HCPCSCode1_ModCode3',
	asr.modcode4 AS 'HCPCSCode1_ModCode4',
	asr.modcode5 AS 'HCPCSCode1_ModCode5',
	asr.actualunits AS 'HCPCSCode1_ActualUnits',
	asr.requestedunits AS 'HCPCSCode1_RequestedUnits',
	asr.totalunits AS 'HCPCSCode1_TotalUnits',
	asr.usedunits AS 'HCPCSCode1_UsedUnits',

	asr1.codeid AS 'HCPCSCode2',
	svc1.description AS 'HCPCSCode2_Description',
	asr1.modcode AS 'HCPCSCode2_ModCode1',
	asr1.modcode2 AS 'HCPCSCode2_ModCode2',
	asr1.modcode3 AS 'HCPCSCode2_ModCode3',
	asr1.modcode4 AS 'HCPCSCode2_ModCode4',
	asr1.modcode5 AS 'HCPCSCode2_ModCode5',
	asr1.actualunits AS 'HCPCSCode2_ActualUnits',
	asr1.requestedunits AS 'HCPCSCode2_RequestedUnits',
	asr1.totalunits AS 'HCPCSCode2_TotalUnits',
	asr1.usedunits AS 'HCPCSCode2_UsedUnits',

	asr2.codeid AS 'HCPCSCode3',
	svc2.description AS 'HCPCSCode3_Description',
	asr2.modcode AS 'HCPCSCode3_ModCode1',
	asr2.modcode2 AS 'HCPCSCode3_ModCode2',
	asr2.modcode3 AS 'HCPCSCode3_ModCode3',
	asr2.modcode4 AS 'HCPCSCode3_ModCode4',
	asr2.modcode5 AS 'HCPCSCode3_ModCode5',
	asr2.actualunits AS 'HCPCSCode3_ActualUnits',
	asr2.requestedunits AS 'HCPCSCode3_RequestedUnits',
	asr2.totalunits AS 'HCPCSCode3_TotalUnits',
	asr2.usedunits AS 'HCPCSCode3_UsedUnits',

	asr3.codeid AS 'HCPCSCode4',
	svc3.description AS 'HCPCSCode4_Description',
	asr3.modcode AS 'HCPCSCode4_ModCode1',
	asr3.modcode2 AS 'HCPCSCode4_ModCode2',
	asr3.modcode3 AS 'HCPCSCode4_ModCode3',
	asr3.modcode4 AS 'HCPCSCode4_ModCode4',
	asr3.modcode5 AS 'HCPCSCode4_ModCode5',
	asr3.actualunits AS 'HCPCSCode4_ActualUnits',
	asr3.requestedunits AS 'HCPCSCode4_RequestedUnits',
	asr3.totalunits AS 'HCPCSCode4_TotalUnits',
	asr3.usedunits AS 'HCPCSCode4_UsedUnits',

	asr4.codeid AS 'HCPCSCode5',
	svc4.description AS 'HCPCSCode5_Description',
	asr4.modcode AS 'HCPCSCode5_ModCode1',
	asr4.modcode2 AS 'HCPCSCode5_ModCode2',
	asr4.modcode3 AS 'HCPCSCode5_ModCode3',
	asr4.modcode4 AS 'HCPCSCode5_ModCode4',
	asr4.modcode5 AS 'HCPCSCode5_ModCode5',
	asr4.actualunits AS 'HCPCSCode5_ActualUnits',
	asr4.requestedunits AS 'HCPCSCode5_RequestedUnits',
	asr4.totalunits AS 'HCPCSCode5_TotalUnits',
	asr4.usedunits AS 'HCPCSCode5_UsedUnits',

CASE
WHEN asr.codeid IN ('H0043','H2016') AND asr.modcode ='U6' THEN 'Housing Transition Navigation Services'
WHEN asr1.codeid IN ('H0043','H2016') AND asr1.modcode ='U6' THEN 'Housing Transition Navigation Services'
WHEN asr2.codeid IN ('H0043','H2016') AND asr2.modcode ='U6' THEN 'Housing Transition Navigation Services'
WHEN asr3.codeid IN ('H0043','H2016') AND asr3.modcode ='U6' THEN 'Housing Transition Navigation Services'
WHEN asr4.codeid IN ('H0043','H2016') AND asr4.modcode ='U6' THEN 'Housing Transition Navigation Services'

WHEN asr.codeid ='H0044' AND asr.modcode ='U2' THEN 'Housing Deposits'
WHEN asr1.codeid ='H0044' AND asr1.modcode='U2' THEN 'Housing Deposits'
WHEN asr2.codeid ='H0044' AND asr2.modcode ='U2' THEN 'Housing Deposits'
WHEN asr3.codeid ='H0044' AND asr3.modcode ='U2' THEN 'Housing Deposits'
WHEN asr4.codeid ='H0044' AND asr4.modcode ='U2' THEN 'Housing Deposits'

WHEN asr.codeid IN ('T2040', 'T2041', 'T2050','T2051') AND asr.modcode ='U6' THEN 'Housing Tenancy and Sustaining Services'
WHEN asr1.codeid IN ('T2040', 'T2041', 'T2050','T2051') AND asr1.modcode ='U6' THEN 'Housing Tenancy and Sustaining Services'
WHEN asr2.codeid IN ('T2040', 'T2041', 'T2050','T2051') AND asr2.modcode ='U6' THEN 'Housing Tenancy and Sustaining Services'
WHEN asr3.codeid IN ('T2040', 'T2041', 'T2050','T2051') AND asr3.modcode ='U6' THEN 'Housing Tenancy and Sustaining Services'
WHEN asr4.codeid IN ('T2040', 'T2041', 'T2050','T2051') AND asr4.modcode ='U6' THEN 'Housing Tenancy and Sustaining Services' -- M001: CORRECTED FROM 'T42041' ~ typo caused silent misclassification on authservice sequence 5
WHEN asr.codeid IN ('H0043', 'H0044') AND asr.modcode='U3' THEN 'Short-term Post-Hospitalization Housing'   
WHEN asr1.codeid IN ('H0043', 'H0044') AND asr1.modcode ='U3' THEN 'Short-term Post-Hospitalization Housing'   
WHEN asr2.codeid IN ('H0043', 'H0044') AND asr2.modcode ='U3' THEN 'Short-term Post-Hospitalization Housing'   
WHEN asr3.codeid IN ('H0043', 'H0044') AND asr3.modcode ='U3' THEN 'Short-term Post-Hospitalization Housing'   
WHEN asr4.codeid IN ('H0043', 'H0044') AND asr4.modcode ='U3' THEN 'Short-term Post-Hospitalization Housing'   

WHEN asr.codeid ='T2033' AND asr.modcode ='U6' THEN 'Recuperative Care'
WHEN asr1.codeid='T2033' AND asr1.modcode ='U6' THEN 'Recuperative Care'
WHEN asr2.codeid ='T2033' AND asr2.modcode ='U6' THEN 'Recuperative Care'
WHEN asr3.codeid ='T2033' AND asr3.modcode ='U6' THEN 'Recuperative Care'
WHEN asr4.codeid ='T2033' AND asr4.modcode ='U6' THEN 'Recuperative Care'

WHEN asr.codeid IN ('H0045', 'S5151', 'S9125') AND asr.modcode ='U6' THEN 'Respite Services'
WHEN asr1.codeid IN ('H0045', 'S5151', 'S9125') AND asr1.modcode ='U6' THEN 'Respite Services'
WHEN asr2.codeid IN ('H0045', 'S5151', 'S9125') AND asr2.modcode ='U6' THEN 'Respite Services'
WHEN asr3.codeid IN ('H0045', 'S5151', 'S9125') AND asr3.modcode ='U6' THEN 'Respite Services'
WHEN asr4.codeid IN ('H0045', 'S5151', 'S9125') AND asr4.modcode ='U6' THEN 'Respite Services'

WHEN asr.codeid IN ('T2012', 'T2014', 'T2018', 'T2020', 'H2014', 'H2038', 'H2024', 'H2026') AND asr.modcode ='U6' THEN 'Day Habilitation Programs'
WHEN asr1.codeid IN ('T2012', 'T2014', 'T2018', 'T2020', 'H2014', 'H2038', 'H2024', 'H2026') AND  asr1.modcode ='U6' THEN 'Day Habilitation Programs'
WHEN asr2.codeid IN ('T2012', 'T2014', 'T2018', 'T2020', 'H2014', 'H2038', 'H2024', 'H2026') AND asr2.modcode ='U6' THEN 'Day Habilitation Programs'
WHEN asr3.codeid IN ('T2012', 'T2014', 'T2018', 'T2020', 'H2014', 'H2038', 'H2024', 'H2026') AND asr3.modcode ='U6' THEN 'Day Habilitation Programs'
WHEN asr4.codeid IN ('T2012', 'T2014', 'T2018', 'T2020', 'H2014', 'H2038', 'H2024', 'H2026') AND asr4.modcode ='U6' THEN 'Day Habilitation Programs'

WHEN asr.codeid ='T2038' AND asr.modcode ='U4' THEN 'NF Transition to ALF'
WHEN asr1.codeid ='T2038' AND asr1.modcode ='U4' THEN 'NF Transition to ALF'
WHEN asr2.codeid ='T2038' AND asr2.modcode ='U4' THEN 'NF Transition to ALF'
WHEN asr3.codeid ='T2038' AND asr3.modcode ='U4' THEN 'NF Transition to ALF'
WHEN asr4.codeid ='T2038' AND asr4.modcode ='U4' THEN 'NF Transition to ALF'

WHEN asr.codeid ='H2022' AND asr.modcode ='U5' THEN 'NF Transition to ALF'
WHEN asr1.codeid ='H2022' AND asr1.modcode ='U5' THEN 'NF Transition to ALF'
WHEN asr2.codeid ='H2022' AND asr2.modcode ='U5' THEN 'NF Transition to ALF'
WHEN asr3.codeid ='H2022' AND asr3.modcode ='U5' THEN 'NF Transition to ALF'
WHEN asr4.codeid ='H2022' AND asr4.modcode ='U5' THEN 'NF Transition to ALF'

WHEN asr.codeid ='T2038' AND asr.modcode ='U5' THEN 'NF Transition to a Home'
WHEN asr1.codeid ='T2038' AND asr1.modcode ='U5' THEN 'NF Transition to a Home'
WHEN asr2.codeid ='T2038' AND asr2.modcode ='U5' THEN 'NF Transition to a Home'
WHEN asr3.codeid ='T2038' AND asr3.modcode ='U5' THEN 'NF Transition to a Home'
WHEN asr4.codeid ='T2038' AND asr4.modcode ='U5' THEN 'NF Transition to a Home'

WHEN asr.codeid IN ('S5130', 'T1019') AND asr.modcode ='U6' THEN 'Personal Care and Homemaker Services'
WHEN asr1.codeid IN ('S5130', 'T1019') AND asr1.modcode ='U6' THEN 'Personal Care and Homemaker Services'
WHEN asr2.codeid IN ('S5130', 'T1019') AND asr2.modcode ='U6' THEN 'Personal Care and Homemaker Services'
WHEN asr3.codeid IN ('S5130', 'T1019') AND asr3.modcode ='U6' THEN 'Personal Care and Homemaker Services'
WHEN asr4.codeid IN ('S5130', 'T1019') AND asr4.modcode ='U6' THEN 'Personal Care and Homemaker Services'

WHEN asr.codeid ='S5165' AND asr.modcode ='U6' THEN 'Environmental Accessibility Adaptations'
WHEN asr1.codeid ='S5165' AND asr1.modcode ='U6' THEN 'Environmental Accessibility Adaptations'
WHEN asr2.codeid ='S5165' AND asr2.modcode ='U6' THEN 'Environmental Accessibility Adaptations'
WHEN asr3.codeid ='S5165' AND asr3.modcode ='U6' THEN 'Environmental Accessibility Adaptations'
WHEN asr4.codeid ='S5165' AND asr4.modcode ='U6' THEN 'Environmental Accessibility Adaptations'

WHEN asr.codeid IN ('S5170','S9470','S9977') AND asr.modcode ='U6' THEN 'Medically-Supportive Food'
WHEN asr1.codeid IN ('S5170','S9470','S9977') AND asr1.modcode ='U6' THEN 'Medically-Supportive Food'
WHEN asr2.codeid IN ('S5170','S9470','S9977') AND asr2.modcode ='U6' THEN 'Medically-Supportive Food'
WHEN asr3.codeid IN ('S5170','S9470','S9977') AND asr3.modcode ='U6' THEN 'Medically-Supportive Food'
WHEN asr4.codeid IN ('S5170','S9470','S9977') AND asr4.modcode ='U6' THEN 'Medically-Supportive Food'

WHEN asr.codeid ='S9452' AND asr.modcode ='U5' THEN 'Medically-Supportive Food - Nutrition Education Individual' -- M003: DHCS v1.3 Jan 2026
WHEN asr1.codeid ='S9452' AND asr1.modcode ='U5' THEN 'Medically-Supportive Food - Nutrition Education Individual' -- M003: DHCS v1.3 Jan 2026
WHEN asr2.codeid ='S9452' AND asr2.modcode ='U5' THEN 'Medically-Supportive Food - Nutrition Education Individual' -- M003: DHCS v1.3 Jan 2026
WHEN asr3.codeid ='S9452' AND asr3.modcode ='U5' THEN 'Medically-Supportive Food - Nutrition Education Individual' -- M003: DHCS v1.3 Jan 2026
WHEN asr4.codeid ='S9452' AND asr4.modcode ='U5' THEN 'Medically-Supportive Food - Nutrition Education Individual' -- M003: DHCS v1.3 Jan 2026

WHEN asr.codeid ='S9452' AND asr.modcode ='U6' THEN 'Medically-Supportive Food - Nutrition Education Group' -- M003: DHCS v1.3 Jan 2026
WHEN asr1.codeid ='S9452' AND asr1.modcode ='U6' THEN 'Medically-Supportive Food - Nutrition Education Group' -- M003: DHCS v1.3 Jan 2026
WHEN asr2.codeid ='S9452' AND asr2.modcode ='U6' THEN 'Medically-Supportive Food - Nutrition Education Group' -- M003: DHCS v1.3 Jan 2026
WHEN asr3.codeid ='S9452' AND asr3.modcode ='U6' THEN 'Medically-Supportive Food - Nutrition Education Group' -- M003: DHCS v1.3 Jan 2026
WHEN asr4.codeid ='S9452' AND asr4.modcode ='U6' THEN 'Medically-Supportive Food - Nutrition Education Group' -- M003: DHCS v1.3 Jan 2026

WHEN asr.codeid ='S9977' AND asr.modcode ='U4' THEN 'Medically-Supportive Food - Produce Rx Box' -- M004: DHCS v1.3 Jan 2026
WHEN asr1.codeid ='S9977' AND asr1.modcode ='U4' THEN 'Medically-Supportive Food - Produce Rx Box' -- M004: DHCS v1.3 Jan 2026
WHEN asr2.codeid ='S9977' AND asr2.modcode ='U4' THEN 'Medically-Supportive Food - Produce Rx Box' -- M004: DHCS v1.3 Jan 2026
WHEN asr3.codeid ='S9977' AND asr3.modcode ='U4' THEN 'Medically-Supportive Food - Produce Rx Box' -- M004: DHCS v1.3 Jan 2026
WHEN asr4.codeid ='S9977' AND asr4.modcode ='U4' THEN 'Medically-Supportive Food - Produce Rx Box' -- M004: DHCS v1.3 Jan 2026

WHEN asr.codeid ='S9977' AND asr.modcode ='U5' THEN 'Medically-Supportive Food - Produce Rx Retail' -- M004: DHCS v1.3 Jan 2026
WHEN asr1.codeid ='S9977' AND asr1.modcode ='U5' THEN 'Medically-Supportive Food - Produce Rx Retail' -- M004: DHCS v1.3 Jan 2026
WHEN asr2.codeid ='S9977' AND asr2.modcode ='U5' THEN 'Medically-Supportive Food - Produce Rx Retail' -- M004: DHCS v1.3 Jan 2026
WHEN asr3.codeid ='S9977' AND asr3.modcode ='U5' THEN 'Medically-Supportive Food - Produce Rx Retail' -- M004: DHCS v1.3 Jan 2026
WHEN asr4.codeid ='S9977' AND asr4.modcode ='U5' THEN 'Medically-Supportive Food - Produce Rx Retail' -- M004: DHCS v1.3 Jan 2026

WHEN asr.codeid ='S9977' AND asr.modcode ='U7' THEN 'Medically-Supportive Food - Medically Supportive Groceries' -- M004: DHCS v1.3 Jan 2026
WHEN asr1.codeid ='S9977' AND asr1.modcode ='U7' THEN 'Medically-Supportive Food - Medically Supportive Groceries' -- M004: DHCS v1.3 Jan 2026
WHEN asr2.codeid ='S9977' AND asr2.modcode ='U7' THEN 'Medically-Supportive Food - Medically Supportive Groceries' -- M004: DHCS v1.3 Jan 2026
WHEN asr3.codeid ='S9977' AND asr3.modcode ='U7' THEN 'Medically-Supportive Food - Medically Supportive Groceries' -- M004: DHCS v1.3 Jan 2026
WHEN asr4.codeid ='S9977' AND asr4.modcode ='U7' THEN 'Medically-Supportive Food - Medically Supportive Groceries' -- M004: DHCS v1.3 Jan 2026

WHEN asr.codeid ='S9977' AND asr.modcode ='U8' THEN 'Medically-Supportive Food - Food Pharmacy' -- M004: DHCS v1.3 Jan 2026
WHEN asr1.codeid ='S9977' AND asr1.modcode ='U8' THEN 'Medically-Supportive Food - Food Pharmacy' -- M004: DHCS v1.3 Jan 2026
WHEN asr2.codeid ='S9977' AND asr2.modcode ='U8' THEN 'Medically-Supportive Food - Food Pharmacy' -- M004: DHCS v1.3 Jan 2026
WHEN asr3.codeid ='S9977' AND asr3.modcode ='U8' THEN 'Medically-Supportive Food - Food Pharmacy' -- M004: DHCS v1.3 Jan 2026
WHEN asr4.codeid ='S9977' AND asr4.modcode ='U8' THEN 'Medically-Supportive Food - Food Pharmacy' -- M004: DHCS v1.3 Jan 2026

WHEN asr.codeid ='S9977' AND asr.modcode ='U9' THEN 'Medically-Supportive Food - Healthy Food Vouchers' -- M004: DHCS v1.3 Jan 2026
WHEN asr1.codeid ='S9977' AND asr1.modcode ='U9' THEN 'Medically-Supportive Food - Healthy Food Vouchers' -- M004: DHCS v1.3 Jan 2026
WHEN asr2.codeid ='S9977' AND asr2.modcode ='U9' THEN 'Medically-Supportive Food - Healthy Food Vouchers' -- M004: DHCS v1.3 Jan 2026
WHEN asr3.codeid ='S9977' AND asr3.modcode ='U9' THEN 'Medically-Supportive Food - Healthy Food Vouchers' -- M004: DHCS v1.3 Jan 2026
WHEN asr4.codeid ='S9977' AND asr4.modcode ='U9' THEN 'Medically-Supportive Food - Healthy Food Vouchers' -- M004: DHCS v1.3 Jan 2026

WHEN asr.codeid ='H0014' AND asr.modcode ='U6' THEN 'Sobering Centers'
WHEN asr1.codeid ='H0014' AND asr1.modcode ='U6' THEN 'Sobering Centers'
WHEN asr2.codeid ='H0014' AND asr2.modcode ='U6' THEN 'Sobering Centers'
WHEN asr3.codeid ='H0014' AND asr3.modcode ='U6' THEN 'Sobering Centers'
WHEN asr4.codeid ='H0014' AND asr4.modcode ='U6' THEN 'Sobering Centers'

WHEN asr.codeid ='S5165' AND asr.modcode ='U5' THEN 'Asthma Remediation'
WHEN asr1.codeid ='S5165' AND asr1.modcode ='U5' THEN 'Asthma Remediation'
WHEN asr2.codeid ='S5165' AND asr2.modcode ='U5' THEN 'Asthma Remediation' -- M002: CORRECTED FROM asr.modcode ~ wrong alias caused sequence 3 auth to evaluate sequence 1 modifier
WHEN asr3.codeid ='S5165' AND asr3.modcode ='U5' THEN 'Asthma Remediation'
WHEN asr4.codeid ='S5165' AND asr4.modcode ='U5' THEN 'Asthma Remediation'

WHEN asr.codeid IN ('H0040') AND asr.modcode ='U1' THEN 'Transitional Rent' -- C004: Update to Community Support Offered logic: 'Transitional Rent' per Ms Kathryn eMail on 20251216 - SUBJECT:Question: Transitional Rent codes in CommunitySupportsAuthStatus Report ~ LEVERAGE: http://devops01:8080/IS/Informatics/_workitems/edit/23626/
WHEN asr1.codeid IN ('H0040') AND asr1.modcode ='U1' THEN 'Transitional Rent'
WHEN asr2.codeid IN ('H0040') AND asr2.modcode ='U1' THEN 'Transitional Rent'
WHEN asr3.codeid IN ('H0040') AND asr3.modcode ='U1' THEN 'Transitional Rent'
WHEN asr4.codeid IN ('H0040') AND asr4.modcode ='U1' THEN 'Transitional Rent'

WHEN asr.codeid IN ('H0040','H0043') AND asr.modcode ='U2' THEN 'Transitional Rent' -- C004: Update to Community Support Offered logic: 'Transitional Rent' per Ms Kathryn eMail on 20251216 - SUBJECT:Question: Transitional Rent codes in CommunitySupportsAuthStatus Report ~ LEVERAGE: http://devops01:8080/IS/Informatics/_workitems/edit/23626/
WHEN asr1.codeid IN ('H0040','H0043') AND asr1.modcode ='U2' THEN 'Transitional Rent'
WHEN asr2.codeid IN ('H0040','H0043') AND asr2.modcode ='U2' THEN 'Transitional Rent'
WHEN asr3.codeid IN ('H0040','H0043') AND asr3.modcode ='U2' THEN 'Transitional Rent'
WHEN asr4.codeid IN ('H0040','H0043') AND asr4.modcode ='U2' THEN 'Transitional Rent'

WHEN asr.codeid IN ('H0044') AND asr.modcode ='U6' THEN 'Transitional Rent' -- C004: Update to Community Support Offered logic: 'Transitional Rent' per Ms Kathryn eMail on 20251216 - SUBJECT:Question: Transitional Rent codes in CommunitySupportsAuthStatus Report ~ LEVERAGE: http://devops01:8080/IS/Informatics/_workitems/edit/23626/
WHEN asr1.codeid IN ('H0044') AND asr1.modcode ='U6' THEN 'Transitional Rent'
WHEN asr2.codeid IN ('H0044') AND asr2.modcode ='U6' THEN 'Transitional Rent'
WHEN asr3.codeid IN ('H0044') AND asr3.modcode ='U6' THEN 'Transitional Rent'
WHEN asr4.codeid IN ('H0044') AND asr4.modcode ='U6' THEN 'Transitional Rent'

WHEN asr.codeid ='H0044' AND asr.modcode ='U5' THEN 'Community or Home Transition Services - Non-Recurring Set-Up Expenses' -- M005: DHCS v1.3 Jan 2026 (Updated January 2026)
WHEN asr1.codeid ='H0044' AND asr1.modcode ='U5' THEN 'Community or Home Transition Services - Non-Recurring Set-Up Expenses' -- M005: DHCS v1.3 Jan 2026
WHEN asr2.codeid ='H0044' AND asr2.modcode ='U5' THEN 'Community or Home Transition Services - Non-Recurring Set-Up Expenses' -- M005: DHCS v1.3 Jan 2026
WHEN asr3.codeid ='H0044' AND asr3.modcode ='U5' THEN 'Community or Home Transition Services - Non-Recurring Set-Up Expenses' -- M005: DHCS v1.3 Jan 2026
WHEN asr4.codeid ='H0044' AND asr4.modcode ='U5' THEN 'Community or Home Transition Services - Non-Recurring Set-Up Expenses' -- M005: DHCS v1.3 Jan 2026

WHEN asr.codeid ='T1016' AND asr.modcode ='U8' THEN 'Housing Outreach - Initiation' -- M006: DHCS v1.3 Jan 2026 ~ mandatory PACES encounter codes; T1016+U8 in-person and T1016+U8+GQ telephonic/electronic
WHEN asr1.codeid ='T1016' AND asr1.modcode ='U8' THEN 'Housing Outreach - Initiation' -- M006: DHCS v1.3 Jan 2026
WHEN asr2.codeid ='T1016' AND asr2.modcode ='U8' THEN 'Housing Outreach - Initiation' -- M006: DHCS v1.3 Jan 2026
WHEN asr3.codeid ='T1016' AND asr3.modcode ='U8' THEN 'Housing Outreach - Initiation' -- M006: DHCS v1.3 Jan 2026
WHEN asr4.codeid ='T1016' AND asr4.modcode ='U8' THEN 'Housing Outreach - Initiation' -- M006: DHCS v1.3 Jan 2026

ELSE 'Received Other Service'
-- END AS 'PopulationofFocus'
END AS [Community Supports Offered by Provider]
INTO INFORMATICS.dbo.ECMCSQTRLY_TAB5PROV

FROM HMOPROD_PlanData.dbo.member AS m
	INNER JOIN HMOPROD_PlanData.dbo.referral AS r ON r.memid = m.memid
	INNER JOIN HMOPROD_PlanData.dbo.provider AS referto ON r.referto = referto.provid
	INNER JOIN HMOPROD_PlanData.DBO.provider AS referFROM ON referfrom.provid = r.referfrom
	-- INNER JOIN HMOPROD_PlanData..authservice asr ON asr.referralid = r.referralid
		LEFT JOIN HMOPROD_PlanData..authservice AS asr ON asr.referralid = r.referralid 
			AND asr.sequence = '1'
		LEFT JOIN HMOPROD_PlanData..authservice AS asr1 ON asr1.referralid = r.referralid --AND asr.status = 'Approved'
			AND asr1.sequence = '2'
		LEFT JOIN HMOPROD_PlanData..authservice AS asr2 ON asr2.referralid = r.referralid --AND asr.status = 'Approved'
			AND asr2.sequence = '3'
		LEFT JOIN HMOPROD_PlanData..authservice AS asr3 ON asr3.referralid = r.referralid --AND asr.status = 'Approved'
			AND asr3.sequence = '4'
		LEFT JOIN HMOPROD_PlanData..authservice AS asr4 ON asr4.referralid = r.referralid --AND asr.status = 'Approved'
			AND asr4.sequence = '5'
		INNER JOIN HMOPROD_PlanData..entity AS e ON m.entityid = e.entid
		LEFT JOIN CHGNXT.dbo.PhoneNumbers AS pn ON m.memid = pn.MemberId
		LEFT JOIN INFORMATICS.dbo.vw_currentpcp AS pcp ON m.memid = pcp.memid
		LEFT JOIN HMOPROD_PlanData.dbo.language AS lang ON lang.languageid = m.primarylanguage
		--LEFT JOIN HMOPROD_PlanData.dbo.ethnicity ethnic ON ethnic.ethnicid = m.ethnicid
		--C001 start
		LEFT JOIN INFORMATICS.dbo.uvwQNXTEthnicity_QNXT6Upgrade AS eth ON m.memid = eth.memid
		--C001 end
		LEFT JOIN HMOPROD_PlanData.dbo.svccode svc ON svc.codeid = asr.codeid
		LEFT JOIN HMOPROD_PlanData.dbo.svccode svc1 ON svc1.codeid = asr1.codeid
		LEFT JOIN HMOPROD_PlanData.dbo.svccode svc2 ON svc2.codeid = asr2.codeid
		LEFT JOIN HMOPROD_PlanData.dbo.svccode svc3 ON svc3.codeid = asr3.codeid
		LEFT JOIN HMOPROD_PlanData.dbo.svccode svc4 ON svc4.codeid = asr4.codeid
WHERE 1=1 
	AND r.servicecode = 'css'
	AND TRY_CONVERT(date,r.termdate) >= @ClockStop -- C001: per TEAMS DISCUSSION WITH() MS CLAUDIA FOR TAB 5 WE SHOULD BE CAPTURING MEMBERS WITH() AN OPEN CS AUTH AT THE END OF THE QTR BEING REPORTED ... 	r.effdate as 'Auth Start Date', -- FROM ALTER proc [dbo].[rptCommunitySupportsAuth] ... 	r.termdate as 'Auth End Date', -- FROM ALTER proc [dbo].[rptCommunitySupportsAuth]
	AND TRY_CONVERT(date,r.effdate) <= @ClockStop -- C001: per TEAMS DISCUSSION WITH() MS CLAUDIA FOR TAB 5 WE SHOULD BE CAPTURING MEMBERS WITH() AN OPEN CS AUTH AT THE END OF THE QTR BEING REPORTED ... 	r.effdate as 'Auth Start Date', -- FROM ALTER proc [dbo].[rptCommunitySupportsAuth] ... 	r.termdate as 'Auth End Date', -- FROM ALTER proc [dbo].[rptCommunitySupportsAuth]
	AND r.termdate >= r.effdate -- MUST BE TRUE ... NON-CROSSFOOTED RECORDS ARE ACTIVE ...	
	





	
-- =====================================================================
	-- Hx TAB 5 MANUAL LOGIC STAGING FROM MS HINA + MS CLAUDIA -- 
-- =====================================================================
SELECT DISTINCT cs.npi_number AS 'Community Supports Provider NPI',
cs.provider_type AS 'Community Supports Provider Type',
cs.community_support_offered AS 'Community Supports Offered by Provider',
cs.num_members_can_serve AS 'Number of Members the Provider is able to serve'
INTO INFORMATICS.dbo.ECMCSQTRLY_TAB5
-- SELECT TOP 10 ' ' AS 'CHECK 1st',' ' AS 'TAB 5 CS',et.[Community Supports Provider NPI],et.[Community Supports Offered by Provider],cs.*,et.*
-- SELECT DISTINCT ' ' AS 'CHECK 1st',cs.community_support_offered,et.[Community Supports Offered by Provider]
FROM INFORMATICS.dbo.[uvw_CS_CAPACITY] AS cs -- IMPORT FROM "Q1 2024 ECM CS Report .msg" + "MOC Excel File CS Provider Capacity Template 2024 Mapping 20240503.xlsx" C004: 20240508 CHANGE.LOG Report
	 LEFT JOIN INFORMATICS.dbo.ECMCSQTRLY_TAB5PROV AS et ON cs.npi_number = et.[Community Supports Provider NPI]
		AND cs.community_support_offered = et.[Community Supports Offered by Provider]
WHERE 1=1
	AND cs.chg_cs_provider_flag = 1 -- C005: ENSURE LIMIT BY [BRAND] CHGSD v CHPIV ON 20260204







-- ==================================================
	-- OUTPUT: 
-- ==================================================
SELECT DISTINCT 'Community Health Group Partnership Plan' AS 'Plan Name',
'29' AS 'Plan Code',
'San Diego' AS 'County',
TRY_CONVERT(varchar(4),DATEPART(yyyy,@ClockStart))+' Q'+TRY_CONVERT(varchar(2),DATEPART(q,@ClockStart)) AS [Reporting Period],
cs.npi_number AS [Community Supports Provider NPI],
cs.provider_type AS [Community Supports Provider Type],
cs.community_support_offered AS [Community Supports Offered by Provider],
COUNT(DISTINCT(tabfiveprov.Member_ID)) AS [Number of Members the Provider is serving],
cs.num_members_can_serve AS [Number of Members the Provider is able to serve],
TRY_CONVERT(nvarchar(255),NULL) AS [CAPACITY CHECK]
INTO INFORMATICS.dbo.ECMCSQTRLY_TAB5PROV_FINAL
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM INFORMATICS.dbo.[uvw_CS_CAPACITY] AS cs -- IMPORT FROM "Q1 2024 ECM CS Report .msg" + "MOC Excel File CS Provider Capacity Template 2024 Mapping 20240503.xlsx" C004: 20240508 CHANGE.LOG Report
		 LEFT JOIN INFORMATICS.dbo.ECMCSQTRLY_TAB5PROV AS tabfiveprov ON cs.npi_number = tabfiveprov.[Community Supports Provider NPI]
			AND cs.community_support_offered = tabfiveprov.[Community Supports Offered by Provider]
		LEFT JOIN INFORMATICS.dbo.ECMCSQTRLY_TAB5 AS staging ON tabfiveprov.[Community Supports Provider NPI] = staging.[Community Supports Provider NPI]
			AND tabfiveprov.[Community Supports Offered by Provider] = staging.[Community Supports Offered by Provider]
WHERE 1=1
	AND cs.chg_cs_provider_flag = 1 -- C005: ENSURE LIMIT BY [BRAND] CHGSD v CHPIV ON 20260204			
GROUP BY cs.npi_number,cs.provider_type,cs.community_support_offered,cs.num_members_can_serve

UPDATE INFORMATICS.dbo.ECMCSQTRLY_TAB5PROV_FINAL
SET [CAPACITY CHECK] = 'WARNING!!! SERVING MORE MEMBERS THAN CAPACITY LIMIT'
FROM INFORMATICS.dbo.ECMCSQTRLY_TAB5PROV_FINAL
WHERE 1=1
	AND [Number of Members the Provider is able to serve] < [Number of Members the Provider is serving]
		
		SELECT * FROM INFORMATICS.dbo.ECMCSQTRLY_TAB5PROV_FINAL
		
		/* SELECT DISTINCT 	Auth_Status,CAST(Referral_Date AS date) AS Referral_Date
		,COUNT(Authorization_ID) AS AuthID_Count
		-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
		-- SELECT DISTINCT ' ' AS 'CHECK 1st'
		FROM INFORMATICS.dbo.ECMCSQTRLY_TAB5PROV
		GROUP BY Referral_Date, Auth_Status */

		SELECT TOP 10  ' ' AS 'TAB5 - SAMPLE: DETAIL: ',* FROM INFORMATICS.dbo.ECMCSQTRLY_TAB5PROV

		SELECT ' ' AS 'OVERALL QA COUNT'
		,tabfiveprov.[Community Supports Offered by Provider] 
		,COUNT(DISTINCT(tabfiveprov.Member_ID)) AS [Number of Members the Provider is serving BY memid]
		,COUNT(DISTINCT(tabfiveprov.CIN)) AS [Number of Members the Provider is serving BY CIN]
		,COUNT(DISTINCT(tabfiveprov.Authorization_ID)) AS [Number of Auths]
		-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
		-- SELECT DISTINCT ' ' AS 'CHECK 1st'
		FROM INFORMATICS.dbo.ECMCSQTRLY_TAB5PROV AS tabfiveprov
		WHERE 1=1 
		GROUP BY tabfiveprov.[Community Supports Offered by Provider] 
