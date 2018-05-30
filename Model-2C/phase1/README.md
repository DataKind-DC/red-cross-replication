# Phase 1 Folder File & Data Organization

## Code Folder
The code folder is organized by phases. The folder "original" contains code used in Phase 1. Folder "replicated" contains phase 1 code that was rewritten to fix bugs that have developed due to changes in R versions, web links, etc.

**RC_disaster_data_exploring.R**

- Description: exploratory data analysis
- Modules: readr, plyr, dplyr, ggplot2, stargazer
- Input: 2009-2014_RedCross_DisasterCases.csv
- Output: NA

**RC_disaster_data_responses_per_region.R**

- Description: generates figures that describe the number of cases per state and Red Cross region
- Modules: readr, plyr, dplyr, ggplot2
- Input: 2009-2014_RedCross_DisasterCases.csv
- Output: figures (not saved)

**RC_homefire_per_tract_risk_indicator.R**

- Description: reverse geocodes using an API
- Modules: xml2, XML, httr, base, rjson, foreach, doMC, data.table, plyr
- Input: 2009-2014_RedCross_DisasterCases.csv
- Output: 2009-2014_Homefire_geo.csv, fires_per_tract.csv, geocodes_x_x.csv, redcross_homefires_cases.csv

**redcross_homefire_risk_indicator.R**

- Description: generates fire risk indicator score that is equal to the total number of fires per census tract
- Libraries: readr, plyr, dplyr, ggplot2, gdata
- Input: redcross_homefires_cases.csv, 2009-2014_Homefire_geo.csv
- Output: homefire_risk_indicator1.csv, homefire_risk_indicator3.csv

## Data
Input and output files can be downloaded from the Red Cross Phase 2 Google Drive.

### Input
- 2009-2014_RedCross_DisasterCases.csv

### Output

- 2009-2014_Homefire_geo.csv
- rc_disaster_summary_stats.txt
- redcross_homefires_cases.csv
- redcross_homefires_cases_tract.csv
- homefire_risk_indicator1.csv
- homefire_risk_indicator3.csv
- fires_per_tract.csv
- geocodes_x_x.csv