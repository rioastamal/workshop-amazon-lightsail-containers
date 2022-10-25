
### <a name="step-1"></a>Step 1 - Requirements

Before starting the workshop, make sure you have an active AWS account and have installed requirements listed below.

- An active AWS account
- Docker
- AWS CLI v2 and its configuration
- Apache 2
- PHP 8.1
- Composer 2.3

To install PHP 8.1 and Apache 2 run following commnad.

```sh
docker pull public.ecr.aws/docker/library/php:8.1-apache
```

For Composer 2.3 run following command to install.

```sh
docker pull public.ecr.aws/docker/library/composer:2.3
```

Make sure those images are fully downloaded and exists on local machine.

```sh
docker images
```

```
REPOSITORY                               TAG          IMAGE ID       CREATED             SIZE
public.ecr.aws/docker/library/php        8.1-apache   9e0b7aff3bd6   38 hours ago        458MB
public.ecr.aws/docker/library/composer   2.3          a0dc29169f36   2 weeks ago         199MB
```


<table border="0" style="width: 100%; display: table;"><tr><td><a href="README.md">&laquo; Sebelumnya</td><td align="center"><a href="README.md">Daftar Isi</a></td><td align="right"><a href="STEP-2.md">Berikutnya &raquo;</a></td></tr></table>

<sup>Workshop: Deploy Laravel App dengan Amazon Lightsail Containers  
Version: 2022-24-06  
Author: [@rioastamal](https://github.com/rioastamal)</sup>
