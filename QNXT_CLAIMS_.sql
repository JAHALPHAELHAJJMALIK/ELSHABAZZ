-- =====================================================================
	-- COMMENT(S) / CHANGE.LOG: --
-- =====================================================================
-- C001: ADD claimdrg 'MS-DRG (Medicare Severity Diagnosis Related Groups) CODES' TO DETAIL AS OF 20240523

-- =====================================================================
	-- DECLARE @PARAMETER(S) / @FILTER(S) --
-- =====================================================================
DECLARE @SearchString AS varchar(255) -- see CREATE TABLE #employee
DECLARE @leadlag AS decimal(9,0)
DECLARE @leadlagmonths AS int
DECLARE @when AS datetime
DECLARE @RangeStartDate AS datetime
DECLARE @RangeEndDate AS datetime
DECLARE @TruevFalse AS binary
DECLARE @DYNAMICLIKE AS nvarchar(255)
DECLARE @LOB AS varchar(255)
DECLARE @memid AS varchar(25)
DECLARE @pos AS varchar(2)
DECLARE @solveforunknown AS decimal(9,3) -- DO THE MATH ... 100% value = (Given value ÷ Given percentage) × 100 ('STEP88_FEESCHED...sql') eg. 100% OF ?

SET @SearchString = 'see "STEP88 DYNAMIC...sql"'
SET @leadlag = -15 -- +- LEAD() LAG() IN ...
SET @leadlagmonths = 12 -- +- LEAD() LAG() IN MONTH(S)
SET @when = NULL
SET @RangeStartDate = DATEADD(MONTH,@leadlag,DATEADD(DAY,1,EOMONTH(GETDATE(),-1))) -- AS [1st of ... MONTH]
-- SET @RangeStartDate = TRY_CONVERT(date,'01/01/'+CAST(DATEPART(yyyy,DATEADD(DAY,1,EOMONTH(GETDATE(),@leadlag))) AS nvarchar(4))) -- AS [1st of ... YEAR]
SET @RangeEndDate = DATEADD(day,-1,DATEADD(MONTH,@leadlagmonths,@RangeStartDate))
SET @TruevFalse = NULL
SET @DYNAMICLIKE = '%'+@SearchString+'%' -- LIKE '%[@PARAMETER]%'
SET @LOB = NULL -- bp.[OPTION(S)]: IN ('COMMUNITY Y MAS (HMO C-SNP)','DSNP MEDI-CAL PLAN','MEDI-CAL BENEFIT PLAN') ... p.[OPTION(S)]: IN ('DSNP MEDI-CAL','DSNP MEDICARE','COMMUNITY Y MAS (HMO C-SNP)','MEDI-CAL') -- ACTIVE LOB LOCK ... 
SET @memid = CAST(NULL AS varchar(25)) -- ISO ON SPECIFIC MEMBER
SET @pos = '02' -- SELECT 'TELEHEALTH ("02") ANALYSIS DUE TO COVID - 19' AS [NOTE(S)],* FROM INFORMATICS2.dbo.SHELLpos
SET @solveforunknown = 1.0 -- DO THE MATH ... 100% value = (Given value ÷ Given percentage) × 100 ('STEP88_FEESCHED...sql') eg. 100% OF ?

		-- SELECT TOP 10 * FROM INFORMATICS.dbo.[uvw_CLAIMS_BILLTYPE]
		-- SELECT TOP 10 * FROM INFORMATICS.dbo.[uvw_CLAIMS_CLMTYPE] -- FACILTY OR PROFESSIONAL ... 
		-- SELECT TOP 10 * FROM INFORMATICS.dbo.[uvw_CLAIMS_PAID] -- SETTLE THE PAID CLAIMS ARGUMENT ...

		SELECT ' ' AS 'SET @PARAM(S)'
		,'BETWEEN '+CAST(CAST(@RangeStartDate AS date) AS varchar(255))+' AND '+CAST(CAST(@RangeEndDate AS date) AS varchar(255)) AS [RANGE NOTE(s)]
		,@leadlag AS [LEADLAG]
		,' ' AS 'FOM USING EOMONTH SQL'
		,DATEADD(DAY,1,EOMONTH(GETDATE(),-2)) AS [1st of PREVIOUS MONTH]
		,DATEADD(DAY,1,EOMONTH(GETDATE(),-1)) AS [1st of CURRENT MONTH]
		,DATEADD(DAY,1,EOMONTH(GETDATE(),0)) AS [1st of NEXT MONTH] -- EOMONTH ( start_date ,[ month_to_add ] )
		,' ' AS 'EOM USING EOMONTH SQL'		
		,EOMONTH(GETDATE(),-1) AS [EO PREVIOUS MONTH]
		,EOMONTH(GETDATE(),0) AS [EO CURRENT MONTH]
		,EOMONTH(GETDATE(),1) AS [EO NEXT MONTH] -- EOMONTH (start_date ,[ month_to_add ])
		,bp.*
		-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
		-- SELECT DISTINCT ' ' AS 'CHECK 1st'
		FROM INFORMATICS.dbo.[uvw_LINE_OF_BUSINESS] AS bp -- HMOPROD_PLANDATA.dbo.benefitplan + HMOPROD_PLANDATA.dbo.program
		WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ... AND ...
			-- AND bp.[LINE_OF_BUSINESS] LIKE ISNULL('%'+@LOB+'%','%')
			AND bp.[PLAN] LIKE ISNULL('%'+@LOB+'%','%')
			-- AND bp.[PROGRAM] LIKE ISNULL('%'+@LOB+'%','%')
	






--------------------------------------------------------------------------------------------------------------------
	-- Error Trapping: Check If Permanent Table(s) Already Exist(s) And Drop If Applicable --
--------------------------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS #SETclaimrange -- SQL Server 2016 and later -- DYNAMIC tmp OR STATIC [TABLE] #TableName is a local temporary table visible only in the current session; ##TableName is a GLOBAL temporary table visible to all sessions IN ('TempDB')

SELECT DISTINCT clm.claimid
,clm.memid
INTO #SETclaimrange
-- SELECT TOP 10 ' ' AS 'CHECK 1st',* 
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM HMOPROD_PLANDATA.dbo.claim AS clm
	JOIN HMOPROD_PLANDATA.dbo.claimdetail AS cd ON clm.claimid = cd.claimid
	JOIN INFORMATICS.dbo.[uvw_LINE_OF_BUSINESS] AS bp on clm.planid = bp.planid	
	-- JOIN INFORMATICS.dbo.[uvw_CLAIMS_PAID] AS pc ON clm.claimid = pc.claimid -- PAID CLAIM(S) ONLY!!!
	-- JOIN #CxCOS AS cx ON clm.claimid = cx.claimid -- COS (Category of Service) ISOLATION see "STEP88_Cx_...sql"
	
	-- JOIN 
	-- ( -- INITIATE ...
	-- SELECT DISTINCT ' ' AS 'APPROVED AUTH(S)',status,referralid,authorizationid
	-- FROM  HMOPROD_PLANDATA.dbo.referral AS r
	-- WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ... AND ...
		-- AND status LIKE '%APPROVED%' -- ONLY CLAIMS WITH AN ... AUTH / REFERRAL
	-- ) -- CONCLUDE ...
	-- AS ar ON c.referralid = ar.authorizationid -- c.referralid OR cd.referralid = ref.authorizationid DISCOVERED ON 20150728 w Stefan Glembocki IN 

		LEFT JOIN HMOPROD_PLANDATA.dbo.affiliation AS a ON clm.affiliationid = a.affiliationid -- REMINDER: within claim(s) tables AFFILIATIONID is the relationship BETWEEN the a.provid = [RENDERING] PROVIDER AND the a.affiliateid = [PAYTO] PROVIDER
		LEFT JOIN HMOPROD_PLANDATA.dbo.provider AS p1 ON a.provid = p1.provid -- [RENDERING]
		LEFT JOIN HMOPROD_PLANDATA.dbo.provider AS p2 ON a.affiliateid = p2.provid -- [PAYTO] (IPAID)
		LEFT JOIN INFORMATICS.dbo.[uvw_CLAIMS_CLMTYPE] AS ct ON clm.formtype = ct.formtype
		LEFT JOIN INFORMATICS.dbo.[uvw_CLAIMS_BILLTYPE] AS sbt ON (LTRIM(RTRIM(clm.facilitycode))+LTRIM(RTRIM(clm.billclasscode))+LTRIM(RTRIM(clm.frequencycode))) = sbt.QNXTbilltype -- HEADER replacement for POS on INCLM claims

WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ... AND ...
	AND clm.enddate >= clm.startdate -- MUST BE TRUE ... NON-CROSSFOOTED RECORDS ARE ACTIVE ...

	AND TRY_CONVERT(date,clm.startdate) <= @RangeEndDate -- WITHIN reporting period [RANGE] OPPOSITION 
	AND TRY_CONVERT(date,ISNULL(clm.enddate,GETDATE())) >= @RangeStartDate -- WITHIN reporting period [RANGE] OPPOSITION
	-- AND TRY_CONVERT(date,clm.startdate) BETWEEN @RangeStartDate AND @RangeEndDate -- by DOS
	-- AND TRY_CONVERT(date,clm.cleandate) BETWEEN @RangeStartDate AND @RangeEndDate -- by RECEIVED DATE
	-- AND TRY_CONVERT(date,clm.paiddate) BETWEEN @RangeStartDate AND @RangeEndDate -- by CHECK DATE
	-- AND TRY_CONVERT(date,clm.adjuddate) BETWEEN @RangeStartDate AND @RangeEndDate -- by POST DATE see DETERMRECON
	-- AND TRY_CONVERT(date,clm.okpaydate) BETWEEN @RangeStartDate AND @RangeEndDate -- CHANGED 20140613 per Burchfield Audit Finding(s) by POST DATE see DETERMRECON
	-- AND TRY_CONVERT(date,clm.paiddate) <= CAST(@cutoffdt AS date)
	-- AND clm.startdate BETWEEN DATEADD(YY,-3, @RangeStartDate) AND @RangeEndDate -- 'ROLLING THREE (3) YEAR(S)'

	-- AND p.description LIKE ISNULL('%'+@LOB+'%','%')
	-- AND bp.description LIKE ISNULL('%'+@LOB+'%','%')

	-- AND clm.claimid IN -- THE ENTIRE CLAIM by [DIAG]
	-- ( -- INITIATE ...
	-- SELECT DISTINCT dx.claimid
	-- FROM HMOPROD_PLANDATA.dbo.claimdiag AS dx
	-- WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ... AND ...
		-- AND UPPER(LTRIM(RTRIM(ISNULL(dx.codeid,'')))) BETWEEN 'E08%' AND 'E13%' -- BETWEEN 'E08' AND 'E13.999' -- see [DMP] + OR ARNOLD_...rar IN ('E08','E09','E10','E11','E13') -- HEDIS Diabetes
	-- ) -- CONCLUDE
	
	-- AND clm.claimid IN -- THE ENTIRE CLAIM by [CPT (CURRENT PROCEDURAL TERMINOLOGY) / PROCEDURE CODE]
	-- ( -- INITIATE 
	-- SELECT DISTINCT claimid 
	-- FROM HMOPROD_PLANDATA.dbo.claimdetail
	-- WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ... AND ...
		-- AND SUBSTRING(UPPER(LTRIM(RTRIM(ISNULL(cd.servcode,'')))),1,5)  IN ('01967','01968')
	-- ) --CONCLUDE ...
	
	-- AND clm.claimid IN -- THE ENTIRE CLAIM by [REVCODE]
	-- ( -- INITIATE 
	-- SELECT DISTINCT claimid
	-- FROM HMOPROD_PLANDATA.dbo.claimdetail
	-- WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ... AND ...
		-- AND CASE
	-- WHEN SUBSTRING(UPPER(LTRIM(RTRIM(ISNULL(cd.revcode,'')))),1,1) = 'Z'
	-- THEN  UPPER(LTRIM(RTRIM(ISNULL(cd.revcode,''))))
	-- WHEN SUBSTRING(UPPER(LTRIM(RTRIM(ISNULL(cd.revcode,'')))),1,1) = '0'
	-- THEN  SUBSTRING(UPPER(LTRIM(RTRIM(ISNULL(cd.revcode,'')))),2,3)
	-- ELSE UPPER(LTRIM(RTRIM(ISNULL(cd.revcode,''))))
	-- END LIKE @revis --LIMIT PLACED ON REVENUE_CODE
	-- ) --CONCLUDE ...
	
	-- AND UPPER(LTRIM(RTRIM(ISNULL(cd.location,'')))) = UPPER(LTRIM(RTRIM(ISNULL(@pos,''))))

	-- AND UPPER(LTRIM(RTRIM(ISNULL(clm.[status],''))))  NOT IN ('DENIED') -- NO NOT NEGATIVE != <> 'DENIED ... FROM DSH rewrite

	-- AND 
	-- ( -- INITIATE ...
	-- UPPER(LTRIM(RTRIM(ISNULL(clm.planid,'')))) LIKE ISNULL('%'+@LOB+'%','%')
		-- /* OR UPPER(LTRIM(RTRIM(ISNULL(cd.planid,'')))) LIKE ISNULL('%'+@LOB+'%','%') -- LINE_OF_BUSINESS FROM EITHER CLAIM(s) [TABLE] */
		-- ) -- CONCLUDE ...

	-- AND UPPER(LTRIM(RTRIM(ISNULL(ct.ClmType,'')))) = UPPER(LTRIM(RTRIM(ISNULL(@clmtype,''))))

	-- AND 
	-- ( -- INITIATE ...
	-- UPPER(LTRIM(RTRIM(ISNULL(clm.facilitycode,''))))+UPPER(LTRIM(RTRIM(ISNULL(clm.billclasscode,''))))+UPPER(LTRIM(RTRIM(ISNULL(clm.frequencycode,'')))) LIKE @bt --HEADER replacement for POS on INCLM claims BILLTYPE
		-- OR UPPER(LTRIM(RTRIM(ISNULL(sbt.QNXTbilltype,'','')))) LIKE @bt --HEADER replacement for POS on INCLM claims BILLTYPE
		-- ) -- CONCLUDE ...

	-- AND clm.memid IN (ISNULL(@memid,clm.memid)) -- ISO ON SPECIFIC MEMBER
	
	-- AND clm.memid IN -- ISO ON SPECIFIC MEMBER
	-- ( -- INITIATE 
	-- SELECT DISTINCT memid
	-- FROM #baselinemembership
	-- ) --CONCLUDE ...

-- ==========================================================
	-- [RENDERING] / [PAYTO] UNION() --
-- ==========================================================
	-- AND UPPER(LTRIM(RTRIM(ISNULL(a.affiliateid,'')))) IN -- [PAYTO]
	-- ( -- INITIATE ...
	-- SELECT DISTINCT provid FROM #PROVISOLATION 
	-- ) -- CONCLUDE ... 

	-- AND UPPER(LTRIM(RTRIM(ISNULL(clm.provid,'')))) IN -- [RENDERING]
	-- ( -- INITIATE ...
	-- SELECT DISTINCT provid FROM #PROVISOLATION 
	-- ) -- CONCLUDE ... 

		-- SELECT * FROM #SETclaimrange







--------------------------------------------------------------------------------------------------------------------
	-- Error Trapping: Check If Permanent Table(s) Already Exist(s) And Drop If Applicable --
--------------------------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS TABLENAME; -- SQL Server 2016 and later -- DYNAMIC tmp OR STATIC [TABLE] #TABLENAME is a local temporary table visible only in the current session; ##TABLENAME is a GLOBAL temporary table visible to all sessions IN ('TempDB')

	-- Main query:
