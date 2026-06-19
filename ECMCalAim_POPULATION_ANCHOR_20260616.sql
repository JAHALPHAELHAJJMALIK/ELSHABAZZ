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
DECLARE @ClockStartECM AS datetime
DECLARE @ClockStopECM AS datetime
DECLARE @IPPdtECM AS datetime
DECLARE @ClockStartCostCategory AS datetime
DECLARE @ClockStopCostCategory AS datetime

SET @CEClockStart = TRY_CONVERT(date,'01/01/2021')
SET @CEClockStop = TRY_CONVERT(date,'12/31/2021')
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

		SELECT * 
		FROM INFORMATICS.dbo.date_calendarCE AS dc -- 40 YEAR CALENDAR 1st OF THE MONTH ONLY!!!
		WHERE 1=1
			AND dc.calendar_date BETWEEN @CEClockStart AND @CEClockStop -- SET REPORTING PERIOD LOCK AND ...
			AND dc.calendar_day = @isoday -- CALENDAR DAY ISO ... / EFFECTIVE AS OF WHICH DAY IN GIVEN MONTH?	

		SELECT *
		FROM INFORMATICS.dbo.date_calendarISO AS dc
		WHERE 1=1
			AND dc.calendar_date BETWEEN @CEClockStart AND @CEClockStop -- SET REPORTING PERIOD LOCK AND ...
			AND dc.calendar_day = @isoday -- CALENDAR DAY ISO ... / EFFECTIVE AS OF WHICH DAY IN GIVEN MONTH?

		SELECT *
		FROM INFORMATICS.dbo.date_calendarISO AS dc
		WHERE 1=1
			AND dc.calendar_date BETWEEN @CEClockStart AND @CEClockStop -- SET REPORTING PERIOD LOCK AND ...
			AND dc.calendar_date = dc.first_day_in_month -- CALENDAR DAY ISO ... / EFFECTIVE AS OF WHICH DAY IN GIVEN MONTH? ... dc.@ClockStop = @isoday

		SELECT *
		FROM INFORMATICS.dbo.date_calendarISO AS dc
		WHERE 1=1
			AND TRY_CONVERT(date,dc.calendar_date) BETWEEN @CEClockStart AND @CEClockStop -- SET REPORTING PERIOD LOCK AND ...
			AND dc.calendar_date = dc.last_day_in_month -- CALENDAR DAY ISO ... / EFFECTIVE AS OF WHICH DAY IN GIVEN MONTH? ... dc.@ClockStop = @isoday
			AND TRY_CONVERT(date,ISNULL(es.termdate,@CEClockStop)) >= TRY_CONVERT(date,dc.calendar_date) -- WITHIN reporting period [RANGE] OPPOSITION 
			AND TRY_CONVERT(date,es.effdate) <= TRY_CONVERT(date,dc.calendar_date) -- WITHIN reporting period [RANGE] OPPOSITION 
			AND TRY_CONVERT(date,ISNULL(es.termdate,@CEClockStop)) > TRY_CONVERT(date,es.effdate) -- MUST BE TRUE ... NON-CROSSFOOTED RECORDS ARE ACTIVE ...
