##############################################################################
# GET_GEOCODES.R
#
# Phase 2 Replication, 2018
# S. Sylvester
#
# This script reverse geocodes lat-long coordinates to find census tracts.
# The overall approach finds the tract polygons for each lat-long coordinate
# and extracts census tract and block information from state tract shapefiles.
# Coordinates that were not localized to a tract in a state shapefile were
# reverse geocoded using the Phase 1 API technique.
#
# Inputs:
#     FTP TIGER/LINE shapefile, state census tract2010:
#         "ftp://ftp2.census.gov/geo/tiger/TIGER2010/TRACT/2010/"
#         Downloaded by the code below
#
#     State FIPs code, state_FIPs_codes.txt:
#         https://www.census.gov/geo/reference/ansi_statetables.html
#         under "National FIPS and GNIS Codes File" tab
#         Manually downloaded and saved as a TXT file
#
#     2009-2014_RedCross_DisasterCases.csv
#         Downloaded from Phase 1 data folder in the DKDC RC Google Drive
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
data_folder <- "~/Documents/DKDC_RC/rcp2_repo/Model-2C/data"
output_folder <- "~/Documents/DKDC_RC/rcp2_repo/Model-2C/phase2/output"

# Load in data sets
state_fips <- read.table(paste(data_folder,"/state_FIPs_codes.txt",sep = ''), header = TRUE, sep = "|")
redcross_disaster_cases <- read.csv(paste(data_folder,"/2009-2014_RedCross_DisasterCases.csv",sep=''), stringsAsFactors = FALSE)
dataset_state_list <- unique(redcross_disaster_cases$esri_state)

# Build URLs for census.gov FTPing
base_url <- "ftp://ftp2.census.gov/geo/tiger/TIGER2010/TRACT/2010/"
sf_names <- c()
url <- c()
counter <- 1
for (abbrev in dataset_state_list){
  if (abbrev %in% state_fips$STUSAB){
    idx <- which(state_fips$STUSAB == abbrev)
    fips_temp <- state_fips$STATE[idx]
    sf_names[counter] <- paste("tl_2010_",sprintf("%02d", fips_temp),"_tract10.zip", sep = '')
    url[counter] <- paste(base_url,sf_names[counter], sep = '')
    counter <- counter + 1
  }
}

# Check to see if shapefiles folder exists, create if missing
if ('shapefiles_tract' %!in% dir(data_folder)){
    dir.create(file.path(data_folder, 'shapefiles_tract'))
}

# Download shapefiles for each state. There is some hang time/ timeouts
# occassionally. This occurs when loading in the browser also timeouts,
# so this is a FTP/ web hosting problem and not a code problem. Just
# restart loop every time it crashes...which happens often
for (i in 1:length(url)){
    if (sf_names[i] %!in% dir(paste(data_folder,'/shapefiles_tract',sep=''))){
      download.file(url[i],paste(data_folder,'/shapefiles_tract/',sf_names[i],sep = ''),mode = "wb")
      unzip(paste(data_folder,'/shapefiles_tract/',sf_names[i],sep=''),
            exdir = paste(data_folder,'/shapefiles_tract',sep=''))
    }
}

# Append fips code to df
redcross_disaster_cases$state_fips <- NA
for (abbrev in dataset_state_list){
    idx_rc <- which(redcross_disaster_cases$esri_state == abbrev)
    idx_fips <- which(state_fips$STUSAB == abbrev)
    if ((length(idx_rc > 0)) & (length(idx_fips) > 0)){
        fips_temp <- state_fips$STATE[idx_fips]
        redcross_disaster_cases$state_fips[idx_rc] <- fips_temp
    }
}

