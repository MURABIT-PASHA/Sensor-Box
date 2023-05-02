import 'dart:async';

import "package:flutter/material.dart";
import 'package:sensor_box/backend/sensor_data.dart';

class WatchRecordScreen extends StatefulWidget {
  final Duration duration;
  final List<String> sensorNames;
  const WatchRecordScreen({Key? key, required this.duration, required this.sensorNames}) : super(key: key);

  @override
  State<WatchRecordScreen> createState() => _WatchRecordScreenState();
}

class _WatchRecordScreenState extends State<WatchRecordScreen> {
  late Timer _timer;
  late Timer _writeTimer;
  final DateTime _currentTime = DateTime.now();
  int _seconds = 0;

  @override
  void initState() {
    super.initState();
    SensorData sensorData = SensorData();
    sensorData.initializeSensors(widget.sensorNames);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _seconds++;
      });
    });
    _writeTimer = Timer.periodic(widget.duration, (timer) {
      setState(() {
        sensorData.writeData(DateTime.now(),_currentTime);
      });
    });

  }

  @override
  void dispose() {
    _timer.cancel();
    _writeTimer.cancel();
    super.dispose();
  }

  String get timerString {
    int minutes = _seconds ~/ 60;
    int seconds = _seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  void _onTap() {
    if (_timer.isActive) {
      _timer.cancel();
      Navigator.pop(context);
    } else {
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          _seconds++;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = const Color(0xFF1C1C1E);
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        color: backgroundColor,
        alignment: Alignment.center,
        width: width,
        height: height,
        child: Center(
          child: GestureDetector(
            onTap: _onTap,
            child: Container(
              margin: const EdgeInsets.all(50),
              alignment: Alignment.center,
              height: 10,
              width: 10,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              child: Text(
                timerString,
                style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 12),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
