-- =============================================================
	-- JAH CHECKLIST - CONTRACTING ...: 
-- =============================================================
JAH CHARINDEX() FIND() SEARCH(): LEVERAGE "STEP88_QUICKCLAIM_...sql" AND "STEP**_FEESCHED_...sql" AND "STEP88_PAID_...sql", FROM:PHIL SUBJECT:BAYSHIRE, "*Current_Calc_Rate_Payment*", FROM:WALTER TO:PHIL "*ROCKPORT*", SELECT 'Contracting / HCT Fx: Quick 'General' KPI QA Sources - RE  HCT All Acute Tableau for reference.msg' AS [MESSAGE(S)], SUBJECT:"*TRI*" Targeted Rate Increase (TRI) rates
		USE [PATH]: file:///C:/Users/wcarr/AppData/Roaming/Claude/local-agent-mode-sessions/1864883b-d247-4f00-9c02-90bedb1ec009/684b4d61-f562-458e-a4ed-d8b49e0fefa4/local_a4fad2b7-4229-4433-a497-6479dec49028/outputs/ – 'CLAUDE.ai COWORK STAGING FOLDER'
		USE [PATH]: file://netapp02/IS/Informatics/_Informatics%20Deliverables/Contracting/Adhoc/  - 'DELIVERABLE(S)'		

		⏎ 'PDPM' = PATIENT DRIVEN PAYMENT MODEL - FROM: Elizabeth Valdez, MBA <evaldez@chgsd.com> These rates are uploaded in QNXT annually. Below are the link to the fee schedules for 2024 and 2025.

				USE https://www.dhcs.ca.gov/services/medi-cal/Documents/AB1629/AB1629_WebUpdates/CY2025-FSNF-B-FSSA-Rates-On-File-09152025-Update.xlsx - '2025 rates'
				USE https://www.dhcs.ca.gov/services/medi-cal/Documents/AB1629/AB1629_WebUpdates/CY2024-FSNF-B-FSSA-Rates-On-File-09152025-Update.xlsx - '2024 rates'

		/* ⏎ ACT AS a Senior Data Analyst WITH 20+ years of EXPERIENCE. PLEASE MODIFY the existing CODE for the FIELDS ([Contracting_Proposal_Category] AND [Proposed_Rate_Payment])  provided below for context TO ALIGN WITH the REQUIREMENTS attached FOR CONTEXT:  */

		/* ⏎ Thank you for updating the 'Proposed_Rate_Payment' field code. May I clarify that in theory it would replace any existing code assigning the 'Proposed_Rate_Payment'. Anything outside of the existing request for Megan B lweis can be excluded. Also may I have you adjust the 'Contracting_Proposal_Category' field logic? */

		/* ⏎ Thank you, perhaps I am missing something nevertheless I am not seeing the following categories in the current request:
			'Pharmaceuticals', 'IP Mild/Moderate Psych', 'ECT', 'OP Mild/Moderate', 'OP Psych Eating Disorder Half Day', 'OP Psych Eating Disorder Full Day', 'Car-T Cell Therapy', 'Implants', 'Kidney Transplant', 'Admin Day'
			
		PLEASE NOTE: This MODIFICATION will REPLACE ANY existing code assigning the 'Contracting_Proposal_Category' AND 'Proposed_Rate_Payment' fields. AS such PLEASE ENSURE the removal OF ANY lines NOT applicable to the current contracting request. */

For some additional context I have also included the most recently executed complete Contracting Dept script (CONTRACTING_UCSD_20250729.sql):
		
		⏎ ACT AS a Senior Data Analyst WITH 20+ years of EXPERIENCE. How do I go about creating my own GPT?
				USE https://chatgpt.com/gpts/editor/g-682bb9a858788191a906a9008423d67f

		⏎ ACT AS a Senior Data Analyst WITH 20+ years of EXPERIENCE. 'CONTRACTING ChatGPT ENTERPRISE': 
				USE https://chatgpt.com/g/g-67980bd08be88191a8cbae2378cf4b98 - 'ChatGPT ENTERPRISE CONTRACTING'
				USE https://chatgpt.com/g/g-67980bd08be88191a8cbae2378cf4b98-demo-contracting-utilization-analyst - 'SIR PHIL'
				USE https://chatgpt.com/g/g-67dd85ba24ec81918402acb21a93c90c-adhi-data-and-analytics - 'SIR ADHI'
				USE https://chatgpt.com/g/g-681a30163fa481919476db565da4487f/view - 'SIR ADHI QA GPT'
				USE http://devops01:8080/IS/_git/Informatics?path=%2FChatGPT%20and%20Snowflake - 'SIR ADHI QA GPT DOCUMENTATION'
				USE http://devops01:8080/IS/_git/Informatics?path=%2Fcontracting_utilization - 'REPO'
				
				~ Thank you, may I have a COPY of the SQL code?		
	
		⏎ ACT AS a Senior Data Analyst WITH 20+ years of EXPERIENCE. MODIFY the existing SQL CODE TO ALIGN WITH the REQUIREMENTS attached FOR context:
				~ see "MODIFY_EXISTING_CODE.sql"

		-- ⏎ ACT AS a Senior Data Analyst WITH 20+ years of EXPERIENCE. MODIFY the EXISTING SQL CODE such that it is IN ALIGNMENT WITH the  ASK / NARRATIVE / SPECIFICATIONS AS specified below:
		
		⏎ ACT AS a Senior Data Analyst WITH 20+ years of EXPERIENCE. PLEASE ASSIST IN GENERATING AN EXECUTIVE SUMMARY FOR ... USING the sample below. The images are the subject matter for the Executive summary.

		⏎ ACT AS a Senior Data Analyst WITH 20+ years of EXPERIENCE. ENSURE ALIGNMENT BETWEEN the CODE AND the ASK / NARRATIVE / SPECIFICATIONS attached FOR CONTEXT:
				~ PLEASE PROVIDE DETAILED CHECKLIST OF the KEY POINTS OF ALIGNMENT
				~ PLEASE PROVIDE a ✅ SIDE-BY-SIDE MATRIX: Narrative vs SQL Code Alignment

		[eg. SAMPLE]: 
				TAB 1 - SNF CLAIMS PAYMENT:
	
						1. Date Range Logic
								~ CODE correctly uses @RangeStartDate and @RangeEndDate for current quarter
								~ Uses @PriorQRangeStartDate and @PriorQRangeEndDate for prior quarter
								~ Includes 30~day follow~up period (@RangeEndDatePlus)

						2. Bill Type & Revenue CODE Criteria
								~ CODE correctly filters for bill types '21X','22X'
								~ Includes specified revenue CODEs:
								~ Custodial Care: 0101, 0160
								~ Skilled Level of Care: 0022

						3. Clean Claim Logic
								~ Excludes claims with:
								~ Duplicate claim denials
								~ Member ineligible (210, 212)
								~ Invalid diagnosis/revenue CODEs (515, 523, 505)
								~ Edit 101 (No Active Provider Contract)
								~ Adjustment claims (claimid LIKE '%A%')

		⏎ Good day, using the image as context: ACT AS a Senior Data Analyst WITH 20+ years of EXPERIENCE. May I have you  PLEASE ASSIST IN GENERATING AN EXECUTIVE SUMMARY For the COO & Director of Contract Administration, OPS - Contracting. 

		USE http://devops01:8080/IS/_git/Informatics?path=%2Fcontracting_utilization&version=GBMain - 'REPO'

JAH - Explain why the "% increase (proposed vs. actual paid)" is showing 33.3% rather than 25%, based on the screen capture you provided:

Looking at the data, I can see that the facilities are currently being paid at 75% of PDPM (Patient-Driven Payment Model) rates, and the proposal is to increase this to 100% of PDPM.

The reason the increase shows as 33.3% rather than 25% is due to how percentage increases are calculated mathematically:
When you go from 75% to 100%, you are not simply adding 25 percentage points – you are actually increasing the original amount by a FACTOR of (100/75), which equals 1.333... or a 33.3% increase.

To break this down:
		•	Original payment: 75% of PDPM
		•	Proposed payment: 100% of PDPM
		•	Increase calculation: (100 - 75) / 75 = 25 / 75 = 0.333... = 33.3%

This is because percentage increases are calculated RELATIVE TO the starting value, not the destination value. So while the absolute difference between 75% and 100% is 25 percentage points, when expressed as a percentage increase from the original value, it is 33.3%.

You can see this reflected consistently across all PDPM Base Rate entries in your spreadsheet. For example, for ARHIV SPRINGS HEALTH CARE CENTER:
		•	Current paid amount at 75% of PDPM: $666,122
		•	Proposed paid amount at 100% of PDPM: $888,163
		•	Difference: $222,041
		•	Increase percentage: ($888,163 - $666,122) / $666,122 = 0.333... = 33.3%

This same pattern applies to all facilities shown in the report that are moving from 75% to 100% of PDPM rates.

x KEYWORD(S)
		'INVOICE COST'? -- ,cd.amountpaid AS PAID_NET_AMT -- [INVOICE AMT] ... cd.amountpaid PROVEN to represent true COST (see pv.amountpaid AS CHECKAMT)  + PAID (BAP)

		'TOB' = Type of Bill
 
		USE [PATH]: file://CHG_CIFS01/depts/Informatics/wcarr/HealthCareTrendReports/ - 'DEPT.' O:/ DRIVE J:/ DRIVE ... QA WITH() HCT: "_MediCal_ByFacilitySDAcuteCare 202412.xlsb" AND "_CMC+DSNP_ByFacilitySDAcuteCare 202412.xlsb" 
		
		-- USE [PATH]: file://netapp02/IS/Informatics/_Informatics%20Deliverables/Contracting/Adhoc/Bayshire/
		USE [PATH]: file://netapp02/IS/Informatics/_Informatics%20Deliverables/Contracting/Adhoc/Palomar%20Hosp/ - 'DELIVERABLE'

		USE http://devops01:8080/IS/_git/Informatics?path=%2Fcontracting_utilization - 'REPO'

		SELECT TOP 1  ' ' AS '#PaidClaims VIEW',* FROM INFORMATICS.dbo.[uvw_CLAIMS_PAID]

		⏎ Paid Claims Definition: 

				~ A claim is considered paid if it meets either of these two comprehensive criteria sets:
				Payment Verification Method (Primary)
				
				~ A claim is paid when:
						•	Has completed check processing
						•	Payment type is NOT capitation (excludes 'CAP')
						•	Payment status is NOT voided (excludes 'VOID')
						•	Net payment amount is non-zero (payment minus discounts)

