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

SET @CEClockStart = TRY_CONVERT(date,'01/01/2025') 
-- SET @CEClockStart = TRY_CONVERT(date,'01/01/1982') -- GO LIVE: CHGSD
SET @CEClockStop = TRY_CONVERT(date,GETDATE())
SET @isoday = 1 -- CALENDAR DAY ISO ... / EFFECTIVE AS OF WHICH DAY IN GIVEN MONTH? 
SET @isomem = NULL -- '%1083184%' -- ('912896','1043158','1083184') -- [RANKis] SAMPLE / TEST
SET @GAPOF = 1
SET @MAXGAP = 1 -- PARAMETERIZE the maximum allowable gap
SET @lob = NULL -- IN ('MEDI-CAL BENEFIT PLAN','DSNP MEDI-CAL PLAN','COMMUNITY Y MAS (HMO C-SNP)','IV_DSNP2 MEDI-CAL PLAN','CHG MARKETPLACE HMO PLAN') -- VALID ACTIVE OPTION(S)
SET @ContinuousMonths = 3
SET @AgeCutoff = 20

		SELECT TOP 1 ' ' AS '50 YEAR CALENDAR  ... CREATING A STATIC CONTINUOUS ENROLLMENT SOURCE...'
		,'USE CASE SEE ECM / CS QUARTERLY TAB 1 LOGIC' AS [NOTE(S)]
		,MIN(calendar_date) AS MINdt
		,MAX(calendar_date) AS MAXdt
		,bp.LINE_OF_BUSINESS
		,'BETWEEN '+CAST(CAST(@CEClockStart AS date) AS varchar (25))+' AND '+CAST(CAST(@CEClockStop AS date) AS varchar (25)) AS [RANGE NOTE(s)]
		,@AgeCutoff AS [AGE LIMIT >= (GREATER THAN EQUAL TO)]
		,ISNULL(@lob,'ALL LOB(S)') AS 'WHICH LOB'
		,dc.calendar_day AS 'ELIGIBILTY DETERMINATION DAY'
		,TRY_CONVERT(date,(SELECT DATEADD(month,-1,MAX(last_day_in_month)) FROM INFORMATICS.[dbo].date_calendarISO AS dc WHERE 1=1 AND dc.calendar_date BETWEEN @CEClockStart AND @CEClockStop)) AS 'Cutoff [Enrollment Category] date'
		--,bp.*
		FROM INFORMATICS.dbo.[uvw_LINE_OF_BUSINESS] AS bp,INFORMATICS.[dbo].date_calendarISO AS dc -- DO NOT NO NEGATIVE <> != COVER UP THE TE() ... 50 YEAR CALENDAR
		WHERE 1=1
			AND bp.[PLAN] IN ('MEDI-CAL BENEFIT PLAN','DSNP MEDI-CAL PLAN','COMMUNITY Y MAS (HMO C-SNP)','IV_DSNP2 MEDI-CAL PLAN','CHG MARKETPLACE HMO PLAN') -- VALID ACTIVE OPTION(S)
			-- AND bp.[LINE_OF_BUSINESS] LIKE ISNULL('%'+@lob+'%','%')
			AND bp.[PLAN] LIKE ISNULL('%'+@lob+'%','%')
			-- AND bp.[PROGRAM] LIKE ISNULL('%'+@lob+'%','%')
		GROUP BY bp.LINE_OF_BUSINESS,dc.calendar_day







-----------------------------------------------------------------------------------------------------------------------------
	-- Error Trapping: Check If Permanent Table(s) Already Exist(s) And Drop If Applicable --
-----------------------------------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS #RANKLAG -- SQL Server 2016 and later -- DYNAMIC tmp OR STATIC [TABLE] #TableName is a local temporary table visible only IN the current session; ##TableName is a GLOBAL temporary table visible to all sessions IN ('TempDB')

