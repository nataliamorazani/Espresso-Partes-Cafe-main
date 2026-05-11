import 'package:espresso_partes_cafe/models/chart_data.dart';
import 'package:espresso_partes_cafe/models/product.dart';
import 'package:espresso_partes_cafe/models/product_to_sell_edited.dart';
import 'package:espresso_partes_cafe/models/sell.dart';
import 'package:espresso_partes_cafe/utils/db_tables_util.dart';
import 'package:espresso_partes_cafe/utils/db_util.dart';
import 'package:espresso_partes_cafe/utils/formater_util.dart';
import 'package:flutter/foundation.dart';

const table = DbTablesUtils.sales;
const tableProductsSell = DbTablesUtils.productsSell;
DateTime now = DateTime.now();
DateTime midMonthNow = DateTime(now.year, now.month, 15);

class DbSalesService with ChangeNotifier {
  DbSalesService() {
    loadData();
    loadChartData();
  }

  int _selectedMonth = 0; //0 é o mes
  DateTime _pikedDate = DateTime.now();

  final List<Sell> _sales = [];

  final Map<int, ChartData> _chartData = {
    0: ChartData(
        date: FormaterUtil.subtractMonthsFromDate(midMonthNow, 0), total: 0),
    1: ChartData(
        date: FormaterUtil.subtractMonthsFromDate(midMonthNow, 1), total: 0),
    2: ChartData(
        date: FormaterUtil.subtractMonthsFromDate(midMonthNow, 2), total: 0),
    3: ChartData(
        date: FormaterUtil.subtractMonthsFromDate(midMonthNow, 3), total: 0),
    4: ChartData(
        date: FormaterUtil.subtractMonthsFromDate(midMonthNow, 4), total: 0),
    5: ChartData(
        date: FormaterUtil.subtractMonthsFromDate(midMonthNow, 5), total: 0),
    6: ChartData(
        date: FormaterUtil.subtractMonthsFromDate(midMonthNow, 6), total: 0),
    7: ChartData(
        date: FormaterUtil.subtractMonthsFromDate(midMonthNow, 7), total: 0),
    8: ChartData(
        date: FormaterUtil.subtractMonthsFromDate(midMonthNow, 8), total: 0),
    9: ChartData(
        date: FormaterUtil.subtractMonthsFromDate(midMonthNow, 9), total: 0),
    10: ChartData(
        date: FormaterUtil.subtractMonthsFromDate(midMonthNow, 10), total: 0),
    11: ChartData(
        date: FormaterUtil.subtractMonthsFromDate(midMonthNow, 11), total: 0),
  };

  Map<int, ChartData> get chartData {
    return {..._chartData};
  }

  DateTime get picketDate {
    return DateTime.parse(_pikedDate.toIso8601String());
  }

  int get selectedMonth {
    return _selectedMonth;
  }

  List<Sell> get sales {
    return [..._sales];
  }

  Future<Sell?> getById(int id) async {
    try {
      Map<String, dynamic>? storageData =
          await DbUtil.getOne(table, whereArgs: [id]);
      if (storageData == null) {
        throw "Venda não encontrada";
      }

      final sell = await mapToSell(storageData);
      return sell;
    } catch (error) {
      return null;
    }
  }

  Future<List<Sell>> getByCustomerId(int id) async {
    try {
      List<Map<String, dynamic>> storageData = await DbUtil.getDataWhere(table,
          where: "customer_id = ?", whereArgs: [id]);

      final sell = await toListSell(storageData);
      return sell;
    } catch (error) {
      return [];
    }
  }

  Future<void> deleteById(int id) async {
    try {
      await DbUtil.delete(
        table,
        where: "id = ?",
        whereArgs: [id],
      );
      await DbUtil.delete(
        tableProductsSell,
        where: "sell_id = ?",
        whereArgs: [id],
      );
      loadData();
    } catch (error) {
      throw "Não foi possivel deletar venda";
    }
  }

  Future<void> deleteProductSellById(int id) async {
    try {
      await DbUtil.delete(
        tableProductsSell,
        where: "id = ?",
        whereArgs: [id],
      );
      await loadData();
    } catch (error) {
      throw "Não foi possivel deletar";
    }
  }

  List<Sell> search(String text) {
    return sales
        .where((element) =>
            element.customerName.toLowerCase().contains(text.toLowerCase()) ||
            element.id.toString().contains(text.toLowerCase()))
        .toList();
  }

  Future<void> updatePickedDate(DateTime pikedDate, int selectedMonth) async {
    _pikedDate = pikedDate;
    _selectedMonth = selectedMonth;
    await loadData();
  }

  Future<void> loadData() async {
    List<Map<String, dynamic>> storageData =
        await DbUtil.getDataByMonthAndYear(table, _pikedDate);

    List<Sell> loadeData = await toListSell(storageData);
    _sales.clear();
    _sales.addAll(loadeData);
    await loadChartData();
    notifyListeners();
  }

