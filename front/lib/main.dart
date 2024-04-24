import 'package:project_app/fetch/bouteille.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter/foundation.dart';
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

class BluetoothManager with ChangeNotifier {
  static final BluetoothManager _instance = BluetoothManager._internal();
  factory BluetoothManager() => _instance;

  BluetoothManager._internal();

  FlutterBluePlus flutterBlue = FlutterBluePlus();
  BluetoothDevice? connectedDevice;
  BluetoothCharacteristic? connectedCharacteristic;
  List<String> messages =
      []; // Liste pour stocker les messages reçus en provenance de l'Arduio
  List<int> bottleArray = []; // Tableau pour stocker l'état de la cave
  int nbBouteilles = 0; // Nombre de bouteilles dans la cave
  List<int> lastBottleArray = [];
  List<int> occupiedLocations = []; // Pour stocker les emplacements occupés
  int lastModifiedLocation = -1;
  bool isConnected = false;
  bool watcher = false;
  Bouteille bouteilleEnAjout = Bouteille(
      nom: "",
      cuvee: "",
      Region: "",
      categorie: '',
      dateRecolt: -1,
      caveId: -1,
      emplacement: -1);

  int? emplacement;

  Future<void> connectToDevice(BluetoothDevice device) async {
    if (connectedDevice != null &&
        connectedDevice == device &&
        connectedCharacteristic != null) {
      // Already connected and listening to this device
      return;
    }

    // Disconnect from any previous device
    if (connectedDevice != null && connectedDevice != device) {
      disconnect();
    }

    connectedDevice = device;
    try {
      await connectedDevice!.connect();
      isConnected = true; // Mise à jour de l'état de connexion
      List<BluetoothService> services =
          await connectedDevice!.discoverServices();
      for (var service in services) {
        if (service.uuid == Guid("0000ffe0-0000-1000-8000-00805f9b34fb")) {
          for (var char in service.characteristics) {
            if (char.uuid == Guid("0000ffe1-0000-1000-8000-00805f9b34fb")) {
              connectedCharacteristic = char;
              await char.setNotifyValue(true);
              char.value.listen((value) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  String receivedMessage = utf8.decode(value);
                  updateCaveState(receivedMessage);
                });
              });
              break;
            }
          }
        }
      }
    } catch (e) {
      isConnected = false; // Mise à jour de l'état de connexion en cas d'échec
      print('Failed to connect: $e');
    }
    notifyListeners();
  }

  void updateCaveState(String message) {
    message = message.trim();
    if (message.isEmpty || !message.contains(':')) {
      // print("Message reçu vide ou mal formé.");
      return;
    }

    int colonIndex = message.indexOf(": ");
    if (colonIndex != -1 && message.length > colonIndex + 2) {
      var numericPart = message.substring(colonIndex + 2).trim();
      try {
        List<int> currentBottleArray =
            numericPart.split('').map(int.parse).toList();
        if (currentBottleArray.length == 6) {
          // Modifiez '6' selon le nombre d'emplacements dans votre cave
          processBottleArray(currentBottleArray);
        } else {
          print(
              "Erreur: Le tableau reçu ne contient pas le nombre attendu d'éléments.");
        }
      } catch (e) {
        print('Erreur lors de la conversion du message : $e');
      }
    } else {
      print("Format du message incorrect ou message trop court.");
    }
  }

  Future<void> processBottleArray(List<int> newBottleArray) async {
    // Inverser le tableau pour que le premier élément corresponde au dernier emplacement dans l'interface utilisateur
    newBottleArray = List.from(newBottleArray.reversed);

    // Initialisation de la variable pour suivre le dernier emplacement modifié lors de cette mise à jour
    int? newlyModifiedLocation;

    // Comparaison des tableaux uniquement si lastBottleArray a été initialisé
    if (lastBottleArray.isNotEmpty) {
      for (int i = 0; i < newBottleArray.length; i++) {
        // Détecter le dernier emplacement modifié en comparant l'ancien et le nouveau tableau
        if (newBottleArray[i] != lastBottleArray[i]) {
          newlyModifiedLocation =
              i + 1; // Index ajusté pour l'affichage (commence à 1)
        }
      }
    }

    // Mise à jour du dernier tableau connu
    lastBottleArray = List.from(newBottleArray);
    nbBouteilles = newBottleArray.where((b) => b == 1).length;

    // Mise à jour des emplacements occupés
    occupiedLocations.clear();
    for (int i = 0; i < newBottleArray.length; i++) {
      if (newBottleArray[i] == 1) {
        occupiedLocations.add(i +
            1); // Supposons que l'indexation commence à 1 pour les emplacements
      }
    }

    // Mise à jour du dernier emplacement modifié, si un changement a été détecté
    if (newlyModifiedLocation != null && watcher) {
      print("PAAAAASAAAAAGE");
      lastModifiedLocation = newlyModifiedLocation;
      watcher = false;
    }
    //  else {
    //   lastModifiedLocation ??=
    //       occupiedLocations.isNotEmpty ? occupiedLocations.last : null;
    // }

    print(
        "Mise à jour - isConnected: $isConnected - nbBouteilles: $nbBouteilles, OccupiedLocations: $occupiedLocations, LastModifiedLocation: $lastModifiedLocation");
    notifyListeners(); // Notifiez les widgets consommateurs après la mise à jour de l'état
  }

  String extractNumericPart(String message) {
    int startIndex = message.indexOf(":") + 1;
    return message.substring(startIndex).trim();
  }

  void disconnect() async {
    if (connectedDevice != null) {
      await connectedDevice!.disconnect();
      connectedDevice = null;
      connectedCharacteristic = null;
      notifyListeners();
    }
  }

  void manualDisconnect() {
    disconnect();
  }

  void sendMessage(String message) async {
    if (connectedCharacteristic != null) {
      print("Envoi du message : $message"); // Ajouter pour le débogage
      await connectedCharacteristic!
          .write(utf8.encode(message), withoutResponse: true);
      messages.add("Envoyé : $message");
      notifyListeners();
    } else {
      print("Caractéristique non disponible."); // Ajouter pour le débogage
    }
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
