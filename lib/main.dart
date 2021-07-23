import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
  Timer({required this.min, required this.sec, required this.msec});

  final int min;
  final int sec;
  final int msec;
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
            child: Stack(alignment: AlignmentDirectional.center, children: <Widget>[
              PageView.builder(
                  physics: AlwaysScrollableScrollPhysics(),
                  controller: _pageController,
                  itemBuilder: (BuildContext context, int index) {
                    return Column(children: [_pages[index % _pages.length]]);
                  },
                  onPageChanged: (int page) {
                    // TODO: アクティブなタイマーの切り替え

                    // TODO: ドットインジケーターのポジションの更新
                  }),
              // TODO: ドットインジケーターの表示
            ])));
  }
}

class TimerWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, timer, child) {
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

final timerProvider = StateProvider((ref) => Timer(min: 1, sec: 2, msec: 3));

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
            "${timer.min.toString().padLeft(2, '0')}:",
            style: Theme.of(context).textTheme.headline2,
          ),
          Text(
            "${timer.sec.toString().padLeft(2, '0')}:",
            style: Theme.of(context).textTheme.headline2,
          ),
          Text(
            "${timer.msec.toString().padLeft(2, '0')}",
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
      return Container(
        alignment: AlignmentDirectional.center,
        child: Text("TIMER-XX", style: TextStyle(color: Colors.white)),
      );
    });
  }
}
