class Product {
  final String id;
  final String name;
  final String description; 
  final double price;
  final String gender;
  final String imageUrl;
  final String category;
  final String creatorId; 
  final String status;    
  final DateTime createdAt;

  const Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.gender,
    required this.imageUrl,
    required this.category,
    required this.creatorId,
    required this.status,
    required this.createdAt,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    String img = "";
    if (json['productImages'] != null && (json['productImages'] as List).isNotEmpty) {
      img = json['productImages'][0]['imageUrl'];
    } else if (json['imageUrl'] != null) {
      img = json['imageUrl'];
    }

    return Product(
      id: json['id'] ?? json['productId'] ?? '', 
      name: json['name'] ?? 'Unknown',
      description: json['description'] ?? "No description provided",
      price: (json['price'] ?? 0).toDouble(),
      gender: json['forGender'] ?? json['gender'] ?? 'Unisex', 
      imageUrl: img,
      category: json['productCategory'] ?? json['category'] ?? 'Uncategorized',
      creatorId: json['creatorId'] ?? '',
      status: json['status'] ?? 'ACTIVE',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'gender': gender,
      'imageUrl': imageUrl,
      'productCategory': category,
      'creatorId': creatorId,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}