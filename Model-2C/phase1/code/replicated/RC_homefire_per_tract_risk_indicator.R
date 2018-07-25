#############################################################################
# RC_homefire_per_tract_risk_indicator.R
#     Phase 2 Code Reproduction, 2018
#     This file uses an API to find the census tract & block for each lat-long
#     coordinate in the data set. The geo data are saved to CSV files in
#     in chunks.
#############################################################################

# Clear workspace
rm(list = ls())

# Load packages
library('xml2')
library('XML')
library('httr')
library('base')
#library('rjson')
library('foreach')
library('doMC')
library('data.table')
library('plyr')



# Set directories
data_folder <- "~/Documents/DKDC_RC/rcp2_repo/Model-2C/data"
output_folder <- "~/Documents/DKDC_RC/rcp2_repo/Model-2C/phase1/output/replicated"
code_folder <- "~/Documents/DKDC_RC/rcp2_repo/Model-2C/phase1/code/replicated"

# Set working directory
setwd(code_folder)



# Load in data as dataframe
# Can also run with a subset: 2009-2014_RedCross_DisasterCases_sample.csv
redcross_disaster_cases <- read.csv(paste(data_folder,"/2009-2014_RedCross_DisasterCases.csv",sep=''), stringsAsFactors = FALSE)

# Convert columns in old output summary stats to numeric.
# Strings are converted to NA automatically.
columnNames <- c("incident_disaster_fiscal_year","chapter_code","pre_zip_5_digit","num_clients","num_cases_w_fin_assist",           
                 "age_5_or_under_num","age_62_to_69_num","age_6_to_61_num","age_over_69_num","female_num","male_num",
                 "gender_undeclared_num","afro_american_num","native_american_num","asian_num","caucasian_num","hispanic_num",
                 "ethnicity_undeclared_num","esri_longitude_x","esri_latitude_x","esri_zip") 
for(i in 1:length(columnNames)){
  redcross_disaster_cases[columnNames[i]] <- as.numeric(unlist(redcross_disaster_cases[columnNames[i]]))
}

print(paste("Total number of rows:",nrow(redcross_disaster_cases)))

# Find home fire cases, store in variable
redcross_homefire_cases <- redcross_disaster_cases[redcross_disaster_cases$event_type_old_categories == "Fire : Multi-Family" | redcross_disaster_cases$event_type_old_categories == "Fire : Single Family" | redcross_disaster_cases$event_type_old_categories == "Fire",]

# lat/lon coordinates = esri_latitude_x and esri_longitude_x 
redcross_homefire_cases$esri_latitude_x[1:5]
redcross_homefire_cases$esri_longitude_x[1:5]

# Save homefires dataframe to csv for manual examination
write.csv(redcross_homefire_cases,
          file = paste(output_folder,'/redcross_homefires_cases.csv',sep = ''),
          row.names = FALSE,
          na = "")


# Function to convert lat-long coordinates to census block using API
coord_to_censusblock <- function(lat, long, id_ = NULL, out = 'geocodes.csv', overwrite = T, progress = T){
  # Set up progress bar
  pb <- txtProgressBar(min=min(id_), max=max(id_), initial=0, char="=", style=3)
  
  for(i in unlist(id_)){
    #print(paste("num:",i))
    if(is.na(lat[i])!=TRUE&&is.na(long[i])!=TRUE) {
      # Build URL for API
      url <- paste0("http://www.broadbandmap.gov/broadbandmap/census/tract?latitude=",
                    lat[i],"&longitude=",long[i],"&format=xml")
      
      # Create XML node
      x <- read_xml(url)
      
      # Parse XML
      doc <- xmlTreeParse(x)
      
      # Extract geo data
      if(length(xml_find_all(x,".//message")) == 1){
        # no census, node contains <message>No Census Tract results found</message>
        # make geo variables NA if reverse geocoding fails
        tract     <- "NA"
        geoType   <- "NA"
        stateFips <- "NA"
        name      <- "NA"
      } else{
        tract     <- xmlSApply(xmlRoot(doc)[[1]][[1]], xmlValue)['fips']
        geoType   <- xmlSApply(xmlRoot(doc)[[1]][[1]], xmlValue)['geographyType']
        stateFips <- xmlSApply(xmlRoot(doc)[[1]][[1]], xmlValue)['stateFips']
        name      <- xmlSApply(xmlRoot(doc)[[1]][[1]], xmlValue)['name']
      }
      
      # Create dataframe with geo data
      ret <- data.frame(i, lat[i], long[i], tract, geoType, stateFips, name)
      
      # Write add ret to CSV
      write.table(ret, file = out, sep = ",",  col.names = FALSE, row.names = FALSE, append = TRUE)
      
      # Update progress bar
      setTxtProgressBar(pb, i)
    }
  }
}

# Set up for parallel processing
numCores <- detectCores()
registerDoMC(cores = numCores)

# Grouping indexes of dataframe rows into chunks for block processing, n = 100 chunks
ids <- split(1:nrow(redcross_homefire_cases), cut(1:nrow(redcross_homefire_cases), 100, labels=FALSE))

# Find the census block for each lat-long pairing for all rows in each chunk
# Process bar only displays if you run each chunk individually (e.g. foreach(i = idx[90]))
# Stops at id[90], geocodes_413105_417745.csv, remaining rows are NA
system.time(
  foreach(i = ids) %dopar%
    coord_to_censusblock(redcross_homefire_cases$esri_latitude_x,
                         redcross_homefire_cases$esri_longitude_x,
                         id = i,
                         out = sprintf('%s/geocodes/geocodes_%s_%s.csv', output_folder, min(i), max(i)))
)



# get list of .csvs geocoded above w foreach
filenames <- paste(output_folder,'geocodes',
                   list.files(paste(output_folder,'geocodes',sep = '/'), pattern='.csv'),
                   sep='/')

# Combine all CSV files into one dataframe
counter = 1
for(file_ in filenames){
  if(counter == 1){
    combined_geocodes <- read.csv(file_, stringsAsFactors = FALSE, header = FALSE)
  } else{
    temp_df <- read.csv(file_, header = FALSE, stringsAsFactors = FALSE)
    combined_geocodes <- rbind(combined_geocodes, temp_df)
    rm(temp_df)
  }
  counter = counter + 1
}

# Change column names
names(combined_geocodes) <- c('id', 'Latitude', 'Longitude', 'tract','geoType','stateFips','name')

# Write dataframe to CSV
write.csv(combined_geocodes,
          paste(output_folder,'2009-2014_Homefire_geo.csv',sep='/'),
          row.names = FALSE)

homefire_geo <- read.csv(paste(output_folder,'2009-2014_Homefire_geo.csv',sep='/'))
nrow(redcross_homefire_cases) - nrow(homefire_geo) # old: 59336 missing, new: 49503 missing
fires_per_tract <- count(homefire_geo$tract)
write.csv(fires_per_tract, paste(output_folder,'fires_per_tract.csv',sep='/'))
