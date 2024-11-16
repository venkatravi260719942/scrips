#!/bin/bash

# Ensure script is run as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root"
   exit 1
fi

# Ensure dependencies are installed
echo "Installing essential dependencies..."
yum update -y && yum install -y awscli jq \
    yum-utils curl ca-certificates wget unzip || { echo "Dependency installation failed"; exit 1; }
sudo yum upgrade -y

# Install Python 3 and pip
echo "Installing Python 3 and pip..."
yum install -y python3 python3-pip || { echo "Python 3 or pip installation failed"; exit 1; }

# Verify installations
python3 --version && pip3 --version || { echo "Python or pip verification failed"; exit 1; }
echo "Python 3 and pip have been installed successfully."

# AWS Configure
CONFIG_FILE="aws_config.json"
if [[ -f "$CONFIG_FILE" ]]; then
    echo "Configuring AWS CLI..."
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
    echo "AWS CLI has been configured."
else
    echo "AWS configuration file not found at $CONFIG_FILE. Skipping AWS configuration."
fi

# Install Docker
echo "Installing Docker..."
yum install -y yum-utils device-mapper-persistent-data lvm2 || { echo "Docker dependencies installation failed"; exit 1; }
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo || { echo "Adding Docker repo failed"; exit 1; }
yum install -y docker-ce docker-ce-cli containerd.io || { echo "Docker installation failed"; exit 1; }
sudo yum upgrade -y

# Enable and start Docker service
echo "Enabling and starting Docker service..."
systemctl enable docker
systemctl start docker
docker --version || { echo "Docker verification failed"; exit 1; }

# Add current user to Docker group for non-root access (optional)
# if ! id -nG "$USER" | grep -qw "docker"; then
#     echo "Adding $USER to docker group for non-root access..."
#     usermod -aG docker $USER
# fi

# Java Installation
echo "Installing Java..."
yum install -y java-17-openjdk java-17-openjdk-devel fontconfig || { echo "Java installation failed"; exit 1; }
java -version || { echo "Java verification failed"; exit 1; }

echo "Installation script completed successfully."
