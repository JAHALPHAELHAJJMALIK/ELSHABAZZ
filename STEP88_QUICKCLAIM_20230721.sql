-- =====================================================================
	-- DYNAMIC() v. STATIC() DECLARE(s) FOR [CLAIM LISTING REFINEMENT] --
-- =====================================================================
DECLARE @SearchString AS varchar(MAX) -- see CREATE TABLE #employee
DECLARE @lag AS int
DECLARE @lagyrs AS int
DECLARE @prevlagyrs AS int
DECLARE @lagdays AS int
DECLARE @lagmonths AS int
DECLARE @when AS datetime
DECLARE @footnotedt AS varchar(25)
DECLARE @StartDT AS datetime
DECLARE @EndDT AS datetime
DECLARE @Start AS datetime
DECLARE @End AS datetime
DECLARE @rangeprefix AS varchar(100)
-- DECLARE @rangemiddle AS varchar(100)
DECLARE @DYNAMICLIKE AS varchar(MAX) -- LIKE '%[@PARAMETER]%'
DECLARE @LOB AS varchar(MAX) -- LIKE '%[@PARAMETER]%'
DECLARE @memid AS varchar(25)
DECLARE @dosSTART AS datetime
DECLARE @dosEND AS datetime
DECLARE @SYSisB AS varchar(4)
DECLARE @pos AS varchar(2) -- SELECT 'TELEHEALTH ("02") ANALYSIS DUE TO COVID - 19' AS [NOTE(S)],* FROM INFORMATICS2.dbo.SHELLpos

SET @SearchString = 'see "STEP88 DYNAMIC...sql"'
/* SET @SearchString = ''''+'%'+SUBSTRING(CONVERT(varchar(25),CAST(CAST(DATEPART(mm,DATEADD(month,@lag,CAST(GETDATE() AS datetime))) AS varchar(2))+'/01/'+CAST(DATEPART(yyyy,DATEADD(month,@lag,CAST(GETDATE() AS datetime))) AS varchar(4)) AS datetime),112),1,6)+'%'+'''' --'201803%' */
-- SET @SearchString = '%'+SUBSTRING(CONVERT(varchar(25),CAST(CAST(DATEPART(mm,DATEADD(month,@lag,CAST(GETDATE() AS datetime))) AS varchar(2))+'/01/'+CAST(DATEPART(yyyy,DATEADD(month,@lag,CAST(GETDATE() AS datetime))) AS varchar(4)) AS datetime),112),1,6)+'%' --'201803%'
SET @lag = -28 --IN MONTH(s) UPDATE() +-
SET @lagyrs = 1 --IN YEAR(s) UPDATE() +-
SET @prevlagyrs = -1 --IN YEAR(s) UPDATE() +-
SET @lagdays = -1 --IN DAY(s) UPDATE() +-
SET @lagmonths = 12 --IN MONTH(s) UPDATE() +-
SET @when = NULL
SET @footnotedt = 'Last Updated: ' --'Last Updated: 01/27/2017' --PRESET TO NEXT FRIDAY
SET @StartDT = CAST(CAST(DATEPART(mm,DATEADD(month,@lag,CAST(GETDATE() AS datetime))) AS varchar(2))+'/01/'+CAST(DATEPART(yyyy,DATEADD(month,@lag,CAST(GETDATE() AS datetime))) AS varchar(4)) AS datetime)
SET @EndDT = DATEADD(day,@lagdays,DATEADD(month,@lagmonths,@StartDt))
SET @Start  = @StartDT
SET @End = @EndDT
SET @rangeprefix  = 'DATE(s) of SERVICE BETWEEN ' --'RECEIVED (aka CLEANDATE) BETWEEN ' --'CHECK DATE(s) BETWEEN ' --'POST DATE(s) BETWEEN ' '--ALL TIME' AS [RANGE]
-- SET @rangemiddle = ' AND '
SET @DYNAMICLIKE = '%'+@SearchString+'%' -- LIKE '%[@PARAMETER]%'
SET @LOB  = '%%%' -- LIKE '%[@PARAMETER]%'
SET @memid = CAST(NULL AS varchar(25)) -- ISO ON SPECIFIC MEMBER
SET @dosSTART = @StartDT
SET @dosEND = @EndDT
SET @SYSisB = 'QNXT'
SET @pos = '02' -- SELECT 'TELEHEALTH ("02") ANALYSIS DUE TO COVID - 19' AS [NOTE(S)],* FROM INFORMATICS2.dbo.SHELLpos

		SELECT TOP 1 planid,programid,BenefitPlanDescr,ProgramDescr,entityid,'BETWEEN '+CAST(CAST(@StartDT AS date) AS varchar(MAX))+' AND '+CAST(CAST(@EndDT AS date) AS varchar(MAX)) AS [RANGE NOTE(s)],@StartDT AS [STARTDT FIELD],@EndDT AS [ENDDT FIELD]
		FROM INFORMATICS2.dbo.[SHELLmasterheader]
		WHERE ISNULL(planid,'') LIKE @LOB







	-- BillType SHELL--
--------------------------------------------------------------------------------------------------------------------
	-- Error Trapping: Check If Permanent Table(s) Already Exist(s) And Drop If Applicable --
--------------------------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS #SHELLbilltype -- SQL Server 2016 and later -- DYNAMIC tmp OR STATIC [TABLE] #INFORMATICS.dbo.REINSURANCE_IP is a local temporary table visible only in the current session; ##INFORMATICS.dbo.REINSURANCE_IP is a GLOBAL temporary table visible to all sessions IN ('TempDB')

SELECT DISTINCT 
LTRIM(RTRIM(bt.facilitycode))+LTRIM(RTRIM(bc.billclasscode))+LTRIM(RTRIM(freq.frequencycode)) AS QNXTbilltype,
LTRIM(RTRIM(bc.description)) +' '+LTRIM(RTRIM(freq.description)) AS [BillTypeDescr]
,LTRIM(RTRIM(bt.facilitycode)) AS FacilityDigit --1st DIGIT: TYPE of FACILITY
,LTRIM(RTRIM(bc.billclasscode)) AS BillCxDigit --2nd DIGIT: BILL CLASSIFICATION
,LTRIM(RTRIM(freq.frequencycode)) AS FreqDigit --3rd DIGIT: FREQUENCY
INTO #SHELLbilltype
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM HMOPROD_PLANDATA.dbo.billtype AS bt
	JOIN HMOPROD_PLANDATA.dbo.billclass AS bc ON bt.billclasscode = bc.billclasscode
		AND bt.facilitycode = bc.facilitycode
	JOIN HMOPROD_PLANDATA.dbo.frequency AS freq ON bt.frequencycode = freq.frequencycode







	-- Claim Type Identification--
--------------------------------------------------------------------------------------------------------------------
	-- Error Trapping: Check If Permanent Table(s) Already Exist(s) And Drop If Applicable --
--------------------------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS #SHELLclmtype -- SQL Server 2016 and later -- DYNAMIC tmp OR STATIC [TABLE] #INFORMATICS.dbo.REINSURANCE_IP is a local temporary table visible only in the current session; ##INFORMATICS.dbo.REINSURANCE_IP is a GLOBAL temporary table visible to all sessions IN ('TempDB')

SELECT DISTINCT formtype,
CASE 
WHEN formtype LIKE '%UB%' --INCLM
THEN 'FACILITY' 
WHEN formtype LIKE '%1500%' --PSCLM
THEN 'PROFESSIONAL'
ELSE 'Erroneous'
END AS ClmType
INTO #SHELLclmtype
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM HMOPROD_PLANDATA.dbo.claim AS c







--------------------------------------------------------------------------------------------------------------------
	-- Error Trapping: Check If Permanent Table(s) Already Exist(s) And Drop If Applicable --
--------------------------------------------------------------------------------------------------------------------
/* DROP TABLE IF EXISTS #CxCOS -- SQL Server 2016 and later -- DYNAMIC tmp OR STATIC [TABLE] #INFORMATICS.dbo.REINSURANCE_IP is a local temporary table visible only in the current session; ##INFORMATICS.dbo.REINSURANCE_IP is a GLOBAL temporary table visible to all sessions IN ('TempDB')
 
SELECT DISTINCT claimid
INTO #CxCOS
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st',sbt.*,ct.*
FROM HMOPROD_PLANDATA.dbo.claim AS clm
	JOIN HMOPROD_PLANDATA.dbo.claimdetail AS cd ON clm.claimid = cd.claimid
	JOIN #SHELLbilltype AS sbt ON (LTRIM(RTRIM(clm.facilitycode))+LTRIM(RTRIM(clm.billclasscode))+LTRIM(RTRIM(clm.frequencycode))) = sbt.QNXTbilltype
	JOIN #SHELLclmtype AS ct ON clm.formtype = ct.formtype
-- WHERE SUBSTRING(UPPER(LTRIM(RTRIM(ISNULL(cd.servcode,'')))),1,5) IN () -- PROCEDURE_CODE / current procedural terminology (CPT)
WHERE 
( -- INITIATE ...
sbt.QNXTbilltype LIKE '11%' -- HOSPITAL IP
	OR sbt.QNXTbilltype LIKE '12%' -- Hospital - Hospital Based or Inpatient
	) -- CONCLUDE ...
	AND ct.[ClmType] = 'FACILITY' -- WHEN formtype LIKE '%UB%' -- INCLM */







--------------------------------------------------------------------------------------------------------------------
	-- Error Trapping: Check If Permanent Table(s) Already Exist(s) And Drop If Applicable --
