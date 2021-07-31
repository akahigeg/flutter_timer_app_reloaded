import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_timer/model/timer_view_model.dart';

final timerIdProvider = StateProvider((ref) => 1);
final timerProvider = ChangeNotifierProvider((ref) => TimerViewModel(timerId: 1));
