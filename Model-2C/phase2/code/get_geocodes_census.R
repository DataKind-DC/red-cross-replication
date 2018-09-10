##############################################################################
# GET_GEOCODES.R
#
# Phase 2 New Data, 2018
# S. Sylvester
#
# This code segements the NFIRS 2009-2016 data file into chunks of 10k
# addresses. It then calls the Census Geocoder API to extract the
# latitude, longitude, Census Tract, Census Block, county FIPS, & state
# FIPS form Census.
#
# Inputs:
#     NFIRS 2009 - 2016.txt
#
# Outputs:
#     chunked_NFIRS_addresses [directory]
#           NFIRS_addresses_chunk#.csv
#           Contains NFIRS addresses, in 10k chunks
#     chunked_NFIRS_geocodes [directory]
#           geocodes_chunk#.csv
#           geocodes_chunk#.RData
#           Contains addresses, lat-long coordinates, & Census data from
#               Census API
#
# Total time: Tens of hours.
#############################################################################

# Clear workspace
rm(list = ls())

# Load libraries
library(httr)
library(jsonlite)

# Set directories
data_folder <- "~/Documents/DKDC_RC/data"
new_data_filename <- "NFIRS 2009 - 2016.txt"
new_path <- "Phase 2 Data and Additional Resources/NFIRS Data (Phase 2)"
new_data_path <- paste(data_folder,new_path,new_data_filename, sep = "/")
csv_path <- paste(data_folder,new_path,"NFIRS_2009_2016.csv", sep = "/")


#################################################################################################
# Chunk NFIRS 2009-2016 addresses & restructure
#   The Census Geocoder allows up to 10k addresses at a time. Chunk NFIRS data frame
#   into chunks of size 10k. First check if a chunk exists. If it does not exist, chunk
#   the NFIRS data frame appropriately, restructure, and save as a CSV-file.
#
#   The Geocoder allows batch processing of addresses stored in a CSV-file in a specific
#   format (commas denote seperate column):
#           UNIQUE ID, ADDRESS, CITY, STATE, ZIPCODE
#           1,4600 Silver Hill Rd,Suitland,MD,20746
#################################################################################################

# Convert NFIRS data set to a CSV-file if it doesn't exist
if(!file.exists(csv_path)){
  df <- read.delim(new_data_path, sep = ",")
  write.csv(df,paste(data_folder,new_path,"NFIRS_2009_2016.csv", sep = "/"))
}else{
  df <- read.csv(paste(data_folder,new_path,"NFIRS_2009_2016.csv", sep = "/"))
}

# Create chunking indexes
chunk_start <- seq(1,dim(df)[1],10000)
chunk_end <- c(tail(chunk_start, -1) - 1, dim(df)[1])

# Chunk save path
chunk_save_path <- file.path(data_folder,"chunked_NFIRS_addresses")

# Create folder for chunked addresses if it doesn't exist
if(!dir.exists(chunk_save_path)){
  dir.create(chunk_save_path)
}

# Chunk
tic <- Sys.time()
if(length(list.files(chunk_save_path)) != length(chunk_start)){
  # Make a list of chunks that are missing
  file_list <- list.files(chunk_save_path, pattern = "chunk")
  chunk_nums <- as.numeric(sub(".csv","",sub("NFIRS_addresses_chunk", "", file_list)))
  chunk_nums <- setdiff(1:length(chunk_start),chunk_nums)
  
  # Chunk main dataframe and save to CSV for chunks that are missing
  # Restructure data frame
  for(i in chunk_nums){
    chunk_name <- paste0("NFIRS_addresses_chunk",i,".csv")
    df_chunk <- df[chunk_start[i]:chunk_end[i],c("street","city","state","zip5")]
    row.names(df_chunk) <- paste0("rcp2_id",chunk_start[i]:chunk_end[i])
    write.table(df_chunk,paste(chunk_save_path,chunk_name,sep = "/"), sep = ",",  col.names=FALSE)
    print(paste("Chunk", i, "out of", length(chunk_nums),"complete...", round(Sys.time() - tic,2),sep = " "))
  }
}


