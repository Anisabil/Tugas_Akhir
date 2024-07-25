import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fvapp/admin/models/bank_model.dart';
import 'package:get/get.dart';

class BankController extends GetxController {
  final selectedBankId = ''.obs;
  final banks = <Bank>[].obs;
  var selectedBank = Rxn<Bank>();

  @override
  void onInit() {
    super.onInit();
    fetchBanks();
  }

  void fetchBanks() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('banks').get();
      List<Bank> fetchedBanks = snapshot.docs.map((doc) {
        return Bank.fromFirestore(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
      print('Fetched banks: ${fetchedBanks.map((b) => b.bankName).toList()}');
      banks.value = fetchedBanks;
    } catch (e) {
      print("Error fetching banks: $e");
    }
  }

  void addBank(Bank bank) async {
    try {
      DocumentReference docRef = await FirebaseFirestore.instance.collection('banks').add(bank.toMap());
      bank.id = docRef.id;
      banks.add(bank);
    } catch (e) {
      print("Error adding bank: $e");
    }
  }

  void updateBank(Bank bank) async {
    try {
      await FirebaseFirestore.instance.collection('banks').doc(bank.id).update(bank.toMap());
      int index = banks.indexWhere((b) => b.id == bank.id);
      if (index != -1) {
        banks[index] = bank;
      }
    } catch (e) {
      print("Error updating bank: $e");
    }
  }

  void deleteBank(String id) async {
    try {
      await FirebaseFirestore.instance.collection('banks').doc(id).delete();
      banks.removeWhere((bank) => bank.id == id);
      if (selectedBankId.value == id) {
        selectedBankId.value = '';  // Deselect if the deleted bank was selected
        selectedBank.value = null;  // Clear selected bank
      }
    } catch (e) {
      print("Error deleting bank: $e");
    }
  }

  void updateSelectedBank(String bankId) {
    selectedBankId.value = bankId;
    selectedBank.value = banks.firstWhereOrNull((bank) => bank.id == bankId);
  }

  Bank? getSelectedBank() {
    return selectedBank.value;
  }
}
