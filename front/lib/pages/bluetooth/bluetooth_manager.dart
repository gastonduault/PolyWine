import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class BluetoothManager with ChangeNotifier {
  static final BluetoothManager _instance = BluetoothManager._internal();
  factory BluetoothManager() => _instance;

  BluetoothManager._internal();

  FlutterBluePlus flutterBlue = FlutterBluePlus();
  BluetoothDevice? connectedDevice;
  BluetoothCharacteristic? connectedCharacteristic;
  List<String> messages = []; // Liste pour stocker les messages reçus en provenance de l'Arduio
  List<int> bottleArray = []; // Tableau pour stocker l'état de la cave 
  int nbBouteilles = 0; // Nombre de bouteilles dans la cave
   List<int> lastBottleArray = [];
  List<int> occupiedLocations = [];  // Pour stocker les emplacements occupés
  int? lastModifiedLocation;  // Pour stocker le dernier emplacement modifié

  Future<void> connectToDevice(BluetoothDevice device) async {
    if (connectedDevice != null && connectedDevice == device && connectedCharacteristic != null) {
      // Already connected and listening to this device
      return;
    }

    // Disconnect from any previous device
    if (connectedDevice != null && connectedDevice != device) {
      disconnect();
    }

    connectedDevice = device;
    await connectedDevice!.connect();
    List<BluetoothService> services = await connectedDevice!.discoverServices();
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
    notifyListeners();
  }

  void updateCaveState(String message) {
    message = message.trim();  // Nettoie les espaces avant et après
    if (message.isEmpty) {
      print("Message reçu vide ou composé uniquement d'espaces.");
      return;  // Ignore ce message
    }  

    print("Message reçu : $message");  // Affiche chaque message reçu pour le débogage

    int colonIndex = message.indexOf(": ");
    if (colonIndex != -1 && message.length > colonIndex + 2) {
        var numericPart = message.substring(colonIndex + 2).trim();
        try {
            List<int> currentBottleArray = numericPart.split('').map(int.parse).toList();
            occupiedLocations.clear();
            lastModifiedLocation = null;

            for (int i = 0; i < currentBottleArray.length; i++) {
                if (currentBottleArray[i] == 1) {
                    occupiedLocations.add(i + 1);
                    if (lastBottleArray.isEmpty || lastBottleArray[i] == 0) {
                        lastModifiedLocation = i + 1;
                    }
                }
            }

            lastBottleArray = List.from(currentBottleArray);
            nbBouteilles = occupiedLocations.length;
            notifyListeners();
        } catch (e) {
            print('Erreur lors de la conversion du message : $e');
        }
    } else {
        print("Format du message incorrect ou message trop court.");
    }
  }


  String extractNumericPart(String message) {
    int startIndex = message.indexOf(":") + 1;
    return message.substring(startIndex).trim();
  }

  void disconnect() async {
    if (connectedDevice != null) {
      await connectedDevice!.disconnect();
    }
    connectedDevice = null;
    connectedCharacteristic = null;
    notifyListeners();
  }

  void sendMessage(String message) async {
    if (connectedCharacteristic != null) {
      await connectedCharacteristic!.write(utf8.encode(message), withoutResponse: true);
      messages.add("Envoyé : $message");
      notifyListeners();
    }
  }
}