# Installing packages
install.packages("gbm")

# Load the packages
library(gbm)

#Select variables
select_variables<-c("early_mortality","age", "race_group", "discharge_status", "ischemic_cardiomyopathy", "obesity", "comorbidity_score", "Loop_diuretics","Other_diuretics")
hf_csv_select<-hf_csv[select_variables]

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

cost<-hf_csv$cost
y_validation<-hf_csv_validation$cost

# Normalize
normalize <- function(z) {
  return ((z - min(z)) / (max(z) - min(z))) }
x<-as.data.frame(x)
x_n <- as.data.frame(lapply(x, normalize))
x_validation_n <- as.data.frame(lapply(x_validation, normalize))
# Check normalizations
summary(x_n)
summary(x_validation_n)

data_test<-cbind(cost,x_n)

# run GBM using the normalized data: gaussian distribution
gbm_0.1 <- gbm(cost~., data=data_test, distribution="gaussian", n.trees=100, interaction.depth = 5, shrinkage = 0.1)
gbm_0.01 <- gbm(cost~., data=data_test, distribution="gaussian", n.trees=100, interaction.depth = 5, shrinkage = 0.01)


# Obtain the variable influence
summary(gbm_0.1,n.trees=1)    
summary(gbm_0.1,n.trees=gbm_0.1$n.trees)    

# Examine the prediction error
gbm_0.1_pred<-predict(gbm_0.1,data_validation, type="response",n.trees=best.iter)
err <- gbm_0.1_pred - hf_csv_validation$cost
(rmse <- sqrt(mean(err^2)))
gbm_0.01_pred<-predict(gbm_0.01,data_validation, type="response",n.trees=best.iter)
err <- gbm_0.01_pred - hf_csv_validation$cost
(rmse <- sqrt(mean(err^2)))