
### <a name="step-5"></a>Step 5 - Create Container Image

To create a container image of the newly created API service we will use Docker.

Make sure you're already inside directory `nodejs-app/`.

```
cd ~/nodejs-app/
```

Create a new file named `Dockerfile`. This file will contain commands to build a container image. Put this file in the root of the project directory which should be inside `nodejs-app/`.

```sh
touch Dockerfile
```

Copy and paste code below into `Dockerfile`.

```dockerfile
FROM public.ecr.aws/docker/library/node:16-slim

RUN mkdir -p /opt/app
COPY package.json package-lock.json /opt/app/
COPY src/index.js /opt/app/src/

WORKDIR /opt/app
RUN npm install --production

ENTRYPOINT ["node", "src/index.js"]
```

We are using Node.js version which taken from Amazon ECR public repository. Then we copy the required files to the container and run `npm install` to get all dependencies.

We will name the container `id-belajar-node` version `1.0`. To start building the container image run the following command. Notice there is .a dot at the end of the command.

```sh
docker build --rm -t idn-belajar-node:1.0 .
```

```
...[CUT]...
Step 7/7 : ENTRYPOINT ["node", "src/index.js"]
 ---> Running in 8cd887da4164
Removing intermediate container 8cd887da4164
 ---> 6c88b5d7ef4a
Successfully built 6c88b5d7ef4a
Successfully tagged idn-belajar-node:1.0
```

Make sure the image is available on our local machine.

```sh
docker images idn-belajar-node
```

```
REPOSITORY         TAG       IMAGE ID       CREATED             SIZE
idn-belajar-node   1.0       6c88b5d7ef4a   3 minutes ago       179MB
```

As we can see that the container image has been successfully created with name `idn-belajar-node` and tagged with version `1.0`.

Now let's try to run the container `idn-belajar-node:1.0` on port `8080` to make sure that we can run the API using Docker.

```sh
docker run --rm --name idn_belajar_1_0 -p 8080:8080 -d idn-belajar-node:1.0
```

```
ec43c5f4ab04b920df9907bf981d3b7b0dd2c287d8599e1b7768e290694b8f16
```

Run `ps` to make sure the container `idn-belajar-node:1.0` is up and running.

```sh
docker ps
```

```
CONTAINER ID   IMAGE                  COMMAND               CREATED          STATUS          PORTS                                       NAMES
ec43c5f4ab04   idn-belajar-node:1.0   "node src/index.js"   24 seconds ago   Up 22 seconds   0.0.0.0:8080->8080/tcp, :::8080->8080/tcp   idn_belajar_1_0
```

Let's try to hit our current container using HTTP request on port `8080` and path `/`.

```sh
curl -s http://localhost:8080/
```

```json
{
  "hello": "Indonesia Belajar!"
}
```

Cool! The API run flawlessly in containers. Now stop the container.

```sh
docker stop idn_belajar_1_0
```


<table border="0" style="width: 100%; display: table;"><tr><td><a href="STEP-4.md">&laquo; Previous</td><td align="center"><a href="README.md">Index</a></td><td align="right"><a href="STEP-6.md">Next &raquo;</a></td></tr></table>

<sup>Workshop: Deploying Node.js App on Amazon Lightsail Containers  
Version: 2022-05-12  
Author: [@rioastamal](https://github.com/rioastamal)</sup>
