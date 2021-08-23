import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter_timer/main.dart';
import 'package:flutter_timer/view/timer_view.dart';
import 'package:flutter_timer/model/timer_view_model.dart';
// import 'package:flutter_clock/model/dot_indicator_model.dart';

void main() {
  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("1", "04:00:00");
  });

  testWidgets('Toggle START and STOP button', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.runAsync(() async {
      await tester.pumpWidget(ProviderScope(child: MyApp()));

      expect(find.text('START'), findsOneWidget);
      expect(find.text('STOP'), findsNothing);

      // STARTボタンをタップ
      await tester.tap(find.widgetWithText(TextButton, "START"));
      // await tester.tap(find.byKey(Key("start_button")));
      await tester.pumpAndSettle();

      expect(find.text('START'), findsNothing);
      expect(find.text('STOP'), findsOneWidget);

      await tester.tap(find.widgetWithText(TextButton, "STOP"));
      await tester.pumpAndSettle();

      expect(find.text('START'), findsOneWidget);
      expect(find.text('STOP'), findsNothing);

      // 疑似タイマーだが止めておかないと動き続けてエラーがでるようだ？
    });
  });

  testWidgets('Switch each timer on swipe', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.runAsync(() async {
      await tester.pumpWidget(ProviderScope(child: MyApp()));

      await tester.pumpAndSettle();
      expect(find.text('TIMER-01'), findsOneWidget);
      expect(find.text('TIMER-02'), findsNothing);
      expect(find.text('TIMER-03'), findsNothing);

      await tester.drag(find.byType(TimerView), const Offset(-500.0, 0.0));
      await tester.pumpAndSettle();
      expect(find.text('TIMER-02'), findsOneWidget);
      expect(find.text('TIMER-01'), findsNothing);
      expect(find.text('TIMER-03'), findsNothing);

      await tester.drag(find.byType(TimerView), const Offset(-500.0, 0.0));
      await tester.pumpAndSettle();
      expect(find.text('TIMER-03'), findsOneWidget);
      expect(find.text('TIMER-01'), findsNothing);
      expect(find.text('TIMER-02'), findsNothing);

      await tester.drag(find.byType(TimerView), const Offset(-500.0, 0.0));
      await tester.pumpAndSettle();
      expect(find.text('TIMER-01'), findsOneWidget);

      await tester.drag(find.byType(TimerView), const Offset(500.0, 0.0));
      await tester.pumpAndSettle();
      expect(find.text('TIMER-03'), findsOneWidget);
    });
  });

  testWidgets('Timer is 04:00:00', (WidgetTester tester) async {
    await tester.runAsync(() async {
      await tester.pumpWidget(ProviderScope(child: MyApp()));

      await tester.pumpAndSettle(); // prefsからの読み込みを待つ

      // タイマー表示 分のところをチェック
      expect(find.text('04:'), findsOneWidget);
      expect(find.text('03:'), findsNothing);

      // 秒
      expect(find.text('00.'), findsOneWidget);

      // ミリ秒以下2桁
      expect(find.text('00'), findsOneWidget);

      // Flutterのウィジェットテストはタイマーが動かないのでタイマーによる変化はテストできない
    });
  });
}
