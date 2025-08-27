class ConversationResponse {
  final List<ConversationResponseData>? data;
  final PaginationMeta? paginationMeta;

  ConversationResponse({
    this.data,
    this.paginationMeta,
  });

  factory ConversationResponse.fromJson(Map<String, dynamic> json) =>
      ConversationResponse(
          data: json['data'] != null
              ? List<ConversationResponseData>.from(
                  json['data'].map((x) => ConversationResponseData.fromJson(x)))
              : null,
          paginationMeta: json['meta'] != null
              ? PaginationMeta.fromJson(json['meta'])
              : null);

  Map<String, dynamic> toJson() => {
        "data": data?.map((x) => x.toJson()).toList(),
        "meta": paginationMeta?.toJson(),
      };
}

class PaginationMeta {
  final Pagination? pagination;

  PaginationMeta(this.pagination);

  Map<String, dynamic> toJson() => {
        'pagination': pagination?.toJson(),
      };

  factory PaginationMeta.fromJson(Map<String, dynamic> json) {
    return PaginationMeta(
      json['pagination'] != null
          ? Pagination.fromJson(json['pagination'])
          : null,
    );
  }
}

class Pagination {
  final int? total;
  final int? count;
  final int? perPage;
  final int? currentPage;
  final int? totalPages;

  Pagination({
    this.total,
    this.count,
    this.perPage,
    this.currentPage,
    this.totalPages,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) => Pagination(
        total: json["total"],
        count: json["count"],
        perPage: json["per_page"],
        currentPage: json["current_page"],
        totalPages: json["total_pages"],
      );

  Map<String, dynamic> toJson() => {
        "total": total,
        "count": count,
        "per_page": perPage,
        "current_page": currentPage,
        "total_pages": totalPages,
      };
}

class ConversationResponseData {
  final String? conversationId;
  final String? conversationType;
  final String? unreadMessageCount;
  final int? createdAt;
  final int? updatedAt;
  final LastMessage? lastMessage;
  final String? lastReadMessageId;
  final ConversationWith? conversationWith;

  ConversationResponseData({
    this.conversationId,
    this.conversationType,
    this.unreadMessageCount,
    this.createdAt,
    this.updatedAt,
    this.lastMessage,
    this.lastReadMessageId,
    this.conversationWith,
  });

  factory ConversationResponseData.fromJson(Map<String, dynamic> json) =>
      ConversationResponseData(
        conversationId: json["conversationId"],
        conversationType: json["conversationType"],
        unreadMessageCount: json["unreadMessageCount"],
        createdAt: json["createdAt"],
        updatedAt: json["updatedAt"],
        lastMessage: json["lastMessage"] == null
            ? null
            : LastMessage.fromJson(json["lastMessage"]),
        lastReadMessageId: json["lastReadMessageId"],
        conversationWith: json["conversationWith"] == null
            ? null
            : ConversationWith.fromJson(json["conversationWith"]),
      );

  Map<String, dynamic> toJson() => {
        "conversationId": conversationId,
        "conversationType": conversationType,
        "unreadMessageCount": unreadMessageCount,
        "createdAt": createdAt,
        "updatedAt": updatedAt,
        "lastMessage": lastMessage?.toJson(),
        "lastReadMessageId": lastReadMessageId,
        "conversationWith": conversationWith?.toJson(),
      };

  ConversationResponseData copyWith({
    String? conversationId,
    String? conversationType,
    String? unreadMessageCount,
    int? createdAt,
    int? updatedAt,
    LastMessage? lastMessage,
    String? lastReadMessageId,
    ConversationWith? conversationWith,
  }) {
    return ConversationResponseData(
      conversationId: conversationId ?? this.conversationId,
      conversationType: conversationType ?? this.conversationType,
      unreadMessageCount: unreadMessageCount ?? this.unreadMessageCount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      lastMessage: lastMessage ?? this.lastMessage,
      lastReadMessageId: lastReadMessageId ?? this.lastReadMessageId,
      conversationWith: conversationWith ?? this.conversationWith,
    );
  }
}

class ConversationWith {
  final String? uid;
  final String? name;
  final String? status;
  final String? role;
  final int? lastActiveAt;
  final int? createdAt;
  final String? conversationId;
  final String? avatar;

