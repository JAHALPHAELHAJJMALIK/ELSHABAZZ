 -- =============================================================
	-- JAH CHECKLIST - DISCIPLINE = FREEDOM: 
-- =============================================================
JAH CHARINDEX() FIND() SEARCH(): 'FROM: WALTER TO:CLAUDIA'

		USE https://cloud.google.com/bigquery
		USER: CHG\svc-ssrs-datasources - 'DEFAULT SUBSCRIPTION' USER 'SERVICE ACCOUNT' OVER CHG\wcarr

💯 FOR CONTEXT ... STEP BY STEP / FEATURE BY FEATURE / PRO v CON / SIDE BY SIDE / BLOCK BY BLOCK,'ai PROMPT ETTIQUETTE' ... WITH() THE AUDIENCE AS ...  'THE KEY STONE KEYSTONE',Consider using MERGE statements instead of separate UPDATE statements where applicable ...  Good Day, ... IN the context OF HMO Healthcare 

		⏎ Good day, YOU ARE THE TOP 0.1% OF Senior Data Analyst WITH 20+ years of EXPERIENCE. The lovely Ms Claudia has tasked us with an ECM CS Claims Utilization Report ask. 
				~ I have leveraged my Claims utilization script ('C:\Users\wcarr\Desktop\ECM_CS_UTILIZATION_REPORT_20260709.sql') AS the BASELINE CODE
				~ I then leveraged the CS script ('C:\Users\wcarr\Desktop\STEP88 CS COMMUNITYSUPPORT POPULATION 20260605.sql')  for the CS CODESET REQUIREMENT.
				~ Upon following up with Ms Claudia as to how she wished to define ECM claims utilization via a Teams chat she provided some feedback (see the attached screen cpature for context ... I incorporated it into my BASELINE CODE)
				~ I have two ASK of you:
						1. PLEASE ENSURE ALIGNMENT BETWEEN the existing CODE AND the ASK
						2. PRODUCE AN INTERACTIVE html DATA FLOW DIAGRAM (DFD) FAITHFUL TO THE TEMPLATE (USE [PATH]: file:///C:/Users/wcarr/Desktop/IHA%20Medi-Cal%20Data%20Flow%20v2_CHGSD%20Informatics.html) DARK AESTHETIC AND LAYOUT DESIGN


		⏎ Good day, YOU ARE THE TOP 0.1% OF Senior Data Analyst WITH 20+ years of EXPERIENCE. Seems that the lovely Ms Claudia would like some refinements to this task. Specifically to break out the summary by the individual CS services [Cx], rather than the [InclusionExclusionType] alone. May I have you assist in updating C:\Users\wcarr\Desktop\ECM_CS_UTILIZATION_REPORT_20260713.sql.
				~ I believe we can execute an UPDATE statement that populates the [Cx] with the CS service. We can leverage C:\Users\wcarr\Desktop\STEP88 CS COMMUNITYSUPPORT POPULATION 20260605.sql for those definitions as was done when we originally developed the script.
		
x SEQUENCE():
		STEP01: 'ECM_CS_UTILIZATION_REPORT_...sql' - ;EXEC IN [SQLPROD02];

		STEP99 'eMAIL DELIVERABLE': Good day ... report analysis is available for your review and approval at the following location: 'FROM:WALTER SUBJECT "*ECM*" TO:CLAUDIA'
		STEP99: QA USE [PATH]: file://chg_cifs01/depts/Informatics/wcarr/JAHstaging/QA%20informatics-InformaticsQualityChecklist-030524-0818-4.pdf - 'QA informatics-InformaticsQualityChecklist-030524-0818-4.pdf'		
		STEP99: QA USE: http://chgconflu.chg.com:8090/display/informatics/Informatics+QA+Process+Improvement - 'SIR AARON QA'







-- ======================================
	-- NOTE(S) | COMMENT(S): 
-- ======================================
JAH 'ECM CS UTILIZATION UCLA SURVEY LOGIC'
		USE [PATH]: C:\Users\wcarr\Desktop\CS Template UCLA Survey.xlsx - 'REVISIT CS SRVICES LOGIC'

		⏎ There is a story that the Lovely Ms Claudia & the C-SUITE team would LIKE to tell. The initial version apparently did not deliver & as such they now seek to revise the CS Services logic (see C:\Users\wcarr\Desktop\CS Template UCLA Survey.xlsx & the attached screen capture for context). May I have you assist in updating the CODE 'C:\Users\wcarr\Desktop\ECM_CS_UTILIZATION_REPORT_20260715.sql' for Ms Claudia?

-- =============================================================
	--  MS EXCEL OLE DB ODBC:
-- =============================================================
SELECT ' ' AS 'MS EXCEL OLE DB ODBC #BASELINE DETAIL: '
,su.[Cx] AS [ECM CS Category of Service]
,su.ClaimCategory
,su.ExecutionDate
,su.LINE_OF_BUSINESS
,su.[RANGE NOTE(s)]
,su.[THE FINAL CLAIM]
,su.[PLAN]
,su.PROGRAM
,su.[CONTRACT DESCRIPTION]
,su.AUTH_NUMBER
,su.[CPT Service Code]
,su.[CPT Service Description]
,su.modcode
,su.modcode2
,su.modcode3
,su.modcode4
,su.modcode5
,su.DupID
,su.CIN
,su.PROVNM
,su.PAYTO
,su.NPIpayto
,su.PAYTONM
,su.claimid
,su.claimline
,su.dosfrom
,su.dosto
,su.HEADERstatus
,su.TOTAL_PAID_AMOUNT 
FROM INFORMATICS.dbo.ECM_CS_UTILIZATION AS su
WHERE 1=1
        AND su.[ClaimCategory] IN ('Paid')
		AND NOT ISNULL(PAID_NET_AMT,0) = 0 -- NO NOT NEGATIVE <> != ...

x Hi Walter, 

Thanks so much for your help so far in helping us capture the data for all paid claims for ECM and CS from January 1- June 30th. As we discussed, there were some CS services missing from the report and the reason for this is because the HCPC Code and Modifier combination fields were limited. With CS services, a few have the same HCPC code, but different modifiers so it’s important that we can differentiate them.  

I have provided all the CS Codes and Modifiers for all. See below and attached. 

Using the same reporting period, 1/1/26-6/3/26, can you please re-run the report to capture paid claims for the services below? If possible, could you incorporate the naming convention for the CS Service as well? If not, no worries. Adding all the codes and mods are our top priority at this point. 😊

		CS Service Name	HCPC Code 	Modifier 
		Housing Transition Navigation Services 	H0043	U6
		Housing Transition Navigation Services 	H2016	U6
		Housing Deposit 	H0044	U2
		Housing Tenancy and Sustaining Services	T2040	U6
		Housing Tenancy and Sustaining Services	T2050	U6
		Housing Tenancy and Sustaining Services	T2041	U6
		Housing Tenancy and Sustaining Services	T2051	U6
		Short-Term Post-Hospitalization	H0043	U3
		Short-Term Post-Hospitalization	H0044	U3
		Recuperative Care (Medical Respite)	T2033	U6
		Respite Service	H0045	U6
		Respite Service	S5151	U6
		Respite Service	S9125	U6
		Day Habilitation	T2012	U6
		Day Habilitation	T2014	U6
		Day Habilitation	T2018	U6
		Day Habilitation	T2020	U6
		Day Habilitation	H2038	U6
		Day Habilitation	H2024	U6
		Day Habilitation	H2026	U6
		Nursing Facility Transition/Diversion to Assisted Living Facilities (RCF &ARF) 	T2038	U4
		Nursing Facility Transition/Diversion to Assisted Living Facilities (RCF &ARF) 	H2022	U5
		Community Transition Services/ Nursing Facility Transition to a Home	T2038	U5
		Personal Care and Homemaker Services	S5130	U6
		Personal Care and Homemaker Services	T1019	U6
		Environmental Accessibility Adaptation (Home Modifications)	S5165	U6
		Medically Tailored Meals/ Medically-Supportive Food	S5170	U6
		Medically Tailored Meals/ Medically-Supportive Food	S9470	U6
		Sobering Centers 	H0014	U6
		Asthma Remediation	S5165	U5
		Transitional Rent 	H0044	U6
		Transitional Rent 	H0043	U2

Thanks,
Claudia 

x From: Juan Francisco Sanchez <juansanchez@chgsd.com> 
Sent: Wednesday, July 15, 2026 1:40 PM
To: John Costello <jcostello@chgsd.com>
Cc: Informatics <Informatics@chgsd.com>
Subject: RE: Admissions Report

Yes,

It’s ready 😃!

Nothing fancy there, just simple ER Paid Claims, no counts, just totals.

 SELECT
                m.FULL_NAME,
                m.CARRIER_MEMBER_ID AS HEALTH_PLAN_ID,
                TO_DATE(m.DATE_OF_BIRTH::VARCHAR, 'YYYYMMDD') AS DATE_OF_BIRTH,
                m.GENDER,
                m.PRIMARY_LANGUAGE,
                m.PHYSICAL_ADDRESS,
                m.PHYSICAL_CITY,
                m.PHYSICAL_ZIP,
                m.PHONE_1,
                bp.LOB,
                mh.CLAIMAK AS CLAIM_ID,
                mh.CLAIM_STATUS,
                TO_DATE(mh.CLAIM_START_DATE::VARCHAR, 'YYYYMMDD') AS CLAIM_START_DATE,
                TO_DATE(mh.CLAIM_END_DATE::VARCHAR, 'YYYYMMDD') AS CLAIM_END_DATE,
                mh.CLAIM_DETAIL_DOS_FROM_DATE,
                mh.CLAIM_DETAIL_DOS_TO_DATE,
                mh.CLAIM_DETAIL_LINE,
                mh.CLAIM_DETAIL_STATUS,
                mh.AMOUNT_PAID,
                rp.PROVIDER_FULL_NAME AS FACILITY_NAME,
                rp.PHYSICAL_CITY AS FACILITY_CITY,
                rp.PHYSICAL_ZIP AS FACILITY_ZIP,
                cdiag.DIAGNOSIS_CODE_1 AS PRIMARY_DIAG_CODE,
                cdiag.DIAGNOSIS_DESCRIPTION_1 AS PRIMARY_DIAG_DESCRIPTION,
                cdiag.DIAGNOSIS_CODE_2,
                cdiag.DIAGNOSIS_DESCRIPTION_2,
                sc.CODEIDAK AS PRIMARY_SERVICE_CODE,
                sc.SERVICE_DESCRIPTION AS PRIMARY_SERVICE_DESCRIPTION
            FROM PROD_CHG_EDW.CHG_EDW.FACT_MEMBERHISTORY AS mh
            JOIN PROD_CHG_EDW.CHG_EDW.DIM_MEMBER AS m ON mh.MEMBERAK = m.MEMBERAK AND m.ROWISCURRENT = 'True'
            JOIN PROD_CHG_EDW.CHG_EDW.DIM_BENEFITPLAN AS bp ON mh.BENEFITPLANSK = bp.BENEFITPLANSK
            JOIN PROD_CHG_EDW.CHG_EDW.DIM_PROVIDERSPECIALTY AS rp ON mh.PROVIDERSK = rp.PROVIDERSK
            JOIN PROD_CHG_EDW.CHG_EDW.DIM_CLAIMDIAGNOSIS AS cdiag ON mh.CLAIMDIAGNOSISSK = cdiag.CLAIMDIAGNOSISSK
            JOIN PROD_CHG_EDW.CHG_EDW.DIM_SERVICECODE AS sc ON mh.SERVICECODESK = sc.SERVICECODESK
            WHERE mh.IS_ER_VISIT = 'YES'
              AND IS_PAID_CLAIM = 'YES'
              AND TO_DATE(mh.CLAIM_START_DATE::VARCHAR, 'YYYYMMDD') BETWEEN :P_START_DATE AND :P_END_DATE
            ORDER BY CLAIM_START_DATE DESC







JAH 'ECM and CS Claims Utilization Report'
x From: Claudia Velasquez 
Sent: Thursday, July 9, 2026 1:18 PM
To: Informatics <Informatics@chgsd.com>; Walter Carr <WCarr@chgsd.com>
Cc: Yousaf Farook <YFaroo@chgsd.com>; Heidi Arndt <HArndt@chgsd.com>; Rodrigo Diaz <RDiaz@chgsd.com>
Subject: ECM and CS Claims Utilization Report

Hi Team, 

Can someone please help us generate an ECM and CS Claims Utilization report for this year 2026? (Jan 1- present day).  We are working on a survey that is due, internally, tomorrow. Anything you can do to help, we would greatly appreciate it! 😊

Thanks, 
Claudia 

WHERE 1=1
	AND ISNULL(DOS,GETDATE()) < CAST('07/01/2026' AS date)
	
