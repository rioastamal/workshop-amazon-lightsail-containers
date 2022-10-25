<a name="top"></a>

<!-- begin step-0 -->

Language: Bahasa Indonesia | [English](https://github.com/rioastamal/workshop-amazon-lightsail-containers/tree/english/lab-deploy-laravel-app)

## Workshop Deploy Laravel App dengan Amazon Lightsail Containers

Pada workshop ini peserta akan mempraktikkan bagaimana melakukan deployment sebuah web app menggunakan Amazon Lightsail Containers. Sebuah app sederhana untuk melakukan konversi Markdown ke HTML yang dibangun dengan Laravel framework akan digunakan sebagai contoh pada praktik ini. 

Peserta dapat mengikuti panduan workshop melalui step-step atau langkah-langkah yang telah disediakan secara berurutan mulai dari step 1 hingga step 15.

- [Step 1 - Kebutuhan](#step-1)
- [Step 2 - Menginstal Lightsail Control Plugin](#step-2)
- [Step 3 - Download Contoh Aplikasi](#step-3)
- [Step 4 - Menjalankan untuk Development](#step-4)
- [Step 5 - Menjalankan untuk Production](#step-5)
- [Step 6 - Membuat Container Service di Amazon Lightsail](#step-6)
- [Step 7 - Push Container Image ke Amazon Lightsail](#step-7)
- [Step 8 - Deploy Container](#step-8)
- [Step 9 - Membuat Versi Baru dari API](#step-9)
- [Step 10 - Update Container Image](#step-10)
- [Step 11 - Push Container Image Versi Terbaru](#step-11)
- [Step 12 - Deploy Versi Terbaru dari API](#step-12)
- [Step 13 - Menambah Jumlah Node](#step-13)
- [Step 14 - Rollback API ke Versi Sebelumnya](#step-14)
- [Step 15 - Menghapus Amazon Lightsail Container Service](#step-15)

Jika anda lebih menyukai semua langkah dalam satu halaman maka silahkan membuka file [README.single-page.md](README.single-page.md).

<!-- end step-0 -->

<!-- begin step-1 -->

### <a name="step-1"></a>Step 1 - Kebutuhan

Sebelum memulai workshop pastikan sudah memenuhi kebutuhan yang tercantum di bawah ini.

- Memiliki akun AWS aktif
- Sudah menginstal Docker
- Sudah menginstal AWS CLI v2 dan konfigurasinya
- Apache 2
- PHP 8.1
- Composer 2.3

Untuk menginstal PHP 8.1 dan Apache 2 gunakan perintah berikut.

```sh
docker pull public.ecr.aws/docker/library/php:8.1-apache
```

Untuk Composer 2.3 gunakan perintah berikut.

```sh
docker pull public.ecr.aws/docker/library/composer:2.3
```

Untuk memastikan image sudah ada pada lokal mesin, jalankan perintah ini.

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

Plugin CLI ini digunakan untuk mengupload container image dari komputer lokal ke Amazon Lightsail container service. Jalankan perintah berikut untuk menginstal Lightsail Control Plugin. Diasumsikan bahwa terdapat perintah `sudo` pada distribusi Linux yang anda gunakan.

```sh
sudo curl "https://s3.us-west-2.amazonaws.com/lightsailctl/latest/linux-amd64/lightsailctl" -o "/usr/local/bin/lightsailctl"
```

Tambahkan atribut _execute_ pada file `lightsailctl` yang baru saja didownload.

```sh
sudo chmod +x /usr/local/bin/lightsailctl
```

Pastikan atribut _execute_ sudah teraplikasikan ke file.

```sh
ls -l /usr/local/bin/lightsailctl
```

```
-rwxr-xr-x 1 root root 13201408 May 28 03:16 /usr/local/bin/lightsailctl
```

Itu ditandai dengan adanya huruf `x` pada daftar atribut, contohnya `-rwxr-xr-x`.

[^back to top](#top)

<!-- end step-2 -->

<!-- begin step-3 -->

### <a name="step-3"></a>Step 3 - Download Contoh Aplikasi

Pada praktik ini sudah disediakan sebuah contoh aplikasi Markdown converter sederhana dibangun dengan Laravel.

Pastikan anda sedang berada pada `$HOME` direktori yaitu `/home/ec2-user`.

```sh
cd ~
pwd 
```

```
/home/ec2-user/
```

Download kode sumber dari GitHub menggunakan utilitas cURL.

```sh
curl -s -L -o 'hello-markdown.zip' \
'https://github.com/rioastamal-examples/laravel-hello-markdown/archive/refs/heads/main.zip'
```

Ekstrak file `hello-markdown.zip` ke direktori saat ini.

```sh
unzip hello-markdown.zip
```

Rename direktori hasil ekstrak menjadi `laravel-app`.

```sh
mv laravel-hello-markdown-main laravel-app
```

Kemudian masuk ke dalam direktori `laravel-app`. Kita akan bekerja dari dalam direktori ini.

```sh
cd laravel-app
```

Untuk melihat isinya gunakan perintah berikut.

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

[^back to top](#top)

<!-- end step-4 -->

<!-- begin step-5 -->

### <a name="step-5"></a>Step 5 - Menjalankan untuk Production

Untuk menjalankan di production kita akan menggunakan file konfigurasi terpisah. Yang akan kita gunakan adalah file `.env.prod`. Generate dulu APP_KEY untuk production.

```sh
docker run --rm -v $(pwd)/laravel:/var/www/html \
indonesia-belajar:1.0 \
php artisan key:generate --show
```

```
base64:+pELmqnKzeJue5lJzkkUFI3RRfjBz54CUXHdIeZ8QrU=
```

Update konfigurasi dari file `.env.prod` seperti berikut.

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

Build ulang `indonesia-belajar` dengan versi yang sama yaitu `1.0`. Proses ini hanya untuk update file konfigurasi.

```sh
docker build --rm -t indonesia-belajar:1.0 .
```

Nantinya kita akan mempush image ini ke Lightsail container service.

[^back to top](#top)

<!-- end step-5 -->

<!-- begin step-6 -->

### <a name="step-6"></a>Step 6 - Membuat Container Service di Amazon Lightsail

Container service adalah sumber daya komputasi tempat dimana container dijalankan. Container service memiliki banyak pilihan kapasitas RAM dan vCPU yang bisa dipilih sesuai dengan kebutuhan aplikasi. Selain itu anda juga bisa menentukan jumlah node yang berjalan.

1. Sekarang masuk ke AWS Management Console kemudian masuk ke halaman Amazon Lightsail. Pada dashboard Amazon Lightsail klik menu **Containers**.

[![Lightsail Containers Menu](https://raw.githubusercontent.com/rioastamal-examples/assets/main/workshop-amazon-lightsail-containers/lab-deploy-nodejs-app/images/lightsail-menu-containers.png)](https://raw.githubusercontent.com/rioastamal-examples/assets/main/workshop-amazon-lightsail-containers/lab-deploy-nodejs-app/images/lightsail-menu-containers.png)

> Gambar 1. Menu Containers pada Amazon Lightsail

2. Pada halaman Containers klik tombol **Create Instance** untuk mulai membuat sebuah Container service.

[![Lightsail Create Instance Button](https://raw.githubusercontent.com/rioastamal-examples/assets/main/workshop-amazon-lightsail-containers/lab-deploy-nodejs-app/images/lightsail-button-create-instance.png)](https://raw.githubusercontent.com/rioastamal-examples/assets/main/workshop-amazon-lightsail-containers/lab-deploy-nodejs-app/images/lightsail-button-create-instance.png)

> Gambar 2. Halaman Containers yang berisi daftar container yang telah dibuat

3. Kemudian kita akan dihadapkan beberapa pilihan. Pada pilihan _Container service location_ pilih region **Singapore**. Klik link **Change AWS Region** untuk melakukannya. Pada pilihan kapasitas container pilih **Nano** dengan RAM 512MB dan vCPU 0.25. Pilihan _Choose the scale_ adalah untuk menentukan jumlah container yang akan diluncurkan, pilih **x1**. Artinya kita hanya akan meluncurkan 1 buah container.

[![Lightsail Choose Container Capacity](https://raw.githubusercontent.com/rioastamal-examples/assets/main/workshop-amazon-lightsail-containers/lab-deploy-nodejs-app/images/lightsail-choose-container-capacity.png)](https://raw.githubusercontent.com/rioastamal-examples/assets/main/workshop-amazon-lightsail-containers/lab-deploy-nodejs-app/images/lightsail-choose-container-capacity.png)

> Gambar 3. Memilih region dan kapasitas dari container

4. Lanjut pada pilihan selanjutnya adalah menentukan nama layanan. Pada bagian _Identify your service_ isi dengan **hello-api**. Pastikan pada bagian _Summary_ bahwa kita akan meluncurkan sebuah container dengan kapasitas **Nano** (512MB RAM, 0.25 vCPU) sebanyak **x1**. Total biaya untuk kapasitas tersebut adalah **$7 USD** per bulan. Jika sudah sesuai maka klik tombol **Create container service** untuk menyelesaikan pembuatan container service.

[![Lightsail Choose Service Name](https://raw.githubusercontent.com/rioastamal-examples/assets/main/workshop-amazon-lightsail-containers/lab-deploy-nodejs-app/images/lightsail-choose-service-name.png)](https://raw.githubusercontent.com/rioastamal-examples/assets/main/workshop-amazon-lightsail-containers/lab-deploy-nodejs-app/images/lightsail-choose-service-name.png)

> Gambar 4. Memasukkan nama container service

5. Setelah itu Lightsail akan mulai memproses pembuatan container service **hello-api**. Ini akan memakan waktu beberapa menit, jadi mohon ditunggu. Setelah selesai anda akan dibawa ke dashboard dari halaman container service **hello-api**. ANda akan mendapat domain yang digunakan untuk mengakses container. Domain tersebut terlihat di bagian _Public domain_. Tunggu hingga status menjadi **Ready** kemudian klik domain tersebut untuk membuka aplikasi **hello-api**. Ketika domain tersebut dikunjungi harusnya terdapat error 404 karena belum ada container image yang dideploy pada **hello-api**.

[![Lightsail hello-api Dashboard](https://raw.githubusercontent.com/rioastamal-examples/assets/main/workshop-amazon-lightsail-containers/lab-deploy-nodejs-app/images/lightsail-hello-api-dashboard.png)](https://raw.githubusercontent.com/rioastamal-examples/assets/main/workshop-amazon-lightsail-containers/lab-deploy-nodejs-app/images/lightsail-hello-api-dashboard.png)

> Gambar 5. Dashboard dari container service hello-api

[![Lightsail hello-api 404](https://raw.githubusercontent.com/rioastamal-examples/assets/main/workshop-amazon-lightsail-containers/lab-deploy-nodejs-app/images/lightsail-404-hello-api.png)](https://raw.githubusercontent.com/rioastamal-examples/assets/main/workshop-amazon-lightsail-containers/lab-deploy-nodejs-app/images/lightsail-404-hello-api.png)

> Gambar 6. Layanan hello-api masih 404 karena belum ada container image yang dideploy

[^back to top](#top)

<!-- end step-6 -->

<!-- begin step-7 -->

### <a name="step-7"></a>Step 7 - Push Container Image ke Amazon Lightsail

Setiap container image yang di-push ke Amazon Lightsail terikat pada sebuah Container service. Karena itulah kita membuat **hello-api** Container service terlebih dahulu sebelum melakukan push container image.

Pada langkah ini kita akan melakukan push container image `indonesia-belajar:1.0` yang telah dibuat sebelumnya ke Container service **hello-api**. Jalankan perintah dibawah ini.

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

Jika berhasil maka anda akan mendapatkan pesan mirip seperti diatas. Container image akan disimpan dengan penamaan `:<container-service>:<label>.<versi-upload>` pada contoh diatas penamaannya adalah `:hello-api.indonesia-belajar.12`.

Sekarang pastikan container image tersebut ada dalam daftar container yang telah diupload. Masuk ke halaman dashboard dari container service **hello api** kemudian masuk ke halaman **Images**.

[![Lightsail hello-api Image](https://raw.githubusercontent.com/rioastamal-examples/assets/main/workshop-amazon-lightsail-containers/lab-general-app/images/lightsail-hello-api-image.png)](https://raw.githubusercontent.com/rioastamal-examples/assets/main/workshop-amazon-lightsail-containers/lab-general-app/images/lightsail-hello-api-image.png)

> Gambar 7. Daftar container image yang telah diupload

Pada halaman _Images_ dapat terlihat jika terdapat sebuah image `:hello-api.indonesia-belajar.12` seperti yang telah diupload pada proses sebelumnya. Kita akan menggunakan image ini untuk melakukan deployment.

[^back to top](#top)

<!-- end step-7 -->

<!-- begin step-8 -->

### <a name="step-8"></a>Step 8 - Deploy Container

Proses ini digunakan untuk menempatkan container yang akan dijalankan ke Container service yang telah tersedia. Pada contoh ini kita telah membuat sebuah Container service dengan nama **hello-api** dengan kapasitas 512MB RAM dan 0.25 vCPU dan hanya berjumlah 1.

1. Pada halaman dashboard **hello-api** klik menu **Deployments** kemudian klik link **Create your first deployment**.

[![Lightsail Create Deployment](https://raw.githubusercontent.com/rioastamal-examples/assets/main/workshop-amazon-lightsail-containers/lab-deploy-nodejs-app/images/lightsail-hello-api-deployments-menu.png)](https://raw.githubusercontent.com/rioastamal-examples/assets/main/workshop-amazon-lightsail-containers/lab-deploy-nodejs-app/images/lightsail-hello-api-deployments-menu.png)

> Gambar 8. Membuka halaman deployment

2. Terdapat beberapa isian yang harus dilengkapi. Pertama isikan **hello-idn-belajar** untuk _Container name_. 
3. Pada pilihan _Image_ klik **Choose stored image** untuk memilih container image yang sudah diupload sebelumnya. Pilih versi container image yang telah diupload.
4. Pada konfigurasi **Open ports** gunakan nomor port dimana aplikasi berjalan. Dalam hal ini Apache berjalan pada port `80`.
5. Untuk **PUBLIC ENDPOINT** gunakan container **hello-idn-belajar** yang telah diinput pada bagian sebelumnya. Container service yang berjalan pada public domain akan melakukan koneksi pada `80` yang dikonfigurasi pada **Open ports**.
6. Jika semua sudah sesuai, klik **Save and deploy** untuk melakukan deployment. Proses ini akan memakan waktu beberapa menit. Tunggu hingga status dari Container service menjadi **Running**.

[![Lightsail Configure Deployment](https://raw.githubusercontent.com/rioastamal-examples/assets/main/workshop-amazon-lightsail-containers/lab-laravel-app/images/lightsail-hello-api-configure-deployment.png)](https://raw.githubusercontent.com/rioastamal-examples/assets/main/workshop-amazon-lightsail-containers/lab-laravel-app/images/lightsail-hello-api-configure-deployment.png)

> Gambar 9. Konfigurasi deployment untuk container

Jika status sudah **Running** maka kita dapat mencoba untuk mengakses aplikasi dengan membuka URL yang ada di public domain. Perlu dicatat jika protocol yang digunakan adalah HTTPS. Dalam contoh ini saya menggunakan `curl` untuk melakukan tes. Sesuaikan dengan public domain anda sendiri.

```sh
curl https://YOUR_OWN_CONTAINER_SERVICE_PUBLIC_DOMAIN/ \ 
-d '# Hello World

This text will be converted to **HTML**.

1. Number one
2. Number two
'
```

Hasilnya harusnya sama dengan yang ada step 4.

Selamat! anda telah sukses melakukan deployment sebuah aplikasi Laravel menggunakan Amazon Lightsail Container service. Cukup mudah bukan?

[^back to top](#top)

<!-- end step-8 -->

<!-- begin step-9 -->

### <a name="step-9"></a>Step 9 - Membuat Versi Baru dari API

Setiap aplikasi hampir pasti akan selalu mengalami proses update entah itu untuk perbaikan atau penambahan fitur. Pada workshop ini kita akan coba mendemonstrasikan bagaimana melakukan update dari aplikasi menggunakan Amazon Lightsail Container service.

Dalam contoh ini kita akan ingin agar pengguna dapat mengkonversi Markdown dari web interface. Untuk itu kita ubah file `laravel/resources/views/welcome.blade.php`. Kita juga menampilkan alamat lokal IP dari server.

Ganti konten file tersebut dengan yang di bawah.

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

File berikutnya yang akan kita ganti adalah `routes/web.php`. Ganti isi file tersebut dengan berikut.

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

Jalankan kembali aplikasi kita melalui Docker.

```sh
docker run --rm --name idn_belajar_1_0 -p 8080:80 \
-v $(pwd)/laravel:/var/www/html \
indonesia-belajar:1.0
```

Buka kembali aplikasi di localhost harusnya tampilan sudah berubah. Terdapat textbox untuk mengisi markdown dan tombol **convert**.

[![Versi Terbaru](https://raw.githubusercontent.com/rioastamal-examples/assets/main/workshop-amazon-lightsail-containers/lab-laravel-app/images/lightsail-hello-api-home-v2.png)](https://raw.githubusercontent.com/rioastamal-examples/assets/main/workshop-amazon-lightsail-containers/lab-laravel-app/images/lightsail-hello-api-home-v2.png)

> Gambar 10. Versi terbaru Markdown converter

Sedangkan untuk tetap mengembalikan secara raw atau teks HTML dari markdown saja maka gunakan parameter `output=raw` pada query string.

Salin perintah berikut untuk mencoba.

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

Tekan `CTRL+C` untuk menghentikan container yang berjalan.

[^back to top](#top)

<!-- end step-9 -->

<!-- begin step-10 -->

### <a name="step-10"></a>Step 10 - Update Container Image

API versi terbaru sudah siap, saatnya melakukan update untuk container image `indonesia-belajar`. Kita akan merilis aplikasi versi terbaru ini dengan tag `2.0`. Untuk melakukannya ikuti langkah berikut.

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

Kita lihat apakah container image baru tersebut sudah ada dalam daftar container image pada mesin kita.

```sh
docker images indonesia-belajar
```

```
REPOSITORY          TAG       IMAGE ID       CREATED          SIZE
indonesia-belajar   2.0       952d9875be26   58 seconds ago   478MB
indonesia-belajar   1.0       e76cb9d91076   40 minutes ago   478MB
```

Jalankan container versi baru tersebut untuk memastikan API berjalan sesuai harapan. 

```sh
docker run --rm --name idn_belajar_2_0 \
-p 8080:80 -d indonesia-belajar:2.0
```

```
d8df1a6d0dbd70de4cd36ff21e5b6a766a7bb0c21d28819d37fdff612aefe23c
```

Buka web browser di alamat `localhost:8080` dan lakukan tes konversi markdown.

[^back to top](#top)

<!-- end step-10 -->

<!-- begin step-11 -->

### <a name="step-11"></a>Step 11 - Push Container Image Versi Terbaru

Kita sudah pernah melakukan upload container image `indonesia-belajar:1.0` ke Container service **hello-api**. Karena sudah ada versi terbaru yaitu `indonesia-belajar:2.0` maka kita juga harus melakukan push container image ini ke **hello-api**. Jalankan perintah di bawah ini.

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

Pada kasus milik saya image yang tersimpan di Container service adalah `:hello-api.indonesia-belajar.13`. Nomor versi upload `.13` bisa berbeda dengan milik anda.

Untuk memastikan container telah terupload dengan sukses masuk pada dashboard Container service **hello-api** dan klik menu **Images**. Harusnya image sudah muncul di halaman tersebut.

[![Lightsail Container New Image](https://raw.githubusercontent.com/rioastamal-examples/assets/main/workshop-amazon-lightsail-containers/lab-general-app/images/lightsail-hello-api-new-image.png)](https://raw.githubusercontent.com/rioastamal-examples/assets/main/workshop-amazon-lightsail-containers/lab-general-app/images/lightsail-hello-api-new-image.png)

> Gambar 11. Container image versi terbaru

[^back to top](#top)

<!-- end step-11 -->

<!-- begin step-12 -->

## <a name="step-12"></a>Step 12 - Deploy Versi Terbaru dari API

Setelah container image versi terbaru `indonesia-belajar:2.0` diupload ke Amazon Lightsail Containers maka kita dapat melakukan deployment versi terbaru dari API menggunakan image tersebut.

1. Masuk pada halaman dashboard Contianer service **hello-api** dan pastikan berada pada halaman _Deployments_.
2. Klik tombol **Modify your deployment**, maka akan terbuka halaman konfigurasi yang sama ketika membuat deployment baru.
3. Konfigurasi yang perlu diubah adalah container image yang digunakan. Klik tombol **Choose stored image** kemudian pilih versi terbaru dari container image yang diupload.
4. Sisanya tidak perlu diubah, untuk memulai deployment klik tombol **Save and deploy**.
5. Tunggu beberapa menit hingga status berubah menjadi **Running** kembali.

[![Lightsail Update Deployment](https://raw.githubusercontent.com/rioastamal-examples/assets/main/workshop-amazon-lightsail-containers/lab-general-app/images/lightsail-hello-api-modify-deployment.png)](https://raw.githubusercontent.com/rioastamal-examples/assets/main/workshop-amazon-lightsail-containers/lab-general-app/images/lightsail-hello-api-modify-deployment.png)

> Gambar 12. Deployment versi terbaru dari container

Setelah status kembali menjadi **Running** saatnya mengakses API versi terbaru apakah sudah menampilkan respon yang diinginkan. Gunakan web browser atau `curl` seperti di bawah untuk mengakses. Sesuaikan dengan URL dari container service anda sendiri.

```sh
curl -s 'https://YOUR_OWN_CONTAINER_SERVICE_PUBLIC_DOMAIN/?output=raw' \
-d '# Hello World'
```

```
<h1>Hello World</h1>

--
Local IP Address: 172.17.0.2
```

Keren! API terbaru sudah berhasil dideploy. Output dari API sekarang menyertakan alamat ip lokal di server yang pada versi sebelumnya tidak ada.

[^back to top](#top)

<!-- end step-12 -->

<!-- begin step-13 -->

### <a name="step-13"></a>Step 13 - Menambah Jumlah Node

Ketika anda ingin meningkatkan kemampuan aplikasi dalam merespon _traffic_ salah satu cara yang bisa dilakukan adalah dengan melakukan _vertical scaling_ yaitu menambah kombinasi CPU dan RAM atau _horizontal scaling_ menambah jumlah node. 

Kali ini kita akan melakukan _horizontal scaling_ dengan menambah jumlah node dari 1 menjadi 3.

1. Masuk pada dashboard dari **hello-api** container service.
2. Klik menu **Capacity**
3. Klik tombol **Change capacity** akan muncul dialog konfirmasi. Klik tombol **Yes, continue** untuk melanjutkan.

[![Lightsail Capacity](https://raw.githubusercontent.com/rioastamal-examples/assets/main/workshop-amazon-lightsail-containers/lab-deploy-nodejs-app/images/lightsail-hello-api-capacity-menu.png)](https://raw.githubusercontent.com/rioastamal-examples/assets/main/workshop-amazon-lightsail-containers/lab-deploy-nodejs-app/images/lightsail-hello-api-capacity-menu.png)

> Gambar 13. Halaman capacity pada container service

4. Kita akan tetap menggunakan tipe Nano jadi yang akan kita ubah adalah jumlah node. Pada **Choose the scale** geser slider ke angka **3**. 

[![Lightsail Add Node](https://raw.githubusercontent.com/rioastamal-examples/assets/main/workshop-amazon-lightsail-containers/lab-deploy-nodejs-app/images/lightsail-hello-api-capacity-add-node.png)](https://raw.githubusercontent.com/rioastamal-examples/assets/main/workshop-amazon-lightsail-containers/lab-deploy-nodejs-app/images/lightsail-hello-api-capacity-add-node.png)

> Gambar 14. Menambah jumlah node untuk container service

5. Proses akan memakan waktu beberapa menit, klik **I understand** untuk menutup dialog.
6. Tunggu hingga status dari container service kembali **Running**.

[![Lightsail New Capacity](https://raw.githubusercontent.com/rioastamal-examples/assets/main/workshop-amazon-lightsail-containers/lab-deploy-nodejs-app/images/lightsail-hello-api-new-capacity-applied.png)](https://raw.githubusercontent.com/rioastamal-examples/assets/main/workshop-amazon-lightsail-containers/lab-deploy-nodejs-app/images/lightsail-hello-api-new-capacity-applied.png)

> Gambar 15. Kapasitas jumlah node telah bertambah

Amazon Lightsail akan secara otomatis mendistribusikan _traffic_ ke 3 node yang telah berjalan pada **hello-api** container service. Anda tidak perlu melakukan konfigurasi apapun, sangat memudahkan.

Sekarang kita tes respon dari API dan melihat nilai dari lokal IP yang dikembalikan. Harusnya alamat IP dari setiap request bisa berbeda hasilnya tergantung node mana yang melayani. Lakukan request ke public endpoint dari container beberapa kali dan lihat hasilnya.

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

Dapat terlihat jika alamat IP yang dikembalikan berbeda-beda mengindikasikan bahwa node yang menangani _request_ adalah node yang berbeda. Lakukan beberapa kali jika mendapatkan hasil yang sama.

Okey, sebelum lanjut ke langkah berikutnya kembalikan terlebih dahulu jumlah node dari **3** menjadi **1**. Tentu masih ingat caranya bukan?

[^back to top](#top)

<!-- end step-13 -->

<!-- begin step-14 -->

### <a name="step-14"></a>Step 14 - Rollback API ke Versi Sebelumnya

Kehidupan di dunia tidak selalu indah, benar? Begitu juga proses deployment kadang versi baru yang kita deploy malah tidak berfungsi dan menyebabkan error. Salah satu keuntungan menggunakan deployment berbasis container adalah kita dapat melakukan rollback dengan mudah.

Sebagai contoh kita akan melakukan rollback API kita ke versi sebelumnya. Caranya sangat mudah.

1. Pertama pastikan anda berada pada halaman dashboard dari container service **hello-api**.
2. Pastikan anda berada pada halaman _Deployments_.
3. Scroll bagian bawah yaitu **Deployment versions**. Disana terlihat kita telah melakukan dua kali deployment. Deployment yang terakhir adalah untuk image `indonesia-belajar:2.0`.
4. Klik titik tiga **Version 1** kemudian klik **Modify and redeploy**.

[![Lightsail Rollback Deployment](https://raw.githubusercontent.com/rioastamal-examples/assets/main/workshop-amazon-lightsail-containers/lab-deploy-nodejs-app/images/lightsail-hello-api-rollback-deployment.png)](https://raw.githubusercontent.com/rioastamal-examples/assets/main/workshop-amazon-lightsail-containers/lab-deploy-nodejs-app/images/lightsail-hello-api-rollback-deployment.png)

> Gambar 16. Rollback Deployment ke Versi Sebelumnya

5. Akan muncul dialog konfirmasi untuk melakukan deployment, klik tombol **Yes, continue**.
6. Proses deployment belum dilakukan, ini hanya otomatis nilai konfigurasi _Image_ akan berubah menjadi versi sebelumnya yaitu `:hello-api.indonesia-belajar.12`. Nomor versi upload `.12` bisa berbeda ditempat anda.
7. Klik tombol **Save and deploy** untuk memulai proses rollback deployment dari image sebelumnya.
8. Tunggu hingga status dari container service kembali menjadi **Running**.

Ketika rollback sudah selesai dan status kembali menjadi **Running** maka coba lakukan request ke API untuk melihat apakah respon sesuai dengan versi sebelumnya.

```sh
curl -s 'https://YOUR_OWN_CONTAINER_SERVICE_PUBLIC_DOMAIN/?output=raw' \
-d '# Hello World'
```

```
<h1>Hello World</h1>
```

Dapat terlihat bahwa API kita telah kembali ke versi sebelumnya yaitu `indonesia-belajar:1.0`. Respon tidak mengembalikan lokal IP dari server seperti yang seharusnya ada di versi `indonesia-belajar:2.0`.

Jadi sebenarnya untuk melakukan rollback sesimple anda mengganti versi container image yang akan dijalankan.

Perlu diingat bahwa rollback juga adalah sebuah proses deployment jadi otomatis itu akan menambah daftar pada **Deployment versions**. Seperti yang terlihat pada gambar di bawah, rollback yang kita lakukan menghasilkan deployment versi 3.

[![Lightsail Deployment Versions](https://raw.githubusercontent.com/rioastamal-examples/assets/main/workshop-amazon-lightsail-containers/lab-deploy-nodejs-app/images/lightsail-hello-api-deployment-versions.png)](https://raw.githubusercontent.com/rioastamal-examples/assets/main/workshop-amazon-lightsail-containers/lab-deploy-nodejs-app/images/lightsail-hello-api-deployment-versions.png)

> Gambar 17. Rollback juga menghasilkan versi deployment baru

[^back to top](#top)

<!-- end step-14 -->

<!-- begin step-15 -->

### <a name="step-15"></a>Step 15 - Menghapus Amazon Lightsail Container Service

Jika aplikasi sudah tidak dibutuhkan maka tidak ada alasan untuk menjalankannya. Jika Container Service hanya kita _disabled_ maka kita tetap terkena charge meskipun container dan endpoint tidak dapat diakses. 

Jika sudah tidak diperlukan maka menghapus container adalah cara yang tepat. Ikuti langkah berikut.

1. Kembali ke dashboard Amazon Lightsail
2. Kemudian klik menu **Containers** untuk masuk ke halaman container service.
3. Disana harusnya terdapat container service **hello-api**, klik tombol titik tiga untuk membuka menu kemudian klik pilihan **Delete**.

[![Lightsail Delete Container Service](https://raw.githubusercontent.com/rioastamal-examples/assets/main/workshop-amazon-lightsail-containers/lab-deploy-nodejs-app/images/lightsail-hello-api-delete.png)](https://raw.githubusercontent.com/rioastamal-examples/assets/main/workshop-amazon-lightsail-containers/lab-deploy-nodejs-app/images/lightsail-hello-api-delete.png)

> Gambar 17. Menghapus container service

4. Pada dialog konfirmasi klik tombol **Yes, delete** untuk menghapus container service.
5. Harusnya container service **hello-api** sudah tidak ada dalam daftar.

Perlu dicatat bahwa container image pada Amazon Lightsail terikat pada container service. Jadi menghapus container service juga akan menghapus semua container image yang telah diupload pada container service tersebut. Dalam hal ini, dua container image yang kita upload sebelumnya yaitu `indonesia-belajar:1.0` dan `indonesia-belajar:2.0` juga ikut dihapus.

Sekarang mari kita coba akses kembali URL endpoint container apakah masih bisa merespon atau mengembalikan error.

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

Dapat terlihat bahwa public URL yang sebelumnya digunakan sekarang mengembalikan HTTP error 404. Artinya tidak ada container service yang berjalan.

[^back to top](#top)

---

SELAMAT! Anda telah menyelesaikan workshop deployment Laravel App dengan menggunakan Amazon Lightsail Containers.

Jangan lupa berikan tanda ⭐ untuk repo ini. Sampai bertemu diworkshop selanjutnya.

<!-- end step-15 -->