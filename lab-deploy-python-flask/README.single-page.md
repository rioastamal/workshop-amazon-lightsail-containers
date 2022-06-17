<a name="top"></a>

<!-- begin step-0 -->

## Workshop Deploy Python Flask dengan Amazon Lightsail Containers

Pada workshop ini peserta akan mempraktikkan bagaimana melakukan deployment sebuah API menggunakan Amazon Lightsail Containers. Sebuah API sederhana dibangun dengan Python dan micro web framework Flask akan digunakan sebagai contoh pada praktik ini.

Peserta dapat mengikuti panduan workshop melalui step-step atau langkah-langkah yang telah disediakan secara berurutan mulai dari step 1 hingga step 15.

- [Step 1 - Kebutuhan](#step-1)
- [Step 2 - Menginstal Lightsail Control Plugin](#step-2)
- [Step 3 - Membuat Direktori untuk Project](#step-3)
- [Step 4 - Membuat Python Flask API](#step-4)
- [Step 5 - Membuat Container Image](#step-5)
- [Step 6 - Membuat Container Service di Amazon Lightsail](#step-6)
- [Step 7 - Push Container Image ke Amazon Lightsail](#step-7)
- [Step 8 - Deploy Container](#step-8)
- [Step 9 - Membuat Versi Baru dari API](#step-9)
- [Step 10 - Update Container Image](#step-10)
- [Step 11 - Push Container Image Versi Terbaru](#step-11)
- [Step 12 - Deploy Versi Terbaru dari API](#step-12)
- [Step 13 - Menambah Jumlah Node](#step-13)
- [Step 14 - Rollback API ke Versi Sebelumnya](#step-14)
- [Step 15 - Menghapus Amazon Lightsail Container Service](#step-15)

Jika anda lebih menyukai semua langkah dalam satu halaman maka silahkan membuka file [README.single-page.md](README.single-page.md).

<!-- end step-0 -->

<!-- begin step-1 -->

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

[^back to top](#top)

<!-- end step-1 -->

<!-- begin step-2 -->

### <a name="step-2"></a>Step 2 - Menginstal Lightsail Control Plugin

Plugin CLI ini digunakan untuk mengupload container image dari komputer lokal ke Amazon Lightsail container service. Jalankan perintah berikut untuk menginstal Lightsail Control Plugin. Diasumsikan bahwa terdapat perintah `sudo` pada distribusi Linux yang anda gunakan.

```sh
sudo curl "https://s3.us-west-2.amazonaws.com/lightsailctl/latest/linux-amd64/lightsailctl" -o "/usr/local/bin/lightsailctl"
```

Tambahkan atribut _execute_ pada file `lightsailctl` yang baru saja didownload.

```sh
sudo chmod +x /usr/local/bin/lightsailctl
```

Pastikan atribut _execute_ sudah teraplikasikan ke file.

```sh
ls -l /usr/local/bin/lightsailctl
```

```
-rwxr-xr-x 1 root root 13201408 May 28 03:16 /usr/local/bin/lightsailctl
```

Itu ditandai dengan adanya huruf `x` pada daftar atribut, contohnya `-rwxr-xr-x`.

[^back to top](#top)

<!-- end step-2 -->

<!-- begin step-3 -->

### <a name="step-3"></a>Step 3 - Membuat Direktori untuk Project

Pastikan anda sedang berada pada `$HOME` direktori yaitu `/home/ec2-user`.

```sh
cd ~
pwd 
```

```
/home/ec2-user/
```

Kemudian buat sebuah direktori baru bernama `python-app`.

```sh
mkdir python-app
```

Masuk pada direktori tersebut. Kita akan menempatkan file-file yang diperlukan disana.

```sh
cd python-app
pwd
```

```
/home/ec2-user/python-app
```

[^back to top](#top)

<!-- end step-3 -->

<!-- begin step-4 -->

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
touch run-server.sh
```

Salin kode shell script di bawah ke dalam file `run-server.sh`.

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

Sekarang mari kita coba kirimkan parameter `text` dengan nilai `Hello%20Indonesia%20Belajar`. Kode `%20` mengindikasikan spasi.

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

[^back to top](#top)

<!-- end step-4 -->

<!-- begin step-5 -->

### <a name="step-5"></a>Step 5 - Membuat Container Image

Untuk membuat container image dari layanan API yang baru dibuat kita akan menggunakan Docker.

Pastikan dulu telah berada pada direktori `python-app/`.

```
cd ~/python-app/
```

Buat sebuah file baru dengan nama `Dockerfile`. File ini akan berisi perintah-perintah dalam membangun container image. Letakkan file ini di dalam root direktori project yaitu `python-app/`.

```sh
touch Dockerfile
```

Salin kode dibawah ini dan masukkan ke dalam file `Dockerfile`.

```dockerfile
FROM public.ecr.aws/docker/library/python:3.8-slim

RUN mkdir -p /app
COPY requirements.txt run-server.sh /app/
COPY src/index.py /app/src/

WORKDIR /app
RUN pip install -r requirements.txt --target=/app/libs

ENTRYPOINT ["bash", "/app/run-server.sh"]
```

Pada kode di atas, kita menggunakan Python versi 3.8 yang diambil dari Amazon ECR public repository. Kemudian menyalin file-file yang diperlukan ke dalam container dan menjalankan `pip install` untuk mendapatkan semua ketergantungan pustaka yang ada di `requirements.txt`. Pustaka yang diinstal oleh pip akan ditempatkan di `/app/libs/`.

Kita akan menamakan container image ini dengan nama `indonesia-belajar` dengan versi `1.0`. Untuk mulai membangun container image jalankan perintah berikut. Perhatikan ada `.` titik diakhir perintah.

```sh
docker build --rm -t indonesia-belajar:1.0 .
```

```
Sending build context to Docker daemon  11.65MB
...[CUT]...
Step 7/7 : ENTRYPOINT ["bash", "/app/run-server.sh"]
 ---> Running in 4b6b9075a846
Removing intermediate container 4b6b9075a846
 ---> 32dc2a5baec9
Successfully built 32dc2a5baec9
Successfully tagged indonesia-belajar:1.0
```

Pastikan image tersebut ada dalam daftar image di lokal mesin.

```sh
docker images indonesia-belajar
```

```
REPOSITORY          TAG       IMAGE ID       CREATED          SIZE
indonesia-belajar   1.0       32dc2a5baec9   11 seconds ago   144MB
```

Dapat terlihat jika container image yang dibuat yaitu `indonesia-belajar` dengan versi `1.0` berhasil dibuat.

Sekarang coba jalankan container `indonesia-belajar:1.0` pada port `8080` untuk memastikan API yang dibuat dapat berjalan pada container.

```sh
docker run --rm --name idn_belajar_1_0 -p 8080:8080 -d indonesia-belajar:1.0
```

```
da1a191143ed8b030e6e3d7536871821a35627384fdfe856114ae26406c1220b
```

Kemudian cek untuk memastikan container `indonesia-belajar:1.0` sedang berjalan.

```sh
docker ps
```

```
CONTAINER ID   IMAGE                   COMMAND                  CREATED         STATUS         PORTS                                       NAMES
da1a191143ed   indonesia-belajar:1.0   "bash /app/run-serve…"   9 seconds ago   Up 7 seconds   0.0.0.0:8080->8080/tcp, :::8080->8080/tcp   idn_belajar_1_0
```

Jalankan `curl` untuk melakukan HTTP request ke localhost port `8080` dan teks "Hello Indonesia Belajar".

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

Mantab! API dapat berjalan dengan sempurna di container. Sekarang stop container tersebut.

```sh
docker stop idn_belajar_1_0
```

[^back to top](#top)

<!-- end step-5 -->

<!-- begin step-6 -->

### <a name="step-6"></a>Step 6 - Membuat Container Service di Amazon Lightsail

Container service adalah sumber daya komputasi tempat dimana container dijalankan. Container service memiliki banyak pilihan kapasitas RAM dan vCPU yang bisa dipilih sesuai dengan kebutuhan aplikasi. Selain itu anda juga bisa menentukan jumlah node yang berjalan.

1. Sekarang masuk ke AWS Management Console kemudian masuk ke halaman Amazon Lightsail. Pada dashboard Amazon Lightsail klik menu **Containers**.

[![Lightsail Containers Menu](https://raw.githubusercontent.com/rioastamal-examples/assets/main/workshop-amazon-lightsail-containers/lab-deploy-nodejs-app/images/lightsail-menu-containers.png)](https://raw.githubusercontent.com/rioastamal-examples/assets/main/workshop-amazon-lightsail-containers/lab-deploy-nodejs-app/images/lightsail-menu-containers.png)

> Gambar 1. Menu Containers pada Amazon Lightsail

2. Pada halaman Containers klik tombol **Create Instance** untuk mulai membuat sebuah Container service.

[![Lightsail Create Instance Button](https://raw.githubusercontent.com/rioastamal-examples/assets/main/workshop-amazon-lightsail-containers/lab-deploy-nodejs-app/images/lightsail-button-create-instance.png)](https://raw.githubusercontent.com/rioastamal-examples/assets/main/workshop-amazon-lightsail-containers/lab-deploy-nodejs-app/images/lightsail-button-create-instance.png)

> Gambar 2. Halaman Containers yang berisi daftar container yang telah dibuat

3. Kemudian kita akan dihadapkan beberapa pilihan. Pada pilihan _Container service location_ pilih region **Singapore**. Klik link **Change AWS Region** untuk melakukannya. Pada pilihan kapasitas container pilih **Nano** dengan RAM 512MB dan vCPU 0.25. Pilihan _Choose the scale_ adalah untuk menentukan jumlah container yang akan diluncurkan, pilih **x1**. Artinya kita hanya akan meluncurkan 1 buah container.

[![Lightsail Choose Container Capacity](https://raw.githubusercontent.com/rioastamal-examples/assets/main/workshop-amazon-lightsail-containers/lab-deploy-nodejs-app/images/lightsail-choose-container-capacity.png)](https://raw.githubusercontent.com/rioastamal-examples/assets/main/workshop-amazon-lightsail-containers/lab-deploy-nodejs-app/images/lightsail-choose-container-capacity.png)

> Gambar 3. Memilih region dan kapasitas dari container

4. Lanjut pada pilihan selanjutnya adalah menentukan nama layanan. Pada bagian _Identify your service_ isi dengan **hello-api**. Pastikan pada bagian _Summary_ bahwa kita akan meluncurkan sebuah container dengan kapasitas **Nano** (512MB RAM, 0.25 vCPU) sebanyak **x1**. Total biaya untuk kapasitas tersebut adalah **$7 USD** per bulan. Jika sudah sesuai maka klik tombol **Create container service** untuk menyelesaikan pembuatan container service.

[![Lightsail Choose Service Name](https://raw.githubusercontent.com/rioastamal-examples/assets/main/workshop-amazon-lightsail-containers/lab-deploy-nodejs-app/images/lightsail-choose-service-name.png)](https://raw.githubusercontent.com/rioastamal-examples/assets/main/workshop-amazon-lightsail-containers/lab-deploy-nodejs-app/images/lightsail-choose-service-name.png)

> Gambar 4. Memasukkan nama container service

5. Setelah itu Lightsail akan mulai memproses pembuatan container service **hello-api**. Ini akan memakan waktu beberapa menit, jadi mohon ditunggu. Setelah selesai anda akan dibawa ke dashboard dari halaman container service **hello-api**. ANda akan mendapat domain yang digunakan untuk mengakses container. Domain tersebut terlihat di bagian _Public domain_. Tunggu hingga status menjadi **Ready** kemudian klik domain tersebut untuk membuka aplikasi **hello-api**. Ketika domain tersebut dikunjungi harusnya terdapat error 404 karena belum ada container image yang dideploy pada **hello-api**.

[![Lightsail hello-api Dashboard](https://raw.githubusercontent.com/rioastamal-examples/assets/main/workshop-amazon-lightsail-containers/lab-deploy-nodejs-app/images/lightsail-hello-api-dashboard.png)](https://raw.githubusercontent.com/rioastamal-examples/assets/main/workshop-amazon-lightsail-containers/lab-deploy-nodejs-app/images/lightsail-hello-api-dashboard.png)

> Gambar 5. Dashboard dari container service hello-api

[![Lightsail hello-api 404](https://raw.githubusercontent.com/rioastamal-examples/assets/main/workshop-amazon-lightsail-containers/lab-deploy-nodejs-app/images/lightsail-404-hello-api.png)](https://raw.githubusercontent.com/rioastamal-examples/assets/main/workshop-amazon-lightsail-containers/lab-deploy-nodejs-app/images/lightsail-404-hello-api.png)

> Gambar 6. Layanan hello-api masih 404 karena belum ada container image yang dideploy

[^back to top](#top)

<!-- end step-6 -->

<!-- begin step-7 -->

### <a name="step-7"></a>Step 7 - Push Container Image ke Amazon Lightsail

Setiap container image yang di-push ke Amazon Lightsail terikat pada sebuah Container service. Karena itulah kita membuat **hello-api** Container service terlebih dahulu sebelum melakukan push container image.

Pada langkah ini kita akan melakukan push container image `indonesia-belajar:1.0` yang telah dibuat sebelumnya ke Container service **hello-api**. Jalankan perintah dibawah ini.

```sh
aws lightsail push-container-image \
--region "ap-southeast-1" \
--service-name "hello-api" \
--label "indonesia-belajar" \
--image "indonesia-belajar:1.0"
```

```
...[CUT]...
ad6562704f37: Pushed 
Digest: sha256:476291c73ec25649423be818454f51ea2185f436f00edb81fbce1da0a6ec2f5e
Image "indonesia-belajar:1.0" registered.
Refer to this image as ":hello-api.indonesia-belajar.12" in deployments.
```

Jika berhasil maka anda akan mendapatkan pesan mirip seperti diatas. Container image akan disimpan dengan penamaan `:<container-service>:<label>.<versi-upload>` pada contoh diatas penamaannya adalah `:hello-api.indonesia-belajar.12`.

Sekarang pastikan container image tersebut ada dalam daftar container yang telah diupload. Masuk ke halaman dashboard dari container service **hello api** kemudian masuk ke halaman **Images**.

[![Lightsail hello-api Image](https://raw.githubusercontent.com/rioastamal-examples/assets/main/workshop-amazon-lightsail-containers/lab-general-app/images/lightsail-hello-api-image.png)](https://raw.githubusercontent.com/rioastamal-examples/assets/main/workshop-amazon-lightsail-containers/lab-general-app/images/lightsail-hello-api-image.png)

> Gambar 7. Daftar container image yang telah diupload

Pada halaman _Images_ dapat terlihat jika terdapat sebuah image `:hello-api.indonesia-belajar.12` seperti yang telah diupload pada proses sebelumnya. Kita akan menggunakan image ini untuk melakukan deployment.

[^back to top](#top)

<!-- end step-7 -->

<!-- begin step-8 -->

### <a name="step-8"></a>Step 8 - Deploy Container

Proses ini digunakan untuk menempatkan container yang akan dijalankan ke Container service yang telah tersedia. Pada contoh ini kita telah membuat sebuah Container service dengan nama **hello-api** dengan kapasitas 512MB RAM dan 0.25 vCPU dan hanya berjumlah 1.

1. Pada halaman dashboard **hello-api** klik menu **Deployments** kemudian klik link **Create your first deployment**.

[![Lightsail Create Deployment](https://raw.githubusercontent.com/rioastamal-examples/assets/main/workshop-amazon-lightsail-containers/lab-deploy-nodejs-app/images/lightsail-hello-api-deployments-menu.png)](https://raw.githubusercontent.com/rioastamal-examples/assets/main/workshop-amazon-lightsail-containers/lab-deploy-nodejs-app/images/lightsail-hello-api-deployments-menu.png)

> Gambar 8. Membuka halaman deployment

2. Terdapat beberapa isian yang harus dilengkapi. Pertama isikan **hello-idn-belajar** untuk _Container name_. 
3. Pada pilihan _Image_ klik **Choose stored image** untuk memilih container image yang sudah diupload sebelumnya. Pilih versi container image yang telah diupload.
4. Aplikasi menggunakan dua opsional environment variable yaitu `APP_WORKER` dan `APP_BIND`. `APP_WORKER` menentukan jumlah gunicorn worker (default 4) dan `APP_BIND` menentukan bind address dan nomor port (default `0.0.0.0:8080`). Kendati opsional pada contoh ini kita tetap mengisikan secara eksplisit.
5. Pada konfigurasi **Open ports** gunakan nomor port dimana aplikasi berjalan. Dalam hal ini sama dengan nilai dari `APP_BIND` yaitu `8080`. 
6. Untuk **PUBLIC ENDPOINT** gunakan container **hello-idn-belajar** yang telah diinput pada bagian sebelumnya. Container service yang berjalan pada public domain akan melakukan koneksi pada `8080` yang dikonfigurasi pada **Open ports**.
7. Jika semua sudah sesuai, klik **Save and deploy** untuk melakukan deployment. Proses ini akan memakan waktu beberapa menit. Tunggu hingga status dari Container service menjadi **Running**.

[![Lightsail Configure Deployment](https://raw.githubusercontent.com/rioastamal-examples/assets/main/workshop-amazon-lightsail-containers/lab-general-app/images/lightsail-hello-api-configure-deployment.png)](https://raw.githubusercontent.com/rioastamal-examples/assets/main/workshop-amazon-lightsail-containers/lab-general-app/images/lightsail-hello-api-configure-deployment.png)

> Gambar 9. Konfigurasi deployment untuk container

Jika status sudah **Running** maka kita dapat mencoba untuk mengakses aplikasi dengan membuka URL yang ada di public domain. Perlu dicatat jika protocol yang digunakan adalah HTTPS. Dalam contoh ini saya menggunakan `curl` untuk melakukan tes. Sesuaikan dengan public domain anda sendiri.

```sh
curl -s 'https://YOUR_OWN_CONTAINER_SERVICE_PUBLIC_DOMAIN/?text=Hello%20Indonesia%20Belajar'
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

Selamat! anda telah sukses melakukan deployment sebuah aplikasi Python Flask menggunakan Amazon Lightsail Container service. Cukup mudah bukan?

[^back to top](#top)

<!-- end step-8 -->

<!-- begin step-9 -->

### <a name="step-9"></a>Step 9 - Membuat Versi Baru dari API

Setiap aplikasi hampir pasti akan selalu mengalami proses update entah itu untuk perbaikan atau penambahan fitur. Pada workshop ini kita akan coba mendemonstrasikan bagaimana melakukan update dari aplikasi menggunakan Amazon Lightsail Container service.

Dalam contoh ini kita akan mengubah kode API dengan mengubah karakter dari sapi ke banyak karakter lain, seperti: 'beavis', 'cheese', 'daemon', 'cow', 'dragon', 'ghostbusters', 'kitty', 'meow', 'milk', 'pig', 'stegosaurus', 'stimpy', 'trex', 'turkey', 'turtle', 'tux'.

Pastikan anda berada pada direktori `python-app`. Kemudian ubah isi dari file `src/index.py` menjadi seperti di bawah.

```py
from flask import Flask
from flask import request
import cowsay
import socket

app = Flask(__name__)

@app.route('/')
def main():
    try:
        the_character = request.args.get('char')
        index_char = list(cowsay.char_names).index(the_character)
    except:
        the_character = 'cow'

    local_ip = socket.gethostbyname(socket.gethostname())

    text = request.args.get('text')
    if text == None:
        text = '''\
I do not understand what you're saying!
.
Usage:
/?text=TEXT&char=CHARACTER
.
Where:
 TEXT      Text you want to say.
 CHARACTER The character: 'cow', 'tux', etc.
          See https://pypi.org/project/cowsay/\
'''

    the_text = cowsay.get_output_string(the_character, text)
    the_text = "%s\nMy Local IP: %s" % (the_text, local_ip)
    return the_text, 200, { 'content-type': 'text/plain' }
```

Terlihat kita menambahkan parameter baru pada inputan query string yaitu `char`. Dimana ini akan menentukan karakter yang ditampilkan selain `cow` seperti `tux`, `dragon`, `ghostbusters` dan lain-lain. Selain itu pada bagian bawah kita juga menampilkan alamat ip lokal server yang berjalan.

Jalankan kembali aplikasi kita melalui Docker.

```sh
docker run -v $(pwd):/app --rm -it -p 8080:8080 \
public.ecr.aws/docker/library/python:3.8-slim \
bash /app/run-server.sh
```

Kemudian lakukan HTTP request ke path `/` dengan mengirimkan parameter `text` dan `char` di query string.

```sh
curl -s 'http://localhost:8080/?text=Hello%20Indonesia%20Belajar&char=tux'
```

```
  _______________________
| Hello Indonesia Belajar |
  =======================
                            \
                             \
                              \
                               .--.
                              |o_o |
                              |:_/ |
                             //   \ \
                            (|     | )
                           /'\_   _/`\
                           \___)=(___/
My Local IP: 172.17.0.2
```

Dapat terlihat bahwa sekarang karakter yang muncul adalah `tux` (pinguin) dan terdapat alamat IP lokal dari server.

[^back to top](#top)

<!-- end step-9 -->

<!-- begin step-10 -->

### <a name="step-10"></a>Step 10 - Update Container Image

API versi terbaru sudah siap, saatnya melakukan update untuk container image `indonesia-belajar`. Kita akan merilis API versi terbaru ini dengan tag `2.0`. Untuk melakukannya ikuti langkah berikut.

```sh
docker build --rm -t indonesia-belajar:2.0 .
```

```
...[CUT]...
Step 7/7 : ENTRYPOINT ["bash", "/app/run-server.sh"]
 ---> Running in 0f0a8b970ba4
Removing intermediate container 0f0a8b970ba4
 ---> b3846915d8d0
Successfully built b3846915d8d0
Successfully tagged indonesia-belajar:2.0
```

Kita lihat apakah container image baru tersebut sudah ada dalam daftar container image pada mesin kita.

```sh
docker images indonesia-belajar
```

```
REPOSITORY          TAG       IMAGE ID       CREATED         SIZE
indonesia-belajar   2.0       b3846915d8d0   6 seconds ago   144MB
indonesia-belajar   1.0       32dc2a5baec9   4 hours ago     144MB
```

Jalankan container versi baru tersebut untuk memastikan API berjalan sesuai harapan. 

```sh
docker run --rm --name idn_belajar_2_0 -p 8080:8080 -d indonesia-belajar:2.0
```

```
d8df1a6d0dbd70de4cd36ff21e5b6a766a7bb0c21d28819d37fdff612aefe23c
```

Lakukan HTTP request ke `localhost:8080` untuk melakukan tes respon dari API.

```sh
curl -s 'http://localhost:8080/?text=Hello%20Indonesia%20Belajar&char=milk'
```

```
  _______________________
| Hello Indonesia Belajar |
  =======================
                       \
                        \
                         \
                          \
                              ____________
                              |__________|
                             /           /\
                            /           /  \
                           /___________/___/|
                           |          |     |
                           |  ==\ /== |     |
                           |   O   O  | \ \ |
                           |     <    |  \ \|
                          /|          |   \ \
                         / |  \_____/ |   / /
                        / /|          |  / /|
                       /||\|          | /||\/
                           -------------|
                               | |    | |
                              <__/    \__>
My Local IP: 172.17.0.2
```

Dapat terlihat jika respon dari API menampilkan karakter `milk` (susu).

[^back to top](#top)

<!-- end step-10 -->

<!-- begin step-11 -->

### <a name="step-11"></a>Step 11 - Push Container Image Versi Terbaru

Kita sudah pernah melakukan upload container image `indonesia-belajar:1.0` ke Container service **hello-api**. Karena sudah ada versi terbaru yaitu `indonesia-belajar:2.0` maka kita juga harus melakukan push container image ini ke **hello-api**. Jalankan perintah di bawah ini.

```sh
aws lightsail push-container-image \
--region "ap-southeast-1" \
--service-name "hello-api" \
--label "indonesia-belajar" \
--image "indonesia-belajar:2.0"
```

```
...[CUT]...
ad6562704f37: Layer already exists 
Digest: sha256:4233e2c6f9650a3a860f113543f6bc8c0d294edfb976574b21ca33a528a635e7
Image "indonesia-belajar:2.0" registered.
Refer to this image as ":hello-api.indonesia-belajar.13" in deployments.
```

Pada kasus milik saya image yang tersimpan di Container service adalah `:hello-api.indonesia-belajar.13`. Nomor versi upload `.13` bisa berbeda dengan milik anda.

Untuk memastikan container telah terupload dengan sukses masuk pada dashboard Container service **hello-api** dan klik menu **Images**. Harusnya image sudah muncul di halaman tersebut.

[![Lightsail Container New Image](https://raw.githubusercontent.com/rioastamal-examples/assets/main/workshop-amazon-lightsail-containers/lab-general-app/images/lightsail-hello-api-new-image.png)](https://raw.githubusercontent.com/rioastamal-examples/assets/main/workshop-amazon-lightsail-containers/lab-general-app/images/lightsail-hello-api-new-image.png)

> Gambar 10. Container image versi terbaru

[^back to top](#top)

<!-- end step-11 -->

<!-- begin step-12 -->

## <a name="step-12"></a>Step 12 - Deploy Versi Terbaru dari API

Setelah container image versi terbaru `indonesia-belajar:2.0` diupload ke Amazon Lightsail Containers maka kita dapat melakukan deployment versi terbaru dari API menggunakan image tersebut.

1. Masuk pada halaman dashboard Contianer service **hello-api** dan pastikan berada pada halaman _Deployments_.
2. Klik tombol **Modify your deployment**, maka akan terbuka halaman konfigurasi yang sama ketika membuat deployment baru.
3. Konfigurasi yang perlu diubah adalah container image yang digunakan. Klik tombol **Choose stored image** kemudian pilih versi terbaru dari container image yang diupload.
4. Sisanya tidak perlu diubah, untuk memulai deployment klik tombol **Save and deploy**.
5. Tunggu beberapa menit hidda status berubah menjadi **Running** kembali.

[![Lightsail Update Deployment](https://raw.githubusercontent.com/rioastamal-examples/assets/main/workshop-amazon-lightsail-containers/lab-general-app/images/lightsail-hello-api-modify-deployment.png)](https://raw.githubusercontent.com/rioastamal-examples/assets/main/workshop-amazon-lightsail-containers/lab-general-app/images/lightsail-hello-api-modify-deployment.png)

> Gambar 11. Deployment versi terbaru dari container

Setelah status kembali menjadi **Running** saatnya mengakses API versi terbaru apakah sudah menampilkan respon yang diinginkan. Gunakan web browser atau `curl` seperti di bawah untuk mengakses. Sesuaikan dengan URL dari container service anda sendiri.

```sh
curl -s 'https://YOUR_OWN_CONTAINER_SERVICE_PUBLIC_DOMAIN/?text=Hello%20Indonesia%20Belajar&char=beavis'
```

```
  _______________________
| Hello Indonesia Belajar |
  =======================
                            \
                             \
                              \
                                    _------~~-,
                                 ,'            ,
                                 /               \\
                                /                :
                               |                  '
                               |                  |
                               |                  |
                                |   _--           |
                                _| =-.     .-.   ||
                                o|/o/       _.   |
                                /  ~          \\ |
                              (____\@)  ___~    |
                                 |_===~~~.`    |
                              _______.--~     |
                              \\________       |
                                       \\      |
                                     __/-___-- -__
                                    /            _ \\
                                    
My Local IP: 172.17.0.2
```

Keren! API terbaru sudah berhasil dideploy. Output dari API sekarang menyertakan alamat ip lokal di server yang pada versi sebelumnya tidak ada.

[^back to top](#top)

<!-- end step-12 -->

<!-- begin step-13 -->

### <a name="step-13"></a>Step 13 - Menambah Jumlah Node

Ketika anda ingin meningkatkan kemampuan aplikasi dalam merespon _traffic_ salah satu cara yang bisa dilakukan adalah dengan melakukan _vertical scaling_ yaitu menambah kombinasi CPU dan RAM atau _horizontal scaling_ menambah jumlah node. 

Kali ini kita akan melakukan _horizontal scaling_ dengan menambah jumlah node dari 1 menjadi 3.

1. Masuk pada dashboard dari **hello-api** container service.
2. Klik menu **Capacity**
3. Klik tombol **Change capacity** akan muncul dialog konfirmasi. Klik tombol **Yes, continue** untuk melanjutkan.

[![Lightsail Capacity](https://raw.githubusercontent.com/rioastamal-examples/assets/main/workshop-amazon-lightsail-containers/lab-deploy-nodejs-app/images/lightsail-hello-api-capacity-menu.png)](https://raw.githubusercontent.com/rioastamal-examples/assets/main/workshop-amazon-lightsail-containers/lab-deploy-nodejs-app/images/lightsail-hello-api-capacity-menu.png)

> Gambar 12. Halaman capacity pada container service

4. Kita akan tetap menggunakan tipe Nano jadi yang akan kita ubah adalah jumlah node. Pada **Choose the scale** geser slider ke angka **3**. 

[![Lightsail Add Node](https://raw.githubusercontent.com/rioastamal-examples/assets/main/workshop-amazon-lightsail-containers/lab-deploy-nodejs-app/images/lightsail-hello-api-capacity-add-node.png)](https://raw.githubusercontent.com/rioastamal-examples/assets/main/workshop-amazon-lightsail-containers/lab-deploy-nodejs-app/images/lightsail-hello-api-capacity-add-node.png)

> Gambar 13. Menambah jumlah node untuk container service

5. Proses akan memakan waktu beberapa menit, klik **I understand** untuk menutup dialog.
6. Tunggu hingga status dari container service kembali **Running**.

[![Lightsail New Capacity](https://raw.githubusercontent.com/rioastamal-examples/assets/main/workshop-amazon-lightsail-containers/lab-deploy-nodejs-app/images/lightsail-hello-api-new-capacity-applied.png)](https://raw.githubusercontent.com/rioastamal-examples/assets/main/workshop-amazon-lightsail-containers/lab-deploy-nodejs-app/images/lightsail-hello-api-new-capacity-applied.png)

> Gambar 14. Kapasitas jumlah node telah bertambah

Amazon Lightsail akan secara otomatis mendistribusikan _traffic_ ke 3 node yang telah berjalan pada **hello-api** container service. Anda tidak perlu melakukan konfigurasi apapun, sangat memudahkan.

Sekarang kita tes respon dari API dan melihat nilai dari lokal IP yang dikembalikan. Harusnya alamat IP dari setiap request bisa berbeda hasilnya tergantung node mana yang melayani. Lakukan request ke public endpoint dari container beberapa kali dan lihat hasilnya.

```sh
curl -s 'https://YOUR_OWN_CONTAINER_SERVICE_PUBLIC_DOMAIN/?text=Hello%20Indonesia%20Belajar'
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
My Local IP: 172.26.31.136
```

```sh
curl -s 'https://YOUR_OWN_CONTAINER_SERVICE_PUBLIC_DOMAIN/?text=Hello%20Indonesia%20Belajar'
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
My Local IP: 172.26.5.248
```

```sh
curl -s 'https://YOUR_OWN_CONTAINER_SERVICE_PUBLIC_DOMAIN/?text=Hello%20Indonesia%20Belajar'
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
My Local IP: 172.26.40.244
```

Dapat terlihat jika alamat IP yang dikembalikan berbeda-beda mengindikasikan bahwa node yang menangani _request_ adalah node yang berbeda. Lakukan beberapa kali jika mendapatkan hasil yang sama.

Okey, sebelum lanjut ke langkah berikutnya kembalikan terlebih dahulu jumlah node dari **3** menjadi **1**. Tentu masih ingat caranya bukan?

[^back to top](#top)

<!-- end step-13 -->

<!-- begin step-14 -->

### <a name="step-14"></a>Step 14 - Rollback API ke Versi Sebelumnya

Kehidupan di dunia tidak selalu indah, benar? Begitu juga proses deployment kadang versi baru yang kita deploy malah tidak berfungsi dan menyebabkan error. Salah satu keuntungan menggunakan deployment berbasis container adalah kita dapat melakukan rollback dengan mudah.

Sebagai contoh kita akan melakukan rollback API kita ke versi sebelumnya. Caranya sangat mudah.

1. Pertama pastikan anda berada pada halaman dashboard dari container service **hello-api**.
2. Pastikan anda berada pada halaman _Deployments_.
3. Scroll bagian bawah yaitu **Deployment versions**. Disana terlihat kita telah melakukan dua kali deployment. Deployment yang terakhir adalah untuk image `indonesia-belajar:2.0`.
4. Klik titik tiga **Version 1** kemudian klik **Modify and redeploy**.

[![Lightsail Rollback Deployment](https://raw.githubusercontent.com/rioastamal-examples/assets/main/workshop-amazon-lightsail-containers/lab-deploy-nodejs-app/images/lightsail-hello-api-rollback-deployment.png)](https://raw.githubusercontent.com/rioastamal-examples/assets/main/workshop-amazon-lightsail-containers/lab-deploy-nodejs-app/images/lightsail-hello-api-rollback-deployment.png)

> Gambar 15. Rollback Deployment ke Versi Sebelumnya

5. Akan muncul dialog konfirmasi untuk melakukan deployment, klik tombol **Yes, continue**.
6. Proses deployment belum dilakukan, ini hanya otomatis nilai konfigurasi _Image_ akan berubah menjadi versi sebelumnya yaitu `:hello-api.indonesia-belajar.12`. Nomor versi upload `.12` bisa berbeda ditempat anda.
7. Klik tombol **Save and deploy** untuk memulai proses rollback deployment dari image sebelumnya.
8. Tunggu hingga status dari container service kembali menjadi **Running**.

Ketika rollback sudah selesai dan status kembali menjadi **Running** maka coba lakukan request ke API untuk melihat apakah respon sesuai dengan versi sebelumnya.

```sh
curl -s 'https://YOUR_OWN_CONTAINER_SERVICE_PUBLIC_DOMAIN/?text=Hello%20Indonesia%20Belajar'
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

Dapat terlihat bahwa API kita telah kembali ke versi sebelumnya yaitu `indonesia-belajar:1.0`. Respon tidak mengembalikan lokal IP dari server seperti yang seharusnya ada di versi `indonesia-belajar:2.0`.

Jadi sebenarnya untuk melakukan rollback sesimple anda mengganti versi container image yang akan dijalankan.

Perlu diingat bahwa rollback juga adalah sebuah proses deployment jadi otomatis itu akan menambah daftar pada **Deployment versions**. Seperti yang terlihat pada gambar di bawah, rollback yang kita lakukan menghasilkan deployment versi 3.

[![Lightsail Deployment Versions](https://raw.githubusercontent.com/rioastamal-examples/assets/main/workshop-amazon-lightsail-containers/lab-deploy-nodejs-app/images/lightsail-hello-api-deployment-versions.png)](https://raw.githubusercontent.com/rioastamal-examples/assets/main/workshop-amazon-lightsail-containers/lab-deploy-nodejs-app/images/lightsail-hello-api-deployment-versions.png)

> Gambar 16. Rollback juga menghasilkan versi deployment baru

[^back to top](#top)

<!-- end step-14 -->

<!-- begin step-15 -->

### <a name="step-15"></a>Step 15 - Menghapus Amazon Lightsail Container Service

Jika aplikasi sudah tidak dibutuhkan maka tidak ada alasan untuk menjalankannya. Jika Container Service hanya kita _disabled_ maka kita tetap terkena charge meskipun container dan endpoint tidak dapat diakses. 

Jika sudah tidak diperlukan maka menghapus container adalah cara yang tepat. Ikuti langkah berikut.

1. Kembali ke dashboard Amazon Lightsail
2. Kemudian klik menu **Containers** untuk masuk ke halaman container service.
3. Disana harusnya terdapat container service **hello-api**, klik tombol titik tiga untuk membuka menu kemudian klik pilihan **Delete**.

[![Lightsail Delete Container Service](https://raw.githubusercontent.com/rioastamal-examples/assets/main/workshop-amazon-lightsail-containers/lab-deploy-nodejs-app/images/lightsail-hello-api-delete.png)](https://raw.githubusercontent.com/rioastamal-examples/assets/main/workshop-amazon-lightsail-containers/lab-deploy-nodejs-app/images/lightsail-hello-api-delete.png)

> Gambar 17. Menghapus container service

4. Pada dialog konfirmasi klik tombol **Yes, delete** untuk menghapus container service.
5. Harusnya container service **hello-api** sudah tidak ada dalam daftar.

Perlu dicatat bahwa container image pada Amazon Lightsail terikat pada container service. Jadi menghapus container service juga akan menghapus semua container image yang telah diupload pada container service tersebut. Dalam hal ini, dua container image yang kita upload sebelumnya yaitu `indonesia-belajar:1.0` dan `indonesia-belajar:2.0` juga ikut dihapus.

Sekarang mari kita coba akses kembali URL endpoint container apakah masih bisa merespon atau mengembalikan error.

```sh
curl -s https://YOUR_OWN_CONTAINER_SERVICE_PUBLIC_DOMAIN/
```

```html
<!DOCTYPE html>
<html>
<head><title>404 No Such Service</title></head>
<body bgcolor="white">
<center><h1>404 No Such Service</h1></center>
</body>
</html>
```

Dapat terlihat bahwa public URL yang sebelumnya digunakan sekarang mengembalikan HTTP error 404. Artinya tidak ada container service yang berjalan.

[^back to top](#top)

---

SELAMAT! Anda telah menyelesaikan workshop deployment Python Flask dengan menggunakan Amazon Lightsail Containers.

Jangan lupa berikan tanda ⭐ untuk repo ini. Sampai bertemu diworkshop selanjutnya.

<!-- end step-15 -->