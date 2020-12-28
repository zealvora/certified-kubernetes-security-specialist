
#### Step 1 - Install containerd:
```sh
cat <<EOF | sudo tee /etc/modules-load.d/containerd.conf
overlay
br_netfilter
EOF
```
```sh
modprobe overlay
modprobe br_netfilter
```
```sh
cat <<EOF | sudo tee /etc/sysctl.d/99-kubernetes-cri.conf
net.bridge.bridge-nf-call-iptables  = 1
net.ipv4.ip_forward                 = 1
net.bridge.bridge-nf-call-ip6tables = 1
EOF
```
```sh
sysctl --system
```
```sh
apt-get install -y containerd
mkdir -p /etc/containerd
containerd config default > /etc/containerd/config.toml
systemctl restart containerd
```
#### Step 2 - Kernel Parameter Configuration:
```sh
cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
```
```sh
sudo sysctl --system
```
#### Step 3 - Configuring kubeadm Repo and Installation:
```sh
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
```
```sh
cat <<EOF | sudo tee /etc/apt/sources.list.d/kubernetes.list
deb https://apt.kubernetes.io/ kubernetes-xenial main
EOF
```
```sh
apt-get update
apt-get install -y kubelet=1.20.1-00 kubeadm=1.20.1-00 kubectl=1.20.1-00
```
#### Step 4 - Initialize Cluster with kubeadm:
```sh
kubeadm init --pod-network-cidr=192.168.0.0/16
```
```sh
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
```
#### Step 5 - Remove the Taint:
```sh
kubectl taint nodes --all node-role.kubernetes.io/master-
```
#### Step 6 - Install Network Addon (Calico):
```sh
kubectl create -f https://docs.projectcalico.org/manifests/tigera-operator.yaml
kubectl create -f https://docs.projectcalico.org/manifests/custom-resources.yaml
```
####  7 - Verification:
```sh
kubectl get nodes
kubectl run nginx --image=nginx
kubectl get pods
```
