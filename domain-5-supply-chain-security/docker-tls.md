
### Install Docker


### Generate CA Key and Certificate
```sh
mkdir -p /etc/docker/certs
cd /etc/docker/certs

openssl genpkey -algorithm RSA -out ca-key.pem

openssl req -new -x509 -days 365 -key ca-key.pem -subj "/CN=MyDockerCA" -out ca.pem
```
### Generate Server Certificate and Key
```sh
openssl genpkey -algorithm RSA -out server-key.pem

openssl req -new -key server-key.pem -subj "/CN=kplabs.docker.internal" -out server.csr

openssl x509 -req -in server.csr -CA ca.pem -CAkey ca-key.pem -CAcreateserial -days 365 -out server-cert.pem
```
### Generate Client Certificate and Key
```sh
openssl genpkey -algorithm RSA -out client-key.pem

openssl req -new -key client-key.pem -subj "/CN=client" -out client.csr

openssl x509 -req -in client.csr -CA ca.pem -CAkey ca-key.pem -CAcreateserial -days 365 -out client-cert.pem
```

### Configure Docker Daemon
```sh
nano /etc/docker/daemon.json
```
```sh
{
  "tls": true,
  "tlsverify": true,
  "tlscacert": "/etc/docker/certs/ca.pem",
  "tlscert": "/etc/docker/certs/server-cert.pem",
  "tlskey": "/etc/docker/certs/server-key.pem",
  "hosts": ["tcp://0.0.0.0:2376", "unix:///var/run/docker.sock"]
}
```

### Modify systemd service file
```sh
nano /usr/lib/systemd/system/docker.service
```
Modify the `ExecStart` to only use dockerd without any flags
```sh
ExecStart=/usr/bin/dockerd
```

### Restart Docker
```sh
systemctl daemon-reload
systemctl restart docker
```

### Testing the Setup
```sh
apt-get install net-tools

netstat -ntlp
```
```sh
curl http://127.0.0.1:2376/version

curl --cert /etc/docker/certs/client-cert.pem --key /etc/docker/certs/client-key.pem --cacert /etc/docker/certs/ca.pem https://127.0.0.1:2376/version
```
```sh
nano /etc/hosts
```
Add following line
```sh
127.0.0.1 docker.kplabs.internal
```
```sh
curl --cert /etc/docker/certs/client-cert.pem --key /etc/docker/certs/client-key.pem --cacert /etc/docker/certs/ca.pem https://docker.kplabs.internal:2376/version
```
