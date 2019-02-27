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

y <-as.factor(hf_csv$early_mortality)
y_validation<-hf_csv_validation$early_mortality

early_mortality_test<-as.numeric(hf_csv$early_mortality)
early_mortality_validation<-as.numeric(hf_csv_validation$early_mortality)

# Normalize
normalize <- function(z) {
  return ((z - min(z)) / (max(z) - min(z))) }
x<-as.data.frame(x)
x_n <- as.data.frame(lapply(x, normalize))
x_validation_n <- as.data.frame(lapply(x_validation, normalize))
# Check normalizations
summary(x_n)
summary(x_validation_n)


data_test<-cbind(early_mortality_test,x_n)
data_validation<-cbind(early_mortality_validation,x_validation_n)

# run GBM using the normalized data: bernoulli (logistic reg) adaboost exponential loss
gbm_0.1 <- gbm(early_mortality_test~., data=data_test, distribution="bernoulli", n.trees=100, interaction.depth = 5, shrinkage = 0.1)
gbm_0.01 <- gbm(early_mortality_test~., data=data_test, distribution="bernoulli", n.trees=100, interaction.depth = 5, shrinkage = 0.01)
gbm_0.001 <- gbm(early_mortality_test~., data=data_test, distribution="bernoulli", n.trees=100, interaction.depth = 5, shrinkage = 0.001)
gbm_0.0001 <- gbm(early_mortality_test~., data=data_test, distribution="bernoulli", n.trees=100, interaction.depth = 5, shrinkage = 0.0001)

#ada_boost_gbm_0.1 <- gbm(early_mortality_test~., data=data_test, distribution="adaboost", n.trees=100, interaction.depth = 5, shrinkage = 0.1)

# Obtain the variable influence
summary(gbm_0.1,n.trees=1)    
summary(gbm_0.1,n.trees=gbm_0.1$n.trees)    

# check performance using a 50% holdout test set
best.iter <- gbm.perf(gbm_0.1,method="OOB")
#best.iter<-10
# Examine the misclassification rate
gbm_0.1_pred<-predict(gbm_0.1,data_validation, type="response",n.trees=best.iter)
gbm_0.1_pred_final<-prediction(gbm_0.1_pred,hf_csv_validation$early_mortality)
# Compute the True Positive Rate (TPR) and the False Positive Rate (FPR)
perf_gbm_0.1_roc<-performance(gbm_0.1_pred_final,"tpr","fpr")
plot(perf_gbm_0.1_roc, add = TRUE,colorize = FALSE)
# compute the Area under the curve (AUC)
(perf_gbm_0.1_auc<-performance(gbm_0.1_pred_final,"auc"))
