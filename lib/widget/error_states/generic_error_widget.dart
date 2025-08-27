import 'package:flutter/material.dart';
import 'package:mydrivenepal/shared/constant/image_constants.dart';
import 'package:mydrivenepal/widget/error_states/error_state_widget.dart';

class GenericErrorWidget extends StatelessWidget {
  final VoidCallback onPressed;
  final String? customTitle;
  final String? customMessage;
  final String? buttonTxt;
  const GenericErrorWidget({
    super.key,
    required this.onPressed,
    this.customTitle,
    this.customMessage,
    this.buttonTxt,
  });

  @override
  Widget build(BuildContext context) {
    return ErrorStateWidget(
      iconPath: ImageConstants.IC_WARNING,
      title: customTitle ?? 'Something Went Wrong',
      desc: customMessage ??
          'An unknown error occurred. Please try again after a while.',
      buttonTxt: buttonTxt ?? 'Retry',
      onPressed: onPressed,
    );
  }
}
