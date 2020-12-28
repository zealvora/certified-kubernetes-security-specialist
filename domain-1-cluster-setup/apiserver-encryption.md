
#### Step 1 - Create Encryption Key:
```sh
ENCRYPTION_KEY=$(head -c 32 /dev/urandom | base64)
echo $ENCRYPTION_KEY
```
#### Step 2 - Create Encryption Config:
```sh
cat > encryption-at-rest.yaml <<EOF
kind: EncryptionConfig
apiVersion: v1
resources:
  - resources:
      - secrets
    providers:
      - aescbc:
          keys:
            - name: key1
              secret: ${ENCRYPTION_KEY}
      - identity: {}
EOF
```
#### Step 3 - Copy configuration to appropriate path:
```sh
mkdir /var/lib/kubernetes
mv encryption-at-rest.yaml /var/lib/kubernetes
```
#### Step 4 - Start kube-apiserver with appropriate flag:
```sh
--encryption-provider-config=/var/lib/kubernetes/encryption-at-rest.yaml
```
Final Command:
```sh
/usr/local/bin/kube-apiserver --advertise-address=134.209.158.247 --etcd-cafile=/root/certificates/ca.crt --etcd-certfile=/root/certificates/apiserver-etcd-client.crt --etcd-keyfile=/root/certificates/apiserver-etcd-client.key --etcd-servers=https://127.0.0.1:2379 --encryption-provider-config=/var/lib/kubernetes/encryption-at-rest.yaml
```
#### Step 5 - Verify Contents of ETCD:
```sh
kubectl create secret generic new-secret -n default --from-literal=mykey=mydata --server=http://localhost:8080
kubectl get secret --server=http://localhost:8080
```
```sh
cd /root/certificates
ETCDCTL_API=3 etcdctl --endpoints=https://127.0.0.1:2379 --insecure-skip-tls-verify  --insecure-transport=false --cert ./client.crt --key ./client.key get /registry/secrets/default/new-secret | hexdump -C
```
```sh
cd /var/lib/etcd
grep -R "mydata" .
```
