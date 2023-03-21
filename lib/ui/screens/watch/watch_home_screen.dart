import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sensor_box/ui/screens/watch/watch_live_sensor_screen.dart';
import 'package:sensor_box/ui/screens/watch/watch_save_sensors_screen.dart';
import 'package:sensor_box/ui/widgets/frosted_glass_box.dart';
import '../screen_controller.dart';

class WatchHomeScreen extends StatefulWidget {
  final ScreenController state;
  const WatchHomeScreen({Key? key, required this.state}) : super(key: key);

  @override
  State<WatchHomeScreen> createState() => _WatchHomeScreenState();
}

class _WatchHomeScreenState extends State<WatchHomeScreen> {
  static const sensorChannel =
      MethodChannel('com.ktun.edu.tr/androidMethodChannel');
  late List<String> sensorNames;
  Future<List<String>> getSensorList() async {
    List<Object?> sensors =
        await sensorChannel.invokeMethod('getSensorNamesList');
    List<String> sensorNames = sensors.map((item) => item.toString()).toList();
    return sensorNames;
  }

  @override
  void initState() {
    getSensorList().then((value) {
      sensorNames = value;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    Color backgroundColor = const Color(0xFF1C1C1E);
    return Scaffold(
      body: Container(
        color: backgroundColor,
        width: width,
        height: height,
        padding: const EdgeInsets.all(5),
        child: ListView(
          children: [
            FrostedGlassBox(
              width: width - 10,
              height: height / 3 - 5,
              child: ListTile(
                leading: const Icon(
                  Icons.download_for_offline,
                  color: Colors.white,
                ),
                title: const Text(
                  "Record",
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (builder) =>
                              WatchSaveSensorScreen(sensorNames: sensorNames)));
                },
              ),
            ),
            FrostedGlassBox(
              width: width - 10,
              height: height / 3 - 5,
              child: ListTile(
                leading: const Icon(
                  Icons.bar_chart_rounded,
                  color: Colors.white,
                ),
                title: const Text(
                  "View sensor",
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (builder) =>
                              LiveSensorScreen(sensorNames: sensorNames)));
                },
              ),
            ),
            FrostedGlassBox(
              width: width - 10,
              height: height / 3 - 5,
              child: ListTile(
                leading: const Icon(
                  Icons.info,
                  color: Colors.white,
                ),
                title: const Text(
                  "Credits",
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (builder) =>
                              LiveSensorScreen(sensorNames: sensorNames)));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
