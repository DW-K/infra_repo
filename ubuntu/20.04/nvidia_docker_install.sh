sudo apt update

sudo apt-get update

sudo apt-get install net-tools

# install docker
curl https://get.docker.com | sh \
  && sudo chkconfig docker on \
  && sudo service docker start

#sudo apt-get install -y docker-ce containerd.io docker-compose
sudo curl -L https://github.com/docker/compose/releases/download/v2.15.0/docker-compose-linux-x86_64 -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

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
