import 'dart:async';

import 'dart:math';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:go_router/go_router.dart';
import 'package:mydrivenepal/data/constants/notification_enums.dart';
import '../../di/di.dart' as di;
import '../../navigation/navigation_routes.dart';
import '../constant/constants.dart';
import '../util/util.dart';

class NotificationHelper {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // setting up app and firebase for notifications
  Future<void> requestNotificationPermission() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: true,
      criticalAlert: true,
      provisional: false,
      sound: true,
    );

    // debug printing to check notification permissions.
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      debugPrint("Authorized permission");
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      debugPrint("Provisional Permission");
    } else {
      debugPrint("Denied Permission");
    }
  }

  Future<String> requestToken() async {
    try {
      final fcmToken = await messaging.getToken();
      print("✅ fcmToken -> $fcmToken");
      return fcmToken ?? "";
    } catch (e) {
      print("Error requesting token: $e");
      return "";
    }
  }

  void refreshToken() async {
    messaging.onTokenRefresh.listen((event) {
      event.toString();
    });
  }

  FutureOr<void> initLocalNotifications(
    BuildContext context,
    RemoteMessage message,
  ) async {
    try {
      // giving permission for foreground pop-up
      _flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.requestNotificationsPermission();

      var androidInitializationSettings =
          const AndroidInitializationSettings('@mipmap/ic_launcher');
      var iosInitializationSettings = const DarwinInitializationSettings();

      var initializationSettings = InitializationSettings(
        android: androidInitializationSettings,
        iOS: iosInitializationSettings,
      );

      // Navigation to certain screen
      await _flutterLocalNotificationsPlugin.initialize(initializationSettings,
          onDidReceiveNotificationResponse: (payload) async {
        Future.delayed(Duration.zero);
        handleMessage(context, message);
      });
    } catch (e, stacktrace) {
      print('Error initializing local notifications: $e');
      print(stacktrace);
    }
  }

  // handling firebase notifications
  void firebaseInit(
    BuildContext context,
  ) {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      debugPrint("->✅ init ${message.notification}");

      String? title = message.notification?.title;

      if (isNotEmpty(title)) {
        await initLocalNotifications(context, message);
        showNotification(message);
      }
    });
  }

  // showing notifications pop-up in the app
  Future<void> showNotification(RemoteMessage message) async {
    AndroidNotificationChannel channel = AndroidNotificationChannel(
      Random.secure().nextInt(10000).toString(),
      "Swaddle_Notification",
      importance: Importance.max,
    );

    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      channel.id.toString(),
      channel.name.toString(),
      channelDescription: "Swaddle Task Notifications",
      importance: Importance.high,
      priority: Priority.high,
      ticker: 'ticker',
    );

    const DarwinNotificationDetails darwinNotificationDetails =
        DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    NotificationDetails notificationDetail = NotificationDetails(
      android: androidNotificationDetails,
      iOS: darwinNotificationDetails,
    );

    final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;

    Future.delayed(Duration.zero, () {
      _flutterLocalNotificationsPlugin.show(
        id,
        message.notification?.title,
        message.notification?.body,
        notificationDetail,
        // payload: message.data['taskId'],
      );
    });
  }

  // for navigation.
  void handleMessage(
    BuildContext context,
    RemoteMessage message,
  ) async {
    String notificationType =
        message.data['type'] ?? NotificationType.task.name;

    if (notificationType == NotificationType.chat.name) {
      navigateToChatScreen(context, message);
    } else {
      navigateToTask(context, message);
    }
  }

  Future<void> backgroundHandler(
    BuildContext context,
  ) async {
    // for background state.
    FirebaseMessaging.onMessageOpenedApp.listen((event) async {
      handleMessage(context, event);

      return;
    });
  }

  Future<void> terminatedHandler(
    BuildContext context,
  ) async {
    // for terminated state.
    FirebaseMessaging.instance.getInitialMessage().then((initialMessage) async {
      if (initialMessage != null) {
        handleMessage(context, initialMessage);
        return;
      }
    });
  }
}

void navigateToChatScreen(
  BuildContext context,
  RemoteMessage message,
) {
  String userId = message.data['sender'];
  String fullName = message.data['senderName'];

  navigatorKey.currentContext?.goNamed(AppRoute.chat.name, extra: {
    "isFromNotification": true,
    "userId": userId,
    "fullName": fullName,
  });
}

void navigateToTask(
  BuildContext context,
  RemoteMessage message,
) {
  String taskId = message.data['taskId'];
  String milestoneId = message.data['milestoneId'];
  String episodeId = message.data['episodeId'];
  // todo: need to check if notification count is more than 1, then navigate to topic screen
  // int? notificationCount = message.data['count'];
  // if (notificationCount != null && notificationCount > 1) {
  //   navigatorKey.currentContext?.goNamed(AppRoute.episodeDetail.name, extra: {
  //     "episodeId": episodeId,
  //   });
  // }
  if (message.data['taskType'] == 'todo') {
    navigatorKey.currentContext?.goNamed(AppRoute.todo.name, extra: {
      "taskId": taskId,
      "milestoneId": milestoneId,
      "episodeId": episodeId,
      'onCompleted': (statusModelForCallback) => {},
      'isFromNotification': true,
    });
  }
  if (message.data['taskType'] == 'message') {
    navigatorKey.currentContext?.goNamed(AppRoute.message.name, extra: {
      "taskId": taskId,
      "milestoneId": milestoneId,
      "episodeId": episodeId,
      'onCompleted': (statusModelForCallback) => {},
      'isFromNotification': true,
    });
  }
  if (message.data['taskType'] == 'signature') {
    navigatorKey.currentContext?.goNamed(AppRoute.signature.name, extra: {
      "taskId": taskId,
      "milestoneId": milestoneId,
      "episodeId": episodeId,
      'onCompleted': (statusModelForCallback) => {},
      'isFromNotification': true,
    });
  }
  if (message.data['taskType'] == 'question') {
    navigatorKey.currentContext?.goNamed(AppRoute.question.name, extra: {
      "taskId": taskId,
      "milestoneId": milestoneId,
      "episodeId": episodeId,
      'onCompleted': (statusModelForCallback) => {},
      'isFromNotification': true,
    });
  }
  if (message.data['taskType'] == 'questionnaire') {
    navigatorKey.currentContext?.goNamed(AppRoute.qnr.name, extra: {
      "isFromNotification": true,
      "taskId": taskId,
      "milestoneId": milestoneId,
      "episodeId": episodeId,
      'onCompleted': (statusModelForCallback) => {}
    });
  }
}
