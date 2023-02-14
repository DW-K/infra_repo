sudo sh ./k8s_common_install.sh

#----------------------------------------------------------------
# Control-plane 구성 (master only)
sudo kubeadm init


# kubectl 권한 설정
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

#----------------------------------------------------------------
# Pod network 애드온 설치 (master only)
kubectl apply -f https://github.com/weaveworks/weave/releases/download/v2.8.1/weave-daemonset-k8s.yaml
sudo ufw route allow in on weave out on weave


# worker node를 구성하지 않을 경우
# kubectl taint nodes --all node-role.kubernetes.io/control-plane-