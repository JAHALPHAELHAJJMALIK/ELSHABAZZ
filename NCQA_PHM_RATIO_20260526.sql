-- ===================================================================
    -- MATHEMATIC(s) %() / PERCENT()  / PERCENTAGE() & OR decimal() SQL:
-- ===================================================================

 		-- ⏎  SQL: TRY_CONVERT(decimal(9,1),NULL) :||: # NUMBER WITH() NINE (9) DIGIT(s) IN TOTAL: WITH() ONE (1) DIGIT(s) AFTER THE DECIMAL

DECLARE @numerator AS decimal(9,3)
DECLARE @denominator AS decimal(9,3)

SET @numerator = 69.78399
SET @denominator = 100.345

		SELECT 'SQL: TRY_CONVERT(decimal(9,1),NULL) :||: # NUMBER WITH() NINE (9) DIGIT(s) IN TOTAL: WITH() ONE (1) DIGIT(s) AFTER THE DECIMAL' AS [MESSAGE(S)]
		,ROUND(@numerator,0) AS 'NUMERATOR TEST ROUND 0'
		,ROUND(@denominator,1) AS 'DENOMINATOR TEST ROUND 1'
		,[PERCENTAGE] = TRY_CONVERT(nvarchar(255),TRY_CONVERT(decimal(9,3),(@numerator)*100.000/NULLIF((@denominator),0)*1.000)) +'%' -- NESTED WITH() SYMBOL' ... DO NOT NO NEGATIVE <> != DIVIDE BY ZERO (0)
		,[PERCENTAGE] = CONVERT(nvarchar(255),CONVERT(decimal(9,3),(@numerator)*100.000/NULLIF((@denominator),0)*1.000)) +'%' -- NESTED WITH() SYMBOL' ... DO NOT NO NEGATIVE <> != DIVIDE BY ZERO (0)
		,[PERCENTAGE] = CAST(CAST((@numerator)*100.000/NULLIF((@denominator)*1.000,0) AS money) AS nvarchar(255))+'%' -- NESTED WITH() SYMBOL' ... DO NOT NO NEGATIVE <> != DIVIDE BY ZERO (0)
		,[PERCENTAGE] = FORMAT(((SUM(@numerator) / NULLIF(SUM(@denominator), 0))) * 100, 'N2') + '%'

SELECT 'Medi-Cal percentage of Pay-for-Performance PCPs and the Capitation/Population Based percentage?' AS [MESSAGE(S)]
,[PERCENTAGE: Capitation/Population-Based Excluding Capitated RCSSD] = TRY_CONVERT(nvarchar(255),TRY_CONVERT(decimal(9,3),(COUNT(DISTINCT(pcp.NPIis)))*100.000/NULLIF((totalproviders.[Total Unique NPI Count]),0)*1.000)) +'%' -- NESTED WITH() SYMBOL' ... DO NOT NO NEGATIVE <> != DIVIDE BY ZERO (0)
,[PERCENTAGE: Capitation/Population-Based Including Capitated RCSSD] =TRY_CONVERT(nvarchar(255),TRY_CONVERT(decimal(9,3),((COUNT(DISTINCT(pcp.NPIis)))+radyspe.[Unique Specialist Count])*100.000/NULLIF((totalproviders.[Total Unique NPI Count]),0)*1.000)) +'%' -- NESTED WITH() SYMBOL' ... DO NOT NO NEGATIVE <> != DIVIDE BY ZERO (0)
,totalproviders.[Total Unique NPI Count]
,COUNT(DISTINCT(pcp.NPIis)) AS [Unique PCP Count]
,spe.[Unique Specialist Count]
,radyspe.[Unique Specialist Count] AS [Unique Capitated RCSSD Specialist Count]
FROM INFORMATICS.dbo.SQIC_PCPs (NOLOCK) AS pcp
CROSS APPLY  -- INDEPENDENT STAND ALONE ... CROSS APPLY() CROSS JOIN() CARTESIAN PRODUCT
( -- INITIATE ...
SELECT COUNT(DISTINCT(NPIis)) AS [Unique Specialist Count]
FROM INFORMATICS.dbo.SQIC_SPEs (NOLOCK)
WHERE 1=1
	AND NOT CHAPTER_NAME IN ('Primary Care Physician') -- NO NOT NEGATIVE <> != ...
) -- CONCLUDE ...
AS spe
CROSS APPLY  -- INDEPENDENT STAND ALONE ... CROSS APPLY() CROSS JOIN() CARTESIAN PRODUCT
( -- INITIATE ...
SELECT COUNT(DISTINCT(NPIis)) AS [Unique Specialist Count]
FROM INFORMATICS.dbo.SQIC_SPEs (NOLOCK)
WHERE 1=1 
	AND ISNULL(DBA,'') LIKE '%RADY%'
) -- CONCLUDE ...
AS radyspe
CROSS APPLY  -- INDEPENDENT STAND ALONE ... CROSS APPLY() CROSS JOIN() CARTESIAN PRODUCT
( -- INITIATE ...
SELECT COUNT(DISTINCT(tp.NPIis)) AS [Total Unique NPI Count]
FROM 
(SELECT NPIis FROM INFORMATICS.dbo.SQIC_PCPs (NOLOCK)

UNION ALL
SELECT NPIis FROM INFORMATICS.dbo.SQIC_SPEs (NOLOCK)) AS tp
) -- CONCLUDE ...
AS totalproviders
GROUP BY spe.[Unique Specialist Count],radyspe.[Unique Specialist Count],totalproviders.[Total Unique NPI Count]

		SELECT TOP 1 * FROM INFORMATICS.dbo.SQIC_PCPs
		SELECT TOP 1 * FROM INFORMATICS.dbo.SQIC_SPEs WHERE 1=1 AND NPIis = '1003964834'

