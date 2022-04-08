## Workshop Deploy Node.js App dengan Amazon Lightsail Containers
<a name="top"></a>
Short intro - the why - TBD.

- [Step 0 - Kebutuhan](#step-0)
- [Step 1 - Menginstal Lightsail Control Plugin](#step-1)
- [Step 2 - Membuat Direktori untuk Project](#step-2)
- [Step 3 - Membuat Node.js API](#step-3)
- [Step 4 - Membuat Container Image](#step-4)
- [Step 5 - Membuat Container Service di Amazon Lightsail](#step-5)
- [Step 6 - Push Container Image ke Amazon Lightsail](#step-6)
- [Step 7 - Deploy Container](#step-7)
- [Step 8 - Membuat Versi Baru dari API](#step-8)
- [Step 9 - Update Container Image](#step-9)
- [Step 10 - Push Container Image Versi Terbaru](#step-10)
- [Step 11 - Deploy Versi Terbaru dari API](#step-11)
- [Step 12 - Menambah Jumlah Node](#step-12)
- [Step 13 - Rollback API ke Versi Sebelumnya](#step-13)
- [Step 14 - Menghapus Amazon Lightsail Container Service](#step-14)

### <a name="step-0"></a>Step 0 - Kebutuhan

Sebelum memulai workshop pastikan sudah memenuhi kebutuhan yang tercantum di bawah ini.

- Memiliki akun AWS aktif
- Sudah menginstal Docker
- Sudah menginstal AWS CLI v2 dan konfigurasinya

[^back to top](#top)

### <a name="step-1"></a>Step 1 - Menginstal Lightsail Control Plugin

Plugin CLI ini digunakan untuk mengupload container image dari komputer lokal ke Amazon Lightsail container service. Jalankan perintah berikut untuk menginstal Lightsail Control Plugin. Diasumsikan bahwa terdapat perintah `sudo` pada distribusi Linux yang anda gunakan.

```sh
$ sudo curl "https://s3.us-west-2.amazonaws.com/lightsailctl/latest/linux-amd64/lightsailctl" -o "/usr/local/bin/lightsailctl"
```

Tambahkan atribut _execute_ pada file `lightsailctl` yang baru saja didownload.

```sh
$ sudo chmod +x /usr/local/bin/lightsailctl
```

[^back to top](#top)

### <a name="step-2"></a>Step 2 - Membuat Direktori untuk Project

Pastikan anda sedang berada pada `$HOME` direktori yaitu `/home/ec2-user`.

```sh
$ cd ~
$ pwd 
/home/ec2-user/
```

Kemudian buat sebuah direktori baru bernama `nodejs-app`.

```sh
$ mkdir nodejs-app
```

Masuk pada direktori tersebut. Kita akan menempatkan file-file yang diperlukan disana.

```sh
$ cd nodejs-app
$ pwd
/home/ec2-user/nodejs-app
```

[^back to top](#top)

### <a name="step-3"></a>Step 3 - Membuat Node.js API

Pada langkah ini kita akan membuat sebuah API sederhana yang dibangun menggunakan framework Node.js yang populer yaitu Express.

```sh
$ npm install --save express
```

Selanjutnya buat sebuah direktori baru bernama `src/` untuk menempatkan kode sumber.

```sh
$ mkdir src/
```

Buat sebuah file `src/index.js`, ini adalah file utama dimana kode API yang akan kita buat.

```sh
$ touch src/index.js
```

Salin kode di bawah ini dan masukkan ke dalam file `src/index.js`.

```js
const express = require('express');
const app = express();
const port = process.env.APP_PORT || 8080;

app.set('json spaces', 2);
app.get('/', function mainRoute(req, res) {
  const mainResponse = {
    "hello": "Indonesia Belajar!"
  };
  
  res.json(mainResponse);
});

app.listen(port, function() {
  console.log(`API server running on port ${port}`);
});
```

Kode diatas akan menjalankan sebuah HTTP server pada port `8080` secara default. Ketika path `/` diakses maka akan mengembalikan sebuah JSON dengan format sebagai berikut.

```json
{
  "hello": "Indonesia Belajar!"
}
```

Sekarang coba jalankan kode tersebut untuk memastikan bahwa API berjalan sesuai harapan.

```
$ node src/index.js
```

```
API server running on port 8080
```

Tes dengan melakukan HTTP request pada localhost port `8080`.

```sh
$ curl -s -D /dev/stdout http://localhost:8080
```

```
HTTP/1.1 200 OK
X-Powered-By: Express
Content-Type: application/json; charset=utf-8
Content-Length: 35
ETag: W/"23-73aYo86Xbum4YcZxsMv0wFJ4BiY"
Date: Tue, 05 Apr 2022 07:58:08 GMT
Connection: keep-alive
Keep-Alive: timeout=5

{
  "hello": "Indonesia Belajar!"
}
```

Keren. API kita sudah bisa berjalan sesuai harapan. Saatnya memaket menjadi container image.

[^back to top](#top)

### <a name="step-4"></a>Step 4 - Membuat Container Image

Untuk membuat container image dari layanan API yang baru dibuat kita akan menggunakan Docker.

Buat sebuah file baru dengan nama `Dockerfile`. File ini akan berisi perintah-perintah dalam membangun container image. Letakkan file ini di dalam root direktori project yaitu `nodejs-app/`.

```sh
$ touch Dockerfile
```

Salin kode dibawah ini dan masukkan ke dalam file `Dockerfile`.

```dockerfile
FROM public.ecr.aws/docker/library/node:16-slim

RUN mkdir -p /opt/app
COPY package.json package-lock.json /opt/app/
COPY src/index.js /opt/app/src/

WORKDIR /opt/app
RUN npm install --production

ENTRYPOINT ["node", "src/index.js"]
```

Pada kode di atas, kita menggunakan Node.js versi 16 yang diambil dari Amazon ECR public repository. Kemudian menyalin file-file yang diperlukan ke dalam container dan menjalankan `npm install` untuk mendapatkan semua ketergantungan pustaka yang ada di `package-lock.json`.

Kita akan menamakan container image ini dengan nama `idn-belajar-node` dengan versi `1.0`. Untuk mulai membangun container image jalankan perintah berikut. Perhatikan ada `.` titik diakhir perintah.

```sh
$ docker build --rm -t idn-belajar-node:1.0 .
```

```
...[CUT]...
Step 7/7 : ENTRYPOINT ["node", "src/index.js"]
 ---> Running in 8cd887da4164
Removing intermediate container 8cd887da4164
 ---> 6c88b5d7ef4a
Successfully built 6c88b5d7ef4a
Successfully tagged idn-belajar-node:1.0
```

Pastikan image tersebut ada dalam daftar image di lokal mesin.

```sh
$ docker images idn-belajar-node
```

```
REPOSITORY         TAG       IMAGE ID       CREATED             SIZE
idn-belajar-node   1.0       6c88b5d7ef4a   3 minutes ago       179MB
```

Dapat terlihat jika container image yang dibuat yaitu `idn-belajar-node` dengan versi `1.0` berhasil dibuat.

Sekarang coba jalankan container `idn-belajar-node:1.0` pada port `8080` untuk memastikan API yang dibuat dapat berjalan pada container.

```sh
$ docker run --rm --name idn_belajar_1_0 -p 8080:8080 -d idn-belajar-node:1.0
```

```
ec43c5f4ab04b920df9907bf981d3b7b0dd2c287d8599e1b7768e290694b8f16
```

Kemudian cek untuk memastikan container `idn-belajar-node:1.0` sedang berjalan.

```sh
$ docker ps
```

```
CONTAINER ID   IMAGE                  COMMAND               CREATED          STATUS          PORTS                                       NAMES
ec43c5f4ab04   idn-belajar-node:1.0   "node src/index.js"   24 seconds ago   Up 22 seconds   0.0.0.0:8080->8080/tcp, :::8080->8080/tcp   idn_belajar_1_0
```

Jalankan `curl` untuk melakukan HTTP request ke localhost port `8080` dan path `/`.

```sh
$ curl -s http://localhost:8080/
```

```json
{
  "hello": "Indonesia Belajar!"
}
```

Mantab! API dapat berjalan dengan sempurna di container. Sekarang stop container tersebut.

```sh
$ docker stop idn_belajar_1_0
```

[^back to top](#top)

### <a name="step-5"></a>Step 5 - Membuat Container Service di Amazon Lightsail

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

[![https://raw.githubusercontent.com/rioastamal-examples/assets/main/workshop-amazon-lightsail-containers/lab-deploy-nodejs-app/images/lightsail-404-hello-api.png](https://raw.githubusercontent.com/rioastamal-examples/assets/main/workshop-amazon-lightsail-containers/lab-deploy-nodejs-app/images/lightsail-404-hello-api.png)](https://raw.githubusercontent.com/rioastamal-examples/assets/main/workshop-amazon-lightsail-containers/lab-deploy-nodejs-app/images/lightsail-404-hello-api.png)

> Gambar 6. Layanan hello-api masih 404 karena belum ada container image yang dideploy

[^back to top](#top)

### <a name="step-6"></a>Step 6 - Push Container Image ke Amazon Lightsail

Setiap container image yang di-push ke Amazon Lightsail terikat pada sebuah Container service. Karena itulah kita membuat **hello-api** Container service terlebih dahulu sebelum melakukan push container image.

Pada langkah ini kita akan melakukan push container image `idn-belajar-node:1.0` yang telah dibuat sebelumnya ke Container service **hello-api**. Jalankan perintah dibawah ini.

```sh
$ aws lightsail push-container-image \
--region "ap-southeast-1" \
--service-name "hello-api" \
--label "idn-belajar-node" \
--image "idn-belajar-node:1.0"
```

```
...[CUT]...
c1065d45b872: Pushed 
Digest: sha256:236b7239c44e16ac44a94b92350b3e409ca7631c9663b5242f8a2d2175603417
Image "idn-belajar-node:1.0" registered.
Refer to this image as ":hello-api.idn-belajar-node.2" in deployments.
```

Jika berhasil maka anda akan mendapatkan pesan mirip seperti diatas. Container image akan disimpan dengan penamaan `:<container-service>:<label>.<versi-upload>` pada contoh diatas penamaannya adalah `:hello-api.idn-belajar.2`.

Sekarang pastikan container image tersebut ada dalam daftar container yang telah diupload. Masuk ke halaman dashboard dari container service **hello api** kemudian masuk ke halaman **Images**.

[![Lightsail hello-api Image](https://raw.githubusercontent.com/rioastamal-examples/assets/main/workshop-amazon-lightsail-containers/lab-deploy-nodejs-app/images/lightsail-hello-api-image.png)](https://raw.githubusercontent.com/rioastamal-examples/assets/main/workshop-amazon-lightsail-containers/lab-deploy-nodejs-app/images/lightsail-hello-api-image.png)

> Gambar 7. Daftar container image yang telah diupload

Pada halaman _Images_ dapat terlihat jika terdapat sebuah image `:hello-api.idn-belajar.2` seperti yang telah diupload pada proses sebelumnya. Kita akan menggunakan image ini untuk melakukan deployment.

[^back to top](#top)

### <a name="step-7"></a>Step 7 - Deploy Container

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

[^back to top](#top)

### <a name="step-8"></a>Step 8 - Membuat Versi Baru dari API

Setiap aplikasi hampir pasti akan selalu mengalami proses update entah itu untuk perbaikan atau penambahan fitur. Pada workshop ini kita akan coba mendemonstrasikan bagaimana melakukan update dari aplikasi menggunakan Amazon Lightsail Container service.

Namun sebelumnya kita akan mengubah kode dari API yang dibuat dengan menambahkan fitur untuk menampilkan informasi jaringan dari container.

Pastikan anda berada pada direktori `nodejs-app`. Kemudian ubah isi dari file `src/index.js` menjadi seperti di bawah.

```js
const express = require('express');
const app = express();
const port = process.env.APP_PORT || 8080;
const { networkInterfaces } = require('os');

app.set('json spaces', 2);
app.get('/', function mainRoute(req, res) {
  const network = networkInterfaces();
  delete network['lo']; // remove loopback interface
  
  const mainResponse = {
    "hello": "Indonesia Belajar!",
    "network": network
  };
  
  res.json(mainResponse);
});

app.listen(port, function() {
  console.log(`API server running on port ${port}`);
});
```

Terlihat kita menambahkan respon atribut baru yaitu `network`. Untuk mencobanya jalankan API server tersebut.

```sh
$ node src/index.js
```

```
API server running on port 8080
```

Kemudian lakukan HTTP request ke path `/` untuk melihat respon terbaru.

```sh
$ curl -s http://localhost:8080/
```

```json
{
  "hello": "Indonesia Belajar!",
  "network": {
    "eth0": [
      {
        "address": "172.31.29.226",
        "netmask": "255.255.240.0",
        "family": "IPv4",
        "mac": "02:08:fa:7e:c3:c6",
        "internal": false,
        "cidr": "172.31.29.226/20"
      },
      {
        "address": "fe80::8:faff:fe7e:c3c6",
        "netmask": "ffff:ffff:ffff:ffff::",
        "family": "IPv6",
      
        "mac": "02:08:fa:7e:c3:c6",
        "internal": false,
        "cidr": "fe80::8:faff:fe7e:c3c6/64",
        "scopeid": 2
      }
    ]
  }
}
```

Dapat terlihat informasi jaringan dari container ditampilkan pada atribut `network`.

[^back to top](#top)

### <a name="step-9"></a>Step 9 - Update Container Image

API versi terbaru sudah siap, saatnya melakukan update untuk container image `idn-belajar-node`. Kita akan merilis API versi terbaru ini dengan tag `2.0`. Untuk melakukannya ikuti langkah berikut.

```sh
$ docker build --rm -t idn-belajar-node:2.0 .
```

```
...[CUT]...
Step 7/7 : ENTRYPOINT ["node", "src/index.js"]
 ---> Running in f1245cc03183
Removing intermediate container f1245cc03183
 ---> c83f20a98c54
Successfully built c83f20a98c54
Successfully tagged idn-belajar-node:2.0
```

Kita lihat apakah container image baru tersebut sudah ada dalam daftar container image pada mesin kita.

```sh
$ docker images idn-belajar-node
```

```
REPOSITORY         TAG       IMAGE ID       CREATED          SIZE
idn-belajar-node   2.0       c83f20a98c54   22 minutes ago   179MB
idn-belajar-node   1.0       6c88b5d7ef4a   2 days ago       179MB
```

Jalankan container versi baru tersebut untuk memastikan API berjalan sesuai harapan. 

```sh
$ docker run --rm --name idn_belajar_2_0 -p 8080:8080 -d idn-belajar-node:2.0
```

```
d8df1a6d0dbd70de4cd36ff21e5b6a766a7bb0c21d28819d37fdff612aefe23c
```

Lakukan HTTP request ke `localhost:8080` untuk melakukan tes respon dari API.

```sh
$ curl -s http://localhost:8080/
```

```json
{
  "hello": "Indonesia Belajar!",
  "network": {
    "eth0": [
      {
        "address": "172.17.0.2",
        "netmask": "255.255.0.0",
        "family": "IPv4",
        "mac": "02:42:ac:11:00:02",
        "internal": false,
        "cidr": "172.17.0.2/16"
      }
    ]
  }
}
```

Dapat terlihat jika respon dari API telah memiliki atribut `network`. Hasilnya berbeda dengan yang non-container karena memang perangkat network yang ada dalam container berbeda dengan host.

[^back to top](#top)

### <a name="step-10"></a>Step 10 - Push Container Image Versi Terbaru

Kita sudah pernah melakukan upload container image `idn-belajar-node:1.0` ke Container service **hello-api**. Karena sudah ada versi terbaru yaitu `idn-belajar-node:2.0` maka kita juga harus melakukan push container image ini ke **hello-api**. Jalankan perintah di bawah ini.

```sh
$ aws lightsail push-container-image \
--region "ap-southeast-1" \
--service-name "hello-api" \
--label "idn-belajar-node" \
--image "idn-belajar-node:2.0"
```

```
...[CUT]...
5dd85641fdcb: Layer already exists 
c1065d45b872: Layer already exists 
Digest: sha256:84be0f3b648170b62551abbadbafda1234c1e6362470ecf0b94b3f767d067976
Image "idn-belajar-node:2.0" registered.
Refer to this image as ":hello-api.idn-belajar-node.4" in deployments.
```

Pada kasus milik saya image yang tersimpan di Container service adalah `:hello-api.idn-belajar-node.4`. Nomor versi upload `.4` bisa berbeda dengan milik anda.

Untuk memastikan container telah terupload dengan sukses masuk pada dashboard Container service **hello-api** dan klik menu **Images**. Harusnya image sudah muncul di halaman tersebut.

[![Lightsail Container New Image](https://raw.githubusercontent.com/rioastamal-examples/assets/main/workshop-amazon-lightsail-containers/lab-deploy-nodejs-app/images/lightsail-hello-api-new-image.png)](https://raw.githubusercontent.com/rioastamal-examples/assets/main/workshop-amazon-lightsail-containers/lab-deploy-nodejs-app/images/lightsail-hello-api-new-image.png)

> Gambar 10. Container image versi terbaru 2.0

[^back to top](#top)

## <a name="step-11"></a>Step 11 - Deploy Versi Terbaru dari API

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

[^back to top](#top)

### <a name="step-12"></a>Step 12 - Menambah Jumlah Node

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
$ curl -s https://hello-api.ihcvtn9gpds60.ap-southeast-1.cs.amazonlightsail.com/ | jq '.network.eth1[0]'
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
$ curl -s https://hello-api.ihcvtn9gpds60.ap-southeast-1.cs.amazonlightsail.com/ | jq '.network.eth1[0]'
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
$ curl -s https://hello-api.ihcvtn9gpds60.ap-southeast-1.cs.amazonlightsail.com/ | jq '.network.eth1[0]'
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

[^back to top](#top)

### <a name="step-13"></a>Step 13 - Rollback API ke Versi Sebelumnya

Kehidupan di dunia tidak selalu indah, benar? Begitu juga proses deployment kadang versi baru yang kita deploy malah tidak berfungsi dan menyebabkan error. Salah satu keuntungan menggunakan deployment berbasis container adalah kita dapat melakukan rollback dengan mudah.

Sebagai contoh kita akan melakukan rollback API kita ke versi sebelumnya. Caranya sangat mudah.

1. Pertama pastikan anda berada pada halaman dashboard dari container service **hello-api**.
2. Pastikan anda berada pada halaman _Deployments_.
3. Scroll bagian bawah yaitu **Deployment versions**. Disana terlihat kita telah melakukan dua kali deployment. Deployment yang terakhir adalah untuk image `idn-belajar-node:2.0`.
4. Klik titik tiga **Version 1** kemudian klik **Modify and redeploy**.

[![Lightsail Rollback Deployment](https://raw.githubusercontent.com/rioastamal-examples/assets/main/workshop-amazon-lightsail-containers/lab-deploy-nodejs-app/images/lightsail-hello-api-rollback-deployment.png)](https://raw.githubusercontent.com/rioastamal-examples/assets/main/workshop-amazon-lightsail-containers/lab-deploy-nodejs-app/images/lightsail-hello-api-rollback-deployment.png)

> Gambar 15. Rollback Deployment ke Versi Sebelumnya

5. Akan muncul dialog konfirmasi untuk melakukan deployment, klik tombol **Yes, continue**.
6. Proses deployment belum dilakukan, ini hanya otomatis nilai konfigurasi _Image_ akan berubah menjadi versi sebelumnya yaitu `:hello-api.idn-belajar-node.3`. Nomor versi upload `.3` bisa berbeda ditempat anda.
7. Klik tombol **Save and deploy** untuk memulai proses rollback deployment dari image sebelumnya.
8. Tunggu hingga status dari container service kembali menjadi **Running**.

Ketika rollback sudah selesai dan status kembali menjadi **Running** maka coba lakukan request ke API untuk melihat apakah respon sesuai dengan versi sebelumnya.

```sh
$ curl -s https://hello-api.ihcvtn9gpds60.ap-southeast-1.cs.amazonlightsail.com/
```

```json
{ 
  "hello": "Indonesia Belajar!"
}
```

Dapat terlihat bahwa API kita telah kembali ke versi sebelumnya yaitu `idn-belajar-node:1.0`. Respon tidak mengembalikan atribut `network` yang seharusnya ada di versi `idn-belajar-node:2.0`.

Jadi sebenarnya untuk melakukan rollback sesimple anda mengganti versi container image yang akan dijalankan.

Perlu diingat bahwa rollback juga adalah sebuah proses deployment jadi otomatis itu akan menambah daftar pada **Deployment versions**. Seperti yang terlihat pada gambar di bawah, rollback yang kita lakukan menghasilkan deployment versi 3.

[![Lightsail Deployment Versions](https://raw.githubusercontent.com/rioastamal-examples/assets/main/workshop-amazon-lightsail-containers/lab-deploy-nodejs-app/images/lightsail-hello-api-deployment-versions.png)](https://raw.githubusercontent.com/rioastamal-examples/assets/main/workshop-amazon-lightsail-containers/lab-deploy-nodejs-app/images/lightsail-hello-api-deployment-versions.png)

> Gambar 16. Rollback juga menghasilkan versi deployment baru

[^back to top](#top)

### <a name="step-14"></a>Step 14 - Menghapus Amazon Lightsail Container Service

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
$ curl -s https://hello-api.ihcvtn9gpds60.ap-southeast-1.cs.amazonlightsail.com/
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

[^back to top](#top)

---

SELAMAT! Anda telah menyelesaikan workshop deploy Node.js dengan menggunakan Amazon Lightsail Containers.

Jangan lupa berikan tanda ⭐ untuk repo ini. Sampai bertemu diworkshop selanjutnya.