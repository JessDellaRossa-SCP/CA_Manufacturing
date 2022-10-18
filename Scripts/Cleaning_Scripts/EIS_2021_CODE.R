library(tidyverse)
library(stringr)


#Set working directory and read FRS data file. In this case, saved as .xlsx file.
setwd("~/DTSC/Manufacturing_Projects/csv")
getwd()
eis<- read.csv("EIS_NAICS_31_33.csv")

#Remove duplicate facilities. This data set did not have any, but good to practice removing duplicates.There are 10,882 facilities.
eis <- eis %>%  
  distinct(eis$EIS.Facility.ID, .keep_all=TRUE)

#Now remove NAICS codes that are not relevant to this research.This will change the total facilties from 10,882 to 9,221.
exclude_N<- c(311, 3111, 31111, 311111, 311119, 3112, 31121, 311211, 311212, 311213, 31122, 311221, 311224, 311225, 31123,
              311230, 3113, 31131, 311313, 311314, 31134, 311340, 31135, 311351, 311352, 3114, 31141, 311411, 311412, 31142, 
              311421, 311422, 311423, 3115, 31151, 311511, 311512, 311513, 311514, 31152, 311520, 3116, 31161, 311611, 311612, 
              311613, 311615, 3117, 31171, 311710, 3118, 31181, 311811, 311812, 311813, 31182, 311821, 311824, 31183, 311830, 
              3119, 31191, 311911, 311919, 31192, 311920, 31193, 311930, 31194, 311941, 311942, 31199, 311991, 311999, 312, 
              3121, 31211, 312111, 312112, 312113, 31212, 312120, 31213, 312130, 31214, 312140, 32312, 323120, 3253, 32532, 
              325320, 325412, 325413, 325414, 3391, 33911, 339112, 339113, 339114, 339116, 111998, 112519, 113310, 211130,
              212324, 212325, 212393, 212399, 488390, 511110, 511120, 511130, 511140, 511191, 511199, 512230, 512250, 519130, 
              541713, 811490)

eis$KEEP<- ifelse(eis$NAICS..Primary. %in% exclude_N, "EXCLUDE", "INCLUDE")

eis %>% 
  count(eis$KEEP)

eis <- eis %>% 
  filter(KEEP == "INCLUDE")

#Check to see if all facilities have coordinates. All have coordinates, so this data is clean.

sum(is.na(eis$Site.Longitude))
#write.csv(eis, "~\\DTSC\\Manufacturing_Projects\\csv\\EIS_FINAL.csv", row.names=FALSE) 
