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

#grouping
gapminder_continent = GapMKuwait %>%
  group_by(continent,year) %>%
  summarize(gdpPercapweighted = weighted.mean(
    x = gdpPercap, w= pop),
    pop = sum(as.numeric(pop)))

#plot # 2
ggplot(GapMKuwait, aes(x=year,y=gdpPercap,
  color=continent,group=country)) +
  geom_point() +
  geom_line() +
  geom_point(data=gapminder_continent,aes(x=year,y=gdpPercapweighted)) +
  facet_wrap(~continent) +
  theme_bw()
#Can't get to work, after including second geom_point, it returns country not found
  
