
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


<table border="0" style="width: 100%; display: table;"><tr><td><a href="STEP-4.md">&laquo; Sebelumnya</td><td align="center"><a href="README.md">Daftar Isi</a></td><td align="right"><a href="STEP-6.md">Berikutnya &raquo;</a></td></tr></table>

<sup>Workshop: Deploy Laravel App dengan Amazon Lightsail Containers  
Version: 2022-24-06  
Author: [@rioastamal](https://github.com/rioastamal)</sup>
