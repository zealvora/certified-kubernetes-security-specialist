
#### Step 1: Download Kubernetes Server Binaries
```sh
cd /root/binaries
wget https://dl.k8s.io/v1.24.2/kubernetes-server-linux-amd64.tar.gz
tar -xzvf kubernetes-server-linux-amd64.tar.gz
cd /root/binaries/kubernetes/server/bin/
cp kube-apiserver kubectl /usr/local/bin/
```

#### Step 2 - Generate Client Certificate for API Server (ETCD Client):
```sh
cd /root/certificates
```
```sh
openssl genrsa -out apiserver.key 2048
openssl req -new -key apiserver.key -subj "/CN=kube-apiserver" -out apiserver.csr
openssl x509 -req -in apiserver.csr -CA ca.crt -CAkey ca.key -CAcreateserial -out apiserver.crt -extensions v3_req  -days 1000
```

#### Step 3 - Generate Service Account Certificates
```sh
openssl genrsa -out service-account.key 2048
openssl req -new -key service-account.key -subj "/CN=service-accounts" -out service-account.csr
openssl x509 -req -in service-account.csr -CA ca.crt -CAkey ca.key -CAcreateserial  -out service-account.crt -days 100
```
#### Step 4 - Start kube-apiserver:
```sh
/usr/local/bin/kube-apiserver --advertise-address=159.65.147.161 --etcd-cafile=/root/certificates/ca.crt --etcd-certfile=/root/certificates/apiserver.crt --etcd-keyfile=/root/certificates/apiserver.key --service-cluster-ip-range 10.0.0.0/24 --service-account-issuer=https://127.0.0.1:6443 --service-account-key-file=/root/certificates/service-account.crt --service-account-signing-key-file=/root/certificates/service-account.key --etcd-servers=https://127.0.0.1:2379
```
#### Step 5 - Verify

```sh
netstat -ntlp
curl -k https://localhost:6443
```

#### Step 6 - Integrate Systemd with API server

Change the IP address in --advertise-address

```sh
cat <<EOF | sudo tee /etc/systemd/system/kube-apiserver.service
[Unit]
Description=Kubernetes API Server
Documentation=https://github.com/kubernetes/kubernetes

[Service]
ExecStart=/usr/local/bin/kube-apiserver \
--advertise-address=159.65.147.161 \
--etcd-cafile=/root/certificates/ca.crt \
--etcd-certfile=/root/certificates/apiserver.crt \
--etcd-keyfile=/root/certificates/apiserver.key \
--etcd-servers=https://127.0.0.1:2379 \
--service-account-key-file=/root/certificates/service-account.crt \
--service-cluster-ip-range=10.0.0.0/24 \
--service-account-signing-key-file=/root/certificates/service-account.key \
--service-account-issuer=https://127.0.0.1:6443 

[Install]
WantedBy=multi-user.target
EOF
```

#### Step 7 - Start kube-api server
```sh
systemctl start kube-apiserver
```
