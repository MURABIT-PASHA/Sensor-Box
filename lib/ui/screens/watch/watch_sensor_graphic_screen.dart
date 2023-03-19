import 'dart:async';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

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
  late List<double> _selectedValues;
  List<StreamSubscription<dynamic>> streamSubscriptions =
      <StreamSubscription<dynamic>>[];
  late List<List<LiveData>> _chartData;
  late List<ChartSeriesController> _chartController;
  final int _frequency = 100;
  int _time = 0;

  Future getStreamData() async {
    //TODO: Get selected sensor values
  }

  @override
  void initState() {
    super.initState();
    getStreamData();
    Timer.periodic(Duration(milliseconds: _frequency), test);
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
            lines(0),
            lines(1),
            lines(2),
          ],
          primaryXAxis: NumericAxis(
              majorGridLines: const MajorGridLines(width: 0),
              edgeLabelPlacement: EdgeLabelPlacement.shift,
              interval: 3,
              title: AxisTitle(text: 'Time (milliseconds)')),
          primaryYAxis: NumericAxis(
            axisLine: const AxisLine(width: 0),
            majorTickLines: const MajorTickLines(size: 0),
            title: AxisTitle(text: widget.sensorName),
          ),
        ),
      ),
    );
  }

  void updateDataSource(Timer timer, int index) {
    _chartData[index].add(LiveData(_time++, _selectedValues[0]));
    _chartData[index].removeAt(0);
    _chartController[index].updateDataSource(
        addedDataIndex: _chartData[index].length - 1, removedDataIndex: 0);
  }

  LineSeries<LiveData, int> lines(int index) {
    return LineSeries<LiveData, int>(
      onRendererCreated: (ChartSeriesController controller) {
        _chartController[index] = controller;
      },
      dataSource: _chartData[index],
      color: const Color.fromRGBO(192, 108, 132, 1),
      xValueMapper: (LiveData sales, _) => sales.time,
      yValueMapper: (LiveData sales, _) => sales.value,
    );
  }
  void test(Timer timer){
    print("This is a timestamp tester");
  }
}


class LiveData {
  LiveData(this.time, this.value);
  final int time;
  final num value;
}
