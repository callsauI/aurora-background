import 'package:dbus/dbus.dart';
import 'package:demo_app/background_service.dart';
import 'package:demo_app/org_freedesktop_notifications.dart';
import 'package:flutter/material.dart';
import 'package:workmanager/workmanager.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();

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
  final backgroundService = BackgroundService();

  @override
  void initState() {
    backgroundService.init();
    super.initState();
  }

  void _testNotification() {
    backgroundService.showNotification(
      'Уведомление получено!',
      'Нажмите подтвердить, чтобы проверить обработку уведомления',
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
        onPressed: _testNotification,
        tooltip: 'Run task',
        child: const Icon(Icons.arrow_back_ios_new),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
