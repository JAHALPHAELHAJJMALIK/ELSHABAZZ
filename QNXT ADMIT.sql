-- ======================================================================
	-- VISIT / ADMIT / ENCOUNTER: 'Unique person, date of service, and provider = one visit'
-- ======================================================================
		-- EXEC [INFORMATICS].dbo.[spWCdate_calendarISO];

-- =====================================================================
	-- DECLARE @PARAMETER(S) / @FILTER(S) --
-- =====================================================================
DECLARE @IndexPlus AS int
DECLARE @gapallowance AS int
DECLARE @los AS decimal(9,0)
DECLARE @yone AS decimal(9,2)
DECLARE @ytwo AS decimal(9,2)
DECLARE @ythree AS decimal(9,2)

SET @IndexPlus = 3
SET @gapallowance = 1
SET @los = 30
SET @yone = 2150
SET @ytwo = 2289.75
SET @ythree = 2438.58

		SELECT @gapallowance AS [GAPS IN ... ALLOWED],@IndexPlus AS [CONSECUTIVE ... + PLUS THE IndexAdmit],@los AS [LOS LIMIT],CAST(YEAR(TRY_CONVERT(date,GETDATE())) AS nvarchar(25))+'-' +CAST(MONTH(TRY_CONVERT(date,GETDATE())) AS nvarchar(25)) AS [CURRENT MOS],'$'+TRY_CONVERT(nvarchar(255),@yone)+' Year 1 per diem' AS [Year 1],'$'+TRY_CONVERT(nvarchar(255),@ytwo)+' Year 2 per diem' AS [Year 2],'$'+TRY_CONVERT(nvarchar(255),@ythree)+' Year 3 per diem' AS [Year 3]







-----------------------------------------------------------------------------------------------------------------------------
	--Error Trapping: Check If Permanent Table(s) Already Exist(s) And Drop If Applicable--
-----------------------------------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS #AdmitAssessment -- SQL Server 2016 and later -- DYNAMIC tmp OR STATIC [TABLE] #TABLENAME is a local temporary table visible only in the current session; ##TABLENAME is a GLOBAL temporary table visible to all sessions IN ('TempDB')

