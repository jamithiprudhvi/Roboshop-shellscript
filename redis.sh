#!/bin/bash

ID=$(id -u)
TIMESTAMP=$(date +%F-%H-%M-%S)
LOGFILE="/tmp/$0-$TIMESTAMP.log"

R="\e[31m"
G="\e[32m"
Y="\e[33"
N="\e[0m"
exec &>$LOGFILE

VALIDATE(){
    if [ $1 -ne 0 ]
    then
        echo -e "$2 .... $R FAILED $N"
        exit 1
    else
        echo -e "$2 .... $G success $N"
    fi
}

if [ $ID -ne 0 ]
then 
    echo -e "$R ERROR:: You are not a root user $N"
    exit 1
else
    echo -e "$G You are a root user $N"
fi

dnf install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y &>> $LOGFILE

VALIDATE $? "Installing rpms.remirepo.net"

dnf module enable redis:remi-6.2 -y &>> $LOGFILE

VALIDATE $? "Enabling redis:remi-6.2"

dnf install redis -y &>> $LOGFILE

VALIDATE $? "Installing redis"

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/redis.conf &>> $LOGFILE

systemctl enable redis &>> $LOGFILE

VALIDATE $? " Enabling redis"

systemctl start redis &>> $LOGFILE

VALIDATE $? "Starting redis"
