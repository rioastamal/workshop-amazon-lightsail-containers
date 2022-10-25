
### <a name="step-3"></a>Step 3 - Download Contoh Aplikasi

In this step we will download sampel app, a Markdown converter built with Laravel.

Make sure you're in `$HOME` directory which is `/home/ec2-user`.

```sh
cd ~
pwd 
```

```
/home/ec2-user/
```

Download source code from GitHub using cURL or your browser.

```sh
curl -s -L -o 'hello-markdown.zip' \
'https://github.com/rioastamal-examples/laravel-hello-markdown/archive/refs/heads/main.zip'
```

Extract `hello-markdown.zip` to current directory.

```sh
unzip hello-markdown.zip
```

Rename extracted directory to `laravel-app`.

```sh
mv laravel-hello-markdown-main laravel-app
```

Go to directory `laravel-app` as we will working within this directory.

```sh
cd laravel-app
```

Below is how the sample app files and directories are structured.

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


<table border="0" style="width: 100%; display: table;"><tr><td><a href="STEP-2.md">&laquo; Previous</td><td align="center"><a href="README.md">Index</a></td><td align="right"><a href="STEP-4.md">Next &raquo;</a></td></tr></table>

<sup>Workshop: Deploy Laravel App on Amazon Lightsail Containers  
Version: 2022-24-06  
Author: [@rioastamal](https://github.com/rioastamal)</sup>
