import 'package:espresso_partes_cafe/models/address_data.dart';
import 'package:espresso_partes_cafe/models/customer.dart';
import 'package:espresso_partes_cafe/utils/db_tables_util.dart';
import 'package:espresso_partes_cafe/utils/db_util.dart';
import 'package:flutter/foundation.dart';

const table = DbTablesUtils.customers;

class DbCustomerService with ChangeNotifier {
  DbCustomerService() {
    loadData();
  }

  final List<Customer> _customers = [];

  List<Customer> get customers {
    return [..._customers];
  }

  Customer? getById(int id) {
    try {
      return customers.singleWhere((element) => element.id == id);
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

  List<Customer> search(String text) {
    return customers
        .where((element) =>
            element.name.toLowerCase().contains(text.toLowerCase()) ||
            element.requester.toLowerCase().contains(text.toLowerCase()))
        .toList();
  }

  Future<void> loadData() async {
    _customers.clear();
    List<Map<String, dynamic>> storageData = await DbUtil.getData(table);
    final List<Customer> loadeData = storageData
        .map((value) => Customer(
              id: value["id"],
              name: value["name"],
              email: value["email"] ?? "",
              phone: value["phone"] ?? "",
              cpf: value["cpf"] ?? "",
              cnpj: value["cnpj"] ?? "",
              rg: value["rg"] ?? "",
              stateRegistration: value["state_registration"],
              im: value["im"],
              birth: DateTime.tryParse(value['birth'].toString()),
              requester: value["requester"] ?? "",
              isJuridic: value["is_juridic"] == 1,
              addressData: AddressData(
                street: value["street"] ?? "",
                number: value["number"],
                city: value["city"] ?? "",
                state: value["state"] ?? "",
                complement: value["complement"] ?? "",
                zipCode: value["zip_code"] ?? "",
                neighborhood: value["neighborhood"] ?? "",
                latitude: double.tryParse(value["latitude"].toString()),
                longitude: double.tryParse(value["longitude"].toString()),
              ),
              updatedAt: DateTime.parse(value["updatedAt"]),
              createdAt: DateTime.parse(value["createdAt"]),
            ))
        .toList();
    final List<Customer> data = loadeData;
    _customers.addAll(data);
    notifyListeners();
  }

  Future<void> addOrUpdate({
    int? id,
    required String name,
    required String email,
    required String phone,
    required String cpf,
    required String cnpj,
    required String rg,
    required String stateRegistration,
    required String im,
    required DateTime? birth,
    required String requester,
    required String street,
    required int? number,
    required String city,
    required String state,
    required String complement,
    required String zipCode,
    required String neighborhood,
    required bool isJuridic,
    required double? longitude,
    required double? latitude,
  }) async {
    try {
      final data = {
        "id": id,
        "name": name,
        "email": email,
        "phone": phone,
        "cpf": cpf,
        "cnpj": cnpj,
        "rg": rg,
        "state_registration": stateRegistration,
        "im": im,
        "birth": birth?.toIso8601String(),
        "requester": requester,
        "street": street,
        "number": number,
        "city": city,
        "state": state,
        "complement": complement,
        "zip_code": zipCode,
        "neighborhood": neighborhood,
        "longitude": longitude,
        "is_juridic": isJuridic ? 1 : 0,
        "latitude": latitude,
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
}
