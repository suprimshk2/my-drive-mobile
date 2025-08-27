import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cometchat_chat_uikit/cometchat_chat_uikit.dart';
import 'package:go_router/go_router.dart';
import 'package:mydrivenepal/di/di.dart';
import 'package:mydrivenepal/feature/communications/screens/comms-listing/comms_screen_viewmodel.dart';
import 'package:mydrivenepal/feature/communications/utils/comet_chat_listeners/comet_chat_user_listener.dart';
import 'package:mydrivenepal/navigation/navigation_routes.dart';
import 'package:mydrivenepal/shared/shared.dart';
import 'package:mydrivenepal/shared/theme/app_colors_theme_extension.dart';
import 'package:mydrivenepal/shared/theme/app_text_theme.dart';
import 'package:mydrivenepal/widget/widget.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../../../widget/shimmer/message_shimmer.dart';

class CometChatMessagesScreen extends StatefulWidget {
  final String userId;
  final String fullName;
  final bool isFromNotification;

  const CometChatMessagesScreen({
    super.key,
    required this.userId,
    required this.fullName,
    this.isFromNotification = false,
  });

  @override
  State<CometChatMessagesScreen> createState() =>
      _CometChatMessagesScreenState();
}

class _CometChatMessagesScreenState extends State<CometChatMessagesScreen> {
  late CometChatColorPalette colorPalette;
  late CometChatTypography typography;
  late CometChatSpacing spacing;

  final _commsScreenViewmodel = locator<CommsScreenViewModel>();

  User? user;

  var uuid = const Uuid();

  // listener IDs for comet chat
  String userListenerId = "";

  @override
  void initState() {
    user = User.fromUID(uid: widget.userId, name: widget.fullName);

    initializeCometChatListeners();

    super.initState();
  }

  initializeCometChatListeners() {
    userListenerId = uuid.v4();

    // user listeners
    ChatUserListener userListener = ChatUserListener(
      onUserOnlineCallback: (uid) {
        print("U: user online: $uid");

        if (uid == widget.userId) {
          _commsScreenViewmodel.isConversingUserOnline = true;
        }
      },
      onUserOfflineCallback: (uid) {
        print("U: user offline: $uid");

        if (uid == widget.userId) {
          _commsScreenViewmodel.isConversingUserOnline = false;
        }
      },
    );

    CometChat.addUserListener(userListenerId, userListener);
  }

  @override
  void dispose() {
    // Removing the message listener to prevent memory leaks
    CometChat.removeUserListener(userListenerId);
    super.dispose();
  }

  double sendButtonOpacity = 0.5;

