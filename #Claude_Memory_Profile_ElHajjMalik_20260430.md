# Claude Memory Profile
**Name:** El Hajj Malik Jahwaca (professionally: Walter Carr / wcarr)
**Exported:** April 30, 2026

---

## Work Context

- **Title:** Co-CEO and Senior Data Analyst
- **Organization:** Community Health Group of San Diego (CHGSD), operating as a Managed Service Organization (MSO) for Community Health Plan of Imperial Valley (CHPIV)
- **Core domains:** Healthcare data engineering, regulatory reporting, provider network analysis, contracting analytics

**Technical Environment:**
- Platforms: SQL Server, Python, SSIS, SSRS, Snowflake, Tableau
- Primary databases: `INFORMATICS`, `HMOPROD_PLANDATA`
- Servers: `SQLPROD02`, `SQLPRODAPP01`

---

## Personal Context

- Philosophical orientation: continuous learning — *"the more I learn, the more I realize how much I do NOT know"*
- Interests: fishing, chess, options trading
- Intellectual approach: First Principles thinking, Socratic method
- Property: Aguanga, CA

---

## Top of Mind (Active as of April 30, 2026)

- **PHM KPI Stratification Suite** — DHCS regulatory submission (PHM IN 26.001), deadline today (April 30, 2026)
  - Adding Sex/Gender stratification columns across measures
  - FUAH: production-validated
  - EDPC, ENPC, ENPC-A, CMHRD: in progress
  - CCME: still pending
- **HTML Data Flow Diagrams** — for stored procedures including:
  - Appeals/reconsiderations pipeline (`COMBINED_DETERMRECON_APPEALS`)
  - CHPIV HSD network adequacy workflow
  - Governing design standard: `HTML_Data_Flow_Diagram_TEMPLATE_20260213.html` (dark aesthetic)

---

## Recent Work History

### PHM KPI Infrastructure
- EDPC/ENPC measure alignment (terminal output matching ENPC's three-table structure with combined denominator)
- ENPC-A and CMHRD scripting
- Arithmetic overflow fix on EDPC eligible population query
- FUAH and CMHRD measure implementation with discharge-event-based counting and LTSS pathway identification (Provider Portal + Home Health)
- Community Supports STEP88 script consistency audit (three critical fixes including NULL-unsafe `<> NULL` and RCU01 stale placeholder)

### CHPIV Network & HSD Work
- CHPIV-adapted stored procedures for HSD NMM MMP reporting (flat-file taxonomy crosswalk)
- Python Excel-to-SQL upload scripts using pywin32 COM automation for legacy `.xls` files
- Matching HTML DFDs produced

### SSIS & SQL Server Agent
- Resolved SSIS truncation warning on CHPIV IBNP Monthly Refresh package (`Line_Of_Business` metadata mismatch)
- Fixed SSA job failures on "INF - Reload Member Months" (Kerberos linked-server auth failure, named DEFAULT constraint collision on `#MM` temp table)
- SQL Server Agent job hunting and cross-database collation error diagnosis (Msg 468)
- `uvwECMTargetPopulations` view maintained with two-view resolution strategy

### Additional Recent Projects
- 2027 Medicare Advantage Bid supplemental benefits extraction for Milliman (Vision, Hearing, Transportation, Post-Acute Meals)
- Dynamic fee schedule routing for contracting analyses (Girard Ortho)
- CMS business days TAT calculations (replacing calendar days)
- DHCS CPSP audit script alignment and bug fixes
- SSIS package comparisons for Feature 26322 (CHPIV IBNP FTP task disabling / subject line update)
- Tableau Cloud Bridge connectivity failure resolved (reassigned working Bridge client to OnPrem pool)

### Earlier Context
- CY 2026 DHCS EAE D-SNP Network Overlap Report for CHPIV (Python-based provider roster uploads, cross-server SQL collation fixes, provider network gap analysis CHGSD vs. Health Net CHPIV)
- CHPIV IBNP reporting pipeline (stored procedures, SSIS packages, provider directory infrastructure)
- LHPC 2026 Legislative Briefing data submission
- AB1455 claims payment regulatory response
- CMS Part C Organization Determinations D-SNP reporting with dynamic table archiving

---

## Coding Standard: DUB C 2.0

The governing SQL coding standard across all work:

- **One space between any two tokens, everywhere — no exceptions**
- Left-aligned commas with no preceding spaces
- Uppercase SQL keywords
- `(NOLOCK)` inline
- Explicit `AS` on all aliases
- `CASE / WHEN / THEN / ELSE / END` each on new lines

---

## Key Colleagues

| Name | Role |
|---|---|
| Ms. Kathryn Madrid | Business Systems Director |
| Sir Phil Steffek | Director of Informatics |
| Sir Salim French | Director of Contracting |
| Sir Omar Rodriguez | Provider Credentialing / ECM |
| Ms. Tatsani | Milliman liaison / IS |
| Ms. Elizabeth Valdez | Director of Claims Administration |
| Sir Adrian | Preferred PAR status affiliation method |
| Sir Alex | Principal Software Developer DBA |
| Juan C. Belmontes | SSIS ECM Daily Processor |
| Ms. Barbara Vargas | Clinical Operations |
| Ms. Noreen | Corporate Quality |
| Sir Evan Ducheny | Claims Systems |
| Norman L. Diaz | CEO |

---

## Long-Term Expertise

- HEDIS / PHM KPI reporting
- DHCS and CMS regulatory compliance
- Provider network adequacy (Quest Analytics, eVips/Symplr, DirectoryExpert)
- ECM / Community Supports program reporting
- LTC and HCT dashboard pipelines
- Contracting proposal analysis
- Python-based Excel-to-SQL upload frameworks (pyodbc, openpyxl, pywin32)
- Dark-aesthetic HTML Data Flow Diagrams (recurring documentation artifact)
- DUB C 2.0 SQL coding standard (developed and owned)

**Preferred role vision:** Consultant-style engagement enabling cross-departmental collaboration

---

*This document was generated from Claude's memory profile on April 30, 2026. It reflects context accumulated from past conversations and may not capture the most recent session activity.*
