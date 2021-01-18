### Falco Documentation:

https://falco.org/docs/getting-started/installation/

#### Installation Steps:
```sh
curl -s https://falco.org/repo/falcosecurity-3672BA8F.asc | apt-key add -
echo "deb https://dl.bintray.com/falcosecurity/deb stable main" | tee -a /etc/apt/sources.list.d/falcosecurity.list
apt-get -y install linux-headers-$(uname -r)
apt-get update && apt-get install -y falco
```
#### Start falco:
```sh
falco
```
#### Sample Rules tested:
```sh
kubectl run nginx --image=nginx
kubectl exec -it nginx -- bash
```
```sh
mkdir /bin/tmp-dir
cat /etc/shadow
```
