# Phase 2 Replication of Phase 1 Model 2C

### Description
This folder contains scripts that were part of phase 1's Model 2C folder and updated versions of said scripts. Despite being named "Model 2C", there are no predicitive models in this folder past or present.

The files in this folder:

- provide basic exploratory data analysis
- reverse geocodes census tract information from geographical (latitude & longitude) coordinates
- create fire idicator score that is equal to the total number of fires per census tract

### Code
Replicated phase 1 code is written in R (version 3.4.4 (2018-03-15), Someone to Lean On) and Python 3.6. More detailed descriptions of code can be found in README.md files within each folder.

### Data
Input and output data can be downloaded from the Phase 2 Google Drive. See project leads for access.

#### Input

- state_FIPs_codes.txt
- 2009-2014_RedCross_DisasterCases.csv
- 2010 census tract shapefiles

#### Output

**Phase 1 (Original & Replicated)**

- 2009-2014_Homefire_geo.csv
- rc_disaster_summary_stats.txt
- redcross_homefires_cases.csv
- redcross_homefires_cases_tract.csv
- homefire_risk_indicator1.csv
- homefire_risk_indicator3.csv
- fires_per_tract.csv
- geocodes_x_x.csv

**Phase 2**

- 2009_2014_RedCross_DisasterCases_with_census_data.csv
- geocodes_xml_method.csv
- geocodes.csv



### To Do List
| Item | Completed |
| --------------------------------------------------- | --------- |
| Find a faster way to geocode or parallelize current code | May 9 |
| Finalize EDA | - |
| Reverse geocode with intact dataset, skip rows that were removed previously to avoid indexing issues | May 9 |
| Try reverse geocoding using geopandas following similar approach as get_geocodes.R | - |

### Progress
| Meeting | Date | Volunteers | Notes |
| --- | --------- | ---------- | ------------------------------------ |
| 1 | ? | S. Sylvester, R. Handa | reviewed phase 1 code, discussed purpose of code to team, provided suggestions for phase 1 |
| 2 | May 8, 2018 | S. Sylvester, D. Duval-Diop , J. Wenk | addressed geocode issues |