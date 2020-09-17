# load tidyverse
library(tidyverse)
#load iris dataset
data(iris)
#view iris dataset
head(iris)
#read help file for function that calculates the mean
help("mean") # or ?mean
#calculate the mean of Petal.Length and save as object
head(iris$Petal.Length)
petal_length_mean = mean(iris$Petal.Length) # mean = 3.758
#plot histogram for petal length column
hist(iris$Petal.Length,las=1,ylim=c(0,40))
#save script
#why is there a bimodal spread? 
a = iris %>%
  filter(Species=="setosa")
b = iris %>%
  filter(Species=="versicolor")
c = iris %>%
  filter(Species=="virginica")
par(mfrow=c(2,2))
hist(a$Petal.Length)
hist(b$Petal.Length)
hist(c$Petal.Length)
#ggsave("Iris Species Histograms.pdf")
