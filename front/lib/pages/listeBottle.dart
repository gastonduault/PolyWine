import 'dart:async';
import 'package:flutter/material.dart';
import 'bottleTile.dart';
import '../fetch/bouteille.dart';
import '../fetch/cave.dart';




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
                  return GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 20.0,
                      mainAxisSpacing: 20.0,
                      childAspectRatio: 0.5,
                    ),
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      return BouteilleTile(bouteille: snapshot.data![index]);
                    },
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



// shrinkWrap: true,
// children: [
//   Row(
//     mainAxisAlignment: MainAxisAlignment.center,
//     mainAxisSize: MainAxisSize.max,
//     children: [
//       BouteilleTile(bouteille: snapshot.data![0]),
//       SizedBox(width: 20,),
//       BouteilleTile(bouteille: snapshot.data![1])
//     ],
//   ),
//   SizedBox(height: 20,),
//   Row(
//     mainAxisAlignment: MainAxisAlignment.center,
//     mainAxisSize: MainAxisSize.max,
//     children: [
//       BouteilleTile(bouteille: snapshot.data![2]),
//       SizedBox(
//         width: 20,
//       ),
//       BouteilleTile(bouteille: snapshot.data![3])
//     ],
//   ),
//   SizedBox(height: 20,),
// ],