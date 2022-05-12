
### <a name="step-11"></a>Step 11 - Push Container Image Versi Terbaru

Kita sudah pernah melakukan upload container image `idn-belajar-node:1.0` ke Container service **hello-api**. Karena sudah ada versi terbaru yaitu `idn-belajar-node:2.0` maka kita juga harus melakukan push container image ini ke **hello-api**. Jalankan perintah di bawah ini.

```sh
$ aws lightsail push-container-image \
--region "ap-southeast-1" \
--service-name "hello-api" \
--label "idn-belajar-node" \
--image "idn-belajar-node:2.0"
```

```
...[CUT]...
5dd85641fdcb: Layer already exists 
c1065d45b872: Layer already exists 
Digest: sha256:84be0f3b648170b62551abbadbafda1234c1e6362470ecf0b94b3f767d067976
Image "idn-belajar-node:2.0" registered.
Refer to this image as ":hello-api.idn-belajar-node.4" in deployments.
```

Pada kasus milik saya image yang tersimpan di Container service adalah `:hello-api.idn-belajar-node.4`. Nomor versi upload `.4` bisa berbeda dengan milik anda.

Untuk memastikan container telah terupload dengan sukses masuk pada dashboard Container service **hello-api** dan klik menu **Images**. Harusnya image sudah muncul di halaman tersebut.

[![Lightsail Container New Image](https://raw.githubusercontent.com/rioastamal-examples/assets/main/workshop-amazon-lightsail-containers/lab-deploy-nodejs-app/images/lightsail-hello-api-new-image.png)](https://raw.githubusercontent.com/rioastamal-examples/assets/main/workshop-amazon-lightsail-containers/lab-deploy-nodejs-app/images/lightsail-hello-api-new-image.png)

> Gambar 10. Container image versi terbaru 2.0


<table border="0" style="width: 100%; display: table;"><tr><td><a href="STEP-10.md">&laquo; Sebelumnya</td><td align="center"><a href="README.md">Daftar Isi</a></td><td align="right"><a href="STEP-12.md">Berikutnya &raquo;</a></td></tr></table>

<sup>Workshop: Deploy Node.js App dengan Amazon Lightsail Containers  
Version: 2022-05-12  
Author: [@rioastamal](https://github.com/rioastamal)</sup>
