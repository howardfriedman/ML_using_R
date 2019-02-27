# Installing packages
install.packages("caret")

# Load the packages
library(caret)


# Data partition example
set.seed(42)
split1=0.60 # percent of cases in the training set
split2=0.50 # test and validation equal size = #validation/(# test+# validation)

# Split 1
trainIndex1 <- createDataPartition(hf_csv$early_mortality, p=split1, list=FALSE)
data_train <- hf_csv[ trainIndex1,]
data_1 <- hf_csv[-trainIndex1,]
# Split 2
trainIndex2 <- createDataPartition(data_1$early_mortality, p=split2, list=FALSE)
data_validation <- data_1[trainIndex2,]
data_test <- data_1[-trainIndex2,]

# Examine the quality of the data splitting
summary(hf_csv)
summary(data_train)
summary(data_validation)
summary(data_test)


