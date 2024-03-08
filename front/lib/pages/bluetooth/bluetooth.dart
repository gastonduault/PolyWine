import 'package:flutter/material.dart';

class SecondRoute extends StatelessWidget {
  const SecondRoute({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Connection bluetooth'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Cette page n'est pas encore prête"),
            SizedBox(height: 20,),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Retour'),
            ),
          ],
        ),
      ),
    );
  }
}
