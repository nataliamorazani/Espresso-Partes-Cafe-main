import 'package:espresso_partes_cafe/models/address_data.dart';

class Customer {
  final int id;
  final String name;
  final String email;
  final String phone;
  final String cpf;
  final String cnpj;
  final String rg;
  final String stateRegistration;
  final String im;
  final DateTime? birth;
  final String requester;
  final AddressData addressData;
  final bool isJuridic;
  final DateTime updatedAt;
  final DateTime createdAt;

  const Customer({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.cpf,
    required this.cnpj,
    required this.rg,
    required this.stateRegistration,
    required this.im,
    required this.birth,
    required this.requester,
    required this.addressData,
    required this.isJuridic,
    required this.updatedAt,
    required this.createdAt,
  });

  String get addressString {
    String address = "";
    if (addressData.street != "") {
      address +=
          "${addressData.street}, ${addressData.number ?? 'SN'} - ${addressData.complement} \n";
    }
    if (addressData.neighborhood != "") {
      address += "${addressData.neighborhood},";
    }
    if (addressData.street != "") {
      address += " ${addressData.city} - ${addressData.state.toUpperCase()}";
    }
    if (addressData.zipCode != "") {
      address += "\nCEP: ${addressData.zipCode}";
    }

    return address;
  }

  String get addressStringPdf {
    String address = "";
    if (addressData.street != "") {
      address += "${addressData.street}, ${addressData.number ?? 'SN'}";
    }
    if (addressData.complement != "") {
      address += " - ${addressData.complement}";
    }
    if (addressData.neighborhood != "") {
      address += " - ${addressData.neighborhood}";
    }
    if (addressData.street != "") {
      address += " - ${addressData.city} - ${addressData.state.toUpperCase()}";
    }
    if (addressData.zipCode != "") {
      address += " - CEP: ${addressData.zipCode}";
    }

    return address;
  }
}
