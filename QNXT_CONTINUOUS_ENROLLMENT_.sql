-- =====================================================================
	-- CONTINUOUS ENROLLMENT --
-- =====================================================================
-- EXEC [INFORMATICS].dbo.[spWCdate_calendarISO]; -- 50 YEAR CALENDAR
-- EXEC [INFORMATICS].dbo.[spWCdate_calendarCE]; -- 40 YEAR CALENDAR 1st OF THE MONTH ONLY!!!

-- =====================================================================
	-- COMMENT(S) / CHANGE.LOG: --
-- =====================================================================
--  C001: 

-- =====================================================================
    -- DECLARE @PARAMETER(S) / @FILTER(S) --
-- =====================================================================
DECLARE @CEClockStart AS date
DECLARE @CEClockStop AS date
DECLARE @isoday AS int
DECLARE @isomem AS nvarchar(25)
DECLARE @GAPOF AS int
DECLARE @MAXGAP AS int
DECLARE @lob AS nvarchar(255)
DECLARE @ContinuousMonths AS decimal(9,0)
DECLARE @AgeCutoff AS decimal(9,0)

SET @CEClockStart = TRY_CONVERT(date,'01/01/2024')
SET @CEClockStop = TRY_CONVERT(date,'03/31/2024')
SET @isoday = 1 -- CALENDAR DAY ISO ... / EFFECTIVE AS OF WHICH DAY IN GIVEN MONTH?
SET @isomem = NULL -- '%1083184%' -- ('912896','1043158','1083184') -- [RANKis] SAMPLE / TEST
SET @GAPOF = 1
SET @MAXGAP = 1 -- PARAMETERIZE the maximum allowable gap
SET @lob = 'DSNP MEDI-CAL PLAN' -- NULL ... '%'+'DSNP MEDI-CAL PLAN'+'%' ... bp.[OPTION(S)]: IN ('COMMUNITY Y MAS (HMO C-SNP)','DSNP MEDI-CAL PLAN','MEDI-CAL BENEFIT PLAN') ... p.[OPTION(S)]: IN ('DSNP MEDI-CAL','DSNP MEDICARE','COMMUNITY Y MAS (HMO C-SNP)','MEDI-CAL') -- ACTIVE LOB LOCK ... 
SET @ContinuousMonths = 3
SET @AgeCutoff = 20

		SELECT TOP 1 ' ' AS '50 YEAR CALENDAR  ... CREATING A STATIC CONTINUOUS ENROLLMENT SOURCE...'
		,'USE CASE SEE ECM / CS QUARTERLY TAB 1 LOGIC' AS [NOTE(S)]
		,MIN(calendar_date) AS MINdt
		,MAX(calendar_date) AS MAXdt
		,bp.LINE_OF_BUSINESS
		,'BETWEEN '+CAST(CAST(@CEClockStart AS date) AS varchar (25))+' AND '+CAST(CAST(@CEClockStop AS date) AS varchar (25)) AS [RANGE NOTE(s)]
		,@AgeCutoff AS [AGE LIMIT >= (GREATER THAN EQUAL TO)]
		,@lob AS 'WHICH LOB'
		,dc.calendar_day AS 'ELIGIBILTY DETERMINATION DAY'
		FROM INFORMATICS.dbo.[uvw_LINE_OF_BUSINESS] AS bp,INFORMATICS.[dbo].date_calendarISO AS dc -- DO NOT NO NEGATIVE <> != COVER UP THE TE() ... 50 YEAR CALENDAR
		WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ... AND ...
			-- AND bp.[LINE_OF_BUSINESS] LIKE ISNULL('%'+@lob+'%','%')
			AND bp.[PLAN] LIKE ISNULL('%'+@lob+'%','%')
			-- AND bp.[PROGRAM] LIKE ISNULL('%'+@lob+'%','%')
		GROUP BY bp.LINE_OF_BUSINESS,dc.calendar_day

		SELECT * FROM INFORMATICS.dbo.[uvw_LINE_OF_BUSINESS] -- HMOPROD_PLANDATA.dbo.benefitplan + HMOPROD_PLANDATA.dbo.program







