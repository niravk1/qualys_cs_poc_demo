#!/bin/bash

export DEBIAN_FRONTEND=noninteractive

# Install prereqs
apt update > /dev/null
apt install -y python3-pip apt-transport-https ca-certificates curl software-properties-common > /dev/null
# Install docker
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add - > /dev/null
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
apt update -qq > /dev/null
apt install -y docker-ce > /dev/null
#usermod -aG docker ubuntu > /dev/null
# Install Azure CLI
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash > /dev/null

# Pull qualys CS sensor image
docker pull qualys/qcs-sensor:latest -q
sleep 1
# Start qualys CS sensor container
docker run -d --restart on-failure -v /var/run/docker.sock:/var/run/docker.sock:ro -v /etc/qualys:/usr/local/qualys/qpa/data/conf/agent-data -v /usr/local/qualys/sensor/data:/usr/local/qualys/qpa/data --env-file /tmp/.qualysenv.list --net=host --name qualys-container-sensor qualys/qcs-sensor:latest --registry-sensor

exit 0