SELECT ' ' AS 'Admit Analysis'
,CAST(NULL AS nvarchar(255)) AS [Index AdmitID] -- The ORIGINAL / INITIAL Visit + OR Admit
,CAST(NULL AS datetime) AS [Index Admission Date] -- The ORIGINAL / INITIAL Visit + OR Admit
,CAST(NULL AS datetime) AS [Index Discharge Date] -- The ORIGINAL / INITIAL Visit + OR Admit
,0 AS [Index Calendar Days]
,[DoTheMathInDays] = CASE
WHEN TRY_CONVERT(date,[PREVIOUS ADMIT DOS]) =TRY_CONVERT(date,DOS)
THEN 0
ELSE DATEDIFF("d",TRY_CONVERT(date,[PREVIOUS ADMIT DOSTHRU]),TRY_CONVERT(date,DOS)) 
END
,[DoTheMathInMonths] = CASE
WHEN TRY_CONVERT(date,[PREVIOUS ADMIT DOS]) =TRY_CONVERT(date,DOS)
THEN 0
ELSE DATEDIFF("m",TRY_CONVERT(date,[PREVIOUS ADMIT DOSTHRU]),TRY_CONVERT(date,DOS)) 
END
,[DATEDIFF DAY(S)] = CASE
WHEN DATEDIFF("d",TRY_CONVERT(date,DOS),TRY_CONVERT(date,ISNULL(DischargeDate,DOSTHRU))) = 0
THEN 1
ELSE DATEDIFF("d",TRY_CONVERT(date,DOS),TRY_CONVERT(date,ISNULL(DischargeDate,DOSTHRU))) -- ... +1 -- INCLUDE [startdate] / [DOS]
END --"(Day Count = Discharge Date - Admit Date; when Admit Date = Discharge Date then Day Count = 1)"
,[CALENDAR DAY(S)] = TRY_CONVERT(decimal(9,0),0)
,[CALENDAR DAY(S) minus END / DISCHARGE date] = TRY_CONVERT(decimal(9,0),0)
,[WORK DAY(S)] = TRY_CONVERT(decimal(9,0),0)
,[READMISSION] = TRY_CONVERT(decimal(9,0),0)
,[CONTINUOUS] = TRY_CONVERT(decimal(9,0),0)
,[CONSECUTIVE] = TRY_CONVERT(decimal(9,0),0)
,[HCT LOGIC DAY(S)] = TRY_CONVERT(decimal(9,0),0)
,dothemath.*
INTO #AdmitAssessment
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM 
( -- INITIATE...
SELECT ranklag.*
,ISNULL(LAG(DOS) OVER (PARTITION BY Cx,memid ORDER BY [RANKis] ASC),DOS) AS [PREVIOUS ADMIT DOS]
,ISNULL(LEAD(DOS) OVER (PARTITION BY Cx,memid ORDER BY [RANKis] ASC),DOS) AS [NEXT ADMIT DOS]
,ISNULL(LAG(ISNULL(DischargeDate,DOSTHRU)) OVER (PARTITION BY Cx,memid ORDER BY [RANKis] ASC),ISNULL(DischargeDate,DOSTHRU)) AS [PREVIOUS ADMIT DOSTHRU]
,ISNULL(LEAD(ISNULL(DischargeDate,DOSTHRU)) OVER (PARTITION BY Cx,memid ORDER BY [RANKis] ASC),ISNULL(DischargeDate,DOSTHRU)) AS [NEXT ADMIT DOSTHRU]
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM 
( -- INITIATE ...
SELECT rankrow.*
-- ,DENSE_RANK() OVER (PARTITION BY memid,Cx ORDER BY memid,Cx,DOS,provid) AS [RANKis]
,DENSE_RANK() OVER (PARTITION BY memid,Cx ORDER BY DOS,provid) AS [RANKis]
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM 
( -- INITIATE ...
SELECT DISTINCT ' ' AS 'NESTED DENSE_RANK() ROW() LAG() LEAD()'
,[Cx]
/* ,CASE -- FOR [CONSECUTIVE] MONTH ANALYSIS ... MCP members who were either 1. discharged from an inpatient setting or 2. in the emergency department for services two (2) or more times over four (4) consecutive months
WHEN Cx IN ('IP (Inpatient Facility)', 'ER')
THEN 'IPER'
WHEN Cx LIKE '%SNF%'
THEN 'SNF'
ELSE Cx
END AS [Cx] */
,MEMNM,memid,DischargeDate,DOS,DOSTHRU,PAYTONM,PAYTO,PROVNM,provid,[AdmitID] -- a.     VISIT / ADMIT / ENCOUNTER: 'Unique person, date of service, and provider = one visit'  OR 'Unique person, date of service, and NDC = one script'
FROM TABLENAME AS developsource
WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ...
	AND ISNULL(developsource.Cx,'') != '' -- NO NOT NEGATIVE <> != AS DEFAULT
	-- AND developsource.revcode BETWEEN '0100' AND '0219' -- COMBINATION OF MS ALLYSON HCT [day_units] LOGIC (BETWEEN '0110' AND '0219') AND + KINDRED NEGOTIATION PROPOSAL see "CHG- Kindred Initial Proposal Renewal Eff 020124.pdf" (BETWEEN '0100' AND '0219')
	AND developsource.TOTAL_PAID_AMOUNT > 0
	AND developsource.HEADERstatus IN ('ADJUCATED','PAID','PAY','REV','REVERSED','REVSYNCH')
	AND developsource.DETAILstatus NOT IN ('DENY','VOID')
	AND developsource.claimid NOT LIKE '%R%'
	AND ISNULL(developsource.resubclaimid,'') = '' -- ... AND resubclaimid IS NULL
) -- CONCLUDE ...
AS rankrow
) -- CONCLUDE ...
AS ranklag
) -- CONCLUDE ...
AS dothemath

		SELECT DISTINCT ' ' AS 'CHECK  [Cx] / [COS] CATEGORY OF SERVICE ASSIGNMENT',[Cx] FROM TABLENAME

		SELECT ' ' AS 'KINDRED SAMPLE DUP',* FROM TABLENAME WHERE AdmitID IN ('23000202022-09-282571')

		/* SELECT ' ' AS 'HCT COMP QA USE [URL]: https://chgtableau.chgsd.com - "TABLEAU APP"',GETDATE() AS [TimeStamp],MAX(su.[RANGE NOTE(s)]) AS [RANGE],su.YEARMO_DOS AS [Each Month],[Cx]AS [COS (Category of Service)]
		,COUNT(DISTINCT(AdmitID)) AS [Admits / Visit / Encounter]
		,COUNT(DISTINCT(memid)) AS [Denominator Membership]
		-- SELECT TOP 10 ' ' AS 'CHECK 1st',* 
		-- SELECT DISTINCT ' ' AS 'CHECK 1st',[Cx]
		FROM TABLENAME AS su -- UTILIZATION BETWEEN 2022-05-01 AND 2022-12-31
		WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ...
			AND [Cx] IN (SELECT DISTINCT [Cx] FROM TABLENAME)
		GROUP BY [Cx],YEARMO_DOS */







-- ======================================================================
	-- INDEX READMISSION(S) --
-- ======================================================================
UPDATE #AdmitAssessment
SET [READMISSION] = 1
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM #AdmitAssessment
WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ...
	-- AND [DoTheMathInMonths] BETWEEN 1 AND @los
	AND [DoTheMathInDays] BETWEEN 1 AND @los

UPDATE #AdmitAssessment
SET [CONTINUOUS] = 1
,[CONSECUTIVE] = 1
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM #AdmitAssessment
WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ...
	-- AND [DoTheMathInMonths] <= @gapallowance
	AND [DoTheMathInDays] <= @gapallowance
	AND RANKis != 1 -- NO NOT NEGATIVE <> !=

UPDATE #AdmitAssessment
SET [Index AdmitID] = CAST(AdmitID AS nvarchar(MAX))
,[Index Admission Date] = TRY_CONVERT(date,DOS)
,[Index Discharge Date] = TRY_CONVERT(date,ISNULL(DischargeDate,DOSTHRU))
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM #AdmitAssessment
WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ...
	AND [Index AdmitID] IS NULL
	AND RANKis = 1

