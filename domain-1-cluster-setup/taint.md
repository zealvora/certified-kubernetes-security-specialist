#### See Taint Details of Worker node

kubectl get nodes
kubectl describe node kubeadm-master

#### Run Nginx POD with current Taint

kubectl run nginx-pod --image=nginx
kubectl describe pod nginx-pod
```


#### Remove Taint from the Worker Node:
```sh
kubectl taint node kubeadm-master node-role.kubernetes.io/master-
```
```sh
kubectl taint node kubeadm-master node-role.kubernetes.io/control-plane-
```

#### Verification:
```sh
kubectl run nginx-pod --image=nginx

kubectl get pods
```
