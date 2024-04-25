import 'package:flutter/material.dart';
import 'package:fvapp/bindings/general_bindings.dart';
import 'package:fvapp/utils/constants/colors.dart';
import 'package:fvapp/utils/theme/theme.dart';
import 'package:get/get.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      themeMode: ThemeMode.system,
      title: 'FVAPP',
      debugShowCheckedModeBanner: false,
      theme: FVAppTheme.lightTheme,
      darkTheme: FVAppTheme.darkTheme,
      initialBinding: GeneralBindings(),
      home: const Scaffold(
        backgroundColor: FVColors.teal,
        body: Center(
          child: CircularProgressIndicator(
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
