
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


<table border="0" style="width: 100%; display: table;"><tr><td><a href="STEP-1.md">&laquo; Sebelumnya</td><td align="center"><a href="README.md">Daftar Isi</a></td><td align="right"><a href="STEP-3.md">Berikutnya &raquo;</a></td></tr></table>

<sup>Workshop: Deploy Python Flask dengan Amazon Lightsail Containers  
Version: 2022-14-06  
Author: [@rioastamal](https://github.com/rioastamal)</sup>