-- =====================================================
	-- TABLE DESIGN: 
-- =====================================================
USE INFORMATICS

SELECT c.TABLE_CATALOG+'.'+c.TABLE_SCHEMA+'.'+c.TABLE_NAME AS 'TABLE DESIGN: '
,c.COLUMN_NAME
,c.DATA_TYPE
,c.IS_NULLABLE
,c.CHARACTER_MAXIMUM_LENGTH
,c.NUMERIC_PRECISION
,c.NUMERIC_SCALE
,c.COLUMN_DEFAULT
,c.ORDINAL_POSITION
,tc.CONSTRAINT_TYPE
,tc.CONSTRAINT_NAME
FROM INFORMATION_SCHEMA.COLUMNS AS c (NOLOCK) 
		LEFT JOIN INFORMATION_SCHEMA.KEY_COLUMN_USAGE AS kcu (NOLOCK) ON c.COLUMN_NAME = kcu.COLUMN_NAME 
			AND c.TABLE_NAME = kcu.TABLE_NAME
		LEFT JOIN INFORMATION_SCHEMA.TABLE_CONSTRAINTS AS tc (NOLOCK) ON kcu.CONSTRAINT_NAME = tc.CONSTRAINT_NAME
WHERE 1=1
	AND c.TABLE_CATALOG IN ('INFORMATICS') -- AS [db] 'DatabaseName'
	AND c.TABLE_SCHEMA = 'dbo' 
	AND c.TABLE_NAME = 'SQIC_PCPs'
ORDER BY c.COLUMN_NAME,c.ORDINAL_POSITION;

-- =====================================================
	-- TABLE DESIGN: 
-- =====================================================
USE INFORMATICS

SELECT c.TABLE_CATALOG+'.'+c.TABLE_SCHEMA+'.'+c.TABLE_NAME AS 'TABLE DESIGN: '
,c.COLUMN_NAME
,c.DATA_TYPE
,c.IS_NULLABLE
,c.CHARACTER_MAXIMUM_LENGTH
,c.NUMERIC_PRECISION
,c.NUMERIC_SCALE
,c.COLUMN_DEFAULT
,c.ORDINAL_POSITION
,tc.CONSTRAINT_TYPE
,tc.CONSTRAINT_NAME
FROM INFORMATION_SCHEMA.COLUMNS AS c (NOLOCK) 
		LEFT JOIN INFORMATION_SCHEMA.KEY_COLUMN_USAGE AS kcu (NOLOCK) ON c.COLUMN_NAME = kcu.COLUMN_NAME 
			AND c.TABLE_NAME = kcu.TABLE_NAME
		LEFT JOIN INFORMATION_SCHEMA.TABLE_CONSTRAINTS AS tc (NOLOCK) ON kcu.CONSTRAINT_NAME = tc.CONSTRAINT_NAME
WHERE 1=1
	AND c.TABLE_CATALOG IN ('INFORMATICS') -- AS [db] 'DatabaseName'
	AND c.TABLE_SCHEMA = 'dbo' 
	AND c.TABLE_NAME = 'SQIC_SPEs'
ORDER BY c.COLUMN_NAME,c.ORDINAL_POSITION;
