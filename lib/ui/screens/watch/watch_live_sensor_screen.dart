import 'package:flutter/material.dart';
import 'package:sensor_box/ui/screens/watch/watch_sensor_graphic_screen.dart';

class LiveSensorScreen extends StatefulWidget {
  final List<String> sensorNames;
  const LiveSensorScreen({Key? key, required this.sensorNames}) : super(key: key);

  @override
  State<LiveSensorScreen> createState() => _LiveSensorScreenState();
}

class _LiveSensorScreenState extends State<LiveSensorScreen> {
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
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        title: const Text("Pick sensor to show", style: TextStyle(color: Colors.white),),
      ),
        body: Container(
          color: Colors.black,
          padding: const EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
          alignment: Alignment.center,
          height: height,
          width: width,
          child: ListView.builder(
            itemCount: widget.sensorNames.length,
            itemBuilder: (BuildContext context, int index) {
              return ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)
                      )
                  ),
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (builder)=>WatchSensorGraphicScreen(height: height,width: width,sensorName: widget.sensorNames[index],)));
                  }, child: Text(widget.sensorNames[index], style: const TextStyle(color: Colors.black),),);
            },
          ),
        ));
  }
}