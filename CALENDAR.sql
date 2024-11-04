-- ================================================================
	-- #BASELINE DATE() SCRIPT(s) --
-- ================================================================
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET NOCOUNT ON
SET ANSI_NULLS ON
SET ANSI_WARNINGS ON
SET ARITHABORT OFF
SET ARITHIGNORE ON
SET TEXTSIZE 2147483647

-- =====================================================================
	-- COMMENT(S) / CHANGE.LOG: --
-- =====================================================================
-- C001: 2024-10-09	Steffek		Added index to improve performance of view dbo.calendar. Index was being dropped when this proc runs... 	See feature 12958http://devops01:8080/IS/Informatics/_workitems/edit/12958

-----------------------------------------------------------------------------------------------------------------------------
	--Script Details: Listing Of Standard Details Related To The Script--
-----------------------------------------------------------------------------------------------------------------------------
--	Purpose: Date Calendar Cross-Reference Table
--	Create Date (MM/DD/YYYY): 10/29/2009
--	Developer: Sean Smith (s.smith.sql AT gmail DOT com)
--	Additional Notes: N/A()

-----------------------------------------------------------------------------------------------------------------------------
--	Modification History: Listing Of All Modifications Since Original Implementation
-----------------------------------------------------------------------------------------------------------------------------
--	Description: Fixed Bug Affecting "month_weekdays_remaining" And "quarter_weekdays_remaining" Columns
--	Date (MM/DD/YYYY): 07/02/2014
--	Developer: Sean Smith (s.smith.sql AT gmail DOT com)
--	Additional Notes: N/A()

-- =================================================================
	-- DYNAMIC() v. STATIC() DECLARE(s) FOR [CALENDAR DEVELOPMENT] --
-- =================================================================
DECLARE @rolling AS int
DECLARE @rollingplus AS int
DECLARE @paydayon AS nvarchar(255)
DECLARE @RangeStart AS date
DECLARE @RangeEnd AS date
DECLARE @ReferencePayDay AS date
DECLARE @when AS date
DECLARE @AsOf AS int  -- SELECT A SPECIFIC DAY of MONTH TO KEEP

SET @rolling = 50
SET @rollingplus = 52
SET @paydayon = 'FRIDAY'
SET @RangeStart= TRY_CONVERT(date,CAST('01/01/'+CAST(DATEPART(yyyy,DATEADD(YEAR,-@rolling,CAST(GETDATE() AS datetime))) AS varchar(4)) AS datetime)) -- ROLLING # YEAR(S)
SET @RangeEnd = DATEADD(DAY,-1,DATEADD(YEAR,@rollingplus,@RangeStart)) -- END OF NEXT YEAR
SET @ReferencePayDay = '20210430'
SET @when = GETDATE()
SET @AsOf = 1 -- SELECT A SPECIFIC DAY of MONTH TO KEEP

		SELECT 	'BETWEEN '+CAST(@RangeStart AS varchar(255))+' AND '+CAST(@RangeEnd AS varchar(255)) AS [CALENDAR RANGE]






-----------------------------------------------------------------------------------------------------------------------------
	-- Error Trapping: Check If Permanent Table(s) Already Exist(s) And Drop If Applicable --
-----------------------------------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS #date_calendar; -- SQL Server 2016 and later -- DYNAMIC tmp OR STATIC [TABLE] #TableName is a local temporary table visible only in the current session; ##TableName is a GLOBAL temporary table visible to all sessions IN ('TempDB')
/* IF OBJECT_ID('TempDB..#date_calendar') IS NOT NULL -- tmp CTE [TABLE] #TableName is a local temporary table visible only in the current session; ##TableName is a GLOBAL temporary table visible to all sessions IN ('TempDB')
DROP TABLE #date_calendar; */

-----------------------------------------------------------------------------------------------------------------------------
	--Permanent Table: Create Date Xref Table--
-----------------------------------------------------------------------------------------------------------------------------
CREATE TABLE #date_calendar
( -- INITIATE ...
calendar_date DATETIME NULL -- DATETIME NOT NULL -- CONSTRAINT PK_date_calendar_calendar_date PRIMARY KEY CLUSTERED
,calendar_year SMALLINT NULL
,calendar_month TINYINT NULL
,calendar_day TINYINT NULL
,calendar_quarter TINYINT NULL
,[CALENDARDAY] INT NULL
,[WORKDAY] INT NULL
,first_day_in_week DATETIME NULL
,last_day_in_week DATETIME NULL
,[first_day_in_week_TEXT] VARCHAR (8) NULL --BUILD 'yyyymmdd' DATE
,[last_day_in_week_TEXT] VARCHAR (8) NULL --BUILD 'yyyymmdd' DATE
,is_week_in_same_month INT NULL
,first_day_in_month DATETIME NULL
,last_day_in_month DATETIME NULL
,[first_day_in_month_TEXT] VARCHAR (8) NULL --BUILD 'yyyymmdd' DATE
,[last_day_in_month_TEXT] VARCHAR (8) NULL --BUILD 'yyyymmdd' DATE
,is_last_day_in_month INT NULL
,first_day_in_quarter DATETIME NULL
,last_day_in_quarter DATETIME NULL
,[first_day_in_quarter_TEXT] VARCHAR (8) NULL --BUILD 'yyyymmdd' DATE
,[last_day_in_quarter_TEXT] VARCHAR (8) NULL --BUILD 'yyyymmdd' DATE
,is_last_day_in_quarter INT NULL
,day_of_week TINYINT NULL
,week_of_month TINYINT NULL
,week_of_quarter TINYINT NULL
,week_of_year TINYINT NULL
,days_in_month TINYINT NULL
,month_days_remaining TINYINT NULL
,weekdays_in_month TINYINT NULL
,month_weekdays_remaining TINYINT NULL
,month_weekdays_completed TINYINT NULL
,days_in_quarter TINYINT NULL
,quarter_days_remaining TINYINT NULL
,quarter_days_completed TINYINT NULL
,weekdays_in_quarter TINYINT NULL
,quarter_weekdays_remaining TINYINT NULL
,quarter_weekdays_completed TINYINT NULL
,day_of_year SMALLINT NULL
,year_days_remaining SMALLINT NULL
,is_weekday INT NULL
,is_leap_year INT NULL
,day_name VARCHAR (10) NULL
,month_day_name_instance TINYINT NULL
,quarter_day_name_instance TINYINT NULL
,year_day_name_instance TINYINT NULL
,month_name VARCHAR (10) NULL
,year_week CHAR (6) NULL
,year_month CHAR (6) NULL
,year_quarter CHAR (6) NULL
,[RANGE] nvarchar (255) NULL --'BETWEEN '+CAST(CAST(DATEADD(month,-12,@when) AS date) AS nvarchar(18))+' AND '+CAST(CAST(DATEADD(month,0,@when-1) AS date) AS nvarchar(18)) AS [RANGE]
,[HOLIDAYS] INT NULL --BUILD HOLIDAY TABLE THEN USE DAILY TAT QUPD LOGIC
,[WORKDAYS_minus_HOLIDAYS] INT NULL --BUILD HOLIDAY TABLE THEN USE DAILY TAT QUPD LOGIC
,[FEDERAL_HOLIDAYS] INT NULL --BUILD HOLIDAY TABLE THEN USE DAILY TAT QUPD LOGIC
,[PREVIOUSfirst_day_in_week] DATETIME NULL --KEY ON last_day_in_week DATETIME NULL
,[PREVIOUSlast_day_in_week] DATETIME NULL --KEY ON ,[PREVIOUSfirst_day_in_week] QUPD
,[PREVIOUSfirst_day_in_week_TEXT] VARCHAR (8) NULL --BUILD 'yyyymmdd' DATE
,[PREVIOUSlast_day_in_week_TEXT] VARCHAR (8) NULL --BUILD 'yyyymmdd' DATE
,[PREVIOUSfirst_day_in_month] DATETIME NULL --KEY ON last_day_in_month DATETIME NULL
,[PREVIOUSlast_day_in_month] DATETIME NULL  --KEY ON ,[PREVIOUSfirst_day_in_month] QUPD
,[PREVIOUSfirst_day_in_month_TEXT] VARCHAR (8) NULL --BUILD 'yyyymmdd' DATE
,[PREVIOUSlast_day_in_month_TEXT] VARCHAR (8) NULL --BUILD 'yyyymmdd' DATE
,[FIRST_day_in_year] DATETIME NULL
,[LAST_day_in_year] DATETIME NULL
,[calendar_date_TEXT] VARCHAR (8) NULL --BUILD 'yyyymmdd' DATE
,[first_day_in_year_TEXT] VARCHAR (8) NULL --BUILD 'yyyymmdd' DATE
,[last_day_in_year_TEXT] VARCHAR (8) NULL --BUILD 'yyyymmdd' DATE
); -- CONCLUDE ...

