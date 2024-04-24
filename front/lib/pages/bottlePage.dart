import 'package:project_app/fetch/bouteille.dart';
import './bluetooth/bluetooth_manager.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import './bluetooth/bluetooth.dart';
import '../assets/colors.dart';
import 'listeBottle.dart';
import '../main.dart';

class bottlePage extends StatefulWidget {
  final Bouteille bouteille;

  const bottlePage({Key? key, required this.bouteille}) : super(key: key);

  @override
  _bottlePage createState() => _bottlePage();
}

class _bottlePage extends State<bottlePage> {
  String? _selectedRegion;
  late DateTime _selectedDate;
  TextEditingController _nomBouteilleController = TextEditingController();
  TextEditingController _cuveeBouteilleController = TextEditingController();
  TextEditingController _regionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nomBouteilleController = TextEditingController(text: widget.bouteille.nom);
    _cuveeBouteilleController =
        TextEditingController(text: widget.bouteille.cuvee);
    _regionController = TextEditingController(text: widget.bouteille.Region);
    _selectedRegion = widget.bouteille.categorie;
    _selectedDate = DateTime(widget.bouteille.dateRecolt);
  }

  @override
  void dispose() {
    _nomBouteilleController.dispose();
    _cuveeBouteilleController.dispose();
    _regionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("info de la bouteille"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 10,
            ),
            TextFormField(
              controller:
                  _nomBouteilleController, // Associez le contrôleur au champ de texte
              decoration: const InputDecoration(
                hintText: 'Nom de la bouteille',
              ),
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return 'Saisir un nom';
                }
                return null;
              },
            ),
            SizedBox(
              height: 10,
            ),
            TextFormField(
              controller:
                  _cuveeBouteilleController, // Associez le contrôleur au champ de texte
              decoration: const InputDecoration(
                hintText: 'Cuvée de la bouteille',
              ),
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return 'Saisir un nom';
                }
                return null;
              },
            ),
            SizedBox(
              height: 10,
            ),
            TextFormField(
              controller:
                  _regionController, // Associez le contrôleur au champ de texte
              decoration: const InputDecoration(
                hintText: 'Region',
              ),
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return 'Saisir un nom';
                }
                return null;
              },
            ),
            SizedBox(
              height: 10,
            ),
            DropdownButton<String>(
              value: _selectedRegion,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedRegion = newValue;
                });
              },
              items: <String>['rouge', 'blanc']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Row(
                    children: [
                      Image.asset(
                        "lib/assets/img/bouteille_${value.toLowerCase()}.png",
                        width: 20,
                        height: 20,
                        fit: BoxFit.contain,
                      ),
                      SizedBox(width: 10),
                      Text(value),
                    ],
                  ),
                );
              }).toList(),
              hint: const Text('Sélectionner le type de la bouteille'),
            ),
            SizedBox(
              height: 10,
            ),
            GestureDetector(
              onTap: () {
                _selectYear(context);
              },
              child: AbsorbPointer(
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Année de récolte',
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                  controller: TextEditingController(
                    text: "${_selectedDate.year}",
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 25,
            ),
            ElevatedButton(
                style: ButtonStyle(
                    padding:
                        MaterialStateProperty.all(const EdgeInsets.all(15))),
                child: Row(
                  children: [
                    Text(
                      "Modifier la bouteille",
                      style: TextStyle(color: font_black),
                    ),
                    SizedBox(width: 10),
                    Icon(
                      Icons.add,
                      color: font_pink,
                      size: 24.0,
                      semanticLabel: 'modifier bouteil',
                    ),
                  ],
                ),
                onPressed: () {
                  if (_validerChamps()) {
                    clickModifier(context, widget.bouteille);
                  }
                }),
          ],
        ),
      ),
    );
  }

  Future<void> _selectYear(BuildContext context) async {
    final DateTime? pickedYear = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
      initialDatePickerMode: DatePickerMode.year,
    );
    if (pickedYear != null && pickedYear != _selectedDate) {
      setState(() {
        _selectedDate = pickedYear;
      });
    }
  }

  bool _validerChamps() {
    if (_nomBouteilleController.text.isEmpty ||
        _cuveeBouteilleController.text.isEmpty ||
        _regionController.text.isEmpty ||
        _selectedRegion == null) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Text('Veuillez remplir tous les champs.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Center(
                  child: Text('OK'),
                ),
              ),
            ],
          );
        },
      );
      return false;
    }
    return true;
  }

  void clickModifier(BuildContext context, Bouteille bouteille) async {
    var appState = context.read<MyAppState>();

    appState.bouteilleEnAjout.nom = _nomBouteilleController.text;
    appState.bouteilleEnAjout.cuvee = _cuveeBouteilleController.text;
    appState.bouteilleEnAjout.Region = _regionController.text;
    appState.bouteilleEnAjout.categorie = _selectedRegion ?? "rouge";
    appState.bouteilleEnAjout.dateRecolt = _selectedDate.year;
    appState.bouteilleEnAjout.caveId = bouteille.caveId;
    appState.bouteilleEnAjout.emplacement = bouteille.emplacement;

    bool modification = await fetchModifierBouteille(appState.bouteilleEnAjout);

    if (modification) {
      print("bouteille modifié");
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => caveScreen(),
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Text('Échec de la modification de la bouteille.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  //TODO: a regarder après
                  Navigator.of(context).pop();
                },
                child: Center(
                  child: Text('OK'),
                ),
              ),
            ],
          );
        },
      );
    }
  }
}
