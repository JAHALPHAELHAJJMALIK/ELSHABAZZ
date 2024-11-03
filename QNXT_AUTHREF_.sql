-- =====================================================================
	-- AUTH Request for Information (RFI) --
-- =====================================================================
-- =====================================================================
	-- COMMENT(S) / CHANGE.LOG: --
-- =====================================================================
-- C000: Coordinated Universal Time or UTC is the primary time standard globally used to regulate clocks and time. It establishes a reference for the current time, forming the basis for civil time and time zones. UTC facilitates international communication, navigation, scientific research, and commerce.

		-- ,CONVERT(datetime,(r.UtcReceiptDate at time zone 'UTC') at time zone 'Pacific Standard Time') 

-- C001: UPDATE per eMAIL FROM MS ERICA ON 20240202 RELATED TO RESULTING AUDIT CAP (CORRECTION ACTION PLAN) ... Hi Phil, We need your assistance to comply with our 2023 DHCS CAP 1.2.1 response. Attached, is a copy of the report my team receives monthly for our internal audit review (link also included below). Index of \\chg_cifs01\Shared\HCS2017\HCS Audit - SARAG Reports\ Request: Please label any case with a ‘MODIFIED’ attribute in QNXT, UM Record, Misc. tab, AS ‘Modified’ for Column M (Request Determination) on this report. NOTe, will be zero identified for now, AS this is a new process.
	-- AND CAST(attrib.effdate AS date) BETWEEN @ClockStart AND @ClockStop

-- C002: FROM ECM / CS Q  per TEAMS DISCUSSION WITH() MS CLAUDIA FOR TAB 5 WE SHOULD BE CAPTURING MEMBERS WITH() AN OPEN CS AUTH AT THE END OF THE QTR BEING REPORTED ... 	r.effdate AS 'Auth Start Date', -- FROM ALTER proc [dbo].[rptCommunitySupportsAuth] ... 	r.termdate AS 'Auth End Date', -- FROM ALTER proc [dbo].[rptCommunitySupportsAuth]

-- C003 C - SNP UPDATE per 'TEAMS CHAT' ON 20231012 'C-SNP User Stories'

-- C004: [Decision Maker] UPDATE: ... Hi Walter, We received feedback from DHCS on 1.2 PA Log. For all previous years, we've submitted our logs with the 'Decision Maker' column data stating 'Medical Director.' However, DHCS has now requested that we provide the name and credentials of the decision maker for all denial and modification records. May you please assist us by revising 1.2 PA Log for the ‘Decision Maker’ Column? Revised source logic: QNXT, UM Record, Assigned Services, Medical Director. I have saved Category1_1.2_17. CHG PA Log_rev.03.27 file: M:\Operations\Documents to Share\Yousaf\2024 DHCS Audit Thank you, Erica   ... Hi Walter, Yes, for example: Case 3804826 was denied by Dr. Conrad QNXT, UM Record, in the Assigned Services tab, the Medical Director assigned is CONRAD, ALAN J. 

-- C005: ,UPPER(q.lastname) +' '+UPPER(q.firstname) AS [UserName] ... PER ECM WEEKLY MEETING ON 20240516 ... WAS LEFT JOIN HMOPROD_QCSIDB.dbo.quser AS qat ON r.updateid = qat.loginid ... LTRIM(RTRIM(qat.firstname))+' '+LTRIM(RTRIM(qat.lastname)) AS [Assigned To]: ... USE to know who made the decision. r.authroizationid IN ('4182284','4063491','4062276') -- Auth# 4063491 Assigned to Jen Jackson: Auth# 4062276 Assigned to Jen Jackson: Auth# 4182284 Assigned to MS TANIA: LEFT JOIN HMOPROD_QCSIDB.dbo.quser AS q ON r.userid = q.userid

-- C006: [Auto Auth Status] PER ECM WEEKLY MEETING ON 20240516 ... Auto Approved: r.authroizationid IN ('3944504') do NOT have CLINICAL notes and only 1 online non CLINICAL note

			-- AND ISNULL(bp.[PROGRAM],'') IN ('CMC MEDICARE','CMC MEDI-CAL PLUS','DSNP MEDICARE PLAN','DSNP MEDI-CAL PLAN') -- DETERMRECON LOB ISO MATCH

-- =====================================================================
	-- DECLARE @PARAMETER(S) / @FILTER(S) --
-- =====================================================================
DECLARE @leadlag AS decimal(9,0)
DECLARE @leadlagmonths AS int
DECLARE @ClockStart AS datetime
DECLARE @ClockStop AS datetime
DECLARE @Authrundt AS datetime
DECLARE @Authlob AS nvarchar(255)

SET @leadlag = -3 -- +- LEAD() LAG() IN ...
SET @leadlagmonths = 3 -- +- LEAD() LAG() IN MONTH(S)
SET @ClockStart  = CAST('01/01/'+CAST(DATEPART(yyyy,DATEADD(month,@leadlag,CAST(GETDATE() AS datetime))) AS varchar(4)) AS datetime)
SET @ClockStop = TRY_CONVERT(date,GETDATE())
SET @Authrundt = TRY_CONVERT(date,GETDATE())
SET @Authlob = NULL -- 'QMXHPQ084%' -- WHEN LTRIM(RTRIM(ek.programid)) = 'QMXHPQ0847' -- CMCmcare ek.planid IS QMXBP0822  & WHEN LTRIM(RTRIM(ek.programid)) = 'QMXHPQ0848' -- CMCmcal ek.planid IS QMXBP0823

		SELECT ' ' AS 'AUTH Request for Information (RFI)','BETWEEN '+CONVERT(nvarchar(10),@ClockStart,101)+' AND '+CONVERT(nvarchar(10),@ClockStop,101) AS [RANGE NOTE(S)]
		,@Authrundt AS [EXEC DATE]
		,@Authlob AS [LOB @parm FILTER]
		,bp.*
		-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
		-- SELECT DISTINCT ' ' AS 'CHECK 1st'
		FROM INFORMATICS.dbo.[uvw_LINE_OF_BUSINESS] AS bp -- HMOPROD_PLANDATA.dbo.benefitplan + HMOPROD_PLANDATA.dbo.program
		WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ... AND ...
			-- AND bp.[LINE_OF_BUSINESS] LIKE ISNULL('%'+@AuthLob+'%','%')
			AND bp.[PLAN] LIKE ISNULL('%'+@AuthLob+'%','%')
			-- AND bp.[PROGRAM] LIKE ISNULL('%'+@AuthLob+'%','%')

		SELECT TOP 1 ' ' AS 'RECIPT OF TIME ZONE',CAST(CONVERT(datetime,(r.UtcReceiptDate at time zone 'UTC') at time zone 'Pacific Standard Time') AS datetime) AS [RECEIPT_DATE_PACIFIC_TIME_ZONE]
		,TRY_CONVERT(datetime,r.UtcReceiptDate) AS [RECEIPT_DATE_ORIGIN_TIME_ZONE]
		FROM HMOPROD_PLANDATA.dbo.referral AS r

		SELECT DISTINCT ' ' AS 'AUTH / REF [ACUITY_PRIORITY]',r.acuity,r.priority
		,CASE 
		WHEN r.[priority] = 'H' 
		THEN CONVERT(nvarchar(25),'Expedited')
		ELSE CONVERT(nvarchar(25),'Standard')
		END AS [acuity_priority]
		FROM HMOPROD_PLANDATA.dbo.referral AS r
		WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ... AND ...

		SELECT DISTINCT ' ' AS 'AUTH "TEMPLATE" OPTION(S)',r.servicecode,ac.codeid,ac.description,ac.authcategory
		,UPPER(LTRIM(RTRIM(ISNULL(ac.description,'')))) AS [AUTH TYPE (TEMPLATE) DESCR]
		,CASE 
		WHEN r.servicecode IN ('INPATIENT', 'INPTARE', 'INPTBH', 'INPTHPSC', 'INPTLTAC', 'INPTSNF', 'IPLate', 'IPPALL', 'IPRetro', 'IPSNDT') 
		THEN 'Inpatient'
		WHEN r.servicecode IN ('OPLate', 'OPSurgery', 'OUTPATIENT', 'HEALTH ED', 'CBAS', 'OPPALL', 'OPRetro') 
		THEN 'Outpatient'
		WHEN r.servicecode IN ('BEHAVIORAL HLTH', 'BHLate', 'BHRetro') 
			OR r.userid = 1178 -- SELECT ' ' AS 'OnlineBH',* FROM HMOPROD_QCSIDB.dbo.quser WHERE userid = 1178
		THEN 'BH' -- sub.renderingSpecialty like 'behavioral health%' or sub.renderingSpecialty like '%psych%' then 'BH'
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
		FROM HMOPROD_PLANDATA.dbo.referral AS r
			JOIN HMOPROD_PLANDATA.dbo.authcode AS ac ON r.servicecode = ac.codeid
		WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ... AND ...
			-- AND ac.codeid LIKE '%AUTO%' -- Please include only auto-auths from this universe. (These are NOT considered authorizations). You may identify auto auth with the following template path. Auth Category: Outpatient, Subcategory: Outpatient, Template: Online Auth
			-- AND r.servicecode LIKE '%ICF%' -- ICF/DD (ntermediate Care Facility for Developmentally Disabled Transition (ICF/DD) and Subacute Monitoring Survey)'
			-- AND a.description LIKE '%palliative%'







