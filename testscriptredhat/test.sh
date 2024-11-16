#!/bin/sudo bash

# Define VM IPs
master_ip="3.82.21.233"
slave_ip="54.242.33.186"
sonarqube_ip="52.90.155.65"
dev_vm_ip="54.226.69.172"


# Define PEM key file path
PEM_KEY_PATH="test.pem"

# Jenkins_Master
echo "Copying and executing scripts on Jenkins Master..."
scp -i "$PEM_KEY_PATH" mastertesting.sh ec2-user@"${master_ip}":/home/ec2-user/
ssh -i "$PEM_KEY_PATH" ec2-user@"${master_ip}" 'sudo chmod +x /home/ec2-user/mastertesting.sh && sudo bash /home/ec2-user/mastertesting.sh'


# Jenkins_Slave
echo "Copying and executing scripts on Jenkins Slave..."
scp -i "$PEM_KEY_PATH" slavetesting.sh ec2-user@"${slave_ip}":/home/ec2-user/
ssh -i "$PEM_KEY_PATH" ec2-user@"${slave_ip}" 'sudo chmod +x /home/ec2-user/slavetesting.sh && sudo bash /home/ec2-user/slavetesting.sh'


# Sonarqube_server
echo "Copying and executing scripts on SonarQube Server..."
scp -i "$PEM_KEY_PATH" sonartesting.sh ec2-user@"${sonarqube_ip}":/home/ec2-user/
ssh -i "$PEM_KEY_PATH" ec2-user@"${sonarqube_ip}" 'sudo chmod +x /home/ec2-user/sonartesting.sh  && sudo bash /home/ec2-user/sonartesting.sh'


# Dev_server
echo "Copying and executing scripts on Dev VM..."
scp -i "$PEM_KEY_PATH" devtesting.sh ec2-user@"${dev_vm_ip}":/home/ec2-user/
ssh -i "$PEM_KEY_PATH" ec2-user@"${dev_vm_ip}" 'sudo chmod +x /home/ec2-user/devtesting.sh  && sudo bash /home/ec2-user/devtesting.sh'
