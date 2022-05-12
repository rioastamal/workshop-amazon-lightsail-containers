
### <a name="step-4"></a>Step 4 - Membuat Node.js API

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


<table border="0" style="width: 100%; display: table;"><tr><td><a href="STEP-3.md">&laquo; Sebelumnya</td><td align="center"><a href="README.md">Daftar Isi</a></td><td align="right"><a href="STEP-5.md">Berikutnya &raquo;</a></td></tr></table>

<sup>Workshop: Deploy Node.js App dengan Amazon Lightsail Containers  
Version: 2022-05-12  
Author: [@rioastamal](https://github.com/rioastamal)</sup>
