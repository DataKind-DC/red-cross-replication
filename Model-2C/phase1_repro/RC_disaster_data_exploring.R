#############################################################################
# RC_disaster_data_exploring.R 
#     Phase 2 Code Reproduction, 2018
#     This file generates basic summary statistics on the Red Cross disaster
#     cases data. The summary statistics are saved as a TXT-file in the
#     data folder.
#
#     This file is not needed for Phase 2 analysis and does not seem to be
#     used in any other analysis in phase 1.
#
#     Most values in the summary stats file are the same. There is some
#     gitter across a few values, but the differences are small.
#############################################################################

# Clear workspace
rm(list=ls())

# Load packages
library(readr)
library(plyr)
library(dplyr)
library(ggplot2)
library(stargazer)

# Navigate to directory containing R-scripts, store directories in variables
code_folder <- getwd()
ROOT_dir <- dirname(code_folder)
data_folder <- paste(ROOT_dir,'/data', sep = '')
output_folder <- paste(ROOT_dir,'/phase1_output', sep = '')

# Set working directory
setwd(code_folder)

# Load in data as dataframe
# Can also run with a subset: 2009-2014_RedCross_DisasterCases_sample.csv
rc_disaster_data <- read.csv(paste(data_folder,"/2009-2014_RedCross_DisasterCases.csv",sep=''), stringsAsFactors = FALSE)

# Convert columns in old output summary stats to numeric.
# Strings are converted to NA automatically.
# If skip this step, summary stargazer summary will only include lat & long data since they are of dtype numeric
columnNames <- c("incident_disaster_fiscal_year","chapter_code","pre_zip_5_digit","num_clients","num_cases_w_fin_assist",           
                  "age_5_or_under_num","age_62_to_69_num","age_6_to_61_num","age_over_69_num","female_num","male_num",
                  "gender_undeclared_num","afro_american_num","native_american_num","asian_num","caucasian_num","hispanic_num",
                  "ethnicity_undeclared_num","esri_longitude_x","esri_latitude_x","esri_zip") 
for(i in 1:length(columnNames)){
  rc_disaster_data[columnNames[i]] <- as.numeric(unlist(rc_disaster_data[columnNames[i]]))
}

# Examine the top of the dataframe
head(rc_disaster_data)

# Outputs summary statistics on data, saves as txt file
stargazer(rc_disaster_data, type = "text", median = TRUE, iqr = TRUE,
          out = paste(output_folder,"/rc_disaster_summary_stats.txt", sep = ''))

summary(rc_disaster_data)