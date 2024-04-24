import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter/foundation.dart';

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
  bool isConnected = false;


  Future<void> connectToDevice(BluetoothDevice device) async {
    if (connectedDevice != null && connectedDevice == device && connectedCharacteristic != null) {
      return;
    }

    if (connectedDevice != null && connectedDevice != device) {
      disconnect();
    }

    connectedDevice = device;
    try {
      await connectedDevice!.connect();
      isConnected = true;
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
    } catch (e) {
      isConnected = false;
      print('Failed to connect: $e');
    }
    notifyListeners();
  }

  void updateCaveState(String message) {
    message = message.trim();
    if (message.isEmpty || !message.contains(':')) {
      return;
    }

    int colonIndex = message.indexOf(": ");
    if (colonIndex != -1 && message.length > colonIndex + 2) {
      var numericPart = message.substring(colonIndex + 2).trim();
      try {
        List<int> currentBottleArray = numericPart.split('').map(int.parse).toList();
        if (currentBottleArray.length == 6) { // Modifiez '6' selon le nombre d'emplacements dans votre cave
        processBottleArray(currentBottleArray);
        } else {
        print("Erreur: Le tableau reçu ne contient pas le nombre attendu d'éléments.");
       }
      } catch (e) {
        print('Erreur lors de la conversion du message : $e');
      }
    } else {
      print("Format du message incorrect ou message trop court.");
    }
  }


  void processBottleArray(List<int> newBottleArray) {
    newBottleArray = List.from(newBottleArray.reversed);

    int? newlyModifiedLocation;

    if (lastBottleArray.isNotEmpty) {
      for (int i = 0; i < newBottleArray.length; i++) {
        if (newBottleArray[i] != lastBottleArray[i]) {
          newlyModifiedLocation = i + 1;
        }
      }
    }

    lastBottleArray = List.from(newBottleArray);
    nbBouteilles = newBottleArray.where((b) => b == 1).length;

    occupiedLocations.clear();
    for (int i = 0; i < newBottleArray.length; i++) {
      if (newBottleArray[i] == 1) {
        occupiedLocations.add(i + 1);
      }
    }

    if (newlyModifiedLocation != null) {
      lastModifiedLocation = newlyModifiedLocation;
    } else {
      lastModifiedLocation ??= occupiedLocations.isNotEmpty ? occupiedLocations.last : null;
    }

    print("Mise à jour - isConnected: $isConnected - nbBouteilles: $nbBouteilles, OccupiedLocations: $occupiedLocations, LastModifiedLocation: $lastModifiedLocation");
    notifyListeners();
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
      print("Envoi du message : $message");
      await connectedCharacteristic!.write(utf8.encode(message), withoutResponse: true);
      messages.add("Envoyé : $message");
      notifyListeners();
    } else {
      print("Caractéristique non disponible.");
    }
  }
}