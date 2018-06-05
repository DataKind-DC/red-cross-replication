** June 4, 2018 Data Jam

Model 1A- Judy verified that the replication matches Phase 1. 

Model 1B - Vicki checked replication, match

Model 1C - Minh and others could not figure out how final csv file was created, no R script? Minh then found the code from Enigma and has made progress on how to replicate the smoke-alarm-risk-scores.csv file that is used in the aggregate model. He will confirm this is the case with Roland.

Model 2A- Lauren verfied that the replication matches Phase 1. 

Model 2C- Sherika and Daniel worked on it, issue with replicating jittering & comparing output data

Model 3A- Did not attempt work here, Sherika asked Jake about input data

Next steps: 

1. Get updated data for Models 1A, 1B, 2A

2. Continue replication of Models 1C, 2C, 3A



**Meeting Notes 5/31
Discussed
<br>

1)	Got the aggregate model code to run, but are unable to match the counties to Red Cross Chapters. However, there are considerable differences in results. Many possible issues:
<br>

a.	3A: we’re using old input file
<br>

b.	2C: due to jittering the lat lons for privacy, the results are likely different. Currently using old input file.
<br>

c.	Not convinced the code for each model is the actual code run at the time of the original model because the team has had to make extensive edits to get the code to run
<br>

d.	Not convinced the output data available on GitHub are the correct/data used in the original, and some of the data files are just missing

2)	3A is not replicable. The code relies on data files that no longer exist, but we have contacted the original creator to see if we can get the dat.

3)	2C is not fully replicable because of the jittering of lat lons used to protect privacy. We do not have code that indicates the random seed used to jitter. 11.5% of census tracts from the original (phase 1) output have different frequencies in phase 1 replicated output. Phase 1 replicated output files are too large for Github, so they are in the Google Drive.

Tasks to get done:
1)	Put original output files into the aggregate model code. Check differences between original output file and the results from this output (Roland)

2)	3A outputs – if possible. Talk with Nick (Original author)


Meeting Notes 6/4 (Data Jam)
