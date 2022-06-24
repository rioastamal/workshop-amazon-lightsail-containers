
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


<table border="0" style="width: 100%; display: table;"><tr><td><a href="STEP-7.md">&laquo; Sebelumnya</td><td align="center"><a href="README.md">Daftar Isi</a></td><td align="right"><a href="STEP-9.md">Berikutnya &raquo;</a></td></tr></table>

<sup>Workshop: Deploy Python Flask dengan Amazon Lightsail Containers  
Version: 2022-24-06  
Author: [@rioastamal](https://github.com/rioastamal)</sup>
