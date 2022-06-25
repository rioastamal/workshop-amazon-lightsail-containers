
### <a name="step-10"></a>Step 10 - Update Container Image

API versi terbaru sudah siap, saatnya melakukan update untuk container image `indonesia-belajar`. Kita akan merilis aplikasi versi terbaru ini dengan tag `2.0`. Untuk melakukannya ikuti langkah berikut.

```sh
docker build --rm -t indonesia-belajar:2.0 .
```

```
...[CUT]...
Compiled views cleared successfully.
Blade templates cached successfully.
Removing intermediate container df51dda8b2ee
 ---> 952d9875be26
Successfully built 952d9875be26
Successfully tagged indonesia-belajar:2.0
```

Kita lihat apakah container image baru tersebut sudah ada dalam daftar container image pada mesin kita.

```sh
docker images indonesia-belajar
```

```
REPOSITORY          TAG       IMAGE ID       CREATED          SIZE
indonesia-belajar   2.0       952d9875be26   58 seconds ago   478MB
indonesia-belajar   1.0       e76cb9d91076   40 minutes ago   478MB
```

Jalankan container versi baru tersebut untuk memastikan API berjalan sesuai harapan. 

```sh
docker run --rm --name idn_belajar_2_0 \
-p 8080:80 -d indonesia-belajar:2.0
```

```
d8df1a6d0dbd70de4cd36ff21e5b6a766a7bb0c21d28819d37fdff612aefe23c
```

Buka web browser di alamat `localhost:8080` dan lakukan tes konversi markdown.


<table border="0" style="width: 100%; display: table;"><tr><td><a href="STEP-9.md">&laquo; Sebelumnya</td><td align="center"><a href="README.md">Daftar Isi</a></td><td align="right"><a href="STEP-11.md">Berikutnya &raquo;</a></td></tr></table>

<sup>Workshop: Deploy Laravel App dengan Amazon Lightsail Containers
Version: 2022-24-06  
Author: [@rioastamal](https://github.com/rioastamal)</sup>
