#reading the data
setwd("C:/Users/victor.rotariu/Desktop/workdir/clean/UCI HAR Dataset")
x_test<-read.table("./test/X_test.txt")
y_test<-read.table("./test/y_test.txt")
subject_test<-read.table("./test/subject_test.txt")
x_train<-read.table("./train/X_train.txt")
y_train<-read.table("./train/y_train.txt")
subject_train<-read.table("./train/subject_train.txt")

#merging
data_x<-rbind(x_train, x_test)
data_y<-rbind(y_train, y_test)
data_subject<-rbind(subject_train, subject_test)
data<-cbind(data_x, data_y, data_subject)

#mean and standard dev
getmean <- sapply(data, mean)
getsd <- sapply(data, sd)

#name of dataset
human_activity_recognition <- data

#names for variables
name<-read.table("./features.txt",stringsAsFactors = F)
namenew<-strsplit(name[,2],"-")

tt<-NULL
for(i in 1:502){
        tt[i]<-paste(namenew[[i]][2],namenew[[i]][1],
                     "-",namenew[[i]][3],sep="")
}
for(i in 503:554){
        tt[i]<-paste(namenew[[i]][2],namenew[[i]][1],sep="")
}
ttt<-NULL
for(i in 555:561)
        ttt[i]<-namenew[[i]]


t<-chartr("()", "OF", tt)
dataname<-c(t,ttt[555:561],"labels","subject")
colnames(human_activity_recognition)<-dataname

human_activity_recognition$subject<-factor(human_activity_recognition$subject)

##tidy dataset with the average of each variable for each activity and each subject

stat<-paste("stat",1:561)
for(i in 1:561){
        assign(stat[i],tapply(human_activity_recognition[,i],human_activity_recognition$subject,mean))
}

statdata<-NULL
for(i in 1:561){
        statdata<-rbind(statdata,get(stat[i]))
}
rownames(statdata)<-dataname[-c(562,563)]

write.table(statdata,"statdata.txt",quote = F)
write.table(human_activity_recognition,"Human_Activity_Recognition.txt",quote = F)