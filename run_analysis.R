run_analysis <- function(){
    library(dplyr)
    #Import Data
    test_sub <- read.table("./UCI HAR Dataset/test/subject_test.txt")
    test_x <- read.table("./UCI HAR Dataset/test/x_test.txt")
    test_y <- read.table("./UCI HAR Dataset/test/y_test.txt") #test labels
    
    train_sub <- read.table("./UCI HAR Dataset/train/subject_train.txt") #which subject
    train_x <- read.table("./UCI HAR Dataset/train/x_train.txt") #each row is one observation, column headings in the features file
    train_y <- read.table("./UCI HAR Dataset/train/y_train.txt") #y labels, which activity
    
    features_labels <- read.table("./UCI HAR Dataset/features.txt") #features label
    activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt") #activity label
    
    #Separate Feature Names in to Columns
    names(features_labels)[1] <- "id"
    features_labels <- separate(features_labels, V2,c("sensor","measure","dimension"),sep="-")
    
    #Tidy Column Names
    names(test_x) <- sapply(colnames(test_x),function(x)sub("V","",x))
    names(test_y) <- "activity_id"
    names(test_sub) <- "subject_id"
    
    names(train_x) <- sapply(colnames(train_x),function(x)sub("V","",x))
    names(train_y) <- "activity_id"
    names(train_sub) <- "subject_id"
    
    names(activity_labels) <- c("id","activity")
    
    #Add Subjects and Activity
    test_x <- cbind(test_x, test_y, test_sub)
    train_x <- cbind(train_x, train_y, train_sub)
    
    #Merge and Melt Data
    tidy_data <- rbind(train_x,test_x) %>%
        gather(key ="feature_id", value="value", -c(activity_id,subject_id))
    
    #Merge Labels
    tidy_data <- tidy_data %>%
        merge(features_labels,by.x="feature_id",by.y="id") %>%
        merge(activity_labels,by.x="activity_id",by.y="id") %>%
        select(-activity_id,-feature_id)
    
    #Keep only Mean and Standard Deviation
    filtered_data <- filter(tidy_data, measure== "mean()" | measure=="std()")
    write.table(filtered_data,"./tidy_HAR_dataset.txt")
        
    #Calculate Average for each subject, variable, and activity
    avg_data <- group_by(filtered_data,subject_id,activity,sensor,measure,dimension) %>%
        summarize(average = mean(value))
    write.table(avg_data,"./tidy_HAR_average_dataset.txt")
        
    #cleanup
    rm(test_sub,test_x,test_y)
    rm(train_sub,train_x,train_y)
    rm(features_labels,activity_labels)
    rm(tidy_data)
}

library(dataMaid)
makeCodebook(filtered_data)
makeCodebook(avg_data)