UPDATE #AdmitAssessment
SET [Index AdmitID] = CAST(AdmitID AS nvarchar(MAX))
,[Index Admission Date] = TRY_CONVERT(date,DOS)
,[Index Discharge Date] = TRY_CONVERT(date,ISNULL(DischargeDate,DOSTHRU))
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM #AdmitAssessment
WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ...
	AND [Index AdmitID] IS NULL
	AND CONSECUTIVE = 0







-- ======================================================================
	-- SQL #PYTHON FOR WHILE LOOP() BREAK / FEEDBACK LOOP() CONDITION(S) -- 
-- ======================================================================
DECLARE @rowCount int;
WHILE (1=1)
BEGIN

		UPDATE #AdmitAssessment
		SET [Index AdmitID] = c.[Index AdmitID]
		,[Index Admission Date] = c.[Index Admission Date]
		,[Index Discharge Date] = TRY_CONVERT(date,ISNULL(aa.DischargeDate,aa.DOSTHRU))
		-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
		-- SELECT DISTINCT ' ' AS 'CHECK 1st'
		FROM #AdmitAssessment AS aa
			JOIN 
			( -- INITIATE ...
			SELECT DISTINCT memid,Cx,DOS,DOSTHRU,ISNULL(DischargeDate,DOSTHRU) AS [DischargeDate],[PREVIOUS ADMIT DOS],[PREVIOUS ADMIT DOSTHRU],[Index AdmitID],[Index Admission Date] 
			FROM #AdmitAssessment 
			WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ...
				AND [Index AdmitID] IS NOT NULL
			) -- CONCLUDE ...
			AS c ON aa.memid = c.memid 
				AND aa.Cx = c.Cx 
				AND aa.[PREVIOUS ADMIT DOS] = c.DOS 
				AND aa.[PREVIOUS ADMIT DOSTHRU] = ISNULL(c.DischargeDate,c.DOSTHRU)
			WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ...
				AND aa.[Index AdmitID] IS NULL
				AND  aa.CONSECUTIVE = 1

SET @rowCount = @@ROWCOUNT;
IF (@rowCount = 0)
BREAK;
END

UPDATE #AdmitAssessment
SET [Index Discharge Date] = idd.[Index Discharge Date]
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM #AdmitAssessment AS aa
	JOIN 
	( -- INITIATE ...
	SELECT [Index AdmitID],MAX([Index Discharge Date]) AS [Index Discharge Date]
	FROM #AdmitAssessment 
	WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ...
		AND [Index AdmitID] IS NOT NULL
	GROUP BY [Index AdmitID]
	) -- CONCLUDE ...
	AS idd ON aa.[Index AdmitID] = idd.[Index AdmitID]







-- ======================================================================
	-- THE UNIT(S) ... [DAY(S)] -- 
-- ======================================================================
UPDATE #AdmitAssessment 
SET [CALENDAR DAY(S)] = cwd.[CALENDAR DAY(S)]
,[CALENDAR DAY(S) minus END / DISCHARGE date] = cwd.[CALENDAR DAY(S) minus END / DISCHARGE date]
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM #AdmitAssessment AS aa
	JOIN 
	( -- INITIATE ...
	SELECT cdays.AdmitID
	,COUNT(DISTINCT(cdays.calendar_date)) AS [CALENDAR DAY(S)]
	,COUNT(DISTINCT(cdays.calendar_date))-1 AS [CALENDAR DAY(S) minus END / DISCHARGE date]
	-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
	-- SELECT DISTINCT ' ' AS 'CHECK 1st'
	FROM 
	( -- INITIATE ...
	SELECT DISTINCT 'ISOLATE FOR EVERY[DAY](S)' AS [NOTE(S)]
	,CAST(UPPER(LTRIM(RTRIM(ISNULL(t.memid,'')))) AS varchar(25))+CAST(UPPER(LTRIM(RTRIM(ISNULL(TRY_CONVERT(date,t.startdate),'')))) AS varchar(10))+CAST(UPPER(LTRIM(RTRIM(ISNULL(a.provid,'')))) AS varchar(25)) AS [AdmitID] -- 'Unique person, date of service, and provider = one visit'  OR 'Unique person, date of service, and NDC = one script'
	,dc.* -- ,t.claimid
	-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
	-- SELECT DISTINCT ' ' AS 'CHECK 1st'
	FROM INFORMATICS.dbo.date_calendarISO AS dc,(SELECT DISTINCT affiliationid,memid,startdate,enddate,dischargedate,provid FROM HMOPROD_PLANDATA.dbo.claim WHERE claimid IN (SELECT DISTINCT claimid FROM TABLENAME)) AS t -- DO NOT NO NEGATIVE <> != COVER UP THE TE() ... 50 YEAR CALENDAR [sp]
		JOIN HMOPROD_PLANDATA.dbo.affiliation AS a ON t.affiliationid = a.affiliationid -- REMINDER: within claim(s) tables AFFILIATIONID is the relationship between the a.provid = RENDERING PROVIDER AND the a.affiliateid = PAYTO aka VENDOR
	WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ...
		AND TRY_CONVERT(date,dc.calendar_date) BETWEEN TRY_CONVERT(date,t.startdate) AND TRY_CONVERT(date,ISNULL(t.Dischargedate,t.enddate)) -- RINA()
		-- AND TRY_CONVERT(date,dc.calendar_date) BETWEEN TRY_CONVERT(date,@CalendarDate_Start) AND TRY_CONVERT(date,@CalendarDate_End) -- RINA()
		-- AND claimid NOT LIKE '%A%'  -- see "STEP88_ORIGINAL_CLAIM...sql" ... 'A "CLEAN CLAIM" is one that has no defect, impropriety, lack of any required substantiating documentation, or particular circumstance requiring special treatment that prevents timely payment.'
		-- AND claimid NOT LIKE '%R%'  -- see "STEP88_ORIGINAL_CLAIM...sql" ... 'A "CLEAN CLAIM" is one that has no defect, impropriety, lack of any required substantiating documentation, or particular circumstance requiring special treatment that prevents timely payment.'
	) -- CONCLUDE...
	AS cdays
	GROUP BY cdays.AdmitID
	) -- CONCLUDE ...
	AS cwd ON aa.AdmitID = cwd.AdmitID
	
