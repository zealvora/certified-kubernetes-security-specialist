### Configure Kubeadm for Control Plane Node
```sh
curl -L https://raw.githubusercontent.com/zealvora/certified-kubernetes-security-specialist/refs/heads/main/domain-2-cluster-hardening/kubeadm-automate.sh -o kubeadm-control-plane.sh

chmod +x kubeadm-control-plane.sh

./kubeadm-control-plane.sh
```

### Configure Kubeadm for Worker Node (Run in Worker Node)
```sh
curl -L https://raw.githubusercontent.com/zealvora/certified-kubernetes-security-specialist/refs/heads/main/domain-2-cluster-hardening/kubeadm-worker-automate.sh -o kubeadm-worker.sh

chmod +x kubeadm-worker.sh

./kubeadm-worker.sh
```
Use the `kubeadm join` command that was generated in your Control Plane Node server. The below command is just for reference.
```sh
kubeadm join 209.38.120.248:6443 --token 9vxoc8.cji5a4o82sd6lkqa \
        --discovery-token-ca-cert-hash sha256:1818dc0a5bad05b378dd3dcec2c048fd798e8f6ff69b396db4f5352b63414baf
```

