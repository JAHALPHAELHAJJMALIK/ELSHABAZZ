JAH 'REVENUE: '
SELECT ' ' AS "UIS (UNSATISFACTORY IMMIGRATION STATUS) REVENUE: "
,R."ClientIndexNumber" AS CIN
       , R."IndividualFirstName" AS FIRST_NAME
       , R."IndividualLastName" AS LAST_NAME
       , TO_DATE(RD."ServiceBeginDate") AS PAYMENT_MONTH
       , SUM(RD."PremiumPaymentAmount") AS PREMIUM_PAYMENT_AMOUNT
FROM PROD_CHG_ODS.CHGAPP_PROD.REMITTANCEDETAILS AS RD
    INNER JOIN PROD_CHG_ODS.CHGAPP_PROD.REMITTANCES AS R ON RD."FileId" = R."FileId" AND RD."AssignedNumber" = R."AssignedNumber"
    INNER JOIN PROD_CHG_ODS.FINCHG.UVW_UIS_SIS AS UIS_SIS ON R."ClientIndexNumber" = UIS_SIS."ClientIndexNumber" AND TO_DATE(RD."ServiceBeginDate") = TO_DATE(UIS_SIS."EligMonth")
WHERE 1=1
	AND YEAR(TO_DATE(RD."ServiceBeginDate")) = '2024'
	AND UIS_SIS."UIS_SIS_FLAGDescr" = 'UIS'
GROUP BY R."ClientIndexNumber"
       , R."IndividualFirstName"
       , R."IndividualLastName"
       , TO_DATE(RD."ServiceBeginDate")
HAVING SUM(RD."PremiumPaymentAmount") > 0
ORDER BY  R."ClientIndexNumber";

x This query finds revenue payments made for members flagged as having "Unsatisfactory Immigration Status" (UIS) during2024.

		What it does:

				Joins remittance details (REMITTANCEDETAILS) with remittance headers (REMITTANCES) to get member info alongside payment data
				Joins to a UIS/SIS flag view (UVW_UIS_SIS) matching on member ID (ClientIndexNumber) and service month
				Filters to only2024 service dates where the flag is specifically 'UIS'
				Groups by member (CIN, name) and payment month, summing premium payments
				Excludes rows where total premium is zero or negative (HAVING SUM > 0)
				Output columns: A label header, member CIN, first/last name, service month, and total premium payment amount — ordered by CIN.

Purpose: Identifies how much premium revenue was paid on behalf of members with unsatisfactory immigration status, broken down by member and month.

-- =============================================================
	--  SQL v SNOWFLAKE --
-- =============================================================
JAH CHARINDEX() FIND() SEARCH() 'SNOWFLAKE ENVIRONMENT SESSION',TEDIUM,'EDW 2.0 (ENTERPRISE DATA WAREHOUSE 2.0)'
		USE https://app.snowflake.com/ojgwzfd/ec55561/#/search?query=EMERGENCY_IMPACTED_MEMBERSHIP&corpus=all - 'snowflake CHARINDEX() FIND() SEARCH()'
		USE https://data-docs.snowflake.com/foundations/sources/nppes/ - 'snowflake NPPES NPI Registry (hhs.gov)'
		USE https://taxonomy.nucc.org/
		USE https://app.snowflake.com/marketplace/listing/GZTSZ290BUX66/snowflake-public-data-products-snowflake-data-foundations - 'snowflake OPEN SOURCE'
		USE https://status.snowflake.com/ - 'SUBJECT TO OUTAGE(S)' ... AWS see "20251020"

		⏎ Thank you, what is the syntax to delete a function? Specifically the following function: "PROD_CHG_EDW.PUBLIC.FN_EMERGENCY_INCIDENT_ANALYSIS_MAPBOX"
				eg. DROP FUNCTION PROD_CHG_EDW.PUBLIC.FN_EMERGENCY_INCIDENT_ANALYSIS_MAPBOX(STRING, NUMBER(11,8), NUMBER(11,8));

💯 IN THE VOICE OF ... FOR CONTEXT ... STEP BY STEP / FEATURE BY FEATURE / PRO v CON / SIDE BY SIDE,'ai PROMPT ETTIQUETTE' ... WITH() THE AUDIENCE AS ...  'THE KEY STONE KEYSTONE',Consider using MERGE statements instead of separate UPDATE statements where applicable ...  Good Day, ... IN the context OF HMO Healthcare 
		⏎ SSMS v snowflake death match, who wins? ... SSMS takes this one for its rich, battle-tested interface—if you’re in its ecosystem. The snowflake UI is underpowered for traditional Senior Data Analyst AND DBA work. snowflake is MISSING FEATURE(S) LIKE ROBUST OBJECT BROWSING OR MULTI-RESULT PANES
				~ LIKE comparing a TANK (SSMS) TO a drone (snowflake)—different battles, different tools.

		USE https://cookbook.openai.com/examples/chatgpt/gpt_actions_library/gpt_action_snowflake_middleware - 'ENTERPRISE .ai LLM'
		USE https://learn.microsoft.com/en-us/sql/sql-server/?view=sql-server-ver16
		-- USE https://docs.snowflake.com/en/index
		USE https://db-engines.com/en/ranking - DENSE_RANK() ROW_NUMBER() SQL PLATFORM ...'Knowledge Base of Relational and NoSQL Database Management Systems'
		USE http://devops01:8080/IS/_git/Informatics?path=%2FECM%20-%20CS%20Eligible%20and%20Enrolled%20All%20Time%2FSNOWFLAKE_ECM_ELIG_20241121.sql&version=GBMain - 'GiTHUB INFORMATICS'
		USE http://devops01:8080/IS/_git/Informatics?path=%2FECM%20-%20CS%20Eligible%20and%20Enrolled%20All%20Time%2FSNOWFLAKE_ECM_ENROLLED_20241121.sql&version=GBMain - 'GiTHUB INFORMATICS'

		⏎ ACT AS a Senior Data Analyst WITH 20+ years of EXPERIENCE. May I have you HELP MODIFY the existing #PYTHON CODE TO EXPORT ... WITH THE 'Claude.ai ANALYSIS TOOL'

		⏎ ACT AS a Senior Data Analyst WITH 20+ years OF EXPERIENCE. PLEASE MODIFY the EXISTING CODE provided FOR CONTEXT:
				✅ LEVERAGE /* ENTERPRISE ChatGPT CODEX */: https://chatgpt.com/codex/cloud
				✅ ENSURE AND ENFORCE THAT THE CODE CONFORMS WITH 'DUB C 2.0 CODING' STYLE STANDARDS AND PREFERENCES /*  BLOCK BY BLOCK */:
						~ PLEASE ENSURE THAT ALL COMMENTS FROM ORIGINAL CODE ARE PRESERVED.
						~ PLEASE DO NOT ADD LEADING spaces/indentation TO align fields vertically. Commas should be placed at the start of each line WITH NO preceding spaces. EACH field should START immediately after the comma.
						~ PLEASE NO extra whitespace anywhere in the code FOR ANY reason - NOT FOR COMMENT alignment, NOT FOR alias alignment, NOT FOR OPERATOR alignment, NOT FOR field alignment, NOT FOR anything. One space between any two tokens is the maximum. If a space does NOT serve a grammatical SQL purpose, it does NOT exist.
						~ PLEASE ENSURE that the JOIN FIELDS ARE ON THE SAME LINE
						~ PLEASE ENSURE EXPLICIT JOIN Type: Change JOIN TO INNER JOIN FOR clarity AND better optimization by the query engine ... BE MINDFUL OF CREATING ERRONEOUS /* LEFT JOIN */ ^ /* RIGHT JOIN */ ^ /* CROSS JOIN */
						~ PLEASE ENSURE that SELECT statements ARE NOT LEFT alone ON their own lines.
						~ PLEASE ENSURE that ALL TABLE AND FIELD aliases ARE PRECEDED BY 'AS' keyword.
						~ PLEASE ENSURE that the COMMA (,) FOR EACH FIELD IS ON THE LEFT HAND SIDE
						~ PLEASE ENSURE that ALL SQL SYNTAX IS IN UPPER CASE
						~ PLEASE RESTRUCTURE the CASE statements so that CASE, WHEN, THEN, ELSE, AND END each begin at the start of a new line.
						~ WHERE (NOLOCK) IS PRESENT APPLY IT DIRECTLY AFTER TABLE OR FIELD
						~ CONSIDER Removing DISTINCT IN FAVOR OF GROUP BY: REPLACE the DISTINCT IN the final SELECT WITH a proper GROUP BY clause. This IS more EXPLICIT about the aggregation intent AND allows the query optimizer to work more efficiently.
						~ CONSIDER CHANGING UNION to UNION ALL WHEN handling OF duplicates IS HANDLED WITHIN the final aggregation. This eliminates unnecessary duplicate removal operations at each union step, significantly improving performance.
						~ TO AVOID TRUNCATION ERROR(S) WITH AN INSERT STATEMENT PLEASE ENSURE THAT EVERY field being INSERTED has an EXPLICIT CAST TO MATCH the CREATE TABLE DATA TYPES EXACTLY  ... TRUNCATE ^ INSERT INTO ^ EXPLICIT COLUMN DEFINITIONS
						~ PLEASE PROVIDE THE 'COMPLETE PRODUCTION READY CODE' that builds upon your existing framework AND ADHERES TO FOLLOWS DUB C 2.0 standards
						~ CONSIDER WHETHER THE CODE WILL BENEFIT FROM INDEX
						~ THE FROM KEYWORD MUST BEGIN AT THE START OF THE LINE.
						~ THE BASE TABLE OR BASE SOURCE MUST REMAIN ON THE SAME LINE AS FROM.
						~ APPLY OPERATORS THAT BELONG DIRECTLY TO THE BASE SOURCE MUST BEGIN AT THE SAME INDENTATION LEVEL AS FROM.
						~ JOIN OPERATORS MUST BE INDENTED ONLY TO SHOW THE STRUCTURAL RELATIONSHIP OF THE JOIN.
						~ USE ONE TAB PER STRUCTURAL JOIN LEVEL.
						~ DO NOT USE SPACES TO ALIGN JOIN KEYWORDS, TABLE NAMES, TABLE ALIASES, ON CONDITIONS, COMMENTS, OR OPERATORS.
						~ SIBLING JOINS MUST USE THE SAME INDENTATION LEVEL.
						~ CHILD / DEPENDENT JOINS MUST BE INDENTED ONE ADDITIONAL TAB UNDER THE JOIN OR SOURCE THEY DEPEND ON.
						~ THE JOIN TYPE MUST BE EXPLICIT: INNER JOIN, LEFT JOIN, RIGHT JOIN, FULL JOIN, CROSS JOIN, CROSS APPLY, OR OUTER APPLY.
						~ DO NOT CHANGE LEFT JOIN, RIGHT JOIN, FULL JOIN, CROSS JOIN, CROSS APPLY, OR OUTER APPLY INTO INNER JOIN.
						~ DO NOT CREATE INVALID OR CONTRADICTORY JOIN TYPES SUCH AS LEFT JOIN OR RIGHT JOIN.
						~ THE JOIN TABLE, TABLE HINT, ALIAS, ON KEYWORD, AND JOIN FIELDS MUST REMAIN ON THE SAME LINE WHEN PRACTICAL.
						~ WHERE (NOLOCK) IS PRESENT, APPLY IT DIRECTLY AFTER THE TABLE NAME AND BEFORE THE TABLE ALIAS.
						~ ALL TABLE ALIASES MUST USE EXPLICIT AS.
						~ ALL SQL SYNTAX KEYWORDS MUST BE UPPERCASE.
						~ PLEASE ENCLOSE the field names with double ("") quotes (WITH the EXCEPTION OF: c.memid,c.claimid,clm.memid,clm.claimid,su.memid,su.claimid,su.contractid,servunit,dosfrom,dosto,revCODE,resubclaimid,su.PROVID,sup.PROVID,sup.location,c.claimid,c.status,c.totalpaid,isencounter,manualencounter,capitated,calendar_date,first_day_in_month,last_day_in_month). 
						~ PLEASE REPLACE ANY REFERENCES OF 'HMOPROD_PLANDATA.dbo.' WITH 'PROD_CHG_ODS.HMOPROD_PLANDATA.'
						~ PLEASE REPLACE ANY REFERENCES OF 'INFORMATICS.dbo.' WITH.'PROD_CHG_ODS.INFORMATICS.'						
						~ PLEASE REPLACE ANY REFERENCES OF 'ProviderPortal.ECM.' WITH.'PROD_CHG_ODS.PROVIDERPORTAL.'
						~ PLEASE ENSURE THAT COMMENTS FROM ORIGINAL CODE ARE PRESERVED.
						~ PLEASE REPLACE any UPDATE statement with a MERGE statement. 
						~ PLEASE REPLACE occurrences of DROP TABLE IF EXISTS ... WITH  CREATE OR REPLACE TEMPORARY TABLE ... AS. 
						~ PLEASE ENSURE that the 100090 (42P18): Duplicate row detected during DML action error is corrected. 
						~ PLEASE ENSURE that the TRY_CAST cannot be used with arguments of types TIMESTAMP_NTZ(9) and DATE error is corrected.

🚩 FROM TABLE1 As t1
CROSS APPLY(TABLECROSSAPPLY)
    INNER JOIN TABLE2 (NOLOCK) AS t2 ON t1.pkid = t2.pkid
            LEFT JOIN TABLE2 (NOLOCK) AS t3 ON t1.pkid = t3.pkid

-- ❌ INCORRECT (with alignment spacing / indentation):
       ,1 AS [QtrNum]
       ,DATEPART(YEAR,@ClockStart) AS [Year]
 
-- ✅ CORRECT (no alignment spacing / indentation):
,1 AS [QtrNum]
,DATEPART(YEAR,@ClockStart) AS [Year]

-- ❌ DOES NOT MEET DUB C 2.0
[DaysRemainingMonth]    [int]        NULL, 

-- ✅ MEETS DUB C 2.0
[DaysRemainingMonth] [int] NULL,

#03.
FROM HMOPROD_PLANDATA.dbo.enrollkeys (NOLOCK) AS ek
CROSS JOIN INFORMATICS.dbo.date_calendarISO (NOLOCK) AS dc -- CALENDAR(S) -- INDEPENDENT STAND ALONE ... CROSS APPLY() CROSS JOIN() CARTESIAN PRODUCT
	INNER JOIN INFORMATICS.dbo.[uvw_LINE_OF_BUSINESS] (NOLOCK) AS bp ON ek.programid = bp.programid
	INNER JOIN PADDEDTABLEJOIN (NOLOCK) AS ndc ON RIGHT('00000000000'+LTRIM(RTRIM(REPLACE(rx.DrugCode,'-',''))),11) = RIGHT('00000000000'+LTRIM(RTRIM(REPLACE(ndc.NDC_Code,'-',''))),11) -- NDC MATCH CAVEAT ABOVE | ZERO-PADDED 11-DIGIT RIGHT-JUSTIFIED MATCH
		LEFT JOIN HMOPROD_PLANDATA.dbo.language (NOLOCK) AS lang ON lang.languageid = mem.primarylanguage
WHERE 1=1 /* CARDINALITY HIERARCHY FOR ... Building dynamic WHERE conditions ... AND ... */
	AND CAST(ISNULL(c.enddate,'9999-12-31') AS date)>=p.RangeStartDate -- WITHIN reporting period [RANGE] OPPOSITION
	-- AND CAST(ISNULL(c.enddate,GETDATE()) AS date)>=p.RangeStartDate -- WITHIN reporting period [RANGE] OPPOSITION
GROUP BY -- v SELECT DISTINCT ... CONSIDER Removing DISTINCT IN FAVOR OF GROUP BY: REPLACE the DISTINCT IN the final SELECT WITH a proper GROUP BY clause. This IS more EXPLICIT about the aggregation intent AND allows the query optimizer to work more efficiently.

		🚀 THE BUSINESS CASE: /* PROS */
				1. Performance Velocity: 
						~ Speed to insight: (NOLOCK) bypasses locking mechanisms. When you ARE running reports against massive enrollment tables – we ARE talking millions of member records – this can mean the difference between a 2-minute query and a 45-second query

		Concurrency liberation: Your analysts ARE NOT blocked waiting for write operations to complete. In a fast-moving healthcare environment where enrollment data is constantly updating, this keeps your business intelligence flowing

				2. Operational Continuity: 
						~ No deadlock scenarios: You eliminate the risk of reader-writer deadlocks. I HAVE seen production systems grind to a halt because reporting queries locked with enrollment batch processes

		Resource efficiency: Fewer locks = less memory overhead = lower SQL Server resource contention
		 
		🚀 THE RISK PROFILE: /* CONS */
		Now here's where it gets serious – and why I'd challenge any of my portfolio companies using NOLOCK without a governance framework:
				1. Data Integrity Compromise (DIRTY READS)
						-- Your query might read:
						Member ID: 12345, Plan: Gold, Status: Active
						 
						-- But mid-query, a transaction rolls back:
						ACTUAL DATA: Member ID: 12345, Plan: Silver, Status: Pending
 
