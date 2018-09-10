# Model 1B Data Update

## Primary Developer
Maria Brun

## Data

The data for the target variable are vailable on GitHub in a csv called 2009_2016_alarm_presence_by_tract. However, the raw data files used to create that csv are stored in the RCP2 google drive in Data Inputs and Model Outputs - Phase 2 / Phase2 - Model_1B / Input Data.

The explanatory variables come from the ACS / AHS (still being determined as of 8.6.2018)

## Target Variable Data Process

The target variable of Model 1B is a variable called "ratio_no_alarm_in_all." This variable comes from NFIRS, but not directly. Instead, I determined this variable was calculated by the previous team in several steps.

First, the team joined the NFIRS data to some other source to get census tract IDs. NFIRS has both a fire department id (FDID) and zip code. I used a 2018 quarter 2 HUD Zip to Tract data file available at https://www.huduser.gov/portal/datasets/usps_crosswalk.html and stored as ZIP_TRACT_062018 on GitHub under red-cross-2\Model-1B\Data. I joined these datasets on zip code, noting that some records (primarily in California) used abbreviations rather than zipcodes (I'm currently working to get fire deparment ID's by zip code to fix this).

Next, the team summed the number of incidents where there was no alarm (N), unknown alarm (U), at least one alarm present (1), or not recorded (blank). I did the same.

Then, the team rolled up the data by tract to determine the total number of fire incidents. Using 2009-2016 NFIRS data, I did the same. However, this revealed a possible issue whereby I was seeing multiple tracts with similar IDs with the same totals. Digging into the NFIRS/HUD joined data, I realized that zipcodes can belong to multiple tracts, so there are fires counted in multiple tracts.

Finally, the team divided the number of "no alarm present" records by tract by the total fire incidents in a tract and then by the total fire incidents where the presence of the alarm was known. I did the same.

## Explanatory Variable Data Process

The prior team worked with Enigma to use the ACS, much more geographically granular, to assign AHS data on smoke alarms to census tracts. Model 1B used 250 variables from this data set as explanatory variables. 

Currently working on updated ACS/AHS data as of 8.6.2018
