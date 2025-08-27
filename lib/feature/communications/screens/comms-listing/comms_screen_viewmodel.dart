import 'package:cometchat_chat_uikit/cometchat_chat_uikit.dart';
import 'package:flutter/foundation.dart';
import 'package:mydrivenepal/feature/auth/auth.dart';
import 'package:mydrivenepal/feature/communications/data/models/conversation_response.dart';
import 'package:mydrivenepal/feature/communications/utils/comet_chat_methods.dart';
import 'package:mydrivenepal/shared/util/response.dart';
import 'package:mydrivenepal/feature/communications/constants/comet_chat_type.dart'
    as constants;

class CommsScreenViewModel extends ChangeNotifier {
  final AuthLocal _authLocal;

  CommsScreenViewModel({
    required AuthLocal authLocal,
  }) : _authLocal = authLocal;

  String _authUserId = "";

  String get authUserId => _authUserId;

  set authUserId(String value) {
    _authUserId = value;
    notifyListeners();
  }

  Future<void> getAuthUserId() async {
    String authUserId = await _authLocal.getUserId();

    this.authUserId = authUserId.toString();

    // TODO: remove this later
    // this.authUserId = "3857";
  }

  Response<List<ConversationResponseData>> _getConversationUseCase =
      Response<List<ConversationResponseData>>();

  Response<List<ConversationResponseData>> get getConversationUseCase =>
      _getConversationUseCase;

  void setConversationUseCase(
      Response<List<ConversationResponseData>> response) {
    _getConversationUseCase = response;
    notifyListeners();
  }

  Future<void> getConversations() async {
    setConversationUseCase(Response.loading());

    ConversationsRequest conversationRequest = (ConversationsRequestBuilder()
          ..limit = 20
          ..conversationType = CometChatConversationType.user
        // ..unread = true
        )
        .build();

    conversationRequest.fetchNext(
      onSuccess: (List<Conversation> conversations) {
        List<ConversationResponseData> modelConersationList =
            conversations.map((cometchatConversation) {
          return createNewConversationObject(
            conversation: cometchatConversation,
          );
        }).toList();

        setConversationUseCase(Response.complete(modelConersationList));
      },
      onError: (CometChatException e) {
        setConversationUseCase(Response.error(e.message));
      },
    );
  }

  void onMessageReceivedCallback({
    TextMessage? textMessage,
    MediaMessage? mediaMessage,
    BaseMessage? baseMessage,
    required bool isMessageReceived,
  }) async {
    dynamic message;
    String conversationWith = "";

    String senderUid = "";
    String receiverUid = "";

    bool isSenderAuthUser = false;

    if (textMessage != null) {
      message = textMessage;

      receiverUid = textMessage.receiverUid;
      senderUid = textMessage.sender?.uid ?? "";
      isSenderAuthUser = senderUid == authUserId;

      conversationWith = isSenderAuthUser ? receiverUid : senderUid;
    } else if (mediaMessage != null) {
      message = mediaMessage;
      // conversationWith = mediaMessage.receiverUid;
      receiverUid = mediaMessage.receiverUid;
      senderUid = mediaMessage.sender?.uid ?? "";
      isSenderAuthUser = senderUid == authUserId;

      conversationWith = isSenderAuthUser ? receiverUid : senderUid;
    } else if (baseMessage != null) {
      message = baseMessage;
      receiverUid = baseMessage.receiverUid;
      senderUid = baseMessage.sender?.uid ?? "";
      isSenderAuthUser = senderUid == authUserId;

      conversationWith = isSenderAuthUser ? receiverUid : senderUid;
    }
    String? messageConversationId = message?.conversationId;

    if (messageConversationId == null) {
      return;
    }

    var conversationList = getConversationUseCase.data ?? [];

    // getUnreadMessageCount();

    // Find the index of the conversation in the list
    int conversationIndex = conversationList.indexWhere((conversation) {
      return conversation.conversationId == messageConversationId;
    });

    if (conversationIndex != -1) {
      // Remove the original conversation from the list
      var originalConversation = conversationList.removeAt(conversationIndex);

      // getting updated conversation
      var updatedConversation = updateLastMessageData(
        message: message,
        originalData: originalConversation,
        isMessageReceived: isMessageReceived,
      );

      if (updatedConversation != null) {
        conversationList.insert(0, updatedConversation);

        setConversationUseCase(Response.complete(conversationList));
        return;
      }
    } else {
      await CometChat.getConversation(
        conversationWith,
        constants.ConversationType.user.name,
        onSuccess: (Conversation conversation) {
          var newConversation = createNewConversationObject(
            conversation: conversation,
            // isMessageReceived: isMessageReceived,
          );

          conversationList.insert(0, newConversation);

          setConversationUseCase(Response.complete(conversationList));

          return;
        },
        onError: (CometChatException e) {
          debugPrint("Fetch Conversation  failed  : ${e.message}");
        },
      );
    }
  }

  bool _isConversingUserOnline = false;

  bool get isConversingUserOnline => _isConversingUserOnline;

  set isConversingUserOnline(bool value) {
    _isConversingUserOnline = value;
    notifyListeners();
  }
}
