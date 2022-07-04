  #### Kubernetes GitHub Repository:

  https://github.com/kubernetes/kubernetes/releases

  #### Step 1 - Download Binaries:
  ```sh
 wget https://dl.k8s.io/v1.24.2/kubernetes-server-linux-amd64.tar.gz
  ```

  #### Step 2 - Verify the Message Digest:
  ```sh
  apt install hashalot
  sha512sum kubernetes-server-linux-amd64.tar.gz
  ```
