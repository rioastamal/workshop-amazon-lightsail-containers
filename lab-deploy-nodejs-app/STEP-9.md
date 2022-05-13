
### <a name="step-9"></a>Step 9 - Membuat Versi Baru dari API

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
node src/index.js
```

```
API server running on port 8080
```

Kemudian lakukan HTTP request ke path `/` untuk melihat respon terbaru.

```sh
curl -s http://localhost:8080/
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


<table border="0" style="width: 100%; display: table;"><tr><td><a href="STEP-8.md">&laquo; Sebelumnya</td><td align="center"><a href="README.md">Daftar Isi</a></td><td align="right"><a href="STEP-10.md">Berikutnya &raquo;</a></td></tr></table>

<sup>Workshop: Deploy Node.js App dengan Amazon Lightsail Containers  
Version: 2022-05-12  
Author: [@rioastamal](https://github.com/rioastamal)</sup>
