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
  slice(which.max(c(2))

testsummary=raster::extract(tmax_monthly[[2]],worldwoAnt,fun=mean,sp=TRUE,na.rm=TRUE)
testhighav=testsummary@data


tmaxbrick=brick(tmax_monthly)
monthlyvals=NULL
pb = txtProgressBar(min = 0, max = nlayers(tmaxbrick), initial = 0, style = 3) 
for (i in 1:nlayers(tmax_monthly)){
  if(is.null(mnthlyvals)==TRUE){ 
  montlyvals=raster::extract(tmaxbrick[[i]],worldwoAnt,fun=mean,sp=TRUE,na.rm=TRUE)
  montlyvalsmax=monthlyvals@data %>%
    slice(which.max(tmax1))}
  else{
  nmvals=raster::extract(tmaxbrick[[i]],worldwoAnt,fun=mean,sp=TRUE)
  monthlyvals=cbind(monthlyvals,nmvals)
  thismonthshigh=monthlyvals@data %>%
    slice(which.max(paste("tmax",i,sep="")))
  monthlyvalsmax=rbind(monthlyvalsmax,thismonthshigh)
  }
  setTxtProgressBar(pb,i)
}
#monthlyvals will be used to make maps and tables for each month
#monthlyvals

