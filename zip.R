readLines("Credentials")
source("Credentials")

library(RCurl)
library(data.table)
?getURL


Usepassword <- paste0(user_name,":", password)

url <- "https://cadtsc.sharepoint.com/:x:/r/sites/spwp-ChemPET/Shared%20Documents/CA%20Manufacturing%20Activities/GitHub_Data/Clean_Data/TRI_FINAL_2.csv?d=w94faea6b4ced4e9ca812d737204b2911&csf=1&web=1&e=tXuYna"
library(xml2)
library(xlsx)
data<-getURL(url, userpwd= Usepassword)
xmldata<-xmlParse(data,useInternalNode=TRUE, options=HUGE)
datalist<-xmlToList(xmlroot(xmldata)[[“data”]])
mydata<-ldply(datalist,rbind)