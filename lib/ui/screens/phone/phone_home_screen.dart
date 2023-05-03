import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:permission_handler/permission_handler.dart';
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
  List<int> iconStatus = [];
  List<String> selectedSensorNames = [];
  final _firestore = FirebaseFirestore.instance;
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

  Future<bool> checkDevice() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final bool deviceStatus = prefs.getBool('connected_device') ?? false;
    return deviceStatus;
  }

  Future<int> getDeviceId() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt('device_id') ?? 48151;
  }

  Future<bool> checkPermissions() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    bool bluetoothPermission = await Permission.bluetooth.isGranted;
    if (bluetoothPermission) {
      return true;
    } else {
      final bool requested =
          prefs.getBool('bluetooth_permission_requested') ?? false;
      if (requested) {
        return false;
      } else {
        final PermissionStatus status = await Permission.bluetooth.request();
        if (status == PermissionStatus.granted) {
          await prefs.setBool('bluetooth_permission_requested', true);
          return true;
        } else {
          return false;
        }
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
      backgroundColor: Colors.black12,
      appBar: AppBar(
        title: const Text("Sensor Box"),
        actions: [
          IconButton(
              onPressed: () async {
                if (await checkDevice()) {
                  _intCode = await getDeviceId();
                  connection = true;
                  print("Cihaz kayıtlı");
                  setState(() {});
                } else {
                  print("Cihaz kayıtlı değil");
                  showDialog(
                      context: context,
                      builder: (builder) {
                        return AlertDialog(
                          title: Text("Kodu girin"),
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
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content: Text(
                                                "Hatalı giriş yaptınız.")));
                                  }
                                  Navigator.pop(context);
                                },
                                child: Text("Bağlan"))
                          ],
                        );
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
            stream: _firestore
                .collection('messages')
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData == true) {
                final messages = snapshot.data?.docs.reversed;
                for (var message in messages!) {
                  final int deviceID = message.get('id');
                  final String messageContext = message.get('message');
                  if (deviceID == _intCode &&
                      messageContext == 'set_list') {
                    List<dynamic> dynamicList = message.get('list');
                    selectedSensorNames = dynamicList.map((item) => item.toString()).toList();
                  }
                }
                return ListView.builder(
                  itemCount: selectedSensorNames.length,
                  scrollDirection: Axis.vertical,
                  physics: ScrollPhysics(),
                  padding:
                      EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  itemBuilder: (BuildContext context, int index) {
                    return FrostedGlassBox(
                      width: width,
                      height: 50.0,
                      child: ListTile(
                        leading: Icon(
                          Icons.save,
                          color: iconStatus.contains(index)
                              ? Colors.green
                              : Colors.red,
                        ),
                        title: Text(
                          selectedSensorNames[index],
                          style: const TextStyle(color: Colors.white),
                        ),
                        onTap: () {
                          setState(() {
                            if(iconStatus.contains(index)){
                              iconStatus.remove(index);
                            }else{
                              iconStatus.add(index);
                            }
                          });
                        },
                        onLongPress: (){
                          // TODO: Open live sensor
                        },
                      ),
                    );
                  },
                );
              } else {
                return Center(
                  child: Column(
                    children: [
                      CircularProgressIndicator(color: Colors.green,),
                      Text("Something went wrong..."),
                    ],
                  ),
                );
              }
            },
          )
          : Center(
              child: Text("Bağlantı bekleniyor..."),
            ),
    );
  }
}
