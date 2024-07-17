import 'package:flutter/material.dart';
import 'package:fvapp/admin/models/promo_model.dart';
import 'package:fvapp/admin/service/promo_service.dart';

class PromoController extends ChangeNotifier {
  final PromoService _promoService = PromoService();
  List<PromoImage> _images = [];

  List<PromoImage> get images => _images;

  Future<void> addImage(PromoImage image) async {
    try {
      await _promoService.addImage(image);
      _images.add(image);
      notifyListeners();
    } catch (e) {
      print('Error adding image: $e');
      rethrow;
    }
  }

  Stream<List<PromoImage>> getImages() {
    return _promoService.getImages();
  }

  Future<void> deleteImage(String id) async {
    try {
      await _promoService.deleteImage(id);
      _images.removeWhere((image) => image.id == id);
      notifyListeners();
    } catch (e) {
      print('Error deleting image: $e');
      rethrow;
    }
  }

  Future<void> updateImage(PromoImage image) async {
    try {
      await _promoService.updateImage(image);
      int index = _images.indexWhere((img) => img.id == image.id);
      if (index != -1) {
        _images[index] = image;
        notifyListeners();
      }
    } catch (e) {
      print('Error updating image: $e');
      rethrow;
    }
  }
}