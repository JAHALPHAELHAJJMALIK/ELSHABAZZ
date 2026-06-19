-- ======================================
	-- TAXONOMY: 
-- ======================================
JAH CHARINDEX() FIND() SEARCH() 'taxonomy', "*EAE*", "*TAX*.rar", "*TAXO*", FROM:SANDRA SUBJECT"*Provide listing of missing or taxonomy codes that are not in the NPI registry*" ON 202508, 'FROM:SSRS SUBJECT:ERROR'

		⏎ 'NPPES' = NATIONAL PLAN & PROVIDER ENUMERATION SYS

				SELECT ' ' AS 'SAMPLE: USE https://npiregistry.cms.hhs.gov/provider-view/1821243759 ',* 
				FROM INFORMATICS.dbo.eVIPS_PRIMARY_TAXONOMY 
				WHERE 1=1 
					AND NPI IN ('1821243759')
				
				SELECT ' ' AS 'SAMPLE: FROM NPPES (NATIONAL PLAN & Provider ENUMERATION SYS): ',* 
				FROM CHGAPP_PROD.dbo.tblNPIdata
				WHERE 1=1 
					AND NPI IN ('1821243759')
					
/* INSERT INTO [dbo].[ProviderTaxonomy] ([ProviderID],[SnapshotID],[TaxonomyCode])

SELECT P.ProviderID
,@SnapshotID
,TaxCross.TaxCode
FROM INFOAG.CHGAPP_PROD.dbo.tblNPIData AS D 
	INNER JOIN SQLPRODAPP01.ProviderRepository.dbo.Providers AS P ON P.NPI COLLATE DATABASE_DEFAULT = D.NPI COLLATE DATABASE_DEFAULT
CROSS APPLY -- CROSS ... THE alias TABLE
( -- INITIATE ...
VALUES
(D.healthcare_provider_taxonomycode_1,  D.healthcare_provider_primary_taxonomy_switch_1),
(D.healthcare_provider_taxonomy_code_2, D.healthcare_provider_primary_taxonomy_switch_2),
(D.healthcare_provider_taxonomy_code_3, D.healthcare_provider_primary_taxonomy_switch_3),
(D.healthcare_provider_taxonomy_code_4, D.healthcare_provider_primary_taxonomy_switch_4),
(D.healthcare_provider_taxonomy_code_5, D.healthcare_provider_primary_taxonomy_switch_5),
(D.healthcare_provider_taxonomy_code_6, D.healthcare_provider_primary_taxonomy_switch_6),
(D.healthcare_provider_taxonomy_code_7, D.healthcare_provider_primary_taxonomy_switch_7),
(D.healthcare_provider_taxonomy_code_8, D.healthcare_provider_primary_taxonomy_switch_8),
(D.healthcare_provider_taxonomy_code_9, D.healthcare_provider_primary_taxonomy_switch_9),
(D.healthcare_provider_taxonomy_code_10, D.healthcare_provider_primary_taxonomy_switch_10),
(D.healthcare_provider_taxonomy_code_11, D.healthcare_provider_primary_taxonomy_switch_11),
(D.healthcare_provider_taxonomy_code_12, D.healthcare_provider_primary_taxonomy_switch_12),
(D.healthcare_provider_taxonomy_code_13, D.healthcare_provider_primary_taxonomy_switch_13),
(D.healthcare_provider_taxonomy_code_14, D.healthcare_provider_primary_taxonomy_switch_14),
(D.healthcare_provider_taxonomy_code_15, D.healthcare_provider_primary_taxonomy_switch_15)
) -- CONCLUDE ...
AS TaxCross(TaxCode, TaxSwitch) -- alias([FIELD1],[FIELD2])
WHERE 1=1 
	AND D.SnapshotID = @SnapshotID
	AND TaxCross.TaxCode IS NOT NULL */

-- =====================================================================
	--  MODIFICATION(S) | CHANGE.LOG:
-- =====================================================================
-- C001 | 20260611 | WCARR | Single-statement optimization
		/* ~ Excel OLE DB command context (SQLPRODAPP01/INFORMATICS).   ROW_NUMBER() replaced with CROSS APPLY TOP 1 to eliminate Sort+SequenceProject stack (plan cost ~221). 
		~ ISNULL() removed from join keys to restore seek eligibility (CONVERT_IMPLICIT warning, nchar/varchar mismatch on tblNPIData.npi). SELECT DISTINCT replaced with GROUP BY per DUB C 2.0. OPTION(RECOMPILE) added for linked server cardinality stability. */

;WITH finalnpitax AS
( -- INITIATE ...
SELECT  ' ' AS 'ADD ON NETWORK ANALYSIS TAXONOMY DATA: '
,ISNULL(npitax.npi,'') AS [NPI]
-- ,TaxCross.*
-- ,LEN(TaxCross.TaxCode) AS [TAX LEN]
,taxdescr.*
,npitax.provider_organization_name
,npitax.parent_organization_lbn
FROM INFOAG.CHGAPP_PROD.dbo.tblNPIData AS npitax

CROSS APPLY -- CROSS ... THE alias TABLE
( -- INITIATE ...
    VALUES
    (npitax.healthcare_provider_taxonomycode_1,  npitax.healthcare_provider_primary_taxonomy_switch_1)
    ,(npitax.healthcare_provider_taxonomy_code_2, npitax.healthcare_provider_primary_taxonomy_switch_2)
    ,(npitax.healthcare_provider_taxonomy_code_3, npitax.healthcare_provider_primary_taxonomy_switch_3)
    ,(npitax.healthcare_provider_taxonomy_code_4, npitax.healthcare_provider_primary_taxonomy_switch_4)
    ,(npitax.healthcare_provider_taxonomy_code_5, npitax.healthcare_provider_primary_taxonomy_switch_5)
    ,(npitax.healthcare_provider_taxonomy_code_6, npitax.healthcare_provider_primary_taxonomy_switch_6)
    ,(npitax.healthcare_provider_taxonomy_code_7, npitax.healthcare_provider_primary_taxonomy_switch_7)
    ,(npitax.healthcare_provider_taxonomy_code_8, npitax.healthcare_provider_primary_taxonomy_switch_8)
    ,(npitax.healthcare_provider_taxonomy_code_9, npitax.healthcare_provider_primary_taxonomy_switch_9)
    ,(npitax.healthcare_provider_taxonomy_code_10, npitax.healthcare_provider_primary_taxonomy_switch_10)
    ,(npitax.healthcare_provider_taxonomy_code_11, npitax.healthcare_provider_primary_taxonomy_switch_11)
    ,(npitax.healthcare_provider_taxonomy_code_12, npitax.healthcare_provider_primary_taxonomy_switch_12)
    ,(npitax.healthcare_provider_taxonomy_code_13, npitax.healthcare_provider_primary_taxonomy_switch_13)
    ,(npitax.healthcare_provider_taxonomy_code_14, npitax.healthcare_provider_primary_taxonomy_switch_14)
    ,(npitax.healthcare_provider_taxonomy_code_15, npitax.healthcare_provider_primary_taxonomy_switch_15)
) AS TaxCross (TaxCode, TaxSwitch) -- alias([FIELD1],[FIELD2])

CROSS APPLY -- INDEPENDENT STAND ALONE ... CROSS APPLY() CROSS JOIN() CARTESIAN PRODUCT
( -- INITIATE: replaces ROW_NUMBER() -- eliminates Sort+SequenceProject
SELECT TOP 1 atc.*
FROM ProviderRepository.dbo.ANCTaxonomyCrosswalk AS atc
WHERE 1=1
	AND atc.TaxonomyCode COLLATE DATABASE_DEFAULT = TaxCross.TaxCode COLLATE DATABASE_DEFAULT
	AND NOT atc.NUCCClassification LIKE '%Student%' -- NO NOT NEGATIVE <> != ...
ORDER BY TRY_CONVERT(date, atc.CrosswalkDate) DESC
) -- CONCLUDE ...
AS taxdescr
WHERE 1=1 
	AND TaxCross.TaxCode IS NOT NULL -- NO NOT NEGATIVE <> != ...
    AND TaxCross.TaxCode <> '' -- NO NOT NEGATIVE <> != ...
) -- CONCLUDE ...

		SELECT * 
		FROM finalnpitax AS fnpi
		WHERE 1=1
			AND ISNULL(fnpi.npi,'') IN ('1881613420') -- SAMPLE: CHPIV IPA PROVIDER - 'Anand	Veerindersingh'ngh'

		USE https://duckduckgo.com/?q=NPPES&ia=web - 'NPPES' = NATIONAL PLAN & PROVIDER ENUMERATION SYS
		USE https://npiregistry.cms.hhs.gov/search - 'NPPES' = NATIONAL PLAN & PROVIDER ENUMERATION SYS
		USE https://npiregistry.cms.hhs.gov/provider-view/1376207829 - 'NPPES (NATIONAL PLAN & PROVIDER ENUMERATION SYS) NPI Registry (hhs.gov)' 1821243759
		USE https://data-docs.snowflake.com/foundations/sources/nppes/ - 'snowflake NPPES NPI Registry (hhs.gov)'
		USE https://taxonomy.nucc.org/
		USE https://app.snowflake.com/marketplace/listing/GZTSZ290BUX66/snowflake-public-data-products-snowflake-data-foundations - 'snowflake OPEN SOURCE'

				see "TAXONOMY_eVIPS_TO_QNXT_20230511.sql"
		
		/* PRACTITIONERS */ 
				1.	Name
				2.	Degree
				3.	NPI
				4.	From product plans
						a.	Provider type
						b.	Practice name

		/* GROUP/FACILITIES */
				1.	DBA name
				2.	FEID
				3.	NPI
				4.	From product plans
						a.	Provider type
						b.	Practice name
						c.	Specialty

SELECT TOP 10 ' ' AS 'ISCAT NAV NPI REGISTRY EDI SOURCE: ',* 
FROM INFOAG.CHGAPP_PROD.dbo.tblNPIData  -- EXEC IN SQLPRODAPP01

		-- SELECT TOP 10 TaxonomyCodeId,* 
		-- FROM INFOAG.HMOPROD_PLANDATA.dbo.ClaimProv

		SELECT TOP 10 taxonomycodeid,* 
		FROM INFOAG.HMOPROD_PLANDATA.dbo.providertaxonomy

		SELECT TOP 10 ProviderTaxonomyCode,* 
		FROM INFOAG.HMOPROD_PLANDATA.dbo.claim

		SELECT TOP 10 ProviderTaxonomyCode,* 
		FROM INFOAG.HMOPROD_PLANDATA.dbo.claimdetail

-- Walter Carr1:16 PM
SELECT * FROM ProviderRepository.dbo.ANCTaxonomyCrosswalk

-- Sushanthi Pediredla1:17 PM
SELECT * FROM HMOPROD_PlanData.dbo.provspecialty

-- Jocelyn Alcala1:17 PM
SELECT * FROM [HMOPROD_PlanData].dbo.[taxonomycode]

-- Jocelyn Alcala1:39 PM
SELECT * FROM SQLPROD01.CHGAPP_PROD.dbo.tblNPIData WHERE NPI IN ('1720171507','1821243759') -- SAMPLE ... SWITCH = Y AS PRIMARY

-- [1:43 PM] Adrian Arce

