# Model 1B: Replication

### *This document outlines Model 1B of the DataKind, DC Chapter, Red Cross Fire Injury and Death Prevention project. It also tracks quesitons about the model and notes coding changes and/or modifications.*


#### **Model Data Sources**

Model 1b uses the American Community Survey and NFIRS data. The original team blended 2009-2013 NFIRS data (code available in Model-1B/phase1-code/nfirs_data_blending.py) and merged this with Enigma's ACS-AHS blended database.

#### **Language and Packages Used**

**Python:** pandas, numpy, scipy, sklearn (linearl_model, cross_validation (now called mode_selection), pre_proecessing, metrics) math

**R:** (for NFIRS data blending only)

#### **Model Target Variable**

Model 1B target variable is the percent of fire incidents within a region that didn't have ANY smoke detectors.

#### **Model Type**

Model 1b first utilizes scikitlearn's train test split logic to train a linear model, minimizing error with stochastic gradient descent, or SGD. The weights are developed using a subset of the data (ALL_FIRE_ALL_YEARS >= 25), whilst the full model uses both the subset and the full dataset. The weights calculated for the model are calculated as a scaled weight - where by each observation on ALL_FIRE_ALL_YEARS is divided by the maximum observation of ALL_FIRE_ALL_YEARS.

#### **Code Notes**

* The package sklearn.cross_validation produces a deprication warning. Should update to sklearn.model_selection
* Mac versus PC: converting the tractid variables to an integer should use astype(int) for Mac and astype('int64') for PC to avoid errors
* (More to come)

#### **Running List of Questions**

1. Why did the previous team filter for ALL_FIRE_ALL_YEARS>25 for the training subset?
2. Why did the previous team use Stochastic Gradient Descent with a linear model?
  * What other models were discussed?
  * Why squared loss?
  * Why scaled weighting?
3. Did the team get a sense of how many observations were dropped due to issues with the data (such as tractid joins), if any?
4. Why were numbers imputed based on the mean value?
  * Were other options discussed?
  * What are the theoretical implications of using the mean?
  * Is this an appropriate strategy for all columns?
