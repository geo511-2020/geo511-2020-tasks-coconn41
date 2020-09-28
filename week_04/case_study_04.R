library(nycflights13)
library(tidyverse)
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
pythag=function(w,x,y,z){ #such that y and z are lat long of NYC airports
sqrt(((w-y)^2)+((x-z)^2))}

EWRdistances=NULL
for (i in 1:nrow(EWRdestairs)){
  destlatitude = EWRdestairs$lat[i]
  destlongitude = EWRdestairs$lon[i]
  if(is.null(EWRdistances)==TRUE){  
    EWRdistances=pythag(nycairports$lat[1],nycairports$lon[1],destlatitude,destlongitude)}
  else{
    c=pythag(nycairports$lat[1],nycairports$lon[1],destlatitude,destlongitude)
    EWRdistances = rbind(EWRdistances,c)}
  if(nrow(EWRdistances)==nrow(EWRdestairs)){
    cbind(EWRdestairs,EWRdistances)
    EWRmax= EWRdestairs %>% slice(which.max(EWRdistances))
  }
}

JFKdistances=NULL
for (i in 1:nrow(JFKdestairs)){
  destlatitude = JFKdestairs$lat[i]
  destlongitude = JFKdestairs$lon[i]
if(is.null(JFKdistances)==TRUE){  
  JFKdistances=pythag(nycairports$lat[2],nycairports$lon[2],destlatitude,destlongitude)}
else{
  c=pythag(nycairports$lat[2],nycairports$lon[2],destlatitude,destlongitude)
JFKdistances = rbind(JFKdistances,c)}
  if(nrow(JFKdistances)==nrow(JFKdestairs)){
    JFKdestairs=cbind(JFKdestairs,JFKdistances)
  JFKmax=JFKdestairs %>% slice(which.max(JFKdistances))
    }
}

LGAdistances=NULL
for (i in 1:nrow(LGAdestairs)){
  destlatitude = LGAdestairs$lat[i]
  destlongitude = LGAdestairs$lon[i]
  if(is.null(LGAdestairs$distancecalc==TRUE)){  
    LGAdistances=pythag(nycairports$lat[3],nycairports$lon[3],destlatitude,destlongitude)}
  else{
    c=pythag(nycairports$lat[3],nycairports$lon[3],destlatitude,destlongitude)
    LGAdistances = rbind(LGAdistances,c)}
  if(nrow(LGAdistances)==nrow(LGAdestairs)){
  LGAdestairs=cbind(LGAdestairs,LGAdistances)
  LGAmax=LGAdestairs %>% slice(which.max(LGAdistances))
  }
}
#find airport furthest away from each NYC Airport
x1=rbind(EWRmax,JFKmax)
x2=rbind(x1,LGAmax)
finaldf=x2[c(2,23,27)]
