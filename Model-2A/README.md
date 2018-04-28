
## Model 2A README Description ##

### Overview of Model ###
In Model 2A, the goal is to calculate the number of fire incidents per 1000 people.  
The **input** are the data sets described below, and the **output** is a map which indicates the tracts with the highest number of incidents per 1000 people.

### Navigation ###

- In phase1-code-model2a, you will find the RMarkdown file (phase1-code-model2a.Rmd) which contains the code written by the originals.  The code uploads the data required, extracts information from both census and National Fire Incident Reporting System (NFIRS) data, and then calculates the proportion of fire incidents per 1000 people.
- In phase1-results-model2a, you will find data files created by phase1-code-model2A.Rmd which contain all the tract information for the proportion.  Additionally, maps of Maryland for years 2009-2013 are saved in phase1-visualization-model2a.
- In phase2-code, you will find the work currently in progress by the Phase 2 Team.

### Data ###
Data required to successfully run Model 2A:

- **_formatted_addresses.csv*: files that contain the formatted addresses of buildings for each year
- **_geocoded_addresses.csv*: files that contain the geocoded addresses of buildings for each year
- *basicincident.txt*: file contains information about any incidents reported by fire department, not necessarily involving a fire
- *national_county.txt*: file contains national and state FIPS codes (a five-digit Federal Information Processing Standards code) for counties and county equivalent entities.  
- *NFIRS_FireIncidents.csv*: file contains information about the incidents reported by fire departments to NFIRS that did involve a fire
- *Tract_2010Census_DP1.dbf*: 2010 census tract data 
- *us2010trf.txt*: 2010 tract relationship file from census

The data files are too large for this repo, so they are stored on the Google Drive: ??


