  #### Explore the API Groups:
```sh
kubectl proxy --port 8085
```
```sh
curl localhost:8085
curl localhost:8085/api/v1
```
  #### Step 1 Create RBAC Role:
```sh
  nano rbac.yaml
```
```sh
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  namespace: default
  name: pod-reader
rules:
- apiGroups: [""]
  resources: ["pods"]
  verbs: ["get", "watch", "list","create"]
- apiGroups: [""]
  resources: ["pods/exec"]
  verbs: ["create"]
```
```sh
kubectl apply -f rbac.yaml
```
```sh
kubectl get role
kubectl describe role pod-reader
```
  #### Step 2 Create Role Binding:
```sh
nano rolebinding.yaml
```
```sh
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: read-pods
  namespace: default
subjects:
- kind: User
  name: john
  apiGroup: rbac.authorization.k8s.io
roleRef:
  kind: Role
  name: pod-reader
  apiGroup: rbac.authorization.k8s.io
```
```sh
kubectl apply -f rolebinding.yaml
kubectl get rolebinding
kubectl describe rolebinding read-pods
```
  #### Step 3 - Verify from user John:
```sh
su - john
kubectl get pods
kubectl run john-pod --image=nginx
kubectl exec -it john-pod -- bash
  ```
  #### Step 4 Verify API Access Action:
```sh
kubectl auth can-i create deployments
kubectl auth can-i create pods
```
