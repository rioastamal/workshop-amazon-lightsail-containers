
### <a name="step-4"></a>Step 4 - Create Node.js API

In this step we will create a simple API built using Express, one of the most popular Node.js framework for web development.

```sh
echo '{}' > package.json
```

```sh
npm install --save express
```

Next create a new directory named `src/` to place the source code.

```sh
mkdir src/
```

Buat sebuah file `src/index.js`, ini adalah file utama dimana kode API yang akan kita buat.

Create a file `src/index.js`, this is the file where we will put our main API codes.

```sh
touch src/index.js
```

Copy and paste code below into `src/index.js`.

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

Code above will run HTTP server on port 8080. When we access path `/` it should return JSON with the following format.

```json
{
  "hello": "Indonesia Belajar!"
}
```

Now try to run the code to make sure it the API runs as expected.

```
node src/index.js
```

```
API server running on port 8080
```

Test by doing HTTP request to the localhost port `8080`.

```sh
curl -s -D /dev/stdout http://localhost:8080
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

Cool!. Our API successfully run as expected. It's time to package it into a container image.


<table border="0" style="width: 100%; display: table;"><tr><td><a href="STEP-3.md">&laquo; Sebelumnya</td><td align="center"><a href="README.md">Daftar Isi</a></td><td align="right"><a href="STEP-5.md">Berikutnya &raquo;</a></td></tr></table>

<sup>Workshop: Deploying Node.js App using Amazon Lightsail Containers  
Version: 2022-05-12  
Author: [@rioastamal](https://github.com/rioastamal)</sup>
