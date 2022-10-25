
### <a name="step-10"></a>Step 10 - Update Container Image

Our new API is ready, next is to update the container image `idn-belajar-node`. We will release the new API with tag `2.0`. To do this follow step below.

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

Let see if our new container image is on the list.

```sh
docker images idn-belajar-node
```

```
REPOSITORY         TAG       IMAGE ID       CREATED          SIZE
idn-belajar-node   2.0       c83f20a98c54   22 minutes ago   179MB
idn-belajar-node   1.0       6c88b5d7ef4a   2 days ago       179MB
```

Let's run our `idn-belajar-node:2.0` to make sure it is working as expected.

```sh
docker run --rm --name idn_belajar_2_0 -p 8080:8080 -d idn-belajar-node:2.0
```

```
d8df1a6d0dbd70de4cd36ff21e5b6a766a7bb0c21d28819d37fdff612aefe23c
```

Do a HTTP request to the API to URL `http://localhost:8080/` to check the API response.

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

As you can see we have `network` attribute from the response. The ouput not exactly similar with non-container because the network interfaces inside the container are different from the host.


<table border="0" style="width: 100%; display: table;"><tr><td><a href="STEP-9.md">&laquo; Sebelumnya</td><td align="center"><a href="README.md">Daftar Isi</a></td><td align="right"><a href="STEP-11.md">Berikutnya &raquo;</a></td></tr></table>

<sup>Workshop: Deploying Node.js App using Amazon Lightsail Containers  
Version: 2022-05-12  
Author: [@rioastamal](https://github.com/rioastamal)</sup>
