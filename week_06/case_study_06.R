library(raster)
library(sp)
library(spData)
library(tidyverse)
library(sf)
library(ncdf4)
library(tmap)

#Load all data
data(world)  #load 'world' data from spData package
crs(world) #world is WGS84
tmax_monthly <- getData(name = "worldclim", var="tmax", res=10)
crs(tmax_monthly) #tmax_monthly is WGS84
download.file("https://crudata.uea.ac.uk/cru/data/temperature/absolute.nc","crudata.nc")
tmean=raster("crudata.nc")
crs(tmean) #tmean is WGS84

#remove antarctica
unique(world$continent)
# Spelled "Antarctica"
worldwoAnt=world %>% 
  filter(continent != "Antarctica") %>% 
  select(name_long,geom)

#extract by country
meansummary=raster::extract(tmean,worldwoAnt,fun=mean,sp=TRUE) 
highestavg=meansummary@data %>%
  slice(base::which.max(CRU_Global_1961.1990_Mean_Monthly_Surface_Temperature_Climatology))


monthlyvals=NULL
pb = txtProgressBar(min = 0, max = nlayers(tmax_monthly), initial = 0, style = 3) 
for (i in 1:nlayers(tmax_monthly)){
  if(is.null(monthlyvals)){ 
  monthlyvals=raster::extract(tmax_monthly[[i]],worldwoAnt,fun=mean,sp=TRUE,na.rm=TRUE)
  monthlyvalsmax=monthlyvals@data %>%
    slice(which.max(tmax1))
  monthlyvalsmax$month=i
  names(monthlyvalsmax)[2]="max_temp"}
  else{
  nmvals=raster::extract(tmax_monthly[[i]],worldwoAnt,fun=mean,sp=TRUE,na.rm=TRUE)
  monthlyvals=merge(monthlyvals,nmvals,by="name_long")
  names(nvals@data)[2]="max_temp"
  thismonthshigh=nmvals@data %>%
    slice(which.max(max_temp))
  thismonthshigh$month=i
  monthlyvalsmax=rbind(monthlyvalsmax,thismonthshigh)
  }
  setTxtProgressBar(pb,i)
}
#monthlyvals will be used to make maps and tables for each month
#monthlyvals

