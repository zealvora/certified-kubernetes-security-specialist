#### Step 0 - Create Namespace:
```sh
kubectl create namespace development
kubectl create namespace production
```
#### Step 1 - Create Cluster Role:
```sh
nano clusterrole.yaml
```
```sh
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: cluster-pod-reader
rules:
- apiGroups: [""]
  resources: ["pods"]
  verbs: ["get", "watch", "list","create"]
- apiGroups: [""]
  resources: ["pods/exec"]
  verbs: ["create"]
  ```
```sh
kubectl apply -f clusterrole.yaml
```
```sh
kubectl get clusterrole
```

#### Step 2 - Create Cluster Role Binding:
```sh
nano clusterrolebinding.yaml
```
```sh
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: read-pods-global
subjects:
- kind: User
  name: john
  apiGroup: rbac.authorization.k8s.io
roleRef:
  kind: ClusterRole
  name: cluster-pod-reader
  apiGroup: rbac.authorization.k8s.io
```
```sh
kubectl apply -f clusterrolebinding.yaml
```
#### Step 3 - Verification:
```sh
su - john
kubectl run john-pod-dev --image=nginx -n development
kubectl exec -it -n development john-pod-dev -- bash
```
#### Step 4 - RoleBinding to ClusterRole:
```sh
kubectl delete -f clusterrolebinding.yaml
```
```sh
nano rolebind-cluster.yaml
```
```sh
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: dev-pods
  namespace: development
subjects:
- kind: User
  name: john
  apiGroup: rbac.authorization.k8s.io
roleRef:
  kind: ClusterRole
  name: cluster-pod-reader
  apiGroup: rbac.authorization.k8s.io
```
```sh
kubectl apply -f rolebind-cluster.yaml
kubectl exec -it -n development john-pod-dev -- bash
```
