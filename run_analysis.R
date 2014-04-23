# This function handles any prerequisites for the analysis: installing packages
# and retrieving data.
fn_Initialize <- function(){
  fn_PkgTest("plyr")
  library(plyr)
  cat("The current working directory is", getwd(),"\n")
  if (!file.exists("UCI HAR Dataset"))
  {
    url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
    temp <- tempfile()
    cat("Downloading data from ", url,"\n")
    download.file(url,temp)
    cat("Extracting zip archive.. ", url,"\n")
    unzip(temp)
    unlink(temp)
  }
}

# This function does all of the data tidying and output generation
fn_CreateOutput <- function(){
  
  cat("Reading raw data files...","\n")

  #read data description files
  features <- read.table("UCI HAR Dataset/features.txt", quote="\"")
  activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt", quote="\"", stringsAsFactors=FALSE)

  #read raw data files: test
  x_test <- read.table("UCI HAR Dataset/test/X_test.txt", quote="\"")
  colnames(x_test) <- features[,2]
  y_test <- read.table("UCI HAR Dataset/test/y_test.txt", quote="\"", col.names=c("Activity"))
  subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt", quote="\"", col.names=c("Subject"))
  
  #read raw data files: train
  x_train <- read.table("UCI HAR Dataset/train/X_train.txt", quote="\"")
  colnames(x_train) <- features[,2]
  y_train <- read.table("UCI HAR Dataset/train/y_train.txt", quote="\"", col.names=c("Activity"))
  subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt", quote="\"", col.names=c("Subject"))
  
  cat("Merging data frames...","\n")
  merged <- rbind(cbind(subject_test,y_test,x_test),cbind(subject_train,y_train,x_train))
  
  cat("Creating tidy data set...","\n")
  exp <- "Subject|Activity|-std\\(\\)|-mean\\(\\)"
  sub <- subset(merged, select = grepl(exp, names(merged)))
  sub$Activity <- mapvalues(sub$Activity,c(activity_labels$V1),c(activity_labels$V2), warn_missing=FALSE)
  
  tidyset <- aggregate(sub[,3:68], list(Subject = sub$Subject,Activity = sub$Activity), mean)
  colnames(tidyset) <- c(gsub("mean\\(\\)","Mean",gsub("std\\(\\)","Std",gsub("-","",names(tidyset)))))
  tidyset <- tidyset[order(tidyset[,1],tidyset[,2]),]
  
  outfile = "TidyData.csv"
  write.csv(tidyset, file = outfile, row.names = FALSE)
  cat("The tidy data set has been written to ", outfile,"\n")

  return(tidyset)
}

# Checks for required packages
fn_PkgTest <- function(x)
{
  if (!require(x,character.only = TRUE))
  {
    install.packages(x,dep=TRUE)
    if(!require(x,character.only = TRUE)) stop("Package not found")
  }
}

# Function to help generate codebook information
fn_CreateCodebook <- function(mydata1)
{
  
  codebook <- data.frame(variable.name=c(names(mydata1))
                        ,variable.desc=c(gsub("^f","Frequency domain signal ",gsub("^t","Time domain signal ",gsub("([X-Z])$"," \\1-axis",gsub("Mean"," measurement mean value ",gsub("Std"," measurement standard deviation",names(mydata1)))))))
  )                     
  knitr::kable(codebook)
}

# Main processing
fn_Initialize()
data = fn_CreateOutput()