In healthcare analytics? That is catastrophic. You are reporting enrollment numbers to CMS that do NOT exist. you ARE calculating risk adjustments on phantom members. I HAVE seen companies face seven-figure audit penalties for exactly this scenario.

				/* ⏎ ACT AS a Senior Data Analyst. May I have you  CONVERT the attached CODE INTO snowflake. OPTIMIZE code to IMPROVE performance, readability, AND maintainability PLEASE KEEP ALL COMMENT(S). PLEASE KEEP EVERY COMMENTED LINE. USE 'AS' PRIOR TO ASSIGNING TABLE / FIELD ALIAS. PLEASE ENSURE that each SELECT statement starts ON the same line as its first column name, like this: SELECT column_name, ... PLEASE ENCLOSE the field names with double ("") quotes (WITH the EXCEPTION OF: c.memid,c.claimid,clm.memid,clm.claimid,su.memid,su.claimid,su.contractid,servunit,dosfrom,dosto,revcode,resubclaimid,su.PROVID,sup.PROVID,sup.location,c.claimid,c.status,c.totalpaid,isencounter,manualencounter,capitated,calendar_date,first_day_in_month,last_day_in_month). Please REPLACE any UPDATE statement with a MERGE statement. Please REPLACE occurrences of DROP TABLE IF EXISTS ... WITH  CREATE OR REPLACE TEMPORARY TABLE ... AS. PLEASE ENSURE that the 100090 (42P18): Duplicate row detected during DML action error is corrected. PLEASE ENSURE that the TRY_CAST cannot be used with arguments of types TIMESTAMP_NTZ(9) and DATE error is corrected. */

		⏎ ACT AS a Senior Data Analyst WITH 20+ years of EXPERIENCE. DEBUG the CODE FOR the following ERROR WITH() '
				~ AGENTIC CODING ... ROOT CAUSE ANALYSIS':
				~ Reduced Memory USAGE: Smaller intermediate RESULT SETS
				~ Better Plan Caching: More consistent execution plans
				~ Easier Debugging: MODULAR STRUCTURE allows testing individual components
				~ Future Scalability: STRUCTURE supports easy addition of new filtering criteria
				
		⏎ ACT AS a Senior Data Analyst WITH 20+ years of EXPERIENCE. May I have you CONVERT / MODIFY / ALTER the existing CODE (attached for context) INTO a snowflake VIEW WITH:		
				~ PLEASE ALLOW FOR THE FOLLOWING DYNAMIC SQL/STORED PROCEDURES PARAMETER(S) 
						- (IncidentName,IncidentLatitude,IncidentLongitude) 
				
				~ PLEASE ENSURE that SELECT statements are NOT left alone ON their own lines. 
				~ PLEASE ENSURE that ALL TABLE AND FIELD aliases are PRECEDED by the 'AS' keyword.				
				~ PLEASE ENSURE that the COMMA FOR EACH FIELD IS ON THE LEFT

		⏎ ACT AS a Senior Data Analyst WITH 20+ years of EXPERIENCE. May I have you CONVERT / MODIFY / ALTER the existing CODE INTO snowflake:
				~ Purpose: Find members within proximity of an emergency incident location
				~ Input: Incident Latitude & Longitude parameters
				~ Output: Members ranked by distance from incident location

				~ PLEASE ENSURE that SELECT statements are NOT left alone ON their own lines. 
				~ PLEASE ENSURE that ALL TABLE AND FIELD aliases are PRECEDED by the 'AS' keyword.				
				~ PLEASE ENCLOSE the field names with double ("") quotes (WITH the EXCEPTION OF: c.memid,c.claimid,clm.memid,clm.claimid,su.memid,su.claimid,su.contractid,servunit,dosfrom,dosto,revCODE,resubclaimid,su.PROVID,sup.PROVID,sup.location,c.claimid,c.status,c.totalpaid,isencounter,manualencounter,capitated,calendar_date,first_day_in_month,last_day_in_month). 
				~ PLEASE ENSURE that the COMMA FOR EACH FIELD IS ON THE LEFT 
				
		⏎ ACT AS a Senior Data Analyst WITH 20+ years of EXPERIENCE. PLEASE provide an EXEC EXAMPLE of the attached sp (STORED PROCEDURE) fn fx (FUNCTION)?
		
				📌 EXEC EXAMPLE - fn fx (FUNCTION): 
				SELECT *
				FROM TABLE(PROD_CHG_ODS.INFORMATICS.FN_EMERGENCY_INCIDENT_ANALYSIS_MAPBOX(
				'Spring Fire - County: San Diego', -- IncidentName: 
				CAST(32.726812619 AS NUMBER(11,9)), -- IncidentLatitude: 
				CAST(-116.720067319 AS NUMBER(12,9)), -- IncidentLongitude: 
				CAST(25.999 AS NUMBER(5,3)), -- distance_threshold: IN Miles - adjust based on emergency response needs
				CAST(CURRENT_DATE() AS DATETIME), -- execdate: 
				CAST(0.621371 AS NUMBER(7,6)), -- km_to_miles: (Conversion factor 0.621371) 1 kilometer = 0.621371 miles ... So multiply the HAVERSINE result by 0.621371 to get miles
				CAST(0.000621371 AS NUMBER(9,8)) --  m_to_miles: (Conversion factor 0.000621371) 1 meter = 0.000621371 miles ... So multiply the ST_DISTANCE result by 0.000621371 to get miles
				)) AS incident_view
				ORDER BY INCIDENT_DISTANCE_IN_MILES;

				📌 EXEC EXAMPLE - sp (STORED PROCEDURE): 
				CALL PROD_CHG_ODS.INFORMATICS.SP_DSNP_PALLIATIVE_QUARTERLY(); -- snbowflake

				SELECT *
				FROM TABLE(PROD_CHG_ODS.INFORMATICS.SP_EMERGENCY_INCIDENT_ANALYSIS_MAPBOX(
				'Wildfire Alert - San Diego County', -- IncidentName
				CAST(32.726812619 AS NUMBER(11,9)), -- IncidentLatitude (San Diego area)
				CAST(-116.720067319 AS NUMBER(12,9)), -- IncidentLongitude (San Diego area)
				CAST(25.999 AS NUMBER(5,3)), -- distance_threshold: IN Miles - adjust based on emergency response needs
				CAST(CURRENT_TIMESTAMP() AS TIMESTAMP_NTZ(9)), -- execdate
				CAST(0.621371 AS NUMBER(7,6)), -- km_to_miles: (Conversion factor 0.621371) 1 kilometer = 0.621371 miles ... So multiply the HAVERSINE result by 0.621371 to get miles
				CAST(0.000621371 AS NUMBER(9,8)) --  m_to_miles: (Conversion factor 0.000621371) 1 meter = 0.000621371 miles ... So multiply the ST_DISTANCE result by 0.000621371 to get miles
				)) AS incident_view
				ORDER BY INCIDENT_DISTANCE_IN_MILES;







-- =============================================================
	IN 'SNOWFLAKE' REPLACE() SUBSTITUTE() ... WITH() ...
-- =============================================================
x WHEN the INFERIOR snowflake PLATFORM STRUGGLES WITH() AN UPDATE USE MERGE ...

x HINT(S) AND TIP(S)
		~ ISNULL WITH() IFNULL
		~ [ WITH ''
		~ ] WITH() ''
		~ SELECT HIGHLIGHT THEN [SHIFT + ''] TO APPLY DOUBLE ("") QUOTES TO FIELD IN INFERIOR PLATFORM
		~ DOUBLE CLICK ON OPBJECT WITHIN THE EXPLORER PANE TO ADD TO SESSION QUERY PANE
		
  	-- CHECK FOR DUP(S) --
SELECT ' ' AS "SHOULD RETURN 0 ROWS - DUP Validation",*
FROM PROD_CHG_ODS.INFORMATICS.QUEST_ANALYTICS_08052025
WHERE 1=1 
	AND quest_memid IN
	( -- INITIATE ...
	SELECT quest_memid
	FROM PROD_CHG_ODS.INFORMATICS.QUEST_ANALYTICS_08052025 AS dup
	GROUP BY quest_memid -- Duplication Driver 
	HAVING COUNT(1)>1 -- HAVING clause RESERVED for AGGREGATE(s) ... HAVING SUM(PAID_NET_AMT) != 0
	); -- CONCLUDE ...

SELECT TOP 10 ' ' AS "SAMPLE NOT NULL(S)S: "
,CONCAT(SUBSTRING(TO_VARCHAR(QUEST_PHYSICAL_LAT), 1, 2), '.', SUBSTRING(TO_VARCHAR(QUEST_PHYSICAL_LAT), 3)) AS "ALTER Latitude"
,CONCAT('-', SUBSTRING(TO_VARCHAR(QUEST_PHYSICAL_LONG), 1, 3), '.', SUBSTRING(TO_VARCHAR(QUEST_PHYSICAL_LONG), 4)) AS "ALTER Longitude",*
FROM PROD_CHG_ODS.INFORMATICS.QUEST_ANALYTICS_08052025
WHERE 1=1
    AND NVL(QUEST_PHYSICAL_LAT, '') != '' -- NO NOT NEGATIVE <> != ... snowflake ISNULL() NVL()
ORDER BY QUEST_PHYSICAL_ADDRESS;

SELECT ' ' AS "SAMPLE NULL(S)S: "
,QUEST_PHYSICAL_ADDRESS
,QUEST_PHYSICAL_ZIP
,QUEST_PHYSICAL_LAT
,QUEST_PHYSICAL_LONG
,QUEST_GEOINFO
FROM PROD_CHG_ODS.INFORMATICS.QUEST_ANALYTICS_08052025
WHERE 1=1
	AND QUEST_PHYSICAL_LAT IS NULL;

x HMOPROD_PLANDATA.dbo. WITH()PROD_CHG_ODS.HMOPROD_PLANDATA.
x INFORMATICS.dbo. WITH().PROD_CHG_ODS.INFORMATICS.

-- x HMOPROD_PLANDATA.dbo. WITH()DEV_CHG_ODS.HMOPROD_PLANDATA.
-- x INFORMATICS.dbo. WITH().DEV_CHG_ODS.INFORMATICS.

x ENCLOSE TABLE FIELD NAME WITH() ''
x BOTHERSOME: 'May I have you assist me IN locating within or have the following tables uploaded into snowflake:'

x FOUR (4) PART(S) SCHEMA(): 'SERVERname'.'DATABASEname'.'SCHEMAname'.'OBJECTname' ... SNOWFLAKE IS THE SERVER
		-- SQLPROD02.HMOPROD_PLANDATA.dbo.TABLENAME
		REPLACE() HMOPROD_PLANDATA.dbo. WITH() DEV_CHG_ODS.HMOPROD_PLANDATA.
		
		-- SQLPROD02.INFORMATICS.dbo.TABLENAME
		REPLACE() INFORMATICS.dbo. WITH() DEV_CHG_ODS.INFORMATICS.

x Snowflake does NOT NO NEGATIVE <> != use traditional indexes. Instead, you can use clustering keys:
		-- Create an index equivalent IN Snowflake (clustering key)
		ALTER TABLE Informatics2.dbo.SHELLunion00_AB1455 CLUSTER BY ("DupID");

x 'HEADER' v 'DETAIL' AS COMPARED TO 'FACT' v 'DIM' TABLE...

x The KEY differences WHEN CONVERTing to SNOWFLAKE are:

💯 I SHALL NO NOT NEGATIVE <> != DELIVER DATA FROM A SOURCE I KNOW TO BE AT BEST INCOMPLETE ... RUN AND TELL ANYBODY YOU LIKE I SAID SO
		⏎ USE DATE instead of datetime for just a date value
		⏎ USE TO_DATE() to CONVERT a formatted string to a Date
		⏎ USE CURRENT_TIMESTAMP() instead of GETDATE()
		⏎ USE || for concatenation instead of +
		⏎ USE LPAD() to left pad numbers with zeros
		⏎ USE single quotes for string literals

		⏎ MAKE USE OF SNOWFLAKE COPILOT EXTENSION PLUGIN
				~ CODE; SHOW PARAMETERS LIKE '%CORTEX%' IN ACCOUNT		

		⏎ 'INFERIOR PLATFORM': SEE NO REASON FOR THE DATA ANALYST TO BE IGNORANT OF THE DATA ... YOU KNOW!!!
		⏎ 'INFERIOR PLATFORM': MANAGE SET EXPECTATION
		⏎ 'INFERIOR PLATFORM': LOSS OF FUNCTIONALITY
		⏎ 'INFERIOR PLATFORM': IN-FLEXIBILITY
		⏎ 'INFERIOR PLATFORM': EXPONENTIAL INCREASE IN DEVELOPMENT TIME 
		⏎ 'INFERIOR PLATFORM': NEED FOR DOUBLE QUOTES "" ON SOME [FIELD] IN SOME SECTION OF CODE
		⏎ 'INFERIOR PLATFORM': CASE SENSITIVITY eg. NEED TO USE 'ILIKE'
		⏎ 'INFERIOR PLATFORM': BEING FOISTED UPON ME
		⏎ 'INFERIOR PLATFORM': KNOWLEDGE SHARE BLOCK
		⏎ 'INFERIOR PLATFORM': NO NOT NEGATIVE <> != FOR DATA ANALYST TO BE IGNORANT OF THE DATA
		⏎ 'INFERIOR PLATFORM': DO NO NOT NEGATIVE <> != CHASE NEW TECHNOLOGY
		⏎ 'INFERIOR PLATFORM': NO NOT NEGATIVE <> != CHASE MODULARITY
		⏎ 'INFERIOR PLATFORM': GATEKEEPING OF TABLE(S)
		
x SNOWFLAKE ODBC SSRS CONNECTION: 'Dsn=SnowFlake; uname=REPORTING; pwd=^^|Happen1'
x IN 'SNOWFLAKE' THE TERM 'WAREHOUSE' SYNONYMOUS WITH AN 'ENGINE' TO BE MOST PERFORMANT
x IN 'SNOWFLAKE' sp SYNTAX IN SNOWFLAKE NESTED TAG(S) OPEN + END SEQUENCE REQUIRES '$$'
x  WHEN VIEWING sp IN SNOWFLAKE AN ADDITIONAL "'" SHOULD BE ADDED
		ie. AS ' ' -- ADDITIONAL ' ADDED FOR VIEWING EASE ...







-- ====================================================================
	-- LOGIN CREDENTIAL(S) --
-- ====================================================================
JAH 'SNOWFLAKE' REGISTRATION
x 'SNOWFLAKE WORKSHEET' = 'SSMS PANEL SESSION'
		-- USE https://pvflcgm-kz00748.SNOWFLAKEcomputing.com - 'Welcome to SNOWFLAKE! Your account has been activated. Your username is ALPACATACKOPHEUCAN and your account URL is .  LOG IN TO SNOWFLAKE Get started with SNOWFLAKE Quickstarts  Follow along with our tutorials to get you up and running with the SNOWFLAKE Data Cloud  Read our documentation  Get started with our SQL syntax and become a pro  Join the community  Talk with fellow SNOWFLAKEs, ask questions and get help from the community  Contact support  Register for Support within SNOWFLAKE, get technical assistance from SNOWFLAKE Support'
		USE https://app.SNOWFLAKE.com/ojgwzfd/ec55561/worksheets - 'ENTERPRISE ACCT' EC55561
		-- USE https://app.SNOWFLAKE.com/xdageat/kp38616/worksheets- 'BURNER FREE TRIAL' KP38616
		-- USE https://app.SNOWFLAKE.com/xdageat/kz00748/worksheets- 'BURNER FREE TRIAL' KZ00748
		USE https://marketplace.visualstudio.com/items?itemName=snowflake.snowflake-vsc
		-- USE https://app.SNOWFLAKE.com/ojgwzfd/ec55561/w1nvHIla1KhA#query - 'ENTERPRISE ACCT' EC55561
		USE https://www.SNOWFLAKE.com/ - 'DATA CLOUD' SNOWFLAKE
		-- USE https://signup.SNOWFLAKE.com/ - 'BURNER FREE TRIAL'
		-- USE https://signup.SNOWFLAKE.com/?utm_cta=d4b-2023-SNOWFLAKE-presentation-cta&_ga=2.91282771.893492408.1679589144-1459952532.1679096785 - 'BURNER FREE TRIAL'
		-- USE https://www.SNOWFLAKE.com/webinar/virtual-hands-on-labs/zero-to-SNOWFLAKE-2023-04-12/?utm_cta=d4b-2023-SNOWFLAKE-presentation-cta - 'DATA CLOUD' SNOWFLAKE
		USE https://docs.SNOWFLAKE.com/en/sql-reference/sql/copy-into-table - 'SNOWFLAKE COPY TABLE(S)'
		USE https://resources.SNOWFLAKE.com/video/introduction-to-SNOWFLAKE-data-marketplace - 'DATA SNOWFLAKE' 
		USE https://tinyurl.com/IntroSNOWFLAKE - 'WEBEX HANDS ON MATERIALS'
		USE https://drive.google.com/drive/folders/1pk9dyucntQVO_3LMcXHuKfoyLuMjsayc - 'WEBEX HANDS ON MATERIALS'
		USE https://www.kahoot.it - 'POP QUIZ' GAME PIN: '2557583'

				UID: ENTEPRISE em OR alpaca...oph... OR WCARR OR 'alpaca...oph...NANCY' OR wcarr@chgsd.com
				em: wca...
				PW: '#GILFna...yyyy' -- 'FREE TRIAL PERIOD' OR 'achetoeatoutNA...+##' OR 'Bunny#WCE1978' -- 'Welcome2023' -- you will be asked to reset it






-- =====================================================================
	-- DECLARE @PARAMETER(S) / @FILTER(S) --