/* --- TAXONOMY STRING_SPLIT(): Extract up to 6 discrete codes ----------- */
SELECT ' ' AS 'TAXONOMY STRING_SPLIT(): '
,Taxonomy
,LEN(Taxonomy)
,LTRIM(RTRIM(
CASE
WHEN CHARINDEX(',', Taxonomy, 1) > 0
THEN LEFT(Taxonomy, CHARINDEX(',', Taxonomy, 1) - 1)
ELSE Taxonomy
END
)) AS [Taxonomy_1]
,LTRIM(RTRIM(
CASE
WHEN CHARINDEX(',', Taxonomy, CHARINDEX(',', Taxonomy, 1) + 1) > 0
THEN SUBSTRING(Taxonomy,CHARINDEX(',', Taxonomy, 1) + 1,CHARINDEX(',', Taxonomy, CHARINDEX(',', Taxonomy, 1) + 1)- CHARINDEX(',', Taxonomy, 1) - 1)
WHEN CHARINDEX(',', Taxonomy, 1) > 0
THEN SUBSTRING(Taxonomy,CHARINDEX(',', Taxonomy, 1) + 1,LEN(Taxonomy))
ELSE NULL
END
)) AS [Taxonomy_2]
,LTRIM(RTRIM(
CASE
WHEN CHARINDEX(',', Taxonomy,CHARINDEX(',', Taxonomy,CHARINDEX(',', Taxonomy, 1) + 1) + 1) > 0
THEN SUBSTRING(Taxonomy,CHARINDEX(',', Taxonomy,CHARINDEX(',', Taxonomy, 1) + 1) + 1,CHARINDEX(',', Taxonomy,CHARINDEX(',', Taxonomy,CHARINDEX(',', Taxonomy, 1) + 1) + 1)- CHARINDEX(',', Taxonomy,CHARINDEX(',', Taxonomy, 1) + 1) - 1)
WHEN CHARINDEX(',', Taxonomy,CHARINDEX(',', Taxonomy, 1) + 1) > 0
THEN SUBSTRING(Taxonomy,CHARINDEX(',', Taxonomy,CHARINDEX(',', Taxonomy, 1) + 1) + 1,LEN(Taxonomy))
ELSE NULL
END
)) AS [Taxonomy_3],*
FROM INFORMATICS.dbo.STATIC_EXTERNAL_274_HEALTHNET_PROVIDERS (NOLOCK)
ORDER BY LEN(Taxonomy) DESC;

		⏎ 'sp(s)': 
				~ [eVIPSGetGroupTaxonomy]
				~ [eVIPSGetProviderTaxonomy]
				~ [eVIPSGetSiteTaxonomy]

-- =====================================================
	-- TABLE DESIGN: 
-- =====================================================
USE CHGAPP_PROD

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
	AND c.TABLE_CATALOG IN ('CHGAPP_PROD') -- AS [db] 'DatabaseName'
	AND c.TABLE_SCHEMA = 'dbo' 
	AND c.TABLE_NAME = 'tblNPIData'
ORDER BY c.COLUMN_NAME,c.ORDINAL_POSITION;

SELECT ' ' AS 'ACQUIRE / SAMPLE TAXONOMY SOURCE: '
,ISNULL(npitax.healthcare_provider_taxonomycode_1,'') AS [NPPES TaxonomyCode]
,xwalk.*
,npitax.*
-- SELECT TOP 10 ' ' AS 'CHECK 1st',chpiv.NPI_NO,*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM CHGAPP_PROD.dbo.tblNPIData AS npitax 
			LEFT JOIN 
			( -- INITIATE ...
			SELECT TaxonomyCode
			,DHCSNetCertGroup
			,DHCSNetCertCategory
			,NUCCClassification
			,NUCCSpecialization
			FROM SQLPRODAPP01.ProviderRepository.dbo.ANCTaxonomyCrosswalk
			GROUP BY TaxonomyCode,DHCSNetCertGroup,DHCSNetCertCategory,NUCCClassification,NUCCSpecialization
			) -- CONCLUDE ...
			AS xwalk ON ISNULL(npitax.healthcare_provider_taxonomycode_1,'') COLLATE DATABASE_DEFAULT = ISNULL(xwalk.TaxonomyCode,'') COLLATE DATABASE_DEFAULT
WHERE 1=1
		AND 
		( -- INITIATE ...
		ISNULL(npitax.npi,'') IN ('1225375017' -- SHOULD RETURN ZERO (0) TEST OVERLAP ANALYSIS "Healthnet CHPIV ONLY - NOT IN CHGSD" 
			,'1770513061' -- TEST OVERLAP ANALYSIS "CHGSD ONLY - NOT IN CHPIV" 
			,'1669842985') -- BLACK TIGER CONTRACTED TRANSPORTATION ... IN ('1003001363','1114454519','1336244896','1376723759','1508905159')
				OR ISNULL(npitax.provider_last_name,'') LIKE '%BLACK%TIGER%'
			) -- CONCLUDE ...

	





-- ====================================================================
	-- eVIPS TO QNXT TAXONOMY PROVISO: 
-- ====================================================================
	-- ('INFOAG'), -- SERVER: SQLPRODAPP01 LINKED SERVER TO SQLPROD02.INFORMATICS [db]

-----------------------------------------------------------------------------------------------------------------------------
	-- Error Trapping: Check If Permanent Table(s) Already Exist(s) And Drop If Applicable --
-----------------------------------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS INFORMATICS.dbo.PHM_KPI_evipstaxonomy -- DENOMINATOR #BASELINE

;WITH taxonomygroup AS 
( -- INITIATE ...
SELECT ' ' AS 'TAXONOMY, TAXID + DEA (GROUP / DBA)'
,g.NPI
,gt.TaxonomyCode
FROM [ProviderRepository].dbo.[Groups] AS g
	INNER JOIN [ProviderRepository].dbo.[GroupTaxonomy] AS gt ON gt.GroupID = g.GroupID
		AND NOT ISNULL(gt.TaxonomyCode,'') = '' -- NO NOT NEGATIVE <> != ...
WHERE 1=1
	-- AND NOT ISNULL(g.TaxIDNumber,'') = '' -- NO NOT NEGATIVE <> != ... REQ. FOR CCA SUBMISSION
	) -- CONCLUDE ...

,taxonomyproviderpractitioner AS 
( -- INITIATE ...
SELECT ' ' AS 'TAXONOMY, TAXID + DEA (PROVIDER)'
,p.NPI
,pt.TaxonomyCode
FROM [ProviderRepository].dbo.[Providers] AS p
	INNER JOIN [ProviderRepository].dbo.[ProviderTaxonomy] AS pt ON p.ProviderID = pt.ProviderID
		AND NOT ISNULL(pt.TaxonomyCode,'') = '' -- NO NOT NEGATIVE <> != ...
WHERE 1=1
	-- AND NOT ISNULL(vpp.TaxIDNumber,'') = '' -- NO NOT NEGATIVE <> != ... REQ. FOR CCA SUBMISSION
	) -- CONCLUDE ...

,taxonomysitefacilitylocation AS 
( -- INITIATE ...
SELECT ' ' AS 'TAXONOMY, TAXID + DEA (LOCATION)'
,s.NPI
,st.TaxonomyCode
FROM [ProviderRepository].dbo.[Sites] AS s 
	INNER JOIN [ProviderRepository].dbo.[SiteTaxonomy] AS st ON s.SiteID = st.SiteID
		AND NOT ISNULL(st.TaxonomyCode,'') = '' -- NO NOT NEGATIVE <> != ...
WHERE 1=1	
	-- AND NOT ISNULL(s.TaxIDNumber,'') = '' NO NOT NEGATIVE <> != ... -- REQ. FOR CCA SUBMISSION
	) -- CONCLUDE ...
	
SELECT evips.NPI
,evips.TaxonomyCode
,prov.provid
INTO INFORMATICS.dbo.PHM_KPI_evipstaxonomy
FROM 
( -- INITIATE ...
SELECT * FROM taxonomygroup

UNION ALL
SELECT * FROM taxonomyproviderpractitioner

UNION ALL
SELECT * FROM taxonomysitefacilitylocation
) -- CONCLUDE ...
AS evips
	INNER JOIN INFOAG.INFORMATICS.dbo.uvw_PROVISO AS prov ON ISNULL(evips.NPI,'') = ISNULL(prov.NPI,'')
WHERE 1=1
	AND NOT ISNULL(evips.TaxonomyCode,'') = '' -- NO NOT NEGATIVE <> !=
GROUP BY evips.NPI,evips.TaxonomyCode,prov.provid

SELECT et.*
,TRY_CONVERT(nvarchar(255),(LTRIM(RTRIM(ISNULL(tc.NUCCSpecialization,'')+' '+ISNULL(tc.NUCCClassification,''))))) AS [Taxonomy Descr (Specialty)]
FROM INFORMATICS.dbo.PHM_KPI_evipstaxonomy AS et
		-- LEFT JOIN HMOPROD_PLANDATA.dbo.providertaxonomy AS pt ON pt.provid = prov.provid
		LEFT JOIN [ProviderRepository].dbo.ANCTaxonomyCrosswalk AS tc ON ISNULL(et.TaxonomyCode,'') = ISNULL(tc.TaxonomyCode,'')
WHERE 1=1
	-- AND SnapshotID IN (@snapshot)
	AND et.TaxonomyCode IN ('207Q00000X' --  'Family Medicine'),
	,'207QA0000X' --  'Family Medicine - Adolescent Medicine'),
	,'207QA0505X' --  'Family Medicine - Adult Medicine'),
	,'207QG0300X' --  'Family Medicine - Geriatric Medicine'),
	,'207R00000X' --  'Internal Medicine'),
	,'207RA0000X' --  'Internal Medicine - Adolescent Medicine'),
	,'207RG0300X' --  'Internal Medicine - Geriatric Medicine'),
	,'207V00000X' --  'Obstetrics & Gynecology'),
	,'207VG0400X' --  'Obstetrics & Gynecology – Gynecology'),
	,'208000000X' --  'Pediatrics'),
	,'2080A0000X' --  'Pediatrics - Adolescent Medicine'),
	,'208D00000X' --  'General Practice'),
	,'261Q00000X' --  'Clinic/Center'),
	,'261QC0050X' --  'Clinic/Center - Critical Access Hospital'),
	,'261QC1500X' --  'Clinic/Center - Community Health'),
	,'261QF0400X' --  'Clinic/Center - FQHC'),
	,'261QH0100X' --  'Clinic/Center - Health Service'),
	,'261QM1000X' --  'Clinic/Center - Migrant Health'),
	,'261QM1300X' --  'Clinic/Center - Multi-Specialty'),
	,'261QP0904X' --  'Clinic/Center - Public Health, Federal'),
	,'261QP0905X' --  'Clinic/Center - Public Health, State or Local'),
	,'261QP2300X' --  'Clinic/Center - Primary Care'),
	,'261QR1300X' --  'Clinic/Center - Rural Health'),
	,'363A00000X' --  'Physician Assistant'),
	,'363AM0700X' --  'Physician Assistant - Medical'),
	,'363L00000X' --  'Nurse Practitioner'),
	,'363LA2200X' --  'Nurse Practitioner - Adult Health'),
	,'363LC1500X' --  'Nurse Practitioner - Community Health'),
	,'363LF0000X' --  'Nurse Practitioner - Family'),
	,'363LG0600X' --  'Nurse Practitioner - Gerontology'),
	,'363LP0200X' --  'Nurse Practitioner - Pediatrics'),
	,'363LP2300X' --  'Nurse Practitioner - Primary Care'),
	,'363LW0102X' --  'Nurse Practitioner - Women''s Health'),
	,'363LX0001X' --  'Nurse Practitioner - Obstetrics & Gynecology')
	)
	-- AND evips.TaxonomyCode IN ('235Z00000X' -- •	235Z00000X (Speech-Language Pathologist)
	-- ,'231H00000X') -- 	231H00000X (Audiologist)
	-- AND eVIPSProviderID IN ('')
	-- AND ProviderID IN ('6235379') -- SAMPLE:







