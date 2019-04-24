analysis_data<-read.csv("~/Github/Data-Management-Final-Project-Agbim/data/clean_data/analysis_data_v1.csv",na.strings ="NA",header = TRUE )

#Need to do correlation matix to check
#only want to check correlation in column 3 to 15
cor(analysis_data[4:15])


#linear regression using analysis data
lm_analysis<-lm(formula=lmi_burdenx100~.-fip-cnty,data=analysis_data)
summary(lm_analysis)

#ugly output. instead use rmarkdown
#first load package memisc
library(memisc)

#then create a mtable of analysis summary
analysis_tbl<-mtable('Analysis Summary'=lm_analysis,
                     summary.stats = c('R-squared','F-statistic','p-value')) #failed
library(pander)

pander(analysis_tbl) #failed