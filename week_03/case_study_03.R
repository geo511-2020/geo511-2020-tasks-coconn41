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
  ylab("GDP per capita") +
  scale_size_continuous("Population (100k)") +
  scale_color_discrete("Continent") +
  theme_bw()
ggsave("CS3plot1.png")
#grouping
gapminder_continent = GapMKuwait %>%
  group_by(continent,year) %>%
  summarize(gdpPercapweighted = weighted.mean(
    x = gdpPercap, w= pop),
    pop = sum(as.numeric(pop)))

#plot # 2
ggplot(GapMKuwait,aes(year,gdpPercap,group=country,color=continent)) +
  geom_point() +
  geom_line() +
  geom_point(data=gapminder_continent,aes(x=year,y=gdpPercapweighted,size=pop/100000),inherit.aes = FALSE) +
  geom_line(data=gapminder_continent,aes(x=year,y=gdpPercapweighted),inherit.aes = FALSE) +
  scale_size_continuous("Population (100k)") +
  scale_color_discrete("Continent") +
  facet_wrap(~continent,nrow=1) +
  theme_bw()
#this link is where I found out about inherit.aes = FALSE:
# https://stackoverflow.com/questions/40391272/ggplot-object-not-found-error-when-adding-layer-with-different-data
ggsave("CS3plot2.png")

