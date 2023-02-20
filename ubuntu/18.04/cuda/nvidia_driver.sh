ubuntu-drivers devices

# 0. 기존 cuda 삭제
sudo apt-get purge nvidia* 
sudo apt-get autoremove
sudo apt-get autoclean
sudo rm -rf /usr/local/cuda*

# 1. 권장드라이버 자동으로 설치
sudo ubuntu-drivers autoinstall

# 2. 원하는 버전 수동으로 설치
# sudo apt install nvidia-driver-450

sudo reboot

nvidia-smi