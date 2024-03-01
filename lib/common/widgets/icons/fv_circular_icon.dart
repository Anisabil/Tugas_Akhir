import 'package:flutter/material.dart';
import 'package:fvapp/utils/helpers/helper_function.dart';

import '../../../utils/constants/colors.dart';
import '../../../utils/constants/sizes.dart';

class FVCircularIcon extends StatelessWidget {
  const FVCircularIcon({
    super.key,
    this.width, this.height, this.size = FVSizes.lg, required this.icon, this.color, this.backgroundColor, this.onPressed,
  });

  final double? width, height, size;
  final IconData icon;
  final Color? color;
  final Color? backgroundColor;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: backgroundColor != null
            ? backgroundColor!
            : FVHelperFunctions.isDarkMode(context)
                ? FVColors.black.withOpacity(0.9)
                : FVColors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(100),
      ),
      child: IconButton(
          onPressed: onPressed,
          icon: Icon(
            icon,
            color: color,
            size: size,
            ),
          ),
    );
  }
}
