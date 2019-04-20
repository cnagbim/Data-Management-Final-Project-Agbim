#The purpose of this script is to merge different datasets into 1 dataset to be used

#The energy burden data from NREL was seperated into three files (see the readme in energy burden folder)
#Therefore we need to merge the files vertically
#Load packages tidyverse

library(tidyverse)
energy_burden_0<-read.csv("~/GitHub/Data-Management-Final-Project-Agbim/data/raw_data/energy_burden_nrel/Energy Burden_Apr 12 2019.csv")

view(energy_burden_0)
#View each dataframe after loading to ensure r read it as a dataframe
energy_burden_1<-read.csv("~/GitHub/Data-Management-Final-Project-Agbim/data/raw_data/energy_burden_nrel/Energy Burden_Apr 12 2019_ 1.csv")
view(energy_burden_1)

energy_burden_2<-read.csv("~/GitHub/Data-Management-Final-Project-Agbim/data/raw_data/energy_burden_nrel/Energy Burden_Apr 12 2019_2.csv")
view(energy_burden_2)
#Column names match. Matching column/var names is required to merge
#check what arguements needed to merge datasets
?rbind()

#merge all energy_burden using rbind function. create new dataframe full_en_burden.

full_en_burden<-rbind(energy_burden_0,energy_burden_1,energy_burden_2)
view(full_en_burden)

#adding binary variable of yes or no energy burdened
#we'll treat the 0.8 as a threshold for energy burdened
#we'll have to calculate it 2x. Once using the LMI burden and the 2nd using nonLMI
full_en_burden$lmi_burdened<-ifelse(full_en_burden$LMI.Energy.Burden>=0.08,1,0)
full_en_burden$notlmi_burdened<-ifelse(full_en_burden$Non.LMI.Energy.Burden>=0.08,1,0)
view(full_en_burden)
#Download the file. Make sure to move it into the data>raw_data>energy_nrel folder
write.csv(full_en_burden,file="energy_burden_tx_full.csv")

#Multiply columns by 100 to ensure we have the same scale (pcnt in whole# instead of deci)
#The scale will be important for analysis later on 
#We're only interested in lmi burden
full_en_burden$lMI_burdenx100<-full_en_burden$LMI.Energy.Burden*100

#Import poverty and income spreadsheet from SAIPE
pov_income_saipe<-read.csv("~/Github/Data-Management-Final-Project-Agbim/data/raw_data/poverty_income_saipe/census_pov_income_tx_full.csv",na.strings = NA,header=TRUE)

#Change the median income variable to be a % of the state median income
#The median income for the state of Texas is $59,195 in 2017
#source: US Census Bureau Small Area Income Poverty Estimate
pov_income_saipe$pcnt_income_saipe<-pov_income_saipe$Median.Household.Income.in.Dollars*(100/59195)

#Import race statistics from US Census Bureau(ucb)
race_ucb<-read.csv("~/Github/Data-Management-Final-Project-Agbim/data/raw_data/race_ACS_17_5YR_/", na.strings = NA,header=TRUE)

