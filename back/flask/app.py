from flask import Flask, jsonify
from flask_sqlalchemy import SQLAlchemy

app = Flask(__name__)
app.config['SQLALCHEMY_DATABASE_URI'] = 'mysql://user:user@mysql/polywine'
db = SQLAlchemy(app)

class Bouteille(db.Model):
    __tablename__ = 'bouteilles'
    id = db.Column(db.Integer, primary_key=True)
    nom = db.Column(db.String(50), nullable=False)
    cuvee = db.Column(db.String(50), nullable=False)
    region = db.Column(db.String(50), nullable=False)
    categorie = db.Column(db.String(50), nullable=False)
    date_recolte = db.Column(db.String(50), nullable=False)
    date_ajout = db.Column(db.Date, nullable=False)
    caveId = db.Column(db.Integer, db.ForeignKey('caves.id'), nullable=False)

# Endpoint pour lister les bouteilles de la cave de quelqu'un
@app.route('/cave/<int:caveid>', methods=['GET'])
def get_bouteilles_by_cave(caveid):
    bouteilles = Bouteille.query.filter_by(caveId=caveid).all()
    bouteilles_list = []
    for bouteille in bouteilles:
        bouteilles_list.append({
            'nom': bouteille.nom,
            'cuvee': bouteille.cuvee,
            'region': bouteille.region,
            'categorie': bouteille.categorie,
            'date_recolte': bouteille.date_recolte,
            'date_ajout': bouteille.date_ajout.strftime('%Y-%m-%d'),
            'caveId': bouteille.caveId
        })
    return jsonify({'bouteilles': bouteilles_list})

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=5000)
