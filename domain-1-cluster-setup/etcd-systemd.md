
#### Step 1: Create Data Directory for etcd

```sh
mkdir /var/lib/etcd
chmod 700 /var/lib/etcd
```

#### Step 2: Create Systemd file for etcd
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
  --listen-client-urls https://127.0.0.1:2379 \\
  --advertise-client-urls https://127.0.0.1:2379 \\
  --data-dir=/var/lib/etcd
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF
```
#### Step 3: Start etcd
```sh
systemctl start etcd

systemctl enable etcd
```
#### Step 4: Verify the status
```sh
systemctl status etcd
```

#### Step 5: Check etcd Logs
```sh
journalctl -u etcd
```
