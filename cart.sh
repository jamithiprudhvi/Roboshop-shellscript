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
        echo -e"$2....$R FAILED $N"
        exit 1
    else
        echo -e"$2....$G SUCCESS $N"
    fi
}

if [ $ID -ne 0 ]
then
    echo -e"$R ERROR:: YOU ARE NOT A ROOT USER $N"
    exit 1
else
    echo -e"$G YOU ARE A ROOT USER $N"
fi

dnf module disable nodejs -y &>> $LOGFILE

VALIDATE $? "nodejs disabling"

dnf module enable nodejs:18 -y &>> $LOGFILE

VALIDATE $? "Enabling nodejs"

dnf install nodejs -y &>> $LOGFILE

VALIDATE $? "Installing nodejs"

fi [ $? -ne 0 ]
then
    useradd roboshop &>> $LOGFILE
    VALIDATE $? "creating roboshop user"
else
    echo -e"roboshop user already exists $Y SKIPPING $N"
fi

mkdir -p /app &>> $LOGFILE

VALIDATE $? "Creating app dirctory"

curl -L -o /tmp/cart.zip https://roboshop-builds.s3.amazonaws.com/cart.zip &>> $LOGFILE

VALIDATE $? "Downloading cart application"

cd /app &>> $LOGFILE

unzip /tmp/cart.zip &>> $LOGFILE

VALIDATE $? "Unzipping log file"

cd /app &>> $LOGFILE

npm install &>> $LOGFILE

VALIDATE $? "Installing npm"

cp /home/centos/Roboshop-shellscript/cart.service /etc/systemd/system/cart.service &>> $LOGFILE

VALIDATE $? "Copying cart.service"

systemctl daemon-reload &>> $LOGFILE

VALIDATE $? "Deamon reloading"

systemctl enable cart &>> $LOGFILE

VALIDATE $? "enabling cart"

systemctl start cart &>> $LOGFILE

VALIDATE $? "starting cart"
