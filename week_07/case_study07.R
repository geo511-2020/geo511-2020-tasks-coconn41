library(tidyverse)
library(reprex)
library(sf)
library(spData)
data(world)

ggplot(world,aes(x=gdpPercap, y=continent, color=continent))+
  geom_density(alpha=0.5,color=F)
# copy the above code first to generate reprex, then run:
#reprex()

