# Model 2C: Replication

## Description
This folder contains scripts that were part of phase 1's Model 2C folder. Despite being named "Model 2C", there are no predicitive models in this folder past or present.

The files in this folder:
- provides basic exploratory analysis
- reverse geocodes census tract information from geographical (latitude & longitude) coordinates
- create fire idicator that is equal to the total number of fires per census tract
- plots number of cases for each Red Cross zone and state

## Data
Below is a list of data sets used by and created by the code.
| Dataset | Created/ Used? | Code Created | Description |
| ------- | -------------- | ------------ | ----------- |
| 2009-2014_RedCross_DisasterCases.csv | Used | NA | main data set containing Red Cross data & lat-long
| 2009-2014_Homefire_geo.csv | Created & Used | RC_homefire_per_tract_risk_indicator.R | reverse geocode from lat-long, used by redcross_homefire_risk_indicator.R
| rc_disaster_summary_stats.txt | Created | RC_disaster_data_exploring.R  | summary statistics for 2009-2014_RedCross_DisasterCases.csv dataset
| redcross_homefires_cases.csv | Created & Used | RC_homefire_per_tract_risk_indicator.R | previously named 2009-2014_RedCross_HomeFire_Cases.csv, subset of 2009-2014_RedCross_DisasterCases.csv that only contains home fire records, used by redcross_homefire_risk_indicator.R 
| redcross_homefires_cases_tract.csv | Created & Used | redcross_homefire_risk_indicator.R | merged dataframe containing census tract information and Red Cross fire information
| homefire_risk_indicator1.csv | Created | redcross_homefire_risk_indicator.R | fire risk indicator equal to the number of fires per day per tract
| homefire_risk_indicator3.csv | Created | redcross_homefire_risk_indicator.R | fire risk indicator equal to the number of fires per tract
| fires_per_tract.csv | Created | RC_homefire_per_tract_risk_indicator.R | number of fires per tract

## Code
| Code | Phase | Libraries/ Modules | Description | Notes |
| ---- | ----- | ------------------ | ----------- | ----- |
| RC_disaster_data_exploring.R | 1 & 2 | readr, plyr, dplyr, ggplot2, stargazer | EDA | need a different way of summarizing data since there are different data types within each column
| RC_disaster_data_responses_per_region.R | 1 & 2 | readr, plyr, dplyr, ggplot2 | generates figures | try and repeat for each type of RC case
| RC_homefire_per_tract_risk_indicator.R | 1 & 2 | xml2, XML, httr, base, rjson, foreach, doMC, data.table, plyr | reverse geocode | takes about 4 hours so currently is the fastest method, change code so that fire events are not subsetted into a seperate dataframe since there are concerns that indexing across different data sets will make merging difficult
| redcross_homefire_risk_indicator.R | 1 & 2 | readr, plyr, dplyr, ggplot2, gdata | generates fire risk indicator | NA
| phase2_model2c_EDA.ipynb | 2 | os, pandas, numpy, seaborn, matplotlib | replication of phase 1 EDA | more granular EDA, tons of figures to digest
| phase2_reverse_geocoding.ipynb | 2 | os, pandas, numpy, censusgeocode, math, datetime, tqdm | replication of phase 1 reverse geocoding using censusgeocode module | slowest approach, try to parallelize
| phase2_reverse_geocoding_xml_parsing.ipynb | 2 | os, pandas, numpy, math, time, tqdm, xml, urllib, xmltodict | replication of phase 1 reverse geocoding using phase 1 API | very slow, but faster than the censusgeocode approach, try to parallelize, try to save and append census data in chunks


## To Do List
| Item | Completed |
| ---- | --------- |
| Find a faster way to geocode or parallelize current code | - |
| Finalize EDA | - |
| Reverse geocode with intact dataset, skip rows that were removed previously to avoid indexing issues | - |

## Progress
| Meeting | Date | Volunteers | Notes |
| ------- | ---- | ---------- | ----- |
| 1 | ? | S. Sylvester, R. Handa | reviewed phase 1 code, discussed purpose of code to team, provided suggestions for phase 1
| 2 | May 8, 2018 | S. Sylvester | - |
