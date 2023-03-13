import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';
import '../screen_controller.dart';

class WatchHomeScreen extends StatefulWidget {
  final ScreenController state;
  const WatchHomeScreen({Key? key, required this.state}) : super(key: key);

  @override
  State<WatchHomeScreen> createState() => _WatchHomeScreenState();
}

class _WatchHomeScreenState extends State<WatchHomeScreen> {
  late List<double> _accelerometerValues;
  late List<double> _userAccelerometerValues;
  late List<double> _gyroscopeValues;
  late List<double> _magnetometerValues;
  List<StreamSubscription<dynamic>> _streamSubscriptions = <StreamSubscription<dynamic>>[];
  @override
  void initState() {
    super.initState();
    _streamSubscriptions
        .add(accelerometerEvents.listen((AccelerometerEvent event) {
      setState(() {
        _accelerometerValues = <double>[event.x, event.y, event.z];
      });
    }));
    _streamSubscriptions
        .add(userAccelerometerEvents.listen((UserAccelerometerEvent event) {
      setState(() {
        _userAccelerometerValues = <double>[event.x, event.y, event.z];
      });
    }));
    _streamSubscriptions.add(gyroscopeEvents.listen((GyroscopeEvent event) {
      setState(() {
        _gyroscopeValues = <double>[event.x, event.y, event.z];
      });
    }));
    _streamSubscriptions
        .add(magnetometerEvents.listen((MagnetometerEvent event) {
      setState(() {
        _magnetometerValues = <double>[event.x, event.y, event.z];
      });
    }));
  }

  @override
  void dispose() {
    for (var subscription in _streamSubscriptions) {
      subscription.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery
        .of(context)
        .size
        .height;
    double width = MediaQuery
        .of(context)
        .size
        .width;
    return Scaffold(
      body: SizedBox(
        width: width,
        height: height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: height/2,
              width: width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: height/2,
                    width: width/2,
                    child: ListView(
                      children: <Widget>[
                        const Text('Accelerometer'),
                        if (_accelerometerValues != [])
                          Text('X: ${_accelerometerValues[0].toStringAsFixed(3)}'),
                        if (_accelerometerValues != [])
                          Text('Y: ${_accelerometerValues[1].toStringAsFixed(3)}'),
                        if (_accelerometerValues != [])
                          Text('Z: ${_accelerometerValues[2].toStringAsFixed(3)}'),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: height/2,
                    width: width/2,
                    child: ListView(
                      children: <Widget>[
                        const Text('User Accelerometer'),
                        if (_userAccelerometerValues != [])
                          Text(
                              'X: ${_userAccelerometerValues[0].toStringAsFixed(3)}'),
                        if (_userAccelerometerValues != [])
                          Text(
                              'Y: ${_userAccelerometerValues[1].toStringAsFixed(3)}'),
                        if (_userAccelerometerValues != [])
                          Text(
                              'Z: ${_userAccelerometerValues[2].toStringAsFixed(3)}'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    const Text('Gyroscope'),
                    if (_gyroscopeValues != [])
                      Text('X: ${_gyroscopeValues[0].toStringAsFixed(3)}'),
                    if (_gyroscopeValues != [])
                      Text('Y: ${_gyroscopeValues[1].toStringAsFixed(3)}'),
                    if (_gyroscopeValues != [])
                      Text('Z: ${_gyroscopeValues[2].toStringAsFixed(3)}'),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    const Text('Magnetometer'),
                    if (_magnetometerValues != [])
                      Text('X: ${_magnetometerValues[0].toStringAsFixed(3)}'),
                    if (_magnetometerValues != [])
                      Text('Y: ${_magnetometerValues[1].toStringAsFixed(3)}'),
                    if (_magnetometerValues != [])
                      Text('Z: ${_magnetometerValues[2].toStringAsFixed(3)}'),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
