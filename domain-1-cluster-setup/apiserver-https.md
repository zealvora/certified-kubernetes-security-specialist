#### Step 1 - Verify Certificate Details
```sh
openssl s_client -showcerts -connect localhost:6443 2>/dev/null | openssl x509 -inform pem -noout -text
```

#### Step 2 - Generate Configuration File for CSR Creation:
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
IP.3 = 10.0.0.1
EOF
```
#### Step 3 - Generate Certificates for API Server
```sh
{
openssl genrsa -out kube-api.key 2048

openssl req -new -key kube-api.key -subj "/CN=kube-apiserver" -out kube-api.csr -config api.conf

openssl x509 -req -in kube-api.csr -CA ca.crt -CAkey ca.key -CAcreateserial  -out kube-api.crt -extensions v3_req -extfile api.conf -days 2000
}
```

#### Step 4 - Start kube-apiserver with following flags:

Append following flags in service file for API Server
```sh
nano /etc/systemd/system/kube-apiserver.service
```
```sh
--tls-cert-file=/root/certificates/kube-api.crt
--tls-private-key-file=/root/certificates/kube-api.key
```
```sh
systemctl daemon-reload

systemctl restart kube-apiserver
```

#### Step 5 - Verification
```sh
openssl s_client -showcerts -connect localhost:6443 2>/dev/null | openssl x509 -inform pem -noout -text

curl -k https://localhost:6443
```