--------------------------------------------------------------------------------------------------------------------
	-- Error Trapping: Check If Permanent Table(s) Already Exist(s) And Drop If Applicable --
--------------------------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS #AUTHPROVISO -- SQL Server 2016 and later -- DYNAMIC tmp OR STATIC [TABLE] #TableName is a local temporary table visible only in the current session; ##TableName is a GLOBAL temporary table visible to all sessions IN ('TempDB')

SELECT DISTINCT UPPER(LTRIM(RTRIM(ISNULL(pspe.spectype,'')))) AS [Specialty Status]
,DENSE_RANK() OVER(PARTITION BY prov.provid ORDER BY spe.description) AS [RANKis]
,ROW_NUMBER() OVER(PARTITION BY prov.provid ORDER BY spe.description) AS [ROWis]
,UPPER(LTRIM(RTRIM(ISNULL(spe.specialtycode,'')))) AS SPECcode
,UPPER(LTRIM(RTRIM(ISNULL(spe.description,'')))) AS SPECdescr
,pspe.spectype
,prov.provid,prov.fedid,prov.NPI,prov.ExternalID -- AS [SEQ_PROV_ID]
,PROVNM = UPPER(LTRIM(RTRIM(ISNULL(prov.fullname,'')))) -- PROVIDER NAME
,ent.enttype,ent.lastname,ent.firstname,ent.middlename,ent.entname
,PROVcode = UPPER(LTRIM(RTRIM(ISNULL(pt.provtype,'')))) -- PROVTYPE CODE
,PROVtype = UPPER(LTRIM(RTRIM(ISNULL(pt.[description],'')))) -- PROVTYPE Descr.
,PROVclass = UPPER(LTRIM(RTRIM(ISNULL(pt.provclass,'')))) -- PROVTYPE Classification
,PROVaddr1 = UPPER(LTRIM(RTRIM(ISNULL(ent.phyaddr1,''))))
,PROVaddr2 = UPPER(LTRIM(RTRIM(ISNULL(ent.phyaddr2,''))))
,PROVcity = UPPER(LTRIM(RTRIM(ISNULL(ent.phycity,''))))
,PROVstate = SUBSTRING(UPPER(LTRIM(RTRIM(ISNULL(ent.phystate,'')))),1,2)
,PROVcounty = UPPER(LTRIM(RTRIM(ISNULL(ent.phycounty,'')))) -- •	County, if Plan is multi-county
,PROVzip = CASE
WHEN SUBSTRING(LTRIM(RTRIM(ent.phyzip)),1,1) = '0'
THEN '0'+ SUBSTRING(LTRIM(RTRIM(ent.phyzip)),2,4)
WHEN SUBSTRING(LTRIM(RTRIM(ent.phyzip)),1,1) = '00'
THEN '00'+ SUBSTRING(LTRIM(RTRIM(ent.phyzip)),3,3)
ELSE  SUBSTRING(LTRIM(RTRIM(ent.phyzip)),1,5) 
END
,PROVphone = CASE
WHEN LTRIM(RTRIM(ent.phone)) = ''
THEN SUBSTRING(REPLACE(LTRIM(RTRIM(ent.emerphone)),'-',''),1,10)
ELSE SUBSTRING(REPLACE(LTRIM(RTRIM(ent.phone)),'-',''),1,10)
END
,PROVmobile = CASE
WHEN LTRIM(RTRIM(ent.mobilephone)) = ''
THEN SUBSTRING(REPLACE(LTRIM(RTRIM(ent.secphone)),'-',''),1,10)
ELSE SUBSTRING(REPLACE(LTRIM(RTRIM(ent.mobilephone)),'-',''),1,10)
END
,PROVemail = LTRIM(RTRIM(ent.email))
-- ,evips.REGION AS [PCP REGION]
INTO #AUTHPROVISO
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
FROM HMOPROD_PLANDATA.dbo.provider AS prov
	JOIN HMOPROD_PLANDATA.dbo.entity AS ent ON prov.entityid = ent.entid

		LEFT JOIN HMOPROD_PLANDATA.dbo.providertype AS pt ON prov.provtype = pt.provtype
		LEFT JOIN HMOPROD_PLANDATA.dbo.provspecialty AS pspe ON prov.provid = pspe.provid
			AND UPPER(LTRIM(RTRIM(ISNULL(pspe.spectype,'PRIMARY')))) LIKE 'PRIMARY' -- PRIMARY SPECIALTY ISO ...
		LEFT JOIN HMOPROD_PLANDATA.dbo.specialty AS spe ON pspe.specialtycode = spe.specialtycode

WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ... AND ...

	-- AND 
	-- ( -- INITIATE ...
	-- ISNULL(prov.NPI,'') IN ('1518424829','1962598425')
		-- OR UPPER(LTRIM(RTRIM(ISNULL(prov.provid,'')))) IN ('313124') -- EYECARE OF SAN DIEGO
		-- OR UPPER(LTRIM(RTRIM(ISNULL(prov.fullname,'')))) LIKE '%SURGER%CEN%' -- PROVIDER NAME
		-- OR UPPER(LTRIM(RTRIM(ISNULL(ent.phycounty,'')))) LIKE '%SAN%DIEG%' -- SERVICE AREA()
	-- ) -- CONCLUDE ...

	-- CHECK FOR DUP(S) --
-- SELECT ' ' AS [SHOULD BE NULL DUP Validation],*
-- FROM #AUTHPROVISO
-- WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ... AND ...
	-- AND LTRIM(RTRIM(provid)) IN
	-- ( -- INITIATE ...
	-- SELECT LTRIM(RTRIM(dup.provid))
	-- FROM #AUTHPROVISO AS dup
	-- GROUP BY LTRIM(RTRIM(dup.provid)) --Duplication Driver
	-- HAVING COUNT(1)>1 --HAVING clause RESERVED for AGGREGATE(s)
	-- ) -- CONCLUDE ...

		-- SELECT ' ' AS 'Request for Information (RFI)',* FROM #AUTHPROVISO






--------------------------------------------------------------------------------------------------------------------
	-- Error Trapping: Check If Permanent Table(s) Already Exist(s) And Drop If Applicable --
--------------------------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS #SETreferralrange -- SQL Server 2016 and later -- DYNAMIC tmp OR STATIC [TABLE] #TableName is a local temporary table visible only in the current session; ##TableName is a GLOBAL temporary table visible to all sessions IN ('TempDB')

