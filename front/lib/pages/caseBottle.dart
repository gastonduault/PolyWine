import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../fetch/bouteille.dart';
import '../assets/colors.dart';
import './listeBottle.dart';
import '../main.dart';

class caseBottle extends StatefulWidget {
  const caseBottle({Key? key}) : super(key: key);

  @override
  _caseBottleState createState() => _caseBottleState();
}

class _caseBottleState extends State<caseBottle> {
  late Future<List<Bouteille>> futureBouteilles;
  late BluetoothManager bluetoothManager;
  late List<int> lastOccupiedLocations;

  @override
  void initState() {
    super.initState();
    bluetoothManager = context.read<BluetoothManager>();
    futureBouteilles = fetchBouteilles(context.read<MyAppState>().caveID);
    lastOccupiedLocations = List.from(bluetoothManager.occupiedLocations);
    bluetoothManager.addListener(onBluetoothManagerChange);
  }

  @override
  void dispose() {
    bluetoothManager.removeListener(onBluetoothManagerChange);
    super.dispose();
  }

  void onBluetoothManagerChange() async {
    if (bluetoothManager.occupiedLocations.isNotEmpty) {
      if (lastOccupiedLocations != bluetoothManager.occupiedLocations) {
        int newLocation = bluetoothManager.occupiedLocations.last;
        await ajoutBouteille(context, newLocation);
        lastOccupiedLocations = List.from(bluetoothManager.occupiedLocations);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var caveId = appState.caveID;
    var bluetooth = bluetoothManager.isConnected;

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
                    width: 22,
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

  Future<void> ajoutBouteille(BuildContext context, int emplacement) async {
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
