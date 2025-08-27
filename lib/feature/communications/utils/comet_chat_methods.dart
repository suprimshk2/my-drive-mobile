import 'package:cometchat_chat_uikit/cometchat_chat_uikit.dart';
import 'package:mydrivenepal/feature/communications/data/models/conversation_response.dart';
import 'package:mydrivenepal/shared/util/custom_functions.dart';
import 'package:mydrivenepal/shared/util/date.dart';

/* 
  Update fields in ConversationResponseData, 
  e.g., lastMessage or unread count
*/
ConversationResponseData? updateLastMessageData({
  dynamic message,
  required bool isMessageReceived,
  required ConversationResponseData originalData,
}) {
  String unreadMessageCount = isMessageReceived ? '1' : '0';
  if (message is TextMessage) {
    return originalData.copyWith(
      conversationId: message.conversationId,
      conversationType: "user",
      lastMessage: LastMessage(
        id: message.id.toString(),
        muid: message.muid,
        conversationId: message.conversationId,
        sender: message.sender?.uid,
        // receiverType: message.receiver,
        receiver: message.receiverUid,
        type: message.type,
        category: message.category,
        data: LastMessageData(
          text: message.text,
          entities: Entities(
            sender: Receiver(
              entity: ConversationWith(
                uid: message.sender?.uid,
                name: message.sender?.name,
                status: message.sender?.status, // check
                role: message.sender?.role,
                lastActiveAt: getUnixTimeFromDate(message.sender?.lastActiveAt),
                // createdAt: getUnixTimeFromDate(message.sender?.),
                // conversationId: message.sender?.conversationId
              ),
              // entityType: message.sender?.,
            ),
            receiver: Receiver(
              entity: ConversationWith(
                uid: message.receiverUid,
                // status: message.

                // name: message.,
                // status: message.sender?.status,

                // role: message.sender?.role,
                // lastActiveAt:
                //     getUnixTimeFromDate(message.sender?.lastActiveAt),
                // createdAt: getUnixTimeFromDate(message.sender?.),
                // conversationId: message.sender?.conversationId
              ),
              entityType: message.receiverType,
            ),
          ),
        ),
        sentAt: getUnixTimeFromDate(message.sentAt),
        deletedAt: getUnixTimeFromDate(message.deletedAt),
        deliveredAt: getUnixTimeFromDate(message.deliveredAt),
        readAt: getUnixTimeFromDate(message.readAt),
        updatedAt: getUnixTimeFromDate(message.updatedAt),
      ),
      unreadMessageCount: unreadMessageCount,
      // unreadMessageCount:
      //     (int.tryParse(originalData.unreadMessageCount ?? '0') ?? 0 + 1)
      //         .toString(),
      updatedAt: DateTime.now().millisecondsSinceEpoch,
    );
  } else if (message is MediaMessage) {
    return originalData.copyWith(
      conversationId: message.conversationId,
      conversationType: "user",
      lastMessage: LastMessage(
        id: message.id.toString(),
        muid: message.muid,
        conversationId: message.conversationId,
        sender: message.sender?.uid,
        // receiverType: message.receiver,
        receiver: message.receiverUid,
        type: message.type,
        category: message.category,
        data: LastMessageData(
          // text: message.text,
          entities: Entities(
            sender: Receiver(
              entity: ConversationWith(
                uid: message.sender?.uid,
                name: message.sender?.name,
                status: message.sender?.status,

                role: message.sender?.role,
                lastActiveAt: getUnixTimeFromDate(message.sender?.lastActiveAt),
                // createdAt: getUnixTimeFromDate(message.sender?.),
                // conversationId: message.sender?.conversationId
              ),
              // entityType: message.sender?.,
            ),
            receiver: Receiver(
              entity: ConversationWith(
                uid: message.receiverUid,
                // name: message.,
                // status: message.sender?.status,

                // role: message.sender?.role,
                // lastActiveAt:
                //     getUnixTimeFromDate(message.sender?.lastActiveAt),
                // createdAt: getUnixTimeFromDate(message.sender?.),
                // conversationId: message.sender?.conversationId
              ),
              entityType: message.receiverType,
            ),
          ),
        ),
        sentAt: getUnixTimeFromDate(message.sentAt),
        deletedAt: getUnixTimeFromDate(message.deletedAt),
        deliveredAt: getUnixTimeFromDate(message.deliveredAt),
        readAt: getUnixTimeFromDate(message.readAt),
        updatedAt: getUnixTimeFromDate(message.updatedAt),
      ),
      unreadMessageCount: unreadMessageCount,
      // unreadMessageCount:
      //     (int.tryParse(originalData.unreadMessageCount ?? '0') ?? 0 + 1)
      //         .toString(),
      updatedAt: DateTime.now().millisecondsSinceEpoch,
    );
  }
  return null;
}

