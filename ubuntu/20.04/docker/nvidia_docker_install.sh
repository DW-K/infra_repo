#!/bin/sh

sudo sh ./docker_install.sh

# install Nvidia toolkit
curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | \
  sudo apt-key add -
distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | \
  sudo tee /etc/apt/sources.list.d/nvidia-docker.list

sudo apt-get update

# install nvidia-docker
sudo apt-get install -y nvidia-docker2

sudo pkill -SIGHUP dockerd
sudo service docker start
sudo service docker restart
# sudo rm /etc/apt/sources.list.d/nvidia-container-toolkit.list
