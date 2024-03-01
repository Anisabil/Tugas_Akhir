import 'package:get_storage/get_storage.dart';

class FVLocalStorage {
  static final FVLocalStorage _instance = FVLocalStorage._internal();

  factory FVLocalStorage() {
    return _instance;
  }

  FVLocalStorage._internal();

  final _storage = GetStorage();
}
