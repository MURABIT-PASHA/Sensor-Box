import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sensor_box/backend/file_saver.dart';
import 'package:sensor_box/ui/screens/phone/phone_record_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../widgets/frosted_glass_box.dart';
import '../screen_controller.dart';

class PhoneHomeScreen extends StatefulWidget {
  final ScreenController state;
  const PhoneHomeScreen({Key? key, required this.state}) : super(key: key);

  @override
  State<PhoneHomeScreen> createState() => _PhoneHomeScreenState();
}

class _PhoneHomeScreenState extends State<PhoneHomeScreen> {
  bool connection = false;
  String _strCode = "";
  int _intCode = 0;
  List<bool> iconStatus = [];
  List<String> selectedSensorNames = [];
  List<String> sensorsToBeSend = [];
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FileSaver _fileSaver = FileSaver();
  Future<void> connectDevice(int code) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    QuerySnapshot querySnapshot =
        await _firestore.collection('device_ids').get();
    for (var document in querySnapshot.docs) {
      if (document.get('id') == code) {
        connection = true;
        _firestore.collection('messages').add({
          'id': _intCode,
          'message': "get_list",
        });
        prefs.setBool('connected_device', true);
        prefs.setInt('device_id', _intCode);
        setState(() {});
      }
    }
  }

  Future<void> sendStandardRequest(int code) async {
    QuerySnapshot querySnapshot =
        await _firestore.collection('device_ids').get();
    for (var document in querySnapshot.docs) {
      if (document.get('id') == code) {
        _firestore.collection('messages').add({
          'id': _intCode,
          'message': "get_list",
        });
      }
    }
  }

  Future<bool> checkDevice() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final bool deviceStatus = prefs.getBool('connected_device') ?? false;
    return deviceStatus;
  }

  Future<int> getDeviceId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt('device_id') ?? 48151;
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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        title: const Text("Sensor Box"),
        actions: [
          IconButton(
              onPressed: () async {
                if (await checkDevice()) {
                  _intCode = await getDeviceId();
                  connection = true;
                  sendStandardRequest(_intCode);
                  setState(() {});
                  if (await _fileSaver.getFiles(_intCode)) {
                    setState(() {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text("Files found and downloading...")));
                    });
                    await _fileSaver.deleteFilesInStorage(_intCode);
                  }
                } else {
                  setState(() {
                    showDialog(
                        context: context,
                        builder: (builder) {
                          return AlertDialog(
                            title: const Text("Enter watch code"),
                            content: TextField(
                              keyboardType: TextInputType.number,
                              onChanged: (value) {
                                _strCode = value;
                              },
                            ),
                            actions: [
                              ElevatedButton(
                                  onPressed: () {
                                    try {
                                      _intCode = int.parse(_strCode);
                                      if (_intCode != 0) {
                                        connectDevice(_intCode);
                                      }
                                    } catch (exception) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                              content: Text(
                                                  "Wrong typed")));
                                    }
                                    Navigator.pop(context);
                                  },
                                  child: const Text("Connect"))
                            ],
                          );
                        });
                  });
                }
              },
              icon: Icon(
                Icons.watch,
                color: connection ? Colors.green : Colors.red,
              ))
        ],
      ),
      body: connection
          ? StreamBuilder<QuerySnapshot>(
              stream: _firestore.collection('messages').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData == true) {
                  final messages = snapshot.data?.docs.reversed;
                  for (var message in messages!) {
                    final int deviceID = message.get('id');
                    final String messageContext = message.get('message');
                    if (deviceID == _intCode && messageContext == 'set_list') {
                      List<dynamic> dynamicList = message.get('list');
                      selectedSensorNames =
                          dynamicList.map((item) => item.toString()).toList();
                      iconStatus =
                          List<bool>.filled(selectedSensorNames.length, false);
                      cleanMessages('set_list');
                    }
                  }
                  return Column(
                    children: [
                      SizedBox(
                        width: width,
                        height: height - 150,
                        child: ListView.builder(
                          itemCount: selectedSensorNames.length,
                          scrollDirection: Axis.vertical,
                          physics: const ScrollPhysics(),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          itemBuilder: (BuildContext context, int index) {
                            return FrostedGlassBox(
                              width: width,
                              height: 50.0,
                              child: ListTile(
                                leading: Icon(
                                  Icons.save,
                                  color: iconStatus[index]
                                      ? Colors.green
                                      : Colors.red,
                                ),
                                title: Text(
                                  selectedSensorNames[index],
                                  style: const TextStyle(color: Colors.white),
                                ),
                                onTap: () {
                                  setState(() {
                                    if (iconStatus[index]) {
                                      iconStatus[index] = false;
                                    } else {
                                      iconStatus[index] = true;
                                    }
                                  });
                                },
                                onLongPress: () {
                                  // TODO: Open live sensor
                                },
                              ),
                            );
                          },
                        ),
                      ),
                      selectedSensorNames.isNotEmpty
                          ? Container(
                              alignment: Alignment.center,
                              width: width,
                              height: 50,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10))),
                                onPressed: () {
                                  sensorsToBeSend = [];
                                  int counter = 0;
                                  for (var iconState in iconStatus) {
                                    if (iconState) {
                                      sensorsToBeSend
                                          .add(selectedSensorNames[counter]);
                                    }
                                    counter++;
                                  }
                                  if (sensorsToBeSend.isNotEmpty) {
                                    _firestore.collection('messages').add({
                                      'id': _intCode,
                                      'message': "start",
                                      'arguments': sensorsToBeSend,
                                    });
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (builder) =>
                                                PhoneRecordScreen(
                                                    code: _intCode)));
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                "Unfortunate error showed up")));
                                  }
                                },
                                child: const Text("Start Recording"),
                              ),
                            )
                          : const Center()
                    ],
                  );
                } else {
                  return Center(
                    child: Container(
                      width: width,
                      height: height,
                      alignment: Alignment.center,
                      child: Column(
                        children: const [
                          CircularProgressIndicator(
                            color: Colors.green,
                          ),
                          Text("Wait a minute..."),
                        ],
                      ),
                    ),
                  );
                }
              },
            )
          : const Center(
              child: Text("Connection waiting..."),
            ),
    );
  }
}
