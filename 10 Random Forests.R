# Installing packages
install.packages("randomForest")

# Load the packages
library(randomForest)

# Subset data
hf_csv_subset<-hf_csv[,3:11]

# data prep
random_forest_prep <- model.matrix(~., hf_csv_subset)
random_forest_prep<-as.data.frame(random_forest_prep)
random_forest_prep$`(Intercept)` <- NULL
names(random_forest_prep) <- make.names(names(random_forest_prep))

x_prep_validation<-hf_csv_validation[,3:10]
x_validation <- model.matrix(~., x_prep_validation)
x_validation<-as.data.frame(x_validation)
x_validation$`(Intercept)` <- NULL

x_prep<-hf_csv[,3:10]
x <- model.matrix(~., x_prep)
x<-as.data.frame(x)
x$`(Intercept)` <- NULL

# Normalize
normalize <- function(z) {
  return ((z - min(z)) / (max(z) - min(z))) }
x<-as.data.frame(x)
x_n <- as.data.frame(lapply(x, normalize))
x_validation_n <- as.data.frame(lapply(x_validation, normalize))
# Check normalizations
summary(x_n)
summary(x_validation_n)


early_mortality_test<-hf_csv$early_mortality
early_mortality_validation<-hf_csv_validation$early_mortality

data_test<-cbind(early_mortality_test,x_n)
data_validation<-cbind(early_mortality_validation,x_validation_n)


# Random Forest model
random_forest <- randomForest(as.factor(early_mortality)~., random_forest_prep, importance=TRUE, ntree=100,sampsize=3000)
importance(random_forest)
print(random_forest)


# Exploring mtry, the number of variables examined at each node
mtry <- tuneRF(random_forest_prep[-18],random_forest_prep$early_mortality, ntreeTry=10,
               stepFactor=1.5,improve=0.01, trace=TRUE, plot=TRUE)
print(mtry)
best.m <- mtry[mtry[, 2] == min(mtry[, 2]), 1]
print(best.m)

# using best mtry
random_forest_mtry <- randomForest(as.factor(early_mortality)~., random_forest_prep, importance=TRUE, ntree=10,sampsize=3000, mtry=best.m)
importance(random_forest_mtry)
print(random_forest_mtry)
