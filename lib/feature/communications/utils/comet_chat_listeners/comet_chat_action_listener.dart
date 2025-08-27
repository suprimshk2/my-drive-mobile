import 'package:cometchat_chat_uikit/cometchat_chat_uikit.dart';

class ChatActions with CometChatMessageEventListener {
  final Function(BaseMessage message, MessageStatus messageStatus)
      onMessageSentCallBack;

  // final Function(BaseMessage message, EventStatus messageStatus)
  //     onMessageDeletedCallBack;

  ChatActions({
    required this.onMessageSentCallBack,
    // required this.onMessageDeletedCallBack,
  });

  @override
  ccMessageSent(BaseMessage message, MessageStatus messageStatus) {
    print("S: Message Sent Listened");

    onMessageSentCallBack(message, messageStatus);
  }

  // @override
  // void ccMessageDeleted(BaseMessage message, EventStatus messageStatus) {
  //   print("S: Message Deleted Listened");

  //   onMessageDeletedCallBack(message, messageStatus);
  // }
}
