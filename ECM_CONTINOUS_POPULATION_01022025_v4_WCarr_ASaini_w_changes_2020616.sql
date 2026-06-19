-- =====================================================================
    -- DECLARE @PARAMETER(S) / @FILTER(S) --
-- =====================================================================
DECLARE @CEClockStart AS date
DECLARE @CEClockStop AS date
DECLARE @ComparisonCEClockStart AS date
DECLARE @ComparisonCEClockStop AS date
DECLARE @isoday AS int
DECLARE @isomem AS nvarchar(25)
DECLARE @GAPOF AS int
DECLARE @MAXGAP AS int
DECLARE @lob AS nvarchar(255)
DECLARE @ContinuousMonths AS decimal(9,0)
DECLARE @AgeCutoff AS decimal(9,0)
DECLARE @ClockStartECM AS datetime
DECLARE @ClockStopECM AS datetime
DECLARE @IPPdtECM AS datetime
DECLARE @ClockStartCostCategory AS datetime
DECLARE @ClockStopCostCategory AS datetime

SET @CEClockStart = TRY_CONVERT(date,'01/01/2021')
SET @CEClockStop = TRY_CONVERT(date,'12/31/2021')
SET @ComparisonCEClockStart = TRY_CONVERT(date,'01/01/2025')
SET @ComparisonCEClockStop = TRY_CONVERT(date,'12/31/2025')
SET @isoday = 1 -- CALENDAR DAY ISO ... / EFFECTIVE AS OF WHICH DAY IN GIVEN MONTH?
SET @isomem = NULL -- '%1083184%' -- ('912896','1043158','1083184') -- [RANKis] SAMPLE / TEST
SET @GAPOF = 1
SET @MAXGAP = 1 -- PARAMETERIZE the maximum allowable gap
SET @lob = 'MEDI-CAL BENEFIT PLAN' -- NULL ... '%'+'DSNP MEDI-CAL PLAN'+'%' ... bp.[OPTION(S)]: IN ('COMMUNITY Y MAS (HMO C-SNP)','DSNP MEDI-CAL PLAN','MEDI-CAL BENEFIT PLAN') ... p.[OPTION(S)]: IN ('DSNP MEDI-CAL','DSNP MEDICARE','COMMUNITY Y MAS (HMO C-SNP)','MEDI-CAL') -- ACTIVE LOB LOCK ... 
--SET @ContinuousMonths = 3
--SET @AgeCutoff = 20

SET @ClockStartECM = '01/01/2022'
--TRY_CONVERT(date,DATEADD(DAY,1,EOMONTH(GETDATE(),-1))) -- AS [1st of CURRENT MONTH] -- EOMONTH ( start_date ,[ month_to_add ] ) ... '07/01/2023'
SET @ClockStopECM = '06/30/2023'
--TRY_CONVERT(date,EOMONTH(GETDATE(),0)) -- AS [EO CURRENT MONTH] -- EOMONTH ( start_date ,[ month_to_add ] ) ... '09/30/2023'
SET @IPPdtECM = TRY_CONVERT(date,GETDATE())
SET @ContinuousMonths = 12


SET @ClockStartCostCategory = TRY_CONVERT(date,'01/01/2025')
SET @ClockStopCostCategory = TRY_CONVERT(date,'12/31/2025')

declare  @BaselineClockStartCostCategory as date = TRY_CONVERT(date,'01/01/2021')
declare  @BaselineClockStopCostCategory as date = TRY_CONVERT(date,'12/31/2021')



declare @mmstart as date = TRY_CONVERT(date,'01/01/2021')
declare @mmstop as date = TRY_CONVERT(date,'12/31/2025')


