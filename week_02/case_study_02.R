#load tidyverse
library(tidyverse)
#define data link
dataurl="https://data.giss.nasa.gov/tmp/gistemp/STATIONS/tmp_USW00014733_14_0_1/station.csv"
#add data
temp=NULL
temp=read_csv(dataurl,
              skip=1, #skip the first line which has column names
              na="999.90", # tell R that 999.90 means missing in this dataset
              col_names = c("YEAR","JAN","FEB","MAR", # define column names 
                            "APR","MAY","JUN","JUL",  
                            "AUG","SEP","OCT","NOV",  
                            "DEC","DJF","MAM","JJA",  
                            "SON","metANN"))
if(is.null(temp)==TRUE){
  #got 404 error first time, but works now, in case it doesn't work again
  #there is code below to save manually and clean data
  
  #---------------------------------------------------------
  #saving the data manually to CSV in wd and then loading
  temp <- read_csv("Week_02/station.csv")
  #change column names like above
  nameslist=c("YEAR","JAN","FEB","MAR", # define column names 
              "APR","MAY","JUN","JUL",  
              "AUG","SEP","OCT","NOV",  
              "DEC","DJF","MAM","JJA",  
              "SON","metANN")
  names(temp)=nameslist
  #create NAs
  temp[temp==999.90]=NA}
#---------------------------------------------------
#explore data
summary(temp)
str(temp)
glimpse(temp)
#after adding NAs, structure of vars becomes dbl

#create plot
casestudy2plot=ggplot(temp,aes(YEAR,JJA))+
  xlab("Year")+
  ylab(expression(paste("Mean Summer Temperatures (",~degree,"C)",sep="")))+
  ggtitle("Mean Summer Temperatures in Buffalo, NY")+
  labs(subtitle="Summer includes June, July, and August 
Data from the Global Historical Climate Network
Red line is a LOESS smooth")+
  geom_line()+
  geom_smooth(color="red")
casestudy2plot
#remove pound key to save, run before creating plot
#png(filename = "case_study2plot.png")
