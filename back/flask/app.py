import os
from flask import Flask, session, render_template, request, url_for, redirect, flash
# from flask_sqlalchemy import SQLAlchemy

app = Flask(__name__)
# app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///db.sqlite3'
# app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
# app.config
# db = SQLAlchemy(app)

@app.route('/')
def home():
    print("Try to connect to the db ... ")
    return "end"


@app.route("/login", methods=["POST"])
def login():
    return "failed 502 "

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=os.getenv('PORT'))