import 'package:cloud_firestore/cloud_firestore.dart';

class Bank {
  String id;
  String bankName;
  String accountNumber;
  String accountName;

  Bank({
    required this.id,
    required this.bankName,
    required this.accountNumber,
    required this.accountName,
  });

  factory Bank.fromFirestore(Map<String, dynamic> data, String id) {
    return Bank(
      id: id,
      bankName: data['bankName'] ?? '',
      accountNumber: data['accountNumber'] ?? '',
      accountName: data['accountName'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'bankName': bankName,
      'accountNumber': accountNumber,
      'accountName': accountName,
    };
  }
}
