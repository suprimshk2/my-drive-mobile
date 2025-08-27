import 'package:flutter/material.dart';
import 'package:mydrivenepal/shared/constant/message/error_messages.dart';
import 'package:mydrivenepal/shared/util/response.dart';
import 'package:mydrivenepal/widget/error_states/connection_error_widget.dart';
import 'package:mydrivenepal/widget/error_states/generic_error_widget.dart';

class ResponseBuilder<ResultType> extends StatelessWidget {
  final Response<ResultType> response;
  final Widget Function()? onLoading;
  final Widget Function(String error)? onError;
  final Widget Function(ResultType data) onData;
  final VoidCallback? onRetry;

  const ResponseBuilder({
    super.key,
    required this.response,
    required this.onData,
    this.onLoading,
    this.onError,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    if (response.isLoading) {
      return onLoading?.call() ??
          const Center(child: CircularProgressIndicator());
    }

    if (response.hasError) {
      return _buildErrorState();
    }

    if (response.hasData) {
      return onData(response.data! as ResultType);
    }

    return SizedBox.shrink();
  }

  Widget _buildErrorState() {
    final errorMessage = response.exception ?? ErrorMessages.defaultError;

    bool isNetworkError = (errorMessage == ErrorMessages.noConnection);

    if (isNetworkError) {
      return ConnectionErrorWidget(
        onRetry: () {
          onRetry?.call();
        },
      );
    } else {
      if (onError != null) {
        return onError!(errorMessage);
      }

      return GenericErrorWidget(
        customMessage: errorMessage,
        onPressed: () {
          onRetry?.call();
        },
      );
    }
  }
}