SELECT DISTINCT 'AUTH ISO' AS 'AUTH CATEGORY',r.referralid -- ,year_month
INTO #SETreferralrange
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM HMOPROD_PLANDATA.dbo.referral AS r
	JOIN HMOPROD_PLANDATA.dbo.enrollkeys AS e ON r.enrollid = e.enrollid
	JOIN INFORMATICS.dbo.[uvw_LINE_OF_BUSINESS] AS bp ON e.programid = bp.programid  -- HMOPROD_PLANDATA.dbo.benefitplan + HMOPROD_PLANDATA.dbo.program
	
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
	THEN 'BH' -- sub.renderingSpecialty like 'behavioral health%' or sub.renderingSpecialty like '%psych%' then 'BH'
	ELSE r.servicecode
	END AS [AuthRefType (Template)]
	,CASE 
	WHEN r.servicecode LIKE '%Retro%'
	THEN 'Post-service'
	WHEN r.servicecode LIKE '%INP%SNF%'
	THEN 'Concurrent'
	ELSE 'Pre-service'
	END AS [AuthRefType (Grouping)] -- If template says Retro = Post-service, INPATIENT – SNF = concurrent, All others = pre-service
	FROM HMOPROD_PLANDATA.dbo.referral AS r
		JOIN HMOPROD_PLANDATA.dbo.authcode AS ac ON r.servicecode = ac.codeid
	WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ... AND ...
		AND r.servicecode LIKE '%ICF%' -- ICF/DD (ntermediate Care Facility for Developmentally Disabled Transition (ICF/DD) and Subacute Monitoring Survey)'
		) -- CONCLUDE ...
		AS atemplate ON r.referralid = atemplate.referralid */

	/* JOIN -- ISO ON [referto]
	( -- INITIATE ...
	SELECT DISTINCT p.NPI,p.provid,piso.SPECdescr AS [SPECIALTY],p.fullname
	FROM HMOPROD_PLANDATA.dbo.provider AS p
		JOIN #AUTHPROVISO AS piso ON p.provid = piso.provid
	WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ... AND ...
		AND ISNULL(piso.NPI,'') != '' -- NO NOT NEGATIVE <> != 
	) -- CONCLUDE ...
	AS ccto ON r.referto = ccto.provid */
	
	/* JOIN -- ISO ON [referfrom]
	( -- INITIATE ...
	SELECT DISTINCT p.NPI,p.provid,piso.SPECdescr AS [SPECIALTY],p.fullname
	FROM HMOPROD_PLANDATA.dbo.provider AS p
		JOIN #AUTHPROVISO AS piso ON p.provid = piso.provid
	WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ... AND ...
		AND ISNULL(piso.NPI,'') != '' -- NO NOT NEGATIVE <> != 
	) -- CONCLUDE ...
	AS ccfrom ON r.referfrom = ccfrom.provid */
	
	/* JOIN -- ISO ON Dx ...
	( -- INITIATE ...	
	SELECT DISTINCT r.authorizationid,ad.referralid,UPPER(LTRIM(RTRIM(ISNULL(ad.diagcode,'')))) AS [Diagnosis code],LTRIM(RTRIM(ad.diagqualifier)) AS [Diagnosis Category]
	,[Diagnosis codes Descr] = UPPER(LTRIM(RTRIM(ISNULL(dc.description,'')))),sequence
	FROM HMOPROD_PLANDATA.dbo.referral AS r
		JOIN HMOPROD_PLANDATA.dbo.authdiag AS ad ON r.referralid = ad.referralid
			LEFT JOIN HMOPROD_PLANDATA.dbo.diagcode AS dc ON ad.diagcode = dc.codeid
	WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ... AND ...
		AND UPPER(LTRIM(RTRIM(ISNULL(ad.diagcode,'')))) IN ('')
		AND sequence = 1 -- PRIMARY DIAGNOSIS
		) -- CONCLUDE ...
		AS rdiag ON r.referralid = rdiag.referralid */		

	/* JOIN -- ISO ON CPT PROCEDURE CODE ...
	( -- INITIATE ...	
	SELECT r.authorizationid,a.referralid,LTRIM(RTRIM(a.codeid)) AS [CPT Procedure code]
	,[CPT Procedure code Description] = UPPER(LTRIM(RTRIM(ISNULL(CAST(procd.description AS varchar(255)),''))))
	,SUM(a.totalunits) AS [requested_units]
	FROM HMOPROD_PLANDATA.dbo.referral AS r
		JOIN HMOPROD_PLANDATA.dbo.authservice AS a ON r.referralid = a.referralid
		JOIN HMOPROD_PLANDATA.dbo.svccode AS  procd  ON a.codeid = procd.codeid
	WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ... AND ...
		AND UPPER(LTRIM(RTRIM(ISNULL(a.codeid,'')))) IN ('')
	GROUP BY r.authorizationid,a.referralid,LTRIM(RTRIM(a.codeid)),UPPER(LTRIM(RTRIM(ISNULL(CAST(procd.description AS varchar(255)),''))))
		) -- CONCLUDE ...
		AS rcpt ON r.referralid = rcpt.referralid */
		
	/* JOIN -- ISO ON REV ...
	( -- INITIATE ...	
	SELECT r.authorizationid,a.referralid,UPPER(LTRIM(RTRIM(ISNULL(a.codeid,'')))) AS [Rev code]
	,[Rev code Description] = UPPER(LTRIM(RTRIM(ISNULL(rev.description,''))))
	,SUM(a.totalunits) AS [requested_units]
	FROM HMOPROD_PLANDATA.dbo.referral AS r
		JOIN HMOPROD_PLANDATA.dbo.authservice AS a ON r.referralid = a.referralid
		JOIN HMOPROD_PLANDATA.dbo.revcode AS rev ON CASE
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
		AS rrev ON r.referralid = rrev.referralid */

WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ... AND ...
	AND r.termdate >= r.effdate -- MUST BE TRUE ... NON-CROSSFOOTED RECORDS ARE ACTIVE ...

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
	
	-- AND bp.description LIKE ISNULL(@AuthLob,'%%%')







--------------------------------------------------------------------------------------------------------------------
	-- Error Trapping: Check If Permanent Table(s) Already Exist(s) And Drop If Applicable --
--------------------------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS #AUTHRFI -- SQL Server 2016 and later -- DYNAMIC tmp OR STATIC [TABLE] #TableName is a local temporary table visible only in the current session; ##TableName is a GLOBAL temporary table visible to all sessions IN ('TempDB')

SELECT DISTINCT 'BETWEEN '+CONVERT(nvarchar(10),@ClockStart,101)+' AND '+CONVERT(nvarchar(10),@ClockStop,101)AS [RANGE NOTE(s)]
,srr.[AUTH CATEGORY]
,CASE 
WHEN r.servicecode IN ('INPATIENT', 'INPTARE', 'INPTBH', 'INPTHPSC', 'INPTLTAC', 'INPTSNF', 'IPLate', 'IPPALL', 'IPRetro', 'IPSNDT') THEN 'Inpatient'
WHEN r.servicecode IN ('OPLate', 'OPSurgery', 'OUTPATIENT', 'HEALTH ED', 'CBAS', 'OPPALL', 'OPRetro') 
THEN 'Outpatient'
WHEN r.servicecode IN ('BEHAVIORAL HLTH', 'BHLate', 'BHRetro') 
	OR r.userid = 1178 -- SELECT ' ' AS 'OnlineBH',* FROM HMOPROD_QCSIDB.dbo.quser WHERE userid = 1178
