#### Remove Taint:
```sh
kubectl taint kubeadm-master node-role.kubernetes.io/master-
```
#### Verification:
```sh
kubectl run nginx-pod --image=nginx
```
