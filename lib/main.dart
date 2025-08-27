import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:mydrivenepal/data/remote/api_client.dart';

import 'package:mydrivenepal/feature/auth/screen/login/developer_option_viewmodel.dart';
import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mydrivenepal/app.dart';
import 'package:mydrivenepal/app_config.dart';
import 'package:mydrivenepal/feature/communications/utils/comet_chat_init.dart';
import 'package:mydrivenepal/feature/theme/theme_provider.dart';

import 'package:mydrivenepal/navigation/navigation_service.dart';
import 'package:mydrivenepal/shared/helper/notification_helper.dart';
import 'package:flutter/services.dart';
import 'di/remote_config_service.dart';
import 'di/service_locator.dart' as di;

@pragma('vm:entry-point')
Future<void> _firebaseNotificationBackgroundHandler(
    RemoteMessage message) async {
  await Firebase.initializeApp();
}

Future<void> main() async {
  await AppConfig.load();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await di.setUpServiceLocator();
  await initApp();
  await di.locator<NotificationHelper>().requestNotificationPermission();
  FirebaseMessaging.onBackgroundMessage(_firebaseNotificationBackgroundHandler);

  runApp(
    DevicePreview(
      enabled: false,
      builder: (context) => const App(),
    ),
  );
}

Future<void> initApp() async {
  final developerOptionViewModel = di.locator<DeveloperOptionViewModel>();
  final cometChat = di.locator<CometChatInit>();

  await Future.wait([
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]),
    di.locator<NavigationService>().getInitialRoute(),

    di.locator<ThemeProvider>().initializeTheme(),

    // di.locator<RemoteConfigService>().initialize(),

    developerOptionViewModel.getBaseUrl(),

    // initializating comet chat
    cometChat.initializeCometChatSdk(),
    cometChat.initializeCometChatUiToolkit(),
  ]);
  di.locator<ApiClient>().init(developerOptionViewModel.baseUrl);
}
