library(nycflights13)
library(tidyverse)

data(flights)
data(airports)

names(flights)
str(flights$dest)
str(flights$origin)
str(flights$flight)

names(airports)
str(airports$name)
str(airports$faa)


data(weather)
str(weather$origin)


data(planes)

data(airlines)
