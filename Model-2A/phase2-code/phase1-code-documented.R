
# if the pacman package is not installed, install it, load it
# and load the other packages as well
if (!require("pacman")) install.packages("pacman")
pacman::p_load(data.table, foreign, rgdal, rgeos, maptools)
# file path for originals file path
# project_data = 'data/'
# external_data = 'e:/data/'

# 
# a function which takes in the year of interest and returns the number of structure fires per 1k
# this output is saved as an R object to be used for the map that is created later
#
# input: data_year is a numeric
# output: not returned, but a saved R object
#
structure_fire_per_1k = function(data_year){
  
  # loads the R data containing the formatted addresses
  # data has 21 columns, variables including state, incident date, zip code, and address
  address = fread("./2013_formated_addresses.csv")
  
  #loads the R data containing the geocoded addresses
  # data has 13 columns, variables including longitude and latitude, county, and address
  geocoded_address = fread("./2013_geocoded_addresses.csv")
  
  # address type comes from the formatted address data
  # this line of code gives how many of each address type
  table(address$address_type)
  
  # load basic incident data -- basic incidents are any incidents the fire department is called for,
  # not necessarily resulting in fire
  # data has 10 columns, variables including ALARM, ARRIVAL, INC_DATE
  basic_incident = fread("./basicincident.txt", sep = "^")
  
  # loads fire incident data -- calls that did have a fire
  # data has 20 variables, including incident data, incident year, street, zip code, and address
  fire_incident = fread("./NFIRS_FireIncidents.csv")
  
  # determine a list of tracts that are contained in the data
  tracts_covered = unique(geocoded_address[, tractid])
  
  # save the results in some folder called results because it's needed for estimating NFIRS coverage.
  saveRDS(tracts_covered, file = paste0('results/', data_year, '_tracts_covered.rds'))
  
  # determines which fire incidents were building fires based on the NFIRS code 111
  building_fire = fire_incident[basic_incident[,grep('111',INC_TYPE)]]
  
  # orders the address data by these variables
  setkey(address, STATE, FDID, INC_DATE, INC_NO, EXP_NO)
  
  # determines the addresses of the incidents that actually have fires
  
  building_fire_address = address[basic_incident[,grep('111', INC_TYPE)]]
  
  # sets row_seq as the key
  setkey(building_fire_address, row_seq)
  setkey(geocoded_address, row_seq)
  
  # determine the geocoded addresses (the non-empty ones) of the building fires
  building_fire_address_geocoded = geocoded_address[building_fire_address][!is.na(row_seq)]
  
  # sorts by tract id and adds columns that counts the addresses within an ID??  That is, by_tract determines the number of incidents in a particular 'tract'
  by_tract = building_fire_address_geocoded[, .N, by = tractid][!is.na(tractid)]
  setkey(by_tract, N)
  
  # save by_tract for later use in some folder called results
  saveRDS(by_tract, file = paste0('results/', data_year, '_building_fire_per_1k.rds'))
  
  # reads in the census data
  tract_census_2010 = data.table(read.dbf("./Tract_2010Census_DP1.dbf", as.is = TRUE))
  
  # sorts by tractid
  setkey(by_tract, tractid)
  
  # sorts by GEOID10
  setkey(tract_census_2010, GEOID10)
  
  # this renames the variable DP0010001 to population
  setnames(tract_census_2010, 'DP0010001', 'population')
  
  # creates a subset of the census data
  # determines which GEOID10 rows in tract_census_2010 are in by_tract
  tract_census_selected = merge(by_tract, tract_census_2010, by.x = 'tractid', by.y = 'GEOID10' )
  
  # creates a new variable called fire_per_1000, which is calculated by the number of building fires in tract and divides by population, then multiply by 1000
  tract_census_selected[, fire_per_1000 := (N/population) * 1000]
  
  # creates a new variable called id, which puts the id 1400000US in the rows with
  # the tractid
  tract_census_selected[, id := paste0('1400000US', tractid)]
  
  # removes the populations less than 100
  tract_census_selected_normal_population = tract_census_selected[population > 100, 
                                                                  .(tractid, id, N, population,fire_per_1000)]
  
  # needed for map
  saveRDS(tract_census_selected_normal_population, file = paste0('results/', data_year, '_tract_population_fire.rds'))
  write.csv(tract_census_selected_normal_population, file = paste0('results/', data_year, '_tract_building_fire_per_1k.csv'))
}

