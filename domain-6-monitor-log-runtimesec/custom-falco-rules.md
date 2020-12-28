
### Documentation:

https://falco.org/docs/rules/supported-fields/

#### 1st - Basic Rule:
```sh
- rule: The program "cat" is run in a container
  desc: An event will trigger every time you run cat in a container
  condition: evt.type = execve and container.id != host and proc.name = cat
  output: "cat was run inside a container"
  priority: INFO
```
#### 2nd rule - Using Sysdig Field Class Elements:
```sh
- rule: The program "cat" is run in a container
  desc: An event will trigger every time you run cat in a container
  condition: evt.type = execve and container.id != host and proc.name = cat
  output: "cat was run inside a container (user=%username container=%container.name image=%container.image proc=%proc.cmdline)"
  priority: INFO
```
#### 3rd rule - Using Macros and List:
```sh
- macro: custom_macro
  condition: evt.type = execve and container.id != host

- list: blacklist_binaries
  items: [cat, grep,date]

- rule: The program "cat" is run in a container
  desc: An event will trigger every time you run cat in a container
  condition: custom_macro and proc.name in (blacklist_binaries)
  output: "cat was run inside a container (user=%user.name container=%container.name image=%container.image proc=%proc.cmdline)"
  priority: INFO
```

#### Part 2: Add Output
```sh
- rule: The program "cat" is run in a container
  desc: An event will trigger every time you run cat in a container
  condition: evt.type = execve and container.id != host and proc.name = cat
  output: demo %evt.time %user.name %container.name
  priority: ERROR
  tags: [demo]
```
