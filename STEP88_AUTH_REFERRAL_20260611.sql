-- =====================================================================
	-- UM REFERRALS | AUTH TEMPLATE: 
-- =====================================================================
JAH CHARINDEX() FIND() SEARCH() 'quser',attribute

			USE http://qnxt/QNXTALL/Web/UtilizationManagement/2/Main/App#/UmDocument/5874910/MemberDetail -- AUTHORIZATIONID: 4812921
			USE http://qnxt/QNXTALL/WebSpa/UmDocument/5874910/MemberDetail -- AUTHORIZATIONID: 4812921

SELECT 'http://qnxt/QNXTALL/WebSpa/UmDocument/'+''+LTRIM(RTRIM(r.referralid))+''+'/MemberDetail' AS 'MCLTC SAMPLE QNXT QA [PATH]' -- http://qnxt/QNXTALL/WebSpa/UmDocument/5874910/MemberDetail -- AUTHORIZATIONID: 4812921
,'http://qnxt/QNXTALL/Web/UtilizationManagement/2/Main/App#/UmDocument/' + + RTRIM(r.referralid) + + '/MemberDetail' AS 'QNXT Referral Link' 
,r.*
FROM HMOPROD_PLANDATA.dbo.referral AS r
WHERE 1=1
	AND r.referralid = 5874910

 SELECT ' ' AS 'SHOULD RETURN 0 ROWS - CHECK FOR SHARING OF [referralid]'
 ,r.referralid
 ,r.authorizationid,*
FROM HMOPROD_PLANDATA.dbo.referral AS r
	INNER JOIN
	( -- INITIATE ...
	SELECT dup.memid
	,dup.referralid
	FROM HMOPROD_PLANDATA.dbo.referral AS dup
	GROUP BY dup.memid,dup.referralid -- Duplication Driver 
	HAVING COUNT(1)>1 -- HAVING clause RESERVED for AGGREGATE(s) ... HAVING SUM(PAID_NET_AMT) != 0
	) -- CONCLUDE ... 
	AS dupa ON r.referralid = dupa.referralid

 SELECT  ' ' AS 'SHOULD RETURN 0 ROWS - CHECK FOR SHARING OF [authorizationid]'
 ,r.authorizationid
 ,r.referralid,*
FROM HMOPROD_PLANDATA.dbo.referral AS r
	INNER JOIN 
	( -- INITIATE ...
	SELECT dup.memid
	,dup.authorizationid
	FROM HMOPROD_PLANDATA.dbo.referral AS dup
	GROUP BY dup.memid,dup.authorizationid -- Duplication Driver 
	HAVING COUNT(1)>1 -- HAVING clause RESERVED for AGGREGATE(s) ... HAVING SUM(PAID_NET_AMT) != 0
	) -- CONCLUDE ... 
	AS dupa ON r.authorizationid = dupa.authorizationid

		SELECT ' ' AS 'Multiple Members per referralid - SHOULD RETURN 0 ROWS: '
		,referralid
		,COUNT(DISTINCT(ISNULL(memid,''))) AS '#'
		FROM HMOPROD_PLANDATA.dbo.referral AS r 
		GROUP BY referralid
		HAVING COUNT(DISTINCT(ISNULL(memid,''))) > 1

		SELECT ' ' AS 'Multiple authorizationids per referralid - SHOULD RETURN 0 ROWS: '
		,referralid
		,COUNT(DISTINCT(ISNULL(authorizationid,''))) AS '#'
		FROM HMOPROD_PLANDATA.dbo.referral AS r 
		GROUP BY referralid
		HAVING COUNT(DISTINCT(ISNULL(authorizationid,''))) > 1

		SELECT ' ' AS 'Multiple Members per authorizationid - SHOULD RETURN 0 ROWS: '
		,authorizationid
		,COUNT(DISTINCT(ISNULL(memid,''))) AS '#'
		FROM HMOPROD_PLANDATA.dbo.referral AS r 
		GROUP BY authorizationid
		HAVING COUNT(DISTINCT(ISNULL(memid,''))) > 1

		SELECT ' ' AS 'Multiple referralids per authorizationid - SHOULD RETURN 0 ROWS: '
		,authorizationid
		,COUNT(DISTINCT(ISNULL(referralid,''))) AS '#'
		FROM HMOPROD_PLANDATA.dbo.referral AS r 
		GROUP BY authorizationid
		HAVING COUNT(DISTINCT(ISNULL(referralid,''))) > 1

		SELECT ' ' AS 'SAMPLE - TRUE SHARING OF... FROM THE SOURCE: '
		,r.authorizationid
		,r.referralid
		,r.*
		FROM HMOPROD_PLANDATA.dbo.referral AS r
		WHERE 1=1
			AND r.authorizationid IN ('914970')

		SELECT ' ' AS 'SAMPLE - snowflake FALSE POSITIVE: '
		,r.authorizationid
		,r.referralid
		,r.*
		FROM HMOPROD_PLANDATA.dbo.referral AS r
		WHERE 1=1
			AND r.authorizationid IN ('5121809')

		USE [PATH]: http://chgtableau/#/workbooks/314/views AS [Server] - 'TABLEAU AUTH SCANS DEVELOPMENT'
		USE [PATH]: https://chgtableau.chgsd.com/#/workbooks/314/views - 'TABLEAU APP' / 'TABLEAU AUTH SCANS DEVELOPMENT'
		USE [PATH]: https://authscans.chg.com/authfileimport.aspx - 'DEPRECATED REPORT'

		⏎ 'TEAMS' ON 20250206 
				FROM MS CLAUDIA: 
						Referral Status:
						Accepted
						Declined
						Pending
						Outreach initiated
						Referral Loop Closed
 
		~ /* [Referral Status] */ may have multiple entries. For services the MCP must authorize, MCPs will begin updating ‘Referral Status’ after the authorization decision is made.  P.G. 11 of guidance  MCPs are required to track each ‘Referral Status’ separately by ‘Date of Referral Status Update’. MM/DD/YYYY format.
 
		SELECT ' ' AS 'IMPORT FROM "AddtnlDocs5.11_Request No. 11_AutoApproval_CPT list.xlsx"'
		,SUBSTRING(UPPER(LTRIM(RTRIM(ISNULL(CLEANID,'')))),1,5) AS [CPT Service Code],*
		,DENSE_RANK() OVER(PARTITION BY CLEANID ORDER BY [Auto-Auth category]) AS [RANKis]
		FROM INFORMATICS.dbo.AUTOAUTHLIST
		WHERE 1=1

		SELECT TOP 10 * FROM SQLPRODAPP02.EDW.dbo.uvwReferrals
		SELECT TOP 10 * FROM HMOPROD_PLANDATA.dbo.umdisposition -- see DISCHARGE OPTION(s)
		SELECT TOP 10 * FROM INFORMATICS.dbo.TABLEAU_AUTHSCANS

		SELECT ' ' AS 'OnlineBH',* 
		FROM HMOPROD_QCSIDB.dbo.quser 
		WHERE 1=1
			AND userid = 1178
		
		SELECT MAX(seendate) AS [MAXseen]
		,MAX(receiptdate) AS [MAXreceipt] 
		FROM SQLPRODAPP02.EDW.dbo.uvwReferrals AS vr 
		WHERE 1=1
			AND vr.seendate<= CAST(GETDATE() AS date)

-- SELECT TOP 10 * FROM HMOPROD_PLANDATA.dbo.referral
-- SELECT TOP 10 * FROM HMOPROD_PLANDATA.dbo.authcode
-- SELECT TOP 10 * FROM HMOPROD_PLANDATA.dbo.authservice
-- SELECT TOP 10 * FROM HMOPROD_PLANDATA.dbo.authreason
-- SELECT TOP 10 * FROM HMOPROD_PLANDATA.dbo.reasongroupdtl
-- SELECT TOP 10 * FROM HMOPROD_PLANDATA.dbo.referraltext
-- SELECT TOP 10 * FROM HMOPROD_PLANDATA.dbo.authdiag
-- SELECT TOP 10 * FROM HMOPROD_PLANDATA.dbo.authgroup
-- SELECT TOP 10 * FROM HMOPROD_PLANDATA.dbo.authservicereason
-- SELECT TOP 10 * FROM HMOPROD_PLANDATA.dbo.authservicedetail
-- SELECT TOP 10 * FROM HMOPROD_PLANDATA.dbo.authproc

		SELECT TOP 1 ' ' AS 'DATE TIME & QUARTER(S): '
		,CONVERT(datetime,(r.UtcReceiptDate at time zone 'UTC') at time zone 'Pacific Standard Time') AS 'RECEIPT_DATE'
		,CONVERT(nvarchar(8),TRY_CONVERT(datetime,CONVERT(datetime,(r.UtcReceiptDate at time zone 'UTC') at time zone 'Pacific Standard Time')),114) AS 'RECEIPT TIME'
		,'Q'+DATENAME(qq,CAST(CAST(CONVERT(datetime,(r.UtcReceiptDate at time zone 'UTC') at time zone 'Pacific Standard Time') AS date) AS datetime))+' '+DATENAME(yyyy,CAST(CAST(CONVERT(datetime,(r.UtcReceiptDate at time zone 'UTC') at time zone 'Pacific Standard Time') AS date) AS datetime)) AS 'DetermQuarter BY RECEIVED DATE'
		,r.seendate
		,CONVERT(nvarchar(8),TRY_CONVERT(datetime,seendate),114) AS 'SEENTIME'
		,'Q'+DATENAME(qq,CAST(CAST(seendate AS date) AS datetime))+' '+DATENAME(yyyy,CAST(CAST(seendate AS date) AS datetime)) AS 'DetermQuarter BY SEENDATE'
		FROM HMOPROD_PLANDATA.dbo.referral AS r

		SELECT DISTINCT' ' AS 'FIND() THE meddir'
		,a.meddirectorid
		,r.referralid
		,r.authorizationid
		,UPPER(LTRIM(RTRIM(ISNULL(en.lastname,''))))+' '+UPPER(LTRIM(RTRIM(ISNULL(en.firstname,'')))) AS [Medical Director]-- see DetermName
		,r.seendate
		,r.receiptdate
		,en.*
		-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
		-- SELECT DISTINCT ' ' AS 'CHECK 1st'
		FROM HMOPROD_PLANDATA.dbo.referral AS r
			INNER JOIN HMOPROD_PLANDATA.dbo.authservice AS a  ON r.referralid = a.referralid
			INNER JOIN HMOPROD_PLANDATA.dbo.entity AS en ON a.meddirectorid = en.entid  --,UPPER(en.lastname) +','+UPPER(en.firstname) AS DetermName
		WHERE 1=1 
			AND 
			( -- INITIATE ...
			a.referralid IN ('2972071')
				OR r.authorizationid IN ('2972071') -- MATCHES AUTH SCAN PRINT SCREEN FROM YOUNG LADY NATALIA CHARINDEX() FIND() SEARCH() 'SUBJECT:Auth Scans Replacement FROM: NATALIA WALTER JEREMY'
				) -- CONCLUDE ...

		SELECT DISTINCT ' ' AS 'AUTH / REF STATUS OPTION(S)'
		,r.status
		FROM HMOPROD_PLANDATA.dbo.referral AS r

		SELECT DISTINCT ' ' AS 'servicecode v codeid'
		,r.servicecode
		FROM HMOPROD_PLANDATA.dbo.referral AS r

		EXCEPT -- LIKE '%INTERSECT%'... ensure that only rows IN the first result set that are NOT NO NEGATIVE != <> IN the second are returned. This means that the EXCEPT() operator is query order-sensitive, like the LEFT JOIN and RIGHT JOIN. see 'https://sqlbolt.com/topic/set_operations'
		SELECT DISTINCT ' ' AS 'servicecode v codeid'
		,ac.codeid
		FROM HMOPROD_PLANDATA.dbo.authcode AS ac

		SELECT DISTINCT ' ' AS 'codeid v servicecode'
		,ac.codeid
		FROM HMOPROD_PLANDATA.dbo.authcode AS ac

		EXCEPT -- LIKE '%INTERSECT%'... ensure that only rows IN the first result set that are NOT NO NEGATIVE != <> IN the second are returned. This means that the EXCEPT() operator is query order-sensitive, like the LEFT JOIN and RIGHT JOIN. see 'https://sqlbolt.com/topic/set_operations'
		SELECT DISTINCT ' ' AS 'codeid v servicecode'
		,r.servicecode
		FROM HMOPROD_PLANDATA.dbo.referral AS r
		 
		SELECT ' ' AS 'AUTH REF CLINICAL + NON-CLINICAL NOTE(S)'
		,TRY_CONVERT(nvarchar(MAX),rt.reason) AS [NON-CLINICAL NOTE(S)]
		,r.authorizationid
		,rt.*
		FROM HMOPROD_PLANDATA.dbo.referraltext AS rt
			INNER JOIN HMOPROD_PLANDATA.dbo.referral AS r ON rt.referralid = r.referralid
		WHERE 1=1
			AND r.authorizationid IN ('4273229','4271951')	 -- C007: ADD NON-CLINICAL NOTES PER REQUEST FROM MS BARBARA ON 20241112 ... FROM:BARB ATTACHMENT:*MC LTC AUTHNOTE SAMPLE Copy of LTC SNF Q2 2024 YF working copy 07-09-2024.xlsx*

		SELECT DISTINCT ' ' AS 'AUTH REF DATA INTEGRITY'
		,r.referralid
		,r.authorizationid
		,r.effdate
		,r.memid
		,bp.* -- ,year_month
		,mem.*
		-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
		-- SELECT DISTINCT ' ' AS 'CHECK 1st'
		FROM HMOPROD_PLANDATA.dbo.referral (NOLOCK) AS r
			INNER JOIN HMOPROD_PLANDATA.dbo.enrollkeys (NOLOCK) AS e ON r.enrollid = e.enrollid
			INNER JOIN INFORMATICS.dbo.[uvw_LINE_OF_BUSINESS] (NOLOCK) AS bp ON e.programid = bp.programid  -- HMOPROD_PLANDATA.dbo.benefitplan + HMOPROD_PLANDATA.dbo.program
			INNER JOIN HMOPROD_PLANDATA.dbo.member AS mem (NOLOCK) ON r.memid = mem.memid
		WHERE 1=1 
			AND r.referralid IN ('4352086','2319087','2312483','1949590','2037776') -- SNOWFLAKE CLAIMS OF DOUBLE DIPPING 
				OR r.authorizationid IN ('4352086','2319087','2312483','1949590','2037776') -- SNOWFLAKE CLAIMS OF DOUBLE DIPPING
				OR r.authorizationid IN ('2426824','2426825','2426826','2426826','2426828') -- KNOWN QNXT [authorizationid] DATA INTEGRITY CONCERN
		ORDER BY authorizationid

		SELECT TOP 1 ' ' AS 'RECEIPT OF TIME ZONE ... Coordinated Universal Time or UTC' -- C000: Coordinated Universal Time or UTC is the primary time standard globally used to regulate clocks and time. It establishes a reference for the current time, forming the basis for civil time and time zones. UTC facilitates international communication, navigation, scientific research, and commerce.
		,TRY_CONVERT(datetime,GETDATE()) AS [NOW_ORIGIN_TIME_ZONE]
		,CAST(TRY_CONVERT(datetime,(GETDATE() at time zone 'UTC') at time zone 'Pacific Standard Time') AS datetime) AS [NOW_PACIFIC_TIME_ZONE]
		,TRY_CONVERT(datetime,r.UtcReceiptDate) AS [RECEIPTDATE_ORIGIN_TIME_ZONE]
		,CAST(CONVERT(datetime,(r.UtcReceiptDate at time zone 'UTC') at time zone 'Pacific Standard Time') AS datetime) AS [RECEIPTDATE_PACIFIC_TIME_ZONE]
		,CAST(TRY_CONVERT(datetime,(r.UtcReceiptDate at time zone 'UTC') at time zone 'Pacific Standard Time') AS datetime) AS [RECEIPTDATE_PACIFIC_TIME_ZONE]
		FROM HMOPROD_PLANDATA.dbo.referral (NOLOCK) AS r

		SELECT DISTINCT ' ' AS 'AUTH / REF [ACUITY_PRIORITY]'
		,r.acuity
		,r.priority
		,CASE 
		WHEN ISNULL(r.[priority],'') = 'H' 
		THEN CONVERT(nvarchar(25),'Expedited')
		ELSE CONVERT(nvarchar(25),'Standard')
		END AS [acuity_priority]
		FROM HMOPROD_PLANDATA.dbo.referral (NOLOCK) AS r
		WHERE 1=1 

		SELECT DISTINCT ' ' AS 'AUTH "TEMPLATE" OPTION(S)'
		,r.servicecode
		,ac.codeid
		,ac.description
		,ac.authcategory
		,UPPER(LTRIM(RTRIM(ISNULL(ac.description,'')))) AS [AUTH TYPE (TEMPLATE) DESCR]
		,CASE 
		WHEN r.servicecode IN ('INPATIENT', 'INPTARE', 'INPTBH', 'INPTHPSC', 'INPTLTAC', 'INPTSNF', 'IPLate', 'IPPALL', 'IPRetro', 'IPSNDT') 
		THEN 'Inpatient'
		WHEN r.servicecode IN ('OPLate', 'OPSurgery', 'OUTPATIENT', 'HEALTH ED', 'CBAS', 'OPPALL', 'OPRetro') 
		THEN 'Outpatient'
		WHEN r.servicecode IN ('BEHAVIORAL HLTH', 'BHLate', 'BHRetro') 
			OR r.userid = 1178 -- SELECT ' ' AS 'OnlineBH',* FROM HMOPROD_QCSIDB.dbo.quser WHERE userid = 1178
		THEN 'BH' -- sub.renderingSpecialty like 'behavioral health%' or sub.renderingSpecialty like '%psych%' THEN 'BH'
		ELSE r.servicecode
		END AS [AuthRefType (Template)]
		,CASE 
		WHEN r.servicecode LIKE '%Retro%'
		THEN 'Post-service'
		WHEN r.servicecode LIKE '%INP%SNF%'
		THEN 'Concurrent'
		ELSE 'Pre-service'
		END AS [AuthRefType (Grouping)] -- If template says Retro = Post-service, INPATIENT – SNF = concurrent, All others = pre-service
		-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
		-- SELECT DISTINCT ' ' AS 'CHECK 1st'
		FROM HMOPROD_PLANDATA.dbo.referral (NOLOCK) AS r
			INNER JOIN HMOPROD_PLANDATA.dbo.authcode (NOLOCK) AS ac ON r.servicecode = ac.codeid
		WHERE 1=1 
			-- AND ac.codeid LIKE '%AUTO%' -- Please include only auto-auths from this universe. (These are NOT considered authorizations). You may identify auto auth with the following template path. Auth Category: Outpatient, Subcategory: Outpatient, Template: Online Auth
			-- AND r.servicecode LIKE '%ICF%' -- ICF/DD (ntermediate Care Facility for Developmentally Disabled Transition (ICF/DD) and Subacute Monitoring Survey)'
			-- AND a.description LIKE '%palliative%'







-- =====================================================================
	-- UM UNIVERSE:
-- =====================================================================

-- =====================================================================
	-- Add the parameters for the stored procedure here:
-- =====================================================================

		DECLARE @BRAND AS nvarchar(100) = NULL -- 'CHGSD' OR 'CHPIV' -- DEFAULT VAL()

-- =====================================================================
	-- AUTH Request for Information (RFI) --
-- =====================================================================

-- =====================================================================
	-- MODIFICATION(S) | CHANGE.LOG: --
-- =====================================================================
-- C000: Coordinated Universal Time or UTC is the primary time standard globally used to regulate clocks and time. It establishes a reference for the current time, forming the basis for civil time and time zones. UTC facilitates international communication, navigation, scientific research, and commerce.

		-- ,CONVERT(datetime,(r.UtcReceiptDate at time zone 'UTC') at time zone 'Pacific Standard Time') 

-- C001: UPDATE per eMAIL FROM MS ERICA ON 20240202 RELATED TO RESULTING AUDIT CAP (CORRECTION ACTION PLAN) ... Hi Phil, We need your assistance to comply with our 2023 DHCS CAP 1.2.1 response. Attached, is a copy of the report my team receives monthly for our internal audit review (link also included below). Index of \\chg_cifs01\Shared\HCS2017\HCS Audit - SARAG Reports\ Request: Please label any case with a ‘MODIFIED’ attribute IN QNXT, UM Record, Misc. tab, AS ‘Modified’ for Column M (Request Determination) ON this report. NOTe, will be zero identified for now, AS this is a new process.
	-- AND CAST(attrib.effdate AS date) BETWEEN @ClockStart AND @ClockStop

-- C002: FROM ECM / CS Q  per TEAMS DISCUSSION WITH() MS CLAUDIA FOR TAB 5 WE SHOULD BE CAPTURING MEMBERS WITH() AN OPEN CS AUTH AT THE END OF THE QTR BEING REPORTED ... 	r.effdate AS 'Auth Start Date', -- FROM ALTER proc [dbo].[rptCommunitySupportsAuth] ... 	r.termdate AS 'Auth End Date', -- FROM ALTER proc [dbo].[rptCommunitySupportsAuth]

-- C003 C - SNP UPDATE per 'TEAMS CHAT' ON 20231012 'C-SNP User Stories'

-- C004: [Decision Maker] UPDATE: ... Hi Walter, We received feedback from DHCS ON 1.2 PA Log. For all previous years, we've submitted our logs with the 'Decision Maker' column data stating 'Medical Director.' However, DHCS has now requested that we provide the name and credentials of the decision maker for all denial and modification records. May you please assist us by revising 1.2 PA Log for the ‘Decision Maker’ Column? Revised source logic: QNXT, UM Record, Assigned Services, Medical Director. I have saved Category1_1.2_17. CHG PA Log_rev.03.27 file: M:\Operations\Documents to Share\Yousaf\2024 DHCS Audit Thank you, Erica   ... Hi Walter, Yes, for example: Case 3804826 was denied by Dr. Conrad QNXT, UM Record, IN the Assigned Services tab, the Medical Director assigned is CONRAD, ALAN J. 

-- C005: ,UPPER(q.lastname) +' '+UPPER(q.firstname) AS [UserName] ... PER ECM WEEKLY MEETING ON 20240516 ... WAS LEFT JOIN HMOPROD_QCSIDB.dbo.quser AS qat ON r.updateid = qat.loginid ... LTRIM(RTRIM(qat.firstname))+' '+LTRIM(RTRIM(qat.lastname)) AS [Assigned To]: ... USE to know who made the decision. r.authroizationid IN ('4182284','4063491','4062276') -- Auth# 4063491 Assigned to Jen Jackson: Auth# 4062276 Assigned to Jen Jackson: Auth# 4182284 Assigned to MS TANIA: LEFT JOIN HMOPROD_QCSIDB.dbo.quser AS q ON r.userid = q.userid

