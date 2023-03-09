library(tidyverse)
library(sf)
library(readxl)


facilities <- read_excel("facilities_shiny.xlsx", col_names=TRUE)
facilities <- st_as_sf(facilities, coords = c("Longitude", "Latitude"), crs = "+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs" )

class(facilities)
st_crs(facilities)

st_write(facilities, "facilitylist.shp", delete_layer = TRUE)
