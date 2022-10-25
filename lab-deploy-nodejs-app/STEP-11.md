
### <a name="step-11"></a>Step 11 - Push New Version of Container Image

We have uploaded previous container image `idn-belajar-node:1.0` to **hello-api** container service. Now it's time to upload the new version with tag `2.0`.

```sh
aws lightsail push-container-image \
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

In my case the image was stored as `:hello-api.idn-belajar-node.4`. The upload version `4` could be different from yours.

To make sure that container image has been uploaded successfully check **_Images** page. The new image should be there.

[![Lightsail Container New Image](https://raw.githubusercontent.com/rioastamal-examples/assets/main/workshop-amazon-lightsail-containers/lab-deploy-nodejs-app/images/lightsail-hello-api-new-image.png)](https://raw.githubusercontent.com/rioastamal-examples/assets/main/workshop-amazon-lightsail-containers/lab-deploy-nodejs-app/images/lightsail-hello-api-new-image.png)

> Figure 10. Container image version 2.0


<table border="0" style="width: 100%; display: table;"><tr><td><a href="STEP-10.md">&laquo; Previous</td><td align="center"><a href="README.md">Index</a></td><td align="right"><a href="STEP-12.md">Next &raquo;</a></td></tr></table>

<sup>Workshop: Deploying Node.js App on Amazon Lightsail Containers  
Version: 2022-05-12  
Author: [@rioastamal](https://github.com/rioastamal)</sup>
