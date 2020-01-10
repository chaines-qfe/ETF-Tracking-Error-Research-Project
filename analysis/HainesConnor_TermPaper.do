//Term Paper - Connor Haines 
//The Effect of Market Structure and Geography on US-Listed ETF Tracking
//Errors 

//This do-file executes the regressions used in my term paper

clear all

//Import data file
import excel "C:\Users\chaines\Documents\HainesConnor_TermPaper\HainesConnor_Stata.xlsx", sheet("Sheet1") firstrow 

//set time series 
tsset ETFcode Period

//Test for heteroskedasdicity in equations (6)
xtgls TE EMdummy Expense Spread Volume Dividend FX EMexp EMspread EMvol EMdiv EMfx, igls panels(heteroskedastic)
estimates store hetero
xtgls TE EMdummy Expense Spread Volume Dividend FX EMexp EMspread EMvol EMdiv EMfx
local df = e(N_g) - 1
lrtest hetero . , df(`df')

//test for autocorrelation 
//Must install xtserial if not already installed; use (fndit xtserial)
xtserial TE EMdummy Expense Spread Volume Dividend FX EMexp EMspread EMvol EMdiv EMfx

//same tests for equation (7)
xtgls TE Asiadummy Americasdummy Expense Spread Volume Dividend FX asiaexp amerexp asiaspread amerspread asiavol amervol asiadiv amerdiv, igls panels(heteroskedastic)
estimates store hetero
xtgls TE Asiadummy Americasdummy Expense Spread Volume Dividend FX asiaexp amerexp asiaspread amerspread asiavol amervol asiadiv amerdiv
lrtest hetero . , df(`df')
xtserial TE Asiadummy Americasdummy Expense Spread Volume Dividend FX asiaexp amerexp asiaspread amerspread asiavol amervol asiadiv amerdiv


//I use the computational method developed by Driscoll Kaay (1998) to deal with autocorrelation and heteroskedacticity. Additionally, this corrects for cross dectional dependence (which a STATA test exists for - xtcsd - but which my version of STATA cannot set a large enough Mat size to measure. Nonetheless, prevoius literature suggests I should be concerned about cross sectional dependence, and when I tested for it on a different version of STATA I came up as having cross sectiona dependence)
//Install Computational Method
ssc install xtscc

//Run Regressions used in paper for equation (6) 
xtscc TE EMdummy Expense Spread Volume Dividend FX EMexp EMspread EMvol EMdiv EMfx
xtscc TE Expense 
xtscc TE Spread 
xtscc TE Volume 
xtscc TE Dividend 
xtscc TE FX
xtscc TE EMdummy Expense Spread Volume Dividend FX EMexp EMspread EMvol EMdiv EMfx
//I predict and store residuals from this last regression (this can easily be editted to store residuals for other regressions as well)
predict residuals
gen residuals1=residuals
drop residuals

//Run Regressions used in paper for equation (7) 
xtscc TE Asiadummy Americasdummy 
xtscc TE Asiadummy Americasdummy Expense Spread Volume Dividend FX 
xtscc TE Asiadummy Americasdummy Expense Spread Volume Dividend FX asiaexp amerexp asiaspread amerspread asiavol amervol asiadiv amerdiv
//I predict and store residuals from this last regression (this can easily be editted to store residuals for other regressions as well)
predict residuals

