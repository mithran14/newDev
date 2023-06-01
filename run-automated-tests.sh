#!/bin/bash
# Connect to the EC2 instance
ssh -i "opencart.pem" -o StrictHostKeyChecking=no bitnami@ec2-13-127-80-239.ap-south-1.compute.amazonaws.com   << EOF

# Update the package lists for upgrades and new package installations
sudo apt-get update

# Install OpenJDK 8
sudo apt-get install -y openjdk-8-jdk

# Install Maven
sudo apt-get install -y maven
# Install xvfbls

sudo apt-get install -y xvfb

# Start xvfb
Xvfb :99 &
export DISPLAY=:99
# Download and install Google Chrome
if ! command -v google-chrome > /dev/null; then
  wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
  sudo dpkg -i google-chrome-stable_current_amd64.deb
  sudo apt --fix-broken install -y
else
  echo "Google Chrome is already installed."
fi

# Clone the webdriver-tests repository
rm -r -f opencart-webdriver
git clone https://github.com/mithran14/opencart-webdriver.git

# Move to the opencart-webdriver folder
cd opencart-webdriver

# pull the changes if any
git pull

# Run Maven tests
mvn clean test

yes | sudo apt install awscli
aws configure set aws_access_key_id AKIA2R4ARFMK3AW3J3VR
aws configure set aws_secret_access_key 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
aws configure set region ap-south-1
aws configure set output json

# Push the results to S3 (make sure to install and configure awsconfigure before)
aws s3api create-bucket --bucket reports3004-html-selenium3004 --region ap-south-1 --create-bucket-configuration LocationConstraint=ap-south-1
aws s3 sync reports/ s3://reports3004-html-selenium3004


EOF
