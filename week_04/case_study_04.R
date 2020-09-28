library(nycflights13)
library(tidyverse)
#load data
data(flights)
data(airports)
names(airports)[1]='dest'

a=left_join(airports,flights,by='dest')
JFKdestairs= a %>% filter(origin == "JFK") %>%  
  distinct(origin,dest,.keep_all = T) #%>%
  #distinct(dest,.keep_all = T)
LGAdestairs=a %>% filter(origin == "LGA") %>%
  distinct(origin,dest,.keep_all = T)
EWRdestairs=a %>% filter(origin=="EWR") %>%
  distinct(origin,dest,.keep_all = T)

nycairports= a %>% filter(dest=="JFK" | dest=="LGA" | dest=="EWR") %>%
  distinct(dest,.keep_all = T)

pythag=function(w,x,y,z){ #such that y and z are lat long of NYC airports
sqrt(((w-y)^2)+((x-z)^2))}

EWRdistances=NULL
for (i in 1:nrow(EWRdestairs)){
  destlatitude = EWRdestairs$lat[i]
  destlongitude = EWRdestairs$lon[i]
  if(is.null(distances)==TRUE){  
    EWRdistances=pythag(nycairports$lat[1],nycairports$lon[1],destlatitude,destlongitude)}
  else{
    c=pythag(nycairports$lat[1],nycairports$lon[1],destlatitude,destlongitude)
    EWRdistances = rbind(EWRdistances,c)}
}



JFKdistances=NULL
for (i in 1:nrow(JFKdestairs)){
  destlatitude = JFKdestairs$lat[i]
  destlongitude = JFKdestairs$lon[i]
if(is.null(distances)==TRUE){  
  JFKdistances=pythag(nycairports$lat[2],nycairports$lon[2],destlatitude,destlongitude)}
else{
  c=pythag(nycairports$lat[2],nycairports$lon[2],destlatitude,destlongitude)
JFKdistances = rbind(JFKdistances,c)}
}

LGAdistances=NULL
for (i in 1:nrow(LGAdestairs)){
  destlatitude = LGAdestairs$lat[i]
  destlongitude = LGAdestairs$lon[i]
  if(is.null(distances)==TRUE){  
    LGAdistances=pythag(nycairports$lat[3],nycairports$lon[3],destlatitude,destlongitude)}
  else{
    c=pythag(nycairports$lat[3],nycairports$lon[3],destlatitude,destlongitude)
    LGAdistances = rbind(LGAdistances,c)}
}

