import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import '../fetch/bouteille.dart';
import '../assets/colors.dart';
import '../fetch/cave.dart';
import './addBottle.dart';
import 'bottleTile.dart';
import '../main.dart';
import 'dart:async';

class caveScreen extends StatelessWidget {
  const caveScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    var caveId = appState.caveID;
    late Future<Cave> futureCave = fetchCave(caveId);

    late Future<List<Bouteille>> futureBouteilles =
        _loadBouteilles(caveId, context);

    var bluetoothManager = context.watch<BluetoothManager>();
    bluetoothManager.caveID = appState.caveID;
    bluetoothManager.context = context;

    return Scaffold(
      appBar: AppBar(
        title: FutureBuilder<Cave>(
          future: futureCave,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      snapshot.data!.nom,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  FutureBuilder<List<Bouteille>>(
                    future: futureBouteilles,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Text(
                          '${6 - snapshot.data!.length} places',
                          style: TextStyle(
                            fontSize: 13,
                            fontFamily: 'RobotoRegular',
                            color: font_pink,
                          ),
                        );
                      } else if (snapshot.hasError) {
                        return Text('Erreur: ${snapshot.error}');
                      }
                      return Text('Chargement...');
                    },
                  ),
                ],
              );
            } else if (snapshot.hasError) {
              return Text('Erreur: ${snapshot.error}');
            }
            return Text('Chargement...');
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Center(
            child: FutureBuilder<List<Bouteille>>(
              future: futureBouteilles,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return SizedBox(
                    // Couleur de la ligne
                    height: MediaQuery.of(context).size.height,
                    child: Column(
                      children: [
                        Visibility(
                          visible:
                              snapshot.hasData && snapshot.data!.length < 6,
                          child: ElevatedButton(
                            style: ButtonStyle(
                              padding: MaterialStateProperty.all(
                                  const EdgeInsets.all(0)),
                              backgroundColor:
                                  MaterialStateProperty.all(background_color),
                              shape: MaterialStateProperty.all<CircleBorder>(
                                CircleBorder(),
                              ),
                            ),
                            child: Image.asset(
                              "lib/assets/img/ajouter.png",
                              width: 16,
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AjoutBouteille(),
                                ),
                              );
                            },
                          ),
                        ),
                        Expanded(
                          child: snapshot.data!.isEmpty
                              ? Center(
                                  child: Text(
                                    'Aucune bouteille dans la cave.',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                )
                              : GridView.builder(
                                  shrinkWrap: true,
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 20.0,
                                    mainAxisSpacing: 20.0,
                                    childAspectRatio: 0.5,
                                  ),
                                  itemCount: snapshot.data!.length,
                                  itemBuilder: (context, index) {
                                    return BouteilleTile(
                                        bouteille: snapshot.data![index]);
                                  },
                                ),
                        ),
                        SizedBox(
                          height: 100,
                        )
                      ],
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                }
                return const CircularProgressIndicator();
              },
            ),
          ),
        ),
      ),
    );
  }

  Future<List<Bouteille>> _loadBouteilles(
      int caveId, BuildContext context) async {
    await fetchBouteilles(caveId, context);
    return context.read<MyAppState>().futureBouteilles;
  }
}
