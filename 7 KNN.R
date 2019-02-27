# Installing packages
install.packages("dplyr")
install.packages("ggplot2")
install.packages("MASS")
install.packages("glmnet")
install.packages("class")
install.packages("caret",dependencies = TRUE)

# Load the packages
library(dplyr)
library(ggplot2)
library(MASS)
library(glmnet)
library(class)
library(caret)

# data set-up
x_variables<-c("age", "race_group", "discharge_status", "ischemic_cardiomyopathy", "obesity", "comorbidity_score", "Loop_diuretics","Other_diuretics")
x_prep<-hf_csv[x_variables]
x <- model.matrix(~., x_prep)
x<-as.data.frame(x)
x$`(Intercept)` <- NULL


x_prep_validation<-hf_csv_validation[x_variables]
x_validation <- model.matrix(~., x_prep_validation)
x_validation<-as.data.frame(x_validation)
x_validation$`(Intercept)` <- NULL

y <-as.factor(hf_csv$early_mortality)
y_validation<-hf_csv_validation$early_mortality

# Normalize
normalize <- function(z) {
  return ((z - min(z)) / (max(z) - min(z))) }
x<-as.data.frame(x)
x_n <- as.data.frame(lapply(x, normalize))
x_validation_n <- as.data.frame(lapply(x_validation, normalize))
# Check normalizations
summary(x_n)
summary(x_validation_n)

# run KNN using the normalized data
knn_3 <- knn(train = x_n, test = x_validation_n,cl = y, k=3)
knn_5 <- knn(train = x_n, test = x_validation_n,cl = y, k=5)
knn_10 <- knn(train = x_n, test = x_validation_n,cl = y, k=10)
knn_100 <- knn(train = x_n, test = x_validation_n,cl = y, k=100)

# Examine the misclassification rate
confusionMatrix(table(knn_3, y_validation))
confusionMatrix(table(knn_5, y_validation))
confusionMatrix(table(knn_10, y_validation))
confusionMatrix(table(knn_100, y_validation))
