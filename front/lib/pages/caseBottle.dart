import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../fetch/bouteille.dart';
import '../assets/colors.dart';
import './listeBottle.dart';
import '../main.dart';

class caseBottle extends StatelessWidget {
  const caseBottle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var bluetooth = appState.bluetoothConnected;
    var caveId = appState.caveID;
    late Future<List<Bouteille>> futureBouteilles = fetchBouteilles(caveId);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Emplacement de la bouteille"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 20,
            ),
            if (bluetooth)
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    "lib/assets/img/bluetooth.png",
                    width: 16,
                  ),
                  Text("Mettez la bouteille dans votre cave"),
                ],
              )
            else
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    "lib/assets/img/no-bluetooth.png",
                    width: 16,
                  ),
                  Text("Vous n'êtes pas connecté à la cave"),
                ],
              ),
            SizedBox(
              height: 20,
            ),
            Divider(
              color: font_pink,
              thickness: 1,
            ),
            SizedBox(
              height: 20,
            ),
            FutureBuilder<List<Bouteille>>(
              future: futureBouteilles,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Erreur: ${snapshot.error}');
                } else {
                  List<int> emplacementsLibres = List.generate(
                    6,
                    (index) => index + 1,
                  );

                  for (var bouteille in snapshot.data!) {
                    emplacementsLibres.remove(bouteille.emplacement);
                  }

                  return DropdownButton<int>(
                    hint: Text('Choisir un emplacement'),
                    value: null,
                    onChanged: (int? newValue) {
                      if (newValue != null) {
                        ajoutBouteille(context, newValue);
                      }
                    },
                    items: emplacementsLibres
                        .map((emplacement) => DropdownMenuItem<int>(
                              value: emplacement,
                              child: Text('Emplacement $emplacement'),
                            ))
                        .toList(),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  void ajoutBouteille(BuildContext context, int emplacement) async {
    var appState = context.read<MyAppState>();
    appState.bouteilleEnAjout.emplacement = emplacement;

    bool ajout = await fetchAjouterBouteille(appState.bouteilleEnAjout);

    if (ajout) {
      print("bouteille ajoutée");
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => caveScreen(),
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Text('Échec de l\'ajout de la bouteille.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Center(
                  child: Text('OK'),
                ),
              ),
            ],
          );
        },
      );
    }
  }
}