--------------------------------------------------------------------------------------------------------------------
/* DROP TABLE IF EXISTS #PaidClaims -- SQL Server 2016 and later -- DYNAMIC tmp OR STATIC [TABLE] #INFORMATICS.dbo.REINSURANCE_IP is a local temporary table visible only in the current session; ##INFORMATICS.dbo.REINSURANCE_IP is a GLOBAL temporary table visible to all sessions IN ('TempDB')
 
DECLARE @chkstrt AS datetime = '04/01/2013' --STATIC 04/01/2013 is the QNXT GO LIVE
DECLARE @chkend AS datetime = GETDATE() --STATIC ALL TIME!!!
DECLARE @payt AS nvarchar(88) = 'CAP'  -- WHERE NOT IN (...
DECLARE @stat AS nvarchar(88) = 'VOID'  -- WHERE NOT IN (...

SELECT DISTINCT UPPER(LTRIM(RTRIM(ISNULL(pv.claimid,'')))) AS SEQ_CLAIM_ID,pv.claimid
INTO #PaidClaims
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM HMOPROD_PLANDATA.dbo.paycheck AS pc
	JOIN HMOPROD_PLANDATA.dbo.checkhistory AS ch ON pc.checkhistoryid = ch.checkhistoryid
	JOIN HMOPROD_PLANDATA.dbo.payment AS pmt ON pc.paymentid = pmt.paymentid
	JOIN HMOPROD_PLANDATA.dbo.qfund AS qf ON pc.fundid = qf.fundid
	JOIN HMOPROD_PLANDATA.dbo.payvoucher AS pv ON pc.paymentid = pv.paymentid
WHERE CAST(pc.checkprintdate AS datetime) BETWEEN CAST(@chkstrt AS datetime) AND CAST(@chkend AS datetime)
	AND pmt.paytype NOT IN (@payt) --NOT 'CAP'
	AND pmt.[status] NOT IN (@stat) --NOT 'VOID'
	-- AND
	-- ( -- INITIATE ...
	-- pv.claimid IN ('19094E01064')
		-- OR  ch.checknbr IN ('179591','95445')
		-- ) -- CONCLUDE ...
GROUP BY UPPER(LTRIM(RTRIM(ISNULL(pv.claimid,'')))),pv.claimid
HAVING SUM((pv.amountpaid)-(pv.paydiscount)) <>0  --HAVING as AGGREGATE SYNTAX Fx aka ,SUM((pv.amountpaid)-(pv.paydiscount)) AS CHECKAMT --pv incorporates INTEREST amount(s) (For refund(s) see 'REFUND_WWCII_20130913.mdb') */







--------------------------------------------------------------------------------------------------------------------
	-- Error Trapping: Check If Permanent Table(s) Already Exist(s) And Drop If Applicable --
--------------------------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS #SETclaimrange -- SQL Server 2016 and later -- DYNAMIC tmp OR STATIC [TABLE] #TableName is a local temporary table visible only in the current session; ##TableName is a GLOBAL temporary table visible to all sessions IN ('TempDB')

-- EXEC [INFORMATICS].dbo.[spWCdate_calendarISO]; -- x SCHEMA() SELECT * FROM 'SERVERname'.'DATABASEname'.'SCHEMAname'.'OBJECTname' - FOUR (4) PART() SCHEMA() aka [SERVERname].[DATABASEname].[SCHEMAname].[OBJECTname] - see '[SQL13].[CHGAPP_PROD].dbo.[tblEDIDHCSType834]'

SELECT DISTINCT clm.claimid
INTO #SETclaimrange
-- SELECT TOP 10 ' ' AS 'CHECK 1st',* -- POTENTIAL TO DEVELOP [PER DIEM ...]
-- SELECT DISTINCT ' ' AS 'CHECK 1st'

FROM HMOPROD_PLANDATA.dbo.claim AS clm
	-- JOIN #PaidClaims AS pc ON clm.claimid = pc.claimid -- PAID CLAIM(S) ONLY!!!
	-- JOIN #CxCOS AS cx ON clm.claimid = cx.claimid -- COS (Category of Service) ISOLATION
WHERE TRY_CONVERT(date,clm.startdate) BETWEEN @Start AND @End -- by DOS
-- WHERE TRY_CONVERT(date,clm.cleandate) BETWEEN @Start AND @End -- by RECEIVED DATE
-- WHERE TRY_CONVERT(date,clm.paiddate) BETWEEN @Start AND @End -- by CHECK DATE
-- WHERE TRY_CONVERT(date,clm.adjuddate) BETWEEN @Start AND @End -- by POST DATE see DETERMRECON
-- WHERE TRY_CONVERT(date,clm.okpaydate) BETWEEN @Start AND @End -- CHANGED 20140613 per Burchfield Audit Finding(s) by POST DATE see DETERMRECON
-- WHERE TRY_CONVERT(date,clm.paiddate) <= CAST(@cutoffdt AS date)
-- WHERE clm.startdate BETWEEN DATEADD(YY,-3, @Start) AND @End -- 'ROLLING THREE (3) YEAR(S)'

FROM INFORMATICS.dbo.date_calendarISO AS dc,HMOPROD_PLANDATA.dbo.claim AS clm -- DO NOT NO NEGATIVE <> != COVER UP THE TE()
WHERE TRY_CONVERT(date,dc.calendar_date) BETWEEN @Start AND @End -- RINA(): APPLIED TO FIELD WITHIN TABLE TO BE UPDATED
	AND TRY_CONVERT(date,dc.calendar_date) BETWEEN TRY_CONVERT(date,clm.startdate) AND TRY_CONVERT(date,ISNULL(clm.Dischargedate,clm.enddate)) -- by ADMIT DISCHARGE RANGE
	
	AND c.startdate >= @StartDate
	AND c.startdate <= @EndDate
	
		-- SELECT * FROM INFORMATICS.dbo.date_calendarISO
		-- SELECT * FROM #SETclaimrange







--------------------------------------------------------------------------------------------------------------------
	-- Error Trapping: Check If Permanent Table(s) Already Exist(s) And Drop If Applicable --
--------------------------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS TABLENAME -- SQL Server 2016 and later -- DYNAMIC tmp OR STATIC [TABLE] #TableName is a local temporary table visible only in the current session; ##TableName is a GLOBAL temporary table visible to all sessions IN ('TempDB')

SELECT CAST(NULL AS nvarchar(MAX))AS [NOTE(s)],CAST(NULL AS nvarchar(MAX))AS [Cx],CAST(NULL AS nvarchar(MAX))AS [SubCx]
,'UTILIZATION BETWEEN '+CAST(CAST(@Start AS date) AS varchar(MAX))+' AND '+CAST(CAST(@End AS date) AS varchar(MAX)) AS [RANGE NOTE(s)]
-- ,CASE
-- WHEN LTRIM(RTRIM(cd.planid)) = 'QMXBP0782' --CL1 programid IS QMXHPQ0842
-- THEN 'CL1'
-- WHEN LTRIM(RTRIM(cd.planid)) = 'QMXBP0808'  --MCR programid IS QMXHPQ0843
-- THEN 'MCR'
-- WHEN LTRIM(RTRIM(cd.planid)) = 'QMXBP0822' --CMCmcare programid IS  QMXHPQ0847
-- THEN 'CMCmcare'
-- WHEN LTRIM(RTRIM(cd.planid)) = 'QMXBP0823' --CMCmcal programid IS  QMXHPQ0848
-- THEN 'CMCmcal'
-- WHEN LTRIM(RTRIM(cd.planid)) = 'BP0004'  --COB programid IS HP0002
-- THEN 'COB'
-- ELSE 'UNKNOWN'
-- END AS [LINE_OF_BUSINESS]
,bp.description AS [LINE_OF_BUSINESS],bp.planid,bp.programid
,a.affiliationid
,cd.contractid,contrdescr.[CONTRACT DESCRIPTION]
,cd.termid,clm.contractnetworkid AS [NETWORK FLAG]
,contractedVerification = CAST(NULL AS nvarchar(1)),capitationVerification = CAST(NULL AS nvarchar(1))
,UPPER(LTRIM(RTRIM(ISNULL(clm.[status],'')))) AS [HEADERstatus],UPPER(LTRIM(RTRIM(ISNULL(cd.[status],'')))) AS [DETAILstatus]
,cd.modcode,cd.modcode2,cd.modcode3,cd.modcode4,cd.modcode5
,UPPER(LTRIM(RTRIM(ISNULL(clm.claimid,''))))+UPPER(LTRIM(RTRIM(ISNULL(cd.claimline,'')))) AS [DupID]
,clm.controlnmb AS [Pat. Control No.]
,CAST(UPPER(LTRIM(RTRIM(ISNULL(clm.memid,'')))) AS varchar(MAX))+CAST(UPPER(LTRIM(RTRIM(ISNULL(TRY_CONVERT(date,clm.startdate),'')))) AS varchar(10))+CAST(UPPER(LTRIM(RTRIM(ISNULL(a.provid,'')))) AS varchar(MAX)) AS [AdmitID] -- 'Unique person, date of service, and provider = one visit' OR 'Unique person, date of service, and NDC = one script'
,CAST(UPPER(LTRIM(RTRIM(ISNULL(clm.memid,'')))) AS varchar(MAX))+CAST(UPPER(LTRIM(RTRIM(ISNULL(TRY_CONVERT(date,clm.startdate),'')))) AS varchar(10)) AS [Alt. AdmitID] -- 'Alt. definition Unique person +  date of service'
,CAST(NULL AS nvarchar(MAX)) AS [CIN],CAST(NULL AS nvarchar(MAX)) AS [SUBSCRID],clm.memid,UPPER(LTRIM(RTRIM(ISNULL(sme.fullname,'')))) AS [MEMNM],sme.dob
,[MEMBER_AGE] = CAST(DATEDIFF("dd",CAST(sme.dob AS datetime),TRY_CONVERT(date,clm.startdate))/365.25 AS money)
,[MEMBER_TRUE_CHRONOLOGICAL_AGE] = CAST(SUBSTRING(CAST(CAST(DATEDIFF("dd",TRY_CONVERT(date,sme.dob),TRY_CONVERT(date,clm.startdate))/365.25 AS money) AS nvarchar(25)),1,CHARINDEX('.',CAST(DATEDIFF("dd",TRY_CONVERT(date,sme.dob),TRY_CONVERT(date,clm.startdate))/365.25 AS money),1)-1) AS int)
,[MEMBER_TRUE_CHRONOLOGICAL_AGE_AND_HOW_MANY_MTHs] = DATEDIFF("mm",TRY_CONVERT(date,sme.dob),TRY_CONVERT(date,clm.startdate))-CAST(SUBSTRING(CAST(CAST(DATEDIFF("dd",TRY_CONVERT(date,sme.dob),TRY_CONVERT(date,clm.startdate))/365.25 AS money) AS nvarchar(25)),1,CHARINDEX('.',CAST(DATEDIFF("dd",TRY_CONVERT(date,sme.dob),TRY_CONVERT(date,clm.startdate))/365.25 AS money),1)-1) AS int)*12
,a.provid -- [RENDERING] -- AFFILIATIONID is the relationship between the a.provid = PROVIDER AND the a.affiliateid = PAYTO aka VENDOR
,UPPER(LTRIM(RTRIM(ISNULL(p1.npi,'')))) AS [NPIprovnm],UPPER(LTRIM(RTRIM(ISNULL(p1.fullname,'')))) AS [PROVNM]
,a.affiliateid AS [PAYTO] -- [PAYTO] -- AFFILIATIONID is the relationship between the a.provid = PROVIDER AND the a.affiliateid = PAYTO aka VENDOR
,UPPER(LTRIM(RTRIM(ISNULL(p2.npi,'')))) AS [NPIpayto],UPPER(LTRIM(RTRIM(ISNULL(p2.fullname,'')))) AS [PAYTONM]
-- ,cd.renderingprovid -- OFF CLAIM RENDERING -- REMOVE AS CAN CAUSE DUP(s) AS OF 20181107
-- ,UPPER(LTRIM(RTRIM(ISNULL(p3.npi,'')))) AS [NPIrendering],UPPER(LTRIM(RTRIM(ISNULL(p3.fullname,'')))) AS [RENDERINGNM] -- REMOVE AS CAN CAUSE DUP(s) AS OF 20181107
,LTRIM(RTRIM(clm.planid)) AS clmLOB
,LTRIM(RTRIM(cd.planid)) AS cdLOB
,UPPER(LTRIM(RTRIM(ISNULL(clm.claimid,'')))) AS SEQ_CLAIM_ID,clm.claimid,cd.claimline,cd.dosfrom,cd.dosto -- ,UPPER(LTRIM(RTRIM(ISNULL(papc.SEQ_CLAIM_ID,'')))) AS SEQ_CLAIM_ID,cd.claimline,cd.dosfrom,cd.dosto
 ,CASE
