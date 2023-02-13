# 기존 cuda 제거

sudo rm -rf /usr/local/cuda*

export PATH=$PATH:/usr/local/cuda-11.0/bin

export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/cuda-11.0/lib64

export CUDADIR=/usr/local/cuda-11.0

# 개발 필수 프로그램 설치
sudo apt-get install build-essential 

# cuda toolkit 설치 (11.6.4)
# https://developer.nvidia.com/cuda-toolkit-archive

wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/cuda-ubuntu2004.pin
sudo mv cuda-ubuntu2004.pin /etc/apt/preferences.d/cuda-repository-pin-600
sudo apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/3bf863cc.pub
sudo add-apt-repository "deb https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/ /"
sudo apt-get update
sudo apt-get -y install cuda

# # 환경 변수 설정
# sudo sh -c "echo 'export PATH=$PATH:/usr/local/cuda-11.2/bin' >> /etc/profile"
# sudo sh -c "echo 'export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/cuda-11.2/lib64' >> /etc/profile"
# sudo sh -c "echo 'export CUDADIR=/usr/local/cuda-11.2' >> /etc/profile"
# source /etc/profile