-- =====================================================================
SET leadlag = -22;
SET leadlagdays = -1;
SET leadlagmonths = 12;
SET clockstart = DATEADD(DAY, 1, LAST_DAY(ADD_MONTHS(CURRENT_DATE(), $leadlag))); -- AS "1st OF ... MONTH" -- DATE(CURRENT_DATE());
SET clockstop = DATE(DATEADD(DAY, -1, DATEADD(MONTH, $leadlagmonths, $clockstart)));
-- SET clockstart = DATE_TRUNC('MONTH', CURRENT_DATE()); -- First day of current month
-- SET clockstop = LAST_DAY(CURRENT_DATE()); -- Last day of current month
SET LOB = 'Medi-Cal';
SET cutoff = '2014-01-01'::DATE; -- IN YYYY-MM-DD
SET distance_threshold = 25.999; -- Miles - adjust based on emergency response needs
SET execdate = CURRENT_DATE()
SET paramstring = 'The following example returns the geospatial distance in kilometers between New York and Los Angeles:';
SET IncidentName = 'Spring Fire - County: San Diego'; -- IncidentName STRING,
SET IncidentLatitude = 32.726812619;    -- Changed to NUMBER instead of string ... IncidentLatitude NUMBER(11,9),
SET IncidentLongitude = -116.720067319; -- Changed to NUMBER and corrected sign ... IncidentLongitude NUMBER(12,9),
SET distance_threshold = 25.999; -- Miles - adjust based on emergency response needs ... distance_threshold NUMBER(5,3),
SET execdate = CURRENT_DATE(); -- execdate DATETIME,
SET km_to_miles = 0.621371; -- 1 kilometer = 0.621371 miles ... So multiply the HAVERSINE result by 0.621371 to get miles ... km_to_miles NUMBER(7,6)

		/* SELECT ' ' AS "To calculate the distance BETWEEN - SYNTAX: HAVERSINE(<lat1>,<lon1>,<lat2>,<lon2>)"
		,HAVERSINE(40.7127, -74.0059, 34.0500, -118.2500) AS "distance in km"
		,HAVERSINE(40.7127, -74.0059, 34.0500, -118.2500)*0.621371 AS "distance in miles"  -- Convert km to miles
		,' ' AS "ST_DISTANCE version (meters * conversion): " 
		,ST_DISTANCE(
		ST_MAKEPOINT(-74.0059, 40.7127) -- New York coordinates (longitude, latitude)
		,ST_MAKEPOINT(-118.2500, 34.0500) -- Los Angeles coordinates (longitude, latitude)
		) * 0.000621371 AS "ST distance_miles";  -- Convert meters to miles

		📌 EXEC EXAMPLE: 
		SELECT *
		FROM TABLE(PROD_CHG_ODS.INFORMATICS.FN_EMERGENCY_INCIDENT_ANALYSIS_MAPBOX(
		'Spring Fire - County: San Diego', -- IncidentName: 
		CAST(32.726812619 AS NUMBER(11,9)), -- IncidentLatitude: 
		CAST(-116.720067319 AS NUMBER(12,9)), -- IncidentLongitude: 
		CAST(25.999 AS NUMBER(5,3)), -- distance_threshold: IN Miles - adjust based on emergency response needs
		CAST(CURRENT_DATE() AS DATETIME), -- execdate: 
		CAST(0.621371 AS NUMBER(7,6)), -- km_to_miles: 1 kilometer = 0.621371 miles ... So multiply the HAVERSINE result by 0.621371 to get miles
		CAST(0.000621371 AS NUMBER(9,8)) -- m_to_miles: 1 meter = 0.000621371 miles ... So multiply the ST_DISTANCE result by 0.000621371 to get miles
		)) AS incident_view; */

		-- SQL TRY_CONVERT(decimal(9,1),NULL) :||: # NUMBER WITH() 'NINE' (9) DIGIT(s) IN TOTAL: WITH() 'ONE' (1) DIGIT(s) AFTER THE DECIMAL v snowflake NUMBER(5,3) 
		
        SELECT ' ' AS "CHECK DECLARE(S)"
		,$LOB AS "Line of Business"
		,$IncidentName AS "Emergency Incident Name"
		,$execdate AS "Analysis_Timestamp"
		,$distance_threshold AS "Radius Cutoff"
		-- ,HAVERSINE(dm.physical_latitude,dm.physical_longitude,$IncidentLatitude,$IncidentLongitude)*$km_to_miles AS "Incident Distance in Miles"
		-- ,ROUND(HAVERSINE(dm.physical_latitude,dm.physical_longitude,$IncidentLatitude,$IncidentLongitude),3)*$km_to_miles AS "ROUND Incident Distance in Miles"
		,$paramstring AS "MESSAGE(S)"
		,'('||$IncidentLatitude||', '||$IncidentLongitude||')' AS "Emergency Response Incident Location"
		,'BETWEEN '|| $clockstart || ' AND ' || $clockstop AS "Range"
		,DATEADD(DAY, 1, LAST_DAY(ADD_MONTHS(CURRENT_DATE(), -2))) AS "1st OF PREVIOUS MONTH"
		,DATEADD(DAY, 1, LAST_DAY(ADD_MONTHS(CURRENT_DATE(), -1))) AS "1st OF MONTH"
		,DATEADD(DAY, 1, LAST_DAY(ADD_MONTHS(CURRENT_DATE(), 0))) AS "1st OF NEXT MONTH"
		,LAST_DAY(ADD_MONTHS(CURRENT_DATE(), -1)) AS "EO PREVIOUS MONTH"  -- EOMONTH / LAST_DAY ( start_date ,[ month_to_add ] )
		,LAST_DAY(ADD_MONTHS(CURRENT_DATE(), 0)) AS "EO CURRENT MONTH"
		,LAST_DAY(ADD_MONTHS(CURRENT_DATE(), 1)) AS "EO NEXT MONTH"
		,DATEFROMPARTS(YEAR(GETDATE()),MONTH(GETDATE()),1) AS "NormalizeMonth" -- DATEFROMPARTS(year, month, day)
		,DATEFROMPARTS(YEAR(DATEADD(MONTH,-1,GETDATE())),MONTH(DATEADD(MONTH,-1,GETDATE())),1) AS "NormalizePreviousMonth"
		,DATEFROMPARTS(YEAR(DATEADD(MONTH,1,GETDATE())),MONTH(DATEADD(MONTH,1,GETDATE())),1) AS "NormalizeNextMonth"
        ,bp."description" AS "LOB",p."description" AS "PROGRAM"
        ,$cutoff AS "Cutoff Date Assessment"
		FROM PROD_CHG_ODS.HMOPROD_PLANDATA.benefitplan AS bp
			INNER JOIN PROD_CHG_ODS.HMOPROD_PLANDATA.program AS p ON bp."programid" = p."programid"
		WHERE 1=1 
			-- AND UPPER(TRIM(COALESCE(p."description", '')))  LIKE IFF($LOB IS NOT NULL, '%' || $LOB || '%', '%');
			AND IFNULL(bp."description",'') IN ('CMC MEDICARE','CMC MEDI-CAL PLUS','DSNP MEDICARE PLAN','DSNP MEDI-CAL PLAN'); -- DETERMRECON LOB ISO MATCH
			AND UPPER(LTRIM(RTRIM(IFNULL(ek."segtype",'')))) ='INT'
			AND IFNULL(mem."issubscriber",'') = 'Y' -- ISO ON SUBSCRIBER ONLY!!!
			-- Fixed: Use DATE() function to convert timestamp to date
			AND IFNULL(dm.physical_latitude,'') != ''
			-- AND UPPER(TRIM(COALESCE(p."description", '')))  LIKE IFF($LOB IS NOT NULL, '%' || $LOB || '%', '%');
			-- AND IFNULL(bp."description",'') IN ('CMC MEDICARE','CMC MEDI-CAL PLUS','DSNP MEDICARE PLAN','DSNP MEDI-CAL PLAN'); -- DETERMRECON LOB ISO MATCH
			-- Removed duplicate condition (was already above)
			AND DATE(ek."effdate") <= DATE($execdate) -- WITHIN reporting period [RANGE] OPPOSITION 
			AND DATE(IFNULL(ek."termdate",CURRENT_DATE())) >= DATE($execdate) -- WITHIN reporting period [RANGE] OPPOSITION
			-- Add distance filter
			-- AND TRY_CAST(ROUND(HAVERSINE(dm.physical_latitude,dm.physical_longitude,$IncidentLatitude,$IncidentLongitude),3) AS DECIMAL(9,3)) <= $distance_threshold;
			AND DATE(IFNULL(ek."termdate",CURRENT_DATE())) > DATE(ek."effdate") -- MUST BE TRUE ... NON-CROSSFOOTED RECORDS ARE ACTIVE ...			

/* DECLARE startdate INT;
            enddate INT;
            months INT;
BEGIN
        startdate := 20240101;
        enddate := 20240331;
        months := 2;  --If quarterly THEN 2.  If yearly THEN 11

... WHERE 1=1 
                  AND 
			mm.START_DATE >= :startdate
                  AND 
              mm.END_DATE <= :enddate
                  AND 
              b.LOB ='D-SNP'
                  AND 
              M.IS_ECM_ENROLLED ='NO' 
        GROUP BY mm.MEMBERAK
                 , m.SECONDARY_ID
                 , m.full_name
        HAVING (MAX(mm.enrollment_lob_consecutive_months) - MIN(mm.enrollment_lob_consecutive_months) = :months
        AND MIN(DATEDIFF(Month,TO_DATE(TO_VARCHAR(m.DATE_OF_BIRTH), 'YYYYMMDD'),TO_DATE(TO_VARCHAR(mm.start_date), 'YYYYMMDD'))/12) >= 21);
    END; */
	
--------------------------------------------------------------------------------------------------------------------
	-- Error Trapping: Check If Permanent Table(s) Already Exist(s) And Drop If Applicable --
--------------------------------------------------------------------------------------------------------------------
CREATE OR REPLACE TEMPORARY TABLE params  
( -- INITIATE ...
my_var number
,start_dt timestamp
,SearchString varchar(255) -- see CREATE TABLE #employee
,lag int
-- ,lagyrs AS int
-- ,prevlagyrs AS int
-- ,lagdays AS int
-- ,lagmonths AS int
-- ,when AS timestamp
-- ,footnotedt AS varchar(25)
-- ,StartDT AS timestamp
-- ,EndDT AS timestamp
-- ,Start AS timestamp
-- ,End AS timestamp
-- ,rangeprefix AS varchar(100)
-- ,TruevFalse AS binary
-- ,DYNAMICLIKE AS varchar(255) -- LIKE '%[@PARAMETER]%'
-- ,LOB AS varchar(255) -- LIKE '%[@PARAMETER]%'
-- ,memid AS varchar(25)
-- ,dosSTART AS timestamp
-- ,dosEND AS timestamp
-- ,SYSisB AS varchar(4)
-- ,pos AS varchar(2) -- SELECT 'TELEHEALTH ("02") ANALYSIS DUE TO COVID - 19' AS [NOTE(S)],* FROM INFORMATICS2.dbo.SHELLpos
-- ,proposedflatrate AS decimal(9,2) -- SELECT 'TELEHEALTH ("02") ANALYSIS DUE TO COVID - 19' AS [NOTE(S)],* FROM INFORMATICS2.dbo.SHELLpos
); -- CONCLUDE WITH();

INSERT INTO params
SELECT 10 AS my_var
,GETDATE() AS start_dt
,'UP AGAINST' AS SearchString
,28 AS Lag;

        SELECT ' ' AS "SNOWFLAKE DECLARE(S)",* FROM params;

-- =====================================================================
	-- LEVERAGE snowflake PEER REVIEW: 
-- =====================================================================	
SELECT ' ' AS 'SIR PHIL PEER REVIEW IN snowflake: ',
dp.PROVIDER_FULL_NAME AS payto_provider,
db.LOB ,
ds.CODEIDAK AS cpt_code,
count(DISTINCT CLAIMAK ) AS claim_count,
sum(fm.ADJUSTED_UNITS) AS units,
sum(AMOUNT_PAID) AS amount_paid,
sum(fm.MEDI_CAL_FEE * ADJUSTED_UNITS) AS medi_cal_100_percent,
sum(fm.MEDICARE_FEE * ADJUSTED_UNITS) AS medicare_100_percent
FROM PROD_CHG_EDW.CHG_EDW.FACT_MEMBERHISTORY AS fm
	JOIN PROD_CHG_EDW.CHG_EDW.DIM_PROVIDERSPECIALTY AS dp ON fm.PAYTOPROVIDERSK = dp.PROVIDERSK
	JOIN PROD_CHG_EDW.CHG_EDW.DIM_SERVICECODE AS ds ON fm.SERVICECODESK = ds.SERVICECODESK
	JOIN PROD_CHG_EDW.CHG_EDW.DIM_BENEFITPLAN AS db ON fm.BENEFITPLANSK =db.BENEFITPLANSK
WHERE 1=1
	AND fm.CLAIM_START_DATE BETWEEN 20240201 AND 20250131
	AND fm.enrollment_status='P' --PRIMARY only
	AND fm.IS_PAID_CLAIM = 'YES'
	AND ds.CODEIDAK IN (
	'99202',
	'99203',
	'99204',
	'99205',
	'99211',
	'99212',
	'99213',
	'99214',
	'99215',
	'99421',
	'99422',
	'99423')
GROUP BY dp.PROVIDER_FULL_NAME, db.LOB, ds.CODEIDAK
ORDER BY amount_paid DESC --sum(AMOUNT_PAID) desc







-- ==============================================================
	-- SINGLE QUOTE() v. DOUBLE QUOTE() --
