import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PhoneRecordScreen extends StatefulWidget {
  final int code;
  const PhoneRecordScreen({Key? key, required this.code}) : super(key: key);

  @override
  State<PhoneRecordScreen> createState() => _PhoneRecordScreenState();
}

class _PhoneRecordScreenState extends State<PhoneRecordScreen> {
  late Timer _timer;
  int _seconds = 0;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _seconds++;
      });
    });

  }
  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String get timerString {
    int minutes = _seconds ~/ 60;
    int seconds = _seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  Future<void> _onTap() async{
    if (_timer.isActive) {
      _timer.cancel();
      QuerySnapshot querySnapshot =
          await _firestore.collection('device_ids').get();
      for (var document in querySnapshot.docs) {
        if (document.get('id') == widget.code) {
          _firestore.collection('messages').add({
            'id': widget.code,
            'message': "stop",
          });
        }
      }
      Navigator.pop(context);
    } else {
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          _seconds++;
        });
      });
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
        child: Center(
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
        ),
      ),
    );
  }
}
