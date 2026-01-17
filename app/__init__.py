from flask import Flask, jsonify

app = Flask(__name__)

@app.route('/')
def home():
    return jsonify({"message": "Bookstore API", "status": "ok"})

@app.route('/books')
def get_books():
    return jsonify([{"id": 1, "title": "Clean Code"}])
