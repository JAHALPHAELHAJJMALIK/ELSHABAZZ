-- ==========================================================================
	-- NEMT' (Non-Emergency Medical Transportation) Missing  'PCS' (Physician Certification Statement): 
-- ==========================================================================
		/* 2.	PCS Form Verification 
				✓ Checks CHGNXT portal via CHGNXT.nemt.Transportation 
				✓ Confirms Case Manager approval: CaseManagerApproved = 1 -- WHERE MISSING the PCS FORM FOR TRANSPORTATION 
				
Sir FYI this report (NEMT PCS Form by ECM Provider) came up in the UM Weekly Meeting with Sir Yousaf. Ms Kelly mentioned that you were working on a report as well. 
 
This particular ask may become more of a manual effort than hoped, with your efforts serving as the starting point.
 
As context whenever this 'PCS' form is submitted via the Provider Portal it is being auto approved as an auth. The concern is that ECM providers are submitting the form on behalf of the Member's PCP which is a no no ... 
 
The PCP should be submitting & signing the form directly. The ECM provider should only be coordinating that action. 
 
How 'we' track / quantify that from a data perspective now is the outstanding question. */

SELECT DISTINCT ' ' AS 'PCS (Physician Certification Statement) FORM FOR TRANSPORTATION: '
,chgnxtt.TransportationModeType
,chgnxtt.MemberID AS [memid]
,chgnxtt.MemberAddress1
,chgnxtt.MemberAddress2
,chgnxtt.MemberCity
,chgnxtt.MemberZip
,chgnxtt.MemberEmail
,chgnxtt.MemberPhone
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st',CaseManagerApproved -- 0,1		
FROM CHGNXT.nemt.Transportation AS chgnxtt
WHERE 1=1 
	AND ISNULL(chgnxtt.CaseManagerApproved,0) = 1 -- WHERE MISSING the PCS FORM FOR TRANSPORTATION
	-- AND ISNULL(chgnxtt.CaseManagerApproved,0) = 0 -- SELF APPROVED BY PROVIDER???
	
		SELECT * FROM ProviderPortal.dbo.PCSFormSubmitters
		SELECT * FROM ProviderPortal.dbo.ProviderUsersNames

SELECT pcs.*
,ui.ProvId
,ui.Providername
,chgnxtt.TransportationModeType
,chgnxtt.MemberID AS [memid]
,chgnxtt.MemberAddress1
,chgnxtt.MemberAddress2
,chgnxtt.MemberCity
,chgnxtt.MemberZip
,chgnxtt.MemberEmail
,chgnxtt.MemberPhone
FROM ProviderPortal.dbo.PCSFormSubmitters AS pcs
	INNER JOIN ProviderPortal.dbo.ProviderUsersNames AS ui ON pcs.UserId = ui.UserId
	INNER JOIN CHGNXT.nemt.Transportation AS chgnxtt ON pcs.TransportationId = chgnxtt.TransportationId
WHERE 1=1 
	-- AND ISNULL(chgnxtt.CaseManagerApproved,0) = 1 -- WHERE MISSING the PCS FORM FOR TRANSPORTATION
	AND ISNULL(chgnxtt.CaseManagerApproved,0) = 0 -- SELF APPROVED BY PROVIDER???

		SELECT * FROM INFORMATICS.dbo.uvw_ECM_CAPACITY ORDER BY provider_organization_name;
		SELECT * FROM INFORMATICS.dbo.uvw_CS_CAPACITY ORDER BY provider_organization_name, community_support_offered; 

		SELECT DISTINCT provider_type FROM INFORMATICS.dbo.uvw_ECM_CAPACITY
		SELECT DISTINCT provider_type FROM INFORMATICS.dbo.uvw_CS_CAPACITY

-- =====================================================
		-- MULTI - [db] DATABASE OBJECT SEARCH TEMPLATE: 
