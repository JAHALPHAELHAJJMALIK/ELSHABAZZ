-- ==================================================
	-- CHECKLIST - WILDCARD(s) --
-- ==================================================
JAH CHARINDEX() FIND() SEARCH() "'*%WILDCARD%*'" WINDOWS KEY + R ('RUN') ... '*tmp*, %tmp%, *temp* %temp%',IN MS EXCEL WILDCARD aka '.xlsx' 

		USE https://img.chandoo.org/f/vw/vlookup-wild-card-example.xls
		USE https://www.w3schools.com/sql/sql_wildcards.asp
		
		⏎ MS EXCEL WILDCARD Fx WITH ISNUMBER(SEARCH() ... : 'NAKED NESTING' ...
				=TRIM(CLEAN(IF(LEFT($C2,4)="*SAN","SAN DIEGO",IF(LEFT($C2,3)="SD,","SAN DIEGO",IF(LEFT($C2,3)="*SD","SAN DIEGO",IF(ISNUMBER(SEARCH("LA JOLLA",$C2)),"LA JOLLA",IF(ISNUMBER(SEARCH("SAN MARCOS",$C2)),"SAN MARCOS",IF(ISNUMBER(SEARCH("TECATE",$C2)),"TECATE",IF(ISNUMBER(SEARCH("OCEANSIDE",$C2)),"OCEANSIDE",UPPER(TRIM(CLEAN(SUBSTITUTE($C2," (POB)","")))))))))))))

				-- [CVS Pharmacy] =IF([@[Pharmacy Name]]="","",IF(ISNUMBER(SEARCH("CVS",[@[Pharmacy Name]],1)),"Y","N")) 
				[CVS Pharmacy] =IF(D2="","",IF(ISNUMBER(SEARCH("CVS",D2,1)),"Y","N"))
				[Retail Chain] =IF(E2="","",IF(ISNUMBER(SEARCH("R",E2,1)),"Y","N"))

		⏎ Explanation:
				🔹 SEARCH("CVS", D2): PERFORMS A /* CASE-INSENSITIVE */ SEARCH FOR THE TEXT "CVS" WITHIN THE PHARMACY NAME IN CELL D2. IT RETURNS A NUMBER IF FOUND, OR AN ERROR IF NOT.
				🔹 FIND("CVS", D2): PERFORMS A /* CASE-SENSITIVE */ SEARCH FOR THE TEXT "CVS" WITHIN THE PHARMACY NAME IN CELL D2. IT RETURNS A NUMBER IF FOUND, OR AN ERROR IF NOT.
				🔹 ISNUMBER(...): Checks whether a NUMBER was returned (i.e., "CVS" was found anywhere in the name).
				🔹 IF(...): RETURNS "Y" if "CVS" appears in the pharmacy name; otherwise "N".

		⏎ 'Population Age Served' =IF(ISNUMBER(SEARCH("ADULT",P7)),"A",IF(OR(ISNUMBER(SEARCH("PEDIAT",P7)),ISNUMBER(SEARCH("(PEDS)",P7)),ISNUMBER(SEARCH("CHILD",P7))),"P","B")) -- NESTED WILDCARD MS EXCEL Fx FORMULA
				1. Sales for the person whose names starts with Jac =VLOOKUP("jac*",$B$5:$E$17,3,FALSE) -- /*=IFERROR(VLOOKUP("*Edit*",B9,1,FALSE),"") */
				2. Sales for the person whose name as 8 characters =VLOOKUP("????????",$B$5:$E$17,3,FALSE) 
				3. Sales for the person whose name ends with son =VLOOKUP("*son",$B$5:$E$17,3,FALSE)
				4. Customers for person whose name starts with ja and ends with am =VLOOKUP("ja*am",$B$5:$E$17,2,FALSE) 
				5. How many sales for the person whose name contains the text IN G17 =COUNTIF(B5:B17,"*ve*") OR =COUNTIF(B5:B17,"*"&$G$17&"*") WHERE $G$17 IS 've'

SELECT TOP 10 '-- 'ISNUMERIC() RETURNS 1 WHEN THE INPUT EXPRESSION EVALUATES TO A VALID NUMERIC DATA TYPE; OTHERWISE IT RETURNS 0. Valid numeric data types'  ' AS [NOTE(S)]
,ISNUMERIC(claimid) AS ' ' 
,claimid
FROM HMOPROD_PLANDATA.dbo.claim
WHERE 1=1 
	AND ISNUMERIC(claimid) = 0
	
,ISNUMERIC(NPI) AS [Confirmed AS Numeric Value]
FROM INFORMATICS.dbo.CHHS_MediCal_Provider_Staging (NOLOCK)
WHERE 1=1
	AND County LIKE '%Imperial%'
	--AND (ManagedCarePlan LIKE '%HEALTH%NET%' OR ManagedCarePlan LIKE '%HEALTHNET%')
	AND ISNUMERIC(NPI) = 1 -- 'ISNUMERIC() RETURNS 1 WHEN THE INPUT EXPRESSION EVALUATES TO A VALID NUMERIC DATA TYPE; OTHERWISE IT RETURNS 0. Valid numeric data types' 
	--AND NPI IS NOT NULL
	--AND NOT NPI = '' -- NO NOT NEGATIVE<> != ...
	AND RecordType = 'Provider'

		⏎ PATINDEX() TO LEVERAGE WILDCARD(S)

CREATE TABLE #AlphaOnly
( PersonID   INT IDENTITY(0, 1)
, PersonName VARCHAR(20));
GO

INSERT INTO #AlphaOnly (PersonName)
VALUES
  ('Billy#')
, ('Man*dy')
, ('NANCY')
, ('TRACY')
, ('BAD MAMMAJAMMA 9');
GO

		SELECT *
		FROM #AlphaOnly
		WHERE 1=1
			-- AND PersonName NOT LIKE '%[^A-Z a-z]%' -- 🚩 ALPHABETIC CHARACTERS ONLY ALLOWING FOR SPACES ... ANY CHARACTER IN THIS SET ALLOWING FOR SPACES
			AND PersonName NOT LIKE '%[^A-Za-z]%' -- 🚩 ALPHABETIC CHARACTERS ONLY EXCLUDING SPACES ... ANY CHARACTER IN THIS SET EXCLUDING SPACES

EXPLANATION OF CHANGE.LOG: 
1.	Ensure at Least One Letter: 
		o	p.PracticeName LIKE '%[A-Za-z]%' ensures the name contains at least one letter (uppercase or lowercase).

2.	Allow Only Specific Characters: 
		o	p.PracticeName NOT LIKE '%[^A-Za-z0-9-'' ]%' ensures the name contains only: 
					Letters (A-Za-z)
					Numbers (0-9)
					Hyphens (-)
					Single quotes (')
					Spaces ( )

		o	The ^ inside the square brackets ([^...]) negates the set, so NOT LIKE '%[^A-Za-z0-9-'' ]%' means no characters other than those listed are allowed. '
		
SELECT DISTINCT ' ' AS 'SET #BASELINE GROUP NAME(S): '
,p.PracticeName AS 'GroupName'
FROM evips_chgcv.dbo.vwPractices AS p
WHERE 1=1

SELECT DISTINCT ' ' AS 'SET #BASELINE Allow FOR Specific Characters: '
,p.PracticeName AS 'GroupName'
FROM evips_chgcv.dbo.vwPractices AS p
WHERE 1=1
	AND NOT p.PracticeName LIKE '%[^A-Za-z0-9-'' ]%' -- 🚩 ALPHA NUMERIC COMBINATION ... ENSURE no characters other than those listed are allowed ... only letters (A-Za-z), numbers (0-9), hyphens (-), single quotes ('), and SPACE ( ) are allowed ... This will flag names containing commas (,), ampersands (&), parentheses (()), or other special characters OUTSIDE of the allowed OPTIONS.

SELECT DISTINCT ' ' AS 'SET #BASELINE ALPHA ONLY: '
,p.PracticeName AS 'GroupName'
FROM evips_chgcv.dbo.vwPractices AS p
WHERE 1=1
	AND NOT p.PracticeName LIKE '%[^A-Za-z ]%' -- 🚩 ALPHA ONLY  ... CONSIDER ALLOWING FOR SPACING OF CHARACTER(S) ... ' ' AT THE END
	
SELECT DISTINCT ' ' AS 'SET #BASELINE NUMERIC ONLY: '
,p.PracticeName AS 'GroupName'
FROM evips_chgcv.dbo.vwPractices AS p
WHERE 1=1
	AND NOT p.PracticeName LIKE '%[^0-9]%' -- 🚩 NUMERIC ONLY

SELECT DISTINCT ' ' AS 'SET #BASELINE NUMERIC COMBINATION: '
,p.PracticeName AS 'GroupName'
FROM evips_chgcv.dbo.vwPractices AS p
WHERE 1=1
	AND NOT p.PracticeName LIKE '%[^0-9] %' -- 🚩 NUMERIC COMBINATION  ... CONSIDER ALLOWING FOR SPACING OF CHARACTER(S) ... ' ' IN THE MIDDLE
	AND p.PracticeName LIKE '%[0-9]%' 







-- =====================================================================
	-- EDIlab TEST RESULT(S) --
-- =====================================================================
--------------------------------------------------------------------------------------------------------------------
	-- Error Trapping: Check If Permanent Table(s) Already Exist(s) And Drop If Applicable --
--------------------------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS #SETa1c -- SQL Server 2016 and later -- DYNAMIC tmp OR STATIC [TABLE] #TableName is a local temporary table visible only IN the current session; ##TableName is a GLOBAL temporary table visible to all sessions IN ('TempDB')

SELECT *,'- Uncontrolled A1C (Uncontrolled to be defined above 7.0% or higher within the previous 12 months)' AS [NOTE(S)]
INTO #SETa1c
FROM 
( -- INITIATE ...
SELECT DISTINCT ' ' AS 'see "CGM..."'
,TRY_CONVERT(date,LEFT(edi.TestDate,8)) AS [LabTestDate]
-- ,edi.TestResult,DENSE_RANK() OVER(PARTITION BY edi.SubscriberId ORDER BY LEFT(edi.TestDate,8) DESC,edi.TestName DESC) AS [RANKis]
,TRY_CONVERT(decimal(9,1),edi.TestResult) AS [EDILab TestResult (decimal)]
,REPLACE(REPLACE(REPLACE(REPLACE(edi.TestResult,'%',''),'<',''),'>',''),'HI','') AS [EDILab TestResult (REPLACE SUBSTITUTE)]
,FLOOR(TRY_CONVERT( float, REPLACE(REPLACE(REPLACE(REPLACE(edi.TestResult,'%',''),'<',''),'>',''),'HI','') ) ) AS [Bucket]
,TRY_CONVERT(float,REPLACE((SELECT SUBSTRING(edi.TestResult,Number,1)
FROM master.dbo.spt_values AS sv
WHERE 1=1
	AND sv.Type = 'p'
	AND sv.Number <= LEN(edi.TestResult)
	AND SUBSTRING(TestResult,Number,1) LIKE '[0.00-9.99]' FOR XML PATH('')),'..','.')) AS [A1c WILDCARD RESULT(S)] -- [floatresult]
	,edi.*
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st',
FROM CHGAPP_PROD.dbo.tblEDILab AS edi (NOLOCK) -- USE https://www.findacode.com/ - 'FIND() PROCEDURE OR DIAGNOSIS CODE(S) ...'
) -- CONCLUDE ...
AS labresult
WHERE 1=1
	AND labresult.TestResultLOINC IN ('17855-8','17856-6','41995-2','4548-4','4549-2','59261-8','62388-4','71875-9','96595-4', '75862-3') -- • Members who got their HbA1c done IN CY ... HbA1c Lab Test Results done within last one year and "HasDiabetes" flag = '1' IN the MemberMonths table.
	-- AND TRY_CONVERT(decimal(9,1),labresult.TestResult) IS NOT NULL
	AND [A1c WILDCARD RESULT(S)] >= 7
	AND CAST(SUBSTRING(CONVERT(varchar(25),TRY_CONVERT(date,TRY_CONVERT(date,edi.TestDate)),112),1,4) AS nvarchar(4)) = CAST(SUBSTRING(CONVERT(varchar(25),TRY_CONVERT(date,GETDATE()),112),1,4) AS nvarchar(4))
	AND TRY_CONVERT(float,REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(edi.TestResult,'<',''),'>',''),'%',''),'/',''),'TNP',''),'Cancelled',''),'gdl','')) BETWEEN 0 AND 20
	AND [LabTestDate] BETWEEN @Start AND @End -- by DOS 	

		SELECT * FROM #SETa1c

