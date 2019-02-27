# Installing packages
install.packages("dplyr")
install.packages("purrr")
install.packages("ggplot2")

# Load the packages
library(dplyr)
library(purrr)
library(ggplot2)


# Examining the characteristics of the hf patients with early mortality
early_mortality_patients<-hf_csv %>% filter(early_mortality==1)
x_variables<-c("age", "race_group", "discharge_status", "ischemic_cardiomyopathy", "obesity", "comorbidity_score", "Loop_diuretics","Other_diuretics")
x_prep<-early_mortality_patients[x_variables]
x <- model.matrix(~., x_prep)
x<-as.data.frame(x)
x$`(Intercept)` <- NULL

# normalize the variables

normalize <- function(z) {
  return ((z - min(z)) / (max(z) - min(z))) }

early_mortality_patients_characteristics<-as.data.frame(x)
early_mortality_patients_characteristics_normalized <- as.data.frame(lapply(early_mortality_patients_characteristics, normalize))

# K-means clustering
k_means_3<-kmeans(early_mortality_patients_characteristics_normalized,3,nstart=20)

# Characteristics by cluster
k_means_3

# Plotting by cluster
k_means_3$cluster <- as.factor(k_means_3$cluster)
ggplot(early_mortality_patients_characteristics, aes(age, comorbidity_score, color = k_means_3$cluster)) + geom_point()


# Plotting the total within-cluster sum of squares by K

set.seed(123)

# function to compute total within-cluster sum of square 
wss <- function(k) {
  kmeans(early_mortality_patients_characteristics_normalized, k, nstart = 10 )$tot.withinss
}

# Compute and plot wss for k = 1 to k = 15
k.values <- 1:15

# extract wss for 2-15 clusters
wss_values <- map_dbl(k.values, wss)

plot(k.values, wss_values,
     type="b", pch = 19, frame = FALSE, 
     xlab="Number of clusters K",
     ylab="Total within-clusters sum of squares")

