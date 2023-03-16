import 'package:flutter/material.dart';
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
              leading: Icon(Icons.download_for_offline, color: Colors.white,),
              title: Text("Record", style: TextStyle(color: Colors.white),),
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (builder)=>SaveSensorScreen()));
              },
            ),
            ListTile(
              leading: Icon(Icons.bar_chart_rounded, color: Colors.white,),
              title: Text("View sensor", style: TextStyle(color: Colors.white),),
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (builder)=>LiveSensorScreen()));
              },
            ),
          ],
        ),
      ),
    );
  }
}
