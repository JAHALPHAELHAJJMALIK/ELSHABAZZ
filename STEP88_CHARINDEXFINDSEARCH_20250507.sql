-- ============================================================
	-- CHARINDEX() FIND() SEARCH() SQL table(s) or field(s) --
-- ============================================================
JAH CHARINDEX() FIND() SEARCH()'SCHEMA()' = SELECT * FROM 'SERVERname'.'DATABASEname'.'SCHEMAname'.'OBJECTname' - FOUR (4) PART() SCHEMA() aka [SERVERname].[DATABASEname].[SCHEMAname].[OBJECTname] - see '[SQL13].[CHGAPP_PROD].dbo.[tblEDIDHCSType834]','find stored procedure from table field name', SSMS LINKED SERVER, CHARINDEX(search_string, base_string [, start_position])
 
-- =====================================================================
	-- SSM SQL SERVER VERSION CTRL - COMPATIBILITY LEVEL(S) -- 
-- =====================================================================
DECLARE @db AS nvarchar(255) = 'INFORMATICS2'

	-- Method 1: Using sys.databases
SELECT name, compatibility_level,*
FROM sys.databases
WHERE name = @db;

	-- Method 2: Using DATABASEPROPERTYEX
SELECT DATABASEPROPERTYEX(@db, 'CompatibilityLevel') AS [db Compatibility LVL];

/* ALTER DATABASE @db SET compatibility_LEVEL=150 -- CURRENTLY @110
 GO */

SELECT SERVERPROPERTY('ProductVersion') AS Version,
       SERVERPROPERTY('ProductLevel') AS Level,
       SERVERPROPERTY('Edition') AS Edition,
       SERVERPROPERTY('ProductMajorVersion') AS MajorVersion;

SELECT @@VERSION AS [Server Version CTRL];

SELECT CASE 
WHEN CONVERT(VARCHAR(128), SERVERPROPERTY ('productversion')) LIKE '16%' THEN 'SQL Server 2022'
WHEN CONVERT(VARCHAR(128), SERVERPROPERTY ('productversion')) LIKE '15%' THEN 'SQL Server 2019'
WHEN CONVERT(VARCHAR(128), SERVERPROPERTY ('productversion')) LIKE '14%' THEN 'SQL Server 2017'
WHEN CONVERT(VARCHAR(128), SERVERPROPERTY ('productversion')) LIKE '13%' THEN 'SQL Server 2016'
WHEN CONVERT(VARCHAR(128), SERVERPROPERTY ('productversion')) LIKE '12%' THEN 'SQL Server 2014'
WHEN CONVERT(VARCHAR(128), SERVERPROPERTY ('productversion')) LIKE '11%' THEN 'SQL Server 2012'
WHEN CONVERT(VARCHAR(128), SERVERPROPERTY ('productversion')) LIKE '10.5%' THEN 'SQL Server 2008 R2'
WHEN CONVERT(VARCHAR(128), SERVERPROPERTY ('productversion')) LIKE '10%' THEN 'SQL Server 2008'
ELSE TRY_CONVERT(nvarchar(255),NULL)
END AS [SQL Server Version],
SERVERPROPERTY('Edition') AS Edition,
SERVERPROPERTY('ProductLevel') AS ProductLevel,
SERVERPROPERTY('ProductUpdateLevel') AS ProductUpdateLevel; 







-- =====================================================
	-- SERVER(S): --
-- =====================================================
		SELECT ' ' AS 'FOUR (4) PART SCHEMA: SERVERname.DATABASEname.SCHEMAname.OBJECTname'

				/* SQLPROD01: 'PRODUCTION SERVER'
				SQLPROD02: 'MAIN QNXT REPORT DEVELOPMENT'
				SQLPRODAPP01: 'eVips'
				SSISPROD01: 'LIMITED SSIS DEVLOPMENT'
				QNXTSQLQA01: 'TEST'
				SQLQA02: 'TEST'
				QNXTSQLDEV01: 'DEV TEST' */
				
/* Filename: database_object_search_template.sql 
Description: Template 
FOR: searching database objects, columns, and definitions
Usage: Copy and modify the parameters in the declaration section AS needed
Repository path suggestion: /sql-templates/utility/database_object_search_template.sql */

		⏎ DATA DICTIONARY(): 'https://cx.trizetto.com/qnxt/datamodels/index.cfm?path=5_20&Step=2' OR  'https://cx.trizetto.com/'

		⏎ CPT / HCPC (): 'https://www.encoderprofp.com/epro4payers' - Allyson, Here’s the login INFORMATION for EncoderPro (claims depot CPT online app);

		USE https://www.encoderprofp.com/epro4payers
		USE https://www.informit.com/library/content.aspx?b=STY_Sql_24hours&seqNum=25
		USE https://duckduckgo.com/?q=find+stored+procedure+dependencies+sql+server&ia=web

		UID: yyyy'shaylise'
		PW: V17T65 (The first AND fourth characters in the password are letters. The other characters are numeric.) 'QTd...yy'

		Username: Vheavn
		Password: Chg2016		
		-- UID: chgclaims3
		-- PW: Chg2016# --Chg2016@

