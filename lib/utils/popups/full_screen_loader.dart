import 'package:flutter/material.dart';
import 'package:fvapp/utils/constants/colors.dart';
import 'package:get/get.dart';

import '../../common/widgets/loaders/animation_loader.dart';
import '../helpers/helper_function.dart';

class FVFullScreenLoader {
  static void openLoadingDialog(String text, String animation) {
    showDialog(
        context: Get.overlayContext!,
        barrierDismissible: false,
        builder: (_) => WillPopScope(
              onWillPop: () async {
                return false;
              },
              child: Container(
                color: FVHelperFunctions.isDarkMode(Get.context!)
                    ? FVColors.dark
                    : FVColors.white,
                width: double.infinity,
                height: double.infinity,
                child: Column(
                  children: [
                    const SizedBox(height: 250),
                    FVAnimationLoaderWidget(text: text, animation: animation),
                  ],
                ),
              ),
            ));
  }

  static stopLoading() {
    Navigator.of(Get.overlayContext!).pop();
  }
}
