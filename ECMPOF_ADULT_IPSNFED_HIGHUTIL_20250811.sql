-- =====================================================================
-- Template generated from Template Explorer using:
-- Create Procedure (New Menu).SQL

-- Use the Specify Values for Template Parameters 
-- command (Ctrl-Shift-M) to fill in the parameter 
-- values below.

-- This block of comments will not be included in
-- the definition of the procedure.
-- =====================================================================
USE INFORMATICS

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET NOCOUNT ON -- added to prevent extra result sets from interfering with SELECT statements.
SET ANSI_NULLS ON
SET ANSI_WARNINGS ON
SET ARITHABORT OFF
SET ARITHIGNORE ON
SET TEXTSIZE 2147483647

GO
SET QUOTED_IDENTIFIER ON
GO

-- =====================================================================
-- Author:		WCARR
-- Create date: IN 20230705
-- Description:	ECM POF 
-- =====================================================================

CREATE OR ALTER PROCEDURE dbo.[sp_ECMPOF_ADULTHIGHUTIL] -- <Procedure_Name, sysname, ProcedureName> ... DROP PROCEDURE ... EXEC dbo.sp_ECMPOF_ADULTHIGHUTIL; 

-- =====================================================================
	-- Add the parameters for the stored procedure here:
-- =====================================================================
		/* DECLARE */ @CurrentLOB AS varchar(25) = 'Medi-Cal' -- DEFAULT VAL() 'LOB' OPTION(S): 				C-SNP 				CMC 				D-SNP 				Medi-Cal 				Unknown

AS
BEGIN

-- =====================================================================
	-- INITIATE STATEMENTS FOR PROCEDURE HERE:
-- =====================================================================
-- =====================================================================
	-- COMMENT(S) / CHANGE.LOG: --
-- =====================================================================
--  C001:  POF NAMING CONVENTION UPDATE(S): 
		/* 'Adult Individuals Experiencing Homelessness' REPLACE() SUBSTITUTE() WITH() Adult Individuals Experiencing Homelessness
		'Adult Homeless WITH Family' REPLACE() SUBSTITUTE() WITH() Adult Families Experiencing Homelessness
		'Adult IP ED High Utilization' REPLACE() SUBSTITUTE() WITH() Adult Avoidable Hospital or ED Utilization
		'Adult MH SMI SUD' REPLACE() SUBSTITUTE() WITH() Adult SMH or SUD
		-- 'Adult Transitioning from Incarceration' REPLACE() SUBSTITUTE() WITH() Adult Transitioning from Incarceration
		'Adult Institutionalization' REPLACE() SUBSTITUTE() WITH() Adult At Risk for LTC Institutionalization
		'Adult Nursing Transition' REPLACE() SUBSTITUTE() WITH() Adult NF Transitioning to Community
		'Adult Birth Equity' REPLACE() SUBSTITUTE() WITH() Adult Birth Equity

		'Child Homeless' REPLACE() SUBSTITUTE() WITH() Child Individuals Experiencing Homelessness
		'Child IP ED High Utilization' REPLACE() SUBSTITUTE() WITH() Child Avoidable Hospital or ED Utilization
		'Child MH SMI SUD' REPLACE() SUBSTITUTE() WITH() Child SMH or SUD
		'Child CCS' REPLACE() SUBSTITUTE() WITH() Child CCS/CCS WCM with Additional Needs
		-- 'Child Welfare' REPLACE() SUBSTITUTE() WITH() Child Welfare
		-- 'Child Transitioning from Incarceration' REPLACE() SUBSTITUTE() WITH() Child Transitioning from Incarceration
		-- 'Child Birth Equity' REPLACE() SUBSTITUTE() WITH() Child Birth Equity */

-- =====================================================================
	-- DYNAMIC() v. STATIC() DECLARE(s) FOR [CLAIM LISTING REFINEMENT] --
