
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


<table border="0" style="width: 100%; display: table;"><tr><td><a href="STEP-4.md">&laquo; Sebelumnya</td><td align="center"><a href="README.md">Daftar Isi</a></td><td align="right"><a href="STEP-6.md">Berikutnya &raquo;</a></td></tr></table>

<sup>Workshop: Deploy Laravel App dengan Amazon Lightsail Containers
Version: 2022-24-06  
Author: [@rioastamal](https://github.com/rioastamal)</sup>
