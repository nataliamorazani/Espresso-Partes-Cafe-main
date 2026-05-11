enum ProductType {
  product,
  service,
}

class Product {
  final int id;
  final String name;
  final double price;
  final int stock;
  final ProductType productType;
  final DateTime updatedAt;
  final DateTime createdAt;

  const Product({
    required this.id,
    required this.name,
    required this.price,
    required this.stock,
    required this.productType,
    required this.updatedAt,
    required this.createdAt,
  });
}
