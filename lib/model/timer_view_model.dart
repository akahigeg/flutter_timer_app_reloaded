import 'package:flutter/material.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

class TimerViewModel extends ChangeNotifier {
  final int timerId;

  int initialMin = 0;
  int initialSec = 0;
  int initialMsec = 1000; // 設定できない値なので固定

  int currentMin = 0;
  int currentSec = 0;
  int currentMsec = 0;

  var timer;
  var startTime;
  var lastStopTime;
  var stoppedMilliseconds = 0; // 中断時間の合計
  bool isStart = false;
  bool inEdit = false;

  TimerViewModel({required this.timerId}) {
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
    notifyListeners();
  }

  void start() {
    if (this.currentMin == 0 && this.currentSec == 0 && this.currentMsec == 0) {
      // すべての桁が0であったらタイマーをスタートしない
      return;
    }

    this.isStart = true;

    if (this.lastStopTime == null) {
      // 新しいタイマーの開始
      this.startTime = DateTime.now();
    } else {
      // 中断したタイマーの再開
      this.stoppedMilliseconds = (DateTime.now().millisecondsSinceEpoch - this.lastStopTime.millisecondsSinceEpoch).toInt() + this.stoppedMilliseconds;
      print(this.lastStopTime.millisecondsSinceEpoch);
      print(DateTime.now().millisecondsSinceEpoch);
      print(this.stoppedMilliseconds);
    }

    this.timer = Timer.periodic(
      Duration(milliseconds: 1),
      this.countDown,
    );

    // notifyListeners();
  }

  void countDown(Timer timer) {
    // 開始時間と現在時間の差分から表示内容を求める
    var currentTimestamp = DateTime.now().millisecondsSinceEpoch;

    // 経過した時間
    var pastMsec = currentTimestamp - this.startTime.millisecondsSinceEpoch - this.stoppedMilliseconds;
    int minusSec = (pastMsec / 1000).ceil();
    // タイマーが1:03で3秒経過で1:00 4秒経過で0:59になってほしい
    // タイマーが1:13で13秒経過で1:00 14秒経過で0:59になってほしい
    int minusMin;
    if (minusSec % 60 > this.initialSec) {
      minusMin = (minusSec / 60).ceil();
    } else {
      minusMin = (minusSec / 60).floor();
    }

    // 表示する時間
    int newMsec = ((this.initialMsec - pastMsec % 1000) ~/ 10).floor();
    int newSec = ((this.initialSec - minusSec) % 60).floor();
    int newMin = (this.initialMin - minusMin);

    this.currentMsec = newMsec;
    this.currentSec = newSec;
    this.currentMin = newMin;

    if (this.currentMin == 0 && this.currentSec == 0 && this.currentMsec == 0) {
      // すべての桁が0になったらタイマー終了
      finish();
    }

    notifyListeners();
  }

  void stop() {
    this.isStart = false;

    // 中断したタイマーの再開ができるように停めた時間を記録
    this.lastStopTime = DateTime.now();
    this.timer.cancel(); // this.switchTimer以外からthis.stopTimerを呼び出すとなぜかバグる

    notifyListeners();
  }

  void reset() {
    this.isStart = false;
    this.lastStopTime = null;
    this.stoppedMilliseconds = 0;

    if (this.timer != null) {
      this.timer.cancel();
    }

    // _stopTimer();
    restore();
  }

  void finish() {}
}
