
#### Pre-Requisite Step, Download The Binaries:
```sh
cd /root/binaries
wget https://dl.k8s.io/v1.19.0/kubernetes-server-linux-amd64.tar.gz
tar -xzvf kubernetes-server-linux-amd64.tar.gz
cd /root/binaries/kubernetes/server/bin/
cp kube-apiserver /usr/local/bin/
```
#### Step 0 - Start ETCD:
```sh
mkdir /var/lib/etcd
chmod 700 /var/lib/etcd
```
```sh
etcd --cert-file=/root/certificates/etcd.crt --key-file=/root/certificates/etcd.key --advertise-client-urls=https://127.0.0.1:2379 --client-cert-auth --trusted-ca-file=/root/certificates/ca.crt  --listen-client-urls=https://127.0.0.1:2379 --data-dir=/var/lib/etcd
```
#### Step 1 - Generate Certificate for API Server (ETCD Client):
```sh
cd /root/certificates
```
```sh
openssl genrsa -out apiserver-etcd-client.key 2048
openssl req -new -key apiserver-etcd-client.key -subj "/CN=kube-apiserver" -out apiserver-etcd-client.csr
openssl x509 -req -in apiserver-etcd-client.csr -CA ca.crt -CAkey ca.key -CAcreateserial -out apiserver-etcd-client.crt -extensions v3_req  -days 1000
```
#### Step 2 - Start kube-apiserver:
```sh
/usr/local/bin/kube-apiserver --advertise-address=143.110.250.107 --etcd-cafile=/root/certificates/ca.crt --etcd-certfile=/root/certificates/apiserver-etcd-client.crt --etcd-keyfile=/root/certificates/apiserver-etcd-client.key --etcd-servers=https://127.0.0.1:2379
```
Let us now verify if things are working as expected:
```sh
netstat -ntlp
curl http://127.0.0.1:8080
cd /root/binaries/kubernetes/server/bin/
cp kubectl /usr/local/bin
kubectl get secret --server=http://127.0.0.1:8080
kubectl get ns --server=http://127.0.0.1:8080
```
#### Step 3 - Create a Secret:
```sh
kubectl create secret generic my-secret --from-literal=passphrase=topsecret --server http://localhost:8080
```
#### Step 4 - Check the contents from ETCD:
```sh
cd /root/certificates
```
```sh
ETCDCTL_API=3 etcdctl --endpoints=https://127.0.0.1:2379 --insecure-skip-tls-verify  --insecure-transport=false --cert ./client.crt --key ./client.key get /registry/secrets/default/my-secret | hexdump -C
```
To verify the secret data directly from the etcd data store:
```sh
cd /var/lib/etcd
grep -R "topsecret" .
```
