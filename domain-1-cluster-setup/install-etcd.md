#### Documentation Link:

https://github.com/etcd-io/etcd/releases/tag/v3.4.10

#### Pre-Requisite:
```sh
sudo su -
setenforce 0
sed -i 's/^SELINUX=enforcing$/SELINUX=permissive/' /etc/selinux/config
yum -y install wget
```
#### Step 1: Copy the ETCD and ETCDCTL Binaries to the Path
```sh
mkdir /root/binaries
cd /root/binaries
```
```sh
wget https://github.com/etcd-io/etcd/releases/download/v3.4.10/etcd-v3.4.10-linux-amd64.tar.gz
tar -xzvf etcd-v3.4.10-linux-amd64.tar.gz
cd etcd-v3.4.10-linux-amd64
cp etcd etcdctl /usr/local/bin/
```
#### Step 2: Start ETCD from CLI
```sh
etcd
```
