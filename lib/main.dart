import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:sensor_box/backend/pathfinder.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(SensorBox());
}

class SensorBox extends StatelessWidget {
  const SensorBox({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sensor Box',
      theme: ThemeData(
        primaryColorDark: const Color(0xFF0D1117),
        primarySwatch: Colors.blue,
      ),
      home: const Pathfinder()
    );
  }
}

