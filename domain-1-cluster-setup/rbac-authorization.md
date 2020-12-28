#### Step 1 Enable RBAC Authorization:
```sh
nano /etc/systemd/system/kube-apiserver.service
```
```sh
--authorization-mode=RBAC \
```
```sh
systemctl daemon-reload
systemctl restart kube-apiserver
```
#### Step 2 Verify with Alice Certificate:
```sh
kubectl get secret --server=https://127.0.0.1:6443 --client-certificate /root/certificates/alice.crt --certificate-authority /root/certificates/ca.crt --client-key /root/certificates/alice.key
```
#### Step 3 - Create Administrator Priveleged User:
```sh
cd /root/certificates
```
```sh
openssl genrsa -out bob.key 2048
openssl req -new -key bob.key -subj "/CN=bob/O=system:masters" -out bob.csr
openssl x509 -req -in bob.csr -CA ca.crt -CAkey ca.key -CAcreateserial -out bob.crt -days 1000
```
#### Step 4 - Verification

```sh
kubectl get secret --server=https://127.0.0.1:6443 --client-certificate /root/certificates/bob.crt --certificate-authority /root/certificates/ca.crt --client-key /root/certificates/bob.key
```
