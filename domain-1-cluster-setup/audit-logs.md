
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
--audit-policy-file=/root/certificates/logging.yaml \
--audit-log-path=/var/log/api-audit.log \
--audit-log-maxage=30 \
--audit-log-maxbackup=10 \
--audit-log-maxsize=100 \
```

#### Step 3: Verification
```sh
systemctl daemon-reload
systemctl restart kube-apiserver
less /var/log/api-audit.log
cd /var/log
grep -i bob api-audit.log
```
