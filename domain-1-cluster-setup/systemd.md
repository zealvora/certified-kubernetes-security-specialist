#### Create env variable:
```sh
export SERVER_IP=172.31.54.201
```
#### systemd file for etcd:
```sh
cat <<EOF | sudo tee /etc/systemd/system/etcd.service
[Unit]
Description=etcd
Documentation=https://github.com/coreos

[Service]
ExecStart=/usr/local/bin/etcd \\
  --cert-file=/root/certificates/etcd.crt \\
  --key-file=/root/certificates/etcd.key \\
  --trusted-ca-file=/root/certificates/ca.crt \\
  --client-cert-auth \\
  --advertise-client-urls https://127.0.0.1:2379 \\
  --listen-client-urls=https://127.0.0.1:2379 \\
  --data-dir=/var/lib/etcd
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF
```
```sh
systemctl start etcd
systemctl enable etcd
```
####  systemd file for kube-apiserver:
```sh
cat <<EOF | sudo tee /etc/systemd/system/kube-apiserver.service
[Unit]
Description=Kubernetes API Server
Documentation=https://github.com/kubernetes/kubernetes

[Service]
ExecStart=/usr/local/bin/kube-apiserver \\
--advertise-address=${SERVER_IP} \\
--etcd-cafile=/root/certificates/ca.crt \\
--etcd-certfile=/root/certificates/apiserver-etcd-client.crt \\
--etcd-keyfile=/root/certificates/apiserver-etcd-client.key \\
--etcd-servers=https://127.0.0.1:2379 \\
--tls-cert-file=/var/lib/kubernetes/kube-api.crt \\
--tls-private-key-file=/var/lib/kubernetes/kube-api.key \\
--encryption-provider-config=/var/lib/kubernetes/encryption-at-rest.yaml \\
--v=2
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF
```
```sh
systemctl start kube-apiserver
systemctl enable kube-apiserver
```
#### Checking Logs:
```sh
journalctl -u etcd
journalctl -u kube-apiserver

journalctl -u etcd --since "10 minutes ago"
```
