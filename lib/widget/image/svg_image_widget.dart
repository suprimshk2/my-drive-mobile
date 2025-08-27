import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SVGPictureWidget extends StatelessWidget {
  final String image;
  final double width;
  final double height;
  final bool adapt;
  final BoxFit? boxFit;
  final Color? color;
  const SVGPictureWidget({
    super.key,
    required this.image,
    this.width = 200,
    this.height = 200,
    this.adapt = false,
    this.boxFit,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      image,
      colorFilter: color != null
          ? ColorFilter.mode(color!, BlendMode.srcIn)
          : null,
      alignment: Alignment.center,
      width: width,
      height: height,
      fit: boxFit ?? BoxFit.contain,
    );
  }
}
