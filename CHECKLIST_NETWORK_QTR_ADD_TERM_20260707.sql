JAH 'CHPIV VERSION'
Young Lady, a refreshed CHPIV Provider Directory is available for your review at the following location:.

		/* USE [PATH]: file://fileserver01/Corporate%20Shared%20Drive/Information%20Systems/Informatics/WCarr/PROVIDERDIRECTORY/CHPIV/CHPIV_PROVDIR_DSNP_MEDICARE_20260226.pdf
		USE [PATH]: file://fileserver01/Corporate%20Shared%20Drive/Information%20Systems/Informatics/WCarr/PROVIDERDIRECTORY/PROVDIR_eVIP.xlsx  - Raw MS Excel source */
		USE [PATH]: file://fileserver01/Corporate%20Shared%20Drive/Information%20Systems/Informatics/WCarr/PROVIDERDIRECTORY/CHPIV/  - Root

CHPIV Network Data Alignment Analysis
		USE [PATH]: file://fileserver01/CHPIV/Provider%20Directory%20Updates/Outgoing/ - Network Data Alignment including external file: “IPA Provider Directory Data Template 1.28.26.xlsx”

/* ________________________________________
The SQL code (CHPIV_NETWORK_DATA_REVIEW_20251221.sql) implements the business requirements specified by Toni Bonde (CHPIV) for the future SFTP data delivery. The code architecture consolidates two distinct provider populations into a unified dataset with proper source attribution.

Core Requirements (The ASK)
"We anticipate being able to pull a data file, in the attached file layout, that consists of:
		1.	All CHPIV directly contracted and credentialed providers, and
		2.	All providers who have an amendment on behalf of CHPIV as executed by CHG"

		Requirement Decomposition
		Requirement Component	Business Definition	Technical Implementation Requirement
		Population 1	CHPIV directly contracted and credentialed providers	Providers from CHGSD''s PROVDIR tables with CHPIV-DSNP network designation
		Population 2	Providers with CHPIV amendments executed by CHG	External IPA roster providers from CHPIV_PROVIDER_DIRECTORY_DATA
		Data Format	"Linked / Attached file layout"	Unified schema with standardized column mapping
		Source Identification	Distinguish between populations	[Data Sourced From] field implementation
		Delivery Mechanism	SFTP-ready file	Queryable table for export to flat file

________________________________________
CHANGE.LOG: 
		I.	Manual removal of San Diego County VSP Providers
		II.	Manual removal of ‘Pediatric …’ specialty Providers
		III.	Manual [AGE RESTRICTION] set to ’21 AND OVER’ */

		STEP17:  'DELIVER - CHPIV Network Data (External IPA Roster & eVips CHPIV Direct) Alignment Analysis':
		
		-- file://fileserver01/CHPIV/Provider%20Directory%20Updates/Outgoing/CHPIV_NETWORK_DATA_REVIEW_20260618.xlsx - Network Data Alignment including external IPA Roster file (typically from Ms Julia)
		file://fileserver01/CHPIV/Provider%20Directory%20Updates/Outgoing/ - 'Root'
		file://fileserver01/CHPIV/Reports/ - 'CHPIV SFTP DROP - OFF'
		file://servu01/ftpdrop/ImperialValley/ - 'CHPIV SFTP DROP - OFF' 
		
-- =============================================================
	-- JAH CHECKLIST - NETWORK ADDS AND TERMS FOR THE QUARTER --
