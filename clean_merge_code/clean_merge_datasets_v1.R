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
full_en_burden$nonlmi_burdenx100<-full_en_burden$Non.LMI.Energy.Burden*100

#COMEBACK FOLLOW UP AND MAKE 2 HISTOGRAMS
#make histogram of lmi burden
#first load ggplot
library(ggplot2)
qplot(full_en_burden$lMI_burdenx100,
      geom = "histogram",
      binwidth=3,
      fill=I("red"),
      main="Texas Low-Moderate Income Energy Burden",
      xlab="Energy Burden (%of Income Spent)",
      ylab="Frequency")
qplot(full_en_burden$nonlmi_burdenx100,
      geom = "histogram",
      binwidth=1,
      fill=I("blue"),
      main="Texas Non Low-Moderate Income Energy Burden",
      xlab="Energy Burden (%of Income Spent)",
      ylab="Frequency")
#Import poverty and income spreadsheet from SAIPE
pov_income_saipe<-read.csv("~/Github/Data-Management-Final-Project-Agbim/data/raw_data/poverty_income_saipe/census_pov_income_tx_full.csv",na.strings = NA,header=TRUE)

#Change the median income variable to be a % of the state median income
#The median income for the state of Texas is $59,195 in 2017
#source: US Census Bureau Small Area Income Poverty Estimate
pov_income_saipe$pcnt_income_saipe<-pov_income_saipe$Median.Household.Income.in.Dollars*(100/59195)
#Rename ugly columns
pov_income_headers<-c("fips","cnty","pcnt_pov_saipe","income_saipe","pcnt_income_saipe")
names(pov_income_saipe)<-pov_income_headers
view(pov_income_saipe)

#Import race statistics from US Census Bureau(ucb)
race_ucb<-read.csv("~/Github/Data-Management-Final-Project-Agbim/data/raw_data/race_age_census/census_race_TX_full.csv", na.strings = NA,header=TRUE)

#rename the really ugly columns
race_ucb_header<-c("Id_ucb","fip_ucb","cnty_ucb","pcnt_hisp_ucb","pcnt_blk_ucb")
names(race_ucb)<-race_ucb_header

view(race_ucb)

#Import statistics from county health ranking (chr)
chr<-read.csv("~/Github/Data-Management-Final-Project-Agbim/data/raw_data/county_health_ranking/county_health_tx_full.csv", na.strings= NA, header=TRUE)

#Change income to be percent of Texas income like before
#Recall tx median income 59195 in 2017
chr$pcnt_income_chr<-chr$Household.Income*(100/59195)

#Rename ugly variables in chr
chr_header<-c("fip","state","cnty","pcnt_food_insec_chr","pcnt_lw_access_chr","pcnt_uninsured_chr","income_chr","pcnt_own_chr","pcnt_sr_chr","pcnt_blk_chr","pcnt_hisp_chr","pcnt_rural_chr","pcnt_unemp_chr","food_rank_chr","pcnt_obese_chr","pcnt_college_chr","pcnt_income_chr")
names(chr)<-chr_header

#Load bureau labor statistics
bls<-read.csv("~/Github/Data-Management-Final-Project-Agbim/data/raw_data/unemployment_bureau_labor_stats/unemp_bls_tx_jun2017_full.csv",na.strings = NA,header = TRUE)
view(bls)

#rename columns
bls_header<-c("fips","cnty","pcnt_unemp_bls")
names(bls)<-bls_header

#load age data
age_ucb<-read.csv("~/Github/Data-Management-Final-Project-Agbim/data/raw_data/race_age_census/census_age_tx_full.csv",na.strings=NA,header=TRUE)

view(age_ucb)

#rename headers
age_header<-c("fip","cnty","total_sr","total_pop","pcnt_sr_ucb")
names(age_ucb)<-age_header

#load ownership data from census bureau
own_ucb<-read.csv("~/Github/Data-Management-Final-Project-Agbim/data/raw_data/ownership_census/census_pcnt_own_full.csv", na.strings =NA, header=TRUE)
#Rename headers
own_ucb_header<-c("Id_ucb","fip_ucb","cnty_ucb","total_housing","total_own","pcnt_own_ucb")
names(own_ucb)<-own_ucb_header
view(own_ucb)
#change percent to 100 scale instead of decimal
own_ucb$pcnt_own_ucb<-own_ucb$pcnt_own_ucb*100

