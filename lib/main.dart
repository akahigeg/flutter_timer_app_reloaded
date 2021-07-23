import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(ProviderScope(child: MyApp()));
}

final helloWorldProvider = Provider((_) => 'Hello world');
final counterProvider = StateProvider((ref) => 0);

class MyApp extends ConsumerWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String value = ref.watch(helloWorldProvider);
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.dark(),
      home: Home(title: value),
    );
  }
}

class Home extends StatelessWidget {
  Home({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text(this.title)), body: Center(child: Counter()), floatingActionButton: AddButton());
  }
}

class Counter extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Consumer(builder: (context, ref, _) {
      final count = ref.watch(counterProvider).state;
      return Text("$count");
    });
  }
}

class AddButton extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FloatingActionButton(onPressed: () => ref.read(counterProvider).state++, child: const Icon(Icons.add));
  }
}
