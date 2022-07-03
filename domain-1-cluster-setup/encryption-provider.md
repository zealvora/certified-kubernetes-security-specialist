#### Documentation Referred:

https://kubernetes.io/docs/tasks/administer-cluster/encrypt-data/

##### Step 1: Create a new secret
```sh
kubectl create secret generic new-secret -n default --from-literal=user=secretpassword --server=https://127.0.0.1:6443 --client-certificate /root/certificates/bob.crt --certificate-authority /root/certificates/ca.crt --client-key /root/certificates/bob.key
```
```sh
kubectl get secret --server=https://127.0.0.1:6443 --client-certificate /root/certificates/bob.crt --certificate-authority /root/certificates/ca.crt --client-key /root/certificates/bob.key
```

##### Step 2: Find the Secret in ETCD in Plain-Text
```sh
cd /root/certificates
```
```sh
ETCDCTL_API=3 etcdctl --endpoints=https://127.0.0.1:2379 --insecure-skip-tls-verify  --insecure-transport=false --cert ./apiserver.crt --key ./apiserver.key get /registry/secrets/default/new-secret | hexdump -C
```
```sh
cd /var/lib/etcd
grep -R "secretpassword" .
```
#### Step 3 - Create Encryption Key:
```sh
ENCRYPTION_KEY=$(head -c 32 /dev/urandom | base64)
echo $ENCRYPTION_KEY
```
#### Step 4 - Create Encryption Config:
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
#### Step 5 - Copy configuration to appropriate path:
```sh
mkdir /var/lib/kubernetes
mv encryption-at-rest.yaml /var/lib/kubernetes
```
#### Step 6 - Start kube-apiserver with appropriate flag:

  ```sh
nano /etc/systemd/system/kube-apiserver.service
```
```sh
--encryption-provider-config=/var/lib/kubernetes/encryption-at-rest.yaml
```
```sh
systemctl daemon-reload
systemctl restart kube-apiserver
systemctl status kube-apiserver
```
#### Step 7 - Create a new Secret
```sh
kubectl create secret generic db-secret -n default --from-literal=dbadmin=dbpasswd --server=https://127.0.0.1:6443 --client-certificate /root/certificates/bob.crt --certificate-authority /root/certificates/ca.crt --client-key /root/certificates/bob.key
```
```sh
kubectl get secret --server=https://127.0.0.1:6443 --client-certificate /root/certificates/bob.crt --certificate-authority /root/certificates/ca.crt --client-key /root/certificates/bob.key
```
##### Step 8: Verify if you can find secret

```sh
cd /root/certificates
ETCDCTL_API=3 etcdctl --endpoints=https://127.0.0.1:2379 --insecure-skip-tls-verify  --insecure-transport=false --cert ./apiserver.crt --key ./apiserver.key get /registry/secrets/default/db-secret | hexdump -C
```
```sh
cd /var/lib/etcd
grep -R "dbpasswd" .
```