-- =============================================================
JAH CHARINDEX() FIND() SEARCH() 'FROM:SANDRA SUBJECT:QUER',FROM:SSRS "*ADDS*TERM*"

		USE http://prodqssrs.chg.com/Reports/search/?filter=Network%20Quarterly%20Adds%20Terms - 'SSRS'
		USE http://prodqssrs.chg.com/Reports/manage/catalogitem/properties/Informatics/SUNSET%20DECOMMISSION%20DEPRECATE%20Network%20Quarterly%20Adds%20Terms%20PNI  - 'SSRS'
		-- USE http://prodqssrs.chg.com/Reports/manage/catalogitem/properties/Informatics/Network%20Quarterly%20Adds%20Terms%20PNI  - 'SSRS'
		-- USE http://prodqssrs.chg.com/Reports/manage/catalogitem/properties/Old%20Reports/Network%20Quarterly%20Adds%20Terms%20PNI  - 'SSRS'
		-- USE http://prodqssrs/Reports/report/Informatics/_General/Network%20Quarterly%20Adds%20Terms - 'SSRS'

		USE http://devops01:8080/IS/_git/Informatics?path=%2FeVips%20Network%20Adds%20%26%20Terms&version=GBMain - 'REPO GITHUB'

		SELECT TOP 100 * FROM INFORMATICS.dbo.NETWORKADDS
		SELECT TOP 100 * FROM INFORMATICS.dbo.NETWORKTERMS
		
		SELECT 'BETWEEN '+CAST(CAST(@BeginDate AS date) AS varchar (25))+' AND '+CAST(CAST(@EndDate AS date) AS varchar (25)) AS [RANGE NOTE(s)],CAST(DATEPART(year,CAST(@EndDate AS date)) AS nvarchar(MAX))+' Q'+CAST(DATEPART(quarter,CAST(@EndDate AS date)) AS nvarchar(MAX)) AS [QUARTER]
		,(SELECT COUNT(DISTINCT(NationalProviderID)) AS [Provider Count] FROM INFORMATICS.dbo.NETWORKADDS WHERE ProductTypeName = 'PCP') AS 'Adds PCP Count'
		,(SELECT COUNT(DISTINCT(NationalProviderID)) AS [Provider Count] FROM INFORMATICS.dbo.NETWORKTERMS WHERE ProductTypeName = 'PCP') AS 'Terms PCP Count'
		,(SELECT COUNT(DISTINCT(NationalProviderID)) AS [Provider Count] FROM INFORMATICS.dbo.NETWORKADDS WHERE ProductTypeName = 'SPE') AS 'Adds SPE Count'
		,(SELECT COUNT(DISTINCT(NationalProviderID)) AS [Provider Count] FROM INFORMATICS.dbo.NETWORKTERMS WHERE ProductTypeName = 'SPE') AS 'Terms SPE Count'
		,(SELECT COUNT(DISTINCT(NationalProviderID)) AS [Provider Count] FROM INFORMATICS.dbo.NETWORKADDS WHERE ProductTypeName = 'AHP' AND SpecialtyName LIKE '%PSYC%') AS 'Adds MH (Non Autism) Count'
		,(SELECT COUNT(DISTINCT(NationalProviderID)) AS [Provider Count] FROM INFORMATICS.dbo.NETWORKTERMS WHERE ProductTypeName = 'AHP' AND SpecialtyName LIKE '%PSYC%') AS 'Terms MH (Non Autism) Count'

x SEQUENCE():
		STEP01: EXEC [db].dbo.[sp_NETWORKQTRADDTERM]; -- IN [SQLPRODAPP01] see 'CHECKLIST_SSRS_...sql' AND 'STEP88_sp_STOREDPROCEDURE_...sql'







-- ======================================
	-- NOTE(S) / COMMENT(S):
-- ======================================
JAH 'eMAIL' ON 20230126
x From: Josey Trujillo Morales <jtmoral@chgsd.com> 
Sent: Thursday, January 26, 2023 3:54 PM
To: Walter Carr <WCarr@chgsd.com>
Cc: Salim French <sfrench@chgsd.com>
Subject: RE: Network Quarterly Adds Terms was executed at 1/12/2023 12:15:05 PM

Hi Walter – Please don’t kill me :’/ Is there any chance we can pull in the zip code? Template requests this only for the additions but if it can be included in the terms that would be ok too. 

Thank you!

Josey 

SELECT DISTINCT vpprovloc.LocationID -- ,vpprovloc.PractitionerID,vpprovloc.PracticeID,vpprovloc.LocationID,vpprovloc.AddressID,vpprovloc.LastName,vpprovloc.FirstName,vpprovloc.Archived,vpprovloc.LocationName,vpprovloc.NationalProviderID,vpprovloc.LocationNotes,vpprovloc.PracticeTypeName,vpprovloc.ProviderNumber,vpprovloc.website,vpfacloc.LineNumber1,vpfacloc.LineNumber2,vpfacloc.LineNumber3,vpfacloc.City,vpfacloc.[State],vpfacloc.ZipCode,vpfacloc.LocationTypeName
,CASE
WHEN SUBSTRING(LTRIM(RTRIM(vpfacloc.ZipCode)),1,1) = '0'
THEN '0'+ SUBSTRING(LTRIM(RTRIM(vpfacloc.ZipCode)),2,4)
WHEN SUBSTRING(LTRIM(RTRIM(vpfacloc.ZipCode)),1,1) = '00'
THEN '00'+ SUBSTRING(LTRIM(RTRIM(vpfacloc.ZipCode)),3,3)
ELSE  SUBSTRING(LTRIM(RTRIM(vpfacloc.ZipCode)),1,5) 
END AS ZIP
FROM eVips_chgcv.dbo.vwPractitionerLocations AS vpprovloc
	JOIN eVips_chgcv.dbo.vwPracticeLocations AS vpfacloc ON vpprovloc.PracticeID = vpfacloc.PracticeID
		AND vpprovloc.LocationID = vpfacloc.LocationID 
