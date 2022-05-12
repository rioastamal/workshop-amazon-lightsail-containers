
### <a name="step-2"></a>Step 2 - Menginstal Lightsail Control Plugin

Plugin CLI ini digunakan untuk mengupload container image dari komputer lokal ke Amazon Lightsail container service. Jalankan perintah berikut untuk menginstal Lightsail Control Plugin. Diasumsikan bahwa terdapat perintah `sudo` pada distribusi Linux yang anda gunakan.

```sh
$ sudo curl "https://s3.us-west-2.amazonaws.com/lightsailctl/latest/linux-amd64/lightsailctl" -o "/usr/local/bin/lightsailctl"
```

Tambahkan atribut _execute_ pada file `lightsailctl` yang baru saja didownload.

```sh
$ sudo chmod +x /usr/local/bin/lightsailctl
```


<table border="0" style="width: 100%; display: table;"><tr><td><a href="STEP-1.md">&laquo; Sebelumnya</td><td align="center"><a href="README.md">Daftar Isi</a></td><td align="right"><a href="STEP-3.md">Berikutnya &raquo;</a></td></tr></table>
<p class="line" style="font-size: small;">
  <span style="display:block">Workshop: Deploy Node.js App dengan Amazon Lightsail Containers</span>
  <span style="display:block">Version: 2022-05-12</span>
  <span style="display:block">Author: <a href="https://github.com/rioastamal">@rioastamal</a></span>
</p>
