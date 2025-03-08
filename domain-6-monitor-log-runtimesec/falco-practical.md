
### Monitor Falco Logs (Terminal Tab 1)
```sh
systemctl status falco 

journalctl -u falco-modern-bpf.service -f
```
### Testing
```sh
cat /etc/shadow

kubectl run nginx-pod --image=nginx

kubectl exec -it nginx-pod -- bash
```

