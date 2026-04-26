class ProductModel {
  final int id;
  final String name;
  final double price;
  final String? imageUrl;
  final String? description;
  final String? category;

  const ProductModel({
    required this.id,
    required this.name,
    required this.price,
    this.imageUrl,
    this.description,
    this.category,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
    id:          json['ID'] ?? json['id'],        // ← pakai ID huruf besar
    name:        json['name'] ?? '',
    price:       (json['price'] as num).toDouble(),
    imageUrl:    json['image_url'],
    description: json['description'],
    category:    json['category'],
  );
}