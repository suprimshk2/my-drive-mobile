// import 'package:cometchat_sdk/cometchat_sdk.dart';
import 'package:cometchat_chat_uikit/cometchat_chat_uikit.dart';
import 'package:flutter/foundation.dart';

class ChatUserListener with UserListener {
  final Function(String) onUserOnlineCallback;
  final Function(String) onUserOfflineCallback;

  ChatUserListener({
    required this.onUserOnlineCallback,
    required this.onUserOfflineCallback,
  });

  @override
  void onUserOnline(User user) {
    debugPrint("ONLINE");
    onUserOnlineCallback(user.uid);
  }

  @override
  void onUserOffline(User user) {
    debugPrint("OFFLINE");
    onUserOfflineCallback(user.uid);
  }
}
