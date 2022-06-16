
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


<table border="0" style="width: 100%; display: table;"><tr><td><a href="STEP-8.md">&laquo; Sebelumnya</td><td align="center"><a href="README.md">Daftar Isi</a></td><td align="right"><a href="STEP-10.md">Berikutnya &raquo;</a></td></tr></table>

<sup>Workshop: Deploy Python Flask dengan Amazon Lightsail Containers  
Version: 2022-14-06  
Author: [@rioastamal](https://github.com/rioastamal)</sup>