-----------------------------------------------------------------------------------------------------------------------------
	-- ECM ENROLLED (CONTINOUSLY) FROM JAN 1ST 2022 TO JUNE 2024 (JOINING THE #CONTINOUSENROLLMENT TABLE ABOVE)
-----------------------------------------------------------------------------------------------------------------------------
		/* SELECT TOP 1 ' ' AS '50 YEAR CALENDAR  ... CREATING A STATIC CONTINUOUS ENROLLMENT SOURCE...'
		,'USE CASE SEE ECM / CS QUARTERLY TAB 1 LOGIC' AS [NOTE(S)]
		,MIN(calendar_date) AS MINdt
		,MAX(calendar_date) AS MAXdt
		,bp.LINE_OF_BUSINESS
		,'BETWEEN '+CAST(CAST(@CEClockStart AS date) AS varchar (25))+' AND '+CAST(CAST(@CEClockStop AS date) AS varchar (25)) AS [RANGE NOTE(s)]
		,dc.calendar_day AS 'ELIGIBILTY DETERMINATION DAY'
		FROM INFORMATICS.dbo.[uvw_LINE_OF_BUSINESS] AS bp,INFORMATICS.[dbo].date_calendarISO AS dc -- DO NOT NO NEGATIVE <> != COVER UP THE TE() ... 50 YEAR CALENDAR
		WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ... AND ...
		GROUP BY bp.LINE_OF_BUSINESS,dc.calendar_day */


-----------------------------------------------------------------------------------------------------------------------------
	-- Error Trapping: Check If Permanent Table(s) Already Exist(s) And Drop If Applicable --
-----------------------------------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS #RANKLAG -- SQL Server 2016 and later -- DYNAMIC tmp OR STATIC [TABLE] #TableName is a local temporary table visible only IN the current session; ##TableName is a GLOBAL temporary table visible to all sessions IN ('TempDB')

SELECT DISTINCT DENSE_RANK() OVER(PARTITION BY ma.memid ORDER BY dc.calendar_date ASC) AS [RANKis]
,ROW_NUMBER() OVER(PARTITION BY ma.memid ORDER BY dc.calendar_date ASC) AS [ROWis]
,TRY_CONVERT(date,first_day_in_month) AS [EligibilityStart]
,TRY_CONVERT(date,last_day_in_month) AS [EligibilityEnd]
,dc.calendar_date
,first_day_in_month
,last_day_in_month
-- ,SUBSTRING(LTRIM(RTRIM(ISNULL(ek.carriermemid,''))),1,10) AS [Health Plan ID]
,SUBSTRING(UPPER(LTRIM(RTRIM(ISNULL(mem.secondaryid,'')))),1,9) AS [CIN]
,ma.memid
,mem.fullname
,ma.effdate,ma.termdate
,CAST(SUBSTRING(CAST(CAST(DATEDIFF("dd",TRY_CONVERT(date,mem.dob),TRY_CONVERT(date,@ClockStopECM))/365.25 AS money) AS nvarchar(25)),1,CHARINDEX('.',CAST(DATEDIFF("dd",TRY_CONVERT(date,mem.dob),TRY_CONVERT(date,@ClockStopECM))/365.25 AS money),1)-1) AS int) AS [AGE]
,CAST(NULL AS nvarchar(100)) AS [AGECx]
,TRY_CONVERT(date,mem.DOB) AS [DOB]
--,bp.LINE_OF_BUSINESS AS [LOB]
--,bp.PROGRAM
,DATEDIFF("d",TRY_CONVERT(date,dc.first_day_in_month),TRY_CONVERT(date,dc.last_day_in_month))+1 AS DaysEnrolled -- FUTURE 1 to include START DATE ELSE SEE 'STEP03b_DaysLogic_20140423.sql' CASE statement SYNTAX 
,CAST(1 AS int) AS MonthsEnrolled --LIKE '%,CAST(1 AS int) AS MMcount%'
 INTO #RANKLAG
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'

FROM INFORMATICS.dbo.date_calendarISO AS dc,HMOPROD_PLANDATA.dbo.memberattribute AS ma -- DO NOT NO NEGATIVE <> != COVER UP THE TE() ... 50 YEAR CALENDAR
-- FROM INFORMATICS.dbo.date_calendarCE AS dc,HMOPROD_PLANDATA.dbo.enrollkeys AS ek -- DO NOT NO NEGATIVE <> != COVER UP THE TE() ... 40 YEAR CALENDAR 1st OF THE MONTH ONLY!!!
	JOIN HMOPROD_PlanData.dbo.qattribute AS qa ON qa.attributeid = ma.attributeid
	-- JOIN HMOPROD_PlanData.dbo.enrollkeys AS ek ON ma.memid = ek.memid
	JOIN HMOPROD_PLANDATA.dbo.member AS mem ON ma.memid = mem.memid
WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ... AND ...
	AND TRY_CONVERT(date,ISNULL(ma.termdate,@ClockStopECM)) > TRY_CONVERT(date,ma.effdate) -- MUST BE TRUE ... NON-CROSSFOOTED RECORDS ARE ACTIVE ...
	AND dc.calendar_date BETWEEN @ClockStartECM AND @ClockStopECM -- SET REPORTING PERIOD LOCK AND ...
	-- AND dc.calendar_day = @isoday -- CALENDAR DAY ISO ... / EFFECTIVE AS OF WHICH DAY IN GIVEN MONTH?
	AND dc.calendar_date = dc.last_day_in_month --dc.calendar_day = @effday -- EFFECTIVE AS OF WHICH DAY IN GIVEN MONTH?
	AND TRY_CONVERT(date,ma.effdate) <= TRY_CONVERT(date,dc.calendar_date) -- WITHIN reporting period [RANGE] OPPOSITION 
	AND TRY_CONVERT(date,ISNULL(ma.termdate,@ClockStopECM)) >= TRY_CONVERT(date,dc.calendar_date) -- WITHIN reporting period 	
	AND qa.description = 'ECM Enrolled'

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
WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ... AND ...

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

-- ==========================================================
	-- ISOLATE POPULATION BASED ON [GAP IN...] COVERAGE --
-- ==========================================================
UPDATE #TotalDaysEnrolled --DETERMINE PRESENCE OF GAP(s) IN COVERAGE FOR SPECIFIED [RANGE]
SET [GAP(s) of] = g.GAPS
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
--SELECT DISTINCT [GAP(s) of] --CHECK 1st
FROM #TotalDaysEnrolled AS t
	JOIN #GAP AS g ON t.memid = g.memid

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
SET [Index EligibilityID] = TRY_CONVERT(nvarchar(25),CIN)+'-'+TRY_CONVERT(nvarchar(10),TRY_CONVERT(date,EligibilityStart))
,[Index Eligibility Start Date] = TRY_CONVERT(date,EligibilityStart)
,[Index Eligibility End Date] = TRY_CONVERT(date,EligibilityEnd)
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM #ContinuousEnrollment
WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ... AND ...
	AND [Index Eligibility Start Date] IS NULL
	AND RANKis = 1

UPDATE #ContinuousEnrollment
SET [Index EligibilityID] = TRY_CONVERT(nvarchar(25),CIN)+'-'+TRY_CONVERT(nvarchar(10),TRY_CONVERT(date,EligibilityStart))
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
-- ===========================================
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
DROP TABLE IF EXISTS #ECMEnrolled_Initial -- SQL Server 2016 and later -- DYNAMIC tmp OR STATIC [TABLE] #TableName is a local temporary table visible only IN the current session; ##TableName is a GLOBAL temporary table visible to all sessions IN ('TempDB')
 
SELECT tde.[Total Day(s) Enrolled],tde.[Total Month(s) Enrolled],ce.*
INTO #ECMEnrolled_Initial
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM #ContinuousEnrollment AS ce
	JOIN #TotalDaysEnrolled AS tde ON ce.memid = tde.memid

DROP TABLE IF EXISTS #ecmbaseline

		SELECT DISTINCT ' ' AS '#BASELINE - SAMPLE / HIGH LEVEL SUMARY: ',memid,fullname
		,[CONSECUTIVE DAY(S)],[CONSECUTIVE MONTH(S)]
		,TRY_CONVERT(decimal(9,1),([Total Day(s) Enrolled]/365.25)) AS [Total Year(s) Enrolled]
		,CAST(TRY_CONVERT(int,([Total Day(s) Enrolled]/365.25)) AS nvarchar(255))+' YEAR(S) AND '+CAST(([Total Month(s) Enrolled])-(TRY_CONVERT(int,([Total Day(s) Enrolled]/365.25))*12) AS nvarchar(255))+ ' MONTH(S)' AS [Total Year(s) & How Many Months Enrolled]
		,min(EligibilityStart) as EligibilityStart
		,max(EligibilityEnd) as EligibilityEnd
		,[Total Month(s) Enrolled]
		,[Total Day(s) Enrolled] 
		INTO #ecmbaseline
		FROM #ECMEnrolled_Initial
		WHERE 1=1
			AND [CONSECUTIVE MONTH(S)] >= @ContinuousMonths
		GROUP by memid, fullname, [CONSECUTIVE DAY(S)], [CONSECUTIVE MONTH(S)],[Total Month(s) Enrolled], [Total Day(s) Enrolled]
		
		-- SELECT * FROM #ecmbaseline;

------------Adding provider, mem, and enrollement info-------

DROP TABLE IF EXISTS #ECMEnrolled_FINAL

SELECT 
 'ENR' AS 'INDICATOR'
 ,EE.memid
 ,E.Member_Last_Name + ' ' + E.Member_First_Name as fullname
 ,'1' as ECMEnrolled
 ,E.ECM_Provider_ID AS ECM_Provider_ID
 ,E.ECM_Provider_Name AS ECM_Provider_Name
 ,MIN(EE.EligibilityStart) AS [EffDate]
 ,MAX(TRY_CONVERT(date,ISNULL(EE.EligibilityEnd,'12/31/2078'))) AS [TermDate]
INTO #ECMEnrolled_FINAL
FROM #ecmbaseline AS EE
--JOIN #CONTINOUSENROLLMENT_FINAL AS CE ON EE.memid = CE.memid
JOIN INFORMATICS.dbo.ECM_All AS E ON EE.memid = E.MemID  --- reduces the number of providers unless I use left join which brings nulls for some members----
--JOIN HMOPROD_PlanData.dbo.enrollkeys AS EK ON EE.memid = ek.memid
--     AND ek.segtype = 'INT'
--	 AND convert(date,getdate()) between ek.effdate and ek.termdate
GROUP BY EE.memid,E.Member_First_Name,E.Member_Last_Name,E.ECM_Provider_ID,E.ECM_Provider_Name
ORDER BY EE.memid;

		-- Select Distinct
		-- memid
		-- from #ECMEnrolled_FINAL;

    
-----------------------------------------------------------------------------------------------------------------------------
	-- Error Trapping: Check If Permanent Table(s) Already Exist(s) And Drop If Applicable --
-----------------------------------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS #RANKLAG_v2 -- SQL Server 2016 and later -- DYNAMIC tmp OR STATIC [TABLE] #TableName is a local temporary table visible only IN the current session; ##TableName is a GLOBAL temporary table visible to all sessions IN ('TempDB')

SELECT DISTINCT DENSE_RANK() OVER(PARTITION BY ek.memid ORDER BY dc.calendar_date ASC) AS [RANKis]
,ROW_NUMBER() OVER(PARTITION BY ek.memid ORDER BY dc.calendar_date ASC) AS [ROWis]
,TRY_CONVERT(date,dc.first_day_in_month) AS [EligibilityStart]
,TRY_CONVERT(date,dc.last_day_in_month) AS [EligibilityEnd]
,dc.calendar_date
,dc.first_day_in_month
,dc.last_day_in_month
,SUBSTRING(LTRIM(RTRIM(ISNULL(ek.carriermemid,''))),1,10) AS [Health Plan ID]
,SUBSTRING(UPPER(LTRIM(RTRIM(ISNULL(mem.secondaryid,'')))),1,9) AS [CIN]
,ek.memid,mem.fullname
,ek.effdate
,ek.termdate
,CAST(SUBSTRING(CAST(CAST(DATEDIFF("dd",TRY_CONVERT(date,mem.dob),TRY_CONVERT(date,@CEClockStop))/365.25 AS money) AS nvarchar(25)),1,CHARINDEX('.',CAST(DATEDIFF("dd",TRY_CONVERT(date,mem.dob),TRY_CONVERT(date,@CEClockStop))/365.25 AS money),1)-1) AS int) AS [AGE]
,CAST(NULL AS nvarchar(100)) AS [AGECx]
,TRY_CONVERT(date,mem.DOB) AS [DOB]
,bp.LINE_OF_BUSINESS AS [LOB]
,bp.PROGRAM
,DATEDIFF("d",TRY_CONVERT(date,dc.first_day_in_month),TRY_CONVERT(date,dc.last_day_in_month))+1 AS DaysEnrolled -- FUTURE 1 to include START DATE ELSE SEE 'STEP03b_DaysLogic_20140423.sql' CASE statement SYNTAX 
,CAST(1 AS int) AS MonthsEnrolled --LIKE '%,CAST(1 AS int) AS MMcount%'
 INTO #RANKLAG_v2
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM INFORMATICS.dbo.date_calendarISO AS dc,HMOPROD_PLANDATA.dbo.enrollkeys AS ek -- DO NOT NO NEGATIVE <> != COVER UP THE TE() ... 50 YEAR CALENDAR
	JOIN HMOPROD_PLANDATA.dbo.member AS mem ON ek.memid = mem.memid
	JOIN INFORMATICS.dbo.[uvw_LINE_OF_BUSINESS] AS bp ON ek.planid = bp.planid
	JOIN #ECMEnrolled_FINAL AS ECMFINAL ON ek.memid = ECMFINAL.memid
WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ... AND ...
	AND TRY_CONVERT(date,ek.termdate) > TRY_CONVERT(date,ek.effdate) -- MUST BE TRUE ... NON-CROSSFOOTED RECORDS ARE ACTIVE ...
	AND dc.calendar_date BETWEEN @CEClockStart AND @CEClockStop -- SET REPORTING PERIOD LOCK AND ...
	AND dc.calendar_day = @isoday -- CALENDAR DAY ISO ... / EFFECTIVE AS OF WHICH DAY IN GIVEN MONTH?	

	AND TRY_CONVERT(date,ek.effdate) <= TRY_CONVERT(date,dc.calendar_date) -- WITHIN reporting period [RANGE] OPPOSITION 
	AND TRY_CONVERT(date,ISNULL(ek.termdate,GETDATE())) >= TRY_CONVERT(date,dc.calendar_date) -- WITHIN reporting period 
	
	AND UPPER(LTRIM(RTRIM(ISNULL(ek.segtype,'')))) ='INT'
	AND ISNULL(mem.IsSubscriber,'') = 'Y' -- ISO ON SUBSCRIBER ONLY!!!

	-- ADD indexes to improve query performance
CREATE INDEX idx_REFACTOR_DupID ON #RANKLAG_v2 (memid,EligibilityStart);

-----------------------------------------------------------------------------------------------------------------------------
	-- Error Trapping: Check If Permanent Table(s) Already Exist(s) And Drop If Applicable --
-----------------------------------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS #ContinuousEnrollment_v2 -- SQL Server 2016 and later -- DYNAMIC tmp OR STATIC [TABLE] #TableName is a local temporary table visible only IN the current session; ##TableName is a GLOBAL temporary table visible to all sessions IN ('TempDB')

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
INTO #ContinuousEnrollment_v2
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM #RANKLAG_v2
WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ... AND ...

	-- tmp / CTE CLEAN - UP: -- 
DROP TABLE IF EXISTS #RANKLAG_v2

-- ================================================
	-- EXECUTE DLOOKUP equivalent(s)--
-- ================================================
UPDATE #ContinuousEnrollment_v2
SET [PREVIOUS EligibilityEnd] = effdate
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM #ContinuousEnrollment_v2
WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ...
	AND RANKis != 1
	AND [PREVIOUS EligibilityEnd] IS NULL

UPDATE #ContinuousEnrollment_v2 --QUPD GAP IN DAY(s)
SET GAPinDAYs = 0
,GAPinMONTHs = 0
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM #ContinuousEnrollment_v2
WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ...
	AND RANKis = 1

UPDATE #ContinuousEnrollment_v2 --QUPD GAP IN DAY(s)
SET GAPinDAYs = CAST(DATEDIFF("d",CASE
WHEN TRY_CONVERT(datetime,[PREVIOUS EligibilityEnd]) = '2078-12-31 00:00:00.000'
THEN CAST(GETDATE() AS date)
ELSE TRY_CONVERT(datetime,[PREVIOUS EligibilityEnd])
END,TRY_CONVERT(datetime,EligibilityStart)-1) AS int)
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM #ContinuousEnrollment_v2
WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ...
	AND GAPinDAYs IS NULL

UPDATE #ContinuousEnrollment_v2 --QUPD GAP IN MONTH(s)
SET GAPinMONTHs = CAST(DATEDIFF("m",CASE
WHEN CAST([PREVIOUS EligibilityEnd] AS datetime) = TRY_CONVERT(datetime,'2078-12-31 00:00:00.000')
THEN CAST(GETDATE() AS datetime)
ELSE CAST([PREVIOUS EligibilityEnd] AS datetime)+1
END,CAST([EligibilityStart] AS datetime)) AS int)
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM #ContinuousEnrollment_v2
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
DROP TABLE IF EXISTS #TotalDaysEnrolled_v2 -- SQL Server 2016 and later -- DYNAMIC tmp OR STATIC [TABLE] #TableName is a local temporary table visible only IN the current session; ##TableName is a GLOBAL temporary table visible to all sessions IN ('TempDB')

SELECT memid
,SUM(DaysEnrolled) AS [Total Day(s) Enrolled] 
,SUM(MonthsEnrolled) AS [Total Month(s) Enrolled] 
,CAST(NULL AS int) AS [GAP(s) of]
--,MIN(effdate) as effdate
--,MAX(termdate) as termdate
INTO #TotalDaysEnrolled_v2
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM #ContinuousEnrollment_v2
GROUP BY memid

--select *
--from #TotalDaysEnrolled

-----------------------------------------------------------------------------------------------------------------------------
	-- Error Trapping: Check If Permanent Table(s) Already Exist(s) And Drop If Applicable --
-----------------------------------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS #GAP_v2 -- SQL Server 2016 and later -- DYNAMIC tmp OR STATIC [TABLE] #TableName is a local temporary table visible only IN the current session; ##TableName is a GLOBAL temporary table visible to all sessions IN ('TempDB')
 
SELECT memid
,COUNT(1) AS GAPS
INTO #GAP_v2
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM #ContinuousEnrollment_v2
WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ...
	-- AND GAPinDAYs>= @GAPOF --IN DAY(s)
	AND ISNULL(GAPinMONTHs,0) >= @GAPOF --IN MONTH(s)
GROUP BY memid

-- ===========================================
	-- INITIATE INDEX() / CONSECUTIVE() UPDATE(S) --
-- ===========================================
UPDATE #ContinuousEnrollment_v2
SET [CONSECUTIVE] = 0 -- RESET RESTART REFRESH
,[Index EligibilityID] = CAST(NULL AS nvarchar(255))
,[Index Eligibility Start Date] = CAST(NULL AS date)
,[Index Eligibility End Date] = CAST(NULL AS date)

UPDATE #ContinuousEnrollment_v2
SET [CONSECUTIVE] = 1
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM #ContinuousEnrollment_v2
WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ... AND ...
	AND [CONSECUTIVE] = 0
	AND GAPinMONTHs = 0
	AND RANKis != 1

UPDATE #ContinuousEnrollment_v2
SET [Index EligibilityID] = TRY_CONVERT(nvarchar(25),[Health Plan ID])+'-'+TRY_CONVERT(nvarchar(10),TRY_CONVERT(date,EligibilityStart))
,[Index Eligibility Start Date] = TRY_CONVERT(date,EligibilityStart)
,[Index Eligibility End Date] = TRY_CONVERT(date,EligibilityEnd)
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM #ContinuousEnrollment_v2
WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ... AND ...
	AND [Index Eligibility Start Date] IS NULL
	AND RANKis = 1

UPDATE #ContinuousEnrollment_v2
SET [Index EligibilityID] = TRY_CONVERT(nvarchar(25),[Health Plan ID])+'-'+TRY_CONVERT(nvarchar(10),TRY_CONVERT(date,EligibilityStart))
,[Index Eligibility Start Date] = TRY_CONVERT(date,EligibilityStart)
,[Index Eligibility End Date] = TRY_CONVERT(date,EligibilityEnd)
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM #ContinuousEnrollment_v2
WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ... AND ...
	AND [Index Eligibility Start Date] IS NULL
	AND CONSECUTIVE = 0

		-- SELECT * FROM #ContinuousEnrollment

-- ======================================================================
	-- SQL #PYTHON FOR WHILE LOOP() BREAK / FEEDBACK LOOP() CONDITION(S) -- 
-- ======================================================================
DECLARE @rowCount_v2 int;
WHILE (1=1)
BEGIN

		UPDATE #ContinuousEnrollment_v2
		SET [Index EligibilityID] = loopce.[Index EligibilityID]
		,[Index Eligibility Start Date] = loopce.[Index Eligibility Start Date]
		,[Index Eligibility End Date] = TRY_CONVERT(date,ce.EligibilityEnd)
		-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
		-- SELECT DISTINCT ' ' AS 'CHECK 1st'
		FROM #ContinuousEnrollment_v2 AS ce
			JOIN 
			( -- INITIATE ...
			SELECT DISTINCT memid
			,EligibilityStart
			,EligibilityEnd
			,[Index EligibilityID]
			,[Index Eligibility Start Date]
			,[Index Eligibility End Date]
			FROM #ContinuousEnrollment_v2
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

SET @rowCount_v2 = @@ROWCOUNT;
IF (@rowCount_v2 = 0)
BREAK;
END
-- =============================================
	-- CONCLUDE INDEX() / CONSECUTIVE() UPDATE(S) --
-- =============================================
UPDATE #ContinuousEnrollment_v2
SET [Index Eligibility End Date] = finish.[Index Eligibility End Date]
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM #ContinuousEnrollment_v2 AS ce
	JOIN 
	( -- INITIATE ...
	SELECT [Index EligibilityID],MAX([Index Eligibility End Date]) AS [Index Eligibility End Date]
	FROM #ContinuousEnrollment_v2
	WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ... AND 
		AND [Index EligibilityID] IS NOT NULL
	GROUP BY [Index EligibilityID]
	) -- CONCLUDE ...
	AS finish ON ce.[Index EligibilityID] = finish.[Index EligibilityID]

UPDATE #ContinuousEnrollment_v2
SET [CONSECUTIVE DAY(S)] = finish.[CONSECUTIVE DAY(S)]
,[CONSECUTIVE MONTH(S)] = finish.[CONSECUTIVE MONTH(S)]
FROM #ContinuousEnrollment_v2 AS ce
	JOIN 
	( -- INITIATE ...
	SELECT [Index EligibilityID]
	,DATEDIFF("m",TRY_CONVERT(date,[Index Eligibility Start Date]),TRY_CONVERT(date,[Index Eligibility End Date]))+1 AS [CONSECUTIVE MONTH(S)]
	,DATEDIFF("d",TRY_CONVERT(date,[Index Eligibility Start Date]),TRY_CONVERT(date,[Index Eligibility End Date]))+1 AS [CONSECUTIVE DAY(S)]
	FROM #ContinuousEnrollment_v2 
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
DROP TABLE IF EXISTS #EligiblePopulation_v2 -- SQL Server 2016 and later -- DYNAMIC tmp OR STATIC [TABLE] #TableName is a local temporary table visible only IN the current session; ##TableName is a GLOBAL temporary table visible to all sessions IN ('TempDB')
 
SELECT tde.[Total Day(s) Enrolled],tde.[Total Month(s) Enrolled],ce.*
INTO #EligiblePopulation_v2
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM #ContinuousEnrollment_v2 AS ce
	JOIN #TotalDaysEnrolled_v2 AS tde ON ce.memid = tde.memid

	-----------------------------------------------------------------------------------------------------------------------------

DROP TABLE IF EXISTS #BASELINE_CONTINOUSENROLLMENT_FINAL -- SQL Server 2016 and later -- DYNAMIC tmp OR STATIC [TABLE] #TableName is a local temporary table visible only IN the current session; ##TableName is a GLOBAL temporary table visible to all sessions IN ('TempDB')

		SELECT DISTINCT ' ' AS '#BASELINE - SAMPLE / HIGH LEVEL SUMARY: '
		,memid as MemID
		,'' as ECM_Provider_ID
		,'' as ECM_Provider_Name
		--,effdate
		--,termdate
		--,[LOB]
		,[Health Plan ID]
		,fullname
		,[CONSECUTIVE DAY(S)],[CONSECUTIVE MONTH(S)]
		,TRY_CONVERT(decimal(9,1),([Total Day(s) Enrolled]/365.25)) AS [Total Year(s) Enrolled]
		,CAST(TRY_CONVERT(int,([Total Day(s) Enrolled]/365.25)) AS nvarchar(255))+' YEAR(S) AND '+CAST(([Total Month(s) Enrolled])-(TRY_CONVERT(int,([Total Day(s) Enrolled]/365.25))*12) AS nvarchar(255))+ ' MONTH(S)' AS [Total Year(s) & How Many Months Enrolled]
		,[Total Month(s) Enrolled]
		,[Total Day(s) Enrolled] 
		INTO #BASELINE_CONTINOUSENROLLMENT_FINAL
		FROM #EligiblePopulation_v2		
		WHERE [Total Month(s) Enrolled] = 12;
		----- ... Continuous enrollment is defined as no more than one gap IN enrollment of up to 45 days during the reporting period (i.e., January through December). To determine continuous enrollment for a member for whom enrollment is verified monthly, the member may not have more than a 1-month gap IN coverage (i.e., a member whose coverage lapses for 2 months [60 days] is not considered continuously enrolled) ...
		
		------------------------------------------------------------------------------------------------------------------------------------
		----------------------------------------------Continously Enrolled for Comparison Year----------------------------------------------
		------------------------------------------------------------------------------------------------------------------------------------

DROP TABLE IF EXISTS #RANKLAG_d2 -- SQL Server 2016 and later -- DYNAMIC tmp OR STATIC [TABLE] #TableName is a local temporary table visible only IN the current session; ##TableName is a GLOBAL temporary table visible to all sessions IN ('TempDB')

SELECT DISTINCT DENSE_RANK() OVER(PARTITION BY ek.memid ORDER BY dc.calendar_date ASC) AS [RANKis]
,ROW_NUMBER() OVER(PARTITION BY ek.memid ORDER BY dc.calendar_date ASC) AS [ROWis]
,TRY_CONVERT(date,dc.first_day_in_month) AS [EligibilityStart]
,TRY_CONVERT(date,dc.last_day_in_month) AS [EligibilityEnd]
,dc.calendar_date
,dc.first_day_in_month
,dc.last_day_in_month
,SUBSTRING(LTRIM(RTRIM(ISNULL(ek.carriermemid,''))),1,10) AS [Health Plan ID]
,SUBSTRING(UPPER(LTRIM(RTRIM(ISNULL(mem.secondaryid,'')))),1,9) AS [CIN]
,ek.memid,mem.fullname
,ek.effdate
,ek.termdate
,CAST(SUBSTRING(CAST(CAST(DATEDIFF("dd",TRY_CONVERT(date,mem.dob),TRY_CONVERT(date,@ComparisonCEClockStop))/365.25 AS money) AS nvarchar(25)),1,CHARINDEX('.',CAST(DATEDIFF("dd",TRY_CONVERT(date,mem.dob),TRY_CONVERT(date,@CEClockStop))/365.25 AS money),1)-1) AS int) AS [AGE]
,CAST(NULL AS nvarchar(100)) AS [AGECx]
,TRY_CONVERT(date,mem.DOB) AS [DOB]
,bp.LINE_OF_BUSINESS AS [LOB]
,bp.PROGRAM
,DATEDIFF("d",TRY_CONVERT(date,dc.first_day_in_month),TRY_CONVERT(date,dc.last_day_in_month))+1 AS DaysEnrolled -- FUTURE 1 to include START DATE ELSE SEE 'STEP03b_DaysLogic_20140423.sql' CASE statement SYNTAX 
,CAST(1 AS int) AS MonthsEnrolled --LIKE '%,CAST(1 AS int) AS MMcount%'
 INTO #RANKLAG_d2
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM INFORMATICS.dbo.date_calendarISO AS dc,HMOPROD_PLANDATA.dbo.enrollkeys AS ek -- DO NOT NO NEGATIVE <> != COVER UP THE TE() ... 50 YEAR CALENDAR
	JOIN HMOPROD_PLANDATA.dbo.member AS mem ON ek.memid = mem.memid
	JOIN INFORMATICS.dbo.[uvw_LINE_OF_BUSINESS] AS bp ON ek.planid = bp.planid
	JOIN #ECMEnrolled_FINAL AS ECMFINAL ON ek.memid = ECMFINAL.memid
WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ... AND ...
	AND TRY_CONVERT(date,ek.termdate) > TRY_CONVERT(date,ek.effdate) -- MUST BE TRUE ... NON-CROSSFOOTED RECORDS ARE ACTIVE ...
	AND dc.calendar_date BETWEEN @ComparisonCEClockStart AND @ComparisonCEClockStop -- SET REPORTING PERIOD LOCK AND ...
	AND dc.calendar_day = @isoday -- CALENDAR DAY ISO ... / EFFECTIVE AS OF WHICH DAY IN GIVEN MONTH?	

	AND TRY_CONVERT(date,ek.effdate) <= TRY_CONVERT(date,dc.calendar_date) -- WITHIN reporting period [RANGE] OPPOSITION 
	AND TRY_CONVERT(date,ISNULL(ek.termdate,GETDATE())) >= TRY_CONVERT(date,dc.calendar_date) -- WITHIN reporting period 
	
	AND UPPER(LTRIM(RTRIM(ISNULL(ek.segtype,'')))) ='INT'
	AND ISNULL(mem.IsSubscriber,'') = 'Y' -- ISO ON SUBSCRIBER ONLY!!!

	-- ADD indexes to improve query performance
CREATE INDEX idx_REFACTOR_DupID ON #RANKLAG_d2 (memid,EligibilityStart);

-----------------------------------------------------------------------------------------------------------------------------
	-- Error Trapping: Check If Permanent Table(s) Already Exist(s) And Drop If Applicable --
-----------------------------------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS #ContinuousEnrollment_d2 -- SQL Server 2016 and later -- DYNAMIC tmp OR STATIC [TABLE] #TableName is a local temporary table visible only IN the current session; ##TableName is a GLOBAL temporary table visible to all sessions IN ('TempDB')

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
INTO #ContinuousEnrollment_d2
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM #RANKLAG_d2
WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ... AND ...

	-- tmp / CTE CLEAN - UP: -- 
DROP TABLE IF EXISTS #RANKLAG_d2

-- ================================================
	-- EXECUTE DLOOKUP equivalent(s)--
-- ================================================
UPDATE #ContinuousEnrollment_d2
SET [PREVIOUS EligibilityEnd] = effdate
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM #ContinuousEnrollment_d2
WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ...
	AND RANKis != 1
	AND [PREVIOUS EligibilityEnd] IS NULL

UPDATE #ContinuousEnrollment_d2 --QUPD GAP IN DAY(s)
SET GAPinDAYs = 0
,GAPinMONTHs = 0
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM #ContinuousEnrollment_d2
WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ...
	AND RANKis = 1

UPDATE #ContinuousEnrollment_d2 --QUPD GAP IN DAY(s)
SET GAPinDAYs = CAST(DATEDIFF("d",CASE
WHEN TRY_CONVERT(datetime,[PREVIOUS EligibilityEnd]) = '2078-12-31 00:00:00.000'
THEN CAST(GETDATE() AS date)
ELSE TRY_CONVERT(datetime,[PREVIOUS EligibilityEnd])
END,TRY_CONVERT(datetime,EligibilityStart)-1) AS int)
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM #ContinuousEnrollment_d2
WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ...
	AND GAPinDAYs IS NULL

UPDATE #ContinuousEnrollment_d2 --QUPD GAP IN MONTH(s)
SET GAPinMONTHs = CAST(DATEDIFF("m",CASE
WHEN CAST([PREVIOUS EligibilityEnd] AS datetime) = TRY_CONVERT(datetime,'2078-12-31 00:00:00.000')
THEN CAST(GETDATE() AS datetime)
ELSE CAST([PREVIOUS EligibilityEnd] AS datetime)+1
END,CAST([EligibilityStart] AS datetime)) AS int)
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM #ContinuousEnrollment_d2
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
DROP TABLE IF EXISTS #TotalDaysEnrolled_d2 -- SQL Server 2016 and later -- DYNAMIC tmp OR STATIC [TABLE] #TableName is a local temporary table visible only IN the current session; ##TableName is a GLOBAL temporary table visible to all sessions IN ('TempDB')

SELECT memid
,SUM(DaysEnrolled) AS [Total Day(s) Enrolled] 
,SUM(MonthsEnrolled) AS [Total Month(s) Enrolled] 
,CAST(NULL AS int) AS [GAP(s) of]
--,MIN(effdate) as effdate
--,MAX(termdate) as termdate
INTO #TotalDaysEnrolled_d2
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM #ContinuousEnrollment_d2
GROUP BY memid

--select *
--from #TotalDaysEnrolled

-----------------------------------------------------------------------------------------------------------------------------
	-- Error Trapping: Check If Permanent Table(s) Already Exist(s) And Drop If Applicable --
-----------------------------------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS #GAP_d2 -- SQL Server 2016 and later -- DYNAMIC tmp OR STATIC [TABLE] #TableName is a local temporary table visible only IN the current session; ##TableName is a GLOBAL temporary table visible to all sessions IN ('TempDB')
 
SELECT memid
,COUNT(1) AS GAPS
INTO #GAP_d2
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM #ContinuousEnrollment_d2
WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ...
	-- AND GAPinDAYs>= @GAPOF --IN DAY(s)
	AND ISNULL(GAPinMONTHs,0) >= @GAPOF --IN MONTH(s)
GROUP BY memid

-- ===========================================
	-- INITIATE INDEX() / CONSECUTIVE() UPDATE(S) --
-- ===========================================
UPDATE #ContinuousEnrollment_d2
SET [CONSECUTIVE] = 0 -- RESET RESTART REFRESH
,[Index EligibilityID] = CAST(NULL AS nvarchar(255))
,[Index Eligibility Start Date] = CAST(NULL AS date)
,[Index Eligibility End Date] = CAST(NULL AS date)

UPDATE #ContinuousEnrollment_d2
SET [CONSECUTIVE] = 1
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM #ContinuousEnrollment_d2
WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ... AND ...
	AND [CONSECUTIVE] = 0
	AND GAPinMONTHs = 0
	AND RANKis != 1

UPDATE #ContinuousEnrollment_d2
SET [Index EligibilityID] = TRY_CONVERT(nvarchar(25),[Health Plan ID])+'-'+TRY_CONVERT(nvarchar(10),TRY_CONVERT(date,EligibilityStart))
,[Index Eligibility Start Date] = TRY_CONVERT(date,EligibilityStart)
,[Index Eligibility End Date] = TRY_CONVERT(date,EligibilityEnd)
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM #ContinuousEnrollment_d2
WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ... AND ...
	AND [Index Eligibility Start Date] IS NULL
	AND RANKis = 1

UPDATE #ContinuousEnrollment_d2
SET [Index EligibilityID] = TRY_CONVERT(nvarchar(25),[Health Plan ID])+'-'+TRY_CONVERT(nvarchar(10),TRY_CONVERT(date,EligibilityStart))
,[Index Eligibility Start Date] = TRY_CONVERT(date,EligibilityStart)
,[Index Eligibility End Date] = TRY_CONVERT(date,EligibilityEnd)
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM #ContinuousEnrollment_d2
WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ... AND ...
	AND [Index Eligibility Start Date] IS NULL
	AND CONSECUTIVE = 0

		-- SELECT * FROM #ContinuousEnrollment

-- ======================================================================
	-- SQL #PYTHON FOR WHILE LOOP() BREAK / FEEDBACK LOOP() CONDITION(S) -- 
-- ======================================================================
DECLARE @rowCount_d2 int;
WHILE (1=1)
BEGIN

		UPDATE #ContinuousEnrollment_d2
		SET [Index EligibilityID] = loopce.[Index EligibilityID]
		,[Index Eligibility Start Date] = loopce.[Index Eligibility Start Date]
		,[Index Eligibility End Date] = TRY_CONVERT(date,ce.EligibilityEnd)
		-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
		-- SELECT DISTINCT ' ' AS 'CHECK 1st'
		FROM #ContinuousEnrollment_d2 AS ce
			JOIN 
			( -- INITIATE ...
			SELECT DISTINCT memid
			,EligibilityStart
			,EligibilityEnd
			,[Index EligibilityID]
			,[Index Eligibility Start Date]
			,[Index Eligibility End Date]
			FROM #ContinuousEnrollment_d2
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

SET @rowCount_d2 = @@ROWCOUNT;
IF (@rowCount_d2 = 0)
BREAK;
END
-- =============================================
	-- CONCLUDE INDEX() / CONSECUTIVE() UPDATE(S) --
-- =============================================
UPDATE #ContinuousEnrollment_d2
SET [Index Eligibility End Date] = finish.[Index Eligibility End Date]
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM #ContinuousEnrollment_d2 AS ce
	JOIN 
	( -- INITIATE ...
	SELECT [Index EligibilityID],MAX([Index Eligibility End Date]) AS [Index Eligibility End Date]
	FROM #ContinuousEnrollment_d2
	WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ... AND 
		AND [Index EligibilityID] IS NOT NULL
	GROUP BY [Index EligibilityID]
	) -- CONCLUDE ...
	AS finish ON ce.[Index EligibilityID] = finish.[Index EligibilityID]

UPDATE #ContinuousEnrollment_d2
SET [CONSECUTIVE DAY(S)] = finish.[CONSECUTIVE DAY(S)]
,[CONSECUTIVE MONTH(S)] = finish.[CONSECUTIVE MONTH(S)]
FROM #ContinuousEnrollment_d2 AS ce
	JOIN 
	( -- INITIATE ...
	SELECT [Index EligibilityID]
	,DATEDIFF("m",TRY_CONVERT(date,[Index Eligibility Start Date]),TRY_CONVERT(date,[Index Eligibility End Date]))+1 AS [CONSECUTIVE MONTH(S)]
	,DATEDIFF("d",TRY_CONVERT(date,[Index Eligibility Start Date]),TRY_CONVERT(date,[Index Eligibility End Date]))+1 AS [CONSECUTIVE DAY(S)]
	FROM #ContinuousEnrollment_d2 
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
DROP TABLE IF EXISTS #EligiblePopulation_d2 -- SQL Server 2016 and later -- DYNAMIC tmp OR STATIC [TABLE] #TableName is a local temporary table visible only IN the current session; ##TableName is a GLOBAL temporary table visible to all sessions IN ('TempDB')
 
SELECT tde.[Total Day(s) Enrolled],tde.[Total Month(s) Enrolled],ce.*
INTO #EligiblePopulation_d2
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM #ContinuousEnrollment_d2 AS ce
	JOIN #TotalDaysEnrolled_d2 AS tde ON ce.memid = tde.memid

	-----------------------------------------------------------------------------------------------------------------------------

DROP TABLE IF EXISTS #CONTINOUSENROLLMENT_FINAL -- SQL Server 2016 and later -- DYNAMIC tmp OR STATIC [TABLE] #TableName is a local temporary table visible only IN the current session; ##TableName is a GLOBAL temporary table visible to all sessions IN ('TempDB')

		SELECT DISTINCT ' ' AS '#BASELINE - SAMPLE / HIGH LEVEL SUMARY: '
		,memid as MemID
		,'' as ECM_Provider_ID
		,'' as ECM_Provider_Name
		--,effdate
		--,termdate
		--,[LOB]
		,[Health Plan ID]
		,fullname
		,[CONSECUTIVE DAY(S)],[CONSECUTIVE MONTH(S)]
		,TRY_CONVERT(decimal(9,1),([Total Day(s) Enrolled]/365.25)) AS [Total Year(s) Enrolled]
		,CAST(TRY_CONVERT(int,([Total Day(s) Enrolled]/365.25)) AS nvarchar(255))+' YEAR(S) AND '+CAST(([Total Month(s) Enrolled])-(TRY_CONVERT(int,([Total Day(s) Enrolled]/365.25))*12) AS nvarchar(255))+ ' MONTH(S)' AS [Total Year(s) & How Many Months Enrolled]
		,[Total Month(s) Enrolled]
		,[Total Day(s) Enrolled] 
		INTO #COMPARISON_CONTINOUSENROLLMENT_FINAL
		FROM #EligiblePopulation_d2		
		WHERE [Total Month(s) Enrolled] = 12;
		----- ... Continuous enrollment is defined as no more than one gap IN enrollment of up to 45 days during the reporting period (i.e., January through December). To determine continuous enrollment for a member for whom enrollment is verified monthly, the member may not have more than a 1-month gap IN coverage (i.e., a member whose coverage lapses for 2 months [60 days] is not considered continuously enrolled) ...

------------------------------------------------end----------------------------------------------------------------------------

------------------------------MEMBER LIST FOR BASELINE PERIOD CONTINOUSLY ENROLLED AND ECM CONTINOUSLY ENROLLED POPULATION--------------------------------

--DROP TABLE IF EXISTS #BASELINE_CALAIM_Mem

--Select Distinct 
-- EF.MemID
--,EF.fullname
--,EF.ECMEnrolled
--,EF.ECM_Provider_ID
--,EF.ECM_Provider_Name
--,EF.EffDate
--,EF.TermDate
--INTO #BASELINE_CALAIM_Mem
--from #ECMEnrolled_FINAL as EF
--JOIN #BASELINE_CONTINOUSENROLLMENT_FINAL AS BCU ON EF.memid = BCU.MemID;

----select Distinct
---- MemID
----from #BASELINE_CALAIM_Mem

--------------------------------MEMBER LIST FOR COMPARISON PERIOD CONTINOUSLY ENROLLED AND ECM CONTINOUSLY ENROLLED POPULATION--------------------------------
		
--DROP TABLE IF EXISTS #COMPARISON_CALAIM_Mem

--Select Distinct 
-- EF.MemID
--,EF.fullname
--,EF.ECMEnrolled
--,EF.ECM_Provider_ID
--,EF.ECM_Provider_Name
--,EF.EffDate
--,EF.TermDate
--INTO #COMPARISON_CALAIM_Mem
--from #ECMEnrolled_FINAL as EF
--JOIN #COMPARISON_CONTINOUSENROLLMENT_FINAL as CCF ON EF.memid = CCF.MemID;

--Select Distinct
-- MemID
--From #COMPARISON_CALAIM_Mem

-----------------------FINAL MEMBER LIST (Matching Baseline and Comparison Members After ECM Enrolled Member Mapping Above)--------------------------------

DROP TABLE IF EXISTS #CALAIM_Mem

Select Distinct 
 --'ENR' as Indicator
BCM.MemID
--,BCM.fullname
--,BCM.ECMEnrolled
--,BCM.ECM_Provider_ID
--,BCM.ECM_Provider_Name
--,BCM.EffDate
--,BCM.TermDate
INTO #CALAIM_Mem
from #BASELINE_CONTINOUSENROLLMENT_FINAL AS BCM
JOIN #COMPARISON_CONTINOUSENROLLMENT_FINAL AS CCM ON BCM.MemID = CCM.MemID;

--Select Distinct
-- MemID
--From #CALAIM_Mem


--------------------------------------------------------------------------------------------------------------------
	-- Inpatient Members for the ECM Program --
--------------------------------------------------------------------------------------------------------------------


drop table if exists  #InptMemberComparison

;with inpthosp as (
		select distinct c.claimid
		from
		#CALAIM_Mem m
		join HMOPROD_PlanData.dbo.claim c on c.memid = m.memid
		join HMOPROD_PlanData.dbo.claimdetail cdet on c.claimid = cdet.claimid
		where
		c.facilitycode in ('1','2','8')
		and c.billclasscode in ('1','2')
		and c.formtype = 'UB04'
		and ( 
		c.startdate between @ClockStartCostCategory and @ClockStopCostCategory 
		or 
		c.startdate between @BaselineClockStartCostCategory and @BaselineClockStopCostCategory )
)
,inptclaims as (
		select distinct
		c.memid,
		m.fullname as member_name,
		m.dob,
		c.planid,
		case
		when c.planid = 'QMXBP0782' then 'MediCal'
		when c.planid in  ('QMXBP0823','QMXBP0822')then 'CMC'
		else null end line_of_business,
		c.claimid,
		c.admitdate as admitdate,
		c.startdate as startdate,
		c.enddate as enddate,
		c.cleandate,
		c.provid,
		p.fullname as provider,
		payto.provid as paytoid,
		payto.fullname as payto,
		case 
			when c.facilitycode = '1' and c.billclasscode in ('1','2') then '1-INPATIENT-HOSPITAL'
			when c.facilitycode = '2' then '2-INPATIENT-SNF'
			else '3-INPATIENT-OTHER'
		end cost_category,
		cdet.claimline,
		cdet.revcode,
		cdet.amountpaid as paid,
		cdet.servunits as units
		from
		inpthosp i
		join HMOPROD_PlanData.DBO.claim c on c.claimid = i.claimid
		join HMOPROD_PlanData.DBO. claimdetail cdet on cdet.claimid = c.claimid
		join HMOPROD_PlanData.DBO.provider p on p.provid = c.provid
		join HMOPROD_PlanData.DBO.member m on m.memid = c.memid
		left join HMOPROD_PlanData.DBO.affiliation a2 on a2.affiliationid = c.affiliationid 
		left join HMOPROD_PlanData.DBO.provider payto on payto.provid = a2.affiliateid
		where
		(c.resubclaimid is null or c.resubclaimid = '')
		and c.claimid not like '%R%'
		and c.status in ('ADJUCATED', 'PAID', 'PAY', 'REV', 'REVERSED', 'REVSYNCH')
		and cdet.status not in ('DENY', 'VOID')
		and c.planid in ('QMXBP0823','QMXBP0822','QMXBP0782')
		and cdet.servunits < 100000
)
,claiminitial as (
		select distinct
			c.memid,
			c.line_of_business,
			c.provid,
			c.provider,
			c.paytoid,
			c.payto,
			c.cost_category,
			c.startdate,
			c.enddate, 
			cal.calendardate
		from 
			inptclaims c
			join informatics.dbo.Calendar cal on cal.CalendarDate between c.startdate and c.enddate
																and cal.CalendarDate < = c.cleandate
	)
,ClaimDays as (
		select distinct
			c.memid,
			c.line_of_business,
			c.provid,
			c.provider,
			c.paytoid,
			c.payto,
			c.cost_category,
			c.CalendarDate,
			case
				when lag( c.CalendarDate, 1 ) over ( partition by c.memid, c.line_of_business, c.provid, c.cost_category order by c.CalendarDate ) is null then c.CalendarDate
				when datediff( dd, lag( c.CalendarDate, 1 ) over ( partition by c.memid, c.line_of_business, c.provid, c.cost_category order by c.CalendarDate), c.CalendarDate ) > 1 then c.CalendarDate
				else null 
			end startdate,
			case 
				when lead( c.CalendarDate, 1 ) over ( partition by c.memid, c.line_of_business, c.provid, c.cost_category  order by  c.CalendarDate ) is null then c.CalendarDate
				when datediff( dd, c.CalendarDate, lead( c.CalendarDate, 1 ) over ( partition by c.memid,c.line_of_business, c.provid, cost_category  order by  c.CalendarDate) ) > 1 then c.CalendarDate
				else null 
			end enddos,
			row_number() over ( partition by memid, line_of_business, provid order by c.provid, c.CalendarDate ) as ct
		from claiminitial c
	)
,StaysInitial as 	(
		select distinct
			memid,
			line_of_business,
			provid,
			provider,
			paytoid,
			payto,
			cost_category,
			startdate,
			case when enddos is not null then enddos else lead(enddos,1) over (partition by memid,line_of_business, provid order by ct) end enddate
		from ClaimDays
		where (startdate is not null
			or enddos is not null)
	)
,StaysFinal as (
		select distinct
			memid,
			line_of_business,
			provid,
			provider,
			paytoid,
			payto,
			cost_category,
			startdate,
			enddate,
			case when datediff(dd,startdate, enddate) = 0 then 1 else datediff(dd,startdate, enddate) end days
		from StaysInitial
		where startdate is not null 
			and enddate is not null
	)
, inptwpaid as (
	select
	sf.*,
	si.paid
	from
	staysfinal sf
	left join inptclaims si on sf.memid = si.memid 
									and sf.line_of_business = si.line_of_business 
									and sf.provid = si.provid 
									and si.startdate between sf.startdate and sf.enddate
)
, inptagg as(
		select 
		memid,
		line_of_business,
		provid,
		provider,
		paytoid,
		payto,
		cost_category,
		startdate,
		enddate,
		sum(paid) as paid,
		days
		from inptwpaid
		group by
		memid,
		line_of_business,
		provid,
		provider,
		paytoid,
		payto,
		cost_category,
		startdate,
		enddate,
		days
)
, inpt_days as (
		select distinct
		ia.*,
		case 
			when  month(c.calendardate) = month(ia.startdate) and year(c.calendardate) = year(ia.startdate) then startdate 
			else  dateadd(dd,1,eomonth(c.calendardate,-1)) 
			end startfordays,
		case 
			when eomonth(c.calendardate) < ia.enddate then eomonth(c.calendardate) 
			else ia.enddate 
			end endfordays
		from
		inptagg ia
		left join informatics.dbo.calendar c on c.calendardate between ia.startdate and ia.enddate 
		
		)
, daysfinal as(
	select
	*,
	dateadd(dd,1,eomonth(startfordays,-1)) as dos_month,
	count(startfordays) over (partition by memid, line_of_business, provid, startdate) as ct,
	case
		when startfordays = endfordays and count(startfordays) over (partition by memid, line_of_business, provid, startdate)  = 1 then 1
		when startfordays = endfordays and row_number() over (partition by memid, line_of_business, provid, startdate order by startfordays asc) = 1  then 1
		when startfordays = endfordays and row_number() over (partition by memid, line_of_business, provid, startdate order by startfordays) <> 1  then 0
		when row_number() over (partition by memid, line_of_business, provid, startdate order by endfordays desc) = 1 then datediff(dd, startfordays, endfordays)
		else datediff(dd, startfordays, endfordays)+1 end days2
	from
	inpt_days
	)
	select
	d.*,
	convert(money,days2)/convert(money,days) as paidweight,
	paid * convert(money,days2)/convert(money,days) as paidfinal,
	case when row_number() over (partition by d.memid, line_of_business, provid, startdate, cost_category order by startfordays) = 1 then 1 else 0 end admits
	into #InptMemberComparison
	from
	daysfinal d


--------------------------------------------------------------------------------------------------------------------
	-- Outpatient Members for the ECM Program --
--------------------------------------------------------------------------------------------------------------------

--DECLARE @ClockStartECM AS datetime
--DECLARE @ClockStopECM AS datetime

--SET @ClockStartECM = '01/01/2022'
--SET @ClockStopECM = '06/30/2024'

-------------------------------------------------------------------------

drop table if exists #OutptMemberComparison

;with outptfac as (
		select distinct c.claimid
		from
		#CALAIM_Mem m
		join HMOPROD_PlanData.dbo.claim c on c.memid = m.memid
		join HMOPROD_PlanData.dbo.claimdetail cdet on c.claimid = cdet.claimid
		where
		not(c.facilitycode in ('1','2','8')
		and c.billclasscode in ('1','2'))
		and c.formtype = 'UB04'
		AND (c.startdate between @ClockStartCostCategory and @ClockStopCostCategory 
		or 
		c.startdate between @BaselineClockStartCostCategory and @BaselineClockStopCostCategory )
		)
	,optclaims as (
		select distinct
		c.memid,
		m.fullname as member_name,
		m.dob,
		c.planid,
		case
		when c.planid = 'QMXBP0782' then 'MediCal'
		when c.planid in  ('QMXBP0823','QMXBP0822')then 'CMC'
		else null end line_of_business,
		c.claimid,
		c.admitdate as admitdate,
		c.startdate as startdate,
		c.enddate as enddate,
		c.provid,
		p.fullname as provider,
		payto.provid as paytoid,
		payto.fullname as payto,
		case		
		when cdet.revcode like '045%' and ( c.facilitycode = '1' and c.billclasscode in ('3','4')) then '1-FACILITY-ER'
		else '2-FACILITY-OTHER'
		end cost_category,
		cdet.claimline,
		cdet.revcode,
		cdet.amountpaid as paid,
		cdet.servunits as units
		from
		outptfac f 
		join HMOPROD_PlanData.DBO.claim c on c.claimid = f.claimid
		join HMOPROD_PlanData.DBO. claimdetail cdet on cdet.claimid = c.claimid
		join HMOPROD_PlanData.DBO.provider p on p.provid = c.provid
		join HMOPROD_PlanData.DBO.member m on m.memid = c.memid
		left join HMOPROD_PlanData.DBO.affiliation a2 on a2.affiliationid = c.affiliationid 
		left join HMOPROD_PlanData.DBO.provider payto on payto.provid = a2.affiliateid
		where
		(c.resubclaimid is null or c.resubclaimid = '')
		and c.claimid not like '%R%'
		and c.status in ('ADJUCATED', 'PAID', 'PAY', 'REV', 'REVERSED', 'REVSYNCH')
		and cdet.status not in ('DENY', 'VOID')
		and c.planid in ('QMXBP0823','QMXBP0822','QMXBP0782')
	)
, detail as (
		select
			memid,
			member_name,
			dob,
			line_of_business,
			admitdate,
			dateadd(dd,1,eomonth(startdate,-1))  as dos_month,
			startdate,
			enddate,
			provid,
			provider,
			paytoid,
			payto,
			convert(varchar(max),memid)+ convert(varchar(max),provid)+ convert(varchar(max),startdate) as visit_identifier,
			min(cost_category) as cost_category,
			sum(paid) as paid
		from optclaims
		group by
			memid,
			member_name,
			dob,
			line_of_business,
			admitdate,
			case when admitdate is null then dateadd(dd,1,eomonth(startdate,-1)) else dateadd(dd,1,eomonth(admitdate,-1)) end,
			startdate,
			enddate,
			provid,
			provider,
			paytoid,
			payto,
			convert(varchar(max),memid)+ convert(varchar(max),provid)+ convert(varchar(max),startdate) 
)
, outptfinal as (		
		select
		memid,
		member_name,
		line_of_business,
		dos_month,
		provid,
		provider,
		paytoid,
		payto,
		cost_category,
		count(distinct visit_identifier) as admits_visits,
		sum(paid) as paid
		from detail
		group by
		memid,
		member_name,
		line_of_business,
		dos_month,
		provid,
		provider,
		paytoid,
		payto,
		cost_category)
	select
	ot.*
	into #OutptMemberComparison
	from
	outptfinal ot


--------------------------------------------------------------------------------------------------------------------
	-- Members who went to Professional Setting Under ECM Program --
--------------------------------------------------------------------------------------------------------------------

--DECLARE @ClockStartECM AS datetime
--DECLARE @ClockStopECM AS datetime

--SET @ClockStartECM = '01/01/2022'
--SET @ClockStopECM = '06/30/2024'

-------------------------------------------------------------------------

drop table if exists #ProfMemberComparison

;with prof as (
	select distinct
	claimid
	from #CALAIM_Mem m
	join HMOPROD_PlanData.dbo.claim c on c.memid = m.memid
	where
	c.formtype = '1500'
	AND (c.startdate between @ClockStartCostCategory and @ClockStopCostCategory 
		or 
		c.startdate between @BaselineClockStartCostCategory and @BaselineClockStopCostCategory )
	)
,profwps as (
		select distinct
		p.claimid,
		case 
			when stat.primarystatus is null and (stat2.primarystatus is null or stat2.primarystatus = 'V') and  (stat3.primarystatus is null or stat3.primarystatus = 'V') then 'P'
			when stat.primarystatus is null and (stat2.primarystatus is null or stat2.primarystatus = 'V') then stat3.primarystatus
			when stat.primarystatus is null then stat2.primarystatus
			when stat.primarystatus = 'V' then 'P'
		else stat.primarystatus end primarystatus
		from prof p
		join hmoprod_plandata.dbo.claim c on c.claimid = p.claimid
		join HMOPROD_PlanData.DBO.enrollkeys ek on ek.enrollid = c.enrollid
		outer apply (select top 1 c.memid, es.enrollid, es.effdate, es.termdate, es.primarystatus
						from
						HMOPROD_PlanData.dbo.enrollstatus es
						where 
						es.enrollid = c.enrollid
						and c.startdate between es.effdate and es.termdate
						order by
						c.memid, es.enrollid, es.effdate, es.termdate, es.primarystatus) stat
		outer apply (select top 1 c.memid, es2.enrollid, es2.effdate, es2.termdate, es2.primarystatus
						from
						HMOPROD_PlanData.dbo.enrollstatus es2
						where 
						es2.enrollid = c.enrollid
						order by
						c.memid, es2.enrollid, es2.effdate, es2.termdate, es2.primarystatus) stat2
		outer apply (select top 1 ek2.memid, es3.enrollid, es3.effdate, es3.termdate, es3.primarystatus
						from
						HMOPROD_PlanData.dbo.enrollkeys ek2
						join HMOPROD_PlanData.dbo.enrollstatus es3 on es3.enrollid = ek2.enrollid				
						where 
						ek2.memid = c.memid
						and c.startdate between es3.effdate and es3.termdate
						order by
						ek2.memid, es3.enrollid, es3.effdate, es3.termdate, es3.primarystatus)stat3				 
	)
, profclaims as (
		select distinct
		c.memid,
		m.fullname as member_name,
		m.dob,
		c.planid,
		case
		when c.planid = 'QMXBP0782' then 'MediCal'
		when c.planid in  ('QMXBP0823','QMXBP0822')then 'CMC'
		else null end line_of_business,
		pw.primarystatus,
		c.claimid,
		cdet.dosfrom as dosfrom,
		cdet.dosto as dosto,
		c.provid,
		p.fullname as provider,
		payto.provid as paytoid,
		payto.fullname as payto,
		case
			when ps.specialtycode in ('MON','ACP','ALL','ANE','CBM','CCM','CGN','CMG','CN','CPA','CRS','CRV','DBP','DER','DMD',
										'DPA','DRD','END','ERM','GAS','GON','GVS','HAS','HEM','HPLT','IND','IVC','MBG','MFM','MGN',
										'NEP','NEU','NMM','NPA','NPM','NRD','NTO','NUM','NUR','NUS','OMS','OPH','ORS','OTL','PAA',
										'PAC','PAT','PCC','PCR','PDI','PDM','PDP','PDS','PEM','PEN','PGE','PHO','PID','PLS','PMR','PNM',
										'PNP','POT','PPA','PRD','PRH','PUD','PURO','RAD','RDO','RDP','REN','RHE','SCC','SCR','SPM','SUR',
										'THS','TPH','TSO','URO','VIR','INT','OCT','ACU','AUD','CHI','DDS','MSG','NUTR','OCM','OPT',
										'ORP','PHT','POD','SLP') then '1-PROFESSIONAL-SPECIALTY'
			when ps.specialtycode in ('FAM','GER','GNP','GYN','MSC','INM','OB','OBG','PED') then '2-PROFESSIONAL-PCP'
			when ps.specialtycode = 'AMB' and cdet.servcode in ('A0427','A0429','A0430','A0431') then '3-PROFESSIONAL-EMERGTRANSPORT'
			else '4-PROFESSIONAL-OTHER'
		end cost_category,
		cdet.claimline,
		cdet.amountpaid as paid,
		cdet.servunits as units,
		case
			when c.planid in  ('QMXBP0823','QMXBP0822') and c.totalpaid > 0 and pw.primarystatus = 'P' then cdet.servunits
			when c.planid in  ('QMXBP0823','QMXBP0822') and sum(cdet.amountpaid) over (partition by c.memid,c.provid, c.startdate, c.enddate) > c.totalpaid and pw.primarystatus = 'S' then 0
			when  c.planid in  ('QMXBP0823','QMXBP0822') and sum(cdet.amountpaid) over (partition by c.memid,c.provid,c.startdate, c.enddate) = c.totalpaid and pw.primarystatus = 'S' then cdet.servunits
			when c.planid not in ('QMXBP0823','QMXBP0822') then cdet.servunits
			else 0
		end units_adj
		from profwps pw
		join HMOPROD_PlanData.DBO. claim c  on c.claimid = pw.claimid
		join HMOPROD_PlanData.DBO.claimdetail cdet on c.claimid = cdet.claimid
		join HMOPROD_PlanData.DBO.provider p on p.provid = c.provid
		join HMOPROD_PlanData.DBO.member m on m.memid = c.memid
		left join HMOPROD_PlanData.DBO.affiliation a2 on a2.affiliationid = c.affiliationid 
		left join HMOPROD_PlanData.DBO.provider payto on payto.provid = a2.affiliateid
		left join HMOPROD_PlanData.dbo.provspecialty ps on ps.provid = c.provid
			and c.startdate between ps.effdate and ps.termdate
			and ps.spectype = 'Primary'
		where
		(c.resubclaimid is null or c.resubclaimid = '')
		and c.claimid not like '%R%'
		and c.status in ('ADJUCATED', 'PAID', 'PAY', 'REV', 'REVERSED', 'REVSYNCH')
		and cdet.status not in ('DENY', 'VOID')
		and c.planid in ('QMXBP0823','QMXBP0822','QMXBP0782')
		and c.formtype = '1500'
		and cdet.servunits < 100000
	)
, detail as (
		select
			memid,
			member_name,
			dob,
			line_of_business,
			dateadd(dd,1,eomonth(dosfrom,-1))dos_month,
			dosfrom,
			dosto,
			provid,
			provider,
			paytoid,
			payto,
			convert(varchar(max),memid)+ convert(varchar(max),provid)+ convert(varchar(max),dosfrom) as visit_identifier ,
			min(cost_category) as cost_category,
			sum(paid) as paid,
			sum(units_adj) as units
		from
			profclaims
		group by
			memid,
			member_name,
			dob,
			line_of_business,
			dateadd(dd,1,eomonth(dosfrom,-1)),
			dosfrom,
			dosto,
			provid,
			provider,
			paytoid,
			payto,
			convert(varchar(max),memid)+ convert(varchar(max),provid)+ convert(varchar(max),dosfrom)
			--cost_category
)
, proffinal as (
		select
		memid,
		member_name,
		line_of_business,
		dos_month,
		provid,
		provider,
		paytoid,
		payto,
		min(cost_category) as cost_category,
		count(distinct visit_identifier) as admits_visits,
		sum(paid) as paid,
		sum(units) as days_units
		from detail
		group by
		memid,
		member_name,
		line_of_business,
		dos_month,
		provid,
		provider,
		paytoid,
		payto
		--cost_category
		)
	select
	pf.*
	into #ProfMemberComparison
	from
	proffinal pf


--------------------------------------------------------------------------------------------------------------------
	-- Final Scripting --
--------------------------------------------------------------------------------------------------------------------

--DECLARE @ClockStartECM AS datetime
--DECLARE @ClockStopECM AS datetime

--SET @ClockStartECM = '01/01/2022'
--SET @ClockStopECM = '06/30/2024'

-------------------------------------------------------------------------


--declare @mmstart as date = TRY_CONVERT(date,'01/01/2021')
--declare @mmstop as date = TRY_CONVERT(date,'12/31/2024')

drop table if exists ##Base

select distinct 
cp.memid
, mm.carriermemid
, mm.calendardate
, c.cost_category
, case when mm.sex = 'F' then 'Female'
when mm.sex = 'M' then 'Male'
else '' end as sex
, mm.QNXTLanguage
, mm.EICDesc
into ##Base
from
#CALAIM_Mem AS cp
join informatics.dbo.membermonths mm on mm.memid = cp.memid and mm.CalendarDate between @mmstart and @mmstop
,
	(select distinct
	cost_category
	from
	#InptMemberComparison

	union

	select distinct
	cost_category
	from
	#OutptMemberComparison


	union

	select distinct
	cost_category
	from
	#ProfMemberComparison) c


--------------------------------------------Combine

truncate table Informatics.dbo.CalAimMemberClaims_Continuous_v3;
insert into Informatics.dbo.CalAimMemberClaims_Continuous_v3
select distinct
b.memid as MemID
, '1' as ECMEnrolled
, cp.ECM_Provider_ID
, cp.ECM_Provider_Name
, '' as MemberCategory
, b.CalendarDate as MemberMonth
, 'Inpatient' as CostCategory
, b.cost_category as SubCostCategory
, case when i.Paid is null then 0 else i.Paid end as Paid
, case when i.Admits is null then 0 else i.Admits end as Admits_Visits
, case when i.Days is null then 0 else i.Days end as Days
, b.carriermemid
, b.QNXTLanguage
, b.EICDesc
, b.sex
,'' as [Baseline Enrollment]
from
##Base b 
left join #CALAIM_Mem cp on cp.memid = b.memid
left join (select 
			memid 
			, dos_month 
--			, 'Inpatient' as CostCategory
			, cost_category as SubCostCategory
			, sum(paidfinal) as Paid
			, sum(admits) as Admits
			, sum(days2) as Days
			from
			#InptMemberComparison
			group by
			memid
			, dos_month
			, cost_category) i on i.memid = b.memid and i.DOS_Month = b.CalendarDate and i.SubCostCategory = b.cost_category 

where
b.cost_category like '%inpatient%'

union

select distinct
b.memid as MemID
, '1' as ECMEnrolled
, cp.ECM_Provider_ID
, cp.ECM_Provider_Name
, '' as MemberCategory
, b.CalendarDate as MemberMonth
, 'Outpatient' as CostCategory
, b.cost_category as SubCostCategory
, case when o.Paid is null then 0 else o.Paid end as Paid
, case when o.Visits is null then 0 else o.Visits end as Admits_Visits
, 0 as Days
, b.carriermemid
, b.QNXTLanguage
, b.EICDesc
, b.sex
,'' as [Baseline Enrollment]
from
##Base b 
left join #CALAIM_Mem cp on cp.memid = b.memid
left join (select 
			memid
			, dos_month
--			, 'Outpatient' as CostCategory
			, cost_category as SubCostCategory
			, sum(paid) as Paid
			, sum(admits_visits) as Visits
			from
			#OutptMemberComparison
			group by
			memid
			, dos_month
			, cost_category) o on o.memid = b.memid and o.DOS_Month = b.CalendarDate and o.SubCostCategory = b.cost_category 
			
where
b.cost_category like '%facility%'

union

select distinct
b.memid as MemID
,'1' as ECMEnrolled
, cp.ECM_Provider_ID
, cp.ECM_Provider_Name
, '' MemberCategory
, b.CalendarDate as MemberMonth
, 'Professional' as CostCategory
, b.cost_category as SubCostCategory
, case when p.Paid is null then 0 else p.Paid end as Paid
, case when p.Visits is null then 0 else p.Visits end as Admits_Visits
, 0 as Days
, b.carriermemid
, b.QNXTLanguage
, b.EICDesc
, b.sex
,'' as [Baseline Enrollment]
from
##Base b 
left join #CALAIM_Mem cp on cp.memid = b.memid
left join (select 
			memid
			, dos_month 
			--, 'Professional' as CostCategory
			, cost_category as SubCostCategory
			, sum(paid) as Paid
			, sum(admits_visits) as Visits
			, sum(days_units) as Units
			from
			#ProfMemberComparison
			group by
			memid
			, dos_month
			, cost_category) p on p.memid = b.memid and p.DOS_Month = b.calendardate and p.SubCostCategory = b.cost_category 
			
where
b.cost_category like '%professional%'

UPDATE INFORMATICS.dbo.CalAimMemberClaims_Continuous_v3 ------baseline
SET [ECMEnrolled] = 1

UPDATE INFORMATICS.dbo.CalAimMemberClaims_Continuous_v3 ----- 2021 (Non-ECM Members Flag)
SET [ECMEnrolled] = 0
where Year(MemberMonth) = 2021

update Informatics.dbo.CalAimMemberClaims_Continuous_v3
set SubCostCategory = 
case 
	when SubCostCategory =  '1-INPATIENT-HOSPITAL' then 'Inpatient Hospital'
	when SubCostCategory =  '2-INPATIENT-SNF' then 'Inpatient SNF'
	when SubCostCategory =  '3-INPATIENT-OTHER' then 'Inpatient Other'
	when SubCostCategory =  '1-FACILITY-ER' then 'Emergency Room'
	when SubCostCategory =  '2-FACILITY-OTHER' then 'Facility Non-ER'
	when SubCostCategory =  '1-PROFESSIONAL-SPECIALTY' then 'Specialty'
	when SubCostCategory =  '2-PROFESSIONAL-PCP' then 'Primary Care'
	when SubCostCategory =  '3-PROFESSIONAL-EMERGTRANSPORT' then 'Emergency Transportation'
	when SubCostCategory =  '4-PROFESSIONAL-OTHER' then 'Other'
end
from
Informatics.dbo.CalAimMemberClaims_Continuous_v3


UPDATE INFORMATICS.dbo.CalAimMemberClaims_Continuous_v3
SET [Baseline Enrollment] = t.[Member Count]
FROM
(
SELECT COUNT(DISTINCT(MemID)) AS [Member Count]
FROM #CALAIM_Mem
) AS t;




--Select
--YEAR(MemberMonth) as year,
----count (distinct Memid)
--sum (admits_visits)
--from INFORMATICS.dbo.CalAimMemberClaims_Continuous_v3
--where SubCostCategory = 'Emergency Room'
----and YEAR(MemberMonth) = 2021
--group by YEAR(MemberMonth)

--Select distinct
--SubCostCategory
--from INFORMATICS.dbo.CalAimMemberClaims_Continuous_v3



Select
YEAR(MemberMonth) as year,
--count (distinct Memid)
SubCostCategory,
sum (admits_visits) as Total_Visits,
SUM(Paid) AS Paid_Amount
from INFORMATICS.dbo.CalAimMemberClaims_Continuous_v3
WHERE YEAR(MemberMonth) IN ('2021','2025')
--where SubCostCategory = 'Emergency Room'
group by YEAR(MemberMonth), SubCostCategory
ORDER BY YEAR(MemberMonth), SubCostCategory


Select *
from INFORMATICS.dbo.CalAimMemberClaims_Continuous_v3