-----------------------------------------------------------------------------------------------------------------------------
	--TBL Insert: Populate Base Date VAL() Into Permanent TBL Using Common TBL Expression (CTE)--
-----------------------------------------------------------------------------------------------------------------------------
;WITH CTE_Date_Base_Table AS --Incorrect syntax near the keyword 'WITH'. If this statement is a common table expression, an xmlnamespaces clause or a change tracking context clause, the previous statement must be terminated WITH a semicolon.
	(
		SELECT
			@RangeStart AS calendar_date
		UNION ALL
		SELECT
			DATEADD (DAY,1, cDBT.calendar_date)
		FROM
			CTE_Date_Base_Table AS cDBT
		WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ... AND ... 
			AND DATEADD (DAY,1, cDBT.calendar_date) <= @RangeEnd
	)

INSERT INTO #date_calendar
	(
		calendar_date
	)

SELECT
	cDBT.calendar_date
FROM
	CTE_Date_Base_Table AS cDBT
OPTION
	(MAXRECURSION 0)
	
	
	
	
	


-----------------------------------------------------------------------------------------------------------------------------
	--Table Update I: Populate Additional Date Xref Table Fields (Pass I)--
-----------------------------------------------------------------------------------------------------------------------------
UPDATE
	#date_calendar
SET
	 calendar_year = DATEPART (YEAR, calendar_date)
	,calendar_month = DATEPART (MONTH, calendar_date)
	,calendar_day = DATEPART (DAY, calendar_date)
	,calendar_quarter = DATEPART (QUARTER, calendar_date)
	,first_day_in_week = DATEADD (DAY, -DATEPART (WEEKDAY, calendar_date) + 1, calendar_date)
	,first_day_in_month = CONVERT (VARCHAR (6), calendar_date,112) + '01'
	,day_of_week = DATEPART (WEEKDAY, calendar_date)
	,week_of_year = DATEPART (WEEK, calendar_date)
	,day_of_year = DATEPART (DAYOFYEAR, calendar_date)
	,is_weekday = (CASE
	WHEN ((@@DATEFIRST - 1) + (DATEPART (WEEKDAY, calendar_date) - 1)) % 7 NOT IN (5, 6) 
	THEN 1
	ELSE 0
	END)
	,day_name = DATENAME (WEEKDAY, calendar_date)
	,month_name = DATENAME (MONTH, calendar_date)
	
	
	
	
	


-----------------------------------------------------------------------------------------------------------------------------
	--Table Update 000: QUPD '....quarter...' [FIELD(s)]--
-----------------------------------------------------------------------------------------------------------------------------
UPDATE #date_calendar
SET first_day_in_quarter = CASE
WHEN DATENAME(qq, CAST(calendar_date AS datetime)) = '4'
THEN CAST('10/01/'+CAST(DATEPART(yyyy, CAST(calendar_date AS datetime)) AS nvarchar(4)) AS datetime)
WHEN DATENAME(qq, CAST(calendar_date AS datetime)) = '3'
THEN CAST('07/01/'+CAST(DATEPART(yyyy, CAST(calendar_date AS datetime)) AS nvarchar(4)) AS datetime)
WHEN DATENAME(qq, CAST(calendar_date AS datetime)) = '2'
THEN CAST('04/01/'+CAST(DATEPART(yyyy, CAST(calendar_date AS datetime)) AS nvarchar(4)) AS datetime)
ELSE CAST('01/01/'+CAST(DATEPART(yyyy, CAST(calendar_date AS datetime)) AS nvarchar(4)) AS datetime)
END
,last_day_in_quarter = CASE
WHEN DATENAME(qq, CAST(calendar_date AS datetime)) = '4'
THEN CAST('12/31/'+CAST(DATEPART(yyyy, CAST(calendar_date AS datetime)) AS nvarchar(4)) AS datetime)
WHEN DATENAME(qq, CAST(calendar_date AS datetime)) = '3'
THEN CAST('09/30/'+CAST(DATEPART(yyyy, CAST(calendar_date AS datetime)) AS nvarchar(4)) AS datetime)
WHEN DATENAME(qq, CAST(calendar_date AS datetime)) = '2'
THEN CAST('06/30/'+CAST(DATEPART(yyyy, CAST(calendar_date AS datetime)) AS nvarchar(4)) AS datetime)
ELSE CAST('03/31/'+CAST(DATEPART(yyyy, CAST(calendar_date AS datetime)) AS nvarchar(4)) AS datetime)
END
-- SELECT ' ' AS 'SHOULD BE NULL DUP Validation',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM #date_calendar AS dc

		-- SELECT * FROM #date_calendar

