import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const d_pink = Color(0xFFFFF6F6);

void main() {
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title : "PolyWine",
      home : HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(),
      body: Container(
        color: d_pink,
      ),
    );
  }
}

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  Size get preferredSize => new Size.fromHeight(50);
  @override 
  Widget build(BuildContext context) {
    return AppBar(
      title: Align(
        alignment: Alignment.center,
        child: Text(
          'Que recherchez-vous ?',
          style: GoogleFonts.montserrat(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.w600,
            
          ),
        ),
      ),
      backgroundColor: Colors.blue,
    );
  }
}