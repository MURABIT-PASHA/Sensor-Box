import 'package:flutter/material.dart';
import 'package:sensor_box/ui/screens/watch/sensor_graphic_screen.dart';

class LiveSensorScreen extends StatefulWidget {
  const LiveSensorScreen({Key? key}) : super(key: key);

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
        title: Text("Pick sensor to show", style: TextStyle(color: Colors.white),),
      ),
        body: Container(
          color: Colors.black,
          padding: EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
          alignment: Alignment.center,
          height: height,
          width: width,
          child: ListView(
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)
                  )
                ),
                  onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (builder)=>SensorGraphicScreen(height: height,width: width,sensorName: "Gyroscope",)));
              }, child: Text("Gyroscope", style: TextStyle(color: Colors.black),)),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)
                      )
                  ),
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (builder)=>SensorGraphicScreen(height: height,width: width,sensorName: "Magnetometer",)));
                  }, child: Text("Magnometer", style: TextStyle(color: Colors.black),)),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)
                      )
                  ),
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (builder)=>SensorGraphicScreen(height: height,width: width,sensorName: "User Accelerometer",)));
                  }, child: Text("User Accelerometer", style: TextStyle(color: Colors.black),)),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)
                      )
                  ),
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (builder)=>SensorGraphicScreen(height: height,width: width,sensorName: "Accelerometer",)));
                  }, child: Text("Accelerometer", style: TextStyle(color: Colors.black),)),
            ],
          ),
        ));
  }
}