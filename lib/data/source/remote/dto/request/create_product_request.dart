import 'dart:io';

class CreateProductRequest {
  final String name;
  final String description;
  final double price;
  final String gender;
  final String category;
  final List<File> images;

  CreateProductRequest({
    required this.name,
    required this.description,
    required this.price,
    required this.gender,
    required this.category,
    required this.images,
  });
  
}