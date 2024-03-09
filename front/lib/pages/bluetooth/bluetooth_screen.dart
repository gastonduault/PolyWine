// import 'package:flutter/material.dart';
// import 'package:flutter_blue/flutter_blue.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:get/get.dart';
// import 'package:project_app/bluetooth_controller.dart';

// class BluetoothScreen extends StatefulWidget {
//   @override
//   _BluetoothScreenState createState() => _BluetoothScreenState();
// }

// class _BluetoothScreenState extends State<BluetoothScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           title: Text(
//             "Connexion Bluetooth",
//             style: GoogleFonts.lato(
//               color: Colors.black,
//               fontSize: 24,
//               fontWeight: FontWeight.w700,
//             ),
//           ),
//           backgroundColor: const Color.fromARGB(255, 144, 205, 255),
//         ),
//         body: GetBuilder<BluetoothController>(
//             init: BluetoothController(),
//             builder: (BluetoothController controller) {
//               return Center(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     StreamBuilder<List<ScanResult>>(
//                         stream: controller.scanResult,
//                         builder: (context, snapshot) {
//                           if (snapshot.hasData) {
//                             return ListView.builder(
//                                 itemBuilder: (context, index) {
//                               final data = snapshot.data![index];
//                               return Card(
//                                 elevation: 2,
//                                 child: ListTile(
//                                   title: Text(data.device.name),
//                                   subtitle: Text(data.device.id.id),
//                                   trailing: Text(data.rssi.toString()),
//                                 ),
//                               );
//                             });
//                           } else {
//                             return Center(child: Text("Aucun appareil trouvé"));
//                           }
//                         }),
//                     SizedBox(
//                       height: 10,
//                     ),
//                     ElevatedButton(
//                         onPressed: () => controller.scanDevices(),
//                         child: Text("SCAN"))
//                   ],
//                 ),
//               );
//             }));
//   }
// }