WITH ClaimData AS 
( -- INITIATE ...
SELECT clm.claimid
,clm.memid
,clm.affiliationid
,clm.startdate
,clm.enddate
,clm.cleandate
,clm.paiddate
,clm.adjuddate
,clm.okpaydate
,clm.Dischargedate
,clm.patientstatus
,clm.okpayby
,clm.planid
,clm.totalamt
,clm.totalpaid
,clm.formtype
,clm.facilitycode
,clm.billclasscode
,clm.frequencycode
,clm.drg
,clm.admitsource
,clm.admithour
,clm.contractnetworkid
,clm.[status]
, clm.controlnmb
,clm.referralid
,clm.manualencounter
,clm.isencounter
,clm.resubclaimid
,clm.totextdeductamt
,clm.logdate
,clm.ProviderParStatus
FROM #SETclaimrange AS scr
	JOIN HMOPROD_PLANDATA.dbo.claim AS clm ON scr.claimid = clm.claimid
) -- CONCLUDE ...
SELECT CAST(NULL AS nvarchar(255)) AS [NOTE(s)]
,TRY_CONVERT(nvarchar(255),NULL) AS [Cx]
,TRY_CONVERT(nvarchar(255),NULL) AS [SubCx]
,TRY_CONVERT(nvarchar(255),NULL) AS [DxCx]
,TRY_CONVERT(nvarchar(255),NULL) AS [Age Band]
,TRY_CONVERT(nvarchar(255),NULL) AS [Ethnicity]
,'UTILIZATION BETWEEN '+CAST(CAST(@RangeStartDate AS date) AS varchar(255))+' AND '+CAST(CAST(@RangeEndDate AS date) AS varchar(255)) AS [RANGE NOTE(s)]
,bp.planid,bp.programid,bp.[LINE_OF_BUSINESS]
,a.affiliationid -- REMINDER: within claim(s) tables AFFILIATIONID is the relationship BETWEEN the a.provid = [RENDERING] PROVIDER AND the a.affiliateid = [PAYTO] PROVIDER
,cd.contractid,contrdescr.[CONTRACT DESCRIPTION]
,cd.termid,claimdata.contractnetworkid AS [NETWORK FLAG]
,ClaimData.ProviderParStatus AS [PROVIDER_PAR_STAT]
,contractedVerification = CAST(NULL AS nvarchar(1))
,capitationVerification = CAST(NULL AS nvarchar(1))
,CASE 
WHEN cd.Capitated=-1 
THEN 'Y' 
ELSE 'N' 
END  AS [EncounterFlag]
,claimdata.manualencounter
,claimdata.isencounter
,UPPER(LTRIM(RTRIM(ISNULL(claimdata.[status],'')))) AS [HEADERstatus],UPPER(LTRIM(RTRIM(ISNULL(cd.[status],'')))) AS [DETAILstatus]
,cd.modcode,cd.modcode2,cd.modcode3,cd.modcode4,cd.modcode5
,UPPER(LTRIM(RTRIM(ISNULL(claimdata.claimid,''))))+''+UPPER(LTRIM(RTRIM(ISNULL(cd.claimline,'')))) AS [DupID]
,claimdata.controlnmb AS [Pat. Control No.]
,CAST(UPPER(LTRIM(RTRIM(ISNULL(claimdata.memid,'')))) AS varchar(255))+CAST(UPPER(LTRIM(RTRIM(ISNULL(TRY_CONVERT(date,claimdata.startdate),'')))) AS varchar(10))+CAST(UPPER(LTRIM(RTRIM(ISNULL(a.provid,'')))) AS varchar(255)) AS [AdmitID] -- 'Unique person, date of service, and provider (RENDERING) = one visit' OR 'Unique person, date of service, and NDC = one script'
,CAST(UPPER(LTRIM(RTRIM(ISNULL(claimdata.memid,'')))) AS varchar(255))+CAST(UPPER(LTRIM(RTRIM(ISNULL(TRY_CONVERT(date,claimdata.Dischargedate),'')))) AS varchar(10))+CAST(UPPER(LTRIM(RTRIM(ISNULL(a.provid,'')))) AS varchar(255)) AS [DischargeID] -- 'Unique person, Discharge date, and provider (RENDERING) = one visit' OR 'Unique person, date of service, and NDC = one script'
,CAST(UPPER(LTRIM(RTRIM(ISNULL(claimdata.memid,'')))) AS varchar(255))+CAST(UPPER(LTRIM(RTRIM(ISNULL(TRY_CONVERT(date,claimdata.startdate),'')))) AS varchar(10)) AS [Alt. AdmitID] -- 'Alt. definition Unique person +  date of service'
,CAST(UPPER(LTRIM(RTRIM(ISNULL(claimdata.memid,'')))) AS varchar(255))+CAST(UPPER(LTRIM(RTRIM(ISNULL(TRY_CONVERT(date,claimdata.Dischargedate),'')))) AS varchar(10)) AS [Alt. DischargeID] -- 'Alt. definition Unique person +  Discharge date'
,CAST(NULL AS nvarchar(255)) AS [CIN],CAST(NULL AS nvarchar(255)) AS [SUBSCRID],claimdata.memid,UPPER(LTRIM(RTRIM(ISNULL(sme.fullname,'')))) AS [MEMNM],sme.dob
,[MEMBER_AGE] = TRY_CONVERT(int,(DATEDIFF("dd",TRY_CONVERT(date,sme.dob),TRY_CONVERT(date,claimdata.startdate))/365.25))
,[MEMBER_TRUE_CHRONOLOGICAL_AGE] = CAST(SUBSTRING(CAST(CAST(DATEDIFF("dd",TRY_CONVERT(date,sme.dob),TRY_CONVERT(date,claimdata.startdate))/365.25 AS money) AS nvarchar(25)),1,CHARINDEX('.',CAST(DATEDIFF("dd",TRY_CONVERT(date,sme.dob),TRY_CONVERT(date,claimdata.startdate))/365.25 AS money),1)-1) AS int)
,[MEMBER_TRUE_CHRONOLOGICAL_AGE_AND_HOW_MANY_MTHs] = DATEDIFF("mm",TRY_CONVERT(date,sme.dob),TRY_CONVERT(date,claimdata.startdate))-CAST(SUBSTRING(CAST(CAST(DATEDIFF("dd",TRY_CONVERT(date,sme.dob),TRY_CONVERT(date,claimdata.startdate))/365.25 AS money) AS nvarchar(25)),1,CHARINDEX('.',CAST(DATEDIFF("dd",TRY_CONVERT(date,sme.dob),TRY_CONVERT(date,claimdata.startdate))/365.25 AS money),1)-1) AS int)*12
,a.provid -- REMINDER: within claim(s) tables AFFILIATIONID is the relationship BETWEEN the a.provid = [RENDERING] PROVIDER AND the a.affiliateid = [PAYTO] PROVIDER
,UPPER(LTRIM(RTRIM(ISNULL(p1.npi,'')))) AS [NPIprovnm],UPPER(LTRIM(RTRIM(ISNULL(p1.fullname,'')))) AS [PROVNM]
,a.affiliateid AS [PAYTO] -- REMINDER: within claim(s) tables AFFILIATIONID is the relationship BETWEEN the a.provid = [RENDERING] PROVIDER AND the a.affiliateid = [PAYTO] PROVIDER
,UPPER(LTRIM(RTRIM(ISNULL(p2.npi,'')))) AS [NPIpayto],UPPER(LTRIM(RTRIM(ISNULL(p2.fullname,'')))) AS [PAYTONM]
-- ,cd.renderingprovid -- OFF CLAIM RENDERING -- REMOVE AS CAN CAUSE DUP(s) AS OF 20181107
-- ,UPPER(LTRIM(RTRIM(ISNULL(p3.npi,'')))) AS [NPIrendering],UPPER(LTRIM(RTRIM(ISNULL(p3.fullname,'')))) AS [RENDERINGNM] -- REMOVE AS CAN CAUSE DUP(s) AS OF 20181107
,LTRIM(RTRIM(claimdata.planid)) AS clmLOB
,LTRIM(RTRIM(cd.planid)) AS cdLOB
,UPPER(LTRIM(RTRIM(ISNULL(claimdata.claimid,'')))) AS SEQ_CLAIM_ID,claimdata.claimid,claimdata.resubclaimid,cd.claimline,cd.dosfrom,cd.dosto
,CASE
WHEN LTRIM(RTRIM(claimdata.claimid))  LIKE '%A%'
THEN SUBSTRING(LTRIM(RTRIM(claimdata.claimid)),1,CHARINDEX('A',LTRIM(RTRIM(claimdata.claimid)),1)-1)
WHEN LTRIM(RTRIM(claimdata.claimid))  LIKE '%R%'
THEN SUBSTRING(LTRIM(RTRIM(claimdata.claimid)),1,CHARINDEX('R',LTRIM(RTRIM(claimdata.claimid)),1)-1)
ELSE LTRIM(RTRIM(claimdata.claimid))
END AS [ORIG_REVERSE_APPEND_CLAIMID]
,ct.ClmType,ct.formtype,sbt.QNXTbilltype,sbt.BillTypeDescr
,cd.servunits -- AS [QUANTITY]
,[QUANTITY] = TRY_CONVERT(decimal(9,0),0)
,[HCT LOGIC DAY(S)] = TRY_CONVERT(decimal(9,0),0)
,claimdata.totalamt AS TOTAL_BILLED_AMT
,claimdata.totalpaid AS TOTAL_PAID_AMOUNT
,cd.claimamt AS BILLED_AMT --BILLED (BAP)
,cd.allowedamt AS ALLOWED_AMT  --ALLOWED (BAP)
,cd.amountpaid AS NET_AMT
,cd.amountpaid AS PAID_NET_AMT -- cd.amountpaid PROVEN to represent true COST (see pv.amountpaid AS CHECKAMT)  + PAID (BAP)
,-cd.paydiscount AS [INT] -- INTEREST -- ,ABS(cd.paydiscount) AS [INT]
,cd.ineligibleamt AS [DISALLOWED],cd.cobeligibleamt AS [COB Allowed],cd.extpaidamt AS [COB Paid],claimdata.totextdeductamt AS [COBDeduct],cd.extcoinsuranceamt AS [COB Coinsurance]
,CAST(NULL AS money) AS [Modifier Discount] -- QUPD()
-- ,CAST((cd.amountpaid/@solveforunknown) AS money) AS [WHEN_GIVEN_CONTRACT_EQUIV_paid]
,CAST(NULL AS money) AS [EQUIV_allow_rate]
,CAST(NULL AS money) AS [EQUIV_allow_compare]
-- ,wc.userid,UPPER(LTRIM(RTRIM(ISNULL(CAST(wc.lastname AS varchar(255)),''))))+', '+UPPER(LTRIM(RTRIM(ISNULL(CAST(wc.firstname AS varchar(255)),'')))) AS [USERname]
-- ,UPPER(LTRIM(RTRIM(ISNULL(CAST(wc.lastname AS varchar(255)),'')))) AS [USERlastname]
-- ,UPPER(LTRIM(RTRIM(ISNULL(CAST(wc.firstname AS varchar(255)),'')))) AS [USERfirstname]
,TRY_CONVERT(date,claimdata.startdate) AS [DOS]
,SUBSTRING(CONVERT(varchar(255),TRY_CONVERT(date,claimdata.startdate),112),1,4) AS [YEAR_DOS] -- yyyy FROM yyyymmdd
,SUBSTRING(CONVERT(varchar(255),TRY_CONVERT(date,claimdata.startdate),112),1,6) AS [YEARMO_DOS] -- yyyymm FROM yyyymmdd
,SUBSTRING(CONVERT(varchar(255),TRY_CONVERT(date,claimdata.startdate),112),5,2) AS [MTH_DOS] -- mm FROM yyyymmdd
,UPPER(LTRIM(RTRIM(ISNULL(CAST(DATENAME(MONTH,TRY_CONVERT(date,claimdata.startdate)) AS varchar(3)),'')))) AS [ABBREV_MONTHis_DOS]
,TRY_CONVERT(date,claimdata.enddate) AS [DOSTHRU]
,SUBSTRING(CONVERT(varchar(255),TRY_CONVERT(date,claimdata.enddate),112),1,4) AS [YEAR_DOSTHRU] -- yyyy FROM yyyymmdd
,SUBSTRING(CONVERT(varchar(255),TRY_CONVERT(date,claimdata.enddate),112),1,6) AS [YEARMO_DOSTHRU] -- yyyymm FROM yyyymmdd
,SUBSTRING(CONVERT(varchar(255),TRY_CONVERT(date,claimdata.enddate),112),5,2) AS [MTH_DOSTHRU] -- mm FROM yyyymmdd
,UPPER(LTRIM(RTRIM(ISNULL(CAST(DATENAME(MONTH,TRY_CONVERT(date,claimdata.enddate)) AS varchar(3)),'')))) AS [ABBREV_MONTHis_DOSTHRU]
,TRY_CONVERT(date,claimdata.cleandate) AS [RECEIVED DATE]
,SUBSTRING(CONVERT(varchar(255),TRY_CONVERT(date,claimdata.cleandate),112),1,4) AS [YEAR_RECEIVED] -- yyyy FROM yyyymmdd
,SUBSTRING(CONVERT(varchar(255),TRY_CONVERT(date,claimdata.cleandate),112),1,6) AS [YEARMO_RECEIVED] -- yyyymm FROM yyyymmdd
,SUBSTRING(CONVERT(varchar(255),TRY_CONVERT(date,claimdata.cleandate),112),5,2) AS [MTH_RECEIVED] -- mm FROM yyyymmdd
,UPPER(LTRIM(RTRIM(ISNULL(CAST(DATENAME(MONTH,TRY_CONVERT(date,claimdata.cleandate)) AS varchar(3)),'')))) AS [ABBREV_MONTHis_RECEIVED]
,TRY_CONVERT(date,claimdata.paiddate)  AS [CHECK DATE]
,SUBSTRING(CONVERT(varchar(255),TRY_CONVERT(date,claimdata.paiddate),112),1,4) AS [YEAR_CHECKDATE] -- yyyy FROM yyyymmdd
,SUBSTRING(CONVERT(varchar(255),TRY_CONVERT(date,claimdata.paiddate),112),1,6) AS [YEARMO_CHECKDATE] -- yyyymm FROM yyyymmdd
,SUBSTRING(CONVERT(varchar(255),TRY_CONVERT(date,claimdata.paiddate),112),5,2) AS [MTH_CHECKDATE] -- mm FROM yyyymmdd
,UPPER(LTRIM(RTRIM(ISNULL(CAST(DATENAME(MONTH,TRY_CONVERT(date,claimdata.paiddate)) AS varchar(3)),'')))) AS [ABBREV_MONTHis_CHECKDATE]
,TRY_CONVERT(date,claimdata.adjuddate) AS [ADJUDICATE DATE]	
,SUBSTRING(CONVERT(varchar(255),TRY_CONVERT(date,claimdata.adjuddate),112),1,4) AS [YEAR_ADJUDICATE] -- yyyy FROM yyyymmdd
,SUBSTRING(CONVERT(varchar(255),TRY_CONVERT(date,claimdata.adjuddate),112),1,6) AS [YEARMO_ADJUDICATE] -- yyyymm FROM yyyymmdd
,SUBSTRING(CONVERT(varchar(255),TRY_CONVERT(date,claimdata.adjuddate),112),5,2) AS [MTH_ADJUDICATE] -- mm FROM yyyymmdd
,UPPER(LTRIM(RTRIM(ISNULL(CAST(DATENAME(MONTH,TRY_CONVERT(date,claimdata.adjuddate)) AS varchar(3)),'')))) AS [ABBREV_MONTHis_ADJUDICATE]
,TRY_CONVERT(date,claimdata.okpaydate) AS [POST DATE]
,SUBSTRING(CONVERT(varchar(255),TRY_CONVERT(date,claimdata.okpaydate),112),1,4) AS [YEAR_POST] -- yyyy FROM yyyymmdd
,SUBSTRING(CONVERT(varchar(255),TRY_CONVERT(date,claimdata.okpaydate),112),1,6) AS [YEARMO_POST] -- yyyymm FROM yyyymmdd
,SUBSTRING(CONVERT(varchar(255),TRY_CONVERT(date,claimdata.okpaydate),112),5,2) AS [MTH_POST] -- mm FROM yyyymmdd
,UPPER(LTRIM(RTRIM(ISNULL(CAST(DATENAME(MONTH,TRY_CONVERT(date,claimdata.okpaydate)) AS varchar(3)),'')))) AS [ABBREV_MONTHis_POST DATE]
,TRY_CONVERT(date,ISNULL(claimdata.Dischargedate,claimdata.enddate)) AS [DISCHARGE DATE]
,SUBSTRING(CONVERT(varchar(255),TRY_CONVERT(date,ISNULL(claimdata.Dischargedate,claimdata.enddate)),112),1,4) AS [YEAR_DISCHARGE] -- yyyy FROM yyyymmdd
,SUBSTRING(CONVERT(varchar(255),TRY_CONVERT(date,ISNULL(claimdata.Dischargedate,claimdata.enddate)),112),1,6) AS [YEARMO_DISCHARGE] -- yyyymm FROM yyyymmdd
,SUBSTRING(CONVERT(varchar(255),TRY_CONVERT(date,ISNULL(claimdata.Dischargedate,claimdata.enddate)),112),5,2) AS [MTH_DISCHARGE] -- mm FROM yyyymmdd
,UPPER(LTRIM(RTRIM(ISNULL(CAST(DATENAME(MONTH,TRY_CONVERT(date,ISNULL(claimdata.Dischargedate,claimdata.enddate))) AS varchar(3)),'')))) AS [ABBREV_MONTHis_DISCHARGE DATE]
,TRY_CONVERT(date,claimdata.cleandate) AS [TAT_CLEANDATE],TRY_CONVERT(date,cd.createdate) AS [TAT_CREATEDATE],CAST(claimdata.logdate AS datetime) AS [TAT_LOGDATE]
,CAST(NULL AS varchar(255)) AS [Primary / Secondary Status] -- EMPTY SHELL QUPD FIELD
,SUBSTRING(UPPER(LTRIM(RTRIM(ISNULL(cd.servcode,'')))),1,5) AS [CPT Service Code],sp.[CodeDescr] AS [Service Description],cd.revcode,revcde.description AS [REVCDE Descr],cd.location,posdescr.DESCRIPTION AS [POS Descr]
,CASE
WHEN cd.referralid IS NULL
THEN UPPER(LTRIM(RTRIM(ISNULL(claimdata.referralid,''))))
ELSE UPPER(LTRIM(RTRIM(ISNULL(cd.referralid,''))))
END AS AUTH_NUMBER -- c.referralid OR cd.referralid = ref.authorizationid DISCOVERED ON 20150728 w Stefan Glembocki
-- ,[prindiag] = principaldiag.prindiag
-- ,[prindiag descr] = principaldiag.[prindiag descr]
-- ,[PRESENT ON ADMISSION] = principaldiag.[PRESENT ON ADMISSION]
,CAST(NULL AS varchar(255)) AS [prindiag] -- EMPTY SHELL QUPD FIELD,principaldiag.prindiag
,CAST(NULL AS varchar(255)) AS [prindiag descr] -- EMPTY SHELL QUPD FIELD ,principaldiag.[prindiag descr]
,CAST(NULL AS nvarchar(255)) AS [PRESENT ON ADMISSION]
,claimdata.drg --ADD ON TO MAKE DISTINCTION BETWEEN [DELIV_TYPE] aka [BIRTH_TYPE], etc... 20171025 'DRG' = Diagnosis Related Group (DRG)
,CAST(NULL AS nvarchar(255)) AS [DRGdescr]
,CAST(NULL AS nvarchar(255)) AS [PROCEDURE_1_CODE]
,claimdata.admitsource,claimdata.admithour,claimdata.dischargedate -- ,r.dischargedate -- FROM HMOPROD_PLANDATA.dbo.referral
,CASE -- see 'STEP88_DISCHARGE_STATUS'...sql
WHEN LTRIM(RTRIM(claimdata.patientstatus)) = '01' THEN 'Discharged to home or self care'
WHEN LTRIM(RTRIM(claimdata.patientstatus)) = '02' THEN 'Discharged/transferred to a short-term general hospital for in-patient care'
WHEN LTRIM(RTRIM(claimdata.patientstatus)) = '03' THEN 'Discharged/transferred to a skilled nursing facility (SNF)'
WHEN LTRIM(RTRIM(claimdata.patientstatus)) = '04' THEN 'Discharged/transferred to an intermediate care facility'
WHEN LTRIM(RTRIM(claimdata.patientstatus)) = '05' THEN 'Discharged/transferred to a non-medicare PPS childrens hospital or non-medicare PPS hospital for inpatient care'
WHEN LTRIM(RTRIM(claimdata.patientstatus)) = '06' THEN 'Discharged/transferred to home under care of organized home health service organization'
WHEN LTRIM(RTRIM(claimdata.patientstatus)) = '07' THEN 'Left against medical advice or discontinued care'
WHEN LTRIM(RTRIM(claimdata.patientstatus)) = '09' THEN 'Admitted as an inpatient to this hospital'
WHEN LTRIM(RTRIM(claimdata.patientstatus)) BETWEEN '10' AND '19' THEN 'Reserved for national assignment'
WHEN LTRIM(RTRIM(claimdata.patientstatus)) = '20' THEN 'Expired'
WHEN LTRIM(RTRIM(claimdata.patientstatus)) BETWEEN '21' AND '29' THEN 'Reserved for national assignment'
WHEN LTRIM(RTRIM(claimdata.patientstatus)) = '30' THEN 'Still a patient'
WHEN LTRIM(RTRIM(claimdata.patientstatus)) BETWEEN '31' AND'39' THEN 'Reserved for national assignment'
WHEN LTRIM(RTRIM(claimdata.patientstatus)) = '40' THEN 'Expired at home'
WHEN LTRIM(RTRIM(claimdata.patientstatus)) = '41' THEN 'Expired in a medical facility'
WHEN LTRIM(RTRIM(claimdata.patientstatus)) = '42' THEN 'Expired -- place unknown'
WHEN LTRIM(RTRIM(claimdata.patientstatus)) = '43' THEN 'Discharged/transferred to a federal hospital'
WHEN LTRIM(RTRIM(claimdata.patientstatus)) BETWEEN '44' AND '49' THEN 'Reserved for national assignment'
WHEN LTRIM(RTRIM(claimdata.patientstatus)) = '50' THEN 'Hospice -- home'
WHEN LTRIM(RTRIM(claimdata.patientstatus)) = '51' THEN 'Hospice -- medical facility'
WHEN LTRIM(RTRIM(claimdata.patientstatus)) BETWEEN '52' AND '60' THEN 'Reserved for national assignment'
WHEN LTRIM(RTRIM(claimdata.patientstatus)) = '61' THEN 'Discharged/transferred within this institution to a hospital-based Medicare approved swing bed'
WHEN LTRIM(RTRIM(claimdata.patientstatus)) = '62' THEN 'Discharged/transferred to another rehabilitation facility including rehabilitation distinct part units of a hospital'
WHEN LTRIM(RTRIM(claimdata.patientstatus)) = '63' THEN 'Discharged/transferred to a long-term care hospital'
WHEN LTRIM(RTRIM(claimdata.patientstatus)) = '64' THEN 'Discharged/transferred to a nursing facility certified under Medicaid but not certified under Medicare'
WHEN LTRIM(RTRIM(claimdata.patientstatus)) = '65' THEN 'Discharged/transferred to a psychiatric hospital or psychiatric distinct part unit of a hospital'
WHEN LTRIM(RTRIM(claimdata.patientstatus)) = '66' THEN 'Discharged/transferred to a to a critical access hospital'
WHEN LTRIM(RTRIM(claimdata.patientstatus)) BETWEEN '67' AND '70' THEN 'Reserved for national assignment'
WHEN LTRIM(RTRIM(claimdata.patientstatus)) BETWEEN '73' AND '99' THEN 'Reserved for national assignment'
ELSE 'TBD'
END AS DischargeDescription,claimdata.patientstatus -- x see 'JAHDischargeStatus_PatientStatus_20160223.pdf'
,0 AS [How many months with plan],claimdata.okpayby,ISNULL(claimdata.okpayby,'N/A') AS [Decision Maker for modification / denial / deferrals]
,'Q'+DATENAME(qq,TRY_CONVERT(date,claimdata.okpaydate))+' '+DATENAME(yyyy,TRY_CONVERT(date,claimdata.okpaydate)) AS [DetermQuarter BY POST DATE]
,RTRIM(cdrg.finaldrg) + '-' + RTRIM(cdrg.SeverityOfIllness) AS [finalDRG+SOI],cdrg.subdrg,cdrg.moddrg,cdrg.finaldrg -- 1.	For select specialty’s proposed rate of “$460 per session per day for Dialysis (MS-DRG codes 800-809)”, is one claim the equivalent of “one session per day”? ... 
INTO TABLENAME
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st' 
FROM ClaimData -- REFERENCING: ClaimData CTE instead of clm table
	JOIN HMOPROD_PLANDATA.dbo.claimdetail AS cd ON claimdata.claimid = cd.claimid

		LEFT JOIN HMOPROD_PLANDATA.dbo.claimdrg AS cdrg ON claimdata.claimid = cdrg.claimid -- C001: ADD claimdrg 'MS-DRG (Medicare Severity Diagnosis Related Groups) CODES' TO DETAIL AS OF 20240523
			AND cdrg.finaldrg+cdrg.SeverityOfIllness IS NOT NULL -- ISOLATES FOR APR DRG OR ???

			LEFT JOIN INFORMATICS.dbo.[uvw_LINE_OF_BUSINESS] AS bp on claimdata.planid = bp.planid

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
			SELECT [CONTRACT DESCRIPTION] = UPPER(LTRIM(RTRIM(ISNULL(CAST(description AS nvarchar(255)),'')))),contractid 
			FROM HMOPROD_PLANDATA.dbo.contract 
			WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ... AND ...
				AND UPPER(LTRIM(RTRIM(ISNULL(CAST(description AS nvarchar(255)),'')))) != ''
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

			LEFT JOIN HMOPROD_PLANDATA.dbo.member AS sme ON claimdata.memid = sme.memid
			LEFT JOIN INFORMATICS.dbo.[uvw_CLAIMS_CLMTYPE] AS ct ON claimdata.formtype = ct.formtype
			LEFT JOIN INFORMATICS.dbo.[uvw_CLAIMS_BILLTYPE] AS sbt ON (LTRIM(RTRIM(claimdata.facilitycode))+LTRIM(RTRIM(claimdata.billclasscode))+LTRIM(RTRIM(claimdata.frequencycode))) = sbt.QNXTbilltype -- HEADER replacement for POS on INCLM claims
			LEFT JOIN HMOPROD_PLANDATA.dbo.affiliation AS a ON claimdata.affiliationid = a.affiliationid -- REMINDER: within claim(s) tables AFFILIATIONID is the relationship BETWEEN the a.provid = [RENDERING] PROVIDER AND the a.affiliateid = [PAYTO] PROVIDER
			LEFT JOIN HMOPROD_PLANDATA.dbo.provider AS p1 ON a.provid = p1.provid -- [RENDERING]
			LEFT JOIN HMOPROD_PLANDATA.dbo.provider AS p2 ON a.affiliateid = p2.provid; -- [PAYTO] (IPAID)
			-- LEFT JOIN HMOPROD_PLANDATA.dbo.provider AS p3 ON cd.renderingprovid = p3.provid -- RENDERING -- REMOVE AS CAN CAUSE DUP(s) AS OF 20181107
			-- LEFT JOIN INFORMATICS2.dbo.quserWC AS wc ON UPPER(LTRIM(RTRIM(ISNULL(cd.createid,'')))) = UPPER(LTRIM(RTRIM(ISNULL(wc.loginid,'')))) -- IMPORT FROM LEFT JOIN SQLPROD01.HMOPROD_QCSIDB.dbo.quser AS q on q.userid = cd.createid see 'QUSER_'...xlsx

	-- ADD indexes to improve query performance
