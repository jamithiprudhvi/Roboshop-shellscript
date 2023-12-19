#!/bin/bash
ID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

TIMESTAMP=$(date +%F-%H-%M-%S)
LOGFILE="/tmp/$0-$TIMESTAMP.log"

echo "script started executing at $TIMESTAMP" &>> $LOGFILE
VALIDATE(){
    if [ $1 -ne 0 ]
    then
        echo -e " $2 .... $R FAILED $N"
    else
        echo -e " $2 .... $G SUCCESS $N"
    fi
}

if [ $ID -ne 0 ]
then
    echo -e "$R you are not a root user $N"
    exit 1
else
    echo -e "$G you are a root user $N"
fi

dnf install golang -y &>> $LOGFILE

VALIDATE $? "Installing golang"

id roboshop  # roboshop user does not exit , then it is failure
if [ $? -ne 0 ]
then
    useradd roboshop &>> $LOGFILE
    VALIDATE $? "user roboshop creation"
else
    echo -e "roboshop user already exists $Y SKIPPING $N"
fi

mkdir -P /app &>> $LOGFILE

VALIDATE $? "creating app directory"

curl -L -o /tmp/dispatch.zip https://roboshop-builds.s3.amazonaws.com/dispatch.zip &>> $LOGFILE

VALIDATE $? "Unzipping dispatch file"

cd /app &>> $LOGFILE

VALIDATE $? " moving to app directory"

unzip /tmp/dispatch.zip &>> $LOGFILE

VALIDATE $? " Unzipping dispatch file"

cd /app &>> $LOGFILE

go mod init dispatch &>> $LOGFILE

VALIDATE $? " init dispatching"

go get &>> $LOGFILE

VALIDATE $? "go getting"

go build &>> $LOGFILE

VALIDATE $? "go building"

systemctl daemon-reload &>> $LOGFILE

VALIDATE $? " Deamon reloading"

systemctl enable dispatch &>> $LOGFILE

VALIDATE $? " Enabling dispatching"

systemctl start dispatch &>> $LOGFILE

VALIDATE $? " start dispatching"