-- =====================================================================
DECLARE @StartDate date = DATEADD(mm,-6,GETDATE())
DECLARE @EndDate date = GETDATE()
DECLARE @ReportRunDate date = GETDATE()
DECLARE @AgeCutoff int = 21
DECLARE @ERVisit AS int = 5
DECLARE @IPAdmit AS int = 3 -- IP OR SNF
DECLARE @PCPrecordRANK AS int = 1 -- ENTER 1 TO GET() JUST MOST CURRENT [RANKis] see DENSE_RANK() OVER(PARTITION BY ek.memid ORDER BY CAST(ek.effdate AS datetime) DESC) AS [RANKis] --'RANKis' --RANK by MOST CURRENT

		SELECT TOP 1 @AgeCutoff AS [AGE LIMIT >= (GREATER THAN EQUAL TO)],@ReportRunDate AS [RunDate],'BETWEEN '+CAST(CAST(@StartDate AS date) AS varchar(MAX))+' AND '+CAST(CAST(@EndDate AS date) AS varchar(MAX)) AS [RANGE NOTE(s)],* FROM INFORMATICS.dbo.MemberMonths






  
-- ======================================================================
	-- ECM COS (CATEGORY OF SERVICE) -- 
-- ======================================================================
--------------------------------------------------------------------------------------------------------------------
	-- Error Trapping: Check If Permanent Table(s) Already Exist(s) And Drop If Applicable --
--------------------------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS #IPClaims; -- SQL Server 2016 and later -- DYNAMIC tmp OR STATIC [TABLE] #TableName is a local temporary table visible only in the current session; ##TableName is a GLOBAL temporary table visible to all sessions IN ('TempDB')

SELECT c.memid,c.claimid,c.startdate,a.affiliateid,cd.dosfrom
,CAST(UPPER(LTRIM(RTRIM(ISNULL(c.memid,'')))) AS varchar(MAX))+CAST(UPPER(LTRIM(RTRIM(ISNULL(TRY_CONVERT(date,c.startdate),'')))) AS varchar(10))+CAST(UPPER(LTRIM(RTRIM(ISNULL(a.provid,'')))) AS varchar(MAX)) AS [AdmitID] -- 'Unique person, date of service, and provider = one visit' OR 'Unique person, date of service, and NDC = one script'
INTO #IPClaims
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st',
FROM HMOPROD_PlanData.dbo.claim AS c (NOLOCK)
	JOIN HMOPROD_PlanData.dbo.claimdetail AS cd (NOLOCK) ON c.claimid = cd.claimid  
	JOIN HMOPROD_PlanData.dbo.affiliation AS a (NOLOCK) ON c.affiliationid = a.affiliationid  
WHERE 1=1
	AND c.startdate >= @StartDate 
	AND c.startdate <= @EndDate
	AND 
	(
		c.resubclaimid IS NULL 
		OR 
		c.resubclaimid = ''
	)
	AND c.claimid NOT LIKE '%R%' -- NO NOT NEGATIVE != <>
	AND c.[status] IN ('ADJUCATED','PAID','PAY','REV','REVERSED','REVSYNCH') 
	AND c.facilitycode = '1'  
	AND c.billclasscode IN ('1','2')  







--------------------------------------------------------------------------------------------------------------------
	-- Error Trapping: Check If Permanent Table(s) Already Exist(s) And Drop If Applicable --
--------------------------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS #ERClaims; -- SQL Server 2016 and later -- DYNAMIC tmp OR STATIC [TABLE] #TableName is a local temporary table visible only in the current session; ##TableName is a GLOBAL temporary table visible to all sessions IN ('TempDB')

