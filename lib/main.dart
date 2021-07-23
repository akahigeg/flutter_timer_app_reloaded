import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:vector_math/vector_math.dart' as vector_math;

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

// final counterProvider = StateProvider((ref) => 0);

// class Home extends StatelessWidget {
//   Home({Key? key, required this.title}) : super(key: key);

//   final String title;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(appBar: AppBar(title: Text(this.title)), body: Center(child: Counter()), floatingActionButton: AddButton());
//   }
// }

// class Counter extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Consumer(builder: (context, ref, _) {
//       final count = ref.watch(counterProvider).state;
//       return Text("$count");
//     });
//   }
// }

// class AddButton extends ConsumerWidget {
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     return FloatingActionButton(onPressed: () => ref.read(counterProvider).state++, child: const Icon(Icons.add));
//   }
// }

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
}

final timerIdProvider = StateProvider((ref) => 1);
final timerProvider = StateProvider((ref) => Timer(timerId: 1));

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
                    timerId.state = page % _pages.length + 1;

                    // TODO: アクティブなタイマーの切り替え
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