=IF(OR(IFERROR(VLOOKUP(A2,ADDSTERMS,3,FALSE),"")="PROVIDER ADDED SINCE AUG 2017",IFERROR(VLOOKUP(A2,ADDSTERMS,3,FALSE),"")="PROVIDER TERMED SINCE AUG 2017",IFERROR(VLOOKUP(A2,ADDSTERMS,3,FALSE),"")="Qualified Autism Services Provider",IFERROR(VLOOKUP(A2,ADDSTERMS,3,FALSE),"")="Qualified Autism Services Paraprofessional",IFERROR(VLOOKUP(A2,ADDSTERMS,3,FALSE),"")="Qualified Autism Services Professional"),IFERROR(VLOOKUP(A2,ADDSTERMS,3,FALSE),""),"")  -- USE IN [In_Network_File_Not_In_CL] ORDER / SEQUENCE MATTER(s) aka NESTED() 1st PASS

=IF(IFERROR(VLOOKUP(A2,pierdiem,3,FALSE),"")="",IFERROR(VLOOKUP(A2,provdir,3,FALSE),"") ,"") -- USE IN [In_Network_File_Not_In_CL] ORDER / SEQUENCE MATTER(s) aka NESTED() 2nd PASS

=IF(ISNUMBER(SEARCH("*Total*",VLOOKUP($B$3,title,$A41,FALSE))),"",IFERROR(VLOOKUP($B$3,title,$A41,FALSE),"")) -- 'Claude.ai ChatGPT BARD GROK' '%WILDCARD%'

