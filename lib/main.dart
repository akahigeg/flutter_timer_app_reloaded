import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_timer/providers.dart';
import 'package:flutter_timer/view/timer/buttons.dart';

void main() {
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.dark(),
      home: FlutterTimer(),
    );
  }
}

class FlutterTimer extends StatelessWidget {
  FlutterTimer({Key? key}) : super(key: key);

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
            final timerId = ref.watch(timerIdProvider);
            return Stack(alignment: AlignmentDirectional.center, children: <Widget>[
              PageView.builder(
                  physics: AlwaysScrollableScrollPhysics(),
                  controller: _pageController,
                  itemBuilder: (BuildContext context, int index) {
                    // timerProvider = StateProvider((ref) => Timer(timerId: index % _pages.length + 1));
                    // print("index: $index");
                    print("timerId: ${index % _pages.length + 1}");
                    return Column(children: [_pages[index % _pages.length]]);
                  },
                  onPageChanged: (int page) {
                    // アクティブなタイマーの切り替え
                    timerId.state = page % _pages.length + 1;

                    // timerProvider = StateProvider((ref) => Timer(timerId: page % _pages.length + 1));
                    // print("page: $page");
                    // print("page % _pages.length + 1: ${page % _pages.length + 1}");

                    // TODO: ドットインジケーターのポジションの更新
                  }),
              // TODO: ドットインジケーターの表示
            ]);
          }),
        ));
  }
}

class TimerWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      return Container(
          child: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          // TODO: サークルインジケーター
          // タイマー表示
          Column(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
            TimerName(),
            Display()
            // timer.inEdit ? DisplayEdit() : Display(),
          ]),
          // TODO: EDITボタン
          // TODO: START/STOP/RESETボタン
          ControlButtons()
        ],
      ));
    });
  }
}

class Display extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      final timer = ref.watch(timerProvider).state;

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