CREATE NONCLUSTERED INDEX idx_REFACTOR_DupID ON TABLENAME ([DupID]);

	-- Check for DUP(s) --
SELECT ' ' AS 'SHOULD BE NULL DUP Validation',*
-- DELETE
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st',
FROM TABLENAME
WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ... AND ...
	AND [DupID] IN
	( -- INITIATE ...
	SELECT [DupID]
	-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
	-- SELECT DISTINCT ' ' AS 'CHECK 1st',
	FROM TABLENAME AS dup
	GROUP BY [DupID] -- Duplication Driver 
	HAVING COUNT(1)>1 -- HAVING clause RESERVED for AGGREGATE(s) ... HAVING SUM(PAID_NET_AMT) != 0
	) -- CONCLUDE ...







-- =====================================================================
	-- [Cx] / [COS] CATEGORY OF SERVICE ASSIGNMENT--
-- =====================================================================
/* UPDATE TABLENAME
SET [Cx] = CAST(NULL AS nvarchar(255)) -- RESET RESTART REFRESH

-- MERGE INTO TABLENAME AS target
-- USING (
    -- SELECT su.AdmitID, 
           -- CASE 
               -- WHEN er.AdmitID IS NOT NULL THEN 'ER'
               -- ELSE NULL
           -- END AS NewCx
    -- FROM TABLENAME AS su
		-- JOIN #ERClaims AS er ON su.AdmitID = er.AdmitID
-- ) AS source ON (target.AdmitID = source.AdmitID)
-- WHEN MATCHED THEN
    -- UPDATE SET [Cx] = source.NewCx;

UPDATE TABLENAME
SET [Cx] = 'ER'
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM TABLENAME AS su
	JOIN #ERClaims AS er ON su.AdmitID = er.AdmitID */
	
	




	
