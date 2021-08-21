// import 'package:test/test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_timer/timer_setting.dart';

void main() {
  group("ClockEditor.changeMin", () {
    test("count up", () {
      expect(TimerSetting.changeMin(3, "up"), 4);
    });

    test("count up from 99, to 00", () {
      expect(TimerSetting.changeMin(99, "up"), 0);
    });

    test("count down", () {
      expect(TimerSetting.changeMin(3, "down"), 2);
    });

    test("count down from 00, to 99", () {
      expect(TimerSetting.changeMin(0, "down"), 99);
    });
  });

  group("ClockEditor.changeSec", () {
    test("count up", () {
      expect(TimerSetting.changeSec(3, "up"), 4);
    });

    test("count up from 59, to 00", () {
      expect(TimerSetting.changeSec(59, "up"), 0);
    });

    test("count down", () {
      expect(TimerSetting.changeSec(3, "down"), 2);
    });

    test("count down from 00, to 59", () {
      expect(TimerSetting.changeSec(0, "down"), 59);
    });
  });
}