#load usda data set
usda<-read.csv("~/Github/Data-Management-Final-Project-Agbim/data/raw_data/USDA_foodatlas/usda_TX_full.csv", na.strings = NA, header=TRUE)
view(usda)
#rename headers
usda_header<-c("fip","cnty","pcnt_obese_usda","pcnt_pov_usda","pcnt_lw_access_usda")
names(usda)<-usda_header

#add a control variable: housing age
house_hud<-read.csv("~/Github/Data-Management-Final-Project-Agbim/data/raw_data/year_household_built_HUD/ACS_5YR_Housing_Estimate_Data_by_County.csv",na.strings = "")
#its messy so we'll need to clean it up using tidy verse
library(tidyverse)
house_hud<-filter(house_age_hud,house_age_hud$STATE=="48")

#year built is the median year that households were built in that county
house_age_hud<-data.frame("fip"=house_hud$GEOID,
                          "state"=house_hud$STATE_NAME,
                          "cnty"=house_hud$NAME,
                          "yr_built"=house_hud$B25037EST3)

house_age_hud$str_age<-2019-house_age_hud$yr_built

#FOLLOW UP HERE AND ADD HOUSE STRUC AGE TO BOTH DATA SETS
#All of the spreadsheets have now been loaded
#Create analysis dataframe

analysis_data<-data.frame("fip"=full_en_burden$County.GEOID,
                          "cnty"=full_en_burden$County.Name,
                          "lmi_burdenx100"=full_en_burden$lMI_burdenx100,
                          "pcnt_hisp_ucb"=race_ucb$pcnt_hisp_ucb,
                          "pcnt_blk_ucb"=race_ucb$pcnt_blk_ucb,
                          "pcnt_rural_chr"=chr$pcnt_rural_chr,
                          "pcnt_sr_ucb"=age_ucb$pcnt_sr_ucb,
                          "pcnt_college_chr"=chr$pcnt_college_chr,
                          "pcnt_unemp_bls"=bls$pcnt_unemp_bls,
                          "pcnt_pov_usda"=usda$pcnt_pov_usda,
                          "pcnt_income_saipe"=pov_income_saipe$pcnt_income_saipe,
                          "pcnt_own_ucb"=own_ucb$pcnt_own_ucb,
                          "pcnt_lw_access_usda"=usda$pcnt_lw_access_usda,
                          "pcnt_obese_usda"=usda$pcnt_obese_usda,
                          "pcnt_food_insec_chr"=chr$pcnt_food_insec_chr,
                          "pcnt_uninsured_chr"=chr$pcnt_uninsured_chr,
                          "house_str_age"=house_age_hud$str_age)

validation_data<-data.frame("fip"=full_en_burden$County.GEOID,
                            "cnty"=full_en_burden$County.Name,
                            "lmi_burdenx100"=full_en_burden$lMI_burdenx100,
                            "pcnt_hisp_chr"=chr$pcnt_hisp_chr,
                            "pcnt_blk_chr"=chr$pcnt_blk_chr,
                            "pcnt_rural_chr"=chr$pcnt_rural_chr,
                            "pcnt_sr_chr"=chr$pcnt_sr_chr,
                            "pcnt_college_chr"=chr$pcnt_college_chr,
                            "pcnt_unemp_chr"=chr$pcnt_unemp_chr,
                            "pcnt_pov_saipe"=pov_income_saipe$pcnt_pov_saipe,
                            "pcnt_income_chr"=chr$pcnt_income_chr,
                            "pcnt_own_chr"=chr$pcnt_own_chr,
                            "pcnt_lw_access_chr"=chr$pcnt_lw_access_chr,
                            "pcnt_obese_chr"=chr$pcnt_obese_chr,
                            "food_rank_chr"=chr$food_rank_chr,
                            "pcnt_uninsured_chr"=chr$pcnt_uninsured_chr,
                            "house_str_age"=house_age_hud$str_age)


#checking correlation
#food insecure and food rank
cor(analysis_data$pcnt_food_insec_chr,validation_data$food_rank_chr)

#result says "NA" so lets check for datatype
typeof(analysis_data$pcnt_food_insec_chr)

typeof(validation_data$food_rank_chr)
#they're different types
#check all variables in both dataframes
str(validation_data)
str(analysis_data)

