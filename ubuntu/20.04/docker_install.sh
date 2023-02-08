sudo apt-get update

sudo apt-get install -y git

# Uninstall old versions
sudo apt-get remove docker docker-engine docker.io containerd runc

# Set up the repository

## 1. Update the apt package index and install packages to allow apt to use a repository over HTTPS:
sudo apt-get update
sudo apt-get install -y ca-certificates curl gnupg lsb-release

## 2. Add Docker’s official GPG key:
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

## 3. Use the following command to set up the repository:
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Install Docker Engine
sudo chmod a+r /etc/apt/keyrings/docker.gpg
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

# docker 자동 실행
sudo systemctl start docker

sudo systemctl enable docker

# docker 권한 설정
sudo usermod -a -G docker $USER

sudo service docker restart

## **Apt를 이용하여 설치**

# 다음과 같은 명령어로 필요한 프로그램 설치합니다.

sudo apt update
sudo apt install -y software-properties-common

# 다음 명령어로 Repository를 등록합니다.

sudo add-apt-repository ppa:deadsnakes/ppa

# 다음 명령어로 Python 3.9를 설치합니다.

sudo apt install -y python3.9

# 다음 명령어로 `python 3.9`가 설치된 경로를 확인할 수 있습니다.

which python3.9

python3.9 --version

# install python alternative

sudo update-alternatives --install /usr/bin/python python /usr/bin/python3.9 3

sudo update-alternatives --config python
