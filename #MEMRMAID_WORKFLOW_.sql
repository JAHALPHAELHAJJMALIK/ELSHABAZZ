%% STYLING
%% NO STYLE DEFAULT TO BLACK FILL WITH WHITE FONT

%%NEON GREEN FILL WITH BLACK TEXT
style A fill:#90EE90,stroke:#2d5a27,color:#000
 
%% CONTRAST CHARCOAL FILL WITH BLACK TEXT
style B fill:#A7A9AC,stroke:#2d5a27,color:#000

%% CONTRAST CHARCOAL FILL WITH WHITE TEXT
style B fill:#A7A9AC,stroke:#2d5a27,color:#fff
 
%% BURNT ORANGE DA BEARS FILL WITH BLACK TEXT
style C fill:#F99928,stroke:#367d2e,color:#000

%% BURNT ORANGE DA BEARS FILL WITH WHITE TEXT
style C fill:#F99928,stroke:#367d2e,color:#fff

%% HOT PINK FILL WITH() BLACK TEXT
style D fill:#FFB6C1,stroke:#2d5a27,color:#000
 
%% DEEP BLUE FILL WITH WHITE TEXT
style E fill:#002B49,stroke:#002B49,color:#fff

%% CONTRAST CHARCOAL FILL WITH WHITE TEXT
style F fill:#2d2d2d,stroke:#4a9eff

'#MERMAID' - [CODE]:
%%{init: {'theme': 'dark', 'themeVariables': { 'fontSize': '16px'}}}%%
flowchart LR
    A[Premium Collection Strategies] -->|Choose Complexity| B{Strategy Type}
    
    B -->|Basic| C[Single Options]
    B -->|Intermediate| D[Credit Spreads]
    B -->|Advanced| E[Complex Positions]
    
    C --> C1[Sell Put] & C2[Sell Call]
    C1 -->|Requires| F1[Cash/Margin Collateral]
    C2 -->|Requires| F2[100 Shares Owned]
    
    D --> D1[Credit Call Spread]
    D --> D2[Credit Put Spread]
    D --> D3[Calendar Spread]
    
    E --> E1[Iron Condor]
    E --> E2[Iron Butterfly]
    E --> E3[Covered Strangle]
    
    D1 & D2 & D3 -->|Defined Risk| G[Limited Max Loss]
    E1 & E2 & E3 -->|Complex Risk| H[Advanced Management Required]
    
    I[Time] -->|Until| J[Expiration]
    J -->|Every| K[3rd Friday When the BIG $ Plays]

style A fill:#90EE90,stroke:#2d5a27,color:#000
style B fill:#F99928,stroke:#367d2e,color:#000
style C fill:#90EE90,stroke:#2d5a27,color:#000
style D fill:#90EE90,stroke:#2d5a27,color:#000
style E fill:#90EE90,stroke:#2d5a27,color:#000

style C1 fill:#FFB6C1,stroke:#2d5a27,color:#000
style C2 fill:#FFB6C1,stroke:#2d5a27,color:#000
style F1 fill:#FFB6C1,stroke:#2d5a27,color:#000
style F2 fill:#FFB6C1,stroke:#2d5a27,color:#000

style D1 fill:#FFB6C1,stroke:#2d5a27,color:#000
style D2 fill:#FFB6C1,stroke:#2d5a27,color:#000
style D3 fill:#FFB6C1,stroke:#2d5a27,color:#000

style E1 fill:#FFB6C1,stroke:#2d5a27,color:#000
style E2 fill:#FFB6C1,stroke:#2d5a27,color:#000
style E3 fill:#FFB6C1,stroke:#2d5a27,color:#000

style G fill:#2d2d2d,stroke:#4a9eff
style H fill:#2d2d2d,stroke:#4a9eff

style I fill:#90EE90,stroke:#2d5a27,color:#000
style J fill:#2d2d2d,stroke:#4a9eff
style K fill:#2d2d2d,stroke:#4a9eff
	
'#MERMAID' - [CODE]:
graph TD
    A[Start Search] --> B{Contains Attachment?}
    B -->|Yes| C[ADD ATTACHMENT: filter]
    B -->|No| D[SKIP ATTACHMENT filter]
    C --> E{Date Range?}
    D --> E
    E -->|Yes| F[ADD RECEIVED date: filter]
    E -->|No| G[SKIP RECEIVED date filter]
    F --> H[Add other filters]
    G --> H
    H --> I[Execute Search]
    I --> J{Results Found?}
    J -->|No| K[Broaden Search]
    J -->|Yes| L[Refine if needed]
 
%% STYLING
%% NO STYLE DEFAULT TO BLACK FILL WITH WHITE FONT
%%NEON GREEN FILL WITH BLACK TEXT
style A fill:#90EE90,stroke:#2d5a27,color:#000
 
%% CONTRAST CHARCOAL FILL WITH BLACK TEXT
style B fill:#A7A9AC,stroke:#2d5a27,color:#000
 
%% BURNT ORANGE DA BEARS FILL WITH WHITE TEXT
style C fill:#F99928,stroke:#367d2e,color:#fff
style D fill:#F99928,stroke:#367d2e,color:#fff

%% HOT PINK FILL WITH() BLACK TEXT
style F fill:#FFB6C1,stroke:#2d5a27,color:#000
style G fill:#FFB6C1,stroke:#2d5a27,color:#000
 
%% DEEP BLUE FILL WITH WHITE TEXT
style I fill:#002B49,stroke:#002B49,color:#fff
style J fill:#002B49,stroke:#002B49,color:#fff
 
'#MERMAID' - [CODE]:
flowchart TB
	A[Current Stock Price] -->|Ideally is Above| B[Strike Price]
	B --> C{Sell Put Option}
	C -->|Requires| D[Collateral]
	C -->|Generates| E[Premium]
	C -->|Creates| F[Obligation]
	F -->|If Triggered| G[Buy Stock at Strike]
	H[Time] -->|Until| I[Expiration]
	I -->|Every| J[3rd Friday When the BIG $ Plays]
	K[Stock Price] -->|Drops Below Strike| G

%% STYLING
%% NO STYLE DEFAULT TO BLACK FILL WITH WHITE FONT
%%NEON GREEN FILL WITH BLACK TEXT
style A fill:#90EE90,stroke:#2d5a27,color:#000
style H fill:#90EE90,stroke:#2d5a27,color:#000
style B fill:#2d2d2d,stroke:#4a9eff
style C fill:#F99928,stroke:#367d2e,color:#fff
style D fill:#2d2d2d,stroke:#4a9eff
style E fill:#2d2d2d,stroke:#4a9eff
style F fill:#2d2d2d,stroke:#4a9eff
style G fill:#2d2d2d,stroke:#4a9eff
style H fill:#2d2d2d,stroke:#4a9eff
style I fill:#2d2d2d,stroke:#4a9eff
style J fill:#2d2d2d,stroke:#4a9eff
style K fill:#2d2d2d,stroke:#4a9eff

'#MERMAID' - [CODE]:
graph TD
    A[Total Members] --> B[PCPs]
    A --> C[Specialists]
    A --> D[Facilities]
    B --> E[Primary Care: 1,480]
    B --> F[Language Access]
    C --> G[Specialists: 2,882]
    D --> H[Acute Care: 19]
    F --> I[Spanish: 640]
    F --> J[Arabic: 84]
	
style A fill:#90EE90,stroke:#2d5a27,color:#000
style B fill:#F99928,stroke:#2d5a27,color:#fff
style C fill:#F99928,stroke:#367d2e,color:#fff
style D fill:#F99928,stroke:#367d2e,color:#fff
style F fill:#FFB6C1,stroke:#2d5a27,color:#000
style I fill:#002B49,stroke:#002B49,color:#fff
style J fill:#002B49,stroke:#002B49,color:#fff

'#MERMAID' - [CODE]:
---
CONFIG:
  THEME: NEO-DARK
---
flowchart TD
    BEGIN[Start ECM Quarterly Process] ==> prep[Preparation Phase]
   
    prep --> |Update if needed| parallel1[Capacity Updates]
    prep --> |Always Required| parallel2[Data Validation]
   
    parallel1 --> update1[Update ECM Capacity]
    parallel1 --> update2[Update CS Capacity]
   
    parallel2 --> validate1[Validate Provider Data]
    parallel2 --> validate2[Verify System Access]
   
    update1 & update2 & validate1 & validate2 --> exec[Execute Report Tabs]
   
    exec --> tab1[Tab 1: ECM Members and Services]
    tab1 --> tab2[Tab 2: ECM Requests and Outreach]
    tab2 --> tab3[Tab 3: ECM Provider Capacity]
    tab3 --> tab4[Tab 4: CS Members and Services]
    tab4 --> tab5[Tab 5: CS Provider Capacity]
    tab5 --> tab6[Tab 6: CS Requests and Denials]
   
    tab6 --> qa{Quality Assurance}
   
    qa --> |Issues Found| qaFail[Address Data Issues]
    qaFail --> exec
   
    qa --> |Passed| review[Final Review]
   
    review --> |Approved| submit[Submit to DHCS]
    review --> |Needs Changes| exec
   
    submit --> archive[Archive Report & Documentation]
   
    archive  ==> endProcess[End Process]
	
