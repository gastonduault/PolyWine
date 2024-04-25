import 'package:project_app/fetch/bouteille.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import './bluetooth/bluetooth.dart';
import '../assets/colors.dart';
import 'listeBottle.dart';
import '../main.dart';

class Historique extends StatelessWidget {
  const Historique({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var bluetoothManager = context.watch<BluetoothManager>();
    Future<List<Bouteille>> bouteilles =
        fetchHistoriques(appState.caveID, context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Historique'),
      ),
      body: FutureBuilder<List<Bouteille>>(
        future: bouteilles,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image.asset(
                        "lib/assets/img/grape_${snapshot.data![index].categorie}.png",
                        width: 30,
                      ),
                      Text(snapshot.data![index].nom),
                      Text(snapshot.data![index].dateRecolt.toString()),
                    ],
                  ),
                  // Text(snapshot.data![index]
                  //     .nom), // Remplacez 'nom' par l'attribut à afficher
                  // Vous pouvez ajouter d'autres widgets ici pour afficher plus d'informations
                );
              },
            );
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
          return CircularProgressIndicator(); // Affiche un indicateur de chargement pendant le chargement des données
        },
      ),
    );
  }
}