SELECT c.memid,c.claimid,c.startdate,a.affiliateid,cd.dosfrom
,CAST(UPPER(LTRIM(RTRIM(ISNULL(c.memid,'')))) AS varchar(MAX))+CAST(UPPER(LTRIM(RTRIM(ISNULL(TRY_CONVERT(date,c.startdate),'')))) AS varchar(10))+CAST(UPPER(LTRIM(RTRIM(ISNULL(a.provid,'')))) AS varchar(MAX)) AS [AdmitID] -- 'Unique person, date of service, and provider = one visit' OR 'Unique person, date of service, and NDC = one script'
INTO #ERClaims
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st',
FROM HMOPROD_PlanData.dbo.claim AS c (NOLOCK)
	JOIN HMOPROD_PlanData.dbo.claimdetail AS cd (NOLOCK) ON c.claimid = cd.claimid  
	JOIN HMOPROD_PlanData.dbo.affiliation AS a (NOLOCK) ON c.affiliationid = a.affiliationid  
WHERE 1=1
	AND c.startdate >= @StartDate 
	AND c.startdate <= @EndDate
	AND 
	(
		c.resubclaimid IS NULL 
		OR 
		c.resubclaimid = ''
	)
	AND c.claimid NOT LIKE '%R%' -- NO NOT NEGATIVE != <>
	AND c.[status] IN ('ADJUCATED','PAID','PAY','REV','REVERSED','REVSYNCH') 
	AND c.facilitycode = '1' 
	AND c.billclasscode IN ('3','4') 
	AND cd.[status] NOT IN ('DENY','VOID') -- NO NOT NEGATIVE != 
	AND cd.revcode BETWEEN '0450' AND '0459'







--------------------------------------------------------------------------------------------------------------------
	-- Error Trapping: Check If Permanent Table(s) Already Exist(s) And Drop If Applicable --
--------------------------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS #SNFClaims; -- SQL Server 2016 and later -- DYNAMIC tmp OR STATIC [TABLE] #TableName is a local temporary table visible only in the current session; ##TableName is a GLOBAL temporary table visible to all sessions IN ('TempDB')

SELECT c.memid,c.claimid,c.startdate,a.affiliateid,cd.dosfrom,rc.codeid,ISNULL(rc.description,'') AS [code descr],'REV' AS [code type]
,CAST(UPPER(LTRIM(RTRIM(ISNULL(c.memid,'')))) AS varchar(MAX))+CAST(UPPER(LTRIM(RTRIM(ISNULL(TRY_CONVERT(date,c.startdate),'')))) AS varchar(10))+CAST(UPPER(LTRIM(RTRIM(ISNULL(a.provid,'')))) AS varchar(MAX)) AS [AdmitID] -- 'Unique person, date of service, and provider = one visit' OR 'Unique person, date of service, and NDC = one script'
INTO #SNFClaims
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st',
FROM HMOPROD_PlanData.dbo.claim AS c (NOLOCK)
	JOIN HMOPROD_PlanData.dbo.claimdetail AS cd (NOLOCK) ON c.claimid = cd.claimid  
	JOIN HMOPROD_PlanData.dbo.affiliation AS a (NOLOCK) ON c.affiliationid = a.affiliationid 
		LEFT JOIN HMOPROD_PLANDATA.dbo.revcode AS rc ON cd.servcode = rc.codeid
WHERE 1=1
	AND c.startdate >= @StartDate 
	AND c.startdate <= @EndDate
	AND 
	(
		c.resubclaimid IS NULL 
		OR 
		c.resubclaimid = ''
	)
	AND c.claimid NOT LIKE '%R%' -- NO NOT NEGATIVE != <>
	AND c.[status] IN ('ADJUCATED','PAID','PAY','REV','REVERSED','REVSYNCH') 
	AND cd.[status] NOT IN ('DENY','VOID') -- NO NOT NEGATIVE != 	
	AND cd.revcode BETWEEN '0191' AND '0193'
	
