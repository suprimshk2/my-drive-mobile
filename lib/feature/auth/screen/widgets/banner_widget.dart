import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mydrivenepal/shared/theme/app_colors_theme_extension.dart';

import 'package:mydrivenepal/shared/theme/app_text_theme.dart';
import 'package:mydrivenepal/shared/util/colors.dart';
import 'package:mydrivenepal/shared/util/dimens.dart';
import 'package:mydrivenepal/widget/text/text_widget.dart';

class BannerWidget extends StatefulWidget {
  final List<({String title, String description})> banners;
  final Duration autoScrollInterval;

  const BannerWidget({
    super.key,
    required this.banners,
    this.autoScrollInterval = const Duration(seconds: 5),
  });

  @override
  State<BannerWidget> createState() => _BannerWidgetState();
}

class _BannerWidgetState extends State<BannerWidget> {
  PageController _pageController = PageController();
  Timer? _autoScrollTimer;
  int _currentPage = 1; // Start from first "real" banner

  List<({String title, String description})> get _loopedBanners {
    // Add last item to start and first item to end
    return [
      widget.banners.last,
      ...widget.banners,
      widget.banners.first,
    ];
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentPage);

    if (widget.banners.length > 1) {
      _startAutoScroll();
    }
  }

  @override
  void dispose() {
    if (widget.banners.length > 1) {
      _autoScrollTimer?.cancel();
    }
    _pageController.dispose();
    super.dispose();
  }

  void _startAutoScroll() {
    if (widget.banners.length <= 1) return;

    _autoScrollTimer = Timer.periodic(widget.autoScrollInterval, (timer) {
      if (_pageController.hasClients) {
        _currentPage++;
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 1000),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  void _handlePageChanged(int page) {
    setState(() {
      _currentPage = page;
    });

    if (widget.banners.length > 1) {
      // Looping logic
      if (page == _loopedBanners.length - 1) {
        Future.delayed(const Duration(milliseconds: 300), () {
          _pageController.jumpToPage(1);
          _currentPage = 1;
        });
      } else if (page == 0) {
        Future.delayed(const Duration(milliseconds: 300), () {
          _pageController.jumpToPage(_loopedBanners.length - 2);
          _currentPage = _loopedBanners.length - 2;
        });
      }

      _autoScrollTimer?.cancel();

      _startAutoScroll();
    }
  }

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(Dimens.spacing_large),
      decoration: BoxDecoration(
        color: appColors.bgSecondaryMain,
        borderRadius: BorderRadius.circular(Dimens.radius_default),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AspectRatio(
            aspectRatio: 4,
            child: PageView.builder(
              controller: _pageController,
              itemCount: widget.banners.length > 1 ? _loopedBanners.length : 1,
              scrollDirection: Axis.horizontal,
              onPageChanged: _handlePageChanged,
              itemBuilder: (context, index) {
                final banner = widget.banners.length > 1
                    ? _loopedBanners[index]
                    : widget.banners[0];
                return _buildBannerContent(banner.title, banner.description);
              },
            ),
          ),
          SizedBox(height: Dimens.spacing_large),
          if (widget.banners.length > 1) ...[
            _buildPageIndicator(),
          ],
        ],
      ),
    );
  }

  _buildBannerContent(String title, String desc) {
    final appColors = context.appColors;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextWidget(
            text: title,
            textAlign: TextAlign.left,
            style: Theme.of(context).textTheme.bodyText.copyWith(
                  fontWeight: FontWeight.w700,
                  color: appColors.textOnSurface,
                ),
          ),
          SizedBox(height: Dimens.spacing_4),
          TextWidget(
            textAlign: TextAlign.left,
            text: desc,
            style: Theme.of(context).textTheme.bodyText.copyWith(
                  color: appColors.textOnSurface,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildPageIndicator() {
    final appColors = context.appColors;

    final realPage = (_currentPage - 1) % widget.banners.length;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(widget.banners.length, (int index) {
        return Container(
          width: Dimens.spacing_8,
          height: Dimens.spacing_8,
          margin: const EdgeInsets.symmetric(horizontal: Dimens.spacing_4),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: index == realPage
                ? appColors.bgGrayBold
                : appColors.gray.subtle.withOpacity(0.5),
          ),
        );
      }),
    );
  }
}
