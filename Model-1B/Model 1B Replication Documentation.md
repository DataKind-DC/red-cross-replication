# Model 1B: Replication

### *This document outlines Model 1B of the DataKind, DC Chapter, Red Cross Fire Injury and Death Prevention project. It also tracks quesitons about the model and notes coding changes and/or modifications.*


#### **Model Data Sources**

Model 1b uses the American Community Survey and NFIRS data. The original team blended 2009-2013 NFIRS data and merged this with Enigma's ACS-AHS blended database.

#### **Model Target Variable**

Model 1B target variable is the percent of fire incidents within a region that didn't have ANY smoke detectors.

#### **Model Type**

Model 1b first utilizes scikitlearn's train test split logic to train a linear model, minimizing error with stochastic gradient descent, or SGD. The weights are developed using a subset of the data (ALL_FIRE_ALL_YEARS >= 25 and resampled ALL_FIRE_ALL_YEARS>=50), whilst the full model uses both the subset and the full dataset.