SELECT DISTINCT  ' ' AS 'CONTINUOUS ENROLLMENT'
,DENSE_RANK() OVER(PARTITION BY ek.memid ORDER BY dc.calendar_date ASC) AS [RANKis]
,ROW_NUMBER() OVER(PARTITION BY ek.memid ORDER BY dc.calendar_date ASC) AS [ROWis]
,TRY_CONVERT(date,first_day_in_month) AS [EligibilityStart]
,TRY_CONVERT(date,last_day_in_month) AS [EligibilityEnd]
,dc.calendar_date
,first_day_in_month
,last_day_in_month
,CASE
WHEN LEN(SUBSTRING(UPPER(LTRIM(RTRIM(ISNULL(ek.carriermemid,'')))),1,10)) = 10
THEN SUBSTRING(UPPER(LTRIM(RTRIM(ISNULL(ek.carriermemid,'')))),1,10)
ELSE TRY_CONVERT(nvarchar(10),NULL)
END AS 'Health Plan ID'
,SUBSTRING(UPPER(LTRIM(RTRIM(ISNULL(mem.secondaryid,'')))),1,9) AS [CIN]
,ek.memid,mem.fullname
,ek.effdate,ek.termdate
,CAST(SUBSTRING(CAST(CAST(DATEDIFF("dd",TRY_CONVERT(date,mem.dob),TRY_CONVERT(date,@CEClockStop))/365.25 AS money) AS nvarchar(25)),1,CHARINDEX('.',CAST(DATEDIFF("dd",TRY_CONVERT(date,mem.dob),TRY_CONVERT(date,@CEClockStop))/365.25 AS money),1)-1) AS int) AS [AGE]
,CAST(NULL AS nvarchar(100)) AS 'AGECx'
,CAST(NULL AS nvarchar(100)) AS 'Enrollment Category'
,TRY_CONVERT(date,mem.DOB) AS [DOB]
,bp.LINE_OF_BUSINESS AS [LOB]
,bp.PROGRAM
,DATEDIFF("d",TRY_CONVERT(date,dc.first_day_in_month),TRY_CONVERT(date,dc.last_day_in_month))+1 AS DaysEnrolled -- FUTURE 1 to include START DATE ELSE SEE 'STEP03b_DaysLogic_20140423.sql' CASE statement SYNTAX 
,CAST(1 AS int) AS MonthsEnrolled --LIKE '%,CAST(1 AS int) AS MMcount%'
 INTO #RANKLAG
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'

FROM INFORMATICS.dbo.date_calendarISO AS dc,HMOPROD_PLANDATA.dbo.enrollkeys AS ek (NOLOCK) -- DO NOT NO NEGATIVE <> != COVER UP THE TE() ... 50 YEAR CALENDAR
-- FROM INFORMATICS.dbo.date_calendarCE AS dc,HMOPROD_PLANDATA.dbo.enrollkeys AS ek -- DO NOT NO NEGATIVE <> != COVER UP THE TE() ... 40 YEAR CALENDAR 1st OF THE MONTH ONLY!!!
	JOIN HMOPROD_PLANDATA.dbo.member AS mem (NOLOCK) ON ek.memid = mem.memid
	JOIN INFORMATICS.dbo.[uvw_LINE_OF_BUSINESS] AS bp (NOLOCK) ON ek.planid = bp.planid
	
	/* JOIN -- MEMBERSHIP ISOLATION ...
	( -- INITIATE ...
	SELECT DISTINCT c.memid FROM INFORMATICS.dbo.DMHCAUDITPDR AS pdr JOIN HMOPROD_PLANDATA.dbo.claim AS c ON pdr.[Claim number] = c.claimid
	) -- CONCLUDE ...
	AS iso ON ek.memid = iso.memid */

