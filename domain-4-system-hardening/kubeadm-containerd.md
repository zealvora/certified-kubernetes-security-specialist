### Pre-Requisite:

containerd installed and running.


#### Step 1 Configuring Repo and Installation:
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
#### Step 2 - Initialize:
```sh
kubeadm init --pod-network-cidr=10.244.0.0/16
```
```sh
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
```
#### Step 3 Install Network Addon (flannel):
```sh
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml
```
#### Step 4 Remove the Taint:
```sh
kubectl taint nodes --all node-role.kubernetes.io/master-
```
