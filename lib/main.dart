import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<void> main() async {
  runApp(
    // Adding ProviderScope enables Riverpod for the entire project
    const ProviderScope(child: MyApp()),
  );
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseAnalytics.instance.logEvent(
    name: 'app_start',
    parameters: {
      'starting': DateTime.now().toIso8601String(),
    },
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: Home());
  }
}

/// Providers are declared globally and specify how to create a state
final counterProvider = StateProvider((ref) => 0);

class Home extends ConsumerWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Counter example')),
      body: Center(
        // Consumer is a widget that allows you reading providers.
        child: Consumer(builder: (context, ref, _) {
          final count = ref.watch(counterProvider.state).state;
          return Text('$count');
        }),
      ),
      floatingActionButton: FloatingActionButton(
        // The read method is a utility to read a provider without listening to it
        onPressed: () => ref.read(counterProvider.state).state++,
        child: const Icon(Icons.add),
      ),
    );
  }
}
