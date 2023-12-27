import 'package:flutter/material.dart';
import 'package:reminder/timer_list.dart';
import 'timer_manager.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();  // Ensure that Flutter is initialized
  TimerManager timerManager = TimerManager();  // Create an instance of TimerManager
  timerManager.initializeNotifications();  // Initialize notifications
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TimerList(),
    );
  }
}