WHERE 1=1
	AND UPPER(LTRIM(RTRIM(ISNULL(ek.segtype,'')))) ='INT'
	AND ISNULL(mem.IsSubscriber,'') = 'Y' -- ISO ON SUBSCRIBER ONLY!!!
	AND TRY_CONVERT(date,ISNULL(ek.termdate,@CEClockStop)) > TRY_CONVERT(date,ek.effdate) -- MUST BE TRUE ... NON-CROSSFOOTED RECORDS ARE ACTIVE ...
	AND TRY_CONVERT(date,dc.calendar_date) BETWEEN @CEClockStart AND @CEClockStop -- SET REPORTING PERIOD LOCK AND ...
	AND dc.calendar_date = dc.last_day_in_month -- dc.calendar_day = @isoday -- CALENDAR DAY ISO ... / EFFECTIVE AS OF WHICH DAY IN GIVEN MONTH?
	AND TRY_CONVERT(date,ek.effdate) <= TRY_CONVERT(date,dc.calendar_date) -- WITHIN reporting period [RANGE] OPPOSITION 
	AND TRY_CONVERT(date,ISNULL(ek.termdate,@CEClockStop)) >= TRY_CONVERT(date,dc.calendar_date) -- WITHIN reporting period 
	AND bp.[PLAN] IN ('MEDI-CAL BENEFIT PLAN','DSNP MEDI-CAL PLAN','COMMUNITY Y MAS (HMO C-SNP)','IV_DSNP2 MEDI-CAL PLAN','CHG MARKETPLACE HMO PLAN') -- VALID ACTIVE OPTION(S)
	-- AND bp.[LINE_OF_BUSINESS] LIKE ISNULL('%'+@lob+'%','%')
	AND bp.[PLAN] LIKE ISNULL('%'+@lob+'%','%')
	-- AND bp.[PROGRAM] LIKE ISNULL('%'+@lob+'%','%')
	-- AND ek.memid LIKE ISNULL(@isomem,'%') -- ('912896''1043158','1083184') -- [RANKis] SAMPLE / TEST

	-- ADD indexes to improve query performance
CREATE INDEX idx_REFACTOR_DupID ON #RANKLAG (memid,EligibilityStart);







-----------------------------------------------------------------------------------------------------------------------------
	-- Error Trapping: Check If Permanent Table(s) Already Exist(s) And Drop If Applicable --
-----------------------------------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS #ContinuousEnrollment -- SQL Server 2016 and later -- DYNAMIC tmp OR STATIC [TABLE] #TableName is a local temporary table visible only IN the current session; ##TableName is a GLOBAL temporary table visible to all sessions IN ('TempDB')

SELECT ' ' AS 'LEAD + LAG: ' -- ,effdate,termdate -- x LEAD() AHEAD TO Accesses the value stored IN a row after the current row. Function Syntax Function Description ... Windowed functions cannot be used IN the context of another windowed function or aggregate. / Windowed functions can only appear IN the SELECT or ORDER BY clauses. + -- x LAG() BEHIND Accesses the value stored IN a row before the current row... Windowed functions cannot be used IN the context of another windowed function or aggregate. / Windowed functions can only appear IN the SELECT or ORDER BY clauses.
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
WHERE 1=1

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
DROP TABLE IF EXISTS #TotalDaysEnrolled -- SQL Server 2016 and later -- DYNAMIC tmp OR STATIC [TABLE] #TableName is a local temporary table visible only IN the current session; ##TableName is a GLOBAL temporary table visible to all sessions IN ('TempDB')

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
DROP TABLE IF EXISTS #GAP -- SQL Server 2016 and later -- DYNAMIC tmp OR STATIC [TABLE] #TableName is a local temporary table visible only IN the current session; ##TableName is a GLOBAL temporary table visible to all sessions IN ('TempDB')
 
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
	AND ISNULL([GAP(s) of],0) > @MAXGAP -- ... Continuous enrollment is defined as no more than one gap IN enrollment of up to 45 days during the reporting period (i.e., January through December). To determine continuous enrollment for a member for whom enrollment is verified monthly, the member AS may not have more than a 1-month gap IN coverage (i.e., a member whose coverage lapses for 2 months [60 days] is not considered continuously enrolled) ...







-- ===========================================
	-- INITIATE INDEX() / CONSECUTIVE() UPDATE(S) --
-- ===========================================
UPDATE #ContinuousEnrollment
SET [CONSECUTIVE] = 0 -- POWER CYCLE RESET REFRESH RESTART ... 
,[Index EligibilityID] = CAST(NULL AS nvarchar(255))
,[Index Eligibility Start Date] = CAST(NULL AS date)
,[Index Eligibility End Date] = CAST(NULL AS date)

UPDATE #ContinuousEnrollment
SET [CONSECUTIVE] = 1
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM #ContinuousEnrollment
WHERE 1=1
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
WHERE 1=1
	AND [Index Eligibility Start Date] IS NULL
	AND RANKis = 1