-----------------------------------------------------------------------------------------------------------------------------
	-- Error Trapping: Check If Permanent Table(s) Already Exist(s) And Drop If Applicable --
-----------------------------------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS #RANKLAG -- SQL Server 2016 and later -- DYNAMIC tmp OR STATIC [TABLE] #TableName is a local temporary table visible only in the current session; ##TableName is a GLOBAL temporary table visible to all sessions IN ('TempDB')

SELECT DISTINCT DENSE_RANK() OVER(PARTITION BY ek.memid ORDER BY dc.calendar_date ASC) AS [RANKis]
,ROW_NUMBER() OVER(PARTITION BY ek.memid ORDER BY dc.calendar_date ASC) AS [ROWis]
,TRY_CONVERT(date,first_day_in_month) AS [EligibilityStart]
,TRY_CONVERT(date,last_day_in_month) AS [EligibilityEnd]
,dc.calendar_date
,first_day_in_month
,last_day_in_month
,SUBSTRING(LTRIM(RTRIM(ISNULL(ek.carriermemid,''))),1,10) AS [Health Plan ID]
,SUBSTRING(UPPER(LTRIM(RTRIM(ISNULL(mem.secondaryid,'')))),1,9) AS [CIN]
,ek.memid,mem.fullname
,ek.effdate,ek.termdate
,CAST(SUBSTRING(CAST(CAST(DATEDIFF("dd",TRY_CONVERT(date,mem.dob),TRY_CONVERT(date,@CEClockStop))/365.25 AS money) AS nvarchar(25)),1,CHARINDEX('.',CAST(DATEDIFF("dd",TRY_CONVERT(date,mem.dob),TRY_CONVERT(date,@CEClockStop))/365.25 AS money),1)-1) AS int) AS [AGE]
,CAST(NULL AS nvarchar(100)) AS [AGECx]
,TRY_CONVERT(date,mem.DOB) AS [DOB]
,bp.LINE_OF_BUSINESS AS [LOB]
,bp.PROGRAM
,DATEDIFF("d",TRY_CONVERT(date,dc.first_day_in_month),TRY_CONVERT(date,dc.last_day_in_month))+1 AS DaysEnrolled -- FUTURE 1 to include START DATE ELSE SEE 'STEP03b_DaysLogic_20140423.sql' CASE statement SYNTAX 
,CAST(1 AS int) AS MonthsEnrolled --LIKE '%,CAST(1 AS int) AS MMcount%'
 INTO #RANKLAG
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'

FROM INFORMATICS.dbo.date_calendarISO AS dc,HMOPROD_PLANDATA.dbo.enrollkeys AS ek -- DO NOT NO NEGATIVE <> != COVER UP THE TE() ... 50 YEAR CALENDAR
-- FROM INFORMATICS.dbo.date_calendarCE AS dc,HMOPROD_PLANDATA.dbo.enrollkeys AS ek -- DO NOT NO NEGATIVE <> != COVER UP THE TE() ... 40 YEAR CALENDAR 1st OF THE MONTH ONLY!!!
	JOIN HMOPROD_PLANDATA.dbo.member AS mem ON ek.memid = mem.memid
	JOIN INFORMATICS.dbo.[uvw_LINE_OF_BUSINESS] AS bp ON ek.planid = bp.planid
	
	/* JOIN -- MEMBERSHIP ISOLATION ...
	( -- INITIATE ...
	SELECT DISTINCT c.memid FROM INFORMATICS.dbo.DMHCAUDITPDR AS pdr JOIN HMOPROD_PLANDATA.dbo.claim AS c ON pdr.[Claim number] = c.claimid
	) -- CONCLUDE ...
	AS iso ON ek.memid = iso.memid */

WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ... AND ...
	AND TRY_CONVERT(date,ek.termdate) > TRY_CONVERT(date,ek.effdate) -- MUST BE TRUE ... NON-CROSSFOOTED RECORDS ARE ACTIVE ...
	AND dc.calendar_date BETWEEN @CEClockStart AND @CEClockStop -- SET REPORTING PERIOD LOCK AND ...
	AND dc.calendar_day = @isoday -- CALENDAR DAY ISO ... / EFFECTIVE AS OF WHICH DAY IN GIVEN MONTH?	

	AND TRY_CONVERT(date,ek.effdate) <= TRY_CONVERT(date,dc.calendar_date) -- WITHIN reporting period [RANGE] OPPOSITION 
	AND TRY_CONVERT(date,ISNULL(ek.termdate,GETDATE())) >= TRY_CONVERT(date,dc.calendar_date) -- WITHIN reporting period 
	
	AND UPPER(LTRIM(RTRIM(ISNULL(ek.segtype,'')))) ='INT'
	AND ISNULL(mem.IsSubscriber,'') = 'Y' -- ISO ON SUBSCRIBER ONLY!!!
	-- AND bp.[LINE_OF_BUSINESS] LIKE ISNULL('%'+@lob+'%','%')
	AND bp.[PLAN] LIKE ISNULL('%'+@lob+'%','%')
	-- AND bp.[PROGRAM] LIKE ISNULL('%'+@lob+'%','%')
	-- AND ek.memid LIKE ISNULL(@isomem,'%') -- ('912896''1043158','1083184') -- [RANKis] SAMPLE / TEST

	-- ADD indexes to improve query performance
CREATE INDEX idx_REFACTOR_DupID ON #RANKLAG (memid,EligibilityStart);







-----------------------------------------------------------------------------------------------------------------------------
	-- Error Trapping: Check If Permanent Table(s) Already Exist(s) And Drop If Applicable --
-----------------------------------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS #ContinuousEnrollment -- SQL Server 2016 and later -- DYNAMIC tmp OR STATIC [TABLE] #TableName is a local temporary table visible only in the current session; ##TableName is a GLOBAL temporary table visible to all sessions IN ('TempDB')

SELECT ' ' AS 'LEAD + LAG: ' -- ,effdate,termdate -- x LEAD() AHEAD TO Accesses the value stored in a row after the current row. Function Syntax Function Description ... Windowed functions cannot be used in the context of another windowed function or aggregate. / Windowed functions can only appear in the SELECT or ORDER BY clauses. + -- x LAG() BEHIND Accesses the value stored in a row before the current row... Windowed functions cannot be used in the context of another windowed function or aggregate. / Windowed functions can only appear in the SELECT or ORDER BY clauses.
,CAST(NULL AS nvarchar(255)) AS [Index EligibilityID] -- The ORIGINAL / INITIAL Eligibility SEQUENCE
,CAST(NULL AS date) AS [Index Eligibility Start Date]
,CAST(NULL AS date) AS [Index Eligibility End Date]
,CAST(NULL AS int) AS [GAPinDAYs]
,CAST(NULL AS int) AS [GAPinMONTHs]
,TRY_CONVERT(decimal(9,0),0) AS [CONSECUTIVE]
,TRY_CONVERT(decimal(9,0),0) AS [CONSECUTIVE DAY(S)]
,TRY_CONVERT(decimal(9,0),0) AS [CONSECUTIVE MONTH(S)]
,[PREVIOUS EligibilityStart] = LAG([EligibilityStart]) OVER (PARTITION BY memid ORDER BY [RANKis] ASC) 
,[FUTURE EligibilityStart] = LEAD([EligibilityStart]) OVER (PARTITION BY memid ORDER BY [RANKis] ASC) 
,[PREVIOUS EligibilityEnd] = LAG([EligibilityEnd]) OVER (PARTITION BY memid ORDER BY [RANKis] ASC)
,[FUTURE EligibilityEnd] = LEAD([EligibilityEnd]) OVER (PARTITION BY memid ORDER BY [RANKis] ASC)
,* -- ALL [FIELD(s)] FROM SHELLunion00_ARCHIVE
INTO #ContinuousEnrollment
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM #RANKLAG
WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ... AND ...

	-- CHECK FOR DUP(S) --
