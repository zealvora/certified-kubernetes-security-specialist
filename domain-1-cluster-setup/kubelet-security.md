#### Step 1: Access Worker Node Kubelet from Control Plane Node
```sh
cd /etc/kubernetes/pki
```
Change the IP address in below command to that of Worker Node IP
```sh
curl -k --cert apiserver-kubelet-client.crt --key apiserver-kubelet-client.key https://143.244.140.236:10250/pods
```
#### Step 2 Make a request to Kubelet API (Worker Node)
```sh
apt install net-tools
netstat -ntlp
curl -k -X GET https://localhost:10250/pods
```

#### Step 2 Modify the Kubelet Configuration file: (Worker Node)
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

#### Step 3 Make Request to Kubelet API: (Worker Node)
```sh
curl -k -X GET https://localhost:10250/pods
```
#### Step 4 Download kubeletctl: (Worker Node)

##### GitHub Repo

https://github.com/cyberark/kubeletctl

```sh
curl -LO https://github.com/cyberark/kubeletctl/releases/download/v1.6/kubeletctl_linux_amd64 && chmod a+x ./kubeletctl_linux_amd64 && mv ./kubeletctl_linux_amd64 /usr/local/bin/kubeletctl
```

```sh
kubeletctl pods -i
kubeletctl run "whoami" --all-pods -i
```

#### Step 5: Verify Kubelet Certificate

Change the IP address in below command to that of Worker Node IP


```sh
openssl s_client -showcerts -connect 143.244.140.236:10250 2>/dev/null | openssl x509 -inform pem -noout -text
```