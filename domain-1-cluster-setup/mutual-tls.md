
#### Step 1 - Generate Client Certificate and Client Key:
```sh
cd /root/certificates
```
```sh
openssl genrsa -out client.key 2048
openssl req -new -key client.key -subj "/CN=client" -out client.csr
openssl x509 -req -in client.csr -CA ca.crt -CAkey ca.key -CAcreateserial -out client.crt -extensions v3_req  -days 2000
```

#### Step 2 - Start Etcd Server (Tab 1):
```sh
cd /root/certificates

etcd --cert-file=etcd.crt --key-file=etcd.key --advertise-client-urls=https://127.0.0.1:2379 --client-cert-auth --trusted-ca-file=ca.crt --listen-client-urls=https://127.0.0.1:2379
```

#### Connect to Etcd (Tab 2)
```sh
cd /root/certificates

etcdctl --endpoints=https://127.0.0.1:2379 --cacert=ca.crt --cert=client.crt --key=client.key put key1 "value1"

etcdctl --endpoints=https://127.0.0.1:2379 --cacert=ca.crt --cert=client.crt --key=client.key get key1
```
