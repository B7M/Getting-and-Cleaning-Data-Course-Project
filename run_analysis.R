# part 1 : basiscs and downloading data
library(dplyr)
library(data.table)
if (!file.exists("Course project")){
  dir.create("./Course project")
}
url='https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip'
download.file(url,destfile = './Course project/FUCI.zip')
setwd("./Course project/")
if (!file.exists("UCI HAR Dataset")) { 
  unzip("FUCI.zip") 
}
# part 2 : loading data
setwd("./UCI HAR Dataset/")
p1="./features.txt"
p2="./activity_labels.txt"
features<-fread(p1)
activities<-fread(p2)
p3="./test/X_test.txt"
Training_set<-fread(p3,col.names = features$V2)
p4="./test/y_test.txt"
Training_labels<-fread(p4,col.names = "label")
p4_1="./test/subject_test.txt"
subject_test<-fread(p4_1,col.names = "ID")
p5="./train/X_train.txt"
Test_set<-fread(p5,col.names = features$V2)
p6="./train/y_train.txt"
Test_label<-fread(p6,col.names = "label")
p6_1="./train/subject_train.txt"
subject_train<-fread(p6_1,col.names = "ID")
Test_set<-cbind(Test_label,Test_set)
Training_set<-cbind(Training_labels,Training_set)
#part 3 : merging data
merged_data<-rbind(Training_set,Test_set)
merged_data<-rbind(subject_test,subject_train)%>%cbind(merged_data)

# part 4 : extracting all the observations with mean and std
TidyData <- merged_data %>% select(ID, label, contains("mean"), contains("std"))
# part 5 : naming the activity in the data set
TidyData$label <- activities[TidyData$label, 2]
# part 6 : labeling the table
names(TidyData)[2] = "activity"
names(TidyData)<-gsub("Acc", "Accelerometer", colnames(TidyData))
names(TidyData)<-gsub("Gyro", "Gyroscope", colnames(TidyData))
names(TidyData)<-gsub("BodyBody", "Body", colnames(TidyData))
names(TidyData)<-gsub("Mag", "Magnitude", colnames(TidyData))
names(TidyData)<-gsub("^t", "Time", colnames(TidyData))
names(TidyData)<-gsub("^f", "Frequency", colnames(TidyData))
names(TidyData)<-gsub("tBody", "TimeBody", colnames(TidyData))
names(TidyData)<-gsub("angle", "Angle", names(TidyData))
names(TidyData)<-gsub("gravity", "Gravity", names(TidyData))
names(TidyData)<-gsub("-mean()", "Mean", names(TidyData), ignore.case = TRUE)
names(TidyData)<-gsub("-std()", "STD", names(TidyData), ignore.case = TRUE)
names(TidyData)<-gsub("-freq()", "Frequency", names(TidyData), ignore.case = TRUE)


# part 7 saving the data
FinalData <- TidyData %>%
  group_by(ID, activity) %>%
  summarise_all(funs(mean))
write.table(FinalData, "FinalData.txt", row.name=FALSE)