UPDATE #date_calendar
SET [first_day_in_quarter_TEXT] = LTRIM(RTRIM(REPLACE(CAST(CAST([first_day_in_quarter] AS date) AS nvarchar(10)),'-','')))
,[last_day_in_quarter_TEXT] = LTRIM(RTRIM(REPLACE(CAST(CAST([last_day_in_quarter] AS date) AS nvarchar(10)),'-','')))
FROM #date_calendar AS dc

ALTER TABLE #date_calendar ALTER COLUMN calendar_year INT NOT NULL
ALTER TABLE #date_calendar ALTER COLUMN calendar_month INT NOT NULL
ALTER TABLE #date_calendar ALTER COLUMN calendar_day INT NOT NULL
ALTER TABLE #date_calendar ALTER COLUMN calendar_quarter INT NOT NULL
ALTER TABLE #date_calendar ALTER COLUMN first_day_in_week DATETIME NOT NULL
ALTER TABLE #date_calendar ALTER COLUMN first_day_in_month DATETIME NOT NULL
ALTER TABLE #date_calendar ALTER COLUMN day_of_week INT NOT NULL
ALTER TABLE #date_calendar ALTER COLUMN week_of_year INT NOT NULL
ALTER TABLE #date_calendar ALTER COLUMN day_of_year INT NOT NULL
ALTER TABLE #date_calendar ALTER COLUMN is_weekday INT NOT NULL
ALTER TABLE #date_calendar ALTER COLUMN day_name VARCHAR (10) NOT NULL
ALTER TABLE #date_calendar ALTER COLUMN month_name VARCHAR (10) NOT NULL

	-- ADD indexes to improve query performance
  CREATE CLUSTERED INDEX IX_date_calendar_calendar_date ON #date_calendar (Calendar_Date, is_weekday,holidays) -- C001: 2024-10-09	Steffek		Added index to improve performance of view dbo.calendar. Index was being dropped when this proc runs... 	See feature 12958http://devops01:8080/IS/Informatics/_workitems/edit/12958

CREATE NONCLUSTERED INDEX IX_date_calendar_calendar_year ON #date_calendar (calendar_year)
CREATE NONCLUSTERED INDEX IX_date_calendar_calendar_month ON #date_calendar (calendar_month)
CREATE NONCLUSTERED INDEX IX_date_calendar_calendar_quarter ON #date_calendar (calendar_quarter)
CREATE NONCLUSTERED INDEX IX_date_calendar_first_day_in_week ON #date_calendar (first_day_in_week)
CREATE NONCLUSTERED INDEX IX_date_calendar_day_of_week ON #date_calendar (day_of_week)
CREATE NONCLUSTERED INDEX IX_date_calendar_is_weekday ON #date_calendar (is_weekday)







-----------------------------------------------------------------------------------------------------------------------------
	--Table Update II: Populate Additional Date Xref Table Fields (Pass II)--
-----------------------------------------------------------------------------------------------------------------------------
UPDATE DC
SET
 DC.last_day_in_week = DC.first_day_in_week + 6
,DC.last_day_in_month = DATEADD (MONTH,1, DC.first_day_in_month) - 1
-- ,DC.first_day_in_quarter = sqDC.first_day_in_quarter
-- ,DC.last_day_in_quarter = sqDC.last_day_in_quarter
,DC.week_of_month = DATEDIFF (WEEK, DC.first_day_in_month, DC.calendar_date) + 1
,DC.week_of_quarter = (DC.week_of_year - sqDC.min_week_of_year_in_quarter) + 1
,DC.is_leap_year = (CASE
WHEN DC.calendar_year % 400 = 0 THEN 1
WHEN DC.calendar_year % 100 = 0 THEN 0
WHEN DC.calendar_year % 4 = 0 THEN 1
ELSE 0
END)
,DC.year_week = CONVERT (VARCHAR (4), DC.calendar_year) + RIGHT ('0' + CONVERT (VARCHAR (2), DC.week_of_year), 2)
,DC.year_month = CONVERT (VARCHAR (4), DC.calendar_year) + RIGHT ('0' + CONVERT (VARCHAR (2), DC.calendar_month), 2)
,DC.year_quarter = CONVERT (VARCHAR (4), DC.calendar_year) + 'Q' + CONVERT (VARCHAR (1), DC.calendar_quarter)
FROM
#date_calendar AS DC
	INNER JOIN
		( -- INITIATE ...
			SELECT
				 DC.calendar_year
				,DC.calendar_quarter
				-- ,MIN(DC.calendar_date) AS first_day_in_quarter
				-- ,MAX(DC.calendar_date) AS last_day_in_quarter
				,MIN(DC.week_of_year) AS min_week_of_year_in_quarter
			FROM
				#date_calendar AS DC
			GROUP BY
				 DC.calendar_year
				,DC.calendar_quarter
		) -- CONCLUDE ...
		AS sqDC ON sqDC.calendar_year = DC.calendar_year AND sqDC.calendar_quarter = DC.calendar_quarter


		
		
		
		
		
ALTER TABLE #date_calendar ALTER COLUMN last_day_in_week DATETIME NOT NULL
ALTER TABLE #date_calendar ALTER COLUMN last_day_in_month DATETIME NOT NULL
ALTER TABLE #date_calendar ALTER COLUMN first_day_in_quarter DATETIME NOT NULL
ALTER TABLE #date_calendar ALTER COLUMN last_day_in_quarter DATETIME NOT NULL
ALTER TABLE #date_calendar ALTER COLUMN week_of_month INT NOT NULL
ALTER TABLE #date_calendar ALTER COLUMN week_of_quarter INT NOT NULL
ALTER TABLE #date_calendar ALTER COLUMN is_leap_year INT NOT NULL
ALTER TABLE #date_calendar ALTER COLUMN year_week VARCHAR (6) NOT NULL
ALTER TABLE #date_calendar ALTER COLUMN year_month VARCHAR (6) NOT NULL
ALTER TABLE #date_calendar ALTER COLUMN year_quarter VARCHAR (6) NOT NULL

CREATE NONCLUSTERED INDEX IX_date_calendar_last_day_in_week ON #date_calendar (last_day_in_week)
CREATE NONCLUSTERED INDEX IX_date_calendar_year_month ON #date_calendar (year_month)
CREATE NONCLUSTERED INDEX IX_date_calendar_year_quarter ON #date_calendar (year_quarter)







-----------------------------------------------------------------------------------------------------------------------------
	--Table Update III: Populate Additional Date Xref Table Fields (Pass III)--
-----------------------------------------------------------------------------------------------------------------------------
UPDATE
	DC
SET
	 DC.is_last_day_in_month = (CASE
									WHEN DC.last_day_in_month = DC.calendar_date THEN 1
									ELSE 0
									END)
	,DC.is_last_day_in_quarter = (CASE
									WHEN DC.last_day_in_quarter = DC.calendar_date THEN 1
									ELSE 0
									END)
	,DC.days_in_month = DATEPART (DAY, DC.last_day_in_month)
	,DC.weekdays_in_month = sqDC1.weekdays_in_month
	,DC.days_in_quarter = DATEDIFF (DAY, DC.first_day_in_quarter, DC.last_day_in_quarter) + 1
	,DC.quarter_days_remaining = DATEDIFF (DAY, DC.calendar_date, DC.last_day_in_quarter)
	,DC.weekdays_in_quarter = sqDC2.weekdays_in_quarter
	,DC.year_days_remaining = (365 + DC.is_leap_year) - DC.day_of_year
