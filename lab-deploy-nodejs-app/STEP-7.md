
### <a name="step-7"></a>Step 7 - Push Container Image ke Amazon Lightsail

Setiap container image yang di-push ke Amazon Lightsail terikat pada sebuah Container service. Karena itulah kita membuat **hello-api** Container service terlebih dahulu sebelum melakukan push container image.

Pada langkah ini kita akan melakukan push container image `idn-belajar-node:1.0` yang telah dibuat sebelumnya ke Container service **hello-api**. Jalankan perintah dibawah ini.

```sh
$ aws lightsail push-container-image \
--region "ap-southeast-1" \
--service-name "hello-api" \
--label "idn-belajar-node" \
--image "idn-belajar-node:1.0"
```

```
...[CUT]...
c1065d45b872: Pushed 
Digest: sha256:236b7239c44e16ac44a94b92350b3e409ca7631c9663b5242f8a2d2175603417
Image "idn-belajar-node:1.0" registered.
Refer to this image as ":hello-api.idn-belajar-node.2" in deployments.
```

Jika berhasil maka anda akan mendapatkan pesan mirip seperti diatas. Container image akan disimpan dengan penamaan `:<container-service>:<label>.<versi-upload>` pada contoh diatas penamaannya adalah `:hello-api.idn-belajar.2`.

Sekarang pastikan container image tersebut ada dalam daftar container yang telah diupload. Masuk ke halaman dashboard dari container service **hello api** kemudian masuk ke halaman **Images**.

[![Lightsail hello-api Image](https://raw.githubusercontent.com/rioastamal-examples/assets/main/workshop-amazon-lightsail-containers/lab-deploy-nodejs-app/images/lightsail-hello-api-image.png)](https://raw.githubusercontent.com/rioastamal-examples/assets/main/workshop-amazon-lightsail-containers/lab-deploy-nodejs-app/images/lightsail-hello-api-image.png)

> Gambar 7. Daftar container image yang telah diupload

Pada halaman _Images_ dapat terlihat jika terdapat sebuah image `:hello-api.idn-belajar.2` seperti yang telah diupload pada proses sebelumnya. Kita akan menggunakan image ini untuk melakukan deployment.


<table border="0" style="width: 100%; display: table;"><tr><td><a href="STEP-6.md">&laquo; Sebelumnya</td><td align="center"><a href="README.md">Daftar Isi</a></td><td align="right"><a href="STEP-8.md">Berikutnya &raquo;</a></td></tr></table>

<sup>Workshop: Deploy Node.js App dengan Amazon Lightsail Containers  
Version: 2022-05-12  
Author: [@rioastamal](https://github.com/rioastamal)</sup>
