import 'package:flutter/material.dart';
import 'package:real_time_chart/real_time_chart.dart';
import 'package:sensor_box/backend/sensor_data.dart';
import 'package:sensor_box/backend/sensor_type_holder.dart';
import 'package:sensor_box/ui/widgets/frosted_glass_box.dart';

class PhoneLiveSensorScreen extends StatefulWidget {
  final String sensorName;
  const PhoneLiveSensorScreen({Key? key, required this.sensorName})
      : super(key: key);

  @override
  State<PhoneLiveSensorScreen> createState() => _PhoneLiveSensorScreenState();
}

class _PhoneLiveSensorScreenState extends State<PhoneLiveSensorScreen> {
  SensorData sensorData = SensorData();
  @override
  void initState() {
    //TODO: Send 'startStream' message to watch
    super.initState();
  }
  @override
  void dispose(){
    //TODO: Send 'stopStream' message to watch
    super.dispose();
  }
  List<String> getTypeOfSensor() {
    return SensorTypeHolder(widget.sensorName).sensorName;
  }
  Stream<double> startStreamData(String dataName) {
    return Stream.periodic(const Duration(milliseconds: 500), (_) {
      return double.parse(
          sensorData.getSensorsInfo()[0][dataName]!.split(' ')[0]);
    }).asBroadcastStream();
  }
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    Color backgroundColor = const Color(0xFF1C1C1E);
    List<Widget> stackedCharts = buildStackedCharts(getTypeOfSensor().length);
    return Scaffold(
      body: Container(
        height: height,
        width: width,
        color: backgroundColor,
        alignment: Alignment.center,
        child: FrostedGlassBox(
          width: width - 10,
          height: width - 10,
          child: Stack(
            children: stackedCharts,
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
