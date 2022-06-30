#### Documentation Link:

https://github.com/etcd-io/etcd/releases/tag/v3.5.4

#### Pre-Requisite:
```sh
apt-get -y install wget
```
#### Step 1: Copy the ETCD and ETCDCTL Binaries to the Path
```sh
mkdir /root/binaries
cd /root/binaries
```
```sh
wget https://github.com/etcd-io/etcd/releases/download/v3.5.4/etcd-v3.5.4-linux-amd64.tar.gz
tar -xzvf etcd-v3.5.4-linux-amd64.tar.gz
cd etcd-v3.5.4-linux-amd64
cp etcd etcdctl /usr/local/bin/
```
#### Step 2: Start ETCD from CLI
```sh
etcd
```
