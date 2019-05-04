analysis_data1<-read.csv("~/Github/Data-Management-Final-Project-Agbim/data/clean_data/analysis_data_v1.csv",na.strings ="NA",header = TRUE )

#make histogram
#first load ggplot
library(ggplot2)
qplot(analysis_data1$lmi_burdenx100,
      geom = "histogram",
      binwidth=3,
      fill=I("blue"),
      main="Texas Low-Moderate Income Energy Burden",
      xlab="Burden (%of Income Spent)",
      ylab="Frequency")

#Need to do correlation matix to check
#only want to check correlation in column 3 to 15
cor(analysis_data1[4:15])#pairs
pairs(analysis_data1[4:15])#pairs hard to read
cor(analysis_data1[sapply(analysis_data1,is.numeric)],use = "complete.obs")#successful
#linear regression using analysis data
lm_analysis1<-lm(formula=lmi_burdenx100~.-X-fip-cnty,data=analysis_data1)
#Checking for variance inflation factor 1-4 means low multicollinearity. 5 and higher are a cause for concern
library(car)
vif(lm_analysis1)
#VIF high for pcnt_hisp and food_insec
summary(lm_analysis1)

#ugly output. instead use rmarkdown
#first load package memisc
library(memisc)

#then create a mtable of analysis summary
analysis_tbl<-mtable('Analysis Summary'=lm_analysis1,
                     summary.stats = c('R-squared','F-statistic','p-value')) #failed
library(pander) # failed

pander(analysis_tbl) #failed
#run another lm w analysis data. leave out pcnt_hisp, b/c it had the highest VIF in th first model

lm_analysis2<-lm(formula=lmi_burdenx100~.-X-fip-cnty-pcnt_hisp_ucb,data = analysis_data1)
vif(lm_analysis2)
summary(lm_analysis2)

#read in validation data
validation_data1<-read.csv("~/Github/Data-Management-Final-Project-Agbim/data/clean_data/validation_data_v1.csv",na.strings ="NA",header = TRUE )

lm_validation1<-lm(formula=validation_data$lmi_burdenx100~.-X-fip-cnty,data=validation_data1)

summary(lm_validation1)
vif(lm_validation1)

#if there's an error in output
str(validation_data1)
#check the datatypes are different
#change own,lw_access,obese,and uninsured to num

validation_data1$pcnt_own_chr<-as.numeric(validation_data1$pcnt_own_chr)
validation_data1$pcnt_lw_access_chr<-as.numeric(validation_data1$pcnt_lw_access_chr)
validation_data1$pcnt_obese_chr<-as.numeric(validation_data1$pcnt_obese_chr)
validation_data1$pcnt_uninsured_chr<-as.numeric(validation_data1$pcnt_uninsured_chr)

str(validation_data1)
#run again without pcnt_hisp

lm_validation2<-lm(formula=validation_data$lmi_burdenx100~.-pcnt_hisp_chr-fip-cnty,data=validation_data1)

summary(lm_validation2)
vif(lm_validation2)
cor(validation_data1$pcnt_obese_chr,validation_data1$pcnt_pov_saipe)

cor(validation_data1$pcnt_obese_chr,validation_data1$pcnt_lw_access_chr)

#HERE STARTS THE ADDITION OF THE DUMMY VAR "BRDR_CNTY"

analysis_data_dum1<-read.csv("~/Github/Data-Management-Final-Project-Agbim/data/clean_data/analysis_data_dum_v1.csv",na.strings = "NA",header=TRUE)
view(analysis_data_dum1)
str(analysis_data_dum1)
#change brd_cnty to a categorical variable again
analysis_data_dum1$lmi_burdenx100<-as.factor(analysis_data_dum1$brdr_cnty)
#run linear regression
lm_analysis_dum1<-lm(formula=validation_data$lmi_burdenx100~.-X.1-X-fip-cnty,
                      data=analysis_data_dum1)
summary(lm_analysis_dum1)
#Check VIF 
vif(lm_analysis_dum1)
#Remove pcnt_hisp to create a new model
lm_analysis_dum2<-lm(formula=validation_data$lmi_burdenx100~.-X.1-X-fip-cnty-pcnt_hisp_ucb,
                     data=analysis_data_dum1)
summary(lm_analysis_dum2)

#Check VIF for analysis_dum2
vif(lm_analysis_dum2)

#to check robustness website: https://www.statmethods.net/stats/rdiagnostics.html