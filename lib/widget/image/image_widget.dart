import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mydrivenepal/shared/shared.dart';

class ImageWidget extends StatelessWidget {
  final String imagePath;
  final double? width;
  final double? height;
  final bool isSvg;
  final Color? color;
  final BoxFit? fit;
  final Widget Function(BuildContext, String)? progressIndicator;

  const ImageWidget({
    super.key,
    required this.imagePath,
    this.width = 100,
    this.height = 100,
    this.isSvg = false,
    this.color,
    this.fit,
    this.progressIndicator,
  });

  @override
  Widget build(BuildContext context) {
    final String imageType = getImageType(imagePath);
    if (imageType.toString() == ImageType.REMOTE.toString()) {
      return CachedNetworkImage(
        placeholder: progressIndicator,
        imageUrl: imagePath,
        width: width,
        height: height,
        fit: fit ?? BoxFit.cover,
        color: color,
      );
    }
    if (imageType.toString() == ImageType.ASSET.toString()) {
      if (isSvg) {
        return SvgPicture.asset(
          imagePath,
          width: width,
          height: height,
          fit: fit ?? BoxFit.cover,
          colorFilter:
              color != null ? ColorFilter.mode(color!, BlendMode.srcIn) : null,
        );
      }
      return Image.asset(
        imagePath,
        width: width,
        height: height,
        fit: BoxFit.cover,
        color: color,
      );
    }
    return Image.file(
      File(imagePath),
      width: width,
      height: height,
      fit: BoxFit.cover,
      color: color,
    );
  }
}
