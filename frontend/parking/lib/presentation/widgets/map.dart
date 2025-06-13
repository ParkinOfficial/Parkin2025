import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class UserLocationMap extends StatefulWidget {
  final Set<Marker> markers;
  final Function(LatLng)? onLocationReady;
  final Function(GoogleMapController)? onMapCreated;

  const UserLocationMap({
    Key? key,
    required this.markers,
    this.onLocationReady,
    this.onMapCreated,
  }) : super(key: key);

  @override
  State<UserLocationMap> createState() => _UserLocationMapState();
}

class _UserLocationMapState extends State<UserLocationMap> {
  LatLng? _currentLocation;
  GoogleMapController? _controller;
  String? _mapStyle;

  @override
  void initState() {
    super.initState();
    _loadMapStyle();
    _getLocation();
  }

  Future<void> _loadMapStyle() async {
    _mapStyle = await rootBundle.loadString('assets/map_style.json');
    if (_controller != null && _mapStyle != null) {
      _controller!.setMapStyle(_mapStyle);
    }
  }

  Future<void> _getLocation() async {
    try {
      Location location = Location();

      bool serviceEnabled = await location.serviceEnabled();
      if (!serviceEnabled) serviceEnabled = await location.requestService();

      PermissionStatus permissionGranted = await location.hasPermission();
      if (permissionGranted == PermissionStatus.denied) {
        permissionGranted = await location.requestPermission();
      }

      if (permissionGranted == PermissionStatus.granted) {
        LocationData locData = await location.getLocation();
        LatLng position = LatLng(locData.latitude!, locData.longitude!);
        setState(() {
          _currentLocation = position;
        });

        widget.onLocationReady?.call(position);
      }
    } catch (e) {
      debugPrint('Error getting location: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_currentLocation == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return GoogleMap(
      onMapCreated: (controller) {
        _controller = controller;
        if (_mapStyle != null) {
          controller.setMapStyle(_mapStyle);
        }
        widget.onMapCreated?.call(controller);
      },
      initialCameraPosition: CameraPosition(
        target: _currentLocation!,
        zoom: 14,
      ),
      myLocationEnabled: true,
      myLocationButtonEnabled: true,
      markers: widget.markers,
    );
  }
}
