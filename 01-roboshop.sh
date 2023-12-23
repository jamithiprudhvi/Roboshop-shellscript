#!/bin/bash

AMI=ami-03265a0778a880afb
SG_ID=sg-0d0ec1361a0648bef #replace with your SG ID
INSTANCES=("mongodb" "redis" "mysql" "rabbitmq" "catalogue" "user" "cart" "shipping" "payment" "dispatch" "web")

for i in "${INSTANCES[@]}"
do
    if [ $i == "mongodb" ] || [ $i == "mysql" ] || [ $i == "shipping" ]
    then
        INSTANCE_TYPE="t3.small"
    else
        INSTANCE_TYPE="t2.micro"
    fi

  aws ec2 run-instances --image-id ami-03265a0778a880afb --instance-type $INSTANCE_TYPE --security-group-ids sg-0d0ec1361a0648bef --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$i}]" 
done