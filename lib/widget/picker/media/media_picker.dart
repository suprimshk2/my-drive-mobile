import 'package:flutter/material.dart';
import 'package:mydrivenepal/shared/util/custom_functions.dart';
import 'package:mydrivenepal/shared/util/dimens.dart';
import 'package:mydrivenepal/widget/alert/show_dialog.dart';

enum MediaPickerType {
  profileImage,
  vehiclePhoto,
  licensePhoto,
  citizenshipPhoto,
  documentPhoto,
  nationalIdPhoto,
  vehicleRegistrationNumberPhoto,
  vehicleRegistrationDetailsPhoto,
}

class MediaPickerWidget extends StatelessWidget {
  final MediaPickerType pickerType;
  final Function(String imagePath)? onImageSelected;
  final Function(String imagePath)? onImageUploaded;
  final bool showUploadLoader;
  final String? customTitle;
  final List<String> allowedExtensions;
  final double? maxImageSize; // in MB
  final bool enableCamera;
  final bool enableGallery;

  const MediaPickerWidget({
    super.key,
    required this.pickerType,
    this.onImageSelected,
    this.onImageUploaded,
    this.showUploadLoader = true,
    this.customTitle,
    this.allowedExtensions = const ['jpg', 'jpeg', 'png', 'heic'],
    this.maxImageSize = 5.0, // 5MB default
    this.enableCamera = true,
    this.enableGallery = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Header with close button
        _buildHeader(context),

        // Camera option
        if (enableCamera)
          _buildOption(
            context: context,
            icon: Icons.camera_alt,
            title: 'Upload with camera',
            onTap: () => _handleCameraSelection(context),
          ),

        // Gallery option
        if (enableGallery)
          _buildOption(
            context: context,
            icon: Icons.photo_library,
            title: 'Choose from gallery',
            onTap: () => _handleGallerySelection(context),
          ),

        // Additional options based on picker type
        // if (pickerType == MediaPickerType.documentPhoto)
        //   _buildOption(
        //     context: context,
        //     icon: Icons.file_copy,
        //     title: 'Choose document',
        //     onTap: () => _handleDocumentSelection(context),
        //   ),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Align(
      alignment: Alignment.topRight,
      child: InkWell(
        onTap: () => {Navigator.of(context).pop()},
        child: const Icon(Icons.close, size: 20),
      ),
    );
  }

  Widget _buildOption({
    required BuildContext context,
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          horizontal: Dimens.spacing_large,
          vertical: Dimens.spacing_12,
        ),
        child: Row(
          children: [
            Icon(icon),
            const SizedBox(width: Dimens.spacing_8),
            Text(
              title,
            ),
          ],
        ),
      ),
    );
  }

  String _getDefaultTitle() {
    switch (pickerType) {
      case MediaPickerType.profileImage:
        return 'Profile Photo';
      case MediaPickerType.vehiclePhoto:
        return 'Vehicle Photo';
      case MediaPickerType.licensePhoto:
        return 'License Photo';
      case MediaPickerType.citizenshipPhoto:
        return 'Citizenship Photo';
      case MediaPickerType.documentPhoto:
        return 'Document Photo';
      default:
        return 'Select Media';
    }
  }

  Future<void> _handleCameraSelection(BuildContext context) async {
    try {
      final String? imagePath = await pickImage();
      if (imagePath != null) {
        await _processSelectedImage(context, imagePath);
      } else {
        if (!context.mounted) return;
        Navigator.of(context).pop();
      }
    } catch (e) {
      _handleError(context, e);
    }
  }

  Future<void> _handleGallerySelection(BuildContext context) async {
    try {
      final String? imagePath = await pickImageFromAlbum();
      if (imagePath != null) {
        await _processSelectedImage(context, imagePath);
      } else {
        if (!context.mounted) return;
        Navigator.of(context).pop();
      }
    } catch (e) {
      _handleError(context, e);
    }
  }

  Future<void> _handleDocumentSelection(BuildContext context) async {
    try {
      // Implement document picker logic here
      // You might want to use file_picker package for this
      final String? documentPath = await pickDocument();
      if (documentPath != null) {
        await _processSelectedImage(context, documentPath);
      } else {
        if (!context.mounted) return;
        Navigator.of(context).pop();
      }
    } catch (e) {
      _handleError(context, e);
    }
  }

  Future<void> _processSelectedImage(
      BuildContext context, String imagePath) async {
    // Validate image
    if (!await _validateImage(imagePath)) {
      if (!context.mounted) return;
      _showValidationError(context);
      return;
    }

    // Notify about selection
    onImageSelected?.call(imagePath);

    // Show loader if needed
    // if (showUploadLoader) {
    //   if (!context.mounted) return;
    //   showLoader(context);
    // }

    try {
      // Notify about successful upload
      onImageUploaded?.call(imagePath);

      // Close picker
      if (!context.mounted) return;
      Navigator.of(context).pop();
    } catch (e) {
      if (!context.mounted) return;
      _handleError(context, e);
    }
  }

  Future<bool> _validateImage(String imagePath) async {
    try {
      // Check file extension
      final extension = imagePath.split('.').last.toLowerCase();
      if (!allowedExtensions.contains(extension)) {
        return false;
      }

      // Check file size (you'll need to implement this based on your file handling)
      // final file = File(imagePath);
      // final sizeInMB = await file.length() / (1024 * 1024);
      // if (sizeInMB > (maxImageSize ?? 5.0)) {
      //   return false;
      // }

      return true;
    } catch (e) {
      return false;
    }
  }

  void _showValidationError(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Invalid File'),
        content: Text(
          'Please select a valid image file (${allowedExtensions.join(', ')}) '
          'under ${maxImageSize}MB.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _handleError(BuildContext context, dynamic error) {
    if (!context.mounted) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text('Failed to process image: ${error.toString()}'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  // Placeholder method - implement based on your needs
  Future<String?> pickDocument() async {
    // Implement document picking logic
    return null;
  }
}