=IFERROR(VLOOKUP(A2,ADDSTERMS,3,FALSE),"") -- USE IN [In_CL_NotIn_Network_File]

-- =================================================================
	-- HYBRID NUMERIC v. ALPHA WILDCARD(s) --
-- =================================================================
WHERE 1=1 
	AND UPPER(LTRIM(RTRIM(ISNULL([FIELD],'')))) BETWEEN '249.7%' AND '250.9%' -- HYBRID() FILTER BETWEEN AND LIKE '%%' OF ICD9(s) / ICD10(s) USE OF SUBSTRING(s) aka MID()
	AND clm.claimid IN -- THE ENTIRE CLAIM
	( -- INITIATE ...
	SELECT DISTINCT dx.claimid
	FROM HMOPROD_PLANDATA.dbo.claimdiag AS dx
	WHERE 1=1 
		AND UPPER(LTRIM(RTRIM(ISNULL(dx.codeid,'')))) BETWEEN 'E08' AND 'E13.9%' -- BETWEEN 'E08' AND 'E13.999' -- see [DMP] + OR ARNOLD_...rar IN ('E08','E09','E10','E11','E13') -- HEDIS Diabetes 
		) -- CONCLUDE

WHERE 1=1 
	AND authorizationid >'!' --IS LIKE WHERE LTRIM(RTRIM(authorizationid)) IS NOT NULL 
		OR LTRIM(RTRIM(authorizationid)) NOT IN ('')

WHERE UPPER(LTRIM(RTRIM(ISNULL([FIELD],'')))) LIKE '[A-Z]%'  --RETAIN LEADING ALPHA CHAR (PREFIX 1st CHAR)

WHERE 1=1 
	AND [FIELD] LIKE 'CDCMY21[a-b]'

WHERE 1=1 
	AND UPPER(LTRIM(RTRIM(ISNULL([FIELD],'')))) LIKE '[0-9]%'  --RETAIN LEADING NUMERIC aka # (PREFIX 1st CHAR)

WHERE 1=1 
	AND UPPER(LTRIM(RTRIM(ISNULL([FIELD],'')))) LIKE '[0-9]%[0-9]'  -- ENTRY BEGINS AND ENDS ;WITH()  NUMERIC VAL()

WHERE 1=1 
	AND UPPER(LTRIM(RTRIM(ISNULL([FIELD],'')))) LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'  --PLACEHOLDER BETWEEN 0 AND 9 FOR A NINE (9) CHAR #	