FROM
	#date_calendar AS DC
	INNER JOIN
		(
			SELECT
				 DC.year_month
				,SUM (DC.is_weekday) AS weekdays_in_month
			FROM
				#date_calendar AS DC
			GROUP BY
				DC.year_month
		) AS sqDC1 ON sqDC1.year_month = DC.year_month

	INNER JOIN
		( -- INITIATE ...
			SELECT
				 DC.year_quarter
				,SUM (DC.is_weekday) AS weekdays_in_quarter
			FROM
				#date_calendar AS DC
			GROUP BY
				DC.year_quarter
		 ) -- CONCLUDE ... 
		 AS sqDC2 ON sqDC2.year_quarter = DC.year_quarter



		 
		 
		 
		 
ALTER TABLE #date_calendar ALTER COLUMN is_last_day_in_month INT NOT NULL
ALTER TABLE #date_calendar ALTER COLUMN is_last_day_in_quarter INT NOT NULL
ALTER TABLE #date_calendar ALTER COLUMN days_in_month INT NOT NULL
ALTER TABLE #date_calendar ALTER COLUMN weekdays_in_month INT NOT NULL
ALTER TABLE #date_calendar ALTER COLUMN days_in_quarter INT NOT NULL
ALTER TABLE #date_calendar ALTER COLUMN quarter_days_remaining INT NOT NULL
ALTER TABLE #date_calendar ALTER COLUMN weekdays_in_quarter INT NOT NULL
ALTER TABLE #date_calendar ALTER COLUMN year_days_remaining INT NOT NULL







-----------------------------------------------------------------------------------------------------------------------------
	--Table Update IV: Populate Additional Date Xref Table Fields (Pass IV)--
-----------------------------------------------------------------------------------------------------------------------------
UPDATE
	DC
SET
	 DC.month_weekdays_remaining = DC.weekdays_in_month - sqDC.month_weekdays_remaining_subtraction
	,DC.quarter_weekdays_remaining = DC.weekdays_in_quarter - sqDC.quarter_weekdays_remaining_subtraction
FROM
	#date_calendar DC
	INNER JOIN

(
SELECT
 DC.calendar_date
,ROW_NUMBER () OVER
					(
						PARTITION BY
							DC.year_month
						ORDER BY
							DC.calendar_date
					) AS month_weekdays_remaining_subtraction
,ROW_NUMBER () OVER
					(
						PARTITION BY
							DC.year_quarter
						ORDER BY
							DC.calendar_date
					) AS quarter_weekdays_remaining_subtraction
FROM
#date_calendar AS DC
WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ... AND ... 
	AND DC.is_weekday = 1
) sqDC ON sqDC.calendar_date = DC.calendar_date

		
		
		
		
		

-----------------------------------------------------------------------------------------------------------------------------
	--Table Update V: Populate Additional Date Xref Table Fields (Pass V)--
-----------------------------------------------------------------------------------------------------------------------------
UPDATE
	DC
SET
 DC.month_weekdays_remaining = (CASE
WHEN DC1.calendar_month = DC.calendar_month AND DC1.month_weekdays_remaining IS NOT NULL THEN DC1.month_weekdays_remaining
WHEN DC2.calendar_month = DC.calendar_month AND DC2.month_weekdays_remaining IS NOT NULL THEN DC2.month_weekdays_remaining
ELSE DC.weekdays_in_month
END)
,DC.quarter_weekdays_remaining = (CASE
WHEN DC1.calendar_quarter = DC.calendar_quarter AND DC1.quarter_weekdays_remaining IS NOT NULL THEN DC1.quarter_weekdays_remaining
WHEN DC2.calendar_quarter = DC.calendar_quarter AND DC2.quarter_weekdays_remaining IS NOT NULL THEN DC2.quarter_weekdays_remaining
ELSE DC.weekdays_in_quarter
END)
FROM #date_calendar AS DC
	LEFT JOIN #date_calendar DC1 ON DATEADD (DAY,1, DC1.calendar_date) = DC.calendar_date
	LEFT JOIN #date_calendar DC2 ON DATEADD (DAY, 2, DC2.calendar_date) = DC.calendar_date
WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ... AND ... 
	AND DC.month_weekdays_remaining IS NULL

ALTER TABLE #date_calendar ALTER COLUMN month_weekdays_remaining INT NOT NULL
ALTER TABLE #date_calendar ALTER COLUMN quarter_weekdays_remaining INT NOT NULL







-----------------------------------------------------------------------------------------------------------------------------
	--Table Update VI: Populate Additional Date Xref Table Fields (Pass VI)--
-----------------------------------------------------------------------------------------------------------------------------
UPDATE
	DC
SET
	 DC.is_week_in_same_month = sqDC.is_week_in_same_month
	,DC.month_days_remaining = DC.days_in_month - DC.calendar_day
	,DC.month_weekdays_completed = DC.weekdays_in_month - DC.month_weekdays_remaining
	,DC.quarter_days_completed = DC.days_in_quarter - DC.quarter_days_remaining
	,DC.quarter_weekdays_completed = DC.weekdays_in_quarter - DC.quarter_weekdays_remaining
	,DC.month_day_name_instance = sqDC.month_day_name_instance
	,DC.quarter_day_name_instance = sqDC.quarter_day_name_instance
	,DC.year_day_name_instance = sqDC.year_day_name_instance
FROM
	#date_calendar DC
	INNER JOIN

	(
		SELECT
			 DC.calendar_date
			,(CASE
				WHEN DATEDIFF (MONTH, DC.first_day_in_week, DC.last_day_in_week) = 0 THEN 1
				ELSE 0
				END) AS is_week_in_same_month
			,ROW_NUMBER () OVER
								(
									PARTITION BY
										 DC.year_month
										,DC.day_name
									ORDER BY
										DC.calendar_date
								) AS month_day_name_instance
			,ROW_NUMBER () OVER
								(
									PARTITION BY
										 DC.year_quarter
										,DC.day_name
									ORDER BY
										DC.calendar_date
								) AS quarter_day_name_instance
			,ROW_NUMBER () OVER
								(
									PARTITION BY
										 DC.calendar_year
										,DC.day_name
									ORDER BY
										DC.calendar_date
								) AS year_day_name_instance
		FROM
			#date_calendar AS DC
	) AS sqDC 
	ON sqDC.calendar_date = DC.calendar_date

