#!/bin/bash

# Update the package list and upgrade packages
yum update -y

# Install required packages for Docker
yum install -y \
    yum-utils \
    device-mapper-persistent-data \
    lvm2 \
    curl \
    ca-certificates \
    gnupg2 \
    wget

# Install Python 3
yum install -y python3

# Install pip for Python 3
yum install -y python3-pip

# Verify installations
python3 --version
pip3 --version

echo "Python 3 and pip have been installed successfully."

# Ensure dependencies are installed
yum install -y awscli jq unzip

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
curl -fsSL https://download.docker.com/linux/centos/gpg | sudo gpg --dearmor -o /etc/pki/rpm-gpg/RPM-GPG-KEY-docker

# Set up the stable repository for Docker
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo

# Update the package list to include Docker packages
yum update -y

# Install Docker Engine, CLI, and containerd
yum install -y docker-ce docker-ce-cli containerd.io

# Enable Docker to start on boot
systemctl enable docker

# Start Docker service
systemctl start docker

# Verify Docker installation
docker --version

# Java Installation
yum install -y java-17-openjdk java-17-openjdk-devel
java -version

# Jenkins Installation
yum clean all
wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key
rpm -qa gpg-pubkey | grep -i jenkins

# Install Jenkins
yum install -y jenkins --nogpgcheck
jenkins --version
# Enable and start Jenkins
systemctl enable jenkins
systemctl start jenkins

# Check Jenkins status
systemctl status jenkins --no-pager && systemctl status docker --no-pager

# password
cat /var/lib/jenkins/secrets/initialAdminPassword
