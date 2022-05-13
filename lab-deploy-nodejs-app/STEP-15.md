
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

Perlu dicatat bahwa container image pada Amazon Lightsail terikat pada container service. Jadi menghapus container service juga akan menghapus semua container image yang telah diupload pada container service tersebut. Dalam hal ini, dua container image yang kita upload sebelumnya yaitu `idn-belajar-node:1.0` dan `idn-belajar-node:2.0` juga ikut dihapus.

Sekarang mari kita coba akses kembali URL endpoint container apakah masih bisa merespon atau mengembalikan error.

```sh
curl -s https://hello-api.ihcvtn9gpds60.ap-southeast-1.cs.amazonlightsail.com/
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


---

SELAMAT! Anda telah menyelesaikan workshop deployment Node.js dengan menggunakan Amazon Lightsail Containers.

Jangan lupa berikan tanda ⭐ untuk repo ini. Sampai bertemu diworkshop selanjutnya.

<table border="0" style="width: 100%; display: table;"><tr><td><a href="STEP-14.md">&laquo; Sebelumnya</td><td align="center"><a href="README.md">Daftar Isi</a></td><td align="right"><a href="README.md">Berikutnya &raquo;</a></td></tr></table>

<sup>Workshop: Deploy Node.js App dengan Amazon Lightsail Containers  
Version: 2022-05-12  
Author: [@rioastamal](https://github.com/rioastamal)</sup>
