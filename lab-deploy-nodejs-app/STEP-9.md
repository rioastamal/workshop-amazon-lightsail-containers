
### <a name="step-9"></a>Step 9 - Create New Version of the API

Every application will almost certainly having an update whether for bug fixes or adding new features. In this step we will try to demonstrate how to update an application on Amazon Lightsail Container service.

We will change the API code by adding new feature to display network information of the system.

Make sure you're in `nodejs-app` directory. Then change the contents of `src/index.js` as shown below.

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

As you see we add `network` attribute to the response. To test the new code, run the API server.

```sh
node src/index.js
```

```
API server running on port 8080
```

Do a HTTP request to the API to URL `http://localhost:8080/`.

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

The API works as expected by returning network attribute.


<table border="0" style="width: 100%; display: table;"><tr><td><a href="STEP-8.md">&laquo; Sebelumnya</td><td align="center"><a href="README.md">Daftar Isi</a></td><td align="right"><a href="STEP-10.md">Berikutnya &raquo;</a></td></tr></table>

<sup>Workshop: Deploying Node.js App using Amazon Lightsail Containers  
Version: 2022-05-12  
Author: [@rioastamal](https://github.com/rioastamal)</sup>
