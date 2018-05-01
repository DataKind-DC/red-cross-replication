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

#### **Model Results Comparison**

The GitHub site for the original project (https://github.com/home-fire-risk/smoke_alarm_models/tree/master/model_1b_nfirs_smokealarm_pres/Output) shows four output files.

1. tract_data_weigted_linear_preds
2. tract_data_weighted_linear_preds_upsampled
3. tracts_74k_weighted_linear_preds
4. tracts_74k_weighted_linear_preds_upsampled

The code, however, only outputs two of the files - the ones with "upsampled" in the file name. To validate the results from replicating the code, I compared the two output files from the replicated code to it's two corresponding output files from the original results.

The tract_data_weighted_linear_preds_upsampled output from the replicated code does not match the original tract_data_weighted_linear_preds_upsampled nor the original tract_data_weigted_linear_preds output file.

The tracts_74k_weighted_linear_preds_upsampled output from the replicated code matches nearly dead on with the original tracts_74k_weighted_linear_preds and nearly matches the original tracts_74k_weighted_linear_preds_upsampled output file.


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
5. Which output file is which? Why does the 74k match while the small sample does not? Why does the new upsampled 74k file match the non-upsampled 74k file and only mostly match the upsampled 74k file? Is something misnamed?
