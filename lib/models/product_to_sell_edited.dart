import 'package:espresso_partes_cafe/models/product.dart';

class ProductToSell {
  final int? id;
  final int productId;
  final int? sellId;
  String name;
  double price;
  int amount;
  final ProductType productType;
  final DateTime createdAt;

  ProductToSell({
    this.id,
    this.sellId,
    required this.productId,
    required this.name,
    required this.price,
    required this.amount,
    required this.productType,
    required this.createdAt,
  });

  double get total {
    return price * amount;
  }
}
