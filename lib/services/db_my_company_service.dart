import 'package:espresso_partes_cafe/models/my_company.dart';
import 'package:espresso_partes_cafe/models/address_data.dart';
import 'package:espresso_partes_cafe/utils/db_tables_util.dart';
import 'package:espresso_partes_cafe/utils/db_util.dart';
import 'package:espresso_partes_cafe/utils/defoult_data_util.dart';
import 'package:flutter/material.dart';

class DbMyCompanyService with ChangeNotifier {
  DbMyCompanyService() {
    loadCompanyData();
  }

  MyCompany _companyData = defoultCompanyData;

  MyCompany get companyData {
    return _companyData.copy();
  }

  Future<void> loadCompanyData() async {
    Map<String, dynamic>? storedData = await DbUtil.getOne(
      DbTablesUtils.myCompany,
      whereArgs: [],
      where: "id",
    );

    if (storedData != null) {
      final company = MyCompany(
        id: storedData["id"],
        username: storedData["username"],
        companyName: storedData["company_name"],
        phone: storedData["phone"],
        email: storedData["email"],
        cnpj: storedData["cnpj"],
        cpf: storedData["cpf"],
        pixDestination: storedData["pix_destination"],
        pixKey: storedData["pix_key"],
        address: AddressData(
          street: storedData["street"],
          number: storedData["number"],
          city: storedData["city"],
          state: storedData["state"],
          complement: storedData["complement"],
          zipCode: storedData["zip_code"],
          neighborhood: storedData["neighborhood"],
        ),
        updatedAt: DateTime.parse(storedData["updatedAt"]),
        createdAt: storedData["createdAt"],
      );
      _companyData = company;
      notifyListeners();
    }
  }

  Future<void> updateCompanyData({
    required String username,
    required String companyName,
    required String phone,
    required String email,
    required String cnpj,
    required String cpf,
    required String street,
    required int? number,
    required String city,
    required String state,
    required String complement,
    required String zipCode,
    required String neighborhood,
    required String pixDestination,
    required String pixKey,
  }) async {
    try {
      final data = {
        "id": _companyData.id,
        "username": username,
        "company_name": companyName,
        "phone": phone,
        "email": email,
        "cnpj": cnpj,
        "cpf": cpf,
        "street": street,
        "number": number,
        "city": city,
        "state": state,
        "complement": complement,
        "zip_code": zipCode,
        "neighborhood": neighborhood,
        "pix_destination": pixDestination,
        "pix_key": pixKey,
        "updatedAt": DateTime.now().toIso8601String(),
      };
      if (_companyData.id != null) {
        await DbUtil.update(
          DbTablesUtils.myCompany,
          data,
          whereArgs: [_companyData.id],
        );
      } else {
        data["createdAt"] = "";
        await DbUtil.insert(DbTablesUtils.myCompany, data);
      }
      loadCompanyData();
    } catch (error) {
      throw "Erro ao salvar";
    }
  }

  Future<void> updateCompanyLogo(filePath) async {
    final data = {"createdAt": filePath};
    if (_companyData.id != null) {
      await DbUtil.update(
        DbTablesUtils.myCompany,
        data,
        whereArgs: [_companyData.id],
      );
    } else {
      final data = {
        "id": _companyData.id,
        "username": "",
        "company_name": "",
        "phone": "",
        "email": "",
        "cnpj": "",
        "cpf": "",
        "street": "",
        "number": 0,
        "city": "",
        "state": "",
        "complement": "",
        "zip_code": "",
        "neighborhood": "",
        "pix_destination": "",
        "pix_key": "",
        "updatedAt": DateTime.now().toIso8601String(),
        "createdAt": filePath,
      };
      await DbUtil.insert(DbTablesUtils.myCompany, data);
    }
  }
}

// List<Map<String, dynamic>> results = await db.query(
//   'sales',
//   where: 'strftime("%m", sale_date) = ? AND strftime("%Y", sale_date) = ?',
//   whereArgs: ['${month.toString().padLeft(2, '0')}', year.toString()],
// );