-- ====================================================================
	-- eVIPS TAXONOMY: 
-- ====================================================================
-- ====================================================================
	-- SET PARAMETER(s) / FILTER(s) / ESTABLISH HDR tempdb(s): 
-- ====================================================================
DECLARE @snapshot AS int = (SELECT MAX([SnapshotID]) AS [SID] FROM [ProviderRepository].dbo.[Snapshot] WHERE 1=1 AND LOB IN ('MEDICAL')) -- [OPTION(S)]: 'MEDICAL','CMC','MEDICARE ... CSNP & DSNP NETWORK IS IDENTICAL

		SELECT ' ' AS 'TAXONOMY SNAPSHOT',@snapshot AS 'PR snapshot in use',* 
		FROM [ProviderRepository].dbo.[Snapshot]
		WHERE 1=1 
			AND SnapshotID IN (SELECT MAX([SnapshotID]) AS [SID] FROM [ProviderRepository].dbo.[Snapshot] GROUP BY LOB)

		SELECT TOP 10 ' ' AS 'ISCAT NAV NPI REGISTRY EDI SOURCE: ',* 
		FROM INFOAG.CHGAPP_PROD.dbo.tblNPIData

		SELECT TOP 10 ' ' AS 'UPDATE DMHC DHCS TAXONOMY CROSSWALK IF / AS NEEDED: '
		,taxranked.*
		FROM 
		( -- INITIATE ...
		SELECT tax.*
		,DENSE_RANK() OVER(PARTITION BY TaxonomyCode ORDER BY TRY_CONVERT(date,CrosswalkDate) DESC) AS [RANKis] -- RANK() ACCOUNT(s) FOR TIES + RETAINS SEQUENCE ... NO NEGATIVE NOT != <> GAPS IN THE SEQUENCE
		,ROW_NUMBER() OVER(PARTITION BY TaxonomyCode ORDER BY TRY_CONVERT(date,CrosswalkDate) DESC) AS [ROWis] -- STRAIGHT FORWARD SEQUENCE
		FROM 
		( -- INITIATE ...
		SELECT DISTINCT CASE
		WHEN ISNULL(tc.NUCCSpecialization,'Undefined') IN ('Undefined')
		THEN ISNULL(tc.NUCCClassification,'')
		ELSE LTRIM(RTRIM(ISNULL(tc.NUCCSpecialization,'')+' '+ISNULL(tc.NUCCClassification,'')))
		END AS 'Specialty'
		,TaxonomyCode COLLATE DATABASE_DEFAULT AS [TaxonomyCode]
		,DHCSNetCertGroup COLLATE DATABASE_DEFAULT AS [DHCSNetCertGroup]
		,DHCSNetCertCategory COLLATE DATABASE_DEFAULT AS [DHCSNetCertCategory]
		,NUCCClassification COLLATE DATABASE_DEFAULT AS [NUCCClassification]
		,NUCCSpecialization COLLATE DATABASE_DEFAULT AS [NUCCSpecialization]
		,TRY_CONVERT(nvarchar,CrosswalkDate) COLLATE DATABASE_DEFAULT AS [CrosswalkDate]
		-- SELECT TOP 1000000 ' ' AS 'CHECK 1st',*
		-- SELECT DISTINCT ' ' AS 'CHECK 1st'
		FROM ProviderRepository.dbo.ANCTaxonomyCrosswalk AS tc
		-- WHERE 1=1
			-- AND (
			-- UPPER(LTRIM(RTRIM(ISNULL(tc.NUCCClassification, '')))) LIKE '%BEHAV%'
			-- OR UPPER(LTRIM(RTRIM(ISNULL(tc.NUCCSpecialization, '')))) LIKE '%BEHAV%'
			-- OR UPPER(LTRIM(RTRIM(ISNULL(tc.NUCCClassification, '')))) LIKE '%PSYCH%'
			-- OR UPPER(LTRIM(RTRIM(ISNULL(tc.NUCCSpecialization, '')))) LIKE '%PSYCH%'
			-- OR UPPER(LTRIM(RTRIM(ISNULL(tc.NUCCClassification, '')))) LIKE '%COUNSEL%'
			-- OR UPPER(LTRIM(RTRIM(ISNULL(tc.NUCCSpecialization, '')))) LIKE '%COUNSEL%'
			-- )
		) -- CONCLUDE ...
		AS tax
		) -- CONCLUDE ...
		AS taxranked
			WHERE 1=1
				AND taxranked.RANKis = 1
				AND taxranked.ROWis = 1	

		/* SELECT SpecialtyName,* 
		FROM evips_chgcv.dbo.vwTaxonomies */

		SELECT TOP 10  ' ' AS 'SOURCE FROM REGULATOR (DHCS) IMPORTED INTO SSMS AS [INFORMATICS].dbo.[SETUPTAXONOMY]: '
		,CASE
		WHEN ISNULL(tax.NUCCSpecialization,'Undefined') IN ('Undefined')
		THEN ISNULL(tax.NUCCClassification,'')
		ELSE LTRIM(RTRIM(ISNULL(tax.NUCCSpecialization,'')+' '+ISNULL(tax.NUCCClassification,'')))
		END AS 'Specialty',* 
		-- SELECT TOP 1000000 ' ' AS 'CHECK 1st',*
		-- SELECT DISTINCT ' ' AS 'CHECK 1st'
		FROM INFORMATICS.dbo.SETUPTAXONOMY AS tax -- ... SUBJECT:"*Annual Network Certification 2022: Time or Distance Analysis and Data Month Utilize*"
		WHERE 1=1
			AND NUCCClassification LIKE '%Student%'
				OR  NUCCSpecialization LIKE '%Student%'
		ORDER BY TRY_CONVERT(date,CrosswalkDate) DESC

		SELECT ' ' AS 'CHECK FOR EXCEPTION(S): IN ANC XWALK NOT IN SETUP',excepttax.*
		FROM 
		( -- INITIATE ...
		SELECT TaxonomyCode COLLATE DATABASE_DEFAULT AS 'TaxonomyCode'
		,DHCSNetCertGroup COLLATE DATABASE_DEFAULT AS 'DHCSNetCertGroup'
		,DHCSNetCertCategory COLLATE DATABASE_DEFAULT AS 'DHCSNetCertCategory'
		,NUCCClassification COLLATE DATABASE_DEFAULT AS 'NUCCClassification'
		,NUCCSpecialization COLLATE DATABASE_DEFAULT AS 'NUCCSpecialization'
		FROM ProviderRepository.dbo.ANCTaxonomyCrosswalk AS tc

		EXCEPT
		SELECT TaxonomyCode COLLATE DATABASE_DEFAULT AS 'TaxonomyCode'
		,DHCSNetCertGroup COLLATE DATABASE_DEFAULT AS 'DHCSNetCertGroup'
		,DHCSNetCertCategory COLLATE DATABASE_DEFAULT AS 'DHCSNetCertCategory'
		,NUCCClassification COLLATE DATABASE_DEFAULT AS 'NUCCClassification'
		,NUCCSpecialization COLLATE DATABASE_DEFAULT AS 'NUCCSpecialization'
		FROM INFORMATICS.dbo.SETUPTAXONOMY AS tax -- ... SUBJECT:"*Annual Network Certification 2022: Time or Distance Analysis and Data Month Utilize*"
		) -- CONCLUDE ...
		AS excepttax

		SELECT ' ' AS 'CHECK FOR EXCEPTION(S): IN SETUP NOT IN ANC XWALK',excepttax.*
		FROM 
		( -- INITIATE ...
		SELECT TaxonomyCode COLLATE DATABASE_DEFAULT AS 'TaxonomyCode'
		,DHCSNetCertGroup COLLATE DATABASE_DEFAULT AS 'DHCSNetCertGroup'
		,DHCSNetCertCategory COLLATE DATABASE_DEFAULT AS 'DHCSNetCertCategory'
		,NUCCClassification COLLATE DATABASE_DEFAULT AS 'NUCCClassification'
		,NUCCSpecialization COLLATE DATABASE_DEFAULT AS 'NUCCSpecialization'
		FROM INFORMATICS.dbo.SETUPTAXONOMY AS tax -- ... SUBJECT:"*Annual Network Certification 2022: Time or Distance Analysis and Data Month Utilize*"

		EXCEPT
		SELECT TaxonomyCode COLLATE DATABASE_DEFAULT AS 'TaxonomyCode'
		,DHCSNetCertGroup COLLATE DATABASE_DEFAULT AS 'DHCSNetCertGroup'
		,DHCSNetCertCategory COLLATE DATABASE_DEFAULT AS 'DHCSNetCertCategory'
		,NUCCClassification COLLATE DATABASE_DEFAULT AS 'NUCCClassification'
		,NUCCSpecialization COLLATE DATABASE_DEFAULT AS 'NUCCSpecialization'
		FROM ProviderRepository.dbo.ANCTaxonomyCrosswalk AS tc
		) -- CONCLUDE ...
		AS excepttax

;WITH taxonomygroup AS 
( -- INITIATE ...
SELECT DISTINCT ' ' AS 'TAXONOMY, TAXID + DEA (GROUP / DBA)'
,g.SnapshotID
,g.GroupID
,g.eVIPSGroupID AS 'practiceid'
,g.NPI
,g.TaxIDNumber
,gt.TaxonomyCode
,TRY_CONVERT(nvarchar(255),(LTRIM(RTRIM(ISNULL(tc.NUCCSpecialization,'')+' '+ISNULL(tc.NUCCClassification,''))))) AS [Taxonomy Descr (Specialty)]
FROM [ProviderRepository].dbo.[Groups] AS g
		LEFT JOIN [ProviderRepository].dbo.[GroupTaxonomy] AS gt ON gt.GroupID = g.GroupID
			AND NOT ISNULL(gt.TaxonomyCode,'') = '' -- NO NOT NEGATIVE <> != ...
		LEFT JOIN ProviderRepository.dbo.ANCTaxonomyCrosswalk AS tc ON ISNULL(t.TaxonomyCode,'') = ISNULL(tc.TaxonomyCode,'')
WHERE 1=1
	AND NOT ISNULL(g.TaxIDNumber,'') = '' -- NO NOT NEGATIVE <> != ... REQ. FOR CCA SUBMISSION
	) -- CONCLUDE ...
	
		SELECT * 
		FROM taxonomygroup
		WHERE 1=1
			AND SnapshotID IN (@snapshot)
			-- AND eVIPSProviderID IN ('4125364') -- SAMPLE: IHP
			-- AND GroupID IN ('1196856') -- SAMPLE: IHP

