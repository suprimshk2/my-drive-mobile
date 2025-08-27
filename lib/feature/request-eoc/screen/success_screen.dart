import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mydrivenepal/feature/auth/constants/constants.dart';
import 'package:mydrivenepal/shared/util/dimens.dart';
import 'package:mydrivenepal/widget/widget.dart';
import '../../../shared/constant/route_names.dart';
import '../../../widget/succes_widget.dart';
import '../constant/constant.dart';

class SuccessScreen extends StatelessWidget {
  final bool isPasswordSet;
  final bool isPasswordChanged;
  final bool isRequestEOC;

  const SuccessScreen({
    super.key,
    this.isPasswordSet = false,
    this.isPasswordChanged = false,
    this.isRequestEOC = false,
  });

  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      padding: 0,
      top: 0,
      bottom: 0,
      showAppbar: false,
      useSafeArea: false,
      child: Padding(
        padding: const EdgeInsets.all(Dimens.spacing_large),
        child: _buildSuccessWidget(context),
      ),
    );
  }

  Widget _buildSuccessWidget(BuildContext context) {
    if (isPasswordChanged) {
      return SuccessWidget(
        title: AuthStrings.passwordChangedSuccessTitle,
        description: AuthStrings.passwordChangedSuccessDescription,
        buttonLabel: AuthStrings.login,
        onPressed: () {
          context.goNamed(AppRoute.login.name);
        },
      );
    } else if (isPasswordSet) {
      return SuccessWidget(
        title: AuthStrings.passwordSetSuccessTitle,
        description: AuthStrings.passwordSetSuccessDescription,
        buttonLabel: AuthStrings.login,
        onPressed: () {
          context.goNamed(AppRoute.login.name);
        },
      );
    } else if (isRequestEOC) {
      return SuccessWidget(
        title: RequestEocConstant.successTitle,
        description: RequestEocConstant.successDescription,
        buttonLabel: RequestEocConstant.goBackHome,
        onPressed: () {
          context.goNamed(AppRoute.login.name);
        },
      );
    } else {
      return SizedBox();
    }
  }
}