ALTER TABLE #date_calendar ALTER COLUMN is_week_in_same_month INT NOT NULL
ALTER TABLE #date_calendar ALTER COLUMN month_days_remaining INT NOT NULL
ALTER TABLE #date_calendar ALTER COLUMN month_weekdays_completed INT NOT NULL
ALTER TABLE #date_calendar ALTER COLUMN quarter_days_completed INT NOT NULL
ALTER TABLE #date_calendar ALTER COLUMN quarter_weekdays_completed INT NOT NULL
ALTER TABLE #date_calendar ALTER COLUMN month_day_name_instance INT NOT NULL
ALTER TABLE #date_calendar ALTER COLUMN quarter_day_name_instance INT NOT NULL
ALTER TABLE #date_calendar ALTER COLUMN year_day_name_instance INT NOT NULL







-- ===============================	
	-- IDENTIFY WORKDAY() --
-- ===============================
UPDATE #date_calendar
SET CALENDARDAY = 1

UPDATE #date_calendar
SET WORKDAY = 1
--SELECT TOP 1000 DATEPART(dd,CAST([calendar_date] AS datetime)),* -- CHECK 1st
FROM #date_calendar
WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ... AND ... 
	AND day_of_week NOT IN ('1','7')

UPDATE #date_calendar
SET WORKDAY = 0
--SELECT TOP 1000 DATEPART(dd,CAST([calendar_date] AS datetime)),* -- CHECK 1st
FROM #date_calendar
WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ... AND ... 
	AND WORKDAY IS NULL







-- ==========================================================	
 	-- ASSIGN HOLIDAY(s) --
-- ==========================================================
--------------------------------------------------------------------------------------------------------------------
	-- Error Trapping: Check If Permanent Table(s) Already Exist(s) And Drop If Applicable --
--------------------------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS #ADD_HOLIDAYs -- SQL Server 2016 and later -- DYNAMIC tmp OR STATIC [TABLE] #TableName is a local temporary table visible only in the current session; ##TableName is a GLOBAL temporary table visible to all sessions IN ('TempDB')

