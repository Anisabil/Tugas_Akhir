import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fvapp/features/studio/about/about_app.dart';
import 'package:get/get.dart';

import 'features/personalization/screens/settings/settings.dart';
import 'features/studio/screens/home/home.dart';
import 'features/studio/screens/rent/rent.dart';
import 'features/studio/screens/order/order.dart';
import 'admin/models/package_model.dart';

class NavigationController extends GetxController {
  final Rx<int> selectedIndex = 0.obs;
  final User? user = FirebaseAuth.instance.currentUser;

  final Package defaultPackage = Package(
    id: '1',
    name: 'Paket Default',
    description: 'Ini adalah deskripsi paket default.',
    price: 10.0,
    categoryId: '1',
    imageUrls: ['https://example.com/image1.jpg', 'https://example.com/image2.jpg'], videoUrls: ['https://example.com/video.mkv'], 
    categoryName: 'package',
  );

  late final List<Widget> screens = [
    HomeScreen(package: defaultPackage),
    AboutApp(),
    user != null ? OrderScreen(userId: user!.uid) : Container(), // Tampilkan kontainer kosong jika user null
    const SettingsScreen(),
  ];
}
