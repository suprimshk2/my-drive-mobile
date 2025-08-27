import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mydrivenepal/feature/landing/constants/landing_constants.dart';
import 'package:mydrivenepal/shared/shared.dart';
import 'package:mydrivenepal/shared/theme/app_colors_theme_extension.dart';
import 'package:mydrivenepal/shared/theme/app_text_theme.dart';
import 'package:mydrivenepal/widget/image/image_widget.dart';
import 'package:mydrivenepal/widget/scaffold/bottom_bar_viewmodel.dart';
import 'package:mydrivenepal/widget/text/text_widget.dart';
import 'package:provider/provider.dart';

class BottomNavBar extends StatelessWidget {
  final List<NavItem> navItems;

  const BottomNavBar({
    super.key,
    required this.navItems,
  });

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      height: 70.h,
      elevation: 10,
      shape: CircularNotchedRectangle(),
      notchMargin: 5,
      padding: EdgeInsets.symmetric(vertical: 0),
      child: CustomNavBar(navItems: navItems),
    );
  }
}

class CustomNavBar extends StatelessWidget {
  final List<NavItem> navItems;

  const CustomNavBar({super.key, required this.navItems});

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;

    return Consumer<BottomBarViewModel>(
      builder: (context, viewModel, _) {
        int currentIndex = viewModel.pageIndex;

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: Dimens.spacing_extra_small),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(navItems.length, (index) {
              bool isSelected = currentIndex == index;

              if ((navItems.length >> 1) == index) {
                return SizedBox(width: 50.w);
              }

              return GestureDetector(
                onTap: () {
                  viewModel.setPageIndex(index);
                },
                child: Material(
                  color: AppColors.transparent,
                  child: Padding(
                    padding: const EdgeInsets.all(Dimens.spacing_8),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ImageWidget(
                          width: Dimens.spacing_extra_large,
                          height: Dimens.spacing_extra_large,
                          imagePath: isSelected
                              ? navItems[index].activeIcon
                              : navItems[index].icon,
                          isSvg: true,
                          color: isSelected
                              ? appColors.bgPrimaryMain
                              : appColors.bgGrayBold,
                        ),
                        SizedBox(height: Dimens.spacing_6),
                        TextWidget(
                          text: navItems[index].label,
                          textOverflow: TextOverflow.ellipsis,
                          style: Theme.of(context)
                              .textTheme
                              .bodyTextSmall
                              .copyWith(
                                color: isSelected
                                    ? appColors.textPrimary
                                    : appColors.textInverse,
                              ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
        );
      },
    );
  }
}