WHERE UPPER(LTRIM(RTRIM(ISNULL(vpfacloc.LocationTypeName,'')))) LIKE '%PRACTI%'
	AND vpprovloc.LocationID IN ('4108287','4108562','4108859','4108890','4108936','4110257','4110336','4110398','4110407','4110418','4110538','4111114','4111159','4111525','4112120','4112800','4112818','4113108','4113262','4113360','4113491','4114850','4114867','4115920','4117782','4118178','4118182','4118312','4118318','4118328','4118386','4118572','4118663','4118684','4118698','4120029','4120655','4120669','4121316','4121789','4121945','4123079','4123205','4123272','4123324','4123390','4123397','4123988','4124101','4124121','4124227','4125008','4125235','4125256','4125369','4126058','4128455','4131423','4132448','4132500','4132530','4885831','4926735','5064204','5235890','5245676','5257338','5288189','5302424','5332012','5342249','5344567','5344868','5357632','5357649','5357673','5357679','5358958','5402396','5425301','5466534','5507599','5545319','5590918','5674165','5684838','5688759','5688843','5695504','5697040','5697090','5697091','5697092','5697093','5697094','5697095','5697096','5707104','5727517','5728649','5747456','5749898','5750117','5750588','5750658','5750941','5751281','5751282','5762806','5762945','5762983','5763182','5763307','5774457','5775746','5775748','5777138','5777140','5787150','5787744','4131335','4121241','4133141','4128052','5423629','4109324','4112883','4113047','4112035','4121532','4121147','4125842','4125878','4109440','4127208','4962873','4108814','4108875','4118502','4126288','4111852','4111884','5221096','4121049','4121158','4127382','4121205','4121266','4125605','5245355','4125595','4125635','4121290','4133249','5627643','4109477','4117319','4118735','4113003','4123413','4885766','5708743','5078830','5572860','4112237','4124733','4130863','4113858','4113866','4113873','4129281','4921380','4128758','4114547','4114577','4114609','4114642','4114672','4114704','4114737','5545259','5358025','5593909','5663743','4889289') -- ADD ZIP TO QTR NETWORK  ADDS + TERMS REPORT per eMAIL FROM MS JOSEY ON 20230126 'SUBJECT:Network Quarterly Ad FROM:JOSEY TO:WALTER'







JAH 'eMAIL' ON 20221101 
x CHARINDEX() FIND() SEARCH() 'FROM:SANDRA SUBJECT:QUERIE'
Good morning,As discussed in our meeting, below are the queries that are refreshed to produce the Adds and Terms for the quarter.  Let me know if you have any questions.

		SELECT ' ' AS 'see "STEP88_PROVALERT_...sql"'
		USE http://prodqssrs/Reports/report/Informatics/_General/Network%20Quarterly%20Adds%20Terms

