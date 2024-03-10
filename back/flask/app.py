from flask import Flask, jsonify, request
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

class Cave(db.Model):
    __tablename__ = 'caves'
    id = db.Column(db.Integer, primary_key=True)
    nom = db.Column(db.String(50), nullable=False)



#création cave
@app.route('/caves', methods=['POST'])
def add_cave():
    if request.method == 'POST':
        data = request.get_json()
        new_cave = Cave(nom=data['nom'])
        try:
            db.session.add(new_cave)
            db.session.commit()
            return jsonify({'message': 'Cave ajoutée avec succès!'}), 201
        except:
            db.session.rollback()
            return jsonify({'message': 'Erreur lors de l\'ajout de la cave'}), 500
        finally:
            db.session.close()


#info cave
@app.route('/cave/<int:cave_id>', methods=['GET'])
def get_cave_name(cave_id):
    cave = Cave.query.get(cave_id)

    if cave:
        return jsonify({'cave_id': cave.id, 'cave_nom': cave.nom})
    else:
        return jsonify({'message': 'Cave non trouvée'}), 404


#modifier cave
@app.route('/caves/<int:cave_id>', methods=['POST'])
def update_cave(cave_id):
    cave = Cave.query.get(cave_id)

    if cave:
        try:
            data = request.get_json()
            cave.nom = data['nom']
            db.session.commit()
            return jsonify({'message': 'Nom de la cave mis à jour avec succès!'}), 200
        except:
            db.session.rollback()
            return jsonify({'message': 'Erreur lors de la mise à jour du nom de la cave'}), 500
        finally:
            db.session.close()
    else:
        return jsonify({'message': 'Cave non trouvée'}), 404


#lister les bouteilles d'une cave
@app.route('/cave/bouteilles/<int:caveid>', methods=['GET'])
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
    return jsonify({'bouteilles': bouteilles_list}), {'Content-Type': 'application/json; charset=utf-8'}


#ajout d'une bouteille
@app.route('/bouteilles', methods=['POST'])
def add_bouteille():
    if request.method == 'POST':
        data = request.get_json()

        new_bouteille = Bouteille(
            nom=data['nom'],
            cuvee=data['cuvee'],
            region=data['region'],
            categorie=data['categorie'],
            date_recolte=data['date_recolte'],
            date_ajout=data['date_ajout'],
            caveId=data['caveId']
        )
        try:
            db.session.add(new_bouteille)
            db.session.commit()
            return jsonify({'message': 'Bouteille ajoutée avec succès!'}), 201
        except:
            db.session.rollback()
            return jsonify({'message': 'Erreur lors de l\'ajout de la bouteille'}), 500
        finally:
            db.session.close()


#modification d'une bouteille
@app.route('/bouteilles/<int:bouteille_id>', methods=['POST'])
def update_bouteille(bouteille_id):
    bouteille = Bouteille.query.get(bouteille_id)

    if bouteille:
        try:
            data = request.get_json()

            bouteille.nom = data['nom']
            bouteille.cuvee = data['cuvee']
            bouteille.region = data['region']
            bouteille.categorie = data['categorie']
            bouteille.date_recolte = data['date_recolte']
            bouteille.date_ajout = data['date_ajout']
            bouteille.caveId = data['caveId']

            db.session.commit()
            return jsonify({'message': 'Bouteille mise à jour avec succès!'}), 200
        except:
            db.session.rollback()
            return jsonify({'message': 'Erreur lors de la mise à jour de la bouteille'}), 500
        finally:
            db.session.close()
    else:
        return jsonify({'message': 'Bouteille non trouvée'}), 404


#suppression bouteille
@app.route('/bouteille/<int:bouteille_id>', methods=['DELETE'])
def delete_bouteille(bouteille_id):
    bouteille = Bouteille.query.get(bouteille_id)
    if bouteille:
        try:
            db.session.delete(bouteille)
            db.session.commit()
            return jsonify({'message': 'Bouteille supprimée avec succès!'}), 200
        except:
            db.session.rollback()
            return jsonify({'message': 'Erreur lors de la suppression de la bouteille'}), 500
        finally:
            db.session.close()
    else:
        return jsonify({'message': 'Bouteille non trouvée'}), 404


if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=5000)

