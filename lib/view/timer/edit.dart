import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_timer/providers.dart';
import 'package:flutter_timer/timer_setting.dart';

class EditButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      final timer = ref.watch(timerProvider);

      return Container(
        width: 50,
        height: 50,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.blueGrey,
        ),
        child: IconButton(icon: Icon(Icons.handyman_rounded), onPressed: timer.startEdit, key: Key("edit_button")),
        // child: TextButton(child: Text('Edit', style: TextStyle(color: Colors.white)), onPressed: timer.startEdit, key: Key("edit_button")),
      );
    });
  }
}

class DisplayEdit extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      final timer = ref.watch(timerProvider);

      return Container(
          margin: EdgeInsets.only(top: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                upDownButton(context, "up", "min"),
                Text(
                  "${timer.currentMin.toString().padLeft(2, '0')}",
                  style: Theme.of(context).textTheme.headline3,
                ),
                upDownButton(context, "down", "min"),
              ]),
              Text(
                ':',
                style: Theme.of(context).textTheme.headline3,
              ),
              Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                upDownButton(context, "up", "sec"),
                Text(
                  "${timer.currentSec.toString().padLeft(2, '0')}",
                  style: Theme.of(context).textTheme.headline3,
                ),
                upDownButton(context, "down", "sec"),
              ]),
            ],
          ));
    });
  }

  Widget upDownButton(BuildContext context, String upOrDown, String minOrSec) {
    return Consumer(builder: (context, ref, child) {
      final timer = ref.read(timerProvider);

      return Container(
          width: 40,
          height: 25,
          child: ElevatedButton(
              child: Icon(upOrDown == "up" ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down),
              style: ElevatedButton.styleFrom(
                primary: Colors.blueGrey,
                onPrimary: Colors.white,
              ),
              onPressed: () {
                if (minOrSec == "min") {
                  timer.changeMin(TimerSetting.changeMin(timer.currentMin, upOrDown));
                } else {
                  timer.changeSec(TimerSetting.changeSec(timer.currentSec, upOrDown));
                }
              },
              // TODO: 長押し 以下のコードでなぜか動かない
              onLongPress: () {
                print("longpress");
                if (minOrSec == "min") {
                  timer.changeMin(TimerSetting.changeMin(timer.currentMin, upOrDown));
                } else {
                  timer.changeSec(TimerSetting.changeSec(timer.currentSec, upOrDown));
                }
              }));
    });
  }
}

class InEditButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      final timer = ref.watch(timerProvider);

      return Container(
          margin: EdgeInsets.only(top: 50.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 70,
                height: 70,
                margin: EdgeInsets.only(right: 30.0),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.lightBlueAccent,
                ),
                child: TextButton(child: Text('UPDATE', style: TextStyle(color: Colors.black)), onPressed: timer.finishEdit),
              ),
              Container(
                width: 70,
                height: 70,
                margin: EdgeInsets.only(left: 30.0),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.redAccent,
                ),
                child: TextButton(child: Text('CANCEL', style: TextStyle(color: Colors.white)), onPressed: timer.cancelEdit),
              )
            ],
          ));
    });
  }
}