/* SELECT ' ' AS 'SHOULD BE NULL DUP Validation',*
-- DELETE
FROM #ContinuousEnrollment
WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ...
	AND LTRIM(RTRIM(memid))+LTRIM(RTRIM(calendar_date)) +LTRIM(RTRIM(termdate)) IN
	( -- INITIATE ...
	SELECT LTRIM(RTRIM(memid))+LTRIM(RTRIM(calendar_date)) +LTRIM(RTRIM(termdate))
	FROM #ContinuousEnrollment AS dup
	GROUP BY LTRIM(RTRIM(memid))+LTRIM(RTRIM(calendar_date)) +LTRIM(RTRIM(termdate)) -- Duplication Driver 
	HAVING COUNT(1)>1 -- HAVING clause RESERVED for AGGREGATE(s) ... HAVING SUM(PAID_NET_AMT) != 0
	) -- CONCLUDE ... */
  
		-- SELECT 'PURGE #RANKLAG' AS [NOTE(S)],* FROM #ContinuousEnrollment ORDER BY [ID]
		-- SELECT DISTINCT MonthsEnrolled FROM #ContinuousEnrollment ORDER BY MonthsEnrolled DESC
		-- SELECT DISTINCT MonthsEnrolled,DaysEnrolled FROM #ContinuousEnrollment ORDER BY MonthsEnrolled DESC

	-- tmp / CTE CLEAN - UP: -- 
DROP TABLE IF EXISTS #RANKLAG







-- ================================================
	-- EXECUTE DLOOKUP equivalent(s)--
-- ================================================
UPDATE #ContinuousEnrollment
SET [PREVIOUS EligibilityEnd] = effdate
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM #ContinuousEnrollment
WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ...
	AND RANKis != 1
	AND [PREVIOUS EligibilityEnd] IS NULL

UPDATE #ContinuousEnrollment --QUPD GAP IN DAY(s)
SET GAPinDAYs = 0
,GAPinMONTHs = 0
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM #ContinuousEnrollment
WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ...
	AND RANKis = 1

UPDATE #ContinuousEnrollment --QUPD GAP IN DAY(s)
SET GAPinDAYs = CAST(DATEDIFF("d",CASE
WHEN TRY_CONVERT(datetime,[PREVIOUS EligibilityEnd]) = '2078-12-31 00:00:00.000'
THEN CAST(GETDATE() AS date)
ELSE TRY_CONVERT(datetime,[PREVIOUS EligibilityEnd])
END,TRY_CONVERT(datetime,EligibilityStart)-1) AS int)
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM #ContinuousEnrollment
WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ...
	AND GAPinDAYs IS NULL

UPDATE #ContinuousEnrollment --QUPD GAP IN MONTH(s)
SET GAPinMONTHs = CAST(DATEDIFF("m",CASE
WHEN CAST([PREVIOUS EligibilityEnd] AS datetime) = TRY_CONVERT(datetime,'2078-12-31 00:00:00.000')
THEN CAST(GETDATE() AS datetime)
ELSE CAST([PREVIOUS EligibilityEnd] AS datetime)+1
END,CAST([EligibilityStart] AS datetime)) AS int)
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM #ContinuousEnrollment
WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ...
	AND GAPinMONTHs IS NULL

		-- SELECT '[RANKis] SAMPLE / TEST' AS [NOTE(S)],* FROM #ContinuousEnrollment WHERE GAP > 0 ORDER BY GAP DESC
		-- SELECT '[RANKis] SAMPLE / TEST' AS [NOTE(S)],* FROM #ContinuousEnrollment WHERE memid IN ('912896') ORDER BY memid,[RANKis]







-- ==========================================================	
	-- ID multiple GAP(s) of ANYTIME / ALLTIME--
-- ==========================================================		
-----------------------------------------------------------------------------------------------------------------------------
	-- Error Trapping: Check If Permanent Table(s) Already Exist(s) And Drop If Applicable --
