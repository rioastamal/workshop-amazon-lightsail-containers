## Node.js Demo App

Direktori ini berisi kode aplikasi dan CloudFormation template dari Workshop Deploy Node.js App dengan Amazon Lightsail Containers. Langkah-langkah pada workshop diduplikasi pada demo ini hanya dengan beberapa langkah karena menggunakan Infrastructure as Code (IaC) yaitu CloudFormation.

### Membuat Container Image

Kita akan langsung build container image versi `2.0` karena kode pada commit terakhir merepresentasikan versi tersebut.

```sh
$ docker build --rm -t idn-belajar-node:2.0
```

Pastikan image telah ada.

```sh
$ docker images idn-belajar-node:2.0
```

```
docker images idn-belajar-node:2.0
REPOSITORY         TAG       IMAGE ID       CREATED        SIZE
idn-belajar-node   2.0       c83f20a98c54   40 hours ago   179MB
```

### Deploy Container ke Amazon Lightsail Containers

Pertama kita harus membuat Container service terlebih dahulu, karena akan digunakan untuk menampung container image yang diupload.

Kita akan memanfaatkan CloudFormation untuk melakukan deployment ke Amazon Lightsail.

```sh
$ aws cloudformation create-stack \
--stack-name "lab-lightsail-nodejs-app" \
--template-body file:///$(pwd)/cloudformation/container-service.yaml \
--parameters ParameterKey=StepParam,ParameterValue=container_service
```

```json
{
    "StackId": "arn:aws:cloudformation:ap-southeast-1:ACCOUNT_ID:stack/lab-lightsail-nodejs-app/d47a2f10-b7df-11ec-9b9c-0ab1174fbbc8"
}
```

Perintah diatas membuat sebuah Contaienr service dengan nama **hello-api**. Lihat template CloudFormation untuk lebih detil.

Tunggu beberapa saat hingga stack selesai. Anda bisa masuk ke CloudFormation console untuk melihat atau menggunakan AWS CLI.

Setelah pembuatan stack selesai, lanjutkan dengan mengupload container image ke Container service **hello-api**.

```sh
$ aws lightsail push-container-image \
--region "ap-southeast-1" \
--service-name "hello-api" \
--label "idn-belajar-node" \
--image "idn-belajar-node:2.0"
```

```
...[CUR]...
Digest: sha256:84be0f3b648170b62551abbadbafda1234c1e6362470ecf0b94b3f767d067976
Image "idn-belajar-node:2.0" registered.
Refer to this image as ":hello-api.idn-belajar-node.11" in deployments.
```

Image berhasil diupload. Referensi untuk container image yang baru saja diupload adalah `:hello-api.idn-belajar-node.11`. Nomor `11` bisa saja berbeda ditempat anda. Hal ini karena saya sudah beberapa kali melakukan upload.

Langkah berikutnya adalah melakukan deployment container image pada container service **hello-api**. Kita akan melakukan update CloudFormation stack dengan memberikan parameter `deployment` untuk menginstruksikan pembuatan deployment.

```sh
$ aws cloudformation update-stack \
--stack-name "lab-lightsail-nodejs-app" \
--template-body file:///$(pwd)/cloudformation/container-service.yaml \
--parameters ParameterKey=StepParam,ParameterValue=deployment \
ParameterKey=ImageNameParam,ParameterValue=:hello-api.idn-belajar-node.11
```

```json
{
    "StackId": "arn:aws:cloudformation:ap-southeast-1:ACCOUNT_ID:stack/lab-lightsail-nodejs-app/d47a2f10-b7df-11ec-9b9c-0ab1174fbbc8"
}
```

Jika semua berjalan sukses maka pada halaman Amazon Lightsail Containers terdapat container service baru **hello-api**. Anda dapat mengakses API dari public domain yang berfungsi sebagai endpoint.

[![Lightsail Deploy from CloudFormation](https://raw.githubusercontent.com/rioastamal-examples/assets/main/workshop-amazon-lightsail-containers/lab-deploy-nodejs-app/images/lightsail-hello-api-cloudformation-deployment.png)](https://raw.githubusercontent.com/rioastamal-examples/assets/main/workshop-amazon-lightsail-containers/lab-deploy-nodejs-app/images/lightsail-hello-api-cloudformation-deployment.png)