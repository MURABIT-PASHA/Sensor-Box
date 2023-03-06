import 'package:flutter/material.dart';
import 'package:sensor_box/backend/pathfinder.dart';

void main() {
  runApp(const SensorBox());
}

class SensorBox extends StatelessWidget {
  const SensorBox({super.key});

  // This widgets is the root of your application.
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

