import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';

class Rent {
  String id;
  String userId;
  String packageId;
  String packageName;
  double totalPrice;
  double downPayment;
  double remainingPayment;
  DateTime date;
  String theme;
  String paymentMethod;
  String description;
  String status;
  String userName;
  String email;
  Uint8List? qrCodeData;

  Rent({
    required this.id,
    required this.userId,
    required this.packageId,
    required this.packageName,
    required this.totalPrice,
    required this.downPayment,
    required this.remainingPayment,
    required this.date,
    required this.theme,
    required this.paymentMethod,
    required this.description,
    required this.status,
    required this.userName,
    required this.email,
    this.qrCodeData,
  });

  factory Rent.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    Map<String, dynamic> data = doc.data()!;
    return Rent(
      id: doc.id,
      userId: data['userId'],
      packageId: data['packageId'],
      packageName: data['packageName'],
      totalPrice: data['totalPrice'],
      downPayment: data['downPayment'],
      remainingPayment: data['remainingPayment'],
      date: (data['date'] as Timestamp).toDate(),
      theme: data['theme'],
      paymentMethod: data['paymentMethod'],
      description: data['description'],
      status: data['status'],
      userName: data['userName'],
      email: data['email'],
      qrCodeData: data['qrCodeData'] != null ? Uint8List.fromList(List<int>.from(data['qrCodeData'])) : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'packageId': packageId,
      'packageName': packageName,
      'totalPrice': totalPrice,
      'downPayment': downPayment,
      'remainingPayment': remainingPayment,
      'date': Timestamp.fromDate(date),
      'theme': theme,
      'paymentMethod': paymentMethod,
      'description': description,
      'status': status,
      'userName': userName,
      'email': email,
      'qrCodeData': qrCodeData != null ? qrCodeData!.toList() : null,
    };
  }
}
