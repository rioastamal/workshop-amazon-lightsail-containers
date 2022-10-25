
### <a name="step-7"></a>Step 7 - Push Container Image to Amazon Lightsail

Each container image pushed to Amazon Lightsail is bound to a container cervice. That's why we created the **hello-api** container service first before pushing the container image.

In this step we will push `idn-belajar-node:1.0` the previously created container image to **hello-api** container service. Run command below.

```sh
aws lightsail push-container-image \
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

You will get a message similar to the one above once the push is successfull. The container image will be saved with the name `:<container-service>:<label>.<upload-number>` in the example above the name is `:hello-api.idn-belajar.2`. Yours `upload-number` could be different.

Now make sure the container image has been uploaded, go to the **Images** page.

[![Lightsail hello-api Image](https://raw.githubusercontent.com/rioastamal-examples/assets/main/workshop-amazon-lightsail-containers/lab-deploy-nodejs-app/images/lightsail-hello-api-image.png)](https://raw.githubusercontent.com/rioastamal-examples/assets/main/workshop-amazon-lightsail-containers/lab-deploy-nodejs-app/images/lightsail-hello-api-image.png)

> Figure 7. List of uploaded container images

As you can see on the _Images_ page there is an container image `:hello-api.idn-belajar.2` that we just uploaded from previous step. We will use this image to do the deployment.


<table border="0" style="width: 100%; display: table;"><tr><td><a href="STEP-6.md">&laquo; Sebelumnya</td><td align="center"><a href="README.md">Daftar Isi</a></td><td align="right"><a href="STEP-8.md">Berikutnya &raquo;</a></td></tr></table>

<sup>Workshop: Deploying Node.js App using Amazon Lightsail Containers  
Version: 2022-05-12  
Author: [@rioastamal](https://github.com/rioastamal)</sup>
