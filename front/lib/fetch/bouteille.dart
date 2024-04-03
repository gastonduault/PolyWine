import 'dart:convert';
import 'package:http/http.dart' as http;
import 'url.dart';


class Bouteille {
  final String categorie;
  final int caveId;
  final String cuvee;
  final int dateRecolt;
  final String nom;
  final String Region;

  Bouteille({
    required this.categorie,
    required this.caveId,
    required this.cuvee,
    required this.dateRecolt,
    required this.nom,
    required this.Region,
  });

  factory Bouteille.fromJson(Map<String, dynamic> json) {
    return Bouteille(
      categorie: json['categorie'] ?? '',
      caveId: json['caveId'] ?? 0,
      cuvee: json['cuvee'] ?? '',
      dateRecolt: json['date_recolte'] ?? '',
      nom: json['nom'] ?? '',
      Region: json['region'] ?? '',
    );
  }
}


Future<List<Bouteille>> fetchBouteilles(int id) async {
  final response = await http.get(Uri.parse(url+'cave/bouteilles/'+id.toString()));

  if (response.statusCode == 200) {
    final List<dynamic> bouteillesJson =
        jsonDecode(response.body)['bouteilles'];
    return bouteillesJson.map((json) => Bouteille.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load bouteilles');
  }
}



Future<void> ajouterBouteille(Bouteille nouvelleBouteille) async {
  final response = await http.post(
    Uri.parse(url + 'bouteilles'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, dynamic>{
      'nom': nouvelleBouteille.nom,
      'cuvee': nouvelleBouteille.cuvee,
      'region': nouvelleBouteille.Region,
      'categorie': nouvelleBouteille.categorie,
      'date_recolte': nouvelleBouteille.dateRecolt,
      'caveId': nouvelleBouteille.caveId,
    }),
  );

  if (response.statusCode == 200) {
    print('Bouteille ajoutée avec succès');
  } else {
    throw Exception('Failed to add bouteille');
  }
}
