import 'package:mydrivenepal/shared/shared.dart';
import 'package:mydrivenepal/shared/theme/app_colors_theme_extension.dart';
import 'package:mydrivenepal/shared/theme/app_text_theme.dart';
import 'package:mydrivenepal/widget/button/variants/rounded_filled_button_widget.dart';
import 'package:mydrivenepal/widget/image/image_widget.dart';
import 'package:mydrivenepal/widget/scaffold/scaffold.dart';
import 'package:mydrivenepal/widget/text/text_widget.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../di/service_locator.dart';
import 'onboarding_viewmodel.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  final OnBoardingViewModel _onBoardingViewModel =
      locator<OnBoardingViewModel>();
  int _currentPageIndex = 0;
  final PageController _pageController = PageController();

  final List<Map<String, dynamic>> _onboardingPages = [
    {
      'image': ImageConstants.IC_BANNER,
      'title': 'My drive Nepal',
      'subtitle': 'Your trusted partner in rides',
    },
    // {
    //   'image': ImageConstants.IC_CHECKUP,
    //   'title': 'Second Screen Title',
    //   'subtitle': 'Second screen description text goes here',
    // },
    // {
    //   'image': ImageConstants.IC_CHECKUP,
    //   'title': 'Third Screen Title',
    //   'subtitle': 'Third screen description text goes here',
    // },
  ];

  void _onPageChanged(int index) {
    setState(() {
      _currentPageIndex = index;
    });
  }

  void _nextPage(OnBoardingViewModel onBoardingViewModel) {
    if (_currentPageIndex < _onboardingPages.length - 1) {
      _pageController.nextPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      onBoardingViewModel.onBoard();
      context.goNamed(AppRoute.login.name);
    }
  }

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;

    final currentPage = _onboardingPages[_currentPageIndex];

    return ChangeNotifierProvider<OnBoardingViewModel>(
      create: (_) => _onBoardingViewModel,
      child: Consumer<OnBoardingViewModel>(
        builder: (context, onBoardingViewModel, child) {
          return ScaffoldWidget(
            padding: 0,
            top: 0,
            bottom: 0,
            showAppbar: false,
            useSafeArea: false,
            child: Stack(
              children: [
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Stack(
                    children: [
                      SizedBox(
                        height: 0.57.sh,
                        width: double.infinity,
                        child: PageView(
                          controller: _pageController,
                          onPageChanged: _onPageChanged,
                          children: _onboardingPages
                              .map((page) => ImageWidget(
                                    imagePath: ImageConstants.IC_BANNER1,
                                    fit: BoxFit.fitWidth,
                                  ))
                              .toList(),
                        ),
                      ),
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                appColors.bgSecondaryMain
                                    .withValues(alpha: 0.9),
                                AppColors.transparent,
                                AppColors.transparent,
                              ],
                              stops: [0.0, 0.7, 1.0],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 0.57.sh + 30,
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(16.r),
                        topRight: Radius.circular(16.r),
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(16.w),
                      child: Column(
                        children: [
                          SizedBox(height: 16.h),
                          TextWidget(
                            text: currentPage['title'],
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .pageTitle
                                .copyWith(color: appColors.textInverse),
                          ),
                          SizedBox(height: 16.h),
                          TextWidget(
                            text: currentPage['subtitle'],
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .bodyText
                                .copyWith(color: appColors.textSubtle),
                          ),
                          SizedBox(height: 35.h),
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.center,
                          //   children: List.generate(
                          //     _onboardingPages.length,
                          //     (index) => AnimatedContainer(
                          //       duration: Duration(milliseconds: 300),
                          //       margin: EdgeInsets.symmetric(horizontal: 4.w),
                          //       height: 5.h,
                          //       width: 20.w,
                          //       decoration: BoxDecoration(
                          //         borderRadius: BorderRadius.circular(4.r),
                          //         color: _currentPageIndex == index
                          //             ? AppColors.primary_main
                          //             : AppColors.primary_lighter,
                          //       ),
                          //     ),
                          //   ),
                          // ),
                          // SizedBox(height: 35.h),
                          RoundedFilledButtonWidget(
                            context: context,
                            label:
                                _currentPageIndex == _onboardingPages.length - 1
                                    ? 'Get Started'
                                    : 'Next',
                            onPressed: () => _nextPage(onBoardingViewModel),
                          ),
                          SizedBox(height: 35.h),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