-- =====================================================================
	-- QUPD [PROCEDURE_1_CODE] --
-- =====================================================================
UPDATE TABLENAME
SET PROCEDURE_1_CODE = pcode
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM TABLENAME AS su
	JOIN HMOPROD_PLANDATA.dbo.claimproc AS cp ON su.claimid = cp.claimid
WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ... AND ...
	AND ISNULL(proctype,'') = 'Primary'
	AND su.claimline = '1'







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
	SELECT aliassetup.*
	-- ,DENSE_RANK() OVER (PARTITION BY aliassetup.claimid ORDER BY aliassetup.sequence ASC,aliassetup.codeid DESC) AS [RANKis]
	-- ,ROW_NUMBER() OVER (PARTITION BY aliassetup.claimid ORDER BY aliassetup.sequence ASC,aliassetup.codeid DESC) AS [ROWis]
	-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
	-- SELECT DISTINCT ' ' AS 'CHECK 1st'	
	FROM 
	( -- INITIATE ...
	SELECT DISTINCT dx.claimid
	,dx.codeid
	,UPPER(LTRIM(RTRIM(ISNULL(dx.codeid,'')))) AS [diag]
	,ISNULL(dc.DESCRIPTION,'') AS [diag descr]
	,dx.sequence
	,dx.poa AS [PRESENT ON ADMISSION]
	-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
	-- SELECT DISTINCT ' ' AS 'CHECK 1st'	
	FROM HMOPROD_PLANDATA.dbo.claimdiag AS dx
		LEFT JOIN HMOPROD_PLANDATA.dbo.DiagCode AS dc ON dx.codeid = dc.codeid
	) -- CONCLUDE
	AS aliassetup
	) -- CONCLUDE
	AS alias
	WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ... AND ...
		AND alias.sequence = 1 -- BETWEEN 1 AND 9
		-- AND alias.[RANKis] = 1
		-- AND alias.[ROWis] = 1
	) -- CONCLUDE ...
	AS principaldiag ON su.claimid = principaldiag.claimid







-- =============================================================
	-- QUPD MEMBERSHIP demog -- 
-- =============================================================
DECLARE @whichcin nvarchar(255)

SET @whichcin = 'MA020' --[MemberAttribute](s) CIN

UPDATE TABLENAME
SET SUBSCRID = SUBSTRING(UPPER(LTRIM(RTRIM(ISNULL(ek.carriermemid,'')))),1,10)
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM TABLENAME AS su
	JOIN HMOPROD_PLANDATA.dbo.enrollkeys AS ek ON su.memid = ek.memid
WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ... AND ...
	AND ISNULL(ek.carriermemid,'') != '' -- NOT <> !=
	AND UPPER(LTRIM(RTRIM(ISNULL(su.SUBSCRID,'')))) = ''
	AND CAST(ek.effdate AS datetime) <= CAST(GETDATE() AS datetime) --IIF eff AFTER....
	AND CAST(ek.termdate AS datetime) >= CAST(GETDATE() AS datetime) --IIF termed BEFORE...
	AND CAST(ek.termdate AS datetime) != CAST(ek.effdate AS datetime)
	AND CAST(ek.termdate AS datetime) > CAST(ek.effdate AS datetime)
	
UPDATE TABLENAME
SET SUBSCRID = SUBSTRING(UPPER(LTRIM(RTRIM(ISNULL(ek.carriermemid,'')))),1,10)
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM TABLENAME AS su
	JOIN HMOPROD_PLANDATA.dbo.enrollkeys AS ek ON su.memid = ek.memid
WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ... AND ...
	AND ISNULL(ek.carriermemid,'') != '' -- NOT <> !=
	AND UPPER(LTRIM(RTRIM(ISNULL(su.SUBSCRID,'')))) = ''
	AND CAST(ek.termdate AS datetime) != CAST(ek.effdate AS datetime)
	AND CAST(ek.termdate AS datetime) > CAST(ek.effdate AS datetime) 

UPDATE TABLENAME
SET [CIN] = SUBSTRING(UPPER(LTRIM(RTRIM(ISNULL(ma.TheValue,'')))),1,9)
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM TABLENAME AS su
	JOIN HMOPROD_PLANDATA.dbo.memberattribute AS ma ON su.memid = ma.memid
WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ... AND ...
	AND UPPER(LTRIM(RTRIM(ISNULL(su.[CIN],'')))) = ''
	AND UPPER(LTRIM(RTRIM(ISNULL(ma.attributeid,'')))) IN (@whichcin) -- SET @whichcin = 'MA020' --[MemberAttribute](s) CIN
	AND CAST(ma.effdate AS datetime) <= CAST(GETDATE() AS datetime) --IIF eff AFTER....
	AND CAST(ma.termdate AS datetime) >= CAST(GETDATE() AS datetime) --IIF termed BEFORE...
	AND CAST(ma.termdate AS datetime) != CAST(ma.effdate AS datetime)
	AND CAST(ma.termdate AS datetime) > CAST(ma.effdate AS datetime)	