UPDATE #ContinuousEnrollment
SET [Index EligibilityID] = TRY_CONVERT(nvarchar(25),[Health Plan ID])+'-'+TRY_CONVERT(nvarchar(10),TRY_CONVERT(date,EligibilityStart))
,[Index Eligibility Start Date] = TRY_CONVERT(date,EligibilityStart)
,[Index Eligibility End Date] = TRY_CONVERT(date,EligibilityEnd)
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM #ContinuousEnrollment
WHERE 1=1
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
			WHERE 1=1
				AND [Index Eligibility Start Date] IS NOT NULL
			) -- CONCLUDE ...
			AS loopce ON ce.memid = loopce.memid
				AND TRY_CONVERT(date,ce.[PREVIOUS EligibilityStart]) = TRY_CONVERT(date,loopce.EligibilityStart)
				AND TRY_CONVERT(date,ce.[PREVIOUS EligibilityEnd]) = TRY_CONVERT(date,loopce.EligibilityEnd)
		WHERE 1=1
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






-- =====================================================================
	-- ADD, TERMS (DISENROLL) AND HODL MEMBER IDENTIFICATION LOGIC:
-- =====================================================================
-----------------------------------------------------------------------------------------------------------------------------
	-- Error Trapping: Check If Permanent Table(s) Already Exist(s) And Drop If Applicable --
-----------------------------------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS #EligiblePopulation -- SQL Server 2016 and later -- DYNAMIC tmp OR STATIC [TABLE] #TableName is a local temporary table visible only IN the current session; ##TableName is a GLOBAL temporary table visible to all sessions IN ('TempDB')
 
SELECT tde.[Total Day(s) Enrolled],tde.[Total Month(s) Enrolled],ce.*
INTO #EligiblePopulation
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM #ContinuousEnrollment AS ce
	JOIN #TotalDaysEnrolled AS tde ON ce.memid = tde.memid

	--DUP(s)--
SELECT ' ' AS 'SHOULD BE NULL DUP Validation',*
FROM #EligiblePopulation
WHERE 1=1
	AND LTRIM(RTRIM(memid))+LTRIM(RTRIM(calendar_date))+LTRIM(RTRIM(effdate)) IN 
	( -- INITITATE ...
	SELECT LTRIM(RTRIM(dup.memid))+LTRIM(RTRIM(dup.calendar_date))+LTRIM(RTRIM(dup.effdate))
	FROM #EligiblePopulation AS dup
	GROUP BY LTRIM(RTRIM(dup.memid))+LTRIM(RTRIM(dup.calendar_date))+LTRIM(RTRIM(dup.effdate)) --Duplication Driver
	HAVING COUNT(1)>1 --HAVING clause RESERVED for AGGREGATE(s)
	) -- CONCLUDE ...

UPDATE  #EligiblePopulation
SET [Enrollment Category] = CAST(NULL AS nvarchar(100))-- POWER CYCLE RESET REFRESH RESTART ...  

UPDATE  #EligiblePopulation
SET [Enrollment Category] = CASE 
WHEN CONSECUTIVE = 0
	AND [Total Month(s) Enrolled] = 1
	AND TRY_CONVERT(date,EligibilityEnd) < TRY_CONVERT(date,(SELECT DATEADD(month,-1,MAX(last_day_in_month)) FROM INFORMATICS.[dbo].date_calendarISO AS dc WHERE 1=1 AND dc.calendar_date BETWEEN @CEClockStart AND @CEClockStop)) -- AS 'Cutoff [Enrollment Category] date'
THEN 'DISENROLLED' -- 834 Adds
WHEN CONSECUTIVE = 0
THEN 'ADDED' -- 834 Adds
WHEN DATEDIFF("d",TRY_CONVERT(date,ISNULL(EligibilityEnd,GETDATE())),TRY_CONVERT(date,[FUTURE EligibilityStart])) > 1
	AND CONSECUTIVE = 1
	AND [FUTURE EligibilityEnd] IS NOT NULL
