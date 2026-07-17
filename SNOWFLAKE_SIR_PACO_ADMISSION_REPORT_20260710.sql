Hello Jonh,

The report is ready for your review.

SSRS: Admission Report - SQL Server 2019 Reporting Services

Code:

--Expanded CensusCategory CASE statement with all service codes (INPTBH, INPTLTAC, ICF-DD, RCU, etc.)
 
-- Stored Procedure for SSRS Admission Report replicating CensusCategory logic 
-- ------------------------------------------------------------------------
-- Snowflake returns ONE resultset per CALL, so SSRS calls this SP twice:
-- once with P_REPORT_TAB = 'ADMISSIONS' and once with 'ER'.
--
-- Parameters:
--   P_REPORT_TAB  : 'ADMISSIONS' or 'ER'
--   P_START_DATE  : report start date
--   P_END_DATE    : report end date
------------------------------------------------------------------------
 
CREATE OR REPLACE PROCEDURE PROD_CHG_EDW.CHG_EDW.SP_ADMISSION_REPORT(
    P_REPORT_TAB VARCHAR,
    P_START_DATE DATE,
    P_END_DATE   DATE
)
RETURNS TABLE()
LANGUAGE SQL
EXECUTE AS CALLER
AS
$$
DECLARE
    rs RESULTSET;
