import 'package:flutter/material.dart';
import 'package:mydrivenepal/shared/constant/image_constants.dart';
import 'package:mydrivenepal/widget/error_states/error_state_widget.dart';

class ConnectionErrorWidget extends StatelessWidget {
  final VoidCallback onRetry;
  final String? customMessage;

  const ConnectionErrorWidget({
    super.key,
    required this.onRetry,
    this.customMessage,
  });

  @override
  Widget build(BuildContext context) {
    return ErrorStateWidget(
      iconPath: ImageConstants.IC_WIFI_OFF,
      title: 'No Internet Connection',
      desc: customMessage ?? 'Please check your Internet connection.',
      buttonTxt: 'Try Again',
      onPressed: onRetry,
    );
  }
}