  // for group
  final String? guid;
  final String? type;
  final String? scope;
  final int? membersCount;
  final int? joinedAt;
  final bool? hasJoined;
  final String? owner;
  final int? updatedAt;
  final int? onlineMembersCount;

  //TODO: METADATA ?

  ConversationWith({
    this.uid,
    this.name,
    this.status,
    this.role,
    this.lastActiveAt,
    this.createdAt,
    this.conversationId,
    this.avatar,

    // for group
    this.guid,
    this.type,
    this.scope,
    this.membersCount,
    this.joinedAt,
    this.hasJoined,
    this.owner,
    this.updatedAt,
    this.onlineMembersCount,
  });

  factory ConversationWith.fromJson(Map<String, dynamic> json) =>
      ConversationWith(
        uid: json["uid"],
        name: json["name"],
        status: json["status"],
        role: json["role"],
        lastActiveAt: json["lastActiveAt"],
        createdAt: json["createdAt"],
        conversationId: json["conversationId"],

        avatar: json["avatar"],

        // for group
        guid: json["guid"],
        type: json["type"],
        scope: json["scope"],
        membersCount: json["membersCount"],
        joinedAt: json["joinedAt"],
        hasJoined: json["hasJoined"],
        owner: json["owner"],
        updatedAt: json["updatedAt"],
        onlineMembersCount: json["onlineMembersCount"],
      );

  Map<String, dynamic> toJson() => {
        "uid": uid,
        "name": name,
        "status": status,
        "role": role,
        "lastActiveAt": lastActiveAt,
        "createdAt": createdAt,
        "conversationId": conversationId,

        "avatar": avatar,

        // for group
        "guid": guid,
        "type": type,
        "scope": scope,
        "membersCount": membersCount,
        "joinedAt": joinedAt,
        "hasJoined": hasJoined,
        "owner": owner,
        "updatedAt": updatedAt,
        "onlineMembersCount": onlineMembersCount,
      };

  ConversationWith copyWith({
    String? uid,
    String? name,
    String? status,
    String? role,
    int? lastActiveAt,
    int? createdAt,
    String? conversationId,
    String? avatar,
    String? guid,
    String? type,
    String? scope,
    int? membersCount,
    int? joinedAt,
    bool? hasJoined,
    String? owner,
    int? updatedAt,
    int? onlineMembersCount,
  }) {
    return ConversationWith(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      status: status ?? this.status,
      role: role ?? this.role,
      lastActiveAt: lastActiveAt ?? this.lastActiveAt,
      createdAt: createdAt ?? this.createdAt,
      conversationId: conversationId ?? this.conversationId,
      avatar: avatar ?? this.avatar,
      guid: guid ?? this.guid,
      type: type ?? this.type,
      scope: scope ?? this.scope,
      membersCount: membersCount ?? this.membersCount,
      joinedAt: joinedAt ?? this.joinedAt,
      hasJoined: hasJoined ?? this.hasJoined,
      owner: owner ?? this.owner,
      updatedAt: updatedAt ?? this.updatedAt,
      onlineMembersCount: onlineMembersCount ?? this.onlineMembersCount,
    );
  }
}

class LastMessage {
  final String? id;
  final String? muid;
  final String? conversationId;
  final String? sender;
  final String? receiverType;
  final String? receiver;
  final String? category;
  final String? type;
  final LastMessageData? data;
  final int? sentAt;
  final int? deletedAt;
  final int? deliveredAt;
  final int? readAt;
  final int? updatedAt;

  LastMessage({
    this.id,
    this.muid,
    this.conversationId,
    this.sender,
    this.receiverType,
    this.receiver,
    this.category,
    this.type,
    this.data,
    this.sentAt,
    this.deletedAt,
    this.deliveredAt,
    this.readAt,
    this.updatedAt,
  });

