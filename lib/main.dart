import 'package:flutter/material.dart';

void main() {
  runApp(const FlutterCepApp());
}

class FlutterCepApp extends StatelessWidget {
  const FlutterCepApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Consulta de CEP',
      home: Container(),
    );
  }
}
