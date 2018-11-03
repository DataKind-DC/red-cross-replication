##############################################################################
# GET_COORDINATES.R
#
# Phase 2 New Data, 2018
# S. Sylvester
#
# This code segements the NFIRS 2009-2016 data file into chunks of 10k
# addresses. It then calls the Census Geocoder API to extract the
# latitude and longitude from Census.
#
# Inputs:
#     NFIRS 2009 - 2016.txt
#
# Outputs:
#     chunked_NFIRS_addresses_idx [directory]
#           NFIRS_addresses_chunk#_idx_#_#.csv
#           Contains NFIRS addresses, in 10k chunks
#     chunked_NFIRS_coordinates [directory]
#           coordinates_chunk#_idx_#_#.csv
#           coordinates_chunk#_idx_#_#.RData
#           Contains lat-long coordinates from Census API
#
# Total time: Tens of hours.
#############################################################################

# Clear workspace
rm(list = ls())

# Load libraries
library(httr)
library(jsonlite)

# Disable scientific notation
options(scipen=999)

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
df$date_edit <- as.Date(df$inc_date, "%m/%d/%Y")

# Create chunking indexes
chunk_start <- seq(1,dim(df)[1],10000)
chunk_end <- c(tail(chunk_start, -1) - 1, dim(df)[1])

# Chunk save path
chunk_save_path <- file.path(data_folder,"chunked_NFIRS_addresses_idx")

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
    chunk_name <- paste0("NFIRS_addresses_chunk",i,"_idx_",chunk_start[i],"_",chunk_end[i],".csv")
    df_chunk <- df[chunk_start[i]:chunk_end[i],c("street","city","state","zip5")]
    row.names(df_chunk) <- paste0("rcp2_id",chunk_start[i]:chunk_end[i])
    write.table(df_chunk,paste(chunk_save_path,chunk_name,sep = "/"), sep = ",",  col.names=FALSE)
    print(paste("Chunk", i, "out of", length(chunk_nums),"complete...", round(Sys.time() - tic,2),sep = " "))
  }
}
Sys.time() - tic

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
#apiurl <- "https://geocoding.geo.census.gov/geocoder/geographies/addressbatch"
apiurl <- "https://geocoding.geo.census.gov/geocoder/locations/addressbatch"

# Create save path for geocodes & Census information
coordinates_save_path <- file.path(data_folder,"chunked_NFIRS_coordinates")

# Create folder for geocode & Census data if one doesn't exist
if(!dir.exists(coordinates_save_path)){
  dir.create(coordinates_save_path)
}

convert_to_raw <- function(raw_content) {
  out <- tryCatch(
    {
      rawToChar(raw_content)
    },
    error=function(cond) {
      message(paste("Unable to convert the results from",
                    paste0("chunk",i),
                    "to char"))
      message("Original error message:")
      message(cond)
      return(NA)
    },
    warning=function(cond) {
      message(paste(paste0("chunk",i),
                    "caused a warning..."))
      message("Original warning message:")
      message(cond)
      # Choose a return value in case of warning
      #return(NULL)
    },
    finally={
      message(paste("Converted raw results to char for",paste0("chunk",i)))
    }
  )    
  return(out)
}


# only 2014-2016
start_chunk <- min(which(chunk_start >= min(which(df$date_edit >= "2000-01-01")))) - 1
chunk_suffixes <- start_chunk : length(chunk_start)
chunk_suffixes <- chunk_suffixes[chunk_suffixes != 0]

if(length(list.files(coordinates_save_path)) != 2*length(chunk_start)){
    # Make a list of chunks that are missing
    #file_list <- list.files(geocode_save_path, pattern = "*chunk.*RData")
    file_list <- list.files(coordinates_save_path, pattern = "chunk")
    chunk_nums <- unique(sub(".csv","",sub(".RData","",sub("coordinates_chunk", "", file_list))))
    chunk_nums <- setdiff(1:length(chunk_start),chunk_nums)
    chunk_nums <- chunk_nums[which(chunk_nums %in% chunk_suffixes)]
  
    chunked_addresses <- list.files(chunk_save_path)
    file_info <- file.info(list.files(chunk_save_path, full.names = T))
    chunked_addresses <- chunked_addresses[order(file_info$ctime)]
    
    for(i in chunk_nums[45:length(chunk_nums)]){
        tic <- Sys.time()
        coordinates_save_name <- paste0("coordinates_chunk",i)
        print(paste("Processing",paste0("NFIRS_addresses_chunk",i,".csv"),"..."))
        req <- POST(apiurl,
                    body = list(addressFile = upload_file(paste(chunk_save_path,chunked_addresses[i],sep="/")),
                                benchmark = "Public_AR_Current")) #16min
        #req <- POST(apiurl,
        #            body = list(addressFile = upload_file(paste(chunk_save_path,chunked_addresses[i],sep="/")),
        #                        benchmark = "Public_AR_Census2010"))
        Sys.time() - tic
        save(req, file = paste(coordinates_save_path,"/",coordinates_save_name,"REQ.RData",sep = ""))
        
        temp0 <- convert_to_raw(req$content)
        
        if(!is.na(temp0)){
          # Save raw data as RDATA-file
          save(temp0, file = paste(coordinates_save_path,"/",coordinates_save_name,".RData",sep = ""))
          
          temp <- strsplit(temp0,"\n")[[1]]
          temp <- strsplit(temp,",")
          temp <- plyr::ldply(temp, rbind)
          temp <- as.data.frame(gsub('"', "", as.matrix(temp)), stringsAsFactors = F)
          
          # Column for extra stuff if address line is split into 2
          colnames(temp) <- c("ID","ORIGINAL_STREET","ORIGINAL_CITY","ORIGINAL_STATE","ORIGINAL_ZIPCODE",
                              "MATCH","MATCH_TYPE",
                              "MATCHED_STREET","MATCHED_CITY","MATCHED_STATE","MATCHED_ZIPCODE",
                              "X","Y","TIGER_LINE_ID","TIGER_LINE_SIDE","EXTRA")[1:dim(temp)[2]]
          save(temp, file = paste(coordinates_save_path,"/",coordinates_save_name,"_df.RData",sep = ""))
          write.csv(temp, file = paste(coordinates_save_path,"/",coordinates_save_name,".csv",sep = ""), row.names = F)
          
          print(paste("Saved",coordinates_save_name,"RData| Chunk", i, "out of",
                      length(chunk_nums),"complete...", round(Sys.time() - tic,2),sep = " "))
        }else{
          print(paste("SKIPPED",coordinates_save_name,"RData| Chunk", i, "out of",
                      length(chunk_nums),"...", round(Sys.time() - tic,2),sep = " "))
        }
    }
}