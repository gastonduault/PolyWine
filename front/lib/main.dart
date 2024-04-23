import 'package:project_app/fetch/bouteille.dart';

import 'pages/bluetooth/bluetooth_manager.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'assets/colors.dart';
import 'pages/home.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => MyAppState()),
        ChangeNotifierProvider(create: (context) => BluetoothManager()),
      ],
      child: MaterialApp(
        title: 'Namer App',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: background_color),
        ),
        home: const Home(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  var caveID = null;
  var bouteilleID = null;
  Bouteille bouteilleEnAjout = Bouteille(
      nom: "",
      cuvee: "",
      Region: "",
      categorie: '',
      dateRecolt: -1,
      caveId: -1,
      emplacement: -1);

  bool bluetoothConnected = false;
}
