## Workshop Deploy Node.js App dengan Amazon Lightsail Containers

### Step 0 - Kebutuhan

Sebelum memulai workshop pastikan sudah memenuhi kebutuhan yang tercantum di bawah ini.

- Memiliki akun AWS aktif
- Sudah menginstal Docker
- Sudah menginstal AWS CLI v2 dan konfigurasinya

### Step 1 - Menginstal Lightsail Control Plugin

Plugin CLI ini digunakan untuk mengupload container image dari komputer lokal ke Amazon Lightsail container service. Jalankan perintah berikut untuk menginstal Lightsail Control Plugin. Diasumsikan bahwa terdapat perintah `sudo` pada distribusi Linux yang anda gunakan.

```sh
$ sudo curl "https://s3.us-west-2.amazonaws.com/lightsailctl/latest/linux-amd64/lightsailctl" -o "/usr/local/bin/lightsailctl"
```

Tambahkan atribut _execute_ pada file `lightsailctl` yang baru saja didownload.

```sh
$ sudo chmod +x /usr/local/bin/lightsailctl
```

### Step 2 - Membuat Direktori untuk Project

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

### Step 3 - Membuat Node.js API

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

### Step 4 - Membuat Container Image

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
$ docker images
```

```
REPOSITORY                                                                  TAG       IMAGE ID       CREATED         SIZE
idn-belajar-node                                                            1.0       6c88b5d7ef4a   3 minutes ago   179MB
public.ecr.aws/docker/library/node                                          16-slim   d42cb3d451c4   6 days ago      175MB
```

Dapat terlihat jika container image yang dibuat yaitu `idn-belajar-node` dengan versi `1.0` berhasil dibuat.

### Step 5 - Membuat Container Service di Amazon Lightsail

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

5. Setelah itu Lightsail akan mulai memproses pembuatan container service **hello-api**. Ini akan memakan waktu beberapa menit, jadi mohon ditunggu. Setelah selesai anda akan dibawa ke dashboard dari halaman container service **hello-api**. ANda akan mendapat domain yang digunakan untuk mengakses container. Domain tersebut terlihat di bagian _Public domain_. Klik domain tersebut untuk membuka aplikasi **hello-api**. Ketika domain tersebut dikunjungi harusnya terdapat error 404 karena belum ada container image yang dideploy pada **hello-api**.

[![Lightsail hello-api Dashboard](https://raw.githubusercontent.com/rioastamal-examples/assets/main/workshop-amazon-lightsail-containers/lab-deploy-nodejs-app/images/lightsail-hello-api-dashboard.png)](https://raw.githubusercontent.com/rioastamal-examples/assets/main/workshop-amazon-lightsail-containers/lab-deploy-nodejs-app/images/lightsail-hello-api-dashboard.png)

> Gambar 5. Dashboard dari container service hello-api

[![https://raw.githubusercontent.com/rioastamal-examples/assets/main/workshop-amazon-lightsail-containers/lab-deploy-nodejs-app/images/lightsail-404-hello-api.png](https://raw.githubusercontent.com/rioastamal-examples/assets/main/workshop-amazon-lightsail-containers/lab-deploy-nodejs-app/images/lightsail-404-hello-api.png)](https://raw.githubusercontent.com/rioastamal-examples/assets/main/workshop-amazon-lightsail-containers/lab-deploy-nodejs-app/images/lightsail-404-hello-api.png)

> Gambar 6. Layanan hello-api masih 404 karena belum ada container image yang dideploy