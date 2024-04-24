import 'dart:convert';
import 'package:http/http.dart' as http;
import 'url.dart';
import '../main.dart';

import 'package:project_app/fetch/bouteille.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import '../assets/colors.dart';

class Bouteille {
  int? id; // Rendre l'attribut id nullable
  String categorie;
  int caveId;
  String cuvee;
  int dateRecolt;
  String nom;
  String Region;
  int emplacement;

  Bouteille({
    this.id,
    required this.categorie,
    required this.caveId,
    required this.cuvee,
    required this.dateRecolt,
    required this.nom,
    required this.Region,
    required this.emplacement,
  });

  factory Bouteille.fromJson(Map<String, dynamic> json) {
    return Bouteille(
      id: json['id'],
      categorie: json['categorie'] ?? '',
      caveId: json['caveId'] ?? 0,
      cuvee: json['cuvee'] ?? '',
      dateRecolt: json['date_recolte'] ?? 0,
      nom: json['nom'] ?? '',
      Region: json['region'] ?? '',
      emplacement: json['emplacement'] ?? 0,
    );
  }
}

Future<void> fetchBouteilles(int id, BuildContext context) async {
  var appState = context.watch<MyAppState>();

  final response = await http.get(Uri.parse('${url}cave/bouteilles/$id'));

  if (response.statusCode == 200) {
    final List<dynamic> bouteillesJson =
        jsonDecode(response.body)['bouteilles'];
    print(response.body);
    List<Bouteille> bouteilles = bouteillesJson
        .map((json) => Bouteille.fromJson(json))
        .toList(); // Convertir l'Iterable en List<Bouteille>
    appState.futureBouteilles =
        Future.value(bouteilles); // Envelopper la liste dans une Future
  } else {
    throw Exception('Failed to load bouteilles');
  }
}

Future<bool> fetchAjouterBouteille(Bouteille nouvelleBouteille) async {
  final response = await http.post(
    Uri.parse('${url}bouteilles'),
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
      'emplacement': nouvelleBouteille.emplacement,
    }),
  );

  if (response.statusCode == 200) {
    return true;
  } else {
    // throw Exception('Failed to add bottle');
    return false;
  }
}

Future<bool> fetchModifierBouteille(Bouteille bouteilleModifiee) async {
  print(bouteilleModifiee.id);
  final response = await http.post(
    Uri.parse('${url}bouteilles/${bouteilleModifiee.id}'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, dynamic>{
      'nom': bouteilleModifiee.nom,
      'cuvee': bouteilleModifiee.cuvee,
      'region': bouteilleModifiee.Region,
      'categorie': bouteilleModifiee.categorie,
      'date_recolte': bouteilleModifiee.dateRecolt,
      'caveId': bouteilleModifiee.caveId,
      'emplacement': bouteilleModifiee.emplacement,
    }),
  );

  if (response.statusCode == 200) {
    return true;
  } else {
    return false;
  }
}

Future<bool> fetchSupprimerBouteille(int emplacement) async {
  final response = await http.delete(
    Uri.parse('${url}bouteilles/emplacement/${emplacement}'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
  );

  if (response.statusCode == 200) {
    return true;
  } else {
    return false;
  }
}