#in analysis_data convert "pcnt_food_insec_chr" and "pcnt_uninsured_chr" to num
analysis_data$pcnt_food_insec_chr<-as.numeric(analysis_data$pcnt_food_insec_chr)
analysis_data$pcnt_uninsured_chr<-as.numeric(analysis_data$pcnt_uninsured_chr)

#in validation_data convert "own_chr", "lw_access", "pcnt_obese_chr", and "uninsured_chr"
validation_data$pcnt_uninsured_chr<-as.numeric(validation_data$pcnt_uninsured_chr)
validation_data$pcnt_own_chr<-as.numeric(validation_data$pcnt_own_chr)
validation_data$pcnt_lw_access_chr<-as.numeric(validation_data$pcnt_lw_access_chr)
validation_data$pcnt_obese_chr<-as.numeric(validation_data$pcnt_obese_chr)

#write the functions
write.csv(x=analysis_data,file="analysis_data_v1.csv")
write.csv(x=validation_data,file="validation_data_v1.csv")

#NOW Go BACK to LOOKING AT correlation
#pcnt hispanic. check correlation for variable in both datasets
cor.test(validation_data$pcnt_hisp_chr,analysis_data$pcnt_hisp_ucb)
#food_insec and food_rank. There are incommplete observations so "use" to specify
cor(analysis_data$pcnt_food_insec_chr,validation_data$food_rank_chr, use="complete.obs")
cor.test(analysis_data$pcnt_food_insec_chr,validation_data$food_rank_chr, use="complete.obs")

#pcnt blk. check correlation for variable in both datasets
cor.test(analysis_data$pcnt_blk_ucb,validation_data$pcnt_blk_chr)

#pcnt rural. check correlation for variable in both datasets
cor.test(analysis_data$pcnt_rural_chr,validation_data$pcnt_rural_chr)

#pcnt sr.check correlation for variable in both datasets
cor.test(analysis_data$pcnt_sr_ucb,validation_data$pcnt_sr_chr)

#unemployment rate.check correlation for variable in both datasets
cor.test(analysis_data$pcnt_unemp_bls,validation_data$pcnt_unemp_chr)

# pcnt pov check correlation for variable in both datasets
cor.test(analysis_data$pcnt_pov_usda,validation_data$pcnt_pov_saipe)

#ocnt income. check correlation for variable in both datasets
cor.test(analysis_data$pcnt_income_saipe,validation_data$pcnt_income_chr)

#ocnt...check correlation for variable in both datasets
cor.test(analysis_data$pcnt_own_ucb,validation_data$pcnt_own_chr)

#lw access check correlation for variable in both datasets
cor.test(analysis_data$pcnt_lw_access_usda,validation_data$pcnt_lw_access_chr)

#obese check correlation for variable in both datasets
cor.test(analysis_data$pcnt_obese_usda,validation_data$pcnt_obese_chr)

#check correlation for variable in both datasets
cor.test(analysis_data$pcnt_uninsured_chr,validation_data$pcnt_uninsured_chr)


#Add border county dataset
#Then add a categorical variable border_cnty
brdr_cnty<-read.csv("~/Github/Data-Management-Final-Project-Agbim/data/raw_data/border_county_dhs/border_county_tx.csv",header = TRUE)
library(tidyverse)
analysis_data$brdr_cnty<-ifelse(analysis_data$cnty %in% brdr_cnty$brdr_cnty_name, 1,0)

view(analysis_data)

#ensure border is being understood as a categorical variable

analysis_data$brdr_cnty<-as.factor(analysis_data$brdr_cnty)
levels(analysis_data$brdr_cnty)
#summarize to see how many variable were categorized as border or non border
#There should be 32 variables categorized as border
summary(analysis_data$brdr_cnty)



#now add brdr cnty variable to validation dataset
validation_data$brdr_cnty<-ifelse(validation_data$cnty %in% brdr_cnty$brdr_cnty_name, 1,0)

view(validation_data)
#check if brdr cnty is a categorical variables. "NULL" response means it's not
levels(validation_data$brdr_cnty)
#change to a factor aka a categorical variable
validation_data$brdr_cnty<-as.factor(validation_data$brdr_cnty)
#check if brdr cnty is a categorical variables. "NULL" response means it's not
levels(validation_data$brdr_cnty)
summary(validation_data$brdr_cnty)

#Export dummy var files
write.csv(x=analysis_data,file = "analysis_data_dum_v1.csv")
write.csv(x=validation_data,file = "valid_data_dum_v1.csv")
