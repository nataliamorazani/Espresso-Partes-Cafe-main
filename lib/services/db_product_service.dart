import 'package:espresso_partes_cafe/models/product.dart';
import 'package:espresso_partes_cafe/utils/db_tables_util.dart';
import 'package:espresso_partes_cafe/utils/db_util.dart';
import 'package:flutter/foundation.dart';

const table = DbTablesUtils.products;

class DbProductService with ChangeNotifier {
  DbProductService() {
    loadData();
  }

  final List<Product> _products = [];

  List<Product> get products {
    return [..._products];
  }

  Product? getById(int id) {
    try {
      return products.singleWhere((element) => element.id == id);
    } catch (error) {
      return null;
    }
  }

  Future<void> deleteById(int id) async {
    try {
      await DbUtil.delete(
        table,
        where: "id = ?",
        whereArgs: [id],
      );
      loadData();
    } catch (error) {
      throw "Não foi possivel deletar cliente";
    }
  }

  List<Product> search(String text) {
    return products
        .where((element) =>
            element.name.toLowerCase().contains(text.toLowerCase()))
        .toList();
  }

  Future<void> loadData() async {
    _products.clear();
    List<Map<String, dynamic>> storageData = await DbUtil.getData(table);
    final List<Product> loadeData = storageData
        .map((value) => Product(
              id: value["id"],
              name: value["name"],
              price: value["price"],
              stock: value["stock"],
              productType: ProductType.values[value["product_type"]],
              updatedAt: DateTime.parse(value["updatedAt"]),
              createdAt: DateTime.parse(value["createdAt"]),
            ))
        .toList();
    final List<Product> data = loadeData;
    _products.addAll(data);
    notifyListeners();
  }

  Future<void> addOrUpdate({
    int? id,
    required String name,
    required double price,
    required int stock,
    required int productType,
    required double? longitude,
    required double? latitude,
  }) async {
    try {
      final data = {
        "id": id,
        "name": name,
        "price": price,
        "stock": stock,
        "product_type": productType,
        "updatedAt": DateTime.now().toIso8601String(),
      };
      if (id != null) {
        await DbUtil.update(
          table,
          data,
          whereArgs: [id],
        );
      } else {
        data["createdAt"] = DateTime.now().toIso8601String();
        await DbUtil.insert(table, data);
      }
      loadData();
    } catch (error) {
      throw "Erro ao salvar";
    }
  }

  Future<void> updateAmountProduct({
    required int productId,
    required int amount,
    bool plus = false,
  }) async {
    try {
      final product = getById(productId);
      if (product == null) {
        return;
      }

      final int newValue =
          plus ? product.stock + amount : product.stock - amount;
      final data = {
        "stock": newValue < 0 ? 0 : newValue,
        "updatedAt": DateTime.now().toIso8601String(),
      };

      await DbUtil.update(
        table,
        data,
        where: "",
        whereArgs: [product.id],
      );
    } catch (error) {
      throw "Erro ao salvar status";
    }
  }
}
