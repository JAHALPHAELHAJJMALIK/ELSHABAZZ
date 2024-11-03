-- ====================================================================
	-- QNXT MEMBERSHIP --
-- ====================================================================

-- =====================================================================
	-- DECLARE @PARAMETER(S) / @FILTER(S) --
-- =====================================================================
DECLARE @leadlagstart AS decimal(9,0) = -1
DECLARE @leadlagstop AS decimal(9,0) = 0
DECLARE @ClockStart AS datetime = TRY_CONVERT(date,DATEADD(DAY,1,EOMONTH(GETDATE(),@leadlagstart)))
DECLARE @ClockStop AS datetime = TRY_CONVERT(date,EOMONTH(GETDATE(),@leadlagstop))
DECLARE @when AS datetime = TRY_CONVERT(date,GETDATE())
DECLARE @PCPrecordRANK AS int = 1 -- ENTER 1 TO GET() JUST MOST CURRENT [RANKis] see DENSE_RANK() OVER(PARTITION BY ek.memid ORDER BY CAST(ek.effdate AS date) DESC) AS [RANKis] --'RANKis' --RANK by MOST CURRENT EligHx
DECLARE @whichaidcode AS nvarchar(5) = 'MA002' -- AIDCODE aka CMCapCode aka SUBSC_DEPT

		SELECT 'BETWEEN '+CAST(TRY_CONVERT(date,@ClockStart) AS varchar(255))+' AND '+CAST(TRY_CONVERT(date,@ClockStop) AS varchar(255)) AS [CALENDAR RANGE]
		,dc.last_day_in_month AS [EFFECTIVE AS OF WHICH DAY IN GIVEN MONTH?]
		,' ' AS 'FOM USING EOMONTH SQL'
		,DATEADD(DAY,1,EOMONTH(GETDATE(),-2)) AS [1st of PREVIOUS MONTH]
		,DATEADD(DAY,1,EOMONTH(GETDATE(),-1)) AS [1st of CURRENT MONTH]
		,DATEADD(DAY,1,EOMONTH(GETDATE(),0)) AS [1st of NEXT MONTH] -- EOMONTH ( start_date ,[ month_to_add ] )
		,' ' AS 'EOM USING EOMONTH SQL'
		,EOMONTH(GETDATE(),-1) AS [EO PREVIOUS MONTH]
		,EOMONTH(GETDATE(),0) AS [EO CURRENT MONTH]
		,EOMONTH(GETDATE(),1) AS [EO NEXT MONTH] -- EOMONTH (start_date ,[ month_to_add ])
		,dc.*
		FROM INFORMATICS.[dbo].date_calendarISO AS dc
		WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ... AND ...
			-- AND dc.calendar_day = @effday -- EFFECTIVE AS OF WHICH DAY IN GIVEN MONTH?
			AND dc.calendar_date = dc.last_day_in_month -- EFFECTIVE AS OF WHICH DAY IN GIVEN MONTH?			
			AND dc.calendar_date BETWEEN @ClockStart AND @ClockStop

DECLARE @fbufamily nvarchar(25)
DECLARE @fbufull nvarchar(25)

