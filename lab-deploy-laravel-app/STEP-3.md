
### <a name="step-3"></a>Step 3 - Download Contoh Aplikasi

Pada praktik ini sudah disediakan sebuah contoh aplikasi Markdown converter sederhana dibangun dengan Laravel.

Pastikan anda sedang berada pada `$HOME` direktori yaitu `/home/ec2-user`.

```sh
cd ~
pwd 
```

```
/home/ec2-user/
```

Download kode sumber dari GitHub menggunakan utilitas cURL.

```sh
curl -s -L -o 'hello-markdown.zip' \
'https://github.com/rioastamal-examples/laravel-hello-markdown/archive/refs/heads/main.zip'
```

Ekstrak file `hello-markdown.zip` ke direktori saat ini.

```sh
unzip hello-markdown.zip
```

Rename direktori hasil ekstrak menjadi `laravel-app`.

```sh
mv laravel-hello-markdown-main laravel-app
```

Kemudian masuk ke dalam direktori `laravel-app`. Kita akan bekerja dari dalam direktori ini.

```sh
cd laravel-app
```

Untuk melihat isinya gunakan perintah berikut.

```sh
ls -l
```

```
total 12
drwxrwxr-x  3 ec2-user ec2-user   27 Jun 24 13:49 apache2
-rw-rw-r--  1 ec2-user ec2-user  620 Jun 24 16:44 Dockerfile
drwxrwxr-x 13 ec2-user ec2-user 4096 Jun 24 16:55 laravel
-rw-rw-r--  1 ec2-user ec2-user 1068 Jun 24 13:57 LICENSE
```


<table border="0" style="width: 100%; display: table;"><tr><td><a href="STEP-2.md">&laquo; Sebelumnya</td><td align="center"><a href="README.md">Daftar Isi</a></td><td align="right"><a href="STEP-4.md">Berikutnya &raquo;</a></td></tr></table>

<sup>Workshop: Deploy Python Flask dengan Amazon Lightsail Containers  
Version: 2022-24-06  
Author: [@rioastamal](https://github.com/rioastamal)</sup>
