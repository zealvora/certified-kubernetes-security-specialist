
#### Get the list of service accounts:
```sh
kubectl get sa
```
#### Service Accounts are created automatically when namespace is created:
```sh
kubectl create namespace kplabs
kubectl get sa
```
#### Verify SA Token Mount in Pods:
```sh
kubectl run nginx --image=nginx
kubectl exec -it nginx -- bash
cd /run/secrets/kubernetes.io/serviceaccount
cat token
```
#### Create POD with custom service account:
```sh
kubectl create sa kplabs
kubectl run nginx-sa --image=nginx --serviceaccount="kplabs"
```