UNION 
SELECT c.memid,c.claimid,c.startdate,a.affiliateid,cd.dosfrom,rc.codeid,ISNULL(rc.description,'') AS [code descr],'REV' AS [code type]
,CAST(UPPER(LTRIM(RTRIM(ISNULL(c.memid,'')))) AS varchar(MAX))+CAST(UPPER(LTRIM(RTRIM(ISNULL(TRY_CONVERT(date,c.startdate),'')))) AS varchar(10))+CAST(UPPER(LTRIM(RTRIM(ISNULL(a.provid,'')))) AS varchar(MAX)) AS [AdmitID] -- 'Unique person, date of service, and provider = one visit' OR 'Unique person, date of service, and NDC = one script'
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st',
FROM HMOPROD_PlanData.dbo.claim AS c (NOLOCK)
	JOIN HMOPROD_PlanData.dbo.claimdetail AS cd (NOLOCK) ON c.claimid = cd.claimid  
	JOIN HMOPROD_PlanData.dbo.affiliation AS a (NOLOCK) ON c.affiliationid = a.affiliationid 
		LEFT JOIN HMOPROD_PLANDATA.dbo.revcode AS rc ON cd.servcode = rc.codeid
WHERE 1=1
	AND c.startdate >= @StartDate 
	AND c.startdate <= @EndDate
	AND 
	(
		c.resubclaimid IS NULL 
		OR 
		c.resubclaimid = ''
	)
	AND c.claimid NOT LIKE '%R%' -- NO NOT NEGATIVE != <>
	AND c.[status] IN ('ADJUCATED','PAID','PAY','REV','REVERSED','REVSYNCH') 
	AND cd.[status] NOT IN ('DENY','VOID') -- NO NOT NEGATIVE != 	
	AND cd.revcode IN ('0022')
	
UNION 
SELECT c.memid,c.claimid,c.startdate,a.affiliateid,cd.dosfrom,'BILL TYPE' AS codeid,'BILL TYPE' AS [code descr],'BILL TYPE' AS [code type]
,CAST(UPPER(LTRIM(RTRIM(ISNULL(c.memid,'')))) AS varchar(MAX))+CAST(UPPER(LTRIM(RTRIM(ISNULL(TRY_CONVERT(date,c.startdate),'')))) AS varchar(10))+CAST(UPPER(LTRIM(RTRIM(ISNULL(a.provid,'')))) AS varchar(MAX)) AS [AdmitID] -- 'Unique person, date of service, and provider = one visit' OR 'Unique person, date of service, and NDC = one script'
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st',
FROM HMOPROD_PlanData.dbo.claim AS c (NOLOCK)
	JOIN HMOPROD_PlanData.dbo.claimdetail AS cd (NOLOCK) ON c.claimid = cd.claimid  
	JOIN HMOPROD_PlanData.dbo.affiliation AS a (NOLOCK) ON c.affiliationid = a.affiliationid  
WHERE 1=1
	AND c.startdate >= @StartDate 
	AND c.startdate <= @EndDate
	AND 
	(
		c.resubclaimid IS NULL 
		OR 
		c.resubclaimid = ''
	)
	AND c.claimid NOT LIKE '%R%' -- NO NOT NEGATIVE != <>
	AND c.[status] IN ('ADJUCATED','PAID','PAY','REV','REVERSED','REVSYNCH') 
	AND c.facilitycode = '2' 
	AND c.billclasscode IN ('2','3') 
	AND cd.[status] NOT IN ('DENY','VOID') -- NO NOT NEGATIVE != 

/* ;WITH latest AS ( 
SELECT   
authorizationid,  
MAX(censusdate) AS CensusDate  
FROM InpatientCensus (NOLOCK)  
WHERE CensusCategory = 'Inpatient SNF'  
GROUP BY authorizationid  
),  */

--------------------------------------------------------------------------------------------------------------------
	-- Error Trapping: Check If Permanent Table(s) Already Exist(s) And Drop If Applicable --