;WITH taxonomyproviderpractitioner AS 
( -- INITIATE ...
SELECT DISTINCT ' ' AS 'TAXONOMY, TAXID + DEA (PROVIDER)'
,p.SnapshotID
,p.ProviderID
,p.eVIPSProviderID AS 'practitionerid'
,p.NPI
,p.DEANumber 
-- ,vpp.TaxIDNumber -- REQ. FOR GROUP / DBA & LOCATION(S) ONLY
,TRY_CONVERT(nvarchar(9),NULL) AS 'TaxIDNumber' -- REQ. FOR GROUP / DBA & LOCATION(S) ONLY
,pt.TaxonomyCode
,TRY_CONVERT(nvarchar(255),(LTRIM(RTRIM(ISNULL(tc.NUCCSpecialization,'')+' '+ISNULL(tc.NUCCClassification,''))))) AS [Taxonomy Descr (Specialty)]
FROM [ProviderRepository].dbo.[Providers] AS p
		-- LEFT JOIN evips_chgcv.dbo.vwPractitionerProducts AS vpp ON p.eVIPSProviderID = vpp.PractitionerID -- eVIPSProviderID AS 'practitionerid'
		LEFT JOIN [ProviderRepository].dbo.[ProviderTaxonomy] AS pt ON p.ProviderID = pt.ProviderID
			AND NOT ISNULL(pt.TaxonomyCode,'') = '' -- NO NOT NEGATIVE <> != ...
		LEFT JOIN ProviderRepository.dbo.ANCTaxonomyCrosswalk AS tc ON ISNULL(t.TaxonomyCode,'') = ISNULL(tc.TaxonomyCode,'')
WHERE 1=1
	-- AND ISNULL(vpp.TaxIDNumber,'') != '' -- REQ. FOR CCA SUBMISSION
			) -- CONCLUDE ...

		SELECT * 
		FROM taxonomyproviderpractitioner
		WHERE 1=1
			AND SnapshotID IN (@snapshot)
			-- AND eVIPSProviderID IN ('')
			-- AND ProviderID IN ('6235379') -- SAMPLE: 

;WITH taxonomysitefacilitylocation AS 
( -- INITIATE ...
SELECT DISTINCT ' ' AS 'TAXONOMY, TAXID + DEA (LOCATION)'
,s.SnapshotID
,s.SiteID
,s.eVIPSSiteID AS 'locationid'
,s.NPI
,s.TaxIDNumber
,s.DEANumber
,st.TaxonomyCode
,TRY_CONVERT(nvarchar(255),(LTRIM(RTRIM(ISNULL(tc.NUCCSpecialization,'')+' '+ISNULL(tc.NUCCClassification,''))))) AS [Taxonomy Descr (Specialty)]
FROM [ProviderRepository].dbo.[Sites] AS s 
		LEFT JOIN [ProviderRepository].dbo.[SiteTaxonomy] AS st ON s.SiteID = st.SiteID
			AND NOT ISNULL(st.TaxonomyCode,'') = '' -- NO NOT NEGATIVE <> != ...
		LEFT JOIN ProviderRepository.dbo.ANCTaxonomyCrosswalk AS tc ON ISNULL(t.TaxonomyCode,'') = ISNULL(tc.TaxonomyCode,'')
WHERE 1=1	
	AND ISNULL(s.TaxIDNumber,'') != '' -- REQ. FOR CCA SUBMISSION
	) -- CONCLUDE ...

		SELECT * 
		FROM taxonomysitefacilitylocation
		WHERE 1=1
			AND SnapshotID IN (@snapshot)
			-- AND eVIPSSiteID IN ('')
			-- AND SiteID IN ('3055268')






		
		SELECT ' ' AS 'IN SOURCE YET NOT IN EAE ANC TAXONOMY PREP TABLE: ',testexceptions.*
		FROM 
		( -- INITIATE ...		
		SELECT DISTINCT TaxonomyCode COLLATE DATABASE_DEFAULT AS [TaxonomyCode]
		,DHCSNetCertGroup COLLATE DATABASE_DEFAULT AS [DHCSNetCertGroup]
		,DHCSNetCertCategory COLLATE DATABASE_DEFAULT AS [DHCSNetCertCategory]
		,NUCCClassification COLLATE DATABASE_DEFAULT AS [NUCCClassification]
		,NUCCSpecialization COLLATE DATABASE_DEFAULT AS [NUCCSpecialization]
		,TRY_CONVERT(nvarchar,CrosswalkDate) COLLATE DATABASE_DEFAULT AS [CrosswalkDate]
		FROM ProviderRepository.dbo.ANCTaxonomyCrosswalk AS tc

		EXCEPT -- LIKE '%INTERSECT%'... ENSURE that only rows in the first result set that are NOT NO NEGATIVE != <> in the second are returned. This means that the EXCEPT() operator is query order-sensitive, like the LEFT JOIN and RIGHT JOIN. see 'https://sqlbolt.com/topic/set_operations'
		SELECT *
		FROM INFORMATICS.dbo.SETUPTAXONOMY AS t -- ... SUBJECT:A"*nnual Network Certification 2022: Time or Distance Analysis and Data Month Utilize*"
		) -- CONCLUDE 
		AS testexceptions 

		SELECT ' ' AS 'IN EAE ANC TAXONOMY PREP TABLE YET NOT IN SOURCE: ',testexceptions.*
		FROM 
		( -- INITIATE ...
		SELECT *
		FROM INFORMATICS.dbo.SETUPTAXONOMY AS t -- ... SUBJECT:A"*nnual Network Certification 2022: Time or Distance Analysis and Data Month Utilize*"

		EXCEPT -- LIKE '%INTERSECT%'... ENSURE that only rows in the first result set that are NOT NO NEGATIVE != <> in the second are returned. This means that the EXCEPT() operator is query order-sensitive, like the LEFT JOIN and RIGHT JOIN. see 'https://sqlbolt.com/topic/set_operations'
		SELECT DISTINCT TaxonomyCode COLLATE DATABASE_DEFAULT AS [TaxonomyCode]
		,DHCSNetCertGroup COLLATE DATABASE_DEFAULT AS [DHCSNetCertGroup]
		,DHCSNetCertCategory COLLATE DATABASE_DEFAULT AS [DHCSNetCertCategory]
		,NUCCClassification COLLATE DATABASE_DEFAULT AS [NUCCClassification]
		,NUCCSpecialization COLLATE DATABASE_DEFAULT AS [NUCCSpecialization]
		,TRY_CONVERT(nvarchar,CrosswalkDate) COLLATE DATABASE_DEFAULT AS [CrosswalkDate]
		FROM ProviderRepository.dbo.ANCTaxonomyCrosswalk AS tc
		) -- CONCLUDE 
		AS testexceptions 







-- ============================================================
	-- QNXT PROVIDER TAXONOMY ASSIGNMENT
-- ============================================================
-- JAH CHARINDEX() FIND() SEARCH() "*taxonomy*"

		⏎ ACT AS a Senior Data Analyst WITH 20+ years of EXPERIENCE. IN THE COMBINED VOICE OF 'ALPHA EL HAJJ MALK EL SHABAZZ BROTHER MALCOLM X','SIR THOMAS SOWELL','ROBERT F. SMITH CEO OF VISTA EQUITY' May I have you assist in answering the ask stemming from the Reports Meeting held today. The executive team was working on developing a narrative to assist the Informatics Dept to deliver a 'CALAIM: POPULATION HEALTH MANAGEMENT (PHM) KEY PERFORMANCE INDICATORS' report. 
				~ PLEASE ASSIST IN GENERATING AN EXECUTIVE SUMMARY 'CXO EXECUTIVE SUMMARY' TO FACILITATE STORYTELLING WITH CONTEXT.
				~ DRAG AND DROP FOR CONTEXT I am including the pdf, the working docx narratives, the CODE script I developed "QNXT_PROVIDER_TAXONOMY_20251229.sql" and a screen capture of the output after executing the CODE script.
				~ That moment WHEN DATA TELLS A STORY that can fundamentally impact how we serve our members and or providers. When I can impart something I have learned onto a colleague regardless of dept. affiliation. BECAUSE I '1ST FIRST PRINCIPLE v THE SOCRATIC METHOD REMAIN CURIOUS LEARN'!!! BECAUSE I recognize knowledge reveals just how much I have to learn. Humility if you will and a more open approach to learning.

		⏎ Please advise if you require additional context, thank you.

		'NPPES' = NATIONAL PLAN & Provider ENUMERATION SYS
              USE https://duckduckgo.com/?q=NPPES&ia=web - 'NPPES' = NATIONAL PLAN & Provider ENUMERATION SYS
              USE https://npiregistry.cms.hhs.gov/provider-view/1821243759 - 'NPPES' = NATIONAL PLAN & Provider ENUMERATION SYS
              USE https://npiregistry.cms.hhs.gov/search - 'NPPES' = NATIONAL PLAN & Provider ENUMERATION SYS

                           SELECT ' ' AS 'SAMPLE: USE https://npiregistry.cms.hhs.gov/provider-view/1821243759 ',*
                           FROM INFORMATICS.dbo.eVIPS_PRIMARY_TAXONOMY
                           WHERE 1=1  
							AND NPI IN ('1821243759')                         

                           SELECT TOP 10 ' ' AS 'FROM NPPES ()',*
                           FROM CHGAPP_PROD.dbo.tblNPIdata

-- =====================================================
	-- TABLE DESIGN: 
-- =====================================================
USE HMOPROD_PLANDATA

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
	AND c.TABLE_CATALOG IN ('HMOPROD_PLANDATA') -- AS [db] 'DatabaseName'
	AND c.TABLE_SCHEMA = 'dbo' 
	AND c.TABLE_NAME = 'taxonomycode'
ORDER BY c.COLUMN_NAME,c.ORDINAL_POSITION;

-- =====================================================
	-- TABLE DESIGN: 
-- =====================================================
USE HMOPROD_PLANDATA

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
	AND c.TABLE_CATALOG IN ('HMOPROD_PLANDATA') -- AS [db] 'DatabaseName'
	AND c.TABLE_SCHEMA = 'dbo' 
	AND c.TABLE_NAME = 'providertaxonomy'
ORDER BY c.COLUMN_NAME,c.ORDINAL_POSITION;

-- =====================================================
	-- MULTI - [db] DATABASE OBJECT SEARCH TEMPLATE: 
-- =====================================================
DECLARE @SearchText NVARCHAR(MAX) = 'taxonomy'; -- Text to search for DEANumber, CONTRACTING_, primarystatus, uvw_JusticeInvolvedIndicator, Marketer, Grievance, paid, LTCFacilityType, % Vari, ReportingCounts
DECLARE @ExactMatchST BIT = 0; -- SET AS 1 WHEN NULL OR FOR an exact match ON @PARAM
DECLARE @ObjectName NVARCHAR(MAX) = 'tax'; -- Keep broad for object names
DECLARE @ExactMatchON BIT = 0; -- SET AS 1 WHEN NULL OR FOR an exact match ON @PARAM
DECLARE @SchemaName NVARCHAR(128) = NULL; -- Target schema (optional) magellan, dbo, ECM, EcmJson ... IGNORE CASE SENSITIVITY
DECLARE @ObjectType NVARCHAR(128) = NULL; -- All object types (optional) 
DECLARE @IncludeSystemObjects BIT = 0;   -- INCLUSION OR EXCLUSION OF system objects

		SELECT ISNULL(@SearchText,'N/A') AS 'Search Text'
		,ISNULL(@ObjectName,'N/A') AS 'Object Name'
		,ISNULL(@SchemaName,'N/A') AS 'Schema Name';

-- Define [db] to search
DECLARE @DatabaseList TABLE (DatabaseName NVARCHAR(128))

