#############################################################################
# RC_disaster_data_responses_per_region.R
#     Phase 2 Code Reproduction, 2018
#     This file explores the frequency of Red Cross cases across different
#     geographical regions (Red Cross regions & states). Two figures are
#     produced (but are not stored in /output).
#
#     There are no figures in Phase 1 Github to compare these results to.
#############################################################################

# Clear workspace
rm(list=ls())

# Load packages
library(readr)
library(plyr)
library(dplyr)
library(ggplot2)
#library(stringr)

# Navigate to directory containing R-scripts, store directories in variables
code_folder <- getwd()
ROOT_dir <- dirname(code_folder)
data_folder <- paste(ROOT_dir,'/data', sep = '')
output_folder <- paste(ROOT_dir,'/phase1_output', sep = '')

# Set working directory
setwd(code_folder)

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
columnNames <- c("incident_disaster_fiscal_year","chapter_code","pre_zip_5_digit","num_clients","num_cases_w_fin_assist",           
                 "age_5_or_under_num","age_62_to_69_num","age_6_to_61_num","age_over_69_num","female_num","male_num",
                 "gender_undeclared_num","afro_american_num","native_american_num","asian_num","caucasian_num","hispanic_num",
                 "ethnicity_undeclared_num","esri_longitude_x","esri_latitude_x","esri_zip") 
for(i in 1:length(columnNames)){
  rc_disaster_data[columnNames[i]] <- as.numeric(unlist(rc_disaster_data[columnNames[i]]))
}


# Count the number of times a case number appears in the dataset
rc_disaster_data %>% group_by(case_num) %>%
  summarise(number = n()) %>% arrange(desc(number))

# Examine the results from select case numbers
filter(rc_disaster_data, case_num == "1-78233518")
filter(rc_disaster_data, case_num == "1-78202007")

# Count number of cases per "region"
region_cases <- rc_disaster_data %>% 
  group_by(region_name) %>%
  summarise(number_cases = length(unique(case_num))) %>%
  as.data.frame() %>%
  arrange(desc(number_cases))

# Examine the first 10 rows
head(region_cases, 10)

# Reorder factors for plotting
region_cases$region_name = factor(region_cases$region_name,
                               levels = region_cases[order(region_cases$number_cases, decreasing = FALSE),1])

# Plot the number of cases for each region
p1 <- ggplot(region_cases,aes(x = region_name, y = number_cases))
p1 <- p1 + geom_point() + coord_flip()
p1 <- p1 + ylab('Count') + xlab('Region Name') + ggtitle("Number of Cases for Each Red Cross Region")
p1



# Count number of cases per state-county
county_cases <- rc_disaster_data %>% 
  group_by(primary_affected_state, primary_affected_county) %>%
  summarise(number_cases = length(unique(case_num))) %>%
  as.data.frame() %>%
  arrange(desc(number_cases))

head(county_cases, 10)


# Count number of cases per zipcode
zipcode_cases <- rc_disaster_data %>% 
  group_by(esri_zip) %>%
  summarise(number_cases = length(unique(case_num))) %>%
  as.data.frame() %>%
  arrange(desc(number_cases))

head(zipcode_cases, 10)


# Count number of cases per state
state_cases <- rc_disaster_data %>% 
  group_by(esri_state) %>%
  summarise(number_cases = length(unique(case_num))) %>%
  as.data.frame() %>%
  arrange(desc(number_cases))

head(state_cases, 10) # 61425 + 41 missing a state

state_cases_nonmissing <- filter(state_cases, !is.na(esri_state),
                                esri_state != "") %>%
                                mutate(esri_state = factor(esri_state))

# reorder factors for plotting
state_cases_nonmissing$esri_state <- factor(state_cases_nonmissing$esri_state,
                                  levels = state_cases_nonmissing[order(state_cases_nonmissing$number_cases, decreasing = FALSE),1])

# Plot number of cases per state
p2 <- ggplot(state_cases_nonmissing, aes(x = esri_state, y = number_cases))
p2 <- p2 + geom_point() + coord_flip()
p2 <- p2 + ylab('Count') + xlab('State') + ggtitle("Number of Cases for Each State")
p2