
#### Create a demo rule condition with the required output:
```sh
- rule: The program "cat" is run in a container
  desc: An event will trigger every time you run cat in a container
  condition: evt.type = execve and container.id != host and proc.name = cat
  output: demo %evt.time %user.name %proc.name
  priority: ERROR
  tags: [demo]
```

####  Dealing with Logging Use-Case:

```sh
timeout 25s falco | grep demo
nano /root/logs.txt
cat logs.txt | awk '{print $4 " " $5 " " $6}' > /tmp/logs.txt
cat /tmp/logs.txt
```
