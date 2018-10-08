---
title: "README"
---

## run_analysis.R

run_analysis.R takes in the raw data files from the "Human Activity Recognition Using Smartphones Data Set" and converts the files into a Tidy Dataset. 

The script requires the following files:

```{r}
    #Input files
    test_sub <- read.table("./UCI HAR Dataset/test/subject_test.txt")
    test_x <- read.table("./UCI HAR Dataset/test/x_test.txt")
    test_y <- read.table("./UCI HAR Dataset/test/y_test.txt") #test labels
    
    train_sub <- read.table("./UCI HAR Dataset/train/subject_train.txt") #which subject
    train_x <- read.table("./UCI HAR Dataset/train/x_train.txt") #each row is one observation, column headings in the features file
    train_y <- read.table("./UCI HAR Dataset/train/y_train.txt") #y labels, which activity
    
    features_labels <- read.table("./UCI HAR Dataset/features.txt") #features label
    activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt") #activity label
```

The output files are 2 Tidy datasets. One containing just raw data that contaains the mean and std measurements and the second contains the average of the mean and std values from different trials for each subject. 

```{r}
    #Keep only Mean and Standard Deviation and output file
    filtered_data <- filter(tidy_data, measure== "mean()" | measure=="std()")
    write.table(filtered_data,"./tidy_HAR_dataset.txt")

    #Calculate Average for each subject, variable, and activity and output file
    avg_data <- group_by(filtered_data,subject_id,activity,sensor,measure,dimension) %>%
        summarize(average = mean(value))
    write.table(avg_data,"./tidy_HAR_average_dataset.txt")
```