import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'pages/home.dart';
import 'assets/colors.dart';
import 'pages/bluetooth/bluetooth_manager.dart';


void main() { runApp(MyApp()); }

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

class MyAppState extends ChangeNotifier {}

