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
    date_recolte = db.Column(db.Integer, nullable=False)
    caveId = db.Column(db.Integer, db.ForeignKey('caves.id'), nullable=False)
    emplacement = db.Column(db.Integer, nullable=False)


class Historique(db.Model):
    __tablename__ = 'historique'
    id = db.Column(db.Integer, primary_key=True)
    nom = db.Column(db.String(50), nullable=False)
    cuvee = db.Column(db.String(50), nullable=False)
    region = db.Column(db.String(50), nullable=False)
    categorie = db.Column(db.String(50), nullable=False)
    date_recolte = db.Column(db.Integer, nullable=False)
    caveId = db.Column(db.Integer, db.ForeignKey('caves.id'), nullable=False)
    emplacement = db.Column(db.Integer, nullable=False)

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
            'id': bouteille.id,
            'nom': bouteille.nom,
            'cuvee': bouteille.cuvee,
            'region': bouteille.region,
            'categorie': bouteille.categorie,
            'date_recolte': bouteille.date_recolte,
            'caveId': bouteille.caveId,
            'emplacement': bouteille.emplacement
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
            caveId=data['caveId'],
            emplacement=data['emplacement']
        )
        try:
            db.session.add(new_bouteille)
            db.session.commit()
            return jsonify({'message': 'Bouteille ajoutée avec succès!'}), 200
        except:
            db.session.rollback()
            return jsonify({'message': 'Erreur lors de l\'ajout de la bouteille'}), 500
        finally:
            db.session.close()


#modification d'une bouteille
@app.route('/bouteilles/<int:bouteille_id>', methods=['POST'])
def update_bouteille(bouteille_id):
    if request.method == 'POST':
        data = request.get_json()
        bouteille = Bouteille.query.get(bouteille_id)

        if not bouteille:
            return jsonify({'message': 'Bouteille non trouvée'}), 404

        try:
            bouteille.nom = data.get('nom', bouteille.nom)
            bouteille.cuvee = data.get('cuvee', bouteille.cuvee)
            bouteille.region = data.get('region', bouteille.region)
            bouteille.categorie = data.get('categorie', bouteille.categorie)
            bouteille.date_recolte = data.get('date_recolte', bouteille.date_recolte)
            bouteille.caveId = data.get('caveId', bouteille.caveId)
            bouteille.emplacement = data.get('emplacement', bouteille.emplacement)

            db.session.commit()
            return jsonify({'message': 'Bouteille mise à jour avec succès!'}), 200
        except Exception as e:
            db.session.rollback()
            error_message = f'Erreur lors de la mise à jour de la bouteille : {str(e)}'
            print(error_message)  # Affiche l'erreur dans la console Flask
            return jsonify({'message': error_message}), 500
        finally:
            db.session.close()


@app.route('/bouteilles/emplacement/<int:emplacement>', methods=['DELETE'])
def delete_bouteille_par_emplacement(emplacement):
    bouteille = Bouteille.query.filter_by(emplacement=emplacement).first()

    if not bouteille:
        return jsonify({'message': 'Bouteille non trouvée à cet emplacement'}), 404

    # Créer un objet historique à partir de la bouteille
    historique_entry = Historique(
        nom=bouteille.nom,
        cuvee=bouteille.cuvee,
        region=bouteille.region,
        categorie=bouteille.categorie,
        date_recolte=bouteille.date_recolte,
        caveId=bouteille.caveId,
        emplacement=bouteille.emplacement
    )

    try:
        # Ajouter à l'historique
        db.session.add(historique_entry)
        # Supprimer la bouteille
        db.session.delete(bouteille)
        db.session.commit()
        return jsonify({'message': 'Bouteille supprimée avec succès et ajoutée à l\'historique!'}), 200
    except Exception as e:
        db.session.rollback()
        error_message = f'Erreur lors de la suppression de la bouteille et de l\'ajout à l\'historique à l\'emplacement {emplacement} : {str(e)}'
        print(error_message)  # Affiche l'erreur dans la console Flask
        return jsonify({'message': error_message}), 500
    finally:
        db.session.close()


#lister les bouteilles d'une cave
@app.route('/cave/historique/<int:caveid>', methods=['GET'])
def get_historique_by_cave(caveid):
    historiques = Historique.query.filter_by(caveId=caveid).all()
    historique_liste = []
    for historique in historiques:
        historique_liste.append({
            'id': historique.id,
            'nom': historique.nom,
            'cuvee': historique.cuvee,
            'region': historique.region,
            'categorie': historique.categorie,
            'date_recolte': historique.date_recolte,
            'caveId': historique.caveId,
            'emplacement': historique.emplacement
        })
    return jsonify({'bouteilles': historique_liste}), {'Content-Type': 'application/json; charset=utf-8'}


if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=5001)

