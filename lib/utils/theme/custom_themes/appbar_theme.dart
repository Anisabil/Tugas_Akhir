import 'package:flutter/material.dart';
import 'package:fvapp/utils/constants/sizes.dart';

import '../../constants/colors.dart';

class FVAppBarTheme {
  FVAppBarTheme._();

  static const lightAppBarTheme = AppBarTheme(
    elevation: 0,
    centerTitle: false,
    scrolledUnderElevation: 0,
    backgroundColor: Colors.transparent,
    surfaceTintColor: Colors.transparent,
    iconTheme: IconThemeData(color: FVColors.black, size: FVSizes.iconMd),
    actionsIconTheme: IconThemeData(color: FVColors.black, size: FVSizes.iconMd),
    titleTextStyle: TextStyle(
      fontSize: 18.0,
      fontWeight: FontWeight.w600,
      color: FVColors.black,
    ),
  );

  static const darkAppBarTheme = AppBarTheme(
    elevation: 0,
    centerTitle: false,
    scrolledUnderElevation: 0,
    backgroundColor: Colors.transparent,
    surfaceTintColor: Colors.transparent,
    iconTheme: IconThemeData(color: FVColors.black, size: FVSizes.iconMd),
    actionsIconTheme: IconThemeData(color: FVColors.white, size: FVSizes.iconMd),
    titleTextStyle: TextStyle(
      fontSize: 18.0,
      fontWeight: FontWeight.w600,
      color: FVColors.white,
    ),
  );
}
