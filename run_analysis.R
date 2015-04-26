#Read all the data
X_test<-read.table('UCI HAR Dataset//test/X_test.txt')
X_train<-read.table('UCI HAR Dataset//train/X_train.txt')
feature_names<-read.table('UCI HAR Dataset//features.txt')
y_train<-read.table('UCI HAR Dataset//train/y_train.txt')
y_test<-read.table('UCI HAR Dataset//test/y_test.txt')
activity_labels<-read.table('UCI HAR Dataset//activity_labels.txt')
subject_test<-read.table('UCI HAR Dataset//test/subject_test.txt')
subject_train<-read.table('UCI HAR Dataset//train/subject_train.txt')

#Combine train and test for X
X_full<-rbind(X_train,X_test)

#Add feature names to X
names(X_full)<-feature_names$V2

#Combine train and test for y
y_full<-rbind(y_train,y_test)

#Replace activity ids with labels in y
y_full$V1<-activity_labels$V2[y_full$V1]

#Retain only the mean and std columns
mean_ids<-grep('mean()',names(X_full))
std_ids<-grep('std()',names(X_full))
mean_std_ids<-c(mean_ids,std_ids)
X_full_mean_std<-X_full[,mean_std_ids]

#combine X and y
XY_full_mean_std<-cbind(y_full,X_full_mean_std)

#Combine train and test for subjects
subject_full<-rbind(subject_train,subject_test)

#Create the full tidy dataset
final_data<-cbind(subject_full,XY_full_mean_std)

#Add some last column names
names(final_data)[[1]]<-'Subject'
names(final_data)[[2]]<-'Activity'

#Create a new data set with means grouped by subject and activity
grouped_data<-with(final_data, aggregate(x=final_data[,3:81], by=list(Subject,Activity), FUN=mean))
names(grouped_data)[[1]]<-'Subject'
names(grouped_data)[[2]]<-'Activity'

#Remove all auxillary variables
rm(list = setdiff(ls(), c('final_data','grouped_data')))