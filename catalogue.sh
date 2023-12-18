#!/bin/bash

ID=$(id -u)
TIMESTAMP=$(date +%F-%H-%M-%S)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

LOGFILE="/tmp/$0-$TIMESTAMP.log"
VALIDATE(){
    if [ $1 -ne 0 ]
    then
        echo "$2 .... $R FAILED $N"
    else
        echo "$2 .... $G SUCCESS $N"
    fi

}

if [ $ID -ne 0 ]
then
    echo "$R ERROR:: you are not a root user $N"
    exit 1
else
    echo "$G you are a root user $N"
fi

dnf module disable nodejs -y &>> LOGFILE

VALIDATE $? "nodejs disabled" 

dnf module enable nodejs:18 -y &>> LOGFILE

VALIDATE $? "nodejs:18" enabled 

dnf install nodejs -y &>> LOGFILE

VALIDATE $? "nodejs Installed" 

useradd roboshop &>> LOGFILE

VALIDATE $? "creating roboshop user" 

mkdir /app &>> LOGFILE

VALIDATE $? "creating app Directory" 

curl -o /tmp/catalogue.zip https://roboshop-builds.s3.amazonaws.com/catalogue.zip &>> LOGFILE


VALIDATE $? "Downloading catalogue application" 

cd /app &>> LOGFILE

unzip /tmp/catalogue.zip &>> LOGFILE


VALIDATE $? "unzipping catalogue application" 

cd /app &>> LOGFILE

npm install &>> LOGFILE


VALIDATE $? "Installing npm" 

cp /home/centos/Roboshop-shellscript/catalogue.service /etc/systemd/system/catalogue.service &>> LOGFILE


VALIDATE $? "copying catalogue.service file" 

systemctl daemon-reload &>> LOGFILE


VALIDATE $? "daemon-reloading" 

systemctl enable catalogue &>> LOGFILE


VALIDATE $? "enabling catalogue" 

systemctl start catalogue &>> LOGFILE


VALIDATE $? "starting catalogue" 

cp /home/centos/Roboshop-shellscript/mongo.repo /etc/yum.repos.d/mongo.repo &>> LOGFILE


VALIDATE $? "coping mongo.repo" 

dnf install mongodb-org-shell -y &>> LOGFILE

VALIDATE $? "Installing mongodb-org-shell" 

mongo --host mongodb.prudhvi.online </app/schema/catalogue.js &>> LOGFILE


VALIDATE $? "loading catalogue data into mongodb" 



