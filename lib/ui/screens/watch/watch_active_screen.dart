import 'package:flutter/material.dart';
import '../../theme/gradients/time_gradient.dart';
import '../screen_controller.dart';

/// View for [DailyForecastRoute] for watch-sized devices while the watch
/// is in an active mode.
class WatchActiveScreen extends StatelessWidget {
  final ScreenController state;

  const WatchActiveScreen(this.state, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black54,
      body: TimeGradient(
        child: Center(
          //TODO: Saatin active durumdayken yapılacak etkinliği ekle
        ),
      ),
    );
  }
}