UPDATE #AdmitAssessment 
SET [WORK DAY(S)] = cwd.[WORK DAY(S)]
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM #AdmitAssessment AS aa
	JOIN 
	( -- INITIATE ...
	SELECT cdays.AdmitID
	,COUNT(DISTINCT(cdays.calendar_date)) AS [WORK DAY(S)]
	-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
	-- SELECT DISTINCT ' ' AS 'CHECK 1st'
	FROM 
	( -- INITIATE ...
	SELECT DISTINCT 'ISOLATE FOR EVERY[DAY](S)' AS [NOTE(S)]
	,CAST(UPPER(LTRIM(RTRIM(ISNULL(t.memid,'')))) AS varchar(25))+CAST(UPPER(LTRIM(RTRIM(ISNULL(TRY_CONVERT(date,t.startdate),'')))) AS varchar(10))+CAST(UPPER(LTRIM(RTRIM(ISNULL(a.provid,'')))) AS varchar(25)) AS [AdmitID] -- 'Unique person, date of service, and provider = one visit'  OR 'Unique person, date of service, and NDC = one script'
	,dc.* -- ,t.claimid
	-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
	-- SELECT DISTINCT ' ' AS 'CHECK 1st'
	FROM INFORMATICS.dbo.date_calendarISO AS dc,(SELECT DISTINCT affiliationid,memid,startdate,enddate,dischargedate,provid FROM HMOPROD_PLANDATA.dbo.claim WHERE claimid IN (SELECT DISTINCT claimid FROM TABLENAME)) AS t -- DO NOT NO NEGATIVE <> != COVER UP THE TE() ... 50 YEAR CALENDAR [sp]
		JOIN HMOPROD_PLANDATA.dbo.affiliation AS a ON t.affiliationid = a.affiliationid -- REMINDER: within claim(s) tables AFFILIATIONID is the relationship between the a.provid = PROVIDER AND the a.affiliateid = PAYTO aka VENDOR
	WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ...
		AND TRY_CONVERT(date,dc.calendar_date) BETWEEN TRY_CONVERT(date,t.startdate) AND TRY_CONVERT(date,ISNULL(t.Dischargedate,t.enddate)) -- RINA()
		-- AND TRY_CONVERT(date,dc.calendar_date) BETWEEN TRY_CONVERT(date,@CalendarDate_Start) AND TRY_CONVERT(date,@CalendarDate_End) -- RINA()
		-- AND claimid NOT LIKE '%A%'  -- see "STEP88_ORIGINAL_CLAIM...sql" ... 'A "CLEAN CLAIM" is one that has no defect, impropriety, lack of any required substantiating documentation, or particular circumstance requiring special treatment that prevents timely payment.'
		-- AND claimid NOT LIKE '%R%'  -- see "STEP88_ORIGINAL_CLAIM...sql" ... 'A "CLEAN CLAIM" is one that has no defect, impropriety, lack of any required substantiating documentation, or particular circumstance requiring special treatment that prevents timely payment.'
			AND dc.WORKDAY = 1
			-- AND dc.HOLIDAYS = 1
	) -- CONCLUDE...
	AS cdays
	GROUP BY cdays.AdmitID
	) -- CONCLUDE ...
	AS cwd ON aa.AdmitID = cwd.AdmitID	

UPDATE #AdmitAssessment
SET [Index Calendar Days] = icd.[Index Calendar Days]
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM #AdmitAssessment AS uaa
	JOIN 
	( -- INITIATE ...
	SELECT [Index AdmitID],COUNT(DISTINCT(dc.calendar_date))-1 AS [Index Calendar Days] -- EXCLUDE / minus THE END / DISCHARGE date
	-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
	-- SELECT DISTINCT ' ' AS 'CHECK 1st'
	FROM INFORMATICS.dbo.date_calendarISO AS dc,#AdmitAssessment AS aa -- DO NOT NO NEGATIVE <> != COVER UP THE TE() ... 50 YEAR CALENDAR [sp]
	WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ...
		AND TRY_CONVERT(date,dc.calendar_date) BETWEEN TRY_CONVERT(date,aa.[Index Admission Date]) AND TRY_CONVERT(date,aa.[Index Discharge Date]) -- RINA()
	GROUP BY [Index AdmitID]
	) --CONCLUDE ...
	AS icd ON uaa.[Index AdmitID] = icd.[Index AdmitID]
	