WHEN LTRIM(RTRIM(clm.claimid))  LIKE '%A%'
THEN SUBSTRING(LTRIM(RTRIM(clm.claimid)),1,CHARINDEX('A',LTRIM(RTRIM(clm.claimid)),1)-1)
WHEN LTRIM(RTRIM(clm.claimid))  LIKE '%R%'
THEN SUBSTRING(LTRIM(RTRIM(clm.claimid)),1,CHARINDEX('R',LTRIM(RTRIM(clm.claimid)),1)-1)
ELSE LTRIM(RTRIM(clm.claimid))
END AS [ORIG_REVERSE_APPEND_CLAIMID]
,ct.ClmType,ct.formtype,sbt.QNXTbilltype,sbt.BillTypeDescr
,cd.servunits -- AS [QUANTITY]
,CAST(NULL AS int) AS [QUANTITY]-- see UNNECESSARY ADJ UPDATE BELOW
,clm.totalamt AS TOTAL_BILLED_AMT
,clm.totalpaid AS TOTAL_PAID_AMOUNT
,cd.claimamt AS BILLED_AMT --BILLED (BAP)
,cd.allowedamt AS ALLOWED_AMT  --ALLOWED (BAP)
,cd.amountpaid AS NET_AMT
,cd.amountpaid AS PAID_NET_AMT -- cd.amountpaid PROVEN to represent true COST (see pv.amountpaid AS CHECKAMT)  + PAID (BAP)
,-cd.paydiscount AS [INT] -- INTEREST -- ,ABS(cd.paydiscount) AS [INT]
,cd.ineligibleamt AS [DISALLOWED],cd.cobeligibleamt AS [COB Allowed],cd.extpaidamt AS [COB Paid],clm.totextdeductamt AS [COBDeduct],cd.extcoinsuranceamt AS [COB Coinsurance]
-- ,wc.userid,UPPER(LTRIM(RTRIM(ISNULL(CAST(wc.lastname AS varchar(MAX)),''))))+', '+UPPER(LTRIM(RTRIM(ISNULL(CAST(wc.firstname AS varchar(MAX)),'')))) AS [USERname]
-- ,UPPER(LTRIM(RTRIM(ISNULL(CAST(wc.lastname AS varchar(MAX)),'')))) AS [USERlastname]
-- ,UPPER(LTRIM(RTRIM(ISNULL(CAST(wc.firstname AS varchar(MAX)),'')))) AS [USERfirstname]
,TRY_CONVERT(date,clm.startdate) AS [DOS]
,SUBSTRING(CONVERT(varchar(MAX),TRY_CONVERT(date,clm.startdate),112),1,4) AS [YEAR_DOS] -- yyyy FROM yyyymmdd
,SUBSTRING(CONVERT(varchar(MAX),TRY_CONVERT(date,clm.startdate),112),1,6) AS [YEARMO_DOS] -- yyyymm FROM yyyymmdd
,SUBSTRING(CONVERT(varchar(MAX),TRY_CONVERT(date,clm.startdate),112),5,2) AS [MTH_DOS] -- mm FROM yyyymmdd
,UPPER(LTRIM(RTRIM(ISNULL(CAST(DATENAME(MONTH,TRY_CONVERT(date,clm.startdate)) AS varchar(3)),'')))) AS [ABBREV_MONTHis_DOS]
,TRY_CONVERT(date,clm.enddate) AS [DOSTHRU]
,SUBSTRING(CONVERT(varchar(MAX),TRY_CONVERT(date,clm.enddate),112),1,4) AS [YEAR_DOSTHRU] -- yyyy FROM yyyymmdd
,SUBSTRING(CONVERT(varchar(MAX),TRY_CONVERT(date,clm.enddate),112),1,6) AS [YEARMO_DOSTHRU] -- yyyymm FROM yyyymmdd
,SUBSTRING(CONVERT(varchar(MAX),TRY_CONVERT(date,clm.enddate),112),5,2) AS [MTH_DOSTHRU] -- mm FROM yyyymmdd
,UPPER(LTRIM(RTRIM(ISNULL(CAST(DATENAME(MONTH,TRY_CONVERT(date,clm.enddate)) AS varchar(3)),'')))) AS [ABBREV_MONTHis_DOSTHRU]
,TRY_CONVERT(date,clm.cleandate) AS [RECEIVED DATE]
,SUBSTRING(CONVERT(varchar(MAX),TRY_CONVERT(date,clm.cleandate),112),1,4) AS [YEAR_RECEIVED] -- yyyy FROM yyyymmdd
,SUBSTRING(CONVERT(varchar(MAX),TRY_CONVERT(date,clm.cleandate),112),1,6) AS [YEARMO_RECEIVED] -- yyyymm FROM yyyymmdd
,SUBSTRING(CONVERT(varchar(MAX),TRY_CONVERT(date,clm.cleandate),112),5,2) AS [MTH_RECEIVED] -- mm FROM yyyymmdd
,UPPER(LTRIM(RTRIM(ISNULL(CAST(DATENAME(MONTH,TRY_CONVERT(date,clm.cleandate)) AS varchar(3)),'')))) AS [ABBREV_MONTHis_RECEIVED]
,TRY_CONVERT(date,clm.paiddate)  AS [CHECK DATE]
,SUBSTRING(CONVERT(varchar(MAX),TRY_CONVERT(date,clm.paiddate),112),1,4) AS [YEAR_CHECKDATE] -- yyyy FROM yyyymmdd
,SUBSTRING(CONVERT(varchar(MAX),TRY_CONVERT(date,clm.paiddate),112),1,6) AS [YEARMO_CHECKDATE] -- yyyymm FROM yyyymmdd
,SUBSTRING(CONVERT(varchar(MAX),TRY_CONVERT(date,clm.paiddate),112),5,2) AS [MTH_CHECKDATE] -- mm FROM yyyymmdd
,UPPER(LTRIM(RTRIM(ISNULL(CAST(DATENAME(MONTH,TRY_CONVERT(date,clm.paiddate)) AS varchar(3)),'')))) AS [ABBREV_MONTHis_CHECKDATE]
,TRY_CONVERT(date,clm.adjuddate) AS [ADJUDICATE DATE]	
,SUBSTRING(CONVERT(varchar(MAX),TRY_CONVERT(date,clm.adjuddate),112),1,4) AS [YEAR_ADJUDICATE] -- yyyy FROM yyyymmdd
,SUBSTRING(CONVERT(varchar(MAX),TRY_CONVERT(date,clm.adjuddate),112),1,6) AS [YEARMO_ADJUDICATE] -- yyyymm FROM yyyymmdd
,SUBSTRING(CONVERT(varchar(MAX),TRY_CONVERT(date,clm.adjuddate),112),5,2) AS [MTH_ADJUDICATE] -- mm FROM yyyymmdd
,UPPER(LTRIM(RTRIM(ISNULL(CAST(DATENAME(MONTH,TRY_CONVERT(date,clm.adjuddate)) AS varchar(3)),'')))) AS [ABBREV_MONTHis_ADJUDICATE]
,TRY_CONVERT(date,clm.okpaydate) AS [POST DATE]
,SUBSTRING(CONVERT(varchar(MAX),TRY_CONVERT(date,clm.okpaydate),112),1,4) AS [YEAR_POST] -- yyyy FROM yyyymmdd
,SUBSTRING(CONVERT(varchar(MAX),TRY_CONVERT(date,clm.okpaydate),112),1,6) AS [YEARMO_POST] -- yyyymm FROM yyyymmdd
,SUBSTRING(CONVERT(varchar(MAX),TRY_CONVERT(date,clm.okpaydate),112),5,2) AS [MTH_POST] -- mm FROM yyyymmdd
,UPPER(LTRIM(RTRIM(ISNULL(CAST(DATENAME(MONTH,TRY_CONVERT(date,clm.okpaydate)) AS varchar(3)),'')))) AS [ABBREV_MONTHis_POST DATE]
,TRY_CONVERT(date,clm.cleandate) AS [TAT_CLEANDATE],TRY_CONVERT(date,cd.createdate) AS [TAT_CREATEDATE],CAST(clm.logdate AS datetime) AS [TAT_LOGDATE]
,CAST(NULL AS varchar(MAX)) AS [Primary / Secondary Status] -- EMPTY SHELL QUPD FIELD
,SUBSTRING(UPPER(LTRIM(RTRIM(ISNULL(cd.servcode,'')))),1,5) AS [CPT Service Code],sp.[CodeDescr] AS [Service Description],cd.revcode,revcde.description AS [REVCDE Descr],cd.location,posdescr.DESCRIPTION AS [POS Descr]
,CAST(NULL AS money) AS [Modifier Discount] -- QUPD()
,CAST(NULL AS money) AS [EQUIV_allow_rate]
,CAST(NULL AS money) AS [EQUIV_allow_compare]
-- CAST(NULL AS nvarchar(100)) AS AUTH_NUMBER, -- QUPD  (see ref.authorizationid)
,CASE
WHEN cd.referralid IS NULL
THEN UPPER(LTRIM(RTRIM(ISNULL(clm.referralid,''))))
ELSE UPPER(LTRIM(RTRIM(ISNULL(cd.referralid,''))))
END AS AUTH_NUMBER -- c.referralid OR cd.referralid = ref.authorizationid DISCOVERED ON 20150728 w S. Glembocki
-- ,[prindiag] = principaldiag.prindiag
-- ,[prindiag descr] = principaldiag.[prindiag descr]
-- ,[PRESENT ON ADMISSION] = principaldiag.[PRESENT ON ADMISSION]
,CAST(NULL AS varchar(MAX)) AS [prindiag] -- EMPTY SHELL QUPD FIELD,principaldiag.prindiag
,CAST(NULL AS varchar(MAX)) AS [prindiag descr] -- EMPTY SHELL QUPD FIELD ,principaldiag.[prindiag descr]
,CAST(NULL AS nvarchar(MAX)) AS [PRESENT ON ADMISSION]
,clm.drg --ADD ON TO MAKE DISTINCTION BETWEEN [DELIV_TYPE] aka [BIRTH_TYPE], etc... 20171025 'DRG' = Diagnosis Related Group (DRG)
,CAST(NULL AS nvarchar(MAX)) AS [DRGdescr]
,CAST(NULL AS nvarchar(MAX)) AS [PROCEDURE_1_CODE]
,clm.admitsource,clm.admithour,clm.dischargedate -- ,r.dischargedate -- FROM HMOPROD_PLANDATA.dbo.referral
,CASE -- see 'STEP88_DISCHARGE_STATUS'...sql
WHEN LTRIM(RTRIM(clm.patientstatus)) = '01' THEN 'Discharged to home or self care'
WHEN LTRIM(RTRIM(clm.patientstatus)) = '02' THEN 'Discharged/transferred to a short-term general hospital for in-patient care'
WHEN LTRIM(RTRIM(clm.patientstatus)) = '03' THEN 'Discharged/transferred to a skilled nursing facility (SNF)'
WHEN LTRIM(RTRIM(clm.patientstatus)) = '04' THEN 'Discharged/transferred to an intermediate care facility'
WHEN LTRIM(RTRIM(clm.patientstatus)) = '05' THEN 'Discharged/transferred to a non-medicare PPS childrens hospital or non-medicare PPS hospital for inpatient care'
WHEN LTRIM(RTRIM(clm.patientstatus)) = '06' THEN 'Discharged/transferred to home under care of organized home health service organization'
WHEN LTRIM(RTRIM(clm.patientstatus)) = '07' THEN 'Left against medical advice or discontinued care'
WHEN LTRIM(RTRIM(clm.patientstatus)) = '09' THEN 'Admitted as an inpatient to this hospital'
WHEN LTRIM(RTRIM(clm.patientstatus)) BETWEEN '10' AND '19' THEN 'Reserved for national assignment'
WHEN LTRIM(RTRIM(clm.patientstatus)) = '20' THEN 'Expired'
WHEN LTRIM(RTRIM(clm.patientstatus)) BETWEEN '21' AND '29' THEN 'Reserved for national assignment'
WHEN LTRIM(RTRIM(clm.patientstatus)) = '30' THEN 'Still a patient'
WHEN LTRIM(RTRIM(clm.patientstatus)) BETWEEN '31' AND'39' THEN 'Reserved for national assignment'
WHEN LTRIM(RTRIM(clm.patientstatus)) = '40' THEN 'Expired at home'
WHEN LTRIM(RTRIM(clm.patientstatus)) = '41' THEN 'Expired in a medical facility'
WHEN LTRIM(RTRIM(clm.patientstatus)) = '42' THEN 'Expired -- place unknown'
WHEN LTRIM(RTRIM(clm.patientstatus)) = '43' THEN 'Discharged/transferred to a federal hospital'
WHEN LTRIM(RTRIM(clm.patientstatus)) BETWEEN '44' AND '49' THEN 'Reserved for national assignment'
WHEN LTRIM(RTRIM(clm.patientstatus)) = '50' THEN 'Hospice -- home'
WHEN LTRIM(RTRIM(clm.patientstatus)) = '51' THEN 'Hospice -- medical facility'
WHEN LTRIM(RTRIM(clm.patientstatus)) BETWEEN '52' AND '60' THEN 'Reserved for national assignment'
WHEN LTRIM(RTRIM(clm.patientstatus)) = '61' THEN 'Discharged/transferred within this institution to a hospital-based Medicare approved swing bed'
WHEN LTRIM(RTRIM(clm.patientstatus)) = '62' THEN 'Discharged/transferred to another rehabilitation facility including rehabilitation distinct part units of a hospital'
WHEN LTRIM(RTRIM(clm.patientstatus)) = '63' THEN 'Discharged/transferred to a long-term care hospital'
WHEN LTRIM(RTRIM(clm.patientstatus)) = '64' THEN 'Discharged/transferred to a nursing facility certified under Medicaid but not certified under Medicare'
WHEN LTRIM(RTRIM(clm.patientstatus)) = '65' THEN 'Discharged/transferred to a psychiatric hospital or psychiatric distinct part unit of a hospital'
WHEN LTRIM(RTRIM(clm.patientstatus)) = '66' THEN 'Discharged/transferred to a to a critical access hospital'
WHEN LTRIM(RTRIM(clm.patientstatus)) BETWEEN '67' AND '70' THEN 'Reserved for national assignment'
WHEN LTRIM(RTRIM(clm.patientstatus)) BETWEEN '73' AND '99' THEN 'Reserved for national assignment'
ELSE 'TBD'
END AS DischargeDescription -- x see 'JAHDischargeStatus_PatientStatus_20160223.pdf'
,0 AS [How many months with plan],clm.okpayby,ISNULL(clm.okpayby,'N/A') AS [Decision Maker for modification / denial / deferrals]
INTO TABLENAME
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
-- SELECT DISTINCT ' ' AS 'CHECK 1st',dischargedate FROM HMOPROD_PLANDATA.dbo.claim
-- SELECT DISTINCT ' ' AS 'CHECK 1st',dischargedate FROM HMOPROD_PLANDATA.dbo.referral
FROM #SETclaimrange AS scr
	JOIN HMOPROD_PLANDATA.dbo.claim AS clm ON scr.claimid = clm.claimid
	JOIN HMOPROD_PLANDATA.dbo.claimdetail AS cd ON clm.claimid = cd.claimid

		LEFT JOIN HMOPROD_PlanData.dbo.benefitplan AS bp on clm.planid = bp.planid

		LEFT JOIN 
		( -- INITIATE ...
		SELECT 'REVENUE_CODE' AS [CodeType],ISNULL(rc.description,'') AS [CodeDescr],rc.*
		,CASE
		WHEN SUBSTRING(LTRIM(RTRIM(ISNULL(rc.codeid,''))),1,1) = 'Z'
		THEN  LTRIM(RTRIM(rc.codeid))
		WHEN SUBSTRING(LTRIM(RTRIM(ISNULL(rc.codeid,''))),1,1) = '0'
		THEN  SUBSTRING(LTRIM(RTRIM(ISNULL(rc.codeid,''))),2,3)
		ELSE LTRIM(RTRIM(ISNULL(rc.codeid,'')))
		END AS [REVENUE_CODE]
		-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
		-- SELECT DISTINCT ' ' AS 'CHECK 1st',
		FROM HMOPROD_PLANDATA.dbo.revcode AS rc 
		) -- CONCLUDE ...
		AS revcde ON CASE
		WHEN SUBSTRING(LTRIM(RTRIM(ISNULL(cd.revcode,''))),1,1) = 'Z'
		THEN  LTRIM(RTRIM(cd.revcode))
		WHEN SUBSTRING(LTRIM(RTRIM(ISNULL(cd.revcode,''))),1,1) = '0'
		THEN  SUBSTRING(LTRIM(RTRIM(ISNULL(cd.revcode,''))),2,3)
		ELSE LTRIM(RTRIM(ISNULL(cd.revcode,'')))
		END = revcde.REVENUE_CODE

		LEFT JOIN 
		( -- INITIATE ...
		SELECT ' ' AS 'POS (PLACE OF SERVICE)',*
		FROM HMOPROD_PLANDATA.dbo.hcfaposlocation
		) -- CONCLUDE ...
		AS posdescr ON UPPER(LTRIM(RTRIM(ISNULL(cd.location,'')))) = posdescr.locationcode
		
		LEFT JOIN 
		( -- INITIATE ...
		SELECT [CONTRACT DESCRIPTION] = UPPER(LTRIM(RTRIM(ISNULL(CAST(description AS nvarchar(MAX)),'')))),contractid 
		FROM HMOPROD_PLANDATA.dbo.contract 
		WHERE UPPER(LTRIM(RTRIM(ISNULL(CAST(description AS nvarchar(MAX)),'')))) != ''
		) -- CONCLUDE ...
		AS contrdescr ON cd.contractid = contrdescr.contractid

		LEFT JOIN 
		( -- INITIATE ...
		SELECT 'CPT - PROCEDURE_CODE' AS [CodeType],ISNULL(sc.description,'') AS [CodeDescr],sc.*
		-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
		-- SELECT DISTINCT ' ' AS 'CHECK 1st',
		FROM HMOPROD_PLANDATA.dbo.svccode AS sc 
		) -- CONCLUDE ...
		AS sp ON SUBSTRING(UPPER(LTRIM(RTRIM(ISNULL(cd.servcode,'')))),1,5) = SUBSTRING(UPPER(LTRIM(RTRIM(ISNULL(sp.codeid,'')))),1,5)

		LEFT JOIN HMOPROD_PLANDATA.dbo.member AS sme ON clm.memid = sme.memid
		LEFT JOIN #SHELLclmtype AS ct ON clm.formtype = ct.formtype
		LEFT JOIN #SHELLbilltype AS sbt ON (LTRIM(RTRIM(clm.facilitycode))+LTRIM(RTRIM(clm.billclasscode))+LTRIM(RTRIM(clm.frequencycode))) = sbt.QNXTbilltype -- HEADER replacement for POS on INCLM claims
		LEFT JOIN HMOPROD_PLANDATA.dbo.affiliation AS a ON clm.affiliationid = a.affiliationid -- REMINDER: within claim(s) tables AFFILIATIONID is the relationship between the a.provid = PROVIDER AND the a.affiliateid = PAYTO aka VENDOR
		LEFT JOIN HMOPROD_PLANDATA.dbo.provider AS p1 ON a.provid = p1.provid -- PROVNM
		LEFT JOIN HMOPROD_PLANDATA.dbo.provider AS p2 ON a.affiliateid = p2.provid -- [PAYTO] (IPAID)
		-- LEFT JOIN HMOPROD_PLANDATA.dbo.provider AS p3 ON cd.renderingprovid = p3.provid -- RENDERING -- REMOVE AS CAN CAUSE DUP(s) AS OF 20181107
		-- LEFT JOIN INFORMATICS2.dbo.quserWC AS wc ON UPPER(LTRIM(RTRIM(ISNULL(cd.createid,'')))) = UPPER(LTRIM(RTRIM(ISNULL(wc.loginid,'')))) -- IMPORT FROM LEFT JOIN SQLPROD01.HMOPROD_QCSIDB.dbo.quser AS q on q.userid = cd.createid see 'QUSER_'...xlsx

