apiserver-secure-01.md

#### Step 5 - Create a Secret:
```sh
kubectl create secret generic my-secret --from-literal=passphrase=topsecret --server http://localhost:8080
```
#### Step 6 - Check the contents from ETCD:
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