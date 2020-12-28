#### Step 1 - Creating Certificate for John:
```sh
mkdir /root/certificates
cd /root/certificates
```
```sh
openssl genrsa -out john.key 2048
openssl req -new -key john.key -subj "/CN=john/O=developers" -out john.csr
```

#### Step 2 - Create CertificateSigningRequest:
```sh
cat <<EOF | kubectl apply -f -
apiVersion: certificates.k8s.io/v1
kind: CertificateSigningRequest
metadata:
  name: john
spec:
  groups:
  - system:authenticated
  request: $(cat john.csr | base64 | tr -d '\n')
  signerName: kubernetes.io/kube-apiserver-client
  usages:
  - client auth
EOF
```
```sh
kubectl certificate approve john
kubectl get csr john -o jsonpath='{.status.certificate}' | base64 --decode > john.crt
```
#### Step 3 - Create John User and Move Certificates:
```sh
useradd -m john -s /bin/bash
cp john.crt john.key /home/john
cp /etc/kubernetes/pki/ca.crt /home/john
chown -R john.john /home/john
```
```sh
kubectl get pods --server=https://134.209.147.191:6443 --client-certificate /home/john/john.crt --certificate-authority /home/john/ca.crt --client-key /home/john/john.key
```
Note: Make sure to replace the above IP Address within the --server block.
#### Step 4 - Create Kubeconfig file for John:
```sh
su - john
export SERVER_IP=
```
```sh
kubectl config set-cluster kubeadm \
    --certificate-authority=/home/john/ca.crt \
    --embed-certs=true \
    --server=https://${SERVER_IP}:6443 \
    --kubeconfig=john.kubeconfig

kubectl config set-credentials john \
    --client-certificate=john.crt \
    --client-key=john.key \
    --embed-certs=true \
    --kubeconfig=john.kubeconfig

kubectl config set-context default \
    --cluster=kubeadm \
    --user=john \
    --kubeconfig=john.kubeconfig
```
```sh
kubectl config use-context default --kubeconfig=john.kubeconfig
kubectl get pods --kubeconfig=john.kubeconfig
cp john.kubeconfig ~/.kube/config
```
```sh
kubectl get pods
```
