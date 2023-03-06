import 'package:flutter/material.dart';
import 'package:sensor_box/ui/screens/phone/phone_home_screen.dart';

import '../screen_controller.dart';

class PhoneSplashScreen extends StatefulWidget {
  final ScreenController state;
  const PhoneSplashScreen({Key? key, required this.state}) : super(key: key);

  @override
  State<PhoneSplashScreen> createState() => _PhoneSplashScreenState();
}

class _PhoneSplashScreenState extends State<PhoneSplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animation;
  Color backgroundColor = const Color(0xFF0D1117);
  double opacityLevel = 0.0;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 1500), () {

      setState(() {
        opacityLevel = 1.0;
      });
    });
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _animation = Tween<Offset>(
      begin: const Offset(2.5, 0.0),
      end: const Offset(0.5, 0.0),
    ).animate(_controller);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            height: 100,
            width: MediaQuery.of(context).size.width - 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SlideTransition(
                  position: _animation,
                  child: Image.asset(
                    'assets/icons/logo.png',
                    height: 75.0,
                    width: 75.0,
                  ),
                ),
                AnimatedOpacity(
                    duration: const Duration(seconds: 2),
                    onEnd: (){
                      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (builder)=> HomeScreen(state: widget.state,)), (route) => false);
                    },
                    opacity: opacityLevel,
                    child: const Text(
                      "KONYA TECHNICAL\nUNIVERSITY",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: "Times New Roman",
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ))
              ],
            ),
          ),
          Container(
            alignment: Alignment.center,
            height: 75,
            width: MediaQuery.of(context).size.width - 10,
            padding: const EdgeInsets.all(10),
            child: const Text(
              "SENSOR BOX",
              style: TextStyle(
                  fontFamily: "Poppins",
                  color: Colors.white70,
                  fontWeight: FontWeight.bold,
                  fontSize: 35),
            ),
          ),
          Container(
            alignment: Alignment.center,
            height: 75,
            width: MediaQuery.of(context).size.width - 10,
            padding: const EdgeInsets.all(10),
            child: const Text(
              "Created by MURABIT-PASHA",
              style: TextStyle(
                  fontFamily: "Poppins",
                  color: Colors.white38,
                  fontWeight: FontWeight.bold,
                  fontSize: 18),
            ),
          )
        ],
      ),
    );
  }
}
