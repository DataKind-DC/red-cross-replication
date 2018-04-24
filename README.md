
## Background of Phase 1

Where should the American Red Cross go to install smoke alarms?

In 2015, DataKind DC, the American Red Cross, and Enigma worked together to create a Home-Fire Risk Score at the U.S. Census Tract Level. The team created models to predict the highest impact areas to go knock on doors to install smoke alarms. These models were developed using proprietary data from the American Red Cross, the American Community Survey, the American Housing Survey, and NFIRS. Since the Red Cross doesn't visit all areas of the USA, risk scores were imputed to non-surveyed areas. Results were displayed on the smoke signals map. Some work was also done to understand historical home fires, where did it happen, how deadly were they?

## How to Help in Phase 2

The first step of the Red Cross Phase 2 is to replicate and document well Phase 1 results. Phase 1's original GitHub repo is <a href link="https://github.com/DataKind-DC/smoke_alarm_models">here</a>. There are six models that the team is working to replicate, if you are interested in helping out on one, the Data Corps contact person is below.

The 2015 Risk Score is a simple average of 5 risks scores from 5 independent models. Full notes are here. Six models were developed using various data sources and available at various geographic levels of aggregation.

Model
Target Variable
Predictors
Type o Model
Data Sources
1A -
% of RC home visits that led to a smoke alarm install
Tract-level characteristics from the ACS
Logit (1/0)
RC Home Visit data

ACS (2009-2013)
1B - Roland
% of fire incidents within a region that didn’t have smoke detectors


clf_linear = linear_model.SGDRegressor
ACS
NFIRS
1C - Maria (?)
% of homes in area that don’t have working smoke alarm




AHS
2A - Jake
# of incidents per 1,000 person within a region


Just ratio by area, no models
(N/population)


NFIRS
2C - Sherika
# of RC fire responses per region


Combine geographical data, info on demographics into one table. # of cases of fires per region/state,

Converted coordinates from RC files to Census block data

Conversion used an API, process could have been bulky, maybe use geo-pandas
RC disaster data
3A - Manuel
# of injuries per 1,000 people (NFIRS)

Probability of injury or death
Tract level characteristics (ACS/NFIRS)
2 Logistic regressions, and 1 Random Forest, in the end a RF was used?
NFIRS
ACS



1A - Judy

1B - Maria

1C - Roland

2A - Amanda

2C - Sherika

3A - Manuel


#Model 1A


# Files

RCP2 Google Drive: https://drive.google.com/drive/u/0/folders/1jq6iQiYgzQZM_vS_k2oiDlvyB5u-ywwW
Phase 1's GitHub repo is <a href link="https://github.com/DataKind-DC/smoke_alarm_models">here</a>.
