import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mydrivenepal/shared/theme/app_colors_theme_extension.dart';
import 'package:mydrivenepal/shared/theme/app_text_theme.dart';
import 'package:mydrivenepal/shared/util/util.dart';
import 'package:mydrivenepal/widget/button/button.dart';
import '../../shared/enum/dialogType.dart';

class AlertDialogWidget extends StatelessWidget {
  const AlertDialogWidget({
    Key? key,
    this.heading = '',
    required this.title,
    required this.description,
    this.firstButtonOnPressed,
    this.firstButtonLabel = 'Keep Editing',
    this.secondButtonLabel = 'Discard',
    this.twoButton = true,
    this.firstButtonIsLoading = false,
    this.secondButtonOnPressed,
    this.dialogType = DialogType.alert,
  }) : super(key: key);

  final String heading;
  final String title;
  final String description;
  final dynamic firstButtonOnPressed;
  final VoidCallback? secondButtonOnPressed;
  final String firstButtonLabel;
  final String secondButtonLabel;
  final bool twoButton;
  final bool firstButtonIsLoading;
  final DialogType dialogType;

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;

    defaultAction() {
      context.pop();
    }

    return AlertDialog(
      content: Text(
        description,
        style: Theme.of(context)
            .textTheme
            .bodyText
            .copyWith(color: appColors.textSubtle),
        textAlign: TextAlign.center,
      ),
      contentPadding: const EdgeInsets.only(
        left: Dimens.spacing_large,
        right: Dimens.spacing_large,
        bottom: Dimens.spacing_32,
        top: Dimens.spacing_large,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(Dimens.radius_medium),
        ),
      ),
      title: Center(
        child: Column(
          children: [
            if (heading.isNotEmpty) ...[
              const SizedBox(height: Dimens.spacing_8),
              Text(
                heading,
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall!
                    .copyWith(color: appColors.textInverse),
                textAlign: TextAlign.center,
              ),
            ],
            Text(
              title,
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall!
                  .copyWith(color: appColors.textInverse),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
      actionsPadding: const EdgeInsets.only(
        left: Dimens.spacing_large,
        right: Dimens.spacing_large,
        bottom: Dimens.spacing_large,
      ),
      actionsAlignment:
          twoButton ? MainAxisAlignment.spaceAround : MainAxisAlignment.center,
      actions: [
        Row(
          children: [
            if (twoButton)
              Expanded(
                flex: 1,
                child: RoundedOutlinedButtonWidget(
                  padding: const EdgeInsets.all(Dimens.spacing_8),
                  label: secondButtonLabel,
                  onPressed: secondButtonOnPressed ?? defaultAction,
                ),
              ),
            const SizedBox(width: Dimens.spacing_8),
            Expanded(
              flex: 1,
              child: ButtonWidget(
                isLoading: firstButtonIsLoading,
                padding: const EdgeInsets.all(Dimens.spacing_8),
                borderRadius: BorderRadius.circular(Dimens.radius_large),
                label: firstButtonLabel,
                onPressed: firstButtonOnPressed ?? defaultAction,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
