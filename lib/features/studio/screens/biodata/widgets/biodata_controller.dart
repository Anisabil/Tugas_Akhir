import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fvapp/features/studio/screens/biodata/widgets/biodata_model.dart';
import 'package:get/get.dart';

class CoupleDataController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Rx<CoupleData?> _coupleData = Rx<CoupleData?>(null);

  Rx<CoupleData?> get coupleData => _coupleData;

  Future<void> saveCoupleData(CoupleData coupleData, String userId, String rentId) async {
    await _firestore.collection('couple_data').add(coupleData.toMap());
  }

  Future<void> updateCoupleData(String coupleDataId, CoupleData coupleData, String userId, String rentId) async {
    await _firestore.collection('couple_data').doc(coupleDataId).update(coupleData.toMap());
  }

  Future<void> loadCoupleData(String coupleDataId) async {
    DocumentSnapshot doc = await _firestore.collection('couple_data').doc(coupleDataId).get();
    if (doc.exists) {
      _coupleData.value = CoupleData.fromMap(doc.data() as Map<String, dynamic>);
    }
  }
}
