import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:parking/presentation/widgets/map.dart'; // <-- Import reusable widget

class SearchParkingMapPage extends StatefulWidget {
  const SearchParkingMapPage({Key? key}) : super(key: key);

  @override
  State<SearchParkingMapPage> createState() => _SearchParkingMapPageState();
}

class _SearchParkingMapPageState extends State<SearchParkingMapPage> {
  final Set<Marker> _markers = {};
  LatLng? _userLocation;
  late GoogleMapController _controller;
  bool _isLoading = false;

  final String apiKey = 'AIzaSyDtow7fcdA7ZiSnjH2TShAy4vLFZrELlQY'; // replace with real key

  void _onLocationReady(LatLng location) {
    setState(() {
      _userLocation = location;
    });
    _searchParkingNearby();
  }

  Future<void> _searchParkingNearby() async {
    if (_userLocation == null) return;

    setState(() {
      _isLoading = true;
      _markers.clear();
    });

    int radius = 5000;
    bool found = false;

    while (!found && radius <= 10000) {
      final url =
          'https://maps.googleapis.com/maps/api/place/nearbysearch/json?'
          'location=${_userLocation!.latitude},${_userLocation!.longitude}'
          '&radius=$radius&type=parking&key=$apiKey';

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final results = data['results'] as List;

        if (results.isNotEmpty) {
          setState(() {
            _markers.addAll(results.map((place) {
              final lat = place['geometry']['location']['lat'];
              final lng = place['geometry']['location']['lng'];
              return Marker(
                markerId: MarkerId(place['place_id']),
                position: LatLng(lat, lng),
                infoWindow: InfoWindow(title: place['name']),
              );
            }));
            _isLoading = false;
          });
          found = true;
        } else {
          radius += 1000;
        }
      } else {
        setState(() {
          _isLoading = false;
        });
        throw Exception('Failed to load parking data');
      }
    }

    if (!found) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No parking found within 10km')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          UserLocationMap(
            markers: _markers,
            onLocationReady: _onLocationReady,
            onMapCreated: (controller) {
              _controller = controller;
            },
          ),
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(strokeWidth: 4),
            ),
          Positioned(
            top: 40,
            left: 20,
            child: ElevatedButton(
              onPressed: _searchParkingNearby,
              child: const Text("Search Again"),
            ),
          ),
        ],
      ),
    );
  }
}