import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:fvapp/admin/controllers/bank_controller.dart';
import 'package:fvapp/admin/controllers/event_controller.dart';
import 'package:fvapp/admin/controllers/promo_controller.dart';
import 'package:fvapp/admin/controllers/rent_detail_controller.dart';
import 'package:fvapp/admin/service/chat_service.dart';
import 'package:fvapp/features/personalization/controllers/user_controller.dart';
import 'package:fvapp/features/studio/payment/controller/rent_controller.dart';
import 'package:fvapp/features/studio/screens/event/controller/event_controller.dart';
import 'package:fvapp/navigation_controller.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'app.dart';
import 'package:firebase_core/firebase_core.dart';

import 'data/repositories/authentication/authentication_repository.dart';
import 'firebase_options.dart';
import 'admin/controllers/category_controller.dart';
import 'admin/controllers/package_controller.dart';

Future<void> main() async {
  // Widgets Binding
  final WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  // GetX local storage
  await GetStorage.init();

  // Await Native Splash
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  // Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Put Authentication Repository
  Get.put(AuthenticationRepository());

  // Initialize controllers here
  Get.put(UserController());
  Get.put(CategoryController());
  Get.put(PackageController());
  Get.put(EventController());
  Get.put(EventFormController());
  Get.put(NavigationController());
  Get.put(RentController());
  Get.put(RentDetailController());
  Get.put(PromoController());
  Get.put(BankController());
  Get.put(ChatService());

  print('RentController initialized successfully');

  runApp(const App());
}
