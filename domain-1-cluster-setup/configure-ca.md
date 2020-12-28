#### Step 1 - Creating a private key for Certificate Authority:
```sh
mkdir /root/certificates
cd /root/certificates
```
```sh
openssl genrsa -out ca.key 2048
```
#### Step 2 -  Creating CSR:
```sh
openssl req -new -key ca.key -subj "/CN=KUBERNETES-CA" -out ca.csr
```
#### Step 3 - Self-Sign the CSR:
```sh
openssl x509 -req -in ca.csr -signkey ca.key -CAcreateserial  -out ca.crt -days 1000
```
#### Step 4 - Remove the CSR
```sh
rm -f ca.csr
```
