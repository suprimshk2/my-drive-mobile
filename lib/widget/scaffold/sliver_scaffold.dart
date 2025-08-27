import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:mydrivenepal/shared/theme/app_colors_theme_extension.dart';
import 'package:mydrivenepal/widget/scaffold/side_bar.dart';
import 'package:flutter/material.dart';
import '../../shared/shared.dart';
import '../widget.dart';

class SliverScaffoldWidget extends StatefulWidget {
  final dynamic controller;
  final Widget child;
  final GlobalKey? iKey;
  final double? padding;
  final bool? pinned;
  final bool showAppbar;
  final bool showSilverAppbar;
  final bool showSideBar;
  final bool showBackButton;
  final String appbarTitle;
  final Widget? flexibleSpace;
  final String? logo;
  final List<Widget>? actionButton;
  final Color? bgColor;
  final Color? appBgColor;
  final void Function()? onPressedIcon;
  final Widget? bottomBar;
  final Widget? bottomSheet;
  final EdgeInsets? bottomBarPadding;
  final double? top;
  final dynamic tabs;
  final double? bottom;
  final bool? resizeToAvoidBottomInset;
  final Color? statusBarColor;
  final int tabLength;
  final double? collapsingAppBarHeight;
  final double? expandedAppBarHeight;

  const SliverScaffoldWidget(
      {Key? key,
      required this.child,
      this.controller,
      this.actionButton,
      this.padding,
      this.pinned = false,
      this.showAppbar = false,
      this.showSilverAppbar = false,
      this.showBackButton = false,
      this.showSideBar = false,
      this.appbarTitle = '',
      this.flexibleSpace,
      this.bgColor,
      this.logo,
      this.appBgColor,
      this.onPressedIcon,
      this.iKey,
      this.bottomBar,
      this.bottomSheet,
      this.top,
      this.bottom,
      this.tabs,
      this.tabLength = 3,
      this.resizeToAvoidBottomInset,
      this.collapsingAppBarHeight,
      this.expandedAppBarHeight,
      this.statusBarColor,
      this.bottomBarPadding = const EdgeInsets.symmetric(
        vertical: Dimens.spacing_8,
        horizontal: Dimens.spacing_large,
      )})
      : super(key: key);

  @override
  State<SliverScaffoldWidget> createState() => _SliverScaffoldWidgetState();
}

class _SliverScaffoldWidgetState extends State<SliverScaffoldWidget> {
  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        bottomSheet: widget.bottomSheet,
        bottomNavigationBar: widget.bottomBar,
        resizeToAvoidBottomInset: widget.resizeToAvoidBottomInset,
        drawer: widget.showSideBar ? const SideNavigationBar() : null,
        body: DefaultTabController(
          length: widget.tabLength,
          child: NestedScrollView(
            physics: const NeverScrollableScrollPhysics(),
            controller: widget.controller,
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                SliverOverlapAbsorber(
                  handle:
                      NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                  sliver: SliverAppBar(
                    actions: widget.actionButton,
                    centerTitle: true,
                    titleSpacing: 5.sp,
                    // leading: _buildLeadingWidget(),
                    floating: true,
                    snap: true,
                    expandedHeight: widget.expandedAppBarHeight ?? 25.h,
                    toolbarHeight: widget.collapsingAppBarHeight ?? 6.h,
                    collapsedHeight: widget.collapsingAppBarHeight ?? 6.h,
                    flexibleSpace: widget.flexibleSpace,
                    title: TextWidget(
                      maxLines: 1,
                      textOverflow: TextOverflow.ellipsis,
                      text: widget.appbarTitle,
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium!
                          .copyWith(color: appColors.textInverse),
                    ),
                    pinned: widget.pinned ?? false,
                    forceElevated: innerBoxIsScrolled,
                    bottom: widget.tabs,
                  ),
                ),
              ];
            },
            body: widget.child,
          ),
        ),
      ),
    );
  }

  _buildLeadingWidget() {
    final appColors = context.appColors;

    if (widget.showSideBar) {
      return null;
    } else if (widget.showBackButton && Navigator.of(context).canPop()) {
      return Builder(
        builder: (BuildContext context) {
          return IconButton(
            color: appColors.bgGrayBold,
            iconSize: Dimens.spacing_extra_large,
            icon: const Icon(CupertinoIcons.chevron_left),
            onPressed: widget.onPressedIcon ??
                () {
                  if (Navigator.of(context).canPop()) {
                    context.pop();
                  }
                },
            tooltip: MaterialLocalizations.of(context).backButtonTooltip,
          );
        },
      );
    } else {
      return null;
    }
  }
}