style BEGIN fill:#90EE90,stroke:#2d5a27,color:#000
style prep fill:#D1D3D4,stroke:#D1D3D4,color:#000
style parallel1 fill:#F99928,stroke:#2d5a27,color:#fff
style parallel2 fill:#F99928,stroke:#367d2e,color:#fff
style qa fill:#002B49,stroke:#002B49,color:#fff
style exec fill:#002B49,stroke:#002B49,color:#fff
style endProcess fill:#FFB6C1,stroke:#2d5a27,color:#000

'#MERMAID' - [CODE]:
flowchart TD
    BEGIN(("Black HOH (Head of Household)")) ==> B{"Initialize Parameters"}
    B --> C[Create Base Table BlackHOH]
   
    subgraph Parameters
        P1[ClockStart/ClockStop]
        P2[PCPrecordRANK]
        P3[FBU Parameters]
    end
   
    subgraph Main Data Flow
        C --> D[Enrollkeys + Member Join]
        D --> E[Entity Join]
        E --> F[Region Zip CrossWalk]
       
        subgraph Additional Data
            G1[SOGI Data]
            G2[834 Ethnicity]
            G3[Language Data]
            G4[Medicare Info]
        end
       
        F --> H[Combine Additional Data]
        G1 --> H
        G2 --> H
        G3 --> H
        G4 --> H
    end
   
    H --> I[Create FBU Family Groups]
    I --> J[Apply Filters]
   
    subgraph Filters
        J1[Black Member Filter]
        J2[Head of Household]
        J3[Children Count]
        J4[Well Child Visit]
    end
   
    J --> K[Final Output]
    K --> L[End]
	
style BEGIN font-size:29px,font-weight:bold,width:199px
style B fill:#002B49,stroke:#002B49,color:#fff
style C fill:#007097,stroke:#007097,color:#fff
style D fill:#00A5DB,stroke:#00A5DB,color:#fff
style E fill:#63666A,stroke:#63666A,color:#fff
style F fill:#A7A9AC,stroke:#A7A9AC,color:#fff
style G1 fill:#F99928,stroke:#2d5a27,color:#fff
style G2 fill:#F99928,stroke:#367d2e,color:#fff
style G3 fill:#F99928,stroke:#3d9537,color:#fff
style G4 fill:#F99928,stroke:#45ad40,color:#fff
style I fill:#002B49,stroke:#002B49,color:#fff
style J fill:#007097,stroke:#007097,color:#fff
style J1 fill:#2d5a27,stroke:#2d5a27,color:#fff
style J2 fill:#367d2e,stroke:#367d2e,color:#fff
style J3 fill:#3d9537,stroke:#3d9537,color:#fff
style J4 fill:#45ad40,stroke:#45ad40,color:#fff 
style K fill:#00A5DB,stroke:#00A5DB,color:#fff
style L fill:#F99928,stroke:#F99928,color:#fff

'#MERMAID' - [CODE]:
graph TD
   BEGIN(("Logo Toggle Implementation Workflow")) ==> L1["Define Logo Requirements"]
   
    %% Logo Preparation Branch
    L1 --> L2["Prepare Logo Files<br/>CHGSD.jpg & CHPIV.jpg"]
    L2 --> PS["Run PowerShell Script<br/>Convert to Base64"]
    PS --> PSO["Output Base64 Files<br/>CHGSD_base64.txt<br/>CHPIV_base64.txt"]
    PSO --> DB[("Database Setup")]
   
    %% Database Development Branch
    DB --> T["Create default_logo Table"]
    T --> SP["Develop sp_get_Logo"]
    SP --> V{"Validate SP"}
    V -->|Fail| SP
    V -->|Pass| RDL["RDL Development"]
   
    %% RDL Development Branch
    RDL --> DS["Configure DataSource<br/>INF.INFOAG.INFORMATICS"]
    DS --> DST["Create Dataset<br/>LogoImage"]
    DST --> P["Add BusinessUnit<br/>Parameter"]
    P --> IC["Configure Image<br/>Control"]
    IC --> TBX["Add Tablix for<br/>Validation"]
   
    %% Parameter Logic Implementation
    TBX --> B{"Check BusinessUnit<br/>Parameter"}
    B -->|CHGSD| C[Show CHGSD Logo]
    B -->|CHPIV| D[Show CHPIV Logo]
    C --> E[Hide CHPIV Logo]
    D --> F[Hide CHGSD Logo]
    E --> G[Display Report Content]
    F --> G
 
%% Styling nodes
style BEGIN font-size:29px,font-weight:bold,width:199px
style B fill:#002B49,stroke:#002B49,color:#fff
style C fill:#007097,stroke:#007097,color:#fff
style D fill:#00A5DB,stroke:#00A5DB,color:#fff
style E fill:#63666A,stroke:#63666A,

'#MERMAID' - [CODE]:
graph TD
    BEGIN(("Toggling Logo Branding in SSRS Reports CHGSD v CHPIV: ")) ==> B{"Check BusinessUnit Parameter"}
    B -->|CHGSD| C[Show CHGSD Logo]
    B -->|CHPIV| D[Show CHPIV Logo]
    C --> E[Hide CHPIV Logo]
    D --> F[Hide CHGSD Logo]
    E --> G[Display Report Content]
    F --> G
 
style BEGIN font-size:19px,font-weight:bold,width:399px
style B fill:#002B49,stroke:#002B49,color:#fff
style C fill:#007097,stroke:#007097,color:#fff
style D fill:#00A5DB,stroke:#00A5DB,color:#fff
style E fill:#63666A,stroke:#63666A,color:#fff
style F fill:#A7A9AC,stroke:#A7A9AC,color:#fff
style G fill:#D1D3D4,stroke:#D1D3D4,color:#000  
 
'#MERMAID' - [CODE]:
flowchart TD
    BEGIN(("DHCS – Managed Care Long Term Care Reporting: ")) ==> B{"Data Collection"}
    B --> C{Facility Type}
    C -->|SNF| D[Tab 1 & 2]
    C -->|ICF/DD| E[Tab 3 & 4]
    C -->|Subacute| F[Tab 5 & 6]
   
    D --> G[Claims Processing]
    E --> G
    F --> G
   
    G --> H[Clean Claims]
    G --> I[Unclean Claims]
   
    H --> J[30-Day Status Check]
    J --> K[Paid]
    J --> L[Denied]
    J --> M[Pending]
   
    N[Authorization Tracking] --> O[Network Status]
    N --> P[TAT Calculation]
   
    Q[Prior Quarter Analysis] --> R[Trending]
   
    subgraph Data Validation
        S[Revenue Codes]
        T[Bill Types]
        U[Provider Contracts]
    end
 
style BEGIN font-size:29px,font-weight:bold,width:199px
style B fill:#002B49,stroke:#002B49,color:#fff
style C fill:#007097,stroke:#007097,color:#fff
style D fill:#00A5DB,stroke:#00A5DB,color:#fff
style E fill:#63666A,stroke:#63666A,color:#fff
style F fill:#A7A9AC,stroke:#A7A9AC,color:#fff
style G fill:#D1D3D4,stroke:#D1D3D4,color:#000
style H fill:#F99928,stroke:#F99928,color:#fff
style I fill:#002B49,stroke:#002B49,color:#fff
style J fill:#007097,stroke:#007097,color:#fff
style K fill:#00A5DB,stroke:#00A5DB,color:#fff
style L fill:#F99928,stroke:#F99928,color:#fff
style M fill:#002B49,stroke:#002B49,color:#fff
style N fill:#007097,stroke:#007097,color:#fff
style O fill:#00A5DB,stroke:#00A5DB,color:#fff
style P fill:#63666A,stroke:#63666A,color:#fff
style Q fill:#A7A9AC,stroke:#A7A9AC,color:#fff
style R fill:#D1D3D4,stroke:#D1D3D4,color:#000
style S fill:#002B49,stroke:#002B49,color:#fff
style T fill:#007097,stroke:#007097,color:#fff
style U fill:#00A5DB,stroke:#00A5DB,color:#fff

'#MERMAID' - [CODE]:
graph LR
    BEGIN(("Re - Admit Reports: ")) ==> B{"Data Preparation"}
    B --> C[Claims Data Processing]
    C --> D[LOB and Aid Code Updates]
    D --> E[Readmission Logic]
    E --> F[Admissions Identification]
    F --> G[Readmission Flagging]
    G --> H[Output Generation]
    H --> I[End]

    subgraph "Data Preparation"
    B1[Import Data]
    B2[Create Temporary Tables]
    end

    subgraph "Claims Processing"
    C1[Update Claims Data]
    C2[Apply Filters]
    end

    subgraph "Identify Inpatient Hospital Claims"
    C3A[Check Revenue Codes]
    C3B[Check Bill Types]
    C3C[Apply System-Specific Criteria]
    end

    subgraph "LOB and Aid Code Updates"
    D1[Update LOB]
    D2[Update Aid Codes]
    D3[SPD Identification]
    end

    subgraph "Readmission Logic"
    E1[Calculate Date Differences]
    E2[Identify True Admissions]
    end

    subgraph "Admissions Identification"
    F1[Set Admission Flags]
    F2[Identify Unique Admissions]
    end

    subgraph "Readmission Flagging"
    G1[Flag Readmissions]
    G2[Update All Related Records]
    end

    subgraph "Output Generation"
    H1[Generate Summary Statistics]
    H2[Create Final Output Tables]
    end

