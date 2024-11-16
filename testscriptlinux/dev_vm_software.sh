#!/bin/bash

# Ensure script is run as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root"
   exit 1
fi

# Update and install essential dependencies
echo "Installing essential dependencies..."
yum update -y && yum install -y awscli jq \
    amazon-linux-extras curl ca-certificates wget unzip || { echo "Dependency installation failed"; exit 1; }
yum upgrade -y

# Enable extras and update the system
amazon-linux-extras enable python3.8
amazon-linux-extras enable docker

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
yum install -y docker || { echo "Docker installation failed"; exit 1; }

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

# Install Java
# Java Installation
sudo amazon-linux-extras enable corretto17
sudo yum install -y java-17-amazon-corretto
java -version
sudo amazon-linux-extras enable corretto17
sudo yum install -y java-17-amazon-corretto-devel
javac -version

echo "Installation script completed successfully."
