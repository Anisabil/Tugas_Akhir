import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fvapp/admin/models/promo_model.dart';

class PromoService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final String _collectionName = 'promos';

  Future<void> addImage(PromoImage image) async {
    try {
      await _db.collection(_collectionName).add(image.toMap());
    } catch (e) {
      print('Error adding image: $e');
      rethrow;
    }
  }

  Stream<List<PromoImage>> getImages() {
    return _db.collection(_collectionName).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return PromoImage.fromFirestore(doc);
      }).toList();
    });
  }

  Future<void> deleteImage(String id) async {
    try {
      await _db.collection(_collectionName).doc(id).delete();
    } catch (e) {
      print('Error deleting image: $e');
      rethrow;
    }
  }

  Future<void> updateImage(PromoImage image) async {
    try {
      await _db.collection(_collectionName).doc(image.id).update(image.toMap());
    } catch (e) {
      print('Error updating image: $e');
      rethrow;
    }
  }
}