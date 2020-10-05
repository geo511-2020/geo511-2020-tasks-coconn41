library(sf)
library(spData)
library(tidyverse)
library(tmap)
library(raster)
data(world)
data(us_states)
CAN= world %>% filter(name_long == "Canada")
CANname=CAN['name_long']
plot(CANname)
plot(us_states)
NYS=us_states %>% filter(NAME=="New York")
plot(NYS)
NYSname=NYS["NAME"]
plot(NYSname)
plot(CANname)

tm_shape(NYSname) +tm_borders() +
  tm_shape(CANname) + tm_borders()

tm_shape(CANname) +tm_borders() +
tm_shape(NYSname) + tm_borders()

#doesn't line up well, check crs

st_crs(CANname)
st_crs(NYSname)

NYSnameproj=st_transform(NYSname,crs=32618)
CANnameproj=st_transform(CANname,crs=32618)
#UTM 18


tm_shape(NYSnameproj) +tm_borders() +
tm_shape(CANnameproj) + tm_borders()

canbuf=st_buffer(CANnameproj,dist=10000)

tm_shape(NYSnameproj) +tm_borders() +
  tm_shape(canbuf) + tm_fill() +
  tm_shape(CANnameproj) + tm_borders() 

bufintersect=st_intersection(NYSnameproj,canbuf)  

tm_shape(NYSnameproj) +tm_borders() +
  tm_shape(bufintersect) + tm_fill() +
  tm_shape(CANnameproj) + tm_borders() 
#good

tm_shape(NYSnameproj) + tm_graticules() + tm_borders() + tm_fill(col="grey") +
  tm_shape(bufintersect) +tm_fill(col="red") + tm_scale_bar(position = "left") +
  tm_layout(main.title="NYS Land Within 10km of Canada",main.title.position = 'center')
  

Areaofintersect=st_area(bufintersect)
#3487834996 m^2