#### Step 1 - Generate Client CSR and Client Key:
```sh
cd /root/certificates
```
```sh
openssl genrsa -out zeal.key 2048

openssl req -new -key zeal.key -subj "/CN=zealvora" -out zeal.csr
```
#### Step 2 - Sign the Client CSR with Certificate Authority
```sh
openssl x509 -req -in zeal.csr -CA ca.crt -CAkey ca.key -out zeal.crt -days 1000
```
#### Step 3 - Verify Client Certificate
```sh
openssl x509 -in zeal.crt -text -noout

openssl verify -CAfile ca.crt zeal.crt
```

#### Step 4 - Delete the Client Certificate and Key
```sh
rm -f zeal.crt zeal.key zeal.csr
```
