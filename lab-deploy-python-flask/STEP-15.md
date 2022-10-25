
### <a name="step-15"></a>Step 15 - Remove Amazon Lightsail Container

If the application is no longer needed then there is no reason to run it. Disabling the container service does not stop the incurring charge.

To stop incurring charge you need to remove the container service.

1. Back to Amazon Lightsail dashboard
2. Click **Containers** menu
3. There should be a **hello-api** container service, click the 3 dots and click the **Delete** option.

[![Lightsail Delete Container Service](https://raw.githubusercontent.com/rioastamal-examples/assets/main/workshop-amazon-lightsail-containers/lab-deploy-nodejs-app/images/lightsail-hello-api-delete.png)](https://raw.githubusercontent.com/rioastamal-examples/assets/main/workshop-amazon-lightsail-containers/lab-deploy-nodejs-app/images/lightsail-hello-api-delete.png)

> Figure 17. Removing a container service

4. Click **Yes, delete** to delete container service.
6. **hello-api** container should be deleted and gone from the list.

It's worth noting that container images on Amazon Lightsail are tied to a container service. So removing the container service will also delete all container images that have been uploaded to the container service. In this case, the two container images that we uploaded earlier are `indonesia-belajar:1.0` and `indonesia-belajar:2.0` were deleted.

Now let's try to access the container's endpoint URL to see the response.

```sh
curl -s https://YOUR_OWN_CONTAINER_SERVICE_PUBLIC_DOMAIN/
```

```html
<!DOCTYPE html>
<html>
<head><title>404 No Such Service</title></head>
<body bgcolor="white">
<center><h1>404 No Such Service</h1></center>
</body>
</html>
```

The endpoint URL should return 404 HTTP error, it means no container service is running.


---

Congrats! You have completed a Python Flask deployment workshop on Amazon Lightsail Containers.

Don't forget to ⭐ this repo. See you at next workshop.

<table border="0" style="width: 100%; display: table;"><tr><td><a href="STEP-14.md">&laquo; Previous</td><td align="center"><a href="README.md">Index</a></td><td align="right"><a href="README.md">Next &raquo;</a></td></tr></table>

<sup>Workshop: Deploy Python Flask dengan Amazon Lightsail Containers  
Version: 2022-14-06  
Author: [@rioastamal](https://github.com/rioastamal)</sup>
