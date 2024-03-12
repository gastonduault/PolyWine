import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

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

  void connectToDevice(BluetoothDevice device) async {
    await device.connect();
    // Ici, vous pouvez ajouter votre logique après la connexion réussie.
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
          // Utiliser advertisementData.localName si disponible, sinon device.name, sinon 'Unknown Device'
          String displayName = scanResults[index].advertisementData.localName ?? 
                              scanResults[index].device.name ?? 
                              'Unknown Device';
          
          bool deviceConnected = connectedDevices[scanResults[index].device.id.toString()] ?? false;

          return Container(
            decoration: BoxDecoration(
              border: deviceConnected ? Border.all(color: Colors.green, width: 2) : null,
            ),
            child: ListTile(
              title: Text(displayName),
              subtitle: Text(scanResults[index].device.id.toString()),
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
              },
            ),
          );

          // Optionnel : filtrer et ne pas afficher les appareils qui n'ont pas de nom "humain"
          // if (displayName.isEmpty || isUUID(displayName)) {
            // return Container(); // Retourne un conteneur vide pour les noms non souhaités
          // }
          
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.refresh),
        onPressed: () => startScan(),
      ),
    );
  }

  bool isUUID(String str) {
    final uuidRegex = RegExp(r'^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[1-5][0-9a-fA-F]{3}-[89abAB][0-9a-fA-F]{3}-[0-9a-fA-F]{12}$');
    return uuidRegex.hasMatch(str);
  }

  @override
  void dispose() {
    FlutterBluePlus.stopScan();
    super.dispose();
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

  @override
  Widget build(BuildContext context) {
    // Utilisez un Container pour ajouter une bordure conditionnelle
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.device.name ?? "Unknown Device"),
      ),
      body: Container(
        // Ajoute une bordure verte si connecté, sinon pas de bordure
        decoration: BoxDecoration(
          border: isConnected ? Border.all(color: Colors.green, width: 4) : null,
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("ID: ${widget.device.id}"),
              ElevatedButton(
                onPressed: isConnected ? null : () async {
                  try {
                    await widget.device.connect();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Connexion établie avec ${widget.device.name}'),
                        backgroundColor: Colors.green,
                      ),
                    );
                    setState(() {
                      isConnected = true; // Mise à jour de l'état pour refléter la connexion réussie
                    });
                    widget.onDeviceConnected();
                    // Plus de logique ici si nécessaire
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Échec de la connexion'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                child: Text(isConnected ? 'Connected' : 'Connect'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    if (isConnected) {
      widget.device.disconnect();
    }
    super.dispose();
  }
}