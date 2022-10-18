library(tidyverse)
library(fs)

setwd("~/DTSC/Manufacturing_Projects/csv")

#Now that we have one .csv that omits blank rows and "NULL" NAICS codes, we can clean up the CERS data to only include relevant information.
cers <- read.csv("CERS_Clean.csv")

#Now we need to find only NAICS codes that start with 31-33 and omit everything else. This will take the total from 468,961 to 130,452 rows.
cers <-  cers %>% 
  filter(grepl("^31", NAICSCode) | grepl("^32", NAICSCode)| grepl("^33", NAICSCode))

#Create a variable of NAICS codes to omit and filter out unnecessary NAICS codes. This will take the total down to 109,921.
exclude_N<- c(311, 3111, 31111, 311111, 311119, 3112, 31121, 311211, 311212, 311213, 31122, 311221, 311224, 311225, 31123,
              311230, 3113, 31131, 311313, 311314, 31134, 311340, 31135, 311351, 311352, 3114, 31141, 311411, 311412, 31142, 
              311421, 311422, 311423, 3115, 31151, 311511, 311512, 311513, 311514, 31152, 311520, 3116, 31161, 311611, 311612, 
              311613, 311615, 3117, 31171, 311710, 3118, 31181, 311811, 311812, 311813, 31182, 311821, 311824, 31183, 311830, 
              3119, 31191, 311911, 311919, 31192, 311920, 31193, 311930, 31194, 311941, 311942, 31199, 311991, 311999, 312, 
              3121, 31211, 312111, 312112, 312113, 31212, 312120, 31213, 312130, 31214, 312140, 32312, 323120, 3253, 32532, 
              325320, 325412, 325413, 325414, 3391, 33911, 339112, 339113, 339114, 339116, 111998, 112519, 113310, 211130,
              212324, 212325, 212393, 212399, 488390, 511110, 511120, 511130, 511140, 511191, 511199, 512230, 512250, 519130, 
              541713, 811490)

cers$KEEP<- ifelse(cers$NAICSCode %in% exclude_N, "EXCLUDE", "INCLUDE")
cers<- cers %>% 
  filter(KEEP == "INCLUDE")

#Now check for unique facilities by the CERSID. This will change the total to 3,618 facilities.
cers <- cers %>% 
  distinct(CERSID, .keep_all=TRUE)

#This data does not contain latitude and longitude. If we receive this information from CalEPA, then we can easily merge this in by CERSID.
#write.csv(cers, "~\\DTSC\\Manufacturing_Projects\\csv\\CERSS_FINAL.csv", row.names=FALSE) 