INSERT INTO @DatabaseList (DatabaseName)
VALUES 
	-- ('INFORMATICS'), -- WORKING [db]
	('HMOPROD_QCSIDB'), -- QNXT 'User'
	('HMOPROD_PLANDATA'); -- QNXT [db]
	-- ('EnrollmentManager'), -- 834 MEMBERSHIP
	-- ('FINCHG'), -- FINANCE DEPT.	
	-- ('CareHub'), -- MIGRATION FROM [MemberPortal]
	-- ('MemberPortal'),
	-- ('ProviderPortal'),
	-- ('CHGAPP_PROD'),	
	-- ('evips_chgcv'), -- SERVER: SQLPRODAPP01 PROVIDER NETWORK SOURCE DATA
	-- ('ProviderRepository'), -- SERVER: SQLPRODAPP01 REPO
	-- ('INFOAG'), -- SERVER: SQLPRODAPP01 LINKED SERVER TO SQLPROD02.INFORMATICS [db]
	-- ('QPROD'),
	-- ('DATAWAREHOUSE'), -- LEGACY DW
	-- ('INFORMATICS2'), -- SQLPROD01.QPROD
	-- ('DIAMOND_Data'),  -- LEGACY SYSTEM (D950) ... 
	-- ('dataprep'),  -- LEGACY STAGING ... 
	-- ('QNXT_Custom'),  -- FOR TRI (TARGETED RATE INCREASE)	
	-- ('master'); -- SQLPROD01.QPROD	

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
	-- AND ISNULL(ObjectName,'') LIKE ISNULL('%'+@ObjectName+'%','%')
	AND ISNULL(ColumnName,'') LIKE ISNULL('%'+@SearchText+'%','%') 
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

		SELECT * FROM INFORMATICS.dbo.uvw_PROVISO WHERE 1=1 AND ISNULL(provid,'') IN ('311929','356801') -- SAMPLE: WITH AND MISSING IN QNXT
		SELECT * FROM HMOPROD_PLANDATA.dbo.taxonomycode
		SELECT * FROM HMOPROD_PLANDATA.dbo.providertaxonomy WHERE 1=1 AND ISNULL(provid,'') IN ('311929','356801') -- SAMPLE: WITH AND MISSING IN QNXT
		
SELECT ' ' AS 'SUMMARY - QNXT PROVIDER(S) TAXONOMY: ' -- LEVERAGE: REPORTS MEETING DISCUSSION ON 20251229 REPLATED TO PHM KPI NARRATIVE DEVELOPMENT
,COUNT(DISTINCT(piso.provid)) AS [Unique QNXT provid COUNT]
,COUNT(DISTINCT(piso.NPI)) AS [Unique QNXT NPI COUNT]
,COUNT(DISTINCT(withtax.provid)) AS [Unique QNXT provid WITH a Taxonomy Code]
,COUNT(DISTINCT(withtax.NPI)) AS [Unique QNXT NPI WITH a Taxonomy Code]
,COUNT(DISTINCT(withouttax.provid)) AS [Unique QNXT provid WITHOUT a Taxonomy Code]
,COUNT(DISTINCT(withouttax.NPI)) AS [Unique QNXT NPI WITHOUT a Taxonomy Code]
FROM INFORMATICS.dbo.uvw_PROVISO AS piso
		LEFT JOIN 
		( -- INITIATE ...
		SELECT ' ' AS 'PROVIDER(S) MISSING TAXONOMY: ' -- LEVERAGE: REPORTS MEETING DISCUSSION ON 20251229 REPLATED TO PHM KPI NARRATIVE DEVELOPMENT
		,ISNULL(pt.taxonomycodeid,'MISSING Taxonomy Code') AS [Taxonomy Code]
		,LTRIM(RTRIM(ISNULL(tax.groupdescription,'MISSING Taxonomy Code')+' '+ISNULL(tax.[description],'')+' '+ISNULL(tax.Specialization,''))) AS [Taxonomy Code Descr]
		,piso.provid
		,piso.fedid
		,piso.NPI
		,piso.PROVNM
		,piso.SPECdescr AS 'Primary Specialty'
		,piso.PROVcity
		,piso.PROVstate
		FROM INFORMATICS.dbo.uvw_PROVISO AS piso
				LEFT JOIN HMOPROD_PLANDATA.dbo.providertaxonomy AS pt ON ISNULL(piso.provid,'') = ISNULL(pt.provid,'')
				LEFT JOIN HMOPROD_PLANDATA.dbo.taxonomycode AS tax ON ISNULL(pt.taxonomycodeid,'') = ISNULL(tax.taxonomycodeid,'')
		WHERE 1=1
			AND ISNULL(pt.taxonomycodeid,'MISSING Taxonomy Code') = 'MISSING Taxonomy Code'
			AND NOT ISNULL(piso.NPI,'') = '' -- NO NOT NEGATIVE <> != ... 
		GROUP BY ISNULL(pt.taxonomycodeid,'MISSING Taxonomy Code')
		,LTRIM(RTRIM(ISNULL(tax.groupdescription,'MISSING Taxonomy Code')+' '+ISNULL(tax.[description],'')+' '+ISNULL(tax.Specialization,'')))
		,piso.provid
		,piso.fedid
		,piso.NPI
		,piso.PROVNM
		,piso.SPECdescr
		,piso.PROVcity
		,piso.PROVstate
		) -- CONCLUDE ...
		AS withouttax ON ISNULL(piso.provid,'') = ISNULL(withouttax.provid,'')
		LEFT JOIN 
		( -- INITIATE ...
		SELECT ' ' AS 'PROVIDER(S) WITH() TAXONOMY: ' -- LEVERAGE: REPORTS MEETING DISCUSSION ON 20251229 REPLATED TO PHM KPI NARRATIVE DEVELOPMENT
		,ISNULL(pt.taxonomycodeid,'MISSING Taxonomy Code') AS [Taxonomy Code]
		,LTRIM(RTRIM(ISNULL(tax.groupdescription,'MISSING Taxonomy Code')+' '+ISNULL(tax.[description],'')+' '+ISNULL(tax.Specialization,''))) AS [Taxonomy Code Descr]
		,piso.provid
		,piso.fedid
		,piso.NPI
		,piso.PROVNM
		,piso.SPECdescr AS 'Primary Specialty'
		,piso.PROVcity
		,piso.PROVstate
		FROM INFORMATICS.dbo.uvw_PROVISO AS piso
				LEFT JOIN HMOPROD_PLANDATA.dbo.providertaxonomy AS pt ON ISNULL(piso.provid,'') = ISNULL(pt.provid,'')
				LEFT JOIN HMOPROD_PLANDATA.dbo.taxonomycode AS tax ON ISNULL(pt.taxonomycodeid,'') = ISNULL(tax.taxonomycodeid,'')
		WHERE 1=1
			AND ISNULL(pt.taxonomycodeid,'MISSING Taxonomy Code') != 'MISSING Taxonomy Code' -- NO NOT NEGATIVE <> != ... 
			AND NOT ISNULL(piso.NPI,'') = '' -- NO NOT NEGATIVE <> != ... 
		GROUP BY ISNULL(pt.taxonomycodeid,'MISSING Taxonomy Code')
		,LTRIM(RTRIM(ISNULL(tax.groupdescription,'MISSING Taxonomy Code')+' '+ISNULL(tax.[description],'')+' '+ISNULL(tax.Specialization,'')))
		,piso.provid
		,piso.fedid
		,piso.NPI
		,piso.PROVNM
		,piso.SPECdescr
		,piso.PROVcity
		,piso.PROVstate
		) -- CONCLUDE ...
		AS withtax ON ISNULL(piso.provid,'') = ISNULL(withtax.provid,'')
WHERE 1=1
	-- AND ISNULL(pt.taxonomycodeid,'MISSING Taxonomy Code') = 'MISSING Taxonomy Code'
	AND NOT ISNULL(piso.NPI,'') = '' -- NO NOT NEGATIVE <> != ... 

SELECT ' ' AS 'UNIVERSE - QNXT PROVIDER(S) TAXONOMY: ' -- LEVERAGE: REPORTS MEETING DISCUSSION ON 20251229 REPLATED TO PHM KPI NARRATIVE DEVELOPMENT
,ISNULL(pt.taxonomycodeid,'MISSING Taxonomy Code') AS [Taxonomy Code]
,LTRIM(RTRIM(ISNULL(tax.groupdescription,'MISSING Taxonomy Code')+' '+ISNULL(tax.[description],'')+' '+ISNULL(tax.Specialization,''))) AS [Taxonomy Code Descr]
,piso.provid
,piso.fedid
,piso.NPI
,piso.PROVNM
,piso.SPECdescr AS 'Primary Specialty'
,piso.PROVcity
,piso.PROVstate
,addcounty.County
FROM INFORMATICS.dbo.uvw_PROVISO AS piso
		LEFT JOIN HMOPROD_PLANDATA.dbo.providertaxonomy AS pt ON ISNULL(piso.provid,'') = ISNULL(pt.provid,'')
		LEFT JOIN HMOPROD_PLANDATA.dbo.taxonomycode AS tax ON ISNULL(pt.taxonomycodeid,'') = ISNULL(tax.taxonomycodeid,'')
		LEFT JOIN 
		( -- INITIATE ...
		SELECT ' ' AS 'ADD COUNTY FROM "DMHC CA County and ZIP Code Combinations - Revised 3.24.2020.xlsx" : ' 
		,City
		,[State]
		,SUBSTRING(LTRIM(RTRIM(ISNULL(ZipCode,''))),1,5) AS ZIP
		,ZipCode
		,County
		FROM INFORMATICS.dbo.ZIP_CODES -- LEVERAGE: "ZIP_DMHC CA County and ZIP Code Combinations - Revised 3.24.2020.xlsx" AND / OR "TIMELYACCESS_...rar" SERVICE AREA
		WHERE 1=1
			-- AND County LIKE '%SAN%DIEG%'
		GROUP BY City,[State],SUBSTRING(LTRIM(RTRIM(ISNULL(ZipCode,''))),1,5),ZipCode,County
		) -- CONCLUDE ...
		AS addcounty ON piso.PROVzip COLLATE DATABASE_DEFAULT = addcounty.ZIP COLLATE DATABASE_DEFAULT
WHERE 1=1
	AND ISNULL(piso.provid,'') IN ('311929','356801') -- SAMPLE: WITH AND MISSING IN QNXT
	AND NOT ISNULL(piso.NPI,'') = '' -- NO NOT NEGATIVE <> != ... 
GROUP BY ISNULL(pt.taxonomycodeid,'MISSING Taxonomy Code')
,LTRIM(RTRIM(ISNULL(tax.groupdescription,'MISSING Taxonomy Code')+' '+ISNULL(tax.[description],'')+' '+ISNULL(tax.Specialization,'')))
,piso.provid
,piso.fedid
,piso.NPI
,piso.PROVNM
,piso.SPECdescr
,piso.PROVcity
,piso.PROVstate
,addcounty.County
ORDER BY piso.PROVcity,piso.PROVstate,piso.PROVNM







-- ======================================
	-- NOTE(S) / COMMENT(S): 
-- ======================================
-- ====================================================================
	-- SET PARAMETER(s) / FILTER(s) / ESTABLISH HDR tempdb(s): 
