
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


<table border="0" style="width: 100%; display: table;"><tr><td><a href="STEP-3.md">&laquo; Previous</td><td align="center"><a href="README.md">Index</a></td><td align="right"><a href="STEP-5.md">Next &raquo;</a></td></tr></table>

<sup>Workshop: Deploy Laravel App on Amazon Lightsail Containers  
Version: 2022-24-06  
Author: [@rioastamal](https://github.com/rioastamal)</sup>
