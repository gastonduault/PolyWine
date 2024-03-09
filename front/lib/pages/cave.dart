import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../fetch/caves.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Future<List<Bouteille>> futureBouteilles;

  @override
  void initState() {
    super.initState();
    futureBouteilles = fetchBouteilles();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fetch Data Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: Scaffold(
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
      ),
    );
  }
}