THEN 'DISENROLLED'
WHEN [Total Month(s) Enrolled] >= 1
	AND CONSECUTIVE = 1
	AND TRY_CONVERT(date,ISNULL(EligibilityEnd,GETDATE())) BETWEEN TRY_CONVERT(date,ISNULL([Index Eligibility Start Date],GETDATE())) AND TRY_CONVERT(date,ISNULL([Index Eligibility End Date],GETDATE())) -- EXISTING: consecutive enrollment
	AND [FUTURE EligibilityEnd] IS NOT NULL
THEN 'EXISTING'
WHEN TRY_CONVERT(date,EligibilityEnd) = TRY_CONVERT(date,(SELECT DATEADD(month,-1,MAX(last_day_in_month)) FROM INFORMATICS.[dbo].date_calendarISO AS dc WHERE 1=1 AND dc.calendar_date BETWEEN @CEClockStart AND @CEClockStop)) -- AS 'Cutoff [Enrollment Category] date'
THEN 'HODL'
WHEN TRY_CONVERT(date,EligibilityEnd) < TRY_CONVERT(date,(SELECT DATEADD(month,-1,MAX(last_day_in_month)) FROM INFORMATICS.[dbo].date_calendarISO AS dc WHERE 1=1 AND dc.calendar_date BETWEEN @CEClockStart AND @CEClockStop)) -- AS 'Cutoff [Enrollment Category] date'
THEN 'DISENROLLED'
ELSE 'HODL' -- 834 Terms
END
FROM  #EligiblePopulation AS pep







-- =============================================================
	-- SUMMARY / SUBTOTAL() ROLLUP v. CUBE --
