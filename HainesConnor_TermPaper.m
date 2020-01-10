%%Term Paper - Connor Haines 
%The Effect of Market Structure and Geography on US-Listed ETF Tracking
%Errors 

%This code compiles key statistical data used in my term paper. 

%First, it imports the raw data I compiled from excel. Using this data, it
%creates the relevant variables for my analysis. These variables are
%exported and saved to an excel file called "HainesConnor_Stata" that can be
%imported into STATA and run with the method outlined in the file
%"ReadMe.txt" submitted along with this code. 

%Second, this file creates summary statistics tables and runs the t-tests
%referenced in my paper. These results display in the command window. 


%% Housekeeping
    clear all % clear all variables from memory
    close all % close all figures
    clc % clear command window
   

%% Import Data

%Creae a list of variables in 'sheetname'
[type,sheetname] = xlsfinfo([pwd, '\HainesConnor_TermPaper.xlsx']);
 m=size(sheetname,2);

%create cell matrices to hold data from excel
alldata = cell(1, m); 
dates = cell(1,m);

%import data from excel 
for(i=1:1:m)
Sheet = char(sheetname(1,i)) ;
[alldata{i}, dates{i}] = xlsread([pwd,'\HainesConnor_TermPaper'], Sheet);
end


%% Calculate Variables and Store in Arrays
%Calculate NAV and Index daily returns 
%Use NAV and Index returns to calculate tracking error 
%Take log of volumes 
%Calculate scaled bid-ask spread variable 
%Store each variable in its own array 

%Calculate number of ETF's
N=size(alldata{2},2);

%Calculate NAV and Index daily returns
NAVret=price2ret(alldata{2});
Indexret=price2ret(alldata{3});

%Calculate Tracking Error
TE=abs(NAVret-Indexret); %absolute value of difference between NAV and Index return for each ETF each day
TE1=TE; %store sorted by ETF for some summary statistics 
TE=reshape(TE,[size(TE,1).*size(TE,2),1]); %store as single column for upload to STATA

%Log of Volumes Variable 
Volume=log(alldata{9});
Volume=reshape(Volume,[size(Volume,1).*size(Volume,2),1]); %store as single column for upload to STATA

%Daily Scaled Bid-Ask Spread Variable 
Spread=(alldata{7}-alldata{6})./alldata{8}; %scale so comparable across ETFs
Spread=reshape(Spread,[size(Spread,1).*size(Spread,2),1]); %store as single column for upload to STATA


%Expense Ratio Variable
Expense=reshape(alldata{1},[size(alldata{1},1).*size(alldata{1},2),1]); %single column

%Dividend Variable 
Dividend=reshape(alldata{4},[size(alldata{4},1).*size(alldata{4},2),1]); %single column

%Exchange Rate Variable
FX=reshape(alldata{10},[size(alldata{10},1).*size(alldata{10},2),1]); %single column

%Emeging Market Dummy
EMdummy=reshape(alldata{11},[size(alldata{11},1).*size(alldata{11},2),1]); %single column

%Asia Dummy
Asiadummy=reshape(alldata{12},[size(alldata{12},1).*size(alldata{12},2),1]); %single column

%Americas Dummy
Americasdummy=reshape(alldata{13},[size(alldata{13},1).*size(alldata{13},2),1]); %single column


%% Format Data for Stata (and create interaction terms) 

%create unique identifiers for ETFs
identifiers = dates{1}(1,2:end);
p=1000;
for i=1:size(identifiers,2)
    identifiers{2,i}=p.*i;  %gives each ETF a unique numerical identifer in increments of 1000
end


%add unique ETF identifiers 
ETFcode=[];
for j=1:N
    for i=1:size(Indexret,1)
         ETFcode = [ETFcode; identifiers{2,j}]; %add unique identifiers with corresonding ETF
    end
end