-- ==============================================================
SELECT DISTINCT '=IF(AND(OR(F2=F1,F2=F3),OR(D2=D1,D2=D3)),'+'"'+'TWIN'+'"'+','+'"'+'"'+')' AS [TWIN CHECK] -- DOUBLE QUOTE(s)
SELECT DISTINCT '=IF(AND(OR(F2=F1,F2=F3),OR(D2=D1,D2=D3)),'+''''+'TWIN'+''''+','+''''+''''+')' AS [TWIN CHECK] -- SINGLE QUOTE(s)

		SELECT 'Children'+''''+'s Specialists of San Diego'

		⏎ DECLARE StartDT DATE = TO_DATE(CONCAT(LPAD(MONTH(DATEADD('month', -1, CURRENT_TIMESTAMP())),2,'0'),'/01/',YEAR(DATEADD('month', -1, CURRENT_TIMESTAMP()))));

x WHERE 1=1 CLAUSE IN SNOWFLAKE IS 'CASE SENSITIVE'

x CREATE IN SSMS SQL: 
CREATE  OR ALTER PROCEDURE dbo.[sp_] --<Procedure_Name, sysname, ProcedureName> ... DROP 

x USE DOUBLE QUOTE() FOR SNOWFLAKE "FIELDNAME"

--------------------------------------------------------------------------------------------------------------------
	-- Error Trapping: Check If Permanent Table(s) Already Exist(s) And Drop If Applicable --
--------------------------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS TABLENAME; -- SQL Server 2016 and later -- DYNAMIC tmp OR STATIC [TABLE] #TableName is a local temporary table visible only IN the current session; ##TableName is a GLOBAL temporary table visible to all sessions IN ('TempDB')

-----------------------------------------------------------------------------------------------------------------------------
	-- Error Trapping: Check If Permanent Table(s) Already Exist(s) And Drop If Applicable --
-----------------------------------------------------------------------------------------------------------------------------
IF OBJECT_ID('TempDB..#date_calendar') IS NOT NULL -- tmp CTE [TABLE] #TableName is a local temporary table visible only IN the current session; ##TableName is a GLOBAL temporary table visible to all sessions IN ('TempDB')
DROP TABLE #date_calendar;

IF OBJECT_ID (N'TABLENAME', N'U') IS NOT NULL -- STATIC [TABLE]
DROP TABLE TABLENAME;

-- IF OBJECT_ID('TempDB..#TABLENAME') IS NOT NULL -- tmp CTE [TABLE] #TableName is a local temporary table visible only IN the current session; ##TableName is a GLOBAL temporary table visible to all sessions IN ('TempDB')
-- BEGIN

		-- DROP TABLE TABLENAME END

-- IF OBJECT_ID (N'TABLENAME', N'U') IS NOT NULL -- STATIC [TABLE]
-- BEGIN

		v  IN 'SNOWFLAKE'

CREATE OR REPLACE TEMPORARY TABLE TABLENAME AS 
CREATE OR REPLACE VIEW VIEWNAME
CREATE OR REPLACE PROCEDURE PROCEDURENAME(...)
CREATE OR REPLACE TABLE TABLENAME AS 

CREATE OR REPLACE TEMPORARY TABLE params -- AS -- REPLACE() SUBSTITUTE() SSMS SQL DYNAMIC DECLARE(S)
CREATE OR REPLACE VIEW PROD_CHG_EDW.CHG_EDW.UVW_EXECUTIVE_DASHBOARD
CREATE OR REPLACE PROCEDURE PROD_CHG_EDW.CHG_EDW.DASH_HCT_FINAL(...)
CREATE OR REPLACE TABLE PROD_CHG_ODS.INFORMATICS.DASH_HCT_EDW AS  

-- Execute the procedure
-- CALL sp_date_calendar_iso();
CALL PROCEDURENAME();

CREATE OR REPLACE PROCEDURE DEV_CHG_EDW.CHG_EDW.LOAD_FACT_MEMEBERHISTORY()
RETURNS VARCHAR(16777216)
LANGUAGE SQL
EXECUTE AS OWNER
AS
 '
BEGIN
/*
* Stored procedure to execute data load for Fact Claims, which combines claims, claims detail and enrollment
* Create Date - 20230815
* Created By - John Costello
* 20240103 jcostello Modified FACILITYBILLCLASSSK to accomodate changes to DIM_FACILITYBILLCLASS
*/

END;  
';

CREATE OR REPLACE PROCEDURE db.schema.sp_procedure_name(
  StartDate DATE,
  EndDate DATE,
  textval VARCHAR,
  cashflow NUMBER(38,2),
  ratio NUMBER(9,1),
  NumberIs NUMBER,
  TrueFalse BOOLEAN
)
RETURNS VARCHAR
LANGUAGE SQL
AS
$$

DECLARE
  DefineMonth VARCHAR;
  DefineYear VARCHAR;
  begin_date DATE;
  whichcin VARCHAR;
  fileid VARCHAR;
  
BEGIN
  -- Set dynamic parameter values
  DefineMonth := CASE
    WHEN EXTRACT(MONTH FROM CURRENT_DATE()) = 1 THEN '12'
    ELSE EXTRACT(MONTH FROM CURRENT_DATE()) - 1
  END;
  
  DefineYear := CASE
    WHEN EXTRACT(MONTH FROM CURRENT_DATE()) = 1 THEN EXTRACT(YEAR FROM CURRENT_DATE()) - 1
    ELSE EXTRACT(YEAR FROM CURRENT_DATE())
  END;
  
  begin_date := CASE
    WHEN StartDate IS NULL THEN TO_DATE(DefineMonth || '/01/' || DefineYear, 'MM/DD/YYYY')
    ELSE StartDate
  END;
  
  whichcin := 'MA020';
  
  fileid := (
    SELECT MAX(FileID)
    FROM EnrollmentManager.dbo.FILE
    WHERE FileType LIKE '%'
  );
  
  -- Insert statements for the stored procedure here
  SELECT
    'Insert statements for the stored procedure here see "sp_CA43_...sql"' AS MESSAGE,
    DefineMonth AS MONTH,
    DefineYear AS YEAR,
    begin_date AS "RETRO CATEGORY MONTH",
    fileid AS "MAX() MONTHLY File Processed";
    
  RETURN 'Stored procedure executed successfully.';

END;
$$;







-- ======================================
	-- NOTE(S) | COMMENT(S): 
-- ======================================
JAH 'TRY_...'
Snowflake SQL with TRY_TO_NUMBER()

SELECT 
TRY_TO_NUMBER(SUBSTRING(TO_VARCHAR(QUEST_PHYSICAL_LAT), 1, 2)) 
+ TRY_TO_NUMBER('0.' || SUBSTRING(TO_VARCHAR(QUEST_PHYSICAL_LAT), 3)) 
AS "ALTER Latitude",
-1 * (
TRY_TO_NUMBER(SUBSTRING(TO_VARCHAR(QUEST_PHYSICAL_LONG), 1, 3)) 
+ TRY_TO_NUMBER('0.' || SUBSTRING(TO_VARCHAR(QUEST_PHYSICAL_LONG), 4))
) AS "ALTER Longitude",*
FROM PROD_CHG_ODS.INFORMATICS.QUEST_ANALYTICS_08052025
WHERE NVL(QUEST_PHYSICAL_LAT, '') != ''
ORDER BY QUEST_PHYSICAL_ADDRESS
LIMIT 10;
________________________________________

🔍 What is Happening Here?
Latitude:
		•	First 2 digits are treated as whole number (e.g., "32").
		•	Remainder becomes decimal: '0.' || '71593812' → 0.71593812
		•	Final result: 32 + 0.71593812 → 32.71593812
		
Longitude:
		•	First 3 digits as whole number (e.g., "117").
		•	Remainder as decimal: '0.' || '1628123' → 0.1628123
		•	Final result: -1 * (117 + 0.1628123) → -117.1628123
________________________________________

💡 Why Use TRY_TO_NUMBER()?
		•	It prevents your query from failing if any SUBSTRING() returns invalid characters (e.g., malformed input).
		•	Returns NULL instead of error on conversion failure.
		•	Ideal for working with dirty or external data.
________________________________________

Let me know if you want this wrapped in a view, turned into geospatial types, or used in filtering (e.g., bounding box queries).







JAH 'MAPBOX UPDATE(S): '
-- Step 1: Create a temporary table of duplicated MEMBERAKs
CREATE TEMP TABLE DUPLICATE_MEMBERAKS AS
SELECT MEMBERAK
FROM PROD_CHG_ODS.INFORMATICS.MAPBOX_TEST_LIST
GROUP BY MEMBERAK
HAVING COUNT(*) > 1;

-- Step 2: Query physical address data for those duplicates
SELECT m.MEMBERAK,
m.ROWLASTUPDATEDATE,
m.PHYSICAL_ADDRESS,
m.PHYSICAL_CITY,
m.PHYSICAL_STATE,
m.PHYSICAL_ZIP,
m.PHYSICAL_COUNTY,
m.PHYSICAL_LATITUDE,
m.PHYSICAL_LONGITUDE,
m.PHYSICAL_FULL_ZIP,
m.PHYSICAL_REGION
FROM PROD_CHG_ODS.INFORMATICS.MAPBOX_TEST_LIST AS m
    JOIN DUPLICATE_MEMBERAKS AS d ON m.MEMBERAK = d.MEMBERAK
ORDER BY m.MEMBERAK, m.ROWLASTUPDATEDATE;

-- Step 3: Record Count
SELECT ' ' AS "MAPBOX UPDATE(S): "
,COUNT(1) AS "RECORDS"
, TO_DATE(ROWLASTUPDATEDATE) AS ROWLASTUPDATEDATE
FROM PROD_CHG_ODS.INFORMATICS.MAPBOX_TEST_LIST
GROUP BY TO_DATE(ROWLASTUPDATEDATE);







JAH 'SNOWFLAKE' ON 20250124
x Missing member from fact_member months?

@John Costello - It looks like we have some missing members from fact_membermonths potentially?  This is resulting in members being excluded when creating one of the fire reports. 

Example: This member has a January row in SQL member months table but no January 2025 row in EDW

		SELECT ' ' AS 'INCOMPLETE',* 
		FROM INFORMATICS.dbo.EMPLOYEEGROUP_members
		WHERE 1=1
			AND memid IN ('2579410')

		select m.rowiscurrent, mm.start_date, m.membersk as dim_member_membersk, mm.*
		from chg_edw.dim_member as m
		join chg_edw.fact_membermonths as mm ON m.membersk=mm.membersk
		where m.memberak='2579410'
		order by mm.start_date;
		
CREATE OR REPLACE FUNCTION FN_EMERGENCY_INCIDENT_ANALYSIS_MAPBOX (
    IncidentName STRING,
    IncidentLatitude NUMBER(11,8),
    IncidentLongitude NUMBER(11,8)
)
RETURNS TABLE (
    risk_category STRING,
    incident_distance_miles NUMBER(10,3),
    memberak STRING,
    -- other columns...
)







JAH 'INFERIOR PLATFORM': 
SELECT 'May I have you assist me IN locating within or have the following tables uploaded into snowflake: ' AS "NOTE(S)";

-- SQLPROD01.HMOPROD_PLANDATA.dbo.paycheck AS pc;
-- SQLPROD01.HMOPROD_PLANDATA.dbo.checkhistory AS ch;
-- SQLPROD01.HMOPROD_PLANDATA.dbo.payment AS pmt;
-- SQLPROD01.HMOPROD_PLANDATA.dbo.qfund AS qf;
-- SQLPROD01.HMOPROD_PLANDATA.dbo.payvoucher;
-- SQLPROD01.HMOPROD_PLANDATA.dbo.claimeditmessage;
    
-- SELECT TOP 1 * FROM DEV_CHG_ODS.HMOPROD_PLANDATA.paycheck AS pc;
-- SELECT TOP 1 * FROM DEV_CHG_ODS.HMOPROD_PLANDATA.checkhistory AS ch;
-- SELECT TOP 1 * FROM DEV_CHG_ODS.HMOPROD_PLANDATA.payment AS pmt;
-- SELECT TOP 1 * FROM DEV_CHG_ODS.HMOPROD_PLANDATA.qfund AS qf;
-- SELECT TOP 1 * FROM DEV_CHG_ODS.HMOPROD_PLANDATA.payvoucher;
-- SELECT TOP 1 * FROM DEV_CHG_ODS.HMOPROD_PLANDATA.claimeditmessage;

SELECT 'May I have you assist me IN locating within or have the following tables uploaded into snowflake: ' AS "NOTE(S)"

-- SQLPROD01.QPROD.dbo.CS_REASON_CODE AS csrc ON cs.REASONCODE = csrc.REASONCODE
-- SQLPROD01.QPROD.dbo.CS_APPEALTYPE AS csa ON cs.APPEALTYPE = csa.APPEALTYPE

-- SELECT TOP 1 * FROM DEV_CHG_ODS.QPROD.CS_REASON_CODE AS csrc;
-- SELECT TOP 1 * FROM DEV_CHG_ODS.QPROD.CS_APPEALTYPE AS csa;

-- Note: The @LOB variable has been replaced with a Snowflake session variable :LOB
-- Make sure to set this variable before running the query, e.g.:
-- SET LOB = 'CL1';    

-- In the MERGE statements where we're comparing dates, replace:
AND ek."effdate"::datetime <= CURRENT_TIMESTAMP()
AND ek."termdate"::datetime >= CURRENT_TIMESTAMP()
AND ek."termdate"::datetime != ek."effdate"::datetime
AND ek."termdate"::datetime > ek."effdate"::datetime

-- With:
AND ek."effdate"::date <= CURRENT_DATE()
AND ek."termdate"::date >= CURRENT_DATE()
AND ek."termdate"::date != ek."effdate"::date
AND ek."termdate"::date > ek."effdate"::date

-- Make similar changes IN other MERGE statements, for example:
AND ma.effdate::date <= CURRENT_DATE()
AND ma.termdate::date >= CURRENT_DATE()
AND ma.termdate::date != ma.effdate::date
AND ma.termdate::date > ma.effdate::date

-- In the PaidClaims temporary table creation, replace:
WHERE TRY_TO_DATE(pc."checkprintdate") BETWEEN TRY_TO_DATE($chkstrt) AND TRY_TO_DATE($chkend)

-- With:
WHERE TRY_TO_DATE(pc."checkprintdate") BETWEEN TRY_TO_DATE($chkstrt)::date AND TRY_TO_DATE($chkend)::date

CREATE OR REPLACE TEMPORARY TABLE DEV_CHG_ODS.INFORMATICS.EligiblePopulation AS
SELECT 
    tde."Total Day(s) Enrolled", 
    tde."Total Month(s) Enrolled", 
    ce.*,
    FLOOR(tde."Total Day(s) Enrolled" / 365.25) AS "Total Years Enrolled",
    (tde."Total Month(s) Enrolled" - (FLOOR(tde."Total Day(s) Enrolled" / 365.25) * 12)) AS "Remaining Months Enrolled"
FROM DEV_CHG_ODS.INFORMATICS.ContinuousEnrollment AS ce
JOIN TotalDaysEnrolled AS tde ON ce.memid = tde.memid;

-- Sample / High Level Summary query
SELECT DISTINCT 
    ' ' AS "SAMPLE / HIGH LEVEL SUMARY: ",
    "LOB", 
    "Health Plan ID", 
    memid, 
    "fullname",
    "CONSECUTIVE DAY(S)", 
    "CONSECUTIVE MONTH(S)",
    ("Total Day(s) Enrolled" / 365.25)::DECIMAL(9,1) AS "Total Year(s) Enrolled",
    "Total Years Enrolled"::VARCHAR || ' YEAR(S) AND ' || 
    "Remaining Months Enrolled"::VARCHAR || ' MONTH(S)' AS "Total Year(s) & How Many Months Enrolled",
    "Total Month(s) Enrolled",
    "Total Day(s) Enrolled"
FROM DEV_CHG_ODS.INFORMATICS.EligiblePopulation;







JAH THANK  YOU JAH 'Claude.ai' ON 20240620 - Functionality Differences Between SSMS and Snowflake

ACT AS a Senior Data Analyst. May I have you list functionality lost when switching from SSMS to SNOWFLAKE?

As a Senior Data Analyst, I can provide you with a list of functionalities that may be lost or different when switching from SQL Server Management Studio (SSMS) to Snowflake. It's important to note that while some features may be lost, Snowflake offers its own set of unique capabilities. Here's a list of key differences:
1.	Local database management: SSMS allows direct management of local SQL Server instances, which is not applicable IN Snowflake's cloud-based environment.
2.	SQL Server-specific features: Tools for managing SQL Server Agent jobs, replication, and other SQL Server-specific features are not available IN Snowflake.
3.	Visual query plan analysis: SSMS provides detailed graphical execution plans, which are not available IN the same format IN Snowflake's web interface.
4.	Integrated source control: SSMS offers built-in integration with source control systems, which is not directly available IN Snowflake's web interface.
5.	Windows authentication: Snowflake doesn't support Windows authentication, which is commonly used IN SSMS.
6.	Design tools: SSMS includes visual designers for databases, tables, and other objects, which are not available IN Snowflake's interface.
7.	Profiler and tuning advisor: SQL Server Profiler and Database Engine Tuning Advisor tools are not available IN Snowflake.
8.	Backup and restore GUI: SSMS provides a graphical interface for backup and restore operations, which is handled differently IN Snowflake.
9.	Server-level management: SSMS allows management of server-level settings and configurations, which is not applicable IN Snowflake's cloud model.
10.	Extended events: SSMS provides tools for working with extended events, which are not available IN Snowflake.
11.	Policy-based management: SSMS offers policy-based management features that are not present IN Snowflake.
12.	Buffer pool extension: This SQL Server feature for extending buffer pool to SSDs is not applicable IN Snowflake.
Would you like me to elaborate ON any of these points or discuss how Snowflake addresses some of these functionalities differently?

Yes please elaborate

Certainly, I'll elaborate ON each point to provide more context and explain how Snowflake might address these functionalities differently:
1.	Local database management: SSMS allows direct management of local SQL Server instances. In contrast, Snowflake is entirely cloud-based. While this means you lose direct control over hardware, it also eliminates the need for on-premises infrastructure management and provides easier scalability.
2.	SQL Server-specific features: SSMS provides tools for managing SQL Server Agent jobs, replication, and other SQL Server-specific features. Snowflake handles these differently:
•	Instead of SQL Server Agent jobs, Snowflake uses tasks for scheduling and automation.
•	For replication, Snowflake offers data sharing and database replication features, but they work differently from SQL Server's replication.
3.	Visual query plan analysis: SSMS offers detailed graphical execution plans. Snowflake does provide query profiling, but it's text-based and accessed through SQL commands like EXPLAIN or QUERY_HISTORY. While not as visually intuitive, it still offers valuable performance insights.
4.	Integrated source control: SSMS has built-in integration with source control systems. Snowflake doesn't offer this directly IN its web interface, but you can use external tools or scripts to manage version control for Snowflake objects.
5.	Windows authentication: Snowflake doesn't support Windows authentication. Instead, it uses its own authentication methods, including username/password, SSO, and key pair authentication, which can be integrated with identity providers.
6.	Design tools: SSMS includes visual designers for databases, tables, and other objects. Snowflake's web interface is more code-centric, requiring SQL commands for object creation and modification. However, this can lead to more precise control and easier script-based management.
7.	Profiler and tuning advisor: While Snowflake lacks direct equivalents to SQL Server Profiler and Database Engine Tuning Advisor, it offers:
•	Query history and profiling features
•	Automatic query optimization
•	Resource monitors for tracking usage
8.	Backup and restore GUI: SSMS provides a graphical interface for backup and restore operations. Snowflake handles this differently:
•	Continuous data protection with time travel and fail-safe features
•	Cloning for quick backups and testing
•	Data export and import features for manual backups
9.	Server-level management: SSMS allows management of server-level settings. In Snowflake, many traditional server-level concepts are abstracted away. Instead, you manage account-level and warehouse-level settings, often through SQL commands or the web interface.
10.	Extended events: Snowflake doesn't have a direct equivalent to SQL Server's extended events. However, it provides:
•	Account usage views for monitoring
•	Logging and alerting features
•	Integration with external monitoring tools
11.	Policy-based management: While Snowflake doesn't offer policy-based management like SSMS, it provides:
•	Role-based access control
•	Resource monitors for usage control
•	Object tagging for organizing and managing database objects
12.	Buffer pool extension: This SQL Server feature isn't applicable IN Snowflake because of its cloud-native architecture. Snowflake automatically manages caching and performance optimization, reducing the need for manual memory management.
Would you like more information ON any specific area or how Snowflake's features compare to SSMS IN certain scenarios?

May I have you provide a list of the SSMS SQL commands which will be lost when switching to snowflake?

As a Senior Data Analyst, I can provide you with a list of SSMS SQL commands that are not directly available or are significantly different IN Snowflake. Keep IN mind that Snowflake may offer alternative ways to achieve similar functionality. Here's a list of notable SQL commands that will be lost or altered when switching from SSMS to Snowflake:
1.	System stored procedures:
•	sp_help, sp_who, sp_lock, etc.
•	xp_cmdshell
2.	Database maintenance commands:
•	DBCC commands (e.g., DBCC CHECKDB, DBCC SHRINKDATABASE)
•	BACKUP DATABASE / RESTORE DATABASE
3.	Security-related commands:
•	EXECUTE AS
•	REVERT
•	IMPERSONATE
4.	Transaction-related commands:
•	BEGIN DISTRIBUTED TRANSACTION
•	SAVE TRANSACTION
5.	Index-related commands:
•	CREATE SPATIAL INDEX
•	CREATE XML INDEX
6.	Full-text search commands:
•	CONTAINSTABLE
•	FREETEXTTABLE
7.	SQL Server Agent commands:
•	sp_add_job, sp_add_jobstep, etc.
8.	Linked server commands:
•	sp_addlinkedserver, sp_dropserver
9.	Replication commands:
•	sp_addpublication, sp_addsubscription, etc.
10.	Service Broker commands:
•	CREATE QUEUE
•	ALTER QUEUE
11.	XML-specific commands:
•	FOR XML clause variations (e.g., FOR XML RAW, FOR XML AUTO)
12.	Temporal table commands:
•	SYSTEM_VERSIONING
13.	Partitioning commands:
•	$PARTITION function
14.	Resource Governor commands:
•	CREATE RESOURCE POOL
•	ALTER RESOURCE GOVERNOR
15.	Extended property commands:
•	sp_addextendedproperty
16.	Synonym-related commands:
•	CREATE SYNONYM
17.	Filegroup management:
•	ALTER DATABASE ADD FILEGROUP
18.	Database mirroring commands:
•	ALTER DATABASE SET PARTNER
19.	Change data capture commands:
•	sys.sp_cdc_enable_table
20.	SQL Server-specific functions:
•	OPENROWSET
•	OPENDATASOURCE
It's important to note that while these specific commands may not be available IN Snowflake, the platform often provides alternative methods to achieve similar functionality. Would you like me to elaborate ON any specific areas or discuss Snowflake alternatives for any of these command categories?

May I have you provide a list of the SSMS SQL SYNTAX which will be lost when switching to snowflake?

Certainly. As a Senior Data Analyst, I can provide you with a list of SQL syntax elements that are specific to SQL Server Management Studio (SSMS) and will be lost or significantly different when switching to Snowflake. Here's a comprehensive list:
1.	Table hints:
•	WITH (NOLOCK), WITH (HOLDLOCK), etc.
2.	TOP clause with ties:
•	SELECT TOP (10) WITH TIES
3.	FORCESEEK and FORCESCAN hints:
•	FROM table WITH (FORCESEEK)
4.	PIVOT and UNPIVOT operators
5.	OVER clause extensions:
•	ROWS or RANGE BETWEEN IN window functions
6.	OUTPUT clause IN INSERT, UPDATE, DELETE:
•	INSERT ... OUTPUT inserted.*
7.	MERGE statement syntax
8.	Table variables with @ prefix:
•	DECLARE @TableVar TABLE (...)
9.	CROSS APPLY and OUTER APPLY
10.	COLLATE clause IN queries
11.	FOR XML clause variations:
•	FOR XML RAW, FOR XML AUTO, FOR XML PATH
12.	TABLESAMPLE clause
13.	WAITFOR statement
14.	ROWVERSION data type
15.	IDENTITY property with seed and increment:
•	IDENTITY(1,1)
16.	INSTEAD OF triggers
17.	TRY...CATCH error handling
18.	Common Table Expressions (CTEs) with recursive keyword:
•	WITH RECURSIVE ...
19.	READPAST table hint
20.	OPENQUERY for linked servers
21.	STRING_SPLIT function with ordinal parameter
22.	STUFF function
23.	INTERSECT and EXCEPT set operators
24.	GROUPING SETS, CUBE, and ROLLUP IN GROUP BY
25.	OFFSET ... FETCH syntax for pagination
26.	UPDATE with FROM clause
27.	INSERT ... EXECUTE syntax
28.	READTEXT, WRITETEXT, and UPDATETEXT
29.	sp_executesql for dynamic SQL
30.	FILESTREAM and FILETABLE features
31.	Temporal table syntax:
•	FOR SYSTEM_TIME AS OF
32.	FETCH ... WITH (READPAST)
33.	BULK INSERT syntax
34.	CREATE TYPE for user-defined types
35.	CREATE ASSEMBLY for CLR integration
While these syntax elements are not directly available IN Snowflake, it's important to note that Snowflake often provides alternative ways to achieve similar functionality. In many cases, you'll need to adapt your SQL code to use Snowflake's specific syntax and features.

Would you like me to elaborate ON any of these points or provide information ON Snowflake alternatives for specific syntax elements?







JAH THANK YOU JAH 'Claude.ai' ON 20240617 - Refactor SQL to Snowflake Stored Procedure AND PASS DYNAMIC @PARAM

STEP88_sp_STOREDPROCEDURE … Here is the refactored SQL script as a Snowflake stored procedure with dynamic parameters:

CREATE OR REPLACE PROCEDURE db.schema.sp_procedure_name(
  StartDate DATE,
  EndDate DATE,
  textval VARCHAR,
  cashflow NUMBER(38,2),
  ratio NUMBER(9,1),
  NumberIs NUMBER,
  TrueFalse BOOLEAN
)
RETURNS VARCHAR
LANGUAGE SQL
AS
$$
DECLARE
  DefineMonth VARCHAR;
  DefineYear VARCHAR;
  begin_date DATE;
  whichcin VARCHAR;
  fileid VARCHAR;
  
BEGIN
  -- Set dynamic parameter values
  DefineMonth := CASE
    WHEN EXTRACT(MONTH FROM CURRENT_DATE()) = 1 THEN '12'
    ELSE EXTRACT(MONTH FROM CURRENT_DATE()) - 1
  END;
  
  DefineYear := CASE
    WHEN EXTRACT(MONTH FROM CURRENT_DATE()) = 1 THEN EXTRACT(YEAR FROM CURRENT_DATE()) - 1
    ELSE EXTRACT(YEAR FROM CURRENT_DATE())
  END;
  
  begin_date := CASE
    WHEN StartDate IS NULL THEN TO_DATE(DefineMonth || '/01/' || DefineYear, 'MM/DD/YYYY')
    ELSE StartDate
  END;
  
  whichcin := 'MA020';
  
  fileid := (
    SELECT MAX(FileID)
    FROM EnrollmentManager.dbo.FILE
    WHERE FileType LIKE '%'
  );
  
  -- Insert statements for the stored procedure here
  SELECT
    'Insert statements for the stored procedure here see "sp_CA43_...sql"' AS MESSAGE,
    DefineMonth AS MONTH,
    DefineYear AS YEAR,
    begin_date AS "RETRO CATEGORY MONTH",
    fileid AS "MAX() MONTHLY File Processed";
    
  RETURN 'Stored procedure executed successfully.';
END;
$$;

Note the following changes:
		1.	The stored procedure is created using the CREATE OR REPLACE PROCEDURE statement IN Snowflake syntax.
		2.	The procedure takes dynamic parameters (StartDate, EndDate, textval, cashflow, ratio, NumberIs, TrueFalse) as input.
		3.	The DECLARE block is used to declare variables within the stored procedure.
		4.	Snowflake-specific functions like CURRENT_DATE(), EXTRACT(), and TO_DATE() are used for date calculations.
		5.	The SELECT statement is modified to use the declared variables.
		6.	The stored procedure returns a success message using the RETURN statement.

To utilize this stored procedure within an SSRS report, you can create a data source IN SSRS that connects to your Snowflake database and THEN use the stored procedure as a dataset IN your report. You can pass the dynamic parameter values from the report to the stored procedure.

Please note that you may need to adjust the schema and object names according to your Snowflake database structure.

Much Appreciated, Thank You 
Walter W Carr II 
Informatics Business Analyst
wcarr@chgsd.com
619 498 6510

 

This e-mail message is intended only for use by the individual, or recipient(s) entity to which it is addressed. This message is confidential and may contain information that is privileged, confidential and is exempt from disclosure under applicable law. If you are not the intended recipient(s), you may not review, copy, or distribute this message. If you have received this communication IN error, please notify us immediately by e-mail, or telephone and delete the original message.







JAH THANK YOU JAH 'Claude.ai' ON 20240603 - Comparing SSMS and Snowflake PLATFORM for Data Analysis

As a Senior Data Analyst, I understand your preference for SQL Server Management Studio (SSMS) over Snowflake. However, it is essential to recognize that both platforms have their strengths and are designed to cater to different use cases and requirements. Let me provide you with an objective comparison of the two:

Benefits of SSMS over Snowflake:
		1.	Familiarity and ecosystem: SSMS is part of the Microsoft SQL Server ecosystem, which has been widely used for decades. Many data professionals are already familiar with SSMS and its features, making it easier to adopt and use. Additionally, SSMS integrates well with other Microsoft tools and technologies.
		2.	On-premises deployment: SSMS is primarily designed for on-premises SQL Server installations. If your organization prefers to keep data within its own infrastructure for security, compliance, or other reasons, SSMS provides a robust solution.
		3.	Fine-grained control: SSMS offers a high level of control over database administration tasks, such as indexing, partitioning, and performance tuning. It provides a comprehensive set of tools and features for managing and optimizing SQL Server databases.
		4.	Stored procedures and functions: SSMS has extensive support for creating and managing stored procedures, user-defined functions, and other database objects. This can be advantageous for complex data processing and business logic implementation.
		5.	Integration with Microsoft BI tools: SSMS seamlessly integrates with Microsoft Business Intelligence (BI) tools like SQL Server Analysis Services (SSAS), SQL Server Reporting Services (SSRS), and SQL Server Integration Services (SSIS), enabling end-to-end BI solutions.

Benefits of Snowflake over SSMS:
		1.	Cloud-native architecture: Snowflake is built from the ground up as a cloud-native data platform. It leverages the scalability, elasticity, and flexibility of cloud computing, allowing users to scale resources up or down instantly based ON workload requirements.
		2.	Separation of storage and compute: Snowflake decouples storage and compute, enabling independent scaling of each component. This allows for cost optimization and the ability to scale compute resources without affecting storage costs.
		3.	Data sharing and collaboration: Snowflake provides native data sharing capabilities, allowing organizations to securely share live, governed data across regions, clouds, and with external parties. This facilitates seamless data collaboration and eliminates the need for data movement.
		4.	Support for diverse data types: Snowflake supports structured, semi-structured, and unstructured data, including JSON, Avro, and XML. It provides a unified platform for storing and querying diverse data types without the need for separate systems.
		5.	Simplified maintenance and automatic optimization: Snowflake handles many database administration tasks automatically, such as data distribution, query optimization, and storage management. This reduces the operational burden ON data teams and allows them to focus ON data analysis and insights.
		Ultimately, the choice between SSMS and Snowflake depends ON your specific requirements, existing infrastructure, and the nature of your data and workloads. While SSMS offers familiarity, control, and integration with Microsoft tools, Snowflake provides cloud-native scalability, data sharing capabilities, and support for diverse data types. It is important to evaluate your needs and consider factors like scalability, collaboration, and cloud adoption strategy when making a decision.

JAH THANK YOU JAH 

While both SSMS (SQL Server Management Studio) and Snowflake support standard SQL syntax, there are some differences IN the specific syntax and features each platform offers. Let us explore the trade-offs IN terms of syntax and functionality:

Syntax Trade-offs:
		1.	T-SQL (Transact-SQL) vs. SQL:
				•	SSMS uses T-SQL, which is Microsofts proprietary extension to standard SQL. T-SQL includes additional features and syntax elements specific to SQL Server.
				•	Snowflake uses standard SQL with some extensions and modifications specific to its platform. While it supports most standard SQL commands, some T-SQL-specific syntax may not be available IN Snowflake.
		2.	Stored Procedures and Functions:
				•	SSMS has extensive support for creating and managing stored procedures and user-defined functions using T-SQL.
				•	Snowflake supports stored procedures and user-defined functions using JavaScript, Python, or SQL. However, the syntax and functionality may differ from T-SQL.
		3.	Data Types:
				•	SSMS supports a wide range of data types, including SQL Server-specific types like datetime, uniqueidentifier, and geography.
				•	Snowflake has its own set of data types, including TIMESTAMP, VARIANT, and GEOGRAPHY. While there is overlap with standard SQL types, some SQL Server-specific types may not have direct equivalents IN Snowflake.
		4.	Partitioning and Indexing:
				•	SSMS provides robust partitioning and indexing options, including clustered and non-clustered indexes, columnstore indexes, and table partitioning.
				•	Snowflake automatically handles data distribution and partitioning based ON the data size and query patterns. It does not support explicit indexing, as it uses a proprietary data storage and retrieval mechanism.

Functionality Trade-offs:
		1.	Scalability and Elasticity:
				•	SSMS is primarily designed for on-premises deployments and may require manual scaling of resources.
				•	Snowflake is built for cloud scalability and allows instant scaling of compute resources up or down based ON workload demands.
		2.	Data Loading and ETL:
				•	SSMS integrates with SQL Server Integration Services (SSIS) for data loading and ETL processes.
				•	Snowflake offers a variety of data loading options, including bulk loading, streaming ingestion, and integration with external ETL tools. It also provides features like auto-ingest and zero-copy cloning.
		3.	Data Sharing and Collaboration:
				•	SSMS does not have built-in data sharing capabilities beyond traditional database permissions and access control.
				•	Snowflake offers native data sharing features, allowing organizations to securely share live, governed data across regions, clouds, and with external parties without data movement.
		4.	Ecosystem and Tooling:
				•	SSMS benefits from the extensive Microsoft ecosystem, including integration with Power BI, Azure services, and other Microsoft tools.
				•	Snowflake has its own ecosystem of partners and integrations, including popular BI and data integration tools. However, the ecosystem may not be as extensive as Microsoft's.
		5.	Cost Model:
				•	SSMS pricing is typically tied to SQL Server licenses and the underlying infrastructure costs.
				•	Snowflake follows a pay-per-use model, where costs are based ON the amount of data stored and the compute resources consumed during query execution.

It's important to note that both platforms have their strengths and are suitable for different use cases. SSMS offers familiarity, extensive T-SQL capabilities, and integration with the Microsoft ecosystem. Snowflake, ON the other hand, provides cloud-native scalability, data sharing features, and support for diverse data types. The choice between them depends ON factors such as scalability requirements, data collaboration needs, existing skillsets, and overall data strategy.







JAH 'SNOWFLAKE sp DEVELOPMENT'
x [2:48 PM] Adhikaran Saini
SP For ECM Like Reports
Hello Team,
 
Informatics
 
If you are creating the stored proc for all your ECM Like reports the conversion for the date below for column D and E might save you some time.
 
TO_VARCHAR(TO_DATE(ct."calldate"),'YYYYMMDD') BETWEEN :startdate AND :enddate
 
Thank you,
Adhi







JAH 'TEAMS' ON 20240528 
John Costello
1:41 PM
Thanks Nolyn

So team,   just a heads up after having identified the membermonths group of member, you will most likely need to join that to member history to scan for certain diagnosis codes and/or hcpc.    There is a cleaner way to do that by using CASE statements.    Here is my code for D-SNP Annual Dementia.  

Edited
CREATE OR REPLACE TEMPORARY TABLE TEMP_DSNP_DEMENTIA_ANNUAL_REPORTING AS 
        SELECT memlist.MEMBERAK
               , memlist.MEMBERSK
               , memlist.SECONDARY_ID
               , MAX(CASE WHEN DIAGNOSIS_CODE_SEARCH LIKE '%G31.84%' OR DIAGNOSIS_CODE_SEARCH LIKE '%F06.71%' OR  DIAGNOSIS_CODE_SEARCH LIKE '%F06.70%' OR DIAGNOSIS_CODE_SEARCH LIKE '%F01.50%' OR DIAGNOSIS_CODE_SEARCH LIKE '%F01.51%' OR DIAGNOSIS_CODE_SEARCH LIKE '%F01.xy%' OR DIAGNOSIS_CODE_SEARCH LIKE '%F01.Ay%' 
                           OR DIAGNOSIS_CODE_SEARCH LIKE '%F01.By%' OR DIAGNOSIS_CODE_SEARCH LIKE '%F01.Cy%' OR DIAGNOSIS_CODE_SEARCH LIKE '%F02.80%' OR DIAGNOSIS_CODE_SEARCH LIKE '%F02.81%' OR DIAGNOSIS_CODE_SEARCH LIKE '%F02.xw%' OR DIAGNOSIS_CODE_SEARCH LIKE '%F02.Ay%' OR DIAGNOSIS_CODE_SEARCH LIKE '%F02.By%'
                           OR DIAGNOSIS_CODE_SEARCH LIKE '%F02.Cy%' OR DIAGNOSIS_CODE_SEARCH LIKE '%F03.Ay%' OR DIAGNOSIS_CODE_SEARCH LIKE '%F03.By%' OR DIAGNOSIS_CODE_SEARCH LIKE '%F03.Cy%' OR DIAGNOSIS_CODE_SEARCH LIKE '%331.0%' OR DIAGNOSIS_CODE_SEARCH LIKE '%331.11%' OR DIAGNOSIS_CODE_SEARCH LIKE '%331.19%'
                           OR DIAGNOSIS_CODE_SEARCH LIKE '%331.82%' OR DIAGNOSIS_CODE_SEARCH LIKE '%294.11%' OR DIAGNOSIS_CODE_SEARCH LIKE '%294.10%' OR DIAGNOSIS_CODE_SEARCH LIKE '%290.40%' OR DIAGNOSIS_CODE_SEARCH LIKE '%290.41%' OR DIAGNOSIS_CODE_SEARCH LIKE '%290.42%' OR DIAGNOSIS_CODE_SEARCH LIKE '%290.43%'
                           THEN '1'
                      ELSE '0'
                 END) AS COGNITIVE_IMPAIRMENT
               , MAX(CASE WHEN (HCPC_CODE_SEARCH LIKE '%96116%' OR HCPC_CODE_SEARCH LIKE '%96136%' OR HCPC_CODE_SEARCH LIKE '%96138%' OR HCPC_CODE_SEARCH LIKE '%96146%' OR HCPC_CODE_SEARCH LIKE '%99483%') AND fmh.CLAIM_START_DATE >= :startdate AND fmh.CLAIM_START_DATE <= :enddate THEN '1'
                          ELSE '0'
                     END) AS COGNITIVE_ASSESSMENT
        FROM TEMP_CONSECUTIVE_DSNP_MEMBERS AS memlist
        JOIN PROD_CHG_EDW.CHG_EDW.FACT_MEMBERHISTORY AS fmh ON memlist.MEMBERSK = fmh.MEMBERSK
        JOIN PROD_CHG_EDW.CHG_EDW.DIM_CLAIMDIAGNOSIS AS dcd ON fmh.CLAIMDIAGNOSISSK = dcd.CLAIMDIAGNOSISSK
        JOIN PROD_CHG_EDW.CHG_EDW.DIM_AUTHORIZATIONSERVICE AS das ON fmh.AUTHORIZATIONSERVICESK = das.AUTHORIZATIONSERVICESK
        GROUP BY memlist.MEMBERAK
               , memlist.MEMBERSK
               , memlist.SECONDARY_ID;CREATE OR REPLACE TEMPORARY TABLE TEMP_DSNP_DEMENTIA_ANNUAL_REPORTING AS 


👍
1 Like reaction.
1 has context menu








-- =====================================================================
	-- DECLARE PARAMETER(S) / FILTER(S) --
-- =====================================================================
DECLARE ClockStart AS datetime;
DECLARE ClockStop AS datetime;
DECLARE IPPdt AS datetime;
DECLARE gapallowance AS decimal(9,0);
DECLARE SearchString AS nvarchar (25);
DECLARE @effday AS int;

SET @ClockStart = TRY_CONVERT(date,'01/01/2023')
SET @ClockStop = TRY_CONVERT(date,GETDATE())
SET IPPdt = TRY_CONVERT(date,GETDATE());
SET gapallowance = 14;
SET SearchString = '%'+'NANCY'+'%'; -- WILDCARD DECLARE(s)
SET @effday = (SELECT DISTINCT @ClockStop FROM [INFORMATICS].dbo.[date_calendarISO] WHERE 1=1 AND @ClockStop = DATEPART(dd,TRY_CONVERT(date,GETDATE()))) ;

		SELECT :ClockStart,:ClockStop FROM [member AS months Fact]
		
/*Query Below*/
SELECT ' ' AS "SIR DANIEL"
    --Will select required fields once the logic is confirmed
    ,FMH.*
FROM PROD_CHG_EDW.CHG_EDW.FACT_MEMBERHISTORY AS FMH
    JOIN PROD_CHG_EDW.CHG_EDW.DIM_MEMBER AS DM ON FMH.MEMBERSK = DM.MEMBERSK
    JOIN PROD_CHG_EDW.CHG_EDW.DIM_BENEFITPLAN AS DMP ON FMH.BENEFITPLANSK = DMP.BENEFITPLANSK
    JOIN PROD_CHG_EDW.CHG_EDW.DIM_PROVIDERSPECIALTY AS DPS ON FMH.PROVIDERSK = DPS.PROVIDERSK
    JOIN PROD_CHG_EDW.CHG_EDW.DIM_SERVICECODE AS DSC ON FMH.SERVICECODESK = DSC.SERVICECODESK
WHERE 1= 1
    AND FMH.CLAIMSTATUS = 'PAID'
    AND FMH.CLAIMDETAILSTATUS not IN ('DENY', 'VOID')
    AND FMH.AMOUNTPAID >= 100
    AND FMH.CLAIMSTARTDATE BETWEEN '20230101' AND '20231231'
    AND DMP.LOB = 'Medi-Cal'
    AND DPS.PRIMARYSPECIALTYCODE1 NOT IN ('CHI', 'PHT', 'ACU', 'RDO', 'POD', 'OCT', 'SPT')
    -- AND DSC.CODEIDAK IN (
        --<insert codes from excel spreadsheet here. unless there is a table I can use to isolate said codes>
    -- )
LIMIT 10 -- TOP ...







-- =====================================================================
	-- DECLARE @PARAMETER(S) / @FILTER(S) --
-- =====================================================================
--------------------------------------------------------------------------------------------------------------------
	-- Error Trapping: Check If Permanent Table(s) Already Exist(s) And Drop If Applicable --
--------------------------------------------------------------------------------------------------------------------
CREATE OR REPLACE TEMPORARY TABLE params  
( -- INITIATE ...
my_var number
,start_dt timestamp
,SearchString varchar(255) -- see CREATE TABLE #employee
,lag int
-- ,lagyrs AS int
-- ,prevlagyrs AS int
-- ,lagdays AS int
-- ,lagmonths AS int
-- ,when AS timestamp
-- ,footnotedt AS varchar(25)
-- ,StartDT AS timestamp
-- ,EndDT AS timestamp
-- ,Start AS timestamp
-- ,End AS timestamp
-- ,rangeprefix AS varchar(100)
-- ,TruevFalse AS binary
-- ,DYNAMICLIKE AS varchar(255) -- LIKE '%[@PARAMETER]%'
-- ,LOB AS varchar(255) -- LIKE '%[@PARAMETER]%'
-- ,memid AS varchar(25)
-- ,dosSTART AS timestamp
-- ,dosEND AS timestamp
-- ,SYSisB AS varchar(4)
-- ,pos AS varchar(2) -- SELECT 'TELEHEALTH ("02") ANALYSIS DUE TO COVID - 19' AS [NOTE(S)],* FROM INFORMATICS2.dbo.SHELLpos
-- ,proposedflatrate AS decimal(9,2) -- SELECT 'TELEHEALTH ("02") ANALYSIS DUE TO COVID - 19' AS [NOTE(S)],* FROM INFORMATICS2.dbo.SHELLpos
); -- CONCLUDE WITH();

INSERT INTO params
SELECT 10 AS my_var
,GETDATE() AS start_dt
,'UP AGAINST' AS SearchString
,28 AS Lag;

        SELECT ' ' AS "SNOWFLAKE DECLARE(S)",* FROM params;

SQL CONVERTed to SNOWFLAKE:

If using DECLARE to define variables is not working IN your SNOWFLAKE environment, here are some alternative options:

		SELECT ' ' AS 'ISOLATE FOR EVERY[DAY](S)',[NOTE(S)] = 'see "STEP88_AdmitsLogic_...sql"',[Last day of a month from a date:]  = EOMONTH(CURRENT_TIMESTAMP(),0)
		SELECT ' ' AS 'FOM USING EOMONTH SQL',DATEADD(DAY,1,EOMONTH(CURRENT_TIMESTAMP(),-2)) AS [1st OF PREVIOUS MONTH],DATEADD(DAY,1,EOMONTH(CURRENT_TIMESTAMP(),-1)) AS [1st OF MONTH],DATEADD(DAY,1,EOMONTH(CURRENT_TIMESTAMP(),0)) AS [1st OF NEXT MONTH] -- EOMONTH ( start_date ,[ month_to_add ] )
		SELECT ' ' AS 'EOM USING EOMONTH SQL',EOMONTH(CURRENT_TIMESTAMP(),-1) AS [EO PREVIOUS MONTH],EOMONTH(CURRENT_TIMESTAMP(),0) AS [EO CURRENT MONTH],EOMONTH(CURRENT_TIMESTAMP(),1) AS [EO NEXT MONTH] -- EOMONTH (start_date ,[ month_to_add ])

		⏎ DECLARE StartDT DATE = TO_DATE(CONCAT(LPAD(MONTH(DATEADD('month', <lag>, CURRENT_TIMESTAMP())),2,'0'),'/01/',YEAR(DATEADD('month', <lag>, CURRENT_TIMESTAMP()))));

The key differences when CONVERTing to SNOWFLAKE are:
		⏎ Use DATE instead of datetime for just a date value
		⏎ Use TO_DATE() to CONVERT a formatted string to a Date
		⏎ Use CURRENT_TIMESTAMP() instead of GETDATE()
		⏎ Use || for concatenation instead of +
		⏎ Use LPAD() to left pad numbers with zeros
		⏎ Use single quotes for string literals

		⏎ DECLARE StartDT DATE = TO_DATE(CONCAT(LPAD(MONTH(DATEADD('month', -1, CURRENT_TIMESTAMP())),2,'0'),'/01/',YEAR(DATEADD('month', -1, CURRENT_TIMESTAMP()))));

This declares StartDT as the first of the previous month relative to the current timestamp. Let me know if you need any clarification or have additional examples to CONVERT!

		⏎ DECLARE @StartDT date = CAST(CAST(DATEPART(mm,DATEADD(month,@lag,CAST(GETDATE() AS datetime))) AS varchar(2))+'/01/'+CAST(DATEPART(yyyy,DATEADD(month,@lag,CAST(GETDATE() AS datetime))) AS varchar(4)) AS datetime)

DECLARE StartDT DATE = TO_DATE(
    CONCAT(
        LPAD(MONTH(DATEADD('month', <lag>, CURRENT_TIMESTAMP())), 2, '0'), 
        '/01/',
        YEAR(DATEADD('month', <lag>, CURRENT_TIMESTAMP()))
    );

SET @SearchString = 'see "STEP88 DYNAMIC...sql"'
SET @leadlag = -28 --IN MONTH(s) UPDATE() +-
SET @leadlagyrs = 1 --IN YEAR(s) UPDATE() +-
SET @prevlagyrs = -1 --IN YEAR(s) UPDATE() +-
SET @leadlagdays = -1 --IN DAY(s) UPDATE() +-
SET @leadlagmonths = 12 --IN MONTH(s) UPDATE() +-
SET @when = NULL
SET @footnotedt = 'Last Updated: ' --'Last Updated: 01/27/2017' --PRESET TO NEXT FRIDAY
SET @StartDT = CAST(CAST(DATEPART(mm,DATEADD(month,@lag,CAST(GETDATE() AS datetime))) AS varchar(2))+'/01/'+CAST(DATEPART(yyyy,DATEADD(month,@lag,CAST(GETDATE() AS datetime))) AS varchar(4)) AS datetime)
SET @EndDT = DATEADD(day,@lagdays,DATEADD(month,@lagmonths,@StartDt))
SET @Start  = @StartDT
SET @End = @EndDT
SET @rangeprefix  = 'DATE(s) of SERVICE BETWEEN ' --'RECEIVED (aka CLEANDATE) BETWEEN ' --'CHECK DATE(s) BETWEEN ' --'POST DATE(s) BETWEEN ' '--ALL TIME' AS [RANGE]
SET @TruevFalse = NULL
SET @DYNAMICLIKE = '%'+@SearchString+'%' -- LIKE '%[@PARAMETER]%'
SET @LOB  = '%%%' -- LIKE '%[@PARAMETER]%'
SET @memid = CAST(NULL AS varchar(25)) -- ISO ON SPECIFIC MEMBER
SET @dosSTART = @StartDT
SET @dosEND = @EndDT
SET @SYSisB = 'QNXT'
SET @pos = NULL; -- SELECT 'TELEHEALTH ("02") ANALYSIS DUE TO COVID - 19' AS [NOTE(S)],* FROM INFORMATICS2.dbo.SHELLpos
SET @proposedflatrate = 2800

-- =====================================================================
	-- DECLARE @PARAMETER(S) / @FILTER(S) --
-- =====================================================================
--------------------------------------------------------------------------------------------------------------------
	-- Error Trapping: Check If Permanent Table(s) Already Exist(s) And Drop If Applicable --
--------------------------------------------------------------------------------------------------------------------
DROP TABLE params; -- SQL Server 2016 and later -- DYNAMIC tmp OR STATIC [TABLE] #INFORMATICS.dbo.REINSURANCE_IP is a local temporary table visible only IN the current session; ##INFORMATICS.dbo.REINSURANCE_IP is a GLOBAL temporary table visible to all sessions IN ('TempDB')

-- CREATE OR REPLACE TEMPORARY TABLE params; -- SQL Server 2016 and later -- DYNAMIC tmp OR STATIC [TABLE] #INFORMATICS.dbo.REINSURANCE_IP is a local temporary table visible only IN the current session; ##INFORMATICS.dbo.REINSURANCE_IP is a GLOBAL temporary table visible to all sessions IN ('TempDB')

CREATE TEMPORARY TABLE params
( -- INITIATE ...
my_var number
,start_dt timestamp
,SearchString varchar(255) -- see CREATE TABLE #employee
,lag int
-- ,lagyrs AS int
-- ,prevlagyrs AS int
-- ,lagdays AS int
-- ,lagmonths AS int
-- ,when AS timestamp
-- ,footnotedt AS varchar(25)
-- ,StartDT AS timestamp
-- ,EndDT AS timestamp
-- ,Start AS timestamp
-- ,End AS timestamp
-- ,rangeprefix AS varchar(100)
-- ,TruevFalse AS binary
-- ,DYNAMICLIKE AS varchar(255) -- LIKE '%[@PARAMETER]%'
-- ,LOB AS varchar(255) -- LIKE '%[@PARAMETER]%'
-- ,memid AS varchar(25)
-- ,dosSTART AS timestamp
-- ,dosEND AS timestamp
-- ,SYSisB AS varchar(4)
-- ,pos AS varchar(2) -- SELECT 'TELEHEALTH ("02") ANALYSIS DUE TO COVID - 19' AS [NOTE(S)],* FROM INFORMATICS2.dbo.SHELLpos
-- ,proposedflatrate AS decimal(9,2) -- SELECT 'TELEHEALTH ("02") ANALYSIS DUE TO COVID - 19' AS [NOTE(S)],* FROM INFORMATICS2.dbo.SHELLpos
); -- CONCLUDE WITH();

INSERT INTO params -- (FIELDS) 

-- VALUES 
-- ( -- INITIATE ...
-- 10 AS [my_var]
-- ,GETDATE() AS [start_dt]
-- ,'UP AGAINST' AS [SearchString]
-- ,28 AS [Lagdays]
-- ); -- CONCLUDE WITH();

SELECT 10 AS my_var
,GETDATE() AS start_dt
,'UP AGAINST' AS SearchString
,28 AS Lag

EXCEPT -- LIKE '%INTERSECT%'... ensure that only rows IN the first result set that are NOT NO NEGATIVE != <> IN the second are returned. This means that the EXCEPT() operator is query order-sensitive, like the LEFT JOIN and RIGHT JOIN. see 'https://sqlbolt.com/topic/set_operations'
-- MINUS
SELECT * FROM params;

        SELECT p.my_var + 5,p.start_dt
		,p.*,bp.* 
		-- SELECT 'BETWEEN '+CAST(CAST(@StartDT AS date) AS varchar(255))+' AND '+CAST(CAST(@EndDT AS date) AS varchar(255)) AS [RANGE NOTE(s)]
		-- ,(SELECT INFORMATICS.core.udfGetLobFromPlanId(bp.planid)) AS [LINE_OF_BUSINESS],bp.*
		FROM params AS p,PROD_CHG_ODS.HMOPROD_PLANDATA.BENEFITPLAN AS bp 
		WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ...
			-- AND ISNULL(bp.planid,'') LIKE @LOB







-- =====================================================================
	-- DECLARE @PARAMETER(S) / @FILTER(S) --
-- =====================================================================
--------------------------------------------------------------------------------------------------------------------
	-- Error Trapping: Check If Permanent Table(s) Already Exist(s) And Drop If Applicable --
--------------------------------------------------------------------------------------------------------------------
DROP TABLE params; -- SQL Server 2016 and later -- DYNAMIC tmp OR STATIC [TABLE] #INFORMATICS.dbo.REINSURANCE_IP is a local temporary table visible only IN the current session; ##INFORMATICS.dbo.REINSURANCE_IP is a GLOBAL temporary table visible to all sessions IN ('TempDB')

-- CREATE OR REPLACE TEMPORARY TABLE params; -- SQL Server 2016 and later -- DYNAMIC tmp OR STATIC [TABLE] #INFORMATICS.dbo.REINSURANCE_IP is a local temporary table visible only IN the current session; ##INFORMATICS.dbo.REINSURANCE_IP is a GLOBAL temporary table visible to all sessions IN ('TempDB')

CREATE TEMPORARY TABLE params
( -- INITIATE ...
my_var number
,start_dt timestamp
,SearchString varchar(255) -- see CREATE TABLE #employee
-- ,lag AS int
-- ,lagyrs AS int
-- ,prevlagyrs AS int
-- ,lagdays AS int
-- ,lagmonths AS int
-- ,when AS timestamp
-- ,footnotedt AS varchar(25)
-- ,StartDT AS timestamp
-- ,EndDT AS timestamp
-- ,Start AS timestamp
-- ,End AS timestamp
-- ,rangeprefix AS varchar(100)
-- ,TruevFalse AS binary
-- ,DYNAMICLIKE AS varchar(255) -- LIKE '%[@PARAMETER]%'
-- ,LOB AS varchar(255) -- LIKE '%[@PARAMETER]%'
-- ,memid AS varchar(25)
-- ,dosSTART AS timestamp
-- ,dosEND AS timestamp
-- ,SYSisB AS varchar(4)
-- ,pos AS varchar(2) -- SELECT 'TELEHEALTH ("02") ANALYSIS DUE TO COVID - 19' AS [NOTE(S)],* FROM INFORMATICS2.dbo.SHELLpos
-- ,proposedflatrate AS decimal(9,2) -- SELECT 'TELEHEALTH ("02") ANALYSIS DUE TO COVID - 19' AS [NOTE(S)],* FROM INFORMATICS2.dbo.SHELLpos
); -- CONCLUDE WITH();

INSERT INTO params -- (FIELDS) 
-- SELECT 10,GETDATE()
VALUES 
( -- INITIATE ...
10
-- ,GETDATE()
,CURRENT_TIMESTAMP() AS start_dt
,'UP AGAINST'
); -- CONCLUDE WITH();

        SELECT p.my_var + 5,p.start_dt
		,p.*,bp.* 
		-- SELECT 'BETWEEN '+CAST(CAST(@StartDT AS date) AS varchar(255))+' AND '+CAST(CAST(@EndDT AS date) AS varchar(255)) AS [RANGE NOTE(s)]
		-- ,(SELECT INFORMATICS.core.udfGetLobFromPlanId(bp.planid)) AS [LINE_OF_BUSINESS],bp.*
		FROM params AS p,PROD_CHG_ODS.HMOPROD_PLANDATA.BENEFITPLAN AS bp 
		WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ...
			-- AND ISNULL(bp.planid,'') LIKE @LOB







JAH 'Claude.ai ChatGPT BARD' ON 20231026 - Converting SQL DECLARE(S)  / VARIABLE(S) / PARAMETER(S) to SNOWFLAKE
x You are welcome! I am glad I could provide some alternative options for simulating variables IN SNOWFLAKE since thx e DECLARE method was not working for you. Using temporary tables, session variables, query parameters, or a parameter table can serve similar purposes to declaring variables IN many cases. Just let me know if you need any help implementing one of those patterns or have any other SNOWFLAKE questions come up. I am always happy to help translate SQL concepts and workarounds to SNOWFLAKE!

EH
May I have you CONVERT the attached SQL declare into a SNOWFLAKE declare

		⏎ DECLARE @StartDT date = CAST(CAST(DATEPART(mm,DATEADD(month,@lag,CAST(GETDATE() AS datetime))) AS varchar(2))+'/01/'+CAST(DATEPART(yyyy,DATEADD(month,@lag,CAST(GETDATE() AS datetime))) AS varchar(4)) AS datetime)

EH
Here is the equivalent SNOWFLAKE SQL for declaring a start date variable:

sql

Copy code

		⏎ DECLARE StartDT DATE = TO_DATE(CONCAT(LPAD(MONTH(DATEADD('month', <lag>, CURRENT_TIMESTAMP())),2,'0'),'/01/',YEAR(DATEADD('month', <lag>, CURRENT_TIMESTAMP()))));

The key differences when CONVERTing to SNOWFLAKE are:
		⏎ Use DATE instead of datetime for just a date value
		⏎ Use TO_DATE() to CONVERT a formatted string to a Date
		⏎ Use CURRENT_TIMESTAMP() instead of GETDATE()
		⏎ Use || for concatenation instead of +
		⏎ Use LPAD() to left pad numbers with zeros
		⏎ Use single quotes for string literals

-- ==============================================================
	-- SINGLE QUOTE() v. DOUBLE QUOTE() --
-- ==============================================================
SELECT DISTINCT '=IF(AND(OR(F2=F1,F2=F3),OR(D2=D1,D2=D3)),'+'"'+'TWIN'+'"'+','+'"'+'"'+')' AS [TWIN CHECK] -- DOUBLE QUOTE(s)
SELECT DISTINCT '=IF(AND(OR(F2=F1,F2=F3),OR(D2=D1,D2=D3)),'+''''+'TWIN'+''''+','+''''+''''+')' AS [TWIN CHECK] -- SINGLE QUOTE(s)

		SELECT 'Children'+''''+'s Specialists of San Diego'

		⏎ DECLARE StartDT DATE = TO_DATE(CONCAT(LPAD(MONTH(DATEADD('month', -1, CURRENT_TIMESTAMP())),2,'0'),'/01/',YEAR(DATEADD('month', -1, CURRENT_TIMESTAMP()))));

