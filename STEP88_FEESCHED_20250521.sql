-- ================================================
	-- GENERAL FEE SCHEDULE(s) REVIEW()  / EQUIVALENT --
-- ================================================
		⏎ Professional Claim (formtype = 1500)
				•	TRI Medi-cal - USE 'C01350903'
				•	Medi-cal - USE 'C00740459'
				•	Medicare POS = 02, 11, 12, 20, 50 - USE 'C01011396' 
				•	Medicare POS <> 02, 11, 12, 20, 50 - USE 'C01011395'

		⏎ Hospital Claim (formtype = UB04) 
				•	TRI Medi-cal - USE 'C01350904'
				•	Medi-cal - USE 'C00727442'
				•	Medicare - NO NOT NEGATIVE != <> fee schedule. Claims are priced with Hospital OP PPS pricer
				
		⏎ 'PDPM' = PATIENT DRIVEN PAYMENT MODEL

		⏎ 'TPN AND SUPPLIES' = TPN (Total Parenteral Nutrition) refers to a medical method of providing nutrition that bypasses the digestive system. It is delivered directly into the bloodstream through an intravenous (IV) line, typically into a large vein like the superior vena cava.

		⏎ FOR CONTRACTING ANALYSIS CONSIDER MIN('TRI Medi-cal') OR MAS / BETTER!!!

		⏎ CURRENT VALUE NO NOT NEGATIVE <> != CALUCLATED BASED ON FEE SCHEDULE(S)

        ⏎ 'eMAIL' FROM: SIR ADRIAN ON 20250214 - 'hospital outpatient augmentation' RATIO
				~ Hello, I think we figured this one out. We may be looking at the wrong fee schedule in QNXT.

				The rates for hospitals are calculated a little bit different than the traditional Medi-Cal rates. There is a bump on the Medi-Cal rates for services provided in a hospital outpatient department (the bump is 43.44% )

						So the base rate for CPT 77280 with TC Modifier is  $70.52 x 1.4344 (hospital outpatient augmentation) = $101.16 x 1.2 (Palomar’s contracted rate) = $121.39.

				My recommendation is to use the fee schedule attached to the contract term in QNXT. 

				Thank you,
				Adrian		

		SELECT 'Contracting / HCT Fx: Quick 'General' KPI QA Sources - RE  HCT All Acute Tableau for reference.msg' AS [MESSAGE(S)]

I. FOR General ‘Paid Claims’ QA:
        ⏎ https://us-west-2b.online.tableau.com/#/site/chgsd/views/HCTAutomation/GRIDER?:iid=1 – ‘HCT (Health Care Trends: Monthly)’

II. FOR General ‘Claims Inventory’ QA:
        ⏎ see attached ‘AB1455’ email related to a regulatory claim inventory report (by Qtr)
        ⏎ for a more granular level report: http://prodqssrs.chg.com/Reports/manage/catalogitem/properties/Informatics/_General/Claims_InventoryCounts  

III. FOR General ‘Maternity / Newborn’ QA:
        ⏎ see attached ‘Maternity Kick’ email
        ⏎ \\chg_cifs01\shared\Informatics_Reporting\ROUTINE\yyyymmddBs8thRUN_FINAL.xls - CURRENT RUN
        ⏎ \\chg_cifs01\shared\Informatics_Reporting\ROUTINE\MaternityKickArchive.xlsx - HISTORICAL

Contracting / HCT Fx: 

        ⏎ Given: If 20 represent 110% of the Medical Rate what would the 100 value be?
				•	$20 represents 110% of the Medical Rate.
				•	We need to find the 100% value of the Medical Rate.

		Step 1: Set up an equation. Let x be the 100% value of the Medical Rate. 110% of x = 20
		Step 2: Convert the percentage to a decimal. 1.1x = 20
		Step 3: Solve for x by dividing both sides by 1.1. x = 20 ÷ 1.1 x ≈ $18.18

Therefore, the 100% value of the Medical Rate is approximately 18.18.
Formula for future reference: To find the 100% value when given a percentage and its corresponding value, use the following formula:

		100% value = (Given value ÷ Given percentage) × 100

In this case: 100% value = (20 ÷ 110) × 100 ≈ 18.18

You can use this formula whenever you need to find the 100% value based ON a given percentage and its corresponding value.

        ⏎ 'IP admits per 1000 Members per Year' or PTMPY formula, which is a key performance indicator IN the attached Medi-Cal data. PTMPY measures the number of inpatient hospital admissions per 1,000 members over a year. It is calculated by dividing the total number of inpatient admissions IN a given year by the average number of members during that year, and THEN multiplying the result by 1,000.
		
        ⏎ 'BASE $ Fx': W = $ / %		

The formula is:

PTMPY = (Total IP Admissions IN a Year ÷ Average Number of Members IN a Year) × 1,000
For example, if a health plan had 5,000 total IP admissions IN a year and an average of 100,000 members, the PTMPY would be:
PTMPY = (5,000 ÷ 100,000) × 1,000 = 50

This means that for every 1,000 members, there were 50 IP admissions that year.

The PTMPY metric is essential for understanding the utilization of inpatient services and the overall health of the member population. A higher PTMPY may indicate a greater burden of illness among members or potential issues with access to preventive care and disease management.

By tracking PTMPY over time and comparing it to benchmarks, CHGSD can identify trends, evaluate the effectiveness of care management initiatives, and make data-driven decisions to improve members' health outcomes and optimize resource utilization.

        ⏎ 'IP admits per 1000 Members per Month (PTMPM) formula? In addition to the 'IP admits per 1000 Members per Year' (PTMPY) formula, I'd like to explain the 'admits per 1000 Members per Month' or PTMPM formula, which provides a more granular view of inpatient admissions. PTMPM measures the number of inpatient hospital admissions per 1,000 members per month. It's calculated by dividing the total number of inpatient admissions IN a given month by the number of members during that month, and THEN multiplying the result by 1,000.

The formula is:
PTMPM = (Total IP Admissions IN a Month ÷ Number of Members IN a Month) × 1,000

For example, if a health plan had 500 total IP admissions IN a month and 100,000 members, the PTMPM would be:
PTMPM = (500 ÷ 100,000) × 1,000 = 5

This means that for every 1,000 members, there were 5 IP admissions that month.

The PTMPM metric is valuable for several reasons:

		1.	It allows for closer monitoring of inpatient utilization trends, enabling timely identification of potential issues or successes.
		2.	It helps to identify seasonal patterns IN inpatient admissions, which can inform resource planning and care management strategies.
		3.	It facilitates more accurate comparisons between different months or periods, as it accounts for variations IN membership.

By tracking PTMPM alongside PTMPY, CHGSD can gain a comprehensive understanding of inpatient utilization patterns and make informed decisions to optimize care delivery and manage costs.
I hope this explanation clarifies the PTMPM formula and its value. 







-- =========================================================
	-- FEE SCHEDULE(s) REVIEW() --
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
        FROM HMOPROD_PLANDATA.dbo.claim c
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

		⏎ Hospital Claim (formtype = UB04) 
				•	TRI Medi-cal - USE 'C01350904'
				•	Medi-cal - USE 'C00727442'
				•	Medicare - NO NOT NEGATIVE != <> fee schedule. Claims are priced with Hospital OP PPS pricer
				
		⏎ 'PDPM' = PATIENT DRIVEN PAYMENT MODEL

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
	-- equiv.[FEE SCHEDULE] LIKE '%0%MCAL%UCR%' -- 'MediCal':  0 PHYS MCAL UCR FEE TABLE for the Medi-Cal rates.
	equiv.feetableid IN (@SETfeesched,'C00740459','C00727442','C01350903','C01350904') -- -- DEFINE / SELECT DESIRED SCHEDULE ... SAMPLE FROM [CONTRACTING AWPvMCALvASP_...rar] USE 'C00740459' AS AWP % FEE SCHEDULE
		 -- OR equiv.[FEE SCHEDULE] LIKE '%ASC%' -- '%UB%' 129.5% OF GA SCHEDULE
		 -- OR equiv.[FEE SCHEDULE] LIKE '%0%MEDICARE%PRO%' -- 'ASP':  0 MEDICARE PRO RATES 
		) -- CONCLUDE ...
	AND equiv.mincodeid IN ('77280') -- ,'77307','77332','77336','77412','77417') -- CODE(S) IN PLAY
	-- AND equiv.feetableid IN ('C00740459','C01011396','C01011395','C00727442')
	-- AND equiv.category LIKE '%RU%'	
	-- AND UPPER(LTRIM(RTRIM(ISNULL(equiv.feeid,'')))) LIKE @schedid -- DEFINE / SELECT DESIRED SCHEDULE
	-- AND CAST(ISNULL(equiv.effdate,CAST(GETDATE() AS date)) AS date) >= @whensf -- AS OF ...	
	-- AND equiv.description LIKE @feeschedulename
ORDER BY equiv.[FEE SCHEDULE],equiv.modcode







-- ==========================================================================
	-- CLAIM FEE SCHEDULE(S) ASSIGNMENT / CONTRACTERM + CONTRACT DESCR TERMS --