WHERE 1=1 
	AND UPPER(LTRIM(RTRIM(ISNULL([FIELD],'')))) LIKE '[1-5][0-0]'  --NUMERIC OPTION(s) IN TWO (2) CHAR VAL()







-- =================================================================
	-- ADDRESS THE NULL WITH ISNULL() --
-- =================================================================
DECLARE @SearchString AS nvarchar (25) = '%'+'NANCY'+'%' -- WILDCARD DECLARE(s)

CREATE TABLE #Person
( PersonID   INT IDENTITY(0, 1)
, PersonName VARCHAR(20));
GO

CREATE TABLE #Candidates
(PersonName VARCHAR(20));
GO

INSERT INTO #Person (PersonName) 
VALUES ('Billy')
, ('Joe')
, (NULL);

INSERT INTO #Candidates (PersonName)
VALUES
  ('Billy')
, ('Mandy')
, ('NANCY')
, ('TRACY')
, ('BAD MAMMAJAMMA');
GO

		SELECT  ' ' AS 'ADDRESS THE NULL WITH ISNULL()',*
		FROM #Candidates AS c
		WHERE 1=1 
			AND UPPER(LTRIM(RTRIM(ISNULL(c.PersonName,'')))) NOT IN 
			(SELECT DISTINCT ISNULL(PersonName,'NOBODY') FROM #Person );

		SELECT  ' ' AS 'TRICK ? QUESTION IF ISNULL() NOT ADDRESSED',*
		FROM #Candidates AS c
		WHERE 1=1 
			AND UPPER(LTRIM(RTRIM(ISNULL(c.PersonName,'')))) NOT IN
			(SELECT DISTINCT PersonName FROM #Person );

		SELECT ' ' AS 'I SEE WHAT YOU DID THERE: ',*
		FROM #Candidates AS c
				LEFT JOIN #Person AS p ON c.PersonName = p.PersonName
		WHERE 1=1 
			AND UPPER(LTRIM(RTRIM(ISNULL(p.PersonName,'')))) = ''

		SELECT ' 'AS 'Person',PersonName FROM #Person

		SELECT ' ' AS 'Candidate', PersonName FROM #Candidates
		






-------------------------------------------------------------------------------------------------------------------------
	-- Error Trapping: Check If Permanent Table(s) Already Exist(s) And Drop If Applicable --
-------------------------------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS #Name -- SQL Server 2016 and later -- DYNAMIC tmp OR STATIC [TABLE] #TableName is a local temporary table visible only IN the current session; ##TableName is a GLOBAL temporary table visible to all sessions IN ('TempDB')

CREATE TABLE #Name
( -- INITIATE ...
[TrackingID] int IDENTITY PRIMARY KEY, --Tracking = IDENTITY(INT,1,1) / IDENTITY(INT,[SEED],[INCREMENT]),
Name    varchar(1000),
phone   varchar(1000),
last_movie_release  date,
amount  varchar(1000),
comments varchar(1000)
); -- CONCLUDE ...

		INSERT INTO #Name (Name, phone, last_movie_release, amount, comments)
		VALUES -- INITIATE ...
		('Bruce Wayne',     'Confidential',   '20120720', '35131'        , 'Reach at email: bwayne@WayneIndustries.com')
		,('Clark Kent',      '8457390095',     '20130614', '58455.64'     , 'Work email: ckent@daily_planet.com')
		,('Richard Grayson', '212-555-0187',   '19970620', '.63521'       , 'Known as Dick Grayson')
		,('Diana Prince',    '849-555-0139',   NULL      , '58485.'       , 'Amazon princess, treat with respect')
		,('J''onn J''onzz',  'N/A',            NULL      , '-15612'       , 'Last Martian')
		,('Barry Allen',     '(697) 555-0142', NULL      , '-1.5413'      , 'Too fast')
		,('Reed Richards',   '917-330-2568',   '20150807', '-4156-15'     , NULL)
		,('Susan Storm',     '917-970-0138',   '20150807', '156.516.51'   , NULL)
		,('Johnny Storm',    '917-913-0172',   '20150807', '665465-'      , NULL)
		,('Ben Grimm',       '917-708-0141',   '20150807', 'One Thousand' , NULL)
		,('Peter Parker',    '917-919-0140',   '20140502', '56E6546'      , 'With great power comes great responsibility')
		,('Tony Stark',      '492-167-0139',   '20130503', '$'            , '')
		,('Wade Wilson',     '692-257-1937',   NULL      , 'ss'           , 'Just 50% hero')
		,('Bruce Banner',    '781-167-4628',   '20080613', 'FFFFFF'       , 'sdo@a#%^add34.voi')
		; -- FROM ... -- CONCLUDE ...					

JAH THANK YOU JAH 'Claude.ai GROK ChatGPT BARD' ON 20231208 - Deciphering a Name Search SQL Query with Wildcards

May I have you explain the following SQL

		SELECT *
		FROM #Name
		WHERE 1=1 
			AND UPPER(LTRIM(RTRIM(ISNULL([FIELD],'')))) LIKE ' ' + Name + ' ' LIKE '%[^A-Za-z]Richard[^A-Za-z]%';

This SQL query is selecting all records from a table called #Name where the name column contains the word 'Richard' surrounded by spaces and non-alphabetic characters.

Breaking it down:

		SELECT * selects all columns from the table
		FROM #Name specifies the table called #Name to select from
		WHERE 1=1 
			AND UPPER(LTRIM(RTRIM(ISNULL([FIELD],'')))) LIKE ' ' + Name + ' ' wraps a space ON both sides of the Name value

		LIKE '%\[^A-Za-z\]Richard\[^A-Za-z\]%' looks for the pattern of:
		% - any number of any characters
		\[^A-Za-z\] - a non-alphabetic character
		Richard - the literal string 'Richard'
		\[^A-Za-z\] - another non-alphabetic character
		% - any number of any characters

So this is finding any rows where the Name contains 'Richard' but has non-alphabetic characters like spaces, dots, commas etc. around it. The key thing is it only matches 'Richard' when it has non-alphabetic characters around it, by using the spaces and LIKE pattern with character ranges.

		Claude.ai is IN beta release and may display incorrect or harmful information

SELECT name FROM #employee WHERE 1=1 AND name LIKE '%'+@SearchString+'%'; --MIX ALPHA  / NUMERIC VAL() CONCLUSION
SELECT name FROM #employee WHERE 1=1 AND name LIKE @SearchString; --MIX ALPHA  / NUMERIC VAL() CONCLUSION
SELECT name FROM #employee WHERE 1=1 AND name LIKE  @SearchString+'%'; --MIX ALPHA  / NUMERIC VAL() CONCLUSION
SELECT name FROM #employee WHERE 1=1 AND name LIKE '%'+@SearchString; --MIX ALPHA  / NUMERIC VAL() CONCLUSION
SELECT name FROM #employee WHERE 1=1 AND name LIKE '[A-Z]%'; --BEGIN (s) ;WITH() AN ALPHA CHAR()
SELECT name FROM #employee WHERE 1=1 AND name LIKE '%[A-Z]'; --CONCLUDE(s) ;WITH() AN ALPHA CHAR()
SELECT name FROM #employee WHERE 1=1 AND name LIKE '[ZX]%'; --BEGIN (s) ;WITH() A SPECIFIED ALPHA CHAR(s)
SELECT name FROM #employee WHERE 1=1 AND name LIKE '%[XZ]'; --CONCLUDE(s) ;WITH() A SPECIFIED ALPHA CHAR(s)
SELECT name FROM #employee WHERE 1=1 AND name LIKE '[0-9]%'; --BEGIN (s) ;WITH() A NUMERIC VAL()
SELECT name FROM #employee WHERE 1=1 AND name LIKE '%[0-9]'; --CONCLUDE(s) ;WITH() A NUMERIC VAL()
SELECT name FROM #employee WHERE 1=1 AND name LIKE '[1978]%'; --BEGIN (s) ;WITH() A SPECIFIC NUMERIC VAL(s)
SELECT name FROM #employee WHERE 1=1 AND name LIKE '%[1978]'; --CONCLUDE(s) ;WITH() A SPECIFIC NUMERIC VAL(s)
SELECT name FROM #employee WHERE 1=1 AND name LIKE '[0-9]%[A-Z]'; --MIX NUMERIC  / ALPHA VAL() CONCLUSION
SELECT name FROM #employee WHERE 1=1 AND name LIKE '[A-Z]%[0-9]'; --MIX ALPHA  / NUMERIC VAL() CONCLUSION

SELECT *
FROM #Name
WHERE comments LIKE '%[A-Za-z0-9.+_]@[A-Za-z0-9.+_]%.[A-Za-z][A-Za-z]%';

 -- A) Return all rows when the name starts by B   
SELECT *
FROM #Name
WHERE Name LIKE 'B%';

-- B) Return all rows when the phone starts by 917
SELECT *
FROM #Name
WHERE phone LIKE '917%';