WHERE vpp.ProductTypeName = 'PCP'
	AND vpd.PractitionerStatus = 'Active'
	AND vpp.ProductName = 'MEDICAL'
	AND CAST(vpp.DateFrom AS date) BETWEEN @Begindate AND @EndDate -- DateTime (2022, 07, 01, 00, 00, 00) to DateTime (2022, 09, 30, 00, 00, 00)
	AND vpp.StatusTypeName LIKE '%Active%'

		Adds PCP
{vwPractitionerProducts.ProductTypeName} = "PCP" and
{vwPractitionerDemographics.PractitionerStatus} = "Active" and
{vwPractitionerProducts.ProductName} = "MEDICAL" and
{vwPractitionerProducts.DateFrom} in DateTime (2022, 07, 01, 00, 00, 00) to DateTime (2022, 09, 30, 00, 00, 00) and
{vwPractitionerProducts.StatusTypeName} startswith "Active"

		Adds SPE
{vwPractitionerProducts.DateFrom} in DateTime (2022, 07, 01, 00, 00, 00) to DateTime (2022, 09, 30, 00, 00, 00) and
{vwPractitionerDemographics.PractitionerStatus} = "Active" and
{vwPractitionerProducts.ProductName} = "MEDICAL" and
{vwPractitionerProducts.ProductTypeName} = "SPE" and
{vwPractitionerProducts.StatusTypeName} startswith "Active"

		Adds MH (Non Autism)	
{vwPractitionerProducts.ProductTypeName} = "AHP" and
{vwPractitionerProductSpecialties.SpecialtyName} like "*psyc*" and
{vwPractitionerDemographics.PractitionerStatus} = "Active" and
{vwPractitionerProducts.ProductName} = "MEDICAL" and
{vwPractitionerProducts.DateFrom} in DateTime (2022, 07, 01, 00, 00, 00) to DateTime (2022, 09, 30, 00, 00, 00) and
{vwPractitionerProducts.StatusTypeName} startswith "Active"

		Terms PCP	
{vwPractitionerDemographics.PractitionerStatus} = "Inactive" and
{vwPractitionerProducts.ProductName} = "MEDICAL" and
{vwPractitionerProducts.ProductTypeName} = "PCP" and
{vwPractitionerProducts.DateTo} in DateTime (2022, 07, 01, 00, 00, 00) to DateTime (2022, 09, 30, 00, 00, 00) and
{vwPractitionerProducts.StatusTypeName} startswith "Active"

		Terms SPE	
{vwPractitionerDemographics.PractitionerStatus} = "Inactive" and
{vwPractitionerProducts.ProductName} = "MEDICAL" and
{vwPractitionerProducts.ProductTypeName} = "SPE" and
{vwPractitionerProducts.DateTo} in DateTime (2022, 07, 01, 00, 00, 00) to DateTime (2022, 09, 30, 00, 00, 00) and
{vwPractitionerProducts.StatusTypeName} startswith "Active"

		Terms MH (Non Autism)	
{vwPractitionerDemographics.PractitionerStatus} = "Inactive" and
{vwPractitionerProducts.ProductName} = "MEDICAL" and
{vwPractitionerProducts.DateTo} in DateTime (2022, 07, 01, 00, 00, 00) to DateTime (2022, 09, 30, 00, 00, 00) and
{vwPractitionerProducts.ProductTypeName} = "AHP" and
{vwPractitionerProductSpecialties.SpecialtyName} like "*psyc*" and
{vwPractitionerProducts.StatusTypeName} startswith "Active"
 
Sandra Coleman 
Credentialing Services Manager
Community Health Group
2420 Fenton St
Chula Vista, CA 91914
(619) 498-6438
scolem@chgsd.com 

The Community is What Counts

This e-mail communication that you have received may contain Protected Health Information (PHI) as defined by The Health Insurance Portability and Accountability Act of 1996 (HIPAA). Federal law mandates that you not use or disclose the information contained herein in any way that will compromise the privacy, security or confidentiality of the individual to whom the information pertains. If this e-mail communication has been misdirected to you, please notify the sender of this e-mail immediately, delete the e-mail and destroy any copies of the e-mail.







		Adds PCP
{vpp.ProductTypeName} = "PCP" and
{vpd.PractitionerStatus} = "Active" and
{vpp.ProductName} = "MEDICAL" and
{vpp.DateFrom} in DateTime (2022, 07, 01, 00, 00, 00) to DateTime (2022, 09, 30, 00, 00, 00) and
{vpp.StatusTypeName} startswith "Active"

		Adds SPE
{vpp.ProductTypeName} = "SPE" and
{vpd.PractitionerStatus} = "Active" and
{vpp.ProductName} = "MEDICAL" and
{vpp.DateFrom} in DateTime (2022, 07, 01, 00, 00, 00) to DateTime (2022, 09, 30, 00, 00, 00) and
{vpp.StatusTypeName} startswith "Active"

		Adds MH (Non Autism)	
{vpp.ProductTypeName} = "AHP" and
{vpd.PractitionerStatus} = "Active" and
{vpp.ProductName} = "MEDICAL" and
{vpp.DateFrom} in DateTime (2022, 07, 01, 00, 00, 00) to DateTime (2022, 09, 30, 00, 00, 00) and
{vpp.StatusTypeName} startswith "Active" and
{vpps.SpecialtyName} like "*psyc*"

		Terms PCP	
{vpp.ProductTypeName} = "PCP" and
{vpd.PractitionerStatus} = "Inactive" and
{vpp.ProductName} = "MEDICAL" and
{vpp.DateTo} in DateTime (2022, 07, 01, 00, 00, 00) to DateTime (2022, 09, 30, 00, 00, 00) and
{vpp.StatusTypeName} startswith "Active"

		Terms SPE	
{vpp.ProductTypeName} = "SPE" and
{vpd.PractitionerStatus} = "Inactive" and
{vpp.ProductName} = "MEDICAL" and
{vpp.DateTo} in DateTime (2022, 07, 01, 00, 00, 00) to DateTime (2022, 09, 30, 00, 00, 00) and
{vpp.StatusTypeName} startswith "Active"

		Terms MH (Non Autism)	
{vpp.ProductTypeName} = "AHP" and
{vpd.PractitionerStatus} = "Inactive" and
{vpp.ProductName} = "MEDICAL" and
{vpp.DateTo} in DateTime (2022, 07, 01, 00, 00, 00) to DateTime (2022, 09, 30, 00, 00, 00) and
{vpp.StatusTypeName} startswith "Active" and
{vpps.SpecialtyName} like "*psyc*" 

		Adds PCP
