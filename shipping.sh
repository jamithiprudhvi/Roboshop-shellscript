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
        echo -e "$2.... $R FAILED  $N"
        exit 1
    else
        echo -e "$2 ....$G SUCCESS $N"
    fi
}

if [ $ID -ne 0 ]
then
    echo -e "$R ERROR:: RUN THIS SCRIPT WITH ROOT USER $N"
    exit 1
else
    echo -e "$G YOU ARE A ROOT USER $N"
fi

dnf install maven -y &>> $LOGFILE 

VALIDATE $? "Installing maven"

useradd roboshop
if [ $? -ne 0 ]
then 
    useradd roboshop
    VALIDATE $? "user roboshop created"
else
    echo -e "user already exists $Y .... SKIPPING $N"
fi

mkdir -p /app &>> $LOGFILE

VALIDATE $? " creating app directory"

curl -L -o /tmp/shipping.zip https://roboshop-builds.s3.amazonaws.com/shipping.zip &>> $LOGFILE

VALIDATE $? "Downloading shipping application"

cd /app &>> $LOGFILE

unzip /tmp/shipping.zip &>> $LOGFILE

VALIDATE $? "unzipping shipping application"

cd /app &>> $LOGFILE

mvn clean package &>> $LOGFILE

VALIDATE $? "cleaning mvn packages"

mv target/shipping-1.0.jar shipping.jar &>> $LOGFILE

VALIDATE $? "targeting shipping.jar"

cp /home/centos/Roboshop-shellscript/shipping.service /etc/systemd/system/shipping.service &>> $LOGFILE

VALIDATE $? "copying shipping .service"

systemctl daemon-reload &>> $LOGFILE

VALIDATE $? "Deamon reloading"

systemctl enable shipping &>> $LOGFILE

VALIDATE $? "Enabling shipping"

systemctl start shipping &>> $LOGFILE

VALIDATE $? "starting shipping"

dnf install mysql -y &>> $LOGFILE

VALIDATE $? "Installing mysql"

mysql -h mysql.prudhvi.online -uroot -pRoboShop@1 < /app/schema/shipping.sql &>> $LOGFILE

VALIDATE $? "Loading schema"

systemctl restart shipping &>> $LOGFILE

VALIDATE $? "Restart shipping"



