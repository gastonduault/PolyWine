import 'bluetooth_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'pages/bluetooth/bluetooth.dart';
import 'package:google_fonts/google_fonts.dart';
import './colors.dart';


void main() { runApp(MyApp()); }

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Namer App',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: background_color),
        ),
        home: FirstRoute(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {}

class FirstRoute extends StatelessWidget {
  const FirstRoute({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Choisir une cave'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Text(
                          "Ajout Cave",
                          style: TextStyle(color: font_black),
                        ),
                        SizedBox(height: 20),
                        Icon(
                          Icons.bluetooth,
                          color: font_pink,
                          size: 24.0,
                          semanticLabel:
                              'Text to announce in accessibility modes',
                        ),
                      ],
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SecondRoute(),
                      ),
                    );
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}