SELECT * 
INTO #ADD_HOLIDAYs --;WITH() LIKE '%CREATION OF [tempdb] TABLE%'  # FROM JL
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st',
FROM
 ( --INITIATE ...
SELECT DISTINCT 'New Years Day' AS [Holiday]
,CAST(NULL AS int) AS [Month]
,CAST(NULL AS int) AS [dayofweek]
,CASE DATEPART(dw,TRY_CONVERT(nvarchar(4),dc.calendar_year)+'-'+'01'+'-'+'01') -- EVALUATE AS OF ...
WHEN 1 -- [SUNDAY]
THEN DATEADD(d,1,TRY_CONVERT(nvarchar(4),dc.calendar_year)+'-'+'01'+'-'+'01')
WHEN 7 -- [SATURDAY]
THEN DATEADD(d,-1,TRY_CONVERT(nvarchar(4),dc.calendar_year)+'-'+'01'+'-'+'01') 
ELSE TRY_CONVERT(date,TRY_CONVERT(nvarchar(4),dc.calendar_year)+'-'+'01'+'-'+'01')
END AS [Holiday Celebrated] -- † When a holiday falls on Saturday or Sunday, most employees observed the holiday on the previous Friday or following Monday, respectively (5 U.S.C. 6103(b) and Executive Order 11582 3(a)). per USE https://www.federalpay.org/holidays
,CAST(NULL AS nvarchar(3)) AS [DOWabbrev]
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st',
FROM INFORMATICS.dbo.date_calendarISO AS dc

/* SELECT DISTINCT 'New Years Day' AS [Holiday]
,CAST(NULL AS int) AS [Month]
,CAST(NULL AS int) AS [dayofweek]
,TRY_CONVERT(nvarchar(4),dc.calendar_year)+'-'+'01'+'-'+'01' AS [Holiday Celebrated]
,CAST(NULL AS nvarchar(3)) AS [DOWabbrev]
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st',
FROM INFORMATICS.dbo.date_calendarISO AS dc */

UNION -- VERTICAL() STACK DISTINCT()
SELECT DISTINCT 'MLK' AS [Holiday]
,CAST(NULL AS int) AS [Month]
,CAST(NULL AS int) AS [dayofweek]
,CASE DATEPART(dw,TRY_CONVERT(nvarchar(4),dc.calendar_year)+'-'+'01'+'-'+'01') -- EVALUATE AS OF ...
WHEN 1 -- [SUNDAY]
THEN DATEADD(d,15,TRY_CONVERT(nvarchar(4),dc.calendar_year)+'-'+'01'+'-'+'01')
WHEN 2 -- [MONDAY]
THEN DATEADD(d,14,TRY_CONVERT(nvarchar(4),dc.calendar_year)+'-'+'01'+'-'+'01')
WHEN 3 -- [TUESDAY]
THEN DATEADD(d,20,TRY_CONVERT(nvarchar(4),dc.calendar_year)+'-'+'01'+'-'+'01')
WHEN 4 -- [WEDNESDAY]
THEN DATEADD(d,19,TRY_CONVERT(nvarchar(4),dc.calendar_year)+'-'+'01'+'-'+'01')
WHEN 5 -- [THURSDAY]
THEN DATEADD(d,18,TRY_CONVERT(nvarchar(4),dc.calendar_year)+'-'+'01'+'-'+'01')
WHEN 6 -- [FRIDAY]
THEN DATEADD(d,17,TRY_CONVERT(nvarchar(4),dc.calendar_year)+'-'+'01'+'-'+'01')
WHEN 7 -- [SATURDAY]
THEN DATEADD(d,16,TRY_CONVERT(nvarchar(4),dc.calendar_year)+'-'+'01'+'-'+'01') 
END AS [Holiday Celebrated] -- 3rd Monday of January
,CAST(NULL AS nvarchar(3)) AS [DOWabbrev]
FROM INFORMATICS.dbo.date_calendarISO AS dc

UNION -- VERTICAL() STACK DISTINCT()
SELECT DISTINCT 'Presidents' AS [Holiday]
,CAST(NULL AS int) AS [Month]
,CAST(NULL AS int) AS [dayofweek]
,CASE DATEPART(dw,TRY_CONVERT(nvarchar(4),dc.calendar_year)+'-'+'02'+'-'+'01') -- EVALUATE AS OF ...
WHEN 1 -- [SUNDAY]
THEN DATEADD(d,15,TRY_CONVERT(nvarchar(4),dc.calendar_year)+'-'+'02'+'-'+'01')
WHEN 2 -- [MONDAY]
THEN DATEADD(d,14,TRY_CONVERT(nvarchar(4),dc.calendar_year)+'-'+'02'+'-'+'01')
WHEN 3 -- [TUESDAY]
THEN DATEADD(d,20,TRY_CONVERT(nvarchar(4),dc.calendar_year)+'-'+'02'+'-'+'01')
WHEN 4 -- [WEDNESDAY]
THEN DATEADD(d,19,TRY_CONVERT(nvarchar(4),dc.calendar_year)+'-'+'02'+'-'+'01')
WHEN 5 -- [THURSDAY]
THEN DATEADD(d,18,TRY_CONVERT(nvarchar(4),dc.calendar_year)+'-'+'02'+'-'+'01')
WHEN 6 -- [FRIDAY]
THEN DATEADD(d,17,TRY_CONVERT(nvarchar(4),dc.calendar_year)+'-'+'02'+'-'+'01')
WHEN 7 -- [SATURDAY]
THEN DATEADD(d,16,TRY_CONVERT(nvarchar(4),dc.calendar_year)+'-'+'02'+'-'+'01') 
END AS [Holiday Celebrated] -- 3rd Monday of February
,CAST(NULL AS nvarchar(3)) AS [DOWabbrev]
FROM INFORMATICS.dbo.date_calendarISO AS dc

UNION -- VERTICAL() STACK DISTINCT()
SELECT DISTINCT 'Memorial' AS [Holiday]
,CAST(NULL AS int) AS [Month]
,CAST(NULL AS int) AS [dayofweek]
,CASE DATEPART(dw,TRY_CONVERT(nvarchar(4),dc.calendar_year)+'-'+'05'+'-'+'01') -- EVALUATE AS OF ...
WHEN 1 -- [SUNDAY]
THEN DATEADD(d,29,TRY_CONVERT(nvarchar(4),dc.calendar_year)+'-'+'05'+'-'+'01')
WHEN 2 -- [MONDAY]
THEN DATEADD(d,28,TRY_CONVERT(nvarchar(4),dc.calendar_year)+'-'+'05'+'-'+'01')
WHEN 3 -- [TUESDAY]
THEN DATEADD(d,27,TRY_CONVERT(nvarchar(4),dc.calendar_year)+'-'+'05'+'-'+'01')
WHEN 4 -- [WEDNESDAY]
THEN DATEADD(d,26,TRY_CONVERT(nvarchar(4),dc.calendar_year)+'-'+'05'+'-'+'01')
WHEN 5 -- [THURSDAY]
THEN DATEADD(d,25,TRY_CONVERT(nvarchar(4),dc.calendar_year)+'-'+'05'+'-'+'01')
WHEN 6 -- [FRIDAY]
THEN DATEADD(d,24,TRY_CONVERT(nvarchar(4),dc.calendar_year)+'-'+'05'+'-'+'01')
WHEN 7 -- [SATURDAY]
THEN DATEADD(d,23,TRY_CONVERT(nvarchar(4),dc.calendar_year)+'-'+'05'+'-'+'01') 
END AS [Holiday Celebrated] -- 4th Monday of May (SPECIAL CIRCUMSTANCE WHEN MONTH START(s) ON Monday '2')
,CAST(NULL AS nvarchar(3)) AS [DOWabbrev]
FROM INFORMATICS.dbo.date_calendarISO AS dc

UNION -- VERTICAL() STACK DISTINCT()
SELECT DISTINCT 'Juneteenth' AS [Holiday]
,CAST(NULL AS int) AS [Month]
,CAST(NULL AS int) AS [dayofweek]
,TRY_CONVERT(nvarchar(4),dc.calendar_year)+'-'+'06'+'-'+'19' AS [Holiday Celebrated]
,CAST(NULL AS nvarchar(3)) AS [DOWabbrev]
FROM INFORMATICS.dbo.date_calendarISO AS dc

UNION -- VERTICAL() STACK DISTINCT()
SELECT DISTINCT 'Independence' AS [Holiday]
,CAST(NULL AS int) AS [Month]
,CAST(NULL AS int) AS [dayofweek]
,TRY_CONVERT(nvarchar(4),dc.calendar_year)+'-'+'07'+'-'+'04' AS [Holiday Celebrated]
,CAST(NULL AS nvarchar(3)) AS [DOWabbrev]
FROM INFORMATICS.dbo.date_calendarISO AS dc

UNION -- VERTICAL() STACK DISTINCT()
SELECT DISTINCT 'Labor' AS [Holiday]
,CAST(NULL AS int) AS [Month]
,CAST(NULL AS int) AS [dayofweek]
,CASE DATEPART(dw,TRY_CONVERT(nvarchar(4),dc.calendar_year)+'-'+'09'+'-'+'01') -- EVALUATE AS OF ...
WHEN 1 -- [SUNDAY]
THEN DATEADD(d,1,TRY_CONVERT(nvarchar(4),dc.calendar_year)+'-'+'09'+'-'+'01')
WHEN 2 -- [MONDAY]
THEN DATEADD(d,0,TRY_CONVERT(nvarchar(4),dc.calendar_year)+'-'+'09'+'-'+'01')
WHEN 3 -- [TUESDAY]
THEN DATEADD(d,6,TRY_CONVERT(nvarchar(4),dc.calendar_year)+'-'+'09'+'-'+'01')
WHEN 4 -- [WEDNESDAY]
THEN DATEADD(d,5,TRY_CONVERT(nvarchar(4),dc.calendar_year)+'-'+'09'+'-'+'01')
WHEN 5 -- [THURSDAY]
THEN DATEADD(d,4,TRY_CONVERT(nvarchar(4),dc.calendar_year)+'-'+'09'+'-'+'01')
WHEN 6 -- [FRIDAY]
THEN DATEADD(d,3,TRY_CONVERT(nvarchar(4),dc.calendar_year)+'-'+'09'+'-'+'01')
WHEN 7 -- [SATURDAY]
THEN DATEADD(d,2,TRY_CONVERT(nvarchar(4),dc.calendar_year)+'-'+'09'+'-'+'01') 
END AS [Holiday Celebrated] -- 1st Monday of September
,CAST(NULL AS nvarchar(3)) AS [DOWabbrev]
FROM INFORMATICS.dbo.date_calendarISO AS dc

UNION -- VERTICAL() STACK DISTINCT()
SELECT DISTINCT 'Columbus - Indigenous People Day' AS [Holiday]
-- SELECT DISTINCT 'Columbus Native American Day' AS [Holiday]
,CAST(NULL AS int) AS [Month]
,CAST(NULL AS int) AS [dayofweek]
,CASE DATEPART(dw,TRY_CONVERT(nvarchar(4),dc.calendar_year)+'-'+'10'+'-'+'01') -- EVALUATE AS OF ...
WHEN 1 -- [SUNDAY]
THEN DATEADD(d,8,TRY_CONVERT(nvarchar(4),dc.calendar_year)+'-'+'10'+'-'+'01')
WHEN 2 -- [MONDAY]
THEN DATEADD(d,7,TRY_CONVERT(nvarchar(4),dc.calendar_year)+'-'+'10'+'-'+'01')
WHEN 3 -- [TUESDAY]
THEN DATEADD(d,13,TRY_CONVERT(nvarchar(4),dc.calendar_year)+'-'+'10'+'-'+'01')
WHEN 4 -- [WEDNESDAY]
THEN DATEADD(d,12,TRY_CONVERT(nvarchar(4),dc.calendar_year)+'-'+'10'+'-'+'01')
WHEN 5 -- [THURSDAY]
THEN DATEADD(d,11,TRY_CONVERT(nvarchar(4),dc.calendar_year)+'-'+'10'+'-'+'01')
WHEN 6 -- [FRIDAY]
THEN DATEADD(d,10,TRY_CONVERT(nvarchar(4),dc.calendar_year)+'-'+'10'+'-'+'01')
WHEN 7 -- [SATURDAY]
THEN DATEADD(d,9,TRY_CONVERT(nvarchar(4),dc.calendar_year)+'-'+'10'+'-'+'01') 
END AS [Holiday Celebrated]  -- 2nd Monday of October
,CAST(NULL AS nvarchar(3)) AS [DOWabbrev]
FROM INFORMATICS.dbo.date_calendarISO AS dc

UNION -- VERTICAL() STACK DISTINCT()
SELECT DISTINCT 'Veterans' AS [Holiday]
,CAST(NULL AS int) AS [Month]
,CAST(NULL AS int) AS [dayofweek]
,TRY_CONVERT(nvarchar(4),dc.calendar_year)+'-'+'11'+'-'+'11' AS [Holiday Celebrated]
,CAST(NULL AS nvarchar(3)) AS [DOWabbrev]
FROM INFORMATICS.dbo.date_calendarISO AS dc

UNION -- VERTICAL() STACK DISTINCT()
SELECT DISTINCT 'Thanksgiving' AS [Holiday]
,CAST(NULL AS int) AS [Month]
,CAST(NULL AS int) AS [dayofweek]
,CASE DATEPART(dw,TRY_CONVERT(nvarchar(4),dc.calendar_year)+'-'+'11'+'-'+'01') -- EVALUATE AS OF ...
WHEN 1 -- [SUNDAY]
THEN DATEADD(d,25,TRY_CONVERT(nvarchar(4),dc.calendar_year)+'-'+'11'+'-'+'01')
WHEN 2 -- [MONDAY]
THEN DATEADD(d,24,TRY_CONVERT(nvarchar(4),dc.calendar_year)+'-'+'11'+'-'+'01')
WHEN 3 -- [TUESDAY]
THEN DATEADD(d,23,TRY_CONVERT(nvarchar(4),dc.calendar_year)+'-'+'11'+'-'+'01')
WHEN 4 -- [WEDNESDAY]
THEN DATEADD(d,22,TRY_CONVERT(nvarchar(4),dc.calendar_year)+'-'+'11'+'-'+'01')
WHEN 5 -- [THURSDAY]
THEN DATEADD(d,21,TRY_CONVERT(nvarchar(4),dc.calendar_year)+'-'+'11'+'-'+'01')
WHEN 6 -- [FRIDAY]
THEN DATEADD(d,27,TRY_CONVERT(nvarchar(4),dc.calendar_year)+'-'+'11'+'-'+'01')
WHEN 7 -- [SATURDAY]
THEN DATEADD(d,26,TRY_CONVERT(nvarchar(4),dc.calendar_year)+'-'+'11'+'-'+'01') 
END AS [Holiday Celebrated] -- 4th Thursday of November 
,CAST(NULL AS nvarchar(3)) AS [DOWabbrev]
FROM INFORMATICS.dbo.date_calendarISO AS dc

UNION -- VERTICAL() STACK DISTINCT()
SELECT DISTINCT 'Christmas' AS [Holiday]
,CAST(NULL AS int) AS [Month]
,CAST(NULL AS int) AS [dayofweek]
,TRY_CONVERT(nvarchar(4),dc.calendar_year)+'-'+'12'+'-'+'25' AS [Holiday Celebrated]
,CAST(NULL AS nvarchar(3)) AS [DOWabbrev]
FROM INFORMATICS.dbo.date_calendarISO AS dc
) -- CONCLUDE ...
AS CTE_Holiday

