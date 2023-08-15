from flask import Flask


app = Flask(__name__)

@app.route('/')
def mainRoute():
   return 'Hello, This is from Flask!'


if __name__ == '__main__':
  app.run(host='0.0.0.0')
