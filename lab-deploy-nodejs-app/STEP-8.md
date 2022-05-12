
### <a name="step-8"></a>Step 8 - Deploy Container

Proses ini digunakan untuk menempatkan container yang akan dijalankan ke Container service yang telah tersedia. Pada contoh ini kita telah membuat sebuah Container service dengan nama **hello-api** dengan kapasitas 512MB RAM dan 0.25 vCPU dan hanya berjumlah 1.

1. Pada halaman dashboard **hello-api** klik menu **Deployments** kemudian klik link **Create your first deployment**.

[![https://raw.githubusercontent.com/rioastamal-examples/assets/main/workshop-amazon-lightsail-containers/lab-deploy-nodejs-app/images/lightsail-hello-api-deployments-menu.png](https://raw.githubusercontent.com/rioastamal-examples/assets/main/workshop-amazon-lightsail-containers/lab-deploy-nodejs-app/images/lightsail-hello-api-deployments-menu.png)](https://raw.githubusercontent.com/rioastamal-examples/assets/main/workshop-amazon-lightsail-containers/lab-deploy-nodejs-app/images/lightsail-hello-api-deployments-menu.png)

> Gambar 8. Membuka halaman deployment

2. Terdapat beberapa isian yang harus dilengkapi. Pertama isikan **hello-idn-belajar** untuk _Container name_. 
3. Pada pilihan _Image_ klik **Choose stored image** untuk memilih container image yang sudah diupload sebelumnya. Pilih versi container image yang telah diupload.
4. Aplikasi yang dibuat hanya menggunakan satu environment variable yaitu `APP_PORT`. Environment variable ini menentukan nomor port dimana aplikasi berjalan. Dengan default port `8080`. Kendati opsional pada contoh ini kita tetap mengisikan `APP_PORT` dengan nilai `8080`.
5. Pada konfigurasi **Open ports** gunakan nomor port dimana aplikasi berjalan. Dalam hal ini sama dengan nilai dari `APP_PORT` yaitu `8080`. 
6. Untuk **PUBLIC ENDPOINT** gunakan container **idn-hello-belajar** yang telah diinput pada bagian sebelumnya. Container service yang berjalan pada public domain akan melakukan koneksi pada `8080` yang dikonfigurasi pada **Open ports**.
7. Jika semua sudah sesuai, klik **Save and deploy** untuk melakukan deployment. Proses ini akan memakan waktu beberapa menit. Tunggu hingga status dari Container service menjadi **Running**.

[![Lightsail Create Deployment](https://raw.githubusercontent.com/rioastamal-examples/assets/main/workshop-amazon-lightsail-containers/lab-deploy-nodejs-app/images/lightsail-hello-api-create-deployment.png)](https://raw.githubusercontent.com/rioastamal-examples/assets/main/workshop-amazon-lightsail-containers/lab-deploy-nodejs-app/images/lightsail-hello-api-create-deployment.png)

> Gambar 9. Konfigurasi deployment untuk container

Jika status sudah **Running** maka kita dapat mencoba untuk mengakses aplikasi dengan membuka URL yang ada di public domain. Perlu dicatat jika protocol yang digunakan adalah HTTPS. Dalam contoh ini saya menggunakan `curl` untuk melakukan tes. Sesuaikan dengan public domain anda sendiri.

```sh
$ curl -s https://hello-api.ihcvtn9gpds60.ap-southeast-1.cs.amazonlightsail.com/
```

```json
{
  "hello": "Indonesia Belajar!"
}
```

Selamat! anda telah sukses melakukan deployment sebuah aplikasi Node.js menggunakan Amazon Lightsail Container service. Cukup mudah bukan?


<table border="0" style="width: 100%; display: table;"><tr><td><a href="STEP-7.md">&laquo; Sebelumnya</td><td align="center"><a href="README.md">Daftar Isi</a></td><td align="right"><a href="STEP-9.md">Berikutnya &raquo;</a></td></tr></table>
<p class="line" style="font-size: small;">
  <span style="display:block">Workshop: Deploy Node.js App dengan Amazon Lightsail Containers</span>
  <span style="display:block">Version: 2022-05-12</span>
  <span style="display:block">Author: <a href="https://github.com/rioastamal">@rioastamal</a></span>
</p>