WHERE vpp.ProductTypeName = 'PCP'
	AND vpd.PractitionerStatus = 'Active'
	AND vpp.ProductName = 'MEDICAL'
	AND CAST(vpp.DateFrom AS date) BETWEEN @Begindate AND @EndDate -- DateTime (2022, 07, 01, 00, 00, 00) to DateTime (2022, 09, 30, 00, 00, 00)
	AND vpp.StatusTypeName LIKE 'Active%'

		Adds SPE
WHERE vpp.ProductTypeName = 'SPE'
	AND vpd.PractitionerStatus = 'Active'
	AND vpp.ProductName = 'MEDICAL'
	AND CAST(vpp.DateFrom AS date) BETWEEN @Begindate AND @EndDate -- DateTime (2022, 07, 01, 00, 00, 00) to DateTime (2022, 09, 30, 00, 00, 00)
	AND vpp.StatusTypeName LIKE 'Active%'

		Adds MH (Non Autism)
WHERE vpp.ProductTypeName = 'AHP'
	AND vpd.PractitionerStatus = 'Active'
	AND vpp.ProductName = 'MEDICAL'
	AND CAST(vpp.DateFrom AS date) BETWEEN @Begindate AND @EndDate -- DateTime (2022, 07, 01, 00, 00, 00) to DateTime (2022, 09, 30, 00, 00, 00)
	AND vpp.StatusTypeName LIKE 'Active%'
	AND vpps.SpecialtyName LIKE '%PSYC%'

		Terms PCP
WHERE vpp.ProductTypeName = 'PCP'
	AND vpd.PractitionerStatus = 'Inactive'
	AND vpp.ProductName = 'MEDICAL'
	AND CAST(vpp.DateTo AS date) BETWEEN @Begindate AND @EndDate -- DateTime (2022, 07, 01, 00, 00, 00) to DateTime (2022, 09, 30, 00, 00, 00)
	AND vpp.StatusTypeName LIKE 'Active%'

		Terms SPE
WHERE vpp.ProductTypeName = 'SPE'
	AND vpd.PractitionerStatus = 'Inactive'
	AND vpp.ProductName = 'MEDICAL'
	AND CAST(vpp.DateTo AS date) BETWEEN @Begindate AND @EndDate -- DateTime (2022, 07, 01, 00, 00, 00) to DateTime (2022, 09, 30, 00, 00, 00)
	AND vpp.StatusTypeName LIKE 'Active%'

		Terms MH (Non Autism)
WHERE vpp.ProductTypeName = 'AHP'
	AND vpd.PractitionerStatus = 'Inactive'
	AND vpp.ProductName = 'MEDICAL'
	AND CAST(vpp.DateTo AS date) BETWEEN @Begindate AND @EndDate -- DateTime (2022, 07, 01, 00, 00, 00) to DateTime (2022, 09, 30, 00, 00, 00)
	AND vpp.StatusTypeName LIKE 'Active%'
	AND vpps.SpecialtyName LIKE '%PSYC%'
