import 'package:espresso_partes_cafe/models/my_company.dart';
import 'package:espresso_partes_cafe/models/address_data.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

MyCompany defoultCompanyData = MyCompany(
  username: "",
  companyName: "",
  phone: "",
  email: "",
  cnpj: "",
  cpf: "",
  createdAt: "",
  updatedAt: DateTime.now(),
  address: const AddressData(
    street: "",
    city: "",
    state: "",
    complement: "",
    zipCode: "",
    neighborhood: "",
  ),
  pixDestination: "",
  pixKey: "",
);

const LatLng defoultLatLng = LatLng(-23.181714, -46.895310);
