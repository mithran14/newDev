#!/bin/bash
# Connect to the EC2 instance
ssh -i ubuntu-selenium.pem ubuntu@ec2-65-2-71-131.ap-south-1.compute.amazonaws.com  << EOF

# Update the package lists for upgrades and new package installations
sudo apt-get update

# Install OpenJDK 8
sudo apt-get install -y openjdk-8-jdk

# Install Maven
sudo apt-get install -y maven

# Install xvfb
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
git clone https://github.com/TestLeafInc/opencart-webdriver

# Move to the webdriver-tests folder
cd opencart-webdriver

# pull the changes if any
git pull

# Run Maven tests
mvn clean test

# Push the results to S3 (make sure to install and configure awsconfigure before)
aws s3 sync reports/ s3://reports-html-selenium

EOF