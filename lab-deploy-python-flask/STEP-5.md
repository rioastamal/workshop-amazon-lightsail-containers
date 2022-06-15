
### <a name="step-5"></a>Step 5 - Membuat Container Image

Untuk membuat container image dari layanan API yang baru dibuat kita akan menggunakan Docker.

Pastikan dulu telah berada pada direktori `python-app/`.

```
cd ~/python-app/
```

Buat sebuah file baru dengan nama `Dockerfile`. File ini akan berisi perintah-perintah dalam membangun container image. Letakkan file ini di dalam root direktori project yaitu `python-app/`.

```sh
touch Dockerfile
```

Salin kode dibawah ini dan masukkan ke dalam file `Dockerfile`.

```dockerfile
FROM public.ecr.aws/docker/library/python:3.8-slim

RUN mkdir -p /app
COPY requirements.txt run-server.sh /app/
COPY src/index.py /app/src/

WORKDIR /app
RUN pip install -r requirements.txt --target=/app/libs

ENTRYPOINT ["bash", "/app/run-server.sh"]
```

Pada kode di atas, kita menggunakan Python versi 3.8 yang diambil dari Amazon ECR public repository. Kemudian menyalin file-file yang diperlukan ke dalam container dan menjalankan `pip install` untuk mendapatkan semua ketergantungan pustaka yang ada di `requirements.txt`. Pustaka yang diinstal oleh pip akan ditempatkan di `/app/libs/`.

Kita akan menamakan container image ini dengan nama `indonesia-belajar` dengan versi `1.0`. Untuk mulai membangun container image jalankan perintah berikut. Perhatikan ada `.` titik diakhir perintah.

```sh
docker build --rm -t indonesia-belajar:1.0 .
```

```
Sending build context to Docker daemon  11.65MB
...[CUT]...
Step 7/7 : ENTRYPOINT ["bash", "/app/run-server.sh"]
 ---> Running in 4b6b9075a846
Removing intermediate container 4b6b9075a846
 ---> 32dc2a5baec9
Successfully built 32dc2a5baec9
Successfully tagged indonesia-belajar:1.0
```

Pastikan image tersebut ada dalam daftar image di lokal mesin.

```sh
docker images indonesia-belajar
```

```
REPOSITORY          TAG       IMAGE ID       CREATED          SIZE
indonesia-belajar   1.0       32dc2a5baec9   11 seconds ago   144MB
```

Dapat terlihat jika container image yang dibuat yaitu `indonesia-belajar` dengan versi `1.0` berhasil dibuat.

Sekarang coba jalankan container `indonesia-belajar:1.0` pada port `8080` untuk memastikan API yang dibuat dapat berjalan pada container.

```sh
docker run --rm --name idn_belajar_1_0 -p 8080:8080 -d indonesia-belajar:1.0
```

```
da1a191143ed8b030e6e3d7536871821a35627384fdfe856114ae26406c1220b
```

Kemudian cek untuk memastikan container `indonesia-belajar:1.0` sedang berjalan.

```sh
docker ps
```

```
CONTAINER ID   IMAGE                   COMMAND                  CREATED         STATUS         PORTS                                       NAMES
da1a191143ed   indonesia-belajar:1.0   "bash /app/run-serve…"   9 seconds ago   Up 7 seconds   0.0.0.0:8080->8080/tcp, :::8080->8080/tcp   idn_belajar_1_0
```

Jalankan `curl` untuk melakukan HTTP request ke localhost port `8080` dan teks "Hello Indonesia Belajar".

```sh
curl -s 'http://localhost:8080/?text=Hello%20Indonesia%20Belajar'
```

```
  _______________________
| Hello Indonesia Belajar |
  =======================
                       \
                        \
                          ^__^
                          (oo)\_______
                          (__)\       )\/\
                              ||----w |
                              ||     ||
```

Mantab! API dapat berjalan dengan sempurna di container. Sekarang stop container tersebut.

```sh
docker stop idn_belajar_1_0
```


<table border="0" style="width: 100%; display: table;"><tr><td><a href="STEP-4.md">&laquo; Sebelumnya</td><td align="center"><a href="README.md">Daftar Isi</a></td><td align="right"><a href="STEP-6.md">Berikutnya &raquo;</a></td></tr></table>

<sup>Workshop: Deploy Python Flask dengan Amazon Lightsail Containers  
Version: 2022-14-06  
Author: [@rioastamal](https://github.com/rioastamal)</sup>