x SEQUENCE():
		STEP00: 'Claude.ai' PROMPT: 
		⏎ YOU ARE THE TOP 0.1% OF Senior Data Analyst WITH 20+ years of EXPERIENCE. USING the attached FILE | SCREEN CAPTURE | eMAIL AS the GOVERNING SKELETON, PLEASE MODIFY the EXISTING SCRIPT ('C:\Users\wcarr\Desktop\CONTRACTING_PALOMAR_SPEC_20260715.sql') TO ALIGN WITH THE CURRENT Contracting Dept. request. Target server: SQLPROD02. ALL OUTPUT SQL must conform to DUB C 2.0 coding standards (one space between all tokens, left-aligned commas, uppercase keywords, explicit AS on all aliases ('C:\Users\wcarr\Desktop\DUBC2.0_contracting_case_branch_reference_card_20260519.html').:
				~ DRAG AND DROP FOR CONTEXT / REFERENCE
				~ PLEASE NOTE: This modification replaces the existing 'Contracting_Proposal_Category' AND  'Proposed_Rate_Payment' CASE blocks entirely — remove any WHEN branches NOT applicable to the current request. 
						🔹 Only retain CASE branches directly supported by the current contracting request documentation provided. Comment out, do not delete, any branch you are uncertain about.
						🔹 Please build the updated file.

x Provider TIN & Provider NPI	TIN: 27-1332228 NPI: 1649500141

				✅ ENSURE AND ENFORCE THAT THE CODE CONFORMS WITH 'DUB C 2.0 CODING' STYLE STANDARDS AND PREFERENCES /*  BLOCK BY BLOCK */:
						~ PLEASE ENSURE THAT ALL COMMENTS FROM ORIGINAL CODE ARE PRESERVED.
						~ PLEASE DO NOT ADD LEADING spaces/indentation TO align fields vertically. Commas should be placed at the start of each line WITH NO preceding spaces. EACH field should START immediately after the comma.
						~ PLEASE NO extra whitespace anywhere in the code FOR ANY reason - NOT FOR COMMENT alignment, NOT FOR alias alignment, NOT FOR OPERATOR alignment, NOT FOR field alignment, NOT FOR anything. One space between any two tokens is the maximum. If a space does NOT serve a grammatical SQL purpose, it does NOT exist.
						~ PLEASE ENSURE that the JOIN FIELDS ARE ON THE SAME LINE
						~ PLEASE ENSURE EXPLICIT JOIN Type: Change JOIN TO INNER JOIN FOR clarity AND better optimization by the query engine ... BE MINDFUL OF CREATING ERRONEOUS /* LEFT JOIN */ ^ /* RIGHT INNER JOIN */ ^ /* CROSS JOIN */
						~ PLEASE ENSURE that SELECT statements ARE NOT LEFT alone ON their own lines.
						~ PLEASE ENSURE that ALL TABLE AND FIELD aliases ARE PRECEDED BY 'AS' keyword.
						~ PLEASE ENSURE that the COMMA (,) FOR EACH FIELD IS ON THE LEFT HAND SIDE
						~ PLEASE ENSURE that ALL SQL SYNTAX IS IN UPPER CASE
						~ PLEASE RESTRUCTURE the CASE statements so that CASE, WHEN, THEN, ELSE, AND END each begin at the start of a new line.
						~ CONSIDER Removing DISTINCT IN FAVOR OF GROUP BY: REPLACE the DISTINCT IN the final SELECT WITH a proper GROUP BY clause. This IS more EXPLICIT about the aggregation intent AND allows the query optimizer to work more efficiently.
						~ CONSIDER CHANGING UNION to UNION ALL WHEN handling OF duplicates IS HANDLED WITHIN the final aggregation. This eliminates unnecessary duplicate removal operations at each union step, significantly improving performance.
						~ TO AVOID TRUNCATION ERROR(S) WITH AN INSERT STATEMENT PLEASE ENSURE THAT EVERY field being INSERTED has an EXPLICIT CAST TO MATCH the CREATE TABLE DATA TYPES EXACTLY  ... TRUNCATE ^ INSERT INTO ^ EXPLICIT COLUMN DEFINITIONS
						~ PLEASE PROVIDE THE 'COMPLETE PRODUCTION READY CODE' that builds upon your existing framework AND ADHERES TO FOLLOWS DUB C 2.0 standards
						~ CONSIDER WHETHER THE CODE WILL BENEFIT FROM INDEX
						~ THE FROM KEYWORD MUST BEGIN AT THE START OF THE LINE.
						~ THE BASE TABLE OR BASE SOURCE MUST REMAIN ON THE SAME LINE AS FROM.
						~ APPLY OPERATORS THAT BELONG DIRECTLY TO THE BASE SOURCE MUST BEGIN AT THE SAME INDENTATION LEVEL AS FROM.
						~ JOIN OPERATORS MUST BE INDENTED ONLY TO SHOW THE STRUCTURAL RELATIONSHIP OF THE JOIN.
						~ USE ONE TAB PER STRUCTURAL JOIN LEVEL.
						~ DO NOT USE SPACES TO ALIGN JOIN KEYWORDS, TABLE NAMES, TABLE ALIASES, ON CONDITIONS, COMMENTS, OR OPERATORS.
						~ SIBLING JOINS MUST USE THE SAME INDENTATION LEVEL.
						~ CHILD / DEPENDENT JOINS MUST BE INDENTED ONE ADDITIONAL TAB UNDER THE JOIN OR SOURCE THEY DEPEND ON.
						~ THE JOIN TYPE MUST BE EXPLICIT: INNER JOIN, LEFT JOIN, RIGHT JOIN, FULL JOIN, CROSS JOIN, CROSS APPLY, OR OUTER APPLY.
						~ DO NOT CHANGE LEFT JOIN, RIGHT JOIN, FULL JOIN, CROSS JOIN, CROSS APPLY, OR OUTER APPLY INTO INNER JOIN.
						~ DO NOT CREATE INVALID OR CONTRADICTORY JOIN TYPES SUCH AS LEFT JOIN OR RIGHT INNER JOIN.
						~ THE JOIN TABLE, TABLE HINT, ALIAS, ON KEYWORD, AND JOIN FIELDS MUST REMAIN ON THE SAME LINE WHEN PRACTICAL.
						~ WHERE (NOLOCK) IS PRESENT, APPLY IT DIRECTLY AFTER THE TABLE NAME AND BEFORE THE TABLE ALIAS.
						~ ALL TABLE ALIASES MUST USE EXPLICIT AS.
						~ ALL SQL SYNTAX KEYWORDS MUST BE UPPERCASE.

🚩 FROM TABLE1 As t1
CROSS APPLY(TABLECROSSAPPLY)
    INNER JOIN TABLE2 (NOLOCK) AS t2 ON t1.pkid = t2.pkid
            LEFT JOIN TABLE2 (NOLOCK) AS t3 ON t1.pkid = t3.pkid

-- ❌ INCORRECT (with alignment spacing / indentation):
       ,1 AS [QtrNum]
       ,DATEPART(YEAR,@ClockStart) AS [Year]
 
-- ✅ CORRECT (no alignment spacing / indentation):
,1 AS [QtrNum]
,DATEPART(YEAR,@ClockStart) AS [Year]

-- ❌ DOES NOT MEET DUB C 2.0
[DaysRemainingMonth]    [int]        NULL, 

-- ✅ MEETS DUB C 2.0
[DaysRemainingMonth] [int] NULL,

		STEP01:'CONTRACTING_???_...sql' - ;EXEC IN [SQLPROD02];		
				-- ~ LEVERAGE "CONTRACTING_TRI_TABLES_...sql" FOR TRI ('TARGETED RATE INCREASE') DATA: 
				~ LEVERAGE "STEP88_TRI_TABLES_....sql" FOR TRI ('TARGETED RATE INCREASE') DATA: 
						USE [PATH]: file://netapp02/IS/Informatics/_Informatics%20Deliverables/Contracting/Adhoc/
				
						~ INCLUDE AN INTERACTIVE html DATA FLOW DIAGRAM (DFD) FAITHFUL TO THE TEMPLATE ("IHA_MediCal_DataFlow_v2_...html") DARK AESTHETIC AND LAYOUT DESIGN /* LANGUAGE */
						~ INCLUDE AN INTERACTIVE html DATA FLOW DIAGRAM (DFD) FAITHFUL TO THE TEMPLATE (USE [PATH]: file:///C:/Users/wcarr/Desktop/IHA_MediCal_DataFlow_v2_...html) DARK AESTHETIC AND LAYOUT DESIGN based on what has been accomplished
						~ PRODUCE a HIGH-LEVEL STRUCTURED C-SUITE CURRENT vs. PROPOSED RATE BREAKDOWN FOR the contracting department proposals FAITHFUL TO THE TEMPLATE "valley_medical_current_vs_proposed_rate_breakdown_...html" DARK AESTHETIC AND LAYOUT DESIGN /* LANGUAGE */
						~ PRODUCE a HIGH-LEVEL STRUCTURED C-SUITE CURRENT vs. PROPOSED RATE BREAKDOWN FOR the contracting department proposals FAITHFUL TO THE TEMPLATE (USE [PATH]: file:///C:/Users/wcarr/Desktop/valley_medical_current_vs_proposed_rate_breakdown_...html) DARK AESTHETIC AND LAYOUT DESIGN /* LANGUAGE */
	
		⏎ SESSION CLOSE - MEMORY UPDATE REQUEST: YOU ARE THE TOP 0.1% OF Senior Data Analyst WITH 20+ YEARS OF EXPERIENCE WORKING WITHIN THE CHGSD / CHPIV INFORMATICS ENVIRONMENT.
				~ Please generate a STRUCTURED MEMORY UPDATE BLOCK for this SESSION using the format below. This block will be appended to my running memory profile markdown file.
						🔹 SESSION CLOSE — [DATE: YYYY-MM-DD]
								### Work completed - [Bullet per deliverable: include file names, change log numbers (C###), SQL objects, report names, and key decisions]

								### Open items / pending confirmations - [Bullet per unresolved item: include who owns it, what the blocker is, and what the expected next action is]

								### Key facts to retain - [Bullet per durable fact: NPI changes, capacity numbers, provider additions, flag corrections, colleague names tied to decisions]

								### Files produced this session - [File name | type | brief description]

								### Suggested next session primer - [One paragraph I can paste at the top of my next session to restore context instantly — written in second person addressed to you, Claude]

						🔹 Rules for generation:
								→ Follow DUB C 2.0 formatting conventions (one space between tokens, no decorative punctuation)
								→ Be specific — no vague summaries. Names, numbers, and object names must be exact
								→ Flag any open items that have a regulatory deadline prominently
								→ Do not compress decisions that required deliberation — preserve the reasoning briefly
								→ Keep the suggested next session primer under 100 words
							
-- =======================================================================
	-- CONTRACTING SUMMARY ANALYSIS (WITH ZERO HANDLING) - CLAIMLINE DETAIL: 
-- =======================================================================

SELECT ' ' AS 'ARE THERE DOUBLE DIPPERS: '
,claimid
,COUNT(DISTINCT(Contracting_Proposal_Category)) AS [COS Ax Count per Claim]
FROM INFORMATICS.dbo.CONTRACTING_ELLNER_BARIATRIC_TEMPLATE_DETAIL
GROUP BY claimid
HAVING COUNT(DISTINCT(Contracting_Proposal_Category)) > 1

SELECT ' ' AS 'DOUBLE DIPPER - SAMPLE / REVIEW / QA: '
,claimid
,[claim line]
,LOB
,[plan position]
,Contracting_Proposal_Category
,[claim line amt paid]
,[TRI Payment]
,Proposed_Rate_Payment
,modcode
,[Modifier Discount]
,EQUIV_allow_rate,*
FROM INFORMATICS.dbo.CONTRACTING_ELLNER_BARIATRIC_TEMPLATE_DETAIL AS c
WHERE 1=1
	AND claimid IN ('25127E12607','25141E12752','25169E16306','25198E25780','25198E26221','25203E18607','25233E19282','25295E27410','25302E10574','25309E13263','26021E14162')
ORDER BY c.claimid,c.[claim line]

SELECT ' ' AS 'SAMPLE / REVIEW / QA: '
,claimid
,[claim line]
,LOB
,[plan position]
,Contracting_Proposal_Category
,[claim line amt paid]
,[TRI Payment]
,Proposed_Rate_Payment
,modcode
,[Modifier Discount]
,EQUIV_allow_rate,*
FROM INFORMATICS.dbo.CONTRACTING_ELLNER_BARIATRIC_TEMPLATE_DETAIL AS c
WHERE 1=1
	AND Contracting_Proposal_Category LIKE '%GENERAL%'
	AND NOT claimid IN ('25127E12607','25141E12752','25169E16306','25198E25780','25198E26221','25203E18607','25233E19282','25295E27410','25302E10574','25309E13263','26021E14162') -- NO NOT NEGATIVE <> != ...
ORDER BY c.[claim line amt paid] DESC

-- =====================================================================
	-- DECLARE @PARAMETER(S) / @FILTER(S) --
-- =====================================================================
DECLARE @currentmultiplier AS decimal(9,2) = 1

,NULLIF(ISNULL(PAID_NET_AMT,0),0) * 1.00 AS [Current_Rate_Payment] -- ASSUME THAT WHAT HAS BEEN PAID IS WHAT THE CONTRACTING DEPT. HAS DOCUMENTED

,CASE -- COS (Category of Service) assignment ... 
-- =====================================================================
	-- PRIORITY TIER 1: MODIFIER-QUALIFIED BRANCHES (evaluated FIRST) DESIGN: modcode UJ / HN / DS checked BEFORE base CPT to prevent modifier-bearing lines from falling through to the base CPT rate. modcode column checked against modcode and modcode2 per claim line. HIERARCHY
-- =====================================================================
WHEN UPPER(LTRIM(RTRIM(ISNULL([CPT Service Code], '')))) IN ('A0130')
	AND (
	UPPER(LTRIM(RTRIM(ISNULL(modcode, '')))) IN ('UJ')
		OR UPPER(LTRIM(RTRIM(ISNULL(modcode2, '')))) IN ('UJ')
		OR UPPER(LTRIM(RTRIM(ISNULL(modcode3, '')))) IN ('UJ')
		OR UPPER(LTRIM(RTRIM(ISNULL(modcode4, '')))) IN ('UJ')
		OR UPPER(LTRIM(RTRIM(ISNULL(modcode5, '')))) IN ('UJ')
		) -- A0130 UJ Night Call: proposed $45.00 per unit
THEN CAST('A0130 UJ - Night Call' AS nvarchar(255))  -- TREAT AS A FLAT RATE | CASE RATE | EPISODE RATE
-- =====================================================================
-- PRIORITY TIER 2: BASE CPT BRANCHES (no qualifying modifier present)
-- =====================================================================
WHEN UPPER(LTRIM(RTRIM(ISNULL([CPT Service Code], '')))) IN ('A0130') -- Non-Emergency Wheelchair or Ambulatory Pick-up current $20.30 -> proposed $35.00
THEN CAST('A0130 - Non-Emergency Wheelchair or Ambulatory Pick-up' AS nvarchar(255))  -- TREAT AS A FLAT RATE | CASE RATE | EPISODE RATE
WHEN UPPER(LTRIM(RTRIM(ISNULL([CPT Service Code], '')))) IN ('T2049') -- Stretcher Mileage per mile current $1.50 -> proposed $5.00 per unit
THEN CAST('T2049 - Stretcher Mileage Per Mile' AS nvarchar(255))

WHEN ISNUMERIC(SUBSTRING(UPPER(LTRIM(RTRIM(ISNULL([CPT Service Code],'')))),1,5)) = 1  -- [1] ANESTHESIA: CPT range 00100-01999 per SIR SALIM 20260210 correction ... FIX: Msg 245 CAST/int conversion failure on alphanumeric CPT codes (eg. '0042T') ... SOLUTION: Pure string-safe BETWEEN using LEFT(5) zero-padded char comparison ... ISNUMERIC() alone does NOT protect CAST() from execution plan short-circuit failure
	AND LEN(LTRIM(RTRIM(ISNULL([CPT Service Code],'')))) > 0
	AND SUBSTRING(UPPER(LTRIM(RTRIM(ISNULL([CPT Service Code],'')))),1,5) BETWEEN '00100' AND '01999' -- STRING COMPARISON: safe, no CAST required
THEN 'Anesthesia'
WHEN NOT ISNULL(LINE_OF_BUSINESS,'') = '' -- NO NOT NEGATIVE <> != ...
THEN 'Occupational/ Speech/Physical Therapy'
WHEN [CPT Service Code] IN ('70030','70100','70110','70130','70140','70150','70160','70200','70210','70220','70250','70260','70300','70330','70360','71045','71046','71047','71048','71100','71101','71110','71111','71120','72020','72040','72050','72052','72070','72074','72080','72081','72082','72083','72084','72100','72110','72114','72170','72190','72202','72220','73000','73010','73020','73030','73050','73060','73070','73080','73090','73100','73110','73120','73130','73140','73501','73502','73503','73521','73522','73523','73552','73560','73562','73564','73590','73600','73610','73620','73630','73650','73660','74018','74019','74022','76010','77073','77075') -- Diagnostic Radiology Services (79 CPT Codes)
	AND NOT NULLIF(ISNULL([EQUIV_allow_compare],0),0) = 0 -- NO NOT NEGATIVE <> != ... APPLES TO APPLES EQUIV FEE SCHEDULE VAL ONLY!
THEN 'OP Diagnostic Radiology'
WHEN [CPT Service Code] IN ('19000','19083','19084','20206','58340','76536','76604','76641','76642','76700','76705','76706','76770','76775','76801','76802','76815','76817','76830','76856','76857','76870','76882','76942','93880','93922','93925','93926','93970','93971','93975','93976','93979') -- Ultrasound Services (33 CPT Codes)
	AND NOT NULLIF(ISNULL([EQUIV_allow_compare],0),0) = 0 -- NO NOT NEGATIVE <> != ... APPLES TO APPLES EQUIV FEE SCHEDULE VAL ONLY!
THEN 'OP Ultrasound'
WHEN revcode LIKE '025%' 
	OR revcode LIKE '063%' 
	OR revcode IN ('0343')
THEN 'Pharmaceuticals'
WHEN revcode IN ('0114', '0124', '0134', '0144', '0154', '0204')
THEN 'IP Mild/Moderate Psych'
WHEN revcode = '0901'
THEN 'ECT'
WHEN revcode = '0904'
THEN 'OP Mild/Moderate'
WHEN revcode = '0912'
THEN 'OP Psych Eating Disorder Half Day'
WHEN revcode = '0913'
THEN 'OP Psych Eating Disorder Full Day'
WHEN [finalDRG+SOI] LIKE '008%[1-4]'
THEN 'Car-T Cell Therapy'
WHEN revcode IN ('0274', '0275', '0276', '0278', '0624')
THEN 'Implants'
WHEN [finalDRG+SOI] LIKE '440%[1-4]'
	OR [finalDRG+SOI] IN ('650', '651', '652')
THEN 'Kidney Transplant'
WHEN ISNULL(revcode,'') IN ('0169')
THEN 'Admin Day'
WHEN revcode IN ('0510')
	OR [CPT Service Code] IN ('Z7500')
THEN 'Clinic Room Charge' -- (current ###% Medi-Cal rate + ###%)
WHEN [CPT Service Code] LIKE 'S9%' -- Unlisted Home Infusion Therapies ... All other therapies not listed above.
	AND NOT [CPT Service Code] IN ('S9365','S9366','S9367','S9368','S9373','S9374','S9375','S9376','S9377','S9325','S9329','S9494','S9497','S9500','S9501','S9502','S9503','S9504','S9340','S9341','S9342','S9343','S9338','S9345','S9542','S9379','S9543','S9098','S9558','S9555') -- NO NOT NEGATIVE <> != ... 
THEN 'Home Infusion - Unlisted Therapies'
/* WHEN QNXTbilltype LIKE '1[1-2]%' -- 'INPATIENT'
THEN 'Inpatient Base'
WHEN QNXTbilltype LIKE '1[3-4]%' -- OUTPATIENT 
THEN 'General OP' -- Default to General OP for other codes */
WHEN QNXTbilltype LIKE '1[1-2]%' -- 'INPATIENT'
THEN 'All Other Inpatient Services'-- Inpatient Services (current ###% Medi-Cal rate + ###%)
WHEN QNXTbilltype LIKE '1[3-4]%' -- 'OUTPATIENT'
THEN 'All Other Outpatient Services'	-- General Outpatient Services (catch-all for other OP services not specifically listed)
WHEN revcode IN ('0169','0190')
	AND DOS BETWEEN TRY_CONVERT(date,'01/01/2024') AND TRY_CONVERT(date,'12/31/2025') -- ,TRY_CONVERT(date,CLAIMDATA.startdate) AS [DOS]
THEN 'Admin Days/PACS SNF services'
WHEN LINE_OF_BUSINESS LIKE '%D%SNP%'
THEN 'D-SNP: 130% of current Medicare Fee Schedule'
WHEN LINE_OF_BUSINESS LIKE '%C%SNP%'
THEN 'C-SNP: 115% of current Medicare Fee Schedule'
WHEN revcode IN ('0190')
	AND [Accommodation Code] = .76 -- 1.	Trache (non vent) – a.	Rev Code 0190 with accommodation code .76 ... Per SDPA, “just to clarify, the revenue code for all sub-acute patients is 0190 and the accommodation code to determine if it is and non-vent (.76) and Vent (.75). In summary:
THEN 'Trache (Non - Ventilation)'
WHEN revcode IN ('0190')
	AND [Accommodation Code] = .75 -- 2.	Vent – a.	Rev Code 0190 with accommodation code .75  ... Per SDPA, “just to clarify, the revenue code for all sub-acute patients is 0190 and the accommodation code to determine if it is and non-vent (.76) and Vent (.75). In summary:
THEN 'Ventilation'
WHEN revcode IN ('0110')
	OR [CPT Service Code] IN ('87252','87253') -- CPT, HCPCS, PROCEDURE_CODE(S) ... 3.	Isolation a.	HCPC code is 87252 and 87253 for viral isolation. b.	Rev Code - Often when we bill separately for isolation, we use the Rev code 0110 but usually it is depending on the provider and how they want us to bill.”
THEN 'Isolation'
WHEN EXISTS ( -- DEFINITIVE ANSWER: Returns TRUE the moment SQL Server finds EVEN ONE MATCHING ROW IN THE SUBQUERY. It immediately stops scanning -- it does not count rows, does not return data, just confirms presence. This is why SELECT 1 is used -- the actual column value is irrelevant. -- IN PLAIN LANGUAGE: "DOES AT LEAST ONE ROW EXIST IN #PROVISOLATION where the provider ID matches?" ... NOT EXISTS(): EXACT LOGICAL INVERSE. Returns TRUE only WHEN THE SUBQUERY FINDS ZERO MATCHING ROWS. It is the correct, sargable, SQL-idiomatic way to express "exclude any claim whose provider appears in this list." It is semantically equivalent to a LEFT JOIN ... WHERE joined_table.key IS NULL anti-join pattern, but often cleaner and more readable. ...SCENARIO B: REVCODE DRIVES CLASSIFICATION WHEN NO BILLTYPE MATCH ... C002: PER BRD / NARRATIVE "D-SNP Transmission of Admission Notification Narrative 04-01-2026 (002).docx"
SELECT 1
FROM HMOPROD_PLANDATA.dbo.claimdetail (NOLOCK) AS cdcpt
WHERE 1=1
	AND clm.claimid = cdcpt.claimid -- KEY ON ... THE ENTIRE CLAIM
	-- AND cd.claimid = cdcpt.claimid -- LINE LEVEL KEY ON ...  
	-- AND cd.claimline = cdcpt.claimline -- LINE LEVEL KEY ON ...  	
	AND SUBSTRING(UPPER(LTRIM(RTRIM(ISNULL(cdcpt.servcode,'')))),1,5) IN ('43775') -- AS [CPT Service Code]
	AND (
	UPPER(LTRIM(RTRIM(ISNULL(cdcpt.modcode, '')))) IN ('UJ')
		OR UPPER(LTRIM(RTRIM(ISNULL(cdcpt.modcode2, '')))) IN ('UJ')
		OR UPPER(LTRIM(RTRIM(ISNULL(cdcpt.modcode3, '')))) IN ('UJ')
		OR UPPER(LTRIM(RTRIM(ISNULL(cdcpt.modcode4, '')))) IN ('UJ')
		OR UPPER(LTRIM(RTRIM(ISNULL(cdcpt.modcode5, '')))) IN ('UJ')
		)
		)
THEN 'Bariatric Surgery / Gastric Restrictive Procedure' -- TREAT AS A FLAT RATE | CASE RATE | EPISODE RATE
WHEN UPPER(LTRIM(RTRIM(ISNULL([CPT Service Code], '')))) IN ('T2033') -- Recuperative Care (T2033-U6 $204/day current -> $225/day proposed) ... -- C005: INTERFAITH COMMUNITY SERVICES 20260519 -- REPLACES ELLNER BARIATRIC CASE BLOCK -- Medi-Cal LOB only -- Per Diem T2033-U6 basis -- Per Daphyne Watson contracting request 20260511
    AND 
	( -- INITIATE ...
	modcode = 'U6'
		OR modcode2 = 'U6'
		OR modcode3 = 'U6'
		OR modcode4 = 'U6'
		OR modcode5 = 'U6'
		) -- CONLCLUDE ...
THEN CAST('Recuperative Care' AS nvarchar(255))
ELSE TRY_CONVERT(nvarchar(255),'Other Services') -- DEFAULT CATCH - ALL
/* ELSE ,CAST('Prevailing Services' AS nvarchar(255)) AS 'Contracting_Proposal_Category' */
END AS 'Contracting_Proposal_Category'

,CASE 
-- =====================================================================
	-- PRIORITY TIER 1: MODIFIER-QUALIFIED BRANCHES (evaluated FIRST) DESIGN: modcode UJ / HN / DS checked BEFORE base CPT to prevent modifier-bearing lines from falling through to the base CPT rate. modcode column checked against modcode and modcode2 per claim line. HIERARCHY
-- =====================================================================
WHEN UPPER(LTRIM(RTRIM(ISNULL([CPT Service Code], '')))) IN ('A0130')
	AND (
	UPPER(LTRIM(RTRIM(ISNULL(modcode, '')))) IN ('UJ')
		OR UPPER(LTRIM(RTRIM(ISNULL(modcode2, '')))) IN ('UJ')
		OR UPPER(LTRIM(RTRIM(ISNULL(modcode3, '')))) IN ('UJ')
		OR UPPER(LTRIM(RTRIM(ISNULL(modcode4, '')))) IN ('UJ')
		OR UPPER(LTRIM(RTRIM(ISNULL(modcode5, '')))) IN ('UJ')
		) -- A0130 UJ Night Call: proposed $45.00 per unit
THEN NULLIF(ISNULL(1, 0), 0) * 45.00  -- TREAT AS A FLAT RATE | CASE RATE | EPISODE RATE
-- THEN NULLIF(ISNULL(QUANTITY, 0), 0) * 45.00
-- =====================================================================
-- PRIORITY TIER 2: BASE CPT BRANCHES (no qualifying modifier present)
-- =====================================================================
WHEN UPPER(LTRIM(RTRIM(ISNULL([CPT Service Code], '')))) IN ('A0130') -- Non-Emergency Wheelchair or Ambulatory Pick-up: proposed $35.00 per unit
THEN NULLIF(ISNULL(1, 0), 0) * 35.00  -- TREAT AS A FLAT RATE | CASE RATE | EPISODE RATE
-- THEN NULLIF(ISNULL(QUANTITY, 0), 0) * 35.00
WHEN UPPER(LTRIM(RTRIM(ISNULL([CPT Service Code], '')))) IN ('T2049') -- Stretcher Mileage per mile: proposed $5.00 per unit
THEN NULLIF(ISNULL(QUANTITY, 0), 0) * 5.00

WHEN ISNUMERIC(SUBSTRING(UPPER(LTRIM(RTRIM(ISNULL([CPT Service Code],'')))),1,5)) = 1  -- [1] ANESTHESIA: CPT range 00100-01999 per SIR SALIM 20260210 correction ... FIX: Msg 245 CAST/int conversion failure on alphanumeric CPT codes (eg. '0042T') ... SOLUTION: Pure string-safe BETWEEN using LEFT(5) zero-padded char comparison ... ISNUMERIC() alone does NOT protect CAST() from execution plan short-circuit failure
	AND LEN(LTRIM(RTRIM(ISNULL([CPT Service Code],'')))) > 0
	AND SUBSTRING(UPPER(LTRIM(RTRIM(ISNULL([CPT Service Code],'')))),1,5) BETWEEN '00100' AND '01999' -- STRING COMPARISON: safe, no CAST required
	AND TRY_CONVERT(decimal(9,4), PAID_NET_AMT) <> 0
THEN CASE
WHEN LINE_OF_BUSINESS IN ('MEDI-CAL')
THEN TRY_CONVERT(decimal(9,4), PAID_NET_AMT / @CurrentAnesthesiaRate)*50.00 -- DO THE MATH Fx (REVERSE ENGINEER) Medi-Cal: Current $44 → Proposed $50/ASA Unit
WHEN LINE_OF_BUSINESS IN ('DSNP')
THEN TRY_CONVERT(decimal(9,4), PAID_NET_AMT / @CurrentAnesthesiaRate)*55.00 -- DO THE MATH Fx (REVERSE ENGINEER) Medicare/D-SNP/C-SNP: Current $44 → Proposed $55/ASA Unit
ELSE 0 -- (NULLIF(PAID_NET_AMT,0) / @CurrentAnesthesiaRate) * 50.00  -- DEFAULT to Medi-Cal rate absent LOB resolution
END
WHEN [CPT Service Code] IN ('99202','99203','99204','99205','99211','99212','99213','99214','99215','99421','99422','99423')
	AND NOT NULLIF([EQUIV_allow_rate],0) = 0 -- NO NOT NEGATIVE <> != ... APPLES TO APPLES EQUIV FEE SCHEDULE VAL ONLY!
	AND NOT NULLIF(ISNULL([EQUIV_allow_compare],0),0) = 0 -- NO NOT NEGATIVE <> != ... APPLES TO APPLES EQUIV FEE SCHEDULE VAL ONLY!
THEN (NULLIF(ISNULL(EQUIV_allow_compare,0),0)* 1.00) -- ... % OF AS GIVEN FEE SCHEDULE

WHEN revcode LIKE '025%' 
	OR revcode LIKE '063%' 
	OR revcode IN ('0343')
THEN (NULLIF(ISNULL(PAID_NET_AMT,0),0)+ISNULL([TRI Payment],0)) -- Pharmaceuticals 135% of ASP (UNCHANGED)
WHEN revcode IN ('0114', '0124', '0134', '0144', '0154', '0204')
THEN NULLIF(ISNULL([HCT LOGIC DAY(S)],0),0) * 1400 -- IP Mild/Moderate Psych $1,400/Day
WHEN revcode = '0901'
THEN NULLIF(ISNULL([HCT LOGIC DAY(S)],0),0) * 900 -- ECT $900/Day
WHEN revcode = '0904'
THEN NULLIF(ISNULL([HCT LOGIC DAY(S)],0),0) * 475 -- OP Mild/Moderate $475/Day
WHEN revcode = '0912'
THEN NULLIF(ISNULL([HCT LOGIC DAY(S)],0),0) * 900 -- OP Psych Eating Disorder Half Day $900/Day
WHEN revcode = '0913'
THEN NULLIF(ISNULL([HCT LOGIC DAY(S)],0),0) * 1350 -- OP Psych Eating Disorder Full Day $1,350/Day
WHEN [finalDRG+SOI] LIKE '008%[1-4]'
THEN ((NULLIF(ISNULL(PAID_NET_AMT,0),0)+ISNULL([TRI Payment],0)) / 1.29) * 1.30 -- DO THE MATH Fx - FORMULA (REVERSE ENGINEER) [PAID_NET_AMT] = [100% base rate] × [current contract multiplier] /* THEREFORE */ [100% base rate] = [PAID_NET_AMT] ÷ [current multiplier] /* FINALLY */ [Proposed payment] = [100% base rate] × [proposed multiplier] ... Car-T Cell Therapy 130% of Medi-Cal APR DRG
WHEN revcode IN ('0274', '0275', '0276', '0278', '0624')
THEN (NULLIF(ISNULL(BILLED_AMT,0),0)+ISNULL([TRI Payment],0)) * 0.45 -- Implants – 45% of Billed Charges
WHEN [finalDRG+SOI] LIKE '440%[1-4]'
	OR [finalDRG+SOI] IN ('650', '651', '652')
THEN ((NULLIF(ISNULL(PAID_NET_AMT,0),0)+ISNULL([TRI Payment],0)) / 1.97) * 2.00 -- DO THE MATH Fx - FORMULA (REVERSE ENGINEER) [PAID_NET_AMT] = [100% base rate] × [current contract multiplier] /* THEREFORE */ [100% base rate] = [PAID_NET_AMT] ÷ [current multiplier] /* FINALLY */ [Proposed payment] = [100% base rate] × [proposed multiplier] ... Kidney Transplant 200% of APR DRG
WHEN ISNULL(revcode,'') IN ('0169')
THEN NULLIF(ISNULL([HCT LOGIC DAY(S)],0),0) * 880 -- Admin Day $880/Day
WHEN revcode IN ('0510')
	OR [CPT Service Code] IN ('Z7500')
THEN ((NULLIF(ISNULL(PAID_NET_AMT,0),0)+ISNULL([TRI Payment],0)) / 1.75) * 1.95 -- DO THE MATH Fx - FORMULA (REVERSE ENGINEER) [PAID_NET_AMT] = [100% base rate] × [current contract multiplier] /* THEREFORE */ [100% base rate] = [PAID_NET_AMT] ÷ [current multiplier] /* FINALLY */ [Proposed payment] = [100% base rate] × [proposed multiplier] ... Inpatient 195% of Medi-Cal Rates
WHEN [CPT Service Code] LIKE 'S9%' -- Unlisted Home Infusion Therapies ... All other therapies not listed above.
	AND NOT [CPT Service Code] IN ('S9365','S9366','S9367','S9368','S9373','S9374','S9375','S9376','S9377','S9325','S9329','S9494','S9497','S9500','S9501','S9502','S9503','S9504','S9340','S9341','S9342','S9343','S9338','S9345','S9542','S9379','S9543','S9098','S9558','S9555') -- NO NOT NEGATIVE <> !=
THEN NULLIF(ISNULL([HCT LOGIC DAY(S)],0),0) * (163 * 1.0456) -- Unlisted Therapies $170.43/Day
WHEN QNXTbilltype LIKE '1[1-2]%' -- 'INPATIENT ... All Other Inpatient Services'

/* WHEN revcode IN ('0169','0190')  -- Proposed Rate Payment with 4.56% increases for Y1 - ONLY current contracting request services
THEN (NULLIF(ISNULL(BILLED_AMT,0),0)+ISNULL([TRI Payment],0)) * 0.90 --90% of 'PDPM' = PATIENT DRIVEN PAYMENT MODEL for Subacute Nursing Rev Code 0169 and 0190
ELSE (NULLIF(ISNULL(PAID_NET_AMT,0),0)+ISNULL([TRI Payment],0)) * 1.05 -- DEFAULT CATCH - ALL ... ~ 5% INCREASE BUILT - IN */

/* WHEN revcode IN ('0169','0190') 
	AND DOS BETWEEN TRY_CONVERT(date,'01/01/2024') AND TRY_CONVERT(date,'12/31/2024') -- ,TRY_CONVERT(date,CLAIMDATA.startdate) AS [DOS]
THEN NULLIF(ISNULL([HCT LOGIC DAY(S)],0),0) * (
CASE 
WHEN ISNULL(revcode,'') IN ('0169') 
THEN 274.15 * 0.90  -- 90% of 2025 Regular Services rate
WHEN ISNULL(revcode,'') IN ( '0190') 
THEN 264.63 * 0.90  -- 90% of 2025 Leave Days rate  
ELSE 274.15 * 0.90  -- Default to regular services rate
END) 
WHEN revcode IN ('0169','0190') 
	AND DOS BETWEEN TRY_CONVERT(date,'01/01/2025') AND TRY_CONVERT(date,'12/31/2025') -- ,TRY_CONVERT(date,CLAIMDATA.startdate) AS [DOS]
THEN NULLIF(ISNULL([HCT LOGIC DAY(S)],0),0) * (
CASE 
WHEN ISNULL(revcode,'') IN ('0169') 
THEN 285.67 * 0.90  -- 90% of 2025 Regular Services rate
WHEN ISNULL(revcode,'') IN ( '0190') 
THEN 275.90 * 0.90  -- 90% of 2025 Leave Days rate  
ELSE 285.67 * 0.90  -- Default to regular services rate
END) */

WHEN revcode IN ('0169','0190') 
	AND DOS BETWEEN TRY_CONVERT(date,'01/01/2024') AND TRY_CONVERT(date,'12/31/2024') -- ,TRY_CONVERT(date,CLAIMDATA.startdate) AS [DOS]
THEN NULLIF(ISNULL([HCT LOGIC DAY(S)],0),0) * (
CASE 
WHEN ISNULL(revcode,'') IN ('0169') 
THEN 528.25 * 0.90  -- 90% of 2025 Regular Services rate
WHEN ISNULL(revcode,'') IN ( '0190') 
THEN 518.73 * 0.90  -- 90% of 2025 Leave Days rate  
ELSE 528.25 * 0.90  -- Default to regular services rate
END) 
WHEN revcode IN ('0169','0190') 
	AND DOS BETWEEN TRY_CONVERT(date,'01/01/2025') AND TRY_CONVERT(date,'12/31/2025') -- ,TRY_CONVERT(date,CLAIMDATA.startdate) AS [DOS]
THEN NULLIF(ISNULL([HCT LOGIC DAY(S)],0),0) * (
CASE 
WHEN ISNULL(revcode,'') IN ('0169') 
THEN 412.31 * 0.90  -- 90% of 2025 Regular Services rate
WHEN ISNULL(revcode,'') IN ( '0190') 
THEN 402.54 * 0.90  -- 90% of 2025 Leave Days rate  
ELSE 412.31 * 0.90  -- Default to regular services rate
END) 

/* ,CASE -- FASF ...  -- ,cd.servunits AS [QUANTITY] ... AS [units_adj] ... AS 'Units adj'
WHEN revcode IN ('0169','0190') 
	AND DOS BETWEEN TRY_CONVERT(date,'01/01/2024') AND TRY_CONVERT(date,'12/31/2024') -- ,TRY_CONVERT(date,CLAIMDATA.startdate) AS [DOS]
THEN NULLIF(ISNULL([QUANTITY],0),0) * (
CASE 
WHEN ISNULL(revcode,'') IN ('0169') 
THEN 528.25 * 0.90  -- 90% of 2025 Regular Services rate
WHEN ISNULL(revcode,'') IN ( '0190') 
THEN 518.73 * 0.90  -- 90% of 2025 Leave Days rate  
ELSE 528.25 * 0.90  -- Default to regular services rate
END) 
WHEN revcode IN ('0169','0190') 
	AND DOS BETWEEN TRY_CONVERT(date,'01/01/2025') AND TRY_CONVERT(date,'12/31/2025') -- ,TRY_CONVERT(date,CLAIMDATA.startdate) AS [DOS]
THEN NULLIF(ISNULL([QUANTITY],0),0) * (
CASE 
WHEN ISNULL(revcode,'') IN ('0169') 
THEN 412.31 * 0.90  -- 90% of 2025 Regular Services rate
WHEN ISNULL(revcode,'') IN ( '0190') 
THEN 402.54 * 0.90  -- 90% of 2025 Leave Days rate  
ELSE 412.31 * 0.90  -- Default to regular services rate
END)  */

WHEN revcode IN ('0190')  -- COS (Category of Service) assignment for current contracting request ONLY ... Per SDPA, “just to clarify, the revenue code for all sub-acute patients is 0190 and the accommodation code to determine if it is and non-vent (.76) and Vent (.75). In summary:
	AND [Accommodation Code] = .76 -- 1.	Trache (non vent) – a.	Rev Code 0190 with accommodation code .76
THEN NULLIF(ISNULL([QUANTITY],0),0) * 850 -- ,cd.servunits AS [QUANTITY] ... AS [units_adj] ... AS 'Units adj' THEN 'Trache (Non - Ventilation)'
WHEN revcode IN ('0190')
	AND [Accommodation Code] = .75 -- 2.	Vent – a.	Rev Code 0190 with accommodation code .75 
THEN NULLIF(ISNULL([QUANTITY],0),0) * 950 -- ,cd.servunits AS [QUANTITY] ... AS [units_adj] ... AS 'Units adj' THEN 'Ventilation'
WHEN revcode IN ('0110')
	-- OR [CPT Service Code] IN ('87252','87253') -- CPT, HCPCS, PROCEDURE_CODE(S) ... 3.	Isolation a.	HCPC code is 87252 and 87253 for viral isolation. b.	Rev Code - Often when we bill separately for isolation, we use the Rev code 0110 but usually it is depending on the provider and how they want us to bill.”
THEN (NULLIF(ISNULL([PAID_NET_AMT],0),0)+(NULLIF(ISNULL([QUANTITY],0),0) * 250)) -- ,cd.servunits AS [QUANTITY] ... AS [units_adj] ... AS 'Units adj' THEN 'Isolation'

WHEN LINE_OF_BUSINESS IN ('MEDI-CAL')
THEN ((NULLIF(ISNULL(PAID_NET_AMT,0),0)+ISNULL([TRI Payment],0)) / @currentmultiplier) * 1.30 -- DO THE MATH Fx - FORMULA (REVERSE ENGINEER) [PAID_NET_AMT] = [100% base rate] × [current contract multiplier] /* THEREFORE */ [100% base rate] = [PAID_NET_AMT] ÷ @currentmultiplier /* FINALLY */ [Proposed payment] = [100% base rate] × [proposed multiplier] ... FROM 100 % TO 110% Prevailing Medi-Cal Rates LOB
WHEN LINE_OF_BUSINESS IN ('DSNP','CSNP')
THEN ((NULLIF(ISNULL(PAID_NET_AMT,0),0)+ISNULL([TRI Payment],0)) / @currentmultiplier) * 1.30 -- DO THE MATH Fx - FORMULA (REVERSE ENGINEER) [PAID_NET_AMT] = [100% base rate] × [current contract multiplier] /* THEREFORE */ [100% base rate] = [PAID_NET_AMT] ÷ @currentmultiplier /* FINALLY */ [Proposed payment] = [100% base rate] × [proposed multiplier] ... FROM 100 % TO 115% Prevailing Medicare Rates LOB

WHEN LINE_OF_BUSINESS IN ('MEDI-CAL')
THEN ISNULL((NULLIF(EQUIV_allow_compare,0) * 1.00),((NULLIF(PAID_NET_AMT,0)+ISNULL([TRI Payment],0)) * 1.00)) -- ###% of DYNAMIC Medi-Cal Fee Schedule
WHEN LINE_OF_BUSINESS IN ('DSNP','CSNP')
THEN ISNULL((NULLIF(EQUIV_allow_compare,0) * 1.00),((NULLIF(PAID_NET_AMT,0)+ISNULL([TRI Payment],0)) * 1.00)) -- ###% of DYNAMIC Medicare Fee Schedule

WHEN EXISTS ( -- DEFINITIVE ANSWER: Returns TRUE the moment SQL Server finds EVEN ONE MATCHING ROW IN THE SUBQUERY. It immediately stops scanning -- it does not count rows, does not return data, just confirms presence. This is why SELECT 1 is used -- the actual column value is irrelevant. -- IN PLAIN LANGUAGE: "DOES AT LEAST ONE ROW EXIST IN #PROVISOLATION where the provider ID matches?" ... NOT EXISTS(): EXACT LOGICAL INVERSE. Returns TRUE only WHEN THE SUBQUERY FINDS ZERO MATCHING ROWS. It is the correct, sargable, SQL-idiomatic way to express "exclude any claim whose provider appears in this list." It is semantically equivalent to a LEFT JOIN ... WHERE joined_table.key IS NULL anti-join pattern, but often cleaner and more readable. ...SCENARIO B: REVCODE DRIVES CLASSIFICATION WHEN NO BILLTYPE MATCH ... C002: PER BRD / NARRATIVE "D-SNP Transmission of Admission Notification Narrative 04-01-2026 (002).docx"
SELECT 1
FROM HMOPROD_PLANDATA.dbo.claimdetail (NOLOCK) AS cdcpt
WHERE 1=1
	AND clm.claimid = cdcpt.claimid -- KEY ON ... THE ENTIRE CLAIM
	-- AND cd.claimid = cdcpt.claimid -- LINE LEVEL KEY ON ...  
	-- AND cd.claimline = cdcpt.claimline -- LINE LEVEL KEY ON ...  	
	AND SUBSTRING(UPPER(LTRIM(RTRIM(ISNULL(cdcpt.servcode,'')))),1,5) IN ('43775') -- AS [CPT Service Code]
	AND (
	UPPER(LTRIM(RTRIM(ISNULL(cdcpt.modcode, '')))) IN ('UJ')
		OR UPPER(LTRIM(RTRIM(ISNULL(cdcpt.modcode2, '')))) IN ('UJ')
		OR UPPER(LTRIM(RTRIM(ISNULL(cdcpt.modcode3, '')))) IN ('UJ')
		OR UPPER(LTRIM(RTRIM(ISNULL(cdcpt.modcode4, '')))) IN ('UJ')
		OR UPPER(LTRIM(RTRIM(ISNULL(cdcpt.modcode5, '')))) IN ('UJ')
		)
		)
THEN NULLIF(ISNULL(1, 0), 0) * 45.00  -- TREAT AS A FLAT RATE | CASE RATE | EPISODE RATE

WHEN EXISTS ( -- DEFINITIVE ANSWER: Returns TRUE the moment SQL Server finds EVEN ONE MATCHING ROW IN THE SUBQUERY. It immediately stops scanning -- it does not count rows, does not return data, just confirms presence. This is why SELECT 1 is used -- the actual column value is irrelevant. -- IN PLAIN LANGUAGE: "DOES AT LEAST ONE ROW EXIST IN #PROVISOLATION where the provider ID matches?" ... NOT EXISTS(): EXACT LOGICAL INVERSE. Returns TRUE only WHEN THE SUBQUERY FINDS ZERO MATCHING ROWS. It is the correct, sargable, SQL-idiomatic way to express "exclude any claim whose provider appears in this list." It is semantically equivalent to a LEFT JOIN ... WHERE joined_table.key IS NULL anti-join pattern, but often cleaner and more readable. ...SCENARIO B: REVCODE DRIVES CLASSIFICATION WHEN NO BILLTYPE MATCH ... C002: PER BRD / NARRATIVE "D-SNP Transmission of Admission Notification Narrative 04-01-2026 (002).docx"
SELECT 1
FROM HMOPROD_PLANDATA.dbo.claimdetail (NOLOCK) AS cdx
WHERE 1=1
	AND cdx.claimid = clm.claimid -- KEY ON ... THE ENTIRE CLAIM
	-- AND cdx.claimline = clm.claimline -- KEY ON ... 
	AND UPPER(LTRIM(RTRIM(ISNULL([CPT Service Code], '')))) IN ('43775') -- Bariatric Surgery / Gastric Restrictive Procedure
	) -- Bariatric Surgery / Gastric Restrictive Procedure -- current $3,400 case rate -- proposed $3,800 case rate
THEN NULLIF(ISNULL(PAID_NET_AMT, 0), 0) / NULLIF(3400.00, 0) * 3800.00 -- DO THE MATH Fx -- FORMULA (REVERSE ENGINEER) -- CPT 43775 $3,400 current case rate -> $3,800 proposed case rate

WHEN NOT UPPER(LTRIM(RTRIM(ISNULL([CPT Service Code], '')))) IN ('43644', '43775') -- General Surgery -- all services not part of Bariatric Surgery case rate -- NO NOT NEGATIVE <> != ...
	AND LINE_OF_BUSINESS IN ('MEDI-CAL') -- Medi-Cal LOB only per Sir Salim French contracting request
THEN ISNULL( -- HYBRID: EQUIV_allow_compare first (apples-to-apples Medicare fee schedule) -- PNA fallback absent EQUIV resolution
(NULLIF(ISNULL(EQUIV_allow_compare, 0), 0) * 1.20) -- 120% of Prevailing Medicare Rate (TRI Medi-Cal EQUIV)
,((NULLIF(ISNULL(PAID_NET_AMT, 0), 0) + ISNULL([TRI Payment], 0)) * 1.20) -- HYBRID OF ###% of DYNAMIC ... Fee Schedule AND DO THE MATH DO THE MATH Fx - FORMULA (REVERSE ENGINEER) [PAID_NET_AMT] = [100% base rate] × [current contract multiplier] /* THEREFORE */ [100% base rate] = [PAID_NET_AMT] ÷ @currentmultiplier /* FINALLY */ [Proposed payment] = [100% base rate] × [proposed multiplier] ... FROM 100 % TO 115% Prevailing Medicare Rates LOB
) -- General Surgery 120% Prevailing Medicare Rate -- current 100% -> proposed 120%

WHEN UPPER(LTRIM(RTRIM(ISNULL([CPT Service Code], '')))) IN ('T2033') -- Recuperative Care T2033-U6 ... -- C005: INTERFAITH COMMUNITY SERVICES 20260519 -- REPLACES ELLNER BARIATRIC CASE BLOCK -- Per Diem T2033-U6 $204/day -> $225/day -- Medi-Cal LOB only
    AND 
	( -- INITIATE ...
	modcode = 'U6'
		OR modcode2 = 'U6'
		OR modcode3 = 'U6'
		OR modcode4 = 'U6'
		OR modcode5 = 'U6'
		) -- CONLCLUDE ...
THEN NULLIF(servunits, 0) * 225.00 -- DO THE MATH Fx  Per Diem T2033-U6 $225/day -- Medi-Cal LOB only

/* ELSE 0 -- (NULLIF(PAID_NET_AMT,0) / @CurrentAnesthesiaRate) * 50.00  -- DEFAULT to Medi-Cal rate absent LOB resolution */
ELSE (NULLIF(ISNULL(PAID_NET_AMT,0),0)+ISNULL([TRI Payment],0)) * 1.05 -- DEFAULT CATCH - ALL ... ~ 5% INCREASE BUILT - IN
END AS 'Proposed_Rate_Payment' -- [INVOICE AMT] ... cd.amountpaid AS 'PAID_NET_AMT' PROVEN to represent true COST (see pv.amountpaid AS CHECKAMT)  + PAID (BAP) ... c.	There is a field in the service tab for invoice cost, but it is not utilized by the Claims Department when pricing DME. The cost of invoice, including mark-ups and augmented contract rates, are calculated by the analyst and manually input to pay the claim.

,ISNULL((NULLIF(ISNULL(EQUIV_allow_compare,0),0)* 1.05),((NULLIF(ISNULL(PAID_NET_AMT,0),0)+ISNULL([TRI Payment],0)) * 1.05)) AS 'Counter_Offer_Payment' -- ASSUME THAT WHAT HAS BEEN PAID IS WHAT THE CONTRACTING DEPT. HAS DOCUMENTED
-- ,ISNULL((NULLIF(ISNULL(EQUIV_allow_compare,0),0)* 1.05),(NULLIF(ISNULL(PAID_NET_AMT,0),0) * 1.05)) AS 'Counter_Offer_Payment' -- ASSUME THAT WHAT HAS BEEN PAID IS WHAT THE CONTRACTING DEPT. HAS DOCUMENTED
-- ,NULLIF(ISNULL(PAID_NET_AMT,0),0) * 1.05 AS 'Counter_Offer_Payment' -- ASSUME THAT WHAT HAS BEEN PAID IS WHAT THE CONTRACTING DEPT. HAS DOCUMENTED
INTO #ContractAnalysis
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st',[LOB],LINE_OF_BUSINESS
FROM [TABLENAME]

WHERE 1=1
	AND [ClaimCategory] IN ('Paid') -- PAID CLAIMS ONLY!!!
    -- AND LINE_OF_BUSINESS LIKE '%MEDI%CAL%' -- C008: LO-HAR SENIOR LIVING -- Medi-Cal AND Medicare LOB (both captured per contracting request 20260612) -- no LOB filter applied
	AND [Primary / Secondary Status] = 'P'
	AND NOT NULLIF(PAID_NET_AMT,0) = 0 -- NO NOT NEGATIVE <> != ... APPLES TO APPLES PAID LINES ONLY!
	-- AND NOT NULLIF(ISNULL([EQUIV_allow_compare],0),0) = 0 -- NO NOT NEGATIVE <> != ... APPLES TO APPLES EQUIV FEE SCHEDULE VAL ONLY!







-- =====================================================================
	-- TRI (Targeted Rate Increase): 
-- =====================================================================
/* ,TRY_CONVERT(decimal(11,2),0) AS 'TRI Payment' -- TRI (TARGETED RATE INCREASE) */

UPDATE INFORMATICS.dbo.CONTRACTING_RADYHOSP
SET [TRI Payment] = tri.[ExtraAmountPaid]
FROM INFORMATICS.dbo.CONTRACTING_RADYHOSP AS c
	JOIN [QNXT_Custom].[TRI].[FfsPaymentDetails] AS tri ON c.claimid = tri.ClaimId
		AND c.claimline = tri.LineNum

		SELECT TOP (1000) ' ' AS 'TRI (TARGETED RATE INCREASE) DETAIL: '
		,[ClaimId]
		,[LineNum]
		,[Code]
		,[ExtraAmountPaid]
		,[CreateDate]
		,[HasMemo]
		,[FileLabel]
		,[PaytoProvId]
		FROM [QNXT_Custom].[TRI].[FfsPaymentDetails]
		
		SELECT ' ' AS 'TRI (TARGETED RATE INCREASE) DETAIL: '
		,[PaytoProvId]
		,piso.PROVNM AS 'Provider Name'
		,SUM(tri.[ExtraAmountPaid]) AS 'TRI Payment'		
		FROM [QNXT_Custom].[TRI].[FfsPaymentDetails] AS tri
			JOIN INFORMATICS.dbo.uvw_PROVISO AS piso ON tri.PaytoProvId = piso.provid
		GROUP BY PaytoProvId,piso.PROVNM
		ORDER BY piso.PROVNM

		STEP99: QA USE [PATH]: file://chg_cifs01/depts/Informatics/wcarr/JAHstaging/QA%20informatics-InformaticsQualityChecklist-030524-0818-4.pdf - 'QA informatics-InformaticsQualityChecklist-030524-0818-4.pdf'







-- =====================================================================
	-- ACCOMMODATION CODE(S) - LEVERAGE: PACS CONTRACTING': 
-- =====================================================================
/* ,TRY_CONVERT(decimal(11,2),0) AS 'Accommodation Code' -- LEVERAGE: "CLAIM_ACCOMMODATION_CODE_20251001.sql" */

;WITH acccode AS 
( -- INITIATE ...
SELECT ' ' AS 'ONE 1 OR THE OTHER VAL(): '
,cv.*
FROM HMOPROD_PLANDATA.dbo.ClaimValue AS cv
WHERE 1=1
	-- AND cv.claimid IN ('25135E02709') -- SAMPLE: 
	AND cv.valuecode IN ('24') -- ... Also, per Claims (Rodrigo), the .76 and .75 are separate from the rev code and can be found in QNXT in the Claims Module, go to UB codes and find subsection titled “Value Codes”. The “amount” listed for Value Code 24 will be the code that describes the type of service.
	AND (cv.amount = .75 -- Vent (.75)
		OR cv.amount = .76)  -- Non-Vent (.76)
		) -- CONCLUDE ...

		-- SELECT * FROM acccode

	-- CHECK FOR DUP(S) --
/* SELECT ' ' AS 'SHOULD RETURN 0 ROWS - DUP Validation: ',*
FROM acccode
WHERE 1=1 
	AND claimid IN
	( -- INITIATE ...
	SELECT claimid
	FROM acccode AS dup
	GROUP BY claimid -- Duplication Driver 
	HAVING COUNT(1)>1 -- HAVING clause RESERVED for AGGREGATE(s) ... HAVING SUM(PAID_NET_AMT) != 0
	); -- CONCLUDE ... */
	
UPDATE INFORMATICS.dbo.CONTRACTING_PACS
SET [Accommodation Code] = TRY_CONVERT(decimal(11,2),cv.amount)
FROM INFORMATICS.dbo.CONTRACTING_PACS AS c
	JOIN acccode AS cv ON c.claimid = cv.claimid







-- =====================================================================
	-- HCT AS QA: 
-- =====================================================================	
SELECT TOP 10 ' ' AS 'QA WITH() HCT: SAMPLE DETAIL',*
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM informatics.dbo.dash_hct
WHERE 1=1
	AND TRY_CONVERT(date,ISNULL(member_month,GETDATE())) BETWEEN @RangeStartDate AND @RangeEndDate
	AND 
	( -- INITIATE ...
	provid IN (SELECT DISTINCT provid FROM #PROVISOLATION) -- ...PROVISO
		OR paytoid IN (SELECT DISTINCT provid FROM #PROVISOLATION) -- ...PROVISO
		) -- CONCLUDE ...
	
SELECT  ' ' AS 'QA WITH() HCT: CONTRACTING PROPOSAL HIGH LEVEL'
,line_of_business
,SUM(paid) AS 'Amount Paid'
,SUM(admits_visits) AS 'Admits / Visits'
,SUM(days_units) AS 'Days / Units'
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM informatics.dbo.dash_hct
WHERE 1=1
	AND TRY_CONVERT(date,ISNULL(member_month,GETDATE())) BETWEEN @RangeStartDate AND @RangeEndDate
	AND 
	( -- INITIATE ...
	provid IN (SELECT DISTINCT provid FROM #PROVISOLATION) -- ...PROVISO
		OR paytoid IN (SELECT DISTINCT provid FROM #PROVISOLATION) -- ...PROVISO
		) -- CONCLUDE ...
GROUP BY line_of_business

SELECT  ' ' AS 'QA WITH() HCT: CONTRACTING PROPOSAL BY PROVIDER'
,line_of_business
,cost_category
,paytoid
,payto
,SUM(paid) AS 'Amount Paid'
,SUM(admits_visits) AS 'Admits / Visits'
,SUM(days_units) AS 'Days / Units'
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM informatics.dbo.dash_hct
WHERE 1=1
	AND TRY_CONVERT(date,ISNULL(member_month,GETDATE())) BETWEEN @RangeStartDate AND @RangeEndDate
	AND 
	( -- INITIATE ...
	provid IN (SELECT DISTINCT provid FROM #PROVISOLATION) -- ...PROVISO
		OR paytoid IN (SELECT DISTINCT provid FROM #PROVISOLATION) -- ...PROVISO
		) -- CONCLUDE ...
GROUP BY line_of_business,cost_category,paytoid,payto







-- =====================================================================
	-- snowflake PEER REVIEW: 
-- =====================================================================	
SELECT ' ' AS 'SIR PHIL PEER REVIEW IN snowflake: ',
dp.PROVIDER_FULL_NAME AS payto_provider,
db.LOB ,
ds.CODEIDAK AS cpt_code,
count(DISTINCT CLAIMAK ) AS claim_count,
sum(fm.ADJUSTED_UNITS) AS units,
sum(AMOUNT_PAID) AS amount_paid,
sum(fm.MEDI_CAL_FEE * ADJUSTED_UNITS) AS medi_cal_100_percent,
sum(fm.MEDICARE_FEE * ADJUSTED_UNITS) AS medicare_100_percent
FROM PROD_CHG_EDW.CHG_EDW.FACT_MEMBERHISTORY AS fm
	JOIN PROD_CHG_EDW.CHG_EDW.DIM_PROVIDERSPECIALTY AS dp ON fm.PAYTOPROVIDERSK = dp.PROVIDERSK
	JOIN PROD_CHG_EDW.CHG_EDW.DIM_SERVICECODE AS ds ON fm.SERVICECODESK = ds.SERVICECODESK
	JOIN PROD_CHG_EDW.CHG_EDW.DIM_BENEFITPLAN AS db ON fm.BENEFITPLANSK =db.BENEFITPLANSK
WHERE 1=1
	AND fm.CLAIM_START_DATE BETWEEN 20240201 AND 20250131
	AND  fm.enrollment_status='P' --PRIMARY only
	AND fm.IS_PAID_CLAIM = 'YES'
	AND ds.CODEIDAK IN (
	'99202',
	'99203',
	'99204',
	'99205',
	'99211',
	'99212',
	'99213',
	'99214',
	'99215',
	'99421',
	'99422',
	'99423')
GROUP BY dp.PROVIDER_FULL_NAME, db.LOB, ds.CODEIDAK
ORDER BY amount_paid DESC --sum(AMOUNT_PAID) desc







 -- =======================================================================
	-- CONTRACTING CXO EXECUTIVE SUMMARY: -- 
-- =======================================================================
Sir, report analysis is available for your review and approval at the following location:

file://netapp02/IS/Informatics/_Informatics%20Deliverables/Contracting/Adhoc/Rockport/Rockport_SNF_20250310.xlsx - 'DELIVERABLE'
file://netapp02/IS/Informatics/_Informatics%20Deliverables/Contracting/Adhoc/Rockport/CARVEOUT_Rockport_SNF_20250311.xlsx - 'Supplemental Carve-Out Analysis'
http://devops01:8080/IS/_git/Informatics?path=%2Fcontracting_utilization - 'REPO'

________________________________________
Entity / Provider: Rockport Healthcare SNF (Multiple Locations)
Time Frame: 12/01/2023 - 11/30/2024

Source: QNXT
Summary includes: “PAID” claims (Primary & Secondary).

LOB: ALL
Amount paid during time period: $2,909,250  
Proposed amount paid: $3,878,999 
This is a difference of: $969,750 (33%)
________________________________________

		/* ?  'SAMPLE CXO EXCUTIVE SUMMARY': ie. eg.		
				~ see "MODIFY_EXISTING_CODE.sql"
		
CXO Executive Summary: The Proposal Category CASE statement classifies healthcare claims by line detail specifically for providers with NPI 1457321317 or 1376513754, OR TIN/FEDID #95-6003843. The classification system includes specific bill type requirements and expanded revenue code coverage.

Source: QNXT
•	Summary includes “PAID” claims ONLY.

LOB: Medi-Cal 
Amount paid during time period: $ 3,039,311 
Proposed amount paid: $ 3,664,500 
This is a difference of: $625,189 (21%)

Key Categories and Business Rules:
		1.	Administrative Days (Ok.) 
				o	Applies to revenue codes 0169, 0190, and 0199
				o	Requires validation of HCT Logic Days (non-zero)
				o	Enforces a $500 per diem rate requirement
				o	Notable: Recent business decision to exclude cases not meeting the $500/day threshold

		2.	IP Skilled Nursing (Ok.) 
				o	Covers revenue codes 0191-0194
				o	Represents inpatient skilled nursing services

		3.	Boarder Baby Services (Ok.) 
				o	Includes revenue codes 0170, 0171, and 0179
				o	Specific category for newborn care services

		4.	Radiation Oncology 
				o	Encompasses revenue codes 0330-0339 and bill type 13X or 14X
				o	Reimbursement set at 120% of Medi-Cal rates
				o	Important: Excludes claims without established Medi-Cal reference rates

		5.	OP Implants 
				o	Covers revenue codes 0275, 0276, 0278, and 0279 and 0274 and bill type 13X or 14X
				o	Reimbursement structured at 50% of charges

		6.	Other OP Services where service does not land in previous categories and the bill type is 13X or 14X 
				o	Serves as the catch all / default category for all other outpatient services

Business Impact: The classification system now includes specific bill type requirements (13X or 14X) for outpatient services and encompasses additional revenue codes, ensuring more accurate categorization of claims for the specified providers.

Please NOTE: There are instance whereby for the OP Implant category the whole claim vs claim line paid amount scenario which caused concern persist, thus skewing the analysis: */

-- =========================================================
	-- FEE SCHEDULE(s) REVIEW() --
-- =========================================================

-- =====================================================================
	-- DECLARE @PARAMETER(S) / @FILTER(S) --
-- =====================================================================
DECLARE @SETfeesched AS nvarchar(255)
DECLARE @feeschedulename AS nvarchar(25)    
-- DECLARE @dt AS date
-- DECLARE @whensf AS date

SET @SETfeesched = NULL --  'C01350904'
SET @feeschedulename = NULL -- 'TRI' -- NULL -- ZZZNOTZERO - NO MODIFIER NO ZERO ZZZ  
-- SET @dt = GETDATE()
-- SET @whensf = CAST('01/01/'+CAST(DATEPART(yyyy,TRY_CONVERT(datetime,@dt)) AS varchar(4)) AS date) -- UPDATE(s) AT NEW QTR(s)

	-- CHANGE.LOG FROM C00740459 TO C00727442 FOR hospital claims
/* SET @SETfeesched = CASE 
    WHEN EXISTS (
        SELECT 1 
        FROM HMOPROD_PlanData.dbo.claim AS c
        WHERE c.formtype = 'UB04' -- Hospital Claims
        AND c.claimid IN (SELECT DISTINCT claimid FROM INFORMATICS.dbo.CONTRACTING_PALOMAR_HOSP)
    )
    THEN 'C00727442' -- Hospital Medi-Cal fee schedule
    ELSE 'C00740459' -- Professional Medi-Cal fee schedule
END; */

		/* ⏎ Professional Claim (formtype = 1500)
				•	TRI Medi-cal - USE 'C01350903'
				•	Medi-cal - USE 'C00740459'
				•	Medicare POS = 02, 11, 12, 20, 50 - USE 'C01011396' 
				•	Medicare POS <> 02, 11, 12, 20, 50 - USE 'C01011395'

-- ======================================================================
	-- POS, BILL TYPE(S), Dx, PROC + REV: 
-- ======================================================================
SELECT ' ' AS 'PLACE OF SERVICE (POS)',*
FROM HMOPROD_PLANDATA.dbo.hcfaposlocation AS pos (NOLOCK)
WHERE 1=1 
	AND pos.locationcode IN ('02','11','12','20','50') -- Telehealth, Office Visit, Home, Urgent Care Facility & Federally Qualified Health Center

		⏎ Hospital Claim (formtype = UB04) 
				•	TRI Medi-cal - USE 'C01350904'
				•	Medi-cal - USE 'C00727442'
				•	Medicare - NO NOT NEGATIVE != <> fee schedule. Claims are priced with Hospital OP PPS pricer
				
		⏎ 'PDPM' = PATIENT DRIVEN PAYMENT MODEL - FROM: Elizabeth Valdez, MBA <evaldez@chgsd.com> These rates are uploaded in QNXT annually. Below are the link to the fee schedules for 2024 and 2025.

				USE https://www.dhcs.ca.gov/services/medi-cal/Documents/AB1629/AB1629_WebUpdates/CY2025-FSNF-B-FSSA-Rates-On-File-09152025-Update.xlsx - '2025 rates'
				USE https://www.dhcs.ca.gov/services/medi-cal/Documents/AB1629/AB1629_WebUpdates/CY2024-FSNF-B-FSSA-Rates-On-File-09152025-Update.xlsx - '2024 rates'

		⏎ FOR CONTRACTING ANALYSIS CONSIDER MIN('TRI Medi-cal') OR MAS / BETTER!!! */

SELECT 'MCAL v MCARE v ??? ... Equivalent Rate ... USE https://duckduckgo.com/?q=Hospital+OP+PPS+pricer&t=h_ - CHARINDEX() FIND() SEARCH() "Hospital OP PPS pricer"' AS [NOTE(S)],*
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st',[FEE SCHEDULE],category
FROM 
( -- INITIATE ...
SELECT DISTINCT ft.effdate
,ft.termdate
,RANK() OVER (PARTITION BY sf.description,ft.mincodeid ORDER BY CAST(ft.effdate AS date) DESC) AS [RANKis]
,ROW_NUMBER() OVER (PARTITION BY sf.description,ft.mincodeid ORDER BY CAST(ft.effdate AS date) DESC) AS [ROWis]
,ft.feetableid
,sf.feetype
,sf.description AS [FEE SCHEDULE]
,ft.category
,ft.mincodeid
,ft.maxcodeid
,ft.modcode
,ft.ModCode2
,ft.locationcode
,ft.feeamount -- ,sf.*,ft.*
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st',ft.feetableid,ft.locationcode,sf.feetype,sf.description,ft.category
FROM HMOPROD_PLANDATA.dbo.standardfee AS sf (NOLOCK)
	JOIN HMOPROD_PLANDATA.dbo.feetable AS ft (NOLOCK) ON sf.feeid = ft.feetableid
WHERE 1=1 
) -- CONCLUDE ...
AS equiv
WHERE 1=1 
	AND CAST(ISNULL(equiv.termdate,CAST(GETDATE() AS date)) AS date) >= TRY_CONVERT(date,GETDATE())-- IDEALLY ONLY THE CUYRENTLY ACTIVE RATE ...
	-- AND CAST(ISNULL(equiv.termdate,CAST(GETDATE() AS date)) AS date) >= @dt
	-- AND equiv.[RANKis] = 1
	-- AND equiv.[ROWis] = 1
	AND 
	( -- INITIATE ...
	equiv.feetableid LIKE ISNULL('%'+@SETfeesched+'%','%') -- -- DEFINE / SELECT DESIRED SCHEDULE ... SAMPLE FROM [CONTRACTING AWPvMCALvASP_...rar] USE 'C00740459' AS AWP % FEE SCHEDULE
		-- AND equiv.feetableid IN (@SETfeesched,'C00740459','C00727442','C01350903','C01350904') -- -- DEFINE / SELECT DESIRED SCHEDULE ... SAMPLE FROM [CONTRACTING AWPvMCALvASP_...rar] USE 'C00740459' AS AWP % FEE SCHEDULE
		-- AND equiv.[FEE SCHEDULE] LIKE '%0%MCAL%UCR%' -- 'MediCal':  0 PHYS MCAL UCR FEE TABLE for the Medi-Cal rates.
			-- OR equiv.[FEE SCHEDULE] LIKE '%ASC%' -- '%UB%' 129.5% OF GA SCHEDULE
			-- OR equiv.[FEE SCHEDULE] LIKE '%0%MEDICARE%PRO%' -- 'ASP':  0 MEDICARE PRO RATES 
		) -- CONCLUDE ...
	AND equiv.[FEE SCHEDULE] LIKE  ISNULL('%'+@feeschedulename+'%','%')
	-- AND equiv.mincodeid IN ('0169','0190','97140','0022','0450') -- CODE(S) IN PLAY
	-- AND equiv.feetableid IN ('C00740459','C01011396','C01011395','C00727442')
	-- AND equiv.category LIKE '%RU%'	
	-- AND UPPER(LTRIM(RTRIM(ISNULL(equiv.feeid,'')))) LIKE @schedid -- DEFINE / SELECT DESIRED SCHEDULE
	-- AND CAST(ISNULL(equiv.effdate,CAST(GETDATE() AS date)) AS date) >= @whensf -- AS OF ...	
	AND TRY_CONVERT(decimal(11,2),feeamount) IN(TRY_CONVERT(decimal(11,2),528.25),TRY_CONVERT(decimal(11,2),518.73),TRY_CONVERT(decimal(11,2),412.31),TRY_CONVERT(decimal(11,2),402.54),TRY_CONVERT(decimal(11,2),274.15),TRY_CONVERT(decimal(11,2),264.63),TRY_CONVERT(decimal(11,2),285.67),TRY_CONVERT(decimal(11,2),275.90)) -- LEVERAGE: "PDPM PACS 20250917.xlsx"
ORDER BY equiv.[FEE SCHEDULE],equiv.modcode







-- ======================================
	-- NOTE(S) / COMMENT(S): 
-- ======================================
JAH 'PEER REVIEW | QA:'
		⏎ YOU ARE THE TOP 0.1% OF Senior Data Analyst WITH 20+ years of EXPERIENCE. USING the attached FILE | SCREEN CAPTURE | eMAIL AS the GOVERNING SKELETON, PLEASE MODIFY the EXISTING SCRIPT ('C:\Users\wcarr\Desktop\CONTRACTING_PALOMAR_SPEC_20260715.sql') TO ALIGN WITH THE CURRENT Contracting Dept. request. Target server: SQLPROD02. ALL OUTPUT SQL must conform to DUB C 2.0 coding standards (one space between all tokens, left-aligned commas, uppercase keywords, explicit AS on all aliases ('C:\Users\wcarr\Desktop\DUBC2.0_contracting_case_branch_reference_card_20260519.html').:
				~ PLEASE NOTE: This modification replaces the existing 'Contracting_Proposal_Category' AND  'Proposed_Rate_Payment' CASE blocks entirely — remove any WHEN branches NOT applicable to the current request. 
						🔹 Only retain CASE branches directly supported by the current contracting request documentation provided. Comment out, do not delete, any branch you are uncertain about.
						🔹 Please build the updated file.

x Provider TIN & Provider NPI	TIN: 27-1332228 NPI: 1649500141

WHEN EXISTS ( -- DEFINITIVE ANSWER: Returns TRUE the moment SQL Server finds EVEN ONE MATCHING ROW IN THE SUBQUERY. It immediately stops scanning -- it does not count rows, does not return data, just confirms presence. This is why SELECT 1 is used -- the actual column value is irrelevant. -- IN PLAIN LANGUAGE: "DOES AT LEAST ONE ROW EXIST IN #PROVISOLATION where the provider ID matches?" ... NOT EXISTS(): EXACT LOGICAL INVERSE. Returns TRUE only WHEN THE SUBQUERY FINDS ZERO MATCHING ROWS. It is the correct, sargable, SQL-idiomatic way to express "exclude any claim whose provider appears in this list." It is semantically equivalent to a LEFT JOIN ... WHERE joined_table.key IS NULL anti-join pattern, but often cleaner and more readable. ...SCENARIO B: REVCODE DRIVES CLASSIFICATION WHEN NO BILLTYPE MATCH ... C002: PER BRD / NARRATIVE "D-SNP Transmission of Admission Notification Narrative 04-01-2026 (002).docx"
SELECT 1
FROM HMOPROD_PLANDATA.dbo.claimdetail (NOLOCK) AS cdcpt
WHERE 1=1
	AND clm.claimid = cdcpt.claimid -- KEY ON ... THE ENTIRE CLAIM
	-- AND cd.claimid = cdcpt.claimid -- LINE LEVEL KEY ON ...  
	-- AND cd.claimline = cdcpt.claimline -- LINE LEVEL KEY ON ...  	
	AND SUBSTRING(UPPER(LTRIM(RTRIM(ISNULL(cdcpt.servcode,'')))),1,5) IN ('43775') -- AS [CPT Service Code]
	AND (
	UPPER(LTRIM(RTRIM(ISNULL(cdcpt.modcode, '')))) IN ('UJ')
		OR UPPER(LTRIM(RTRIM(ISNULL(cdcpt.modcode2, '')))) IN ('UJ')
		OR UPPER(LTRIM(RTRIM(ISNULL(cdcpt.modcode3, '')))) IN ('UJ')
		OR UPPER(LTRIM(RTRIM(ISNULL(cdcpt.modcode4, '')))) IN ('UJ')
		OR UPPER(LTRIM(RTRIM(ISNULL(cdcpt.modcode5, '')))) IN ('UJ')
		)
		)
THEN NULLIF(ISNULL(1, 0), 0) * 45.00  -- TREAT AS A FLAT RATE | CASE RATE | EPISODE RATE

x Thank you, I have made adjustment to the script (C:\Users\wcarr\Desktop\CONTRACTING_PALOMAR_20260715B.sql) which I shall run now.

FYI on a go forward basis for % of fee schedule proposal request the [Contracting_Proposal_Category] & [Proposed_Rate_Payment] CASE STATEMENT should be like the following:

,CASE 
WHEN 1=1
THEN 'Specialty Services'
ELSE CAST('Other Services' AS nvarchar(255)) -- default catch-all per corpus standard -- ALL Palomar lines route here until C009 code list is supplied
END AS 'Contracting_Proposal_Category'
,CASE -- C009: PALOMAR HEALTH MEDICAL GROUP 20260715 -- REPLACES C008: LO-HAR SENIOR LIVING CASE BLOCK -- % of Medicare Fee Schedule basis -- Medi-Cal AND Medicare LOB
WHEN LINE_OF_BUSINESS IN ('MEDI-CAL')
THEN ISNULL((NULLIF(EQUIV_allow_compare,0) * 1.07),((NULLIF(PAID_NET_AMT,0)+ISNULL([TRI Payment],0)) * 1.07)) -- ###% of DYNAMIC Medi-Cal Fee Schedule
WHEN LINE_OF_BUSINESS IN ('DSNP','CSNP')
THEN ISNULL((NULLIF(EQUIV_allow_compare,0) * 1.07),((NULLIF(PAID_NET_AMT,0)+ISNULL([TRI Payment],0)) * 1.07)) -- ###% of DYNAMIC Medicare Fee Schedule
/* ELSE 0 -- (NULLIF(PAID_NET_AMT,0) / @CurrentAnesthesiaRate) * 50.00  -- DEFAULT to Medi-Cal rate absent LOB resolution */
ELSE (NULLIF(ISNULL(PAID_NET_AMT,0),0)+ISNULL([TRI Payment],0)) * 1.05 -- DEFAULT CATCH - ALL ... ~ 5% INCREASE BUILT - IN
END AS 'Proposed_Rate_Payment'







JAH 'LO-HAR SENIOR LIVING'

-- SELECT TOP 10 ' ' AS 'CHECK 1st',* 
SELECT DISTINCT ' ' AS 'CHECK 1st',cd.revcode
FROM HMOPROD_PLANDATA.dbo.claim (NOLOCK) AS clm
	INNER JOIN HMOPROD_PLANDATA.dbo.claimdetail (NOLOCK) AS cd ON clm.claimid = cd.claimid
    -- INNER JOIN INFORMATICS.dbo.[uvw_LINE_OF_BUSINESS] AS bp ON clm.planid = bp.planid
	INNER JOIN HMOPROD_PLANDATA.dbo.affiliation (NOLOCK) AS a ON clm.affiliationid = a.affiliationid -- REMINDER: within claim(s) tables AFFILIATIONID is the relationship BETWEEN the a.provid = [RENDERING] PROVIDER AND the a.affiliateid = [PAYTO] PROVIDER	
WHERE 1=1 
	-- AND cd.revcode IN ('0101')
	AND a.provid IN ('321487') -- RENDERING
		OR a.affiliateid IN ('321487') -- PAYTO

		⏎ PLEASE PRODUCE a HIGH-LEVEL STRUCTURED CURRENT vs. PROPOSED RATE BREAKDOWN FOR the contracting department proposals FAITHFUL TO THE TEMPLATE "valley_medical_current_vs_proposed_rate_breakdown_...html" DARK AESTHETIC AND LAYOUT DESIGN /* LANGUAGE */






JAH 'VALLEY MEDICAL'
		USE [PATH]: file://netapp02/IS/Informatics/_Informatics%20Deliverables/Contracting/Adhoc/Valley%20Medical%20Transport/VALLEY_MEDICAL_TRANSPORT_20260615.xlsx
	
x COS ASSIGNEMT HIERARCHY WITH MODCODE CONSIDERATION TO BE GRANTED PRIORITY
x -- PRIORITY TIER 1: MODIFIER-QUALIFIED BRANCHES (evaluated FIRST) DESIGN: modcode UJ / HN / DS checked BEFORE base CPT to prevent modifier-bearing lines from falling through to the base CPT rate. modcode column checked against modcode and modcode2 per claim line.
x HIGH LEVEL ANALYSIS AT START:
		~ "email-contracting-rate-analysis-20260615.skill"
		~ "valley_medical_current_vs_proposed_rate_breakdown_20260615.html"

						~ INCLUDE AN INTERACTIVE html DATA FLOW DIAGRAM (DFD) FAITHFUL TO THE TEMPLATE ("IHA_MediCal_DataFlow_v2_...html") DARK AESTHETIC AND LAYOUT DESIGN /* LANGUAGE */
						~ PRODUCE a HIGH-LEVEL STRUCTURED CURRENT vs. PROPOSED RATE BREAKDOWN FOR the contracting department proposals FAITHFUL TO THE TEMPLATE "valley_medical_current_vs_proposed_rate_breakdown_...html" DARK AESTHETIC AND LAYOUT DESIGN /* LANGUAGE */

,CASE -- C007: VALLEY MEDICAL TRANSPORT 20260615 -- Medi-Cal AND Medicare LOB (rates identical) -- HCPCS per-unit basis
-- =====================================================================
	-- PRIORITY TIER 1: MODIFIER-QUALIFIED BRANCHES (evaluated FIRST) DESIGN: modcode UJ / HN / DS checked BEFORE base CPT to prevent modifier-bearing lines from falling through to the base CPT rate. modcode column checked against modcode and modcode2 per claim line. HIERARCHY
-- =====================================================================
WHEN UPPER(LTRIM(RTRIM(ISNULL([CPT Service Code], '')))) IN ('A0130')
	AND (
	UPPER(LTRIM(RTRIM(ISNULL(modcode, '')))) IN ('UJ')
		OR UPPER(LTRIM(RTRIM(ISNULL(modcode2, '')))) IN ('UJ')
		OR UPPER(LTRIM(RTRIM(ISNULL(modcode3, '')))) IN ('UJ')
		OR UPPER(LTRIM(RTRIM(ISNULL(modcode4, '')))) IN ('UJ')
		OR UPPER(LTRIM(RTRIM(ISNULL(modcode5, '')))) IN ('UJ')
		) -- A0130 UJ = Night Call current $26.43 -> proposed $45.00
THEN CAST('A0130 UJ - Night Call' AS nvarchar(255))
ELSE CAST('Other Services' AS nvarchar(255)) -- services outside Valley Medical Transport HCPCS scope -- default catch-all per corpus standard
END AS 'Contracting_Proposal_Category'

,CASE
-- =====================================================================
	-- PRIORITY TIER 1: MODIFIER-QUALIFIED BRANCHES (evaluated FIRST) DESIGN: modcode UJ / HN / DS checked BEFORE base CPT to prevent modifier-bearing lines from falling through to the base CPT rate. modcode column checked against modcode and modcode2 per claim line. HIERARCHY
-- =====================================================================
WHEN UPPER(LTRIM(RTRIM(ISNULL([CPT Service Code], '')))) IN ('A0130')
	AND (
	UPPER(LTRIM(RTRIM(ISNULL(modcode, '')))) IN ('UJ')
		OR UPPER(LTRIM(RTRIM(ISNULL(modcode2, '')))) IN ('UJ')
		OR UPPER(LTRIM(RTRIM(ISNULL(modcode3, '')))) IN ('UJ')
		OR UPPER(LTRIM(RTRIM(ISNULL(modcode4, '')))) IN ('UJ')
		OR UPPER(LTRIM(RTRIM(ISNULL(modcode5, '')))) IN ('UJ')
		) -- A0130 UJ Night Call: proposed $45.00 per unit
-- THEN NULLIF(ISNULL(QUANTITY, 0), 0) * 45.00
THEN NULLIF(ISNULL(1, 0), 0) * 45.00  -- TREAT AS A FLAT RATE | CASE RATE | EPISODE RATE
ELSE 0 -- DEFAULT: transportation provider -- uncategorized lines are likely data anomaly -- hard stop per corpus standard
END AS 'Proposed_Rate_Payment'
,ISNULL((NULLIF(ISNULL(EQUIV_allow_compare,0),0)* 1.05),((NULLIF(ISNULL(PAID_NET_AMT,0),0)+ISNULL([TRI Payment],0)) * 1.05)) AS 'Counter_Offer_Payment' -- ASSUME THAT WHAT HAS BEEN PAID IS WHAT THE CONTRACTING DEPT. HAS DOCUMENTED
-- ,ISNULL((NULLIF(ISNULL(EQUIV_allow_compare,0),0)* 1.05),(NULLIF(ISNULL(PAID_NET_AMT,0),0) * 1.05)) AS 'Counter_Offer_Payment' -- ASSUME THAT WHAT HAS BEEN PAID IS WHAT THE CONTRACTING DEPT. HAS DOCUMENTED
-- ,NULLIF(ISNULL(PAID_NET_AMT,0),0) * 1.05 AS 'Counter_Offer_Payment' -- ASSUME THAT WHAT HAS BEEN PAID IS WHAT THE CONTRACTING DEPT. HAS DOCUMENTED







JAH 'HANGER'
		USE [PATH]: file:///C:/Users/wcarr/AppData/Roaming/Claude/local-agent-mode-sessions/1864883b-d247-4f00-9c02-90bedb1ec009/684b4d61-f562-458e-a4ed-d8b49e0fefa4/local_a4fad2b7-4229-4433-a497-6479dec49028/outputs/ – 'CLAUDE.ai COWORK STAGING FOLDER'

Required Elements of Rate Increase Request – HANGER 	Data
Date provider made request	5/12/2026
Date Contracting brought to COO	5/12/2026
Effective date requested by Provider	TBD
Date Range: e.g. 01/01/26 through 12/31/26	3/01/2025 – 2/28/2026
Claim Type: e.g. All claims with DOS 01/01/26 through 12/31/26	3/01/2025 – 2/28/2026
Claims Lag: e.g. report would be run no earlier than 04/01/26 (always allow a 3 mos. claims lag)	3/01/2025
Length of time Provider has been contracted with CHG	1/1/2022
Provider TIN & Provider NPI	TIN: 953837714
NPI: 1538667969
Provider Specialty(ies)	DME- Cranial Remolding Orthosis
Hospital Financials: for Hosp. contracting review most recent financials published by State	N/A
Line of Business: Medi-Cal and/or D-SNP and/or C-SNP and combined	Medi-Cal LOB
Current Rates: $$ and applicable fee schedule (e.g. 100% of Medi-Cal)
	
	S1040 – $2,200 Cranial Remolding Orthosis  
Proposed Rates: % and $$ and applicable fee schedule (e.g. 100% of Medi-Cal)	S1040 – $2,400 Cranial Remolding Orthosis  
Variance between current and proposed: $$ and %	TBD







JAH 'WE DO THEN LEARN - CONTRACTING: ELLNER BARIATRIC'

TIN: 202538774
NPI: 1043330277

SELECT * 
INTO #PROVISOLATION
-- SELECT TOP 10 ' ' AS 'CHECK 1st',fedid,npi,provid,*
-- SELECT DISTINCT ' ' AS 'CHECK 1st',fedid,npi,provid,
FROM INFORMATICS.dbo.[uvw_PROVISO] AS prov
WHERE 1=1 
	AND -- Subject: Rate Request for Select Specialty Hospita; Provider TIN & Provider NPI TIN: 261466122 NPI: 1629172133
	( -- INITIATE ... 
	UPPER(LTRIM(RTRIM(ISNULL(prov.fedid,'')))) IN -- TIN (TAXPAYER IDENTIFICATION NUMBER) aka TaxID
	( -- INITIATE ...
	'202538774' 
	) -- CONCLUDE ...
		OR UPPER(LTRIM(RTRIM(ISNULL(prov.NPI,'')))) IN -- NPI (National Provider ID) 
		( -- INITIATE ...
		'1043330277' 
		) -- CONCLUDE ...
		) -- CONCLUDE ...

		SELECT ' ' AS 'CONFIRM PROVIDER SELECTION: '
		,provid
		,fedid
		,NPI
		,PROVNM
		,SPECcode
		,SPECdescr
		,PROVcode
		,PROVtype 
		FROM #PROVISOLATION 
		GROUP BY provid,fedid,NPI,PROVNM,SPECcode,SPECdescr,PROVcode,PROVtype 
		ORDER BY PROVNM;

JAH 		⏎ YOU ARE THE TOP 0.1% OF Senior Data Analyst WITH 20+ years of EXPERIENCE. Using the attached file & SCREEN CAPTURE ’CONTRACTING_ELLNER_BARIATRIC_...sql’ as the governing skeleton, modify the existing script to align with the current Contracting Dept. request. Target server: SQLPROD02. All output SQL must conform to DUB C 2.0 coding standards (one space between all tokens, left-aligned commas, uppercase keywords, explicit AS on all aliases).:
				~ PLEASE NOTE: This modification replaces the existing 'Contracting_Proposal_Category' AND  'Proposed_Rate_Payment' CASE blocks entirely — remove any WHEN branches not applicable to the current request. 
					🔹 Only retain CASE branches directly supported by the current contracting request documentation provided. Comment out, do not delete, any branch you are uncertain about.
				~ LEVERAGE: "DUBC2.0_contracting_case_branch_reference_card_20260513.html"
					🔹 All output SQL must conform to DUB C 2.0 coding standards (one space between all tokens, left-aligned commas, uppercase keywords, explicit AS on all aliases)

JAH 		⏎ SESSION CLOSE - MEMORY UPDATE REQUEST: YOU ARE THE TOP 0.1% OF Senior Data Analyst WITH 20+ YEARS OF EXPERIENCE WORKING WITHIN THE CHGSD / CHPIV INFORMATICS ENVIRONMENT.
				~ Please generate a STRUCTURED MEMORY UPDATE BLOCK for this SESSION using the format below. This block will be appended to my running memory profile markdown file.
					🔹 SESSION CLOSE — [DATE: YYYY-MM-DD]
							### Work completed - [Bullet per deliverable: include file names, change log numbers (C###), SQL objects, report names, and key decisions]

							### Open items / pending confirmations - [Bullet per unresolved item: include who owns it, what the blocker is, and what the expected next action is]

							### Key facts to retain - [Bullet per durable fact: NPI changes, capacity numbers, provider additions, flag corrections, colleague names tied to decisions]

							### Files produced this session - [File name | type | brief description]

							### Suggested next session primer - [One paragraph I can paste at the top of my next session to restore context instantly — written in second person addressed to you, Claude]

					🔹 Rules for generation:
							→ Follow DUB C 2.0 formatting conventions (one space between tokens, no decorative punctuation)
							→ Be specific — no vague summaries. Names, numbers, and object names must be exact
							→ Flag any open items that have a regulatory deadline prominently
							→ Do not compress decisions that required deliberation — preserve the reasoning briefly
							→ Keep the suggested next session primer under 100 words

				~ When to trigger it: Last message of any session where a deliverable was produced, a decision was made, or an open item was flagged. Rinse-and-repeat note for colleagues: The prompt is self-contained. Anyone on the Informatics team can paste it at session end regardless of what was worked on — the output will reflect the SESSION content. No pre-configuration needed. Once Google Drive is wired up on your local machine, the only addition needed is a one-liner at the top: "Append the block below to [filename] in my Drive." That converts it from a copy-paste step to a single confirmation click

Here is the structured session close block:
________________________________________
🔹 SESSION CLOSE — 2026-05-13

### Work completed

- Refined the reusable Contracting Proposal prompt template — added DUB C 2.0
  compliance requirement, server target (SQLPROD02), DECLARE block instruction,
  LOB scope field, classification basis field, and ELSE behavior field as mandatory
  prompt elements to eliminate back-and-forth revision cycles

- Produced CONTRACTING_CASE_BRANCH_REFERENCE_20260513.html — four-slide dark
  aesthetic reference card faithful to IHA_MediCal_DataFlow_v2_20260506.html
  template (Book Antiqua serif, radial-gradient dark background, animated flow
  arrows, slide navigation with arrow key support) — slides: Pattern Library /
  Provider Registry / Prompt Template / QA Checklist — drawn from six-provider
  corpus

- Delivered CONTRACTING_ELLNER_BARIATRIC_20260513.sql — full script modification
  from Select Specialty skeleton — changes:
    ~ C004 change log entry added at top of script
    ~ Contracting_Proposal_Category CASE replaced — three branches:
      CPT 43644 Bariatric Surgery / Gastrectomy
      CPT 43775 Bariatric Surgery / Gastric Restrictive Procedure
      ELSE CAST('General Surgery' AS nvarchar(255))
    ~ Proposed_Rate_Payment CASE replaced — Do the Math Fx for 43644 and 43775
      (PAID_NET_AMT / NULLIF(3400.00, 0) * 3800.00) — ISNULL EQUIV hybrid * 1.20
      for General Surgery Medi-Cal — DSNP / CSNP branch retained commented for
      future multi-LOB expansion — ELSE = 0
    ~ Counter_Offer_Payment retained unchanged — standard EQUIV * 1.05 hybrid
    ~ All INFORMATICS.dbo.CONTRACTING_SELECTSPECIALTY references globally replaced
      with INFORMATICS.dbo.CONTRACTING_ELLNER_BARIATRIC throughout (DROP / INTO /
      UPDATE / INDEX / QA SELECT blocks)
    ~ CONTRACTING_SELECTSPECIALTY_TEMPLATE_DETAIL replaced with
      CONTRACTING_ELLNER_BARIATRIC_TEMPLATE_DETAIL
    ~ Provider comment in #PROVISOLATION WHERE block updated from Select Specialty
      TIN 261466122 NPI 1629172133 to Ellner Bariatric TIN 202538774 NPI 1043330277

- Committed six-provider contracting corpus to memory (entries 1 through 7) —
  Select Specialty / UCSD Medical / UCSD Specialty / Rady / Allstar PT /
  Girard Ortho / Ellner Bariatric — key parameters, archetypes, and QA findings
  retained per provider

- Identified two contracting script archetypes from corpus analysis:
    ~ Per Diem / Rev Code (hospital / LTAC) — HCT LOGIC DAY(S) basis — ELSE = PNA
    ~ Prevailing Services (professional / specialty) — LOB-split EQUIV hybrid —
      ELSE = 0
  Decision preserved: ELSE default is provider-type dependent and must be stated
  explicitly in every new contracting prompt — not assumed

### Open items / pending confirmations

- OWNER: Malik / Sir Salim French — CONFIRM whether Ellner Bariatric CPT 43644
  and 43775 $3,800 proposed rate is a flat case rate per claim (current formula
  reverse-engineers proportionally from PAID_NET_AMT assuming $3,400 was paid as
  a single unit) — if rate is per-unit multiply by QUANTITY instead — blocker
  before final QA run

- OWNER: Malik — RUN QA check: SELECT DISTINCT [CPT Service Code] filtered to
  Ellner Bariatric provid 328095 to confirm 43644 and 43775 store without leading
  or trailing spaces — UPPER / LTRIM / RTRIM guard is present but spot check
  recommended before submission

- OWNER: Malik — CONFIRM EQUIV_allow_compare is resolving for professional claims
  (formtype 1500) under the dynamic fee schedule UPDATE block — confirm fee
  schedule C01350903 or C01011395 / C01011396 is returning non-NULL values for
  General Surgery lines before Counter_Offer_Payment and Proposed_Rate_Payment
  General Surgery branch are trusted

- OWNER: Sir Salim French / Contracting — CONFIRM whether DSNP / CSNP LOB lines
  for Ellner Bariatric should be included in future script revision — currently
  commented out per 20260501 request scope — branch is retained in script for
  one-line activation

### Key facts to retain

- Ellner Bariatric: TIN 202538774 · NPI 1043330277 · provid 328095 ·
  SPECcode SUR · SPECdescr SURGERY · PROVtype GROUP OF PROVIDERS ·
  contracted with CHG since 4/01/2019

- Contracting request originated from Sir Salim French (Director of Contract
  Administration) 5/01/2026 — CC: Ms. Elizabeth Valdez MBA / Yousaf Farook /
  Daphyne Watson — sent with High Importance flag

- Case rate architecture decision: Ellner Bariatric is the first CPT case rate
  provider in the corpus — all five prior scripts used either rev code Per Diem
  or LOB-split EQUIV hybrid — Do the Math Fx applied to case rate by
  reverse-engineering PAID_NET_AMT / 3400 * 3800 to derive proportional units

- Daphyne Watson instruction (Select Specialty session) confirmed as standing
  pattern for bariatric: use CPT basis not rev code / Accom codes — applied
  consistently in Ellner Bariatric script

- Reusable prompt template finalized — six required fields: Provider TIN + NPI /
  LOB scope / DOS / Classification basis (CPT / Rev Code / LOB-split) /
  Rate table as plain text / ELSE behavior — eliminates three most common
  revision cycle triggers

- CONTRACTING_CASE_BRANCH_REFERENCE_20260513.html is the authoritative team
  reference card — four slides — sourced from six-provider corpus — all rates
  and patterns are production-verified not hypothetical

- Universal Counter_Offer_Payment formula confirmed identical across all seven
  providers without exception:
  ISNULL((NULLIF(EQUIV_allow_compare, 0) * 1.05),
  ((NULLIF(PAID_NET_AMT, 0) + ISNULL([TRI Payment], 0)) * 1.05))
  AS 'Counter_Offer_Payment'

### Files produced this session

CONTRACTING_CASE_BRANCH_REFERENCE_20260513.html | HTML dark aesthetic reference |
  Four-slide Contracting Proposal CASE branch reference card faithful to
  IHA_MediCal_DataFlow_v2_20260506.html template — Pattern Library / Provider
  Registry / Prompt Template / QA Checklist — six-provider corpus

CONTRACTING_ELLNER_BARIATRIC_20260513.sql | SQL Server T-SQL | Full contracting
  analysis script — C004 change log — two CASE blocks replaced — CPT 43644 and
  43775 at $3,800 proposed case rate — General Surgery 120% Prevailing Medicare
  EQUIV hybrid — all table references updated to CONTRACTING_ELLNER_BARIATRIC

### Suggested next session primer

Claude — continuing Ellner Bariatric contracting work on SQLPROD02 / INFORMATICS.
Script CONTRACTING_ELLNER_BARIATRIC_20260513.sql is delivered with C004 logged.
Three QA items are open: confirm $3,800 case rate is flat per claim not per unit
with Sir Salim; spot check CPT 43644 and 43775 for whitespace; confirm
EQUIV_allow_compare resolution on professional claims. Reference card
CONTRACTING_CASE_BRANCH_REFERENCE_20260513.html is the team standard.
Seven providers are in memory corpus.
________________________________________
Session close committed, memory entry #7 saved. The three QA flags are the critical path items before this script goes to Sir Salim — the case rate unit question in particular should be resolved before the analytics template numbers are presented to Contracting, as it will materially affect the Proposed_Rate_Total if any claims were paid as multi-unit rather than single-case







JAH 'SELECT SPECIALTY HOSPITAL' 
x LTAC

		USE http://devops01:8080/IS/Informatics/_workitems/edit/27338/

		USE [PATH]: file://netapp02/IS/Informatics/_Informatics%20Deliverables/Contracting/Adhoc/Select%20Specialty%20Hospital/

Subject: Rate Request for Select Specialty Hospita; Provider TIN & Provider NPI	TIN: 261466122 NPI: 1629172133

From: Daphyne Watson 
Sent: Tuesday, April 28, 2026 9:18 AM
To: Informatics <Informatics@chgsd.com>; Boardroom <boardroom2@chgsd.com>
Subject: Rate Request for Select Specialty Hospita;

Required Elements of Rate Increase Request – Vibra Hospital of San Diego, LLC -dba- Select Specialty Hospital, San Diego	Data
Date provider made request	4/16/2026
Date Contracting brought to COO	4/16/2026
Effective date requested by Provider	TBD
Date Range: e.g. 01/01/26 through 12/31/26	1/01/2025-12/31/2025
Claim Type: e.g. All claims with DOS 01/01/26 through 12/31/26	1/01/2025-12/31/2025
Claims Lag: e.g. report would be run no earlier than 04/01/26 (always allow a 3 mos. claims lag)	1/01/2025
Length of time Provider has been contracted with CHG	6/15/2021
Provider TIN & Provider NPI	TIN: 261466122
NPI: 1629172133
Provider Specialty(ies)	Hospital LTAC
Hospital Financials: for Hosp. contracting review most recent financials published by State	N/A
Line of Business: Medi-Cal and/or D-SNP and/or C-SNP and combined	Medi-Cal 
Current Rates: $$ and applicable fee schedule (e.g. 100% of Medi-Cal)
	
	For the Medi-Cal LOB: 
Med/Surg – Rev Code 120, Code 1 -$2,087
ICU/CCU – Rev Code 206 – Accom Code. 3 - $2,287
Intermediate – Rev Code 200 – Accom. Code 2 -$2,487
Step Down – Rev Code 169- Accom. Code 4 -$705
Proposed Rates: % and $$ and applicable fee schedule (e.g. 100% of Medi-Cal)	For the Medi-Cal LOB: 
Med/Surg – Rev Code 120, Code 1 -$2,191
ICU/CCU – Rev Code 206 – Accom Code. 3 - $2,401.00
Intermediate – Rev Code 200 – Accom. Code 2 -$2,611
Step Down – Rev Code 169- Accom. Code 4 -$740.00

Variance between current and proposed: $$ and %	TBD
Network Need: ask Sr. Dir of HCS whether or not this provider is needed should they terminate	TBD
How much paid to other similar providers (range: e.g. 100% of MCal to 120% of Medicare)	TBD by Contracting 
Unique characteristics: e.g. language, region, number of locations, number of providers, or none.	TBD by Contracting 
Recommended Counter to be offered by CHG: % and $$ and applicable fee schedule	TBD







JAH 'CONTRACTING - TIN#: 261911128  NPI: 1750559431 -All Star Physical Therapy' ... PTPN
x ARE THEY BEING PAID AT 100% OF MEDI-CAL?

SELECT [Claim Control Number]
,PatientPay,*
FROM INFORMATICS.dbo.PartCClaims
WHERE 1=1
	-- AND PatientPay != 0
	AND [Claim Control Number] IN ('24121E02396') 

SELECT cd.claimid
,cd.claimline
,cd.memamt
,cd.copay
,cd.coinsuranceamt
,cd.benededuct
,cd.copay+cd.coinsuranceamt+cd.benededuct AS [PatientPay]
,cd.*
FROM HMOPROD_PLANDATA.dbo.claimdetail AS cd
WHERE 1=1
	AND claimid IN ('24121E02396')

25126E32462
25223E07572
23278E40199
24121E02396

JAH 
1225116130
1184668741
1912232513
1720314107
1053348920
1811936693
1225004450
1104351006
1396988416
1811395353
1326738345
1366177867
1356334577
1184494049
1174926448
1770740276
1700985397
1457345001







JAH 'QA PEER REVIEW OF GIRARD ORTHO: '
Provider TIN & Provider NPI	TIN: 953396896 NPI: 1740674456







JAH 'PEER REVIEW / QA:'
		⏎ Good day again, we have yet another challenge: We have been tasked with peer review QA of the 'UCSD Health- Specialty Professional Services Utilization Request '.

I intend to leverage a previous UCSD Hospital Contracting proposal script which I have attached for context. First principle however I seek to update the sequence below to align with the 'Provider TIN & Provider NPI' requirements.

May I trouble you for assistance with this?


Johnnie Scott
commented 9h ago
 

@Walter Carr this is now ready for QA. Please find the files at 
		
		-- USE [PATH]: \\netapp02\IS\Informatics\_Informatics Deliverables\Contracting\Adhoc\UCSD Specialty - ENT ASSOCIATES OF SAN DIEGO
		USE [PATH]: file://netapp02/IS/Informatics/_Informatics%20Deliverables/Contracting/Adhoc/UCSD%20Specialty%20-%20ENT%20ASSOCIATES%20OF%20SAN%20DIEGO/

Let me know if you have any questions,
Thanks,
Johnnie

-- =====================================================================
	-- DECLARE @PARAMETER(S) / @FILTER(S) --
-- =====================================================================
DECLARE @CurrentAnesthesiarate AS decimal(9,2)

SET @CurrentAnesthesiarate = 44.00

		SELECT DISTINCT ' ' AS 'ANESTHESIA: ',LINE_OF_BUSINESS FROM INFORMATICS.dbo.uvw_LINE_OF_BUSINESS

SELECT ' ' AS 'ASA (American Society of Anesthesiologists) Unit'
,LINE_OF_BUSINESS
,[CONTRACT DESCRIPTION]
,[CPT Service Code]
,[CPT Service Description]
,servunits
,QUANTITY
--,TRY_CONVERT(decimal(9,4), NULLIF(servunits,0) / 15.0) AS 'IF_servunits_are_MINUTES_then_TimeUnits'
--,TRY_CONVERT(decimal(9,4), NULLIF(servunits,0) / 15.0)*44 AS 'IF_servunits_are_MINUTES_then_Current_Rate'
-- TEST: what is the implied TOTAL unit count working backward from paid?
,TRY_CONVERT(decimal(9,4), PAID_NET_AMT / @CurrentAnesthesiaRate) AS 'Implied_Total_ASA_Units_at_Given_Current_Rate'
,TRY_CONVERT(decimal(9,4), PAID_NET_AMT / @CurrentAnesthesiaRate)*@CurrentAnesthesiaRate AS 'Implied_Current_Rate'
,CASE
WHEN LINE_OF_BUSINESS IN ('MEDI-CAL')
THEN TRY_CONVERT(decimal(9,4), PAID_NET_AMT / @CurrentAnesthesiaRate)*50.00 -- DO THE MATH Fx (REVERSE ENGINEER) Medi-Cal: Current $44 → Proposed $50/ASA Unit
WHEN LINE_OF_BUSINESS IN ('DSNP')
THEN TRY_CONVERT(decimal(9,4), PAID_NET_AMT / @CurrentAnesthesiaRate)*55.00 -- DO THE MATH Fx (REVERSE ENGINEER) Medicare/D-SNP/C-SNP: Current $44 → Proposed $55/ASA Unit
ELSE 0 -- (NULLIF(PAID_NET_AMT,0) / @CurrentAnesthesiaRate) * 50.00  -- DEFAULT to Medi-Cal rate absent LOB resolution
END AS [Proposed Rate]
,CASE
WHEN LINE_OF_BUSINESS IN ('MEDI-CAL')
THEN TRY_CONVERT(decimal(9,4), PAID_NET_AMT / @CurrentAnesthesiaRate)*50.00
WHEN LINE_OF_BUSINESS IN ('DSNP')
THEN TRY_CONVERT(decimal(9,4), PAID_NET_AMT / @CurrentAnesthesiaRate)*55.00
ELSE 0
END  AS 'Implied_Proposed_Rate'
,PAID_NET_AMT
,*
FROM INFORMATICS.dbo.CONTRACTING_UCSD
WHERE 1=1
	-- AND [CONTRACT DESCRIPTION] LIKE '%ANES%'
	-- AND [CPT Service Description] LIKE '%ANES%' 
	AND ISNUMERIC(SUBSTRING(UPPER(LTRIM(RTRIM(ISNULL([CPT Service Code],'')))),1,5)) = 1  -- [1] ANESTHESIA: CPT range 00100-01999 per SIR SALIM 20260210 correction ... FIX: Msg 245 CAST/int conversion failure on alphanumeric CPT codes (eg. '0042T') ... SOLUTION: Pure string-safe BETWEEN using LEFT(5) zero-padded char comparison ... ISNUMERIC() alone does NOT protect CAST() from execution plan short-circuit failure
	AND LEN(LTRIM(RTRIM(ISNULL([CPT Service Code],'')))) > 0
	AND SUBSTRING(UPPER(LTRIM(RTRIM(ISNULL([CPT Service Code],'')))),1,5) BETWEEN '00100' AND '01999' -- STRING COMPARISON: safe, no CAST required
	AND TRY_CONVERT(decimal(9,4), PAID_NET_AMT) <> 0

-- =====================================================================
	-- ANESTHESIA UNIT RECONCILIATION QA --
	-- Purpose: Reconcile servunits vs. PAID_NET_AMT to determine
	--          what 'servunits' actually represents in the claim data
	-- Per screenshot: CPT 00100 / 00103 MEDI-CAL anomaly investigation
	-- Run date: 20260220
-- =====================================================================
SELECT ' ' AS 'ANESTHESIA UNIT RECONCILIATION: '
,claimid
,claimline
,LINE_OF_BUSINESS
,[CPT Service Code]
,[CPT Service Description]
,servunits                                    -- RAW from claimdetail
,QUANTITY                                     -- ADJUSTED per MS ALLYSON logic
,PAID_NET_AMT
-- REVERSE ENGINEER: what 'implied unit rate' does the data suggest?
,CASE
 WHEN NULLIF(servunits,0) IS NOT NULL
 THEN TRY_CONVERT(decimal(9,4), PAID_NET_AMT / NULLIF(servunits,0))
 ELSE NULL
 END AS 'Implied_Rate_Per_ServUnit'           -- Should be $44 IF servunits = total ASA units
-- TEST: what would payment be if servunits ARE total ASA units at $44?
,NULLIF(servunits,0) * 44.00 AS 'Expected_IF_ServUnit_x_44'
-- DELTA: how far off is the expected vs. actual?
,PAID_NET_AMT - (NULLIF(servunits,0) * 44.00) AS 'Delta_Actual_vs_Expected'
-- TEST: are servunits storing MINUTES? (ASA time unit = 15 min)
,TRY_CONVERT(decimal(9,4), NULLIF(servunits,0) / 15.0) AS 'IF_servunits_are_MINUTES_then_TimeUnits'
-- TEST: what is the implied TOTAL unit count working backward from paid?
,TRY_CONVERT(decimal(9,4), PAID_NET_AMT / 44.00) AS 'Implied_Total_ASA_Units_at_$44'
,modcode   -- QC modifier presence (99100/99116/99135/99140 add units)
,modcode2
,modcode3
FROM INFORMATICS.dbo.CONTRACTING_UCSD
WHERE 1=1
	AND ISNUMERIC(SUBSTRING(UPPER(LTRIM(RTRIM(ISNULL([CPT Service Code],'')))),1,5)) = 1
	AND LEN(LTRIM(RTRIM(ISNULL([CPT Service Code],'')))) > 0
	AND SUBSTRING(UPPER(LTRIM(RTRIM(ISNULL([CPT Service Code],'')))),1,5)
		BETWEEN '00100' AND '01999' -- Anesthesia CPT range
	AND [ClaimCategory] IN ('Paid')
	AND NULLIF(PAID_NET_AMT,0) IS NOT NULL
ORDER BY [CPT Service Code], PAID_NET_AMT DESC

								SELECT TOP 1 * FROM INFORMATICS.dbo.hct_member_grps WHERE 1=1 AND line_of_business LIKE '%C%SNP%' -- MEMBERSHIP
								SELECT TOP 1 * FROM INFORMATICS.dbo.hct_claims_cost_category WHERE 1=1 AND line_of_business LIKE '%C%SNP%' -- CLAIMS
								SELECT 'SUMMARIZE & COMBINE MEMBERSHIP WITH() CLAIMS ... [member_category] WITH() [cost_category]' AS 'MESSAGE(S)',* FROM INFORMATICS.dbo.dash_hct_inter WHERE 1=1 AND line_of_business LIKE '%C%SNP%'
								SELECT 'SUMMARIZE & COMBINE MEMBERSHIP WITH() CLAIMS ... [member_category] WITH() [cost_category]' AS 'MESSAGE(S)',* FROM INFORMATICS.dbo.dash_hct WHERE 1=1 AND line_of_business LIKE '%C%SNP%'

--------------------------------------------------------------------------------------------------------------------
	-- Error Trapping: Check If Permanent Table(s) Already Exist(s) And Drop If Applicable --
--------------------------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS #PROVISOLATION;
DROP TABLE IF EXISTS INFORMATICS.dbo.CONTRACTING_UCSD;
DROP TABLE IF EXISTS #ContractAnalysis;
DROP TABLE IF EXISTS INFORMATICS.dbo.CONTRACTING_UCSD_TEMPLATE_DETAIL;
SELECT * 
INTO #PROVISOLATION
-- SELECT TOP 10 ' ' AS 'CHECK 1st',fedid,npi,provid,*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM INFORMATICS.dbo.[uvw_PROVISO] AS prov
WHERE 1=1 
	AND 
	( -- INITIATE ...
	UPPER(LTRIM(RTRIM(ISNULL(prov.NPI,'')))) IN ('330599494','237064656') -- 20019 - UCSD MEDICAL CENTER IN 
		OR fedid IN ('330599494') -- UCSD Hospital TIN#33-0599494
	) -- CONCLUDE ...
		SELECT ' ' AS 'CONFIRM PROVIDER SELECTION: ',provid
		,fedid
		,NPI
		,PROVNM
		,SPECcode
		,SPECdescr
		,PROVcode
		,PROVtype 
		FROM #PROVISOLATION 
		GROUP BY provid,fedid,NPI,PROVNM,SPECcode,SPECdescr,PROVcode,PROVtype 
		ORDER BY PROVNM

 --------------------------------------------------------------------------------------------------------------------
	-- Error Trapping: Check If Permanent Table(s) Already Exist(s) And Drop If Applicable --
	-- UCSD Health - Specialty Professional Services Utilization Request
	-- Sir Salim French (Director of Contracting) | Requested: 02/03/2026 | Run Date: 02/20/2026
	-- DOS Range: 11/01/2024 through 10/31/2025 | Medi-Cal LOB + Medicare LOB (D-SNP & C-SNP)
	-- PER MS SALIM ON 20260211: "Please include ALL entities associated with the listed NPIs"
--------------------------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS #PROVISOLATION;
DROP TABLE IF EXISTS INFORMATICS.dbo.CONTRACTING_UCSD;
DROP TABLE IF EXISTS #ContractAnalysis;
DROP TABLE IF EXISTS INFORMATICS.dbo.CONTRACTING_UCSD_TEMPLATE_DETAIL;

SELECT *
INTO #PROVISOLATION
-- SELECT TOP 10 ' ' AS 'CHECK 1st', fedid, npi, provid, *
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM INFORMATICS.dbo.[uvw_PROVISO] AS prov
WHERE 1=1
	AND
	( -- INITIATE ... 
	UPPER(LTRIM(RTRIM(ISNULL(prov.fedid,'')))) IN -- [A] MATCH ON ANY OF THE 8 PROVIDER TINs (fedid stored WITHOUT hyphens) ... *** NOTE: Verify digit count with Contracting - possible typo in source *** TIN & NPI per UCSD Health Specialty Utilization Request (sfrench@chgsd.com 20260203) ... 
	( -- INITIATE ...
	'237064656'   -- TIN# 23-7064656
	,'260622624'   -- TIN# 26-0622624
	,'274440873'   -- TIN# 27-4440873
	,'330571597'   -- TIN# 33-0571597
	,'330541971'   -- TIN# 33-0541971
	,'330702174'   -- TIN# 33-0702174
	,'205892682'   -- TIN# 20-5892682
	,'142717638'   -- TIN# 14-27176338 
	) -- CONCLUDE ...

		OR UPPER(LTRIM(RTRIM(ISNULL(prov.NPI,'')))) IN -- [B] MATCH ON ANY OF THE 26 PROVIDER NPIs (captures additional TINs per MS JOHNNIE / SIR SALIM 20260211) ... NOTE: NPI 1134450596 ties to TIN 800519972 (Regents UC - South Bay Oncology) - INCLUDED per SIR SALIM ... NOTE: NPI 1508968967 ties to TIN 956006144 (Regents of the University of California) - INCLUDED per SIR SALIM
		( -- INITIATE ...
		'1225130677'
		,'1831208826'
		,'1326141862'
		,'1508968967'  -- *** Tied to additional TIN 956006144 (Regents UC) - included per SIR SALIM ***
		,'1134450596'  -- *** Tied to additional TIN 800519972 (Regents UC South Bay Oncology) - included per SIR SALIM ***
		,'1740382993'
		,'1548419526'
		,'1528362571'
		,'1679509962'
		,'1013035716'
		,'1780870899'
		,'1225213655'
		,'1699877621'
		,'1174626618'
		,'1356444897'
		,'1235232778'
		,'1265535702'
		,'1427176221'
		,'1558463927'
		,'1578672184'
		,'1336267137'
		,'1386762300'
		,'1508968751'
		,'1649372673'
		,'1881796811'
		,'1760594998'
		) -- CONCLUDE ...
		) -- CONCLUDE ...

		SELECT ' ' AS 'CONFIRM PROVIDER SELECTION: '
		,provid
		,fedid
		,NPI
		,PROVNM
		,SPECcode
		,SPECdescr
		,PROVcode
		,PROVtype
		FROM #PROVISOLATION
		GROUP BY provid,fedid,NPI,PROVNM,SPECcode,SPECdescr,PROVcode,PROVtype
		ORDER BY fedid, PROVNM -- ORDER BY fedid FIRST to surface the 2 additional TINs for visibility

		⏎ Excellent work, thank you. Next we need to update the [Contracting_Proposal_Category] & [Proposed_Rate_Payment] CASE STATEMENTS to ensure alignment  with the email 'Proposed Rates: ...' section
				~ PLEASE NOTE: This MODIFICATION will REPLACE ANY existing code assigning the 'Contracting_Proposal_Category' AND 'Proposed_Rate_Payment' FIELD(S). AS such PLEASE ENSURE the removal OF ANY lines NOT applicable to the current contracting request.

,CASE -- COS (Category of Service) assignment ...
WHEN revcode LIKE '025%' 
	OR revcode LIKE '063%' 
	OR revcode IN ('0343')
THEN 'Pharmaceuticals'
WHEN ISNUMERIC(SUBSTRING(UPPER(LTRIM(RTRIM(ISNULL([CPT Service Code],'')))),1,5)) = 1
	AND LEN(LTRIM(RTRIM(ISNULL([CPT Service Code],'')))) > 0
	AND SUBSTRING(UPPER(LTRIM(RTRIM(ISNULL([CPT Service Code],'')))),1,5) BETWEEN '00100' AND '01999' -- STRING COMPARISON: safe, no CAST required
THEN 'Anesthesia'
WHEN revcode IN ('0114', '0124', '0134', '0144', '0154', '0204')
THEN 'IP Mild/Moderate Psych'
WHEN revcode = '0901'
THEN 'ECT'
WHEN revcode = '0904'
THEN 'OP Mild/Moderate'
WHEN revcode = '0912'
THEN 'OP Psych Eating Disorder Half Day'
WHEN revcode = '0913'
THEN 'OP Psych Eating Disorder Full Day'
WHEN [finalDRG+SOI] LIKE '008%[1-4]'
THEN 'Car-T Cell Therapy'
WHEN revcode IN ('0274', '0275', '0276', '0278', '0624')
THEN 'Implants'
WHEN [finalDRG+SOI] LIKE '440%[1-4]'
	OR [finalDRG+SOI] IN ('650', '651', '652')
THEN 'Kidney Transplant'
WHEN revcode = '0169'
THEN 'Admin Day'
WHEN QNXTbilltype LIKE '1[1-2]%' -- 'INPATIENT'
THEN 'Inpatient Base'
WHEN QNXTbilltype LIKE '1[3-4]%' -- OUTPATIENT 
THEN 'General OP' -- Default to General OP for other codes
ELSE TRY_CONVERT(nvarchar(255),'Other Services') -- DEFAULT CATCH - ALL
END AS 'Contracting_Proposal_Category'
,CASE
WHEN revcode LIKE '025%' 
	OR revcode LIKE '063%' 
	OR revcode IN ('0343')
THEN NULLIF(PAID_NET_AMT,0) -- Pharmaceuticals 135% of ASP (UNCHANGED)
WHEN ISNUMERIC(SUBSTRING(UPPER(LTRIM(RTRIM(ISNULL([CPT Service Code],'')))),1,5)) = 1
	AND LEN(LTRIM(RTRIM(ISNULL([CPT Service Code],'')))) > 0
	AND SUBSTRING(UPPER(LTRIM(RTRIM(ISNULL([CPT Service Code],'')))),1,5) BETWEEN '00100' AND '01999' -- STRING COMPARISON: safe, no CAST required
THEN CASE
WHEN LINE_OF_BUSINESS LIKE '%MEDI%CAL%'
THEN NULLIF(QUANTITY,0) * 50.00  -- $50 ASA Unit (Medi-Cal Proposed)
WHEN LINE_OF_BUSINESS LIKE '%MEDICARE%'
	OR LINE_OF_BUSINESS LIKE '%DSNP%'
	OR LINE_OF_BUSINESS LIKE '%CSNP%'
THEN NULLIF(QUANTITY,0) * 55.00  -- $55 ASA Unit (Medicare / D-SNP / C-SNP Proposed)
ELSE NULLIF(QUANTITY,0) * 50.00  -- DEFAULT to Medi-Cal rate absent LOB resolution
END
WHEN revcode IN ('0114', '0124', '0134', '0144', '0154', '0204')
THEN NULLIF([HCT LOGIC DAY(S)],0) * 1400 -- IP Mild/Moderate Psych $1,400/Day
WHEN revcode = '0901'
THEN NULLIF([HCT LOGIC DAY(S)],0) * 900 -- ECT $900/Day
WHEN revcode = '0904'
THEN NULLIF([HCT LOGIC DAY(S)],0) * 475 -- OP Mild/Moderate $475/Day
WHEN revcode = '0912'
THEN NULLIF([HCT LOGIC DAY(S)],0) * 900 -- OP Psych Eating Disorder Half Day $900/Day
WHEN revcode = '0913'
THEN NULLIF([HCT LOGIC DAY(S)],0) * 1350 -- OP Psych Eating Disorder Full Day $1,350/Day
WHEN [finalDRG+SOI] LIKE '008%[1-4]'
THEN (NULLIF(PAID_NET_AMT,0) / 1.29) * 1.30 -- DO THE MATH Fx - FORMULA (REVERSE ENGINEER) [PAID_NET_AMT] = [100% base rate] × [current contract multiplier] /* THEREFORE */ [100% base rate] = [PAID_NET_AMT] ÷ [current multiplier] /* FINALLY */ [Proposed payment] = [100% base rate] × [proposed multiplier] ... Car-T Cell Therapy 130% of Medi-Cal APR DRG
WHEN revcode IN ('0274', '0275', '0276', '0278', '0624')
THEN BILLED_AMT * 0.45 -- Implants – 45% of Billed Charges
WHEN [finalDRG+SOI] LIKE '440%[1-4]'
	OR [finalDRG+SOI] IN ('650', '651', '652')
THEN (NULLIF(PAID_NET_AMT,0) / 1.97) * 2.00 -- DO THE MATH Fx - FORMULA (REVERSE ENGINEER) [PAID_NET_AMT] = [100% base rate] × [current contract multiplier] /* THEREFORE */ [100% base rate] = [PAID_NET_AMT] ÷ [current multiplier] /* FINALLY */ [Proposed payment] = [100% base rate] × [proposed multiplier] ... Kidney Transplant 200% of APR DRG
WHEN revcode = '0169'
THEN NULLIF([HCT LOGIC DAY(S)],0) * 880 -- Admin Day $880/Day
WHEN QNXTbilltype LIKE '1[1-2]%' -- 'INPATIENT'
THEN (NULLIF(PAID_NET_AMT,0) / 1.15) * 1.25 -- DO THE MATH Fx - FORMULA (REVERSE ENGINEER) [PAID_NET_AMT] = [100% base rate] × [current contract multiplier] /* THEREFORE */ [100% base rate] = [PAID_NET_AMT] ÷ [current multiplier] /* FINALLY */ [Proposed payment] = [100% base rate] × [proposed multiplier] ... Inpatient 125% of Medi-Cal APR DRG (increase from 115%)
WHEN QNXTbilltype LIKE '1[3-4]%' -- OUTPATIENT 
THEN (NULLIF(PAID_NET_AMT,0) / 1.29) * 1.30 -- DO THE MATH Fx - FORMULA (REVERSE ENGINEER) [PAID_NET_AMT] = [100% base rate] × [current contract multiplier] /* THEREFORE */ [100% base rate] = [PAID_NET_AMT] ÷ [current multiplier] /* FINALLY */ [Proposed payment] = [100% base rate] × [proposed multiplier] ... General OP 130% of Medi-Cal (increase from 129%)
ELSE 0 -- NO NOT NEGATIVE <> !+ PROPOSAL GIVEN FOR DEFAULT CATCH - ALL
END AS 'Proposed_Rate_Payment'







-- =====================================================================
	-- [Contracting_Proposal_Category] & [Proposed_Rate_Payment] --
	-- UCSD Health - Specialty Professional Services Utilization Request
	-- Proposed Rates per SIR SALIM FRENCH EMAIL 20260203 (updated 20260210)
	-- Medi-Cal LOB:  (1) General Specialty 120% Medi-Cal FS
	--                (2) Anesthesia $50 ASA Unit (CPT 00100-01999)
	--                (3) Specialty Carve-out 140% Medi-Cal FS
	--                    (Lymphedema, Breast, Chronic Thromboembolic,
	--                     Ortho, Neuro, Gender Affirming)
	-- Medicare LOB:  (1) General Specialty 120% Medicare FS
	--                (2) Anesthesia $55 ASA Unit (CPT 00100-01999)
	--                (3) Specialty Carve-out 140% Medi-Cal FS (same schedule)
	-- NOTE: This is a PROFESSIONAL (CMS-1500) script.
	--       Revenue code / DRG / facility-based categories
	--       from prior hospital contracting script have been REMOVED.
-- =====================================================================
,CASE -- COS (Category of Service) assignment ...	
WHEN CAST(SUBSTRING(UPPER(LTRIM(RTRIM(ISNULL([CPT Service Code],'')))),1,5) AS int) BETWEEN 100 AND 1999 -- [1] ANESTHESIA: CPT range 00100-01999 per SIR SALIM 20260210 correction
AND ISNUMERIC(SUBSTRING(UPPER(LTRIM(RTRIM(ISNULL([CPT Service Code],'')))),1,5)) = 1
THEN 'Anesthesia'
WHEN UPPER(LTRIM(RTRIM(ISNULL([CPT Service Code],'')))) IN -- [2] SPECIALTY CARVE-OUT: Lymphedema, Breast, Chronic Thromboembolic, ... Ortho, Neuro, Gender Affirming - 140% of Medi-Cal FS ... Codes per SIR SALIM 20260203 & 20260210 (49999 corrected from 4999)
( -- INITIATE ...
'38999'  -- Lymphedema / unlisted lymphatic procedure
,'38745'  -- Axillary lymphadenectomy
,'38500'  -- Biopsy or excision of lymph node(s)
,'38792'  -- Injection for sentinel node ID
,'38740'  -- Axillary lymphadenectomy (complete)
,'19361'  -- Breast reconstruction with latissimus dorsi flap
,'19364'  -- Breast reconstruction with free flap
,'19366'  -- Breast reconstruction with other technique
,'19367'  -- Breast reconstruction with TRAM flap (single pedicle)
,'49203'  -- Excision / destruction abdominal tumor, 5 cm or less
,'49204'  -- Excision / destruction abdominal tumor, 5.1-10 cm
,'49205'  -- Excision / destruction abdominal tumor, over 10 cm
,'49999'  -- Unlisted laparoscopy procedure (corrected from 4999 per SIR SALIM 20260210)
) -- CONCLUDE ...
	OR UPPER(LTRIM(RTRIM(ISNULL([prindiag],'')))) IN
	( -- INITIATE ... 
	'F64.0'  -- Transsexualism
	,'F64.9'  -- Gender identity disorder, unspecified
	) -- CONCLUDE ...
	THEN 'Specialty Carve-out' 
ELSE TRY_CONVERT(nvarchar(255),'General Specialty') -- DEFAULT CATCH - ALL ... [3] GENERAL SPECIALTY: Default professional services catch-all ... Applies to all other professional (1500) claim lines --
END AS 'Contracting_Proposal_Category'
,CASE -- [1] ANESTHESIA: ASA Unit-based ... Medi-Cal LOB: $50/unit | Medicare LOB (D-SNP/C-SNP): $55/unit ... [QUANTITY] field = base units (per MS ALLYSON + MS HINA ADJ UNIT(S) logic) --
WHEN CAST(SUBSTRING(UPPER(LTRIM(RTRIM(ISNULL([CPT Service Code],'')))),1,5) AS int) BETWEEN 100 AND 1999
	AND ISNUMERIC(SUBSTRING(UPPER(LTRIM(RTRIM(ISNULL([CPT Service Code],'')))),1,5)) = 1
THEN CASE
WHEN LINE_OF_BUSINESS LIKE '%MEDI%CAL%'
THEN NULLIF(QUANTITY,0) * 50.00  -- $50 ASA Unit (Medi-Cal Proposed)
WHEN LINE_OF_BUSINESS LIKE '%MEDICARE%'
	OR LINE_OF_BUSINESS LIKE '%DSNP%'
	OR LINE_OF_BUSINESS LIKE '%CSNP%'
THEN NULLIF(QUANTITY,0) * 55.00  -- $55 ASA Unit (Medicare / D-SNP / C-SNP Proposed)
ELSE NULLIF(QUANTITY,0) * 50.00  -- DEFAULT to Medi-Cal rate absent LOB resolution
END 
WHEN UPPER(LTRIM(RTRIM(ISNULL([CPT Service Code],'')))) IN -- [2] SPECIALTY CARVE-OUT: 140% of Medi-Cal FS ... DO THE MATH Fx - FORMULA (REVERSE ENGINEER) …EQUIV_allow_rate = 100% Medi-Cal FS rate (from @SETfeesched) ... Apply [Modifier Discount] per MS ALLYSON pattern; multiply by QUANTITY ... NOTE: Medicare LOB also references Medi-Cal FS per SIR SALIM 20260203
( -- INITIATE ...
'38999'  -- Lymphedema / unlisted lymphatic procedure
,'38745'  -- Axillary lymphadenectomy
,'38500'  -- Biopsy or excision of lymph node(s)
,'38792'  -- Injection for sentinel node ID
,'38740'  -- Axillary lymphadenectomy (complete)
,'19361'  -- Breast reconstruction with latissimus dorsi flap
,'19364'  -- Breast reconstruction with free flap
,'19366'  -- Breast reconstruction with other technique
,'19367'  -- Breast reconstruction with TRAM flap (single pedicle)
,'49203'  -- Excision / destruction abdominal tumor, 5 cm or less
,'49204'  -- Excision / destruction abdominal tumor, 5.1-10 cm
,'49205'  -- Excision / destruction abdominal tumor, over 10 cm
,'49999'  -- Unlisted laparoscopy procedure (corrected from 4999 per SIR SALIM 20260210)
) -- CONCLUDE ...
	OR UPPER(LTRIM(RTRIM(ISNULL([prindiag],'')))) IN
	( -- INITIATE ... 
	'F64.0'  -- Transsexualism
	,'F64.9'  -- Gender identity disorder, unspecified
	) -- CONCLUDE ...
THEN  (NULLIF(PAID_NET_AMT,0) / 1.33) * 1.40 -- DO THE MATH Fx - FORMULA (REVERSE ENGINEER) [PAID_NET_AMT] = [100% base rate] × [current contract multiplier] /* THEREFORE */ [100% base rate] = [PAID_NET_AMT] ÷ [current multiplier] /* FINALLY */ [Proposed payment] = [100% base rate] × [proposed multiplier] ...  % OF AS GIVEN FEE SCHEDULE ... Proposed: 140% of Medi-Cal FS
ELSE (NULLIF(PAID_NET_AMT,0) / 1.10) * 1.20 -- DO THE MATH Fx - FORMULA (REVERSE ENGINEER) [PAID_NET_AMT] = [100% base rate] × [current contract multiplier] /* THEREFORE */ [100% base rate] = [PAID_NET_AMT] ÷ [current multiplier] /* FINALLY */ [Proposed payment] = [100% base rate] × [proposed multiplier] ... 110% OF GIVEN SCHEDULE FOR BOTH MEDI-CAL AND MEDICARE ... % OF AS GIVEN FEE SCHEDULE ... [3] GENERAL SPECIALTY: 120% of applicable Fee Schedule ... Medi-Cal LOB: 120% of Medi-Cal FS ... Medicare LOB (D-SNP / C-SNP): 120% of Medicare FS ...  DO THE MATH Fx - FORMULA (REVERSE ENGINEER) …Fx: EQUIV_allow_rate = 100% of applicable FS (from @SETfeesched)
END AS 'Proposed_Rate_Payment'

Good evening! This is a sharp observation and the screenshot tells the story clearly. Let me diagnose what you are seeing.

What the data is showing:
Looking at the highlighted rows — CPT 00100 and 00103 — the servunits and QUANTITY columns are identical (e.g., row 1: 77 units, row 2: 151 units), yet PAID_NET_AMT values like 638.88, 418.88, 682.88, 44.00 do not equal servunits × $44.
For example:
Row 1:  77 units × $44 = $3,388.00  ≠  $638.88  ✗
Row 9:  234 units × $44 = $10,296.00 ≠  $44.00   ✗
Row 12: 126 units × $44 = $5,544.00  ≠  $44.00   ✗
The math is definitively not mathing. This tells you that servunits / QUANTITY is not storing raw ASA base units in the way the Anesthesia formula expects.

Root cause — How ASA Anesthesia pricing actually works:
Anesthesia reimbursement is not simply units × rate. The full ASA formula is:
Total Payment = (Base Units + Time Units + Qualifying Circumstances Units) × Conversion Factor

Where:
  Base Units      = procedure-specific value assigned by ASA (e.g., CPT 00100 = 7 base units)
  Time Units      = Total anesthesia minutes ÷ 15
  QC Units        = modifier-driven additions (e.g., 99100 = +3 units for extreme age)
  Conversion Factor = the dollar rate per unit ($44 current / $50 proposed Medi-Cal)
What servunits is most likely storing is the total combined unit count (Base + Time + QC already summed), OR it may be storing raw minutes — both of which would explain the variance you are seeing. The $44.00 flat amounts on rows 9, 12, 14, 17 strongly suggest those are 1-unit claims (perhaps base units only with zero time), while the others reflect varying total unit calculations already baked into the adjudication.

The diagnostic query to run before adjusting anything:
sql

-- =====================================================================
	-- ANESTHESIA UNIT RECONCILIATION QA --
	-- Purpose: Reconcile servunits vs. PAID_NET_AMT to determine
	--          what 'servunits' actually represents in the claim data
	-- Per screenshot: CPT 00100 / 00103 MEDI-CAL anomaly investigation
	-- Run date: 20260220
-- =====================================================================
SELECT ' ' AS 'ANESTHESIA UNIT RECONCILIATION: '
,claimid
,claimline
,LINE_OF_BUSINESS
,[CPT Service Code]
,[CPT Service Description]
,servunits                                    -- RAW from claimdetail
,QUANTITY                                     -- ADJUSTED per MS ALLYSON logic
,PAID_NET_AMT
-- REVERSE ENGINEER: what 'implied unit rate' does the data suggest?
,CASE
 WHEN NULLIF(servunits,0) IS NOT NULL
 THEN TRY_CONVERT(decimal(9,4), PAID_NET_AMT / NULLIF(servunits,0))
 ELSE NULL
 END AS 'Implied_Rate_Per_ServUnit'           -- Should be $44 IF servunits = total ASA units
-- TEST: what would payment be if servunits ARE total ASA units at $44?
,NULLIF(servunits,0) * 44.00 AS 'Expected_IF_ServUnit_x_44'
-- DELTA: how far off is the expected vs. actual?
,PAID_NET_AMT - (NULLIF(servunits,0) * 44.00) AS 'Delta_Actual_vs_Expected'
-- TEST: are servunits storing MINUTES? (ASA time unit = 15 min)
,TRY_CONVERT(decimal(9,4), NULLIF(servunits,0) / 15.0) AS 'IF_servunits_are_MINUTES_then_TimeUnits'
-- TEST: what is the implied TOTAL unit count working backward from paid?
,TRY_CONVERT(decimal(9,4), PAID_NET_AMT / 44.00) AS 'Implied_Total_ASA_Units_at_$44'
,modcode   -- QC modifier presence (99100/99116/99135/99140 add units)
,modcode2
,modcode3
FROM INFORMATICS.dbo.CONTRACTING_UCSD
WHERE 1=1
	AND ISNUMERIC(SUBSTRING(UPPER(LTRIM(RTRIM(ISNULL([CPT Service Code],'')))),1,5)) = 1
	AND LEN(LTRIM(RTRIM(ISNULL([CPT Service Code],'')))) > 0
	AND SUBSTRING(UPPER(LTRIM(RTRIM(ISNULL([CPT Service Code],'')))),1,5)
		BETWEEN '00100' AND '01999' -- Anesthesia CPT range
	AND [ClaimCategory] IN ('Paid')
	AND NULLIF(PAID_NET_AMT,0) IS NOT NULL
ORDER BY [CPT Service Code], PAID_NET_AMT DESC

What to look for in the results:
The Implied_Rate_Per_ServUnit column will reveal one of three scenarios:
Scenario A — Implied_Rate_Per_ServUnit clusters around $44.00 → servunits IS your total ASA unit count and the proposed formula QUANTITY × $50 is correct as written.
Scenario B — Implied_Rate_Per_ServUnit clusters around $2.93 (= $44 ÷ 15) → servunits is storing raw minutes, and you need to convert: (servunits / 15) × $50 for the proposed rate.
Scenario C — Implied_Rate_Per_ServUnit is erratic with no pattern → QNXT is storing the pre-calculated dollar amount in the units field, or claims were adjudicated outside the standard ASA formula (manual overrides, COB adjustments, or capitated encounter pricing). In this case, the DO THE MATH reverse-engineer approach (PAID_NET_AMT / 44) × 50 becomes the more defensible formula.

My recommendation before touching the proposed rate formula:
Run the diagnostic first. If Implied_Total_ASA_Units_at_$44 (= PAID_NET_AMT ÷ 44) produces clean whole numbers or near-whole numbers consistently, that confirms Scenario C and the safer proposed rate formula becomes:
sql-- Anesthesia Proposed Rate: reverse-engineer from $44 current to $50/$55 proposed
WHEN [Contracting_Proposal_Category] = 'Anesthesia'
THEN
    CASE
    WHEN LINE_OF_BUSINESS LIKE '%MEDI%CAL%'
    THEN (NULLIF(PAID_NET_AMT,0) / 44.00) * 50.00  -- DO THE MATH Fx (REVERSE ENGINEER) Current $44 → Proposed $50
    WHEN LINE_OF_BUSINESS LIKE '%MEDICARE%'
        OR LINE_OF_BUSINESS LIKE '%DSNP%'
        OR LINE_OF_BUSINESS LIKE '%CSNP%'
    THEN (NULLIF(PAID_NET_AMT,0) / 44.00) * 55.00  -- DO THE MATH Fx (REVERSE ENGINEER) Current $44 → Proposed $55
    ELSE (NULLIF(PAID_NET_AMT,0) / 44.00) * 50.00  -- DEFAULT to Medi-Cal absent LOB resolution
    END
This keeps it fully consistent with the "DO THE MATH" framework already established for General Specialty and the Specialty Carve-out, and avoids any dependency on whether servunits is storing minutes, total units, or something else entirely.Thank you, as you anticipated would seem the 'Implied_Total_ASA_Units_at...' is the way to go:SELECT ' ' AS 'ASA Unit'
,LINE_OF_BUSINESS
,[CONTRACT DESCRIPTION]
,[CPT Service Code]
,[CPT Service Description]
,servunits
,QUANTITY
--,TRY_CONVERT(decimal(9,4), NULLIF(servunits,0) / 15.0) AS 'IF_servunits_are_MINUTES_then_TimeUnits'
--,TRY_CONVERT(decimal(9,4), NULLIF(servunits,0) / 15.0)*44 AS 'IF_servunits_are_MINUTES_then_Current_Rate'
-- TEST: what is the implied TOTAL unit count working backward from paid?
,TRY_CONVERT(decimal(9,4), PAID_NET_AMT / 44.00) AS 'Implied_Total_ASA_Units_at_Given_Current_Rate'
,TRY_CONVERT(decimal(9,4), PAID_NET_AMT / 44.00)*44.00 AS 'Implied_Current_Rate'
,CASE
WHEN LINE_OF_BUSINESS IN ('MEDI-CAL')
THEN TRY_CONVERT(decimal(9,4), PAID_NET_AMT / 44.00)*50.00
WHEN LINE_OF_BUSINESS IN ('DSNP','CSNP')
THEN TRY_CONVERT(decimal(9,4), PAID_NET_AMT / 44.00)*55.00
ELSE 0
END  AS 'Implied_Proposed_Rate'
,PAID_NET_AMT
,*
FROM INFORMATICS.dbo.CONTRACTING_UCSD
WHERE 1=1
    -- AND [CONTRACT DESCRIPTION] LIKE '%ANES%'
    AND [CPT Service Description] LIKE '%ANES%'Show more11:18 PMGood evening! The screenshot confirms Scenario C definitively. Look at the evidence:
The smoking gun — rows 9, 12, 14, 17:
servunits = 234, 126, 151, 86  →  Implied_Total_ASA_Units = 1.0000
PAID_NET_AMT = $44.00 exactly  →  1.0 × $44 = $44.00  ✓
And the pattern holds cleanly across all rows — Implied_Current_Rate column equals PAID_NET_AMT exactly in every row. The DO THE MATH reverse-engineer approach is confirmed correct. servunits is storing something entirely unrelated to ASA unit pricing (likely raw procedure minutes or a QNXT internal unit field) and should not be used in the Anesthesia proposed rate formula.

One additional observation worth flagging for Sir Salim:
Notice rows 22 and 28 — both DSNP with QUANTITY = 0 yet PAID_NET_AMT of $12.32 and $15.84 respectively. These will produce NULL via NULLIF(QUANTITY,0) but will calculate correctly via the reverse-engineer formula since PAID_NET_AMT is non-zero. This is another reason the PAID_NET_AMT-based approach is more robust than the QUANTITY-based approach for Anesthesia.

The confirmed final Anesthesia formula — updated #ContractAnalysis section:
sql

-- =======================================================================
	-- CONTRACTING SUMMARY ANALYSIS (WITH ZERO HANDLING): 
-- =======================================================================
SELECT DISTINCT 'CONTRACTING PROPOSAL DEVELOPMENT: ' AS [Scenario]
,claimid
,claimline
,AdmitID
,[Alt. AdmitID]
,LINE_OF_BUSINESS
,ISNULL(LINE_OF_BUSINESS,'')+' '+ISNULL([Primary / Secondary Status],'') AS 'LOB'
,PAYTONM
,memid
,revcode
,[REVCDE Descr]
,[CPT Service Code]
,[CPT Service Description]
,[HCT LOGIC DAY(S)]
,QUANTITY
,BILLED_AMT
,ALLOWED_AMT
,NET_AMT
,PAID_NET_AMT AS 'Actual_Payment'
,EQUIV_allow_rate AS 'TRI Medi-cal Rate'
,EQUIV_allow_compare AS 'TRI Medi-cal Paid'
,EQUIV_allow_rate2 AS 'Medicare In Office NF Rate'
,EQUIV_allow_compare2 AS 'Medicare In Office NF Paid'
,EQUIV_allow_rate3 AS 'Medicare Out of Office NF Rate'
,EQUIV_allow_compare3 AS 'Medicare Out of Office NF Paid'
,NULLIF(PAID_NET_AMT,0) * 1.00 AS 'Current_Rate_Payment' -- ASSUME THAT WHAT HAS BEEN PAID IS WHAT THE CONTRACTING DEPT. HAS DOCUMENTED
,CASE -- COS (Category of Service) assignment ...

	-- [1] ANESTHESIA: CPT range 00100-01999 per SIR SALIM 20260210 correction --
	-- STRING-SAFE BETWEEN: avoids Msg 245 CAST/int failure on alphanumeric CPT codes (eg. '0042T') --
	WHEN ISNUMERIC(SUBSTRING(UPPER(LTRIM(RTRIM(ISNULL([CPT Service Code],'')))),1,5)) = 1
		AND LEN(LTRIM(RTRIM(ISNULL([CPT Service Code],'')))) > 0
		AND SUBSTRING(UPPER(LTRIM(RTRIM(ISNULL([CPT Service Code],'')))),1,5)
			BETWEEN '00100' AND '01999'
	THEN 'Anesthesia'

	-- [2] SPECIALTY CARVE-OUT: Lymphedema, Breast, Chronic Thromboembolic,
	--     Ortho, Neuro, Gender Affirming - 140% of Medi-Cal FS --
	--     Codes per SIR SALIM 20260203 & 20260210 (49999 corrected from 4999) --
	WHEN UPPER(LTRIM(RTRIM(ISNULL([CPT Service Code],'')))) IN
		( -- INITIATE ...
		 '38999'  -- Lymphedema / unlisted lymphatic procedure
		,'38745'  -- Axillary lymphadenectomy
		,'38500'  -- Biopsy or excision of lymph node(s)
		,'38792'  -- Injection for sentinel node ID
		,'38740'  -- Axillary lymphadenectomy (complete)
		,'19361'  -- Breast reconstruction with latissimus dorsi flap
		,'19364'  -- Breast reconstruction with free flap
		,'19366'  -- Breast reconstruction with other technique
		,'19367'  -- Breast reconstruction with TRAM flap (single pedicle)
		,'49203'  -- Excision / destruction abdominal tumor, 5 cm or less
		,'49204'  -- Excision / destruction abdominal tumor, 5.1-10 cm
		,'49205'  -- Excision / destruction abdominal tumor, over 10 cm
		,'49999'  -- Unlisted laparoscopy procedure (corrected from 4999 per SIR SALIM 20260210)
		) -- CONCLUDE ...
		OR UPPER(LTRIM(RTRIM(ISNULL([prindiag],'')))) IN
		( -- INITIATE ... ICD-10 Gender Affirming per SIR SALIM 20260203 --
		 'F64.0'  -- Transsexualism
		,'F64.9'  -- Gender identity disorder, unspecified
		) -- CONCLUDE ...
	THEN 'Specialty Carve-out'

	-- [3] GENERAL SPECIALTY: Default professional services catch-all --
	ELSE TRY_CONVERT(nvarchar(255),'General Specialty') -- DEFAULT CATCH - ALL

END AS 'Contracting_Proposal_Category'

,CASE -- PROPOSED RATE PAYMENT calculation ...

	-- [1] ANESTHESIA: DO THE MATH Fx - FORMULA (REVERSE ENGINEER) --
	--     CONFIRMED via QA 20260220: servunits does NOT store ASA total units --
	--     servunits/QUANTITY field is unreliable for ASA pricing (QNXT internal unit field) --
	--     DSNP rows 22 & 28: QUANTITY=0 yet PAID_NET_AMT non-zero -- reverse-engineer handles correctly --
	--     [PAID_NET_AMT] = [Total ASA Units] × [Current $44 rate]
	--     /* THEREFORE */ [Total ASA Units] = [PAID_NET_AMT] ÷ $44.00
	--     /* FINALLY */   [Proposed payment] = [Total ASA Units] × [Proposed rate]
	WHEN ISNUMERIC(SUBSTRING(UPPER(LTRIM(RTRIM(ISNULL([CPT Service Code],'')))),1,5)) = 1
		AND LEN(LTRIM(RTRIM(ISNULL([CPT Service Code],'')))) > 0
		AND SUBSTRING(UPPER(LTRIM(RTRIM(ISNULL([CPT Service Code],'')))),1,5)
			BETWEEN '00100' AND '01999'
	THEN
		CASE
		WHEN LINE_OF_BUSINESS LIKE '%MEDI%CAL%'
		THEN (NULLIF(PAID_NET_AMT,0) / 44.00) * 50.00  -- DO THE MATH Fx (REVERSE ENGINEER) Medi-Cal: Current $44 → Proposed $50/ASA Unit
		WHEN LINE_OF_BUSINESS LIKE '%DSNP%'
			OR LINE_OF_BUSINESS LIKE '%CSNP%'
			OR LINE_OF_BUSINESS LIKE '%MEDICARE%'
		THEN (NULLIF(PAID_NET_AMT,0) / 44.00) * 55.00  -- DO THE MATH Fx (REVERSE ENGINEER) Medicare/D-SNP/C-SNP: Current $44 → Proposed $55/ASA Unit
		ELSE (NULLIF(PAID_NET_AMT,0) / 44.00) * 50.00  -- DEFAULT to Medi-Cal rate absent LOB resolution
		END

	-- [2] SPECIALTY CARVE-OUT: 140% of Medi-Cal FS --
	--     DO THE MATH Fx: Current 133% → Proposed 140% of Medi-Cal FS --
	--     NOTE: Medicare LOB also references Medi-Cal FS per SIR SALIM 20260203 --
	WHEN UPPER(LTRIM(RTRIM(ISNULL([CPT Service Code],'')))) IN
		( -- INITIATE ...
		 '38999','38745','38500','38792','38740'
		,'19361','19364','19366','19367'
		,'49203','49204','49205','49999'
		) -- CONCLUDE ...
		OR UPPER(LTRIM(RTRIM(ISNULL([prindiag],'')))) IN
		( -- INITIATE ...
		 'F64.0','F64.9'
		) -- CONCLUDE ...
	THEN (NULLIF(PAID_NET_AMT,0) / 1.33) * 1.40  -- DO THE MATH Fx - FORMULA (REVERSE ENGINEER)
	                                               -- [PAID_NET_AMT] = [100% base] × 1.33
	                                               -- [100% base]    = [PAID_NET_AMT] ÷ 1.33
	                                               -- [Proposed]     = [100% base] × 1.40

	-- [3] GENERAL SPECIALTY: 120% of applicable Fee Schedule --
	--     DO THE MATH Fx: Current 110% → Proposed 120% (both Medi-Cal and Medicare) --
	ELSE (NULLIF(PAID_NET_AMT,0) / 1.10) * 1.20  -- DO THE MATH Fx - FORMULA (REVERSE ENGINEER)
	                                               -- [PAID_NET_AMT] = [100% base] × 1.10
	                                               -- [100% base]    = [PAID_NET_AMT] ÷ 1.10
	                                               -- [Proposed]     = [100% base] × 1.20

END AS 'Proposed_Rate_Payment'

,ISNULL((NULLIF(EQUIV_allow_compare,0) * 1.05),((NULLIF(PAID_NET_AMT,0)+ISNULL([TRI Payment],0)) * 1.05)) AS 'Counter_Offer_Payment' -- ASSUME THAT WHAT HAS BEEN PAID IS WHAT THE CONTRACTING DEPT. HAS DOCUMENTED
-- ,ISNULL((NULLIF(EQUIV_allow_compare,0)* 1.05),(NULLIF(PAID_NET_AMT,0) * 1.05)) AS 'Counter_Offer_Payment'
-- ,NULLIF(PAID_NET_AMT,0) * 1.05 AS 'Counter_Offer_Payment'
INTO #ContractAnalysis
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st',[LOB],LINE_OF_BUSINESS
FROM INFORMATICS.dbo.CONTRACTING_UCSD
WHERE 1=1
	AND [ClaimCategory] IN ('Paid') -- PAID CLAIMS ONLY!!!
	-- AND LINE_OF_BUSINESS LIKE '%MEDI%CAL%'
	AND [Primary / Secondary Status] = 'P'
	AND NULLIF(PAID_NET_AMT,0) != 0 -- APPLES TO APPLES PAID LINES ONLY!
	-- AND NOT NULLIF(ISNULL([EQUIV_allow_compare],0),0) = 0 -- NO NOT NEGATIVE <> != ... APPLES TO APPLES EQUIV FEE SCHEDULE VAL ONLY!

One final QA checkpoint to run after populating #ContractAnalysis:
sql

-- =====================================================================
	-- POST-LOAD QA: Anesthesia category sanity check --
	-- Confirms reverse-engineer formula producing expected rate uplift --
-- =====================================================================
SELECT ' ' AS 'QA ANESTHESIA PROPOSED RATE VALIDATION: '
,LINE_OF_BUSINESS
,[CPT Service Code]
,[CPT Service Description]
,COUNT(DISTINCT claimid)  AS 'Unique Claims'
,SUM(Actual_Payment)  AS 'Total Current Paid'
,SUM(Proposed_Rate_Payment)   AS 'Total Proposed Payment'
,SUM(Proposed_Rate_Payment) - SUM(Actual_Payment) AS 'Dollar Impact'
,CASE
 WHEN SUM(Actual_Payment) = 0 THEN 'N/A'
 ELSE TRY_CONVERT(nvarchar(50),
      TRY_CONVERT(decimal(9,3),
      ((SUM(Proposed_Rate_Payment) / NULLIF(SUM(Actual_Payment),0)) - 1) * 100))+'%'
 END    AS 'Rate Uplift %' -- Should be ~13.64% for Medi-Cal ($44→$50) and ~25.00% for Medicare ($44→$55)
FROM #ContractAnalysis
WHERE 1=1
	AND Contracting_Proposal_Category = 'Anesthesia'
GROUP BY LINE_OF_BUSINESS,[CPT Service Code],[CPT Service Description]
ORDER BY LINE_OF_BUSINESS,[CPT Service Code]
The Rate Uplift % column gives you the immediate sanity check — Medi-Cal should return approximately 13.64% ($50/$44 - 1) and Medicare/D-SNP/C-SNP approximately 25.00% ($55/$44 - 1). Any material deviation flags a claim requiring further investigation before the proposal goes to Sir Salim for final review.Thank you, by the way for my edification what does 'ASA' stand for?11:43 PMASA = American Society of Anesthesiologists
The ASA is the professional medical association that developed and maintains the relative value unit system used to price anesthesia services — which is why the unit-based pricing methodology carries their name. It is distinct from every other CPT-based specialty in that regard; no other specialty has its own named unit conversion system embedded into the claims pricing infrastructure the way Anesthesia does.
For your broader managed care context, the three components worth keeping in your working knowledge are:
Base Units — assigned by the ASA to each anesthesia CPT code reflecting the inherent complexity of the procedure. CPT 00100 (salivary gland, which is exactly what you are seeing in your data) carries 7 base units for example.
Time Units — accrued during the procedure, traditionally calculated as 1 unit per 15 minutes of anesthesia time. This is why raw servunits in QNXT was producing numbers like 77, 151, 124 — those figures are almost certainly total elapsed minutes being stored in that field, not ASA units.
Qualifying Circumstance Units — additive units driven by modifiers such as 99100 (extreme age — infancy or over 70), 99116 (utilization of controlled hypotension), 99135 (controlled hypotension), and 99140 (emergency conditions), each adding between 3 and 5 units to the total.
The reason your reverse-engineer formula (PAID_NET_AMT ÷ $44) × $50 is the analytically correct and defensible approach is precisely because QNXT has already done the Base + Time + Qualifying Circumstances summation during adjudication and PAID_NET_AMT reflects the fully loaded total — so you never need to reconstruct those components separately for contracting proposal purposes






JAH 'NPI & TIN'
		USE [PATH]: file://netapp02/IS/Informatics/_Informatics%20Deliverables/Contracting/Adhoc/PTN/

IN ('1447512983','1598994758','1922321397','1023269222','1750559431','1083938764','1629618723','1518668565','1306394382','1912732397','1649779919') -- PTPN NPI

IN ('455334364 ','330874542','770700060','800267675','261911128','464813023','842257081','871718352','832168854','990755090','823871361') -- PTPN TAXID

SELECT * 
-- INTO #PROVISOLATION
-- SELECT TOP 10 ' ' AS 'CHECK 1st',fedid,npi,provid,*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM INFORMATICS.dbo.[uvw_PROVISO] AS prov
WHERE 1=1 
	AND 
	( -- INITIATE ...
	UPPER(LTRIM(RTRIM(ISNULL(prov.NPI,'')))) IN ('1447512983','1598994758','1922321397','1023269222','1750559431','1083938764','1629618723','1518668565','1306394382','1912732397','1649779919') -- PTPN NPI
		OR fedid IN ('455334364 ','330874542','770700060','800267675','261911128','464813023','842257081','871718352','832168854','990755090','823871361') -- PTPN TAXID
	) -- CONCLUDE ...
	
SELECT * 
-- INTO #PROVISOLATION
-- SELECT TOP 10 ' ' AS 'CHECK 1st',fedid,npi,provid,*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM INFORMATICS.dbo.[uvw_PROVISO] AS prov
WHERE 1=1 
	AND 
	( -- INITIATE ...
	UPPER(LTRIM(RTRIM(ISNULL(prov.NPI,'')))) IN ('6899','317997','139660','330599494','21','10798','134963','237064656') -- 20019 - UCSD MEDICAL CENTER IN 
		OR fedid IN ('330599494') -- UCSD Hospital TIN#33-0599494
	) -- CONCLUDE ...
	
SELECT * 
-- INTO #PROVISOLATION
-- SELECT TOP 10 ' ' AS 'CHECK 1st',fedid,npi,provid,*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM INFORMATICS.dbo.[uvw_PROVISO] AS prov
WHERE 1=1 
	AND 
	( -- INITIATE ...
	UPPER(LTRIM(RTRIM(ISNULL(prov.provid,'')))) IN ('6899','317997','139660','330599494','21','10798','134963','237064656') -- 20019 - UCSD MEDICAL CENTER IN 
		OR fedid IN ('330599494') -- UCSD Hospital TIN#33-0599494
	) -- CONCLUDE ...	

-- =====================================================================================================
-- PHYSICAL THERAPY PROVIDER NETWORK - CONTRACTING ANALYSIS
-- Request Date: 1/8/2026 | Effective Date: 1/1/2026
-- Analysis Period: DOS 10/01/2024 - 9/31/2025 (Claims Lag through 3/1/2027)
-- =====================================================================================================
,NULLIF(ISNULL(PAID_NET_AMT,0),0) * 1.00 AS [Current_Rate_Payment]

,CASE -- Contracting Proposal Category Assignment
WHEN NOT ISNULL([Line of Business],'') = '' -- NO NOT NEGATIVE <> != ...
THEN 'Occupational/ Speech/Physical Therapy'
ELSE TRY_CONVERT(nvarchar(255),'Other Services') -- DEFAULT CATCH - ALL
END AS [Contracting_Proposal_Category]

,CASE -- Proposed Rate Payment Calculation
WHEN [Line of Business] LIKE '%D%SNP%'
THEN ISNULL((NULLIF(EQUIV_allow_compare,0)* 1.30),((NULLIF(PAID_NET_AMT,0)+ISNULL([TRI Payment],0)) * 1.30)) -- D-SNP: 130% of current Medicare Fee Schedule
WHEN [Line of Business] IKE '%C%SNP%'
THEN ISNULL((NULLIF(EQUIV_allow_compare,0)* 1.15),((NULLIF(PAID_NET_AMT,0)+ISNULL([TRI Payment],0)) * 1.15)) -- C-SNP: 115% of current Medicare Fee Schedule
ELSE 0
END AS [Proposed_Rate_Payment]

,ISNULL((NULLIF(EQUIV_allow_compare,0)* 1.05),((NULLIF(PAID_NET_AMT,0)+ISNULL([TRI Payment],0)) * 1.05)) AS 'Counter_Offer_Payment' -- ASSUME THAT WHAT HAS BEEN PAID IS WHAT THE CONTRACTING DEPT. HAS DOCUMENTED







JAH 'MEGAN LEWIS' NO UTILIZATION FOR SPECIFIC CODE: 
SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM INFORMATICS.dbo.CONTRACTING_MEGANLEWIS AS su
WHERE 1=1
	AND [CPT Service Code] IN ('90847')

SELECT clm.claimid
,clm.memid
,clm.startdate
,TRY_CONVERT(nvarchar(255),'Assign Claim Adjudication Category') AS [ClaimCategory]
-- SELECT TOP 10 ' ' AS 'CHECK 1st',* 
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM HMOPROD_PLANDATA.dbo.claim (NOLOCK) AS clm
	INNER JOIN HMOPROD_PLANDATA.dbo.claimdetail (NOLOCK) AS cd ON clm.claimid = cd.claimid
		LEFT JOIN HMOPROD_PLANDATA.dbo.affiliation (NOLOCK) AS a ON clm.affiliationid = a.affiliationid -- REMINDER: within claim(s) tables AFFILIATIONID is the relationship BETWEEN the a.provid = [RENDERING] PROVIDER AND the a.affiliateid = [PAYTO] PROVIDER
WHERE 1=1
	AND UPPER(LTRIM(RTRIM(ISNULL(a.affiliateid,'')))) IN -- [PAYTO]
	( -- INITIATE ...
	'10261','326191'
	) -- CONCLUDE ... 
	AND SUBSTRING(UPPER(LTRIM(RTRIM(ISNULL(cd.servcode,'')))),1,5) IN ('90847')
ORDER BY clm.startdate DESC







JAH 'CONTRACTING - IMAGE ONE'
x QA FOR SIR JOHNNIE
		USE http://devops01:8080/IS/Informatics/_workitems/edit/23295/ - 'DEVOPS SPRINT TICKET'
		
		⏎ ACT AS a Senior Data Analyst WITH 20+ years of EXPERIENCE. PLEASE MODIFY the existing CODE TO ENSURE ALIGNMENT WITH the latest Contracting Dept. request. LEVERAGE: TEXT / TABLE ("CLEAN" worksheet within "WC List of Diagnostic Radiology and Ultrasound CPT Codes for Image One Analysis.xlsx"), screen capture & the attached CODE AS / FOR context: ... DRAG AND DROP FOR CONTEXT
				~ PLEASE NOTE: This MODIFICATION will REPLACE ANY existing code assigning the 'Contracting_Proposal_Category' AND 'Proposed_Rate_Payment' FIELD(S). AS such PLEASE ENSURE the removal OF ANY lines NOT applicable to the current contracting request.
				~ LEVERAGE the existing PAID_NET_AMT AS the baseline equivalent TO CURRENT rates.
				~ FOR Per Diem  OR Per Day calculations PLEASE leverage the following example: NULLIF(ISNULL([HCT LOGIC DAY(S)],0),0) * 1400 -- IP Mild/Moderate Psych $1,400/Day

x CHARINDEX() FIND() SEARCH() 'FROM;SALIM  SUBJECT:Utilization Request- Image One (Diagnostic Radiology and Ultrasound)', SUBJECT:Contracting QA / Peer Review of Utilization Request- Image One (Diagnostic Radiology and Ultrasound)

-- =====================================================================================
-- IMAGE ONE CONTRACTING PROPOSAL - DIAGNOSTIC RADIOLOGY AND ULTRASOUND SERVICES
-- Effective Date: 01/01/2026 (Per Contracting Request dated 12/01/2025)
-- Provider: Image One (TIN 934968340, NPI 1093585036)
-- Locations: Chula Vista, El Cajon, La Mesa, San Diego
-- =====================================================================================
-- Current Rates: Diagnostic Radiology 107% of Medi-Cal | Ultrasound 120% of Medi-Cal
-- Proposed Rates: Diagnostic Radiology 105.4% of Medicare | Ultrasound 105.4% of Medicare
-- Date Range: 09/01/2024 through 08/31/2025 (All paid claims)
-- Claims Lag: Report run no earlier than 09/01/2025 (allows 3 mos lag)
-- Provider contracted since: 06/01/2024
-- =====================================================================================

,NULLIF(PAID_NET_AMT,0) * 1.00 AS [Current_Rate_Payment] -- ASSUME THAT WHAT HAS BEEN PAID IS WHAT THE CONTRACTING DEPT. HAS DOCUMENTED

,CASE -- COS (Category of Service) assignment ...
WHEN [CPT Service Code] IN ('70030','70100','70110','70130','70140','70150','70160','70200','70210','70220','70250','70260','70300','70330','70360','71045','71046','71047','71048','71100','71101','71110','71111','71120','72020','72040','72050','72052','72070','72074','72080','72081','72082','72083','72084','72100','72110','72114','72170','72190','72202','72220','73000','73010','73020','73030','73050','73060','73070','73080','73090','73100','73110','73120','73130','73140','73501','73502','73503','73521','73522','73523','73552','73560','73562','73564','73590','73600','73610','73620','73630','73650','73660','74018','74019','74022','76010','77073','77075') -- Diagnostic Radiology Services (79 CPT Codes)
	AND NOT NULLIF(ISNULL([EQUIV_allow_compare],0),0) = 0 -- NO NOT NEGATIVE <> != ... APPLES TO APPLES EQUIV FEE SCHEDULE VAL ONLY!
THEN 'OP Diagnostic Radiology'
WHEN [CPT Service Code] IN ('19000','19083','19084','20206','58340','76536','76604','76641','76642','76700','76705','76706','76770','76775','76801','76802','76815','76817','76830','76856','76857','76870','76882','76942','93880','93922','93925','93926','93970','93971','93975','93976','93979') -- Ultrasound Services (33 CPT Codes)
	AND NOT NULLIF(ISNULL([EQUIV_allow_compare],0),0) = 0 -- NO NOT NEGATIVE <> != ... APPLES TO APPLES EQUIV FEE SCHEDULE VAL ONLY!
THEN 'OP Ultrasound'
ELSE TRY_CONVERT(nvarchar(255),'Other Services - Not in Scope') -- DEFAULT CATCH - ALL
END AS [Contracting_Proposal_Category]

,CASE -- Proposed Rate Payment ...
WHEN [CPT Service Code] IN ('70030','70100','70110','70130','70140','70150','70160','70200','70210','70220','70250','70260','70300','70330','70360','71045','71046','71047','71048','71100','71101','71110','71111','71120','72020','72040','72050','72052','72070','72074','72080','72081','72082','72083','72084','72100','72110','72114','72170','72190','72202','72220','73000','73010','73020','73030','73050','73060','73070','73080','73090','73100','73110','73120','73130','73140','73501','73502','73503','73521','73522','73523','73552','73560','73562','73564','73590','73600','73610','73620','73630','73650','73660','74018','74019','74022','76010','77073','77075') -- Diagnostic Radiology Services (79 CPT Codes)
	AND NOT NULLIF(ISNULL([EQUIV_allow_compare],0),0) = 0 -- NO NOT NEGATIVE <> != ... APPLES TO APPLES EQUIV FEE SCHEDULE VAL ONLY!
THEN NULLIF(EQUIV_allow_compare,0) * 1.054 -- Note: Rates vary by CPT code; using EQUIV_allow_compare as the #baseline ...105.4% of Medicare
WHEN [CPT Service Code] IN ('19000','19083','19084','20206','58340','76536','76604','76641','76642','76700','76705','76706','76770','76775','76801','76802','76815','76817','76830','76856','76857','76870','76882','76942','93880','93922','93925','93926','93970','93971','93975','93976','93979') -- Ultrasound Services (33 CPT Codes)
	AND NOT NULLIF(ISNULL([EQUIV_allow_compare],0),0) = 0 -- NO NOT NEGATIVE <> != ... APPLES TO APPLES EQUIV FEE SCHEDULE VAL ONLY!
THEN NULLIF(EQUIV_allow_compare,0) * 1.054 -- Note: Rates vary by CPT code; using EQUIV_allow_compare as the #baseline  ... 105.4% of Medicare 
ELSE (NULLIF(PAID_NET_AMT,0)+ISNULL([TRI Payment],0)) * 1.05 -- DEFAULT CATCH - ALL ... ~ 5% INCREASE BUILT - IN
END AS [Proposed_Rate_Payment]

,ISNULL((NULLIF(EQUIV_allow_compare,0)* 1.05),((NULLIF(PAID_NET_AMT,0)+ISNULL([TRI Payment],0)) * 1.05)) AS 'Counter_Offer_Payment' -- ASSUME THAT WHAT HAS BEEN PAID IS WHAT THE CONTRACTING DEPT. HAS DOCUMENTED
-- ,ISNULL((NULLIF(EQUIV_allow_compare,0)* 1.05),(NULLIF(PAID_NET_AMT,0) * 1.05)) AS 'Counter_Offer_Payment' -- ASSUME THAT WHAT HAS BEEN PAID IS WHAT THE CONTRACTING DEPT. HAS DOCUMENTED
-- ,NULLIF(PAID_NET_AMT,0) * 1.05 AS 'Counter_Offer_Payment' -- ASSUME THAT WHAT HAS BEEN PAID IS WHAT THE CONTRACTING DEPT. HAS DOCUMENTED

-- =====================================================================================
-- BUSINESS RULES & ASSUMPTIONS:
-- =====================================================================================
-- 1. EQUIV_allow_compare represents Medicare allowed amounts (baseline for rate calculations)
-- 2. PAID_NET_AMT represents current contracted payment amounts
-- 3. TRI Payment included where applicable for complete payment picture
-- 4. Proposed rates are 105.4% of Medicare for BOTH Diagnostic Radiology and Ultrasound
-- 5. Counter offer provides 5% increase over current rates as negotiation fallback
-- 6. Date range ensures 12 months of historical data with 3-month claims lag
-- 7. All 112 CPT codes (79 Diagnostic Radiology + 33 Ultrasound) explicitly listed
-- =====================================================================================
-- VALIDATION NOTES:
-- =====================================================================================
-- • Verify EQUIV_allow_compare contains Medicare rates (not Medi-Cal)
-- • Confirm CPT codes match Image One's service capabilities at all 4 locations
-- • Validate current rates align with existing contract (107% and 120% of Medi-Cal)
-- • Review claims volume by CPT code to identify high-impact codes for negotiation
-- • Cross-reference with provider specialty codes (DXC, DRD) for appropriate categorization
-- =====================================================================================







JAH 'CONTRACTING PREP'
		⏎ ACT AS a Senior Data Analyst WITH 20+ years of EXPERIENCE. IN the voice of Robert F Smith CEO of Vista Equity may I have you assist in categorizing the new dynamic summary added to the Contracting Dept. negotiation proposal report with the full code script & screen captures provided for context
		
		SELECT 'LEVEARGE: "NEW DYNAMIC SUMMARY.jpg"'
		SELECT 'LEVEARGE: "NEW DYNAMIC SUMMARY Fx FORMULA.jpg"'
		
file://netapp02/IS/Informatics/_Informatics%20Deliverables/Contracting/Adhoc/Rady''s%20Children%20Hospital%20Rate%20Increase%20Report/  - 'DELIVERABLE'
file://netapp02/IS/Informatics/_Informatics%20Deliverables/Contracting/Adhoc/UCSD/  - 'DELIVERABLE'
	
TO: Phil Steffek <psteffek@chgsd.com>; Adrian Arce <AArce@chgsd.com>; Tatsani Flora <TInkha@chgsd.com>; Christopher Duenas <cduenas@chgsd.com>; Salim French <sfrench@chgsd.com>; Elizabeth Valdez, MBA <evaldez@chgsd.com>; Yousaf Farook <YFaroo@chgsd.com>;John Costello <jcostello@chgsd.com>

Team, a new 'Dynamic Summary Categorization Section'	has been added to the 'Summary by PayTo by LOB by COS' worksheet. This new section can be found beginning at column 'Y'. Report analysis and SQL categorization has been attached for context. Also see initital request with categorization specifics below:

,AdmitID
,[Alt. AdmitID]

COUNT(DISTINCT(AdmitID)) AS 'Admit Visit Interaction',

/* SELECT ' ' AS 'TEMPLATE: BY [Contracting_Proposal_Category] WITH DYNAMIC COUNTER % Summary',
PAYTONM AS [Pay To Provider],
[LOB],
[Contracting_Proposal_Category] AS 'Category',
COUNT(DISTINCT(AdmitID)) AS 'Admit Visit Interaction',
COUNT(DISTINCT memid) AS [Total Unique Members],
SUM(Actual_Payment) AS [Actual Amount Paid],
SUM(CASE WHEN ISNULL([HCT LOGIC DAY(S)],0) = 0 THEN ISNULL(QUANTITY,0) ELSE ISNULL([HCT LOGIC DAY(S)],0) END) AS [Days / Units],
TRY_CONVERT(nvarchar(255),NULL) AS 'Unit Type ',
TRY_CONVERT(nvarchar(255),NULL) AS 'Currently Paid at: ',
SUM(Proposed_Rate_Payment) AS [Proposed Total Paid],
TRY_CONVERT(nvarchar(255),NULL) AS 'Proposed Rate: '
FROM #ContractAnalysis
WHERE 1=1
	AND [Contracting_Proposal_Category] NOT IN ('Other Services') -- NO NOT NEGATIVE <> != THE 'DEFAULT CATCH - ALL'
	AND [LOB] IS NOT NULL -- NO NOT NEGATIVE <> != ONLY PULL ASSIGNED LOB CLAIM LINE DETAIL
GROUP BY PAYTONM,LOB,[Contracting_Proposal_Category]
ORDER BY PAYTONM,[Contracting_Proposal_Category]; */

,su.AdmitID
,su.[Alt. AdmitID]

Fyi, the ‘most common’ definition of an Admit / Visits / Interaction = 'Unique person, date of service, and provider (RENDERING) = one visit' OR 'Unique person, date of service, and NDC = one script'

FOR 'RADY HOSPITAL: '
,CASE -- COS (Category of Service) assignment for current contracting request ONLY
-- Inpatient Services
WHEN revcode = '0120'
THEN 'Convalescent Unit'
WHEN revcode = '0194'
THEN 'Sub-Acute Unit w/ Ventilator'
WHEN revcode IN ('0190','0191','0192','0193')
THEN 'Sub-Acute Unit w/o Ventilator'
WHEN revcode = '0199'
THEN 'Convalescent Chronic Pain Management'
WHEN revcode = '0180'
THEN 'Bed Hold'
/* WHEN ISNULL(revcode,'') IN ('0169')
THEN 'Admin Day' */
WHEN revcode = '0185'
THEN 'Administrative Day'
WHEN revcode IN ('0480','0481','0482','0483')
THEN 'OP Cardiac Cath'
WHEN revcode BETWEEN '0360' AND '0369'
	OR revcode IN ('0490','0499')
THEN 'OP Surgery'
WHEN revcode IN ('0274','0275','0276','0278','0279')
THEN 'OP Surgical Implants'
WHEN revcode BETWEEN '0681' AND '0689'
THEN 'OP Trauma'
WHEN revcode IN ('0510')
	OR [CPT Service Code] IN ('Z7500')
THEN 'Clinic Room Charge'
WHEN revcode = '0456'
THEN 'Urgent Care'
WHEN revcode IN ('0450')
	OR [CPT Service Code] IN('Z7502')
THEN 'Emergency Room'
WHEN revcode BETWEEN '0430' AND '0439'
THEN 'Occupational Therapy'
WHEN revcode BETWEEN '0420' AND '0429'
THEN 'Physical Therapy'
WHEN revcode BETWEEN '0440' AND '0449'
THEN 'Speech Therapy'
WHEN [CPT Service Code] = 'J1428' -- Exondys
THEN 'OP High-Cost Drug - Exondys'
WHEN [CPT Service Code] = 'J2326' -- Spinraza
THEN 'OP High-Cost Drug - Spinraza'
WHEN [CPT Service Code] = 'J3399' -- Zolgensma
THEN 'OP High-Cost Drug - Zolgensma'
WHEN [CPT Service Code] = 'Q2042' -- Kymriah
THEN 'OP High-Cost Drug - Kymriah'
WHEN revcode = '0252' 
	OR [CPT Service Code] IN ('J7189','J7190','J7191','J7192','J7193','J7194','J7195','J7196','J7197','J7198','J7199')
THEN 'OP Hemophilia Factor'
WHEN [CPT Service Code] IN ('S9365','S9366','S9367','S9368')
THEN 'Home Infusion - TPN'
WHEN [CPT Service Code] IN ('S9373','S9374','S9375','S9376','S9377')
THEN 'Home Infusion - IV Hydration'
WHEN [CPT Service Code] = 'S9325'
THEN 'Home Infusion - Pain Management'
WHEN [CPT Service Code] = 'S9329'
THEN 'Home Infusion - Bolus or Continuous Chemotherapy'
WHEN [CPT Service Code] IN ('S9494','S9497','S9500','S9501','S9502','S9503','S9504')
THEN 'Home Infusion - Antibiotics'
WHEN [CPT Service Code] IN ('S9340','S9341','S9342','S9343')
THEN 'Home Infusion - Enteral Nutrition'
WHEN [CPT Service Code] = 'S9338'
THEN 'Home Infusion - IVIG'
WHEN [CPT Service Code] = 'S9345'
THEN 'Home Infusion - Factor Therapy'
WHEN [CPT Service Code] IN ('S5498','S5501')
THEN 'Home Infusion - Central Catheter Care'
WHEN [CPT Service Code] = 'S9542'
THEN 'Home Infusion - Injectable Drugs'
WHEN [CPT Service Code] = 'J1785'
THEN 'Home Infusion - Cerezyme'
WHEN [CPT Service Code] IN ('S9379','S9543')
THEN 'Home Infusion - IV Push'
WHEN [CPT Service Code] IN ('E0202','S9098')
THEN 'Home Infusion - Phototherapy'
WHEN [CPT Service Code] = 'S9558'
THEN 'Home Infusion - Growth Hormone'
WHEN [CPT Service Code] = 'S9555'
THEN 'Home Infusion - Multiple Therapies'
WHEN [CPT Service Code] LIKE 'S9%' -- Unlisted Home Infusion Therapies ... All other therapies not listed above.
	AND NOT [CPT Service Code] IN ('S9365','S9366','S9367','S9368','S9373','S9374','S9375','S9376','S9377','S9325','S9329','S9494','S9497','S9500','S9501','S9502','S9503','S9504','S9340','S9341','S9342','S9343','S9338','S9345','S9542','S9379','S9543','S9098','S9558','S9555') -- NO NOT NEGATIVE <> != ... 
THEN 'Home Infusion - Unlisted Therapies'
WHEN revcode = '0551'
THEN 'Home Health - Skilled Nursing'
WHEN revcode = '0552'
THEN 'Home Health - Extended Skilled Nursing'
WHEN revcode = '0559'
THEN 'Home Health - Maternal/Child Visit'
WHEN QNXTbilltype LIKE '1[1-2]%' -- 'INPATIENT'
THEN 'All Other Inpatient Services'-- Inpatient Services (current 120% Medi-Cal rate + 4.56%)
WHEN QNXTbilltype LIKE '1[3-4]%' -- 'OUTPATIENT'
THEN 'All Other Outpatient Services'	-- General Outpatient Services (catch-all for other OP services not specifically listed) ... OP Services including urgent care, observation(B) & OP Rehab Services not separately designated, OP MRI, Proton Beam Therapy, Infusion Therapy, OP Chemo, Unlisted Home Infusion Therapies ??? 
ELSE TRY_CONVERT(nvarchar(255),'Other Services') -- DEFAULT CATCH - ALL
END AS [Contracting_Proposal_Category]

FOR 'UCSD HOSPITAL: '
,CASE -- COS (Category of Service) assignment ...
WHEN revcode LIKE '025%' 
	OR revcode LIKE '063%' 
	OR revcode IN ('0343')
THEN 'Pharmaceuticals'
WHEN revcode IN ('0114', '0124', '0134', '0144', '0154', '0204')
THEN 'IP Mild/Moderate Psych'
WHEN revcode = '0901'
THEN 'ECT'
WHEN revcode = '0904'
THEN 'OP Mild/Moderate'
WHEN revcode = '0912'
THEN 'OP Psych Eating Disorder Half Day'
WHEN revcode = '0913'
THEN 'OP Psych Eating Disorder Full Day'
WHEN [finalDRG+SOI] LIKE '008%[1-4]'
THEN 'Car-T Cell Therapy'
WHEN revcode IN ('0274', '0275', '0276', '0278', '0624')
THEN 'Implants'
WHEN [finalDRG+SOI] LIKE '440%[1-4]'
	OR [finalDRG+SOI] IN ('650', '651', '652')
THEN 'Kidney Transplant'
WHEN revcode = '0169'
THEN 'Admin Day'
WHEN QNXTbilltype LIKE '1[1-2]%' -- 'INPATIENT'
THEN 'Inpatient Base'
WHEN QNXTbilltype LIKE '1[3-4]%' -- OUTPATIENT 
THEN 'General OP' -- Default to General OP for other codes
ELSE TRY_CONVERT(nvarchar(255),'Other Services') -- DEFAULT CATCH - ALL
END AS [Contracting_Proposal_Category]






'Inpatient Services through the ER' SEQUENCE FOR BOTH:
-- ======================================================================================
	-- INCLUSION / EXCLUSION ... ER (EMERGENCY ROOM) VISIT THAT RESULTS IN AN IP (INPATIENT) ADMIT: 
-- ======================================================================================
;WITH ipa AS
( -- INITIATE ...
SELECT DISTINCT su.memid
,su.claimid
,su.claimline
,su.DOS AS 'AdmissionDate'
,TRY_CONVERT(date,ISNULL(su.DOSTHRU,GETDATE())) AS 'DischargeDate'
FROM INFORMATICS.dbo.CONTRACTING_UCSD AS su
	JOIN #ContractAnalysis AS ca ON su.claimid = ca.claimid
		AND su.claimline = ca.claimline
WHERE 1=1
	AND ca.Contracting_Proposal_Category LIKE '%Inpatient%'
) -- CONCLUDE ...

		-- SELECT *,DATEADD(day,1,TRY_CONVERT(date,AdmissionDate)) AS 'Day After AdmissionDate' FROM ipa

,erv AS
( -- INITIATE ...
SELECT DISTINCT er.memid
,er.claimid
,er.claimline
,er.DOS AS 'AdmissionDate'
,TRY_CONVERT(date,ISNULL(er.DOSTHRU,GETDATE())) AS 'DischargeDate'
FROM INFORMATICS.dbo.CONTRACTING_UCSD AS er
WHERE 1=1
	AND CASE
	WHEN SUBSTRING(LTRIM(RTRIM(ISNULL(er.revcode,''))),1,1) = 'Z'
	THEN  LTRIM(RTRIM(er.revcode))
	WHEN SUBSTRING(LTRIM(RTRIM(ISNULL(er.revcode,''))),1,1) = '0'
	THEN  SUBSTRING(LTRIM(RTRIM(ISNULL(er.revcode,''))),2,3)
	ELSE LTRIM(RTRIM(ISNULL(er.revcode,'')))
	END LIKE '45%'
	AND (er.QNXTbilltype  LIKE '13%' -- HOSPITAL  OP
		OR er.QNXTbilltype  LIKE '14%') -- HOSPITAL Oth
	AND er.[ClmType] = 'FACILITY'
) -- CONCLUDE ...

		-- SELECT * FROM erv

,ipaviatheer AS 
( -- INITIATE ...
SELECT DISTINCT ip.*
FROM ipa AS ip
	JOIN erv AS er ON ip.memid = er.memid
WHERE 1=1
	AND TRY_CONVERT(date,er.DischargeDate) BETWEEN TRY_CONVERT(date,ip.AdmissionDate) AND DATEADD(day,1,TRY_CONVERT(date,ip.AdmissionDate)) -- RINA(): APPLIED TO FIELD WITHIN TABLE TO BE UPDATED 
	)
	
		-- SELECT * FROM ipaviatheer

		/* SELECT ' ' AS 'QA ER THAT RESULT INTO AN IP ADMIT: '
		,memid
		,SUBSCRID AS 'HealthPlanID'
		,MEMNM
		,QNXTbilltype
		,BillTypeDescr
		,revcode
		,[REVCDE Descr]
		,DOS
		,DOSTHRU,* 
		FROM INFORMATICS.dbo.CONTRACTING_UCSD AS su
		WHERE 1=1 
			AND su.memid IN ('853483','2060516','1046703')
		ORDER BY su.memid,TRY_CONVERT(date,DOS) ASC */

UPDATE #ContractAnalysis
SET Contracting_Proposal_Category = 'Inpatient Services through the ER' -- OPPOSITE OF "All Other Inpatient Services" WHICH WOULD REPRESNT IP ABSENT OF AN EMERGENCY ROOM ENCOUNTER */
FROM #ContractAnalysis AS ca
		JOIN ipaviatheer AS iper ON ca.memid = iper.memid
			AND ca.claimid = iper.claimid
			AND ca.claimline = iper.claimline
			
		-- SELECT DISTINCT QNXTbilltype,BillTypeDescr FROM INFORMATICS.dbo.CONTRACTING_UCSD

;WITH entireclaimer AS
( -- INITIATE ...
SELECT DISTINCT er.memid
,er.claimid
,er.claimline
,er.DOS AS 'AdmissionDate'
,TRY_CONVERT(date,ISNULL(er.DOSTHRU,GETDATE())) AS 'DischargeDate'
FROM INFORMATICS.dbo.CONTRACTING_UCSD AS er
WHERE 1=1
	AND CASE
	WHEN SUBSTRING(LTRIM(RTRIM(ISNULL(er.revcode,''))),1,1) = 'Z'
	THEN  LTRIM(RTRIM(er.revcode))
	WHEN SUBSTRING(LTRIM(RTRIM(ISNULL(er.revcode,''))),1,1) = '0'
	THEN  SUBSTRING(LTRIM(RTRIM(ISNULL(er.revcode,''))),2,3)
	ELSE LTRIM(RTRIM(ISNULL(er.revcode,'')))
	END IN ('450')
	AND er.QNXTbilltype IN ('111','117') -- C###: REVISED ER DEFINITION PER DSCUSSION WITH MS GRISELDA ON 20250929 '... I spoke briefly with Griselda and Rodrigo regarding identifying "Inpatient Services through the ER". ..'
) -- CONCLUDE ...

		-- SELECT * FROM entireclaimer
		
UPDATE #ContractAnalysis
SET Contracting_Proposal_Category = 'Inpatient Services through the ER' -- OPPOSITE OF "All Other Inpatient Services" WHICH WOULD REPRESNT IP ABSENT OF AN EMERGENCY ROOM ENCOUNTER */
FROM #ContractAnalysis AS ca
		JOIN entireclaimer AS iper ON ca.claimid = iper.claimid







JAH 'Accommodation Code'
x LEVERAGE: "CLAIM_ACCOMMODATION_CODE_20251001.sql"

		⏎ ACT AS a Senior Data Analyst WITH 20+ years of EXPERIENCE. IN the voice of Robert F Smith CEO of Vista Equity, May I have you PLEASE ASSIST IN GENERATING AN EXECUTIVE SUMMARY 'CXO EXECUTIVE SUMMARY' TO FACILITATE STORYTELLING WITH CONTEXT. PLEASE 'CONTRAST' AND 'COMPARE' IN DETAIL the attached Contracting scripts with special focus on the implementation of the [Accommodation Code] logic which was added to the most current version ('CONTRACTING_PACS_20251001.sql')

,TRY_CONVERT(decimal(11,2),0) AS 'Accommodation Code' -- LEVERAGE: "CLAIM_ACCOMMODATION_CODE_20251001.sql"

-- =====================================================================
	-- ACCOMMODATION CODE(S) - LEVERAGE: PACS CONTRACTING': 
-- =====================================================================
;WITH acccode AS 
( -- INITIATE ...
SELECT ' ' AS 'ONE 1 OR THE OTHER VAL(): '
,cv.*
FROM HMOPROD_PLANDATA.dbo.ClaimValue AS cv
WHERE 1=1
	-- AND cv.claimid IN ('25135E02709') -- SAMPLE: 
	AND cv.valuecode IN ('24') -- ... Also, per Claims (Rodrigo), the .76 and .75 are separate from the rev code and can be found in QNXT in the Claims Module, go to UB codes and find subsection titled “Value Codes”. The “amount” listed for Value Code 24 will be the code that describes the type of service.
	AND (cv.amount = .75 -- Vent (.75)
		OR cv.amount = .76)  -- Non-Vent (.76)
		) -- CONCLUDE ...

		-- SELECT * FROM acccode

	-- CHECK FOR DUP(S) --
/* SELECT ' ' AS 'SHOULD RETURN 0 ROWS - DUP Validation: ',*
FROM acccode
WHERE 1=1 
	AND claimid IN
	( -- INITIATE ...
	SELECT claimid
	FROM acccode AS dup
	GROUP BY claimid -- Duplication Driver 
	HAVING COUNT(1)>1 -- HAVING clause RESERVED for AGGREGATE(s) ... HAVING SUM(PAID_NET_AMT) != 0
	); -- CONCLUDE ... */
	
UPDATE INFORMATICS.dbo.CONTRACTING_PACS
SET [Accommodation Code] = TRY_CONVERT(decimal(11,2),cv.amount)
FROM INFORMATICS.dbo.CONTRACTING_PACS AS c
	JOIN acccode AS cv ON c.claimid = cv.claimid
	
,CASE -- COS (Category of Service) assignment for current contracting request ONLY ... Per SDPA, “just to clarify, the revenue code for all sub-acute patients is 0190 and the accommodation code to determine if it is and non-vent (.76) and Vent (.75). In summary:
WHEN revcode IN ('0190')
	AND [Accommodation Code] = .76 -- 1.	Trache (non vent) – a.	Rev Code 0190 with accommodation code .76
THEN 'Trache (Non - Ventilation)'
WHEN revcode IN ('0190')
	AND [Accommodation Code] = .75 -- 2.	Vent – a.	Rev Code 0190 with accommodation code .75 
THEN 'Ventilation'
WHEN revcode IN ('0110')
	OR [CPT Service Code] IN ('87252','87253') -- CPT, HCPCS, PROCEDURE_CODE(S) ... 3.	Isolation a.	HCPC code is 87252 and 87253 for viral isolation. b.	Rev Code - Often when we bill separately for isolation, we use the Rev code 0110 but usually it is depending on the provider and how they want us to bill.”
THEN 'Isolation'
ELSE TRY_CONVERT(nvarchar(255),'Other Services') -- DEFAULT CATCH - ALL
END AS [Contracting_Proposal_Category]	

,CASE -- COS (Category of Service) assignment for current contracting request ONLY ... Per SDPA, “just to clarify, the revenue code for all sub-acute patients is 0190 and the accommodation code to determine if it is and non-vent (.76) and Vent (.75). In summary:
WHEN revcode IN ('0190')
	AND [Accommodation Code] = .76 -- 1.	Trache (non vent) – a.	Rev Code 0190 with accommodation code .76
THEN NULLIF(ISNULL([QUANTITY],0),0) * 850 -- ,cd.servunits AS [QUANTITY] ... AS [units_adj] ... AS 'Units adj' THEN 'Trache (Non - Ventilation)'
WHEN revcode IN ('0190')
	AND [Accommodation Code] = .75 -- 2.	Vent – a.	Rev Code 0190 with accommodation code .75 
THEN NULLIF(ISNULL([QUANTITY],0),0) * 950 -- ,cd.servunits AS [QUANTITY] ... AS [units_adj] ... AS 'Units adj' THEN 'Ventilation'
WHEN revcode IN ('0110')
	-- OR [CPT Service Code] IN ('87252','87253') -- CPT, HCPCS, PROCEDURE_CODE(S) ... 3.	Isolation a.	HCPC code is 87252 and 87253 for viral isolation. b.	Rev Code - Often when we bill separately for isolation, we use the Rev code 0110 but usually it is depending on the provider and how they want us to bill.”
THEN (NULLIF(ISNULL([PAID_NET_AMT],0),0)+(NULLIF(ISNULL([QUANTITY],0),0) * 250)) -- ,cd.servunits AS [QUANTITY] ... AS [units_adj] ... AS 'Units adj' THEN 'Isolation'
ELSE (NULLIF(ISNULL(PAID_NET_AMT,0),0)+ISNULL([TRI Payment],0)) * 1.05 -- Default catch-all ... ~ 5% INCREASE BUILT - IN
END AS [Proposed_Rate_Payment] -- [INVOICE AMT] ... cd.amountpaid AS 'PAID_NET_AMT' PROVEN to represent true COST (see pv.amountpaid AS CHECKAMT)  + PAID (BAP) ... c.	There is a field in the service tab for invoice cost, but it is not utilized by the Claims Department when pricing DME. The cost of invoice, including mark-ups and augmented contract rates, are calculated by the analyst and manually input to pay the claim.



	
	
	
	
JAH 'IP VIA THE ER'
		⏎ ACT AS a Senior Data Analyst WITH 20+ years of EXPERIENCE. IN the voice of Robert F Smith CEO of Vista Equity, May I have you PLEASE ASSIST IN GENERATING AN EXECUTIVE SUMMARY 'CXO EXECUTIVE SUMMARY' with specific focus on how the Contracting_Proposal_Category of 'Inpatient Services through the ER' is being applied to each of the attached CODE SETS

		⏎ ACT  AS a Senior Data Analyst WITH 20+ years of EXPERIENCE. PLEASE ENSURE ALIGNMENT BETWEEN the existing CODE AND the ASK, WITH that ASK being to UPDATE the 'Contracting_Proposal_Category' field when the ER Visit resulted in an IP admit. I have attached the CODE dedicated to this for context ... DRAG AND DROP

What we are re-classifying:

We are isolating inpatient stays that originate in the emergency room and tagging those claim lines as Contracting_Proposal_Category = “Inpatient Services through the ER.” The category is assigned in both hospital code sets (UCSD and Rady) via two complementary inclusion paths:

1.	Direct ER flag on the inpatient claim (“entireclaimer”)
		o	Any claim with revcode 450 and inpatient bill types 111 or 117 is promoted to “Inpatient Services through the ER.” 
		CONTRACTING_UCSD_20251003
		CONTRACTING_RADY_HOSPITAL_20251…

		o	The assignment updates the working table: UPDATE #ContractAnalysis … SET Contracting_Proposal_Category = 'Inpatient Services through the ER' by joining that inpatient claim set. 
		CONTRACTING_UCSD_20251003
		CONTRACTING_RADY_HOSPITAL_20251…

2.	ER visit within 0–1 days that leads to an admission (“ipaviatheer”)
		o	We first collect IP admits (“ipa”), then link to ER facility lines with 45x revenue on 13x/14x OP bill types, same member, where ER discharge is between admit date and +1 day; those IP lines are re-classified as ER→IP. 
		CONTRACTING_UCSD_20251003
		CONTRACTING_RADY_HOSPITAL_20251…

		o	The category is then updated on the matched IP claim/line. 
		CONTRACTING_UCSD_20251003
		CONTRACTING_RADY_HOSPITAL_20251…


x SUBSTITUTE() REPLACE()
		,su.''
		,su.TRY_CONVERT
		,su.NULL
		,su.ISNULL
		
JAH 'CONTRACTING COS:  "Inpatient Services through the ER".' ON 20250929
x I spoke briefly with Griselda and Rodrigo regarding identifying "Inpatient Services through the ER".  

Their recommendation:

If the claim has:
a line where the rev code is 0450
and a line where the bill type is 0111 or 0117

Then count the entire claim as "Inpatient Services through the ER"

		-- SELECT DISTINCT QNXTbilltype,BillTypeDescr FROM INFORMATICS.dbo.CONTRACTING_UCSD

;WITH entireclaimer AS
( -- INITIATE ...
SELECT DISTINCT er.memid
,er.claimid
,er.claimline
,er.DOS AS 'AdmissionDate'
,TRY_CONVERT(date,ISNULL(er.DOSTHRU,GETDATE())) AS 'DischargeDate'
FROM INFORMATICS.dbo.CONTRACTING_UCSD AS er
WHERE 1=1
	AND CASE
	WHEN SUBSTRING(LTRIM(RTRIM(ISNULL(er.revcode,''))),1,1) = 'Z'
	THEN  LTRIM(RTRIM(er.revcode))
	WHEN SUBSTRING(LTRIM(RTRIM(ISNULL(er.revcode,''))),1,1) = '0'
	THEN  SUBSTRING(LTRIM(RTRIM(ISNULL(er.revcode,''))),2,3)
	ELSE LTRIM(RTRIM(ISNULL(er.revcode,'')))
	END IN ('450')
	AND er.QNXTbilltype IN ('111','117') -- C###: REVISED ER DEFINITION PER DSCUSSION WITH MS GRISELDA ON 20250929 '... I spoke briefly with Griselda and Rodrigo regarding identifying "Inpatient Services through the ER". ..'
) -- CONCLUDE ...

		-- SELECT * FROM entireclaimer
		
UPDATE #ContractAnalysis
SET Contracting_Proposal_Category = 'Inpatient Services through the ER' -- OPPOSITE OF "All Other Inpatient Services" WHICH WOULD REPRESNT IP ABSENT OF AN EMERGENCY ROOM ENCOUNTER */
FROM #ContractAnalysis AS ca
		JOIN entireclaimer AS iper ON ca.claimid = iper.claimid

		-- SELECT DISTINCT QNXTbilltype,BillTypeDescr FROM INFORMATICS.dbo.CONTRACTING_RADYHOSP

;WITH entireclaimer AS
( -- INITIATE ...
SELECT DISTINCT er.memid
,er.claimid
,er.claimline
,er.DOS AS 'AdmissionDate'
,TRY_CONVERT(date,ISNULL(er.DOSTHRU,GETDATE())) AS 'DischargeDate'
FROM INFORMATICS.dbo.CONTRACTING_RADYHOSP AS er
WHERE 1=1
	AND CASE
	WHEN SUBSTRING(LTRIM(RTRIM(ISNULL(er.revcode,''))),1,1) = 'Z'
	THEN  LTRIM(RTRIM(er.revcode))
	WHEN SUBSTRING(LTRIM(RTRIM(ISNULL(er.revcode,''))),1,1) = '0'
	THEN  SUBSTRING(LTRIM(RTRIM(ISNULL(er.revcode,''))),2,3)
	ELSE LTRIM(RTRIM(ISNULL(er.revcode,'')))
	END IN ('450')
	AND er.QNXTbilltype IN ('111','117') -- C###: REVISED ER DEFINITION PER DSCUSSION WITH MS GRISELDA ON 20250929 '... I spoke briefly with Griselda and Rodrigo regarding identifying "Inpatient Services through the ER". ..'
) -- CONCLUDE ...

		-- SELECT * FROM entireclaimer

UPDATE #ContractAnalysis
SET Contracting_Proposal_Category = 'Inpatient Services through the ER' -- OPPOSITE OF "All Other Inpatient Services" WHICH WOULD REPRESNT IP ABSENT OF AN EMERGENCY ROOM ENCOUNTER */
FROM #ContractAnalysis AS ca
		JOIN entireclaimer AS iper ON ca.claimid = iper.claimid

-- ======================================================================================
	-- INCLUSION / EXCLUSION ... ER (EMERGENCY ROOM) VISIT THAT RESULTS IN AN IP (INPATIENT) ADMIT: 
-- ======================================================================================
SELECT TOP 1 [CPT Service Code],* FROM INFORMATICS.dbo.CONTRACTING_UCSD

ALTER TABLE INFORMATICS.dbo.CONTRACTING_UCSD
ADD -- INITIATE ... ADD OF COLUMN(s)
[CPT Service Description] nvarchar(255) DEFAULT NULL -- DFLT VAL() IS NULL
; -- CONCLUDE ...

UPDATE INFORMATICS.dbo.CONTRACTING_UCSD
SET [CPT Service Description] = [Service Description]

ALTER TABLE INFORMATICS.dbo.CONTRACTING_UCSD
ADD -- INITIATE ... ADD OF COLUMN(s)
[ExecutionDate] datetime NULL -- DFLT VAL() IS NULL
; -- CONCLUDE ...

UPDATE INFORMATICS.dbo.CONTRACTING_UCSD
SET [ExecutionDate] = TRY_CONVERT(datetime,TimeStamp)

x LEVERAGE: "CA 4.3", "ADHOC CA 4.1"







JAH 'Admin Days/PACS SNF services'
		⏎ ACT AS a Senior Data Analyst WITH 20+ years of EXPERIENCE. IN the voice of Robert F Smith CEO of Vista Equity, May I have you PLEASE ENSURE ALIGNMENT BETWEEN the existing CODE AND the REQUIREMENTS attached FOR CONTEXT:

		⏎ Thank you, how might I leverage the attached files to arrive at the desired '90% of PDPM for Subacute Nursing Rev Code 0169 and 0190' proposed rate?

SELECT 'REVENUE_CODE' AS [CodeType],ISNULL(rc.description,'') AS [CodeDescr],rc.*
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st',
FROM HMOPROD_PLANDATA.dbo.revcode AS rc 
WHERE 1=1 
	AND rc.codeid IN ('0169','0190') -- 'Admin Days/PACS SNF services'

SELECT TOP  1 *
FROM INFORMATICS.[dbo].date_calendarISO AS dc -- CALENDAR(S)
CROSS APPLY ( -- INDEPENDENT STAND ALONE ... CROSS APPLY() CROSS JOIN() CARTESIAN PRODUCT
SELECT *
FROM HMOPROD_PLANDATA.dbo.benefitplan AS bp
) AS bp

SELECT ' ' AS '⏎ PDPM = PATIENT DRIVEN PAYMENT MODEL: '
,274.15 * 0.90  AS '90% of 2025 Regular Services rate'
,264.63 * 0.90  AS'90% of 2025 Leave Days rate '
,285.67 * 0.90  AS '90% of 2025 Regular Services rate'
,275.90 * 0.90  AS'90% of 2025 Leave Days rate '

Key PDMP Rate Information for San Diego Post-Acute Center (NPI: 1285061085)
		2024 PDPM Rates:

		Revenue Code 0101 (Regular Services): $274.15 per day
		Revenue Code 0180 (Leave Days): $264.63 per day

		2025 PDPM Rates:

		Revenue Code 0101 (Regular Services): $285.67 per day
		Revenue Code 0180 (Leave Days): $275.90 per day

,CASE 
WHEN revcode IN ('0169','0190') 
	AND DOS BETWEEN TRY_CONVERT(date,'01/01/2024') AND TRY_CONVERT(date,'12/31/2024') -- ,TRY_CONVERT(date,CLAIMDATA.startdate) AS [DOS]
THEN NULLIF(ISNULL([HCT LOGIC DAY(S)],0),0) * (
CASE 
WHEN ISNULL(revcode,'') IN ('0169') 
THEN 274.15 * 0.90  -- 90% of 2025 Regular Services rate
WHEN ISNULL(revcode,'') IN ( '0190') 
THEN $264.63 * 0.90  -- 90% of 2025 Leave Days rate  
ELSE 274.15 * 0.90  -- Default to regular services rate
END) 
WHEN revcode IN ('0169','0190') 
	AND DOS BETWEEN TRY_CONVERT(date,'01/01/2025') AND TRY_CONVERT(date,'12/31/2025') -- ,TRY_CONVERT(date,CLAIMDATA.startdate) AS [DOS]
THEN NULLIF(ISNULL([HCT LOGIC DAY(S)],0),0) * (
CASE 
WHEN ISNULL(revcode,'') IN ('0169') 
THEN 285.67 * 0.90  -- 90% of 2025 Regular Services rate
WHEN ISNULL(revcode,'') IN ( '0190') 
THEN 275.90 * 0.90  -- 90% of 2025 Leave Days rate  
ELSE 285.67 * 0.90  -- Default to regular services rate
END) 
ELSE (NULLIF(ISNULL(PAID_NET_AMT,0),0)+ISNULL([TRI Payment],0)) * 1.05 -- Default catch-all ... ~ 5% INCREASE BUILT - IN
END AS [Proposed_Rate_Payment]







JAH 'CONTRACTING RADY HOSPITAL'
x 'TRI' = Targeted Rate Increase (TRI) rates
x 4.56% INCREASE YoY ('INCLUDE TRI PAYMENT IN THE YoY BASELINE')
		~ LEVERAGE "STEP88_TRI_TABLES_....sql"

x Good morning, Please see the utilization request for Rady Children’s Hospital 

Required Elements of Rate Increase Request	Data
Date provider made request	08/26/2025
Date Contracting brought to COO	8/26/2025
Effective date requested by Provider	10/1/2025
Date Range: e.g. 01/01/24 through 12/31/24	05/01/2024 through 04/30/2025
Claim Type: e.g. All claims with DOS 01/01/24 through 12/31/24	All paid claims 05/01/2024 through 04/30/2025
Claims Lag: e.g. report would be run no earlier than 04/01/25 (always allow a 3 mos. claims lag)	5/1/2024
Length of time Provider has been contracted with CHG	5/1/2007
Provider TIN & Provider NPI	TIN#95-1691313 NPI#1053674564 Rady Children’s Hospital -San Diego
Provider Specialty(ies)	Hospital  
Hospital Financials: for Hosp. contracting review most recent financials published by State	N/A
Line of Business: Medi-Cal and/or D-SNP and/or C-SNP and combined	Medi-Cal
Current Rates: $$ and applicable fee schedule (e.g. 100% of Medi-Cal)	Inpatient Services     	120%  Medi-Cal DRG
0120 Convalescent Unit 	$ 665.00 Per Diem
0194 Sub-Acute Unit w/ Ventilator	100% Medi-Cal Rates
0190-0193 Sub-Acute Unit w/o Ventilator	100% Medi-Cal Rates
0199 Convalescent Chronic Pain Management	$2,900.00 Per Diem 
0180                 Bed Hold                                           $356 Per Diem
Bed Hold up to seven days per hospitalization in the event patient requires transfer to an acute care facility.

0185                 Administrative Day                             $356 Per Diem
Outpatient (“OP”) Services	
0480 – 0483 OP Cardiac Cath	175% Medi-Cal Rates

0360 – 0369, 0490, 0499 OP Surgery
	175% Medi-Cal Rates (Including multiple surgical procedures)
0274-0276, 0278-0279 OP Surgical Implants(A)	Invoice Cost + 2%
0681 – 0689 OP Trauma	60% of Billed Charges, not to exceed $19,120.00 per day
0510, Z7500 Clinic Room Charge	175% of Medical Rates
OP Services including urgent care, observation(B) & OP Rehab Services not separately designated	175% Medical Rates
0456 Urgent Care	175% Medical Rates
0450, Z7502 Emergency Room	175% of Medical Rates
0430-0439 Occupational Therapy (“OT”)
0420 – 0429 Physical Therapy (“PT”)
0440-0449 Speech Therapy (“ST”)	175% of Medical Rates (Including Therapy & Evals)
OP MRI	175% of Medical Rates
Outpatient High-Cost Drug
J1428 (Exondys), J2326 (Spinraza) 	175% of Medi-Cal Rate
J3399 (Zolgensma)	15% of Billed Charges
Q2042 (Kymriah)	Case by case negotiation
0252 OP Hemophilia Factor (J7189, J7190-J7199)	15% of Billed Charges
Proton Beam Therapy 	Subject to LOA
Infusion Services	
Infusion Therapy 	175% of Medi-Cal Rates
OP Chemo	175% of Medi-Cal Rates
Home Infusion Services

Total Parenteral Nutrition                    S9365-S9368                             $323/day
With or without lipids.  No additional charge allowed for AWP.

IV Hydration                                         S9373-S9377                             $136/day + (AWP – 5%)
Compensation rate includes any volume of hydration, pump, pole and standard additives (electrolytes and multivitamins).

Pain Management                                S9325                                       $136/day + (AWP – 5%)
Compensation rate includes pump, cassette, and supplies for intravenous or subcutaneous use.

Bolus or Continuous Chemotherapy    S9329                                       $136/day + (AWP – 5%)
All skilled nursing visits shall be billed separately.

Antibiotics                                           S9494; S9497                           $188/day + (AWP – 5%)
                                                            S9500-S9504
Compensation rate includes pump (ambulatory and disposable ambulatory pump included depending on patient needs) and all supplies for central or peripheral access, pole, mini-bags and compounding fees.

Multiple antibiotics at different dosing regimens shall be reimbursed at $188/day + (AWP – 5%) for all antibiotics administered.  No additional per diem rate shall be allowed.

Total Enteral Nutrition                          S9340-S9343                             $  35/day + (AWP – 5%)
Compensation rate includes pump, pole, bags, and supplies for feeding tube and formula.

IVIG                                                     S9338                                       $101/day + (AWP – 5%)

Factor Therapy                                     S9345                                       $170/day + (AWP – 5%)
Per day charge. Drug dispensing frequency varies but is usually in the range of every one (1) to three (3) months.

Central Catheter Care                          S5498; S5501                           $  22/day
Catheter supply patients only.  If patient is on infusion therapy, per diem charges include either central or peripheral line supplies and care.

Injectable Drugs                                   S9542                                       $101/day + (AWP – 5%)
Compensation rate includes pump and all supplies, injectable drugs including Desferal, Epogen, Heparin, Leukine, Neupogen, Synagis, Procrit, and any other medication not specifically listed out as a separate category.  Compensation rate does not include IVIG, Factor Therapy, Antibiotics and any IV Push Drugs.  HOSPITAL shall bill only for day that drugs are actually administered.

Cerezyme                                             J1785                                       $170/day + (AWP – 5%)

IV Push                                                S9379; S9543                           $170/day + (AWP – 5%)
Includes Lasix, Bumex, Phenobarb, Dilantin and any other IM drugs administered through IV Push. 

Phototherapy/Home Bililight               E0202; S9098                           $314/day
Compensation rate includes equipment and/or light rental, nursing visit and education, and blood draws.  Compensation rate excludes lab fee for processing.

Growth Hormone                                 S9558                                       $170/day + (AWP – 5%)
Per day charge and includes all supplies.  Growth Hormone is usually dispensed approximately once every three (3) months.

Multiple Therapies                               S9555
Compensation for two therapies listed above performed on the same day shall be paid at the highest per diem plus AWP – 5% for all items.  Compensation for three or more therapies listed above performed on the same day shall be paid at the two highest per diems plus AWP – 5% for all items.

Unlisted Therapies                                                                               $163/day + (AWP – 5%)
All other therapies not listed above.

Home Health Care

0551     Skilled Nursing < 2 hours           Z6900                                       $223.45/visit
0552     Skilled Nursing > 2 hours                                                           $114.80/hour
0559     Maternal/Child Visit                                                                   $223.45/visit
Proposed Rates: % and $$ and applicable fee schedule (e.g. 100% of Medi-Cal)	All Inpatient and Outpatient, High-Cost Drug, Infusion, Home Infusion and Home Health Care services Y1- 4.56% increase; 

All services Inpatient and Outpatient, High-Cost Drug, Infusion, Home Infusion and Home Health Care Services Y2- 4.56% increase. 
Variance between current and proposed: $$ and %	TBD
Network Need: ask Sr. Dir of HCS whether or not this provider is needed should they terminate	TBD
How much paid to other similar providers (range: e.g. 100% of MCal to 120% of Medicare)	TBD by Contracting 
Unique characteristics: e.g. language, region, number of locations, number of providers, or none.	TBD by Contracting 
Recommended Counter to be offered by CHG: % and $$ and applicable fee schedule	TBD







JAH 'CONTRACTING - DR MEGAN LEWIS'
,CASE -- COS (Category of Service) assignment ...
WHEN [CPT Service Code] IN ('90791', '90834', '90837') -- Specific CPT codes for Megan B. Lewis
THEN 'Psychiatric Services'
ELSE TRY_CONVERT(nvarchar(255),'Other Services') -- DEFAULT CATCH - ALL for non-specified CPT codes
END AS [Contracting_Proposal_Category]
,CASE 
WHEN [CPT Service Code] IN ('90791', '90834', '90837') -- Specific CPT codes for Megan B. Lewis
THEN 
    CASE [CPT Service Code]
        WHEN '90791' THEN NULLIF(ISNULL([HCT LOGIC DAY(S)],0),0) * 175.00 -- $175.00 for Medi-Cal LOB
        WHEN '90834' THEN NULLIF(ISNULL([HCT LOGIC DAY(S)],0),0) * 150.00 -- $150.00 for Medi-Cal LOB
        WHEN '90837' THEN NULLIF(ISNULL([HCT LOGIC DAY(S)],0),0) * 125.00 -- $125.00 for Medi-Cal LOB
        ELSE 0
    END
ELSE 0 -- NO NOT NEGATIVE <> != PROPOSAL GIVEN FOR DEFAULT CATCH - ALL
END AS [Proposed_Rate_Payment]

 SELECT 'CPT - PROCEDURE_CODE + SERVICE CATEGORY(-ies)' AS [CodeType],ISNULL(sc.description,'') AS [CodeDescr]
 ,UPPER(LTRIM(RTRIM(scg.description)))+' - '+UPPER(LTRIM(RTRIM(scat.description)))+': '+UPPER(LTRIM(RTRIM(ssc.description))) AS ServiceCatDescr
,scg.catid
,scg.subcatid
,scg.svcgroupid
,sc.*
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st',UPPER(LTRIM(RTRIM(scg.description)))+' - '+UPPER(LTRIM(RTRIM(scat.description)))+': '+UPPER(LTRIM(RTRIM(ssc.description))) AS ServiceCatDescr
FROM HMOPROD_PLANDATA.dbo.svccode AS sc 
	LEFT JOIN HMOPROD_PLANDATA.dbo.svccatgroup AS scg ON sc.codeid = scg.codeid
	LEFT JOIN HMOPROD_PLANDATA.dbo.svccategory AS scat ON scg.catid = scat.catid
	LEFT JOIN HMOPROD_PLANDATA.dbo.svcsubcategory AS ssc ON scg.catid = ssc.catid
		AND scg.subcatid = ssc.subcatid
WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ... AND ...
	AND SUBSTRING(UPPER(LTRIM(RTRIM(ISNULL(sc.codeid,'')))),1,5) IN ('90791','90834','90837') -- 'SMI' =  Serious Mental Illness 'SUD' = Substance Use Disorder ... AS [CPT Service Code] 







JAH 'CONTRACTING - UCSD REFRESH'
x Hi John, Salime is requesting the UCSD Hospital analysis we did previously to be refreshed with   May 2024 - April 2025 data. Please create a ticket.

Phil
		
		BETWEEN '05/01/2024' AND '04/30/2025'







JAH 'ONE 1 BIG BEAUTIFUL PROMPT': ChatGPT testing prompts
(in the repo)
Informatics\ChatGPT and Snowflake\testing prompts.txt
 
 ChatGPT testing prompts
(in the repo)
Informatics\ChatGPT and Snowflake\testing prompts.txt

http://devops01:8080/IS/_git/Informatics?path=%2FChatGPT%20and%20Snowflake

testing prompts.txt

Edit

Contents
History
Compare
Blame

123456789101112131415161718192021222324252627282930313233343536373839404142434445464748495051525354555657**

Test for Vikram Udani
create contracting utilization report for vikram udani, I don''t have the tax id

Create it as a fee schedule report for all LOBs

current is 100% of medicare
proposed is 150% of medicare
counter is 105% of medicare

run it for the time period 12/01/2023 to 11/30/2024

For Medi-Cal LOB I'm expecting the proposed payment to be $293,677
For D-SNP LOB I'm expecting the proposed payment to be $28,521  


For output show only the following in a tabular format: the dollar amount I expected, what it actually was, the dollar difference, and the percent difference for each. Show only two decimals.

**Test for Carlsbad Imaging

create contracting utilization report for TIN 33-0991215 

Create it as a fee schedule report for all LOBs

for the Medi-Cal LOB
current is 100% of medi-cal
proposed is 120% of medi-cal
counter is 105% of medi-cal

for the Medicare LOB
current is 100% of medicare
proposed is 120% of medicare
counter is 105% of medicare

run it for the Time Period:  02/01/2024 - 01/31/2025

For Medi-Cal LOB I'm expecting the proposed payment to be $86,715.68 

For D-SNP LOB I'm expecting the proposed payment to be  $1,875.91   

For output show only the following in a tabular format: the dollar amount I expected for the proposed, what it actually was, the dollar difference, and the percent difference for each LOB.


**Test for Coastal Surgeons
create a contracting utilization report for Coastal Surgeons
TIN is 33-0446198 
for Time Period:  11/01/2023 - 10/31/2024
for Medi-Cal LOB
The current contract is 80% of medicare
The proposed contract is 100% of medicare
The counter offer is 95% of medicare

I expect the actual amount paid to be: $218,932.35
I expect the proposed amount to be:  $273,665
I expect the counter offer to be:  $259,982 

For output show only the following in a tabular format: the dollar amount I expected, what it actually was, the dollar difference, and the percent difference for each. Show only two decimals.
 
 -- ======================================================================
	-- POS, BILL TYPE(S), Dx, PROC + REV: 
-- ======================================================================
SELECT ' ' AS 'PLACE OF SERVICE (POS)',*
FROM HMOPROD_PLANDATA.dbo.hcfaposlocation AS pos (NOLOCK)
WHERE 1=1 
	-- AND pos.DESCRIPTION LIKE '%TELE%'
	AND pos.locationcode IN ('41','42','95') -- TRANSPORTATION
		
		--LEFT JOIN 
		--( -- INITIATE ...
		--SELECT ' ' AS 'POS (PLACE OF SERVICE)',*
		---- SELECT TOP 10 ' ' AS 'CHECK 1st',*
		---- SELECT DISTINCT ' ' AS 'CHECK 1st',
		--FROM HMOPROD_PLANDATA.dbo.hcfaposlocation
		--) -- CONCLUDE ...
		--AS posdescr ON UPPER(LTRIM(RTRIM(ISNULL(cd.location,'')))) = posdescr.locationcode		

SELECT 'BILL TYPE' AS [CodeType],*
FROM INFORMATICS.dbo.[uvw_CLAIMS_BILLTYPE] AS sbt 
WHERE 1=1
	AND sbt.QNXTbilltype LIKE '1[1-2]%' -- 'INPATIENT'

SELECT 'BILL TYPE' AS [CodeType],*
FROM INFORMATICS.dbo.[uvw_CLAIMS_BILLTYPE] AS sbt 
WHERE 1=1
	AND sbt.QNXTbilltype LIKE '1[3-4]%' -- 'OUTPATIENT'

SELECT 'Dx - DIAGNOSIS' AS [CodeType],ISNULL(dc.description,'') AS [CodeDescr]
,dc.*
FROM HMOPROD_PLANDATA.dbo.DiagCode AS dc 
WHERE 1=1 
	AND dc.codeid IN ('F22','F23','F24','F28','F29','F32.3','F33.3','F70','F71','F72','F73','F78','F78.A1','F78.A9','F79','F80.0','F80.1','F80.2','F80.4','F80.81','F80.82','F80.89','F80.9','F81.0','F81.2','F81.81','F81.89','F81.9','F82','F84','F84.0','F84.0','F84.0','F84.2','F84.2','F84.3','F84.3','F84.3','F84.5','F84.5','F84.8','F84.8','F84.8','F84.9','F84.9','F84.9','F88','F89','F90.0','F90.1','F90.2','F90.8','F90.9','F91.0','F91.1','F91.2','F91.3','F91.8','F91.9','F93.0','F93.8','F93.9','F94.0','F94.1','F94.2','F94.8','F94.9','F95.0','F95.0','F95.1','F95.1','F95.2','F95.2','F95.8','F95.8','F95.9','F95.9','F98.0','F98.1','F98.21','F98.29','F98.3','F98.4','F98.5','F98.8','F98.9','F99','Q90','Q90.0','Q90.1','Q90.2','Q90.9','Q91.0','Q91.1','Q91.2','Q91.3','Q91.4','Q91.5','Q91.6','Q91.7','Q92','Q93','Q93.0','Q93.1','Q93.2','Q93.3','Q93.4','Q93.5','Q93.51','Q93.59','Q93.7','Q93.8','Q93.81','Q93.82','Q93.88','Q93.89','Q93.9','Q99.2') -- Children and youth (younger than 21 yrs of age) who have a diagnosis of I/DD Use the following ICD-10 diagnosis codes: Lookback period 12 months
	-- AND dc.codeid >= 'F8'
	-- AND dc.codeid < 'F9'
	-- AND dc.codeid LIKE 'E08%'
		-- OR dc.codeid LIKE 'E09%'

 SELECT 'CPT - PROCEDURE_CODE + SERVICE CATEGORY(-ies)' AS [CodeType],ISNULL(sc.description,'') AS [CodeDescr]
 ,UPPER(LTRIM(RTRIM(scg.description)))+' - '+UPPER(LTRIM(RTRIM(scat.description)))+': '+UPPER(LTRIM(RTRIM(ssc.description))) AS ServiceCatDescr
,scg.catid
,scg.subcatid
,scg.svcgroupid
,sc.*
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st',UPPER(LTRIM(RTRIM(scg.description)))+' - '+UPPER(LTRIM(RTRIM(scat.description)))+': '+UPPER(LTRIM(RTRIM(ssc.description))) AS ServiceCatDescr
FROM HMOPROD_PLANDATA.dbo.svccode AS sc 
	LEFT JOIN HMOPROD_PLANDATA.dbo.svccatgroup AS scg ON sc.codeid = scg.codeid
	LEFT JOIN HMOPROD_PLANDATA.dbo.svccategory AS scat ON scg.catid = scat.catid
	LEFT JOIN HMOPROD_PLANDATA.dbo.svcsubcategory AS ssc ON scg.catid = ssc.catid
		AND scg.subcatid = ssc.subcatid
WHERE 1=1 
	AND SUBSTRING(UPPER(LTRIM(RTRIM(ISNULL(sc.codeid,'')))),1,5) IN ('J7189','J7190','J7191','J7192','J7193','J7194','J7195','J7196','J7197','J7198','J7199','Z7500','Z7502')

		 -- SELECT DISTINCT description FROM HMOPROD_PLANDATA.dbo.svccatgroup ORDER BY description
		 -- SELECT DISTINCT description FROM HMOPROD_PLANDATA.dbo.svccategory ORDER BY description
		 -- SELECT DISTINCT description FROM HMOPROD_PLANDATA.dbo.svcsubcategory ORDER BY description

SELECT 'REVENUE_CODE' AS [CodeType],ISNULL(rc.description,'') AS [CodeDescr],rc.*
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st',
FROM HMOPROD_PLANDATA.dbo.revcode AS rc 
WHERE 1=1 
	AND rc.codeid IN ('0252','0510','0450')







JAH 'GENOME - UNIVERSE'

,CAST(NULL AS money) AS [EQUIV_allow_rate]
,CAST(NULL AS money) AS [EQUIV_allow_compare]
,CAST(NULL AS money) AS [EQUIV_allow_rate2]
,CAST(NULL AS money) AS [EQUIV_allow_compare2]
,CAST(NULL AS money) AS [EQUIV_allow_rate3]
,CAST(NULL AS money) AS [EQUIV_allow_compare3]

,EQUIV_allow_rate AS 'TRI Medi-cal Rate'
,EQUIV_allow_compare AS 'TRI Medi-cal Paid'
,EQUIV_allow_rate2 AS 'Medicare In Office NF Rate'
,EQUIV_allow_compare2 AS 'Medicare In Office NF Paid'
,EQUIV_allow_rate3 AS 'Medicare Out of Office NF Rate'
,EQUIV_allow_compare3 AS 'Medicare Out of Office NF Paid'

-- =====================================================================
	-- DECLARE @PARAMETER(S) / @FILTER(S) --
-- =====================================================================
DECLARE @SETfeesched AS varchar(255)
DECLARE @SETfeesched2 AS varchar(255)
DECLARE @SETfeesched3 AS varchar(255)

SET @SETfeesched = 'C01350903'
SET @SETfeesched2 = 'C01011396'
SET @SETfeesched3 = 'C01011395'

	-- Change from C00740459 to C00727442 for hospital claims
/* SET @SETfeesched = CASE 
    WHEN EXISTS (
        SELECT 1 
        FROM HMOPROD_PlanData.dbo.claim AS c
        WHERE c.formtype = 'UB04' -- Hospital Claims
        AND c.claimid IN (SELECT DISTINCT claimid FROM INFORMATICS.dbo.CONTRACTING_PACS)
    )
    THEN 'C00727442' -- Hospital Medi-Cal fee schedule
    ELSE 'C00740459' -- Professional Medi-Cal fee schedule
END; 

		⏎ Professional Claim (formtype = 1500)
				•	TRI Medi-cal - USE 'C01350903'
				•	Medi-cal - USE 'C00740459'
				•	Medicare POS = 02, 11, 12, 20, 50 - USE 'C01011396' 
				•	Medicare POS <> 02, 11, 12, 20, 50 - USE 'C01011395'

-- ======================================================================
	-- POS, BILL TYPE(S), Dx, PROC + REV: 
-- ======================================================================
SELECT ' ' AS 'PLACE OF SERVICE (POS)',*
FROM HMOPROD_PLANDATA.dbo.hcfaposlocation AS pos (NOLOCK)
WHERE 1=1 
	AND pos.locationcode IN ('02','11','12','20','50') -- Telehealth, Office Visit, Home, Urgent Care Facility & Federally Qualified Health Center

		⏎ Hospital Claim (formtype = UB04) 
				•	TRI Medi-cal - USE 'C01350904'
				•	Medi-cal - USE 'C00727442'
				•	Medicare - NO NOT NEGATIVE != <> fee schedule. Claims are priced with Hospital OP PPS pricer
				
		⏎ 'PDPM' = PATIENT DRIVEN PAYMENT MODEL FROM: Elizabeth Valdez, MBA <evaldez@chgsd.com> These rates are uploaded in QNXT annually. Below are the link to the fee schedules for 2024 and 2025.

				USE https://www.dhcs.ca.gov/services/medi-cal/Documents/AB1629/AB1629_WebUpdates/CY2025-FSNF-B-FSSA-Rates-On-File-09152025-Update.xlsx - '2025 rates'
				USE https://www.dhcs.ca.gov/services/medi-cal/Documents/AB1629/AB1629_WebUpdates/CY2024-FSNF-B-FSSA-Rates-On-File-09152025-Update.xlsx - '2024 rates'

		⏎ FOR CONTRACTING ANALYSIS CONSIDER MIN('TRI Medi-cal') OR MAS / BETTER!!! */

 SELECT 'CPT - PROCEDURE_CODE + SERVICE CATEGORY(-ies)' AS [CodeType]
 ,ISNULL(sc.description,'') AS [CodeDescr]
 ,UPPER(LTRIM(RTRIM(scg.description)))+' - '+UPPER(LTRIM(RTRIM(scat.description)))+': '+UPPER(LTRIM(RTRIM(ssc.description))) AS ServiceCatDescr
,scg.catid
,scg.subcatid
,scg.svcgroupid
,sc.*
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st',UPPER(LTRIM(RTRIM(scg.description)))+' - '+UPPER(LTRIM(RTRIM(scat.description)))+': '+UPPER(LTRIM(RTRIM(ssc.description))) AS ServiceCatDescr
FROM HMOPROD_PLANDATA.dbo.svccode AS sc 
	LEFT JOIN HMOPROD_PLANDATA.dbo.svccatgroup AS scg ON sc.codeid = scg.codeid
	LEFT JOIN HMOPROD_PLANDATA.dbo.svccategory AS scat ON scg.catid = scat.catid
	LEFT JOIN HMOPROD_PLANDATA.dbo.svcsubcategory AS ssc ON scg.catid = ssc.catid
		AND scg.subcatid = ssc.subcatid
WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ... AND ...
	AND SUBSTRING(UPPER(LTRIM(RTRIM(ISNULL(sc.codeid,'')))),1,5) IN ('99202','99203','99204','99205','99211','99212','99213','99214','99215','99421','99422','99423')


ALTER TABLE INFORMATICS.dbo.CONTRACTING_GENOME
ADD -- INITIATE ... ADD OF COLUMN(s)
[EQUIV_allow_rate2] money DEFAULT NULL -- DFLT VAL() IS NULL
,[EQUIV_allow_compare2] money DEFAULT NULL -- DFLT VAL() IS NULL
,[EQUIV_allow_rate3] money DEFAULT NULL -- DFLT VAL() IS NULL
,[EQUIV_allow_compare2] money DEFAULT NULL -- DFLT VAL() IS NULL
; -- CONCLUDE ...

		SELECT TOP 10 ' ' AS 'ADD COL()',[EQUIV_allow_rate]
		,[EQUIV_allow_compare]
		,[EQUIV_allow_rate2]
		,[EQUIV_allow_compare2]
		,[EQUIV_allow_rate3]
		,[EQUIV_allow_compare3],*
		FROM INFORMATICS.dbo.CONTRACTING_GENOME

x 'SIR PHIL PEER REVIEW' IN snowflake: 
Looks good Walter!  Thanks!

I spot checked a number of provider+CPT code combinations against the date warehouse and had very similar numbers to your report. I’ll forward this to Contracting.

Phil

p.s. Here is the EDW query I used for validation:

SELECT ' ' AS 'SIR PHIL PEER REVIEW IN snowflake: ',
dp.PROVIDER_FULL_NAME AS payto_provider,
db.LOB ,
ds.CODEIDAK AS cpt_code,
count(DISTINCT CLAIMAK ) AS claim_count,
sum(fm.ADJUSTED_UNITS) AS units,
sum(AMOUNT_PAID) AS amount_paid,
sum(fm.MEDI_CAL_FEE * ADJUSTED_UNITS) AS medi_cal_100_percent,
sum(fm.MEDICARE_FEE * ADJUSTED_UNITS) AS medicare_100_percent
FROM PROD_CHG_EDW.CHG_EDW.FACT_MEMBERHISTORY AS fm
	JOIN PROD_CHG_EDW.CHG_EDW.DIM_PROVIDERSPECIALTY AS dp ON
	fm.PAYTOPROVIDERSK = dp.PROVIDERSK
	JOIN PROD_CHG_EDW.CHG_EDW.DIM_SERVICECODE AS ds ON
	fm.SERVICECODESK = ds.SERVICECODESK
	JOIN PROD_CHG_EDW.CHG_EDW.DIM_BENEFITPLAN AS db ON fm.BENEFITPLANSK =db.BENEFITPLANSK
WHERE fm.CLAIM_START_DATE BETWEEN 20240201 AND 20250131
	AND  fm.enrollment_status='P' --PRIMARY only
	AND fm.IS_PAID_CLAIM = 'YES'
	AND ds.CODEIDAK IN (
	'99202',
	'99203',
	'99204',
	'99205',
	'99211',
	'99212',
	'99213',
	'99214',
	'99215',
	'99421',
	'99422',
	'99423'           
	)
GROUP BY dp.PROVIDER_FULL_NAME, db.LOB, ds.CODEIDAK
ORDER BY amount_paid DESC --sum(AMOUNT_PAID) desc		







JAH 'CONTRACTING ChatGPT ENTERPRISE'
		⏎ ChatGPT Access
				~ @Walter Carr, Aaron Peck, Romzy Safadi - Each of you should have access to ChatGPT now, not only to the contracting utilization project but to ChatGPT Enterprise in general. FYI - We have a very limited set of licenses at CHG currently so if it appears you are not using ChatGPT it is likely the license will be reassigned to someone else.

				@Walter - As the person with the most experience with contracting utilization reports, Joseph has asked for you to be involved in the QA of the ChatGPT Contracting Utilization work.

				Here is a link to v2 of what has been built. Current version handles "percent of medi-cal" and "percent of medicare"

				ChatGPT - Demo - Contracting Utilization Analyst

				Johnnie Scott, Juan Francisco Sanchez - We are out of licenses, but I am working to get more, I am not sure how you two got the short end of the stick as far as the licenses go. I will work on getting additional licenses.

				Sir I have a moment if you are free  Hello Walter. I just added you the custom GPT. Can you try clicking the link below whenever you get time and see if it is working for you.  Contracts for fee schedule and flat fee as follow:
				
		⏎ ACT AS a Senior Data Analyst WITH 20+ years of EXPERIENCE. 'CONTRACTING ChatGPT ENTERPRISE': 
				USE https://chatgpt.com/g/g-67980bd08be88191a8cbae2378cf4b98 - 'ChatGPT ENTERPRISE CONTRACTING'
				USE https://chatgpt.com/g/g-67980bd08be88191a8cbae2378cf4b98-demo-contracting-utilization-analyst - 'SIR PHIL'
				USE https://chatgpt.com/g/g-67dd85ba24ec81918402acb21a93c90c-adhi-data-and-analytics - 'SIR ADHI'

				~ Thank you, may I have a copy of the SQL code?				

		USE https://getmontecarlo.com/assets?search=&tab=TABLES - 'DATA STEWARDSHIP / GOVERNANCE'
		
				UID: em
				em: chgsd
				PW:SEEDto...'#' THEN CHGSD YOB IN "yyyy"

Hi Allan and Tatsani,

You can find sample contracts for:
		1.	ABD Kids
		2.	Coastal Surgeons
		3.	Vikram Udani

		USE [PATH]: file://fileserver01/Corporate%20Shared%20Drive/Information%20Systems/Informatics/ChatGPT%20and%20Snowflake/sample%20contracts/ - 'CONTRACT(S): N:\Information Systems\Informatics\ChatGPT and Snowflake\sample contracts'

		ChatGPT is here (same link shared with Joseph):
		USE https://chatgpt.com/g/g-67980bd08be88191a8cbae2378cf4b98-demo-contracting-utilization-analyst - 'ChatGPT - Demo - Contracting Utilization Analyst'

-- =============================================================
	-- snowflake: Contracting Utilization Summary - Flat Rate Based Report for Coastal Surgeons
-- =============================================================
SELECT pp.PAYTO_PROVIDER_FULL_NAME AS provider_name,
    pp.PAYTO_PROVIDER_TAX_ID AS provider_tax_id,
    sc.SERVICE_CODE_ID AS cpt_code,
    COUNT(DISTINCT ct.CLAIMID) AS total_claims,
    COUNT(*) AS total_lines,
    SUM(ct.ADJUSTED_UNITS) AS total_units,
    COUNT(DISTINCT ct.MEMBERAK) AS unique_members,
    SUM(ct.CLAIM_DETAIL_LINE_AMOUNT_PAID) AS total_paid_amount,

    -- Proposed Payment: $900.00 per diem
    SUM(900.00 * ct.ADJUSTED_UNITS) AS proposed_payment,

    -- Counter Payment: $875.00 per diem
    SUM(875.00 * ct.ADJUSTED_UNITS) AS counter_payment

FROM PROD_CHG_EDW.CHATGPT.CLAIM_TRANSACTIONS ct
JOIN PROD_CHG_EDW.CHATGPT.PAYTO_PROVIDERS pp 
    ON ct.PAYTO_PROVIDERSK = pp.PAYTO_PROVIDERSK
JOIN PROD_CHG_EDW.CHATGPT.SERVICE_CODE sc
    ON ct.SERVICECODESK = sc.SERVICECODESK

WHERE pp.PAYTO_PROVIDER_TAX_ID = '330446198'
  AND ct.IS_PAID_CLAIM = 'YES'
  AND ct.DATE_OF_SERVICE_FROM_DATE >= DATEADD(MONTH, -15, CURRENT_DATE)
  AND ct.DATE_OF_SERVICE_FROM_DATE < DATEADD(MONTH, -3, CURRENT_DATE)

GROUP BY 
    pp.PAYTO_PROVIDER_FULL_NAME, 
    pp.PAYTO_PROVIDER_TAX_ID, 
    sc.SERVICE_CODE_ID

ORDER BY total_paid_amount DESC;

--------------------------------------------------------------------------------------------------------------------
	--Error Trapping: Check If Permanent Table(s) Already Exist(s) And Drop If Applicable--
--------------------------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS #PROVISOLATION;

SELECT * 
INTO #PROVISOLATION
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM INFORMATICS.dbo.[uvw_PROVISO] AS prov
WHERE 1=1 
	AND 
	( -- INITIATE ...
	UPPER(LTRIM(RTRIM(ISNULL(prov.NPI,'')))) IN ('6899','317997','139660','330599494','21','10798','134963','237064656') -- 20019 - UCSD MEDICAL CENTER IN 
		OR fedid IN ('330599494') -- UCSD Hospital TIN#33-0599494
	) -- CONCLUDE ...

		SELECT DISTINCT ' ' AS 'CONFIRM PROVIDER SELECTION: '
		,fedid
		,NPI
		,PROVNM
		,SPECcode
		,SPECdescr
		,PROVcode
		,PROVtype 
		FROM #PROVISOLATION 
		ORDER BY PROVNM
		
DECLARE @PAID_NET_AMT AS decimal(9,3) = 100
DECLARE @EQUIV_allow_compare AS decimal(9,3) = 87.5

SELECT ' ' AS 'SYNTAX DIFFERENCES: ',NULLIF(@PAID_NET_AMT,0) * 1.00 AS [Current_Rate_Payment] -- ASSUME THAT WHAT HAS BEEN PAID IS WHAT THE CONTRACTING DEPT. HAS DOCUMENTED
,NULLIF(@EQUIV_allow_compare,0) * 1.10 AS 'Proposed...'
,ISNULL((NULLIF(@EQUIV_allow_compare,0)* 1.05),(NULLIF(@PAID_NET_AMT,0) * 1.05)) AS 'Counter_Offer_Payment' -- ASSUME THAT WHAT HAS BEEN PAID IS WHAT THE CONTRACTING DEPT. HAS DOCUMENTED
,NULLIF(@PAID_NET_AMT,0) * 1.05 AS 'Counter_Offer_Payment' -- ASSUME THAT WHAT HAS BEEN PAID IS WHAT THE CONTRACTING DEPT. HAS DOCUMENTED
,ISNULL((NULLIF(ISNULL(EQUIV_allow_compare,0),0)* 1.05),((NULLIF(ISNULL(PAID_NET_AMT,0),0)+ISNULL([TRI Payment],0)) * 1.05)) AS 'Counter_Offer_Payment' -- ASSUME THAT WHAT HAS BEEN PAID IS WHAT THE CONTRACTING DEPT. HAS DOCUMENTED
-- ,ISNULL((NULLIF(ISNULL(EQUIV_allow_compare,0),0)* 1.05),(NULLIF(ISNULL(PAID_NET_AMT,0),0) * 1.05)) AS 'Counter_Offer_Payment' -- ASSUME THAT WHAT HAS BEEN PAID IS WHAT THE CONTRACTING DEPT. HAS DOCUMENTED
-- ,NULLIF(ISNULL(PAID_NET_AMT,0),0) * 1.05 AS 'Counter_Offer_Payment' -- ASSUME THAT WHAT HAS BEEN PAID IS WHAT THE CONTRACTING DEPT. HAS DOCUMENTED
WHERE 1=1
	 -- AND ISNULL(@PAID_NET_AMT,0) != 0
	 AND NULLIF(@PAID_NET_AMT,0) != 0
	-- AND NULLIF(ISNULL(@PAID_NET_AMT,0),0) != 0

JAH THANK YOU JAH 

		USE https://openai.com/index/introducing-codex/

ChatGPT Codex
Introducing Codex | OpenAI
Introducing Codex
Introducing Codex: a cloud-based software engineering agent that can work on many tasks in parallel, powered by codex-1. With Codex, developers can simultaneously deploy multiple agents to independ...
 

JAH THANK YOU JAH 
		⏎ ACT AS a Senior Data Analyst WITH 20+ years of EXPERIENCE. How do I go about creating my own GPT?
				USE https://chatgpt.com/gpts/editor/g-682bb9a858788191a906a9008423d67f

Gentlemen, you ‘should’  have received invitation emails from ESRI ArcGis

Alec Lolly-Wilson alwilson@chgsd.com


alwilson_CHGSD
CHGalw1234 – ‘TEMP’
	

https://my.esri.com/#/users/admin/invite - Maintenance
https://my.esri.com/#/transactions/quotes

Based on your interest in creating your own GPT, I'll share what I know about this process. As of my knowledge cutoff in October 2024, OpenAI offers a way to create custom GPTs through their platform.
To create your own GPT, you would generally follow these steps:
1.	Go to the OpenAI website and log into your account (or create one if needed)
2.	Navigate to the GPT Builder or similar section where custom models are created
3.	Define your GPT's purpose, capabilities, and knowledge
4.	Configure how your GPT should respond, including its tone and style
5.	Test your GPT to ensure it works as intended
6.	Deploy it for personal use or share it with others
However, since this information may have changed since my training data, let me search for the latest information on creating custom GPTs.
Would you like me to look up the current process for creating a custom GPT on OpenAI's platform?
Retry
Claude can make mistakes. 
Please double-check responses.

JAH THANK YOU JAH 
Creating your own GPT (Generative Pre-trained Transformer) is a significant undertaking, but it's entirely possible depending on your goals, resources, and level of customization needed. Here's how a Senior Data Analyst with 20+ years of experience should approach this, broken down into practical stages:

________________________________________
🧠 Step 1: Clarify Your Goal
Ask yourself:
•	Do you want a GPT for a niche task (e.g., summarizing financial reports, coding, legal analysis)?
•	How custom do you want it to be? Options:
o	Light fine-tuning or prompt engineering (fastest, no model training)
o	Domain-adapted GPT via fine-tuning (moderate effort)
o	Training from scratch (heavy compute, $$$, deep ML skills)

________________________________________
⚙️ Step 2: Choose Your Approach
Option A: Use OpenAI’s GPT with Fine-Tuning / Embeddings (Recommended)
•	Fastest and most practical way to build a custom GPT.
•	Use OpenAI’s API (or Azure OpenAI) + your own data + prompt templates.
Tools:
•	Fine-tuning: Teach GPT to behave a certain way with labeled examples.
•	Embeddings + Vector DB (e.g., Pinecone, FAISS, Chroma): Upload large documents, query them semantically.
•	Custom GPTs via ChatGPT: Use OpenAI’s “Custom GPT” feature to add tools, rules, and persona.
Ideal for:
•	A domain expert who wants results fast without managing infrastructure.

________________________________________
Option B: Fine-Tune an Open Source GPT (Like LLaMA, Mistral, Falcon)
•	Use libraries like Hugging Face 🤗 Transformers.
•	Dataset: Curate a domain-specific corpus (e.g., healthcare claims, legal docs).
•	Compute: You’ll need GPUs (AWS, Paperspace, Lambda Labs, or your own rig).
•	Tools:
o	Transformers + PEFT/LoRA for lightweight fine-tuning.
o	LangChain or LlamaIndex for orchestration with tools.
Ideal for:
•	Mid-to-advanced ML professionals with resources and a need for data privacy or full control.

________________________________________
Option C: Train GPT From Scratch (Not Recommended Unless You're a Lab)
•	You’ll need:
o	100s of GBs of text data.
o	100,000s of GPU hours.
o	ML engineers and researchers.
•	Only done by labs like OpenAI, Meta, Anthropic, etc.

________________________________________
🛠️ Step 3: Build the Stack
Depending on the approach, here’s a typical modern stack:
Layer	Tools
Model	GPT-3.5/4 (OpenAI), LLaMA2, Mistral, Falcon
Embedding	OpenAI, Hugging Face, SentenceTransformers
Vector DB	FAISS, Chroma, Pinecone, Weaviate
App Interface	LangChain, LlamaIndex, Streamlit, Gradio
Hosting	AWS, Azure, GCP, Local
Data Curation	Python, SQL, pandas, manual QA

________________________________________
📈 Example Use Case for a Senior Data Analyst
You want a GPT that answers questions about Medicare/Medicaid claims from historical SQL data, PDFs, and compliance documents.
Steps:
1.	Ingest your regulatory docs and claims data into a vector store using embeddings.
2.	Use GPT (e.g., OpenAI GPT-4 API) to retrieve and answer based on these sources.
3.	Wrap it with a Streamlit or Flask interface for internal use.

________________________________________
✅ Recommendations
•	Start with OpenAI’s custom GPT or LangChain + GPT-4 to validate your idea.
•	Use LLaMA 3 (Meta) or Mistral if you need open-source control.
•	Avoid training from scratch unless you have serious resources.

________________________________________
🚀 Resources
•	OpenAI Custom GPT Guide
•	Hugging Face Transformers
•	LangChain
•	LlamaIndex
•	Fine-tuning GPT

________________________________________
Would you like help creating a plan for your specific GPT use case (e.g., claims QA, compliance analysis, etc.)?
4o


From: OpenAI <noreply@tm.openai.com> 
Sent: Monday, May 19, 2025 3:20 PM
To: Walter Carr <WCarr@chgsd.com>
Subject: ChatGPT - Adhikaran Saini shared a new GPT with you: QA Contracting Utilization Reports

A new GPT is shared with you. 



Adhikaran Saini has shared a new GPT, QA Contracting Utilization Reports, with you in the workspace CHG ChatGPT Enterprise. 
Please click on the link below to start using the GPT. 
Chat with GPT 



New to GPTs? Learn more in our help center. 
Best,
The OpenAI Team






JAH 'SIR EVAN ChatGPT REVIEW':
Requested by Tatsani Flora on 2025-May-01 17:12:50
 
HI Informatics:
 
I want to check if you have a chance to review Evan’s comments below.  This is the latest email I found for this conversation.
 
Field	ChatGPT	Evan's QA (MCL Fee Schedule)	Evan's QA (MCR Fee Schedule)
Provider Name	SPECIAL CARE	SPECIAL CARE	SPECIAL CARE
Provider Tax ID	330905467	330905467	330905467
Total Claims	62,270	                                94,641	                               54,336
Total Lines	149,264	                             234,604	                             105,787
Total Units	20,902,663	                       42,170,323	                         2,417,101
Unique Members	9,743	                                13,964	                                 9,640
Total Paid Amount	$15,942,616.65	$18,298,107.78	$11,681,269.56
Proposed Payment (200% Medi-Cal)	$27,235,263.46	$36,652,730.86	 
Counter Payment (200% Medicare)	$22,247,226.38	 	$22,522,389.17
  
Thanks,
Tatsani
 
From: Evan Ducheny <eduche@chgsd.com>
Sent: Thursday, April 17, 2025 9:37 AM
To: John Costello <jcostello@chgsd.com>; Allan Sombillo <asombi@chgsd.com>; Tatsani Flora <TInkha@chgsd.com>; Phil Steffek <psteffek@chgsd.com>; Johnnie Scott <jscott@chgsd.com>
Subject: RE: Evans ChatGPT QA Results - Part 1
 
Hi Everyone,
 
I have some additional QA comparisons for you. They’re attached.
 
This time I selected two providers that are more challenging. These providers (Special Care and Sharp Rees-Stealy Medical Group) have more claims and more complicated claims (COB, DSNP, etc.).
 
The biggest issue that I found was that most of my ChatGPT queries were returning with no data. For the six ChatGPT queries that I did for these two providers, I got back results for only one of them.
 
A secondary issue was that I got significantly different results for the one query that did return results in ChatGPT. Please see the first tab in the “Special Care.xlsx” attachment. The proposed payment differed by about 35% between ChatGPT and the QA report for that query. Some of the other fields differed significantly as well.
 
Another issue that I ran into was ChatGPT freezing for a query. ChatGPT froze for about 10 minutes or so. I’m not sure what the problem was. I ended up starting the report over since I didn’t know how long it would take (or if it would return at all). Note that my next ChatGPT session was with the same parameters, but it did not freeze.
 
Below are some additional notes regarding these tests.
 
----------------------------------------------------------------------------------------
 
I changed how the QA fee schedule report deals with the “Medicare” and “Medi-Cal” LOBs. I assumed that the “Medicare” LOB included the following plans in QNXT:
 
•	DSNP Medicare (DSNP1)
•	CSNP
 
And I assumed the “Medi-Cal” LOB included the following QNXT plans:
 
•	Medi-Cal
•	DSNP Medi-Cal (DSNP2)
 
Thus, if the user selects the “Medicare” LOB in the fee schedule report, only claims associated with the DSNP1 and CSNP plans would be included in the results.
 
Also, I did not try to subtract patient responsibility amounts from the estimated payment amounts for the Medicare LOB in the QA report. I assumed this was outside the scope of this report. Note that this means that the Medicare estimated payments are likely too high.
 
------------------------------------------------------------------------------------------
 
Please tell me if you’d like me to do any further testing. Unless I hear back from anyone, I’ll proceed with other projects that I’ve been assigned. Thanks.
  
-Evan
 
From: John Costello <jcostello@chgsd.com>
Sent: Wednesday, April 16, 2025 2:55 PM
To: Evan Ducheny <eduche@chgsd.com>; Allan Sombillo <asombi@chgsd.com>; Tatsani Flora <TInkha@chgsd.com>; Phil Steffek <psteffek@chgsd.com>; Johnnie Scott <jscott@chgsd.com>
Subject: RE: Evans ChatGPT QA Results - Part 1
 
Thanks Evan.   Most of your assumption below are spot on with what ChatGPT is doing using the EDW model in Snowflake.
 
Thanks,
 
John Costello
 
From: Evan Ducheny <eduche@chgsd.com>
Sent: Wednesday, April 16, 2025 12:14 PM
To: Allan Sombillo <asombi@chgsd.com>; Tatsani Flora <TInkha@chgsd.com>; Phil Steffek <psteffek@chgsd.com>; John Costello <jcostello@chgsd.com>; Johnnie Scott <jscott@chgsd.com>
Subject: Evans ChatGPT QA Results - Part 1
 
Hi Everyone,
 
I’m done (for now) creating a QA version of the ChatGPT Contracting Utilization Report.
 
The initial comparisons below use the “Coastal Surgeons” provider. More comparisons will be forthcoming.
  
Fee Schedule Based Report
 
Field	ChatGPT	Evans QA	*See bottom of email
Provider Name	Coastal Surgeons	COASTAL SURGEONS	
Provider Tax ID	330446198	330446198	
Total Claims	766	780	
Total Lines	1,005	1,019	1,020
Total Units	1,010	1,021	1,022
Unique Members	450	463	
Total Paid Amount	$220,944.87	$221,888.71	$221,908.66
Proposed Payment (200% Medi-Cal)	$417,679.74	$397,151.25	
Counter Payment (150% Medicare)	$446,622.99	$453,342.51	
  
Flat Rate Based Report (Code 99204)
 
Field	ChatGPT	Evans QA
Provider Name	Coastal Surgeons	COASTAL SURGEONS
Provider Tax ID	330446198	330446198
CPT Code	99204	99204
Total Claims	248	241
Total Lines	248	241
Total Units	248	241
Unique Members	247	240
Total Paid Amount	$35,093.74	$34,280.34
Proposed Payment ($120)	$29,760.00	$28,680.00
Counter Payment ($130)	$32,240.00	$31,070.00
 
Flat Rate Based Report (Code 99231)
 
Field	ChatGPT	Evans QA
Provider Name	Coastal Surgeons	COASTAL SURGEONS
Provider Tax ID	330446198	330446198
CPT Code	99231	99231
Total Claims	36	35
Total Lines	63	62
Total Units	63	62
Unique Members	26	26
Total Paid Amount	$2,516.97	$2,526.30
Proposed Payment ($24.5)	$1,543.50	$1,519.00
Counter Payment ($29.5)	$1,858.50	$1,829.00
 
 As you can see, the two reports return similar values with these parameters. Note that I used the following parameters:
 
•	LOB: Medi-Cal (though I don’t remember ChatGPT asking for a LOB for the flat rate based report)
•	DOS Range: 12 months with a 3-month lag (i.e., 15 months ago to 3 months ago)
•	Tax ID: 330446198 (Coastal Surgeons, provid: 137179)
 
I made lots of assumptions while writing the QA report. Below are some of them.
 
1.	I used the dosfrom field on the claim lines to determine inclusion. And I used SQL Server’s DATEADD function to calculate 15 months ago and 3 months ago.
2.	I did not use claim line modifiers for filtering. Thus, lines with UA/UB modifiers or assistant surgeon modifiers were not excluded.
3.	I used the fee schedule codes and the flat rate codes for filtering. Thus, if a claim line does not have one of these codes, then it was excluded.
4.	I did not use claim line modifiers for adjusting the estimated payment amounts. So I made no adjustments for reduction modifiers, split-service modifiers, multiple surgery modifiers, etc.
5.	I only included paid claims and approved claim lines. Reversed claims were excluded, as were W and X claims.
6.	Capitated claim lines were excluded.
7.	I did try to adjust my estimated payment amounts for COB claims. However, all of the COB calculations were done at the line level, not the header level—including for institutional claims. I did this since filtering for this report is done at the line level. Note that I used the “lesser than” method for COB calculations.
8.	I assumed I should use the following fee schedules in QNXT for the Medi-Cal and Medicare fee schedules respectively.
a.	0 PHYS MCAL UCR FEE TABLE - TRI RATES
b.	0 MEDICARE PRO RATES
9.	The asterisk note in the first table above indicates that I got slightly different counts with the Medicare fee schedule vs. the Medi-Cal fee schedule. This is probably due to the different fee schedules containing slightly different service codes.
 
Please tell me if any of the above assumptions are incorrect, and I’ll make the necessary modifications to the QA report.
  
I will now proceed and compare a few additional providers. Please tell me if you have some specific providers you’d like me to compare. Note that I still don’t understand how to select the DSNP or CSNP LOBs within ChatGPT. So until I figure that out, or someone explains it to me, I’ll be using the Medi-Cal LOB exclusively.
 
 -Evan
  
---------------------------
When completed please notify TInkha@chgsd.com
and cc: Evan Ducheny<eduche@chgsd.com>; John Costello<jcostello@chgsd.com>; Allan Sombillo<asombi@chgsd.com>; Phil Steffek<psteffek@chgsd.com>; Johnnie Scott<jscott@chgsd.com>;







JAH 'UCSD'
UCSD Hospital TIN#33-0599494
Line of Business: Medi-Cal
Target Due Date: Tuesday 4/1/25

Requesting a utilization report for the standard most recent 12 months (less three months claim lag), Medi-Cal LOB; please provide the following: 
		•	Comparison with the current (see summary below) vs. their proposed rates  (see summary below) vs. CHG counter (5% increase)
		•	Total unique members seen + units billed
		•	Primary only 

		Current Fee Schedule Medi-Cal
				1.	Inpatient 115% of Medi-Cal APR DRG
				2.	General OP 129% of Medi-Cal
				3.	Admin Day $704.86/Day Rev Code 169
				4.	IP Mild/Moderate Psych $1,360/Day Rev Code 0114, 0124, 0134, 0144, 0154, 0204
				5.	IP ECT $875/Day Rev Code 0901
				6.	OP Mild/Moderate $450/Day Rev 0904
				7.	OP Psych Eating Disorder Half Day  $850/Day Rev Code 0912
				8.	OP Psych Eating Disorder Full Day $1,250/Day Rev Code 0913
				9.	ECT $875/Day Rev Code 0901
				10.	Car-T Cell Therapy 129% of Medi-Cal APR DRG Reve Code 008-1, 008-2, 008-3, 008-4
				11.	Implants – Invoice + 3% Rev Code 274-276, 278 and 624
				12.	Pharmaceuticals 135% of ASP Rev Code 025X, 063X, 0343
				13.	Kidney Transplant- 197% of APR DRG Code 440-1, 440-2, 440-3, 440-4, 650, 651, 652

		Proposed Fee Schedule Medi-Cal 
				1.	Inpatient 125% of Medi-Cal APR DRG
				2.	General OP 130% of Medi-Cal
				3.	Admin Day $880/Day Rev Code 169
				4.	IP Mild/Moderate Psych $1,400/Day Rev Code 0114, 0124, 0134, 0144, 0154, 0204
				5.	IP ECT $900/Day Rev Code 0901
				6.	OP Mild/Moderate $475/Day Rev 0904
				7.	OP Psych Eating Disorder Half Day $900/Day Rev Code 0912
				8.	OP Psych Eating Disorder Full Day $1,350/Day Rev Code 0913
				9.	ECT $900/Day Rev Code 0901
				10.	Car-T Cell Therapy 130% of Medi-Cal APR DRG Reve Code 008-1, 008-2, 008-3, 008-4
				11.	Implants – 45% of Billed Charges in addition to per diem or other applicable rate Rev Code 274-276, 278 and 624
				12.	Pharmaceuticals 135% of ASP Rev Code 025X, 063X, 0343
				13.	Kidney Transplant- 200% of APR DRG Code 440-1, 440-2, 440-3, 440-4, 650, 651, 652

JAH THANK YOU JAH 
SELECT 'UCSD PHARMACEUTICALS' AS [CodeType]
,ISNULL(rc.description,'') AS [CodeDescr],rc.*
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st',
FROM HMOPROD_PLANDATA.dbo.revcode AS rc 
WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ... AND ...
	AND rc.codeid LIKE '025%' 
		OR rc.codeid LIKE '063%' 
		OR rc.codeid IN ('0343')

Explain why the "% increase (proposed vs. actual paid)" is showing 33.3% rather than 25%, based on the screen capture you provided:

Looking at the data, I can see that the facilities are currently being paid at 75% of PDPM (Patient-Driven Payment Model) rates, and the proposal is to increase this to 100% of PDPM.

The reason the increase shows as 33.3% rather than 25% is due to how percentage increases are calculated mathematically:
When you go from 75% to 100%, you are not simply adding 25 percentage points – you are actually increasing the original amount by a FACTOR of (100/75), which equals 1.333... or a 33.3% increase.

To break this down:
		•	Original payment: 75% of PDPM
		•	Proposed payment: 100% of PDPM
		•	Increase calculation: (100 - 75) / 75 = 25 / 75 = 0.333... = 33.3%

This is because percentage increases are calculated RELATIVE TO the starting value, not the destination value. So while the absolute difference between 75% and 100% is 25 percentage points, when expressed as a percentage increase from the original value, it is 33.3%.

You can see this reflected consistently across all PDPM Base Rate entries in your spreadsheet. For example, for ARHIV SPRINGS HEALTH CARE CENTER:
		•	Current paid amount at 75% of PDPM: $666,122
		•	Proposed paid amount at 100% of PDPM: $888,163
		•	Difference: $222,041
		•	Increase percentage: ($888,163 - $666,122) / $666,122 = 0.333... = 33.3%

This same pattern applies to all facilities shown in the report that are moving from 75% to 100% of PDPM rates.

-- ==========================================================================
	-- APR (All Patient Refined Diagnosis) DRG (Diagnosis Related Groups) --
-- ==========================================================================
SELECT ' ' AS 'APR - DRG: '
,dc.*
-- ,cg.groupdescription
-- dc.description
,CASE 
WHEN ISNULL(cdrg.SeverityOfIllness,'') != '' -- NO NOT NEGATIVE <> != ... SOI
THEN RTRIM(cdrg.finaldrg)+'-'+RTRIM(cdrg.SeverityOfIllness)
ELSE RTRIM(cdrg.finaldrg)
END AS [finalDRG+SOI]
,cdrg.subdrg
,cdrg.moddrg
,cdrg.finaldrg
,cdrg.SeverityOfIllness -- 1.	For select specialty’s proposed rate of “$460 per session per day for Dialysis (MS-DRG codes 800-809)”, is one claim the equivalent of “one session per day”? ... *
FROM HMOPROD_PLANDATA.dbo.claimdrg AS cdrg -- C001: ADD claimdrg 'MS-DRG (Medicare Severity Diagnosis Related Groups) CODES' TO DETAIL AS OF 20240523
	JOIN HMOPROD_PLANDATA.dbo.drgcode AS dc ON cdrg.finaldrg = dc.codeid 
		LEFT JOIN HMOPROD_PLANDATA.dbo.codegrouperdrg AS cgd ON cdrg.finaldrg = cgd.codeid
		LEFT JOIN HMOPROD_PLANDATA.dbo.codegrouper AS cg ON cgd.groupid = cg.groupid
WHERE 1=1
	-- AND ISNULL(cdrg.SeverityOfIllness,'') != '' -- IS NOT NULL -- ISOLATES FOR APR DRG OR ???
	AND 
	( -- INITIATE ...
	CASE 
	WHEN ISNULL(cdrg.SeverityOfIllness,'') != '' -- NO NOT NEGATIVE <> != 
	THEN RTRIM(cdrg.finaldrg)+'-'+RTRIM(cdrg.SeverityOfIllness)
	ELSE cdrg.finaldrg
	END LIKE '440%[1-4]'
		OR cdrg.finaldrg IN ('650','651','652')
		OR CASE 
		WHEN ISNULL(cdrg.SeverityOfIllness,'') != '' -- NO NOT NEGATIVE <> != 
		THEN RTRIM(cdrg.finaldrg)+'-'+RTRIM(cdrg.SeverityOfIllness)
		ELSE cdrg.finaldrg
		END LIKE '008%[1-4]'
		) -- CONCLUDE ...
ORDER BY cdrg.finaldrg

		SELECT ' ' AS 'APR - DRG Descr.: ',dc.*
		,cgd.groupid AS 'codegrouperdrg'
		,cg.groupdescription AS 'codegrouper'
		FROM HMOPROD_PLANDATA.dbo.drgcode AS dc 
				LEFT JOIN HMOPROD_PLANDATA.dbo.codegrouperdrg AS cgd ON dc.codeid = cgd.codeid
				LEFT JOIN HMOPROD_PLANDATA.dbo.codegrouper AS cg ON cgd.groupid = cg.groupid
		WHERE 1=1
			AND dc.codeid LIKE '440'
				OR dc.codeid IN ('650','651','652','008')
		ORDER BY dc.codeid

		SELECT ' ' AS 'APR - DRG groupid.: ',* 
		FROM HMOPROD_PLANDATA.dbo.drggroup AS dg

		SELECT ' ' AS 'APR - DRG Grouper ',* 
		FROM HMOPROD_PLANDATA.dbo.codegrouperdrg AS cgd 
		WHERE 1=1
			AND cgd.codeid LIKE '%440%'
				OR cgd.codeid IN ('650','651','652','008')

		SELECT ' ' AS 'APR - DRG Grouper ',* 
		FROM HMOPROD_PLANDATA.dbo.codegrouper AS cg

		SELECT TOP 10 ' ' AS 'CLAIM(S) drg DETAIL SAMPLE: ',*
		FROM HMOPROD_PLANDATA.dbo.claimdrg AS cdrg







JAH 'THE ASK'
From: Salim French 
Sent: Tuesday, February 18, 2025 10:56 AM
To: Informatics <Informatics@chgsd.com>
Cc: Josey Trujillo Morales <jtmoral@chgsd.com>; Adrian Arce <AArce@chgsd.com>; Allan Sombillo <asombi@chgsd.com>; Natalia Castellanos <ncaste@chgsd.com>; Griselda Schilling <GSchil@chgsd.com>
Subject: Rockport Healthcare SNF Rate Utilization Request 

Good morning, 

May I please request your help in obtaining a utilization report for this group?

		Rockport Healthcare Services (SNFs)
		TIN: 27-0907657, 20-4754141, 20-4747776, 20-4754166, 20-4754094 (Granite Hills, Brighton Place-SD, The Pavilion at Ocean Point, Brighton Place- Spring Valley, Amay Springs Health Care Center0
		Line of Business: Medi-Cal & Medicare
		Target Due Date: 02/24/25
		Requesting a utilization report for the standard most recent 12 months (less three months claim lag), please provide the following: 
		•	Comparison with the current vs. their proposed rates vs. CHG counter 
		Medi-Cal
		Current 	Proposed	Counter
		75% of PDPM	100% of PDPM Rev Code 0022
		Carveout:
		Bariatric Rev Code 0169: $250
		Isolation Rev Code 0119:$200
		Sitter Services Rev Code 0559: $200
		TPN and Supplies: AWP Rev Code 258	80% of PDPM
		Medicare
		Current 	Proposed	Counter
		75% of PDPM	100% of PDPM Rev Code 0022
		Carveout:
		Bariatric Rev Code 0169: $250
		Isolation Rev Code 0119:$200
		Sitter Services Rev Code 0559: $200
		TPN and Supplies: AWP Rev Code 258	80% of PDPM
		•	Total unique members seen + units billed.

This should follow our standard format with the % increase on the counter being dynamic. 

Please let me know if I can answer any questions or provide clarification. Thank you,

,NULLIF(ISNULL(PAID_NET_AMT,0),0) * 1.00 AS 'Current_Calc_Rate_Payment' -- ASSUME THAT WHAT HAS BEEN PAID IS WHAT THE CONTRACTING DEPT. HAS DOCUMENTED

-- =====================================================================
	-- LEVERAGE HCT AS QA: 
-- =====================================================================	
SELECT TOP 10 ' ' AS 'QA WITH() HCT: SAMPLE DETAIL',*
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM informatics.dbo.dash_hct
WHERE 1=1
	AND TRY_CONVERT(date,ISNULL(member_month,GETDATE())) BETWEEN @RangeStartDate AND @RangeEndDate
	AND 
	( -- INITIATE ...
	provid IN ('120253','143514','201715','303321','594') -- ROCKPORT SNF PROVISO
		OR paytoid IN ('120253','143514','201715','303321','594') -- ROCKPORT SNF PROVISO
		) -- CONCLUDE ...
	
SELECT  ' ' AS 'QA WITH() HCT: CONTRACTING PROPOSAL HIGH LEVEL'
,SUM(paid) AS 'Amount Paid'
,SUM(admits_visits) AS 'Admits / Visits'
,SUM(days_units) AS 'Days / Units'
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM informatics.dbo.dash_hct
WHERE 1=1
	AND TRY_CONVERT(date,ISNULL(member_month,GETDATE())) BETWEEN @RangeStartDate AND @RangeEndDate
	AND 
	( -- INITIATE ...
	provid IN ('120253','143514','201715','303321','594') -- ROCKPORT SNF PROVISO
		OR paytoid IN ('120253','143514','201715','303321','594') -- ROCKPORT SNF PROVISO
		) -- CONCLUDE ...

SELECT  ' ' AS 'QA WITH() HCT: CONTRACTING PROPOSAL BY PROVIDER'
,cost_category
,paytoid
,payto
,SUM(paid) AS 'Amount Paid'
,SUM(admits_visits) AS 'Admits / Visits'
,SUM(days_units) AS 'Days / Units'
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM informatics.dbo.dash_hct
WHERE 1=1
	AND TRY_CONVERT(date,ISNULL(member_month,GETDATE())) BETWEEN @RangeStartDate AND @RangeEndDate
	AND 
	( -- INITIATE ...
	provid IN ('120253','143514','201715','303321','594') -- ROCKPORT SNF PROVISO
		OR paytoid IN ('120253','143514','201715','303321','594') -- ROCKPORT SNF PROVISO
		) -- CONCLUDE ...
GROUP BY cost_category,paytoid,payto

SELECT DISTINCT ' ' AS 'JUST CHECKING FOR ROCKPORT CARVEOUT(S): ',clm.claimid,clm.memid
,TRY_CONVERT(nvarchar(255),'Assign Claim Adjudication Category') AS [ClaimCategory]
-- SELECT TOP 10 ' ' AS 'CHECK 1st',* 
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM HMOPROD_PLANDATA.dbo.claim AS clm
	JOIN HMOPROD_PLANDATA.dbo.claimdetail AS cd (NOLOCK) ON clm.claimid = cd.claimid
	JOIN INFORMATICS.dbo.[uvw_LINE_OF_BUSINESS] AS bp (NOLOCK) ON clm.planid = bp.planid
	-- JOIN INFORMATICS.dbo.[uvw_CLAIMS_PAID] AS pc (NOLOCK) ON clm.claimid = pc.claimid -- PAID CLAIM ISO !!! 

		LEFT JOIN HMOPROD_PLANDATA.dbo.affiliation AS a (NOLOCK) ON clm.affiliationid = a.affiliationid -- REMINDER: within claim(s) tables AFFILIATIONID is the relationship BETWEEN the a.provid = [RENDERING] PROVIDER AND the a.affiliateid = [PAYTO] PROVIDER
		LEFT JOIN HMOPROD_PLANDATA.dbo.provider AS p1 (NOLOCK) ON a.provid = p1.provid -- [RENDERING]
		LEFT JOIN HMOPROD_PLANDATA.dbo.provider AS p2 (NOLOCK) ON a.affiliateid = p2.provid -- [PAYTO] (IPAID)
		LEFT JOIN INFORMATICS.dbo.[uvw_CLAIMS_CLMTYPE] AS ct (NOLOCK) ON clm.formtype = ct.formtype
		LEFT JOIN INFORMATICS.dbo.[uvw_CLAIMS_BILLTYPE] AS sbt (NOLOCK) ON (LTRIM(RTRIM(clm.facilitycode))+LTRIM(RTRIM(clm.billclasscode))+LTRIM(RTRIM(clm.frequencycode))) = sbt.QNXTbilltype -- HEADER replacement for POS ON INCLM claims

WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ... AND ...
	AND TRY_CONVERT(date,ISNULL(clm.enddate,GETDATE())) >= @RangeStartDate -- WITHIN reporting period [RANGE] OPPOSITION
	AND TRY_CONVERT(date,clm.startdate) <= @RangeEndDate -- WITHIN reporting period [RANGE] OPPOSITION 
	AND cd.revcode IN ('0169','0119','0559') --  ('0022','0169','0119','0559','0258')
	AND UPPER(LTRIM(RTRIM(ISNULL(a.affiliateid,'')))) IN -- [PAYTO]
	( -- INITIATE ...
	SELECT DISTINCT provid FROM #PROVISOLATION 
	) -- CONCLUDE ...
	AND ISNULL(clm.enddate,GETDATE()) >= clm.startdate -- MUST BE TRUE ... NON-CROSSFOOTED RECORDS ARE ACTIVE ...

	





JAH 'EXPLAIN FEE SCHED TO ...'
-- ================================================
	-- GENERAL FEE SCHEDULE(s) REVIEW()  / EQUIVALENT --
-- ================================================

/* CPT CODE(S): IN ('77280','77307','77332','77336','77412','77417')
claimid: 24281E27078
FEE SCHEDULE: 'C00740459' */

        ⏎ 'eMAIL' FROM: SIR ADRIAN ON 20250214 - 'hospital outpatient augmentation' RATIO
				~ Hello, I think we figured this one out. We may be looking at the wrong fee schedule in QNXT.

				The rates for hospitals are calculated a little bit different than the traditional Medi-Cal rates. There is a bump on the Medi-Cal rates for services provided in a hospital outpatient department (the bump is 43.44% )

						So the base rate for CPT 77280 with TC Modifier is  $70.52 x 1.4344 (hospital outpatient augmentation) = $101.16 x 1.2 (Palomar’s contracted rate) = $121.39.

				My recommendation is to use the fee schedule attached to the contract term in QNXT. 

				Thank you,
				Adrian

-- =========================================================
	-- MS ALLYSON FEE SCHEDULE(s) REVIEW()  / EQUIVALENT --
-- =========================================================
-- =====================================================================
	-- DECLARE @PARAMETER(S) / @FILTER(S) --
-- =====================================================================
DECLARE @SETfeesched AS nvarchar(255)
DECLARE @feeschedulename AS nvarchar(25)    
DECLARE @dt AS date
DECLARE @whensf AS date

SET @SETfeesched = 'C01350904'
SET @feeschedulename = '%%%' -- ZZZNOTZERO - NO MODIFIER NO ZERO ZZZ                        
SET @dt = GETDATE()
SET @whensf = CAST('01/01/'+CAST(DATEPART(yyyy,TRY_CONVERT(datetime,@dt)) AS varchar(4)) AS date) -- UPDATE(s) AT NEW QTR(s)

	-- CHANGE.LOG FROM C00740459 TO C00727442 FOR hospital claims
/* SET @SETfeesched = CASE 
    WHEN EXISTS (
        SELECT 1 
        FROM HMOPROD_PlanData.dbo.claim AS c
        WHERE c.formtype = 'UB04' -- Hospital Claims
        AND c.claimid IN (SELECT DISTINCT claimid FROM INFORMATICS.dbo.CONTRACTING_PALOMAR_HOSP)
    )
    THEN 'C00727442' -- Hospital Medi-Cal fee schedule
    ELSE 'C00740459' -- Professional Medi-Cal fee schedule
END; */

/* Professional Claim (formtype = 1500)
		•	Medi-cal - USE 'C00740459'
		•	Medicare POS = 02, 11, 12, 20, 50 - USE 'C01011396' 
		•	Medicare POS <> 02, 11, 12, 20, 50 - USE 'C01011395'

-- ======================================================================
	-- POS, BILL TYPE(S), Dx, PROC + REV: 
-- ======================================================================
SELECT ' ' AS 'PLACE OF SERVICE (POS)',*
FROM HMOPROD_PLANDATA.dbo.hcfaposlocation AS pos (NOLOCK)
WHERE 1=1 
	AND pos.locationcode IN ('02','11','12','20','50') -- Telehealth, Office Visit, Home, Urgent Care Facility & Federally Qualified Health Center

Hospital Claim (formtype = UB04) 
		•	Medi-cal - USE 'C00727442'
		•	Medicare - NO NOT NEGATIVE != <> fee schedule. Claims are priced with Hospital OP PPS pricer */

SELECT 'MCAL v MCARE v ??? ... Equivalent Rate ... USE https://duckduckgo.com/?q=Hospital+OP+PPS+pricer&t=h_ - CHARINDEX() FIND() SEARCH() "Hospital OP PPS pricer"' AS [NOTE(S)],*
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st',[FEE SCHEDULE],category
FROM 
( -- INITIATE ...
SELECT DISTINCT ft.effdate,ft.termdate
,RANK() OVER (PARTITION BY sf.description,ft.mincodeid ORDER BY CAST(ft.effdate AS date) DESC) AS [RANKis]
,ROW_NUMBER() OVER (PARTITION BY sf.description,ft.mincodeid ORDER BY CAST(ft.effdate AS date) DESC) AS [ROWis]
,ft.feetableid,sf.description AS [FEE SCHEDULE]
,ft.category
,ft.mincodeid
,ft.maxcodeid
,ft.modcode
,ft.ModCode2
,ft.locationcode
,ft.feeamount -- ,sf.*,ft.*
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st',ft.feetableid,ft.locationcode,sf.feetype,sf.description,ft.category
FROM HMOPROD_PLANDATA.dbo.standardfee AS sf (NOLOCK)
	JOIN HMOPROD_PLANDATA.dbo.feetable AS ft (NOLOCK) ON sf.feeid = ft.feetableid
WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ... AND ...
) -- CONCLUDE ...
AS equiv
WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ... AND ...
	AND CAST(ISNULL(equiv.termdate,CAST(GETDATE() AS date)) AS date) >= TRY_CONVERT(date,GETDATE())-- IDEALLY ONLY THE CUYRENTLY ACTIVE RATE ...
	-- AND CAST(ISNULL(equiv.termdate,CAST(GETDATE() AS date)) AS date) >= @dt
	-- AND equiv.[RANKis] = 1
	-- AND equiv.[ROWis] = 1
	AND 
	( -- INITIATE ...
	-- equiv.[FEE SCHEDULE] LIKE '%0%MCAL%UCR%' -- 'MediCal':  0 PHYS MCAL UCR FEE TABLE for the Medi-Cal rates.
	equiv.feetableid IN (@SETfeesched,'C00740459','C00727442') -- -- DEFINE / SELECT DESIRED SCHEDULE ... SAMPLE FROM [CONTRACTING AWPvMCALvASP_...rar] USE 'C00740459' AS AWP % FEE SCHEDULE
		 -- OR equiv.[FEE SCHEDULE] LIKE '%ASC%' -- '%UB%' 129.5% OF GA SCHEDULE
		 -- OR equiv.[FEE SCHEDULE] LIKE '%0%MEDICARE%PRO%' -- 'ASP':  0 MEDICARE PRO RATES 
		) -- CONCLUDE ...
	AND equiv.mincodeid IN ('77280') -- ,'77307','77332','77336','77412','77417') -- CODE(S) IN PLAY
	-- AND equiv.feetableid IN ('C00740459','C01011396','C01011395','C00727442')
	-- AND equiv.category LIKE '%RU%'	
	-- AND UPPER(LTRIM(RTRIM(ISNULL(equiv.feeid,'')))) LIKE @schedid -- DEFINE / SELECT DESIRED SCHEDULE
	-- AND CAST(ISNULL(equiv.effdate,CAST(GETDATE() AS date)) AS date) >= @whensf -- AS OF ...	
	-- AND equiv.description LIKE @feeschedulename
ORDER BY equiv.[FEE SCHEDULE]

SELECT ' ' AS 'CONTRACTING: PALOMAR QA OF: Radiation Oncology OP:  ',[CPT Service Code]
,[Service Description]
,su.modcode
,su.[Modifier Discount]
,PAID_NET_AMT AS [Actual Payment]
,(ISNULL(EQUIV_ALLOW_COMPARE,0)*2.00) AS [Proposed Amount]
,(ISNULL(EQUIV_ALLOW_COMPARE,0)*1.20) AS [Alleged Current Payment (120% of MCAL)]
,md.paypercent
,md.paydiscount
,QUANTITY AS [Units Adj] -- ,cd.servunits AS [QUANTITY] ... AS [units_adj] ... AS 'Units adj'
,EQUIV_ALLOW_RATE AS [Fee Schedule Rate]
,(CASE WHEN md.paypercent is null THEN 1 ELSE md.paypercent/100 end) AS [Modifier Discount1]
,(CASE WHEN md2.paypercent is null THEN 1 ELSE md2.paypercent/100 end) AS [Modifier Discount2]
,(CASE WHEN md3.paypercent is null THEN 1 ELSE md3.paypercent/100 end) AS [Modifier Discount3]
,(CASE WHEN md4.paypercent is null THEN 1 ELSE md4.paypercent/100 end) AS [Modifier Discount4]
,(CASE WHEN md5.paypercent is null THEN 1 ELSE md5.paypercent/100 end) AS [Modifier Discount5]
,QNXTbilltype
,revcode
,[REVCDE Descr]
,*
-- SELECT TOP 10 ' ' AS 'CHECK 1st',ci.contracted,sip.ProviderParStatus,ci.*,sip.*
-- SELECT DISTINCT ' ' AS 'CHECK 1st',contracted,iscapitated FROM HMOPROD_PLANDATA.dbo.contractinfo
FROM INFORMATICS.dbo.CONTRACTING_PALOMAR_HOSP AS su (NOLOCK)
-- [Modifier Join]
	LEFT JOIN HMOPROD_PlanData.dbo.contract AS ct ON su.contractid = ct.contractid
	LEFT JOIN HMOPROD_PlanData.dbo.moddiscount AS md ON ct.moddiscountgroupid = md.moddiscountgroupid 
		AND su.modcode = md.modcode
	LEFT JOIN HMOPROD_PlanData.dbo.moddiscount AS md2 ON ct.moddiscountgroupid = md2.moddiscountgroupid 
		AND su.modcode2 = md2.modcode
	LEFT JOIN HMOPROD_PlanData.dbo.moddiscount AS md3 ON ct.moddiscountgroupid = md3.moddiscountgroupid 
		AND su.modcode3 = md3.modcode
	LEFT JOIN HMOPROD_PlanData.dbo.moddiscount AS md4 ON ct.moddiscountgroupid = md4.moddiscountgroupid
		 AND su.modcode4 = md4.modcode
	LEFT JOIN HMOPROD_PlanData.dbo.moddiscount AS md5 ON ct.moddiscountgroupid = md5.moddiscountgroupid 
		AND su.modcode5 = md5.modcode
WHERE 1=1
	AND claimid IN ('24281E27078') -- CONTRACT: PALOMAR HOSP SAMPLE
	AND [CPT Service Code] IN ('77280') -- ,'77307','77332','77336','77412','77417') -- CONTRACT: PALOMAR HOSP SAMPLE ... CODE(S) IN PLAY







-- =================================================
	-- CLAIM FEE SCHEDULE(S) / CONTRACT DESCR TERMS --
-- =================================================
	-- CONTRACTERM / FEESCHED SUMMARY query
SELECT ' ' AS 'CONTRACTERM / FEESCHED ... LINES TO IDENTIFY'
,MIN(DOS) AS [RangeStart]
,MAX(DOS) AS [RangeEnd]
,COUNT(DISTINCT(CONCAT(TRY_CONVERT(nvarchar(255), su.claimid), TRY_CONVERT(nvarchar(255), cd.claimline)))) AS [RDT FEE SCHEDULE LINE ALLOCATION]
-- SELECT TOP 10 ' ' AS 'CHECK 1st',cd.claimid,cd.claimline,sft.*,csft.*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM INFORMATICS.dbo.CONTRACTING_PALOMAR_HOSP AS su (NOLOCK)
	JOIN HMOPROD_PLANDATA.dbo.claimdetail AS cd (NOLOCK) ON su.claimid = cd.claimid -- CLAIM ISO SOURCE TABLE
	
		-- SELECT TOP 10 ' ' AS 'DETAIL SAMPLE: ',* FROM INFORMATICS.dbo.CONTRACTING_PALOMAR_HOSP
	
	-- CONTRACTERM / FEESCHED CTE (Common Table Expressions) for reusable subqueries
;WITH ContractDescr AS (
    SELECT DISTINCT ' ' AS 'FEE SCHEDULE(S)',c.contractid,
        UPPER(LTRIM(RTRIM(ISNULL(CAST(c.description AS nvarchar(255)), '')))) AS [CONTRACT DESCRIPTION],
        ct.termid,
        ct.termtype,		
        c.ucrtableid AS [FeeScheduleId],
        sf.description AS [FeeScheduleDesc]
    FROM HMOPROD_PLANDATA.dbo.contract AS c (NOLOCK)
		JOIN HMOPROD_PLANDATA.dbo.contractterm AS ct (NOLOCK) ON c.contractid = ct.contractid
			LEFT JOIN HMOPROD_PLANDATA.dbo.standardfee AS sf (NOLOCK) ON c.ucrtableid = sf.feeid
			LEFT JOIN HMOPROD_PLANDATA.dbo.feetable AS ft (NOLOCK) ON sf.feeid = ft.feetableid
),
CustomFeeSchedule AS (
    SELECT DISTINCT ' ' AS 'CUSTOM FEE SCHEDULE(S)',c.contractid,
        UPPER(LTRIM(RTRIM(ISNULL(CAST(c.description AS nvarchar(255)), '')))) AS [CONTRACT DESCRIPTION],
        ct.termid,
        ct.termtype,
        ct.customfeeid AS [CustFeeScheduleID],
        sf.description AS [CustFeeScheduleDesc]
    FROM HMOPROD_PLANDATA.dbo.contract AS c (NOLOCK)
		JOIN HMOPROD_PLANDATA.dbo.contractterm AS ct (NOLOCK) ON c.contractid = ct.contractid
			LEFT JOIN HMOPROD_PLANDATA.dbo.standardfee AS sf (NOLOCK) ON ct.customfeeid = sf.feeid
			LEFT JOIN HMOPROD_PLANDATA.dbo.feetable AS ft (NOLOCK) ON sf.feeid = ft.feetableid
)

	-- CONTRACTERM / FEESCHED Main query
SELECT ' ' AS 'CONTRACTERM / FEESCHED ... MS ALLYSON + SIR JEREMY ##RDTFeeTerm VIA SIR MARCO',su.line_of_business,
su.FormType,
-- contrdescr.contractid,
-- contrdescr.[CONTRACT DESCRIPTION],
contrdescr.FeeScheduleId,
contrdescr.[FeeScheduleDesc],
--csft.[CustFeeScheduleID],
--csft.[CustFeeScheduleDesc],
--csft.termtype,
COUNT(DISTINCT(CONCAT(TRY_CONVERT(nvarchar(255), cd.claimid), TRY_CONVERT(nvarchar(255), cd.claimline)))) AS [ClaimLineCt]
-- SELECT TOP 10 ' ' AS 'CHECK 1st',cd.claimid,cd.claimline,sft.*,csft.*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM HMOPROD_PLANDATA.dbo.claim AS ClaimData (NOLOCK) -- REFERENCING: ClaimData CTE instead of clm table
	JOIN HMOPROD_PLANDATA.dbo.claimdetail AS cd (NOLOCK) ON ClaimData.claimid = cd.claimid
	JOIN INFORMATICS.dbo.CONTRACTING_PALOMAR_HOSP AS su (NOLOCK) ON cd.claimid = su.claimid -- CLAIM ISO SOURCE TABLE ... NEEDS TO BE REPLACED EACH YEAR
		AND cd.claimline = su.claimline
	JOIN INFORMATICS.dbo.[uvw_LINE_OF_BUSINESS] AS bp (NOLOCK) ON claimdata.planid = bp.planid
		LEFT JOIN ContractDescr AS contrdescr ON cd.contractid = contrdescr.contractid
			AND cd.termid = contrdescr.termid
		LEFT JOIN CustomFeeSchedule AS csft ON cd.contractid = csft.contractid
			AND cd.termid = csft.termid
WHERE 1=1
	AND su.revcode BETWEEN '0330' AND '0339' -- Proposed Radiation Oncology rates (120% of Medi-Cal)
	AND ISNULL(su.EQUIV_allow_compare,0) != 0 -- C002: PER Contracting Meeting ON 20250107 ... Action item: Exclude all claims where there is no corresponding medi-cal rate
	AND su.QNXTbilltype LIKE '1[3-4]%'
GROUP BY su.line_of_business,
su.FormType,
-- contrdescr.contractid,
-- contrdescr.[CONTRACT DESCRIPTION],
contrdescr.FeeScheduleId,
contrdescr.[FeeScheduleDesc]
--csft.[CustFeeScheduleID],
--csft.[CustFeeScheduleDesc],
--csft.termtype
ORDER BY su.line_of_business

	-- ADD validation query to check rates
SELECT 'Radiation Oncology Rate Check' AS Analysis,
revcode,
[REVCDE Descr],
COUNT(DISTINCT(claimid)) AS Claim_Count,
SUM(PAID_NET_AMT) AS Current_Paid,
-- SUM([EQUIV_allow_rate]) AS Proposed_Rate,
TRY_CONVERT(decimal(11,2),SUM((NULLIF(ISNULL(PAID_NET_AMT,0),0) / 1.20) * 2.00))  AS Proposed_Rate -- C005: -- Modify the Proposed Rate Payment calculation in the Contract Analysis section FOR 'Radiation Oncology' [Contracting_Proposal_Category] ... THEN Calculate base rate (reverse engineer from current 120% rate) ... Get back to 100% THEN  Apply new 200% rate
-- CAST(SUM([EQUIV_allow_rate]) / NULLIF(SUM(PAID_NET_AMT), 0) * 100 AS decimal(10,2)) AS Rate_Ratio
FROM INFORMATICS.dbo.CONTRACTING_PALOMAR_HOSP
WHERE revcode BETWEEN '0330' AND '0339'
	AND ISNULL(EQUIV_allow_compare,0) != 0 -- C002: PER Contracting Meeting ON 20250107 ... Action item: Exclude all claims where there is no corresponding medi-cal rate
	AND QNXTbilltype LIKE '1[3-4]%'
	-- AND [ClaimCategory] = 'Paid'
	AND LINE_OF_BUSINESS LIKE '%MEDI%CAL%'
	AND [Primary / Secondary Status] = 'P'
GROUP BY revcode, [REVCDE Descr]
ORDER BY revcode;

SELECT 'Radiation Oncology Rate Check' AS Analysis
,[EQUIV_allow_rate]
,PAID_NET_AMT
,revcode
,[REVCDE Descr]
,[CPT Service Code]
,[Service Description]
,modcode
,[Modifier Discount]
,PAID_NET_AMT AS [Actual Payment]
,(NULLIF(ISNULL(PAID_NET_AMT,0),0) / 1.20) * 2.00  AS Adj_Proposed_Rate -- C005: -- Modify the Proposed Rate Payment calculation in the Contract Analysis section FOR 'Radiation Oncology' [Contracting_Proposal_Category] ... THEN Calculate base rate (reverse engineer from current 120% rate) ... Get back to 100% THEN  Apply new 200% rate
,(ISNULL(EQUIV_ALLOW_COMPARE,0)*2.00) AS [Proposed Amount]
,(ISNULL(EQUIV_ALLOW_COMPARE,0)*1.20) AS [Alleged Current Payment (120% of MCAL)]
,QUANTITY AS [Units Adj] -- ,cd.servunits AS [QUANTITY] ... AS [units_adj] ... AS 'Units adj'
,*
FROM INFORMATICS.dbo.CONTRACTING_PALOMAR_HOSP
WHERE revcode BETWEEN '0330' AND '0339'
	-- AND ISNULL(EQUIV_allow_compare,0) != 0 -- C002: PER Contracting Meeting ON 20250107 ... Action item: Exclude all claims where there is no corresponding medi-cal rate
	AND QNXTbilltype LIKE '1[3-4]%'
	-- AND [ClaimCategory] = 'Paid'
	AND LINE_OF_BUSINESS LIKE '%MEDI%CAL%'
	AND [Primary / Secondary Status] = 'P'
ORDER BY EQUIV_allow_compare







JAH 'CONTRACTING PALOMAR' LEVERAGE 'BAYSHIRE'
		USE http://devops01:8080/IS/_git/Informatics?path=%2Fcontracting_utilization - 'REPO'

Palomar Health (Hospital)  (NPI:1457321317; TIN#95-6003843) 
Line of Business: Medi-Cal 
Target Due Date: Thursday 12/12/24
Requesting a utilization report for the standard most recent 12 months (less three months claim lag), Medi-Cal LOB; please provide the following: 

		•	Comparison with the current (see summary below) vs. their proposed rates  (see summary below) vs. CHG counter (5% increase)
		•	Total unique members seen + units billed

		Current Fee Schedule Medi-Cal
				Inpatient Services(A): 
				0191-0194 Skilled Nursing:  $525 per Day (All Inclusive)
				0170/0171/0179 Boarder Baby: $525 per Day (All Inclusive)

				Outpatient Services(F):  200% of Prevailing Medi-Cal 
				OP Implants and devices paid at invoice cost plus 2%
				0330 – 0339 Radiation Oncology Services:  120% of Prevailing Medi-Cal (All Inclusive)

		Proposed Fee Schedule Medi-Cal 
				Medi-Cal:
				IP Skilled Nursing: $705 per diem
				IP Boarder Baby:  $705 per diem
				IP Administrative Day: 100% Medi-Cal
				OP Implants: 50% of charges (PH will attest that 50% of charges equates to cost)
				Radiology Oncology Services: 200% of prevailing Medi-Cal.
				Add Outpatient Rate Hierarchy Language:  If patient is in the ED (TOB 13x & RC450-459) and moves to Outpatient Surgery (TOB 13x & 360-361, 481, 780, 790) or is Outpatient Trauma (TOB 13x & RC 681-689) then the service is paid at the OP Services rate not ED rate. Pending Provider clarification.

--declare @TIN varchar(100) ='330803845';
declare @current_pct decimal(28, 12) = 1.00; -- FROM PROVIDER; 120% of Prevailing Medi-Cal (All Inclusive)
declare @ProposedPct decimal(28, 12) = 2.00; -- FROM PROVIDER: 200% of prevailing Medi-Cal
declare @counter_pct decimal(28, 12) = 1.05; -- CHGSD COUNTER: 105%







JAH 'PEER REVIEW SD GASTRO': 
Hey Walter and Nolyn – 

I was trying to complete this this morning but caught a mistake in my original work:

		1.	The proposed rate is 120% of Medicare for Medi-Cal members. My original had 120% of Med-Cal.  I have updated the sheet. Can you please QA.

		2.	For D-SNP members, Josey said they are at 100% of Medicare. But when I compare what we actually paid to 100% of Medicare it’s pretty far off. Can you please check my 100% of Medicare rate for D-SNP? Note: I checked with Josey and she confirmed the current rate is 100% of Medicare.

If what I have looks good, you can send it to Salim and Josey, adding a summary to the email.
