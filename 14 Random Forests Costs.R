# Installing packages
install.packages("randomForest")

# Load the packages
library(randomForest)

# Subset data
hf_csv_cost_subset<-hf_csv[,c(3,6:10,13)]
random_forest_prep <- model.matrix(~., hf_csv_cost_subset)
random_forest_prep<-as.data.frame(random_forest_prep)
random_forest_prep$`(Intercept)` <- NULL
names(random_forest_prep) <- make.names(names(random_forest_prep))

# Random Forest model
random_forest_costs <- randomForest(cost~., random_forest_prep, importance=TRUE, ntree=10,sampsize=3000)
print(random_forest_costs)
importance(random_forest_costs)

# train RMSE
err<-random_forest_costs$predicted-random_forest_costs$y
(rmse <- sqrt(mean(err^2)))

# prediction RMSE
cart_cost_prediction<- predict(random_forest_costs, hf_csv_validation)
err <- cart_cost_prediction - hf_csv_validation$cost
(rmse <- sqrt(mean(err^2)))