  factory LastMessage.fromJson(Map<String, dynamic> json) => LastMessage(
        id: json["id"],
        muid: json["muid"],
        conversationId: json["conversationId"],
        sender: json["sender"],
        receiverType: json["receiverType"],
        receiver: json["receiver"],
        category: json["category"],
        type: json["type"],
        data: json["data"] == null
            ? null
            : LastMessageData.fromJson(json["data"]),
        sentAt: json["sentAt"],
        deletedAt: json["deletedAt"],
        deliveredAt: json["deliveredAt"],
        readAt: json["readAt"],
        updatedAt: json["updatedAt"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "muid": muid,
        "conversationId": conversationId,
        "sender": sender,
        "receiverType": receiverType,
        "receiver": receiver,
        "category": category,
        "type": type,
        "data": data?.toJson(),
        "sentAt": sentAt,
        "deletedAt": deletedAt,
        "deliveredAt": deliveredAt,
        "readAt": readAt,
        "updatedAt": updatedAt,
      };

  LastMessage copyWith({
    String? id,
    String? muid,
    String? conversationId,
    String? sender,
    String? receiverType,
    String? receiver,
    String? category,
    String? type,
    LastMessageData? data,
    int? sentAt,
    int? deletedAt,
    int? deliveredAt,
    int? readAt,
    int? updatedAt,
  }) {
    return LastMessage(
      id: id ?? this.id,
      muid: muid ?? this.muid,
      conversationId: conversationId ?? this.conversationId,
      sender: sender ?? this.sender,
      receiverType: receiverType ?? this.receiverType,
      receiver: receiver ?? this.receiver,
      category: category ?? this.category,
      type: type ?? this.type,
      data: data ?? this.data,
      sentAt: sentAt ?? this.sentAt,
      deletedAt: deletedAt ?? null,
      deliveredAt: deliveredAt ?? this.deliveredAt,
      readAt: readAt ?? this.readAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class LastMessageData {
  final String? text;
  final Entities? entities;
  final String? resource;
  final Moderation? moderation;
  final String? action;

  final String? url;

  LastMessageData({
    this.text,
    this.entities,
    this.resource,
    this.moderation,
    this.action,
    this.url,
  });

  factory LastMessageData.fromJson(Map<String, dynamic> json) =>
      LastMessageData(
        text: json["text"],
        entities: json["entities"] == null
            ? null
            : Entities.fromJson(json["entities"]),
        resource: json["resource"],
        moderation: json["moderation"] == null
            ? null
            : Moderation.fromJson(json["moderation"]),
        action: json["action"],
        url: json["url"],
      );

  Map<String, dynamic> toJson() => {
        "text": text,
        "entities": entities?.toJson(),
        "resource": resource,
        "moderation": moderation?.toJson(),
        "action": action,
        "url": url,
      };
}

class Entities {
  final Receiver? sender;
  final Receiver? receiver;
  final Receiver? actionByUser;
  final Receiver? actionToUser;
  final Receiver? actionInGroup;

  Entities({
    this.sender,
    this.receiver,
    this.actionByUser,
    this.actionToUser,
    this.actionInGroup,
  });

  factory Entities.fromJson(Map<String, dynamic> json) => Entities(
        sender:
            json["sender"] == null ? null : Receiver.fromJson(json["sender"]),
        receiver: json["receiver"] == null
            ? null
            : Receiver.fromJson(json["receiver"]),
        actionByUser: json["by"] == null ? null : Receiver.fromJson(json["by"]),
        actionToUser: json["on"] == null ? null : Receiver.fromJson(json["on"]),
        actionInGroup:
            json["for"] == null ? null : Receiver.fromJson(json["for"]),
      );

  Map<String, dynamic> toJson() => {
        "sender": sender?.toJson(),
        "receiver": receiver?.toJson(),
        "actionByUser": receiver?.toJson(),
        "actionToUser": receiver?.toJson(),
        "actionInGroup": receiver?.toJson(),
      };
}

class Receiver {
  final ConversationWith? entity;
  final String? entityType;

  Receiver({
    this.entity,
    this.entityType,
  });

  factory Receiver.fromJson(Map<String, dynamic> json) => Receiver(
        entity: json["entity"] == null
            ? null
            : ConversationWith.fromJson(json["entity"]),
        entityType: json["entityType"],
      );

  Map<String, dynamic> toJson() => {
        "entity": entity?.toJson(),
        "entityType": entityType,
      };
}

class Moderation {
  final String? status;

  Moderation({
    this.status,
  });

  factory Moderation.fromJson(Map<String, dynamic> json) => Moderation(
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
      };
}
