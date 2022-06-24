
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


<table border="0" style="width: 100%; display: table;"><tr><td><a href="STEP-11.md">&laquo; Sebelumnya</td><td align="center"><a href="README.md">Daftar Isi</a></td><td align="right"><a href="STEP-13.md">Berikutnya &raquo;</a></td></tr></table>

<sup>Workshop: Deploy Python Flask dengan Amazon Lightsail Containers  
Version: 2022-24-06  
Author: [@rioastamal](https://github.com/rioastamal)</sup>