-- C) Return all rows when the name starts by any character between A and L
SELECT *
FROM #Name 
WHERE Name LIKE '[A-L]%';

-- D) Return all rows when the name starts by the characters C, D or W
SELECT * 
FROM #Name 
WHERE Name LIKE N'[CDW]%'; /* NOT LIKE '[CDW]%'; OR '[!CDW]%'; */

-- E) Return all rows when the last_movie_release starts by 2015
SELECT * 
FROM #Name 
WHERE last_movie_release LIKE '2015%';

SELECT * 
FROM #Name
WHERE Name LIKE '%Parker'; 

SELECT *
FROM #Name
WHERE Name LIKE '%Richard%'; 

SELECT *
FROM #Name
WHERE Name LIKE '% Richard %'; 

SELECT *
FROM #Name
WHERE ' ' + Name + ' ' LIKE '%[^A-Za-z]Richard[^A-Za-z]%';

SELECT *
FROM #Name
WHERE Name LIKE REPLICATE('_', 3) + 'n%';

SELECT *
FROM #Name
WHERE Name LIKE '%n' + REPLICATE('_', 3);

SELECT *
FROM #Name
WHERE amount NOT LIKE '%[^-0-9.]%' --Only digits, DECIMAL points and minus signs
	AND amount NOT LIKE '%[.]%[.]%' --Only one DECIMAL point allowed
	AND amount NOT LIKE '_%[-]%'; --Minus sign should only appear at the beginning of the string
  
SELECT *
FROM #Name
WHERE comments LIKE '%';

SELECT *
FROM #Name
WHERE comments LIKE '%[0-9]~%%' ESCAPE '~';

SELECT *
FROM #Name
WHERE comments LIKE '%[0-9][%]%';

 -- F) Return SPECIFIC CHAR() SPACING() WILDCARD ..."_" matches exactly one character. If we want all our customers who live ON the 200 block of Flatley Avenue IN Dover, we could query:
SELECT first_name
, street_address 
FROM [TABLE]
WHERE street_address LIKE '2__ Flatley Avenue' 
	AND city = 'Dover'; --"_" matches exactly one character. If we want all our customers who live ON the 200 block of Flatley Avenue IN Dover, we could query:
	
