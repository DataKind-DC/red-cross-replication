# Phase 2 Reverse Geocoding & Exploratory Data Analysis

## Code

*get_geocodes.R*
- Description: Finds census tract information from lat-long coordinates from 2010 state census tract shapefiles. Shortens prior R and Python techniques significantly. Total elasped time approximately 10 minutes with automatic downloading of shapefiles from census.gov.
- Libraries: tictoc, xml2, XML, sf, raster (R version 3.4.4 (2018-03-15), "Someone to Lean On")
- Input: state_FIPs_codes.txt, 2009-2014_RedCross_DisasterCases.csv
- Output: 2009_2014_RedCross_DisasterCases_with_census_data.csv

*phase2_model2c_EDA.ipynb*
Description: exploratory data analysis
Modules: os, pandas, numpy, seaborn, matplotlib (Python 3.6)
Input: 2009-2014_RedCross_DisasterCases.csv
Output: N/A

*phase2_reverse_geocoding_xml_parsing.ipynb*
Description: reverse geocode following Phase 1's API method
Modules: os, pandas, numpy, math, time, tqdm, xml.etree.ElementTree, urllib.request, xmltodict, math (Python 3.6)
Input: 2009-2014_RedCross_DisasterCases.csv
Output: geocodes_xml_method.csv

*phase2_reverse_geocoding.ipynb*
Description: reverse geocoding using censusgeocode module (slowest technique)
Modules: os, pandas, numpy, censusgeocode, math, datetime, tqdm (Python 3.6)
Input: 2009-2014_RedCross_DisasterCases.csv
Output: geocodes.csv

## To Do List

| Item | Completed |
| ---- | --------- |
| Find a faster way to geocode or parallelize current code | May 9 |
| Finalize EDA | - |
| Try reverse geocoding using geopandas following similar approach as get_geocodes.R | - |