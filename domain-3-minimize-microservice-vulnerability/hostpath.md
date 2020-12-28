#### Create a HostPath Volume:
```sh
nano host-path.yaml
```
```sh
apiVersion: v1
kind: Pod
metadata:
  name: hostpath-pod
spec:
  containers:
  - image: nginx
    name: test-container
    volumeMounts:
    - mountPath: /host-path
      name: host-volume
  volumes:
  - name: host-volume
    hostPath:
      path: /
```
```sh
kubectl apply -f host-path.yaml
kubectl exec -it hostpath-pod -- bash
```
#### Improved Pod Security Policy:
```sh
nano /root/psp/restrictive-psp.yaml
```
```sh
apiVersion: policy/v1beta1
kind: PodSecurityPolicy
metadata:
  name: restrictive-psp
  annotations:
    seccomp.security.alpha.kubernetes.io/allowedProfileNames: '*'
spec:
  privileged: false
  allowPrivilegeEscalation: true
  allowedCapabilities:
  - '*'
  volumes:
  - configMap
  -  downwardAPI
  -  emptyDir
  -  persistentVolumeClaim
  -  secret
  -  projected
  hostNetwork: true
  hostPorts:
  - min: 0
    max: 65535
  hostIPC: true
  hostPID: true
  runAsUser:
    rule: 'RunAsAny'
  seLinux:
    rule: 'RunAsAny'
  supplementalGroups:
    rule: 'RunAsAny'
  fsGroup:
    rule: 'RunAsAny'
```
