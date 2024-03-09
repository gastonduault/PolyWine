import 'dart:async';
import 'package:flutter/material.dart';
import '../fetch/caves.dart';




class Cave extends StatelessWidget {
  final int caveId;

  const Cave({Key? key, required int caveid})
      : caveId = caveid,
        super(key: key);




  @override
  Widget build(BuildContext context) {
    late Future<List<Bouteille>> futureBouteilles = fetchBouteilles(caveId);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fetch Data Example'),
      ),
      body: Center(
        child: FutureBuilder<List<Bouteille>>(
          future: futureBouteilles,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              // Afficher la liste de noms de bouteilles
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(snapshot.data![index].nom),
                    subtitle: Text(snapshot.data![index].cuvee),
                  );
                },
              );
            } else if (snapshot.hasError) {
              // Afficher l'erreur s'il y en a une
              return Text('${snapshot.error}');
            }

            // Par défaut, afficher un spinner de chargement
            return const CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}
