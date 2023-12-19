#!/bin/bash

ID=$(id -u)
TIMESTAMP=$(date +%F-%H-%M-%S)
LOGFILE="/tmp/$0-$TIMESTAMP.log"
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

VALIDATE(){
    if [ $1 -ne 0 ]
    then
        echo -e "$2....$R FAILED $N"
        exit 1
    else
        echo -e "$2....$G SUCCESS $N"
    fi
}

if [ $ID -ne 0 ]
then
    echo -e "$R ERROR:: YOU ARE NOT A ROOT USER $N"
    exit 1
else
    echo -e "$G YOU ARE A ROOT USER $N"
fi

dnf install nginx -y &>> $LOGFILE

VALIDATE $? "Installing nginx"

systemctl enable nginx &>> $LOGFILE

VALIDATE $? "Enabling nginx"

systemctl start nginx &>> $LOGFILE

VALIDATE $? "Starting nginx"

rm -rf /usr/share/nginx/html/* &>> $LOGFILE

VALIDATE $? "removing html file"

curl -o /tmp/web.zip https://roboshop-builds.s3.amazonaws.com/web.zip &>> $LOGFILE

VALIDATE $? "Downloading roboshop file"

cd /usr/share/nginx/html &>> $LOGFILE

unzip /tmp/web.zip &>> $LOGFILE

VALIDATE $? "unzipping"

cp /home/centos/Roboshop-shellscript/roboshop.conf  /etc/nginx/default.d/roboshop.conf &>> $LOGFILE

VALIDATE $? "Copying file"

systemctl restart nginx &>> $LOGFILE

VALIDATE $? "Restarting nginx"