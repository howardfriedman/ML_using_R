# Installing packages
install.packages("glmnet")
install.packages("dplyr")
install.packages("magrittr")
install.packages("MASS")

# Load the packages
library(glmnet)
library(dplyr)
library(magrittr)
library(MASS)

# Merge the cost data into the trianing data set


# logistic regression
m1	<-	glm(early_mortality	~	comorbidity_score+age+race_group+discharge_status+obesity+Loop_diuretics+Other_diuretics,	data	=	hf_csv,	family	=	"binomial")
exp(coef(m1)) 
m2	<-	glm(early_mortality	~	comorbidity_score+age+race_group+discharge_status+obesity+Loop_diuretics,	data	=	hf_csv,	family	=	"binomial")
anova(m1,m2,test="Chisq")
#Interaction
m3	<-	glm(early_mortality	~	comorbidity_score+age+race_group+Loop_diuretics+Other_diuretics+discharge_status*obesity,	data	=	hf_csv,	family	=	"binomial")
summary(m3)
anova(m1,m3,test="Chisq")
# stepwise
step.model <- m1 %>% stepAIC(trace = FALSE)
summary(step.model)
#LASSO
set.seed(123) 
attach(hf_csv)
# set-up
x_variables<-c("age", "race_group", "discharge_status","ischemic_cardiomyopathy","obesity","comorbidity_score","Loop_diuretics","Other_diuretics")
x_prep<-hf_csv[x_variables]
x <- model.matrix(early_mortality~., x_prep)
y<-early_mortality
# Obtain lambda
cv.lasso <- cv.glmnet(x,y, alpha = 1, family = "binomial")
# Lasso model
lasso.model <- glmnet(x, y, alpha = 1, family = "binomial",lambda = cv.lasso$lambda.min)
summary(lasso.model)
lasso.model$beta