THEN 'BH' -- sub.renderingSpecialty like 'behavioral health%' or sub.renderingSpecialty like '%psych%' then 'BH'
ELSE r.servicecode
END AS [AuthRefType (Template)]
,CASE 
WHEN r.servicecode LIKE '%Retro%'
THEN 'Post-service'
WHEN r.servicecode LIKE '%INP%SNF%'
THEN 'Concurrent'
ELSE 'Pre-service'
END AS [AuthRefType (Grouping)] -- If template says Retro = Post-service, INPATIENT – SNF = concurrent, All others = pre-service
,vrb.BUCKET,ac.codeid,r.servicecode
,r.authorizationid AS [Prior Authorization Number],r.referralid,r.authorizationid
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
,r.effdate,r.termdate,r.referraldate,r.seendate,r.receiptdate,r.seendate AS [DecisionDate],r.admitdate,r.dischargedate
,r.referfrom,ccfrom.fullname AS ReferFromProv,ccfrom.NPI AS ReferFromNPI
,r.referto,ccto.fullname AS ReferToProv,ccto.NPI AS ReferToNPI
,r.memid,mem.CIN,mem.HealthPlanID,TRY_CONVERT(date,mem.dob) AS 'Member DOB',mem.[Member Name],mem.[Member Last Name],mem.[Member First Name]
,[MEMBER_AGE] = CAST(DATEDIFF("dd",CAST(mem.dob AS datetime),TRY_CONVERT(date,r.effdate))/365.25 AS money)
,[MEMBER_TRUE_CHRONOLOGICAL_AGE] = CAST(SUBSTRING(CAST(CAST(DATEDIFF("dd",TRY_CONVERT(date,mem.dob),TRY_CONVERT(date,r.effdate))/365.25 AS money) AS nvarchar(25)),1,CHARINDEX('.',CAST(DATEDIFF("dd",TRY_CONVERT(date,mem.dob),TRY_CONVERT(date,r.effdate))/365.25 AS money),1)-1) AS int)
,[MEMBER_TRUE_CHRONOLOGICAL_AGE_AND_HOW_MANY_MTHs] = DATEDIFF("mm",TRY_CONVERT(date,mem.dob),TRY_CONVERT(date,r.effdate))-CAST(SUBSTRING(CAST(CAST(DATEDIFF("dd",TRY_CONVERT(date,mem.dob),TRY_CONVERT(date,r.effdate))/365.25 AS money) AS nvarchar(25)),1,CHARINDEX('.',CAST(DATEDIFF("dd",TRY_CONVERT(date,mem.dob),TRY_CONVERT(date,r.effdate))/365.25 AS money),1)-1) AS int)*12
,bp.[LINE_OF_BUSINESS]
,bp.programid,bp.planid
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
,r.acuity,r.priority
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
,CASE
WHEN r.[status] = 'DENIED' 
THEN UPPER(LTRIM(RTRIM(ISNULL(en.lastname,'')))) +', '+UPPER(LTRIM(RTRIM(ISNULL(en.firstname,'')))) -- C004: [Decision Maker] UPDATE: ... Hi Walter, We received feedback from DHCS on 1.2 PA Log. For all previous years, we've submitted our logs with the 'Decision Maker' column data stating 'Medical Director.' However, DHCS has now requested that we provide the name and credentials of the decision maker for all denial and modification records. May you please assist us by revising 1.2 PA Log for the ‘Decision Maker’ Column? Revised source logic: QNXT, UM Record, Assigned Services, Medical Director. I have saved Category1_1.2_17. CHG PA Log_rev.03.27 file: M:\Operations\Documents to Share\Yousaf\2024 DHCS Audit Thank you, Erica   ... Hi Walter, Yes, for example: Case 3804826 was denied by Dr. Conrad QNXT, UM Record, in the Assigned Services tab, the Medical Director assigned is CONRAD, ALAN J. 
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
,TRY_CONVERT(nvarchar(1),NULL) AS [contractedVerification],r.paytoaffiliationid,r.DefaultContractId
,CASE
WHEN UPPER(LTRIM(RTRIM(ISNULL(UPPER(LTRIM(RTRIM(ISNULL(q.lastname,'')))),''))))+', '+UPPER(LTRIM(RTRIM(ISNULL(UPPER(LTRIM(RTRIM(ISNULL(q.firstname,'')))),'')))) LIKE '%BUCKET%'
THEN ISNULL(vrb.[BUCKET],'')
ELSE UPPER(LTRIM(RTRIM(ISNULL(q.loginid,''))))+' - '+UPPER(LTRIM(RTRIM(ISNULL(UPPER(LTRIM(RTRIM(ISNULL(q.lastname,'')))),''))))+', '+UPPER(LTRIM(RTRIM(ISNULL(UPPER(LTRIM(RTRIM(ISNULL(q.firstname,'')))),''))))
END AS [Assigned]
INTO #AUTHRFI
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st',status
FROM #SETreferralrange AS srr
	JOIN HMOPROD_PLANDATA.dbo.referral AS r ON srr.referralid = r.referralid
	JOIN HMOPROD_PLANDATA.dbo.enrollkeys AS e ON r.enrollid = e.enrollid
	JOIN INFORMATICS.dbo.[uvw_LINE_OF_BUSINESS] AS bp ON e.programid = bp.programid  -- HMOPROD_PLANDATA.dbo.benefitplan + HMOPROD_PLANDATA.dbo.program
	
	JOIN HMOPROD_PLANDATA.dbo.provider AS ccto ON r.referto = ccto.provid
	-- JOIN HMOPROD_PLANDATA.dbo.affiliation AS affto ON ccto.provid = affto.provid

	JOIN HMOPROD_PLANDATA.dbo.provider AS ccfrom ON r.referfrom = ccfrom.provid
	-- JOIN HMOPROD_PLANDATA.dbo.affiliation AS afffrom ON ccfrom.provid = afffrom.provid

-- =============================================================
	-- #BASELINE QNXT MEMBERSHIP DEMOGRAPHIC JOIN ... --
