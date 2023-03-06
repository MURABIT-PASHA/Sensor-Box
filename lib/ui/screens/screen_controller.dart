import 'package:flutter/material.dart';
import '../../backend/pathfinder.dart';
import 'phone/phone_view.dart';
import 'watch/watch_view.dart';

class ScreenController extends State<Pathfinder> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      debugPrint('Ana cihaz ekran genişliği: ${constraints.maxWidth}');

      if (constraints.maxWidth < 300) {
        return WatchView(this);
      } else {
        return PhoneView(this);
      }
    });
  }
}
