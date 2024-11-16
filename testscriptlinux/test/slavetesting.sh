#!/bin/sudo bash

python3 --version
pip --version
docker --version
java --version 
javac --version
sudo systemctl status docker --no-pager || { echo "docker service failed to start"; exit 1; }
wget --version
mvn --version
sonar-scanner --version
which sonar-scanner
which mvn
hostname