-- =====================================================
DECLARE @SearchText NVARCHAR(MAX) = 'UserID' -- 'PCS'; -- Text to search FOR: DEANumber, CONTRACTING_, primarystatus, uvw_JusticeInvolvedIndicator, Marketer, Grievance, paid, LTCFacilityType, % Vari, ReportingCounts magellan, dbo, ECM, EcmJson ... IGNORE CASE SENSITIVITY
DECLARE @ExactMatchST BIT = 0; -- SET AS 1 WHEN NULL OR FOR an exact match ON @PARAM
DECLARE @ObjectName NVARCHAR(MAX) = NULL; -- Keep broad for object names
DECLARE @ExactMatchON BIT = 1; -- SET AS 1 WHEN NULL OR FOR an exact match ON @PARAM
DECLARE @SchemaName NVARCHAR(128) = NULL; -- Target schema (optional) 
DECLARE @ObjectType NVARCHAR(128) = NULL; -- All object types (optional) 
DECLARE @IncludeSystemObjects BIT = 0;   -- INCLUSION OR EXCLUSION OF system objects

		SELECT ISNULL(@SearchText,'N/A') AS 'Search Text'
		,ISNULL(@ObjectName,'N/A') AS 'Object Name'
		,ISNULL(@SchemaName,'N/A') AS 'Schema Name';

-- Define [db] to search
DECLARE @DatabaseList TABLE (DatabaseName NVARCHAR(128))

INSERT INTO @DatabaseList (DatabaseName)
VALUES 
	('CHGNXT'), -- SQLPROD01.QPROD
	('ProviderPortal'); -- QNXT 'User'

		SELECT ' ' AS '[db](s) to Query:', * 
		FROM @DatabaseList;

-- Create results table
DROP TABLE IF EXISTS #SearchResults;
CREATE TABLE #SearchResults (
    DatabaseName NVARCHAR(128),
    ResultType NVARCHAR(50),
    SchemaName NVARCHAR(128),
    ObjectName NVARCHAR(256),
    ObjectType NVARCHAR(128),
    ColumnName NVARCHAR(128) NULL,
    DataTypeInfo NVARCHAR(256) NULL,
    AdditionalInfo NVARCHAR(MAX) NULL,
    ModifiedDate DATETIME NULL,
	DefinitionText NVARCHAR(MAX) NULL
);

-- Prepare search patterns
DECLARE @SearchPattern NVARCHAR(MAX) = CASE 
    WHEN @SearchText IS NULL THEN '%'
    WHEN @ExactMatchST = 1 THEN @SearchText
    ELSE '%' + @SearchText + '%'
END;

DECLARE @ObjectPattern NVARCHAR(MAX) = CASE 
    WHEN @ObjectName IS NULL THEN '%'
    WHEN @ExactMatchON = 1 THEN @ObjectName
    ELSE '%' + @ObjectName + '%'
END;

PRINT 'Search Pattern: ' + @SearchPattern;
PRINT 'Object Pattern: ' + @ObjectPattern;

-- Process each [db]
DECLARE @CurrentDB NVARCHAR(128);
DECLARE @SQL NVARCHAR(MAX);

DECLARE db_cursor CURSOR FOR 
SELECT DatabaseName FROM @DatabaseList;

OPEN db_cursor;
FETCH NEXT FROM db_cursor INTO @CurrentDB;

