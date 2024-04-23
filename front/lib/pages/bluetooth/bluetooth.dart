import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:provider/provider.dart';
import 'bluetooth_manager.dart';
import '../home.dart';

class ScanPage extends StatefulWidget {
  const ScanPage({Key? key}) : super(key: key);

  @override
  _ScanPageState createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  final FlutterBluePlus flutterBlue = FlutterBluePlus();
  List<ScanResult> scanResults = [];
  bool isScanning = false;
  Map<String, bool> connectedDevices = {};

  @override
  void initState() {
    super.initState();
    startScan();
  }

  void startScan() async {
    setState(() {
      isScanning = true;
    });
    await FlutterBluePlus.startScan(timeout: Duration(seconds: 4));

    FlutterBluePlus.scanResults.listen((results) {
      setState(() {
        scanResults = results;
      });
    });

    setState(() {
      isScanning = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Scan Bluetooth Devices'),
        actions: [
          if (isScanning)
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            )
        ],
      ),
      body: ListView.builder(
        itemCount: scanResults.length,
        itemBuilder: (context, index) {
          String displayName = scanResults[index].advertisementData.localName ??
              scanResults[index].device.name ??
              'Unknown Device';

          bool deviceConnected = connectedDevices[scanResults[index].device.id.toString()] ?? false;

          return ListTile(
            title: Text(displayName),
            subtitle: Text(scanResults[index].device.id.toString()),
            leading: Icon(deviceConnected ? Icons.bluetooth_connected : Icons.bluetooth),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                return DeviceDetailPage(
                  device: scanResults[index].device,
                  onDeviceConnected: () {
                    setState(() {
                      connectedDevices[scanResults[index].device.id.toString()] = true;
                    });
                  },
                );
              }));
              BluetoothManager().connectToDevice(scanResults[index].device);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.refresh),
        onPressed: () => startScan(),
      ),
    );
  }
}

class DeviceDetailPage extends StatefulWidget {
  final BluetoothDevice device;
  final VoidCallback onDeviceConnected;

  DeviceDetailPage({required this.device, required this.onDeviceConnected});

  @override
  _DeviceDetailPageState createState() => _DeviceDetailPageState();
}

class _DeviceDetailPageState extends State<DeviceDetailPage> {
  bool isConnected = false;
  List<BluetoothService> services = [];
  String receivedData = "";
  List<String> logs = []; // Ajout d'une liste pour stocker les logs

  final Guid serviceUuid = Guid("0000ffe0-0000-1000-8000-00805f9b34fb");
  final Guid characteristicUuid = Guid("0000ffe1-0000-1000-8000-00805f9b34fb");
  BluetoothCharacteristic? characteristic;

  @override
  void initState() {
    super.initState();
    connectAndDiscoverServices();
  }

  void connectAndDiscoverServices() async {
    if (widget.device == null) return;
    await widget.device.connect();
    services = await widget.device.discoverServices();
    for (var service in services) {
      if (service.uuid == serviceUuid) {
        for (var char in service.characteristics) {
          if (char.uuid == characteristicUuid) {
            characteristic = char;
            await char.setNotifyValue(true);
            char.value.listen((value) {
              String receivedMessage = utf8.decode(value);
              if (mounted) {              
                setState(() {
                  logs.add("Reçu : $receivedMessage");
                  receivedData = receivedMessage;
                });
              }
            });
            break;
          }
        }
      }
    }
    if (mounted) {
      setState(() {
        isConnected = true;
      });
    }
    widget.onDeviceConnected();
  }

  void sendMessage(String message) async {
    if (characteristic == null) {
      logs.add("Caractéristique non disponible.");
      return;
    }
    try {
      await characteristic!.write(utf8.encode(message), withoutResponse: true);
      setState(() {
        logs.add("Envoyé : $message");
      });
    } catch (e) {
      logs.add("Erreur lors de l'envoi du message : $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.device.name ?? "Unknown Device"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => Home()));
          },
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: logs.length,
              itemBuilder: (context, index) => ListTile(
                title: Text(logs[index]),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: TextEditingController(),
                    decoration: InputDecoration(
                      hintText: "Type your message here",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () => sendMessage("OK"), // Envoie 'OK' pour initier la communication
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    if (characteristic != null) {
    characteristic?.setNotifyValue(false);  // Désactiver les notifications
    }
    super.dispose();
  }
}
