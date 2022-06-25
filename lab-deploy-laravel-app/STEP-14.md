
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


<table border="0" style="width: 100%; display: table;"><tr><td><a href="STEP-13.md">&laquo; Sebelumnya</td><td align="center"><a href="README.md">Daftar Isi</a></td><td align="right"><a href="STEP-15.md">Berikutnya &raquo;</a></td></tr></table>

<sup>Workshop: Deploy Laravel App dengan Amazon Lightsail Containers
Version: 2022-24-06  
Author: [@rioastamal](https://github.com/rioastamal)</sup>