This declares StartDT as the first of the previous month relative to the current timestamp. Let me know if you need any clarification or have additional examples to CONVERT!

		⏎ DECLARE @StartDT date = CAST(CAST(DATEPART(mm,DATEADD(month,@lag,CAST(GETDATE() AS datetime))) AS varchar(2))+'/01/'+CAST(DATEPART(yyyy,DATEADD(month,@lag,CAST(GETDATE() AS datetime))) AS varchar(4)) AS datetime)

DECLARE StartDT DATE = TO_DATE(
    CONCAT(
        LPAD(MONTH(DATEADD('month', <lag>, CURRENT_TIMESTAMP())), 2, '0'), 
        '/01/',
        YEAR(DATEADD('month', <lag>, CURRENT_TIMESTAMP()))
    )
);

To use it with a specific lag value:

DECLARE StartDT DATE = TO_DATE(
    CONCAT(
        LPAD(MONTH(DATEADD('month', -1, CURRENT_TIMESTAMP())), 2, '0'),
        '/01/', 
        YEAR(DATEADD('month', -1, CURRENT_TIMESTAMP()))
    )
);

This will declare StartDT as the first day of the previous month relative to the current timestamp. Let me know if you need any other SQL CONVERTed to SNOWFLAKE!

Copy

Thank you