-- =============================================================
		SELECT ' ' AS '#BASELINE - SUMMARY: ',LOB
		,COUNT(DISTINCT(memid)) AS [Total unique members during the reporting period]
		,MIN(AGE) AS MINage
		,MAX(AGE) AS MAXage
		,MAX([Total Month(s) Enrolled]) AS [MAXmonths]
		,MAX(TRY_CONVERT(decimal(9,1),([Total Day(s) Enrolled]/365.25))) AS [MAXyears]
		FROM #EligiblePopulation 
		GROUP BY LOB

		SELECT DISTINCT ' ' AS '#BASELINE - SAMPLE / HIGH LEVEL SUMARY: ',[LOB],[Health Plan ID],memid,fullname
		,[CONSECUTIVE DAY(S)],[CONSECUTIVE MONTH(S)]
		,TRY_CONVERT(decimal(9,1),([Total Day(s) Enrolled]/365.25)) AS [Total Year(s) Enrolled]
		,CAST(TRY_CONVERT(int,([Total Day(s) Enrolled]/365.25)) AS nvarchar(255))+' YEAR(S) AND '+CAST(([Total Month(s) Enrolled])-(TRY_CONVERT(int,([Total Day(s) Enrolled]/365.25))*12) AS nvarchar(255))+ ' MONTH(S)' AS [Total Year(s) & How Many Months Enrolled]
		,[Total Month(s) Enrolled]
		,[Total Day(s) Enrolled] 
		FROM #EligiblePopulation
		WHERE 1=1
			-- AND [CONSECUTIVE MONTH(S)] >= 12 -- @ContinuousMonths
			-- AND [AGE] >= @AgeCutoff
			-- AND [Total Month(s) Enrolled] >= @ContinuousMonths

		SELECT ' ' AS '#FILTER / @param - SUMMARY: '
		,COUNT(DISTINCT(memid)) AS [Total unique members during the reporting period]
		,MIN(AGE) AS MINage
		,MAX(AGE) AS MAXage 
		FROM #EligiblePopulation 
		WHERE 1=1
			AND [CONSECUTIVE MONTH(S)] = @ContinuousMonths
			AND TRY_CONVERT(date,EligibilityEnd) = TRY_CONVERT(date,@CEClockStop)
			AND [AGE] >@AgeCutoff

		SELECT ' ' AS '#FILTER / @param - DETAIL: ...)',* 
		FROM #EligiblePopulation 
		WHERE 1=1
			AND [CONSECUTIVE MONTH(S)] = @ContinuousMonths
			AND TRY_CONVERT(date,EligibilityEnd) = TRY_CONVERT(date,@CEClockStop)
			AND [AGE] >@AgeCutoff

		/* SELECT DISTINCT '' AS 'QA LOOP SEQUENCE',memid
		,EligibilityStart
		,EligibilityEnd
		,[Index EligibilityID]
		,[Index Eligibility Start Date]
		,[Index Eligibility End Date]
		FROM #ContinuousEnrollment 
		WHERE 1=1
			AND [Index Eligibility Start Date] IS NOT NULL */

		SELECT ' ' AS 'SAMPLE - ADD AND TERMS (DISENROLL): ',LOB
		,[Enrollment Category]
		,[Health Plan ID]
		,PROGRAM
		,[Total Month(s) Enrolled]
		,[FUTURE EligibilityStart]
		,[FUTURE EligibilityEnd]
		,CONSECUTIVE
		,EligibilityStart
		,EligibilityEnd
		,GAPinMONTHs
		,DATEDIFF("d",TRY_CONVERT(date,ISNULL(EligibilityEnd,GETDATE())),TRY_CONVERT(date,[FUTURE EligibilityStart])) AS 'CHECK THE DIFF'
		,ep.*
		-- SELECT DISTINCT [Enrollment Category]
		FROM  #EligiblePopulation AS ep
		WHERE 1=1
			-- AND [Total Month(s) Enrolled] = 27
			--AND memid IN (SELECT memid 
			--FROM  #EligiblePopulation
			--WHERE 1=1
			--	AND [Total Month(s) Enrolled] IN (	SELECT MAX([Total Month(s) Enrolled]) FROM  #EligiblePopulation)
			AND memid IN ('85550','1040646','89842')	 -- ONE 1 ACTIVE ONE 1 DISENROLLED ONE 1 WITH() GAP(S)
				-- OR GAPinMONTHs != 0
		ORDER BY ep.memid,ep.PROGRAM,TRY_CONVERT(date,ISNULL(EligibilityStart,GETDATE())) DESC

		SELECT ' ' AS 'SAMPLE - ADDS AND TERMS (DISENROLL) SUMMARY: ',LOB
		,[Enrollment Category]
		,CASE 
		WHEN [Enrollment Category] IN ('DISENROLLED')
		THEN DATEADD(day,1,TRY_CONVERT(date,EligibilityEnd))
		ELSE TRY_CONVERT(date,EligibilityStart)
		END AS'Enrollment Category Month'
		,COUNT(DISTINCT(memid)) AS [Unique Members]
		FROM  #EligiblePopulation AS ep
		WHERE 1=1
			AND [Enrollment Category] IN ('DISENROLLED','ADDED') -- 'HODL' AS CURRENTLY ACTIVE ...
			AND LOB IN ('MEDI-CAL')
			-- AND memid IN ('85550','1040646','89842')
			AND TRY_CONVERT(date,CASE 
		WHEN [Enrollment Category] IN ('DISENROLLED')
		THEN DATEADD(day,1,TRY_CONVERT(date,EligibilityEnd))
		ELSE TRY_CONVERT(date,EligibilityStart)
		END) != TRY_CONVERT(date,@CEClockStart) -- Start 'MONTH' IGNORED
		GROUP BY LOB,[Enrollment Category]
		,CASE 
		WHEN [Enrollment Category] IN ('DISENROLLED')
		THEN DATEADD(day,1,TRY_CONVERT(date,EligibilityEnd))
		ELSE TRY_CONVERT(date,EligibilityStart)
		END		







-----------------------------------------------------------------------------------------------------------------------------
	-- Error Trapping: Check If Permanent Table(s) Already Exist(s) And Drop If Applicable --
-----------------------------------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS #EligiblePopulationMM -- SQL Server 2016 and later -- DYNAMIC tmp OR STATIC [TABLE] #TableName is a local temporary table visible only IN the current session; ##TableName is a GLOBAL temporary table visible to all sessions IN ('TempDB')
 
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
JAH THANK YOU JAH 'Claude.ai' ON 20240524 - Detailed SQL Script Analysis for Enrollment Reporting

		⏎ MSSQL Script: STEP88_CONTINUOUSenrollment_20240525.sql

Summary: This SQL script calculates continuous enrollment for health plan members over a specified date range. It identifies gaps IN coverage and determines eligibility based ON defined criteria such as maximum allowable gap length.

Key Concepts:	
		1.	Temporary tables are extensively used to store and manipulate intermediate results.
		2.	Date parameters are declared to set the reporting period.
		3.	Enrollee data is joined with a calendar table to generate a record for each member for each month IN the reporting period.
		4.	DENSE_RANK() is used to assign a sequential number to each distinct enrollment period per member.
		5.	LAG() and LEAD() functions are used to look at enrollment start and end dates of adjacent records to identify gaps IN coverage.
		6.	Recursive updates are performed to group contiguous enrollment periods together and calculate total days/months enrolled.
		7.	Loops are used to update enrollment period end dates until no more updates can be made.
		8.	The final output includes total enrolled days, months, years, and longest continuous enrollment period for each member.

Interpretation: This script takes a thorough and methodical approach to calculating continuous enrollment. By breaking the process down into discrete steps and storing intermediate results IN temporary tables, the complex logic is easier to follow and debug. The use of window functions and recursive updates is an efficient way to group contiguous enrollment periods with minimal gaps IN between.

The end result is a comprehensive view of each member''s enrollment history, including any gaps IN coverage, total time enrolled, and longest continuous enrollment period. This output enables further analysis and reporting ON member enrollment patterns and trends.

One potential enhancement would be to parameterize the maximum allowable gap so it could be easily adjusted without modifying the code. Additionally, using a calendar table specific to the reporting period rather than a 50-year table may improve efficiency.

Overall, this script demonstrates strong SQL skills and a good grasp of the business logic required to calculate continuous enrollment. The generous use of comments throughout the code is helpful for explaining the purpose and functionality of each section.

		⏎ Snowflake Script: SNOWFLAKE_CALENDAR_20240524.sql

Summary: This Snowflake SQL script contains two main parts:
		1.	A query to find D-SNP members with a specified number of consecutive enrollment months and minimum age.
		2.	A query to create a member-level calendar table containing all months between each member''s initial and most recent enrollment dates.

Key Concepts:
		1.	Variables are declared for the date range and number of consecutive months to query.
		2.	Temporary tables are created to store the query results.
		3.	The first query joins member AS months, member, and benefit plan data to find D-SNP members meeting the consecutive enrollment and age criteria.
		4.	The second query joins the enrollkeys and calendar tables to generate a row for each month between each member''s initial enrollment and most recent termination date.

Interpretation: The first query demonstrates a concise way to find members meeting a set of enrollment criteria by aggregating at the member level and using HAVING to filter the results. However, there are a couple potential issues to note:
	•	The query assumes there are no gaps IN the enrollment_lob_consecutive_months values per member. If there are gaps, the MAX - MIN calculation may not accurately reflect the longest continuous enrollment period.

	•	Age is calculated based ON the earliest enrollment month rather than a fixed point IN time. This means the same member could be included or excluded from the results depending ON the reporting period.

The second query generates a useful member-level calendar table that could be used as the basis for further analysis or reporting ON enrollment, claims, etc. Filtering the calendar to only include the first day of each month helps reduce the number of rows generated.

A few suggestions for improvement:
		•	Use more descriptive variable names than 'startdate' and 'enddate'.
		•	Add validation to ensure startdate is before enddate.
		•	Consider whether the enrollkeys table may contain overlapping date ranges for a given member and how to handle that scenario.
		•	For the 2nd query, consider adding a condition to only include months within a specified reporting period.

In terms of technical execution, the script follows best practices such as using temporary tables, joining ON specific columns, and aliasing table names. The queries are well-structured and easy to follow.

The two parts of this script serve different purposes but both relate to analyzing member enrollment. The output of the first query could potentially be joined to the calendar table from the second query to further analyze enrollment patterns for the subset of members meeting the specified criteria.

May I have you provide the enhancement code '...parameterize the maximum allowable gap'

		⏎ By parameterizing the maximum allowable gap, you can easily adjust the gap threshold by modifying the value assigned to @MAXGAP at the beginning of the script. This provides flexibility and eliminates the need to change the core logic whenever a different gap threshold is required.

Remember to review and test the enhanced script to ensure it functions as expected with the parameterized gap value.