-- C006: [Auto Auth Status] PER ECM WEEKLY MEETING ON 20240516 ... Auto Approved: r.authroizationid IN ('3944504') do NOT have CLINICAL notes and only 1 online non CLINICAL note

			-- AND ISNULL(bp.[PROGRAM],'') IN ('CMC MEDICARE','CMC MEDI-CAL PLUS','DSNP MEDICARE PLAN','DSNP MEDI-CAL PLAN') -- DETERMRECON LOB ISO MATCH

 -- C007: ADD NON-CLINICAL NOTES PER REQUEST FROM MS BARBARA ON 20241112 ... FROM:BARB ATTACHMENT:*MC LTC AUTHNOTE SAMPLE Copy of LTC SNF Q2 2024 YF working copy 07-09-2024.xlsx*
 
-- C008: ADD BRANDING FOR CHPIV 'MSO' = management services organization IMPLEMENTATION AS OF 01/01/2026 GO LIVE

-- C009: DEFAULT TO 'Y' OVERRIDE PER SIR YOUSAF INSTRUCTION DURING UM WEEKLY ON 20260325

-- OPT001: Materialized #setauthref replaces setauthref CTE to eliminate double-read of referral+enrollkeys+uvw_LINE_OF_BUSINESS.

-- OPT002: Single-pass attribute extraction replacing 5 separate reads of qattribute+referralattribute+referral.

-- OPT003: INNER JOIN #AUTHRFI scopes reads to only referralids already staged, reducing scan size further.

-- =====================================================================
	-- DECLARE @PARAMETER(S) | @FILTER(S) --
-- =====================================================================
DECLARE @leadlag AS decimal(9,0)
DECLARE @leadlagmonths AS int
DECLARE @ClockStart AS datetime2
DECLARE @ClockStop AS datetime2
DECLARE @Authrundt AS datetime2
-- DECLARE @SPLITlob AS nvarchar(255)
DECLARE @Authlob AS nvarchar(255)

SET @leadlag = -3 -- +- LEAD() LAG() IN ...
SET @leadlagmonths = 3 -- +- LEAD() LAG() IN MONTH(S)
SET @ClockStart  = CAST('01/01/'+CAST(DATEPART(yyyy,DATEADD(month,@leadlag,CAST(GETDATE() AS datetime))) AS varchar(4)) AS datetime)
SET @ClockStop = TRY_CONVERT(date,GETDATE())
SET @Authrundt = TRY_CONVERT(date,GETDATE())
-- SET @SPLITlob = 'MEDI-CAL,DSNP,CSNP,CMC,MSO - CHPIV' -- SQL: STRING_SPLIT() ... LINE_OF_BUSINESS OPTION(S)
SET @Authlob = NULL -- LIKE '%[@PARAMETER]%' -- 'QMXHPQ084%' -- WHEN LTRIM(RTRIM(ek.programid)) = 'QMXHPQ0847' -- CMCmcare ek.planid IS QMXBP0822  & WHEN LTRIM(RTRIM(ek.programid)) = 'QMXHPQ0848' -- CMCmcal ek.planid IS QMXBP0823 'MEDI-CAL BENEFIT PLAN'

		SELECT ' ' AS 'AUTH Request for Information (RFI)'
		,'BETWEEN '+CONVERT(nvarchar(10),@ClockStart,101)+' AND '+CONVERT(nvarchar(10),@ClockStop,101) AS 'RANGE NOTE(S)'
		,@Authrundt AS 'EXEC DATE'
		,@Authlob AS 'LOB @parm FILTER'
		,CONVERT(nvarchar(10),TRY_CONVERT(datetime,GETDATE()),111) AS [SAMPLE DATE]
		,CONVERT(nvarchar(8),TRY_CONVERT(datetime,GETDATE()),114) AS [SAMPLE TIME]
		,bp.*
		-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
		-- SELECT DISTINCT ' ' AS 'CHECK 1st'
		FROM INFORMATICS.dbo.[uvw_LINE_OF_BUSINESS] (NOLOCK) AS bp -- HMOPROD_PLANDATA.dbo.benefitplan + HMOPROD_PLANDATA.dbo.program
		WHERE 1=1 
			-- AND bp.LINE_OF_BUSINESS IN (SELECT value FROM STRING_SPLIT(@SPLITlob, ','))
			AND bp.[PLAN] LIKE ISNULL('%'+@Authlob+'%','%')
			-- AND bp.[PROGRAM] LIKE ISNULL('%'+@Authlob+'%','%')
			-- AND bp.[LINE_OF_BUSINESS] LIKE ISNULL('%'+@Authlob+'%','%')
			-- AND bp.[BRAND] IN (ISNULL(@BRAND,'CHGSD')) -- ('MEDI-CAL BENEFIT PLAN','DSNP MEDI-CAL PLAN','COMMUNITY Y MAS (HMO C-SNP)','IV_DSNP2 MEDI-CAL PLAN','CHG MARKETPLACE HMO PLAN') -- VALID ACTIVE OPTION(S) -- C008: ADD BRANDING FOR CHPIV 'MSO' = management services organization IMPLEMENTATION AS OF 01/01/2026 GO LIVE 

DECLARE @PCPrecordRANK AS decimal(1,0) = 1 -- ENTER 1 TO GET() JUST MOST CURRENT [RANKis] see DENSE_RANK() OVER(PARTITION BY ek.memid ORDER BY CAST(ek.effdate AS datetime) DESC) AS [RANKis] --'RANKis' --RANK by MOST CURRENT EligHx







--------------------------------------------------------------------------------------------------------------------
	-- Error Trapping: Check If Permanent Table(s) Already Exist(s) And Drop If Applicable --
--------------------------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS #PROVISOLATION;
DROP TABLE IF EXISTS #QUALIFYING_AUTHS; -- PRE - FILTER THE DETAIL
DROP TABLE IF EXISTS #AUTHRFI;
-- DROP TABLE IF EXISTS #authmodified;
-- DROP TABLE IF EXISTS #authextension;
-- DROP TABLE IF EXISTS #authnotification;
-- DROP TABLE IF EXISTS #auththreshold;
-- DROP TABLE IF EXISTS #authoralnotification;
DROP TABLE IF EXISTS #authattributes;
DROP TABLE IF EXISTS #AUTHRFI_OUTPUT;

/* SELECT * 
INTO #PROVISOLATION
-- SELECT TOP 10 ' ' AS 'CHECK 1st',fedid,npi,provid,*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM INFORMATICS.dbo.[uvw_PROVISO] AS prov
WHERE 1=1 
	AND 
	( -- INITIATE ...
	UPPER(LTRIM(RTRIM(ISNULL(prov.NPI,'')))) IN ('1669420980') -- CLAIMS RFI: CARLSBAD PT ... The Department’s findings of excessive billing for these codes.
		-- OR fedid IN ('463701069') -- Provider TIN & Provider NPI	TIN# 46-3701069 NPI#1285061085 San Diego Post-Acute Center (Skilled Nursing Facility)
		-- OR UPPER(LTRIM(RTRIM(ISNULL(prov.provid,'')))) IN ('5514')
		) -- CONCLUDE ... 

		SELECT DISTINCT ' ' AS 'CONFIRM PROVIDER SELECTION: ',provid
		,fedid
		,NPI
		,PROVNM
		,SPECcode
		,SPECdescr
		,PROVcode
		,PROVtype 
		FROM #PROVISOLATION 
		ORDER BY PROVNM; */

-- =====================================================================
	-- OPT001: Materialized #setauthref replaces setauthref CTE to eliminate double-read of referral+enrollkeys+uvw_LINE_OF_BUSINESS.
-- =====================================================================
SELECT DISTINCT ' ' AS 'QUALIFYING AUTH ANCHOR DATE: '
,r.memid
,r.referralid
,r.authorizationid
,CASE
WHEN EXISTS ( -- DEFINITIVE ANSWER: Returns TRUE the moment SQL Server finds EVEN ONE MATCHING ROW IN THE SUBQUERY. It immediately stops scanning -- it does not count rows, does not return data, just confirms presence. This is why SELECT 1 is used -- the actual column value is irrelevant. -- IN PLAIN LANGUAGE: "DOES AT LEAST ONE ROW EXIST IN #PROVISOLATION where the provider ID matches?" ... NOT EXISTS(): EXACT LOGICAL INVERSE. Returns TRUE only WHEN THE SUBQUERY FINDS ZERO MATCHING ROWS. It is the correct, sargable, SQL-idiomatic way to express "exclude any claim whose provider appears in this list." It is semantically equivalent to a LEFT JOIN ... WHERE INNER JOINed_table.key IS NULL anti-INNER JOIN pattern, but often cleaner and more readable. ...SCENARIO B: REVCODE DRIVES CLASSIFICATION WHEN NO BILLTYPE MATCH ... C002: PER BRD / NARRATIVE "D-SNP Transmission of Admission Notification Narrative 04-01-2026 (002).docx"
SELECT 1
FROM HMOPROD_PLANDATA.dbo.referral (NOLOCK) AS rtemplate
WHERE 1=1
	AND r.referralid = rtemplate.referralid -- KEY ON ...  
	WHEN r.servicecode IN ('INPATIENT', 'INPTARE', 'INPTBH', 'INPTHPSC', 'INPTLTAC', 'INPTSNF', 'IPLate', 'IPPALL', 'IPRetro', 'IPSNDT') 
	)
THEN 'HOSPITAL_INPATIENT'
WHEN EXISTS ( -- DEFINITIVE ANSWER: Returns TRUE the moment SQL Server finds EVEN ONE MATCHING ROW IN THE SUBQUERY. It immediately stops scanning -- it does not count rows, does not return data, just confirms presence. This is why SELECT 1 is used -- the actual column value is irrelevant. -- IN PLAIN LANGUAGE: "DOES AT LEAST ONE ROW EXIST IN #PROVISOLATION where the provider ID matches?" ... NOT EXISTS(): EXACT LOGICAL INVERSE. Returns TRUE only WHEN THE SUBQUERY FINDS ZERO MATCHING ROWS. It is the correct, sargable, SQL-idiomatic way to express "exclude any claim whose provider appears in this list." It is semantically equivalent to a LEFT JOIN ... WHERE INNER JOINed_table.key IS NULL anti-INNER JOIN pattern, but often cleaner and more readable. ...SCENARIO B: REVCODE DRIVES CLASSIFICATION WHEN NO BILLTYPE MATCH ... C002: PER BRD / NARRATIVE "D-SNP Transmission of Admission Notification Narrative 04-01-2026 (002).docx"
SELECT 1
FROM HMOPROD_PLANDATA.dbo.referral (NOLOCK) AS rtemplate
WHERE 1=1
	AND r.referralid = rtemplate.referralid -- KEY ON ...  
	WHEN r.servicecode IN ('OPLate', 'OPSurgery', 'OUTPATIENT', 'HEALTH ED', 'CBAS', 'OPPALL', 'OPRetro') 
	)
THEN 'OUTPATIENT'
WHEN EXISTS ( -- DEFINITIVE ANSWER: Returns TRUE the moment SQL Server finds EVEN ONE MATCHING ROW IN THE SUBQUERY. It immediately stops scanning -- it does not count rows, does not return data, just confirms presence. This is why SELECT 1 is used -- the actual column value is irrelevant. -- IN PLAIN LANGUAGE: "DOES AT LEAST ONE ROW EXIST IN #PROVISOLATION where the provider ID matches?" ... NOT EXISTS(): EXACT LOGICAL INVERSE. Returns TRUE only WHEN THE SUBQUERY FINDS ZERO MATCHING ROWS. It is the correct, sargable, SQL-idiomatic way to express "exclude any claim whose provider appears in this list." It is semantically equivalent to a LEFT JOIN ... WHERE INNER JOINed_table.key IS NULL anti-INNER JOIN pattern, but often cleaner and more readable. ...SCENARIO B: REVCODE DRIVES CLASSIFICATION WHEN NO BILLTYPE MATCH ... C002: PER BRD / NARRATIVE "D-SNP Transmission of Admission Notification Narrative 04-01-2026 (002).docx"
SELECT 1
FROM HMOPROD_PLANDATA.dbo.referral (NOLOCK) AS rtemplate
WHERE 1=1
	AND r.referralid = rtemplate.referralid -- KEY ON ...  
	WHEN rtemplate.servicecode IN ('BEHAVIORAL HLTH', 'BHLate', 'BHRetro') 
		OR rtemplate.userid = 1178 -- SELECT ' ' AS 'OnlineBH',* FROM HMOPROD_QCSIDB.dbo.quser WHERE userid = 1178
		)
THEN 'BH' -- sub.renderingSpecialty like 'behavioral health%' or sub.renderingSpecialty like '%psych%' THEN 'BH'
WHEN EXISTS ( -- DEFINITIVE ANSWER: Returns TRUE the moment SQL Server finds EVEN ONE MATCHING ROW IN THE SUBQUERY. It immediately stops scanning -- it does not count rows, does not return data, just confirms presence. This is why SELECT 1 is used -- the actual column value is irrelevant. -- IN PLAIN LANGUAGE: "DOES AT LEAST ONE ROW EXIST IN #PROVISOLATION where the provider ID matches?" ... NOT EXISTS(): EXACT LOGICAL INVERSE. Returns TRUE only WHEN THE SUBQUERY FINDS ZERO MATCHING ROWS. It is the correct, sargable, SQL-idiomatic way to express "exclude any claim whose provider appears in this list." It is semantically equivalent to a LEFT JOIN ... WHERE joined_table.key IS NULL anti-join pattern, but often cleaner and more readable.
SELECT 1
FROM #PROVISOLATION AS piso
WHERE 1=1
	AND r.referto = piso.provid -- KEY ON ... [Rendering Provider]
	)
THEN 'HIT ON REFERTO PROVIDER'
WHEN EXISTS ( -- DEFINITIVE ANSWER: Returns TRUE the moment SQL Server finds EVEN ONE MATCHING ROW IN THE SUBQUERY. It immediately stops scanning -- it does not count rows, does not return data, just confirms presence. This is why SELECT 1 is used -- the actual column value is irrelevant. -- IN PLAIN LANGUAGE: "DOES AT LEAST ONE ROW EXIST IN #PROVISOLATION where the provider ID matches?" ... NOT EXISTS(): EXACT LOGICAL INVERSE. Returns TRUE only WHEN THE SUBQUERY FINDS ZERO MATCHING ROWS. It is the correct, sargable, SQL-idiomatic way to express "exclude any claim whose provider appears in this list." It is semantically equivalent to a LEFT JOIN ... WHERE joined_table.key IS NULL anti-join pattern, but often cleaner and more readable.
SELECT 1
FROM #PROVISOLATION AS piso
WHERE 1=1
	AND r.referfrom = piso.provid -- KEY ON ... [Rendering Provider]
	)
THEN 'HIT ON REFERFROM PROVIDER'
WHEN EXISTS ( -- DEFINITIVE ANSWER: Returns TRUE the moment SQL Server finds EVEN ONE MATCHING ROW IN THE SUBQUERY. It immediately stops scanning -- it does not count rows, does not return data, just confirms presence. This is why SELECT 1 is used -- the actual column value is irrelevant. -- IN PLAIN LANGUAGE: "DOES AT LEAST ONE ROW EXIST IN #PROVISOLATION where the provider ID matches?" ... NOT EXISTS(): EXACT LOGICAL INVERSE. Returns TRUE only WHEN THE SUBQUERY FINDS ZERO MATCHING ROWS. It is the correct, sargable, SQL-idiomatic way to express "exclude any claim whose provider appears in this list." It is semantically equivalent to a LEFT JOIN ... WHERE INNER JOINed_table.key IS NULL anti-INNER JOIN pattern, but often cleaner and more readable. ...SCENARIO B: REVCODE DRIVES CLASSIFICATION WHEN NO BILLTYPE MATCH ... C002: PER BRD / NARRATIVE "D-SNP Transmission of Admission Notification Narrative 04-01-2026 (002).docx"
SELECT 1
FROM HMOPROD_PLANDATA.dbo.authdiag (NOLOCK) AS adx
WHERE 1=1
	AND r.referralid = adx.referralid -- KEY ON ... 
	AND adx.diagcode LIKE '%Z51.5%'
	)
THEN 'PALLIATIVE'
WHEN EXISTS ( -- DEFINITIVE ANSWER: Returns TRUE the moment SQL Server finds EVEN ONE MATCHING ROW IN THE SUBQUERY. It immediately stops scanning -- it does not count rows, does not return data, just confirms presence. This is why SELECT 1 is used -- the actual column value is irrelevant. -- IN PLAIN LANGUAGE: "DOES AT LEAST ONE ROW EXIST IN #PROVISOLATION where the provider ID matches?" ... NOT EXISTS(): EXACT LOGICAL INVERSE. Returns TRUE only WHEN THE SUBQUERY FINDS ZERO MATCHING ROWS. It is the correct, sargable, SQL-idiomatic way to express "exclude any claim whose provider appears in this list." It is semantically equivalent to a LEFT JOIN ... WHERE INNER JOINed_table.key IS NULL anti-INNER JOIN pattern, but often cleaner and more readable. ...SCENARIO B: REVCODE DRIVES CLASSIFICATION WHEN NO BILLTYPE MATCH ... C002: PER BRD / NARRATIVE "D-SNP Transmission of Admission Notification Narrative 04-01-2026 (002).docx"
SELECT 1
FROM HMOPROD_PLANDATA.dbo.authservice (NOLOCK) AS arev
	INNER JOIN HMOPROD_PLANDATarev.dbo.revcode AS rev (NOLOCK) ON CASE
	WHEN SUBSTRING(UPPER(LTRIM(RTRIM(ISNULL(arev.codeid,'')))),1,1) = 'Z'
	THEN  UPPER(LTRIM(RTRIM(ISNULL(arev.codeid,''))))
	WHEN SUBSTRING(UPPER(LTRIM(RTRIM(ISNULL(arev.codeid,'')))),1,1) = '0'
	THEN  SUBSTRING(UPPER(LTRIM(RTRIM(ISNULL(arev.codeid,'')))),2,3)
	ELSE UPPER(LTRIM(RTRIM(ISNULL(arev.codeid,''))))
	END = CASE
	WHEN SUBSTRING(UPPER(LTRIM(RTRIM(ISNULL(rev.codeid,'')))),1,1) = 'Z'
	THEN  UPPER(LTRIM(RTRIM(ISNULL(rev.codeid,''))))
	WHEN SUBSTRING(UPPER(LTRIM(RTRIM(ISNULL(rev.codeid,'')))),1,1) = '0'
	THEN  SUBSTRING(UPPER(LTRIM(RTRIM(ISNULL(rev.codeid,'')))),2,3)
	ELSE UPPER(LTRIM(RTRIM(ISNULL(rev.codeid,''))))
	END
WHERE 1=1
	AND  r.referralid = arev.referralid -- KEY ON ... 
	AND CASE 
	WHEN SUBSTRING(UPPER(LTRIM(RTRIM(ISNULL(arev.codeid,'')))),1,1) = 'Z'
	THEN  UPPER(LTRIM(RTRIM(ISNULL(arev.codeid,''))))
	WHEN SUBSTRING(UPPER(LTRIM(RTRIM(ISNULL(arev.codeid,'')))),1,1) = '0'
	THEN  SUBSTRING(UPPER(LTRIM(RTRIM(ISNULL(arev.codeid,'')))),2,3)
	ELSE UPPER(LTRIM(RTRIM(ISNULL(arev.codeid,''))))
	END IN ('101', '190', '160', '169', '112', '199', '185', '180') -- LTC REVENUE CODES per requirements
	)
THEN 'LTC'
WHEN EXISTS ( -- DEFINITIVE ANSWER: Returns TRUE the moment SQL Server finds EVEN ONE MATCHING ROW IN THE SUBQUERY. It immediately stops scanning -- it does not count rows, does not return data, just confirms presence. This is why SELECT 1 is used -- the actual column value is irrelevant. -- IN PLAIN LANGUAGE: "DOES AT LEAST ONE ROW EXIST IN #PROVISOLATION where the provider ID matches?" ... NOT EXISTS(): EXACT LOGICAL INVERSE. Returns TRUE only WHEN THE SUBQUERY FINDS ZERO MATCHING ROWS. It is the correct, sargable, SQL-idiomatic way to express "exclude any claim whose provider appears in this list." It is semantically equivalent to a LEFT JOIN ... WHERE joined_table.key IS NULL anti-join pattern, but often cleaner and more readable. ...SCENARIO B: REVCODE DRIVES CLASSIFICATION WHEN NO BILLTYPE MATCH ... C002: PER BRD / NARRATIVE "D-SNP Transmission of Admission Notification Narrative 04-01-2026 (002).docx"
SELECT 1
FROM HMOPROD_PLANDATA.dbo.authservice (NOLOCK) AS acpt
WHERE 1=1
	AND r.referralid = acpt.referralid -- KEY ON ... 
	AND SUBSTRING(UPPER(LTRIM(RTRIM(ISNULL(acpt.codeid,'')))),1,5) IN ('43644') -- AS [CPT Service Code]
	)
THEN 'Bariatric Surgery / Gastrectomy'
ELSE 'NOT_QUALIFYING'
END AS [InclusionExclusionType]
INTO #QUALIFYING_AUTHS
FROM HMOPROD_PLANDATA.dbo.referral (NOLOCK) AS r
	INNER JOIN HMOPROD_PLANDATA.dbo.referralattribute (NOLOCK) AS attrib ON r.referralid = attrib.referralid
	INNER JOIN HMOPROD_PLANDATA.dbo.qattribute (NOLOCK) AS q ON attrib.attributeid = q.attributeid
	INNER JOIN HMOPROD_PLANDATA.dbo.enrollkeys (NOLOCK) AS e ON r.enrollid = e.enrollid
		AND r.effdate BETWEEN CAST(e.effdate AS date) AND CAST(ISNULL(e.termdate,'12/31/2078') AS date) -- RINA: APPLIED TO FIELD WITHIN TABLE TO BE UPDATE	
	INNER JOIN INFORMATICS.dbo.[uvw_LINE_OF_BUSINESS] (NOLOCK) AS bp ON e.programid = bp.programid -- HMOPROD_PLANDATA.dbo.benefitplan + HMOPROD_PLANDATA.dbo.program
