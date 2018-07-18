## Differences between these results and the Phase 1 results for this model.

The 2010 formatted address input data doesn’t contain a column called address_type.  This is required in line 28 of phase2-code/phase1-code-documented.R.  
Therefore, the output in states_coverage.csv here is not the same as the originals.  In addition to the *_tract_building_fire_per_1k.csv files,
states_coverage.csv relies on the data files

    national_county.txt
    us2010trf.txt

These files could not be found in the originals Google folder (at least not by these names), so we had to find them online at https://www2.census.gov/geo/docs/reference/codes/files/ 
and https://www2.census.gov/geo/docs/maps-data/data/rel/trf_txt/, respectively.  This could also be producing a different result.


--- from May 2018 update ---

Accuracy of states_coverage.csv: 

A 5.4% difference for the covered population of the states (calculated by *||ours - theirs||_2 / ||theirs||_2*)
A 14% difference for the proportion of coverage (calculated by *||ours - theirs||_2/||theirs_2*)

--- from July 2018 update ---

In May 2018, model was validated, but resulting data is empty?  When the same code is implemented, do not get results as before but get empty data.  Still working through what the issue is, but have found a "fix".  The July 2018 data is the result.

A few differences in the lines of code may have attributed to result differences.  For example, for 2013_tract_building_fire_per_1k, our replicated results vary by 0.7% from the Original's results according to the relative percentage  

    *||ours - theirs||_2 / ||theirs||_2*.  

For the number of entries that differ, the Original's result is 19 entries longer and only 872 elements are exactly the same (to get the percentage previously stated, the differing elements may be relatively close in value).

**Note**, although the primary code in July 2018 get different *_tract_building_per_1k data, the states_coverage.csv seems to be the same, but different than the Original's states_coverage.csv.
