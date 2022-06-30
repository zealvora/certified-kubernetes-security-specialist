#### Step 1 - Generate Client Certificate and Client Key:
```sh
cd /root/certificates
```
```sh
openssl genrsa -out client.key 2048
openssl req -new -key client.key -subj "/CN=client" -out client.csr
openssl x509 -req -in client.csr -CA ca.crt -CAkey ca.key -CAcreateserial -out client.crt -extensions v3_req  -days 1000
```

#### Step 2 - Start ETCD Server:
```sh
etcd --cert-file=/root/certificates/etcd.crt --key-file=/root/certificates/etcd.key --advertise-client-urls=https://127.0.0.1:2379 --client-cert-auth --trusted-ca-file=/root/certificates/ca.crt  --listen-client-urls=https://127.0.0.1:2379
```
#### Step 3 - Authenticate with Certificates:
```sh
ETCDCTL_API=3 etcdctl --endpoints=https://127.0.0.1:2379 --insecure-skip-tls-verify  --insecure-transport=false --cert /root/certificates/client.crt --key /root/certificates/client.key put course "kplabs is awesome!"

ETCDCTL_API=3 etcdctl --endpoints=https://127.0.0.1:2379 --insecure-skip-tls-verify  --insecure-transport=false --cert /root/certificates/client.crt --key /root/certificates/client.key get course
```
