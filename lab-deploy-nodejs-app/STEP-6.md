
### <a name="step-6"></a>Step 6 - Create Container Service on Amazon Lightsail

The container service is the compute resource on which the container is run. It provides many choices of RAM and vCPU capacities that can be selected according to your application needs. In addition you can also specify the number of nodes on which container is running.

1. Go to AWS Management Console then go to Amazon Lightsail page. On the Amazon Lightsail Dashboard click the **Containers** menu.

[![Lightsail Containers Menu](https://raw.githubusercontent.com/rioastamal-examples/assets/main/workshop-amazon-lightsail-containers/lab-deploy-nodejs-app/images/lightsail-menu-containers.png)](https://raw.githubusercontent.com/rioastamal-examples/assets/main/workshop-amazon-lightsail-containers/lab-deploy-nodejs-app/images/lightsail-menu-containers.png)

> Figure 1. The Containers menu on Amazon Lightsail

2. On the Containers page click the **Create container service** button to start creating a Container service.

[![Lightsail Create Instance Button](https://raw.githubusercontent.com/rioastamal-examples/assets/main/workshop-amazon-lightsail-containers/lab-deploy-nodejs-app/images/lightsail-button-create-instance.png)](https://raw.githubusercontent.com/rioastamal-examples/assets/main/workshop-amazon-lightsail-containers/lab-deploy-nodejs-app/images/lightsail-button-create-instance.png)

> Figure 2. Containers page contain a list of containers created

3. Then we will be faced with several choices. In the _Container service location_ option, select the a region, in this case I choose **Singapore**. Click the **Change AWS Region** link to do so. In the container capacity option, select **Nano** which consist of 512MB RAM and 0.25 vCPU. For the scale option specify **x1**. It means that we will only launch 1 node to run the containers.


[![Lightsail Choose Container Capacity](https://raw.githubusercontent.com/rioastamal-examples/assets/main/workshop-amazon-lightsail-containers/lab-deploy-nodejs-app/images/lightsail-choose-container-capacity.png)](https://raw.githubusercontent.com/rioastamal-examples/assets/main/workshop-amazon-lightsail-containers/lab-deploy-nodejs-app/images/lightsail-choose-container-capacity.png)

> Figure 3. Selecting region and capacity of the container

4. Next is to determine the name of the service. In the _Identify your service_ section, enter **hello-api**. At the _Summary_ section as we can see we will launch a container with a **Nano** capacity (512MB RAM, 0.25 vCPU)  **x1**. Total cost for this container service is **$7** per month. All is set now click  **Create container service** button.

[![Lightsail Choose Service Name](https://raw.githubusercontent.com/rioastamal-examples/assets/main/workshop-amazon-lightsail-containers/lab-deploy-nodejs-app/images/lightsail-choose-service-name.png)](https://raw.githubusercontent.com/rioastamal-examples/assets/main/workshop-amazon-lightsail-containers/lab-deploy-nodejs-app/images/lightsail-choose-service-name.png)

> Figure 4. Entering the container service name

5. The creation of container service will take few minutes, so be patient. Once done you will be taken to the dashboard of the **hello-api** container service page. You will get a domain to used to access your container. The domain is located at the _Public domain_ section. Wait until the status becomes **Ready** then click the domain to open **hello-api** container service. It should be still 404 error because no container image has been deployed to the container service.

[![Lightsail hello-api Dashboard](https://raw.githubusercontent.com/rioastamal-examples/assets/main/workshop-amazon-lightsail-containers/lab-deploy-nodejs-app/images/lightsail-hello-api-dashboard.png)](https://raw.githubusercontent.com/rioastamal-examples/assets/main/workshop-amazon-lightsail-containers/lab-deploy-nodejs-app/images/lightsail-hello-api-dashboard.png)

> Figure 5. Dashboard of the hello-api container service

[![https://raw.githubusercontent.com/rioastamal-examples/assets/main/workshop-amazon-lightsail-containers/lab-deploy-nodejs-app/images/lightsail-404-hello-api.png](https://raw.githubusercontent.com/rioastamal-examples/assets/main/workshop-amazon-lightsail-containers/lab-deploy-nodejs-app/images/lightsail-404-hello-api.png)](https://raw.githubusercontent.com/rioastamal-examples/assets/main/workshop-amazon-lightsail-containers/lab-deploy-nodejs-app/images/lightsail-404-hello-api.png)

> Figure 6. hello-api service returns 404 because no container image has been deployed


<table border="0" style="width: 100%; display: table;"><tr><td><a href="STEP-5.md">&laquo; Sebelumnya</td><td align="center"><a href="README.md">Daftar Isi</a></td><td align="right"><a href="STEP-7.md">Berikutnya &raquo;</a></td></tr></table>

<sup>Workshop: Deploying Node.js App using Amazon Lightsail Containers  
Version: 2022-05-12  
Author: [@rioastamal](https://github.com/rioastamal)</sup>
