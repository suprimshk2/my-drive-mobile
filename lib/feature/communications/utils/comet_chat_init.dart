import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:cometchat_chat_uikit/cometchat_chat_uikit.dart';
import 'package:mydrivenepal/feature/communications/constants/comet_chat_type.dart';
import 'package:mydrivenepal/shared/constant/message/message.dart';
import 'package:mydrivenepal/shared/shared.dart';

class CometChatInit extends ChangeNotifier {
  final NotificationHelper _notificationHelper;

  CometChatInit({
    required NotificationHelper notificationHelper,
  }) : _notificationHelper = notificationHelper;

  // comet chat keys
  String region = dotenv.env["REGION"] ?? "";
  String appId = dotenv.env["APP_ID"] ?? "";
  String authKey = dotenv.env["AUTH_KEY"] ?? "";

  // comet chat sdk setup
  Future<void> initializeCometChatSdk() async {
    AppSettings appSettings = (AppSettingsBuilder()
          ..subscriptionType = CometChatSubscriptionType.allUsers
          ..region = region
          ..adminHost = "" //optional
          ..clientHost = "" //optional
          ..autoEstablishSocketConnection = true)
        .build();

    await CometChat.init(
      appId,
      appSettings,
      onSuccess: (String successMessage) {
        debugPrint(
            "SDK Initialization completed successfully  $successMessage");
      },
      onError: (CometChatException excep) {
        debugPrint(
            "SDK Initialization failed with exception: ${excep.message}");
      },
    );
  }

  // comet chat UI toolkit setup
  Future<void> initializeCometChatUiToolkit() async {
    UIKitSettings uiKitSettings = (UIKitSettingsBuilder()
          ..subscriptionType = CometChatSubscriptionType.allUsers
          ..autoEstablishSocketConnection = true
          ..region = region
          ..appId = appId
          ..authKey = authKey
          ..extensions = CometChatUIKitChatExtensions.getDefaultExtensions())
        .build();

    CometChatUIKit.init(
      uiKitSettings: uiKitSettings,
      onSuccess: (successMessage) {
        debugPrint(
            "Toolkit Initialization completed successfully  $successMessage");
      },
      onError: (e) {
        debugPrint(
            "Toolkit Initialization failed with exception: ${e.message}");
      },
    );
  }

  ///
  /// Login Function for cometchat
  ///
  /// Check if the session is active and continue with the same
  /// session if it is!
  ///
  /// Login with the uid if there's no session.
  ///

  Future<User?> login(String userId) async {
    final loggedInUserSession = await CometChatUIKit.getLoggedInUser();

    // Means there is an active user login session. No need to login again.
    if (loggedInUserSession != null) {
      return loggedInUserSession;
    }

    // Logging in with generated comet chat user info
    await CometChatUIKit.login(
      userId,
      onSuccess: (successfullyLoggedInuser) async {
        debugPrint(
            "Successfully logged in with user: ${successfullyLoggedInuser.name}");

        await registerPushToken();

        return successfullyLoggedInuser;
      },
      onError: (excep) async {
        debugPrint("Failed to login with user: ${excep.message}");
        // Creating a new user if the login fails.
        if (excep.code == CometChatErrorCodes.USER_NOT_FOUND) {
          // todo: handle failed login case.
        }
      },
    );
  }

  Future<void> logout() async {
    await CometChatNotifications.unregisterPushToken();
    await CometChatUIKit.logout();
  }

  Future<void> registerPushToken() async {
    _notificationHelper.requestNotificationPermission();
    String token = await _notificationHelper.requestToken();

    PushPlatforms platform = Platform.isAndroid
        ? PushPlatforms.FCM_FLUTTER_ANDROID
        : PushPlatforms.FCM_FLUTTER_IOS;

    CometChatNotifications.registerPushToken(
      platform,
      providerId: CometChatProviderIDs.MySwaddleProvider.name,
      fcmToken: token,
      onSuccess: (response) {
        debugPrint("registerPushToken:success ${response.toString()}");
      },
      onError: (e) {
        debugPrint("registerPushToken:error ${e.toString()}");
      },
    );
  }
}