WHILE @@FETCH_STATUS = 0  
BEGIN
    PRINT 'Processing database: ' + @CurrentDB;
    
    BEGIN TRY
        -- **KEY FIX: Properly qualify all object references**
        SET @SQL = N'
        -- 1. Search Object Definitions
        INSERT INTO #SearchResults (DatabaseName, ResultType, SchemaName, ObjectName, ObjectType, AdditionalInfo, ModifiedDate,DefinitionText)
        SELECT DISTINCT ''' + @CurrentDB + N''',
            ''Object Definition'', 
            SCHEMA_NAME(o.schema_id), 
            o.name, 
            o.type_desc,
            LEFT(ISNULL(m.definition, ''No definition''), 100) + ''...'',
            o.modify_date,
			m.definition AS [DefinitionText]
        FROM ' + QUOTENAME(@CurrentDB) + N'.sys.objects AS o
            LEFT JOIN ' + QUOTENAME(@CurrentDB) + N'.sys.sql_modules AS m ON o.object_id = m.object_id
        WHERE 1=1
            AND (' + CASE WHEN @SchemaName IS NULL THEN N'1=1' ELSE N'SCHEMA_NAME(o.schema_id) = ''' + @SchemaName + N'''' END + N')
            AND (' + CASE WHEN @ObjectType IS NULL THEN N'1=1' ELSE N'o.type_desc LIKE ''' + @ObjectType + N'''' END + N')
            AND (' + CASE WHEN @IncludeSystemObjects = 1 THEN N'1=1' ELSE N'o.is_ms_shipped = 0' END + N')
            AND (
                o.name LIKE ''' + @SearchPattern + N''' OR 
                o.name LIKE ''' + @ObjectPattern + N''' OR
                m.definition LIKE ''' + @SearchPattern + N'''
            )
            AND o.name NOT LIKE ''sp_MS%'';
            
        -- 2. Search Tables via INFORMATION_SCHEMA
        INSERT INTO #SearchResults (DatabaseName, ResultType, SchemaName, ObjectName, ObjectType)
        SELECT DISTINCT ''' + @CurrentDB + N''',
            ''Table'',
            t.TABLE_SCHEMA,
            t.TABLE_NAME,
            t.TABLE_TYPE
        FROM ' + QUOTENAME(@CurrentDB) + N'.INFORMATION_SCHEMA.TABLES AS t
        WHERE 1=1
            AND (' + CASE WHEN @SchemaName IS NULL THEN N'1=1' ELSE N't.TABLE_SCHEMA = ''' + @SchemaName + N'''' END + N')
            AND (
                t.TABLE_NAME LIKE ''' + @SearchPattern + N''' OR
                t.TABLE_NAME LIKE ''' + @ObjectPattern + N'''
            );
            
        -- 3. Search Columns via INFORMATION_SCHEMA  
        INSERT INTO #SearchResults (DatabaseName, ResultType, SchemaName, ObjectName, ObjectType, ColumnName, DataTypeInfo, AdditionalInfo)
        SELECT DISTINCT ''' + @CurrentDB + N''',
            ''Column'',
            c.TABLE_SCHEMA,
            c.TABLE_NAME,
            t.TABLE_TYPE,
            c.COLUMN_NAME,
            c.DATA_TYPE + 
                CASE 
                    WHEN c.CHARACTER_MAXIMUM_LENGTH IS NOT NULL 
                    THEN ''('' + CAST(c.CHARACTER_MAXIMUM_LENGTH AS VARCHAR(10)) + '')''
                    ELSE ''''
                END,
            ''Nullable: '' + c.IS_NULLABLE
        FROM ' + QUOTENAME(@CurrentDB) + N'.INFORMATION_SCHEMA.COLUMNS AS c
            JOIN ' + QUOTENAME(@CurrentDB) + N'.INFORMATION_SCHEMA.TABLES AS t 
                ON c.TABLE_NAME = t.TABLE_NAME AND c.TABLE_SCHEMA = t.TABLE_SCHEMA
        WHERE 1=1
            AND (' + CASE WHEN @SchemaName IS NULL THEN N'1=1' ELSE N'c.TABLE_SCHEMA = ''' + @SchemaName + N'''' END + N')
            AND (
                c.COLUMN_NAME LIKE ''' + @SearchPattern + N''' OR 
                c.TABLE_NAME LIKE ''' + @SearchPattern + N''' OR
                c.TABLE_NAME LIKE ''' + @ObjectPattern + N'''
            );
            
        -- 4. Search Indexes
        INSERT INTO #SearchResults (DatabaseName, ResultType, SchemaName, ObjectName, ColumnName, DataTypeInfo, AdditionalInfo)
        SELECT DISTINCT ''' + @CurrentDB + N''',
            ''Index'',
            SCHEMA_NAME(t.schema_id),
            t.name,
            i.name,
            i.type_desc,
            ''Is Unique: '' + CASE WHEN i.is_unique = 1 THEN ''Yes'' ELSE ''No'' END
        FROM ' + QUOTENAME(@CurrentDB) + N'.sys.indexes AS i
            INNER JOIN ' + QUOTENAME(@CurrentDB) + N'.sys.tables AS t ON i.object_id = t.object_id
        WHERE 1=1
            AND (' + CASE WHEN @SchemaName IS NULL THEN N'1=1' ELSE N'SCHEMA_NAME(t.schema_id) = ''' + @SchemaName + N'''' END + N')
            AND (
                i.name LIKE ''' + @SearchPattern + N''' OR 
                t.name LIKE ''' + @SearchPattern + N''' OR
                t.name LIKE ''' + @ObjectPattern + N'''
            )
            AND i.name IS NOT NULL;';
            
        PRINT 'Executing search for: ' + @CurrentDB;
        EXEC sp_executesql @SQL;
        PRINT 'Successfully processed: ' + @CurrentDB;
            
    END TRY
    BEGIN CATCH
        PRINT 'Error processing database ' + @CurrentDB + ': ' + ERROR_MESSAGE();
        
        INSERT INTO #SearchResults (DatabaseName, ResultType, AdditionalInfo)
        VALUES (@CurrentDB, 'ERROR', 'Failed to process: ' + ERROR_MESSAGE());
    END CATCH
    
    FETCH NEXT FROM db_cursor INTO @CurrentDB;
END

CLOSE db_cursor;
DEALLOCATE db_cursor;

-- =====================================================
	-- DISPLAY RESULTS
-- =====================================================
SELECT ' ' AS 'Summary counts by database and result type',
DatabaseName,
ResultType, 
COUNT(*) AS TotalFound
FROM #SearchResults
GROUP BY DatabaseName, ResultType
ORDER BY DatabaseName, ResultType;

SELECT ' ' AS 'Summary counts by database and object type',
DatabaseName,
ObjectType, 
COUNT(*) AS TotalFound
FROM #SearchResults
GROUP BY DatabaseName, ObjectType
ORDER BY DatabaseName, ObjectType;

SELECT ' ' AS 'All detailed results (excluding errors)',*
FROM #SearchResults
WHERE 1=1
	AND NOT ISNULL(ResultType,'') = 'ERROR'  -- NO NOT NEGATIVE <> != ...
	-- AND ISNULL(ResultType,'') LIKE '%TABLE%' -- SPECIFICITY ...  
	-- AND NOT ISNULL(ObjectType,'OTHER OBJECT') LIKE '%TABLE%'  -- NO NOT NEGATIVE <> != ... PULL NON TABLE OBJECT(S)	
	-- AND ISNULL(ObjectType,'OTHER OBJECT') IN ('OTHER OBJECT','SQL_STORED_PROCEDURE','VIEW','SQL_INLINE_TABLE_VALUED_FUNCTION','SQL_SCALAR_FUNCTION','SQL_TABLE_VALUED_FUNCTION','BASE TABLE') -- ASSESS ObjectType(s) ...
	-- AND ISNULL(ObjectType,'OTHER OBJECT') LIKE ISNULL('%'+@ObjectName+'%','%') 
	AND 
	( ISNULL(ObjectName,'') LIKE ISNULL('%'+@SearchText+'%','%')
		OR  ISNULL(ColumnName,'') LIKE ISNULL('%'+@SearchText+'%','%')) 
	-- AND ISNULL(ColumnName,'') IS NULL -- PULL NON TABLE OBJECT(S)	
	-- AND ISNULL(AdditionalInfo,'') LIKE ISNULL('%'+@SearchText+'%','%')
	-- AND ISNULL(DefinitionText,'') LIKE ISNULL('%'+@SearchText+'%','%')	 
ORDER BY DatabaseName, ResultType, SchemaName, ObjectName;

/* IF EXISTS (SELECT 1 FROM #SearchResults WHERE ResultType = 'ERROR')

BEGIN
SELECT ' ' AS 'Errors encountered',
DatabaseName,
AdditionalInfo
FROM #SearchResults
WHERE 1=1
	AND ResultType = 'ERROR'
ORDER BY DatabaseName;
END

SELECT ' ' AS 'EcmJson Schema Specific Results',*
FROM #SearchResults
WHERE 1=1
	AND SchemaName = 'EcmJson' AND ResultType != 'ERROR'  -- NO NOT NEGATIVE <> != ...
ORDER BY ResultType, ObjectName, ColumnName; */

-- DROP TABLE IF EXISTS #SearchResults; -- POWER CYCLE RESET REFRESH RESTART ...
