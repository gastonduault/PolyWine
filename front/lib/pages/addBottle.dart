import 'package:flutter/material.dart';


class AjoutBouteille extends StatelessWidget {
  final int caveId;

  AjoutBouteille({Key? key, required int caveid})
      : caveId = caveid,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ajout d'une bouteille"),
      ),
      body: Column(
        children: [
          TextFormField(
            decoration: const InputDecoration(
              hintText: 'Saisir le nom du vin',
            ),
            validator: (String? value) {
              if (value == null || value.isEmpty) {
                return 'Saisir un nom';
              }
              return null;
            },
          ),
        ],
      )
    );
  }
}