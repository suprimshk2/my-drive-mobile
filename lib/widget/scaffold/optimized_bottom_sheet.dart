import 'package:flutter/material.dart';
import 'package:mydrivenepal/shared/shared.dart';
import 'package:mydrivenepal/shared/theme/app_colors_theme_extension.dart';
import 'package:mydrivenepal/widget/widget.dart';

class OptimizedBottomSheet extends StatelessWidget {
  final String? title;
  final Widget? header;
  final Widget content;
  final Widget? footer;
  final bool showDragHandle;
  final bool isDismissible;
  final bool isScrollControlled;
  final double? maxHeight;
  final double? minHeight;
  final EdgeInsets? padding;
  final VoidCallback? onClose;
  final Color? backgroundColor;
  final BorderRadius? borderRadius;

  const OptimizedBottomSheet({
    Key? key,
    this.title,
    this.header,
    required this.content,
    this.footer,
    this.showDragHandle = true,
    this.isDismissible = true,
    this.isScrollControlled = true,
    this.maxHeight,
    this.minHeight,
    this.padding,
    this.onClose,
    this.backgroundColor,
    this.borderRadius,
  }) : super(key: key);

  static Future<T?> show<T>({
    required BuildContext context,
    required Widget content,
    String? title,
    Widget? header,
    Widget? footer,
    bool showDragHandle = true,
    bool isDismissible = true,
    bool isScrollControlled = true,
    double? maxHeight,
    double? minHeight,
    EdgeInsets? padding,
    VoidCallback? onClose,
    Color? backgroundColor,
    BorderRadius? borderRadius,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isDismissible: isDismissible,
      isScrollControlled: isScrollControlled,
      backgroundColor: Colors.transparent,
      constraints: BoxConstraints(
        maxHeight: maxHeight ?? MediaQuery.of(context).size.height * 0.9,
        minHeight: minHeight ?? 200,
      ),
      builder: (context) => OptimizedBottomSheet(
        title: title,
        header: header,
        content: content,
        footer: footer,
        showDragHandle: showDragHandle,
        isDismissible: isDismissible,
        isScrollControlled: isScrollControlled,
        maxHeight: maxHeight,
        minHeight: minHeight,
        padding: padding,
        onClose: onClose,
        backgroundColor: backgroundColor,
        borderRadius: borderRadius,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;
    final defaultBorderRadius = BorderRadius.vertical(
      top: Radius.circular(Dimens.radius_medium),
    );

    return Container(
      decoration: BoxDecoration(
        color: backgroundColor ?? Theme.of(context).scaffoldBackgroundColor,
        borderRadius: borderRadius ?? defaultBorderRadius,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag Handle
          if (showDragHandle) _buildDragHandle(),

          // Header
          if (header != null || title != null) _buildHeader(context, appColors),

          // Content
          Flexible(
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: padding ?? const EdgeInsets.all(Dimens.spacing_large),
              child: content,
            ),
          ),

          // Footer
          if (footer != null) _buildFooter(),
        ],
      ),
    );
  }