style BEGIN font-size:29px,font-weight:bold,width:199px
style B fill:#002B49,stroke:#002B49,color:#fff
style C fill:#007097,stroke:#007097,color:#fff
style D fill:#00A5DB,stroke:#00A5DB,color:#fff
style E fill:#63666A,stroke:#63666A,color:#fff
style F fill:#A7A9AC,stroke:#A7A9AC,color:#fff
style G fill:#D1D3D4,stroke:#D1D3D4,color:#000
style H fill:#F99928,stroke:#F99928,color:#fff
style I fill:#002B49,stroke:#002B49,color:#fff

'#MERMAID' - [CODE]:
graph TD
   BEGIN(("CALENDAR INDEX: ")) ==> B{"Create #date_calendar temporary table"}
    B --> C[Populate base dates]
    C --> D[Update basic date information]
    D --> E[Update week, month, quarter information]
    E --> F[Update remaining date calculations]
    F --> G[Identify workdays]
    G --> H[Assign holidays]
    H --> I[Calculate true workdays considering holidays]
    I --> J[Update previous period information]
    J --> K[Set first and last day of year]
    K --> L[Format dates as 'yyyymmdd']
    L --> M[End]

style BEGIN font-size:29px,font-weight:bold,width:199px
style B fill:#002B49,stroke:#002B49,color:#fff
style C fill:#007097,stroke:#007097,color:#fff
style D fill:#00A5DB,stroke:#00A5DB,color:#fff
style E fill:#63666A,stroke:#63666A,color:#fff
style F fill:#A7A9AC,stroke:#A7A9AC,color:#fff
style G fill:#D1D3D4,stroke:#D1D3D4,color:#000
style H fill:#F99928,stroke:#F99928,color:#fff
style I fill:#002B49,stroke:#002B49,color:#fff
style J fill:#007097,stroke:#007097,color:#fff
style K fill:#00A5DB,stroke:#00A5DB,color:#fff
style L fill:#F99928,stroke:#F99928,color:#fff
style M fill:#002B49,stroke:#002B49,color:#fff

'#MERMAID' - [CODE]:
graph TD
       BEGIN((".ai Assistant : ")) ==> B{"Choose Prompt Type"}
       B -->|Analysis| C[Act as Senior Data Analyst]
       B -->|Code Review| D[Provide Detailed Report]
       B -->|Optimization| E[Recommend Optimizations]
       B -->|Debugging| F[Assist in Debugging]
       C --> G[Specify Experience: 20+ years]
       D --> H[Focus on Parameters, Clauses, Functions]
       E --> I[Consider SQL Query Execution Order]
       F --> J[Provide Step-by-Step Guide]
       G --> K[End]
       H --> K
       I --> K
       J --> K
                          
style BEGIN font-size:29px,font-weight:bold,width:199px
style B fill:#002B49,stroke:#002B49,color:#fff
style C fill:#007097,stroke:#007097,color:#fff
style D fill:#00A5DB,stroke:#00A5DB,color:#fff
style E fill:#63666A,stroke:#63666A,color:#fff
style F fill:#A7A9AC,stroke:#A7A9AC,color:#fff
style G fill:#D1D3D4,stroke:#D1D3D4,color:#000
style H fill:#F99928,stroke:#F99928,color:#fff
style I fill:#002B49,stroke:#002B49,color:#fff
style J fill:#007097,stroke:#007097,color:#fff
style K fill:#00A5DB,stroke:#00A5DB,color:#fff 

