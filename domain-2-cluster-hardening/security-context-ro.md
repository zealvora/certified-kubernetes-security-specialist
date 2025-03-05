
### Security Context of readOnlyRootFilesystem
```sh
nano security-context-ro.yaml
```
```sh
apiVersion: v1
kind: Pod
metadata:
  name: readonly-pod
spec:
  containers:
  - name: demo
    image: busybox:1.37
    command: [ "sleep", "1h" ]
    securityContext:
      readOnlyRootFilesystem: true
```
```sh
kubectl create -f security-context-ro.yaml
```
#### Testing
```sh
kubectl exec -it readonly-pod -- sh

touch test.txt

cd tmp

touch test.txt
```
### Security Context of readOnlyRootFilesystem + emptyDir
```sh
nano security-context-ro-empty-dir.yaml
```
```sh
apiVersion: v1
kind: Pod
metadata:
  name: readonly-pod-emptydir
spec:
  containers:
    - name: my-container
      image: busybox:1.37
      command: [ "sleep", "1h" ]
      securityContext:
        readOnlyRootFilesystem: true
      volumeMounts:
        - name: tmp-storage
          mountPath: /tmp
  volumes:
    - name: tmp-storage
      emptyDir: {}
```
```sh
kubectl create -f security-context-ro-empty-dir.yaml
```

#### Testing
```sh
kubectl exec -it readonly-pod-emptydir -- sh

touch test.txt

cd tmp

touch test.txt
```