UPDATE TABLENAME
SET [CIN] = SUBSTRING(UPPER(LTRIM(RTRIM(ISNULL(ma.TheValue,'')))),1,9)
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM TABLENAME AS su
	JOIN HMOPROD_PLANDATA.dbo.memberattribute AS ma ON su.memid = ma.memid
WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ... AND ...
	AND UPPER(LTRIM(RTRIM(ISNULL(su.[CIN],'')))) = ''
	AND UPPER(LTRIM(RTRIM(ISNULL(ma.attributeid,'')))) IN (@whichcin) -- SET @whichcin = 'MA020' --[MemberAttribute](s) CIN
	AND CAST(ma.termdate AS datetime) != CAST(ma.effdate AS datetime)
	AND CAST(ma.termdate AS datetime) > CAST(ma.effdate AS datetime)	
	
UPDATE TABLENAME
SET [CIN] = SUBSTRING(UPPER(LTRIM(RTRIM(ISNULL(mem.secondaryid,'')))),1,9)
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM TABLENAME AS su
	JOIN HMOPROD_PLANDATA.dbo.member AS mem ON su.memid = mem.memid
WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ... AND ...
	AND UPPER(LTRIM(RTRIM(ISNULL(su.[CIN],'')))) = ''
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
	SELECT DISTINCT c.claimid,es.primarystatus AS [Plan Position Status],ek.carriermemid,ek.memid,es.effdate,es.termdate,es.primarystatus AS [STATUS INDICATOR],ec.ratecode,bp.programid,bp.planid,bp.[LINE_OF_BUSINESS],ek.enrollid
	-- SELECT TOP 10 estatus.[STATUS INDICATOR],su.* -- CHECK 1st
	-- SELECT DISTINCT ' ' AS 'CHECK 1st'
	FROM HMOPROD_PLANDATA.dbo.enrollkeys AS ek
		JOIN HMOPROD_PLANDATA.dbo.member AS mem ON ek.memid = mem.memid
			LEFT JOIN INFORMATICS.dbo.[uvw_LINE_OF_BUSINESS] AS bp ON ek.programid = bp.programid
		JOIN HMOPROD_PLANDATA.dbo.program AS pg ON ek.programid = pg.programid
		JOIN HMOPROD_PLANDATA.dbo.entity AS ent ON mem.entityid = ent.entid
		JOIN HMOPROD_PlanData.dbo.enrollstatus AS es ON ek.enrollid = es.enrollid		
		JOIN HMOPROD_PLANDATA.dbo.enrollcoverage AS ec ON ek.enrollid = ec.enrollid
		JOIN HMOPROD_PLANDATA.dbo.claim AS c ON ek.memid = c.memid
			AND ek.enrollid = c.enrollid -- planid / programid JOIN
	WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ... AND ...
		AND CAST(c.startdate AS date) BETWEEN CAST(ek.effdate AS date) AND CAST(ek.termdate AS date) -- RINA: APPLIED TO FIELD WITHIN TABLE TO BE UPDATE
		AND UPPER(LTRIM(RTRIM(ISNULL(ek.segtype,'')))) ='INT'
		AND CAST(ek.termdate AS date) > CAST(ek.effdate AS date) -- MUST BE TRUE ... NON-CROSSFOOTED RECORDS ARE ACTIVE ...		
		) -- CONCLUDE ...
		AS estatus ON su.claimid = estatus.claimid
WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ... AND ...
	AND CAST(su.DOS AS date) BETWEEN CAST(estatus.effdate AS date) AND CAST(estatus.termdate AS date)	-- RINA: APPLIED TO FIELD WITHIN TABLE TO BE UPDATE







-- =====================================================================
	-- contracted PROVIDER(s) + QUPD TRUST but VERIFY contracted status ci.contracted --
-- =====================================================================
/* x FIVE (5) COMPONENT(s) FIVE (5) table(s) - claim, claimdetail,provider, contractinfo, affiliation */
UPDATE TABLENAME
SET contractedVerification = LTRIM(RTRIM(ci.contracted))
,capitationVerification = LTRIM(RTRIM(ci.iscapitated))
-- SELECT TOP 10 ' ' AS 'CHECK 1st',aff.provid,prov.fullname,ci.contracted,ci.termdate,ci.effdate,ci.lastupdate,c.[description] AS [CONTRACT_DESCR],bp.[description] AS [BENEFIT PLAN DESCR],prog.[description] AS [PROG DESCR],*,ci.contracted,sip.ProviderParStatus,ci.*,sip.*
-- SELECT DISTINCT ' ' AS 'CHECK 1st',contracted,iscapitated FROM HMOPROD_PLANDATA.dbo.contractinfo
FROM TABLENAME AS su
	JOIN HMOPROD_PLANDATA.dbo.contractinfo AS ci ON su.programid = ci.programid -- ci key#01 smh.programid,
		AND su.affiliationid = ci.affiliationid -- ci key#02 a.affiliationid, -- AFFILIATIONID (REMINDER: within memberpcp AFFILIATIONID is the relationship between PCP + SITE whereas PAYTOAFFILID within memberpcp represents the relationship between PCP + IPA FINALLY within CLAIM table a.provid = PROVIDER a.affiliateid = PAYTO aka VENDOR	
		AND su.contractid = ci.contractid -- ci key#03 see ci.key#04 in WHERE CLAUSE cd.contractid,
		AND su.[NETWORK FLAG] = ci.networkid-- ci key#05 ON clm.contractNetworkId LTRIM(RTRIM(clm.contractnetworkid)) AS [NETWORK FLAG], -- DEPRECATED for PROVIDER_PAR_STAT + contractedVerification already present AND to avoid confusion w NetworkID ... ??? (see  INFORMATICS2.dbo.[SHELLprov] was the PARTICIPARTION_FLAG FROM PROVC in D950 OR see ci.contractnetworkid 20140410)
WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ... AND ...
	AND CAST(su.[DOS] AS date) BETWEEN CAST(ci.effdate AS date) AND CAST(ci.termdate AS date) -- ci key#04







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
	WHEN planid IN ('QMXBP0823','QMXBP0822','QMXBP0850','QMXBP0851') -- ADD DSNP AS OF 20230101 DSNP MEDICARE PLAN	DSNP MCARE	DSNP MCARE	'QMXBP0850' + DSNP MEDI-CAL PLAN	DSNP MCAL	DSNP MCAL
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
		when c.planid IN ('QMXBP0823','QMXBP0822','QMXBP0850','QMXBP0851') and cdet.amountpaid > 0 and es.primarystatus = 'P' then cdet.servunits
		when c.planid IN ('QMXBP0823','QMXBP0822','QMXBP0850','QMXBP0851') and sum(cdet.amountpaid) over (partition by c.memid, c.provid, cdet.dosfrom, cdet.dosto, cdet.servcode, cdet.claimline) > cdet.amountpaid and es.primarystatus = 'S' then 0
		when  c.planid IN ('QMXBP0823','QMXBP0822','QMXBP0850','QMXBP0851') and sum(cdet.amountpaid) over (partition by c.memid, c.provid, cdet.dosfrom, cdet.dosto, cdet.servcode, cdet.claimline) = cdet.amountpaid and es.primarystatus = 'S' then cdet.servunits
		when c.planid not in ('QMXBP0823','QMXBP0822','QMXBP0850','QMXBP0851') then cdet.servunits
		else 0 end Units_adj */
		
UPDATE TABLENAME
SET [HCT LOGIC DAY(S)] = t.[QUANTITY]
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM TABLENAME AS t
	JOIN INFORMATICS.dbo.[uvw_CLAIMS_PAID] AS p ON t.claimid = p.claimid -- SETTLE THE PAID CLAIMS ARGUMENT ...
WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ... AND ... 
	AND t.revcode BETWEEN '0110' AND '0219'
	AND t.TOTAL_PAID_AMOUNT > 0
	-- AND t.claimid NOT LIKE '%R%'
	-- AND t.HEADERstatus IN ('ADJUCATED','PAID','PAY','REV','REVERSED','REVSYNCH')
	-- AND t.DETAILstatus NOT IN ('DENY','VOID')
	-- AND ISNULL(t.resubclaimid,'') = '' -- ... AND resubclaimid IS NULL 







-- =====================================================================
	-- INCLUSION / EXCLUSION by ... --
-- =====================================================================
/* UPDATE TABLENAME -- RESET RESFRESH RESTART ...
SET [NOTE(S)] = CAST(NULL AS nvarchar(255))

UPDATE TABLENAME
SET [NOTE(S)] = 'KEEP'

UPDATE TABLENAME
SET [NOTE(S)] = ISNULL([NOTE(S)],'DELETE')'

DELETE TABLENAME
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM TABLENAME
WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ... AND ...
	AND ISNULL([NOTE(S)],'DELETE') = 'DELETE'

UPDATE TABLENAME -- RESET RESFRESH RESTART ...
SET [NOTE(S)] = CAST(NULL AS nvarchar(255)) */







-- ============================================================= 
	-- @PARAM(S) / @DECLARE(S) QA  --
-- =============================================================
SELECT DISTINCT ' ' AS 'QA [RANGE]'
,MIN([DOS]) AS [MIN DOS],MAX([DOS]) AS [MAX DOS]
,MIN([DOSTHRU]) AS [MIN DOSTHRU],MAX([DOSTHRU]) AS [MAX DOSTHRU]
,MIN([RECEIVED DATE]) AS [MIN RECEIVED DATE],MAX([RECEIVED DATE]) AS [MAX RECEIVED DATE]
,MIN([CHECK DATE]) AS [MIN CHECK DATE],MAX([CHECK DATE]) AS [MAX CHECK DATE]
,MIN([ADJUDICATE DATE]) AS [MIN ADJUDICATE DATE],MAX([ADJUDICATE DATE]) AS [MAX ADJUDICATE DATE]
,MIN([POST DATE]) AS [MIN POST DATE],MAX([POST DATE]) AS [MAX POST DATE]
,MIN([DISCHARGE DATE]) AS [MIN DISCHARGE DATE],MAX([DISCHARGE DATE]) AS [MAX DISCHARGE DATE]
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM TABLENAME

