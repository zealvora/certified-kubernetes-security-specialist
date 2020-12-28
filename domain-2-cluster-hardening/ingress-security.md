### Documentation Referred:

https://kubernetes.io/docs/concepts/services-networking/ingress/

#### Step 1 - Create Self Signed Certificate for Domain:
```sh
mkdir ingress
cd ingress
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout ingress.key -out ingress.crt -subj "/CN=example.internal/O=security"
```
#### Step 2 - Create Kubernetes TLS based secret :
```sh
kubectl create secret tls tls-cert --key ingress.key --cert ingress.crt
kubectl get secret tls-cert -o yaml
```
#### Step 3 - Create Kubernetes Ingress with TLS:
```sh
kubectl delete ingress example-ingress
```
```sh
nano ingress-tls.yaml
```
```sh
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: demo-ingress
  annotations:
     nginx.ingress.kubernetes.io/rewrite-target: /
spec:
  tls:
  - hosts:
      - example.internal
    secretName: tls-cert
  rules:
  - host: example.internal
    http:
      paths:
      - pathType: Prefix
        path: "/"
        backend:
          service:
            name: example-service
            port:
              number: 80
```
```sh
kubectl apply -f ingress-tls.yaml
```
#### Step 4 - Make a request to Controller:
```sh
kubectl get svc -n ingress-nginx

curl -kv https://example.internal:31893
```
