import 'package:dbus/dbus.dart';
import 'package:demo_app/background_service.dart';
import 'package:demo_app/org_freedesktop_notifications.dart';
import 'package:flutter/material.dart';
import 'package:workmanager/workmanager.dart';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    WidgetsFlutterBinding.ensureInitialized();
    switch (task) {
      case "Simple":
        WidgetsFlutterBinding.ensureInitialized();
        final backgroundService = BackgroundService();
        await backgroundService.init();
        await Future.delayed(const Duration(seconds: 10000));
        debugPrint("Simple task was completed");
        return Future.value(true); // Task succeeded
      default:
        return Future.value(false);
    }
  });
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Workmanager().initialize(callbackDispatcher, isInDebugMode: true);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Background tester'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _runWorkmanagerTask() {
    Workmanager().cancelAll();
    Workmanager().registerOneOffTask(
      "1",
      "Simple",
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _runWorkmanagerTask,
        tooltip: 'Run task',
        child: const Icon(Icons.arrow_back_ios_new),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
