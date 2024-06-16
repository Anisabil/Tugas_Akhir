import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fvapp/admin/models/package_model.dart';
import 'package:fvapp/features/studio/screens/home/home.dart';
import 'package:fvapp/features/studio/screens/rent/rent.dart';
import 'package:fvapp/features/studio/screens/order/order.dart';
import 'package:fvapp/features/personalization/screens/settings/settings.dart';

class NavigationController extends GetxController {
  final Rx<int> selectedIndex = 0.obs;
  final RxList<Widget> screens = <Widget>[].obs;
  final User? user = FirebaseAuth.instance.currentUser;

  @override
  void onInit() {
    super.onInit();
    _initializeScreens();
  }

  void _initializeScreens() {
    final tempScreens = [
      HomeScreen(package: Package(id: '1', name: '1', description: '1', price: 10, categoryId: '1', imageUrls: ['1', '2'])),
      const RentScreen(),
      if (user != null) OrderScreen(userId: user!.uid),
      const SettingsScreen(),
    ];
    screens.addAll(tempScreens);
  }
}
