
#### Check Man page for Linux Capabilities
```sh
man capabilities
```
#### Verify capability of ping utility
```sh
which ping

getcap /usr/bin/ping
```
#### Create new user in Linux

```sh
useradd -m -s /bin/bash demouser
su - demouser
ping google.com
```

#### Remove capabilities for Ping utility (From Root User)
```sh
setcap -r /usr/bin/ping

getcap /usr/bin/ping
```
#### Set the capabilities for ping utility 
```sh
setcap cap_net_raw=ep /usr/bin/ping
```