UPDATE #AdmitAssessment
SET [HCT LOGIC DAY(S)] = hct.[HCT LOGIC DAY(S)]
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM #AdmitAssessment AS uaa
	JOIN 
	( -- INITIATE ...
	SELECT [AdmitID]
	,SUM([HCT LOGIC DAY(S)]) AS [HCT LOGIC DAY(S)]
	-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
	-- SELECT DISTINCT ' ' AS 'CHECK 1st'
	FROM TABLENAME
	GROUP BY [AdmitID]
	) --CONCLUDE ...
	AS hct ON uaa.[AdmitID] = hct.[AdmitID]

	-- CHECK FOR DUP(S) --
-- SELECT ' ' AS 'SHOULD BE NULL DUP Validation [CALENDAR DAY(S) minus END / DISCHARGE date]',Cx,[AdmitID],*
DELETE
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st',
FROM #AdmitAssessment
WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ...
	AND [Cx]+[AdmitID] IN 
	( -- INITIATE ...
	SELECT [Cx]+[AdmitID] AS [DupID]
	FROM #AdmitAssessment AS dup
	GROUP BY [Cx]+[AdmitID] -- Duplication Driver 
	HAVING COUNT(1)>1 -- HAVING clause RESERVED for AGGREGATE(s) ... HAVING SUM(PAID_NET_AMT) != 0
	) -- CONCLUDE ... 
		AND [DATEDIFF DAY(S)] != [CALENDAR DAY(S) minus END / DISCHARGE date]

SELECT ' ' AS 'SHOULD BE NULL DUP Validation',Cx,[AdmitID],*
-- DELETE
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st',
FROM #AdmitAssessment
WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ...
	AND [Cx]+[AdmitID] IN 
	( -- INITIATE ...
	SELECT [Cx]+[AdmitID] AS [DupID]
	FROM #AdmitAssessment AS dup
	GROUP BY [Cx]+[AdmitID] -- Duplication Driver 
	HAVING COUNT(1)>1 -- HAVING clause RESERVED for AGGREGATE(s) ... HAVING SUM(PAID_NET_AMT) != 0
	) -- CONCLUDE ... 







-- ============================================================= 
	-- SUMMARY: Days + Admits / Visits --
-- =============================================================
SELECT ' ' AS 'SUMMARY: Days + Admits / Visits BY [Cx / COS]',los.* -- ... large claims costs for hospital inpatient stays => than 30 days
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM 
( -- INITIATE ...
SELECT aa.Cx AS [Category of Service]
,COUNT(DISTINCT(memid)) AS [UNIQUE UTILZERS]
,SUM([HCT LOGIC DAY(S)]) AS [DAY(S)]
,SUM(p.PAID) AS [PAID]
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM #AdmitAssessment AS aa
	JOIN 
	( -- INITIATE ...
	SELECT AdmitID,SUM(PAID_NET_AMT) AS [Paid]
	FROM TABLENAME AS developsource
	GROUP BY AdmitID
	) -- CONCLUDE ...
	AS p ON aa.AdmitID = p.AdmitID
GROUP BY aa.Cx
) -- CONCLUDE ...
AS los

SELECT ' ' AS 'SUMMARY: Days + Admits / Visits BY [RENDERING]',los.* -- ... large claims costs for hospital inpatient stays => than 30 days
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM 
( -- INITIATE ...
SELECT aa.Cx AS [Category of Service],aa.PROVNM,DATEPART(year,aa.DOS) AS YOS
,COUNT(DISTINCT(aa.memid)) AS [UNIQUE UTILZERS]
,COUNT(DISTINCT(aa.[Index AdmitID])) AS [INDEX ADMIT(S) / VISIT(S)] -- USING [Index AdmitID] ENABLES TRACKING OF [CONSECUTIVE] DAY(S)
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
	FROM TABLENAME
	GROUP BY AdmitID
	) -- CONCLUDE ...
	AS p ON aa.AdmitID = p.AdmitID
GROUP BY aa.Cx,aa.PROVNM,DATEPART(year,aa.DOS)
) -- CONCLUDE ...
AS los
	
SELECT ' ' AS 'SUMMARY: Days + Admits / Visits BY [PAYTO]',los.* -- ... large claims costs for hospital inpatient stays => than 30 days
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM 
( -- INITIATE ...
SELECT aa.Cx AS [Category of Service],aa.PAYTONM,DATEPART(year,aa.DOS) AS YOS
,COUNT(DISTINCT(aa.memid)) AS [UNIQUE UTILZERS]
,COUNT(DISTINCT(aa.[Index AdmitID])) AS [INDEX ADMIT(S) / VISIT(S)] -- USING [Index AdmitID] ENABLES TRACKING OF [CONSECUTIVE] DAY(S)
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
	FROM TABLENAME
	GROUP BY AdmitID
	) -- CONCLUDE ...
	AS p ON aa.AdmitID = p.AdmitID