EH
You are welcome! I'm glad I could help CONVERT that SQL declare statement into SNOWFLAKE syntax. Let me know if you have any other examples you need help translating from SQL to SNOWFLAKE. Converting between database platforms can be tricky, so I'm happy to assist however I can. Just provide any additional SQL snippets and I'll do my best to provide the equivalent SNOWFLAKE code.

Copy

This failed when attempting to execute. May i have you explain step by step how to use a DECLARE IN SNOWFLAKE?

EH
Sure, let's walk through how to use DECLARE IN SNOWFLAKE step-by-step:

Start a SNOWFLAKE query/script with the DECLARE keyword followed by the name and data type of the variable you want to declare.
For example:

sql

Copy code

DECLARE my_var NUMBER;
Optionally assign a value to the declared variable using =. This can be done IN the same statement or a separate statement.
For example:

sql

Copy code

DECLARE my_var NUMBER = 10;

-- Or

DECLARE my_var NUMBER;
SET my_var = 10;
Reference the declared variable wherever needed IN the query/script.
For example:

sql

Copy code

DECLARE my_var NUMBER = 10;

SELECT my_var + 5;
The scope of the variable is within the query/script it is declared. It will not persist across queries.
Declare variables near the top of the script before first use.
Make sure to terminate each statement with a semi-colon ;
So IN summary:

Use DECLARE to declare variable
Assign value with = or SET
Reference IN queries with variable name
Declare at top before first use
End statements with ;
Let me know if this helps explain how to properly use DECLARE IN SNOWFLAKE or if you have any other questions!

Copy

Unfortunately this likewise generated an error. Is there an alternative?

EH
If using DECLARE to define variables is not working IN your SNOWFLAKE environment, here are some alternative options:

Use temporary tables instead of variables:
sql

Copy code

CREATE TEMPORARY TABLE params (
  my_var NUMBER
);

INSERT INTO params (my_var) VALUES (10);

SELECT my_var + 5 FROM params;
Use session variables:
sql

Copy code

SET my_var = 10;

SELECT SESSION_USER, my_var + 5 FROM table;
Use query parameters:
sql

Copy code

SELECT ? + 5 FROM table;
Then pass 10 as a bind variable value for the parameter.

Create a permanent table to store parameters:
sql

Copy code

CREATE TABLE params (
  name VARCHAR, 
  value VARIANT
);

INSERT INTO params (name, value) 
VALUES ('my_var', 10);

SELECT value::NUMBER + 5 
FROM params
WHERE name = 'my_var';
The key difference with these approaches is that the values will persist across queries within the same session/connection.

Let me know if any of those alternatives work for you or if you have any other questions!

Copy
Retry

No file chosen

		⏎ to send, shift + ⏎ to add a new line, Ctrl + K to create a new chat







-- ====================================================================
	-- QNXT MEMBERSHIP --
-- ====================================================================
-- =================================================================
	-- DYNAMIC() v. STATIC() DECLARE(s) FOR [...] --
-- =================================================================
DECLARE @when AS date
DECLARE @PCPrecordRANK AS int
-- DECLARE @provider AS nvarchar(25) -- see JOIN #PROVISOLATION AS piso ON a1.provid = piso.provid BELOW...
-- DECLARE @payto AS nvarchar(25) -- see JOIN #PROVISOLATION AS piso ON a1.provid = piso.provid BELOW...
DECLARE @whichfbu nvarchar(25)
DECLARE @whichaidcode AS nvarchar(5)
-- DECLARE @whichcin AS nvarchar(5)

SET @when = GETDATE() -- ESTABLISH CUTOFF DT()
SET @PCPrecordRANK = 1 -- ENTER 1 TO GET() JUST MOST CURRENT [RANKis] see DENSE_RANK() OVER(PARTITION BY ek.memid ORDER BY CAST(ek.effdate AS date) DESC) AS [RANKis] --'RANKis' --RANK by MOST CURRENT EligHx
-- SET @provider = '' -- LOCK IN A SPECIFIC PROVIDER
-- SET @payto = '953397369' -- LOCK IN A SPECIFIC PROVIDER '953397369'
SET @whichfbu = 'MA019' --[MemberAttribute](s) FBU
SET @whichaidcode = 'MA002' -- AIDCODE aka CMCapCode aka SUBSC_DEPT
-- SET @whichcin = 'MA020' -- [MemberAttribute](s) CIN

SELECT TOP 1 @when AS [Membership Assessment Date],bp.description AS [LINE_OF_BUSINESS],* FROM HMOPROD_PLANDATA.dbo.benefitplan AS bp

EH
Here is the SQL CONVERTed to SNOWFLAKE syntax:

sql
Copy code

-- ====================================================================
-- QNXT MEMBERSHIP -- 
-- ====================================================================
-- =================================================================
-- DYNAMIC() v. STATIC() DECLARE(s) FOR [...] --
-- =================================================================
DECLARE when DATE;
DECLARE PCPrecordRANK NUMBER;
-- DECLARE provider VARCHAR(25); -- see JOIN #PROVISOLATION AS piso ON a1.provid = piso.provid BELOW... 
-- DECLARE payto VARCHAR(25); -- see JOIN #PROVISOLATION AS piso ON a1.provid = piso.provid BELOW...
DECLARE whichfbu VARCHAR(25);
DECLARE whichaidcode VARCHAR(5); 
-- DECLARE whichcin VARCHAR(5);

SET when = CURRENT_DATE(); -- ESTABLISH CUTOFF DT()
SET PCPrecordRANK = 1; -- ENTER 1 TO GET() JUST MOST CURRENT [RANKis] see DENSE_RANK() OVER(PARTITION BY ek.memid ORDER BY CAST(ek.effdate AS DATE) DESC) AS [RANKis] --'RANKis' --RANK by MOST CURRENT EligHx  
-- SET provider = ''; -- LOCK IN A SPECIFIC PROVIDER
-- SET payto = '953397369'; -- LOCK IN A SPECIFIC PROVIDER '953397369'
SET whichfbu = 'MA019'; --[MemberAttribute](s) FBU  
SET whichaidcode = 'MA002'; -- AIDCODE aka CMCapCode aka SUBSC_DEPT
-- SET whichcin = 'MA020'; -- [MemberAttribute](s) CIN

SELECT TOP 1 when AS [Membership Assessment Date], bp.description AS [LINE_OF_BUSINESS], *
FROM HMOPROD_PLANDATA.dbo.benefitplan AS bp;

The main changes:

		Replaced SQL Server DECLARE with SNOWFLAKE DECLARE
		Replaced GETDATE() with CURRENT_DATE()
		Replaced NVARCHAR with VARCHAR
		Removed GO statements
		Changed TOP 1 to LIMIT 1
		Changed dbo schema references to just table name

Let me know if you have any other questions!

Copy
Retry

Thank you

No file chosen

⏎ to send, shift + ⏎ to add a new line, Ctrl + K to create a new chat
Claude
Error Due to unexpected capacity constraints, Claude is unable to respond to your message. Please try again soon, or get notified when paid plans are available.

-- ====================================================================
-- QNXT MEMBERSHIP -- 
-- ====================================================================
-- =================================================================
-- DYNAMIC() v. STATIC() DECLARE(s) FOR [...] --
-- =================================================================
DECLARE when DATE = CURRENT_DATE(); -- ESTABLISH CUTOFF DT()
DECLARE PCPrecordRANK NUMBER = 1; -- ENTER 1 TO GET() JUST MOST CURRENT [RANKis] see DENSE_RANK() OVER(PARTITION BY ek.memid ORDER BY CAST(ek.effdate AS DATE) DESC) AS [RANKis] --'RANKis' --RANK by MOST CURRENT EligHx 
DECLARE whichfbu VARCHAR(25) = 'MA019'; --[MemberAttribute](s) FBU  ;
DECLARE whichaidcode VARCHAR(5) = 'MA002'; -- AIDCODE aka CMCapCode aka SUBSC_DEPT
-- DECLARE whichcin = 'MA020'; -- [MemberAttribute](s) CIN

SELECT when AS [Membership Assessment Date], bp.description AS [LINE_OF_BUSINESS], *
FROM HMOPROD_PLANDATA.dbo.benefitplan AS bp LIMIT 1;







