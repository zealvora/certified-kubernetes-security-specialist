### GitHub Page:

https://github.com/flavio/kube-image-bouncer

#### Switch to the controlconf directory:
```sh
cd /etc/kubernetes/controlconf
```
#### Creating Custom Webhook Configuration File:
```sh
nano custom-config.yaml
```
```sh
apiVersion: apiserver.config.k8s.io/v1
kind: AdmissionConfiguration
plugins:
- name: ImagePolicyWebhook
  configuration:
    imagePolicy:
      kubeConfigFile: /etc/kubernetes/controlconf/custom-webhook.kubeconfig
      allowTTL: 50
      denyTTL: 50
      retryBackoff: 500
      defaultAllow: false
```

#### Creating Custom Webhook kubeconfigfile:
```sh
nano custom-webhook.kubeconfig
```
```sh
apiVersion: v1
kind: Config
clusters:
- cluster:
    certificate-authority: /etc/kubernetes/controlconf/webhook.crt
    server: https://bouncer.local.lan:1323/image_policy
  name: bouncer_webhook
contexts:
- context:
    cluster: bouncer_webhook
    user: api-server
  name: bouncer_validator
current-context: bouncer_validator
preferences: {}
users:
- name: api-server
  user:
    client-certificate: /etc/kubernetes/controlconf/api-user.crt
    client-key: /etc/kubernetes/controlconf/api-user.key
```
#### Modify the kube-apiserver Manifest:
```sh
nano /etc/kubernetes/manifests/kube-apiserver.yaml
```
 Setting Host Alias:
```sh
hostAliases:
- ip: "134.209.147.191"
  hostnames:
  - "bouncer.local.lan"

- mountPath: /etc/kubernetes/controlconf
      name: admission-controller
      readOnly: true
```
```sh
  - hostPath:
      path: /etc/kubernetes/controlconf
      type: DirectoryOrCreate
    name: admission-controller
```
```sh
- --admission-control-config-file=/etc/kubernetes/controlconf/custom-config.yaml
```
#### Start the webhook service in a different tab:
```sh
kube-image-bouncer --cert webhook.crt --key webhook.key
```
#### Verification:
```sh
kubectl run dem-nginx --image=nginx:latest
kubectl run dem-nginx --image=nginx:1.19.2
```
