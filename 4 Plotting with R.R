# Installing packages
install.packages("lattice")
install.packages("ggplot2")

# Load the packages
library(lattice)
library(ggplot2)

# lattice graphics
# Histogram
attach(hf_csv) 
histogram(~comorbidity_score)
#conditional histogram plot
histogram(~comorbidity_score| race_group)
#Density plots
densityplot(~age)
#conditional density plot
densityplot(~age| race_group)
#Quantile-quantile plots
qqmath(~age)
#Box and whisker conditional plot
bwplot(race_group~age)
bwplot(early_mortality~age)
# Scatter plot
xyplot(age~comorbidity_score)

# ggplot2 graphics
# histogram
ggplot(hf_csv, aes(x=comorbidity_score)) + geom_histogram(binwidth=1)
# faceted histogram
ggplot(hf_csv, aes(x=comorbidity_score)) + geom_histogram(binwidth=1) +  facet_grid(race_group ~ .,scales="free_y")
# density plots
ggplot(hf_csv, aes(x=age)) + geom_density() 
# Box and whisker plot
ggplot(hf_csv, aes(x=race_group,y=age)) + geom_boxplot()+ coord_flip()
ggplot(hf_csv, aes(x=as.factor(early_mortality),y=age)) + geom_boxplot()+ coord_flip()
# SCatter plot
ggplot(hf_csv, aes(x=comorbidity_score, y=age)) + geom_point(size=2, shape=23)

ggplot(hf_csv, aes(x=comorbidity_score, y=age)) + geom_point(size=2, shape=23) + facet_grid(race_group ~ .)


