library(raster)
library(sp)
library(spData)
library(tidyverse)
library(sf)
library(ncdf4)
library(tmap)
library(viridis)

#Load all data
data(world)  #load 'world' data from spData package
crs(world) #world is WGS84
tmax_monthly <- getData(name = "worldclim", var="tmax", res=10)
gain(tmax_monthly)=.1
crs(tmax_monthly) #tmax_monthly is WGS84
download.file("https://crudata.uea.ac.uk/cru/data/temperature/absolute.nc","crudata.nc")
tmean=raster("crudata.nc")
crs(tmean) #tmean is WGS84

#Spatial World
worldspatial=as(world,"Spatial")


#remove antarctica
unique(worldspatial$continent)
# Spelled "Antarctica"
worldwoAnt=world %>% 
  filter(continent != "Antarctica") %>%
  filter(name_long != "French Southern and Antarctic Lands")


tmax_annual=max(tmax_monthly)
names(tmax_annual) = "tmax"


highval=raster::extract(tmax_annual,worldwoAnt,na.rm=TRUE,small=TRUE,sp=TRUE,fun=max)
highvalsf=st_as_sf(highval)
tm_shape(highval) +
  tm_graticules() +
  tm_polygons(col="tmax",
              style = "cont",
              palette="viridis",
              title = "Annual\nMaximum\nTemperature (C)",
              legend.is.portrait=F) +
  tm_layout(legend.outside=TRUE,
            legend.outside.position = "bottom")

    
?guide_colorbar
# table below

hotcontinent = highval@data %>%
  group_by(continent) %>%
  slice(which.max(tmax)) #%>%
  arrange('descending')

view(hotcontinent)