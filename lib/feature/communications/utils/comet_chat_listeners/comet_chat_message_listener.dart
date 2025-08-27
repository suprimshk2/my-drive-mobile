import 'package:cometchat_chat_uikit/cometchat_chat_uikit.dart';

class CometChatMessageListeners with MessageListener {
  final Function(TextMessage) onTextMessageReceivedCallback;
  final Function(MediaMessage) onMediaMessageReceivedCallback;
  final Function(CustomMessage) onCustomMessageReceivedCallback;

  CometChatMessageListeners({
    required this.onTextMessageReceivedCallback,
    required this.onMediaMessageReceivedCallback,
    required this.onCustomMessageReceivedCallback,
  });

  @override
  void onTextMessageReceived(TextMessage textMessage) {
    print("R: Text Message Listened: ${textMessage.text}");

    onTextMessageReceivedCallback(textMessage);
  }

  // Triggered when a media message is received
  @override
  void onMediaMessageReceived(MediaMessage mediaMessage) {
    print("R: Media Message Listened: ${mediaMessage.type}");

    onMediaMessageReceivedCallback(mediaMessage);
  }

  // Triggered when a custom message is received
  @override
  void onCustomMessageReceived(CustomMessage customMessage) {
    print("R: Custom Message Listened: ${customMessage.customData}");

    onCustomMessageReceivedCallback(customMessage);
  }
}
