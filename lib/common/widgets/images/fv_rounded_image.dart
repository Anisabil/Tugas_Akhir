import 'package:flutter/material.dart';

import '../../../utils/constants/sizes.dart';

class FVRoundedImage extends StatelessWidget {
  const FVRoundedImage({
    Key? key,
    this.width,
    this.height,
    required this.imageUrl,
    this.applyImageRadius = true,
    this.border,
    this.backgroundColor,
    this.fit = BoxFit.contain,
    this.padding,
    this.isNetworkImage = false,
    this.onPressed,
    this.borderRadius = FVSizes.md,
  }) : super(key: key);

  final double? width, height;
  final String imageUrl;
  final bool applyImageRadius;
  final BoxBorder? border;
  final Color? backgroundColor;
  final BoxFit fit;
  final EdgeInsetsGeometry? padding;
  final bool isNetworkImage;
  final VoidCallback? onPressed;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: width,
        height: height,
        padding: padding,
        decoration: BoxDecoration(
          border: border,
          color: backgroundColor,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(
              applyImageRadius ? borderRadius : 0.0),
          child: isNetworkImage
              ? Image.network(
                  imageUrl,
                  width: width,
                  height: height,
                  fit: fit,
                )
              : Image.asset(
                  imageUrl,
                  width: width,
                  height: height,
                  fit: fit,
                ),
        ),
      ),
    );
  }
}