GROUP BY aa.Cx,aa.PAYTONM,DATEPART(year,aa.DOS)
) -- CONCLUDE ...
AS los

SELECT ' ' AS 'MS EXCEL ODBC DETAIL',developsource.*
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM #AdmitAssessment AS aa
	JOIN TABLENAME AS developsource ON aa.AdmitID = developsource.AdmitID
WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ...
	-- AND revcode BETWEEN '0110' AND '0219'
	-- AND TOTAL_PAID_AMOUNT > 0
	-- AND claimid NOT LIKE '%R%'
	-- AND HEADERstatus IN ('ADJUCATED','PAID','PAY','REV','REVERSED','REVSYNCH')
	-- AND developsource.DETAILstatus NOT IN ('DENY','VOID')
	






-- ============================================================= 
	-- [LOS] / [DAY(s)] INCLUSION OR EXCLUSION --
-- =============================================================
SELECT ' ' AS 'SUMMARY: Determine Consecutive Days','USING [Index AdmitID] ENABLES TRACKING OF [CONSECUTIVE] DAY(S)' AS [NOTE(S)],* -- ... large claims costs for hospital inpatient stays => than 30 days
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM 
( -- INITIATE ...
SELECT Cx,memid,MEMNM,[Index AdmitID] -- USING [Index AdmitID] ENABLES TRACKING OF [CONSECUTIVE] DAY(S)
,SUM([CALENDAR DAY(S)]) AS [CALENDAR_consecutive_length_of_stay]
,SUM([CALENDAR DAY(S) minus END / DISCHARGE date]) AS [CALENDAR_minus_consecutive_length_of_stay]
,SUM([DATEDIFF DAY(S)]) AS [DATEDIFF_consecutive_length_of_stay]
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM #AdmitAssessment
GROUP BY Cx,memid,MEMNM,[Index AdmitID]
) -- CONCLUDE ...
AS los
WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ...
	AND [CALENDAR_consecutive_length_of_stay] >= @los

SELECT ' ' AS 'SUMMARY: Determine Total Days','USING JUST THE memid ENABLES TRACKING OF [TOTAL] DAY(S)' AS [NOTE(S)],*  -- ... large claims costs for hospital inpatient stays => than 30 days
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM 
( -- INITIATE ...
SELECT Cx,memid,MEMNM -- USING JUST THE memid ENABLES TRACKING OF [TOTAL] DAY(S)
,SUM([CALENDAR DAY(S)]) AS [CALENDAR_length_of_stay_DAYS]
,SUM([CALENDAR DAY(S) minus END / DISCHARGE date]) AS [CALENDAR_minus_length_of_stay_DAYS]
,SUM([DATEDIFF DAY(S)]) AS [DATEDIFF_length_of_stay_DAYS]
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM #AdmitAssessment
GROUP BY Cx,memid,MEMNM
) -- CONCLUDE ...
AS los
WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ...
	AND [CALENDAR_length_of_stay_DAYS] >= @los

