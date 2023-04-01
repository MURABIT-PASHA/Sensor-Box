import 'package:flutter/material.dart';
import '../screen_controller.dart';

class PhoneHomeScreen extends StatefulWidget {
  final ScreenController state;
  const PhoneHomeScreen({Key? key, required this.state}) : super(key: key);

  @override
  State<PhoneHomeScreen> createState() => _PhoneHomeScreenState();
}

class _PhoneHomeScreenState extends State<PhoneHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
