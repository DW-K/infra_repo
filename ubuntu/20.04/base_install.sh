#!/bin/sh
# sudo cp apt_repo/sources.list /etc/apt/sources.list

sudo apt update
sudo apt-get update

sudo apt-get install -y vim
sudo apt-get install -y net-tools
sudo apt-get install -y openssh-server

sudo ufw allow ssh
sudo systemctl enable ssh