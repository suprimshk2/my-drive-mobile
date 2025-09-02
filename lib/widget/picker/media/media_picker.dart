import 'package:flutter/material.dart';
import 'package:mydrivenepal/di/service_locator.dart';
import 'package:mydrivenepal/feature/rider-registration/viewmodel/rider_registration_viewmodel.dart';
import 'package:mydrivenepal/shared/util/custom_functions.dart';
import 'package:mydrivenepal/shared/util/dimens.dart';
import 'package:mydrivenepal/widget/alert/show_dialog.dart';
import 'package:provider/provider.dart';

class MediaPickerWidget extends StatelessWidget {
  const MediaPickerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final RiderRegistrationViewModel viewModel =
        locator<RiderRegistrationViewModel>();
    return Column(
      children: [
        Align(
          alignment: Alignment.topRight,
          child: InkWell(
            onTap: () => {Navigator.of(context).pop()},
            child: const Icon(Icons.close),
          ),
        ),
        InkWell(
          onTap: () => onPressCamera(context, viewModel),
          child: const Row(
            children: [
              Icon(Icons.camera),
              SizedBox(width: Dimens.spacing_8),
              Text(
                'Upload with camera',
              )
            ],
          ),
        ),
        const SizedBox(height: Dimens.spacing_12),
        InkWell(
          onTap: () => onPressAlbum(context, viewModel),
          child: const Row(
            children: [
              Icon(Icons.photo),
              SizedBox(width: Dimens.spacing_8),
              Text(
                'Upload from gallery',
              )
            ],
          ),
        )
      ],
    );
  }

  onPressAlbum(
      BuildContext context, RiderRegistrationViewModel viewModel) async {
    try {
      final String? image = await pickImageFromAlbum();
      if (image != null) {
        Future.delayed(
          Duration.zero,
          () {
            showLoader(context);
          },
        );
        // upload to server
        // final UserProfileModel profileData =
        //     await viewModel.uploadProfilePicture(image);
        Future.delayed(
          Duration.zero,
          () async {
            Future.delayed(Duration.zero, () {
              popUntil(context, 2);
            });
          },
        );
      } else {
        if (!context.mounted) return;
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (!context.mounted) return;
      Navigator.of(context).pop();
    }
  }

  onPressCamera(
      BuildContext context, RiderRegistrationViewModel viewModel) async {
    try {
      final String? image = await pickImage();
      if (image != null) {
        Future.delayed(
          Duration.zero,
          () {
            showLoader(context);
          },
        );
        // upload to server
        // final UserProfileModel profileData =
        //     await viewModel.uploadProfilePicture(image);
        Future.delayed(
          Duration.zero,
          () async {
            Future.delayed(Duration.zero, () {
              popUntil(context, 2);
            });
          },
        );
      } else {
        if (!context.mounted) return;
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (!context.mounted) return;
      Navigator.of(context).pop();
    }
  }
}
