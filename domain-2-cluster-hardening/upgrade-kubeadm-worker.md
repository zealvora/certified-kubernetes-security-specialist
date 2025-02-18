#### Configure Repository for newer Kubernetes version
```sh
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.32/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg

echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.32/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list

apt-get update
```
#### Identify available Kubeadm version
```sh
apt-cache madison kubeadm
```
#### Remove hold on kubernetes component for upgrade process
```sh
apt-mark unhold kubeadm kubelet kubectl
```

#### Install and Upgrade Kubeadm
```sh
apt-get install -y kubeadm="1.32.2-1.1*"

kubeadm upgrade node
```


#### Install and Upgrade kubelet and kubectl
```sh
apt-cache madison kubelet

apt-cache madison kubectl
```
RUN the below command CONTROL PLANE NODE. Replace `node01` with appropriate worker node name
```sh
kubectl drain node01 --ignore-daemonsets
```
Following commands will run on worker node 
apt-get install -y kubelet="1.32.2-1.1*" kubectl="1.32.2-1.1"

sudo systemctl daemon-reload

sudo systemctl restart kubelet
```

#### Verification: (Run in Control Plane Node)

RUN the below command CONTROL PLANE NODE. Replace `node01` with appropriate worker node name
```sh
kubectl uncordon node01 
kubectl get nodes
```
