
### <a name="step-5"></a>Step 5 - Membuat Container Image

Untuk membuat container image dari layanan API yang baru dibuat kita akan menggunakan Docker.

Pastikan dulu telah berada pada direktori `nodejs-app/`.

```
cd ~/nodejs-app/
```

Buat sebuah file baru dengan nama `Dockerfile`. File ini akan berisi perintah-perintah dalam membangun container image. Letakkan file ini di dalam root direktori project yaitu `nodejs-app/`.

```sh
touch Dockerfile
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
docker build --rm -t idn-belajar-node:1.0 .
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
docker images idn-belajar-node
```

```
REPOSITORY         TAG       IMAGE ID       CREATED             SIZE
idn-belajar-node   1.0       6c88b5d7ef4a   3 minutes ago       179MB
```

Dapat terlihat jika container image yang dibuat yaitu `idn-belajar-node` dengan versi `1.0` berhasil dibuat.

Sekarang coba jalankan container `idn-belajar-node:1.0` pada port `8080` untuk memastikan API yang dibuat dapat berjalan pada container.

```sh
docker run --rm --name idn_belajar_1_0 -p 8080:8080 -d idn-belajar-node:1.0
```

```
ec43c5f4ab04b920df9907bf981d3b7b0dd2c287d8599e1b7768e290694b8f16
```

Kemudian cek untuk memastikan container `idn-belajar-node:1.0` sedang berjalan.

```sh
docker ps
```

```
CONTAINER ID   IMAGE                  COMMAND               CREATED          STATUS          PORTS                                       NAMES
ec43c5f4ab04   idn-belajar-node:1.0   "node src/index.js"   24 seconds ago   Up 22 seconds   0.0.0.0:8080->8080/tcp, :::8080->8080/tcp   idn_belajar_1_0
```

Jalankan `curl` untuk melakukan HTTP request ke localhost port `8080` dan path `/`.

```sh
curl -s http://localhost:8080/
```

```json
{
  "hello": "Indonesia Belajar!"
}
```

Mantab! API dapat berjalan dengan sempurna di container. Sekarang stop container tersebut.

```sh
docker stop idn_belajar_1_0
```


<table border="0" style="width: 100%; display: table;"><tr><td><a href="STEP-4.md">&laquo; Sebelumnya</td><td align="center"><a href="README.md">Daftar Isi</a></td><td align="right"><a href="STEP-6.md">Berikutnya &raquo;</a></td></tr></table>

<sup>Workshop: Deploy Node.js App dengan Amazon Lightsail Containers  
Version: 2022-05-12  
Author: [@rioastamal](https://github.com/rioastamal)</sup>