WHERE 1=1
	AND (
	UPPER(LTRIM(RTRIM(ISNULL(q.description,'')))) LIKE '%AUTH%NOTIFI%LETT%SENT%'	 -- C00863757 ... LEVERAGE: "#authattributes"
	)
	-- AND TRY_CONVERT(date,ISNULL(attrib.effdate,'12/31/2028')) BETWEEN @ClockStart AND @ClockStop
	AND CAST(CONVERT(datetime,(r.UtcReceiptDate at time zone 'UTC') at time zone 'Pacific Standard Time') AS date) BETWEEN @ClockStart AND @ClockStop -- Coordinated Universal Time or UTC is the primary time standard globally used to regulate clocks and time. It establishes a reference for the current time, forming the basis for civil time and time zones. UTC facilitates international communication, navigation, scientific research, and commerce. ... ADHOC REQUEST per eMAIL FROM MS NATALIA ON 20221115 '... We need to run a report through AuthScans for Auth Scan Report for EYECARE OF SAN DIEGO/Provider ID: 313124 ...'

	-- AND TRY_CONVERT(date,ISNULL(r.termdate,GETDATE())) >= @ClockStart -- WITHIN reporting period [RANGE] OPPOSITION
	-- AND TRY_CONVERT(date,r.effdate) <= @ClockStop -- WITHIN reporting period [RANGE] OPPOSITION 	

	-- AND TRY_CONVERT(date,r.termdate) >= @ClockStop -- FROM ECM / CS Q  C002: per TEAMS DISCUSSION WITH() MS CLAUDIA FOR TAB 5 WE SHOULD BE CAPTURING MEMBERS WITH() AN OPEN CS AUTH AT THE END OF THE QTR BEING REPORTED ... 	r.effdate AS 'Auth Start Date', -- FROM ALTER proc [dbo].[rptCommunitySupportsAuth] ... 	r.termdate AS 'Auth End Date', -- FROM ALTER proc [dbo].[rptCommunitySupportsAuth]
	-- AND TRY_CONVERT(date,r.effdate) <= @ClockStop -- FROM ECM / CS Q C002: per TEAMS DISCUSSION WITH() MS CLAUDIA FOR TAB 5 WE SHOULD BE CAPTURING MEMBERS WITH() AN OPEN CS AUTH AT THE END OF THE QTR BEING REPORTED ... 	r.effdate AS 'Auth Start Date', -- FROM ALTER proc [dbo].[rptCommunitySupportsAuth] ... 	r.termdate AS 'Auth End Date', -- FROM ALTER proc [dbo].[rptCommunitySupportsAuth]

	-- AND TRY_CONVERT(date,ISNULL(r.effdate,'12/31/2078')) BETWEEN @ClockStart AND @ClockStop
	-- AND TRY_CONVERT(date,ISNULL(r.termdate,'12/31/2028')) BETWEEN @ClockStart AND @ClockStop
	-- AND TRY_CONVERT(date,ISNULL(r.termdate,GETDATE()) >= TRY_CONVERT(date,GETDATE()) -- STILL OPEN REFERRAL	
	-- AND TRY_CONVERT(date,ISNULL(r.seendate,'12/31/2078')) BETWEEN @ClockStart AND @ClockStop -- AS [DECISION DATE]
	-- AND TRY_CONVERT(date,ISNULL(r.referraldate,'12/31/2078')) BETWEEN @ClockStart AND @ClockStop
	-- AND TRY_CONVERT(date,ISNULL(a.DeterminationDate,'12/31/2078')) BETWEEN @ClockStart AND @ClockStop
	-- AND TRY_CONVERT(date,ISNULL(r.receiptdate,'12/31/2078')) BETWEEN @ClockStart AND @ClockStop
	-- AND TRY_CONVERT(date,ISNULL(r.createdate,'12/31/2078')) BETWEEN @ClockStart AND @ClockStop
	-- AND TRY_CONVERT(date,ISNULL(a.createdate,'12/31/2078')) BETWEEN @ClockStart AND @ClockStop
	-- AND TRY_CONVERT(date,ISNULL(a.lastupdate,'12/31/2078')) BETWEEN @ClockStart AND @ClockStop

	AND TRY_CONVERT(date,ISNULL(r.termdate,GETDATE())) >= r.effdate -- MUST BE TRUE ... NON-CROSSFOOTED RECORDS ARE ACTIVE ...

CREATE CLUSTERED INDEX idx_QAR_referralidclaimid ON #QUALIFYING_AUTHS (referralid);
CREATE NONCLUSTERED INDEX idx_QAR_memid ON #QUALIFYING_AUTHS (memid);

/* DELETE -- ENSURE INCLUSIONEXCLUSION FENCE ... 
FROM #QUALIFYING_AUTHS
WHERE 1=1
	AND InclusionExclusionType = 'NOT_QUALIFYING' */

	-- CHECK FOR DUP(S) --
SELECT ' ' AS 'SHOULD RETURN 0 ROWS - DUP Validation',*
FROM #QUALIFYING_AUTHS
WHERE 1=1
    AND [referralid] IN
    ( -- INITIATE ...
    SELECT [referralid]
    FROM #QUALIFYING_AUTHS AS dup
    GROUP BY [referralid]
    HAVING COUNT(1)>1
    ) -- CONCLUDE ...

        SELECT ' ' AS 'QA PRE-STAGE OF QUALIFYING UM AUTH REFERRAL COUNT: '
        ,InclusionExclusionType
        ,COUNT(DISTINCT referralid) AS [Unique Auths]
        ,COUNT(DISTINCT memid) AS [Unique Members]
        FROM #QUALIFYING_AUTHS
        WHERE 1=1
            AND NOT InclusionExclusionType = 'NOT_QUALIFYING' -- NO NOT NEGATIVE <> = ...
        GROUP BY InclusionExclusionType
		






-- =====================================================================
	--  SETCLAIM CTE: NOW JOINS #QUALIFYING_UMAUTHREF ONLY - NOT FULL TABLES
-- =====================================================================
;WITH setauthref AS
( -- INITIATE ...
SELECT TRY_CONVERT(nvarchar(255),'AUTH ISO') AS [AUTH CATEGORY]
,r.referralid -- ,year_month
,r.memid
,r.InclusionExclusionType
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM #QUALIFYING_AUTHS (NOLOCK) AS r
WHERE 1=1
    AND NOT r.InclusionExclusionType = 'NOT_QUALIFYING' -- NO NOT NEGATIVE <> != ...
GROUP BY r.referralid,r.memid,r.InclusionExclusionType -- CONSIDER Removing DISTINCT IN FAVOR OF GROUP BY: REPLACE the DISTINCT in the final SELECT with a proper GROUP BY clause. This is more explicit about the aggregation intent and allows the query optimizer to work more efficiently.
) -- CONCLUDE ...

		-- SELECT * FROM setauthref; -- Or any other query that uses the CTE

SELECT DISTINCT 'BETWEEN '+CONVERT(nvarchar(10),@ClockStart,101)+' AND '+CONVERT(nvarchar(10),@ClockStop,101)AS [RANGE NOTE(s)]
,CONVERT(nvarchar(25), GETDATE(),120) AS 'ExecutionDate'  --Like FORMAT or TEXT IN 'yyyy-mm-dd hh:mi:ss' (24h)
,srr.[AUTH CATEGORY]
,CASE 
WHEN r.servicecode IN ('INPATIENT', 'INPTARE', 'INPTBH', 'INPTHPSC', 'INPTLTAC', 'INPTSNF', 'IPLate', 'IPPALL', 'IPRetro', 'IPSNDT') THEN 'Inpatient'
WHEN r.servicecode IN ('OPLate', 'OPSurgery', 'OUTPATIENT', 'HEALTH ED', 'CBAS', 'OPPALL', 'OPRetro') 
THEN 'Outpatient'
WHEN r.servicecode IN ('BEHAVIORAL HLTH', 'BHLate', 'BHRetro') 
	OR r.userid = 1178 -- SELECT ' ' AS 'OnlineBH',* FROM HMOPROD_QCSIDB.dbo.quser WHERE userid = 1178
THEN 'BH' -- sub.renderingSpecialty like 'behavioral health%' or sub.renderingSpecialty like '%psych%' THEN 'BH'
ELSE r.servicecode
END AS [AuthRefType (Template)]
,CASE 
WHEN r.servicecode LIKE '%Retro%'
THEN 'Post-service'
WHEN r.servicecode LIKE '%INP%SNF%'
THEN 'Concurrent'
ELSE 'Pre-service'
END AS [AuthRefType (Grouping)] -- If template says Retro = Post-service, INPATIENT – SNF = concurrent, All others = pre-service
,CASE
WHEN r.servicecode LIKE '%Retro%' 
THEN 'PS' -- Post-service: NCQA MEDI-CAL narrative McaidPS = Medicaid Post-service
WHEN r.servicecode LIKE '%INP%SNF%' 
THEN 'CU' -- Concurrent: NCQA MEDI-CAL narrative McaidCU = Medicaid Concurrent
WHEN ISNULL(r.[priority],'') = 'H' 
THEN 'PU' -- Pre-service Urgent: NCQA MEDI-CAL narrative McaidPU = Medicaid Pre-service urgent
ELSE 'PN' -- Pre-service Non-urgent: NCQA MEDI-CAL narrative McaidPN = Medicaid Pre-service non-urgent
END AS [File Type] -- NCQA MEDI-CAL 2026 NARRATIVE: Care type Urgent+Priority H=McaidPU; Elective+empty=McaidPN; Concurrent via SNF=McaidCU; Retro=McaidPS
,vrb.BUCKET
,ac.codeid
,r.servicecode
,r.authorizationid AS [Prior Authorization Number]
,r.referralid
,r.authorizationid
,r.UtcReceiptDate
,CONVERT(datetime,(r.UtcReceiptDate at time zone 'UTC') at time zone 'Pacific Standard Time') AS 'RECEIPT_DATE'
,CONVERT(nvarchar(8),TRY_CONVERT(datetime,CONVERT(datetime,(r.UtcReceiptDate at time zone 'UTC') at time zone 'Pacific Standard Time')),114) AS 'RECEIPT TIME'
,'Q'+DATENAME(qq,CAST(CAST(CONVERT(datetime,(r.UtcReceiptDate at time zone 'UTC') at time zone 'Pacific Standard Time') AS date) AS datetime))+' '+DATENAME(yyyy,CAST(CAST(CONVERT(datetime,(r.UtcReceiptDate at time zone 'UTC') at time zone 'Pacific Standard Time') AS date) AS datetime)) AS 'DetermQuarter BY RECEIVED DATE'
,TRY_CONVERT(date,r.admitdate) AS [Date of Admission]
,CASE
WHEN LEN(LTRIM(RTRIM(CAST(DATEPART(hh,TRY_CONVERT(datetime,r.admitdate)) AS nvarchar(2)))))=1
THEN '0'+CAST(DATEPART(hh,TRY_CONVERT(datetime,r.admitdate)) AS nvarchar(2))
ELSE CAST(DATEPART(hh,TRY_CONVERT(datetime,r.admitdate)) AS nvarchar(2)) 
END
+':'+CASE
WHEN LEN(LTRIM(RTRIM(CAST(DATEPART(mi,TRY_CONVERT(datetime,r.admitdate)) AS nvarchar(2)))))=1
THEN '0'+CAST(DATEPART(mi,TRY_CONVERT(datetime,r.admitdate)) AS nvarchar(2))
ELSE CAST(DATEPART(mi,TRY_CONVERT(datetime,r.admitdate)) AS nvarchar(2)) 
END
+':'+CASE
WHEN LEN(LTRIM(RTRIM(CAST(DATEPART(ss,TRY_CONVERT(datetime,r.admitdate)) AS nvarchar(2)))))=1
THEN '0'+CAST(DATEPART(ss,TRY_CONVERT(datetime,r.admitdate)) AS nvarchar(2))
ELSE CAST(DATEPART(ss,TRY_CONVERT(datetime,r.admitdate)) AS nvarchar(2)) 
END AS [Time of Admission]
,TRY_CONVERT(date,r.dischargedate) AS [Date of Discharge]
,CASE
WHEN LEN(LTRIM(RTRIM(CAST(DATEPART(hh,TRY_CONVERT(datetime,r.dischargedate)) AS nvarchar(2)))))=1
THEN '0'+CAST(DATEPART(hh,TRY_CONVERT(datetime,r.dischargedate)) AS nvarchar(2))
ELSE CAST(DATEPART(hh,TRY_CONVERT(datetime,r.dischargedate)) AS nvarchar(2)) 
END
+':'+CASE
WHEN LEN(LTRIM(RTRIM(CAST(DATEPART(mi,TRY_CONVERT(datetime,r.dischargedate)) AS nvarchar(2)))))=1
THEN '0'+CAST(DATEPART(mi,TRY_CONVERT(datetime,r.dischargedate)) AS nvarchar(2))
ELSE CAST(DATEPART(mi,TRY_CONVERT(datetime,r.dischargedate)) AS nvarchar(2)) 
END
+':'+CASE
WHEN LEN(LTRIM(RTRIM(CAST(DATEPART(ss,TRY_CONVERT(datetime,r.dischargedate)) AS nvarchar(2)))))=1
THEN '0'+CAST(DATEPART(ss,TRY_CONVERT(datetime,r.dischargedate)) AS nvarchar(2))
ELSE CAST(DATEPART(ss,TRY_CONVERT(datetime,r.dischargedate)) AS nvarchar(2)) 
END AS [Time of Discharge]
,r.status
,r.status AS [HeaderStatus]
,CAST(UPPER(LTRIM(RTRIM(ISNULL(r.status,''))))+' - '+UPPER(LTRIM(RTRIM(ISNULL(a.status,'')))) AS nvarchar(255)) AS [DetailStatus]
,ar.description AS [DetailStatusReason]
,r.effdate
,r.termdate
,r.referraldate
,r.seendate
,r.receiptdate
,r.seendate AS [Decision Date]
,CONVERT(nvarchar(8),TRY_CONVERT(datetime,seendate),114) AS 'SEENTIME'
,'Q'+DATENAME(qq,CAST(CAST(seendate AS date) AS datetime))+' '+DATENAME(yyyy,CAST(CAST(seendate AS date) AS datetime)) AS 'DetermQuarter BY SEENDATE'
,r.admitdate
,r.dischargedate
,r.referfrom
,ccfrom.fullname AS 'ReferFromProv'
,ccfrom.NPI AS 'ReferFromNPI'
,r.referto
,ccto.fullname AS 'ReferToProv'
,ccto.NPI AS 'ReferToNPI'
,r.memid
,mem.CIN
,mem.HealthPlanID
,TRY_CONVERT(date,mem.dob) AS 'Member DOB'
,mem.[Member Name]
,mem.[Member Last Name]
,mem.[Member First Name]
,mem.[Member Last Name] AS [Enrollee Last Name]
,mem.[Member First Name] AS [Enrollee First Name]
,TRY_CONVERT(decimal(4,1),(DATEDIFF("dd",TRY_CONVERT(date,mem.dob),TRY_CONVERT(date,GETDATE()))/365.25)) AS 'MEMBER_AGE'
,TRY_CONVERT(int,(DATEDIFF("dd",TRY_CONVERT(date,mem.dob),TRY_CONVERT(date,GETDATE()))/365.25)) AS 'MEMBER_TRUE_CHRONOLOGICAL_AGE'
,DATEDIFF("mm",TRY_CONVERT(date,mem.dob),TRY_CONVERT(date,GETDATE()))-(TRY_CONVERT(int,(DATEDIFF("dd",TRY_CONVERT(date,mem.dob),TRY_CONVERT(date,GETDATE()))/365.25))*12) AS 'MEMBER_TRUE_CHRONOLOGICAL_AGE_AND_HOW_MANY_MTHs'
,bp.LINE_OF_BUSINESS
,bp.programid
,bp.planid
,bp.[PLAN]
,bp.PROGRAM
-- ,rdiag.[Diagnosis code],rdiag.[Diagnosis codes Descr]
-- ,rcpt.[CPT Procedure code],rcpt.[CPT Procedure code Description],rcpt.[requested_units] AS [CPT requested_units]
-- ,rrev.[Rev code],rrev.[Rev code Description],rrev.[requested_units] AS [RC requested_units]
,CAST(NULL AS nvarchar(255)) AS [Diagnosis code]
,CAST(NULL AS nvarchar(255)) AS [Diagnosis Category]
,CAST(NULL AS nvarchar(255)) AS [Diagnosis codes Descr]
,CAST(NULL AS nvarchar(255)) AS [CPT Procedure code]
,CAST(NULL AS nvarchar(255)) AS [CPT Procedure code Description]
,CAST(NULL AS nvarchar(255)) AS [Rev code]
,CAST(NULL AS nvarchar(255)) AS [Rev code Description]
,CAST(NULL AS int) AS [requested_units]
,ac.codeid AS [AUTH TYPE (TEMPLATE)]
,UPPER(LTRIM(RTRIM(ISNULL(ac.description,'')))) AS [AUTH TYPE (TEMPLATE) DESCR]
,ac.authcategory -- If template says Retro = Post-service, INPATIENT – SNF = concurrent, All others = pre-service 
,glembocki.claimid AS [CLAIM ASSOCIATED WITH AUTH]	
,r.acuity
,r.priority
,CASE 
WHEN ISNULL(r.[priority],'') = 'H' 
THEN CONVERT(nvarchar(25),'Expedited')
ELSE CONVERT(nvarchar(25),'Standard')
END AS [acuity_priority]
,CONVERT(datetime,(r.UtcReceiptDate at time zone 'UTC') at time zone 'Pacific Standard Time') AS [ClockStart] -- Coordinated Universal Time or UTC is the primary time standard globally used to regulate clocks and time. It establishes a reference for the current time, forming the basis for civil time and time zones. UTC facilitates international communication, navigation, scientific research, and commerce. ... 9.	TAT (Urgent requests 72 hours from Receipt to Seen date & time) (Routine requests 5 working days from Receipt to Seen date & time)
,CASE
WHEN r.[status] = 'PEND' 
THEN GETDATE()
ELSE r.seendate
END AS [ClockStop] -- 9.	TAT (Urgent requests 72 hours from Receipt to Seen date & time) (Routine requests 5 working days from Receipt to Seen date & time) 
,r.effdate AS 'Auth Start Date' -- FROM ALTER proc [dbo].[rptCommunitySupportsAuth]
,r.termdate AS 'Auth End Date' -- FROM ALTER proc [dbo].[rptCommunitySupportsAuth]
,ISNULL(r.NextReviewDate,'') AS [NextReviewDate]
,CASE
WHEN CAST(ISNULL(r.NextReviewDate,'') AS date) < CAST('01/01/1982' AS date)
THEN TRY_CONVERT(date,NULL)
ELSE CAST(ISNULL(r.NextReviewDate,'') AS date) 
END AS [NEXT_REVIEW_DUE_DATE]
,CASE
WHEN CAST(ISNULL(r.NextReviewDate,'') AS date) < CAST('01/01/1982' AS date)
THEN TRY_CONVERT(date,NULL)
ELSE CONVERT(nvarchar(8),TRY_CONVERT(datetime2,ISNULL(r.NextReviewDate,'')),114)
END AS [NEXT_REVIEW_DUE_TIME]
,rg.reasoncode
,CAST(UPPER(LTRIM(RTRIM(ISNULL(ar.description,'')))) AS nvarchar(255)) AS [ReasonDescr]
,CAST(0 AS money) AS [TAT]
,CAST(NULL AS int) AS [Threshold]
,CAST(NULL AS nvarchar(25)) AS [Units]
,CAST('N' AS nvarchar(1)) AS [Extended]
,CAST(NULL AS datetime) AS [Attribute Date /Time]
,CAST(NULL AS datetime) AS [Oral Attribute Date /Time]
,CAST(NULL AS nvarchar(1)) AS [Primary / Secondary Status]
,coc.[QNXT Reason Code (A= COC Reporting: Continuity of Care)] 
,coc.[QNXT Reason Code (A= COC Reporting: Continuity of Care) Descr.]
,oon.[QNXT Reason Code OON (A= OUT OF NETWORK)]
,oon.[QNXT Reason Code OON (A= OUT OF NETWORK) Descr.]
,a.meddirectorid -- see DetermName
,UPPER(LTRIM(RTRIM(ISNULL(en.lastname,'')))) +', '+UPPER(LTRIM(RTRIM(ISNULL(en.firstname,'')))) AS [AUDIT Medical Director]
-- ,UPPER(LTRIM(RTRIM(ISNULL(en.lastname,'')))) +', '+UPPER(LTRIM(RTRIM(ISNULL(en.firstname,''))))+' ('+UPPER(LTRIM(RTRIM(ISNULL(en.enttype,''))))+')' AS [AUDIT Medical Director]
,UPPER(LTRIM(RTRIM(ISNULL(q.lastname,'')))) +', '+UPPER(LTRIM(RTRIM(ISNULL(q.firstname,'')))) AS [UserName]
,'N' AS [Modified]
,TRY_CONVERT(nvarchar(255),NULL) AS [NONSPD/SPD flag] -- UNIVERSE AUDIT [FIELD] ... UPDATE WITH() MS ALLYSON FUNCTION (Fx) [informatics.dbo.udf_MediCalwSPDFlag]
,TRY_CONVERT(nvarchar(2),NULL) AS [Medi-Cal Aid Code] -- UNIVERSE AUDIT [FIELD] ... UPDATE LOGIC FOUND IN SIR ADAM STEP88_EnrollmentManager...sql
,TRY_CONVERT(nvarchar(255),NULL) AS [Member primary/preferred language] -- UNIVERSE AUDIT [FIELD] ... UPDATE WITH() QNXT RFP LANGUAGE CASE STATEMENT FOUND IN SIR ADAM STEP88_EnrollmentManager...sql
,TRY_CONVERT(nvarchar(255),NULL) AS [IPA/PPG/Clinics Delegate Entity] -- UNIVERSE AUDIT [FIELD] ... UPDATE WITH() LOGIC FOUND IN STEP88_PCP...sql
,TRY_CONVERT(nvarchar(255),NULL) AS [Name of PCP] -- UNIVERSE AUDIT [FIELD]
,TRY_CONVERT(nvarchar(255),NULL) AS [PCP Address] -- UNIVERSE AUDIT [FIELD]
,CASE
WHEN r.[status] = 'DENIED' 
THEN UPPER(LTRIM(RTRIM(ISNULL(en.lastname,'')))) +', '+UPPER(LTRIM(RTRIM(ISNULL(en.firstname,'')))) -- C004: [Decision Maker] UPDATE: ... Hi Walter, We received feedback from DHCS ON 1.2 PA Log. For all previous years, we've submitted our logs with the 'Decision Maker' column data stating 'Medical Director.' However, DHCS has now requested that we provide the name and credentials of the decision maker for all denial and modification records. May you please assist us by revising 1.2 PA Log for the ‘Decision Maker’ Column? Revised source logic: QNXT, UM Record, Assigned Services, Medical Director. I have saved Category1_1.2_17. CHG PA Log_rev.03.27 file: M:\Operations\Documents to Share\Yousaf\2024 DHCS Audit Thank you, Erica   ... Hi Walter, Yes, for example: Case 3804826 was denied by Dr. Conrad QNXT, UM Record, IN the Assigned Services tab, the Medical Director assigned is CONRAD, ALAN J. 
ELSE ''
END AS [Decision Maker] -- UNIVERSE AUDIT [FIELD] ... LOGIC SET PER DISCUSSION WITH() MS ERICA AUDIT UNIVERSE QA DISCUSSION 
-- ,CASE
-- WHEN r.[status] = 'DENIED' 
-- THEN 'MEDICAL DIRECTOR'
-- ELSE ''
-- END AS [Decision Maker] -- UNIVERSE AUDIT [FIELD] ... LOGIC SET PER DISCUSSION WITH() MS ERICA AUDIT UNIVERSE QA DISCUSSION 
,LTRIM(RTRIM(q.firstname))+' '+LTRIM(RTRIM(q.lastname)) AS [Assigned To] -- C005: ,UPPER(q.lastname) +' '+UPPER(q.firstname) AS [UserName] ... PER ECM WEEKLY MEETING ON 20240516 ... WAS LEFT JOIN HMOPROD_QCSIDB.dbo.quser AS qat ON r.updateid = qat.loginid ... LTRIM(RTRIM(q.firstname))+' '+LTRIM(RTRIM(q.lastname)) AS [Assigned To]: ... use to know who made the decision. r.authroizationid IN ('4182284','4063491','4062276') -- Auth# 4063491 Assigned to Jen Jackson: Auth# 4062276 Assigned to Jen Jackson: Auth# 4182284 Assigned to MS TANIA: 
,CASE 
WHEN ISNULL(TRY_CONVERT(nvarchar(255),rt.CLINICALNOTes),'') = ''
THEN 'AUTO AUTH'
ELSE TRY_CONVERT(nvarchar(255),NULL)
END AS [Auto Auth Status] -- C006: [Auto Auth Status] PER ECM WEEKLY MEETING ON 20240516 ... Auto Approved: r.authroizationid IN ('3944504') do NOT have CLINICAL notes and only 1 online non CLINICAL note
,TRY_CONVERT(nvarchar(2025),rt.reason) AS [NON-CLINICAL NOTE(S)] -- C007: ADD NON-CLINICAL NOTES PER REQUEST FROM MS BARBARA ON 20241112 ... FROM:BARB ATTACHMENT:*MC LTC AUTHNOTE SAMPLE Copy of LTC SNF Q2 2024 YF working copy 07-09-2024.xlsx*
,TRY_CONVERT(nvarchar(1),NULL) AS [ReferFromcontractedVerification]
,TRY_CONVERT(nvarchar(1),NULL) AS [ReferTocontractedVerification]
-- ,TRY_CONVERT(nvarchar(1),NULL) AS [contractedVerification]
,r.paytoaffiliationid
,r.DefaultContractId
,CASE
WHEN UPPER(LTRIM(RTRIM(ISNULL(UPPER(LTRIM(RTRIM(ISNULL(q.lastname,'')))),''))))+', '+UPPER(LTRIM(RTRIM(ISNULL(UPPER(LTRIM(RTRIM(ISNULL(q.firstname,'')))),'')))) LIKE '%BUCKET%'
THEN ISNULL(vrb.[BUCKET],'')
ELSE UPPER(LTRIM(RTRIM(ISNULL(q.loginid,''))))+' - '+UPPER(LTRIM(RTRIM(ISNULL(UPPER(LTRIM(RTRIM(ISNULL(q.lastname,'')))),''))))+', '+UPPER(LTRIM(RTRIM(ISNULL(UPPER(LTRIM(RTRIM(ISNULL(q.firstname,'')))),''))))
END AS [Assigned]
,TRY_CONVERT(nvarchar(2000),NULL) AS [DETAILelement]
,CONVERT(nvarchar(10),TRY_CONVERT(datetime,NULL),111) AS [AOR DATE] -- IN 'yyyymmdd: ' 
,CONVERT(nvarchar(8),TRY_CONVERT(datetime,NULL),114) AS [AOR TIME] -- IN 'hh:mm:ss:mmm (24-hour FORMAT) MILITARY TIME(): ' 
,'N' AS [Part B Drug Request]
,TRY_CONVERT(nvarchar(255),NULL) AS [Part B Drug CPT / HCPCS CODE]
,bp.[Contract Number]
INTO #AUTHRFI
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st',status
FROM setauthref AS srr
	INNER JOIN HMOPROD_PLANDATA.dbo.referral (NOLOCK) AS r ON srr.referralid = r.referralid
	INNER JOIN HMOPROD_PLANDATA.dbo.enrollkeys (NOLOCK) AS e ON r.enrollid = e.enrollid
	INNER JOIN INFORMATICS.dbo.[uvw_LINE_OF_BUSINESS] (NOLOCK) AS bp ON e.programid = bp.programid  -- HMOPROD_PLANDATA.dbo.benefitplan + HMOPROD_PLANDATA.dbo.program
	
	INNER JOIN HMOPROD_PLANDATA.dbo.provider (NOLOCK) AS ccto ON r.referto = ccto.provid
	-- JOIN HMOPROD_PLANDATA.dbo.affiliation AS affto ON ccto.provid = affto.provid

	INNER JOIN HMOPROD_PLANDATA.dbo.provider AS ccfrom (NOLOCK) ON r.referfrom = ccfrom.provid
	-- JOIN HMOPROD_PLANDATA.dbo.affiliation AS afffrom ON ccfrom.provid = afffrom.provid

	INNER JOIN INFORMATICS.dbo.uvw_BASELINE_MEMBERSHIP (NOLOCK) AS mem ON r.memid = mem.memid
		
		LEFT JOIN HMOPROD_QCSIDB.dbo.quser (NOLOCK) AS qat ON r.updateid = qat.loginid -- C005: ,UPPER(q.lastname) +' '+UPPER(q.firstname) AS [UserName] ... PER ECM WEEKLY MEETING ON 20240516 ... WAS LEFT JOIN HMOPROD_QCSIDB.dbo.quser AS qat ON r.updateid = qat.loginid ... LTRIM(RTRIM(q.firstname))+' '+LTRIM(RTRIM(q.lastname)) AS [Assigned To]: ... use to know who made the decision. r.authroizationid IN ('4182284','4063491','4062276') -- Auth# 4063491 Assigned to Jen Jackson: Auth# 4062276 Assigned to Jen Jackson: Auth# 4182284 Assigned to MS TANIA: 
		LEFT JOIN HMOPROD_PlanData.dbo.referraltext (NOLOCK) AS rt ON r.referralid = rt.referralid -- [Auto Auth Status] -- C005: PER ECM WEEKLY MEETING ON 20240516 ... Auto Approved: r.authroizationid IN ('3944504') do NOT have CLINICAL NOTes and only 1 online non CLINICAL NOT
		LEFT JOIN HMOPROD_PLANDATA.dbo.authdiag (NOLOCK) AS ad ON r.referralid = ad.referralid
		LEFT JOIN HMOPROD_PLANDATA.dbo.authcode (NOLOCK) AS ac ON r.servicecode = ac.codeid --AUTH TYPE (TEMPLATE) DEFINITION()
		LEFT JOIN HMOPROD_PLANDATA.dbo.authservice (NOLOCK) AS a ON r.referralid = a.referralid --PROC / REV CODE(s)
		LEFT JOIN HMOPROD_PLANDATA.dbo.authservicedetail (NOLOCK) AS asd ON r.referralid = asd.referralid
			AND asd.sequence = ad.sequence
		LEFT JOIN HMOPROD_PLANDATA.dbo.authservicereason (NOLOCK) AS asr ON a.referralid = asr.referralid
		LEFT JOIN HMOPROD_PLANDATA.dbo.reasongroupdtl (NOLOCK) AS rg ON asr.reasongroupdtlid =  rg.reasongroupdtlid
		LEFT JOIN HMOPROD_PLANDATA.dbo.authreason (NOLOCK) AS ar ON rg.reasoncode = ar.reasoncode
		LEFT JOIN HMOPROD_PLANDATA.dbo.entity (NOLOCK) AS en ON a.meddirectorid = en.entid --,UPPER(en.lastname) +','+UPPER(en.firstname) AS DetermName
		-- LEFT JOIN HMOPROD_QCSIDB.dbo.quser (NOLOCK) AS q ON r.issueinitials = q.UPDATEid
		LEFT JOIN HMOPROD_QCSIDB.dbo.quser (NOLOCK) AS q ON r.userid = q.userid --,UPPER(q.lastname) +' '+UPPER(q.firstname) AS UserName

		LEFT JOIN 
		( -- INITIATE ...
		SELECT DISTINCT q.loginid
		,q.userid
		,UPPER(LTRIM(RTRIM(ISNULL(UPPER(LTRIM(RTRIM(ISNULL(q.lastname,'')))),''))))+' '+UPPER(LTRIM(RTRIM(ISNULL(UPPER(LTRIM(RTRIM(ISNULL(q.firstname,'')))),'')))) AS [BUCKET]
		FROM HMOPROD_QCSIDB.dbo.quser AS q
		WHERE 1=1 
			AND UPPER(LTRIM(RTRIM(ISNULL(q.lastname,'')))) LIKE '%BUCKET%'
		) -- CONCLUDE ...
		AS vrb ON r.userid = vrb.userid

		LEFT JOIN -- COC per eMAIL ON 20220516 SUBJECT:Field Name changes & RANGE rewrite - RE: DHCS Audit 2022 - Assignments BODY:We heard FROM the UM team IN regards to the COC AND OON indicators AND what code to include for that. FROM:HINA ... was = '308' 
		( -- INITIATE ... 
		SELECT DISTINCT asr.referralid
		,asr.[sequence]
		,DENSE_RANK() OVER(PARTITION BY asr.referralid ORDER BY asr.[sequence]) AS [RANKis] -- RANK() ACCOUNT(s) FOR TIES + RETAINS SEQUENCE
		,ar.reasoncode AS [QNXT Reason Code (A= COC Reporting: Continuity of Care)] 
		,ar.[description] AS [QNXT Reason Code (A= COC Reporting: Continuity of Care) Descr.]
		FROM HMOPROD_PlanData.dbo.authservicereason (NOLOCK) AS asr
			INNER JOIN HMOPROD_PlanData.dbo.reasongroupdtl (NOLOCK) AS rgd ON asr.reasongroupdtlid = rgd.reasongroupdtlid
			INNER JOIN HMOPROD_PlanData.dbo.authreason ar (NOLOCK) ON rgd.reasoncode = ar.reasoncode
		WHERE 1=1 
			AND ar.reasoncode IN ('308','343') 
		) -- CONCLUDE ...
		AS coc ON r.referralid = coc.referralid
			-- AND coc.[RANKis] = 1 -- OUTER APPLY (SELECT TOP 1 ... Alt.

		LEFT JOIN -- COC per eMAIL ON 20220516 SUBJECT:Field Name changes & RANGE rewrite - RE: DHCS Audit 2022 - Assignments BODY:We heard FROM the UM team IN regards to the COC AND OON indicators AND what code to include for that. FROM:HINA ... was = '308' 
		( -- INITIATE ... 
		SELECT DISTINCT asr.referralid
		,asr.[sequence]
		,DENSE_RANK() OVER(PARTITION BY asr.referralid ORDER BY asr.[sequence]) AS [RANKis] -- RANK() ACCOUNT(s) FOR TIES + RETAINS SEQUENCE
		,ROW_NUMBER() OVER(PARTITION BY asr.referralid ORDER BY asr.[sequence]) AS [ROWis] -- RANK() ACCOUNT(s) FOR TIES + RETAINS SEQUENCE
		,ar.reasoncode AS [QNXT Reason Code OON (A= OUT OF NETWORK)]
		,ar.[description] AS [QNXT Reason Code OON (A= OUT OF NETWORK) Descr.]
		FROM HMOPROD_PlanData.dbo.authservicereason (NOLOCK) AS asr
			INNER JOIN HMOPROD_PlanData.dbo.reasongroupdtl (NOLOCK) AS rgd ON asr.reasongroupdtlid = rgd.reasongroupdtlid
			INNER JOIN HMOPROD_PlanData.dbo.authreason (NOLOCK) AS ar ON rgd.reasoncode = ar.reasoncode
		WHERE 1=1 
			AND ar.reasoncode IN ('411','412','413','414','415','416') -- COC per eMAIL ON 20220516 SUBJECT:Field Name changes & RANGE rewrite - RE: DHCS Audit 2022 - Assignments BODY:We heard FROM the UM team IN regards to the COC AND OON indicators AND what code to include for that. FROM:HINA ... was = '308' 
		) -- CONCLUDE ...
		AS oon ON r.referralid = oon.referralid
			-- AND oon.[RANKis] = 1 -- OUTER APPLY (SELECT TOP 1 ... Alt.
			-- AND oon.[ROWis] = 1 -- OUTER APPLY (SELECT TOP 1 ... Alt.
			
		LEFT JOIN INFORMATICS.dbo.[uvw_AUTHREFCLAIM] AS  Glembocki ON r.referralid = Glembocki.referralid -- 'Claude.ai v Perplexity.ai ...  'c.referralid OR cd.referralid = ref.authorizationid DISCOVERED ON 20150728 w Stefan Glembocki'
			AND r.authorizationid = Glembocki.authorizationid

	-- CHECK FOR DUP(S) --
/* SELECT ' ' AS 'SHOULD RETURN 0 ROWS - DUP Validation',*
-- DELETE
FROM #AUTHRFI
WHERE 1=1 
	AND [referralid] IN 
	( -- INITIATE ...
	SELECT dup.[referralid]
	FROM #AUTHRFI AS dup
	GROUP BY dup.[referralid] -- Duplication Driver 
	HAVING COUNT(1)>1 -- HAVING clause RESERVED for AGGREGATE(s) ... HAVING SUM(PAID_NET_AMT) != 0
	) -- CONCLUDE ...  */

CREATE INDEX idx_REFACTOR_DupID ON #AUTHRFI (referralid,authorizationid,ClockStart)

;WITH AOR AS -- 'AOR' = Appointment of Representative 
( -- INITIATE ...
SELECT ' ' AS 'LEVERAGE [udfAORForms]: '
,ctk.memid
,ctk.svcdate AS [ReceiptDate]
,DATEADD( yy, 1, ctk.svcdate ) AS [ExpirationDate]
FROM HMOPROD_PlanData..calltrack AS ctk
	INNER JOIN HMOPROD_PlanData.dbo.callreason AS cr ON ctk.callerid = cr.callerid
	INNER JOIN HMOPROD_PlanData.dbo.calltype AS ct ON cr.callcode = ct.callcode
WHERE 1=1
	AND ct.[description] = 'AOR Form on File'
	) -- CONCLUDE ...
	
			-- SELECT TOP 1 *,CONVERT(nvarchar(10),TRY_CONVERT(datetime,aor.[ReceiptDate]),111) AS [AOR DATE],CONVERT(nvarchar(8),TRY_CONVERT(datetime,aor.[ReceiptDate]),114) AS [AOR TIME] FROM AOR
	
UPDATE #AUTHRFI
SET [AOR DATE] = CONVERT(nvarchar(10),TRY_CONVERT(datetime,dt.[ReceiptDate]),111)
,[AOR TIME] = CONVERT(nvarchar(8),TRY_CONVERT(datetime,dt.[ReceiptDate]),114)
FROM  #AUTHRFI AS r
	INNER JOIN AOR AS dt ON r.memid = dt.memid
WHERE 1=1
	AND CAST(dt.[ReceiptDate] AS date) BETWEEN CAST(r.[effdate] AS date) AND CAST(r.termdate AS date)
	






-- ======================================================================
	--  Dx, PROC + REV -- 
-- ======================================================================
UPDATE #AUTHRFI
SET [Diagnosis code] = LTRIM(RTRIM(ISNULL(rdiag.diagcode,'')))
,[Diagnosis Category] = LTRIM(RTRIM(rdiag.diagqualifier))
,[Diagnosis codes Descr] = LTRIM(RTRIM(ISNULL(rdiag.description,'')))
FROM #AUTHRFI AS ar
	INNER JOIN 
	( -- INITIATE ...
	SELECT aliassetup.*
	-- ,DENSE_RANK() OVER (PARTITION BY aliassetup.authorizationid ORDER BY aliassetup.[sequence] ASC,aliassetup.diagcode DESC) AS [RANKis]
	,ROW_NUMBER() OVER (PARTITION BY aliassetup.authorizationid ORDER BY aliassetup.[sequence] ASC,aliassetup.diagcode DESC) AS [ROWis]
	FROM 
	( -- INITIATE ...
	SELECT ' ' AS 'PRIMARY DIAGNOSIS: '
	,r.authorizationid
	,ad.referralid
	,ad.diagcode
	,ad.diagqualifier
	,dc.[description]
	,ad.[sequence]
	-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
	-- SELECT DISTINCT ' ' AS 'CHECK 1st'
	FROM HMOPROD_PLANDATA.dbo.referral (NOLOCK) AS r 
		INNER JOIN HMOPROD_PLANDATA.dbo.authdiag (NOLOCK) AS ad ON r.referralid = ad.referralid
		INNER JOIN HMOPROD_PLANDATA.dbo.diagcode AS dc (NOLOCK) ON ad.diagcode = dc.codeid
	WHERE 1=1 
		-- AND r.authorizationid IN ('4731258') -- SAMPLE - MULTI CODES
		AND NOT ISNULL(ad.diagcode,'') = '' -- NO NOT NEGATIVE <> != 
	GROUP BY r.authorizationid,ad.referralid,ad.diagcode,ad.diagqualifier,dc.[description],ad.[sequence]
	) -- CONCLUDE ...
	AS aliassetup
	) -- CONCLUDE ...
	AS rdiag ON ar.referralid = rdiag.referralid
		AND rdiag.[ROWis] = 1 -- ONLY PRIMARY DIAGNOSIS

UPDATE #AUTHRFI
SET [CPT Procedure code] = rcpt.[CPT Procedure code]
,[CPT Procedure code Description] = rcpt.[CPT Procedure code Description]
,[requested_units] = rcpt.[requested_units]
FROM #AUTHRFI AS ar
	INNER JOIN 
	( -- INITIATE ...	
	SELECT ' ' AS 'LIST WITH STRING_AGG() / MULTI CPT HCPC CODE(S): '
	,r.authorizationid
	,a.referralid
	,SUBSTRING(STRING_AGG(SUBSTRING(ISNULL(a.codeid,''),1,5),'|') WITHIN GROUP (ORDER BY a.[sequence] DESC),1,255) AS [CPT Procedure code] -- SQL STRING_AGG COMPONENTS: STRING_AGG(<<expr>>,<<separator>>)
	,SUBSTRING(STRING_AGG(ISNULL(CAST(ISNULL(procd.description,'') AS varchar(255)),''),'|') WITHIN GROUP (ORDER BY a.[sequence] DESC),1,255) AS [CPT Procedure code Description] -- SQL STRING_AGG COMPONENTS: STRING_AGG(<<expr>>,<<separator>>)
	,SUM(a.totalunits) AS [requested_units]
	-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
	-- SELECT DISTINCT ' ' AS 'CHECK 1st'
	FROM HMOPROD_PLANDATA.dbo.referral (NOLOCK) AS r
		INNER JOIN HMOPROD_PLANDATA.dbo.authservice (NOLOCK) AS a ON r.referralid = a.referralid
		INNER JOIN HMOPROD_PLANDATA.dbo.svccode AS  procd (NOLOCK)  ON SUBSTRING(LTRIM(RTRIM(ISNULL(a.codeid,''))),1,5) = SUBSTRING(LTRIM(RTRIM(ISNULL(procd.codeid,''))),1,5)
	WHERE 1=1 
		-- AND r.authorizationid IN ('4731258') -- SAMPLE - MULTI CODES
		AND NOT ISNULL(a.codeid,'') = '' -- NO NOT NEGATIVE <> !=
	GROUP BY r.authorizationid,a.referralid -- ,SUBSTRING(LTRIM(RTRIM(ISNULL(a.codeid,''))),1,5) ,UPPER(LTRIM(RTRIM(ISNULL(CAST(ISNULL(procd.description,'') AS varchar(255)),''))))
	) -- CONCLUDE ...
	AS rcpt ON ar.referralid = rcpt.referralid

UPDATE #AUTHRFI
SET [Rev code] = rrev.[Rev code]
,[Rev code Description] = rrev.[Rev code Description]
,[requested_units] = CASE
WHEN rrev.requested_units IS NULL
THEN rrev.[requested_units]
ELSE rrev.requested_units
END
FROM #AUTHRFI AS ar
	INNER JOIN 
	( -- INITIATE ...	
	SELECT ' ' AS 'LIST WITH STRING_AGG() / MULTI REV CODE(S): '
	,r.authorizationid
	,a.referralid
	,SUBSTRING(STRING_AGG(ISNULL(a.codeid,''),'|') WITHIN GROUP (ORDER BY a.[sequence] DESC),1,255) AS [Rev code] -- SQL STRING_AGG COMPONENTS: STRING_AGG(<<expr>>,<<separator>>)
	,SUBSTRING(STRING_AGG(ISNULL(CAST(ISNULL(rev.description,'') AS varchar(255)),''),'|') WITHIN GROUP (ORDER BY a.[sequence] DESC),1,255) AS [Rev code Description] -- SQL STRING_AGG COMPONENTS: STRING_AGG(<<expr>>,<<separator>>)
	,SUM(a.totalunits) AS [requested_units]
	-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
	-- SELECT DISTINCT ' ' AS 'CHECK 1st'
	FROM HMOPROD_PLANDATA.dbo.referral (NOLOCK) AS r
		INNER JOIN HMOPROD_PLANDATA.dbo.authservice (NOLOCK) AS a ON r.referralid = a.referralid
		INNER JOIN HMOPROD_PLANDATA.dbo.revcode AS rev (NOLOCK) ON CASE
		WHEN SUBSTRING(UPPER(LTRIM(RTRIM(ISNULL(a.codeid,'')))),1,1) = 'Z'
		THEN  UPPER(LTRIM(RTRIM(ISNULL(a.codeid,''))))
		WHEN SUBSTRING(UPPER(LTRIM(RTRIM(ISNULL(a.codeid,'')))),1,1) = '0'
		THEN  SUBSTRING(UPPER(LTRIM(RTRIM(ISNULL(a.codeid,'')))),2,3)
		ELSE UPPER(LTRIM(RTRIM(ISNULL(a.codeid,''))))
		END = CASE
		WHEN SUBSTRING(UPPER(LTRIM(RTRIM(ISNULL(rev.codeid,'')))),1,1) = 'Z'
		THEN  UPPER(LTRIM(RTRIM(ISNULL(rev.codeid,''))))
		WHEN SUBSTRING(UPPER(LTRIM(RTRIM(ISNULL(rev.codeid,'')))),1,1) = '0'
		THEN  SUBSTRING(UPPER(LTRIM(RTRIM(ISNULL(rev.codeid,'')))),2,3)
		ELSE UPPER(LTRIM(RTRIM(ISNULL(rev.codeid,''))))
		END
	WHERE 1=1 
		-- AND r.authorizationid IN ('4731258') -- SAMPLE - MULTI CODES
		AND NOT ISNULL(a.codeid,'') = '' -- NO NOT NEGATIVE <> !=
	GROUP BY r.authorizationid,a.referralid -- ,UPPER(LTRIM(RTRIM(ISNULL(a.codeid,'')))),UPPER(LTRIM(RTRIM(ISNULL(rev.description,''))))
	) -- CONCLUDE ...
	AS rrev ON ar.referralid = rrev.referralid







-- ======================================================================
	--  Part B Drug IDENTIFICATION: 
-- ======================================================================
;WITH PartB AS 
( -- INITIATE ...
SELECT 'Part B Drug CPT / HCPCS CODE: ' AS [CodeType]
,SUBSTRING(LTRIM(RTRIM(ISNULL(sc.codeid,''))),1,5) AS [CPTHCPC]
 ,ISNULL(sc.description,'') AS [CodeDescr]
  ,UPPER(LTRIM(RTRIM(ISNULL(scg.description,'')))) + ' - ' + UPPER(LTRIM(RTRIM(ISNULL(scat.description,'')))) + ': ' + UPPER(LTRIM(RTRIM(ISNULL(ssc.description,'')))) AS 'ServiceCatDescr'
,scg.catid
,scg.subcatid
,scg.svcgroupid
,sc.*
FROM HMOPROD_PLANDATA.dbo.svccode AS sc 
		LEFT JOIN HMOPROD_PLANDATA.dbo.svccatgroup AS scg ON sc.codeid = scg.codeid
		LEFT JOIN HMOPROD_PLANDATA.dbo.svccategory AS scat ON scg.catid = scat.catid
		LEFT JOIN HMOPROD_PLANDATA.dbo.svcsubcategory AS ssc ON scg.catid = ssc.catid
			AND scg.subcatid = ssc.subcatid
			AND scg.svcgroupid = 'C01154158'
WHERE 1=1 	
	AND SUBSTRING(UPPER(LTRIM(RTRIM(ISNULL(sc.codeid,'')))),1,1) = 'J' -- Any Rev Code or CPT code that starts with a J
	) -- CONCLUDE ...

		-- SELECT * FROM PartB

UPDATE #AUTHRFI
SET [Part B Drug Request] = 'Y'
,[Part B Drug CPT / HCPCS CODE] = TRY_CONVERT(nvarchar(255),(rcpt.[CPT Procedure code]+' | '+rcpt.[CPT Procedure code Description]))
FROM #AUTHRFI AS r
	INNER JOIN 
	( -- INITIATE ...	
	SELECT r.authorizationid
	,a.referralid
	,SUBSTRING(ISNULL(a.codeid,''),1,5) AS [CPT Procedure code]
	,ISNULL(CAST(ISNULL(procd.description,'') AS varchar(255)),'') AS [CPT Procedure code Description]
	-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
	-- SELECT DISTINCT ' ' AS 'CHECK 1st'
	FROM HMOPROD_PLANDATA.dbo.referral (NOLOCK) AS r
		INNER JOIN HMOPROD_PLANDATA.dbo.authservice (NOLOCK) AS a ON r.referralid = a.referralid
		INNER JOIN PartB ON SUBSTRING(LTRIM(RTRIM(ISNULL(a.codeid,''))),1,5) = PartB.[CPTHCPC]
		INNER JOIN HMOPROD_PLANDATA.dbo.svccode AS  procd (NOLOCK)  ON SUBSTRING(LTRIM(RTRIM(ISNULL(a.codeid,''))),1,5) = SUBSTRING(LTRIM(RTRIM(ISNULL(procd.codeid,''))),1,5)
	WHERE 1=1 
		AND NOT ISNULL(a.codeid,'') = '' -- NO NOT NEGATIVE <> !=
	GROUP BY r.authorizationid,a.referralid,SUBSTRING(ISNULL(a.codeid,''),1,5),ISNULL(CAST(ISNULL(procd.description,'') AS varchar(255)),'')
		) -- CONCLUDE ...
		AS rcpt ON r.referralid = rcpt.referralid







-- ==========================================================
	-- AUTH ATTRIBUTE(S) --
-- ==========================================================
SELECT ' ' AS [DHCS AUDIT REQUEST - COMBINED ATTRIBUTE PASS]
,r.memid
,r.authorizationid
,attrib.referralid
,attrib.thevalue
,attrib.effdate
,CAST(TRY_CONVERT(date,attrib.effdate) AS nvarchar(255))+''+TRY_CONVERT(datetime,attrib.thevalue) AS [ATTRIB_DATETIME]
,TRY_CONVERT(date,attrib.effdate) AS [ATTRIB_DATE]
/* ,CASE
WHEN LEN(LTRIM(RTRIM(CAST(DATEPART(hh,CAST(attrib.effdate AS datetime)) AS nvarchar(2)))))=1
THEN '0'+CAST(DATEPART(hh,CAST(attrib.effdate AS datetime)) AS nvarchar(2))
ELSE CAST(DATEPART(hh,CAST(attrib.effdate AS datetime)) AS nvarchar(2))
END
+':'+CASE
WHEN LEN(LTRIM(RTRIM(CAST(DATEPART(mi,CAST(attrib.effdate AS datetime)) AS nvarchar(2)))))=1
THEN '0'+CAST(DATEPART(mi,CAST(attrib.effdate AS datetime)) AS nvarchar(2))
ELSE CAST(DATEPART(mi,CAST(attrib.effdate AS datetime)) AS nvarchar(2))
END
+':'+CASE
WHEN LEN(LTRIM(RTRIM(CAST(DATEPART(ss,CAST(attrib.effdate AS datetime)) AS nvarchar(2)))))=1
THEN '0'+CAST(DATEPART(ss,CAST(attrib.effdate AS datetime)) AS nvarchar(2))
ELSE CAST(DATEPART(ss,CAST(attrib.effdate AS datetime)) AS nvarchar(2))
END AS [ATTRIB_TIME] */
,attrib.thevalue AS [ATTRIB_TIME]
,q.[description] AS [ATTRIBUTE DESCRIPTION]
,CASE
WHEN UPPER(LTRIM(RTRIM(ISNULL(q.description,'')))) LIKE '%MODIFIED%' 
THEN 'MODIFIED'
WHEN UPPER(LTRIM(RTRIM(ISNULL(q.description,'')))) LIKE '%EXTEN%LETTER%' 
THEN 'EXTENSION'
WHEN UPPER(LTRIM(RTRIM(ISNULL(q.description,'')))) LIKE '%AUTH%NOTIFI%LETT%SENT%' 
THEN 'NOTIFICATION'
WHEN UPPER(LTRIM(RTRIM(ISNULL(q.description,'')))) LIKE '%THRESH%SENT%' 
THEN 'THRESHOLD'
WHEN UPPER(LTRIM(RTRIM(ISNULL(q.description,'')))) LIKE '%ORAL%NOTIFI%PROVID%' 
THEN 'ORAL'
END AS [ATTR_TYPE]
INTO #authattributes
FROM HMOPROD_PLANDATA.dbo.qattribute (NOLOCK) AS q
	INNER JOIN HMOPROD_PLANDATA.dbo.referralattribute (NOLOCK) AS attrib ON q.attributeid = attrib.attributeid
	INNER JOIN HMOPROD_PLANDATA.dbo.referral (NOLOCK) AS r ON attrib.referralid = r.referralid
	INNER JOIN #AUTHRFI AS tscope ON r.referralid = tscope.referralid -- OPT007: Scope to staged referralids only
WHERE 1=1 -- OPT002: Single-pass attribute extraction replacing 5 separate reads of qattribute+referralattribute+referral.
	AND (
	UPPER(LTRIM(RTRIM(ISNULL(q.description,'')))) LIKE '%MODIFIED%'  -- C001: UPDATE per eMAIL FROM MS ERICA ON 20240202 RELATED TO RESULTING AUDIT CAP (CORRECTION ACTION PLAN) ... Hi Phil, We need your assistance to comply with our 2023 DHCS CAP 1.2.1 response. Attached, is a copy of the report my team receives monthly for our internal audit review (link also included below). Index of \\chg_cifs01\Shared\HCS2017\HCS Audit - SARAG Reports\ Request: Please label any case with a 'MODIFIED' attribute IN QNXT, UM Record, Misc. tab, AS 'Modified' for Column M (Request Determination) ON this report. NOTe, will be zero identified for now, AS this is a new process.
		OR UPPER(LTRIM(RTRIM(ISNULL(q.description,'')))) LIKE '%EXTEN%LETTER%' -- C00863753
		OR UPPER(LTRIM(RTRIM(ISNULL(q.description,'')))) LIKE '%AUTH%NOTIFI%LETT%SENT%' -- C00863757
		OR UPPER(LTRIM(RTRIM(ISNULL(q.description,'')))) LIKE '%THRESH%SENT%'  -- C01236757 + C01236806
		OR UPPER(LTRIM(RTRIM(ISNULL(q.description,'')))) LIKE '%ORAL%NOTIFI%PROVID%'
		-- OR q.attributeid IN ('C00863753','C00887907') -- AUTH EXTENSION LETTER SENT + ORAL NOTIFICATION PROVIDED
		);

CREATE INDEX idx_authattributes ON #authattributes (referralid,[ATTR_TYPE]) INCLUDE ([ATTRIB_DATETIME],[ATTRIB_DATE],[ATTRIB_TIME]);

UPDATE #AUTHRFI
SET [Modified] = 'Y'
FROM #AUTHRFI AS ar
	INNER JOIN #authattributes AS attr ON ar.referralid = attr.referralid
WHERE 1=1
	AND attr.[ATTR_TYPE] = 'MODIFIED';

UPDATE #AUTHRFI
SET [Extended] = 'Y'
FROM #AUTHRFI AS ar
	INNER JOIN #authattributes AS attr ON ar.referralid = attr.referralid
WHERE 1=1
	AND attr.[ATTR_TYPE] = 'EXTENSION';

UPDATE #AUTHRFI
SET [Attribute Date /Time] = TRY_CONVERT(datetime2,attr.[ATTRIB_DATETIME])
FROM #AUTHRFI AS ar
	INNER JOIN #authattributes AS attr ON ar.referralid = attr.referralid
WHERE 1=1
	AND attr.[ATTR_TYPE] = 'NOTIFICATION';
	
/* UPDATE #AUTHRFI
SET [Attribute Date /Time] = TRY_CONVERT(datetime2,attr.[ATTRIB_DATETIME])
FROM #AUTHRFI AS ar
	INNER JOIN #authattributes AS attr ON ar.referralid = attr.referralid
WHERE 1=1
	AND attr.[ATTR_TYPE] = 'THRESHOLD';	 */

UPDATE #AUTHRFI
SET [Oral Attribute Date /Time] = TRY_CONVERT(datetime2,attr.[ATTRIB_DATETIME])
FROM #AUTHRFI AS ar
	INNER JOIN #authattributes AS attr ON ar.referralid = attr.referralid
WHERE 1=1
	AND attr.[ATTR_TYPE] = 'ORAL';







-- ==================================================
	-- [TAT] | [Threshold] UPDATE(S) --
-- ==================================================
UPDATE #AUTHRFI -- POWER CYCLE RESET REFRESH RESTART ...
SET TAT = CAST(0 AS money)
,Threshold = CAST(NULL AS int)

/* UPDATE #AUTHRFI
SET [ClockStop] = TRY_CONVERT(datetime,ISNULL([Attribute Date /Time],[ClockStop])) -- C010: NCQA MEDI-CAL 2026 NARRATIVE 6.3.26: Override ClockStop with Auth Notification Letter Sent date ...  TAT Column I = Column H (receipt date) to Column D (notification date) ... Applied AFTER LIKE '%AUTH%NOTIFI%LETT%SENT%'  is populated.
FROM #AUTHRFI AS ar
WHERE 1=1
	AND [Attribute Date /Time] IS NOT NULL */
	
UPDATE #AUTHRFI
SET [Threshold] = CASE
WHEN ar.Extended = 'N'
	AND ar.acuity_priority = 'Expedited' 
THEN 72 -- HOUR(S)
WHEN ar.Extended = 'N'
	AND ar.LINE_OF_BUSINESS LIKE '%MEDI-CAL%'
THEN 5 -- business days
WHEN ar.Extended = 'N'
	AND ar.LINE_OF_BUSINESS LIKE '%DSNP%' 
THEN 14 -- calendar days
WHEN ar.Extended = 'N'
	AND ar.LINE_OF_BUSINESS LIKE '%CMC%' 
THEN 14 -- calendar days
WHEN ar.Extended = 'Y'  
	AND ar.acuity_priority = 'Standard' 
THEN 28 -- calendar days
WHEN ar.Extended = 'Y'  
AND ar.acuity_priority = 'Expedited' 
THEN 14 -- calendar days
END
,[Units] = CASE
WHEN ar.Extended = 'N' 
	AND ar.acuity_priority = 'Expedited' 
THEN 'Hours'
WHEN ar.Extended = 'N'
	AND ar.LINE_OF_BUSINESS LIKE '%MEDI-CAL%'
THEN 'Business Days'
ELSE 'Calendar Days'
END
FROM #AUTHRFI AS ar

		/* ,CONVERT(datetime,(r.UtcReceiptDate AT TIME ZONE 'UTC') AT TIME ZONE 'Pacific Standard Time') AS [ClockStart] -- C000: UTC to PST. TAT clock start. 9. TAT (Urgent requests 72 hours from Receipt to Seen date & time) (Routine requests 5 working days from Receipt to Seen date & time)
		,CASE
		WHEN r.[status] = 'PEND' THEN GETDATE()
		ELSE r.seendate
		END AS [ClockStop] -- C010: ClockStop will be overridden below with Auth Notification Letter Sent date per NCQA MEDI-CAL 2026 NARRATIVE Column D spec. 9. TAT (Urgent requests 72 hours from Receipt to Seen date & time) (Routine requests 5 working days from Receipt to Seen date & time) */

UPDATE #AUTHRFI
SET [TAT] = CASE 
WHEN ar.Units = 'Hours'
THEN ISNULL(tath.[TAT],0)
WHEN ar.Units = 'Business Days'	
THEN ISNULL(tatwd.[TAT],0)
ELSE DATEDIFF(day,ar.ClockStart,ar.ClockStop)
END -- 9.	TAT (Urgent requests 72 hours from Receipt to Seen date & time) (Routine requests 5 working days from Receipt to Seen date & time)
FROM #AUTHRFI AS ar
		LEFT JOIN 
		( -- INITIATE ...
		SELECT r.referralid,r.authorizationid
		,COUNT(DISTINCT(dc.calendar_date)) AS [TAT]
		FROM INFORMATICS.dbo.date_calendarISO AS dc -- CALENDAR(S)
		CROSS APPLY ( -- INDEPENDENT STAND ALONE ... CROSS APPLY() CROSS JOIN() CARTESIAN PRODUCT	
		SELECT referralid
		,authorizationid
		,ClockStart
		,ClockStop
		FROM #AUTHRFI
		GROUP BY referralid,authorizationid	,ClockStart,ClockStop
		) AS r	
		WHERE 1=1 
			AND dc.calendar_date BETWEEN r.ClockStart AND r.ClockStop 
			AND ISNULL(dc.WORKDAY,0) = 1 
			AND ISNULL(dc.HOLIDAYS,0) = 0
		GROUP BY r.referralid,r.authorizationid
		) -- CONCLUDE ...
		AS tatwd ON ar.referralid = tatwd.referralid
			AND ar.authorizationid = tatwd.authorizationid
		LEFT JOIN 
		( -- INITIATE ...
		SELECT DISTINCT referralid,authorizationid
		,DATEDIFF(hh,ClockStart,ClockStop) AS [TAT]
		FROM #AUTHRFI
		) -- CONCLUDE ...
		AS tath ON ar.referralid = tath.referralid
			AND ar.authorizationid = tath.authorizationid







-- =====================================================================
	-- [Primary or secondary claim] OR [Member Status (Primary, Secondary] --
-- =====================================================================
UPDATE #AUTHRFI
SET [Primary / Secondary Status] = estatus.[Plan Position Status] -- [Primary or secondary claim] OR [Member Status (Primary, Secondary] see "DMP" FOR alt. SEQUENCE
 FROM #AUTHRFI AS su
	INNER JOIN 
	( -- INITIATE ...
	SELECT DISTINCT es.primarystatus AS [Plan Position Status]
	,ek.carriermemid
	,ek.memid
	,es.effdate
	,es.termdate
	,es.primarystatus AS [STATUS INDICATOR]
	,ec.ratecode
	,pg.programid
	,bp.planid
	,bp.description
	,ek.enrollid
	,r.referralid
	-- SELECT TOP 10 estatus.[STATUS INDICATOR],su.* -- CHECK 1st
	-- SELECT DISTINCT ' ' AS 'CHECK 1st'
	FROM HMOPROD_PLANDATA.dbo.enrollkeys AS ek (NOLOCK)
		INNER JOIN HMOPROD_PLANDATA.dbo.member AS mem (NOLOCK) ON ek.memid = mem.memid
			LEFT JOIN HMOPROD_PLANDATA.dbo.benefitplan AS bp (NOLOCK) ON ek.programid = bp.programid
		INNER JOIN HMOPROD_PLANDATA.dbo.program AS pg (NOLOCK) ON ek.programid = pg.programid
		INNER JOIN HMOPROD_PLANDATA.dbo.entity AS ent (NOLOCK) ON mem.entityid = ent.entid
		INNER JOIN HMOPROD_PlanData.dbo.enrollstatus AS es (NOLOCK) ON ek.enrollid = es.enrollid		
		INNER JOIN HMOPROD_PLANDATA.dbo.enrollcoverage AS ec (NOLOCK) ON ek.enrollid = ec.enrollid
		INNER JOIN HMOPROD_PLANDATA.dbo.referral (NOLOCK) AS r ON ek.memid = r.memid
			AND ek.enrollid = r.enrollid -- planid / programid JOIN
	WHERE 1=1 
		AND CAST(r.effdate AS date) BETWEEN CAST(ek.effdate AS date) AND CAST(ek.termdate AS date) -- RINA: APPLIED TO FIELD WITHIN TABLE TO BE UPDATE
		AND UPPER(LTRIM(RTRIM(ISNULL(ek.segtype,'')))) ='INT'
		-- AND CAST(ek.effdate AS date) <= @when
		-- AND CAST(ek.termdate AS date) >= @when
		AND CAST(ek.termdate AS date) != CAST(ek.effdate AS date)
		AND CAST(ek.termdate AS date) > CAST(ek.effdate AS date)
		) -- CONCLUDE ...
		AS estatus ON su.referralid = estatus.referralid
		-- AS estatus ON su.memid = estatus.memid
			-- AND su.programid = estatus.programid
WHERE 1=1 
	AND CAST(su.effdate AS date) BETWEEN CAST(estatus.effdate AS date) AND CAST(estatus.termdate AS date)	-- RINA: APPLIED TO FIELD WITHIN TABLE TO BE UPDATE







-- =====================================================================
	-- contracted PROVIDER(s) + QUPD TRUST but VERIFY contracted status ci.contracted --
-- =====================================================================
UPDATE #AUTHRFI
SET [ReferFromcontractedVerification] = TRY_CONVERT(nvarchar(1),NULL) -- POWER CYCLE RESET REFRESH RESTART ...
,[RefertocontractedVerification] = TRY_CONVERT(nvarchar(1),NULL) -- POWER CYCLE RESET REFRESH RESTART ...
-- ,[contractedVerification] = TRY_CONVERT(nvarchar(1),NULL) -- POWER CYCLE RESET REFRESH RESTART ...

	-- THE [ReferFrom]: 
UPDATE #AUTHRFI
SET [ReferFromcontractedVerification] = fpp.[contracted] -- C002: QNXT FALSE PAR STATUS LOGIC APPLIED PER DISCUSSION WITH() SIR PHIL ON 20230223 
FROM #AUTHRFI AS ar
	-- INNER JOIN INFORMATICS.dbo.[uvw_FALSE_PROVIDER_PAR] AS fpp ON ar.referto = fpp.provid
	INNER JOIN INFORMATICS.dbo.[uvw_FALSE_PROVIDER_PAR] AS fpp ON ar.referfrom = fpp.provid -- FOR AUDITS LIKE 'SOD' OR 'ODG' THE [ReferFrom] PAR STATUS IS BEING REQUESTED FORMERLY #CURRENTCONTRACT / see "STEP88_FALSE_PROVIDER_PAR_...sql"

UPDATE #AUTHRFI 
SET [ReferFromcontractedVerification] = fpp.[contracted] 
FROM #AUTHRFI AS ar
	-- INNER JOIN INFORMATICS.dbo.[uvw_FALSE_PROVIDER_PAR] AS fpp ON ar.referto = fpp.provid
	INNER JOIN INFORMATICS.dbo.[uvw_FALSE_PROVIDER_PAR] AS fpp ON ar.referfrom = fpp.provid -- FOR AUDITS LIKE 'SOD' OR 'ODG' THE [ReferFrom] PAR STATUS IS BEING REQUESTED FORMERLY #CURRENTCONTRACT / see "STEP88_FALSE_PROVIDER_PAR_...sql"
WHERE 1=1
	AND ISNULL(fpp.[contracted],'Y') = 'Y' -- C009: DEFAULT TO 'Y' OVERRIDE PER SIR YOUSAF INSTRUCTION DURING UM WEEKLY ON 20260325

UPDATE #AUTHRFI 
SET [ReferFromcontractedVerification] = piso.[contracted] 
FROM #AUTHRFI AS ar
	-- INNER JOIN INFORMATICS.dbo.[uvw_PROVISO] AS piso ON ar.referto = piso.provid
	INNER JOIN INFORMATICS.dbo.[uvw_PROVISO] AS piso ON ar.referfrom = piso.provid -- FOR AUDITS LIKE 'SOD' OR 'ODG' THE [ReferFrom] PAR STATUS IS BEING REQUESTED FORMERLY #CURRENTCONTRACT / see "STEP88_FALSE_PROVIDER_PAR_...sql"
WHERE 1=1
	AND ISNULL(piso.[contracted],'Y') = 'Y' -- C009: DEFAULT TO 'Y' OVERRIDE PER SIR YOUSAF INSTRUCTION DURING UM WEEKLY ON 20260325

UPDATE #AUTHRFI
SET ReferFromcontractedVerification = 'Y' -- ACTIVE 274 274 PAR OVERRIDE ~ LEVERAGE "QNXT CXO EXECUTIVE SUMMARY CONTRACT PAR STATUS.jpg" AND 'uvw_FALSE_PROVIDER_PAR' AND 'uvw_ProviderRepository274_PAR' ... ReferFromcontractedVerification = NULL / 'N' NON-PAR (no contractinfo matchand not active on 274 roster) ... ISNULL(ReferFromcontractedVerification,'N')
FROM #AUTHRFI AS source
	-- INNER JOIN SQLPRODAPP01.INFORMATICS.dbo.uvw_ProviderRepository274_PAR AS pr ON ISNULL(source.refertoNPI,'') = ISNULL(pr.[Provider NPI],'') 
	INNER JOIN SQLPRODAPP01.INFORMATICS.dbo.uvw_ProviderRepository274_PAR AS pr ON ISNULL(source.referfromNPI,'') = ISNULL(pr.[Provider NPI],'') -- FOR AUDITS LIKE 'SOD' OR 'ODG' THE [ReferFrom] PAR STATUS IS BEING REQUESTED FORMERLY #CURRENTCONTRACT / see "STEP88_FALSE_PROVIDER_PAR_...sql"
	
UPDATE #AUTHRFI 
SET [ReferFromcontractedVerification] = ISNULL(ReferFromcontractedVerification,'Y') -- C009: DEFAULT TO 'Y' OVERRIDE PER SIR YOUSAF INSTRUCTION DURING UM WEEKLY ON 20260325

	-- THE [ReferTo]: 
UPDATE #AUTHRFI
SET [ReferTocontractedVerification] = fpp.[contracted] -- C002: QNXT FALSE PAR STATUS LOGIC APPLIED PER DISCUSSION WITH() SIR PHIL ON 20230223 
FROM #AUTHRFI AS ar
	-- INNER JOIN INFORMATICS.dbo.[uvw_FALSE_PROVIDER_PAR] AS fpp ON ar.referto = fpp.provid
	INNER JOIN INFORMATICS.dbo.[uvw_FALSE_PROVIDER_PAR] AS fpp ON ar.referfrom = fpp.provid -- FOR AUDITS LIKE 'SOD' OR 'ODG' THE [ReferFrom] PAR STATUS IS BEING REQUESTED FORMERLY #CURRENTCONTRACT / see "STEP88_FALSE_PROVIDER_PAR_...sql"

UPDATE #AUTHRFI 
SET [ReferTocontractedVerification] = fpp.[contracted] 
FROM #AUTHRFI AS ar
	-- INNER JOIN INFORMATICS.dbo.[uvw_FALSE_PROVIDER_PAR] AS fpp ON ar.referto = fpp.provid
	INNER JOIN INFORMATICS.dbo.[uvw_FALSE_PROVIDER_PAR] AS fpp ON ar.referfrom = fpp.provid -- FOR AUDITS LIKE 'SOD' OR 'ODG' THE [ReferFrom] PAR STATUS IS BEING REQUESTED FORMERLY #CURRENTCONTRACT / see "STEP88_FALSE_PROVIDER_PAR_...sql"
WHERE 1=1
	AND ISNULL(fpp.[contracted],'Y') = 'Y' -- C009: DEFAULT TO 'Y' OVERRIDE PER SIR YOUSAF INSTRUCTION DURING UM WEEKLY ON 20260325

UPDATE #AUTHRFI 
SET [ReferTocontractedVerification] = piso.[contracted] 
FROM #AUTHRFI AS ar
	-- INNER JOIN INFORMATICS.dbo.[uvw_PROVISO] AS piso ON ar.referto = piso.provid
	INNER JOIN INFORMATICS.dbo.[uvw_PROVISO] AS piso ON ar.referfrom = piso.provid -- FOR AUDITS LIKE 'SOD' OR 'ODG' THE [ReferFrom] PAR STATUS IS BEING REQUESTED FORMERLY #CURRENTCONTRACT / see "STEP88_FALSE_PROVIDER_PAR_...sql"
WHERE 1=1
	AND ISNULL(piso.[contracted],'Y') = 'Y' -- C009: DEFAULT TO 'Y' OVERRIDE PER SIR YOUSAF INSTRUCTION DURING UM WEEKLY ON 20260325

UPDATE #AUTHRFI
SET ReferTocontractedVerification = 'Y' -- ACTIVE 274 274 PAR OVERRIDE ~ LEVERAGE "QNXT CXO EXECUTIVE SUMMARY CONTRACT PAR STATUS.jpg" AND 'uvw_FALSE_PROVIDER_PAR' AND 'uvw_ProviderRepository274_PAR' ... ReferTocontractedVerification = NULL / 'N' NON-PAR (no contractinfo matchand not active on 274 roster) ... ISNULL(ReferTocontractedVerification,'N')
FROM #AUTHRFI AS source
	-- INNER JOIN SQLPRODAPP01.INFORMATICS.dbo.uvw_ProviderRepository274_PAR AS pr ON ISNULL(source.refertoNPI,'') = ISNULL(pr.[Provider NPI],'') 
	INNER JOIN SQLPRODAPP01.INFORMATICS.dbo.uvw_ProviderRepository274_PAR AS pr ON ISNULL(source.referfromNPI,'') = ISNULL(pr.[Provider NPI],'') -- FOR AUDITS LIKE 'SOD' OR 'ODG' THE [ReferFrom] PAR STATUS IS BEING REQUESTED FORMERLY #CURRENTCONTRACT / see "STEP88_FALSE_PROVIDER_PAR_...sql"
	
UPDATE #AUTHRFI 
SET [ReferTocontractedVerification] = ISNULL(ReferTocontractedVerification,'Y') -- C009: DEFAULT TO 'Y' OVERRIDE PER SIR YOUSAF INSTRUCTION DURING UM WEEKLY ON 20260325







-- =====================================================================
	-- SOURCE: PCP UPDATE() --
-- =====================================================================
UPDATE #AUTHRFI
SET [Name of PCP] = UPPER(LTRIM(RTRIM(pcp.PCPName)))
,[PCP Address] = UPPER(LTRIM(RTRIM(pcp.ServiceLocationName)))
FROM #AUTHRFI AS tn
	INNER JOIN INFORMATICS.dbo.[uvw_PCP] AS pcp ON tn.memid = pcp.memid
WHERE 1=1
	AND TRY_CONVERT(date,RECEIPT_DATE) BETWEEN TRY_CONVERT(date,pcp.effdate) AND TRY_CONVERT(date,pcp.termdate) -- RINA(): APPLIED TO FIELD WITHIN TABLE TO BE UPDATED

UPDATE #AUTHRFI -- USE IIF() STILL NULL()
SET [Name of PCP] = UPPER(LTRIM(RTRIM(pcp.PCPName)))
,[PCP Address] = UPPER(LTRIM(RTRIM(pcp.ServiceLocationName)))
FROM #AUTHRFI AS tn
	INNER JOIN INFORMATICS.dbo.[uvw_PCP] AS pcp ON tn.memid = pcp.memid
WHERE 1=1
	AND pcp.RANKis IN (@PCPrecordRANK)
	AND pcp.ROWis IN (@PCPrecordRANK)
	AND tn.[Name of PCP] IS NULL







-- =====================================================================
	-- INCLUSION / EXCLUSION:
-- =====================================================================
/* UPDATE #AUTHRFI -- POWER CYCLE RESET REFRESH RESTART ... 
SET [DETAILelement] = TRY_CONVERT(nvarchar(2000),NULL);

UPDATE #AUTHRFI
SET [DETAILelement] = 'DELETE';

UPDATE #AUTHRFI
SET [DETAILelement] = 'KEEP'
FROM #AUTHRFI AS t
WHERE 1=1
	AND TRY_CONVERT(date,ISNULL([Attribute Date /Time],GETDATE())) BETWEEN @ClockStart AND @ClockStop -- SET [Attribute Date /Time] = TRY_CONVERT(datetime2,attr.[ATTRIB_DATETIME]);

DELETE #AUTHRFI
FROM #AUTHRFI
WHERE 1=1
	AND ISNULL([DETAILelement],'DELETE') = 'DELETE';

		SELECT ' ' AS 'Verify: Expected 427 rows:',COUNT(*) AS TotalCodes FROM INFORMATICS.dbo.MediCalOnly_CPT_Exclusions;
		SELECT ' ' AS 'Verify: Expected 427 rows DETAIL:',* FROM INFORMATICS.dbo.MediCalOnly_CPT_Exclusions;

WITH medicaidonly AS -- LEVERAGE: "List_of_only_Medi-Cal_codes_2_11_26.docx" AND "MediCal_Exclusive_CPT_Exclusion_SQL.sql" ... Purpose: Exclude Medicaid-only CPT codes from D-SNP Org Determinations
( -- INITIATE ...
SELECT a.referralid
-- SELECT TOP 10 ' ' AS 'CHECK 1st',* 
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM HMOPROD_PLANDATA.dbo.authservice (NOLOCK) AS a
	INNER JOIN INFORMATICS.dbo.MediCalOnly_CPT_Exclusions AS moexclusion ON SUBSTRING(UPPER(LTRIM(RTRIM(ISNULL(a.codeid,'')))),1,5) = moexclusion.CPTCode
GROUP BY a.referralid
) -- CONCLUDE ...

		-- SELECT TOP 10 ' ' AS 'Purpose: Exclude Medicaid-only CPT codes from D-SNP Org Determinations: ',* FROM medicaidonly 

UPDATE #AUTHRFI
SET [AUTH CATEGORY] = 'Medicaid-only CPT code' -- C013: Purpose: Exclude Medicaid-only CPT codes from D-SNP Org Determinations ...LEVERAGE: "List_of_only_Medi-Cal_codes_2_11_26.docx" AND "MediCal_Exclusive_CPT_Exclusion_SQL.sql"
FROM #AUTHRFI AS a
	INNER JOIN medicaidonly AS moc ON a.referralid = moc.referralid
	
DELETE 
FROM #AUTHRFI
WHERE 1=1
	AND [AUTH CATEGORY] = 'Medicaid-only CPT code'
	
UPDATE #AUTHRFI -- POWER CYCLE RESET REFRESH RESTART ... 
SET [DETAILelement] = TRY_CONVERT(nvarchar(2000),NULL) */







-- =====================================================================
	-- OPEN AUTHORIZATION AGING SUMMARY: 
-- =====================================================================
;WITH DetailedAging AS (
SELECT [AUTH CATEGORY]
,[AuthRefType (Template)]
,[AuthRefType (Grouping)]
,LINE_OF_BUSINESS
,status AS 'HeaderStatus'
,authorizationid
,memid
,DATEDIFF(day, TRY_CONVERT(date,RECEIPT_DATE), TRY_CONVERT(date,GETDATE())) AS 'Days Outstanding'
,CASE 
WHEN DATEDIFF(day, TRY_CONVERT(date,RECEIPT_DATE), TRY_CONVERT(date,GETDATE())) <= 30 
THEN '0-30 Days'
WHEN DATEDIFF(day, TRY_CONVERT(date,RECEIPT_DATE), TRY_CONVERT(date,GETDATE())) BETWEEN 31 AND 60 
THEN '31-60 Days'
WHEN DATEDIFF(day, TRY_CONVERT(date,RECEIPT_DATE), TRY_CONVERT(date,GETDATE())) BETWEEN 61 AND 90 
THEN '61-90 Days'
WHEN DATEDIFF(day, TRY_CONVERT(date,RECEIPT_DATE), TRY_CONVERT(date,GETDATE())) > 90 
THEN '> 90 Days'
ELSE 'Unknown'
END AS 'Aging Category'
FROM #AUTHRFI 
WHERE 1=1
	AND NOT ISNULL([HeaderStatus],'') IN ('CLOSED') -- NO NOT NEGTIVE <> != ...
	AND TRY_CONVERT(date,RECEIPT_DATE) >= TRY_CONVERT(date,'07/01/2025')
	)
,AgingSummary AS (
SELECT [AUTH CATEGORY]
,[AuthRefType (Template)]
,[AuthRefType (Grouping)]
,LINE_OF_BUSINESS
,[HeaderStatus]
,[Aging Category]
,COUNT(DISTINCT authorizationid) AS 'AuthCount'
,COUNT(DISTINCT memid) AS 'MemberCount'
,AVG(CAST([Days Outstanding] AS FLOAT)) AS 'AvgDaysOutstanding'
FROM DetailedAging
GROUP BY [AUTH CATEGORY],[AuthRefType (Template)],[AuthRefType (Grouping)],LINE_OF_BUSINESS,[HeaderStatus],[Aging Category]
)
SELECT ' ' AS 'AUTHORIZATION AGING SUMMARY (PIVOT) AS OF 20250701: '
,[AUTH CATEGORY]
,[AuthRefType (Template)]
,[AuthRefType (Grouping)]
,LINE_OF_BUSINESS
,[HeaderStatus]
,ISNULL([0-30 Days],0) AS '0-30 Days'
,ISNULL([31-60 Days],0) AS '31-60 Days'
,ISNULL([61-90 Days],0) AS '61-90 Days'
,ISNULL([> 90 Days],0) AS '> 90 Days'
,ISNULL([Unknown],0) AS 'Unknown/Invalid Dates'
,ISNULL([0-30 Days],0) + ISNULL([31-60 Days],0) + ISNULL([61-90 Days],0) + ISNULL([> 90 Days],0) + ISNULL([Unknown],0) AS 'Total Open Auths'
,(SELECT COUNT(DISTINCT memid) 
FROM DetailedAging AS da2 
WHERE 1=1
	AND da2.[AUTH CATEGORY] = summary.[AUTH CATEGORY]
	AND da2.[AuthRefType (Template)] = summary.[AuthRefType (Template)]
	AND da2.[AuthRefType (Grouping)] = summary.[AuthRefType (Grouping)]
	AND da2.LINE_OF_BUSINESS = summary.LINE_OF_BUSINESS
	AND da2.[HeaderStatus] = summary.[HeaderStatus]
	) AS 'Unique Members'
,(SELECT TRY_CONVERT(decimal(5,1),AVG(CAST([Days Outstanding] AS FLOAT)))
FROM DetailedAging AS da3 
WHERE 1=1
	AND da3.[AUTH CATEGORY] = summary.[AUTH CATEGORY]
	AND da3.[AuthRefType (Template)] = summary.[AuthRefType (Template)]
	AND da3.[AuthRefType (Grouping)] = summary.[AuthRefType (Grouping)]
	AND da3.LINE_OF_BUSINESS = summary.LINE_OF_BUSINESS
	AND da3.[HeaderStatus] = summary.[HeaderStatus]
	AND da3.[Aging Category] != 'Unknown' -- NO NOT NEGATIVE <> != ...
	) AS 'Avg Days Outstanding'
FROM 
( -- INITIATE ...
SELECT [AUTH CATEGORY]
,[AuthRefType (Template)]
,[AuthRefType (Grouping)]
,LINE_OF_BUSINESS
,[HeaderStatus]
,[0-30 Days]
,[31-60 Days]
,[61-90 Days]
,[> 90 Days]
,[Unknown]
FROM (
SELECT [AUTH CATEGORY]
,[AuthRefType (Template)]
,[AuthRefType (Grouping)]
,LINE_OF_BUSINESS
,[HeaderStatus]
,[Aging Category]
,AuthCount
FROM AgingSummary
) AS SourceTable
PIVOT 
( -- INITIATE ...
SUM(AuthCount)
FOR [Aging Category] IN ([0-30 Days] ,[31-60 Days] ,[61-90 Days] ,[> 90 Days],[Unknown])
) -- CONCLUDE ...
AS PivotTable
) -- CONCLUDE ...
AS summary







-- ============================================================= 
	-- SUMMARY / SUBTOTAL() ROLLUP v. CUBE --
-- =============================================================
SELECT ' ' AS 'AUTH SUMMARY: '
,[RANGE NOTE(s)]
,status
,COUNT(DISTINCT(referralid)) AS [Referrals]
,COUNT(DISTINCT(authorizationid)) AS [Auths]
,COUNT(DISTINCT(memid)) AS [Unique Members] 
FROM #AUTHRFI
 GROUP BY [RANGE NOTE(s)],status

SELECT DISTINCT ' ' AS 'AUTH ReferFrom /  ReferTo LISTING: '
,[RANGE NOTE(s)]                                                                                                                               
,referto
,ReferToNPI
,ReferToProv
,ReferFrom
,ReferFromNPI
,ReferFromProv
FROM #AUTHRFI
ORDER BY ReferToProv

SELECT ' ' AS 'OPEN AUTH SUMMARY'
,[RANGE NOTE(s)]
,status,COUNT(DISTINCT(referralid)) AS [Referrals]
,COUNT(DISTINCT(authorizationid)) AS [Auths]
,COUNT(DISTINCT(memid)) AS [Unique Members] 
FROM #AUTHRFI 
WHERE 1=1
	AND [CLAIM ASSOCIATED WITH AUTH] IS NULL 
	AND TRY_CONVERT(date,termdate) >= TRY_CONVERT(date,GETDATE()) GROUP BY [RANGE NOTE(s)],status

SELECT ' ' AS 'CLOSED AUTH SUMMARY'
,[RANGE NOTE(s)]
,status
,COUNT(DISTINCT(referralid)) AS [Referrals]
,COUNT(DISTINCT(authorizationid)) AS [Auths]
,COUNT(DISTINCT(memid)) AS [Unique Members] 
FROM #AUTHRFI 
WHERE 1=1
	AND [CLAIM ASSOCIATED WITH AUTH] IS NOT NULL 
GROUP BY [RANGE NOTE(s)],status

SELECT DISTINCT ' ' AS 'QA TEMPLATE TYPE OPTION(S)'
,[AuthRefType (Template)]
,servicecode
,status 
FROM #AUTHRFI

SELECT ' ' AS 'QA DATE RANGE + [LOB]'
,LINE_OF_BUSINESS
,MIN (TRY_CONVERT(date,RECEIPT_DATE)) AS [RANGE MIN]
,MAX(TRY_CONVERT(date,RECEIPT_DATE)) AS [RANGE MAX]
,COUNT(DISTINCT(referralid)) AS [AUTH(S)]
,COUNT(DISTINCT(memid)) AS [Unique Members] 
FROM #AUTHRFI
GROUP BY LINE_OF_BUSINESS

SELECT ' ' AS 'QA DATE RANGE + [servicecode]'
,servicecode
,MIN (TRY_CONVERT(date,RECEIPT_DATE)) AS [RANGE MIN]
,MAX(TRY_CONVERT(date,RECEIPT_DATE)) AS [RANGE MAX]
,COUNT(DISTINCT(referralid)) AS [AUTH(S)]
,COUNT(DISTINCT(memid)) AS [Unique Members] 
FROM #AUTHRFI
GROUP BY servicecode

		SELECT TOP 1 ' ' AS 'SAMPLE THE DETAIL: ',* FROM #AUTHRFI
		-- SELECT TOP 10 ' ' AS '[TAT] HOURS: AUTH DETAIL MS EXCEL ODBC',* FROM #AUTHRFI AS auth WHERE Units = 'Hours'
		-- SELECT TOP 10 ' ' AS '[TAT] BUSINESS DAYS: AUTH DETAIL MS EXCEL ODBC',* FROM #AUTHRFI AS auth WHERE Units = 'Business Days'
		-- SELECT TOP 10 ' ' AS '[TAT] CALENDAR DAYS: AUTH DETAIL MS EXCEL ODBC',* FROM #AUTHRFI AS auth WHERE Units = 'Calendar Days'
		-- SELECT TOP 10 ' ' AS 'OPEN AUTH DETAIL MS EXCEL ODBC',* FROM #AUTHRFI AS auth WHERE [CLAIM ASSOCIATED WITH AUTH] IS NULL AND TRY_CONVERT(date,auth.termdate) >= TRY_CONVERT(date,GETDATE()) -- STILL OPEN REFERRAL -- OPEN AUTH NO CLAIMS ASSOCIATION ...
		-- SELECT TOP 10 ' ' AS 'CLOSED AUTH DETAIL MS EXCEL ODBC',* FROM #AUTHRFI AS auth WHERE [CLAIM ASSOCIATED WITH AUTH] IS NOT NULL -- CLOSED AUTH NO CLAIMS ASSOCIATION ...
		
		SELECT ' ' AS 'ANYTHING?: '
		,ccto.*,rcpt.*
		FROM ( -- INITIATE ...	
			SELECT r.authorizationid
			,a.referralid
			,r.referto
			,r.referfrom
			,LTRIM(RTRIM(a.codeid)) AS [CPT Procedure code]
			,[CPT Procedure code Description] = UPPER(LTRIM(RTRIM(ISNULL(CAST(ISNULL(procd.description,'') AS varchar(255)),''))))
			,CAST(CONVERT(datetime,(r.UtcReceiptDate at time zone 'UTC') at time zone 'Pacific Standard Time') AS date) AS 'ReceiptDate'
			,r.seendate
			,r.referraldate
			,r.effdate
			-- SELECT TOP 10 ' ' AS 'CHECK 1st',procd.*
			-- SELECT DISTINCT ' ' AS 'CHECK 1st'
			FROM HMOPROD_PLANDATA.dbo.referral (NOLOCK) AS r
				INNER JOIN HMOPROD_PLANDATA.dbo.authservice (NOLOCK) AS a ON r.referralid = a.referralid
				INNER JOIN HMOPROD_PLANDATA.dbo.svccode AS  procd (NOLOCK)  ON SUBSTRING(LTRIM(RTRIM(ISNULL(a.codeid,''))),1,5) = SUBSTRING(LTRIM(RTRIM(ISNULL(procd.codeid,''))),1,5)
			WHERE 1=1 
				AND UPPER(LTRIM(RTRIM(ISNULL(a.codeid,'')))) IN ('97039','97139')
				) -- CONCLUDE ...
				AS rcpt 
					INNER JOIN -- ISO ON [referto] PROVIDER
					( -- INITIATE ...
					SELECT DISTINCT provid FROM #PROVISOLATION
					) -- CONCLUDE ...
					AS ccto ON rcpt.referto = ccto.provid







-- ==================================================
	-- STANDARD AUDIT OUTPUT:
-- ==================================================
SELECT pa.[Enrollee First Name]
,pa.[Enrollee Last Name]
,pa.CIN AS [Member Client Index Number]
,mbi.[MEDICARE_NO] AS [Enrollee ID] -- [MBI]
,pa.[contract number] AS [Contract ID] -- D-SNP Contract # H4733 / C-SNP Contract # H6248
,TRY_CONVERT(varchar(3),'001') AS [Plan Benefit Package (PBP)]
,TRY_CONVERT(varchar(70),NULL) AS [First Tier Downstream and Related Entity]
,CONVERT(nvarchar(25),CAST(pa.[Member DOB] AS datetime),111) AS [Date of Birth] -- yyyy/mm/dd
,pa.[Medi-Cal Aid Code] -- QUPD
-- ,pa.[County] AS [LIST COUNTY]
,TRY_CONVERT(varchar(255),'NA') AS [County]
,pa.authorizationid AS [Prior Authorization Number]
,pa.referralid
,pa.LINE_OF_BUSINESS AS [Product Line]
-- ,pa.[Product Line]
,CASE
WHEN pa.[acuity_priority] LIKE '%Expedite%' THEN 'Urgent'
WHEN pa.[acuity_priority] LIKE '%Standard%' THEN 'Routine'
ELSE 'Routine' -- ELSE TRY_CONVERT(nvarchar(25),NULL) -- C011: NULL acuity defaults to 'Routine' ~ LEVERAGE: "DHCS MEDI-CAL 1.2 UNIVERSE NARRATIVE 2026 2.25.26.docx"
END AS [_RoutineOrUrgent]
,CASE
WHEN pa.[acuity_priority] LIKE '%Expedite%' THEN 'E' -- EXPEDITED
WHEN pa.[acuity_priority] LIKE '%Standard%' THEN 'S' -- STANDARD
ELSE 'S' -- ELSE TRY_CONVERT(nvarchar(25),NULL) -- C011: NULL acuity defaults to 'Routine' ~ LEVERAGE: "DHCS MEDI-CAL 1.2 UNIVERSE NARRATIVE 2026 2.25.26.docx"
END AS [Standard or Expedited]
,CONVERT(nvarchar(25),CAST(pa.seendate AS datetime),111) AS [Date of PA] -- yyyy/mm/dd CHANGE TO [seendate] PER MS ERICA EMAIL ON 20240314
-- ,CONVERT(nvarchar(25),CAST(pa.UtcReceiptDate AS datetime),111) AS [Request Receipt Date] -- yyyy/mm/dd
-- ,CONVERT(nvarchar(25),CAST(pa.[Date of PA] AS datetime),111) AS [Request Receipt Date] -- yyyy/mm/dd
,ISNULL(ISNULL([CPT Procedure Code],[Rev code]),pa.[Diagnosis code]) AS [Service Code] -- NESTED ISNULL() ... C008: PER eMAIL FROM MS ERICA ON 20240324 INCLUDE REVCODE FOR ISNULL(CPT) ...
,ISNULL(ISNULL(pa.[CPT Procedure Code Description],pa.[Rev code Description]),pa.[Diagnosis codes Descr]) AS [Service Code Description] -- NESTED ISNULL() ... C008: PER eMAIL FROM MS ERICA ON 20240324 INCLUDE REVCODE FOR ISNULL(CPT) ...
,ISNULL(piso.SPECdescr,'') AS [Specialty]
,pa.[Diagnosis code]+' | '+pa.[Diagnosis codes Descr] AS [Diagnosis]
,CONVERT(nvarchar(25),CAST(pa.UtcReceiptDate AS datetime),111) AS [Received Date] -- yyyy/mm/dd
,[RECEIPT TIME] AS [Received Time] -- IN 'hh:mm:ss:mmm (24-hour FORMAT) MILITARY TIME():
,CONVERT(nvarchar(25),CAST(pa.[Decision Date] AS datetime),111) AS [Decision Date] -- yyyy/mm/dd
,[SEENTIME] AS [Decision Time] -- IN 'hh:mm:ss:mmm (24-hour FORMAT) MILITARY TIME():
,pa.[AOR DATE]
,pa.[AOR TIME]
,pa.[Part B Drug Request]
,pa.[Part B Drug CPT / HCPCS CODE]
,pa.TAT
,pa.status AS [Request Disposition]
,pa.[Decision Maker]
-- ,pa.meddirectorid AS [Decision Maker]
,pa.reasoncode+' | '+pa.ReasonDescr AS [Reason to Deny or Modify]
,ISNULL(pa.[Member primary/preferred language],'Unknown') AS [Member primary/preferred language]
-- ,qnxtlang.[Member Preferred Language] AS [Member primary/preferred language]
-- ,bm.[834Language] AS [Member primary/preferred language]
,pa.[IPA/PPG/Clinics Delegate Entity]
,pa.[NONSPD/SPD flag]
,pa.[AUTH TYPE (TEMPLATE)] AS [Name of Template]
,pa.[AUTH TYPE (TEMPLATE) DESCR]
,pa.[AuthRefType (Grouping)]
,pa.[AuthRefType (Template)]
,pa.[File Type]
,pa.[QNXT Reason Code (A= COC Reporting: Continuity of Care)]
,pa.[QNXT Reason Code (A= COC Reporting: Continuity of Care) Descr.]
,pa.[QNXT Reason Code OON (A= OUT OF NETWORK)]
,pa.[QNXT Reason Code OON (A= OUT OF NETWORK) Descr.]
,CONVERT(nvarchar(10),TRY_CONVERT(datetime,aex.[ATTRIB_DATE]),111) AS [Date Extension notification]
,CONVERT(nvarchar(8),TRY_CONVERT(datetime,aex.[ATTRIB_TIME]),114) AS [Time Extension notification]
,CONVERT(nvarchar(10),TRY_CONVERT(datetime,awn.[ATTRIB_DATE]),111) AS [Date Written notification]
,CONVERT(nvarchar(8),TRY_CONVERT(datetime,awn.[ATTRIB_TIME]),114) AS [Time Written notification]
,CONVERT(nvarchar(10),TRY_CONVERT(datetime,ath.[ATTRIB_DATE]),111) AS [Date Threshold notification]
,CONVERT(nvarchar(8),TRY_CONVERT(datetime,ath.[ATTRIB_TIME]),114) AS [Time Threshold notification]
,CONVERT(nvarchar(10),TRY_CONVERT(datetime,aon.[ATTRIB_DATE]),111) AS [Date Oral notification]
,CONVERT(nvarchar(8),TRY_CONVERT(datetime,aon.[ATTRIB_TIME]),114) AS [Time Oral notification]
,pa.[Extended]
,pa.programid
,pa.servicecode
,CASE
WHEN TAT <= Threshold 
THEN 'Y'
ELSE 'N'
END AS [_Timely]
,pa.memid
,pa.CIN
,pa.HealthPlanID
,dpa.IndicatorNote
,CASE
WHEN ISNULL(ReferFromcontractedVerification,'Y') = 'N' -- C009: DEFAULT TO 'Y' OVERRIDE PER SIR YOUSAF INSTRUCTION DURING UM WEEKLY ON 20260325
THEN 'NCP'
ELSE 'CP'
END AS [Who Made the Request?]
INTO INFORMATICS.dbo.NCQA_UM_DENIALS_OUTPUT
-- SELECT TOP 10 ' ' AS [CHECK 1st], *
-- SELECT DISTINCT ' ' AS [CHECK 1st]
FROM INFORMATICS.dbo.NCQA_UM_DENIALS AS pa
		-- LEFT JOIN #baselinemembership AS bm ON pa.[Member Client Index Number] = bm.ClientIndexNumber
		LEFT JOIN #authattributes AS ath ON pa.referralid = ath.referralid
			AND ath.[ATTR_TYPE] = 'THRESHOLD' 
		LEFT JOIN #authattributes AS awn ON pa.referralid = awn.referralid
			AND awn.[ATTR_TYPE] = 'NOTIFICATION'
		LEFT JOIN #authattributes AS aex ON pa.referralid = aex.referralid
			AND aex.[ATTR_TYPE] = 'EXTENSION'
		LEFT JOIN #authattributes AS aon ON pa.referralid = aon.referralid
			AND aon.[ATTR_TYPE] = 'ORAL'
		LEFT JOIN INFORMATICS.dbo.uvw_PROVISO AS piso ON pa.referto = piso.provid -- PISO
		/* LEFT JOIN
		( -- INITIATE ...
		SELECT pspe.provid
		,UPPER(LTRIM(RTRIM(ISNULL(spe.[description],'')))) AS [SPECdescr]
		FROM HMOPROD_PLANDATA.dbo.provspecialty (NOLOCK) AS pspe ON prov.provid = pspe.provid
		AND NOT UPPER(LTRIM(RTRIM(ISNULL(pspe.spectype,'PRIMARY')))) LIKE 'PRIMARY' -- NO NOT NEGATIVE <> != ... SECONDARYPISO
		LEFT JOIN HMOPROD_PLANDATA.dbo.specialty (NOLOCK) AS spe ON pspe.specialtycode = spe.specialtycode
		) -- CONCLUDE ...
		AS spiso ON pa.referto = spiso.provid -- SECONDARYPISO */
		LEFT JOIN INFORMATICS.dbo.VLOOKUPIndicator_DENTAL_PAD_ABA AS dpa ON ISNULL(pa.[CPT Procedure code],pa.[Rev code]) = dpa.ID
		LEFT JOIN
		( -- INITIATE ...
		SELECT MemId
		,UPPER(LTRIM(RTRIM(ISNULL(Hic,'')))) AS [MEDICARE_NO]
		,Hic
		,TRY_CONVERT(date,EffDate) AS [EffectiveDate]
		,TRY_CONVERT(date,ISNULL(TermDate,GETDATE())) AS [TermDate]
		,DENSE_RANK() OVER (PARTITION BY MemId ORDER BY TRY_CONVERT(date,ISNULL(TermDate,GETDATE())) DESC) AS [RANKis]
		,ROW_NUMBER() OVER (PARTITION BY MemId ORDER BY TRY_CONVERT(date,ISNULL(TermDate,GETDATE())) DESC) AS [ROWis]
		FROM HMOPROD_PlanData.dbo.MemberCmsHic (NOLOCK)
		GROUP BY MemId,UPPER(LTRIM(RTRIM(ISNULL(Hic,'')))),Hic,TRY_CONVERT(date,EffDate),TRY_CONVERT(date,ISNULL(TermDate,GETDATE()))
		) -- CONCLUDE ...
		AS mbi ON pa.memid = mbi.MemId -- 'MBI' Medicare Beneficiary Identifier (MBI) was the HIC# Health Insurance Claim Number (HICN HICNO) see "Medicare Beneficiary Identifier (MBI) Understanding-the-MBI-052918.pdf"
			AND mbi.[RANKis] = 1
			AND mbi.[ROWis] = 1
GROUP BY pa.[Enrollee First Name]
,pa.[Enrollee Last Name]
,pa.[contract number]
,pa.CIN
,mbi.[MEDICARE_NO]
,pa.[Member DOB]
,pa.[Medi-Cal Aid Code]
,pa.authorizationid
,pa.referralid
,pa.LINE_OF_BUSINESS
-- ,pa.[Product Line]
,pa.[acuity_priority]
,CONVERT(nvarchar(25),CAST(pa.seendate AS datetime),111)
,ISNULL(ISNULL([CPT Procedure Code],[Rev code]),pa.[Diagnosis code])
,ISNULL(ISNULL(pa.[CPT Procedure Code Description],pa.[Rev code Description]),pa.[Diagnosis codes Descr])
,ISNULL(piso.SPECdescr,'')
,pa.[Diagnosis code]+' | '+pa.[Diagnosis codes Descr]
,CONVERT(nvarchar(25),CAST(pa.UtcReceiptDate AS datetime),111)
,[RECEIPT TIME]
,CONVERT(nvarchar(25),CAST(pa.[Decision Date] AS datetime),111)
,[SEENTIME]
,pa.[AOR DATE]
,pa.[AOR TIME]
,pa.[Part B Drug Request]
,pa.[Part B Drug CPT / HCPCS CODE]
,pa.TAT
,pa.Threshold
,pa.[status]
,pa.[Decision Maker]
-- ,pa.meddirectorid AS [Decision Maker]
,pa.reasoncode+' | '+pa.ReasonDescr
,ISNULL(pa.[Member primary/preferred language],'Unknown')
-- ,qnxtlang.[Member Preferred Language]
-- ,bm.[834Language]
,pa.[IPA/PPG/Clinics Delegate Entity]
,pa.[NONSPD/SPD flag]
,pa.[AUTH TYPE (TEMPLATE)]
,pa.[AUTH TYPE (TEMPLATE) DESCR]
,pa.[AuthRefType (Grouping)]
,pa.[AuthRefType (Template)]
,pa.[File Type]
,pa.[QNXT Reason Code (A= COC Reporting: Continuity of Care)]
,pa.[QNXT Reason Code (A= COC Reporting: Continuity of Care) Descr.]
,pa.[QNXT Reason Code OON (A= OUT OF NETWORK)]
,pa.[QNXT Reason Code OON (A= OUT OF NETWORK) Descr.]
,CONVERT(nvarchar(10),TRY_CONVERT(datetime,aex.[ATTRIB_DATE]),111)
,CONVERT(nvarchar(8),TRY_CONVERT(datetime,aex.[ATTRIB_TIME]),114)
,CONVERT(nvarchar(10),TRY_CONVERT(datetime,awn.[ATTRIB_DATE]),111)
,CONVERT(nvarchar(8),TRY_CONVERT(datetime,awn.[ATTRIB_TIME]),114)
,CONVERT(nvarchar(10),TRY_CONVERT(datetime,ath.[ATTRIB_DATE]),111)
,CONVERT(nvarchar(8),TRY_CONVERT(datetime,ath.[ATTRIB_TIME]),114)
,CONVERT(nvarchar(10),TRY_CONVERT(datetime,aon.[ATTRIB_DATE]),111)
,CONVERT(nvarchar(8),TRY_CONVERT(datetime,aon.[ATTRIB_TIME]),114)
,pa.[Extended]
,pa.programid
,pa.servicecode
,pa.memid
,pa.CIN
,pa.HealthPlanID
,dpa.IndicatorNote
,CASE
WHEN ISNULL(ReferFromcontractedVerification,'Y') = 'N'
THEN 'NCP'
ELSE 'CP'
END

-- =============================================================
	-- AIDCODE VIA [EnrollmentMangaer] 834 --
-- =============================================================
UPDATE INFORMATICS.dbo.NCQA_UM_DENIALS_OUTPUT
SET [Medi-Cal Aid Code] = aidc.CapitatedAidCode
FROM INFORMATICS.dbo.NCQA_UM_DENIALS_OUTPUT AS ar
	INNER JOIN
	( -- INITIATE ...
	SELECT 'SIR ADAM RETRO QA / CHECK / REVIEW' AS [NOTE(S)]
	,hc.BenefitBeginDate
	,hc.BenefitEndDate
	,hc.HcpCode
	,hc.ClientIndexNumber
	,hc.CapitatedAidCode -- DUAL(s) FROM RDT [TEMPLATE] - must meet both criteria: Medicare Indicator A IN 1, 2, 3, 4, or 5 AND Medicare Indicator B IN 1, 2, 4, or 5 NOTE(s): It is no longer required to have a Medicare Indicator D to be considered dual eligible. If a member has both A & B it is assumed they also have D. FROM SIR SOMBILLO see "MEDICARE CHG DHCS COB Mapping and Scenarios.docx" see Hx "STEP88_834_UPDATE_...sql"
	-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
	-- SELECT DISTINCT ' ' AS 'CHECK 1st',TRY_CONVERT(date,ar.[Decision Date]
	FROM EnrollmentManager.dbo.healthcoverage AS hc
		-- AND m.FileId = hc.FileId -- SANS THIS INNER JOIN TO VIEW ALL DETAIL v. DETAIL LIMITED TO MAX([FileId]) FOR GIVEN [CIN]
		INNER JOIN EnrollmentManager.dbo.healthcoverageoverlay AS hco ON hc.ClientIndexNumber = hco.ClientIndexNumber -- 'TABLE: [HealthCoverageOverlay] - DETAIL METADATA PROVIDING MAX([FileId]) FOR GIVEN [CIN] + [BenefitBeginDate]'
			AND hc.FileId = hco.FileId
			AND hc.BenefitBeginDate = hco.BenefitBeginDate
		INNER JOIN EnrollmentManager.dbo.HcpStatusCode AS hsc ON hc.HcpStatus = hsc.code
	WHERE 1=1
	-- AND hco.HcpCode IN ('029') -- ,'804','SNP') -- CHGSD (CURRENT MONTH HEALTH CARE PLANCODE) eg. '029' (CHGSD medicaid),'804' (CHGSD CalMediConnect) & '079' (Kaiser) -- LIKE '%'
	-- AND hc.HcpStatus IN ('01','51','S1') -- SELECT 'TABLE: [HcpStatusCode] - STATUS XWALK' AS [NOTE(s)],* FROM EnrollmentManager.dbo.HcpStatusCode
	) -- CONCLUDE ...
	AS aidc ON ar.CIN = SUBSTRING(UPPER(LTRIM(RTRIM(ISNULL(aidc.ClientIndexNumber,'')))),1,9)
		AND aidc.CapitatedAidCode IS NOT NULL
		-- AND aidc.ClientIndexNumber IN ('93406830H')
WHERE 1=1
	-- AND ar.CIN IN ('93406830H')
	AND TRY_CONVERT(date,ar.[Decision Date]) BETWEEN TRY_CONVERT(date,aidc.BenefitBeginDate) AND TRY_CONVERT(date,aidc.BenefitEndDate) -- RINA(): APPLIED TO FIELD WITHIN TABLE TO BE UPDATED

UPDATE INFORMATICS.dbo.NCQA_UM_DENIALS_OUTPUT
SET [Medi-Cal Aid Code] = aidc.CapitatedAidCode -- C009: PULL the Last Known [Medi-Cal Aid Code] for remaining ISNULL ...CAPTURE REMAINING BLANK(S)
FROM INFORMATICS.dbo.NCQA_UM_DENIALS_OUTPUT AS ar
INNER JOIN
( -- INITIATE ...
SELECT 'SIR ADAM RETRO QA / CHECK / REVIEW' AS [NOTE(S)]
,MAX(hc.BenefitBeginDate) AS [LastKnownBBD]
,hc.HcpCode
,hc.ClientIndexNumber
,hc.CapitatedAidCode -- DUAL(s) FROM RDT [TEMPLATE] - must meet both criteria: Medicare Indicator A IN 1, 2, 3, 4, or 5 AND Medicare Indicator B IN 1, 2, 4, or 5 NOTE(s): It is no longer required to have a Medicare Indicator D to be considered dual eligible. If a member has both A & B it is assumed they also have D. FROM SIR SOMBILLO see "MEDICARE CHG DHCS COB Mapping and Scenarios.docx" see Hx "STEP88_834_UPDATE_...sql"
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st',TRY_CONVERT(date,ar.[Decision Date]
FROM EnrollmentManager.dbo.healthcoverage AS hc
	-- AND m.FileId = hc.FileId -- SANS THIS INNER JOIN TO VIEW ALL DETAIL v. DETAIL LIMITED TO MAX([FileId]) FOR GIVEN [CIN]
	INNER JOIN EnrollmentManager.dbo.healthcoverageoverlay AS hco ON hc.ClientIndexNumber = hco.ClientIndexNumber -- 'TABLE: [HealthCoverageOverlay] - DETAIL METADATA PROVIDING MAX([FileId]) FOR GIVEN [CIN] + [BenefitBeginDate]'
		AND hc.FileId = hco.FileId
		AND hc.BenefitBeginDate = hco.BenefitBeginDate
	INNER JOIN EnrollmentManager.dbo.HcpStatusCode AS hsc ON hc.HcpStatus = hsc.code
	WHERE 1=1
		-- AND hco.HcpCode IN ('029') -- ,'804','SNP') -- CHGSD (CURRENT MONTH HEALTH CARE PLANCODE) eg. '029' (CHGSD medicaid),'804' (CHGSD CalMediConnect) & '079' (Kaiser) -- LIKE '%'
		-- AND hc.HcpStatus IN ('01','S1') -- SELECT 'TABLE: [HcpStatusCode] - STATUS XWALK' AS [NOTE(s)],* FROM EnrollmentManager.dbo.HcpStatusCode
GROUP BY hc.HcpCode,hc.ClientIndexNumber,hc.CapitatedAidCode
) -- CONCLUDE ...
AS aidc ON ar.CIN = SUBSTRING(UPPER(LTRIM(RTRIM(ISNULL(aidc.ClientIndexNumber,'')))),1,9)
	AND aidc.CapitatedAidCode IS NOT NULL
WHERE 1=1
	AND [Medi-Cal Aid Code] IS NULL -- CAPTURE REMAINING BLANK(S)







-- ===========================================================================
	-- ALLYSON + HINA 'LANGUAGE' FROM QNXT FOR RFP --
-- ===========================================================================
UPDATE INFORMATICS.dbo.NCQA_UM_DENIALS_OUTPUT -- C013: ROLLUP LANGUAGES: QNXT, Member Details, Language All No Language, No valid data, Other-non-english, undetermined, zz.unknown set all to unknown PER "DHCS MEDI-CAL 1.2 UNIVERSE NARRATIVE 2026 2.25.26.docx"
SET [Member primary/preferred language] = ISNULL(qnxtlang.[Member Preferred Language],'ENGLISH')
FROM INFORMATICS.dbo.NCQA_UM_DENIALS_OUTPUT AS ar
	INNER JOIN
	( -- INITIATE...
	SELECT ' ' AS [THRESHOLD LANGUAGE(S) see "CHG Fact Sheet 2023-03-06.docx"]
	,'QNXT / RFP [LANGUAGE]' AS [MESSAGE(S)]
	,m.memid
	,m.secondaryid
	,SUBSTRING(UPPER(LTRIM(RTRIM(ISNULL(m.secondaryid,'')))),1,9) AS [CIN]
	,CASE
	WHEN lang.description = 'NO VALID DATA REPORTED' THEN 'Unknown'
	WHEN lang.description = 'No Language' THEN 'Unknown'
	WHEN lang.description = 'Undetermined' THEN 'Unknown'
	WHEN ISNULL(lang.description,'') = '' THEN 'Unknown'
	WHEN lang.description = 'English, Old (ca. 450-1100)' THEN 'English'
	WHEN lang.description = 'English, Middle (1100-1500)' THEN 'English'
	WHEN lang.description = 'English - Large Print' THEN 'English'
	WHEN lang.description = 'Spanish - Large Print' THEN 'Spanish'
	WHEN lang.description = 'Arabic - Large Print' THEN 'Arabic'
	-- WHEN lang.description = 'Vietnamese - Large Print' THEN 'Vietnamese'
	WHEN lang.description LIKE '%Vietnamese%' THEN 'Vietnamese'
	WHEN lang.description = 'Tagalog - Large Print' THEN 'Tagalog'
	WHEN lang.description = 'Lao - Large Print' THEN 'Laotian'
	WHEN lang.description LIKE '%Non%English%' THEN 'Unknown'
	WHEN lang.description LIKE '%No%Valid%' THEN 'Unknown'
	WHEN lang.description LIKE '%Undetermined%' THEN 'Unknown'
	WHEN lang.description LIKE '%English%' THEN 'English'
	WHEN lang.description LIKE '%Unknown%' THEN 'Unknown'
	WHEN lang.description LIKE '%Other %' THEN 'Unknown'
	ELSE lang.description
	END AS [Member Preferred Language]
	-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
	-- SELECT DISTINCT ' ' AS 'CHECK 1st',UPPER(LTRIM(RTRIM(ISNULL(lang.description,'ENGLISH')))) FROM HMOPROD_PLANDATA.dbo.language AS lang
	FROM HMOPROD_PlanData.dbo.member AS m
		INNER JOIN HMOPROD_PLANDATA.dbo.language AS lang ON m.primarylanguage = lang.languageid
	GROUP BY m.memid,m.secondaryid,SUBSTRING(UPPER(LTRIM(RTRIM(ISNULL(m.secondaryid,'')))),1,9),lang.description
	) -- CONCLUDE ...
	AS qnxtlang ON ar.[Member Client Index Number] = qnxtlang.[CIN]







-- ===========================================================================
	-- MS EXCEL OLE DB ODBC:
-- ===========================================================================
/* SELECT ' ' AS 'DETAIL SAMPLE: '
,[CPT Procedure Code]
,[CPT Procedure Code Description]
,[Rev code]
,[Rev code Description]
,ISNULL([CPT Procedure Code],[Rev code]) AS [Service Code]
,CASE
WHEN LTRIM(RTRIM(ISNULL([CPT Procedure Code Description],''))) = ''
THEN ISNULL([Rev code Description],'')
ELSE ISNULL([CPT Procedure Code Description],'')
END AS [Service Code Description]
,*
FROM INFORMATICS.dbo.NCQA_UM_DENIALS
WHERE 1=1
-- AND ISNULL(authorizationid,'') IN ('4700475')
AND [AOR DATE] IS NOT NULL
AND [Part B Drug Request] = 'Y' */

-- SELECT DISTINCT [Product Line],[Request Disposition] FROM INFORMATICS.dbo.NCQA_UM_DENIALS_OUTPUT

-- ===========================================================================
	-- NCQA 2026 MEDI-CAL UM FILE SUBMISSION OUTPUT: 
-- ===========================================================================
			/* NARRATIVE: "2026 NCQA_UM File Submission_NARRATIVE_MEDI-CAL 6.3.26 FINAL.docx"
					~ COL A: Case ID/Auth ID  COL B: Org Type  COL C: File Type (McaidPX)
					~ COL D: File Date (Notification Letter Sent)  COL E: Delegate Name
					~ COL F: Denial Reason Code  COL G: Template  COL H: Date Received  COL I: TAT
					~ FILTER: MEDI-CAL LOB + DENIED status + Medical Necessity reason group */

;WITH refertoreferfrom AS
( -- INITIATE ...
SELECT referralid
,authorizationid
,referfrom
,[ReferFromProv]
,[ReferFromNPI]
,referto
,[ReferToProv]
,[ReferToNPI]
FROM INFORMATICS.dbo.NCQA_UM_DENIALS
GROUP BY referralid
,authorizationid
,referfrom
,[ReferFromProv]
,[ReferFromNPI]
,referto
,[ReferToProv]
,[ReferToNPI]
) -- CONCLUDE ...

		-- SELECT * FROM refertoreferfrom

SELECT ' ' AS [MS EXCEL OLE DB ODBC: NCQA 2026 MEDI-CAL UM SUBMISSION]
,finaltemplate.*
FROM
( -- INITIATE ...
SELECT ROW_NUMBER() OVER(PARTITION BY [HealthPlanID],[Prior Authorization Number] ORDER BY TRY_CONVERT(date,[Decision Date]) DESC) AS [ROWis] -- STRAIGHT FORWARD SEQUENCE ... include all of the request's line items in a single row and enter the multiple line items as a single organization determination request. ~ LEVERAGE: "ODAGprotocol.pdf"
-- =====================================================================
	-- NCQA MEDI-CAL COLUMN MAPPING (per narrative 6.3.26):
-- =====================================================================
,pa.[Prior Authorization Number] AS [A: Case ID Number] -- COL A: QNXT Auth ID
,CAST('Community Health Group' AS nvarchar(100)) AS [B: Organizational Type] -- COL B: HARDCODE per narrative
,CASE 
WHEN pa.[Product Line] = 'MEDI-CAL'
THEN 'Mcaid'+pa.[File Type] 
WHEN pa.[Product Line] = 'DSNP'
THEN 'Mcare'+pa.[File Type]  
ELSE pa.[File Type]
END AS [C: File Type] -- COL C: McaidPN / McaidPU / McaidCU / McaidPS per narrative
,CONVERT(nvarchar(10),TRY_CONVERT(datetime,pa.[Date Written notification]),101) AS [D: File Date (MM/DD/YYYY)] -- COL D: Auth Notification Letter Sent date per narrative
,CAST('' AS nvarchar(255)) AS [E: Delegate Name] -- COL E: BLANK per narrative
,pa.[Reason to Deny or Modify] AS [F: Denial Reason Code] -- COL F: QNXT Assigned service reason code Denial-Medical Necessity
,pa.[Name of Template] AS [G: Template] -- COL G: QNXT template used to create auth record
,CONVERT(nvarchar(10),TRY_CONVERT(datetime,pa.[Received Date]),101) AS [H: Date Request Received (MM/DD/YYYY)] -- COL H: QNXT receipt date (date only)
,(DATEDIFF(day,pa.[Received Date],pa.[Date Written notification])-1) AS [I: TAT] -- COL I: Column H to Column D per narrative (ClockStop overridden to notification date via C010)
-- =====================================================================
	-- SUPPORTING AUDIT FIELDS:
-- =====================================================================
,pa.[Enrollee First Name]
,pa.[Enrollee Last Name]
,pa.[Member Client Index Number]
,pa.[HealthPlanID]
,pa.[Prior Authorization Number]
,pa.referralid
,pa.[Product Line]
,pa.[_RoutineOrUrgent]
,pa.[Standard or Expedited]
,pa.[Extended]
,pa.[Date of PA]
,pa.[Decision Date] AS [Date of Determination]
,pa.[Decision Time] AS [Time of Determination]
,pa.[Received Date]
,pa.[Received Time]
,pa.[Date Written notification]
,pa.[Time Written notification]
,pa.[Date Extension notification]
,pa.[Time Extension notification]
,pa.[Date Oral notification]
,pa.[Time Oral notification]
,pa.[Request Disposition]
,pa.[Decision Maker]
,pa.[Reason to Deny or Modify]
,pa.[Member primary/preferred language]
,pa.[IPA/PPG/Clinics Delegate Entity]
,pa.[NONSPD/SPD flag]
,pa.[Medi-Cal Aid Code]
,pa.[AUTH TYPE (TEMPLATE) DESCR]
,pa.[AuthRefType (Template)]
,pa.[QNXT Reason Code (A= COC Reporting: Continuity of Care)]
,pa.[QNXT Reason Code (A= COC Reporting: Continuity of Care) Descr.]
,pa.[QNXT Reason Code OON (A= OUT OF NETWORK)]
,pa.[QNXT Reason Code OON (A= OUT OF NETWORK) Descr.]
,pa.[Who Made the Request?]
,rtrf.referfrom
,rtrf.[ReferFromProv]
,rtrf.[ReferFromNPI]
,pa.[Service Code]
,pa.[Service Code Description]
,pa.[Specialty]
,pa.[Diagnosis]
,pa.[Part B Drug Request]
,pa.[Part B Drug CPT / HCPCS CODE]
,pa.[AOR DATE]
,pa.[AOR TIME]
,pa.programid
,pa.servicecode
,pa.IndicatorNote
,CASE
WHEN ISNULL(pa.[Request Disposition],'') = 'DENIED' THEN 'Y'
ELSE 'N'
END AS [Was the request denied for lack of medical necessity?]
FROM INFORMATICS.dbo.NCQA_UM_DENIALS_OUTPUT AS pa
		LEFT JOIN refertoreferfrom AS rtrf ON ISNULL(pa.referralid,'') = ISNULL(rtrf.referralid,'')
			AND ISNULL(pa.[Prior Authorization Number],'') = ISNULL(rtrf.authorizationid,'')
WHERE 1=1
	AND ISNULL(pa.[Product Line],'') LIKE '%MEDI-CAL%' -- NCQA MEDI-CAL NARRATIVE: LOB FILTER
	AND ISNULL(pa.[Request Disposition],'') = 'DENIED' -- NCQA MEDI-CAL NARRATIVE: All Medical Necessity Denials per "reason group Denial-Medical Necessity in QNXT"
	AND pa.[Reason to Deny or Modify] LIKE '%MED%NECESSITY%'
	-- AND [AOR DATE] IS NOT NULL
	-- AND [Part B Drug Request] = 'Y'
	-- AND [Who Made the Request?] = 'NCP'
	) -- CONCLUDE ...
	AS finaltemplate
WHERE 1=1
	AND finaltemplate.ROWis = 1







-- ==================================================================
	-- NOTE(S) | COMMENT(S): 
-- ==================================================================
SELECT ' ' AS 'JL Hx'

-- ==========================================================
	-- RANK() JL ROW_NUMBER() v. RANK()...--
-- ==========================================================
-- declare @ClockStart date = '10/24/2016'
-- declare @ClockStop date = '10/28/2016'

-- ;WITH() ClosingActions as
-- (
       -- select
              -- r.referralid,
              -- pa.createid AS Closer,
              -- pa.createdate AS CloseDate,
              -- row_number() over( partition by r.referralid ORDER BY pa.createdate ) AS ActionOrderNumber
       -- from HMOPROD_PLANDATA.dbo.referral r
              -- join HMOPROD_PLANDATA.dbo.planaction pa ON r.referralid = pa.primaryid
      -- WHERE pa.actionid = 105
              -- and 
			  -- (
                     -- pa.comment like '%Status APPROVED - %'
                     -- or pa.comment like '%Status CLOSED - %'
                     -- or pa.comment like '%Status DENIED - %'
              -- )
              -- and pa.createdate >= @ClockStart
              -- and pa.createdate < @ClockStop
-- )
-- select *
-- from ClosingActions
-- where ActionOrderNumber = 1

----------------DECLARE @ClockStart AS datetime
----------------DECLARE @ClockStop AS datetime
DECLARE @Authkeep AS int
----------------SET @ClockStart = '10/24/2016'
----------------SET @ClockStop = '10/28/2016'
SET @Authkeep = 1

-----------------------------------------------------------------------------------------------------------------------------
	-- Error Trapping: Check If Permanent Table(s) Already Exist(s) And Drop If Applicable --
-----------------------------------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS #AUTHREF_DECISION -- SQL Server 2016 and later -- DYNAMIC tmp OR STATIC [TABLE] #TableName is a local temporary table visible only IN the current session; #TableName is a GLOBAL temporary table visible to all sessions IN ('TempDB')

select 'OP AUTHREF' AS [TYPE],
	  r.referralid,
	  pa.createid AS Closer,
	  CAST(pa.createdate AS datetime) AS CloseDate,
	  row_number() over( partition by r.referralid ORDER BY pa.createdate ) AS ActionOrderNumber
INTO #AUTHREF_DECISION
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
from HMOPROD_PLANDATA.dbo.referral r
	INNER JOIN HMOPROD_PLANDATA.dbo.planaction pa ON r.referralid = pa.primaryid
where pa.actionid = 105 --'OP AUTHREF' AS [TYPE],
	  and 
	  (
			 pa.comment like '%Status APPROVED - %'
			 or pa.comment like '%Status CLOSED - %'
			 or pa.comment like '%Status DENIED - %'
	  )
	  -- and pa.createdate >= @ClockStart
	  -- and pa.createdate < @ClockStop
UNION ALL --CONSIDER CHANGING UNION to UNION ALL WHEN handling OF duplicates IS HANDLED WITHIN the final aggregation. This eliminates unnecessary duplicate removal operations at each union step, significantly improving performance.
select 'IP AUTHREF' AS [TYPE],
	  r.referralid,
	  pa.createid AS Closer,
	  CAST(pa.createdate AS datetime) AS CloseDate,
	  row_number() over( partition by r.referralid ORDER BY pa.createdate ) AS ActionOrderNumber
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
from HMOPROD_PLANDATA.dbo.referral r
	INNER JOIN HMOPROD_PLANDATA.dbo.planaction pa ON r.referralid = pa.primaryid
where pa.actionid = 209 --'IP AUTHREF' AS [TYPE],
	  AND (
			 pa.comment like '%Status APPROVED - %'
			 or pa.comment like '%Status CLOSED - %'
			 or pa.comment like '%Status DENIED - %'
	  )
	  -- and p

		DELETE	  
		FROM #AUTHREF_DECISION
		WHERE 1=1 
			AND ActionOrderNumber != @Authkeep -- Row_number() over( partition by r.referralid ORDER BY pa.createdate )







-----------------------------------------------------------------------------------------------------------------------------
	-- Error Trapping: Check If Permanent Table(s) Already Exist(s) And Drop If Applicable --
-----------------------------------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS #svccat -- SQL Server 2016 and later -- DYNAMIC tmp OR STATIC [TABLE] #TableName is a local temporary table visible only IN the current session; #TableName is a GLOBAL temporary table visible to all sessions IN ('TempDB')

SELECT DISTINCT sc.catid,ssc.subcatid,scg.svcgroupid
,UPPER(LTRIM(RTRIM(sc.description)))+' '+UPPER(LTRIM(RTRIM(ssc.description)))+' '+UPPER(LTRIM(RTRIM(scg.description))) AS ServiceDescr
INTO #svccat
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM HMOPROD_PLANDATA.dbo.svccatgroup AS scg
	INNER JOIN HMOPROD_PLANDATA.dbo.svccategory AS sc ON scg.catid = sc.catid
	INNER JOIN HMOPROD_PLANDATA.dbo.svcsubcategory AS ssc ON scg.catid = ssc.catid
		AND scg.subcatid = ssc.subcatid

		-- SELECT * FROM #svccat







--------------------------------------------------------------------------------------------------------------------
	-- Error Trapping: Check If Permanent Table(s) Already Exist(s) And Drop If Applicable --
--------------------------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS #PARTIALFAVORABLE -- SQL Server 2016 and later -- DYNAMIC tmp OR STATIC [TABLE] #TableName is a local temporary table visible only IN the current session; #TableName is a GLOBAL temporary table visible to all sessions IN ('TempDB')

SELECT attrib.referralid,attrib.thevalue,attrib.effdate
--,CONVERT(Varchar(10),r.seendate,101) AS ProcedureDate,--FORMERLY FOR IP & OP AUTH(s) / REF(s) - DailyRefCount_ProcedureDate
--,CONVERT(Varchar(10),a.DeterminationDate,101) AS ProcedureDate,--FORMERLY FOR BHT AUTH(s) / REF(s) - DailyRefCount_ProcedureDate
,CAST(attrib.effdate AS datetime) AS [ATTRIB_PROCEDUREDATE]
,CASE
WHEN LEN(LTRIM(RTRIM(CAST(DATEPART(hh,CAST(attrib.effdate AS datetime)) AS nvarchar(2)))))=1
THEN '0'+CAST(DATEPART(hh,CAST(attrib.effdate AS datetime)) AS nvarchar(2))
ELSE CAST(DATEPART(hh,CAST(attrib.effdate AS datetime)) AS nvarchar(2)) 
END
+':'+CASE
WHEN LEN(LTRIM(RTRIM(CAST(DATEPART(mi,CAST(attrib.effdate AS datetime)) AS nvarchar(2)))))=1
THEN '0'+CAST(DATEPART(mi,CAST(attrib.effdate AS datetime)) AS nvarchar(2))
ELSE CAST(DATEPART(mi,CAST(attrib.effdate AS datetime)) AS nvarchar(2)) 
END
+':'+CASE
WHEN LEN(LTRIM(RTRIM(CAST(DATEPART(ss,CAST(attrib.effdate AS datetime)) AS nvarchar(2)))))=1
THEN '0'+CAST(DATEPART(ss,CAST(attrib.effdate AS datetime)) AS nvarchar(2))
ELSE CAST(DATEPART(ss,CAST(attrib.effdate AS datetime)) AS nvarchar(2)) 
END AS [ATTRIB_TIME]
,q.[description] AS [ATTRIBUTE DESCRIPTION]
INTO #PARTIALFAVORABLE
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM HMOPROD_PLANDATA.dbo.qattribute AS q
	INNER JOIN HMOPROD_PLANDATA.dbo.referralattribute AS attrib ON q.attributeid = attrib.attributeid
WHERE UPPER(LTRIM(RTRIM(ISNULL(q.attributeid,'')))) IN ('C00863756')
	OR UPPER(LTRIM(RTRIM(ISNULL(q.description,'')))) LIKE '%AUTH%MODIF%'
	 
		-- SELECT TOP 10 * FROM #PARTIALFAVORABLE
		






-- ===============================================================
-- AUTH / REFERRAL : STATUS --
-- ===============================================================
UPDATE #AUTH_TEMPLATE
SET [DetailStatus] = 'ATTRIBUTE PARTIAL FAVORABLE' --ADD ON per DISCUSSION / MEETING ;WITH() SIR JL & SIR YOUSAF ON 20180221
FROM #AUTH_TEMPLATE AS auth
	INNER JOIN #PARTIALFAVORABLE AS ra ON auth.referralid = ra.referralid

UPDATE #AUTH_TEMPLATE
SET [DetailStatus] = 'ADD ON DISMISSAL(s)' --ADD ON per DISCUSSION / MEETING ;WITH() SIR JL & SIR YOUSAF ON 20180221
FROM #AUTH_TEMPLATE AS auth
WHERE HeaderStatus LIKE '%CLOSE%'  --,r.status AS HeaderStatus
	AND ( -- INITIATE ...
	UPPER(LTRIM(RTRIM(ISNULL(DetailStatusReason,'')))) LIKE '%CMC%DISM%' --DISMISSAL(s) ,ar.description AS DetailStatusReason
		-- OR UPPER(LTRIM(RTRIM(ISNULL(DetailStatusReason,'')))) LIKE '%%%' --DISMISSAL(s) ,ar.description AS DetailStatusReason
) -- CONCLUDE ...

UPDATE #AUTH_TEMPLATE
SET [DetailStatus] = 'ADD ON WITHDRAWN(s)' --ADD ON per DISCUSSION / MEETING ;WITH() SIR JL & SIR YOUSAF ON 20180221
FROM #AUTH_TEMPLATE AS auth
WHERE HeaderStatus LIKE '%CLOSE%' 
	AND ( -- INITIATE ...
	UPPER(LTRIM(RTRIM(ISNULL(DetailStatusReason,'')))) LIKE '%RETRACT%' --WITHDRAWN() ,ar.description AS DetailStatusReason
		OR UPPER(LTRIM(RTRIM(ISNULL(DetailStatusReason,'')))) LIKE '%CMC%WITHD%'--WITHDRAWN() ,ar.description AS DetailStatusReason
		OR UPPER(LTRIM(RTRIM(ISNULL(DetailStatusReason,'')))) LIKE '%NO%AUTH%REQ%'--WITHDRAWN() ,ar.description AS DetailStatusReason
		OR UPPER(LTRIM(RTRIM(ISNULL(DetailStatusReason,'')))) LIKE '%IPA%RESP%'--WITHDRAWN() ,ar.description AS DetailStatusReason
		OR UPPER(LTRIM(RTRIM(ISNULL(DetailStatusReason,'')))) LIKE '%ENTRY%ERR%'--WITHDRAWN() ,ar.description AS DetailStatusReason
		-- OR UPPER(LTRIM(RTRIM(ISNULL(DetailStatusReason,'')))) LIKE '%%%' --WITHDRAWN() ,ar.description AS DetailStatusReason
		OR UPPER(LTRIM(RTRIM(ISNULL(DetailStatusReason,'')))) LIKE '%DUPLI%REQ%' --WITHDRAWN() ,ar.description AS DetailStatusReason
) -- CONCLUDE ...

	
	
	
	
	
	
-- ===============================================================
	-- FIX MISSING receiptdate --
-- ===============================================================
UPDATE #AUTH_TEMPLATE
SET [DATE the request was received] = LEFT(CONVERT(nvarchar(10),CAST([AUTHREF_RECEIVED] AS date),112),4)+'/'+ SUBSTRING(CONVERT(nvarchar(10),CAST([AUTHREF_RECEIVED] AS date),112),5,2)+'/'+ SUBSTRING(CONVERT(nvarchar(10),CAST([AUTHREF_RECEIVED] AS date),112),7,2)
,[TIME the request was received] = CASE
WHEN LEN(LTRIM(RTRIM(CAST(DATEPART(hh,CAST(referraldate AS datetime)) AS nvarchar(2)))))=1
THEN '0'+CAST(DATEPART(hh,CAST(referraldate AS datetime)) AS nvarchar(2))
ELSE CAST(DATEPART(hh,CAST(referraldate AS datetime)) AS nvarchar(2)) 
END
+':'+CASE
WHEN LEN(LTRIM(RTRIM(CAST(DATEPART(mi,CAST(referraldate AS datetime)) AS nvarchar(2)))))=1
THEN '0'+CAST(DATEPART(mi,CAST(referraldate AS datetime)) AS nvarchar(2))
ELSE CAST(DATEPART(mi,CAST(referraldate AS datetime)) AS nvarchar(2)) 
END
+':'+CASE
WHEN LEN(LTRIM(RTRIM(CAST(DATEPART(ss,CAST(referraldate AS datetime)) AS nvarchar(2)))))=1
THEN '0'+CAST(DATEPART(ss,CAST(referraldate AS datetime)) AS nvarchar(2))
ELSE CAST(DATEPART(ss,CAST(referraldate AS datetime)) AS nvarchar(2)) 
END
FROM #AUTH_TEMPLATE







-- ===============================================================
	-- QUPD(s) QTR(s) --
-- ===============================================================
UPDATE #AUTH_TEMPLATE
SET DetermQuarter = CASE
WHEN DATENAME(qq,CAST(CloseDate AS datetime)) = '4'
THEN 'Q4'
WHEN DATENAME(qq,CAST(CloseDate AS datetime)) = '3'
THEN 'Q3'
WHEN DATENAME(qq,CAST(CloseDate AS datetime)) = '2'
THEN 'Q2'
ELSE 'Q1'
END
,DetermMonth = DATEPART(mm,CAST(CloseDate AS datetime))
,DetermYear = DATEPART(yyyy,CAST(CloseDate AS datetime))
FROM #AUTH_TEMPLATE AS auth

UPDATE #AUTH_TEMPLATE
SET [NEXT_BUSINESS_DAY] = CAST(CASE
WHEN DATEPART (WEEKDAY,CAST(CloseDate AS datetime)) = 6 --FRIDAY
THEN CAST(CAST(CloseDate AS datetime)+3 AS datetime)
WHEN DATEPART (WEEKDAY,CAST(CloseDate AS datetime)) = 7 --SATURDAY
THEN CAST(CAST(CloseDate AS datetime)+2 AS datetime)
ELSE CAST(CAST(CloseDate AS datetime)+1 AS datetime)
END AS datetime)
FROM #AUTH_TEMPLATE AS auth

UPDATE #AUTH_TEMPLATE
SET [DATE of Sponsor Decision] = LEFT(CONVERT(nvarchar(10),CAST(auth.CloseDate AS date),112),4)+'/'+ SUBSTRING(CONVERT(nvarchar(10),CAST(auth.CloseDate AS date),112),5,2)+'/'+ SUBSTRING(CONVERT(nvarchar(10),CAST(auth.CloseDate AS date),112),7,2)
,[TIME of Sponsor Decision] = CASE
WHEN LEN(LTRIM(RTRIM(CAST(DATEPART(hh,CAST(auth.CloseDate AS datetime)) AS nvarchar(2)))))=1
THEN '0'+CAST(DATEPART(hh,CAST(auth.CloseDate AS datetime)) AS nvarchar(2))
ELSE CAST(DATEPART(hh,CAST(auth.CloseDate AS datetime)) AS nvarchar(2)) 
END
+':'+CASE
WHEN LEN(LTRIM(RTRIM(CAST(DATEPART(mi,CAST(auth.CloseDate AS datetime)) AS nvarchar(2)))))=1
THEN '0'+CAST(DATEPART(mi,CAST(auth.CloseDate AS datetime)) AS nvarchar(2))
ELSE CAST(DATEPART(mi,CAST(auth.CloseDate AS datetime)) AS nvarchar(2)) 
END
+':'+CASE
WHEN LEN(LTRIM(RTRIM(CAST(DATEPART(ss,CAST(auth.CloseDate AS datetime)) AS nvarchar(2)))))=1
THEN '0'+CAST(DATEPART(ss,CAST(auth.CloseDate AS datetime)) AS nvarchar(2))
ELSE CAST(DATEPART(ss,CAST(auth.CloseDate AS datetime)) AS nvarchar(2)) 
END
FROM #AUTH_TEMPLATE AS auth
