
#### Step 1 - Create Nginx Pod:
```sh
kubectl run example-pod --image=nginx -l=app=nginx
```
#### Step 2 - Create Service:
```sh
kubectl expose example-pod nginx --port=80 --target-port=80 --name=example-svc
```
#### Step 3 - Installing Ingress Controller:
```sh
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.8.2/deploy/static/provider/baremetal/deploy.yaml
```
#### Step 4 - Create Ingress:
```sh
nano ingress.yaml
```
```sh
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: example-ingress
  annotations:
     nginx.ingress.kubernetes.io/rewrite-target: /
spec:
  ingressClassName: nginx
  rules:
  - host: example.internal
    http:
      paths:
      - pathType: Prefix
        path: "/"
        backend:
          service:
            name: example-svc
            port:
              number: 80
```
```sh
kubectl apply -f ingress.yaml
```
#### Step 5 - Verification:
```sh
kubectl get svc -n ingress-nginx
apt install net-tools
ifconfig eth0
```
Add appropriate host entry accordingly.
```sh
nano /etc/hosts
```
```sh
curl http://example.internal:30429
```
