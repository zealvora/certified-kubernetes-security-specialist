#### Check status of apparmor:
```sh
systemctl status apparmor
```
#### Sample Script:
```sh
mkdir /root/apparmor
cd /root/apparmor
```
```sh
nano myscript.sh
```
```sh
#!/bin/bash
touch /tmp/file.txt
echo "New File created"

rm -f /tmp/file.txt
echo "New file removed"
```
```sh
chmod +x myscript.sh
```
#### Install Apparmor Utils:
```sh
apt install apparmor-utils
```
#### Generate a new profile:
```sh
aa-genprof ./myscript.sh
```
```sh
./myscript.sh (from new tab)
```
#### Verify the new profile:
```sh
cat /etc/apparmor.d/root.tt.script.sh
aa-status
```
#### Disable a profile:
```sh
ln -s /etc/apparmor.d/root.apparmor.myscript.sh /etc/apparmor.d/disable/
apparmor_parser -R /etc/apparmor.d/root.apparmor.myscript.sh
```