# runs the function above for each year 2009 - 2013
# creating tract information in different files
for(year in 2009:2013){
  structure_fire_per_1k(year)
}

# not needed for this particular script
# the originals used the following block in an RMarkdown file, so
# perhaps the separated code blocks needed this again

# if (!require("pacman")) install.packages("pacman")
# pacman::p_load(data.table)
# project_data = 'data/'
# external_data = 'e:/data/'
# combined version

# I just didn't run this block of code because I don't have the data for all years

# tracts_covered_all_years = vector()
# creates a list of the tract info for all years
# for(year in 2009:2013){
  # the tracts covered data was created in the previous function
  # tracts_covered_all_years = c(tracts_covered_all_years, 
  #                            readRDS(paste0('results/', data_year, '_tracts_covered.rds')))
# }
# tracts_covered_all_years_unique = unique(tracts_covered_all_years)

tracts_covered_all_years_unique = unique(tracts_covered)
# read in census data
tracts_census_national = fread("./us2010trf.txt", sep = ",", header = FALSE)

# I add from https://www2.census.gov/geo/pdfs/maps-data/data/rel/tractrelfile.pdf
colnames(tracts_census_national) = c('STATE00','COUNTY00','TRACT00','GEOID00','POP00','HU00','PART00','AREA00','AREALAND00','STATE10','COUNTY10','TRACT10','GEOID10','POP10','HU10','PART10','AREA10','AREALAND10','AREAPT','AREALANDPT','AREAPCT00PT','AREALANDPCT00PT','AREAPCT10PT','AREALANDPCT10PT','POP10PT','POPPCT00','POPPCT10','HU10PT','HUPCT00','HUPCT10')

# sets the key to be GEOID10, and then keeps the unique rows based on GEOID10
setkey(tracts_census_national, GEOID10)
tracts_census_national = unique(tracts_census_national)

# now we add all population of those entries with the same STATE10
states_population = tracts_census_national[, sum(POP10), by = STATE10]

# rename that new data to be total population in the state
setnames(states_population, 'V1', 'total_population')

# determines which entries in the census data is also in the fire tract data
covered_tracts = tracts_census_national[GEOID10 %in% tracts_covered_all_years_unique,]

# total number of the population  covered by the fire guys
states_population_covered = covered_tracts[, sum(POP10), by = STATE10]
setnames(states_population_covered, 'V1', 'covered_population')
setkey(states_population, STATE10)
setkey(states_population_covered, STATE10)

# produces a table this gives us the total population for a state and the population 
# covered by the fire guys
states_coverage = merge(states_population, states_population_covered)
# creates a new column called coverage which produces a proportion/percentage for coverage
states_coverage[, coverage := covered_population / total_population]

#states_county_fips = fread(paste0(external_data, 'TIGER/national_county.txt'), colClasses=list(character=c('STATEFP', 'COUNTYFP')))

states_county_fips = fread("./national_county.txt", sep = ",", header = FALSE)
# these column names are obtained from https://www.census.gov/geo/reference/codes/cou.html
colnames(states_county_fips) = c("STATE", "STATEFP", "COUNTYFP", "COUNTYNAME", "CLASSFP")

setkey(states_county_fips, STATEFP)
# determines the unique pairs of STATE and STATEFP
# states_fips = unique(states_county_fips)[, .(STATE, STATEFP)]
states_fips = unique(states_county_fips[, .(STATE, STATEFP)])

setnames(states_fips,'STATEFP', 'STATE10')
setkey(states_fips, STATE10)
# merges the data containing total population and covered population for a state 
# with the fips information
states_coverage = merge(states_coverage, states_fips)
# saves data for the map
write.csv(states_coverage, file = 'results/states_coverage.csv')
