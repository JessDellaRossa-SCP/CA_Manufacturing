library(sf)
library(tidyverse)
library(units)
library(tmap)
library(tidycensus)
library(tigris)
library(rmapshaper)
library(leaflet)
library(tidygeocoder)
library(osmdata)

setwd("~/DTSC/Manufacturing_Projects/Manufacturing-SCP/Data/Clean_Data")

master.df <- read.csv("MLfinal_onlyCA_Feb9_.csv")


master.sf <- master.df %>% 
  st_as_sf(coords = c("lon", "lat"),
           crs = "+proj=longlat +datum=WGS84")

st_write(master.sf, "facilitylist.shp", delete_layer = TRUE)