SELECT DISTINCT DefineOTH_SPE
,SPEC 
FROM INFORMATICS.dbo.PROVDIR_PCP AS pcp	
WHERE DefineOTH_SPE LIK '___P%' -- LEADING THREE (3) CHAR() THEN CONTAINS a 'P' AT THE FOURTH() CHAR()







 -- ==========================================================
	-- CHARINDEX() FIND() SEARCH() LEFT() RIGHT() MID() AND QTR(s) --
-- ==========================================================
SELECT ' ' AS 'ALONE OR IN COMBINATION WITH SUBSTRING(): '
,PATINDEX('%en_ure%','please ensure the door is locked') AS 'PATINDEX START POSITION' -- PATINDEX('%[FIND () WHAT]%',[SOURCE],[START POSITION])  -- [START POSITION] default(s) TO 1 If either pattern or expression is NULL, PATINDEX returns NULL ... LIKE ALT.
,CHARINDEX('en','please ensure the door is locked') AS  'CHARINDEX START POSITION' -- CHARINDEX([FIND() WHAT],[SOURCE],[START POSITION]) ... [START POSITION] default(s) TO 1

		⏎ NESTED TAG(s) - SUBSTRING() LIKE '%MID()%' & CHARINDEX() LIKE '%FIND()%' -- see 'STEP88_ORIGINAL_CLAIM_'....sql

		,CASE
		WHEN DATENAME(qq, CAST(GETDATE() AS datetime)) = '4'
		THEN '4TH QTR '+CAST(DATEPART(yyyy, CAST(GETDATE() AS datetime)) AS nvarchar(4))
		WHEN DATENAME(qq, CAST(GETDATE() AS datetime)) = '3'
		THEN '3RD QTR '+CAST(DATEPART(yyyy, CAST(GETDATE() AS datetime)) AS nvarchar(4))
		WHEN DATENAME(qq, CAST(GETDATE() AS datetime)) = '2'
		THEN '2ND QTR '+CAST(DATEPART(yyyy, CAST(GETDATE() AS datetime)) AS nvarchar(4))
		ELSE '1ST QTR '+CAST(DATEPART(yyyy, CAST(GETDATE() AS datetime)) AS nvarchar(4))
		END AS QTRref --QTR() aka QTR(s)

'A "CLEAN CLAIM" is one that has no defect, impropriety, lack of any required substantiating documentation, or particular circumstance requiring special treatment that prevents timely payment.'

		,CASE --see 'STEP88_ORIGINAL_CLAIM'...sql
		WHEN LTRIM(RTRIM(claimid))  LIKE '%A%'
		THEN CHARINDEX('A',LTRIM(RTRIM(claimid)),1)-1
		WHEN LTRIM(RTRIM(claimid))  LIKE '%R%'
		THEN CHARINDEX('R',LTRIM(RTRIM(claimid)),1)-1
		ELSE  LEN(LTRIM(RTRIM(claimid)))
		END AS [STARTING_POINT_CLAIM_LEN]

		,CASE
		WHEN LTRIM(RTRIM(claimid))  LIKE '%A%'
		THEN SUBSTRING(LTRIM(RTRIM(claimid)),1,CHARINDEX('A',LTRIM(RTRIM(claimid)),1)-1)
		WHEN LTRIM(RTRIM(claimid))  LIKE '%R%'
		THEN SUBSTRING(LTRIM(RTRIM(claimid)),1,CHARINDEX('R',LTRIM(RTRIM(claimid)),1)-1)
		ELSE  LTRIM(RTRIM(claimid))
		END AS [ORIG_REVERSE_APPEND_CLAIMID]

,LEFT(UPPER(LTRIM(RTRIM(MEMNM))),CHARINDEX(',',MEMNM,1)-1) AS LAST_NAME --CHARINDEX() LIKE '%FIND()%' IN MS EXCEL
,UPPER(LTRIM(RTRIM(SUBSTRING(UPPER(LTRIM(RTRIM(MEMNM))),CHARINDEX(',',MEMNM,1)+1,88)))), AS FIRST_NAME --SUBSTRING LIKE '%MID()%' IN EXCEL AND CHARINDEX() LIKE '%FIND()%' IN MS EXCEL
,CAST(NULL AS nvarchar(1)) AS MIDDLE_INITIAL

UPDATE #CARRDirectBillPharmacy
SET MIDDLE_INITIAL = CASE 
WHEN LTRIM(RTRIM(CHARINDEX(' ',LTRIM(RTRIM(FIRST_NAME)),1))) = '0'
THEN ''
ELSE SUBSTRING(FIRST_NAME,CHARINDEX(' ',LTRIM(RTRIM(FIRST_NAME)),1)+1,1) --SUBSTRING LIKE '%MID()%' IN EXCEL AND CHARINDEX() LIKE '%FIND()%' IN MS EXCEL
END 			
FROM #CARRDirectBillPharmacy

UPDATE #CARRDirectBillPharmacy
SET FIRST_NAME = CASE 
WHEN LTRIM(RTRIM(CHARINDEX(' ',LTRIM(RTRIM(FIRST_NAME)),1))) = '0'
THEN LTRIM(RTRIM(FIRST_NAME))
ELSE LEFT(FIRST_NAME,CHARINDEX(' ',LTRIM(RTRIM(FIRST_NAME)),1)) --SUBSTRING LIKE '%MID()%' IN EXCEL AND CHARINDEX() LIKE '%FIND()%' IN MS EXCEL
END 			
FROM #CARRDirectBillPharmacy







