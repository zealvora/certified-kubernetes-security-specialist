### Documentation:

https://github.com/bridgecrewio/checkov

#### Install the Tool:
```sh
apt install python3-pip
pip3 install checkov
```
#### Our Demo Manifest File:
```sh
nano pod-priv.yaml
```
```sh
apiVersion: v1
kind: Pod
metadata:
  name: privileged
spec:
  containers:
  - image: nginx
    name: demo-pod
    securityContext:
      privileged: true

```
#### Perform a static analysis:
```sh
checkov -f pod-priv.yaml
```
