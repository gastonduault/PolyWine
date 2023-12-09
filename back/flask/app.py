from flask import Flask

@app.route('/api/cave')
def cave():
    return "hello world !"