  Widget _buildDragHandle() {
    return Container(
      margin: const EdgeInsets.only(top: Dimens.spacing_8),
      width: 40,
      height: 4,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, AppColorExtension appColors) {
    return Container(
      color: appColors.bgGraySoft,
      padding: const EdgeInsets.all(Dimens.spacing_large),
      child: Row(
        children: [
          if (title != null)
            Expanded(
              child: TextWidget(
                text: title!,
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(color: appColors.textInverse),
              ),
            ),
          if (header != null) Expanded(child: header!),
          const Spacer(),
          IconButton(
            icon: Icon(
              Icons.close,
              color: appColors.textInverse,
              size: Dimens.text_size_24,
            ),
            onPressed: onClose ?? () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.all(Dimens.spacing_large),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(
            color: Colors.grey[200]!,
            width: 1,
          ),
        ),
      ),
      child: footer!,
    );
  }
}

// Specialized bottom sheet for ride details
class RideDetailsBottomSheet extends StatelessWidget {
  final String distance;
  final String duration;
  final double estimatedFare;
  final bool canBookRide;
  final bool isLoading;
  final VoidCallback? onBookRide;
  final VoidCallback? onClose;

  const RideDetailsBottomSheet({
    Key? key,
    required this.distance,
    required this.duration,
    required this.estimatedFare,
    required this.canBookRide,
    this.isLoading = false,
    this.onBookRide,
    this.onClose,
  }) : super(key: key);

  static Future<T?> show<T>({
    required BuildContext context,
    required String distance,
    required String duration,
    required double estimatedFare,
    required bool canBookRide,
    bool isLoading = false,
    VoidCallback? onBookRide,
    VoidCallback? onClose,
  }) {
    return OptimizedBottomSheet.show<T>(
      context: context,
      maxHeight: 200,
      minHeight: 150,
      isScrollControlled: false,
      content: RideDetailsBottomSheet(
        distance: distance,
        duration: duration,
        estimatedFare: estimatedFare,
        canBookRide: canBookRide,
        isLoading: isLoading,
        onBookRide: onBookRide,
        onClose: onClose,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextWidget(
                    text: 'Distance: $distance',
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(fontSize: Dimens.text_size_14),
                  ),
                  const SizedBox(height: Dimens.spacing_4),
                  TextWidget(
                    text: 'Duration: $duration',
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(fontSize: Dimens.text_size_14),
                  ),
                  const SizedBox(height: Dimens.spacing_4),
                  TextWidget(
                    text:
                        'Estimated Fare: NPR ${estimatedFare.toStringAsFixed(0)}',
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: Dimens.text_size_16,
                          color: Colors.green[700],
                        ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: Dimens.spacing_large),
            SizedBox(
              height: 48,
              child: RoundedFilledButtonWidget(
                context: context,
                label: 'Book a ride',
                // label: isLoading ? '' : 'Book Ride',
                // enabled: canBookRide && !isLoading,
                // isLoading: isLoading,
                onPressed: canBookRide ? onBookRide : null,
                backgroundColor: Colors.black,
                textColor: Colors.white,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// Specialized bottom sheet for location options
class LocationOptionsBottomSheet extends StatelessWidget {
  final VoidCallback? onSaveLocation;
  final VoidCallback? onShare;
  final VoidCallback? onRemove;
  final VoidCallback? onClose;

  const LocationOptionsBottomSheet({
    Key? key,
    this.onSaveLocation,
    this.onShare,
    this.onRemove,
    this.onClose,
  }) : super(key: key);

  static Future<T?> show<T>({
    required BuildContext context,
    VoidCallback? onSaveLocation,
    VoidCallback? onShare,
    VoidCallback? onRemove,
    VoidCallback? onClose,
  }) {
    return OptimizedBottomSheet.show<T>(
      context: context,
      maxHeight: 300,
      minHeight: 200,
      isScrollControlled: false,
      content: LocationOptionsBottomSheet(
        onSaveLocation: onSaveLocation,
        onShare: onShare,
        onRemove: onRemove,
        onClose: onClose,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          leading: const Icon(Icons.bookmark_border),
          title: const Text('Save Location'),
          onTap: () {
            Navigator.pop(context);
            onSaveLocation?.call();
          },
        ),
        ListTile(
          leading: const Icon(Icons.share),
          title: const Text('Share'),
          onTap: () {
            Navigator.pop(context);
            onShare?.call();
          },
        ),
        ListTile(
          leading: Icon(
            Icons.delete_outline,
            color: appColors.primary.main,
          ),
          title: Text(
            'Remove from Recent',
            style: TextStyle(color: appColors.primary.main),
          ),
          onTap: () {
            Navigator.pop(context);
            onRemove?.call();
          },
        ),
      ],
    );
  }
}
