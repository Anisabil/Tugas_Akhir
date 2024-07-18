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
  String? biodataId;

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
    this.biodataId,
  });

  factory Rent.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
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
    );
  }

  factory Rent.fromJson(Map<String, dynamic> json) {
    return Rent(
      id: json['id'],
      userId: json['userId'],
      packageId: json['packageId'],
      packageName: json['packageName'],
      totalPrice: (json['totalPrice'] as num).toDouble(),
      downPayment: (json['downPayment'] as num).toDouble(),
      remainingPayment: (json['remainingPayment'] as num).toDouble(),
      date: DateTime.parse(json['date']),
      theme: json['theme'],
      paymentMethod: json['paymentMethod'],
      description: json['description'],
      status: json['status'],
      userName: json['userName'],
      email: json['email'],
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
    };
  }
}
