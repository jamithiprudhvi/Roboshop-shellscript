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

curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash &>> $LOGFILE

VALIDATE $? "Configureing YUM Repos from the script provided by vendor"

curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash &>> $LOGFILE

VALIDATE $? "Configureing YUM Repos for RabbitMQ."

dnf install rabbitmq-server -y &>> $LOGFILE

VALIDATE $? "Installing rabbitmq"

systemctl enable rabbitmq-server &>> $LOGFILE

VALIDATE $? "Enabling rabbitmq"

systemctl start rabbitmq-server &>> $LOGFILE

VALIDATE $? "Starting rabbit mq"

rabbitmqctl add_user roboshop roboshop123 &>> $LOGFILE

VALIDATE $? " creating default username / password"

rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>> $LOGFILE

VALIDATE $? "Setting permissions"