-- =============================================================
	JOIN 
	( -- INITIATE ...
	SELECT ranksetup.*
	,DENSE_RANK() OVER(PARTITION BY ranksetup.memid ORDER BY TRY_CONVERT(date,ranksetup.termdate) DESC,TRY_CONVERT(date,ranksetup.effdate) DESC) AS [RANKis] -- RANK by MOST CURRENT EligHx
	,ROW_NUMBER() OVER(PARTITION BY ranksetup.memid ORDER BY TRY_CONVERT(date,ranksetup.termdate) DESC,TRY_CONVERT(date,ranksetup.effdate) DESC) AS [ROWis] -- RANK by MOST CURRENT EligHx
	-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
	-- SELECT DISTINCT ' ' AS 'CHECK 1st'
	FROM 
	( -- INITIATE ...
	SELECT DISTINCT mb.memid
	,mb.ssn
	,mb.secondaryid
	,mb.headofhouse
	,mb.dob
	,mb.deathdate
	,SUBSTRING(UPPER(LTRIM(RTRIM(ISNULL(mb.secondaryid,'')))),1,9) AS [CIN],SUBSTRING(LTRIM(RTRIM(ISNULL(ek.carriermemid,''))),1,10) AS [HealthPlanID]
	,IIF(LEN(mb.headofhouse) < 10, CONCAT(RTRIM(mb.headofhouse), REPLICATE('0', 10 - LEN(mb.headofhouse))), RTRIM(mb.headofhouse)) AS 'PaddedHeadOfHouse' -- When you try to join Capitation Subscriber_ID to Member Headofhouse, there are some subscriber id that won't match ... The Cap table always pads the subscriber ids with zeros to complete it to 10 characters. To overcome this you need to create a member table with the code below
	,mb.fullname AS [Member Name]
	,ent.firstname AS [Member First Name],ent.lastname AS [Member Last Name]
	,ek.effdate
	,ek.termdate
	,lob.* -- uvw_LINE_OF_BUSINESS
	-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
	-- SELECT DISTINCT ' ' AS 'CHECK 1st'
	FROM HMOPROD_PLANDATA.dbo.member As mb
		JOIN HMOPROD_PLANDATA.dbo.enrollkeys AS ek ON mb.memid = ek.memid
		JOIN HMOPROD_PLANDATA.dbo.entity AS ent ON mb.entityid = ent.entid
			LEFT JOIN INFORMATICS.dbo.[uvw_LINE_OF_BUSINESS] AS lob ON ek.planid = lob.planid -- HMOPROD_PLANDATA.dbo.benefitplan + HMOPROD_PLANDATA.dbo.program
	WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ...
		AND UPPER(LTRIM(RTRIM(ISNULL(ek.segtype,'')))) ='INT'
		AND ISNULL(mb.IsSubscriber,'') = 'Y' -- ISO ON SUBSCRIBER ONLY!!!
		AND CAST(ek.termdate AS date) > CAST(ek.effdate AS date) -- MUST BE TRUE ... NON-CROSSFOOTED RECORDS ARE ACTIVE ...
		) -- CONCLUDE ...
		AS ranksetup
		) -- CONCLUDE ...
	AS mem ON r.memid = mem.memid
		AND mem.[RANKis] = 1 -- RANK by MOST CURRENT EligHx
		AND mem.[ROWis] = 1 -- RANK by MOST CURRENT EligHx
		
		LEFT JOIN HMOPROD_QCSIDB.dbo.quser AS qat ON r.updateid = qat.loginid -- C005: ,UPPER(q.lastname) +' '+UPPER(q.firstname) AS [UserName] ... PER ECM WEEKLY MEETING ON 20240516 ... WAS LEFT JOIN HMOPROD_QCSIDB.dbo.quser AS qat ON r.updateid = qat.loginid ... LTRIM(RTRIM(q.firstname))+' '+LTRIM(RTRIM(q.lastname)) AS [Assigned To]: ... use to know who made the decision. r.authroizationid IN ('4182284','4063491','4062276') -- Auth# 4063491 Assigned to Jen Jackson: Auth# 4062276 Assigned to Jen Jackson: Auth# 4182284 Assigned to MS TANIA: 
		LEFT JOIN HMOPROD_PlanData.dbo.referraltext AS rt ON r.referralid = rt.referralid -- [Auto Auth Status] -- C005: PER ECM WEEKLY MEETING ON 20240516 ... Auto Approved: r.authroizationid IN ('3944504') do NOT have CLINICAL NOTes and only 1 online non CLINICAL NOT
		LEFT JOIN HMOPROD_PLANDATA.dbo.authdiag AS ad ON r.referralid = ad.referralid
		LEFT JOIN HMOPROD_PLANDATA.dbo.authcode AS ac ON r.servicecode = ac.codeid --AUTH TYPE (TEMPLATE) DEFINITION()
		LEFT JOIN HMOPROD_PLANDATA.dbo.program AS p ON e.programid = p.programid
		LEFT JOIN HMOPROD_PLANDATA.dbo.authservice AS a ON r.referralid = a.referralid --PROC / REV CODE(s)
		LEFT JOIN HMOPROD_PLANDATA.dbo.authservicedetail AS asd ON r.referralid = asd.referralid
			AND asd.sequence = ad.sequence
		LEFT JOIN HMOPROD_PLANDATA.dbo.authservicereason AS asr ON a.referralid = asr.referralid
		LEFT JOIN HMOPROD_PLANDATA.dbo.reasongroupdtl AS rg ON asr.reasongroupdtlid =  rg.reasongroupdtlid
		LEFT JOIN HMOPROD_PLANDATA.dbo.authreason AS ar ON rg.reasoncode = ar.reasoncode
		LEFT JOIN HMOPROD_PLANDATA.dbo.entity AS en ON a.meddirectorid = en.entid --,UPPER(en.lastname) +','+UPPER(en.firstname) AS DetermName
		-- LEFT JOIN HMOPROD_QCSIDB.dbo.quser AS q ON r.issueinitials = q.UPDATEid
		LEFT JOIN HMOPROD_QCSIDB.dbo.quser AS q ON r.userid = q.userid --,UPPER(q.lastname) +' '+UPPER(q.firstname) AS UserName

		LEFT JOIN 
		( -- INITIATE ...
		SELECT DISTINCT q.loginid,q.userid,UPPER(LTRIM(RTRIM(ISNULL(UPPER(LTRIM(RTRIM(ISNULL(q.lastname,'')))),''))))+' '+UPPER(LTRIM(RTRIM(ISNULL(UPPER(LTRIM(RTRIM(ISNULL(q.firstname,'')))),'')))) AS [BUCKET]
		FROM HMOPROD_QCSIDB.dbo.quser AS q
		WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ... AND ...
			AND UPPER(LTRIM(RTRIM(ISNULL(q.lastname,'')))) LIKE '%BUCKET%'
		) -- CONCLUDE ...
		AS vrb ON r.userid = vrb.userid

		LEFT JOIN -- COC per eMAIL ON 20220516 SUBJECT:Field Name changes & RANGE rewrite - RE: DHCS Audit 2022 - Assignments BODY:We heard FROM the UM team in regards to the COC AND OON indicators AND what code to include for that. FROM:HINA ... was = '308' 
		( -- INITIATE ... 
		SELECT DISTINCT asr.referralid,asr.[sequence],DENSE_RANK() OVER(PARTITION BY asr.referralid ORDER BY asr.[sequence]) AS [RANKis] -- RANK() ACCOUNT(s) FOR TIES + RETAINS SEQUENCE
		,ar.reasoncode AS [QNXT Reason Code (A= COC Reporting: Continuity of Care)] 
		,ar.[description] AS [QNXT Reason Code (A= COC Reporting: Continuity of Care) Descr.]
		FROM HMOPROD_PlanData.dbo.authservicereason AS asr
			JOIN HMOPROD_PlanData.dbo.reasongroupdtl AS rgd on asr.reasongroupdtlid = rgd.reasongroupdtlid
			JOIN HMOPROD_PlanData.dbo.authreason ar on rgd.reasoncode = ar.reasoncode
		WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ... AND ...
			AND ar.reasoncode IN ('308','343') 
		) -- CONCLUDE ...
		AS coc ON r.referralid = coc.referralid
			-- AND coc.[RANKis] = 1 -- OUTER APPLY (SELECT TOP 1 ... Alt.

		LEFT JOIN -- COC per eMAIL ON 20220516 SUBJECT:Field Name changes & RANGE rewrite - RE: DHCS Audit 2022 - Assignments BODY:We heard FROM the UM team in regards to the COC AND OON indicators AND what code to include for that. FROM:HINA ... was = '308' 
		( -- INITIATE ... 
		SELECT DISTINCT asr.referralid,asr.[sequence]
		,DENSE_RANK() OVER(PARTITION BY asr.referralid ORDER BY asr.[sequence]) AS [RANKis] -- RANK() ACCOUNT(s) FOR TIES + RETAINS SEQUENCE
		,ROW_NUMBER() OVER(PARTITION BY asr.referralid ORDER BY asr.[sequence]) AS [ROWis] -- RANK() ACCOUNT(s) FOR TIES + RETAINS SEQUENCE
		,ar.reasoncode AS [QNXT Reason Code OON (A= OUT OF NETWORK)]
		,ar.[description] AS [QNXT Reason Code OON (A= OUT OF NETWORK) Descr.]
		FROM HMOPROD_PlanData.dbo.authservicereason AS asr
			JOIN HMOPROD_PlanData.dbo.reasongroupdtl AS rgd on asr.reasongroupdtlid = rgd.reasongroupdtlid
			JOIN HMOPROD_PlanData.dbo.authreason AS ar on rgd.reasoncode = ar.reasoncode
		WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ... AND ...
			AND ar.reasoncode IN ('411','412','413','414','415','416') -- COC per eMAIL ON 20220516 SUBJECT:Field Name changes & RANGE rewrite - RE: DHCS Audit 2022 - Assignments BODY:We heard FROM the UM team in regards to the COC AND OON indicators AND what code to include for that. FROM:HINA ... was = '308' 
		) -- CONCLUDE ...
		AS oon ON r.referralid = oon.referralid
			-- AND oon.[RANKis] = 1 -- OUTER APPLY (SELECT TOP 1 ... Alt.
			-- AND oon.[ROWis] = 1 -- OUTER APPLY (SELECT TOP 1 ... Alt.
			
		LEFT JOIN INFORMATICS.dbo.[uvw_AUTHREFCLAIM] AS  Glembocki ON r.referralid = Glembocki.referralid -- 'Claude.ai v Perplexity.ai ...  'c.referralid OR cd.referralid = ref.authorizationid DISCOVERED ON 20150728 w Stefan Glembocki'
			AND r.authorizationid = Glembocki.authorizationid

WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ... AND ...
	-- AND r.referfrom IN ('313124') -- 'EYECARE OF SAN DIEGO/Provider ID: 313124
		-- OR r.referto IN ('313124') -- 'EYECARE OF SAN DIEGO/Provider ID: 313124

	-- AND ac.codeid LIKE '%AUTO%' -- Please include only auto-auths from this universe. (These are NOT considered authorizations). You may identify auto auth with the following template path. Auth Category: Outpatient, Subcategory: Outpatient, Template: Online Auth
	 
	-- AND r.authorizationid IN ('1581726','1841622','1865454')

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
-- SELECT DISTINCT ' ' AS 'CHECK 1st',
FROM #AUTHRFI AS r
	JOIN -- ISON ON Dx, PROC + REV ...
	( -- INITIATE ...	
	SELECT DISTINCT r.authorizationid,ad.referralid,UPPER(LTRIM(RTRIM(ISNULL(ad.diagcode,'')))) AS [Diagnosis code],LTRIM(RTRIM(ad.diagqualifier)) AS [Diagnosis Category]
	,[Diagnosis codes Descr] = UPPER(LTRIM(RTRIM(ISNULL(dc.description,'')))),sequence
	-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
	-- SELECT DISTINCT ' ' AS 'CHECK 1st'
	FROM HMOPROD_PLANDATA.dbo.referral AS r
		JOIN HMOPROD_PLANDATA.dbo.authdiag AS ad ON r.referralid = ad.referralid
		JOIN HMOPROD_PLANDATA.dbo.diagcode AS dc ON ad.diagcode = dc.codeid
	WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ... AND ...
		AND UPPER(LTRIM(RTRIM(ISNULL(ad.diagcode,'')))) != '' -- NO NOT NEGATIVE <> != 
		AND sequence = 1 -- PRIMARY DIAGNOSIS
		) -- CONCLUDE ...
		AS rdiag ON r.referralid = rdiag.referralid

UPDATE #AUTHRFI
SET [CPT Procedure code]  = rcpt.[CPT Procedure code]
,[CPT Procedure code Description] = rcpt.[CPT Procedure code Description]
,[requested_units] = rcpt.[requested_units]
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st',
FROM #AUTHRFI AS r
	JOIN 
	( -- INITIATE ...	
	SELECT r.authorizationid,a.referralid,LTRIM(RTRIM(a.codeid)) AS [CPT Procedure code]
	,[CPT Procedure code Description] = UPPER(LTRIM(RTRIM(ISNULL(CAST(procd.description AS varchar(255)),''))))
	,SUM(a.totalunits) AS [requested_units]
	-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
	-- SELECT DISTINCT ' ' AS 'CHECK 1st'
	FROM HMOPROD_PLANDATA.dbo.referral AS r
		JOIN HMOPROD_PLANDATA.dbo.authservice AS a ON r.referralid = a.referralid
		JOIN HMOPROD_PLANDATA.dbo.svccode AS  procd  ON a.codeid = procd.codeid
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
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st',
FROM #AUTHRFI AS r
	JOIN 
	( -- INITIATE ...	
	SELECT r.authorizationid,a.referralid,UPPER(LTRIM(RTRIM(ISNULL(a.codeid,'')))) AS [Rev code]
	,[Rev code Description] = UPPER(LTRIM(RTRIM(ISNULL(rev.description,''))))
	,SUM(a.totalunits) AS [requested_units]
	-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
	-- SELECT DISTINCT ' ' AS 'CHECK 1st'
	FROM HMOPROD_PLANDATA.dbo.referral AS r
		JOIN HMOPROD_PLANDATA.dbo.authservice AS a ON r.referralid = a.referralid
		JOIN HMOPROD_PLANDATA.dbo.revcode AS rev ON CASE
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

--------------------------------------------------------------------------------------------------------------------
	-- Error Trapping: Check If Permanent Table(s) Already Exist(s) And Drop If Applicable --
--------------------------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS #authmodified -- SQL Server 2016 and later -- DYNAMIC tmp OR STATIC [TABLE] #TableName is a local temporary table visible only in the current session; #TableName is a GLOBAL temporary table visible to all sessions IN ('TempDB')

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
FROM HMOPROD_PLANDATA.dbo.qattribute AS q
	JOIN HMOPROD_PLANDATA.dbo.referralattribute AS attrib ON q.attributeid = attrib.attributeid
WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ... AND ...
	AND UPPER(LTRIM(RTRIM(ISNULL(q.description,'')))) LIKE '%MODIFIED%' -- C001: UPDATE per eMAIL FROM MS ERICA ON 20240202 RELATED TO RESULTING AUDIT CAP (CORRECTION ACTION PLAN) ... Hi Phil, We need your assistance to comply with our 2023 DHCS CAP 1.2.1 response. Attached, is a copy of the report my team receives monthly for our internal audit review (link also included below). Index of \\chg_cifs01\Shared\HCS2017\HCS Audit - SARAG Reports\ Request: Please label any case with a ‘MODIFIED’ attribute in QNXT, UM Record, Misc. tab, AS ‘Modified’ for Column M (Request Determination) on this report. NOTe, will be zero identified for now, AS this is a new process.
	-- AND CAST(attrib.effdate AS date) BETWEEN @ClockStart AND @ClockStop

UPDATE #AUTHRFI
SET [Modified] = 'Y'
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM #AUTHRFI AS ar
	JOIN #authmodified AS attr ON ar.referralid = attr.referralid

		-- SELECT ' ' AS 'SAMPLE',* FROM #authmodified WHERE referralid IN ('4416355') -- authorizationid IN ('3354410')







--------------------------------------------------------------------------------------------------------------------
	-- Error Trapping: Check If Permanent Table(s) Already Exist(s) And Drop If Applicable --
--------------------------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS #authextension -- SQL Server 2016 and later -- DYNAMIC tmp OR STATIC [TABLE] #TableName is a local temporary table visible only in the current session; #TableName is a GLOBAL temporary table visible to all sessions IN ('TempDB')

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
FROM HMOPROD_PLANDATA.dbo.qattribute AS q
	JOIN HMOPROD_PLANDATA.dbo.referralattribute AS attrib ON q.attributeid = attrib.attributeid
WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ... AND ...
	AND UPPER(LTRIM(RTRIM(ISNULL(q.description,'')))) LIKE '%EXTEN%LETTER%'
	-- AND CAST(attrib.effdate AS date) BETWEEN @ClockStart AND @ClockStop

UPDATE #AUTHRFI
SET [Extended] = 'Y'
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM #AUTHRFI AS ar
	JOIN #authextension AS attr ON ar.referralid = attr.referralid

		-- SELECT ' ' AS 'SAMPLE',* FROM #authextension WHERE referralid IN ('4416355') -- authorizationid IN ('3354410')







--------------------------------------------------------------------------------------------------------------------
	-- Error Trapping: Check If Permanent Table(s) Already Exist(s) And Drop If Applicable --
--------------------------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS #authnotification -- SQL Server 2016 and later -- DYNAMIC tmp OR STATIC [TABLE] #TableName is a local temporary table visible only in the current session; #TableName is a GLOBAL temporary table visible to all sessions IN ('TempDB')

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
FROM HMOPROD_PLANDATA.dbo.qattribute AS q
	JOIN HMOPROD_PLANDATA.dbo.referralattribute AS attrib ON q.attributeid = attrib.attributeid
WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ... AND ...
	AND UPPER(LTRIM(RTRIM(ISNULL(q.description,'')))) LIKE '%AUTH%NOTIFI%LETT%SENT%'
	-- AND CAST(attrib.effdate AS date) BETWEEN @ClockStart AND @ClockStop

UPDATE #AUTHRFI
SET [Attribute Date /Time] = TRY_CONVERT(datetime,attr.[ATTRIB_DATETIME])
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM #AUTHRFI AS ar
	JOIN #authnotification AS attr ON ar.referralid = attr.referralid

		-- SELECT ' ' AS 'SAMPLE',* FROM #authnotification WHERE referralid IN ('4416355') -- authorizationid IN ('3354410')







--------------------------------------------------------------------------------------------------------------------
	-- Error Trapping: Check If Permanent Table(s) Already Exist(s) And Drop If Applicable --
--------------------------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS #auththreshold -- SQL Server 2016 and later -- DYNAMIC tmp OR STATIC [TABLE] #TableName is a local temporary table visible only in the current session; #TableName is a GLOBAL temporary table visible to all sessions IN ('TempDB')

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
FROM HMOPROD_PLANDATA.dbo.qattribute AS q
	JOIN HMOPROD_PLANDATA.dbo.referralattribute AS attrib ON q.attributeid = attrib.attributeid
WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ... AND ...
	AND UPPER(LTRIM(RTRIM(ISNULL(q.description,'')))) LIKE '%THRESH%SENT%'
	-- AND CAST(attrib.effdate AS date) BETWEEN @ClockStart AND @ClockStop

/* UPDATE #AUTHRFI
SET [Attribute Date /Time] = TRY_CONVERT(datetime,attr.[ATTRIB_DATETIME])
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
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
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM #AUTHRFI AS ar

UPDATE #AUTHRFI
SET [TAT] = CASE 
WHEN ar.Units = 'Hours'
THEN ISNULL(tath.[TAT],0)
WHEN ar.Units = 'Business Days'	
THEN ISNULL(tatwd.[TAT],0)
ELSE DATEDIFF(day,ar.ClockStart,ar.ClockStop)
END -- 9.	TAT (Urgent requests 72 hours from Receipt to Seen date & time) (Routine requests 5 working days from Receipt to Seen date & time)
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
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
-- SELECT TOP 10 estatus.[STATUS INDICATOR],su.* -- CHECK 1st
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
 FROM #AUTHRFI AS su
	JOIN 
	( -- INITIATE ...
	SELECT DISTINCT es.primarystatus AS [Plan Position Status],ek.carriermemid,ek.memid,es.effdate,es.termdate,es.primarystatus AS [STATUS INDICATOR],ec.ratecode,pg.programid,bp.planid,bp.description,ek.enrollid,r.referralid
	-- SELECT TOP 10 estatus.[STATUS INDICATOR],su.* -- CHECK 1st
	-- SELECT DISTINCT ' ' AS 'CHECK 1st'
	FROM HMOPROD_PLANDATA.dbo.enrollkeys AS ek
		JOIN HMOPROD_PLANDATA.dbo.member AS mem ON ek.memid = mem.memid
			LEFT JOIN HMOPROD_PLANDATA.dbo.benefitplan AS bp ON ek.programid = bp.programid
		JOIN HMOPROD_PLANDATA.dbo.program AS pg ON ek.programid = pg.programid
		JOIN HMOPROD_PLANDATA.dbo.entity AS ent ON mem.entityid = ent.entid
		JOIN HMOPROD_PlanData.dbo.enrollstatus AS es ON ek.enrollid = es.enrollid		
		JOIN HMOPROD_PLANDATA.dbo.enrollcoverage AS ec ON ek.enrollid = ec.enrollid
		JOIN HMOPROD_PLANDATA.dbo.referral AS r ON ek.memid = r.memid
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

		/* SELECT 'TEST JOIN ON [referralid] ... c.referralid  OR cd.referralid = ref.authorizationid DISCOVERED ON 20150728 w Stefan Glembocki' AS [NOTE(S)],* 
		FROM 
		-- JOIN 
		( -- INTIATE ...
		SELECT DISTINCT c.claimid
		-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
		-- SELECT DISTINCT ' ' AS 'CHECK 1st'
		-- SELECT DISTINCT ' ' AS 'CHECK 1st',dischargedate FROM HMOPROD_PLANDATA.dbo.claim
		-- SELECT DISTINCT ' ' AS 'CHECK 1st',dischargedate FROM HMOPROD_PLANDATA.dbo.referral
		FROM HMOPROD_PLANDATA.dbo.claim AS c
			JOIN 
			( -- INITIATE ...
			SELECT DISTINCT 'c.referralid  OR cd.referralid = ref.authorizationid DISCOVERED ON 20150728 w Stefan Glembocki' AS [NOTE(S)],authorizationid,referralid FROM #AUTHRFI
			) -- CONCLUDE ...
			AS auth ON c.referralid = auth.referralid

		UNION 
		SELECT DISTINCT cd.claimid
		-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
		-- SELECT DISTINCT ' ' AS 'CHECK 1st'
		-- SELECT DISTINCT ' ' AS 'CHECK 1st',dischargedate FROM HMOPROD_PLANDATA.dbo.claim
		-- SELECT DISTINCT ' ' AS 'CHECK 1st',dischargedate FROM HMOPROD_PLANDATA.dbo.referral
		FROM HMOPROD_PLANDATA.dbo.claimdetail AS cd 
			JOIN 
			( -- INITIATE ...
			SELECT DISTINCT 'c.referralid  OR cd.referralid = ref.authorizationid DISCOVERED ON 20150728 w Stefan Glembocki' AS [NOTE(S)],authorizationid,referralid FROM #AUTHRFI
			) -- CONCLUDE ...
			AS auth ON cd.referralid = auth.referralid
		) -- CONCLUDE ...
		AS claimiso */







-- ==================================================================
	-- PAR STAT STREAMLINE - ELIMINATE DUP(s) --
-- ==================================================================
-----------------------------------------------------------------------------------------------------------------------------
	--Error Trapping: Check If Permanent Table(s) Already Exist(s) And Drop If Applicable--
-----------------------------------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS #CURRENTCONTRACT -- SQL Server 2016 and later -- DYNAMIC tmp OR STATIC [TABLE] #TableName is a local temporary table visible only in the current session; ##TableName is a GLOBAL temporary table visible to all sessions IN ('TempDB')
 
SELECT DISTINCT prov.provid+' '+UPPER(LTRIM(RTRIM(ISNULL(pspe.spectype,'')))) AS [DupID]
,RANK() OVER(PARTITION BY prov.provid ORDER BY ci.contracted DESC,spe.description) AS [RANKis]
,ci.contracted -- PAR STATUS!!!
,'N' AS pcp --,aff.pcp --DETERMINE WHETHER PROVIDER IS A PCP (Primary Care Physician)
,UPPER(LTRIM(RTRIM(ISNULL(pspe.spectype,'')))) AS [Specialty Status]
,UPPER(LTRIM(RTRIM(ISNULL(spe.specialtycode,'')))) AS SPECcode
,UPPER(LTRIM(RTRIM(ISNULL(spe.description,'')))) AS SPECdescr,pspe.spectype
,prov.provid,prov.fedid,prov.NPI,prov.ExternalID -- AS [SEQ_PROV_ID]
,PROVNM = UPPER(LTRIM(RTRIM(ISNULL(prov.fullname,'')))) -- PROVIDER NAME
,ent.enttype,ent.lastname,ent.firstname,ent.middlename,ent.entname
,PROVcode = UPPER(LTRIM(RTRIM(ISNULL(pt.provtype,'')))) -- PROVTYPE CODE
,PROVtype = UPPER(LTRIM(RTRIM(ISNULL(pt.[description],'')))) -- PROVTYPE Descr.
,PROVclass = UPPER(LTRIM(RTRIM(ISNULL(pt.provclass,'')))) -- PROVTYPE Classification
,PROVaddr1 = UPPER(LTRIM(RTRIM(ISNULL(ent.phyaddr1,''))))
,PROVaddr2 = UPPER(LTRIM(RTRIM(ISNULL(ent.phyaddr2,''))))
,PROVcity = UPPER(LTRIM(RTRIM(ISNULL(ent.phycity,''))))
,PROVstate = SUBSTRING(UPPER(LTRIM(RTRIM(ISNULL(ent.phystate,'')))),1,2)
,PROVcounty = UPPER(LTRIM(RTRIM(ISNULL(ent.phycounty,'')))) -- •	County, if Plan is multi-county
,PROVzip = CASE
WHEN SUBSTRING(LTRIM(RTRIM(ent.phyzip)),1,1) = '0'
THEN '0'+ SUBSTRING(LTRIM(RTRIM(ent.phyzip)),2,4)
WHEN SUBSTRING(LTRIM(RTRIM(ent.phyzip)),1,1) = '00'
THEN '00'+ SUBSTRING(LTRIM(RTRIM(ent.phyzip)),3,3)
ELSE  SUBSTRING(LTRIM(RTRIM(ent.phyzip)),1,5) 
END
,PROVphone = CASE
WHEN LTRIM(RTRIM(ent.phone)) = ''
THEN SUBSTRING(REPLACE(LTRIM(RTRIM(ent.emerphone)),'-',''),1,10)
ELSE SUBSTRING(REPLACE(LTRIM(RTRIM(ent.phone)),'-',''),1,10)
END
,PROVmobile = CASE
WHEN LTRIM(RTRIM(ent.mobilephone)) = ''
THEN SUBSTRING(REPLACE(LTRIM(RTRIM(ent.secphone)),'-',''),1,10)
ELSE SUBSTRING(REPLACE(LTRIM(RTRIM(ent.mobilephone)),'-',''),1,10)
END
,PROVemail = LTRIM(RTRIM(ent.email))
-- ,Lang = LTRIM(RTRIM(lang.description))
-- ,evips.REGION AS [PCP REGION]
INTO #CURRENTCONTRACT
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM HMOPROD_PLANDATA.dbo.provider AS prov
	JOIN HMOPROD_PLANDATA.dbo.affiliation AS aff ON prov.provid = aff.provid --claim RELATIONSHIP provid AS PROVIDER AND affiateid AS PAYTO aka VENDOR
	JOIN HMOPROD_PLANDATA.dbo.contractinfo AS ci ON aff.affiliationid = ci.affiliationid
	JOIN HMOPROD_PLANDATA.dbo.contract AS c ON ci.contractid = c.contractid --QUPD
	JOIN HMOPROD_PLANDATA.dbo.program AS prog ON ci.programid = prog.programid
	JOIN HMOPROD_PLANDATA.dbo.entity AS ent ON prov.entityid = ent.entid

		-- LEFT JOIN HMOPROD_PLANDATA.dbo.provlanguage AS plang ON prov.provid = plang.provid
		-- LEFT JOIN HMOPROD_PLANDATA.dbo.language AS lang ON plang.languageid = lang.languageid
		LEFT JOIN HMOPROD_PLANDATA.dbo.providertype AS pt ON prov.provtype = pt.provtype
		LEFT JOIN HMOPROD_PLANDATA.dbo.provspecialty AS pspe ON prov.provid = pspe.provid
			AND UPPER(LTRIM(RTRIM(ISNULL(pspe.spectype,'PRIMARY')))) LIKE 'PRIMARY' -- PRIMARY SPECIALTY ISO ...
		LEFT JOIN HMOPROD_PLANDATA.dbo.specialty AS spe ON pspe.specialtycode = spe.specialtycode

WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ... AND ...
	AND CAST(ci.termdate AS date) = CAST('12/31/2078' AS date) -- CURRENTLY OPEN CONTRACT per em MO & CA 20150903
	AND UPPER(LTRIM(RTRIM(ISNULL(c.description,'')))) NOT LIKE '%IPA%PPCAM%' 
	AND UPPER(LTRIM(RTRIM(ISNULL(c.description,'')))) NOT LIKE '%ENCOUNT%'

DELETE
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st',
FROM #CURRENTCONTRACT
WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ...
	AND [DupID] IN
	( -- INITIATE ...
	SELECT [DupID]
	-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
	-- SELECT DISTINCT ' ' AS 'CHECK 1st',
	FROM #CURRENTCONTRACT AS dup
	GROUP BY [DupID] -- Duplication Driver 
	HAVING COUNT(1)>1 -- HAVING clause RESERVED for AGGREGATE(s) ... HAVING SUM(PAID_NET_AMT) != 0
	) -- CONCLUDE ...
	-- AND UPPER(LTRIM(RTRIM(ISNULL(contracted,'')))) = 'N'
	AND [RANKis] != 1 -- NO NOT NEGATIVE <> != TO ELIMINATE DUP(S)

UPDATE #CURRENTCONTRACT
SET pcp = LTRIM(RTRIM(aff.pcp)) --aff.pcp --DETERMINE WHETHER PROVIDER IS A PCP (Primary Care Physician)
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st',aff.affiltype 
FROM #CURRENTCONTRACT AS cc
	JOIN HMOPROD_PLANDATA.dbo.affiliation AS aff ON cc.provid = aff.provid
WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ...
	AND LTRIM(RTRIM(cc.SPECcode)) IN ('FAM','GNP','INM','OBG','PED') --RDT / Mercer suggested TYPE(s) '...Pediatrics, OB/GYN, Family Practice, General Practice, Internal Medicine, or Other. If provider specializes in more than one field, enter additional Specialty Records (rows) for each specialty...'
	AND UPPER(LTRIM(RTRIM(ISNULL(aff.pcp,'')))) = 'Y'
	-- AND LTRIM(RTRIM(cc.SPECcode)) IN ('FAM','GNP','INM','OBG','PED') --RDT / Mercer suggested TYPE(s)
	-- AND LTRIM(RTRIM(cc.PROVtype)) = 'PHYSICIAN'
	AND UPPER(LTRIM(RTRIM(ISNULL(cc.contracted,'')))) = 'Y'







-- ======================================================================
	-- DESPITE SYSTEM (QNXT) EVIDENCE manipulate dataset --
-- ======================================================================	
UPDATE #CURRENTCONTRACT
SET contracted = 'Y'
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM #CURRENTCONTRACT AS cc
WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ...
	AND UPPER(LTRIM(RTRIM(ISNULL(provid,'')))) IN ('200734','2029') --,'3889')  --'200734' ('%HANGER%PROSTHE%' ) NOT A SINGLE Y rec PRESENT, '2029' ('%GIRARD%ORTHO%') NOT A SINGLE Y rec PRESENT

UPDATE #CURRENTCONTRACT
SET contracted = 'N'
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM #CURRENTCONTRACT AS cc
WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ...
	AND UPPER(LTRIM(RTRIM(ISNULL(provid,'')))) IN ('154459','4770') --Potential suspended provider alert [secure] FROM Ms. A. WARREN ON 20151124 Samuel Gerson	1881843431	Inactive since 5/14/14 due to license probation.  Termed in QNXT. AND Martha Capizzi	1265545073	Inactive since 5/7/13.  License surrendered.  Termed in QNXT.







-- =====================================================================
	-- contracted PROVIDER(s) + QUPD TRUST but VERIFY contracted status ci.contracted --
-- =====================================================================
UPDATE #AUTHRFI
SET [contractedVerification] = cc.[contracted] -- C002: QNXT FALSE PAR STATUS LOGIC APPLIED PER DISCUSSION WITH() SIR PHIL ON 20230223 
-- SELECT TOP 10 ' ' AS 'CHECK 1st',[QNXT Reason Code (A= COC Reporting: Continuity of Care)],Units,TAT,*
-- SELECT DISTINCT ' ' AS 'CHECK 1st',HeaderStatus,LINE_OF_BUSINESS
FROM #AUTHRFI AS ar
	JOIN #CURRENTCONTRACT AS cc ON ar.referfrom = cc.provid
WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ...

/* x FIVE (5) COMPONENT(s) FIVE (5) table(s) - claim, claimdetail,provider, contractinfo, affiliation */
/* UPDATE #AUTHRFI
SET [contractedVerification] = LTRIM(RTRIM(ci.contracted))
-- SELECT TOP 10 ' ' AS 'CHECK 1st',aff.provid,prov.fullname,ci.contracted,ci.termdate,ci.effdate,ci.lastupdate,c.[description] AS [CONTRACT_DESCR],bp.[description] AS [BENEFIT PLAN DESCR],prog.[description] AS [PROG DESCR],*,ci.contracted,sip.ProviderParStatus,ci.*,sip.*
-- SELECT DISTINCT ' ' AS 'CHECK 1st',contracted,iscapitated FROM HMOPROD_PLANDATA.dbo.contractinfo
FROM #AUTHRFI AS ar
	JOIN HMOPROD_PLANDATA.dbo.contractinfo AS ci ON ar.programid = ci.programid -- ci key#01 smh.programid,
		AND ar.paytoaffiliationid = ci.affiliationid -- ci key#02 a.affiliationid, -- AFFILIATIONID (REMINDER: within memberpcp AFFILIATIONID is the relationship between PCP + SITE whereas PAYTOAFFILID within memberpcp represents the relationship between PCP + IPA FINALLY within CLAIM table a.provid = PROVIDER a.affiliateid = PAYTO aka VENDOR	
		AND ar.DefaultContractId = ci.contractid -- ci key#03 see ci.key#04 in WHERE CLAUSE cd.contractid,
		-- AND ar.[NETWORK FLAG] = ci.networkid-- ci key#05 ON clm.contractNetworkId LTRIM(RTRIM(clm.contractnetworkid)) AS [NETWORK FLAG], --DEPRECATED for PROVIDER_PAR_STAT + contractedVerification already present AND to avoid confusion w NetworkID -- ??? (see  INFORMATICS2.dbo.[SHELLprov] was the PARTICIPARTION_FLAG FROM PROVC in D950 OR see ci.contractnetworkid 20140410)
WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ...
	AND CAST(ar.[UtcReceiptDate] AS date) BETWEEN CAST(ci.effdate AS date) AND CAST(ci.termdate AS date) -- ci key#04 */







-- ============================================================= 
	-- SUMMARY / SUBTOTAL() ROLLUP v. CUBE --
-- =============================================================
SELECT ' ' AS 'AUTH SUMMARY',[RANGE NOTE(s)],status,COUNT(DISTINCT(referralid)) AS [Referrals],COUNT(DISTINCT(authorizationid)) AS [Auths],COUNT(DISTINCT(memid)) AS [Unique Members] FROM #AUTHRFI GROUP BY [RANGE NOTE(s)],status

SELECT ' ' AS 'OPEN AUTH SUMMARY',[RANGE NOTE(s)],status,COUNT(DISTINCT(referralid)) AS [Referrals],COUNT(DISTINCT(authorizationid)) AS [Auths],COUNT(DISTINCT(memid)) AS [Unique Members] FROM #AUTHRFI WHERE [CLAIM ASSOCIATED WITH AUTH] IS NULL AND TRY_CONVERT(date,termdate) >= TRY_CONVERT(date,GETDATE()) GROUP BY [RANGE NOTE(s)],status

SELECT ' ' AS 'CLOSED AUTH SUMMARY',[RANGE NOTE(s)],status,COUNT(DISTINCT(referralid)) AS [Referrals],COUNT(DISTINCT(authorizationid)) AS [Auths],COUNT(DISTINCT(memid)) AS [Unique Members] FROM #AUTHRFI WHERE [CLAIM ASSOCIATED WITH AUTH] IS NOT NULL GROUP BY [RANGE NOTE(s)],status

SELECT DISTINCT ' ' AS 'QA TEMPLATE TYPE OPTION(S)',[AuthRefType (Template)],servicecode,status FROM #AUTHRFI

SELECT ' ' AS 'QA DATE RANGE + [LOB]',LINE_OF_BUSINESS
,MIN (TRY_CONVERT(date,effdate)) AS [RANGE MIN]
,MAX(TRY_CONVERT(date,termdate)) AS [RANGE MAX]
,COUNT(DISTINCT(referralid)) AS [AUTH(S)]
-- SELECT TOP 10 * -- CHECK 1st
-- SELECT DISTINCT -- CHECK 1st
FROM #AUTHRFI
GROUP BY LINE_OF_BUSINESS

SELECT ' ' AS 'QA DATE RANGE + [servicecode]',servicecode
,MIN (TRY_CONVERT(date,effdate)) AS [RANGE MIN]
,MAX(TRY_CONVERT(date,termdate)) AS [RANGE MAX]
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
