library(tidyverse)
library(gapminder)
data("gapminder")
#remove Kuwait
GapMKuwait= gapminder %>%
  filter(country != "Kuwait")

#plot #1
ggplot(GapMKuwait,aes(lifeExp,gdpPercap))+
  geom_point(aes(size=pop/100000,color=continent)) +
  scale_y_continuous(trans = 'sqrt')+
  facet_wrap(~year,nrow=1) +
  xlab("Life Expectancy") +
  ylab(" GDP per capita") +
  scale_size_continuous("Population (100k)") +
  scale_color_discrete("Continent") +
  theme_bw()
