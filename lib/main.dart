import 'package:flutter/material.dart';
import 'package:ouakr/anasayfa.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(WandermApp());
}

class WandermApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WandermApp',
      home: Anasayfa(),
    );
  }
}
