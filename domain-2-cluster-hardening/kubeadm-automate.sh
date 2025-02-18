#!/bin/bash

set -e  # Exit on error
set -o pipefail
set -x  # Enable debugging

### Step 1: Setup containerd ###
echo "[Step 1] Installing and configuring containerd..."

# Load required kernel modules
cat <<EOF | sudo tee /etc/modules-load.d/containerd.conf
overlay
br_netfilter
EOF

sudo modprobe overlay
sudo modprobe br_netfilter

# Configure sysctl
cat <<EOF | sudo tee /etc/sysctl.d/99-kubernetes-cri.conf
net.bridge.bridge-nf-call-iptables  = 1
net.ipv4.ip_forward                 = 1
net.bridge.bridge-nf-call-ip6tables = 1
EOF

sudo sysctl --system

# Install containerd
sudo apt-get update
sudo apt-get install -y containerd

# Configure containerd
sudo mkdir -p /etc/containerd
containerd config default | sudo tee /etc/containerd/config.toml >/dev/null

# Modify containerd config for systemd cgroup
sudo sed -i 's/SystemdCgroup = false/SystemdCgroup = true/' /etc/containerd/config.toml

# Restart containerd
sudo systemctl restart containerd
sudo systemctl enable containerd

### Step 2: Kernel Parameter Configuration ###
echo "[Step 2] Configuring kernel parameters..."

cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF

sudo sysctl --system

### Step 3: Configuring Repo and Installing Kubernetes ###
echo "[Step 3] Adding Kubernetes repository and installing kubeadm, kubelet, kubectl..."

sudo apt-get install -y apt-transport-https ca-certificates curl gpg

# Add Kubernetes GPG key
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.31/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg

# Add Kubernetes APT repository
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.31/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list

# Install kubeadm, kubelet, kubectl
sudo apt-get update
sudo apt-get install -y kubelet=1.31.6-1.1 kubeadm=1.31.6-1.1 kubectl=1.31.6-1.1 cri-tools=1.31.1-1.1
sudo apt-mark hold kubelet kubeadm kubectl

# Enable kubelet
sudo systemctl enable --now kubelet

### Step 4: Initialize Cluster with kubeadm ###
echo "[Step 4] Initializing Kubernetes cluster..."

sudo kubeadm init --pod-network-cidr=192.168.0.0/16

# Setup kubeconfig for user
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

### Step 5: Remove the Taint ###
echo "[Step 5] Removing control-plane taint..."

kubectl taint nodes --all node-role.kubernetes.io/control-plane- || true

### Step 6: Install Network Addon (Calico) ###
echo "[Step 6] Installing Calico network addon..."

kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v3.29.1/manifests/tigera-operator.yaml
sleep 20
kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v3.29.1/manifests/custom-resources.yaml

