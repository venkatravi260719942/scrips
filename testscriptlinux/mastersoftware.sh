#!/bin/bash

# Update the package list and upgrade packages
sudo yum update -y

# Install required packages for Docker
sudo yum install -y \
    yum-utils \
    device-mapper-persistent-data \
    lvm2 \
    curl \
    ca-certificates \
    gnupg2 \
    wget

# Install Python 3
sudo yum install -y python3

# Install pip for Python 3
sudo yum install -y python3-pip
sudo ln -s /usr/bin/pip3 /usr/bin/pip


# Verify installations
python3 --version
pip --version
pip3 --version

echo "Python 3 and pip have been installed successfully."

# Ensure dependencies are installed
sudo yum install -y aws-cli jq unzip

# AWS Configure
CONFIG_FILE="aws_config.json"

# Extract values from JSON
AWS_ACCESS_KEY_ID=$(jq -r '.aws_access_key_id' "$CONFIG_FILE")
AWS_SECRET_ACCESS_KEY=$(jq -r '.aws_secret_access_key' "$CONFIG_FILE")
REGION=$(jq -r '.region' "$CONFIG_FILE")
OUTPUT=$(jq -r '.output' "$CONFIG_FILE")

# Write to ~/.aws/credentials
mkdir -p ~/.aws
cat <<EOT > ~/.aws/credentials
[default]
aws_access_key_id = $AWS_ACCESS_KEY_ID
aws_secret_access_key = $AWS_SECRET_ACCESS_KEY
EOT

# Write to ~/.aws/config
cat <<EOT > ~/.aws/config
[default]
region = $REGION
output = $OUTPUT
EOT

# Add Docker's official GPG key
sudo yum install -y amazon-linux-extras
amazon-linux-extras enable docker
sudo yum install -y docker

# Enable Docker to start on boot
sudo systemctl enable docker

# Start Docker service
sudo systemctl start docker

# Verify Docker installation
docker --version

# Java Installation
sudo amazon-linux-extras enable corretto17
sudo yum install -y java-17-amazon-corretto
java -version
sudo amazon-linux-extras enable corretto17
sudo yum install -y java-17-amazon-corretto-devel
javac -version

# Jenkins Installation
sudo yum clean all
wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key
rpm -qa gpg-pubkey | grep -i jenkins

# Install Jenkins
sudo yum install -y jenkins --nogpgcheck
jenkins --version

# Enable and start Jenkins
sudo systemctl enable jenkins
sudo systemctl start jenkins

# Check Jenkins status
sudo systemctl status jenkins --no-pager && sudo systemctl status docker --no-pager

# password
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