-----------------------------------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS #TotalDaysEnrolled -- SQL Server 2016 and later -- DYNAMIC tmp OR STATIC [TABLE] #TableName is a local temporary table visible only in the current session; ##TableName is a GLOBAL temporary table visible to all sessions IN ('TempDB')

SELECT memid
,SUM(DaysEnrolled) AS [Total Day(s) Enrolled] 
,SUM(MonthsEnrolled) AS [Total Month(s) Enrolled] 
,CAST(NULL AS int) AS [GAP(s) of]
INTO #TotalDaysEnrolled
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM #ContinuousEnrollment
GROUP BY memid

	--DUP(s)--
SELECT ' ' AS 'SHOULD BE NULL DUP Validation',*
FROM #TotalDaysEnrolled
WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ...
	AND LTRIM(RTRIM(memid)) IN 
	( -- INITIATE ...
	SELECT LTRIM(RTRIM(dup.memid))
	FROM #TotalDaysEnrolled AS dup
	GROUP BY LTRIM(RTRIM(dup.memid)) --Duplication Driver
	HAVING COUNT(1)>1 --HAVING clause RESERVED for AGGREGATE(s)
	) -- CONCLUDE ...

		-- SELECT DISTINCT [Total Month(s) Enrolled] FROM #TotalDaysEnrolled ORDER BY [Total Month(s) Enrolled] DESC
		-- SELECT DISTINCT [Total Month(s) Enrolled],[Total Day(s) Enrolled] FROM #TotalDaysEnrolled ORDER BY [Total Month(s) Enrolled] DESC







-----------------------------------------------------------------------------------------------------------------------------
	-- Error Trapping: Check If Permanent Table(s) Already Exist(s) And Drop If Applicable --
-----------------------------------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS #GAP -- SQL Server 2016 and later -- DYNAMIC tmp OR STATIC [TABLE] #TableName is a local temporary table visible only in the current session; ##TableName is a GLOBAL temporary table visible to all sessions IN ('TempDB')
 
SELECT memid
,COUNT(1) AS GAPS
INTO #GAP
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM #ContinuousEnrollment
WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ...
	-- AND GAPinDAYs>= @GAPOF --IN DAY(s)
	AND ISNULL(GAPinMONTHs,0) >= @GAPOF --IN MONTH(s)
GROUP BY memid

	--DUP(s)--
SELECT ' ' AS 'SHOULD BE NULL DUP Validation',*
FROM #GAP
WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ...
	AND LTRIM(RTRIM(memid)) IN 
	( -- INITIATE ...
	SELECT LTRIM(RTRIM(dup.memid))
	FROM #GAP AS dup
	GROUP BY LTRIM(RTRIM(dup.memid)) --Duplication Driver
	HAVING COUNT(1)>1 --HAVING clause RESERVED for AGGREGATE(s)
	) -- CONCLUDE ...

		-- SELECT * FROM #GAP ORDER BY GAPS DESC
		-- SELECT GAPinDAYs,GAPinMONTHs,[PREVIOUS EligibilityEnd],* FROM #ContinuousEnrollment WHERE UPPER(LTRIM(RTRIM(memid))) IN ('2133890        ')  --SAMPLE







-- ==========================================================
	-- ISOLATE POPULATION BASED ON [GAP IN...] COVERAGE --
-- ==========================================================
UPDATE #TotalDaysEnrolled --DETERMINE PRESENCE OF GAP(s) IN COVERAGE FOR SPECIFIED [RANGE]
SET [GAP(s) of] = g.GAPS
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
--SELECT DISTINCT [GAP(s) of] --CHECK 1st
FROM #TotalDaysEnrolled AS t
	JOIN #GAP AS g ON t.memid = g.memid

-- DELETE 
SELECT TOP 10 ' ' AS 'POSSIBLY DELETE THESE RECORD(S)',* -- CHECK 1st
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM #TotalDaysEnrolled --LEFT w ONLY ELIGIBLE POPULATION
WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ...
	AND ISNULL([GAP(s) of],0) > @MAXGAP -- ... Continuous enrollment is defined as no more than one gap in enrollment of up to 45 days during the reporting period (i.e., January through December). To determine continuous enrollment for a member for whom enrollment is verified monthly, the member may not have more than a 1-month gap in coverage (i.e., a member whose coverage lapses for 2 months [60 days] is not considered continuously enrolled) ...







