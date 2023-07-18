import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

class NotifyTask {
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  void initFirebaseMessaging() {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/todogo');
    InitializationSettings initializationSettings =
        InitializationSettings(android: androidSettings);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);

    // Request permission to display notifications
    messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    // Handle foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      showNotification(message);
    });

    // Handle messages when the app is in the background or terminated
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      // You can handle the notification click event here
    });
  }

  Future<void> showNotification(RemoteMessage message) async {
    String title = message.notification?.title ?? 'Notification';
    String body = message.notification?.body ?? '';

    AndroidNotificationDetails androidDetails =
        const AndroidNotificationDetails(
      'todogo',
      'todogo',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
    );

    NotificationDetails notificationDetails =
        NotificationDetails(android: androidDetails);

    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      notificationDetails,
      payload: message.data['your_custom_data_key'],
    );
  }

  Future<void> scheduleNotification(
      int todoId,
      tz.TZDateTime notificationDateTime,
      String taskTitle,
      String categoryName) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails('todogo', 'todogo',
            importance: Importance.high,
            priority: Priority.high,
            playSound: true,
            enableVibration: true,
            color: Color(0xffF5F3C1),
            colorized: true);

    final DarwinNotificationDetails iOSPlatformChannelSpecifics =
        DarwinNotificationDetails();

    final NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    await flutterLocalNotificationsPlugin.zonedSchedule(
      todoId,
      taskTitle,
      '$categoryName category',
      notificationDateTime,
      platformChannelSpecifics,
      androidScheduleMode: AndroidScheduleMode.alarmClock,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }
}
