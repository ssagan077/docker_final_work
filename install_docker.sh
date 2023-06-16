#!/bin/bash
## This script installs Docker
op_user="serge"

# Check the script is being run root (sudo)
if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root"
   exit 1
fi

## Remove all old versions
for pkg in docker.io docker-doc docker-compose podman-docker containerd runc; do apt-get remove $pkg; done

## Update apt-get
apt-get update
apt-get install ca-certificates curl gnupg
if [ $? -ne 0 ]; then echo "Something went wrong. Please check log files"; exit 1; fi

## Add Docker’s official GPG key
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
chmod a+r /etc/apt/keyrings/docker.gpg


## Set up the repository
echo \
  "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] \
  https://download.docker.com/linux/ubuntu \
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
  tee /etc/apt/sources.list.d/docker.list > /dev/null
if [ $? -ne 0 ]; then echo "Something went wrong. Please check log files"; exit 1; fi

## Install Docker + Compose
apt-get update
apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
if [ $? -ne 0 ]; then echo "Something went wrong. Please check log files"; exit 1; fi

## Adding user to Group
usermod -aG docker $op_user


## Verify that the Docker Engine installation is successful
docker run hello-world
