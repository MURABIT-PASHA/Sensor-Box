import 'package:flutter/material.dart';
import 'package:sensor_box/ui/widgets/frosted_glass_box.dart';
import '../screen_controller.dart';

class WatchSensorTimerScreen extends StatefulWidget {
  final List<String> sensorNames;
  const WatchSensorTimerScreen({Key? key, required this.sensorNames}) : super(key: key);

  @override
  State<WatchSensorTimerScreen> createState() => _WatchSensorTimerScreenState();
}

class _WatchSensorTimerScreenState extends State<WatchSensorTimerScreen> {

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
              height: height / 2,
              child: Container(
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      alignment: Alignment.center,
                      width: width - 70,
                      height: 30,
                      child: TextField(
                        textAlignVertical: TextAlignVertical.bottom,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          hintText: "Time delay",
                          hintStyle: const TextStyle(color: Colors.white12, fontStyle: FontStyle.italic)
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    DropdownButton(
                      items: [
                        DropdownMenuItem(child: Text("ms"),value: "ms",),
                        DropdownMenuItem(child: Text("s"),value: "s",)
                      ],
                      onChanged: (value){
                        print(value);
                      }
                  ),
                  ],
                ),
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

                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
