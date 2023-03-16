import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class SensorGraphicScreen extends StatefulWidget {
  final double width;
  final double height;
  final String sensorName;
  const SensorGraphicScreen(
      {Key? key,
      required this.width,
      required this.height,
      required this.sensorName})
      : super(key: key);

  @override
  State<SensorGraphicScreen> createState() => _SensorGraphicScreenState();
}

class _SensorGraphicScreenState extends State<SensorGraphicScreen> {
  late List<double> _selectedValues;
  List<StreamSubscription<dynamic>> streamSubscriptions =
      <StreamSubscription<dynamic>>[];
  late List<LiveData> chartData = [];
  late ChartSeriesController _chartSeriesController;

  Future getStreamData() async{

    switch(widget.sensorName){
      case "Gyroscope":
        streamSubscriptions.add(gyroscopeEvents.listen((GyroscopeEvent event) {
          setState(() {
            _selectedValues = <double>[event.x, event.y, event.z];
          });
        }));
        break;
      case "Magnetometer":
        streamSubscriptions
            .add(magnetometerEvents.listen((MagnetometerEvent event) {
          setState(() {
            _selectedValues = <double>[event.x, event.y, event.z];
          });
        }));
        break;
      case "User Accelerometer":
        streamSubscriptions
            .add(userAccelerometerEvents.listen((UserAccelerometerEvent event) {
          setState(() {
            _selectedValues = <double>[event.x, event.y, event.z];
          });
        }));
        break;
      case "Accelerometer":
        streamSubscriptions
            .add(accelerometerEvents.listen((AccelerometerEvent event) {
          setState(() {
            _selectedValues = <double>[event.x, event.y, event.z];
          });
        }));
        break;
      default:
        throw "Unassigned value error!";
    }
  }
  @override
  void initState() {
    super.initState();
    getStreamData();
    Timer.periodic(const Duration(milliseconds: 100), updateDataSource);
  }

  @override
  void dispose() {
    for (var subscription in streamSubscriptions) {
      subscription.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            body: SfCartesianChart(
                series: <LineSeries<LiveData, int>>[
          LineSeries<LiveData, int>(
            onRendererCreated: (ChartSeriesController controller) {
              _chartSeriesController = controller;
            },
            dataSource: chartData,
            color: const Color.fromRGBO(192, 108, 132, 1),
            xValueMapper: (LiveData sales, _) => sales.time,
            yValueMapper: (LiveData sales, _) => sales.x,
          )
        ],
                primaryXAxis: NumericAxis(
                    majorGridLines: const MajorGridLines(width: 0),
                    edgeLabelPlacement: EdgeLabelPlacement.shift,
                    interval: 3,
                    title: AxisTitle(text: 'Time (milliseconds)')),
                primaryYAxis: NumericAxis(
                    axisLine: const AxisLine(width: 0),
                    majorTickLines: const MajorTickLines(size: 0),
                    title: AxisTitle(text: widget.sensorName)))));
  }

  int time = 19;
  void updateDataSource(Timer timer) {
    chartData.add(LiveData(time++, _selectedValues[0],_selectedValues[1],_selectedValues[2]));
    chartData.removeAt(0);
    _chartSeriesController.updateDataSource(
        addedDataIndex: chartData.length - 1, removedDataIndex: 0);
  }
}

class LiveData {
  LiveData(this.time, this.x, this.y, this.z);
  final int time;
  final num x;
  final num y;
  final num z;
}
