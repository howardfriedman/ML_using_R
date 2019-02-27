install.packages("ROCR")
install.packages("caret",dependencies = TRUE)

library (readr)
library (ROCR)
library(caret)

# ROC curves using hfref_sample_validation.csv
# import hf_csv_validation and create data frame
#hf_csv_validation<-read_csv("D:/Users/friedman/Desktop/ML course materials/New_Data_Files/hfref_sample_validation.csv")
hf_csv_validation<-read_csv("~/hdr-proj/cds/Other/R/Data_Files/hfref_sample_validation.csv")
hf_csv_validation<-as.data.frame(hf_csv_validation)
# create prediction using the predict command
m1_pred<-predict(m1,hf_csv_validation, type="response")
m1_pred_final<-prediction(m1_pred,hf_csv_validation$early_mortality)
# Compute the True Positive Rate (TPR) and the False Positive Rate (FPR)
perf_m1_roc<-performance(m1_pred_final,"tpr","fpr")
plot(perf_m1_roc,col="black",lty=3, lwd=3)
# compute the Area under the curve (AUC)
(perf_m1_auc<-performance(m1_pred_final,"auc"))

# For m2
m2_pred<-predict(m2,hf_csv_validation, type="response")
m2_pred_final<-prediction(m2_pred,hf_csv_validation$early_mortality)
# Compute the True Positive Rate (TPR) and the False Positive Rate (FPR)
perf_m2_roc<-performance(m2_pred_final,"tpr","fpr")
plot(perf_m2_roc, add = TRUE,colorize = TRUE)
# compute the Area under the curve (AUC)
(perf_m2_auc<-performance(m2_pred_final,"auc"))

# For stepwise
step.model_pred<-predict(step.model,hf_csv_validation, type="response")
step.model_pred_final<-prediction(step.model_pred,hf_csv_validation$early_mortality)
# Compute the True Positive Rate (TPR) and the False Positive Rate (FPR)
perf_step.model_roc<-performance(step.model_pred_final,"tpr","fpr")
plot(perf_step.model_roc, colorize = FALSE)
# compute the Area under the curve (AUC)
(perf_step.model_auc<-performance(step.model_pred_final,"auc"))

# For LASSO
lasso_x_prep<-hf_csv_validation[x_variables]
newx <- model.matrix(~., lasso_x_prep)
lasso.model_pred<-predict(lasso.model,newx, s = cv.lasso$lambda.min, type="response")
lasso.model_pred_final<-prediction(lasso.model_pred,hf_csv_validation$early_mortality)
# Compute the True Positive Rate (TPR) and the False Positive Rate (FPR)
perf_step.model_roc<-performance(step.model_pred_final,"tpr","fpr")
plot(perf_step.model_roc, colorize = FALSE)
# compute the Area under the curve (AUC)
(perf_step.model_auc<-performance(step.model_pred_final,"auc"))

# confusion matrix using m1 as an example
p_class <- ifelse(m1_pred > mean(as.numeric(hf_csv$early_mortality)), 1, 0)
confusionMatrix(table(p_class, hf_csv_validation$early_mortality))

