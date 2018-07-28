
## Model 2A README Description ##

### Overview of Model ###
In Model 2A, the goal is to calculate the number of fire incidents per 1000 people.  
The **input** are the data sets described below, and the **output** is a dataset which indicates the tracts with the highest number of incidents per 1000 people in each state.

### Navigation ###

- In phase1-code-model2a, you will find the RMarkdown file (phase1-code-model2a.Rmd) which contains the code written by the originals.  The code uploads the data required, extracts information from both census and National Fire Incident Reporting System (NFIRS) data, and then calculates the proportion of fire incidents per 1000 people.  
    - The RMarkdown file, when compiled, will output a map of a state.  The most red areas have the highest rate of incident, and the lighter shades of red have lower rates of incident.
- In phase1-results-model2a, you will find data files created by phase1-code-model2A.Rmd which contain all the tract information for the proportion.  Additionally, maps of Maryland for years 2009-2013 are saved in phase1-visualization-model2a.
- In phase2-code, you will find the work currently in progress by the Phase 2 Team.  At the moment, this is a copy of the phase1-code-model2a with comments throughout the file so that future may understand the code.  
- In phase2-results, you will find the results for the phase2-code.  At the moment, this is the best version of replicated Phase 1 results.

### Input Data ###
Data required to successfully run Model 2A:

- **_formatted_addresses.csv*: files that contain the formatted addresses of buildings for each year, e.g. 1001 G Street Northwest, Washington, DC 20001
- **_geocoded_addresses.csv*: files that contain the geocoded addresses of buildings for each year, e.g. latitude and longitude coordinates for the address above according to (https://geocoding.geo.census.gov/geocoder/locations/address?form): X: -77.02605 Y: 38.89833
- **_basic_incident.txt*: file contains information about any incidents reported by fire department, not necessarily involving a fire
- *national_county.txt*: file contains national and state FIPS codes (a five-digit Federal Information Processing Standards code) for counties and county equivalent entities.  
- **_fire_incident.txt*: file contains information about the incidents reported by fire departments to NFIRS that did involve a fire
- *Tract_2010Census_DP1.dbf*: 2010 census tract data 
- *us2010trf.txt*: 2010 tract relationship file from census

The data files are too large for this repo, so they are stored on the Google Drive: https://drive.google.com/open?id=14FSdOjsk2w9p3UlnntJFglOhXzLnCuT2

### To Do ###
       
|    |                                    Task                                    |                 Progress Notes                 | Check |
|----|----------------------------------------------------------------------------|--------------------------------------------|-------|
| 1. | Double check all input files are the same as the Originals for replication | This particular task has been attempted many times.  There was success once, and it was verified by a volunteer at one DataJam?  However, checking again, it seems there was a mistake along the way? Code works, and results are very close.  See phase2-results. | |
| 2. | Check the new NFIRS data has the same variable names and the same variable types | Need to email RC rep because the data does not match the fire_incident.txt or the basic_incident.txt | |
| 3. | EDA with new NFIRS data | According to NFIRS documentation, there are several "modules", or datasets.  Including the basic_incident.txt and fire_incident.txt.  The new NFIRS 2009 - 2016 data seems to be some merge of these modules. | X |
| 4. | Can the # of fires per 1000 people be calculated with the NFIRS data?  | | |
