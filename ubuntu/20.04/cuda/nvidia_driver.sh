ubuntu-drivers devices

# 0. 기존 cuda 삭제
sudo apt-get purge nvidia*
sudo apt-get autoremove
sudo apt-get autoclean
sudo rm -rf /usr/local/cuda*

# 기존 cuda 제거

sudo rm -rf /usr/local/cuda*
export PATH=$PATH:/usr/local/cuda-11.0/bin
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/cuda-11.0/lib64
export CUDADIR=/usr/local/cuda-11.0

# 1. 권장드라이버 자동으로 설치
sudo ubuntu-drivers autoinstall

# 2. 원하는 버전 수동으로 설치
# sudo apt install nvidia-driver-450

sudo apt-get install dkms nvidia-modprobe
sudo apt update
sudo apt upgrade

sudo reboot