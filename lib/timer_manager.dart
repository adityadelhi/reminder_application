import 'dart:async';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'timer_model.dart';

class TimerManager {
  final List<TimerModel> _timers = [];
  final StreamController<List<TimerModel>> _timersController =
      StreamController<List<TimerModel>>.broadcast();

  Stream<List<TimerModel>> get timersStream => _timersController.stream;

  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  TimerManager() {
    initializeNotifications();
    _startTimers();
  }

  void dispose() {
    _timersController.close();
  }

  Future<void> initializeNotifications() async {
    try {
      const AndroidInitializationSettings initializationSettingsAndroid =
          AndroidInitializationSettings('@mipmap/ic_launcher');
      const InitializationSettings initializationSettings =
          InitializationSettings(android: initializationSettingsAndroid, iOS: null);

      await _flutterLocalNotificationsPlugin.initialize(initializationSettings);

      const AndroidNotificationChannel channel = AndroidNotificationChannel(
        'timer_notification_channel', // id
        'Timer Notifications', // title
        importance: Importance.high,
      );

      await _flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);

      // Request notification permissions
      await _flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
    } catch (e) {
      print('Error initializing notifications: $e');
    }
  }

  void _startTimers() {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      for (int i = 0; i < _timers.length; i++) {
        final TimerModel timerModel = _timers[i];
        final DateTime now = DateTime.now();
        final Duration difference = now.difference(timerModel.startTime);
        if (timerModel.isActive() && difference.inSeconds % 60 == 0) {
          _showNotification(timerModel);
        } else if (timerModel.isExpired()) {
          _timers.removeAt(i);
          i--; // Decrement the index to account for the removed timer
        }
      }

      _timersController.add(_timers);
    });
  }

  void addTimer(int minutes, DateTime startTime, DateTime endTime) {
    _timers.add(TimerModel(minutes, startTime, endTime));
    _timersController.add(_timers);
  }

  void removeTimer(int index) {
    _timers.removeAt(index);
    _timersController.add(_timers);
  }

  Future<void> _showNotification(TimerModel timerModel) async {
    try {
      const AndroidNotificationDetails androidPlatformChannelSpecifics =
          AndroidNotificationDetails(
        'timer_notification_channel',
        'Timer Notification',
        importance: Importance.max,
        priority: Priority.high,
      );
      const NotificationDetails platformChannelSpecifics =
          NotificationDetails(android: androidPlatformChannelSpecifics);

      await _flutterLocalNotificationsPlugin.show(
        0,
        'Timer Reached',
        'Your ${timerModel.minutes} minutes timer has reached.',
        platformChannelSpecifics,
        payload: 'item x',
      );
      print('TimerManager: Notification shown.'); // For debugging
    } catch (e) {
      print('Error showing notification: $e');
    }
  }
}
