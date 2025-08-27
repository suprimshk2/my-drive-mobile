import 'package:flutter/material.dart';
import '../button_widget.dart';

class FilledButtonWidget extends ButtonWidget {
  const FilledButtonWidget({
    Key? key,
    required String label,
    VoidCallback? onPressed,
    bool isLoading = false,
    bool enabled = true,
    Widget? child,
    String? loadingMsg,
  }) : super(
          key: key,
          label: label,
          onPressed: onPressed,
          isLoading: isLoading,
          enabled: enabled,
          child: child,
          loadingMsg: loadingMsg,
        );
}
