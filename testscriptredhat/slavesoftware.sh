#!/bin/bash

# Ensure dependencies are installed
yum update -y && yum install -y awscli jq \
    yum-utils ca-certificates curl gnupg2 wget unzip

# Update the package list
yum update -y

# Install Python 3
yum install -y python3

# Install pip for Python 3
yum install -y python3-pip

# Verify installations
python3 --version
pip3 --version

echo "Python 3 and pip have been installed successfully."

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

# Install Docker
curl -fsSL https://download.docker.com/linux/centos/gpg | gpg --dearmor -o /etc/pki/rpm-gpg/RPM-GPG-KEY-docker
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo

yum update -y && yum install -y docker-ce docker-ce-cli containerd.io

# Enable and start Docker service
systemctl enable docker
systemctl start docker
docker --version

# Java Installation
yum install -y java-17-openjdk java-17-openjdk-devel
java -version

# Maven Installation
wget https://dlcdn.apache.org/maven/maven-3/3.9.9/binaries/apache-maven-3.9.9-bin.tar.gz
tar -xvzf apache-maven-3.9.9-bin.tar.gz
mv apache-maven-3.9.9 /opt/maven

# Set Maven environment variables
export M2_HOME=/opt/maven
export PATH=$M2_HOME/bin:$PATH
echo "export M2_HOME=/opt/maven" >> /etc/profile.d/maven.sh
echo "export PATH=\$M2_HOME/bin:\$PATH" >> /etc/profile.d/maven.sh
source /etc/profile.d/maven.sh

# Verify Maven installation
which mvn
mvn --version

# Sonar Scanner CLI Installation
aws s3 cp s3://sonar-scanner-6/sonar-scanner-cli-6.1.0.4477-linux-x64.zip .
yum install -y unzip
unzip sonar-scanner-cli-6.1.0.4477-linux-x64.zip
mv sonar-scanner-6.1.0.4477-linux-x64 /opt/sonar-scanner

# Set Sonar Scanner environment variables
export SONAR_SCANNER_HOME=/opt/sonar-scanner
export PATH=$SONAR_SCANNER_HOME/bin:$PATH
echo "export SONAR_SCANNER_HOME=/opt/sonar-scanner" >> /etc/profile.d/sonar-scanner.sh
echo "export PATH=\$SONAR_SCANNER_HOME/bin:\$PATH" >> /etc/profile.d/sonar-scanner.sh
source /etc/profile.d/sonar-scanner.sh

# Verify Sonar Scanner installation
which sonar-scanner
