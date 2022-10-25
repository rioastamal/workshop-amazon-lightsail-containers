
### <a name="step-1"></a>Step 1 - Requirements

Before starting the workshop, make sure you have an active AWS account and have installed requirements listed below.

- Docker
- AWS CLI v2 and its configuration
- Python v3.8 dan pip via Docker

To install Python 3.8 using Docker use following command.

```sh
docker pull public.ecr.aws/docker/library/python:3.8-slim
```

```
3.8-slim: Pulling from docker/library/python
42c077c10790: Pull complete 
f63e77b7563a: Pull complete 
5215613c2da8: Pull complete 
9ca2d4523a14: Pull complete 
e97cee5830c4: Pull complete 
Digest: sha256:0e07cc072353e6b10de910d8acffa020a42467112ae6610aa90d6a3c56a74911
Status: Downloaded newer image for public.ecr.aws/docker/library/python:3.8-slim
public.ecr.aws/docker/library/python:3.8-slim
```

The above command will download a slim version of the Python 3.8 container image from the Amazon ECR public registry. To make sure the container image has been downloaded run command below.

```sh
docker images
```

```
REPOSITORY                             TAG          IMAGE ID       CREATED         SIZE
public.ecr.aws/docker/library/python   3.8-slim     61c56c60bb49   11 days ago     124MB
```

Next is try to run Python 3.8 interpreter using Docker.

```sh
docker run --rm \
public.ecr.aws/docker/library/python:3.8-slim \
python --version
```

```
Python 3.8.13
```

If you see output as above then congratulations you can now use Python 3.8 on your computer.


<table border="0" style="width: 100%; display: table;"><tr><td><a href="README.md">&laquo; Sebelumnya</td><td align="center"><a href="README.md">Daftar Isi</a></td><td align="right"><a href="STEP-2.md">Berikutnya &raquo;</a></td></tr></table>

<sup>Workshop: Deploy Python Flask dengan Amazon Lightsail Containers  
Version: 2022-14-06  
Author: [@rioastamal](https://github.com/rioastamal)</sup>