%Create Period Variable (because stata doesn't do well with trading days formatted as dates due to missing values)
Period=reshape(alldata{14},[size(alldata{14},1).*size(alldata{14},2),1]);


%EM interaction terms 
EMexp = EMdummy.*Expense;
EMspread = EMdummy.*Spread;
EMvol = EMdummy.*Volume;
EMdiv=EMdummy.*Dividend;
EMfx=EMdummy.*FX; 

%Geographical Region interaction terms
asiaexp = Asiadummy.*Expense;
asiaspread = Asiadummy.*Spread;
asiavol = Asiadummy.*Volume;
asiadiv=Asiadummy.*Dividend;
asiafx=Asiadummy.*FX; 
amerexp = Americasdummy.*Expense;
amerspread = Americasdummy.*Spread;
amervol = Americasdummy.*Volume;
amerdiv=Americasdummy.*Dividend;
amerfx=Americasdummy.*FX;

%put variables together 
statadata = table(ETFcode, TE, Expense, Spread, Volume, Dividend, FX, EMdummy, Asiadummy, Americasdummy, Period, EMexp, EMspread, EMvol, EMdiv, EMfx, asiaexp, asiaspread, asiavol, asiadiv, asiafx, amerexp, amerspread, amervol, amerdiv, amerfx);

%export to excel 
filename = 'HainesConnor_Stata.xlsx';
writetable(statadata,filename,'Sheet',1,'Range','A1')

clearvars -except N alldata dates Indexret NAVret sheetname TE TE1 Expense Volume Dividend Spread FX EMdummy RegionCategory Asiadummy Americasdummy


%% Descriptive Statistics

%Descriptive Statistics for all TE's by Year 

%Create variables
datearray=[];
datearray=(datenum(dates{1}(2:end,1))); 
TE09=[];
TE10=[];
TE11=[];
TE12=[];
TE13=[];
TE14=[];
TE15=[];

%Loop through TE's and create array of TE's for each year
for j=1:size(TE1,2)
for i=1:size(TE1,1)
    if datearray(i,1) <= 734138
         TE09 = [TE09; TE1(i,j)];
    end
     if (datearray(i,1) <734506 ) && (datearray(i,1) >=734138)
             TE10 = [TE10; TE1(i,j)];
     end
      if (datearray(i,1) < 734871) && (datearray(i,1) >=734506 )
             TE11 = [TE11; TE1(i,j)];
      end
       if (datearray(i,1) < 735236) && (datearray(i,1) >=734871 )
              TE12 = [TE12; TE1(i,j)];
       end
        if (datearray(i,1) < 735601) && (datearray(i,1) >=735236 )
               TE13 = [TE13; TE1(i,j)];
        end
         if (datearray(i,1) < 735966) && (datearray(i,1) >=735601 )
                TE14 = [TE14; TE1(i,j)];
         end
          if datearray(i,1) >=735966
                  TE15 = [TE15; TE1(i,j)];
          end
end
end

%convert to percent 
TE09=TE09.*100;
TE10=TE10.*100;
TE11=TE11.*100;
TE12=TE12.*100;
TE13=TE13.*100;
TE14=TE14.*100;
TE15=TE15.*100;

%eliminate NaN values in order to calculate moments 
TE09(~any(~isnan(TE09), 2),:)=[];
TE10(~any(~isnan(TE10), 2),:)=[];
TE11(~any(~isnan(TE11), 2),:)=[];
TE12(~any(~isnan(TE12), 2),:)=[];
TE13(~any(~isnan(TE13), 2),:)=[];
TE14(~any(~isnan(TE14), 2),:)=[];
TE15(~any(~isnan(TE15), 2),:)=[];

%calculate sample moments 
ss09=[mean(TE09') median(TE09') std(TE09') min(TE09') max(TE09') skewness(TE09',1,2) kurtosis(TE09',1,2)];   
ss10=[mean(TE10') median(TE10') std(TE10') min(TE10') max(TE10') skewness(TE10',1,2) kurtosis(TE10',1,2)];
ss11=[mean(TE11') median(TE11') std(TE11') min(TE11') max(TE11') skewness(TE11',1,2) kurtosis(TE11',1,2)];
ss12=[mean(TE12') median(TE12') std(TE12') min(TE12') max(TE12') skewness(TE12',1,2) kurtosis(TE12',1,2)];
ss13=[mean(TE13') median(TE13') std(TE13') min(TE13') max(TE13') skewness(TE13',1,2) kurtosis(TE13',1,2)];
ss14=[mean(TE14') median(TE14') std(TE14') min(TE14') max(TE14') skewness(TE14',1,2) kurtosis(TE14',1,2)];
ss15=[mean(TE15') median(TE15') std(TE15') min(TE15') max(TE15') skewness(TE15',1,2) kurtosis(TE15',1,2)];

%create table
TEsumstats = [ss09; ss10; ss11; ss12; ss13; ss14; ss15];
names=string({'Mean'; 'Median'; 'Std'; 'Min'; 'Max'; 'Skew'; 'Kurt'});
names=cellstr(names);
names2=string({'2009','2010', '2011', '2012', '2013', '2014', '2015'});
names2=cellstr(names2);
TEsumstats = table(TEsumstats(:,1), TEsumstats(:,2), TEsumstats(:,3), TEsumstats(:,4), TEsumstats(:,5), TEsumstats(:,6), TEsumstats(:,7), 'VariableNames', names, 'RowNames', names2);

%calculate percent TE's that are negative(ie ETF underperformed benchmark) 
TEraw=NAVret-Indexret;
TEraw=reshape(TEraw,[size(TEraw,1).*size(TEraw,2),1]);
TEunder=sum(TEraw<0);
TEunderpercet=TEunder./size(TE,1);

%
%
%
%Descriptive Statistics for TE's by EM or DM 

%Create variables
TEEM=[];
TEDM=[];

%Loop through TE's and create array for each classification
for i=1:size(TE,1)
    if EMdummy(i,1)== 1
         TEEM = [TEEM; TE(i,1)];
    else
        TEDM = [TEDM; TE(i,1)]; 
    end
end

%convert to percent 
TEEM=TEEM.*100;
TEDM=TEDM.*100;


%eliminate NaN values in order to calculate moments 
TEEM(~any(~isnan(TEEM), 2),:)=[];
TEDM(~any(~isnan(TEDM), 2),:)=[];


%calculate sample moments 
ssDM=[mean(TEDM') median(TEDM') std(TEDM') min(TEDM') max(TEDM') skewness(TEDM',1,2) kurtosis(TEDM',1,2)];   
ssEM=[mean(TEEM') median(TEEM') std(TEEM') min(TEEM') max(TEEM') skewness(TEEM',1,2) kurtosis(TEEM',1,2)];

%create table
TEssm = [ssDM; ssEM];
names=string({'Mean'; 'Median'; 'Std'; 'Min'; 'Max'; 'Skew'; 'Kurt'});
names=cellstr(names);
names2=string({'Developed Market','Emerging Market'});
names2=cellstr(names2);
TEssm = table(TEssm(:,1), TEssm(:,2), TEssm(:,3), TEssm(:,4), TEssm(:,5), TEssm(:,6), TEssm(:,7), 'VariableNames', names, 'RowNames', names2);

%2-sample ttest on DM TE's and EM TE's to see if TE's are significantly
%different 
EMtest=ttest2(TEEM, TEDM, 'Alpha', .01); %returns one if different at 1% level

%
%
%
%Descriptive Statistics for TE's by Geographic Region

%Create variables
TEeurope=[];
TEasia=[];
TEamericas=[];

%Loop through TE's and create array for each classification
for i=1:size(TE,1)
    if Asiadummy(i,1)== 1
         TEasia = [TEasia; TE(i,1)];
    end
    if Americasdummy(i,1) == 1
        TEamericas = [TEamericas; TE(i,1)]; 
    end
    if (Asiadummy(i,1) == 0) && (Americasdummy(i,1) == 0)
         TEeurope  = [TEeurope; TE(i,1)];     
    end
end

%convert to percent 
TEeurope=TEeurope.*100;
TEasia=TEasia.*100;
TEamericas=TEamericas.*100;


%eliminate NaN values in order to calculate moments 
TEeurope(~any(~isnan(TEeurope), 2),:)=[];
TEasia(~any(~isnan(TEasia), 2),:)=[];
TEamericas(~any(~isnan(TEamericas), 2),:)=[];

%calculate sample moments 
sseurope=[mean(TEeurope') median(TEeurope') std(TEeurope') min(TEeurope') max(TEeurope') skewness(TEeurope',1,2) kurtosis(TEeurope',1,2)];   
ssasia=[mean(TEasia') median(TEasia') std(TEasia') min(TEasia') max(TEasia') skewness(TEasia',1,2) kurtosis(TEasia',1,2)];
ssamericas=[mean(TEamericas') median(TEamericas') std(TEamericas') min(TEamericas') max(TEamericas') skewness(TEamericas',1,2) kurtosis(TEamericas',1,2)];


%create table
TEssr = [sseurope; ssasia; ssamericas];
names=string({'Mean'; 'Median'; 'Std'; 'Min'; 'Max'; 'Skew'; 'Kurt'});
names=cellstr(names);
names2=string({'Europe','Asia', 'Americas'});
names2=cellstr(names2);
TEssr = table(TEssr(:,1), TEssr(:,2), TEssr(:,3), TEssr(:,4), TEssr(:,5), TEssr(:,6), TEssr(:,7), 'VariableNames', names, 'RowNames', names2);

%2-sample ttests on regions to see if TE's are significantly
%different 
Regiontest1=ttest2(TEeurope, TEasia, 'Alpha', .01); %returns one if different at 1% level
Regiontest2=ttest2(TEeurope, TEamericas, 'Alpha', .01); %returns one if different at 1% level
Regiontest3=ttest2(TEamericas, TEasia, 'Alpha', .01); %returns one if different at 1% level


%
%
%
%Descriptive Statistics for Control Variables

%eliminate NaN values in order to calculate moments 
Expense(~any(~isnan(Expense), 2),:)=[];
Spread(~any(~isnan(Spread), 2),:)=[];
Volume(~any(~isnan(Volume), 2),:)=[];
Dividend(~any(~isnan(Dividend), 2),:)=[];
FX(~any(~isnan(FX), 2),:)=[];
FX=FX.*100; %convert to percent


%calculate sample moments 
ssexpense=[mean(Expense') median(Expense') std(Expense') min(Expense') max(Expense')];   
ssspread=[mean(Spread') median(Spread') std(Spread') min(Spread') max(Spread')];
ssvolume=[mean(Volume') median(Volume') std(Volume') min(Volume') max(Volume')];
ssdividend=[mean(Dividend') median(Dividend') std(Dividend') min(Dividend') max(Dividend')];
ssFX=[mean(FX') median(FX') std(FX') min(FX') max(FX')];


%create table
sscontrol = [ssexpense; ssspread; ssvolume; ssdividend; ssFX];
names=string({'Mean'; 'Median'; 'Std'; 'Min'; 'Max'});
names=cellstr(names);
names2=string({'Daily Expense Ratio','Scaled Bid-Ask Spread', 'Log Volume', 'Dividend Yield', 'FX Change'});
names2=cellstr(names2);
sscontrol = table(sscontrol(:,1), sscontrol(:,2), sscontrol(:,3), sscontrol(:,4), sscontrol(:,5),'VariableNames', names, 'RowNames', names2);


clear vars names names2 ss09 ss10 ss11 ss12 ss13 ss14 ss15 ssexpnese ssspread ssvolume ssdividend ssFX ssamericas ssasia ssDM ssEM sseurope TE09 TE10 TE11 TE12 TE13 TE14 TE15 


%% Display Stats
%this displays results for all tables used in paper with the exception of
%the regression results. Also displays t-test results (returns 1 if sig at
%1% level for market structure and region sample mean comparissons) 


TEsumstats
TEssm 
TEssr 
TEunder 
TEunderpercet
EMtest
Regiontest1
Regiontest2
Regiontest3
sscontrol


