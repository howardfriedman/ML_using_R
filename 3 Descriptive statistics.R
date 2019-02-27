# Installing packages
install.packages("Hmisc")
install.packages("pastecs")
install.packages("readr")

# Load the package
library(Hmisc)
library(pastecs)
library(readr)
# Summary descriptive statistics
summary(hf_csv)
describe(hf_csv)
stat.desc(hf_csv)
# Correlations
rcorr(hf_csv$comorbidity_score,hf_csv$age,type="pearson")
rcorr(hf_csv$comorbidity_score,hf_csv$age,type="spearman")
# Frequencies
attach(hf_csv) 
mytable<-table(Other_diuretics,early_mortality)
mytable
summary(mytable)
fisher.test(mytable)
# T-tests
# independent 2-group t-test
t.test(age~early_mortality,var.equal = FALSE) # where age is numeric and early_mortality is a binary factor
# Non-parametric tests
kruskal.test(race_group~early_mortality) 
wilcox.test(age~early_mortality) 