-- ===========================================
	-- INITIATE INDEX() / CONSECUTIVE() UPDATE(S) --
-- ===========================================
UPDATE #ContinuousEnrollment
SET [CONSECUTIVE] = 0 -- RESET RESTART REFRESH
,[Index EligibilityID] = CAST(NULL AS nvarchar(255))
,[Index Eligibility Start Date] = CAST(NULL AS date)
,[Index Eligibility End Date] = CAST(NULL AS date)

UPDATE #ContinuousEnrollment
SET [CONSECUTIVE] = 1
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM #ContinuousEnrollment
WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ... AND ...
	AND [CONSECUTIVE] = 0
	AND GAPinMONTHs = 0
	AND RANKis != 1

UPDATE #ContinuousEnrollment
SET [Index EligibilityID] = TRY_CONVERT(nvarchar(25),[Health Plan ID])+'-'+TRY_CONVERT(nvarchar(10),TRY_CONVERT(date,EligibilityStart))
,[Index Eligibility Start Date] = TRY_CONVERT(date,EligibilityStart)
,[Index Eligibility End Date] = TRY_CONVERT(date,EligibilityEnd)
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM #ContinuousEnrollment
WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ... AND ...
	AND [Index Eligibility Start Date] IS NULL
	AND RANKis = 1

UPDATE #ContinuousEnrollment
SET [Index EligibilityID] = TRY_CONVERT(nvarchar(25),[Health Plan ID])+'-'+TRY_CONVERT(nvarchar(10),TRY_CONVERT(date,EligibilityStart))
,[Index Eligibility Start Date] = TRY_CONVERT(date,EligibilityStart)
,[Index Eligibility End Date] = TRY_CONVERT(date,EligibilityEnd)
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM #ContinuousEnrollment
WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ... AND ...
	AND [Index Eligibility Start Date] IS NULL
	AND CONSECUTIVE = 0

		-- SELECT * FROM #ContinuousEnrollment







-- ======================================================================
	-- SQL #PYTHON FOR WHILE LOOP() BREAK / FEEDBACK LOOP() CONDITION(S) -- 
-- ======================================================================
DECLARE @rowCount int;
WHILE (1=1)
BEGIN

		UPDATE #ContinuousEnrollment
		SET [Index EligibilityID] = loopce.[Index EligibilityID]
		,[Index Eligibility Start Date] = loopce.[Index Eligibility Start Date]
		,[Index Eligibility End Date] = TRY_CONVERT(date,ce.EligibilityEnd)
		-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
		-- SELECT DISTINCT ' ' AS 'CHECK 1st'
		FROM #ContinuousEnrollment AS ce
			JOIN 
			( -- INITIATE ...
			SELECT DISTINCT memid
			,EligibilityStart
			,EligibilityEnd
			,[Index EligibilityID]
			,[Index Eligibility Start Date]
			,[Index Eligibility End Date]
			FROM #ContinuousEnrollment 
			WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ... AND ...
				AND [Index Eligibility Start Date] IS NOT NULL
			) -- CONCLUDE ...
			AS loopce ON ce.memid = loopce.memid
				AND TRY_CONVERT(date,ce.[PREVIOUS EligibilityStart]) = TRY_CONVERT(date,loopce.EligibilityStart)
				AND TRY_CONVERT(date,ce.[PREVIOUS EligibilityEnd]) = TRY_CONVERT(date,loopce.EligibilityEnd)
		WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ... AND ...
			AND ce.[Index Eligibility Start Date] IS NULL
			AND ce.CONSECUTIVE = 1

		-- SELECT * FROM #ContinuousEnrollment

SET @rowCount = @@ROWCOUNT;
IF (@rowCount = 0)
BREAK;
END







