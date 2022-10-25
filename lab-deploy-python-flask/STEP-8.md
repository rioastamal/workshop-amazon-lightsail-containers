
### <a name="step-8"></a>Step 8 - Deploy Container Service

This step will create new deployment for **hello-api** container service using container image `:hello-api.indonesia-belajar.12`.

1. On the **hello-api** dashboard click the **Deployments** menu and then click the **Create your first deployment** link.

[![Lightsail Create Deployment](https://raw.githubusercontent.com/rioastamal-examples/assets/main/workshop-amazon-lightsail-containers/lab-deploy-nodejs-app/images/lightsail-hello-api-deployments-menu.png)](https://raw.githubusercontent.com/rioastamal-examples/assets/main/workshop-amazon-lightsail-containers/lab-deploy-nodejs-app/images/lightsail-hello-api-deployments-menu.png)

> Figure 8. Create your first deployment link

2. There are several things need to be configured. First enter **hello-idn-belajar** for the _Container name_. 
3. For the _Image_ option, click **Choose stored image** then choose our container image that has been uploaded.
4. API uses two optional environment variables: `APP_WORKER` and `APP_BIND`. `APP_WORKER` used to determine number of gunicorn worker (default is 4) and `APP_BIND` used to determine the bind address and port number (default is `0.0.0.0:8080`).
5. For **Open Ports** use the same port as `APP_BIND` environment variable in this case `8080` and HTTP for the protocol.
6. For **PUBLIC ENDPOINT** use container **idn-hello-belajar**. All traffic coming from public endpoint will be forwarded to this container.
7. Click **Save and deploy** to begin deployment.

[![Lightsail Configure Deployment](https://raw.githubusercontent.com/rioastamal-examples/assets/main/workshop-amazon-lightsail-containers/lab-general-app/images/lightsail-hello-api-configure-deployment.png)](https://raw.githubusercontent.com/rioastamal-examples/assets/main/workshop-amazon-lightsail-containers/lab-general-app/images/lightsail-hello-api-configure-deployment.png)

> Figure 9. Deployment configuration for containers

When the status is **Running** we can try to access the API by opening the URL shown on the public domain section. The public endpoint use HTTPS protocol. We will use curl to do the test. Run command below and replace with your own public domain.

```sh
curl -s 'https://YOUR_OWN_CONTAINER_SERVICE_PUBLIC_DOMAIN/?text=Hello%20Indonesia%20Belajar'
```

```
  _______________________
| Hello Indonesia Belajar |
  =======================
                       \
                        \
                          ^__^
                          (oo)\_______
                          (__)\       )\/\
                              ||----w |
                              ||     ||
```

Congrats! You gave successfully deployed a Python Flask API on Amazon Lightsail Container service. Pretty easy isn't it?


<table border="0" style="width: 100%; display: table;"><tr><td><a href="STEP-7.md">&laquo; Previous</td><td align="center"><a href="README.md">Index</a></td><td align="right"><a href="STEP-9.md">Next &raquo;</a></td></tr></table>

<sup>Workshop: Deploy Python Flask dengan Amazon Lightsail Containers  
Version: 2022-14-06  
Author: [@rioastamal](https://github.com/rioastamal)</sup>
