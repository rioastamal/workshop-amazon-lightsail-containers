
### <a name="step-1"></a>Step 1 - Kebutuhan

Sebelum memulai workshop pastikan sudah memenuhi kebutuhan yang tercantum di bawah ini.

- Memiliki akun AWS aktif
- Sudah menginstal Docker
- Sudah menginstal AWS CLI v2 dan konfigurasinya
- Python v3.8 dan pip via Docker

Untuk menginstal Python 3.8 menggunakan Docker gunakan perintah berikut.

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

Perintah diatas akan mendownload container image Python 3.8 versi slim dari registry publik Amazon ECR. Untuk memastikan container image telah didownload gunakan perintah.

```sh
docker images
```

```
REPOSITORY                             TAG          IMAGE ID       CREATED         SIZE
public.ecr.aws/docker/library/python   3.8-slim     61c56c60bb49   11 days ago     124MB
```

Jalankan perintah di bawah ini untuk mencoba menjalankan container Python 3.8.

```sh
docker run --rm \
public.ecr.aws/docker/library/python:3.8-slim \
python --version
```

```
Python 3.8.13
```

Jika output dari shell seperti di atas maka selamat anda sekarang bisa menggunakan Python 3.8 di komputer anda.


<table border="0" style="width: 100%; display: table;"><tr><td><a href="README.md">&laquo; Sebelumnya</td><td align="center"><a href="README.md">Daftar Isi</a></td><td align="right"><a href="STEP-2.md">Berikutnya &raquo;</a></td></tr></table>

<sup>Workshop: Deploy Python Flask dengan Amazon Lightsail Containers  
Version: 2022-14-06  
Author: [@rioastamal](https://github.com/rioastamal)</sup>