-- =====================================================
	-- CASE WHEN THEN ELSE END AS IF() - 'CASE()' --
-- =====================================================
DECLARE @Year AS int
DECLARE @sYear AS varchar(4)

SET @Year  = '2018' --'2021' YEAR(GETDATE())
SET @sYear = CAST(@Year AS varchar(4))

SELECT 'MEMORIAL DAY' AS [Holiday]
,CASE DATEPART(dw,@sYear  +'-'+'05'+'-'+'01') 
WHEN 1 
THEN DATEADD(d,29,@sYear+'-'+'05'+'-'+'01')
WHEN 2 
THEN DATEADD(d,28,@sYear+'-'+'05'+'-'+'01')
WHEN 3 
THEN DATEADD(d,27,@sYear+'-'+'05'+'-'+'01')
WHEN 4 
THEN DATEADD(d,26,@sYear+'-'+'05'+'-'+'01')
WHEN 5 
THEN DATEADD(d,25,@sYear+'-'+'05'+'-'+'01')
WHEN 6 
THEN DATEADD(d,24,@sYear+'-'+'05'+'-'+'01')
WHEN 7 
THEN DATEADD(d,23,@sYear+'-'+'05'+'-'+'01') 
END AS [Holiday Celebrated] -- 4th Monday of May (SPECIAL CIRCUMSTANCE WHEN MONTH START(s) ON MONDAY '2')

'WORK WITH THIS':  
,case when [CMStartDate] LIKE '[0-9][0-9]/[0-9][0-9]/[0-9][0-9][0-9][0-9]' then convert(date, CMStartDate,101)
else null end as CMStartDate
,case when [CMEndDate] LIKE '[0-9][0-9]/[0-9][0-9]/[0-9][0-9][0-9][0-9]' then convert(date, CMEndDate,101)
else null end as CMEndDate
		
----------------,CMStartDate,CMEndDate,PM12StartDate,PM12EndDate
,CASE
WHEN [CMStartDate] LIKE '[0-9][0-9]/[0-9][0-9]/[0-9][0-9][0-9][0-9]'  --VERIFY DEALING WITH TRUE DATE(s)
THEN CONVERT(datetime, CMStartDate,121)
ELSE NULL
END AS [CMStartDate]
,CASE
WHEN [CMEndDate] LIKE '[0-9][0-9]/[0-9][0-9]/[0-9][0-9][0-9][0-9]'  --VERIFY DEALING WITH TRUE DATE(s)
THEN CONVERT(datetime, CMEndDate,121)
ELSE NULL
END AS [CMEndDate]
,CASE
WHEN [PM12StartDate] LIKE '[0-9][0-9]/[0-9][0-9]/[0-9][0-9][0-9][0-9]'  --VERIFY DEALING WITH TRUE DATE(s)
THEN CONVERT(datetime, PM12StartDate,121)
ELSE NULL
END AS [PM12StartDate]
,CASE
WHEN [PM12EndDate] LIKE '[0-9][0-9]/[0-9][0-9]/[0-9][0-9][0-9][0-9]'  --VERIFY DEALING WITH TRUE DATE(s)
THEN CONVERT(datetime, PM12EndDate,121)
ELSE NULL
END AS [PM12EndDate]
		
		see 'SQL09.CHGAPP_PROD.dbo.uvw_EDIDHCSType834' --VIEW() v. FUNCTION()
		
JAH 'R' CLICK THEN 'Page Info'... ( R CLICK())

Beyond IF() and SUM(), 15 really useful excel formulas for everyone - 
'https://chandoo.org/wp/2008/08/13/15-microsoft-excel-formulas/'

TOP 10 Formulas for Aspiring Analysts - 'https://chandoo.org/wp/2013/01/16/top-10-formulas-for-aspiring-analysts/'

EXCEL VLOOKUP WILDCARD(s): - 'https://img.chandoo.org/f/vw/vlookup-wild-card-example.xls'

		SELECT CA_License,* 
		FROM HMOPROD_REPORT.dbo.TimelyAccessCLINIC 
		WHERE CA_License NOT LIKE '%[A-Z]%'  --ENTRY VOID OF ALPHA(s) aka ALL NUMERAL(s)...

		SELECT CA_License,* 
		FROM HMOPROD_REPORT.dbo.TimelyAccessCLINIC 
		WHERE CA_License LIKE '%[A-Z]%'  --ENTRY CONTAINS AN ALPHA

		SELECT CA_License,* 
		FROM HMOPROD_REPORT.dbo.TimelyAccessCLINIC 
		WHERE CA_License NOT LIKE '%[0-9]%'  --ENTRY VOID OF NUMERAL(s) aka ALL ALPHA(s)...

		SELECT CA_License,* 
		FROM HMOPROD_REPORT.dbo.TimelyAccessCLINIC 
		WHERE CA_License LIKE '%[0-9]%'  --ENTRY CONTAINS AT MIN() OF ONE (1) NUMERAL(s)

		SELECT CA_License,* 
		FROM HMOPROD_REPORT.dbo.TimelyAccessCLINIC 
		WHERE CA_License LIKE '%[0-9]%'  --ENTRY CONTAINS AT MIN() OF ONE (1) NUMERAL(s) AND ...
			AND CA_License LIKE '%[A-Z]%'  --...ENTRY CONTAINS AN ALPHA - (ALPHA NUMERIC COMBINATION)

