import 'package:flutter/material.dart';
import 'package:mydrivenepal/shared/util/util.dart';

showLoader(BuildContext context) {
  return showDialog<String>(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) => AlertDialog(
      content: Row(
        children: [
          const SizedBox(
            height: Dimens.spacing_30,
            width: Dimens.spacing_30,
            child: CircularProgressIndicator.adaptive(),
          ),
          const SizedBox(
            width: Dimens.spacing_8,
          ),
          Text(
            'Requesting...',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    ),
  );
}
