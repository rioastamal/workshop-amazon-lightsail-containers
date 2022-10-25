
### <a name="step-8"></a>Step 8 - Deploy Container Service

This step will create new deployment for **hello-api** container service using container image `:hello-api.indonesia-belajar.12`.

1. On the **hello-api** dashboard click the **Deployments** menu and then click the **Create your first deployment** link.

[![Lightsail Create Deployment](https://raw.githubusercontent.com/rioastamal-examples/assets/main/workshop-amazon-lightsail-containers/lab-deploy-nodejs-app/images/lightsail-hello-api-deployments-menu.png)](https://raw.githubusercontent.com/rioastamal-examples/assets/main/workshop-amazon-lightsail-containers/lab-deploy-nodejs-app/images/lightsail-hello-api-deployments-menu.png)

> Figure 9. Create your first deployment link

2. There are several things need to be configured. First enter **hello-idn-belajar** for the _Container name_. 
3. For the _Image_ option, click **Choose stored image** then choose our container image that has been uploaded.
4. For the **Open ports** use `80` as Apache is run on this port.
6. For **PUBLIC ENDPOINT** use container **idn-hello-belajar**. All traffic coming from public endpoint will be forwarded to this container.
7. Jika semua sudah sesuai, klik **Save and deploy** untuk melakukan deployment. Proses ini akan memakan waktu beberapa menit. Tunggu hingga status dari 
8. Click **Save and deploy** to begin deployment.

[![Lightsail Configure Deployment](https://raw.githubusercontent.com/rioastamal-examples/assets/main/workshop-amazon-lightsail-containers/lab-laravel-app/images/lightsail-hello-api-configure-deployment.png)](https://raw.githubusercontent.com/rioastamal-examples/assets/main/workshop-amazon-lightsail-containers/lab-laravel-app/images/lightsail-hello-api-configure-deployment.png)

> Figure 10. Deployment configuration for containers

When the status is **Running** we can try to access the API by opening the URL shown on the public domain section. The public endpoint use HTTPS protocol. We will use curl to do the test. Run command below and replace with your own public domain.

```sh
curl https://YOUR_OWN_CONTAINER_SERVICE_PUBLIC_DOMAIN/ \ 
-d '# Hello World

This text will be converted to **HTML**.

1. Number one
2. Number two
'
```

The result should be the same as we got on step 4.

Congrats! You gave successfully deployed a Laravel app on Amazon Lightsail Container service. Pretty easy isn't it?


<table border="0" style="width: 100%; display: table;"><tr><td><a href="STEP-7.md">&laquo; Sebelumnya</td><td align="center"><a href="README.md">Daftar Isi</a></td><td align="right"><a href="STEP-9.md">Berikutnya &raquo;</a></td></tr></table>

<sup>Workshop: Deploy Laravel App dengan Amazon Lightsail Containers  
Version: 2022-24-06  
Author: [@rioastamal](https://github.com/rioastamal)</sup>
