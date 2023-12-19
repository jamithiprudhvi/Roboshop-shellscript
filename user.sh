#!/bin/bash

ID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"
TIMESTAMP=$(date +%F-%H-%M-%S)

LOGFILE="/tmp/$0-$TIMESTAMP.log"

VALIDATE(){
    if [ $1 -ne 0 ]
    then 
        echo -e "$2....$R FAILED $N"
        exit 1
    else
        echo -e "$2....$G SUCCESS $N"
    fi
}

if [ $? -ne 0 ]
then
    echo -e "$R ERROR:: Run this script with root user $N"
else
    echo -e "$G You are a root user $N"
fi

dnf module disable nodejs -y &>> $LOGFILE

VALIDATE $? "Disabling nodejs"

dnf module enable nodejs:18 -y &>> $LOGFILE

VALIDATE $? "Enabling nodejs"

dnf install nodejs -y &>> $LOGFILE

VALIDATE $? "Installating nodejs"

id roboshop
if [ $? -ne 0 ]
then
    useradd roboshop &>> $LOGFILE
    VALIDATE $? "Creating roboshop user"
else
    echo "roboshop user already exists"
fi

mkdir -p /app

VALIDATE $? "Creating app directory"

curl -L -o /tmp/user.zip https://roboshop-builds.s3.amazonaws.com/user.zip &>> $LOGFILE

VALIDATE $? "Downloading user application"

cd /app &>> $LOGFILE

if [ $? -ne 0 ]
then 
    unzip /tmp/user.zip &>> LOGFILE
    VALIDATE $? "unzipping userfile"
else
    echo -e "Unzip already done .... $Y SKIPPING $N"
fi



cd /app &>> LOGFILE

npm install &>> LOGFILE

VALIDATE $? "Installing npm"

cp /home/centos/Roboshop-shellscript/user.service /etc/systemd/system/user.service &>> LOGFILE

VALIDATE $? "copying user.service"

systemctl daemon-reload &>> LOGFILE

VALIDATE $? "daemon reloading"

systemctl enable user &>> LOGFILE

VALIDATE $? "enabling user"

systemctl start user &>> LOGFILE

VALIDATE $? "user starting"

cp /home/centos/Roboshop-shellscript/mongo.repo /etc/yum.repos.d/mongo.repo &>> LOGFILE

VALIDATE $? "copying mongo.repo"

dnf install mongodb-org-shell -y &>> LOGFILE

VALIDATE $? "installing mongodb-org-shell"

mongo --host mongodb.prudhvi.online </app/schema/user.js &>> LOGFILE

VALIDATE $? "loading user data into mongodb" 




