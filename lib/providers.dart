import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Timer {
  final int timerId;

  int initialMin = 0;
  int initialSec = 0;

  int currentMin = 0;
  int currentSec = 0;
  int currentMsec = 0;

  Timer({required this.timerId}) {
    restore();
  }

  void restore() async {
    var prefs = await SharedPreferences.getInstance();
    var timer = prefs.getString(this.timerId.toString()) ?? "03:00:00";
    var numbers = timer.toString().split(":");

    this.initialMin = int.parse(numbers[0]);
    this.initialSec = int.parse(numbers[1]);

    this.currentMin = this.initialMin;
    this.currentSec = this.initialSec;
    this.currentMsec = 0;

    // update();
    // notifyListeners();
  }

  void start() {}

  void stop() {}
  void reset() {}
}

final timerIdProvider = StateProvider((ref) => 1);
final timerProvider = StateProvider((ref) => Timer(timerId: 1));
final isTimerStartingProvider = StateProvider((ref) => false);
