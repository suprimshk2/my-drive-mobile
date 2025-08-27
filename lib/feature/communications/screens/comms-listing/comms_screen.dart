import 'package:cometchat_chat_uikit/cometchat_chat_uikit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:mydrivenepal/di/service_locator.dart';
import 'package:mydrivenepal/feature/communications/constants/coms_strings.dart';
import 'package:mydrivenepal/feature/communications/data/models/conversation_response.dart';
import 'package:mydrivenepal/feature/communications/screens/comms-listing/comms_screen_viewmodel.dart';
import 'package:mydrivenepal/feature/communications/screens/widgets/comms_tile.dart';
import 'package:mydrivenepal/feature/communications/utils/comet_chat_listeners/comet_chat_action_listener.dart';
import 'package:mydrivenepal/feature/communications/utils/comet_chat_listeners/comet_chat_message_listener.dart';
import 'package:mydrivenepal/feature/communications/utils/comet_chat_methods.dart';
import 'package:mydrivenepal/shared/shared.dart';
import 'package:mydrivenepal/widget/response_builder.dart';
import 'package:mydrivenepal/widget/widget.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:uuid/uuid.dart';

class CommsScreen extends StatefulWidget {
  const CommsScreen({super.key});

  @override
  State<CommsScreen> createState() => _CommsScreenState();
}

class _CommsScreenState extends State<CommsScreen> {
  final _commsScreenViewmodel = locator<CommsScreenViewModel>();
  final RefreshController _refreshController = RefreshController(
    initialRefresh: false,
  );
  var uuid = const Uuid();

  // listener IDs for comet chat
  String userListenerId = "";
  String messageReceiveListenerId = "";
  String chatActionListenerId = "";

  @override
  void initState() {
    initializeCometChatListeners();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      getData();
    });

    super.initState();
  }

  Future<void> getData() async {
    await _commsScreenViewmodel.getAuthUserId();
    await _commsScreenViewmodel.getConversations();
  }

  Future<void> _onRefresh() async {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getData();
    });
    _refreshController.refreshCompleted();
  }

  initializeCometChatListeners() {
    userListenerId = uuid.v4();

    messageReceiveListenerId = uuid.v4();

    chatActionListenerId = uuid.v4();

    // message received listeners
    CometChatMessageListeners messageReceivedListener =
        CometChatMessageListeners(
      onTextMessageReceivedCallback: (TextMessage message) {
        debugPrint("R: listened from UI for text: ${message.text}");

        _commsScreenViewmodel.onMessageReceivedCallback(
          textMessage: message,
          isMessageReceived: true,
        );
      },
      onMediaMessageReceivedCallback: (MediaMessage mediaMessage) {
        debugPrint("R: listened from UI for media: ${mediaMessage.type}");
        _commsScreenViewmodel.onMessageReceivedCallback(
          mediaMessage: mediaMessage,
          isMessageReceived: true,
        );
      },
      onCustomMessageReceivedCallback: (customMessage) {},
    );

    CometChat.addMessageListener(
        messageReceiveListenerId, messageReceivedListener);

    // chat action listeners
    var chatActions = ChatActions(
      onMessageSentCallBack: (message, messageStatus) {
        if (messageStatus == MessageStatus.sent) {
          debugPrint("S: listened from UI for message: $message");

          _commsScreenViewmodel.onMessageReceivedCallback(
            baseMessage: message,
            isMessageReceived: false,
          );
        }
      },
    );

    CometChatMessageEvents.addMessagesListener(
        chatActionListenerId, chatActions);
  }

  @override
  void dispose() {
    // Removing the message listener to prevent memory leaks
    CometChat.removeMessageListener(messageReceiveListenerId);
    CometChatMessageEvents.removeMessagesListener(chatActionListenerId);
    CometChat.removeUserListener(userListenerId);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<CommsScreenViewModel>(
      create: (_) => _commsScreenViewmodel,
      child: ScaffoldWidget(
        appbarTitle: ComsStrings.communicationsTitle,
        padding: Dimens.spacing_8,
        child: Consumer<CommsScreenViewModel>(
            builder: (context, commsScreenViewModel, _) {
          return ResponseBuilder<List<ConversationResponseData>>(
            response: commsScreenViewModel.getConversationUseCase,
            onRetry: () {
              getData();
            },
            onLoading: () =>
                CardShimmerWidget(height: Dimens.spacing_50, needMargin: false),
            onData: (List<ConversationResponseData> conversationList) {
              if (conversationList.isEmpty) {
                return Center(
                  child: TextWidget(
                    text: ComsStrings.noCommunicationsFound,
                    textAlign: TextAlign.left,
                    textOverflow: TextOverflow.ellipsis,
                  ),
                );
              }

              return SmartRefresher(
                  controller: _refreshController,
                  onRefresh: _onRefresh,
                  enablePullDown: true,
                  enablePullUp: false,
                  child: ListView.builder(
                    physics: BouncingScrollPhysics(),
                    padding: EdgeInsets.only(
                        top: Dimens.spacing_extra_small, bottom: 18.h),
                    itemCount: conversationList.length,
                    itemBuilder: (_, index) {
                      final conversation = conversationList[index];

                      bool isLastMessageOfLoggedInUser =
                          conversation.lastMessage?.sender ==
                              _commsScreenViewmodel.authUserId;

                      bool isMessageReceived =
                          (int.parse(conversation.unreadMessageCount ?? '0') >
                              0);

                      return CommsTile(
                        onTap: () {
                          context.pushNamed(AppRoute.chat.name, extra: {
                            'userId': conversation.conversationWith?.uid ?? '',
                            'fullName':
                                conversation.conversationWith?.name ?? '',
                          });
                        },
                        isMessageReceived: isMessageReceived,
                        userImagePath:
                            conversation.conversationWith?.avatar ?? '',
                        userName: conversation.conversationWith?.name ?? '',
                        message: getLastMessage(
                          lastMessage: conversation.lastMessage,
                          isLastMessageOfLoggedInUser:
                              isLastMessageOfLoggedInUser,
                        ),
                        date: getFormattedDateForConversation(
                            getDateFromUnixTime(
                                conversation.lastMessage?.updatedAt)),
                      );
                    },
                  ));
            },
          );
        }),
      ),
    );
  }
}
