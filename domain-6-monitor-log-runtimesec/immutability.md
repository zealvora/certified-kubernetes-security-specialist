
#### Create a POD with ReadOnlyRootFileSystem:

```sh
nano immutable.yaml
```
```sh
apiVersion: v1
kind: Pod
metadata:
  name: immutable-pod
spec:
  containers:
  - name: ubuntu
    image: ubuntu
    command: ["sleep","3600"]
    securityContext:
      readOnlyRootFilesystem: true
```

#### Verification:
```sh
kubectl exec -it immutable-pod -- bash
touch file.txt
```
