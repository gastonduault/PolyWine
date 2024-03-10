import 'dart:async';
import 'package:flutter/material.dart';
import '../fetch/bouteille.dart';
import '../assets/colors.dart';
import '../fetch/cave.dart';
import './addBottle.dart';
import 'bottleTile.dart';

class caveScreen extends StatelessWidget {
  final int caveId;

  const caveScreen({Key? key, required int caveid})
      : caveId = caveid,
        super(key: key);


  @override
  Widget build(BuildContext context) {
    
    late Future<List<Bouteille>> futureBouteilles = fetchBouteilles(caveId);
    late Future<Cave> futureCave = fetchCave(caveId);

    return Scaffold(
      appBar: AppBar(
        title: FutureBuilder<Cave>(
          future: futureCave,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Text(snapshot.data!.nom);
            } else if (snapshot.hasError) {
              return Text('Erreur: ${snapshot.error}');
            }
            return Text('Chargement...');
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Center(
            child: FutureBuilder<List<Bouteille>>(
              future: futureBouteilles,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Column(
                    children: [
                      Text(
                        ' ${6 - snapshot.data!.length} EMPLACEMENT VIDE',
                        style: TextStyle(
                            fontSize: 13,
                            fontFamily: 'RobotoRegular',
                            color: font_pink
                          ),
                      ),
                      SizedBox(height: 10,),
                      ElevatedButton(
                        style: ButtonStyle(
                          padding: MaterialStateProperty.all(
                            const EdgeInsets.all(0)
                          ),
                          backgroundColor:
                              MaterialStateProperty.all(background_color),
                          shape:
                            MaterialStateProperty.all<CircleBorder>(
                              CircleBorder(),
                            ),
                        ),
                        child:  Image.asset(
                          "lib/assets/img/ajouter.png",
                          width: 16,
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AjoutBouteille(caveid: caveId,),
                            ),
                          );
                        },
                      ),
                      SizedBox(height: 5,),
                      GridView.builder(
                        shrinkWrap: true,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 20.0,
                          mainAxisSpacing: 20.0,
                          childAspectRatio: 0.5,
                        ),
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          return BouteilleTile(
                              bouteille: snapshot.data![index]);
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        ' ${snapshot.data!.length} / 6 BOUTEILLES',
                        style: TextStyle(
                            fontSize: 13,
                            fontFamily: 'RobotoRegular',
                            color: font_pink),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  );
                } else if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                }
                return const CircularProgressIndicator();
              },
            ),
          ),
        ),
      ),
    );
  }
}
