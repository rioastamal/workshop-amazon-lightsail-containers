
### <a name="step-13"></a>Step 13 - Menambah Jumlah Node

Ketika anda ingin meningkatkan kemampuan aplikasi dalam merespon _traffic_ salah satu cara yang bisa dilakukan adalah dengan melakukan _vertical scaling_ yaitu menambah kombinasi CPU dan RAM atau _horizontal scaling_ menambah jumlah node. 

Kali ini kita akan melakukan _horizontal scaling_ dengan menambah jumlah node dari 1 menjadi 3.

1. Masuk pada dashboard dari **hello-api** container service.
2. Klik menu **Capacity**
3. Klik tombol **Change capacity** akan muncul dialog konfirmasi. Klik tombol **Yes, continue** untuk melanjutkan.

[![Lightsail Capacity](https://raw.githubusercontent.com/rioastamal-examples/assets/main/workshop-amazon-lightsail-containers/lab-deploy-nodejs-app/images/lightsail-hello-api-capacity-menu.png)](https://raw.githubusercontent.com/rioastamal-examples/assets/main/workshop-amazon-lightsail-containers/lab-deploy-nodejs-app/images/lightsail-hello-api-capacity-menu.png)

> Gambar 12. Halaman capacity pada container service

4. Kita akan tetap menggunakan tipe Nano jadi yang akan kita ubah adalah jumlah node. Pada **Choose the scale** geser slider ke angka **3**. 

[![Lightsail Add Node](https://raw.githubusercontent.com/rioastamal-examples/assets/main/workshop-amazon-lightsail-containers/lab-deploy-nodejs-app/images/lightsail-hello-api-capacity-add-node.png)](https://raw.githubusercontent.com/rioastamal-examples/assets/main/workshop-amazon-lightsail-containers/lab-deploy-nodejs-app/images/lightsail-hello-api-capacity-add-node.png)

> Gambar 13. Menambah jumlah node untuk container service

5. Proses akan memakan waktu beberapa menit, klik **I understand** untuk menutup dialog.
6. Tunggu hingga status dari container service kembali **Running**.

[![Lightsail New Capacity](https://raw.githubusercontent.com/rioastamal-examples/assets/main/workshop-amazon-lightsail-containers/lab-deploy-nodejs-app/images/lightsail-hello-api-new-capacity-applied.png)](https://raw.githubusercontent.com/rioastamal-examples/assets/main/workshop-amazon-lightsail-containers/lab-deploy-nodejs-app/images/lightsail-hello-api-new-capacity-applied.png)

> Gambar 14. Kapasitas jumlah node telah bertambah

Amazon Lightsail akan secara otomatis mendistribusikan _traffic_ ke 3 node yang telah berjalan pada **hello-api** container service. Anda tidak perlu melakukan konfigurasi apapun, sangat memudahkan.

Sekarang kita tes respon dari API terutama pada atribut `network.eth1`, harusnya alamat IP dari setiap request bisa berbeda hasilnya tergantung node mana yang melayani. Lakukan request ke public endpoint dari container beberapa kali dan lihat hasilnya.

```sh
curl -s https://YOUR_OWN_CONTAINER_SERVICE_PUBLIC_DOMAIN/ | jq '.network.eth1[0]'
```

```json
{
  "address": "172.26.16.104",
  "netmask": "255.255.240.0",
  "family": "IPv4",
  "mac": "06:3d:94:bd:f3:82",
  "internal": false,
  "cidr": "172.26.16.104/20"
}
```

```sh
curl -s https://YOUR_OWN_CONTAINER_SERVICE_PUBLIC_DOMAIN/ | jq '.network.eth1[0]'
```

```json
{
  "address": "172.26.40.212",
  "netmask": "255.255.240.0",
  "family": "IPv4",
  "mac": "0a:2f:30:f6:15:ca",
  "internal": false,
  "cidr": "172.26.40.212/20"
}
```

```sh
curl -s https://YOUR_OWN_CONTAINER_SERVICE_PUBLIC_DOMAIN/ | jq '.network.eth1[0]'
```

```json
{
  "address": "172.26.13.18",
  "netmask": "255.255.240.0",
  "family": "IPv4",
  "mac": "02:5d:98:ca:df:e6",
  "internal": false,
  "cidr": "172.26.13.18/20"
}
```

Dapat terlihat jika alamat IP yang dikembalikan berbeda-beda mengindikasikan bahwa node yang menangani _request_ adalah node yang berbeda. Lakukan beberapa kali jika mendapatkan hasil yang sama.

Okey, sebelum lanjut ke langkah berikutnya kembalikan terlebih dahulu jumlah node dari **3** menjadi **1**. Tentu masih ingat caranya bukan?


<table border="0" style="width: 100%; display: table;"><tr><td><a href="STEP-12.md">&laquo; Sebelumnya</td><td align="center"><a href="README.md">Daftar Isi</a></td><td align="right"><a href="STEP-14.md">Berikutnya &raquo;</a></td></tr></table>

<sup>Workshop: Deploy Node.js App dengan Amazon Lightsail Containers  
Version: 2022-05-12  
Author: [@rioastamal](https://github.com/rioastamal)</sup>
