import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './pages/homeScreen.dart';
import 'assets/colors.dart';


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
        home: Home(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {}

