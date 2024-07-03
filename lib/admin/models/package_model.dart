class Package {
  final String id;
  final String name;
  final String description;
  final double price;
  final String categoryId;
  String categoryName;
  final List<String> imageUrls;
  final List<String> videoUrls; // List of video URLs

  Package({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.categoryId,
    required this.imageUrls,
    required this.videoUrls,
    this.categoryName = '',
  });

  factory Package.fromJson(Map<String, dynamic> json) {
    return Package(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price: json['price']?.toDouble() ?? 0.0,
      categoryId: json['categoryId'] ?? '',
      imageUrls: List<String>.from(json['imageUrls'] ?? []),
      videoUrls: List<String>.from(json['videoUrls'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'categoryId': categoryId,
      'imageUrls': imageUrls,
      'videoUrls': videoUrls,
    };
  }
}
