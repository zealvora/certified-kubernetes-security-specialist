#### Pages Referred:

https://github.com/kubernetes-sigs/bom

https://trivy.dev/v0.33/docs/sbom/


### Install Bom

```sh
wget https://github.com/kubernetes-sigs/bom/releases/download/v0.6.0/bom-amd64-linux

mv bom-amd64-linux bom

chmod +x bom

mv bom /usr/local/bin
```

### Install Trivy
```sh
curl -sfL https://raw.githubusercontent.com/aquasecurity/trivy/main/contrib/install.sh | sh

sudo mv bin/trivy /usr/local/bin
```

### Bom Learnings
```sh
bom generate spdx-json --image nginx:latest --output nginx.spdx.json

bom generate spdx-json --image nginx@sha256:28edb1806e63847a8d6f77a7c312045e1bd91d5e3c944c8a0012f0b14c830c44 --output nginx.spdx.json

bom document outline nginx.spdx.json

bom document outline nginx-spdx.json | grep dpkg
```

### Trivy Learnings

```sh
trivy image --format spdx-json --output nginx-spdx.json nginx:latest

trivy image --format cyclonedx --output nginx-cyclone.json nginx:latest

trivy sbom nginx-spdx.json
```