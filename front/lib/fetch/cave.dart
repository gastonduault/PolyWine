import 'dart:convert';
import 'package:http/http.dart' as http;
import 'url.dart';


class Cave {
  final int caveId;
  final String nom;

  Cave({
    required this.caveId,
    required this.nom,
  });

  factory Cave.fromJson(Map<String, dynamic> json) {
    return Cave(
      caveId: json['cave_id'] ?? 0,
      nom: json['cave_nom'] ?? '',
    );
  }
}


Future<Cave> fetchCave(int id) async {
  final response = await http.get(Uri.parse(url + 'cave/' + id.toString()));

  if (response.statusCode == 200) {
    final dynamic caveJson = jsonDecode(response.body);
    return Cave.fromJson(caveJson);
  } else {
    throw Exception('Failed to load cave');
  }
}