UPDATE #ADD_HOLIDAYs
SET [Month] = MONTH(CAST([Holiday Celebrated] AS datetime)) --,CAST(NULL AS int) AS [Month]
,[dayofweek] = DATEPART(dw,CAST([Holiday Celebrated] AS datetime)) --,CAST(NULL AS int) AS [dayofweek]
,[DOWabbrev] = SUBSTRING(LTRIM(RTRIM(DATENAME (dw,CAST([Holiday Celebrated] AS datetime)))),1,3) --,CAST(NULL AS nvarchar(3)) AS [DOWabbrev]

		/* SELECT DISTINCT ' ' AS 'DEVELOP FEDERAL HOLIDAY(S): ','UNIQUE USE OF CASE STATEMENT...' AS [MESSAGE(S)],dc.calendar_year,dc.week_of_month,dc.day_name,ah.*,fh.*
		FROM #date_calendar AS dc
			JOIN #ADD_HOLIDAYs AS ah ON TRY_CONVERT(date,dc.calendar_date) = TRY_CONVERT(date,ah.[Holiday Celebrated])
				LEFT JOIN INFORMATICS.dbo.FEDERAL_HOLIDAY AS fh ON TRY_CONVERT(date,dc.calendar_date) = TRY_CONVERT(date,fh.HOLIDAYDT) -- DEPRECATED MANUALLY MAINTAINED TABLE
		ORDER BY ah.[Holiday Celebrated] DESC */

UPDATE #date_calendar  -- RESET RESFRESH RESTART ...
SET [FEDERAL_HOLIDAYS] = TRY_CONVERT(int,NULL)
,[HOLIDAYS]  = TRY_CONVERT(int,NULL)

UPDATE #date_calendar
SET [FEDERAL_HOLIDAYS] = 1
,[HOLIDAYS] = 1
-- SELECT TOP 10 'see STEP88_FEDERAL_HOLIDAYS...sql OR see ROUTINE.sql OR URGENT.sql FROM DailyTAT' AS [MESSAGE(S)],* -- CHECK 1st
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM #date_calendar AS dc
	JOIN #ADD_HOLIDAYs AS ah ON TRY_CONVERT(date,dc.calendar_date) = TRY_CONVERT(date,ah.[Holiday Celebrated])
WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ... AND ... 
	AND [HOLIDAYS] IS NULL

UPDATE #date_calendar
SET [FEDERAL_HOLIDAYS] = 0
,[HOLIDAYS] = 0
-- SELECT TOP 10 'see STEP88_FEDERAL_HOLIDAYS...sql OR see ROUTINE.sql OR URGENT.sql FROM DailyTAT' AS [MESSAGE(S)],* -- CHECK 1st
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM #date_calendar AS dc
WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ... AND ... 
	AND [HOLIDAYS] IS NULL







