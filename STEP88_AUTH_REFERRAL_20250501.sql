-- ==========================================================
	-- REFERRALS / AUTH TEMPLATE--
-- ==========================================================
JAH CHARINDEX() FIND() SEARCH() 'quser',attribute,
		⏎ 'TEAMS' ON 20250206 
				FROM MS CLAUDIA: 
						Referral Status:
						Accepted
						Declined
						Pending
						Outreach initiated
						Referral Loop Closed
 
‘Referral Status’ may have multiple entries. For services the MCP must authorize, MCPs will begin updating ‘Referral Status’ after the authorization decision is made.  P.G. 11 of guidance  MCPs are required to track each ‘Referral Status’ separately by ‘Date of Referral Status Update’. MM/DD/YYYY format.
 
		SELECT ' ' AS 'IMPORT FROM "AddtnlDocs5.11_Request No. 11_AutoApproval_CPT list.xlsx"'
		,SUBSTRING(UPPER(LTRIM(RTRIM(ISNULL(CLEANID,'')))),1,5) AS [CPT Service Code],*
		,DENSE_RANK() OVER(PARTITION BY CLEANID ORDER BY [Auto-Auth category]) AS [RANKis]
		FROM INFORMATICS.dbo.AUTOAUTHLIST
		WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ... AND ... 1=1

		SELECT TOP 10 * FROM SQLPRODAPP02.EDW.dbo.uvwReferrals
		SELECT TOP 10 * FROM HMOPROD_PLANDATA.dbo.umdisposition -- see DISCHARGE OPTION(s)
		SELECT TOP 10 * FROM INFORMATICS.dbo.TABLEAU_AUTHSCANS
		SELECT ' ' AS 'OnlineBH',* FROM HMOPROD_QCSIDB.dbo.quser WHERE userid = 1178
		
		SELECT MAX(seendate) AS [MAXseen]
		,MAX(receiptdate) AS [MAXreceipt] 
		FROM SQLPRODAPP02.EDW.dbo.uvwReferrals AS vr 
		WHERE 1=1
			AND vr.seendate<= CAST(GETDATE() AS date)

		USE [PATH]: http://chgtableau/#/workbooks/314/views AS [Server] - 'TABLEAU AUTH SCANS DEVELOPMENT'
		USE [PATH]: https://chgtableau.chgsd.com/#/workbooks/314/views - 'TABLEAU APP' / 'TABLEAU AUTH SCANS DEVELOPMENT'
		USE [PATH]: https://authscans.chg.com/authfileimport.aspx - 'DEPRECATED REPORT'

		SELECT DISTINCT' ' AS 'FIND() THE meddir',a.meddirectorid,r.referralid,r.authorizationid,UPPER(LTRIM(RTRIM(ISNULL(en.lastname,''))))+' '+UPPER(LTRIM(RTRIM(ISNULL(en.firstname,'')))) AS  [Medical Director]-- see DetermName
		,r.seendate,r.receiptdate,en.*
		-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
		-- SELECT DISTINCT ' ' AS 'CHECK 1st'
		FROM HMOPROD_PLANDATA.dbo.referral AS r
			JOIN HMOPROD_PLANDATA.dbo.authservice AS a  ON r.referralid = a.referralid
			JOIN HMOPROD_PLANDATA.dbo.entity AS en ON a.meddirectorid = en.entid  --,UPPER(en.lastname) +','+UPPER(en.firstname) AS DetermName
		WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ... AND ...
			AND 
			( -- INITIATE ...
			a.referralid IN ('2972071')
				OR r.authorizationid IN ('2972071') -- MATCHES AUTH SCAN PRINT SCREEN FROM YOUNG LADY NATALIA CHARINDEX() FIND() SEARCH() 'SUBJECT:Auth Scans Replacement FROM: NATALIA WALTER JEREMY'
				) -- CONCLUDE ...

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
		,r.authorizationid,rt.*
		FROM HMOPROD_PLANDATA.dbo.referraltext AS rt
			JOIN HMOPROD_PLANDATA.dbo.referral AS r ON rt.referralid = r.referralid
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
		FROM HMOPROD_PLANDATA.dbo.referral AS r (NOLOCK)
			JOIN HMOPROD_PLANDATA.dbo.enrollkeys AS e (NOLOCK) ON r.enrollid = e.enrollid
			JOIN INFORMATICS.dbo.[uvw_LINE_OF_BUSINESS] AS bp (NOLOCK) ON e.programid = bp.programid  -- HMOPROD_PLANDATA.dbo.benefitplan + HMOPROD_PLANDATA.dbo.program
			JOIN HMOPROD_PLANDATA.dbo.member AS mem (NOLOCK) ON r.memid = mem.memid
		WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ... AND ...
			AND r.referralid IN ('4352086','2319087','2312483','1949590','2037776') -- SNOWFLAKE CLAIMS OF DOUBLE DIPPING 
				OR r.authorizationid IN ('4352086','2319087','2312483','1949590','2037776') -- SNOWFLAKE CLAIMS OF DOUBLE DIPPING
				OR r.authorizationid IN ('2426824','2426825','2426826','2426826','2426828') -- KNOWN QNXT [authorizationid] DATA INTEGRITY CONCERN
		ORDER BY authorizationid

		SELECT ' ' AS 'SHOULD BE NULL',referralid
		,COUNT(DISTINCT(memid)) AS [Member#]
		FROM HMOPROD_PLANDATA.dbo.referral AS r 
		GROUP BY referralid
		HAVING COUNT(DISTINCT(memid))  > 1

		SELECT ' ' AS 'SHOULD BE NULL',authorizationid
		,COUNT(DISTINCT(memid)) AS [Member#]
		FROM HMOPROD_PLANDATA.dbo.referral AS r 
		GROUP BY authorizationid
		HAVING COUNT(DISTINCT(memid))  > 1







-- =====================================================================
	-- AUTH Request for Information (RFI) --
-- =====================================================================
-- =====================================================================
	-- COMMENT(S) / CHANGE.LOG: --
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
 
-- =====================================================================
	-- DECLARE @PARAMETER(S) / @FILTER(S) --
-- =====================================================================
DECLARE @leadlag AS decimal(9,0)
DECLARE @leadlagmonths AS int
DECLARE @ClockStart AS datetime
DECLARE @ClockStop AS datetime
DECLARE @Authrundt AS datetime
-- DECLARE @SPLITlob AS nvarchar(255)
DECLARE @Authlob AS nvarchar(255)

SET @leadlag = -3 -- +- LEAD() LAG() IN ...
SET @leadlagmonths = 3 -- +- LEAD() LAG() IN MONTH(S)
SET @ClockStart  = CAST('01/01/'+CAST(DATEPART(yyyy,DATEADD(month,@leadlag,CAST(GETDATE() AS datetime))) AS varchar(4)) AS datetime)
SET @ClockStop = TRY_CONVERT(date,GETDATE())
SET @Authrundt = TRY_CONVERT(date,GETDATE())
-- SET @SPLITlob = 'MEDI-CAL,DSNP,CSNP,CMC' -- SQL: STRING_SPLIT() ... LINE_OF_BUSINESS OPTION(S)
SET @Authlob = '%'+NULL+'%'; -- LIKE '%[@PARAMETER]%' -- 'QMXHPQ084%' -- WHEN LTRIM(RTRIM(ek.programid)) = 'QMXHPQ0847' -- CMCmcare ek.planid IS QMXBP0822  & WHEN LTRIM(RTRIM(ek.programid)) = 'QMXHPQ0848' -- CMCmcal ek.planid IS QMXBP0823

		SELECT ' ' AS 'AUTH Request for Information (RFI)','BETWEEN '+CONVERT(nvarchar(10),@ClockStart,101)+' AND '+CONVERT(nvarchar(10),@ClockStop,101) AS [RANGE NOTE(S)]
		,@Authrundt AS [EXEC DATE]
		,@Authlob AS [LOB @parm FILTER]
		,bp.*
		-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
		-- SELECT DISTINCT ' ' AS 'CHECK 1st'
		FROM INFORMATICS.dbo.[uvw_LINE_OF_BUSINESS] AS bp (NOLOCK) -- HMOPROD_PLANDATA.dbo.benefitplan + HMOPROD_PLANDATA.dbo.program
		WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ... AND ...
			-- AND bp.LINE_OF_BUSINESS IN (SELECT value FROM STRING_SPLIT(@SPLITlob, ','))
			AND bp.[PLAN] LIKE ISNULL('%'+@Authlob+'%','%')
			-- AND bp.[PROGRAM] LIKE ISNULL('%'+@Authlob+'%','%')
			-- AND bp.[LINE_OF_BUSINESS] LIKE ISNULL('%'+@Authlob+'%','%')

		SELECT TOP 1 ' ' AS 'RECEIPT OF TIME ZONE ... Coordinated Universal Time or UTC' -- C000: Coordinated Universal Time or UTC is the primary time standard globally used to regulate clocks and time. It establishes a reference for the current time, forming the basis for civil time and time zones. UTC facilitates international communication, navigation, scientific research, and commerce.
		,TRY_CONVERT(datetime,GETDATE()) AS [NOW_ORIGIN_TIME_ZONE]
		,CAST(TRY_CONVERT(datetime,(GETDATE() at time zone 'UTC') at time zone 'Pacific Standard Time') AS datetime) AS [NOW_PACIFIC_TIME_ZONE]
		,TRY_CONVERT(datetime,r.UtcReceiptDate) AS [RECEIPTDATE_ORIGIN_TIME_ZONE]
		,CAST(CONVERT(datetime,(r.UtcReceiptDate at time zone 'UTC') at time zone 'Pacific Standard Time') AS datetime) AS [RECEIPTDATE_PACIFIC_TIME_ZONE]
		,CAST(TRY_CONVERT(datetime,(r.UtcReceiptDate at time zone 'UTC') at time zone 'Pacific Standard Time') AS datetime) AS [RECEIPTDATE_PACIFIC_TIME_ZONE]
		FROM HMOPROD_PLANDATA.dbo.referral AS r (NOLOCK)

		SELECT DISTINCT ' ' AS 'AUTH / REF [ACUITY_PRIORITY]'
		,r.acuity,r.priority
		,CASE 
		WHEN r.[priority] = 'H' 
		THEN CONVERT(nvarchar(25),'Expedited')
		ELSE CONVERT(nvarchar(25),'Standard')
		END AS [acuity_priority]
		FROM HMOPROD_PLANDATA.dbo.referral AS r (NOLOCK)
		WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ... AND ...

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
		FROM HMOPROD_PLANDATA.dbo.referral AS r (NOLOCK)
			JOIN HMOPROD_PLANDATA.dbo.authcode AS ac (NOLOCK) ON r.servicecode = ac.codeid
		WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ... AND ...
			-- AND ac.codeid LIKE '%AUTO%' -- Please include only auto-auths from this universe. (These are NOT considered authorizations). You may identify auto auth with the following template path. Auth Category: Outpatient, Subcategory: Outpatient, Template: Online Auth
			-- AND r.servicecode LIKE '%ICF%' -- ICF/DD (ntermediate Care Facility for Developmentally Disabled Transition (ICF/DD) and Subacute Monitoring Survey)'
			-- AND a.description LIKE '%palliative%'















--------------------------------------------------------------------------------------------------------------------
	-- Error Trapping: Check If Permanent Table(s) Already Exist(s) And Drop If Applicable --
--------------------------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS #AUTHRFI;
DROP TABLE IF EXISTS #authmodified;
DROP TABLE IF EXISTS #authextension;
DROP TABLE IF EXISTS #authnotification;
DROP TABLE IF EXISTS #auththreshold;

WITH SETAUTHREF AS 
( -- INITIATE ...
SELECT DISTINCT 'AUTH ISO' AS 'AUTH CATEGORY',r.referralid -- ,year_month
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM HMOPROD_PLANDATA.dbo.referral AS r (NOLOCK)
	JOIN HMOPROD_PLANDATA.dbo.enrollkeys AS e (NOLOCK) ON r.enrollid = e.enrollid
	JOIN INFORMATICS.dbo.[uvw_LINE_OF_BUSINESS] AS bp (NOLOCK) ON e.programid = bp.programid  -- HMOPROD_PLANDATA.dbo.benefitplan + HMOPROD_PLANDATA.dbo.program	
	
	/* JOIN 
	( -- INITIATE ...
	SELECT DISTINCT ' ' AS 'ISO FOR AUTH TEMPLATE',r.referralid
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
	FROM HMOPROD_PLANDATA.dbo.referral AS r (NOLOCK)
		JOIN HMOPROD_PLANDATA.dbo.authcode AS ac (NOLOCK) ON r.servicecode = ac.codeid
	WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ... AND ...
		AND r.servicecode LIKE '%ICF%' -- ICF/DD (ntermediate Care Facility for Developmentally Disabled Transition (ICF/DD) and Subacute Monitoring Survey)'
		) -- CONCLUDE ...
		AS atemplate (NOLOCK) ON r.referralid = atemplate.referralid */

	/* JOIN -- ISO (NOLOCK) ON [referto]
	( -- INITIATE ...
	SELECT DISTINCT p.NPI,p.provid,piso.SPECdescr AS [SPECIALTY],p.fullname
	FROM HMOPROD_PLANDATA.dbo.provider AS p (NOLOCK)
		JOIN INFORMATICS.dbo.[uvw_PROVISO] AS piso ON p.provid = piso.provid
	WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ... AND ...
		AND ISNULL(piso.NPI,'') != '' -- NO NOT NEGATIVE <> != 
	) -- CONCLUDE ...
	AS ccto (NOLOCK) ON r.referto = ccto.provid */
	
	/* JOIN -- ISO (NOLOCK) ON [referfrom]
	( -- INITIATE ...
	SELECT DISTINCT p.NPI,p.provid,piso.SPECdescr AS [SPECIALTY],p.fullname
	FROM HMOPROD_PLANDATA.dbo.provider AS p (NOLOCK)
		JOIN INFORMATICS.dbo.[uvw_PROVISO] AS piso  ON p.provid = piso.provid
	WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ... AND ...
		AND ISNULL(piso.NPI,'') != '' -- NO NOT NEGATIVE <> != 
	) -- CONCLUDE ...
	AS ccfrom (NOLOCK) ON r.referfrom = ccfrom.provid */
	
	/* JOIN -- ISO (NOLOCK) ON Dx ...
	( -- INITIATE ...	
	SELECT DISTINCT r.authorizationid,ad.referralid,UPPER(LTRIM(RTRIM(ISNULL(ad.diagcode,'')))) AS [Diagnosis code],LTRIM(RTRIM(ad.diagqualifier)) AS [Diagnosis Category]
	,[Diagnosis codes Descr] = UPPER(LTRIM(RTRIM(ISNULL(dc.description,'')))),sequence
	FROM HMOPROD_PLANDATA.dbo.referral AS r (NOLOCK)
		JOIN HMOPROD_PLANDATA.dbo.authdiag AS ad (NOLOCK) ON r.referralid = ad.referralid
			LEFT JOIN HMOPROD_PLANDATA.dbo.diagcode AS dc (NOLOCK) ON ad.diagcode = dc.codeid
	WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ... AND ...
		AND UPPER(LTRIM(RTRIM(ISNULL(ad.diagcode,'')))) IN ('')
		AND sequence = 1 -- PRIMARY DIAGNOSIS
		) -- CONCLUDE ...
		AS rdiag (NOLOCK) ON r.referralid = rdiag.referralid */		

	/* JOIN -- ISO (NOLOCK) ON CPT PROCEDURE CODE ...
	( -- INITIATE ...	
	SELECT r.authorizationid,a.referralid,LTRIM(RTRIM(a.codeid)) AS [CPT Procedure code]
	,[CPT Procedure code Description] = UPPER(LTRIM(RTRIM(ISNULL(CAST(procd.description AS varchar(255)),''))))
	,SUM(a.totalunits) AS [requested_units]
	FROM HMOPROD_PLANDATA.dbo.referral AS r (NOLOCK)
		JOIN HMOPROD_PLANDATA.dbo.authservice AS a (NOLOCK) ON r.referralid = a.referralid
		JOIN HMOPROD_PLANDATA.dbo.svccode AS  procd  (NOLOCK) ON a.codeid = procd.codeid
	WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ... AND ...
		AND UPPER(LTRIM(RTRIM(ISNULL(a.codeid,'')))) IN ('')
	GROUP BY r.authorizationid,a.referralid,LTRIM(RTRIM(a.codeid)),UPPER(LTRIM(RTRIM(ISNULL(CAST(procd.description AS varchar(255)),''))))
		) -- CONCLUDE ...
		AS rcpt (NOLOCK) ON r.referralid = rcpt.referralid */
		
	/* JOIN -- ISO (NOLOCK) ON REV ...
	( -- INITIATE ...	
	SELECT r.authorizationid,a.referralid,UPPER(LTRIM(RTRIM(ISNULL(a.codeid,'')))) AS [Rev code]
	,[Rev code Description] = UPPER(LTRIM(RTRIM(ISNULL(rev.description,''))))
	,SUM(a.totalunits) AS [requested_units]
	FROM HMOPROD_PLANDATA.dbo.referral AS r
		JOIN HMOPROD_PLANDATA.dbo.authservice AS a (NOLOCK) ON r.referralid = a.referralid
		JOIN HMOPROD_PLANDATA.dbo.revcode AS rev (NOLOCK) ON CASE
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
		WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ... AND ...
			AND UPPER(LTRIM(RTRIM(ISNULL(a.codeid,'')))) IN ('')
		GROUP BY r.authorizationid,a.referralid,UPPER(LTRIM(RTRIM(ISNULL(a.codeid,'')))),UPPER(LTRIM(RTRIM(ISNULL(rev.description,''))))
		) -- CONCLUDE ...
		AS rrev (NOLOCK) ON r.referralid = rrev.referralid */

WHERE 1=1
	-- AND bp.[PLAN], LIKE ISNULL(@AuthLob,'%%%') -- LINE_OF_BUSINESS

	-- AND r.referfrom IN ('313124') -- 'EYECARE OF SAN DIEGO/Provider ID: 313124

	-- AND r.referto IN ('313124') -- 'EYECARE OF SAN DIEGO/Provider ID: 313124

	-- AND r.servicecode LIKE '%AUTO%' -- Please include only auto-auths from this universe. (These are NOT considered authorizations). You may identify auto auth with the following template path. Auth Category: Outpatient, Subcategory: Outpatient, Template: Online Auth
	 
	-- AND r.authorizationid IN ('1581726','1841622','1865454')	

	AND TRY_CONVERT(date,ISNULL(r.termdate,GETDATE())) >= TRY_CONVERT(date,r.effdate) -- MUST BE TRUE ... NON-CROSSFOOTED RECORDS ARE ACTIVE ...

	AND CAST(CONVERT(datetime,(r.UtcReceiptDate at time zone 'UTC') at time zone 'Pacific Standard Time') AS date) BETWEEN @ClockStart AND @ClockStop -- Coordinated Universal Time or UTC is the primary time standard globally used to regulate clocks and time. It establishes a reference for the current time, forming the basis for civil time and time zones. UTC facilitates international communication, navigation, scientific research, and commerce. ... ADHOC REQUEST per eMAIL FROM MS NATALIA ON 20221115 '... We need to run a report through AuthScans for Auth Scan Report for EYECARE OF SAN DIEGO/Provider ID: 313124 ...'

	AND TRY_CONVERT(date,r.effdate) <= @ClockStop -- FROM ECM / CS Q C002: per TEAMS DISCUSSION WITH() MS CLAUDIA FOR TAB 5 WE SHOULD BE CAPTURING MEMBERS WITH() AN OPEN CS AUTH AT THE END OF THE QTR BEING REPORTED ... 	r.effdate AS 'Auth Start Date', -- FROM ALTER proc [dbo].[rptCommunitySupportsAuth] ... 	r.termdate AS 'Auth End Date', -- FROM ALTER proc [dbo].[rptCommunitySupportsAuth]
	AND TRY_CONVERT(date,r.termdate) >= @ClockStop -- FROM ECM / CS Q  C002: per TEAMS DISCUSSION WITH() MS CLAUDIA FOR TAB 5 WE SHOULD BE CAPTURING MEMBERS WITH() AN OPEN CS AUTH AT THE END OF THE QTR BEING REPORTED ... 	r.effdate AS 'Auth Start Date', -- FROM ALTER proc [dbo].[rptCommunitySupportsAuth] ... 	r.termdate AS 'Auth End Date', -- FROM ALTER proc [dbo].[rptCommunitySupportsAuth]

	AND TRY_CONVERT(date,r.effdate) <= @ClockStop -- WITHIN reporting period [RANGE] OPPOSITION 
	AND TRY_CONVERT(date,ISNULL(r.termdate,GETDATE())) >= @ClockStart -- WITHIN reporting period [RANGE] OPPOSITION
	
	-- AND TRY_CONVERT(date,r.effdate) BETWEEN @ClockStart AND @ClockStop
	-- AND TRY_CONVERT(date,r.seendate) BETWEEN @ClockStart AND @ClockStop -- AS [DECISION DATE]
	-- AND TRY_CONVERT(date,r.referraldate) BETWEEN @ClockStart AND @ClockStop
	-- AND TRY_CONVERT(date,a.DeterminationDate) BETWEEN @ClockStart AND @ClockStop
	-- AND TRY_CONVERT(date,r.receiptdate) BETWEEN @ClockStart AND @ClockStop
	-- AND TRY_CONVERT(date,r.createdate) BETWEEN @ClockStart AND @ClockStop
	-- AND TRY_CONVERT(date,a.createdate) BETWEEN @ClockStart AND @ClockStop
	-- AND TRY_CONVERT(date,a.lastUPDATE) BETWEEN @ClockStart AND @ClockStop
	-- AND TRY_CONVERT(date,r.termdate) >= TRY_CONVERT(date,GETDATE()) -- STILL OPEN REFERRAL
	) -- CONCLUDE ...

		-- SELECT * FROM SETAUTHREF; -- Or any other query that uses the CTE

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
,vrb.BUCKET
,ac.codeid
,r.servicecode
,r.authorizationid AS [Prior Authorization Number]
,r.referralid
,r.authorizationid
,r.UtcReceiptDate
,CONVERT(datetime,(r.UtcReceiptDate at time zone 'UTC') at time zone 'Pacific Standard Time') AS [RECEIPT_DATE]
,CONVERT(nvarchar(8),TRY_CONVERT(datetime,CONVERT(datetime,(r.UtcReceiptDate at time zone 'UTC') at time zone 'Pacific Standard Time')),114) AS [RECEIPT TIME]
,'Q'+DATENAME(qq,CAST(CAST(CONVERT(datetime, (r.UtcReceiptDate at time zone 'UTC' ) at time zone 'Pacific Standard Time') AS date) AS datetime))+' '+DATENAME(yyyy,CAST(CAST(CONVERT(datetime, (r.UtcReceiptDate at time zone 'UTC' ) at time zone 'Pacific Standard Time') AS date) AS datetime)) AS [DetermQuarter BY RECEIVED DATE]
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
,CAST(UPPER(LTRIM(RTRIM(ISNULL(r.status,''))))+' - '+UPPER(LTRIM(RTRIM(ISNULL(a.status,'')))) AS nvarchar(255)) AS [DetailStatus],ar.description as [DetailStatusReason]
,r.effdate
,r.termdate
,r.referraldate
,r.seendate
,r.receiptdate
,r.seendate AS [DecisionDate]
,r.admitdate,r.dischargedate
,r.referfrom,ccfrom.fullname AS ReferFromProv,ccfrom.NPI AS ReferFromNPI
,r.referto,ccto.fullname AS ReferToProv,ccto.NPI AS ReferToNPI
,r.memid
,mem.CIN
,mem.HealthPlanID
,TRY_CONVERT(date,mem.dob) AS 'Member DOB'
,mem.[Member Name]
,mem.[Member Last Name]
,mem.[Member First Name]
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
,ac.codeid AS [AUTH TYPE (TEMPLATE)],UPPER(LTRIM(RTRIM(ISNULL(ac.description,'')))) AS [AUTH TYPE (TEMPLATE) DESCR],ac.authcategory -- If template says Retro = Post-service, INPATIENT – SNF = concurrent, All others = pre-service 
,glembocki.claimid AS [CLAIM ASSOCIATED WITH AUTH]	
,r.acuity
,r.priority
,CASE 
WHEN r.[priority] = 'H' 
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
,rg.reasoncode,CAST(UPPER(LTRIM(RTRIM(ISNULL(ar.description,'')))) AS nvarchar(255)) AS [ReasonDescr]
,CAST(0 AS money) AS [TAT]
,CAST(NULL AS int) AS [Threshold]
,CAST(NULL AS nvarchar(25)) AS [Units]
,CAST('N' AS nvarchar(1)) AS [Extended]
,CAST(NULL AS datetime) AS [Attribute Date /Time]
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
END AS [Decision Maker]
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
,TRY_CONVERT(nvarchar(2025),rt.reason) AS [NON-CLINICAL NOTE(S)]  -- C007: ADD NON-CLINICAL NOTES PER REQUEST FROM MS BARBARA ON 20241112 ... FROM:BARB ATTACHMENT:*MC LTC AUTHNOTE SAMPLE Copy of LTC SNF Q2 2024 YF working copy 07-09-2024.xlsx*
,TRY_CONVERT(nvarchar(1),NULL) AS [contractedVerification]
,r.paytoaffiliationid
,r.DefaultContractId
,CASE
WHEN UPPER(LTRIM(RTRIM(ISNULL(UPPER(LTRIM(RTRIM(ISNULL(q.lastname,'')))),''))))+', '+UPPER(LTRIM(RTRIM(ISNULL(UPPER(LTRIM(RTRIM(ISNULL(q.firstname,'')))),'')))) LIKE '%BUCKET%'
THEN ISNULL(vrb.[BUCKET],'')
ELSE UPPER(LTRIM(RTRIM(ISNULL(q.loginid,''))))+' - '+UPPER(LTRIM(RTRIM(ISNULL(UPPER(LTRIM(RTRIM(ISNULL(q.lastname,'')))),''))))+', '+UPPER(LTRIM(RTRIM(ISNULL(UPPER(LTRIM(RTRIM(ISNULL(q.firstname,'')))),''))))
END AS [Assigned]
,TRY_CONVERT(nvarchar(2000),NULL) AS [DETAILelement]
INTO #AUTHRFI
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st',status
FROM SETAUTHREF AS srr
	JOIN HMOPROD_PLANDATA.dbo.referral AS r (NOLOCK) ON srr.referralid = r.referralid
	JOIN HMOPROD_PLANDATA.dbo.enrollkeys AS e (NOLOCK) ON r.enrollid = e.enrollid
	JOIN INFORMATICS.dbo.[uvw_LINE_OF_BUSINESS] AS bp (NOLOCK) ON e.programid = bp.programid  -- HMOPROD_PLANDATA.dbo.benefitplan + HMOPROD_PLANDATA.dbo.program
	
	JOIN HMOPROD_PLANDATA.dbo.provider AS ccto (NOLOCK) ON r.referto = ccto.provid
	-- JOIN HMOPROD_PLANDATA.dbo.affiliation AS affto ON ccto.provid = affto.provid

	JOIN HMOPROD_PLANDATA.dbo.provider AS ccfrom (NOLOCK) ON r.referfrom = ccfrom.provid
	-- JOIN HMOPROD_PLANDATA.dbo.affiliation AS afffrom ON ccfrom.provid = afffrom.provid

	JOIN INFORMATICS.dbo.uvw_BASELINE_MEMBERSHIP AS mem ON r.memid = mem.memid
		
		LEFT JOIN HMOPROD_QCSIDB.dbo.quser AS qat (NOLOCK) ON r.updateid = qat.loginid -- C005: ,UPPER(q.lastname) +' '+UPPER(q.firstname) AS [UserName] ... PER ECM WEEKLY MEETING ON 20240516 ... WAS LEFT JOIN HMOPROD_QCSIDB.dbo.quser AS qat ON r.updateid = qat.loginid ... LTRIM(RTRIM(q.firstname))+' '+LTRIM(RTRIM(q.lastname)) AS [Assigned To]: ... use to know who made the decision. r.authroizationid IN ('4182284','4063491','4062276') -- Auth# 4063491 Assigned to Jen Jackson: Auth# 4062276 Assigned to Jen Jackson: Auth# 4182284 Assigned to MS TANIA: 
		LEFT JOIN HMOPROD_PlanData.dbo.referraltext AS rt (NOLOCK) ON r.referralid = rt.referralid -- [Auto Auth Status] -- C005: PER ECM WEEKLY MEETING ON 20240516 ... Auto Approved: r.authroizationid IN ('3944504') do NOT have CLINICAL NOTes and only 1 online non CLINICAL NOT
		LEFT JOIN HMOPROD_PLANDATA.dbo.authdiag AS ad (NOLOCK) ON r.referralid = ad.referralid
		LEFT JOIN HMOPROD_PLANDATA.dbo.authcode AS ac (NOLOCK) ON r.servicecode = ac.codeid --AUTH TYPE (TEMPLATE) DEFINITION()
		LEFT JOIN HMOPROD_PLANDATA.dbo.authservice AS a (NOLOCK) ON r.referralid = a.referralid --PROC / REV CODE(s)
		LEFT JOIN HMOPROD_PLANDATA.dbo.authservicedetail AS asd (NOLOCK) ON r.referralid = asd.referralid
			AND asd.sequence = ad.sequence
		LEFT JOIN HMOPROD_PLANDATA.dbo.authservicereason AS asr (NOLOCK) ON a.referralid = asr.referralid
		LEFT JOIN HMOPROD_PLANDATA.dbo.reasongroupdtl AS rg (NOLOCK) ON asr.reasongroupdtlid =  rg.reasongroupdtlid
		LEFT JOIN HMOPROD_PLANDATA.dbo.authreason AS ar (NOLOCK) ON rg.reasoncode = ar.reasoncode
		LEFT JOIN HMOPROD_PLANDATA.dbo.entity AS en (NOLOCK) ON a.meddirectorid = en.entid --,UPPER(en.lastname) +','+UPPER(en.firstname) AS DetermName
		-- LEFT JOIN HMOPROD_QCSIDB.dbo.quser AS q (NOLOCK) ON r.issueinitials = q.UPDATEid
		LEFT JOIN HMOPROD_QCSIDB.dbo.quser AS q (NOLOCK) ON r.userid = q.userid --,UPPER(q.lastname) +' '+UPPER(q.firstname) AS UserName

		LEFT JOIN 
		( -- INITIATE ...
		SELECT DISTINCT q.loginid,q.userid,UPPER(LTRIM(RTRIM(ISNULL(UPPER(LTRIM(RTRIM(ISNULL(q.lastname,'')))),''))))+' '+UPPER(LTRIM(RTRIM(ISNULL(UPPER(LTRIM(RTRIM(ISNULL(q.firstname,'')))),'')))) AS [BUCKET]
		FROM HMOPROD_QCSIDB.dbo.quser AS q
		WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ... AND ...
			AND UPPER(LTRIM(RTRIM(ISNULL(q.lastname,'')))) LIKE '%BUCKET%'
		) -- CONCLUDE ...
		AS vrb ON r.userid = vrb.userid

		LEFT JOIN -- COC per eMAIL ON 20220516 SUBJECT:Field Name changes & RANGE rewrite - RE: DHCS Audit 2022 - Assignments BODY:We heard FROM the UM team IN regards to the COC AND OON indicators AND what code to include for that. FROM:HINA ... was = '308' 
		( -- INITIATE ... 
		SELECT DISTINCT asr.referralid,asr.[sequence],DENSE_RANK() OVER(PARTITION BY asr.referralid ORDER BY asr.[sequence]) AS [RANKis] -- RANK() ACCOUNT(s) FOR TIES + RETAINS SEQUENCE
		,ar.reasoncode AS [QNXT Reason Code (A= COC Reporting: Continuity of Care)] 
		,ar.[description] AS [QNXT Reason Code (A= COC Reporting: Continuity of Care) Descr.]
		FROM HMOPROD_PlanData.dbo.authservicereason AS asr (NOLOCK)
			JOIN HMOPROD_PlanData.dbo.reasongroupdtl AS rgd (NOLOCK) ON asr.reasongroupdtlid = rgd.reasongroupdtlid
			JOIN HMOPROD_PlanData.dbo.authreason ar (NOLOCK) ON rgd.reasoncode = ar.reasoncode
		WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ... AND ...
			AND ar.reasoncode IN ('308','343') 
		) -- CONCLUDE ...
		AS coc ON r.referralid = coc.referralid
			-- AND coc.[RANKis] = 1 -- OUTER APPLY (SELECT TOP 1 ... Alt.

		LEFT JOIN -- COC per eMAIL ON 20220516 SUBJECT:Field Name changes & RANGE rewrite - RE: DHCS Audit 2022 - Assignments BODY:We heard FROM the UM team IN regards to the COC AND OON indicators AND what code to include for that. FROM:HINA ... was = '308' 
		( -- INITIATE ... 
		SELECT DISTINCT asr.referralid,asr.[sequence]
		,DENSE_RANK() OVER(PARTITION BY asr.referralid ORDER BY asr.[sequence]) AS [RANKis] -- RANK() ACCOUNT(s) FOR TIES + RETAINS SEQUENCE
		,ROW_NUMBER() OVER(PARTITION BY asr.referralid ORDER BY asr.[sequence]) AS [ROWis] -- RANK() ACCOUNT(s) FOR TIES + RETAINS SEQUENCE
		,ar.reasoncode AS [QNXT Reason Code OON (A= OUT OF NETWORK)]
		,ar.[description] AS [QNXT Reason Code OON (A= OUT OF NETWORK) Descr.]
		FROM HMOPROD_PlanData.dbo.authservicereason AS asr (NOLOCK)
			JOIN HMOPROD_PlanData.dbo.reasongroupdtl AS rgd (NOLOCK) ON asr.reasongroupdtlid = rgd.reasongroupdtlid
			JOIN HMOPROD_PlanData.dbo.authreason AS ar (NOLOCK) ON rgd.reasoncode = ar.reasoncode
		WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ... AND ...
			AND ar.reasoncode IN ('411','412','413','414','415','416') -- COC per eMAIL ON 20220516 SUBJECT:Field Name changes & RANGE rewrite - RE: DHCS Audit 2022 - Assignments BODY:We heard FROM the UM team IN regards to the COC AND OON indicators AND what code to include for that. FROM:HINA ... was = '308' 
		) -- CONCLUDE ...
		AS oon ON r.referralid = oon.referralid
			-- AND oon.[RANKis] = 1 -- OUTER APPLY (SELECT TOP 1 ... Alt.
			-- AND oon.[ROWis] = 1 -- OUTER APPLY (SELECT TOP 1 ... Alt.
			
		LEFT JOIN INFORMATICS.dbo.[uvw_AUTHREFCLAIM] AS  Glembocki ON r.referralid = Glembocki.referralid -- 'Claude.ai v Perplexity.ai ...  'c.referralid OR cd.referralid = ref.authorizationid DISCOVERED ON 20150728 w Stefan Glembocki'
			AND r.authorizationid = Glembocki.authorizationid

	-- CHECK FOR DUP(S) --
/* SELECT ' ' AS [SHOULD BE NULL DUP Validation],*
-- DELETE
FROM #AUTHRFI
WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ... AND ...
	AND [referralid] IN 
	( -- INITIATE ...
	SELECT dup.[referralid]
	FROM #AUTHRFI AS dup
	GROUP BY dup.[referralid] -- Duplication Driver 
	HAVING COUNT(1)>1 -- HAVING clause RESERVED for AGGREGATE(s) ... HAVING SUM(PAID_NET_AMT) != 0
	) -- CONCLUDE ...  */

CREATE INDEX idx_REFACTOR_DupID ON #AUTHRFI (referralid,authorizationid,ClockStart)







-- ======================================================================
	--  Dx, PROC + REV -- 
-- ======================================================================
UPDATE #AUTHRFI
SET [Diagnosis code]  = rdiag.[Diagnosis code]
,[Diagnosis Category] = rdiag.[Diagnosis Category]
,[Diagnosis codes Descr] = rdiag.[Diagnosis codes Descr]
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
FROM #AUTHRFI AS r
	JOIN -- ISON ON Dx, PROC + REV ...
	( -- INITIATE ...	
	SELECT DISTINCT r.authorizationid,ad.referralid,UPPER(LTRIM(RTRIM(ISNULL(ad.diagcode,'')))) AS [Diagnosis code],LTRIM(RTRIM(ad.diagqualifier)) AS [Diagnosis Category]
	,[Diagnosis codes Descr] = UPPER(LTRIM(RTRIM(ISNULL(dc.description,'')))),sequence
	-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
	-- SELECT DISTINCT ' ' AS 'CHECK 1st'
	FROM HMOPROD_PLANDATA.dbo.referral AS r (NOLOCK) 
		JOIN HMOPROD_PLANDATA.dbo.authdiag AS ad (NOLOCK) ON r.referralid = ad.referralid
		JOIN HMOPROD_PLANDATA.dbo.diagcode AS dc (NOLOCK) ON ad.diagcode = dc.codeid
	WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ... AND ...
		AND UPPER(LTRIM(RTRIM(ISNULL(ad.diagcode,'')))) != '' -- NO NOT NEGATIVE <> != 
		AND sequence = 1 -- PRIMARY DIAGNOSIS
		) -- CONCLUDE ...
		AS rdiag ON r.referralid = rdiag.referralid

UPDATE #AUTHRFI
SET [CPT Procedure code]  = rcpt.[CPT Procedure code]
,[CPT Procedure code Description] = rcpt.[CPT Procedure code Description]
,[requested_units] = rcpt.[requested_units]
FROM #AUTHRFI AS r
	JOIN 
	( -- INITIATE ...	
	SELECT r.authorizationid,a.referralid,LTRIM(RTRIM(a.codeid)) AS [CPT Procedure code]
	,[CPT Procedure code Description] = UPPER(LTRIM(RTRIM(ISNULL(CAST(procd.description AS varchar(255)),''))))
	,SUM(a.totalunits) AS [requested_units]
	-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
	-- SELECT DISTINCT ' ' AS 'CHECK 1st'
	FROM HMOPROD_PLANDATA.dbo.referral AS r (NOLOCK)
		JOIN HMOPROD_PLANDATA.dbo.authservice AS a (NOLOCK) ON r.referralid = a.referralid
		JOIN HMOPROD_PLANDATA.dbo.svccode AS  procd (NOLOCK)  ON a.codeid = procd.codeid
	WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ... AND ...
		AND UPPER(LTRIM(RTRIM(ISNULL(a.codeid,'')))) != '' -- NO NOT NEGATIVE <> !=
	GROUP BY r.authorizationid,a.referralid,LTRIM(RTRIM(a.codeid)),UPPER(LTRIM(RTRIM(ISNULL(CAST(procd.description AS varchar(255)),''))))
		) -- CONCLUDE ...
		AS rcpt ON r.referralid = rcpt.referralid

UPDATE #AUTHRFI
SET [Rev code]  = rrev.[Rev code]
,[Rev code Description] = rrev.[Rev code Description]
,[requested_units] = CASE
WHEN r.requested_units IS NULL
THEN rrev.[requested_units]
ELSE r.requested_units
END
FROM #AUTHRFI AS r
	JOIN 
	( -- INITIATE ...	
	SELECT r.authorizationid,a.referralid,UPPER(LTRIM(RTRIM(ISNULL(a.codeid,'')))) AS [Rev code]
	,[Rev code Description] = UPPER(LTRIM(RTRIM(ISNULL(rev.description,''))))
	,SUM(a.totalunits) AS [requested_units]
	-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
	-- SELECT DISTINCT ' ' AS 'CHECK 1st'
	FROM HMOPROD_PLANDATA.dbo.referral AS r (NOLOCK)
		JOIN HMOPROD_PLANDATA.dbo.authservice AS a (NOLOCK) ON r.referralid = a.referralid
		JOIN HMOPROD_PLANDATA.dbo.revcode AS rev (NOLOCK) ON CASE
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
		WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ... AND ...
			AND UPPER(LTRIM(RTRIM(ISNULL(a.codeid,'')))) != '' -- NO NOT NEGATIVE <> !=
		GROUP BY r.authorizationid,a.referralid,UPPER(LTRIM(RTRIM(ISNULL(a.codeid,'')))),UPPER(LTRIM(RTRIM(ISNULL(rev.description,''))))
		) -- CONCLUDE ...
		AS rrev ON r.referralid = rrev.referralid







-- ==========================================================
	-- AUTH ATTRIBUTE(S) --
-- ==========================================================
/* SELECT DISTINCT ' ' AS 'AUTHREF ATTRIBUTE(S)',q.*
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM HMOPROD_PLANDATA.dbo.qattribute AS q
WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ... AND ...
	AND 
	( -- INITIATE ...
	q.attributeid IN ('C00863753','C00887907') -- AUTH EXTENSION LETTER SENT + ORAL NOTIFICATION PROVIDED
		OR UPPER(LTRIM(RTRIM(ISNULL(q.description,'')))) LIKE '%EXTEN%LETTER%' -- C00863753
		OR UPPER(LTRIM(RTRIM(ISNULL(q.description,'')))) LIKE '%AUTH%NOTIFI%LETT%SENT%' -- C00863757
		OR  UPPER(LTRIM(RTRIM(ISNULL(q.description,'')))) LIKE '%THRESH%SENT%' -- C01236757 + C01236806
		) -- CONCLUDE ... */

SELECT ' ' AS 'DHCS AUDIT REQUEST - CAP (CORRECTIVE ACTION PLAN)',attrib.referralid,attrib.thevalue,attrib.effdate
--,CONVERT(Varchar(10),r.seendate,101) AS ProcedureDate,--FORMERLY FOR IP & OP AUTH(s) / REF(s) - DailyRefCount_ProcedureDate
--,CONVERT(Varchar(10),a.DeterminationDate,101) AS ProcedureDate,--FORMERLY FOR BHT AUTH(s) / REF(s) - DailyRefCount_ProcedureDate
-- ,CAST(attrib.effdate AS datetime) AS [ATTRIB_PROCEDUREDATE]
,CAST(TRY_CONVERT(date,attrib.effdate) AS nvarchar(255))+''+TRY_CONVERT(datetime,attrib.thevalue) AS [ATTRIB_DATETIME]
,TRY_CONVERT(date,attrib.effdate) AS [ATTRIB_DATE]
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
INTO #authmodified
-- SELECT TOP 10 'alias Q' AS [Q],q.*,'alias ATTRIB' AS [ATTRIB],attrib.* -- CHECK 1st 
-- SELECT DISTINCT ' ' AS 'CHECK 1st',
FROM HMOPROD_PLANDATA.dbo.qattribute AS q (NOLOCK)
	JOIN HMOPROD_PLANDATA.dbo.referralattribute AS attrib (NOLOCK) ON q.attributeid = attrib.attributeid
WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ... AND ...
	AND UPPER(LTRIM(RTRIM(ISNULL(q.description,'')))) LIKE '%MODIFIED%' -- C001: UPDATE per eMAIL FROM MS ERICA ON 20240202 RELATED TO RESULTING AUDIT CAP (CORRECTION ACTION PLAN) ... Hi Phil, We need your assistance to comply with our 2023 DHCS CAP 1.2.1 response. Attached, is a copy of the report my team receives monthly for our internal audit review (link also included below). Index of \\chg_cifs01\Shared\HCS2017\HCS Audit - SARAG Reports\ Request: Please label any case with a ‘MODIFIED’ attribute IN QNXT, UM Record, Misc. tab, AS ‘Modified’ for Column M (Request Determination) ON this report. NOTe, will be zero identified for now, AS this is a new process.
	-- AND CAST(attrib.effdate AS date) BETWEEN @ClockStart AND @ClockStop

UPDATE #AUTHRFI
SET [Modified] = 'Y'
FROM #AUTHRFI AS ar
	JOIN #authmodified AS attr ON ar.referralid = attr.referralid

		-- SELECT ' ' AS 'SAMPLE',* FROM #authmodified WHERE referralid IN ('4416355') -- authorizationid IN ('3354410')







SELECT ' ' AS 'DHCS AUDIT REQUEST',attrib.referralid,attrib.thevalue,attrib.effdate
--,CONVERT(Varchar(10),r.seendate,101) AS ProcedureDate,--FORMERLY FOR IP & OP AUTH(s) / REF(s) - DailyRefCount_ProcedureDate
--,CONVERT(Varchar(10),a.DeterminationDate,101) AS ProcedureDate,--FORMERLY FOR BHT AUTH(s) / REF(s) - DailyRefCount_ProcedureDate
-- ,CAST(attrib.effdate AS datetime) AS [ATTRIB_PROCEDUREDATE]
,CAST(TRY_CONVERT(date,attrib.effdate) AS nvarchar(255))+''+TRY_CONVERT(datetime,attrib.thevalue) AS [ATTRIB_DATETIME]
,TRY_CONVERT(date,attrib.effdate) AS [ATTRIB_DATE]
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
INTO #authextension
-- SELECT TOP 10 'alias Q' AS [Q],q.*,'alias ATTRIB' AS [ATTRIB],attrib.* -- CHECK 1st 
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM HMOPROD_PLANDATA.dbo.qattribute AS q (NOLOCK)
	JOIN HMOPROD_PLANDATA.dbo.referralattribute AS attrib (NOLOCK) ON q.attributeid = attrib.attributeid
WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ... AND ...
	AND UPPER(LTRIM(RTRIM(ISNULL(q.description,'')))) LIKE '%EXTEN%LETTER%'
	-- AND CAST(attrib.effdate AS date) BETWEEN @ClockStart AND @ClockStop

UPDATE #AUTHRFI
SET [Extended] = 'Y'
FROM #AUTHRFI AS ar
	JOIN #authextension AS attr ON ar.referralid = attr.referralid

		-- SELECT ' ' AS 'SAMPLE',* FROM #authextension WHERE referralid IN ('4416355') -- authorizationid IN ('3354410')







SELECT ' ' AS 'DHCS AUDIT REQUEST',attrib.referralid,attrib.thevalue,attrib.effdate
--,CONVERT(Varchar(10),r.seendate,101) AS ProcedureDate,--FORMERLY FOR IP & OP AUTH(s) / REF(s) - DailyRefCount_ProcedureDate
--,CONVERT(Varchar(10),a.DeterminationDate,101) AS ProcedureDate,--FORMERLY FOR BHT AUTH(s) / REF(s) - DailyRefCount_ProcedureDate
-- ,CAST(attrib.effdate AS datetime) AS [ATTRIB_PROCEDUREDATE]
,CAST(TRY_CONVERT(date,attrib.effdate) AS nvarchar(255))+''+TRY_CONVERT(datetime,attrib.thevalue) AS [ATTRIB_DATETIME]
,TRY_CONVERT(date,attrib.effdate) AS [ATTRIB_DATE]
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
INTO #authnotification
-- SELECT TOP 10 'alias Q' AS [Q],q.*,'alias ATTRIB' AS [ATTRIB],attrib.* -- CHECK 1st 
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM HMOPROD_PLANDATA.dbo.qattribute AS q (NOLOCK)
	JOIN HMOPROD_PLANDATA.dbo.referralattribute AS attrib (NOLOCK) ON q.attributeid = attrib.attributeid
WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ... AND ...
	AND UPPER(LTRIM(RTRIM(ISNULL(q.description,'')))) LIKE '%AUTH%NOTIFI%LETT%SENT%'
	-- AND CAST(attrib.effdate AS date) BETWEEN @ClockStart AND @ClockStop

UPDATE #AUTHRFI
SET [Attribute Date /Time] = TRY_CONVERT(datetime,attr.[ATTRIB_DATETIME])
FROM #AUTHRFI AS ar
	JOIN #authnotification AS attr ON ar.referralid = attr.referralid

		-- SELECT ' ' AS 'SAMPLE',* FROM #authnotification WHERE referralid IN ('4416355') -- authorizationid IN ('3354410')







SELECT ' ' AS 'DHCS AUDIT REQUEST',attrib.referralid,attrib.thevalue,attrib.effdate
--,CONVERT(Varchar(10),r.seendate,101) AS ProcedureDate,--FORMERLY FOR IP & OP AUTH(s) / REF(s) - DailyRefCount_ProcedureDate
--,CONVERT(Varchar(10),a.DeterminationDate,101) AS ProcedureDate,--FORMERLY FOR BHT AUTH(s) / REF(s) - DailyRefCount_ProcedureDate
-- ,CAST(attrib.effdate AS datetime) AS [ATTRIB_PROCEDUREDATE]
,CAST(TRY_CONVERT(date,attrib.effdate) AS nvarchar(255))+''+TRY_CONVERT(datetime,attrib.thevalue) AS [ATTRIB_DATETIME]
,TRY_CONVERT(date,attrib.effdate) AS [ATTRIB_DATE]
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
INTO #auththreshold
-- SELECT TOP 10 'alias Q' AS [Q],q.*,'alias ATTRIB' AS [ATTRIB],attrib.* -- CHECK 1st 
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM HMOPROD_PLANDATA.dbo.qattribute AS q (NOLOCK)
	JOIN HMOPROD_PLANDATA.dbo.referralattribute AS attrib (NOLOCK) ON q.attributeid = attrib.attributeid
WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ... AND ...
	AND UPPER(LTRIM(RTRIM(ISNULL(q.description,'')))) LIKE '%THRESH%SENT%'
	-- AND CAST(attrib.effdate AS date) BETWEEN @ClockStart AND @ClockStop

/* UPDATE #AUTHRFI
SET [Attribute Date /Time] = TRY_CONVERT(datetime,attr.[ATTRIB_DATETIME])
FROM #AUTHRFI AS ar
	JOIN #auththreshold AS attr ON ar.referralid = attr.referralid

		-- SELECT ' ' AS 'SAMPLE',* FROM #authnotification WHERE referralid IN ('4416355') -- authorizationid IN ('3354410') */







-- ==================================================
	-- [TAT] threshold UPDATE(S) --
-- ==================================================
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
		-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
		-- SELECT DISTINCT ' ' AS 'CHECK 1st'
		FROM INFORMATICS.dbo.date_calendarISO AS dc,#AUTHRFI AS r -- DO NOT NO NEGATIVE <> != COVER UP THE TE()
		WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ... AND ...
			AND dc.calendar_date BETWEEN r.ClockStart AND r.ClockStop 
			AND ISNULL(dc.WORKDAY,0) = 1 
			AND ISNULL(dc.HOLIDAYS,0) = 0
		GROUP BY r.referralid,r.authorizationid
		) -- CONCLUDE ...
		AS tatwd ON ar.referralid = tatwd.referralid
			AND ar.authorizationid = tatwd.authorizationid
		LEFT JOIN 
		( -- INITIATE ...
		SELECT DISTINCT r.referralid,r.authorizationid
		,DATEDIFF(hh,r.ClockStart,r.ClockStop) AS [TAT]
		-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
		-- SELECT DISTINCT ' ' AS 'CHECK 1st'
		FROM #AUTHRFI AS r
		) -- CONCLUDE ...
		AS tath ON ar.referralid = tath.referralid
			AND ar.authorizationid = tath.authorizationid







-- =====================================================================
	-- [Primary or secondary claim] OR [Member Status (Primary, Secondary] --
-- =====================================================================
UPDATE #AUTHRFI
SET [Primary / Secondary Status] = estatus.[Plan Position Status] -- [Primary or secondary claim] OR [Member Status (Primary, Secondary] see "DMP" FOR alt. SEQUENCE
 FROM #AUTHRFI AS su
	JOIN 
	( -- INITIATE ...
	SELECT DISTINCT es.primarystatus AS [Plan Position Status],ek.carriermemid,ek.memid,es.effdate,es.termdate,es.primarystatus AS [STATUS INDICATOR],ec.ratecode,pg.programid,bp.planid,bp.description,ek.enrollid,r.referralid
	-- SELECT TOP 10 estatus.[STATUS INDICATOR],su.* -- CHECK 1st
	-- SELECT DISTINCT ' ' AS 'CHECK 1st'
	FROM HMOPROD_PLANDATA.dbo.enrollkeys AS ek (NOLOCK)
		JOIN HMOPROD_PLANDATA.dbo.member AS mem (NOLOCK) ON ek.memid = mem.memid
			LEFT JOIN HMOPROD_PLANDATA.dbo.benefitplan AS bp (NOLOCK) ON ek.programid = bp.programid
		JOIN HMOPROD_PLANDATA.dbo.program AS pg (NOLOCK) ON ek.programid = pg.programid
		JOIN HMOPROD_PLANDATA.dbo.entity AS ent (NOLOCK) ON mem.entityid = ent.entid
		JOIN HMOPROD_PlanData.dbo.enrollstatus AS es (NOLOCK) ON ek.enrollid = es.enrollid		
		JOIN HMOPROD_PLANDATA.dbo.enrollcoverage AS ec (NOLOCK) ON ek.enrollid = ec.enrollid
		JOIN HMOPROD_PLANDATA.dbo.referral AS r (NOLOCK) ON ek.memid = r.memid
			AND ek.enrollid = r.enrollid -- planid / programid JOIN
	WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ... AND ...
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
WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ... AND ...
	AND CAST(su.effdate AS date) BETWEEN CAST(estatus.effdate AS date) AND CAST(estatus.termdate AS date)	-- RINA: APPLIED TO FIELD WITHIN TABLE TO BE UPDATE







-- =====================================================================
	-- contracted PROVIDER(s) + QUPD TRUST but VERIFY contracted status ci.contracted --
-- =====================================================================
UPDATE #AUTHRFI
SET [contractedVerification] = TRY_CONVERT(nvarchar(1),NULL) -- POWER CYCLE RESET REFRESH RESTART ...

UPDATE #AUTHRFI
SET [contractedVerification] = fpp.[contracted] -- C002: QNXT FALSE PAR STATUS LOGIC APPLIED PER DISCUSSION WITH() SIR PHIL ON 20230223 
FROM #AUTHRFI AS ar
	JOIN INFORMATICS.dbo.[uvw_FALSE_PROVIDER_PAR] AS fpp ON ar.referfrom = fpp.provid -- FORMERLY #CURRENTCONTRACT







-- =====================================================================
	-- SOURCE: PCP UPDATE() --
-- =====================================================================
-- =====================================================================
	-- DECLARE @PARAMETER(S) / @FILTER(S) --
-- =====================================================================
DECLARE @PCPrecordRANK AS decimal(1,0) = 1 -- ENTER 1 TO GET() JUST MOST CURRENT [RANKis] see DENSE_RANK() OVER(PARTITION BY ek.memid ORDER BY CAST(ek.effdate AS datetime) DESC) AS [RANKis] --'RANKis' --RANK by MOST CURRENT EligHx

UPDATE #AUTHRFI
SET [Name of PCP] = UPPER(LTRIM(RTRIM(pcp.PCPName)))
,[PCP Address] = UPPER(LTRIM(RTRIM(pcp.ServiceLocationName)))
FROM #AUTHRFI AS tn
	JOIN INFORMATICS.dbo.[uvw_PCP] AS pcp ON tn.memid = pcp.memid
WHERE 1=1
	AND TRY_CONVERT(date,RECEIPT_DATE) BETWEEN TRY_CONVERT(date,pcp.effdate) AND TRY_CONVERT(date,pcp.termdate) -- RINA(): APPLIED TO FIELD WITHIN TABLE TO BE UPDATED

UPDATE #AUTHRFI -- USE IIF() STILL NULL()
SET [Name of PCP] = UPPER(LTRIM(RTRIM(pcp.PCPName)))
,[PCP Address] = UPPER(LTRIM(RTRIM(pcp.ServiceLocationName)))
FROM #AUTHRFI AS tn
	JOIN INFORMATICS.dbo.[uvw_PCP] AS pcp ON tn.memid = pcp.memid
WHERE 1=1
	AND pcp.RANKis IN (@PCPrecordRANK)
	AND pcp.ROWis IN (@PCPrecordRANK)
	AND tn.[Name of PCP] IS NULL







-- ============================================================= 
	-- SUMMARY / SUBTOTAL() ROLLUP v. CUBE --
-- =============================================================
SELECT ' ' AS 'AUTH SUMMARY: ',[RANGE NOTE(s)]
,status
,COUNT(DISTINCT(referralid)) AS [Referrals]
,COUNT(DISTINCT(authorizationid)) AS [Auths]
,COUNT(DISTINCT(memid)) AS [Unique Members] 
FROM #AUTHRFI
 GROUP BY [RANGE NOTE(s)],status

SELECT DISTINCT ' ' AS 'AUTH ReferFrom /  ReferTo LISTING: ',[RANGE NOTE(s)]                                                                                                                               
,referto
,ReferToNPI
,ReferToProv
,ReferFrom
,ReferFromNPI
,ReferFromProv
FROM #AUTHRFI
ORDER BY ReferToProv

SELECT ' ' AS 'OPEN AUTH SUMMARY',[RANGE NOTE(s)]
,status,COUNT(DISTINCT(referralid)) AS [Referrals]
,COUNT(DISTINCT(authorizationid)) AS [Auths]
,COUNT(DISTINCT(memid)) AS [Unique Members] 
FROM #AUTHRFI 
WHERE 1=1
	AND [CLAIM ASSOCIATED WITH AUTH] IS NULL 
	AND TRY_CONVERT(date,termdate) >= TRY_CONVERT(date,GETDATE()) GROUP BY [RANGE NOTE(s)],status

SELECT ' ' AS 'CLOSED AUTH SUMMARY',[RANGE NOTE(s)]
,status
,COUNT(DISTINCT(referralid)) AS [Referrals]
,COUNT(DISTINCT(authorizationid)) AS [Auths]
,COUNT(DISTINCT(memid)) AS [Unique Members] 
FROM #AUTHRFI 
WHERE 1=1
	AND [CLAIM ASSOCIATED WITH AUTH] IS NOT NULL 
GROUP BY [RANGE NOTE(s)],status

SELECT DISTINCT ' ' AS 'QA TEMPLATE TYPE OPTION(S)',[AuthRefType (Template)]
,servicecode
,status 
FROM #AUTHRFI

SELECT ' ' AS 'QA DATE RANGE + [LOB]',LINE_OF_BUSINESS
,MIN (TRY_CONVERT(date,RECEIPT_DATE)) AS [RANGE MIN]
,MAX(TRY_CONVERT(date,RECEIPT_DATE)) AS [RANGE MAX]
,COUNT(DISTINCT(referralid)) AS [AUTH(S)]
-- SELECT TOP 10 * -- CHECK 1st
-- SELECT DISTINCT -- CHECK 1st
FROM #AUTHRFI
GROUP BY LINE_OF_BUSINESS

SELECT ' ' AS 'QA DATE RANGE + [servicecode]',servicecode
,MIN (TRY_CONVERT(date,RECEIPT_DATE)) AS [RANGE MIN]
,MAX(TRY_CONVERT(date,RECEIPT_DATE)) AS [RANGE MAX]
,COUNT(DISTINCT(referralid)) AS [AUTH(S)]
-- SELECT TOP 10 * -- CHECK 1st
-- SELECT DISTINCT -- CHECK 1st
FROM #AUTHRFI
GROUP BY servicecode

SELECT TOP 10 ' ' AS '[TAT] HOURS: AUTH DETAIL MS EXCEL ODBC',* FROM #AUTHRFI AS auth WHERE Units = 'Hours'
SELECT TOP 10 ' ' AS '[TAT] BUSINESS DAYS: AUTH DETAIL MS EXCEL ODBC',* FROM #AUTHRFI AS auth WHERE Units = 'Business Days'
SELECT TOP 10 ' ' AS '[TAT] CALENDAR DAYS: AUTH DETAIL MS EXCEL ODBC',* FROM #AUTHRFI AS auth WHERE Units = 'Calendar Days'
SELECT TOP 10 ' ' AS 'OPEN AUTH DETAIL MS EXCEL ODBC',* FROM #AUTHRFI AS auth WHERE [CLAIM ASSOCIATED WITH AUTH] IS NULL AND TRY_CONVERT(date,auth.termdate) >= TRY_CONVERT(date,GETDATE()) -- STILL OPEN REFERRAL -- OPEN AUTH NO CLAIMS ASSOCIATION ...
SELECT TOP 10 ' ' AS 'CLOSED AUTH DETAIL MS EXCEL ODBC',* FROM #AUTHRFI AS auth WHERE [CLAIM ASSOCIATED WITH AUTH] IS NOT NULL -- CLOSED AUTH NO CLAIMS ASSOCIATION ...







-- ==================================================================
	-- NOTE(S) / COMMENT(S) / CHANGE.LOG --
-- ==================================================================
SELECT' ' AS 'JL Hx'

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
	  join HMOPROD_PLANDATA.dbo.planaction pa ON r.referralid = pa.primaryid
where pa.actionid = 105 --'OP AUTHREF' AS [TYPE],
	  and 
	  (
			 pa.comment like '%Status APPROVED - %'
			 or pa.comment like '%Status CLOSED - %'
			 or pa.comment like '%Status DENIED - %'
	  )
	  -- and pa.createdate >= @ClockStart
	  -- and pa.createdate < @ClockStop
UNION -- VERTICAL() STACK DISTINCT()
select 'IP AUTHREF' AS [TYPE],
	  r.referralid,
	  pa.createid AS Closer,
	  CAST(pa.createdate AS datetime) AS CloseDate,
	  row_number() over( partition by r.referralid ORDER BY pa.createdate ) AS ActionOrderNumber
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
from HMOPROD_PLANDATA.dbo.referral r
	  join HMOPROD_PLANDATA.dbo.planaction pa ON r.referralid = pa.primaryid
where pa.actionid = 209 --'IP AUTHREF' AS [TYPE],
	  AND (
			 pa.comment like '%Status APPROVED - %'
			 or pa.comment like '%Status CLOSED - %'
			 or pa.comment like '%Status DENIED - %'
	  )
	  -- and p

		DELETE	  
		-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
		-- SELECT DISTINCT ' ' AS 'CHECK 1st'
		FROM #AUTHREF_DECISION
		WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ... AND ...
			AND ActionOrderNumber != @Authkeep -- Row_number() over( partition by r.referralid ORDER BY pa.createdate )

	-- DUP(s)--
-- SELECT *
-- FROM #AUTHREF_DECISION
-- WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ... AND ...
	-- AND LTRIM(RTRIM(referralid))+LTRIM(RTRIM([TYPE])) IN (SELECT LTRIM(RTRIM(dup.referralid))+LTRIM(RTRIM(dup.[TYPE]))
	-- FROM #AUTHREF_DECISION AS dup
	-- GROUP BY LTRIM(RTRIM(dup.referralid))+LTRIM(RTRIM(dup.[TYPE])) --Duplication Driver
	-- HAVING COUNT(1)>1) --HAVING clause RESERVED for AGGREGATE(s)







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
	JOIN HMOPROD_PLANDATA.dbo.svccategory AS sc ON scg.catid = sc.catid
	JOIN HMOPROD_PLANDATA.dbo.svcsubcategory AS ssc ON scg.catid = ssc.catid
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
	JOIN HMOPROD_PLANDATA.dbo.referralattribute AS attrib ON q.attributeid = attrib.attributeid
WHERE UPPER(LTRIM(RTRIM(ISNULL(q.attributeid,'')))) IN ('C00863756')
	OR UPPER(LTRIM(RTRIM(ISNULL(q.description,'')))) LIKE '%AUTH%MODIF%'
	 
		-- SELECT TOP 10 * FROM #PARTIALFAVORABLE
		






-- ===============================================================
-- AUTH / REFERRAL : STATUS --
-- ===============================================================
UPDATE #AUTH_TEMPLATE
SET [DetailStatus] = 'ATTRIBUTE PARTIAL FAVORABLE' --ADD ON per DISCUSSION / MEETING ;WITH() SIR JL & SIR YOUSAF ON 20180221
FROM #AUTH_TEMPLATE AS auth
	JOIN #PARTIALFAVORABLE AS ra ON auth.referralid = ra.referralid

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