/*
 create a new conversation object in case of new messages
*/
ConversationResponseData createNewConversationObject({
  required Conversation conversation,
  // required bool isMessageReceived,
}) {
  try {
    ConversationResponseData newConversation = ConversationResponseData(
      conversationId: conversation.conversationId,
      conversationType: conversation.conversationType,
      unreadMessageCount: (conversation.unreadMessageCount ?? 0).toString(),
      // unreadMessageCount: (conversation.unreadMessageCount ?? 0).toString(),
      // createdAt: conversation.
      updatedAt: getUnixTimeFromDate(conversation.updatedAt),
      lastReadMessageId: conversation.lastReadMessageId,
      conversationWith:
          _mapAppEntityToConversationWith(conversation.conversationWith),
      lastMessage: _mapBaseMessageToLastMessage(conversation.lastMessage),
    );

    return newConversation;
  } catch (e) {
    print(e);
    return ConversationResponseData();
  }
}

ConversationWith? _mapAppEntityToConversationWith(AppEntity appEntity) {
  if (appEntity is User) {
    return ConversationWith(
      uid: appEntity.uid,
      name: appEntity.name,
      avatar: appEntity.avatar,
      status: appEntity.status,
      lastActiveAt: getUnixTimeFromDate(appEntity.lastActiveAt),
    );
  } else if (appEntity is Group) {
    return ConversationWith(
      guid: appEntity.guid,
      name: appEntity.name,
      // avatar: appEntity.avatar,
      type: appEntity.type,
      scope: appEntity.scope,
      membersCount: appEntity.membersCount,
      owner: appEntity.owner,
      createdAt: getUnixTimeFromDate(appEntity.createdAt),
      updatedAt: getUnixTimeFromDate(appEntity.updatedAt),
      hasJoined: appEntity.hasJoined,
    );
  }
  return null; // Handle unexpected cases gracefully
}

