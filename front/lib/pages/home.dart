import './bluetooth/bluetooth_manager.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import './bluetooth/bluetooth.dart';
import '../assets/colors.dart';
import 'listeBottle.dart';
import '../main.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Choisir une cave'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // Modifications pour ajouts du nombre de bouteilles présentes dans la cave à vin
          Consumer<BluetoothManager>(
            builder: (context, manager, child) {
              return Column(
                children: [
                  Text(
                      "Il y a ${manager.nbBouteilles} bouteilles dans la cave à vin",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Text(
                      "Les emplacements ${manager.occupiedLocations.join(", ")} de la cave à vin sont occupés"),
                  if (manager.lastModifiedLocation != null)
                    Text(
                        "L'emplacement ${manager.lastModifiedLocation} a été le dernier modifié"),
                ],
              );
            },
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 60,
              ),
              ElevatedButton(
                style: ButtonStyle(
                    padding:
                        MaterialStateProperty.all(const EdgeInsets.all(15))),
                child: Row(
                  children: [
                    Text(
                      "Ajout Cave",
                      style: TextStyle(color: font_black),
                    ),
                    SizedBox(width: 10),
                    Icon(
                      Icons.bluetooth,
                      color: font_pink,
                      size: 24.0,
                      semanticLabel: 'Connection bluetooth',
                    ),
                  ],
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ScanPage(),
                    ),
                  );
                },
              ),
            ],
          ),
          SizedBox(
            height: 30,
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Text("Caves ajoutés", style: TextStyle(fontSize: 17))],
          ),
          SizedBox(
            height: 5,
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(background_color),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        side: BorderSide(color: font_pink),
                      ),
                    ),
                    padding:
                        MaterialStateProperty.all(const EdgeInsets.all(20))),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text("Vladou"),
                        SizedBox(
                          height: 5,
                        ),
                        Image.asset(
                          'lib/assets/img/cave.png',
                          width: 50,
                        ),
                      ],
                    )
                  ],
                ),
                onPressed: () {
                  appState.caveID = 1;
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const caveScreen(),
                    ),
                  );
                },
              ),
              SizedBox(
                width: 15,
              ),
              ElevatedButton(
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(background_color),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        side: BorderSide(color: font_pink),
                      ),
                    ),
                    padding:
                        MaterialStateProperty.all(const EdgeInsets.all(20))),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text("Souhail"),
                        SizedBox(
                          height: 5,
                        ),
                        Image.asset(
                          'lib/assets/img/cave.png',
                          width: 50,
                        ),
                      ],
                    )
                  ],
                ),
                onPressed: () {
                  appState.caveID = 2;
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const caveScreen(),
                    ),
                  );
                },
              )
            ],
          )
        ],
      ),
    );
  }
}
