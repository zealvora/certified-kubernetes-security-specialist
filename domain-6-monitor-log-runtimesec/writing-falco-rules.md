### Documentation Refernced:
https://falco.org/docs/concepts/rules/basic-elements/

https://falco.org/docs/reference/rules/supported-fields/

https://falco.org/docs/reference/rules/default-macros/

### Create a Simple Falco Rule.
```sh
- rule: Detect curl Execution in Kubernetes Pod
  desc: Detects when the curl utility is executed within a Kubernetes pod.
  condition: >
    spawned_process and container and
    proc.name = "curl"
  output: >
    Suspicious process detected (curl) inside a Container.
  priority: WARNING
```


### Testing
```sh
systemctl restart falco

kubectl run nginx-pod --image=nginx

kubectl exec -it nginx-pod -- bash

curl google.com
```

### Improvement in Falco Rule Output

```sh
- rule: Detect curl Execution in Kubernetes Pod
  desc: Detects when the curl utility is executed within a Kubernetes pod.
  condition: >
    spawned_process and container and
    proc.name = "curl"
  output: >
    Suspicious process detected (curl) inside a container_id=%container.id and container_name=%container.name
  priority: WARNING
```

```sh
systemctl restart falco
```


### Using Macros
```sh
- macro: sensitive_files
  condition: fd.name in (/tmp/sensitive.txt)

- rule: Access to Sensitive Files
  desc: Detect any process attempting to read or write sensitive files
  condition: sensitive_files
  output: "Sensitive file access detected (user=%user.name process=%proc.name file=%fd.name)"
  priority: WARNING
```

```sh
touch /tmp/sensitive.txt

systemctl restart falco
```
### Optimized Macro Rule
```sh
- macro: sensitive_files
  condition: fd.name in (/tmp/sensitive.txt)

- rule: Access to Sensitive Files
  desc: Detect any process attempting to read or write sensitive files
  condition: open_read and sensitive_files
  output: "Sensitive file access detected (user=%user.name process=%proc.name file=%fd.name)"
  priority: WARNING
```

```sh
echo "Hi" /tmp/sensitive.txt
```