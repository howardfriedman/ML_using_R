# Installing packages
install.packages("rpart")

# Load the packages
library(rpart)

# Subset data
hf_csv_cost_subset<-hf_csv[,c(3:10,13)]

# CART model
cart_costs <- rpart (cost~., hf_csv_cost_subset, method="anova", 
               control=rpart.control(minsplit=500,minbucket=300,cp=0.0001))
rsq.rpart(cart_costs)
plot(cart_costs$variable.importance)
print(cart_costs)
plot(cart_costs)
printcp(cart_costs)
# train RMSE
pred_costs = predict(cart_costs)
err <- pred_costs - hf_csv_cost_subset$cost
(rmse <- sqrt(mean(err^2)))

# prediction RMSE
cart_cost_prediction<- predict(cart_costs, hf_csv_validation)
err <- cart_cost_prediction - hf_csv_validation$cost
(rmse <- sqrt(mean(err^2)))

# prune the tree 
pfit<- prune(cart_costs, cp=   cart_costs$cptable[which.min(cart_costs$cptable[,"xerror"]),"CP"])

#predict on the pruned tree
cart_cost_prediction<- predict(pfit, hf_csv_validation)
err <- cart_cost_prediction - hf_csv_validation$cost
(rmse <- sqrt(mean(err^2)))

