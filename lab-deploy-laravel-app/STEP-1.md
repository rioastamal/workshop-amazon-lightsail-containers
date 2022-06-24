
### <a name="step-1"></a>Step 1 - Kebutuhan

Sebelum memulai workshop pastikan sudah memenuhi kebutuhan yang tercantum di bawah ini.

- Memiliki akun AWS aktif
- Sudah menginstal Docker
- Sudah menginstal AWS CLI v2 dan konfigurasinya
- Apache 2
- PHP 8.1
- Composer 2.3

Untuk menginstal PHP 8.1 dan Apache 2 gunakan perintah berikut.

```sh
docker pull public.ecr.aws/docker/library/php:8.1-apache
```

Untuk Composer 2.3 gunakan perintah berikut.

```sh
docker pull public.ecr.aws/docker/library/composer:2.3
```

Untuk memastikan image sudah ada pada lokal mesin, jalankan perintah ini.

```sh
docker images
```

```
REPOSITORY                               TAG          IMAGE ID       CREATED             SIZE
public.ecr.aws/docker/library/php        8.1-apache   9e0b7aff3bd6   38 hours ago        458MB
public.ecr.aws/docker/library/composer   2.3          a0dc29169f36   2 weeks ago         199MB
```


<table border="0" style="width: 100%; display: table;"><tr><td><a href="README.md">&laquo; Sebelumnya</td><td align="center"><a href="README.md">Daftar Isi</a></td><td align="right"><a href="STEP-2.md">Berikutnya &raquo;</a></td></tr></table>

<sup>Workshop: Deploy Python Flask dengan Amazon Lightsail Containers  
Version: 2022-24-06  
Author: [@rioastamal](https://github.com/rioastamal)</sup>
