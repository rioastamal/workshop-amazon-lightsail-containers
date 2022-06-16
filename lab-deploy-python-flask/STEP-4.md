
### <a name="step-4"></a>Step 4 - Membuat Python Flask API

Pada langkah ini kita akan membuat sebuah API sederhana yang dibangun menggunakan web framework di Python yang populer yaitu Flask. API yang dibuat akan mengembalikan karakter sapi dan teks dalam format ASCII. Mirip dengan yang ditemukan pada utilitas di Unix/Linux `cowsay`.

Pertama kita buat file `requirements.txt` untuk menginstal ketergantungan pustaka menggunakan pip yaitu package manager untuk Python.

```sh
echo '
cowsay~=4.0
Flask~=2.1.2
gunicorn~=20.1.0
' > requirements.txt
```

Karena kita menjalankan Python via Docker maka kita akan melakukan mount lokal direktori `python-app` ke Docker container. Hal ini kita lakukan karena pustaka akan kita tempatkan di komputer host bukan di dalam container agar ketika container dimatikan pustaka tersebut tidak ikut hilang.

Direktori `/home/ec2-user/python-app` akan kita mount ke `/app` di dalam container. Semua paket yang diinstal oleh pip akan dimasukkan ke `/app/libs`.

```sh
docker run -v $(pwd):/app --rm -it \
public.ecr.aws/docker/library/python:3.8-slim \
pip install -r /app/requirements.txt --target=/app/libs
```

Jika digunakan perintah `ls`, maka sekarang harusnya terdapat direktori baru `libs/` yang ownernya adalah root.

```sh
ls -l libs/
```

```
total 112
drwxr-xr-x 2 root root 4096 Jun 15 09:10 bin
...
drwxr-xr-x 3 root root 4096 Jun 15 09:10 cowsay
drwxr-xr-x 4 root root 4096 Jun 15 09:10 flask
drwxr-xr-x 2 root root 4096 Jun 15 09:10 Flask-2.1.2.dist-info
drwxr-xr-x 7 root root 4096 Jun 15 09:10 gunicorn
drwxr-xr-x 2 root root 4096 Jun 15 09:10 gunicorn-20.1.0.dist-info
....
```

Selanjutnya buat sebuah direktori baru bernama `src/` untuk menempatkan kode sumber.

```sh
mkdir src/
```

Buat sebuah file `src/index.py`, ini adalah file utama dimana kode API yang akan kita buat.

```sh
touch src/index.py
```

Salin kode di bawah ini dan masukkan ke dalam file `src/index.py`.

```py
from flask import Flask
from flask import request
import cowsay

app = Flask(__name__)

@app.route('/')
def main():
    text = request.args.get('text')
    if text == None:
        text = '''\
I do not understand what you're saying!
.
Usage:
/?text=TEXT
.
Where:
 TEXT is text you want to say.\
'''

    the_text = cowsay.get_output_string('cow', text)
    return the_text, 200, { 'content-type': 'text/plain' }
```

Untuk menjalankan API server kita akan menggunakan WSGI server yaitu gunicorn. Buat sebuah shell script untuk menjalankan gunicorn di dalam container.

```sh
#!/bin/bash
# This script intended to be run inside a container

export PYTHONPATH=/app/libs

# Run gunicorn WSGI server
[ -z "$APP_BIND" ] && APP_BIND='0.0.0.0:8080'
[ -z "$APP_WORKER" ] && APP_WORKER=4
$PYTHONPATH/bin/gunicorn \
 -w $APP_WORKER \
 -b $APP_BIND \
 --chdir /app/src 'index:app'
```

Eksekusi gunicorn WSGI server menggunakan Docker.

```sh
docker run -v $(pwd):/app --rm -it -p 8080:8080 \
public.ecr.aws/docker/library/python:3.8-slim \
bash /app/run-server.sh
```

```
[2022-06-15 09:28:21 +0000] [8] [INFO] Starting gunicorn 20.1.0
[2022-06-15 09:28:21 +0000] [8] [INFO] Listening at: http://0.0.0.0:8080 (8)
[2022-06-15 09:28:21 +0000] [8] [INFO] Using worker: sync
[2022-06-15 09:28:21 +0000] [10] [INFO] Booting worker with pid: 10
[2022-06-15 09:28:22 +0000] [11] [INFO] Booting worker with pid: 11
[2022-06-15 09:28:22 +0000] [12] [INFO] Booting worker with pid: 12
[2022-06-15 09:28:22 +0000] [13] [INFO] Booting worker with pid: 13
```

Tes dengan melakukan HTTP request pada localhost port `8080` path `/` dan tanpa mengirimkan parameter apapun.

```sh
curl -s -D /dev/stderr 'http://localhost:8080/'
```

```
HTTP/1.1 200 OK
Server: gunicorn
Date: Thu, 16 Jun 2022 04:15:16 GMT
Connection: close
content-type: text/plain
Content-Length: 833

  _______________________________________
 /                                       \
| I do not understand what you're saying! |
| .                                       |
| Usage:                                  |
| /?text=TEXT                             |
| .                                       |
| Where:                                  |
| TEXT is text you want to say.           |
 \                                       /
  =======================================
                                       \
                                        \
                                          ^__^
                                          (oo)\_______
                                          (__)\       )\/\
                                              ||----w |
                                              ||     ||
```

Sekarang mari kita coba kirimkan parameter `text` dengna nilai `Hello%20Indonesia%20Belajar`. Kode `%20` mengindikasikan spasi.

```sh
curl -s 'http://localhost:8080/?text=Hello%20Indonesia%20Belajar'
```

```
  _______________________
| Hello Indonesia Belajar |
  =======================
                       \
                        \
                          ^__^
                          (oo)\_______
                          (__)\       )\/\
                              ||----w |
                              ||     ||
```

Keren. API kita sudah bisa berjalan sesuai harapan. Saatnya memaket menjadi container image. Tekan `CTRL+C` untuk menghentikan container.


<table border="0" style="width: 100%; display: table;"><tr><td><a href="STEP-3.md">&laquo; Sebelumnya</td><td align="center"><a href="README.md">Daftar Isi</a></td><td align="right"><a href="STEP-5.md">Berikutnya &raquo;</a></td></tr></table>

<sup>Workshop: Deploy Python Flask dengan Amazon Lightsail Containers  
Version: 2022-14-06  
Author: [@rioastamal](https://github.com/rioastamal)</sup>