/**Creates the initial data set using the EDW semantic model**/
    CREATE OR REPLACE TEMPORARY TABLE snfclaims AS     
    SELECT DISTINCT dm.memberak AS memid
		   , dm.fullname AS member_name
		   , dm.dateofbirth
		   , dbp.planak
           , CASE WHEN UPPER(TRIM(IFNULL(dbp.planak,''))) IN ('QMXBP0850','QMXBP0851') THEN 'DSNP'
                  WHEN UPPER(TRIM(IFNULL(dbp.planak,''))) = 'QMXBP0782'  THEN 'MediCal'
                  WHEN UPPER(TRIM(IFNULL(dbp.planak,''))) IN ('QMXBP0822','QMXBP0823') THEN 'CMC'
                  ELSE 'UNKNOWN'
             END AS line_of_business
		   , CASE WHEN fmh.ENROLLMENTSTATUS IS NULL OR fmh.ENROLLMENTSTATUS = 'V' THEN 'P'
		          ELSE fmh.ENROLLMENTSTATUS
             END primarystatus
		   , fmh.claimak
		   , fmh.admitdate AS admitdate
		   , fmh.claimstartdate AS startdate
		   , fmh.claimenddate AS enddate
           , fmh.claimdetaildosfromdate AS claimdetaildosfromdate
		   , fmh.claimdetaildostodate AS claimdetaildostodate
		   , dps.PROVIDERAK AS provid
		   , dps.PROVIDERFULLNAME AS provider
		   , pay.PROVIDERAK AS paytoid
		   , pay.PROVIDERFULLNAME AS payto
		   , CASE WHEN dps.PROVIDERAK IN ('156799','2571','911','22') THEN '1-LTAC' 
                  ELSE '2-SNF' 
             END AS cost_category
           , CASE WHEN drc.codeidak IN ('0112', '0122', '0132', '0142', '0152') THEN '1-OB' 
                  ELSE '2-POS21' 
             END AS 'cost_category2'
           , CASE WHEN dl.LOCATIONAK = '21' THEN '1-PROFESSIONAL-INPATIENT' 
			      WHEN dl.LOCATIONAK = '23' AND NOT (fmh.servunits BETWEEN '80048' AND '89356' OR fmh.servunits BETWEEN '70010' AND '79999') THEN '2-PROFESSIONAL-ER'
			      WHEN dl.LOCATIONAK IN ('11','22') THEN '3-PROFESSIONAL-POS:11,22'
		          ELSE '4-PROFESSIONAL-OTHER'
             END AS 'cost_category3'
           , CASE WHEN drc.codeidak LIKE '045%' AND (dfbc.FACILITYCODEAK = '1' AND dfbc.BILLCLASSCODEAK IN ('3','4')) THEN '1-FACILITY - ER'
		          ELSE '2-FACILITY - Other'
		     END AS 'cost_category4'    
		   , fmh.claimdetailline AS claimline
           , dfbc.FACILITYCODEAK
           , dfbc.BILLCLASSCODEAK
           , dl.LOCATIONAK
		   , drc.codeidak AS revcode
           , fmh.resubclaimid
           , fmh.formtype
           , fmh.claimstatus
           , fmh.claimdetailstatus
		   , fmh.amountpaid AS paid
           , claimfltr.totalpaid
		   , fmh.servunits AS units  
    FROM DEV_CHG_EDW.CHG_EDW.FACT_MEMBERHISTORY AS fmh
    JOIN (SELECT DISTINCT claimak
                          , TOTALPAIDAMOUNT AS totalpaid
          FROM DEV_CHG_EDW.CHG_EDW.FACT_MEMBERHISTORY 
          WHERE claimdetailline = 1 AND TOTALPAIDAMOUNT > 0) AS claimfltr ON fmh.claimak = claimfltr.claimak
    JOIN DEV_CHG_EDW.CHG_EDW.DIM_FACILITYBILLCLASS AS dfbc ON fmh.facilitybillclasssk = dfbc.facilitybillclasssk
    JOIN DEV_CHG_EDW.CHG_EDW.DIM_REVENUECODE AS drc ON fmh.REVENUECODEsk = drc.REVENUECODEsk
    JOIN DEV_CHG_EDW.CHG_EDW.DIM_PROVIDERSPECIALTY AS dps ON fmh.providersk = dps.providersk
    JOIN DEV_CHG_EDW.CHG_EDW.DIM_PROVIDERSPECIALTY AS pay ON fmh.paytoprovidersk = pay.providersk
    JOIN DEV_CHG_EDW.CHG_EDW.DIM_BENEFITPLAN AS dbp ON fmh.benefitplansk = dbp.benefitplansk
    JOIN DEV_CHG_EDW.CHG_EDW.DIM_MEMBER AS dm ON fmh.membersk = dm.membersk
    JOIN DEV_CHG_EDW.CHG_EDW.DIM_LOCATION AS dl ON fmh.locationsk = dl.locationsk;





    

    /**Pulls Skilled Nursing Facility stays.  lines up multiple claims for a given member IN chronilogical order and lists all the calendar days between start and end dates.   Many admits span multiple claims, this code attemps to find those as well as expose gaps.**/
    CREATE OR REPLACE TEMPORARY TABLE ClaimDays AS
    SELECT c.memid
		   , c.line_of_business
		   , c.provid
		   , c.provider
		   , c.paytoid
		   , c.payto
		   , c.cost_category
           , REPLACE(cal."CalendarDate", '-', '') AS CalendarDate
           , CASE WHEN LAG(cal."CalendarDate", 1) OVER(PARTITION BY c.memid, c.line_of_business, c.provid, c.paytoid, c.cost_category ORDER BY cal."CalendarDate") IS NULL THEN cal."CalendarDate"
				  WHEN DATEDIFF(day, LAG(cal."CalendarDate", 1) OVER(PARTITION BY c.memid, c.line_of_business, c.provid, c.paytoid, c.cost_category ORDER BY cal."CalendarDate"), cal."CalendarDate") > 1 THEN cal."CalendarDate"
				  ELSE NULL 
			 END startdate
		   , CASE WHEN LEAD(cal."CalendarDate", 1) OVER(PARTITION BY c.memid, c.line_of_business, c.provid, c.paytoid, c.cost_category ORDER BY cal."CalendarDate") IS NULL THEN cal."CalendarDate"
				  WHEN DATEDIFF(day, cal."CalendarDate", LEAD(cal."CalendarDate", 1) OVER(PARTITION BY c.memid, c.line_of_business, c.provid, c.paytoid, c.cost_category ORDER BY cal."CalendarDate")) > 1 THEN cal."CalendarDate"
				  ELSE NULL 
			 END enddos
           , ROW_NUMBER() OVER (PARTITION BY c.memid, c.line_of_business, c.provid, c.paytoid ORDER BY cal."CalendarDate") AS ct
	FROM snfclaims AS c
	JOIN DEV_CHG_ODS.HMOPROD_PLANDATA.CALENDAR AS cal ON REPLACE(cal."CalendarDate", '-', '') BETWEEN c.startdate AND c.enddate
    WHERE ((c.FACILITYCODEAK = '2'
			    AND 
            c.BILLCLASSCODEAK IN ('1', '2', '3'))
		     OR 
          c.revcode IN ('0022', '0191', '0192', '0193')
		     OR 
          c.provid IN ('156799', '2571', '911', '22'))
             AND
          c.resubclaimid IS NULL
		     AND 
          c.claimak NOT LIKE '%R%'
		     AND 
          c.claimstatus IN ('ADJUCATED', 'PAID', 'PAY', 'REV', 'REVERSED', 'REVSYNCH')
		     AND 
          c.claimdetailstatus NOT IN ('DENY', 'VOID')
		     AND 
          c.planak IN ('QMXBP0823', 'QMXBP0822', 'QMXBP0782', 'QMXBP0850', 'QMXBP0851');
         
    CREATE OR REPLACE TEMPORARY TABLE StaysFinal AS 
	SELECT DISTINCT memid
		   , line_of_business
		   , provid
		   , provider
		   , paytoid
		   , payto
		   , cost_category
           , startdate
		   , CASE WHEN enddos IS NOT NULL THEN enddos 
                  ELSE LEAD(enddos, 1) OVER(PARTITION BY memid, line_of_business, provid, paytoid ORDER BY ct) 
             END enddate
		   , CASE WHEN DATEDIFF(day, startdate, CASE WHEN enddos IS NOT NULL THEN enddos 
                                                     ELSE LEAD(enddos, 1) OVER(PARTITION BY memid, line_of_business, provid, paytoid ORDER BY ct) 
                                                END) = 0 THEN 1 
                  ELSE DATEDIFF(day, startdate, CASE WHEN enddos IS NOT NULL THEN enddos 
                                                     ELSE LEAD(enddos, 1) OVER(PARTITION BY memid, line_of_business, provid, paytoid ORDER BY ct) 
                                                END)
             END days
	FROM ClaimDays
	WHERE startdate IS NOT NULL
             OR
          enddos IS NOT NULL;





          
    
    /**Map back to original data set to get appropriate paid amounts without duplication**/
    CREATE OR REPLACE TEMPORARY TABLE hct_snf AS 
	SELECT sf.memid
		   , sf.line_of_business
		   , sf.provid
		   , sf.provider
		   , sf.paytoid
		   , sf.payto
		   , sf.cost_category
		   , sf.startdate
		   , IFNULL(sf.enddate, sf.startdate) AS enddate
		   , SUM(sc.paid) AS paid
		   , IFNULL(sf.days, 1) AS days
	FROM StaysFinal AS sf
	LEFT JOIN snfclaims AS sc ON sf.memid = sc.memid 
									 AND 
                                 sf.line_of_business = sc.line_of_business 
									 AND 
                                 sf.provid = sc.provid 
									 AND 
                                 sc.startdate BETWEEN REPLACE(sf.startdate, '-', '') AND REPLACE(IFNULL(sf.enddate, sf.startdate), '-', '')
    WHERE sc.startdate IS NOT NULL
              AND
          ((sc.FACILITYCODEAK = '2'
			    AND 
            sc.BILLCLASSCODEAK IN ('1', '2', '3'))
		     OR 
          sc.revcode IN ('0022', '0191', '0192', '0193')
		     OR 
          sc.provid IN ('156799', '2571', '911', '22'))
             AND
          sc.resubclaimid IS NULL
		     AND 
          sc.claimak NOT LIKE '%R%'
		     AND 
          sc.claimstatus IN ('ADJUCATED', 'PAID', 'PAY', 'REV', 'REVERSED', 'REVSYNCH')
		     AND 
          sc.claimdetailstatus NOT IN ('DENY', 'VOID')
		     AND 
          sc.planak IN ('QMXBP0823', 'QMXBP0822', 'QMXBP0782', 'QMXBP0850', 'QMXBP0851')
	GROUP BY sf.memid
		     , sf.line_of_business
		     , sf.provid
		     , sf.provider
		     , sf.paytoid
		     , sf.payto
		     , sf.cost_category
		     , sf.startdate
		     , IFNULL(sf.enddate, sf.startdate)
             , IFNULL(sf.days, 1);

    CREATE OR REPLACE TEMPORARY TABLE snf_days AS 
	SELECT DISTINCT hct_snf.*
		            , CASE WHEN MONTH(to_date(cal."CalendarDate")) = MONTH(to_date(hct_snf.startdate)) AND YEAR(to_date(cal."CalendarDate")) = YEAR(to_date(hct_snf.startdate)) THEN hct_snf.startdate
			               ELSE DATEADD(day, 1, LAST_DAY(DATEADD(month, -1, to_date(cal."CalendarDate")))) 
			          END startfordays
		            , CASE WHEN LAST_DAY(to_date(cal."CalendarDate")) < to_date(hct_snf.enddate) THEN LAST_DAY(to_date(cal."CalendarDate")) 
			               ELSE hct_snf.enddate 
			          END endfordays
	FROM hct_snf
	LEFT JOIN DEV_CHG_ODS.HMOPROD_PLANDATA.CALENDAR AS cal ON to_date(cal."CalendarDate") BETWEEN hct_snf.startdate AND hct_snf.enddate;		

    CREATE OR REPLACE TEMPORARY TABLE daysfinal AS
	SELECT snf_days.*
	       , DATEADD(day, 1, LAST_DAY(DATEADD(month, -1, to_date(startfordays)))) AS dos_month
	       , COUNT(startfordays) OVER(PARTITION BY memid, line_of_business, provid, startdate) AS ct
	       , CASE WHEN startfordays = endfordays AND COUNT(startfordays) OVER(PARTITION BY memid, line_of_business, provid, startdate) = 1 THEN 1
		          WHEN startfordays = endfordays AND ROW_NUMBER() OVER(PARTITION BY memid, line_of_business, provid, startdate ORDER BY startfordays ASC) = 1 THEN 1
		          WHEN startfordays = endfordays AND ROW_NUMBER() OVER(PARTITION BY memid, line_of_business, provid, startdate ORDER BY startfordays) <> 1 THEN 0
		          WHEN ROW_NUMBER() OVER(PARTITION BY memid, line_of_business, provid, startdate ORDER BY endfordays DESC) = 1 THEN DATEDIFF(day, startfordays, endfordays)
		          ELSE DATEDIFF(day, startfordays, endfordays) + 1 
             END days2
	FROM snf_days;
    
    CREATE OR REPLACE TEMPORARY TABLE snf_memgrps AS
	SELECT DISTINCT daysfinal.memid
		            , daysfinal.line_of_business
		            , daysfinal.provid
		            , daysfinal.provider
		            , daysfinal.paytoid
		            , daysfinal.payto
		            , daysfinal.cost_category
		            , daysfinal.dos_month
		            , CASE WHEN ROW_NUMBER() OVER(PARTITION BY daysfinal.memid, daysfinal.line_of_business, daysfinal.provid, daysfinal.startdate, daysfinal.cost_category ORDER BY daysfinal.startfordays) = 1 THEN 1 
                           ELSE 0 
                      END admits
		            , daysfinal.paid
		            , daysfinal.days
		            , daysfinal.startfordays
		            , daysfinal.endfordays
		            , daysfinal.days2
		            , days2/days AS paidweight
	                , paid * (days2/days) AS paidfinal                 
		            , mg.member_category
		            , mg.pcp_flag	       
	FROM daysfinal
	LEFT JOIN DEV_CHG_ODS.INFORMATICS.HCT_MEMBER_GRPS AS mg ON daysfinal.memid = mg.memid AND daysfinal.dos_month = mg.member_month AND daysfinal.line_of_business = mg.line_of_business;
   
    CREATE OR REPLACE TEMPORARY TABLE hct_claim AS
	SELECT line_of_business
	       , dos_month
	       , CASE WHEN member_category IS NULL THEN 'OTHER' 
                  ELSE member_category 
             END AS member_category
	       , CASE WHEN pcp_flag IS NULL THEN 'OTHER' 
                  ELSE pcp_flag 
             END pcp_flag
	       , provid
	       , provider 
	       , paytoid
	       , payto
	       , CASE WHEN provid IN ('25', '200424') OR paytoid IN ('25', '200424') THEN 'FALLBROOK HOSPITAL'
		          WHEN provid IN ('13', '304577') OR paytoid IN ('13', '304577') THEN 'GREEN HOSPITAL OF SCRIPPS CLINIC'
		          WHEN provid IN ('300115', '17', '314986') OR paytoid IN ('300115', '17', '314986') THEN 'GROSSMONT HOSPITAL'
		          WHEN provid IN ('22', '307733') OR paytoid IN ('22', '307733') THEN 'PROMISE HOSPITAL OF SAN DIEGO'
		          WHEN provid IN ('21', '237064656', '330599494') OR paytoid IN ('21', '237064656', '330599494') THEN 'UCSD MEDICAL CENTER'
		          WHEN provid IN ('4', '951684089') OR paytoid IN ('4', '951684089') THEN 'SCRIPPS MERCY HOSPITAL HILLCREST'
		          WHEN provid IN ('20', '317712') OR paytoid IN ('20', '317712') THEN 'TRI-CITY MEDICAL CENTER'
		          WHEN provid IN ('10', '10798', '10801', '12', '14', '15', '16', '18', '20', '24', '3', '6', '6078', '7', '5', '911', '311989') OR paytoid IN ('10', '10798', '10801', '12', '14', '15', '16', '18', '20', '24', '3', '6', '6078', '7', '5', '911', '311989')  THEN provider 
                  ELSE 'OTHER'
	         END providerflag
	       , cost_category
	       , SUM(admits) AS admits_visits
	       , SUM(paidfinal) AS paid
	       , SUM(days2) AS days_units
	FROM snf_memgrps
	WHERE dos_month BETWEEN '2013-04-01' AND  LAST_DAY(DATEADD(month, -4, to_timestamp(current_timestamp)))
	GROUP BY line_of_business
	       , dos_month
	       , CASE WHEN member_category IS NULL THEN 'OTHER' 
                  ELSE member_category 
             END
	       , CASE WHEN pcp_flag IS NULL THEN 'OTHER' 
                  ELSE pcp_flag 
             END
	       , provid
	       , provider 
	       , paytoid
	       , payto
	       , CASE WHEN provid IN ('25', '200424') OR paytoid IN ('25', '200424') THEN 'FALLBROOK HOSPITAL'
		          WHEN provid IN ('13', '304577') OR paytoid IN ('13', '304577') THEN 'GREEN HOSPITAL OF SCRIPPS CLINIC'
		          WHEN provid IN ('300115', '17', '314986') OR paytoid IN ('300115', '17', '314986') THEN 'GROSSMONT HOSPITAL'
		          WHEN provid IN ('22', '307733') OR paytoid IN ('22', '307733') THEN 'PROMISE HOSPITAL OF SAN DIEGO'
		          WHEN provid IN ('21', '237064656', '330599494') OR paytoid IN ('21', '237064656', '330599494') THEN 'UCSD MEDICAL CENTER'
		          WHEN provid IN ('4', '951684089') OR paytoid IN ('4', '951684089') THEN 'SCRIPPS MERCY HOSPITAL HILLCREST'
		          WHEN provid IN ('20', '317712') OR paytoid IN ('20', '317712') THEN 'TRI-CITY MEDICAL CENTER'
		          WHEN provid IN ('10', '10798', '10801', '12', '14', '15', '16', '18', '20', '24', '3', '6', '6078', '7', '5', '911', '311989') OR paytoid IN ('10', '10798', '10801', '12', '14', '15', '16', '18', '20', '24', '3', '6', '6078', '7', '5', '911', '311989')  THEN provider 
                  ELSE 'OTHER'
	         END
	       , cost_category;







CREATE OR REPLACE PROCEDURE update_continuous_enrollment()
RETURNS STRING
LANGUAGE SQL
AS
$$

DECLARE
    rowCount NUMBER DEFAULT 1;
BEGIN
    WHILE (rowCount > 0) DO
        MERGE INTO DEV_CHG_ODS.INFORMATICS.ContinuousEnrollment AS ce
        USING (
            SELECT DISTINCT c."memid",
                "EligibilityStart",
                "EligibilityEnd",
                "Index EligibilityID",
                "Index Eligibility Start Date",
                "Index Eligibility End Date"
            FROM DEV_CHG_ODS.INFORMATICS.ContinuousEnrollment AS c
            WHERE 1=1
                AND "Index Eligibility Start Date" IS NOT NULL
        ) loopce
        ON ce."memid" = loopce."memid"
            AND TRY_TO_DATE(ce."PREVIOUS EligibilityStart") = TRY_TO_DATE(loopce."EligibilityStart")
            AND TRY_TO_DATE(ce."PREVIOUS EligibilityEnd") = TRY_TO_DATE(loopce."EligibilityEnd")
        WHEN MATCHED AND ce."Index Eligibility Start Date" IS NULL AND ce.CONSECUTIVE = 1 THEN
            UPDATE SET 
                ce."Index EligibilityID" = loopce."Index EligibilityID",
                ce."Index Eligibility Start Date" = loopce."Index Eligibility Start Date",
                ce."Index Eligibility End Date" = TRY_TO_DATE(ce."EligibilityEnd");

        -- SET rowCount = SQLROWCOUNT;
        SELECT COUNT(*) INTO :rowCount FROM TABLE(RESULT_SCAN(LAST_QUERY_ID()));

        IF (rowCount = 0) THEN
            BREAK;
        END IF;
    END WHILE;

    RETURN 'Procedure completed successfully';

END;
$$;


-- ======================================================================
-- SQL #PYTHON FOR WHILE LOOP() BREAK / FEEDBACK LOOP() CONDITION(S) -- 
-- ======================================================================
-- To execute the procedure
CALL update_continuous_enrollment();