-- WHERE ... 

	-- AND clm.claimid IN -- THE ENTIRE CLAIM by [DIAG]
	-- ( -- INITIATE ...
	-- SELECT DISTINCT dx.claimid
	-- FROM HMOPROD_PLANDATA.dbo.claimdiag AS dx
	-- WHERE UPPER(LTRIM(RTRIM(ISNULL(dx.codeid,'')))) BETWEEN 'E08%' AND 'E13%' -- BETWEEN 'E08' AND 'E13.999' -- see [DMP] + OR ARNOLD_...rar IN ('E08','E09','E10','E11','E13') -- HEDIS Diabetes
	-- ) -- CONCLUDE
	
	-- AND clm.claimid IN -- THE ENTIRE CLAIM by [CPT]
	-- ( -- INITIATE 
	-- SELECT DISTINCT claimid 
	-- FROM HMOPROD_PLANDATA.dbo.claimdetail
	-- WHERE SUBSTRING(UPPER(LTRIM(RTRIM(ISNULL(cd.servcode,'')))),1,5)  IN ('01967','01968')  -- PROCEDURE_CODE / current procedural terminology (CPT)
	-- ) --CONCLUDE ...

	-- AND UPPER(LTRIM(RTRIM(ISNULL(clm.[status],''))))  IN ('PAID') -- != 'DENIED' -- NOT <> !=  EXCLUDE DENIED CLAIM(s) FROM DSH rewrite

	-- AND clm.claimid IN -- THE ENTIRE CLAIM by [REVCODE]
	-- ( -- INITIATE 
	-- SELECT DISTINCT claimid
	-- FROM HMOPROD_PLANDATA.dbo.claimdetail
	-- WHERE CASE
	-- WHEN SUBSTRING(UPPER(LTRIM(RTRIM(ISNULL(cd.revcode,'')))),1,1) = 'Z'
	-- THEN  UPPER(LTRIM(RTRIM(ISNULL(cd.revcode,''))))
	-- WHEN SUBSTRING(UPPER(LTRIM(RTRIM(ISNULL(cd.revcode,'')))),1,1) = '0'
	-- THEN  SUBSTRING(UPPER(LTRIM(RTRIM(ISNULL(cd.revcode,'')))),2,3)
	-- ELSE UPPER(LTRIM(RTRIM(ISNULL(cd.revcode,''))))
	-- END LIKE @revis --LIMIT PLACED ON REVENUE_CODE
	-- ) --CONCLUDE ...

	-- AND 
	-- ( -- INITIATE ...
	-- UPPER(LTRIM(RTRIM(ISNULL(clm.planid,'')))) LIKE @LOB
		-- /* OR UPPER(LTRIM(RTRIM(ISNULL(cd.planid,'')))) LIKE @LOB -- LINE_OF_BUSINESS FROM EITHER CLAIM(s) [TABLE] */
		-- ) -- CONCLUDE ...

	-- AND UPPER(LTRIM(RTRIM(ISNULL(clm.provid,'')))) IN -- [RENDERING]
	-- ( -- INITIATE ...
	-- SELECT DISTINCT provid FROM #PROVISOLATION 
	-- ) -- CONCLUDE ... 

	-- AND UPPER(LTRIM(RTRIM(ISNULL(a.affiliateid,'')))) IN  -- [PAYTO]
	-- ( -- INITIATE ...
	-- SELECT DISTINCT provid FROM #PROVISOLATION 
	-- ) -- CONCLUDE ... 

	-- AND 
	-- ( -- INITIATE ... 
	-- UPPER(LTRIM(RTRIM(ISNULL(clm.provid,'')))) IN (@prov,@payto) -- [RENDERING]
		-- OR UPPER(LTRIM(RTRIM(ISNULL(a.affiliateid,'')))) IN (@prov,@payto) -- [PAYTO]
		-- ) -- CONCLUDE ...

	-- AND UPPER(LTRIM(RTRIM(ISNULL(ct.ClmType,'')))) = UPPER(LTRIM(RTRIM(ISNULL(@clmtype,''))))

	-- AND UPPER(LTRIM(RTRIM(ISNULL(cd.location,'')))) = UPPER(LTRIM(RTRIM(ISNULL(@pos,''))))

	-- AND 
	-- ( -- INITIATE ...
	-- UPPER(LTRIM(RTRIM(ISNULL(clm.facilitycode,''))))+UPPER(LTRIM(RTRIM(ISNULL(clm.billclasscode,''))))+UPPER(LTRIM(RTRIM(ISNULL(clm.frequencycode,'')))) LIKE @bt --HEADER replacement for POS on INCLM claims BILLTYPE
		-- OR UPPER(LTRIM(RTRIM(ISNULL(sbt.QNXTbilltype,'','')))) LIKE @bt --HEADER replacement for POS on INCLM claims BILLTYPE
		-- ) -- CONCLUDE ...

	-- AND UPPER(LTRIM(RTRIM(ISNULL(clm.claimid,'')))) NOT IN (SELECT DISTINCT UPPER(LTRIM(RTRIM(ISNULL(clmh.claimid,'')))) -- The ENTIRE claim
-- FROM HMOPROD_PLANDATA.dbo.claim AS clmh
-- WHERE UPPER(LTRIM(RTRIM(ISNULL(clmh.[status],'')))) = 'DENIED') -- NOT <> !=  EXCLUDE DENIED CLAIM(s) FROM DSH rewrite

	-- AND clm.memid IN (ISNULL(@memid,clm.memid)) -- ISO ON SPECIFIC MEMBER
	
	-- AND clm.memid IN -- ISO ON SPECIFIC MEMBER
	-- ( -- INITIATE 
	-- SELECT DISTINCT memid
	-- FROM #baselinemembership
	-- ) --CONCLUDE ...
