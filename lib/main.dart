import 'package:flutter/material.dart';
import 'timer_list.dart';
import 'timer_manager.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure widgets binding is initialized
  final TimerManager timerManager = TimerManager(); // Create an instance of TimerManager
  timerManager.initializeNotifications(); // Initialize notifications
  runApp(MyApp(timerManager: timerManager));
}

class MyApp extends StatelessWidget {
  final TimerManager timerManager;

  const MyApp({super.key, required this.timerManager});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Timer App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TimerList(timerManager: timerManager),
    );
  }
}