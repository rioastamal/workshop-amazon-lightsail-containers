<a name="top"></a>

<!-- begin step-0 -->

Language: [Bahasa Indonesia](https://github.com/rioastamal/workshop-amazon-lightsail-containers/tree/main/lab-deploy-python-flask) | English

DRAFT - Need a review for any spelling or grammatical errors.

## Workshop Deploying Python Flask on Amazon Lightsail Containers

In this workshop, participants will be guided how to deploy an API on Amazon Lightsail Containers. A simple API built using Python and Flask microframework will be used as an example in this workshop.

Participants can follow the workshop guide through steps that have been provided sequentially starting from step 1 to step 15.

- [Step 1 - Requirements](#step-1)
- [Step 2 - Install Lightsail Control Plugin](#step-2)
- [Step 3 - Create Directory for the Project](#step-3)
- [Step 4 - Create Python Flask API](#step-4)
- [Step 5 - Create Container Image](#step-5)
- [Step 6 - Create Container Service on Amazon Lightsail](#step-6)
- [Step 7 - Push Container Image to Amazon Lightsail](#step-7)
- [Step 8 - Deploy Container Service](#step-8)
- [Step 9 - Create New Version of the API](#step-9)
- [Step 10 - Update Container Image](#step-10)
- [Step 11 - Push New Version of Container Image](#step-11)
- [Step 12 - Deploy Latest Version of the API](#step-12)
- [Step 13 - Increasing Number of Nodes](#step-13)
- [Step 14 - Rollback Container to Previous Deployment](#step-14)
- [Step 15 - Remove Amazon Lightsail Container Service](#step-15)

If you prefer all steps in one page then please open [README.single-page.md](README.single-page.md).

<!-- end step-0 -->

<!-- begin step-1 -->

### <a name="step-1"></a>Step 1 - Requirements

Before starting the workshop, make sure you have an active AWS account and have installed requirements listed below.

- An active AWS account
- Docker
- AWS CLI v2 and its configuration
- Python v3.8 dan pip via Docker

To install Python 3.8 using Docker use following command.

```sh
docker pull public.ecr.aws/docker/library/python:3.8-slim
```

```
3.8-slim: Pulling from docker/library/python
42c077c10790: Pull complete 
f63e77b7563a: Pull complete 
5215613c2da8: Pull complete 
9ca2d4523a14: Pull complete 
e97cee5830c4: Pull complete 
Digest: sha256:0e07cc072353e6b10de910d8acffa020a42467112ae6610aa90d6a3c56a74911
Status: Downloaded newer image for public.ecr.aws/docker/library/python:3.8-slim
public.ecr.aws/docker/library/python:3.8-slim
```

The above command will download a slim version of the Python 3.8 container image from the Amazon ECR public registry. To make sure the container image has been downloaded run command below.

```sh
docker images
```

```
REPOSITORY                             TAG          IMAGE ID       CREATED         SIZE
public.ecr.aws/docker/library/python   3.8-slim     61c56c60bb49   11 days ago     124MB
```

Next is try to run Python 3.8 interpreter using Docker.

```sh
docker run --rm \
public.ecr.aws/docker/library/python:3.8-slim \
python --version
```

```
Python 3.8.13
```

If you see output as above then congratulations you can now use Python 3.8 on your computer.

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

Then create new directory named `python-app`.

```sh
mkdir python-app
```

Go to that directory as we will put all necessary files there.

```sh
cd python-app
pwd
```

```
/home/ec2-user/python-app
```

[^back to top](#top)

<!-- end step-3 -->

<!-- begin step-4 -->

### <a name="step-4"></a>Step 4 - Create Python Flask API

In this step we will create a simple API built using the popular Python web framework, Flask. The API will return cow characters and text in ASCII format. Similar to those found on utilities on Unix/Linux cowsay.

First create a file `requirements.txt` to list all packages used on this app using pip which is the package manager for Python.

```sh
echo '
cowsay~=4.0
Flask~=2.1.2
gunicorn~=20.1.0
' > requirements.txt
```

Since we are running Python via Docker we will mount local directory `python-app` to the Docker container. We do this because we will place the packages on the host computer, not in a container so that when the container is turned off the packages will not be lost.

We will mount `/home/ec2-user/python-app` to `/app` inside the container. All the packages installed by pip will be placed to `/app/libs` .

```sh
docker run -v $(pwd):/app --rm -it \
public.ecr.aws/docker/library/python:3.8-slim \
pip install -r /app/requirements.txt --target=/app/libs
```

If you use `ls` command, there should be a new directory `libs` whose owner is root.

```sh
ls -l libs/
```

```
total 112
drwxr-xr-x 2 root root 4096 Jun 15 09:10 bin
...
drwxr-xr-x 3 root root 4096 Jun 15 09:10 cowsay
drwxr-xr-x 4 root root 4096 Jun 15 09:10 flask
drwxr-xr-x 2 root root 4096 Jun 15 09:10 Flask-2.1.2.dist-info
drwxr-xr-x 7 root root 4096 Jun 15 09:10 gunicorn
drwxr-xr-x 2 root root 4096 Jun 15 09:10 gunicorn-20.1.0.dist-info
....
```

Next create a new directory `src/` to place API source code.

```sh
mkdir src/
```

Create new file `src/index.py`, this is the main file for the API.

```sh
touch src/index.py
```

Copy and paste code below to `src/index.py`.

```py
from flask import Flask
from flask import request
import cowsay

app = Flask(__name__)

@app.route('/')
def main():
    text = request.args.get('text')
    if text == None:
        text = '''\
I do not understand what you're saying!
.
Usage:
/?text=TEXT
.
Where:
 TEXT is text you want to say.\
'''

    the_text = cowsay.get_output_string('cow', text)
    return the_text, 200, { 'content-type': 'text/plain' }
```

Untuk menjalankan API server kita akan menggunakan WSGI server yaitu gunicorn. Buat sebuah shell script untuk menjalankan gunicorn di dalam container.

To run API server we will use a WSGI server, gunicorn. Create a shell script to run gunicorn in container.

```sh
touch run-server.sh
```

Copy this shell script code to file `run-server.sh`.

```sh
#!/bin/bash
# This script intended to be run inside a container

export PYTHONPATH=/app/libs

# Run gunicorn WSGI server
[ -z "$APP_BIND" ] && APP_BIND='0.0.0.0:8080'
[ -z "$APP_WORKER" ] && APP_WORKER=4
$PYTHONPATH/bin/gunicorn \
 -w $APP_WORKER \
 -b $APP_BIND \
 --chdir /app/src 'index:app'
```

Eksekusi gunicorn WSGI server menggunakan Docker.

Run gunicurn using Docker.

```sh
docker run -v $(pwd):/app --rm -it -p 8080:8080 \
public.ecr.aws/docker/library/python:3.8-slim \
bash /app/run-server.sh
```

```
[2022-06-15 09:28:21 +0000] [8] [INFO] Starting gunicorn 20.1.0
[2022-06-15 09:28:21 +0000] [8] [INFO] Listening at: http://0.0.0.0:8080 (8)
[2022-06-15 09:28:21 +0000] [8] [INFO] Using worker: sync
[2022-06-15 09:28:21 +0000] [10] [INFO] Booting worker with pid: 10
[2022-06-15 09:28:22 +0000] [11] [INFO] Booting worker with pid: 11
[2022-06-15 09:28:22 +0000] [12] [INFO] Booting worker with pid: 12
[2022-06-15 09:28:22 +0000] [13] [INFO] Booting worker with pid: 13
```

You can test by issuing HTTP request to localhost port `8080` and path `/`.

```sh
curl -s -D /dev/stderr 'http://localhost:8080/'
```

```
HTTP/1.1 200 OK
Server: gunicorn
Date: Thu, 16 Jun 2022 04:15:16 GMT
Connection: close
content-type: text/plain
Content-Length: 833

  _______________________________________
 /                                       \
| I do not understand what you're saying! |
| .                                       |
| Usage:                                  |
| /?text=TEXT                             |
| .                                       |
| Where:                                  |
| TEXT is text you want to say.           |
 \                                       /
  =======================================
                                       \
                                        \
                                          ^__^
                                          (oo)\_______
                                          (__)\       )\/\
                                              ||----w |
                                              ||     ||
```

Let's do another request by adding parameter to the query string. Send a `text` paramter with value `Hello%20Indonesia%20Belajar`. String `%20` represent space.

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

Cool! Our API is run as expected. It's time to package this API into a container image. Press `CTRL+C` to stop the container.

[^back to top](#top)

<!-- end step-4 -->

<!-- begin step-5 -->

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

[^back to top](#top)

<!-- end step-5 -->

<!-- begin step-6 -->

### <a name="step-6"></a>Step 6 - Create Container Service on Amazon Lightsail

Container service is compute resource on which the container is run. It provides many choices of RAM and vCPU capacities that can be selected according to your application needs. In addition you can also specify the number of nodes on which container is running.

1. Go to AWS Management Console then go to Amazon Lightsail page. On the Amazon Lightsail Dashboard click the **Containers** menu.

[![Lightsail Containers Menu](https://raw.githubusercontent.com/rioastamal-examples/assets/main/workshop-amazon-lightsail-containers/lab-deploy-nodejs-app/images/lightsail-menu-containers.png)](https://raw.githubusercontent.com/rioastamal-examples/assets/main/workshop-amazon-lightsail-containers/lab-deploy-nodejs-app/images/lightsail-menu-containers.png)

> Figure 1. Containers menu on Amazon Lightsail

2. On the Containers page click the **Create container service** button to start creating a Container service.

[![Lightsail Create Instance Button](https://raw.githubusercontent.com/rioastamal-examples/assets/main/workshop-amazon-lightsail-containers/lab-deploy-nodejs-app/images/lightsail-button-create-instance.png)](https://raw.githubusercontent.com/rioastamal-examples/assets/main/workshop-amazon-lightsail-containers/lab-deploy-nodejs-app/images/lightsail-button-create-instance.png)

> Figure 2. Containers page contain a list of containers

3. Then we will be faced with several choices. In the _Container service location_ option, select the a region, in this case I choose **Singapore**. Click the **Change AWS Region** link to do so. In the container capacity option, select **Nano** which consist of 512MB RAM and 0.25 vCPU. For the scale option specify **x1**. It means that we will only launch 1 node to run the containers.

[![Lightsail Choose Container Capacity](https://raw.githubusercontent.com/rioastamal-examples/assets/main/workshop-amazon-lightsail-containers/lab-deploy-nodejs-app/images/lightsail-choose-container-capacity.png)](https://raw.githubusercontent.com/rioastamal-examples/assets/main/workshop-amazon-lightsail-containers/lab-deploy-nodejs-app/images/lightsail-choose-container-capacity.png)

> Figure 3. Selecting region and capacity of the container

4. Next is to determine the name of the service. In the _Identify your service_ section, enter **hello-api**. At the _Summary_ section as we can see we will launch a container with a **Nano** capacity (512MB RAM, 0.25 vCPU)  **x1**. Total cost for this container service is **$7** per month. All is set now click  **Create container service** button.

[![Lightsail Choose Service Name](https://raw.githubusercontent.com/rioastamal-examples/assets/main/workshop-amazon-lightsail-containers/lab-deploy-nodejs-app/images/lightsail-choose-service-name.png)](https://raw.githubusercontent.com/rioastamal-examples/assets/main/workshop-amazon-lightsail-containers/lab-deploy-nodejs-app/images/lightsail-choose-service-name.png)

> Figure 4. Entering the container service name

5. Container service creation will take few minutes, so be patient. Once done you will be taken to the dashboard of the **hello-api** container service page. You will get a domain to used to access your container. The domain is located at the _Public domain_ section. Wait until the status becomes **Ready** then click the domain to open **hello-api** container service. It should be still 404 error because no container image has been deployed to the container service.

[![Lightsail hello-api Dashboard](https://raw.githubusercontent.com/rioastamal-examples/assets/main/workshop-amazon-lightsail-containers/lab-deploy-nodejs-app/images/lightsail-hello-api-dashboard.png)](https://raw.githubusercontent.com/rioastamal-examples/assets/main/workshop-amazon-lightsail-containers/lab-deploy-nodejs-app/images/lightsail-hello-api-dashboard.png)

> Figure 5. Dashboard of the hello-api container service

[![Lightsail hello-api 404](https://raw.githubusercontent.com/rioastamal-examples/assets/main/workshop-amazon-lightsail-containers/lab-deploy-nodejs-app/images/lightsail-404-hello-api.png)](https://raw.githubusercontent.com/rioastamal-examples/assets/main/workshop-amazon-lightsail-containers/lab-deploy-nodejs-app/images/lightsail-404-hello-api.png)

> Figure 6. hello-api service returns 404 because no container image has been deployed

[^back to top](#top)

<!-- end step-6 -->

<!-- begin step-7 -->

### <a name="step-7"></a>Step 7 - Push Container Image to Amazon Lightsail

Each container image pushed to Amazon Lightsail is bound to a container service. That's why we created the **hello-api** container service first before pushing the container image.

In this step we will push `indonesia-belajar:1.0` the previously created container image to **hello-api** container service. Run command below.

```sh
aws lightsail push-container-image \
--region "ap-southeast-1" \
--service-name "hello-api" \
--label "indonesia-belajar" \
--image "indonesia-belajar:1.0"
```

```
...[CUT]...
ad6562704f37: Pushed 
Digest: sha256:476291c73ec25649423be818454f51ea2185f436f00edb81fbce1da0a6ec2f5e
Image "indonesia-belajar:1.0" registered.
Refer to this image as ":hello-api.indonesia-belajar.12" in deployments.
```

You will get a message similar to the one above once the push is successfull. The container image will be saved with the name `:<container-service>:<label>.<upload-number>` in the example above the name is `:hello-api.indonesia-belajar.12`. Your `upload-number` could be different.

Now make sure the container image has been uploaded, go to the **Images** page.

[![Lightsail hello-api Image](https://raw.githubusercontent.com/rioastamal-examples/assets/main/workshop-amazon-lightsail-containers/lab-general-app/images/lightsail-hello-api-image.png)](https://raw.githubusercontent.com/rioastamal-examples/assets/main/workshop-amazon-lightsail-containers/lab-general-app/images/lightsail-hello-api-image.png)

> Figure 7. List of uploaded container images

As you can see on the _Images_ page there is an container image `:hello-api.indonesia-belajar.12` that we just uploaded from previous step. We will use this image to do the deployment.

[^back to top](#top)

<!-- end step-7 -->

<!-- begin step-8 -->

### <a name="step-8"></a>Step 8 - Deploy Container Service

This step will create new deployment for **hello-api** container service using container image `:hello-api.indonesia-belajar.12`.

1. On the **hello-api** dashboard click the **Deployments** menu and then click the **Create your first deployment** link.

[![Lightsail Create Deployment](https://raw.githubusercontent.com/rioastamal-examples/assets/main/workshop-amazon-lightsail-containers/lab-deploy-nodejs-app/images/lightsail-hello-api-deployments-menu.png)](https://raw.githubusercontent.com/rioastamal-examples/assets/main/workshop-amazon-lightsail-containers/lab-deploy-nodejs-app/images/lightsail-hello-api-deployments-menu.png)

> Figure 8. Create your first deployment link

2. There are several things need to be configured. First enter **hello-idn-belajar** for the _Container name_. 
3. For the _Image_ option, click **Choose stored image** then choose our container image that has been uploaded.
4. API uses two optional environment variables: `APP_WORKER` and `APP_BIND`. `APP_WORKER` used to determine number of gunicorn worker (default is 4) and `APP_BIND` used to determine the bind address and port number (default is `0.0.0.0:8080`).
5. For **Open Ports** use the same port as `APP_BIND` environment variable in this case `8080` and HTTP for the protocol.
6. For **PUBLIC ENDPOINT** use container **idn-hello-belajar**. All traffic coming from public endpoint will be forwarded to this container.
7. Click **Save and deploy** to begin deployment.

[![Lightsail Configure Deployment](https://raw.githubusercontent.com/rioastamal-examples/assets/main/workshop-amazon-lightsail-containers/lab-general-app/images/lightsail-hello-api-configure-deployment.png)](https://raw.githubusercontent.com/rioastamal-examples/assets/main/workshop-amazon-lightsail-containers/lab-general-app/images/lightsail-hello-api-configure-deployment.png)

> Figure 9. Deployment configuration for containers

When the status is **Running** we can try to access the API by opening the URL shown on the public domain section. The public endpoint use HTTPS protocol. We will use curl to do the test. Run command below and replace with your own public domain.

```sh
curl -s 'https://YOUR_OWN_CONTAINER_SERVICE_PUBLIC_DOMAIN/?text=Hello%20Indonesia%20Belajar'
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

Congrats! You gave successfully deployed a Python Flask API on Amazon Lightsail Container service. Pretty easy isn't it?

[^back to top](#top)

<!-- end step-8 -->

<!-- begin step-9 -->

### <a name="step-9"></a>Step 9 - Create New Version of the API

Every application will almost certainly having an update whether for bug fixes or adding new features. In this step we will try to demonstrate how to update an application on Amazon Lightsail Container service.

In this example we will update the API to support character other than cow. List of new characters: 'beavis', 'cheese', 'daemon', 'cow', 'dragon', 'ghostbusters', 'kitty', 'meow', 'milk', 'pig', 'stegosaurus', 'stimpy', 'trex', 'turkey', 'turtle', 'tux'.

Make sure you are in directory `python-app`. Then change the contents of the file `src/index.pyto` as shown below.

```py
from flask import Flask
from flask import request
import cowsay
import socket

app = Flask(__name__)

@app.route('/')
def main():
    try:
        the_character = request.args.get('char')
        index_char = list(cowsay.char_names).index(the_character)
    except:
        the_character = 'cow'

    local_ip = socket.gethostbyname(socket.gethostname())

    text = request.args.get('text')
    if text == None:
        text = '''\
I do not understand what you're saying!
.
Usage:
/?text=TEXT&char=CHARACTER
.
Where:
 TEXT      Text you want to say.
 CHARACTER The character: 'cow', 'tux', etc.
          See https://pypi.org/project/cowsay/\
'''

    the_text = cowsay.get_output_string(the_character, text)
    the_text = "%s\nMy Local IP: %s" % (the_text, local_ip)
    return the_text, 200, { 'content-type': 'text/plain' }
```

We add new parameter `char` via query string. This parameter will determine what character to shown. In addition we also add new section to show our local IP address.

Run the API using Docker.

```sh
docker run -v $(pwd):/app --rm -it -p 8080:8080 \
public.ecr.aws/docker/library/python:3.8-slim \
bash /app/run-server.sh
```

Kemudian lakukan HTTP request ke path `/` dengan mengirimkan parameter `text` dan `char` di query string.

Try to call the API to show tux character. We need to pass query string `char=tux`.

```sh
curl -s 'http://localhost:8080/?text=Hello%20Indonesia%20Belajar&char=tux'
```

```
  _______________________
| Hello Indonesia Belajar |
  =======================
                            \
                             \
                              \
                               .--.
                              |o_o |
                              |:_/ |
                             //   \ \
                            (|     | )
                           /'\_   _/`\
                           \___)=(___/
My Local IP: 172.17.0.2
```

Now our API able to support many characters and display local IP of the server.

[^back to top](#top)

<!-- end step-9 -->

<!-- begin step-10 -->

### <a name="step-10"></a>Step 10 - Update Container Image

Our new API is ready, next is to update the container image `indonesia-belajar`. We will release the new API with tag `2.0`. To do this follow step below.

```sh
docker build --rm -t indonesia-belajar:2.0 .
```

```
...[CUT]...
Step 7/7 : ENTRYPOINT ["bash", "/app/run-server.sh"]
 ---> Running in 0f0a8b970ba4
Removing intermediate container 0f0a8b970ba4
 ---> b3846915d8d0
Successfully built b3846915d8d0
Successfully tagged indonesia-belajar:2.0
```

Let's see if our new container image is already on the list.

```sh
docker images indonesia-belajar
```

```
REPOSITORY          TAG       IMAGE ID       CREATED         SIZE
indonesia-belajar   2.0       b3846915d8d0   6 seconds ago   144MB
indonesia-belajar   1.0       32dc2a5baec9   4 hours ago     144MB
```

Let's run our `indonesia-belajar:2.0` to make sure it is working as expected.

```sh
docker run --rm --name idn_belajar_2_0 -p 8080:8080 -d indonesia-belajar:2.0
```

```
d8df1a6d0dbd70de4cd36ff21e5b6a766a7bb0c21d28819d37fdff612aefe23c
```

Do a HTTP request to the API to URL `http://localhost:8080/` to check the API response.

```sh
curl -s 'http://localhost:8080/?text=Hello%20Indonesia%20Belajar&char=milk'
```

```
  _______________________
| Hello Indonesia Belajar |
  =======================
                       \
                        \
                         \
                          \
                              ____________
                              |__________|
                             /           /\
                            /           /  \
                           /___________/___/|
                           |          |     |
                           |  ==\ /== |     |
                           |   O   O  | \ \ |
                           |     <    |  \ \|
                          /|          |   \ \
                         / |  \_____/ |   / /
                        / /|          |  / /|
                       /||\|          | /||\/
                           -------------|
                               | |    | |
                              <__/    \__>
My Local IP: 172.17.0.2
```

The API return `milk` character as expected.

[^back to top](#top)

<!-- end step-10 -->

<!-- begin step-11 -->

### <a name="step-11"></a>Step 11 - Push New Version of Container Image

We have uploaded previous container image `indonesia-belajar:1.0` to **hello-api** container service. Now it's time to upload the new version with tag `2.0`.

```sh
aws lightsail push-container-image \
--region "ap-southeast-1" \
--service-name "hello-api" \
--label "indonesia-belajar" \
--image "indonesia-belajar:2.0"
```

```
...[CUT]...
ad6562704f37: Layer already exists 
Digest: sha256:4233e2c6f9650a3a860f113543f6bc8c0d294edfb976574b21ca33a528a635e7
Image "indonesia-belajar:2.0" registered.
Refer to this image as ":hello-api.indonesia-belajar.13" in deployments.
```

In my case the image was stored as `:hello-api.indonesia-belajar.13`. The upload version `13` could be different from yours.

To make sure that container image has been uploaded successfully check **_Images** page. The new image should be there.

[![Lightsail Container New Image](https://raw.githubusercontent.com/rioastamal-examples/assets/main/workshop-amazon-lightsail-containers/lab-general-app/images/lightsail-hello-api-new-image.png)](https://raw.githubusercontent.com/rioastamal-examples/assets/main/workshop-amazon-lightsail-containers/lab-general-app/images/lightsail-hello-api-new-image.png)

> Figure 10. Container image version 2.0

[^back to top](#top)

<!-- end step-11 -->

<!-- begin step-12 -->

## <a name="step-12"></a>Step 12 - Deploy Latest Version of the API

Once the container image `-belajar:2.0` uploaded to Amazon Lightsail Containers, we can deploy the latest version of the API using that image.

1. Go to Dashboard of the container service **hello-api** and make sure you're at the _Deployments_ page.
2. Click the **Modify your deployment** to open the configuration section to create new deployment.
3. The only configuration that need to change is container image which being used. Klik the **Choose stored image** then pick the latest one.
4. No need to change the rest of the configuration.
5. Wait few minutes for the status to change back to **Running**.

[![Lightsail Update Deployment](https://raw.githubusercontent.com/rioastamal-examples/assets/main/workshop-amazon-lightsail-containers/lab-general-app/images/lightsail-hello-api-modify-deployment.png)](https://raw.githubusercontent.com/rioastamal-examples/assets/main/workshop-amazon-lightsail-containers/lab-general-app/images/lightsail-hello-api-modify-deployment.png)

> Figure 11. Deployment of new version

After the status back to **Running** it's time to test it out using HTTP request. Use cURL or your browser to test the new deployment.

```sh
curl -s 'https://YOUR_OWN_CONTAINER_SERVICE_PUBLIC_DOMAIN/?text=Hello%20Indonesia%20Belajar&char=beavis'
```

```
  _______________________
| Hello Indonesia Belajar |
  =======================
                            \
                             \
                              \
                                    _------~~-,
                                 ,'            ,
                                 /               \\
                                /                :
                               |                  '
                               |                  |
                               |                  |
                                |   _--           |
                                _| =-.     .-.   ||
                                o|/o/       _.   |
                                /  ~          \\ |
                              (____\@)  ___~    |
                                 |_===~~~.`    |
                              _______.--~     |
                              \\________       |
                                       \\      |
                                     __/-___-- -__
                                    /            _ \\
                                    
My Local IP: 172.17.0.2
```

Cool! The new version API has been successfully deployed. Now it contains new character and local IP address of the server.

[^back to top](#top)

<!-- end step-12 -->

<!-- begin step-13 -->

### <a name="step-13"></a>Step 13 - Increasing Number of Nodes

When you when to increase the performance of your app to respond traffic, one of the solution is to do vertical scaling which means increasing your server's specs. The other way around is to do horizontal scaling which increasing number of nodes, which exactly what we are going to do.

This time we will increase number of nodes from 1 to 3.

1. Go to **hello-api** dashboard
2. Click the **Capacity**
3. Then click the **Change capacity** a window dialog will popping up, click **Yes, continue**.

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

Now test the response from the API and see the value of the local IP that is returned. The IP address of each request should have different results depending on which node is serving. Make a request to the public endpoint of the container several times and see the results.

```sh
curl -s 'https://YOUR_OWN_CONTAINER_SERVICE_PUBLIC_DOMAIN/?text=Hello%20Indonesia%20Belajar'
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
My Local IP: 172.26.31.136
```

```sh
curl -s 'https://YOUR_OWN_CONTAINER_SERVICE_PUBLIC_DOMAIN/?text=Hello%20Indonesia%20Belajar'
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
My Local IP: 172.26.5.248
```

```sh
curl -s 'https://YOUR_OWN_CONTAINER_SERVICE_PUBLIC_DOMAIN/?text=Hello%20Indonesia%20Belajar'
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
My Local IP: 172.26.40.244
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
6. The deployment process has not been carried out, it only autofill the Image configuration value that changed the image previous version, namely `:hello-api.indonesia-belajar.12`. The uploaded version number `.12` may be different on your side.
7. Click **Save and deploy** button to start the rollback deployment process from the previous image.
8. Wait until the status of the container service returns to Running.

When rollback is complete and the status returns to _Running_, try to make a request to the API to see if the response matches the previous version.

```sh
curl -s 'https://YOUR_OWN_CONTAINER_SERVICE_PUBLIC_DOMAIN/?text=Hello%20Indonesia%20Belajar'
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

Now API does not return the local IP of the server as it should be in version `indonesia-belajar:2.0`, instead it return response from previous deployment using `indonesia-belajar:1.0` image.

So doing rollback is as simple as changing the version of the container image to run.

Keep in mind that rollback is also a deployment process so it will increase deployment version as seen in the image below, our rollback results in a version 3 deployment.

[![Lightsail Deployment Versions](https://raw.githubusercontent.com/rioastamal-examples/assets/main/workshop-amazon-lightsail-containers/lab-deploy-nodejs-app/images/lightsail-hello-api-deployment-versions.png)](https://raw.githubusercontent.com/rioastamal-examples/assets/main/workshop-amazon-lightsail-containers/lab-deploy-nodejs-app/images/lightsail-hello-api-deployment-versions.png)

> Figure 16. Rollback produces new deployment version

[^back to top](#top)

<!-- end step-14 -->

<!-- begin step-15 -->

### <a name="step-15"></a>Step 15 - Remove Amazon Lightsail Container

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

Congrats! You have completed a Python Flask deployment workshop on Amazon Lightsail Containers.

Don't forget to ⭐ this repo. See you at next workshop.

<!-- end step-15 -->