library(tidyverse)
library(stringr)
rm(list=ls())

#Set working directory and read FRS data file. In this case, saved as .xlsx file.
setwd("~/DTSC/Manufacturing_Projects/csv")
tri<- read.csv("TRI_CA_2021.csv")

#Only look at NAICS codes that start with 31, 32, or 33, which are manufacturing NAICS codes. 1,133 to 1000 facilities.
tri <-  tri %>% 
  filter(grepl("^31", X56..PRIMARY.NAICS.CODE) | grepl("^32", X56..PRIMARY.NAICS.CODE)| grepl("^33", X56..PRIMARY.NAICS.CODE))

#Remove facilities associated with NAICS codes outside of SCP scope. This should reduce the number from 1,000 to 
exclude_N<- c(311, 3111, 31111, 311111, 311119, 3112, 31121, 311211, 311212, 311213, 31122, 311221, 311224, 311225, 31123,
              311230, 3113, 31131, 311313, 311314, 31134, 311340, 31135, 311351, 311352, 3114, 31141, 311411, 311412, 31142, 
              311421, 311422, 311423, 3115, 31151, 311511, 311512, 311513, 311514, 31152, 311520, 3116, 31161, 311611, 311612, 
              311613, 311615, 3117, 31171, 311710, 3118, 31181, 311811, 311812, 311813, 31182, 311821, 311824, 31183, 311830, 
              3119, 31191, 311911, 311919, 31192, 311920, 31193, 311930, 31194, 311941, 311942, 31199, 311991, 311999, 312, 
              3121, 31211, 312111, 312112, 312113, 31212, 312120, 31213, 312130, 31214, 312140, 32312, 323120, 3253, 32532, 
              325320, 325412, 325413, 325414, 3391, 33911, 339112, 339113, 339114, 339116, 111998, 112519, 113310, 211130,
              212324, 212325, 212393, 212399, 488390, 511110, 511120, 511130, 511140, 511191, 511199, 512230, 512250, 519130, 
              541713, 811490)

tri$KEEP<- ifelse(tri$X56..PRIMARY.NAICS.CODE %in% exclude_N, "EXCLUDE", "INCLUDE")

tri %>% 
  count(tri$KEEP)

tri <- tri %>% 
  filter(KEEP == "INCLUDE")

#Remove duplicate facilities. 
tri <- tri %>%  distinct(X4..TRIFD, .keep_all=TRUE)
sum(is.na(tri$X4..TRIFD))

#Each facility has a longitude and latitude associated, so there is not other cleaning to perform for TRI data.
sum(is.na(tri$X62..LATITUDE))

#write.csv(tri, "~\\DTSC\\Manufacturing_Projects\\csv\\TRI_FINAL_2.csv", row.names=FALSE) 
