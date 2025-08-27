import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mydrivenepal/shared/theme/app_colors_theme_extension.dart';
import 'package:mydrivenepal/shared/util/colors.dart';
import 'package:mydrivenepal/shared/util/dimens.dart';

class ExpandableTile extends StatefulWidget {
  final Widget header;
  final Widget content;
  final bool initiallyExpanded;
  final Duration animationDuration;
  final EdgeInsetsGeometry padding;
  final Color? backgroundColor;
  final Color? expandedBackgroundColor;
  final BorderRadius? borderRadius;
  final List<BoxShadow>? shadow;
  final EdgeInsetsGeometry? margin;

  const ExpandableTile({
    super.key,
    required this.header,
    required this.content,
    this.initiallyExpanded = false,
    this.animationDuration = const Duration(milliseconds: 200),
    this.padding = const EdgeInsets.all(Dimens.spacing_large),
    this.backgroundColor,
    this.expandedBackgroundColor,
    this.borderRadius,
    this.shadow,
    this.margin,
  });

  @override
  State<ExpandableTile> createState() => _ExpandableTileState();
}

class _ExpandableTileState extends State<ExpandableTile> {
  late bool _isExpanded;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.initiallyExpanded;
  }

  @override
  Widget build(BuildContext context) {
    final backgroundColor = widget.backgroundColor ?? AppColors.white;
    final expandedBackgroundColor =
        widget.expandedBackgroundColor ?? AppColors.white;

    final appColors = context.appColors;

    return AnimatedContainer(
      duration: widget.animationDuration,
      margin: widget.margin,
      decoration: BoxDecoration(
        color: _isExpanded ? expandedBackgroundColor : backgroundColor,
        borderRadius: widget.borderRadius,
        boxShadow: widget.shadow,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          InkWell(
            onTap: () => setState(() => _isExpanded = !_isExpanded),
            child: Padding(
              padding: widget.padding,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      top: Dimens.spacing_2,
                    ),
                    child: Icon(
                      _isExpanded
                          ? CupertinoIcons.chevron_up
                          : CupertinoIcons.chevron_down,
                      color: appColors.gray.bold,
                      size: Dimens.spacing_extra_large,
                    ),
                  ),
                  SizedBox(width: Dimens.spacing_3),
                  Expanded(child: widget.header),
                ],
              ),
            ),
          ),
          AnimatedCrossFade(
            duration: widget.animationDuration,
            firstChild: const SizedBox.shrink(),
            secondChild: Padding(
              padding: EdgeInsets.only(
                bottom: widget.padding.vertical / 2,
              ),
              child: widget.content,
            ),
            crossFadeState: _isExpanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
          ),
        ],
      ),
    );
  }
}