-- ====================================================================
DECLARE @SnapshotID AS int = (SELECT MAX([SnapshotID]) AS [SID] FROM [ProviderRepository].dbo.[Snapshot] WHERE 1=1 AND LOB IN ('MEDICAL')) -- [OPTION(S)]: 'MEDICAL','CMC','MEDICARE ... CSNP & DSNP NETWORK IS IDENTICAL

		SELECT ' ' AS 'TAXONOMY SNAPSHOT',@SnapshotID AS 'PR snapshot in use',* 
		FROM [ProviderRepository].dbo.[Snapshot]
		WHERE 1=1 
			AND SnapshotID IN (SELECT MAX([SnapshotID]) AS [SID] FROM [ProviderRepository].dbo.[Snapshot] GROUP BY LOB)

-- INSERT INTO #Temp -- (FIELD(S) IN PLAY,...)  
SELECT DISTINCT t.SnapshotID
,t.GroupID
,t.eVIPSGroupID
,t.GroupName
,t.NPI
,t.TaxIDNumber
,t.PracticeTypeName
,t.AssignedTo
,'GroupTaxonomy' AS 'ErrorColumn'
,'Missing OR Student Taxonomy: '+TRY_CONVERT(nvarchar(255),(LTRIM(RTRIM(ISNULL(tc.NUCCSpecialization,'')+' '+ISNULL(tc.NUCCClassification,''))))) AS 'ErrorText' -- C003: NPIs pending OR Missing Taxonomy update in NPI Registry. -Per email from MS SANDRA ON 20251031 SUBJECT:Symphony - NPIs pending Taxonomy update in NPI Registry
FROM 
( -- INITIATE ...
SELECT DISTINCT ' ' AS 'TAXONOMY, TAXID + DEA (GROUP / DBA)'
,g.SnapshotID
,g.GroupID
,g.eVIPSGroupID
,g.eVIPSGroupID AS 'practiceid'
,g.GroupName
,g.NPI
,g.TaxIDNumber
,g.PracticeTypeName
,g.AssignedTo
,gt.TaxonomyCode
FROM [ProviderRepository].dbo.[Groups] AS g
		LEFT JOIN [ProviderRepository].dbo.[GroupTaxonomy] AS gt ON gt.GroupID = g.GroupID
			AND NOT ISNULL(gt.TaxonomyCode,'') = '' -- NO NOT NEGATIVE <> != ...
WHERE 1=1
	AND NOT ISNULL(g.TaxIDNumber,'') = '' -- NO NOT NEGATIVE <> != ... REQ. FOR CCA SUBMISSION
	) -- CONCLUDE ...
	AS t
		LEFT JOIN ProviderRepository.dbo.ANCTaxonomyCrosswalk AS tc ON t.TaxonomyCode = tc.TaxonomyCode
WHERE 1=1
	AND t.SnapshotID IN (@SnapshotID)
	AND ( -- INITIATE ...
	ISNULL(t.TaxonomyCode,'') = ''
		OR tc.NUCCClassification LIKE '%Student%'
		OR  tc.NUCCSpecialization LIKE '%Student%'
		) -- CONCLUDE ...

-- INSERT INTO #Temp -- (FIELD(S) IN PLAY,...)  
SELECT DISTINCT t.ProviderID
,t.eVIPSProviderID
,t.FirstName
,t.LastName
,t.NPI
,t.ProviderType AS 'Degree'
,t.ProductType AS 'PlanProvType'
,t.AssignedTo
,'ProviderTaxonomy' AS 'ErrorColumn'
,'Missing OR Student Taxonomy: '+TRY_CONVERT(nvarchar(255),(LTRIM(RTRIM(ISNULL(tc.NUCCSpecialization,'')+' '+ISNULL(tc.NUCCClassification,''))))) AS 'ErrorText' -- C013: NPIs pending OR Missing Taxonomy update in NPI Registry. -Per email from MS SANDRA ON 20251031 SUBJECT:Symphony - NPIs pending Taxonomy update in NPI Registry
,NULL AS 'MemberCount'
FROM 
( -- INITIATE ...
SELECT DISTINCT ' ' AS 'TAXONOMY, TAXID + DEA (PROVIDER)'
,p.ProviderID
,p.eVIPSProviderID
,p.FirstName
,p.LastName
,p.NPI
,sp.ProviderType
,sp.ProductType
,p.AssignedTo
,p.SnapshotID
,p.eVIPSProviderID AS 'practitionerid'
,p.DEANumber 
,pt.TaxonomyCode
FROM [ProviderRepository].dbo.[Providers] AS p
	INNER JOIN [ProviderRepository].dbo.SiteProviders sp ON sp.ProviderID = p.ProviderID
		LEFT JOIN [ProviderRepository].dbo.[ProviderTaxonomy] AS pt ON p.ProviderID = pt.ProviderID
			AND NOT ISNULL(pt.TaxonomyCode,'') = '' -- NO NOT NEGATIVE <> != ...
	) -- CONCLUDE ...
	AS t
		LEFT JOIN ProviderRepository.dbo.ANCTaxonomyCrosswalk AS tc ON t.TaxonomyCode = tc.TaxonomyCode
WHERE 1=1
	AND t.SnapshotID IN (@SnapshotID)
	AND ( -- INITIATE ...
	ISNULL(t.TaxonomyCode,'') = ''
		OR tc.NUCCClassification LIKE '%Student%'
		OR  tc.NUCCSpecialization LIKE '%Student%'
		) -- CONCLUDE ...

-- INSERT INTO #Temp -- (FIELD(S) IN PLAY,...) 
SELECT DISTINCT t.SiteID
,t.eVIPSSiteID
,t.[Name]
,t.NPI
,t.GroupName
,t.AssignedTo
,t.[Address]
,t.LocationCode
,'SiteTaxonomy' AS 'ErrorColumn'
,'Missing OR Student Taxonomy: '+TRY_CONVERT(nvarchar(255),(LTRIM(RTRIM(ISNULL(tc.NUCCSpecialization,'')+' '+ISNULL(tc.NUCCClassification,''))))) AS 'ErrorText' -- C009: NPIs pending OR Missing Taxonomy update in NPI Registry. -Per email from MS SANDRA ON 20251031 SUBJECT:Symphony - NPIs pending Taxonomy update in NPI Registry
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st',s.FacilityType,s.InstitutionalFacilityType,s.LTCFacilityType
FROM 
( -- INITIATE ...
SELECT DISTINCT ' ' AS 'TAXONOMY, TAXID + DEA (LOCATION)'
,s.SnapshotID
,s.SiteID
,s.eVIPSSiteID
,s.eVIPSSiteID AS 'locationid'
,s.NPI
,s.TaxIDNumber
,s.DEANumber
,s.[Name]
,g.GroupName
,g.AssignedTo
,s.[Address] +', ' + ISNULL((s.[Address2] + ', ') , '') + s.[City] + ', ' + s.[State] + ' - ' + s.[ZipCode] AS [Address]
,LocationCode
,st.TaxonomyCode
FROM [ProviderRepository].dbo.[Sites] AS s 
	INNER JOIN [ProviderRepository].dbo.GroupSites AS gs ON gs.SiteID = s.SiteID
	INNER JOIN [ProviderRepository].dbo.Groups AS g ON g.GroupID = gs.GroupID	 
		LEFT JOIN [ProviderRepository].dbo.[SiteTaxonomy] AS st ON s.SiteID = st.SiteID
			AND NOT ISNULL(st.TaxonomyCode,'') = '' -- NO NOT NEGATIVE <> != ...
WHERE 1=1	
	AND ISNULL(s.TaxIDNumber,'') != '' -- REQ. FOR CCA SUBMISSION
	) -- CONCLUDE ...
	AS t
		LEFT JOIN ProviderRepository.dbo.ANCTaxonomyCrosswalk AS tc ON t.TaxonomyCode = tc.TaxonomyCode
WHERE 1=1
	AND t.SnapshotID IN (@SnapshotID)
	AND ( -- INITIATE ...
	ISNULL(t.TaxonomyCode,'') = ''
		OR tc.NUCCClassification LIKE '%Student%'
		OR  tc.NUCCSpecialization LIKE '%Student%'
		) -- CONCLUDE ...







-- ====================================================================
	-- SET PARAMETER(s) / FILTER(s) / ESTABLISH HDR tempdb(s)--
-- ====================================================================
DECLARE @snapshot AS int = (SELECT MAX([SnapshotID]) AS [SID] FROM [ProviderRepository].dbo.[Snapshot] WHERE LOB IN ('MEDICARE')) -- [OPTION(S)]: 'MEDICAL','CMC','MEDICARE ... CSNP & DSNP NETWORK IS IDENTICAL

		SELECT ' ' AS 'CSNP & DSNP NETWORK IS IDENTICAL',@snapshot AS 'PR snapshot in use',* 
		FROM [ProviderRepository].dbo.[Snapshot]
		WHERE 1=1 
			AND SnapshotID IN (SELECT MAX([SnapshotID]) AS [SID] FROM [ProviderRepository].dbo.[Snapshot] GROUP BY LOB)

SELECT 'Outpatient Beahvioral Health' AS [Specialty] -- QUPD ... taxfinal.Specialty
,'068' AS [Specialty Code] -- QUPD
--,SUBSTRING(UPPER(LTRIM(RTRIM(ISNULL(s.[ZipCode],'')))),1,5) AS [ZIP],s.* -- ALL COL()
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st',taxfinal.Specialty,taxfinal.taxonomyCode
FROM [ProviderRepository].dbo.[Sites] AS s
	JOIN [ProviderRepository].dbo.[SiteTaxonomy] AS st ON s.snapshotid = st.SnapshotID
		AND  s.SiteID = st.SiteID
		AND ISNULL(s.TaxIDNumber,'') != ''
	-- JOIN [ProviderRepository].dbo.GroupSites AS gs ON s.SiteID = gs.SiteID
		-- AND gs.[SnapshotID] = s.[SnapshotID]
	-- JOIN [ProviderRepository].dbo.Groups AS g ON gs.GroupID = g.GroupID
		-- AND g.[SnapshotID] = s.[SnapshotID]
	JOIN 
	( -- INITIATE ...
	SELECT taxranked.*
	FROM 
	( -- INITIATE ...
	SELECT tax.*
	,DENSE_RANK() OVER(PARTITION BY TaxonomyCode ORDER BY TRY_CONVERT(date,CrosswalkDate) DESC) AS [RANKis] -- RANK() ACCOUNT(s) FOR TIES + RETAINS SEQUENCE ... NO NEGATIVE NOT != <> GAPS IN THE SEQUENCE
	,ROW_NUMBER() OVER(PARTITION BY TaxonomyCode ORDER BY TRY_CONVERT(date,CrosswalkDate) DESC) AS [ROWis] -- STRAIGHT FORWARD SEQUENCE
	FROM 
	( -- INITIATE ...
	SELECT DISTINCT CASE
	WHEN ISNULL(tc.NUCCSpecialization,'Undefined') IN ('Undefined')
	THEN ISNULL(tc.NUCCClassification,'')
	ELSE LTRIM(RTRIM(ISNULL(tc.NUCCSpecialization,'')+' '+ISNULL(tc.NUCCClassification,'')))
	END AS 'Specialty'
	,TaxonomyCode COLLATE DATABASE_DEFAULT AS [TaxonomyCode]
	,DHCSNetCertGroup COLLATE DATABASE_DEFAULT AS [DHCSNetCertGroup]
	,DHCSNetCertCategory COLLATE DATABASE_DEFAULT AS [DHCSNetCertCategory]
	,NUCCClassification COLLATE DATABASE_DEFAULT AS [NUCCClassification]
	,NUCCSpecialization COLLATE DATABASE_DEFAULT AS [NUCCSpecialization]
	,TRY_CONVERT(nvarchar,CrosswalkDate) COLLATE DATABASE_DEFAULT AS [CrosswalkDate]
	-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
	-- SELECT DISTINCT ' ' AS 'CHECK 1st'
	FROM ProviderRepository.dbo.ANCTaxonomyCrosswalk AS tc
	WHERE 1=1
		AND (
                UPPER(LTRIM(RTRIM(ISNULL(tc.NUCCClassification, '')))) LIKE '%BEHAV%'
                OR UPPER(LTRIM(RTRIM(ISNULL(tc.NUCCSpecialization, '')))) LIKE '%BEHAV%'
                OR UPPER(LTRIM(RTRIM(ISNULL(tc.NUCCClassification, '')))) LIKE '%PSYCH%'
                OR UPPER(LTRIM(RTRIM(ISNULL(tc.NUCCSpecialization, '')))) LIKE '%PSYCH%'
                OR UPPER(LTRIM(RTRIM(ISNULL(tc.NUCCClassification, '')))) LIKE '%COUNSEL%'
                OR UPPER(LTRIM(RTRIM(ISNULL(tc.NUCCSpecialization, '')))) LIKE '%COUNSEL%'
				)
	) -- CONCLUDE ...
	AS tax
	) -- CONCLUDE ...
	AS taxranked
	WHERE 1=1
		--AND taxranked.RANKis = 1
		--AND taxranked.ROWis = 1
		) -- CONCLUDE 
		AS taxfinal ON ISNULL(st.TaxonomyCode,'') = ISNULL(taxfinal.TaxonomyCode,'') COLLATE DATABASE_DEFAULT
