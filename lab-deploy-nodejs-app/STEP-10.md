
### <a name="step-10"></a>Step 10 - Update Container Image

API versi terbaru sudah siap, saatnya melakukan update untuk container image `idn-belajar-node`. Kita akan merilis API versi terbaru ini dengan tag `2.0`. Untuk melakukannya ikuti langkah berikut.

```sh
docker build --rm -t idn-belajar-node:2.0 .
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
docker images idn-belajar-node
```

```
REPOSITORY         TAG       IMAGE ID       CREATED          SIZE
idn-belajar-node   2.0       c83f20a98c54   22 minutes ago   179MB
idn-belajar-node   1.0       6c88b5d7ef4a   2 days ago       179MB
```

Jalankan container versi baru tersebut untuk memastikan API berjalan sesuai harapan. 

```sh
docker run --rm --name idn_belajar_2_0 -p 8080:8080 -d idn-belajar-node:2.0
```

```
d8df1a6d0dbd70de4cd36ff21e5b6a766a7bb0c21d28819d37fdff612aefe23c
```

Lakukan HTTP request ke `localhost:8080` untuk melakukan tes respon dari API.

```sh
curl -s http://localhost:8080/
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


<table border="0" style="width: 100%; display: table;"><tr><td><a href="STEP-9.md">&laquo; Sebelumnya</td><td align="center"><a href="README.md">Daftar Isi</a></td><td align="right"><a href="STEP-11.md">Berikutnya &raquo;</a></td></tr></table>

<sup>Workshop: Deploy Node.js App dengan Amazon Lightsail Containers  
Version: 2022-05-12  
Author: [@rioastamal](https://github.com/rioastamal)</sup>
