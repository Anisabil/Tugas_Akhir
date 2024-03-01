import 'package:flutter/material.dart';
import 'package:fvapp/utils/constants/colors.dart';

class FVShadowStyle {
  static final verticalProductShadow = BoxShadow(
    color: FVColors.darkGrey.withOpacity(0.1),
    blurRadius: 50,
    spreadRadius: 7,
    offset: const Offset(0, 2),
  );

  static final horizontalProductShadow = BoxShadow(
    color: FVColors.darkGrey.withOpacity(0.1),
    blurRadius: 50,
    spreadRadius: 7,
    offset: const Offset(0, 2),
  );
}
