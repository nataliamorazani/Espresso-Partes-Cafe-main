import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  final LatLng initialLocation;
  final bool isReadOnly;
  final bool onlyMap;
  const MapScreen({
    required this.initialLocation,
    this.isReadOnly = false,
    this.onlyMap = false,
    Key? key,
  }) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng? _pickedPosition;

  void _selectPosition(LatLng position) {
    setState(() {
      _pickedPosition = position;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.onlyMap) {
      return MapContainer(
        pickedPosition: _pickedPosition,
        initialLocation: widget.initialLocation,
        selectPosition: _selectPosition,
        isReadOnly: widget.isReadOnly,
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(!widget.isReadOnly ? 'Selecione...' : "Mapa"),
        actions: [
          if (!widget.isReadOnly)
            IconButton(
              icon: const Icon(Icons.check),
              onPressed: _pickedPosition == null
                  ? null
                  : () {
                      Navigator.of(context).pop(_pickedPosition);
                    },
            ),
        ],
      ),
      body: MapContainer(
        pickedPosition: _pickedPosition,
        initialLocation: widget.initialLocation,
        selectPosition: _selectPosition,
        isReadOnly: widget.isReadOnly,
      ),
    );
  }
}

class MapContainer extends StatelessWidget {
  const MapContainer({
    super.key,
    required this.pickedPosition,
    required this.initialLocation,
    required this.selectPosition,
    required this.isReadOnly,
  });

  final LatLng? pickedPosition;
  final LatLng initialLocation;
  final Function(LatLng) selectPosition;
  final bool isReadOnly;

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: initialLocation,
        zoom: 15,
      ),
      onTap: isReadOnly ? null : selectPosition,
      markers: (pickedPosition == null && !isReadOnly)
          ? {}
          : {
              Marker(
                markerId: const MarkerId('p1'),
                position: pickedPosition ?? initialLocation,
              )
            },
    );
  }
}
