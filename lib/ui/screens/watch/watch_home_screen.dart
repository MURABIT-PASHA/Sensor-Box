import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sensor_box/ui/screens/watch/watch_info_screen.dart';
import 'package:sensor_box/ui/screens/watch/watch_live_sensor_screen.dart';
import 'package:sensor_box/ui/screens/watch/watch_record_screen.dart';
import 'package:sensor_box/ui/screens/watch/watch_save_sensors_screen.dart';
import 'package:sensor_box/ui/widgets/frosted_glass_box.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  int _intCode = 0;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future<List<String>> getSensorList() async {
    List<Object?> sensors =
        await sensorChannel.invokeMethod('getSensorNamesList');
    List<String> sensorNames = sensors.map((item) => item.toString()).toList();
    return sensorNames;
  }

  int getFiveDigitsNumber() {
    int milliseconds = DateTime.now().millisecondsSinceEpoch;
    int lastFiveDigits = milliseconds % 10000;
    return lastFiveDigits;
  }

  Future<void> initialCode() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    int fiveDigits = getFiveDigitsNumber();
    QuerySnapshot querySnapshot =
        await _firestore.collection('device_ids').get();
    for (var document in querySnapshot.docs) {
      if (document.get('id') == fiveDigits) {
        fiveDigits = getFiveDigitsNumber();
      }
    }
    _firestore.collection('device_ids').add({'id': fiveDigits});
    prefs.setInt('device_id', fiveDigits);
    _intCode = fiveDigits;
  }

  Future<bool> checkDeviceCode() async {
    final SharedPreferences _prefs = await SharedPreferences.getInstance();
    int code = _prefs.getInt('device_id') ?? 0;
    if (code != 0) {
      _intCode = code;
      return true;
    } else {
      return false;
    }
  }

  Future<void> cleanMessages(String type) async {
    QuerySnapshot querySnapshot = await _firestore.collection('messages').get();
    for (var document in querySnapshot.docs) {
      if (document.get('id') == _intCode && document.get('message') == type) {
        await document.reference.delete();
      }
    }
  }

  @override
  void initState() {
    getSensorList().then((value) {
      sensorNames = value;
    });
    checkDeviceCode().then((value) {
      if (!value) {
        initialCode();
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    Color backgroundColor = const Color(0xFF1C1C1E);
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
          stream: _firestore.collection('messages').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData == true) {
              final messages = snapshot.data?.docs.reversed;
              for (var message in messages!) {
                final int deviceID = message.get('id');
                final String messageContext = message.get('message');
                if (deviceID == _intCode && messageContext == 'get_list') {
                  _firestore.collection('messages').add({
                    'id': _intCode,
                    'list': sensorNames,
                    'message': 'set_list'
                  });
                  cleanMessages('get_list');
                } else if (deviceID == _intCode && messageContext == 'start') {
                  List<dynamic> dynamicList = message.get('arguments');
                  List<String> arguments =
                      dynamicList.map((e) => e.toString()).toList();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (builder) => WatchRecordScreen(
                              duration: Duration(seconds: 1),
                              sensorNames: arguments)));
                  cleanMessages('start');
                }
              }
              return Container(
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
                                  builder: (builder) => WatchSaveSensorScreen(
                                      sensorNames: sensorNames)));
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
                                  builder: (builder) => LiveSensorScreen(
                                      sensorNames: sensorNames)));
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
                                  builder: (builder) => WatchInfoScreen(
                                        code: _intCode,
                                      )));
                        },
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return Container(
                width: width,
                height: height,
                alignment: Alignment.center,
                child: Column(
                  children: const [
                    CircularProgressIndicator(
                      color: Colors.green,
                    ),
                    Text("Ana menü yükleniyor..."),
                  ],
                ),
              );
            }
          }),
    );
  }
}
