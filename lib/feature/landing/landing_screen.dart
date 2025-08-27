import 'package:mydrivenepal/feature/landing/constants/landing_constants.dart';
import 'package:mydrivenepal/shared/theme/app_colors_theme_extension.dart';
import 'package:mydrivenepal/widget/scaffold/bottom_bar_viewmodel.dart';
import 'package:mydrivenepal/widget/scaffold/bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../shared/shared.dart';
import '../../../../widget/widget.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;

    return Consumer<BottomBarViewModel>(
      builder: (context, bottomBarViewModel, _) {
        return ScaffoldWidget(
          padding: 0,
          showAppbar: false,
          bottomBar: BottomNavBar(navItems: NAV_ITEMS),
          resizeToAvoidBottomInset: false,
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          floatingActionButton: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: appColors.gradients.button,
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
            ),
            child: RawMaterialButton(
              shape: CircleBorder(),
              onPressed: () {
                bottomBarViewModel.setPageIndex(2);
              },
              child: ImageWidget(
                width: Dimens.spacing_over_large,
                height: Dimens.spacing_over_large,
                imagePath: ImageConstants.IC_HOME_FILL,
                isSvg: true,
              ),
            ),
          ),
          child: Column(
            children: [
              Expanded(child: PAGES[bottomBarViewModel.pageIndex]),
            ],
          ),
        );
      },
    );
  }
}