SELECT DISTINCT ' ' AS 'QA REV CODE(S)',revcode,[REVCDE Descr]
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
WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ... AND ...
	AND  claimid IN  
	( -- INITIATE ...
	SELECT DISTINCT [claimid]  
	FROM TABLENAME
	) --CONCLUDE ...

SELECT DISTINCT ' ' AS 'QA LOB(S)',[LINE_OF_BUSINESS]
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM TABLENAME







-- ============================================================= 
	-- SUMMARY / SUBTOTAL() ROLLUP v. CUBE --
-- =============================================================
DECLARE @year1_rate AS decimal(9,2) = 2434.00
DECLARE @year2_rate AS decimal(9,2) = 2507.00
DECLARE @year3_rate AS decimal(9,2) = 2583.00

		SELECT @year1_rate AS [PERIOD 1: PROPOSAL RATE],@year2_rate AS [PERIOD 2: PROPOSAL RATE],@year3_rate  AS [PERIOD 3: PROPOSAL RATE]

SELECT ' ' AS 'BASELINE COUNTERPROPOSAL SUMMARY',GETDATE() AS [TimeStamp]
,LINE_OF_BUSINESS
,[RANGE NOTE(s)]
,COUNT(DISTINCT(memid)) AS [Unique Members]
,COUNT(DISTINCT(claimid)) AS [Unique Claims]
,MAX(su.[CHECK DATE]) AS RUNOUT_CHECK_DT
,SUM([HCT LOGIC DAY(S)]) AS [HCT LOGIC DAY(S)]
,SUM(su.BILLED_AMT) AS Billed
,SUM(su.PAID_NET_AMT) AS Paid
,SUM(su.INT) AS Interest -- ABS(cd.paydiscount) AS [INT]
,SUM(CASE WHEN su.[HCT LOGIC DAY(S)] IS NULL THEN su.PAID_NET_AMT ELSE (su.[HCT LOGIC DAY(S)] * @year1_rate) END) AS [Year 1 Counterproposal]
,SUM(CASE WHEN su.[HCT LOGIC DAY(S)] IS NULL THEN su.PAID_NET_AMT ELSE (su.[HCT LOGIC DAY(S)] * @year2_rate) END) AS [Year 2 Counterproposal]  
,SUM(CASE WHEN su.[HCT LOGIC DAY(S)] IS NULL THEN su.PAID_NET_AMT ELSE (su.[HCT LOGIC DAY(S)] * @year3_rate) END) AS [Year 3 Counterproposal]
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st',[Primary / Secondary Status]
FROM TABLENAME AS su
WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ... AND ...
	-- AND [Primary / Secondary Status] = 'P'
GROUP BY LINE_OF_BUSINESS,[RANGE NOTE(s)]
ORDER BY LINE_OF_BUSINESS DESC

SELECT ' ' AS 'BASELINE PRIMARY LIMITED REVCODE COUNTERPROPOSAL SUMMARY',GETDATE() AS [TimeStamp]
,LINE_OF_BUSINESS
,[RANGE NOTE(s)]
,COUNT(DISTINCT(memid)) AS [Unique Members]
,COUNT(DISTINCT(claimid)) AS [Unique Claims]
,MAX(su.[CHECK DATE]) AS RUNOUT_CHECK_DT
,SUM([HCT LOGIC DAY(S)]) AS [HCT LOGIC DAY(S)]
,SUM(su.BILLED_AMT) AS Billed
,SUM(su.PAID_NET_AMT) AS Paid
,SUM(su.INT) AS Interest -- ABS(cd.paydiscount) AS [INT]
--,SUM(CASE WHEN revcode IN ('0120','0206','0200') THEN su.[HCT LOGIC DAY(S)] * @year1_rate ELSE su.PAID_NET_AMT END) AS [Year 1 Counterproposal]
--,SUM(CASE WHEN revcode IN ('0120','0206','0200') THEN su.[HCT LOGIC DAY(S)] * @year2_rate ELSE su.PAID_NET_AMT END) AS [Year 2 Counterproposal]  
--,SUM(CASE WHEN revcode IN ('0120','0206','0200') THEN su.[HCT LOGIC DAY(S)] * @year3_rate ELSE su.PAID_NET_AMT END) AS [Year 3 Counterproposal]
,SUM(CASE WHEN su.[HCT LOGIC DAY(S)] IS NULL THEN su.PAID_NET_AMT ELSE (su.[HCT LOGIC DAY(S)] * @year1_rate) END) AS [Year 1 Counterproposal]
,SUM(CASE WHEN su.[HCT LOGIC DAY(S)] IS NULL THEN su.PAID_NET_AMT ELSE (su.[HCT LOGIC DAY(S)] * @year2_rate) END) AS [Year 2 Counterproposal]  
,SUM(CASE WHEN su.[HCT LOGIC DAY(S)] IS NULL THEN su.PAID_NET_AMT ELSE (su.[HCT LOGIC DAY(S)] * @year3_rate) END) AS [Year 3 Counterproposal]
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st',[Primary / Secondary Status]
FROM TABLENAME AS su
WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ... AND ...
	AND [Primary / Secondary Status] = 'P'
	AND revcode IN ('0120','0206','0200')
GROUP BY LINE_OF_BUSINESS,[RANGE NOTE(s)]
ORDER BY LINE_OF_BUSINESS DESC

SELECT 'ESTABLISH SUB & GRAND TOTAL(S)' AS [NOTE(S)],*
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM 
( -- INITIATE ...
SELECT GETDATE() AS [TimeStamp],MAX(su.[RANGE NOTE(s)]) AS [RANGE]
,COALESCE (LTRIM(RTRIM(ISNULL(su.LINE_OF_BUSINESS,'')))+' - '+LTRIM(RTRIM(ISNULL(su.PAYTONM,''))),LTRIM(RTRIM(ISNULL(su.LINE_OF_BUSINESS,'')))+' {SUBTOTAL} ') AS [ROLLUPvCUBE] -- ADD LEADING SPACE FOR SORT / ORDER BY TO SUBTOTAL
,SUM([QUANTITY]) AS Qty,SUM(su.BILLED_AMT) AS Billed,SUM(su.ALLOWED_AMT) AS Allowed,SUM(su.NET_AMT) AS Net,SUM(su.PAID_NET_AMT) AS Paid,SUM(su.INT) AS Interest -- ABS(cd.paydiscount) AS [INT]
-- ,SUM(EQUIV_allow_compare) AS [EQUIV],SUM(EQUIV_allow_compare_totalmoddiscount) AS [EQUIVtotalmoddiscount]
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM TABLENAME AS su
GROUP BY LTRIM(RTRIM(ISNULL(su.LINE_OF_BUSINESS,''))),LTRIM(RTRIM(ISNULL(su.PAYTONM,''))) WITH CUBE -- The CUBE Operator  The CUBE operator is also used in combination with the GROUP BY clause, however the CUBE operator produces results by generating all combinations of columns specified in the “GROUP BY CUBE” clause.
) -- CONCLUDE ...
AS cubesummary
WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ... AND ...
	AND cubesummary.[ROLLUPvCUBE] IS NOT NULL

UNION -- VERTICAL() STACK DISTINCT()
SELECT 'GRAND TOTAL LINE ' AS [NOTE(S)],GETDATE() AS [TimeStamp],MAX(su.[RANGE NOTE(s)]) AS [RANGE]
,'x:   {GRAND TOTAL}   ' AS [ROLLUPvCUBE]
,SUM([QUANTITY]) AS Qty,SUM(su.BILLED_AMT) AS Billed,SUM(su.ALLOWED_AMT) AS Allowed,SUM(su.NET_AMT) AS Net,SUM(su.PAID_NET_AMT) AS Paid,SUM(su.INT) AS Interest -- ABS(cd.paydiscount) AS [INT]
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM TABLENAME AS su
ORDER BY [ROLLUPvCUBE]

/* SELECT DISTINCT c.claimid,c.totalpaid AS [Total Paid Amount]
	FROM HMOPROD_PlanData.dbo.claim AS c
	WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ... AND ...
		AND c.claimid IN (SELECT DISTINCT claimid FROM TABLENAME) -- SOURCE TABLE RECONCILIATION

SELECT SUM(c.totalpaid) AS [Total Paid Amount]
	FROM HMOPROD_PlanData.dbo.claim AS c
	WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ... AND ...
		AND c.claimid IN (SELECT DISTINCT claimid FROM TABLENAME) -- SOURCE TABLE RECONCILIATION */

SELECT ' ' AS 'PRIMARY BASELINE SUMMARY',GETDATE() AS [TimeStamp]
,LINE_OF_BUSINESS
,[RANGE NOTE(s)]
,COUNT(DISTINCT(memid)) AS [Unique Members]
,MIN (TRY_CONVERT(date,DOS)) AS [MIN() OF RANGE]
,MAX(TRY_CONVERT(date,DOS)) AS [MAX() OF RANGE]
,MAX(su.[CHECK DATE]) AS RUNOUT_DT,SUM([QUANTITY]) AS Qty,SUM(su.BILLED_AMT) AS Billed,SUM(su.ALLOWED_AMT) AS Allowed,SUM(su.NET_AMT) AS Net,SUM(su.PAID_NET_AMT) AS Paid,SUM(su.INT) AS Interest -- ABS(cd.paydiscount) AS [INT]
,(SELECT SUM(c.totalpaid) AS [Total Paid Amount]
	FROM HMOPROD_PlanData.dbo.claim AS c
	WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ... AND ...
		AND c.claimid IN (SELECT DISTINCT claimid FROM TABLENAME) -- SOURCE TABLE RECONCILIATION
		) AS [SOURCE Total Paid Amount CHECK]
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM TABLENAME AS su
WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ... AND ...	
	AND [Primary / Secondary Status] = 'P'
GROUP BY LINE_OF_BUSINESS,[RANGE NOTE(s)]
ORDER BY LINE_OF_BUSINESS DESC