  Future<void> loadChartData() async {
    _chartData.forEach((key, value) async {
      List<Map<String, dynamic>> storageData =
          await DbUtil.getDataByMonthAndYear(table, value.date);

      List<Sell> loadeData = await toListSell(storageData);
      value.total = calculateTotalPriceInMonth(loadeData);
    });
  }

  double calculateTotalPriceInMonth(List<Sell> sales) {
    double value = 0;
    for (final Sell sell in sales) {
      for (final ProductToSell product in sell.products) {
        value += (product.total - sell.discount);
      }
    }
    return value;
  }

  Future<int> addOrUpdate({
    int? id,
    required int customerId,
    required String customerName,
    required double discount,
    required int amount,
    required double totalPrice,
    required int paymentType,
    required int paymentStatus,
    required List<ProductToSell> products,
    required DateTime sellDate,
    required String observation,
    required String pixDestination,
    required String pixKey,
    required PaymentMode paymentMode,
    required String paymentMethod,
    required String paymentAbould,
    required DateTime paymentDate,
  }) async {
    int? sellId = id;
    try {
      final data = {
        "id": id,
        "customer_id": customerId,
        "customer_name": customerName,
        "discount": discount,
        "amount": amount,
        "total_price": totalPrice,
        "payment_type": paymentType,
        "payment_status": paymentStatus,
        "sell_date": sellDate.toIso8601String(),
        "observation": observation,
        "pix_destination": pixDestination,
        "pix_key": pixKey,
        "payment_mode": paymentMode.index,
        "payment_method": paymentMethod,
        "payment_abould": paymentAbould,
        "updatedAt": paymentDate.toIso8601String(),
      };

      if (id != null) {
        await DbUtil.update(
          table,
          data,
          whereArgs: [id],
        );
      } else {
        data["createdAt"] = DateTime.now().toIso8601String();
        sellId = await DbUtil.insert(table, data);
      }

      for (final ProductToSell product in products) {
        if (product.id == null && sellId != null) {
          final productsMap = {
            "id": product.id,
            "product_id": product.productId,
            "sell_id": sellId,
            "name": product.name,
            "price": product.price,
            "amount": product.amount,
            "product_type": product.productType.index,
            "createdAt": DateTime.now().toIso8601String(),
          };
          await DbUtil.insert(tableProductsSell, productsMap);
        }
      }
      loadData();
      return sellId!;
    } catch (error) {
      throw "Erro ao salvar";
    }
  }

  Future<void> updatePaymentStatus({
    required int id,
    required int paymentStatus,
  }) async {
    try {
      final data = {
        "payment_status": paymentStatus,
        "updatedAt": DateTime.now().toIso8601String(),
      };

      await DbUtil.update(
        table,
        data,
        whereArgs: [id],
      );

      await DbUtil.insert(DbTablesUtils.sellPaymentDate, {
        "id": null,
        "sell_id": id,
        "installment_number": paymentStatus,
        "createdAt": DateTime.now().toIso8601String(),
      });

      loadData();
    } catch (error) {
      throw "Erro ao salvar status";
    }
  }

  Future<List<Sell>> toListSell(List<Map<String, dynamic>> storageData) async {
    final List<Sell> loadeData = [];

    for (final value in storageData) {
      final sell = await mapToSell(value);
      loadeData.add(sell);
    }
    return loadeData;
  }

  Future<Sell> mapToSell(Map<String, dynamic> value) async {
    final List<Map<String, dynamic>> storageDataProductsSell =
        await DbUtil.getDataWhere(
      tableProductsSell,
      where: "sell_id = ?",
      whereArgs: [value["id"]],
    );

    final installmentPaymentDate = await DbUtil.getDataWhere(
      DbTablesUtils.sellPaymentDate,
      where: "sell_id = ?",
      whereArgs: [value["id"]],
    );

    final Sell loadeData = Sell(
      id: value["id"],
      installmentPaymentDate: installmentPaymentDate
          .map(
            (val) => InstallmentPaymentDate(
              id: val['id'],
              createdAt: DateTime.parse(val["createdAt"]),
              installmentNumber: val["installment_number"],
            ),
          )
          .toList(),
      products: storageDataProductsSell
          .map(
            (val) => ProductToSell(
              id: val["id"],
              productId: val["product_id"],
              sellId: val["sell_id"],
              name: val["name"],
              price: val["price"],
              amount: val["amount"],
              productType: ProductType.values[val["product_type"]],
              createdAt: DateTime.parse(val["createdAt"]),
            ),
          )
          .toList(),
      customerId: value["customer_id"],
      customerName: value["customer_name"],
      discount: value["discount"],
      amount: value["amount"],
      totalPrice: value["total_price"],
      paymentType: value["payment_type"],
      paymentStatus: value["payment_status"],
      sellDate: DateTime.parse(value["sell_date"]),
      observation: value["observation"],
      pixDestination: value["pix_destination"],
      pixKey: value["pix_key"],
      paymentMode: PaymentMode.values[value["payment_mode"]],
      paymentMethod: value["payment_method"],
      paymentAbould: value["payment_abould"],
      paymentDate: DateTime.parse(value["updatedAt"]),
      createdAt: DateTime.parse(value["createdAt"]),
    );

    return loadeData;
  }
}
