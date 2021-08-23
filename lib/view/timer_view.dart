import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dots_indicator/dots_indicator.dart';

import 'package:flutter_timer/providers.dart';
import 'package:flutter_timer/view/timer/buttons.dart';
import 'package:flutter_timer/view/timer/edit.dart';

import 'package:vector_math/vector_math.dart' as vector_math;

class TimerView extends StatelessWidget {
  TimerView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _pageController = PageController();

    final List<Widget> _pages = <Widget>[
      new TimerWidget(),
      new TimerWidget(),
      new TimerWidget(),
    ];

    return Scaffold(
        appBar: AppBar(title: Text("Flutter Timer"), actions: <Widget>[]),
        body: IconTheme(
          data: IconThemeData(color: Colors.black.withOpacity(0.8)),
          child: Consumer(builder: (context, ref, child) {
            final timerId = ref.read(timerIdProvider);
            final timer = ref.read(timerProvider);

            return Container(
              child: PageView.builder(
                  physics: AlwaysScrollableScrollPhysics(),
                  controller: _pageController,
                  itemBuilder: (BuildContext context, int index) {
                    print("timerId: ${index % _pages.length + 1}");
                    return Column(children: [_pages[index % _pages.length]]);
                  },
                  onPageChanged: (int page) {
                    // アクティブなタイマーの切り替え
                    timerId.state = page % _pages.length + 1;
                    timer.switchTimerId(timerId.state);
                    timer.reset();

                    // ドットインジケーターのポジションの更新
                    ref.read(dotIndicatorPositionProvider).state = (page % _pages.length).toDouble();
                  }),
            );
          }),
        ));
  }
}

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
        alignment: AlignmentDirectional.topCenter,
        children: [
          // サークルインジケーター
          Container(child: timer.inEdit ? CircleIndicatorForEdit() : CircleIndicator(), margin: EdgeInsets.fromLTRB(0, 100, 0, 0)),

          // タイマー名
          Container(child: TimerName(), margin: EdgeInsets.fromLTRB(0, 180, 0, 0)),

          // タイマー表示
          Container(child: timer.inEdit ? DisplayEdit() : Display(), margin: EdgeInsets.fromLTRB(0, 200, 0, 0)),

          // EDITボタン
          Container(child: timer.inEdit ? null : EditButton(), margin: EdgeInsets.fromLTRB(0, 300, 0, 0)),

          // 操作ボタン
          Container(child: timer.inEdit ? InEditButtons() : ControlButtons(), margin: EdgeInsets.fromLTRB(0, 400, 0, 0)),

          // ドットインジケーター
          Container(
            child: Consumer(builder: (context, ref, child) {
              final position = ref.watch(dotIndicatorPositionProvider).state;
              final count = ref.watch(dotIndicatorCountProvider).state;
              return Container(child: DotsIndicator(dotsCount: count, position: position), margin: EdgeInsets.fromLTRB(0, 600, 0, 0));
            }),
          ),
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
            "${timer.currentSec.toString().padLeft(2, '0')}.",
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
