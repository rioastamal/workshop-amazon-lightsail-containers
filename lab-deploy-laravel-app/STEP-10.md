
### <a name="step-10"></a>Step 10 - Update Container Image

Our new API is ready, next is to update the container image `indonesia-belajar`. We will release the new API with tag `2.0`. To do this follow step below.

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

Let's see if our new container image is already on the list.

```sh
docker images indonesia-belajar
```

```
REPOSITORY          TAG       IMAGE ID       CREATED          SIZE
indonesia-belajar   2.0       952d9875be26   58 seconds ago   478MB
indonesia-belajar   1.0       e76cb9d91076   40 minutes ago   478MB
```

Let's run our `indonesia-belajar:2.0` to make sure it is working as expected.

```sh
docker run --rm --name idn_belajar_2_0 \
-p 8080:80 -d indonesia-belajar:2.0
```

```
d8df1a6d0dbd70de4cd36ff21e5b6a766a7bb0c21d28819d37fdff612aefe23c
```

Open `loclahost:8080` on your browser dan do some test to convert Markdown.


<table border="0" style="width: 100%; display: table;"><tr><td><a href="STEP-9.md">&laquo; Previous</td><td align="center"><a href="README.md">Index</a></td><td align="right"><a href="STEP-11.md">Next &raquo;</a></td></tr></table>

<sup>Workshop: Deploy Laravel App on Amazon Lightsail Containers  
Version: 2022-24-06  
Author: [@rioastamal](https://github.com/rioastamal)</sup>
