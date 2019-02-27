# Installing packages
install.packages("dplyr")
install.packages("purrr")
install.packages("cluster")

# Load the packages
library(dplyr)
library(purrr)
library(cluster)

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

# Hierarchical clustering
# methods to assess
m <- c( "average", "single", "complete", "ward")
names(m) <- c( "average", "single", "complete", "ward")

# function to compute the Agglomerative coefficient
ac <- function(x) {
  agnes(early_mortality_patients_characteristics_normalized, method = x)$ac
}

map_dbl(m, ac)

# Using Ward
ward_agglomerative_cluster<-agnes(early_mortality_patients_characteristics_normalized, method = "ward")
pltree(ward_agglomerative_cluster, cex = 0.6, hang = -1, main = "Dendrogram of agnes") 
