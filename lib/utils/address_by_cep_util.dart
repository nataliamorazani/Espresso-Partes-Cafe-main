import 'dart:convert';
import 'package:http/http.dart' as http;

class AddressByCep {
  final String street;
  final String neighborhood;
  final String city;
  final String state;

  AddressByCep({
    required this.street,
    required this.neighborhood,
    required this.city,
    required this.state,
  });
}

class AddressByCepUtil {
  static Future<AddressByCep?> getAddressFromCEP(String cep) async {
    final url = Uri.parse('https://viacep.com.br/ws/$cep/json/');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['erro'] == null) {
        return AddressByCep(
          street: data['logradouro'] ?? "",
          neighborhood: data['bairro'] ?? "",
          city: data['localidade'] ?? "",
          state: data['uf'] ?? "",
        );
      }
    }

    return null;
  }
}
