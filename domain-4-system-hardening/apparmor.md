#### Check status of apparmor:
```sh
systemctl status apparmor

aa-status
```
#### Sample Script:
```sh
mkdir /root/apparmor

cd /root/apparmor
```
```sh
nano app.sh
```
```sh
#!/bin/bash
touch /tmp/file.txt
echo "New File created"

rm -f /tmp/file.txt
echo "New file removed"
```
```sh
chmod +x app.sh
```
#### Install Apparmor Utils:
```sh
apt install apparmor-utils -y
```
#### Generate a new profile:
```sh
aa-genprof ./app.sh
```
```sh
./app.sh (from new tab)
```
#### Verify the new profile:
```sh
cat /etc/apparmor.d/root.apparmor.app.sh

aa-status
```
#### Disable a profile:
```sh
ln -s /etc/apparmor.d/root.apparmor.app.sh /etc/apparmor.d/disable/

apparmor_parser -R /etc/apparmor.d/root.apparmor.app.sh
```
