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
        echo -e "$2 .... $R FAILED $N"
    else
        echo -e "$2 .... $G SUCCESS $N"
    fi

}

if [ $ID -ne 0 ]
then
    echo -e "$R ERROR:: you are not a root user $N"
    exit 1
else
    echo -e "$G you are a root user $N"
fi

dnf install python36 gcc python3-devel -y &>> $LOGFILE

VALIDATE $? "Installing python"

id roboshop
if [ $? -ne 0 ]
then
    useradd roboshop &>> $LOGFILE
    VALIDATE $? "Creating roboshop user"
else
    echo -e "user roboshop already exists $Y ....SKIPPING $N"
fi

mkdir -p /app &>> $LOGFILE

VALIDATE $? "Creating app directory"

curl -L -o /tmp/payment.zip https://roboshop-builds.s3.amazonaws.com/payment.zip &>> $LOGFILE

VALIDATE $? "Downloading payment application"

cd /app &>> $LOGFILE

VALIDATE $? "Moving to app directory"

unzip /tmp/payment.zip &>> $LOGFILE

VALIDATE $? "Unzipping payment"

cd /app &>> $LOGFILE


pip3.6 install -r requirements.txt &>> $LOGFILE

VALIDATE $? "Installing pip"

cp /home/centos/Roboshop-shellscript/payment.service /etc/systemd/system/payment.service &>> $LOGFILE

VALIDATE $? "Copying files"

systemctl daemon-reload &>> $LOGFILE

VALIDATE $? "Deamon reloading"

systemctl enable payment &>> $LOGFILE

VALIDATE $? "Enabling payments"

systemctl start payment &>> $LOGFILE

VALIDATE $? "starting payments"

