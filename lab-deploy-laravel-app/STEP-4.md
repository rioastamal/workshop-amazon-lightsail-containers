
### <a name="step-4"></a>Step 4 - Menjalankan untuk Development

Pertama kita instal semua ketergantungan pustaka yang diperlukan Laravel menggunakan Composer via Docker. 

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

Perintah diatas akan melakukan mount direktori `laravel/` ke `/app/` di Container. Composer akan membaca file `composer.lock` dan menginstal ketergantungan. Kemudian semua pustaka akan otomatis tersedia di direktori `laravel/vendor/`.

Untuk menjalankan maka kita perlu melakukan build container image tersebut terlebih dulu. Hal ini karena base image `php:8.1-apache` masih ada ekstensi dan konfigurasi yang tidak tersedia.

Buat dulu environment file untuk development dan production.

```sh
touch laravel/.env .env.prod
```

Buat nilai yang akan digunakan pada APP_KEY.

```sh
docker run --rm -v $(pwd)/laravel:/var/www/html \
public.ecr.aws/docker/library/php:8.1-apache \
php artisan key:generate --show
```

```
base64:bcHcNZAfo0/m4RePQ4Jk0H671ZVOk+CQGbPYXtvTyAs=
```

Update konfigurasi dari file `laravel/.env` seperti berikut.

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

File `laravel/.env` tidak akan masuk ke proses build karena masuk daftar _ignore_.

Berikutnya pastikan direktori `laravel/storage` writable.

```sh
sudo chmod 0777 -R laravel/storage/
```

Kita akan menamakan image ini `indonesia-belajar` dengan versi `1.0`.

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

Pastikan image tersebut ada dalam daftar image di lokal mesin.

```sh
docker images indonesia-belajar
```

```
REPOSITORY          TAG       IMAGE ID       CREATED             SIZE
indonesia-belajar   1.1       e0070a43c4d7   29 minutes ago      478MB
```

Dapat terlihat jika container image yang dibuat yaitu `indonesia-belajar` dengan versi `1.0` berhasil dibuat.

Sekarang coba jalankan container `indonesia-belajar:1.0` pada port `8080` untuk memastikan API yang dibuat dapat berjalan pada container. Apache pada container berjalan pada port `80`.

```sh
docker run --rm --name idn_belajar_1_0 -p 8080:80 \
-v $(pwd)/laravel:/var/www/html \
indonesia-belajar:1.0
```

Kemudian cek untuk memastikan container `indonesia-belajar:1.0` sedang berjalan.

```sh
docker ps
```

```
CONTAINER ID   IMAGE                   COMMAND                  CREATED          STATUS          PORTS                                   NAMES
edc39c6eca83   indonesia-belajar:1.0   "docker-php-entrypoi…"   15 seconds ago   Up 14 seconds   0.0.0.0:8080->80/tcp, :::8080->80/tcp   idn_belajar_1_0
```

Buka browser untuk mengecek jalannya aplikasi pada port `8080`.

[![Markdown Converter](https://raw.githubusercontent.com/rioastamal-examples/assets/main/workshop-amazon-lightsail-containers/lab-laravel-app/images/lightsail-hello-api-home.png)](https://raw.githubusercontent.com/rioastamal-examples/assets/main/workshop-amazon-lightsail-containers/lab-laravel-app/images/lightsail-hello-api-home.png)

> Gambar 0. Halaman Markdown Converter

Pada terminal kita dapat mencoba untuk melakukan konversi dari Markdown ke HTML menggunakan cURL.

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

```sh
docker stop idn_belajar_1_0
```


<table border="0" style="width: 100%; display: table;"><tr><td><a href="STEP-3.md">&laquo; Sebelumnya</td><td align="center"><a href="README.md">Daftar Isi</a></td><td align="right"><a href="STEP-5.md">Berikutnya &raquo;</a></td></tr></table>

<sup>Workshop: Deploy Python Flask dengan Amazon Lightsail Containers  
Version: 2022-14-06  
Author: [@rioastamal](https://github.com/rioastamal)</sup>