WHERE 1=1 
	AND s.[SnapshotID] = @snapshot
	
SELECT * 
FROM INFORMATICS.dbo.PROVDIR_ASC
WHERE 1=1
	AND [Participating Network] LIKE '%CCA%'
	
FROM #snapshot AS snap  -- SNAPSHOT ISO ...
	JOIN CHGAPP_PROD.dbo.tblEDIDHCSType274Provider AS p ON snap.SnapshotId = p.SnapshotId
	JOIN CHGAPP_PROD.dbo.tblEDIDHCSType274Site AS s ON p.SiteId = s.SiteId
		AND p.SnapshotId = s.SnapshotId
	JOIN CHGAPP_PROD.dbo.tblEDIDHCSType274ProviderSpecialization AS ps ON p.SnapshotId = ps.SnapshotId
		AND p.ProviderId = ps.ProviderId

	JOIN 
	( -- INITIATE ...
	SELECT taxranked.*
	FROM 
	( -- INITIATE ...
	SELECT tax.*
	,DENSE_RANK() OVER(PARTITION BY TaxonomyCode ORDER BY TRY_CONVERT(date,CrosswalkDate) DESC) AS [RANKis] -- RANK() ACCOUNT(s) FOR TIES + RETAINS SEQUENCE ... NO NEGATIVE NOT != <> GAPS IN THE SEQUENCE
	,ROW_NUMBER() OVER(PARTITION BY TaxonomyCode ORDER BY TRY_CONVERT(date,CrosswalkDate) DESC) AS [ROWis] -- STRAIGHT FORWARD SEQUENCE
	FROM 
	( -- INITIATE ...
	SELECT DISTINCT CASE
	WHEN ISNULL(tc.NUCCSpecialization,'Undefined') IN ('Undefined')
	THEN ISNULL(tc.NUCCClassification,'')
	ELSE LTRIM(RTRIM(ISNULL(tc.NUCCSpecialization,'')+' '+ISNULL(tc.NUCCClassification,'')))
	END AS 'Specialty'
	,TaxonomyCode COLLATE DATABASE_DEFAULT AS [TaxonomyCode]
	,DHCSNetCertGroup COLLATE DATABASE_DEFAULT AS [DHCSNetCertGroup]
	,DHCSNetCertCategory COLLATE DATABASE_DEFAULT AS [DHCSNetCertCategory]
	,NUCCClassification COLLATE DATABASE_DEFAULT AS [NUCCClassification]
	,NUCCSpecialization COLLATE DATABASE_DEFAULT AS [NUCCSpecialization]
	,TRY_CONVERT(nvarchar,CrosswalkDate) COLLATE DATABASE_DEFAULT AS [CrosswalkDate]
	-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
	-- SELECT DISTINCT ' ' AS 'CHECK 1st'
	FROM ProviderRepository.dbo.ANCTaxonomyCrosswalk AS tc
	) -- CONCLUDE ...
	AS tax
	) -- CONCLUDE ...
	AS taxranked
	WHERE 1=1
		AND taxranked.RANKis = 1
		AND taxranked.ROWis = 1
		) -- CONCLUDE 
		AS taxfinal ON ISNULL(sourcetable.Specialty,'') = ISNULL(taxfinal.TaxonomyCode,'') COLLATE DATABASE_DEFAULT

		LEFT JOIN 
		( -- INITIATE ...
			SELECT DISTINCT ' ' AS 'TAXONOMY, TAXID + DEA',p.ProviderID
			,p.DEANumber 
			,vpp.TaxIDNumber
			,pt.TaxonomyCode
			FROM [ProviderRepository].dbo.[Providers] AS p
					LEFT JOIN evips_chgcv.dbo.vwPractitionerProducts AS vpp On p.ProviderID = vpp.PractitionerID
						AND ISNULL(vpp.TaxIDNumber,'') != ''
					LEFT JOIN [ProviderRepository].dbo.[ProviderTaxonomy] AS pt ON p.ProviderID = pt.ProviderID
						AND NOT ISNULL(pt.TaxonomyCode,'') = '' -- NO NOT NEGATIVE <> != ...
				) -- CONCLUDE ...
				AS tax ON ta.eVipsProviderID = tax.ProviderID

				LEFT JOIN 
		( -- INITIATE ...
			SELECT DISTINCT ' ' AS 'TAXONOMY, TAXID + DEA',p.ProviderID
			,p.DEANumber 
			,vpp.TaxIDNumber
			,pt.TaxonomyCode
			FROM [ProviderRepository].dbo.[Providers] AS p
					LEFT JOIN evips_chgcv.dbo.vwPractitionerProducts AS vpp On p.ProviderID = vpp.PractitionerID
						AND ISNULL(vpp.TaxIDNumber,'') != ''
					LEFT JOIN [ProviderRepository].dbo.[ProviderTaxonomy] AS pt ON p.ProviderID = pt.ProviderID
						AND NOT ISNULL(pt.TaxonomyCode,'') = '' -- NO NOT NEGATIVE <> != ...
				) -- CONCLUDE ...
				AS tax ON ta.eVipsProviderID = tax.ProviderID

				LEFT JOIN 
		( -- INITIATE ...
		SELECT DISTINCT ' ' AS 'TAXONOMY, TAXID + DEA',p.ProviderID
		,p.DEANumber 
		,vpp.TaxIDNumber
		,pt.TaxonomyCode
		FROM [ProviderRepository].dbo.[Providers] AS p
				LEFT JOIN evips_chgcv.dbo.vwPractitionerProducts AS vpp On p.ProviderID = vpp.PractitionerID
					AND ISNULL(vpp.TaxIDNumber,'') != ''
				LEFT JOIN [ProviderRepository].dbo.[ProviderTaxonomy] AS pt ON p.ProviderID = pt.ProviderID
					AND NOT ISNULL(pt.TaxonomyCode,'') = '' -- NO NOT NEGATIVE <> != ...
				) -- CONCLUDE ...
				AS tax ON ta.eVipsProviderID = tax.ProviderID

		LEFT JOIN 
		( -- INITIATE ...
		SELECT DISTINCT ' ' AS 'TAXONOMY, TAXID + DEA',p.ProviderID
		,p.DEANumber 
		,vpp.TaxIDNumber
		,pt.TaxonomyCode
		FROM [ProviderRepository].dbo.[Providers] AS p
				LEFT JOIN evips_chgcv.dbo.vwPractitionerProducts AS vpp On p.ProviderID = vpp.PractitionerID
					AND ISNULL(vpp.TaxIDNumber,'') != ''
				LEFT JOIN [ProviderRepository].dbo.[ProviderTaxonomy] AS pt ON p.ProviderID = pt.ProviderID
					AND NOT ISNULL(pt.TaxonomyCode,'') = '' -- NO NOT NEGATIVE <> != ...
				) -- CONCLUDE ...
				AS tax ON ta.eVipsProviderID = tax.ProviderID

		LEFT JOIN 
		( -- INITIATE ...
		SELECT DISTINCT ' ' AS 'TAXONOMY, TAXID + DEA',p.ProviderID
		,p.DEANumber 
		,vpp.TaxIDNumber
		,pt.TaxonomyCode
		FROM [ProviderRepository].dbo.[Providers] AS p
				LEFT JOIN evips_chgcv.dbo.vwPractitionerProducts AS vpp On p.ProviderID = vpp.PractitionerID
					AND ISNULL(vpp.TaxIDNumber,'') != ''
				LEFT JOIN [ProviderRepository].dbo.[ProviderTaxonomy] AS pt ON p.ProviderID = pt.ProviderID
					AND NOT ISNULL(pt.TaxonomyCode,'') = '' -- NO NOT NEGATIVE <> != ...
				) -- CONCLUDE ...
				AS tax ON ta.eVipsProviderID = tax.ProviderID

		LEFT JOIN 
		( -- INITIATE ...
			SELECT DISTINCT ' ' AS 'TAXONOMY, TAXID + DEA',p.ProviderID
			,p.DEANumber 
			,vpp.TaxIDNumber
			,pt.TaxonomyCode
			FROM [ProviderRepository].dbo.[Providers] AS p
					LEFT JOIN evips_chgcv.dbo.vwPractitionerProducts AS vpp On p.ProviderID = vpp.PractitionerID
						AND ISNULL(vpp.TaxIDNumber,'') != ''
					LEFT JOIN [ProviderRepository].dbo.[ProviderTaxonomy] AS pt ON p.ProviderID = pt.ProviderID
						AND NOT ISNULL(pt.TaxonomyCode,'') = '' -- NO NOT NEGATIVE <> != ...
				) -- CONCLUDE ...
				AS tax ON ta.eVipsProviderID = tax.ProviderID

	JOIN 
	( -- INITIATE ...
	SELECT DISTINCT s.eVIPSSiteID
	,s.TaxIDNumber
	,s.DEANumber
	,st.*
	FROM [ProviderRepository].dbo.[Sites] AS s
		JOIN [ProviderRepository].dbo.[SiteTaxonomy] AS st ON s.snapshotid = st.SnapshotID
			AND  s.SiteID = st.SiteID
			) -- CONCLUDE ...
			AS tax ON ta.[SID] = tax.SnapshotID
				AND ta.eVIPSSiteID = tax.eVIPSSiteID
				AND ISNULL(tax.TaxIDNumber,'') != ''

	JOIN 
	( -- INITIATE ...
	SELECT DISTINCT s.eVIPSSiteID
	,s.TaxIDNumber
	,s.DEANumber
	,st.*
	FROM [ProviderRepository].dbo.[Sites] AS s
		JOIN [ProviderRepository].dbo.[SiteTaxonomy] AS st ON s.snapshotid = st.SnapshotID
			AND  s.SiteID = st.SiteID
			) -- CONCLUDE ...
			AS tax ON ta.[SID] = tax.SnapshotID
				AND ta.eVIPSSiteID = tax.eVIPSSiteID
				AND ISNULL(tax.TaxIDNumber,'') != ''

		LEFT JOIN 
		( -- INITIATE ...
		SELECT DISTINCT s.eVIPSSiteID
		,s.TaxIDNumber
		,s.DEANumber
		,st.*
		FROM [ProviderRepository].dbo.[Sites] AS s
			JOIN [ProviderRepository].dbo.[SiteTaxonomy] AS st ON s.snapshotid = st.SnapshotID
				AND  s.SiteID = st.SiteID
				) -- CONCLUDE ...
				AS tax ON ta.[SID] = tax.SnapshotID
					AND ta.eVIPSSiteID = tax.eVIPSSiteID
					AND ISNULL(tax.TaxIDNumber,'') != ''

				LEFT JOIN 
				( -- INITIATE ...
				SELECT DISTINCT TaxonomyCode COLLATE DATABASE_DEFAULT AS [TaxonomyCode],DHCSNetCertGroup COLLATE DATABASE_DEFAULT AS [DHCSNetCertGroup],DHCSNetCertCategory COLLATE DATABASE_DEFAULT AS [DHCSNetCertCategory],NUCCClassification COLLATE DATABASE_DEFAULT AS [NUCCClassification],NUCCSpecialization COLLATE DATABASE_DEFAULT AS [NUCCSpecialization],TRY_CONVERT(nvarchar,CrosswalkDate) COLLATE DATABASE_DEFAULT AS [CrosswalkDate]
				-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
				-- SELECT DISTINCT ' ' AS 'CHECK 1st'
				FROM ProviderRepository.dbo.ANCTaxonomyCrosswalk AS tc
				) -- CONCLUDE ...
				AS tax ON ISNULL(pd.Specialty,'') = ISNULL(tax.[TaxonomyCode],'')

				LEFT JOIN 
				( -- INITIATE ...
				SELECT DISTINCT TaxonomyCode COLLATE DATABASE_DEFAULT AS [TaxonomyCode],DHCSNetCertGroup COLLATE DATABASE_DEFAULT AS [DHCSNetCertGroup],DHCSNetCertCategory COLLATE DATABASE_DEFAULT AS [DHCSNetCertCategory],NUCCClassification COLLATE DATABASE_DEFAULT AS [NUCCClassification],NUCCSpecialization COLLATE DATABASE_DEFAULT AS [NUCCSpecialization],TRY_CONVERT(nvarchar,CrosswalkDate) COLLATE DATABASE_DEFAULT AS [CrosswalkDate]
				-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
				-- SELECT DISTINCT ' ' AS 'CHECK 1st'
				FROM ProviderRepository.dbo.ANCTaxonomyCrosswalk AS tc
				) -- CONCLUDE ...
				AS tax ON ISNULL(pd.Specialty,'') = ISNULL(tax.[TaxonomyCode],'')

		/* SELECT ' ' AS 'QA NULL SPECIALTY / SITE SERVICE TYPE: '
		 ,CASE 
		WHEN ISNULL(tax.NUCCSpecialization,'Undefined') IN ('Undefined')
			AND ISNULL(Prov_type,'') IN ('P')
		THEN 'PHYSICIAN' -- (P): MD/DO with NUCC taxonomy starting with '20'
		WHEN ISNULL(tax.NUCCSpecialization,'Undefined') IN ('Undefined')
			AND ISNULL(Prov_type,'') IN ('D')
		THEN 'DENTAL PROVIDER'  -- (D): DDS with NUCC taxonomy starting with '12'
		WHEN ISNULL(tax.NUCCSpecialization,'Undefined') IN ('Undefined')
			AND ISNULL(Prov_type,'') IN ('PE')
		THEN 'PCP EXTENDER' -- (PE): Nurse Practitioners and Physician Assistants
		WHEN ISNULL(tax.NUCCSpecialization,'Undefined') IN ('Undefined')
			AND ISNULL(Prov_type,'') IN ('H')
		THEN 'HOSPITAL' -- (H): Hospital facilities with NUCC taxonomy starting with '28'
		WHEN ISNULL(tax.NUCCSpecialization,'Undefined') IN ('Undefined')
			AND ISNULL(Prov_type,'') IN ('C')
		THEN 'COMMUNITY CLINIC' -- (C): Organized outpatient facilities (<24 hour stays)
		WHEN ISNULL(tax.NUCCSpecialization,'Undefined') IN ('Undefined')
			AND ISNULL(Prov_type,'') IN ('OF')
		THEN 'OTHER FACILITY' -- (OF): Non-individual facility providers (Pharmacies, Labs, etc.)
		WHEN ISNULL(tax.NUCCSpecialization,'Undefined') IN ('Undefined')
			AND ISNULL(Prov_type,'') IN ('OI')
		THEN 'OTHER INDIVIDUAL PROVIDER'
		ELSE ISNULL(tax.NUCCSpecialization,'')+' '+ISNULL(tax.NUCCClassification,'')
		END AS 'Speciality Category'
		,Prov_type,*
		FROM INFORMATICS.dbo.CCA_PROVIDER_DIRECTORY_ONLINE_TEMPLATE AS pd
				LEFT JOIN 
				( -- INITIATE ...
				SELECT DISTINCT TaxonomyCode COLLATE DATABASE_DEFAULT AS [TaxonomyCode],DHCSNetCertGroup COLLATE DATABASE_DEFAULT AS [DHCSNetCertGroup],DHCSNetCertCategory COLLATE DATABASE_DEFAULT AS [DHCSNetCertCategory],NUCCClassification COLLATE DATABASE_DEFAULT AS [NUCCClassification],NUCCSpecialization COLLATE DATABASE_DEFAULT AS [NUCCSpecialization],TRY_CONVERT(nvarchar,CrosswalkDate) COLLATE DATABASE_DEFAULT AS [CrosswalkDate]
				-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
				-- SELECT DISTINCT ' ' AS 'CHECK 1st'
				FROM ProviderRepository.dbo.ANCTaxonomyCrosswalk AS tc
				) -- CONCLUDE ...
				AS tax ON ISNULL(pd.Specialty,'') = ISNULL(tax.[TaxonomyCode],'')
		WHERE 1=1
			AND ISNULL(pd.Specialty,'') = '' --  IS NULL */

		SELECT ' ' AS 'TAXONOMY COUNT(): '
		,CASE 
		WHEN ISNULL(tax.NUCCSpecialization,'Undefined') IN ('Undefined')
			AND ISNULL(Prov_type,'') IN ('P')
		THEN 'PHYSICIAN' -- (P): MD/DO with NUCC taxonomy starting with '20'
		WHEN ISNULL(tax.NUCCSpecialization,'Undefined') IN ('Undefined')
			AND ISNULL(Prov_type,'') IN ('D')
		THEN 'DENTAL PROVIDER'  -- (D): DDS with NUCC taxonomy starting with '12'
		WHEN ISNULL(tax.NUCCSpecialization,'Undefined') IN ('Undefined')
			AND ISNULL(Prov_type,'') IN ('PE')
		THEN 'PCP EXTENDER' -- (PE): Nurse Practitioners and Physician Assistants
		WHEN ISNULL(tax.NUCCSpecialization,'Undefined') IN ('Undefined')
			AND ISNULL(Prov_type,'') IN ('H')
		THEN 'HOSPITAL' -- (H): Hospital facilities with NUCC taxonomy starting with '28'
		WHEN ISNULL(tax.NUCCSpecialization,'Undefined') IN ('Undefined')
			AND ISNULL(Prov_type,'') IN ('C')
		THEN 'COMMUNITY CLINIC' -- (C): Organized outpatient facilities (<24 hour stays)
		WHEN ISNULL(tax.NUCCSpecialization,'Undefined') IN ('Undefined')
			AND ISNULL(Prov_type,'') IN ('OF')
		THEN 'OTHER FACILITY' -- (OF): Non-individual facility providers (Pharmacies, Labs, etc.)
		WHEN ISNULL(tax.NUCCSpecialization,'Undefined') IN ('Undefined')
			AND ISNULL(Prov_type,'') IN ('OI')
		THEN 'OTHER INDIVIDUAL PROVIDER'
		ELSE ISNULL(tax.NUCCSpecialization,'')+' '+ISNULL(tax.NUCCClassification,'')
		END AS 'Speciality Category'
		,COUNT(DISTINCT(NPI)) AS 'Unique Provider Count' -- tax.*,pd.*
		FROM INFORMATICS.dbo.CCA_PROVIDER_DIRECTORY_ONLINE_TEMPLATE AS pd
				LEFT JOIN 
				( -- INITIATE ...
				SELECT DISTINCT TaxonomyCode COLLATE DATABASE_DEFAULT AS [TaxonomyCode],DHCSNetCertGroup COLLATE DATABASE_DEFAULT AS [DHCSNetCertGroup],DHCSNetCertCategory COLLATE DATABASE_DEFAULT AS [DHCSNetCertCategory],NUCCClassification COLLATE DATABASE_DEFAULT AS [NUCCClassification],NUCCSpecialization COLLATE DATABASE_DEFAULT AS [NUCCSpecialization],TRY_CONVERT(nvarchar,CrosswalkDate) COLLATE DATABASE_DEFAULT AS [CrosswalkDate]
				-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
				-- SELECT DISTINCT ' ' AS 'CHECK 1st'
				FROM ProviderRepository.dbo.ANCTaxonomyCrosswalk AS tc
				) -- CONCLUDE ...
				AS tax ON ISNULL(pd.Specialty,'') = ISNULL(tax.[TaxonomyCode],'')
		GROUP BY CASE 
		WHEN ISNULL(tax.NUCCSpecialization,'Undefined') IN ('Undefined')
			AND ISNULL(Prov_type,'') IN ('P')
		THEN 'PHYSICIAN' -- (P): MD/DO with NUCC taxonomy starting with '20'
		WHEN ISNULL(tax.NUCCSpecialization,'Undefined') IN ('Undefined')
			AND ISNULL(Prov_type,'') IN ('D')
		THEN 'DENTAL PROVIDER'  -- (D): DDS with NUCC taxonomy starting with '12'
		WHEN ISNULL(tax.NUCCSpecialization,'Undefined') IN ('Undefined')
			AND ISNULL(Prov_type,'') IN ('PE')
		THEN 'PCP EXTENDER' -- (PE): Nurse Practitioners and Physician Assistants
		WHEN ISNULL(tax.NUCCSpecialization,'Undefined') IN ('Undefined')
			AND ISNULL(Prov_type,'') IN ('H')
		THEN 'HOSPITAL' -- (H): Hospital facilities with NUCC taxonomy starting with '28'
		WHEN ISNULL(tax.NUCCSpecialization,'Undefined') IN ('Undefined')
			AND ISNULL(Prov_type,'') IN ('C')
		THEN 'COMMUNITY CLINIC' -- (C): Organized outpatient facilities (<24 hour stays)
		WHEN ISNULL(tax.NUCCSpecialization,'Undefined') IN ('Undefined')
			AND ISNULL(Prov_type,'') IN ('OF')
		THEN 'OTHER FACILITY' -- (OF): Non-individual facility providers (Pharmacies, Labs, etc.)
		WHEN ISNULL(tax.NUCCSpecialization,'Undefined') IN ('Undefined')
			AND ISNULL(Prov_type,'') IN ('OI')
		THEN 'OTHER INDIVIDUAL PROVIDER'
		ELSE ISNULL(tax.NUCCSpecialization,'')+' '+ISNULL(tax.NUCCClassification,'')
		END
