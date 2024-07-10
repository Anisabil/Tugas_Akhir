import 'package:cloud_firestore/cloud_firestore.dart';

class Package {
  String id;
  String name;
  String description;
  double price;
  String categoryId;
  String categoryName;
  List<String> imageUrls;
  List<String> videoUrls;

  Package({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.categoryId,
    required this.categoryName,
    required this.imageUrls,
    required this.videoUrls,
  });

  factory Package.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;

    return Package(
      id: doc.id,
      name: data?['name'] ?? '',
      description: data?['description'] ?? '',
      price: (data?['price'] as num?)?.toDouble() ?? 0.0,
      categoryId: data?['categoryId'] ?? '',
      categoryName: data?['categoryName'] ?? '',
      imageUrls: List<String>.from(data?['imageUrls'] ?? []),
      videoUrls: List<String>.from(data?['videoUrls'] ?? []),
    );
  }

  factory Package.fromJson(Map<String, dynamic> json) {
    return Package(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      price: json['price'],
      categoryId: json['categoryId'],
      categoryName: json['categoryName'],
      imageUrls: List<String>.from(json['imageUrls']),
      videoUrls: List<String>.from(json['videoUrls']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'categoryId': categoryId,
      'categoryName': categoryName,
      'imageUrls': imageUrls,
      'videoUrls': videoUrls,
    };
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'categoryId': categoryId,
      'categoryName': categoryName,
      'imageUrls': imageUrls,
      'videoUrls': videoUrls,
    };
  }
}
