#############################################################################
# RC_disaster_data_exploring.R 
#     Phase 2 Code Reproduction, 2018
#     This file generates basic summary statistics on the Red Cross disaster
#     cases data. The summary statistics are saved as a TXT-file in the
#     data folder.
#
#     This file is not needed for Phase 2 analysis and does not seem to be
#     used in any other analysis in phase 1.
#############################################################################

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
rc_disaster_data <- read.csv(paste(data_folder,"/2009-2014_RedCross_DisasterCases_sample.csv",sep=''))

# Examine the top of the dataframe
head(rc_disaster_data)

# Outputs summary statistics on data, saves as txt file
stargazer(rc_disaster_data, type = "text", median = TRUE, iqr = TRUE,
          out = paste(output_folder,"/rc_disaster_summary_stats.txt", sep = ''))

summary(rc_disaster_data)













































