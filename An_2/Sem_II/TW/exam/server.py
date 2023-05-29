# serve at http://localhost:3000/poke.json the file poke.json

import os
import json
from flask import Flask, jsonify, request, abort, make_response, send_from_directory
from flask_cors import CORS

app = Flask(__name__)
CORS(app)

@app.route('/poke.json')
def poke():
      print('Reading poke.json...' )
      with open('resources/poke.json') as json_file:
            res = json.load(json_file)
      return res


if __name__ == '__main__':
      app.run(debug=True, host='localhost', port=3000)