#################################################################################################
# Get Census data via Census Geocoder API
#   For this script, the geocoder API endpoint extracts geographial information as well as
#   approximated latitude & longitude coordinates for addresses. Change the API URL if
#   only coordinates are needed.
#       apiurl <- "https://geocoding.geo.census.gov/geocoder/locations/addressbatch"
#
#   General API information: https://geocoding.geo.census.gov/geocoder/Geocoding_Services_API.pdf
#   Vintages for each benchmark: https://geocoding.geo.census.gov/geocoder/vintages?form
#
#   Benchmark "Public_AR_Current" was used to extract information using the most current
#   Census files.
#################################################################################################

# Store API address
apiurl <- "https://geocoding.geo.census.gov/geocoder/geographies/addressbatch"

# Create save path for geocodes & Census information
geocode_save_path <- file.path(data_folder,"chunked_NFIRS_geocodes")

# Create folder for geocode & Census data if one doesn't exist
if(!dir.exists(geocode_save_path)){
  dir.create(geocode_save_path)
}


if(length(list.files(geocode_save_path)) != 2*length(chunk_start)){
    # Make a list of chunks that are missing
    file_list <- list.files(geocode_save_path, pattern = "*chunk.*csv")
    chunk_nums <- as.numeric(sub(".csv","",sub("geocodes_chunk", "", file_list)))
    chunk_nums <- setdiff(1:length(chunk_start),chunk_nums)
  
    chunked_addresses <- list.files(chunk_save_path)
    
    for(i in chunk_nums){
        tic <- Sys.time()
        
        geocode_save_name <- paste0("geocodes_chunk",
                                    as.numeric(sub(".csv","",sub("NFIRS_addresses_chunk", "", chunked_addresses[i]))))
        data_chunk <- paste(chunk_save_path,chunked_addresses[i], sep = "/")
        req <- POST(apiurl,
                    body = list(addressFile = upload_file(data_chunk),
                                benchmark = "Public_AR_Current",
                                vintage = "Current_Current"))
        Sys.time() - tic #27.6 minutes
        
        temp0 <- rawToChar(req$content)
        
        # Save raw data as RDATA-file
        save(temp0, file = paste(geocode_save_path,"/",geocode_save_name,".RData",sep = ""))
        
        temp0 <- strsplit(temp0,"\n")[[1]]
        temp0 <-strsplit(temp0,'"')
        list_length <- lengths(temp0, use.names = TRUE)
        
        # Process matches
        idx <- which(list_length == max(unique(list_length)))
        temp <- as.data.frame(t(as.data.frame(temp0[idx])))
        row.names(temp) <- c()
        temp <- temp[,seq(2,max(unique(list_length)),2)]
        names(temp) <- c("ID","ADDRESS","MATCH","MATCH_TYPE","MATCHED_ADDRESS","LAT_LONG",
                         "TIGER_LINE_ID","TIGER_LINE_SIDE","STATE_FIPS","COUNTY_FIPS",
                         "CENSUS_TRACT","CENSUS_BLOCK")
        temp_match <- temp
        
        # Process non-matches, fill empty fields with NA
        idx <- which(list_length != max(unique(list_length)))
        temp <- as.data.frame(t(as.data.frame(temp0[idx])))
        row.names(temp) <- c()
        temp <- temp[,seq(2,dim(temp)[2],2)]
        names(temp) <- c("ID","ADDRESS","MATCH")
        temp[,c("MATCH_TYPE","MATCHED_ADDRESS","LAT_LONG",
                "TIGER_LINE_ID","TIGER_LINE_SIDE","STATE_FIPS","COUNTY_FIPS",
                "CENSUS_TRACT","CENSUS_BLOCK")] <- NA
        temp_noMatch <- temp
        
        # Stack matched and non-matched addresses
        temp_complete <- rbind(temp_match,temp_noMatch)
        
        # Save stacked data frame as a CSV-file
        write.csv(temp_complete, file = paste(geocode_save_path,"/",geocode_save_name,".csv",sep = ""))
        print(paste("Saved",geocode_save_name,"| Chunk", i, "out of",
                    length(chunk_nums),"complete...", round(Sys.time() - tic,2),sep = " "))
    }
}
