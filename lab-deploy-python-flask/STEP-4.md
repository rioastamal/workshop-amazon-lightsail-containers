
### <a name="step-4"></a>Step 4 - Create Python Flask API

In this step we will create a simple API built using the popular Python web framework, Flask. The API will return cow characters and text in ASCII format. Similar to those found on utilities on Unix/Linux cowsay.

First create a file `requirements.txt` to list all packages used on this app using pip which is the package manager for Python.

```sh
echo '
cowsay~=4.0
Flask~=2.1.2
gunicorn~=20.1.0
' > requirements.txt
```

Since we are running Python via Docker we will mount local directory `python-app` to the Docker container. We do this because we will place the packages on the host computer, not in a container so that when the container is turned off the packages will not be lost.

We will mount `/home/ec2-user/python-app` to `/app` inside the container. All the packages installed by pip will be placed to `/app/libs` .

```sh
docker run -v $(pwd):/app --rm -it \
public.ecr.aws/docker/library/python:3.8-slim \
pip install -r /app/requirements.txt --target=/app/libs
```

If you use `ls` command, there should be a new directory `libs` whose owner is root.

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

Next create a new directory `src/` to place API source code.

```sh
mkdir src/
```

Create new file `src/index.py`, this is the main file for the API.

```sh
touch src/index.py
```

Copy and paste code below to `src/index.py`.

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

To run API server we will use a WSGI server, gunicorn. Create a shell script to run gunicorn in container.

```sh
touch run-server.sh
```

Copy this shell script code to file `run-server.sh`.

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

Run gunicurn using Docker.

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

You can test by issuing HTTP request to localhost port `8080` and path `/`.

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

Let's do another request by adding parameter to the query string. Send a `text` paramter with value `Hello%20Indonesia%20Belajar`. String `%20` represent space.

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

Cool! Our API is run as expected. It's time to package this API into a container image. Press `CTRL+C` to stop the container.


<table border="0" style="width: 100%; display: table;"><tr><td><a href="STEP-3.md">&laquo; Sebelumnya</td><td align="center"><a href="README.md">Daftar Isi</a></td><td align="right"><a href="STEP-5.md">Berikutnya &raquo;</a></td></tr></table>

<sup>Workshop: Deploy Python Flask dengan Amazon Lightsail Containers  
Version: 2022-14-06  
Author: [@rioastamal](https://github.com/rioastamal)</sup>