# Find tract via intersection of spatial dataframes, blocked by state
# 2 minutes
start_time <- tic()
redcross_disaster_cases$COUNTYFP <- NA
redcross_disaster_cases$TRACTCE <- NA
redcross_disaster_cases$GEOID <- NA
redcross_disaster_cases$NAME <- NA
redcross_disaster_cases$NAMELSAD <- NA
redcross_disaster_cases$MTFCC <- NA
redcross_disaster_cases$FUNCSTAT <- NA
fips_list <- unique(redcross_disaster_cases$state_fips)
fips_list <- fips_list[which(!is.na(fips_list), arr.ind = TRUE)]
for (fips in fips_list){
    idx <- which((redcross_disaster_cases$state_fips == fips)
                 & (!is.na(redcross_disaster_cases$esri_latitude_x))
                 & (!is.na(redcross_disaster_cases$esri_longitude_x)),
                 arr.ind = TRUE)
    if (length(idx) > 0){
        # Load shapefile
        filename_ <- paste("tl_2010_",sprintf("%02d", fips),"_tract10.shp", sep = '')
        s_temp <- shapefile(paste(data_folder,'/shapefiles_tract/',filename_,sep=''))
        
        # Make lat-long coords into sf object/ spatial dataframe
        temp_df <- redcross_disaster_cases[idx,c('esri_longitude_x','esri_latitude_x','esri_state')]
        temp_df$index <- idx
        coordinates(temp_df) <- ~esri_longitude_x+esri_latitude_x
        proj4string(temp_df) <- proj4string(s_temp)
        
        # Join spatial dataframes to find point & polygon intersections
        joined_df <- over(temp_df,s_temp)
        
        # Add census data to RC dataframe
        redcross_disaster_cases$COUNTYFP[idx] <- joined_df$COUNTYFP10
        redcross_disaster_cases$TRACTCE[idx] <- joined_df$TRACTCE10
        redcross_disaster_cases$GEOID[idx] <- joined_df$GEOID10
        redcross_disaster_cases$NAME[idx] <- joined_df$NAME10
        redcross_disaster_cases$NAMELSAD[idx] <- joined_df$NAMELSAD10
        redcross_disaster_cases$MTFCC[idx] <- joined_df$MTFCC10
        redcross_disaster_cases$FUNCSTAT[idx] <- joined_df$FUNCSTAT10
    }
}
toc(start_time)



# Find entries with lat-longs != NA & TRACT == NA
# Add census data via API approach
# n = 1590, 3 minutes
idx_remaining <- which((is.na(redcross_disaster_cases$TRACTCE))
             & (!is.na(redcross_disaster_cases$esri_latitude_x))
             & (!is.na(redcross_disaster_cases$esri_longitude_x)),
             arr.ind = TRUE)
tract     <- c()
geoType   <- c()
stateFips <- c()
name      <- c()

for (idx in idx_remaining){
    lat <- redcross_disaster_cases$esri_latitude_x[idx]
    long <- redcross_disaster_cases$esri_longitude_x[idx]
    url <- paste0("http://www.broadbandmap.gov/broadbandmap/census/tract?latitude=",
                  lat,"&longitude=",long,"&format=xml")
    
    # Create XML node
    x <- read_xml(url)
    
    # Parse XML
    doc <- xmlTreeParse(x)
    
    # Extract geo data
    if(length(xml_find_all(x,".//message")) == 1){
        # no census, node contains <message>No Census Tract results found</message>
        # make geo variables NA if reverse geocoding fails
        tract     <- c(tract,NA)
        geoType   <- c(geoType,NA)
        stateFips <- c(stateFips,NA)
        name      <- c(name,NA)
      } else{
        tract     <- c(tract,xmlSApply(xmlRoot(doc)[[1]][[1]], xmlValue)[['fips']])
        geoType   <- c(geoType,xmlSApply(xmlRoot(doc)[[1]][[1]], xmlValue)[['geographyType']])
        stateFips <- c(stateFips,xmlSApply(xmlRoot(doc)[[1]][[1]], xmlValue)[['stateFips']])
        name      <- c(name,xmlSApply(xmlRoot(doc)[[1]][[1]], xmlValue)[['name']])
      }
}

# Add API data to dataframe
redcross_disaster_cases$tract_api <- NA
redcross_disaster_cases$geoType_api <- NA
redcross_disaster_cases$stateFips_api <- NA
redcross_disaster_cases$name_api <- NA
redcross_disaster_cases$tract_api[idx_remaining] <- tract
redcross_disaster_cases$geoType_api[idx_remaining]  <- geoType
redcross_disaster_cases$stateFips_api[idx_remaining]  <- stateFips
redcross_disaster_cases$name_api[idx_remaining]  <- name

# Write dataframe to CSV
write.csv(redcross_disaster_cases,
          file = paste(output_folder,"/2009_2014_RedCross_DisasterCases_with_census_data.csv", sep = ""),
          row.names = FALSE,
          na = "")