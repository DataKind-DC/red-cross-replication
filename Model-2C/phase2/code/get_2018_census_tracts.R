##############################################################################
# GET_CENSUSTRACT.R
#
# Red Cross Fire Alarm Phase 2, New Data, 2018
# S. Sylvester
#
# This script is an exact copy of get_censustract.R, except it used 2018 
# Census tract shape files (instead of 2010) and does not call the
# Broadband map API to fill in missing rows. The inputs are also new coded
# addresses from NFIRS 2009-2016 using the Census API (GET_COORDINATES.R).
#
# This script reverse geocodes lat-long coordinates to find census tracts.
# The overall approach finds the tract polygons for each lat-long coordinate
# and extracts census tract and block information from state tract shapefiles.
#
# Inputs:
#     State-based TIGER/LINE shapefile, state census tract 2018:
#         Link to download found here: https://www.census.gov/geo/maps-data/data/tiger-line.html
#         List of FTP links (downloaded by code below): "ftp://ftp2.census.gov/geo/tiger/TIGER2018/TRACT/"
#         **WARNING** Connection to server often times out. Add a try/catch to attempt download again if
#               download fails
#
#     State FIPs code, state_FIPs_codes.txt:
#         https://www.census.gov/geo/reference/ansi_statetables.html
#         under "National FIPS and GNIS Codes File" tab
#         Manually downloaded and saved as a TXT file
#
#     coordinates_chunk#_idx_#_#.csv
#         Coordinates from NFIRS 2009-2016 using the Census API (see GET_COORDINATES.R)
#
# Outputs:
#     2009_2014_RedCross_DisasterCases_with_census_data.csv
#         The original case data (2009-2014_RedCross_DisasterCases.csv) with
#         census data as additional columns.
#############################################################################

# Clear workspace
rm(list = ls())

# Load libraries
library(tictoc)
library(xml2)
library(XML)
library(sf)
library(raster)

# Build "NOT IN" function
'%!in%' <- function(x,y)!('%in%'(x,y))

# Set directories
data_folder <- "~/Documents/DKDC_RC/data"
#output_folder <- "~/Documents/DKDC_RC/repo_v2/Model-2C/phase2/output"

# Load in data sets
state_fips <- read.table(paste(data_folder,"/state_FIPs_codes.txt",sep = ''), header = TRUE, sep = "|", stringsAsFactors = F)
df <- read.csv("~/Documents/DKDC_RC/data/master_fire_incidents_location.csv",stringsAsFactors = F)
df <- df[which(df$ID != ""),]

temp <- strsplit(df$ORIGINAL_ADDRESS,",")
temp <- unlist(lapply(temp, function(x) x[length(x)-1]))
df$STATE <- trimws(temp)
dataset_state_list <- state_fips$STUSAB
#dataset_state_list <- unique(trimws(df$MATCHED_STATE))
#dataset_state_list <- dataset_state_list[nchar(dataset_state_list)==2 & !is.na(dataset_state_list)]

# Build URLs for census.gov FTPing
base_url <- "ftp://ftp2.census.gov/geo/tiger/TIGER2018/TRACT/"
sf_names <- c()
url <- c()
counter <- 1
for (abbrev in dataset_state_list){
  if (abbrev %in% state_fips$STUSAB){
    idx <- which(state_fips$STUSAB == abbrev)
    fips_temp <- state_fips$STATE[idx]
    sf_names[counter] <- paste("tl_2018_",sprintf("%02d", fips_temp),"_tract.zip", sep = '')
    url[counter] <- paste(base_url,sf_names[counter], sep = '')
    counter <- counter + 1
  }
}

# Check to see if shapefiles folder exists, create if missing
if ('shapefiles_tract_2018Census' %!in% dir(data_folder)){
    dir.create(file.path(data_folder, 'shapefiles_tract_2018Census'))
}

# Download shapefiles for each state. There is some hang time/ timeouts
# occassionally. May download manually since that is faster
for (i in 1:length(url)){
    if (sf_names[i] %!in% dir(paste(data_folder,'/shapefiles_tract_2018Census',sep=''))){
      download.file(url[i],paste(data_folder,'/shapefiles_tract_2018Census/',sf_names[i],sep = ''),mode = "wb")
      unzip(paste(data_folder,'/shapefiles_tract_2018Census/',sf_names[i],sep=''),
            exdir = paste(data_folder,'/shapefiles_tract_2018Census',sep=''))
    }
}

# Append fips code to df
df$state_fips <- NA
for (abbrev in dataset_state_list){
    idx_rc <- which(df$STATE == abbrev)
    idx_fips <- which(state_fips$STUSAB == abbrev)
    if ((length(idx_rc > 0)) & (length(idx_fips) > 0)){
        fips_temp <- state_fips$STATE[idx_fips]
        df$state_fips[idx_rc] <- fips_temp
    }
}

# Find tract via intersection of spatial dataframes, blocked by state
# 8 minutes
start_time <- tic()
df$COUNTYFP <- NA
df$TRACTCE <- NA
df$GEOID <- NA
df$NAME <- NA
df$NAMELSAD <- NA
df$MTFCC <- NA
df$FUNCSTAT <- NA
fips_list <- unique(df$state_fips)
fips_list <- fips_list[which(!is.na(fips_list), arr.ind = TRUE)]

# MN and MO shapefiles are corrupted. will use 2010 shapefiles instead
for (fips in fips_list[!fips_list %in% c(27,29)]){
    idx <- which((df$state_fips == fips)
                 & (!is.na(df$X))
                 & (!is.na(df$Y)),
                 arr.ind = TRUE)
    if (length(idx) > 0){
        # Load shapefile
        filename_ <- paste("tl_2018_",sprintf("%02d", fips),"_tract.shp", sep = '')
        s_temp <- shapefile(paste(data_folder,'/shapefiles_tract_2018Census/',filename_,sep=''))
        
        # Make lat-long coords into sf object/ spatial dataframe
        temp_df <- df[idx,c('X','Y','STATE')]
        if(fips == 27){
          idx <- idx[1:25100]
          temp_df <- df[idx,c('X','Y','STATE')]
        }
        if(fips == 29){
          idx <- idx[1:37000]
          temp_df <- df[idx,c('X','Y','STATE')]
        }
        temp_df$index <- idx
        coordinates(temp_df) <- ~X+Y
        proj4string(temp_df) <- proj4string(s_temp)
        
        # Join spatial dataframes to find point & polygon intersections
        joined_df <- over(temp_df,s_temp)
        
        # Add census data to RC dataframe
        df$COUNTYFP[idx] <- joined_df$COUNTYFP
        df$TRACTCE[idx] <- joined_df$TRACTCE
        df$GEOID[idx] <- joined_df$GEOID
        df$NAME[idx] <- joined_df$NAME
        df$NAMELSAD[idx] <- joined_df$NAMELSAD
        df$MTFCC[idx] <- joined_df$MTFCC
        df$FUNCSTAT[idx] <- joined_df$FUNCSTAT
    }
}
toc(start_time)

write.csv(df,"~/Documents/DKDC_RC/data/master_geocoded_census.csv",row.names = F)
