<a name="top"></a>

<!-- begin step-0 -->

Language: [Bahasa Indonesia](https://github.com/rioastamal/workshop-amazon-lightsail-containers/tree/main/lab-deploy-laravel-app) | English

DRAFT - Need a review for any spelling or grammatical errors.

## Workshop: Deploy Laravel App on Amazon Lightsail Containers

In this workshop, participants will be guided how to deploy an API on Amazon Lightsail Containers. A simple API built using Laravel framework to convert Makrdown text to HTML will be used as an example in this workshop.

Participants can follow the workshop guide through steps that have been provided sequentially starting from step 1 to step 15.

- [Step 1 - Requirements](#step-1)
- [Step 2 - Menginstal Lightsail Control Plugin](#step-2)
- [Step 3 - Download Sample App](#step-3)
- [Step 4 - Run for Development](#step-4)
- [Step 5 - Run for Production](#step-5)
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
- Apache 2
- PHP 8.1
- Composer 2.3

To install PHP 8.1 and Apache 2 run following commnad.

```sh
docker pull public.ecr.aws/docker/library/php:8.1-apache
```

For Composer 2.3 run following command to install.

```sh
docker pull public.ecr.aws/docker/library/composer:2.3
```

Make sure those images are fully downloaded and exists on local machine.

```sh
docker images
```

```
REPOSITORY                               TAG          IMAGE ID       CREATED             SIZE
public.ecr.aws/docker/library/php        8.1-apache   9e0b7aff3bd6   38 hours ago        458MB
public.ecr.aws/docker/library/composer   2.3          a0dc29169f36   2 weeks ago         199MB
```

[^back to top](#top)

<!-- end step-1 -->

<!-- begin step-2 -->

### <a name="step-2"></a>Step 2 - Menginstal Lightsail Control Plugin

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

### <a name="step-3"></a>Step 3 - Download Contoh Aplikasi

In this step we will download sampel app, a Markdown converter built with Laravel.

Make sure you're in `$HOME` directory which is `/home/ec2-user`.

```sh
cd ~
pwd 
```

```
/home/ec2-user/
```

Download source code from GitHub using cURL or your browser.

```sh
curl -s -L -o 'hello-markdown.zip' \
'https://github.com/rioastamal-examples/laravel-hello-markdown/archive/refs/heads/main.zip'
```

Extract `hello-markdown.zip` to current directory.

```sh
unzip hello-markdown.zip
```

Rename extracted directory to `laravel-app`.

```sh
mv laravel-hello-markdown-main laravel-app
```

Go to directory `laravel-app` as we will working within this directory.

```sh
cd laravel-app
```

Below is how the sample app files and directories are structured.

```sh
ls -l
```

```
total 12
drwxrwxr-x  3 ec2-user ec2-user   27 Jun 24 13:49 apache2
-rw-rw-r--  1 ec2-user ec2-user  620 Jun 24 16:44 Dockerfile
drwxrwxr-x 13 ec2-user ec2-user 4096 Jun 24 16:55 laravel
-rw-rw-r--  1 ec2-user ec2-user 1068 Jun 24 13:57 LICENSE
```

[^back to top](#top)

<!-- end step-3 -->

<!-- begin step-4 -->

### <a name="step-4"></a>Step 4 - Running for Development

Install all dependencies required by Laravel using Composer via Docker. 

```sh
docker run --rm -i \
-v $(pwd)/laravel:/app public.ecr.aws/docker/library/composer:2.3 \
composer install --no-dev
```

```
...
Discovered Package: laravel/sanctum
Discovered Package: laravel/tinker
Discovered Package: nesbot/carbon
Package manifest generated successfully.
47 packages you are using are looking for funding.
Use the `composer fund` command to find out more!
```

Command above will mount local directory `laravel/` to `/app/` inside the container. Composer read `composer.lock` file and install all the dependencies. It will automatically available to `laravel/vendor/`.

To run the app, we need to build the container image first. This is because the base image `php:8.1-apache` has no extensions and configurations needed.

Buat dulu environment file untuk development dan production.

Create two environment files for development and production.

```sh
touch laravel/.env .env.prod
```

Generate `APP_KEY` by running command below. The value shown here may differ from yours.

```sh
docker run --rm -v $(pwd)/laravel:/var/www/html \
public.ecr.aws/docker/library/php:8.1-apache \
php artisan key:generate --show
```

```
base64:bcHcNZAfo0/m4RePQ4Jk0H671ZVOk+CQGbPYXtvTyAs=
```

Update konfigurasi dari file `laravel/.env` seperti berikut.

Update local Laravel configuration file `laravel.env` as follows.

```
cat <<EOF > laravel/.env
APP_NAME=Laravel
APP_ENV=local
APP_KEY=base64:bcHcNZAfo0/m4RePQ4Jk0H671ZVOk+CQGbPYXtvTyAs=
APP_DEBUG=true
APP_URL=http://localhost

LOG_CHANNEL=stack
LOG_DEPRECATIONS_CHANNEL=null
LOG_LEVEL=debug
EOF
```

File `laravel/.env` won't included into build process because it is on ignore list.

Make sure directory `laravel/storage` is writable.

```sh
sudo chmod 0777 -R laravel/storage/
```

Build and the container image `indonesia-belajar` version `1.0`.

```sh
docker build --rm -t indonesia-belajar:1.0 .
```

```
...[CUT]...
Configuration cache cleared successfully.
Configuration cached successfully.
Route cache cleared successfully.
Routes cached successfully.
Compiled views cleared successfully.
Blade templates cached successfully.
Removing intermediate container 94f1c2e45059
 ---> d10aba77d9fd
Successfully built d10aba77d9fd
Successfully tagged indonesia-belajar:1.0
```

Make sure our image are successfully build on local machine.

```sh
docker images indonesia-belajar
```

```
REPOSITORY          TAG       IMAGE ID       CREATED             SIZE
indonesia-belajar   1.1       e0070a43c4d7   29 minutes ago      478MB
```

As we can see now we have new container image `indonesia-belajar` version `1.0`.

Let's test the API by running this container on port `8080`. We will forward all the network request to port `80` since Apache 2 inside the container is running on that port. We mount our `laravel/` directory to `/var/www/html/` inside the container.

```sh
docker run --rm --name idn_belajar_1_0 -p 8080:80 \
-v $(pwd)/laravel:/var/www/html \
indonesia-belajar:1.0
```

Check with `ps` command to make sure our container is running.

```sh
docker ps
```

```
CONTAINER ID   IMAGE                   COMMAND                  CREATED          STATUS          PORTS                                   NAMES
edc39c6eca83   indonesia-belajar:1.0   "docker-php-entrypoi…"   15 seconds ago   Up 14 seconds   0.0.0.0:8080->80/tcp, :::8080->80/tcp   idn_belajar_1_0
```

Open `localhost:8080` using your browser to see the app.

[![Markdown Converter](https://raw.githubusercontent.com/rioastamal-examples/assets/main/workshop-amazon-lightsail-containers/lab-laravel-app/images/lightsail-hello-api-home.png)](https://raw.githubusercontent.com/rioastamal-examples/assets/main/workshop-amazon-lightsail-containers/lab-laravel-app/images/lightsail-hello-api-home.png)

> Figure 1. Markdown converter

We can also use cURL to convert Makrdown to HTML.

```sh
curl localhost:8080 -d '# Hello World

This text will be converted to **HTML**.

1. Number one
2. Number two
'
```

```html
<h1>Hello World</h1>
<p>This text will be converted to <strong>HTML</strong>.</p>
<ol>
<li>Number one</li>
<li>Number two</li>
</ol>
```

Mantab! Proses konversi markdown berjalan sukses. Sekarang stop container tersebut atau tekan `CTRL-C`.

Great! we are able to convert Markdown to text. Now stop the container by pressing `CTRL-C`.

```sh
docker stop idn_belajar_1_0
```

[^back to top](#top)

<!-- end step-4 -->

<!-- begin step-5 -->

### <a name="step-5"></a>Step 5 - Menjalankan untuk Production

Untuk menjalankan di production kita akan menggunakan file konfigurasi terpisah. Yang akan kita gunakan adalah file `.env.prod`. Generate dulu APP_KEY untuk production.

To run for production we will use a separate configuration file `.env.prod`. First generate APP_KEY for production. Keep in mind, the value should be different on your side.

```sh
docker run --rm -v $(pwd)/laravel:/var/www/html \
indonesia-belajar:1.0 \
php artisan key:generate --show
```

```
base64:+pELmqnKzeJue5lJzkkUFI3RRfjBz54CUXHdIeZ8QrU=
```

Overwrite the contents of `.env.prod` as shown below.

```
cat <<EOF > .env.prod
APP_NAME=Laravel
APP_ENV=production
APP_KEY=base64:+pELmqnKzeJue5lJzkkUFI3RRfjBz54CUXHdIeZ8QrU=
APP_DEBUG=false
APP_URL=http://localhost

LOG_CHANNEL=null
LOG_DEPRECATIONS_CHANNEL=null
LOG_LEVEL=debug
EOF
```

Rebuild `indonesia-belajar:1.0` container image. This process only to update the configuration file.

Keep it mind that storing configuration file inside container is not best practice. As an alternative, you may specify all this config on environment variables on Lightsail container service console.

```sh
docker build --rm -t indonesia-belajar:1.0 .
```

We will push this image to Lightsail container service. 

[^back to top](#top)

<!-- end step-5 -->

<!-- begin step-6 -->

### <a name="step-6"></a>Step 6 - Create Container Service on Amazon Lightsail

Container service is compute resource on which the container is run. It provides many choices of RAM and vCPU capacities that can be selected according to your application needs. In addition you can also specify the number of nodes on which container is running.

1. Go to AWS Management Console then go to Amazon Lightsail page. On the Amazon Lightsail Dashboard click the **Containers** menu.

[![Lightsail Containers Menu](https://raw.githubusercontent.com/rioastamal-examples/assets/main/workshop-amazon-lightsail-containers/lab-deploy-nodejs-app/images/lightsail-menu-containers.png)](https://raw.githubusercontent.com/rioastamal-examples/assets/main/workshop-amazon-lightsail-containers/lab-deploy-nodejs-app/images/lightsail-menu-containers.png)

> Figure 2. Containers menu on Amazon Lightsail

2. On the Containers page click the **Create container service** button to start creating a Container service.

[![Lightsail Create Instance Button](https://raw.githubusercontent.com/rioastamal-examples/assets/main/workshop-amazon-lightsail-containers/lab-deploy-nodejs-app/images/lightsail-button-create-instance.png)](https://raw.githubusercontent.com/rioastamal-examples/assets/main/workshop-amazon-lightsail-containers/lab-deploy-nodejs-app/images/lightsail-button-create-instance.png)

> Figure 3. Containers page contain a list of containers

3. Then we will be faced with several choices. In the _Container service location_ option, select the a region, in this case I choose **Singapore**. Click the **Change AWS Region** link to do so. In the container capacity option, select **Nano** which consist of 512MB RAM and 0.25 vCPU. For the scale option specify **x1**. It means that we will only launch 1 node to run the containers.

[![Lightsail Choose Container Capacity](https://raw.githubusercontent.com/rioastamal-examples/assets/main/workshop-amazon-lightsail-containers/lab-deploy-nodejs-app/images/lightsail-choose-container-capacity.png)](https://raw.githubusercontent.com/rioastamal-examples/assets/main/workshop-amazon-lightsail-containers/lab-deploy-nodejs-app/images/lightsail-choose-container-capacity.png)

> Figure 4. Selecting region and capacity of the container

4. Next is to determine the name of the service. In the _Identify your service_ section, enter **hello-api**. At the _Summary_ section as we can see we will launch a container with a **Nano** capacity (512MB RAM, 0.25 vCPU)  **x1**. Total cost for this container service is **$7** per month. All is set now click  **Create container service** button.

[![Lightsail Choose Service Name](https://raw.githubusercontent.com/rioastamal-examples/assets/main/workshop-amazon-lightsail-containers/lab-deploy-nodejs-app/images/lightsail-choose-service-name.png)](https://raw.githubusercontent.com/rioastamal-examples/assets/main/workshop-amazon-lightsail-containers/lab-deploy-nodejs-app/images/lightsail-choose-service-name.png)

> Figure 5. Entering the container service name

5. Container service creation will take few minutes, so be patient. Once done you will be taken to the dashboard of the **hello-api** container service page. You will get a domain to used to access your container. The domain is located at the _Public domain_ section. Wait until the status becomes **Ready** then click the domain to open **hello-api** container service. It should be still 404 error because no container image has been deployed to the container service.

[![Lightsail hello-api Dashboard](https://raw.githubusercontent.com/rioastamal-examples/assets/main/workshop-amazon-lightsail-containers/lab-deploy-nodejs-app/images/lightsail-hello-api-dashboard.png)](https://raw.githubusercontent.com/rioastamal-examples/assets/main/workshop-amazon-lightsail-containers/lab-deploy-nodejs-app/images/lightsail-hello-api-dashboard.png)

> Figure 6. Dashboard of the hello-api container service

[![Lightsail hello-api 404](https://raw.githubusercontent.com/rioastamal-examples/assets/main/workshop-amazon-lightsail-containers/lab-deploy-nodejs-app/images/lightsail-404-hello-api.png)](https://raw.githubusercontent.com/rioastamal-examples/assets/main/workshop-amazon-lightsail-containers/lab-deploy-nodejs-app/images/lightsail-404-hello-api.png)

> Figure 7. hello-api service returns 404 because no container image has been deployed

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

> Figure 8. List of uploaded container images

As you can see on the _Images_ page there is an container image `:hello-api.indonesia-belajar.12` that we just uploaded from previous step. We will use this image to do the deployment.

[^back to top](#top)

<!-- end step-7 -->

<!-- begin step-8 -->

### <a name="step-8"></a>Step 8 - Deploy Container Service

This step will create new deployment for **hello-api** container service using container image `:hello-api.indonesia-belajar.12`.

1. On the **hello-api** dashboard click the **Deployments** menu and then click the **Create your first deployment** link.

[![Lightsail Create Deployment](https://raw.githubusercontent.com/rioastamal-examples/assets/main/workshop-amazon-lightsail-containers/lab-deploy-nodejs-app/images/lightsail-hello-api-deployments-menu.png)](https://raw.githubusercontent.com/rioastamal-examples/assets/main/workshop-amazon-lightsail-containers/lab-deploy-nodejs-app/images/lightsail-hello-api-deployments-menu.png)

> Figure 9. Create your first deployment link

2. There are several things need to be configured. First enter **hello-idn-belajar** for the _Container name_. 
3. For the _Image_ option, click **Choose stored image** then choose our container image that has been uploaded.
4. For the **Open ports** use `80` as Apache is run on this port.
6. For **PUBLIC ENDPOINT** use container **idn-hello-belajar**. All traffic coming from public endpoint will be forwarded to this container.
7. Jika semua sudah sesuai, klik **Save and deploy** untuk melakukan deployment. Proses ini akan memakan waktu beberapa menit. Tunggu hingga status dari 
8. Click **Save and deploy** to begin deployment.

[![Lightsail Configure Deployment](https://raw.githubusercontent.com/rioastamal-examples/assets/main/workshop-amazon-lightsail-containers/lab-laravel-app/images/lightsail-hello-api-configure-deployment.png)](https://raw.githubusercontent.com/rioastamal-examples/assets/main/workshop-amazon-lightsail-containers/lab-laravel-app/images/lightsail-hello-api-configure-deployment.png)

> Figure 10. Deployment configuration for containers

When the status is **Running** we can try to access the API by opening the URL shown on the public domain section. The public endpoint use HTTPS protocol. We will use curl to do the test. Run command below and replace with your own public domain.

```sh
curl https://YOUR_OWN_CONTAINER_SERVICE_PUBLIC_DOMAIN/ \ 
-d '# Hello World

This text will be converted to **HTML**.

1. Number one
2. Number two
'
```

The result should be the same as we got on step 4.

Congrats! You gave successfully deployed a Laravel app on Amazon Lightsail Container service. Pretty easy isn't it?

[^back to top](#top)

<!-- end step-8 -->

<!-- begin step-9 -->

### <a name="step-9"></a>Step 9 - Create New Version of the API

Every application will almost certainly having an update whether for bug fixes or adding new features. In this step we will try to demonstrate how to update an application on Amazon Lightsail Container service.

In this example we want user able to convert Markdown using the web interface. We will modify `laravel/resources/views/welcome.blade.php`. We will also shows the IP address of the server.

Change the content of `welcome.blade.php` as shown below.

```php
<!DOCTYPE html>
<html lang="{{ str_replace('_', '-', app()->getLocale()) }}">
    <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">

        <title>Laravel</title>

        <!-- Fonts -->
        <link href="https://fonts.googleapis.com/css2?family=Nunito:wght@400;600;700&display=swap" rel="stylesheet">

        <!-- Styles -->
        <style>
            /*! normalize.css v8.0.1 | MIT License | github.com/necolas/normalize.css */html{line-height:1.15;-webkit-text-size-adjust:100%}body{margin:0}a{background-color:transparent}[hidden]{display:none}html{font-family:system-ui,-apple-system,BlinkMacSystemFont,Segoe UI,Roboto,Helvetica Neue,Arial,Noto Sans,sans-serif,Apple Color Emoji,Segoe UI Emoji,Segoe UI Symbol,Noto Color Emoji;line-height:1.5}*,:after,:before{box-sizing:border-box;border:0 solid #e2e8f0}a{color:inherit;text-decoration:inherit}svg,video{display:block;vertical-align:middle}video{max-width:100%;height:auto}.bg-white{--bg-opacity:1;background-color:#fff;background-color:rgba(255,255,255,var(--bg-opacity))}.bg-gray-100{--bg-opacity:1;background-color:#f7fafc;background-color:rgba(247,250,252,var(--bg-opacity))}.border-gray-200{--border-opacity:1;border-color:#edf2f7;border-color:rgba(237,242,247,var(--border-opacity))}.border-t{border-top-width:1px}.flex{display:flex}.grid{display:grid}.hidden{display:none}.items-center{align-items:center}.justify-center{justify-content:center}.font-semibold{font-weight:600}.h-5{height:1.25rem}.h-8{height:2rem}.h-16{height:4rem}.text-sm{font-size:.875rem}.text-lg{font-size:1.125rem}.leading-7{line-height:1.75rem}.mx-auto{margin-left:auto;margin-right:auto}.ml-1{margin-left:.25rem}.mt-2{margin-top:.5rem}.mr-2{margin-right:.5rem}.ml-2{margin-left:.5rem}.mt-4{margin-top:1rem}.ml-4{margin-left:1rem}.mt-8{margin-top:2rem}.ml-12{margin-left:3rem}.-mt-px{margin-top:-1px}.max-w-6xl{max-width:72rem}.min-h-screen{min-height:100vh}.overflow-hidden{overflow:hidden}.p-6{padding:1.5rem}.py-4{padding-top:1rem;padding-bottom:1rem}.px-6{padding-left:1.5rem;padding-right:1.5rem}.pt-8{padding-top:2rem}.fixed{position:fixed}.relative{position:relative}.top-0{top:0}.right-0{right:0}.shadow{box-shadow:0 1px 3px 0 rgba(0,0,0,.1),0 1px 2px 0 rgba(0,0,0,.06)}.text-center{text-align:center}.text-gray-200{--text-opacity:1;color:#edf2f7;color:rgba(237,242,247,var(--text-opacity))}.text-gray-300{--text-opacity:1;color:#e2e8f0;color:rgba(226,232,240,var(--text-opacity))}.text-gray-400{--text-opacity:1;color:#cbd5e0;color:rgba(203,213,224,var(--text-opacity))}.text-gray-500{--text-opacity:1;color:#a0aec0;color:rgba(160,174,192,var(--text-opacity))}.text-gray-600{--text-opacity:1;color:#718096;color:rgba(113,128,150,var(--text-opacity))}.text-gray-700{--text-opacity:1;color:#4a5568;color:rgba(74,85,104,var(--text-opacity))}.text-gray-900{--text-opacity:1;color:#1a202c;color:rgba(26,32,44,var(--text-opacity))}.underline{text-decoration:underline}.antialiased{-webkit-font-smoothing:antialiased;-moz-osx-font-smoothing:grayscale}.w-5{width:1.25rem}.w-8{width:2rem}.w-auto{width:auto}.grid-cols-1{grid-template-columns:repeat(1,minmax(0,1fr))}@media (min-width:640px){.sm\:rounded-lg{border-radius:.5rem}.sm\:block{display:block}.sm\:items-center{align-items:center}.sm\:justify-start{justify-content:flex-start}.sm\:justify-between{justify-content:space-between}.sm\:h-20{height:5rem}.sm\:ml-0{margin-left:0}.sm\:px-6{padding-left:1.5rem;padding-right:1.5rem}.sm\:pt-0{padding-top:0}.sm\:text-left{text-align:left}.sm\:text-right{text-align:right}}@media (min-width:768px){.md\:border-t-0{border-top-width:0}.md\:border-l{border-left-width:1px}.md\:grid-cols-2{grid-template-columns:repeat(2,minmax(0,1fr))}}@media (min-width:1024px){.lg\:px-8{padding-left:2rem;padding-right:2rem}}@media (prefers-color-scheme:dark){.dark\:bg-gray-800{--bg-opacity:1;background-color:#2d3748;background-color:rgba(45,55,72,var(--bg-opacity))}.dark\:bg-gray-900{--bg-opacity:1;background-color:#1a202c;background-color:rgba(26,32,44,var(--bg-opacity))}.dark\:border-gray-700{--border-opacity:1;border-color:#4a5568;border-color:rgba(74,85,104,var(--border-opacity))}.dark\:text-white{--text-opacity:1;color:#fff;color:rgba(255,255,255,var(--text-opacity))}.dark\:text-gray-400{--text-opacity:1;color:#cbd5e0;color:rgba(203,213,224,var(--text-opacity))}.dark\:text-gray-500{--tw-text-opacity:1;color:#6b7280;color:rgba(107,114,128,var(--tw-text-opacity))}}
        </style>

        <style>
            body {
                font-family: 'Nunito', sans-serif;
            }
        </style>
    </head>
    <body class="antialiased">
        <div class="relative flex items-top justify-center min-h-screen bg-gray-100 dark:bg-gray-900 sm:items-center py-4 sm:pt-0">
            <div class="max-w-6xl mx-auto sm:px-6 lg:px-8">
                <div class="flex justify-center pt-8 sm:justify-start sm:pt-0">
                    <svg viewBox="0 0 651 192" fill="none" xmlns="http://www.w3.org/2000/svg" class="h-16 w-auto text-gray-700 sm:h-20">
                        <g clip-path="url(#clip0)" fill="#EF3B2D">
                            <path d="M248.032 44.676h-16.466v100.23h47.394v-14.748h-30.928V44.676zM337.091 87.202c-2.101-3.341-5.083-5.965-8.949-7.875-3.865-1.909-7.756-2.864-11.669-2.864-5.062 0-9.69.931-13.89 2.792-4.201 1.861-7.804 4.417-10.811 7.661-3.007 3.246-5.347 6.993-7.016 11.239-1.672 4.249-2.506 8.713-2.506 13.389 0 4.774.834 9.26 2.506 13.459 1.669 4.202 4.009 7.925 7.016 11.169 3.007 3.246 6.609 5.799 10.811 7.66 4.199 1.861 8.828 2.792 13.89 2.792 3.913 0 7.804-.955 11.669-2.863 3.866-1.908 6.849-4.533 8.949-7.875v9.021h15.607V78.182h-15.607v9.02zm-1.431 32.503c-.955 2.578-2.291 4.821-4.009 6.73-1.719 1.91-3.795 3.437-6.229 4.582-2.435 1.146-5.133 1.718-8.091 1.718-2.96 0-5.633-.572-8.019-1.718-2.387-1.146-4.438-2.672-6.156-4.582-1.719-1.909-3.032-4.152-3.938-6.73-.909-2.577-1.36-5.298-1.36-8.161 0-2.864.451-5.585 1.36-8.162.905-2.577 2.219-4.819 3.938-6.729 1.718-1.908 3.77-3.437 6.156-4.582 2.386-1.146 5.059-1.718 8.019-1.718 2.958 0 5.656.572 8.091 1.718 2.434 1.146 4.51 2.674 6.229 4.582 1.718 1.91 3.054 4.152 4.009 6.729.953 2.577 1.432 5.298 1.432 8.162-.001 2.863-.479 5.584-1.432 8.161zM463.954 87.202c-2.101-3.341-5.083-5.965-8.949-7.875-3.865-1.909-7.756-2.864-11.669-2.864-5.062 0-9.69.931-13.89 2.792-4.201 1.861-7.804 4.417-10.811 7.661-3.007 3.246-5.347 6.993-7.016 11.239-1.672 4.249-2.506 8.713-2.506 13.389 0 4.774.834 9.26 2.506 13.459 1.669 4.202 4.009 7.925 7.016 11.169 3.007 3.246 6.609 5.799 10.811 7.66 4.199 1.861 8.828 2.792 13.89 2.792 3.913 0 7.804-.955 11.669-2.863 3.866-1.908 6.849-4.533 8.949-7.875v9.021h15.607V78.182h-15.607v9.02zm-1.432 32.503c-.955 2.578-2.291 4.821-4.009 6.73-1.719 1.91-3.795 3.437-6.229 4.582-2.435 1.146-5.133 1.718-8.091 1.718-2.96 0-5.633-.572-8.019-1.718-2.387-1.146-4.438-2.672-6.156-4.582-1.719-1.909-3.032-4.152-3.938-6.73-.909-2.577-1.36-5.298-1.36-8.161 0-2.864.451-5.585 1.36-8.162.905-2.577 2.219-4.819 3.938-6.729 1.718-1.908 3.77-3.437 6.156-4.582 2.386-1.146 5.059-1.718 8.019-1.718 2.958 0 5.656.572 8.091 1.718 2.434 1.146 4.51 2.674 6.229 4.582 1.718 1.91 3.054 4.152 4.009 6.729.953 2.577 1.432 5.298 1.432 8.162 0 2.863-.479 5.584-1.432 8.161zM650.772 44.676h-15.606v100.23h15.606V44.676zM365.013 144.906h15.607V93.538h26.776V78.182h-42.383v66.724zM542.133 78.182l-19.616 51.096-19.616-51.096h-15.808l25.617 66.724h19.614l25.617-66.724h-15.808zM591.98 76.466c-19.112 0-34.239 15.706-34.239 35.079 0 21.416 14.641 35.079 36.239 35.079 12.088 0 19.806-4.622 29.234-14.688l-10.544-8.158c-.006.008-7.958 10.449-19.832 10.449-13.802 0-19.612-11.127-19.612-16.884h51.777c2.72-22.043-11.772-40.877-33.023-40.877zm-18.713 29.28c.12-1.284 1.917-16.884 18.589-16.884 16.671 0 18.697 15.598 18.813 16.884h-37.402zM184.068 43.892c-.024-.088-.073-.165-.104-.25-.058-.157-.108-.316-.191-.46-.056-.097-.137-.176-.203-.265-.087-.117-.161-.242-.265-.345-.085-.086-.194-.148-.29-.223-.109-.085-.206-.182-.327-.252l-.002-.001-.002-.002-35.648-20.524a2.971 2.971 0 00-2.964 0l-35.647 20.522-.002.002-.002.001c-.121.07-.219.167-.327.252-.096.075-.205.138-.29.223-.103.103-.178.228-.265.345-.066.089-.147.169-.203.265-.083.144-.133.304-.191.46-.031.085-.08.162-.104.25-.067.249-.103.51-.103.776v38.979l-29.706 17.103V24.493a3 3 0 00-.103-.776c-.024-.088-.073-.165-.104-.25-.058-.157-.108-.316-.191-.46-.056-.097-.137-.176-.203-.265-.087-.117-.161-.242-.265-.345-.085-.086-.194-.148-.29-.223-.109-.085-.206-.182-.327-.252l-.002-.001-.002-.002L40.098 1.396a2.971 2.971 0 00-2.964 0L1.487 21.919l-.002.002-.002.001c-.121.07-.219.167-.327.252-.096.075-.205.138-.29.223-.103.103-.178.228-.265.345-.066.089-.147.169-.203.265-.083.144-.133.304-.191.46-.031.085-.08.162-.104.25-.067.249-.103.51-.103.776v122.09c0 1.063.568 2.044 1.489 2.575l71.293 41.045c.156.089.324.143.49.202.078.028.15.074.23.095a2.98 2.98 0 001.524 0c.069-.018.132-.059.2-.083.176-.061.354-.119.519-.214l71.293-41.045a2.971 2.971 0 001.489-2.575v-38.979l34.158-19.666a2.971 2.971 0 001.489-2.575V44.666a3.075 3.075 0 00-.106-.774zM74.255 143.167l-29.648-16.779 31.136-17.926.001-.001 34.164-19.669 29.674 17.084-21.772 12.428-43.555 24.863zm68.329-76.259v33.841l-12.475-7.182-17.231-9.92V49.806l12.475 7.182 17.231 9.92zm2.97-39.335l29.693 17.095-29.693 17.095-29.693-17.095 29.693-17.095zM54.06 114.089l-12.475 7.182V46.733l17.231-9.92 12.475-7.182v74.537l-17.231 9.921zM38.614 7.398l29.693 17.095-29.693 17.095L8.921 24.493 38.614 7.398zM5.938 29.632l12.475 7.182 17.231 9.92v79.676l.001.005-.001.006c0 .114.032.221.045.333.017.146.021.294.059.434l.002.007c.032.117.094.222.14.334.051.124.088.255.156.371a.036.036 0 00.004.009c.061.105.149.191.222.288.081.105.149.22.244.314l.008.01c.084.083.19.142.284.215.106.083.202.178.32.247l.013.005.011.008 34.139 19.321v34.175L5.939 144.867V29.632h-.001zm136.646 115.235l-65.352 37.625V148.31l48.399-27.628 16.953-9.677v33.862zm35.646-61.22l-29.706 17.102V66.908l17.231-9.92 12.475-7.182v33.841z"/>
                        </g>
                    </svg>
                </div>

                <div class="mt-8 bg-white dark:bg-gray-800 overflow-hidden shadow sm:rounded-lg">
                    <div class="grid grid-cols-1 md:grid-cols-2">
                        <div class="p-6">
                            <div class="flex items-center">
                                <svg fill="none" stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" viewBox="0 0 24 24" class="w-8 h-8 text-gray-500"><path d="M12 6.253v13m0-13C10.832 5.477 9.246 5 7.5 5S4.168 5.477 3 6.253v13C4.168 18.477 5.754 18 7.5 18s3.332.477 4.5 1.253m0-13C13.168 5.477 14.754 5 16.5 5c1.747 0 3.332.477 4.5 1.253v13C19.832 18.477 18.247 18 16.5 18c-1.746 0-3.332.477-4.5 1.253"></path></svg>
                                <div class="ml-4 text-lg leading-7 font-semibold"><a class="underline text-gray-900 dark:text-white" href="https://github.com/rioastamal/workshop-amazon-lightsail-containers">Workshop Amazon Lightsail Containers</a></div>
                            </div>

                            <div class="ml-12">
                                <form method="POST">
                                  <textarea name="markdown" placeholder="Your markdown here" style="border: 1px solid gray; width: 400px; height: 200px">{{ $markdownInput ?? '' }}</textarea><br>
                                  <input type="submit" value="Convert">
                                </form>
                            </div>
                        </div>
                    </div>
                    
                    <div class="p-6">
                        <div class="flex items-center">
                            <svg fill="none" stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" viewBox="0 0 24 24" class="w-8 h-8 text-gray-500"><path d="M12 6.253v13m0-13C10.832 5.477 9.246 5 7.5 5S4.168 5.477 3 6.253v13C4.168 18.477 5.754 18 7.5 18s3.332.477 4.5 1.253m0-13C13.168 5.477 14.754 5 16.5 5c1.747 0 3.332.477 4.5 1.253v13C19.832 18.477 18.247 18 16.5 18c-1.746 0-3.332.477-4.5 1.253"></path></svg>
                            <div class="ml-4 text-lg leading-7 font-semibold"><a class="underline text-gray-900 dark:text-white" href="https://github.com/rioastamal/workshop-amazon-lightsail-containers">Response</a></div>
                        </div>
                        
                        <div class="ml-12">
                            <div class="mt-2 text-gray-600 dark:text-gray-400 text-sm">{!! $htmlOutput ?? '' !!}</div>
                        </div>
                    </div>
                </div>

                <div class="flex justify-center mt-4 sm:items-center sm:justify-between">
                    <div class="ml-4 text-center text-sm text-gray-500 sm:text-right sm:ml-0">
                        Laravel v{{ Illuminate\Foundation\Application::VERSION }} (PHP v{{ PHP_VERSION }}) - 
                        Local IP Address: {{ $_SERVER['SERVER_ADDR'] }}
                    </div>
                </div>
            </div>
        </div>
    </body>
</html>
```

Next, we need to modify our router file `routes/web.php`.

```php
<?php

use Illuminate\Support\Facades\Route;
use Illuminate\Http\Request;
use Illuminate\Support\Str;

/*
|--------------------------------------------------------------------------
| Web Routes
|--------------------------------------------------------------------------
|
| Here is where you can register web routes for your application. These
| routes are loaded by the RouteServiceProvider within a group which
| contains the "web" middleware group. Now create something great!
|
*/

Route::get('/', function () {
    return view('welcome');
});

// For v2 Demo
Route::post('/', function(Request $request) {
    $option = $request->query('output', 'html');
    if ($option === 'raw') {
        return Str::of($request->getContent())->markdown([
            'html_input' => 'strip',
            'allow_unsafe_links' => false,
        ]) . "\n--\nLocal IP Address: {$_SERVER['SERVER_ADDR']}";
    }
    
    $markdownInput = $request->input('markdown', '');
    $htmlOutput = Str::of($markdownInput)->markdown([
        'html_input' => 'strip',
        'allow_unsafe_links' => false,
    ]);

    // Blade output
    return view('welcome', [
        'markdownInput' => $markdownInput,
        'htmlOutput' => $htmlOutput
    ]);
});

```

After all modification, run this app using Docker.

```sh
docker run --rm --name idn_belajar_1_0 -p 8080:80 \
-v $(pwd)/laravel:/var/www/html \
indonesia-belajar:1.0
```
Open the app via browser. There should be a new textbox component to enter Markdown text and a button **convert**.

[![Versi Terbaru](https://raw.githubusercontent.com/rioastamal-examples/assets/main/workshop-amazon-lightsail-containers/lab-laravel-app/images/lightsail-hello-api-home-v2.png)](https://raw.githubusercontent.com/rioastamal-examples/assets/main/workshop-amazon-lightsail-containers/lab-laravel-app/images/lightsail-hello-api-home-v2.png)

> Figure 11. New version of Markdown converter

Sedangkan untuk tetap mengembalikan secara raw atau teks HTML dari markdown saja maka gunakan parameter `output=raw` pada query string.

In order to return raw or only HTML text from the Markdown then we need to pass paramter `output=raw` on query string.

```sh
curl 'localhost:8080/?output=raw' \
-d '# Hello World          

This text will be converted to **HTML**.

1. Number one
2. Number two
'
```

```
<h1>Hello World</h1>
<p>This text will be converted to <strong>HTML</strong>.</p>
<ol>
<li>Number one</li>
<li>Number two</li>
</ol>

--
Local IP Address: 172.17.0.2
```

Press `CTRL+C` to stop the container.

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
Compiled views cleared successfully.
Blade templates cached successfully.
Removing intermediate container df51dda8b2ee
 ---> 952d9875be26
Successfully built 952d9875be26
Successfully tagged indonesia-belajar:2.0
```

Let's see if our new container image is already on the list.

```sh
docker images indonesia-belajar
```

```
REPOSITORY          TAG       IMAGE ID       CREATED          SIZE
indonesia-belajar   2.0       952d9875be26   58 seconds ago   478MB
indonesia-belajar   1.0       e76cb9d91076   40 minutes ago   478MB
```

Let's run our `indonesia-belajar:2.0` to make sure it is working as expected.

```sh
docker run --rm --name idn_belajar_2_0 \
-p 8080:80 -d indonesia-belajar:2.0
```

```
d8df1a6d0dbd70de4cd36ff21e5b6a766a7bb0c21d28819d37fdff612aefe23c
```

Open `loclahost:8080` on your browser dan do some test to convert Markdown.

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

> Figure 12. Container image version 2.0

[^back to top](#top)

<!-- end step-11 -->

<!-- begin step-12 -->

## <a name="step-12"></a>Step 12 - Deploy Versi Terbaru dari API

Setelah container image versi terbaru `indonesia-belajar:2.0` diupload ke Amazon Lightsail Containers maka kita dapat melakukan deployment versi terbaru dari API menggunakan image tersebut.

Once the container image `-belajar:2.0` uploaded to Amazon Lightsail Containers, we can deploy the latest version of the API using that image.

1. Go to Dashboard of the container service **hello-api** and make sure you're at the _Deployments_ page.
2. Click the **Modify your deployment** to open the configuration section to create new deployment.
3. The only configuration that need to change is container image which being used. Klik the **Choose stored image** then pick the latest one.
4. No need to change the rest of the configuration.
5. Wait few minutes for the status to change back to **Running**.

[![Lightsail Update Deployment](https://raw.githubusercontent.com/rioastamal-examples/assets/main/workshop-amazon-lightsail-containers/lab-general-app/images/lightsail-hello-api-modify-deployment.png)](https://raw.githubusercontent.com/rioastamal-examples/assets/main/workshop-amazon-lightsail-containers/lab-general-app/images/lightsail-hello-api-modify-deployment.png)

> Figure 13. Deployment of new version

After the status back to **Running** it's time to test it out using HTTP request. Use cURL or your browser to test the new deployment.

```sh
curl -s 'https://YOUR_OWN_CONTAINER_SERVICE_PUBLIC_DOMAIN/?output=raw' \
-d '# Hello World'
```

```
<h1>Hello World</h1>

--
Local IP Address: 172.17.0.2
```

Cool! The new version API has been successfully deployed. Now it contains new local IP address of the server.

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

> Figure 14. Changing container service capacity

4. We are still going to use Nano type for the capacity and for the scale move it to **3**.

[![Lightsail Add Node](https://raw.githubusercontent.com/rioastamal-examples/assets/main/workshop-amazon-lightsail-containers/lab-deploy-nodejs-app/images/lightsail-hello-api-capacity-add-node.png)](https://raw.githubusercontent.com/rioastamal-examples/assets/main/workshop-amazon-lightsail-containers/lab-deploy-nodejs-app/images/lightsail-hello-api-capacity-add-node.png)

> Figure 15. Adding more nodes for container service

5. This process will several minutes to complete, click **I understand** to close the dialog.
6. Wait for the status of the container service back to **Running**.

[![Lightsail New Capacity](https://raw.githubusercontent.com/rioastamal-examples/assets/main/workshop-amazon-lightsail-containers/lab-deploy-nodejs-app/images/lightsail-hello-api-new-capacity-applied.png)](https://raw.githubusercontent.com/rioastamal-examples/assets/main/workshop-amazon-lightsail-containers/lab-deploy-nodejs-app/images/lightsail-hello-api-new-capacity-applied.png)

> Figure 16. Number of nodes has been increased

Amazon Lightsail automatically will distributes the traffic to the 3 nodes running on **hello-api** container service. You don't need to configure anything including the load balancer.

Now test the response from the API and see the value of the local IP that is returned. The IP address of each request should have different results depending on which node is serving. Make a request to the public endpoint of the container several times and see the results.

```sh
curl -s 'https://YOUR_OWN_CONTAINER_SERVICE_PUBLIC_DOMAIN/?output=raw' \
-d '# Hello World'
```

```
<h1>Hello World</h1>

--
Local IP Address: 172.26.33.207
```

```sh
curl -s 'https://YOUR_OWN_CONTAINER_SERVICE_PUBLIC_DOMAIN/?output=raw' \
-d '# Hello World'
```

```
<h1>Hello World</h1>

--
Local IP Address: 172.26.7.130
```

```sh
curl -s 'https://YOUR_OWN_CONTAINER_SERVICE_PUBLIC_DOMAIN/?output=raw' \
-d '# Hello World'
```

```
<h1>Hello World</h1>

--
Local IP Address: 172.26.19.9
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

> Figure 17. Rollback deployment to previous version

5. A confirmation dialog will appear, click **Yes button, continue**.
6. The deployment process has not been carried out, it only autofill the Image configuration value that changed the image previous version, namely `:hello-api.indonesia-belajar.12`. The uploaded version number `.12` may be different on your side.
7. Click **Save and deploy** button to start the rollback deployment process from the previous image.
8. Wait until the status of the container service returns to Running.

When rollback is complete and the status returns to _Running_, try to make a request to the API to see if the response matches the previous version.

```sh
curl -s 'https://YOUR_OWN_CONTAINER_SERVICE_PUBLIC_DOMAIN/?output=raw' \
-d '# Hello World'
```

```
<h1>Hello World</h1>
```

Now API does not return the local IP of the server as it should be in version `indonesia-belajar:2.0`, instead it return response from previous deployment using `indonesia-belajar:1.0` image.

So doing rollback is as simple as changing the version of the container image to run.

Keep in mind that rollback is also a deployment process so it will increase deployment version as seen in the image below, our rollback results in a version 3 deployment.

[![Lightsail Deployment Versions](https://raw.githubusercontent.com/rioastamal-examples/assets/main/workshop-amazon-lightsail-containers/lab-deploy-nodejs-app/images/lightsail-hello-api-deployment-versions.png)](https://raw.githubusercontent.com/rioastamal-examples/assets/main/workshop-amazon-lightsail-containers/lab-deploy-nodejs-app/images/lightsail-hello-api-deployment-versions.png)

> Figure 18. Rollback produces new deployment version

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

> Figure 19. Removing a container service

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

Congrats! You have completed a Laravel app deployment workshop on Amazon Lightsail Containers.

Don't forget to ⭐ this repo. See you at next workshop.

<!-- end step-15 -->