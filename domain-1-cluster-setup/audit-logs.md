#### Reference Websites:

https://jsonformatter.curiousconcept.com/#

#### Step 1 - Create Sample Audit Policy File:
```sh
nano /root/certificates/logging.yaml
```
```sh
apiVersion: audit.k8s.io/v1
kind: Policy
rules:
- level: Metadata
```

#### Step 2 - Audit Configuration:
```sh
nano /etc/systemd/system/kube-apiserver.service
```
```sh
--audit-policy-file=/root/certificates/logging.yaml --audit-log-path=/var/log/api-audit.log --audit-log-maxage=30  --audit-log-maxbackup=10  --audit-log-maxsize=100 
```
```sh
systemctl daemon-reload
systemctl restart kube-apiserver
```
#### Step 3 Run Some Queries using Bob user

```sh
kubectl get secret --server=https://127.0.0.1:6443 --client-certificate /root/certificates/bob.crt --certificate-authority /root/certificates/ca.crt --client-key /root/certificates/bob.key
```
#### Step 4: Verification
```sh
cd /var/log
grep -i bob api-audit.log
```
