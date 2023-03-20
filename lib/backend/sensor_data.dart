import 'dart:async';
import 'dart:math';
import 'package:flutter/services.dart';

class SensorData {
  final Duration interval;
  final Duration duration;
  static const sensorChannel = MethodChannel('com.ktun.edu.tr/sensor');
  SensorData({required this.interval, required this.duration});
  // <Map<String,Map<String,int>>>
  Stream getSensorData() async* {
    final stopwatch = Stopwatch()..start();
    while (stopwatch.elapsed < duration) {
      await Future.delayed(Duration(milliseconds: interval.inMilliseconds));
      yield 'Hello${Random.secure().nextInt(25)}';
    }
  }
  Future<Map<dynamic,dynamic>> getSensorList() async{
    var sensors = await sensorChannel.invokeMethod('getSensorValues') as Map;
    print(sensors.isEmpty);
    return sensors;
  }
}
