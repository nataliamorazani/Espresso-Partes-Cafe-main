import 'package:google_maps_flutter/google_maps_flutter.dart';

class AddressData {
  final String street;
  final int? number;
  final String city;
  final String state;
  final String complement;
  final String zipCode;
  final String neighborhood;
  final double? longitude;
  final double? latitude;

  const AddressData({
    required this.street,
    this.number,
    required this.city,
    required this.state,
    required this.complement,
    required this.zipCode,
    required this.neighborhood,
    this.longitude,
    this.latitude,
  });

  LatLng toLatLng() {
    return LatLng(latitude ?? 0, longitude ?? 0);
  }
}
