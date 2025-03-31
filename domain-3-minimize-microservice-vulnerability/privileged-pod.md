### Documentation Referenced:

https://kubernetes.io/docs/tasks/configure-pod-container/security-context/

#### Create Non-Privileged Pod
```sh
kubectl run non-privileged --image=busybox -- sleep 36000
```
#### Create Privileged Pod
```sh
kubectl run privileged-pod --image=busybox --privileged -- sleep 36000
```

### Connect to Both the Pods in Two Separate Terminal Tabs
```sh
kubectl exec -it non-privileged -- sh

kubectl exec -it privileged-pod -- sh
```

### Run Commands in Both Pods to See Difference
```sh
cd /dev
ls

dmesg

fdisk -l
```

#### Verify Manifest File Associated with Privileged Pod

```sh
kubectl run privileged-pod --image=busybox --dry-run=client -o yaml --privileged -- sleep 36000
```
