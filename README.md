
## Background of Phase 1

Where should the American Red Cross go to install smoke alarms?

In 2015, DataKind DC, the American Red Cross, and Enigma worked together to create a Home-Fire Risk Score at the U.S. Census Tract Level. The team created models to predict the highest impact areas to go knock on doors to install smoke alarms. These models were developed using proprietary data from the American Red Cross, the American Community Survey, the American Housing Survey, and NFIRS. Since the Red Cross doesn't visit all areas of the USA, risk scores were imputed to non-surveyed areas. Results were displayed on the smoke signals map. Some work was also done to understand historical home fires, where did it happen, how deadly were they?

The final product was a Home Fire Risk <a href="http://www.datakind.org/blog/american-red-cross-and-datakind-team-up-to-prevent-home-fire-deaths-and-injuries">Map</a>.



## Phase 2 Road Map
1. Replicate Phase 1 Models
2. Cross Validation of Phase 1 Predictions with New data
3. Improve/Update Index and models. We have new NFIRS, Red Cross, and ACS data that we would like to incorporate. We would like to consider adding new types of data as well such as climate data.
4. Update the Home Fire Risk Map!

## How to Help in Phase 2

The first step of the Red Cross Phase 2 is to replicate and document  Phase 1 results. Phase 1's original GitHub repo is <a href="https://github.com/DataKind-DC/smoke_alarm_models">here</a>. There are six models that the team is working to replicate, if you are interested in helping out on one, the Data Corps contact person is below.

Progress Notes:  <a href="https://github.com/DataKind-DC/red-cross-2/blob/master/Progress%20Document.md">here</a>


Phase 1 Model  |  Status  | Next Steps | Issues
----|-------|---|-----
  1A  - Judy    | Verified by Judy (June 4, 2018) | Update model with new ACS & RC Home Fire Install data  |
   1B - Maria    | Verified  | Update model with new data  |
   1C - Roland   |under replication (last update by Minh June 4, 2018) |   Cannot find R script that creates results (Minh found code by Enigma) |
   2A - Amanda   | Verified by Lauren (June 4, 2018)   | Update model with new data   | How to find address_type in formatted_address data?
   2C - Sherika  |  under replication (last update June 4, 2018: Sherika and Daniel) |   |  Issue with geo-coding - translating to Python
  3A - Manuel   |  Verified | |
 Aggregate - Maria| Unable to Replicate  | Code works - update with new models  | May not be final code used by RCP1

## Model Input-Output Relationships


Model | Input Data | Output Files | Output To...
-----|-------|---------------|-------------
 1A  | Homefire_SmokeAlarmInstalls.csv, ACS | smoke_alarm_risk_scores_1a.csv  | Aggregate
 1B  | 2009_2013_alarm_tract_data.csv, ACS  | tracts_74k_weighted_linear_preds_upsampled.csv | Aggregate
 1C  | AHS  | smoke_alarm_risk_scores_1c.csv  | Aggregate
2A  | 2010 Census, fire_incident  | 2009_tract_building_fire_per_1k 2010_tract_building_fire_per_1k 2011_tract_building_fire_per_1k 2012_tract_building_fire_per_1k 2013_tract_building_fire_per_1k   | Aggregate  
 2C  | RC disaster cases, 2010 census tract shape files, state fibs code file  | fires_per_tract  | Aggregate
 3A  | modeling_injury_dataset, ACS tract data  | results_tract  | Aggregate
 Aggregate  | Output files from 1A, 1B, 1C, 2A, 2C, and 3A  |  risk_tract | Map

## DataKind DataCorps

DataKind DataCorps brings together teams of pro bono data scientists with social change organizations on long-term projects that use data science to transform their work and their sector. We help organizations define their needs and discover what’s possible, then match them with a team that can translate those needs into data science problems and solve them with advanced analytics.

We are very proud to re-partner with the American Red Cross!
