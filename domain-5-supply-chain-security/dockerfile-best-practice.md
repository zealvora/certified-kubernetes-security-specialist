```sh
nano app.sh
```
```sh
#!/bin/sh
echo "Hello, Docker"
```
### Base Dockerfile

```sh
FROM ubuntu:18.04
USER root
RUN apt-get update
RUN apt-get install -y curl
RUN apt-get install -y wget
RUN apt-get install -y nano
EXPOSE 80
WORKDIR /usr/src/app
COPY app.sh .
RUN chmod -R 777 /usr/src/app/app.sh
CMD ["./app.sh"]
```

#### Verification
```sh
docker build -t myapp:v1 .

docker images

docker run myapp:v1
```
### Revision 1 - DockerFile
```sh
echo > Dockerfile
```
```sh
FROM ubuntu:24.10

RUN apt-get update && \
    apt-get install -y curl && \
    apt-get install -y wget && \
    apt-get install -y nano && \
    useradd appuser

EXPOSE 80
WORKDIR /usr/src/app
COPY app.sh .

RUN chmod 700 app.sh && chown appuser:appuser app.sh
USER appuser
CMD ["./app.sh"]
```
#### Verification
```sh
docker build -t myapp:v2 .

docker images

docker run myapp:v2
```

### Revision 2 DockerFile
```sh
FROM alpine:latest
WORKDIR /usr/src/app
COPY app.sh .
RUN chmod +x app.sh
RUN adduser -D appuser && chown appuser:appuser app.sh
USER appuser
CMD ["/usr/src/app/app.sh"]
```

#### Verification
```sh
docker build -t myapp:v3 .

docker images

docker run myapp:v3
```