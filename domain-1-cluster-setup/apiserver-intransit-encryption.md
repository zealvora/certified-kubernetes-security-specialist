#### Step 1 - Generate Configuration File for CSR Creation:
```sh
cd /root/certificates
```
```sh
cat <<EOF | sudo tee api.conf
[req]
req_extensions = v3_req
distinguished_name = req_distinguished_name
[req_distinguished_name]
[ v3_req ]
basicConstraints = CA:FALSE
keyUsage = nonRepudiation, digitalSignature, keyEncipherment
subjectAltName = @alt_names
[alt_names]
DNS.1 = kubernetes
DNS.2 = kubernetes.default
DNS.3 = kubernetes.default.svc
DNS.4 = kubernetes.default.svc.cluster.local
IP.1 = 127.0.0.1
IP.2 = 143.110.250.107
IP.3 = 10.32.0.1
EOF
```
#### Step 2 - Generate Certificates for API Server
```sh
openssl genrsa -out kube-api.key 2048
openssl req -new -key kube-api.key -subj "/CN=kube-apiserver" -out kube-api.csr -config api.conf
openssl x509 -req -in kube-api.csr -CA ca.crt -CAkey ca.key -CAcreateserial  -out kube-api.crt -extensions v3_req -extfile api.conf -days 1000
```
```sh
cp kube-api.crt kube-api.key /var/lib/kubernetes
```
#### Step 3 - Start kube-apiserver with following flags:
```sh
--tls-cert-file=/var/lib/kubernetes/kube-api.crt
--tls-private-key-file=/var/lib/kubernetes/kube-api.key
--insecure-port 0
```
```sh
netstat -ntlp
```
