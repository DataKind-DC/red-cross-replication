## Differences between these results and the Phase 1 results for this model.

The 2010 formatted address input data doesn’t contain a column called address_type.  This is required in line 28 of phase2-code/phase1-code-documented.R.  
Therefore, the output in states_coverage.csv here is not the same as the originals.  In addition to the *_tract_building_fire_per_1k.csv files,
states_coverage.csv relies on the data files

    national_county.txt
    us2010trf.txt

These files could not be found in the originals Google folder (at least not by these names), so we had to find them online at https://www2.census.gov/geo/docs/reference/codes/files/ 
and https://www2.census.gov/geo/docs/maps-data/data/rel/trf_txt/, respectively.  This could also be producing a different result.

The differences in proportion of coverage is relatively large, according to the measure below.

Accuracy of states_coverage.csv: 

A 5.4% difference for the covered population of the states (calculated by ||ours - theirs||_2 / ||theirs||_2)
A 14% difference for the proportion of coverage (calculated by ||ours - theirs||_2/||theirs_2)
