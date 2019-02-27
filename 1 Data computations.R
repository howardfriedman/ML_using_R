# Installing packages
install.packages("readr")
# Load the readr package
library(readr)
# If you need to declare the directory where you will store the downloaded packages 
# install.packages("readr", lib="/data/Rpackages/")
# library(readr, lib.loc="/data/Rpackages/")
packageDescription("readr")
help(package="readr")
?(package="readr")
# Importing a .CSV file using readr
#hf_csv<-read_csv("D:/Users/friedman/Desktop/ML course materials/New_Data_Files/hfref_sample.csv")
hf_csv<-read_csv("~/hdr-proj/cds/Other/R/Data_Files/hfref_sample.csv")
head(hf_csv,n=5)
tail(hf_csv,n=5)
# Data types in R include scalars, vectors, lists, matrices and dataframes
(u <- ceiling(-1.8)) 
(v <- floor(1.8+1)) 
(w <- log(1.8)) 
(x <- trunc(-1.8-1)) 
(y <- round(-1.81*10)) 
(z <- exp(4)) 
print(u)
# Boolean expressions
3 + 4 < 5
10 + 4 == 7 + 7
(2 < 4) & (6 > 7)
(2 < 4) | (6 > 7)
! (6 > 7)


# When creating a vector or matrix "c" stands for concatenate; the array and seq command can also be used

b <- c(1,5.3,6,-2,4) # numeric vector
c <- c("one","two","three","four") # character vector
d <- c(TRUE,FALSE,TRUE,FALSE) #logical vector
e <- array(c(3,5), 10)
f <- seq(3, 22, 2)

# Determine type of element and length
typeof(b)
length(f)
# to select elements of a vetor or matrix use the [] 
f[1:3]
f[c(1,2)]

# Matrices
y<-matrix(1:24, nrow=6,ncol=4)

cells <- c(1,26,24,68,4,7)
rnames <- c("R1", "R2 ", "R3")
cnames <- c("C1", "C2") 
y <- matrix(cells, nrow=3, ncol=2, byrow=TRUE,
            dimnames=list(rnames, cnames))
z = rbind(y, c(37,38))
rownames(z)[4]<-"R4"
z = cbind(y, c(37,38,39))
colnames(z)[3]<-"C3"
# Data frames
d <- c(1,3,5,7)
e <- c("red", "white", "red", NA)
f <- c(TRUE,TRUE,TRUE,FALSE)
mydata <- data.frame(d,e,f)
names(mydata) <- c("NumberID","Color","Test_result") 

# Lists
# Create a list with two values.
A = list()
A$banana = 3
A$pear = 4
A$fruit = A$banana + A$pear
# User-defined functions
f = function(x, y) { 
  return(x / (1+y^2)) 
} 
(a = f(1, 2))
      
# Factors
# variable gender with 20 "male" entries and 
# 30 "female" entries 
gender <- c(rep("male",20), rep("female", 30)) 
gender_as_factor <- factor(gender) 
# stores gender as 20 1s and 30 2s and associates
# 1=female, 2=male internally (alphabetically)
# R now treats gender as a nominal variable 
class(gender)
typeof(gender)
