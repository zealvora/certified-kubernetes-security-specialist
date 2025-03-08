### Documentation Referenced:

https://falco.org/docs/setup/packages/

### Install Falco for Ubuntu

```sh
curl -fsSL https://falco.org/repo/falcosecurity-packages.asc | \
sudo gpg --dearmor -o /usr/share/keyrings/falco-archive-keyring.gpg

echo "deb [signed-by=/usr/share/keyrings/falco-archive-keyring.gpg] https://download.falco.org/packages/deb stable main" | \
sudo tee -a /etc/apt/sources.list.d/falcosecurity.list

sudo apt-get update -y

sudo apt install -y dkms make linux-headers-$(uname -r)
sudo apt install -y clang llvm
sudo apt install -y dialog
```
```sh
sudo apt-get install -y falco
```

### Check Falco status
```sh
systemctl status falco
```