-- ==========================================================================
SELECT ' ' AS 'CONTRACTERM / FEESCHED ... LINES TO IDENTIFY'
,MIN(DOS) AS [RangeStart]
,MAX(DOS) AS [RangeEnd]
,COUNT(DISTINCT(CONCAT(TRY_CONVERT(nvarchar(255), su.claimid), TRY_CONVERT(nvarchar(255), cd.claimline)))) AS [FEE SCHEDULE LINE ALLOCATION#]
-- SELECT TOP 10 ' ' AS 'CHECK 1st',cd.claimid,cd.claimline,sft.*,csft.*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM INFORMATICS.dbo.CONTRACTING_PALOMAR_HOSP AS su (NOLOCK)
	JOIN HMOPROD_PLANDATA.dbo.claimdetail AS cd (NOLOCK) ON su.claimid = cd.claimid -- CLAIM ISO SOURCE TABLE
	
		-- SELECT TOP 10 ' ' AS 'DETAIL SAMPLE: ',* FROM INFORMATICS.dbo.CONTRACTING_PALOMAR_HOSP
	
;WITH ContractDescr AS ( -- CONTRACTERM / FEESCHED CTE (Common Table Expressions) for reusable subqueries
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

SELECT ' ' AS 'CONTRACTERM / FEESCHED ... MS ALLYSON + SIR JEREMY ##RDTFeeTerm VIA SIR MARCO',su.line_of_business,
su.FormType,
-- ISNULL(contrdescr.contractid,'UNKNOWN') AS 'contractid',
-- ISNULL(contrdescr.[CONTRACT DESCRIPTION],'UNKNOWN') AS 'CONTRACT DESCRIPTION',
ISNULL(contrdescr.FeeScheduleId,'UNKNOWN') AS 'FeeScheduleId',
ISNULL(contrdescr.FeeScheduleDesc,'UNKNOWN') AS 'FeeScheduleDesc',
-- ISNULL(csft.[CustFeeScheduleID],'UNKNOWN') AS 'CustFeeScheduleID',
-- ISNULL(csft.[CustFeeScheduleDesc],'UNKNOWN') AS 'CustFeeScheduleDesc',
-- ISNULL(csft.termtype,'UNKNOWN') AS 'termtype',
COUNT(DISTINCT(CONCAT(TRY_CONVERT(nvarchar(255), cd.claimid), TRY_CONVERT(nvarchar(255), cd.claimline)))) AS [ClaimLineCt]
-- SELECT TOP 10 ' ' AS 'CHECK 1st',cd.claimid,cd.claimline,sft.*,csft.*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM INFORMATICS.dbo.CONTRACTING_PALOMAR_HOSP AS su (NOLOCK) -- CLAIM ISO SOURCE TABLE ... NEEDS TO BE REPLACED ...
	JOIN HMOPROD_PLANDATA.dbo.claim AS ClaimData (NOLOCK) ON su.claimid = ClaimData.claimid  -- REFERENCING: ClaimData CTE instead of clm table
	JOIN HMOPROD_PLANDATA.dbo.claimdetail AS cd (NOLOCK)  ON  su.claimid = cd.claimid
		AND su.claimline = cd.claimline
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

SELECT ' ' AS 'CONTRACTING: PALOMAR QA OF: Radiation Oncology OP:  ',ct.ucrtableid
,[CPT Service Code]
,[CPT Service Description]
,su.modcode
,su.[Modifier Discount]
,PAID_NET_AMT AS [Actual Payment]
,(ISNULL(EQUIV_ALLOW_COMPARE,0)*2.00) AS [Proposed Amount]
,(ISNULL(EQUIV_ALLOW_COMPARE,0)*1.20) AS [Alleged Current Payment (120% of MCAL)]
,md.paypercent
,md.paydiscount
,QUANTITY AS [Units Adj]
,EQUIV_ALLOW_RATE AS [Fee Schedule Rate]
,(CASE WHEN md.paypercent is null THEN 1 ELSE md.paypercent/100 end) AS [Modifier Discount1]
,(CASE WHEN md2.paypercent is null THEN 1 ELSE md2.paypercent/100 end) AS [Modifier Discount2]
,(CASE WHEN md3.paypercent is null THEN 1 ELSE md3.paypercent/100 end) AS [Modifier Discount3]
,(CASE WHEN md4.paypercent is null THEN 1 ELSE md4.paypercent/100 end) AS [Modifier Discount4]
,(CASE WHEN md5.paypercent is null THEN 1 ELSE md5.paypercent/100 end) AS [Modifier Discount5]
,QNXTbilltype
,revcode
,[REVCDE Descr],*
-- SELECT TOP 10 ' ' AS 'CHECK 1st',ci.contracted,sip.ProviderParStatus,ci.*,sip.*
-- SELECT DISTINCT ' ' AS 'CHECK 1st',contracted,iscapitated FROM HMOPROD_PLANDATA.dbo.contractinfo
FROM INFORMATICS.dbo.CONTRACTING_PALOMAR_HOSP AS su (NOLOCK)
-- [Modifier Join]
	LEFT JOIN HMOPROD_PlanData.dbo.contract AS ct (NOLOCK) ON su.contractid = ct.contractid
	LEFT JOIN HMOPROD_PlanData.dbo.moddiscount AS md (NOLOCK) ON ct.moddiscountgroupid = md.moddiscountgroupid 
		AND su.modcode = md.modcode
	LEFT JOIN HMOPROD_PlanData.dbo.moddiscount AS md2 (NOLOCK) ON ct.moddiscountgroupid = md2.moddiscountgroupid 
		AND su.modcode2 = md2.modcode
	LEFT JOIN HMOPROD_PlanData.dbo.moddiscount AS md3 (NOLOCK) ON ct.moddiscountgroupid = md3.moddiscountgroupid 
		AND su.modcode3 = md3.modcode
	LEFT JOIN HMOPROD_PlanData.dbo.moddiscount AS md4 (NOLOCK) ON ct.moddiscountgroupid = md4.moddiscountgroupid
		 AND su.modcode4 = md4.modcode
	LEFT JOIN HMOPROD_PlanData.dbo.moddiscount AS md5 (NOLOCK) ON ct.moddiscountgroupid = md5.moddiscountgroupid 
		AND su.modcode5 = md5.modcode
WHERE 1=1
	AND claimid IN ('24281E27078') -- CONTRACT: PALOMAR HOSP SAMPLE
	AND [CPT Service Code] IN ('77280') -- ,'77307','77332','77336','77412','77417') -- CONTRACT: PALOMAR HOSP SAMPLE ... CODE(S) IN PLAY







-- =============================================================
	-- AWP (Average Wholesale Price) INDICATOR --
-- =============================================================
UPDATE INFORMATICS.dbo.AWPvMCALvASP 
SET [AWP Indicator] = 'Y' -- CHARINDEX() FIND() SEARCH() 'SUBJECT:AWP FROM:ALLYSON ... 'Can you flag the services that meet this criteria? and cdet.servcode like '%J%' and ct.longdescription like '%AWP%'   Using the below joins. LEFT JOIN HMOPROD_PlanData.dbo.contract con ON con.contractid = c.contractid LEFT JOIN HMOPROD_PlanData.dbo.contractterm ct ON ct.contractid = cdet.contractid and ct.termid = cdet.termid
-- SELECT ct.longdescription,con.*,ct.*,su.* -- CHECK 1st
-- SELECT DISTINCT CAST(ct.longdescription AS nvarchar(2000)) AS [Descr] -- CHECK 1st
 FROM INFORMATICS.dbo.AWPvMCALvASP AS su
	JOIN HMOPROD_PlanData.dbo.contract AS con ON su.contractid = con.contractid
	JOIN HMOPROD_PlanData.dbo.contractterm AS ct ON su.contractid = ct.contractid
		AND su.termid = ct.termid
WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ... AND ...
	AND su.[CPT Service Code] like '%J%'
	AND ct.longdescription like '%AWP%'	
	-- AND SEQ_CLAIM_ID IN ('19043E10154') -- SAMPLE FROM [CONTRACTING AWPvMCALvASP_...rar] USE 'C00740459' AS AWP % FEE SCHEDULE

	





-- =======================================================================
	-- ASSUMING CONTRACTING HAS PROVIDED % BID / PROPOSAL SUMMARY + DETAIL --
-- =======================================================================
-- DECLARE @solveforunknown AS decimal(9,3) = 1.3 -- DO THE MATH ... 100% value = (Given value ÷ Given percentage) × 100 ('STEP88_FEESCHED...sql') eg. 130% OF ?

		/* ,cd.servunits -- AS [QUANTITY]
		,CAST(NULL AS int) AS [QUANTITY] -- see UNNECESSARY ADJ UPDATE BELOW
		,clm.totalamt AS TOTAL_BILLED_AMT
		,clm.totalpaid AS TOTAL_PAID_AMOUNT
		,cd.claimamt AS BILLED_AMT --BILLED (BAP)
		,cd.allowedamt AS ALLOWED_AMT  --ALLOWED (BAP)
		,cd.amountpaid AS NET_AMT
		,cd.amountpaid AS PAID_NET_AMT -- cd.amountpaid PROVEN to represent true COST (see pv.amountpaid AS CHECKAMT)  + PAID (BAP)
		,-cd.paydiscount AS [INT] -- INTEREST -- ,ABS(cd.paydiscount) AS [INT]
		,cd.ineligibleamt AS [DISALLOWED],cd.cobeligibleamt AS [COB Allowed],cd.extpaidamt AS [COB Paid],clm.totextdeductamt AS [COBDeduct],cd.extcoinsuranceamt AS [COB Coinsurance]
		,CAST(NULL AS money) AS [Modifier Discount] -- QUPD()
		,CAST((cd.amountpaid/@solveforunknown) AS money) AS [WHEN_GIVEN_CONTRACT_EQUIV_paid]
		,CAST(NULL AS money) AS [EQUIV_allow_rate]
		,CAST(NULL AS money) AS [EQUIV_allow_compare] */

SELECT 'ASSUMING CONTRACTING PROVIDED RATE ...' AS [MESSAGE(S)],Cx AS [SPECIALTY],LINE_OF_BUSINESS,PAYTONM
,SUM((PAID_NET_AMT/@solveforunknown))*1.5 AS [150% BID / PROPOSAL AMOUNT]
,SUM((PAID_NET_AMT/@solveforunknown))*1.3 AS [130% BID / PROPOSAL AMOUNT]
,SUM((PAID_NET_AMT/@solveforunknown))*1.0 AS [100% BID / PROPOSAL AMOUNT]
,SUM((PAID_NET_AMT/@solveforunknown)) AS [CHGSD PAID AMOUNT]
,COUNT(DISTINCT(u.memid)) AS [Unique Members]
,COUNT(DISTINCT(AdmitID)) AS [VISIT(S)]
,COUNT(DISTINCT(claimid)) AS [CLAIM(S)],u.[RANGE NOTE(s)]
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st
FROM TABLENAME AS u
WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ... AND ...
	AND [PAID_NET_AMT] != 0 -- APPLE(S) TO APPLE(S) ... COMPARED TO WHAT?
	AND [Primary / Secondary Status] = 'P'
GROUP BY LINE_OF_BUSINESS,PAYTONM,Cx,u.[RANGE NOTE(s)]
ORDER BY LINE_OF_BUSINESS,PAYTONM

SELECT 'ASSUMING CONTRACTING PROVIDED RATE ...' AS [MESSAGE(S)],Cx AS [SPECIALTY],LINE_OF_BUSINESS,PAYTONM
,SUM(WHEN_GIVEN_CONTRACT_EQUIV_paid)*1.5 AS [150% BID / PROPOSAL AMOUNT]
,SUM(WHEN_GIVEN_CONTRACT_EQUIV_paid)*1.3 AS [130% BID / PROPOSAL AMOUNT]
,SUM(WHEN_GIVEN_CONTRACT_EQUIV_paid)*1.0 AS [100% BID / PROPOSAL AMOUNT]
,SUM(WHEN_GIVEN_CONTRACT_EQUIV_paid) AS [CHGSD PAID AMOUNT]
,COUNT(DISTINCT(u.memid)) AS [Unique Members]
,COUNT(DISTINCT(AdmitID)) AS [VISIT(S)]
,COUNT(DISTINCT(claimid)) AS [CLAIM(S)],u.[RANGE NOTE(s)]
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st
FROM TABLENAME AS u
WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ... AND ...
	AND [PAID_NET_AMT] != 0 -- APPLE(S) TO APPLE(S) ... COMPARED TO WHAT?
	-- AND [WHEN_GIVEN_CONTRACT_EQUIV_paid] != 0 -- APPLE(S) TO APPLE(S) ... COMPARED TO WHAT?
	AND [Primary / Secondary Status] = 'P'
GROUP BY LINE_OF_BUSINESS,PAYTONM,Cx,u.[RANGE NOTE(s)]
ORDER BY LINE_OF_BUSINESS,PAYTONM







-- =========================================================
	-- MS ALLYSON FEE SCHEDULE(s) REVIEW()  / EQUIVALENT --
-- =========================================================
-- =====================================================================
	-- DECLARE @PARAMETER(S) / @FILTER(S) --
-- =====================================================================
DECLARE @SETfeesched AS varchar(255)

SET @SETfeesched = 'C01350903'
		/* ⏎ Professional Claim (formtype = 1500)
				•	TRI Medi-cal - USE 'C01350903'
				•	Medi-cal - USE 'C00740459'
				•	Medicare POS = 02, 11, 12, 20, 50 - USE 'C01011396' 
				•	Medicare POS <> 02, 11, 12, 20, 50 - USE 'C01011395'

		⏎ Hospital Claim (formtype = UB04) 
				•	TRI Medi-cal - USE 'C01350904'
				•	Medi-cal - USE 'C00727442'
				•	Medicare - NO NOT NEGATIVE != <> fee schedule. Claims are priced with Hospital OP PPS pricer
				
		⏎ 'PDPM' = PATIENT DRIVEN PAYMENT MODEL

		⏎ FOR CONTRACTING ANALYSIS CONSIDER MIN('TRI Medi-cal') OR MAS / BETTER!!! */

-- =====================================================================
	-- CONTRACTING DEPT. PROPOSAL [Modifier Discount] --
-- =====================================================================
UPDATE TABLENAME
SET [EQUIV_allow_rate] = CAST(NULL AS money) -- POWER CYCLE RESET REFRESH RESTART
,[EQUIV_allow_compare] = CAST(NULL AS money) -- POWER CYCLE RESET REFRESH RESTART
,[EQUIV_allow_rate2] = CAST(NULL AS money) -- POWER CYCLE RESET REFRESH RESTART
,[EQUIV_allow_compare2] = CAST(NULL AS money) -- POWER CYCLE RESET REFRESH RESTART
,[EQUIV_allow_rate3] = CAST(NULL AS money) -- POWER CYCLE RESET REFRESH RESTART
,[EQUIV_allow_compare3] = CAST(NULL AS money) -- POWER CYCLE RESET REFRESH RESTART

UPDATE TABLENAME
SET [Modifier Discount] = (CASE WHEN md.paypercent is null THEN 1 ELSE md.paypercent/100 end) * 
(CASE WHEN md2.paypercent is null THEN 1 ELSE md2.paypercent/100 end) * 
(CASE WHEN md3.paypercent is null THEN 1 ELSE md3.paypercent/100 end) * 
(CASE WHEN md4.paypercent is null THEN 1 ELSE md4.paypercent/100 end) * 
(CASE WHEN md5.paypercent is null THEN 1 ELSE md5.paypercent/100 end) -- as [totalmoddiscount]
FROM TABLENAME AS su
-- [Modifier Join] -- MS ALLYSON see "STEP88_FEESCHED_...sql"
		LEFT JOIN HMOPROD_PlanData.dbo.contract AS con ON su.contractid = con.contractid
		LEFT JOIN HMOPROD_PlanData.dbo.moddiscount AS md ON con.moddiscountgroupid = md.moddiscountgroupid 
			AND su.modcode = md.modcode
		LEFT JOIN HMOPROD_PlanData.dbo.moddiscount AS md2 ON con.moddiscountgroupid = md2.moddiscountgroupid 
			AND su.modcode2 = md2.modcode
		LEFT JOIN HMOPROD_PlanData.dbo.moddiscount AS md3 ON con.moddiscountgroupid = md3.moddiscountgroupid 
			AND su.modcode3 = md3.modcode
		LEFT JOIN HMOPROD_PlanData.dbo.moddiscount AS md4 ON con.moddiscountgroupid = md4.moddiscountgroupid
			 AND su.modcode4 = md4.modcode
		LEFT JOIN HMOPROD_PlanData.dbo.moddiscount AS md5 ON con.moddiscountgroupid = md5.moddiscountgroupid 
			AND su.modcode5 = md5.modcode

UPDATE TABLENAME
SET [EQUIV_allow_rate] = case 
when f.feeamount is null and f2.feeamount is null and f3.feeamount is null and f4.feeamount is null and f5.feeamount is null and f6.feeamount is null and f7.feeamount is null and f8.feeamount is null and f9.feeamount is null and f10.feeamount is null and f11.feeamount is null and f12.feeamount is null and f13.feeamount is null THEN f14.feeamount
when f.feeamount is null and f2.feeamount is null and f3.feeamount is null and f4.feeamount is null and f5.feeamount is null and f6.feeamount is null and f7.feeamount is null and f8.feeamount is null and f9.feeamount is null and f10.feeamount is null and f11.feeamount is null and f12.feeamount is null THEN f13.feeamount 
when f.feeamount is null and f2.feeamount is null and f3.feeamount is null and f4.feeamount is null and f5.feeamount is null and f6.feeamount is null and f7.feeamount is null and f8.feeamount is null and f9.feeamount is null and f10.feeamount is null and f11.feeamount is null THEN f12.feeamount
when f.feeamount is null and f2.feeamount is null and f3.feeamount is null and f4.feeamount is null and f5.feeamount is null and f6.feeamount is null and f7.feeamount is null and f8.feeamount is null and f9.feeamount is null and f10.feeamount is null THEN f11.feeamount
when f.feeamount is null and f2.feeamount is null and f3.feeamount is null and f4.feeamount is null and f5.feeamount is null and f6.feeamount is null and f7.feeamount is null and f8.feeamount is null and f9.feeamount is null THEN f10.feeamount
when f.feeamount is null and f2.feeamount is null and f3.feeamount is null and f4.feeamount is null and f5.feeamount is null and f6.feeamount is null and f7.feeamount is null and f8.feeamount is null THEN f9.feeamount
when f.feeamount is null and f2.feeamount is null and f3.feeamount is null and f4.feeamount is null and f5.feeamount is null and f6.feeamount is null and f7.feeamount is null THEN f8.feeamount
when f.feeamount is null and f2.feeamount is null and f3.feeamount is null and f4.feeamount is null and f5.feeamount is null and f6.feeamount is null THEN f7.feeamount
when f.feeamount is null and f2.feeamount is null and f3.feeamount is null and f4.feeamount is null and f5.feeamount is null THEN f6.feeamount
when f.feeamount is null and f2.feeamount is null and f3.feeamount is null and f4.feeamount is null THEN f5.feeamount
when f.feeamount is null and f2.feeamount is null and f3.feeamount is null THEN f4.feeamount
when f.feeamount is null and f2.feeamount is null THEN f3.feeamount
when f.feeamount is null THEN f2.feeamount
ELSE f.feeamount end
,[EQUIV_allow_compare] = case 
when f.feeamount is null and f2.feeamount is null and f3.feeamount is null and f4.feeamount is null and f5.feeamount is null and f6.feeamount is null and f7.feeamount is null and f8.feeamount is null and f9.feeamount is null and f10.feeamount is null and f11.feeamount is null and f12.feeamount is null and f13.feeamount is null THEN f14.feeamount
when f.feeamount is null and f2.feeamount is null and f3.feeamount is null and f4.feeamount is null and f5.feeamount is null and f6.feeamount is null and f7.feeamount is null and f8.feeamount is null and f9.feeamount is null and f10.feeamount is null and f11.feeamount is null and f12.feeamount is null THEN f13.feeamount 
when f.feeamount is null and f2.feeamount is null and f3.feeamount is null and f4.feeamount is null and f5.feeamount is null and f6.feeamount is null and f7.feeamount is null and f8.feeamount is null and f9.feeamount is null and f10.feeamount is null and f11.feeamount is null THEN f12.feeamount
when f.feeamount is null and f2.feeamount is null and f3.feeamount is null and f4.feeamount is null and f5.feeamount is null and f6.feeamount is null and f7.feeamount is null and f8.feeamount is null and f9.feeamount is null and f10.feeamount is null THEN f11.feeamount
when f.feeamount is null and f2.feeamount is null and f3.feeamount is null and f4.feeamount is null and f5.feeamount is null and f6.feeamount is null and f7.feeamount is null and f8.feeamount is null and f9.feeamount is null THEN f10.feeamount
when f.feeamount is null and f2.feeamount is null and f3.feeamount is null and f4.feeamount is null and f5.feeamount is null and f6.feeamount is null and f7.feeamount is null and f8.feeamount is null THEN f9.feeamount
when f.feeamount is null and f2.feeamount is null and f3.feeamount is null and f4.feeamount is null and f5.feeamount is null and f6.feeamount is null and f7.feeamount is null THEN f8.feeamount
when f.feeamount is null and f2.feeamount is null and f3.feeamount is null and f4.feeamount is null and f5.feeamount is null and f6.feeamount is null THEN f7.feeamount
when f.feeamount is null and f2.feeamount is null and f3.feeamount is null and f4.feeamount is null and f5.feeamount is null THEN f6.feeamount
when f.feeamount is null and f2.feeamount is null and f3.feeamount is null and f4.feeamount is null THEN f5.feeamount
when f.feeamount is null and f2.feeamount is null and f3.feeamount is null THEN f4.feeamount
when f.feeamount is null and f2.feeamount is null THEN f3.feeamount
when f.feeamount is null THEN f2.feeamount
ELSE f.feeamount end -- AS [EQUIV_allow_rate]
* (CASE WHEN md.paypercent is null THEN 1 ELSE md.paypercent/100 end) * 
(CASE WHEN md2.paypercent is null THEN 1 ELSE md2.paypercent/100 end) * 
(CASE WHEN md3.paypercent is null THEN 1 ELSE md3.paypercent/100 end) * 
(CASE WHEN md4.paypercent is null THEN 1 ELSE md4.paypercent/100 end) * 
(CASE WHEN md5.paypercent is null THEN 1 ELSE md5.paypercent/100 end) -- AS totalmoddiscount ... [Modifier Discount]
* su.QUANTITY -- *1.295 -- AS [units_adj]
-- SELECT TOP 10 ' ' AS 'CHECK 1st',ci.contracted,sip.ProviderParStatus,ci.*,sip.*
-- SELECT DISTINCT ' ' AS 'CHECK 1st',contracted,iscapitated FROM HMOPROD_PLANDATA.dbo.contractinfo
FROM TABLENAME AS su
-- [Modifier Join]
	LEFT JOIN HMOPROD_PlanData.dbo.contract ct ON su.contractid = ct.contractid
	LEFT JOIN HMOPROD_PlanData.dbo.moddiscount md ON ct.moddiscountgroupid = md.moddiscountgroupid 
		AND su.modcode = md.modcode
	LEFT JOIN HMOPROD_PlanData.dbo.moddiscount md2 ON ct.moddiscountgroupid = md2.moddiscountgroupid 
		AND su.modcode2 = md2.modcode
	LEFT JOIN HMOPROD_PlanData.dbo.moddiscount md3 ON ct.moddiscountgroupid = md3.moddiscountgroupid 
		AND su.modcode3 = md3.modcode
	LEFT JOIN HMOPROD_PlanData.dbo.moddiscount md4 ON ct.moddiscountgroupid = md4.moddiscountgroupid
		 AND su.modcode4 = md4.modcode
	LEFT JOIN HMOPROD_PlanData.dbo.moddiscount md5 ON ct.moddiscountgroupid = md5.moddiscountgroupid 
		AND su.modcode5 = md5.modcode
-- FROM #temp AS db -- [Fee Schedule LEFT JOIN]
	LEFT JOIN hmoprod_plandata.dbo.feetable f ON su.[CPT Service Code] = f.mincodeid
		AND su.modcode = f.modcode
		AND su.modcode2 = f.modcode2
		AND su.location = f.locationcode
		and f.feetableid = @SETfeesched 
		and f.termdate = '12/31/2078'
	LEFT JOIN hmoprod_plandata.dbo.feetable f2 ON su.[CPT Service Code] = f2.mincodeid
		AND su.modcode = f2.modcode
		AND su.modcode2 = f.modcode2  
		and ISNULL(f2.locationcode,'') = '' 
		and f2.feetableid = @SETfeesched 
		and f2.termdate = '12/31/2078'
	LEFT JOIN hmoprod_plandata.dbo.feetable f3 ON su.[CPT Service Code] = f3.mincodeid
		AND su.modcode = f3.modcode2
		AND su.modcode2 = f3.modcode
		AND su.location = f3.locationcode 
		and f3.feetableid = @SETfeesched 
		and f3.termdate = '12/31/2078'
	LEFT JOIN hmoprod_plandata.dbo.feetable f4 ON su.[CPT Service Code] = f4.mincodeid
		AND su.modcode = f4.modcode2
		AND su.modcode2 = f4.modcode
		and ISNULL(f4.locationcode,'') = '' 
		and f4.feetableid = @SETfeesched 
		and f4.termdate = '12/31/2078'
	LEFT JOIN hmoprod_plandata.dbo.feetable f5 ON su.[CPT Service Code] = f5.mincodeid
		AND su.modcode = f5.modcode
		AND su.location = f5.locationcode
		and f5.feetableid = @SETfeesched 
		and f5.termdate = '12/31/2078'
	LEFT JOIN hmoprod_plandata.dbo.feetable f6 ON su.[CPT Service Code] = f6.mincodeid
		AND su.modcode = f6.modcode
		and ISNULL(f6.locationcode,'') = '' 
		and f6.feetableid = @SETfeesched 
		and f6.termdate = '12/31/2078'
	LEFT JOIN hmoprod_plandata.dbo.feetable f7 ON su.[CPT Service Code] = f7.mincodeid
		AND su.modcode2 = f7.modcode
		AND su.location = f7.locationcode  
		and f7.feetableid = @SETfeesched 
		and f7.termdate = '12/31/2078'
	LEFT JOIN hmoprod_plandata.dbo.feetable f8 ON su.[CPT Service Code] = f8.mincodeid
		AND su.modcode2 = f8.modcode
		and ISNULL(f8.locationcode,'') = '' 
		and f8.feetableid = @SETfeesched 
		and f8.termdate = '12/31/2078'
	LEFT JOIN hmoprod_plandata.dbo.feetable f9 ON su.[CPT Service Code] = f9.mincodeid
		AND su.modcode3 = f9.modcode
		AND su.location = f9.locationcode
		and f9.feetableid = @SETfeesched 
		and f9.termdate = '12/31/2078'
	LEFT JOIN hmoprod_plandata.dbo.feetable f10 ON su.[CPT Service Code] = f10.mincodeid
		AND su.modcode3 = f10.modcode 
		and ISNULL(f10.locationcode,'') = '' 
		and f10.feetableid = @SETfeesched 
		and f10.termdate = '12/31/2078'
	LEFT JOIN hmoprod_plandata.dbo.feetable f11 ON su.[CPT Service Code] = f11.mincodeid
		AND su.modcode4 = f11.modcode
		AND su.location = f11.locationcode  
		and f11.feetableid = @SETfeesched 
		and f11.termdate = '12/31/2078'
	LEFT JOIN hmoprod_plandata.dbo.feetable f12 ON su.[CPT Service Code] = f12.mincodeid
		AND su.modcode4 = f12.modcode
		and ISNULL(f12.locationcode,'') = '' 
		and f12.feetableid = @SETfeesched 
		and f12.termdate = '12/31/2078'
	LEFT JOIN hmoprod_plandata.dbo.feetable f13 ON su.[CPT Service Code] = f13.mincodeid
		AND su.modcode5 = f13.modcode
		AND su.location = f13.locationcode  
		and f13.feetableid = @SETfeesched 
		and f13.termdate = '12/31/2078'
	LEFT JOIN hmoprod_plandata.dbo.feetable f14 ON su.[CPT Service Code] = f14.mincodeid
		AND su.modcode5 = f14.modcode
		and ISNULL(f14.locationcode,'') = '' 
		and f14.feetableid = @SETfeesched 
		and f14.termdate = '12/31/2078'
WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ... AND ...
	AND [EQUIV_allow_rate] IS NULL

	-- AND -- Professional Claim (formtype = 1500)
	-- ( -- INITIATE ...
	-- su.formtype LIKE '%1500%' -- PROFESSIONAL •	Medi-cal - USE @SETfeesched
	-- ) -- CONCLUDE ...

	-- AND -- Hospital Claim (formtype = UB04) 
	-- ( -- INITIATE ...
	-- su.formtype LIKE '%UB%' -- FACILITY •	Medi-cal - USE 'C00727442'
	-- ) -- CONCLUDE ...

	-- AND -- Professional Claim (formtype = 1500)
	-- ( -- INITIATE ...
	-- su.formtype LIKE '%1500%' -- PROFESSIONAL
	-- AND su.Location IN ('02','11','12','20','50') -- •	Medicare POS = 02, 11, 12, 20, 50 - USE 'C01011396' 
	-- ) -- CONCLUDE ...

	-- AND -- Professional Claim (formtype = 1500)
	-- ( -- INITIATE ...
	-- su.formtype LIKE '%1500%' -- PROFESSIONAL
	-- AND su.Location NOT IN ('02','11','12','20','50') -- NO NOT NEGATIVE <> != •	Medicare POS <> 02, 11, 12, 20, 50 - USE 'C01011395'
	-- ) -- CONCLUDE ...

/* UPDATE TABLENAME -- DEFAULT REMAINING NULL EQUIV TO % PERCENTAGE OF [BILLED]
-- SELECT [EQUIV_allow_rate] = case 
SET [EQUIV_allow_rate] = .15*[BILLED_AMT]
,[EQUIV_allow_compare] = .15*[BILLED_AMT]
WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ... AND ...
	AND [EQUIV_allow_rate] IS NULL
	-- AND formtype LIKE '%UB%' -- FACILITY
	-- AND su.formtype LIKE '%1500%' -- PROFESSIONAL */
	






-- =======================================================================
	-- CONTRACTING SUMMARY ANALYSIS (WITH ZERO HANDLING) -- 
-- =======================================================================
SELECT 'CONTRACTING PROPOSAL DEVELOPMENT: ' AS [Scenario]
,claimid,claimline
,LINE_OF_BUSINESS
,ISNULL(LINE_OF_BUSINESS,'')+' '+ISNULL([Primary / Secondary Status],'') AS 'LOB'
,PAYTONM
,memid
,revcode
,[REVCDE Descr]
,[HCT LOGIC DAY(S)]
,QUANTITY
,BILLED_AMT
,ALLOWED_AMT
,NET_AMT
,PAID_NET_AMT AS 'Actual_Payment'
,CASE -- Category assignment based on rev codes and LOB
WHEN revcode IN ('0022')
THEN 'PDPM Base Rate'
WHEN revcode IN ('0169')
THEN 'Bariatric'
WHEN revcode IN ('0119')
THEN 'Isolation'
WHEN revcode IN ('0559')
THEN 'Sitter Services'
WHEN revcode IN ('0258')
THEN 'TPN and Supplies'
ELSE 'Other Services' -- DEFAULT CATCH - ALL
END AS 'Contracting_Proposal_Category'
,NULLIF(PAID_NET_AMT,0) * 1.00 AS 'Current_Calc_Rate_Payment' -- ASSUME THAT WHAT HAS BEEN PAID IS WHATTHE CONTRACTING DEPT. HAS DOCUMENTED
,CASE -- Proposed payment calculation (100% of PDPM for base rate, same specific amounts for carveouts)
WHEN revcode IN ('0022')
THEN (NULLIF(PAID_NET_AMT,0) / 0.75) -- 100% of PDPM (assuming current is at 75%) Fx - FORMULA
WHEN revcode IN ('0169')
THEN NULLIF([HCT LOGIC DAY(S)],0) * 250 -- Bariatric per Diem RATE - CARVEOUT
WHEN revcode IN ('0119')
THEN NULLIF([HCT LOGIC DAY(S)],0) * 200 -- Isolation per Diem RATE - CARVEOUT
WHEN revcode IN ('0559')
THEN NULLIF([HCT LOGIC DAY(S)],0) * 200 -- Sitter Services per Diem RATE - CARVEOUT
WHEN revcode IN ('0258')
-- THEN NULLIF(PAID_NET_AMT,0) -- TPN and Supplies (AWP: Average Wholesale Price) ??? WHICH SCHEDULE - CARVEOUT
THEN NULLIF(EQUIV_allow_compare,0) * 1.00 -- TPN and Supplies (AWP: Average Wholesale Price) ??? WHICH SCHEDULE / 100% OF MEDI_CAL medicaid??? - CARVEOUT
ELSE 0 -- NO NOT NEGATIVE <> !+ PROPOSAL GIVEN FOR DEFAULT CATCH - ALL
END AS 'Proposed_Rate_Payment'
,CASE -- Counter offer calculation (80% of PDPM for base rate, same specific amounts for carveouts)
WHEN revcode IN ('0022','0169','0119','0559','0258')
THEN (NULLIF(PAID_NET_AMT,0) / 0.75) * 0.80 -- 80% of PDPM
ELSE  (NULLIF(PAID_NET_AMT,0) / 0.75) * 0.80 -- 80% of PDPM ...DEFAULT COUNTER CATCH-ALL SAME AS CURRENT???
END AS 'Counter_Offer_Payment'
INTO #ContractAnalysis
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st',[LOB],LINE_OF_BUSINESS
FROM INFORMATICS.dbo.CONTRACTING_ROCKPORT
WHERE 1=1
	AND [ClaimCategory] IN ('Paid') -- PAID CLAIMS ONLY!!!
    -- AND LINE_OF_BUSINESS LIKE '%MEDI%CAL%'
	-- AND [Primary / Secondary Status] = 'P'
	AND NULLIF(PAID_NET_AMT,0) != 0 -- APPLES TO APPLES PAID LINES ONLY!

	-- Check for DUP(s) --
SELECT ' ' AS 'SHOULD BE NULL DUP Validation',*
-- DELETE
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st',
FROM INFORMATICS.dbo.CONTRACTING_ROCKPORT
WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ... AND ...
	AND [DupID] IN
	( -- INITIATE ...
	SELECT [DupID]
	FROM INFORMATICS.dbo.CONTRACTING_ROCKPORT AS dup
	GROUP BY [DupID] -- Duplication Driver 
	HAVING COUNT(1)>1 -- HAVING clause RESERVED for AGGREGATE(s) ... HAVING SUM(PAID_NET_AMT) != 0
	) -- CONCLUDE ...

SELECT ' ' AS 'TEMPLATE: NEW JAG SUMMARY',LINE_OF_BUSINESS,
COUNT(DISTINCT(memid)) AS 'Unduplicated Members,',
SUM([HCT LOGIC DAY(S)]) AS Total_Days,
SUM(QUANTITY) AS [Total_Units],
SUM(BILLED_AMT) AS Total_Billed,
SUM(Actual_Payment) AS Actual_Payment_Total,
SUM(Current_Calc_Rate_Payment) AS Current_Rate_Total,
SUM(Proposed_Rate_Payment) AS Proposed_Rate_Total,
SUM(Counter_Offer_Payment) AS Counter_Offer_Total,
CASE 
WHEN SUM(Current_Calc_Rate_Payment) = 0 
THEN 'N/A'
ELSE TRY_CONVERT(nvarchar(255),TRY_CONVERT(decimal(9,3),((SUM(Proposed_Rate_Payment) / NULLIF(SUM(Current_Calc_Rate_Payment), 0)) - 1) * 100)) + '%'
END AS Overall_Proposed_Impact,
CASE 
WHEN SUM(Current_Calc_Rate_Payment) = 0 
THEN 'N/A'
ELSE TRY_CONVERT(nvarchar(255),TRY_CONVERT(decimal(9,3),((SUM(Counter_Offer_Payment) / NULLIF(SUM(Current_Calc_Rate_Payment), 0)) - 1) * 100)) + '%'
END AS Overall_Counter_Impact
FROM #ContractAnalysis
WHERE 1=1
	AND [Contracting_Proposal_Category] NOT IN ('Other Services') -- NO NOT NEGATIVE <> != THE 'DEFAULT CATCH - ALL'
GROUP BY LINE_OF_BUSINESS;

SELECT ' ' AS 'TEMPLATE: BY [Contracting_Proposal_Category] WITH DYNAMIC COUNTER % Summary',
PAYTONM AS [Pay To Provider],
[LOB],
[Contracting_Proposal_Category] AS 'Category',
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
ORDER BY PAYTONM,[Contracting_Proposal_Category];

SELECT ' ' AS 'TEMPLATE: BY [Pay To Provider] WITH DYNAMIC COUNTER % Summary',
PAYTONM AS [Pay To Provider],
[LOB],
COUNT(DISTINCT memid) AS [Total Unique Members],
SUM(Actual_Payment) AS [Actual Amount Paid],
SUM(CASE WHEN ISNULL([HCT LOGIC DAY(S)],0) = 0 THEN ISNULL(QUANTITY,0) ELSE ISNULL([HCT LOGIC DAY(S)],0) END) AS [Days / Units],
SUM(Proposed_Rate_Payment) AS [Proposed Total Paid]
FROM #ContractAnalysis
WHERE 1=1
	AND [Contracting_Proposal_Category] NOT IN ('Other Services') -- NO NOT NEGATIVE <> != THE 'DEFAULT CATCH - ALL'
GROUP BY PAYTONM,LOB
ORDER BY PAYTONM;

SELECT ' ' AS 'TEMPLATE: FULL Summary BY CPT / Revenue Code with ZERO Handling',
PAYTONM AS [Pay To Provider],
[LOB],
revcode,
[REVCDE Descr] AS [Revcode Description],
COUNT(DISTINCT memid) AS [Number of Members],
COUNT(DISTINCT claimid) AS [Number of Claims],
SUM(CASE WHEN ISNULL([HCT LOGIC DAY(S)],0) = 0 THEN ISNULL(QUANTITY,0) ELSE ISNULL([HCT LOGIC DAY(S)],0) END) AS [Days / Units],
SUM(Actual_Payment) AS [CHG Total Paid],
SUM(Proposed_Rate_Payment) AS [Proposed Total Paid],
(SUM(Proposed_Rate_Payment) - NULLIF(SUM(Actual_Payment), 0)) AS [Dollar Difference between CHG Total Paid and Proposed Total Paid],
CASE 
WHEN SUM(Current_Calc_Rate_Payment) = 0 
THEN 'N/A'
ELSE TRY_CONVERT(nvarchar(255),TRY_CONVERT(decimal(9,3),((SUM(Proposed_Rate_Payment) / NULLIF(SUM(Actual_Payment), 0)) - 1) * 100)) + '%' 
END AS [Percent Difference between CHG Total Paid and Proposed Total Paid],
[Contracting_Proposal_Category]
FROM #ContractAnalysis
WHERE 1=1
	AND [Contracting_Proposal_Category] NOT IN ('Other Services') -- NO NOT NEGATIVE <> != THE 'DEFAULT CATCH - ALL'
GROUP BY PAYTONM,[LOB],revcode,[REVCDE Descr],[Contracting_Proposal_Category]
ORDER BY [Contracting_Proposal_Category],revcode;

 -- =======================================================================
	-- CONTRACTING CXO EXECUTIVE SUMMARY: -- 
-- =======================================================================
		/* ⏎  'SAMPLE CXO EXCUTIVE SUMMARY': ie. eg.
		
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

-- =======================================================================
	-- CONTRACTING DETAIL --
-- =======================================================================
SELECT [TimeStamp] AS [Report Run date time]
,TRY_CONVERT(date,SUBSTRING([RANGE NOTE(S)],21,10)) AS [time period start date]
,TRY_CONVERT(date,SUBSTRING([RANGE NOTE(S)],36,10)) AS [time period end date]
,LINE_OF_BUSINESS AS [LOB]
,[Primary / Secondary Status] AS [plan position]
,ISNULL(LINE_OF_BUSINESS,'')+' '+ISNULL([Primary / Secondary Status],'') AS [plan position status]
,dosfrom AS [dos from]
,claimid
,claimline AS [claim line]
,HEADERstatus AS [claim status]
,QUANTITY AS [Units adj]
,PAID_NET_AMT AS [claim line amt paid]
,BILLED_AMT AS [claim line billed amt]
,TOTAL_BILLED_AMT AS [total billed amt]
,ClmType AS [Claim Type]
,HEADERstatus AS [claim header status]
,[CHECK DATE] AS [claim paid date]
,memid
,MEMNM AS [member name]
,QNXTbilltype AS [Bill Type]
,BillTypeDescr AS [Bill Type Descr]
,[CPT Service Code] AS [CPT]
,[Service Description] AS [cpt description]
,revcode
,[REVCDE Descr] AS [revcode description]
,[HCT LOGIC DAY(S)] AS [hct day logic]
,[Modifier Discount]
,EQUIV_ALLOW_RATE AS [Fee Schedule Rate]
,finaldrg
,modcode
,modcode2
,modcode3
,modcode4
,modcode5
,provid AS [rendering provider id]
,NPIprovnm AS [rendering provider npi]
,TRY_CONVERT(nvarchar(25),NULL) AS [Rendering provider fedid]
,PROVNM AS [rendering provider name]
,PAYTO AS [payto provider id]
,NPIpayto AS [payto provider npi]
,TRY_CONVERT(nvarchar(25),NULL) AS [payto provider fedid]
,PAYTONM AS [payto provider name]
,TRY_CONVERT(nvarchar(255),NULL) AS [claim inclusion reason]
,contractid
,[CONTRACT DESCRIPTION]
,TRY_CONVERT(nvarchar(255),NULL) AS [actual paid per unit]
,TRY_CONVERT(nvarchar(255),NULL) AS [medi cal allowed rate]
,TRY_CONVERT(nvarchar(255),NULL) AS [medicare allowed rate]
,TRY_CONVERT(nvarchar(255),NULL) AS [asc allowed rate]
,TRY_CONVERT(nvarchar(255),NULL) AS [custom rate proposed amt paid]
,TRY_CONVERT(nvarchar(255),NULL) AS [custom rate type]
,TRY_CONVERT(nvarchar(255),NULL) AS [custom rate]
,CASE -- Category assignment based on rev codes and LOB
WHEN revcode IN ('0022')
THEN 'PDPM Base Rate'
WHEN revcode IN ('0169')
THEN 'Bariatric'
WHEN revcode IN ('0119')
THEN 'Isolation'
WHEN revcode IN ('0559')
THEN 'Sitter Services'
WHEN revcode IN ('0258')
THEN 'TPN and Supplies'
ELSE 'Other Services' -- DEFAULT CATCH - ALL
END AS 'Contracting_Proposal_Category'
,CASE -- Proposed payment calculation (100% of PDPM for base rate, same specific amounts for carveouts)
WHEN revcode IN ('0022')
THEN (NULLIF(PAID_NET_AMT,0) / 0.75) -- 100% of PDPM (assuming current is at 75%) Fx - FORMULA
WHEN revcode IN ('0169')
THEN NULLIF([HCT LOGIC DAY(S)],0) * 250 -- Bariatric per Diem RATE - CARVEOUT
WHEN revcode IN ('0119')
THEN NULLIF([HCT LOGIC DAY(S)],0) * 200 -- Isolation per Diem RATE - CARVEOUT
WHEN revcode IN ('0559')
THEN NULLIF([HCT LOGIC DAY(S)],0) * 200 -- Sitter Services per Diem RATE - CARVEOUT
WHEN revcode IN ('0258')
-- THEN NULLIF(PAID_NET_AMT,0) -- TPN and Supplies (AWP: Average Wholesale Price) ??? WHICH SCHEDULE - CARVEOUT
THEN NULLIF(EQUIV_allow_compare,0) * 1.00 -- TPN and Supplies (AWP: Average Wholesale Price) ??? WHICH SCHEDULE / 100% OF MEDI_CAL medicaid??? - CARVEOUT
ELSE 0 -- NO NOT NEGATIVE <> !+ PROPOSAL GIVEN FOR DEFAULT CATCH - ALL
END AS 'Proposed_Rate_Payment'
,CASE -- Counter offer calculation (80% of PDPM for base rate, same specific amounts for carveouts)
WHEN revcode IN ('0022','0169','0119','0559','0258')
THEN (NULLIF(PAID_NET_AMT,0) / 0.75) * 0.80 -- 80% of PDPM
ELSE  (NULLIF(PAID_NET_AMT,0) / 0.75) * 0.80 -- 80% of PDPM ...DEFAULT COUNTER CATCH-ALL SAME AS CURRENT???
END AS 'Counter_Offer_Payment'
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM INFORMATICS.dbo.CONTRACTING_ROCKPORT
WHERE 1=1
	AND [ClaimCategory] IN ('Paid') -- PAID CLAIMS ONLY!!!
    -- AND LINE_OF_BUSINESS LIKE '%MEDI%CAL%'
	-- AND [Primary / Secondary Status] = 'P'
	AND NULLIF(PAID_NET_AMT,0) != 0 -- APPLES TO APPLES PAID LINES ONLY!







-- =============================================================
	-- PROVIDER CONTRACT : FEE SCHEDULE ISO --
-- =============================================================
SELECT DISTINCT ' ' AS 'SPECIAL CONTRACTING PROPOSAL CONTRACT / FEE SCHEDULE'
,ci.feeid,ci.networkid
,cd.termid
,con.description AS [Contract Descr]
,ct.description AS [ContractTerm Descr]
,a.provid
,p1.fullname AS [Rendering Provider]
,a.affiliateid
,p2.fullname AS [PayTo Provider]
-- SELECT TOP 10 ' ' AS 'CHECK 1st',cr.* -- ,ct.*,ct.longdescription -- ,con.*,ct.*
-- SELECT DISTINCT ' ' AS 'CHECK 1st',ft.feetableid,ft.locationcode,sf.feetype,sf.description,ft.category,CAST(ct.longdescription AS nvarchar(2000)) AS [Descr]
 FROM HMOPROD_PLANDATA.dbo.contract AS con
	JOIN HMOPROD_PLANDATA.dbo.contractinfo AS ci ON con.contractid = ci.contractid
	JOIN HMOPROD_PLANDATA.dbo.contractterm AS ct ON con.contractid = ct.contractid
	JOIN HMOPROD_PLANDATA.dbo.claimdetail AS cd ON ct.contractid = cd.contractid
		AND ct.termid = cd.termid
	JOIN HMOPROD_PLANDATA.dbo.claim AS clm ON cd.claimid = clm.claimid

		LEFT JOIN HMOPROD_PLANDATA.dbo.contractregion AS cr ON con.contractid = cr.contractid
		LEFT JOIN HMOPROD_PLANDATA.dbo.affiliation AS a ON clm.affiliationid = a.affiliationid -- REMINDER: within claim(s) tables AFFILIATIONID is the relationship between the a.provid = PROVIDER AND the a.affiliateid = PAYTO aka VENDOR
		LEFT JOIN HMOPROD_PLANDATA.dbo.provider AS p1 ON a.provid = p1.provid -- [RENDERING]
		LEFT JOIN HMOPROD_PLANDATA.dbo.provider AS p2 ON a.affiliateid = p2.provid -- [PAYTO] (IPAID)

WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ... AND ...
	AND a.provid IN ('2458') -- TESTING / SAMPLE
	AND a.affiliateid IN ('201700') -- SYNERGY SPECIALISTS MEDICAL GROUP (Org NPI: 1114282779 TIN: 455215138) 		-- Line of Business: Medi-Cal Only (not negotiating Medicare LOB IN this request) 		-- Target Due Date: Wed 01/24/24







--------------------------------------------------------------------------------------------------------------------
	--Error Trapping: Check If Permanent Table(s) Already Exist(s) And Drop If Applicable--
--------------------------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS INFORMATICS.dbo.FINAL_CONTRACTING_SUMMARY_KINDRED -- SQL Server 2016 and later -- DYNAMIC tmp OR STATIC [TABLE] #INFORMATICS.dbo.CONTRACTING_KINDREDHOSP is a local temporary table visible only IN the current session; ##INFORMATICS.dbo.CONTRACTING_KINDREDHOSP is a GLOBAL temporary table visible to all sessions IN ('TempDB')

SELECT ' ' AS 'SUMMARY: Proposal Unit(s) + Cost',los.* -- ... large claims costs for hospital inpatient stays => than 30 days
INTO INFORMATICS.dbo.FINAL_CONTRACTING_SUMMARY_KINDRED
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM 
( -- INITIATE ...
SELECT aa.Cx AS [Category of Service],aa.PROVNM,DATEPART(year,aa.DOS) AS YOS
,COUNT(DISTINCT(memid)) AS [UNIQUE UTILZERS]
,COUNT(DISTINCT([Index AdmitID])) AS [INDEX ADMIT(S) / VISIT(S)] -- USING [Index AdmitID] ENABLES TRACKING OF [CONSECUTIVE] DAY(S)
,COUNT(DISTINCT(p.[AdmitID])) AS [ADMIT(S) / VISIT(S)] -- USING [Index AdmitID] ENABLES TRACKING OF [CONSECUTIVE] DAY(S)
,SUM([CALENDAR DAY(S)]) AS [CALENDAR DAY(S)]
,SUM([CALENDAR DAY(S) minus END / DISCHARGE date]) AS [CALENDAR DAY(S) minus END / DISCHARGE date]
,SUM([DATEDIFF DAY(S)]) AS [DATEDIFF DAY(S)]
,SUM([WORK DAY(S)]) AS [WORK DAY(S)]
,SUM([HCT LOGIC DAY(S)]) AS [HCT LOGIC DAY(S)]
,SUM(p.PAID) AS [PAID]
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM #AdmitAssessment AS aa
	JOIN 
	( -- INITIATE ...
	SELECT AdmitID,SUM(PAID_NET_AMT) AS [Paid]
	FROM #AdmitSetup
	GROUP BY AdmitID
	) -- CONCLUDE ...
	AS p ON aa.AdmitID = p.AdmitID
GROUP BY aa.Cx,aa.PROVNM,DATEPART(year,aa.DOS)
) -- CONCLUDE ...
AS los

		SELECT * FROM INFORMATICS.dbo.FINAL_CONTRACTING_SUMMARY_KINDRED AS s

SELECT ' ' AS 'Present CHGSD Contract v Proposal',math.PROVNM AS [Provider],math.YOS,math.[HCT LOGIC DAY(S)] AS [Days],math.[Paid]
,[Year 1 February 2024],[Year 1 Rate Proposal Cost],[Year 1 % Variance] = TRY_CONVERT(nvarchar(255),TRY_CONVERT(decimal(9,3),([Year 1 Rate Proposal Cost]-math.[Paid])*100.000/NULLIF((math.[Paid]),0)*1.000)) +'%' -- NESTED WITH() SYMBOL' ... DO NOT NO NEGATIVE <> != DIVIDE BY ZERO (0)
,[Year 2 February 2025],[Year 2 Rate Proposal Cost],[Year 2 % Variance] = TRY_CONVERT(nvarchar(255),TRY_CONVERT(decimal(9,3),([Year 2 Rate Proposal Cost]-math.[Paid])*100.000/NULLIF((math.[Paid]),0)*1.000)) +'%' -- NESTED WITH() SYMBOL' ... DO NOT NO NEGATIVE <> != DIVIDE BY ZERO (0)
,[Year 3 February 2026],[Year 3 Rate Proposal Cost],[Year 3 % Variance] = TRY_CONVERT(nvarchar(255),TRY_CONVERT(decimal(9,3),([Year 3 Rate Proposal Cost]-math.[Paid])*100.000/NULLIF((math.[Paid]),0)*1.000)) +'%' -- NESTED WITH() SYMBOL' ... DO NOT NO NEGATIVE <> != DIVIDE BY ZERO (0)
FROM 
( -- INITIATE ...
SELECT s.*
,TRY_CONVERT(nvarchar(255),'$2,434 per diem') AS [Year 1 February 2024]
,TRY_CONVERT(decimal(9,2),(2434*[HCT LOGIC DAY(S)])) AS [Year 1 Rate Proposal Cost]
,TRY_CONVERT(nvarchar(255),'$2,507 per diem') AS [Year 2 February 2025]
,TRY_CONVERT(decimal(9,2),(2507*[HCT LOGIC DAY(S)])) AS [Year 2 Rate Proposal Cost]
,TRY_CONVERT(nvarchar(255),'$2,583 per diem') AS [Year 3 February 2026]
,TRY_CONVERT(decimal(9,2),(2583*[HCT LOGIC DAY(S)])) AS [Year 3 Rate Proposal Cost]
FROM INFORMATICS.dbo.FINAL_CONTRACTING_SUMMARY_KINDRED AS s
) -- CONCLUDE ...
AS math

 SELECT ' ' AS 'Proposal Yr Over Yr Comp',math.PROVNM AS [Provider]
,[Year 1 February 2024],[Year 1 Rate Proposal Cost]
,[Year 2 February 2025],[Year 2 Rate Proposal Cost],[Year 1 v Year 2 % Variance] = TRY_CONVERT(nvarchar(255),TRY_CONVERT(decimal(9,3),(([Year 2 Rate Proposal Cost]-[Year 1 Rate Proposal Cost])*100.000)/(NULLIF(CAST([Year 1 Rate Proposal Cost] AS money),0)*1.000))) +'%' -- NESTED WITH() SYMBOL' ... DO NOT NO NEGATIVE <> != DIVIDE BY ZERO (0)
,[Year 3 February 2026],[Year 3 Rate Proposal Cost],[Year 2 v Year 3 % Variance] = TRY_CONVERT(nvarchar(255),TRY_CONVERT(decimal(9,3),(([Year 3 Rate Proposal Cost]-[Year 2 Rate Proposal Cost])*100.000)/(NULLIF(CAST([Year 2 Rate Proposal Cost] AS money),0)*1.000))) +'%' -- NESTED WITH() SYMBOL' ... DO NOT NO NEGATIVE <> != DIVIDE BY ZERO (0)
FROM 
( -- INITIATE ...
SELECT s.*
,TRY_CONVERT(nvarchar(255),'$2,434 per diem') AS [Year 1 February 2024]
,TRY_CONVERT(decimal(9,2),(2434*[HCT LOGIC DAY(S)])) AS [Year 1 Rate Proposal Cost]
,TRY_CONVERT(nvarchar(255),'$2,507 per diem') AS [Year 2 February 2025]
,TRY_CONVERT(decimal(9,2),(2507*[HCT LOGIC DAY(S)])) AS [Year 2 Rate Proposal Cost]
,TRY_CONVERT(nvarchar(255),'$2,583 per diem') AS [Year 3 February 2026]
,TRY_CONVERT(decimal(9,2),(2583*[HCT LOGIC DAY(S)])) AS [Year 3 Rate Proposal Cost]
FROM INFORMATICS.dbo.FINAL_CONTRACTING_SUMMARY_KINDRED AS s
) -- CONCLUDE ...
AS math







-- =========================================================
	-- WWCII alt. FEE SCHEDULE(s) REVIEW()  / EQUIVALENT --
-- =========================================================
UPDATE TABLENAME
SET [EQUIV_allow_rate] = CAST(NULL AS money)
,[EQUIV_allow_compare] = CAST(NULL AS money)

UPDATE TABLENAME
SET [EQUIV_allow_rate] = equiv.feeamount
,[EQUIV_allow_compare] = equiv.feeamount*su.QUANTITY*[Modifier Discount]
 -- SELECT su.[CPT Service Code],su.modcode,su.modcode2,su.Location,equiv.LocationCode,equiv.feeamount,su.QUANTITY,[???_allow_compare] = equiv.feeamount*su.QUANTITY,su.PAID_NET_AMT,*-- CHECK 1st
-- SELECT DISTINCT [FEE SCHEDULE] -- CHECK 1st
FROM TABLENAME AS su
	JOIN 
	( -- INITIATE ...
SELECT 'MCAL v MCARE v ??? ... Equivalent Rate ... USE https://duckduckgo.com/?q=Hospital+OP+PPS+pricer&t=h_ - CHARINDEX() FIND() SEARCH() "Hospital OP PPS pricer"' AS [NOTE(S)],*
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT feetableid,[FEE SCHEDULE] -- CHECK 1st
FROM 
( -- INITIATE ...
SELECT DISTINCT @whensf AS [EST BASELINE effdate],ft.effdate,ft.termdate
,RANK() OVER (PARTITION BY sf.description ORDER BY CAST(ft.effdate AS date) DESC) AS [RANKis]
,ft.feetableid,sf.description AS [FEE SCHEDULE],ft.category,ft.mincodeid,ft.maxcodeid,ft.modcode,ft.ModCode2,ft.locationcode,ft.feeamount -- ,sf.*,ft.*
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ft.feetableid,ft.locationcode,sf.feetype,sf.description,ft.category -- CHECK 1st
FROM HMOPROD_PLANDATA.dbo.standardfee AS sf
	JOIN HMOPROD_PLANDATA.dbo.feetable AS ft ON sf.feeid = ft.feetableid
-- WHERE ft.feetableid IN ('C00740459','C01011396','C01011395','C00727442')
-- WHERE ft.category LIKE '%RU%'	
WHERE UPPER(LTRIM(RTRIM(ISNULL(sf.feeid,'')))) LIKE @schedid -- DEFINE / SELECT DESIRED SCHEDULE
	-- AND CAST(ISNULL(ft.effdate,CAST(GETDATE() AS date)) AS date) >= @whensf -- AS OF ...
	AND CAST(ISNULL(ft.termdate,CAST(GETDATE() AS date)) AS date) >= @dt
	-- AND sf.description LIKE @feeschedulename
) -- CONCLUDE ...
AS equiv
WHERE equiv.[RANKis] = 1
	AND ( -- INITIATE ...
	-- equiv.[FEE SCHEDULE] LIKE '%0%MCAL%UCR%' -- 'MediCal':  0 PHYS MCAL UCR FEE TABLE for the Medi-Cal rates.
	equiv.feetableid IN ('C00740459') -- SAMPLE FROM [CONTRACTING AWPvMCALvASP_...rar] USE 'C00740459' AS AWP % FEE SCHEDULE
		) -- CONCLUDE ...
	) -- CONCLUDE ... 
	AS equiv ON su.[CPT Service Code] = SUBSTRING(UPPER(LTRIM(RTRIM(ISNULL(equiv.mincodeid,'')))),1,5)
		AND UPPER(LTRIM(RTRIM(ISNULL(su.modcode,'')))) = UPPER(LTRIM(RTRIM(ISNULL(equiv.modcode,''))))
		AND UPPER(LTRIM(RTRIM(ISNULL(su.modcode2,'')))) = UPPER(LTRIM(RTRIM(ISNULL(equiv.modcode2,''))))
		AND UPPER(LTRIM(RTRIM(ISNULL(su.Location,'')))) = UPPER(LTRIM(RTRIM(ISNULL(equiv.LocationCode,''))))
WHERE [EQUIV_allow_rate] IS NULL

UPDATE TABLENAME
SET [EQUIV_allow_rate] = equiv.feeamount
,[EQUIV_allow_compare] = equiv.feeamount*su.QUANTITY*[Modifier Discount]
 -- SELECT su.[CPT Service Code],su.modcode,su.modcode2,su.Location,equiv.LocationCode,equiv.feeamount,su.QUANTITY,[???_allow_compare] = equiv.feeamount*su.QUANTITY,su.PAID_NET_AMT,*-- CHECK 1st
-- SELECT DISTINCT [FEE SCHEDULE] -- -- CHECK 1st
FROM TABLENAME AS su
	JOIN 
	( -- INITIATE ...
SELECT 'MCAL v MCARE v ??? ... Equivalent Rate ... USE https://duckduckgo.com/?q=Hospital+OP+PPS+pricer&t=h_ - CHARINDEX() FIND() SEARCH() "Hospital OP PPS pricer"' AS [NOTE(S)],*
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT feetableid,[FEE SCHEDULE] -- CHECK 1st
FROM 
( -- INITIATE ...
SELECT DISTINCT @whensf AS [EST BASELINE effdate],ft.effdate,ft.termdate
,RANK() OVER (PARTITION BY sf.description ORDER BY CAST(ft.effdate AS date) DESC) AS [RANKis]
,ft.feetableid,sf.description AS [FEE SCHEDULE],ft.category,ft.mincodeid,ft.maxcodeid,ft.modcode,ft.ModCode2,ft.locationcode,ft.feeamount -- ,sf.*,ft.*
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ft.feetableid,ft.locationcode,sf.feetype,sf.description,ft.category -- CHECK 1st
FROM HMOPROD_PLANDATA.dbo.standardfee AS sf
	JOIN HMOPROD_PLANDATA.dbo.feetable AS ft ON sf.feeid = ft.feetableid
-- WHERE ft.feetableid IN ('C00740459','C01011396','C01011395','C00727442')
-- WHERE ft.category LIKE '%RU%'	
WHERE UPPER(LTRIM(RTRIM(ISNULL(sf.feeid,'')))) LIKE @schedid -- DEFINE / SELECT DESIRED SCHEDULE
	-- AND CAST(ISNULL(ft.effdate,CAST(GETDATE() AS date)) AS date) >= @whensf -- AS OF ...
	AND CAST(ISNULL(ft.termdate,CAST(GETDATE() AS date)) AS date) >= @dt
	-- AND sf.description LIKE @feeschedulename
) -- CONCLUDE ...
AS equiv
WHERE equiv.[RANKis] = 1
	AND ( -- INITIATE ...
	-- equiv.[FEE SCHEDULE] LIKE '%0%MCAL%UCR%' -- 'MediCal':  0 PHYS MCAL UCR FEE TABLE for the Medi-Cal rates.
	equiv.feetableid IN ('C00740459') -- SAMPLE FROM [CONTRACTING AWPvMCALvASP_...rar] USE 'C00740459' AS AWP % FEE SCHEDULE
		) -- CONCLUDE ...
	) -- CONCLUDE ... 
	AS equiv ON su.[CPT Service Code] = SUBSTRING(UPPER(LTRIM(RTRIM(ISNULL(equiv.mincodeid,'')))),1,5)
		AND UPPER(LTRIM(RTRIM(ISNULL(su.modcode,'')))) = UPPER(LTRIM(RTRIM(ISNULL(equiv.modcode,''))))
		AND UPPER(LTRIM(RTRIM(ISNULL(su.modcode2,'')))) = UPPER(LTRIM(RTRIM(ISNULL(equiv.modcode2,''))))
WHERE [EQUIV_allow_rate] IS NULL

UPDATE TABLENAME
SET [EQUIV_allow_rate] = equiv.feeamount
,[EQUIV_allow_compare] = equiv.feeamount*su.QUANTITY*[Modifier Discount]
 -- SELECT su.[CPT Service Code],su.modcode,su.modcode2,su.Location,equiv.LocationCode,equiv.feeamount,su.QUANTITY,[???_allow_compare] = equiv.feeamount*su.QUANTITY,su.PAID_NET_AMT,*-- CHECK 1st
-- SELECT DISTINCT [FEE SCHEDULE] -- -- CHECK 1st
FROM TABLENAME AS su
	JOIN 
	( -- INITIATE ...
SELECT 'MCAL v MCARE v ??? ... Equivalent Rate ... USE https://duckduckgo.com/?q=Hospital+OP+PPS+pricer&t=h_ - CHARINDEX() FIND() SEARCH() "Hospital OP PPS pricer"' AS [NOTE(S)],*
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT feetableid,[FEE SCHEDULE] -- CHECK 1st
FROM 
( -- INITIATE ...
SELECT DISTINCT @whensf AS [EST BASELINE effdate],ft.effdate,ft.termdate
,RANK() OVER (PARTITION BY sf.description ORDER BY CAST(ft.effdate AS date) DESC) AS [RANKis]
,ft.feetableid,sf.description AS [FEE SCHEDULE],ft.category,ft.mincodeid,ft.maxcodeid,ft.modcode,ft.ModCode2,ft.locationcode,ft.feeamount -- ,sf.*,ft.*
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ft.feetableid,ft.locationcode,sf.feetype,sf.description,ft.category -- CHECK 1st
FROM HMOPROD_PLANDATA.dbo.standardfee AS sf
	JOIN HMOPROD_PLANDATA.dbo.feetable AS ft ON sf.feeid = ft.feetableid
-- WHERE ft.feetableid IN ('C00740459','C01011396','C01011395','C00727442')
-- WHERE ft.category LIKE '%RU%'	
WHERE UPPER(LTRIM(RTRIM(ISNULL(sf.feeid,'')))) LIKE @schedid -- DEFINE / SELECT DESIRED SCHEDULE
	-- AND CAST(ISNULL(ft.effdate,CAST(GETDATE() AS date)) AS date) >= @whensf -- AS OF ...
	AND CAST(ISNULL(ft.termdate,CAST(GETDATE() AS date)) AS date) >= @dt
	-- AND sf.description LIKE @feeschedulename
) -- CONCLUDE ...
AS equiv
WHERE equiv.[RANKis] = 1
	AND ( -- INITIATE ...
	-- equiv.[FEE SCHEDULE] LIKE '%0%MCAL%UCR%' -- 'MediCal':  0 PHYS MCAL UCR FEE TABLE for the Medi-Cal rates.
	equiv.feetableid IN ('C00740459') -- SAMPLE FROM [CONTRACTING AWPvMCALvASP_...rar] USE 'C00740459' AS AWP % FEE SCHEDULE
		) -- CONCLUDE ...
	) -- CONCLUDE ... 
	AS equiv ON su.[CPT Service Code] = SUBSTRING(UPPER(LTRIM(RTRIM(ISNULL(equiv.mincodeid,'')))),1,5)
		AND UPPER(LTRIM(RTRIM(ISNULL(su.modcode,'')))) = UPPER(LTRIM(RTRIM(ISNULL(equiv.modcode,''))))
WHERE [EQUIV_allow_rate] IS NULL

UPDATE TABLENAME
SET [EQUIV_allow_rate] = equiv.feeamount
,[EQUIV_allow_compare] = equiv.feeamount*su.QUANTITY*[Modifier Discount]
 -- SELECT su.[CPT Service Code],su.modcode,su.modcode2,su.Location,equiv.LocationCode,equiv.feeamount,su.QUANTITY,[???_allow_compare] = equiv.feeamount*su.QUANTITY,su.PAID_NET_AMT,*-- CHECK 1st
-- SELECT DISTINCT [FEE SCHEDULE] -- -- CHECK 1st
FROM TABLENAME AS su
	JOIN 
	( -- INITIATE ...
SELECT 'MCAL v MCARE v ??? ... Equivalent Rate ... USE https://duckduckgo.com/?q=Hospital+OP+PPS+pricer&t=h_ - CHARINDEX() FIND() SEARCH() "Hospital OP PPS pricer"' AS [NOTE(S)],*
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT feetableid,[FEE SCHEDULE] -- CHECK 1st
FROM 
( -- INITIATE ...
SELECT DISTINCT @whensf AS [EST BASELINE effdate],ft.effdate,ft.termdate
,RANK() OVER (PARTITION BY sf.description ORDER BY CAST(ft.effdate AS date) DESC) AS [RANKis]
,ft.feetableid,sf.description AS [FEE SCHEDULE],ft.category,ft.mincodeid,ft.maxcodeid,ft.modcode,ft.ModCode2,ft.locationcode,ft.feeamount -- ,sf.*,ft.*
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ft.feetableid,ft.locationcode,sf.feetype,sf.description,ft.category -- CHECK 1st
FROM HMOPROD_PLANDATA.dbo.standardfee AS sf
	JOIN HMOPROD_PLANDATA.dbo.feetable AS ft ON sf.feeid = ft.feetableid
-- WHERE ft.feetableid IN ('C00740459','C01011396','C01011395','C00727442')
-- WHERE ft.category LIKE '%RU%'	
WHERE UPPER(LTRIM(RTRIM(ISNULL(sf.feeid,'')))) LIKE @schedid -- DEFINE / SELECT DESIRED SCHEDULE
	-- AND CAST(ISNULL(ft.effdate,CAST(GETDATE() AS date)) AS date) >= @whensf -- AS OF ...
	AND CAST(ISNULL(ft.termdate,CAST(GETDATE() AS date)) AS date) >= @dt
	-- AND sf.description LIKE @feeschedulename
) -- CONCLUDE ...
AS equiv
WHERE equiv.[RANKis] = 1
	AND ( -- INITIATE ...
	-- equiv.[FEE SCHEDULE] LIKE '%0%MCAL%UCR%' -- 'MediCal':  0 PHYS MCAL UCR FEE TABLE for the Medi-Cal rates.
	equiv.feetableid IN ('C00740459') -- SAMPLE FROM [CONTRACTING AWPvMCALvASP_...rar] USE 'C00740459' AS AWP % FEE SCHEDULE
		) -- CONCLUDE ...
	) -- CONCLUDE ... 
	AS equiv ON su.[CPT Service Code] = SUBSTRING(UPPER(LTRIM(RTRIM(ISNULL(equiv.mincodeid,'')))),1,5)
		AND UPPER(LTRIM(RTRIM(ISNULL(su.modcode,'')))) = UPPER(LTRIM(RTRIM(ISNULL(equiv.modcode2,''))))
		AND UPPER(LTRIM(RTRIM(ISNULL(su.modcode2,'')))) = UPPER(LTRIM(RTRIM(ISNULL(equiv.modcode,''))))
		AND UPPER(LTRIM(RTRIM(ISNULL(su.Location,'')))) = UPPER(LTRIM(RTRIM(ISNULL(equiv.LocationCode,''))))
WHERE [EQUIV_allow_rate] IS NULL

UPDATE TABLENAME
SET [EQUIV_allow_rate] = equiv.feeamount
,[EQUIV_allow_compare] = equiv.feeamount*su.QUANTITY*[Modifier Discount]
 -- SELECT su.[CPT Service Code],su.modcode,su.modcode2,su.Location,equiv.LocationCode,equiv.feeamount,su.QUANTITY,[???_allow_compare] = equiv.feeamount*su.QUANTITY,su.PAID_NET_AMT,*-- CHECK 1st
-- SELECT DISTINCT [FEE SCHEDULE] -- -- CHECK 1st
FROM TABLENAME AS su
	JOIN 
	( -- INITIATE ...
SELECT 'MCAL v MCARE v ??? ... Equivalent Rate ... USE https://duckduckgo.com/?q=Hospital+OP+PPS+pricer&t=h_ - CHARINDEX() FIND() SEARCH() "Hospital OP PPS pricer"' AS [NOTE(S)],*
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT feetableid,[FEE SCHEDULE] -- CHECK 1st
FROM 
( -- INITIATE ...
SELECT DISTINCT @whensf AS [EST BASELINE effdate],ft.effdate,ft.termdate
,RANK() OVER (PARTITION BY sf.description ORDER BY CAST(ft.effdate AS date) DESC) AS [RANKis]
,ft.feetableid,sf.description AS [FEE SCHEDULE],ft.category,ft.mincodeid,ft.maxcodeid,ft.modcode,ft.ModCode2,ft.locationcode,ft.feeamount -- ,sf.*,ft.*
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ft.feetableid,ft.locationcode,sf.feetype,sf.description,ft.category -- CHECK 1st
FROM HMOPROD_PLANDATA.dbo.standardfee AS sf
	JOIN HMOPROD_PLANDATA.dbo.feetable AS ft ON sf.feeid = ft.feetableid
-- WHERE ft.feetableid IN ('C00740459','C01011396','C01011395','C00727442')
-- WHERE ft.category LIKE '%RU%'	
WHERE UPPER(LTRIM(RTRIM(ISNULL(sf.feeid,'')))) LIKE @schedid -- DEFINE / SELECT DESIRED SCHEDULE
	-- AND CAST(ISNULL(ft.effdate,CAST(GETDATE() AS date)) AS date) >= @whensf -- AS OF ...
	AND CAST(ISNULL(ft.termdate,CAST(GETDATE() AS date)) AS date) >= @dt
	-- AND sf.description LIKE @feeschedulename
) -- CONCLUDE ...
AS equiv
WHERE equiv.[RANKis] = 1
	AND ( -- INITIATE ...
	-- equiv.[FEE SCHEDULE] LIKE '%0%MCAL%UCR%' -- 'MediCal':  0 PHYS MCAL UCR FEE TABLE for the Medi-Cal rates.
	equiv.feetableid IN ('C00740459') -- SAMPLE FROM [CONTRACTING AWPvMCALvASP_...rar] USE 'C00740459' AS AWP % FEE SCHEDULE
		) -- CONCLUDE ...
	) -- CONCLUDE ... 
	AS equiv ON su.[CPT Service Code] = SUBSTRING(UPPER(LTRIM(RTRIM(ISNULL(equiv.mincodeid,'')))),1,5)
		AND UPPER(LTRIM(RTRIM(ISNULL(su.modcode,'')))) = UPPER(LTRIM(RTRIM(ISNULL(equiv.modcode2,''))))
		AND UPPER(LTRIM(RTRIM(ISNULL(su.modcode2,'')))) = UPPER(LTRIM(RTRIM(ISNULL(equiv.modcode,''))))
WHERE [EQUIV_allow_rate] IS NULL

UPDATE TABLENAME
SET [EQUIV_allow_rate] = equiv.feeamount
,[EQUIV_allow_compare] = equiv.feeamount*su.QUANTITY*[Modifier Discount]
 -- SELECT su.[CPT Service Code],su.modcode,su.modcode2,su.Location,equiv.LocationCode,equiv.feeamount,su.QUANTITY,[???_allow_compare] = equiv.feeamount*su.QUANTITY,su.PAID_NET_AMT,*-- CHECK 1st
-- SELECT DISTINCT [FEE SCHEDULE] -- -- CHECK 1st
FROM TABLENAME AS su
	JOIN 
	( -- INITIATE ...
SELECT 'MCAL v MCARE v ??? ... Equivalent Rate ... USE https://duckduckgo.com/?q=Hospital+OP+PPS+pricer&t=h_ - CHARINDEX() FIND() SEARCH() "Hospital OP PPS pricer"' AS [NOTE(S)],*
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT feetableid,[FEE SCHEDULE] -- CHECK 1st
FROM 
( -- INITIATE ...
SELECT DISTINCT @whensf AS [EST BASELINE effdate],ft.effdate,ft.termdate
,RANK() OVER (PARTITION BY sf.description ORDER BY CAST(ft.effdate AS date) DESC) AS [RANKis]
,ft.feetableid,sf.description AS [FEE SCHEDULE],ft.category,ft.mincodeid,ft.maxcodeid,ft.modcode,ft.ModCode2,ft.locationcode,ft.feeamount -- ,sf.*,ft.*
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ft.feetableid,ft.locationcode,sf.feetype,sf.description,ft.category -- CHECK 1st
FROM HMOPROD_PLANDATA.dbo.standardfee AS sf
	JOIN HMOPROD_PLANDATA.dbo.feetable AS ft ON sf.feeid = ft.feetableid
-- WHERE ft.feetableid IN ('C00740459','C01011396','C01011395','C00727442')
-- WHERE ft.category LIKE '%RU%'	
WHERE UPPER(LTRIM(RTRIM(ISNULL(sf.feeid,'')))) LIKE @schedid -- DEFINE / SELECT DESIRED SCHEDULE
	-- AND CAST(ISNULL(ft.effdate,CAST(GETDATE() AS date)) AS date) >= @whensf -- AS OF ...
	AND CAST(ISNULL(ft.termdate,CAST(GETDATE() AS date)) AS date) >= @dt
	-- AND sf.description LIKE @feeschedulename
) -- CONCLUDE ...
AS equiv
WHERE equiv.[RANKis] = 1
	AND ( -- INITIATE ...
	-- equiv.[FEE SCHEDULE] LIKE '%0%MCAL%UCR%' -- 'MediCal':  0 PHYS MCAL UCR FEE TABLE for the Medi-Cal rates.
	equiv.feetableid IN ('C00740459') -- SAMPLE FROM [CONTRACTING AWPvMCALvASP_...rar] USE 'C00740459' AS AWP % FEE SCHEDULE
		) -- CONCLUDE ...
	) -- CONCLUDE ... 
	AS equiv ON su.[CPT Service Code] = SUBSTRING(UPPER(LTRIM(RTRIM(ISNULL(equiv.mincodeid,'')))),1,5)
		AND UPPER(LTRIM(RTRIM(ISNULL(su.modcode,'')))) = UPPER(LTRIM(RTRIM(ISNULL(equiv.modcode2,''))))
WHERE [EQUIV_allow_rate] IS NULL

UPDATE TABLENAME
SET [EQUIV_allow_rate] = equiv.feeamount
,[EQUIV_allow_compare] = equiv.feeamount*su.QUANTITY*[Modifier Discount]
 -- SELECT su.[CPT Service Code],su.modcode,su.modcode2,su.Location,equiv.LocationCode,equiv.feeamount,su.QUANTITY,[???_allow_compare] = equiv.feeamount*su.QUANTITY,su.PAID_NET_AMT,*-- CHECK 1st
-- SELECT DISTINCT [FEE SCHEDULE] -- -- CHECK 1st
FROM TABLENAME AS su
	JOIN 
	( -- INITIATE ...
SELECT 'MCAL v MCARE v ??? ... Equivalent Rate ... USE https://duckduckgo.com/?q=Hospital+OP+PPS+pricer&t=h_ - CHARINDEX() FIND() SEARCH() "Hospital OP PPS pricer"' AS [NOTE(S)],*
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT feetableid,[FEE SCHEDULE] -- CHECK 1st
FROM 
( -- INITIATE ...
SELECT DISTINCT @whensf AS [EST BASELINE effdate],ft.effdate,ft.termdate
,RANK() OVER (PARTITION BY sf.description ORDER BY CAST(ft.effdate AS date) DESC) AS [RANKis]
,ft.feetableid,sf.description AS [FEE SCHEDULE],ft.category,ft.mincodeid,ft.maxcodeid,ft.modcode,ft.ModCode2,ft.locationcode,ft.feeamount -- ,sf.*,ft.*
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ft.feetableid,ft.locationcode,sf.feetype,sf.description,ft.category -- CHECK 1st
FROM HMOPROD_PLANDATA.dbo.standardfee AS sf
	JOIN HMOPROD_PLANDATA.dbo.feetable AS ft ON sf.feeid = ft.feetableid
-- WHERE ft.feetableid IN ('C00740459','C01011396','C01011395','C00727442')
-- WHERE ft.category LIKE '%RU%'	
WHERE UPPER(LTRIM(RTRIM(ISNULL(sf.feeid,'')))) LIKE @schedid -- DEFINE / SELECT DESIRED SCHEDULE
	-- AND CAST(ISNULL(ft.effdate,CAST(GETDATE() AS date)) AS date) >= @whensf -- AS OF ...
	AND CAST(ISNULL(ft.termdate,CAST(GETDATE() AS date)) AS date) >= @dt
	-- AND sf.description LIKE @feeschedulename
) -- CONCLUDE ...
AS equiv
WHERE equiv.[RANKis] = 1
	AND ( -- INITIATE ...
	-- equiv.[FEE SCHEDULE] LIKE '%0%MCAL%UCR%' -- 'MediCal':  0 PHYS MCAL UCR FEE TABLE for the Medi-Cal rates.
	equiv.feetableid IN ('C00740459') -- SAMPLE FROM [CONTRACTING AWPvMCALvASP_...rar] USE 'C00740459' AS AWP % FEE SCHEDULE
		) -- CONCLUDE ...
	) -- CONCLUDE ... 
	AS equiv ON su.[CPT Service Code] = SUBSTRING(UPPER(LTRIM(RTRIM(ISNULL(equiv.mincodeid,'')))),1,5)
		AND UPPER(LTRIM(RTRIM(ISNULL(su.Location,'')))) = UPPER(LTRIM(RTRIM(ISNULL(equiv.LocationCode,''))))
WHERE [EQUIV_allow_rate] IS NULL

UPDATE TABLENAME
SET [EQUIV_allow_rate] = equiv.feeamount
,[EQUIV_allow_compare] = equiv.feeamount*su.QUANTITY*[Modifier Discount]
 -- SELECT su.[CPT Service Code],su.modcode,su.modcode2,su.Location,equiv.LocationCode,equiv.feeamount,su.QUANTITY,[???_allow_compare] = equiv.feeamount*su.QUANTITY,su.PAID_NET_AMT,*-- CHECK 1st
-- SELECT DISTINCT [FEE SCHEDULE] -- -- CHECK 1st
FROM TABLENAME AS su
	JOIN 
	( -- INITIATE ...
SELECT 'MCAL v MCARE v ??? ... Equivalent Rate ... USE https://duckduckgo.com/?q=Hospital+OP+PPS+pricer&t=h_ - CHARINDEX() FIND() SEARCH() "Hospital OP PPS pricer"' AS [NOTE(S)],*
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT feetableid,[FEE SCHEDULE] -- CHECK 1st
FROM 
( -- INITIATE ...
SELECT DISTINCT @whensf AS [EST BASELINE effdate],ft.effdate,ft.termdate
,RANK() OVER (PARTITION BY sf.description ORDER BY CAST(ft.effdate AS date) DESC) AS [RANKis]
,ft.feetableid,sf.description AS [FEE SCHEDULE],ft.category,ft.mincodeid,ft.maxcodeid,ft.modcode,ft.ModCode2,ft.locationcode,ft.feeamount -- ,sf.*,ft.*
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ft.feetableid,ft.locationcode,sf.feetype,sf.description,ft.category -- CHECK 1st
FROM HMOPROD_PLANDATA.dbo.standardfee AS sf
	JOIN HMOPROD_PLANDATA.dbo.feetable AS ft ON sf.feeid = ft.feetableid
-- WHERE ft.feetableid IN ('C00740459','C01011396','C01011395','C00727442')
-- WHERE ft.category LIKE '%RU%'	
WHERE UPPER(LTRIM(RTRIM(ISNULL(sf.feeid,'')))) LIKE @schedid -- DEFINE / SELECT DESIRED SCHEDULE
	-- AND CAST(ISNULL(ft.effdate,CAST(GETDATE() AS date)) AS date) >= @whensf -- AS OF ...
	AND CAST(ISNULL(ft.termdate,CAST(GETDATE() AS date)) AS date) >= @dt
	-- AND sf.description LIKE @feeschedulename
) -- CONCLUDE ...
AS equiv
WHERE equiv.[RANKis] = 1
	AND ( -- INITIATE ...
	-- equiv.[FEE SCHEDULE] LIKE '%0%MCAL%UCR%' -- 'MediCal':  0 PHYS MCAL UCR FEE TABLE for the Medi-Cal rates.
	equiv.feetableid IN ('C00740459') -- SAMPLE FROM [CONTRACTING AWPvMCALvASP_...rar] USE 'C00740459' AS AWP % FEE SCHEDULE
		) -- CONCLUDE ...
	) -- CONCLUDE ... 
	AS equiv ON su.[CPT Service Code] = SUBSTRING(UPPER(LTRIM(RTRIM(ISNULL(equiv.mincodeid,'')))),1,5)
WHERE [EQUIV_allow_rate] IS NULL
		
		SELECT TOP 100 [CPT Service Code],[CPT Service Description],modcode,modcode2,Location,[EQUIV_allow_rate],'X' AS [by],QUANTITY,'X' AS [by],[Modifier Discount],'=' AS [EQUALS],[EQUIV_allow_compare],PAID_NET_AMT,* FROM TABLENAME WHERE PAID_NET_AMT <> 0 AND ISNULL([EQUIV_allow_rate],0) != 0 AND [DETAILstatus] NOT LIKE '%DENY%' AND [Modifier Discount] != 1







-- ======================================
	-- NOTE(S) / COMMENT(S) / CHANGE.LOG: --
-- ======================================
JAH CHARINDEX() FIND() SEARCH() 'MS ALLYSON FEE SCHEDULE EQUIVALENT LOGIC','SUBJECT:FEE FROM:ALLYSON'
x From: Sergio Martinez <smarti@chgsd.com> 
Sent: Monday, December 14, 2020 2:38 PM
To: Allyson Ross <aross@chgsd.com>
Subject: RE: Fee Schedule Question

Hi Allyson,  Sorry for the late reply. I’ll see what I can come up with, it may be a little complicated because there are so many scenarios, but I’ll give it a try. To answer you first question; we pay Outpatient Radiation Therapy claims as follows; 

Professional Claim (formtype = 1500)
		•	Medi-cal - USE 'C00740459'
		•	Medicare POS = 02, 11, 12, 20, 50 - USE 'C01011396' 
		•	Medicare POS <> 02, 11, 12, 20, 50 - USE 'C01011395'

Hospital Claim (formtype = UB04) 
		•	Medi-cal - USE 'C00727442'
		•	Medicare – no fee schedule. Claims are priced with Hospital OP PPS pricer

		USE https://duckduckgo.com/?q=Hospital+OP+PPS+pricer&t=h_ - CHARINDEX() FIND() SEARCH() "Hospital OP PPS pricer"

Thanks, Sergio

[Modifier Discount] 
SELECT CASE WHEN md.paypercent is null THEN 1 ELSE md.paypercent/100 end) * 
(CASE WHEN md2.paypercent is null THEN 1 ELSE md2.paypercent/100 end) * 
(CASE WHEN md3.paypercent is null THEN 1 ELSE md3.paypercent/100 end) * 
(CASE WHEN md4.paypercent is null THEN 1 ELSE md4.paypercent/100 end) * 
(CASE WHEN md5.paypercent is null THEN 1 ELSE md5.paypercent/100 end) as totalmoddiscount,

[Modifier Join]
FROM HMOPROD_PLANDATA.dbo.claimdetail AS cdet
		LEFT JOIN HMOPROD_PlanData.dbo.contract AS ct ON ct.contractid = c.contractid
		LEFT JOIN HMOPROD_PlanData.dbo.moddiscount AS md ON ct.moddiscountgroupid = md.moddiscountgroupid and md.modcode = cdet.modcode
		LEFT JOIN HMOPROD_PlanData.dbo.moddiscount AS md2 ON ct.moddiscountgroupid = md2.moddiscountgroupid and md2.modcode = cdet.modcode2
		LEFT JOIN HMOPROD_PlanData.dbo.moddiscount AS md3 ON ct.moddiscountgroupid = md3.moddiscountgroupid and md3.modcode = cdet.modcode3
		LEFT JOIN HMOPROD_PlanData.dbo.moddiscount AS md4 ON ct.moddiscountgroupid = md4.moddiscountgroupid and md4.modcode = cdet.modcode4
		LEFT JOIN HMOPROD_PlanData.dbo.moddiscount AS md5 ON ct.moddiscountgroupid = md5.moddiscountgroupid and md5.modcode = cdet.modcode5

[Fee Schedule Comparison]
SELECT case 
when f.feeamount is null and f2.feeamount is null and f3.feeamount is null and f4.feeamount is null and f5.feeamount is null and f6.feeamount is null and f7.feeamount is null and f8.feeamount is null and f9.feeamount is null and f10.feeamount is null and f11.feeamount is null and f12.feeamount is null and f13.feeamount is null THEN f14.feeamount
when f.feeamount is null and f2.feeamount is null and f3.feeamount is null and f4.feeamount is null and f5.feeamount is null and f6.feeamount is null and f7.feeamount is null and f8.feeamount is null and f9.feeamount is null and f10.feeamount is null and f11.feeamount is null and f12.feeamount is null THEN f13.feeamount 
when f.feeamount is null and f2.feeamount is null and f3.feeamount is null and f4.feeamount is null and f5.feeamount is null and f6.feeamount is null and f7.feeamount is null and f8.feeamount is null and f9.feeamount is null and f10.feeamount is null and f11.feeamount is null THEN f12.feeamount
when f.feeamount is null and f2.feeamount is null and f3.feeamount is null and f4.feeamount is null and f5.feeamount is null and f6.feeamount is null and f7.feeamount is null and f8.feeamount is null and f9.feeamount is null and f10.feeamount is null THEN f11.feeamount
when f.feeamount is null and f2.feeamount is null and f3.feeamount is null and f4.feeamount is null and f5.feeamount is null and f6.feeamount is null and f7.feeamount is null and f8.feeamount is null and f9.feeamount is null THEN f10.feeamount
when f.feeamount is null and f2.feeamount is null and f3.feeamount is null and f4.feeamount is null and f5.feeamount is null and f6.feeamount is null and f7.feeamount is null and f8.feeamount is null THEN f9.feeamount
when f.feeamount is null and f2.feeamount is null and f3.feeamount is null and f4.feeamount is null and f5.feeamount is null and f6.feeamount is null and f7.feeamount is null THEN f8.feeamount
when f.feeamount is null and f2.feeamount is null and f3.feeamount is null and f4.feeamount is null and f5.feeamount is null and f6.feeamount is null THEN f7.feeamount
when f.feeamount is null and f2.feeamount is null and f3.feeamount is null and f4.feeamount is null and f5.feeamount is null THEN f6.feeamount
when f.feeamount is null and f2.feeamount is null and f3.feeamount is null and f4.feeamount is null THEN f5.feeamount
when f.feeamount is null and f2.feeamount is null and f3.feeamount is null THEN f4.feeamount
when f.feeamount is null and f2.feeamount is null THEN f3.feeamount
when f.feeamount is null THEN f2.feeamount
ELSE f.feeamount end  as [EQUIV_allow_rate],
case
when f15.feeamount is null and f16.feeamount is null and f17.feeamount is null and f18.feeamount is null and f19.feeamount is null and f20.feeamount is null and f21.feeamount is null and f22.feeamount is null THEN f23.feeamount
when f15.feeamount is null and f16.feeamount is null and f17.feeamount is null and f18.feeamount is null and f19.feeamount is null and f20.feeamount is null and f21.feeamount is null THEN f22.feeamount
when f15.feeamount is null and f16.feeamount is null and f17.feeamount is null and f18.feeamount is null and f19.feeamount is null and f20.feeamount is null THEN f21.feeamount
when f15.feeamount is null and f16.feeamount is null and f17.feeamount is null and f18.feeamount is null and f19.feeamount is null THEN f20.feeamount
when f15.feeamount is null and f16.feeamount is null and f17.feeamount is null and f18.feeamount is null THEN f19.feeamount
when f15.feeamount is null and f16.feeamount is null and f17.feeamount is null THEN f18.feeamount
when f15.feeamount is null and f16.feeamount is null THEN f17.feeamount
when f15.feeamount is null THEN f16.feeamount
ELSE  f15.feeamount end as [mcr_allow_rate],
case 
when f.feeamount is null and f2.feeamount is null and f3.feeamount is null and f4.feeamount is null and f5.feeamount is null and f6.feeamount is null and f7.feeamount is null and f8.feeamount is null and f9.feeamount is null and f10.feeamount is null and f11.feeamount is null and f12.feeamount is null and f13.feeamount is null THEN f14.feeamount
when f.feeamount is null and f2.feeamount is null and f3.feeamount is null and f4.feeamount is null and f5.feeamount is null and f6.feeamount is null and f7.feeamount is null and f8.feeamount is null and f9.feeamount is null and f10.feeamount is null and f11.feeamount is null and f12.feeamount is null THEN f13.feeamount 
when f.feeamount is null and f2.feeamount is null and f3.feeamount is null and f4.feeamount is null and f5.feeamount is null and f6.feeamount is null and f7.feeamount is null and f8.feeamount is null and f9.feeamount is null and f10.feeamount is null and f11.feeamount is null THEN f12.feeamount
when f.feeamount is null and f2.feeamount is null and f3.feeamount is null and f4.feeamount is null and f5.feeamount is null and f6.feeamount is null and f7.feeamount is null and f8.feeamount is null and f9.feeamount is null and f10.feeamount is null THEN f11.feeamount
when f.feeamount is null and f2.feeamount is null and f3.feeamount is null and f4.feeamount is null and f5.feeamount is null and f6.feeamount is null and f7.feeamount is null and f8.feeamount is null and f9.feeamount is null THEN f10.feeamount
when f.feeamount is null and f2.feeamount is null and f3.feeamount is null and f4.feeamount is null and f5.feeamount is null and f6.feeamount is null and f7.feeamount is null and f8.feeamount is null THEN f9.feeamount
when f.feeamount is null and f2.feeamount is null and f3.feeamount is null and f4.feeamount is null and f5.feeamount is null and f6.feeamount is null and f7.feeamount is null THEN f8.feeamount
when f.feeamount is null and f2.feeamount is null and f3.feeamount is null and f4.feeamount is null and f5.feeamount is null and f6.feeamount is null THEN f7.feeamount
when f.feeamount is null and f2.feeamount is null and f3.feeamount is null and f4.feeamount is null and f5.feeamount is null THEN f6.feeamount
when f.feeamount is null and f2.feeamount is null and f3.feeamount is null and f4.feeamount is null THEN f5.feeamount
when f.feeamount is null and f2.feeamount is null and f3.feeamount is null THEN f4.feeamount
when f.feeamount is null and f2.feeamount is null THEN f3.feeamount
when f.feeamount is null THEN f2.feeamount
ELSE f.feeamount end   * totalmoddiscount * units_adj as [EQUIV_allow_compare],
case
when f15.feeamount is null and f16.feeamount is null and f17.feeamount is null and f18.feeamount is null and f19.feeamount is null and f20.feeamount is null and f21.feeamount is null and f22.feeamount is null THEN f23.feeamount
when f15.feeamount is null and f16.feeamount is null and f17.feeamount is null and f18.feeamount is null and f19.feeamount is null and f20.feeamount is null and f21.feeamount is null THEN f22.feeamount
when f15.feeamount is null and f16.feeamount is null and f17.feeamount is null and f18.feeamount is null and f19.feeamount is null and f20.feeamount is null THEN f21.feeamount
when f15.feeamount is null and f16.feeamount is null and f17.feeamount is null and f18.feeamount is null and f19.feeamount is null THEN f20.feeamount
when f15.feeamount is null and f16.feeamount is null and f17.feeamount is null and f18.feeamount is null THEN f19.feeamount
when f15.feeamount is null and f16.feeamount is null and f17.feeamount is null THEN f18.feeamount
when f15.feeamount is null and f16.feeamount is null THEN f17.feeamount
when f15.feeamount is null THEN f16.feeamount
ELSE  f15.feeamount end * totalmoddiscount * units_adj as [mcr_allow_compare]

[Fee Schedule Join]
FROM #temp AS db
		LEFT JOIN hmoprod_plandata.dbo.feetable AS f ON f.mincodeid = db.servcode and f.modcode = db.modcode and f.modcode2 = db.modcode2 and db.location = f.locationcode and f.feetableid = 'C00740459' and f.termdate = '12/31/2078'
		LEFT JOIN hmoprod_plandata.dbo.feetable AS f2 ON f2.mincodeid = db.servcode and f2.modcode = db.modcode and f.modcode2 = db.modcode2  and  f2.locationcode = '' and f2.feetableid = 'C00740459' and f2.termdate = '12/31/2078'
		LEFT JOIN hmoprod_plandata.dbo.feetable AS f3 ON f3.mincodeid = db.servcode and f3.modcode2 = db.modcode and f3.modcode = db.modcode2 and db.location = f3.locationcode and f3.feetableid = 'C00740459' and f3.termdate = '12/31/2078'
		LEFT JOIN hmoprod_plandata.dbo.feetable AS f4 ON f4.mincodeid = db.servcode and f4.modcode2 = db.modcode and f4.modcode = db.modcode2  and  f4.locationcode = '' and f4.feetableid = 'C00740459' and f4.termdate = '12/31/2078'
		LEFT JOIN hmoprod_plandata.dbo.feetable AS f5 ON f5.mincodeid = db.servcode and f5.modcode = db.modcode and f5.locationcode = db.location  and f5.feetableid = 'C00740459' and f5.termdate = '12/31/2078'
		LEFT JOIN hmoprod_plandata.dbo.feetable AS f6 ON f6.mincodeid = db.servcode and f6.modcode = db.modcode and  f6.locationcode = '' and f6.feetableid = 'C00740459' and f6.termdate = '12/31/2078'
		LEFT JOIN hmoprod_plandata.dbo.feetable AS f7 ON f7.mincodeid = db.servcode and f7.modcode = db.modcode2 and f7.locationcode = db.location  and f7.feetableid = 'C00740459' and f7.termdate = '12/31/2078'
		LEFT JOIN hmoprod_plandata.dbo.feetable AS f8 ON f8.mincodeid = db.servcode and f8.modcode = db.modcode2 and  f8.locationcode = '' and f8.feetableid = 'C00740459' and f8.termdate = '12/31/2078'
		LEFT JOIN hmoprod_plandata.dbo.feetable AS f9 ON f9.mincodeid = db.servcode and f9.modcode = db.modcode3 and f9.locationcode = db.location  and f9.feetableid = 'C00740459' and f9.termdate = '12/31/2078'
		LEFT JOIN hmoprod_plandata.dbo.feetable AS f10 ON f10.mincodeid = db.servcode and f10.modcode = db.modcode3 and  f10.locationcode = '' and f10.feetableid = 'C00740459' and f10.termdate = '12/31/2078'
		LEFT JOIN hmoprod_plandata.dbo.feetable AS f11 ON f11.mincodeid = db.servcode and f11.modcode = db.modcode4 and f11.locationcode = db.location  and f11.feetableid = 'C00740459' and f11.termdate = '12/31/2078'
		LEFT JOIN hmoprod_plandata.dbo.feetable AS f12 ON f12.mincodeid = db.servcode and f12.modcode = db.modcode4 and  f12.locationcode = '' and f12.feetableid = 'C00740459' and f12.termdate = '12/31/2078'
		LEFT JOIN hmoprod_plandata.dbo.feetable AS f13 ON f13.mincodeid = db.servcode and f13.modcode = db.modcode5 and f13.locationcode = db.location  and f13.feetableid = 'C00740459' and f13.termdate = '12/31/2078'
		LEFT JOIN hmoprod_plandata.dbo.feetable AS f14 ON f14.mincodeid = db.servcode and f14.modcode = db.modcode5 and  f14.locationcode = '' and f14.feetableid = 'C00740459' and f14.termdate = '12/31/2078'
		LEFT JOIN hmoprod_plandata.dbo.feetable AS f15 ON f15.mincodeid = db.servcode and f15.modcode = db.modcode and f15.modcode2 = db.modcode2 and f15.feetableid = 'C01011396'and f15.termdate = '12/31/2078'
		LEFT JOIN hmoprod_plandata.dbo.feetable AS f16 ON f16.mincodeid = db.servcode and f16.modcode = db.modcode2 and f16.modcode2 = db.modcode and f16.feetableid = 'C01011396'and f16.termdate = '12/31/2078'
		LEFT JOIN hmoprod_plandata.dbo.feetable AS f17 ON f17.mincodeid = db.servcode and f17.modcode = db.modcode and f17.modcode2 = '' and f17.feetableid = 'C01011396'and f17.termdate = '12/31/2078'
		LEFT JOIN hmoprod_plandata.dbo.feetable AS f18 ON f18.mincodeid = db.servcode and f18.modcode = db.modcode2 and f18.modcode2 = '' and f18.feetableid = 'C01011396'and f18.termdate = '12/31/2078'
		LEFT JOIN hmoprod_plandata.dbo.feetable AS f19 ON f19.mincodeid = db.servcode and f19.modcode = db.modcode3 and f19.modcode2 = '' and f19.feetableid = 'C01011396'and f19.termdate = '12/31/2078'
		LEFT JOIN hmoprod_plandata.dbo.feetable AS f20 ON f20.mincodeid = db.servcode and f20.modcode = db.modcode4 and f20.modcode2 = '' and f20.feetableid = 'C01011396'and f20.termdate = '12/31/2078'
		LEFT JOIN hmoprod_plandata.dbo.feetable AS f21 ON f21.mincodeid = db.servcode and f21.modcode = db.modcode5 and f21.modcode2 = '' and f21.feetableid = 'C01011396'and f21.termdate = '12/31/2078'
		LEFT JOIN hmoprod_plandata.dbo.feetable AS f22 ON f22.mincodeid = db.servcode and f22.modcode = '' and f22.modcode2 = '' and f22.feetableid = 'C01011396'and f22.termdate = '12/31/2078'
		LEFT JOIN hmoprod_plandata.dbo.feetable AS f23 ON f23.mincodeid = db.servcode and f23.modcode = db.modcode and f23.feetableid = 'C01011396'and f23.termdate = '12/31/2078'

Thank you,
Allyson Ross
Informatics Supervisor
Office: (619) 240-8926
Cell: (619) 495-6994
Email: aross@chgsd.com







-- =================================================================
	-- DYNAMIC() v. STATIC() DECLARE(s) FOR [...] --
-- =================================================================
DECLARE @sched AS nvarchar(25)
DECLARE @whensf AS datetime
DECLARE @ft AS nvarchar(25)    
DECLARE @dt AS datetime

SET @sched = '%%%' --'MCR%' --'%ZZZ%'
SET @whensf = '01/01/2017' -- GETDATE() --UPDATE(s) AT NEW QTR(s)
SET @ft = '%ZZZNOTZERO%' --ZZZNOTZERO - NO MODIFIER NO ZERO ZZZ                        
SET @dt = GETDATE()

-- ===================================================================
	-- ZZZ pricing --
-- ===================================================================	
	-- Generate Initial ZZZ Tbl--
-----------------------------------------------------------------------------------------------------------------------------
	-- Error Trapping: Check If Permanent Table(s) Already Exist(s) And Drop If Applicable --
-----------------------------------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS #pricing -- SQL Server 2016 and later -- DYNAMIC tmp OR STATIC [TABLE] #TableName is a local temporary table visible only IN the current session; ##TableName is a GLOBAL temporary table visible to all sessions IN ('TempDB')

SELECT DISTINCT sf.feeid,sf.description,SUBSTRING(UPPER(LTRIM(RTRIM(mincodeid))),1,5) AS PROCEDURE_CODE,SUBSTRING(UPPER(LTRIM(RTRIM(maxcodeid))) ,1,5)AS othPROC,LTRIM(RTRIM(modcode)) AS MODIFIER,MAX(feeamount) AS MAXrate
INTO #pricing
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM HMOPROD_PLANDATA.dbo.standardfee AS sf
	JOIN HMOPROD_PLANDATA.dbo.feetable AS ft ON sf.feeid = ft.feetableid
WHERE LTRIM(RTRIM(sf.feeid)) LIKE @ft
	AND CAST(ft.effdate AS datetime) <= CAST(@dt AS datetime) --IIF eff AFTER...
	AND CAST(ft.termdate AS datetime) >= CAST(@dt AS datetime)  --IIF termed BEFORE...
GROUP BY 	sf.feeid,sf.description,SUBSTRING(UPPER(LTRIM(RTRIM(mincodeid))),1,5),SUBSTRING(UPPER(LTRIM(RTRIM(maxcodeid))),1,5),LTRIM(RTRIM(modcode))

	--DUP(s)--
-- SELECT 'DUP Validation' AS [DUP NOTE(s)],*
-- FROM #pricing
-- WHERE LTRIM(RTRIM(PROCEDURE_CODE))+LTRIM(RTRIM(MODIFIER)) IN (SELECT LTRIM(RTRIM(PROCEDURE_CODE))+LTRIM(RTRIM(MODIFIER))
-- FROM #pricing
-- GROUP BY LTRIM(RTRIM(PROCEDURE_CODE))+LTRIM(RTRIM(MODIFIER)) --Duplication Driver
-- HAVING COUNT(1)>1 ) --HAVING clause RESERVED for AGGREGATE(s)
-- ORDER BY LTRIM(RTRIM(PROCEDURE_CODE))+LTRIM(RTRIM(MODIFIER))

		SELECT TOP 10 * FROM #pricing
		






	--Generate Alternate ZZZ Tbl(s)--
-----------------------------------------------------------------------------------------------------------------------------
	-- Error Trapping: Check If Permanent Table(s) Already Exist(s) And Drop If Applicable --
-----------------------------------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS #pricingOptionB -- SQL Server 2016 and later -- DYNAMIC tmp OR STATIC [TABLE] #TableName is a local temporary table visible only IN the current session; ##TableName is a GLOBAL temporary table visible to all sessions IN ('TempDB')

SELECT DISTINCT sf.feeid,sf.description,SUBSTRING(UPPER(LTRIM(RTRIM(mincodeid))),1,5) AS PROCEDURE_CODE,SUBSTRING(UPPER(LTRIM(RTRIM(maxcodeid))) ,1,5)AS othPROC,LTRIM(RTRIM(modcode)) AS MODIFIER,MAX(feeamount) AS MAXrate
INTO #pricingOptionB
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM HMOPROD_PLANDATA.dbo.standardfee AS sf
	JOIN HMOPROD_PLANDATA.dbo.feetable AS ft ON sf.feeid = ft.feetableid
WHERE LTRIM(RTRIM(sf.feeid)) LIKE @ft
	AND CAST(ft.effdate AS datetime) <= CAST(@dt AS datetime) --IIF eff AFTER...
	AND CAST(ft.termdate AS datetime) >= CAST(@dt AS datetime)  --IIF termed BEFORE...
GROUP BY 	sf.feeid,sf.description,SUBSTRING(UPPER(LTRIM(RTRIM(mincodeid))),1,5),SUBSTRING(UPPER(LTRIM(RTRIM(maxcodeid))),1,5),LTRIM(RTRIM(modcode))

	--DUP(s)--
-- SELECT 'DUP Validation' AS [DUP NOTE(s)],*
-- FROM #pricingOptionB
-- WHERE LTRIM(RTRIM(PROCEDURE_CODE))+LTRIM(RTRIM(MODIFIER)) IN (SELECT LTRIM(RTRIM(PROCEDURE_CODE))+LTRIM(RTRIM(MODIFIER))
-- FROM #pricingOptionB
-- GROUP BY LTRIM(RTRIM(PROCEDURE_CODE))+LTRIM(RTRIM(MODIFIER)) --Duplication Driver
-- HAVING COUNT(1)>1 ) --HAVING clause RESERVED for AGGREGATE(s)
-- ORDER BY LTRIM(RTRIM(PROCEDURE_CODE))+LTRIM(RTRIM(MODIFIER))

		SELECT TOP 10 * FROM #pricingOptionB







-----------------------------------------------------------------------------------------------------------------------------
	-- Error Trapping: Check If Permanent Table(s) Already Exist(s) And Drop If Applicable --
-----------------------------------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS #pricingOptionC -- SQL Server 2016 and later -- DYNAMIC tmp OR STATIC [TABLE] #TableName is a local temporary table visible only IN the current session; ##TableName is a GLOBAL temporary table visible to all sessions IN ('TempDB')

SELECT DISTINCT sf.feeid,sf.description,SUBSTRING(UPPER(LTRIM(RTRIM(mincodeid))),1,5) AS PROCEDURE_CODE,SUBSTRING(UPPER(LTRIM(RTRIM(maxcodeid))) ,1,5)AS othPROC,LTRIM(RTRIM(modcode)) AS MODIFIER,MAX(feeamount) AS MAXrate
INTO #pricingOptionC
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM standardfee AS sf
	JOIN feetable AS ft ON sf.feeid = ft.feetableid
WHERE LTRIM(RTRIM(sf.feeid)) LIKE @ft
	AND CAST(ft.effdate AS datetime) <= CAST(@dt AS datetime) --IIF eff AFTER...
	AND CAST(ft.termdate AS datetime) >= CAST(@dt AS datetime)  --IIF termed BEFORE...
GROUP BY 	sf.feeid,sf.description,SUBSTRING(UPPER(LTRIM(RTRIM(mincodeid))),1,5),SUBSTRING(UPPER(LTRIM(RTRIM(maxcodeid))),1,5),LTRIM(RTRIM(modcode)) 

	--DUP(s)--
-- SELECT 'DUP Validation' AS [DUP NOTE(s)],*
-- FROM #pricingOptionC
-- WHERE LTRIM(RTRIM(PROCEDURE_CODE))+LTRIM(RTRIM(MODIFIER)) IN (SELECT LTRIM(RTRIM(PROCEDURE_CODE))+LTRIM(RTRIM(MODIFIER))
-- FROM #pricingOptionC
-- GROUP BY LTRIM(RTRIM(PROCEDURE_CODE))+LTRIM(RTRIM(MODIFIER)) --Duplication Driver
-- HAVING COUNT(1)>1 ) --HAVING clause RESERVED for AGGREGATE(s)
-- ORDER BY LTRIM(RTRIM(PROCEDURE_CODE))+LTRIM(RTRIM(MODIFIER))

		SELECT TOP 10 * FROM #pricingOptionC







-- =====================================================
	-- GENERATE medi-cal ZZZ  Rate Equivalent(s) FEE SCHEDULE--
-- =====================================================
-----------------------------------------------------------------------------------------------------------------------------
	-- Error Trapping: Check If Permanent Table(s) Already Exist(s) And Drop If Applicable --
-----------------------------------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS #ZZZ -- SQL Server 2016 and later -- DYNAMIC tmp OR STATIC [TABLE] #TableName is a local temporary table visible only IN the current session; ##TableName is a GLOBAL temporary table visible to all sessions IN ('TempDB')

SELECT *
INTO #ZZZ
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM #pricing
UNION ALL
SELECT *
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM #pricingOptionB
UNION ALL
SELECT *
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM #pricingOptionC

	--DUP(s)--
-- SELECT 'DUP Validation' AS [DUP NOTE(s)],*
-- FROM #ZZZ
-- WHERE LTRIM(RTRIM(PROCEDURE_CODE))+LTRIM(RTRIM(MODIFIER)) IN (SELECT LTRIM(RTRIM(dup.PROCEDURE_CODE))+LTRIM(RTRIM(dup.MODIFIER))
-- FROM #ZZZ AS dup
-- GROUP BY LTRIM(RTRIM(dup.PROCEDURE_CODE))+LTRIM(RTRIM(dup.MODIFIER)) --Duplication Driver
-- HAVING COUNT(1)>1 ) --HAVING clause RESERVED for AGGREGATE(s)
-- ORDER BY LTRIM(RTRIM(PROCEDURE_CODE))+LTRIM(RTRIM(MODIFIER))







-----------------------------------------------------------------------------------------------------------------------------
	-- Error Trapping: Check If Permanent Table(s) Already Exist(s) And Drop If Applicable --
-----------------------------------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS INFORMATICS2.dbo.SHELLzzz -- SQL Server 2016 and later -- DYNAMIC tmp OR STATIC [TABLE] #TableName is a local temporary table visible only IN the current session; ##TableName is a GLOBAL temporary table visible to all sessions IN ('TempDB')

SELECT DISTINCT 'ZZZ' AS feeschedule
,UPPER(LTRIM(RTRIM(PROCEDURE_CODE))) AS PROCCDE
,UPPER(LTRIM(RTRIM(MODIFIER))) AS MODIFIER_CODE
,MAXrate AS ZZZprice
INTO INFORMATICS2.dbo.SHELLzzz
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM #ZZZ
ORDER BY UPPER(LTRIM(RTRIM(PROCEDURE_CODE))),UPPER(LTRIM(RTRIM(MODIFIER))),MAXrate DESC

	--DUP(s)--
-- SELECT 'DUP Validation' AS [DUP NOTE(s)],*
-- WHERE LTRIM(RTRIM(PROCCDE))+LTRIM(RTRIM(MODIFIER_CODE)) IN (SELECT LTRIM(RTRIM(dup.PROCCDE))+LTRIM(RTRIM(dup.MODIFIER_CODE))
-- FROM INFORMATICS2.dbo.SHELLzzz AS dup
-- GROUP BY LTRIM(RTRIM(dup.PROCCDE))+LTRIM(RTRIM(dup.MODIFIER_CODE)) --Duplication Driver
-- HAVING COUNT(1)>1 ) --HAVING clause RESERVED for AGGREGATE(s)
-- ORDER BY LTRIM(RTRIM(PROCCDE))+LTRIM(RTRIM(MODIFIER_CODE))







'SIR ALLAN FEE TABLE UPDATE'(s) - FYI… All the 1st quarter 2017 CMS fee schedules have been loaded into QNXT. Their temp tables and identification IN feetable are below:
		/*****2017 CMS Fee Schedules - 1st Quarter*****/
		-- Physician
		SELECT *
		FROM CHGAPP_PROD..TEMP_Physician2017Q1
		WHERE StatusCode <> 'N'
		-- 13,433 records

		-- MCR10
		SELECT f.*
		FROM HMOPROD_PLANDATA.dbo.feetable AS f
		WHERE f.createid = 'M102017Q1'

		-- MCR11
		SELECT f.*
		FROM HMOPROD_PLANDATA.dbo.feetable AS f
		WHERE f.createid = 'M112017Q1'

		-- Ambulance 
		SELECT *
		FROM CHGAPP_PROD..TEMP_AMBULANCE2017
		-- 12 records

		SELECT f.*
		FROM HMOPROD_PLANDATA.dbo.feetable AS f
		WHERE f.createid = 'CMSAmb2017'

		-- Average Sale Price - Drugs
		SELECT *
		FROM CHGAPP_PROD..TEMP_ASP2017Q1_ASH
		-- 539 records

		SELECT f.*
		FROM HMOPROD_PLANDATA.dbo.feetable AS f
		WHERE f.createid = 'ASP2017Q1'

		-- CLIA - Clinical Lab
		SELECT *
		FROM CHGAPP_PROD..TEMP_CLIA2017Q1
		-- 1,342 records

		SELECT f.*
		FROM HMOPROD_PLANDATA.dbo.feetable AS f
		WHERE f.createid = 'CLIA2017Q1'

		-- DME - Durable Medical Equipment
		SELECT *
		FROM CHGAPP_PROD..TEMP_DME2017Q1
		-- 2,549 records

		SELECT f.*
		FROM HMOPROD_PLANDATA.dbo.feetable AS f
		WHERE f.createid = 'DME2017Q1'

Regards,

Allan Sombillo
Chief Information Officer
Community Health Group
(619) 498-6413
asombillo@chgsd.com







'MS. ALLYSON' - New Encoder Pro login.
Thank you,
Allyson Ross

From: Sergio Martinez 
Sent: Friday, August 05, 2016 1:54 PM
To: Allyson Ross
Subject: EncoderPro login

		USE https://www.encoderprofp.com/epro4payers/

		Username: 'Vheavn'
		Password: 'Chg2016'

Hi Walter,
Below are the Medi-Cal fee schedules.
Thank you,
Allyson Ross

From: Allan Sombillo 
Sent: Friday, August 05, 2016 5:17 PM
To: Allyson Ross
Subject: RE: Medi-Cal

Allyson,  For Institutional, it will depend ON the Provider and the type of contract they have. But there are 4 Medi-Cal Institutional fee schedules, and they are released ON a monthly basis which are loaded into QNXT feetable.

		-- Medi-Cal Institutional
		SELECT  s.feeid
			   , s.description
			   , s.feetype
		FROM HMOPROD_PLANDATA.dbo.standardfee s
		WHERE s.feeid IN ('C00727444','C00727443','C00727442','C00727445')
		-- feeid                          description                                     feetype
		-- C00727442         1 HOSP MCAL ORTHO - BASIC RATES                               UCR            
		-- C00727443         1 HOSP MCAL CHILDREN RATES                                    CUSTOM         
		-- C00727444         1 HOSP MCAL CUTBACK RATES                                     CUSTOM         
		-- C00727445         1 HOSP MCAL ER RATES                                          CUSTOM         

		-- Active Medi-Cal Institutional rates
		SELECT  s.description
			   , f.*
		FROM HMOPROD_PLANDATA.dbo.feetable AS f
		join   HMOPROD_PLANDATA.dbo.standardfee s (NOLOCK) ON s.feeid = f.feetableid
		  and  f.termdate = '12/31/2078'
		  and  s.feeid IN ('C00727444','C00727443','C00727442','C00727445')

Thanks, Allan
From: Allyson Ross 
Sent: Friday, August 05, 2016 3:07 PM
To: Allan Sombillo
Subject: RE: Medi-Cal

Institutional.
Thank you,
Allyson Ross

From: Allan Sombillo 
Sent: Friday, August 05, 2016 3:06 PM
To: Allyson Ross
Subject: RE: Medi-Cal

Hi Allyson,
Are these Professional or Institutional services? 
Thanks,
Allan

From: Allyson Ross 
Sent: Friday, August 05, 2016 3:01 PM
To: Allan Sombillo
Subject: Medi-Cal

Hi Allan,
Joseph would like me to compare a contract to 120% of Medi-Cal rates.  Can you send me our current Medi-Cal fee schedule?
Thank you,

Allyson Ross
Informatics Business Systems Analyst
Email: aross@chgsd.com
Ext: 8926







-- ================================================
	-- GENERAL FEE SCHEDULE(s) REVIEW()  / EQUIVALENT --
-- ================================================
UPDATE INFORMATICS.dbo.GENDERAx
SET [EQUIV_allow_rate] = case 
when f.feeamount is null and f2.feeamount is null and f3.feeamount is null and f4.feeamount is null and f5.feeamount is null and f6.feeamount is null and f7.feeamount is null and f8.feeamount is null and f9.feeamount is null and f10.feeamount is null and f11.feeamount is null and f12.feeamount is null and f13.feeamount is null THEN f14.feeamount
when f.feeamount is null and f2.feeamount is null and f3.feeamount is null and f4.feeamount is null and f5.feeamount is null and f6.feeamount is null and f7.feeamount is null and f8.feeamount is null and f9.feeamount is null and f10.feeamount is null and f11.feeamount is null and f12.feeamount is null THEN f13.feeamount 
when f.feeamount is null and f2.feeamount is null and f3.feeamount is null and f4.feeamount is null and f5.feeamount is null and f6.feeamount is null and f7.feeamount is null and f8.feeamount is null and f9.feeamount is null and f10.feeamount is null and f11.feeamount is null THEN f12.feeamount
when f.feeamount is null and f2.feeamount is null and f3.feeamount is null and f4.feeamount is null and f5.feeamount is null and f6.feeamount is null and f7.feeamount is null and f8.feeamount is null and f9.feeamount is null and f10.feeamount is null THEN f11.feeamount
when f.feeamount is null and f2.feeamount is null and f3.feeamount is null and f4.feeamount is null and f5.feeamount is null and f6.feeamount is null and f7.feeamount is null and f8.feeamount is null and f9.feeamount is null THEN f10.feeamount
when f.feeamount is null and f2.feeamount is null and f3.feeamount is null and f4.feeamount is null and f5.feeamount is null and f6.feeamount is null and f7.feeamount is null and f8.feeamount is null THEN f9.feeamount
when f.feeamount is null and f2.feeamount is null and f3.feeamount is null and f4.feeamount is null and f5.feeamount is null and f6.feeamount is null and f7.feeamount is null THEN f8.feeamount
when f.feeamount is null and f2.feeamount is null and f3.feeamount is null and f4.feeamount is null and f5.feeamount is null and f6.feeamount is null THEN f7.feeamount
when f.feeamount is null and f2.feeamount is null and f3.feeamount is null and f4.feeamount is null and f5.feeamount is null THEN f6.feeamount
when f.feeamount is null and f2.feeamount is null and f3.feeamount is null and f4.feeamount is null THEN f5.feeamount
when f.feeamount is null and f2.feeamount is null and f3.feeamount is null THEN f4.feeamount
when f.feeamount is null and f2.feeamount is null THEN f3.feeamount
when f.feeamount is null THEN f2.feeamount
ELSE f.feeamount end
,[EQUIV_allow_compare] = case 
when f.feeamount is null and f2.feeamount is null and f3.feeamount is null and f4.feeamount is null and f5.feeamount is null and f6.feeamount is null and f7.feeamount is null and f8.feeamount is null and f9.feeamount is null and f10.feeamount is null and f11.feeamount is null and f12.feeamount is null and f13.feeamount is null THEN f14.feeamount
when f.feeamount is null and f2.feeamount is null and f3.feeamount is null and f4.feeamount is null and f5.feeamount is null and f6.feeamount is null and f7.feeamount is null and f8.feeamount is null and f9.feeamount is null and f10.feeamount is null and f11.feeamount is null and f12.feeamount is null THEN f13.feeamount 
when f.feeamount is null and f2.feeamount is null and f3.feeamount is null and f4.feeamount is null and f5.feeamount is null and f6.feeamount is null and f7.feeamount is null and f8.feeamount is null and f9.feeamount is null and f10.feeamount is null and f11.feeamount is null THEN f12.feeamount
when f.feeamount is null and f2.feeamount is null and f3.feeamount is null and f4.feeamount is null and f5.feeamount is null and f6.feeamount is null and f7.feeamount is null and f8.feeamount is null and f9.feeamount is null and f10.feeamount is null THEN f11.feeamount
when f.feeamount is null and f2.feeamount is null and f3.feeamount is null and f4.feeamount is null and f5.feeamount is null and f6.feeamount is null and f7.feeamount is null and f8.feeamount is null and f9.feeamount is null THEN f10.feeamount
when f.feeamount is null and f2.feeamount is null and f3.feeamount is null and f4.feeamount is null and f5.feeamount is null and f6.feeamount is null and f7.feeamount is null and f8.feeamount is null THEN f9.feeamount
when f.feeamount is null and f2.feeamount is null and f3.feeamount is null and f4.feeamount is null and f5.feeamount is null and f6.feeamount is null and f7.feeamount is null THEN f8.feeamount
when f.feeamount is null and f2.feeamount is null and f3.feeamount is null and f4.feeamount is null and f5.feeamount is null and f6.feeamount is null THEN f7.feeamount
when f.feeamount is null and f2.feeamount is null and f3.feeamount is null and f4.feeamount is null and f5.feeamount is null THEN f6.feeamount
when f.feeamount is null and f2.feeamount is null and f3.feeamount is null and f4.feeamount is null THEN f5.feeamount
when f.feeamount is null and f2.feeamount is null and f3.feeamount is null THEN f4.feeamount
when f.feeamount is null and f2.feeamount is null THEN f3.feeamount
when f.feeamount is null THEN f2.feeamount
ELSE f.feeamount end   * (CASE WHEN md.paypercent is null THEN 1 ELSE md.paypercent/100 end) * 
(CASE WHEN md2.paypercent is null THEN 1 ELSE md2.paypercent/100 end) * 
(CASE WHEN md3.paypercent is null THEN 1 ELSE md3.paypercent/100 end) * 
(CASE WHEN md4.paypercent is null THEN 1 ELSE md4.paypercent/100 end) * 
(CASE WHEN md5.paypercent is null THEN 1 ELSE md5.paypercent/100 end) -- as totalmoddiscount -- [Modifier Discount]
 * su.servunits
-- SELECT TOP 10 * ci.contracted,sip.ProviderParStatus,ci.*,sip.* -- CHECK 1st
-- SELECT DISTINCT contracted,iscapitated FROM HMOPROD_PLANDATA.dbo.contractinfo -- CHECK 1st
FROM INFORMATICS.dbo.GENDERAx AS su
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
-- FROM #temp AS db -- [Fee Schedule LEFT JOIN]
	LEFT JOIN hmoprod_plandata.dbo.feetable AS f ON su.servcode = f.mincodeid
		AND su.modcode = f.modcode
		AND su.modcode2 = f.modcode2
		AND su.location = f.locationcode
		and f.feetableid = 'C00740459' 
		and f.termdate = '12/31/2078'
	LEFT JOIN hmoprod_plandata.dbo.feetable AS f2 ON su.servcode = f2.mincodeid
		AND su.modcode = f2.modcode
		AND su.modcode2 = f.modcode2  
		and  f2.locationcode = '' 
		and f2.feetableid = 'C00740459' 
		and f2.termdate = '12/31/2078'
	LEFT JOIN hmoprod_plandata.dbo.feetable AS f3 ON su.servcode = f3.mincodeid
		AND su.modcode = f3.modcode2
		AND su.modcode2 = f3.modcode
		AND su.location = f3.locationcode 
		and f3.feetableid = 'C00740459' 
		and f3.termdate = '12/31/2078'
	LEFT JOIN hmoprod_plandata.dbo.feetable AS f4 ON su.servcode = f4.mincodeid
		AND su.modcode = f4.modcode2
		AND su.modcode2 = f4.modcode
		and  f4.locationcode = '' 
		and f4.feetableid = 'C00740459' 
		and f4.termdate = '12/31/2078'
	LEFT JOIN hmoprod_plandata.dbo.feetable AS f5 ON su.servcode = f5.mincodeid
		AND su.modcode = f5.modcode
		AND su.location = f5.locationcode
		and f5.feetableid = 'C00740459' 
		and f5.termdate = '12/31/2078'
	LEFT JOIN hmoprod_plandata.dbo.feetable AS f6 ON su.servcode = f6.mincodeid
		AND su.modcode = f6.modcode
		and  f6.locationcode = '' 
		and f6.feetableid = 'C00740459' 
		and f6.termdate = '12/31/2078'
	LEFT JOIN hmoprod_plandata.dbo.feetable AS f7 ON su.servcode = f7.mincodeid
		AND su.modcode2 = f7.modcode
		AND su.location = f7.locationcode  
		and f7.feetableid = 'C00740459' 
		and f7.termdate = '12/31/2078'
	LEFT JOIN hmoprod_plandata.dbo.feetable AS f8 ON su.servcode = f8.mincodeid
		AND su.modcode2 = f8.modcode
		and  f8.locationcode = '' 
		and f8.feetableid = 'C00740459' 
		and f8.termdate = '12/31/2078'
	LEFT JOIN hmoprod_plandata.dbo.feetable AS f9 ON su.servcode = f9.mincodeid
		AND su.modcode3 = f9.modcode
		AND su.location = f9.locationcode
		and f9.feetableid = 'C00740459' 
		and f9.termdate = '12/31/2078'
	LEFT JOIN hmoprod_plandata.dbo.feetable AS f10 ON su.servcode = f10.mincodeid
		AND su.modcode3 = f10.modcode 
		and  f10.locationcode = '' 
		and f10.feetableid = 'C00740459' 
		and f10.termdate = '12/31/2078'
	LEFT JOIN hmoprod_plandata.dbo.feetable AS f11 ON su.servcode = f11.mincodeid
		AND su.modcode4 = f11.modcode
		AND su.location = f11.locationcode  
		and f11.feetableid = 'C00740459' 
		and f11.termdate = '12/31/2078'
	LEFT JOIN hmoprod_plandata.dbo.feetable AS f12 ON su.servcode = f12.mincodeid
		AND su.modcode4 = f12.modcode
		and  f12.locationcode = '' 
		and f12.feetableid = 'C00740459' 
		and f12.termdate = '12/31/2078'
	LEFT JOIN hmoprod_plandata.dbo.feetable AS f13 ON su.servcode = f13.mincodeid
		AND su.modcode5 = f13.modcode
		AND su.location = f13.locationcode  
		and f13.feetableid = 'C00740459' 
		and f13.termdate = '12/31/2078'
	LEFT JOIN hmoprod_plandata.dbo.feetable AS f14 ON su.servcode = f14.mincodeid
		AND su.modcode5 = f14.modcode
		and  f14.locationcode = '' 
		and f14.feetableid = 'C00740459' 
		and f14.termdate = '12/31/2078'
	LEFT JOIN hmoprod_plandata.dbo.feetable AS f15 ON su.servcode = f15.mincodeid
		AND su.modcode = f15.modcode
		AND su.modcode2 = f15.modcode2
		and f15.feetableid = 'C01011396'
		and f15.termdate = '12/31/2078'
	LEFT JOIN hmoprod_plandata.dbo.feetable AS f16 ON su.servcode = f16.mincodeid
		AND su.modcode2 = f16.modcode
		AND su.modcode = f16.modcode2
		and f16.feetableid = 'C01011396'
		and f16.termdate = '12/31/2078'
	LEFT JOIN hmoprod_plandata.dbo.feetable AS f17 ON su.servcode = f17.mincodeid
		AND su.modcode = f17.modcode
		and f17.modcode2 = '' 
		and f17.feetableid = 'C01011396'
		and f17.termdate = '12/31/2078'
	LEFT JOIN hmoprod_plandata.dbo.feetable AS f18 ON su.servcode = f18.mincodeid
		AND su.modcode2 = f18.modcode
		and f18.modcode2 = '' 
		and f18.feetableid = 'C01011396'
		and f18.termdate = '12/31/2078'
	LEFT JOIN hmoprod_plandata.dbo.feetable AS f19 ON su.servcode = f19.mincodeid
		AND su.modcode3 = f19.modcode
		and f19.modcode2 = '' 
		and f19.feetableid = 'C01011396'
		and f19.termdate = '12/31/2078'
	LEFT JOIN hmoprod_plandata.dbo.feetable AS f20 ON su.servcode = f20.mincodeid
		AND su.modcode4 = f20.modcode
		and f20.modcode2 = '' 
		and f20.feetableid = 'C01011396'
		and f20.termdate = '12/31/2078'
	LEFT JOIN hmoprod_plandata.dbo.feetable AS f21 ON su.servcode = f21.mincodeid
		AND su.modcode5  = f21.modcode
		and f21.modcode2 = '' 
		and f21.feetableid = 'C01011396'
		and f21.termdate = '12/31/2078'
	LEFT JOIN hmoprod_plandata.dbo.feetable AS f22 ON su.servcode = f22.mincodeid
		and f22.modcode = '' 
		and f22.modcode2 = '' 
		and f22.feetableid = 'C01011396'
		and f22.termdate = '12/31/2078'
	LEFT JOIN hmoprod_plandata.dbo.feetable AS f23 ON su.servcode = f23.mincodeid
		AND su.modcode = f23.modcode
		and f23.feetableid = 'C01011396'
		and f23.termdate = '12/31/2078'
WHERE su.formtype LIKE '%1500%'







UPDATE INFORMATICS.dbo.GENDERAx
SET [EQUIV_allow_rate] = case 
when f.feeamount is null and f2.feeamount is null and f3.feeamount is null and f4.feeamount is null and f5.feeamount is null and f6.feeamount is null and f7.feeamount is null and f8.feeamount is null and f9.feeamount is null and f10.feeamount is null and f11.feeamount is null and f12.feeamount is null and f13.feeamount is null THEN f14.feeamount
when f.feeamount is null and f2.feeamount is null and f3.feeamount is null and f4.feeamount is null and f5.feeamount is null and f6.feeamount is null and f7.feeamount is null and f8.feeamount is null and f9.feeamount is null and f10.feeamount is null and f11.feeamount is null and f12.feeamount is null THEN f13.feeamount 
when f.feeamount is null and f2.feeamount is null and f3.feeamount is null and f4.feeamount is null and f5.feeamount is null and f6.feeamount is null and f7.feeamount is null and f8.feeamount is null and f9.feeamount is null and f10.feeamount is null and f11.feeamount is null THEN f12.feeamount
when f.feeamount is null and f2.feeamount is null and f3.feeamount is null and f4.feeamount is null and f5.feeamount is null and f6.feeamount is null and f7.feeamount is null and f8.feeamount is null and f9.feeamount is null and f10.feeamount is null THEN f11.feeamount
when f.feeamount is null and f2.feeamount is null and f3.feeamount is null and f4.feeamount is null and f5.feeamount is null and f6.feeamount is null and f7.feeamount is null and f8.feeamount is null and f9.feeamount is null THEN f10.feeamount
when f.feeamount is null and f2.feeamount is null and f3.feeamount is null and f4.feeamount is null and f5.feeamount is null and f6.feeamount is null and f7.feeamount is null and f8.feeamount is null THEN f9.feeamount
when f.feeamount is null and f2.feeamount is null and f3.feeamount is null and f4.feeamount is null and f5.feeamount is null and f6.feeamount is null and f7.feeamount is null THEN f8.feeamount
when f.feeamount is null and f2.feeamount is null and f3.feeamount is null and f4.feeamount is null and f5.feeamount is null and f6.feeamount is null THEN f7.feeamount
when f.feeamount is null and f2.feeamount is null and f3.feeamount is null and f4.feeamount is null and f5.feeamount is null THEN f6.feeamount
when f.feeamount is null and f2.feeamount is null and f3.feeamount is null and f4.feeamount is null THEN f5.feeamount
when f.feeamount is null and f2.feeamount is null and f3.feeamount is null THEN f4.feeamount
when f.feeamount is null and f2.feeamount is null THEN f3.feeamount
when f.feeamount is null THEN f2.feeamount
ELSE f.feeamount end
,[EQUIV_allow_compare] = case 
when f.feeamount is null and f2.feeamount is null and f3.feeamount is null and f4.feeamount is null and f5.feeamount is null and f6.feeamount is null and f7.feeamount is null and f8.feeamount is null and f9.feeamount is null and f10.feeamount is null and f11.feeamount is null and f12.feeamount is null and f13.feeamount is null THEN f14.feeamount
when f.feeamount is null and f2.feeamount is null and f3.feeamount is null and f4.feeamount is null and f5.feeamount is null and f6.feeamount is null and f7.feeamount is null and f8.feeamount is null and f9.feeamount is null and f10.feeamount is null and f11.feeamount is null and f12.feeamount is null THEN f13.feeamount 
when f.feeamount is null and f2.feeamount is null and f3.feeamount is null and f4.feeamount is null and f5.feeamount is null and f6.feeamount is null and f7.feeamount is null and f8.feeamount is null and f9.feeamount is null and f10.feeamount is null and f11.feeamount is null THEN f12.feeamount
when f.feeamount is null and f2.feeamount is null and f3.feeamount is null and f4.feeamount is null and f5.feeamount is null and f6.feeamount is null and f7.feeamount is null and f8.feeamount is null and f9.feeamount is null and f10.feeamount is null THEN f11.feeamount
when f.feeamount is null and f2.feeamount is null and f3.feeamount is null and f4.feeamount is null and f5.feeamount is null and f6.feeamount is null and f7.feeamount is null and f8.feeamount is null and f9.feeamount is null THEN f10.feeamount
when f.feeamount is null and f2.feeamount is null and f3.feeamount is null and f4.feeamount is null and f5.feeamount is null and f6.feeamount is null and f7.feeamount is null and f8.feeamount is null THEN f9.feeamount
when f.feeamount is null and f2.feeamount is null and f3.feeamount is null and f4.feeamount is null and f5.feeamount is null and f6.feeamount is null and f7.feeamount is null THEN f8.feeamount
when f.feeamount is null and f2.feeamount is null and f3.feeamount is null and f4.feeamount is null and f5.feeamount is null and f6.feeamount is null THEN f7.feeamount
when f.feeamount is null and f2.feeamount is null and f3.feeamount is null and f4.feeamount is null and f5.feeamount is null THEN f6.feeamount
when f.feeamount is null and f2.feeamount is null and f3.feeamount is null and f4.feeamount is null THEN f5.feeamount
when f.feeamount is null and f2.feeamount is null and f3.feeamount is null THEN f4.feeamount
when f.feeamount is null and f2.feeamount is null THEN f3.feeamount
when f.feeamount is null THEN f2.feeamount
ELSE f.feeamount end   * (CASE WHEN md.paypercent is null THEN 1 ELSE md.paypercent/100 end) * 
(CASE WHEN md2.paypercent is null THEN 1 ELSE md2.paypercent/100 end) * 
(CASE WHEN md3.paypercent is null THEN 1 ELSE md3.paypercent/100 end) * 
(CASE WHEN md4.paypercent is null THEN 1 ELSE md4.paypercent/100 end) * 
(CASE WHEN md5.paypercent is null THEN 1 ELSE md5.paypercent/100 end) -- as totalmoddiscount -- [Modifier Discount]
 * su.servunits
-- SELECT TOP 10 * ci.contracted,sip.ProviderParStatus,ci.*,sip.* -- CHECK 1st
-- SELECT DISTINCT contracted,iscapitated FROM HMOPROD_PLANDATA.dbo.contractinfo -- CHECK 1st
FROM INFORMATICS.dbo.GENDERAx AS su
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
-- FROM #temp AS db -- [Fee Schedule Join]
	LEFT JOIN hmoprod_plandata.dbo.feetable AS f ON su.servcode = f.mincodeid
		AND su.modcode = f.modcode
		AND su.modcode2 = f.modcode2
		AND su.location = f.locationcode
		and f.feetableid = 'C00727442' 
		and f.termdate = '12/31/2078'
	LEFT JOIN hmoprod_plandata.dbo.feetable AS f2 ON su.servcode = f2.mincodeid
		AND su.modcode = f2.modcode
		AND su.modcode2 = f.modcode2  
		and  f2.locationcode = '' 
		and f2.feetableid = 'C00727442' 
		and f2.termdate = '12/31/2078'
	LEFT JOIN hmoprod_plandata.dbo.feetable AS f3 ON su.servcode = f3.mincodeid
		AND su.modcode = f3.modcode2
		AND su.modcode2 = f3.modcode
		AND su.location = f3.locationcode 
		and f3.feetableid = 'C00727442' 
		and f3.termdate = '12/31/2078'
	LEFT JOIN hmoprod_plandata.dbo.feetable AS f4 ON su.servcode = f4.mincodeid
		AND su.modcode = f4.modcode2
		AND su.modcode2 = f4.modcode
		and  f4.locationcode = '' 
		and f4.feetableid = 'C00727442' 
		and f4.termdate = '12/31/2078'
	LEFT JOIN hmoprod_plandata.dbo.feetable AS f5 ON su.servcode = f5.mincodeid
		AND su.modcode = f5.modcode
		AND su.location = f5.locationcode
		and f5.feetableid = 'C00727442' 
		and f5.termdate = '12/31/2078'
	LEFT JOIN hmoprod_plandata.dbo.feetable AS f6 ON su.servcode = f6.mincodeid
		AND su.modcode = f6.modcode
		and  f6.locationcode = '' 
		and f6.feetableid = 'C00727442' 
		and f6.termdate = '12/31/2078'
	LEFT JOIN hmoprod_plandata.dbo.feetable AS f7 ON su.servcode = f7.mincodeid
		AND su.modcode2 = f7.modcode
		AND su.location = f7.locationcode  
		and f7.feetableid = 'C00727442' 
		and f7.termdate = '12/31/2078'
	LEFT JOIN hmoprod_plandata.dbo.feetable AS f8 ON su.servcode = f8.mincodeid
		AND su.modcode2 = f8.modcode
		and  f8.locationcode = '' 
		and f8.feetableid = 'C00727442' 
		and f8.termdate = '12/31/2078'
	LEFT JOIN hmoprod_plandata.dbo.feetable AS f9 ON su.servcode = f9.mincodeid
		AND su.modcode3 = f9.modcode
		AND su.location = f9.locationcode
		and f9.feetableid = 'C00727442' 
		and f9.termdate = '12/31/2078'
	LEFT JOIN hmoprod_plandata.dbo.feetable AS f10 ON su.servcode = f10.mincodeid
		AND su.modcode3 = f10.modcode 
		and  f10.locationcode = '' 
		and f10.feetableid = 'C00727442' 
		and f10.termdate = '12/31/2078'
	LEFT JOIN hmoprod_plandata.dbo.feetable AS f11 ON su.servcode = f11.mincodeid
		AND su.modcode4 = f11.modcode
		AND su.location = f11.locationcode  
		and f11.feetableid = 'C00727442' 
		and f11.termdate = '12/31/2078'
	LEFT JOIN hmoprod_plandata.dbo.feetable AS f12 ON su.servcode = f12.mincodeid
		AND su.modcode4 = f12.modcode
		and  f12.locationcode = '' 
		and f12.feetableid = 'C00727442' 
		and f12.termdate = '12/31/2078'
	LEFT JOIN hmoprod_plandata.dbo.feetable AS f13 ON su.servcode = f13.mincodeid
		AND su.modcode5 = f13.modcode
		AND su.location = f13.locationcode  
		and f13.feetableid = 'C00727442' 
		and f13.termdate = '12/31/2078'
	LEFT JOIN hmoprod_plandata.dbo.feetable AS f14 ON su.servcode = f14.mincodeid
		AND su.modcode5 = f14.modcode
		and  f14.locationcode = '' 
		and f14.feetableid = 'C00727442' 
		and f14.termdate = '12/31/2078'
	LEFT JOIN hmoprod_plandata.dbo.feetable AS f15 ON su.servcode = f15.mincodeid
		AND su.modcode = f15.modcode
		AND su.modcode2 = f15.modcode2
		and f15.feetableid = 'C01011396'
		and f15.termdate = '12/31/2078'
	LEFT JOIN hmoprod_plandata.dbo.feetable AS f16 ON su.servcode = f16.mincodeid
		AND su.modcode2 = f16.modcode
		AND su.modcode = f16.modcode2
		and f16.feetableid = 'C01011396'
		and f16.termdate = '12/31/2078'
	LEFT JOIN hmoprod_plandata.dbo.feetable AS f17 ON su.servcode = f17.mincodeid
		AND su.modcode = f17.modcode
		and f17.modcode2 = '' 
		and f17.feetableid = 'C01011396'
		and f17.termdate = '12/31/2078'
	LEFT JOIN hmoprod_plandata.dbo.feetable AS f18 ON su.servcode = f18.mincodeid
		AND su.modcode2 = f18.modcode
		and f18.modcode2 = '' 
		and f18.feetableid = 'C01011396'
		and f18.termdate = '12/31/2078'
	LEFT JOIN hmoprod_plandata.dbo.feetable AS f19 ON su.servcode = f19.mincodeid
		AND su.modcode3 = f19.modcode
		and f19.modcode2 = '' 
		and f19.feetableid = 'C01011396'
		and f19.termdate = '12/31/2078'
	LEFT JOIN hmoprod_plandata.dbo.feetable AS f20 ON su.servcode = f20.mincodeid
		AND su.modcode4 = f20.modcode
		and f20.modcode2 = '' 
		and f20.feetableid = 'C01011396'
		and f20.termdate = '12/31/2078'
	LEFT JOIN hmoprod_plandata.dbo.feetable AS f21 ON su.servcode = f21.mincodeid
		AND su.modcode5  = f21.modcode
		and f21.modcode2 = '' 
		and f21.feetableid = 'C01011396'
		and f21.termdate = '12/31/2078'
	LEFT JOIN hmoprod_plandata.dbo.feetable AS f22 ON su.servcode = f22.mincodeid
		and f22.modcode = '' 
		and f22.modcode2 = '' 
		and f22.feetableid = 'C01011396'
		and f22.termdate = '12/31/2078'
	LEFT JOIN hmoprod_plandata.dbo.feetable AS f23 ON su.servcode = f23.mincodeid
		AND su.modcode = f23.modcode
		and f23.feetableid = 'C01011396'
		and f23.termdate = '12/31/2078'
WHERE su.formtype LIKE '%UB%'







UPDATE INFORMATICS.dbo.GENDERAx
SET [mcr_allow_rate] = case 
when f.feeamount is null and f2.feeamount is null and f3.feeamount is null and f4.feeamount is null and f5.feeamount is null and f6.feeamount is null and f7.feeamount is null and f8.feeamount is null and f9.feeamount is null and f10.feeamount is null and f11.feeamount is null and f12.feeamount is null and f13.feeamount is null THEN f14.feeamount
when f.feeamount is null and f2.feeamount is null and f3.feeamount is null and f4.feeamount is null and f5.feeamount is null and f6.feeamount is null and f7.feeamount is null and f8.feeamount is null and f9.feeamount is null and f10.feeamount is null and f11.feeamount is null and f12.feeamount is null THEN f13.feeamount 
when f.feeamount is null and f2.feeamount is null and f3.feeamount is null and f4.feeamount is null and f5.feeamount is null and f6.feeamount is null and f7.feeamount is null and f8.feeamount is null and f9.feeamount is null and f10.feeamount is null and f11.feeamount is null THEN f12.feeamount
when f.feeamount is null and f2.feeamount is null and f3.feeamount is null and f4.feeamount is null and f5.feeamount is null and f6.feeamount is null and f7.feeamount is null and f8.feeamount is null and f9.feeamount is null and f10.feeamount is null THEN f11.feeamount
when f.feeamount is null and f2.feeamount is null and f3.feeamount is null and f4.feeamount is null and f5.feeamount is null and f6.feeamount is null and f7.feeamount is null and f8.feeamount is null and f9.feeamount is null THEN f10.feeamount
when f.feeamount is null and f2.feeamount is null and f3.feeamount is null and f4.feeamount is null and f5.feeamount is null and f6.feeamount is null and f7.feeamount is null and f8.feeamount is null THEN f9.feeamount
when f.feeamount is null and f2.feeamount is null and f3.feeamount is null and f4.feeamount is null and f5.feeamount is null and f6.feeamount is null and f7.feeamount is null THEN f8.feeamount
when f.feeamount is null and f2.feeamount is null and f3.feeamount is null and f4.feeamount is null and f5.feeamount is null and f6.feeamount is null THEN f7.feeamount
when f.feeamount is null and f2.feeamount is null and f3.feeamount is null and f4.feeamount is null and f5.feeamount is null THEN f6.feeamount
when f.feeamount is null and f2.feeamount is null and f3.feeamount is null and f4.feeamount is null THEN f5.feeamount
when f.feeamount is null and f2.feeamount is null and f3.feeamount is null THEN f4.feeamount
when f.feeamount is null and f2.feeamount is null THEN f3.feeamount
when f.feeamount is null THEN f2.feeamount
ELSE f.feeamount end
,[mcr_allow_compare] = case 
when f.feeamount is null and f2.feeamount is null and f3.feeamount is null and f4.feeamount is null and f5.feeamount is null and f6.feeamount is null and f7.feeamount is null and f8.feeamount is null and f9.feeamount is null and f10.feeamount is null and f11.feeamount is null and f12.feeamount is null and f13.feeamount is null THEN f14.feeamount
when f.feeamount is null and f2.feeamount is null and f3.feeamount is null and f4.feeamount is null and f5.feeamount is null and f6.feeamount is null and f7.feeamount is null and f8.feeamount is null and f9.feeamount is null and f10.feeamount is null and f11.feeamount is null and f12.feeamount is null THEN f13.feeamount 
when f.feeamount is null and f2.feeamount is null and f3.feeamount is null and f4.feeamount is null and f5.feeamount is null and f6.feeamount is null and f7.feeamount is null and f8.feeamount is null and f9.feeamount is null and f10.feeamount is null and f11.feeamount is null THEN f12.feeamount
when f.feeamount is null and f2.feeamount is null and f3.feeamount is null and f4.feeamount is null and f5.feeamount is null and f6.feeamount is null and f7.feeamount is null and f8.feeamount is null and f9.feeamount is null and f10.feeamount is null THEN f11.feeamount
when f.feeamount is null and f2.feeamount is null and f3.feeamount is null and f4.feeamount is null and f5.feeamount is null and f6.feeamount is null and f7.feeamount is null and f8.feeamount is null and f9.feeamount is null THEN f10.feeamount
when f.feeamount is null and f2.feeamount is null and f3.feeamount is null and f4.feeamount is null and f5.feeamount is null and f6.feeamount is null and f7.feeamount is null and f8.feeamount is null THEN f9.feeamount
when f.feeamount is null and f2.feeamount is null and f3.feeamount is null and f4.feeamount is null and f5.feeamount is null and f6.feeamount is null and f7.feeamount is null THEN f8.feeamount
when f.feeamount is null and f2.feeamount is null and f3.feeamount is null and f4.feeamount is null and f5.feeamount is null and f6.feeamount is null THEN f7.feeamount
when f.feeamount is null and f2.feeamount is null and f3.feeamount is null and f4.feeamount is null and f5.feeamount is null THEN f6.feeamount
when f.feeamount is null and f2.feeamount is null and f3.feeamount is null and f4.feeamount is null THEN f5.feeamount
when f.feeamount is null and f2.feeamount is null and f3.feeamount is null THEN f4.feeamount
when f.feeamount is null and f2.feeamount is null THEN f3.feeamount
when f.feeamount is null THEN f2.feeamount
ELSE f.feeamount end 
* (CASE WHEN md.paypercent is null THEN 1 ELSE md.paypercent/100 end) * 
(CASE WHEN md2.paypercent is null THEN 1 ELSE md2.paypercent/100 end) * 
(CASE WHEN md3.paypercent is null THEN 1 ELSE md3.paypercent/100 end) * 
(CASE WHEN md4.paypercent is null THEN 1 ELSE md4.paypercent/100 end) * 
(CASE WHEN md5.paypercent is null THEN 1 ELSE md5.paypercent/100 end) -- as totalmoddiscount -- [Modifier Discount]
 * su.servunits
-- SELECT TOP 10 * ci.contracted,sip.ProviderParStatus,ci.*,sip.* -- CHECK 1st
-- SELECT DISTINCT contracted,iscapitated FROM HMOPROD_PLANDATA.dbo.contractinfo -- CHECK 1st
FROM INFORMATICS.dbo.GENDERAx AS su
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
-- FROM #temp AS db -- [Fee Schedule Join]
	LEFT JOIN hmoprod_plandata.dbo.feetable AS f ON su.servcode = f.mincodeid
		AND su.modcode = f.modcode
		AND su.modcode2 = f.modcode2
		AND su.location = f.locationcode
		and f.feetableid = 'C00740459' 
		and f.termdate = '12/31/2078'
	LEFT JOIN hmoprod_plandata.dbo.feetable AS f2 ON su.servcode = f2.mincodeid
		AND su.modcode = f2.modcode
		AND su.modcode2 = f.modcode2  
		and  f2.locationcode = '' 
		and f2.feetableid = 'C00740459' 
		and f2.termdate = '12/31/2078'
	LEFT JOIN hmoprod_plandata.dbo.feetable AS f3 ON su.servcode = f3.mincodeid
		AND su.modcode = f3.modcode2
		AND su.modcode2 = f3.modcode
		AND su.location = f3.locationcode 
		and f3.feetableid = 'C00740459' 
		and f3.termdate = '12/31/2078'
	LEFT JOIN hmoprod_plandata.dbo.feetable AS f4 ON su.servcode = f4.mincodeid
		AND su.modcode = f4.modcode2
		AND su.modcode2 = f4.modcode
		and  f4.locationcode = '' 
		and f4.feetableid = 'C00740459' 
		and f4.termdate = '12/31/2078'
	LEFT JOIN hmoprod_plandata.dbo.feetable AS f5 ON su.servcode = f5.mincodeid
		AND su.modcode = f5.modcode
		AND su.location = f5.locationcode
		and f5.feetableid = 'C00740459' 
		and f5.termdate = '12/31/2078'
	LEFT JOIN hmoprod_plandata.dbo.feetable AS f6 ON su.servcode = f6.mincodeid
		AND su.modcode = f6.modcode
		and  f6.locationcode = '' 
		and f6.feetableid = 'C00740459' 
		and f6.termdate = '12/31/2078'
	LEFT JOIN hmoprod_plandata.dbo.feetable AS f7 ON su.servcode = f7.mincodeid
		AND su.modcode2 = f7.modcode
		AND su.location = f7.locationcode  
		and f7.feetableid = 'C00740459' 
		and f7.termdate = '12/31/2078'
	LEFT JOIN hmoprod_plandata.dbo.feetable AS f8 ON su.servcode = f8.mincodeid
		AND su.modcode2 = f8.modcode
		and  f8.locationcode = '' 
		and f8.feetableid = 'C00740459' 
		and f8.termdate = '12/31/2078'
	LEFT JOIN hmoprod_plandata.dbo.feetable AS f9 ON su.servcode = f9.mincodeid
		AND su.modcode3 = f9.modcode
		AND su.location = f9.locationcode
		and f9.feetableid = 'C00740459' 
		and f9.termdate = '12/31/2078'
	LEFT JOIN hmoprod_plandata.dbo.feetable AS f10 ON su.servcode = f10.mincodeid
		AND su.modcode3 = f10.modcode 
		and  f10.locationcode = '' 
		and f10.feetableid = 'C00740459' 
		and f10.termdate = '12/31/2078'
	LEFT JOIN hmoprod_plandata.dbo.feetable AS f11 ON su.servcode = f11.mincodeid
		AND su.modcode4 = f11.modcode
		AND su.location = f11.locationcode  
		and f11.feetableid = 'C00740459' 
		and f11.termdate = '12/31/2078'
	LEFT JOIN hmoprod_plandata.dbo.feetable AS f12 ON su.servcode = f12.mincodeid
		AND su.modcode4 = f12.modcode
		and  f12.locationcode = '' 
		and f12.feetableid = 'C00740459' 
		and f12.termdate = '12/31/2078'
	LEFT JOIN hmoprod_plandata.dbo.feetable AS f13 ON su.servcode = f13.mincodeid
		AND su.modcode5 = f13.modcode
		AND su.location = f13.locationcode  
		and f13.feetableid = 'C00740459' 
		and f13.termdate = '12/31/2078'
	LEFT JOIN hmoprod_plandata.dbo.feetable AS f14 ON su.servcode = f14.mincodeid
		AND su.modcode5 = f14.modcode
		and  f14.locationcode = '' 
		and f14.feetableid = 'C00740459' 
		and f14.termdate = '12/31/2078'
	LEFT JOIN hmoprod_plandata.dbo.feetable AS f15 ON su.servcode = f15.mincodeid
		AND su.modcode = f15.modcode
		AND su.modcode2 = f15.modcode2
		and f15.feetableid = 'C01011396'
		and f15.termdate = '12/31/2078'
	LEFT JOIN hmoprod_plandata.dbo.feetable AS f16 ON su.servcode = f16.mincodeid
		AND su.modcode2 = f16.modcode
		AND su.modcode = f16.modcode2
		and f16.feetableid = 'C01011396'
		and f16.termdate = '12/31/2078'
	LEFT JOIN hmoprod_plandata.dbo.feetable AS f17 ON su.servcode = f17.mincodeid
		AND su.modcode = f17.modcode
		and f17.modcode2 = '' 
		and f17.feetableid = 'C01011396'
		and f17.termdate = '12/31/2078'
	LEFT JOIN hmoprod_plandata.dbo.feetable AS f18 ON su.servcode = f18.mincodeid
		AND su.modcode2 = f18.modcode
		and f18.modcode2 = '' 
		and f18.feetableid = 'C01011396'
		and f18.termdate = '12/31/2078'
	LEFT JOIN hmoprod_plandata.dbo.feetable AS f19 ON su.servcode = f19.mincodeid
		AND su.modcode3 = f19.modcode
		and f19.modcode2 = '' 
		and f19.feetableid = 'C01011396'
		and f19.termdate = '12/31/2078'
	LEFT JOIN hmoprod_plandata.dbo.feetable AS f20 ON su.servcode = f20.mincodeid
		AND su.modcode4 = f20.modcode
		and f20.modcode2 = '' 
		and f20.feetableid = 'C01011396'
		and f20.termdate = '12/31/2078'
	LEFT JOIN hmoprod_plandata.dbo.feetable AS f21 ON su.servcode = f21.mincodeid
		AND su.modcode5  = f21.modcode
		and f21.modcode2 = '' 
		and f21.feetableid = 'C01011396'
		and f21.termdate = '12/31/2078'
	LEFT JOIN hmoprod_plandata.dbo.feetable AS f22 ON su.servcode = f22.mincodeid
		and f22.modcode = '' 
		and f22.modcode2 = '' 
		and f22.feetableid = 'C01011396'
		and f22.termdate = '12/31/2078'
	LEFT JOIN hmoprod_plandata.dbo.feetable AS f23 ON su.servcode = f23.mincodeid
		AND su.modcode = f23.modcode
		and f23.feetableid = 'C01011396'
		and f23.termdate = '12/31/2078'
WHERE su.formtype LIKE '%1500%'
	AND su.location IN ('02','11','12','20','50') -- •	Medicare POS = 02, 11, 12, 20, 50 - USE 'C01011396' AND FOR su.formtype LIKE '%1500%'•	Medicare – no fee schedule. Claims are priced with Hospital OP PPS pricer







UPDATE INFORMATICS.dbo.GENDERAx
SET [mcr_allow_rate] = case 
when f.feeamount is null and f2.feeamount is null and f3.feeamount is null and f4.feeamount is null and f5.feeamount is null and f6.feeamount is null and f7.feeamount is null and f8.feeamount is null and f9.feeamount is null and f10.feeamount is null and f11.feeamount is null and f12.feeamount is null and f13.feeamount is null THEN f14.feeamount
when f.feeamount is null and f2.feeamount is null and f3.feeamount is null and f4.feeamount is null and f5.feeamount is null and f6.feeamount is null and f7.feeamount is null and f8.feeamount is null and f9.feeamount is null and f10.feeamount is null and f11.feeamount is null and f12.feeamount is null THEN f13.feeamount 
when f.feeamount is null and f2.feeamount is null and f3.feeamount is null and f4.feeamount is null and f5.feeamount is null and f6.feeamount is null and f7.feeamount is null and f8.feeamount is null and f9.feeamount is null and f10.feeamount is null and f11.feeamount is null THEN f12.feeamount
when f.feeamount is null and f2.feeamount is null and f3.feeamount is null and f4.feeamount is null and f5.feeamount is null and f6.feeamount is null and f7.feeamount is null and f8.feeamount is null and f9.feeamount is null and f10.feeamount is null THEN f11.feeamount
when f.feeamount is null and f2.feeamount is null and f3.feeamount is null and f4.feeamount is null and f5.feeamount is null and f6.feeamount is null and f7.feeamount is null and f8.feeamount is null and f9.feeamount is null THEN f10.feeamount
when f.feeamount is null and f2.feeamount is null and f3.feeamount is null and f4.feeamount is null and f5.feeamount is null and f6.feeamount is null and f7.feeamount is null and f8.feeamount is null THEN f9.feeamount
when f.feeamount is null and f2.feeamount is null and f3.feeamount is null and f4.feeamount is null and f5.feeamount is null and f6.feeamount is null and f7.feeamount is null THEN f8.feeamount
when f.feeamount is null and f2.feeamount is null and f3.feeamount is null and f4.feeamount is null and f5.feeamount is null and f6.feeamount is null THEN f7.feeamount
when f.feeamount is null and f2.feeamount is null and f3.feeamount is null and f4.feeamount is null and f5.feeamount is null THEN f6.feeamount
when f.feeamount is null and f2.feeamount is null and f3.feeamount is null and f4.feeamount is null THEN f5.feeamount
when f.feeamount is null and f2.feeamount is null and f3.feeamount is null THEN f4.feeamount
when f.feeamount is null and f2.feeamount is null THEN f3.feeamount
when f.feeamount is null THEN f2.feeamount
ELSE f.feeamount end
,[mcr_allow_compare] = case 
when f.feeamount is null and f2.feeamount is null and f3.feeamount is null and f4.feeamount is null and f5.feeamount is null and f6.feeamount is null and f7.feeamount is null and f8.feeamount is null and f9.feeamount is null and f10.feeamount is null and f11.feeamount is null and f12.feeamount is null and f13.feeamount is null THEN f14.feeamount
when f.feeamount is null and f2.feeamount is null and f3.feeamount is null and f4.feeamount is null and f5.feeamount is null and f6.feeamount is null and f7.feeamount is null and f8.feeamount is null and f9.feeamount is null and f10.feeamount is null and f11.feeamount is null and f12.feeamount is null THEN f13.feeamount 
when f.feeamount is null and f2.feeamount is null and f3.feeamount is null and f4.feeamount is null and f5.feeamount is null and f6.feeamount is null and f7.feeamount is null and f8.feeamount is null and f9.feeamount is null and f10.feeamount is null and f11.feeamount is null THEN f12.feeamount
when f.feeamount is null and f2.feeamount is null and f3.feeamount is null and f4.feeamount is null and f5.feeamount is null and f6.feeamount is null and f7.feeamount is null and f8.feeamount is null and f9.feeamount is null and f10.feeamount is null THEN f11.feeamount
when f.feeamount is null and f2.feeamount is null and f3.feeamount is null and f4.feeamount is null and f5.feeamount is null and f6.feeamount is null and f7.feeamount is null and f8.feeamount is null and f9.feeamount is null THEN f10.feeamount
when f.feeamount is null and f2.feeamount is null and f3.feeamount is null and f4.feeamount is null and f5.feeamount is null and f6.feeamount is null and f7.feeamount is null and f8.feeamount is null THEN f9.feeamount
when f.feeamount is null and f2.feeamount is null and f3.feeamount is null and f4.feeamount is null and f5.feeamount is null and f6.feeamount is null and f7.feeamount is null THEN f8.feeamount
when f.feeamount is null and f2.feeamount is null and f3.feeamount is null and f4.feeamount is null and f5.feeamount is null and f6.feeamount is null THEN f7.feeamount
when f.feeamount is null and f2.feeamount is null and f3.feeamount is null and f4.feeamount is null and f5.feeamount is null THEN f6.feeamount
when f.feeamount is null and f2.feeamount is null and f3.feeamount is null and f4.feeamount is null THEN f5.feeamount
when f.feeamount is null and f2.feeamount is null and f3.feeamount is null THEN f4.feeamount
when f.feeamount is null and f2.feeamount is null THEN f3.feeamount
when f.feeamount is null THEN f2.feeamount
ELSE f.feeamount end   * (CASE WHEN md.paypercent is null THEN 1 ELSE md.paypercent/100 end) * 
(CASE WHEN md2.paypercent is null THEN 1 ELSE md2.paypercent/100 end) * 
(CASE WHEN md3.paypercent is null THEN 1 ELSE md3.paypercent/100 end) * 
(CASE WHEN md4.paypercent is null THEN 1 ELSE md4.paypercent/100 end) * 
(CASE WHEN md5.paypercent is null THEN 1 ELSE md5.paypercent/100 end) -- as totalmoddiscount -- [Modifier Discount]
 * su.servunits
-- SELECT TOP 10 * ci.contracted,sip.ProviderParStatus,ci.*,sip.* -- CHECK 1st
-- SELECT DISTINCT contracted,iscapitated FROM HMOPROD_PLANDATA.dbo.contractinfo -- CHECK 1st
FROM INFORMATICS.dbo.GENDERAx AS su
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
-- FROM #temp AS db -- [Fee Schedule Join]
	LEFT JOIN hmoprod_plandata.dbo.feetable AS f ON su.servcode = f.mincodeid
		AND su.modcode = f.modcode
		AND su.modcode2 = f.modcode2
		AND su.location = f.locationcode
		and f.feetableid = 'C00740459' 
		and f.termdate = '12/31/2078'
	LEFT JOIN hmoprod_plandata.dbo.feetable AS f2 ON su.servcode = f2.mincodeid
		AND su.modcode = f2.modcode
		AND su.modcode2 = f.modcode2  
		and  f2.locationcode = '' 
		and f2.feetableid = 'C00740459' 
		and f2.termdate = '12/31/2078'
	LEFT JOIN hmoprod_plandata.dbo.feetable AS f3 ON su.servcode = f3.mincodeid
		AND su.modcode = f3.modcode2
		AND su.modcode2 = f3.modcode
		AND su.location = f3.locationcode 
		and f3.feetableid = 'C00740459' 
		and f3.termdate = '12/31/2078'
	LEFT JOIN hmoprod_plandata.dbo.feetable AS f4 ON su.servcode = f4.mincodeid
		AND su.modcode = f4.modcode2
		AND su.modcode2 = f4.modcode
		and  f4.locationcode = '' 
		and f4.feetableid = 'C00740459' 
		and f4.termdate = '12/31/2078'
	LEFT JOIN hmoprod_plandata.dbo.feetable AS f5 ON su.servcode = f5.mincodeid
		AND su.modcode = f5.modcode
		AND su.location = f5.locationcode
		and f5.feetableid = 'C00740459' 
		and f5.termdate = '12/31/2078'
	LEFT JOIN hmoprod_plandata.dbo.feetable AS f6 ON su.servcode = f6.mincodeid
		AND su.modcode = f6.modcode
		and  f6.locationcode = '' 
		and f6.feetableid = 'C00740459' 
		and f6.termdate = '12/31/2078'
	LEFT JOIN hmoprod_plandata.dbo.feetable AS f7 ON su.servcode = f7.mincodeid
		AND su.modcode2 = f7.modcode
		AND su.location = f7.locationcode  
		and f7.feetableid = 'C00740459' 
		and f7.termdate = '12/31/2078'
	LEFT JOIN hmoprod_plandata.dbo.feetable AS f8 ON su.servcode = f8.mincodeid
		AND su.modcode2 = f8.modcode
		and  f8.locationcode = '' 
		and f8.feetableid = 'C00740459' 
		and f8.termdate = '12/31/2078'
	LEFT JOIN hmoprod_plandata.dbo.feetable AS f9 ON su.servcode = f9.mincodeid
		AND su.modcode3 = f9.modcode
		AND su.location = f9.locationcode
		and f9.feetableid = 'C00740459' 
		and f9.termdate = '12/31/2078'
	LEFT JOIN hmoprod_plandata.dbo.feetable AS f10 ON su.servcode = f10.mincodeid
		AND su.modcode3 = f10.modcode 
		and  f10.locationcode = '' 
		and f10.feetableid = 'C00740459' 
		and f10.termdate = '12/31/2078'
	LEFT JOIN hmoprod_plandata.dbo.feetable AS f11 ON su.servcode = f11.mincodeid
		AND su.modcode4 = f11.modcode
		AND su.location = f11.locationcode  
		and f11.feetableid = 'C00740459' 
		and f11.termdate = '12/31/2078'
	LEFT JOIN hmoprod_plandata.dbo.feetable AS f12 ON su.servcode = f12.mincodeid
		AND su.modcode4 = f12.modcode
		and  f12.locationcode = '' 
		and f12.feetableid = 'C00740459' 
		and f12.termdate = '12/31/2078'
	LEFT JOIN hmoprod_plandata.dbo.feetable AS f13 ON su.servcode = f13.mincodeid
		AND su.modcode5 = f13.modcode
		AND su.location = f13.locationcode  
		and f13.feetableid = 'C00740459' 
		and f13.termdate = '12/31/2078'
	LEFT JOIN hmoprod_plandata.dbo.feetable AS f14 ON su.servcode = f14.mincodeid
		AND su.modcode5 = f14.modcode
		and  f14.locationcode = '' 
		and f14.feetableid = 'C00740459' 
		and f14.termdate = '12/31/2078'
	LEFT JOIN hmoprod_plandata.dbo.feetable AS f15 ON su.servcode = f15.mincodeid
		AND su.modcode = f15.modcode
		AND su.modcode2 = f15.modcode2
		and f15.feetableid = 'C01011395'
		and f15.termdate = '12/31/2078'
	LEFT JOIN hmoprod_plandata.dbo.feetable AS f16 ON su.servcode = f16.mincodeid
		AND su.modcode2 = f16.modcode
		AND su.modcode = f16.modcode2
		and f16.feetableid = 'C01011395'
		and f16.termdate = '12/31/2078'
	LEFT JOIN hmoprod_plandata.dbo.feetable AS f17 ON su.servcode = f17.mincodeid
		AND su.modcode = f17.modcode
		and f17.modcode2 = '' 
		and f17.feetableid = 'C01011395'
		and f17.termdate = '12/31/2078'
	LEFT JOIN hmoprod_plandata.dbo.feetable AS f18 ON su.servcode = f18.mincodeid
		AND su.modcode2 = f18.modcode
		and f18.modcode2 = '' 
		and f18.feetableid = 'C01011395'
		and f18.termdate = '12/31/2078'
	LEFT JOIN hmoprod_plandata.dbo.feetable AS f19 ON su.servcode = f19.mincodeid
		AND su.modcode3 = f19.modcode
		and f19.modcode2 = '' 
		and f19.feetableid = 'C01011395'
		and f19.termdate = '12/31/2078'
	LEFT JOIN hmoprod_plandata.dbo.feetable AS f20 ON su.servcode = f20.mincodeid
		AND su.modcode4 = f20.modcode
		and f20.modcode2 = '' 
		and f20.feetableid = 'C01011395'
		and f20.termdate = '12/31/2078'
	LEFT JOIN hmoprod_plandata.dbo.feetable AS f21 ON su.servcode = f21.mincodeid
		AND su.modcode5  = f21.modcode
		and f21.modcode2 = '' 
		and f21.feetableid = 'C01011395'
		and f21.termdate = '12/31/2078'
	LEFT JOIN hmoprod_plandata.dbo.feetable AS f22 ON su.servcode = f22.mincodeid
		and f22.modcode = '' 
		and f22.modcode2 = '' 
		and f22.feetableid = 'C01011395'
		and f22.termdate = '12/31/2078'
	LEFT JOIN hmoprod_plandata.dbo.feetable AS f23 ON su.servcode = f23.mincodeid
		AND su.modcode = f23.modcode
		and f23.feetableid = 'C01011395'
		and f23.termdate = '12/31/2078'
WHERE su.formtype LIKE '%1500%'
	AND ISNULL(su.location,'') NOT IN ('02','11','12','20','50') -- •	Medicare POS <> 02, 11, 12, 20, 50 - USE 'C01011395' AND FOR su.formtype LIKE '%1500%'•	Medicare – no fee schedule. Claims are priced with Hospital OP PPS pricer
	
	
	
	
	
	
	
-- ================================================
	-- GENERAL FEE SCHEDULE(s) REVIEW() / EQUIVALENT() --
-- ================================================
UPDATE INFORMATICS.dbo.GENDERAx
SET [MedicareRate] = equivalent.feeamount
-- SELECT TOP 10 * ci.contracted,sip.ProviderParStatus,ci.*,sip.* -- CHECK 1st
-- SELECT DISTINCT contracted,iscapitated FROM HMOPROD_PLANDATA.dbo.contractinfo -- CHECK 1st
FROM INFORMATICS.dbo.GENDERAx AS su
	JOIN 
	( -- INITIATE ...
	SELECT 'see "GENDER RE - Ax" MEDICARE EQUIV' AS [NOTE(S)],*
	FROM 
	( -- INITIATE ...
	SELECT DISTINCT @whensf AS [EST BASELINE effdate],ft.effdate
	,RANK() OVER (PARTITION BY sf.description ORDER BY CAST(ft.effdate AS date) DESC) AS [RANKis]
	,ft.feetableid,sf.description AS [FEE SCHEDULE],ft.category,codeset.*,ft.modcode,ft.feeamount -- ,sf.*,ft.*
	-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
	-- SELECT DISTINCT sf.feetype,sf.description,ft.category -- CHECK 1st
	FROM HMOPROD_PLANDATA.dbo.standardfee AS sf
		JOIN HMOPROD_PLANDATA.dbo.feetable AS ft ON sf.feeid = ft.feetableid
		JOIN 
		( -- INITIATE ...
		SELECT DISTINCT [ID],[Description]
		-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
		-- SELECT DISTINCT ft.category -- CHECK 1st
		FROM INFORMATICS.dbo.GenderAxCodes AS gac -- MANUAL UPLOAD see "Gender Re-assignment Codes and Procedures 07192021.xls"
		) -- CONCLUDE ...
		AS codeset ON SUBSTRING(UPPER(LTRIM(RTRIM(ISNULL(ft.mincodeid,'')))),1,5) = SUBSTRING(UPPER(LTRIM(RTRIM(ISNULL(codeset.[ID],'')))),1,5)

	-- WHERE ft.category LIKE '%RU%'	
	WHERE UPPER(LTRIM(RTRIM(ISNULL(sf.feeid,'')))) LIKE @schedid -- DEFINE / SELECT DESIRED SCHEDULE
		-- AND CAST(ISNULL(ft.effdate,CAST(GETDATE() AS date)) AS date) >= @whensf -- AS OF ...
		AND sf.description LIKE @feeschedulename

	) -- CONCLUDE ...
	AS equiv
	WHERE equiv.[RANKis] = 1
	) -- CONCLUDE ...
	AS equivalent ON SUBSTRING(UPPER(LTRIM(RTRIM(ISNULL(su.[CPT Service Code],'')))),1,5) = SUBSTRING(UPPER(LTRIM(RTRIM(ISNULL(equivalent.[ID],'')))),1,5)
		AND ISNULL(su.modcode,'') = ISNULL(equivalent.modcode,'')

UPDATE INFORMATICS.dbo.GENDERAx
SET [MediCalRate] = equivalent.feeamount
-- SELECT TOP 10 * ci.contracted,sip.ProviderParStatus,ci.*,sip.* -- CHECK 1st
-- SELECT DISTINCT contracted,iscapitated FROM HMOPROD_PLANDATA.dbo.contractinfo -- CHECK 1st
FROM INFORMATICS.dbo.GENDERAx AS su
	JOIN
	( -- INITIATE ...
	SELECT 'see "GENDER RE - Ax" MCAL EQUIV' AS [NOTE(S)],*
	FROM 
	( -- INITIATE ...
	SELECT DISTINCT @whensf AS [EST BASELINE effdate],ft.effdate
	,RANK() OVER (PARTITION BY sf.description ORDER BY CAST(ft.effdate AS date) DESC) AS [RANKis]
	,ft.feetableid,sf.description AS [FEE SCHEDULE],ft.category,codeset.*,ft.modcode,ft.feeamount -- ,sf.*,ft.*
	-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
	-- SELECT DISTINCT sf.feetype,sf.description,ft.category -- CHECK 1st
	FROM HMOPROD_PLANDATA.dbo.standardfee AS sf
		JOIN HMOPROD_PLANDATA.dbo.feetable AS ft ON sf.feeid = ft.feetableid
		JOIN 
		( -- INITIATE ...
		SELECT DISTINCT [ID],[Description]
		-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
		-- SELECT DISTINCT ft.category -- CHECK 1st
		FROM INFORMATICS.dbo.GenderAxCodes AS gac -- MANUAL UPLOAD see "Gender Re-assignment Codes and Procedures 07192021.xls"
		) -- CONCLUDE ...
		AS codeset ON SUBSTRING(UPPER(LTRIM(RTRIM(ISNULL(ft.mincodeid,'')))),1,5) = SUBSTRING(UPPER(LTRIM(RTRIM(ISNULL(codeset.[ID],'')))),1,5)
	WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ... AND ...
		-- AND ft.category LIKE '%RU%'	
		AND UPPER(LTRIM(RTRIM(ISNULL(sf.feeid,'')))) LIKE @schedid -- DEFINE / SELECT DESIRED SCHEDULE
		-- AND CAST(ISNULL(ft.effdate,CAST(GETDATE() AS date)) AS date) >= @whensf -- AS OF ...
		AND sf.description LIKE '%MCAL%'
	) -- CONCLUDE ...
	AS equiv
	WHERE equiv.[RANKis] = 1
	) -- CONCLUDE ...
	AS equivalent ON SUBSTRING(UPPER(LTRIM(RTRIM(ISNULL(su.[CPT Service Code],'')))),1,5) = SUBSTRING(UPPER(LTRIM(RTRIM(ISNULL(equivalent.[ID],'')))),1,5)
		AND ISNULL(su.modcode,'') = ISNULL(equivalent.modcode,'')

		-- SELECT TOP 10 * FROM HMOPROD_PLANDATA.dbo.standardfee AS sf
		-- SELECT TOP 10 * FROM HMOPROD_PLANDATA.dbo.feetable AS ft

UPDATE INFORMATICS.dbo.GENDERAx
SET [MedicareRateEquivalent] = [MedicareRate]*[QUANTITY]
 ,[MediCalRateEquivalent] = [MediCalRate]*[QUANTITY]
-- SELECT TOP 10 * ci.contracted,sip.ProviderParStatus,ci.*,sip.* -- CHECK 1st
-- SELECT DISTINCT contracted,iscapitated FROM HMOPROD_PLANDATA.dbo.contractinfo -- CHECK 1st
FROM INFORMATICS.dbo.GENDERAx AS su
