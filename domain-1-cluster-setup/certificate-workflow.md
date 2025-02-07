### Step 1 - Generate Client Certificate and Client Key:
```sh
cd /root/certificates
```
```sh
openssl genrsa -out zeal.key 2048

openssl req -new -key zeal.key -subj "/CN=zealvora" -out zeal.csr
```
### Step 2 - Sign the Client Certificate with CA
```sh
openssl x509 -req -in zeal.csr -CA ca.crt -CAkey ca.key -out zeal.crt -days 1000
```
### Step 3 - Verify Certificate
```sh
openssl x509 -in zeal.crt -text -noout

openssl verify -CAfile ca.crt zeal.crt
```

