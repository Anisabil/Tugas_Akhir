class Rent {
  final String id;
  final String userId;
  final String packageId;
  final double totalPrice;
  final double downPayment;
  final double remainingPayment;
  final DateTime date;
  final String theme;
  final String paymentMethod;
  final String description;
  final String status;

  Rent({
    required this.id,
    required this.userId,
    required this.packageId,
    required this.totalPrice,
    required this.downPayment,
    required this.remainingPayment,
    required this.date,
    required this.theme,
    required this.paymentMethod,
    required this.description,
    this.status = 'belum bayar',
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'packageId': packageId,
      'totalPrice': totalPrice,
      'downPayment': downPayment,
      'remainingPayment': remainingPayment,
      'date': date.toIso8601String(),
      'theme': theme,
      'paymentMethod': paymentMethod,
      'description': description,
      'status': status,
    };
  }

  factory Rent.fromMap(Map<String, dynamic> map) {
    return Rent(
      id: map['id'],
      userId: map['userId'],
      packageId: map['packageId'],
      totalPrice: map['totalPrice'],
      downPayment: map['downPayment'],
      remainingPayment: map['remainingPayment'],
      date: DateTime.parse(map['date']),
      theme: map['theme'],
      paymentMethod: map['paymentMethod'],
      description: map['description'],
      status: map['status'],
    );
  }
}
