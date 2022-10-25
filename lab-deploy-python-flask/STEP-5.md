
### <a name="step-5"></a>Step 5 - Create Container Image

To create a container image of the newly created API service we will use Docker.

Make sure you're already inside directory `python-app/`.

```
cd ~/python-app/
```

Create a new file named `Dockerfile`. This file will contain commands to build a container image. Put this file in the root of the project directory which should be inside `python-app/`.

```sh
touch Dockerfile
```

Copy and paste code below into `Dockerfile`.

```dockerfile
FROM public.ecr.aws/docker/library/python:3.8-slim

RUN mkdir -p /app
COPY requirements.txt run-server.sh /app/
COPY src/index.py /app/src/

WORKDIR /app
RUN pip install -r requirements.txt --target=/app/libs

ENTRYPOINT ["bash", "/app/run-server.sh"]
```

In Dockerfile above, we are using Python 3.8 which taken from Amazon ECR public repository. Then we copy source code files from host to container and run `pip install` to install all required packages. All the packages saved to `/app/libs`.

We will name this container image `indonesia-belajar` version `1.0`. To start building container image run following command. Notic there is `.` a dot at the end of the command.

```sh
docker build --rm -t indonesia-belajar:1.0 .
```

```
Sending build context to Docker daemon  11.65MB
...[CUT]...
Step 7/7 : ENTRYPOINT ["bash", "/app/run-server.sh"]
 ---> Running in 4b6b9075a846
Removing intermediate container 4b6b9075a846
 ---> 32dc2a5baec9
Successfully built 32dc2a5baec9
Successfully tagged indonesia-belajar:1.0
```

Check the image on the local machine.

```sh
docker images indonesia-belajar
```

```
REPOSITORY          TAG       IMAGE ID       CREATED          SIZE
indonesia-belajar   1.0       32dc2a5baec9   11 seconds ago   144MB
```

We successfully create container image `indonesia-belajar` version `1.0`. Next is to run our API from this new container image.

```sh
docker run --rm --name idn_belajar_1_0 -p 8080:8080 -d indonesia-belajar:1.0
```

```
da1a191143ed8b030e6e3d7536871821a35627384fdfe856114ae26406c1220b
```

Check using `ps` command to make sure the container is running.

```sh
docker ps
```

```
CONTAINER ID   IMAGE                   COMMAND                  CREATED         STATUS         PORTS                                       NAMES
da1a191143ed   indonesia-belajar:1.0   "bash /app/run-serve…"   9 seconds ago   Up 7 seconds   0.0.0.0:8080->8080/tcp, :::8080->8080/tcp   idn_belajar_1_0
```

Run `curl` command to make HTTP request to localhost port `8080` with parameter `text` is `Hello Belajar Indonesia`.

```sh
curl -s 'http://localhost:8080/?text=Hello%20Indonesia%20Belajar'
```

```
  _______________________
| Hello Indonesia Belajar |
  =======================
                       \
                        \
                          ^__^
                          (oo)\_______
                          (__)\       )\/\
                              ||----w |
                              ||     ||
```

Great! The API runs flawlessly in container. Now stop the container.

```sh
docker stop idn_belajar_1_0
```


<table border="0" style="width: 100%; display: table;"><tr><td><a href="STEP-4.md">&laquo; Previous</td><td align="center"><a href="README.md">Index</a></td><td align="right"><a href="STEP-6.md">Next &raquo;</a></td></tr></table>

<sup>Workshop: Deploy Python Flask dengan Amazon Lightsail Containers  
Version: 2022-14-06  
Author: [@rioastamal](https://github.com/rioastamal)</sup>
