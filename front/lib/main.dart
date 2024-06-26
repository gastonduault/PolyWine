import 'package:project_app/fetch/bouteille.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter/foundation.dart';
import 'pages/bluetooth/bluetooth_manager.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'fetch/bouteille.dart';
import 'assets/colors.dart';
import 'pages/listeBottle.dart';
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
  int lastModifiedLocation_forDelete = -1;
  bool isConnected = false;
  bool watcher = false;
  bool pivot = true;
  var caveID = null;
  late BuildContext context;
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
    if (message.isEmpty) {
      print("Message reçu vide.");
      return;
    }

    if (!RegExp(r'^\d+$').hasMatch(message)) {
      print("Message contient des caractères non numériques : $message");
      return;
    }

    try {
      List<int> currentBottleArray = message.split('').map(int.parse).toList();
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

    // Mise à jour des emplacements occupé
    var tmp_occupiedLocations = List.from(occupiedLocations);
    print("init tmp");
    print(tmp_occupiedLocations.length);

    occupiedLocations.clear();
    print("after clear");
    print(occupiedLocations.length);
    for (int i = 0; i < newBottleArray.length; i++) {
      if (newBottleArray[i] == 1) {
        occupiedLocations.add(i +
            1); // Supposons que l'indexation commence à 1 pour les emplacements
      }
    }
    print("after boucle");
    print(occupiedLocations.length);
    print(tmp_occupiedLocations.length);

    if (tmp_occupiedLocations.length > occupiedLocations.length) {
      print("IF OK");
      for (var i = 0; i <= occupiedLocations.length; i++) {
        print("FOR OK");
        if (!tmp_occupiedLocations.contains(occupiedLocations.indexOf(i))) {
          print("SUPPRESSION");
          if (caveID != null) {
            await fetchSupprimerBouteille(lastModifiedLocation_forDelete);
            // TODO: à changer si valeur réactive
            // await fetchBouteilles(caveID, context);
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => caveScreen(),
              ),
            );
          }
        }
      }
    }

    // Mise à jour du dernier emplacement modifié, si un changement a été détecté
    if (newlyModifiedLocation != null && watcher) {
      lastModifiedLocation = newlyModifiedLocation;
      watcher = false;
    }
    if (newlyModifiedLocation != null) {
      lastModifiedLocation_forDelete = newlyModifiedLocation;
    }
    //  else {
    // }

    print(
        "Mise à jour - isConnected: $isConnected - nbBouteilles: $nbBouteilles, OccupiedLocations: $occupiedLocations, LastModifiedLocation: $lastModifiedLocation, LastModifiedLocation for delete: $lastModifiedLocation_forDelete");
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

  void controlLED(int emplacement) async {
    //   if (connectedCharacteristic != null) {
    //     String message = "$emplacement";
    //     print("Envoi du message allumer l'emplacement: $message");

    //     await connectedCharacteristic!
    //         .write(utf8.encode(message), withoutResponse: true);
    //     messages.add("Envoyé : $message");
    //     notifyListeners();
    //   } else {
    //     print("Caractéristique non connectée ou indisponible.");
    //   }
    print("PAAAASSSAAAGE");
    Provider.of<BluetoothManager>(context, listen: false).sendMessage("6");
  }
}

class MyAppState extends ChangeNotifier {
  var caveID = null;
  var bouteilleID = null;
  late Future<List<Bouteille>> futureBouteilles = Future.value([]);

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
