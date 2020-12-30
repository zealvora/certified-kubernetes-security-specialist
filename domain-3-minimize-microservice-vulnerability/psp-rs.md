## Testing with base setup:

#### Apply the network addon components:
```sh
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml
```
Add PodSecurityPolicy under kube-apiserver.manifest.

####  Create PODS and Deployments to observe the object creation:
```sh
kubectl get psp
kubectl run nginx --image=nginx
kubectl create deployment nginx-deploy --image=nginx
kubectl get deployment
```
####  Create ReplicationController to observe the object creation:

```sh
nano rc.yaml
```
```sh
apiVersion: v1
kind: ReplicationController
metadata:
  name: nginx
spec:
  replicas: 3
  selector:
    app: nginx
  template:
    metadata:
      name: nginx
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: nginx
        ports:
        - containerPort: 80
```
```sh
kubectl apply -f rc.yaml
kubectl get rc
kubectl describe rc nginx
```
## Testing with Possible Solution 1:

#### Step 1: Create a Permissive PSP
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
```sh
kubectl get psp
```
#### Step 2 - Create Cluster Role:

```sh
nano clusterrole.yaml
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
kubectl apply -f clusterrole.yaml
```
#### Step 3 - Create Cluster Role Binding:

```sh
nano clusterrolebinding.yaml
```
```sh
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  name: psp-default
subjects:
- kind: Group
  name: system:serviceaccounts
  namespace: kube-system
roleRef:
  kind: ClusterRole
  name: permissive-cluster-role
  apiGroup: rbac.authorization.k8s.io
```

```sh
kubectl delete -f rc.yaml
kubectl apply -f clusterrolebinding.yaml
```
```sh
kubectl apply -f rc.yaml
kubectl get rc
```
Let us delete existing resources before we move to a better solution
```sh
kubectl delete -f rc.yaml
kubectl delete -f clusterrole.yaml
kubectl delete -f clusterrolebinding.yaml
```
## Testing with Possible Solution 2 (Better Approach):

#### Step 1 - Create a new namespace:
```sh
kubectl create namespace demo-namespace
```
#### Step 2 - Create a Role:
```sh
nano role.yaml
```
```sh
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: psp-permissive
  namespace: demo-namespace
rules:
- apiGroups: ['policy']
  resources: ['podsecuritypolicies']
  verbs:     ['use']
  resourceNames:
  - permissive-psp
```
```sh
kubectl apply -f role.yaml
```
#### Step 3 -  Create a Role Binding:
```sh
nano rb.yaml
```
```sh
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: psp-permissive
  namespace: demo-namespace
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: Role
  name: psp-permissive
subjects:
- kind: ServiceAccount
  name: default
  namespace: demo-namespace
```
```sh
kubectl apply -f rb.yaml
```
```sh
kubectl apply -f rc.yaml -n demo-namespace
```
