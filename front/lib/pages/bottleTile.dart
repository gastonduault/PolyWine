import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import '../fetch/bouteille.dart';
import '../assets/colors.dart';
import './bottlePage.dart';
import '../main.dart';

class BouteilleTile extends StatelessWidget {
  final Bouteille bouteille;

  const BouteilleTile({Key? key, required this.bouteille}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        clickBottle(context, bouteille);
      },
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(white),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
            side: BorderSide(color: font_pink),
          ),
        ),
        padding: MaterialStateProperty.all(const EdgeInsets.all(10)),
        minimumSize: MaterialStateProperty.all(Size(100, 100)),
        maximumSize: MaterialStateProperty.all(Size(150, 200)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              Image.asset(
                "lib/assets/img/grape_${bouteille.categorie}.png",
                width: 50,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Image.asset(
                "lib/assets/img/bouteille_${bouteille.categorie}.png",
                width: 50,
              ),
            ],
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  bouteille.nom,
                  style: TextStyle(
                    fontFamily: 'RobotoRegular',
                    color: font_black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  bouteille.Region,
                  style: TextStyle(color: font_black, fontSize: 13),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

void clickBottle(BuildContext context, Bouteille bouteille) async {
  var appState = context.read<MyAppState>();
  appState.bouteilleEnAjout = bouteille;
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => bottlePage(
        bouteille: bouteille,
      ),
    ),
  );
}
