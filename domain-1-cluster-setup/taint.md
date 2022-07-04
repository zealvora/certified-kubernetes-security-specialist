#### Remove Taint:
```sh
kubectl taint node kubeadm-master node-role.kubernetes.io/master-
```
```sh
kubectl taint node kubeadm-master node-role.kubernetes.io/control-plane-
```

#### Verification:
```sh
kubectl run nginx-pod --image=nginx
```
