-- ==========================================================	
	-- CHECKLIST - PIVOT() v. UNPIVOT() IN SSMS --
-- ==========================================================
JAH CHARINDEX() FIND() SEARCH() 'CREATE MS EXCEL CALCULATED FIELD',STATIC v DYNAMIC PIVOT() AKIN TO THE WHERE 1=1 CLAUSE ... PIVOT() OPERATOR, 'EFFECTUATE PRE - PIVOT() OPTIMIZATION'

SELECT [CLAIMS PER MONTH]
LOB,
ISNULL([0-30],0) AS '0-30',
ISNULL([31-60],0) AS '31-60',
ISNULL([61-90],0) AS '61-90',
ISNULL([90+],0) AS '90+'
FROM -- EFFECTUATE PRE - PIVOT() OPTIMIZATION
( -- INITIATE ...
SELECT @month1 AS 'CLAIMS PER MONTH',
CASE
WHEN DATEDIFF("d",c.cleandate,@month1) <= 30 THEN '0-30'
WHEN DATEDIFF("d",c.cleandate,@month1) <= 60 THEN '31-60'
WHEN DATEDIFF("d",c.cleandate,@month1) <= 90 THEN '61-90'
ELSE '90+' END AS 'AGE_BUCKET',
COUNT(DISTINCT(c.claimid)) AS 'CLAIMS',
bp.[PLAN] AS 'LOB'
FROM HMOPROD_PLANDATA.dbo.claim AS c (NOLOCK)
	JOIN HMOPROD_PLANDATA.dbo.claimdetail AS cd (NOLOCK) ON c.claimid = cd.claimid
	JOIN INFORMATICS.dbo.[uvw_LINE_OF_BUSINESS] AS bp (NOLOCK) ON c.planid = bp.planid
WHERE 1=1
	AND c.status IN ('PAID','REVERSED')
	AND c.claimid NOT LIKE '%A%'
	AND c.claimid NOT LIKE '%R%'
	AND c.totalpaid <> 0 -- ✅ Filters out claims with totalpaid = 0	
	AND c.cleandate <= @month1 -- ✅ Only counts claims where receipt date (cleandate) is before the month end
	AND c.paiddate >= @month1 + 1 -- ✅ Only counts claims where paid date is after the month end
	AND c.paiddate <= eomonth(@month1,4) -- ✅ Only counts claims paid within the runout period (4 months after month end)
	AND c.paiddate <= @PaidThrough --  ✅ Only counts claims paid within the execution date
GROUP BY CASE
WHEN DATEDIFF("d",c.cleandate,@month1) <= 30 THEN '0-30'
WHEN DATEDIFF("d",c.cleandate,@month1) <= 60 THEN '31-60'
WHEN DATEDIFF("d",c.cleandate,@month1) <= 90 THEN '61-90'
ELSE '90+' END,
bp.[PLAN]
) -- CONCLUDE...
AS SourceTable
PIVOT
(SUM(SourceTable.CLAIMS) -- ✅ Aggregates claim counts by age bucket using PIVOT()
FOR SourceTable.AGE_BUCKET IN ([0-30],[31-60],[61-90],[90+])
) AS PivotTable

SELECT [PAID PER MONTH]
LOB,
ISNULL([0-30],0) AS '0-30',
ISNULL([31-60],0) AS '31-60',
ISNULL([61-90],0) AS '61-90',
ISNULL([90+],0) AS '90+'
FROM -- EFFECTUATE PRE - PIVOT() OPTIMIZATION
( -- INITIATE ...
SELECT @month1 AS 'PAID PER MONTH',
CASE
WHEN DATEDIFF("d",c.cleandate,@month1) <= 30 THEN '0-30'
WHEN DATEDIFF("d",c.cleandate,@month1) <= 60 THEN '31-60'
WHEN DATEDIFF("d",c.cleandate,@month1) <= 90 THEN '61-90'
ELSE '90+' END AS 'AGE_BUCKET',
SUM(cd.amountpaid) AS 'PAID AMOUNT',
bp.[PLAN] AS 'LOB'
FROM HMOPROD_PLANDATA.dbo.claim AS c (NOLOCK)
	JOIN HMOPROD_PLANDATA.dbo.claimdetail AS cd (NOLOCK) ON c.claimid = cd.claimid
	JOIN INFORMATICS.dbo.[uvw_LINE_OF_BUSINESS] AS bp (NOLOCK) ON c.planid = bp.planid
WHERE 1=1
	AND c.status IN ('PAID','REVERSED')
	AND c.claimid NOT LIKE '%A%'
	AND c.claimid NOT LIKE '%R%'
	AND c.totalpaid <> 0 -- ✅ Filters out claims with totalpaid = 0	
	AND c.cleandate <= @month1 -- ✅ Only counts claims where receipt date (cleandate) is before the month end
	AND c.paiddate >= @month1 + 1 -- ✅ Only counts claims where paid date is after the month end
	AND c.paiddate <= eomonth(@month1,4) -- ✅ Only counts claims paid within the runout period (4 months after month end)
	AND c.paiddate <= @PaidThrough --  ✅ Only counts claims paid within the execution date
GROUP BY CASE
WHEN DATEDIFF("d",c.cleandate,@month1) <= 30 THEN '0-30'
WHEN DATEDIFF("d",c.cleandate,@month1) <= 60 THEN '31-60'
WHEN DATEDIFF("d",c.cleandate,@month1) <= 90 THEN '61-90'
ELSE '90+' END,
bp.[PLAN]
) -- CONCLUDE...
AS SourceTable
PIVOT
(SUM(SourceTable.[PAID AMOUNT]) -- ✅ Aggregates totalpaid like ORIGINAL by age bucket using PIVOT()
FOR SourceTable.AGE_BUCKET IN ([0-30],[31-60],[61-90],[90+])
) AS PivotTable

x MS ACCESS QXTB COMPONENT(s)
		TRANSFORM defines the VAL() 
		SELECT defines the ROW(s)
		PIVOT defines the COLUMN - COL()

		USE https://duckduckgo.com/?q=create+pivot+table+field&ia=web
		USE https://www.got-it.ai/solutions/excel-chat/excel-tutorial/pivot-table/how-to-create-calculated-fields-in-pivot-table - 'How to Create Calculated Fields in a Pivot Table'
		USE [URL]: https://www.databasejournal.com/features/mssql/CONVERTing-rows-to-columns-pivot-and-columns-to-rows-unpivot-in-sql-server.html
		USE [URL]: https://www.mssqltips.com/sqlservertip/1019/crosstab-queries-using-pivot-in-sql-server-2005/
		USE [URL]: https://www.c-sharpcorner.com/UploadFile/rohatash/differences-between-ISNULL-and-coalesce-functions-in-sql/
		USE [URL]: https://www.mssqltips.com/sqlservertip/1521/the-many-uses-of-coalesce-in-sql-server/
		USE [URL]: https://www.sqlservercentral.com/blogs/sql_server_dba/2011/11/15/quotename-in-sql/
		USE [URL]: https://www.dotnetheaven.com/article/using-quotename-function-in-sql-2008
		USE [URL]: https://www.c-sharpcorner.com/Blogs/7515/quotename-function-in-sql-server.aspx
		
-- ==================================================
	-- PIVOT() MANUAL --
-- ==================================================
SELECT (SELECT CAST(CAST(@START AS date) AS nvarchar(10))+' THROUGH '+CAST(CAST(@END AS date) AS nvarchar(10))) AS [MA DOS RANGE]
,(SELECT COUNT(1) FROM INFORMATICS.dbo.MOSS_ADAMS_AUDIT AS su) AS [MA RECORD(s)]
,(SELECT SUM(su.SumOfBILLED_AMT) FROM INFORMATICS.dbo.MOSS_ADAMS_AUDIT AS su) AS [MA BILLED]
,(SELECT SUM(su.SumOfPAID_NET_AMT) AS Cost FROM INFORMATICS.dbo.MOSS_ADAMS_AUDIT AS su) AS [MA COST(s)]

