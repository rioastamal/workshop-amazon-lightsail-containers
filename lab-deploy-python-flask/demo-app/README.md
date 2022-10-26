## Python Flask Demo App

This directory contains application code and CloudFormation templates used for the workshop. The steps in the workshop are duplicated in this demo with only a few steps because it uses CloudFormation an Infrastructure as Code (IaC).

### Membuat Container Image

We will build the container image version `2.0` because code in the last commit represents that version.

```sh
docker build --rm -t indonesia-belajar:2.0 .
```

Pastikan image telah ada.

```sh
docker images indonesia-belajar:2.0
```

```
REPOSITORY          TAG       IMAGE ID       CREATED          SIZE
indonesia-belajar   2.0       08d5d95a6cb8   19 seconds ago   144MB
```

### Deploy Container to Amazon Lightsail Containers

A container image is bound to container service so we need to create a container service first.

We are going to use our CloudFormation template and provide a parameter which indicate that we want to create container service first.

```sh
aws cloudformation create-stack \
--stack-name "lab-lightsail-python-app" \
--template-body file:///$(pwd)/cloudformation/container-service.yaml \
--parameters ParameterKey=StepParam,ParameterValue=container_service
```

```json
{
    "StackId": "arn:aws:cloudformation:ap-southeast-1:ACCOUNT_ID:stack/lab-lightsail-nodejs-app/d47a2f10-b7df-11ec-9b9c-0ab1174fbbc8"
}
```

Command above will create container service **hello-api**, you can see CloudFormation template for more details.

Wait a few moments till the stack creation complete. You may go to CloudFormation console or using AWS CLI to check the progress.

Once stack creation completed, continue to upload container image to **hello-api** container service.

```sh
aws lightsail push-container-image \
--region "ap-southeast-1" \
--service-name "hello-api" \
--label "indonesia-belajar" \
--image "indonesia-belajar:2.0"
```

```
...[CUT]...
Digest: sha256:84be0f3b648170b62551abbadbafda1234c1e6362470ecf0b94b3f767d067976
Image "indonesia-belajar:2.0" registered.
Refer to this image as ":hello-api.indonesia-belajar.14" in deployments.
```

Image successfully uploaded, the reference for uploaded image is `:hello-api.idn-belajar-node.14`. Number `14` could be different on your side.

Next is to create a deployment on container service **hello-api** using image that we just uploaded. 

Run an update to the CloudFormation stack by giving parameter value `deployment`.

```sh
aws cloudformation update-stack \
--stack-name "lab-lightsail-python-app" \
--template-body file:///$(pwd)/cloudformation/container-service.yaml \
--parameters ParameterKey=StepParam,ParameterValue=deployment \
ParameterKey=ImageNameParam,ParameterValue=:hello-api.indonesia-belajar.14
```

```json
{
    "StackId": "arn:aws:cloudformation:ap-southeast-1:ACCOUNT_ID:stack/lab-lightsail-nodejs-app/d47a2f10-b7df-11ec-9b9c-0ab1174fbbc8"
}
```

You can check the progress on CloudFormation console. Once completed you can access API from the public endpoint provided in the Lightsail container service console.

[![Lightsail Deploy from CloudFormation](https://raw.githubusercontent.com/rioastamal-examples/assets/main/workshop-amazon-lightsail-containers/lab-deploy-nodejs-app/images/lightsail-hello-api-cloudformation-deployment.png)](https://raw.githubusercontent.com/rioastamal-examples/assets/main/workshop-amazon-lightsail-containers/lab-deploy-nodejs-app/images/lightsail-hello-api-cloudformation-deployment.png)

## Remove Deployment and Container Service

Since we uses CloudFormation to create container service and the deployment, removing the all resources is pretty easy.

```sh
aws cloudformation delete-stack \
--stack-name "lab-lightsail-python-app"
```

Running command above all resources created during deployment will be deleted.