### Run Docker through CLI
```sh
systemctl stop docker
systemctl stop docker.socket

dockerd
```
### Test Container Launch
```sh
docker run -d --name nginx nginx

docker exec -it nginx bash

cat /etc/resolv.conf
```

### Run Docker through CLI with DNS Flag
```sh
dockerd --dns=8.8.8.8

docker run -d --name nginx2 nginx

docker exec -it nginx2 bash

cat /etc/resolv.conf
```

### Configure daemon.json file
```sh
nano /etc/docker/daemon.json
```
```sh
{
  "dns": ["8.8.4.4"]
}
```
```sh
dockerd

docker run -d --name nginx3 nginx

docker exec -it nginx3 bash

cat /etc/resolv.conf
```