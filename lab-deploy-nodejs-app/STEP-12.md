
## <a name="step-12"></a>Step 12 - Deploy Versi Terbaru dari API

Setelah container image versi terbaru `idn-belajar-node:2.0` diupload ke Amazon Lightsail Containers maka kita dapat melakukan deployment versi terbaru dari API menggunakan image tersebut.

1. Masuk pada halaman dashboard Contianer service **hello-api** dan pastikan berada pada halaman _Deployments_.
2. Klik tombol **Modify your deployment**, maka akan terbuka halaman konfigurasi yang sama ketika membuat deployment baru.
3. Konfigurasi yang perlu diubah adalah container image yang digunakan. Klik tombol **Choose stored image** kemudian pilih versi terbaru dari container image yang diupload.
4. Sisanya tidak perlu diubah, untuk memulai deployment klik tombol **Save and deploy**.
5. Tunggu beberapa menit hidda status berubah menjadi **Running** kembali.

[![Lightsail Update Deployment](https://raw.githubusercontent.com/rioastamal-examples/assets/main/workshop-amazon-lightsail-containers/lab-deploy-nodejs-app/images/lightsail-hello-api-modify-deployment.png)](https://raw.githubusercontent.com/rioastamal-examples/assets/main/workshop-amazon-lightsail-containers/lab-deploy-nodejs-app/images/lightsail-hello-api-modify-deployment.png)

> Gambar 11. Deployment versi terbaru dari container

Setelah status kembali menjadi **Running** saatnya mengakses API versi terbaru apakah sudah menampilkan respon yang diinginkan. Gunakan web browser atau `curl` seperti di bawah untuk mengakses. Sesuaikan dengan URL dari container service anda sendiri.

```sh
$ curl -s https://hello-api.ihcvtn9gpds60.ap-southeast-1.cs.amazonlightsail.com/
```

```json
{
  "hello": "Indonesia Belajar!",
  "network": {
    "eth0": [
      {
        "address": "169.254.172.2",
        "netmask": "255.255.252.0",
        "family": "IPv4",
        "mac": "0a:58:a9:fe:ac:02",
        "internal": false,
        "cidr": "169.254.172.2/22"
      },
      {
        "address": "fe80::c016:75ff:fe78:8827",
        "netmask": "ffff:ffff:ffff:ffff::",
        "family": "IPv6",
        "mac": "0a:58:a9:fe:ac:02",
        "internal": false,
        "cidr": "fe80::c016:75ff:fe78:8827/64",
        "scopeid": 3
      }
    ],
    "eth1": [
      {
        "address": "172.26.0.67",
        "netmask": "255.255.240.0",
        "family": "IPv4",
        "mac": "02:f4:1a:f9:96:ac",
        "internal": false,
        "cidr": "172.26.0.67/20"
      },
      {
        "address": "2406:da18:f4f:e00:971b:f340:5454:794c",
        "netmask": "ffff:ffff:ffff:ffff::",
        "family": "IPv6",
        "mac": "02:f4:1a:f9:96:ac",
        "internal": false,
        "cidr": "2406:da18:f4f:e00:971b:f340:5454:794c/64",
        "scopeid": 0
      },
      {
        "address": "fe80::f4:1aff:fef9:96ac",
        "netmask": "ffff:ffff:ffff:ffff::",
        "family": "IPv6",
        "mac": "02:f4:1a:f9:96:ac",
        "internal": false,
        "cidr": "fe80::f4:1aff:fef9:96ac/64",
        "scopeid": 4
      }
    ]
  }
}
```

Keren! API terbaru sudah berhasil dideploy. Output dari API sekarang menyertakan atribut `network` yang pada versi sebelumnya tidak ada.


<table border="0" style="width: 100%; display: table;"><tr><td><a href="STEP-11.md">&laquo; Sebelumnya</td><td align="center"><a href="README.md">Daftar Isi</a></td><td align="right"><a href="STEP-13.md">Berikutnya &raquo;</a></td></tr></table>

<sup>Workshop: Deploy Node.js App dengan Amazon Lightsail Containers  
Version: 2022-05-12  
Author: [@rioastamal](https://github.com/rioastamal)</sup>
