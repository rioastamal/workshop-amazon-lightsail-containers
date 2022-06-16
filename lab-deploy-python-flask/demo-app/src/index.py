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
