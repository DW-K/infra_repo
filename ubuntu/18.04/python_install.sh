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
