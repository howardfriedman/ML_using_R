# Installing packages
install.packages("naivebayes", dependencies=TRUE, type="source")

# Load the packages
library(naivebayes)

# data set-up: same as K-NN
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

# Naive Bayes model
m <- naive_bayes(y ~ ., data = x)

# prediction
naive_bayes_prediction<- predict(m, x_validation,threshold=mean(as.numeric(y)))

# Examine the misclassification rate
confusionMatrix(naive_bayes_prediction, y_validation)