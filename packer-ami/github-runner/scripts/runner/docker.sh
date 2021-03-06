#!/bin/sh
sudo apt-get update
sudo apt-get -y upgrade

sudo apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    lsb-release \
    software-properties-common

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update
sudo apt-get -y upgrade
sudo apt-get install docker-ce docker-ce-cli containerd.io -y

sudo groupadd docker
sudo usermod -aG docker ubuntu

sudo systemctl enable docker

