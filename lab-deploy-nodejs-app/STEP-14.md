
### <a name="step-14"></a>Step 14 - Rollback Container to Previous Deployment

There's a situation where your new deployment is not working and causes errors. One of the advantages of using a container based-deployment is we can rollback easily.

To rollback our API deployment to previous version it's easy.

1. First make sure you are on the dashboard page of the **hello-api** container service.
2. Go to the _Deployments_ page.
3. Scroll down to Deployment versions . There we can see that we have done two deployments. The last deployment is for image `indonesia-belajar:2.0`.
4. Click the three dots Version 1 then click **Modify and redeploy**.


[![Lightsail Rollback Deployment](https://raw.githubusercontent.com/rioastamal-examples/assets/main/workshop-amazon-lightsail-containers/lab-deploy-nodejs-app/images/lightsail-hello-api-rollback-deployment.png)](https://raw.githubusercontent.com/rioastamal-examples/assets/main/workshop-amazon-lightsail-containers/lab-deploy-nodejs-app/images/lightsail-hello-api-rollback-deployment.png)

> Figure 15. Rollback deployment to previous version

5. A confirmation dialog will appear, click **Yes button, continue**.
6. The deployment process has not been carried out, it only autofill the Image configuration value that changed the image previous version, namely `:hello-api.indonesia-belajar.12`. The uploaded version number `.12` may be different in your side.
7. Click **Save and deploy** button to start the rollback deployment process from the previous image.
8. Wait until the status of the container service returns to Running.

When rollback is complete and the status returns to _Running_, try to make a request to the API to see if the response matches the previous version.

```sh
curl -s https://YOUR_OWN_CONTAINER_SERVICE_PUBLIC_DOMAIN/
```

```json
{ 
  "hello": "Indonesia Belajar!"
}
```

Now API does not return the local IP of the server as it should be in version `indonesia-belajar:2.0`, instead it return response from previous deployment using `indonesia-belajar:1.0` image.

So doing rollback is as simple as changing the version of the container image to run.

Keep in mind that rollback is also a deployment process so it will increase deployment version as seen in the image below, our rollback results in a version 3 deployment.

[![Lightsail Deployment Versions](https://raw.githubusercontent.com/rioastamal-examples/assets/main/workshop-amazon-lightsail-containers/lab-deploy-nodejs-app/images/lightsail-hello-api-deployment-versions.png)](https://raw.githubusercontent.com/rioastamal-examples/assets/main/workshop-amazon-lightsail-containers/lab-deploy-nodejs-app/images/lightsail-hello-api-deployment-versions.png)

> Gambar 16. Rollback juga menghasilkan versi deployment baru


<table border="0" style="width: 100%; display: table;"><tr><td><a href="STEP-13.md">&laquo; Sebelumnya</td><td align="center"><a href="README.md">Daftar Isi</a></td><td align="right"><a href="STEP-15.md">Berikutnya &raquo;</a></td></tr></table>

<sup>Workshop: Deploying Node.js App using Amazon Lightsail Containers  
Version: 2022-05-12  
Author: [@rioastamal](https://github.com/rioastamal)</sup>