SET @fbufamily = 'MA025' -- JUST FAMILY SEGMENT OF FBU: LTRIM(RTRIM(SUBSTRING(thevalue,6,8))) (eg. BE869140 )
SET @fbufull =  'MA019' -- FULL FBU: [EMPLOYEE_NO] & [SUBSC_DEPT] & "-" & [MEDICAID_NO] (eg. 37 32 - BE86914002  







-----------------------------------------------------------------------------------------------------------------------------
	-- Error Trapping: Check If Permanent Table(s) Already Exist(s) And Drop If Applicable --
-----------------------------------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS #ZIP -- SQL Server 2016 and later -- DYNAMIC tmp OR STATIC [TABLE] TABLENAME is a local temporary table visible only in the current session; TABLENAME is a GLOBAL temporary table visible to all sessions IN ('TempDB')
 
SELECT DISTINCT z.County,SUBSTRING(LTRIM(RTRIM(ISNULL(CAST(z.ZIPCODE AS nvarchar(25)),''))),1,5) AS [ZIPCODE]
,'Medi-Cal' AS [Name of Network]
,'Medi Cal (Medicaid)' AS [Line-of-Business]
-- ,xw.city,xw.region
INTO #ZIP
-- SELECT TOP 10 z.*,xw.city,xw.region -- CHECK 1st
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM INFORMATICS.dbo.SD_COUNTY_ZIP AS z -- was 'INFORMATICS.dbo.SDZIPCODES' see 'CA County Zip Codes_20200110.xlsx' FROM TIMELYACCESS WEBPORTAL
	LEFT JOIN informatics.dbo.region_zip_xwalk AS xw ON SUBSTRING(LTRIM(RTRIM(ISNULL(CAST(z.ZIPCODE AS nvarchar(25)),''))),1,5) = SUBSTRING(LTRIM(RTRIM(ISNULL(xw.zip,''))),1,5) -- From: Allyson Ross Sent: Tuesday, July 26, 2016 2:38 PM To: Walter Carr Subject: Region Table Hi Walter, Thank you for the help with the region zip cross walk. I created a table for our reference. informatics.dbo.region_zip_xwalk

	-- CHECK FOR DUP(S) --
 SELECT ' ' AS 'SHOULD BE NULL DUP Validation',*
 FROM #ZIP
WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ...
	AND LTRIM(RTRIM(ZIPCODE))+LTRIM(RTRIM([Line-of-Business])) IN 
	 ( -- INITIATE ...
	 SELECT LTRIM(RTRIM(dup.ZIPCODE))+LTRIM(RTRIM(dup.[Line-of-Business]))
	 FROM #ZIP AS dup
	 GROUP BY LTRIM(RTRIM(dup.ZIPCODE))+LTRIM(RTRIM(dup.[Line-of-Business])) --Duplication Driver
	 HAVING Count(1)>1 --HAVING clause RESERVED for AGGREGATE(s)
	) -- CONCLUDE ...
	 
		-- SELECT * FROM #ZIP
		
		
		
		
		
		
		
-----------------------------------------------------------------------------------------------------------------------------
	-- Error Trapping: Check If Permanent Table(s) Already Exist(s) And Drop If Applicable --
-----------------------------------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS TABLENAME -- SQL Server 2016 and later -- DYNAMIC tmp OR STATIC [TABLE] TABLENAME is a local temporary table visible only in the current session; TABLENAME is a GLOBAL temporary table visible to all sessions IN ('TempDB')

SELECT *
-- SELECT TRY_CONVERT(date,dc.calendar_date ) AS [Membership Assessment Date],*
INTO TABLENAME
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM 
( -- INITIATE ...
SELECT DISTINCT ' ' AS 'MEMBERSHIP RANKED',*
,DENSE_RANK() OVER(PARTITION BY rankrowsetup.memid ORDER BY TRY_CONVERT(date,rankrowsetup.termdate) DESC,TRY_CONVERT(date,rankrowsetup.effdate) DESC) AS [RANKis] -- RANK by MOST CURRENT EligHx
,ROW_NUMBER() OVER(PARTITION BY rankrowsetup.memid ORDER BY TRY_CONVERT(date,rankrowsetup.termdate) DESC,TRY_CONVERT(date,rankrowsetup.effdate) DESC) AS [ROWis] --RANK by MOST CURRENT EligHx
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM 
( -- INITIATE ...
SELECT DISTINCT bp.[LINE_OF_BUSINESS],TRY_CONVERT(date,dc.calendar_date) AS [Membership Assessment Date]
,ek.effdate,ek.termdate,ek.memid,mem.dob
,UPPER(LTRIM(RTRIM(ISNULL(mem.headofhouse ,''))))AS [Head of Household],SUBSTRING(LTRIM(RTRIM(ek.carriermemid)),1,10) AS [HealthPlanID],SUBSTRING(UPPER(LTRIM(RTRIM(ISNULL(ek.carriermemid,'')))),1,10) AS [SUBSCRIBER_ID],SUBSTRING(UPPER(LTRIM(RTRIM(ISNULL(mem.secondaryid,'')))),1,9) AS [CIN],UPPER(LTRIM(RTRIM(ISNULL(mem.memid,'')))) AS [SEQ_MEMB_ID]
,UPPER(LTRIM(RTRIM(ISNULL(mem.fullname,'')))) AS [MEMNM],ent.lastname,ent.firstname,ent.middlename
,CAST(NULL AS nvarchar(2)) AS [SUBSC_DEPT]
,CAST(NULL AS nvarchar(1)) AS [SPD FLAG] -- see 'STEP88_AIDCODE_SPDVLOOKUP_...sql'
,CAST(NULL AS nvarchar(2)) AS [AIDCODE]
,CAST(NULL AS nvarchar(255)) AS [RATECODE]
,fbuno.FBU
,UPPER(LTRIM(RTRIM(ent.Phyaddr1))) AS [Physical Address 1]
,UPPER(LTRIM(RTRIM(ent.Phyaddr2))) AS [Physical Address 2]
,UPPER(LTRIM(RTRIM(ent.Phycity))) AS [Physical City]
,UPPER(LTRIM(RTRIM(ent.Phystate))) AS [Physical State]
,UPPER(LTRIM(RTRIM(ISNULL(ent.Phycounty,'UNDEFINED COUNTY')))) AS [Physical County] --•	County, if Plan is multi-county
,CASE
WHEN SUBSTRING(LTRIM(RTRIM(ISNULL(CAST(ent.Phyzip AS nvarchar(25)),''))),1,1) = '0'
THEN '0'+ SUBSTRING(LTRIM(RTRIM(ISNULL(CAST(ent.Phyzip AS nvarchar(25)),''))),2,4)
WHEN SUBSTRING(LTRIM(RTRIM(ISNULL(CAST(ent.Phyzip AS nvarchar(25)),''))),1,1) = '00'
THEN '00'+ SUBSTRING(LTRIM(RTRIM(ISNULL(CAST(ent.Phyzip AS nvarchar(25)),''))),3,3)
ELSE  SUBSTRING(LTRIM(RTRIM(ISNULL(CAST(ent.Phyzip AS nvarchar(25)),''))),1,5) 
END AS [Physical Zip]
,UPPER(LTRIM(RTRIM(ent.addr1))) AS [Mailing Address 1]
,UPPER(LTRIM(RTRIM(ent.addr2))) AS [Mailing Address 2]
,UPPER(LTRIM(RTRIM(ent.city))) AS [Mailing City]
,UPPER(LTRIM(RTRIM(ent.state))) AS [Mailing State]
,UPPER(LTRIM(RTRIM(ISNULL(ent.county,'UNDEFINED COUNTY')))) AS [Mailing County] --•	County, if Plan is multi-county
--,UPPER(LTRIM(RTRIM(zip.ZIPCODE))) AS ZIPCODE --SAN DIEGO (SD) COUNTY ONLY!!!
,CASE
WHEN SUBSTRING(LTRIM(RTRIM(ISNULL(CAST(ent.zip AS nvarchar(25)),''))),1,1) = '0'
THEN '0'+ SUBSTRING(LTRIM(RTRIM(ISNULL(CAST(ent.zip AS nvarchar(25)),''))),2,4)
WHEN SUBSTRING(LTRIM(RTRIM(ISNULL(CAST(ent.zip AS nvarchar(25)),''))),1,1) = '00'
THEN '00'+ SUBSTRING(LTRIM(RTRIM(ISNULL(CAST(ent.zip AS nvarchar(25)),''))),3,3)
ELSE  SUBSTRING(LTRIM(RTRIM(ISNULL(CAST(ent.zip AS nvarchar(25)),''))),1,5) 
END AS [Mailing Zip]
,[TELEPHONE] = CASE
WHEN LTRIM(RTRIM(ent.phone)) = ''
THEN SUBSTRING(REPLACE(LTRIM(RTRIM(ent.emerphone)),'-',''),1,10)
ELSE SUBSTRING(REPLACE(LTRIM(RTRIM(ent.phone)),'-',''),1,10)
END,ent.emerphone,ent.faxphone,ent.mobilephone,ent.pagerphone,ent.secfaxphone,ent.secphone,ent.SecureFaxPhone
,UPPER(LTRIM(RTRIM(ISNULL(ent.email,'')))) AS [eMAIL]
,CAST(NULL AS nvarchar(255)) AS RISK_LEVEL
,[MEMBER_TRUE_CHRONOLOGICAL_AGE] = CAST(SUBSTRING(CAST(CAST(DATEDIFF("dd",TRY_CONVERT(date,mem.dob),TRY_CONVERT(date,dc.calendar_date))/365.25 AS money) AS nvarchar(25)),1,CHARINDEX('.',CAST(DATEDIFF("dd",TRY_CONVERT(date,mem.dob),TRY_CONVERT(date,dc.calendar_date))/365.25 AS money),1)-1) AS int)
,[MEMBER_TRUE_CHRONOLOGICAL_AGE_AND_HOW_MANY_MTHs] = DATEDIFF("mm",TRY_CONVERT(date,mem.dob),TRY_CONVERT(date,dc.calendar_date))-CAST(SUBSTRING(CAST(CAST(DATEDIFF("dd",TRY_CONVERT(date,mem.dob),TRY_CONVERT(date,dc.calendar_date))/365.25 AS money) AS nvarchar(25)),1,CHARINDEX('.',CAST(DATEDIFF("dd",TRY_CONVERT(date,mem.dob),TRY_CONVERT(date,dc.calendar_date))/365.25 AS money),1)-1) AS int)*12
,UPPER(LTRIM(RTRIM(mem.sex))) AS GENDER
,CAST(NULL AS nvarchar(255)) AS AGEgroup
,TRY_CONVERT(date,GETDATE()) AS [RUNDT]
,CAST(CONVERT(nvarchar(4),CAST(dc.calendar_date AS datetime),112)+DATENAME(qq, CAST(dc.calendar_date AS datetime)) AS nvarchar(5)) AS [QTRrank] -- yyyyqq
,LTRIM(RTRIM(CONVERT(NVARCHAR(6),CAST(dc.calendar_date AS date),112))) AS YEAR_MO -- 'yyyymm'
,CAST(1 AS int) AS MMcount -- SUM(MMcount) AS MBRMNTHS
,qnxtlang.[Member Preferred Language] -- LTRIM(RTRIM(umem.primarylanguage))
,ISNULL(emeth.[834 EIC Ethnicity],'Unknown') AS [834 EIC Ethnicity]
,ISNULL(emeth.[834 OMBdesc],'Unknown') AS [834 OMB Ethnicity]
,CAST(NULL AS nvarchar(25)) AS PAYTOID
,CAST(NULL AS nvarchar(100)) AS PAYTONM
,CAST(NULL AS nvarchar(25)) AS PCPID
,CAST(NULL AS nvarchar(100)) AS PCPNM
,CAST(NULL AS nvarchar(25)) AS SERVICELOCATIONID --SITE
,CAST(NULL AS nvarchar(100)) AS SERVICELOCATION --SITE
,CAST(0 AS int) AS [CENSUSCOUNT]
,mbi.[MEDICARE_NO] -- 'MBI' Medicare Beneficiary Identifier (MBI) was the HIC# Health Insurance Claim Number (HICN) see "Medicare Beneficiary Identifier (MBI) Understanding-the-MBI-052918.pdf"
,SOGI_RACE
,SOGI_ETHNICITY
,SOGI_GENDER_AT_BIRTH 
,SOGI_SEXUAL_ORIENTATION
,SOGI_GENDER_IDENTITY
,SOGI_HOMELESS
,SOGI_PRONOUNS
,QNXTrace
,QNXTethnicity
,QNXTLanguage
,xw.REGION
,CAST(NULL AS nvarchar(255)) AS [MEMBER_CATEGORY]
,CAST(NULL AS nvarchar(255)) AS [MEMBER_SUBCATEGORY]
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st',
FROM INFORMATICS.[dbo].date_calendarISO AS dc,HMOPROD_PLANDATA.dbo.enrollkeys AS ek -- DO NOT NO NEGATIVE <> != COVER UP THE TE()
	JOIN HMOPROD_PLANDATA.dbo.member AS mem ON ek.memid = mem.memid
	JOIN INFORMATICS.dbo.[uvw_LINE_OF_BUSINESS] AS bp ON ek.programid = bp.programid
	JOIN HMOPROD_PLANDATA.dbo.entity AS ent ON mem.entityid = ent.entid
	-- JOIN HMOPROD_PlanData.dbo.enrollstatus AS es ON ek.enrollid = es.enrollid		
	-- JOIN HMOPROD_PLANDATA.dbo.enrollcoverage AS ec ON ek.enrollid = ec.enrollid

		LEFT JOIN 
		( -- INITIATE ...
		SELECT *
		,DENSE_RANK() OVER (PARTITION BY MemId ORDER BY TermDate DESC) AS [RANKis]
		,ROW_NUMBER() OVER (PARTITION BY MemId ORDER BY TermDate DESC) AS [ROWis]
		FROM 
		( -- INITIATE ...
		SELECT DISTINCT MemId,UPPER(LTRIM(RTRIM(ISNULL(Hic,'')))) AS [MEDICARE_NO],Hic,TermDate
		FROM HMOPROD_PlanData.dbo.MemberCmsHic
		) -- CONCLUDE
		AS alias			
		) -- CONCLUDE ...
		AS mbi ON ek.memid = mbi.MemId -- 'MBI' Medicare Beneficiary Identifier (MBI) was the HIC# Health Insurance Claim Number (HICN) see "Medicare Beneficiary Identifier (MBI) Understanding-the-MBI-052918.pdf"
			AND mbi.[RANKis] = 1
			AND mbi.[ROWis] = 1

		LEFT JOIN informatics.dbo.region_zip_xwalk AS xw ON CASE
		WHEN SUBSTRING(LTRIM(RTRIM(ISNULL(CAST(ent.zip AS nvarchar(25)),''))),1,1) = '0'
		THEN '0'+ SUBSTRING(LTRIM(RTRIM(ISNULL(CAST(ent.zip AS nvarchar(25)),''))),2,4)
		WHEN SUBSTRING(LTRIM(RTRIM(ISNULL(CAST(ent.zip AS nvarchar(25)),''))),1,1) = '00'
		THEN '00'+ SUBSTRING(LTRIM(RTRIM(ISNULL(CAST(ent.zip AS nvarchar(25)),''))),3,3)
		ELSE  SUBSTRING(LTRIM(RTRIM(ISNULL(CAST(ent.zip AS nvarchar(25)),''))),1,5) 
		END = SUBSTRING(LTRIM(RTRIM(ISNULL(xw.zip,''))),1,5) -- From: Allyson Ross Sent: Tuesday, July 26, 2016 2:38 PM To: Walter Carr Subject: Region Table Hi Walter, Thank you for the help with the region zip cross walk. I created a table for our reference. informatics.dbo.region_zip_xwalk
	
	/* JOIN #ZIP AS zip ON CASE
	WHEN SUBSTRING(LTRIM(RTRIM(ISNULL(CAST(ent.zip AS nvarchar(25)),''))),1,1) = '0'
	THEN '0'+ SUBSTRING(LTRIM(RTRIM(ISNULL(CAST(ent.zip AS nvarchar(25)),''))),2,4)
	WHEN SUBSTRING(LTRIM(RTRIM(ISNULL(CAST(ent.zip AS nvarchar(25)),''))),1,1) = '00'
	THEN '00'+ SUBSTRING(LTRIM(RTRIM(ISNULL(CAST(ent.zip AS nvarchar(25)),''))),3,3)
	ELSE  SUBSTRING(LTRIM(RTRIM(ISNULL(CAST(ent.zip AS nvarchar(25)),''))),1,5) 
	END =  zip.ZIPCODE */
	
		LEFT JOIN
		( -- INITIATE ...
		SELECT DISTINCT ' ' AS 'FBU (Family Budget Unit)',*
		FROM 
		( -- INITIATE...
		SELECT DISTINCT ma.memid
		,ma.thevalue AS [FBU]
		,q.description AS [AttribDescr]
		,DENSE_RANK() OVER(PARTITION BY ma.memid ORDER BY TRY_CONVERT(date,ma.effdate) DESC) AS [RANKis] -- RANK() ACCOUNT(s) FOR TIES + RETAINS SEQUENCE ... NO NEGATIVE NOT != <> GAPS IN THE SEQUENCE
		,ROW_NUMBER() OVER(PARTITION BY ma.memid ORDER BY TRY_CONVERT(date,ma.effdate) DESC) AS [ROWis] -- STRAIGHT FORWARD SEQUENCEma.thevalue,ma.memid,q.description 
		FROM HMOPROD_PLANDATA.dbo.qattribute AS q
			JOIN HMOPROD_PlanData.dbo.memberattribute AS ma ON q.attributeid = ma.attributeid
		WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ... AND ...
			AND q.attributeid IN (@fbufamily) -- JUST FAMILY SEGMENT OF FBU: LTRIM(RTRIM(SUBSTRING(thevalue,6,8))) (eg. BE869140 )
		) -- CONCLUDE ...
		AS fbu
		WHERE 1=1
			AND fbu.[RANKis] = 1 -- RANK by MOST CURRENT
			AND fbu.[ROWis] = 1 --RANK by MOST CURRENT
			) -- CONCLUDE ...
			AS fbuno ON mem.memid = fbuno.memid

-- ===========================================================================
	-- SOGI (SEXUAL ORIENTATION AND GENDER IDENTITY) [FIELD(S)] --
-- ===========================================================================
LEFT JOIN -- C002: 6.	Additional LEFT JOINs are used to include SOGI (Sexual Orientation and Gender Identity) data and language information from the QNXT system.
( -- INITIATE ...
SELECT DISTINCT ' ' AS 'ADD SOGI (SEXUAL ORIENTATION AND GENDER IDENTITY) TO SARAG Table 1: ',memid
,SOGI_RACE
,SOGI_ETHNICITY
,SOGI_GENDER_AT_BIRTH 
,SOGI_SEXUAL_ORIENTATION
,SOGI_GENDER_IDENTITY
,SOGI_HOMELESS
,SOGI_PRONOUNS
,QNXTrace,QNXTethnicity,QNXTLanguage
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st',SOGI_RACE
FROM INFORMATICS.dbo.MemberMonths
WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ... AND ...
	-- AND memid IN ('2122369') -- SAMPLE MISSING
) -- CONCLUDE ...
AS sogi ON mem.memid = sogi.memid

-- ===========================================================================
	-- 834 EnrollmentManager ETHNICITY --
-- ===========================================================================
LEFT JOIN 
( -- INITIATE...
SELECT  'OMB (Office of Management and Budget) + EIC (Ethnicity Industry Code)' AS [MESSAGE(S)],eicomb.*
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st',[834 EIC Ethnicity],[834 OMBdesc]
FROM 
( -- INITIATE ...
SELECT DISTINCT SUBSTRING(UPPER(LTRIM(RTRIM(ISNULL(mem.secondaryid,'')))),1,9) AS [CIN]
,mem.memid,mem.fullname
,ISNULL(eic.Description,'Unknown') AS [834 EIC Ethnicity]
,ISNULL(xwalk.OMBdesc,'Unknown') AS [834 OMBdesc]
,DENSE_RANK() OVER(PARTITION BY mem.memid ORDER BY m.fileid DESC) AS [RANKis] -- RANK() ACCOUNT(s) FOR TIES + RETAINS SEQUENCE ... NO NEGATIVE NOT != <> GAPS IN THE SEQUENCE
,ROW_NUMBER() OVER(PARTITION BY mem.memid ORDER BY m.fileid DESC) AS [ROWis] -- STRAIGHT FWD SEQUENCE
-- SELECT TOP 10 ' ' AS 'CHECK 1st',eic.*,xwalk.*
-- SELECT DISTINCT ' ' AS 'CHECK 1st',ISNULL(eic.Description,'Unknown') AS [834 EIC Ethnicity],ISNULL(xwalk.OMBdesc,'Unknown') AS [834 OMB Ethnicity]
FROM HMOPROD_PLANDATA.dbo.member AS mem (NOLOCK)
	JOIN EnrollmentManager.dbo.[Member] AS m (NOLOCK) ON mem.secondaryid = m.ClientIndexNumber
	-- JOIN EnrollmentManager.dbo.[Member] AS m (NOLOCK) ON SUBSTRING(UPPER(LTRIM(RTRIM(ISNULL(mem.secondaryid,'')))),1,9) = SUBSTRING(UPPER(LTRIM(RTRIM(ISNULL(m.ClientIndexNumber,'')))),1,9)
	JOIN EnrollmentManager.dbo.EthnicityIndustryCode AS eic (NOLOCK) ON m.EthnicityIndustryCode = eic.Code
	JOIN informatics.dbo.Ethnicity_EICandOMBDesc_XWalk AS xwalk (NOLOCK) ON xwalk.EIC = eic.Code
) -- CONCLUDE ...
AS eicomb
WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ... AND ... 
	AND eicomb.RANKis = 1
	AND eicomb.ROWis = 1
) -- CONCLUDE ...
AS emeth ON mem.memid = emeth.memid

-- ===========================================================================
	-- ALLYSON + HINA 'LANGUAGE' FROM QNXT FOR RFP --
-- ===========================================================================
LEFT JOIN 
( -- INITIATE...
SELECT DISTINCT ' ' AS 'THRESHOLD LANGUAGE(S) see "CHG Fact Sheet 2023-03-06.docx"','QNXT / RFP [LANGUAGE]' AS [MESSAGE(S)],m.memid,m.secondaryid,SUBSTRING(UPPER(LTRIM(RTRIM(ISNULL(m.secondaryid,'')))),1,9) AS [CIN]
,CASE 
WHEN lang.description = 'NO VALID DATA REPORTED' THEN 'Unknown'
WHEN lang.description = 'No Language' THEN 'Unknown'
WHEN lang.description = 'Undetermined' THEN 'Unknown'
WHEN lang.description = '' THEN 'Unknown'
WHEN lang.description ='English, Old (ca. 450-1100)' THEN 'English'
WHEN lang.description = 'English, Middle (1100-1500)' THEN 'English'
WHEN lang.description = 'English - Large Print' THEN 'English'
WHEN lang.description = 'Spanish - Large Print' THEN 'Spanish'
WHEN lang.description = 'Arabic - Large Print' THEN 'Arabic'
WHEN lang.description = 'Vietnamese - Large Print' THEN 'Vietnamese'
WHEN lang.description = 'Tagalog - Large Print' THEN 'Tagalog'
WHEN lang.description = 'Lao - Large Print' THEN 'Laotian'
ELSE lang.description 
END AS 'Member Preferred Language'
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st',UPPER(LTRIM(RTRIM(ISNULL(lang.description,'ENGLISH')))) FROM HMOPROD_PLANDATA.dbo.language AS lang
FROM HMOPROD_PlanData.dbo.member AS m
	JOIN HMOPROD_PLANDATA.dbo.language AS lang ON m.primarylanguage = lang.languageid
	) -- CONCLUDE ...
-- AS qnxtlang ON alias.memid = qnxtlang.memid
AS qnxtlang ON mem.memid = qnxtlang.memid

WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ... AND ...
	AND UPPER(LTRIM(RTRIM(ISNULL(ek.segtype,'')))) ='INT'
	AND ISNULL(mem.IsSubscriber,'') = 'Y' -- ISO ON SUBSCRIBER ONLY!!!
	AND CAST(ek.termdate AS date) > CAST(ek.effdate AS date) -- MUST BE TRUE ... NON-CROSSFOOTED RECORDS ARE ACTIVE ...
	
	AND dc.calendar_date = dc.last_day_in_month --dc.calendar_day = @effday -- EFFECTIVE AS OF WHICH DAY IN GIVEN MONTH?
	AND dc.calendar_date BETWEEN @ClockStart AND @ClockStop
	AND TRY_CONVERT(date,ek.effdate) <= TRY_CONVERT(date,dc.calendar_date) -- WITHIN reporting period [RANGE] OPPOSITION 
	AND TRY_CONVERT(date,ISNULL(ek.termdate,GETDATE())) >= TRY_CONVERT(date,dc.calendar_date) -- WITHIN reporting period [RANGE] OPPOSITION
) -- CONCLUDE ...
AS rankrowsetup
) -- CONCLUDE ...
AS baselinem

CREATE INDEX idx_REFACTOR_DupID ON TABLENAME (memid,effdate);

	-- CHECK FOR DUP(S) --
SELECT ' ' AS 'SHOULD BE NULL DUP Validation',*
FROM TABLENAME
WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ...
	AND LTRIM(RTRIM(memid))+LTRIM(RTRIM(YEAR_MO))+LTRIM(RTRIM([LINE_OF_BUSINESS])) IN 
	( -- INITIATE ...
	SELECT LTRIM(RTRIM(memid))+LTRIM(RTRIM(YEAR_MO))+LTRIM(RTRIM([LINE_OF_BUSINESS]))
	FROM TABLENAME AS dup
	GROUP BY LTRIM(RTRIM(memid))+LTRIM(RTRIM(YEAR_MO))+LTRIM(RTRIM([LINE_OF_BUSINESS])) -- Duplication Driver 
	HAVING COUNT(1)>1 -- HAVING clause RESERVED for AGGREGATE(s) ... HAVING SUM(PAID_NET_AMT) != 0
	) -- CONCLUDE ...







-- ==================================================
	-- memberattribute QUPD(s) --
-- ==================================================	
UPDATE TABLENAME
SET [SUBSC_DEPT] = SUBSTRING(UPPER(LTRIM(RTRIM(ISNULL(TheValue,'')))),1,2)
,[AIDCODE] = SUBSTRING(UPPER(LTRIM(RTRIM(ISNULL(TheValue,'')))),1,2)
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM TABLENAME AS sm
	JOIN HMOPROD_PLANDATA.dbo.memberattribute AS ma ON LTRIM(RTRIM(sm.SEQ_MEMB_ID)) = LTRIM(RTRIM(ma.memid))
	AND CAST(GETDATE() AS date) BETWEEN ma.effdate AND ma.termdate
	AND (sm.[SUBSC_DEPT] IS NULL
		OR LTRIM(RTRIM(sm.[SUBSC_DEPT])) = '')

/* UPDATE TABLENAME
SET [RATECODE] = UPPER(LTRIM(RTRIM(ISNULL(ec.ratecode,''))))
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM TABLENAME AS t
	JOIN HMOPROD_PLANDATA.dbo.enrollkeys AS ek ON UPPER(LTRIM(RTRIM(ISNULL(t.SEQ_MEMB_ID,'')))) = UPPER(LTRIM(RTRIM(ISNULL(ek.memid,''))))
	JOIN HMOPROD_PLANDATA.dbo.enrollcoverage AS ec ON ek.enrollid = ec.enrollid
WHERE 1=1
	AND CAST(t.[DATEFIELD] AS date) BETWEEN CAST(ec.effdate AS date) AND CAST(ec.termdate AS date) -- RINA: APPLIED TO FIELD WITHIN TABLE TO BE UPDATED
	AND UPPER(LTRIM(RTRIM(ISNULL(ec.ratecode,''))))  NOT IN ('') -- aka IS NOT <> != NULL
	-- AND UPPER(LTRIM(RTRIM(ISNULL(t.[RATECODE],'')))) = '' -- aka IS NULL */







-- ==================================================
	-- OUTPUT(s) --
-- ==================================================
SELECT ' ' AS 'by LOB'
,ISNULL(mm.LINE_OF_BUSINESS,'Unknown') AS [LOB]
,mm.RUNDT
,mm.[Membership Assessment Date]
-- ,NULLIF(COUNT(DISTINCT(memid)),0) AS [MM]
,ISNULL(COUNT(DISTINCT(mm.memid)),0) AS [MM]
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM TABLENAME AS mm
GROUP BY ISNULL(mm.LINE_OF_BUSINESS,'Unknown'),mm.RUNDT,mm.[Membership Assessment Date]
ORDER BY mm.[Membership Assessment Date],ISNULL(mm.LINE_OF_BUSINESS,'Unknown')

SELECT ' ' AS 'by Member Preferred Language'
,mm.[Member Preferred Language]
,mm.RUNDT
,mm.[Membership Assessment Date]
-- ,NULLIF(COUNT(DISTINCT(memid)),0) AS [MM]
,ISNULL(COUNT(DISTINCT(mm.memid)),0) AS [MM]
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM TABLENAME AS mm
GROUP BY mm.[Member Preferred Language],mm.RUNDT,mm.[Membership Assessment Date]
ORDER BY mm.[Membership Assessment Date],mm.[Member Preferred Language]

SELECT ' ' AS 'by ETHNICITY'
,ISNULL(mm.[834 OMB Ethnicity],'Unknown)') AS [834 OMB Ethnicity]
,mm.RUNDT
,mm.[Membership Assessment Date]
,ISNULL(COUNT(DISTINCT(mm.memid)),0) AS [MM]
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM TABLENAME AS mm
GROUP BY ISNULL(mm.[834 OMB Ethnicity],'Unknown)'),mm.RUNDT,mm.[Membership Assessment Date]
ORDER BY mm.[Membership Assessment Date],mm.RUNDT,ISNULL(mm.[834 OMB Ethnicity],'Unknown)')

/* SELECT ' ' AS 'PIVOT [Unique Member Count]'
,[LOB]
,[MM_YEAR]
,ISNULL([01],0) AS [JAN],ISNULL([02],0) AS [FEB],ISNULL([03],0) AS [MAR],ISNULL([04],0) AS [APR],ISNULL([05],0) AS [MAY],ISNULL([06],0) AS [JUN],ISNULL([07],0) AS [JUL],ISNULL([08],0) AS [AUG],ISNULL([09],0) AS [SEP],ISNULL([10],0) AS [OCT],ISNULL([11],0) AS [NOV],ISNULL([12],0) AS [DEC]
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'	
FROM 
( -- INITIATE ...
SELECT mm.LINE_OF_BUSINESS AS [LOB],DATEPART(yyyy,mm.[Membership Assessment Date]) AS [MM_YEAR],DATEPART(mm,mm.[Membership Assessment Date]) AS [MM_MTH]
,ISNULL(COUNT(DISTINCT(mm.memid)),0) AS [Unique Member Count]
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st',MTH
FROM TABLENAME AS mm
GROUP BY mm.LINE_OF_BUSINESS,DATEPART(yyyy,mm.[Membership Assessment Date]),DATEPART(mm,mm.[Membership Assessment Date]) 
) -- CONCLUDE
 AS util
PIVOT 
( -- INITIATE ...
MAX(util.[Unique Member Count])
FOR util.[MM_MTH] IN ([01],[02],[03],[04],[05],[06],[07],[08],[09],[10],[11],[12])
) -- CONCLUDE ...
AS dxpivot */

SELECT DISTINCT 'MEMBERS TURNING 65' AS [MESSAGE(S)],dob,MEMBER_TRUE_CHRONOLOGICAL_AGE,[Membership Assessment Date],*
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM TABLENAME AS mm
WHERE 1=1
	AND mm.MEMBER_TRUE_CHRONOLOGICAL_AGE = 65
	AND DATEPART(m,mm.dob) = 4
	AND DATEPART(m,mm.[Membership Assessment Date]) = 4
ORDER BY mm.memid

/* SELECT DISTINCT 'MEMBERS TURNING '+TRY_CONVERT(nvarchar(3),@age) AS [MESSAGE(S)],dob,MEMBER_TRUE_CHRONOLOGICAL_AGE,[Membership Assessment Date],*
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM TABLENAME AS mm
WHERE 1=1
	AND mm.MEMBER_TRUE_CHRONOLOGICAL_AGE = @age
	AND DATEPART(m,mm.dob) = 4
	AND DATEPART(m,mm.[Membership Assessment Date]) = 4
ORDER BY mm.memid */
