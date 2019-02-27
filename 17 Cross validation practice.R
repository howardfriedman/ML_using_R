# Installing packages
install.packages("caret")

# Load the packages
library(caret)


# Cross validation example
set.seed(42)

# define training control
train_control <- trainControl(method="cv", number=10, savePredictions = TRUE)
# train the model
logistic_regression_model <- train(as.factor(early_mortality)	~	comorbidity_score+age+race_group+discharge_status+obesity+Loop_diuretics+Other_diuretics,	data	=	hf_csv, 
               trControl=train_control, method="glm", family="binomial", tuneLength=10)
# summarize results
print(logistic_regression_model)

#
pred_logistic_regression = predict(logistic_regression_model, newdata=hf_csv_validation)
confusionMatrix(table(data=pred_logistic_regression, hf_csv_validation$early_mortality))

# Repeated Cross Validation
set.seed(42)
# define training control
train_control <- trainControl(method="repeatedcv", number=20, repeats=5, savePredictions = TRUE)
# train the model
repeated_logistic_regression_model <- train(as.factor(early_mortality)	~	comorbidity_score+age+race_group+discharge_status+obesity+Loop_diuretics+Other_diuretics,	data	=	hf_csv, 
                                   trControl=train_control, method="glm", family="binomial", tuneLength=10)
# summarize results
print(repeated_logistic_regression_model)

#
pred_repeat_logistic_regression = predict(repeated_logistic_regression_model, newdata=hf_csv_validation)
confusionMatrix(table(data=pred_repeat_logistic_regression, hf_csv_validation$early_mortality))


# Naive Bayes 
# Cross validation example
set.seed(42)

# define training control
train_control <- trainControl(method="cv", number=10, savePredictions = TRUE)
# train the model
nb_model <- train(as.factor(early_mortality)	~	comorbidity_score+age+race_group+discharge_status+obesity+Loop_diuretics+Other_diuretics,	data	=	hf_csv, 
                  trControl=train_control, method="nb", family="binomial", tuneLength=10)
# summarize results
print(nb_model)

#
pred_nb = predict(nb_model, newdata=hf_csv_validation)
confusionMatrix(table(data=pred_nb, hf_csv_validation$early_mortality))