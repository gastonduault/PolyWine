import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:provider/provider.dart';
import 'bluetooth_manager.dart';

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
  String receivedData = ""; // Pour stocker les données reçues
  TextEditingController commandController = TextEditingController();
  List<String> terminalLogs = []; // Historique des messages

  final Guid serviceUuid = Guid("0000ffe0-0000-1000-8000-00805f9b34fb"); // Ajusté
  final Guid characteristicUuid = Guid("0000ffe1-0000-1000-8000-00805f9b34fb"); // Ajusté
  BluetoothCharacteristic? characteristic;

  @override
  void initState() {
    super.initState();
    // connectAndDiscoverServices();
  }

  void connectAndDiscoverServices() async {
    await widget.device.connect();
    services = await widget.device.discoverServices();
    for (var service in services) {
      if (service.uuid == serviceUuid) {
        for (var char in service.characteristics) {
          if (char.uuid == characteristicUuid) {
            characteristic = char;
            await char.setNotifyValue(true);
            char.value.listen((value) {
              setState(() {
                String receivedMessage = utf8.decode(value);
                terminalLogs.add("Reçu : $receivedMessage");
                receivedData = receivedMessage; // Stocke les données reçues
              });
            });
            break;
          }
        }
      }
    }
    setState(() {
      isConnected = true;
    });
    widget.onDeviceConnected();
  }

void sendMessage(String message) async {
  if (characteristic == null) {
    print("Caractéristique non disponible.");
    return;
  }
  try {
    await characteristic!.write(utf8.encode(message), withoutResponse: true);
    setState(() {
      terminalLogs.add("Envoyé : $message");
    });
  } catch (e) {
    print("Erreur lors de l'envoi du message : $e");
    // Affichage facultatif d'un message d'erreur à l'utilisateur
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.device.name ?? "Unknown Device"),
      ),
      body: Consumer<BluetoothManager>(
        builder: (context, manager, child) {
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: manager.messages.length,
                  itemBuilder: (context, index) => ListTile(
                    title: Text(manager.messages[index]),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: "Tapez votre message ici",
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    IconButton( 
                      icon: Icon(Icons.send),
                      onPressed: () {
                        manager.sendMessage("Hello DSD Tech");
                      },
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    // if (isConnected) {
    //   widget.device.disconnect();
    // }
    // FlutterBluePlus.stopScan();
    super.dispose();
  }
}
