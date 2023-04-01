import 'package:flutter/material.dart';
import 'package:sensor_box/ui/screens/phone/phone_splash_screen.dart';
import '../screen_controller.dart';

class PhoneView extends StatelessWidget {
  final ScreenController state;

  const PhoneView(this.state, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PhoneSplashScreen(state: state);
  }
}
