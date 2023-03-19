import 'package:flutter/services.dart';
class SaveSensorValues{
  final String name;
  final DateTime timestamp;

  SaveSensorValues(this.name, this.timestamp);

  Future<void> call_method() async{
    final channel = MethodChannel('sensors');
    channel.setMethodCallHandler((call) async {
      if (call.method == 'sensorData') {
        final sensorData = call.arguments.toString().split(',');
        // sensör verilerini işle
      }
    });
  }

}