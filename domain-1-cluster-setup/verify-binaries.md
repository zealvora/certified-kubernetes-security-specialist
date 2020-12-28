  #### Kubernetes GitHub Repository:

  https://github.com/kubernetes/kubernetes/releases

  #### Step 1 - Download Binaries:
  ```sh
  wget https://github.com/kubernetes/kubernetes/releases/download/v1.18.12/kubernetes.tar.gz
  ```

  #### Step 2 - Verify the Message Digest:
  ```sh
  apt install hashalot
  sha256 kubernetes.tar.gz
  sha512sum kubernetes.tar.gz
  ```
