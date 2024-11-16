#!/bin/bash

# Define SonarQube version
SONARQUBE_VERSION="9.9.1.69595"

# Java Installation
sudo amazon-linux-extras enable corretto17
sudo yum install -y java-17-amazon-corretto
java -version
sudo amazon-linux-extras enable corretto17
sudo yum install -y java-17-amazon-corretto-devel
javac -version

# Ensure dependencies are installed
echo "Installing dependencies..."
sudo yum update -y && sudo yum install -y fontconfig jq \
    amazon-linux-extras curl ca-certificates unzip wget || { echo "Dependency installation failed"; exit 1; }
sudo yum upgrade -y

# AWS Configure (optional, remove if not needed)
CONFIG_FILE="aws_config.json"
if [ -f "$CONFIG_FILE" ]; then
    echo "Configuring AWS CLI..."
    mkdir -p ~/.aws
    AWS_ACCESS_KEY_ID=$(jq -r '.aws_access_key_id' "$CONFIG_FILE")
    AWS_SECRET_ACCESS_KEY=$(jq -r '.aws_secret_access_key' "$CONFIG_FILE")
    REGION=$(jq -r '.region' "$CONFIG_FILE")
    OUTPUT=$(jq -r '.output' "$CONFIG_FILE")

    cat <<EOT > ~/.aws/credentials
[default]
aws_access_key_id = $AWS_ACCESS_KEY_ID
aws_secret_access_key = $AWS_SECRET_ACCESS_KEY
EOT

    cat <<EOT > ~/.aws/config
[default]
region = $REGION
output = $OUTPUT
EOT
else
    echo "AWS configuration file not found, skipping AWS configuration."
fi

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

# Install Docker
echo "Installing Docker..."
sudo amazon-linux-extras enable docker
sudo yum install -y docker || { echo "Docker installation failed"; exit 1; }

# Enable and start Docker service
echo "Starting Docker service..."
sudo systemctl enable docker
sudo systemctl start docker
docker --version || { echo "Docker installation verification failed"; exit 1; }

# Create a 2 GB swap file for SonarQube
echo "Creating swap file..."
sudo fallocate -l 2G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile

echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab
free -h

# Create a dedicated user for SonarQube
echo "Creating SonarQube user..."
sudo useradd -m -d /opt/sonarqube -r -s /bin/bash sonarqube || { echo "Failed to create SonarQube user"; exit 1; }

# Download and install SonarQube
echo "Downloading and setting up SonarQube..."
cd /opt || exit
sudo wget https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-$SONARQUBE_VERSION.zip || { echo "SonarQube download failed"; exit 1; }
sudo unzip sonarqube-$SONARQUBE_VERSION.zip || { echo "Failed to unzip SonarQube"; exit 1; }
sudo mv sonarqube-$SONARQUBE_VERSION sonarqube
sudo chown -R sonarqube:sonarqube /opt/sonarqube

# Setup SonarQube as a systemd service
echo "Configuring SonarQube service..."
sudo tee /etc/systemd/system/sonarqube.service > /dev/null <<EOT
[Unit]
Description=SonarQube service
After=network.target

[Service]
Type=simple
User=sonarqube
Group=sonarqube
ExecStart=/opt/sonarqube/bin/linux-x86-64/sonar.sh start
ExecStop=/opt/sonarqube/bin/linux-x86-64/sonar.sh stop
Restart=always
LimitNOFILE=65536

[Install]
WantedBy=multi-user.target
EOT

# Reload systemd, enable, and start SonarQube service
echo "Starting SonarQube service..."
sudo systemctl daemon-reload
sudo systemctl enable sonarqube
sudo systemctl start sonarqube

# Verify SonarQube service status
sudo systemctl status sonarqube --no-pager || { echo "SonarQube service failed to start"; exit 1; }
