import 'package:flutter/material.dart';

import 'screens/demo_screen.dart';

void main() => runApp(const IsolateDemoApp());

class IsolateDemoApp extends StatelessWidget {
  const IsolateDemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Isolates demo',
      theme: ThemeData(colorSchemeSeed: Colors.indigo, useMaterial3: true),
      home: const DemoScreen(),
    );
  }
}
