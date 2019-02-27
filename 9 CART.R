# Installing packages
install.packages("rpart")
install.packages("caret",dependencies = TRUE)


# Load the packages
library(rpart)
library(caret)

# Subset data
hf_csv_subset<-hf_csv[,3:11]

# CART model
cart <- rpart (early_mortality~., hf_csv_subset, method="class", 
               control=rpart.control(minsplit=500,minbucket=300,cp=0.0001))

print(cart)
plot(cart)
# prediction
cart_prediction<- predict(cart, hf_csv_validation,type="class")


# Examine the misclassification rate
confusionMatrix(table(cart_prediction, y_validation))

#Developing a ROC curve
cart_prediction<- predict(cart, hf_csv_validation)
cart_pred_final<-prediction(cart_prediction[,2],hf_csv_validation$early_mortality)
perf_cart_model_roc<-performance(cart_pred_final,"tpr","fpr")
plot(perf_cart_model_roc, colorize = FALSE)

#Computing AUC
(perf_cart_model_auc<-performance(cart_pred_final,"auc"))

# Pruning
pfit<- prune(cart, cp=   cart$cptable[which.min(cart$cptable[,"xerror"]),"CP"])
prune_prediction<- predict(pfit, hf_csv_validation)
prune_pred_final<-prediction(prune_prediction[,2],hf_csv_validation$early_mortality)
perf_prune_model_roc<-performance(prune_pred_final,"tpr","fpr")
plot(perf_prune_model_roc, colorize = FALSE)
(perf_prune_model_auc<-performance(prune_pred_final,"auc"))
