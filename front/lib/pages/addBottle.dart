import 'package:flutter/material.dart';
import '../assets/colors.dart';

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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child:  Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            TextFormField(
              decoration: const InputDecoration(
                hintText: 'Nom de la bouteille',
                contentPadding: EdgeInsets.all(0),
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
      ),
    );
  }
}