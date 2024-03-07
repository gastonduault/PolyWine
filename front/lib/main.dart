import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'bluetooth_screen.dart';

const d_pink = Color(0xFFFEEBEB); // Couleur principale maquette 

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
      body: SingleChildScrollView(
        child: Column(
          children: [
            SearchSection(),
            InfosSection(),
            BouteilleSection(),
          ],
        ),
      ),
    );
  }
}

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  Size get preferredSize => new Size.fromHeight(50);
  @override 
  Widget build(BuildContext context) {
    return AppBar(
      leading: const IconButton(
        icon: Icon(
          Icons.arrow_back,
          color: Colors.black,
          size: 24,
        ),
        onPressed: null,
      ),
      title: Text(
          'Home page',
          style: GoogleFonts.lato(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.w700,
          ),
        ),
      actions: [
              IconButton(
        icon: const Icon(
          Icons.bluetooth,
          color: Colors.black,
          size: 24,
        ),
        onPressed: () {
          Navigator.push(
            context, 
            MaterialPageRoute(builder: (context) => BluetoothScreen()),
          );
        },
      ),
        const IconButton(
        icon: Icon(
          Icons.home,
          color: Colors.black,
          size: 24,
        ),
        onPressed: null,
      ),
      ],
      centerTitle: true,
      backgroundColor: Colors.white,
    );
  }
}

class SearchSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red[50],
      padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
      child: Column(
        children: [
          Container(
            height: 50,
            color: Colors.blue,
          ),
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 50,
                  color: Colors.green[300],
                  // child: const TextField(),
                )
              ),
              Container(
                height: 50,
                width: 60,
                color: Colors.green,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class InfosSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 125,
      color: Colors.red[100],
    );
  }
}

class BouteilleSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1500,
      color: Colors.red[200],
    );
  }
}