SELECT '[Cx] SUMMARY WC' AS [NOTE(s)],su.Cx,SUM(su.PAID_NET_AMT) AS [CostWC],ar.Cost AS [CostAR]
FROM INFORMATICS2.dbo.[SHELLunion00_HCT] AS su
	JOIN (SELECT '[Cx] SUMMARY AR' AS [NOTE(s)],cost_category,SUM(paid) AS Cost FROM #ARHCT WHERE member_month BETWEEN @STARTDATE AND @ENDDATE GROUP BY cost_category) AS ar ON ar.cost_category = su.Cx
GROUP BY su.Cx,ar.Cost
ORDER BY su.Cx,ar.Cost







-- ==================================================
	-- ENSURE ALL PIVOT() COLUMNS EXIST --
-- ==================================================
-----------------------------------------------------------------------------------------------------------------------------
	--Error Trapping: Check If Permanent Table(s) Already Exist(s) AND Drop If Applicable--
-----------------------------------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS #URGENTPIVOT_VAL -- SQL Server 2016 AND later -- DYNAMIC tmp OR STATIC [TABLE] ##BHTATAGINGURGENT is a local temporary table visible only in the current session; ##BHTATAGINGURGENT is a GLOBAL temporary table visible to all sessions IN ('TempDB')

	-- CTE TO ENSURE all possible PIVOT values EXIST:
;WITH AllTATAssessments AS 
( -- INITIATE ... 
SELECT ' Within 24 Hours' AS [Assessment ]

UNION 
SELECT ' Within 48 Hours' AS [Assessment ]

UNION 
SELECT ' Within 72 Hours' AS [Assessment ]

UNION 
SELECT 'Over 72 Hours' AS [Assessment ]
) -- CONCLUDE ...
 
SELECT DISTINCT ISNULL(LOB,'Medi-Cal') AS LINE_OF_BUSINESS
,ata.Assessment AS [TAT Assessment]
,ISNULL(bts.[Average Auth Days (ROUTINE) Hours (URGENT)],0) AS [Average Auth Days (ROUTINE) Hours (URGENT)]
,ISNULL(CAST(SUM(bts.[AuthRef count]) AS int),0) AS [VAL]
INTO #URGENTPIVOT_VAL
-- SELECT TOP 10 CAST(NULL AS nvarchar(255)) AS [SPACING],* -- CHECK 1st
-- SELECT DISTINCT -- CHECK 1st
FROM AllTATAssessments AS ata  -- C001: ENSURE ALL PIVOT() COLUMNS EXIST
	LEFT JOIN INFORMATICS.dbo.BHTTATSummary AS bts ON ata.Assessment = bts.[TAT Assessment] 
		AND Acuity LIKE '%URGE%'
		AND LOB LIKE '%Medi%'
GROUP BY LOB,ata.Assessment,[Average Auth Days (ROUTINE) Hours (URGENT)]

		SELECT ' ' AS 'ENSURE ALL PIVOT() COLUMNS EXIST',* FROM #URGENTPIVOT_VAL







-- =====================================================================
	-- PIVOT() STATIC MM --
-- =====================================================================
;WITH staticmm AS 
( -- INITIATE ...
SELECT ' ' AS 'PIVOT [Unique Member Count]',[LOB],[MM_YEAR],ISNULL([01],0) AS [JAN],ISNULL([02],0) AS [FEB],ISNULL([03],0) AS [MAR],ISNULL([04],0) AS [APR],ISNULL([05],0) AS [MAY],ISNULL([06],0) AS [JUN],ISNULL([07],0) AS [JUL],ISNULL([08],0) AS [AUG],ISNULL([09],0) AS [SEP],ISNULL([10],0) AS [OCT],ISNULL([11],0) AS [NOV],ISNULL([12],0) AS [DEC]
FROM 
( -- INITIATE ...
SELECT mm.LINE_OF_BUSINESS AS [LOB],DATEPART(yyyy,mm.[RUNDT]) AS [MM_YEAR],DATEPART(mm,mm.[RUNDT]) AS [MM_MTH]
,COUNT(DISTINCT(mm.memid)) AS [Unique Member Count]
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st',MTH
FROM INFOAG.INFORMATICS.dbo.EMPLOYEEGROUP_members AS mm (NOLOCK)
GROUP BY mm.LINE_OF_BUSINESS,DATEPART(yyyy,mm.[RUNDT]),DATEPART(mm,mm.[RUNDT]) 
) -- CONCLUDE
 AS util
PIVOT 
( -- INITIATE ...
MAX(util.[Unique Member Count])
FOR util.[MM_MTH] IN ([01],[02],[03],[04],[05],[06],[07],[08],[09],[10],[11],[12])
) -- CONCLUDE ...
AS dxpivot
) -- CONCLUDE ...

		SELECT mm.*,gt.[Total MM]
		FROM staticmm AS mm
			LEFT JOIN 
			( -- INTIATE ...
			SELECT [LOB],[MM_YEAR]
			,SUM([JAN]+[FEB]+[MAR]+[APR]+[MAY]+[JUN]+[JUL]+[AUG]+[SEP]+[OCT]+[NOV]+[DEC]) AS [Total MM]
			FROM staticmm
			GROUP BY [LOB],[MM_YEAR]
			) -- CONCLUDE ...
				AS gt ON mm.[LOB] = gt.[LOB]
				AND mm.[MM_YEAR] = gt.[MM_YEAR]
				






-- =====================================================================
	-- PIVOT() DIAG --
-- =====================================================================
SELECT ' ' AS 'PIVOT Dx',referralid
,[1],[2],[3],[4],[5],[6],[7],[8],[9],[10],[11],[12],[13],[14],[15],[16],[17],[18],[19],[20],[21],[22],[23],[24],[25],[26],[27],[28],[29],[30],[31],[32],[33],[34],[35],[36],[37],[38],[39],[40],[41],[42],[43],[44],[45]
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'	
FROM 
( -- INITIATE ...
SELECT dx.referralid,dx.diagcode,dx.sequence
-- ,dx.poa AS [PRESENT ON ADMISSION],dc.description AS [DIAG DESCR]
FROM HMOPROD_PLANDATA.dbo.authdiag AS dx
	-- LEFT JOIN HMOPROD_PLANDATA.dbo.DiagCode AS dc ON dx.diagcode = dc.codeid
WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ...
	AND dx. referralid IN ('4916189') -- SAMPLE: MAX() MULTI DIAG AUTH
) -- CONCLUDE
 AS diag
PIVOT 
( -- INITIATE ...
MAX(diag.diagcode)
FOR diag.sequence IN ([1],[2],[3],[4],[5],[6],[7],[8],[9],[10],[11],[12],[13],[14],[15],[16],[17],[18],[19],[20],[21],[22],[23],[24],[25],[26],[27],[28],[29],[30],[31],[32],[33],[34],[35],[36],[37],[38],[39],[40],[41],[42],[43],[44],[45])
) -- CONCLUDE ...
AS dxpivot
WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ...

SELECT ' ' AS 'PIVOT Dx DESCR.',referralid
,[1],[2],[3],[4],[5],[6],[7],[8],[9],[10],[11],[12],[13],[14],[15],[16],[17],[18],[19],[20],[21],[22],[23],[24],[25],[26],[27],[28],[29],[30],[31],[32],[33],[34],[35],[36],[37],[38],[39],[40],[41],[42],[43],[44],[45]
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'	
FROM 
( -- INITIATE ...
SELECT dx.referralid,dx.sequence,dc.description
-- ,dx.poa AS [PRESENT ON ADMISSION],dc.description AS [DIAG DESCR]
FROM HMOPROD_PLANDATA.dbo.authdiag AS dx
	LEFT JOIN HMOPROD_PLANDATA.dbo.DiagCode AS dc ON dx.diagcode = dc.codeid
WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ...
	AND dx. referralid IN ('4916189') -- SAMPLE: MAX() MULTI DIAG AUTH
) -- CONCLUDE
 AS diag
PIVOT 
( -- INITIATE ...
MAX(diag.description)
FOR diag.sequence IN ([1],[2],[3],[4],[5],[6],[7],[8],[9],[10],[11],[12],[13],[14],[15],[16],[17],[18],[19],[20],[21],[22],[23],[24],[25],[26],[27],[28],[29],[30],[31],[32],[33],[34],[35],[36],[37],[38],[39],[40],[41],[42],[43],[44],[45])
) -- CONCLUDE ...
AS dxpivot
WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ...

		SELECT DISTINCT ' ' AS 'SAMPLE: MAX() MULTI DIAG AUTH',dx.referralid,dx.sequence,dx.diagcode,dc.description
		-- SELECT DISTINCT ' ' AS 'CHECK 1st',dx.referralid
		-- SELECT ' ' AS 'CHECK FOR MAX()',MAX(dx.sequence)
		FROM HMOPROD_PLANDATA.dbo.authdiag AS dx
				LEFT JOIN HMOPROD_PLANDATA.dbo.DiagCode AS dc ON dx.diagcode = dc.codeid
		WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ...
			-- AND sequence = 75
			AND dx. referralid IN ('4916189') -- SAMPLE: MAX() MULTI DIAG AUTH







SELECT ' ' AS 'PIVOT Dx',claimid
,[1],[2],[3],[4],[5],[6],[7],[8],[9],[10],[11],[12],[13],[14],[15],[16],[17],[18],[19],[20],[21],[22],[23],[24],[25],[26],[27],[28],[29],[30],[31],[32],[33],[34],[35],[36],[37],[38],[39],[40],[41],[42],[43],[44],[45]
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'	
FROM 
( -- INITIATE ...
SELECT dx.claimid,dx.codeid,dx.sequence
-- ,dx.poa AS [PRESENT ON ADMISSION],dc.description AS [DIAG DESCR]
FROM HMOPROD_PLANDATA.dbo.claimdiag AS dx
	-- LEFT JOIN HMOPROD_PLANDATA.dbo.DiagCode AS dc ON dx.codeid = dc.codeid
WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ...
	AND dx. claimid IN ('13339000006','14031500056') -- SAMPLE: MAX() MULTI DIAG CLAIM
) -- CONCLUDE
 AS diag
PIVOT 
( -- INITIATE ...
MAX(diag.codeid)
FOR diag.sequence IN ([1],[2],[3],[4],[5],[6],[7],[8],[9],[10],[11],[12],[13],[14],[15],[16],[17],[18],[19],[20],[21],[22],[23],[24],[25],[26],[27],[28],[29],[30],[31],[32],[33],[34],[35],[36],[37],[38],[39],[40],[41],[42],[43],[44],[45])
) -- CONCLUDE ...
AS dxpivot
WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ...

SELECT ' ' AS 'PIVOT Dx DESCR.',claimid
,[1],[2],[3],[4],[5],[6],[7],[8],[9],[10],[11],[12],[13],[14],[15],[16],[17],[18],[19],[20],[21],[22],[23],[24],[25],[26],[27],[28],[29],[30],[31],[32],[33],[34],[35],[36],[37],[38],[39],[40],[41],[42],[43],[44],[45]
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'	
FROM 
( -- INITIATE ...
SELECT dx.claimid,dx.sequence,dc.description
-- ,dx.poa AS [PRESENT ON ADMISSION],dc.description AS [DIAG DESCR]
FROM HMOPROD_PLANDATA.dbo.claimdiag AS dx
	LEFT JOIN HMOPROD_PLANDATA.dbo.DiagCode AS dc ON dx.codeid = dc.codeid
WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ...
	AND dx. claimid IN ('13339000006','14031500056') -- SAMPLE: MAX() MULTI DIAG CLAIM
) -- CONCLUDE
 AS diag
PIVOT 
( -- INITIATE ...
MAX(diag.description)
FOR diag.sequence IN ([1],[2],[3],[4],[5],[6],[7],[8],[9],[10],[11],[12],[13],[14],[15],[16],[17],[18],[19],[20],[21],[22],[23],[24],[25],[26],[27],[28],[29],[30],[31],[32],[33],[34],[35],[36],[37],[38],[39],[40],[41],[42],[43],[44],[45])
) -- CONCLUDE ...
AS dxpivot
WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ...

		SELECT DISTINCT ' ' AS 'SAMPLE: MAX() MULTI DIAG CLAIM'
		,dx.claimid
		,dx.sequence
		,dx.codeid
		,dc.description
		FROM HMOPROD_PLANDATA.dbo.claimdiag AS dx
				LEFT JOIN HMOPROD_PLANDATA.dbo.DiagCode AS dc ON dx.codeid = dc.codeid
		WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ...
			-- AND sequence = 52
			AND dx. claimid IN ('13339000006','14031500056') -- SAMPLE: MAX() MULTI DIAG CLAIM







-- =====================================================================
	-- PIVOT() UTIL SAMPLE PAID + UNIT(S)
-- =====================================================================
SELECT ' ' AS 'GRAND TOTAL PIVOT()',t.YEAR_DOS
,t.PAYTO AS [PayTo ProviderID],t.PAYTONM AS [PayTo Provider]
,t.provid AS [Rendering ProviderID],t.PROVNM AS [Rendering Provider]
,SUM(t.PAID_NET_AMT) AS [Paid]
,COUNT(DISTINCT(t.AdmitID)) AS [AdmitVisit]
,COUNT(DISTINCT(t.QUANTITY)) AS [Unit] -- MS ALLYSON Adj. Unit(s)
INTO #gt
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st',MTH_DOS
FROM TABLENAME AS t
GROUP BY t.YEAR_DOS,t.PAYTO,t.PAYTONM,t.provid,t.PROVNM

		SELECT * FROM #gt

SELECT ' ' AS 'PIVOT [Paid]'
,YEAR_DOS
,[PayTo ProviderID]
,[PayTo Provider]
,[Rendering ProviderID]
,[Rendering Provider]
,ISNULL([01],0) AS [JAN],ISNULL([02],0) AS [FEB],ISNULL([03],0) AS [MAR],ISNULL([04],0) AS [APR],ISNULL([05],0) AS [MAY],ISNULL([06],0) AS [JUN],ISNULL([07],0) AS [JUL],ISNULL([08],0) AS [AUG],ISNULL([09],0) AS [SEP],ISNULL([10],0) AS [OCT],ISNULL([11],0) AS [NOV],ISNULL([12],0) AS [DEC]
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'	
FROM 
( -- INITIATE ...
SELECT t.PAYTO AS [PayTo ProviderID]
,t.PAYTONM AS [PayTo Provider]
,t.provid AS [Rendering ProviderID]
,t.PROVNM AS [Rendering Provider]
,t.YEAR_DOS,t.MTH_DOS
,SUM(t.PAID_NET_AMT) AS [Paid]
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

SELECT ' ' AS 'PIVOT [AdmitVisit]'
,YEAR_DOS
,[PayTo ProviderID]
,[PayTo Provider]
,[Rendering ProviderID]
,[Rendering Provider]
,ISNULL([01],0) AS [JAN],ISNULL([02],0) AS [FEB],ISNULL([03],0) AS [MAR],ISNULL([04],0) AS [APR],ISNULL([05],0) AS [MAY],ISNULL([06],0) AS [JUN],ISNULL([07],0) AS [JUL],ISNULL([08],0) AS [AUG],ISNULL([09],0) AS [SEP],ISNULL([10],0) AS [OCT],ISNULL([11],0) AS [NOV],ISNULL([12],0) AS [DEC]
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'	
FROM 
( -- INITIATE ...
SELECT t.PAYTO AS [PayTo ProviderID]
,t.PAYTONM AS [PayTo Provider]
,t.provid AS [Rendering ProviderID]
,t.PROVNM AS [Rendering Provider]
,t.YEAR_DOS,t.MTH_DOS
,COUNT(DISTINCT(t.AdmitID)) AS [AdmitVisit]
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

SELECT ' ' AS 'PIVOT [Unit(s)]'
,YEAR_DOS
,[PayTo ProviderID]
,[PayTo Provider]
,[Rendering ProviderID]
,[Rendering Provider]
,ISNULL([01],0) AS [JAN],ISNULL([02],0) AS [FEB],ISNULL([03],0) AS [MAR],ISNULL([04],0) AS [APR],ISNULL([05],0) AS [MAY],ISNULL([06],0) AS [JUN],ISNULL([07],0) AS [JUL],ISNULL([08],0) AS [AUG],ISNULL([09],0) AS [SEP],ISNULL([10],0) AS [OCT],ISNULL([11],0) AS [NOV],ISNULL([12],0) AS [DEC]
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'	
FROM 
( -- INITIATE ...
SELECT t.PAYTO AS [PayTo ProviderID]
,t.PAYTONM AS [PayTo Provider]
,t.provid AS [Rendering ProviderID]
,t.PROVNM AS [Rendering Provider]
,t.YEAR_DOS,t.MTH_DOS
,SUM(t.QUANTITY) AS [Unit] -- MS ALLYSON Adj. Unit(s)
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







-- ========================================================================
	-- PIVOT() DYNAMIC: ??? -- 
-- ========================================================================
-----------------------------------------------------------------------------------------------------------------------------
	--Error Trapping: Check If Permanent Table(s) Already Exist(s) And Drop If Applicable--
-----------------------------------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS #PIVOT_YTD_UPDATE -- SQL Server 2016 and later -- DYNAMIC tmp OR STATIC [TABLE] ###SLANG is a local temporary table visible only in the current session; ###SLANG is a GLOBAL temporary table visible to all sessions IN ('TempDB')
 
SELECT LINE_OF_BUSINESS
,COUNT(DISTINCT(memid)) AS [VAL]
INTO #PIVOT_YTD_UPDATE
FROM INFORMATICS.dbo.DMHC_HP_DEMO
GROUP BY [LINE_OF_BUSINESS]

		-- SELECT * FROM #PIVOT_YTD_UPDATE 

-----------------------------------------------------------------------------------------------------------------------------
	--Error Trapping: Check If Permanent Table(s) Already Exist(s) And Drop If Applicable--
-----------------------------------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS #PIVOT_VAL -- SQL Server 2016 and later -- DYNAMIC tmp OR STATIC [TABLE] ###SLANG is a local temporary table visible only in the current session; ###SLANG is a GLOBAL temporary table visible to all sessions IN ('TempDB')
 
SELECT LINE_OF_BUSINESS,ROLLUP_SPOKEN_LANGUAGE
,COUNT(DISTINCT(memid)) AS [VAL]
INTO #PIVOT_VAL
FROM INFORMATICS.dbo.DMHC_HP_DEMO
GROUP BY LINE_OF_BUSINESS,ROLLUP_SPOKEN_LANGUAGE

		-- SELECT * FROM #PIVOT_VAL

/* COALESCE() - ROW(s) INTO A SINGULAR STRING / COL(column); 3rd person present: coalesces; past tense: coalesced; past participle: coalesced; gerund or present participle: coalescing

								come together and form one mass or whole.
								"the puddles had coalesced into shallow streams"
								synonyms:	merge, unite, join together, combine, fuse, mingle, blend; amalgamate, consolidate, integrate, homogenize, converge
								"the puddles had coalesced into shallow streams"
								combine (elements) in a mass or whole.
								"to help coalesce the community, they established an office" */

		-- STEP 01: DECLARE necessary variables
DECLARE @SQLQuery AS nvarchar (MAX)
DECLARE @PivotColumns AS nvarchar (MAX)
 
		-- STEP02: SET / Get unique values of pivot column  
SELECT @PivotColumns = COALESCE(@PivotColumns + ',','')+ QUOTENAME(ROLLUP_SPOKEN_LANGUAGE) --[] is the DEFAULT VAL() COALESCE() - ROW(s) INTO A SINGULAR STRING / COL(column)
FROM (SELECT DISTINCT ROLLUP_SPOKEN_LANGUAGE FROM #PIVOT_VAL) AS PivotCOLnames ORDER BY ROLLUP_SPOKEN_LANGUAGE ASC --SET PIVOT COL(s) HEADER(s) aka 'FOR'
 
		-- SELECT @PivotColumns AS COLnames --SET PIVOT COL(s) HEADER(s) aka 'FOR'
 
-----------------------------------------------------------------------------------------------------------------------------
	--Error Trapping: Check If Permanent Table(s) Already Exist(s) And Drop If Applicable--
-----------------------------------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS ##SLANG -- SQL Server 2016 and later -- DYNAMIC tmp OR STATIC [TABLE] ###SLANG is a local temporary table visible only in the current session; ###SLANG is a GLOBAL temporary table visible to all sessions IN ('TempDB')

		-- STEP03: Create the dynamic query with all the values for 
--pivot column at runtime
SET @SQLQuery = 'SELECT LINE_OF_BUSINESS'  --ROW(s)
    +','+@PivotColumns --SET PIVOT COL(s) HEADER(s) aka 'FOR'
	+' ,TRY_CONVERT(decimal(9,0),NULL) AS [YTD]'
    +' INTO ##SLANG '
    +' FROM #PIVOT_VAL'
    +' PIVOT'
	+'('
	+'AVG([VAL])' -- SET PIVOT VAL()
	+' FOR ROLLUP_SPOKEN_LANGUAGE IN ('+@PivotColumns+')'
	+')'
	+' AS P --SET PIVOT COL(s) HEADER(s) aka'
    +' ORDER BY LINE_OF_BUSINESS'
 
		-- SELECT @SQLQuery AS [COPY & PASTE TO EXEC; MANUALLY]
		EXEC sp_executesql @SQLQuery

UPDATE ##SLANG
SET [YTD] = ytd.[VAL]
FROM ##SLANG AS ql
	JOIN #PIVOT_YTD_UPDATE AS ytd ON ytd.LINE_OF_BUSINESS = ql.LINE_OF_BUSINESS

		SELECT ' ' AS 'DMHC HP DEMO: ',* FROM ##SLANG ORDER BY LINE_OF_BUSINESS







-- =============================================================
	-- MANUAL PIVOT CalAIM IPP (Incentive Payment Program) --
-- =============================================================
SELECT (SELECT COUNT(DISTINCT(n.[memid])) AS [NUMERATOR]-- (D48) Numerator: Count of ECM-eligible members ages 21 and older who have a follow-up visit with a mental health provider within 30 days after discharge 
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM INFORMATICS.dbo.IPP3_48 AS n
	JOIN 
	( -- INITIATE ...
	SELECT c.memid,c.claimid,c.startdate,a.affiliateid,cd.dosfrom
	,CAST(UPPER(LTRIM(RTRIM(ISNULL(c.memid,'')))) AS varchar(255))+CAST(UPPER(LTRIM(RTRIM(ISNULL(TRY_CONVERT(date,c.startdate),'')))) AS varchar(10)) AS [Alt AdmitID] -- 'Unique person, date of service, and provider = one visit'  OR 'Unique person, date of service, and NDC = one script'
	-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
	-- SELECT DISTINCT ' ' AS 'CHECK 1st',
	FROM HMOPROD_PlanData.dbo.claim AS c (NOLOCK)
		JOIN HMOPROD_PlanData.dbo.claimdetail AS cd (NOLOCK) ON c.claimid = cd.claimid  
		JOIN HMOPROD_PlanData.dbo.affiliation AS a (NOLOCK) ON c.affiliationid = a.affiliationid 
	) -- CONCLUDE ...
	AS fu ON n.memid = fu.memid
WHERE n.MEMBER_TRUE_CHRONOLOGICAL_AGE >= 21
	AND fu.startdate BETWEEN DATEADD(day,1,n.DOS) AND DATEADD(day,31,n.DOS)
	AND fu.claimid NOT IN -- NO NOT NEGATIVE <> != ... ENSURE WE ARE NOT COUNTING THE DISCHARGE CLAIM ITSELF
	( -- INITIATE ...
	SELECT DISTINCT claimid 
	-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
	-- SELECT DISTINCT ' ' AS 'CHECK 1st',
	FROM #IPClaims
	) -- CONCLUDE ...
	) AS [NUMERATOR]
,COUNT(DISTINCT(d.AdmitID)) AS [DENOMINATOR] -- (E48) Denominator: Count of acute inpatient discharges with a principal diagnosis of mental illness or intentional self-harm ON the discharge claim during the measurement period among members ages 21 and older who are eligible for ECM
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM INFORMATICS.dbo.IPP3_48 AS d
WHERE d.MEMBER_TRUE_CHRONOLOGICAL_AGE >= 21

		-- SELECT DOS,DATEADD(day,-1,su.DOS) AS [1 DAY PRIOR], DATEADD(day,31,su.DOS) AS [31 DAYS OUT] FROM INFORMATICS.dbo.IPP3_48 AS su
		-- SELECT TOP 10 * FROM INFORMATICS.dbo.IPP3_48
		-- SELECT DISTINCT MTH_DOS FROM INFORMATICS.dbo.IPP3_48







-- ========================================================================
	-- MANUAL PIVOT() by TIER(S) --
-- ========================================================================
--------------------------------------------------------------------------------------------------------------------
	-- Error Trapping: Check If Permanent Table(s) Already Exist(s) And Drop If Applicable --
--------------------------------------------------------------------------------------------------------------------
-- if object_id ('INFORMATICS.dbo.MedImpactRxCSNPCHGALL ') is not null drop table INFORMATICS.dbo.MedImpactRxCSNPCHGALL;
DROP TABLE IF EXISTS INFORMATICS.dbo.CSNP_MEMBER_TIER_ASSESSMENT -- SQL Server 2016 and later -- DYNAMIC tmp OR STATIC [TABLE] #INFORMATICS.dbo.REINSURANCE_IP is a local temporary table visible only in the current session; ##INFORMATICS.dbo.REINSURANCE_IP is a GLOBAL temporary table visible to all sessions IN ('TempDB')

SELECT mpivot.*,TRY_CONVERT(varchar(255),mpivot.[Tier1]+mpivot.[Tier2]+mpivot.[Tier3]+mpivot.[Tier4]+mpivot.[Tier5]+mpivot.[Tier6]) AS [Total Tier(s)]
INTO INFORMATICS.dbo.CSNP_MEMBER_TIER_ASSESSMENT
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM 
( -- INITIATE ...
SELECT DISTINCT 'per Subject: "CSNP Drug Tier Utilization Projections Review of Results" DISCUSSION ON Thursday, September 14, 2023 WITH() Aaron Peck; Noreen Koizumi, PharmD; Tammy Chung, PharmD Cc: Hina Punjabi' AS [NOTE(S)],base.memid
,ISNULL(one.[Tier],0) AS [Tier1],ISNULL(two.[Tier],0) AS [Tier2],ISNULL(three.[Tier],0) AS [Tier3],ISNULL(four.[Tier],0) AS [Tier4],ISNULL(five.[Tier],0) AS [Tier5],ISNULL(six.[Tier],0) AS [Tier6]
FROM 
( -- INITIATE ...
SELECT DISTINCT memid
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st',Tier
FROM #CSNPRxTiers
-- WHERE TotalDMPHits = 1
) -- CONCLUDE ... 
AS base

	LEFT JOIN 
	( -- INITIATE ...
	SELECT DISTINCT memid,1 AS [Tier]
	FROM #CSNPRxTiers
	WHERE ISNULL(Tier,4) = 1
	) -- CONCLUDE ... 
	AS one ON base.memid = one.memid
	
	LEFT JOIN 
	( -- INITIATE ...
	SELECT DISTINCT memid,1 AS [Tier]
	FROM #CSNPRxTiers
	WHERE ISNULL(Tier,4) = 2
	) -- CONCLUDE ... 
	AS two ON base.memid = two.memid

	LEFT JOIN 
	( -- INITIATE ...
	SELECT DISTINCT memid,1 AS [Tier]
	FROM #CSNPRxTiers
	WHERE ISNULL(Tier,4) = 3
	) -- CONCLUDE ... 
	AS three ON base.memid = three.memid

	LEFT JOIN 
	( -- INITIATE ...
	SELECT DISTINCT memid,1 AS [Tier]
	FROM #CSNPRxTiers
	WHERE ISNULL(Tier,4) = 4 -- CAPTURE THE ISNULL(S) WITHOUT REPORTING THE '4'
	) -- CONCLUDE ... 
	AS four ON base.memid = four.memid
	
	LEFT JOIN 
	( -- INITIATE ...
	SELECT DISTINCT memid,1 AS [Tier]
	FROM #CSNPRxTiers
	WHERE ISNULL(Tier,4) = 5
	) -- CONCLUDE ... 
	AS five ON base.memid = five.memid

	LEFT JOIN 
	( -- INITIATE ...
	SELECT DISTINCT memid,1 AS [Tier]
	FROM #CSNPRxTiers
	WHERE ISNULL(Tier,4) = 6
	) -- CONCLUDE ... 
	AS six ON base.memid = six.memid
) -- CONCLUDE ...
AS mpivot

UNION 
SELECT ' ' AS [NOTE(S)], 'Total Members per [Tier]' AS [memid],SUM(mpivot.[Tier1]) AS [Tier1],SUM(mpivot.[Tier2]) AS [Tier2],SUM(mpivot.[Tier3]) AS [Tier3],SUM(mpivot.[Tier4]) AS [Tier4],SUM(mpivot.[Tier5]) AS [Tier5],SUM(mpivot.[Tier6]) AS [Tier6],'N/A' AS [Total Tier(s)]
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM 
( -- INITIATE ...
SELECT DISTINCT 'per Subject: "CSNP Drug Tier Utilization Projections Review of Results" DISCUSSION ON Thursday, September 14, 2023 WITH() Aaron Peck; Noreen Koizumi, PharmD; Tammy Chung, PharmD Cc: Hina Punjabi' AS [NOTE(S)],base.memid
,ISNULL(one.[Tier],0) AS [Tier1],ISNULL(two.[Tier],0) AS [Tier2],ISNULL(three.[Tier],0) AS [Tier3],ISNULL(four.[Tier],0) AS [Tier4],ISNULL(five.[Tier],0) AS [Tier5],ISNULL(six.[Tier],0) AS [Tier6]
FROM 
( -- INITIATE ...
SELECT DISTINCT memid
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st',Tier
FROM #CSNPRxTiers
-- WHERE TotalDMPHits = 1
) -- CONCLUDE ... 
AS base

	LEFT JOIN 
	( -- INITIATE ...
	SELECT DISTINCT memid,1 AS [Tier]
	FROM #CSNPRxTiers
	WHERE ISNULL(Tier,4) = 1
	) -- CONCLUDE ... 
	AS one ON base.memid = one.memid
	
	LEFT JOIN 
	( -- INITIATE ...
	SELECT DISTINCT memid,1 AS [Tier]
	FROM #CSNPRxTiers
	WHERE ISNULL(Tier,4) = 2
	) -- CONCLUDE ... 
	AS two ON base.memid = two.memid

	LEFT JOIN 
	( -- INITIATE ...
	SELECT DISTINCT memid,1 AS [Tier]
	FROM #CSNPRxTiers
	WHERE ISNULL(Tier,4) = 3
	) -- CONCLUDE ... 
	AS three ON base.memid = three.memid

	LEFT JOIN 
	( -- INITIATE ...
	SELECT DISTINCT memid,1 AS [Tier]
	FROM #CSNPRxTiers
	WHERE ISNULL(Tier,4) = 4 -- CAPTURE THE ISNULL(S) WITHOUT REPORTING THE '4'
	) -- CONCLUDE ... 
	AS four ON base.memid = four.memid
	
	LEFT JOIN 
	( -- INITIATE ...
	SELECT DISTINCT memid,1 AS [Tier]
	FROM #CSNPRxTiers
	WHERE ISNULL(Tier,4) = 5
	) -- CONCLUDE ... 
	AS five ON base.memid = five.memid

	LEFT JOIN 
	( -- INITIATE ...
	SELECT DISTINCT memid,1 AS [Tier]
	FROM #CSNPRxTiers
	WHERE ISNULL(Tier,4) = 6
	) -- CONCLUDE ... 
	AS six ON base.memid = six.memid
) -- CONCLUDE ...
AS mpivot

		-- SELECT TOP 10 * FROM #MedImpactRxCSNPCHGALL
		SELECT DISTINCT TIER FROM INFORMATICS.dbo.MedImpactRxCSNPCHGALL
		SELECT COUNT(DISTINCT(DupID)) AS [Unique RxID],COUNT(DISTINCT(ClaimID)) AS [Unique Rx claimid Count],COUNT(DISTINCT(PrescriptionNumber)) AS [Unique Prescription Count],SUM(PaidAmount) AS [Cost] FROM #MedImpactRxCSNPCHGALL

		SELECT ' ' AS 'NO COPAY ONLY',mta.*,mem.fullname
		,UPPER(LTRIM(RTRIM(ent.Phyaddr1))) AS [PhyAddress1]
		,UPPER(LTRIM(RTRIM(ent.Phyaddr2))) AS [PhyAddress2]
		,UPPER(LTRIM(RTRIM(ent.Phycity))) AS [PhyCity]
		,UPPER(LTRIM(RTRIM(ent.Phystate))) AS [PhyState]
		,UPPER(LTRIM(RTRIM(ISNULL(ent.Phycounty,'UNDEFINED COUNTY')))) AS [PhyCounty] --•	County, if Plan is multi-county
		,CASE
		WHEN SUBSTRING(LTRIM(RTRIM(ISNULL(CAST(ent.Phyzip AS nvarchar(25)),''))),1,1) = '0'
		THEN '0'+ SUBSTRING(LTRIM(RTRIM(ISNULL(CAST(ent.Phyzip AS nvarchar(25)),''))),2,4)
		WHEN SUBSTRING(LTRIM(RTRIM(ISNULL(CAST(ent.Phyzip AS nvarchar(25)),''))),1,1) = '00'
		THEN '00'+ SUBSTRING(LTRIM(RTRIM(ISNULL(CAST(ent.Phyzip AS nvarchar(25)),''))),3,3)
		ELSE  SUBSTRING(LTRIM(RTRIM(ISNULL(CAST(ent.Phyzip AS nvarchar(25)),''))),1,5) 
		END AS [PhyZip]
		,UPPER(LTRIM(RTRIM(ent.addr1))) AS [MailingAddress1]
		,UPPER(LTRIM(RTRIM(ent.addr2))) AS [MailingAddress2]
		,UPPER(LTRIM(RTRIM(ent.city))) AS [MailingCity]
		,UPPER(LTRIM(RTRIM(ent.state))) AS [MailingState]
		,UPPER(LTRIM(RTRIM(ISNULL(ent.county,'UNDEFINED COUNTY')))) AS [MailingCounty] --•	County, if Plan is multi-county
		--,UPPER(LTRIM(RTRIM(zip.ZIPCODE))) AS ZIPCODE --SAN DIEGO (SD) COUNTY ONLY!!!
		,CASE
		WHEN SUBSTRING(LTRIM(RTRIM(ISNULL(CAST(ent.zip AS nvarchar(25)),''))),1,1) = '0'
		THEN '0'+ SUBSTRING(LTRIM(RTRIM(ISNULL(CAST(ent.zip AS nvarchar(25)),''))),2,4)
		WHEN SUBSTRING(LTRIM(RTRIM(ISNULL(CAST(ent.zip AS nvarchar(25)),''))),1,1) = '00'
		THEN '00'+ SUBSTRING(LTRIM(RTRIM(ISNULL(CAST(ent.zip AS nvarchar(25)),''))),3,3)
		ELSE  SUBSTRING(LTRIM(RTRIM(ISNULL(CAST(ent.zip AS nvarchar(25)),''))),1,5) 
		END AS [MailingZip]
		,[TELEPHONE] = CASE
		WHEN LTRIM(RTRIM(ent.phone)) = ''
		THEN SUBSTRING(REPLACE(LTRIM(RTRIM(ent.emerphone)),'-',''),1,10)
		ELSE SUBSTRING(REPLACE(LTRIM(RTRIM(ent.phone)),'-',''),1,10)
		END,ent.emerphone,ent.faxphone,ent.mobilephone,ent.pagerphone,ent.secfaxphone,ent.secphone,ent.SecureFaxPhone
		,UPPER(LTRIM(RTRIM(ISNULL(ent.email,'')))) AS [eMAIL]
		-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
		-- SELECT DISTINCT ' ' AS 'CHECK 1st'
		FROM INFORMATICS.dbo.CSNP_MEMBER_TIER_ASSESSMENT AS mta
				LEFT JOIN HMOPROD_PLANDATA.dbo.member AS mem ON SUBSTRING(UPPER(LTRIM(RTRIM(ISNULL(mta.memid,'')))),1,9) COLLATE DATABASE_DEFAULT = SUBSTRING(UPPER(LTRIM(RTRIM(ISNULL(mem.secondaryid,'')))),1,9) COLLATE DATABASE_DEFAULT
				LEFT JOIN HMOPROD_PLANDATA.dbo.entity AS ent ON mem.entityid = ent.entid
		WHERE 
		( -- INITIATE ...
		mta.[Tier1] = 1
			OR mta.[Tier6] = 1
		) -- CONCLUDE ...
			AND mta.[Tier2] = 0
			AND mta.[Tier3] = 0
			AND mta.[Tier4] = 0
			AND mta.[Tier5] = 0
				
		SELECT ' ' AS 'COMPREHENSIVE',mta.*,mem.fullname
		,UPPER(LTRIM(RTRIM(ent.Phyaddr1))) AS [PhyAddress1]
		,UPPER(LTRIM(RTRIM(ent.Phyaddr2))) AS [PhyAddress2]
		,UPPER(LTRIM(RTRIM(ent.Phycity))) AS [PhyCity]
		,UPPER(LTRIM(RTRIM(ent.Phystate))) AS [PhyState]
		,UPPER(LTRIM(RTRIM(ISNULL(ent.Phycounty,'UNDEFINED COUNTY')))) AS [PhyCounty] --•	County, if Plan is multi-county
		,CASE
		WHEN SUBSTRING(LTRIM(RTRIM(ISNULL(CAST(ent.Phyzip AS nvarchar(25)),''))),1,1) = '0'
		THEN '0'+ SUBSTRING(LTRIM(RTRIM(ISNULL(CAST(ent.Phyzip AS nvarchar(25)),''))),2,4)
		WHEN SUBSTRING(LTRIM(RTRIM(ISNULL(CAST(ent.Phyzip AS nvarchar(25)),''))),1,1) = '00'
		THEN '00'+ SUBSTRING(LTRIM(RTRIM(ISNULL(CAST(ent.Phyzip AS nvarchar(25)),''))),3,3)
		ELSE  SUBSTRING(LTRIM(RTRIM(ISNULL(CAST(ent.Phyzip AS nvarchar(25)),''))),1,5) 
		END AS [PhyZip]
		,UPPER(LTRIM(RTRIM(ent.addr1))) AS [MailingAddress1]
		,UPPER(LTRIM(RTRIM(ent.addr2))) AS [MailingAddress2]
		,UPPER(LTRIM(RTRIM(ent.city))) AS [MailingCity]
		,UPPER(LTRIM(RTRIM(ent.state))) AS [MailingState]
		,UPPER(LTRIM(RTRIM(ISNULL(ent.county,'UNDEFINED COUNTY')))) AS [MailingCounty] --•	County, if Plan is multi-county
		,CASE
		WHEN SUBSTRING(LTRIM(RTRIM(ISNULL(CAST(ent.zip AS nvarchar(25)),''))),1,1) = '0'
		THEN '0'+ SUBSTRING(LTRIM(RTRIM(ISNULL(CAST(ent.zip AS nvarchar(25)),''))),2,4)
		WHEN SUBSTRING(LTRIM(RTRIM(ISNULL(CAST(ent.zip AS nvarchar(25)),''))),1,1) = '00'
		THEN '00'+ SUBSTRING(LTRIM(RTRIM(ISNULL(CAST(ent.zip AS nvarchar(25)),''))),3,3)
		ELSE  SUBSTRING(LTRIM(RTRIM(ISNULL(CAST(ent.zip AS nvarchar(25)),''))),1,5) 
		END AS [MailingZip]
		,[TELEPHONE] = CASE
		WHEN LTRIM(RTRIM(ent.phone)) = ''
		THEN SUBSTRING(REPLACE(LTRIM(RTRIM(ent.emerphone)),'-',''),1,10)
		ELSE SUBSTRING(REPLACE(LTRIM(RTRIM(ent.phone)),'-',''),1,10)
		END,ent.emerphone,ent.faxphone,ent.mobilephone,ent.pagerphone,ent.secfaxphone,ent.secphone,ent.SecureFaxPhone
		,UPPER(LTRIM(RTRIM(ISNULL(ent.email,'')))) AS [eMAIL]
		-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
		-- SELECT DISTINCT ' ' AS 'CHECK 1st'
		FROM INFORMATICS.dbo.CSNP_MEMBER_TIER_ASSESSMENT AS mta
				LEFT JOIN HMOPROD_PLANDATA.dbo.member AS mem ON SUBSTRING(UPPER(LTRIM(RTRIM(ISNULL(mta.memid,'')))),1,9) COLLATE DATABASE_DEFAULT = SUBSTRING(UPPER(LTRIM(RTRIM(ISNULL(mem.secondaryid,'')))),1,9) COLLATE DATABASE_DEFAULT
				LEFT JOIN HMOPROD_PLANDATA.dbo.entity AS ent ON mem.entityid = ent.entid







-- ===============================================================================
	-- MANUAL PIVOT() High Level Breakdown of the Number of Unique Member(s) that have the following: --
-- ===============================================================================
-- x see [sp_DMP]

------------ SELECT * FROM INFORMATICS.dbo.DMP_DMW --FUTURE USE!!!

		------------•	Per Dr. Vega request, once refreshed, can you please provide a high level breakdown of the number of unique members that have the following: 
				------------o	4 out of 4 of the diagnoses
				------------o	3 out of 4 of the diagnoses
				------------o	2 out of 4 of the diagnoses
				------------o	1 out of 4 of the diagnoses

		------------o	That is, a diagnosis of at least one of the following per the established criteria (attached):
		------------?	Asthma
		------------?	COPD
		------------?	CHF
		------------?	Diabetes Mellitus

SELECT ds.[NOTE(s)],TRY_CONVERT(date,ds.DYNAMIC_STARTdate) AS DYNAMIC_START,TRY_CONVERT(date,ds.DYNAMIC_ENDdate) AS DYNAMIC_END,ds.[MESSAGE(s)],one.LINE_OF_BUSINESS,four.[4 out of 4 of the diagnoses],three.[3 out of 4 of the diagnoses],two.[2 out of 4 of the diagnoses],one.[1 out of 4 of the diagnoses]
FROM INFORMATICS.dbo.DMWsummary AS ds,
( -- INITIATE ...
SELECT LINE_OF_BUSINESS,COUNT(1) AS [1 out of 4 of the diagnoses]
FROM INFORMATICS.dbo.DMP_DMW 
WHERE TotalDMPHits = 1
GROUP BY LINE_OF_BUSINESS
) -- CONCLUDE ... 
AS one -- DO NOT NO NEGATIVE != <> COVER UP THE TE
	LEFT JOIN 
	( -- INITIATE ...
	SELECT LINE_OF_BUSINESS,COUNT(1) AS [2 out of 4 of the diagnoses]
	FROM INFORMATICS.dbo.DMP_DMW 
	WHERE TotalDMPHits = 2
	GROUP BY LINE_OF_BUSINESS
	) -- CONCLUDE ... 
	AS two ON one.LINE_OF_BUSINESS = two.LINE_OF_BUSINESS
	LEFT JOIN 
	( -- INITIATE ...
	SELECT LINE_OF_BUSINESS,COUNT(1) AS [3 out of 4 of the diagnoses]
	FROM INFORMATICS.dbo.DMP_DMW 
	WHERE TotalDMPHits = 3
	GROUP BY LINE_OF_BUSINESS
	) -- CONCLUDE ... 
	AS three ON one.LINE_OF_BUSINESS = three.LINE_OF_BUSINESS
	LEFT JOIN 
	( -- INITIATE ...
	SELECT LINE_OF_BUSINESS,COUNT(1) AS [4 out of 4 of the diagnoses]
	FROM INFORMATICS.dbo.DMP_DMW 
	WHERE TotalDMPHits = 4
	GROUP BY LINE_OF_BUSINESS
	) -- CONCLUDE ... 
	AS four ON one.LINE_OF_BUSINESS = four.LINE_OF_BUSINESS

UNION -- [TOTAL] / [GRAND TOTAL] HACK IN LIEU OF CUBE()
SELECT ds.[NOTE(s)],TRY_CONVERT(date,ds.DYNAMIC_STARTdate) AS DYNAMIC_START,TRY_CONVERT(date,ds.DYNAMIC_ENDdate) AS DYNAMIC_END,ds.[MESSAGE(s)],' Total: ' AS LINE_OF_BUSINESS,(SELECT COUNT(1) FROM INFORMATICS.dbo.DMP_DMW WHERE TotalDMPHits = 4) AS [4 out of 4 of the diagnoses],(SELECT COUNT(1) FROM INFORMATICS.dbo.DMP_DMW WHERE TotalDMPHits = 3) AS [3 out of 4 of the diagnoses],(SELECT COUNT(1) FROM INFORMATICS.dbo.DMP_DMW WHERE TotalDMPHits = 2) AS [2 out of 4 of the diagnoses],(SELECT COUNT(1) FROM INFORMATICS.dbo.DMP_DMW WHERE TotalDMPHits = 1) AS [1 out of 4 of the diagnoses]
FROM INFORMATICS.dbo.DMWsummary AS ds
ORDER BY LINE_OF_BUSINESS DESC







-- ==================================================
	-- STEP00: Generate MULTIPLE PIVOT() SOURCE dataset --
-- ==================================================
-----------------------------------------------------------------------------------------------------------------------------
	--Error Trapping: Check If Permanent Table(s) Already Exist(s) And Drop If Applicable--
-----------------------------------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS #PIVOTtesting-- SQL Server 2016 and later -- DYNAMIC tmp OR STATIC [TABLE] #TableName is a local temporary table visible only in the current session; #TableName is a GLOBAL temporary table visible to all sessions IN ('TempDB')

SELECT memid,headofhouse,lastname,firstname,dob,age,planid,program_name,claimid,claim_status,date_of_service,cleandate,logdate,createdate,formtype,billtype,provid,provider_name,charges,paid,cap_flag,codeid,DIAG_DESC,code_rank,code_rank_descr
INTO #PIVOTtesting
-- SELECT TOP 10 CAST(NULL AS nvarchar(255)) AS [SPACING],* -- CHECK 1st
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM #ar_ccs_1

		-- SELECT * FROM #PIVOTtesting

		-- COALESCE() - ROW(s) INTO A SINGULAR STRING / COL(column); 3rd person present: coalesces; past tense: coalesced; past participle: coalesced; gerund or present participle: coalescing

		-- come together and form one mass or whole.
		-- "the puddles had coalesced into shallow streams"
		-- synonyms:	merge, unite, join together, combine, fuse, mingle, blend; amalgamate, consolidate, integrate, homogenize, converge
		-- "the puddles had coalesced into shallow streams"
		-- combine (elements) in a mass or whole.
		-- "to help coalesce the community, they established an office"

		-- STEP 01: DECLARE necessary variables
DECLARE @SQLQuery AS nvarchar (MAX)
DECLARE @PivotColumns AS nvarchar (MAX)
DECLARE @PivotColumnsDESC AS nvarchar (MAX) --ADD Descritpion(s)
 
		-- STEP02: SET / Get unique values of pivot column
SELECT @PivotColumns = COALESCE(@PivotColumns + ',','')+ QUOTENAME(code_rank) --[] is the DEFAULT VAL() COALESCE() - ROW(s) INTO A 
FROM (SELECT DISTINCT code_rank FROM #PIVOTtesting) AS PivotCOLnames ORDER BY code_rank DESC --SET PIVOT COL(s) HEADER(s) aka 'FOR'

		SELECT @PivotColumns AS COLnames --SET PIVOT COL(s) HEADER(s) aka 'FOR'

		-- STEP02: SET/  ADD Descritpion(s): Get unique values of pivot column  
SELECT @PivotColumnsDESC = COALESCE(@PivotColumnsDESC + ',','')+ QUOTENAME(code_rank_descr) --[] is the DEFAULT VAL() COALESCE() - ROW(s) INTO A 
FROM (SELECT DISTINCT code_rank_descr FROM #PIVOTtesting) AS PivotCOLnames ORDER BY code_rank_descr DESC --SET PIVOT COL(s) HEADER(s) aka 'FOR'

		SELECT @PivotColumnsDESC AS COLnamesDESC --SET PIVOT COL(s) HEADER(s) aka 'FOR'

-----------------------------------------------------------------------------------------------------------------------------
	--Error Trapping: Check If Permanent Table(s) Already Exist(s) And Drop If Applicable--
-----------------------------------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS [TABLENAME]-- SQL Server 2016 and later -- DYNAMIC tmp OR STATIC [TABLE] #TableName is a local temporary table visible only in the current session; #TableName is a GLOBAL temporary table visible to all sessions IN ('TempDB')

		-- STEP03: Create the dynamic query with all the values for 
--pivot column at runtime
SET @SQLQuery = 'SELECT memid,headofhouse,lastname,firstname,dob,age,planid,program_name,claimid,claim_status,date_of_service,cleandate,logdate,createdate,formtype,billtype,provid,provider_name,charges,paid,cap_flag ,'  --ROW(s)
    +@PivotColumns --SET PIVOT COL(s) HEADER(s) aka 'FOR'
    +','+
    +@PivotColumnsDESC --SET PIVOT COL(s) HEADER(s) aka 'FOR'
    +' INTO [TABLENAME] ' --global temporary table visible to all sessions. 
    +' FROM #PIVOTtesting'
    +' PIVOT(MAX(codeid)' -- SET PIVOT VAL()
	+' FOR code_rank IN (' +@PivotColumns+')) AS P' --SET PIVOT COL(s) HEADER(s) aka 'FOR'
	+' PIVOT(MAX(DIAG_DESC)' -- SET PIVOT VAL()
	+' FOR code_rank_descr IN (' +@PivotColumnsDESC+')) AS PP' --SET PIVOT COL(s) HEADER(s) aka 'FOR'
    +' ORDER BY memid,headofhouse,lastname,firstname,dob,age,planid,program_name,claimid,claim_status,date_of_service,cleandate,logdate,createdate,formtype,billtype,provid,provider_name,charges,paid,cap_flag'

		-- SELECT @SQLQuery AS [COPY & PASTE TO EXEC; MANUALLY]
		EXEC sp_executesql @SQLQuery;

		SELECT * FROM [TABLENAME]







-- =====================================================================
	-- UNPIVOT() --
-- =====================================================================
-- =====================================================================
	-- DECLARE @PARAMETER(S) / @FILTER(S) --
-- =====================================================================
DECLARE @RangeStartDate AS datetime
DECLARE @RangeEndDate AS datetime

SET @RangeStartDate = GETDATE()
SET @RangeEndDate = GETDATE()

		SELECT TOP 1 ' ' AS 'ESRI ArcGIS (ALWAYR RIGHT CLICK HOVER)'
		,'Assuming the CSV is imported into a table named INFORMATICS.dbo.ESRIArcGIS_NetworkAdequacy' AS [MESSAGE(S)],		'BETWEEN '+CAST(CAST(@RangeStartDate AS date) AS varchar(255))+' AND '+CAST(CAST(@RangeEndDate AS date) AS varchar(255)) AS [RANGE NOTE(s)],*
		FROM INFORMATICS.dbo.ESRIArcGIS_NetworkAdequacy
		
		
		
		
		


--------------------------------------------------------------------------------------------------------------------
	-- Error Trapping: Check If Permanent Table(s) Already Exist(s) And Drop If Applicable --
--------------------------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS #UNPIVOT_ESRIArcGIS_NetworkAdequacy -- First, we'll create a CTE (Common Table Expression) to unpivot the Pass_ columns

SELECT DISTINCT  ' ' AS 'CREATE a CTE (Common Table Expression) to UNPIVOT the Pass_ columns',
COUNTY,
ZIP_CODE,
-- LATITUDE,
-- LONGITUDE,
-- DistanceToNetworkInMeters,
CASE 
WHEN ColumnName = 'Pass_Adult_Primary_Care' THEN 'Adult Primary Care'
WHEN ColumnName = 'Pass_Cardiology_Interventional_Cardiology' THEN 'Cardiology/Interventional Cardiology'
WHEN ColumnName = 'Pass_Dermatology' THEN 'Dermatology'
WHEN ColumnName = 'Pass_ENT_Otolaryngology' THEN 'ENT/Otolaryngology'
WHEN ColumnName = 'Pass_Endocrinology' THEN 'Endocrinology'
WHEN ColumnName = 'Pass_Gastroenterology' THEN 'Gastroenterology'
WHEN ColumnName = 'Pass_General_Surgery' THEN 'General Surgery'
WHEN ColumnName = 'Pass_HIV_AIDS_Infectious_Disease' THEN 'HIV/AIDS/Infectious Disease'
WHEN ColumnName = 'Pass_Hematology' THEN 'Hematology'
WHEN ColumnName = 'Pass_Hospitals' THEN 'Hospitals'
WHEN ColumnName = 'Pass_Mental_Health_Outpatient_Services' THEN 'Mental Health Outpatient Services'
WHEN ColumnName = 'Pass_Nephrology' THEN 'Nephrology'
WHEN ColumnName = 'Pass_Neurology' THEN 'Neurology'
WHEN ColumnName = 'Pass_Obstetrics___Gynecology' THEN 'Obstetrics & Gynecology'
WHEN ColumnName = 'Pass_Oncology' THEN 'Oncology'
WHEN ColumnName = 'Pass_Ophthalmology' THEN 'Ophthalmology'
WHEN ColumnName = 'Pass_Orthopedic_Surgery' THEN 'Orthopedic Surgery'
WHEN ColumnName = 'Pass_Pediatric_Primary_Care' THEN 'Pediatric Primary Care'
WHEN ColumnName = 'Pass_Physical_Medicine___Rehabilitation' THEN 'Physical Medicine & Rehabilitation'
WHEN ColumnName = 'Pass_Psychiatry' THEN 'Psychiatry'
WHEN ColumnName = 'Pass_Pulmonology' THEN 'Pulmonology'
END AS ProviderType,
TRY_CONVERT(nvarchar(255),NULL) AS [TD_StandardsMet],
ColumnValue AS PassValue
INTO #UNPIVOT_ESRIArcGIS_NetworkAdequacy
-- SELECT TOP 10 ' ' AS 'CHECK 1st',* 
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM INFORMATICS.dbo.ESRIArcGIS_NetworkAdequacy

UNPIVOT
(
ColumnValue FOR ColumnName IN (
Pass_Adult_Primary_Care,
Pass_Cardiology_Interventional_Cardiology,
Pass_Dermatology,
Pass_ENT_Otolaryngology,
Pass_Endocrinology,
Pass_Gastroenterology,
Pass_General_Surgery,
Pass_HIV_AIDS_Infectious_Disease,
Pass_Hematology,
Pass_Hospitals,
Pass_Mental_Health_Outpatient_Services,
Pass_Nephrology,
Pass_Neurology,
Pass_Obstetrics___Gynecology,
Pass_Oncology,
Pass_Ophthalmology,
Pass_Orthopedic_Surgery,
Pass_Pediatric_Primary_Care,
Pass_Physical_Medicine___Rehabilitation,
Pass_Psychiatry,
Pass_Pulmonology
)
) AS UnpivotedCols

UPDATE #UNPIVOT_ESRIArcGIS_NetworkAdequacy
SET [TD_StandardsMet] = TRY_CONVERT(nvarchar(255),NULL) -- RESET REFRESH RESTART

UPDATE #UNPIVOT_ESRIArcGIS_NetworkAdequacy
SET [TD_StandardsMet] = CASE 
WHEN PassValue = '0'
THEN 'Does Not Meet'
WHEN PassValue = '1'
THEN 'Meets'
END 
FROM #UNPIVOT_ESRIArcGIS_NetworkAdequacy AS ea
