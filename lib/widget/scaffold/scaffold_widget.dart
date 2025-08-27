import 'package:go_router/go_router.dart';
import 'package:mydrivenepal/shared/theme/app_colors_theme_extension.dart';
import 'package:mydrivenepal/shared/theme/app_text_theme.dart';
import 'package:mydrivenepal/widget/scaffold/side_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mydrivenepal/shared/util/util.dart';
import 'package:flutter/services.dart';

import '../../shared/shared.dart';

class ScaffoldWidget extends StatefulWidget {
  final Widget child;
  final GlobalKey? iKey;
  final double? padding;
  final bool showAppbar;
  final bool isCenterAligned;
  final bool showSideBar;
  final bool showBackButton;
  final String appbarTitle;
  final Widget? actionButton;
  final Color? bgColor;
  final void Function()? onPressedIcon;
  final Widget? bottomBar;
  final EdgeInsets? bottomBarPadding;
  final double? top;
  final double? bottom;
  final bool? resizeToAvoidBottomInset;
  final bool useSafeArea;
  final bool showTransparentStatusBar;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;

  const ScaffoldWidget(
      {Key? key,
      required this.child,
      this.actionButton,
      this.resizeToAvoidBottomInset,
      this.padding,
      this.isCenterAligned = true,
      this.showAppbar = true,
      this.showBackButton = true,
      this.showSideBar = false,
      this.appbarTitle = '',
      this.bgColor,
      this.onPressedIcon,
      this.iKey,
      this.bottomBar,
      this.top,
      this.bottom,
      this.floatingActionButtonLocation,
      this.useSafeArea = true,
      this.showTransparentStatusBar = false,
      this.floatingActionButton,
      this.bottomBarPadding = const EdgeInsets.symmetric(
        vertical: Dimens.spacing_8,
        horizontal: Dimens.spacing_large,
      )})
      : super(key: key);

  @override
  State<ScaffoldWidget> createState() => _ScaffoldWidgetState();
}

class _ScaffoldWidgetState extends State<ScaffoldWidget> {
  @override
  Widget build(BuildContext context) {
    if (widget.showTransparentStatusBar) {
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: AppColors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ));
    }
    return Scaffold(
      resizeToAvoidBottomInset: widget.resizeToAvoidBottomInset,
      drawer: widget.showSideBar ? const SideNavigationBar() : null,
      appBar: _buildAppBar(),
      floatingActionButton: widget.floatingActionButton,
      floatingActionButtonLocation: widget.floatingActionButtonLocation,
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: SafeArea(
          top: widget.useSafeArea,
          bottom: widget.useSafeArea,
          child: Container(
            color: widget.bgColor,
            width: double.infinity,
            padding: EdgeInsets.only(
                top: widget.top ?? 0,
                left: widget.padding ?? Dimens.spacing_large,
                right: widget.padding ?? Dimens.spacing_large,
                bottom: widget.bottom ?? 0),
            child: widget.child,
          ),
        ),
      ),
      bottomNavigationBar: widget.bottomBar,
    );
  }

  _buildAppBar() {
    final appColors = context.appColors;

    if (widget.showAppbar) {
      return AppBar(
        centerTitle: widget.isCenterAligned,
        key: widget.iKey,
        leading: _buildLeadingWidget(),
        title: Text(
          widget.appbarTitle,
          style: Theme.of(context)
              .textTheme
              .bodyText
              .copyWith(color: appColors.textInverse),
        ),
        actions: [if (widget.actionButton != null) widget.actionButton!],
      );
    } else {
      return null;
    }
  }

  _buildLeadingWidget() {
    final appColors = context.appColors;

    if (widget.showSideBar) {
      return null;
    } else if (widget.showBackButton &&
        (context.canPop() || widget.onPressedIcon != null)) {
      return Builder(
        builder: (BuildContext context) {
          return IconButton(
            color: appColors.bgGrayBold,
            iconSize: Dimens.spacing_extra_large,
            icon: const Icon(CupertinoIcons.chevron_left),
            onPressed: widget.onPressedIcon ?? () => context.pop(),
            tooltip: MaterialLocalizations.of(context).backButtonTooltip,
          );
        },
      );
    } else {
      return null;
    }
  }
}
