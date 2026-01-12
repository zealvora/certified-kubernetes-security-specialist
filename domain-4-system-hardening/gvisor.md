### Documentation:

https://kubernetes.io/docs/concepts/containers/runtime-class/

#### Step 1 - Configure Docker:
```sh
# Add Docker's official GPG key:
sudo apt update && apt -y install ca-certificates curl

sudo install -m 0755 -d /etc/apt/keyrings

sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc

sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
sudo tee /etc/apt/sources.list.d/docker.sources <<EOF
Types: deb
URIs: https://download.docker.com/linux/ubuntu
Suites: $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}")
Components: stable
Signed-By: /etc/apt/keyrings/docker.asc
EOF

sudo apt update
```
```sh
sudo apt-get -y install docker-ce docker-ce-cli containerd.io
```
#### Step 2 - Install Configure Minikube:
```sh
wget https://github.com/kubernetes/minikube/releases/download/v1.37.0/minikube-linux-amd64

mv minikube-linux-amd64 minikube

chmod +x minikube

sudo mv ./minikube /usr/local/bin/minikube
```
```sh
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"

sudo mv kubectl /usr/local/bin

chmod +x /usr/local/bin/kubectl
```

#### Step 3 - Create a New user for testing
```sh
useradd -m -s /bin/bash -G sudo,docker zeal
visudo -f /etc/sudoers.d/zeal
zeal ALL=(ALL) NOPASSWD:ALL
su - zeal
```

####  Step 4: Start Minikube:
```sh
minikube start --container-runtime=containerd  --docker-opt containerd=/var/run/containerd/containerd.sock
```
####  Step 5 Enable gVisor addon:
```sh
minikube addons list
minikube addons enable gvisor
minikube addons list
```
####  Step 6 - Explore gVisor:
```sh
kubectl get runtimeclass
```
```sh
nano runtimeclass.yaml
```
```sh
apiVersion: node.k8s.io/v1
kind: RuntimeClass
metadata:
  name: gvisor2
handler: runsc
```
```sh
kubectl apply -f runtimeclass.yaml
```
```sh
nano gvisor-pod.yaml
```
```sh
apiVersion: v1
kind: Pod
metadata:
  name: nginx
spec:
  runtimeClassName: gvisor2
  containers:
  - image: nginx
    name: nginx
```
```sh
kubectl apply -f gvisor-pod.yaml
```

#### Create one more pod for seeing the difference in dmesg and uname output:
```sh
kubectl run nginx-default --image=nginx
```

#### Verify output (dmesg and uname -r)

From host machine: Run `dmesg` and 'uname -r'

```sh
kubectl exec -it nginx -- bash
dmesg
uname -r
logout
```

```sh
kubectl exec -it nginx-default -- bash
dmesg
uname -r
logout
```