SELECT ' ' AS 'DETAIL EXPORT',riso.*,rip.* 
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM TABLENAME AS rip
	JOIN 
	( -- INITITIATE ...
	SELECT DISTINCT ' ' AS 'REINSURANCE ISOLATION',aa.AdmitID,aa.[Index AdmitID]
	-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
	-- SELECT DISTINCT ' ' AS 'CHECK 1st'
	FROM INFORMATICS.dbo.#AdmitAssessment AS aa
		JOIN 
		( -- INITITIATE ...
		SELECT ' ' AS 'SUMMARY: Determine Consecutive Days',* -- ... large claims costs for hospital inpatient stays => than 30 days
		-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
		-- SELECT DISTINCT ' ' AS 'CHECK 1st'
		FROM 
		( -- INITIATE ...
		SELECT Cx,memid,MEMNM,[Index AdmitID] -- USING [Index AdmitID] ENABLES TRACKING OF [CONSECUTIVE] DAY(S)
		,SUM([CALENDAR DAY(S)]) AS [CALENDAR_consecutive_length_of_stay]
		,SUM([CALENDAR DAY(S) minus END / DISCHARGE date]) AS [CALENDAR_minus_consecutive_length_of_stay]
		,SUM([DATEDIFF DAY(S)]) AS [DATEDIFF_consecutive_length_of_stay]
		-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
		-- SELECT DISTINCT ' ' AS 'CHECK 1st'
		FROM INFORMATICS.dbo.#AdmitAssessment
		GROUP BY Cx,memid,MEMNM,[Index AdmitID]
		) -- CONCLUDE ...
		AS los
		WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ...
			AND [CALENDAR_consecutive_length_of_stay] >= @los
		) -- CONCLUDE ...
		AS reinsuranceiso ON aa.[Index AdmitID] = reinsuranceiso.[Index AdmitID]
		) -- CONCLUDE ...
		AS riso ON rip.AdmitID = riso.AdmitID

		SELECT ' ' AS 'QA CHECK'
		,(SELECT COUNT(DISTINCT(AdmitID)) AS [AdmitVist] FROM TABLENAME) AS [QAAdmitVisitSource]
		,(SELECT COUNT(DISTINCT(AdmitID)) AS [AdmitVist] FROM #AdmitAssessment) AS [QAAdmitVisitAssessment]
		
		SELECT ' ' AS 'SAMPLE FROM CLAIMS SOURCE TABLE',claimid,Cx,AdmitID,DOS,DOSTHRU,DOS,DOSTHRU,memid,MEMNM,provid,PROVNM,QUANTITY,[REVCDE Descr],revcode,QNXTbilltype,ClmType,[CPT Service Code],location,* FROM TABLENAME AS su WHERE memid IN ('2021497') AND [Cx] IN ('SNF') -- WHERE AdmitID IN ('21250432022-01-28330599494')
		
		SELECT ' ' AS 'SAMPLE FROM #AdmitAssessment',* FROM #AdmitAssessment WHERE memid IN ('2021497') AND [Cx] IN ('SNF')







-- ======================================================================
	-- Identifying Frequent Users OVER [CONSECUTIVE] MONTH(S) --
-- ======================================================================
/* UPDATE #AdmitAssessment
SET [CONTINUOUS] = 0 -- RESET / REFRESH / GO HOME
,[CONSECUTIVE] = 0 -- RESET / REFRESH / GO HOME

UPDATE #AdmitAssessment
SET [CONTINUOUS] = 1
,[CONSECUTIVE] = 1
-- SELECT TOP 10 ' ' AS 'CHECK 1st',DATEDIFF(MONTH,DOS,[NEXT ADMIT DOS]) AS [TEST LEAD LAG CONSECUTIVE MONTH],*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM #AdmitAssessment
WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ...
	AND DATEDIFF(MONTH,DOS,[NEXT ADMIT DOS]) <= 1 -- [TEST LEAD LAG CONSECUTIVE MONTH] */

-----------------------------------------------------------------------------------------------------------------------------
	--Error Trapping: Check If Permanent Table(s) Already Exist(s) And Drop If Applicable--
-----------------------------------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS #ConsecutiveMembershipISO -- SQL Server 2016 and later -- DYNAMIC tmp OR STATIC [TABLE] #INFORMATICS.dbo.HHIPCLAIMS is a local temporary table visible only in the current session; ##INFORMATICS.dbo.HHIPCLAIMS is a GLOBAL temporary table visible to all sessions IN ('TempDB')

SELECT 'MCP members who were either 1. discharged from an inpatient setting or 2. in the emergency department for services two (2) or more times over four (4) consecutive months' AS [NOTE(S)],*
INTO #ConsecutiveMembershipISO
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM #AdmitAssessment AS ccie
WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ...
	AND ccie.Cx IN ('IPER')
	AND ccie.memid IN 
	( -- INITITIATE ...
	SELECT DISTINCT memid
	-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
	-- SELECT DISTINCT ' ' AS 'CHECK 1st'
	FROM #AdmitAssessment
	WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ...
		AND Cx IN ('IPER')
		-- AND memid IN ('1004072') -- SAMPLE / [QA]
		AND 
		( -- INITIATE ...
		MONTH(DOS) BETWEEN 1 AND 4
			--OR MONTH(DOS) BETWEEN 2 AND 5
			--OR MONTH(DOS) BETWEEN 3 AND 6
			--OR MONTH(DOS) BETWEEN 4 AND 7
			--OR MONTH(DOS) BETWEEN 5 AND 8
			--OR MONTH(DOS) BETWEEN 6 AND 9
			--OR MONTH(DOS) BETWEEN 7 AND 10
			--OR MONTH(DOS) BETWEEN 8 AND 11
			--OR MONTH(DOS) BETWEEN 9 AND 12
		) -- CONCLUDE ...
	GROUP BY memid
	HAVING COUNT(DISTINCT(CAST(YEAR(TRY_CONVERT(date,DOS)) AS nvarchar(25))+'-' +CAST(MONTH(TRY_CONVERT(date,DOS)) AS nvarchar(25)))) >= @IndexPlus -- HOW MANY MONTHS OF UTILIZATION

	UNION 
	SELECT DISTINCT memid
	-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
	-- SELECT DISTINCT ' ' AS 'CHECK 1st'
	FROM #AdmitAssessment
	WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ...
		AND Cx IN ('IPER')
		AND MONTH(DOS) BETWEEN 2 AND 5
	GROUP BY memid
	HAVING COUNT(DISTINCT(CAST(YEAR(TRY_CONVERT(date,DOS)) AS nvarchar(25))+'-' +CAST(MONTH(TRY_CONVERT(date,DOS)) AS nvarchar(25)))) >= @IndexPlus -- HOW MANY MONTHS OF UTILIZATION

	UNION 
	SELECT DISTINCT memid
	-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
	-- SELECT DISTINCT ' ' AS 'CHECK 1st'
	FROM #AdmitAssessment
	WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ...
		AND Cx IN ('IPER')
		AND MONTH(DOS) BETWEEN 3 AND 6
	GROUP BY memid
	HAVING COUNT(DISTINCT(CAST(YEAR(TRY_CONVERT(date,DOS)) AS nvarchar(25))+'-' +CAST(MONTH(TRY_CONVERT(date,DOS)) AS nvarchar(25)))) >= @IndexPlus -- HOW MANY MONTHS OF UTILIZATION

	UNION 
	SELECT DISTINCT memid
	-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
	-- SELECT DISTINCT ' ' AS 'CHECK 1st'
	FROM #AdmitAssessment
	WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ...
		AND Cx IN ('IPER')
		AND MONTH(DOS) BETWEEN 4 AND 7
	GROUP BY memid
	HAVING COUNT(DISTINCT(CAST(YEAR(TRY_CONVERT(date,DOS)) AS nvarchar(25))+'-' +CAST(MONTH(TRY_CONVERT(date,DOS)) AS nvarchar(25)))) >= @IndexPlus -- HOW MANY MONTHS OF UTILIZATION

	UNION 
	SELECT DISTINCT memid
	-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
	-- SELECT DISTINCT ' ' AS 'CHECK 1st'
	FROM #AdmitAssessment
	WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ...
		AND Cx IN ('IPER')
		AND MONTH(DOS) BETWEEN 5 AND 8
	GROUP BY memid
	HAVING COUNT(DISTINCT(CAST(YEAR(TRY_CONVERT(date,DOS)) AS nvarchar(25))+'-' +CAST(MONTH(TRY_CONVERT(date,DOS)) AS nvarchar(25)))) >= @IndexPlus -- HOW MANY MONTHS OF UTILIZATION

	UNION 
	SELECT DISTINCT memid
	-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
	-- SELECT DISTINCT ' ' AS 'CHECK 1st'
	FROM #AdmitAssessment
	WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ...
		AND Cx IN ('IPER')
		AND MONTH(DOS) BETWEEN 6 AND 9
	GROUP BY memid
	HAVING COUNT(DISTINCT(CAST(YEAR(TRY_CONVERT(date,DOS)) AS nvarchar(25))+'-' +CAST(MONTH(TRY_CONVERT(date,DOS)) AS nvarchar(25)))) >= @IndexPlus -- HOW MANY MONTHS OF UTILIZATION

	UNION 
	SELECT DISTINCT memid
	-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
	-- SELECT DISTINCT ' ' AS 'CHECK 1st'
	FROM #AdmitAssessment
	WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ...
		AND Cx IN ('IPER')
		AND MONTH(DOS) BETWEEN 7 AND 10
	GROUP BY memid
	HAVING COUNT(DISTINCT(CAST(YEAR(TRY_CONVERT(date,DOS)) AS nvarchar(25))+'-' +CAST(MONTH(TRY_CONVERT(date,DOS)) AS nvarchar(25)))) >= @IndexPlus -- HOW MANY MONTHS OF UTILIZATION

	UNION 
	SELECT DISTINCT memid
	-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
	-- SELECT DISTINCT ' ' AS 'CHECK 1st'
	FROM #AdmitAssessment
	WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ...
		AND Cx IN ('IPER')
		AND MONTH(DOS) BETWEEN 8 AND 11
	GROUP BY memid
	HAVING COUNT(DISTINCT(CAST(YEAR(TRY_CONVERT(date,DOS)) AS nvarchar(25))+'-' +CAST(MONTH(TRY_CONVERT(date,DOS)) AS nvarchar(25)))) >= @IndexPlus -- HOW MANY MONTHS OF UTILIZATION

	UNION 
	SELECT DISTINCT memid
	-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
	-- SELECT DISTINCT ' ' AS 'CHECK 1st'
	FROM #AdmitAssessment
	WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ...
		AND Cx IN ('IPER')
		AND MONTH(DOS) BETWEEN 9 AND 12
	GROUP BY memid
	HAVING COUNT(DISTINCT(CAST(YEAR(TRY_CONVERT(date,DOS)) AS nvarchar(25))+'-' +CAST(MONTH(TRY_CONVERT(date,DOS)) AS nvarchar(25)))) >= @IndexPlus -- HOW MANY MONTHS OF UTILIZATION
	) -- CONCLUDE ...

		SELECT ' ' AS 'INCLUSION / EXCLUSION POPULATION #BASELINE',COUNT(DISTINCT(memid)) AS [BASELINE POP],SUM(CONSECUTIVE) AS [CONSECUTIVE Visit(s)] FROM #ConsecutiveMembershipISO ORDER BY SUM(CONSECUTIVE) DESC
		SELECT TOP 1  ' ' AS 'HHIP IPER EXCLUSION',* FROM #ConsecutiveMembershipISO
		SELECT ' ' AS 'SAMPLE SOURCE DATA QA',AdmitID,DOS,DOSTHRU,DischargeDate,Cx,memid,MEMNM,* FROM INFORMATICS.dbo.HHIPCLAIMS AS h WHERE Cx IN ('IP (Inpatient Facility)', 'ER') AND memid IN ('1005759') AND claimline = 1 ORDER BY h.DOS DESC
		SELECT ' ' AS 'SAMPLE ADMIT ASSESSMENT QA',* FROM #AdmitAssessment AS h WHERE Cx IN ('IPER') AND memid IN ('1005759')
