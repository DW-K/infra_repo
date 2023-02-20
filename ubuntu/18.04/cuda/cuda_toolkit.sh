
# 개발 필수 프로그램 설치
sudo apt-get install -y build-essential 

# cuda toolkit 설치 (11.6.4)
# https://developer.nvidia.com/cuda-toolkit-archive

wget https://developer.download.nvidia.com/compute/cuda/11.6.2/local_installers/cuda_11.6.2_510.47.03_linux.run
sudo sh cuda_11.6.2_510.47.03_linux.run

# # 환경 변수 설정
# sudo sh -c "echo 'export PATH=$PATH:/usr/local/cuda-11.2/bin' >> /etc/profile"
# sudo sh -c "echo 'export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/cuda-11.2/lib64' >> /etc/profile"
# sudo sh -c "echo 'export CUDADIR=/usr/local/cuda-11.2' >> /etc/profile"
# source /etc/profile