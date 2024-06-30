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
  });

  factory Rent.fromMap(Map<String, dynamic> map) {
    return Rent(
      id: map['id'],
      userId: map['userId'],
      packageId: map['packageId'],
      packageName: map['packageName'],
      totalPrice: (map['totalPrice'] is int) ? (map['totalPrice'] as int).toDouble() : map['totalPrice'],
      downPayment: (map['downPayment'] is int) ? (map['downPayment'] as int).toDouble() : map['downPayment'],
      remainingPayment: (map['remainingPayment'] is int) ? (map['remainingPayment'] as int).toDouble() : map['remainingPayment'],
      date: DateTime.parse(map['date']),
      theme: map['theme'],
      paymentMethod: map['paymentMethod'],
      description: map['description'],
      status: map['status'],
      userName: map['userName'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'packageId': packageId,
      'packageName': packageName,
      'totalPrice': totalPrice,
      'downPayment': downPayment,
      'remainingPayment': remainingPayment,
      'date': date.toIso8601String(),
      'theme': theme,
      'paymentMethod': paymentMethod,
      'description': description,
      'status': status,
      'userName': userName,
    };
  }
}
