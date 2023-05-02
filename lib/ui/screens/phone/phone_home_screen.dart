import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:permission_handler/permission_handler.dart';
import '../screen_controller.dart';

class PhoneHomeScreen extends StatefulWidget {
  final ScreenController state;
  const PhoneHomeScreen({Key? key, required this.state}) : super(key: key);

  @override
  State<PhoneHomeScreen> createState() => _PhoneHomeScreenState();
}

class _PhoneHomeScreenState extends State<PhoneHomeScreen> {
  static const String _methodChannelName =
      'com.ktun.edu.tr/androidMethodChannel'; // keep it unique
  final MethodChannel _methodChannel = const MethodChannel(_methodChannelName);
  bool connection = false;
  bool status = false;
  String connectedDeviceAddress = "";
  Future<List> getData() async {
    List tmp = await _methodChannel.invokeMethod('getDevices');
    return tmp;
  }
  Future<bool> getConnect(String deviceAddress) async{
    connection = await _methodChannel.invokeMethod('getConnect',{'deviceAddress': deviceAddress});
    return connection;
  }
  Future<bool> breakConnect() async{
      connection = await _methodChannel.invokeMethod('closeConnection');
      return connection;
  }
  Future<bool> getBluetoothStatus() async{
    status = await _methodChannel.invokeMethod('getStatus');
    return status;
  }
  Future<bool> sendMessage() async{
    return await _methodChannel.invokeMethod('sendMessage');
  }
  Future<String> getMessage() async{
    return await _methodChannel.invokeMethod('getMessage');
  }

  Future<bool> checkPermissions() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    bool bluetoothPermission = await Permission.bluetooth.isGranted;
    if (bluetoothPermission) {
      return true;
    } else {
      final bool requested = prefs.getBool('bluetooth_permission_requested') ?? false;
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
    getData().then((value) => value.forEach((element) {print(element);}));
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: Text("Sensor Box"),
        actions: [
          IconButton(onPressed: ()async{
            if(await getBluetoothStatus()){
              List deviceList = await getData();
              for (Map device in deviceList){
                if(device['type'] == 'Unknown'){
                  if(await getConnect(device['address'])){
                    setState(() {});
                    connectedDeviceAddress = device['address'];
                    print(connectedDeviceAddress);
                  }
                }
              }
              if(connectedDeviceAddress == ""){
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Make sure your wear device is paired")));
              }else{
                if(await sendMessage()){
                  print("Mesaj gönderildi");
                }else{
                  print("Mesaj gönderilemedi");
                }
              }
            }
            else{
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Activate your bluetooth setting")));
            }

          }, icon: Icon(Icons.watch,color: connection?Colors.green:Colors.red,))
        ],
      ),
      body: Center(
        child: Text("This is bluetooth test"),
      ),
    );
  }
}