BEGIN
 
    IF (:P_REPORT_TAB = 'ADMISSIONS') THEN
        -- TAB 1: Hospital & SNF Admissions (Authorization-based)
        rs := (
            SELECT
                -- CensusCategory logic
                CASE 
                    WHEN mh.REFERRAL_SERVICE_CODE IN ('INPATIENT','IPLate')
                         AND svc.HCPC_REASON_CODE_1 = '345' THEN 'Inpatient CCS'
                    WHEN mh.REFERRAL_SERVICE_CODE IN ('INPATIENT','IPLate') THEN 'Inpatient Acute'
                    WHEN mh.REFERRAL_SERVICE_CODE IN ('INPTBH','BHLate') THEN 'Inpatient BH'
                    WHEN mh.REFERRAL_SERVICE_CODE IN ('INPTLTAC','IPSLCTSPC') THEN 'Inpatient LTAC'
                    WHEN mh.REFERRAL_SERVICE_CODE = 'ICF-DD-N' THEN 'ICFDD N'
                    WHEN mh.REFERRAL_SERVICE_CODE = 'ICF-DD-H' THEN 'ICFDD H'
                    WHEN mh.REFERRAL_SERVICE_CODE = 'ICF-DD' THEN 'ICFDD'
                    WHEN mh.REFERRAL_SERVICE_CODE = 'RCU01' THEN 'RCU'
                    WHEN mh.REFERRAL_SERVICE_CODE = 'INPTSNF'
                         AND referto.PROVIDERAK IN ('2154','316244','1411','300013','1910','867','5515','300026','5514','300003')
                         AND rc.CODEIDAK IN ('0169','0199') THEN 'Inpatient Subacute'
                    WHEN mh.REFERRAL_SERVICE_CODE = 'INPTSNF'
                         AND rc.CODEIDAK IN ('0101','0160','0185') THEN 'Inpatient Custodial'
                    WHEN mh.REFERRAL_SERVICE_CODE = 'INPTSNF'
                         AND rc.CODEIDAK IN ('0022','0180') THEN 'Inpatient SNF'
                    WHEN mh.REFERRAL_SERVICE_CODE = 'INPTSNF' THEN 'Inpatient SNF'
                    ELSE 'Other'
                END AS CENSUS_CATEGORY,
                m.FULL_NAME,
                m.CARRIER_MEMBER_ID AS HEALTH_PLAN_ID,
                TO_DATE(m.DATE_OF_BIRTH::VARCHAR, 'YYYYMMDD') AS DATE_OF_BIRTH,
                m.GENDER,
                m.PRIMARY_LANGUAGE,
                m.PHYSICAL_ADDRESS,
                m.PHYSICAL_CITY,
                m.PHYSICAL_ZIP,
                m.PHONE_1,
                bp.PLAN_DESCRIPTION,
                bp.LOB,
                mh.AUTHORIZATION_ID,
                mh.AUTHORIZATION_STATUS,
                mh.REFERRAL_SERVICE_CODE,
                --svc.HCPC_REASON_CODE_1 AS REASON_CODE,
                --rc.CODEIDAK AS REVENUE_CODE,
                TO_DATE(mh.AUTHORIZATION_EFFECTIVE_DATE::VARCHAR, 'YYYYMMDD') AS AUTHORIZATION_EFFECTIVE_DATE,
                TO_DATE(mh.AUTHORIZATION_TERMINATION_DATE::VARCHAR, 'YYYYMMDD') AS AUTHORIZATION_TERMINATION_DATE,
                MIN(TO_DATE(mh.ADMIT_DATE::VARCHAR, 'YYYYMMDD')) AS ADMISSION_DATE,
                MAX(TO_DATE(mh.DISCHARGE_DATE::VARCHAR, 'YYYYMMDD')) AS DISCHARGE_DATE,
                referfrom.PROVIDER_FULL_NAME AS REFERFROM_PROVIDER,
                referto.PROVIDER_FULL_NAME AS FACILITY_NAME,
                referto.PHYSICAL_ADDRESS AS FACILITY_ADDRESS,
                referto.PHYSICAL_CITY AS FACILITY_CITY,
                referto.PHYSICAL_ZIP AS FACILITY_ZIP,
                diag.DIAG_CODE_1 AS PRIMARY_DIAG_CODE,
                diag.DIAG_DESCRIPTION_1 AS PRIMARY_DIAG_DESCRIPTION,
                svc.HCPC_CODE_1 AS PRIMARY_SERVICE_CODE,
                svc.HCPC_DESCRIPTION_1 AS PRIMARY_SERVICE_DESCRIPTION
            FROM PROD_CHG_EDW.CHG_EDW.FACT_MEMBERHISTORY AS mh
            JOIN PROD_CHG_EDW.CHG_EDW.DIM_AUTHORIZATIONSERVICE AS svc ON mh.AUTHORIZATIONSERVICESK = svc.AUTHORIZATIONSERVICESK
            JOIN PROD_CHG_EDW.CHG_EDW.DIM_MEMBER AS m ON mh.MEMBERAK = m.MEMBERAK AND m.ROWISCURRENT = 'True'
            JOIN PROD_CHG_EDW.CHG_EDW.DIM_BENEFITPLAN AS bp ON mh.BENEFITPLANSK = bp.BENEFITPLANSK
            JOIN PROD_CHG_EDW.CHG_EDW.DIM_PROVIDERSPECIALTY AS referfrom ON mh.AUTHORIZATIONFROMPROVIDERSK = referfrom.PROVIDERSK
            JOIN PROD_CHG_EDW.CHG_EDW.DIM_PROVIDERSPECIALTY AS referto ON mh.AUTHORIZATIONTOPROVIDERSK = referto.PROVIDERSK
            JOIN PROD_CHG_EDW.CHG_EDW.DIM_AUTHORIZATIONDIAGNOSIS AS diag ON mh.AUTHORIZATIONDIAGNOSISSK = diag.AUTHORIZATIONDIAGNOSISSK
            JOIN PROD_CHG_EDW.CHG_EDW.DIM_REVENUECODE AS rc ON mh.REVENUECODESK = rc.REVENUECODESK
            WHERE mh.REFERRAL_SERVICE_CODE IN ('INPATIENT','IPLate','INPTBH','BHLate','INPTLTAC','IPSLCTSPC','ICF-DD-N','ICF-DD-H','ICF-DD','RCU01','INPTSNF')
              AND mh.AUTHORIZATION_STATUS IN ('APPROVED')
              AND TO_DATE(mh.ADMIT_DATE::VARCHAR, 'YYYYMMDD') BETWEEN :P_START_DATE AND :P_END_DATE
              --AND TO_DATE(mh.ADMIT_DATE::VARCHAR, 'YYYYMMDD') BETWEEN '2025-01-01' AND '2025-07-01'
              AND LOB != 'zzUnknown'
            GROUP BY ALL
            ORDER BY HEALTH_PLAN_ID, ADMISSION_DATE DESC 
            
        );
 
 
    ELSEIF (:P_REPORT_TAB = 'ER') THEN
        -- TAB 2: ER Visits (Claims-based)
        rs := (
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
                bp.PLAN_DESCRIPTION,
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
              AND IS_PAID_CLAIM = 'PAID'
              AND TO_DATE(mh.CLAIM_START_DATE::VARCHAR, 'YYYYMMDD') BETWEEN :P_START_DATE AND :P_END_DATE
            ORDER BY CLAIM_START_DATE DESC
        );
 
    ELSE
        rs := (SELECT 'Invalid P_REPORT_TAB value. Use ADMISSIONS or ER.' AS ERROR_MESSAGE);
    END IF;
 
    RETURN TABLE(rs);
 
END;
$$;
Juan Francisco Sanchez 
Informatics Data Analyst
2420 Fenton St, Suite 100
Chula Vista, CA 91914
E: juansanchez@chgsd.com 

O: 619-271-4801


 

This email and any attachments may contain confidential and privileged information protected by the Health Insurance Portability and Accountability Act (HIPAA). This information is intended solely for the use of the individual or entity to which it is addressed. If you are not the intended recipient, you are hereby notified that any unauthorized review, use, disclosure, or distribution is strictly prohibited. If you have received this email in error, please contact the sender immediately by reply email and destroy all copies of the original message.

