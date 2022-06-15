
### <a name="step-10"></a>Step 10 - Update Container Image

API versi terbaru sudah siap, saatnya melakukan update untuk container image `indonesia-belajar`. Kita akan merilis API versi terbaru ini dengan tag `2.0`. Untuk melakukannya ikuti langkah berikut.

```sh
docker build --rm -t indonesia-belajar:2.0 .
```

```
...[CUT]...
Step 7/7 : ENTRYPOINT ["bash", "/app/run-server.sh"]
 ---> Running in 0f0a8b970ba4
Removing intermediate container 0f0a8b970ba4
 ---> b3846915d8d0
Successfully built b3846915d8d0
Successfully tagged indonesia-belajar:2.0
```

Kita lihat apakah container image baru tersebut sudah ada dalam daftar container image pada mesin kita.

```sh
docker images indonesia-belajar
```

```
REPOSITORY          TAG       IMAGE ID       CREATED         SIZE
indonesia-belajar   2.0       b3846915d8d0   6 seconds ago   144MB
indonesia-belajar   1.0       32dc2a5baec9   4 hours ago     144MB
```

Jalankan container versi baru tersebut untuk memastikan API berjalan sesuai harapan. 

```sh
docker run --rm --name idn_belajar_2_0 -p 8080:8080 -d indonesia-belajar:2.0
```

```
d8df1a6d0dbd70de4cd36ff21e5b6a766a7bb0c21d28819d37fdff612aefe23c
```

Lakukan HTTP request ke `localhost:8080` untuk melakukan tes respon dari API.

```sh
curl -s 'http://localhost:8080/?text=Hello%20Indonesia%20Belajar&char=milk'
```

```
  _______________________
| Hello Indonesia Belajar |
  =======================
                       \
                        \
                         \
                          \
                              ____________
                              |__________|
                             /           /\
                            /           /  \
                           /___________/___/|
                           |          |     |
                           |  ==\ /== |     |
                           |   O   O  | \ \ |
                           |     <    |  \ \|
                          /|          |   \ \
                         / |  \_____/ |   / /
                        / /|          |  / /|
                       /||\|          | /||\/
                           -------------|
                               | |    | |
                              <__/    \__>
My Local IP: 172.17.0.2
```

Dapat terlihat jika respon dari API menampilkan karakter `milk` (susu).


<table border="0" style="width: 100%; display: table;"><tr><td><a href="STEP-9.md">&laquo; Sebelumnya</td><td align="center"><a href="README.md">Daftar Isi</a></td><td align="right"><a href="STEP-11.md">Berikutnya &raquo;</a></td></tr></table>

<sup>Workshop: Deploy Python Flask dengan Amazon Lightsail Containers  
Version: 2022-14-06  
Author: [@rioastamal](https://github.com/rioastamal)</sup>