-- =============================================
	-- CONCLUDE INDEX() / CONSECUTIVE() UPDATE(S) --
-- =============================================
UPDATE #ContinuousEnrollment
SET [Index Eligibility End Date] = finish.[Index Eligibility End Date]
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM #ContinuousEnrollment AS ce
	JOIN 
	( -- INITIATE ...
	SELECT [Index EligibilityID],MAX([Index Eligibility End Date]) AS [Index Eligibility End Date]
	FROM #ContinuousEnrollment 
	WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ... AND 
		AND [Index EligibilityID] IS NOT NULL
	GROUP BY [Index EligibilityID]
	) -- CONCLUDE ...
	AS finish ON ce.[Index EligibilityID] = finish.[Index EligibilityID]

UPDATE #ContinuousEnrollment
SET [CONSECUTIVE DAY(S)] = finish.[CONSECUTIVE DAY(S)]
,[CONSECUTIVE MONTH(S)] = finish.[CONSECUTIVE MONTH(S)]
FROM #ContinuousEnrollment AS ce
	JOIN 
	( -- INITIATE ...
	SELECT [Index EligibilityID]
	,DATEDIFF("m",TRY_CONVERT(date,[Index Eligibility Start Date]),TRY_CONVERT(date,[Index Eligibility End Date]))+1 AS [CONSECUTIVE MONTH(S)]
	,DATEDIFF("d",TRY_CONVERT(date,[Index Eligibility Start Date]),TRY_CONVERT(date,[Index Eligibility End Date]))+1 AS [CONSECUTIVE DAY(S)]
	FROM #ContinuousEnrollment 
	WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ... AND 
	GROUP BY [Index EligibilityID]
	,DATEDIFF("m",TRY_CONVERT(date,[Index Eligibility Start Date]),TRY_CONVERT(date,[Index Eligibility End Date]))+1
	,DATEDIFF("d",TRY_CONVERT(date,[Index Eligibility Start Date]),TRY_CONVERT(date,[Index Eligibility End Date]))+1
	) -- CONCLUDE 
	AS finish ON ce.[Index EligibilityID] = finish.[Index EligibilityID]

		-- SELECT * FROM #ContinuousEnrollment






-----------------------------------------------------------------------------------------------------------------------------
	-- Error Trapping: Check If Permanent Table(s) Already Exist(s) And Drop If Applicable --
-----------------------------------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS #EligiblePopulation -- SQL Server 2016 and later -- DYNAMIC tmp OR STATIC [TABLE] #TableName is a local temporary table visible only in the current session; ##TableName is a GLOBAL temporary table visible to all sessions IN ('TempDB')
 
SELECT tde.[Total Day(s) Enrolled],tde.[Total Month(s) Enrolled],ce.*
INTO #EligiblePopulation
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM #ContinuousEnrollment AS ce
	JOIN #TotalDaysEnrolled AS tde ON ce.memid = tde.memid

	--DUP(s)--
