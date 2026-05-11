import 'package:espresso_partes_cafe/components/callback.dart';
import 'package:espresso_partes_cafe/services/db_customer_service.dart';
import 'package:espresso_partes_cafe/utils/defoult_data_util.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import '../screens/map_screen.dart';

class LocationInput extends StatefulWidget {
  final Function(LatLng) onSelectPosition;
  final LatLng? latLngSelected;

  final bool viewOnly;
  const LocationInput(
    this.onSelectPosition, {
    Key? key,
    this.latLngSelected,
    this.viewOnly = false,
  }) : super(key: key);

  @override
  State<LocationInput> createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  LatLng? _latLngSelected;
  bool _loading = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Provider.of<DbCustomerService>(context);
  }

  Future<void> _getCurrentUserLocation(BuildContext context) async {
    setState(() => _loading = true);

    try {
      bool serviceEnabled;
      LocationPermission permission;

      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        // Location services are not enabled don't continue
        // accessing the position and request users of the
        // App to enable the location services.
        throw 'Serviço de localização esta desativado';
      }

      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          // Permissions are denied, next time you could try
          // requesting permissions again (this is also where
          // Android's shouldShowRequestPermissionRationale
          // returned true. According to Android guidelines
          // your App should show an explanatory UI now.
          throw 'Permição para acessar localização foi negada';
        }
      }

      if (permission == LocationPermission.deniedForever) {
        // Permissions are denied forever, handle appropriately.
        throw 'Permição para acessar a localização foi negada, não podemos pedir novamente';
      }

      final locData = await Geolocator.getCurrentPosition();

      final latLang = LatLng(
        locData.latitude,
        locData.longitude,
      );
      widget.onSelectPosition(latLang);
      setState(() {
        _latLngSelected = latLang;
      });
    } catch (e) {
      Callback.snackBar(
        context,
        title: e.toString(),
      );
    } finally {
      setState(() => _loading = false);
    }
  }

  Future<void> _selectOnMap() async {
    setState(() => _loading = true);
    final LatLng? selectedPosition = await Navigator.of(context).push(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (ctx) => MapScreen(
          initialLocation:
              _latLngSelected ?? widget.latLngSelected ?? defoultLatLng,
        ),
      ),
    );

    if (selectedPosition == null) return setState(() => _loading = false);

    widget.onSelectPosition(selectedPosition);

    setState(() {
      _latLngSelected = selectedPosition;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (_loading)
          Container(
            decoration: BoxDecoration(
              border: Border.all(
                width: 1,
                color: Theme.of(context).colorScheme.tertiary.withOpacity(.5),
              ),
            ),
            height: 350,
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          )
        else
          MapImage(
            viewOnly: widget.viewOnly,
            latLngSelected: _latLngSelected ?? widget.latLngSelected,
          ),
        if (!widget.viewOnly)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton.icon(
                icon: const Icon(Icons.location_on),
                label: const Text('Localização atual'),
                onPressed: () => _getCurrentUserLocation(context),
              ),
              TextButton.icon(
                icon: const Icon(Icons.map),
                label: const Text('Selecione no Mapa'),
                onPressed: _selectOnMap,
              ),
            ],
          )
      ],
    );
  }
}

class MapImage extends StatelessWidget {
  const MapImage({
    super.key,
    required this.viewOnly,
    required this.latLngSelected,
  });

  final bool viewOnly;
  final LatLng? latLngSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 350,
      width: double.infinity,
      constraints: const BoxConstraints(maxWidth: 500),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border.all(
          width: 1,
          color: Theme.of(context).colorScheme.tertiary.withOpacity(.5),
        ),
      ),
      child: latLngSelected == null
          ? const Text('Localização não informada!')
          : MapScreen(
              initialLocation: latLngSelected ?? defoultLatLng,
              isReadOnly: true,
              onlyMap: true,
            ),
    );
  }
}