; -- SEMICOLON CONCLUSION ...

	-- DUP(s) --
SELECT ' ' AS 'SHOULD BE NULL DUP Validation',*
FROM TABLENAME
WHERE [DupID] IN 
( -- INITIATE ...
SELECT dup.[DupID]
FROM TABLENAME AS dup
GROUP BY dup.[DupID] -- Duplication Driver
HAVING COUNT(1)>1 -- HAVING clause RESERVED for AGGREGATE(s)
) -- CONCLUDE ...







-- =====================================================================
	-- CONTRACTING DEPT. PROPOSAL [Modifier Discount] --
-- =====================================================================
		SELECT 'see "STEP88_FEESCHED_...sql" FOR CONTRACTING PROPOSAL ANALYSIS' AS [MESSAGE(S)]







-- =====================================================================
	-- QUPD [PROCEDURE_1_CODE] --
-- =====================================================================
UPDATE TABLENAME
SET PROCEDURE_1_CODE = pcode
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM TABLENAME AS su
	JOIN HMOPROD_PLANDATA.dbo.claimproc AS cp ON su.claimid = cp.claimid
WHERE ISNULL(proctype,'') = 'Primary'
	AND su.claimline = '1'
	
	
	
	
	
	
	
-- =====================================================================
	-- PIVOT() PRINCIPAL DIAG  [prindiag] + [poa] --
-- =====================================================================
/* SELECT claimid,[1],[2],[3],[4],[5],[6],[7],[8],[9],[10],[11],[12],[13],[14],[15],[16],[17],[18],[19],[20],[21],[22],[23],[24],[25],[26],[27],[28],[29],[30],[31],[32],[33],[34],[35],[36],[37],[38],[39],[40],[41],[42],[43],[44],[45]
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'	
FROM 
( -- INITIATE ...
SELECT dx.claimid,dx.codeid,dx.sequence
-- ,dx.poa AS [PRESENT ON ADMISSION],dc.description AS [DIAG DESCR]
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st',
FROM HMOPROD_PLANDATA.dbo.claimdiag AS dx
	-- LEFT JOIN HMOPROD_PLANDATA.dbo.DiagCode AS dc ON dx.codeid = dc.codeid
) -- CONCLUDE
 AS diag
PIVOT 
( -- INITIATE ...
MAX(diag.codeid)
FOR diag.sequence IN ([1],[2],[3],[4],[5],[6],[7],[8],[9],[10],[11],[12],[13],[14],[15],[16],[17],[18],[19],[20],[21],[22],[23],[24],[25],[26],[27],[28],[29],[30],[31],[32],[33],[34],[35],[36],[37],[38],[39],[40],[41],[42],[43],[44],[45])
) -- CONCLUDE ...
AS dxpivot
-- WHERE claimid IN (SELECT DISTINCT claimid FROM #IPClaims)
	AND [25] IS NOT NULL */







-- =====================================================================
	-- PRINCIPAL DIAG  [prindiag] + [poa] --
