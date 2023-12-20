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
        echo -e "$R $2....FAILED  $N"
        exit 1
    else
        echo -e "$G $2 ....SUCCESS $N"
    fi
}

if [ $ID -ne 0 ]
then
    echo -e "$R ERROR:: RUN THIS SCRIPT WITH ROOT USER $N"
    exit 1
else
    echo -e "$G YOU ARE A ROOT USER $N"
fi

dnf module disable mysql -y &>>$LOGFILE

VALIDATE $? "mysql disabling"

cp /home/centos/Roboshop-shellscript/mysql.repo /etc/yum.repos.d/mysql.repo &>> $LOGFILE

VALIDATE $? "Copying files"

dnf install mysql-community-server -y &>> $LOGFILE

VALIDATE $? "Installing mysql"

systemctl enable mysqld &>> $LOGFILE

VALIDATE $? "Enabling mysql"

systemctl start mysqld &>> $LOGFILE

VALIDATE $? "starting mysql"

mysql_secure_installation --set-root-pass RoboShop@1 &>> $LOGFILE

VALIDATE $? "Setting root password"

mysql -uroot -pRoboShop@1 &>> $LOGFILE

VALIDATE $? "checking rootpassword"
