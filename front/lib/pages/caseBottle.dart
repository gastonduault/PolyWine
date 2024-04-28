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
    var bluetoothManager = context.watch<BluetoothManager>();
    var bluetooth = bluetoothManager.isConnected;
    bluetoothManager.watcher = true;

    var caveId = appState.caveID;
    fetchBouteilles(caveId, context);
    late Future<List<Bouteille>> futureBouteilles = appState.futureBouteilles;

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
                    width: 21,
                  ),
                  Text("Mettez la bouteille dans votre cave"),
                  ElevatedButton(
                      style: ButtonStyle(
                          padding: MaterialStateProperty.all(
                              const EdgeInsets.all(15))),
                      child: Row(
                        children: [
                          Text(
                            "Bouteille ajoutée à la cave",
                            style: TextStyle(color: font_black),
                          ),
                          SizedBox(width: 10),
                          Icon(
                            Icons.add,
                            color: font_pink,
                            size: 24.0,
                            semanticLabel: 'Bouteille ajoutée à la cave',
                          ),
                        ],
                      ),
                      onPressed: () {
                        print(
                            'LE lastModifiedLocation EGAL${bluetoothManager.lastModifiedLocation}');
                        if (bluetoothManager.lastModifiedLocation != -1) {
                          ajoutBouteille(
                              context, bluetoothManager.lastModifiedLocation);
                        } else {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                content: Text(
                                    'La bouteille n\'est pas présente dans la cave'),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      //TODO: a regarder après
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
                      }),
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
                    print(bouteille.emplacement);
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
                              child: Text('Emplacement ${emplacement}'),
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
      Navigator.of(context).pop();
      Navigator.of(context).pop();
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
                  //TODO: a regarder après
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
