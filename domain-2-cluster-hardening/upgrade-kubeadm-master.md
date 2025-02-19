Documentation Referenced:

https://kubernetes.io/docs/tasks/administer-cluster/kubeadm/kubeadm-upgrade/

#### Verify Current Version of kubeadm
```sh
kubeadm version
```
#### Remove hold on kubernetes component for upgrade process
```sh
apt-mark unhold kubeadm kubelet kubectl
```

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
#### Install and Upgrade Kubeadm
```sh
apt-get install -y kubeadm="1.32.2-1.1*"
kubeadm upgrade plan
kubeadm upgrade apply v1.32.2
```
#### Install and Upgrade kubelet and kubectl
```sh
apt-cache madison kubelet
apt-cache madison kubectl
apt-get install -y kubelet="1.32.2-1.1*" kubectl="1.32.2-1.1"

systemctl daemon-reload
systemctl restart kubelet
```

#### Mark hold Kubernetes Component
```sh
apt-mark hold kubelet kubectl kubeadm
```

#### Final Verficiation
```sh
kubectl get nodes
```




