import 'package:flutter/material.dart';
import 'package:fvapp/utils/theme/custom_themes/elevated_button_theme.dart';
import 'package:fvapp/utils/theme/custom_themes/text_field_theme.dart';
import 'package:fvapp/utils/theme/custom_themes/text_theme.dart';

import 'custom_themes/outlined_button_theme.dart';

class FVAppTheme {
  FVAppTheme._();

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Poppins',
    brightness: Brightness.light,
    primaryColor: const Color.fromARGB(255, 1, 129, 158),
    scaffoldBackgroundColor: Colors.white,
    textTheme: FVTextTheme.lightTextTheme,
    elevatedButtonTheme: FVElevatedButtonTheme.lightElevatedButtonTheme,
    outlinedButtonTheme: FVOutlinedButtonTheme.lightOutlinedButtonTheme,
    inputDecorationTheme: FVTextFormFieldTheme.lightInputDecorationTheme,
  );
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Poppins',
    brightness: Brightness.dark,
    primaryColor: const Color.fromARGB(255, 1, 129, 158),
    scaffoldBackgroundColor: Colors.black,
    textTheme: FVTextTheme.darkTextTheme,
    elevatedButtonTheme: FVElevatedButtonTheme.darkElevatedButtonTheme,
    outlinedButtonTheme: FVOutlinedButtonTheme.darkOutlinedButtonTheme,
    inputDecorationTheme: FVTextFormFieldTheme.darkInputDecorationTheme,
  );
}
