import 'package:flutter/material.dart';
import './bluetooth/bluetooth.dart';
import '../assets/colors.dart';
import './caveScreen.dart';


class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Choisir une cave'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 60,
              ),
              ElevatedButton(
                style: ButtonStyle(
                    padding:
                        MaterialStateProperty.all(const EdgeInsets.all(15))),
                child: Row(
                  children: [
                    Text(
                      "Ajout Cave",
                      style: TextStyle(color: font_black),
                    ),
                    SizedBox(width: 10),
                    Icon(
                      Icons.bluetooth,
                      color: font_pink,
                      size: 24.0,
                      semanticLabel: 'Connection bluetooth',
                    ),
                  ],
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
          ),
          SizedBox(
            height: 30,
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Text("Caves ajoutés", style: TextStyle(fontSize: 17))],
          ),
          SizedBox(
            height: 5,
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(background_color),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        side: BorderSide(color: font_pink),
                      ),
                    ),
                    padding:
                        MaterialStateProperty.all(const EdgeInsets.all(20))),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text("Vladou"),
                        SizedBox(
                          height: 5,
                        ),
                        Image.asset(
                          'lib/assets/img/cave.png',
                          width: 50,
                        ),
                      ],
                    )
                  ],
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Cave(
                        caveid: 1,
                      ),
                    ),
                  );
                },
              ),
              SizedBox(
                width: 15,
              ),
              ElevatedButton(
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(background_color),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        side: BorderSide(color: font_pink),
                      ),
                    ),
                    padding:
                        MaterialStateProperty.all(const EdgeInsets.all(20))),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text("Souhail"),
                        SizedBox(
                          height: 5,
                        ),
                        Image.asset(
                          'lib/assets/img/cave.png',
                          width: 50,
                        ),
                      ],
                    )
                  ],
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Cave(
                        caveid: 4,
                      ),
                    ),
                  );
                },
              )
            ],
          )
        ],
      ),
    );
  }
}
