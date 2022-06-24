
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


<table border="0" style="width: 100%; display: table;"><tr><td><a href="STEP-5.md">&laquo; Sebelumnya</td><td align="center"><a href="README.md">Daftar Isi</a></td><td align="right"><a href="STEP-7.md">Berikutnya &raquo;</a></td></tr></table>

<sup>Workshop: Deploy Python Flask dengan Amazon Lightsail Containers  
Version: 2022-24-06  
Author: [@rioastamal](https://github.com/rioastamal)</sup>
