### NOTE BACK
- installer *docker*
- installer *docker-compose*


- **start servers** : `sudo docker-compose up`
  - commande dans le dossier `./back/`


- Si **Erreur** :
  > ``` Creating mysql ... error```<br/> ``` ERROR: for mysql  Cannot start service mysql: driver failed programming external connectivity on endpoint mysql```
  > - Faire la commande suivante :
  >   - ```sudo service mysql stop ```
  > - Puis éteindre et rallumer les services :
  >   - ```sudo docker-compose down ```
  >   - ```sudo docker-compose up ```


## Test des endpoints :
> - Liste des bouteilles d'une cave (à partir de son id)<br/>
``` curl http://localhost:5000/cave/1```
> - Modifier le nom d'une cave<br/> 
``` curl -X PUT -H "Content-Type: application/json" -d '{"nom": "NouveauNomDeCave"}' http://localhost:5000/caves/1```
> - Modifier une bouteille <br/>
``` curl -X PUT -H "Content-Type: application/json" -d '{"nom": "NouveauNom", "cuvee": "NouvelleCuvee", "region": "NouvelleRegion", "categorie": "NouvelleCategorie", "date_recolte": "NouvelleDateRecolte", "date_ajout": "NouvelleDateAjout", "caveId": 2}' http://localhost:5000/bouteilles/1```
> - Supprimer une bouteille<br/>
``` curl -X DELETE http://localhost:5000/bouteilles/1 ```
> - Ajouter une bouteille<br />
``` curl -X POST -H "Content-Type: application/json" -d '{"nom": "Vouvray", "cuvee": "Domaine d\'Orsay", "region": "Bordeaux", "categorie": "rouge", "date_recolte": "2020", "date_ajout": "2023-12-15", "caveId": 1}' http://localhost:5000/bouteilles```
