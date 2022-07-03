
#### Format of Static Token File:
```sh
token,user,uid,"group1,group2,group3"
```
#### Create a token file with required data:
```sh
nano /root/token.csv
```
```sh
Dem0Passw0rd#,bob,01,admins
```
#### Pass the token auth flag:
  ```sh
nano /etc/systemd/system/kube-apiserver.service
```
```sh
--token-auth-file /root/token.csv
```
```sh
systemctl daemon-reload
systemctl restart kube-apiserver
```
#### Verification:
```sh
curl -k --header "Authorization: Bearer Dem0Passw0rd#" https://localhost:6443

kubectl get secret --server=https://localhost:6443 --token Dem0Passw0rd# --insecure-skip-tls-verify
```
#### Testing:
```sh
kubectl create secret generic my-secret --server=https://localhost:6443 --token Dem0Passw0rd# --insecure-skip-tls-verify
kubectl delete secret my-secret --server=https://localhost:6443 --token Dem0Passw0rd# --insecure-skip-tls-verify
```
