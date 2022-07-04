
#### Get the list of service accounts:
```sh
kubectl get sa
kubectl get secret
```
#### Service Accounts are created automatically when namespace is created:
```sh
kubectl create namespace kplabs
kubectl get sa -n kplabs
kubectl get secret -n kplabs
```
#### Verify SA Token Mount in Pods:
```sh
kubectl run nginx --image=nginx
kubectl exec -it nginx -- bash
cd /run/secrets/kubernetes.io/serviceaccount
cat token
kubectl get pod nginx -o yaml
```
#### Create POD with custom service account:
```sh
kubectl create sa kplabs
kubectl run nginx-sa --image=nginx --serviceaccount="kplabs"
kubectl get pod nginx-sa -o yaml
```
