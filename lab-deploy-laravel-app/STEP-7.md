
### <a name="step-7"></a>Step 7 - Push Container Image to Amazon Lightsail

Each container image pushed to Amazon Lightsail is bound to a container service. That's why we created the **hello-api** container service first before pushing the container image.

In this step we will push `indonesia-belajar:1.0` the previously created container image to **hello-api** container service. Run command below.

```sh
aws lightsail push-container-image \
--region "ap-southeast-1" \
--service-name "hello-api" \
--label "indonesia-belajar" \
--image "indonesia-belajar:1.0"
```

```
...[CUT]...
ad6562704f37: Pushed 
Digest: sha256:476291c73ec25649423be818454f51ea2185f436f00edb81fbce1da0a6ec2f5e
Image "indonesia-belajar:1.0" registered.
Refer to this image as ":hello-api.indonesia-belajar.12" in deployments.
```

You will get a message similar to the one above once the push is successfull. The container image will be saved with the name `:<container-service>:<label>.<upload-number>` in the example above the name is `:hello-api.indonesia-belajar.12`. Your `upload-number` could be different.

Now make sure the container image has been uploaded, go to the **Images** page.

[![Lightsail hello-api Image](https://raw.githubusercontent.com/rioastamal-examples/assets/main/workshop-amazon-lightsail-containers/lab-general-app/images/lightsail-hello-api-image.png)](https://raw.githubusercontent.com/rioastamal-examples/assets/main/workshop-amazon-lightsail-containers/lab-general-app/images/lightsail-hello-api-image.png)

> Figure 8. List of uploaded container images

As you can see on the _Images_ page there is an container image `:hello-api.indonesia-belajar.12` that we just uploaded from previous step. We will use this image to do the deployment.


<table border="0" style="width: 100%; display: table;"><tr><td><a href="STEP-6.md">&laquo; Previous</td><td align="center"><a href="README.md">Index</a></td><td align="right"><a href="STEP-8.md">Next &raquo;</a></td></tr></table>

<sup>Workshop: Deploy Laravel App on Amazon Lightsail Containers  
Version: 2022-24-06  
Author: [@rioastamal](https://github.com/rioastamal)</sup>
