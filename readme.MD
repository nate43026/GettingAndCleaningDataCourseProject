##Stated Requirements:
 
You should create one R script called run_analysis.R that does the following. 

1. Merges the training and the test sets to create one data set.
1. Extracts only the measurements on the mean and standard deviation for each measurement. 
1. Uses descriptive activity names to name the activities in the data set
1. Appropriately labels the data set with descriptive activity names. 
1. Creates a second, independent tidy data set with the average of each variable for each activity and each subject.

##Methodology:

The run_analysis.R script will:

1. Check for any package dependencies and install if not found.  The following packages are required for this script: *plyr*.
2. Check for the existence of the data in the working directory.  If it does not find a "UCI HAR Dataset" subdirectory in the working directory, then it will download the source ZIP file from https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip and extract it.
3. Read the raw test and training data and merge them.
4. Label the activities according to the activity_labels.txt file, clean up the names slightly by removing "()" and "-" characters.
5. Transform the Activity values to a more human-readable description (e.g "WALKING", "RUNNING", etc).
6. Group the data by Subject and Activity, with the means of all aggregated measurements that included "mean()" or "std()" in their original descriptions. 
7. Write the new tidy data set to the output file TidyData.csv in the working directory.




##Assumptions:

- Only the measurements with "mean()" or "std()" in their name will be included in the tidy data set.




 