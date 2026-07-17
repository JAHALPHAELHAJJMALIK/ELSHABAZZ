USE [INFORMATICS]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =====================================================================
-- Author:		WCARR
-- Create date: IN yyyymmdd
-- Description:	GENERATE VIEW (uvw) 
-- =====================================================================

CREATE  OR ALTER VIEW dbo.[uvw_BASELINE_MEMBERSHIP] -- <VIEW_Name, sysname, VIEWName> ... DROP VIEW ...  SELECT * FROM dbo.[uvw_BASELINE_MEMBERSHIP]

AS

-- =====================================================================
	-- INITIATE STATEMENTS FOR VIEW HERE:
-- =====================================================================
SELECT ' ' AS '#BASELINE QNXT MEMBERSHIP DEMOGRAPHIC JOIN: '
,mem.*
FROM 
( -- INITIATE ...
SELECT ranksetup.*
-- ,DENSE_RANK() OVER(PARTITION BY ranksetup.memid ORDER BY TRY_CONVERT(date,ISNULL(ranksetup.termdate,GETDATE())) DESC,TRY_CONVERT(date,ranksetup.effdate) DESC) AS [RANKis] -- RANK by MOST CURRENT EligHx
,ROW_NUMBER() OVER(PARTITION BY ranksetup.memid ORDER BY TRY_CONVERT(date,ISNULL(ranksetup.termdate,GETDATE())) DESC,TRY_CONVERT(date,ranksetup.effdate) DESC) AS [ROWis] -- RANK by MOST CURRENT EligHx
FROM 
( -- INITIATE ...
SELECT DISTINCT mb.memid
,mb.ssn
,mb.secondaryid
,mb.headofhouse
,mb.sex
,ek.carriermemid
,mb.dob
,mb.deathdate
,CASE
WHEN LEN(SUBSTRING(LTRIM(RTRIM(ISNULL(ek.carriermemid,''))),1,10) ) = 10
THEN SUBSTRING(LTRIM(RTRIM(ISNULL(ek.carriermemid,''))),1,10) 
ELSE TRY_CONVERT(nvarchar(10),NULL)
END AS 'HealthPlanID'
,CASE
WHEN LEN(SUBSTRING(UPPER(LTRIM(RTRIM(ISNULL(mb.secondaryid,'')))),1,9)) = 9
THEN SUBSTRING(UPPER(LTRIM(RTRIM(ISNULL(mb.secondaryid,'')))),1,9)
ELSE TRY_CONVERT(nvarchar(9),NULL)
END AS 'CIN'
,IIF(LEN(mb.headofhouse) < 10, CONCAT(RTRIM(mb.headofhouse), REPLICATE('0', 10 - LEN(mb.headofhouse))), RTRIM(mb.headofhouse)) AS 'PaddedHeadOfHouse' -- When you try to join Capitation Subscriber_ID to Member Headofhouse, there are some subscriber id that won't match ... The Cap table always pads the subscriber ids with zeros to complete it to 10 characters. To overcome this you need to create a member table with the code below
,mb.fullname AS 'Member Name'
,ent.firstname AS 'Member First Name'
,ent.lastname AS 'Member Last Name'
,ek.effdate
,ek.termdate
,lob.* -- uvw_LINE_OF_BUSINESS
FROM HMOPROD_PLANDATA.dbo.member AS mb (NOLOCK)
	INNER JOIN HMOPROD_PLANDATA.dbo.enrollkeys AS ek (NOLOCK) ON mb.memid = ek.memid
	INNER JOIN HMOPROD_PLANDATA.dbo.entity AS ent (NOLOCK) ON mb.entityid = ent.entid
		LEFT JOIN INFORMATICS.dbo.[uvw_LINE_OF_BUSINESS] AS lob ON ek.planid = lob.planid -- HMOPROD_PLANDATA.dbo.benefitplan + HMOPROD_PLANDATA.dbo.program
WHERE 1=1 
	AND UPPER(LTRIM(RTRIM(ISNULL(ek.segtype,'')))) ='INT'
	AND ISNULL(mb.IsSubscriber,'') = 'Y' -- ISO ON SUBSCRIBER ONLY!!! ... -- COMMENT OUT TO ALLOW FOR NEWBORNS AND DEPENDENT(S)
	AND ISNULL(ek.termdate,GETDATE()) > ek.effdate -- MUST BE TRUE ... NON-CROSSFOOTED RECORDS ARE ACTIVE ...	
) -- CONCLUDE ...
AS ranksetup
) -- CONCLUDE ...
AS mem 
WHERE 1=1
	-- AND mem.[RANKis] = 1 -- RANK by MOST CURRENT EligHx
	AND mem.[ROWis] = 1 -- RANK by MOST CURRENT EligHx
	






-- ======================================
	-- NOTE(S) / COMMENT(S) / CHANGE.LOG: 
-- ======================================
	-- CHECK FOR DUP(S) --
/* SELECT ' ' AS 'SHOULD RETURN 0 ROWS - DUP Validation',*
FROM INFORMATICS.dbo.uvw_BASELINE_MEMBERSHIP
WHERE 1=1
	AND memid IN
	( -- INITIATE ...
	SELECT memid
	FROM INFORMATICS.dbo.uvw_BASELINE_MEMBERSHIP AS dup
	GROUP BY memid -- Duplication Driver 
	HAVING COUNT(1)>1 -- HAVING clause RESERVED for AGGREGATE(s) ... HAVING SUM(PAID_NET_AMT) != 0
	) -- CONCLUDE ...

	INNER JOIN INFORMATICS.dbo.uvw_BASELINE_MEMBERSHIP (NOLOCK) AS mem ON  
WHERE 1=1
			AND bp.LINE_OF_BUSINESS IN ('CSNP','CMC','MEDICARE ADVANTAGE','DSNP','MEDI-CAL') */
-- =====================================================================
	-- CONCLUDE STATEMENTS FOR VIEW HERE:
-- =====================================================================
GO
