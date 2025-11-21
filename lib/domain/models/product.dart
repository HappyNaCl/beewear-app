class Product {
  final String productId;
  final String name;
  final double price;
  final String gender;
  final String? imageUrl;
  final String category;
  final DateTime createdAt;

  const Product({
    required this.productId,
    required this.name,
    required this.price,
    required this.gender,
    this.imageUrl,
    required this.category,
    required this.createdAt,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      productId: json['id'],
      name: json['name'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      gender: json['gender'] ?? '',
      imageUrl: json['imageUrl'],
      category: json['category'] ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'name': name,
      'price': price,
      'gender': gender,
      'imageUrl': imageUrl,
      'category': category,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  Product copyWith({
    String? productId,
    String? name,
    String? description,
    double? price,
    String? imageUrl,
    String? category,
    String? brand,
    int? stock,
    DateTime? createdAt,
    String? gender,
  }) {
    return Product(
      productId: productId ?? this.productId,
      name: name ?? this.name,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
      category: category ?? this.category,
      createdAt: createdAt ?? this.createdAt,
      gender: gender ?? this.gender,
    );
  }
}
