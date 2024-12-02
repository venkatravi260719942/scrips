#!/bin/bash

# Update the package list
apt-get update

# Install required packages for Docker
apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    lsb-release \
    wget

# Update the package list
apt update

sudo apt upgrade -y

# Install Python 3
apt install -y python3

# Install pip for Python 3
apt install -y python3-pip

# Verify installations
python3 --version
pip3 --version

echo "Python 3 and pip have been installed successfully."

sudo apt update

# Install required dependencies
sudo apt install -y curl unzip

# Download the AWS CLI v2 installation file
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"

# Unzip the downloaded file
unzip awscliv2.zip

# Run the installer
sudo ./aws/install

# Verify the installation
aws --version

# Ensure dependencies are installed
apt update && apt install -y jq unzip
    apt-transport-https ca-certificates curl gnupg lsb-release wget

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
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

# Set up the stable repository for Ubuntu
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null


# Update the package list to include Docker packages
apt-get update
sudo apt upgrade -y
# Install Docker Engine, CLI, and containerd
apt-get install -y docker-ce docker-ce-cli containerd.io

# Enable Docker to start on boot
systemctl enable docker

# Start Docker service
systemctl start docker

# Verify Docker installation
docker --version


# Java Installation
apt-get install -y fontconfig openjdk-17-jre
apt install -y openjdk-17-jdk-headless
java -version

# Jenkins Installation
apt-get update
apt-get upgrade -y
wget -O /usr/share/keyrings/jenkins-keyring.asc \
  https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key
echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/" | tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null
apt-get update
apt-get install -y jenkins

# Enable and start Jenkins
systemctl enable jenkins
systemctl start jenkins

# Check Jenkins status
systemctl status jenkins --no-pager && systemctl status docker --no-pager