-- =====================================================================
UPDATE TABLENAME
SET [prindiag] = principaldiag.diag
,[prindiag descr] = principaldiag.[diag descr]
,[PRESENT ON ADMISSION] = principaldiag.[PRESENT ON ADMISSION]
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM TABLENAME AS su	
	JOIN 
	( -- INITIATE ...
	SELECT *
	-- INTO #prindiag
	-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
	-- SELECT DISTINCT ' ' AS 'CHECK 1st'	
	FROM 
	( -- INITIATE ...
	SELECT aliassetup.*,DENSE_RANK() OVER (PARTITION BY aliassetup.claimid ORDER BY aliassetup.sequence ASC,aliassetup.codeid DESC) AS [RANKis]
	-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
	-- SELECT DISTINCT ' ' AS 'CHECK 1st'	
	FROM 
	( -- INITIATE ...
	SELECT DISTINCT dx.claimid,dx.codeid,UPPER(LTRIM(RTRIM(ISNULL(dx.codeid,'')))) AS [diag],ISNULL(dc.DESCRIPTION,'') AS [diag descr],dx.sequence,dx.poa AS [PRESENT ON ADMISSION]
	-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
	-- SELECT DISTINCT ' ' AS 'CHECK 1st'	
	FROM HMOPROD_PLANDATA.dbo.claimdiag AS dx
		LEFT JOIN HMOPROD_PLANDATA.dbo.DiagCode AS dc ON dx.codeid = dc.codeid
	) -- CONCLUDE
	AS aliassetup
	) -- CONCLUDE
	AS alias
	WHERE alias.sequence = 1 -- BETWEEN 1 AND 9
		AND alias.[RANKis] = 1
	) -- CONCLUDE ...
	AS principaldiag ON su.claimid = principaldiag.claimid







-- =============================================================
	-- QUPD MEMBERSHIP demog -- 
-- =============================================================
DECLARE @whichcin nvarchar(MAX)

SET @whichcin = 'MA020' --[MemberAttribute](s) CIN

UPDATE TABLENAME
SET SUBSCRID = SUBSTRING(UPPER(LTRIM(RTRIM(ISNULL(ek.carriermemid,'')))),1,10)
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
-- SELECT TOP 10 * FROM HMOPROD_PLANDATA.dbo.enrollkeys
FROM TABLENAME AS su
	JOIN HMOPROD_PLANDATA.dbo.enrollkeys AS ek ON su.memid = ek.memid
WHERE ISNULL(ek.carriermemid,'') != '' -- NOT <> !=
	AND UPPER(LTRIM(RTRIM(ISNULL(su.SUBSCRID,'')))) = ''
	AND CAST(ek.effdate AS datetime) <= CAST(GETDATE() AS datetime) --IIF eff AFTER....
	AND CAST(ek.termdate AS datetime) >= CAST(GETDATE() AS datetime) --IIF termed BEFORE...
	AND CAST(ek.termdate AS datetime) != CAST(ek.effdate AS datetime)
	AND CAST(ek.termdate AS datetime) > CAST(ek.effdate AS datetime)
	
UPDATE TABLENAME
SET SUBSCRID = SUBSTRING(UPPER(LTRIM(RTRIM(ISNULL(ek.carriermemid,'')))),1,10)
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
-- SELECT TOP 10 * FROM HMOPROD_PLANDATA.dbo.enrollkeys
FROM TABLENAME AS su
	JOIN HMOPROD_PLANDATA.dbo.enrollkeys AS ek ON su.memid = ek.memid
WHERE ISNULL(ek.carriermemid,'') != '' -- NOT <> !=
	AND UPPER(LTRIM(RTRIM(ISNULL(su.SUBSCRID,'')))) = ''
	AND CAST(ek.termdate AS datetime) != CAST(ek.effdate AS datetime)
	AND CAST(ek.termdate AS datetime) > CAST(ek.effdate AS datetime) 

UPDATE TABLENAME
SET [CIN] = SUBSTRING(UPPER(LTRIM(RTRIM(ISNULL(ma.TheValue,'')))),1,9)
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
-- SELECT TOP 10 * FROM HMOPROD_PLANDATA.dbo.memberattribute
FROM TABLENAME AS su
	JOIN HMOPROD_PLANDATA.dbo.memberattribute AS ma ON su.memid = ma.memid
WHERE UPPER(LTRIM(RTRIM(ISNULL(su.[CIN],'')))) = ''
	AND UPPER(LTRIM(RTRIM(ISNULL(ma.attributeid,'')))) IN (@whichcin) -- SET @whichcin = 'MA020' --[MemberAttribute](s) CIN
	AND CAST(ma.effdate AS datetime) <= CAST(GETDATE() AS datetime) --IIF eff AFTER....
	AND CAST(ma.termdate AS datetime) >= CAST(GETDATE() AS datetime) --IIF termed BEFORE...
	AND CAST(ma.termdate AS datetime) != CAST(ma.effdate AS datetime)
	AND CAST(ma.termdate AS datetime) > CAST(ma.effdate AS datetime)	

UPDATE TABLENAME
SET [CIN] = SUBSTRING(UPPER(LTRIM(RTRIM(ISNULL(ma.TheValue,'')))),1,9)
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
-- SELECT TOP 10 * FROM HMOPROD_PLANDATA.dbo.memberattribute
FROM TABLENAME AS su
	JOIN HMOPROD_PLANDATA.dbo.memberattribute AS ma ON su.memid = ma.memid
WHERE UPPER(LTRIM(RTRIM(ISNULL(su.[CIN],'')))) = ''
	AND UPPER(LTRIM(RTRIM(ISNULL(ma.attributeid,'')))) IN (@whichcin) -- SET @whichcin = 'MA020' --[MemberAttribute](s) CIN
	AND CAST(ma.termdate AS datetime) != CAST(ma.effdate AS datetime)
	AND CAST(ma.termdate AS datetime) > CAST(ma.effdate AS datetime)	
	
UPDATE TABLENAME
SET [CIN] = SUBSTRING(UPPER(LTRIM(RTRIM(ISNULL(mem.secondaryid,'')))),1,9)
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
-- SELECT TOP 10 * FROM HMOPROD_PLANDATA.dbo.member
FROM TABLENAME AS su
	JOIN HMOPROD_PLANDATA.dbo.member AS mem ON su.memid = mem.memid
WHERE UPPER(LTRIM(RTRIM(ISNULL(su.[CIN],'')))) = ''
	AND UPPER(LTRIM(RTRIM(ISNULL(mem.secondaryid,'')))) != '' -- NOT <> !=