--------------------------------------------------------------------------------------------------------------------
-- TRUNCATE TABLE INFORMATICS.dbo.ECMPOF_ADULT_IPSNFED_HIGHUTIL; -- SQL Server 2016 and later -- DYNAMIC tmp OR STATIC [TABLE] #TableName is a local temporary table visible only in the current session; ##TableName is a GLOBAL temporary table visible to all sessions IN ('TempDB')

-- DROP TABLE IF EXISTS INFORMATICS.dbo.ECMPOF_ADULT_IPSNFED_HIGHUTIL; -- SQL Server 2016 and later -- DYNAMIC tmp OR STATIC [TABLE] #TableName is a local temporary table visible only in the current session; ##TableName is a GLOBAL temporary table visible to all sessions IN ('TempDB')

INSERT INTO INFORMATICS.dbo.ECMPOF_ADULT_IPSNFED_HIGHUTIL -- (FIELD(S) IN PLAY,...)
SELECT DISTINCT 'Adult Avoidable Hospital or ED Utilization' AS [TargetPopulation],@AgeCutoff AS [AGE LIMIT >= (GREATER THAN EQUAL TO)],@ReportRunDate AS [RunDate],'BETWEEN '+CAST(CAST(@StartDate AS date) AS varchar(MAX))+' AND '+CAST(CAST(@EndDate AS date) AS varchar(MAX)) AS [RANGE NOTE(s)],
mm.memid,mm.carriermemid,mm.secondaryid,TRY_CONVERT(date,sme.dob) AS [Date of Birth],ent.lastname,ent.firstname,ent.middlename
,[MEMBER_AGE] = CAST(DATEDIFF("dd",CAST(sme.dob AS datetime),TRY_CONVERT(date,@ReportRunDate))/365.25 AS money)
,[MEMBER_TRUE_CHRONOLOGICAL_AGE] = CAST(SUBSTRING(CAST(CAST(DATEDIFF("dd",TRY_CONVERT(date,sme.dob),TRY_CONVERT(date,@ReportRunDate))/365.25 AS money) AS nvarchar(25)),1,CHARINDEX('.',CAST(DATEDIFF("dd",TRY_CONVERT(date,sme.dob),TRY_CONVERT(date,@ReportRunDate))/365.25 AS money),1)-1) AS int)
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
,0 AS [ERVisitCount]
,0 AS [IPAdmitCount]
,0 AS [SNFAdmitCount]
,CAST('N' AS nvarchar(1)) AS [HighUtilizer]
,ISNULL(pcp.PAYTONM,'NO PCP REQUIRED') AS [PCPs Pay To]
-- INTO INFORMATICS.dbo.ECMPOF_ADULT_IPSNFED_HIGHUTIL
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st',
FROM INFORMATICS.dbo.MemberMonths AS mm (NOLOCK)
		LEFT JOIN HMOPROD_PLANDATA.dbo.member AS sme ON mm.memid = sme.memid
		LEFT JOIN HMOPROD_PLANDATA.dbo.entity AS ent ON sme.entityid = ent.entid
		LEFT JOIN SQLPROD02.INFORMATICS.dbo.uvw_PCP AS pcp ON mm.memid = pcp.memid
			AND pcp.[RANKis] = @PCPrecordRANK -- CURRENT OR LAST PCP Ax
			AND pcp.[ROWis] = @PCPrecordRANK -- CURRENT OR LAST PCP Ax

