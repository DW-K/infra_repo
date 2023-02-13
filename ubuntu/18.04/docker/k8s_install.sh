sudo sh ./docker_install.sh

# 각 노드들은 Swap Disable 해야하기 때문에 각 노드별로 다음 명령을 통해 설정한다.

sudo swapoff -a && sudo sed -i '/swap/s/^/#/' /etc/fstab

# ptable 설정

cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
br_netfilter
EOF
 
cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
sudo sysctl --system

# 통신을 위해 방화벽 예외 설정을 수행한다. 
sudo systemctl stop firewalld
sudo systemctl disable firewalld

# 쿠버네티스 설치를 진행하기위해 저장소 업데이트 및 필수 패키지 추가한다.
sudo apt-get update
sudo apt-get install -y apt-transport-https ca-certificates curl

# 구글 클라우드 퍼블릭 키 다운로드를 수행한다. 
sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg

# 쿠버네티스를 설치하기 위해 Kubernetes 저장소 추가한다. 
echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list

# 저장소 업데이트 후 kubelet, kubeadm, kubectl 설치를 순차적으로 진행한다. 
sudo apt-get update
sudo apt-get install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl

# 쿠버네티스를 서비스 등록 및 재시작을 수행한다. 
sudo systemctl daemon-reload
sudo systemctl restart kubelet
