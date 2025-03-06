### Documentation Referred:

https://kubernetes.io/docs/concepts/storage/projected-volumes/#serviceaccounttoken

### Create ServiceAccount with Automount False
```sh
kubectl create namespace test-ns

kubectl edit sa default -n test-ns
```
Add following snippet:

`automountServiceAccountToken: false`

### Use Projected Volume to Mount Service Account to Pod
```sh
nano sa-example-1-yaml
```
```sh
apiVersion: v1
kind: Pod
metadata:
  name: pod-sa
  namespace: test-ns
spec:
  containers:
  - name: container-test
    image: busybox:1.37
    command: ["sleep", "3600"]
    volumeMounts:
    - name: token-vol
      mountPath: "/service-account"
      readOnly: true   
  volumes:
  - name: token-vol
    projected:
      sources:
      - serviceAccountToken:
          audience: api
          expirationSeconds: 3600
          path: token
```
```sh
kubectl create sa-example-1-yaml
```

#### Verification
```sh
kubectl exec -n test-ns -it pod-sa -- sh
ls -l /service-account
cat /service-account/token
```

```sh
kubectl delete -f sa-example-1-yaml
```
### Mount Custom Service Account
```sh
nano custom-sa.yaml
```
```sh
apiVersion: v1
kind: ServiceAccount
metadata:
  name: custom-sa
  namespace: test-ns
automountServiceAccountToken: false
```
```sh
kubectl create -f custom-sa.yaml
```

```sh
nano sa-example-2.yaml
```
```sh
apiVersion: v1
kind: Pod
metadata:
  name: pod-sa-custom
  namespace: test-ns
spec:
  serviceAccountName: custom-sa
  containers:
  - name: container-test
    image: busybox:1.37
    command: ["sleep", "3600"]
    volumeMounts:
    - name: token-vol
      mountPath: "/service-account"
      readOnly: true   
  volumes:
  - name: token-vol
    projected:
      sources:
      - serviceAccountToken:
          audience: api
          expirationSeconds: 3600
          path: token
```
```sh
kubectl create -f sa-example-2.yaml
```

#### Verification
```sh
kubectl exec -n test-ns -it pod-sa-custom -- sh
ls -l /service-account
cat /service-account/token
```

### Delet the Resources created
```sh
kubectl delete ns test-ns
```