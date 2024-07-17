import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fvapp/features/studio/screens/biodata/widgets/biodata_model.dart';
import 'package:get/get.dart';

class BiodataController extends GetxController {
  var biodata = Rx<Biodata?>(null);
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> loadBiodata(String biodataId) async {
    try {
      DocumentSnapshot doc = await _firestore.collection('biodata').doc(biodataId).get();
      if (doc.exists) {
        biodata.value = Biodata.fromMap(doc.data() as Map<String, dynamic>);
      }
    } catch (e) {
      print("Error loading biodata: $e");
    }
  }

  Future<void> saveBiodata(Biodata biodata, String userId, String rentId, {String? biodataId}) async {
    try {
      if (biodataId != null) {
        await _firestore.collection('biodata').doc(biodataId).set(biodata.toMap());
      } else {
        await _firestore.collection('biodata').add(biodata.toMap());
      }
    } catch (e) {
      print("Error saving biodata: $e");
    }
  }

  Future<void> updateBiodata(String biodataId, Biodata updatedBiodata, String userId, String rentId) async {
    try {
      Map<String, dynamic> updatedBiodataMap = updatedBiodata.toMap();
      updatedBiodataMap['userId'] = userId;
      updatedBiodataMap['rentId'] = rentId;

      await _firestore.collection('biodata').doc(biodataId).update(updatedBiodataMap);
      print('Biodata updated successfully');
    } catch (e) {
      print('Error updating biodata: $e');
    }
  }
}
