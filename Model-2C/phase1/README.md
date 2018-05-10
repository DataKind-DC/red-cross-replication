# README

## Code Folder
The code folder is organized by phases. The folder "original" contains code used in Phase 1. Folder "replicated" contains phase 1 code that was rewritten to fix bugs that have developed due to changes in R versions, web links, etc.

The files in this folder:
- provides basic exploratory analysis (RC_disaster_data_exploring.R)
- reverse geocodes census tract information from geographical (latitude & longitude) coordinates (RC_homefire_per_tract_risk_indicator.R)
- create fire idicator that is equal to the total number of fires per census tract (redcross_homefire_risk_indicator.R)
- plots number of cases for each Red Cross zone and state (RC_disaster_data_responses_per_region.R)

## Data
Input and output files can be downloaded from the Red Cross Phase 2 Google Drive.

### Input
2009-2014_RedCross_DisasterCases.csv

### Output
2009-2014_Homefire_geo.csv
rc_disaster_summary_stats.txt
redcross_homefires_cases.csv
redcross_homefires_cases_tract.csv
homefire_risk_indicator1.csv
homefire_risk_indicator3.csv
fires_per_tract.csv
geocodes_x_x.csv