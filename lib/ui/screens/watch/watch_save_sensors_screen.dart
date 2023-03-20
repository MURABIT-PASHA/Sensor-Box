import 'package:flutter/material.dart';

import '../../../backend/sensor_data.dart';

class WatchSaveSensorScreen extends StatefulWidget {
  final List<String> sensorNames;
  const WatchSaveSensorScreen({Key? key, required this.sensorNames})
      : super(key: key);

  @override
  State<WatchSaveSensorScreen> createState() => _WatchSaveSensorScreenState();
}

class _WatchSaveSensorScreenState extends State<WatchSaveSensorScreen> {
  late List<bool> iconStatus;
  late List<String> selectedSensorNames;
  Map<String, bool> selectedSensors = {};
  late Map sensorNames = {};

  @override
  void initState() {
    selectedSensorNames = widget.sensorNames;
    iconStatus = List.filled(widget.sensorNames.length, false);
    SensorData data = SensorData(interval: Duration(seconds: 2), duration: Duration(seconds: 10));
    data.getSensorData().listen((event) {print(event);});
    data.getSensorList().then((value){
      sensorNames = value;
    });
    print(sensorNames);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        height: height,
        width: width,
        padding: const EdgeInsets.only(
          top: 10,
          left: 5,
          right: 5,
        ),
        child: Column(
          children: [
            SizedBox(
              width: width,
              height: height - 70,
              child: ListView.builder(
                itemCount: widget.sensorNames.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    leading: Icon(
                      Icons.save,
                      color: iconStatus[index] ? Colors.green : Colors.red,
                    ),
                    title: Text(
                      selectedSensorNames[index],
                      style: const TextStyle(color: Colors.white),
                    ),
                    onTap: () {
                      setState(() {
                        iconStatus[index] = !iconStatus[index];
                      });
                    },
                  );
                },
              ),
            ),
            Container(
                padding: const EdgeInsets.only(left: 15, right: 15),
                width: width,
                height: 45,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade800,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                    onPressed: () {
                      //TODO: Start save process
                    },
                    child: const Text('Save')))
          ],
        ),
      ),
    );
  }
}