WHERE 1=1
	AND mm.CurrentMonth = 1 -- CURRENTLY ACTIVE OR ... LOB AT REPORT EXEC 
	AND mm.LOB IN (@CurrentLOB)
	AND CAST(SUBSTRING(CAST(CAST(DATEDIFF("dd",TRY_CONVERT(date,sme.dob),TRY_CONVERT(date,@ReportRunDate))/365.25 AS money) AS nvarchar(25)),1,CHARINDEX('.',CAST(DATEDIFF("dd",TRY_CONVERT(date,sme.dob),TRY_CONVERT(date,@ReportRunDate))/365.25 AS money),1)-1) AS int) >= @AgeCutoff
	
	AND mm.memid NOT IN 
	( -- INITIATE ...
	SELECT DISTINCT ccmcm.memberid
	FROM
	( -- INITIATE ...
	SELECT ' ' AS 'MS KATHRYN ENROLLED CCM / CM IDENTIFICATION'
	,'Y' AS [CCMflag],mi.memberid,lcm.Name AS CareMgrName
	FROM ProviderPortal.ecm.MembersInformation AS mi (NOLOCK)
		
		CROSS APPLY (
		SELECT *
		FROM ProviderPortal.ecm.MemberProviderAssigment AS mpa (NOLOCK)
		WHERE mpa.MemberId= mi.MemberId
		AND mpa.TermDate = '2078-12-31'
		) AS mpa
		
		OUTER APPLY (
		SELECT TOP 1 *
		FROM ProviderPortal.ecm.LeadCareManager AS lcm (NOLOCK)
		WHERE lcm.AssignmentID= mpa.AssignmentID
		ORDER BY lcm.LeadCareManagerID DESC
		) AS lcm
		
			LEFT JOIN ProviderPortal.ecm.ValidProvider AS vp ON vp.ProviderId=mpa.ProviderId
	WHERE 1=1
		AND mi.IsECM = 0 
		AND mi.EnrollmentStatus = 'enrolled'
	) -- CONCLUDE ...
	AS ccmcm 
	) -- CONCLUDE ...

  	-- AND mm.InMSSP = 0
	-- AND mm.memid NOT IN 
	-- ( -- INITIATE ...
	-- SELECT MemberId
	-- FROM CM.dbo.uvwCASEMgrRepMembers (NOLOCK)
	-- WHERE 1=1
		-- AND CASEManagerTeam = 'SPD'
	-- ) -- CONCLUDE ...

		/* LEFT JOIN HMOPROD_PlANData..memberattribute ma WITH(INDEX(XIE1memberattribute), NOLOCK) ON m.memid = ma.memid  
			  AND ma.attributeid = 'C01112777'  
			  AND ma.thevalue = 'yes'  
			  AND GETDATE() BETWEEN ma.effdate AND ma.termdate */
  
		/* LEFT JOIN WPW_Roster wpw(NOLOCK) ON m.secondaryid = wpw.CIN  
		  AND FILE_DATE = (SELECT MAX( FILE_DATE) FROM WPW_Roster)  
		  AND current_statusfinal not like 'exited%'  
		WHERE 1=1
			AND ErVisitCount >= 5  
				OR (IPAdmitCount + SNFAdmitCount) >= 3 */
 
	/* AND NOT EXISTS (SELECT top 1 p.MemberId
	FROM ProviderPortal.ECM.MembersPendingAssignment p  (NOLOCK)
	WHERE 1=1
		AND p.MemberId = m.memid) */
	
	/* AND NOT EXISTS (
	SELECT TOP 1 1 
	FROM ProviderPortal.ECM.MembersInformation mi(NOLOCK) 
	WHERE 1=1
		AND mi.MemberId = m.memid --this should be the alias used in the SP
		AND mi.IsECM=0 --PHM members will have this set to 0 and ECM will have 1
		AND mi.EnrollmentStatus='Enrolled') */

UPDATE INFORMATICS.dbo.ECMPOF_ADULT_IPSNFED_HIGHUTIL
SET [ERVisitCount] = util.HIT
FROM INFORMATICS.dbo.ECMPOF_ADULT_IPSNFED_HIGHUTIL AS ecm
	JOIN  
	( -- INITIATE ...
	SELECT ' ' AS 'FROM ER Visits & Inpatient Acute ...sql','IPClaims' AS 'Cx',memid
	,COUNT(DISTINCT(AdmitID )) AS [HIT]
	FROM #ERClaims
	GROUP BY memid
	) -- CONCLUDE ...
	AS util ON ecm.memid = util.memid
	-- AS ecm ON c.AdmitID = util.AdmitID
		-- AND ecm.Cx = util.Cx

