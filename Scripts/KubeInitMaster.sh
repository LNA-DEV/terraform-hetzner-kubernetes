#! /bin/bash
sudo su
sudo apt-get update
sudo apt-get upgrade -y

# Turn off swapspace
swapoff -a; sed -i '/swap/d' /etc/fstab

sysctl settings for Kubernetes networking
cat >>/etc/sysctl.d/kubernetes.conf<<EOF
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
sysctl --system

# Install Docker
apt install -y apt-transport-https ca-certificates curl gnupg-agent software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
apt update
apt install -y docker-ce=5:19.03.10~3-0~ubuntu-focal containerd.io

# Install Kubernetes
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" > /etc/apt/sources.list.d/kubernetes.list
apt update && apt install -y kubeadm=1.18.5-00 kubelet=1.18.5-00 kubectl=1.18.5-00 -y

# Cluster init
publicIp=$(curl ipinfo.io/ip)
kubeadm init --apiserver-advertise-address=$publicIp --pod-network-cidr=10.0.0.0/16  --ignore-preflight-errors=all

# Calico Network
kubectl --kubeconfig=/etc/kubernetes/admin.conf create -f https://docs.projectcalico.org/v3.14/manifests/calico.yaml

# Join Nodes
kubeadm token create --print-join-command > ~/join.txt
sudo apt-get install netcat
sleep 60

for i in {2..[REPLACE]}
do
  sudo netcat 10.0.1.$i 57898 < ~/join.txt
done

# Configure kubectl
mkdir ~/.kube/
touch ~/.kube/config
cd ~
cp /etc/kubernetes/admin.conf .kube/config

sleep 60

kubectl label node kubeNode node-role.kubernetes.io/worker=worker

var=[REPLACE]
var=$var-2

for (( i = 0; i <= $var; i++ )) 
do
  kubectl label node kubenode$i node-role.kubernetes.io/worker=worker
done

# Finisheds script
touch ~/FinishedScript.txt