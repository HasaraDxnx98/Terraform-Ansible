#!/bin/bash

# Install the "lrzsz" package 
yum -y install lrzsz

# Give user the sudo previledges
echo "adminuser ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/adminuser

# ----------------------------- Registration On REDHAT ----------------------------------------------------
# Registration of image using subscription manager
# subscription-manager register --username <username> --password <password> --auto-attach
subscription-manager register --username "<username>" --password "<password>" --auto-attach

# ----------------------------- Docker Installation -------------------------------------------------------
# Add the external repository
sudo yum config-manager --add-repo=https://download.docker.com/linux/centos/docker-ce.repo

# Install "docker-ce" package
sudo yum -y install docker-ce --allowerasing

# Start and enable the docker daemon
sudo systemctl enable --now docker

# Install docker-compose globally.
# Download the binary file from the project’s GitHub page
curl -L "https://github.com/docker/compose/releases/download/1.23.2/docker-compose-$(uname -s)-$(uname -m)" -o docker-compose

# After the binary file is downloaded, move it to the /usr/local/bin folder, and then make it executable
sudo mv docker-compose /usr/local/bin && sudo chmod +x /usr/local/bin/docker-compose
sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose 

# Login to the Docker Hub account 
docker login dockerhub.globalwavenet.com -u "<username>" -p "<password>"

# ----------------------------- Ansible Installation ------------------------------------------------------
# Add the external repository
subscription-manager repos --enable satellite-tools-6.6-for-rhel-8-x86_64-rpms
subscription-manager repos --enable ansible-2.9-for-rhel-8-x86_64-rpms

# Install python3
yum install python3 -y

# Install ansible 
yum install ansible -y