JAH THANK YOU JAH 'Claude.ai ChatGPT BARD GROK' ON 20240215 ... Using the attached AS a baseline may I have you write a SQL script which will assist in locating an object within a given schema?

SELECT ' ' AS 'QNXT AUDIT TABLE(S): ',*
FROM HMOPROD_PLANDATA.dbo.EnrollKeys_Audit AS ea
WHERE 1=1
	AND ea.enrollid IN 
	( -- INITIATE ...
	SELECT c.enrollid
	--,c.claimid
	--, cd.dosfrom
	--, es.primarystatus
	--, es.effdate
	--, es.termdate
	FROM HMOPROD_PlanData.dbo.claim AS c
		JOIN HMOPROD_PlanData.dbo.claimdetail AS cd ON c.claimid = cd.claimid
			LEFT JOIN HMOPROD_PlanData.dbo.enrollstatus AS es ON es.enrollid = c.enrollid
				AND cd.dosfrom BETWEEN es.effdate AND  es.termdate
	WHERE 1=1
		AND c.claimid IN ( '24243E04359', '24159E02651A1', '24155E10848A1' )
	); -- CONCLUDE 

	





-- =====================================================
	-- MULTI - DATABASE OBJECT SEARCH TEMPLATE: 
-- =====================================================
DECLARE @SearchText NVARCHAR(MAX) = 'paid';  -- Text to search for DEANumber, CONTRACTING_, primarystatus, uvw_JusticeInvolvedIndicator, Marketer, Grievance
DECLARE @ExactMatchST BIT = 0;               -- SET AS 1 FOR for exact matches AND NULL @PARAM
DECLARE @ObjectName NVARCHAR(MAX) = NULL;    -- Specific object name to search for (optional) uvw_BASELINE_MEMBERSHIP, CONTRACTING_
DECLARE @ExactMatchON BIT = 1;               -- SET AS 1 FOR for exact object name matches AND NULL @PARAM
DECLARE @SchemaName NVARCHAR(128) = NULL;     -- Limit search to specific schema (optional) magellan, dbo, ECM
DECLARE @ObjectType NVARCHAR(128) = NULL;    -- Limit to specific object type (optional)
DECLARE @IncludeSystemObjects BIT = 0;       -- SET AS 1 FOR TO include system objects

		SELECT ISNULL(@SearchText,'N/A') AS 'txt CHARINDEX() FIND() SEARCH()'
		,ISNULL(@ObjectName,'N/A') AS 'obj CHARINDEX() FIND() SEARCH()'
		,ISNULL(@SchemaName,'N/A') AS 'SCHEMA() CHARINDEX() FIND() SEARCH()'

-- Define databases to search (add or remove as needed)
DECLARE @DatabaseList TABLE (DatabaseName NVARCHAR(128))
INSERT INTO @DatabaseList (DatabaseName)
VALUES 
    ('INFORMATICS'), -- WORKING [db]
    ('HMOPROD_PLANDATA'), -- QNXT [db]
    ('EnrollmentManager'), -- 834 MEMBERSHIP
	('FINCHG'), -- FINANCE DEPT.	
    ('MemberPortal'),
    ('ProviderPortal'),
    ('CHGAPP_PROD'),	
	('evips_chgcv'), -- SERVER: SQLPRODAPP01 PROVIDER NETWORK SOURCE DATA
    ('ProviderRepository'), -- SERVER: SQLPRODAPP01 REPO
	('INFOAG'), -- SERVER: SQLPRODAPP01 LINKED SERVER TO SQLPROD02.INFORMATICS [db]
	('QPROD'),
    ('DATAWAREHOUSE'), -- LEGACY DW
    ('INFORMATICS2'), -- SQLPROD01.QPROD
    ('DIAMOND_Data');  -- LEGACY SYSTEM (D950) ... 
	
		SELECT ' ' AS '[db](s) TO QRY: ',* FROM @DatabaseList

-- Create a temporary table to store results
DROP TABLE IF EXISTS #SearchResults;

CREATE TABLE #SearchResults (
    DatabaseName NVARCHAR(128),
    ResultType NVARCHAR(50),
    SchemaName VARCHAR(128),
    ObjectName NVARCHAR(256),
    ObjectType NVARCHAR(128),
    ColumnName NVARCHAR(128) NULL,
    DataTypeInfo NVARCHAR(256) NULL,
    AdditionalInfo NVARCHAR(MAX) NULL,
    ModifiedDate DATETIME NULL
);

-- Prepare search patterns
DECLARE @SearchPattern NVARCHAR(MAX) = CASE 
    WHEN @ExactMatchST = 1 THEN @SearchText
    ELSE '%' + ISNULL(@SearchText, '') + '%'
END;

DECLARE @ObjectPattern NVARCHAR(MAX) = CASE 
    WHEN @ExactMatchON = 1 THEN @ObjectName
    ELSE '%' + ISNULL(@ObjectName, '') + '%'
