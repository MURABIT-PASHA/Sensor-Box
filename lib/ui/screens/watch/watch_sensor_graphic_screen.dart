import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sensor_box/backend/sensor_data.dart';
import 'package:sensor_box/ui/widgets/frosted_glass_box.dart';
import 'package:real_time_chart/real_time_chart.dart';

class WatchSensorGraphicScreen extends StatefulWidget {
  final double width;
  final double height;
  final String sensorName;
  const WatchSensorGraphicScreen(
      {Key? key,
      required this.width,
      required this.height,
      required this.sensorName})
      : super(key: key);

  @override
  State<WatchSensorGraphicScreen> createState() =>
      _WatchSensorGraphicScreenState();
}

class _WatchSensorGraphicScreenState extends State<WatchSensorGraphicScreen> {
  SensorData sensorData = SensorData();
  List<String> getTypeOfSensor() {
    switch (widget.sensorName) {
      case "Accelerometer":
        return ['Along X-axis', 'Along Y-axis', 'Along Z-axis'];
      case "Gyroscope":
        return [
          'Angular Speed around X',
          'Angular Speed around Y',
          'Angular Speed around Z'
        ];
      case "Magnetic Field":
        return ['Along X-axis', 'Along Y-axis', 'Along Z-axis'];
      case "Orientation":
        return [];
      case "Ambient Temperature":
        return ['Temperature'];
      case "Proximity":
        return ['Distance From Screen'];
      case "Light":
        return ['Ambient Light Level'];
      case "Pressure":
        return ['Atmospheric Pressure'];
      case "Humidity":
        return ['Relative Air Humidity'];
      case "Uncalibrated Magnetic field":
        return [];
      case "Uncalibrated Gyroscope":
        return [
          'Angular Speed around X',
          'Angular Speed around Y',
          'Angular Speed around Z',
          'Estimated Drift around X',
          'Estimated Drift around Y',
          'Estimated Drift around Z'
        ];
      case "Heart Rate":
        return ['Confidence'];
      case "Gesture":
        return [];
      case "Game Rotation":
        return [
          'X * Sin(\u{03b8}/2)',
          'Y * Sin(\u{03b8}/2)',
          'Z * Sin(\u{03b8}/2)'
        ];
      case "Geographic Magnetic Rotation":
        return [
          'X * Sin(\u{03b8}/2)',
          'Y * Sin(\u{03b8}/2)',
          'Z * Sin(\u{03b8}/2)',
          'Cos(\u{03b8}/2)'
        ];
      case "Gravity":
        return ['Along X-axis', 'Along Y-axis', 'Along Z-axis'];
      case "Linear Acceleration":
        return ['Along X-axis', 'Along Y-axis', 'Along Z-axis'];
      case "Rotation":
        return [
          'X * Sin(\u{03b8}/2)',
          'Y * Sin(\u{03b8}/2)',
          'Z * Sin(\u{03b8}/2)',
          'Cos(\u{03b8}/2)'
        ];
      default:
        return [];
    }
  }

  Stream<double> startStreamData(String dataName) {
    return Stream.periodic(const Duration(milliseconds: 500), (_) {
      return double.parse(
          sensorData.getSensorsInfo()[0][dataName]!.split(' ')[0]);
    }).asBroadcastStream();
  }

  @override
  void initState() {
    super.initState();
    sensorData.initializeSensors([widget.sensorName]);
  }

  @override
  void dispose() {
    // TODO: add on will pop scope
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> stackedCharts = buildStackedCharts(getTypeOfSensor().length);
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: FrostedGlassBox(
            width: widget.width,
            height: widget.height,
            child: Container(
              width: widget.width - 10,
              height: widget.height - 10,
              alignment: Alignment.center,
              child: Stack(
                children: stackedCharts,
              )
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> buildStackedCharts(int length) {
    List<Widget> charts = [];
    for (int i = 0; i < length; i++) {
      Widget chart = RealTimeGraph(
        xAxisColor: Colors.white,
        yAxisColor: Colors.white,
        graphColor: Colors.red,
        stream: startStreamData(getTypeOfSensor()[i]),
        supportNegativeValuesDisplay: true,
      );
      charts.add(
        Positioned.fill(
          child: Align(
            alignment: Alignment.center,
            child: chart,
          ),
        ),
      );
    }
    return charts;
  }
}
