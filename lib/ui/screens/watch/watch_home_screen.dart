import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sensor_box/ui/screens/watch/watch_live_sensor_screen.dart';
import 'package:sensor_box/ui/screens/watch/watch_save_sensors_screen.dart';
import '../screen_controller.dart';

class WatchHomeScreen extends StatefulWidget {
  final ScreenController state;
  const WatchHomeScreen({Key? key, required this.state}) : super(key: key);

  @override
  State<WatchHomeScreen> createState() => _WatchHomeScreenState();
}

class _WatchHomeScreenState extends State<WatchHomeScreen> {
  static const sensorChannel = MethodChannel('com.ktun.edu.tr/sensor');
  late List<String> sensorNames;
  Future<List<String>> getSensorList() async{
    final arguments = {};
    return await sensorChannel.invokeMethod('getSensorNames',arguments);
  }
  @override
  void initState() {
    getSensorList().then((value) => sensorNames = value);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        color: Colors.black,
        width: width,
        height: height,
        padding: const EdgeInsets.all(5),
        child: ListView(
          children: [
            ListTile(
              leading: const Icon(Icons.download_for_offline, color: Colors.white,),
              title: const Text("Record", style: TextStyle(color: Colors.white),),
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (builder)=>SaveSensorScreen(sensorNames: sensorNames)));
              },
            ),
            ListTile(
              leading: const Icon(Icons.bar_chart_rounded, color: Colors.white,),
              title: const Text("View sensor", style: TextStyle(color: Colors.white),),
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (builder)=>LiveSensorScreen(sensorNames: sensorNames)));
              },
            ),
          ],
        ),
      ),
    );
  }
}
