
## <a name="step-12"></a>Step 12 - Deploy Versi Terbaru dari API

Setelah container image versi terbaru `indonesia-belajar:2.0` diupload ke Amazon Lightsail Containers maka kita dapat melakukan deployment versi terbaru dari API menggunakan image tersebut.

Once the container image `-belajar:2.0` uploaded to Amazon Lightsail Containers, we can deploy the latest version of the API using that image.

1. Go to Dashboard of the container service **hello-api** and make sure you're at the _Deployments_ page.
2. Click the **Modify your deployment** to open the configuration section to create new deployment.
3. The only configuration that need to change is container image which being used. Klik the **Choose stored image** then pick the latest one.
4. No need to change the rest of the configuration.
5. Wait few minutes for the status to change back to **Running**.

[![Lightsail Update Deployment](https://raw.githubusercontent.com/rioastamal-examples/assets/main/workshop-amazon-lightsail-containers/lab-general-app/images/lightsail-hello-api-modify-deployment.png)](https://raw.githubusercontent.com/rioastamal-examples/assets/main/workshop-amazon-lightsail-containers/lab-general-app/images/lightsail-hello-api-modify-deployment.png)

> Figure 13. Deployment of new version

After the status back to **Running** it's time to test it out using HTTP request. Use cURL or your browser to test the new deployment.

```sh
curl -s 'https://YOUR_OWN_CONTAINER_SERVICE_PUBLIC_DOMAIN/?output=raw' \
-d '# Hello World'
```

```
<h1>Hello World</h1>

--
Local IP Address: 172.17.0.2
```

Cool! The new version API has been successfully deployed. Now it contains new local IP address of the server.


<table border="0" style="width: 100%; display: table;"><tr><td><a href="STEP-11.md">&laquo; Previous</td><td align="center"><a href="README.md">Index</a></td><td align="right"><a href="STEP-13.md">Next &raquo;</a></td></tr></table>

<sup>Workshop: Deploy Laravel App on Amazon Lightsail Containers  
Version: 2022-24-06  
Author: [@rioastamal](https://github.com/rioastamal)</sup>
