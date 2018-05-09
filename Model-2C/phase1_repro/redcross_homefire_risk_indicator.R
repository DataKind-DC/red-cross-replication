#############################################################################
# redcross_homefire_risk_indicator.R 
#     Phase 2 Code Reproduction, 2018
#     
#     This code adds census tract data to the home fires dataset and
#     generates "risk indicators". Given how the code was originally written,
#     tract information was added to the home fires CSV prior to this script.
#     However, there is no indication of where this may have occured.
#############################################################################

# Clear workspace
rm(list = ls())

# Load libraries
library('readr')
library('plyr')
library('dplyr')
library('ggplot2')
library('gdata')

# Navigate to directory containing R-scripts, store directories in variables
code_folder <- getwd()
ROOT_dir <- dirname(code_folder)
data_folder <- paste(ROOT_dir,'/data', sep = '')
output_folder <- paste(ROOT_dir,'/phase1_output/geocodes', sep = '')

# Set working directory
setwd(code_folder)



# Load home fires CSV that was created in RC_homefire_per_tract_risk_indicator.R
# PReviously named 2009-2014_RedCross_HomeFire_Cases.csv
redcross_homefire_cases <- read.csv(paste(data_folder,"/redcross_homefires_cases.csv",sep=''),
                                    stringsAsFactors = FALSE,
                                    header = TRUE,
                                    na = NA)

# Load census data
census_df <- read.csv(paste(ROOT_dir,"/phase1_output/2009-2014_Homefire_geo.csv",sep=''),
                                    stringsAsFactors = FALSE,
                                    header = TRUE,
                                    na = NA)

# Add tract data to home fire cases df
if('tract' %in% colnames(redcross_homefire_cases)){
      print('tract exists in dataframe')
} else{
      redcross_homefire_cases$tract <- NA
      for(i in 1:dim(census_df)[1]){
        idx = census_df$id[i]
        redcross_homefire_cases$tract[idx] <- census_df$tract[i]
      }
      write.csv(redcross_homefire_cases,
                paste(ROOT_dir,'/phase1_output/redcross_homefires_cases_tract.csv',sep=''),
                row.names = FALSE)
}


# tract
redcross_homefire_cases$tract

# order data
redcross_homefire_cases_orderedtracts <- redcross_homefire_cases[order(redcross_homefire_cases$tract),]
redcross_homefire_cases_orderedtracts_dates <- redcross_homefire_cases_orderedtracts[order(redcross_homefire_cases_orderedtracts$incident_disaster_date),]
redcross_homefire_cases[1:20,]

# aggregate data - number of cases per tract and day
aggregated_homefire_data1 <- aggregate(redcross_homefire_cases$num_case, by=list(redcross_homefire_cases$tract, redcross_homefire_cases$incident_disaster_date),FUN=sum)
aggregated_homefire_data <- aggregated_homefire_data1

# aggregate data - number of cases per tract
aggregated_homefire_data3 <- aggregate(redcross_homefire_cases$num_case, by=list(redcross_homefire_cases$tract),FUN=sum)
aggregated_homefire_data3$x

# risk indicator 1 - number of cases per tract and day
homefire_risk_indicator1 <- aggregated_homefire_data$x

# where there are no gaps in cases
which((aggregated_homefire_data[,3]=="NA")==FALSE)
nrow(aggregated_homefire_data) # 6832
nrow(data.frame(which((aggregated_homefire_data[,3]=="NA")==FALSE))) # 6811
num_na <- nrow(aggregated_homefire_data) - nrow(data.frame(which((aggregated_homefire_data[,3]=="NA")==FALSE)))
num_na # 21 NA

# risk indicator 2 - number of cases per tract
homefire_risk_indicator2 <- aggregated_homefire_data3$x

# rename risk indicator variable names
aggregated_homefire_data <- rename.vars(aggregated_homefire_data,"x","risk_indicator")
names(aggregated_homefire_data)
aggregated_homefire_data3 <- rename.vars(aggregated_homefire_data3,"x","risk_indicator")
names(aggregated_homefire_data3)

# write to csv
write.csv(aggregated_homefire_data, paste(ROOT_dir,"/phase1_output/homefire_risk_indicator1.csv",sep=''))
write.csv(aggregated_homefire_data3, paste(ROOT_dir,"/phase1_output/homefire_risk_indicator3.csv",sep=''))
