
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


<table border="0" style="width: 100%; display: table;"><tr><td><a href="STEP-10.md">&laquo; Sebelumnya</td><td align="center"><a href="README.md">Daftar Isi</a></td><td align="right"><a href="STEP-12.md">Berikutnya &raquo;</a></td></tr></table>

<sup>Workshop: Deploy Laravel App dengan Amazon Lightsail Containers
Version: 2022-24-06  
Author: [@rioastamal](https://github.com/rioastamal)</sup>
