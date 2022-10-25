
### <a name="step-13"></a>Step 13 - Increasing Number of Nodes

When you when to increase the performance of your app to respond traffic, one of the solution is to do vertical scaling which means increasing your server's specs. The other way around is to do horizontal scaling which increasing number of nodes, which exactly what we are going to do.

This time we will increase number of nodes from 1 to 3.

1. Go to **hello-api** dashboard
2. Click the **Capacity**
3. Then click the **Change capacity** a window dialog will popping up, click **Yes, continue**.

[![Lightsail Capacity](https://raw.githubusercontent.com/rioastamal-examples/assets/main/workshop-amazon-lightsail-containers/lab-deploy-nodejs-app/images/lightsail-hello-api-capacity-menu.png)](https://raw.githubusercontent.com/rioastamal-examples/assets/main/workshop-amazon-lightsail-containers/lab-deploy-nodejs-app/images/lightsail-hello-api-capacity-menu.png)

> Figure 14. Changing container service capacity

4. We are still going to use Nano type for the capacity and for the scale move it to **3**.

[![Lightsail Add Node](https://raw.githubusercontent.com/rioastamal-examples/assets/main/workshop-amazon-lightsail-containers/lab-deploy-nodejs-app/images/lightsail-hello-api-capacity-add-node.png)](https://raw.githubusercontent.com/rioastamal-examples/assets/main/workshop-amazon-lightsail-containers/lab-deploy-nodejs-app/images/lightsail-hello-api-capacity-add-node.png)

> Figure 15. Adding more nodes for container service

5. This process will several minutes to complete, click **I understand** to close the dialog.
6. Wait for the status of the container service back to **Running**.

[![Lightsail New Capacity](https://raw.githubusercontent.com/rioastamal-examples/assets/main/workshop-amazon-lightsail-containers/lab-deploy-nodejs-app/images/lightsail-hello-api-new-capacity-applied.png)](https://raw.githubusercontent.com/rioastamal-examples/assets/main/workshop-amazon-lightsail-containers/lab-deploy-nodejs-app/images/lightsail-hello-api-new-capacity-applied.png)

> Figure 16. Number of nodes has been increased

Amazon Lightsail automatically will distributes the traffic to the 3 nodes running on **hello-api** container service. You don't need to configure anything including the load balancer.

Now test the response from the API and see the value of the local IP that is returned. The IP address of each request should have different results depending on which node is serving. Make a request to the public endpoint of the container several times and see the results.

```sh
curl -s 'https://YOUR_OWN_CONTAINER_SERVICE_PUBLIC_DOMAIN/?output=raw' \
-d '# Hello World'
```

```
<h1>Hello World</h1>

--
Local IP Address: 172.26.33.207
```

```sh
curl -s 'https://YOUR_OWN_CONTAINER_SERVICE_PUBLIC_DOMAIN/?output=raw' \
-d '# Hello World'
```

```
<h1>Hello World</h1>

--
Local IP Address: 172.26.7.130
```

```sh
curl -s 'https://YOUR_OWN_CONTAINER_SERVICE_PUBLIC_DOMAIN/?output=raw' \
-d '# Hello World'
```

```
<h1>Hello World</h1>

--
Local IP Address: 172.26.19.9
```

As can be seen that the IP addresses returned are different indicating that the request are served by different node. Do it several times if you still got the same result.

Before proceeding to the next step, first set the number of nodes back from **3** to **1**. Do you still remember how to do it right?


<table border="0" style="width: 100%; display: table;"><tr><td><a href="STEP-12.md">&laquo; Previous</td><td align="center"><a href="README.md">Index</a></td><td align="right"><a href="STEP-14.md">Next &raquo;</a></td></tr></table>

<sup>Workshop: Deploy Laravel App on Amazon Lightsail Containers  
Version: 2022-24-06  
Author: [@rioastamal](https://github.com/rioastamal)</sup>
