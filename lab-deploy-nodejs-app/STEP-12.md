
## <a name="step-12"></a>Step 12 - Deploy Latest Version of the API

Once the container image `idn-belajar-node:2.0` uploaded to Amazon Lightsail Containers, we can deploy the latest version of the API using that image.

1. Go to Dashboard of the container service **hello-api** and make sure you're at the _Deployments_ page.
2. Click the **Modify your deployment** to open the configuration section to create new deployment.
3. The only configuration that need to change is container image which being used. Klik the **Choose stored image** then pick the latest one.
4. No need to change the rest of the configuration.
5. Wait few minutes for the status to change back to **Running**.

[![Lightsail Update Deployment](https://raw.githubusercontent.com/rioastamal-examples/assets/main/workshop-amazon-lightsail-containers/lab-deploy-nodejs-app/images/lightsail-hello-api-modify-deployment.png)](https://raw.githubusercontent.com/rioastamal-examples/assets/main/workshop-amazon-lightsail-containers/lab-deploy-nodejs-app/images/lightsail-hello-api-modify-deployment.png)

> Figure 11. Deployment of new version

After the status back to **Running** it's time to test it out using HTTP request. Use cURL or your browser to test the new deployment.

```sh
curl -s https://YOUR_OWN_CONTAINER_SERVICE_PUBLIC_DOMAIN/
```

```json
{
  "hello": "Indonesia Belajar!",
  "network": {
    "eth0": [
      {
        "address": "169.254.172.2",
        "netmask": "255.255.252.0",
        "family": "IPv4",
        "mac": "0a:58:a9:fe:ac:02",
        "internal": false,
        "cidr": "169.254.172.2/22"
      },
      {
        "address": "fe80::c016:75ff:fe78:8827",
        "netmask": "ffff:ffff:ffff:ffff::",
        "family": "IPv6",
        "mac": "0a:58:a9:fe:ac:02",
        "internal": false,
        "cidr": "fe80::c016:75ff:fe78:8827/64",
        "scopeid": 3
      }
    ],
    "eth1": [
      {
        "address": "172.26.0.67",
        "netmask": "255.255.240.0",
        "family": "IPv4",
        "mac": "02:f4:1a:f9:96:ac",
        "internal": false,
        "cidr": "172.26.0.67/20"
      },
      {
        "address": "2406:da18:f4f:e00:971b:f340:5454:794c",
        "netmask": "ffff:ffff:ffff:ffff::",
        "family": "IPv6",
        "mac": "02:f4:1a:f9:96:ac",
        "internal": false,
        "cidr": "2406:da18:f4f:e00:971b:f340:5454:794c/64",
        "scopeid": 0
      },
      {
        "address": "fe80::f4:1aff:fef9:96ac",
        "netmask": "ffff:ffff:ffff:ffff::",
        "family": "IPv6",
        "mac": "02:f4:1a:f9:96:ac",
        "internal": false,
        "cidr": "fe80::f4:1aff:fef9:96ac/64",
        "scopeid": 4
      }
    ]
  }
}
```

Cool! The new version of the API deployed. Now it contains `network` attribute as part of the output which not exists previously.


<table border="0" style="width: 100%; display: table;"><tr><td><a href="STEP-11.md">&laquo; Previous</td><td align="center"><a href="README.md">Index</a></td><td align="right"><a href="STEP-13.md">Next &raquo;</a></td></tr></table>

<sup>Workshop: Deploying Node.js App on Amazon Lightsail Containers  
Version: 2022-05-12  
Author: [@rioastamal](https://github.com/rioastamal)</sup>
