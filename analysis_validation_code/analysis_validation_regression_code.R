analysis_data<-read.csv("~/Github/Data-Management-Final-Project-Agbim/data/clean_data/analysis_data_v1.csv",na.strings ="NA",header = TRUE )

#make histogram
#first load ggplot
library(ggplot2)
qplot(analysis_data$lmi_burdenx100,
      geom = "histogram",
      binwidth=3,
      fill=I("blue"),
      main="Texas Low-Moderate Income Energy Burden",
      xlab="Burden (%of Income Spent)",
      ylab="Frequency")

#Need to do correlation matix to check
#only want to check correlation in column 3 to 15
cor(analysis_data[4:15])#pairs
pairs(analysis_data[4:15])#pairs hard to read
cor(analysis_data[sapply(analysis_data,is.numeric)],use = "complete.obs")#successful
#linear regression using analysis data
lm_analysis<-lm(formula=lmi_burdenx100~.-X-fip-cnty,data=analysis_data)
#Checking for variance inflation factor 1-4 means low multicollinearity. 5 and higher are a cause for concern
library(car)
vif(lm_analysis)
#VIF high for pcnt_hisp and food_insec
summary(lm_analysis)

#ugly output. instead use rmarkdown
#first load package memisc
library(memisc)

#then create a mtable of analysis summary
analysis_tbl<-mtable('Analysis Summary'=lm_analysis,
                     summary.stats = c('R-squared','F-statistic','p-value')) #failed
library(pander) # failed

pander(analysis_tbl) #failed
#run another lm w analysis data. leave out pcnt_hisp, b/c it had the highest VIF in th first model

lm_analysis2<-lm(formula=lmi_burdenx100~.-X.1-X-fip-cnty-pcnt_hisp_ucb,data = analysis_data)
vif(lm_analysis2)
summary(lm_analysis2)

#read in validation data
validation_data<-read.csv("~/Github/Data-Management-Final-Project-Agbim/data/clean_data/validation_data_v1.csv",na.strings ="NA",header = TRUE )

lm_validation<-lm(formula=validation_data$lmi_burdenx100~.-X-fip-cnty,data=validation_data)

summary(lm_validation)


#there's an error in output
str(validation_data)
#the datatypes are different
#change own,lw_access,obese,and uninsured to num

validation_data$pcnt_own_chr<-as.numeric(validation_data$pcnt_own_chr)
validation_data$pcnt_lw_access_chr<-as.numeric(validation_data$pcnt_lw_access_chr)
validation_data$pcnt_obese_chr<-as.numeric(validation_data$pcnt_obese_chr)
validation_data$pcnt_uninsured_chr<-as.numeric(validation_data$pcnt_uninsured_chr)

str(validation_data)
#run again

lm_validation<-lm(formula=validation_data$lmi_burdenx100~.-fip-cnty,data=validation_data)

summary(lm_validation)

cor(validation_data$pcnt_obese_chr,validation_data$pcnt_pov_saipe)

cor(validation_data$pcnt_obese_chr,validation_data$pcnt_lw_access_chr)