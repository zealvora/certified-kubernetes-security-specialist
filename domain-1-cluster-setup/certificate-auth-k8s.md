### Documentation Referred:

https://kubernetes.io/docs/reference/command-line-tools-reference/kube-apiserver/

#### Step 1 Creating Certificate for Alice:
```sh
cd /root/certificates
```
```sh
openssl genrsa -out alice.key 2048
openssl req -new -key alice.key -subj "/CN=alice/O=developers" -out alice.csr
openssl x509 -req -in alice.csr -CA ca.crt -CAkey ca.key -CAcreateserial -out alice.crt -days 1000
```
#### Step 2 Set ClientCA flag in API Server:

```sh
nano /etc/systemd/system/kube-apiserver.service
```
```sh
--client-ca-file /root/certificates/ca.crt
```
```sh
systemctl daemon-reload
systemctl restart kube-apiserver
```
#### Step 3 Verification:
```sh
kubectl get secret --server=https://127.0.0.1:6443 --client-certificate /root/certificates/alice.crt --certificate-authority /root/certificates/ca.crt --client-key /root/certificates/alice.key
```
