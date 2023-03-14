# 필요 패키지 설치
sudo apt-get update
sudo apt-get install -y vim

# 방화벽 해제
sudo ufw disable

# mysql 설치
sudo apt-get update
sudo apt-get install -y mysql-server
sudo systemctl start mysql
sudo systemctl enable mysql

# install prerequistie
sudo apt-get update &&
sudo apt-get install -y socat

# docker
sudo apt-get update && sudo apt-get install -y ca-certificates curl gnupg lsb-release

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

echo \
"deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
$(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update && apt-cache madison docker-ce
apt-cache madison docker-ce | grep 5:20.10.11~3-0~ubuntu-focal

sudo apt-get install -y containerd.io docker-ce=5:20.10.11~3-0~ubuntu-focal docker-ce-cli=5:20.10.11~3-0~ubuntu-focal

sudo groupadd docker
sudo usermod -aG docker $USER
newgrp docker

# Turn off Swap Memory 
sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab
sudo swapoff -a

# install kubectl
curl -LO https://dl.k8s.io/release/v1.21.7/bin/linux/amd64/kubectl
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

## kubeadm
# Prerequisite (쿠버네티스를 위한 네트워크 설정 변경)
sudo modprobe br_netfilter

cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
br_netfilter
EOF

cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF

sudo sysctl --system

# kubernetes cluster setup (kubeadm, kubelet, kubectl 설치)
sudo apt-get update

sudo apt-get install -y apt-transport-https ca-certificates curl &&
sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg &&
echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list &&
sudo apt-get update

sudo apt-get install -y kubelet=1.21.7-00 kubeadm=1.21.7-00 kubectl=1.21.7-00 &&
sudo apt-mark hold kubelet kubeadm kubectl

# kubeadm을 사용해서 kubernetes 설치
kubeadm config images list
kubeadm config images pull

sudo kubeadm init --pod-network-cidr=10.244.0.0/16

# admin 인증서 복사
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

kubectl apply -f https://raw.githubusercontent.com/flannel-io/flannel/v0.13.0/Documentation/kube-flannel.yml

# master client가 한 노드에 있을 때
kubectl taint nodes --all node-role.kubernetes.io/master-

### trouble shooting (corens pod pending)
# kubectl edit cm coredns -n kube-system
# 24번째 줄 loop 주석 처리
# kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml

## Install Kubernetes Modules (client only)
# Helm
wget https://get.helm.sh/helm-v3.7.1-linux-amd64.tar.gz
tar -zxvf helm-v3.7.1-linux-amd64.tar.gz
sudo mv linux-amd64/helm /usr/local/bin/helm

# Kustomize
wget https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize%2Fv3.10.0/kustomize_v3.10.0_linux_amd64.tar.gz
tar -zxvf kustomize_v3.10.0_linux_amd64.tar.gz
sudo mv kustomize /usr/local/bin/kustomize

# CSI Plugin : Local Path Provisioner 
kubectl apply -f https://raw.githubusercontent.com/rancher/local-path-provisioner/v0.0.20/deploy/local-path-storage.yaml
kubectl patch storageclass local-path  -p '{"metadata": {"annotations":{"storageclass.kubernetes.io/is-default-class":"true"}}}'

## Nvidia setting
# driver
sudo add-apt-repository ppa:graphics-drivers/ppa
sudo apt update && sudo apt install -y ubuntu-drivers-common
sudo ubuntu-drivers autoinstall
sudo reboot

# Nvidia docker
curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | \
  sudo apt-key add - 

distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | sudo tee /etc/apt/sources.list.d/nvidia-docker.list
sudo apt-get update
sudo apt-get install -y nvidia-docker2 &&
sudo systemctl restart docker

# Nvidia-docker를 default container runtime으로 설정
# sudo vi /etc/docker/daemon.json
# {
#   "default-runtime": "nvidia",
#   "runtimes": {
#       "nvidia": {
#           "path": "nvidia-container-runtime",
#           "runtimeArgs": []
#   }
#   }
# }

sudo systemctl daemon-reload
sudo service docker restart

## Nvidia-Device-Plugin
# nvidia-device-plugin daemonset을 생성
kubectl create -f https://raw.githubusercontent.com/NVIDIA/k8s-device-plugin/v0.10.0/nvidia-device-plugin.yml

### trouble shooting
## kube-flannel-ds pod가 CrashLoopBackOff 상태 일 때
# sudo kubeadm reset
# sudo kubeadm init --pod-network-cidr=10.244.0.0/16
# sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
# sudo chown $(id -u):$(id -g) $HOME/.kube/config
# kubectl apply -f https://raw.githubusercontent.com/flannel-io/flannel/v0.13.0/Documentation/kube-flannel.yml

## Kubeflow 설치
git clone -b v1.4.0 https://github.com/kubeflow/manifests.git
cd manifests

# cert-manager 를 설치합니다.
kustomize build common/cert-manager/cert-manager/base | kubectl apply -f -

kubectl get pod -n cert-manager

# kubeflow-issuer 를 설치합니다.
kustomize build common/cert-manager/kubeflow-issuer/base | kubectl apply -f -

## Istio
# istio 관련 Custom Resource Definition(CRD) 를 설치합니다.
kustomize build common/istio-1-9/istio-crds/base | kubectl apply -f -
# istio namespace 를 설치합니다.
kustomize build common/istio-1-9/istio-namespace/base | kubectl apply -f -
# istio 를 설치합니다.
kustomize build common/istio-1-9/istio-install/base | kubectl apply -f -

kubectl get po -n istio-system


## Dex
kustomize build common/dex/overlays/istio | kubectl apply -f -
kubectl get po -n auth

## OIDC AuthService 
kustomize build common/oidc-authservice/base | kubectl apply -f -
kubectl get po -n istio-system

### trouble shooting (재시작)
# kustomize build common/oidc-authservice/base | kubectl delete -f -

## Kubeflow Namespace 
kustomize build common/kubeflow-namespace/base | kubectl apply -f -
kubectl get ns kubeflow

## Kubeflow Roles 
kustomize build common/kubeflow-roles/base | kubectl apply -f -

## Kubeflow Istio Resources 
kustomize build common/istio-1-9/kubeflow-istio-resources/base | kubectl apply -f -

## Kubeflow Pipelines 
kustomize build apps/pipeline/upstream/env/platform-agnostic-multi-user | kubectl apply -f -
# kubectl port-forward svc/ml-pipeline-ui -n kubeflow 10019:80 --address='0.0.0.0'

## Katib
kustomize build apps/katib/upstream/installs/katib-with-kubeflow | kubectl apply -f -
# kubectl get po -n kubeflow | grep katib
# kubectl port-forward svc/katib-ui -n kubeflow 10018:80 --address='0.0.0.0'

## Central Dashboard 
kustomize build apps/centraldashboard/upstream/overlays/istio | kubectl apply -f -
# kubectl get po -n kubeflow | grep centraldashboard
# kubectl port-forward svc/centraldashboard -n kubeflow 10017:80 --address='0.0.0.0'

## Admission Webhook 
kustomize build apps/admission-webhook/upstream/overlays/cert-manager | kubectl apply -f -

## Notebooks & Jupyter Web App 
# http 접속 허용 (https://otzslayer.github.io/kubeflow/2022/06/11/could-not-find-csrf-cookie-xsrf-token-in-the-request.html)
# sudo vi /home/ubuntu/manifests/apps/jupyter/jupyter-web-app/upstream/base/deployment.yaml

# spec - spec - containers -env 에 
# - name: APP_SECURE_COOKIES
#   value: "false"
# 추가

# Notebook controller 를 설치합니다.
kustomize build apps/jupyter/notebook-controller/upstream/overlays/kubeflow | kubectl apply -f -
# kubectl get po -n kubeflow | grep notebook-controller

# Jupyter Web App 을 설치합니다.
kustomize build apps/jupyter/jupyter-web-app/upstream/overlays/istio | kubectl apply -f -
# kubectl get po -n kubeflow | grep jupyter-web-app

## Profiles + KFAM 
# Profile Controller를 설치합니다.
kustomize build apps/profiles/upstream/overlays/kubeflow | kubectl apply -f -
kubectl get po -n kubeflow | grep profiles-deployment

## Volumes Web App 
kustomize build apps/volumes-web-app/upstream/overlays/istio | kubectl apply -f -
kubectl get po -n kubeflow | grep volumes-web-app


## Tensorboard & Tensorboard Web App 
# Tensorboard Web App 를 설치합니다.
kustomize build apps/tensorboard/tensorboards-web-app/upstream/overlays/istio | kubectl apply -f -
kubectl get po -n kubeflow | grep tensorboards-web-app
# Tensorboard Controller 를 설치합니다.
kustomize build apps/tensorboard/tensorboard-controller/upstream/overlays/kubeflow | kubectl apply -f -
kubectl get po -n kubeflow | grep tensorboard-controller

## Training Operator 
kustomize build apps/training-operator/upstream/overlays/kubeflow | kubectl apply -f -
kubectl get po -n kubeflow | grep training-operator

## User Namespace 
# Kubeflow 사용을 위해, 사용할 User의 Kubeflow Profile 을 생성합니다.
kustomize build common/user-namespace/base | kubectl apply -f -
kubectl get profile

## 정상 설치 확인
kubectl port-forward svc/istio-ingressgateway -n istio-system 10012:80 --address='0.0.0.0'
# user@example.com
# 12341234

### MLflow Tracking Server
## Before Install MLflow Tracking Server 
# PostgreSQL DB 설치 
kubectl create ns mlflow-system
kubectl -n mlflow-system apply -f https://raw.githubusercontent.com/mlops-for-all/helm-charts/b94b5fe4133f769c04b25068b98ccfa7a505aa60/mlflow/manifests/postgres.yaml 
kubectl get pod -n mlflow-system | grep postgresql

## Minio 설정 
# MLflow Tracking Server가 Artifacts Store로 사용할 용도의 Minio는 이전 Kubeflow 설치 단계에서 설치한 Minio를 활용합니다.
# 단, kubeflow 용도와 mlflow 용도를 분리하기 위해, mlflow 전용 버킷(bucket)을 생성하겠습니다

kubectl port-forward svc/minio-service -n kubeflow 10019:9000 --address='0.0.0.0'
# Username: minio
# Password: minio123

# 우측 하단의 + 버튼을 클릭하여, Create Bucket를 클릭합니다.
# Bucket Name에 mlflow를 입력하여 버킷을 생성합니다.

## Helm Repository 추가 
helm repo add mlops-for-all https://mlops-for-all.github.io/helm-charts
helm repo update

## Helm Install #
helm install mlflow-server mlops-for-all/mlflow-server \
  --namespace mlflow-system \
  --version 0.2.0

# 주의: 위의 helm chart는 MLflow 의 backend store 와 artifacts store 의 접속 정보를 kubeflow 설치 과정에서 생성한 minio와 위의 PostgreSQL DB 설치에서 생성한 postgresql 정보를 default로 하여 설치합니다.
# 별개로 생성한 DB 혹은 Object storage를 활용하고 싶은 경우, Helm Chart Repo를 참고하여 helm install 시 value를 따로 설정하여 설치하시기 바랍니다. 
# https://github.com/mlops-for-all/helm-charts/tree/main/mlflow/chart

# kubectl port-forward svc/mlflow-server-service -n mlflow-system 10018:5000 --address='0.0.0.0'

### Seldon-Core (쿠버네티스 환경에 수많은 머신러닝 모델을 배포하고 관리할 수 있는 오픈소스 프레임워크)
helm repo add datawire https://www.getambassador.io
helm repo update

## Ambassador - Helm Install 
helm install ambassador datawire/ambassador \
  --namespace seldon-system \
  --create-namespace \
  --set image.repository=quay.io/datawire/ambassador \
  --set enableAES=false \
  --set crds.keep=false \
  --version 6.9.3

# kubectl get pod -n seldon-system

## Seldon-Core - Helm Install 
helm install seldon-core seldon-core-operator \
    --repo https://storage.googleapis.com/seldon-charts \
    --namespace seldon-system \
    --set usageMetrics.enabled=true \
    --set ambassador.enabled=true \
    --version 1.11.2

# kubectl get pod -n seldon-system | grep seldon-controller

### Prometheus & Grafana
helm repo add seldonio https://storage.googleapis.com/seldon-charts
helm repo update

helm install seldon-core-analytics seldonio/seldon-core-analytics \
  --namespace seldon-system \
  --version 1.12.0

# kubectl get pod -n seldon-system | grep seldon-core-analytics
# kubectl port-forward svc/seldon-core-analytics-grafana -n seldon-system 10017:80 --address='0.0.0.0'

# Email or username : admin
# Password : password


# kubectl port-forward --address 0.0.0.0 svc/istio-ingressgateway -n istio-system 10012:80 --address='0.0.0.0'
# user@example.com
# 12341234


### pyenv 설치
sudo apt-get update
sudo apt-get install -y \
    build-essential \
    curl \
    libbz2-dev \
    libffi-dev \
    liblzma-dev \
    libncursesw5-dev \
    libreadline-dev \
    libsqlite3-dev \
    libssl-dev \
    libxml2-dev \
    libxmlsec1-dev \
    llvm \
    make \
    tk-dev \
    wget \
    xz-utils \
    zlib1g-dev

curl https://pyenv.run | bash
sudo vi ~/.bashrc

# 추가
# export PATH="$HOME/.pyenv/bin:$PATH"
# eval "$(pyenv init -)"
# eval "$(pyenv virtualenv-init -)"

exec $SHELL
pyenv --help

pyenv install 3.7.12
pyenv virtualenv 3.7.12 demo
pyenv activate demo
