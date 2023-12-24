#!/bin/bash

# AWS Configuration
AWS_REGION="us-east-1"
AMI_ID="ami-03265a0778a880afb"
INSTANCE_TYPE="t2.micro"
SECURITY_GROUP_ID="sg-0d0ec1361a0648bef"


# EC2 Instance Launch
echo "Creating EC2 instance..."
aws ec2 run-instances \
  --region $AWS_REGION \
  --image-id $AMI_ID \
  --instance-type $INSTANCE_TYPE \
  --security-group-ids $SECURITY_GROUP_ID 


# Optionally, you can wait for the instance to be in the 'running' state
echo "Waiting for the instance to be in the 'running' state..."
aws ec2 wait instance-running --region $AWS_REGION --filters "Name=instance-state-name,Values=running"

echo "EC2 instance created successfully."
