The excel file included in this zip file, “HainesConnor_TermPaper.xlxs” includes the raw data compiled from Blackrock and WRDS used in my research project. 

The matlab file, “HainesConnor_TermPaper.m” takes this raw data and completes two tasks: 

1) It compiles the data for all tables and statistics used in my research paper that are not regression based 
2) It exports and saves an excel file entitled “HainesConnor_Stata”. This includes variables and interaction terms so that they are formatted for use in STATA. 

To execute the regressions used in my paper, either: 

Execute the attached HainesConnor_TermPaper.do file in STATA, 

Or: 

Import HainesConnor_Stata into STATA. Then use the following lines of code (indicated with '--'). 

First, install program for Driscoll and Kaay (1998) computational method:
--ssc install xtscc 

Next, set panel time series:
--tsset ETFcode period

Then, run regressions outlined in paper with the format: 
--xtscc depvar [varlist] 


