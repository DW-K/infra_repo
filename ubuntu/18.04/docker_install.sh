#!/bin/sh
sudo apt-get update
sudo apt-get install -y\
   ca-certificates \
   curl \
   gnupg \
   lsb-release

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io

# docker 자동 실행
sudo systemctl start docker

sudo systemctl enable docker

# docker 권한 설정
sudo usermod -a -G docker $USER

sudo service docker restart

# docker-compose 설치
sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

sudo chmod +x /usr/local/bin/docker-compose