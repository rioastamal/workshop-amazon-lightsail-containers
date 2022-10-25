
### <a name="step-9"></a>Step 9 - Create New Version of the API

Every application will almost certainly having an update whether for bug fixes or adding new features. In this step we will try to demonstrate how to update an application on Amazon Lightsail Container service.

In this example we will update the API to support character other than cow. List of new characters: 'beavis', 'cheese', 'daemon', 'cow', 'dragon', 'ghostbusters', 'kitty', 'meow', 'milk', 'pig', 'stegosaurus', 'stimpy', 'trex', 'turkey', 'turtle', 'tux'.

Make sure you are in directory `python-app`. Then change the contents of the file `src/index.pyto` as shown below.

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

We add new parameter `char` via query string. This parameter will determine what character to shown. In addition we also add new section to show our local IP address.

Run the API using Docker.

```sh
docker run -v $(pwd):/app --rm -it -p 8080:8080 \
public.ecr.aws/docker/library/python:3.8-slim \
bash /app/run-server.sh
```

Kemudian lakukan HTTP request ke path `/` dengan mengirimkan parameter `text` dan `char` di query string.

Try to call the API to show tux character. We need to pass query string `char=tux`.

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

Now our API able to support many characters and display local IP of the server.


<table border="0" style="width: 100%; display: table;"><tr><td><a href="STEP-8.md">&laquo; Previous</td><td align="center"><a href="README.md">Index</a></td><td align="right"><a href="STEP-10.md">Next &raquo;</a></td></tr></table>

<sup>Workshop: Deploy Python Flask dengan Amazon Lightsail Containers  
Version: 2022-14-06  
Author: [@rioastamal](https://github.com/rioastamal)</sup>
