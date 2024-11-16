#!/bin/sudo bash

# Define VM IPs
master_ip="3.87.77.183"
slave_ip="50.19.147.211"
sonarqube_ip="54.159.22.29"
dev_vm_ip="34.201.44.132"


# Define PEM key file path
PEM_KEY_PATH="test.pem"

# Jenkins_Master
echo "Copying and executing scripts on Jenkins Master..."
scp -i "$PEM_KEY_PATH" mastersoftware.sh ec2-user@"${master_ip}":/home/ec2-user/
# scp -i "$PEM_KEY_PATH" rm_master_software.sh ec2-user@"${master_ip}":/home/ec2-user/
scp -i "$PEM_KEY_PATH" aws_config.json ec2-user@"${master_ip}":/home/ec2-user/

# Set permissions and execute scripts on Jenkins Master
ssh -i "$PEM_KEY_PATH" ec2-user@"${master_ip}" 'sudo chmod +x /home/ec2-user/mastersoftware.sh && sudo bash /home/ec2-user/mastersoftware.sh'
# ssh -i "$PEM_KEY_PATH" ec2-user@"${master_ip}" 'sudo bash /home/ec2-user/rm_master_software.sh'
# Change hostname of the master VM
ssh -i "$PEM_KEY_PATH" ec2-user@"${master_ip}" 'sudo hostnamectl set-hostname jenkins-master'
ssh -i "$PEM_KEY_PATH" ec2-user@"${master_ip}" 'hostname'
ssh -i "$PEM_KEY_PATH" ec2-user@"${master_ip}" 'hostname -f'

# Jenkins_Slave
echo "Copying and executing scripts on Jenkins Slave..."
scp -i "$PEM_KEY_PATH" slavesoftware.sh ec2-user@"${slave_ip}":/home/ec2-user/
# scp -i "$PEM_KEY_PATH" slave_rm_software.sh ec2-user@"${slave_ip}":/home/ec2-user/
scp -i "$PEM_KEY_PATH" aws_config.json ec2-user@"${slave_ip}":/home/ec2-user/

# Set permissions and execute scripts on Jenkins Slave
ssh -i "$PEM_KEY_PATH" ec2-user@"${slave_ip}" 'sudo chmod +x /home/ec2-user/slavesoftware.sh && sudo bash /home/ec2-user/slavesoftware.sh'
# ssh -i "$PEM_KEY_PATH" ec2-user@"${slave_ip}" 'sudo bash /home/ec2-user/slave_rm_software.sh'
# Change hostname of the Slave VM
ssh -i "$PEM_KEY_PATH" ec2-user@"${slave_ip}" 'sudo hostnamectl set-hostname jenkins-slave'
ssh -i "$PEM_KEY_PATH" ec2-user@"${slave_ip}" 'hostname'
ssh -i "$PEM_KEY_PATH" ec2-user@"${slave_ip}" 'hostname -f'

# Sonarqube_server
echo "Copying and executing scripts on SonarQube Server..."
scp -i "$PEM_KEY_PATH" sonarqube-server-software.sh ec2-user@"${sonarqube_ip}":/home/ec2-user/
# scp -i "$PEM_KEY_PATH" sonar_rm_software.sh ec2-user@"${sonarqube_ip}":/home/ec2-user/
scp -i "$PEM_KEY_PATH" aws_config.json ec2-user@"${sonarqube_ip}":/home/ec2-user/

# Set permissions and execute scripts on SonarQube Server
ssh -i "$PEM_KEY_PATH" ec2-user@"${sonarqube_ip}" 'sudo chmod +x /home/ec2-user/sonarqube-server-software.sh  && sudo bash /home/ec2-user/sonarqube-server-software.sh'
# ssh -i "$PEM_KEY_PATH" ec2-user@"${sonarqube_ip}"  'sudo bash /home/ec2-user/sonar_rm_software.sh'
# Change hostname of the Sonarqube server
ssh -i "$PEM_KEY_PATH" ec2-user@"${sonarqube_ip}" 'sudo hostnamectl set-hostname sonarqube'
ssh -i "$PEM_KEY_PATH" ec2-user@"${sonarqube_ip}" 'hostname'
ssh -i "$PEM_KEY_PATH" ec2-user@"${sonarqube_ip}" 'hostname -f'

# Dev_server
echo "Copying and executing scripts on Dev VM..."
scp -i "$PEM_KEY_PATH" dev_vm_software.sh ec2-user@"${dev_vm_ip}":/home/ec2-user/
# scp -i "$PEM_KEY_PATH" rm_dev_software.sh ec2-user@"${dev_vm_ip}":/home/ec2-user/
scp -i "$PEM_KEY_PATH" aws_config.json ec2-user@"${dev_vm_ip}":/home/ec2-user/

# Set permissions and execute scripts on Dev VM
ssh -i "$PEM_KEY_PATH" ec2-user@"${dev_vm_ip}" 'sudo chmod +x /home/ec2-user/dev_vm_software.sh  && sudo bash /home/ec2-user/dev_vm_software.sh'
# ssh -i "$PEM_KEY_PATH" ec2-user@"${dev_vm_ip}" 'sudo bash /home/ec2-user/rm_dev_software.sh'
# Change hostname of the Dev server
ssh -i "$PEM_KEY_PATH" ec2-user@"${dev_vm_ip}" 'sudo hostnamectl set-hostname develope'
ssh -i "$PEM_KEY_PATH" ec2-user@"${dev_vm_ip}" 'hostname'
ssh -i "$PEM_KEY_PATH" ec2-user@"${dev_vm_ip}" 'hostname -f'

# Final message
echo "Scripts executed successfully on all VMs."
