-- ======================================================================
	-- [Cx] / [COS] CATEGORY OF SERVICE ASSIGNMENT -- 
-- ======================================================================
UPDATE TABLENAME -- 1ST FIRST, RESET REFRESH RESTART ALL ...
SET Cx = TRY_CONVERT(nvarchar(255),NULL) 

		-- SELECT TOP 10 * FROM INFORMATICS.dbo.[uvw_CLAIMS_BILLTYPE];
		-- SELECT TOP 10 * FROM INFORMATICS.dbo.[uvw_CLAIMS_CLMTYPE]; -- FACILTY OR PROFESSIONAL ... 
		-- SELECT TOP 10 * FROM INFORMATICS.dbo.[uvw_CLAIMS_PAID]; -- SETTLE THE PAID CLAIMS ARGUMENT ...
		-- SELECT TOP 10 * FROM INFORMATICS.dbo.[uvw_AUTHREFCLAIM] -- 'Claude.ai v Perplexity.ai ...  'c.referralid OR cd.referralid = ref.authorizationid DISCOVERED ON 20150728 w Stefan Glembocki' 

-- ======================================================================
	-- POS, BILL TYPE(S), Dx, PROC + REV -- 
-- ======================================================================
--------------------------------------------------------------------------------------------------------------------
	--Error Trapping: Check If Permanent Table(s) Already Exist(s) And Drop If Applicable--
--------------------------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS #POS -- SQL Server 2016 and later -- DYNAMIC tmp OR STATIC [TABLE] #TableName is a local temporary table visible only IN the current session; ##TableName is a GLOBAL temporary table visible to all sessions IN ('TempDB')

SELECT ' ' AS 'PLACE OF SERVICE (POS)',*
-- INTO #POS
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM HMOPROD_PLANDATA.dbo.hcfaposlocation AS pos (NOLOCK)
WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ...
	-- AND pos.DESCRIPTION LIKE '%TELE%'
	AND pos.locationcode IN ('41','42','95') -- TRANSPORTATION
	
		SELECT * FROM #POS

SELECT 'BILL TYPE' AS [CodeType],*
FROM INFORMATICS.dbo.[uvw_CLAIMS_BILLTYPE] AS sbt 
WHERE 1=1
	AND sbt.QNXTbilltype LIKE '2[1-2]%'

		LEFT JOIN 
		( -- INITIATE ...
		SELECT ' ' AS 'POS (PLACE OF SERVICE)',*
		-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
		-- SELECT DISTINCT ' ' AS 'CHECK 1st',
		FROM HMOPROD_PLANDATA.dbo.hcfaposlocation
		) -- CONCLUDE ...
		AS posdescr ON UPPER(LTRIM(RTRIM(ISNULL(cd.location,'')))) = posdescr.locationcode

SELECT 'Dx - DIAGNOSIS' AS [CodeType],ISNULL(dc.description,'') AS [CodeDescr]
,dc.*
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st',
FROM HMOPROD_PLANDATA.dbo.DiagCode AS dc 
WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ... AND ...
	AND dc.codeid IN ('F22','F23','F24','F28','F29','F32.3','F33.3','F70','F71','F72','F73','F78','F78.A1','F78.A9','F79','F80.0','F80.1','F80.2','F80.4','F80.81','F80.82','F80.89','F80.9','F81.0','F81.2','F81.81','F81.89','F81.9','F82','F84','F84.0','F84.0','F84.0','F84.2','F84.2','F84.3','F84.3','F84.3','F84.5','F84.5','F84.8','F84.8','F84.8','F84.9','F84.9','F84.9','F88','F89','F90.0','F90.1','F90.2','F90.8','F90.9','F91.0','F91.1','F91.2','F91.3','F91.8','F91.9','F93.0','F93.8','F93.9','F94.0','F94.1','F94.2','F94.8','F94.9','F95.0','F95.0','F95.1','F95.1','F95.2','F95.2','F95.8','F95.8','F95.9','F95.9','F98.0','F98.1','F98.21','F98.29','F98.3','F98.4','F98.5','F98.8','F98.9','F99','Q90','Q90.0','Q90.1','Q90.2','Q90.9','Q91.0','Q91.1','Q91.2','Q91.3','Q91.4','Q91.5','Q91.6','Q91.7','Q92','Q93','Q93.0','Q93.1','Q93.2','Q93.3','Q93.4','Q93.5','Q93.51','Q93.59','Q93.7','Q93.8','Q93.81','Q93.82','Q93.88','Q93.89','Q93.9','Q99.2') -- Children and youth (younger than 21 yrs of age) who have a diagnosis of I/DD Use the following ICD-10 diagnosis codes: Lookback period 12 months
	-- AND dc.codeid >= 'F8'
	-- AND dc.codeid < 'F9'
	-- AND dc.codeid LIKE 'E08%'
		-- OR dc.codeid LIKE 'E09%'

 SELECT 'CPT - PROCEDURE_CODE + SERVICE CATEGORY(-ies)' AS [CodeType],ISNULL(sc.description,'') AS [CodeDescr]
 ,UPPER(LTRIM(RTRIM(scg.description)))+' - '+UPPER(LTRIM(RTRIM(scat.description)))+': '+UPPER(LTRIM(RTRIM(ssc.description))) AS ServiceCatDescr
,scg.catid
,scg.subcatid
,scg.svcgroupid
,sc.*
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st',UPPER(LTRIM(RTRIM(scg.description)))+' - '+UPPER(LTRIM(RTRIM(scat.description)))+': '+UPPER(LTRIM(RTRIM(ssc.description))) AS ServiceCatDescr
FROM HMOPROD_PLANDATA.dbo.svccode AS sc 
	LEFT JOIN HMOPROD_PLANDATA.dbo.svccatgroup AS scg ON sc.codeid = scg.codeid
	LEFT JOIN HMOPROD_PLANDATA.dbo.svccategory AS scat ON scg.catid = scat.catid
	LEFT JOIN HMOPROD_PLANDATA.dbo.svcsubcategory AS ssc ON scg.catid = ssc.catid
		AND scg.subcatid = ssc.subcatid
WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ... AND ...
	AND SUBSTRING(UPPER(LTRIM(RTRIM(ISNULL(sc.codeid,'')))),1,5) IN ('99408','99409','G0396','G0397','G0443','H0001','H0005','H0007','H0015','H0016','H0022','H0047','H0050','H2035','H2036','T1006','T1012','H0006','H0028') -- 'SMI' =  Serious Mental Illness 'SUD' = Substance Use Disorder ... AS [CPT Service Code] 

		 -- SELECT DISTINCT description FROM HMOPROD_PLANDATA.dbo.svccatgroup ORDER BY description
		 -- SELECT DISTINCT description FROM HMOPROD_PLANDATA.dbo.svccategory ORDER BY description
		 -- SELECT DISTINCT description FROM HMOPROD_PLANDATA.dbo.svcsubcategory ORDER BY description

SELECT 'REVENUE_CODE' AS [CodeType],ISNULL(rc.description,'') AS [CodeDescr],rc.*
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st',
FROM HMOPROD_PLANDATA.dbo.revcode AS rc 
WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ... AND ...
	AND rc.description LIKE '%ICF%'
		OR rc.codeid IN ('0199','0022','0169') -- SAMPLE: DHCS SUBACUTE SURVEY
	AND rc.codeid IN ('0258' -- ⏎ 'TPN AND SUPPLIES' = TPN (Total Parenteral Nutrition) refers to a medical method of providing nutrition that bypasses the digestive system. It is delivered directly into the bloodstream through an intravenous (IV) line, typically into a large vein like the superior vena cava.
	,'0022') -- ⏎ 'PDPM' = PATIENT DRIVEN PAYMENT MODEL

	/* AND CASE
	WHEN SUBSTRING(LTRIM(RTRIM(ISNULL(rc.codeid,''))),1,1) = 'Z'
	THEN  LTRIM(RTRIM(rc.codeid))
	WHEN SUBSTRING(LTRIM(RTRIM(ISNULL(rc.codeid,''))),1,1) = '0'
	THEN  SUBSTRING(LTRIM(RTRIM(ISNULL(rc.codeid,''))),2,3)
	ELSE LTRIM(RTRIM(ISNULL(rc.codeid,'')))
	END BETWEEN '450' AND '459'

		OR CASE
		WHEN SUBSTRING(LTRIM(RTRIM(ISNULL(rc.codeid,''))),1,1) = 'Z'
		THEN  LTRIM(RTRIM(rc.codeid))
		WHEN SUBSTRING(LTRIM(RTRIM(ISNULL(rc.codeid,''))),1,1) = '0'
		THEN  SUBSTRING(LTRIM(RTRIM(ISNULL(rc.codeid,''))),2,3)
		ELSE LTRIM(RTRIM(ISNULL(rc.codeid,'')))
		END IN ('022') */







-- =====================================================================
	-- QUPD [PROCEDURE_1_CODE] --
-- =====================================================================
SELECT 'Births 12 months gift basket adhoc WITH() P1 ([PROCEDURE_1_CODE]) CODE(S)' AS [CodeType],*
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM HMOPROD_PLANDATA.dbo.proccode AS pc (NOLOCK)
WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ... AND ...
	AND pc.pcode IN ('10E0XZZ','10D00Z0','10D00Z1','10D00Z2')

/* UPDATE TABLENAME
SET PROCEDURE_1_CODE = pcode
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM TABLENAME AS su
	JOIN HMOPROD_PLANDATA.dbo.claimproc AS cp ON su.claimid = cp.claimid
WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ... AND ...
	AND ISNULL(cp.proctype,'') = 'Primary'
	AND su.claimline = '1' */







-- ==========================================================================
	-- APR (All Patient Refined) Diagnosis DRG (Diagnosis Related Groups) --
-- ==========================================================================
SELECT ' ' AS 'APR - DRG: ',dc.*
-- ,cg.groupdescription
-- dc.description
,CASE 
WHEN ISNULL(cdrg.SeverityOfIllness,'') != '' -- NO NOT NEGATIVE <> != ... SOI
THEN RTRIM(cdrg.finaldrg)+'-'+RTRIM(cdrg.SeverityOfIllness)
ELSE RTRIM(cdrg.finaldrg)
END AS [finalDRG+SOI]
,cdrg.subdrg
,cdrg.moddrg
,cdrg.finaldrg
,cdrg.SeverityOfIllness -- 1.	For select specialty’s proposed rate of “$460 per session per day for Dialysis (MS-DRG codes 800-809)”, is one claim the equivalent of “one session per day”? ... *
FROM HMOPROD_PLANDATA.dbo.claimdrg AS cdrg -- C001: ADD claimdrg 'MS-DRG (Medicare Severity Diagnosis Related Groups) CODES' TO DETAIL AS OF 20240523
	JOIN HMOPROD_PLANDATA.dbo.drgcode AS dc ON cdrg.finaldrg = dc.codeid 
		LEFT JOIN HMOPROD_PLANDATA.dbo.codegrouperdrg AS cgd ON cdrg.finaldrg = cgd.codeid
		LEFT JOIN HMOPROD_PLANDATA.dbo.codegrouper AS cg ON cgd.groupid = cg.groupid
WHERE 1=1
	-- AND ISNULL(cdrg.SeverityOfIllness,'') != '' -- IS NOT NULL -- ISOLATES FOR APR DRG OR ???
	AND 
	( -- INITIATE ...
	CASE 
	WHEN ISNULL(cdrg.SeverityOfIllness,'') != '' -- NO NOT NEGATIVE <> != 
	THEN RTRIM(cdrg.finaldrg)+'-'+RTRIM(cdrg.SeverityOfIllness)
	ELSE cdrg.finaldrg
	END LIKE '440%[1-4]'
		OR cdrg.finaldrg IN ('650','651','652')
		OR CASE 
		WHEN ISNULL(cdrg.SeverityOfIllness,'') != '' -- NO NOT NEGATIVE <> != 
		THEN RTRIM(cdrg.finaldrg)+'-'+RTRIM(cdrg.SeverityOfIllness)
		ELSE cdrg.finaldrg
		END LIKE '008%[1-4]'
		) -- CONCLUDE ...
ORDER BY cdrg.finaldrg

		SELECT ' ' AS 'APR - DRG Descr.: ',dc.*
		,cgd.groupid AS 'codegrouperdrg'
		,cg.groupdescription AS 'codegrouper'
		FROM HMOPROD_PLANDATA.dbo.drgcode AS dc 
				LEFT JOIN HMOPROD_PLANDATA.dbo.codegrouperdrg AS cgd ON dc.codeid = cgd.codeid
				LEFT JOIN HMOPROD_PLANDATA.dbo.codegrouper AS cg ON cgd.groupid = cg.groupid
		WHERE 1=1
			AND dc.codeid LIKE '440'
				OR dc.codeid IN ('650','651','652','008')
		ORDER BY dc.codeid

		SELECT ' ' AS 'APR - DRG groupid.: ',* 
		FROM HMOPROD_PLANDATA.dbo.drggroup AS dg

		SELECT ' ' AS 'APR - DRG Grouper ',* 
		FROM HMOPROD_PLANDATA.dbo.codegrouperdrg AS cgd 
		WHERE 1=1
			AND cgd.codeid LIKE '%440%'
				OR cgd.codeid IN ('650','651','652','008')

		SELECT ' ' AS 'APR - DRG Grouper ',* 
		FROM HMOPROD_PLANDATA.dbo.codegrouper AS cg

		SELECT TOP 10 ' ' AS 'CLAIM(S) drg DETAIL SAMPLE: ',*
		FROM HMOPROD_PLANDATA.dbo.claimdrg AS cdrg
		
		SELECT ' ' AS 'MS-DRG (Medicare Severity Diagnosis Related Groups) CODES'
		,CASE 
		WHEN ISNULL(cdrg.SeverityOfIllness,'') != '' -- NO NOT NEGATIVE <> != ... SOI
		THEN RTRIM(cdrg.finaldrg)+'-'+RTRIM(cdrg.SeverityOfIllness)
		ELSE RTRIM(cdrg.finaldrg)
		END AS [finalDRG+SOI]
		,cdrg.subdrg,cdrg.moddrg,cdrg.finaldrg,c.drg,cdrg.* -- 1.	For select specialty’s proposed rate of “$460 per session per day for Dialysis (MS-DRG codes 800-809)”, is one claim the equivalent of “one session per day”? 
		-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
		-- SELECT DISTINCT ' ' AS 'CHECK 1st',
		FROM HMOPROD_PLANDATA.dbo.claim AS c
			JOIN HMOPROD_PLANDATA.dbo.claimdrg AS cdrg ON c.claimid = cdrg.claimid
		WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ... AND ...
			AND cdrg.finaldrg BETWEEN 800 AND 809 -- 1.	For select specialty’s proposed rate of “$460 per session per day for Dialysis (MS-DRG codes 800-809)”, is one claim the equivalent of “one session per day”?		







-- ===============================================================================
	-- ENSURE ONE 1 CLAIM ONE 1 ASSIGNMENT --
-- ===============================================================================
,CASE 
WHEN MAX(CASE WHEN cd.revcode IN ('0199', '0190') THEN 1 ELSE 0 END) = 1 -- ENSURE each claimid is assigned TO ONLY ONE 1 [LOC] Level of Care designation
THEN 'Subacute Trach/Vent'
ELSE 'Other'
END AS [LOC]

WHERE 1=1
	AND claimid IN -- The ENTIRE claim LIKE '%RDT%' 
		( -- INITIATE ...
		SELECT DISTINCT claimid
		FROM INFORMATICS.dbo.CXOLTC
		WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ... AND ...
			AND QNXTbilltype LIKE '2[1-3]%' -- LTRIM(RTRIM(clm.facilitycode))+LTRIM(RTRIM(clm.billclasscode))+LTRIM(RTRIM(clm.frequencycode)
			AND PROVID NOT IN ('22','911') 
		) -- CONCLUDE ...





	

-- =======================================================================
	-- MCR BID Milliman HOSPICE -- 
-- =======================================================================
		LEFT JOIN 
		( -- INITIATE ...
		SELECT DISTINCT ' ' AS 'HOSPICE ASSIGNMENT'
		,mcf.memid
		,TRY_CONVERT(date,ISNULL(mcf.EffDate,GETDATE()) AS EffDate
		,TRY_CONVERT(date,ISNULL(mcf.TermDate,GETDATE()) AS TermDate
		,'Y' AS [Hospice Indicator]
		-- ,mcf.*
		FROM HMOPROD_PLANDATA.dbo.membercmsfactor AS mcf (NOLOCK) -- PREFERRED METHOD PER SIR ADAM ON TEAMS AS OF 20250220 '... hi Walter  Tatsani said you were asking about using member condition vs member factor for the HOSP flag  both tables are driven by the same stored procedure, which processes the DTRR (daily transaction reply report)   so it is expected that the HOSP flag and condition will only apply to Medicare members  but both tables are populated at the same time by the same procedure so they should be equal  I would suggest using the membercmsfactor table though, because that table is clearly reserved for Medicare members ...'
 		WHERE 1=1
			AND ISNULL(mcf.termdate,GETDATE())>= mcf.effdate -- MUST BE TRUE ... NON-CROSSFOOTED RECORDS ARE ACTIVE ... 
			AND mcf.factor = 'HOSP'
			-- AND mcf.memid IN (SELECT DISTINCT memid FROM HMOPROD_PLANDATA.dbo.claim WHERE 1=1 AND claimid IN ('24004E18060')) -- 'SAMPLE: membercmsfactor MEMBER' AS 'HOSPICE ASSIGNMENT'

		UNION 
		SELECT DISTINCT ' ' AS 'HOSPICE ASSIGNMENT'
		,mc.memid
		,TRY_CONVERT(date,ISNULL(mc.EffDate,GETDATE()) AS EffDate
		,TRY_CONVERT(date,ISNULL(mc.TermDate,GETDATE()) AS TermDate
		,'Y' AS [Hospice Indicator]
		-- ,mc.*
		FROM HMOPROD_PLANDATA.dbo.membercondition AS mc (NOLOCK)
			JOIN HMOPROD_PLANDATA.dbo.condition AS c (NOLOCK) ON mc.conditionid = c.conditionid
		WHERE 1=1
			AND ISNULL(mc.termdate,GETDATE())>= mc.effdate -- MUST BE TRUE ... NON-CROSSFOOTED RECORDS ARE ACTIVE ... 
			AND  c.description = 'hospice'
			-- AND mc.memid IN (SELECT DISTINCT memid FROM HMOPROD_PLANDATA.dbo.claim WHERE 1=1 AND claimid IN ('24004E18060')) -- 'SAMPLE: membercmsfactor MEMBER' AS 'HOSPICE ASSIGNMENT'
		) -- CONCLUDE ...
		AS hospice ON Cl.memid = hospice.memid
			AND TRY_CONVERT(date,Cl.startdate) BETWEEN hospice.EffDate AND hospice.TermDate -- by DOS







-- =======================================================================
	-- CONTRACTING PROPOSAL DEVELOPMENT ANALYSIS (WITH ZERO HANDLING) -- 
-- =======================================================================
SELECT 'CONTRACTING PROPOSAL DEVELOPMENT: ' AS [Scenario]
,claimid,claimline
,LINE_OF_BUSINESS
,LINE_OF_BUSINESS+' '+[Primary / Secondary Status] AS 'LOB'
,PAYTONM
,memid
,revcode
,[REVCDE Descr]
,[HCT LOGIC DAY(S)]
,QUANTITY
,BILLED_AMT
,ALLOWED_AMT
,NET_AMT
,PAID_NET_AMT AS 'Actual_Payment'
,CASE -- COS (Category of Service) assignment ... 
WHEN revcode IN ('0169','0190','0199') -- Administrative Days rates
THEN 'Administrative Days'
WHEN revcode BETWEEN '0191' AND '0194' -- IP Skilled Nursing rates
THEN 'IP Skilled Nursing'
WHEN revcode IN ('0170','0171','0179') -- Boarder Baby rates 
THEN 'Boarder Baby'
WHEN revcode BETWEEN '0330' AND '0339' -- Radiation Oncology rates (120% of Medi-Cal)
THEN 'Radiation Oncology'
WHEN revcode IN ('0275','0276','0278','0279') -- OP Implants at 50% of charges
THEN 'OP Implants'
ELSE 'Other OP Services' -- Other OP Services ...
END AS 'Contracting_Proposal_Category'
,NULLIF(PAID_NET_AMT,0) * 1.00 AS 'Current_Calc_Rate_Payment' -- ASSUME THAT WHAT HAS BEEN PAID IS WHATTHE CONTRACTING DEPT. HAS DOCUMENTED
,CASE 
WHEN revcode IN ('0169','0190','0199') -- Proposed Administrative Days rates    
THEN ISNULL(NULLIF([EQUIV_allow_compare],0),(NULLIF(PAID_NET_AMT,0) * 1.00))
WHEN revcode IN ('0191','0192','0193','0194') -- Proposed IP Skilled Nursing rates
THEN NULLIF([HCT LOGIC DAY(S)],0) * 705.00
 WHEN revcode IN ('0170','0171','0179') -- Proposed Boarder Baby rates 
THEN NULLIF([HCT LOGIC DAY(S)],0) * 705.00
WHEN revcode BETWEEN '0330' AND '0339' -- Proposed Radiation Oncology rates (120% of Medi-Cal)
THEN NULLIF(EQUIV_allow_compare,0) * 2.00
WHEN revcode IN ('0275','0276','0278','0279') -- Proposed OP Implants at 50% of charges
THEN NULLIF(BILLED_AMT,0) * 0.50
ELSE NULLIF(EQUIV_allow_compare,0) * 2.00 -- Proposed Other OP Services (assumed same as current)
END AS 'Proposed_Rate_Payment'
,CASE 
WHEN revcode IN ('0169','0190','0199') -- Administrative Days rates
THEN NULLIF(PAID_NET_AMT,0) * 1.00 * 1.05
WHEN revcode BETWEEN '0191' AND '0194' -- IP Skilled Nursing rates
THEN NULLIF([HCT LOGIC DAY(S)],0) * 525.00 * 1.05
WHEN revcode IN ('0170','0171','0179') -- Boarder Baby rates 
THEN NULLIF([HCT LOGIC DAY(S)],0) * 525.00 * 1.05
WHEN revcode BETWEEN '0330' AND '0339' -- Radiation Oncology rates (120% of Medi-Cal)
THEN NULLIF(EQUIV_allow_compare,0) * 1.20 * 1.05
WHEN revcode IN ('0275','0276','0278','0279') --  OP Implants at invoice cost + 2%
THEN NULLIF(PAID_NET_AMT,0) * 1.02 * 1.05
ELSE NULLIF(EQUIV_allow_compare,0) * 2.00 * 1.05 -- Other OP Services at 200% of Medi-Cal
END AS 'Counter_Offer_Payment'
INTO #ContractAnalysis
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM INFORMATICS.dbo.CONTRACTING_PALOMAR_HOSP
WHERE 1=1
	AND [ClaimCategory] IN ('Paid') -- PAID CLAIMS ONLY!!!
    AND LINE_OF_BUSINESS LIKE '%MEDI%CAL%'
	AND [Primary / Secondary Status] = 'P'

SELECT ' ' AS 'BOARDER BABY' 
FROM APR-DRG
,MIN(CASE 
WHEN cd.revcode IN ('0540', '0541', '0542', '0544', '0545', '0546', '0560','0112','0122','0132','0142','0152') 
	OR cdx.codeid = 'O80' 
	OR LEFT(cdx.codeid,3) IN ('Z37','Z38')  
	OR LEFT(cdx.codeid,5) IN ('O60.1', 'O60.2') 
THEN '1-OB'	
WHEN cd.revcode  = '0655' 
THEN '2-Hospice'	
WHEN cd.revcode IN ('0114','0124','0134','0144','0154','0204') 
THEN '3-Psychiatry'	
WHEN cd.revcode IN ('0179', '0171','0170')  -- Current Boarder Baby rates 
THEN '4-Boarder Baby' -- assignment of 4 is because of how the boarder baby claims were paid, if run again will need to research ... A boarder baby typically refers to an infant who is medically cleared for discharge from the hospital but remains in the hospital due to social or placement issues, often related to child protective services involvement or other social circumstances preventing immediate discharge to home care.
WHEN cd.revcode IN ('0100','0101','0110',/*'0112',*/'0113','0117','0118','0119','0120','0121',/*'0122',*/'0123','0127','0128','0129','0130','0131',/*'0132',*/'0133','0137','0138','0139','0140','0141',/*'0142',*/'0143','0147','0148','0149','0150','0151',/*'0152',*/'0153','0157','0158','0159','0160','0164','0167','0169','0170','0172','0173','0174','0200','0201','0202','0203','0206','0209','0210','0211','0212','0213','0219') 
THEN '4-Inpatient Services'	
ELSE NULL	
END) AS [cost_category]
WHERE 1=1

		•	"Boarder baby" = an infant who remains in the hospital after medical clearance ... he term comes from the fact that these infants are essentially "boarding" at the hospital after they are medically cleared for discharge. Like a boarder at a boarding house, they are occupying space but not receiving active medical treatment.







-- ===============================================================================
	-- [snapshotid] IN [ProviderRepository] + [274] --
-- ===============================================================================
DROP TABLE IF EXISTS #snapshot -- SQL Server 2016 and later -- DYNAMIC tmp OR STATIC [TABLE] #INFORMATICS.dbo.SHELLclaimlist_TOPDIAG is a local temporary table visible only IN the current session; ##INFORMATICS.dbo.SHELLclaimlist_TOPDIAG is a GLOBAL temporary table visible to all sessions IN ('TempDB')

SELECT ' ' AS '[ProviderRepository] - DSNP TRANSITION WITH() [LOBCode] v [HCPCode] AS OF 20230101 [SnapshotID] IN USE',*
INTO #snapshot
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st',
FROM 
( -- INITIATE ...
SELECT DENSE_RANK() OVER (PARTITION BY LOB ORDER BY snapshotid DESC,TRY_CONVERT(datetime,Createdate) DESC) AS [RANKis],* 
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st',
FROM [ProviderRepository].dbo.[Snapshot] -- IN SQLPRODAPP01
) -- CONCLUDE ...
AS ss
WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ... AND ...
	AND ss.RANKis BETWEEN 1 AND 3
	AND ss.SnapshotID IN 
	 ( -- INITIATE ...
	 SELECT MAX([SnapshotID]) AS 'SID' FROM [ProviderRepository].dbo.[Snapshot] /* WHERE LOB IN ('MEDICAL') */ GROUP BY LOB
	 ) -- CONCLUDE ...

		SELECT * FROM #snapshot

DROP TABLE IF EXISTS #snapshot -- SQL Server 2016 and later -- DYNAMIC tmp OR STATIC [TABLE] #INFORMATICS.dbo.SHELLclaimlist_TOPDIAG is a local temporary table visible only IN the current session; ##INFORMATICS.dbo.SHELLclaimlist_TOPDIAG is a GLOBAL temporary table visible to all sessions IN ('TempDB')

SELECT ' ' AS '[274] - EAE (Exclusively Aligned Enrollment) DSNP TRANSITION WITH() [LOBCode] v [HCPCode] AS OF 20230101 [SnapshotID] IN USE',*
INTO #snapshot 
FROM 
( -- INITIATE ...
SELECT DENSE_RANK() OVER (PARTITION BY LOBCode ORDER BY snapshotid DESC,TRY_CONVERT(datetime,CreatedDate) DESC) AS [RANKis],* 
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st',
FROM [CHGAPP_PROD].[dbo].[tblEDIDHCSType274Snapshot] -- IN SQLPROD02 OR SQLPROD01
) -- CONCLUDE ...
AS ss
WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ... AND ...
	AND ss.RANKis BETWEEN 1 AND 3
	AND SnapshotID IN 
	( -- INITIATE ...
	-- '418','450','451' -- ORIGINAL EAE RUN [snapshot]
	SELECT MAX([SnapshotID]) AS 'SID' FROM [CHGAPP_PROD].[dbo].[tblEDIDHCSType274Snapshot] GROUP BY LOBCode -- GROUP BY HCPCode -- CMC,DSNP,MCAL,TEST ...
	) -- CONCLUDE ...

		SELECT * FROM #snapshot







-- ===============================================================================
	-- ICF/DD = Intermediate Care Facility for Developmentally Disabled Transition RENDERING / PAYTO --
-- ===============================================================================
DROP TABLE IF EXISTS #ICF -- SQL Server 2016 and later -- DYNAMIC tmp OR STATIC [TABLE] #INFORMATICS.dbo.SHELLclaimlist_TOPDIAG is a local temporary table visible only IN the current session; ##INFORMATICS.dbo.SHELLclaimlist_TOPDIAG is a GLOBAL temporary table visible to all sessions IN ('TempDB')

SELECT DISTINCT ' ' AS 'IDENTIFY ICF/DD = Intermediate Care Facility for Developmentally Disabled Transition','see "FW  CHG LTC ICF DD Network Readiness Requirements and Network Readiness Template.msg" FROM SIR SALIM' AS [MESSAGE(S)],vls.LocationID,vls.LocationName,vls.PracticeID,vls.PracticeName,vls.ServiceTypeName,vls.ServiceTypeCode,vp.NationalProviderID -- ,vls.*,vp.*
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st',
INTO #ICF
FROM evips_chgcv.dbo.vwLocationServices AS vls
	LEFT JOIN evips_chgcv.dbo.vwPractices AS vp ON vls.PracticeId = vp.PracticeId
	
	LEFT JOIN
		 ( -- INITIATE ...
		SELECT DISTINCT ljvlp.ProductTypeCode,ljvlp.ProductTypeName,ljvlp.PracticeTypeName,ljvlp.PracticeID,ljvlp.LocationID,ljvlp.Archived,ljvlp.StatusTypeName,vlpstype.indirectory,vlpstype.ServiceTypeCode,vlpstype.ServiceTypeName,ljvlp.productname,ljvlp.ProductPanelStatusTypeName,ljvlp.ProductPanelStatusTypeCode,ljvlp.ProviderNumber,ljvlp.Focus,ljvlp.ProductID,ljvlp.LocationTypeName 
		FROM eVips_chgcv.dbo.vwLocationProducts AS ljvlp 
			JOIN evips_chgcv.dbo.vwLocationProductServices AS vlpstype ON ljvlp.LocationProductRecID = vlpstype.LocationProductRecID 
		WHERE ISNULL(ljvlp.Archived,'') IN ('N','') 
			AND (ISNULL(ljvlp.StatusTypeName,'') IN ('ACTIVE','') 
				OR ljvlp.StatusTypeName LIKE '%PARTICIP%')
			AND ISNULL(vlpstype.Archived,'') IN ('N','') 
			) -- CONCLUDE ...
			AS vlp ON vls.PracticeID = vlp.PracticeID --'YOUNG LADY LAURA GAH ID WHERE p.archived = 'N' AND s.ServiceTypeName = 'HOSPITAL' AND p.focus like '%GAH%'' ON 20171120 see ,UPPER(LTRIM(RTRIM(vlp.ServiceTypeName))) AS [vlpSERVICETYPENAME]
				AND vls.LocationID = vlp.LocationID -- per YOUNG LADY LAURA email ON 20171221 ... Products (CMC & MEDICAL)  are stored at Location Level. The code below is joining based only ON Practice ID. This should be based ON PracticeID + Location

WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ... AND ...
	AND UPPER(LTRIM(RTRIM(ISNULL(vlp.ServiceTypeName,'')))) LIKE '%INTERMEDIATE%CARE%FACILITIES%' -- PER DISCUSSION WITH() MS JOHANNA + MS SANDRA REGARDING ADDING ICF AS A PROVDIR_ICF CHAPTER ON 202402029
	-- AND UPPER(LTRIM(RTRIM(ISNULL(vp.NationalProviderID,''))))  IN ('1073736427','1831124890','1639392079','1336368984','1114124849','1053518779','1134342520','1417183831','1982839320','1922233469','1679708028','1699901017','1477789832','1972739399','1881820207','1164658589','1205061645','1659506012','1154557577','1922277698','1427284843','1063648483') -- ICF NPI(S) FROM SIR SALIM FILE see "COC_SURVEY_..."

		SELECT * FROM #ICF






-- ===============================================================================
	-- ICF/DD = Intermediate Care Facility for Developmentally Disabled Transition RENDERING / PAYTO --
-- ===============================================================================
SELECT DISTINCT ' ' AS 'ICF/DD = Intermediate Care Facility for Developmentally Disabled Transition: ',UPPER(LTRIM(RTRIM(ISNULL(pspe.spectype,'')))) AS [Specialty Status]
,UPPER(LTRIM(RTRIM(ISNULL(spe.specialtycode,'')))) AS SPECcode
,UPPER(LTRIM(RTRIM(ISNULL(spe.description,'')))) AS SPECdescr
,pspe.spectype
,prov.provid
,prov.fedid
,prov.NPI
,prov.ExternalID -- AS [SEQ_PROV_ID]
,PROVNM = UPPER(LTRIM(RTRIM(ISNULL(prov.fullname,'')))) -- PROVIDER NAME
,ent.enttype
,ent.lastname
,ent.firstname
,ent.middlename
,ent.entname
,PROVcode = UPPER(LTRIM(RTRIM(ISNULL(pt.provtype,'')))) -- PROVTYPE CODE
,PROVtype = UPPER(LTRIM(RTRIM(ISNULL(pt.[description],'')))) -- PROVTYPE Descr.
,PROVclass = UPPER(LTRIM(RTRIM(ISNULL(pt.provclass,'')))) -- PROVTYPE Classification
,PROVaddr1 = UPPER(LTRIM(RTRIM(ISNULL(ent.phyaddr1,''))))
,PROVaddr2 = UPPER(LTRIM(RTRIM(ISNULL(ent.phyaddr2,''))))
,PROVcity = UPPER(LTRIM(RTRIM(ISNULL(ent.phycity,''))))
,PROVstate = SUBSTRING(UPPER(LTRIM(RTRIM(ISNULL(ent.phystate,'')))),1,2)
,PROVcounty = UPPER(LTRIM(RTRIM(ISNULL(ent.phycounty,'')))) -- •	County, if Plan is multi-county
,PROVzip = CASE
WHEN SUBSTRING(LTRIM(RTRIM(ent.phyzip)),1,1) = '0'
THEN '0'+ SUBSTRING(LTRIM(RTRIM(ent.phyzip)),2,4)
WHEN SUBSTRING(LTRIM(RTRIM(ent.phyzip)),1,1) = '00'
THEN '00'+ SUBSTRING(LTRIM(RTRIM(ent.phyzip)),3,3)
ELSE  SUBSTRING(LTRIM(RTRIM(ent.phyzip)),1,5) 
END
,PROVphone = CASE
WHEN LTRIM(RTRIM(ent.phone)) = ''
THEN SUBSTRING(REPLACE(LTRIM(RTRIM(ent.emerphone)),'-',''),1,10)
ELSE SUBSTRING(REPLACE(LTRIM(RTRIM(ent.phone)),'-',''),1,10)
END
,PROVmobile = CASE
WHEN LTRIM(RTRIM(ent.mobilephone)) = ''
THEN SUBSTRING(REPLACE(LTRIM(RTRIM(ent.secphone)),'-',''),1,10)
ELSE SUBSTRING(REPLACE(LTRIM(RTRIM(ent.mobilephone)),'-',''),1,10)
END
,PROVemail = LTRIM(RTRIM(ent.email))
-- ,evips.REGION AS [PCP REGION]
-- INTO #PROVISOLATION
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM HMOPROD_PLANDATA.dbo.provider AS prov
	JOIN HMOPROD_PLANDATA.dbo.entity AS ent ON prov.entityid = ent.entid
		LEFT JOIN HMOPROD_PLANDATA.dbo.providertype AS pt ON prov.provtype = pt.provtype
		LEFT JOIN HMOPROD_PLANDATA.dbo.provspecialty AS pspe ON prov.provid = pspe.provid
		LEFT JOIN HMOPROD_PLANDATA.dbo.specialty AS spe ON pspe.specialtycode = spe.specialtycode
WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ... AND ...
	AND UPPER(LTRIM(RTRIM(ISNULL(prov.npi,''))))  IN ('1073736427','1831124890','1639392079','1336368984','1114124849','1053518779','1134342520','1417183831','1982839320','1922233469','1679708028','1699901017','1477789832','1972739399','1881820207','1164658589','1205061645','1659506012','1154557577','1922277698','1427284843','1063648483') -- ICF NPI(S)

		SELECT * FROM #PROVISOLATION







-- ==================================================================
	-- BASELINE SUBACUTE FACILITIES (SNFs) FOR EAE NETWORK --
-- ==================================================================
DROP TABLE IF EXISTS #SUBACUTEFAC -- SQL Server 2016 and later -- DYNAMIC tmp OR STATIC [TABLE] #INFORMATICS.dbo.SHELLclaimlist_TOPDIAG is a local temporary table visible only IN the current session; ##INFORMATICS.dbo.SHELLclaimlist_TOPDIAG is a GLOBAL temporary table visible to all sessions IN ('TempDB')

SELECT DISTINCT ' ' AS 'IDENTIFY SUBACUTE FACILITIES (SNFs) via eVips (Symplr)',vls.LocationID,vls.LocationName,vls.PracticeID,vls.PracticeName,vls.ServiceTypeName,vls.ServiceTypeCode,vp.NationalProviderID -- ,vls.*,vp.*
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st',
INTO #SUBACUTEFAC
FROM SQLPRODAPP01.evips_chgcv.dbo.vwLocationServices AS vls
	LEFT JOIN SQLPRODAPP01.evips_chgcv.dbo.vwPractices AS vp ON vls.PracticeId = vp.PracticeId
WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ... AND ...
	AND ServiceTypeName LIKE '%ACUTE%' -- LIKE '%SAFETY%PROV%'

		SELECT * FROM #SUBACUTEFAC
		
SELECT DISTINCT ' ' AS 'DHCS SURVEY SUBACUTE / SUB-ACUTE',c.memid,c.claimid
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st',
FROM HMOPROD_PlanData.dbo.claim AS c (NOLOCK)
	JOIN HMOPROD_PlanData.dbo.claimdetail AS cd (NOLOCK) ON c.claimid = cd.claimid
	--JOIN HMOPROD_PLANDATA.dbo.affiliation AS a ON c.affiliationid = a.affiliationid -- REMINDER: within claim(s) tables AFFILIATIONID is the relationship between the a.provid = PROVIDER AND the a.affiliateid = PAYTO aka VENDOR
	--	LEFT JOIN HMOPROD_PLANDATA.dbo.provider AS p1 ON a.provid = p1.provid -- [RENDERING]
	--	LEFT JOIN HMOPROD_PLANDATA.dbo.provider AS p2 ON a.affiliateid = p2.provid -- [PAYTO] (IPAID)
WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ... AND ...
	AND cd.revcode IN ('0199','0022','0169') -- SAMPLE: DHCS SUBACUTE SURVEY







-- =====================================================================
	-- COMMENT(S) / CHANGE.LOG: --
-- =====================================================================
-- C001:  … Admin days are days that we pay to the hospital for patients/members that have a barrier to discharge such as there is no SNF that will take the patient or they have no safe place to discharge to.  I assume they will be tracked by claims and that the data will be available as ADMIN DAYS. I do not know what codes are used to bill and pay claims, but Adrian Arce will know… *Per claims team - MS NATALIA DURING 20241231 CONTRACTING MEETING: Medi-Cal ADMIN DAYS rate for proposed is: $704.86 (100% of Medi-Cal)

		 /*  see the "Informational Admin Days NO CPT" tab as no CPT were present to arrive at a 100% of Medi-Cal proposal  
		 Per claims team: Medi-Cal admin days rate for proposed is: 704.86 (100% of Medi-Cal)  */
		 
JAH 'IP ADMIN DAYS' FOR DR CONRAD REPORT
WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ...
	AND c.formtype LIKE '%UB%'
    AND c.startdate <= @RangeEndDate
    AND ISNULL(c.enddate, GETDATE()) >= @RangeStartDate
    AND c.claimid IN (
        SELECT DISTINCT claimid
        FROM HMOPROD_PlanData.dbo.claimdetail
        WHERE revcode IN ('0169', '0190', '0191')
    )
    AND p1.provid != '7' -- C001: PARADISE VALLEY HOSPITAL EXCLUDED BY CMO DR CONRAD REQUEST

    AND p2.provid != '7' -- C001: PARADISE VALLEY HOSPITAL EXCLUDED BY CMO DR CONRAD REQUEST

-- =====================================================================
	-- DECLARE @PARAMETER(S) / @FILTER(S) --
-- =====================================================================
DECLARE @Start AS datetime -- = DATEADD(DAY,1,EOMONTH(TRY_CONVERT(date,GETDATE()),-13))
DECLARE @End AS datetime -- = EOMONTH(TRY_CONVERT(date,GETDATE()),-1)

SET @Start = DATEADD(DAY,1,EOMONTH(TRY_CONVERT(date,GETDATE()),-13))
SET @End= EOMONTH(TRY_CONVERT(date,GETDATE()),-1)

		SELECT ' ' AS 'REFERENCE "STEP88_ADMIT...sql"',COUNT(DISTINCT(calendar_date)) AS [TAT COUNT DISTINCT],COUNT(DISTINCT(calendar_date))-1 AS [TAT COUNT DISTINCT MINUS ONE (1)],DATEDIFF(day,@Start,@End) AS [TAT DATEDIFF DAYS],DATEDIFF(hour,@Start,@End) AS [TAT DATEDIFF HOUR(S)],'BETWEEN '+CONVERT(nvarchar(10),ISNULL(@Start,GETDATE()),101)+' AND '+CONVERT(nvarchar(10),ISNULL(@End,GETDATE()),101) AS [RANGE NOTE(S)]
		FROM INFORMATICS.dbo.date_calendarISO AS dc -- 50 YEAR CALENDAR [sp]
		WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ... AND ...
			AND dc.calendar_date BETWEEN @Start AND @End

--------------------------------------------------------------------------------------------------------------------
	-- Error Trapping: Check If Permanent Table(s) Already Exist(s) And Drop If Applicable --
--------------------------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS INFORMATICS.dbo.AdminDaysClaims; -- SQL Server 2016 and later -- DYNAMIC tmp OR STATIC [TABLE] #INFORMATICS.dbo.PIVOTHOSPIP is a local temporary table visible only IN the current session; ##INFORMATICS.dbo.PIVOTHOSPIP is a GLOBAL temporary table visible to all sessions IN ('TempDB')

SELECT DISTINCT ' ' AS 'Admin days / Barrier to discharge',c.memid,c.claimid,c.startdate,a.affiliateid
,CAST(UPPER(LTRIM(RTRIM(ISNULL(c.memid,'')))) AS varchar(255))+CAST(UPPER(LTRIM(RTRIM(ISNULL(TRY_CONVERT(date,c.startdate),'')))) AS varchar(10))+CAST(UPPER(LTRIM(RTRIM(ISNULL(a.provid,'')))) AS varchar(255)) AS [AdmitID] -- 'Unique person, date of service, and provider = one visit'  OR 'Unique person, date of service, and NDC = one script'
,a.provid -- [RENDERING] -- AFFILIATIONID is the relationship between the a.provid = PROVIDER AND the a.affiliateid = PAYTO aka VENDOR
,UPPER(LTRIM(RTRIM(ISNULL(p1.npi,'')))) AS [NPIprovnm],UPPER(LTRIM(RTRIM(ISNULL(p1.fullname,'')))) AS [RENDERINGPROVNM]
,a.affiliateid AS [PAYTO] -- [PAYTO] -- AFFILIATIONID is the relationship between the a.provid = PROVIDER AND the a.affiliateid = PAYTO aka VENDOR
,UPPER(LTRIM(RTRIM(ISNULL(p2.npi,'')))) AS [NPIpayto],UPPER(LTRIM(RTRIM(ISNULL(p2.fullname,'')))) AS [PAYTONM]
,SUM(CASE 
WHEN cd.revcode = '0169' 
THEN cd.servunits 
ELSE 0 
END) AS [admin_days]
,MAX(c.totalamt) AS [Total Claim Paid Amt]
,SUM(cd.amountpaid) AS [Detail Line Paid Amt]
INTO INFORMATICS.dbo.AdminDaysClaims
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st',billclasscode
FROM HMOPROD_PlanData.dbo.claim AS c (NOLOCK)
	JOIN HMOPROD_PlanData.dbo.claimdetail AS cd (NOLOCK) ON c.claimid = cd.claimid  
	JOIN HMOPROD_PlanData.dbo.affiliation AS a (NOLOCK) ON c.affiliationid = a.affiliationid 
		LEFT JOIN HMOPROD_PLANDATA.dbo.provider AS p1 ON a.provid = p1.provid -- [RENDERING]
		LEFT JOIN HMOPROD_PLANDATA.dbo.provider AS p2 ON a.affiliateid = p2.provid -- [PAYTO] (IPAID)
WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ... AND ...
	AND c.formtype LIKE '%UB%'
	AND TRY_CONVERT(date,c.startdate) <= @End -- WITHIN reporting period [RANGE] OPPOSITION 
	AND TRY_CONVERT(date,c.enddate) >= @Start -- WITHIN reporting period [RANGE] OPPOSITION

	AND 
	(
		c.resubclaimid IS NULL 
		OR 
		c.resubclaimid = ''
	)

	AND c.claimid NOT LIKE '%R%' -- NO NOT NEGATIVE != <>
	AND c.[status] IN ('ADJUCATED','PAID','PAY','REV','REVERSED','REVSYNCH') 
	AND cd.revcode IN ('0169')
GROUP BY c.memid,c.claimid,c.startdate,a.affiliateid,CAST(UPPER(LTRIM(RTRIM(ISNULL(c.memid,'')))) AS varchar(255))+CAST(UPPER(LTRIM(RTRIM(ISNULL(TRY_CONVERT(date,c.startdate),'')))) AS varchar(10))+CAST(UPPER(LTRIM(RTRIM(ISNULL(a.provid,'')))) AS varchar(255))
,a.provid,UPPER(LTRIM(RTRIM(ISNULL(p1.npi,'')))) ,UPPER(LTRIM(RTRIM(ISNULL(p1.fullname,''))))
,a.affiliateid,UPPER(LTRIM(RTRIM(ISNULL(p2.npi,'')))),UPPER(LTRIM(RTRIM(ISNULL(p2.fullname,''))))

			SELECT * FROM INFORMATICS.dbo.AdminDaysClaims







--------------------------------------------------------------------------------------------------------------------
	-- Error Trapping: Check If Permanent Table(s) Already Exist(s) And Drop If Applicable --
--------------------------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS #CXOLTC -- SQL Server 2016 and later -- DYNAMIC tmp OR STATIC [TABLE] #INFORMATICS.dbo.REINSURANCE_IP is a local temporary table visible only IN the current session; ##INFORMATICS.dbo.REINSURANCE_IP is a GLOBAL temporary table visible to all sessions IN ('TempDB')

SELECT DISTINCT ' ' AS 'CXO LTC / SNF',c.memid,c.claimid,c.startdate,a.affiliateid
,CAST(UPPER(LTRIM(RTRIM(ISNULL(c.memid,'')))) AS varchar(255))+CAST(UPPER(LTRIM(RTRIM(ISNULL(TRY_CONVERT(date,c.startdate),'')))) AS varchar(10))+CAST(UPPER(LTRIM(RTRIM(ISNULL(a.provid,'')))) AS varchar(255)) AS [AdmitID] -- 'Unique person, date of service, and provider = one visit'  OR 'Unique person, date of service, and NDC = one script'
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st',
-- INTO #CXOLTC
FROM HMOPROD_PlanData.dbo.claim AS c (NOLOCK)
	JOIN HMOPROD_PlanData.dbo.claimdetail AS cd (NOLOCK) ON c.claimid = cd.claimid
	JOIN HMOPROD_PLANDATA.dbo.affiliation AS a ON c.affiliationid = a.affiliationid -- REMINDER: within claim(s) tables AFFILIATIONID is the relationship between the a.provid = PROVIDER AND the a.affiliateid = PAYTO aka VENDOR
		LEFT JOIN HMOPROD_PLANDATA.dbo.provider AS p1 ON a.provid = p1.provid -- [RENDERING]
		LEFT JOIN HMOPROD_PLANDATA.dbo.provider AS p2 ON a.affiliateid = p2.provid -- [PAYTO] (IPAID)
WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ... AND ...
	AND TRY_CONVERT(date,c.startdate) <= @End -- WITHIN reporting period [RANGE] OPPOSITION 
	AND TRY_CONVERT(date,c.enddate) >= @Start -- WITHIN reporting period [RANGE] OPPOSITION

	AND 
	( -- INITIATE...
		c.resubclaimid IS NULL 
		OR 
		c.resubclaimid = ''
	) -- CONCLUDE ...

	AND c.claimid NOT LIKE '%R%' -- NO NOT NEGATIVE != <>
	AND c.[status] IN ('ADJUCATED','PAID','PAY','REV','REVERSED','REVSYNCH') 
	AND 
	( -- INITIATE ...
	cd.revcode IN ('0101', '0190') -- LTC CPT codes (see authservice.codeid AND authservice.servcategory) ALSO STEP88-MEMBER_CONDITIONs...sql
		OR cd.revcode IN ('0120','0110','0130') -- LTC
		OR cd.revcode BETWEEN '0180' AND '0189' -- LTC
	) -- CONCLUDE ...
	AND c.formtype LIKE '%UB%' -- FACILITY

UNION 
SELECT DISTINCT ' ' AS 'CXO LTC / SNF',c.memid,c.claimid,c.startdate,a.affiliateid
,CAST(UPPER(LTRIM(RTRIM(ISNULL(c.memid,'')))) AS varchar(255))+CAST(UPPER(LTRIM(RTRIM(ISNULL(TRY_CONVERT(date,c.startdate),'')))) AS varchar(10))+CAST(UPPER(LTRIM(RTRIM(ISNULL(a.provid,'')))) AS varchar(255)) AS [AdmitID] -- 'Unique person, date of service, and provider = one visit'  OR 'Unique person, date of service, and NDC = one script'
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st',
FROM HMOPROD_PlanData.dbo.claim AS c (NOLOCK)
	JOIN HMOPROD_PlanData.dbo.claimdetail AS cd (NOLOCK) ON c.claimid = cd.claimid
	JOIN HMOPROD_PLANDATA.dbo.affiliation AS a ON c.affiliationid = a.affiliationid -- REMINDER: within claim(s) tables AFFILIATIONID is the relationship between the a.provid = PROVIDER AND the a.affiliateid = PAYTO aka VENDOR
	JOIN HMOPROD_PLANDATA.dbo.provider AS p1 ON a.provid = p1.provid -- [RENDERING]
	JOIN HMOPROD_PLANDATA.dbo.provider AS p2 ON a.affiliateid = p2.provid -- [PAYTO] (IPAID)
WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ... AND ...
	AND TRY_CONVERT(date,c.startdate) <= @End -- WITHIN reporting period [RANGE] OPPOSITION 
	AND TRY_CONVERT(date,c.enddate) >= @Start -- WITHIN reporting period [RANGE] OPPOSITION
	AND 
	( -- INITIATE...
		c.resubclaimid IS NULL 
		OR 
		c.resubclaimid = ''
	) -- CONCLUDE ...
	AND c.claimid NOT LIKE '%R%' -- NO NOT NEGATIVE != <>
	AND c.[status] IN ('ADJUCATED','PAID','PAY','REV','REVERSED','REVSYNCH') 
	AND a.provid IN ('22','911') -- [RENDERING]

UNION 
SELECT DISTINCT ' ' AS 'CXO LTC / SNF',c.memid,c.claimid,c.startdate,a.affiliateid
,CAST(UPPER(LTRIM(RTRIM(ISNULL(c.memid,'')))) AS varchar(255))+CAST(UPPER(LTRIM(RTRIM(ISNULL(TRY_CONVERT(date,c.startdate),'')))) AS varchar(10))+CAST(UPPER(LTRIM(RTRIM(ISNULL(a.provid,'')))) AS varchar(255)) AS [AdmitID] -- 'Unique person, date of service, and provider = one visit'  OR 'Unique person, date of service, and NDC = one script'
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st',
FROM HMOPROD_PlanData.dbo.claim AS c (NOLOCK)
	JOIN HMOPROD_PlanData.dbo.claimdetail AS cd (NOLOCK) ON c.claimid = cd.claimid
	JOIN HMOPROD_PLANDATA.dbo.affiliation AS a ON c.affiliationid = a.affiliationid -- REMINDER: within claim(s) tables AFFILIATIONID is the relationship between the a.provid = PROVIDER AND the a.affiliateid = PAYTO aka VENDOR
	JOIN HMOPROD_PLANDATA.dbo.provider AS p1 ON a.provid = p1.provid -- [RENDERING]
	JOIN HMOPROD_PLANDATA.dbo.provider AS p2 ON a.affiliateid = p2.provid -- [PAYTO] (IPAID)
WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ... AND ...
	AND TRY_CONVERT(date,c.startdate) <= @End -- WITHIN reporting period [RANGE] OPPOSITION 
	AND TRY_CONVERT(date,c.enddate) >= @Start -- WITHIN reporting period [RANGE] OPPOSITION
	AND 
	( -- INITIATE...
		c.resubclaimid IS NULL 
		OR 
		c.resubclaimid = ''
	) -- CONCLUDE ...
	AND c.claimid NOT LIKE '%R%' -- NO NOT NEGATIVE != <>
	AND c.[status] IN ('ADJUCATED','PAID','PAY','REV','REVERSED','REVSYNCH') 
	AND a.affiliateid IN ('22','911') -- [PAYTO] (IPAID)

UNION 
SELECT DISTINCT ' ' AS 'CXO LTC / SNF',c.memid,c.claimid,c.startdate,a.affiliateid
,CAST(UPPER(LTRIM(RTRIM(ISNULL(c.memid,'')))) AS varchar(255))+CAST(UPPER(LTRIM(RTRIM(ISNULL(TRY_CONVERT(date,c.startdate),'')))) AS varchar(10))+CAST(UPPER(LTRIM(RTRIM(ISNULL(a.provid,'')))) AS varchar(255)) AS [AdmitID] -- 'Unique person, date of service, and provider = one visit'  OR 'Unique person, date of service, and NDC = one script'
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st',
FROM HMOPROD_PlanData.dbo.claim AS c (NOLOCK)
	JOIN HMOPROD_PlanData.dbo.claimdetail AS cd (NOLOCK) ON c.claimid = cd.claimid
	JOIN HMOPROD_PLANDATA.dbo.affiliation AS a ON c.affiliationid = a.affiliationid -- REMINDER: within claim(s) tables AFFILIATIONID is the relationship between the a.provid = PROVIDER AND the a.affiliateid = PAYTO aka VENDOR
		LEFT JOIN HMOPROD_PLANDATA.dbo.provider AS p1 ON a.provid = p1.provid -- [RENDERING]
		LEFT JOIN HMOPROD_PLANDATA.dbo.provider AS p2 ON a.affiliateid = p2.provid -- [PAYTO] (IPAID)
WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ... AND ...
	AND TRY_CONVERT(date,c.startdate) <= @End -- WITHIN reporting period [RANGE] OPPOSITION 
	AND TRY_CONVERT(date,c.enddate) >= @Start -- WITHIN reporting period [RANGE] OPPOSITION
	AND 
	( -- INITIATE...
		c.resubclaimid IS NULL 
		OR 
		c.resubclaimid = ''
	) -- CONCLUDE ...
	AND c.claimid NOT LIKE '%R%' -- NO NOT NEGATIVE != <>
	AND c.[status] IN ('ADJUCATED','PAID','PAY','REV','REVERSED','REVSYNCH') 
	AND 
	( -- INITIATE ...
	cd.revcode IN ('0022') -- SNF (SKILLED NURSING FACILITY PROSPECTIVE PAYMENT SYSTEM.)
		OR cd.revcode BETWEEN '0191' AND '0193' -- SNF
	) -- CONCLUDE ...
	AND c.formtype LIKE '%UB%' -- FACILITY

UNION 
SELECT DISTINCT ' ' AS 'CXO LTC / SNF',c.memid,c.claimid,c.startdate,a.affiliateid
,CAST(UPPER(LTRIM(RTRIM(ISNULL(c.memid,'')))) AS varchar(255))+CAST(UPPER(LTRIM(RTRIM(ISNULL(TRY_CONVERT(date,c.startdate),'')))) AS varchar(10))+CAST(UPPER(LTRIM(RTRIM(ISNULL(a.provid,'')))) AS varchar(255)) AS [AdmitID] -- 'Unique person, date of service, and provider = one visit'  OR 'Unique person, date of service, and NDC = one script'
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st',
FROM HMOPROD_PlanData.dbo.claim AS c (NOLOCK)
	JOIN HMOPROD_PlanData.dbo.claimdetail AS cd (NOLOCK) ON c.claimid = cd.claimid  
	JOIN HMOPROD_PLANDATA.dbo.affiliation AS a ON c.affiliationid = a.affiliationid -- REMINDER: within claim(s) tables AFFILIATIONID is the relationship between the a.provid = PROVIDER AND the a.affiliateid = PAYTO aka VENDOR
		LEFT JOIN HMOPROD_PLANDATA.dbo.provider AS p1 ON a.provid = p1.provid -- [RENDERING]
		LEFT JOIN HMOPROD_PLANDATA.dbo.provider AS p2 ON a.affiliateid = p2.provid -- [PAYTO] (IPAID)
WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ... AND ...
	AND TRY_CONVERT(date,c.startdate) <= @End -- WITHIN reporting period [RANGE] OPPOSITION 
	AND TRY_CONVERT(date,c.enddate) >= @Start -- WITHIN reporting period [RANGE] OPPOSITION
	AND 
	( -- INITIATE...
		c.resubclaimid IS NULL 
		OR 
		c.resubclaimid = ''
	) -- CONCLUDE ...
	AND c.claimid NOT LIKE '%R%' -- NO NOT NEGATIVE != <>
	AND c.[status] IN ('ADJUCATED','PAID','PAY','REV','REVERSED','REVSYNCH') 
	AND c.facilitycode = '2'  
	AND c.billclasscode IN ('1','2','3') -- SNF ... Per discussion with Ms. Nora & Ms. Cristina ON 20160622
	AND c.formtype LIKE '%UB%' -- FACILITY

UNION
SELECT DISTINCT ' ' AS 'CXO LTC / SNF',c.memid,c.claimid,c.startdate,a.affiliateid
,CAST(UPPER(LTRIM(RTRIM(ISNULL(c.memid,'')))) AS varchar(255))+CAST(UPPER(LTRIM(RTRIM(ISNULL(TRY_CONVERT(date,c.startdate),'')))) AS varchar(10))+CAST(UPPER(LTRIM(RTRIM(ISNULL(a.provid,'')))) AS varchar(255)) AS [AdmitID] -- 'Unique person, date of service, and provider = one visit'  OR 'Unique person, date of service, and NDC = one script'
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st',
FROM HMOPROD_PlanData.dbo.claim AS c (NOLOCK)
	JOIN HMOPROD_PlanData.dbo.claimdetail AS cd (NOLOCK) ON c.claimid = cd.claimid
	JOIN HMOPROD_PLANDATA.dbo.affiliation AS a ON c.affiliationid = a.affiliationid -- REMINDER: within claim(s) tables AFFILIATIONID is the relationship between the a.provid = PROVIDER AND the a.affiliateid = PAYTO aka VENDOR
	JOIN HMOPROD_PLANDATA.dbo.provider AS p1 ON a.provid = p1.provid -- [RENDERING]
	JOIN HMOPROD_PLANDATA.dbo.provider AS p2 ON a.affiliateid = p2.provid -- [PAYTO] (IPAID)
	JOIN HMOPROD_PLANDATA.dbo.providertype AS pt ON p1.provtype = pt.provtype -- ON [RENDERING]
	JOIN HMOPROD_PLANDATA.dbo.provspecialty AS pspe ON p1.provid = pspe.provid -- ON [RENDERING]
	JOIN HMOPROD_PLANDATA.dbo.specialty AS spec ON pspe.specialtycode = spec.specialtycode
WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ... AND ...
	AND TRY_CONVERT(date,c.startdate) <= @End -- WITHIN reporting period [RANGE] OPPOSITION 
	AND TRY_CONVERT(date,c.enddate) >= @Start -- WITHIN reporting period [RANGE] OPPOSITION
	AND 
	( -- INITIATE...
		c.resubclaimid IS NULL 
		OR 
		c.resubclaimid = ''
	) -- CONCLUDE ...
	AND c.claimid NOT LIKE '%R%' -- NO NOT NEGATIVE != <>
	AND c.[status] IN ('ADJUCATED','PAID','PAY','REV','REVERSED','REVSYNCH') 
	AND spec.specialtycode IN ('LTACH') -- ADD ON per RDT CCI DISCUSSION / email FROM MS. NIKKITA see SUBJECT: RDT CCI Cx UPDATE(s) - RE: Discuss CCI RDT ON 20180503 AND see ''COS Updates_'...xlsx	
	AND c.formtype LIKE '%UB%' -- FACILITY

/* WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ... AND ...

		AND
(
c.facilitycode = '2'
and c.billclasscode IN ('1','2','3')
)
or cdet.revcode between '0191' and '0193'
or cdet.revcode = '0022'
or c.provid IN ('22','911')

case 
when c.provid IN ('22','911') THEN '1-LTAC' 
when cdet.revcode = '0022' THEN '2-SNF'
ELSE '3-LTC' end cost_category, */

/* WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ... AND ...
	AND QNXTbilltype LIKE '2[1-3]%' 	
	AND (c.facilitycode = '2'
	AND c.billclasscode IN ('1','2','3'))
		OR cdet.revcode BETWEEN '0191' AND '0193'
		OR cdet.revcode = '0022'
		OR provid IN ('156799','2571','911','22')
	AND revcode IN ('0100','0101','0127','0157','0159','0160','0164','0167','0169','0219')
	AND  revcode BETWEEN '0191' AND '0193' -- LTAC
			OR revcode BETWEEN '0110' AND '0113'
			OR revcode BETWEEN '0117' AND '0123'
			OR revcode BETWEEN '0127' AND '0133'
			OR revcode BETWEEN '0137' AND '0143'
			OR revcode BETWEEN '0147' AND '0153'
			OR revcode BETWEEN '0200' AND '0203'
			OR revcode BETWEEN '0206' AND '0207'
			OR revcode BETWEEN '0213' AND '0214' */

-- ======================================================================
	-- [Cx] / [COS] CATEGORY OF SERVICE ASSIGNMENT FOR CXO LTC (Long-Term Care) --
-- ======================================================================
UPDATE INFORMATICS.dbo.CXOLTC
SET Cx = TRY_CONVERT(nvarchar(255),NULL) -- RESET

UPDATE INFORMATICS.dbo.CXOLTC
SET Cx = 'LTC' -- HCT LIKE '%%%'
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st',
FROM INFORMATICS.dbo.CXOLTC
WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ... AND ...
	AND claimid IN -- The ENTIRE claim LIKE '%RDT%' 
	( -- INITIATE ...
	SELECT DISTINCT claimid
	FROM INFORMATICS.dbo.CXOLTC
	WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ... AND ...
		AND QNXTbilltype LIKE '2[1-3]%' -- LTRIM(RTRIM(clm.facilitycode))+LTRIM(RTRIM(clm.billclasscode))+LTRIM(RTRIM(clm.frequencycode)
		AND PROVID NOT IN ('22','911') 
	) -- CONCLUDE ...

UPDATE INFORMATICS.dbo.CXOLTC
SET Cx = 'LTC' -- HCT LIKE '%%%'
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st',
FROM INFORMATICS.dbo.CXOLTC
WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ... AND ...
	AND claimid IN -- The ENTIRE claim LIKE '%RDT%' 
	( -- INITIATE ...
	SELECT DISTINCT claimid
	FROM INFORMATICS.dbo.CXOLTC
	WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ... AND ...
		AND  
		( 
		revcode BETWEEN '0191' AND '0193'
			OR revcode IN ('0022')
		) 
	) -- CONCLUDE ...

UPDATE TABLENAME
SET Cx = 'Long-Term Care' 
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st',
FROM INFORMATICS.dbo.PIVOTHOSPIP AS su
WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ... AND ...
	AND ( -- INITIATE ...
	su.Cx IS NULL
	AND 
	( -- INITIATE ...
	LTRIM(RTRIM(revcode)) IN ('101', '190') --Ltc CPT codes (see authservice.codeid AND authservice.servcategory) ALSO STEP88-MEMBER_CONDITIONs...sql
		OR LTRIM(RTRIM(revcode)) IN ('120','110','130') --LTC
		OR LTRIM(RTRIM(revcode)) BETWEEN  '180' AND '189' --LTC
		) -- CONCLUDE ...
	AND su.ClmType = 'FACILITY' --claim.formtype LIKE '%UB%' INCLM = FACILITY
	) -- CONCLUDE ...
	OR 
	( -- INITIATE ...
	1=1 -- FOR ... Building dynamic WHERE conditions ...
	AND su.Cx IS NULL
	AND su.SEQ_CLAIM_ID IN (SELECT DISTINCT sup.SEQ_CLAIM_ID -- The ENTIRE claim
	FROM INFORMATICS.dbo.PIVOTHOSPIP AS sup
	WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ... AND ...
		AND LTRIM(RTRIM(sup.PROVID)) IN ('22','911')
			OR LTRIM(RTRIM(sup.PAYTO)) IN ('22','911'))
	) -- CONCLUDE ...
	OR 
	( -- INITIATE ...
	1=1 -- FOR ... Building dynamic WHERE conditions ...
		AND su.Cx IS NULL --'NF (Nursing Facility)' --SNF (Skilled Nursing Facility) see 'Core 9.2 
		AND 
		( -- INITIATE ...
		LTRIM(RTRIM(QNXTbilltype)) LIKE '21%' --SNF
			OR LTRIM(RTRIM(QNXTbilltype)) LIKE '22%' --SNF
			OR LTRIM(RTRIM(revcode)) BETWEEN  '191' AND '193' --SNF
			OR LTRIM(RTRIM(QNXTbilltype)) LIKE '23%' --Per discussion with Ms. Nora & Ms. Cristina ON 20160622
			OR LTRIM(RTRIM(revcode)) IN ('022') --SNF (SKILLED NURSING FACILITY PROSPECTIVE PAYMENT SYSTEM.)
			) -- CONCLUDE ...
		AND ClmType = 'FACILITY' --claim.formtype LIKE '%UB%' INCLM = FACILITY)
		) -- CONCLUDE ...

	/* OR 
	( -- INITIATE ...
	1=1 -- FOR ... Building dynamic WHERE conditions ...
		AND su.Cx IS NULL
		AND UPPER(LTRIM(RTRIM(ISNULL(PROVSPEC,'')))) IN ('LTACH') -- ADD ON per RDT CCI DISCUSSION / email FROM MS. NIKKITA see SUBJECT: RDT CCI Cx UPDATE(s) - RE: Discuss CCI RDT ON 20180503 AND see ''COS Updates_'...xlsx	
	) -- CONCLUDE ... */







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
SELECT DISTINCT ' ' AS 'see "CGM..."',TRY_CONVERT(date,LEFT(edi.TestDate,8)) AS [LabTestDate]
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







-- ======================================================================
	-- ECM COS (CATEGORY OF SERVICE) -- 
-- ======================================================================
--------------------------------------------------------------------------------------------------------------------
	-- Error Trapping: Check If Permanent Table(s) Already Exist(s) And Drop If Applicable --
--------------------------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS #PPPClaims; -- SQL Server 2016 and later -- DYNAMIC tmp OR STATIC [TABLE] #TableName is a local temporary table visible only IN the current session; ##TableName is a GLOBAL temporary table visible to all sessions IN ('TempDB')

SELECT DISTINCT ' ' AS 'PREGNANCY + POSTPARTUM',c.memid,c.claimid,c.startdate,cdx.codeid,cdx.[diag descr],'DIAG' AS [code type]
,CAST(UPPER(LTRIM(RTRIM(ISNULL(c.memid,'')))) AS varchar(255))+CAST(UPPER(LTRIM(RTRIM(ISNULL(TRY_CONVERT(date,c.startdate),'')))) AS varchar(10))+CAST(UPPER(LTRIM(RTRIM(ISNULL(a.provid,'')))) AS varchar(255)) AS [AdmitID] -- 'Unique person, date of service, and provider = one visit' OR 'Unique person, date of service, and NDC = one script'
INTO #PPPClaims
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st',
FROM HMOPROD_PlanData.dbo.claim AS c (NOLOCK)
	JOIN HMOPROD_PlanData.dbo.claimdetail AS cd (NOLOCK) ON c.claimid = cd.claimid  
	JOIN HMOPROD_PlanData.dbo.affiliation AS a (NOLOCK) ON c.affiliationid = a.affiliationid
	JOIN INFORMATICS.dbo.[uvw_CLAIMS_PAID] AS paid ON c.claimid = paid.claimid	
	JOIN 
	( -- INITIATE ...
	SELECT DISTINCT *
	-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
	-- SELECT DISTINCT ' ' AS 'CHECK 1st',
	FROM 
	( -- INITIATE ...
	SELECT aliassetup.*,DENSE_RANK() OVER (PARTITION BY aliassetup.claimid ORDER BY aliassetup.sequence ASC,aliassetup.codeid DESC) AS [RANKis]
	-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
	-- SELECT DISTINCT ' ' AS 'CHECK 1st',
	FROM 
	( -- INITIATE ...
	SELECT DISTINCT dx.claimid,dx.codeid,UPPER(LTRIM(RTRIM(ISNULL(dx.codeid,'')))) AS [diag],ISNULL(dc.DESCRIPTION,'') AS [diag descr],dx.sequence,dx.poa AS [PRESENT ON ADMISSION]
	-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
	-- SELECT DISTINCT ' ' AS 'CHECK 1st',
	FROM HMOPROD_PLANDATA.dbo.claimdiag AS dx
		LEFT JOIN HMOPROD_PLANDATA.dbo.DiagCode AS dc ON dx.codeid = dc.codeid
	) -- CONCLUDE
	AS aliassetup
	) -- CONCLUDE
	AS alias
	-- WHERE alias.sequence = 1 -- BETWEEN 1 AND 9	
		-- AND alias.[RANKis] = 1
WHERE alias.diag BETWEEN 'O00.00' AND 'O99.891'
	OR alias.diag BETWEEN 'O9A.111' AND 'O9A.519'
	OR alias.diag BETWEEN 'Z03.71' AND 'Z03.79'
	OR alias.diag IN ('Z32.01')
	OR alias.diag BETWEEN 'Z33.1' AND 'Z33.3'
	OR alias.diag BETWEEN 'Z34.00' AND 'Z34.93'
	OR alias.diag BETWEEN 'Z36.0' AND 'Z36.9'
	OR alias.diag IN ('Z36.8A')
	OR alias.diag BETWEEN 'Z39.1' AND 'Z39.2'
	) -- CONCLUDE ...
	AS cdx ON c.claimid = cdx.claimid
WHERE TRY_CONVERT(date,c.startdate) <= @End -- WITHIN reporting period [RANGE] OPPOSITION  
	AND TRY_CONVERT(date,ISNULL(c.enddate,GETDATE())) >= @Start -- WITHIN reporting period [RANGE] OPPOSITION 
	
UNION 
SELECT DISTINCT ' ' AS 'PREGNANCY + POSTPARTUM',c.memid,c.claimid,c.startdate,sc.codeid,ISNULL(sc.description,'') AS [code descr],'CPT' AS [code type]
,CAST(UPPER(LTRIM(RTRIM(ISNULL(c.memid,'')))) AS varchar(255))+CAST(UPPER(LTRIM(RTRIM(ISNULL(TRY_CONVERT(date,c.startdate),'')))) AS varchar(10))+CAST(UPPER(LTRIM(RTRIM(ISNULL(a.provid,'')))) AS varchar(255)) AS [AdmitID] -- 'Unique person, date of service, and provider = one visit' OR 'Unique person, date of service, and NDC = one script'
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st',
FROM HMOPROD_PlanData.dbo.claim AS c (NOLOCK)
	JOIN HMOPROD_PlanData.dbo.claimdetail AS cd (NOLOCK) ON c.claimid = cd.claimid  
	JOIN HMOPROD_PlanData.dbo.affiliation AS a (NOLOCK) ON c.affiliationid = a.affiliationid
	JOIN INFORMATICS.dbo.[uvw_CLAIMS_PAID] AS paid ON c.claimid = paid.claimid
		LEFT JOIN HMOPROD_PLANDATA.dbo.svccode AS sc ON cd.servcode = sc.codeid
WHERE TRY_CONVERT(date,c.startdate) <= @End -- WITHIN reporting period [RANGE] OPPOSITION  
	AND TRY_CONVERT(date,ISNULL(c.enddate,GETDATE())) >= @Start -- WITHIN reporting period [RANGE] OPPOSITION 
	AND 
	( -- INITIATE ...
	SUBSTRING(UPPER(LTRIM(RTRIM(ISNULL(cd.servcode,'')))),1,5) IN ('59400','59410','59425','59426','59510','59515','59610','59614','59618','59622','57170','58300','59430')
		OR SUBSTRING(UPPER(LTRIM(RTRIM(ISNULL(cd.servcode,'')))),1,5) BETWEEN '99201' AND '99205'
		OR SUBSTRING(UPPER(LTRIM(RTRIM(ISNULL(cd.servcode,'')))),1,5) BETWEEN '99211' AND '99215'
		OR SUBSTRING(UPPER(LTRIM(RTRIM(ISNULL(cd.servcode,'')))),1,5)BETWEEN '99241' AND '99245'
		OR SUBSTRING(UPPER(LTRIM(RTRIM(ISNULL(cd.servcode,'')))),1,5) IN ('99483','99501','G0101 G0463','H1005','T1015') -- ... AS [CPT Service Code] 
		) -- CONCLUDE ...







	-- CCS' = Ca. Children Service(s) v 'CSSD' = Childrens Specialist of San Diego (CSSD) --
SELECT DISTINCT ' ' AS 'POF #7 CCS = Ca. Children Service(s) v CSSD = Childrens Specialist of San Diego (CSSD)',q.description,ma.*
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st',q.*,ma.thevalue
FROM HMOPROD_PLANDATA.dbo.qattribute AS q
	JOIN HMOPROD_PlanData.dbo.memberattribute AS ma WITH(INDEX(XIE1memberattribute), NOLOCK) ON q.attributeid = ma.attributeid -- m.memid = ma.memid  
WHERE q.description LIKE '%CCS%' 
	AND @ReportRunDate BETWEEN ma.effdate AND ma.termdate -- RINA(): APPLIED TO FIELD WITHIN TABLE TO BE UPDATED
	AND CAST(ma.termdate AS date) != CAST(ma.effdate AS date)
	AND CAST(ma.termdate AS datetime) > CAST(ma.effdate AS datetime)

SELECT DISTINCT '(CCS Paneled Provider) IN eVIPS [ProviderRepository]' AS [CCS PANEL PROVIDER NOTE(s)],ccsd.NationalProviderID,ccsu.ProviderID,ccsd.PractitionerID,ccsu.DataSource,ccsu.Value,ccsu.tablename,ccsu.fieldname
-- SELECT TOP 10 ' ' AS 'CHECK 1st',ccsd.*,ccsu.*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM eVips_chgcv.dbo.vwUserFields AS ccsu
	JOIN eVips_chgcv.dbo.vwPractitionerDemographics AS ccsd ON ccsu.ProviderID = ccsd.practitionerid
WHERE ccsu.FieldName LIKE '%CCS%'
	AND ccsu.Value LIKE '%CCS%'
	-- AND ccsd.NationalProviderID IN ('1912218199','1760776728','1740485531','1275580037','1821387572','1649699968') -- ccsu.ProviderID IN ('4371852','4380505','4386131','4387896','4962677')
	) -- CONCLUDE ...
	AS ccs ON p.NPIis = UPPER(LTRIM(RTRIM(ISNULL(ccs.NationalProviderID,''))))

SELECT DISTINCT '(CCS Paneled Site) IN eVIPS [ProviderRepository]' AS [CCS PANEL SITE NOTE(s)],ccspl.LocationName,ccspl.LegalName,ccspl.NationalProviderID,ccsu.ProviderID,ccspl.PracticeID,ccspl.LocationID,ccsu.DataSource,ccsu.Value,ccsu.tablename,ccsu.fieldname
-- SELECT TOP 10 ' ' AS 'CHECK 1st',
-- SELECT DISTINCT ' ' AS 'CHECK 1st',TableName,LocationName,PracticeName,Value,PracticeLegalName,LegalName
FROM eVips_chgcv.dbo.vwUserFields AS ccsu
	JOIN evips_chgcv.dbo.vwPracticeLocations AS ccspl ON ccsu.ParentRecID = ccspl.LocationID
	-- JOIN evips_chgcv.dbo.vwPracticeLocations AS ccspl ON ccsu.ProviderID = ccspl.LocationID
	-- JOIN evips_chgcv.dbo.vwPracticeLocations AS ccspl ON ccsu.ProviderID = ccspl.PracticeID
WHERE ccspl.Archived IN ('N') --WITH eVIPS LOGICAL BINARY OPTION(s) IN USE •	Must not be archived 
	AND ccsu.FieldName LIKE '%CCS%'
	AND ccsu.Value LIKE '%CCS%'
	-- AND LegalName LIKE '%PALOM%'
	-- AND LineNumber1 LIKE '%555%PARK%'
	AND ISNULL(ccspl.NationalProviderID,'') != ''
	-- AND ccspl.NationalProviderID IN ('1801861190','1457321317') -- SAMPLE 'TRI CITY MED CTR''




	


SELECT TOP 10 ' ' AS '#MS HINA SMI SUD',DATEDIFF(day,CONVERT(date,ed.DateOfServiceFrom),CONVERT(date,ed.createdate)) AS 
'Number of days (lag) between ED DOS (claims) and when the provider (PCP) was notified',* 
FROM [ProviderPortal].[dbo].[NotificationCenter_ERVisitsCache] AS ed

--------------------------------------------------------------------------------------------------------------------
	-- Error Trapping: Check If Permanent Table(s) Already Exist(s) And Drop If Applicable --
--------------------------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS #SMI; -- SQL Server 2016 and later -- DYNAMIC tmp OR STATIC [TABLE] #TableName is a local temporary table visible only IN the current session; ##TableName is a GLOBAL temporary table visible to all sessions IN ('TempDB')

SELECT DISTINCT ' ' AS 'SMI (Serious Mental Illness)'
,mmem.memid,mmem.effdate,mmem.termdate,mem.codeid,CAST(mem.description AS nvarchar(255)) AS [CodeDescr]
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st',
INTO #SMI
FROM HMOPROD_PlanData.dbo.memo AS mem (NOLOCK)
	JOIN HMOPROD_PlanData.dbo.membermemo AS mmem (NOLOCK) ON mem.memoid = mmem.memoid
WHERE mem.memotype = 'salrt' 
	-- AND TRY_CONVERT(date,mem.termdate) >= TRY_CONVERT(date,GETDATE())
	AND TRY_CONVERT(date,mem.effdate) >= @StartDate 
	AND TRY_CONVERT(date,mem.effdate) <= @EndDate	
	AND mem.codeid = 'MentalHealth'
	-- AND mm.memid = mmem.memid -- FROM INFORMATICS.dbo.MemberMonths AS mm (NOLOCK)

		SELECT * FROM #SMI







--------------------------------------------------------------------------------------------------------------------
	-- Error Trapping: Check If Permanent Table(s) Already Exist(s) And Drop If Applicable --
--------------------------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS #HomelessClaims; -- SQL Server 2016 and later -- DYNAMIC tmp OR STATIC [TABLE] #TableName is a local temporary table visible only IN the current session; ##TableName is a GLOBAL temporary table visible to all sessions IN ('TempDB')

SELECT DISTINCT ' ' AS 'Homeless via Claims Utilization',c.memid,c.claimid,c.startdate,cdx.codeid,cdx.[diag descr],'DIAG' AS [code type]
INTO #HomelessClaims
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st',
FROM HMOPROD_PlanData.dbo.claim AS c (NOLOCK)
	JOIN 
	( -- INITIATE ...
	SELECT DISTINCT *
	-- INTO #prindiag
	-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
	-- SELECT DISTINCT ' ' AS 'CHECK 1st',
	FROM 
	( -- INITIATE ...
	SELECT aliassetup.*,DENSE_RANK() OVER (PARTITION BY aliassetup.claimid ORDER BY aliassetup.sequence ASC,aliassetup.codeid DESC) AS [RANKis]
	-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
	-- SELECT DISTINCT ' ' AS 'CHECK 1st',
	FROM 
	( -- INITIATE ...
	SELECT DISTINCT dx.claimid,dx.codeid,UPPER(LTRIM(RTRIM(ISNULL(dx.codeid,'')))) AS [diag],ISNULL(dc.DESCRIPTION,'') AS [diag descr],dx.sequence,dx.poa AS [PRESENT ON ADMISSION]
	-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
	-- SELECT DISTINCT ' ' AS 'CHECK 1st',
	FROM HMOPROD_PLANDATA.dbo.claimdiag AS dx
		LEFT JOIN HMOPROD_PLANDATA.dbo.DiagCode AS dc ON dx.codeid = dc.codeid
	) -- CONCLUDE
	AS aliassetup
	) -- CONCLUDE
	AS alias
	-- WHERE alias.sequence = 1 -- BETWEEN 1 AND 9	
		-- AND alias.[RANKis] = 1
	WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ... AND ...
		AND alias.diag LIKE '%Z59%' -- AND cdx.codeid = 'Z59.0'
		) -- CONCLUDE ...
		AS cdx ON c.claimid = cdx.claimid
WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ... AND ...
	AND TRY_CONVERT(date,c.startdate) <= @EndDate -- WITHIN reporting period [RANGE] OPPOSITION 
	AND TRY_CONVERT(date,ISNULL(c.enddate,GETDATE())) >= @StartDate -- WITHIN reporting period [RANGE] OPPOSITION 

	AND c.enddate >= c.startdate
	AND 
	( -- INITIATE ...
		c.resubclaimid IS NULL 
		OR 
		c.resubclaimid = ''
	) -- CONCLUDE ...
	AND c.claimid NOT LIKE '%R%' -- NO NOT NEGATIVE != <>
	AND c.[status] IN ('ADJUCATED', 'PAID', 'PAY', 'REV', 'REVERSED', 'REVSYNCH') 







--------------------------------------------------------------------------------------------------------------------
	-- Error Trapping: Check If Permanent Table(s) Already Exist(s) And Drop If Applicable --
--------------------------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS #IPClaims; -- SQL Server 2016 and later -- DYNAMIC tmp OR STATIC [TABLE] #TableName is a local temporary table visible only IN the current session; ##TableName is a GLOBAL temporary table visible to all sessions IN ('TempDB')

SELECT DISTINCT ' ' AS 'IP (Inpatient Facility)',c.memid,c.claimid,c.startdate,a.affiliateid
,CAST(UPPER(LTRIM(RTRIM(ISNULL(c.memid,'')))) AS varchar(255))+CAST(UPPER(LTRIM(RTRIM(ISNULL(TRY_CONVERT(date,c.startdate),'')))) AS varchar(10))+CAST(UPPER(LTRIM(RTRIM(ISNULL(a.provid,'')))) AS varchar(255)) AS [AdmitID] -- 'Unique person, date of service, and provider = one visit'  OR 'Unique person, date of service, and NDC = one script'
INTO #IPClaims
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st',
FROM HMOPROD_PlanData.dbo.claim AS c (NOLOCK)
	JOIN HMOPROD_PlanData.dbo.affiliation AS a (NOLOCK) ON c.affiliationid = a.affiliationid  
	JOIN INFORMATICS.dbo.[uvw_CLAIMS_PAID] AS paid ON c.claimid = paid.claimid
WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ... AND ...
	AND TRY_CONVERT(date,c.startdate) <= @End -- WITHIN reporting period [RANGE] OPPOSITION
	AND TRY_CONVERT(date,ISNULL(c.enddate,GETDATE())) >= @Start -- WITHIN reporting period [RANGE] OPPOSITION 
	AND c.formtype LIKE '%UB%'
	AND c.facilitycode = '1'  
	AND c.billclasscode IN ('1','2')







--------------------------------------------------------------------------------------------------------------------
	-- Error Trapping: Check If Permanent Table(s) Already Exist(s) And Drop If Applicable --
--------------------------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS #AR_HCT_IPClaims; -- SQL Server 2016 and later -- DYNAMIC tmp OR STATIC [TABLE] #INFORMATICS.dbo.PIVOTHOSPIP is a local temporary table visible only IN the current session; ##INFORMATICS.dbo.PIVOTHOSPIP is a GLOBAL temporary table visible to all sessions IN ('TempDB')

SELECT DISTINCT ' ' AS 'IP (Inpatient Facility)',c.memid,c.claimid,c.startdate,a.affiliateid
,CAST(UPPER(LTRIM(RTRIM(ISNULL(c.memid,'')))) AS varchar(255))+CAST(UPPER(LTRIM(RTRIM(ISNULL(TRY_CONVERT(date,c.startdate),'')))) AS varchar(10))+CAST(UPPER(LTRIM(RTRIM(ISNULL(a.provid,'')))) AS varchar(255)) AS [AdmitID] -- 'Unique person, date of service, and provider = one visit'  OR 'Unique person, date of service, and NDC = one script'
INTO #AR_HCT_IPClaims
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st',billclasscode
FROM HMOPROD_PlanData.dbo.claim AS c (NOLOCK)
	JOIN HMOPROD_PlanData.dbo.claimdetail AS cd (NOLOCK) ON c.claimid = cd.claimid  
	JOIN HMOPROD_PlanData.dbo.affiliation AS a (NOLOCK) ON c.affiliationid = a.affiliationid  
	JOIN INFORMATICS.dbo.[uvw_CLAIMS_PAID] AS paid ON c.claimid = paid.claimid
WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ... AND ...
	AND TRY_CONVERT(date,c.startdate) <= @End -- WITHIN reporting period [RANGE] OPPOSITION 
	AND TRY_CONVERT(date,ISNULL(c.enddate,GETDATE())) >= @Start -- WITHIN reporting period [RANGE] OPPOSITION 
	AND c.formtype LIKE '%UB%'
	AND c.facilitycode = '1'  
	AND c.billclasscode LIKE '[1-2]'

UNION 
SELECT DISTINCT ' ' AS 'IP (Inpatient Facility)',c.memid,c.claimid,c.startdate,a.affiliateid
,CAST(UPPER(LTRIM(RTRIM(ISNULL(c.memid,'')))) AS varchar(255))+CAST(UPPER(LTRIM(RTRIM(ISNULL(TRY_CONVERT(date,c.startdate),'')))) AS varchar(10))+CAST(UPPER(LTRIM(RTRIM(ISNULL(a.provid,'')))) AS varchar(255)) AS [AdmitID] -- 'Unique person, date of service, and provider = one visit'  OR 'Unique person, date of service, and NDC = one script'
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st',
FROM HMOPROD_PlanData.dbo.claim AS c (NOLOCK)
	JOIN HMOPROD_PlanData.dbo.claimdetail AS cd (NOLOCK) ON c.claimid = cd.claimid  
	JOIN HMOPROD_PlanData.dbo.affiliation AS a (NOLOCK) ON c.affiliationid = a.affiliationid  
	JOIN INFORMATICS.dbo.[uvw_CLAIMS_PAID] AS paid ON c.claimid = paid.claimid
WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ... AND ...
	AND TRY_CONVERT(date,c.startdate) <= @End -- WITHIN reporting period [RANGE] OPPOSITION 
	AND TRY_CONVERT(date,ISNULL(c.enddate,GETDATE())) >= @Start -- WITHIN reporting period [RANGE] OPPOSITION 
	AND c.formtype LIKE '%UB%'
	AND cd.revcode IN ('0112','0122','0132','0142','0152')
	






--------------------------------------------------------------------------------------------------------------------
	-- Error Trapping: Check If Permanent Table(s) Already Exist(s) And Drop If Applicable --
--------------------------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS #OPClaims; -- SQL Server 2016 and later -- DYNAMIC tmp OR STATIC [TABLE] #TableName is a local temporary table visible only IN the current session; ##TableName is a GLOBAL temporary table visible to all sessions IN ('TempDB')

SELECT DISTINCT ' ' AS 'OP (Outpatient Facility)',c.memid,c.claimid,c.startdate,a.affiliateid
,CAST(UPPER(LTRIM(RTRIM(ISNULL(c.memid,'')))) AS varchar(255))+CAST(UPPER(LTRIM(RTRIM(ISNULL(TRY_CONVERT(date,c.startdate),'')))) AS varchar(10))+CAST(UPPER(LTRIM(RTRIM(ISNULL(a.provid,'')))) AS varchar(255)) AS [AdmitID] -- 'Unique person, date of service, and provider = one visit'  OR 'Unique person, date of service, and NDC = one script'
INTO #OPClaims
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st',LTRIM(RTRIM(c.facilitycode))+LTRIM(RTRIM(c.billclasscode))+LTRIM(RTRIM(c.frequencycode)) AS [BillType]
FROM HMOPROD_PlanData.dbo.claim AS c (NOLOCK)
	JOIN HMOPROD_PlanData.dbo.claimdetail AS cd (NOLOCK) ON c.claimid = cd.claimid  
	JOIN HMOPROD_PlanData.dbo.affiliation AS a (NOLOCK) ON c.affiliationid = a.affiliationid  
	JOIN INFORMATICS.dbo.[uvw_CLAIMS_PAID] AS paid ON c.claimid = paid.claimid
WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ... AND ...
	AND TRY_CONVERT(date,c.startdate) <= @End -- WITHIN reporting period [RANGE] OPPOSITION  
	AND TRY_CONVERT(date,ISNULL(c.enddate,GETDATE())) >= @Start -- WITHIN reporting period [RANGE] OPPOSITION 
	AND c.formtype LIKE '%UB%'
	AND c.facilitycode = '1'  
	AND c.billclasscode LIKE '[3-4]'







--------------------------------------------------------------------------------------------------------------------
	-- Error Trapping: Check If Permanent Table(s) Already Exist(s) And Drop If Applicable --
--------------------------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS #ERClaims; -- SQL Server 2016 and later -- DYNAMIC tmp OR STATIC [TABLE] #INFORMATICS.dbo.IPP3_44 is a local temporary table visible only IN the current session; ##INFORMATICS.dbo.IPP3_44 is a GLOBAL temporary table visible to all sessions IN ('TempDB')

SELECT c.memid,c.claimid,c.startdate,a.affiliateid
,CAST(UPPER(LTRIM(RTRIM(ISNULL(c.memid,'')))) AS varchar(255))+CAST(UPPER(LTRIM(RTRIM(ISNULL(TRY_CONVERT(date,c.startdate),'')))) AS varchar(10))+CAST(UPPER(LTRIM(RTRIM(ISNULL(a.provid,'')))) AS varchar(255)) AS [AdmitID] -- 'Unique person, date of service, and provider = one visit'  OR 'Unique person, date of service, and NDC = one script'
INTO #ERClaims
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st',
FROM HMOPROD_PlanData.dbo.claim AS c (NOLOCK)
	JOIN HMOPROD_PlanData.dbo.claimdetail AS cd (NOLOCK) ON c.claimid = cd.claimid  
	JOIN HMOPROD_PlanData.dbo.affiliation AS a (NOLOCK) ON c.affiliationid = a.affiliationid 
	JOIN INFORMATICS.dbo.[uvw_CLAIMS_PAID] AS paid ON c.claimid = paid.claimid
WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ... AND ...
	AND c.enddate >= c.startdate -- MUST BE TRUE ... NON-CROSSFOOTED RECORDS ARE ACTIVE ...
	AND TRY_CONVERT(date,c.startdate) <= @ClockStop -- WITHIN reporting period [RANGE] OPPOSITION 
	AND TRY_CONVERT(date,ISNULL(c.enddate,GETDATE())) >= @ClockStart -- WITHIN reporting period [RANGE] OPPOSITION
	AND c.facilitycode = '1' 
	AND c.billclasscode IN ('3','4') 
	AND cd.revcode BETWEEN '0450' AND '0459'	

		-- SELECT TOP 1 ' ' AS 'ER Claims',* FROM #ERClaims







--------------------------------------------------------------------------------------------------------------------
	-- Error Trapping: Check If Permanent Table(s) Already Exist(s) And Drop If Applicable --
--------------------------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS #ERClaimsMHSelfHarm; -- SQL Server 2016 and later -- DYNAMIC tmp OR STATIC [TABLE] #INFORMATICS.dbo.IPP3_44 is a local temporary table visible only IN the current session; ##INFORMATICS.dbo.IPP3_44 is a GLOBAL temporary table visible to all sessions IN ('TempDB')

SELECT c.memid,c.claimid,c.startdate,a.affiliateid
,CAST(UPPER(LTRIM(RTRIM(ISNULL(c.memid,'')))) AS varchar(255))+CAST(UPPER(LTRIM(RTRIM(ISNULL(TRY_CONVERT(date,c.startdate),'')))) AS varchar(10))+CAST(UPPER(LTRIM(RTRIM(ISNULL(a.provid,'')))) AS varchar(255)) AS [AdmitID] -- 'Unique person, date of service, and provider = one visit'  OR 'Unique person, date of service, and NDC = one script'
INTO #ERClaimsMHSelfHarm
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st',
FROM HMOPROD_PlanData.dbo.claim AS c (NOLOCK)
	JOIN HMOPROD_PlanData.dbo.claimdetail AS cd (NOLOCK) ON c.claimid = cd.claimid  
	JOIN HMOPROD_PlanData.dbo.affiliation AS a (NOLOCK) ON c.affiliationid = a.affiliationid 
	JOIN INFORMATICS.dbo.[uvw_CLAIMS_PAID] AS paid ON c.claimid = paid.claimid
WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ... AND ...
	AND c.enddate >= c.startdate -- MUST BE TRUE ... NON-CROSSFOOTED RECORDS ARE ACTIVE ...
	AND TRY_CONVERT(date,c.startdate) <= @ClockStop -- WITHIN reporting period [RANGE] OPPOSITION 
	AND TRY_CONVERT(date,ISNULL(c.enddate,GETDATE())) >= @ClockStart -- WITHIN reporting period [RANGE] OPPOSITION
	AND c.facilitycode = '1' 
	AND c.billclasscode IN ('3','4') 
	AND cd.revcode BETWEEN '0450' AND '0459'	

	AND c.claimid IN
	( -- INITIATE ...
	SELECT DISTINCT dx.claimid
	FROM HMOPROD_PLANDATA.dbo.claimdiag AS dx
	WHERE UPPER(LTRIM(RTRIM(ISNULL(dx.codeid,'')))) BETWEEN 'F01%' AND 'F99%' -- IPP3 ... with a diagnosis of mental health disorder or intentional self-harm ... 

	UNION 
	SELECT DISTINCT dx.claimid
	FROM HMOPROD_PLANDATA.dbo.claimdiag AS dx
	WHERE UPPER(LTRIM(RTRIM(ISNULL(dx.codeid,'')))) LIKE 'T14.9%'

	UNION 
	SELECT DISTINCT dx.claimid
	FROM HMOPROD_PLANDATA.dbo.claimdiag AS dx
	WHERE UPPER(LTRIM(RTRIM(ISNULL(dx.codeid,'')))) IN ('R45.85')
	) -- CONCLUDE ...
	
		-- SELECT TOP 1 ' ' AS 'ER Claims with MH or Self Harm Dx',* FROM #ERClaimsMHSelfHarm







--------------------------------------------------------------------------------------------------------------------
	-- Error Trapping: Check If Permanent Table(s) Already Exist(s) And Drop If Applicable --
--------------------------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS #ERClaimsAOD; -- SQL Server 2016 and later -- DYNAMIC tmp OR STATIC [TABLE] #INFORMATICS.dbo.IPP3_45 is a local temporary table visible only IN the current session; ##INFORMATICS.dbo.IPP3_45 is a GLOBAL temporary table visible to all sessions IN ('TempDB')

SELECT c.memid,c.claimid,c.startdate,a.affiliateid
,CAST(UPPER(LTRIM(RTRIM(ISNULL(c.memid,'')))) AS varchar(255))+CAST(UPPER(LTRIM(RTRIM(ISNULL(TRY_CONVERT(date,c.startdate),'')))) AS varchar(10))+CAST(UPPER(LTRIM(RTRIM(ISNULL(a.provid,'')))) AS varchar(255)) AS [AdmitID] -- 'Unique person, date of service, and provider = one visit'  OR 'Unique person, date of service, and NDC = one script'
INTO #ERClaimsAOD
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st',
FROM HMOPROD_PlanData.dbo.claim AS c (NOLOCK)
	JOIN HMOPROD_PlanData.dbo.claimdetail AS cd (NOLOCK) ON c.claimid = cd.claimid  
	JOIN HMOPROD_PlanData.dbo.affiliation AS a (NOLOCK) ON c.affiliationid = a.affiliationid 
	JOIN INFORMATICS.dbo.[uvw_CLAIMS_PAID] AS paid ON c.claimid = paid.claimid
WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ... AND ...
	AND c.enddate >= c.startdate -- MUST BE TRUE ... NON-CROSSFOOTED RECORDS ARE ACTIVE ...
	AND TRY_CONVERT(date,c.startdate) <= @ClockStop -- WITHIN reporting period [RANGE] OPPOSITION 
	AND TRY_CONVERT(date,ISNULL(c.enddate,GETDATE())) >= @ClockStart -- WITHIN reporting period [RANGE] OPPOSITION
	AND c.facilitycode = '1' 
	AND c.billclasscode IN ('3','4') 
	AND cd.revcode BETWEEN '0450' AND '0459'	

	AND c.claimid IN
	( -- INITIATE ...
	SELECT DISTINCT dx.claimid
	FROM HMOPROD_PLANDATA.dbo.claimdiag AS dx
	WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ... AND ...
		AND UPPER(LTRIM(RTRIM(ISNULL(dx.codeid,'')))) IN (SELECT DISTINCT Code FROM #CAValSet WHERE (VALUESETNAME LIKE '%AOD%') AND [CodeType] LIKE '%ICD10%') -- AOD Abuse and Dependence
	) -- CONCLUDE ...

		-- SELECT TOP 1 ' ' AS 'ER Claims with AOD Dx',* FROM #ERClaimsAOD








--------------------------------------------------------------------------------------------------------------------
	-- Error Trapping: Check If Permanent Table(s) Already Exist(s) And Drop If Applicable --
--------------------------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS #Ambulatory -- SQL Server 2016 and later -- DYNAMIC tmp OR STATIC [TABLE] #INFORMATICS.dbo.IPP3_45 is a local temporary table visible only IN the current session; ##INFORMATICS.dbo.IPP3_45 is a GLOBAL temporary table visible to all sessions IN ('TempDB')

SELECT c.memid,c.claimid,c.startdate,a.affiliateid
,CAST(UPPER(LTRIM(RTRIM(ISNULL(c.memid,'')))) AS varchar(255))+CAST(UPPER(LTRIM(RTRIM(ISNULL(TRY_CONVERT(date,c.startdate),'')))) AS varchar(10))+CAST(UPPER(LTRIM(RTRIM(ISNULL(a.provid,'')))) AS varchar(255)) AS [AdmitID] -- 'Unique person, date of service, and provider = one visit'  OR 'Unique person, date of service, and NDC = one script'
INTO #Ambulatory
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st',
FROM HMOPROD_PlanData.dbo.claim AS c (NOLOCK)
	JOIN HMOPROD_PlanData.dbo.claimdetail AS cd (NOLOCK) ON c.claimid = cd.claimid  
	JOIN HMOPROD_PlanData.dbo.affiliation AS a (NOLOCK) ON c.affiliationid = a.affiliationid 
	-- JOIN INFORMATICS.dbo.[uvw_CLAIMS_PAID] AS paid ON c.claimid = paid.claimid
	JOIN INFORMATICS.dbo.PHMKPIValueSetsVersion20220801 AS vs ON vs.Code = cd.servcode -- FROM MS NOLYN PHM LOGIC ON 20230830 TEAMS CHAT ... From the #CaimsInitial temp table, identifying ambulatory or preventive claims using the NCQA value sets
WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ... AND ...
	AND c.enddate >= c.startdate -- MUST BE TRUE ... NON-CROSSFOOTED RECORDS ARE ACTIVE ...
	AND TRY_CONVERT(date,c.startdate) <= @ClockStop -- WITHIN reporting period [RANGE] OPPOSITION 
	AND TRY_CONVERT(date,ISNULL(c.enddate,GETDATE())) >= @ClockStart -- WITHIN reporting period [RANGE] OPPOSITION
	AND vs.[Value Set Name] IN ('Ambulatory Visits','Other Ambulatory Visits','Online Assessments','Telephone Visits','Well-Care')
	AND vs.[Code Type] IN ('CPT','HCPCS')

UNION
SELECT c.memid,c.claimid,c.startdate,a.affiliateid
,CAST(UPPER(LTRIM(RTRIM(ISNULL(c.memid,'')))) AS varchar(255))+CAST(UPPER(LTRIM(RTRIM(ISNULL(TRY_CONVERT(date,c.startdate),'')))) AS varchar(10))+CAST(UPPER(LTRIM(RTRIM(ISNULL(a.provid,'')))) AS varchar(255)) AS [AdmitID] -- 'Unique person, date of service, and provider = one visit'  OR 'Unique person, date of service, and NDC = one script'
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st',
FROM HMOPROD_PlanData.dbo.claim AS c (NOLOCK)
	JOIN HMOPROD_PlanData.dbo.claimdetail AS cd (NOLOCK) ON c.claimid = cd.claimid  
	JOIN HMOPROD_PlanData.dbo.affiliation AS a (NOLOCK) ON c.affiliationid = a.affiliationid 
	-- JOIN INFORMATICS.dbo.[uvw_CLAIMS_PAID] AS paid ON c.claimid = paid.claimid
	JOIN INFORMATICS.dbo.PHMKPIValueSetsVersion20220801 AS vs ON vs.Code = cd.revcode  -- FROM MS NOLYN PHM WORK ... From the #CaimsInitial temp table, identifying ambulatory or preventive claims using the NCQA value sets
WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ... AND ...
	AND c.enddate >= c.startdate -- MUST BE TRUE ... NON-CROSSFOOTED RECORDS ARE ACTIVE ...
	AND TRY_CONVERT(date,c.startdate) <= @ClockStop -- WITHIN reporting period [RANGE] OPPOSITION 
	AND TRY_CONVERT(date,ISNULL(c.enddate,GETDATE())) >= @ClockStart -- WITHIN reporting period [RANGE] OPPOSITION
	AND vs.[Value Set Name] IN ('Ambulatory Visits','Other Ambulatory Visits')
	AND vs.[Code Type] IN ('UBREV')

UNION
SELECT c.memid,c.claimid,c.startdate,a.affiliateid
,CAST(UPPER(LTRIM(RTRIM(ISNULL(c.memid,'')))) AS varchar(255))+CAST(UPPER(LTRIM(RTRIM(ISNULL(TRY_CONVERT(date,c.startdate),'')))) AS varchar(10))+CAST(UPPER(LTRIM(RTRIM(ISNULL(a.provid,'')))) AS varchar(255)) AS [AdmitID] -- 'Unique person, date of service, and provider = one visit'  OR 'Unique person, date of service, and NDC = one script'
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st',
FROM HMOPROD_PlanData.dbo.claim AS c (NOLOCK)
	JOIN HMOPROD_PlanData.dbo.claimdetail AS cd (NOLOCK) ON c.claimid = cd.claimid  
	JOIN HMOPROD_PlanData.dbo.affiliation AS a (NOLOCK) ON c.affiliationid = a.affiliationid 
	-- JOIN INFORMATICS.dbo.[uvw_CLAIMS_PAID] AS paid ON c.claimid = paid.claimid
	JOIN HMOPROD_PlanData.dbo.claimdiag AS diag ON c.claimid = diag.claimid
	JOIN INFORMATICS.dbo.PHMKPIValueSetsVersion20220801 AS vs ON vs.Code = diag.codeid -- FROM MS NOLYN PHM LOGIC ON 20230830 TEAMS CHAT ... From the #CaimsInitial temp table, identifying ambulatory or preventive claims using the NCQA value sets
WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ... AND ...
	AND c.enddate >= c.startdate -- MUST BE TRUE ... NON-CROSSFOOTED RECORDS ARE ACTIVE ...
	AND TRY_CONVERT(date,c.startdate) <= @ClockStop -- WITHIN reporting period [RANGE] OPPOSITION 
	AND TRY_CONVERT(date,ISNULL(c.enddate,GETDATE())) >= @ClockStart -- WITHIN reporting period [RANGE] OPPOSITION
	AND vs.[Value Set Name] IN ('Ambulatory Visits','Well-Care')
	AND ((vs.[Code Type] = 'ICD10CM' and cd.dosfrom > = '20151001')
		OR (vs.[Code Type] = 'ICD9CM' and cd.dosfrom <'20151001'))
		
		SELECT TOP 1 ' ' AS 'Ambulatory Claims',* FROM #Ambulatory







--------------------------------------------------------------------------------------------------------------------
	-- Error Trapping: Check If Permanent Table(s) Already Exist(s) And Drop If Applicable --
--------------------------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS #WellCare -- SQL Server 2016 and later -- DYNAMIC tmp OR STATIC [TABLE] #TableName is a local temporary table visible only IN the current session; ##TableName is a GLOBAL temporary table visible to all sessions IN ('TempDB')


SELECT c.memid,c.claimid,c.startdate,a.affiliateid,cd.dosfrom
,CAST(UPPER(LTRIM(RTRIM(ISNULL(c.memid,'')))) AS varchar(255))+CAST(UPPER(LTRIM(RTRIM(ISNULL(TRY_CONVERT(date,c.startdate),'')))) AS varchar(10))+CAST(UPPER(LTRIM(RTRIM(ISNULL(a.provid,'')))) AS varchar(255)) AS [AdmitID] -- 'Unique person, date of service, and provider = one visit'  OR 'Unique person, date of service, and NDC = one script'
INTO #WellCare
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st',
FROM HMOPROD_PlanData.dbo.claim AS c (NOLOCK)
	JOIN HMOPROD_PlanData.dbo.claimdetail AS cd (NOLOCK) ON c.claimid = cd.claimid  
	JOIN HMOPROD_PlanData.dbo.affiliation AS a (NOLOCK) ON c.affiliationid = a.affiliationid 
	-- JOIN INFORMATICS.dbo.[uvw_CLAIMS_PAID] AS paid ON c.claimid = paid.claimid
	JOIN INFORMATICS.dbo.PHMKPIValueSetsVersion20220801 AS vs ON vs.Code = cd.servcode -- FROM MS NOLYN PHM LOGIC ON 20230830 TEAMS CHAT ... From the #CaimsInitial temp table, identifying ambulatory or preventive claims using the NCQA value sets
WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ... AND ...
	AND c.enddate >= c.startdate -- MUST BE TRUE ... NON-CROSSFOOTED RECORDS ARE ACTIVE ...
	AND TRY_CONVERT(date,c.startdate) <= @ClockStop -- WITHIN reporting period [RANGE] OPPOSITION 
	AND TRY_CONVERT(date,ISNULL(c.enddate,GETDATE())) >= @ClockStart -- WITHIN reporting period [RANGE] OPPOSITION
	AND vs.[Value Set Name] IN ('Well-Care') -- Well-Care OR WellCare OR Well Care
	AND vs.[Code Type] IN ('CPT','HCPCS')

UNION
SELECT c.memid,c.claimid,c.startdate,a.affiliateid,cd.dosfrom
,CAST(UPPER(LTRIM(RTRIM(ISNULL(c.memid,'')))) AS varchar(255))+CAST(UPPER(LTRIM(RTRIM(ISNULL(TRY_CONVERT(date,c.startdate),'')))) AS varchar(10))+CAST(UPPER(LTRIM(RTRIM(ISNULL(a.provid,'')))) AS varchar(255)) AS [AdmitID] -- 'Unique person, date of service, and provider = one visit'  OR 'Unique person, date of service, and NDC = one script'
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st',
FROM HMOPROD_PlanData.dbo.claim AS c (NOLOCK)
	JOIN HMOPROD_PlanData.dbo.claimdetail AS cd (NOLOCK) ON c.claimid = cd.claimid  
	JOIN HMOPROD_PlanData.dbo.affiliation AS a (NOLOCK) ON c.affiliationid = a.affiliationid 
	-- JOIN INFORMATICS.dbo.[uvw_CLAIMS_PAID] AS paid ON c.claimid = paid.claimid
	JOIN HMOPROD_PlanData.dbo.claimdiag AS diag ON c.claimid = diag.claimid
	JOIN INFORMATICS.dbo.PHMKPIValueSetsVersion20220801 AS vs ON vs.Code = diag.codeid -- FROM MS NOLYN PHM LOGIC ON 20230830 TEAMS CHAT ... From the #CaimsInitial temp table, identifying ambulatory or preventive claims using the NCQA value setss
WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ... AND ...
	AND c.enddate >= c.startdate -- MUST BE TRUE ... NON-CROSSFOOTED RECORDS ARE ACTIVE ...
	AND TRY_CONVERT(date,c.startdate) <= @ClockStop -- WITHIN reporting period [RANGE] OPPOSITION 
	AND TRY_CONVERT(date,ISNULL(c.enddate,GETDATE())) >= @ClockStart -- WITHIN reporting period [RANGE] OPPOSITION
	AND vs.[Value Set Name] IN ('Well-Care') -- Well-Care OR WellCare OR Well Care
	AND ((vs.[Code Type] = 'ICD10CM' and cd.dosfrom > = '20151001')
		OR (vs.[Code Type] = 'ICD9CM' and cd.dosfrom <'20151001'))

		SELECT TOP 1 ' ' AS 'Well-Care OR WellCare OR Well Care',* FROM #WellCare







--------------------------------------------------------------------------------------------------------------------
	-- Error Trapping: Check If Permanent Table(s) Already Exist(s) And Drop If Applicable --
--------------------------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS #MentalHealth; -- SQL Server 2016 and later -- DYNAMIC tmp OR STATIC [TABLE] #INFORMATICS.dbo.IPP3_44 is a local temporary table visible only IN the current session; ##INFORMATICS.dbo.IPP3_44 is a GLOBAL temporary table visible to all sessions IN ('TempDB')

SELECT c.memid,c.claimid,c.startdate,a.affiliateid
,CAST(UPPER(LTRIM(RTRIM(ISNULL(c.memid,'')))) AS varchar(255))+CAST(UPPER(LTRIM(RTRIM(ISNULL(TRY_CONVERT(date,c.startdate),'')))) AS varchar(10))+CAST(UPPER(LTRIM(RTRIM(ISNULL(a.provid,'')))) AS varchar(255)) AS [AdmitID] -- 'Unique person, date of service, and provider = one visit'  OR 'Unique person, date of service, and NDC = one script'
INTO #MentalHealth
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st',
FROM HMOPROD_PlanData.dbo.claim AS c (NOLOCK)
	JOIN HMOPROD_PlanData.dbo.claimdetail AS cd (NOLOCK) ON c.claimid = cd.claimid  
	JOIN HMOPROD_PlanData.dbo.affiliation AS a (NOLOCK) ON c.affiliationid = a.affiliationid 
	JOIN INFORMATICS.dbo.[uvw_CLAIMS_PAID] AS paid ON c.claimid = paid.claimid
WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ... AND ...
	AND c.enddate >= c.startdate -- MUST BE TRUE ... NON-CROSSFOOTED RECORDS ARE ACTIVE ...
	-- AND TRY_CONVERT(date,c.startdate) <= @ClockStop -- WITHIN reporting period [RANGE] OPPOSITION- 
	AND TRY_CONVERT(date,c.startdate) <= TRY_CONVERT(date,GETDATE()) -- IPP F/U TRACKING ... WITHIN reporting period [RANGE] OPPOSITION 
	AND TRY_CONVERT(date,ISNULL(c.enddate,GETDATE())) >= @ClockStart -- WITHIN reporting period [RANGE] OPPOSITION
	AND c.claimid IN
	( -- INITIATE ...
	SELECT DISTINCT dx.claimid
	FROM HMOPROD_PLANDATA.dbo.claimdiag AS dx
	WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ... AND ...
		AND UPPER(LTRIM(RTRIM(ISNULL(dx.codeid,'')))) BETWEEN 'F01%' AND 'F99%' -- IPP3 ... with a diagnosis of mental health disorder or intentional self-harm ... 

	UNION 
	SELECT DISTINCT dx.claimid
	FROM HMOPROD_PLANDATA.dbo.claimdiag AS dx
	WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ... AND ...
		AND UPPER(LTRIM(RTRIM(ISNULL(dx.codeid,'')))) LIKE 'T14.9%'

	UNION 
	SELECT DISTINCT dx.claimid
	FROM HMOPROD_PLANDATA.dbo.claimdiag AS dx
	WHERE 1=1 -- FOR ... Building dynamic WHERE conditions ... AND ...
		AND UPPER(LTRIM(RTRIM(ISNULL(dx.codeid,'')))) IN ('R45.85')
	) -- CONCLUDE ...

		-- SELECT TOP 1 ' ' AS 'MentalHealth F/ U',* FROM #MentalHealth







 --------------------------------------------------------------------------------------------------------------------
	-- Error Trapping: Check If Permanent Table(s) Already Exist(s) And Drop If Applicable --
--------------------------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS #SNFClaims; -- SQL Server 2016 and later -- DYNAMIC tmp OR STATIC [TABLE] #TableName is a local temporary table visible only IN the current session; ##TableName is a GLOBAL temporary table visible to all sessions IN ('TempDB')

SELECT DISTINCT ' ' AS 'SNF',c.memid,c.claimid,c.startdate,a.affiliateid,rc.codeid,ISNULL(rc.description,'') AS [code descr],'REV' AS [code type]
,CAST(UPPER(LTRIM(RTRIM(ISNULL(c.memid,'')))) AS varchar(255))+CAST(UPPER(LTRIM(RTRIM(ISNULL(TRY_CONVERT(date,c.startdate),'')))) AS varchar(10))+CAST(UPPER(LTRIM(RTRIM(ISNULL(a.provid,'')))) AS varchar(255)) AS [AdmitID] -- 'Unique person, date of service, and provider = one visit'  OR 'Unique person, date of service, and NDC = one script'
INTO #SNFClaims
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st',
FROM HMOPROD_PlanData.dbo.claim AS c (NOLOCK)
	JOIN HMOPROD_PlanData.dbo.claimdetail AS cd (NOLOCK) ON c.claimid = cd.claimid  
	JOIN HMOPROD_PlanData.dbo.affiliation AS a (NOLOCK) ON c.affiliationid = a.affiliationid 
	JOIN INFORMATICS.dbo.[uvw_CLAIMS_PAID] AS paid ON c.claimid = paid.claimid
		LEFT JOIN HMOPROD_PLANDATA.dbo.revcode AS rc ON cd.servcode = rc.codeid
WHERE 1=1
	AND TRY_CONVERT(date,c.startdate) <= @End -- WITHIN reporting period [RANGE] OPPOSITION
	AND TRY_CONVERT(date,ISNULL(c.enddate,GETDATE())) >= @Start -- WITHIN reporting period [RANGE] OPPOSITION 
	AND cd.revcode BETWEEN '0191' AND '0193'
	
UNION 
SELECT DISTINCT ' ' AS 'SNF',c.memid,c.claimid,c.startdate,a.affiliateid,rc.codeid,ISNULL(rc.description,'') AS [code descr],'REV' AS [code type]
,CAST(UPPER(LTRIM(RTRIM(ISNULL(c.memid,'')))) AS varchar(255))+CAST(UPPER(LTRIM(RTRIM(ISNULL(TRY_CONVERT(date,c.startdate),'')))) AS varchar(10))+CAST(UPPER(LTRIM(RTRIM(ISNULL(a.provid,'')))) AS varchar(255)) AS [AdmitID] -- 'Unique person, date of service, and provider = one visit'  OR 'Unique person, date of service, and NDC = one script'
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st',
FROM HMOPROD_PlanData.dbo.claim AS c (NOLOCK)
	JOIN HMOPROD_PlanData.dbo.claimdetail AS cd (NOLOCK) ON c.claimid = cd.claimid  
	JOIN HMOPROD_PlanData.dbo.affiliation AS a (NOLOCK) ON c.affiliationid = a.affiliationid 
	JOIN INFORMATICS.dbo.[uvw_CLAIMS_PAID] AS paid ON c.claimid = paid.claimid
		LEFT JOIN HMOPROD_PLANDATA.dbo.revcode AS rc ON cd.servcode = rc.codeid
WHERE 1=1
	AND TRY_CONVERT(date,c.startdate) <= @End -- WITHIN reporting period [RANGE] OPPOSITION
	AND TRY_CONVERT(date,ISNULL(c.enddate,GETDATE())) >= @Start -- WITHIN reporting period [RANGE] OPPOSITION 
	AND cd.revcode IN ('0022')







--------------------------------------------------------------------------------------------------------------------
	-- Error Trapping: Check If Permanent Table(s) Already Exist(s) And Drop If Applicable --
--------------------------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS #MHSMISUDClaims; -- SQL Server 2016 and later -- DYNAMIC tmp OR STATIC [TABLE] #TableName is a local temporary table visible only IN the current session; ##TableName is a GLOBAL temporary table visible to all sessions IN ('TempDB')

SELECT DISTINCT c.memid,c.claimid,c.startdate
,CAST(UPPER(LTRIM(RTRIM(ISNULL(c.memid,'')))) AS varchar(255))+CAST(UPPER(LTRIM(RTRIM(ISNULL(TRY_CONVERT(date,c.startdate),'')))) AS varchar(10))+CAST(UPPER(LTRIM(RTRIM(ISNULL(a.provid,'')))) AS varchar(255)) AS [AdmitID] -- 'Unique person, date of service, and provider = one visit'  OR 'Unique person, date of service, and NDC = one script'
INTO #MHSMISUDClaims
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st',
FROM HMOPROD_PlanData.dbo.claim AS c (NOLOCK)
	JOIN HMOPROD_PlanData.dbo.claimdetail AS cd (NOLOCK) ON c.claimid = cd.claimid  
	JOIN HMOPROD_PlanData.dbo.affiliation AS a (NOLOCK) ON c.affiliationid = a.affiliationid  
	JOIN INFORMATICS.dbo.[uvw_CLAIMS_PAID] AS paid ON c.claimid = paid.claimid
	JOIN 
	( -- INITIATE ...
	SELECT DISTINCT *
	-- INTO #prindiag
	-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
	-- SELECT DISTINCT ' ' AS 'CHECK 1st',
	FROM 
	( -- INITIATE ...
	SELECT aliassetup.*,DENSE_RANK() OVER (PARTITION BY aliassetup.claimid ORDER BY aliassetup.sequence ASC,aliassetup.codeid DESC) AS [RANKis]
	-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
	-- SELECT DISTINCT ' ' AS 'CHECK 1st',
	FROM 
	( -- INITIATE ...
	SELECT DISTINCT dx.claimid,dx.codeid,UPPER(LTRIM(RTRIM(ISNULL(dx.codeid,'')))) AS [diag],ISNULL(dc.DESCRIPTION,'') AS [diag descr],dx.sequence,dx.poa AS [PRESENT ON ADMISSION]
	-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
	-- SELECT DISTINCT ' ' AS 'CHECK 1st',
	FROM HMOPROD_PLANDATA.dbo.claimdiag AS dx
		LEFT JOIN HMOPROD_PLANDATA.dbo.DiagCode AS dc ON dx.codeid = dc.codeid
	) -- CONCLUDE
	AS aliassetup
	) -- CONCLUDE
	AS alias
	-- WHERE alias.sequence = 1 -- BETWEEN 1 AND 9	
		-- AND alias.[RANKis] = 1
	WHERE alias.diag IN ('F10.920','F10.921','F10.929','F10.930','F10.931','F10.932','F10.939','F10.94','F10.950','F10.951','F10.959','F10.96','F10.97','F10.980','F10.981','F10.982','F10.988','F10.99','F11.90','F11.920','F11.921','F11.922','F11.929','F11.93','F11.94','F11.950','F11.951','F11.959','F11.981','F11.982','F11.988','F11.99','F12.90','F12.920','F12.921','F12.922','F12.929','F12.93','F12.950','F12.951','F12.959','F12.980','F12.988','F12.99','F13.90','F13.920','F13.921','F13.929','F13.930','F13.931','F13.932','F13.939','F13.94','F13.950','F13.951','F13.959','F13.96','F13.97','F13.980','F13.981','F13.982','F13.988','F13.99','F14.90','F14.920','F14.921','F14.922','F14.929','F14.93','F14.94','F14.950','F14.951','F14.959','F14.980','F14.981','F14.982','F14.988','F14.99','F15.90','F15.920','F15.921','F15.922','F15.929','F15.93','F15.94','F15.950','F15.951','F15.959','F15.980','F15.981','F15.982','F15.988','F15.99','F16.90','F16.920','F16.921','F16.929','F16.94','F16.950','F16.951','F16.959','F16.980','F16.983','F16.988','F16.99','F18.90','F18.920','F18.921','F18.929','F18.94','F18.950','F18.951','F18.959','F18.97','F18.980','F18.988','F18.99','F19.90','F19.920','F19.921','F19.922','F19.929','F19.930','F19.931','F19.932','F19.939','F19.94','F19.950','F19.951','F19.959','F19.96','F19.97','F19.980','F19.981','F19.982','F19.988','F19.99') -- SUD diagnosis codes: ICD-10 Code Series F00 to F99 
	) -- CONCLUDE ...
	AS cdx ON c.claimid = cdx.claimid
WHERE TRY_CONVERT(date,c.startdate) <= @End -- WITHIN reporting period [RANGE] OPPOSITION
	AND TRY_CONVERT(date,ISNULL(c.enddate,GETDATE())) >= @Start -- WITHIN reporting period [RANGE] OPPOSITION 
	
UNION 
SELECT DISTINCT c.memid,c.claimid,c.startdate
,CAST(UPPER(LTRIM(RTRIM(ISNULL(c.memid,'')))) AS varchar(255))+CAST(UPPER(LTRIM(RTRIM(ISNULL(TRY_CONVERT(date,c.startdate),'')))) AS varchar(10))+CAST(UPPER(LTRIM(RTRIM(ISNULL(a.provid,'')))) AS varchar(255)) AS [AdmitID] -- 'Unique person, date of service, and provider = one visit'  OR 'Unique person, date of service, and NDC = one script'
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st',
FROM HMOPROD_PlanData.dbo.claim AS c (NOLOCK)
	JOIN HMOPROD_PlanData.dbo.claimdetail AS cd (NOLOCK) ON c.claimid = cd.claimid  
	JOIN HMOPROD_PlanData.dbo.affiliation AS a (NOLOCK) ON c.affiliationid = a.affiliationid 
	JOIN INFORMATICS.dbo.[uvw_CLAIMS_PAID] AS paid ON c.claimid = paid.claimid
WHERE TRY_CONVERT(date,c.startdate) <= @End -- WITHIN reporting period [RANGE] OPPOSITION
	AND TRY_CONVERT(date,ISNULL(c.enddate,GETDATE())) >= @Start -- WITHIN reporting period [RANGE] OPPOSITION 
	AND SUBSTRING(UPPER(LTRIM(RTRIM(ISNULL(cd.servcode,'')))),1,5) IN ('99408','99409','G0396','G0397','G0443','H0001','H0005','H0007','H0015','H0016','H0022','H0047','H0050','H2035','H2036','T1006','T1012','H0006','H0028') -- 'SMI' =  Serious Mental Illness 'SUD' = Substance Use Disorder ... AS [CPT Service Code] 







--------------------------------------------------------------------------------------------------------------------
	-- Error Trapping: Check If Permanent Table(s) Already Exist(s) And Drop If Applicable --
--------------------------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS #IDD; -- SQL Server 2016 and later -- DYNAMIC tmp OR STATIC [TABLE] #TableName is a local temporary table visible only IN the current session; ##TableName is a GLOBAL temporary table visible to all sessions IN ('TempDB')

SELECT DISTINCT ' ' AS 'I/DD (Intellectual and Developmental Disabilities)',c.memid,c.claimid,c.startdate,cdx.codeid,cdx.[diag descr],'DIAG' AS [code type]
,CAST(UPPER(LTRIM(RTRIM(ISNULL(c.memid,'')))) AS varchar(255))+CAST(UPPER(LTRIM(RTRIM(ISNULL(TRY_CONVERT(date,c.startdate),'')))) AS varchar(10))+CAST(UPPER(LTRIM(RTRIM(ISNULL(a.provid,'')))) AS varchar(255)) AS [AdmitID] -- 'Unique person, date of service, and provider = one visit'  OR 'Unique person, date of service, and NDC = one script'
INTO #IDD
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st',
FROM HMOPROD_PlanData.dbo.claim AS c (NOLOCK)
	JOIN HMOPROD_PlanData.dbo.claimdetail AS cd (NOLOCK) ON c.claimid = cd.claimid  
	JOIN HMOPROD_PlanData.dbo.affiliation AS a (NOLOCK) ON c.affiliationid = a.affiliationid  
	JOIN INFORMATICS.dbo.[uvw_CLAIMS_PAID] AS paid ON c.claimid = paid.claimid
	JOIN 
	( -- INITIATE ...
	SELECT DISTINCT *
	-- INTO #prindiag
	-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
	-- SELECT DISTINCT ' ' AS 'CHECK 1st',
	FROM 
	( -- INITIATE ...
	SELECT aliassetup.*,DENSE_RANK() OVER (PARTITION BY aliassetup.claimid ORDER BY aliassetup.sequence ASC,aliassetup.codeid DESC) AS [RANKis]
	-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
	-- SELECT DISTINCT ' ' AS 'CHECK 1st',
	FROM 
	( -- INITIATE ...
	SELECT DISTINCT dx.claimid,dx.codeid,UPPER(LTRIM(RTRIM(ISNULL(dx.codeid,'')))) AS [diag],ISNULL(dc.DESCRIPTION,'') AS [diag descr],dx.sequence,dx.poa AS [PRESENT ON ADMISSION]
	-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
	-- SELECT DISTINCT ' ' AS 'CHECK 1st',
	FROM HMOPROD_PLANDATA.dbo.claimdiag AS dx
		LEFT JOIN HMOPROD_PLANDATA.dbo.DiagCode AS dc ON dx.codeid = dc.codeid
	) -- CONCLUDE
	AS aliassetup
	) -- CONCLUDE
	AS alias
	-- WHERE alias.sequence = 1 -- BETWEEN 1 AND 9	
		-- AND alias.[RANKis] = 1
	WHERE alias.diag IN ('F22','F23','F24','F28','F29','F32.3','F33.3','F70','F71','F72','F73','F78','F78.A1','F78.A9','F79','F80.0','F80.1','F80.2','F80.4','F80.81','F80.82','F80.89','F80.9','F81.0','F81.2','F81.81','F81.89','F81.9','F82','F84','F84.0','F84.0','F84.0','F84.2','F84.2','F84.3','F84.3','F84.3','F84.5','F84.5','F84.8','F84.8','F84.8','F84.9','F84.9','F84.9','F88','F89','F90.0','F90.1','F90.2','F90.8','F90.9','F91.0','F91.1','F91.2','F91.3','F91.8','F91.9','F93.0','F93.8','F93.9','F94.0','F94.1','F94.2','F94.8','F94.9','F95.0','F95.0','F95.1','F95.1','F95.2','F95.2','F95.8','F95.8','F95.9','F95.9','F98.0','F98.1','F98.21','F98.29','F98.3','F98.4','F98.5','F98.8','F98.9','F99','Q90','Q90.0','Q90.1','Q90.2','Q90.9','Q91.0','Q91.1','Q91.2','Q91.3','Q91.4','Q91.5','Q91.6','Q91.7','Q92','Q93','Q93.0','Q93.1','Q93.2','Q93.3','Q93.4','Q93.5','Q93.51','Q93.59','Q93.7','Q93.8','Q93.81','Q93.82','Q93.88','Q93.89','Q93.9','Q99.2') -- Children and youth (younger than 21 yrs of age) who have a diagnosis of I/DD Use the following ICD-10 diagnosis codes: Lookback period 12 months
	) -- CONCLUDE ...
	AS cdx ON c.claimid = cdx.claimid
WHERE TRY_CONVERT(date,c.startdate) <= @End -- WITHIN reporting period [RANGE] OPPOSITION
	AND TRY_CONVERT(date,ISNULL(c.enddate,GETDATE())) >= @Start -- WITHIN reporting period [RANGE] OPPOSITION 







--------------------------------------------------------------------------------------------------------------------
	-- Error Trapping: Check If Permanent Table(s) Already Exist(s) And Drop If Applicable --
--------------------------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS #IncarcerationClaims; -- SQL Server 2016 and later -- DYNAMIC tmp OR STATIC [TABLE] #TableName is a local temporary table visible only IN the current session; ##TableName is a GLOBAL temporary table visible to all sessions IN ('TempDB')

SELECT DISTINCT c.memid,c.claimid,c.startdate,cdx.codeid,cdx.[diag descr],'DIAG' AS [code type]
INTO #IncarcerationClaims
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st',
FROM HMOPROD_PlanData.dbo.claim AS c (NOLOCK)
	JOIN 
	( -- INITIATE ...
	SELECT DISTINCT *
	-- INTO #prindiag
	-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
	-- SELECT DISTINCT ' ' AS 'CHECK 1st',
	FROM 
	( -- INITIATE ...
	SELECT aliassetup.*,DENSE_RANK() OVER (PARTITION BY aliassetup.claimid ORDER BY aliassetup.sequence ASC,aliassetup.codeid DESC) AS [RANKis]
	-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
	-- SELECT DISTINCT ' ' AS 'CHECK 1st',
	FROM 
	( -- INITIATE ...
	SELECT DISTINCT dx.claimid,dx.codeid,UPPER(LTRIM(RTRIM(ISNULL(dx.codeid,'')))) AS [diag],ISNULL(dc.DESCRIPTION,'') AS [diag descr],dx.sequence,dx.poa AS [PRESENT ON ADMISSION]
	-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
	-- SELECT DISTINCT ' ' AS 'CHECK 1st',
	FROM HMOPROD_PLANDATA.dbo.claimdiag AS dx
		LEFT JOIN HMOPROD_PLANDATA.dbo.DiagCode AS dc ON dx.codeid = dc.codeid
	) -- CONCLUDE
	AS aliassetup
	) -- CONCLUDE
	AS alias
	-- WHERE alias.sequence = 1 -- BETWEEN 1 AND 9	
		-- AND alias.[RANKis] = 1
	WHERE alias.diag IN ('Z65.1','Z65.2','Z65.3','Z65.4','Z65.5','Z65.8','Z65.9')
	) -- CONCLUDE ...
	AS cdx ON c.claimid = cdx.claimid
WHERE TRY_CONVERT(date,c.startdate) <= @End -- WITHIN reporting period [RANGE] OPPOSITION
	AND TRY_CONVERT(date,ISNULL(c.enddate,GETDATE())) >= @Start -- WITHIN reporting period [RANGE] OPPOSITION 
	AND 
	( -- INITIATE ...
		c.resubclaimid IS NULL 
		OR 
		c.resubclaimid = ''
	) -- CONCLUDE ...
	AND c.claimid NOT LIKE '%R%' -- NO NOT NEGATIVE != <>
	AND c.[status] IN ('ADJUCATED', 'PAID', 'PAY', 'REV', 'REVERSED', 'REVSYNCH')

		SELECT * FROM #IncarcerationClaims







--------------------------------------------------------------------------------------------------------------------
	-- Error Trapping: Check If Permanent Table(s) Already Exist(s) And Drop If Applicable --
--------------------------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS #SUDClaims; -- SQL Server 2016 and later -- DYNAMIC tmp OR STATIC [TABLE] #TableName is a local temporary table visible only IN the current session; ##TableName is a GLOBAL temporary table visible to all sessions IN ('TempDB')

SELECT DISTINCT c.memid,c.claimid,c.startdate,cdx.codeid,cdx.[diag descr],'DIAG' AS [code type]
INTO #SUDClaims
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st',
FROM HMOPROD_PlanData.dbo.claim AS c (NOLOCK)
	JOIN 
	( -- INITIATE ...
	SELECT DISTINCT *
	-- INTO #prindiag
	-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
	-- SELECT DISTINCT ' ' AS 'CHECK 1st',
	FROM 
	( -- INITIATE ...
	SELECT aliassetup.*,DENSE_RANK() OVER (PARTITION BY aliassetup.claimid ORDER BY aliassetup.sequence ASC,aliassetup.codeid DESC) AS [RANKis]
	-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
	-- SELECT DISTINCT ' ' AS 'CHECK 1st',
	FROM 
	( -- INITIATE ...
	SELECT DISTINCT dx.claimid,dx.codeid,UPPER(LTRIM(RTRIM(ISNULL(dx.codeid,'')))) AS [diag],ISNULL(dc.DESCRIPTION,'') AS [diag descr],dx.sequence,dx.poa AS [PRESENT ON ADMISSION]
	-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
	-- SELECT DISTINCT ' ' AS 'CHECK 1st',
	FROM HMOPROD_PLANDATA.dbo.claimdiag AS dx
		LEFT JOIN HMOPROD_PLANDATA.dbo.DiagCode AS dc ON dx.codeid = dc.codeid
	) -- CONCLUDE
	AS aliassetup
	) -- CONCLUDE
	AS alias
	-- WHERE alias.sequence = 1 -- BETWEEN 1 AND 9	
		-- AND alias.[RANKis] = 1
	WHERE alias.diag >= 'F1'
		AND alias.diag < 'F9'
	) -- CONCLUDE ...
	AS cdx ON c.claimid = cdx.claimid
WHERE TRY_CONVERT(date,c.startdate) <= @End -- WITHIN reporting period [RANGE] OPPOSITION
	AND TRY_CONVERT(date,ISNULL(c.enddate,GETDATE())) >= @Start -- WITHIN reporting period [RANGE] OPPOSITION 
	AND 
	( -- INITIATE ...
		c.resubclaimid IS NULL 
		OR 
		c.resubclaimid = ''
	) -- CONCLUDE ...
	AND c.claimid NOT LIKE '%R%' -- NO NOT NEGATIVE != <>
	AND c.[status] IN ('ADJUCATED', 'PAID', 'PAY', 'REV', 'REVERSED', 'REVSYNCH')

		SELECT * FROM #SUDClaims







--------------------------------------------------------------------------------------------------------------------
	-- Error Trapping: Check If Permanent Table(s) Already Exist(s) And Drop If Applicable --
--------------------------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS #ChronicCondClaims; -- SQL Server 2016 and later -- DYNAMIC tmp OR STATIC [TABLE] #TableName is a local temporary table visible only IN the current session; ##TableName is a GLOBAL temporary table visible to all sessions IN ('TempDB')

SELECT DISTINCT c.memid,c.claimid,c.startdate,cdx.codeid,cdx.[diag descr],'DIAG' AS [code type]
INTO #ChronicCondClaims
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st',
FROM HMOPROD_PlanData.dbo.claim AS c (NOLOCK)
	JOIN 
	( -- INITIATE ...
	SELECT DISTINCT *
	-- INTO #prindiag
	-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
	-- SELECT DISTINCT ' ' AS 'CHECK 1st',
	FROM 
	( -- INITIATE ...
	SELECT aliassetup.*,DENSE_RANK() OVER (PARTITION BY aliassetup.claimid ORDER BY aliassetup.sequence ASC,aliassetup.codeid DESC) AS [RANKis]
	-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
	-- SELECT DISTINCT ' ' AS 'CHECK 1st',
	FROM 
	( -- INITIATE ...
	SELECT DISTINCT dx.claimid,dx.codeid,UPPER(LTRIM(RTRIM(ISNULL(dx.codeid,'')))) AS [diag],ISNULL(dc.DESCRIPTION,'') AS [diag descr],dx.sequence,dx.poa AS [PRESENT ON ADMISSION]
	-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
	-- SELECT DISTINCT ' ' AS 'CHECK 1st',
	FROM HMOPROD_PLANDATA.dbo.claimdiag AS dx
		LEFT JOIN HMOPROD_PLANDATA.dbo.DiagCode AS dc ON dx.codeid = dc.codeid
	) -- CONCLUDE
	AS aliassetup
	) -- CONCLUDE
	AS alias
	-- WHERE alias.sequence = 1 -- BETWEEN 1 AND 9	
		-- AND alias.[RANKis] = 1
	WHERE alias.diag LIKE 'E08%'
		OR alias.diag LIKE 'E09%'
		OR alias.diag LIKE 'E10%'
		OR alias.diag LIKE 'E11%'
		OR alias.diag LIKE 'E12%'
		OR alias.diag LIKE 'E13%'
		OR alias.diag LIKE 'K73%'
		
	) -- CONCLUDE ...
	AS cdx ON c.claimid = cdx.claimid
WHERE TRY_CONVERT(date,c.startdate) <= @End -- WITHIN reporting period [RANGE] OPPOSITION
	AND TRY_CONVERT(date,ISNULL(c.enddate,GETDATE())) >= @Start -- WITHIN reporting period [RANGE] OPPOSITION 
	AND 
	( -- INITIATE ...
		c.resubclaimid IS NULL 
		OR 
		c.resubclaimid = ''
	) -- CONCLUDE ...
	AND c.claimid NOT LIKE '%R%' -- NO NOT NEGATIVE != <>
	AND c.[status] IN ('ADJUCATED', 'PAID', 'PAY', 'REV', 'REVERSED', 'REVSYNCH')

		SELECT * FROM #ChronicCondClaims







--------------------------------------------------------------------------------------------------------------------
	-- Error Trapping: Check If Permanent Table(s) Already Exist(s) And Drop If Applicable --
--------------------------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS #IntellectualDisClaims; -- SQL Server 2016 and later -- DYNAMIC tmp OR STATIC [TABLE] #TableName is a local temporary table visible only IN the current session; ##TableName is a GLOBAL temporary table visible to all sessions IN ('TempDB')

SELECT DISTINCT c.memid,c.claimid,c.startdate,cdx.codeid,cdx.[diag descr],'DIAG' AS [code type]
INTO #IntellectualDisClaims
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st',
FROM HMOPROD_PlanData.dbo.claim AS c (NOLOCK)
	JOIN 
	( -- INITIATE ...
	SELECT DISTINCT *
	-- INTO #prindiag
	-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
	-- SELECT DISTINCT ' ' AS 'CHECK 1st',
	FROM 
	( -- INITIATE ...
	SELECT aliassetup.*,DENSE_RANK() OVER (PARTITION BY aliassetup.claimid ORDER BY aliassetup.sequence ASC,aliassetup.codeid DESC) AS [RANKis]
	-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
	-- SELECT DISTINCT ' ' AS 'CHECK 1st',
	FROM 
	( -- INITIATE ...
	SELECT DISTINCT dx.claimid,dx.codeid,UPPER(LTRIM(RTRIM(ISNULL(dx.codeid,'')))) AS [diag],ISNULL(dc.DESCRIPTION,'') AS [diag descr],dx.sequence,dx.poa AS [PRESENT ON ADMISSION]
	-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
	-- SELECT DISTINCT ' ' AS 'CHECK 1st',
	FROM HMOPROD_PLANDATA.dbo.claimdiag AS dx
		LEFT JOIN HMOPROD_PLANDATA.dbo.DiagCode AS dc ON dx.codeid = dc.codeid
	) -- CONCLUDE
	AS aliassetup
	) -- CONCLUDE
	AS alias
	-- WHERE alias.sequence = 1 -- BETWEEN 1 AND 9	
		-- AND alias.[RANKis] = 1
	WHERE alias.diag >= 'F7'
	AND alias.diag < 'F8'
		
	) -- CONCLUDE ...
	AS cdx ON c.claimid = cdx.claimid
WHERE TRY_CONVERT(date,c.startdate) <= @End -- WITHIN reporting period [RANGE] OPPOSITION
	AND TRY_CONVERT(date,ISNULL(c.enddate,GETDATE())) >= @Start -- WITHIN reporting period [RANGE] OPPOSITION 
	AND 
	( -- INITIATE ...
		c.resubclaimid IS NULL 
		OR 
		c.resubclaimid = ''
	) -- CONCLUDE ...
	AND c.claimid NOT LIKE '%R%' -- NO NOT NEGATIVE != <>
	AND c.[status] IN ('ADJUCATED', 'PAID', 'PAY', 'REV', 'REVERSED', 'REVSYNCH')

		SELECT * FROM #IntellectualDisClaims







--------------------------------------------------------------------------------------------------------------------
	-- Error Trapping: Check If Permanent Table(s) Already Exist(s) And Drop If Applicable --
--------------------------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS #DevelopmentalDisClaims; -- SQL Server 2016 and later -- DYNAMIC tmp OR STATIC [TABLE] #TableName is a local temporary table visible only IN the current session; ##TableName is a GLOBAL temporary table visible to all sessions IN ('TempDB')

SELECT DISTINCT c.memid,c.claimid,c.startdate,cdx.codeid,cdx.[diag descr],'DIAG' AS [code type]
INTO #DevelopmentalDisClaims
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st',
FROM HMOPROD_PlanData.dbo.claim AS c (NOLOCK)
	JOIN 
	( -- INITIATE ...
	SELECT DISTINCT *
	-- INTO #prindiag
	-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
	-- SELECT DISTINCT ' ' AS 'CHECK 1st',
	FROM 
	( -- INITIATE ...
	SELECT aliassetup.*,DENSE_RANK() OVER (PARTITION BY aliassetup.claimid ORDER BY aliassetup.sequence ASC,aliassetup.codeid DESC) AS [RANKis]
	-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
	-- SELECT DISTINCT ' ' AS 'CHECK 1st',
	FROM 
	( -- INITIATE ...
	SELECT DISTINCT dx.claimid,dx.codeid,UPPER(LTRIM(RTRIM(ISNULL(dx.codeid,'')))) AS [diag],ISNULL(dc.DESCRIPTION,'') AS [diag descr],dx.sequence,dx.poa AS [PRESENT ON ADMISSION]
	-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
	-- SELECT DISTINCT ' ' AS 'CHECK 1st',
	FROM HMOPROD_PLANDATA.dbo.claimdiag AS dx
		LEFT JOIN HMOPROD_PLANDATA.dbo.DiagCode AS dc ON dx.codeid = dc.codeid
	) -- CONCLUDE
	AS aliassetup
	) -- CONCLUDE
	AS alias
	-- WHERE alias.sequence = 1 -- BETWEEN 1 AND 9	
		-- AND alias.[RANKis] = 1
	WHERE alias.diag >= 'F8'
	AND alias.diag < 'F9'
		
	) -- CONCLUDE ...
	AS cdx ON c.claimid = cdx.claimid
WHERE TRY_CONVERT(date,c.startdate) <= @End -- WITHIN reporting period [RANGE] OPPOSITION
	AND TRY_CONVERT(date,ISNULL(c.enddate,GETDATE())) >= @Start -- WITHIN reporting period [RANGE] OPPOSITION 
	AND 
	( -- INITIATE ...
		c.resubclaimid IS NULL 
		OR 
		c.resubclaimid = ''
	) -- CONCLUDE ...
	AND c.claimid NOT LIKE '%R%' -- NO NOT NEGATIVE != <>
	AND c.[status] IN ('ADJUCATED', 'PAID', 'PAY', 'REV', 'REVERSED', 'REVSYNCH')

		SELECT * FROM #DevelopmentalDisClaims







--------------------------------------------------------------------------------------------------------------------
	-- Error Trapping: Check If Permanent Table(s) Already Exist(s) And Drop If Applicable --
--------------------------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS #BrainInjClaims; -- SQL Server 2016 and later -- DYNAMIC tmp OR STATIC [TABLE] #TableName is a local temporary table visible only IN the current session; ##TableName is a GLOBAL temporary table visible to all sessions IN ('TempDB')

SELECT DISTINCT c.memid,c.claimid,c.startdate,cdx.codeid,cdx.[diag descr],'DIAG' AS [code type]
INTO #BrainInjClaims
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st',
FROM HMOPROD_PlanData.dbo.claim AS c (NOLOCK)
	JOIN 
	( -- INITIATE ...
	SELECT DISTINCT *
	-- INTO #prindiag
	-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
	-- SELECT DISTINCT ' ' AS 'CHECK 1st',
	FROM 
	( -- INITIATE ...
	SELECT aliassetup.*,DENSE_RANK() OVER (PARTITION BY aliassetup.claimid ORDER BY aliassetup.sequence ASC,aliassetup.codeid DESC) AS [RANKis]
	-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
	-- SELECT DISTINCT ' ' AS 'CHECK 1st',
	FROM 
	( -- INITIATE ...
	SELECT DISTINCT dx.claimid,dx.codeid,UPPER(LTRIM(RTRIM(ISNULL(dx.codeid,'')))) AS [diag],ISNULL(dc.DESCRIPTION,'') AS [diag descr],dx.sequence,dx.poa AS [PRESENT ON ADMISSION]
	-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
	-- SELECT DISTINCT ' ' AS 'CHECK 1st',
	FROM HMOPROD_PLANDATA.dbo.claimdiag AS dx
		LEFT JOIN HMOPROD_PLANDATA.dbo.DiagCode AS dc ON dx.codeid = dc.codeid
	) -- CONCLUDE
	AS aliassetup
	) -- CONCLUDE
	AS alias
	-- WHERE alias.sequence = 1 -- BETWEEN 1 AND 9	
		-- AND alias.[RANKis] = 1
	WHERE alias.diag >= 'S06'
	AND alias.diag < 'S07'
		
	) -- CONCLUDE ...
	AS cdx ON c.claimid = cdx.claimid
WHERE TRY_CONVERT(date,c.startdate) <= @End -- WITHIN reporting period [RANGE] OPPOSITION
	AND TRY_CONVERT(date,ISNULL(c.enddate,GETDATE())) >= @Start -- WITHIN reporting period [RANGE] OPPOSITION 
	AND 
	( -- INITIATE ...
		c.resubclaimid IS NULL 
		OR 
		c.resubclaimid = ''
	) -- CONCLUDE ...
	AND c.claimid NOT LIKE '%R%' -- NO NOT NEGATIVE != <>
	AND c.[status] IN ('ADJUCATED', 'PAID', 'PAY', 'REV', 'REVERSED', 'REVSYNCH')

		SELECT * FROM #BrainInjClaims







--------------------------------------------------------------------------------------------------------------------
	-- Error Trapping: Check If Permanent Table(s) Already Exist(s) And Drop If Applicable --
--------------------------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS #HIVClaims; -- SQL Server 2016 and later -- DYNAMIC tmp OR STATIC [TABLE] #TableName is a local temporary table visible only IN the current session; ##TableName is a GLOBAL temporary table visible to all sessions IN ('TempDB')

SELECT DISTINCT c.memid,c.claimid,c.startdate,cdx.codeid,cdx.[diag descr],'DIAG' AS [code type]
INTO #HIVClaims
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st',
FROM HMOPROD_PlanData.dbo.claim AS c (NOLOCK)
	JOIN 
	( -- INITIATE ...
	SELECT DISTINCT *
	-- INTO #prindiag
	-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
	-- SELECT DISTINCT ' ' AS 'CHECK 1st',
	FROM 
	( -- INITIATE ...
	SELECT aliassetup.*,DENSE_RANK() OVER (PARTITION BY aliassetup.claimid ORDER BY aliassetup.sequence ASC,aliassetup.codeid DESC) AS [RANKis]
	-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
	-- SELECT DISTINCT ' ' AS 'CHECK 1st',
	FROM 
	( -- INITIATE ...
	SELECT DISTINCT dx.claimid,dx.codeid,UPPER(LTRIM(RTRIM(ISNULL(dx.codeid,'')))) AS [diag],ISNULL(dc.DESCRIPTION,'') AS [diag descr],dx.sequence,dx.poa AS [PRESENT ON ADMISSION]
	-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
	-- SELECT DISTINCT ' ' AS 'CHECK 1st',
	FROM HMOPROD_PLANDATA.dbo.claimdiag AS dx
		LEFT JOIN HMOPROD_PLANDATA.dbo.DiagCode AS dc ON dx.codeid = dc.codeid
	) -- CONCLUDE
	AS aliassetup
	) -- CONCLUDE
	AS alias
	-- WHERE alias.sequence = 1 -- BETWEEN 1 AND 9	
		-- AND alias.[RANKis] = 1
	WHERE alias.diag >= 'B20'
		AND alias.diag < 'B25'
		
	) -- CONCLUDE ...
	AS cdx ON c.claimid = cdx.claimid
WHERE TRY_CONVERT(date,c.startdate) <= @End -- WITHIN reporting period [RANGE] OPPOSITION
	AND TRY_CONVERT(date,ISNULL(c.enddate,GETDATE())) >= @Start -- WITHIN reporting period [RANGE] OPPOSITION 
	AND 
	( -- INITIATE ...
		c.resubclaimid IS NULL 
		OR 
		c.resubclaimid = ''
	) -- CONCLUDE ...
	AND c.claimid NOT LIKE '%R%' -- NO NOT NEGATIVE != <>
	AND c.[status] IN ('ADJUCATED', 'PAID', 'PAY', 'REV', 'REVERSED', 'REVSYNCH')

		SELECT * FROM #HIVClaims







--------------------------------------------------------------------------------------------------------------------
	-- Error Trapping: Check If Permanent Table(s) Already Exist(s) And Drop If Applicable --
--------------------------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS #PregnancyClaims; -- SQL Server 2016 and later -- DYNAMIC tmp OR STATIC [TABLE] #TableName is a local temporary table visible only IN the current session; ##TableName is a GLOBAL temporary table visible to all sessions IN ('TempDB')

SELECT DISTINCT c.memid,c.claimid,c.startdate,cdx.codeid,cdx.[diag descr],'DIAG' AS [code type]
INTO #PregnancyClaims
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st',
FROM HMOPROD_PlanData.dbo.claim AS c (NOLOCK)
	JOIN 
	( -- INITIATE ...
	SELECT DISTINCT *
	-- INTO #prindiag
	-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
	-- SELECT DISTINCT ' ' AS 'CHECK 1st',
	FROM 
	( -- INITIATE ...
	SELECT aliassetup.*,DENSE_RANK() OVER (PARTITION BY aliassetup.claimid ORDER BY aliassetup.sequence ASC,aliassetup.codeid DESC) AS [RANKis]
	-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
	-- SELECT DISTINCT ' ' AS 'CHECK 1st',
	FROM 
	( -- INITIATE ...
	SELECT DISTINCT dx.claimid,dx.codeid,UPPER(LTRIM(RTRIM(ISNULL(dx.codeid,'')))) AS [diag],ISNULL(dc.DESCRIPTION,'') AS [diag descr],dx.sequence,dx.poa AS [PRESENT ON ADMISSION]
	-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
	-- SELECT DISTINCT ' ' AS 'CHECK 1st',
	FROM HMOPROD_PLANDATA.dbo.claimdiag AS dx
		LEFT JOIN HMOPROD_PLANDATA.dbo.DiagCode AS dc ON dx.codeid = dc.codeid
	) -- CONCLUDE
	AS aliassetup
	) -- CONCLUDE
	AS alias
	-- WHERE alias.sequence = 1 -- BETWEEN 1 AND 9	
		-- AND alias.[RANKis] = 1
	WHERE alias.diag >= 'Z32'
		AND alias.diag < 'Z40'
		
	) -- CONCLUDE ...
	AS cdx ON c.claimid = cdx.claimid
WHERE TRY_CONVERT(date,c.startdate) <= @End -- WITHIN reporting period [RANGE] OPPOSITION
	AND TRY_CONVERT(date,ISNULL(c.enddate,GETDATE())) >= @Start -- WITHIN reporting period [RANGE] OPPOSITION 
	AND 
	( -- INITIATE ...
		c.resubclaimid IS NULL 
		OR 
		c.resubclaimid = ''
	) -- CONCLUDE ...
	AND c.claimid NOT LIKE '%R%' -- NO NOT NEGATIVE != <>
	AND c.[status] IN ('ADJUCATED', 'PAID', 'PAY', 'REV', 'REVERSED', 'REVSYNCH')

		SELECT * FROM #PregnancyClaims







-- ======================================================================
	-- SAMPLE UPDATE(S) --
-- ======================================================================
UPDATE INFORMATICS.dbo.JAG_SCRIPSS_ECM
SET [Cx] = CAST(NULL AS nvarchar(255)) -- RESET DFLT() VAL

UPDATE INFORMATICS.dbo.JAG_SCRIPSS_ECM
SET [Cx] = 'IPClaims'
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM INFORMATICS.dbo.JAG_SCRIPSS_ECM AS su
	JOIN 
	( -- INITIATE ...
	SELECT DISTINCT ' ' AS 'FROM ER Visits & Inpatient Acute ...sql','IPClaims' AS 'Cx',AdmitID 
	FROM #IPClaims
	) -- CONCLUDE ...
	AS ecm ON su.AdmitID = ecm.AdmitID
WHERE su.QNXTbilltype LIKE '11%'
	OR su.QNXTbilltype LIKE '12%'
	
UPDATE INFORMATICS.dbo.ECMPOF_CHILD_IPSNFED_HIGHUTIL
SET [ERVisitCount] = util.HIT
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st',
FROM INFORMATICS.dbo.ECMPOF_CHILD_IPSNFED_HIGHUTIL AS ecm
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

UPDATE INFORMATICS.dbo.ECMPOF_CHILD_IPSNFED_HIGHUTIL
SET [HighUtilizer] = CASE 
WHEN [ERVisitCount] >= @ERVisit
THEN 'Y'
WHEN [IPAdmitCount] >= @IPAdmit
THEN 'Y'
WHEN [SNFAdmitCount] >= @IPAdmit
THEN 'Y'
ELSE 'N'
END 
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st',
FROM INFORMATICS.dbo.ECMPOF_CHILD_IPSNFED_HIGHUTIL AS ecm

-- HAVING COUNT(DISTINCT(ecm.AdmitID)) >= @ERVisit
-- HAVING COUNT(DISTINCT(ecm.AdmitID)) >= @IPAdmit
	






-- ===========================================================================
	-- COS (CATEGORY OF SERVICE) ... LIKE '%HCT%' [Cx] INCLM (FACILITY) --
-- ===========================================================================
UPDATE INFORMATICS.dbo.PRESIDIUMHOMELESSCLAIMS
SET [Cx] = CAST(NULL AS nvarchar(255)) -- RESET DFLT() VAL

SELECT DISTINCT ' ' AS 'SIR PHIL SNF FROM HCT'
c.claimid
INTO #snf
FROM
HMOPROD_PlanData.dbo.claim c (NOLOCK)
JOIN HMOPROD_PlanData.dbo.claimdetail AS cdet (NOLOCK) ON c.claimid = cdet.claimid
WHERE
(c.facilitycode = '2'
	  AND c.billclasscode IN ('1','2','3'))
		OR cdet.revcode BETWEEN '0191' AND '0193'
		OR cdet.revcode = '0022'
		OR c.provid IN ('156799','2571','911','22')

	-- ER FAC (INCLM) --
UPDATE INFORMATICS.dbo.PRESIDIUMHOMELESSCLAIMS
SET [Cx] = 'ER (Facility)'
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM INFORMATICS.dbo.PRESIDIUMHOMELESSCLAIMS AS su
WHERE su.[Cx] IS NULL -- UNIVERSAL
	AND su.claimid IN -- The ENTIRE claim
	( -- INITIATE ...
	SELECT DISTINCT sup.claimid
	-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
	-- SELECT DISTINCT ' ' AS 'CHECK 1st'
	FROM INFORMATICS.dbo.PRESIDIUMHOMELESSCLAIMS AS sup
	WHERE CASE
		WHEN SUBSTRING(LTRIM(RTRIM(ISNULL(sup.revcode,''))),1,1) = 'Z'
		THEN  LTRIM(RTRIM(sup.revcode))
		WHEN SUBSTRING(LTRIM(RTRIM(ISNULL(sup.revcode,''))),1,1) = '0'
		THEN  SUBSTRING(LTRIM(RTRIM(ISNULL(sup.revcode,''))),2,3)
		ELSE LTRIM(RTRIM(ISNULL(sup.revcode,'')))
		END LIKE '45%'
		AND (sup.QNXTbilltype  LIKE '13%' --HOSPITAL  OP
			OR sup.QNXTbilltype  LIKE '14%') --HOSPITAL Oth
		AND sup.[ClmType] = 'FACILITY'
		) -- CONCLUDE ...

	-- POS 21 (INCLM) --
UPDATE INFORMATICS.dbo.PRESIDIUMHOMELESSCLAIMS
SET [Cx] = 'IP (Facility)'
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM INFORMATICS.dbo.PRESIDIUMHOMELESSCLAIMS AS su
WHERE su.[Cx] IS NULL -- UNIVERSAL
	AND su.claimid IN -- The ENTIRE claim
	( -- INITIATE ...
	SELECT DISTINCT sup.claimid
	-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
	-- SELECT DISTINCT ' ' AS 'CHECK 1st'
	FROM INFORMATICS.dbo.PRESIDIUMHOMELESSCLAIMS AS sup
	WHERE 
	( -- INITIATE ...
	sup.QNXTbilltype LIKE '11%' --HOSPITAL IP
		OR sup.QNXTbilltype LIKE '12%' --Hospital - Hospital Based or Inpatient
		) -- CONCLUDE ...
		AND sup.[ClmType] = 'FACILITY' --WHEN formtype LIKE '%UB%' --INCLM
		) -- CONLUDE ...

	-- OB (INCLM) --
UPDATE INFORMATICS.dbo.PRESIDIUMHOMELESSCLAIMS
SET [Cx] = 'OB (Facility)'
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM INFORMATICS.dbo.PRESIDIUMHOMELESSCLAIMS AS su
WHERE su.[Cx] IS NULL -- UNIVERSAL
	AND su.claimid IN -- The ENTIRE claim
	( -- INITIATE ...
	SELECT DISTINCT sup.claimid
	-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
	-- SELECT DISTINCT ' ' AS 'CHECK 1st'
	FROM INFORMATICS.dbo.PRESIDIUMHOMELESSCLAIMS AS sup
	WHERE CASE
	WHEN SUBSTRING(LTRIM(RTRIM(ISNULL(sup.revcode,''))),1,1) = 'Z'
	THEN  LTRIM(RTRIM(sup.revcode))
	WHEN SUBSTRING(LTRIM(RTRIM(ISNULL(sup.revcode,''))),1,1) = '0'
	THEN  SUBSTRING(LTRIM(RTRIM(ISNULL(sup.revcode,''))),2,3)
	ELSE LTRIM(RTRIM(ISNULL(sup.revcode,'')))
	END IN ('112','122','132','142','152')
		AND sup.[ClmType] = 'FACILITY'
		) -- CONCLUDE ...

	-- SNF (INCLM) --
UPDATE INFORMATICS.dbo.PRESIDIUMHOMELESSCLAIMS
SET [Cx] = 'SNF'
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM INFORMATICS.dbo.PRESIDIUMHOMELESSCLAIMS AS su
WHERE su.[Cx] IS NULL -- UNIVERSAL
	AND su.claimid IN -- The ENTIRE claim
	( -- INITIATE ...
	SELECT DISTINCT sup.claimid
	-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
	-- SELECT DISTINCT ' ' AS 'CHECK 1st'
	FROM INFORMATICS.dbo.PRESIDIUMHOMELESSCLAIMS AS sup
	WHERE 
	( -- INITIATE ...
	sup.QNXTbilltype LIKE '21%' -- SNF
		OR sup.QNXTbilltype LIKE '22%' -- SNF
		OR sup.QNXTbilltype LIKE '23%' -- SNF
		OR CASE
		WHEN SUBSTRING(LTRIM(RTRIM(ISNULL(sup.revcode,''))),1,1) = 'Z'
		THEN  LTRIM(RTRIM(sup.revcode))
		WHEN SUBSTRING(LTRIM(RTRIM(ISNULL(sup.revcode,''))),1,1) = '0'
		THEN  SUBSTRING(LTRIM(RTRIM(ISNULL(sup.revcode,''))),2,3)
		ELSE LTRIM(RTRIM(ISNULL(sup.revcode,'')))
		END BETWEEN '191' AND '193'
		OR CASE
		WHEN SUBSTRING(LTRIM(RTRIM(ISNULL(sup.revcode,''))),1,1) = 'Z'
		THEN  LTRIM(RTRIM(sup.revcode))
		WHEN SUBSTRING(LTRIM(RTRIM(ISNULL(sup.revcode,''))),1,1) = '0'
		THEN  SUBSTRING(LTRIM(RTRIM(ISNULL(sup.revcode,''))),2,3)
		ELSE LTRIM(RTRIM(ISNULL(sup.revcode,'')))
		END IN ('022')
		) -- CONCLUDE ...
		AND sup.[ClmType] = 'FACILITY' --WHEN formtype LIKE '%UB%' --INCLM
		) -- CONLUDE ...

	-- LTAC (INCLM) --
UPDATE INFORMATICS.dbo.PRESIDIUMHOMELESSCLAIMS
SET [Cx] = 'LTAC'
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM INFORMATICS.dbo.PRESIDIUMHOMELESSCLAIMS AS su
WHERE su.[Cx] IS NULL -- UNIVERSAL
	AND su.claimid IN -- The ENTIRE claim
	( -- INITIATE ...
	SELECT DISTINCT sup.claimid
	-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
	-- SELECT DISTINCT ' ' AS 'CHECK 1st'
	FROM INFORMATICS.dbo.PRESIDIUMHOMELESSCLAIMS AS sup
	WHERE sup.provid IN ('22','911') -- SELECT DISTINCT PROVNM,VENDNM FROM INFORMATICS2.dbo.SHELLprov WHERE PROVIDER_ID IN ('22','911') -- PROMISE HOSPITAL OF SAN DIEGO + SELECT SPECIALTY HOSPITAL - SAN DIEGO
		AND sup.[ClmType] = 'FACILITY' --WHEN formtype LIKE '%UB%' --INCLM
	) -- CONLUDE ...

	-- ER (PSCLM) --
UPDATE INFORMATICS.dbo.PRESIDIUMHOMELESSCLAIMS
SET [Cx] = 'ER (Professional)'
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM INFORMATICS.dbo.PRESIDIUMHOMELESSCLAIMS AS su
WHERE su.[Cx] IS NULL -- UNIVERSAL
	AND su.claimid IN -- The ENTIRE claim
	( -- INITIATE ...
	SELECT DISTINCT sup.claimid
	-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
	-- SELECT DISTINCT ' ' AS 'CHECK 1st'
	FROM INFORMATICS.dbo.PRESIDIUMHOMELESSCLAIMS AS sup
	WHERE sup.location = '23'
		AND sup.[CPT Service Code] NOT BETWEEN '80048' AND '89356' -- EXCLUDE LAB & RAD codes
		AND sup.[CPT Service Code] NOT BETWEEN '70010' AND '79999' -- EXCLUDE LAB & RAD codes
		AND [ClmType] = 'PROFESSIONAL' --WHEN formtype LIKE '%1500%' --PSCLM
		) -- CONCLUDE ...

	-- IP (PSCLM) --
UPDATE INFORMATICS.dbo.PRESIDIUMHOMELESSCLAIMS
SET [Cx] = 'IP (Professional)'
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM INFORMATICS.dbo.PRESIDIUMHOMELESSCLAIMS AS su
WHERE su.[Cx] IS NULL -- UNIVERSAL
	AND su.claimid IN -- The ENTIRE claim
	( -- INITIATE ...
	SELECT DISTINCT sup.claimid
	-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
	-- SELECT DISTINCT ' ' AS 'CHECK 1st'
	FROM INFORMATICS.dbo.PRESIDIUMHOMELESSCLAIMS AS sup
	WHERE sup.location = '21'
		AND [ClmType] = 'PROFESSIONAL' --WHEN formtype LIKE '%1500%' --PSCLM
		) -- CONCLUDE ...

UPDATE INFORMATICS.dbo.PRESIDIUMHOMELESSCLAIMS
SET [Cx] = 'Other COS (Category of Service)' -- LEFT - OVER(S) ...
FROM INFORMATICS.dbo.PRESIDIUMHOMELESSCLAIMS AS su
WHERE su.[Cx] IS NULL

		-- SELECT TOP 10 HOMELESS_INDICATOR,Cx,claimid,revcode,QNXTbilltype,ClmType,[CPT Service Code],location,* FROM INFORMATICS.dbo.PRESIDIUMHOMELESSCLAIMS AS su WHERE ClmType LIKE '%FACILI%'

	-- SUBSET OF [Cx] COS (Category of Service) BH SUD --
UPDATE INFORMATICS.dbo.PRESIDIUMHOMELESSCLAIMS
SET [NOTE(S)] = 'BEHAVIORAL OR SUBSTANCE ABUSE SERVICES'
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st',Cx,[NOTE(S)],[Prindiag Descr]
FROM INFORMATICS.dbo.PRESIDIUMHOMELESSCLAIMS AS su
WHERE su.[NOTE(S)] IS NULL -- UNIVERSAL
	AND su.claimid IN -- The ENTIRE claim
	( -- INITIATE ...
	SELECT DISTINCT sup.claimid
	-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
	-- SELECT DISTINCT ' ' AS 'CHECK 1st'
	FROM INFORMATICS.dbo.PRESIDIUMHOMELESSCLAIMS AS sup
	WHERE sup.[CPT Service Code] IN ('90785','90791','90792','90832','90833','90834','90836','90837','90838','90839','90840','90845','90846','90847','90849','90853','90865','90885','90887','90889','90899') -- per eMAIL ON 20230224 'SUBJECT:HOMELESS FROM:HINA / ADRIAN ... parameters to identify if the members are receiving behavioral or substance abuse services...'
		) -- CONCLUDE ...

	-- SUBSET OF [Cx] COS (Category of Service) BH SUD --
UPDATE INFORMATICS.dbo.PRESIDIUMHOMELESSCLAIMS
SET [NOTE(S)] = 'BEHAVIORAL OR SUBSTANCE ABUSE SERVICES'
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st',Cx,[NOTE(S)],[Prindiag Descr]
FROM INFORMATICS.dbo.PRESIDIUMHOMELESSCLAIMS AS su
WHERE su.[NOTE(S)] IS NULL -- UNIVERSAL
	AND su.claimid IN -- The ENTIRE claim
	( -- INITIATE ...
	SELECT DISTINCT sup.claimid
	-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
	-- SELECT DISTINCT ' ' AS 'CHECK 1st'
	FROM INFORMATICS.dbo.PRESIDIUMHOMELESSCLAIMS AS sup
		JOIN
		( -- INITIATE ...
		SELECT DISTINCT UPPER(LTRIM(RTRIM(ISNULL(pspe.spectype,'')))) AS [Specialty Status]
		,UPPER(LTRIM(RTRIM(ISNULL(spe.specialtycode,'')))) AS SPECcode
		,UPPER(LTRIM(RTRIM(ISNULL(spe.description,'')))) AS SPECdescr
		,pspe.spectype
		,prov.provid
		,prov.fedid
		,prov.NPI
		,prov.ExternalID -- AS [SEQ_PROV_ID]
		,PROVNM = UPPER(LTRIM(RTRIM(ISNULL(prov.fullname,'')))) -- PROVIDER NAME
		,ent.enttype
		,ent.lastname
		,ent.firstname
		,ent.middlename
		,ent.entname
		,PROVcode = UPPER(LTRIM(RTRIM(ISNULL(pt.provtype,'')))) -- PROVTYPE CODE
		,PROVtype = UPPER(LTRIM(RTRIM(ISNULL(pt.[description],'')))) -- PROVTYPE Descr.
		,PROVclass = UPPER(LTRIM(RTRIM(ISNULL(pt.provclass,'')))) -- PROVTYPE Classification
		,PROVaddr1 = UPPER(LTRIM(RTRIM(ISNULL(ent.phyaddr1,''))))
		,PROVaddr2 = UPPER(LTRIM(RTRIM(ISNULL(ent.phyaddr2,''))))
		,PROVcity = UPPER(LTRIM(RTRIM(ISNULL(ent.phycity,''))))
		,PROVstate = SUBSTRING(UPPER(LTRIM(RTRIM(ISNULL(ent.phystate,'')))),1,2)
		,PROVcounty = UPPER(LTRIM(RTRIM(ISNULL(ent.phycounty,'')))) -- •	County, if Plan is multi-county
		,PROVzip = CASE
		WHEN SUBSTRING(LTRIM(RTRIM(ent.phyzip)),1,1) = '0'
		THEN '0'+ SUBSTRING(LTRIM(RTRIM(ent.phyzip)),2,4)
		WHEN SUBSTRING(LTRIM(RTRIM(ent.phyzip)),1,1) = '00'
		THEN '00'+ SUBSTRING(LTRIM(RTRIM(ent.phyzip)),3,3)
		ELSE  SUBSTRING(LTRIM(RTRIM(ent.phyzip)),1,5) 
		END
		,PROVphone = CASE
		WHEN LTRIM(RTRIM(ent.phone)) = ''
		THEN SUBSTRING(REPLACE(LTRIM(RTRIM(ent.emerphone)),'-',''),1,10)
		ELSE SUBSTRING(REPLACE(LTRIM(RTRIM(ent.phone)),'-',''),1,10)
		END
		,PROVmobile = CASE
		WHEN LTRIM(RTRIM(ent.mobilephone)) = ''
		THEN SUBSTRING(REPLACE(LTRIM(RTRIM(ent.secphone)),'-',''),1,10)
		ELSE SUBSTRING(REPLACE(LTRIM(RTRIM(ent.mobilephone)),'-',''),1,10)
		END
		,PROVemail = LTRIM(RTRIM(ent.email))
		-- ,evips.REGION AS [PCP REGION]
		-- SELECT DISTINCT TOP 10 UPPER(LTRIM(RTRIM(ISNULL(spe.description,'')))),*  -- CHECK 1st
		-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
		FROM HMOPROD_PLANDATA.dbo.provider AS prov
			JOIN HMOPROD_PLANDATA.dbo.entity AS ent ON prov.entityid = ent.entid
				LEFT JOIN HMOPROD_PLANDATA.dbo.providertype AS pt ON prov.provtype = pt.provtype
				LEFT JOIN HMOPROD_PLANDATA.dbo.provspecialty AS pspe ON prov.provid = pspe.provid
				LEFT JOIN HMOPROD_PLANDATA.dbo.specialty AS spe ON pspe.specialtycode = spe.specialtycode
		WHERE UPPER(LTRIM(RTRIM(ISNULL(spe.specialtycode,'')))) IN ('ADP','APSC','BA','BHT','BHTH','C00870614','CAP','DBP','DTX','FOP','GEP','GPSC','NDO','PSC','PSY','PSYC','PSYCH','RTC') -- per eMAIL ON 20230224 'SUBJECT:HOMELESS FROM:HINA / ADRIAN ... The rendering provider specialty ON the claim is one of the following: ... parameters to identify if the members are receiving behavioral or substance abuse services...'
		) -- CONCLUDE ...
		AS proviso ON su.provid = proviso.provid
		) -- CONCLUDE ...

		SELECT TOP 10 HOMELESS_INDICATOR,Cx,claimid,revcode,QNXTbilltype,ClmType,[CPT Service Code],location,* FROM INFORMATICS.dbo.PRESIDIUMHOMELESSCLAIMS AS su WHERE ClmType LIKE '%FACILI%'







 -- ========================================================================
	-- CGM ... LIKE '%HCT%' [CATEGORY] ROLLING 18 MONTH(S) --
-- ========================================================================
		SELECT ' ' AS [CGM Cx],DATEADD(MM,-18,TRY_CONVERT(date,GETDATE())) AS [ROLLING BACK MONTH(S)]

UPDATE INFORMATICS.dbo.CGMoutput -- RESET / CLEANSE ...
SET [ER Visits last 18 Months] = CAST(NULL AS int)
,[Admits last 18 Months] = CAST(NULL AS int)

UPDATE INFORMATICS.dbo.CGMoutput
SET [ER Visits last 18 Months] = admit.AdmitID
-- SELECT TOP 100 CAST(NULL AS nvarchar(255)) AS [SPACING],* -- CHECK 1st
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM INFORMATICS.dbo.CGMoutput AS cgm
	JOIN 
	( -- INITIATE ...
	-- ER FAC (INCLM) --
	SELECT ' ER - FAC' AS [CATEGORY],clm.memid
	,COUNT(DISTINCT(CAST(UPPER(LTRIM(RTRIM(ISNULL(clm.memid,'')))) AS varchar(25))+CAST(UPPER(LTRIM(RTRIM(ISNULL(TRY_CONVERT(date,clm.startdate),'')))) AS varchar(10))+CAST(UPPER(LTRIM(RTRIM(ISNULL(a.provid,'')))) AS varchar(25))))AS [AdmitID] -- 'Unique person, date of service, and provider = one visit'  OR 'Unique person, date of service, and NDC = one script'
	--SELECT TOP 100 CAST(NULL AS nvarchar(255)) AS [SPACING],* -- CHECK 1st
	-- SELECT DISTINCT ' ' AS 'CHECK 1st'
	FROM INFORMATICS.dbo.CGMoutput AS cgm
		JOIN HMOPROD_PLANDATA.dbo.claim AS clm ON cgm.memid = clm.memid
		JOIN HMOPROD_PLANDATA.dbo.claimdetail AS cd ON clm.claimid = cd.claimid
		JOIN HMOPROD_PlanData.dbo.benefitplan AS bp ON clm.planid = bp.planid
		-- JOIN INFORMATICS.dbo.[uvw_CLAIMS_PAID] AS paid ON clm.claimid = paid.claimid

		LEFT JOIN 
		( -- INITIATE ...
		SELECT 'REVENUE_CODE' AS [CodeType],ISNULL(rc.description,'') AS [CodeDescr],rc.*
		,CASE
		WHEN SUBSTRING(LTRIM(RTRIM(ISNULL(rc.codeid,''))),1,1) = 'Z'
		THEN  LTRIM(RTRIM(rc.codeid))
		WHEN SUBSTRING(LTRIM(RTRIM(ISNULL(rc.codeid,''))),1,1) = '0'
		THEN  SUBSTRING(LTRIM(RTRIM(ISNULL(rc.codeid,''))),2,3)
		ELSE LTRIM(RTRIM(ISNULL(rc.codeid,'')))
		END AS [REVENUE_CODE]
		-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
		-- SELECT DISTINCT ' ' AS 'CHECK 1st',
		FROM HMOPROD_PLANDATA.dbo.revcode AS rc 
		) -- CONCLUDE ...
		AS revcde ON CASE
		WHEN SUBSTRING(LTRIM(RTRIM(ISNULL(cd.revcode,''))),1,1) = 'Z'
		THEN  LTRIM(RTRIM(cd.revcode))
		WHEN SUBSTRING(LTRIM(RTRIM(ISNULL(cd.revcode,''))),1,1) = '0'
		THEN  SUBSTRING(LTRIM(RTRIM(ISNULL(cd.revcode,''))),2,3)
		ELSE LTRIM(RTRIM(ISNULL(cd.revcode,'')))
		END = revcde.REVENUE_CODE
		
		LEFT JOIN 
		( -- INITIATE ...
		SELECT ' ' AS 'POS (PLACE OF SERVICE)',*
		FROM HMOPROD_PLANDATA.dbo.hcfaposlocation
		) -- CONCLUDE ...
		AS posdescr ON UPPER(LTRIM(RTRIM(ISNULL(cd.location,'')))) = posdescr.locationcode		

		LEFT JOIN 
		( -- INITIATE ...
		SELECT 'CPT - PROCEDURE_CODE' AS [CodeType],ISNULL(sc.description,'') AS [CodeDescr],sc.*
		-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
		-- SELECT DISTINCT ' ' AS 'CHECK 1st',
		FROM HMOPROD_PLANDATA.dbo.svccode AS sc 
		) -- CONCLUDE ...
		AS sp ON SUBSTRING(UPPER(LTRIM(RTRIM(ISNULL(cd.servcode,'')))),1,5) = SUBSTRING(UPPER(LTRIM(RTRIM(ISNULL(sp.codeid,'')))),1,5)

			LEFT JOIN HMOPROD_PLANDATA.dbo.member AS sme ON clm.memid = sme.memid
			LEFT JOIN INFORMATICS.dbo.[uvw_CLAIMS_CLMTYPE] AS ct ON clm.formtype = ct.formtype
			LEFT JOIN INFORMATICS.dbo.[uvw_CLAIMS_BILLTYPE] AS sbt ON (LTRIM(RTRIM(clm.facilitycode))+LTRIM(RTRIM(clm.billclasscode))+LTRIM(RTRIM(clm.frequencycode))) = sbt.QNXTbilltype -- HEADER replacement for POS ON INCLM claims
			LEFT JOIN HMOPROD_PLANDATA.dbo.affiliation AS a ON clm.affiliationid = a.affiliationid -- REMINDER: within claim(s) tables AFFILIATIONID is the relationship between the a.provid = PROVIDER AND the a.affiliateid = PAYTO aka VENDOR
			LEFT JOIN HMOPROD_PLANDATA.dbo.provider AS p1 ON a.provid = p1.provid -- [RENDERING]
			LEFT JOIN HMOPROD_PLANDATA.dbo.provider AS p2 ON a.affiliateid = p2.provid -- [PAYTO] (IPAID)
			-- LEFT JOIN HMOPROD_PLANDATA.dbo.provider AS p3 ON cd.renderingprovid = p3.provid -- RENDERING -- REMOVE AS CAN CAUSE DUP(s) AS OF 20181107
			-- LEFT JOIN INFORMATICS2.dbo.quserWC AS wc ON UPPER(LTRIM(RTRIM(ISNULL(cd.createid,'')))) = UPPER(LTRIM(RTRIM(ISNULL(wc.loginid,'')))) -- IMPORT FROM LEFT JOIN SQLPROD01.HMOPROD_QCSIDB.dbo.quser AS q ON q.userid = cd.createid see 'QUSER_'...xlsx
	WHERE clm.startdate BETWEEN TRY_CONVERT(date,DATEADD(MM,-18,GETDATE())) AND TRY_CONVERT(date,GETDATE()) -- 'ROLLING [RANGE]'
		AND revcde.REVENUE_CODE LIKE '45%'
		AND (sbt.QNXTbilltype  LIKE '13%' --HOSPITAL  OP
			OR sbt.QNXTbilltype  LIKE '14%') --HOSPITAL Oth
		AND ct.[ClmType] = 'FACILITY'
	GROUP BY clm.memid
	) -- CONCLUDE ...
	AS admit ON cgm.memid = admit.memid







UPDATE INFORMATICS.dbo.CGMoutput
SET [Admits last 18 Months] = admit.AdmitID
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM INFORMATICS.dbo.CGMoutput AS cgm
	JOIN 
	( -- INITIATE ...
		-- POS 21 (INCLM) --
	 SELECT '-POS 21' AS [CATEGORY],clm.memid
	,COUNT(DISTINCT(CAST(UPPER(LTRIM(RTRIM(ISNULL(clm.memid,'')))) AS varchar(25))+CAST(UPPER(LTRIM(RTRIM(ISNULL(TRY_CONVERT(date,clm.startdate),'')))) AS varchar(10))+CAST(UPPER(LTRIM(RTRIM(ISNULL(a.provid,'')))) AS varchar(25)))) AS [AdmitID] -- 'Unique person, date of service, and provider = one visit'  OR 'Unique person, date of service, and NDC = one script'
	-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
	-- SELECT DISTINCT ' ' AS 'CHECK 1st'
	FROM INFORMATICS.dbo.CGMoutput AS cgm
		JOIN HMOPROD_PLANDATA.dbo.claim AS clm ON cgm.memid = clm.memid
		JOIN HMOPROD_PLANDATA.dbo.claimdetail AS cd ON clm.claimid = cd.claimid
		JOIN HMOPROD_PlanData.dbo.benefitplan AS bp ON clm.planid = bp.planid
		-- JOIN INFORMATICS.dbo.[uvw_CLAIMS_PAID] AS paid ON clm.claimid = paid.claimid

		LEFT JOIN 
		( -- INITIATE ...
		SELECT 'REVENUE_CODE' AS [CodeType],ISNULL(rc.description,'') AS [CodeDescr],rc.*
		,CASE
		WHEN SUBSTRING(LTRIM(RTRIM(ISNULL(rc.codeid,''))),1,1) = 'Z'
		THEN  LTRIM(RTRIM(rc.codeid))
		WHEN SUBSTRING(LTRIM(RTRIM(ISNULL(rc.codeid,''))),1,1) = '0'
		THEN  SUBSTRING(LTRIM(RTRIM(ISNULL(rc.codeid,''))),2,3)
		ELSE LTRIM(RTRIM(ISNULL(rc.codeid,'')))
		END AS [REVENUE_CODE]
		-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
		-- SELECT DISTINCT ' ' AS 'CHECK 1st',
		FROM HMOPROD_PLANDATA.dbo.revcode AS rc 
		) -- CONCLUDE ...
		AS revcde ON CASE
		WHEN SUBSTRING(LTRIM(RTRIM(ISNULL(cd.revcode,''))),1,1) = 'Z'
		THEN  LTRIM(RTRIM(cd.revcode))
		WHEN SUBSTRING(LTRIM(RTRIM(ISNULL(cd.revcode,''))),1,1) = '0'
		THEN  SUBSTRING(LTRIM(RTRIM(ISNULL(cd.revcode,''))),2,3)
		ELSE LTRIM(RTRIM(ISNULL(cd.revcode,'')))
		END = revcde.REVENUE_CODE
		
		LEFT JOIN 
		( -- INITIATE ...
		SELECT ' ' AS 'POS (PLACE OF SERVICE)',*
		FROM HMOPROD_PLANDATA.dbo.hcfaposlocation
		) -- CONCLUDE ...
		AS posdescr ON UPPER(LTRIM(RTRIM(ISNULL(cd.location,'')))) = posdescr.locationcode		

		LEFT JOIN 
		( -- INITIATE ...
		SELECT 'CPT - PROCEDURE_CODE' AS [CodeType],ISNULL(sc.description,'') AS [CodeDescr],sc.*
		-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
		-- SELECT DISTINCT ' ' AS 'CHECK 1st',
		FROM HMOPROD_PLANDATA.dbo.svccode AS sc 
		) -- CONCLUDE ...
		AS sp ON SUBSTRING(UPPER(LTRIM(RTRIM(ISNULL(cd.servcode,'')))),1,5) = SUBSTRING(UPPER(LTRIM(RTRIM(ISNULL(sp.codeid,'')))),1,5)

			LEFT JOIN HMOPROD_PLANDATA.dbo.member AS sme ON clm.memid = sme.memid
			LEFT JOIN INFORMATICS.dbo.[uvw_CLAIMS_CLMTYPE] AS ct ON clm.formtype = ct.formtype
			LEFT JOIN INFORMATICS.dbo.[uvw_CLAIMS_BILLTYPE] AS sbt ON (LTRIM(RTRIM(clm.facilitycode))+LTRIM(RTRIM(clm.billclasscode))+LTRIM(RTRIM(clm.frequencycode))) = sbt.QNXTbilltype -- HEADER replacement for POS ON INCLM claims
			LEFT JOIN HMOPROD_PLANDATA.dbo.affiliation AS a ON clm.affiliationid = a.affiliationid -- REMINDER: within claim(s) tables AFFILIATIONID is the relationship between the a.provid = PROVIDER AND the a.affiliateid = PAYTO aka VENDOR
			LEFT JOIN HMOPROD_PLANDATA.dbo.provider AS p1 ON a.provid = p1.provid -- [RENDERING]
			LEFT JOIN HMOPROD_PLANDATA.dbo.provider AS p2 ON a.affiliateid = p2.provid -- [PAYTO] (IPAID)
			-- LEFT JOIN HMOPROD_PLANDATA.dbo.provider AS p3 ON cd.renderingprovid = p3.provid -- RENDERING -- REMOVE AS CAN CAUSE DUP(s) AS OF 20181107
			-- LEFT JOIN INFORMATICS2.dbo.quserWC AS wc ON UPPER(LTRIM(RTRIM(ISNULL(cd.createid,'')))) = UPPER(LTRIM(RTRIM(ISNULL(wc.loginid,'')))) -- IMPORT FROM LEFT JOIN SQLPROD01.HMOPROD_QCSIDB.dbo.quser AS q ON q.userid = cd.createid see 'QUSER_'...xlsx

		WHERE clm.startdate BETWEEN TRY_CONVERT(date,DATEADD(MM,-18,GETDATE())) AND TRY_CONVERT(date,GETDATE()) -- 'ROLLING [RANGE]'
			AND (sbt.QNXTbilltype LIKE '11%' --HOSPITAL IP
				OR sbt.QNXTbilltype LIKE '12%') --Hospital - Hospital Based or Inpatient
					AND ct.[ClmType] = 'FACILITY' --WHEN formtype LIKE '%UB%' --INCLM
		GROUP BY clm.memid
		) -- CONCLUDE ...
		AS admit ON cgm.memid = admit.memid







-- ========================================================================
	-- HCT [FIELDNAME] INCLM (FACILITY) --
-- ========================================================================
/* OPTION(s):
		'ER - FAC'
		'OB'
		'POS 21'
		'-NOT21NOT23 aka (INCLM LEFT - OVER(s))' */

	-- reset [FIELDNAME] --
UPDATE TABLENAME
SET [FIELDNAME] = CAST(NULL AS nvarchar(100)) -- POST PRODUCTION QUPD

	-- ER FAC (INCLM) --
UPDATE TABLENAME
SET [FIELDNAME] = ' ER - FAC'
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM TABLENAME AS su
WHERE su.[FIELDNAME] IS NULL -- UNIVERSAL
	AND su.SEQ_CLAIM_ID IN (SELECT DISTINCT sup.SEQ_CLAIM_ID -- The ENTIRE claim
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM TABLENAME AS sup
WHERE sup.REVCDE LIKE '45%'
	AND (sup.QNXTbilltype  LIKE '13%' --HOSPITAL  OP
		OR sup.QNXTbilltype  LIKE '14%') --HOSPITAL Oth
	AND sup.[ClmType] = 'FACILITY')

	-- OB (INCLM) --
UPDATE TABLENAME
SET [FIELDNAME] = '-OB'
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM TABLENAME AS su
WHERE su.[FIELDNAME] IS NULL -- UNIVERSAL
	AND su.SEQ_CLAIM_ID IN (SELECT DISTINCT sup.SEQ_CLAIM_ID -- The ENTIRE claim
FROM TABLENAME AS sup
WHERE sup.REVCDE IN ('112','122','132','142','152')
	AND sup.[ClmType] = 'FACILITY') --WHEN formtype LIKE '%UB%' --INCLM

	-- SNF--	NEW AS OF 20160607
UPDATE TABLENAME
SET [FIELDNAME] = 'SNF' --TYPE: "SNF" FROM D950
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM TABLENAME AS su
WHERE su.[FIELDNAME] IS NULL -- UNIVERSAL
    AND su.SEQ_CLAIM_ID IN (SELECT DISTINCT sup.SEQ_CLAIM_ID -- The ENTIRE claim
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM TABLENAME AS sup
WHERE (LTRIM(RTRIM(sup.QNXTbilltype)) LIKE '21%' --SNF
		OR LTRIM(RTRIM(sup.QNXTbilltype)) LIKE '22%' --SNF
		OR LTRIM(RTRIM(sup.QNXTbilltype)) LIKE '23%' --Per discussion with Ms. Nora & Ms. Cristina ON 20160622
		OR LTRIM(RTRIM(sup.REVCDE)) BETWEEN  '191' AND '193' --SNF
		OR LTRIM(RTRIM(sup.REVCDE)) IN ('022')) --SNF (SKILLED NURSING FACILITY PROSPECTIVE PAYMENT SYSTEM.)
		AND sup.[ClmType] = 'FACILITY') --WHEN formtype LIKE '%UB%' --INCLM

	-- LTAC--	NEW AS OF 20160607
UPDATE TABLENAME
SET [FIELDNAME] = 'LTAC' --TYPE: "LTAC" FROM D950
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM TABLENAME AS su
WHERE su.[FIELDNAME] IS NULL -- UNIVERSAL
    AND su.SEQ_CLAIM_ID IN (SELECT DISTINCT sup.SEQ_CLAIM_ID -- The ENTIRE claim
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM TABLENAME AS sup
WHERE LTRIM(RTRIM(sup.PROVID)) IN ('22','911')) --,'30773','390'))

	-- POS 21 (INCLM) --
UPDATE TABLENAME
SET [FIELDNAME] = '-POS 21'
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM TABLENAME AS su
WHERE su.[FIELDNAME] IS NULL -- UNIVERSAL
    AND su.SEQ_CLAIM_ID IN (SELECT DISTINCT sup.SEQ_CLAIM_ID -- The ENTIRE claim
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM TABLENAME AS sup
WHERE (sup.QNXTbilltype LIKE '11%' --HOSPITAL IP
	OR sup.QNXTbilltype LIKE '12%') --Hospital - Hospital Based or Inpatient
		AND sup.[ClmType] = 'FACILITY') --WHEN formtype LIKE '%UB%' --INCLM

	-- '-NOT21NOT23' aka (INCLM LEFT-OVER(s)) --
UPDATE TABLENAME
SET [FIELDNAME] = '-NOT21NOT23' --OTHER()
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM TABLENAME
WHERE [FIELDNAME] IS NULL -- UNIVERSAL
	AND [ClmType] = 'FACILITY' --WHEN formtype LIKE '%UB%' --INCLM







-- ========================================================================
	-- HCT [FIELDNAME] PSCLM (PROFESSIONAL) --
-- ========================================================================
/* OPTION(s):
		'ER - PROF SVC'
		'- 21'
		'- NOT21NOT23 aka (PSCLM LEFT - OVER(s))' */

	-- ' ER - PROF SVC' (PSCLM) --
UPDATE TABLENAME
SET [FIELDNAME] = ' ER - PROF SVC' 
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM TABLENAME AS su
WHERE su.[FIELDNAME] IS NULL -- UNIVERSAL
    AND su.SEQ_CLAIM_ID IN (SELECT DISTINCT sup.SEQ_CLAIM_ID -- The ENTIRE claim
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM TABLENAME AS sup
WHERE sup.location = '23'
	AND sup.PROCCDE NOT BETWEEN '80048' AND '89356' -- EXCLUDE LAB & RAD codes
	AND sup.PROCCDE NOT BETWEEN '70010' AND '79999' -- EXCLUDE LAB & RAD codes
	AND [ClmType] = 'PROFESSIONAL') --WHEN formtype LIKE '%1500%' --PSCLM

	-- '21' (PSCLM) --
UPDATE TABLENAME
SET [FIELDNAME] = '-21'
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM TABLENAME AS su
WHERE su.[FIELDNAME] IS NULL -- UNIVERSAL
    AND su.SEQ_CLAIM_ID IN (SELECT DISTINCT sup.SEQ_CLAIM_ID -- The ENTIRE claim
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM TABLENAME AS sup
WHERE sup.location = '21'
	AND [ClmType] = 'PROFESSIONAL') --WHEN formtype LIKE '%1500%' --PSCLM

	-- ' NOT21NOT23' (PSCLM) (LEFT-OVER(s)) --
UPDATE TABLENAME
SET [FIELDNAME] = '- NOT21NOT23' --OTHER()
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM TABLENAME AS su
WHERE [FIELDNAME] IS NULL -- UNIVERSAL
	AND [ClmType] = 'PROFESSIONAL' --WHEN formtype LIKE '%1500%' --PSCLM







-- ==========================================================
	-- COS (Category of Service) SIMPLE...--
-- ==========================================================
----------------x SOURCE(s):
----------------		'QNXT' table(s) - 'https://hmoprodqapp01/QNXTALL/QNXT'
----------------		'MS EXCEL IMPORT' table(s) - see 'LBP CY2016 FINAL.xls' [POPULATION]
		
----------------		SELECT * FROM 'SERVERname'.'DATABASEname'.'SCHEMAname'.'OBJECTname' - FOUR (4) PART() SCHEMA()  aka 'SQL01.VIP.dbo.[TABLE]'
----------------		SELECT * FROM INFORMATICS2.dbo.demogLBP
----------------		SELECT * FROM INFORMATICS2.dbo.SHELLunion00_LBP

					--SELECT *
					--FROM [INFORMATICS2].dbo.SHELLproc AS sup
					--WHERE LTRIM(RTRIM(sup.PROCEDURE_CODE)) IN ('72010','72020','72052','72100','72110','72114','72120','72131','72132','72133','72141','72142','72146','72147','72148','72149','72156','72158','72200','72202') --Imaging study is defined as:

					--SELECT *
					--FROM [INFORMATICS2].dbo.SHELLrevcde AS sup
					--WHERE LTRIM(RTRIM(sup.REVENUE_CODE)) IN ('320','329','350','352','359','610','612','614','619','972') --Imaging study is defined as:

	--RESET Cx--
UPDATE [INFORMATICS2].dbo.[SHELLunion00_LBP]
SET Cx = CAST(NULL AS nvarchar(100)) --CLEANSE()

	--'Imaging Study'--
UPDATE [INFORMATICS2].dbo.[SHELLunion00_LBP]
SET Cx = 'Imaging Study'
-- SELECT TOP 10 ' ' AS 'CHECK 1st',*
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM [INFORMATICS2].dbo.[SHELLunion00_LBP] AS su
WHERE UPPER(LTRIM(RTRIM(ISNULL(su.REVCDE,'')))) IN ('320','329','350','352','359','610','612','614','619','972') --Imaging study is defined as:
	OR UPPER(LTRIM(RTRIM(ISNULL(su.PROCEDURE_CODE,'')))) IN ('72010','72020','72052','72100','72110','72114','72120','72131','72132','72133','72141','72142','72146','72147','72148','72149','72156','72158','72200','72202') --Imaging study is defined as:
	
	
	
	

	
	
-- ==========================================================
	-- COS (Category of Service) AS [Cx]--
-- ==========================================================
-- SELECT TOP 10 * FROM INFORMATICS2.dbo.SHELL_Rx_RDT
-- SELECT TOP 10 * FROM [INFORMATICS2].dbo.[SHELLunion00_RDT]

/* 4. The categories of service are listed IN hierarchical order and should be followed when claims meet criteria for more than one COS. For Example, if a claim meets criteria for both Inpatient and Emergency Room, the claim would be assigned to Inpatient because Inpatient is listed higher ON the hierarchy than Emergency Room. */

/* 5. Any one claim/encounter gets classified into only one COS. Therefore, if a claim has multiple detail lines with varying COS assignments, use the hierarchy to decide which COS the entire claim will be assigned to. */

			-- x COS HIERARCHY (19):
					-- 'Inpatient Hospital'
					-- 'Community-Based Adult Services (CBAS)'
					-- 'Emergency Room'
					-- 'Outpatient Facility'
					-- 'Behavioral Health Treatment (BHT)'
					-- 'Mental Health - Outpatient'
					-- 'Long-Term Care'  
					-- 'Federally Qualified Health Center (FQHC)'
					-- 'Specialty Physician'
					-- 'Primary Care Physician'
					-- 'Hospice'
					-- 'Multipurpose Senior Services Program (MSSP)'
					-- 'In-Home Supportive Services (IHSS)'
					-- 'HCBS Other'
					-- 'Lab and Radiology'
					-- 'Pharmacy'
					-- 'Transportation'
					-- 'All Other'  --FACILITY LIKE '%UB%' (INCLM)
					-- 'Other Medical Professional'  --PROFESSIONAL LIKE '%1500%' (PSCLM)

	-- RESET() Cx--
UPDATE [INFORMATICS2].dbo.[SHELLunion00_RDT]
SET Cx = CAST(NULL AS nvarchar(100)) --CLEANSE()

	-- 'Inpatient Hospital'--
UPDATE [INFORMATICS2].dbo.[SHELLunion00_RDT]
SET Cx = 'Inpatient Hospital'
-- SELECT TOP 10 * -- CHECK 1st
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM [INFORMATICS2].dbo.[SHELLunion00_RDT] AS su
WHERE (su.Cx IS NULL
    AND su.SEQ_CLAIM_ID IN (SELECT DISTINCT sup.SEQ_CLAIM_ID -- The ENTIRE claim
FROM [INFORMATICS2].dbo.[SHELLunion00_RDT] AS sup
WHERE (sup.BILL_TYPE LIKE '11%' --HOSPITAL IP
	OR sup.BILL_TYPE LIKE '12%') --Hospital - Hospital Based or Inpatient
		AND sup.[CLM TYPE] = 'FACILITY'))
OR (su.Cx IS NULL
	AND UPPER(LTRIM(RTRIM(ISNULL(PROVSPEC,'')))) IN ('ASC','BRC')) -- ADD ON per RDT CCI DISCUSSION / email FROM MS. NIKKITA see SUBJECT: RDT CCI Cx UPDATE(s) - RE: Discuss CCI RDT ON 20180503 AND see ''COS Updates_'...xlsx







	-- Community-Based Adult Services (CBAS) --	
UPDATE [INFORMATICS2].dbo.[SHELLunion00_RDT]
SET Cx = 'Community-Based Adult Services (CBAS)'
-- SELECT TOP 10 * -- CHECK 1st
-- SELECT DISTINCT su.Cx,su.PROVTYPE,su.PROVSPEC,su.PROVSPEC_DESCR,su.PROCEDURE_CODE,su.[PROCCDE DESCR],su.BILL_TYPE
FROM [INFORMATICS2].dbo.[SHELLunion00_RDT] AS su
WHERE (su.Cx IS NULL
    AND su.SEQ_CLAIM_ID IN (SELECT DISTINCT sup.SEQ_CLAIM_ID -- The ENTIRE claim
FROM [INFORMATICS2].dbo.[SHELLunion00_RDT] AS sup
WHERE UPPER(LTRIM(RTRIM(ISNULL(sup.PROCEDURE_CODE,'')))) IN ('H2000','T1023','S5102','S5101','S5100')))
	OR (su.Cx IS NULL
		AND UPPER(LTRIM(RTRIM(ISNULL(PROVSPEC,'')))) = 'ADHC')
	OR (su.Cx IS NULL
		AND LTRIM(RTRIM(BILL_TYPE)) IN ('891')) -- CBAS (Community Based Adult Services) Admit
		






	-- Emergency Room--
UPDATE [INFORMATICS2].dbo.[SHELLunion00_RDT]
SET Cx = 'Emergency Room'
-- SELECT TOP 10 * -- CHECK 1st
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM [INFORMATICS2].dbo.[SHELLunion00_RDT] AS su
WHERE (su.Cx IS NULL
	AND su.SEQ_CLAIM_ID IN (SELECT DISTINCT sup.SEQ_CLAIM_ID -- The ENTIRE claim
FROM [INFORMATICS2].dbo.[SHELLunion00_RDT] AS sup
WHERE sup.REVCDE LIKE '45%'
	AND (sup.BILL_TYPE  LIKE '13%' --HOSPITAL OP
		OR sup.BILL_TYPE  LIKE '14%') --HOSPITAL OP
	AND sup.[CLM TYPE] = 'FACILITY')) --claim.formtype LIKE '%UB%' INCLM = FACILITY
OR (su.Cx IS NULL
	AND su.SEQ_CLAIM_ID IN (SELECT DISTINCT sup.SEQ_CLAIM_ID -- The ENTIRE claim
FROM [INFORMATICS2].dbo.[SHELLunion00_RDT] AS sup
WHERE SUBSTRING(UPPER(LTRIM(RTRIM(ISNULL(su.PROCEDURE_CODE,'')))),1,5) IN ('Z7500','Z7502','99281','99282','99283','99284','99285')
	AND (sup.BILL_TYPE  LIKE '13%' --HOSPITAL OP
			OR sup.BILL_TYPE  LIKE '14%') --HOSPITAL OP
	AND sup.[CLM TYPE] = 'FACILITY')) --claim.formtype LIKE '%UB%' INCLM = FACILITY







	-- 'Outpatient Facility'--
UPDATE [INFORMATICS2].dbo.[SHELLunion00_RDT]
SET Cx = 'Outpatient Facility'
-- SELECT TOP 10 * -- CHECK 1st
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM [INFORMATICS2].dbo.[SHELLunion00_RDT]
WHERE (Cx IS NULL
	AND (BILL_TYPE  LIKE '13%' --HOSPITAL OP
		OR BILL_TYPE  LIKE '14%') --HOSPITAL OP
	AND [CLM TYPE] = 'FACILITY') --claim.formtype LIKE '%UB%' INCLM = FACILITY
OR (Cx IS NULL
	AND UPPER(LTRIM(RTRIM(ISNULL(PROVSPEC,'')))) IN ('DLC')) --ADD ON per 20180525 DISCUSSION(s) Please add ProvSpec of 'DLC' to the Outpatient Facility Category of Service		







	-- Behavioral Health Treatment (BHT) --	
UPDATE [INFORMATICS2].dbo.[SHELLunion00_RDT]
SET Cx = 'Behavioral Health Treatment (BHT)' -- 'Member Age = Less than 21'
-- SELECT TOP 10 * -- CHECK 1st
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM [INFORMATICS2].dbo.[SHELLunion00_RDT] AS su
WHERE (su.Cx IS NULL
	AND (su.[MEMBER_TRUE_CHRONOLOGICAL_AGE] < 21 
		OR (su.[MEMBER_TRUE_CHRONOLOGICAL_AGE] = 21
			AND su.[MEMBER_TRUE_CHRONOLOGICAL_AGE_AND_HOW_MANY_MTHs] = 0)) -- SET MEMBER_AGE = CAST(DATEDIFF("d",CAST(sme.dob AS datetime),CAST(su.PRIMARY_SVC_DATE AS datetime))/365.25 AS money) -- AGE determination: an individual is considered TO BE THE SPECIFIED AGE the month after they turn THE SPECIFIED AGE. This is the same methodology used by DHCS for enrollment and payment processing. 1/12 = 0.8333333333 OR (20.917 / 17.917)]
    AND su.SEQ_CLAIM_ID IN (SELECT DISTINCT sup.SEQ_CLAIM_ID -- The ENTIRE claim
FROM [INFORMATICS2].dbo.[SHELLunion00_RDT] AS sup
WHERE (UPPER(LTRIM(RTRIM(sup.prindiag))) IN ('F84.0') --Criteria #1: Autism Diagnosis Codes
	OR UPPER(LTRIM(RTRIM(sup.DIAGNOSIS_1))) IN ('F84.0') --Criteria #1: Autism Diagnosis Codes
	OR UPPER(LTRIM(RTRIM(sup.DIAGNOSIS_2))) IN ('F84.0') --Criteria #1: Autism Diagnosis Codes
	OR UPPER(LTRIM(RTRIM(sup.DIAGNOSIS_3))) IN ('F84.0') --Criteria #1: Autism Diagnosis Codes
	OR UPPER(LTRIM(RTRIM(sup.DIAGNOSIS_4))) IN ('F84.0') --Criteria #1: Autism Diagnosis Codes
	OR UPPER(LTRIM(RTRIM(sup.DIAGNOSIS_5))) IN ('F84.0') --Criteria #1: Autism Diagnosis Codes
	OR UPPER(LTRIM(RTRIM(sup.DIAGNOSIS_6))) IN ('F84.0') --Criteria #1: Autism Diagnosis Codes
	OR UPPER(LTRIM(RTRIM(sup.DIAGNOSIS_7))) IN ('F84.0') --Criteria #1: Autism Diagnosis Codes
	OR UPPER(LTRIM(RTRIM(sup.DIAGNOSIS_8))) IN ('F84.0') --Criteria #1: Autism Diagnosis Codes
	OR UPPER(LTRIM(RTRIM(sup.DIAGNOSIS_9))) IN ('F84.0')) --Criteria #1: Autism Diagnosis Codes
		AND SUBSTRING(UPPER(LTRIM(RTRIM(ISNULL(sup.PROCEDURE_CODE,'')))),1,5) IN ('H0031','H0032','H0046','H2012','H2014','H2019','S5111','S5108','96152'))) --,'S5108'))  --Criteria #2: Codes that trigger a BHT supplemental payment AND For monthly utilizer counts, please only count a utilizer month when a member utilized a procedure code ON the supplemental payment trigger list (Criteria #2 ON the [COS Grouping] tab). If a member had no utilization of a trigger service (i.e. only had costs categorized under non-trigger codes or CDEs), THEN do not record a utilizer month, however please still report the non-trigger and/or CDE experience for all members. ADDED 'S5108','96152' --Direct Member Unique Utilizers (DUU) for CY 2016:  Enter the count of unique utilizers (not utilizer months) for CY 2016. A member is a unique utilizer if they utilized any BHT service at any time IN CY 2016 (i.e. they were counted at least once IN the utilizer month column, and your health plan received a supplemental payment for the member). This is for direct members only; do not enter unique utilizer counts for global members. Also, do NOT count a member as a unique utilizer if they only received a CDE and not a BHT service IN CY 2016.)) --,'S5108'))
OR (su.Cx IS NULL
	AND (su.[MEMBER_TRUE_CHRONOLOGICAL_AGE] < 21 
		OR ([MEMBER_TRUE_CHRONOLOGICAL_AGE] = 21
			AND [MEMBER_TRUE_CHRONOLOGICAL_AGE_AND_HOW_MANY_MTHs] = 0)) -- SET MEMBER_AGE = CAST(DATEDIFF("d",CAST(sme.dob AS datetime),CAST(su.PRIMARY_SVC_DATE AS datetime))/365.25 AS money) -- AGE determination: an individual is considered TO BE THE SPECIFIED AGE the month after they turn THE SPECIFIED AGE. This is the same methodology used by DHCS for enrollment and payment processing. 1/12 = 0.8333333333 OR (20.917 / 17.917)]
	AND UPPER(LTRIM(RTRIM(ISNULL(PROVSPEC,'')))) IN ('BHT')) -- ADD ON per RDT CCI DISCUSSION / email FROM MS. NIKKITA see SUBJECT: RDT CCI Cx UPDATE(s) - RE: Discuss CCI RDT ON 20180503 AND see ''COS Updates_'...xlsx		
	
	-- Behavioral Health Treatment (BHT) --	
UPDATE [INFORMATICS2].dbo.[SHELLunion00_RDT]
SET Cx = 'Behavioral Health Treatment (BHT)' -- 'Member Age = Less than 21'
-- SELECT TOP 10 * -- CHECK 1st
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM [INFORMATICS2].dbo.[SHELLunion00_RDT] AS su
WHERE su.Cx IS NULL
	AND (su.[MEMBER_TRUE_CHRONOLOGICAL_AGE] < 21 
		OR (su.[MEMBER_TRUE_CHRONOLOGICAL_AGE] = 21
			AND su.[MEMBER_TRUE_CHRONOLOGICAL_AGE_AND_HOW_MANY_MTHs] = 0)) -- SET MEMBER_AGE = CAST(DATEDIFF("d",CAST(sme.dob AS datetime),CAST(su.PRIMARY_SVC_DATE AS datetime))/365.25 AS money) -- AGE determination: an individual is considered TO BE THE SPECIFIED AGE the month after they turn THE SPECIFIED AGE. This is the same methodology used by DHCS for enrollment and payment processing. 1/12 = 0.8333333333 OR (20.917 / 17.917)]
    AND su.SEQ_CLAIM_ID IN (SELECT DISTINCT sup.SEQ_CLAIM_ID -- The ENTIRE claim
FROM [INFORMATICS2].dbo.[SHELLunion00_RDT] AS sup
WHERE (UPPER(LTRIM(RTRIM(sup.prindiag))) IN ('F84.0') --Criteria #1: Autism Diagnosis Codes
	OR UPPER(LTRIM(RTRIM(sup.DIAGNOSIS_1))) IN ('F84.0') --Criteria #1: Autism Diagnosis Codes
	OR UPPER(LTRIM(RTRIM(sup.DIAGNOSIS_2))) IN ('F84.0') --Criteria #1: Autism Diagnosis Codes
	OR UPPER(LTRIM(RTRIM(sup.DIAGNOSIS_3))) IN ('F84.0') --Criteria #1: Autism Diagnosis Codes
	OR UPPER(LTRIM(RTRIM(sup.DIAGNOSIS_4))) IN ('F84.0') --Criteria #1: Autism Diagnosis Codes
	OR UPPER(LTRIM(RTRIM(sup.DIAGNOSIS_5))) IN ('F84.0') --Criteria #1: Autism Diagnosis Codes
	OR UPPER(LTRIM(RTRIM(sup.DIAGNOSIS_6))) IN ('F84.0') --Criteria #1: Autism Diagnosis Codes
	OR UPPER(LTRIM(RTRIM(sup.DIAGNOSIS_7))) IN ('F84.0') --Criteria #1: Autism Diagnosis Codes
	OR UPPER(LTRIM(RTRIM(sup.DIAGNOSIS_8))) IN ('F84.0') --Criteria #1: Autism Diagnosis Codes
	OR UPPER(LTRIM(RTRIM(sup.DIAGNOSIS_9))) IN ('F84.0')) --Criteria #1: Autism Diagnosis Codes
		AND SUBSTRING(UPPER(LTRIM(RTRIM(ISNULL(sup.PROCEDURE_CODE,'')))),1,5) IN ('0364T','0370T','0365T','0371T','0366T','0372T','0367T','0373T','0368T','0374T','0369T')) --Criteria #3: Codes that reflect BHT services, but do not trigger a BHT supplemental payment. The cost for these services will be included IN the BHT supplemental payment amount. --Direct Member Unique Utilizers (DUU) for CY 2016:  Enter the count of unique utilizers (not utilizer months) for CY 2016. A member is a unique utilizer if they utilized any BHT service at any time IN CY 2016 (i.e. they were counted at least once IN the utilizer month column, and your health plan received a supplemental payment for the member). This is for direct members only; do not enter unique utilizer counts for global members. Also, do NOT count a member as a unique utilizer if they only received a CDE and not a BHT service IN CY 2016.
	
	-- Behavioral Health Treatment (BHT) --
UPDATE [INFORMATICS2].dbo.[SHELLunion00_RDT]
SET Cx = 'Behavioral Health Treatment (BHT)' -- 'Member Age = Less than 21'
-- SELECT TOP 10 * -- CHECK 1st
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM [INFORMATICS2].dbo.[SHELLunion00_RDT] AS su
WHERE su.Cx IS NULL
	AND (su.[MEMBER_TRUE_CHRONOLOGICAL_AGE] < 21 
		OR (su.[MEMBER_TRUE_CHRONOLOGICAL_AGE] = 21
			AND su.[MEMBER_TRUE_CHRONOLOGICAL_AGE_AND_HOW_MANY_MTHs] = 0)) -- SET MEMBER_AGE = CAST(DATEDIFF("d",CAST(sme.dob AS datetime),CAST(su.PRIMARY_SVC_DATE AS datetime))/365.25 AS money) -- AGE determination: an individual is considered TO BE THE SPECIFIED AGE the month after they turn THE SPECIFIED AGE. This is the same methodology used by DHCS for enrollment and payment processing. 1/12 = 0.8333333333 OR (20.917 / 17.917)]
    AND SUBSTRING(UPPER(LTRIM(RTRIM(ISNULL(su.PROCEDURE_CODE,'')))),1,5) IN ('90791','90792','96101','96102','96103','96105','96111','96116','96118','96119','96120','90785','0359T','0360T','0361T','0362T','0363T') --,'96152') --Criteria #4: Comprehensive Diagnostic Evaluation (CDE) services performed with the intent to determine an autism diagnosis LIMIT ON PROVIDER(s) NECESSARY TO ENSURE that the Comprehensive Diagnostic Evaluation (CDE) services is being performed with the INTENT to determine an autism diagnosis ADDED 'S5108','96152'
	AND (su.PROVID IN ('307271','147873','698','5492','330541971') --RENDERING()
		OR su.VENDID IN ('307271','147873','698','5492','330541971')) --PAYTO(s)
	----------------AND (su.PROVNM LIKE '%MOTIVA%' --RENDERING
	----------------	OR su.VENDNM LIKE '%MOTIVA%' --PAYTO
	----------------	OR su.PROVNM LIKE '%REGENT%' --RENDERING
	----------------	OR su.VENDNM LIKE '%REGENT%' --PAYTO
	----------------	OR su.PROVNM LIKE '%RADY%' --RENDERING
	----------------	OR su.VENDNM LIKE '%RADY%') --PAYTO







	-- Mental Health - Outpatient--
UPDATE [INFORMATICS2].dbo.[SHELLunion00_RDT]
SET Cx = 'Mental Health - Outpatient'
--SELECT DISTINCT su.Cx,su.PROVTYPE,su.PROVSPEC,su.PROVSPEC_DESCR,su.PROCEDURE_CODE,su.[PROCCDE DESCR]
FROM [INFORMATICS2].dbo.[SHELLunion00_RDT] AS su
WHERE (su.Cx IS NULL
	AND UPPER(LTRIM(RTRIM(ISNULL(PROVSPEC,'')))) IN ('APSC','CAP','GEP','GPSC','PSC','PSY','PSYC','PSYCH')) -- ADD ON per 20180525 DISCUSSIONPlease add a line to the Mental Health-Outpatient Category of Service to capture the remaining PSY ProvSpec	 		Where the Cx is null and ProvSpec = 'PSY'   (I believe this will be added to the first where clause of this update)
OR (su.Cx IS NULL
	AND SUBSTRING(UPPER(LTRIM(RTRIM(ISNULL(su.PROCEDURE_CODE,'')))),1,5) IN ('90791','90792','90863','4064F','4063F','90833','90836','90838') --Criteria #2: Subgroup of Mental Health - Outpatient: Psychiatrist
	AND UPPER(LTRIM(RTRIM(ISNULL(PROVSPEC,'')))) IN ('APSC','CAP','GEP','GPSC','PSC','PSY','PSYC','PSYCH')) -- ADD ON per RDT CCI DISCUSSION / email FROM MS. NIKKITA see SUBJECT: RDT CCI Cx UPDATE(s) - RE: Discuss CCI RDT ON 20180503 AND see ''COS Updates_'...xlsx
OR (su.Cx IS NULL
	AND su.SEQ_CLAIM_ID IN (SELECT DISTINCT supp.SEQ_CLAIM_ID -- The ENTIRE claim
FROM [INFORMATICS2].dbo.SHELLprov AS p
	JOIN [INFORMATICS2].dbo.[SHELLunion00_RDT] AS supp ON LTRIM(RTRIM(supp.PROVID)) = LTRIM(RTRIM(p.PROVIDER_ID))
WHERE p.LICENSE LIKE '%LCS%' --Criteria #1: Subgroup of Mental Health - Outpatient: Mental Health - Other - Licensed Clinical Social Worker (LCSW)
	AND UPPER(LTRIM(RTRIM(ISNULL(PROVSPEC,'')))) IN ('APSC','CAP','GEP','GPSC','PSC','PSY','PSYC','PSYCH'))) -- ADD ON per RDT CCI DISCUSSION / email FROM MS. NIKKITA see SUBJECT: RDT CCI Cx UPDATE(s) - RE: Discuss CCI RDT ON 20180503 AND see ''COS Updates_'...xlsx
	-- OR supp.PROVSPEC_DESCR LIKE '%PSY%'))
OR (su.Cx IS NULL
	AND SUBSTRING(UPPER(LTRIM(RTRIM(ISNULL(su.PROCEDURE_CODE,'')))),1,5) IN ('90785','90792','90845','90847','90791','90846','90849','90832','90834','90837','90839','90840','90853','96101','96105','96110','96111','96116','96118','96120','99366','99368','Z0300') --Criteria #2: Subgroup of Mental Health - Outpatient: Mental Health - Other
	AND UPPER(LTRIM(RTRIM(ISNULL(PROVSPEC,'')))) IN ('APSC','CAP','GEP','GPSC','PSC','PSY','PSYC','PSYCH')) -- ADD ON per RDT CCI DISCUSSION / email FROM MS. NIKKITA see SUBJECT: RDT CCI Cx UPDATE(s) - RE: Discuss CCI RDT ON 20180503 AND see ''COS Updates_'...xlsx







	-- Long-Term Care--
UPDATE [INFORMATICS2].dbo.[SHELLunion00_RDT]
SET Cx = 'Long-Term Care' 
-- SELECT TOP 10 * -- CHECK 1st
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM [INFORMATICS2].dbo.[SHELLunion00_RDT] AS su
WHERE (su.Cx IS NULL
	AND (LTRIM(RTRIM(su.REVCDE)) IN ('101', '190') --Ltc CPT codes (see authservice.codeid AND authservice.servcategory) ALSO STEP88-MEMBER_CONDITIONs...sql
		OR LTRIM(RTRIM(REVCDE)) IN ('120','110','130') --LTC
		OR LTRIM(RTRIM(REVCDE)) BETWEEN  '180' AND '189') --LTC
	AND su.[CLM TYPE] = 'FACILITY') --claim.formtype LIKE '%UB%' INCLM = FACILITY
OR (su.Cx IS NULL
	AND su.SEQ_CLAIM_ID IN (SELECT DISTINCT sup.SEQ_CLAIM_ID -- The ENTIRE claim
FROM [INFORMATICS2].dbo.[SHELLunion00_RDT] AS sup
WHERE LTRIM(RTRIM(sup.PROVID)) IN ('22','911')
	OR LTRIM(RTRIM(sup.VENDID)) IN ('22','911')))
OR (su.Cx IS NULL --'NF (Nursing Facility)' --SNF (Skilled Nursing Facility) see 'Core 9.2 
	AND (LTRIM(RTRIM(BILL_TYPE)) LIKE '21%' --SNF
		OR LTRIM(RTRIM(BILL_TYPE)) LIKE '22%' --SNF
		OR LTRIM(RTRIM(REVCDE)) BETWEEN  '191' AND '193' --SNF
		OR LTRIM(RTRIM(BILL_TYPE)) LIKE '23%' --Per discussion with Ms. Nora & Ms. Cristina ON 20160622
		OR LTRIM(RTRIM(REVCDE)) IN ('022')) --SNF (SKILLED NURSING FACILITY PROSPECTIVE PAYMENT SYSTEM.)
	AND [CLM TYPE] = 'FACILITY') --claim.formtype LIKE '%UB%' INCLM = FACILITY)
OR (su.Cx IS NULL
	AND UPPER(LTRIM(RTRIM(ISNULL(PROVSPEC,'')))) IN ('LTACH')) -- ADD ON per RDT CCI DISCUSSION / email FROM MS. NIKKITA see SUBJECT: RDT CCI Cx UPDATE(s) - RE: Discuss CCI RDT ON 20180503 AND see ''COS Updates_'...xlsx	







	-- Federally Qualified Health Center (FQHC) --
UPDATE [INFORMATICS2].dbo.[SHELLunion00_RDT]
SET Cx = 'Federally Qualified Health Center (FQHC)'
-- SELECT TOP 10 * -- CHECK 1st
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM [INFORMATICS2].dbo.[SHELLunion00_RDT] AS c
	JOIN [INFORMATICS].dbo.[uvw_PROVIDER_FQHC] AS fqhc ON c.PAYTO = fqhc.provid
WHERE Cx IS NULL
	AND LTRIM(RTRIM([FQHC FLAG])) = 'FQHC'
	OR (Cx IS NULL
		AND UPPER(LTRIM(RTRIM(ISNULL(PLACE_OF_SERVICE_1,'')))) = '50')







	-- Specialty Physician-- 
UPDATE [INFORMATICS2].dbo.[SHELLunion00_RDT]
SET Cx = 'Specialty Physician'
-- SELECT TOP 10 * -- CHECK 1st
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM [INFORMATICS2].dbo.[SHELLunion00_RDT]
WHERE (Cx IS NULL
     AND [CLM TYPE] = 'PROFESSIONAL' --claim.formtype LIKE '%1500%' (PSCLM = PROFESSIONAL)
	AND UPPER(LTRIM(RTRIM(ISNULL(PROVSPEC,'')))) IN ('MON','ACP','ALL','ANE','CBM','CCM','CGN','CMG','CN','CPA','CRS','CRV','DBP','DER','DMD','DPA','DRD','END','ERM','GAS','GON','GVS','HAS','HEM','HPLT','IND','IVC','MBG','MFM','MGN','NEP','NEU','NMM','NPA','NPM','NRD','NTO','NUM','NUR','NUS','OMS','OPH','ORS','OTL','PAA','PAC','PAT','PCC','PCR','PDI','PDM','PDP','PDS','PEM','PEN','PGE','PHO','PID','PLS','PMR','PNM','PNP','POT','PPA','PRD','PRH','PUD','PURO','RAD','RDO','RDP','REN','RHE','SCC','SCR','SPM','SUR','THS','TPH','TSO','URO','VIR','NPM')) -- ADD ON per RDT CCI DISCUSSION / email FROM MS. NIKKITA see SUBJECT: RDT CCI Cx UPDATE(s) - RE: Discuss CCI RDT ON 20180503 AND see ''COS Updates_'...xlsx
    -- AND PROVSPEC NOT IN ('FAM','GNP','INM','OBG','PED','CLL') --RDT / Mercer suggested TYPE(s) '...Pediatrics, OB/GYN, Family Practice, General Practice, Internal Medicine, or Other. If provider specializes IN more than one field, enter additional Specialty Records (rows) for each specialty...'







	-- Primary Care Physician--
UPDATE [INFORMATICS2].dbo.[SHELLunion00_RDT]
SET Cx = 'Primary Care Physician'
-- SELECT TOP 10 * -- CHECK 1st
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM [INFORMATICS2].dbo.[SHELLunion00_RDT]
WHERE (Cx IS NULL
    AND [CLM TYPE] = 'PROFESSIONAL' --claim.formtype LIKE '%1500%' (PSCLM = PROFESSIONAL)
    AND UPPER(LTRIM(RTRIM(ISNULL(PROVSPEC,'')))) IN ('FAM','GER','GNP','GYN','MSC','INM','OB','OBG','PED')) -- RDT / Mercer suggested TYPE(s) '...Pediatrics, OB/GYN, Family Practice, General Practice, Internal Medicine, or Other. If provider specializes IN more than one field, enter additional Specialty Records (rows) for each specialty...'







	-- Hospice--
UPDATE [INFORMATICS2].dbo.[SHELLunion00_RDT]
SET Cx = 'Hospice'
--SELECT DISTINCT PROVTYPE,PROVSPEC,PROVSPEC_DESCR,PROCEDURE_CODE,[PROCCDE DESCR],PLACE_OF_SERVICE_1
FROM [INFORMATICS2].dbo.[SHELLunion00_RDT]
WHERE (Cx IS NULL
	--AND UPPER(UPPER(LTRIM(RTRIM(ISNULL(PROVSPEC,''))))) = 'HSP'
	AND (BILL_TYPE LIKE '81%'
		OR BILL_TYPE LIKE '82%')
		AND UPPER(LTRIM(RTRIM(ISNULL(PROVSPEC,'')))) IN ('HPM','HSP')) -- ADD ON per RDT CCI DISCUSSION / email FROM MS. NIKKITA see SUBJECT: RDT CCI Cx UPDATE(s) - RE: Discuss CCI RDT ON 20180503 AND see ''COS Updates_'...xlsx
		OR (Cx IS NULL
			AND LTRIM(RTRIM(PLACE_OF_SERVICE_1)) IN('34','13')
			AND UPPER(LTRIM(RTRIM(ISNULL(PROVSPEC,'')))) IN ('HPM','HSP')) -- ADD ON per RDT CCI DISCUSSION / email FROM MS. NIKKITA see SUBJECT: RDT CCI Cx UPDATE(s) - RE: Discuss CCI RDT ON 20180503 AND see ''COS Updates_'...xlsx







	-- Multipurpose Senior Services Program (MSSP) --
/* UPDATE [INFORMATICS2].dbo.[SHELLunion00_RDT]
SET Cx = 'Multipurpose Senior Services Program (MSSP)'
FROM [INFORMATICS2].dbo.[SHELLunion00_RDT]
WHERE (Cx IS NULL
	AND '') */







	-- In-Home Supportive Services (IHSS) -- MANUAL REORDER AFTER 20171101 DISCUSSION GUIDE CALL
UPDATE [INFORMATICS2].dbo.[SHELLunion00_RDT]
SET Cx = 'In-Home Supportive Services (IHSS)'
FROM [INFORMATICS2].dbo.[SHELLunion00_RDT]
WHERE (Cx IS NULL
	AND (PROVID IN ('162447')
		OR VENDID IN ('162447'))) --SAFE HARBOR - ID# 162447 PROVIDER TYPE: IN HOME SUPPORT SERVICES
OR (Cx IS NULL
	AND UPPER(LTRIM(RTRIM(ISNULL(PROVSPEC,'')))) IN ('HHC')) -- ADD ON per RDT CCI DISCUSSION / email FROM MS. NIKKITA see SUBJECT: RDT CCI Cx UPDATE(s) - RE: Discuss CCI RDT ON 20180503 AND see ''COS Updates_'...xlsx

					---------------- 'IHSS PROVID / VENDID???' - SAFE HARBOR - ID# 162447
					---------------- PROVIDER TYPE: IN HOME SUPPORT
					---------------- SERVICES
					---------------- 1810 GILLESPIE WAY SUITE 207
					---------------- EL CAJON, CA 92020
					---------------- (619) 749-2665
					---------------- NPI: 1699094003
					---------------- LICENSE: 023285
					---------------- ACCREDITATION: NO
					---------------- ACCEPTING NEW PATIENTS: YES
					---------------- BUSINESS HOURS: MON-FRI 8AM-5PM
					---------------- ACCESS BY PUBLIC
					---------------- TRANSPORTATION: YES
					---------------- ACCESS: NA
					---------------- NA
					---------------- AGE RESTRICTIONS:

					---------------- SELECT Cx,PROVNM,VENDNM,PAID_NET_AMT,*
					---------------- FROM INFORMATICS2.dbo.SHELLunion00_RDT_RDT_20161118
					---------------- WHERE PROVID IN ('162447')
					--------------	-- OR VENDID IN ('162447')







	--HCBS Other (Home and Community Based Servcies Other) --
UPDATE [INFORMATICS2].dbo.[SHELLunion00_RDT]
SET Cx = 'HCBS Other'
-- SELECT TOP 10 * -- CHECK 1st
-- SELECT DISTINCT PROVTYPE,PROVSPEC,PROVSPEC_DESCR,PROCEDURE_CODE,[PROCCDE DESCR],PLACE_OF_SERVICE_1,*
FROM [INFORMATICS2].dbo.[SHELLunion00_RDT]
WHERE (Cx IS NULL
	AND (BILL_TYPE LIKE '81%' --Hospice - Non-Hospital Based...
		OR BILL_TYPE LIKE '82%' --Hospice - Hospital Based...
		OR LTRIM(RTRIM(BILL_TYPE)) IN ('891'))) --Community Based Adult Services...
OR (Cx IS NULL
	AND (UPPER(LTRIM(RTRIM(PROVID))) IN ('121867','122827','139434','139679','140270','159271','300847','301931','303334','304607','305072','310380','315328','315339','320878','5372','5511','5534','5584','5593','5662') --'Home Health Care'  ADD - ON per RDT DISCUSSION CALL ON 20171103
	OR UPPER(LTRIM(RTRIM(PROVID))) IN ('300815') --'Nursing Facilities - Residential Care' ADD - ON per RDT DISCUSSION CALL ON 20171103
	OR UPPER(LTRIM(RTRIM(VENDID))) IN ('121867','122827','139434','139679','140270','159271','300847','301931','303334','304607','305072','310380','315328','315339','320878','5372','5511','5534','5584','5593','5662') --'Home Health Care' ADD - ON per RDT DISCUSSION CALL ON 20171103
	OR UPPER(LTRIM(RTRIM(VENDID))) IN ('300815') --'Nursing Facilities - Residential Care' ADD - ON per RDT DISCUSSION CALL ON 20171103
	OR UPPER(UPPER(LTRIM(RTRIM(ISNULL(PROVSPEC,''))))) LIKE '%HHC%'
	OR UPPER(UPPER(LTRIM(RTRIM(ISNULL(PROVSPEC,''))))) LIKE '%BDC%'
)) --CONCLUDE ...







	--Lab and Radiology (PSCLM) --
UPDATE [INFORMATICS2].dbo.[SHELLunion00_RDT]
SET Cx = 'Lab and Radiology' --LAB & RAD PSCLM (PROFESSIONAL) claim.formtype LIKE '%1500%' 
-- SELECT TOP 10 * -- CHECK 1st
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM [INFORMATICS2].dbo.[SHELLunion00_RDT] AS su
WHERE (su.Cx IS NULL
	AND su.[CLM TYPE] = 'PROFESSIONAL' 
	AND LTRIM(RTRIM(su.SEQ_CLAIM_ID)) IN (SELECT DISTINCT LTRIM(RTRIM(sup.SEQ_CLAIM_ID)) -- The ENTIRE claim
FROM [INFORMATICS2].dbo.[SHELLunion00_RDT] AS sup
	JOIN INFORMATICS2.dbo.SHELLproc AS procc ON SUBSTRING(LTRIM(RTRIM(procc.PROCEDURE_CODE)),1,5) = LTRIM(RTRIM(sup.PROCEDURE_CODE)) --svccode.codegroup
WHERE LTRIM(RTRIM(procc.PROCEDURE_CODE)) BETWEEN '70000' AND '89999'))
	OR (Cx IS NULL
		AND UPPER(LTRIM(RTRIM(ISNULL(PLACE_OF_SERVICE_1,'')))) = '81')	--Independent Laboratory
OR (su.Cx IS NULL
	AND UPPER(LTRIM(RTRIM(ISNULL(PROVSPEC,'')))) IN ('CLL','PHY LA','DXC')) -- ADD ON per RDT CCI DISCUSSION / email FROM MS. NIKKITA see SUBJECT: RDT CCI Cx UPDATE(s) - RE: Discuss CCI RDT ON 20180503 AND see ''COS Updates_'...xlsx







	--Lab and Radiology INCLM--
UPDATE [INFORMATICS2].dbo.[SHELLunion00_RDT]
SET Cx = 'Lab and Radiology' --LAB & RAD INCLM (FACILITY) claim.formtype LIKE '%UB%'
-- SELECT TOP 10 * -- CHECK 1st
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM [INFORMATICS2].dbo.[SHELLunion00_RDT] AS su
WHERE su.Cx IS NULL
	AND LTRIM(RTRIM(su.SEQ_CLAIM_ID)) IN (SELECT DISTINCT LTRIM(RTRIM(sup.SEQ_CLAIM_ID)) -- The ENTIRE claim
FROM [INFORMATICS2].dbo.[SHELLunion00_RDT] AS sup 
WHERE LTRIM(RTRIM(sup.REVCDE)) IN (SELECT DISTINCT LTRIM(RTRIM(REVENUE_CODE))
FROM INFORMATICS2.dbo.SHELLrevcde
WHERE (REVENUE_CODE LIKE '30%'
	OR REVENUE_CODE LIKE '31%'
	OR REVENUE_CODE LIKE '32%'
	OR REVENUE_CODE LIKE '33%'
	OR REVENUE_CODE LIKE '35%'
	OR REVENUE_CODE LIKE '40%'
	OR REVENUE_CODE LIKE '61%'))
		AND (sup.BILL_TYPE  LIKE '13%' --HOSPITAL OP
			OR sup.BILL_TYPE  LIKE '14%') --HOSPITAL OP
		AND su.[CLM TYPE] = 'FACILITY')







    -- Pharmacy Codes that are IN QNXT--
UPDATE [INFORMATICS2].dbo.[SHELLunion00_RDT]
SET Cx = 'Pharmacy'
-- SELECT TOP 10 * -- CHECK 1st
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM [INFORMATICS2].dbo.[SHELLunion00_RDT] AS su
WHERE su.Cx IS NULL
	AND (UPPER(LTRIM(RTRIM(ISNULL(su.PROCEDURE_CODE,'')))) LIKE 'J%'
		OR UPPER(LTRIM(RTRIM(ISNULL(su.PROCEDURE_CODE,'')))) IN ('96361','96366','96372','96374','96375','96413','96523','99601','99602','S5497','S5498','S5501','S5502','S5517','S5520','S9325','S9326','S9327','S9329','S9330','S9338','S9340','S9341','S9342','S9343','S9347','S9348','S9351','S9355','S9359','S9361','S9365','S9366','S9367','S9370','S9372','S9373','S9374','S9375','S9377','S9379','S9490','S9494','S9500','S9501','S9502','S9503','S9504','S9537','S9542','S9558','S9590','Q9957','Q9967','A9577','S5571','250','255','258','259','636','99605','99606','99607','Q0144','Q0162','Q3028','Q4081','S0028','S0032','S0164','S0280','S4993','S5000','S5001','S5010','Q0511','Q0512','Q0513','90371','90378','90384','90471','90632','90633','90636','90648','90649','90651','90656','90658','90670','90686','90707','90714','90715','90716','90732','90734','90736','90744','90746'))
		
					/* SELECT MedImpactLOB,LINE_OF_BUSINESS,Cx
					,SUM(PaidAmount) AS Paid
					,SUM(trueSCRIPT) AS [SCRIPT(s)]
					-- SELECT TOP 10 * -- CHECK 1st
					-- SELECT DISTINCT ' ' AS 'CHECK 1st'
					FROM INFORMATICS2.dbo.SHELL_Rx_RDT
					GROUP BY MedImpactLOB,LINE_OF_BUSINESS,Cx
					ORDER BY MedImpactLOB,LINE_OF_BUSINESS,Cx */







	-- Transportation--
UPDATE [INFORMATICS2].dbo.[SHELLunion00_RDT]
SET Cx = 'Transportation'
-- SELECT TOP 10 * -- CHECK 1st
-- SELECT DISTINCT PROVID,PROVNM,PROVSPEC,PROVSPEC_DESCR,VENDID,VENDNM -- CHECK 1st
FROM [INFORMATICS2].dbo.[SHELLunion00_RDT] AS su
WHERE (su.Cx IS NULL
	AND [XPORT FLAG] = '1')
		OR (su.Cx IS NULL
			AND UPPER(LTRIM(RTRIM(ISNULL(PLACE_OF_SERVICE_1,'')))) = '41') --Ambulance - Land
		OR (su.Cx IS NULL
			AND UPPER(LTRIM(RTRIM(ISNULL(PROVSPEC,'')))) IN ('AMB','NET')) -- ADD ON per RDT CCI DISCUSSION / email FROM MS. NIKKITA see SUBJECT: RDT CCI Cx UPDATE(s) - RE: Discuss CCI RDT ON 20180503 AND see ''COS Updates_'...xlsx
			







	-- 'Other' (INCLM LEFT-OVER(s)) --
UPDATE [INFORMATICS2].dbo.[SHELLunion00_RDT]
SET Cx = 'All Other'  --FACILITY LIKE '%UB%' (INCLM)
-- SELECT TOP 10 * -- CHECK 1st
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM [INFORMATICS2].dbo.[SHELLunion00_RDT]
--WHERE Cx = 'OP Facility - Other'
WHERE (Cx IS NULL
	-- AND [CLM TYPE] = 'FACILITY' --EXCLUSION per 20180525 Please modify the 'All Other' Category of Service to include both 'Facilty' & 'Professional' [CLM TYPE]
	AND (UPPER(LTRIM(RTRIM(ISNULL(PROVSPEC,'')))) IN ('CET','CS','CYP','DME','HAD','HED','HOS','INT','NULL','PHM','PRM','RX','SLM','URC') -- ADD ON per RDT CCI DISCUSSION / email FROM MS. NIKKITA see SUBJECT: RDT CCI Cx UPDATE(s) - RE: Discuss CCI RDT ON 20180503 AND see ''COS Updates_'...xlsx
		OR UPPER(LTRIM(RTRIM(ISNULL(PROVSPEC,'')))) LIKE '%C0032992%')) --ADD ON per 20180525 DISCUSSION(s) Please add ProvSpec of 'INT' to the Other Medical Professional Category of Service







	-- 'Other Medical Professional' (PSCLM LEFT-OVER(s)) --
UPDATE [INFORMATICS2].dbo.[SHELLunion00_RDT]
SET Cx = 'Other Medical Professional'  --PROFESSIONAL LIKE '%1500%' (PSCLM)
-- SELECT TOP 10 * -- CHECK 1st
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM [INFORMATICS2].dbo.[SHELLunion00_RDT]
WHERE (Cx IS NULL
	AND [CLM TYPE] = 'PROFESSIONAL'
	AND UPPER(LTRIM(RTRIM(ISNULL(PROVSPEC,'')))) IN ('OCT','ACU','AUD','CHI','DDS','MSG','NUTR','OCM','OPT','ORP','PHT','POD','SLP','INT')) -- ADD ON per RDT CCI DISCUSSION / email FROM MS. NIKKITA see SUBJECT: RDT CCI Cx UPDATE(s) - RE: Discuss CCI RDT ON 20180503 AND see ''COS Updates_'...xlsx







-- ========================================================
	-- RDT HIERARCHY DOUBLE CHECK (Trust yet VERIFY) --
-- ========================================================
/* 4. The categories of service are listed IN hierarchical order and should be followed when claims meet criteria for more than one COS. For Example, if a claim meets criteria for both Inpatient and Emergency Room, the claim would be assigned to Inpatient because Inpatient is listed higher ON the hierarchy than Emergency Room. */

/* 5. Any one claim/encounter gets classified into only one COS. Therefore, if a claim has multiple detail lines with varying COS assignments, use the hierarchy to decide which COS the entire claim will be assigned to. */

			-- x COS HIERARCHY (19):
					-- 'Inpatient Hospital'
					-- 'Community-Based Adult Services (CBAS)'
					-- 'Emergency Room'
					-- 'Outpatient Facility'
					-- 'Behavioral Health Treatment (BHT)'
					-- 'Mental Health - Outpatient'
					-- 'Long-Term Care'  
					-- 'Federally Qualified Health Center (FQHC)'
					-- 'Specialty Physician'
					-- 'Primary Care Physician'
					-- 'Hospice'
					-- 'Multipurpose Senior Services Program (MSSP)'
					-- 'In-Home Supportive Services (IHSS)'
					-- 'HCBS Other'
					-- 'Lab and Radiology'
					-- 'Pharmacy'
					-- 'Transportation'
					-- 'All Other'  --FACILITY LIKE '%UB%' (INCLM)
					-- 'Other Medical Professional'  --PROFESSIONAL LIKE '%1500%' (PSCLM)

UPDATE [INFORMATICS2].dbo.[SHELLunion00_RDT]
SET Cx = 'Inpatient Hospital'
-- SELECT TOP 10 * -- CHECK 1st
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM [INFORMATICS2].dbo.[SHELLunion00_RDT] AS su
WHERE LTRIM(RTRIM(su.SEQ_CLAIM_ID)) IN (SELECT DISTINCT LTRIM(RTRIM(sup.SEQ_CLAIM_ID)) -- The ENTIRE claim
FROM [INFORMATICS2].dbo.[SHELLunion00_RDT] AS sup
WHERE sup.Cx = 'Inpatient Hospital')

UPDATE [INFORMATICS2].dbo.[SHELLunion00_RDT]
SET Cx = 'Community-Based Adult Services (CBAS)'
-- SELECT TOP 10 * -- CHECK 1st
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM [INFORMATICS2].dbo.[SHELLunion00_RDT] AS su
WHERE LTRIM(RTRIM(su.SEQ_CLAIM_ID)) IN (SELECT DISTINCT LTRIM(RTRIM(sup.SEQ_CLAIM_ID)) -- The ENTIRE claim
FROM [INFORMATICS2].dbo.[SHELLunion00_RDT] AS sup
WHERE sup.Cx = 'Community-Based Adult Services (CBAS)')

UPDATE [INFORMATICS2].dbo.[SHELLunion00_RDT]
SET Cx = 'Emergency Room'
-- SELECT TOP 10 * -- CHECK 1st
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM [INFORMATICS2].dbo.[SHELLunion00_RDT] AS su
WHERE LTRIM(RTRIM(su.SEQ_CLAIM_ID)) IN (SELECT DISTINCT LTRIM(RTRIM(sup.SEQ_CLAIM_ID)) -- The ENTIRE claim
FROM [INFORMATICS2].dbo.[SHELLunion00_RDT] AS sup
WHERE sup.Cx = 'Emergency Room')

UPDATE [INFORMATICS2].dbo.[SHELLunion00_RDT]
SET Cx = 'Outpatient Facility'
-- SELECT TOP 10 * -- CHECK 1st
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM [INFORMATICS2].dbo.[SHELLunion00_RDT] AS su
WHERE LTRIM(RTRIM(su.SEQ_CLAIM_ID)) IN (SELECT DISTINCT LTRIM(RTRIM(sup.SEQ_CLAIM_ID)) -- The ENTIRE claim
FROM [INFORMATICS2].dbo.[SHELLunion00_RDT] AS sup
WHERE sup.Cx = 'Outpatient Facility')

UPDATE [INFORMATICS2].dbo.[SHELLunion00_RDT]
SET Cx = 'Behavioral Health Treatment (BHT)'
-- SELECT TOP 10 * -- CHECK 1st
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM [INFORMATICS2].dbo.[SHELLunion00_RDT] AS su
WHERE LTRIM(RTRIM(su.SEQ_CLAIM_ID)) IN (SELECT DISTINCT LTRIM(RTRIM(sup.SEQ_CLAIM_ID)) -- The ENTIRE claim
FROM [INFORMATICS2].dbo.[SHELLunion00_RDT] AS sup
WHERE sup.Cx = 'Behavioral Health Treatment (BHT)')

UPDATE [INFORMATICS2].dbo.[SHELLunion00_RDT]
SET Cx = 'Mental Health - Outpatient'
-- SELECT TOP 10 * -- CHECK 1st
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM [INFORMATICS2].dbo.[SHELLunion00_RDT] AS su
WHERE LTRIM(RTRIM(su.SEQ_CLAIM_ID)) IN (SELECT DISTINCT LTRIM(RTRIM(sup.SEQ_CLAIM_ID)) -- The ENTIRE claim
FROM [INFORMATICS2].dbo.[SHELLunion00_RDT] AS sup
WHERE sup.Cx = 'Mental Health - Outpatient')

UPDATE [INFORMATICS2].dbo.[SHELLunion00_RDT]
SET Cx = 'Long-Term Care'
-- SELECT TOP 10 * -- CHECK 1st
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM [INFORMATICS2].dbo.[SHELLunion00_RDT] AS su
WHERE LTRIM(RTRIM(su.SEQ_CLAIM_ID)) IN (SELECT DISTINCT LTRIM(RTRIM(sup.SEQ_CLAIM_ID)) -- The ENTIRE claim
FROM [INFORMATICS2].dbo.[SHELLunion00_RDT] AS sup
WHERE sup.Cx = 'Long-Term Care')

UPDATE [INFORMATICS2].dbo.[SHELLunion00_RDT]
SET Cx = 'Federally Qualified Health Center (FQHC)'
-- SELECT TOP 10 * -- CHECK 1st
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM [INFORMATICS2].dbo.[SHELLunion00_RDT] AS su
WHERE LTRIM(RTRIM(su.SEQ_CLAIM_ID)) IN (SELECT DISTINCT LTRIM(RTRIM(sup.SEQ_CLAIM_ID)) -- The ENTIRE claim
FROM [INFORMATICS2].dbo.[SHELLunion00_RDT] AS sup
WHERE sup.Cx = 'Federally Qualified Health Center (FQHC)')
		
UPDATE [INFORMATICS2].dbo.[SHELLunion00_RDT]
SET Cx = 'Specialty Physician'
-- SELECT TOP 10 * -- CHECK 1st
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM [INFORMATICS2].dbo.[SHELLunion00_RDT] AS su
WHERE LTRIM(RTRIM(su.SEQ_CLAIM_ID)) IN (SELECT DISTINCT LTRIM(RTRIM(sup.SEQ_CLAIM_ID)) -- The ENTIRE claim
FROM [INFORMATICS2].dbo.[SHELLunion00_RDT] AS sup
WHERE sup.Cx = 'Specialty Physician')

UPDATE [INFORMATICS2].dbo.[SHELLunion00_RDT]
SET Cx = 'Primary Care Physician'
-- SELECT TOP 10 * -- CHECK 1st
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM [INFORMATICS2].dbo.[SHELLunion00_RDT] AS su
WHERE LTRIM(RTRIM(su.SEQ_CLAIM_ID)) IN (SELECT DISTINCT LTRIM(RTRIM(sup.SEQ_CLAIM_ID)) -- The ENTIRE claim
FROM [INFORMATICS2].dbo.[SHELLunion00_RDT] AS sup
WHERE sup.Cx = 'Primary Care Physician')

UPDATE [INFORMATICS2].dbo.[SHELLunion00_RDT]
SET Cx = 'Hospice'
-- SELECT TOP 10 * -- CHECK 1st
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM [INFORMATICS2].dbo.[SHELLunion00_RDT] AS su
WHERE LTRIM(RTRIM(su.SEQ_CLAIM_ID)) IN (SELECT DISTINCT LTRIM(RTRIM(sup.SEQ_CLAIM_ID)) -- The ENTIRE claim
FROM [INFORMATICS2].dbo.[SHELLunion00_RDT] AS sup
WHERE sup.Cx = 'Hospice')

UPDATE [INFORMATICS2].dbo.[SHELLunion00_RDT]
SET Cx = 'Multipurpose Senior Services Program (MSSP)'
-- SELECT TOP 10 * -- CHECK 1st
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM [INFORMATICS2].dbo.[SHELLunion00_RDT] AS su
WHERE LTRIM(RTRIM(su.SEQ_CLAIM_ID)) IN (SELECT DISTINCT LTRIM(RTRIM(sup.SEQ_CLAIM_ID)) -- The ENTIRE claim
FROM [INFORMATICS2].dbo.[SHELLunion00_RDT] AS sup
WHERE sup.Cx = 'Multipurpose Senior Services Program (MSSP)')

UPDATE [INFORMATICS2].dbo.[SHELLunion00_RDT]
SET Cx = 'In-Home Supportive Services (IHSS)'
-- SELECT TOP 10 * -- CHECK 1st
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM [INFORMATICS2].dbo.[SHELLunion00_RDT] AS su
WHERE LTRIM(RTRIM(su.SEQ_CLAIM_ID)) IN (SELECT DISTINCT LTRIM(RTRIM(sup.SEQ_CLAIM_ID)) -- The ENTIRE claim
FROM [INFORMATICS2].dbo.[SHELLunion00_RDT] AS sup
WHERE sup.Cx = 'In-Home Supportive Services (IHSS)')

UPDATE [INFORMATICS2].dbo.[SHELLunion00_RDT]
SET Cx = 'HCBS Other'
-- SELECT TOP 10 * -- CHECK 1st
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM [INFORMATICS2].dbo.[SHELLunion00_RDT] AS su
WHERE LTRIM(RTRIM(su.SEQ_CLAIM_ID)) IN (SELECT DISTINCT LTRIM(RTRIM(sup.SEQ_CLAIM_ID)) -- The ENTIRE claim
FROM [INFORMATICS2].dbo.[SHELLunion00_RDT] AS sup
WHERE sup.Cx = 'HCBS Other')

UPDATE [INFORMATICS2].dbo.[SHELLunion00_RDT]
SET Cx = 'Lab and Radiology'
-- SELECT TOP 10 * -- CHECK 1st
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM [INFORMATICS2].dbo.[SHELLunion00_RDT] AS su
WHERE LTRIM(RTRIM(su.SEQ_CLAIM_ID)) IN (SELECT DISTINCT LTRIM(RTRIM(sup.SEQ_CLAIM_ID)) -- The ENTIRE claim
FROM [INFORMATICS2].dbo.[SHELLunion00_RDT] AS sup
WHERE sup.Cx = 'Lab and Radiology')

UPDATE [INFORMATICS2].dbo.[SHELLunion00_RDT]
SET Cx = 'Pharmacy'
-- SELECT TOP 10 * -- CHECK 1st
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM [INFORMATICS2].dbo.[SHELLunion00_RDT] AS su
WHERE LTRIM(RTRIM(su.SEQ_CLAIM_ID)) IN (SELECT DISTINCT LTRIM(RTRIM(sup.SEQ_CLAIM_ID)) -- The ENTIRE claim
FROM [INFORMATICS2].dbo.[SHELLunion00_RDT] AS sup
WHERE sup.Cx = 'Pharmacy')

UPDATE [INFORMATICS2].dbo.[SHELLunion00_RDT]
SET Cx = 'Transportation'
-- SELECT TOP 10 * -- CHECK 1st
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM [INFORMATICS2].dbo.[SHELLunion00_RDT] AS su
WHERE LTRIM(RTRIM(su.SEQ_CLAIM_ID)) IN (SELECT DISTINCT LTRIM(RTRIM(sup.SEQ_CLAIM_ID)) -- The ENTIRE claim
FROM [INFORMATICS2].dbo.[SHELLunion00_RDT] AS sup
WHERE sup.Cx = 'Transportation')

UPDATE [INFORMATICS2].dbo.[SHELLunion00_RDT]
SET Cx = 'All Other' --FACILITY LIKE '%UB%' (INCLM)
-- SELECT TOP 10 * -- CHECK 1st
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM [INFORMATICS2].dbo.[SHELLunion00_RDT] AS su
WHERE LTRIM(RTRIM(su.SEQ_CLAIM_ID)) IN (SELECT DISTINCT LTRIM(RTRIM(sup.SEQ_CLAIM_ID)) -- The ENTIRE claim
FROM [INFORMATICS2].dbo.[SHELLunion00_RDT] AS sup
WHERE sup.Cx = 'All Other') --FACILITY LIKE '%UB%' (INCLM)

UPDATE [INFORMATICS2].dbo.[SHELLunion00_RDT]
SET Cx = 'Other Medical Professional' --PROFESSIONAL LIKE '%1500%' (PSCLM)
-- SELECT TOP 10 * -- CHECK 1st
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM [INFORMATICS2].dbo.[SHELLunion00_RDT] AS su
WHERE LTRIM(RTRIM(su.SEQ_CLAIM_ID)) IN (SELECT DISTINCT LTRIM(RTRIM(sup.SEQ_CLAIM_ID)) -- The ENTIRE claim
FROM [INFORMATICS2].dbo.[SHELLunion00_RDT] AS sup
WHERE sup.Cx = 'Other Medical Professional') --PROFESSIONAL LIKE '%1500%' (PSCLM)







-- =================================================================
	-- SUMMARY() --
-- =================================================================
DECLARE @LOB AS nvarchar(88)

SET @LOB  = 'CL1'

					-- DELETE
					-- SELECT TOP 10 * -- CHECK 1st
					-- FROM INFORMATICS2.dbo.SHELLunion00_RDT
					-- WHERE LTRIM(RTRIM(LINE_OF_BUSINESS)) NOT LIKE @LOB

					-- DELETE
					-- SELECT TOP 10 * -- CHECK 1st
					-- FROM INFORMATICS2.dbo.SHELL_Rx_RDT
					-- WHERE LTRIM(RTRIM(LINE_OF_BUSINESS)) NOT LIKE @LOB

						-- Review Summary--
					SELECT 'Cx SUMMARY' AS [NOTE(s)]
					/* ,LINE_OF_BUSINESS */,[RANGE],Cx
					,SUM(PAID_NET_AMT) AS Cost
					-- SELECT TOP 10 * -- CHECK 1st
					-- SELECT DISTINCT ' ' AS 'CHECK 1st'
					FROM [INFORMATICS2].dbo.SHELLunion00_RDT
					-- WHERE UPPER(LTRIM(RTRIM(ISNULL(,'')))) IN (@LOB)
					GROUP BY /* LINE_OF_BUSINESS, */[RANGE],Cx
					ORDER BY /* LINE_OF_BUSINESS, */[RANGE],Cx







-- ============================================================= 
	-- CREATE() / ALTER()  PLACEHOLDER/ STAGING / SHELL [FIELD](s) & OR [TABLE](s) --
-- =============================================================
ALTER TABLE [INFORMATICS2].dbo.[SHELLunion00_RDT]
ADD --INITIATE ...
[RDT_GROUP] nvarchar (100) DEFAULT NULL --DFLT VAL() IS NULL RDT CCI placeholder [OPTION(s)]: Institutional SPD/Full-Dual  - see 'Scott file' WHEN 'Long-Term Care'  aka SNF (Skilled Nursing Facility) - DAY(s) ,HCBS High	LTC/Full-Dual - see 'Ms. Maryanne HCPCS' WHEN 'HCBS Other' - OTHER ,HCBS Low	- see 'Ms. Maryanne HCPCS' WHEN 'HCBS Other' - OTHER ,Healthy - ELSE...
,[POPULATION] nvarchar (100) DEFAULT NULL --DFLT VAL() IS NULL RDT CCI MediConnect','Prior To Transition','MediConnect Ineligible','MediConnect Ineligible'
,[RDTAgeCx ] nvarchar (100) DEFAULT NULL --DFLT VAL() IS NULL
,[RDT_SUBGROUP] nvarchar(100) DEFAULT NULL --OPTION(s) 'Non-Medicare,Full-Dual,Non-Medicare,Part A Only,Part B Only'
,[COA] nvarchar (100) DEFAULT NULL --DFLT VAL() IS NULL RDT QUPD WHEN Is Null / exception(s) BASED ON ratecode AND age
,[ABORTIONflag] int DEFAULT NULL --DFLT VAL() IS NULL
,[PARTIALflag] int DEFAULT NULL --DFLT VAL() IS NULL
,[DELIVflag] int DEFAULT NULL --DFLT VAL() IS NULL
,[OE (ACA Optional Expansion)] nvarchar (100) DEFAULT NULL --DFLT VAL() IS NULL RDT QUPD WHEN Is Null / exception(s)
,[Mental Health Carve-In] nvarchar (100) DEFAULT NULL --DFLT VAL() IS NULL RDT MH
,[BIRTH_TYPE] nvarchar (100) DEFAULT NULL --DFLT VAL() IS NULL
,[OPENa] nvarchar(25) DEFAULT NULL --DFLT VAL() IS NULL NEWBORN_INDICATOR
,[OPENb] nvarchar(25) DEFAULT NULL --DFLT VAL() IS NULL BIRTH_TYPE
,[OPENc] nvarchar(25) DEFAULT NULL --DFLT VAL() IS NULL BIRTH_FACILITY
------------------,[OPENd] nvarchar(25) DEFAULT NULL --DFLT VAL() IS NULL HFPflag (TLIC(s))
------------------,[OPENe] nvarchar(25) DEFAULT NULL --DFLT VAL() IS NULL Partial DUAL(s)
,[OPENd] nvarchar(100) DEFAULT NULL --DFLT VAL() IS NULL NEW RDT CCI / MLTSS [POPULATION] copy
,[OPENe] nvarchar(100) DEFAULT NULL --DFLT VAL() IS NULL NEW RDT CCI / MLTSS [COA] copy
,[OLD_Cx] nvarchar(255) DEFAULT NULL --DFLT VAL() IS NULL NEW RDT CCI / MLTSS [COA] copy
; --CONCLUDE ...

				-- SELECT TOP 10 * FROM [INFORMATICS2].dbo.[SHELLunion00_RDT]

	--DUP(s) --
SELECT 'DUP Validation' AS [DUP NOTE(s)],Cx,*
FROM INFORMATICS2.dbo.SHELLunion00_RDT
WHERE LTRIM(RTRIM(SEQ_CLAIM_ID))+LTRIM(RTRIM(LINE_NUMBER))+LTRIM(RTRIM(POST_DATE)) IN (SELECT LTRIM(RTRIM(SEQ_CLAIM_ID))+LTRIM(RTRIM(LINE_NUMBER))+LTRIM(RTRIM(POST_DATE))
FROM INFORMATICS2.dbo.SHELLunion00_RDT
WHERE PAID_NET_AMT <>0
GROUP BY LTRIM(RTRIM(SEQ_CLAIM_ID))+LTRIM(RTRIM(LINE_NUMBER))+LTRIM(RTRIM(POST_DATE)) --Duplication Driver
HAVING COUNT(1)>1) --Aggregate Syntax REQUIRED
ORDER BY LTRIM(RTRIM(SEQ_CLAIM_ID))+LTRIM(RTRIM(LINE_NUMBER))+LTRIM(RTRIM(POST_DATE))







ALTER TABLE [INFORMATICS2].dbo.[SHELL_Rx_RDT]
ADD --INITIATE ...
[RDT_GROUP] nvarchar (100) DEFAULT NULL --DFLT VAL() IS NULL RDT CCI placeholder [OPTION(s)]: Institutional SPD/Full-Dual  - see 'Scott file' WHEN 'Long-Term Care'  aka SNF (Skilled Nursing Facility) - DAY(s) ,HCBS High	LTC/Full-Dual - see 'Ms. Maryanne HCPCS' WHEN 'HCBS Other' - OTHER ,HCBS Low	- see 'Ms. Maryanne HCPCS' WHEN 'HCBS Other' - OTHER ,Healthy - ELSE...
-- ,[POPULATION] nvarchar (100) DEFAULT NULL --DFLT VAL() IS NULL RDT CCI MediConnect','Prior To Transition','MediConnect Ineligible','MediConnect Ineligible'
,[RDT_SUBGROUP] nvarchar(100) DEFAULT NULL --OPTION(s) 'Non-Medicare,Full-Dual,Non-Medicare,Part A Only,Part B Only'
,[OPENa] nvarchar(25) DEFAULT NULL --DFLT VAL() IS NULL NEWBORN_INDICATOR
,[OPENb] nvarchar(25) DEFAULT NULL --DFLT VAL() IS NULL BIRTH_TYPE
,[OPENc] nvarchar(25) DEFAULT NULL --DFLT VAL() IS NULL BIRTH_FACILITY
------------------,[OPENd] nvarchar(25) DEFAULT NULL --DFLT VAL() IS NULL HFPflag (TLIC(s))
------------------,[OPENe] nvarchar(25) DEFAULT NULL --DFLT VAL() IS NULL Partial DUAL(s)
,[OPENd] nvarchar(100) DEFAULT NULL --DFLT VAL() IS NULL NEW RDT CCI / MLTSS [POPULATION] copy
,[OPENe] nvarchar(100) DEFAULT NULL --DFLT VAL() IS NULL NEW RDT CCI / MLTSS [COA] copy
; --CONCLUDE ...

				-- SELECT TOP 10 * FROM [INFORMATICS2].dbo.[SHELL_Rx_RDT]
				
	--DUP(s) --
SELECT 'DUP Validation' AS [DUP NOTE(s)],Cx,*
FROM INFORMATICS2.dbo.SHELL_Rx_RDT
WHERE ClaimId IN (SELECT dup.ClaimId
FROM INFORMATICS2.dbo.SHELL_Rx_RDT AS dup
GROUP BY dup.ClaimId --Duplication Driver
HAVING COUNT(1)>1) --Aggregate HAVING clause
ORDER BY ClaimId







-- ==========================================================
	-- SECONDARY OVERDOSE DIAGNOSIS COMBINATION (ANN GRANT) --
-- ==========================================================
----------------x ;WITH() DxCx for ambulatory care sensitive conditions, plus overdose* see 'ANN_GRANT_Ambulatory Care Sensitive DX Codes.xlsx'

--*Ambulatory care sensitive conditions include: overdose, complications of diabetes, COPD/heat failure/angina, hypertension, UTI, perforated appendix, asthma, pneumonia, dehydration. (This list was derived from AHQR’s list of ambulatory care sensitive conditions, with the exception of overdose.)

----------------SELECT *
----------------FROM INFORMATICS2.dbo.SHELLdiag
----------------WHERE UPPER(LTRIM(RTRIM(DIAGNOSIS_CODE))) IN ('T39.8X1','T39.8X2','T39.8X3','T39.8X4','T39.8X5','E11.8','E11.63','E11.638','E11.62','E11.628','E11.5','E11.59','E11.2','E10','E10.9','E10.8','E10.6','E10.5','E10.2','E13.3','E13.8','E13.59','E13.638','E13.628','O24.93','O24.92','J44.9','J44.1','J44.0','I50.9','I50.2','I50.20','I50.21','I50.22','I50.23','I50.3','I50.30','I50.31','I50.32','I50.33','I50.4','I50.40','I50.42','I50.43','I20','I20.0','I20.8','I20.9','I20.1','I15','I15.0','I15.8','I10','O16','O16.4','O16.1','O16.2','O16.3','O16.9','O10','O10.9','O10.92','O10.0','O10.02','O13','O13.1','O13.9','O13.4','O13.3','N39.0','O86.2','K35','K35.2','K35.3','K35.80','K35.89','J45','J45.9X','J45.4X','J45.3X','J45.5X','J45.2X','J15.X','J16.X','J12.X','J13','J18.X','P23.X','E86.0','E08.2','E08.21','E08.22','E08.29','E10.2') --ambulatory care sensitive conditions, plus overdose*

	--RESET DxCx--
UPDATE [INFORMATICS2].dbo.[SHELLunion00_ANN_GRANT]
SET DxCx = CAST(NULL AS nvarchar(100)) --CLEANSE()

	--'Overdose'--
UPDATE [INFORMATICS2].dbo.[SHELLunion00_ANN_GRANT]
SET DxCx = 'Overdose'
--SELECT su.* -- CHECK 1st
FROM [INFORMATICS2].dbo.[SHELLunion00_ANN_GRANT] AS su
WHERE su.DxCx IS NULL
    AND su.SEQ_CLAIM_ID IN (SELECT DISTINCT sup.SEQ_CLAIM_ID -- The ENTIRE claim
--SELECT su.* -- CHECK 1st
FROM [INFORMATICS2].dbo.[SHELLunion00_ANN_GRANT] AS sup
WHERE LTRIM(RTRIM(su.prindiag)) IN ('T39.8X1','T39.8X2','T39.8X3','T39.8X4','T39.8X5','E11.8','E11.63','E11.638','E11.62','E11.628','E11.5','E11.59','E11.2','E10','E10.9','E10.8','E10.6','E10.5','E10.2','E13.3','E13.8','E13.59','E13.638','E13.628','O24.93','O24.92','J44.9','J44.1','J44.0','I50.9','I50.2','I50.20','I50.21','I50.22','I50.23','I50.3','I50.30','I50.31','I50.32','I50.33','I50.4','I50.40','I50.42','I50.43','I20','I20.0','I20.8','I20.9','I20.1','I15','I15.0','I15.8','I10','O16','O16.4','O16.1','O16.2','O16.3','O16.9','O10','O10.9','O10.92','O10.0','O10.02','O13','O13.1','O13.9','O13.4','O13.3','N39.0','O86.2','K35','K35.2','K35.3','K35.80','K35.89','J45','J45.9X','J45.4X','J45.3X','J45.5X','J45.2X','J15.X','J16.X','J12.X','J13','J18.X','P23.X','E86.0','E08.2','E08.21','E08.22','E08.29','E10.2') --ambulatory care sensitive conditions, plus overdose*
	OR LTRIM(RTRIM(su.DIAGNOSIS_1)) IN ('T39.8X1','T39.8X2','T39.8X3','T39.8X4','T39.8X5','E11.8','E11.63','E11.638','E11.62','E11.628','E11.5','E11.59','E11.2','E10','E10.9','E10.8','E10.6','E10.5','E10.2','E13.3','E13.8','E13.59','E13.638','E13.628','O24.93','O24.92','J44.9','J44.1','J44.0','I50.9','I50.2','I50.20','I50.21','I50.22','I50.23','I50.3','I50.30','I50.31','I50.32','I50.33','I50.4','I50.40','I50.42','I50.43','I20','I20.0','I20.8','I20.9','I20.1','I15','I15.0','I15.8','I10','O16','O16.4','O16.1','O16.2','O16.3','O16.9','O10','O10.9','O10.92','O10.0','O10.02','O13','O13.1','O13.9','O13.4','O13.3','N39.0','O86.2','K35','K35.2','K35.3','K35.80','K35.89','J45','J45.9X','J45.4X','J45.3X','J45.5X','J45.2X','J15.X','J16.X','J12.X','J13','J18.X','P23.X','E86.0','E08.2','E08.21','E08.22','E08.29','E10.2') --ambulatory care sensitive conditions, plus overdose*
	OR LTRIM(RTRIM(su.DIAGNOSIS_2)) IN ('T39.8X1','T39.8X2','T39.8X3','T39.8X4','T39.8X5','E11.8','E11.63','E11.638','E11.62','E11.628','E11.5','E11.59','E11.2','E10','E10.9','E10.8','E10.6','E10.5','E10.2','E13.3','E13.8','E13.59','E13.638','E13.628','O24.93','O24.92','J44.9','J44.1','J44.0','I50.9','I50.2','I50.20','I50.21','I50.22','I50.23','I50.3','I50.30','I50.31','I50.32','I50.33','I50.4','I50.40','I50.42','I50.43','I20','I20.0','I20.8','I20.9','I20.1','I15','I15.0','I15.8','I10','O16','O16.4','O16.1','O16.2','O16.3','O16.9','O10','O10.9','O10.92','O10.0','O10.02','O13','O13.1','O13.9','O13.4','O13.3','N39.0','O86.2','K35','K35.2','K35.3','K35.80','K35.89','J45','J45.9X','J45.4X','J45.3X','J45.5X','J45.2X','J15.X','J16.X','J12.X','J13','J18.X','P23.X','E86.0','E08.2','E08.21','E08.22','E08.29','E10.2') --ambulatory care sensitive conditions, plus overdose*
	OR LTRIM(RTRIM(su.DIAGNOSIS_3)) IN ('T39.8X1','T39.8X2','T39.8X3','T39.8X4','T39.8X5','E11.8','E11.63','E11.638','E11.62','E11.628','E11.5','E11.59','E11.2','E10','E10.9','E10.8','E10.6','E10.5','E10.2','E13.3','E13.8','E13.59','E13.638','E13.628','O24.93','O24.92','J44.9','J44.1','J44.0','I50.9','I50.2','I50.20','I50.21','I50.22','I50.23','I50.3','I50.30','I50.31','I50.32','I50.33','I50.4','I50.40','I50.42','I50.43','I20','I20.0','I20.8','I20.9','I20.1','I15','I15.0','I15.8','I10','O16','O16.4','O16.1','O16.2','O16.3','O16.9','O10','O10.9','O10.92','O10.0','O10.02','O13','O13.1','O13.9','O13.4','O13.3','N39.0','O86.2','K35','K35.2','K35.3','K35.80','K35.89','J45','J45.9X','J45.4X','J45.3X','J45.5X','J45.2X','J15.X','J16.X','J12.X','J13','J18.X','P23.X','E86.0','E08.2','E08.21','E08.22','E08.29','E10.2') --ambulatory care sensitive conditions, plus overdose*
	OR LTRIM(RTRIM(su.DIAGNOSIS_4)) IN ('T39.8X1','T39.8X2','T39.8X3','T39.8X4','T39.8X5','E11.8','E11.63','E11.638','E11.62','E11.628','E11.5','E11.59','E11.2','E10','E10.9','E10.8','E10.6','E10.5','E10.2','E13.3','E13.8','E13.59','E13.638','E13.628','O24.93','O24.92','J44.9','J44.1','J44.0','I50.9','I50.2','I50.20','I50.21','I50.22','I50.23','I50.3','I50.30','I50.31','I50.32','I50.33','I50.4','I50.40','I50.42','I50.43','I20','I20.0','I20.8','I20.9','I20.1','I15','I15.0','I15.8','I10','O16','O16.4','O16.1','O16.2','O16.3','O16.9','O10','O10.9','O10.92','O10.0','O10.02','O13','O13.1','O13.9','O13.4','O13.3','N39.0','O86.2','K35','K35.2','K35.3','K35.80','K35.89','J45','J45.9X','J45.4X','J45.3X','J45.5X','J45.2X','J15.X','J16.X','J12.X','J13','J18.X','P23.X','E86.0','E08.2','E08.21','E08.22','E08.29','E10.2') --ambulatory care sensitive conditions, plus overdose*
	OR LTRIM(RTRIM(su.DIAGNOSIS_5)) IN ('T39.8X1','T39.8X2','T39.8X3','T39.8X4','T39.8X5','E11.8','E11.63','E11.638','E11.62','E11.628','E11.5','E11.59','E11.2','E10','E10.9','E10.8','E10.6','E10.5','E10.2','E13.3','E13.8','E13.59','E13.638','E13.628','O24.93','O24.92','J44.9','J44.1','J44.0','I50.9','I50.2','I50.20','I50.21','I50.22','I50.23','I50.3','I50.30','I50.31','I50.32','I50.33','I50.4','I50.40','I50.42','I50.43','I20','I20.0','I20.8','I20.9','I20.1','I15','I15.0','I15.8','I10','O16','O16.4','O16.1','O16.2','O16.3','O16.9','O10','O10.9','O10.92','O10.0','O10.02','O13','O13.1','O13.9','O13.4','O13.3','N39.0','O86.2','K35','K35.2','K35.3','K35.80','K35.89','J45','J45.9X','J45.4X','J45.3X','J45.5X','J45.2X','J15.X','J16.X','J12.X','J13','J18.X','P23.X','E86.0','E08.2','E08.21','E08.22','E08.29','E10.2') --ambulatory care sensitive conditions, plus overdose*
	OR LTRIM(RTRIM(su.DIAGNOSIS_6)) IN ('T39.8X1','T39.8X2','T39.8X3','T39.8X4','T39.8X5','E11.8','E11.63','E11.638','E11.62','E11.628','E11.5','E11.59','E11.2','E10','E10.9','E10.8','E10.6','E10.5','E10.2','E13.3','E13.8','E13.59','E13.638','E13.628','O24.93','O24.92','J44.9','J44.1','J44.0','I50.9','I50.2','I50.20','I50.21','I50.22','I50.23','I50.3','I50.30','I50.31','I50.32','I50.33','I50.4','I50.40','I50.42','I50.43','I20','I20.0','I20.8','I20.9','I20.1','I15','I15.0','I15.8','I10','O16','O16.4','O16.1','O16.2','O16.3','O16.9','O10','O10.9','O10.92','O10.0','O10.02','O13','O13.1','O13.9','O13.4','O13.3','N39.0','O86.2','K35','K35.2','K35.3','K35.80','K35.89','J45','J45.9X','J45.4X','J45.3X','J45.5X','J45.2X','J15.X','J16.X','J12.X','J13','J18.X','P23.X','E86.0','E08.2','E08.21','E08.22','E08.29','E10.2') --ambulatory care sensitive conditions, plus overdose*
	OR LTRIM(RTRIM(su.DIAGNOSIS_7)) IN ('T39.8X1','T39.8X2','T39.8X3','T39.8X4','T39.8X5','E11.8','E11.63','E11.638','E11.62','E11.628','E11.5','E11.59','E11.2','E10','E10.9','E10.8','E10.6','E10.5','E10.2','E13.3','E13.8','E13.59','E13.638','E13.628','O24.93','O24.92','J44.9','J44.1','J44.0','I50.9','I50.2','I50.20','I50.21','I50.22','I50.23','I50.3','I50.30','I50.31','I50.32','I50.33','I50.4','I50.40','I50.42','I50.43','I20','I20.0','I20.8','I20.9','I20.1','I15','I15.0','I15.8','I10','O16','O16.4','O16.1','O16.2','O16.3','O16.9','O10','O10.9','O10.92','O10.0','O10.02','O13','O13.1','O13.9','O13.4','O13.3','N39.0','O86.2','K35','K35.2','K35.3','K35.80','K35.89','J45','J45.9X','J45.4X','J45.3X','J45.5X','J45.2X','J15.X','J16.X','J12.X','J13','J18.X','P23.X','E86.0','E08.2','E08.21','E08.22','E08.29','E10.2') --ambulatory care sensitive conditions, plus overdose*
	OR LTRIM(RTRIM(su.DIAGNOSIS_8)) IN ('T39.8X1','T39.8X2','T39.8X3','T39.8X4','T39.8X5','E11.8','E11.63','E11.638','E11.62','E11.628','E11.5','E11.59','E11.2','E10','E10.9','E10.8','E10.6','E10.5','E10.2','E13.3','E13.8','E13.59','E13.638','E13.628','O24.93','O24.92','J44.9','J44.1','J44.0','I50.9','I50.2','I50.20','I50.21','I50.22','I50.23','I50.3','I50.30','I50.31','I50.32','I50.33','I50.4','I50.40','I50.42','I50.43','I20','I20.0','I20.8','I20.9','I20.1','I15','I15.0','I15.8','I10','O16','O16.4','O16.1','O16.2','O16.3','O16.9','O10','O10.9','O10.92','O10.0','O10.02','O13','O13.1','O13.9','O13.4','O13.3','N39.0','O86.2','K35','K35.2','K35.3','K35.80','K35.89','J45','J45.9X','J45.4X','J45.3X','J45.5X','J45.2X','J15.X','J16.X','J12.X','J13','J18.X','P23.X','E86.0','E08.2','E08.21','E08.22','E08.29','E10.2') --ambulatory care sensitive conditions, plus overdose*
	OR LTRIM(RTRIM(su.DIAGNOSIS_9)) IN ('T39.8X1','T39.8X2','T39.8X3','T39.8X4','T39.8X5','E11.8','E11.63','E11.638','E11.62','E11.628','E11.5','E11.59','E11.2','E10','E10.9','E10.8','E10.6','E10.5','E10.2','E13.3','E13.8','E13.59','E13.638','E13.628','O24.93','O24.92','J44.9','J44.1','J44.0','I50.9','I50.2','I50.20','I50.21','I50.22','I50.23','I50.3','I50.30','I50.31','I50.32','I50.33','I50.4','I50.40','I50.42','I50.43','I20','I20.0','I20.8','I20.9','I20.1','I15','I15.0','I15.8','I10','O16','O16.4','O16.1','O16.2','O16.3','O16.9','O10','O10.9','O10.92','O10.0','O10.02','O13','O13.1','O13.9','O13.4','O13.3','N39.0','O86.2','K35','K35.2','K35.3','K35.80','K35.89','J45','J45.9X','J45.4X','J45.3X','J45.5X','J45.2X','J15.X','J16.X','J12.X','J13','J18.X','P23.X','E86.0','E08.2','E08.21','E08.22','E08.29','E10.2') --ambulatory care sensitive conditions, plus overdose*
) --CLOSE OUT SUB-QUERY







-- ========================================================
	--DxCx HIERARCHY DOUBLE CHECK (Trust yet VERIFY) --
----------------'Pharmacy' makes NINETEEN (19)
-- ========================================================
----------------x DIAG COMBINATION() HIERARCHY:
----------------'Overdose'

UPDATE [INFORMATICS2].dbo.[SHELLunion00_ANN_GRANT]
SET DxCx = 'Overdose'
--SELECT su.* -- CHECK 1st
FROM [INFORMATICS2].dbo.[SHELLunion00_ANN_GRANT] AS su
WHERE LTRIM(RTRIM(su.SEQ_CLAIM_ID)) IN (SELECT DISTINCT LTRIM(RTRIM(sup.SEQ_CLAIM_ID)) -- The ENTIRE claim
--SELECT su.* -- CHECK 1st
FROM [INFORMATICS2].dbo.[SHELLunion00_ANN_GRANT] AS sup
WHERE sup.DxCx = 'Overdose')

					SELECT Cx,DxCx
					,SUM(PAID_NET_AMT) AS Cost
					FROM [INFORMATICS2].dbo.SHELLunion00_ANN_GRANT
					--WHERE LINE_OF_BUSINESS = 'CL1'
					GROUP BY Cx,DxCx
					ORDER BY Cx,DxCx







-- ==========================================================
	-- COS (Category of Service) w HIERARCHY--
-- ==========================================================
					x COS HIERARCHY:
					'Psychiatrist'
					'SBIRT Services' --'SBIRT (Screening, Brief Intervention, and Referral to Treatment)'
					'Mental Health - Other'
					'Mental Health Pharmacy'

	--Reset [Mental Health Carve-In]--
UPDATE [INFORMATICS2].dbo.[SHELLunion00_RDT_MH]
SET [Mental Health Carve-In] = CAST(NULL AS nvarchar(100)) --CLEANSE()

	--'Psychiatrist'--
UPDATE [INFORMATICS2].dbo.[SHELLunion00_RDT_MH]
SET [Mental Health Carve-In] = 'Psychiatrist'
--SELECT su.*
FROM [INFORMATICS2].dbo.[SHELLunion00_RDT_MH] AS su
WHERE su.[Mental Health Carve-In] IS NULL
    AND LTRIM(RTRIM(su.PROVSPEC)) IN ('ADP','CAP','GEP','PSY') --ADDICTION PSYCHIATRY, CHILD & ADOLESCENT PSYCHIATRY, GERIATRIC PSYCHIATRY, PSYCHIATRY

UPDATE [INFORMATICS2].dbo.[SHELLunion00_RDT_MH]
SET [Mental Health Carve-In] = 'Psychiatrist'
--SELECT su.* -- CHECK 1st
FROM [INFORMATICS2].dbo.[SHELLunion00_RDT_MH] AS su
WHERE su.[Mental Health Carve-In] IS NULL
	AND SUBSTRING(LTRIM(RTRIM(su.PROCEDURE_CODE)),1,5) IN ('90791','90792','90833','90836','90838') --In Psychiatric category: Keep 90791, 90792 Drop 4063F, 4064F, 90863 Add 90833, 90836, 90838 AS OF 20171201 VIA email FROM Dawn Vacheresse <dvacheresse@chgsd.com>







	--'SBIRT (Screening, Brief Intervention, and Referral to Treatment)'--
UPDATE [INFORMATICS2].dbo.[SHELLunion00_RDT_MH]
SET [Mental Health Carve-In] = 'SBIRT Services' --'SBIRT (Screening, Brief Intervention, and Referral to Treatment)'
--SELECT su.* -- CHECK 1st
FROM [INFORMATICS2].dbo.[SHELLunion00_RDT_MH] AS su
WHERE su.[Mental Health Carve-In] IS NULL
	AND SUBSTRING(LTRIM(RTRIM(su.PROCEDURE_CODE)),1,5) IN ('99408','G0396','G0442','H0049','99409','G0397','G0443','H0050') --In SBIRT category – no changes. AS OF 20171201 VIA email FROM Dawn Vacheresse <dvacheresse@chgsd.com>







	--'Mental Health - Other'--
UPDATE [INFORMATICS2].dbo.[SHELLunion00_RDT_MH]
SET [Mental Health Carve-In] = 'Mental Health - Other'
--SELECT su.* -- CHECK 1st
FROM [INFORMATICS2].dbo.[SHELLunion00_RDT_MH] AS su
WHERE su.[Mental Health Carve-In] IS NULL
	AND SUBSTRING(LTRIM(RTRIM(su.PROCEDURE_CODE)),1,5) IN ('90832','90834','90837','90839','90840','90853','96101','96105','96110','96111','96116','96118','96120','99366','99368','Z0300','90785','90791','90792','90846','90847','90849')  --In MH-Other category Keep all previous codes, except Drop 90845. No additions. AS OF 20171201 VIA email FROM Dawn Vacheresse <dvacheresse@chgsd.com>

UPDATE [INFORMATICS2].dbo.[SHELLunion00_RDT_MH]
SET [Mental Health Carve-In] = 'Mental Health - Other'
--SELECT su.* -- CHECK 1st
FROM [INFORMATICS2].dbo.[SHELLunion00_RDT_MH] AS su
WHERE su.[Mental Health Carve-In] IS NULL
    AND su.SEQ_CLAIM_ID IN (SELECT DISTINCT sup.SEQ_CLAIM_ID -- The ENTIRE claim
FROM [INFORMATICS2].dbo.[SHELLunion00_RDT_MH] AS sup
	JOIN [INFORMATICS2].dbo.[SHELLcalic] AS mh ON LTRIM(RTRIM(PROVIDER_ID)) = LTRIM(RTRIM(sup.PROVID))
WHERE (LTRIM(RTRIM(mh.LICENSE)) LIKE '%LCSW%'
	OR LTRIM(RTRIM(mh.LICENSE)) LIKE '%PSY%')) --In MH-Other category Keep all previous codes, except Drop 90845. No additions. AS OF 20171201 VIA email FROM Dawn Vacheresse <dvacheresse@chgsd.com>







-- ========================================================
	--RDT Mental Health HIERARCHY DOUBLE CHECK (Trust yet VERIFY) --
------------------'Mental Health Pharmacy' makes FOUR (4)	
-- ========================================================
					x COS HIERARCHY:
					'Psychiatrist'
					'SBIRT Services' --'SBIRT (Screening, Brief Intervention, and Referral to Treatment)'
					'Mental Health - Other'
					'Mental Health Pharmacy'

UPDATE [INFORMATICS2].dbo.[SHELLunion00_RDT_MH]
SET [Mental Health Carve-In] = 'Psychiatrist'
--SELECT su.* -- CHECK 1st
FROM [INFORMATICS2].dbo.[SHELLunion00_RDT_MH] AS su
WHERE LTRIM(RTRIM(su.SEQ_CLAIM_ID)) IN (SELECT DISTINCT LTRIM(RTRIM(sup.SEQ_CLAIM_ID)) -- The ENTIRE claim
FROM [INFORMATICS2].dbo.[SHELLunion00_RDT_MH] AS sup
WHERE sup.[Mental Health Carve-In] = 'Psychiatrist')

UPDATE [INFORMATICS2].dbo.[SHELLunion00_RDT_MH]
SET [Mental Health Carve-In] = 'SBIRT Services' --'SBIRT (Screening, Brief Intervention, and Referral to Treatment)'
--SELECT su.* -- CHECK 1st
FROM [INFORMATICS2].dbo.[SHELLunion00_RDT_MH] AS su
WHERE LTRIM(RTRIM(su.SEQ_CLAIM_ID)) IN (SELECT DISTINCT LTRIM(RTRIM(sup.SEQ_CLAIM_ID)) -- The ENTIRE claim
FROM [INFORMATICS2].dbo.[SHELLunion00_RDT_MH] AS sup
WHERE sup.[Mental Health Carve-In] = 'SBIRT Services')

UPDATE [INFORMATICS2].dbo.[SHELLunion00_RDT_MH]
SET [Mental Health Carve-In] = 'Mental Health - Other'
--SELECT su.* -- CHECK 1st
FROM [INFORMATICS2].dbo.[SHELLunion00_RDT_MH] AS su
WHERE LTRIM(RTRIM(su.SEQ_CLAIM_ID)) IN (SELECT DISTINCT LTRIM(RTRIM(sup.SEQ_CLAIM_ID)) -- The ENTIRE claim
FROM [INFORMATICS2].dbo.[SHELLunion00_RDT_MH] AS sup
WHERE sup.[Mental Health Carve-In] = 'Mental Health - Other')







-- ==========================================================	
	--EXCLUSION(s) ;WITH 4. Excludes Behavioral Health Treament (BHT) services as defined IN the BHT category of service of the CY 2016 regular RDT.--	
-- ==========================================================
--------------------------------------------------------------------------------------------------------------------
	-- Error Trapping: Check If Permanent Table(s) Already Exist(s) And Drop If Applicable --
--------------------------------------------------------------------------------------------------------------------
IF OBJECT_ID('TempDB..#BHTEXCLUSION') IS NOT NULL
BEGIN

		DROP TABLE #BHTEXCLUSION --#TableName is a local temporary table visible only IN the current session; ##TableName is a global temporary table visible to all sessions IN 'tempdb'

END

SELECT DISTINCT su.SEQ_CLAIM_ID
INTO #BHTEXCLUSION  -- Behavioral Health Treatment (BHT)
-- SELECT TOP 10 * -- CHECK 1st
-- SELECT DISTINCT ' ' AS 'CHECK 1st'
FROM [INFORMATICS2].dbo.[SHELLunion00_RDT_MH] AS su
WHERE su.SEQ_CLAIM_ID IN (SELECT DISTINCT sup.SEQ_CLAIM_ID -- The ENTIRE claim
FROM [INFORMATICS2].dbo.[SHELLunion00_RDT_MH] AS sup
WHERE (UPPER(LTRIM(RTRIM(sup.prindiag))) IN ('299.00','F84.0') --Criteria #1: Autism Diagnosis Codes
	OR UPPER(LTRIM(RTRIM(sup.DIAGNOSIS_1))) IN ('299.00','F84.0') --Criteria #1: Autism Diagnosis Codes
	OR UPPER(LTRIM(RTRIM(sup.DIAGNOSIS_2))) IN ('299.00','F84.0') --Criteria #1: Autism Diagnosis Codes
	OR UPPER(LTRIM(RTRIM(sup.DIAGNOSIS_3))) IN ('299.00','F84.0') --Criteria #1: Autism Diagnosis Codes
	OR UPPER(LTRIM(RTRIM(sup.DIAGNOSIS_4))) IN ('299.00','F84.0') --Criteria #1: Autism Diagnosis Codes
	OR UPPER(LTRIM(RTRIM(sup.DIAGNOSIS_5))) IN ('299.00','F84.0') --Criteria #1: Autism Diagnosis Codes
	OR UPPER(LTRIM(RTRIM(sup.DIAGNOSIS_6))) IN ('299.00','F84.0') --Criteria #1: Autism Diagnosis Codes
	OR UPPER(LTRIM(RTRIM(sup.DIAGNOSIS_7))) IN ('299.00','F84.0') --Criteria #1: Autism Diagnosis Codes
	OR UPPER(LTRIM(RTRIM(sup.DIAGNOSIS_8))) IN ('299.00','F84.0') --Criteria #1: Autism Diagnosis Codes
	OR UPPER(LTRIM(RTRIM(sup.DIAGNOSIS_9))) IN ('299.00','F84.0')) --Criteria #1: Autism Diagnosis Codes
		AND UPPER(LTRIM(RTRIM(sup.PROCEDURE_CODE))) IN ('H0031','H0032','H0046','H2012','H2014','H2019','S5111','S5108','96152')) --,'S5108'))  --Criteria #2: Codes that trigger a BHT supplemental payment AND For monthly utilizer counts, please only count a utilizer month when a member utilized a procedure code ON the supplemental payment trigger list (Criteria #2 ON the [COS Grouping] tab). If a member had no utilization of a trigger service (i.e. only had costs categorized under non-trigger codes or CDEs), THEN do not record a utilizer month, however please still report the non-trigger and/or CDE experience for all members. ADDED 'S5108','96152' --Direct Member Unique Utilizers (DUU) for CY 2016:  Enter the count of unique utilizers (not utilizer months) for CY 2016. A member is a unique utilizer if they utilized any BHT service at any time IN CY 2016 (i.e. they were counted at least once IN the utilizer month column, and your health plan received a supplemental payment for the member). This is for direct members only; do not enter unique utilizer counts for global members. Also, do NOT count a member as a unique utilizer if they only received a CDE and not a BHT service IN CY 2016.)) --,'S5108'))

UNION ALL --VERTICAL() w UNION ALL()  - ROW(s) --STACK
SELECT DISTINCT su.SEQ_CLAIM_ID
FROM [INFORMATICS2].dbo.[SHELLunion00_RDT_MH] AS su
WHERE su.SEQ_CLAIM_ID IN (SELECT DISTINCT sup.SEQ_CLAIM_ID -- The ENTIRE claim
FROM [INFORMATICS2].dbo.[SHELLunion00_RDT_MH] AS sup
WHERE (UPPER(LTRIM(RTRIM(sup.prindiag))) IN ('299.00','F84.0') --Criteria #1: Autism Diagnosis Codes
	OR UPPER(LTRIM(RTRIM(sup.DIAGNOSIS_1))) IN ('299.00','F84.0') --Criteria #1: Autism Diagnosis Codes
	OR UPPER(LTRIM(RTRIM(sup.DIAGNOSIS_2))) IN ('299.00','F84.0') --Criteria #1: Autism Diagnosis Codes
	OR UPPER(LTRIM(RTRIM(sup.DIAGNOSIS_3))) IN ('299.00','F84.0') --Criteria #1: Autism Diagnosis Codes
	OR UPPER(LTRIM(RTRIM(sup.DIAGNOSIS_4))) IN ('299.00','F84.0') --Criteria #1: Autism Diagnosis Codes
	OR UPPER(LTRIM(RTRIM(sup.DIAGNOSIS_5))) IN ('299.00','F84.0') --Criteria #1: Autism Diagnosis Codes
	OR UPPER(LTRIM(RTRIM(sup.DIAGNOSIS_6))) IN ('299.00','F84.0') --Criteria #1: Autism Diagnosis Codes
	OR UPPER(LTRIM(RTRIM(sup.DIAGNOSIS_7))) IN ('299.00','F84.0') --Criteria #1: Autism Diagnosis Codes
	OR UPPER(LTRIM(RTRIM(sup.DIAGNOSIS_8))) IN ('299.00','F84.0') --Criteria #1: Autism Diagnosis Codes
	OR UPPER(LTRIM(RTRIM(sup.DIAGNOSIS_9))) IN ('299.00','F84.0')) --Criteria #1: Autism Diagnosis Codes
		AND UPPER(LTRIM(RTRIM(sup.PROCEDURE_CODE))) IN ('0364T','0370T','0365T','0371T','0366T','0372T','0367T','0373T','0368T','0374T','0369T')) --Criteria #3: Codes that reflect BHT services, but do not trigger a BHT supplemental payment. The cost for these services will be included IN the BHT supplemental payment amount. --Direct Member Unique Utilizers (DUU) for CY 2016:  Enter the count of unique utilizers (not utilizer months) for CY 2016. A member is a unique utilizer if they utilized any BHT service at any time IN CY 2016 (i.e. they were counted at least once IN the utilizer month column, and your health plan received a supplemental payment for the member). This is for direct members only; do not enter unique utilizer counts for global members. Also, do NOT count a member as a unique utilizer if they only received a CDE and not a BHT service IN CY 2016. 

UNION ALL --VERTICAL() w UNION ALL()  - ROW(s) --STACK
SELECT DISTINCT su.SEQ_CLAIM_ID
FROM [INFORMATICS2].dbo.[SHELLunion00_RDT_MH] AS su
WHERE UPPER(LTRIM(RTRIM(su.PROCEDURE_CODE))) IN ('90791','90792','96101','96102','96103','96105','96111','96116','96118','96119','96120','90785','0359T','0360T','0361T','0362T','0363T') --,'96152') --Criteria #4: Comprehensive Diagnostic Evaluation (CDE) services performed with the intent to determine an autism diagnosis LIMIT ON PROVIDER(s) NECESSARY TO ENSURE that the Comprehensive Diagnostic Evaluation (CDE) services is being performed with the INTENT to determine an autism diagnosis ADDED 'S5108','96152'
	AND (su.PROVID IN ('307271','147873','698','5492','330541971') --RENDERING()
		OR su.VENDID IN ('307271','147873','698','5492','330541971')) --PAYTO(s)
	----------------AND (su.PROVNM LIKE '%MOTIVA%' --RENDERING
	----------------	OR su.VENDNM LIKE '%MOTIVA%' --PAYTO
	----------------	OR su.PROVNM LIKE '%REGENT%' --RENDERING
	----------------	OR su.VENDNM LIKE '%REGENT%' --PAYTO
	----------------	OR su.PROVNM LIKE '%RADY%' --RENDERING
	----------------	OR su.VENDNM LIKE '%RADY%') --PAYTO
	
	--DUP(s) --
SELECT 'DUP Validation' AS [DUP NOTE(s)],*
FROM #BHTEXCLUSION
WHERE LTRIM(RTRIM(SEQ_CLAIM_ID)) IN (SELECT LTRIM(RTRIM(dup.SEQ_CLAIM_ID))
FROM #BHTEXCLUSION AS dup
GROUP BY LTRIM(RTRIM(dup.SEQ_CLAIM_ID)) --Duplication Driver
HAVING COUNT(1)>1) --HAVING clause RESERVED for AGGREGATE(s)

					UPDATE [INFORMATICS2].dbo.[SHELLunion00_RDT_MH]
					SET Cx = 'DELETE'
					-- SELECT TOP 10 * -- CHECK 1st
					-- SELECT DISTINCT ' ' AS 'CHECK 1st'
					FROM [INFORMATICS2].dbo.[SHELLunion00_RDT_MH] AS su
						JOIN #BHTEXCLUSION AS bht ON bht.SEQ_CLAIM_ID = su.SEQ_CLAIM_ID
						
					DELETE
					-- SELECT TOP 10 * -- CHECK 1st
					-- SELECT DISTINCT ' ' AS 'CHECK 1st'
					FROM [INFORMATICS2].dbo.[SHELLunion00_RDT_MH]
					WHERE  Cx = 'DELETE'

						--Review Summary--
					SELECT COALESCE (LINE_OF_BUSINESS,'SUBTOTAL - LOB') AS LINE_OF_BUSINESS
					,COALESCE ([Mental Health Carve-In],'SUBTOTAL - COS') AS [Mental Health Carve-In]
					,SUM(PAID_NET_AMT) AS [COST]
					------------------ SELECT TOP 10 * -- CHECK 1st
					------------------ SELECT DISTINCT ' ' AS 'CHECK 1st'
					FROM INFORMATICS2.dbo.SHELLunion00_RDT_MH
					--WHERE  [Mental Health Carve-In] IS NOT NULL
					GROUP BY CUBE (LINE_OF_BUSINESS,[Mental Health Carve-In]) -- The CUBE Operator  The CUBE operator is also used IN combination with the GROUP BY clause, however the CUBE operator produces results by generating all combinations of columns specified IN the “GROUP BY CUBE” clause. 







-- ==========================================================
	--RDT Mental Health Pharmacy--
-- ==========================================================		
--SELECT TOP 1000 CxDx,RxCx,* FROM INFORMATICS2.dbo.SHELL_Rx_RDT_MH --SET PHARMACY table USE CxDx for [Mental Health Carve-In] designation

----------------SELECT * FROM SQL13.INFORMATICS2.dbo.SHELL_MHgcn --BUILD FROM TEMPLATE .xlsx DROP TABLE INFORMATICS2.dbo.SHELL_MHgcn
----------------SELECT * FROM SQL13.INFORMATICS2.dbo.SHELL_MHndc --BUILD FROM TEMPLATE .xlsx DROP TABLE INFORMATICS2.dbo.SHELL_MHndc

		-- DEPRECATED SAME AS 'SHELL_MHgcn'...SELECT * FROM INFORMATICS2.dbo.SHELL_MHrx

	--Reset CxDx--
UPDATE [INFORMATICS2].dbo.SHELL_Rx_RDT_MH
SET [Mental Health Carve-In] = CAST(NULL AS nvarchar(100)) --CLEANSE() ,CAST(NULL AS nvarchar(100)) AS [Mental Health Carve-In] --RDT MH

UPDATE [INFORMATICS2].dbo.SHELL_Rx_RDT_MH
SET [Mental Health Carve-In] = 'Mental Health Pharmacy'
--SELECT mh.*,rx.* -- CHECK 1st
FROM [INFORMATICS2].dbo.SHELL_Rx_RDT_MH AS rx
	JOIN INFORMATICS2.dbo.SHELL_MHgcn AS mh ON LTRIM(RTRIM(mh.IDis)) COLLATE DATABASE_DEFAULT = LTRIM(RTRIM(rx.GenericCodeNumber)) COLLATE DATABASE_DEFAULT

UPDATE [INFORMATICS2].dbo.SHELL_Rx_RDT_MH
SET [Mental Health Carve-In] = 'Mental Health Pharmacy'
--SELECT mh.*,rx.* -- CHECK 1st
FROM [INFORMATICS2].dbo.SHELL_Rx_RDT_MH AS rx
	JOIN INFORMATICS2.dbo.SHELL_MHndc AS mh ON LTRIM(RTRIM(mh.IDis)) COLLATE DATABASE_DEFAULT = LTRIM(RTRIM(rx.NDCNumber))	COLLATE DATABASE_DEFAULT

						--Review Summary--
					SELECT COALESCE (LINE_OF_BUSINESS,'SUBTOTAL - LOB') AS LINE_OF_BUSINESS
					,COALESCE ([Mental Health Carve-In],'SUBTOTAL - COS') AS [Mental Health Carve-In]
					,SUM(PaidAmount) AS [COST]
					------------------ SELECT TOP 10 * -- CHECK 1st
					------------------ SELECT DISTINCT ' ' AS 'CHECK 1st'
					FROM INFORMATICS2.dbo.SHELL_Rx_RDT_MH
					--WHERE  [Mental Health Carve-In] IS NOT NULL
					GROUP BY CUBE (LINE_OF_BUSINESS,[Mental Health Carve-In]) -- The CUBE Operator  The CUBE operator is also used IN combination with the GROUP BY clause, however the CUBE operator produces results by generating all combinations of columns specified IN the “GROUP BY CUBE” clause.







-- =============================================================
	-- DEFINE SUD (Substance Abuse Disorder(s)) population--
-- =============================================================
x SOURCE(s):
		SELECT * FROM [INFORMATICS2].dbo.[SHELLunion00]
		SELECT * FROM #ContinuousEnrollment
		SELECT * FROM INFORMATICS.dbo.EligiblePopulation
		SELECT * FROM INFORMATICS.dbo.SUD_Dx_codes -- USE 'ICD9cx' OR 'DxCx'
		SELECT * FROM INFORMATICS.dbo.SUD_REV_PROC_codes -- USE 'ICD9cx' OR 'DxCx'
		--SELECT * FROM INFORMATICS.dbo.SUD_EDcodes

UPDATE [INFORMATICS2].dbo.[SHELLunion00]
SET DxCx = CAST(NULL AS nvarchar(100)) --AS DxCx -- POST PRODUCTION QUPD		

UPDATE [INFORMATICS2].dbo.[SHELLunion00]
SET DxCx = 'SUD'
--SELECT * -- CHECK 1st
FROM [INFORMATICS2].dbo.[SHELLunion00] AS su
	JOIN INFORMATICS.dbo.SUD_Dx_codes AS xw ON (REPLACE(LTRIM(RTRIM(xw.CLEANcode)),'.','') = REPLACE(LTRIM(RTRIM(su.prindiag)),'.','')
		OR REPLACE(LTRIM(RTRIM(xw.CLEANcode)),'.','') = REPLACE(LTRIM(RTRIM(su.DIAGNOSIS_1)),'.','')
		OR REPLACE(LTRIM(RTRIM(xw.CLEANcode)),'.','') = REPLACE(LTRIM(RTRIM(su.DIAGNOSIS_2)),'.','')
		OR REPLACE(LTRIM(RTRIM(xw.CLEANcode)),'.','') = REPLACE(LTRIM(RTRIM(su.DIAGNOSIS_3)),'.','')
		OR REPLACE(LTRIM(RTRIM(xw.CLEANcode)),'.','') = REPLACE(LTRIM(RTRIM(su.DIAGNOSIS_4)),'.','')
		OR REPLACE(LTRIM(RTRIM(xw.CLEANcode)),'.','') = REPLACE(LTRIM(RTRIM(su.DIAGNOSIS_5)),'.','')
		OR REPLACE(LTRIM(RTRIM(xw.CLEANcode)),'.','') = REPLACE(LTRIM(RTRIM(su.DIAGNOSIS_6)),'.','')
		OR REPLACE(LTRIM(RTRIM(xw.CLEANcode)),'.','') = REPLACE(LTRIM(RTRIM(su.DIAGNOSIS_7)),'.','')
		OR REPLACE(LTRIM(RTRIM(xw.CLEANcode)),'.','') = REPLACE(LTRIM(RTRIM(su.DIAGNOSIS_8)),'.','')
		OR REPLACE(LTRIM(RTRIM(xw.CLEANcode)),'.','') = REPLACE(LTRIM(RTRIM(su.DIAGNOSIS_9)),'.',''))
WHERE DxCx IS NULL

-- UPDATE [INFORMATICS2].dbo.[SHELLunion00]
--SET DxCx = 'SUD'
----SELECT * -- CHECK 1st
--FROM [INFORMATICS2].dbo.[SHELLunion00] AS su
--	JOIN INFORMATICS.dbo.SUD_REV_PROC_codes AS xw ON UPPER(LTRIM(RTRIM(xw.CLEANcode))) = UPPER(LTRIM(RTRIM(su.PROCEDURE_CODE))) --SUBSTRING(LTRIM(RTRIM(cd.servcode)),1,5) AS PROCEDURE_CODE
--WHERE DxCx IS NULL

UPDATE [INFORMATICS2].dbo.[SHELLunion00]
SET DxCx = 'SUD'
--SELECT * -- CHECK 1st
FROM [INFORMATICS2].dbo.SHELLunion00 AS su
	JOIN INFORMATICS.dbo.SUD_REV_PROC_codes AS xw ON CASE
WHEN SUBSTRING(LTRIM(RTRIM(xw.CLEANcode)),1,1) = 'Z'
THEN  LTRIM(RTRIM(xw.CLEANcode))
WHEN SUBSTRING(LTRIM(RTRIM(xw.CLEANcode)),1,1) = '0'
THEN  SUBSTRING(LTRIM(RTRIM(xw.CLEANcode)),2,3)
ELSE LTRIM(RTRIM(xw.CLEANcode))
END = UPPER(LTRIM(RTRIM(su.REVCDE)))
	OR UPPER(LTRIM(RTRIM(xw.CLEANcode))) = UPPER(LTRIM(RTRIM(su.PROCEDURE_CODE)))
WHERE DxCx IS NULL

--SELECT xw.*,su.* -- CHECK 1st
--FROM INFORMATICS.dbo.SHELLunion00_PREVIOUS_SUD AS su
--	JOIN INFORMATICS.dbo.SUD_REV_PROC_codes AS xw ON UPPER(LTRIM(RTRIM(xw.CLEANcode))) = UPPER(LTRIM(RTRIM(su.PROCEDURE_CODE)))







-- ==========================================================
	-- COS (Category of Service) w HIERARCHY (FAMILY PLANNING) --
-- ==========================================================
	--RESET Cx--
UPDATE [INFORMATICS2].dbo.[SHELLunion00]
SET Cx = CAST(NULL AS nvarchar(100)) --CLEANSE()

	--'Family Planning'--
UPDATE [INFORMATICS2].dbo.[SHELLunion00]
SET Cx = 'Family Planning'
--SELECT *
FROM [INFORMATICS2].dbo.[SHELLunion00] AS su
WHERE su.Cx IS NULL
	AND su.SEQ_CLAIM_ID IN (SELECT DISTINCT sup.SEQ_CLAIM_ID -- The ENTIRE claim
FROM [INFORMATICS2].dbo.[SHELLunion00] AS sup
WHERE LTRIM(RTRIM(PROCEDURE_CODE)) IN ('Z1032','Z1034','Z1036','Z1038','59400','59510','59610','59618','99384','99394','J7300','J7301','J7302','J7303','J7304','S4993','J7307','11976','11981','S5199'))
							
UPDATE [INFORMATICS2].dbo.[SHELLunion00]
SET Cx = 'Family Planning'
--SELECT *
FROM [INFORMATICS2].dbo.[SHELLunion00] AS su
WHERE su.Cx IS NULL
	AND su.SEQ_CLAIM_ID IN (SELECT DISTINCT sup.SEQ_CLAIM_ID -- The ENTIRE claim
FROM [INFORMATICS2].dbo.[SHELLunion00] AS sup
WHERE LTRIM(RTRIM(PROCEDURE_CODE)) IN ('J3490')
	AND LTRIM(RTRIM(PROCEDURE_MODIFIER)) IN ('U5','U6','U8'))

UPDATE [INFORMATICS2].dbo.[SHELLunion00]
SET Cx = 'Family Planning'
--SELECT *
FROM [INFORMATICS2].dbo.[SHELLunion00] AS su
WHERE su.Cx IS NULL
	AND su.SEQ_CLAIM_ID IN (SELECT DISTINCT sup.SEQ_CLAIM_ID -- The ENTIRE claim
FROM [INFORMATICS2].dbo.[SHELLunion00] AS sup
WHERE LTRIM(RTRIM(PROCEDURE_CODE)) IN ('A4269')
	AND LTRIM(RTRIM(PROCEDURE_MODIFIER)) IN ('U1','U2','U3','U4'))

UPDATE [INFORMATICS2].dbo.[SHELLunion00]
SET Cx = 'Family Planning'
--SELECT *
FROM [INFORMATICS2].dbo.[SHELLunion00] AS su
WHERE su.Cx IS NULL
	AND su.SEQ_CLAIM_ID IN (SELECT DISTINCT sup.SEQ_CLAIM_ID -- The ENTIRE claim
FROM [INFORMATICS2].dbo.[SHELLunion00] AS sup
WHERE LTRIM(RTRIM(PROCEDURE_CODE)) BETWEEN '99201' AND '99215'
	OR LTRIM(RTRIM(PROCEDURE_CODE)) BETWEEN 'Z6200' AND 'Z6500'
	OR LTRIM(RTRIM(PROCEDURE_CODE)) BETWEEN '99241' AND '99245'
	OR LTRIM(RTRIM(PROCEDURE_CODE)) BETWEEN '99281' AND '99285'
	OR LTRIM(RTRIM(PROCEDURE_CODE)) BETWEEN '99341' AND '99353')

UPDATE [INFORMATICS2].dbo.[SHELLunion00]
SET Cx = 'Family Planning'
--SELECT su.*
FROM [INFORMATICS2].dbo.[SHELLunion00] AS su
WHERE su.Cx IS NULL
	AND (UPPER(LTRIM(RTRIM(prindiag))) BETWEEN 'V25.0' AND 'V5.02'
		OR UPPER(LTRIM(RTRIM(DIAGNOSIS_1))) BETWEEN 'V25.0' AND 'V5.02'
		OR UPPER(LTRIM(RTRIM(DIAGNOSIS_2))) BETWEEN 'V25.0' AND 'V5.02'
		OR UPPER(LTRIM(RTRIM(DIAGNOSIS_3))) BETWEEN 'V25.0' AND 'V5.02'
		OR UPPER(LTRIM(RTRIM(DIAGNOSIS_4))) BETWEEN 'V25.0' AND 'V5.02'
		OR UPPER(LTRIM(RTRIM(DIAGNOSIS_5))) BETWEEN 'V25.0' AND 'V5.02'
		OR UPPER(LTRIM(RTRIM(DIAGNOSIS_6))) BETWEEN 'V25.0' AND 'V5.02'
		OR UPPER(LTRIM(RTRIM(DIAGNOSIS_7))) BETWEEN 'V25.0' AND 'V5.02'
		OR UPPER(LTRIM(RTRIM(DIAGNOSIS_8))) BETWEEN 'V25.0' AND 'V5.02'
		OR UPPER(LTRIM(RTRIM(DIAGNOSIS_9))) BETWEEN 'V25.0' AND 'V5.02')
		
UPDATE [INFORMATICS2].dbo.[SHELLunion00]
SET Cx = 'Family Planning'
--SELECT su.*
FROM [INFORMATICS2].dbo.[SHELLunion00] AS su
	JOIN INFORMATICS.dbo.FP_DIAG AS fpd ON UPPER(REPLACE(LTRIM(RTRIM(fpd.CLEANDIAG)),'.','')) = UPPER(REPLACE(LTRIM(RTRIM(su.prindiag)),'.',''))
		OR UPPER(REPLACE(LTRIM(RTRIM(fpd.CLEANDIAG)),'.','')) = UPPER(REPLACE(LTRIM(RTRIM(su.DIAGNOSIS_1)),'.',''))
		OR UPPER(REPLACE(LTRIM(RTRIM(fpd.CLEANDIAG)),'.','')) = UPPER(REPLACE(LTRIM(RTRIM(su.DIAGNOSIS_2)),'.',''))
		OR UPPER(REPLACE(LTRIM(RTRIM(fpd.CLEANDIAG)),'.','')) = UPPER(REPLACE(LTRIM(RTRIM(su.DIAGNOSIS_3)),'.',''))
		OR UPPER(REPLACE(LTRIM(RTRIM(fpd.CLEANDIAG)),'.','')) = UPPER(REPLACE(LTRIM(RTRIM(su.DIAGNOSIS_4)),'.',''))
		OR UPPER(REPLACE(LTRIM(RTRIM(fpd.CLEANDIAG)),'.','')) = UPPER(REPLACE(LTRIM(RTRIM(su.DIAGNOSIS_5)),'.',''))
		OR UPPER(REPLACE(LTRIM(RTRIM(fpd.CLEANDIAG)),'.','')) = UPPER(REPLACE(LTRIM(RTRIM(su.DIAGNOSIS_6)),'.',''))
		OR UPPER(REPLACE(LTRIM(RTRIM(fpd.CLEANDIAG)),'.','')) = UPPER(REPLACE(LTRIM(RTRIM(su.DIAGNOSIS_7)),'.',''))
		OR UPPER(REPLACE(LTRIM(RTRIM(fpd.CLEANDIAG)),'.','')) = UPPER(REPLACE(LTRIM(RTRIM(su.DIAGNOSIS_8)),'.',''))
		OR UPPER(REPLACE(LTRIM(RTRIM(fpd.CLEANDIAG)),'.','')) = UPPER(REPLACE(LTRIM(RTRIM(su.DIAGNOSIS_9)),'.',''))
WHERE su.Cx IS NULL







-- ========================================================
	--COS (Category of Service) HIERARCHY DOUBLE CHECK (Trust yet VERIFY) --
-- ========================================================
UPDATE [INFORMATICS2].dbo.[SHELLunion00]
SET Cx = 'Family Planning'
--SELECT su.* -- CHECK 1st
FROM [INFORMATICS2].dbo.[SHELLunion00] AS su
WHERE LTRIM(RTRIM(su.SEQ_CLAIM_ID)) IN (SELECT DISTINCT LTRIM(RTRIM(sup.SEQ_CLAIM_ID)) -- The ENTIRE claim
FROM [INFORMATICS2].dbo.[SHELLunion00] AS sup
WHERE sup.Cx = 'Family Planning')

		SELECT Cx
		,SUM(PAID_NET_AMT) AS Cost
		FROM [INFORMATICS2].dbo.SHELLunion00
		--WHERE LINE_OF_BUSINESS = 'CL1'
		GROUP BY  Cx
		ORDER BY Cx







-- ==========================================================
	-- COS (Category of Service) w HIERARCHY (ABA BHT) --
-- ==========================================================
----------------SELECT TOP 10 * FROM [INFORMATICS2].dbo.[SHELLunion00]

----------------x COS HIERARCHY:
----------------		'Behavioral Health Treatment (BHT)'
----------------		'Comprehensive Diagnostic Evaluation (CDE)'
		
----------------Logic Format Notes: 1) All bullet points under each criteria must be met to satisfy that criteria. 2) For COS()s where there are multiple criteria, there is a line that reads: "Criteria Combinations". This line explains which criteria need to be met IN order to satisfy the requirement for assignment to The COS. For example, IN the inpatient logic, the line reads, "Criteria Combinations - (1,2) or (1,3)". Therefore, if criteria 1 AND 2 or 1 AND 3 are met, THEN the claim should be coded as inpatient.

----------------Description: All expenses related to BHT services such as Applied Behavioral Analysis (ABA) and other evidence-based behavioral intervention services that prevent or minimize the adverse effects of Autism Spectrum Disorder (ASD). Services include, but are not limited to:
----------------		- Comprehensive Diagnostic Evaluation (CDE)
----------------		- Behavioral assessment
----------------		- Treatment planning
----------------		- Delivery of evidence based BHT services
----------------		- Training of parents/guardians
----------------		- Case management

----------------					ICD9Cx IN ('299.00','F84.0') --Criteria #1: Autism Diagnosis Codes
----------------						WITH
----------------					Cx IN ('H0031','H0032','H0046','H2012','H2014','H2019','S5111') --Criteria #2: Codes that trigger a BHT supplemental payment

----------------					ICD9Cx IN ('299.00','F84.0') --Criteria #1: Autism Diagnosis Codes
----------------						WITH
----------------					Cx IN ('0364T','0370T','0365T','0371T','0366T','0372T','0367T','0373T','0368T','0374T','0369T') --Criteria #3: Codes that reflect BHT services, but do not trigger a BHT supplemental payment. The cost for these services will be included IN the BHT supplemental payment amount.

----------------					Cx IN ('90791','90792','96101','96102','96103','96105','96111','96116','96118','96119','96120','90785','0359T','0360T','0361T','0362T','0363T') --Criteria #4: Comprehensive Diagnostic Evaluation (CDE) services performed with the intent to determine an autism diagnosis

	--RESET Cx--
UPDATE [INFORMATICS2].dbo.[SHELLunion00]
SET Cx = CAST(NULL AS nvarchar(100)) --CLEANSE()

	--Behavioral Health Treatment (BHT) --	
UPDATE [INFORMATICS2].dbo.[SHELLunion00]
SET Cx = 'Behavioral Health Treatment (BHT)'
--SELECT su.*
FROM [INFORMATICS2].dbo.[SHELLunion00] AS su
WHERE su.Cx IS NULL
    AND su.SEQ_CLAIM_ID IN (SELECT DISTINCT sup.SEQ_CLAIM_ID -- The ENTIRE claim
FROM [INFORMATICS2].dbo.[SHELLunion00] AS sup
WHERE (UPPER(LTRIM(RTRIM(sup.prindiag))) IN ('299.00','F84.0') --Criteria #1: Autism Diagnosis Codes
	OR UPPER(LTRIM(RTRIM(sup.DIAGNOSIS_1))) IN ('299.00','F84.0') --Criteria #1: Autism Diagnosis Codes
	OR UPPER(LTRIM(RTRIM(sup.DIAGNOSIS_2))) IN ('299.00','F84.0') --Criteria #1: Autism Diagnosis Codes
	OR UPPER(LTRIM(RTRIM(sup.DIAGNOSIS_3))) IN ('299.00','F84.0') --Criteria #1: Autism Diagnosis Codes
	OR UPPER(LTRIM(RTRIM(sup.DIAGNOSIS_4))) IN ('299.00','F84.0') --Criteria #1: Autism Diagnosis Codes
	OR UPPER(LTRIM(RTRIM(sup.DIAGNOSIS_5))) IN ('299.00','F84.0') --Criteria #1: Autism Diagnosis Codes
	OR UPPER(LTRIM(RTRIM(sup.DIAGNOSIS_6))) IN ('299.00','F84.0') --Criteria #1: Autism Diagnosis Codes
	OR UPPER(LTRIM(RTRIM(sup.DIAGNOSIS_7))) IN ('299.00','F84.0') --Criteria #1: Autism Diagnosis Codes
	OR UPPER(LTRIM(RTRIM(sup.DIAGNOSIS_8))) IN ('299.00','F84.0') --Criteria #1: Autism Diagnosis Codes
	OR UPPER(LTRIM(RTRIM(sup.DIAGNOSIS_9))) IN ('299.00','F84.0')) --Criteria #1: Autism Diagnosis Codes
		AND UPPER(LTRIM(RTRIM(sup.PROCEDURE_CODE))) IN ('H0031','H0032','H0046','H2012','H2014','H2019','S5111')) --,'S5108')) --Criteria #2: Codes that trigger a BHT supplemental payment AND For monthly utilizer counts, please only count a utilizer month when a member utilized a procedure code ON the supplemental payment trigger list (Criteria #2 ON the [COS Grouping] tab). If a member had no utilization of a trigger service (i.e. only had costs categorized under non-trigger codes or CDEs), THEN do not record a utilizer month, however please still report the non-trigger and/or CDE experience for all members. ADDED 'S5108','96152'
	
	--Behavioral Health Treatment (BHT) --	
UPDATE [INFORMATICS2].dbo.[SHELLunion00]
SET Cx = 'Behavioral Health Treatment (BHT)'
--SELECT su.*
FROM [INFORMATICS2].dbo.[SHELLunion00] AS su
WHERE su.Cx IS NULL
    AND su.SEQ_CLAIM_ID IN (SELECT DISTINCT sup.SEQ_CLAIM_ID -- The ENTIRE claim
FROM [INFORMATICS2].dbo.[SHELLunion00] AS sup
WHERE (UPPER(LTRIM(RTRIM(sup.prindiag))) IN ('299.00','F84.0') --Criteria #1: Autism Diagnosis Codes
	OR UPPER(LTRIM(RTRIM(sup.DIAGNOSIS_1))) IN ('299.00','F84.0') --Criteria #1: Autism Diagnosis Codes
	OR UPPER(LTRIM(RTRIM(sup.DIAGNOSIS_2))) IN ('299.00','F84.0') --Criteria #1: Autism Diagnosis Codes
	OR UPPER(LTRIM(RTRIM(sup.DIAGNOSIS_3))) IN ('299.00','F84.0') --Criteria #1: Autism Diagnosis Codes
	OR UPPER(LTRIM(RTRIM(sup.DIAGNOSIS_4))) IN ('299.00','F84.0') --Criteria #1: Autism Diagnosis Codes
	OR UPPER(LTRIM(RTRIM(sup.DIAGNOSIS_5))) IN ('299.00','F84.0') --Criteria #1: Autism Diagnosis Codes
	OR UPPER(LTRIM(RTRIM(sup.DIAGNOSIS_6))) IN ('299.00','F84.0') --Criteria #1: Autism Diagnosis Codes
	OR UPPER(LTRIM(RTRIM(sup.DIAGNOSIS_7))) IN ('299.00','F84.0') --Criteria #1: Autism Diagnosis Codes
	OR UPPER(LTRIM(RTRIM(sup.DIAGNOSIS_8))) IN ('299.00','F84.0') --Criteria #1: Autism Diagnosis Codes
	OR UPPER(LTRIM(RTRIM(sup.DIAGNOSIS_9))) IN ('299.00','F84.0')) --Criteria #1: Autism Diagnosis Codes
		AND UPPER(LTRIM(RTRIM(sup.PROCEDURE_CODE))) IN ('0364T','0370T','0365T','0371T','0366T','0372T','0367T','0373T','0368T','0374T','0369T')) --Criteria #3: Codes that reflect BHT services, but do not trigger a BHT supplemental payment. The cost for these services will be included IN the BHT supplemental payment amount.







	--Comprehensive Diagnostic Evaluation (CDE) --	
UPDATE [INFORMATICS2].dbo.[SHELLunion00]
SET Cx = 'Comprehensive Diagnostic Evaluation (CDE)'
--SELECT su.*
FROM [INFORMATICS2].dbo.[SHELLunion00] AS su
WHERE su.Cx IS NULL
    AND UPPER(LTRIM(RTRIM(su.PROCEDURE_CODE))) IN ('90791','90792','96101','96102','96103','96105','96111','96116','96118','96119','96120','90785','0359T','0360T','0361T','0362T','0363T') --,'96152') --Criteria #4: Comprehensive Diagnostic Evaluation (CDE) services performed with the intent to determine an autism diagnosis LIMIT ON PROVIDER(s) NECESSARY TO ENSURE that the Comprehensive Diagnostic Evaluation (CDE) services is being performed with the INTENT to determine an autism diagnosis ADDED 'S5108','96152'
	AND (su.PROVID IN ('307271','147873','698','5492','330541971') --RENDERING()
		OR su.VENDID IN ('307271','147873','698','5492','330541971')) --PAYTO(s)







-- ========================================================
	-- RDT HIERARCHY DOUBLE CHECK (Trust yet VERIFY) --
-- ========================================================
-- 'Behavioral Health Treatment (BHT)'
-- 'Comprehensive Diagnostic Evaluation (CDE)'

UPDATE [INFORMATICS2].dbo.[SHELLunion00]
SET Cx = 'Behavioral Health Treatment (BHT)'
FROM [INFORMATICS2].dbo.[SHELLunion00] AS su
WHERE LTRIM(RTRIM(su.SEQ_CLAIM_ID)) IN (SELECT DISTINCT LTRIM(RTRIM(sup.SEQ_CLAIM_ID)) -- The ENTIRE claim
FROM [INFORMATICS2].dbo.[SHELLunion00] AS sup
WHERE sup.Cx = 'Behavioral Health Treatment (BHT)')

UPDATE [INFORMATICS2].dbo.[SHELLunion00]
SET Cx = 'Comprehensive Diagnostic Evaluation (CDE)'
FROM [INFORMATICS2].dbo.[SHELLunion00] AS su
WHERE LTRIM(RTRIM(su.SEQ_CLAIM_ID)) IN (SELECT DISTINCT LTRIM(RTRIM(sup.SEQ_CLAIM_ID)) -- The ENTIRE claim
FROM [INFORMATICS2].dbo.[SHELLunion00] AS sup
WHERE sup.Cx = 'Comprehensive Diagnostic Evaluation (CDE)')

	--Review Summary--
SELECT Cx
,SUM(PAID_NET_AMT) AS Cost
,SYSis
FROM [INFORMATICS2].dbo.SHELLunion00
--FROM [INFORMATICS2].dbo.SHELLunion00_RDT_ABA_BHT
GROUP BY  Cx,SYSis
ORDER BY SYSis,Cx

	--LEFT-OVER(s) ANALYSIS--
USE HMOPROD_PLANDATA --(SQL09) Production
SELECT  DISTINCT Cx,rdt.SYSIs
--,rdt.[BB FLAG]
,[CLM TYPE]
,rdt.PLACE_OF_SERVICE_1,rdt.POS
,rdt.BILL_TYPE,bt.BillTypeDescr
FROM [INFORMATICS2].dbo.[SHELLunion00]AS rdt--Medical Claim(s)
	JOIN INFORMATICS.dbo.[uvw_CLAIMS_BILLTYPE] AS bt ON bt.QNXTbilltype = rdt.BILL_TYPE
WHERE 1=1
	AND rdt.Cx LIKE '%Other%'	
	-- AND QNXTbilltype LIKE '11%'	
ORDER BY rdt.BILL_TYPE
