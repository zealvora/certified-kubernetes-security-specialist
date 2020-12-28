
#### Step 1 - Create Permissive Policy:
```sh
mkdir /root/psp
cd /root/psp
```
```sh
nano permissive-psp.yaml
```
```sh
apiVersion: policy/v1beta1
kind: PodSecurityPolicy
metadata:
  name: permissive-psp
  annotations:
    seccomp.security.alpha.kubernetes.io/allowedProfileNames: '*'
spec:
  privileged: true
  allowPrivilegeEscalation: true
  allowedCapabilities:
  - '*'
  volumes:
  - '*'
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
```sh
kubectl apply -f permissive-psp.yaml
```
#### Step 2 - Create Cluster Role for Permissive Policy:
```sh
nano permissive-psp-cluster-role.yaml
```
```sh
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: permissive-cluster-role
rules:
- apiGroups: ['policy']
  resources: ['podsecuritypolicies']
  verbs:     ['use']
  resourceNames:
  - permissive-psp
```
```sh
kubectl apply -f permissive-psp-cluster-role.yaml
```
#### Step 3 - Create Cluster Role Binding to Bind PSP to Subjects:
```sh
nano permissive-psp-clusterbind.yaml
```
```sh
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
    name: permissive-psp-cluster-bind
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: permissive-cluster-role
subjects:
  - kind: Group
    apiGroup: rbac.authorization.k8s.io
    name: system:authenticated
```
```sh
kubectl apply -f permissive-psp-clusterbind.yaml
```
#### Step 4: Enable PodSecurityPolicy Admission Controller:
```sh
nano /etc/kubernetes/manifests/kube-apiserver.yaml
```
```sh
--enable-admission-plugins=PodSecurityPolicy
```
```sh
watch kubectl get pods -n kube-system
```