END;

-- Cursor to loop through databases
DECLARE @CurrentDB NVARCHAR(128)
DECLARE @SQL NVARCHAR(MAX)
DECLARE db_cursor CURSOR FOR 
SELECT DatabaseName FROM @DatabaseList
OPEN db_cursor  
FETCH NEXT FROM db_cursor INTO @CurrentDB

WHILE @@FETCH_STATUS = 0  
BEGIN
    PRINT 'Processing database: ' + @CurrentDB;
    
    BEGIN TRY
        -- Check if database exists and is accessible
        /* SET @SQL = N'IF DB_ID(''' + @CurrentDB + ''') IS NOT NULL 
                   BEGIN
                       USE ' + QUOTENAME(@CurrentDB) + ';
                       SELECT 1 AS [db CHECK];
                   END
                   ELSE
                   BEGIN
                       RAISERROR(''Database does not exist or is not accessible'', 16, 1);
                   END'; */
                   
        EXEC sp_executesql @SQL;
        
        -- 1. Search Object Definitions
        SET @SQL = N'
        USE ' + QUOTENAME(@CurrentDB) + N';
        
        INSERT INTO #SearchResults (DatabaseName, ResultType, SchemaName, ObjectName, ObjectType, AdditionalInfo, ModifiedDate)
        SELECT DISTINCT ''' + @CurrentDB + N''',
            ''Object Definition'', 
            SCHEMA_NAME(o.schema_id), 
            o.name, 
            ISNULL(o.type_desc,NULL),
            LEFT(m.definition, 100) + ''...'',
            o.modify_date
        FROM sys.sql_modules AS m
            INNER JOIN sys.objects AS o ON m.object_id = o.object_id
        WHERE 1=1
            AND (' + CASE WHEN @SchemaName IS NULL THEN N'1=1' ELSE N'SCHEMA_NAME(o.schema_id) = @SchemaName COLLATE DATABASE_DEFAULT' END + N')
            AND (' + CASE WHEN @ObjectType IS NULL THEN N'1=1' ELSE N'o.type_desc LIKE @ObjectType COLLATE DATABASE_DEFAULT' END + N')
            AND (' + CASE WHEN @IncludeSystemObjects = 1 THEN N'1=1' ELSE N'o.is_ms_shipped = 0' END + N')
            AND (m.definition LIKE @SearchPattern COLLATE DATABASE_DEFAULT OR o.name LIKE @ObjectPattern COLLATE DATABASE_DEFAULT)
            AND o.name NOT LIKE ''sp_MS%'';
            
        -- 2. Search Columns
        INSERT INTO #SearchResults (DatabaseName, ResultType, SchemaName, ObjectName, ObjectType, ColumnName, DataTypeInfo, AdditionalInfo)
        SELECT DISTINCT ''' + @CurrentDB + N''',
            ''Column'',
            c.TABLE_SCHEMA,
            c.TABLE_NAME,
            CAST(NULL AS nvarchar(128)),
            c.COLUMN_NAME,
            c.DATA_TYPE + 
                CASE 
                    WHEN c.CHARACTER_MAXIMUM_LENGTH IS NOT NULL 
                    THEN ''('' + CAST(c.CHARACTER_MAXIMUM_LENGTH AS VARCHAR(10)) + '')''
                    ELSE ''''
                END,
            ''Nullable: '' + c.IS_NULLABLE
        FROM INFORMATION_SCHEMA.COLUMNS AS c
            JOIN INFORMATION_SCHEMA.TABLES AS t ON c.TABLE_NAME = t.TABLE_NAME 
                AND c.TABLE_SCHEMA = t.TABLE_SCHEMA
        WHERE 1=1
            AND (' + CASE WHEN @SchemaName IS NULL THEN N'1=1' ELSE N'c.TABLE_SCHEMA = @SchemaName COLLATE DATABASE_DEFAULT' END + N')
            AND (c.COLUMN_NAME LIKE @SearchPattern COLLATE DATABASE_DEFAULT OR c.TABLE_NAME LIKE @ObjectPattern COLLATE DATABASE_DEFAULT);
            
        -- 3. Search Tables
        INSERT INTO #SearchResults (DatabaseName, ResultType, SchemaName, ObjectName, ObjectType)
        SELECT DISTINCT ''' + @CurrentDB + N''',
            ''TABLE'',
            t.TABLE_SCHEMA,
            t.TABLE_NAME,
            t.TABLE_TYPE
        FROM INFORMATION_SCHEMA.TABLES AS t
        WHERE 1=1
            AND (' + CASE WHEN @SchemaName IS NULL THEN N'1=1' ELSE N't.TABLE_SCHEMA = @SchemaName COLLATE DATABASE_DEFAULT' END + N')
            AND t.TABLE_NAME LIKE @ObjectPattern COLLATE DATABASE_DEFAULT;
            
        -- 4. Search Indexes
        INSERT INTO #SearchResults (DatabaseName, ResultType, SchemaName, ObjectName, ColumnName, DataTypeInfo, AdditionalInfo)
        SELECT DISTINCT ''' + @CurrentDB + N''',
            ''Index'',
            SCHEMA_NAME(t.schema_id),
            t.name,
            i.name,
            i.type_desc,
            ''Is Unique: '' + CASE WHEN i.is_unique = 1 THEN ''Yes'' ELSE ''No'' END
        FROM sys.indexes AS i
            INNER JOIN sys.tables AS t ON i.object_id = t.object_id
        WHERE 1=1
            AND (' + CASE WHEN @SchemaName IS NULL THEN N'1=1' ELSE N'SCHEMA_NAME(t.schema_id) = @SchemaName COLLATE DATABASE_DEFAULT' END + N')
            AND (i.name LIKE @SearchPattern COLLATE DATABASE_DEFAULT OR t.name LIKE @ObjectPattern COLLATE DATABASE_DEFAULT)
            AND i.name IS NOT NULL;';
            
        EXEC sp_executesql @SQL, 
            N'@SearchPattern NVARCHAR(MAX), @ObjectPattern NVARCHAR(MAX), @SchemaName NVARCHAR(128), @ObjectType NVARCHAR(128)',
            @SearchPattern, @ObjectPattern, @SchemaName, @ObjectType;
            
    END TRY
    BEGIN CATCH
        PRINT 'Error processing database ' + @CurrentDB + ': ' + ERROR_MESSAGE();
        
        -- Optional: Insert error information into the results
        INSERT INTO #SearchResults (DatabaseName, ResultType, AdditionalInfo)
        VALUES (@CurrentDB, 'ERROR', 'Failed to process: ' + ERROR_MESSAGE());
    END CATCH
    
    -- Next database
    FETCH NEXT FROM db_cursor INTO @CurrentDB
END

CLOSE db_cursor  
DEALLOCATE db_cursor

-- =====================================================
	-- Display Results
-- =====================================================
SELECT ' ' AS 'Summary counts by database and result type',
DatabaseName,
ResultType, 
COUNT(*) AS TotalFound
FROM #SearchResults
GROUP BY DatabaseName, ResultType
ORDER BY DatabaseName, ResultType;

/* SELECT ' ' AS 'Column results for easier analysis',*
FROM #SearchResults
WHERE 1=1
	AND ResultType = 'Column'
ORDER BY DatabaseName, SchemaName, ObjectName, ColumnName; */

SELECT ' ' AS 'All detailed results',*
FROM #SearchResults
ORDER BY DatabaseName, ResultType, SchemaName, ObjectName;

-- DROP TABLE IF EXISTS #SearchResults; -- POWER CYCLE RESET REFRESH RESTART ...







-- =====================================================
-- IMPROVED DATABASE OBJECT SEARCH TEMPLATE: 
-- =====================================================
USE HMOPROD_PLANDATA; -- Set your target database

DECLARE @SearchText NVARCHAR(MAX) = 'primarystatus';  -- Text to search for DEANumber, CONTRACTING_, primarystatus
DECLARE @ExactMatchST BIT = 0;                        -- SET AS 1 FOR for exact matches AND NULL @PARAM
DECLARE @ObjectName NVARCHAR(MAX) = NULL;             -- Specific object name to search for (optional)
DECLARE @ExactMatchON BIT = 1;                        -- SET AS 1 FOR for exact object name matches AND NULL @PARAM
DECLARE @SchemaName NVARCHAR(128) = NULL;             -- Limit search to specific schema (optional)
DECLARE @ObjectType NVARCHAR(128) = NULL;             -- Limit to specific object type (optional)
DECLARE @IncludeSystemObjects BIT = 0;                -- SET AS 1 FOR TO include system objects

-- Create a temporary table to store results
DROP TABLE IF EXISTS #SearchResults;

CREATE TABLE #SearchResults (
    ResultType NVARCHAR(50),
    SchemaName NVARCHAR(128),
    ObjectName NVARCHAR(256),
    ObjectType NVARCHAR(128),
    ColumnName NVARCHAR(128) NULL,
    DataTypeInfo NVARCHAR(256) NULL,
    AdditionalInfo NVARCHAR(MAX) NULL,
    ModifiedDate DATETIME NULL
);

-- Prepare search patterns
DECLARE @SearchPattern NVARCHAR(MAX) = CASE 
    WHEN @ExactMatchST = 1 THEN @SearchText
    ELSE '%' + ISNULL(@SearchText, '') + '%'
END;

DECLARE @ObjectPattern NVARCHAR(MAX) = CASE 
    WHEN @ExactMatchON = 1 THEN @ObjectName
    ELSE '%' + ISNULL(@ObjectName, '') + '%'
END;

-- =====================================================
-- 1. Search Object Definitions
-- =====================================================
INSERT INTO #SearchResults (ResultType, SchemaName, ObjectName, ObjectType, AdditionalInfo, ModifiedDate)
SELECT DISTINCT 'Object Definition', 
    SCHEMA_NAME(o.schema_id), 
    o.name, 
    ISNULL(o.type_desc,'TABLE'),
    LEFT(m.definition, 100) + '...',
    o.modify_date
FROM sys.sql_modules AS m
    INNER JOIN sys.objects AS o ON m.object_id = o.object_id
WHERE 1=1
    AND (@SchemaName IS NULL OR SCHEMA_NAME(o.schema_id) = @SchemaName)
    AND (@ObjectType IS NULL OR o.type_desc LIKE @ObjectType)
    AND (@IncludeSystemObjects = 1 OR o.is_ms_shipped = 0)
    AND (m.definition LIKE @SearchPattern OR o.name LIKE @ObjectPattern)
    AND o.name NOT LIKE 'sp_MS%';

-- =====================================================
-- 2. Search Columns 
-- =====================================================
INSERT INTO #SearchResults (ResultType, SchemaName, ObjectName, ObjectType, ColumnName, DataTypeInfo, AdditionalInfo)
SELECT DISTINCT 
    'Column',
    c.TABLE_SCHEMA,
    c.TABLE_NAME,
	TRY_CONVERT(nvarchar(128),'TABLE'),
    c.COLUMN_NAME,
    c.DATA_TYPE + 
        CASE 
            WHEN c.CHARACTER_MAXIMUM_LENGTH IS NOT NULL 
            THEN '(' + CAST(c.CHARACTER_MAXIMUM_LENGTH AS VARCHAR(10)) + ')'
            ELSE ''
        END,
    'Nullable: ' + c.IS_NULLABLE
FROM INFORMATION_SCHEMA.COLUMNS AS c
    JOIN INFORMATION_SCHEMA.TABLES AS t ON c.TABLE_NAME = t.TABLE_NAME 
        AND c.TABLE_SCHEMA = t.TABLE_SCHEMA
WHERE 1=1
    AND (@SchemaName IS NULL OR c.TABLE_SCHEMA = @SchemaName)
    AND (c.COLUMN_NAME LIKE @SearchPattern OR c.TABLE_NAME LIKE @ObjectPattern);

-- =====================================================
-- 3. Search Tables by name
-- =====================================================
INSERT INTO #SearchResults (ResultType, SchemaName, ObjectName)
SELECT DISTINCT 
    'Table',
    t.TABLE_SCHEMA,
    t.TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES AS t
WHERE 1=1
    AND (@SchemaName IS NULL OR t.TABLE_SCHEMA = @SchemaName)
    AND t.TABLE_NAME LIKE @ObjectPattern;

-- =====================================================
-- 4. Search Indexes
-- =====================================================
INSERT INTO #SearchResults (ResultType, SchemaName, ObjectName, ColumnName, DataTypeInfo, AdditionalInfo)
SELECT DISTINCT 
    'Index',
    SCHEMA_NAME(t.schema_id),
    t.name,
    i.name,
    i.type_desc,
    'Is Unique: ' + CASE WHEN i.is_unique = 1 THEN 'Yes' ELSE 'No' END
FROM sys.indexes AS i
    INNER JOIN sys.tables AS t ON i.object_id = t.object_id
WHERE 1=1
    AND (@SchemaName IS NULL OR SCHEMA_NAME(t.schema_id) = @SchemaName)
    AND (i.name LIKE @SearchPattern OR t.name LIKE @ObjectPattern)
    AND i.name IS NOT NULL;

-- =====================================================
-- Display Results
-- =====================================================
SELECT ' ' AS 'Summary counts by result type',
ResultType, 
COUNT(*) AS TotalFound
FROM #SearchResults
GROUP BY ResultType
ORDER BY ResultType;

SELECT ' ' AS 'All detailed results', * 
FROM #SearchResults
ORDER BY ResultType, SchemaName, ObjectName;

SELECT ' ' AS 'Column results for easier analysis',*
FROM #SearchResults
WHERE ResultType = 'Column'
ORDER BY SchemaName, ObjectName, ColumnName;

DROP TABLE IF EXISTS #SearchResults; -- POWER CYCLE RESET REFRESH RESTART ... 







-- =====================================================
	-- DATABASE DEPENDENCY SEARCH TEMPLATE: 
-- =====================================================
	-- Validate inputs
IF @ObjectName IS NULL AND @SearchText IS NULL
BEGIN
    RAISERROR('Either @ObjectName or @SearchText must be provided', 16, 1);
    RETURN;
END

-- =====================================================
	-- 1. Direct Dependencies (Parent → Child)
-- =====================================================
SELECT DISTINCT 'Dependent Objects' AS SearchType,
    OBJECT_SCHEMA_NAME(sed.referencing_id) AS ReferencingSchema,
    OBJECT_NAME(sed.referencing_id) AS ReferencingObject,
    o.type_desc AS ReferencingObjectType,
    OBJECT_SCHEMA_NAME(sed.referenced_id) AS ReferencedSchema,
    OBJECT_NAME(sed.referenced_id) AS ReferencedObject,
    sed.referenced_database_name AS ReferencedDatabase,
    sed.referenced_schema_name AS ReferencedSchemaName,
    sed.referenced_entity_name AS ReferencedEntityName
FROM sys.sql_expression_dependencies sed
INNER JOIN sys.objects AS o 
    ON sed.referencing_id = o.object_id
WHERE 1=1
	AND  (@SchemaName IS NULL 
    OR OBJECT_SCHEMA_NAME(sed.referencing_id) = @SchemaName
    OR OBJECT_SCHEMA_NAME(sed.referenced_id) = @SchemaName)
    AND (@ObjectName IS NULL 
    OR OBJECT_NAME(sed.referencing_id) LIKE @ObjectName
    OR OBJECT_NAME(sed.referenced_id) LIKE @ObjectName)
ORDER BY ReferencingSchema,ReferencingObject;

-- =====================================================
	-- 2. Reverse Dependencies (Child → Parent)
-- =====================================================
SELECT DISTINCT 'Referenced By' AS SearchType,
    OBJECT_SCHEMA_NAME(sed.referenced_id) AS ReferencedSchema,
    OBJECT_NAME(sed.referenced_id) AS ReferencedObject,
    o.type_desc AS ReferencedObjectType,
    OBJECT_SCHEMA_NAME(sed.referencing_id) AS ReferencingSchema,
    OBJECT_NAME(sed.referencing_id) AS ReferencingObject
FROM sys.sql_expression_dependencies sed
	INNER JOIN sys.objects AS o ON sed.referenced_id = o.object_id
WHERE 1=1
	AND (@SchemaName IS NULL 
    OR OBJECT_SCHEMA_NAME(sed.referenced_id) = @SchemaName)
    AND (@ObjectName IS NULL 
    OR OBJECT_NAME(sed.referenced_id) LIKE @ObjectName)
ORDER BY ReferencedSchema,ReferencedObject;

-- =====================================================
	-- 3. Search Within Object Definitions
-- =====================================================
IF @SearchText IS NOT NULL
BEGIN
    SELECT DISTINCT 'Definition References' AS SearchType,
        SCHEMA_NAME(o.schema_id) AS ObjectSchema,
        o.name AS ObjectName,
        o.type_desc AS ObjectType,
        m.definition AS ObjectDefinition
    FROM sys.sql_modules AS m
		INNER JOIN sys.objects AS o ON m.object_id = o.object_id
    WHERE 1=1
		AND m.definition LIKE '%' + @SearchText + '%'
        AND (@SchemaName IS NULL 
            OR SCHEMA_NAME(o.schema_id) = @SchemaName)
    ORDER BY ObjectSchema,ObjectName;
END

-- =====================================================
	-- 4. Column Dependencies
-- =====================================================
SELECT DISTINCT 'Column References' AS SearchType,
    OBJECT_SCHEMA_NAME(fc.parent_object_id) AS ReferencingSchema,
    OBJECT_NAME(fc.parent_object_id) AS ReferencingTable,
    c1.name AS ReferencingColumn,
    OBJECT_SCHEMA_NAME(fc.referenced_object_id) AS ReferencedSchema,
    OBJECT_NAME(fc.referenced_object_id) AS ReferencedTable,
    c2.name AS ReferencedColumn
FROM sys.foreign_keys fk
	INNER JOIN sys.foreign_key_columns fc ON fk.object_id = fc.constraint_object_id
	INNER JOIN sys.COLUMNS AS c1 ON fc.parent_object_id = c1.object_id 
		AND fc.parent_column_id = c1.column_id
	INNER JOIN sys.COLUMNS AS c2 ON fc.referenced_object_id = c2.object_id 
		AND fc.referenced_column_id = c2.column_id
WHERE 1=1
	AND (@SchemaName IS NULL 
		OR OBJECT_SCHEMA_NAME(fc.parent_object_id) = @SchemaName
		OR OBJECT_SCHEMA_NAME(fc.referenced_object_id) = @SchemaName)
    AND (@ObjectName IS NULL 
		OR OBJECT_NAME(fc.parent_object_id) LIKE @ObjectName
		OR OBJECT_NAME(fc.referenced_object_id) LIKE @ObjectName)
ORDER BY ReferencingSchema,ReferencingTable;

-- =====================================================
-- 5. Stored Procedure Parameter Dependencies
-- =====================================================
SELECT DISTINCT 'Parameter References' AS SearchType,
    SCHEMA_NAME(o.schema_id) AS ProcedureSchema,
    o.name AS ProcedureName,
    p.name AS ParameterName,
    TYPE_NAME(p.user_type_id) AS ParameterType,
    p.max_length AS ParameterLength,
    p.is_output AS IsOutput
FROM sys.parameters p
	INNER JOIN sys.objects AS o ON p.object_id = o.object_id
WHERE 1=1
	AND (@SchemaName IS NULL 
		OR SCHEMA_NAME(o.schema_id) = @SchemaName)
    AND (@ObjectName IS NULL 
		OR o.name LIKE @ObjectName);
-- ORDER BY ProcedureSchema,ProcedureName,p.parameter_id;







-- ============================================================
		-- HUNT SSRS (SQL SERVER REPORTING SERVICE): 
-- ============================================================
DECLARE @months_to_look_back AS decimal(9,0) = 12

SELECT report_id
,report_name
,COUNT(1) / (DATEDIFF(month,MIN(report_run_date),GETDATE())+1) AS avg_number_of_times_report_run_per_month
,MAX(report_run_date) AS most_recent_run
,MAX(CASE
WHEN report_exec_order_newest_first = 1 
THEN report_run_by
ELSE NULL
END
) AS most_recently_run_by
,report_last_modified_date
,report_last_modified_by
,CAST(AVG(report_query_time_milliseconds) AS decimal(28,12)) / 60000 AS average_query_time_in_mins2
,report_path
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st',
FROM Informatics.core.ssrs_usage
WHERE 1=1
	AND report_run_date IS NOT NULL
	AND report_is_owned_by_Informatics = 'yes'
	AND report_run_date > DATEADD(month,-@months_to_look_back,GETDATE())
GROUP BY report_id
,report_path
,report_name
,report_last_modified_date
,report_last_modified_by
,report_is_owned_by_Informatics
ORDER BY COUNT(1) / (DATEDIFF(month,MIN(report_run_date),GETDATE())+1) DESC;







-- ============================================================
		-- HUNT SSA (SQL SERVER AGENT JOBS): 
-- ============================================================
USE INFORMATICS

DECLARE @hunt nvarchar(255) = '%Finance%'; 
DECLARE @server nvarchar(255) = '%SSISPROD01%'; 

SELECT ' ' AS 'WHICH SQL Server Agent Job is calling the SSIS package',
'EXEC IN '+@server AS [MESSAGE],
j.name AS JobName,
js.step_id AS StepID,
js.step_name AS StepName,
js.commAND AS Command,
j.enabled AS JobEnabled,
js.subsystem AS StepType
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st',
FROM msdb.dbo.sysjobs AS j
	JOIN msdb.dbo.sysjobsteps AS js ON j.job_id = js.job_id
WHERE 1=1
	AND j.enabled = 1
	AND js.subsystem = 'SSIS'
	AND js.commAND LIKE @hunt
	   --OR js.step_name LIKE '%Inventory%'
	   --OR j.name LIKE '%Inventory%'
ORDER BY j.name, js.step_id;	







-- ============================================================
		-- HUNT SSRS SUBSCRIPTION(S): 
-- ============================================================
USE ReportServerHMO_New -- 'see "http://prodqssrs.chg.com/Reports/manage/catalogitem/properties/Informatics/_General/SSRS%20Subscription%20Issues%20-%20Reports%20Not%20Using%20Service%20Account"'

SELECT ' ' AS 'SSRS SUBSCRIPTION SEARCH(): ',
c.Name AS ReportName,
s.SubscriptionID,
s.Description AS SubscriptionDescription,
u.UserName AS SubscriptionOwner,
c.Path AS ReportPath,
s.LastStatus,
CASE 
WHEN s.InactiveFlags <> 0 THEN 'Disabled'
ELSE 'Enabled'
END AS SubscriptionStatus,
'CHG\svc-ssrs-datasources' AS Service_Account
FROM ReportServerHMO_New.dbo.Subscriptions AS s
	JOIN ReportServerHMO_New.dbo.Catalog AS c ON s.Report_OID = c.ItemID
	JOIN ReportServerHMO_New.dbo.Users AS u ON s.OwnerID = u.UserID
	JOIN ReportServerHMO_New.dbo.ReportSchedule AS rs ON s.SubscriptionID = rs.SubscriptionID
	JOIN ReportServerHMO_New.dbo.Schedule AS sch ON rs.ScheduleID = sch.ScheduleID
WHERE 1=1
	AND (u.UserName <> 'CHG\svc-ssrs-datasources' AND u.UserName <> 'CHG\qnxtadmin')  
	AND c.Path LIKE '/Informatics/%'  
	AND s.EventType = 'TimedSubscription'-- Filter by Enabled Subscriptions
	AND CASE 
	WHEN s.InactiveFlags <> 0 
	THEN 'Disabled'
	ELSE 'Enabled'
	END='Enabled'
ORDER BY c.Name, s.SubscriptionID;







-- ============================================================
		-- HUNT FOR DEPENDENCIES: 
-- ============================================================
USE Informatics; -- Change this to your target database

	-- Declare server AND database variables
	-- Note: Server name usage here is illustrative; dynamic cross-server queries require linked servers or external scripts.
	-- Update the following variables AS needed for your search criteria
	
/* DECLARE @ServerName nvarchar(255) = N'INFORMATIONAL ONLY'; -- This is more FOR: documentation AS we can't switch servers within a script ... The dynamic SQL (@SQL) is constructed to incorporate the database AND schema names into the script. This approach is necessary because T-SQL does not allow the direct use of variables in certain statements (e.g., USE, schema names in queries). */
DECLARE @DatabaseName nvarchar(255) =  'ProviderPortal'; 
DECLARE @SchemaName nvarchar(255) =  '%%%'; -- Specify the schema name here
-- DECLARE @ObjectName nvarchar(255) = 'dbo.CMCSummary'; -- Specify your object name here
DECLARE @ObjectName nvarchar(255) = '%%%'; -- Specify your object name here ... '%'+'...'+'%'
DECLARE @SearchText nvarchar(255) = '%TargetPopulationId%'; -- Text to search FOR: in object definitions AND column names ... '%'+'...'+'%'

		SELECT ' ' AS  'CHARINDEX() FIND() SEARCH()  4 PART SCHEMA(): "SERVERname"."DATABASEname"."SCHEMAname"."OBJECTname"'

DECLARE @SQL nvarchar(255);

	-- Dynamic SQL to switch database context (Note: USE statement cannot use variable directly)
SET @SQL = N'USE [' + @DatabaseName + '];'+ 

'-- Your SQL script here, for example:
SELECT DB_NAME() AS CurrentDatabase; -- This will show the database name AS a demonstration of dynamic SQL execution

-- Insert the rest of your SQL script here

-- Dynamic SQL script including schema variable
DECLARE @ObjectName NVARCHAR(MAX) = N''YourObjectName''; -- Specify the object name

-- Example: Searching in object definitions (procedures, functions, views, etc.) within the specified schema
SELECT 
    o.name AS ObjectName,
    o.type_desc AS ObjectType,
    m.definition AS ObjectDefinition
FROM sys.sql_modules AS m
JOIN sys.objects AS o ON m.object_id = o.object_id
WHERE m.definition LIKE N''%' + @SchemaName + N'.YourObjectName%'' -- Adjust this LIKE pattern AS needed
AND SCHEMA_NAME(o.schema_id) = ''' + @SchemaName + N'''
ORDER BY o.name;

-- You can add more queries here that utilize the @SchemaName variable';

-- Execute the dynamic SQL
EXEC sp_executesql @SQL;

-- Note: This script demonstrates how to incorporate a schema name dynamically into SQL operations.
-- Remember to replace placeholders like YourServerName, YourDatabaseName, YourSchemaName, AND YourObjectName
-- with actual values relevant to your use case.

-- FOR: operations that need to be conducted ON a specific database directly
-- you can embed them within dynamic SQL statements AS shown above.

-- Note: Directly changing server context within a T-SQL script executed ON SQL Server is not possible.
-- FOR: operations across servers, consider using linked servers AND four-part names or openquery, or manage cross-server execution within application logic or SQL Server Management Studio (SSMS) scripts.

	-- Objects that depend upon @ObjectName, filtered by schema
SELECT DISTINCT 'Objects that depend upon ' + @ObjectName AS DependencyType,
    referencing_schema_name, 
    referencing_entity_name
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st',
FROM sys.dm_sql_referencing_entities(QUOTENAME(@SchemaName) + '.' + QUOTENAME(@ObjectName), 'OBJECT')
-- FROM sys.dm_sql_referencing_entities(QUOTENAME(@DatabaseName)+ '.' +QUOTENAME(@SchemaName) + '.' + QUOTENAME(@ObjectName), 'OBJECT')
WHERE 1=1
	AND referencing_schema_name = @SchemaName;

	-- objects AS oN which @ObjectName depends, filtered by schema
SELECT DISTINCT 'objects AS oN which ' + @ObjectName + ' depends' AS DependencyType,
    referenced_schema_name, 
    referenced_entity_name
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st',
FROM sys.dm_sql_referenced_entities(QUOTENAME(@SchemaName) + '.' + QUOTENAME(@ObjectName), 'OBJECT')
-- FROM sys.dm_sql_referenced_entities(QUOTENAME(@DatabaseName)+ '.' +QUOTENAME(@SchemaName) + '.' + QUOTENAME(@ObjectName), 'OBJECT')
WHERE 1=1
	AND referenced_schema_name = @SchemaName;

	-- Alternative method to find dependencies (using sys.sql_expression_dependencies), filtered by schema
SELECT DISTINCT 'objects AS oN which ' + @ObjectName + ' depends (alternative method)' AS DependencyType,
    OBJECT_SCHEMA_NAME(referencing_id) AS referencing_schema_name, 
    OBJECT_NAME(referencing_id) AS referencing_entity_name
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st',
FROM sys.sql_expression_dependencies
WHERE 1=1
	AND referencing_id = OBJECT_ID(QUOTENAME(@SchemaName) + '.' + QUOTENAME(@ObjectName))
	-- AND referencing_id = OBJECT_ID(QUOTENAME(@DatabaseName)+ '.' +QUOTENAME(@SchemaName) + '.' + QUOTENAME(@ObjectName))
AND OBJECT_SCHEMA_NAME(referencing_id) = @SchemaName;
