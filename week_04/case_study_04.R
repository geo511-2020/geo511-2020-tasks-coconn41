library(nycflights13)
library(tidyverse)
library(geosphere)
#load data
data(flights)
data(airports)
names(airports)[1]='dest'

a=left_join(airports,flights,by='dest')
#flights from JFK
JFKdestairs= a %>% filter(origin == "JFK") %>%  
  distinct(origin,dest,.keep_all = T) 
#flights from LGA
LGAdestairs=a %>% filter(origin == "LGA") %>%
  distinct(origin,dest,.keep_all = T)
#flights from EWR
EWRdestairs=a %>% filter(origin=="EWR") %>%
  distinct(origin,dest,.keep_all = T)
#Coordinates of NYC Airports
nycairports= a %>% filter(dest=="JFK" | dest=="LGA" | dest=="EWR") %>%
  distinct(dest,.keep_all = T)
#create function for pythagorean theorem
#pythag=function(w,x,y,z){ #such that y and z are lat long of NYC airports
#sqrt(((w-y)^2)+((x-z)^2))}

distances=NULL
for (i in 1:nrow(EWRdestairs)){
  destlatitude = EWRdestairs$lat[i]
  destlongitude = EWRdestairs$lon[i]
  if(is.null(distances)==TRUE){  
    distances=distHaversine(c(nycairports$lon[1],nycairports$lat[1]),c(destlongitude,destlatitude))}
  else{
    c=distHaversine(c(nycairports$lon[1],nycairports$lat[1]),c(destlongitude,destlatitude))
      distances = rbind(distances,c)}
  if(NROW(distances)==NROW(EWRdestairs)){
    EWRdestairs=cbind(EWRdestairs,distances)
    EWRmax= EWRdestairs %>% slice(which.max(distances))
  }
}

distances=NULL
for (i in 1:nrow(JFKdestairs)){
  destlatitude = JFKdestairs$lat[i]
  destlongitude = JFKdestairs$lon[i]
if(is.null(distances)==TRUE){  
  distances=distHaversine(c(nycairports$lon[2],nycairports$lat[2]),c(destlongitude,destlatitude))}
else{
  c=distHaversine(c(nycairports$lon[2],nycairports$lat[2]),c(destlongitude,destlatitude))
distances = rbind(distances,c)}
  if(NROW(distances)==NROW(JFKdestairs)){
     JFKdestairs=cbind(JFKdestairs,distances)
  JFKmax=JFKdestairs %>% slice(which.max(distances))
    }
}

distances=NULL
for (i in 1:nrow(LGAdestairs)){
  destlatitude = LGAdestairs$lat[i]
  destlongitude = LGAdestairs$lon[i]
  if(is.null(LGAdestairs$distancecalc==TRUE)){  
    distances=distHaversine(c(nycairports$lon[3],nycairports$lat[3]),c(destlongitude,destlatitude))}
  else{
    c=distHaversine(c(nycairports$lon[3],nycairports$lat[3]),c(destlongitude,destlatitude))
    distances = rbind(distances,c)}
  if(NROW(distances)==NROW(LGAdestairs)){
  LGAdestairs=cbind(LGAdestairs,distances)
  LGAmax=LGAdestairs %>% slice(which.max(distances))
  }
}
#find airport furthest away from each NYC Airport
x1=rbind(EWRmax,JFKmax)
x2=rbind(x1,LGAmax)
finaldf=x2[c(2,21,23,27)]
finaldf$km_distance=finaldf$distances/1000
finaldf$mi_distance=finaldf$km_distance*(1/1.609344)
