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
  List<String> logs = []; // Ajout d'une liste pour stocker les logs

  @override
  void initState() {
    super.initState();
    // Connexion au dispositif via BluetoothManager
    final manager = Provider.of<BluetoothManager>(context, listen: false);
    manager.connectToDevice(widget.device);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.device.name ?? "Unknown Device"),
      ),
      body: Consumer<BluetoothManager>(
        builder: (context, manager, child) {
          return ListView(
            children: manager.messages.map((msg) => ListTile(title: Text(msg))).toList(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.send),
        onPressed: () {
          Provider.of<BluetoothManager>(context, listen: false).sendMessage("OK");
        },
      ),
    );
  }

  @override
  void dispose() {
    Provider.of<BluetoothManager>(context, listen: false).disconnect();
    super.dispose();
  }
}