'#MERMAID' - [CODE]:
graph LR
    BEGIN(("Provider Repository Error Report (city name reconciliation) : ")) ==> B{"Set @SnapshotID"}
    B --> C[Create #Temp Table]
    C --> D{Multiple INSERT Operations}
    D --> E[City Spelling Check]
    D --> F[URL Website Check]
    D --> G[OSHPDID Check]
    D --> H[Type of Service Checks]
    D --> I[NPI Checks]
    D --> J[State License Checks]
    D --> K[TaxID and Facility ID Checks]
    D --> L[Facility Type Checks]
    D --> M[Bed Count Checks]
    D --> N[Contact Info Checks]
    D --> O[Accessibility Checks]
    D --> P[In-Directory Checks]
    D --> Q[Various Indicator Checks]
    D --> R[Site with No Group Check]
    D --> S[Ownership Checks]
    S --> T[Final SELECT from #Temp]
    T --> U[Drop #Temp Table]
    U --> V[End]
 
style BEGIN font-size:29px,font-weight:bold,width:199px
style B fill:#002B49,stroke:#002B49,color:#fff
style C fill:#007097,stroke:#007097,color:#fff
style D fill:#00A5DB,stroke:#00A5DB,color:#fff
style E fill:#63666A,stroke:#63666A,color:#fff
style F fill:#A7A9AC,stroke:#A7A9AC,color:#fff
style G fill:#D1D3D4,stroke:#D1D3D4,color:#000
style H fill:#F99928,stroke:#F99928,color:#fff
style I fill:#002B49,stroke:#002B49,color:#fff
style J fill:#007097,stroke:#007097,color:#fff
style K fill:#00A5DB,stroke:#00A5DB,color:#fff
style L fill:#F99928,stroke:#F99928,color:#fff
style M fill:#002B49,stroke:#002B49,color:#fff
style N fill:#007097,stroke:#007097,color:#fff
style O fill:#00A5DB,stroke:#00A5DB,color:#fff
style P fill:#63666A,stroke:#63666A,color:#fff
style Q fill:#A7A9AC,stroke:#A7A9AC,color:#fff
style R fill:#D1D3D4,stroke:#D1D3D4,color:#000
style S fill:#002B49,stroke:#002B49,color:#fff
style T fill:#007097,stroke:#007097,color:#fff
style U fill:#00A5DB,stroke:#00A5DB,color:#fff
style V fill:#F99928,stroke:#F99928,color:#fff
  
'#MERMAID' - [CODE]:
graph TD
    BEGIN(("274 Group VSP ERROR [NetworkType]: ")) ==> B{"Declare Parameters"}
    B --> C[Query Snapshot]
    B --> D[Query Groups]
    B --> E[Query GroupSites]
    B --> F[Query Sites]
    B --> G[Main Query]
    G --> H[vwpractices]
    G --> I[Subquery P]
    I --> J[vwPractitionerProducts]
    J --> K[vwEntityAssignments]
    K --> L[vwPracticeLocations]
    G --> M[OUTER APPLY LP]
    G --> N[OUTER APPLY nc]
    G --> O[OUTER APPLY cc]
    G --> P[OUTER APPLY att]
    H --> Q[Final Result Set]
    I --> Q
    M --> Q
    N --> Q
    O --> Q
    P --> Q
    Q --> R[End]
      
style BEGIN font-size:29px,font-weight:bold,width:199px
style B fill:#002B49,stroke:#002B49,color:#fff
style C fill:#007097,stroke:#007097,color:#fff
style D fill:#00A5DB,stroke:#00A5DB,color:#fff
style E fill:#63666A,stroke:#63666A,color:#fff
style F fill:#A7A9AC,stroke:#A7A9AC,color:#fff
style G fill:#D1D3D4,stroke:#D1D3D4,color:#000
style H fill:#F99928,stroke:#F99928,color:#fff
style I fill:#002B49,stroke:#002B49,color:#fff
style J fill:#007097,stroke:#007097,color:#fff
style K fill:#00A5DB,stroke:#00A5DB,color:#fff
style L fill:#F99928,stroke:#F99928,color:#fff
style M fill:#002B49,stroke:#002B49,color:#fff
style N fill:#007097,stroke:#007097,color:#fff
style O fill:#00A5DB,stroke:#00A5DB,color:#fff
style P fill:#63666A,stroke:#63666A,color:#fff
style Q fill:#A7A9AC,stroke:#A7A9AC,color:#fff
style R fill:#D1D3D4,stroke:#D1D3D4,color:#000 

'#MERMAID' - [CODE]:
graph TD
    BEGIN(("Bi - Annual MS Excel Provider Directory: ")) ==> B{"Drop existing table if present"}
    B --> C[Create new table MSEXCEL_PROVDIR]
    C --> D[Union multiple SELECT statements]
    D --> E{For each provider type}
    E --> F[Select data from corresponding table]
    F --> G[Apply filters and transformations]
    G --> E
    E --> H[Combine all results]
    H --> I[Final SELECT statement]
    I --> J[Order results]
    J --> K[End]
 
style BEGIN font-size:29px,font-weight:bold,width:199px
style B fill:#002B49,stroke:#002B49,color:#fff
style C fill:#007097,stroke:#007097,color:#fff
style D fill:#00A5DB,stroke:#00A5DB,color:#fff
style E fill:#63666A,stroke:#63666A,color:#fff
style F fill:#A7A9AC,stroke:#A7A9AC,color:#fff
style G fill:#D1D3D4,stroke:#D1D3D4,color:#000
style H fill:#F99928,stroke:#F99928,color:#fff
style I fill:#002B49,stroke:#002B49,color:#fff
style J fill:#007097,stroke:#007097,color:#fff
style K fill:#00A5DB,stroke:#00A5DB,color:#fff
 
'#MERMAID' - [CODE]:
graph TD
    BEGIN(("IHA Medi-Cal: ")) ==> B{"Set Parameters"}
    B --> C[Create Temporary Tables]
    C --> D[Process Enrollment Data]
    D --> E[Process PCP Data]
    E --> F[Process Claims Data]
    F --> G[Process CHDP Data]
    G --> H[Calculate Continuous Enrollment]
    H --> I[Process Member Demographics]
    I --> J[Process Aid Codes and Rate Codes]
    J --> K[Combine Data into Final Table]
    K --> L[Update Ethnicity and Gender]
    L --> M[Generate Summary Statistics]
    M --> N[End]
 
style BEGIN font-size:29px,font-weight:bold,width:199px
style B fill:#002B49,stroke:#002B49,color:#fff
style C fill:#007097,stroke:#007097,color:#fff
style D fill:#00A5DB,stroke:#00A5DB,color:#fff
style E fill:#63666A,stroke:#63666A,color:#fff
style F fill:#A7A9AC,stroke:#A7A9AC,color:#fff
style G fill:#D1D3D4,stroke:#D1D3D4,color:#000
style H fill:#F99928,stroke:#F99928,color:#fff
style I fill:#002B49,stroke:#002B49,color:#fff
style J fill:#007097,stroke:#007097,color:#fff
style K fill:#00A5DB,stroke:#00A5DB,color:#fff
style L fill:#F99928,stroke:#F99928,color:#fff
style M fill:#002B49,stroke:#002B49,color:#fff
style N fill:#007097,stroke:#007097,color:#fff
      
'#MERMAID' - [CODE]:
graph TD
    BEGIN(("Over Under Tableau Prep: ")) ==> B{Set Date Parameters]
    B --> C[Create Baseline Membership]
    C --> D[Update Baseline with QNXT Data]
    D --> E[Insert Data into OverUnderCSSDMM]
    E --> F[Gather Visit Details]
    F --> G[Insert Data into OverUnderCSSD]
    G --> H[Create Summaries by LOB and Specialty]
    H --> I[Calculate Statistics]
    I --> J[Update Quadrants]
    J --> K[Update Date Ranges]
    K --> L[End]
      
style BEGIN font-size:29px,font-weight:bold,width:199px
style B fill:#002B49,stroke:#002B49,color:#fff
style C fill:#007097,stroke:#007097,color:#fff
style D fill:#00A5DB,stroke:#00A5DB,color:#fff
style E fill:#63666A,stroke:#63666A,color:#fff
style F fill:#A7A9AC,stroke:#A7A9AC,color:#fff
style G fill:#D1D3D4,stroke:#D1D3D4,color:#000
style H fill:#F99928,stroke:#F99928,color:#fff
style I fill:#002B49,stroke:#002B49,color:#fff
style J fill:#007097,stroke:#007097,color:#fff
style K fill:#00A5DB,stroke:#00A5DB,color:#fff 
      
'#MERMAID' - [CODE]:
graph TD
    BEGIN(("Medi-Medi List: ")) ==> B{"Set @AsOf date"}
    B --> C[Create CTE 'mems']
    C --> D[Join multiple tables]
    D --> E[Apply filters]
    E --> F[Select distinct members]
    F --> G[Join with additional tables]
    G --> H[Apply final filters]
    H --> I[Return result set]
    I --> J[End]
 
style BEGIN font-size:29px,font-weight:bold,width:199px
style B fill:#002B49,stroke:#002B49,color:#fff
style C fill:#007097,stroke:#007097,color:#fff
style D fill:#00A5DB,stroke:#00A5DB,color:#fff
style E fill:#63666A,stroke:#63666A,color:#fff
style F fill:#A7A9AC,stroke:#A7A9AC,color:#fff
style G fill:#D1D3D4,stroke:#D1D3D4,color:#000
style H fill:#F99928,stroke:#F99928,color:#fff
style I fill:#002B49,stroke:#002B49,color:#fff
style J fill:#007097,stroke:#007097,color:#fff
 
'#MERMAID' - [CODE]:
graph TD
    BEGIN(("SNOWFLAKE Upload UI / UX Wizard: ")) ==> B{"Source Type?"}
    B -->|SQL| C[Execute SQL Query]
    B -->|CSV| D[Prepare CSV File]
    C --> E[Export Query Results]
    D --> F[Validate CSV Format]
    E --> G[Prepare Data for Upload]
    F --> G
    G --> H[Connect to Snowflake]
    H --> I[Create or Select Target Table]
    I --> J[Upload Data]
    J --> K[Verify Data Integrity]
    K --> L{"Data Correct?"}
    L -->|Yes| M[Commit Changes]
    L -->|No| N[Rollback and Troubleshoot]
    M --> O[End]
    N --> G
 
style BEGIN font-size:29px,font-weight:bold,width:199px
style B fill:#002B49,stroke:#002B49,color:#fff
style C fill:#007097,stroke:#007097,color:#fff
style D fill:#00A5DB,stroke:#00A5DB,color:#fff
style E fill:#63666A,stroke:#63666A,color:#fff
style F fill:#A7A9AC,stroke:#A7A9AC,color:#fff
style G fill:#D1D3D4,stroke:#D1D3D4,color:#000
style H fill:#F99928,stroke:#F99928,color:#fff
style I fill:#002B49,stroke:#002B49,color:#fff
style J fill:#007097,stroke:#007097,color:#fff
style K fill:#00A5DB,stroke:#00A5DB,color:#fff
style L fill:#F99928,stroke:#F99928,color:#fff
style M fill:#002B49,stroke:#002B49,color:#fff
style N fill:#007097,stroke:#007097,color:#fff
style O fill:#00A5DB,stroke:#00A5DB,color:#fff
      
'#MERMAID' - [CODE]:
graph TD
    BEGIN(("RDT Fee Schedule: ")) ==> B[Define CTEs]
    B --> C[ContractDescr CTE]
    B --> D[CustomFeeSchedule CTE]
    C --> E[Main Query]
    D --> E
    E --> F[SELECT]
    F --> I[Group By]
    I --> J[End]
 
    subgraph CTE Definitions
    C
    D
    end
 
    subgraph Main Query Execution
    F
    I
    end
 
    style BEGIN font-size:29px,font-weight:bold,width:199px
    style B fill:#002B49,stroke:#002B49,color:#fff
    style C fill:#007097,stroke:#007097,color:#fff
    style D fill:#00A5DB,stroke:#00A5DB,color:#fff
    style E fill:#63666A,stroke:#63666A,color:#fff
    style F fill:#A7A9AC,stroke:#A7A9AC,color:#fff
    style I fill:#002B49,stroke:#002B49,color:#fff
    style J fill:#00A5DB,stroke:#00A5DB,color:#fff
 
'#MERMAID' - [CODE]:
graph TD
    BEGIN(("Black PCPs:")) ==> B[Create BLACK_PCPs Table]
    B --> C[Insert PCP Data]
    C --> D[Update SQIC_ID for PCPs]
    D --> E[Update Ethnicity for PCPs]
    E --> F[Create BLACK_SPEs Table]
    F --> G[Insert Specialist Data]
    G --> H[Update SQIC_ID for Specialists]
    H --> I[Update Ethnicity for Specialists]
    I --> J[Perform Counts and Analysis]
    J --> K[Update ROLLUP_ETHNICITY]
    K --> L[End]
 
style BEGIN font-size:29px,font-weight:bold,width:199px
style B fill:#002B49,stroke:#002B49,color:#fff
style C fill:#007097,stroke:#007097,color:#fff
style D fill:#00A5DB,stroke:#00A5DB,color:#fff
style E fill:#63666A,stroke:#63666A,color:#fff
style F fill:#A7A9AC,stroke:#A7A9AC,color:#fff
style G fill:#D1D3D4,stroke:#D1D3D4,color:#000
style H fill:#F99928,stroke:#F99928,color:#fff
style I fill:#002B49,stroke:#002B49,color:#fff
style J fill:#007097,stroke:#007097,color:#fff
style end fill:#00A5DB,stroke:#00A5DB,color:#fff

'#MERMAID' - [CODE]:
graph TD
    BEGIN(("RDT Fee Schedule: ")) ==> B[Define CTEs]
    B --> C[ContractDescr CTE]
    B --> D[CustomFeeSchedule CTE]
    C --> E[Main Query]
    D --> E
    E --> F[SELECT]
    F --> I[Group By]
    I --> J[End] 
	
    subgraph CTE Definitions
    C
    D
    end 
	
    subgraph Main Query Execution
    F
    I
    end 

style BEGIN font-size:29px,font-weight:bold,width:199px
style B fill:#002B49,stroke:#002B49,color:#fff
style C fill:#007097,stroke:#007097,color:#fff
style D fill:#00A5DB,stroke:#00A5DB,color:#fff
style E fill:#63666A,stroke:#63666A,color:#fff
style F fill:#A7A9AC,stroke:#A7A9AC,color:#fff
style I fill:#002B49,stroke:#002B49,color:#fff
style J fill:#007097,stroke:#007097,color:#fff
   
'#MERMAID' - [CODE]:
graph TD
    BEGIN((("ED Visit for SMI and SUD and Provider Portal Notificaiton: "))) ==> B[CTE_FilteredClaims]
    BEGIN --> C[CTE_Diagnoses]
    B --> D[Main Query]
    C --> D
    D --> E[Join with member]
    E --> F[Join with enrollkeys]
    F --> G[Join with provider]
    G --> H[Left Join with affiliation]
    H --> I[Left Join with provider payto]
    I --> J[Join with CTE_Diagnoses]
    J --> K[Left Join with DiagCode]
    K --> L[Left Join with ERVisitsCache]
    L --> M[Apply CASE for LOB]
    M --> N[Select and transform columns]
    N --> O[Order by memid]
    O --> P[End]
	
graph LR
    BEGIN(("ED Visit for SMI and SUD and Provider Portal Notification:")) ==> B[CTE_FilteredClaims]
    BEGIN --> C[CTE_Diagnoses]
    B --> D[Main Query]
    C --> D
    D --> E[Join with member]
    E --> F[Join with enrollkeys]
    F --> G[Join with provider]
    G --> H[Left Join with affiliation]
    H --> I[Left Join with provider payto]
    I --> J[Join with CTE_Diagnoses]
    J --> K[Left Join with DiagCode]
    K --> L[Left Join with ERVisitsCache]
    L --> M[Apply CASE for LOB]
    M --> N[Select and transform columns]
    N --> O[Order by memid]
    O --> P[End]	

style BEGIN font-size:29px,font-weight:bold,width:199px
style B fill:#002B49,stroke:#002B49,color:#fff
style C fill:#007097,stroke:#007097,color:#fff
style D fill:#00A5DB,stroke:#00A5DB,color:#fff
style E fill:#63666A,stroke:#63666A,color:#fff
style F fill:#A7A9AC,stroke:#A7A9AC,color:#fff
style G fill:#D1D3D4,stroke:#D1D3D4,color:#000
style H fill:#F99928,stroke:#F99928,color:#fff
style I fill:#002B49,stroke:#002B49,color:#fff
style J fill:#007097,stroke:#007097,color:#fff
style K fill:#00A5DB,stroke:#00A5DB,color:#fff
style L fill:#F99928,stroke:#F99928,color:#fff
style M fill:#002B49,stroke:#002B49,color:#fff
style N fill:#007097,stroke:#007097,color:#fff
style O fill:#00A5DB,stroke:#00A5DB,color:#fff 

'#MERMAID' - [CODE]:
graph TD
    BEGIN((("Current Membership by OMB Ethnicity: "))) ==> B[Define Variables]
    B --> C[Create DateRanges CTE]
    B --> D[Create ZipCodes CTE]
    B --> E[Create BaseMemberData CTE]
    E --> F[Create SOGIData CTE]
    E --> G[Create EthnicityData CTE]
    E --> H[Create LanguageData CTE]
    C --> I[Create MembershipData CTE]
    D --> I
    E --> I
    F --> I
    G --> I
    H --> I
    I --> J[Final SELECT from MembershipData]
    J --> K[Additional Queries/Updates]
    K --> L[End]
 
style BEGIN font-size:29px,font-weight:bold,width:199px
style B fill:#002B49,stroke:#002B49,color:#fff
style C fill:#007097,stroke:#007097,color:#fff
style D fill:#00A5DB,stroke:#00A5DB,color:#fff
style E fill:#63666A,stroke:#63666A,color:#fff
style F fill:#A7A9AC,stroke:#A7A9AC,color:#fff
style G fill:#D1D3D4,stroke:#D1D3D4,color:#000
style H fill:#F99928,stroke:#F99928,color:#fff
style I fill:#002B49,stroke:#002B49,color:#fff
style J fill:#007097,stroke:#007097,color:#fff
style K fill:#00A5DB,stroke:#00A5DB,color:#fff 

'#MERMAID' - [CODE]:
graph TD
    BEGIN((("Member_Demographic Source Data: "))) ==> B[rpt_membe_demo View]
    B --> C[rpt_demo_ratecode SP]
    B --> D[rpt_demo_age_gender SP]
    B --> E[rpt_demo_pcp SP]
    B --> F[rpt_demo_zip_sum SP]
    G[INFORMATICS] --> B
    H[EnrollmentManager] --> B
    I[Informatics2] --> B
 
style BEGIN font-size:29px,font-weight:bold,width:199px
style B fill:#002B49,stroke:#002B49,color:#fff
style C fill:#007097,stroke:#007097,color:#fff
style D fill:#00A5DB,stroke:#00A5DB,color:#fff
style E fill:#63666A,stroke:#63666A,color:#fff
style F fill:#A7A9AC,stroke:#A7A9AC,color:#fff
style G fill:#D1D3D4,stroke:#D1D3D4,color:#000
style H fill:#F99928,stroke:#F99928,color:#fff
style I fill:#002B49,stroke:#002B49,color:#fff

'#MERMAID' - [CODE]:
graph TD
    BEGIN((("Members Authorized for & Utilizing CBAS: "))) ==> B[Create Temporary Tables]
    B --> C[Populate #SETreferralrange]
    C --> D[Create Main Table CHG_CBAS_MEMBER_LIST]
    D --> E[Update Diagnosis, Procedure, and Revenue Codes]
    E --> F[Update Authorization Attributes]
    F --> G[Update TAT and Threshold]
    G --> H[Update Claim Association]
    H --> I[Update Primary/Secondary Status]
    I --> J[Update Provider Contract Status]
    J --> K[Generate Final Reports]
    K --> L[End]
      
style BEGIN font-size:29px,font-weight:bold,width:199px
style B fill:#002B49,stroke:#002B49,color:#fff
style C fill:#007097,stroke:#007097,color:#fff
style D fill:#00A5DB,stroke:#00A5DB,color:#fff
style E fill:#63666A,stroke:#63666A,color:#fff
style F fill:#A7A9AC,stroke:#A7A9AC,color:#fff
style G fill:#D1D3D4,stroke:#D1D3D4,color:#000
style H fill:#F99928,stroke:#F99928,color:#fff
style I fill:#002B49,stroke:#002B49,color:#fff
style J fill:#007097,stroke:#007097,color:#fff
style K fill:#00A5DB,stroke:#00A5DB,color:#fff

'#MERMAID' - [CODE]:
graph TD
    BEGIN((("AB1455 Annual Plan Claims Payment and Dispute Resolution Mechanism Report
    APPEALS: "))) ==> B[Set Parameters]
	
    B --> C[Create #CURRENTCONTRACT]
    C --> D[Update #CURRENTCONTRACT]
    D --> E[Create #CurrentAppeals]
    E --> F[Update #CurrentAppeals]
    F --> G[Create AB1455_APPEALSall]
    G --> H[Create AB1455_APPEALSthousand]
    H --> I[Create AB1455_APPEALSprov]
    I --> J[Create AB1455_APPEALStype]
    J --> K[Generate Summary Statistics]
    K --> L[End]
	
style BEGIN font-size:29px,font-weight:bold,width:199px
style B fill:#002B49,stroke:#002B49,color:#fff
style C fill:#007097,stroke:#007097,color:#fff
style D fill:#00A5DB,stroke:#00A5DB,color:#fff
style E fill:#63666A,stroke:#63666A,color:#fff
style F fill:#A7A9AC,stroke:#A7A9AC,color:#fff
style G fill:#D1D3D4,stroke:#D1D3D4,color:#000
style H fill:#F99928,stroke:#F99928,color:#fff
style I fill:#002B49,stroke:#002B49,color:#fff
style J fill:#007097,stroke:#007097,color:#fff
style K fill:#00A5DB,stroke:#00A5DB,color:#fff
style L fill:#F99928,stroke:#F99928,color:#fff
	
'#MERMAID' - [CODE]:
graph TD
    BEGIN((("AB1455 Annual Plan Claims Payment and Dispute Resolution Mechanism Report
    APPEALS: DW2.0 Transition"))) ==> B[Set Parameters]
	
    B --> C[Create CURRENTCONTRACT Table]
    C --> D[Merge PCP Information]
    D --> E[Update Specific Provider Contracts]
    E --> F[Create CurrentAppeals Table]
    F --> G[Create AB1455_APPEALSall Table]
    G --> H[Create AB1455_APPEALSthousand Table]
    H --> I[Create AB1455_APPEALSprov Table]
    I --> J[Create AB1455_APPEALStype Table]
    J --> K[Generate Summary Reports]
    K --> L[End]

style BEGIN font-size:29px,font-weight:bold,width:199px
style B fill:#002B49,stroke:#002B49,color:#fff
style C fill:#007097,stroke:#007097,color:#fff
style D fill:#00A5DB,stroke:#00A5DB,color:#fff
style E fill:#63666A,stroke:#63666A,color:#fff
style F fill:#A7A9AC,stroke:#A7A9AC,color:#fff
style G fill:#D1D3D4,stroke:#D1D3D4,color:#000
style H fill:#F99928,stroke:#F99928,color:#fff
style I fill:#002B49,stroke:#002B49,color:#fff
style J fill:#007097,stroke:#007097,color:#fff
style K fill:#00A5DB,stroke:#00A5DB,color:#fff
style L fill:#F99928,stroke:#F99928,color:#fff

'#MERMAID' - [CODE]:
graph LR
    BEGIN((("Provider Repository
    Quality Ctrl Mechanism: "))) ==>B[Set SnapshotID]

    B --> C[Create Temp Table]
    C --> D{Multiple INSERT Operations}
    D --> E[Select Results from Temp Table]
    E --> F[End]

style BEGIN font-size:29px,font-weight:bold,width:199px
style B fill:#002B49,stroke:#002B49,color:#fff
style C fill:#007097,stroke:#007097,color:#fff
style D fill:#F99928,stroke:#F99928,color:#fff
style E fill:#63666A,stroke:#63666A,color:#fff 

subgraph "Insert Operations"
    D --> G[Insert ECM Provider Errors]
    D --> H[Insert ILOS Provider Errors]
    D --> I[Insert Name Errors]
    D --> J[Insert NPI Errors]
    D --> K[Insert Gender Errors]
    D --> L[Insert DOB Errors]
    D --> M[Insert Admitting Privileges Errors]
    D --> N[Insert Excessive Addresses Errors]
    D --> O[Insert Board Certification Errors]
    D --> P[Insert QNXT ProvID Errors]
    D --> Q[Insert Member Count Errors]
    D --> R[Insert License/Certificate Errors]
    D --> S[Insert DEA Errors]
    D --> T[Insert FTE Equivalent Errors]
    D --> U[Insert In-directory Details Errors]
    end
	
'#MERMAID' - [CODE]:
graph TD
    BEGIN((("TEMPLATE: "))) ==>B
    B[Declare Variables] ... 

    BEGIN =====> B --> C --> D --> E --> F --> G --> H --> I --> J --> K --> L --> M --> N --> O --> P --> Q --> R --> S --> T

style BEGIN font-size:29px,font-weight:bold,width:199px
style B fill:#002B49,stroke:#002B49,color:#fff
style C fill:#007097,stroke:#007097,color:#fff
style D fill:#00A5DB,stroke:#00A5DB,color:#fff
style E fill:#63666A,stroke:#63666A,color:#fff
style F fill:#A7A9AC,stroke:#A7A9AC,color:#fff
style G fill:#D1D3D4,stroke:#D1D3D4,color:#000
style H fill:#F99928,stroke:#F99928,color:#fff
style I fill:#002B49,stroke:#002B49,color:#fff
style J fill:#007097,stroke:#007097,color:#fff
style K fill:#00A5DB,stroke:#00A5DB,color:#fff
style L fill:#F99928,stroke:#F99928,color:#fff
style M fill:#002B49,stroke:#002B49,color:#fff
style N fill:#007097,stroke:#007097,color:#fff
style O fill:#00A5DB,stroke:#00A5DB,color:#fff
style P fill:#63666A,stroke:#63666A,color:#fff
style Q fill:#A7A9AC,stroke:#A7A9AC,color:#fff
style R fill:#D1D3D4,stroke:#D1D3D4,color:#000
style S fill:#002B49,stroke:#002B49,color:#fff
style T fill:#007097,stroke:#007097,color:#fff
style U fill:#00A5DB,stroke:#00A5DB,color:#fff
style AR fill:#F99928,stroke:#F99928,color:#fff
style AS fill:#F99928,stroke:#F99928,color:#fff
style AT fill:#F99928,stroke:#F99928,color:#fff

'#MERMAID' - [CODE]:
graph LR
BEGIN((("ISCAT NAV Audit Readiness: "))) ==> B

    B[Network Adequacy Data Reconciliation, Preproduction, and Integration]
    B --> C[Overview of network adequacy data preproduction process]
    B --> D[Overview of data warehouse/repository]
    B --> E[Overview of data security and back-up processes]
    B --> F[Overview of data preproduction processing and data integration]
    
    G[SQL Scripts and Policy] --> H[Provider Repository Data Preparation]
    G --> I[274 Data Preparation]
    
    H --> J[ProviderRepository Tables]
    
    I --> Q[CHGAPP_PROD Tables]
    
    H --> Y[Update Functions and Stored Procedures]
    
    I --> AE[Update Functions and Stored Procedures]
    
    B --> AK[Reconciliation of files used to calculate network adequacy indicators]
    AK --> AL[Network Adequacy Methodology and Reporting]
    AL --> AM[Discussion from the ISCAT review]
    
    B --> AN[Data completeness]
    
    AO[SSRS Report Update] --> AP[274 Snapshot Summary Report]
    
    AU[Overview and discussion regarding network adequacy methodology]
    
    AV[ISCAT NAV 5150a Network Development Policy 6.3.24.1.24pm.docx] --> AW[Primary Source Verification/logic discussion]

style BEGIN width:99px
style B fill:#002B49,stroke:#002B49,color:#fff
style C fill:#007097,stroke:#007097,color:#fff
style D fill:#00A5DB,stroke:#00A5DB,color:#fff
style E fill:#63666A,stroke:#63666A,color:#fff
style F fill:#A7A9AC,stroke:#A7A9AC,color:#fff
style G fill:#D1D3D4,stroke:#D1D3D4,color:#000
style H fill:#F99928,stroke:#F99928,color:#fff
style I fill:#002B49,stroke:#002B49,color:#fff
style J fill:#007097,stroke:#007097,color:#fff

'#MERMAID' - [CODE]:
graph TD
    BEGIN((("A1c
    
     CGM (Continuous Glucose Monitoring): "))) ==>B
    B[Declare Variables]
    C[Create #baselinemembership]
    D[Create #SHELLbilltype]
    E[Create #SHELLclmtype]
    F[Create INFORMATICS.dbo.CGMPilotProgDIABA1c]
    G[Update Principal Diagnosis]
    H[Update Membership Demographics]
    I[Update Primary/Secondary Status]
    J[Update Contracted Provider Status]
    K[Create #PCP]
    L[Create #provendo]
    M[Create INFORMATICS.dbo.CGMoutput]
    N[Update PCP and Endocrinologist Info]
    O[Update Continuous Enrollment]
    P[Update ER Visits and Admissions]
    Q[Update Pharmacy Data CGM, Insulin, Oral Meds]
    R[Update Diabetes Diagnoses]
    S[Update Insulin Pumps and Supplies]
    T[End]

    BEGIN =====> B --> C --> D --> E --> F --> G --> H --> I --> J --> K --> L --> M --> N --> O --> P --> Q --> R --> S --> T

style BEGIN font-size:29px,font-weight:bold,width:199px
style B fill:#002B49,stroke:#002B49,color:#fff
style C fill:#007097,stroke:#007097,color:#fff
style D fill:#00A5DB,stroke:#00A5DB,color:#fff
style E fill:#63666A,stroke:#63666A,color:#fff
style F fill:#A7A9AC,stroke:#A7A9AC,color:#fff
style G fill:#D1D3D4,stroke:#D1D3D4,color:#000
style H fill:#F99928,stroke:#F99928,color:#fff
style I fill:#002B49,stroke:#002B49,color:#fff
style J fill:#007097,stroke:#007097,color:#fff
style K fill:#00A5DB,stroke:#00A5DB,color:#fff
style L fill:#F99928,stroke:#F99928,color:#fff
style M fill:#002B49,stroke:#002B49,color:#fff
style N fill:#007097,stroke:#007097,color:#fff
style O fill:#00A5DB,stroke:#00A5DB,color:#fff
style P fill:#63666A,stroke:#63666A,color:#fff
style Q fill:#A7A9AC,stroke:#A7A9AC,color:#fff
style R fill:#D1D3D4,stroke:#D1D3D4,color:#000
style S fill:#002B49,stroke:#002B49,color:#fff
style T fill:#007097,stroke:#007097,color:#fff
style U fill:#00A5DB,stroke:#00A5DB,color:#fff
style AR fill:#F99928,stroke:#F99928,color:#fff
style AS fill:#F99928,stroke:#F99928,color:#fff
style AT fill:#F99928,stroke:#F99928,color:#fff

'#MERMAID' - [CODE]:
graph LR
BEGIN((("ISCAT NAV Audit Readiness: "))) ==> B

    B[Network Adequacy Data Reconciliation, Preproduction, and Integration]
    B --> C[Overview of network adequacy data preproduction process]
    B --> D[Overview of data warehouse/repository]
    B --> E[Overview of data security and back-up processes]
    B --> F[Overview of data preproduction processing and data integration]
    
    G[SQL Scripts and Policy] --> H[Provider Repository Data Preparation]
    G --> I[274 Data Preparation]
    
    H --> J[ProviderRepository Tables]
    J --> K[Snapshot]
    J --> L[Groups]
    J --> M[Sites]
    J --> N[Providers]
    J --> O[GroupSites]
    J --> P[SiteProviders]
    
    I --> Q[CHGAPP_PROD Tables]
    Q --> R[tblEDIDHCSType274Snapshot]
    Q --> S[tblEDIDHCSType274Group]
    Q --> T[tblEDIDHCSType274Site]
    Q --> U[tblEDIDHCSType274Provider]
    Q --> V[tblEDIDHCSType274GroupError]
    Q --> W[tblEDIDHCSType274SiteError]
    Q --> X[tblEDIDHCSType274ProviderError]
    
    H --> Y[Update Functions and Stored Procedures]
    Y --> Z[InserteVIPSData]
    Y --> AA[eVIPsGetSites]
    Y --> AB[eVIPsGetProviders]
    Y --> AC[GetErrorsSites]
    Y --> AD[GetErrorsProviders]
    
    I --> AE[Update Functions and Stored Procedures]
    AE --> AF[usp_EDI_DHCS_Type274_CollectData]
    AE --> AG[udf_EDI_DHCS_Type274_eVIPsSites]
    AE --> AH[usp_EDI_DHCS_Type274_eVIPsSites]
    AE --> AI[udf_EDI_DHCS_Type274_eVIPsProviders]
    AE --> AJ[usp_EDI_DHCS_Type274_eVIPsProviders]
    
    B --> AK[Reconciliation of files used to calculate network adequacy indicators]
    AK --> AL[Network Adequacy Methodology and Reporting]
    AL --> AM[Discussion from the ISCAT review]
    
    B --> AN[Data completeness]
    
    AO[SSRS Report Update] --> AP[274 Snapshot Summary Report]
    
    AQ[Table Triggers] --> AR[GroupTrigger]
    AQ --> AS[SiteTrigger]
    AQ --> AT[ProviderTrigger]
    
    AU[Overview and discussion regarding network adequacy methodology]
    
    AV[ISCAT NAV 5150a Network Development Policy 6.3.24.1.24pm.docx] --> AW[Primary Source Verification/logic discussion]

style BEGIN width:99px
style B fill:#002B49,stroke:#002B49,color:#fff
style C fill:#007097,stroke:#007097,color:#fff
style D fill:#00A5DB,stroke:#00A5DB,color:#fff
style E fill:#63666A,stroke:#63666A,color:#fff
style F fill:#A7A9AC,stroke:#A7A9AC,color:#fff
style G fill:#D1D3D4,stroke:#D1D3D4,color:#000
style H fill:#F99928,stroke:#F99928,color:#fff
style I fill:#002B49,stroke:#002B49,color:#fff
style J fill:#007097,stroke:#007097,color:#fff
style K fill:#00A5DB,stroke:#00A5DB,color:#fff
style L fill:#F99928,stroke:#F99928,color:#fff
style M fill:#002B49,stroke:#002B49,color:#fff
style N fill:#007097,stroke:#007097,color:#fff
style O fill:#00A5DB,stroke:#00A5DB,color:#fff
style P fill:#63666A,stroke:#63666A,color:#fff
style Q fill:#A7A9AC,stroke:#A7A9AC,color:#fff
style R fill:#D1D3D4,stroke:#D1D3D4,color:#000
style S fill:#002B49,stroke:#002B49,color:#fff
style T fill:#007097,stroke:#007097,color:#fff
style U fill:#00A5DB,stroke:#00A5DB,color:#fff
style AR fill:#F99928,stroke:#F99928,color:#fff
style AS fill:#F99928,stroke:#F99928,color:#fff
style AT fill:#F99928,stroke:#F99928,color:#fff

'#MERMAID' - [CODE]:
graph LR
node_header[["ISCAT NAV Audit Readiness:"]]
BEGIN(((" "))) ==> A

A[Network Adequacy Data Reconciliation, Preproduction, and Integration] --> B[Overview of network adequacy data preproduction process]
A --> C[Overview of data warehouse/repository]
--> D[Overview of data security and back-up processes]
A --> E[Reconciliation of files used to calculate network adequacy indicators]
A --> F[Interview of data preproduction processing and data integration]
A --> G[Data completeness]

H[Network Adequacy Methodology and Reporting] --> I[Overview and discussion regarding network adequacy methodology]
H --> J[Primary Source Verification/logic discussion]
H --> K[Discussion from the ISCAT review]

L[SQL Scripts and Policy] --> M[ISCAT_NAV_DHCS_ADEQUACY_TAXONOMY_RESET_20230129.sql]
L --> N[ISCAT_NAV_DHCS_STEP88_GEOACCESS_PROVGROUP_20220817.sql]
L --> O[ISCAT_NAV_DHCS_STEP88_MEMBER_COUNT_20240318.sql]
L --> P[ISCAT_NAV_Network Certification Providers 20240317.sql]
L --> Q[ISCAT_NAV_Provider Network Analysis Language Race Ethnicity Membership 20231103.sql]
L --> R[ISCAT_NAV_SQIC_STEP88_GEOACCESS_PROVGROUP_20231103.sql]
L --> S[ISCAT_NAV_SQIC_STEP88_MEMBER_COUNT_20240515.sql]
L --> T[ISCAT_NAV_NETWORK_QTR_ADD_TERM_20230929.sql]
L --> U[ISCAT NAV 5150a Network Development Policy 6.3.24 1.24pm.docx]

M --> E
N --> E
N --> I
O --> E
O --> G
P --> E
P --> I
Q --> E
Q --> G
Q --> I
R --> E
R --> G
R --> I
S --> E
S --> G
S --> I
T --> E
U --> I
U --> J
E --> H
F --> H
G --> H

style node_header stroke:#AA00FF,color:#FFD600,fill:#AA00FF,stroke-width:19px,stroke-dasharray: 0
style A fill:#F99928,stroke:#F99928,color:#fff
style B fill:#002B49,stroke:#002B49,color:#fff
style C fill:#007097,stroke:#007097,color:#fff
style D fill:#00A5DB,stroke:#00A5DB,color:#fff
style E fill:#63666A,stroke:#63666A,color:#fff
style F fill:#A7A9AC,stroke:#A7A9AC,color:#fff
style G fill:#D1D3D4,stroke:#D1D3D4,color:#000
style H fill:#F99928,stroke:#F99928,color:#fff
style I fill:#002B49,stroke:#002B49,color:#fff
style J fill:#007097,stroke:#007097,color:#fff
style K fill:#00A5DB,stroke:#00A5DB,color:#fff
style L fill:#F99928,stroke:#F99928,color:#fff
style M fill:#002B49,stroke:#002B49,color:#fff
style N fill:#007097,stroke:#007097,color:#fff
style O fill:#00A5DB,stroke:#00A5DB,color:#fff
style P fill:#63666A,stroke:#63666A,color:#fff
style Q fill:#A7A9AC,stroke:#A7A9AC,color:#fff
style R fill:#D1D3D4,stroke:#D1D3D4,color:#000
style S fill:#002B49,stroke:#002B49,color:#fff
style T fill:#007097,stroke:#007097,color:#fff
style U fill:#00A5DB,stroke:#00A5DB,color:#fff

'#MERMAID' - [CODE]:
graph TD
node_header[["ISCAT NAV Audit Readiness:"]]
BEGIN(((" "))) ==> A 

A[Network Adequacy Data Reconciliation, Preproduction, and Integration] --> B[Overview of network adequacy data preproduction process]
A --> C[Overview of data warehouse/repository]
A --> D[Overview of data security and back-up processes]
A --> E[Reconciliation of files used to calculate network adequacy indicators]
A --> F[Interview of data preproduction processing and data integration]
A --> G[Data completeness]

H[Network Adequacy Methodology and Reporting] --> I[Overview and discussion regarding network adequacy methodology]
H --> J[Primary Source Verification/logic discussion]
H --> K[Discussion from the ISCAT review] 

L[SQL Scripts] --> M[ISCAT_NAV_DHCS_ADEQUACY_TAXONOMY_RESET_20230129.sql]
L --> N[ISCAT_NAV_DHCS_STEP88_GEOACCESS_PROVGROUP_20220817.sql]
L --> O[ISCAT_NAV_DHCS_STEP88_MEMBER_COUNT_20240318.sql]
L --> P[ISCAT_NAV_Network Certification Providers 20240317.sql]
L --> Q[ISCAT_NAV_Provider Network Analysis Language Race Ethnicity Membership 20231103.sql]
L --> R[ISCAT_NAV_SQIC_STEP88_GEOACCESS_PROVGROUP_20231103.sql]
L --> S[ISCAT_NAV_SQIC_STEP88_MEMBER_COUNT_20240515.sql]

M --> E
N --> E
N --> I
O --> E
O --> G
P --> E
P --> I
Q --> E
Q --> G
Q --> I
R --> E
R --> G
R --> I
S --> E
S --> G
S --> I
E --> H
F --> H
G --> H 

			style node_header stroke:#AA00FF,color:#FFD600,fill:#AA00FF,stroke-width:19px,stroke-dasharray: 0
			style A fill:#F99928,stroke:#F99928,color:#fff
			style B fill:#002B49,stroke:#002B49,color:#fff
			style C fill:#007097,stroke:#007097,color:#fff    

'#MERMAID' - [CODE]:
flowchart TD
node_header[["OAW OPTION ARBITRAGE WHEEL:"]]
BEGIN(((" "))) ==> A

A[Sell Puts +$ premium] -->|Restart| B(Rinse & Repeat)
B -->|When assigned| C[Sell Calls +$ premium]
C -->|When assigned| A
B -->|Stocks get called away +$ profit| A

			style node_header stroke:#AA00FF,color:#FFD600,fill:#AA00FF,stroke-width:19px,stroke-dasharray: 0
			style A fill:#F99928,stroke:#F99928,color:#fff
			style B fill:#002B49,stroke:#002B49,color:#fff
			style C fill:#007097,stroke:#007097,color:#fff
            
'#MERMAID' - [CODE]:
graph TD
node_header[["100 Days of Data Science Roadmap:"]]
BEGIN(((" "))) ==> A

A[100 Days of Data Science Roadmap] --> B(Days 1-20: Python & Data Manipulation)
A --> C(Days 21-40: Data Wrangling & Exploration)
A --> D(Days 41-60: Statistics & Probability)
A --> E(Days 61-80: Machine Learning Basics)
A --> F(Days 81-100: Advanced Topics & Projects)
G[Check captions for Detailed Roadmap] --> A

			style node_header stroke:#AA00FF,color:#FFD600,fill:#AA00FF,stroke-width:19px,stroke-dasharray: 0
			style A fill:#F99928,stroke:#F99928,color:#fff
			style B fill:#002B49,stroke:#002B49,color:#fff
			style C fill:#007097,stroke:#007097,color:#fff

'#MERMAID' - [CODE]:
graph TD
node_header[["Regulatory Report Stakeholder Review Agenda:"]]
BEGIN(((" "))) ==> A

    A[Data Extraction] -->|SQL Queries / Script Exec; | B(Review / Confirm Most Current Code Sets)
    B --> |Narrative / Regulator Specifications Review: | C(Review / Confirm Specs)
    C -->|Sign Off + Distribution| D(Done!!!)

			style node_header stroke:#AA00FF,color:#FFD600,fill:#AA00FF,stroke-width:19px,stroke-dasharray: 0
			style A fill:#F99928,stroke:#F99928,color:#fff
			style B fill:#002B49,stroke:#002B49,color:#fff
			style C fill:#007097,stroke:#007097,color:#fff

'#MERMAID' - [CODE]:
graph TD
node_header[["Report Generation Process:"]]
	BEGIN(((" "))) ==> A

    A[Data Extraction] -->|SQL Queries| B(Extract member 
	&
	provider data)
    B --> C[Data Transformation and Loading]
    C -->|ETL Process| D(Cleanse, standardize, and integrate data)
    D --> E(Load data into reporting database)
    E --> F[Network Adequacy Calculations]
    F -->|SQL and Quest Analytics API| G(Calculate TIME
    and / or
    DISTANCE metrics)
    F --> H(Calculate provider-to-member ratios)
    F --> I(Calculate appointment
    availability measures)
    G --> J(Store results in summary tables/views)
    H --> J
    I --> J
    J --> K[Report Generation]
    K -->|Reporting Tools| L(Generate reports using
    pre-defined templates)
    L --> M(Produce reports in standard formats - PDF, Excel)
    M --> N[Quality Assurance and Review]
    N -->|Manual spot checks, reconciliation| O(Validate accuracy and
    completeness)
    O --> P{Any issues found?}
    P -->|Yes| Q(Investigate and resolve issues)
    Q --> N
    P -->|No| R[Finalize Reports]
    R --> S[Distribution and Submission]
    S -->|Secure distribution| T(Internal stakeholders)
    S -->|Regulatory submission| U(Regulatory bodies)
    S --> V(Subcontractors)
    R --> W[Documentation and Archiving]
    W --> X(Maintain documentation of methodologies 
	and assumptions)
    W --> Y(Archive report-related files securely)

		style node_header stroke:#AA00FF,color:#FFD600,fill:#AA00FF,stroke-width:9px,stroke-dasharray: 0	
		style A fill:#F99928,stroke:#F99928,color:#fff
		style B fill:#002B49,stroke:#002B49,color:#fff
		style C fill:#007097,stroke:#007097,color:#fff
		style D fill:#6AB3DB,stroke:#6AB3DB,color:#000
		style E fill:#007097,stroke:#007097,color:#fff
		style F fill:#6AB3DB,stroke:#6AB3DB,color:#000

		linkStyle 0 stroke:#F99928,stroke-width:2px
		linkStyle 1 stroke:#1C91C0,stroke-width:2px
		linkStyle 2 stroke:#1C91C0,stroke-width:2px
		linkStyle 3 stroke:#1C91C0,stroke-width:2px
		linkStyle 4 stroke:#1C91C0,stroke-width:2px
		linkStyle 5 stroke:#F99928,stroke-width:2px

'#MERMAID' - [CODE]:
graph TD
node_header[["Tableau TC2024: How to Choose"]]
   BEGIN(((" "))) ==> A 

    A[LOD] --> B{Ranking Recursion Moving Calc Inter-Row Calc}
    B -->|BEST/WORST 1| C{Have all the data values to answer my question in the viz?}
    C -->|YES| D[Table Calculation]
    C -->|NO| E{Granularity of question = granularity of Viz/Data Source?}
    E -->|YES| F[Basic Calc]
    E -->|NO| A

			style node_header stroke:#AA00FF,color:#FFD600,fill:#AA00FF,stroke-width:19px,stroke-dasharray: 0
			style A fill:#F99928,stroke:#F99928,color:#fff
			style B fill:#002B49,stroke:#002B49,color:#fff
			style C fill:#007097,stroke:#007097,color:#fff
			style D fill:#6AB3DB,stroke:#6AB3DB,color:#000
			style E fill:#007097,stroke:#007097,color:#fff
			style F fill:#6AB3DB,stroke:#6AB3DB,color:#000

			linkStyle 0 stroke:#F99928,stroke-width:2px
			linkStyle 1 stroke:#1C91C0,stroke-width:2px
			linkStyle 2 stroke:#1C91C0,stroke-width:2px
			linkStyle 3 stroke:#1C91C0,stroke-width:2px
			linkStyle 4 stroke:#1C91C0,stroke-width:2px
			linkStyle 5 stroke:#F99928,stroke-width:2px

'#MERMAID' - [CODE]:
graph TD
node_header[["Ms Sandra - PRACTITIONER DATA SYSTEM
DATA FLOW:"]]
    style node_header stroke:#AA00FF,color:#FFD600,fill:#AA00FF,stroke-width:4px,stroke-dasharray: 0
BEGIN(((" "))) ==> A

A[Data Entry Specialist enters data in eVIPs] --> B{Credentialing Field = Y?}
B -->|Yes| C[Credential Process Activated]
C --> D[Application Received from Credentialing]
D --> E[Application and Credentialing Verification
Data Entered into eVIPs]
B -->|No| F{Paper Claim from Provider without
a QNXT Record?}
F -->|Yes| G[Claim Information Routed to PE]
G --> H[PE Validates & Enters in QNXT]
H --> I[Provider number returned to claims
Department for Adjudication]
F -->|No| J{EDI Claim from Provider without
a QNXT Record?}
J -->|Yes| G
J -->|No| K[Notification of Provider's Change of Address,
Taxpayer Info, Contracting Entity]
K --> L[Data Entry Specialist Validates Info]

'#MERMAID' - [CODE]:
graph LR
node_header["HIGH-LEVEL DATA PROCESS FLOW:"]
    style node_header stroke:#AA00FF,color:#FFD600,fill:#AA00FF,stroke-width:4px,stroke-dasharray: 0
BEGIN(((" "))) ==> A

	A[Enrollment System] --> C[Data Warehouse]
	B[Provider Data Management System] --> C[Data Warehouse]
	D[Claims Processing System] --> C[Data Warehouse]
	C --> E[Data Mart]
	E --> F[Network Adequacy Analysis]
	F --> G[Reporting and Visualization]

'#MERMAID' - [CODE]:
flowchart TB
node_header[["DETAILED DATA PROCESS FLOW:"]]
    style node_header stroke:#AA00FF,color:#FFD600,fill:#AA00FF,stroke-width:4px,stroke-dasharray: 0
BEGIN(((" "))) ==> A

    A["Enrollment System"] --> B["ETL Process"]
    C["Provider Data Management System"] --> B
    D["Claims Processing System"] --> B
    B --> E["Data Warehouse"]
    E --> F["Data Mart"]
    F --> G["Geocoding"]
    G --> H["Time and Distance Calculations"] & I["Provider Capacity Analysis"]
    H --> J["Network Adequacy Reporting"]
    I --> J
    J --> K["Data Quality Checks"]
    K --> L["Supervisory Review"]
    L --> M["Final Network Adequacy Reports"]

'#MERMAID' - [CODE]:
graph LR
node_header["DATA QUALITY AND VALIDATION PROCESS:"]
    style node_header stroke:#AA00FF,color:#FFD600,fill:#AA00FF,stroke-width:4px,stroke-dasharray: 0
BEGIN(((" "))) ==> A
	A[Data Profiling] --> B[Data Validation Rules]
	B --> C[Data Reconciliation]
	C --> D[Supervisory Review]
	D --> E[Continuous Monitoring and Improvement]

'#MERMAID' - [CODE]:
graph TD
node_header[["TARGETED RATE INCREASE (TRI) 
SUBCAPITATION SUPPLEMENTAL DATA REQUEST (SDR):"]]
    style node_header stroke:#AA00FF,color:#FFD600,fill:#AA00FF,stroke-width:4px,stroke-dasharray: 0
BEGIN(((" "))) ==> A

    A[Existing SQL Scripts] --> B{Identify Eligible Subcontracts}
    B --> C[Pull Relevant Encounter Data]
    C --> D[Develop Repricing Logic]
    D --> E[Medi-Cal FFS Fee Schedule]
    D --> F[TRI Fee Schedule]
    E --> G[Reprice Encounters]
    F --> G[Reprice Encounters]
    G --> H[Aggregate Data by Subcontractor]
    H --> I[Calculate Total Costs, 
	Repriced Amounts, Key Percentages]
    I --> J[Generate Enrollment Files per Subcontractor]
    J --> K[Conduct Data Validation Checks]
    K --> L{Data Complete and Accurate?}
    L -->|No| M[Investigate and Resolve Issues]
    M --> K
    L -->|Yes| N[Prepare Data for Submission]
    N --> O[CEO/CFO Certification]
    O --> P[Submit TRI Subcapitation SDR to DHCS/Mercer]
    P --> DESTINATION(((" ")))
