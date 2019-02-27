# Installing packages
install.packages("glmnet")

# Load the packages
library(glmnet)


# linear regression
linear_model	<-	glm(cost~comorbidity_score+age+race_group+Loop_diuretics+Other_diuretics+discharge_status+obesity,	data	=	hf_csv,	family	=	gaussian (link="identity"))

# Examining performance on a validation data set hfref_sample_validation.
summary(linear_model)
plot(linear_model)
linear_model_pred<-predict(linear_model,hf_csv_validation, type="response")
err <- linear_model_pred - hf_csv_validation$cost
(rmse <- sqrt(mean(err^2)))

# Assuming gamma distribution
gamma_model	<-	glm(cost~comorbidity_score+age+race_group+Loop_diuretics+Other_diuretics+discharge_status+obesity,	data	=	hf_csv,	family	=	Gamma (link="inverse"))

# Examining performance on a validation data set hfref_sample_validation.
summary(gamma_model)
gamma_model_pred<-predict(gamma_model,hf_csv_validation, type="response")
err <- gamma_model_pred - hf_csv_validation$cost
(rmse <- sqrt(mean(err^2)))