UPDATE INFORMATICS.dbo.ECMPOF_ADULT_IPSNFED_HIGHUTIL
SET [IPAdmitCount] = util.HIT
FROM INFORMATICS.dbo.ECMPOF_ADULT_IPSNFED_HIGHUTIL AS ecm
	JOIN 
	( -- INITIATE ...
	SELECT DISTINCT ' ' AS 'FROM ER Visits & Inpatient Acute ...sql','ERClaims' AS 'Cx',memid
	,COUNT(DISTINCT(AdmitID )) AS [HIT]
	FROM #IPClaims
	GROUP BY memid
	) -- CONCLUDE ...
	AS util ON ecm.memid = util.memid
	-- AS ecm ON c.AdmitID = util.AdmitID
		-- AND ecm.Cx = util.Cx

UPDATE INFORMATICS.dbo.ECMPOF_ADULT_IPSNFED_HIGHUTIL
SET [SNFAdmitCount] = util.HIT
FROM INFORMATICS.dbo.ECMPOF_ADULT_IPSNFED_HIGHUTIL AS ecm
	JOIN 
	( -- INITIATE ...
	SELECT DISTINCT ' ' AS 'FROM ER Visits & Inpatient Acute ...sql','SNFClaims' AS 'Cx',memid
	,COUNT(DISTINCT(AdmitID )) AS [HIT]
	FROM #SNFClaims
	GROUP BY memid
	) -- CONCLUDE ...
	AS util ON ecm.memid = util.memid
	-- AS ecm ON c.AdmitID = util.AdmitID
		-- AND ecm.Cx = util.Cx

UPDATE INFORMATICS.dbo.ECMPOF_ADULT_IPSNFED_HIGHUTIL
SET [HighUtilizer] = CASE 
WHEN [ERVisitCount] >= @ERVisit
THEN 'Y'
WHEN [IPAdmitCount] >= @IPAdmit
THEN 'Y'
WHEN [SNFAdmitCount] >= @IPAdmit
THEN 'Y'
ELSE 'N'
END 
FROM INFORMATICS.dbo.ECMPOF_ADULT_IPSNFED_HIGHUTIL AS ecm
-- HAVING COUNT(DISTINCT(ecm.AdmitID)) >= @ERVisit
-- HAVING COUNT(DISTINCT(ecm.AdmitID)) >= @IPAdmit

DELETE
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st',
FROM INFORMATICS.dbo.ECMPOF_ADULT_IPSNFED_HIGHUTIL
WHERE 1=1
	AND [HighUtilizer] = 'N'

-- Display results
		-- SELECT TOP 10 * FROM INFORMATICS.dbo.ECMPOF_ADULT_IPSNFED_HIGHUTIL -- WHERE [HighUtilizer] = 'Y' 

		SELECT 'ECM POF Adult Avoidable Hospital or ED Utilization' AS ' '
		,bp.LINE_OF_BUSINESS AS 'LOB AT REPORT EXEC'
		,COUNT(DISTINCT(pof.memid)) AS [Unique Member Count] 
		FROM INFORMATICS.dbo.ECMPOF_ADULT_IPSNFED_HIGHUTIL AS pof
			JOIN INFORMATICS.dbo.uvw_BASELINE_MEMBERSHIP AS bp ON pof.memid = bp.memid  -- HMOPROD_PLANDATA.dbo.benefitplan + HMOPROD_PLANDATA.dbo.program
		WHERE 1=1
			-- AND bp.LINE_OF_BUSINESS IN ('DSNP'); -- ('CSNP','CMC','MEDICARE ADVANTAGE','DSNP','MEDI-CAL')
		GROUP BY bp.LINE_OF_BUSINESS;
-- =====================================================================
	-- CONCLUDE STATEMENTS FOR PROCEDURE HERE:
-- =====================================================================
END
GO