  void onPop() {
    if (widget.isFromNotification) {
      navigatorKey.currentContext?.goNamed(AppRoute.landing.name);
    } else {
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;

    final ccColor = CometChatThemeHelper.getColorPalette(context);

    final templates = CometChatUIKit.getDataSource().getAllMessageTemplates();
    for (int i = 0; i < templates.length; i++) {
      CometChatMessageTemplate template = templates[i];
      final oldOptions = template.options;
      template.options = (user, message, context, group, additionalConfigs) {
        List<CometChatMessageOption> options = [];
        if (oldOptions != null) {
          options.addAll(
              oldOptions(user, message, context, group, additionalConfigs) ??
                  []);
        }
        options.removeWhere(
          (option) =>
              option.id == MessageOptionConstants.editMessage ||
              option.id == MessageOptionConstants.deleteMessage ||
              option.id == MessageOptionConstants.shareMessage ||
              option.id == MessageOptionConstants.copyMessage ||
              option.id == MessageOptionConstants.forwardMessage ||
              option.id == MessageOptionConstants.replyInThreadMessage ||
              option.id == MessageOptionConstants.sendMessagePrivately ||
              option.id == MessageOptionConstants.messageInformation,
        );
        return options;
      };
    }

    return ChangeNotifierProvider(
      create: (context) => _commsScreenViewmodel,
      child:
          Consumer<CommsScreenViewModel>(builder: (context, viewmodel, child) {
        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          appBar: _buildAppBar(context, viewmodel.isConversingUserOnline),
          resizeToAvoidBottomInset: true,
          body: Container(
            color: Theme.of(context).scaffoldBackgroundColor,
            child: Column(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => FocusScope.of(context).unfocus(),
                    child: CometChatMessageList(
                      user: user,
                      disableSoundForMessages: true,
                      loadingStateView: (context) {
                        return ChatShimmerScreen();
                      },
                      hideTimestamp: false,
                      templates: templates,
                      style: CometChatMessageListStyle(
                        backgroundColor:
                            Theme.of(context).scaffoldBackgroundColor,
                        borderRadius: BorderRadius.circular(2),
                        messageInformationStyle:
                            CometChatMessageInformationStyle(
                          borderRadius: BorderRadius.circular(2),
                        ),
                        incomingMessageBubbleStyle:
                            _incomingMessageBubbleStyle(context),
                        outgoingMessageBubbleStyle:
                            _outgoingMessageBubbleStyle(context),
                      ),
                    ),
                  ),
                ),
                CometChatMessageComposer(
                  user: user,
                  disableSoundForMessages: true,
                  hideVoiceRecordingButton: true,
                  disableMentions: true,
                  hideAudioAttachmentOption: true,
                  onChange: (text) {
                    setState(() {
                      sendButtonOpacity = isNotEmpty(text) ? 1 : 0.5;
                    });
                  },
                  sendButtonView: Opacity(
                    opacity: sendButtonOpacity,
                    child: ImageWidget(
                      isSvg: true,
                      imagePath: ImageConstants.IC_SEND,
                      width: Dimens.spacing_30,
                      height: Dimens.spacing_30,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  AppBar _buildAppBar(
    BuildContext context,
    bool isOnline,
  ) {
    final appColors = context.appColors;

    return AppBar(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          TextWidget(
            text: widget.fullName,
            textOverflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodyText,
          ),
          SizedBox(width: Dimens.spacing_4),
          Icon(
            CupertinoIcons.circle_fill,
            size: 10,
            color: isOnline ? appColors.success.main : appColors.gray.main,
          ),
        ],
      ),
      leading: IconButton(
        onPressed: () => onPop(),
        icon: Padding(
          padding: EdgeInsets.only(left: Dimens.spacing_6),
          child: Icon(
            CupertinoIcons.chevron_left,
            size: Dimens.spacing_extra_large,
            color: appColors.bgGrayBold,
          ),
        ),
      ),
    );
  }

  CometChatIncomingMessageBubbleStyle _incomingMessageBubbleStyle(
      BuildContext context) {
    final appColors = context.appColors;

    return CometChatIncomingMessageBubbleStyle(
      backgroundColor: appColors.gray.subtle,
      borderRadius: BorderRadius.only(
        topLeft: Radius.zero,
        topRight: Radius.circular(Dimens.spacing_8),
        bottomLeft: Radius.circular(Dimens.spacing_8),
        bottomRight: Radius.circular(Dimens.spacing_8),
      ),
      textBubbleStyle: _textBubbleStyle(context, isForIncoming: true),
      imageBubbleStyle: _imageBubbleStyle(context, isForIncoming: true),
      videoBubbleStyle: _videoBubbleStyle(context, isForIncoming: true),
      fileBubbleStyle: _fileBubbleStyle(context, isForIncoming: true),
    );
  }

  CometChatOutgoingMessageBubbleStyle _outgoingMessageBubbleStyle(
      BuildContext context) {
    final appColors = context.appColors;

    return CometChatOutgoingMessageBubbleStyle(
      backgroundColor: appColors.primary.main,
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(Dimens.spacing_8),
        topRight: Radius.circular(Dimens.spacing_8),
        bottomLeft: Radius.circular(Dimens.spacing_8),
        bottomRight: Radius.zero,
      ),
      messageReceiptStyle: CometChatMessageReceiptStyle(
        readIconColor: AppColors.white,
        waitIconColor: AppColors.white,
        sentIconColor: AppColors.white,
        deliveredIconColor: AppColors.white,
        errorIconColor: AppColors.white,
      ),
      textBubbleStyle: _textBubbleStyle(context, isForIncoming: false),
      imageBubbleStyle: _imageBubbleStyle(context, isForIncoming: false),
      videoBubbleStyle: _videoBubbleStyle(context, isForIncoming: false),
      fileBubbleStyle: _fileBubbleStyle(context, isForIncoming: false),
    );
  }

  CometChatTextBubbleStyle _textBubbleStyle(
    BuildContext context, {
    required bool isForIncoming,
  }) {
    final appColors = context.appColors;

    return CometChatTextBubbleStyle(
      textStyle: Theme.of(context).textTheme.caption.copyWith(
            color: isForIncoming ? appColors.gray.main : AppColors.white,
          ),
      messageBubbleDateStyle: CometChatDateStyle(
        textStyle: Theme.of(context).textTheme.bodyTextSmall.copyWith(
              color: isForIncoming ? appColors.gray.main : AppColors.white,
            ),
      ),
    );
  }

  CometChatImageBubbleStyle _imageBubbleStyle(
    BuildContext context, {
    required bool isForIncoming,
  }) {
    final appColors = context.appColors;

    return CometChatImageBubbleStyle(
      messageBubbleDateStyle: CometChatDateStyle(
        textStyle: Theme.of(context).textTheme.bodyTextSmall.copyWith(
              color: isForIncoming ? appColors.gray.main : AppColors.white,
            ),
      ),
    );
  }

  CometChatVideoBubbleStyle _videoBubbleStyle(
    BuildContext context, {
    required bool isForIncoming,
  }) {
    final appColors = context.appColors;

    return CometChatVideoBubbleStyle(
      playIconColor: appColors.gray.main,
      playIconBackgroundColor:
          isForIncoming ? appColors.gray.main : AppColors.white,
    );
  }

  CometChatFileBubbleStyle _fileBubbleStyle(
    BuildContext context, {
    required bool isForIncoming,
  }) {
    final appColors = context.appColors;

    return CometChatFileBubbleStyle(
      titleTextStyle: Theme.of(context).textTheme.caption,
      subtitleTextStyle: Theme.of(context).textTheme.bodyTextSmall,
      downloadIconTint: isForIncoming ? appColors.gray.main : AppColors.white,
      titleColor: isForIncoming ? appColors.gray.main : AppColors.white,
      subtitleColor: isForIncoming ? appColors.gray.main : AppColors.white,
      backgroundColor:
          isForIncoming ? appColors.gray.subtle : appColors.primary.main,
      messageBubbleDateStyle: CometChatDateStyle(
        textStyle: Theme.of(context).textTheme.bodyTextSmall.copyWith(
              color: isForIncoming ? appColors.gray.main : AppColors.white,
            ),
      ),
    );
  }
}
