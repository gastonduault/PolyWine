import 'package:flutter_blue/flutter_blue.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class BluetoothController extends GetxController {

  FlutterBlue flutterBlue = FlutterBlue.instance;

  Future scanDevices() async {
    if(await Permission.bluetoothScan.request().isGranted) {
      if (await Permission.bluetoothConnect.request().isGranted) {
        flutterBlue.startScan(timeout: const Duration(seconds: 5));

        flutterBlue.stopScan();
      }
    }
  }

  Stream<List<ScanResult>> get scanResult => flutterBlue.scanResults;

}