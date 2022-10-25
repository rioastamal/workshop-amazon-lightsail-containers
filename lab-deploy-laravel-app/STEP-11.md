
### <a name="step-11"></a>Step 11 - Push New Version of Container Image

We have uploaded previous container image `indonesia-belajar:1.0` to **hello-api** container service. Now it's time to upload the new version with tag `2.0`.

```sh
aws lightsail push-container-image \
--region "ap-southeast-1" \
--service-name "hello-api" \
--label "indonesia-belajar" \
--image "indonesia-belajar:2.0"
```

```
...[CUT]...
ad6562704f37: Layer already exists 
Digest: sha256:4233e2c6f9650a3a860f113543f6bc8c0d294edfb976574b21ca33a528a635e7
Image "indonesia-belajar:2.0" registered.
Refer to this image as ":hello-api.indonesia-belajar.13" in deployments.
```

In my case the image was stored as `:hello-api.indonesia-belajar.13`. The upload version `13` could be different from yours.

To make sure that container image has been uploaded successfully check **_Images** page. The new image should be there.

[![Lightsail Container New Image](https://raw.githubusercontent.com/rioastamal-examples/assets/main/workshop-amazon-lightsail-containers/lab-general-app/images/lightsail-hello-api-new-image.png)](https://raw.githubusercontent.com/rioastamal-examples/assets/main/workshop-amazon-lightsail-containers/lab-general-app/images/lightsail-hello-api-new-image.png)

> Figure 12. Container image version 2.0


<table border="0" style="width: 100%; display: table;"><tr><td><a href="STEP-10.md">&laquo; Sebelumnya</td><td align="center"><a href="README.md">Daftar Isi</a></td><td align="right"><a href="STEP-12.md">Berikutnya &raquo;</a></td></tr></table>

<sup>Workshop: Deploy Laravel App dengan Amazon Lightsail Containers  
Version: 2022-24-06  
Author: [@rioastamal](https://github.com/rioastamal)</sup>