SELECT ' ' AS 'SHOULD BE NULL DUP Validation',*
FROM #EligiblePopulation
WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ... AND ...
	AND LTRIM(RTRIM(memid))+LTRIM(RTRIM(calendar_date))+LTRIM(RTRIM(effdate)) IN 
	( -- INITITATE ...
	SELECT LTRIM(RTRIM(dup.memid))+LTRIM(RTRIM(dup.calendar_date))+LTRIM(RTRIM(dup.effdate))
	FROM #EligiblePopulation AS dup
	GROUP BY LTRIM(RTRIM(dup.memid))+LTRIM(RTRIM(dup.calendar_date))+LTRIM(RTRIM(dup.effdate)) --Duplication Driver
	HAVING COUNT(1)>1 --HAVING clause RESERVED for AGGREGATE(s)
	) -- CONCLUDE ...

		/* SELECT DISTINCT '' AS 'QA LOOP SEQUENCE',memid
		,EligibilityStart
		,EligibilityEnd
		,[Index EligibilityID]
		,[Index Eligibility Start Date]
		,[Index Eligibility End Date]
		FROM #ContinuousEnrollment 
		WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ... AND ...
			AND [Index Eligibility Start Date] IS NOT NULL */
			
		SELECT ' ' AS '#BASELINE - SUMMARY: ',COUNT(DISTINCT(memid)) AS [Total unique members during the reporting period]
		,MIN(AGE) AS MINage
		,MAX(AGE) AS MAXage 
		FROM #EligiblePopulation 
		WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ... AND ...
		
		SELECT DISTINCT ' ' AS '#BASELINE - SAMPLE / HIGH LEVEL SUMARY: ',[LOB],[Health Plan ID],memid,fullname
		,[CONSECUTIVE DAY(S)],[CONSECUTIVE MONTH(S)]
		,TRY_CONVERT(decimal(9,1),([Total Day(s) Enrolled]/365.25)) AS [Total Year(s) Enrolled]
		,CAST(TRY_CONVERT(int,([Total Day(s) Enrolled]/365.25)) AS nvarchar(255))+' YEAR(S) AND '+CAST(([Total Month(s) Enrolled])-(TRY_CONVERT(int,([Total Day(s) Enrolled]/365.25))*12) AS nvarchar(255))+ ' MONTH(S)' AS [Total Year(s) & How Many Months Enrolled]
		,[Total Month(s) Enrolled]
		,[Total Day(s) Enrolled] 
		FROM #EligiblePopulation		

		SELECT ' ' AS '#FILTER / @param - SUMMARY: '
		,COUNT(DISTINCT(memid)) AS [Total unique members during the reporting period]
		,MIN(AGE) AS MINage
		,MAX(AGE) AS MAXage 
		FROM #EligiblePopulation 
		WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ... AND ...
			AND [CONSECUTIVE MONTH(S)] = @ContinuousMonths
			AND TRY_CONVERT(date,EligibilityEnd) = TRY_CONVERT(date,@CEClockStop)
			AND [AGE] >@AgeCutoff

		SELECT ' ' AS '#FILTER / @param - DETAIL: ...)',* 
		FROM #EligiblePopulation 
		WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ... AND ...
			AND [CONSECUTIVE MONTH(S)] = @ContinuousMonths
			AND TRY_CONVERT(date,EligibilityEnd) = TRY_CONVERT(date,@CEClockStop)
			AND [AGE] >@AgeCutoff			







-----------------------------------------------------------------------------------------------------------------------------
	-- Error Trapping: Check If Permanent Table(s) Already Exist(s) And Drop If Applicable --
-----------------------------------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS #EligiblePopulationMM -- SQL Server 2016 and later -- DYNAMIC tmp OR STATIC [TABLE] #TableName is a local temporary table visible only in the current session; ##TableName is a GLOBAL temporary table visible to all sessions IN ('TempDB')
 
SELECT * 
INTO #EligiblePopulationMM --IneligiblePopulationMM
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM #TotalDaysEnrolled

		-- SELECT * FROM #EligiblePopulationMM







-- ==========================================================
	-- ISOLATE POPULATION BASED ON [MM] VAL() + OR - --
-- ==========================================================
/* DECLARE @MINMM AS int

SET @MINMM = 3

-- DELETE 
SELECT TOP 10 ' ' AS 'DELETE FROM EligiblePopulation BASED ON ... ',* -- CHECK 1st
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM #EligiblePopulation
WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ...
	AND [Total Month(s) Enrolled] < @MINMM -- REMOVE MEMBERS NOT <> != ENROLLED FOR THE SPECIFIED [MONTH](s)

-- DELETE 
SELECT TOP 10 ' ' AS 'DELETE FROM EligiblePopulationMM BASED ON ... ',* -- CHECK 1st
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM #EligiblePopulationMM
WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ...
	AND [Total Month(s) Enrolled] < @MINMM -- REMOVE MEMBERS NOT <> != ENROLLED FOR THE SPECIFIED [MONTH](s */







-- ======================================
	-- NOTE(S) / COMMENT(S) / CHANGE.LOG --
-- ======================================
