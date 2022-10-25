
### <a name="step-8"></a>Step 8 - Deploy Container Service

This step will create new deployment for **hello-api** container service using container image `:hello-api.idn-belajar.2`.

1. On the **hello-api** dashboard click the **Deployments** menu and then click the **Create your first deployment** link.

[![https://raw.githubusercontent.com/rioastamal-examples/assets/main/workshop-amazon-lightsail-containers/lab-deploy-nodejs-app/images/lightsail-hello-api-deployments-menu.png](https://raw.githubusercontent.com/rioastamal-examples/assets/main/workshop-amazon-lightsail-containers/lab-deploy-nodejs-app/images/lightsail-hello-api-deployments-menu.png)](https://raw.githubusercontent.com/rioastamal-examples/assets/main/workshop-amazon-lightsail-containers/lab-deploy-nodejs-app/images/lightsail-hello-api-deployments-menu.png)

> Figure 8. Create your first deployment link

2. There are several fields need to be completed. First enter **hello-idn-belajar** for the _Container name_. 
3. For the _Image_ option, click **Choose stored image** then choose our container image that has been uploaded.
4. The API only uses single environment variable named `APP_PORT` to determine which port the app should bind to. Default to port `8080`. Although it is optional we will explicitly provide the env just to make it more clear.
5. For the **Open ports** configuration, use port number where the app is running in this case should be the same as `APP_PORT` value which is `8080`.
6. For **PUBLIC ENDPOINT** use container **idn-hello-belajar**. All traffic coming from public endpoint will be forwarded to this container.
7. If everything is set, click **Save and deploy** to deploy. 

This process will take several minutes. Wait until the status of the Container service becomes **Running**.

[![Lightsail Create Deployment](https://raw.githubusercontent.com/rioastamal-examples/assets/main/workshop-amazon-lightsail-containers/lab-deploy-nodejs-app/images/lightsail-hello-api-create-deployment.png)](https://raw.githubusercontent.com/rioastamal-examples/assets/main/workshop-amazon-lightsail-containers/lab-deploy-nodejs-app/images/lightsail-hello-api-create-deployment.png)

> Figure 9. Deployment configuration for containers

When the status is **Running** then we can try to access the API by opening the URL in the public domain section. The public endpoint use HTTPS protocol. We will use curl to do the test. Run command below and replace with your own public domain.

```sh
curl -s https://YOUR_OWN_CONTAINER_SERVICE_PUBLIC_DOMAIN/
```

```json
{
  "hello": "Indonesia Belajar!"
}
```

Congrats! You gave successfully deployed a Node.js API using Amazon Lightsail Container service. Pretty easy isn't it?


<table border="0" style="width: 100%; display: table;"><tr><td><a href="STEP-7.md">&laquo; Sebelumnya</td><td align="center"><a href="README.md">Daftar Isi</a></td><td align="right"><a href="STEP-9.md">Berikutnya &raquo;</a></td></tr></table>

<sup>Workshop: Deploying Node.js App using Amazon Lightsail Containers  
Version: 2022-05-12  
Author: [@rioastamal](https://github.com/rioastamal)</sup>
