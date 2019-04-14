#The energy burden data from NREL was seperated into three files (see the readme in energy burden folder)
#Therefore we need to merge the files vertically
energy_burden_0<-read.csv("~/GitHub/Data-Management-Final-Project-Agbim/data/data_raw/analysis_data_raw/energy_burden_nrel/Energy Burden_Apr 12 2019.csv")

view(energy_burden_0)
#View each dataframe after loading to ensure r read it as a dataframe
energy_burden_1<-read.csv("~/GitHub/Data-Management-Final-Project-Agbim/data/data_raw/analysis_data_raw/energy_burden_nrel/Energy Burden_Apr 12 2019_ 1.csv")
view(energy_burden_1)

energy_burden_2<-read.csv("~/GitHub/Data-Management-Final-Project-Agbim/data/data_raw/analysis_data_raw/energy_burden_nrel/Energy Burden_Apr 12 2019_2.csv")

view(energy_burden_2)
