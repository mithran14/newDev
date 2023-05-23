#!/bin/bash

# Install OpenJDK 8
sudo apt-get install -y openjdk-8-jdk

# Install Maven
sudo apt-get install maven -y

# Install xvfb
sudo apt-get install xvfb -y

# Start xvfb
Xvfb :99 &
export DISPLAY=:99
echo $DISPLAY

# Download and Install Google Chrome
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo dpkg -i google-chrome-stable_current_amd64.deb
sudo apt --fix-broken install -y

# Clone the webdriver-tests repository
git clone https://github.com/TestLeafInc/webdriver-tests

# Move to the webdriver-tests folder
cd webdriver-tests

# Run Maven tests
mvn clean test

sudo apt update
sudo apt-get install awscli -y
aws --version
aws s3api create-bucket --bucket my-test45-bucket --region ap-south-1 --create-bucket-configuration LocationConstraint=ap-south-1 --acl private

aws s3api put-object --bucket my-test45-bucket --key collections/

aws s3 cp /home/ubuntu/webdriver-tests/reports/20-May-2023\ 07-22-57 s3://my-test45-bucket/collections --recursive
aws s3 cp /home/ubuntu/webdriver-tests/reports/20-May-2023\ 07-22-57/result.html s3://my-test45-bucket/run/ 

