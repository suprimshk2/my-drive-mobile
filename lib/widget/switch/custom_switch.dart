import 'package:flutter/material.dart';
import 'package:mydrivenepal/shared/theme/app_colors_theme_extension.dart';
import 'package:mydrivenepal/shared/util/colors.dart';

class CustomSwitch extends StatelessWidget {
  final bool value;
  final Color? activeTrackColor;
  final Color? inactiveTrackColor;
  final Color activeThumbColor;
  final Color inactiveThumbColor;
  final Function(bool)? onChanged;

  const CustomSwitch({
    super.key,
    required this.value,
    required this.onChanged,
    this.activeTrackColor,
    this.inactiveTrackColor,
    this.activeThumbColor = AppColors.white,
    this.inactiveThumbColor = AppColors.white,
  });

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;

    final activeTrackColor = this.activeTrackColor ?? appColors.bgPrimaryMain;
    return SizedBox(
      width: 45,
      child: GestureDetector(
        onTap: () => onChanged?.call(!value),
        child: Container(
          width: 45,
          height: 24,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(32),
            // track color
            color: value
                ? activeTrackColor
                : (inactiveTrackColor ?? appColors.gray.main),
          ),
          child: Stack(
            children: [
              AnimatedPositioned(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                left: value ? 20 : 2,
                top: 2,
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    // thumb color
                    color: value ? activeThumbColor : inactiveThumbColor,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.black.withOpacity(0.1),
                        blurRadius: 4,
                        spreadRadius: 0,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