LastMessage? _mapBaseMessageToLastMessage(BaseMessage? baseMessage) {
  if (baseMessage == null) return null;

  print('BaseMessage runtime type: ${baseMessage.runtimeType}');

  // Initialize common properties
  var lastMessage = LastMessage(
    id: baseMessage.id.toString(),
    muid: baseMessage.muid,
    conversationId: baseMessage.conversationId,
    sender: baseMessage.sender?.uid,
    receiverType: baseMessage.receiverType,
    receiver: baseMessage.receiverUid,
    category: baseMessage.category,
    type: baseMessage.type,
    sentAt: getUnixTimeFromDate(baseMessage.sentAt),
    deletedAt: getUnixTimeFromDate(baseMessage.deletedAt),
    deliveredAt: getUnixTimeFromDate(baseMessage.deliveredAt),
    readAt: getUnixTimeFromDate(baseMessage.readAt),
    updatedAt: getUnixTimeFromDate(baseMessage.updatedAt),
  );

  // Add specific data for TextMessage
  if (baseMessage is TextMessage) {
    return lastMessage.copyWith(
      data: LastMessageData(
        text: baseMessage.text,
        entities: Entities(
          sender: Receiver(
            entity: ConversationWith(
              uid: baseMessage.sender?.uid,
              name: baseMessage.sender?.name,
              status: baseMessage.sender?.status,
              role: baseMessage.sender?.role,
              lastActiveAt:
                  getUnixTimeFromDate(baseMessage.sender?.lastActiveAt),
            ),
          ),
          receiver: Receiver(
            entity: ConversationWith(
              uid: baseMessage.receiverUid,
            ),
            entityType: baseMessage.receiverType,
          ),
        ),
      ),
    );
  }

  // Add specific data for MediaMessage
  if (baseMessage is MediaMessage) {
    return lastMessage.copyWith(
      data: LastMessageData(
        url: baseMessage.attachment?.fileUrl,
        entities: Entities(
          sender: Receiver(
            entity: ConversationWith(
              uid: baseMessage.sender?.uid,
              name: baseMessage.sender?.name,
              status: baseMessage.sender?.status,
              role: baseMessage.sender?.role,
              lastActiveAt:
                  getUnixTimeFromDate(baseMessage.sender?.lastActiveAt),
            ),
          ),
          receiver: Receiver(
            entity: ConversationWith(
              uid: baseMessage.receiverUid,
            ),
            entityType: baseMessage.receiverType,
          ),
        ),
      ),
    );
  }

  if (baseMessage is Action) {
    var addedByUser = baseMessage.actionBy as User;
    var addedUser = baseMessage.actionOn as User;
    var addedToGroup = baseMessage.actionFor as Group;

    return lastMessage.copyWith(
      data: LastMessageData(
        action: baseMessage.action,
        entities: Entities(
          actionByUser: Receiver(
            entity: ConversationWith(
              uid: addedByUser.uid,
              name: addedByUser.name,
              role: addedByUser.role,
              status: addedByUser.status,
              lastActiveAt: getUnixTimeFromDate(addedByUser.lastActiveAt),
            ),
            entityType: "user",
          ),
          actionToUser: Receiver(
            entity: ConversationWith(
              uid: addedUser.uid,
              name: addedUser.name,
              role: addedUser.role,
              status: addedUser.status,
              lastActiveAt: getUnixTimeFromDate(addedUser.lastActiveAt),
            ),
            entityType: "user",
          ),
          actionInGroup: Receiver(
            entity: ConversationWith(
              guid: addedToGroup.guid,
              name: addedToGroup.name,
              type: addedToGroup.type,
              owner: addedToGroup.owner,
              createdAt: getUnixTimeFromDate(addedToGroup.createdAt),
              membersCount: addedToGroup.membersCount,
              conversationId: baseMessage.conversationId,
              // onlineMembersCount: addedToGroup.
            ),
          ),
        ),
      ),
    );
  }
  return null;
}

String getLastMessageForMedia({
  String messageType = "",
  String fullName = "",
  bool isSenderLoggedInUser = false,
}) {
  bool isMessageTypeVowel = startsWithVowel(messageType);

  String article = isMessageTypeVowel ? "an" : "a";

  if (isSenderLoggedInUser) {
    return "You sent $article $messageType.";
  } else {
    return "$fullName sent $article $messageType.";
  }
}

String getLastMessageForGroupActions(LastMessageData? data) {
  String actionByUser = (data?.entities?.actionByUser?.entity?.name) ?? "";

  String action = (data?.action) ?? "";

  String actionToUser = (data?.entities?.actionToUser?.entity?.name) ?? "";

  String lastMessageText = "$actionByUser $action $actionToUser";

  return lastMessageText;
}

String getLastMessage({
  LastMessage? lastMessage,
  bool isLastMessageOfLoggedInUser = false,
}) {
  bool isLastMessageText = lastMessage?.type == "text";

  String lastMessageCategory = lastMessage?.category?.toLowerCase() ?? "";

  switch (lastMessageCategory) {
    case "message":
      if (lastMessage?.deletedAt != null && lastMessage?.deletedAt != 0) {
        return "Message was deleted.";
      }
      String lastMessageText = isLastMessageText
          ? (lastMessage?.data?.text ?? "")
          : getLastMessageForMedia(
              isSenderLoggedInUser: isLastMessageOfLoggedInUser,
              messageType: lastMessage?.type ?? "",
              fullName:
                  (lastMessage?.data?.entities?.sender?.entity?.name) ?? "",
            );
      return lastMessageText;
    case "action":
      return getLastMessageForGroupActions(lastMessage?.data);
    default:
      return "";
  }
}
