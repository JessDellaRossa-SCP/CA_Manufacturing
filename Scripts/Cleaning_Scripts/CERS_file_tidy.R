library(tidyverse)

setwd("~/DTSC/Manufacturing_Projects/csv/")

files <- list.files("CERS", full.names=TRUE)
files
cers <- data.frame(files)
cers$file <- gsub("CERS/", "",
                  gsub(".csv", "", as.character(cers$files)))
CERS_d <- data.frame()

for (i in 2:10) {
  cers_data<- read.csv(paste0("CERS/",cers$file[i], ".csv"))
  CERS_d <- rbind(cers_data,CERS_d)
}

CERS_d <- CERS_d[!apply(CERS_d == "", 1, all),]
CERS_d<- CERS_d[!(CERS_d$NAICSCode == "NULL"),]
CERS_d<- CERS_d[!(CERS_d$NAICSCode == ""),]

write.csv(CERS_d, "~\\DTSC\\Manufacturing_Projects\\csv\\CERS_Clean.csv", row.names=FALSE) 
