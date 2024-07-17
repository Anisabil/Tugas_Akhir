import 'package:cloud_firestore/cloud_firestore.dart';

class PromoImage {
  final String id;
  final String imageUrl;

  PromoImage({
    required this.id,
    required this.imageUrl,
  });

  factory PromoImage.fromMap(Map<String, dynamic> map) {
    return PromoImage(
      id: map['id'],
      imageUrl: map['imageUrl'],
    );
  }

  factory PromoImage.fromFirestore(QueryDocumentSnapshot doc) {
    final Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return PromoImage(
      id: doc.id,
      imageUrl: data['imageUrl'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'imageUrl': imageUrl,
    };
  }
}
