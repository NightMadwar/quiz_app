import 'package:flutter/material.dart';

class FinishPage extends StatelessWidget {
  const FinishPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          body: Center(
        child: Text("Congratulations for make the exam"),
      )),
    );
  }
}
