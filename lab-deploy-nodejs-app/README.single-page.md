<a name="top"></a>

<!-- begin step-0 -->

DRAFT - Need a review for any spelling or grammatical errors.

## Workshop Deploying Node.js App on Amazon Lightsail Containers

In this workshop, participants will be guided how to deploy an API on Amazon Lightsail Containers. A simple API built with Node.js and Express.js framework will be used as an example in this workshop.

Participants can follow the workshop guide through steps that have been provided sequentially starting from step 1 to step 15.

- [Step 1 - Requirements](#step-1)
- [Step 2 - Install Lightsail Control Plugin](#step-2)
- [Step 3 - Create Directory for the Project](#step-3)
- [Step 4 - Create Node.js API](#step-4)
- [Step 5 - Create Container Image](#step-5)
- [Step 6 - Create Container Service on Amazon Lightsail](#step-6)
- [Step 7 - Push Container Image to Amazon Lightsail](#step-7)
- [Step 8 - Deploy Container Service](#step-8)
- [Step 9 - Create New Version of the API](#step-9)
- [Step 10 - Updating Container Image](#step-10)
- [Step 11 - Pushing New Version of Container Image](#step-11)
- [Step 12 - Deploying the New API](#step-12)
- [Step 13 - Increasing Number of Nodes](#step-13)
- [Step 14 - Rollback Container to Previous Deployment](#step-14)
- [Step 15 - Remove Amazon Lightsail Container Service](#step-15)

If you prefer all steps on one page then please open [README.single-page.md](README.single-page.md).

<!-- end step-0 -->

<!-- begin step-1 -->

### <a name="step-1"></a>Step 1 - Requirements

Before starting the workshop, make sure you have an active AWS account and have installed requirements listed below.

- Docker
- AWS CLI v2 and its configuration
- Node.js v16

[^back to top](#top)

<!-- end step-1 -->

<!-- begin step-2 -->

### <a name="step-2"></a>Step 2 - Install Lightsail Control Plugin

This CLI plugin is used to upload container image from your local computer to the Amazon Lightsail container service. Run the following command to install the Lightsail Control Plugin. It is assumed that there is `sudo` command on your Linux distribution.

```sh
sudo curl "https://s3.us-west-2.amazonaws.com/lightsailctl/latest/linux-amd64/lightsailctl" -o "/usr/local/bin/lightsailctl"
```

Add an execute attribute to `lightsailctl` file.

```sh
sudo chmod +x /usr/local/bin/lightsailctl
```

Make sure the attribute is applied to the file. It is indicated by letter `x` in the attribute list, for an example `rwxr-xr-x`

```sh
ls -l /usr/local/bin/lightsailctl
```

```
-rwxr-xr-x 1 root root 13201408 May 28 03:16 /usr/local/bin/lightsailctl
```

[^back to top](#top)

<!-- end step-2 -->

<!-- begin step-3 -->

### <a name="step-3"></a>Step 3 - Create Directory for the Project

Make sure you're in `$HOME` directory which is `/home/ec2-user`.

```sh
cd ~
pwd 
```

```
/home/ec2-user/
```

Then create new directory named `nodejs-app`.

```sh
mkdir nodejs-app
```

Go to that directory, we will place the neccessary files there.


```sh
cd nodejs-app
pwd
```

```
/home/ec2-user/nodejs-app
```

[^back to top](#top)

<!-- end step-3 -->

<!-- begin step-4 -->

### <a name="step-4"></a>Step 4 - Create Node.js API

In this step we will create a simple API built using Express, one of the most popular Node.js framework for web development.

```sh
echo '{}' > package.json
```

```sh
npm install --save express
```

Next create a new directory named `src/` to place the source code.

```sh
mkdir src/
```

Buat sebuah file `src/index.js`, ini adalah file utama dimana kode API yang akan kita buat.

Create a file `src/index.js`, this is the file where we will put our main API codes.

```sh
touch src/index.js
```

Copy and paste code below into `src/index.js`.

```js
const express = require('express');
const app = express();
const port = process.env.APP_PORT || 8080;

app.set('json spaces', 2);
app.get('/', function mainRoute(req, res) {
  const mainResponse = {
    "hello": "Indonesia Belajar!"
  };
  
  res.json(mainResponse);
});

app.listen(port, function() {
  console.log(`API server running on port ${port}`);
});
```

Code above will run HTTP server on port 8080. When we access path `/` it should return JSON with the following format.

```json
{
  "hello": "Indonesia Belajar!"
}
```

Now try to run the code to make sure it the API runs as expected.

```
node src/index.js
```

```
API server running on port 8080
```

Test by doing HTTP request to the localhost port `8080`.

```sh
curl -s -D /dev/stdout http://localhost:8080
```

```
HTTP/1.1 200 OK
X-Powered-By: Express
Content-Type: application/json; charset=utf-8
Content-Length: 35
ETag: W/"23-73aYo86Xbum4YcZxsMv0wFJ4BiY"
Date: Tue, 05 Apr 2022 07:58:08 GMT
Connection: keep-alive
Keep-Alive: timeout=5

{
  "hello": "Indonesia Belajar!"
}
```

Cool!. Our API successfully run as expected. It's time to package it into a container image.

[^back to top](#top)

<!-- end step-4 -->

<!-- begin step-5 -->

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

[^back to top](#top)

<!-- end step-5 -->

<!-- begin step-6 -->

### <a name="step-6"></a>Step 6 - Create Container Service on Amazon Lightsail

The container service is the compute resource on which the container is run. It provides many choices of RAM and vCPU capacities that can be selected according to your application needs. In addition you can also specify the number of nodes on which container is running.

1. Go to AWS Management Console then go to Amazon Lightsail page. On the Amazon Lightsail Dashboard click the **Containers** menu.

[![Lightsail Containers Menu](https://raw.githubusercontent.com/rioastamal-examples/assets/main/workshop-amazon-lightsail-containers/lab-deploy-nodejs-app/images/lightsail-menu-containers.png)](https://raw.githubusercontent.com/rioastamal-examples/assets/main/workshop-amazon-lightsail-containers/lab-deploy-nodejs-app/images/lightsail-menu-containers.png)

> Figure 1. The Containers menu on Amazon Lightsail

2. On the Containers page click the **Create container service** button to start creating a Container service.

[![Lightsail Create Instance Button](https://raw.githubusercontent.com/rioastamal-examples/assets/main/workshop-amazon-lightsail-containers/lab-deploy-nodejs-app/images/lightsail-button-create-instance.png)](https://raw.githubusercontent.com/rioastamal-examples/assets/main/workshop-amazon-lightsail-containers/lab-deploy-nodejs-app/images/lightsail-button-create-instance.png)

> Figure 2. Containers page contain a list of containers created

3. Then we will be faced with several choices. In the _Container service location_ option, select the a region, in this case I choose **Singapore**. Click the **Change AWS Region** link to do so. In the container capacity option, select **Nano** which consist of 512MB RAM and 0.25 vCPU. For the scale option specify **x1**. It means that we will only launch 1 node to run the containers.


[![Lightsail Choose Container Capacity](https://raw.githubusercontent.com/rioastamal-examples/assets/main/workshop-amazon-lightsail-containers/lab-deploy-nodejs-app/images/lightsail-choose-container-capacity.png)](https://raw.githubusercontent.com/rioastamal-examples/assets/main/workshop-amazon-lightsail-containers/lab-deploy-nodejs-app/images/lightsail-choose-container-capacity.png)

> Figure 3. Selecting region and capacity of the container

4. Next is to determine the name of the service. In the _Identify your service_ section, enter **hello-api**. At the _Summary_ section as we can see we will launch a container with a **Nano** capacity (512MB RAM, 0.25 vCPU)  **x1**. Total cost for this container service is **$7** per month. All is set now click  **Create container service** button.

[![Lightsail Choose Service Name](https://raw.githubusercontent.com/rioastamal-examples/assets/main/workshop-amazon-lightsail-containers/lab-deploy-nodejs-app/images/lightsail-choose-service-name.png)](https://raw.githubusercontent.com/rioastamal-examples/assets/main/workshop-amazon-lightsail-containers/lab-deploy-nodejs-app/images/lightsail-choose-service-name.png)

> Figure 4. Entering the container service name

5. The creation of container service will take few minutes, so be patient. Once done you will be taken to the dashboard of the **hello-api** container service page. You will get a domain to used to access your container. The domain is located at the _Public domain_ section. Wait until the status becomes **Ready** then click the domain to open **hello-api** container service. It should be still 404 error because no container image has been deployed to the container service.

[![Lightsail hello-api Dashboard](https://raw.githubusercontent.com/rioastamal-examples/assets/main/workshop-amazon-lightsail-containers/lab-deploy-nodejs-app/images/lightsail-hello-api-dashboard.png)](https://raw.githubusercontent.com/rioastamal-examples/assets/main/workshop-amazon-lightsail-containers/lab-deploy-nodejs-app/images/lightsail-hello-api-dashboard.png)

> Figure 5. Dashboard of the hello-api container service

[![https://raw.githubusercontent.com/rioastamal-examples/assets/main/workshop-amazon-lightsail-containers/lab-deploy-nodejs-app/images/lightsail-404-hello-api.png](https://raw.githubusercontent.com/rioastamal-examples/assets/main/workshop-amazon-lightsail-containers/lab-deploy-nodejs-app/images/lightsail-404-hello-api.png)](https://raw.githubusercontent.com/rioastamal-examples/assets/main/workshop-amazon-lightsail-containers/lab-deploy-nodejs-app/images/lightsail-404-hello-api.png)

> Figure 6. hello-api service returns 404 because no container image has been deployed

[^back to top](#top)

<!-- end step-6 -->

<!-- begin step-7 -->

### <a name="step-7"></a>Step 7 - Push Container Image to Amazon Lightsail

Each container image pushed to Amazon Lightsail is bound to a container cervice. That's why we created the **hello-api** container service first before pushing the container image.

In this step we will push `idn-belajar-node:1.0` the previously created container image to **hello-api** container service. Run command below.

```sh
aws lightsail push-container-image \
--region "ap-southeast-1" \
--service-name "hello-api" \
--label "idn-belajar-node" \
--image "idn-belajar-node:1.0"
```

```
...[CUT]...
c1065d45b872: Pushed 
Digest: sha256:236b7239c44e16ac44a94b92350b3e409ca7631c9663b5242f8a2d2175603417
Image "idn-belajar-node:1.0" registered.
Refer to this image as ":hello-api.idn-belajar-node.2" in deployments.
```

You will get a message similar to the one above once the push is successfull. The container image will be saved with the name `:<container-service>:<label>.<upload-number>` in the example above the name is `:hello-api.idn-belajar.2`. Yours `upload-number` could be different.

Now make sure the container image has been uploaded, go to the **Images** page.

[![Lightsail hello-api Image](https://raw.githubusercontent.com/rioastamal-examples/assets/main/workshop-amazon-lightsail-containers/lab-deploy-nodejs-app/images/lightsail-hello-api-image.png)](https://raw.githubusercontent.com/rioastamal-examples/assets/main/workshop-amazon-lightsail-containers/lab-deploy-nodejs-app/images/lightsail-hello-api-image.png)

> Figure 7. List of uploaded container images

As you can see on the _Images_ page there is an container image `:hello-api.idn-belajar.2` that we just uploaded from previous step. We will use this image to do the deployment.

[^back to top](#top)

<!-- end step-7 -->

<!-- begin step-8 -->

### <a name="step-8"></a>Step 8 - Deploy Container Service

This step will create new deployment for **hello-api** container service using container image `:hello-api.idn-belajar.2`.

1. On the **hello-api** dashboard click the **Deployments** menu and then click the **Create your first deployment** link.

[![https://raw.githubusercontent.com/rioastamal-examples/assets/main/workshop-amazon-lightsail-containers/lab-deploy-nodejs-app/images/lightsail-hello-api-deployments-menu.png](https://raw.githubusercontent.com/rioastamal-examples/assets/main/workshop-amazon-lightsail-containers/lab-deploy-nodejs-app/images/lightsail-hello-api-deployments-menu.png)](https://raw.githubusercontent.com/rioastamal-examples/assets/main/workshop-amazon-lightsail-containers/lab-deploy-nodejs-app/images/lightsail-hello-api-deployments-menu.png)

> Figure 8. Create your first deployment link

2. There are several fields need to be completed. First enter **hello-idn-belajar** for the _Container name_. 
3. For the _Image_ option, click **Choose stored image** then choose our container image that has been uploaded.
4. The API only uses single environment variable named `APP_PORT` to determine which port the app should bind to. Default to port `8080`. Although it is optional we will explicitly provide the env just to make it more clear.
5. For the **Open ports** configuration, use port number where the app is running in this case should be the same as `APP_PORT` value which is `8080`.
6. For **PUBLIC ENDPOINT** use container **idn-hello-belajar**. All traffic coming from public endpoint will be forwarded to this container.
7. If everything is set, click **Save and deploy** to deploy. 

This process will take several minutes. Wait until the status of the Container service becomes **Running**.

[![Lightsail Create Deployment](https://raw.githubusercontent.com/rioastamal-examples/assets/main/workshop-amazon-lightsail-containers/lab-deploy-nodejs-app/images/lightsail-hello-api-create-deployment.png)](https://raw.githubusercontent.com/rioastamal-examples/assets/main/workshop-amazon-lightsail-containers/lab-deploy-nodejs-app/images/lightsail-hello-api-create-deployment.png)

> Figure 9. Deployment configuration for containers

When the status is **Running** then we can try to access the API by opening the URL in the public domain section. The public endpoint use HTTPS protocol. We will use curl to do the test. Run command below and replace with your own public domain.

```sh
curl -s https://YOUR_OWN_CONTAINER_SERVICE_PUBLIC_DOMAIN/
```

```json
{
  "hello": "Indonesia Belajar!"
}
```

Congrats! You gave successfully deployed a Node.js API on Amazon Lightsail Container service. Pretty easy isn't it?

[^back to top](#top)

<!-- end step-8 -->

<!-- begin step-9 -->

### <a name="step-9"></a>Step 9 - Create New Version of the API

Every application will almost certainly having an update whether for bug fixes or adding new features. In this step we will try to demonstrate how to update an application on Amazon Lightsail Container service.

We will change the API code by adding new feature to display network information of the system.

Make sure you're in `nodejs-app` directory. Then change the contents of `src/index.js` as shown below.

```js
const express = require('express');
const app = express();
const port = process.env.APP_PORT || 8080;
const { networkInterfaces } = require('os');

app.set('json spaces', 2);
app.get('/', function mainRoute(req, res) {
  const network = networkInterfaces();
  delete network['lo']; // remove loopback interface
  
  const mainResponse = {
    "hello": "Indonesia Belajar!",
    "network": network
  };
  
  res.json(mainResponse);
});

app.listen(port, function() {
  console.log(`API server running on port ${port}`);
});
```

As you see we add `network` attribute to the response. To test the new code, run the API server.

```sh
node src/index.js
```

```
API server running on port 8080
```

Do a HTTP request to the API to URL `http://localhost:8080/`.

```sh
curl -s http://localhost:8080/
```

```json
{
  "hello": "Indonesia Belajar!",
  "network": {
    "eth0": [
      {
        "address": "172.31.29.226",
        "netmask": "255.255.240.0",
        "family": "IPv4",
        "mac": "02:08:fa:7e:c3:c6",
        "internal": false,
        "cidr": "172.31.29.226/20"
      },
      {
        "address": "fe80::8:faff:fe7e:c3c6",
        "netmask": "ffff:ffff:ffff:ffff::",
        "family": "IPv6",
      
        "mac": "02:08:fa:7e:c3:c6",
        "internal": false,
        "cidr": "fe80::8:faff:fe7e:c3c6/64",
        "scopeid": 2
      }
    ]
  }
}
```

The API works as expected by returning network attribute.

[^back to top](#top)

<!-- end step-9 -->

<!-- begin step-10 -->

### <a name="step-10"></a>Step 10 - Update Container Image

Our new API is ready, next is to update the container image `idn-belajar-node`. We will release the new API with tag `2.0`. To do this follow step below.

```sh
docker build --rm -t idn-belajar-node:2.0 .
```

```
...[CUT]...
Step 7/7 : ENTRYPOINT ["node", "src/index.js"]
 ---> Running in f1245cc03183
Removing intermediate container f1245cc03183
 ---> c83f20a98c54
Successfully built c83f20a98c54
Successfully tagged idn-belajar-node:2.0
```

Let see if our new container image is on the list.

```sh
docker images idn-belajar-node
```

```
REPOSITORY         TAG       IMAGE ID       CREATED          SIZE
idn-belajar-node   2.0       c83f20a98c54   22 minutes ago   179MB
idn-belajar-node   1.0       6c88b5d7ef4a   2 days ago       179MB
```

Let's run our `idn-belajar-node:2.0` to make sure it is run as expected.

```sh
docker run --rm --name idn_belajar_2_0 -p 8080:8080 -d idn-belajar-node:2.0
```

```
d8df1a6d0dbd70de4cd36ff21e5b6a766a7bb0c21d28819d37fdff612aefe23c
```

Do a HTTP request to the API to URL `http://localhost:8080/` to check the API response.

```sh
curl -s http://localhost:8080/
```

```json
{
  "hello": "Indonesia Belajar!",
  "network": {
    "eth0": [
      {
        "address": "172.17.0.2",
        "netmask": "255.255.0.0",
        "family": "IPv4",
        "mac": "02:42:ac:11:00:02",
        "internal": false,
        "cidr": "172.17.0.2/16"
      }
    ]
  }
}
```

As you can see we have `network` attribute from the response. The ouput not exactly similar with non-container because the network interfaces inside the container are different from the host.

[^back to top](#top)

<!-- end step-10 -->

<!-- begin step-11 -->

### <a name="step-11"></a>Step 11 - Push New Version of Container Image

We have uploaded previous container image `idn-belajar-node:1.0` to **hello-api** container service. Now it's time to upload the new version with tag `2.0`.

```sh
aws lightsail push-container-image \
--region "ap-southeast-1" \
--service-name "hello-api" \
--label "idn-belajar-node" \
--image "idn-belajar-node:2.0"
```

```
...[CUT]...
5dd85641fdcb: Layer already exists 
c1065d45b872: Layer already exists 
Digest: sha256:84be0f3b648170b62551abbadbafda1234c1e6362470ecf0b94b3f767d067976
Image "idn-belajar-node:2.0" registered.
Refer to this image as ":hello-api.idn-belajar-node.4" in deployments.
```

In my case the image was stored as `:hello-api.idn-belajar-node.4`. The upload version `4` could be different from yours.

To make sure that container image has been uploaded successfully check **_Images** page. The new image should be there.

[![Lightsail Container New Image](https://raw.githubusercontent.com/rioastamal-examples/assets/main/workshop-amazon-lightsail-containers/lab-deploy-nodejs-app/images/lightsail-hello-api-new-image.png)](https://raw.githubusercontent.com/rioastamal-examples/assets/main/workshop-amazon-lightsail-containers/lab-deploy-nodejs-app/images/lightsail-hello-api-new-image.png)

> Figure 10. Container image version 2.0

[^back to top](#top)

<!-- end step-11 -->

<!-- begin step-12 -->

## <a name="step-12"></a>Step 12 - Deploy Latest Version of the API

Once the container image `idn-belajar-node:2.0` uploaded to Amazon Lightsail Containers, we can deploy the latest version of the API using that image.

1. Go to Dashboard of the container service **hello-api** and make sure you're at the _Deployments_ page.
2. Click the **Modify your deployment** to open the configuration section to create new deployment.
3. The only configuration that need to change is container image which being used. Klik the **Choose stored image** then pick the latest one.
4. No need to change the rest of the configuration.
5. Wait few minutes for the status to change back to **Running**.

[![Lightsail Update Deployment](https://raw.githubusercontent.com/rioastamal-examples/assets/main/workshop-amazon-lightsail-containers/lab-deploy-nodejs-app/images/lightsail-hello-api-modify-deployment.png)](https://raw.githubusercontent.com/rioastamal-examples/assets/main/workshop-amazon-lightsail-containers/lab-deploy-nodejs-app/images/lightsail-hello-api-modify-deployment.png)

> Figure 11. Deployment of new version

After the status back to **Running** it's time to test it out using HTTP request. Use cURL or your browser to test the new deployment.

```sh
curl -s https://YOUR_OWN_CONTAINER_SERVICE_PUBLIC_DOMAIN/
```

```json
{
  "hello": "Indonesia Belajar!",
  "network": {
    "eth0": [
      {
        "address": "169.254.172.2",
        "netmask": "255.255.252.0",
        "family": "IPv4",
        "mac": "0a:58:a9:fe:ac:02",
        "internal": false,
        "cidr": "169.254.172.2/22"
      },
      {
        "address": "fe80::c016:75ff:fe78:8827",
        "netmask": "ffff:ffff:ffff:ffff::",
        "family": "IPv6",
        "mac": "0a:58:a9:fe:ac:02",
        "internal": false,
        "cidr": "fe80::c016:75ff:fe78:8827/64",
        "scopeid": 3
      }
    ],
    "eth1": [
      {
        "address": "172.26.0.67",
        "netmask": "255.255.240.0",
        "family": "IPv4",
        "mac": "02:f4:1a:f9:96:ac",
        "internal": false,
        "cidr": "172.26.0.67/20"
      },
      {
        "address": "2406:da18:f4f:e00:971b:f340:5454:794c",
        "netmask": "ffff:ffff:ffff:ffff::",
        "family": "IPv6",
        "mac": "02:f4:1a:f9:96:ac",
        "internal": false,
        "cidr": "2406:da18:f4f:e00:971b:f340:5454:794c/64",
        "scopeid": 0
      },
      {
        "address": "fe80::f4:1aff:fef9:96ac",
        "netmask": "ffff:ffff:ffff:ffff::",
        "family": "IPv6",
        "mac": "02:f4:1a:f9:96:ac",
        "internal": false,
        "cidr": "fe80::f4:1aff:fef9:96ac/64",
        "scopeid": 4
      }
    ]
  }
}
```

Cool! The new version of the API deployed. Now it contains `network` attribute as part of the output which not exists previously.

[^back to top](#top)

<!-- end step-12 -->

<!-- begin step-13 -->

### <a name="step-13"></a>Step 13 - Increasing Number of Nodes

When you when to increase the performance of your app to respond traffic, one of the solution is to do vertical scaling which means increasing your server's specs. The other way around is to do horizontal scaling which increasing number of nodes, which exactly what we are going to do.

This time we will increase number of nodes from 1 to 3.

1. Go to **hello-api** dashboard
2. Click the **Capacity**
3. Then click the **Change capacity** a window dialog will popping up, click "Yes, continue".

[![Lightsail Capacity](https://raw.githubusercontent.com/rioastamal-examples/assets/main/workshop-amazon-lightsail-containers/lab-deploy-nodejs-app/images/lightsail-hello-api-capacity-menu.png)](https://raw.githubusercontent.com/rioastamal-examples/assets/main/workshop-amazon-lightsail-containers/lab-deploy-nodejs-app/images/lightsail-hello-api-capacity-menu.png)

> Figure 12. Changing container service capacity

4. We are still going to use Nano type for the capacity and for the scale move it to **3**.

[![Lightsail Add Node](https://raw.githubusercontent.com/rioastamal-examples/assets/main/workshop-amazon-lightsail-containers/lab-deploy-nodejs-app/images/lightsail-hello-api-capacity-add-node.png)](https://raw.githubusercontent.com/rioastamal-examples/assets/main/workshop-amazon-lightsail-containers/lab-deploy-nodejs-app/images/lightsail-hello-api-capacity-add-node.png)

> Figure 13. Adding more nodes for container service

5. This process will several minutes to complete, click **I understand** to close the dialog.
6. Wait for the status of the container service back to **Running**.

[![Lightsail New Capacity](https://raw.githubusercontent.com/rioastamal-examples/assets/main/workshop-amazon-lightsail-containers/lab-deploy-nodejs-app/images/lightsail-hello-api-new-capacity-applied.png)](https://raw.githubusercontent.com/rioastamal-examples/assets/main/workshop-amazon-lightsail-containers/lab-deploy-nodejs-app/images/lightsail-hello-api-new-capacity-applied.png)

> Figure 14. Number of nodes has been increased

Amazon Lightsail automatically will distributes the traffic to the 3 nodes running on **hello-api** container service. You don't need to configure anything including the load balancer.

Now test the response from the API and see the value of the local IP that is returned from attribute `network.eth1`. The IP address of each request should have different results depending on which node is serving. Make a request to the public endpoint of the container several times and see the results.

```sh
curl -s https://YOUR_OWN_CONTAINER_SERVICE_PUBLIC_DOMAIN/ | jq '.network.eth1[0]'
```

```json
{
  "address": "172.26.16.104",
  "netmask": "255.255.240.0",
  "family": "IPv4",
  "mac": "06:3d:94:bd:f3:82",
  "internal": false,
  "cidr": "172.26.16.104/20"
}
```

```sh
curl -s https://YOUR_OWN_CONTAINER_SERVICE_PUBLIC_DOMAIN/ | jq '.network.eth1[0]'
```

```json
{
  "address": "172.26.40.212",
  "netmask": "255.255.240.0",
  "family": "IPv4",
  "mac": "0a:2f:30:f6:15:ca",
  "internal": false,
  "cidr": "172.26.40.212/20"
}
```

```sh
curl -s https://YOUR_OWN_CONTAINER_SERVICE_PUBLIC_DOMAIN/ | jq '.network.eth1[0]'
```

```json
{
  "address": "172.26.13.18",
  "netmask": "255.255.240.0",
  "family": "IPv4",
  "mac": "02:5d:98:ca:df:e6",
  "internal": false,
  "cidr": "172.26.13.18/20"
}
```

As can be seen that the IP addresses returned are different indicating that the request are served by different node. Do it several times if you still got the same result.

Before proceeding to the next step, first set the number of nodes back from **3** to **1**. Do you still remember how to do it right?

[^back to top](#top)

<!-- end step-13 -->

<!-- begin step-14 -->

### <a name="step-14"></a>Step 14 - Rollback Container to Previous Deployment

There's a situation where your new deployment is not working and causes errors. One of the advantages of using a container based-deployment is we can rollback easily.

To rollback our API deployment to previous version it's easy.

1. First make sure you are on the dashboard page of the **hello-api** container service.
2. Go to the _Deployments_ page.
3. Scroll down to Deployment versions . There we can see that we have done two deployments. The last deployment is for image `indonesia-belajar:2.0`.
4. Click the three dots Version 1 then click **Modify and redeploy**.


[![Lightsail Rollback Deployment](https://raw.githubusercontent.com/rioastamal-examples/assets/main/workshop-amazon-lightsail-containers/lab-deploy-nodejs-app/images/lightsail-hello-api-rollback-deployment.png)](https://raw.githubusercontent.com/rioastamal-examples/assets/main/workshop-amazon-lightsail-containers/lab-deploy-nodejs-app/images/lightsail-hello-api-rollback-deployment.png)

> Figure 15. Rollback deployment to previous version

5. A confirmation dialog will appear, click **Yes button, continue**.
6. The deployment process has not been carried out, it only autofill the Image configuration value that changed the image previous version, namely `:hello-api.indonesia-belajar.12`. The uploaded version number `.12` may be different in your side.
7. Click **Save and deploy** button to start the rollback deployment process from the previous image.
8. Wait until the status of the container service returns to Running.

When rollback is complete and the status returns to _Running_, try to make a request to the API to see if the response matches the previous version.

```sh
curl -s https://YOUR_OWN_CONTAINER_SERVICE_PUBLIC_DOMAIN/
```

```json
{ 
  "hello": "Indonesia Belajar!"
}
```

Now API does not return the local IP of the server as it should be in version `indonesia-belajar:2.0`, instead it return response from previous deployment using `indonesia-belajar:1.0` image.

So doing rollback is as simple as changing the version of the container image to run.

Keep in mind that rollback is also a deployment process so it will increase deployment version as seen in the image below, our rollback results in a version 3 deployment.

[![Lightsail Deployment Versions](https://raw.githubusercontent.com/rioastamal-examples/assets/main/workshop-amazon-lightsail-containers/lab-deploy-nodejs-app/images/lightsail-hello-api-deployment-versions.png)](https://raw.githubusercontent.com/rioastamal-examples/assets/main/workshop-amazon-lightsail-containers/lab-deploy-nodejs-app/images/lightsail-hello-api-deployment-versions.png)

> Gambar 16. Rollback juga menghasilkan versi deployment baru

[^back to top](#top)

<!-- end step-14 -->

<!-- begin step-15 -->

### <a name="step-15"></a>Step 15 - Removing Amazon Lightsail Container Service

If the application is no longer needed then there is no reason to run it. Disabling the container service does not stop the incurring charge.

To stop incurring charge you need to remove the container service.

1. Back to Amazon Lightsail dashboard
2. Click **Containers** menu
3. There should be a **hello-api** container service, click the 3 dots and click the **Delete** option.

[![Lightsail Delete Container Service](https://raw.githubusercontent.com/rioastamal-examples/assets/main/workshop-amazon-lightsail-containers/lab-deploy-nodejs-app/images/lightsail-hello-api-delete.png)](https://raw.githubusercontent.com/rioastamal-examples/assets/main/workshop-amazon-lightsail-containers/lab-deploy-nodejs-app/images/lightsail-hello-api-delete.png)

> Figure 17. Removing a container service

4. Click **Yes, delete** to delete container service.
6. **hello-api** container should be deleted and gone from the list.

It's worth noting that container images on Amazon Lightsail are tied to a container service. So removing the container service will also delete all container images that have been uploaded to the container service. In this case, the two container images that we uploaded earlier are `indonesia-belajar:1.0` and `indonesia-belajar:2.0` were deleted.

Now let's try to access the container's endpoint URL to see the response.

```sh
curl -s https://YOUR_OWN_CONTAINER_SERVICE_PUBLIC_DOMAIN/
```

```html
<!DOCTYPE html>
<html>
<head><title>404 No Such Service</title></head>
<body bgcolor="white">
<center><h1>404 No Such Service</h1></center>
</body>
</html>
```

The endpoint URL should return 404 HTTP error, it means no container service is running.

[^back to top](#top)

---

Congrats! You have completed a Node.js deployment workshop on Amazon Lightsail Containers.

Don't forget to ⭐ this repo. See you at next workshop.

<!-- end step-15 -->