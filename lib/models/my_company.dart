import 'package:espresso_partes_cafe/models/address_data.dart';

class MyCompany {
  final int? id;
  final String username;
  final String companyName;
  final String phone;
  final String email;
  final String cnpj;
  final String cpf;
  final AddressData address;
  final String pixDestination;
  final String pixKey;
  final DateTime updatedAt;
  final String createdAt; //LOGO

  const MyCompany({
    this.id,
    required this.username,
    required this.companyName,
    required this.phone,
    required this.email,
    required this.cnpj,
    required this.cpf,
    required this.address,
    required this.pixDestination,
    required this.pixKey,
    required this.updatedAt,
    required this.createdAt,
  });

  copy() {
    return MyCompany(
      id: id,
      username: username,
      companyName: companyName,
      phone: phone,
      email: email,
      cnpj: cnpj,
      cpf: cpf,
      address: address,
      pixDestination: pixDestination,
      pixKey: pixKey,
      updatedAt: updatedAt,
      createdAt: createdAt,
    );
  }

  String get addressString {
    String string = "";

    string +=
        "${address.street}, ${address.number ?? 'SN'} - ${address.complement} - ${address.neighborhood} - ${address.city} - ${address.state.toUpperCase()} - CEP: ${address.zipCode}";

    return string;
  }

  // "JOAQUIM PIRES DE OLIVEIRA, 221 - CASA - CENTRO - Jundiaí - SP - CEP: 13201-847"
}
