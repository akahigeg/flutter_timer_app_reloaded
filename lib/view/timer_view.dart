import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_timer/providers.dart';
import 'package:flutter_timer/view/timer/buttons.dart';
import 'package:flutter_timer/view/timer/edit.dart';

import 'package:vector_math/vector_math.dart' as vector_math;

class ArcPaint extends CustomPainter {
  int _initialMSec = 0;
  int _remainMsec = 0;

  ArcPaint(int initialMsec, int remainMsec) {
    _initialMSec = initialMsec;
    _remainMsec = remainMsec;
  }
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 12;
    final rect = Rect.fromLTRB(0, 0, size.width, size.height);
    final startAngle = -vector_math.radians(90.0); // 0時の位置から
    double degree = _remainMsec / _initialMSec * 360;
    if (degree == 0.0) {
      degree = 360;
    }
    final sweepAngle = -vector_math.radians(degree);
    final useCenter = false;

    canvas.drawArc(rect, startAngle, sweepAngle, useCenter, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class CircleIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      final timer = ref.watch(timerProvider);

      return CustomPaint(
        size: const Size(300, 300),
        painter: ArcPaint((((timer.initialMin * 60) + timer.initialSec).toInt()) * 1000, (timer.currentMin * 60 + timer.currentSec) * 1000 + timer.currentMsec * 10),
      );
    });
  }
}

class CircleIndicatorForEdit extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      return CustomPaint(size: const Size(300, 300), painter: ArcPaint(1, 1));
    });
  }
}

class TimerWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      final timer = ref.watch(timerProvider);

      return Container(
          child: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          Container(child: CircleIndicator(), margin: EdgeInsets.fromLTRB(0, 0, 0, 0)),
          // タイマー表示
          Column(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
            TimerName(),
            timer.inEdit ? DisplayEdit() : Display(),
          ]),
          // EDITボタン
          Container(child: timer.inEdit ? null : EditButton(), margin: EdgeInsets.fromLTRB(0, 180, 0, 0)),
          // 操作ボタン
          Container(child: timer.inEdit ? InEditButtons() : ControlButtons(), margin: EdgeInsets.fromLTRB(0, 400, 0, 0))
        ],
      ));
    });
  }
}

class Display extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      final timer = ref.watch(timerProvider);

      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Text(
            "${timer.currentMin.toString().padLeft(2, '0')}:",
            style: Theme.of(context).textTheme.headline2,
          ),
          Text(
            "${timer.currentSec.toString().padLeft(2, '0')}:",
            style: Theme.of(context).textTheme.headline2,
          ),
          Text(
            "${timer.currentMsec.toString().padLeft(2, '0')}",
            style: Theme.of(context).textTheme.headline3,
          ),
        ],
      );
    });
  }
}

class TimerName extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      final timerId = ref.watch(timerIdProvider).state;

      return Container(
        alignment: AlignmentDirectional.center,
        child: Text("TIMER-${timerId.toString().padLeft(2, '0')}", style: TextStyle(color: Colors.white)),
      );
    });
  }
}
