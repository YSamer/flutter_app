import 'dart:convert';
import 'dart:math';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  NotificationHelper.onBgNotificationOpen(json.encode(message.data));
}

class NotificationHelper {
  // Constructor
  NotificationHelper({this.fcmOnMessage}) {
    _initFCM();
  }

  // Clients.
  static final _fcmNotify = FirebaseMessaging.instance;
  static final _localNotify = FlutterLocalNotificationsPlugin();

  // Functions.
  final Function? fcmOnMessage;

  // Vars
  bool _init = false;

  // Public Methods
  Future<void> subscribeToTopic(String topic) async {
    await _fcmNotify.subscribeToTopic("topic_$topic");
  }

  Future<void> unSubscribeToTopic(String topic) async {
    await _fcmNotify.unsubscribeFromTopic("topic_$topic");
  }

  // Private Methods
  _initFCM() async {
    if (_init) {
      return;
    } else {
      await _fcmNotify.subscribeToTopic('all');
      await _fcmNotify.setAutoInitEnabled(true);

      // Get Token and just Print it.
      await _saveFCMToken();

      _onTokenRefresh();
      // Init Listen for Notifications.
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        if (kDebugMode) {
          debugPrint(
            "methodName: 'FirebaseMessaging@onMessage',\n"
            "fileName: 'fcm_manager.dart',\n"
            "response: ${message.data},\n",
            wrapWidth: 512,
          );
        }
        //
        if (fcmOnMessage != null) fcmOnMessage!(message);
        //
        showNotification(message);
      });
      // Request Permissions for IOS Only.
      await _fcmNotify.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );

      void onDidReceiveLocalNotification(
          int? id, String? title, String? body, String? payload) async {}

      // Init Local Notifications Settings.
      var initializationSettingsAndroid =
          const AndroidInitializationSettings('@mipmap/ic_launcher');
      var initializationSettingsIOS = DarwinInitializationSettings(
        onDidReceiveLocalNotification: onDidReceiveLocalNotification,
      );
      var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsIOS,
      );
      await _localNotify.initialize(
        initializationSettings,
        onDidReceiveBackgroundNotificationResponse: onNotificationOpen,
      );
      _init = true;
    }
  }

  Future<void> _saveFCMToken() async {
    final token = await _fcmNotify.getToken();
    if (kDebugMode) debugPrint("_fcmToken: $token");
  }

  static Future<void> onBgNotificationOpen(String? x) async {
    try {
      // final message = json.decode(x!);
      // Navigator.of(Get.context!).push(
      //   CupertinoPageRoute(
      //     builder: (context) => const NotificationScreen(),
      //   ),
      // );
    } catch (e) {}
  }

  static Future<void> onNotificationOpen(NotificationResponse? x) async {
    try {
      // final message = json.decode(x!);
      // Navigator.of(Get.context!).push(
      //   CupertinoPageRoute(
      //     builder: (context) => const NotificationScreen(),
      //   ),
      // );
    } catch (e) {}
  }

  // Helper Functions
  void showNotification(RemoteMessage payload) async {
    await _initFCM();
    var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
      'channel id 3',
      'CRChannelName',
      channelDescription: 'CRChanelDescription',
      importance: Importance.max,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
      ticker: 'ticker',
    );
    var iOSPlatformChannelSpecifics = const DarwinNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );
    await _localNotify.show(
      Random().nextInt(999),
      payload.notification!.title ?? '',
      payload.notification!.body ?? '',
      platformChannelSpecifics,
      payload: json.encode(payload.data),
    );
  }

  Future<void> _onTokenRefresh() async {
    _fcmNotify.onTokenRefresh.listen((String token) async {
      // DioClient.instance.updateToken(token);
    });
  }
}
