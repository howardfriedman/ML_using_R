# Installing packages
install.packages("readr")
# Load the readr package
library(readr)
# If you need to declare the directory where you will store the downloaded packages 
# install.packages("readr", lib="/data/Rpackages/")
# library(readr, lib.loc="/data/Rpackages/")
# packageDescription("readr")
# help(package="readr")
# ?(package="readr")
# Importing a .CSV file using readr
# hf_csv<-read_csv("~/hdr-proj/cds/Other/R/Data_Files/hfref_sample.csv")
# Convert to a data frame
hf_csv<-as.data.frame (hf_csv)
class(hf_csv)

# Explore the data frame hf_csv
head(hf_csv,n=5)
tail(hf_csv,n=5)
str(hf_csv)
summary(hf_csv)
# Install and Load the dplyr package
install.packages("dplyr")
library(dplyr)
# Glimpse file 
glimpse(hf_csv)
# Select variables
a<-select(hf_csv, patient_id, age, early_mortality)
b<-select(hf_csv, -age)
# Select variables and add filter on age
a<-hf_csv%>%select(patient_id, age, early_mortality)%>%filter(age<65)
# Mutate adds new variables that are functions of existing variables.
a<-hf_csv %>% mutate(mortality_readmission_30=early_mortality*readmission_30)
#  Arrange() changes the ordering of the rows
a<-hf_csv %>% arrange(age)
a<-hf_csv %>% arrange(desc(age))
# Summarise() reduces multiple values down to a single summary 
# Group_by() is used to aggregate 
hf_csv %>% 
  group_by(race_group) %>% 
  summarize (
    n=n(), 
    mortality_rate=mean(early_mortality,na.rm=TRUE),
    readmission_rate=mean(readmission_30,na.rm=TRUE)
  ) %>%
  filter (n>1)
# Import txt files, convert to data frames and merge by patient_id
hf_csv_a<-read.table("~/hdr-proj/cds/Other/R/Data_Files/hfref_sample_a.txt",header = TRUE, sep = "\t", dec = ".")
hf_csv_b<-read_csv("~/hdr-proj/cds/Other/R/Data_Files/hfref_sample_b.csv")
hf_csv_a<-as.data.frame(hf_csv_a)
hf_csv_b<-as.data.frame(hf_csv_b)
hf_csv_ab<-merge(hf_csv_a,hf_csv_b,by.x="patient_id",by.y="patient_id")
hf_csv_ab<-merge(hf_csv_a,hf_csv_b,by="patient_id")

# Import hf_csv_c then bind to hf_csv_ab
hf_csv_c<-read.table("~/hdr-proj/cds/Other/R/Data_Files/hfref_sample_c.txt",header = TRUE, sep = "\t", dec = ".")
hf_csv_c<-as.data.frame(hf_csv_c)
temp<-rbind(hf_csv_ab,hf_csv_c)