-- =====================================================================
	-- [Primary or secondary claim] OR [Member Status (Primary, Secondary] --
-- =====================================================================
UPDATE TABLENAME
SET [Primary / Secondary Status] = estatus.[Plan Position Status] -- [Primary or secondary claim] OR [Member Status (Primary, Secondary] see "DMP" FOR alt. SEQUENCE
-- SELECT TOP 10 estatus.[STATUS INDICATOR],su.* -- CHECK 1st
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
 FROM TABLENAME AS su
 
	JOIN 
	( -- INITIATE ...
	SELECT DISTINCT c.claimid,es.primarystatus AS [Plan Position Status],ek.carriermemid,ek.memid,es.effdate,es.termdate,es.primarystatus AS [STATUS INDICATOR],ec.ratecode,pg.programid,bp.planid,bp.description,ek.enrollid
	-- SELECT TOP 10 estatus.[STATUS INDICATOR],su.* -- CHECK 1st
	-- SELECT DISTINCT ' ' AS 'CHECK 1st'
	FROM HMOPROD_PLANDATA.dbo.enrollkeys AS ek
	-- FROM #date_calendar AS dc,HMOPROD_PLANDATA.dbo.enrollkeys AS ek -- DO NOT NO NEGATIVE != <> COVER THE TE
		JOIN HMOPROD_PLANDATA.dbo.member AS mem ON ek.memid = mem.memid
			LEFT JOIN HMOPROD_PLANDATA.dbo.benefitplan AS bp ON ek.programid = bp.programid
		JOIN HMOPROD_PLANDATA.dbo.program AS pg ON ek.programid = pg.programid
		JOIN HMOPROD_PLANDATA.dbo.entity AS ent ON mem.entityid = ent.entid
		JOIN HMOPROD_PlanData.dbo.enrollstatus AS es ON ek.enrollid = es.enrollid		
		JOIN HMOPROD_PLANDATA.dbo.enrollcoverage AS ec ON ek.enrollid = ec.enrollid
		JOIN HMOPROD_PLANDATA.dbo.claim AS c ON ek.memid = c.memid
			AND ek.enrollid = c.enrollid -- planid / programid JOIN
	WHERE CAST(c.startdate AS date) BETWEEN CAST(ek.effdate AS date) AND CAST(ek.termdate AS date) -- RINA: APPLIED TO FIELD WITHIN TABLE TO BE UPDATE
		AND UPPER(LTRIM(RTRIM(ISNULL(ek.segtype,'')))) ='INT'
		-- AND CAST(ek.effdate AS date) <= CAST(dc.calendar_date AS date) --IIF eff AFTER... SEEKING CURRENT PAYTO / PCP
		-- AND CAST(ek.termdate AS date) >= CAST(dc.calendar_date AS date) --IIF termed BEFORE... SEEKING CURRENT PAYTO / PCP	
		-- AND CAST(ek.effdate AS date) <= @when
		-- AND CAST(ek.termdate AS date) >= @when
		AND CAST(ek.termdate AS date) != CAST(ek.effdate AS date)
		AND CAST(ek.termdate AS date) > CAST(ek.effdate AS date)
		) -- CONCLUDE ...
		AS estatus ON su.claimid = estatus.claimid
		-- AS estatus ON su.memid = estatus.memid
			-- AND su.programid = estatus.programid
WHERE CAST(su.DOS AS date) BETWEEN CAST(estatus.effdate AS date) AND CAST(estatus.termdate AS date)	-- RINA: APPLIED TO FIELD WITHIN TABLE TO BE UPDATE







-- =====================================================================
	-- contracted PROVIDER(s) + QUPD TRUST but VERIFY contracted status ci.contracted --
-- =====================================================================
/* x FIVE (5) COMPONENT(s) FIVE (5) table(s) - claim, claimdetail,provider, contractinfo, affiliation */

	-- see clm.ProviderParStatus AS PROVIDER_PAR_STAT, alternative--
	-- CONTRACTED v. NON - CONTRACTED --
UPDATE TABLENAME
SET contractedVerification = LTRIM(RTRIM(ci.contracted))
,capitationVerification = LTRIM(RTRIM(ci.iscapitated))
-- SELECT TOP 10 ' ' AS 'CHECK 1st',aff.provid,prov.fullname,ci.contracted,ci.termdate,ci.effdate,ci.lastupdate,c.[description] AS [CONTRACT_DESCR],bp.[description] AS [BENEFIT PLAN DESCR],prog.[description] AS [PROG DESCR],*,ci.contracted,sip.ProviderParStatus,ci.*,sip.*
-- SELECT DISTINCT ' ' AS 'CHECK 1st',contracted,iscapitated FROM HMOPROD_PLANDATA.dbo.contractinfo
FROM TABLENAME AS su
	JOIN HMOPROD_PLANDATA.dbo.contractinfo AS ci ON su.programid = ci.programid -- ci key#01 smh.programid,
		AND su.affiliationid = ci.affiliationid -- ci key#02 a.affiliationid, -- AFFILIATIONID (REMINDER: within memberpcp AFFILIATIONID is the relationship between PCP + SITE whereas PAYTOAFFILID within memberpcp represents the relationship between PCP + IPA FINALLY within CLAIM table a.provid = PROVIDER a.affiliateid = PAYTO aka VENDOR	
		AND su.contractid = ci.contractid -- ci key#03 see ci.key#04 in WHERE CLAUSE cd.contractid,
		AND su.[NETWORK FLAG] = ci.networkid-- ci key#05 ON clm.contractNetworkId LTRIM(RTRIM(clm.contractnetworkid)) AS [NETWORK FLAG], --DEPRECATED for PROVIDER_PAR_STAT + contractedVerification already present AND to avoid confusion w NetworkID -- ??? (see  INFORMATICS2.dbo.[SHELLprov] was the PARTICIPARTION_FLAG FROM PROVC in D950 OR see ci.contractnetworkid 20140410)
WHERE CAST(su.[DOS] AS date) BETWEEN CAST(ci.effdate AS date) AND CAST(ci.termdate AS date) -- ci key#04







-- ============================================================= 
	-- MS ALLYSON + MS HINA ADJ [UNIT(S)] --
-- =============================================================
UPDATE TABLENAME
SET [QUANTITY] = q.[QUANTITY]
-- SELECT TOP 10 ci.contracted,sip.ProviderParStatus,ci.*,sip.* -- CHECK 1st
-- SELECT DISTINCT contracted,iscapitated FROM HMOPROD_PLANDATA.dbo.contractinfo -- CHECK 1st
FROM TABLENAME AS su
	JOIN 
	( -- INITIATE ...
	SELECT DISTINCT claimid,claimline
	,[QUANTITY] = CASE
	WHEN planid IN ('QMXBP0823','QMXBP0822','QMXBP0850','QMXBP0851') -- ADD DSNP AS OF 20230101 DSNP MEDICARE PLAN	DSNP MCARE	DSNP MCARE	'QMXBP0850' + DSNP MEDI-CAL PLAN	DSNP MCAL	DSNP MCAL
		AND PAID_NET_AMT > 0 
		AND [Primary / Secondary Status] = 'P' 
	THEN servunits
	WHEN planid in  ('QMXBP0823','QMXBP0822','QMXBP0850','QMXBP0851') -- ADD DSNP AS OF 20230101 DSNP MEDICARE PLAN	DSNP MCARE	DSNP MCARE	'QMXBP0850' + DSNP MEDI-CAL PLAN	DSNP MCAL	DSNP MCAL
		AND sum(PAID_NET_AMT) over (partition by memid,provid,dosfrom,dosto,[CPT Service Code],claimline) > PAID_NET_AMT 
		AND [Primary / Secondary Status] = 'S' 
	THEN 0
	WHEN planid IN ('QMXBP0823','QMXBP0822','QMXBP0850','QMXBP0851') -- ADD DSNP AS OF 20230101 DSNP MEDICARE PLAN	DSNP MCARE	DSNP MCARE	'QMXBP0850' + DSNP MEDI-CAL PLAN	DSNP MCAL	DSNP MCAL
		AND sum(PAID_NET_AMT) over (partition by memid,provid,dosfrom,dosto,[CPT Service Code],claimline) = PAID_NET_AMT 
		AND [Primary / Secondary Status] = 'S' 
	THEN servunits
	WHEN planid NOT IN ('QMXBP0823','QMXBP0822','QMXBP0850','QMXBP0851') -- NO NEGATIVE NOT != <> ... -- ADD DSNP AS OF 20230101 DSNP MEDICARE PLAN	DSNP MCARE	DSNP MCARE	'QMXBP0850' + DSNP MEDI-CAL PLAN	DSNP MCAL	DSNP MCAL
	THEN servunits
	ELSE 0 
	END
	-- SELECT TOP 10 ci.contracted,sip.ProviderParStatus,ci.*,sip.* -- CHECK 1st
	-- SELECT DISTINCT contracted,iscapitated FROM HMOPROD_PLANDATA.dbo.contractinfo -- CHECK 1st
	FROM TABLENAME
	) -- CONCLUDE ...
	AS q ON su.claimid = q.claimid
		AND su.claimline = q.claimline

		/* case
		when c.planid in  ('QMXBP0823','QMXBP0822','QMXBP0850','QMXBP0851') and cdet.amountpaid > 0 and es.primarystatus = 'P' then cdet.servunits
		when c.planid in  ('QMXBP0823','QMXBP0822','QMXBP0850','QMXBP0851') and sum(cdet.amountpaid) over (partition by c.memid, c.provid, cdet.dosfrom, cdet.dosto, cdet.servcode, cdet.claimline) > cdet.amountpaid and es.primarystatus = 'S' then 0
		when  c.planid in  ('QMXBP0823','QMXBP0822','QMXBP0850','QMXBP0851') and sum(cdet.amountpaid) over (partition by c.memid, c.provid, cdet.dosfrom, cdet.dosto, cdet.servcode, cdet.claimline) = cdet.amountpaid and es.primarystatus = 'S' then cdet.servunits
		when c.planid not in ('QMXBP0823','QMXBP0822','QMXBP0850','QMXBP0851') then cdet.servunits
		else 0 end Units_adj */







-- =====================================================================
	-- INCLUSION / EXCLUSION by ... --
-- =====================================================================
/* UPDATE TABLENAME -- RESET ...
SET [NOTE(S)] = CAST(NULL AS nvarchar(MAX))

UPDATE TABLENAME
SET [NOTE(S)] = 'KEEP'
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st',[Primary / Secondary Status]
-- SELECT [Primary / Secondary Status],COUNT(1)
FROM TABLENAME AS su	
WHERE ISNULL(su.[Primary / Secondary Status],'') = 'P' -- PRIMARY ONLY !!!
	AND UPPER(LTRIM(RTRIM(ISNULL(su.provid,'')))) IN -- [RENDERING] -- AFFILIATIONID is the relationship between the a.provid = PROVIDER AND the a.affiliateid = PAYTO aka VENDOR
( -- INITIATE ...
SELECT DISTINCT provid FROM #PROVISOLATION 
) -- CONCLUDE ... 

UPDATE TABLENAME
SET [NOTE(S)] = 'KEEP'
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st',[Primary / Secondary Status]
FROM TABLENAME AS su	
WHERE ISNULL(su.[Primary / Secondary Status],'') = 'P' -- PRIMARY ONLY !!!
	AND UPPER(LTRIM(RTRIM(ISNULL(su.PAYTO,'')))) IN  -- [PAYTO] -- AFFILIATIONID is the relationship between the a.provid = PROVIDER AND the a.affiliateid = PAYTO aka VENDOR
( -- INITIATE ...
SELECT DISTINCT provid FROM #PROVISOLATION 
) -- CONCLUDE ... 

		DELETE TABLENAME
		-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
		-- SELECT DISTINCT ' ' AS 'CHECK 1st'
		FROM TABLENAME
		WHERE ISNULL([NOTE(S)],'DELETE') = 'DELETE'

UPDATE TABLENAME -- RESET ... 
SET [NOTE(S)] = CAST(NULL AS nvarchar(MAX)) */







-- ============================================================= 
	-- SUMMARY / SUBTOTAL() ROLLUP v. CUBE --
-- =============================================================
SELECT ' ' AS 'BASELINE SUMMARY',GETDATE() AS [TimeStamp],LINE_OF_BUSINESS,[RANGE NOTE(s)]
,MIN (TRY_CONVERT(date,DOS)) AS [START OF DOS RANGE]
,MAX(TRY_CONVERT(date,DOS)) AS [END OF DOS RANGE]
,MAX(su.[CHECK DATE]) AS RUNOUT_DT,SUM([QUANTITY]) AS Qty,SUM(su.BILLED_AMT) AS Billed,SUM(su.ALLOWED_AMT) AS Allowed,SUM(su.NET_AMT) AS Net,SUM(su.PAID_NET_AMT) AS Paid,SUM(su.INT) AS Interest -- ABS(cd.paydiscount) AS [INT]
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM TABLENAME AS su
GROUP BY LINE_OF_BUSINESS,[RANGE NOTE(s)]
ORDER BY LINE_OF_BUSINESS DESC

SELECT 'ESTABLISH SUB & GRAND TOTAL(S)' AS [NOTE(S)],*
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM 
( -- INITIATE ...
SELECT GETDATE() AS [TimeStamp],MAX(su.[RANGE NOTE(s)]) AS [RANGE]
,COALESCE (su.LINE_OF_BUSINESS+' - '+su.PAYTONM,su.LINE_OF_BUSINESS+' -  SUBTOTAL') AS [ROLLUPvCUBE] -- ADD LEADING SPACE FOR SORT / ORDER BY TO SUBTOTAL
,MAX(su.[CHECK DATE]) AS RUNOUT_DT,SUM([QUANTITY]) AS Qty,SUM(su.BILLED_AMT) AS Billed,SUM(su.ALLOWED_AMT) AS Allowed,SUM(su.NET_AMT) AS Net,SUM(su.PAID_NET_AMT) AS Paid,SUM(su.INT) AS Interest -- ABS(cd.paydiscount) AS [INT]
-- ,SUM(EQUIV_allow_compare) AS [EQUIV],SUM(EQUIV_allow_compare_totalmoddiscount) AS [EQUIVtotalmoddiscount]
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM TABLENAME AS su
-- WHERE ...
GROUP BY su.LINE_OF_BUSINESS,su.PAYTONM WITH CUBE -- The CUBE Operator  The CUBE operator is also used in combination with the GROUP BY clause, however the CUBE operator produces results by generating all combinations of columns specified in the “GROUP BY CUBE” clause.
) -- CONCLUDE ...
AS cubesummary
WHERE cubesummary.[ROLLUPvCUBE] IS NOT NULL

UNION -- VERTICAL() STACK DISTINCT()
SELECT 'GRAND TOTAL LINE ' AS [NOTE(S)],GETDATE() AS [TimeStamp],MAX(su.[RANGE NOTE(s)]) AS [RANGE]
,' -  GRAND TOTAL' AS [ROLLUPvCUBE]
,MAX(su.[CHECK DATE]) AS RUNOUT_DT,SUM([QUANTITY]) AS Qty,SUM(su.BILLED_AMT) AS Billed,SUM(su.ALLOWED_AMT) AS Allowed,SUM(su.NET_AMT) AS Net,SUM(su.PAID_NET_AMT) AS Paid,SUM(su.INT) AS Interest -- ABS(cd.paydiscount) AS [INT]
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM TABLENAME AS su
ORDER BY [ROLLUPvCUBE] DESC

		SELECT *
		,CAST(bid.[CASE(S)]*2800.00*1.00 AS money) AS [PROPOSED PAYMENT]
		-- ,CAST(bid.[Alt. CASE(S)]*2800.00*1.00 AS money) AS [Alt. CASE RATE]
		FROM 
		( -- INITIATE ...
		SELECT PAYTONM,[RANGE NOTE(s)]
		-- ,[CPT Service Code],[Service Description]
		,COUNT(DISTINCT(memid)) AS [Unique Member Count],COUNT(DISTINCT(AdmitID)) AS [CASE(S)]
		-- ,COUNT(DISTINCT([Alt. AdmitID])) AS [Alt. CASE(S)]
		,COUNT(DISTINCT(claimid)) AS [CLAIM(S)],SUM(QUANTITY) AS [UNIT(S)],SUM(PAID_NET_AMT) AS [CHGSD PAID AMOUNT]
		-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
		-- SELECT DISTINCT ' ' AS 'CHECK 1st'
		FROM TABLENAME
		GROUP BY PAYTONM,[RANGE NOTE(s)] -- ,[CPT Service Code],[Service Description]
		HAVING SUM(PAID_NET_AMT) != 0
		) -- CONCLUDE ...
		AS bid
		ORDER BY PAYTONM,[RANGE NOTE(s)]

		SELECT [RANGE NOTE(s)],SUM(PAID_NET_AMT) AS [CHGSD PAID AMOUNT],COUNT(DISTINCT(memid)) AS [Unique Member Count],COUNT(DISTINCT(AdmitID)) AS [VISIT(S) / ADMIT(S)],COUNT(DISTINCT([Alt. AdmitID])) AS [Alt. VISIT(S) / ADMIT(S)],COUNT(DISTINCT(claimid)) AS [CLAIM(S)],SUM(QUANTITY) AS [UNIT(S)]
		-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
		-- SELECT DISTINCT ' ' AS 'CHECK 1st'
		FROM TABLENAME
		GROUP BY [RANGE NOTE(s)]
		HAVING SUM(PAID_NET_AMT) != 0
		ORDER BY [RANGE NOTE(s)]

		SELECT [RANGE NOTE(s)],[POS Descr],SUM(PAID_NET_AMT) AS [CHGSD PAID AMOUNT],COUNT(DISTINCT(memid)) AS [Unique Member Count],COUNT(DISTINCT(AdmitID)) AS [VISIT(S) / ADMIT(S)],COUNT(DISTINCT([Alt. AdmitID])) AS [Alt. VISIT(S) / ADMIT(S)],COUNT(DISTINCT(claimid)) AS [CLAIM(S)],SUM(QUANTITY) AS [UNIT(S)]
		-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
		-- SELECT DISTINCT ' ' AS 'CHECK 1st'
		FROM TABLENAME
		GROUP BY [RANGE NOTE(s)],[POS Descr]
		HAVING SUM(PAID_NET_AMT) != 0
		ORDER BY [RANGE NOTE(s)]

		SELECT [RANGE NOTE(s)],prindiag,[prindiag descr],SUM(PAID_NET_AMT) AS [CHGSD PAID AMOUNT],COUNT(DISTINCT(memid)) AS [Unique Member Count],COUNT(DISTINCT(AdmitID)) AS [VISIT(S) / ADMIT(S)],COUNT(DISTINCT([Alt. AdmitID])) AS [Alt. VISIT(S) / ADMIT(S)],COUNT(DISTINCT(claimid)) AS [CLAIM(S)],SUM(QUANTITY) AS [UNIT(S)]
		-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
		-- SELECT DISTINCT ' ' AS 'CHECK 1st'
		FROM TABLENAME
		GROUP BY [RANGE NOTE(s)],prindiag,[prindiag descr]
		HAVING SUM(PAID_NET_AMT) != 0
		ORDER BY [RANGE NOTE(s)]

		SELECT [RANGE NOTE(s)],revcode,[REVCDE Descr],SUM(PAID_NET_AMT) AS [CHGSD PAID AMOUNT],COUNT(DISTINCT(memid)) AS [Unique Member Count],COUNT(DISTINCT(AdmitID)) AS [VISIT(S) / ADMIT(S)],COUNT(DISTINCT([Alt. AdmitID])) AS [Alt. VISIT(S) / ADMIT(S)],COUNT(DISTINCT(claimid)) AS [CLAIM(S)],SUM(QUANTITY) AS [UNIT(S)]
		-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
		-- SELECT DISTINCT ' ' AS 'CHECK 1st'
		FROM TABLENAME
		GROUP BY [RANGE NOTE(s)],revcode,[REVCDE Descr]
		HAVING SUM(PAID_NET_AMT) != 0
		ORDER BY [RANGE NOTE(s)]

		SELECT [RANGE NOTE(s)],[CPT Service Code],[Service Description],SUM(PAID_NET_AMT) AS [CHGSD PAID AMOUNT],COUNT(DISTINCT(memid)) AS [Unique Member Count],COUNT(DISTINCT(AdmitID)) AS [VISIT(S) / ADMIT(S)],COUNT(DISTINCT([Alt. AdmitID])) AS [Alt. VISIT(S) / ADMIT(S)],COUNT(DISTINCT(claimid)) AS [CLAIM(S)],SUM(QUANTITY) AS [UNIT(S)]
		-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
		-- SELECT DISTINCT ' ' AS 'CHECK 1st'
		FROM TABLENAME
		GROUP BY [RANGE NOTE(s)],[CPT Service Code],[Service Description]
		HAVING SUM(PAID_NET_AMT) != 0
		ORDER BY [RANGE NOTE(s)]







-- ============================================================= 
	-- FINAL QA  --
-- =============================================================
SELECT DISTINCT ' ' AS 'QA [RANGE]',MIN (DOS) AS MINdos,MAX(DOS) AS MAXdos,MIN (DOSTHRU) AS MINthrough,MAX(DOSTHRU) AS MAXthrough
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM TABLENAME

SELECT DISTINCT ' ' AS 'QA CPT CODE(S)',[CPT Service Code],[Service Description]
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM TABLENAME

SELECT DISTINCT ' ' AS 'QA PRINDIAG(S)',[prindiag],[prindiag descr]
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM TABLENAME

SELECT DISTINCT ' ' AS 'QA HEADER STATUS & planid',status,planid
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM HMOPROD_PLANDATA.dbo.claim 
WHERE claimid IN  
( -- INITIATE ...
SELECT DISTINCT [claimid]  
FROM TABLENAME
) --CONCLUDE ...







-- =================================================================	
	-- CHECK SPEC TYPE(s) / SPEC DESCR... --
-- =================================================================
--------------------------------------------------------------------------------------------------------------------
	-- Error Trapping: Check If Permanent Table(s) Already Exist(s) And Drop If Applicable --
--------------------------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS #PAYTORENDER -- SQL Server 2016 and later -- DYNAMIC tmp OR STATIC [TABLE] #TableName is a local temporary table visible only in the current session; ##TableName is a GLOBAL temporary table visible to all sessions IN ('TempDB')

SELECT DISTINCT UPPER(LTRIM(RTRIM(ISNULL(pspe.spectype,'')))) AS [Specialty Status],UPPER(LTRIM(RTRIM(ISNULL(spe.specialtycode,'')))) AS SPECcode,UPPER(LTRIM(RTRIM(ISNULL(spe.description,'')))) AS SPECdescr,pspe.spectype
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
INTO #PAYTORENDER
-- SELECT TOP 10 CAST(NULL AS nvarchar(MAX)) AS [SPACING FOR ...],* -- CHECK 1st
-- SELECT DISTINCT TOP 10 UPPER(LTRIM(RTRIM(ISNULL(spe.description,'')))),*  -- CHECK 1st
FROM HMOPROD_PLANDATA.dbo.provider AS prov
	JOIN HMOPROD_PLANDATA.dbo.entity AS ent ON prov.entityid = ent.entid
		LEFT JOIN HMOPROD_PLANDATA.dbo.providertype AS pt ON prov.provtype = pt.provtype
		LEFT JOIN HMOPROD_PLANDATA.dbo.provspecialty AS pspe ON prov.provid = pspe.provid
		LEFT JOIN HMOPROD_PLANDATA.dbo.specialty AS spe ON pspe.specialtycode = spe.specialtycode
WHERE 
( -- INITIATE ...
UPPER(LTRIM(RTRIM(ISNULL(pspe.spectype,'')))) LIKE 'PRIMARY' -- '%%%'
) -- CONCLUDE ...

SELECT DISTINCT ' ' AS [QA RENDERING + PAYTO],u.NPIprovnm,u.PROVNM,piso.SPECdescr,u.NPIpayto,PAYTONM,pto.SPECdescr
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM TABLENAME AS u
	LEFT JOIN #PAYTORENDER AS piso ON u.provid = piso.provid
	LEFT JOIN #PAYTORENDER AS pto ON u.payto = pto.provid
ORDER BY u.PAYTONM