-- ==========================================================	
 	-- TRUE [WORKDAY] CONSIDER HOLIDAY(S) --
-- ==========================================================
UPDATE #date_calendar
SET [WORKDAYS_minus_HOLIDAYS]  = 1
-- SELECT ' ' AS 'SHOULD BE NULL DUP Validation',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM #date_calendar AS dc
WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ... AND ... 
	AND [WORKDAYS_minus_HOLIDAYS] IS NULL
	AND [WORKDAY] = 1

UPDATE #date_calendar
SET [WORKDAYS_minus_HOLIDAYS]  = 0
-- SELECT ' ' AS 'SHOULD BE NULL DUP Validation',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM #date_calendar AS dc
WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ... AND ... 
	AND [WORKDAYS_minus_HOLIDAYS] IS NULL

UPDATE #date_calendar
SET [WORKDAYS_minus_HOLIDAYS]  = 0
-- SELECT ' ' AS 'SHOULD BE NULL DUP Validation',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM #date_calendar AS dc
WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ... AND ... 
	AND [WORKDAY] = 1
	AND [HOLIDAYS] = 1







-- ==========================================================	
 	-- PREVIOUS QUPD(s) --
-- ==========================================================
UPDATE #date_calendar
SET [PREVIOUSlast_day_in_week] = CAST([first_day_in_week]-1 AS datetime) --USE WHAT YOU KNOW()
-- SELECT TOP 1000 DATEPART(dd,CAST([calendar_date] AS datetime)),* -- CHECK 1st
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM #date_calendar

UPDATE #date_calendar
SET [PREVIOUSfirst_day_in_week] = CAST([PREVIOUSlast_day_in_week]-6 AS datetime)
-- SELECT TOP 1000 DATEPART(dd,CAST([calendar_date] AS datetime)),* -- CHECK 1st
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM #date_calendar

UPDATE #date_calendar
SET [PREVIOUSlast_day_in_month] = CAST([first_day_in_month]-1 AS datetime) --USE WHAT YOU KNOW()
-- SELECT TOP 1000 DATEPART(dd,CAST([calendar_date] AS datetime)),* -- CHECK 1st
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM #date_calendar

UPDATE #date_calendar
SET [PREVIOUSfirst_day_in_month] = CAST(CAST(DATEPART(mm,CAST([PREVIOUSlast_day_in_month]AS datetime)) AS nvarchar(2)) +'/01/'+CAST(DATEPART(yyyy,CAST([PREVIOUSlast_day_in_month] AS datetime)) AS nvarchar(4)) AS datetime)
-- SELECT TOP 1000 DATEPART(dd,CAST([calendar_date] AS datetime)),* -- CHECK 1st
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM #date_calendar







-- ==========================================================	
 	-- FIRST & LAST day in YEAR--
-- ==========================================================
UPDATE #date_calendar
SET [FIRST_day_in_year] = CAST('01/01/'+CAST(LTRIM(RTRIM(dc.calendar_year)) AS nvarchar(4)) AS datetime)
,[LAST_day_in_year] = CAST('12/31/'+CAST(LTRIM(RTRIM(dc.calendar_year)) AS nvarchar(4)) AS datetime)
-- SELECT ' ' AS 'SHOULD BE NULL DUP Validation',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM #date_calendar AS dc







-- ==========================================================	
 	-- DATE IN 'yyyymmdd' FORMAT() --
-- ==========================================================
UPDATE #date_calendar
SET [calendar_date_TEXT] = LTRIM(RTRIM(REPLACE(CAST(CAST([calendar_date] AS date) AS nvarchar(10)),'-','')))
,[first_day_in_week_TEXT] = LTRIM(RTRIM(REPLACE(CAST(CAST([first_day_in_week] AS date) AS nvarchar(10)),'-','')))
,[last_day_in_week_TEXT] = LTRIM(RTRIM(REPLACE(CAST(CAST([last_day_in_week] AS date) AS nvarchar(10)),'-','')))
,[first_day_in_month_TEXT] = LTRIM(RTRIM(REPLACE(CAST(CAST([first_day_in_month] AS date) AS nvarchar(10)),'-','')))
,[last_day_in_month_TEXT] = LTRIM(RTRIM(REPLACE(CAST(CAST([last_day_in_month] AS date) AS nvarchar(10)),'-','')))
,[first_day_in_year_TEXT] = LTRIM(RTRIM(REPLACE(CAST(CAST([first_day_in_year] AS date) AS nvarchar(10)),'-','')))
,[last_day_in_year_TEXT] = LTRIM(RTRIM(REPLACE(CAST(CAST([last_day_in_year] AS date) AS nvarchar(10)),'-','')))
,[PREVIOUSfirst_day_in_week_TEXT] = LTRIM(RTRIM(REPLACE(CAST(CAST([PREVIOUSfirst_day_in_week] AS date) AS nvarchar(10)),'-','')))
,[PREVIOUSlast_day_in_week_TEXT] = LTRIM(RTRIM(REPLACE(CAST(CAST([PREVIOUSlast_day_in_week] AS date) AS nvarchar(10)),'-','')))
,[PREVIOUSfirst_day_in_month_TEXT] = LTRIM(RTRIM(REPLACE(CAST(CAST([PREVIOUSfirst_day_in_month] AS date) AS nvarchar(10)),'-','')))
,[PREVIOUSlast_day_in_month_TEXT] = LTRIM(RTRIM(REPLACE(CAST(CAST([PREVIOUSlast_day_in_month] AS date) AS nvarchar(10)),'-','')))
-- SELECT ' ' AS 'SHOULD BE NULL DUP Validation',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM #date_calendar AS dc

	-- CHECK FOR DUP(S) --
SELECT ' ' AS 'SHOULD BE NULL DUP Validation',*
-- DELETE
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st',
FROM #date_calendar
WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ... AND ...
	AND [calendar_date] IN
	( -- INITIATE ...
	SELECT [calendar_date]
	-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
	-- SELECT DISTINCT ' ' AS 'CHECK 1st',
	FROM #date_calendar AS dup
	GROUP BY [calendar_date] -- Duplication Driver 
	HAVING COUNT(1)>1 -- HAVING clause RESERVED for AGGREGATE(s) ... HAVING SUM(PAID_NET_AMT) != 0
	) -- CONCLUDE ...

		SELECT' ' AS 'RAW CALENDAR AS IS'
		,[WORKDAY]
		,[HOLIDAYS]
		,[WORKDAYS_minus_HOLIDAYS],* 
		FROM #date_calendar
		WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ... AND ...
			-- AND [HOLIDAYS] = 1

		SELECT ' ' AS [CALENDAR RANGE],COUNT(1) AS [RECORDS],MIN(calendar_date) AS MINdt,MAX(calendar_date) AS MAXdt 
		FROM #date_calendar