SELECT ' ' AS  'QA OUT OF POCKET COST COMP'
,COUNT(DISTINCT(nested.memid)) AS [Unique Utilizer]
,SUM(nested.[Total Claim Paid Amt]) AS [Total Claim Paid Amt]
,SUM(nested.[Detail Line Paid Amt w Interest]) AS [Detail Line Paid Amt w Interest]
,SUM(nested.[Detail Line Paid Amt]) AS [Detail Line Paid Amt]
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM
( -- INITIATE ...
SELECT c.claimid,c.memid
,MAX(c.totalamt) AS [Total Claim Paid Amt]
,SUM(cd.amountpaid)-SUM(cd.paydiscount) AS [Detail Line Paid Amt w Interest]
,SUM(cd.amountpaid) AS [Detail Line Paid Amt]
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st',billclasscode
FROM HMOPROD_PlanData.dbo.claim AS c (NOLOCK)
	JOIN HMOPROD_PlanData.dbo.claimdetail AS cd (NOLOCK) ON c.claimid = cd.claimid 
WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ... AND ...
	AND c.claimid IN (SELECT DISTINCT claimid FROM TABLENAME) -- SOURCE TABLE RECONCILIATION
GROUP BY c.claimid,c.memid
) -- CONCLUDE ...
AS nested

		-- SELECT ' ' AS 'see "STEP88_FEESCHED_...sql" FOR FINAL CONTRACTING BID / PROPOSAL SUMMARY + DETAIL'

SELECT ' ' AS 'QA - LEVERAGE dash_hct',cost_category
,SUM(admits_visits) AS [admits_visits]
,SUM(days_units) AS [days_units]
,SUM(paid) AS [Paid]
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st',
FROM INFORMATICS.dbo.dash_hct
WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ... AND ...
	AND member_month BETWEEN TRY_CONVERT(date,@RangeStartDate) AND TRY_CONVERT(date,@RangeEndDate)
GROUP BY cost_category







-- =====================================================================
	-- PIVOT() UTIL SAMPLE PAID + UNIT(S)
-- =====================================================================
--------------------------------------------------------------------------------------------------------------------
	-- Error Trapping: Check If Permanent Table(s) Already Exist(s) And Drop If Applicable --
--------------------------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS #gt -- SQL Server 2016 and later -- DYNAMIC tmp OR STATIC [TABLE] #TableName is a local temporary table visible only in the current session; ##TableName is a GLOBAL temporary table visible to all sessions IN ('TempDB')

SELECT ' ' AS 'GRAND TOTAL PIVOT()',t.YEAR_DOS,t.PAYTO AS [PayTo ProviderID],t.PAYTONM AS [PayTo Provider],t.provid AS [Rendering ProviderID],t.PROVNM AS [Rendering Provider]
,SUM(t.PAID_NET_AMT) AS [Paid]
,COUNT(DISTINCT(t.AdmitID)) AS [AdmitVisit]
,COUNT(DISTINCT(t.QUANTITY)) AS [Unit] -- MS ALLYSON Adj. Unit(s)
INTO #gt
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st',MTH_DOS
FROM TABLENAME AS t
GROUP BY t.YEAR_DOS,t.PAYTO,t.PAYTONM,t.provid,t.PROVNM

		SELECT * FROM #gt

SELECT ' ' AS 'PIVOT [Paid]',YEAR_DOS,[PayTo ProviderID],[PayTo Provider],[Rendering ProviderID],[Rendering Provider]
,ISNULL([01],0) AS [JAN],ISNULL([02],0) AS [FEB],ISNULL([03],0) AS [MAR],ISNULL([04],0) AS [APR],ISNULL([05],0) AS [MAY],ISNULL([06],0) AS [JUN],ISNULL([07],0) AS [JUL],ISNULL([08],0) AS [AUG],ISNULL([09],0) AS [SEP],ISNULL([10],0) AS [OCT],ISNULL([11],0) AS [NOV],ISNULL([12],0) AS [DEC]
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'	
FROM 
( -- INITIATE ...
SELECT t.PAYTO AS [PayTo ProviderID],t.PAYTONM AS [PayTo Provider],t.provid AS [Rendering ProviderID],t.PROVNM AS [Rendering Provider],t.YEAR_DOS,t.MTH_DOS
,SUM(t.PAID_NET_AMT) AS [Paid]
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st',MTH_DOS
FROM TABLENAME AS t
GROUP BY t.PAYTO,t.PAYTONM,t.provid,t.PROVNM,t.YEAR_DOS,t.MTH_DOS
) -- CONCLUDE
 AS util
PIVOT 
( -- INITIATE ...
MAX(util.[Paid])
FOR util.MTH_DOS IN ([01],[02],[03],[04],[05],[06],[07],[08],[09],[10],[11],[12])
) -- CONCLUDE ...
AS dxpivot

SELECT ' ' AS 'PIVOT [AdmitVisit]',YEAR_DOS,[PayTo ProviderID],[PayTo Provider],[Rendering ProviderID],[Rendering Provider]
,ISNULL([01],0) AS [JAN],ISNULL([02],0) AS [FEB],ISNULL([03],0) AS [MAR],ISNULL([04],0) AS [APR],ISNULL([05],0) AS [MAY],ISNULL([06],0) AS [JUN],ISNULL([07],0) AS [JUL],ISNULL([08],0) AS [AUG],ISNULL([09],0) AS [SEP],ISNULL([10],0) AS [OCT],ISNULL([11],0) AS [NOV],ISNULL([12],0) AS [DEC]
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'	
FROM 
( -- INITIATE ...
SELECT t.PAYTO AS [PayTo ProviderID],t.PAYTONM AS [PayTo Provider],t.provid AS [Rendering ProviderID],t.PROVNM AS [Rendering Provider],t.YEAR_DOS,t.MTH_DOS
,COUNT(DISTINCT(t.AdmitID)) AS [AdmitVisit]
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st',MTH_DOS
FROM TABLENAME AS t
GROUP BY t.PAYTO,t.PAYTONM,t.provid,t.PROVNM,t.YEAR_DOS,t.MTH_DOS
) -- CONCLUDE
 AS util
PIVOT 
( -- INITIATE ...
MAX(util.[AdmitVisit])
FOR util.MTH_DOS IN ([01],[02],[03],[04],[05],[06],[07],[08],[09],[10],[11],[12])
) -- CONCLUDE ...
AS dxpivot

SELECT ' ' AS 'PIVOT [Unit(s)]',YEAR_DOS,[PayTo ProviderID],[PayTo Provider],[Rendering ProviderID],[Rendering Provider]
,ISNULL([01],0) AS [JAN],ISNULL([02],0) AS [FEB],ISNULL([03],0) AS [MAR],ISNULL([04],0) AS [APR],ISNULL([05],0) AS [MAY],ISNULL([06],0) AS [JUN],ISNULL([07],0) AS [JUL],ISNULL([08],0) AS [AUG],ISNULL([09],0) AS [SEP],ISNULL([10],0) AS [OCT],ISNULL([11],0) AS [NOV],ISNULL([12],0) AS [DEC]
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'	
FROM 
( -- INITIATE ...
SELECT t.PAYTO AS [PayTo ProviderID],t.PAYTONM AS [PayTo Provider],t.provid AS [Rendering ProviderID],t.PROVNM AS [Rendering Provider],t.YEAR_DOS,t.MTH_DOS
,SUM(t.QUANTITY) AS [Unit] -- MS ALLYSON Adj. Unit(s)
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st',MTH_DOS
FROM TABLENAME AS t
GROUP BY t.PAYTO,t.PAYTONM,t.provid,t.PROVNM,t.YEAR_DOS,t.MTH_DOS
) -- CONCLUDE
 AS util
PIVOT 
( -- INITIATE ...
MAX(util.[Unit])
FOR util.MTH_DOS IN ([01],[02],[03],[04],[05],[06],[07],[08],[09],[10],[11],[12])
) -- CONCLUDE ...
AS dxpivot







-- =================================================================	
	-- CHECK [RENDERING] + [PAYTO] SPEC TYPE(s) / SPEC DESCR... --
-- =================================================================
--------------------------------------------------------------------------------------------------------------------
	-- Error Trapping: Check If Permanent Table(s) Already Exist(s) And Drop If Applicable --
--------------------------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS #PAYTORENDER -- SQL Server 2016 and later -- DYNAMIC tmp OR STATIC [TABLE] #TableName is a local temporary table visible only in the current session; ##TableName is a GLOBAL temporary table visible to all sessions IN ('TempDB')

SELECT DISTINCT UPPER(LTRIM(RTRIM(ISNULL(pspe.spectype,'')))) AS [Specialty Status],UPPER(LTRIM(RTRIM(ISNULL(spe.specialtycode,'')))) AS SPECcode,UPPER(LTRIM(RTRIM(ISNULL(spe.description,'')))) AS SPECdescr
,pspe.spectype
,prov.provid,prov.fedid,prov.NPI,prov.ExternalID -- AS [SEQ_PROV_ID]
,PROVNM = UPPER(LTRIM(RTRIM(ISNULL(prov.fullname,'')))) -- PROVIDER NAME
,ent.enttype
,ent.lastname
,ent.firstname
,ent.middlename
,ent.entname
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
INTO #PAYTORENDER
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM HMOPROD_PLANDATA.dbo.provider AS prov
	JOIN HMOPROD_PLANDATA.dbo.entity AS ent ON prov.entityid = ent.entid	
		LEFT JOIN HMOPROD_PLANDATA.dbo.providertype AS pt ON prov.provtype = pt.provtype
		LEFT JOIN HMOPROD_PLANDATA.dbo.provspecialty AS pspe ON prov.provid = pspe.provid
		LEFT JOIN HMOPROD_PLANDATA.dbo.specialty AS spe ON pspe.specialtycode = spe.specialtycode
WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ... AND ...
	AND 
	( -- INITIATE ...
	UPPER(LTRIM(RTRIM(ISNULL(pspe.spectype,'')))) LIKE 'PRIMARY' -- '%%%'
	) -- CONCLUDE ...

		SELECT DISTINCT ' ' AS [QA RENDERING + PAYTO],u.NPIprovnm,u.PROVNM,piso.SPECdescr,u.NPIpayto,PAYTONM,pto.SPECdescr,Cx,SubCx
		-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
		-- SELECT DISTINCT ' ' AS 'CHECK 1st'
		FROM TABLENAME AS u
			LEFT JOIN #PAYTORENDER AS piso ON u.provid = piso.provid
			LEFT JOIN #PAYTORENDER AS pto ON u.payto = pto.provid
		ORDER BY u.PAYTONM
