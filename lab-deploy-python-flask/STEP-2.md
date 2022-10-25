
### <a name="step-2"></a>Step 2 - Install Lightsail Control Plugin

This CLI plugin is used to upload container image from your local computer to the Amazon Lightsail container service. Run the following command to install the Lightsail Control Plugin. It is assumed that there is `sudo` command on your Linux distribution.

```sh
sudo curl "https://s3.us-west-2.amazonaws.com/lightsailctl/latest/linux-amd64/lightsailctl" -o "/usr/local/bin/lightsailctl"
```

Add an execute attribute to `lightsailctl` file.

```sh
sudo chmod +x /usr/local/bin/lightsailctl
```

Make sure the attribute is applied to the file. It is indicated by letter `x` in the attribute list, for an example `rwxr-xr-x`

```sh
ls -l /usr/local/bin/lightsailctl
```

```
-rwxr-xr-x 1 root root 13201408 May 28 03:16 /usr/local/bin/lightsailctl
```


<table border="0" style="width: 100%; display: table;"><tr><td><a href="STEP-1.md">&laquo; Previous</td><td align="center"><a href="README.md">Index</a></td><td align="right"><a href="STEP-3.md">Next &raquo;</a></td></tr></table>

<sup>Workshop: Deploy Python Flask dengan Amazon Lightsail Containers  
Version: 2022-14-06  
Author: [@rioastamal](https://github.com/rioastamal)</sup>
