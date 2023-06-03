import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import "package:flutter/material.dart";
import 'package:sensor_box/backend/file_saver.dart';
import 'package:sensor_box/backend/sensor_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WatchRecordScreen extends StatefulWidget {
  final Duration duration;
  final List<String> sensorNames;
  const WatchRecordScreen(
      {Key? key, required this.duration, required this.sensorNames})
      : super(key: key);

  @override
  State<WatchRecordScreen> createState() => _WatchRecordScreenState();
}

class _WatchRecordScreenState extends State<WatchRecordScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FileSaver _fileSaver = FileSaver();
  late Timer _timer;
  late Timer _writeTimer;
  final DateTime _currentTime = DateTime.now();
  int _seconds = 0;
  int _intCode = 0;

  Future<void> checkDeviceCode() async {
    final SharedPreferences _prefs = await SharedPreferences.getInstance();
    int code = _prefs.getInt('device_id') ?? 0;
    if (code != 0) {
      _intCode = code;
    }
  }

  @override
  void initState() {
    super.initState();
    checkDeviceCode();
    SensorData sensorData = SensorData();
    sensorData.initializeSensors(widget.sensorNames);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _seconds++;
      });
    });
    _writeTimer = Timer.periodic(widget.duration, (timer) {
        sensorData.writeData(DateTime.now(), _currentTime);
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _writeTimer.cancel();
    super.dispose();
  }

  String get timerString {
    int minutes = _seconds ~/ 60;
    int seconds = _seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  void _onTap() {
    if (_timer.isActive) {
      _timer.cancel();
      _writeTimer.cancel();
      sendFiles().then((value) => print(value));
      Navigator.pop(context);
    } else {
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          _seconds++;
        });
      });
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
  Future<bool> sendFiles() async{
    print("Dosya gönderiliyor....");
    if(await _fileSaver.sendFiles(_intCode)){
      print("Dosyalar gönderildi");
      return true;
    }
    else{
      print("Dosyalar gönderilemedi");
      return false;
    }
  }
  @override
  Widget build(BuildContext context) {
    Color backgroundColor = const Color(0xFF1C1C1E);
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        color: backgroundColor,
        alignment: Alignment.center,
        width: width,
        height: height,
        child: StreamBuilder<QuerySnapshot>(
            stream: _firestore.collection('messages').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData == true) {
                final messages = snapshot.data?.docs.reversed;
                for (var message in messages!) {
                  final int deviceID = message.get('id');
                  final String messageContext = message.get('message');
                  if (deviceID == _intCode && messageContext == 'stop') {
                    cleanMessages('stop');
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      _onTap();
                    });
                  }
                }
              }
              return Center(
                child: GestureDetector(
                  onTap: _onTap,
                  child: Container(
                    margin: const EdgeInsets.all(50),
                    alignment: Alignment.center,
                    height: width - 20,
                    width: height - 20,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    child: Text(
                      timerString,
                      style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 12),
                    ),
                  ),
                ),
              );
            }),
      ),
    );
  }
}