WHERE 1=1 
	AND CA_License LIKE '%[0-9]%'  --ENTRY CONTAINS AT MIN() OF ONE (1) NUMERAL(s) AND ...
		OR ( -- INITIATE ...
		CA_License LIKE '%[0-9]%'  --ENTRY CONTAINS AT MIN() OF ONE (1) NUMERAL(s) AND ...
			AND CA_License LIKE '%[A-Z]%'
			)  -- CONCLUDE ... --...ENTRY CONTAINS AN ALPHA - (ALPHA NUMERIC COMBINATION)

'SAMPLE': --SELECT SUBSTRING(CONVERT(nvarchar,CAST([HOLIDAYDT] AS datetime),112),7,2) AS [TEST_WILDCARD],CONVERT(nvarchar,CAST([HOLIDAYDT] AS datetime),112), * 
SELECT DISTINCT SUBSTRING(CONVERT(nvarchar,CAST([HOLIDAYDT] AS datetime),112),7,2) AS [TEST_WILDCARD]
FROM INFORMATICS.dbo.[FEDERAL_HOLIDAY] 
WHERE (UPPER(LTRIM(RTRIM(SUBSTRING(CONVERT(nvarchar,CAST([HOLIDAYDT] AS datetime),112),7,2)))) LIKE '[1-5][0-0]' 
	OR UPPER(LTRIM(RTRIM(SUBSTRING(CONVERT(nvarchar,CAST([HOLIDAYDT] AS datetime),112),7,2)))) LIKE '[0-0][1-2]'
	OR UPPER(LTRIM(RTRIM(SUBSTRING(CONVERT(nvarchar,CAST([HOLIDAYDT] AS datetime),112),7,2)))) LIKE '[0-0][4-4]'
	OR UPPER(LTRIM(RTRIM(SUBSTRING(CONVERT(nvarchar,CAST([HOLIDAYDT] AS datetime),112),7,2)))) LIKE '[0-0][5-5]') --WAS IN ('01','02','04','30') --DUAL(s) - must meet both criteria: Medicare Indicator A  IN 1, 2, 3, 4, or 5AND Medicare Indicator B IN 1, 2, 4, or 5 NOTE(s): It is no longer required to have a Medicare Indicator D to be considered dual eligible. If a member has both A & B it is assumed they also have D.
ORDER BY SUBSTRING(CONVERT(nvarchar,CAST([HOLIDAYDT] AS datetime),112),7,2)	

--SELECT SUBSTRING(CONVERT(nvarchar,CAST([HOLIDAYDT] AS datetime),112),4,2) AS [TEST_WILDCARD], * 
SELECT DISTINCT SUBSTRING(CONVERT(nvarchar,CAST([HOLIDAYDT] AS datetime),112),4,2) AS [TEST_WILDCARD]
FROM INFORMATICS.dbo.[FEDERAL_HOLIDAY] 
WHERE (UPPER(LTRIM(RTRIM(SUBSTRING(CONVERT(nvarchar,CAST([HOLIDAYDT] AS datetime),112),4,2)))) LIKE '[1-5][0-0]' 
	OR UPPER(LTRIM(RTRIM(SUBSTRING(CONVERT(nvarchar,CAST([HOLIDAYDT] AS datetime),112),4,2)))) LIKE '[0-0][1-2]'
	OR UPPER(LTRIM(RTRIM(SUBSTRING(CONVERT(nvarchar,CAST([HOLIDAYDT] AS datetime),112),4,2)))) LIKE '[0-0][4-4]'
	OR UPPER(LTRIM(RTRIM(SUBSTRING(CONVERT(nvarchar,CAST([HOLIDAYDT] AS datetime),112),4,2)))) LIKE '[0-0][5-5]') --WAS IN ('01','02','04','30') --DUAL(s) - must meet both criteria: Medicare Indicator A  IN 1, 2, 3, 4, or 5AND Medicare Indicator B IN 1, 2, 4, or 5 NOTE(s): It is no longer required to have a Medicare Indicator D to be considered dual eligible. If a member has both A & B it is assumed they also have D.
ORDER BY SUBSTRING(CONVERT(nvarchar,CAST([HOLIDAYDT] AS datetime),112),4,2)	







-- ======================================
	-- NOTE(S) / COMMENT(S) / CHANGE.LOG: 
-- ======================================
'SQL INTERVIEW' - What ways can we use wildcard characters IN LIKE clauses? 
		USE https://www.interviewcake.com/article/python/sql

Answer LIKE lets you use two wildcard characters, "%" and "_". 

"%" matches any amount of characters (including zero characters). So if we want all our customers whose last name starts with "A", we could query:

					SELECT customer_id, last_name 
					FROM customers 
					WHERE last_name LIKE 'a%';

(We could use the BINARY keyword if we wanted a case-sensitive comparison. It would treat the string we’re comparing as a binary string, so we’d compare bytes instead of characters.)  "_" matches exactly one character. If we want all our customers who live ON the 200 block of Flatley Avenue IN Dover, we could query:

					SELECT first_name, street_address 
					FROM customers
					WHERE street_address LIKE '2__ Flatley Avenue' AND city = 'Dover'; --"_" matches exactly one character. If we want all our customers who live ON the 200 block of Flatley Avenue IN Dover, we could query:

And some databases (like SQL Server, but not MySQL or PostgreSQL) support sets or ranges of characters. So we could get every customer whose city starts with either "m" or "d":
					SELECT customer_id 
					FROM customers 
					WHERE city LIKE '[md]%';

Or whose last name starts with any character IN the range “a” through “m” (“a”, “b”, “c”...“k”, “l”, “m”):

					SELECT customer_id 
					FROM customer 
					WHERE last_name LIKE '[a-m]%'
