#!/bin/bash

# ssh into the aws linux machine -- opencart app
ssh -i opencart.pem bitnami@ec2-65-0-72-176.ap-south-1.compute.amazonaws.com << EOF

    # install git assuming it does not exist
    sudo apt-get install git -y

    # remove the existing folder
    rm -r -f ubuntu-health-check

    # pull a git repo for the health check up shell script
    git clone https://github.com/TestLeafInc/ubuntu-health-check.git
    cd ubuntu-health-check
    
    # change the shell to write and read
    chmod 777 health-check.sh

    # run the health check script and capture its output
   ./health-check.sh > health-check-output.txt

EOF

# Copy the output file from AWS instance to local machine
scp -i opencart.pem bitnami@ec2-65-0-72-176.ap-south-1.compute.amazonaws.com:~/ubuntu-health-check/health-check-output.txt .

# Read the output file
output=$(cat health-check-output.txt)

# check if the script worked fine (all checks are good)
if [[ $output == *"All checks passed"* ]]; then
    bash run-automated-tests.sh
else
  echo "Health check failed. Not running tests."
fi
