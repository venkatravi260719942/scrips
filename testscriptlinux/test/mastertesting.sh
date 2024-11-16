#!/bin/sudo bash

python3 --version
pip --version
docker --version
java --version 
javac --version
wget --version
jenkins --version
sudo systemctl status jenkins --no-pager || { echo "jenkins service failed to start"; exit 1; }
sudo systemctl status docker --no-pager || { echo "docker service failed to start"; exit 1; }
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
hostname