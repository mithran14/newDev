#!/bin/bash

# ssh into the aws linux machine -- opencart app
ssh -i "C:\Users\DELL\Downloads\opencart.pem" bitnami@ec2-15-206-88-77.ap-south-1.compute.amazonaws.com << EOF

    # install git assuming it does not exist
    sudo apt-get install git -y
    sudo apt-get install bc
    sudo apt-get install mailutils

    # remove the existing folder
    rm -r -f TestLeafInc

    # pull a git repo for the health check up shell script
    git clone https://github.com/mithran14/TestLeafInc.git
    cd TestLeafInc
    
    # change the shell to write and read
    #chmod 777 ubuntu-health-check.sh

    # run the health check script and capture its output
    sh ubuntu-health-check.sh > health-check-output.txt

EOF

# Copy the output file from AWS instance to local machine
ssh -i "C:\Users\DELL\Downloads\opencart.pem" bitnami@ec2-15-206-88-77.ap-south-1.compute.amazonaws.com:~/ubuntu-health-check/health-check-output.txt
#scp -i "C:\Users\DELL\Downloads\opencart.pem" bitnami@ec2-15-206-88-77.ap-south-1.compute.amazonaws.com:~/ubuntu-health-check/health-check-output.txt .

# Read the output file
output=$(cat health-check-output.txt)

# check if the script worked fine (all checks are good)
if [[ $output == *"All checks passed"* ]]; then
    bash run-automated-tests.sh
else
  echo "Health check failed. Not running tests."
fi
